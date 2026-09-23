# Football Nations Manager (FNM)

A **fully offline** international football management sim built with Flutter.
Manage a national team through a four-year World Championship cycle: call up a
squad, set your lineup and tactics, play qualifiers, and reach the finals.

**Business model:** the first full four-year cycle is free, on two save slots:
qualifying, a continental championship and the World Championship, every nation
in the world, with nothing held back. The purchase unlocks two things and only
those two: **endless cycles** (a save carries on past its first four years) and
**unlimited saves** (the two-slot ceiling goes away entirely). One-time
**€12.99** in-app purchase. Nations are not part of it and never will be: a
trial that shows the whole world converts better than a padlocked one. The price
shown in the app is always the store's own localised `ProductDetails.price`;
€12.99 is the tier configured in the consoles.

There is no account, no server and no network call in the whole app. The store
is the only thing it ever talks to, and only when you buy or restore.

## Tech stack

| Concern            | Choice                                              |
| ------------------ | --------------------------------------------------- |
| State / DI         | Riverpod (`flutter_riverpod`, manual providers)     |
| Local storage      | Drift (type-safe SQLite)                            |
| Models             | `freezed` + `json_serializable`                     |
| Routing            | `go_router`                                         |
| Monetization       | `in_app_purchase` (non-consumable unlock)           |
| Backup             | Local file export/import (`VACUUM INTO` + bundles)  |
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
             match_engine · competition · entitlement · squad
  features/  one folder per feature (hub, career, squad, tactics,
             tournaments, match, paywall, settings, onboarding)
  shared/    reusable design-system widgets
assets/      data/ (seed JSON) · flags/ · trophies/ · images/ · fonts/
test/        unit · widget · golden  (+ helpers/, generated_migrations/)
```

Dependency rule: `features → domain → data`; `domain` depends only on
interfaces, never on concrete data implementations.

## Design principles

- **Offline, not offline-first** — there is no backend to fall back to. Every
  feature works with the radio off, and backups are files you own: a whole-DB
  copy or a single career bundle, exported and imported by hand.
- **Deterministic core** — the match engine is a pure function seeded by
  `SeededRng` (see `lib/core/rng/`), so the same `(saveSeed, fixtureId)` always
  reproduces the same match. This makes the engine unit-testable and replay-safe.
- **DRY / reusable** — one design-system widget library; repository pattern with
  interfaces; a single source of truth for premium gating.
- **Tested everywhere** — unit, widget and golden tests under `test/`; CI runs
  `dart format` check + `flutter analyze` + `flutter test`.

## Getting started

```bash
flutter pub get
flutter test          # run the test suite
flutter analyze       # static analysis
flutter run           # launch on a connected device / simulator
```

### Code generation (freezed / json_serializable / drift)

```bash
dart run build_runner build --force-jit
```

> **`--force-jit` is required.** A transitive dependency (`sqlite3`) ships a
> native-assets `hook/build.dart` that breaks build_runner's default AOT
> bootstrap on Dart 3.10. JIT compilation of the build script avoids it.
> Regenerate after changing any `@freezed` / Drift table / seed entity.

### Regenerating seed data

```bash
dart run tool/generate_seed.dart   # rewrites assets/data/{nations,players}.json
```

## Roadmap

Development is milestone-based; see the architecture plan for details. M0
(project setup, tooling, CI, deterministic RNG core) is complete. Next:
M1 data layer (Drift schema + entities + repositories).
