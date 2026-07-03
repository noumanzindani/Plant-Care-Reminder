import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/value_objects/enums.dart';
import '../db/database.dart';
import '../sync/outbox_writer.dart';

/// The write/read side of rooms: the locations a user groups plants by (Living room,
/// Balcony, …). A room's [WindowOrientation] and `outdoor` flag are the light/weather
/// priors that Phase 5 will read; in Phase 1 a room is purely organizational.
///
/// Ids are client-generated UUID v7 — the same canonical identity convention as the rest
/// of the collection, so rooms sync as a straight push later.
class RoomsRepository {
  RoomsRepository(this._db, {Uuid uuid = const Uuid()})
      : _uuid = uuid,
        _outbox = OutboxWriter(_db);

  final AppDatabase _db;
  final Uuid _uuid;
  final OutboxWriter _outbox;

  /// Create a room. Returns its id.
  Future<String> addRoom({
    required String name,
    WindowOrientation? orientation,
    bool outdoor = false,
  }) async {
    final now = DateTime.now();
    final id = _uuid.v7();
    await _db.transaction(() async {
      await _db.into(_db.rooms).insert(
            RoomsCompanion.insert(
              id: id,
              name: name,
              createdAt: now,
              updatedAt: now,
              orientation: Value(orientation),
              outdoor: Value(outdoor),
            ),
          );
      final row =
          await (_db.select(_db.rooms)..where((r) => r.id.equals(id))).getSingle();
      await _outbox.upsert('rooms', id, row.toJson(), now);
    });
    return id;
  }

  /// Live list of non-deleted rooms, ordered by explicit sort order then creation.
  Stream<List<Room>> watchRooms() {
    return (_db.select(_db.rooms)
          ..where((r) => r.deletedAt.isNull())
          ..orderBy([
            (r) => OrderingTerm(expression: r.sortOrder),
            (r) => OrderingTerm(expression: r.createdAt),
          ]))
        .watch();
  }

  /// Set a room's outdoor flag — the location prior the weather overlay reads. The caller
  /// reconciles, since weather-sensitive schedules of plants in this room may shift.
  Future<void> setRoomOutdoor({required String roomId, required bool outdoor}) async {
    final now = DateTime.now();
    await _db.transaction(() async {
      await (_db.update(_db.rooms)..where((r) => r.id.equals(roomId))).write(
        RoomsCompanion(
          outdoor: Value(outdoor),
          updatedAt: Value(now),
        ),
      );
      final row =
          await (_db.select(_db.rooms)..where((r) => r.id.equals(roomId))).getSingle();
      await _outbox.upsert('rooms', roomId, row.toJson(), now);
    });
  }

  /// Assign [plantId] to [roomId] (pass null to clear the room). `Value(roomId)` writes
  /// the value — including null — rather than leaving the column untouched.
  Future<void> assignPlantToRoom({required String plantId, String? roomId}) async {
    final now = DateTime.now();
    await _db.transaction(() async {
      await (_db.update(_db.userPlants)..where((p) => p.id.equals(plantId))).write(
        UserPlantsCompanion(
          roomId: Value(roomId),
          updatedAt: Value(now),
        ),
      );
      // Assigning a room mutates the *plant* row, so the change enqueues under it.
      final row = await (_db.select(_db.userPlants)..where((p) => p.id.equals(plantId)))
          .getSingle();
      await _outbox.upsert('user_plants', plantId, row.toJson(), now);
    });
  }
}
