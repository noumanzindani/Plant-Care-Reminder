# Plantner — Plant Care Reminder

An offline-first Flutter plant-care app (a Planta / Greg / PlantIn competitor). The core
loop — **add plant → schedule care → local reminders → log care** — works fully offline with
no account; sync, auth, weather, and ads are optional overlays layered on top.

## Context for contributors (and AI agents)

A fresh clone carries the full project context:

- **[`CLAUDE.md`](CLAUDE.md)** — curated overview: architecture, conventions, phase status,
  and the offline-first / run-for-free-with-ads mandate. Auto-loaded by Claude Code.
- **[`docs/PROJECT_MEMORY.md`](docs/PROJECT_MEMORY.md)** — the exhaustive decision and
  slice-by-slice progress log (the "why" behind the code).

The Laravel sync/auth backend lives in a **separate** repo (`plantner-backend/`) and is
optional by design — you don't need it to run or ship the app.

## Getting started

```bash
flutter pub get
flutter run
flutter test          # full suite
flutter analyze
```

For Flutter itself: [online documentation](https://docs.flutter.dev/) offers tutorials,
samples, and a full API reference.
