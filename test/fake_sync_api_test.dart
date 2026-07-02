// Contract tests for the in-memory FakeSyncApi — the executable spec of the delta-sync
// server. These pin the semantics the SyncEngine (and later the Laravel backend) rely on:
// monotonic revs, rev-cursor pull with pagination, append-only idempotency, and LWW.

import 'package:flutter_test/flutter_test.dart';

import 'package:plant_care_reminder/core/domain/ports/sync_api_port.dart';
import 'support/fake_sync_api.dart';

SyncMutation _mut(
  String entity,
  String uuid, {
  int? baseRev,
  DateTime? at,
  Map<String, dynamic>? attrs,
  String op = 'upsert',
}) =>
    SyncMutation(
      entity: entity,
      uuid: uuid,
      op: op,
      baseRev: baseRev,
      clientUpdatedAt: at ?? DateTime.utc(2026, 1, 1),
      attributes: attrs ?? {'id': uuid},
    );

void main() {
  late FakeSyncApi api;
  setUp(() => api = FakeSyncApi());

  test('push assigns monotonically increasing server revs', () async {
    final r = await api.push([_mut('rooms', 'a'), _mut('rooms', 'b')]);
    expect(r.entries.map((e) => e.accepted), everyElement(isTrue));
    expect(r.entries[0].rev, 1);
    expect(r.entries[1].rev, 2);
  });

  test('pull returns rows with rev > since, ascending, with a cursor', () async {
    await api.push([_mut('rooms', 'a'), _mut('rooms', 'b')]);

    final page = await api.pull(since: 0, limit: 100);
    expect(page.changes.map((c) => c.uuid), ['a', 'b']);
    expect(page.nextRev, 2);
    expect(page.hasMore, isFalse);

    final page2 = await api.pull(since: 1, limit: 100);
    expect(page2.changes.map((c) => c.uuid), ['b']); // only rev 2 is newer than 1
  });

  test('pull paginates via limit + hasMore', () async {
    await api.push([_mut('rooms', 'a'), _mut('rooms', 'b'), _mut('rooms', 'c')]);

    final page = await api.pull(since: 0, limit: 2);
    expect(page.changes.map((c) => c.uuid), ['a', 'b']);
    expect(page.hasMore, isTrue);
    expect(page.nextRev, 2);

    final page2 = await api.pull(since: 2, limit: 2);
    expect(page2.changes.map((c) => c.uuid), ['c']);
    expect(page2.hasMore, isFalse);
  });

  test('an append-only care_log push is idempotent on replay', () async {
    final m = _mut('care_logs', 'log-1');
    final r1 = await api.push([m]);
    final r2 = await api.push([m]); // replay the same uuid

    expect(r1.entries.single.rev, 1);
    expect(r2.entries.single.accepted, isTrue);
    expect(r2.entries.single.rev, 1); // same rev — not a second insert
    final page = await api.pull(since: 0, limit: 100);
    expect(page.changes.where((c) => c.uuid == 'log-1'), hasLength(1));
  });

  test('push conflict: an older client edit loses LWW and the winner is echoed',
      () async {
    // Another device already wrote this room at a *later* client time.
    final remote = api.seedRemote(
      entity: 'rooms',
      uuid: 'r1',
      clientUpdatedAt: DateTime.utc(2026, 6, 2),
      attributes: {'id': 'r1', 'name': 'Server name'},
    );

    final r = await api.push([
      _mut('rooms', 'r1',
          baseRev: null,
          at: DateTime.utc(2026, 6, 1),
          attrs: {'id': 'r1', 'name': 'Local name'}),
    ]);

    final entry = r.entries.single;
    expect(entry.accepted, isFalse);
    expect(entry.winner, isNotNull);
    expect(entry.winner!.rev, remote.rev);
    expect(entry.winner!.attributes!['name'], 'Server name');
  });

  test('push conflict: a newer client edit wins LWW', () async {
    api.seedRemote(
      entity: 'rooms',
      uuid: 'r1',
      clientUpdatedAt: DateTime.utc(2026, 6, 1),
      attributes: {'id': 'r1', 'name': 'Server name'},
    );

    final r = await api.push([
      _mut('rooms', 'r1',
          baseRev: null,
          at: DateTime.utc(2026, 6, 5),
          attrs: {'id': 'r1', 'name': 'Local name'}),
    ]);

    expect(r.entries.single.accepted, isTrue);
    final page = await api.pull(since: 0, limit: 100);
    expect(page.changes.firstWhere((c) => c.uuid == 'r1').attributes!['name'],
        'Local name');
  });
}
