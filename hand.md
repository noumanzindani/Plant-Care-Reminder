# HANDOFF — Plantner (Plant Care Reminder)

> **Purpose:** the one file to read after a fresh `git clone` to resume *exactly*
> where the last session ended. Point-in-time snapshot — **2026-07-06**.
> Deep context lives in [`CLAUDE.md`](CLAUDE.md) (auto-loaded) and the exhaustive
> slice log in [`docs/PROJECT_MEMORY.md`](docs/PROJECT_MEMORY.md).
> **When this file disagrees with the code, the code wins.**
>
> This file also carries the working session memory (`.remember/` day logs + the
> persistent mandates), because that memory is machine-local and does **not**
> travel with the repo.

---

## 🧭 YOU ARE HERE

- **Done:** Phases **0, 1, 2, 3, 5** + the pure/testable core of **Phase 6 (ads)**.
- **Weather (Phase 5) is LIVE** in the running app (Open-Meteo overlay + opt-in toggles).
- **App has been built & run on a physical Android device** (DE2118, Android 12) — it launches,
  renders the care queue, and is interactive.
- **➡️ NEXT MISSION: Phase 4 — AI plant identification (Pl@ntNet).** See [Phase 4 kickoff](#-phase-4--the-next-mission-start-here).
- **Repo state:** Flutter `main` @ `befe575` — **clean working tree, pushed** (`local == origin`).
- **Tests (last recorded, at code slice `fb62e97`):** **140 Flutter** + **30 backend** green, `analyze`/`Pint` clean, debug APK builds.

---

## ⚠️ READ FIRST — clone gotchas (these WILL bite you)

1. **The backend is a SEPARATE repo with NO remote.** `plantner-backend/` (Laravel 13 + Sanctum:
   delta-sync, social auth) is its own git repo (5 commits, HEAD `f361ef0`) and has **no `origin`**.
   **Cloning `Plant-Care-Reminder.git` does NOT bring it down.** Phase 4 (AI ID) is the *first* phase
   that genuinely needs this backend, so **before starting Phase 4 you must recover/host it** →
   see [action items](#-action-items-before-phase-4).
2. **`.remember/` and `~/.claude/.../memory` are machine-local.** They are NOT in any repo. This
   `hand.md` is their durable substitute — the [session history](#-session-history-folded-in-rememberememory)
   section below preserves them.
3. **No secrets are in the repo (correct).** Still-needed-but-absent, all owner-supplied:
   AdMob app IDs, Google/Apple OAuth client IDs, and a **Pl@ntNet API key** (Phase 4).
4. **Physical-device verification backlog** (do in ONE device session, not piecemeal): weather GPS →
   live forecast shifts a due date · notification fires while offline · Android reboot re-arms alarms ·
   iOS BGTaskScheduler (the iOS counterpart to Android's workmanager reconcile is still unbuilt).

---

## 🔁 Resume in ~5 minutes (fresh clone)

```bash
# --- Flutter client (this repo) ---
git clone https://github.com/noumanzindani/Plant-Care-Reminder.git
cd Plant-Care-Reminder
flutter pub get
flutter test          # expect ~140 green
flutter analyze       # expect clean
flutter run -d <deviceId>          # flutter devices  → pick your phone/emulator

# --- Backend (SEPARATE repo — see gotcha #1) ---
cd ../plantner-backend             # only if you still have it locally
composer install
php artisan test      # expect ~30 green (SQLite :memory:, zero setup)
php artisan serve     # http://127.0.0.1:8000
# Android emulator reaches the host at 10.0.2.2 → the app's SYNC_BASE_URL default is
#   http://10.0.2.2:8000/api/v1/   (override with: flutter run --dart-define=SYNC_BASE_URL=...)
```

**Toolchain on the build machine:** Flutter 3.41.9 (stable) · PHP 8.5.7 (Homebrew) · Composer 2.10 ·
Laravel 13.18 · Sanctum 4.3. MySQL 9.6 is installed but **not needed** (tests use SQLite in-memory).

---

## ✅ Phase ledger (what's built)

| Phase | Status | Notes |
|---|---|---|
| **0 — Foundation** | ✅ | Domain layer, Drift/SQLite, Riverpod + Freezed, compliance scaffolding. |
| **1 — Offline core loop** | ✅ | Cadence engine, reconciler, reminder applier, local notifications, snooze, journal, multi-care-type, rooms, workmanager + reconcile-on-resume, notification-tap deep-link. **Tail:** iOS BGTaskScheduler. |
| **2 — Catalog** | ✅ | Offline species catalog (bundled seed, ~18 houseplants), smart defaults, species detail. Backend catalog deferred. |
| **3 — Accounts + delta sync** | ✅ | Entire *testable* surface: Outbox invariant, SyncEngine, anon→auth flush, Dio adapter, Laravel backend (sep. repo) with Google/Apple JWKS verifiers, sign-in orchestration, resume-triggered sync. **Tails:** real Google/Apple **SDK adapters + sign-in UI**, two-device manual test, `DELETE /account`. |
| **4 — AI plant ID (Pl@ntNet)** | ⛔ **NEXT** | Not started. Needs server-side key. Disease diagnosis deferred (Pl@ntNet has no disease endpoint → add Plant.id/Kindwise later, premium-gated). |
| **5 — Weather + light meter** | ✅ (weather) | Overlay **live**: policy + reconciler wiring + Open-Meteo adapter + TTL cache + geolocator + Plant Detail opt-in toggles (per-room *Outdoor*, per-water-schedule *Weather-adaptive*). **Remaining:** real-device GPS verify; the **light meter** (camera lux → `LightMeterPort`) is a later 5.x slice. |
| **6 — Monetization (AdMob)** | 🟡 core only | Built (pure, no SDK): `AdFrequencyController`, `AdGate` (entitlement→surface→frequency), `AdPort` seam + `NoopAdPort`, `InterstitialAdManager`, `RewardedUnlockPolicy`, ad provider graph. **Not wired to any screen; no real SDK.** Needs owner: AdMob account + app IDs, placement decisions, real `google_mobile_ads` adapter, UMP/ATT, rewarded-SSV grant endpoint. |
| **7 — Community / 8 — Store hardening** | ⛔ | Not started. |

---

## ▶️ Phase 4 — the next mission (start here)

**Goal:** let a user photograph a plant → get species candidates → link/create the plant with
smart care defaults. Uses the **Pl@ntNet free API** (identification only).

**Why it's the hard one:** it's the **first feature that genuinely requires a server** — the Pl@ntNet
API key must live server-side, never in the client. This is in direct tension with the owner's
**"run for free"** mandate, so the *first* Phase-4 decision is a hosting decision (below), not code.

### Seams already in place (don't rebuild these)
- **`AdSurface.scanner.allowsAds == false`** — the scan screen is already declared ad-free in `AdGate`.
- **`RewardedUnlockPolicy`** (Phase 6.3) already decides *when to OFFER* "watch an ad to unlock 1 scan"
  (`maxUnlocksPerDay = 5`). It **never mints a credit** — grants are server-authoritative by design.
- **Ports & adapters pattern** — add an `IdentifyPort` (domain) + a Dio adapter + a `FakeIdentify` for
  TDD, exactly like `SyncApiPort`/`WeatherPort`. The scanner UI reads the port; tests never hit HTTP.
- **Server-authoritative entitlements** (`users.is_premium`) + Sanctum auth already exist in the backend.

### Suggested first slice (client-first, backend-free, TDD — matches how Phase 3 was built)
1. `IdentifyPort` domain contract + result VO (candidate species + score) + `FakeIdentify`. Red→green.
2. Scan flow use-case: pick image → `IdentifyPort.identify()` → candidate list → map onto existing
   `SpeciesCatalogPort` / create plant. All against the fake.
3. **Then** the backend: `POST /api/v1/identify` (proxy to Pl@ntNet, key from env, count against a
   per-user quota) + the **AdMob SSV grant endpoint** (SSV callback → increment scan credits → client
   re-reads) + a quota/credits read. Replay fake vectors as feature tests (SQLite `:memory:`).
4. Swap fake→Dio adapter; wire the rewarded `AdPort` show-flow + credit re-read after SSV.

### Open decisions for Phase 4 (surface to owner before coding the backend)
- **Hosting story** (the big one, per run-free mandate): free-tier serverless function for the Pl@ntNet
  proxy vs the existing Laravel backend? Keep AI ID **optional/premium**, never a mandatory cost.
- **Gating:** free scan quota per day? premium-only? free + rewarded-ad unlock (policy already caps 5/day)?
- **Compliance:** Pl@ntNet key server-side **only**; camera + photo permission strings; disclose image
  upload in Play Data Safety / iOS Privacy Manifest.

> **Note on ordering (per the ads mandate):** the owner previously prioritized *ads = revenue* and
> asked to bring Phase 6 forward. Phase 6's **core is built but not wired to real revenue** (no AdMob
> account, no placements, `NoopAdPort`). So "finish Phase 6 wiring" is the actual money path and is a
> legitimate alternative/parallel to Phase 4 — both are currently blocked on **owner-supplied inputs**
> (AdMob IDs vs Pl@ntNet key + hosting). Phase 4 is the stated next step; flagging this so the choice is
> explicit.

---

## 📌 Conventions you must NOT break (quick pointers; full text in CLAUDE.md)

- **Offline-first, no account required.** Core loop works fully offline; every cloud feature is a
  null-tolerant port/adapter overlay — never a dependency of the core loop.
- **Run for free, monetize with ads.** Backend stays optional/deferred; near-zero hosting cost.
- **Manual Riverpod providers, NOT codegen** (riverpod_generator/lint conflict with Freezed 3.x). Drift + Freezed codegen stay.
- **TDD is the default** (red→green→refactor). Only platform-channel adapters are "analyze/build-verified" instead of unit-tested — keep them razor-thin and null/no-op on every failure.
- **Never mix `testWidgets` and pure Drift-stream tests in one file** (fake clock hangs Drift streams). Widget tests verify *rendering*; data tests verify *mutation*.
- **Client UUID v7 keys are canonical** (anon→auth is a pure Outbox flush, no id remap). **Append-only care logs.** **Rolling 56-notification window** (iOS 64 cap). **Server-authoritative** entitlements + rewarded grants.
- **App id (permanent):** `co.appverra.plantner`. ⚠️ The Android `MainActivity` still sits in the default
  `com.example.plant_care_reminder` namespace — **rename before store submission** (Google rejects `com.example`).

---

## 🧠 Session history (folded-in `.remember` + memory)

> The ephemeral working memory, preserved so a clone carries the "how we got here."
> `now.md` was empty at handoff time.

### Persistent mandates (the two load-bearing memories)

**`plant-care-reminder-project` (project):** Greenfield Flutter full competitor to Planta/Greg/PlantIn.
8 shippable phases. Locked 2026-07-01: Pl@ntNet free API for ID (proxied through Laravel, swappable
adapter) · disease diagnosis deferred · offline-first core loop is non-negotiable · Drift = single
source of truth · Riverpod state · client UUID v7 canonical · append-only logs · rolling-56 reconciler ·
monotonic server `rev` watermark · server-authoritative `users.is_premium`. Approved plan:
`~/.claude/plans/ancient-humming-snail.md` (machine-local). Owner also runs EzHand (Laravel marketplace),
comfortable with Laravel/Flutter — but this app uses **Riverpod, not Provider**.

**`run-free-local-first-ads` (feedback, 2026-07-03):** Owner: *"app initially work on local data
with[out] any backend, i want to run it for free and want to add ads which make me money, so keep it in
this way."* → Every cloud feature stays optional/null-tolerant; the Laravel backend stays optional/deferred
(don't require hosting it to ship/run); Pl@ntNet AI ID (Phase 4) is the one server-needing feature —
keep it optional/premium or free-tier serverless, never a mandatory cost; bring Phase 6 (AdMob + UMP)
forward as the revenue engine; follow the plan's ad-free surfaces + frequency rules.

### Daily log

**Week of 2026-06-30 (archive):** Phases 0–1 foundation (domain, Drift, Riverpod, reminder engine, UI;
40 tests) + Phase 2 offline catalog + notification deep-linking. Launched Phase 3 auth: Flutter anon↔auth
(79 tests), DioSyncApi JWT stack (123 tests), Laravel sync/mutations/social endpoints (25+ tests); 3 new
deps; native builds clean.

**2026-07-01:** Researched 5 competing plant apps → 3-agent architecture (Flutter offline-first client,
Laravel sync/community/subs, freemium + rewarded ads + Pl@ntNet ID proxy) + 15 store-compliance blockers.
Phase 0 foundation (domain, Drift, app shell, Riverpod/Freezed). Phase 1 cadence engine TDD'd
(fromLastDone/fixedCalendar anchoring, hemisphere-aware seasonal, DST-stable, never-performed). Built
reminder engine (CadenceEngine, Reconciler, Applier, OccurrenceBuilder, ReconcileCoordinator; 20+ tests);
set bundle id; wired Android/iOS native config + notifications; Android APK builds. Fixed Android
desugaring; workmanager periodic reconcile + resume-reconcile. Added snooze (marker-based, auto-clear),
journal (newest-first), multi-care cadences, rooms; wired PlantDetail/Journal/Home. 40 tests, analyze clean.
Started Phase 2 (SpeciesCatalogPort + bundled-seed adapter, schema v3).

**2026-07-02:** Phase 2 offline catalog (Species table v3; SpeciesCatalogPort/DriftSpeciesCatalog;
CatalogSeeder ~18 plants; addPlant species-link + auto-fertilize; picker + detail with light/toxicity/
family; 53 tests). Shipped notification-tap deep-link (56 tests). Council rec → Phase 3 Outbox-wiring
(client-first TDD) ‖ Play closed-test prep; defer Laravel/iOS. Slices 3.2–3.4: Flutter anon↔auth (79
tests); Laravel `/sync/changes`, `/mutations` (8); `/auth/social` Google/Apple (17); NullSocialIdentity
Verifier fail-closed; `firebase/php-jwt` installed. Phase 3: JWT verifier + JWKS; Flutter DioSyncApi +
auth stack + connectivity-gated SyncService + Riverpod + sign-in; 30 backend + 93 Flutter tests; 3 deps
(dio, flutter_secure_storage, connectivity_plus); native builds clean.

**2026-07-03:** Committed lifecycle-trigger sync to `main` (Phase 3 testable surface versioned).
Phase 5: 5.1 weather overlay (7 TDD, 100 tests) + 5.2a reconciler wiring (104 tests); committed →
5.2b-i Open-Meteo adapter.

**2026-07-04:** Phase 6.2 ad core (AdSurface, AdGate, AdPort, InterstitialAdManager, FakeAdPort; +12
tests → 128 green). Phase 6 ad core complete (pacing, gate, rewarded offer, providers; commits
762cc2f/1d04fe6/b4d4830; 134 tests). Weather-watering overlay flipped ON: fwd WeatherPort through
reconciler, geolocator adapter, OpenMeteo + TTL cache provider, native perms, Plant Detail toggles;
140 tests; commits 17a71e4/b5d9218, fb62e97. **Pushed** 6 commits to `origin/main` (owner said "push
all the memory to git") → repo now self-documents via `CLAUDE.md` + `docs/PROJECT_MEMORY.md`; HEAD `befe575`.

**2026-07-06:** Built & ran Flutter Plantner on Android device DE2118; APK installed; app interactive.
Created this `hand.md` handoff and pushed it.

### Identity notes (from memory)
- Rigorous **TDD across the full stack** (Flutter + Laravel) — every phase red→green, 30–140+ tests.
- **Offline-first mobile + backend architecture** with bidirectional delta sync and reconciliation.

---

## 📋 Action items before Phase 4

- [ ] **Recover / host the backend.** Create a GitHub remote for `plantner-backend/` and push it (it
      currently has none) — otherwise a clone can't run Phase 4's server side. Then decide hosting
      (free-tier serverless proxy vs Laravel) per the run-free mandate.
- [ ] **Get a Pl@ntNet API key** (server-side env var only).
- [ ] Decide AI-ID gating: free quota / premium / rewarded-unlock (policy already caps 5/day).
- [ ] (Parallel, revenue) If prioritizing ads instead: AdMob account + app IDs, placement decisions,
      real `google_mobile_ads` adapter, UMP/ATT. Both paths are blocked only on these owner inputs.
