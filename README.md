# Football Nations Manager (FNM)

An **offline-first** international football management sim built with Flutter.
Manage a national team through a four-year World-Cup cycle: call up a squad, set
your lineup and tactics, play qualifiers, and reach the finals.

**Business model:** a free demo (one 4-year cycle + a handful of nations) with
everything else — all nations, multiple cycles, and **cloud save backup** —
unlocked by a one-time **€9.99** in-app purchase.

## Tech stack

| Concern            | Choice                                              |
| ------------------ | --------------------------------------------------- |
| State / DI         | Riverpod (`flutter_riverpod`, manual providers)     |
| Local storage      | Drift (type-safe SQLite)                            |
| Models             | `freezed` + `json_serializable`                     |
| Routing            | `go_router`                                         |
| Monetization       | `in_app_purchase` (non-consumable unlock)           |
| Cloud (premium)    | Supabase, isolated behind `CloudSyncService`        |
| Lint               | `very_good_analysis`                                |

> **Note:** Riverpod is used **without** code generation. Its codegen package
> pins an older `analyzer` that conflicts with `drift_dev`; manual providers
> avoid the conflict and are fully idiomatic.

## Project structure

```
lib/
  core/      cross-cutting: theme, routing, rng, result, di, utils
  data/      Drift db + DAOs, seed loaders, repository implementations
  domain/    freezed entities, repository interfaces, services:
             match_engine · competition · entitlement · cloud
  features/  one folder per feature (home, career, squad, tactics,
             competition, match, paywall, cloud, settings, onboarding)
  shared/    reusable design-system widgets
assets/      data/ (seed JSON) · images/ (logo, flags)
test/        unit · widget · golden  (+ helpers/, integration_test/)
```

Dependency rule: `features → domain → data`; `domain` depends only on
interfaces, never on concrete data/cloud implementations.

## Design principles

- **Offline-first** — every gameplay feature works with no network; cloud is
  opt-in backup only.
- **Deterministic core** — the match engine is a pure function seeded by
  `SeededRng` (see `lib/core/rng/`), so the same `(saveSeed, fixtureId)` always
  reproduces the same match. This makes the engine unit-testable and replay-safe.
- **DRY / reusable** — one design-system widget library; repository pattern with
  interfaces; a single source of truth for premium gating.
- **Tested everywhere** — unit, widget, golden, and integration tests; CI runs
  `dart format` check + `flutter analyze` + `flutter test`.

## Getting started

```bash
flutter pub get
flutter test          # run the test suite
flutter analyze       # static analysis
flutter run           # launch on a connected device / simulator
```

### Code generation (from M1 onward, once freezed/drift models exist)

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Roadmap

Development is milestone-based; see the architecture plan for details. M0
(project setup, tooling, CI, deterministic RNG core) is complete. Next:
M1 data layer (Drift schema + entities + repositories).
