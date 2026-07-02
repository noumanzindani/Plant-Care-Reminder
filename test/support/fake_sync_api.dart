import 'package:plant_care_reminder/core/domain/ports/sync_api_port.dart';

/// An in-memory implementation of [SyncApiPort] that behaves like the real delta-sync
/// server — the executable spec the [SyncEngine] tests run against (and the golden
/// contract the Laravel backend will later be validated against).
///
/// It holds one authoritative row per uuid, stamps a monotonically increasing `rev` on
/// every accepted write, resolves conflicts by last-write-wins on `clientUpdatedAt`
/// (echoing the winner), treats `care_logs` as append-only (insert-if-not-exists), and
/// does not enforce foreign keys (uuid references may arrive out of order).
class FakeSyncApi implements SyncApiPort {
  int _rev = 0;
  final Map<String, SyncChange> _rows = {}; // keyed by uuid

  /// How many times [push] has been called — lets tests assert idempotent replay.
  int pushCalls = 0;

  /// Simulate another device having written a row on the server. Returns the stored row.
  SyncChange seedRemote({
    required String entity,
    required String uuid,
    required Map<String, dynamic> attributes,
    required DateTime clientUpdatedAt,
    bool deleted = false,
  }) {
    final change = SyncChange(
      entity: entity,
      uuid: uuid,
      rev: ++_rev,
      deleted: deleted,
      clientUpdatedAt: clientUpdatedAt,
      attributes: deleted ? null : attributes,
    );
    _rows[uuid] = change;
    return change;
  }

  @override
  Future<SyncPushResult> push(List<SyncMutation> mutations) async {
    pushCalls++;
    final entries = <SyncPushEntry>[];
    for (final m in mutations) {
      final existing = _rows[m.uuid];

      // Append-only logs: a replayed uuid is a no-op, not a duplicate.
      if (m.entity == 'care_logs' && existing != null) {
        entries.add(SyncPushEntry(uuid: m.uuid, accepted: true, rev: existing.rev));
        continue;
      }

      // Conflict: the server row moved on since the client's base_rev.
      if (existing != null && existing.rev != m.baseRev) {
        if (m.clientUpdatedAt.isAfter(existing.clientUpdatedAt)) {
          entries.add(
              SyncPushEntry(uuid: m.uuid, accepted: true, rev: _apply(m).rev));
        } else {
          // Server wins → echo the winner so the client can absorb it.
          entries.add(SyncPushEntry(uuid: m.uuid, accepted: false, winner: existing));
        }
        continue;
      }

      entries.add(SyncPushEntry(uuid: m.uuid, accepted: true, rev: _apply(m).rev));
    }
    return SyncPushResult(entries);
  }

  SyncChange _apply(SyncMutation m) {
    final change = SyncChange(
      entity: m.entity,
      uuid: m.uuid,
      rev: ++_rev,
      deleted: m.op == 'delete',
      clientUpdatedAt: m.clientUpdatedAt,
      attributes: m.op == 'delete' ? null : m.attributes,
    );
    _rows[m.uuid] = change;
    return change;
  }

  @override
  Future<SyncPullResult> pull({required int since, int limit = 100}) async {
    final ordered = _rows.values.where((c) => c.rev > since).toList()
      ..sort((a, b) => a.rev.compareTo(b.rev));
    final page = ordered.take(limit).toList();
    return SyncPullResult(
      changes: page,
      nextRev: page.isEmpty ? since : page.last.rev,
      hasMore: ordered.length > limit,
    );
  }
}
