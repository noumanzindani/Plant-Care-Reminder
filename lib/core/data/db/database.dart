import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../domain/value_objects/enums.dart';
import 'daos/plants_dao.dart';
import 'tables.dart';

part 'database.g.dart';

/// The app's single Drift database — the on-device source of truth.
///
/// Opened via `drift_flutter`'s [driftDatabase], which uses `sqlite3_flutter_libs`
/// with WAL journaling. WAL matters here: it lets the background isolate (workmanager,
/// Phase 1) safely share this same file with the UI isolate while the reconciler runs.
///
/// A [QueryExecutor] can be injected for tests (e.g. an in-memory `NativeDatabase`).
@DriftDatabase(
  tables: [
    Species,
    Rooms,
    UserPlants,
    CareSchedules,
    CareLogs,
    NotificationRegistryRows,
    OutboxEntries,
    SyncCursors,
  ],
  daos: [PlantsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'plant_care'));

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          // v2: snooze marker on schedules (deferred "remind me later").
          if (from < 2) {
            await m.addColumn(careSchedules, careSchedules.snoozedUntil);
          }
          // v3: plant-species catalog table.
          if (from < 3) {
            await m.createTable(species);
          }
          // v4: server-rev watermark on syncable rows (delta-sync base_rev source).
          if (from < 4) {
            await m.addColumn(userPlants, userPlants.serverRev);
            await m.addColumn(careSchedules, careSchedules.serverRev);
            await m.addColumn(careLogs, careLogs.serverRev);
            await m.addColumn(rooms, rooms.serverRev);
          }
        },
      );
}
