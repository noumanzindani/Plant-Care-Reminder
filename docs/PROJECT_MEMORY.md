# Project Memory — Plantner (Plant Care Reminder)

A faithful export of the working memory accumulated while building this app: the locked
architecture decisions, conventions, the sync wire contract, and the slice-by-slice
progress log. It is terse and internal by nature (originally an assistant scratch-memory) —
the curated, readable summary lives in the root [`CLAUDE.md`](../CLAUDE.md). Kept here so a
clone carries the full "why" behind the code.

> Note: this is a point-in-time snapshot. When it disagrees with the code, the code wins.

---

## Project scope, architecture & slice-by-slice progress

Building **Plant Care Reminder** (`plant_care_reminder/`), a greenfield Flutter app positioned as a
full competitor to Planta/Greg/PlantIn. Approved plan lives at
`/Users/macmini/.claude/plans/ancient-humming-snail.md`.

**Locked decisions (2026-07-01):** full-competitor scope built via 8 shippable phases · Pl@ntNet
free API for identification (proxied through Laravel, swappable adapter) · disease diagnosis DEFERRED
(Pl@ntNet has no disease endpoint; add Plant.id/Kindwise later, premium-gated) · full custom Laravel
backend · hybrid monetization (AdMob free tier + RevenueCat subscription).

**Non-negotiable principle:** the core loop (add plant → schedule → local reminders → log) must work
fully offline with no account. Every cloud feature is a port/adapter layered on top — the OPPOSITE of
EzHand's client→server model.

**Load-bearing architecture (three independent design passes converged on these):** Drift/SQLite =
single source of truth · Riverpod state · client-generated UUID v7 keys accepted as canonical by
backend (makes anon→auth a pure Outbox flush) · append-only care logs (conflict-free) · rolling
56-window reconciler for the reminder engine (iOS 64-notification cap) · monotonic server `rev`
watermark for delta sync · server-authoritative entitlements (`users.is_premium`).

**Phase order:** 0 Foundation+compliance scaffolding → 1 Offline core loop (the spine) → 2 Catalog
(Perenual seed) → 3 Accounts+sync → 4 AI ID → 5 Weather+light meter → 6 Monetization → 7 Community →
8 Store hardening. Start 0→1; 2–5 reorderable.

Owner also runs EzHand (Laravel marketplace) — comfortable with Laravel/Flutter/Provider, but this
app uses Riverpod not Provider. See the plan file for the 15-item store-compliance checklist (bundle
id, Privacy Manifest, ATT/UMP, account deletion, AdMob wiring).

**Bundle id / applicationId (permanent):** `co.appverra.plantner` (app name "Plantner", appverra.co).
Set in android/app/build.gradle.kts + ios pbxproj.

**Conventions established (non-obvious):**
- **Manual Riverpod providers, NOT codegen.** `riverpod_generator`/`riverpod_lint` conflict with
  Freezed 3.x + the pinned Riverpod, so they're deliberately omitted. Drift + Freezed codegen stay.
- **Never put widget tests (`testWidgets`) and pure Drift-stream tests in the SAME file.**
  `TestWidgetsFlutterBinding`'s fake clock stops Drift's real-timer stream delivery → hangs. Data
  tests get their own files (Flutter runs each file in its own isolate). Also: never `pumpAndSettle`
  against a `CircularProgressIndicator` (spins forever); override async providers with timer-free
  `Stream.value` stubs in View tests.
- flutter_local_notifications v22 uses NAMED params: `initialize(settings:)`, `cancel(id:)`,
  `zonedSchedule(id:, scheduledDate:, ...)`.

