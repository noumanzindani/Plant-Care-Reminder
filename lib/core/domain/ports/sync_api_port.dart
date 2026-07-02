/// The delta-sync wire contract, as a pure-Dart port.
///
/// The [SyncEngine] depends only on this interface — never on `dio` or a live server.
/// An in-memory fake implements it for tests (the executable spec), and a Laravel-backed
/// adapter implements the *same* contract later. The two are interchangeable.
///
/// The watermark is a monotonic server `rev` (not a client clock): pull returns rows with
/// `rev > since` ordered ascending; push echoes a new `rev` per accepted row. Conflicts
/// resolve by last-write-wins on [clientUpdatedAt], with the winning row echoed back so
/// the loser is never silently discarded.
library;

/// One local change to push — an Outbox entry joined to the row's last-known server rev.
class SyncMutation {
  const SyncMutation({
    required this.entity,
    required this.uuid,
    required this.op,
    required this.baseRev,
    required this.clientUpdatedAt,
    required this.attributes,
  });

  final String entity; // 'user_plants' | 'care_schedules' | 'care_logs' | 'rooms'
  final String uuid;
  final String op; // 'upsert' | 'delete'
  final int? baseRev; // server rev the client based this edit on; null if never synced
  final DateTime clientUpdatedAt; // LWW tiebreak
  final Map<String, dynamic> attributes; // JSON snapshot of the row (empty for delete)
}

/// A changed row as the server reports it — a pull result row, or a push conflict echo.
class SyncChange {
  const SyncChange({
    required this.entity,
    required this.uuid,
    required this.rev,
    required this.deleted,
    required this.clientUpdatedAt,
    this.attributes,
  });

  final String entity;
  final String uuid;
  final int rev;
  final bool deleted; // tombstone
  final DateTime clientUpdatedAt;
  final Map<String, dynamic>? attributes; // null iff [deleted]
}

/// The outcome of pushing one mutation.
class SyncPushEntry {
  const SyncPushEntry({
    required this.uuid,
    required this.accepted,
    this.rev,
    this.winner,
  });

  final String uuid;
  final bool accepted; // our version was applied
  final int? rev; // the new server rev, if accepted
  final SyncChange? winner; // the winning row echoed back, if we lost the LWW conflict
}

/// The result of a push batch (per-mutation, so partial success is expressible).
class SyncPushResult {
  const SyncPushResult(this.entries);
  final List<SyncPushEntry> entries;
}

/// One page of pulled changes plus the resumable cursor.
class SyncPullResult {
  const SyncPullResult({
    required this.changes,
    required this.nextRev,
    required this.hasMore,
  });

  final List<SyncChange> changes;
  final int nextRev; // highest rev in this page — the next `since`
  final bool hasMore; // more pages remain beyond this one
}

/// The delta-sync API seam.
abstract interface class SyncApiPort {
  /// Push an ordered batch of local mutations; returns a per-mutation outcome.
  Future<SyncPushResult> push(List<SyncMutation> mutations);

  /// Pull changes with `rev > since`, ascending, up to [limit] per page.
  Future<SyncPullResult> pull({required int since, int limit});
}
