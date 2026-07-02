// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plants_dao.dart';

// ignore_for_file: type=lint
mixin _$PlantsDaoMixin on DatabaseAccessor<AppDatabase> {
  $UserPlantsTable get userPlants => attachedDatabase.userPlants;
  $RoomsTable get rooms => attachedDatabase.rooms;
  PlantsDaoManager get managers => PlantsDaoManager(this);
}

class PlantsDaoManager {
  final _$PlantsDaoMixin _db;
  PlantsDaoManager(this._db);
  $$UserPlantsTableTableManager get userPlants =>
      $$UserPlantsTableTableManager(_db.attachedDatabase, _db.userPlants);
  $$RoomsTableTableManager get rooms =>
      $$RoomsTableTableManager(_db.attachedDatabase, _db.rooms);
}
