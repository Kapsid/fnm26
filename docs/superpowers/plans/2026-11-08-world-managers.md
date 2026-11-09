# 1.1.0 World Managers and Host Stadium Rules Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Every AI nation gets a named, stored, fictional manager. He is hired, sacked, poached and retired at fixed decision points, he blends his style into the nation's AI tactics, and he builds a relationship with the player that shows in the press, on Y, in the news and on new screens. The same release makes tournament hosting obey real stadium requirements. Both ship in 1.1.0 on schema 55 and must not break a single existing save.

**Architecture:**
- Managers live in three additive per-career tables (`world_managers`, `manager_spells`, `manager_ties`). None of them has a column named `id`.
- Every rule is a pure function in `lib/domain/services/world_managers/`. One feature service (`WorldManagerService`) loads the whole manager world in one read, runs the pure pass and writes one batch.
- Seeding is lazy. It runs the first time anything asks for managers, never on the career-load path.
- Behaviour changes are gated per cycle by a `draws_watched` marker (`worldManagers1`). A cycle without the marker plays on today's rules.
- Host stadium rules are pure functions over the seed grounds and the manager's estate. They are gated per edition by a `hostRules2:` marker and need no table, so they share schema 55 without adding to it.

**Tech Stack:** Flutter, Riverpod 2.6.1 (hand-written providers, no codegen), Drift with stepwise migrations, freezed only where it already exists, go_router, gen_l10n through `copy/strings.csv`.

**Spec:**
- `docs/superpowers/specs/2026-11-07-world-managers-design.md`, including "Owner decisions", "Save safety" and "Release scope".
- `docs/superpowers/specs/2026-11-07-real-world-playoffs-design.md`, section 6 "Host stadium requirements", owner decision 3 and "Save safety" only. The play-offs, the calendar and match spacing stay in 1.1.1 and are out of scope here.

## Global Constraints

- **Workspace.** Branch `feature/world-managers` in worktree `../fnm26-world-managers`, created from main at execution time (`git worktree add ../fnm26-world-managers -b feature/world-managers main`).
  - Copy both specs and this plan into the worktree and commit them first: `docs: world managers and host rules spec and plan`.
  - Other branches are landing on main now (open-last-career performance `fix/perf-hangs`, rating badges, penalties, press and Y names). Rebase onto main before Task 2, before Task 14 and before Task 18. After each rebase, re-run the Task 1 upgrade test.
- **One flutter_tester at a time.** Before every flutter or dart command, wait until `pgrep -f "flutter_tester|flutter test"` finds nothing: `while pgrep -f "flutter_tester|flutter test" >/dev/null; do sleep 20; done`. Wrap every run as `caffeinate -dimsu timeout <s> flutter test <paths>`.
- **Targeted tests only.** Each task's verify step names its test files. Only Task 18 runs the full suite.
- **Codegen.** Run it only as `dart run build_runner build --force-jit`. Never add `@riverpod`. Format only the files you touched.
- **Schema 55, additive.** `AppDatabase.currentSchemaVersion` goes from 54 to 55 in Task 2 only. Follow the recipe on `AppDatabase.migration`: dump, steps, fill `from54To55`, generate test helpers, then `build_runner --force-jit`. The step only calls `m.createTable` (CREATE TABLE IF NOT EXISTS), so a step that is cut short re-runs cleanly. No existing column is dropped, rewritten or given a new meaning.
- **No column named `id` in the new tables.** `CareerBundle.import` removes `id` from every row it writes (`career_bundle.dart:286`). The keys are `(career_id, manager_id)`, `(career_id, spell_no)` and `(career_id, tie_no)`, so a bundle carries them with no remapping.
- **Per-cycle gate.** Use `const worldManagersKind = 'worldManagers1'`.
  - It is stamped at career creation for cycle 0, next to `fluidWindowsKind`, and in `_startNextCycle` for the new cycle.
  - A fixture whose cycle lacks it reads `NationIdentity` style exactly as today.
  - No sacking, hiring, news, press beat or Y post happens in an unmarked cycle.
  - An upgraded save gets its first marked cycle at its next rollover.
- **Per-edition host gate.** Use `HostBidding.rules2Kind(cycle) = 'hostRules2:<cycle>'`. It is stamped beside `HostBidding.rulesKind` at creation and at rollover. There is one exception: an edition that already holds a pledge or bid lodged by an older build (`hostBid:` / `hostBidPledge:` format) is not stamped. An edition without the marker is decided, and its venues built, exactly as today.
- **Never the world RNG.** All manager and host-rule randomness uses `SeededRng(varietySeed('mgr:<purpose>:<rngSeed>:<key>'))` or `'host2:...'`. With manager style switched off, a pinned-seed world is identical to today's (Task 1 golden).
- **Untouched systems.** `RatingMatchSimulator`, match strength, the balance calibration and the tactics-impact guards must not change. A manager affects only the six instruction shifts in `AiTactics`.
- **Load time.** No hub, career-load or careers-list provider reads a manager table. Lazy seeding of a career is one transaction and must take under 50 ms on the Galaxy A56. It is logged through `AppLog` with tag `mgr-seed` and measured on the device in Task 18.
- **Names.**
  - Names are fictional, built from the career's own name pools (pack lists first) the way `StaffMarket._nameFrom` builds them. They are stored once and never renamed.
  - Ex-internationals keep their player name.
  - Names are never translated.
  - A world pack (format 3) may rename only day-one incumbents.
- **The player's job flow is unchanged.** `rolloverVerdictProvider`, the offers and `switchNation` behave byte for byte as today. Managers only react to them.
- **Copy.** Every new user-facing string goes through `copy/strings.csv` (UTF-8 with BOM, CRLF), then `dart run tool/import_copy.dart`, then `flutter gen-l10n`, in all 28 languages (Task 17).
  - Tasks 2 to 16 add their keys with `en` and `cs` filled, and the other locales fall back until Task 17.
  - No em dashes in user-facing copy, and in Czech no ` – ` pause dash.
  - Never write "World Cup" in English copy; it is "World Championship".
  - No ALL CAPS English.
  - News is stored as meaning (`MsgPart`), never as words.
