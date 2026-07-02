/// Core domain enums — pure Dart, no Flutter or plugin imports.
///
/// These are the vocabulary of the care domain. They are persisted by Drift via
/// `textEnum<T>()` columns (stored as the enum's `.name`), so **do not reorder or
/// rename** existing values without a migration — the string name is the contract.
library;

/// The kinds of care a plant can need. Drives schedules, logs, and reminders.
enum CareType { water, fertilize, mist, repot, rotate, prune, clean, inspect }

/// How a schedule computes its next due date.
///
/// * [fromLastDone] — next due is relative to when the task was *actually* performed
///   (late watering pushes the whole chain forward; no "catch-up storm"). Default for
///   water/mist/fertilize.
/// * [fixedCalendar] — next due snaps to the next grid slot regardless of when the task
///   was performed (rotating early doesn't skip the month). Default for rotate/clean/inspect.
enum AnchorMode { fromLastDone, fixedCalendar }

/// Where a care log entry came from — distinguishes a real action from a skip.
enum CareLogSource { manual, quickAction, autoConfirmed, skipped }

/// Lifecycle state of a user's plant instance.
enum PlantStatus { active, dormant, archived, dead }

/// Offline-first sync state of a locally-owned row.
///
/// * [localOnly] — created offline / no account yet; anon→auth upgrade flips these to
///   [pendingPush] and the Outbox drains them.
/// * [pendingPush] — has local changes not yet acknowledged by the server.
/// * [synced] — server has the current version.
/// * [conflicted] — a sync conflict that needs surfacing to the user (never silently lost).
enum SyncState { localOnly, pendingPush, synced, conflicted }

/// A window's compass orientation — a prior for how much light a room gets.
enum WindowOrientation { north, east, south, west }

/// How much light a species wants — the catalog's light band. `bright` includes direct
/// sun tolerance; `low` is shade-tolerant. Used for display now and room-matching later.
enum LightLevel { low, medium, bright }

/// Season, used to scale care intervals (e.g. water less in winter). Which months
/// map to which season is hemisphere-dependent — see `CadenceEngine`.
enum Season { spring, summer, autumn, winter }
