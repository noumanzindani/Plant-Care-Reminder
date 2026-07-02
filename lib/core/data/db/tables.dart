import 'package:drift/drift.dart';

import '../../domain/value_objects/enums.dart';

/// Drift table definitions — the on-device source of truth.
///
/// Conventions (mirrors the backend contract so sync is a straight mapping):
/// * Every user-owned row's primary key is a **client-generated UUID v7** (`TextColumn id`).
///   The backend accepts these as canonical, which makes the anonymous→account upgrade a
///   pure Outbox flush (no id remapping).
/// * `createdAt` / `updatedAt` / nullable `deletedAt` (soft-delete tombstones).
/// * `sync` — the row's [SyncState]; new rows default to `localOnly`.
/// * Enums are stored via `textEnum` (as `.name`) — never reorder/rename enum values
///   without a migration.

/// The plant-species catalog — read-mostly reference data, the opposite direction from
/// user rows: server-authoritative (seeded locally now, synced from the Perenual-backed
/// Laravel catalog later) and one-way into the app. Keyed by a stable slug id so a
/// re-seed / delta upserts in place. `catalogVersion` is the delta-sync watermark.
///
/// Not a user-owned row, so it carries no [SyncState]/soft-delete — those belong to the
/// user's own collection, which syncs in the other direction.
@DataClassName('SpeciesRow') // avoids Drift's "Specy" singularization of "Species"
class Species extends Table {
  TextColumn get id => text()(); // stable slug, e.g. "monstera-deliciosa"
  TextColumn get scientificName => text()();
  TextColumn get commonName => text()();
  TextColumn get family => text().nullable()();
  IntColumn get wateringIntervalDays => integer()();
  IntColumn get fertilizeIntervalDays => integer().nullable()();
  TextColumn get lightLevel => textEnum<LightLevel>().nullable()();
  BoolColumn get toxicToPets => boolean().nullable()(); // null = unknown
  IntColumn get catalogVersion => integer().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Rooms extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get orientation => textEnum<WindowOrientation>().nullable()();
  BoolColumn get outdoor => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get sync => textEnum<SyncState>().withDefault(const Constant('localOnly'))();
  /// The server revision this row was last synced at (the `rev` watermark). Null until
  /// the row has been accepted by the backend; sourced as `base_rev` on the next push.
  IntColumn get serverRev => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class UserPlants extends Table {
  TextColumn get id => text()();
  TextColumn get speciesId => text().nullable()(); // null = unidentified
  TextColumn get roomId => text().nullable()();
  TextColumn get nickname => text().withLength(min: 1, max: 120)();
  TextColumn get photoPath => text().nullable()();
  DateTimeColumn get acquiredAt => dateTime().nullable()();
  TextColumn get status => textEnum<PlantStatus>().withDefault(const Constant('active'))();
  IntColumn get version => integer().withDefault(const Constant(0))(); // optimistic concurrency
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get sync => textEnum<SyncState>().withDefault(const Constant('localOnly'))();
  /// The server revision this row was last synced at (the `rev` watermark). Null until
  /// the row has been accepted by the backend; sourced as `base_rev` on the next push.
  IntColumn get serverRev => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// One schedule per (plant, careType). The cadence engine reads these + the latest
/// matching [CareLogs] to compute the next due date. `nextDueAt` is a **cache** of that
/// computation for fast UI/queries — never an authoritative input.
class CareSchedules extends Table {
  TextColumn get id => text()();
  TextColumn get userPlantId => text()();
  TextColumn get type => textEnum<CareType>()();
  IntColumn get baseIntervalDays => integer()();
  TextColumn get anchor => textEnum<AnchorMode>().withDefault(const Constant('fromLastDone'))();
  IntColumn get timeOfDayMinutes => integer().withDefault(const Constant(540))(); // 09:00 local
  TextColumn get tzId => text()(); // IANA zone, e.g. "America/Los_Angeles"
  TextColumn get seasonalMul => text().nullable()(); // JSON {season: multiplier}
  BoolColumn get weatherSensitive => boolean().withDefault(const Constant(false))();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  DateTimeColumn get nextDueAt => dateTime().nullable()(); // cached projection
  /// A user-requested "remind me later" marker. When set and *later* than the cadence's
  /// natural due date, the reminder engine fires at this instant instead. Logging the
  /// care afterward pushes the natural due date past it, which supersedes the snooze —
  /// so it needs no explicit clearing.
  DateTimeColumn get snoozedUntil => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()(); // cadence anchor when never performed
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get sync => textEnum<SyncState>().withDefault(const Constant('localOnly'))();
  /// The server revision this row was last synced at (the `rev` watermark). Null until
  /// the row has been accepted by the backend; sourced as `base_rev` on the next push.
  IntColumn get serverRev => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Append-only care history. Drives next-due recomputation and streaks.
/// Immutable by design → never conflicts on sync.
class CareLogs extends Table {
  TextColumn get id => text()();
  TextColumn get userPlantId => text()();
  TextColumn get type => textEnum<CareType>()();
  DateTimeColumn get performedAt => dateTime()(); // when the user actually did it
  TextColumn get source => textEnum<CareLogSource>().withDefault(const Constant('manual'))();
  IntColumn get amountMl => integer().nullable()();
  TextColumn get note => text().nullable()();
  TextColumn get photoPath => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get sync => textEnum<SyncState>().withDefault(const Constant('localOnly'))();
  /// The server revision this row was last synced at (the `rev` watermark). Null until
  /// the row has been accepted by the backend; sourced as `base_rev` on the next push.
  IntColumn get serverRev => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Maps an OS-scheduled notification to the schedule that produced it. Local-only —
/// never synced. The reconciler owns this table and diffs it against the desired set by
/// [fingerprint].
class NotificationRegistryRows extends Table {
  IntColumn get osNotificationId => integer()();
  TextColumn get scheduleId => text()();
  DateTimeColumn get firesAt => dateTime()();
  TextColumn get fingerprint => text()(); // hash(scheduleId, firesAt, type)

  @override
  Set<Column> get primaryKey => {osNotificationId};
}

/// The sync change log. Every local mutation appends a row here in the same
/// transaction; the SyncEngine drains it to the backend. Local-only.
class OutboxEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entity => text()(); // e.g. "user_plants"
  TextColumn get entityId => text()(); // the row's UUID
  TextColumn get op => text()(); // "upsert" | "delete"
  TextColumn get payload => text()(); // JSON snapshot of attributes
  IntColumn get baseRev => integer().nullable()(); // last server rev seen for this row
  DateTimeColumn get createdAt => dateTime()();
}

/// Per-entity delta-sync cursor: the highest server `rev` this device has fully
/// consumed. Local-only.
class SyncCursors extends Table {
  TextColumn get entity => text()();
  IntColumn get lastRev => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {entity};
}