- **Tablet.** Every new route goes into `tabletReadyPaths` (`lib/features/shell/tablet_shell.dart`) and into `test/widget/tablet_route_sweep_test.dart`. Screens get phone and tablet layouts.
- **Name clash.** `managerServiceProvider` already exists (`lib/features/manager/manager_providers.dart`, the player's own manager). New code uses the `worldManager*` prefix and lives in `lib/features/world_managers/`.
- **Host bars (spec section 6, verbatim):**

  | Tournament | Grounds | Final / opener | Semi grounds | Others |
  |---|---|---|---|---|
  | World Championship | ≥10 | 1 × ≥60,000 | 2 × ≥40,000 | ≥30,000 |
  | EURO | ≥8 | ≥50,000 | 2 × ≥35,000 | ≥25,000 |
  | AFCON and Asian Cup | ≥6 | ≥40,000 | 1 × ≥30,000 | ≥20,000 |
  | Gold Cup | ≥6 | ≥40,000 | 1 × ≥30,000 | ≥20,000 |
  | Copa | ≥5 | ≥40,000 | 1 × ≥30,000 | ≥20,000 |
  | Oceania Cup | ≥2 | ≥10,000 | n/a | ≥5,000 |

  - A ground counts if it is a seed ground or a manager estate ground open by the edition's cycle (`NationalStadium.openIn`).
  - Generated extra cities never count.
  - A joint bid has at most 3 hosts, and each co-host brings at least 2 qualifying grounds.
  - The World Championship is played in 10 to 16 qualifying grounds and is never padded.

## Review Focus

1. **A save from 1.0.9 or 1.1.0 (37) opened mid-cycle.** It loads at its usual speed. Its results, squads, names, trophies, stints and this cycle's hosts and venues are identical, and the opponents play today's styles until the next rollover. Pinned by `save_upgrade_test.dart` (Task 1), re-run in Tasks 2, 5, 8, 15 and 18.
2. **The player's assistant hired in an earlier cycle leaves.** `staffProvider` gives him an empty name (`name: ''`). He must still enter the pool with a real, stable name and his country. Test in Task 8: `a departed assistant from an earlier cycle enters the pool named`.
3. **Two old fixtures, a replay and a scout report against the same nation, either side of a manager change.** Each reads the manager in charge on that fixture's date, and a fixture from an unmarked cycle reads the nation's own style. Test in Task 5: `a fixture before the change reads the old manager, one after reads the new`.
4. **A career bundle round trip.** A bundle exported before 55 imports with no manager rows and seeds lazily. A 55 bundle keeps every manager id, spell and tie. Tests in Task 2.
5. **A small or unlucky nation in host selection.** It never ends up hosting below the bar, alone or in a bid. A bid that only reaches the bar with planned grounds that are then not paid (a broken promise) never leaves the player hosting an edition he cannot stage. Tests in Tasks 14 and 15: `no v2 edition is hosted below its bar for seeds 1..40` and `an unpaid planned-ground pledge lapses, is marked broken and bars the next bid`.

---

## File Structure

Domain (pure Dart, `lib/domain/`):
- `entities/world_manager.dart` (new): `WorldManager`, `ManagerSpell`, `ManagerTie`, the enums and `ManagerWorld`.
- `services/world_managers/manager_seeder.dart`: day-one world.
- `services/world_managers/manager_names.dart`: names from pools.
- `services/world_managers/manager_decisions.dart`: sack, hire, poach, retire, entrants, contracts and safeguards.
- `services/world_managers/manager_reputation.dart`
- `services/world_managers/manager_relation.dart`: warmth and labels.
- `services/world_managers/manager_news.dart`: which moves become news.
- `services/match/ai_tactics.dart` (modify): the `managerStyle` blend.
- `services/competition/host_stadium_rules.dart` (new): bars, qualifying grounds, joint bids and planned grounds.
- `services/competition/hosts.dart`, `venues.dart`, `host_bidding.dart` (modify): v2 selection, venues and markers.
- `services/world_pack/world_pack.dart` (modify): format 3 `managers`.
- `repositories/world_manager_repository.dart` (new, abstract).

Data:
- `data/db/tables.dart`, `app_database.dart`, `schema_versions.dart`: schema 55.
- `data/db/save_backup.dart`, `connection.dart`: the pre-upgrade copy.
- `data/repositories/drift_world_manager_repository.dart` (new).
- `data/repositories/drift_player_repository.dart`: `namePoolsFor`.

Features (`lib/features/world_managers/`, new):
- `world_manager_markers.dart`
- `world_manager_service.dart`
- `world_manager_providers.dart`
- `manager_row.dart`
- `manager_profile_sheet.dart`
- `managers_screen.dart`, `managers_tablet_layout.dart`

Modified features:
- `match/match_providers.dart`, `hub/hub_providers.dart` (`_withManagerTactics`), `match/scout_report_providers.dart`: style lookup.
- `hub/season_cycle.dart`, `hub/season_rollover.dart`: decision points and markers.
- `career/career_providers.dart`: markers at creation.
- `manager/manager_providers.dart` (`hire`): assistant departure.
- `nations/nation_now_card.dart`, `match/match_preview_screen.dart` (`OpponentBriefing`), `match/scout_report_view.dart`, `ranking/` (managers entry).
- `press/press_desk.dart`, `domain/services/press/conference.dart`, `y/y_providers.dart`, `domain/services/press/y_feed.dart`, `messages/message_sheet.dart`.
- `federation/host_bid_screen.dart`, `host_bid_providers.dart`, `national_stadiums_screen.dart`.
- `editor/names/name_sections.dart` and the pack rules.

Tests and fixtures:
- `test/fixtures/saves/{v109,v110_37,pre55}/{mid_cycle,late_cycle}.db.gz` with a `.manifest.json` and a `.fnmcareer` each.
- `tool/fixture_saves/make_fixture_saves_test.dart.txt` (the template run inside old-build worktrees).
- `test/story/save_upgrade_test.dart`
- `test/unit/world_managers/*`
- `test/unit/competition/host_stadium_rules_test.dart`

---
### Task 1: Fixture saves from earlier builds, the upgrade test and the pinned world

**Files:**
- Create: `tool/fixture_saves/make_fixture_saves_test.dart.txt`, `tool/fixture_saves/README.md` (four lines: how to regenerate)
- Create: `test/fixtures/saves/v109/`, `v110_37/`, `pre55/`, each holding `mid_cycle.db.gz`, `late_cycle.db.gz`, `*.manifest.json` and `late_cycle.fnmcareer`
- Create: `test/story/save_upgrade_test.dart`, `test/helpers/save_fixtures.dart`
- Create: `test/unit/world_managers/pinned_world_test.dart` and its golden `test/fixtures/managers/pinned_world_seed42.json`

**Interfaces:**
- Produces in `test/helpers/save_fixtures.dart`:
  - `Future<File> unpackFixture(String build, String name)`: gunzips into a fresh temp directory, so the committed original is never written.
  - `Future<Map<String, List<Map<String, Object?>>>> dumpTables(String dbPath, {Set<String>? only})`: raw `sqlite3`, `SELECT * ... ORDER BY rowid`, every user table.
  - `const Set<String> kRolloverMutableTables`: the tables whose existing rows a rollover may legitimately change. Step 4 fixes this set against today's code, and no later task may grow it.
  - `typedef SaveManifest = ({int careerId, int cyclePointer, Map<String, List<int>> hosts, Map<String, List<String>> venues, Map<int, List<String>> names})`
    - `hosts` keys look like `wc:<cycle>` and `cont:<CONF>:<cycle>`.
    - `venues` holds `"<name>|<capacity>"` strings.
    - `names` is keyed by nationId and holds that nation's pool names at the save's date.
- Produces in `pinned_world_test.dart`: a golden holding every fixture `(id, date, home, away, scores, pens)` of seed 42, England, after the first 120 hub events.

- [ ] **Step 1: Write the fixture-maker template.** The template uses only APIs that exist at `e34168ea`: `StoryDriver.start`, `step(stopAtRollover:)`, `CareerBundle.export`, `WorldCupHosts.hostsFor` / `continentalHostsFor`, `VenueGenerator.forHosts` and `playerRepositoryProvider.byNation`. Where a later build renamed one of these, the template carries a `// BUILD:` switch. It writes:
  - `mid_cycle`: seed 4242, England, played until the first continental finals honour is recorded.
  - `late_cycle`: seed 777, Czechia, played until `step(stopAtRollover: true)` returns false, which is the World Championship decided and the rollover next.
  - Each database is snapshotted with `VACUUM INTO` (never a file copy, the database is in WAL mode) and gzipped.
  - A manifest goes beside each one: hosts and venues for every edition of cycles 0 and 1 the build can name, and names for the career nation plus nations 1, 23 and 140.
  - `late_cycle.fnmcareer` is the career bundle from that build.
- [ ] **Step 2: Generate the fixtures in three worktrees.** Use `$SCRATCH/wt109` at `e34168ea` (1.0.9 (21), schema 52), `$SCRATCH/wt110` at `e70e731c` (1.1.0 (37), schema 54) and `$SCRATCH/wtpre` at the rebased main (schema 54). In each one:
  - copy the template in as `test/story/make_fixture_saves_test.dart`;
  - run it alone (`timeout 3600`);
  - copy the outputs into `test/fixtures/saves/<build>/`.
  - Check that the fixtures total 15 MB or less. If they do not, drop `mid_cycle` from `pre55`.
  - Remove the worktrees afterwards (`git worktree remove`).
- [ ] **Step 3: Write `save_upgrade_test.dart`.** For each build × save:
  - `opening migrates to 55 and changes no existing row`: the dump before equals the dump after, table for table, ignoring tables the build did not have.
  - `names, hosts and venues match the old build's manifest`.
  - For `late_cycle` only, `a rollover keeps every existing row outside the mutable tables`. Run one `d.step()` for the rollover, then assert:
    - every pre-existing row of every table outside `kRolloverMutableTables` is present and identical;
    - the `honours`, `career_stints`, `player_honours` and `fixtures` rows dated before the rollover are identical;
    - the hosts and venues of every cycle-0 edition equal the manifest.
  - `the old build's bundle imports`: `CareerBundle.import` of `late_cycle.fnmcareer` succeeds and its fixtures count equals the source's.
  - For `mid_cycle`, `fifty more events play`: 50 steps, no throw, and this cycle's hosts are unchanged.
  - Later tasks append their own assertions to this file.
- [ ] **Step 4: Run** `test/story/save_upgrade_test.dart` on today's code. Expected: PASS. If the rollover test fails, the failure lists the tables today's code legitimately mutates. Put exactly those into `kRolloverMutableTables`, with a one-line reason each, and re-run.
- [ ] **Step 5: Write `pinned_world_test.dart`** to record the golden on today's code (`FNM_GOLDEN=1` writes it, a plain run compares it). Run it twice. Expected: PASS both times.
- [ ] **Step 6: Profile the baseline.** Use `AppLog` timing (tag `career-open`) to time opening the last career on the 1.1.0 (37) `late_cycle` fixture in a widget test (`test/widget/career_open_timing_test.dart`, printed, not asserted). Record the figure in `.superpowers/sdd/2026-11-08-world-managers/progress.md` as the before number.
- [ ] **Step 7: Commit** `test(saves): fixture saves from 1.0.9, 1.1.0 (37) and pre-55, upgrade test, pinned world`.

### Task 2: Schema 55, the pre-upgrade copy and bundle coverage

**Files:**
- Modify: `lib/data/db/tables.dart`, `lib/data/db/app_database.dart`, `lib/data/db/schema_versions.dart` (generated), `drift_schemas/drift_schema_v55.json`, `test/generated_migrations/`
- Modify: `lib/data/db/save_backup.dart`, `lib/data/db/connection.dart`, `lib/data/db/career_bundle.dart` (doc comment only), `lib/main.dart` (open-failure screen)
- Test: `test/unit/data/schema_migration_test.dart`, `test/unit/data/career_bundle_test.dart`, `test/unit/data/save_backup_test.dart`, `test/story/save_upgrade_test.dart`

**Interfaces:**
- Produces three tables. Each `careerId` is `integer().references(Careers, #id, onDelete: KeyAction.cascade)()`.
  - `WorldManagers`, primary key `{careerId, managerId}`:
    - `managerId` int;
    - `name` text;
    - `nationality` text (FIFA code, upper case);
    - `birthYear` int;
    - `style` text (a `NationStyle` name);
    - `origin` text (a `ManagerOrigin` name);
    - `enteredAt` dateTime;
    - `retiredAt` dateTime, nullable;
    - `sourceId` int, nullable (the player id of an ex-international, or the staff candidate id of an ex-assistant).
  - `ManagerSpells`, primary key `{careerId, spellNo}`, index `(career_id, nation_id)`:
    - `spellNo` int;
    - `managerId` int;
    - `nationId` int;
    - `fromDate` dateTime;
    - `toDate` dateTime, nullable;
    - `endReason` text, nullable (a `SpellEnd` name);
    - `contractUntil` dateTime;
    - `briefNet` int, default 0.
  - `ManagerTies`, primary key `{careerId, tieNo}`: `tieNo` int, `managerId` int, `kind` text (a `TieKind` name), `delta` int, `date` dateTime.
- `from54To55: createTable` for each of the three tables, and nothing else.
- `SaveBackup.writePreUpgradeCopy(File live, {required int fromVersion}) -> Future<File?>`
  - It opens the file with raw `sqlite3`, reads `PRAGMA user_version`, and when `firstManagedVersion <= v < currentSchemaVersion` writes `VACUUM INTO` `<safetyDirectory>/before-update-v<v>-<stamp>.<extension>`.
  - It returns null when there is nothing to upgrade.
  - The Settings restore list already lists safety copies, so the copy appears there.
- `connection.dart` calls it before `NativeDatabase.createInBackground`. If the call throws, it logs `AppLog.error('pre-upgrade-copy', ...)` and opens the database anyway.
- When opening the database throws, `main.dart` shows `SaveUpgradeFailedScreen` with copy keys `saveUpgradeFailedTitle` and `saveUpgradeFailedBody` ("Your save could not be updated. Nothing was deleted, and a copy from before the update is in Settings, Backups."). It never shows an empty career list.

- [ ] **Step 1: Write the failing tests.**
  - `schema_migration_test.dart`: `54 → 55 keeps every career and adds three empty manager tables`.
  - `career_bundle_test.dart`:
    - `manager rows keep their ids through a round trip`: insert 2 managers, 3 spells and 1 tie, export, import, and assert the same `managerId`, `spellNo` and `tieNo` values under the new career id;
    - `a bundle from 54 imports with no manager rows`.
  - `save_backup_test.dart`:
    - `a v54 file gets a pre-upgrade copy that opens at v54 with its careers`;
    - `a current file gets none`.
- [ ] **Step 2: Run** those three files. Expected: FAIL.
- [ ] **Step 3: Implement** the tables and the bump with the recipe in Global Constraints, then `writePreUpgradeCopy`, the connection hook and the failure screen. The bundle classification test passes untouched, because every table has `career_id`.
- [ ] **Step 4: Run** the three files plus `test/story/save_upgrade_test.dart`. Expected: PASS, with zero manager rows in every upgraded fixture.
- [ ] **Step 5: Commit** `feat(db): schema 55 adds world manager tables, pre-upgrade copy`.

### Task 3: Manager entities and the repository

**Files:**
- Create: `lib/domain/entities/world_manager.dart`, `lib/domain/repositories/world_manager_repository.dart`, `lib/data/repositories/drift_world_manager_repository.dart`
- Modify: `lib/data/data_providers.dart` (`worldManagerRepositoryProvider`)
- Test: `test/unit/world_managers/world_manager_repository_test.dart`

**Interfaces:**
- Produces in `world_manager.dart`:
  - `enum ManagerOrigin { fresh, exPlayer, exAssistant }`
  - `enum SpellEnd { sacked, resigned, poached, retired, contractEnd, replacedByPlayer }`
  - `enum TieKind { grudge, successor, protege, formerPlayer, pressDig, pressRespect }`
  - `class WorldManager`: the Task 2 columns as final fields, plus `copyWith({DateTime? retiredAt})`.
  - `class ManagerSpell`: the Task 2 columns, `bool get current => toDate == null`, and `close(DateTime on, SpellEnd why)`.
  - `class ManagerTie`: the Task 2 columns.
  - `class ManagerWorld { final List<WorldManager> managers; final List<ManagerSpell> spells; ManagerSpell? currentAt(int nationId); ManagerSpell? inChargeOn(int nationId, DateTime d); List<WorldManager> free(DateTime d); int nextManagerId; int nextSpellNo; }`
    - `inChargeOn` is the latest-starting spell at that nation with `fromDate <= d` and `(toDate == null || d < toDate)`.
    - `free` lists managers with no current spell and no `retiredAt`.
  - `class ManagerChanges { final List<WorldManager> added, updated; final List<ManagerSpell> opened, closed, renewed; final List<ManagerTie> ties; final List<ManagerMove> moves; bool get isEmpty; }`
  - `typedef ManagerMove = ({int nationId, int? outgoingId, SpellEnd? why, int? incomingId, DateTime date})`
- Produces in `WorldManagerRepository`:
  - `Future<bool> hasManagers(int careerId)`
  - `Future<ManagerWorld> load(int careerId)`: two queries.
  - `Future<void> apply(int careerId, ManagerChanges c)`: one transaction using `batch`.
  - `Future<ManagerSpell?> inChargeOn(int careerId, int nationId, DateTime date)`: an indexed single query.
  - `Future<List<ManagerSpell>> spellsOf(int careerId, int managerId)`
  - `Future<List<ManagerTie>> ties(int careerId)`
  - `Future<void> addTie(int careerId, {required int managerId, required TieKind kind, required int delta, required DateTime date})`: assigns `tieNo = max + 1`.
  - `Future<List<ManagerSpell>> movesSince(int careerId, DateTime since)`: spells opened or closed on or after `since`.

- [ ] **Step 1: Write the failing tests.**
  - `apply then load round-trips managers, spells and ties`.
  - `inChargeOn picks the spell covering the date and null before any`.
  - `closing a spell and opening the successor on one date gives the successor from that date`.
  - `apply is one transaction: a duplicate spellNo leaves nothing written`.
  - `movesSince lists spells opened or closed since the date`.
- [ ] **Step 2: Run** `test/unit/world_managers/world_manager_repository_test.dart`. Expected: FAIL.
- [ ] **Step 3: Implement** the entities, the repository and the provider.
- [ ] **Step 4: Run** it. Expected: PASS.
- [ ] **Step 5: Commit** `feat(managers): manager entities and repository`.

### Task 4: Names, pack format 3 and lazy seeding

**Files:**
- Create: `lib/domain/services/world_managers/manager_names.dart`, `manager_seeder.dart`
- Create: `lib/features/world_managers/world_manager_markers.dart`, `world_manager_service.dart`, `world_manager_providers.dart`
- Modify: `lib/domain/services/world_pack/world_pack.dart` (format 3), `lib/data/repositories/world_pack_repository.dart` (`managersFor`), `lib/domain/repositories/player_repository.dart` and `lib/data/repositories/drift_player_repository.dart` (`namePoolsFor`), `lib/features/career/career_providers.dart` (marker at creation)
- Test: `test/unit/world_managers/manager_seeder_test.dart`, `test/unit/world_pack/world_pack_json_test.dart` (extend), `test/unit/world_managers/lazy_seed_test.dart`

**Interfaces:**
- Consumes: `ManagerWorld`, `WorldManagerRepository` (Task 3).
- Produces in `world_pack.dart`:
  - `kPackFormatVersion = 3`
  - `WorldPack.managers`: `Map<int, ({String name, String nationality})>`, JSON key `managers`.
  - `_from2To3` adds `managers: {}`. `migrate` chains 1→2→3 and refuses 4.
- Produces in `PlayerRepository`:
  - `Future<Map<String, NamePoolLists>> namePoolsFor(int careerId)`, where `NamePoolLists = ({List<String> first, List<String> sur})`, keyed by upper-case FIFA code.
  - It covers the career's current pool era, with pack `nameLists` taking precedence.
  - It is read from the repository's cached pools, with no per-nation query.
- Produces in `WorldPackRepository`: `Future<Map<int, ({String name, String nationality})>> managersFor(int careerId)`, built like `addedSponsorsFor` and empty for the default world.
- Produces in `ManagerNames`: `static String build(NamePoolLists pool, SeededRng rng)`, a first name plus a surname from the pool as in `StaffMarket._nameFrom`. An empty pool falls back to the `ENG` pool.
- Produces in `ManagerSeeder`:
  - `static ManagerWorld seed({required int rngSeed, required int seedCycle, required DateTime asOf, required List<Nation> nations, required Map<int, int> rankById, required Set<int> playerNationIds, required Map<String, NamePoolLists> pools, required Map<int, ({String name, String nationality})> packManagers})`
  - Values pinned by the spec:
    - one incumbent per nation outside `playerNationIds`, plus 60 free managers;
    - spell start = `asOf` minus a uniform 0 to 6 years;
    - one or two earlier fictional spells at other nations, ending before the current start (end reasons drawn from sacked, resigned, contractEnd);
    - domestic share 85% for pedigree 1 to 2, 70% for pedigree 3, 55% for pedigree 4 to 5;
    - foreign nationality drawn with weight `(6 - pedigree)^2`, restricted to pedigree 1 to 3 at 90%;
    - style: a domestic manager has the nation's style 70% of the time, otherwise a neighbouring style; a foreign manager has his country's style 60% of the time;
    - age at `asOf` from 38 to 66;
    - contract from 2 to 6 years after spell start, at least `asOf` plus 1 year;
    - origin is fresh for all of them.
  - A pack entry replaces an incumbent's name and nationality, and the nationality then sets the style draw.
  - RNG: `SeededRng(varietySeed('mgr:seed:$rngSeed:$seedCycle'))`.
  - `const Map<NationStyle, List<NationStyle>> kNeighbourStyles` is fixed in the seeder:

    ```
    possession: [balanced, flair]
    highPress:  [direct, possession]
    defensive:  [counter, physical]
    direct:     [physical, highPress]
    counter:    [defensive, direct]
    flair:      [possession, counter]
    physical:   [direct, defensive]
    balanced:   [possession, counter]
    ```

- Produces in the feature layer:
  - `const worldManagersKind = 'worldManagers1';`
  - `String mgrDecidedKind(String key) => 'mgrDecided:$key'`
  - `const mgrRolloverKind = 'mgrRollover'` (row cycle = the new cycle).
  - `class WorldManagerService { Future<void> ensureSeeded(int careerId); Future<bool> cycleHasManagers(int careerId, DateTime date); Future<NationStyle?> styleOn(int careerId, int nationId, DateTime date); }`
    - `ensureSeeded` keeps one memoised `Future` per career and does nothing if rows exist.
    - Otherwise it seeds with `seedCycle` = the career's `cyclePointer` and `asOf = CareerService.cycleOpens(seedCycle)`. `rankById` is that cycle's seed-ranking snapshot, or `nation.ranking` for cycle 0.
    - It writes one `apply` and logs `AppLog.info('mgr-seed', '<ms> ms')`.
    - `styleOn` returns null when the date's cycle has no `worldManagersKind` marker or no spell covers it, and calls `ensureSeeded` otherwise.
  - `CareerService.cycleAt(DateTime d) -> int`: the largest `c` with `cycleOpens(c) <= d`.
  - `final worldManagerServiceProvider = Provider<WorldManagerService>(...)`
- `CareerService.create` marks `worldManagersKind` for cycle 0, next to `fluidWindowsKind`. It does not seed.

- [ ] **Step 1: Write the failing tests.**
  - `manager_seeder_test.dart`:
    - `same seed same world`;
    - `one incumbent per AI nation and none at the player's`;
    - `60 free`;
    - `domestic share by pedigree within ±8 points over seeds 1..20`;
    - `every name is first + surname from that nationality's pool`;
    - `spell starts lie within 6 years of asOf`;
    - `no earlier spell overlaps its manager's current one`;
    - `a pack manager keeps its name and nationality`.
  - `world_pack_json_test.dart`:
    - `v2 migrates to v3 with empty managers`;
    - `v3 round trip keeps managers`;
    - `migrate refuses format 4`.
  - `lazy_seed_test.dart`:
    - `opening a career and reading the hub seeds nothing` (`hubDataProvider` and `nextEventProvider` read, then `hasManagers` is false);
    - `ensureSeeded twice writes once`;
    - `an upgraded 1.1.0 (37) mid_cycle fixture seeds as of its own cycle`;
    - `seeding the 1.1.0 (37) fixture takes one transaction`, asserted with a `QueryInterceptor` counting `BEGIN` statements equal to 1.
- [ ] **Step 2: Run** the three files. Expected: FAIL.
- [ ] **Step 3: Implement** the code. `namePoolsFor` exposes the pools the repository already builds and keeps no second copy.
- [ ] **Step 4: Run** the three files plus `test/unit/world_pack/` and `test/unit/world_managers/pinned_world_test.dart`. Expected: PASS, with the pin unchanged.
- [ ] **Step 5: Commit** `feat(managers): seeded fictional managers, pack format 3, lazy seeding`.

### Task 5: Style blend at the three AI-tactics call sites

**Files:**
- Modify: `lib/domain/services/match/ai_tactics.dart`, `lib/features/match/match_providers.dart:448`, `lib/features/hub/hub_providers.dart:1570` (`_withManagerTactics`), `lib/features/match/scout_report_providers.dart:57`
- Test: `test/unit/match/ai_tactics_blend_test.dart`, `test/unit/world_managers/style_agreement_test.dart`, `test/story/save_upgrade_test.dart` (append)

**Interfaces:**
- Consumes: `WorldManagerService.styleOn` (Task 4).
- Produces:
  - `AiTactics.forOpponent(..., NationStyle style, NationStyle? managerStyle)` and `typicalSetups(..., NationStyle? managerStyle)`.
  - Each of the six shifts becomes `((nation + manager) / 2).round()`.
  - With `managerStyle` null or equal to `style`, the output is identical to today's. The RNG draws are unchanged, because only the shift values move.
  - `AiCounter.forFixture` and `AiTactics.flexibility` keep the nation's `style`, so identity governs shape flexibility.
- The live match and the skip path call `styleOn(careerId, opponentId, fixture.date)`. The scout report calls it once per recent fixture, with that fixture's date.
- `final worldManagerStyleEnabledProvider = Provider<bool>((_) => true)`. Tests override it to false so the pinned world compares exactly.

- [ ] **Step 1: Write the failing tests.**
  - `ai_tactics_blend_test.dart`:
    - `null managerStyle equals today for 200 seeds × 8 styles`;
    - `blend is the rounded mean of both shifts`;
    - `same rng draws with and without a manager`.
  - `style_agreement_test.dart`, on a seeded career with one manager swapped on a known date:
    - `live, skip, scout and replay setups agree for the same fixture`;
    - `a fixture before the change reads the old manager, one after reads the new`;
    - `a fixture in a cycle without the marker reads NationIdentity`.
  - `save_upgrade_test.dart`: `opponents in the upgrade cycle read NationIdentity style`.
- [ ] **Step 2: Run** the three files. Expected: FAIL.
- [ ] **Step 3: Implement** the code.
- [ ] **Step 4: Run** the three files, plus `test/unit/match/tactics_impact_test.dart`, `test/unit/match/match_balance_guard_test.dart` and `pinned_world_test.dart` with style off. Expected: PASS. If a guard file named here does not exist, run `test/unit/match/` filtered with `--name "guard|impact"`.
- [ ] **Step 5: Commit** `feat(managers): manager style blends into AI tactics, read on the fixture date`.

### Task 6: The decision engine, reputation and the tenure lab

**Files:**
- Create: `lib/domain/services/world_managers/manager_decisions.dart`, `manager_reputation.dart`
- Modify: `lib/features/hub/objective_providers.dart` (make `continentalFinishOrdinal` public; logic unchanged)
- Test: `test/unit/world_managers/manager_decisions_test.dart`, `test/unit/world_managers/manager_tenure_guard_test.dart`, `test/unit/world_managers/manager_lab_test.dart` (skipped unless `FNM_LAB=1`)

**Interfaces:**
- Consumes: `ManagerWorld`, `ManagerChanges` and `ManagerMove` (Task 3).
- Produces:
  - `typedef NationWindow = ({int briefNet, double surpriseSum, bool settledFinalsBriefMet, bool anyBriefSettled})`
  - `typedef DecisionContext = ({DateTime date, Map<int, int> rankById, Set<int> scope, Set<int> playerNationIds, int rngSeed, String key, bool rollover})`
    - `scope` is the set of nations whose tournament just settled, or every nation at a rollover.
    - `key` is unique per decision point.
  - `ManagerDecisions.decide(ManagerWorld w, Map<int, NationWindow> windows, DecisionContext ctx, {Map<int, int> honoursByManager = const {}, List<WorldManager> entrants = const []}) -> ManagerChanges`
  - `ManagerReputation.of(int managerId, ManagerWorld w, Map<int, int> rankById, Map<int, int> honoursByManager) -> int`
    - Formula: `clamp(0, 100, 20 + Σ spells (years × (211 − rank) / 211 × 6) + honours × 8 + Σ briefNet × 4)`.
    - It is computed in memory only.
  - `ManagerDecisions.attractCap(int rank) = min(100, 40 + (211 − rank) * 0.3)`
- Rules, in order. Spec values first, then the rulings in brackets.
  1. **Score** = `briefNet + 0.5 × surpriseSum`. It is added to the current spell's `briefNet` and stored on the renewed spell.
  2. **Sack** if score < −2 at 60%, or score < −1 at 25%. A sack is blocked when the spell is under 12 months old, when the nation already changed in the last 12 months, or when `settledFinalsBriefMet` was true at a decision point in the last 12 months.
  3. **[Resign]** If the manager is not sacked, his score is below −2, and a finals brief was settled, he resigns at 15%.
  4. **Contract.** If `date >= contractUntil`, he is renewed for 2 to 6 years when score ≥ 0. Otherwise the spell ends `contractEnd`.
  5. **Cap.** At most 25% of the world's AI nations change at one decision point. Voluntary changes (2 to 4 and poaching) are cut worst score first. Forced vacancies (retired, replacedByPlayer, a nation the player left) are always filled.
  6. **Rollover only:** retirement chance `(age − 63) / 12` from age 64, so certainty at 75. Free managers unhired for 8 years leave, with `retiredAt` set.
  7. **Rollover only:** `entrants` are added to the pool before hiring. Task 7 builds them.
  8. **Rollover only, poaching.** A vacant nation ranked in the top 40 takes an employed manager at a nation at least 20 places lower whose reputation beats the best free candidate by 15 or more. The nation he left then hires from the pool, with no further chain.
  9. **Hiring** runs in rank order, best nation first. Each vacancy takes the best free manager by reputation whose reputation is at most `attractCap(rank)`, with +8 for a same-nationality exPlayer or exAssistant and +5 for any same-nationality manager. If nobody fits under the cap, it takes the lowest-reputation free manager. A new spell's contract runs 2 to 6 years.
  - RNG: `varietySeed('mgr:decide:${ctx.rngSeed}:${ctx.key}:<nationId>')`, one stream per nation.
- **Lab.** A synthetic world of 209 nations runs for 5 cycles × 8 seeds.
  - Two finals decision points per cycle and one rollover.
  - `NationWindow` values are drawn from rank-based noise (`briefNet ~ N(0, 1.2)`, `surpriseSum ~ N(0, 1.5)`), with no database.
  - It prints mean tenure, the share of nations changing per year, the share of changes in the post-finals window, and the maximum share at any single point.
  - Only the bracketed rulings (the resign rate and the contract spread) may be tuned. Spec numbers are not tuned.

- [ ] **Step 1: Write the failing tests** in `manager_decisions_test.dart`. Each rule above gets its own test:
  - `no results sack inside 12 months`;
  - `one change per nation per 12 months`;
  - `cap trims the worst scores first and fills forced vacancies`;
  - `met finals brief shields 12 months`;
  - `retirement certain at 75 and impossible at 63`;
  - `free 8 years leaves`;
  - `poach only top-40 vacancy from 20+ places lower with +15 reputation`;
  - `poached manager's old nation hires from the pool, no chain`;
  - `hiring respects attractCap and the domestic bonus`;
  - `renewal when score >= 0`;
  - `decide never touches nations outside scope or the player's`.
- [ ] **Step 2: Write** `manager_tenure_guard_test.dart` on the lab world with seeds 1 and 2 × 5 cycles. Assert:
  - mean tenure in `[4.0, 6.0]` years;
  - yearly change share in `[0.12, 0.28]`;
  - post-finals share ≥ 0.5;
  - maximum at any point ≤ 0.25.
- [ ] **Step 3: Run** both files. Expected: FAIL.
- [ ] **Step 4: Implement**, then run the lab with `FNM_LAB=1` and tune only the bracketed values until the guard holds. Record the lab output in the progress ledger.
- [ ] **Step 5: Run** both files plus `test/unit/hub/objective*`. Expected: PASS.
- [ ] **Step 6: Commit** `feat(managers): decision engine, reputation, tenure guard and lab`.

### Task 7: Decision points in the season

**Files:**
- Modify: `lib/features/world_managers/world_manager_service.dart`, `lib/features/hub/season_cycle.dart` (`_recordHonourIfDecided`, `_recordContinentalHonourIfDecided`), `lib/features/hub/season_rollover.dart` (`_startNextCycle`)
- Test: `test/unit/world_managers/decision_points_test.dart`, `test/story/save_upgrade_test.dart` (append)

**Interfaces:**
- Consumes: `ManagerDecisions.decide` (Task 6), `ensureSeeded` (Task 4).
- Produces on `WorldManagerService`:
  - `Future<List<ManagerMove>> afterFinals(int careerId, {required String key, required Set<int> scope, required DateTime date})`
  - `Future<List<ManagerMove>> atRollover(int careerId, {required int nextCycle})`
  - Both share one recipe:
    - return `[]` if the decision point's cycle lacks `worldManagersKind`, or if `mgrDecidedKind(key)` (or `mgrRolloverKind` for `nextCycle`) is already marked;
    - otherwise run `ensureSeeded`, then `load` once, one fixtures read for the window (from the later of the last decision point and spell start, up to `date`), one honours read, and windows built against the current cycle's seed-ranking snapshot;
    - then `decide`, then `apply`, with the marker written inside the same transaction.
  - Briefs reuse the pure targets as the player's do:
    - `worldObjectiveTarget` and `continentalObjectiveTarget`, both through `gradedQualifyingTarget`;
    - finishes from `worldFinishOrdinal` and `continentalFinishOrdinal`;
    - only targets above 0 count;
    - surprise uses `Expectation.surprise` over the window's competitive fixtures.
  - [Ruling] AI Nations Cup briefs are not scored. The surprise term covers those matches.
- Hooks:
  - `_recordHonourIfDecided`, after `recordHonour`: `afterFinals(key: 'wc:<year>', scope: all nations)`.
  - `_recordContinentalHonourIfDecided(conf)`: `afterFinals(key: 'cont:<CONF>:<year>', scope: that confederation)`.
  - `_startNextCycle`, after `recordStint`: mark `worldManagersKind` for `nextCycle`, then `atRollover`.
  - `atRollover` runs `ensureSeeded` before the cycle pointer moves. Task 8 adds the player's moves to it.

- [ ] **Step 1: Write the failing tests.**
  - `decision_points_test.dart`, with a seeded career and stubbed results:
    - `a decided World Championship runs one pass`;
    - `re-running the hook is a no-op`;
    - `a continental honour only touches its confederation`;
    - `a rollover runs retirements and poaching`;
    - `an unmarked cycle runs no pass`;
    - `a pass reads fixtures once` (QueryInterceptor count on `fixtures` ≤ 2).
  - `save_upgrade_test.dart` for `late_cycle`:
    - `the rollover stamps worldManagers1 on the new cycle only`;
    - `the upgrade cycle's World Championship ran no pass`;
    - `after the rollover every AI nation has a manager`.
- [ ] **Step 2: Run** both files. Expected: FAIL.
- [ ] **Step 3: Implement** the hooks and the service methods.
- [ ] **Step 4: Run** both files plus `test/unit/full_cycle_test.dart`. Expected: PASS.
- [ ] **Step 5: Commit** `feat(managers): sack, hire and poach at finals and rollover`.

### Task 8: The player's moves, departed assistants and ex-internationals

**Files:**
- Modify: `lib/features/world_managers/world_manager_service.dart`, `lib/features/hub/season_rollover.dart`, `lib/features/manager/manager_providers.dart` (`hire`), `lib/domain/services/manager/staff.dart` (`StaffMarket.cycleOf`), `lib/domain/repositories/competition_repository.dart` and its drift implementation (`capsUnder`)
- Test: `test/unit/world_managers/player_moves_test.dart`

**Interfaces:**
- Produces:
  - `WorldManagerService.playerMoved(int careerId, {required int? from, required int to, required DateTime date})`, called from `_startNextCycle` when `switching`.
    - The incumbent at `to` gets his spell ended `replacedByPlayer` and joins the pool, with a `grudge` tie at −25.
    - `from` hires at once, inside the same rollover pass, and the successor gets a `successor` tie at −25.
  - `WorldManagerService.assistantLeft(int careerId, {required int candidateId, required String name, required String? country, required DateTime date})`
    - It adds an `exAssistant` free manager (`sourceId: candidateId`) with a `protege` tie at +40, unless that `sourceId` already exists.
    - It is called from `hire` when the assistant post changes from one person to another or to nobody, and from `_startNextCycle` when switching with an assistant hired.
    - [Ruling] An empty `name` is re-derived through `StaffMarket.forRole` for the cycle `StaffMarket.cycleOf(candidateId)` returns. If that finds nothing, the name is `ManagerNames.build` from the home pool on `varietySeed('mgr:asst:$candidateId')`.
  - `StaffMarket.cycleOf(int id) -> int`: `(id - idBase) ~/ _cycleStride`.
  - **Rollover entrants** (Task 6 rule 7) top the pool back up to 60:
    - 60% fresh, nationality weighted `(6 − pedigree)^2`;
    - 40% ex-internationals: players the existing `InternationalRetirement` markers name, aged 36 to 45 in the rollover year, keeping their name and birth year (`exPlayer`, `sourceId` = player id).
  - `CompetitionRepository.capsUnder(int careerId, int playerId, int nationId, DateTime from, DateTime to) -> Future<int>`: `player_ratings` rows joined to `fixtures` of that nation in the range.
    - An entrant with at least 5 caps under the player (inside the player's `career_stints` at that nation) gets a `formerPlayer` tie at +20.

- [ ] **Step 1: Write the failing tests** in `player_moves_test.dart`:
  - `taking a job ends the incumbent replacedByPlayer with a grudge tie`;
  - `the nation left names a successor in the same rollover with a successor tie`;
  - `replacing the assistant puts him in the pool as protege`;
  - `a departed assistant from an earlier cycle enters the pool named`;
  - `the same assistant never enters twice`;
  - `an ex-international with 5 caps under you enters as former player`;
  - `the pool is back to 60 after a rollover`.
- [ ] **Step 2: Run** it. Expected: FAIL.
- [ ] **Step 3: Implement** the code.
- [ ] **Step 4: Run** it plus `test/unit/federation/staff*` and `test/unit/career/*offer*`. Expected: PASS, with the offers and verdicts unchanged.
- [ ] **Step 5: Commit** `feat(managers): react to the player's moves and departing staff`.

### Task 9: Relationships: warmth and labels

**Files:**
- Create: `lib/domain/services/world_managers/manager_relation.dart`
- Modify: `lib/features/world_managers/world_manager_providers.dart`
- Test: `test/unit/world_managers/manager_relation_test.dart`

**Interfaces:**
- Produces:
  - `enum TieLabel { neutral, respect, rival, grudge, successor, protege, formerPlayer }`. [Ruling] The spec's "old boss" is dropped because nothing in the spec creates it, and `successor` is added for the replacing-the-player tie.
  - `typedef ManagerRelation = ({int warmth, TieLabel label, int meetings, int won, int drawn, int lost})`
  - `ManagerRelation readRelation({required List<ManagerSpell> spells, required List<Fixture> meetings, required Set<int> playerSideAt(DateTime d), required List<ManagerTie> ties, required DateTime today})`
    - `meetings` are the player's competitive fixtures against the nations of the manager's spells, inside those spells' dates.
    - Events are walked in date order:
      - a knockout elimination either way: −10;
      - a player win by 3 or more: −5;
      - a tie row: its `delta`.
    - Warmth is multiplied by `0.75^(years since the last meeting)` at each event and again at `today`, then clamped to [−100, 100].
    - Label precedence:
      1. a structural tie (`grudge`, `successor`, `protege`, `formerPlayer`), which lasts for life;
      2. `rival`, when there are at least 2 knockout eliminations between the sides under him and the latest is within 2 cycles (8 years);
      3. `respect`, when warmth ≥ 30;
      4. otherwise `neutral`.
    - No meetings and no ties gives `neutral` and 0.
  - `final managerRelationProvider = FutureProvider.autoDispose.family<ManagerRelation, ({int careerId, int managerId})>(...)`. It reads the spells, ties and fixtures of only that manager's nations.

- [ ] **Step 1: Write the failing tests:**
  - `never met is neutral`;
  - `two knockout exits make rival`;
  - `rival fades to neutral after two cycles without a meeting`;
  - `heavy win costs 5`;
  - `grudge stays for life while its warmth decays 25% a year`;
  - `protege +40 and former player +20 label over warmth`;
  - `press dig -15 and respect +10 move warmth`.
- [ ] **Step 2: Run** `test/unit/world_managers/manager_relation_test.dart`. Expected: FAIL.
- [ ] **Step 3: Implement** the code.
- [ ] **Step 4: Run** it. Expected: PASS.
- [ ] **Step 5: Commit** `feat(managers): derived relationships with the player`.

### Task 10: Manager voices: news, the press beat and Y

**Files:**
- Create: `lib/domain/services/world_managers/manager_news.dart`
- Modify: `lib/features/world_managers/world_manager_service.dart` (post news after each pass), `lib/features/messages/message_sheet.dart` (`'manager'` icon `Icons.badge_outlined`), `lib/domain/services/press/conference.dart`, `lib/features/press/press_desk.dart`, `lib/domain/services/press/y_feed.dart`, `lib/features/y/y_providers.dart`, `copy/strings.csv`
- Test: `test/unit/world_managers/manager_news_test.dart`, `test/unit/press/opposing_manager_beat_test.dart`, `test/unit/y/manager_tie_post_test.dart`

**Interfaces:**
- Produces in `ManagerNews`:
  - `static List<ManagerMove> newsworthy(List<ManagerMove> moves, {required Set<int> tiedManagerIds, required Set<int> myNations, required Set<int> upcomingOpponents, required Set<int> confTop10})`
    - It keeps only moves touching one of those sets.
    - It keeps at most 3, ranked tied manager first, then my nations, then opponents, then the top 10.
  - Messages go out with category `'manager'` and dedupKey `'mgr:<key>:<nationId>'`. Title and body are `MsgPart`s with these keys: `mgrNewsSacked`, `mgrNewsResigned`, `mgrNewsPoached`, `mgrNewsRetired`, `mgrNewsContractEnd`, `mgrNewsReplacedByPlayer`, `mgrNewsAppointed`, `mgrNewsAppointedBody`.
- Press:
  - `BeatKind.opposingManager` and `AnswerKind.hitBackAtManager` and `AnswerKind.respectManager`, appended at the end of their enums (both are stored by name).
  - `ConferenceFacts` gains `({int managerId, String name, TieLabel label})? opposingManager`.
  - `ConferenceBuilder.opposingManagerBeat(ConferenceFacts f) -> Beat?` returns non-null only when the label is not neutral.
  - The desk adds it as the conference's last beat at most once. No new trigger is added and the cap is unchanged.
  - Answering writes `addTie(kind: pressDig, delta: -15)` or `(pressRespect, +10)`.
  - Copy keys: `pressBeatOpposingManager`, `pressAnswerHitBackAtManager`, `pressAnswerRespectManager`.
- Y:
  - `YFeed.forOpponentManager({required String manager, required TieLabel label, required DateTime date, required String key, required String nation, required int seed, ResultStanding standing})` returns at most one post.
  - It uses `YTemplate.managerTieLooms`, with 4 tone-banded variants keyed `yMgrTie1` to `yMgrTie4`, and the tone follows the speaker.
  - `y_providers.dart` calls it once per upcoming match whose opponent's manager on that date has a non-neutral label.
- Copy for all three goes into `copy/strings.csv` with `en` and `cs` filled.

- [ ] **Step 1: Write the failing tests.**
  - `manager_news_test.dart`:
    - `nothing outside the four sets`;
    - `never more than 3 per pass`;
    - `stored as meaning, rendered in cs`.
  - `opposing_manager_beat_test.dart`:
    - `no beat for a neutral manager`;
    - `one beat for a rival`;
    - `conference count unchanged`;
    - `answers write the tie`.
  - `manager_tie_post_test.dart`:
    - `one post before a match against a grudge`;
    - `none for neutral`;
    - `four variants reachable`.
- [ ] **Step 2: Run** the three files. Expected: FAIL.
- [ ] **Step 3: Implement**, then import the copy (`dart run tool/import_copy.dart`, then `flutter gen-l10n`).
- [ ] **Step 4: Run** the three files plus `test/unit/press/` and `test/unit/l10n/message_keys_test.dart`. Expected: PASS.
- [ ] **Step 5: Commit** `feat(managers): manager news, press beat and Y post`.

### Task 11: Nation page row, profile sheet, preview line and dossier

**Files:**
- Create: `lib/features/world_managers/manager_row.dart`, `manager_profile_sheet.dart`
- Modify: `lib/features/world_managers/world_manager_providers.dart`, `lib/features/nations/nation_now_card.dart`, `lib/features/match/match_preview_screen.dart` (`OpponentBriefing`), `lib/features/match/scout_report_view.dart`, `copy/strings.csv`
- Test: `test/widget/world_managers/manager_row_test.dart`, `test/golden/phone_guard_manager_profile_test.dart`, `test/widget/match_preview_manager_test.dart`

**Interfaces:**
- Consumes: `managerRelationProvider` (Task 9) and `WorldManagerService` (Task 4).
- Produces:
  - `nationManagerProvider`: `FutureProvider.autoDispose.family<NationManagerView?, ({int careerId, int nationId})>`. It calls `ensureSeeded`, then `currentAt`. `NationManagerView = ({WorldManager m, ManagerSpell spell, int age, int won, int drawn, int lost})`, where W/D/L are the nation's fixtures inside the spell.
  - `managerProfileProvider`: `.family<ManagerProfile, ({int careerId, int managerId})>`. `ManagerProfile = ({WorldManager m, List<ManagerSpell> spells, ManagerRelation relation, int reputation})`.
  - `opponentManagerProvider`: `.family<NationManagerView?, ({int careerId, int nationId, DateTime date})>`, through `inChargeOn`.
  - `NationNowCard` gains a `_Section(key: NationNowCard.managerKey, label: l.mgrRowLabel)` holding a `ManagerRow`: flag, name, age, appointment date and record. Tapping it opens `ManagerProfileSheet`. The card's own `nationNowProvider` does not change. The row watches its own provider.
  - `OpponentBriefing` adds one line with the manager and his `TieChip` when the label is not neutral.
  - The dossier (scout report) adds the manager's style and your record against him.
  - `TieChip(TieLabel)` copy keys: `mgrTieNeutral`, `mgrTieRespect`, `mgrTieRival`, `mgrTieGrudge`, `mgrTieSuccessor`, `mgrTieProtege`, `mgrTieFormerPlayer`.
  - End-reason keys: `mgrEndSacked`, `mgrEndResigned`, `mgrEndPoached`, `mgrEndRetired`, `mgrEndContractEnd`, `mgrEndReplacedByPlayer`.
  - Profile labels: `mgrProfileSpells`, `mgrProfileRecordVsYou`, `mgrProfileReputation`, `mgrProfileAge`, `mgrProfileAppointed`.
  - Style names reuse the existing `NationStyle` labels if they exist. Otherwise add `mgrStyle<Name>` keys.
- The player's own nation shows no row.

- [ ] **Step 1: Write the failing tests.**
  - `manager_row_test.dart`:
    - `another nation's page shows the manager row`;
    - `your own nation shows none`;
    - `tap opens the profile with spells, record and tie`;
    - `the row does not rebuild NationNowCard's provider`.
  - The phone guard golden of the profile sheet at 390 px, en and de.
  - `match_preview_manager_test.dart`:
    - `preview names the opposing manager`;
    - `tie chip only when not neutral`.
- [ ] **Step 2: Run** the three files. Expected: FAIL.
- [ ] **Step 3: Implement**, then import the copy.
- [ ] **Step 4: Run** the three files plus `test/golden/phone_guard_h2h_test.dart` and the nation vitrine tablet test. Expected: PASS.
- [ ] **Step 5: Commit** `feat(managers): manager on the nation page, preview and dossier`.

### Task 12: The managers list (Current and Recent moves)

**Files:**
- Create: `lib/features/world_managers/managers_screen.dart`, `managers_tablet_layout.dart`
- Modify: `lib/core/routing/app_router.dart` (`Routes.managers = '/managers'`, which expects `?careerId=`), `lib/features/shell/shell_destinations.dart` (add `Routes.managers` to the ranking destination's `alsoActiveOn`), the ranking screen app bar (an action icon `Icons.badge_outlined` with tooltip `mgrListTitle`), `lib/features/shell/tablet_shell.dart` (`tabletReadyPaths`), `copy/strings.csv`
- Test: `test/widget/world_managers/managers_screen_test.dart`, `test/widget/tablet_route_sweep_test.dart` (extend)

**Interfaces:**
- Produces:
  - `managersListProvider`: `.family<List<ManagerListRow>, int>`. `ManagerListRow = ({WorldManager m, int nationId, Confederation conf, int reputation, ManagerSpell spell})`.
  - `recentMovesProvider`: `.family<List<ManagerMove>, int>` through `movesSince(today − 2 years)`.
  - The screen has two tabs, `mgrListCurrent` and `mgrListRecentMoves`, a confederation filter, and sorting by reputation (the default) or by name. Copy keys: `mgrListTitle`, `mgrListCurrent`, `mgrListRecentMoves`, `mgrListFilterAll`, `mgrListSortReputation`, `mgrListSortName`, `mgrListEmptyMoves`.
  - Tapping a row opens `ManagerProfileSheet` (Task 11).
  - [Ruling] The spec's "Nations area" is the world ranking screen, because the app has no separate Nations section.

- [ ] **Step 1: Write the failing tests** in `managers_screen_test.dart`:
  - `current lists every AI nation's manager once`;
  - `filter by confederation`;
  - `sort by reputation`;
  - `recent moves shows the last two years`;
  - `ranking action opens it`.
  - Then add `/managers` to the tablet sweep.
- [ ] **Step 2: Run** both files. Expected: FAIL.
- [ ] **Step 3: Implement**, then import the copy.
- [ ] **Step 4: Run** both files. Expected: PASS.
- [ ] **Step 5: Commit** `feat(managers): managers list with recent moves`.

### Task 13: Editor: the Managers name section

**Files:**
- Modify: `lib/features/editor/names/name_sections.dart`, `name_section_screen.dart`, `name_edit_form.dart`, `lib/domain/services/world_pack/pack_rules.dart`, `pack_keys.dart`, `lib/features/editor/pack_issue_text.dart`, `copy/strings.csv`
- Test: `test/unit/world_pack/pack_rules_test.dart` (extend), `test/widget/editor/managers_section_test.dart`, `test/unit/world_managers/pack_managers_story_test.dart`

**Interfaces:**
- Consumes: `WorldPack.managers` (Task 4).
- Produces:
  - A `NameSection.managers` entry that lists every nation.
  - Each row edits name and nationality. The nationality is picked from `PackGameKeys.countryCodes`.
  - An empty row shows the hint `editorManagersHint`: "Chosen when a career starts".
  - [Ruling] The default incumbent depends on the career's seed, so the editor cannot show his name.
  - Pack rules:
    - name trimmed, 1 to 40 characters;
    - nationality must be a known code;
    - a nation id must be in `PackGameKeys.nationIds`;
    - a failure is refused as `badData`, with issue text `editorIssueManagerName` or `editorIssueManagerNationality`.
  - `pack_codec` writes format 3. A 1.1.0 build that opens a format-3 pack refuses it with its existing "newer" message (owner decision 3).
  - Copy keys: `editorSectionManagers`, `editorManagersHint`, `editorManagerName`, `editorManagerNationality`, plus the two issue keys.

- [ ] **Step 1: Write the failing tests.**
  - `pack_rules_test.dart`:
    - `a manager name over 40 chars is refused`;
    - `an unknown nationality is refused`;
    - `an unknown nation id is refused`.
  - `managers_section_test.dart`:
    - `editing Czechia's manager saves to pack.managers`;
    - `clearing the row removes it`.
  - `pack_managers_story_test.dart`: `a career on a pack renaming Czechia's manager shows that name on day one, and later hires use pack name lists`.
- [ ] **Step 2: Run** the three files. Expected: FAIL.
- [ ] **Step 3: Implement**, then import the copy.
- [ ] **Step 4: Run** the three files plus `test/unit/world_pack/` and `test/unit/l10n/editor_copy_test.dart`. Expected: PASS.
- [ ] **Step 5: Commit** `feat(editor): managers name section, pack format 3`.

## Host stadium rules (Tasks 14 to 16)

These three tasks have no dependency on the managers tasks and no dependency on the 1.1.1 calendar (`calendar2`, `DrawSlots` and `Competitions.edition` are not built). They use markers only and add nothing to schema 55. Owner decision 3 (planned stadiums) is defined as follows:

- **Planned ground.** A bid may promise new grounds to close its shortfall. Each one is sized to the bar slot it fills (final, semi or other seats).
- **Cost.** The player pays exactly the stadium works price the stadium screen already charges: `NationalStadiums.buildCost(nationId)`, plus `enlargeCost` steps up to the slot's seats. It is charged with the pledge at the rollover, together with the bid levels, out of the same free funds the offer reads (`rolloverMoney`).
- **Delivery deadline.** A paid planned ground is written as `StadiumWork.build` (plus `resize` if needed) with `cycle = editionCycle − 1`, so it opens on the first day of the edition's cycle (`openIn(editionCycle)`), well before the tournament. A ground promised for a bid may not be downsized below its promised seats until the edition has been played. The stadium screen blocks it with the copy `hostPlanLocked`.
- **Broken promise (player).** If the pledge cannot be paid in full at the rollover:
  - the bid lapses (the existing `lapsedKind`);
  - `hostPromiseBrokenKind(comp, editionCycle) = 'hostPromiseBroken:<comp>:<editionCycle>'` is stamped;
  - the board loses 5 for the new cycle, through a `PressAnswers`-style board effect row with `questionKey 'hostPromiseBroken:<comp>:<cycle>'`;
  - a `board` news item goes out (`hostPromiseBrokenTitle` and `hostPromiseBrokenBody`);
  - that nation cannot bid for the next edition of the same tournament.
  - A pledge that lapses because the manager changed nation is not a broken promise. It lapses quietly, as today.
- **AI planned grounds.** An AI nation ranked in the world top 30 on the edition's seed ranking may count up to 4 planned grounds (World Championship) or 2 (continental) to reach the bar alone.
  - It breaks its promise with a deterministic 10% roll (`varietySeed('host2:promise:<seed>:<comp>:<cycle>:<nationId>')`).
  - A broken AI promise delivers one planned ground fewer. The edition is played in the grounds that exist, never padded.
  - That nation is barred from the next 2 editions of that tournament.

### Task 14: Host bars, qualifying grounds, joint bids and the v2 marker

**Files:**
- Create: `lib/domain/services/competition/host_stadium_rules.dart`
- Modify: `lib/domain/services/competition/host_bidding.dart` (the `rules2` marker), and the nation read that turns `hostRules:` markers into `Nation.hostBids` (follow `HostBidding.decodeRules` to its reader)
- Test: `test/unit/competition/host_stadium_rules_test.dart`

**Interfaces:**
- Produces:
  - `typedef HostBar = ({int grounds, int finalSeats, int semiGrounds, int semiSeats, int otherSeats})`
  - `HostStadiumRules.worldChampionship = (grounds: 10, finalSeats: 60000, semiGrounds: 2, semiSeats: 40000, otherSeats: 30000)`
  - `HostStadiumRules.continental(Confederation c)`, with values from the Global Constraints table:
    - europe `(8, 50000, 2, 35000, 25000)`;
    - africa and asia `(6, 40000, 1, 30000, 20000)`;
    - northAmerica `(6, 40000, 1, 30000, 20000)`;
    - southAmerica `(5, 40000, 1, 30000, 20000)`;
    - oceania `(2, 10000, 0, 0, 5000)`.
  - `HostStadiumRules.of(HostBidComp comp, Confederation c)`
  - `HostStadiumRules.shortfall(List<int> seats, HostBar bar) -> ({int grounds, bool finalGround, int semiGrounds})`
    - The biggest ground fills the final slot, the next `semiGrounds` fill the semi slots, and every ground of at least `otherSeats` counts toward `grounds`.
  - `HostStadiumRules.meets(List<int> seats, HostBar bar) -> bool`
  - `HostStadiumRules.qualifyingSeats({required int nationId, required int editionCycle, List<NationalStadium> estate = const []}) -> List<int>`
    - It uses the seed grounds from `national_stadium_data.dart`. When `estate` is given (the manager's nation), it uses the estate grounds where `openIn(editionCycle)`.
    - Generated cities are never included.
  - `HostStadiumRules.jointBid({required Nation lead, required List<Nation> candidates, required Map<int, List<int>> seatsById, required HostBar bar}) -> List<int>?`
    - Partners come from the same subregion (`NationGeography.subregionFor`) first, then the same confederation, nearest ranked first, up to 3 hosts in all.
    - Each co-host must bring at least 2 grounds of `otherSeats` or more.
    - The result lists the nation holding the final ground first.
    - It returns null if no combination reaches the bar.
  - `HostStadiumRules.plannedAi({required int worldRank, required HostBidComp comp, required List<int> seats, required HostBar bar}) -> List<int>`
    - It returns the planned seats that close the shortfall. The list is empty when the nation is outside the top 30 or the shortfall exceeds the cap.
  - `HostBidding.rules2Kind(int cycle) = 'hostRules2:$cycle'`, `decodeRules2`, and `rules2Key(int cycle) = 'r2:$cycle'`. The key goes on `Nation.hostBids` of the manager's nation, the same way `managerKey` is carried.
  - `bool WorldCupHosts.isV2(int cycle, List<Nation> nations)` checks whether any nation carries `rules2Key(cycle)`.

- [ ] **Step 1: Write the failing tests:**
  - `solo-eligible World Championship hosts in seed data are ENG ESP GER FRA ITA TUR ARG BRA USA RSA CHN JPN KOR`;
  - `EURO solo-eligible count is 7`;
  - `AFCON 9, Asian Cup 14, Gold Cup USA MEX CAN, Copa 9 of 10, Oceania NZL FIJ NCL PNG TAH`, each computed from the data and asserted against the spec's column;
  - `generated cities never count`;
  - `an estate ground counts only from the cycle it opens`;
  - `joint bid prefers the same subregion, caps at 3, needs 2 grounds per co-host, lists the final-ground holder first`;
  - `no bid when no neighbours close the gap`;
  - `plannedAi only for the top 30 and within the cap`;
  - `rules2 round-trips and is not a bid or rules marker`.
- [ ] **Step 2: Run** `test/unit/competition/host_stadium_rules_test.dart`. Expected: FAIL. If a solo-eligible list differs from the spec, report the data's list in the test's failure text, keep the data's list, and note the difference in the progress ledger. Do not change the data.
- [ ] **Step 3: Implement** the code.
- [ ] **Step 4: Run** it plus `test/unit/competition/host*`. Expected: PASS.
- [ ] **Step 5: Commit** `feat(hosts): stadium bars, qualifying grounds, joint bids, v2 marker`.

### Task 15: v2 host selection and venues, behind the per-edition marker

**Files:**
- Modify: `lib/domain/services/competition/hosts.dart` (`hostBids`, `_bidsFromShortlist`, `continentalHostsFor`, `_wcHostChain`), `lib/domain/services/competition/venues.dart` (`forHosts`), `lib/features/career/career_providers.dart` and `lib/features/hub/season_rollover.dart` (stamp `rules2Kind`)
- Test: `test/unit/competition/hosts_v2_test.dart`, `test/story/save_upgrade_test.dart` (append)

**Interfaces:**
- Consumes: Task 14.
- Produces:
  - For an edition where `isV2(cycle)` holds:
    - every shortlisted nation that fails `meets` either stands in a `jointBid` or, for the AI, counts `plannedAi` grounds;
    - otherwise it is dropped from that edition;
    - the ranking-weighted draw, the last-3-hosts exclusion and the previous-confederation exclusion are unchanged.
  - An edition without the marker runs today's code path untouched, inside `_wcHostChain` as well.
  - `VenueGenerator.forHosts(..., bool qualifyingOnly = false)`: when true, it uses only qualifying grounds and delivered planned grounds (named `NationalStadiums.newStadiumName(city)`), up to `countForField`, never padded.
  - Stamping: at creation, mark `rules2Kind(0)` next to `rulesKind(0, nationId)`. In the rollover, mark `rules2Kind(next)` next to `rulesKind(next, ...)`, unless a legacy `hostBid:` / `hostBidPledge:` marker exists for that edition.
  - The AI broken-promise bar is read from the chain itself (deterministic), so no marker is needed.

- [ ] **Step 1: Write the failing tests.**
  - `hosts_v2_test.dart`:
    - `no v2 edition is hosted below its bar for seeds 1..40` (World Championship and every confederation);
    - `an unmarked edition picks exactly today's hosts for seeds 1..40`;
    - `a small nation hosts only inside a joint bid`;
    - `v2 venues are all qualifying and number 10 to 16 for the World Championship`;
    - `an AI broken promise plays in one fewer ground and bars the next two editions`;
    - `an edition with a legacy pledge is not stamped`.
  - `save_upgrade_test.dart`:
    - `every awarded edition's hosts and venues equal the manifest after migration and after the rollover`;
    - `the upgrade cycle carries no hostRules2`;
    - `the next cycle carries hostRules2 unless a legacy pledge exists`.
- [ ] **Step 2: Run** both files. Expected: FAIL.
- [ ] **Step 3: Implement** the code.
- [ ] **Step 4: Run** both files plus `test/unit/competition/` and `test/story/host_qualifying_test.dart` and `test/story/host_bid_end_of_cycle_test.dart`. Expected: PASS.
- [ ] **Step 5: Commit** `feat(hosts): stadium-aware host selection and venues for new editions`.

### Task 16: The player's bid: checklist, co-hosts and planned stadiums

**Files:**
- Modify: `lib/domain/services/competition/host_bidding.dart` (`HostBidMarker2`), `lib/features/federation/host_bid_providers.dart`, `host_bid_screen.dart`, `national_stadiums_screen.dart`, the `HostBidService` in `lib/features/federation/host_bid_providers.dart` (`settlePledges`, `resolveDue`), `copy/strings.csv`
- Test: `test/unit/federation/host_bid_v2_test.dart`, `test/widget/host_bid_checklist_test.dart`

**Interfaces:**
- Produces:
  - `class HostBidMarker2`:
    - `prefix = 'hostBid2:'`, `pledgePrefix = 'hostBid2Pledge:'`;
    - fields: `comp`, `editionCycle`, `nationId`, `levels`, `permille`, `List<int> partners`, `List<int> plannedSeats`;
    - encoded as `hostBid2:<comp>:<cycle>:<nation>:<levels>:<permille>:<partners joined by . or ->:<seats joined by . or ->`;
    - `encode`, `decode`, `encodePledge`, `decodePledge`.
  - The old `HostBidMarker` decode stays untouched, and every reader of bids reads both kinds.
  - `hostBidChecklistProvider`: `.family<HostChecklist, ({int careerId, HostBidComp comp, int editionCycle})>`. `HostChecklist = ({HostBar bar, List<int> held, ({int grounds, bool finalGround, int semiGrounds}) shortfall, List<List<int>> partnerOptions, List<int> plannedSeats, int plannedCost})`.
    - Partner options come from `jointBid` alternatives.
    - Planned seats and cost come from the stadium works price (see the section intro).
  - The screen shows a checklist (grounds needed and held, the final ground, the semi grounds). When the nation falls short, it offers partner chips, a "promise new stadiums" option with its cost, and a link to the stadium screen. Confirm is disabled until the bar is met, so a bid that cannot meet the bar cannot be lodged.
  - `settlePledges` pays the planned cost with the levels. It writes the build and resize works with `cycle = editionCycle − 1`, or applies the broken-promise path (section intro) when the money is short.
  - `HostBidService.barredFor(int careerId, HostBidComp comp, int editionCycle) -> Future<bool>` reads `hostPromiseBroken` for the previous edition.
  - The stadium screen blocks downsizing a promised ground (`hostPlanLocked`).
  - Copy keys: `hostCheckTitle`, `hostCheckGrounds`, `hostCheckFinal`, `hostCheckSemis`, `hostCheckMet`, `hostCheckShort`, `hostCoHostOffer`, `hostCoHostWith`, `hostPlanOffer`, `hostPlanCost`, `hostPlanDeadline`, `hostPlanLocked`, `hostPromiseBrokenTitle`, `hostPromiseBrokenBody`, `hostBidBarred`, `hostCheckBuildLink`.
  - All the English uses "World Championship".

- [ ] **Step 1: Write the failing tests.**
  - `host_bid_v2_test.dart`:
    - `hostBid2 round-trips and old hostBid still decodes`;
    - `a short bid cannot be lodged`;
    - `a joint bid with a neighbour is lodged and drawn as a joint host`;
    - `planned grounds are charged at the stadium price with the pledge and open for the edition`;
    - `an unpaid planned-ground pledge lapses, is marked broken and bars the next bid`;
    - `moving nation lapses a pledge without a broken promise`;
    - `a promised ground cannot be downsized before its edition`.
  - `host_bid_checklist_test.dart`:
    - `checklist shows held and needed`;
    - `partners offered when short`;
    - `confirm disabled until met`.
- [ ] **Step 2: Run** both files. Expected: FAIL.
- [ ] **Step 3: Implement**, then import the copy.
- [ ] **Step 4: Run** both files plus `test/unit/federation/host*` and `test/golden/phone_guard_*host*`, if such guards exist. Expected: PASS.
- [ ] **Step 5: Commit** `feat(hosts): bid checklist, co-hosts and planned stadiums`.

## Copy and release (Tasks 17 and 18)

### Task 17: Copy in 28 languages

**Files:**
- Modify: `copy/strings.csv`, then `lib/l10n/app_*.arb` through the tools
- Test: `test/unit/l10n/` (every guard), plus a new `test/unit/l10n/world_managers_copy_test.dart`

- [ ] **Step 1: Write the test.** `world_managers_copy_test.dart` checks every key with the prefixes `mgr`, `pressBeatOpposingManager`, `pressAnswer*Manager`, `yMgrTie`, `editorManager*`, `editorSectionManagers`, `editorIssueManager*`, `host*` (new keys only, listed in the test) and `saveUpgradeFailed*`. Each must exist in all 28 locales, and outside `en` none may equal the English text. Names and the flag codes are allow-listed.
- [ ] **Step 2: Run** it. Expected: FAIL.
- [ ] **Step 3: Translate.** Run `dart run tool/export_copy.dart` and fill all 28 columns. Then run `dart run tool/import_copy.dart --dry-run` and `dart run tool/import_copy.dart`, then `flutter gen-l10n`. The file stays UTF-8 with a BOM and CRLF line ends. The importer is all-or-nothing, so fix whichever rows it names and run it again.
  - No em dashes, and no Czech ` – ` pause dash.
  - Never "World Cup" in English, and no ALL CAPS.
  - Tie chips must fit at 390 px in de, fi and hu.
- [ ] **Step 4: Run** `test/unit/l10n/` plus `test/golden/phone_guard_manager_profile_test.dart` in cs and de. Expected: PASS.
- [ ] **Step 5: Commit** `feat(copy): world managers and host rules in all languages`.

### Task 18: End-to-end stories, device timing and the full suite

**Files:**
- Create: `test/story/world_managers_story_test.dart`, `test/story/host_rules_story_test.dart`
- Modify: `test/story/save_upgrade_test.dart` (final assertions)

- [ ] **Step 1: Rebase** onto main. Re-run Task 1's upgrade test and the pinned world. Expected: PASS.
- [ ] **Step 2: Write the managers story.** Seed 42, Czechia, through the first rollover. It walks the spec's acceptance checks 1, 3, 4, 5, 6 and 7:
  - every nation page has a manager;
  - a second career at the same seed has identical managers;
  - in the year after the World Championship, Recent moves lists 15 to 30% of nations;
  - at most 3 manager news items per decision point;
  - take an offer, and the old incumbent shows grudge while the left nation names a successor in the same advance;
  - replace the assistant, and he is in the pool as protégé;
  - live, skip and scout agree on manager and style.
- [ ] **Step 3: Write the host story.** Over seeds 1..10, through two rollovers:
  - no v2 edition is hosted below its bar;
  - every v2 host city on the cup screen is at least the bar;
  - the player's short bid shows the checklist and offers partners;
  - cycle-0 hosts equal a pre-feature run of the same seed (golden from Task 1's `pre55` manifest).
- [ ] **Step 4: Add the final upgrade assertions** to `save_upgrade_test.dart`, for every build × save:
  - the export after the upgrade carries the manager rows;
  - re-importing keeps them;
  - the pre-upgrade copy exists, and opens at the old version with the same careers.
- [ ] **Step 5: Run** the two stories and `save_upgrade_test.dart`. Expected: PASS.
- [ ] **Step 6: Run the full suite** after the pgrep wait: `caffeinate -dimsu timeout 5400 flutter test`. Expected: all green. A failure caused by sleep or a timeout is rerun file by file, never assumed.
- [ ] **Step 7: Device timing on the Galaxy A56** (FNM Dev build, `FNM_DEV_APP=1`, `adb install -r` only, after pulling the app data).
  - Restore the 1.1.0 (37) `late_cycle` fixture through Settings, Backups.
  - Open the last career, then open a nation page.
  - Read `adb logcat` for `career-open` and `mgr-seed`.
  - Expected: `career-open` within 10% of Task 1's before number, and `mgr-seed` under 50 ms.
  - Record both in the progress ledger. If `mgr-seed` is 50 ms or more, stop and report. Do not merge.
- [ ] **Step 8: Commit** `test(managers): end-to-end stories, upgrade checks, device timing`.

---

## Self-review notes

- **Spec coverage.** Sections 1 to 8 map onto Tasks 3 to 13. Section 10 checks 1 to 9 are covered by Tasks 4, 7, 8, 9, 5, 17, 13 and 18. Save safety is covered by Tasks 1, 2, 15 and 18. Host section 6 is covered by Tasks 14 to 16, with owner decision 3 defined in the hosts intro.
- **Ruled gaps.** These are listed in the hand-off: id columns, AI Nations Cup briefs, `briefNet`, labels, resignation, the Nations area, the editor's default names, the assistant names, the seeding date, gating by marker, and the planned-stadium terms.
- **Names used across tasks.**
  - `worldManagersKind`, `WorldManagerService.ensureSeeded/styleOn/afterFinals/atRollover/playerMoved/assistantLeft`, `ManagerWorld.inChargeOn`, `ManagerDecisions.decide`, `readRelation`, `TieLabel`.
  - `HostStadiumRules.of/meets/shortfall/qualifyingSeats/jointBid/plannedAi`, `HostBidding.rules2Kind/rules2Key`, `HostBidMarker2`.
