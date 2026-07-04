# CLAUDE.md — Plantner (Plant Care Reminder)

Guidance for Claude Code (and humans) working in this repo. This file is loaded
automatically by Claude Code, so a fresh clone gets the full project context. The
exhaustive decision/progress log lives in [`docs/PROJECT_MEMORY.md`](docs/PROJECT_MEMORY.md).

## What this is

**Plantner** is a greenfield Flutter app — a full competitor to Planta / Greg / PlantIn.
The core loop is: **add plant → schedule care → local reminders → log care**.

- **App id / bundle id (permanent):** `co.appverra.plantner` (app name "Plantner", appverra.co)
- **This repo:** the Flutter client (`plant_care_reminder`), git remote
  `github.com/noumanzindani/Plant-Care-Reminder`, branch `main`.
- **Backend:** a **separate** repo, `plantner-backend/` (sibling directory) — Laravel 13 +
  Sanctum delta-sync + social auth. Optional by design (see mandate below).

## Non-negotiable principles

1. **Offline-first, no account required.** The core loop must work fully offline. Every
   cloud feature (sync, auth, weather, AI ID) is a null-tolerant *port/adapter overlay*
   layered on top — never a dependency of the core loop.
2. **Run for free, monetize with ads.** The owner's mandate: the app must run at near-zero
   hosting cost. The Laravel backend stays optional/deferred; don't require hosting it to
   ship or run. Revenue is AdMob ads (+ optional Premium). The one feature that genuinely
   needs a server is Pl@ntNet AI identify (key must be server-side) — keep it optional/
   premium, never a mandatory cost.

## Architecture (load-bearing decisions — do not casually revisit)

- **Drift/SQLite is the single source of truth.** Riverpod for state.
- **Client-generated UUID v7 keys** are canonical; the backend accepts them as-is, which
  makes anon→auth a pure Outbox flush (no id remap).
