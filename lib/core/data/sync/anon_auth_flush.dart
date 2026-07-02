import 'package:drift/drift.dart';

import '../db/database.dart';
import 'outbox_writer.dart';
import 'sync_engine.dart';

/// The one-time offline→account migration: when a previously-anonymous user first
/// authenticates, every row they created offline must reach their new account —
/// completely and without duplicates.
///
/// Because primary keys are client-generated UUID v7 that the server accepts as canonical,
/// this is a pure insert (no id remap — the classic source of anon→auth dup/loss). It
/// stages every not-yet-synced row (`serverRev == null`) into the Outbox *explicitly* —
/// so completeness is a property of the flush, not a bet that the Outbox was never pruned
/// — then lets the [SyncEngine] push it. Idempotent: the SyncEngine coalesces per row and
/// the `serverRev` filter skips already-acknowledged rows, so a repeat flush is a no-op.
class AnonAuthFlush {
  AnonAuthFlush({required AppDatabase db, required SyncEngine engine})
      : _db = db,
        _engine = engine,
        _outbox = OutboxWriter(db);

  final AppDatabase _db;
  final SyncEngine _engine;
  final OutboxWriter _outbox;

  Future<SyncReport> flush() async {
    await _stageUnsyncedRows();
    return _engine.sync();
  }

  /// Enqueue an upsert for every live row the server has not yet acknowledged. Soft-deleted
  /// rows created before the account existed are intentionally skipped — there is no reason
  /// to resurrect them on the server. Care schedules have no soft-delete (inactive ones are
  /// still real rows to sync), so they filter on `serverRev` alone.
  Future<void> _stageUnsyncedRows() async {
    await _db.transaction(() async {
      for (final p in await (_db.select(_db.userPlants)
            ..where((t) => t.serverRev.isNull() & t.deletedAt.isNull()))
          .get()) {
        await _outbox.upsert('user_plants', p.id, p.toJson(), p.updatedAt);
      }
      for (final s in await (_db.select(_db.careSchedules)
            ..where((t) => t.serverRev.isNull()))
          .get()) {
        await _outbox.upsert('care_schedules', s.id, s.toJson(), s.updatedAt);
      }
      for (final l in await (_db.select(_db.careLogs)
            ..where((t) => t.serverRev.isNull() & t.deletedAt.isNull()))
          .get()) {
        await _outbox.upsert('care_logs', l.id, l.toJson(), l.updatedAt);
      }
      for (final r in await (_db.select(_db.rooms)
            ..where((t) => t.serverRev.isNull() & t.deletedAt.isNull()))
          .get()) {
        await _outbox.upsert('rooms', r.id, r.toJson(), r.updatedAt);
      }
    });
  }
}
