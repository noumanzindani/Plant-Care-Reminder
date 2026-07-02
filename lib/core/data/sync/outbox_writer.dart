import 'dart:convert';

import '../db/database.dart';

/// The single writer for the sync Outbox — the change log every local mutation appends
/// to, *in the same transaction as the mutation*, so the SyncEngine (a later slice) can
/// push it to the backend. Nothing may be written to `outboxEntries` except through here.
///
/// Centralizing it keeps the enqueue convention identical across every repository:
/// * `op` is `upsert` (creates + updates; server treats append-only logs as
///   insert-if-not-exists) or `delete` (soft-delete tombstone).
/// * `payload` is a JSON snapshot of the row's post-mutation attributes.
/// * [OutboxEntry.createdAt] is the mutation instant, which doubles as the
///   `client_updated_at` LWW tiebreak when the change is pushed.
/// * `baseRev` stays null until a row is server-known (populated once sync pulls exist).
class OutboxWriter {
  const OutboxWriter(this._db);

  final AppDatabase _db;

  /// Append an upsert change for [entity]/[entityId] snapshotting [attributes].
  /// [clientUpdatedAt] is the mutation instant (the LWW tiebreak on the server).
  Future<void> upsert(
    String entity,
    String entityId,
    Map<String, dynamic> attributes,
    DateTime clientUpdatedAt,
  ) {
    return _db.into(_db.outboxEntries).insert(
          OutboxEntriesCompanion.insert(
            entity: entity,
            entityId: entityId,
            op: 'upsert',
            // `attributes` is a row's `toJson()`, whose DateTimes are already epoch ints
            // (Drift's default serializer) — json-safe and symmetric with `fromJson` on
            // apply, so the SyncEngine can round-trip the snapshot without loss.
            payload: jsonEncode(attributes),
            createdAt: clientUpdatedAt,
          ),
        );
  }
}
