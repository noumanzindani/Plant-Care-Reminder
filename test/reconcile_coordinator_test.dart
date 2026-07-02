// End-to-end test of the reminder engine: seed real plants/schedules/logs in an
// in-memory Drift db, run the coordinator with a recording fake port, and assert the
// right notifications were scheduled AND recorded in the registry — and that a second
// run is a no-op (idempotent). No widgets, no real notifications.

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'package:plant_care_reminder/core/data/db/database.dart';
import 'package:plant_care_reminder/core/data/reminders/reconcile_coordinator.dart';
import 'package:plant_care_reminder/core/domain/ports/notification_port.dart';
import 'package:plant_care_reminder/core/domain/value_objects/enums.dart';

class RecordingNotificationPort implements NotificationPort {
  final List<ScheduledReminder> scheduled = [];
  final List<int> cancelled = [];

  @override
  Future<void> schedule(ScheduledReminder r) async => scheduled.add(r);

  @override
  Future<void> cancel(int osId) async => cancelled.add(osId);

  @override
  Future<void> cancelAll() async {}

  @override
  Future<List<int>> pendingIds() async => scheduled.map((r) => r.osId).toList();
}

void main() {
  tz_data.initializeTimeZones();
  final ny = tz.getLocation('America/New_York');

  late AppDatabase db;
  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  Future<void> seedWateredPlant() async {
    await db.plantsDao.insertPlant(UserPlantsCompanion.insert(
      id: 'p1', nickname: 'Monstera',
      createdAt: DateTime.utc(2026, 1, 1), updatedAt: DateTime.utc(2026, 1, 1),
    ));
    await db.into(db.careSchedules).insert(CareSchedulesCompanion.insert(
      id: 'sch1', userPlantId: 'p1', type: CareType.water, baseIntervalDays: 7,
      tzId: 'America/New_York',
      createdAt: DateTime.utc(2026, 1, 1), updatedAt: DateTime.utc(2026, 1, 1),
    ));
    await db.into(db.careLogs).insert(CareLogsCompanion.insert(
      id: 'log1', userPlantId: 'p1', type: CareType.water,
      performedAt: tz.TZDateTime(ny, 2026, 6, 1, 9, 0),
      createdAt: DateTime.utc(2026, 6, 1), updatedAt: DateTime.utc(2026, 6, 1),
    ));
  }

  test('reconcile schedules the due reminder and records it in the registry', () async {
    await seedWateredPlant();
    final port = RecordingNotificationPort();
    final coordinator = ReconcileCoordinator(db: db, port: port);

    await coordinator.reconcile(tz.TZDateTime(ny, 2026, 6, 1, 10, 0));

    expect(port.scheduled, hasLength(1));
    expect(port.scheduled.single.firesAt, tz.TZDateTime(ny, 2026, 6, 8, 9, 0));

    final registry = await db.select(db.notificationRegistryRows).get();
    expect(registry, hasLength(1));
    expect(registry.single.scheduleId, 'sch1');
    expect(registry.single.osNotificationId, port.scheduled.single.osId);
  });

  test('reconcile is idempotent: a second run schedules nothing new', () async {
    await seedWateredPlant();
    final port = RecordingNotificationPort();
    final coordinator = ReconcileCoordinator(db: db, port: port);
    final now = tz.TZDateTime(ny, 2026, 6, 1, 10, 0);

    await coordinator.reconcile(now);
    port.scheduled.clear();
    await coordinator.reconcile(now);

    expect(port.scheduled, isEmpty);
    expect(port.cancelled, isEmpty);
    expect(await db.select(db.notificationRegistryRows).get(), hasLength(1));
  });

  test('reconcile caches nextDueAt on the schedule for the UI to read', () async {
    await seedWateredPlant();
    final coordinator = ReconcileCoordinator(db: db, port: RecordingNotificationPort());

    await coordinator.reconcile(tz.TZDateTime(ny, 2026, 6, 1, 10, 0));

    final schedule =
        await (db.select(db.careSchedules)..where((s) => s.id.equals('sch1'))).getSingle();
    expect(schedule.nextDueAt, isNotNull);
    expect(
      schedule.nextDueAt!.isAtSameMomentAs(tz.TZDateTime(ny, 2026, 6, 8, 9, 0)),
      isTrue,
    );
  });
}
