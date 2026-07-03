import 'package:drift/drift.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../domain/ports/notification_port.dart';
import '../../domain/ports/weather_port.dart';
import '../../domain/services/cadence_engine.dart';
import '../../domain/services/reconciler.dart';
import '../../infra/notifications/reminder_applier.dart';
import '../db/database.dart';
import 'occurrence_builder.dart';

/// Orchestrates one reconcile pass: build the desired occurrences, diff them against
/// the OS registry, apply the delta to the [NotificationPort], and persist the new
/// registry — the single entry point every reconcile trigger (app start, care log,
/// snooze, workmanager tick, boot) funnels through.
///
/// Constructible from just `(AppDatabase, NotificationPort)` so the background isolate
/// can build one from scratch without any Riverpod/UI state.
class ReconcileCoordinator {
  ReconcileCoordinator({
    required AppDatabase db,
    required NotificationPort port,
    CadenceEngine engine = const CadenceEngine(),
    Reconciler reconciler = const Reconciler(),
    WeatherPort? weather,
  })  : _db = db,
        _reconciler = reconciler,
        _applier = ReminderApplier(port),
        _builder = OccurrenceBuilder(db, engine, weather: weather);

  final AppDatabase _db;
  final Reconciler _reconciler;
  final ReminderApplier _applier;
  final OccurrenceBuilder _builder;

  /// Run a reconcile as of [now] (defaults to the current instant in the local zone).
  Future<void> reconcile([tz.TZDateTime? now]) async {
    final at = now ?? tz.TZDateTime.now(tz.local);

    final desired = await _builder.build(at);
    await _cacheNextDue(desired);

    final current = await _readRegistry();
    final plan = _reconciler.reconcile(desired: desired, current: current);

    await _applier.apply(plan);
    await _persistRegistry(plan);
  }

  /// Write each schedule's next-due instant back to its row so the UI can render a
  /// "Today / Upcoming" queue without recomputing. Covers ALL active schedules (not
  /// just the windowed subset that got OS notifications).
  Future<void> _cacheNextDue(List<DesiredOccurrence> desired) async {
    await _db.transaction(() async {
      for (final occurrence in desired) {
        await (_db.update(_db.careSchedules)
              ..where((s) => s.id.equals(occurrence.scheduleId)))
            .write(CareSchedulesCompanion(nextDueAt: Value(occurrence.firesAt)));
      }
    });
  }

  Future<List<RegisteredNotification>> _readRegistry() async {
    final rows = await _db.select(_db.notificationRegistryRows).get();
    return [
      for (final r in rows)
        RegisteredNotification(
          osId: r.osNotificationId,
          scheduleId: r.scheduleId,
          firesAt: r.firesAt,
          fingerprint: r.fingerprint,
        ),
    ];
  }

  Future<void> _persistRegistry(ReconcilePlan plan) async {
    await _db.transaction(() async {
      if (plan.toCancel.isNotEmpty) {
        await (_db.delete(_db.notificationRegistryRows)
              ..where((t) => t.osNotificationId.isIn(plan.toCancel)))
            .go();
      }
      for (final r in plan.toSchedule) {
        await _db.into(_db.notificationRegistryRows).insert(
              NotificationRegistryRowsCompanion.insert(
                osNotificationId: Value(r.osId), // our allocated id, not an auto rowid
                scheduleId: r.scheduleId,
                firesAt: r.firesAt,
                fingerprint: Reconciler.fingerprintFor(r.scheduleId, r.firesAt),
              ),
            );
      }
    });
  }
}
