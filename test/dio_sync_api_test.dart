// The real dio-backed SyncApiPort, verified against the pinned wire contract
// (plantner-backend/docs/SYNC_CONTRACT.md) with a hand-rolled fake HttpClientAdapter:
// canned JSON responses in, captured request body out — no real backend, no extra dep.

import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:plant_care_reminder/core/data/sync/dio_sync_api.dart';
import 'package:plant_care_reminder/core/domain/ports/sync_api_port.dart';

/// Captures the last request and returns a fixed JSON body.
class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.respond);

  final Map<String, dynamic> Function(RequestOptions options, dynamic body) respond;

  RequestOptions? lastOptions;
  dynamic lastBody;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastOptions = options;
    if (requestStream != null) {
      final chunks = await requestStream.toList();
      final bytes = chunks.expand((c) => c).toList();
      lastBody = jsonDecode(utf8.decode(bytes));
    }
    return ResponseBody.fromString(
      jsonEncode(respond(options, lastBody)),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

({DioSyncApi api, _FakeAdapter adapter}) build(
    Map<String, dynamic> Function(RequestOptions, dynamic) respond) {
  final dio = Dio(BaseOptions(baseUrl: 'https://plantner.test/api/v1/'));
  final adapter = _FakeAdapter(respond);
  dio.httpClientAdapter = adapter;
  return (api: DioSyncApi(dio), adapter: adapter);
}

void main() {
  test('push serializes mutations to the contract and parses accepted entries', () async {
    final built = build((_, _) => {
          'entries': [
            {'uuid': 'room-1', 'accepted': true, 'rev': 5},
          ],
        });

    final result = await built.api.push([
      SyncMutation(
        entity: 'rooms',
        uuid: 'room-1',
        op: 'upsert',
        baseRev: null,
        clientUpdatedAt: DateTime.fromMillisecondsSinceEpoch(1000, isUtc: true),
        attributes: const {'id': 'room-1', 'name': 'Balcony'},
      ),
    ]);

    // Request shape matches SYNC_CONTRACT.md.
    expect(built.adapter.lastOptions!.path, 'sync/mutations');
    expect(built.adapter.lastOptions!.method, 'POST');
    final sent = (built.adapter.lastBody as Map)['mutations'][0] as Map;
    expect(sent['entity'], 'rooms');
    expect(sent['op'], 'upsert');
    expect(sent['base_rev'], null);
    expect(sent['client_updated_at'], 1000); // epoch millis
    expect(sent['attributes'], {'id': 'room-1', 'name': 'Balcony'});

    // Response parsed.
    expect(result.entries.single.uuid, 'room-1');
    expect(result.entries.single.accepted, isTrue);
    expect(result.entries.single.rev, 5);
    expect(result.entries.single.winner, isNull);
  });

  test('push parses a lost-conflict entry with the echoed winner', () async {
    final built = build((_, _) => {
          'entries': [
            {
              'uuid': 'room-1',
              'accepted': false,
              'winner': {
                'entity': 'rooms',
                'uuid': 'room-1',
                'rev': 9,
                'deleted': false,
                'client_updated_at': 5000,
                'attributes': {'id': 'room-1', 'name': 'Winner'},
              },
            },
          ],
        });

    final result = await built.api.push([
      SyncMutation(
        entity: 'rooms',
        uuid: 'room-1',
        op: 'upsert',
        baseRev: 1,
        clientUpdatedAt: DateTime.fromMillisecondsSinceEpoch(3000, isUtc: true),
        attributes: const {'id': 'room-1', 'name': 'Stale'},
      ),
    ]);

    final entry = result.entries.single;
    expect(entry.accepted, isFalse);
    expect(entry.rev, isNull);
    expect(entry.winner!.rev, 9);
    expect(entry.winner!.entity, 'rooms');
    expect(entry.winner!.attributes!['name'], 'Winner');
  });

  test('pull sends since+limit and parses changes with the cursor', () async {
    final built = build((_, _) => {
          'changes': [
            {
              'entity': 'rooms',
              'uuid': 'room-1',
              'rev': 7,
              'deleted': false,
              'client_updated_at': 1000,
              'attributes': {'id': 'room-1', 'name': 'Balcony'},
            },
          ],
          'next_rev': 7,
          'has_more': true,
        });

    final result = await built.api.pull(since: 3, limit: 50);

    expect(built.adapter.lastOptions!.path, 'sync/changes');
    expect(built.adapter.lastOptions!.method, 'GET');
    expect(built.adapter.lastOptions!.queryParameters, {'since': 3, 'limit': 50});

    expect(result.changes.single.uuid, 'room-1');
    expect(result.changes.single.entity, 'rooms');
    expect(result.changes.single.deleted, isFalse);
    expect(result.changes.single.attributes!['name'], 'Balcony');
    expect(result.nextRev, 7);
    expect(result.hasMore, isTrue);
  });

  test('pull parses a tombstone (deleted, null attributes)', () async {
    final built = build((_, _) => {
          'changes': [
            {
              'entity': 'rooms',
              'uuid': 'room-1',
              'rev': 8,
              'deleted': true,
              'client_updated_at': 2000,
              'attributes': null,
            },
          ],
          'next_rev': 8,
          'has_more': false,
        });

    final result = await built.api.pull(since: 0);

    expect(result.changes.single.deleted, isTrue);
    expect(result.changes.single.attributes, isNull);
    expect(result.hasMore, isFalse);
  });
}
