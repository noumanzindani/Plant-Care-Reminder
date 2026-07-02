import 'package:dio/dio.dart';

import '../../domain/ports/sync_api_port.dart';

/// The live [SyncApiPort]: talks to the Laravel delta-sync endpoints over HTTP, serialising
/// to the wire contract in `plantner-backend/docs/SYNC_CONTRACT.md` (snake_case keys,
/// epoch-millisecond timestamps). Drop-in replacement for the in-memory `FakeSyncApi`.
///
/// The injected [Dio] carries the base URL (`…/api/v1/`) and the auth interceptor that adds
/// the bearer token; this class only knows the two relative endpoints and the JSON shapes.
class DioSyncApi implements SyncApiPort {
  DioSyncApi(this._dio);

  final Dio _dio;

  @override
  Future<SyncPushResult> push(List<SyncMutation> mutations) async {
    final res = await _dio.post<Map<String, dynamic>>(
      'sync/mutations',
      data: {'mutations': mutations.map(_mutationToJson).toList()},
    );
    final entries = (res.data!['entries'] as List)
        .map((e) => _entryFromJson((e as Map).cast<String, dynamic>()))
        .toList();
    return SyncPushResult(entries);
  }

  @override
  Future<SyncPullResult> pull({required int since, int limit = 100}) async {
    final res = await _dio.get<Map<String, dynamic>>(
      'sync/changes',
      queryParameters: {'since': since, 'limit': limit},
    );
    final data = res.data!;
    final changes = (data['changes'] as List)
        .map((c) => _changeFromJson((c as Map).cast<String, dynamic>()))
        .toList();
    return SyncPullResult(
      changes: changes,
      nextRev: data['next_rev'] as int,
      hasMore: data['has_more'] as bool,
    );
  }

  Map<String, dynamic> _mutationToJson(SyncMutation m) => {
        'entity': m.entity,
        'uuid': m.uuid,
        'op': m.op,
        'base_rev': m.baseRev,
        'client_updated_at': m.clientUpdatedAt.millisecondsSinceEpoch,
        'attributes': m.attributes,
      };

  SyncPushEntry _entryFromJson(Map<String, dynamic> j) => SyncPushEntry(
        uuid: j['uuid'] as String,
        accepted: j['accepted'] as bool,
        rev: j['rev'] as int?,
        winner: j['winner'] == null
            ? null
            : _changeFromJson((j['winner'] as Map).cast<String, dynamic>()),
      );

  SyncChange _changeFromJson(Map<String, dynamic> j) => SyncChange(
        entity: j['entity'] as String,
        uuid: j['uuid'] as String,
        rev: j['rev'] as int,
        deleted: j['deleted'] as bool,
        clientUpdatedAt:
            DateTime.fromMillisecondsSinceEpoch(j['client_updated_at'] as int, isUtc: true),
        attributes: (j['attributes'] as Map?)?.cast<String, dynamic>(),
      );
}