- **Append-only care logs** (conflict-free history that re-anchors a schedule's next due).
- **Rolling 56-notification window reconciler** for the reminder engine (iOS 64-notif cap).
- **Delta sync** via a monotonic server `rev` watermark; every local mutation appends one
  `OutboxEntries` row *in the same transaction* (no committed mutation invisible to server).
- **Server-authoritative entitlements** (`users.is_premium`) and rewarded-ad grants (AdMob
  SSV → Laravel increments quota → client re-reads; the client never mints a credit).
- **Ports & adapters everywhere** the app touches the outside world: `NotificationPort`,
  `WeatherPort`, `LocationPort`, `SyncApiPort`, `AdPort`, `Clock`, etc. Each has a fake for
  tests and a real adapter for production. This is why almost everything is unit-testable.

### Layout (`lib/`)
```
app/            provider graphs (providers.dart, sync_providers.dart, ad_providers.dart), app.dart
core/domain/    pure: services (cadence engine, reconciler, weather policy), ports, value objects
core/data/      Drift db, repositories, reminders (occurrence builder, reconcile coordinator),
                sync (engine, outbox, dio adapter), weather (open-meteo, cache), catalog, auth
core/infra/     platform adapters: notifications, location (geolocator), time (system clock), background
features/       feature slices: plants (presentation), ads (domain/data/application)
shared/         cross-feature helpers (e.g. care_type_display.dart)
```

## Conventions (non-obvious — follow these)

- **Manual Riverpod providers, NOT codegen.** `riverpod_generator`/`riverpod_lint` conflict
  with Freezed 3.x + the pinned Riverpod, so they're deliberately omitted. Drift + Freezed
  codegen stay.
- **TDD is the default.** Red → green → refactor. Ports have fakes; adapters that wrap
  platform channels (geolocator, notifications, in-app SDKs) are the *only* things that are
  "analyze/build-verified" rather than unit-tested — keep them razor-thin and defensive
  (collapse every failure to the port's null/no-op contract).
- **Never put widget tests (`testWidgets`) and pure Drift-stream tests in the SAME file.**
  `TestWidgetsFlutterBinding`'s fake clock stops Drift's real-timer stream delivery → hangs.
  Data tests get their own files. Never `pumpAndSettle` a `CircularProgressIndicator`
  (spins forever); override async/family providers with timer-free `Stream.value` stubs in
  View tests. Widget tests verify *rendering*; data tests verify *mutation*.
- **flutter_local_notifications v22 uses NAMED params:** `initialize(settings:)`,
  `cancel(id:)`, `zonedSchedule(id:, scheduledDate:, ...)`.

## Commands

```bash
flutter pub get
flutter run
flutter test                         # full suite
flutter test test/ad_gate_test.dart  # single file
flutter analyze
flutter build apk --debug            # standard native-compile check for plugin edges
```

## Phase roadmap & status

Built in shippable slices. **0 Foundation → 1 Offline core loop → 2 Catalog → 3 Accounts+sync
→ 4 AI ID → 5 Weather+light meter → 6 Monetization → 7 Community → 8 Store hardening.**

- **Phase 0 Foundation** — ✅ domain layer, Drift, Riverpod/Freezed, compliance scaffolding.
- **Phase 1 Offline core loop** — ✅ cadence engine, reconciler, reminder applier, local
  notifications, snooze, journal, multi-care-type, rooms, workmanager + reconcile-on-resume,
  notification-tap deep-link. Tail: iOS BGTaskScheduler.
- **Phase 2 Catalog** — ✅ offline species catalog (bundled seed, ~18 houseplants, smart
  defaults, species detail). Backend catalog deferred.
- **Phase 3 Accounts + delta sync** — ✅ entire testable surface: Outbox invariant, SyncEngine,
  anon→auth flush, dio adapter, Laravel backend (separate repo) with Google/Apple JWKS
  verifiers, sign-in orchestration, resume-triggered sync. Tails: real Google/Apple SDK
  adapters + sign-in UI, two-device manual test, `DELETE /account`.
- **Phase 4 AI plant ID (Pl@ntNet)** — not started (needs server-side key). Disease diagnosis
  deferred (Pl@ntNet has no disease endpoint; add Plant.id/Kindwise later, premium-gated).
- **Phase 5 Weather + light meter** — ✅ weather overlay is **live**: policy + reconciler
  wiring + Open-Meteo adapter + TTL cache + real geolocator adapter + Plant Detail opt-in
  toggles (Outdoor per-room, Weather-adaptive per-water-schedule). Remaining: real-device GPS
  verification; the light meter (camera lux → LightMeterPort) is a later slice.
- **Phase 6 Monetization (AdMob)** — 🟡 in progress. Done (pure, no SDK): AdFrequencyController,
  AdGate (entitlement→surface→frequency), AdPort seam + NoopAdPort, InterstitialAdManager,
  RewardedUnlockPolicy, ad provider graph. Needs owner: AdMob account + app IDs, placement
  decisions, real `google_mobile_ads` adapter, UMP/ATT, rewarded SSV grant endpoint.
- **Phase 7 Community / 8 Store hardening** — not started.

## Store-compliance must-dos (baked into later phases)

Account deletion (in-app + public web URL), Sign-in-with-Apple parity, tokens in
`flutter_secure_storage` (not SharedPreferences), HTTPS-only/no ATS weakening, no PII/token
logging, Pl@ntNet key server-side only, Android AdMob APPLICATION_ID in native config
(**omitting it crashes on launch**), iOS Privacy Manifest + ATT/UMP consent, target API 34+.

## Git workflow

- Conventional Commits (`feat:` / `fix:` / `chore:`), descriptive bodies explaining the *why*.
- Solo-dev workflow: slices are committed directly to `main` and pushed. Run the tests
  (`flutter test`) and `flutter analyze` before considering a slice done.
- Ad-free surfaces, sync wire contract, and the full slice-by-slice history are in
  [`docs/PROJECT_MEMORY.md`](docs/PROJECT_MEMORY.md).