**Progress (as of this session):** Phase 0 ✅. Phase 1 core loop ✅ — offline reminder engine fully
TDD'd (CadenceEngine, Reconciler, ReminderApplier, OccurrenceBuilder, ReconcileCoordinator),
LocalNotificationsAdapter, CareRepository, add-plant + Today-queue UI, workmanager periodic reconcile
+ reconcile-on-resume. **Snooze ✅** (schema v2 `snoozedUntil` column on CareSchedules + migration;
overlay in OccurrenceBuilder fires at snoozedUntil only when *later* than natural due, so logging
care self-supersedes it — no explicit clear; `CareRepository.snooze`; PopupMenu on care tile).
**Journal ✅** (`CareRepository.watchJournal` newest-first + nickname join; JournalScreen at
`/journal`, day-grouped; shared `lib/shared/care_type_display.dart` icon/verb helper).
**Multi-care-type ✅** — engine already supported N schedules/plant; added `CareRepository.addSchedule`
(upserts one-active-per-(plant,type), reactivates + clears snooze), `deactivateSchedule` (active=false,
keeps logs), `watchPlantSchedules(plantId)`, `PlantsDao.watchPlant(id)`; PlantDetailScreen at
`/plant/:id` (list care types, remove, "Add care type" bottom sheet w/ type dropdown + interval +
time), home care tiles tap → detail.
**Rooms ✅** — `RoomsRepository` (addRoom/watchRooms/assignPlantToRoom; `Value(roomId)` writes null to
clear); `roomsProvider`/`roomsRepositoryProvider`; PlantDetailScreen now has a Room row + picker sheet
(select existing / "No room" via `RadioGroup` — the pre-3.32 groupValue/onChanged API is deprecated /
create-inline). Rooms table + UserPlants.roomId already existed; no reconcile (rooms don't affect
Phase-1 scheduling — they're the Phase-5 light/weather prior). 40 tests, all green, analyze clean.
REMAINING in Phase 1 (tails): notification-tap deep-link, iOS BGTaskScheduler.

**Phase 2 STARTED — offline catalog + smart defaults ✅ (foundation).** Built offline-first, NO backend
yet (Perenual-via-Laravel remote adapter drops into the same port later). Schema **v3**: `Species`
catalog table (`@DataClassName('SpeciesRow')` to avoid Drift's "Specy"; slug id, watering/fertilize
defaults, LightLevel enum, toxicToPets, catalogVersion) + migration `m.createTable(species)`.
`SpeciesCatalogPort` (domain, pure) w/ SpeciesSummary/SpeciesDetail/CareDefaults; `DriftSpeciesCatalog`
adapter (search by common+scientific name via lower()+LIKE, getById). `CatalogSeeder` (idempotent
`insertOnConflictUpdate`, version-gated via SyncCursors 'catalog_seed') + `kSpeciesSeed` (~18 common
houseplants, Dart const — no asset plumbing). Seeded in main() bootstrap. `CareRepository.addPlant`
(species link + optional fertilize schedule = smart defaults; `addWateringPlant` now delegates to it).
AddPlantScreen has a search-as-you-type species picker (out-of-order-guarded) that pre-fills cadence +
auto-fertilize. Providers: speciesCatalogProvider, catalogSeederProvider. **Species detail display ✅** —
`speciesDetailProvider` (FutureProvider.autoDispose.family keyed on speciesId → getById);
PlantDetailScreen `_SpeciesTile` shows the linked species' common+scientific name and info chips
(light need via `_lightLabel`, pet toxicity, family); renders SizedBox.shrink for unidentified plants
(display-only, no reconcile). **Phase 2 offline portion COMPLETE.** REMAINING Phase 2 (deferred to Phase 3 territory): Laravel
catalog backend + delta sync.

**Notification-tap deep-link ✅** — reminder payload already carried `userPlantId` (stamped by
OccurrenceBuilder); added pure `notificationRouteFor(payload)` in router.dart (payload→`/plant/{id}`,
null/blank→null, TDD'd 3 tests). Adapter `init({onTap})` wires `onDidReceiveNotificationResponse`;
`notificationLaunchPayload()` reads `getNotificationAppLaunchDetails` for cold-start taps. main.dart
bootstrap: warm tap → `router.go`; cold-start → post-frame `router.go`. Device-integration wiring is
analyze/build-verified (not unit-testable). 56 tests green, analyze clean, **debug APK builds**.

**Phase 1 tail still open:** iOS BGTaskScheduler (the iOS counterpart to Android's workmanager
periodic reconcile).

**Phase 3 STARTED — council-driven, CLIENT-FIRST.** Convened a 4-lens advisory council (product/
release, backend-sync architect, solo-dev velocity, compliance) on "iOS tail vs start Phase 3." Split
verdict; synthesis = build the client-side sync foundation FIRST (pure-Dart, TDD, no backend), defer
Laravel until the wire contract is frozen as Dart types + golden fixtures. Two lenses independently
converged on the exact same first slice AND the same defect (Outbox unused; mutations non-transactional).
Deferred consciously: iOS BGTask + notification-fires-offline + Android-reboot verification → ONE later
physical-device session (don't do device-only work piecemeal now). Parallel non-code track recommended
to user: start Play closed-testing prep (12 testers/14-day clock) + add still-missing
`ios/Runner/PrivacyInfo.xcprivacy`.

**Slice 3.0 ✅ — the Outbox invariant.** Every mutation now appends exactly one `OutboxEntries` row per
row it writes, IN THE SAME TRANSACTION (so no committed local mutation is invisible to the server).
Shared `lib/core/data/sync/outbox_writer.dart` `OutboxWriter.upsert(entity, entityId, attrs, clientUpdatedAt)`
— single enqueue convention (op='upsert', jsonEncode payload snapshot via row.toJson() with
DateTime→UTC-ISO toEncodable, createdAt = LWW client_updated_at, baseRev null until server-known).
Wired + made transactional: CareRepository (addPlant, logCare, addSchedule, snooze, deactivateSchedule)
and RoomsRepository (addRoom; assignPlantToRoom enqueues under 'user_plants' since it mutates the plant).
Atomicity proven by a fault-injection test: a `_CollidingUuid` (noSuchMethod stub) forces the fertilize
schedule to collide on PK mid-transaction → plant+water rows AND their Outbox entries all roll back.
No schema change (OutboxEntries/SyncCursors/SyncState/version/tombstones already existed from Phase 0).
63 tests green, analyze clean, **debug APK builds**.

**Slice 3.1 ✅ — the SyncEngine, backend-free, TDD'd vs a fake.** Schema **v4**: added nullable
`serverRev` (rev watermark) to UserPlants/CareSchedules/CareLogs/Rooms (migration addColumn ×4).
`lib/core/domain/ports/sync_api_port.dart` — pure wire contract: SyncMutation/SyncChange/SyncPushEntry/
SyncPushResult/SyncPullResult + `SyncApiPort{push, pull}`. `test/support/fake_sync_api.dart` `FakeSyncApi`
(in-memory server = executable spec: monotonic rev, rev>since ASC pull w/ limit+hasMore cursor, care_logs
insert-if-not-exists idempotency, LWW-by-clientUpdatedAt w/ winner echo, no FK enforcement; `seedRemote`
test helper) — 6 contract tests. `lib/core/data/sync/sync_engine.dart` `SyncEngine{sync()→SyncReport}`:
PUSH (coalesce Outbox to latest-per-row, baseRev=current serverRev, push, stamp serverRev on accepted,
record server-wins in `conflicts` — winner absorbed via pull, drain Outbox) then PULL (apply changes
rev>cursor page-by-page, insertOnConflictUpdate via row.fromJson+copyWith(serverRev,sync=synced), soft-
delete tombstones, advance SyncCursors 'sync' key — all in txn). Round-trip via Drift toJson/fromJson
(DateTime=epoch-int default serializer, symmetric; simplified OutboxWriter's dead toEncodable). 6 engine
tests: push-drains-stamps, pull-applies-remote, idempotent double-sync, server-wins-conflict-surfaced+
winner-applied, out-of-order-FK, tombstone-soft-delete. NO app/provider wiring yet (fake in test/ only;
shipping app unchanged). 75 tests green, analyze clean, **debug APK builds**.
NOTE (env): dev disk was 100% full mid-slice → removed regenerable `build/` to unblock; Data volume
still 99% (~6Gi free). User's ~/.gradle/caches=29G + Xcode DerivedData=12G are the obvious reclaim
targets but NOT cleared (their machine/other projects — their call).

**Slice 3.2 ✅ — anon→auth Outbox flush, backend-free, TDD'd vs the fake.** `lib/core/data/sync/
anon_auth_flush.dart` `AnonAuthFlush{db, engine}.flush() → SyncReport` = `_stageUnsyncedRows()` then
`engine.sync()`. `_stageUnsyncedRows()` (one txn) re-derives what to sync from the DURABLE truth
`serverRev IS NULL` (NOT from the Outbox — completeness is a data property, not a bet the queue was
never pruned): iterate userPlants/careSchedules/careLogs/rooms, `where serverRev.isNull()` (+ live
`deletedAt.isNull()` for the three soft-delete tables; careSchedules has no deletedAt — uses `active`
flag — so filters serverRev alone), `_outbox.upsert(entity, row.id, row.toJson(), row.updatedAt)`.
Idempotency falls out of two independent mechanisms: post-sync `serverRev` stamp removes rows from the
`isNull()` filter (replay stages nothing → pushed==0) + OutboxWriter coalesces per-row (dedupes any
overlap). No id remap (UUID v7 client PKs canonical → pure INSERT). 4 tests: full flush (plant+schedule+
room, pushed==3, Outbox drained, serverRev stamped), re-stages after Outbox deleted (completeness not
Outbox-trust), idempotent double-flush (pushed==0, no dup), does-not-re-push-acknowledged (only new
work, first row's serverRev untouched). NO schema/native change over 3.1 (pure-Dart, same v4) → native
rung skipped as redundant (3.1 already built APK). 79 tests green, analyze clean.

**Slice 3.3 ✅ — Laravel sync backend, TDD'd vs the golden contract.** NEW separate repo (its own
git) at `../plantner-backend/` (sibling to `plant_care_reminder/`). Stack on this machine: PHP 8.5.7
(Homebrew) + Composer 2.10 + **Laravel 13.18** + Sanctum 4.3 (all newer than plan's 12/8.3, fine).
MySQL 9.6 installed but NOT running — irrelevant: tests use **SQLite `:memory:`** (Laravel's default
phpunit.xml, zero setup). Data volume now 37Gi free (user reclaimed space since 3.1). Laravel 13 quirks:
User model uses PHP attributes `#[Fillable]`/`#[Hidden]` not properties; config in `bootstrap/app.php`;
`php artisan install:api` scaffolds routes/api.php + Sanctum. Schema: `sync_state` singleton
(`current_rev` counter, seeded 0) + 4 uniform syncable tables (rooms/user_plants/care_schedules/
care_logs) each = id, uuid(unique char36), user_id(FK, the ONLY FK), rev, client_updated_at(epoch-ms),
attributes(json, full row snapshot), deleted_at(nullable timestamp tombstone — plain column, NOT
Eloquent SoftDeletes so tombstones aren't hidden from pull), index(user_id,rev). NO cross-entity FKs
(species_uuid/room_uuid/userPlantId live inside attributes) → FK-out-of-order tolerance is automatic.
`SyncController` (query-builder, ENTITIES whitelist map, no Eloquent models yet): `GET /api/v1/sync/
changes?since=&limit=` = UNION-all across the 4 tables where rev>since, order rev ASC, limit+1 to detect
has_more, next_rev=last page rev; `POST /api/v1/sync/mutations` = per-mutation in ONE txn: care_logs+
existing→no-op echo existing rev; existing && rev!=base_rev→LWW by client_updated_at (win=write+new rev,
lose=accepted:false + winner echo); else write. Global rev via `nextRev()` = lockForUpdate on
sync_state row (held within push txn; no-op lock on SQLite but single-threaded tests fine). Added
`HasApiTokens` to User (for 3.4 token issuance). **Wire JSON format PINNED** in `plantner-backend/docs/
SYNC_CONTRACT.md` — snake_case keys (base_rev/client_updated_at/next_rev/has_more), epoch-ms ints; the
Dart dio adapter (3.4) must serialize to this exactly (camelCase↔snake_case at boundary). 8 SyncTest
feature tests (push-insert+pull, cursor/ordering+hasMore paging, care_logs idempotency, stale-loses-LWW+
winner-echo, newer-wins-LWW, FK-out-of-order, delete-tombstone, auth-required) replaying the fake's
scenarios; 10 total green (`php artisan test`), Pint clean. 2 commits on backend `main`. NO OAuth/
account-delete/catalog yet (later slices). Client side unchanged (fake still the only adapter in Flutter).

**Slice 3.4 PARTIAL — backend social-auth ✅ (client dio adapter + real verifiers PENDING dep approval).**
Done (backend, TDD'd, no new deps): `POST /api/v1/auth/social` {provider,token} → verify via injected
`SocialIdentityVerifier` port (App\Services\Auth\) → find-or-create user by provider **subject (NOT
email)** → issue Sanctum token; returns {token, user:{id,email,name}}. `social_accounts` table
(unique(provider,provider_user_id)); made users.email + users.password **nullable** (Apple relay withholds
email / social-only accounts have no password; unique allows multi-NULL). `SocialIdentity` readonly VO
(subject/email?/name?). Route is PUBLIC (outside auth:sanctum group). **Account-linking policy DECIDED:
separate account per provider, NO auto-link by email** (avoids account-takeover vector; safe MVP default —
user was away when asked, took recommended). **Fail-closed hardening:** `NullSocialIdentityVerifier`
bound as default in AppServiceProvider::register (rejects all → 401), else unconfigured deploy threw a
container 500. Tests: 7 SocialAuthTest (new-user, same-subject-dedupe, token-authorizes-/sync,
invalid-token-401, apple-null-email, bad-provider-422, fail-closed-default) via an in-test fake verifier.
17 total green (`php artisan test`), Pint clean, 2 commits (backend now 4 commits on main).
**Slice 3.4 BACKEND FULLY ✅ — real Google/Apple verifiers done.** Installed `firebase/php-jwt` ^7.1
(user approved "both deps, backend first"). `JwtSocialIdentityVerifier` (App\Services\Auth\): JWT::decode
(RS256 sig + exp) then assert iss ∈ config issuers + aud ∩ config audiences + non-empty sub → SocialIdentity;
any failure→null→401. `JwksProvider` port + `HttpJwksProvider` (fetch provider JWKS, cache RAW json not Key
objects [Key wraps unserializable OpenSSL handle], failures NOT cached, JWK::parseKeySet default RS256).
`config/social.php` (google/apple jwks_url+issuers+audiences; audiences from GOOGLE_CLIENT_IDS/
APPLE_CLIENT_IDS env, comma-split; added to .env.example). AppServiceProvider binds real verifier ONLY if
some provider has non-empty audiences, else NullVerifier (fail-closed) — so test env (no client IDs) stays
Null, all endpoint tests hermetic. Tests: 7 JwtSocialIdentityVerifierTest (self-minted RSA keypair signs
tokens; valid + forged-key/wrong-aud/wrong-iss/expired/unconfigured-provider/apple-no-email), 4
HttpJwksProviderTest (Http::fake: parse, cache-no-refetch, unknown-provider-no-http, failed-fetch-not-
cached), 2 SocialVerifierBindingTest (configured→real, unconfigured→Null). **30 backend tests green, Pint
clean, 5 commits on main.** BACKEND for Phase 3 sync+auth is COMPLETE (3.5 account-delete still pending).

**Slice 3.4 CLIENT dio adapter ✅ (built + tested; NOT wired into app yet).** Added deps `dio` (^5) +
`flutter_secure_storage` 10.3.1 to plant_care_reminder (user pre-approved both). Built + TDD'd:
`lib/core/data/sync/dio_sync_api.dart` `DioSyncApi implements SyncApiPort` — POST `sync/mutations` / GET
`sync/changes` (relative paths; caller's Dio baseUrl = `…/api/v1/`), serializes to SYNC_CONTRACT.md
(snake_case base_rev/client_updated_at/next_rev/has_more, epoch-ms via .millisecondsSinceEpoch,
reconstruct DateTime.fromMillisecondsSinceEpoch(isUtc:true)). `token_store.dart` `TokenStore` pure port +
`secure_token_store.dart` `SecureTokenStore` (FlutterSecureStorage, key 'sanctum_token'; v10 auto-secures
Android — removed deprecated encryptedSharedPreferences opt). `auth_interceptor.dart` `AuthInterceptor`
(reads TokenStore, adds `Authorization: Bearer` when present, omits when signed out). Tests: 4
dio_sync_api_test (push serialize+parse accepted, push winner-echo, pull since+limit+cursor, pull
tombstone) via hand-rolled fake `HttpClientAdapter` capturing request body + returning canned JSON (NO
backend, NO extra dep); 2 auth_interceptor_test (header present/absent). **85 Flutter tests green, analyze
clean.** CORRECTION (2026-07-03): plant_care_reminder IS a git repo (flutter create init'd it) with remote
`origin` = github.com/noumanzindani/Plant-Care-Reminder.git, branch `main`. Earlier "not a git repo /
uncommitted" notes were STALE — all client work was already committed ("added worked to git" de7977a) and
pushed by the user during a break. (The sibling backend `plantner-backend/` is its own separate repo.)
**Slice 3.4 SYNC WIRING ✅ (provider graph + connectivity gate; NOT yet triggered/authed).** Added dep
`connectivity_plus`. `ConnectivityPort` (domain port) + `ConnectivityPlusAdapter` (any transport != none).
`lib/core/data/sync/sync_service.dart` `SyncService{engine, connectivity, tokens}.syncNow()→SyncReport?`
= gate: offline→null, no token (anonymous)→null, else engine.sync(). TDD'd 3 tests (online+token drains
Outbox; offline leaves Outbox intact + pushCalls==0; anonymous skips). `lib/app/sync_providers.dart` wires
the whole graph: tokenStoreProvider(SecureTokenStore), syncDioProvider (Dio baseUrl=`String.fromEnvironment
('SYNC_BASE_URL', default 'http://10.0.2.2:8000/api/v1/')` [Android-emu→host; override via --dart-define] +
AuthInterceptor), syncApiProvider(DioSyncApi — THE fake→dio swap point), connectivityProvider,
syncEngineProvider, syncServiceProvider. **88 Flutter tests green, analyze clean, debug APK builds** (dio +
flutter_secure_storage + connectivity_plus all compile natively). Graph composes but nothing INVOKES
syncNow() yet + no token is ever stored → currently always no-ops (correct until sign-in exists).
**Slice 3.4 SIGN-IN ORCHESTRATION ✅ (testable backbone; SDK edge + UI still pending).** No new deps (dio
only). Ports `lib/core/domain/ports/social_auth.dart`: `AuthSession`(token,userId,email?,name?),
`SocialSignIn.obtainToken(provider)→String?` (null=cancel; real adapters wrap google_sign_in/
sign_in_with_apple SDKs — NOT built), `SocialAuthClient.exchange({provider,token})→AuthSession`.
`lib/core/data/auth/auth_api.dart` `AuthApi implements SocialAuthClient` (dio POST `auth/social`, parses
{token,user:{id→String,email?,name?}}) — 2 tests via fake HttpClientAdapter. `lib/core/data/auth/
auth_service.dart` `AuthService{signIn,authClient,tokens,flush}.signIn(provider)→AuthSession?` = obtain→
(null?no-op:exchange→tokens.write→flush.flush()), `signOut()=tokens.clear()`. Order matters: store token
BEFORE flush (flush syncs over HTTP needing the bearer). 3 tests (success stores token + anon plant reaches
FakeSyncApi; cancel = no token no flush; signOut clears) using fakes + REAL AnonAuthFlush vs FakeSyncApi.
**93 Flutter tests green, analyze clean.** ENTIRE testable Dart surface of Phase-3 sync+auth now DONE.
**Lifecycle trigger ✅** — `app.dart` `_PlantCareAppState.didChangeAppLifecycleState` (existing resume
observer that already calls reconcile) now ALSO fires `ref.read(syncServiceProvider).syncNow().catchError(
(_)=>null)` on resume — opportunistic sync, safe no-op until signed in+online (SyncService gates), errors
swallowed (next resume retries). First time the running app's widget tree references the sync graph; 93
tests green, analyze clean, **debug APK builds** with it wired in. (Connectivity-regained-while-foregrounded
trigger = noted optional refinement, NOT added — resume + post-sign-in flush cover the common paths.)
**REMAINING 3.4 tail (needs MORE deps + native config + manual, NOT done):** (a) real SocialSignIn adapters =
google_sign_in + sign_in_with_apple deps (approve) + native config (Google OAuth client IDs, Apple capability)
+ sign-in UI wired to AuthService + authServiceProvider (blocked: needs the SDK adapter to exist) → the ONLY
non-testable-here classes;
(b) lifecycle trigger: call syncService.syncNow() on foreground/resume + on connectivity-regained (hook into
existing ReconcileCoordinator or app WidgetsBindingObserver); (c) two-device manual test vs running
`php artisan serve` (set SYNC_BASE_URL, Android needs cleartext-http exception for local dev) — the one
genuinely non-TDD-able bit; (d) `/sync/bootstrap` (minor). Lifecycle trigger committed+pushed as `8453d02`
("feat: trigger opportunistic sync on app resume") to origin/main — Flutter app IS versioned (see correction above).

**Slice order (remaining):** 3.4 tail = Flutter dio adapter (above). 3.5 = DELETE /account + PurgeUserJob. [superseded original 3.3 note below:]
3.3 = Laravel (migrations uuid/rev/deleted_at/
client_updated_at, Sanctum, /sync/changes + /sync/mutations satisfying the SAME contract, replay fake's
golden vectors as feature tests; global rev via sequence/Redis INCR). 3.4 = Google/Apple OAuth +
/sync/bootstrap + swap fake→dio + two-device manual test. 3.5 = DELETE /account + PurgeUserJob.
**Open decision for 3.1:** whole-row vs field-level LWW for plant metadata — MVP accepts whole-row LWW
ONLY if the loser is surfaced as a conflict, never silently dropped. **Compliance musts baked into 3.3-3.5:**
account deletion (in-app + public web URL), Sign-in-with-Apple parity, tokens in flutter_secure_storage
(NOT SharedPreferences — a new dep to approve), HTTPS-only/no ATS weakening, no PII/token logging,
Pl@ntNet key server-side only. Then Phases 4-8.

**PHASE 5 STARTED (2026-07-03) — Slice 5.1 weather overlay ✅ (pure fn, NO deps, NOT yet wired).**
`lib/core/domain/services/weather_policy.dart`: `WeatherForecast` VO (expectedRainMm, highTempC,
humidityPct — the WeatherPort adapter maps Open-Meteo INTO this; policy knows no HTTP) + `WeatherPolicy.
adjust({baseDue, forecast, outdoor}) → tz.TZDateTime`. Overlay-on-read (never mutates schedule), operates
on the CadenceEngine's OUTPUT instant. Rules ("**Balanced**" preset — I chose it autonomously; user was
away for the sensitivity AskUserQuestion; 6 named constants = one-place retune to Conservative/Responsive):
rain OUTDOOR only +3d per full 10mm; highTempC≥30 −1d; humidityPct≤30 −1d; net `.clamp(-2, +5)` days
safety bound (upper reachable via heavy rain; lower a forward guard — factors only total −2 today). DST-safe
day shift via TZDateTime ctor (same trick as CadenceEngine). TDD'd red→green 7 tests (identity, rain-delay,
indoor-ignores-rain [proved by strip/restore of the outdoor guard], heat, dry, heat+dry stack, upper-clamp);
refactored magic numbers→constants staying green. **100 Flutter tests green, analyze clean.** Committed+pushed
as `b9db7fa` (feat: add weather-adaptive care overlay).
**Slice 5.2a ✅ (reconciler wiring; NO new deps).** Moved `WeatherForecast` VO → `value_objects/
weather_forecast.dart` (weather_policy.dart re-exports it, so existing importers unchanged). New port
`lib/core/domain/ports/weather_port.dart` `WeatherPort { Future<WeatherForecast?> forecast(); }` (null =
offline/denied/stale → fall back to base cadence). `OccurrenceBuilder` gained OPTIONAL ctor params
`{WeatherPort? weather, WeatherPolicy weatherPolicy = const WeatherPolicy()}` (null WeatherPort = today's
exact behavior → existing 4 tests + reconcile_coordinator.dart:27 call site unchanged), left-joins `rooms`
for the `outdoor` flag, applies overlay ONLY to `schedule.weatherSensitive` schedules, order = engine →
weather → snooze (snooze stays final user-intent layer). TDD'd 4 new tests vs a fake WeatherPort (rain-defers-
outdoor, non-sensitive-ignores [drove the guard], null-forecast→base, indoor-ignores-rain [teeth proved by
strip/restore of `outdoor: room?.outdoor ?? false`]). **104 Flutter tests green, analyze clean.** NOT yet
committed. **Slice 5.2b-i ✅ (Open-Meteo adapter; NO new dep).** `lib/core/domain/value_objects/geo_coordinates.dart`
`GeoCoordinates{latitude,longitude}` + `lib/core/domain/ports/location_port.dart` `LocationPort {
Future<GeoCoordinates?> current(); }` (null = denied/off/no-fix). `lib/core/data/weather/
open_meteo_weather_adapter.dart` `OpenMeteoWeatherAdapter implements WeatherPort`, ctor `(Dio, LocationPort)`.
`forecast()`: resolve coords (null→null, NO http call), GET api.open-meteo.com/v1/forecast
?daily=precipitation_sum,temperature_2m_max&hourly=relative_humidity_2m&forecast_days=2&timezone=auto,
summarise → WeatherForecast (rain=Σ daily precip; highTemp=max daily tmax; humidity=MIN hourly RH = driest
hour). try/catch → null on any failure (offline/500/malformed) = degrade to base cadence. TDD'd 4 tests via
fake HttpClientAdapter (reused dio_sync_api_test pattern) + fake LocationPort: mapping+request-contract,
no-location→null+0 calls (teeth = null-safety compiler REFUSES to build w/o the guard), 500→null,
malformed→null. **108 Flutter tests green, analyze clean.** Committed? NO (awaiting nod).
**Slice 5.2b-cache ✅ (CachingWeatherPort; NO new dep).** `lib/core/data/weather/caching_weather_port.dart`
`CachingWeatherPort implements WeatherPort` wraps inner WeatherPort + Clock, default TTL 3h; serves cached
forecast within TTL (dedupes rapid reconciles), refetches after expiry, NEVER serves null from cache (read
guard requires non-null → failures retry next reconcile). TDD'd 3 tests (fake Clock + scripted inner):
fresh-dedupes, expiry-refetch (teeth via strip of TTL check), null-not-served; removed a redundant success-
guard so every branch is test-driven. Committed `239780f`. **111 Flutter tests green, analyze clean.**
**ENTIRE no-dep testable weather core now DONE** (policy + overlay wiring + Open-Meteo adapter + TTL cache).
**Slice 5.2b FLIP-ON ✅ (2026-07-04, local commit `17a71e4`) — weather overlay is LIVE in the app.**
Added dep `geolocator` ^14.0.3 (pre-approved). `lib/core/infra/location/geolocator_location_adapter.dart`
`GeolocatorLocationAdapter implements LocationPort` (const): serviceEnabled→checkPermission→request→
getCurrentPosition(LocationSettings accuracy=low[coarse], timeLimit 10s)→GeoCoordinates; whole body in
try/catch → null on ANY failure (services off/denied/deniedForever/no-fix/timeout) per port contract =
degrade to base cadence. Plugin edge = analyze/build-verified (wraps static platform channels), NOT unit-
tested (downstream OpenMeteo/overlay/cache already are). **`ReconcileCoordinator` gained optional `WeatherPort?
weather` param → forwards to `OccurrenceBuilder(db, engine, weather:)`** — TDD'd (RED=missing param; test:
12mm rain defers outdoor weather-sensitive watering 06-08→06-11, provable only if forwarded). `lib/app/
providers.dart`: `locationPortProvider`(GeolocatorLocationAdapter), `weatherPortProvider`(CachingWeatherPort
over OpenMeteoWeatherAdapter(new bare `Dio()` — NO AuthInterceptor, public API + `SystemClock`)), injected
`weather:` into `reconcileCoordinatorProvider`. So EVERY FOREGROUND reconcile now applies the overlay (bg
isolate `background_reconcile.dart` still weather-free — bg location unreliable, null-tolerant, next resume
applies it). Native: Android `ACCESS_COARSE_LOCATION` in main AndroidManifest; iOS `NSLocationWhenInUseUsage
Description` in Info.plist (both optional). geolocator also regenerated macos/windows plugin registrants
(folded into commit). **135 tests green, analyze clean, debug APK builds (73s).** ONLY remaining: real-device
verification (location ON → live Open-Meteo forecast actually shifts a due date) — hardware-only, can't do here.
Also NOT done: mark a schedule weatherSensitive + a plant outdoor from the UI (currently only settable via
seed/DB — needs a PlantDetail toggle to expose the feature to users).
**Slice 5.2c ✅ (2026-07-04, local commit `fb62e97`) — weather opt-in now REACHABLE in the UI.**
`CareRepository.setWeatherSensitive(scheduleId, bool)` + `RoomsRepository.setRoomOutdoor({roomId, outdoor})` —
transactional + Outbox (entity 'care_schedules'/'rooms'), TDD'd. `CareQueueItem` gained `weatherSensitive`
(DEFAULTED false so existing widget-test constructions + call sites untouched), populated in `_toCareQueueItems`
(read model the detail screen renders from). PlantDetail (`lib/features/plants/presentation/plant_detail_screen.dart`):
`_ScheduleTile` now a Column — the care ListTile + a `SwitchListTile` "Weather-adaptive" shown ONLY for
`CareType.water` (overlay is watering-centric; noise on fertilize/mist) + Divider; `_OutdoorTile` (new
ConsumerWidget after `_RoomTile`) = SwitchListTile "Outdoor" bound to the plant's ROOM.outdoor (outdoor is a
room property — balcony outdoors for all its plants — so hidden until a room is assigned). Both toggles = mutate
then `reconcileCoordinatorProvider.reconcile()`, same pattern as add/remove care type. TDDّd: 2 repo persistence/
Outbox tests + read-model-surfaces-flag test + 2 widget tests (both toggles render ON for outdoor water schedule;
no toggle on non-water) — rendering-only per project convention (widget tests check render, data tests check
mutation; matches _remove/reconcile also not widget-tested). **140 tests green, analyze clean, debug APK builds.**
Weather feature now FULLY usable: user assigns plant to a room → toggles room Outdoor → toggles a water schedule
Weather-adaptive → next reconcile applies the Open-Meteo overlay. ONLY remaining weather gap = real-device
verification (location fix → live forecast shifts a due date). **GIT: local main now 5 ahead of origin
(762cc2f,1d04fe6,b4d4830,17a71e4,fb62e97), all UNPUSHED pending owner's literal "push to main".** **PRIORITY NOTE:** owner wants free/local +
ADS revenue (run-free-local-first-ads) → after weather, bring Phase 6 (AdMob) forward.

**PHASE 6 STARTED (2026-07-03) — pivoted here on owner's "ads make me money" signal (they were away for
the fork AskUserQuestion; I chose the ads testable core as most-aligned + fully reversible). Slice 6.1
AdFrequencyController ✅ (pure, NO dep).** `lib/features/ads/domain/ad_frequency_controller.dart` — pure
interstitial pacing policy, DateTime-driven (no Clock/plugin): ctor `{sessionStart, minSinceStart=60s,
minInterval=90s, maxPerSession=4}`; `canShowInterstitial(now)` = false if within cold-start grace OR
session cap hit OR within minInterval of last shown, else true; `recordInterstitialShown(now)` bumps
_lastShownAt + _shownThisSession. TDD'd 5 tests (cold-start block, allow-after-grace, interval block,
interval reopen, session cap). Committed `646484d`. **116 Flutter tests green, analyze clean.**
**Slice 6.2 ✅ (AdGate + AdPort + InterstitialAdManager; pure, NO dep; TDD'd; NOT yet committed).**
`lib/features/ads/domain/ad_surface.dart` `enum AdSurface` encodes the plan's ad-free HARD RULE as
data via `bool get allowsAds` (false for onboarding/scanner/paywall/reminderCompletion/account/
pushLanding; true for plantList/speciesBrowse/journal/communityFeed). `ad_gate.dart` `AdGate` (const,
stateless, pure) = the single "may I show an ad?" authority, layers 3 orthogonal gates in authority
order: entitlement (`isPremium`→zero ads, checked first, cheapest+absolute) → surface (`allowsAds`) →
frequency (interstitial-ONLY, delegates to existing AdFrequencyController). `showBanner(surface,
isPremium)` never even receives the frequency ctrl (type encodes "banners are persistent"); `show
Interstitial(surface, isPremium, frequency, now)`. Client models entitlement as a bare `bool isPremium`
for now (plan: ads gated ENTIRELY behind isPremium ⟺ ad-free; a richer Entitlements VO waits for IAP).
`ad_port.dart` `abstract interface class AdPort {loadInterstitial(); showInterstitialIfReady()→bool}`
(imperative, interstitial-only — banners are widgets, no port). `application/interstitial_ad_manager.dart`
`InterstitialAdManager{port, frequency, gate}.maybeShow(surface, isPremium, now)→bool` = ask gate; if no
→ return false WITHOUT waking the SDK; else port.showInterstitialIfReady(); **record frequency ONLY if
an ad actually rendered** (no-fill must NOT consume the pacing budget = revenue-leak guard). New
`application/` layer under features/ads (use-case orchestration, mirrors sync's SyncService-over-port
split). TDD'd 12 tests (8 ad_gate: premium-blocks-banner/interstitial, ad-free-surface-blocks-both,
free-user-browse-banner, natural-break-interstitial, delegates-pacing-cold-start, banner-ignores-freq;
4 manager via `test/support/fake_ad_port.dart` FakeAdPort: gate-no→no-SDK-call, show+record, no-fill-
doesn't-consume-budget, successful-show-paces-next). **128 Flutter tests green, analyze clean.**
Slice 6.2 committed+pushed? COMMITTED `762cc2f` on local main; **push to origin BLOCKED** by auto-mode
classifier (bare "yes" ≠ explicit push-to-default-branch authorization) — needs owner to say literally
"push to main". So local main is AHEAD of origin by 6.2 (+later slices) until then.
**Slice 6.3 ✅ (RewardedUnlockPolicy; pure, NO dep; TDD'd).** `lib/features/ads/domain/rewarded_unlock_
policy.dart`: `enum RewardedUnlockAvailability {offer, hasCredits, dailyCapReached, premium}` +
`RewardedUnlockPolicy{maxUnlocksPerDay=5}.evaluate({scanCreditsRemaining, rewardedUnlocksToday, isPremium})`.
Decides ONLY whether to OFFER the "watch to unlock 1 AI scan" path (returns a reason for the UI); NEVER
grants — grant is server-authoritative (AdMob SSV→Laravel increments quota, client re-reads; plan §305-308,
tamper-test §425), so no credit is minted on-device. Precedence (UX-correctness, not style): premium →
hasCredits(remaining>0) → dailyCapReached(today≥max, inclusive) → offer. TDD'd 6 tests (offer, hasCredits,
dailyCap, premium-never, premium-precedence-over-cap, cap-boundary 4→offer/5→capped). **134 Flutter tests
green, analyze clean. NOT committed yet.** The rewarded AD PORT + show-flow + SSV re-read wait for Phase 4
backend (AI-ID) which isn't built — building only the offer policy keeps the slice honest (no client grant stub).
**Slice 6.4 ✅ (ad provider graph; NO dep; local commit `b4d4830`).** `lib/app/ad_providers.dart` mirrors
sync_providers.dart: `isPremiumProvider`(Provider<bool>=false, free-tier default; TODO read server
`users.is_premium` once signed-in user state exposed), `adGateProvider`(const AdGate), `adFrequency
ControllerProvider`(sessionStart=DateTime.now() at first read), `adPortProvider`(=NoopAdPort — THE swap
point), `interstitialAdManagerProvider`(composes port+freq+gate). `lib/features/ads/data/noop_ad_port.dart`
`NoopAdPort implements AdPort` (never fills → app runs w/ zero ad behavior until real adapter swapped in).
Placement-agnostic: NO screen references these yet (banner/interstitial call sites await owner placement
decision). Provider wiring = config (TDD exception + matches sync_providers having no test). Analyze clean,
134 tests green. **GIT STATE (as of 2026-07-04): local main is 4 commits AHEAD of origin (762cc2f, 1d04fe6, b4d4830, 17a71e4) —
all UNPUSHED (push to default branch blocked pending owner's literal "push to main"). 6.1 `646484d` already on origin.**
**BLIND-BUILDABLE PHASE 6 CORE NOW EXHAUSTED** — every remaining step needs owner input: placement answers
(banner on which screens / interstitial on which transition), AdMob account+app IDs, or a new dep+native config.
Next pure-testable elsewhere: native-in-feed pacing (needs Phase 7). PLUGIN/ACCOUNT EDGE unchanged (needs owner's AdMob acct + app IDs):
real google_mobile_ads adapter (AdPort impl), AdMob app IDs in native config (Android APPLICATION_ID meta —
OMISSION CRASHES ON START, plan blocker #7), iOS GADApplicationIdentifier+SKAdNetwork, UMP+ATT, rewarded SSV
grant endpoint (Phase 4 backend). UI WIRING (needs owner's placement answers — asked, UNANSWERED): banner on
which browse screens + interstitial on which transition. **OPEN PRODUCT DECISIONS (asked 2026-07-03, owner
away, UNANSWERED):** (a) monetization model — I'm defaulting to plan's ads+Premium but ads ship first/standalone
(isPremium=false until IAP); (b) exact placements; (c) confirm freq 60s/90s/4. None block code built so far. PLUGIN/ACCOUNT EDGE
(needs owner's AdMob account + app IDs, like the OAuth creds gap): real `google_mobile_ads` adapter, AdMob
app IDs in native config (Android APPLICATION_ID meta — OMISSION CRASHES ON START per plan blocker #7), iOS
GADApplicationIdentifier+SKAdNetwork, UMP consent + ATT, rewarded-SSV grant endpoint. Ad-free surfaces +
freq rules already specced in plan §C. **OPEN PRODUCT DECISIONS for owner:** (a) is there a paid 'remove ads /
premium' tier or ads-for-everyone? (b) exact ad placements (banner on list screens, interstitial on which
transitions, native in-feed later w/ community) (c) confirm frequency numbers (60s grace/90s gap/4 per session).
Also STILL PENDING from Phase 5: geolocator dep + native location config to flip weather overlay ON. Light meter = later 5.x slice
(camera Y-plane lux → LightMeterPort).

---

## Owner mandate — run free, local-first, ads

The owner wants Plant Care Reminder to (1) work fully on **local data with NO backend
required** so it can be **run for free** (no server/hosting bills), and (2) make money via
**ads** (AdMob). Stated 2026-07-03: "app initially work on local data with[out] any backend,
i want to run it for free and want to add ads which make me money, so keep it in this way."

**Why:** revenue goal is ad income with near-zero running cost; a paid always-on backend
would eat the margin. This sharpens the already-locked offline-first principle into a
hosting/monetization mandate.

**How to apply:**
- Keep every cloud feature an OPTIONAL, null-tolerant overlay (already true: no token → no
  sync, app fully works locally; weather via Open-Meteo is free + keyless + called direct
  from the client, no proxy). Never make the core loop depend on a server.
- The Laravel backend (plant-care-reminder-project Phase 3) stays optional/deferred —
  don't require the owner to host it to ship or run the app.
- The ONE feature that genuinely needs a server is Pl@ntNet AI identify (Phase 4) because the
  API key must be server-side. Flag it as optional/premium or a free-tier serverless function;
  don't let it become a mandatory cost. Same for rewarded-ad SSV grants (need an endpoint).
- Bring **Phase 6 (ads/AdMob + UMP consent)** forward as a priority since ads are the revenue
  engine; it can precede the backend-dependent Phase 4. Confirm gating with the owner.
- Ads must follow the plan's ad-free surfaces + frequency rules (see plant-care-reminder-project).
