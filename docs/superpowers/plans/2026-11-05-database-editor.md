# Database Editor (1.1.0) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Players build their own starting worlds ("databases") in an in-game editor, share them as `.fnmdb` files, and start new careers on them; the default game is untouched.

**Architecture:** A database is a `WorldPack`: full squads per nation plus name overrides and trophy PNGs, stored in new Drift tables. Starting a career copies the pack into career-scoped tables (`career_worlds`), so the career never depends on the pack again. At read time the existing seams consult the career's world: `DriftPlayerRepository` swaps the seeded core rows and names, a `Zone` value carries potential overrides into the static development code, and an `ActiveWorld` holder feeds the pure display functions (`competitionLabel`, `NationRowMapper`, sponsors, press, Y, stadiums, trophies). No world row = default career = exactly today's behaviour.

**Tech Stack:** Flutter, Riverpod 2.6.1 (no codegen), Drift (schema 52 → 53), go_router, `share_plus`, `file_picker`, `dart:io` gzip + JSON, `dart:ui` image codec for PNG re-encoding (no new image package), native method channel for OS "open file".

**Spec:** `docs/superpowers/specs/2026-11-04-database-editor-design.md`

## Global Constraints

- Existing saves and default-world careers must behave byte-for-byte as before: same names, attributes, clubs, rankings for the same seed.
- Schema bump 52 → 53 follows the stepwise recipe in the comment at `lib/data/db/app_database.dart:118-129` (`build_runner --force-jit`, schema dump, `from52To53`, migration test).
- Never run two `flutter test` / `flutter build` processes at once; wrap long runs in `caffeinate -dimsu`.
- Every new user-facing string in all 28 ARBs via the `copy/strings.csv` round trip (`dart run tool/export_copy.dart` → edit → `dart run tool/import_copy.dart` → `flutter gen-l10n`). No em dashes. Never "World Cup" in English copy.
- Every new route joins `tabletReadyPaths` (`lib/features/shell/tablet_shell.dart:15`) with a tablet layout, and the sweep tests (`test/widget/tablet_full_screen_sweep_test.dart`, `tablet_route_sweep_test.dart`).
- No photos anywhere. Trophy PNGs only: World Championship 400×400, all other trophies 400×600, transparent.
- Free for everyone: no Pro checks in the editor, import, export or world choice. A career on a database still uses the normal slot and cycle rules.
- Campaigns always run on the default world.
- Work on branch `feature/world-editor`.

## Review Focus

1. **A default career after this ships**: same seed, same names, attributes, clubs and starting ranks as before. Test in Task 7.
2. **Pack deleted or edited after a career started on it**: the career is unchanged. Test in Task 6.
3. **A hostile or broken `.fnmdb`**: gzip bomb, wrong JSON types, 10 000-character names, 5 000 players in one nation, a JPEG or garbage bytes posing as a trophy, an unknown top-level key. The import is refused with a plain reason and nothing is written. Test in Task 12.
4. **A pack from a newer format version, or one naming a nation id the game no longer has**: a newer format is refused. An unknown id is kept but marked incompatible and cannot start a career. Tests in Tasks 12 and 18.
5. **Renaming two nations to the same code, a name made only of spaces, or a competition renamed to the empty string**: blocked in the editor and counted as an issue by completeness. Test in Task 3.

---

## File Structure

New, domain (pure Dart):
- `lib/domain/services/world_pack/world_pack.dart`: `WorldPack`, `PackPlayer`, `PackNameLists`, `PackReporter`, JSON codec, `formatVersion`.
- `lib/domain/services/world_pack/player_build.dart`: `PlayerType`, overall+type ⇄ attributes.
- `lib/domain/services/world_pack/pack_rules.dart`: field checks, completeness, compatibility.
- `lib/domain/services/world_pack/pack_ranking.dart`: starting ranks from squads.
- `lib/domain/services/world_pack/pack_codec.dart`: `.fnmdb` encode/decode with safety caps.
- `lib/domain/services/world_pack/active_world.dart`: `ActiveWorld` (display overrides) + `WorldZone` (zone key for potential).

New, data / features:
- `lib/data/repositories/world_pack_repository.dart`: CRUD for packs and career copies.
- `lib/features/world_pack/world_pack_providers.dart`: providers, `WorldPackService` (create from default, duplicate, import, export).
- `lib/features/world_pack/trophy_image.dart`: `TrophyImage` widget + `TrophyNormaliser`.
- `lib/features/world_pack/incoming_file.dart`: method-channel listener for OS-opened files.
- `lib/features/editor/…`: screens (Tasks 14 to 17), each with a `_tablet_layout.dart` twin.

Modified seams (exact lines are from the 2026-11-05 survey; re-check before editing):
- `lib/data/db/tables.dart`, `app_database.dart`: new tables, schema 53.
- `lib/data/db/career_bundle.dart`: carry `career_worlds` / `career_world_trophies`.
- `lib/data/repositories/drift_player_repository.dart`: `_seededRows`, `_namerFor` (:819), `_withClub` (:347), `byId` (:388).
- `lib/domain/services/squad/player_lifecycle.dart`: `developmentPotential` (:342), `isSuperstar` (:405).
- `lib/features/career/career_providers.dart`: `CareerService.create` (:177).
- `lib/data/repositories/mappers.dart:17`: `NationRowMapper.toDomain`.
- `lib/domain/entities/nation.dart`: `displayCode`.
- `lib/core/util/competition_label.dart:40`, `lib/core/util/sponsor_label.dart`, `lib/domain/services/press/press.dart:53,212`, `lib/features/y/y_providers.dart`, `lib/domain/services/federation/national_stadiums.dart:575`, `lib/domain/services/competition/venues.dart:471`, `lib/domain/services/club/clubs.dart`.
- Trophy render sites: `manager_history_screen.dart:321`, `tournaments_screen.dart:485`, `tournaments_tablet_layout.dart:228`, `tournament_summary.dart:105`, `tournament_kickoff_screen.dart:143`.
- `lib/features/home/home_screen.dart:151`, `home_tablet_layout.dart:93`, `lib/core/routing/app_router.dart`, `lib/features/nations/nation_select_screen.dart`, `lib/features/career/new_game_screen.dart:45`, `saves_screen.dart:546`, `saves_tablet_layout.dart:193`.
- `ios/Runner/Info.plist`, `ios/Runner/SceneDelegate.swift`, `android/app/src/main/AndroidManifest.xml`, `android/app/src/main/kotlin/.../MainActivity.kt`.

---

### Task 1: WorldPack model and JSON

**Files:**
- Create: `lib/domain/services/world_pack/world_pack.dart`
- Test: `test/unit/world_pack/world_pack_json_test.dart`

**Interfaces:**
- Produces:
  - `const int kPackFormatVersion = 1;`
  - `class PackPlayer { final int id; final String name; final int age; final PlayerPosition position; final PlayerAttributes attributes; final int potential; final String? club; final String? clubCountry; }`. `potential` is the peak overall, 1..99. `id` is the base id or ≥ `kPackPlayerIdBase`.
  - `const int kPackPlayerIdBase = 800000000;`
  - `class PackNameLists { final List<String> first; final List<String> sur; }`
  - `class PackReporter { final String name; final String outlet; }`
  - `class WorldPack` with:
    - `String uuid, name, author; int formatVersion; String madeWithVersion`
    - `Map<int, List<PackPlayer>> squads` (nationId → core squad)
    - `Map<int, ({String name, String code})> nations`
    - `Map<String, String> clubs` (original club name → new)
    - `Map<String, String> stadiums` (`'$nationId:$city'` → name)
    - `Map<String, String> competitions` (canonical stored English name → new)
    - `Map<String, String> yAccounts` (original display name → new)
    - `Map<int, PackReporter> reporters` (index in `Press._reporters` → new)
    - `Map<int, PackNameLists> nameLists` (nationId → lists)
    - `Map<String, String> sponsors` (`SponsorBrand.name` → new)
    - `Set<String> trophies` (keys with a custom PNG)
  - `WorldPack copyWith(...)`, `Map<String, Object?> toJson()`, `static WorldPack fromJson(Map<String, Object?>)`. `fromJson` throws `FormatException` on any wrong type.
  - `static Map<String, Object?> migrate(Map<String, Object?> json)`: upgrades any older `formatVersion` step by step to `kPackFormatVersion`. It is the identity at v1, and it is used both by `WorldPackRepository.load` (Task 4) and by import (Task 12), so stored packs survive format changes too. It throws `FormatException` for a newer version.

- [ ] **Step 1: Write the failing tests.** `round trip keeps every field` builds a pack with one entry in every map and asserts `WorldPack.fromJson(p.toJson()) == p`. `wrong types throw FormatException` takes `{'squads': 'x'}`, `{'nations': {'1': 5}}`, and a player whose `age` is `'20'`; each throws. `unknown top-level keys throw` asserts that `{'..valid..', 'script': '…'}` throws.
- [ ] **Step 2: Run** `flutter test test/unit/world_pack/world_pack_json_test.dart`. Expected: FAIL (file missing).
- [ ] **Step 3: Implement** `world_pack.dart`: plain immutable classes with value equality (`package:collection` `DeepCollectionEquality`) and hand-written JSON (no freezed, so the reader stays strict). Map keys are stored as strings in JSON.
- [ ] **Step 4: Run** the test. Expected: PASS.
- [ ] **Step 5: Commit** `feat(world-pack): pack model and strict JSON`.

### Task 2: Overall + type ⇄ qualities

**Files:**
- Create: `lib/domain/services/world_pack/player_build.dart`
- Test: `test/unit/world_pack/player_build_test.dart`

**Interfaces:**
- Consumes: `OverallRating.forPosition(PlayerPosition, PlayerAttributes)` (`lib/domain/services/rating/overall_rating.dart:26`).
- Produces:
  - `enum PlayerType { balanced, athlete, technician, engine }` with ratios physical:technical:stamina of 1:1:1, 1.15:0.9:1.0, 0.9:1.15:0.95 and 0.95:0.95:1.15.
  - `abstract final class PlayerBuild`:
    - `static PlayerAttributes attributesFor(PlayerPosition pos, PlayerType type, int overall)`
    - `static PlayerType typeOf(PlayerAttributes a)`, the type whose ratio is nearest by cosine.

- [ ] **Step 1: Write the failing tests.**
  - `every position, type and overall 20..99 lands within 1`: loop over all `PlayerPosition.values`, `PlayerType.values` and overall 20..99, and assert `(OverallRating.forPosition(pos, PlayerBuild.attributesFor(pos, t, o)) - o).abs() <= 1`.
  - `qualities stay within 1..99`.
  - `typeOf reads back the type it built` for overall 70, every position.
- [ ] **Step 2: Run** the test. Expected: FAIL.
- [ ] **Step 3: Implement.** Binary-search a scale `s` so that `round(ratio_i * s)`, clamped to 1..99, gives the target overall under `forPosition`. When clamping stops the search, adjust the uncapped qualities.
- [ ] **Step 4: Run** the test. Expected: PASS.
- [ ] **Step 5: Commit** `feat(world-pack): overall and player type build qualities`.

### Task 3: Rules: field checks and completeness

**Files:**
- Create: `lib/domain/services/world_pack/pack_rules.dart`
- Test: `test/unit/world_pack/pack_rules_test.dart`

**Interfaces:**
- Consumes: `WorldPack`, `PackPlayer` (Task 1).
- Produces:
  - `sealed class PackIssue { String get where; }`, with subclasses:
    - `SquadTooSmall(nationId, have, need)`
    - `NeedsPosition(nationId, PositionCategory, have, need)`
    - `BadField(path, reason)`
    - `DuplicateCode(code, nationIds)`
    - `UnknownId(path)`, used by Task 18.
  - `enum FieldReason { empty, tooLong, badCharacters, outOfRange }`
  - `abstract final class PackRules`:
    - `static const squadMin = 23, squadMax = 40, gkMin = 3, defMin = 6, midMin = 6, fwdMin = 3`
    - `static const nameMax = 40, handleMax = 30, codeLength = 3`
    - `static FieldReason? checkName(String s, {int max = nameMax})`: trimmed must be non-empty and ≤ max; no control characters (`\p{Cc}`) and no unpaired surrogates.
    - `static FieldReason? checkCode(String s)`: exactly 3 letters A–Z.
    - `static List<PackIssue> issues(WorldPack p)`: every issue, in nation order.
    - `static bool isComplete(WorldPack p) => issues(p).isEmpty;`
  - Ranges: age 15..45, overall 1..99, and potential ≥ the player's overall and ≤ 99.

- [ ] **Step 1: Write the failing tests.**
  - `a 22-man squad is too small`.
  - `two goalkeepers is not enough`.
  - `two nations renamed to the same code` gives a `DuplicateCode`.
  - `a name of spaces is empty`; `a 41-character name is too long`; `a tab inside a name is badCharacters`.
  - `a competition renamed to '' is empty`.
  - `potential below overall is outOfRange`.
  - `a duplicate player name inside a nation is not an issue` (spec: warning only; the warning lives in the UI).
- [ ] **Step 2: Run** the test. Expected: FAIL.
- [ ] **Step 3: Implement** as specified.
- [ ] **Step 4: Run** the test. Expected: PASS.
- [ ] **Step 5: Commit** `feat(world-pack): completeness and field rules`.

### Task 4: Storage, schema 53, career copy, bundle

**Files:**
- Modify: `lib/data/db/tables.dart`, `lib/data/db/app_database.dart`, `lib/data/db/career_bundle.dart`
- Create: `lib/data/repositories/world_pack_repository.dart`
- Test: `test/unit/world_pack/world_pack_repository_test.dart`; extend `test/unit/data/schema_migration_test.dart`; extend the existing career bundle round-trip test.

**Interfaces:**
- New tables:
  - `WorldPacks(id int PK autoinc, uuid text unique, name text, json text, updatedAt dateTime)`
  - `WorldPackTrophies(packId FK cascade, key text, png blob, PK packId+key)`
  - `CareerWorlds(careerId FK cascade PK, packName text, json text)`
  - `CareerWorldTrophies(careerId FK cascade, key text, png blob, PK careerId+key)`
- Produces `class WorldPackRepository(AppDatabase db)` with:
  - `Future<List<({int id, String name, DateTime updatedAt})>> list()`
  - `Future<WorldPack?> load(int id)`, which runs `WorldPack.migrate` before `fromJson`
  - `Future<int> insert(WorldPack p, Map<String, Uint8List> trophies)`
  - `Future<void> save(int id, WorldPack p)`
  - `Future<void> setTrophy(int id, String key, Uint8List? png)`
  - `Future<Map<String, Uint8List>> trophies(int id)`
  - `Future<void> delete(int id)`
  - `Future<int> duplicate(int id, String newName)`
  - `Future<void> copyToCareer(int packId, int careerId)`, which runs inside the caller's transaction.
  - `Future<({WorldPack pack, Map<String, Uint8List> trophies})?> forCareer(int careerId)`

- [ ] **Step 1: Write the failing tests.**
  - `insert, load, save, duplicate, delete round trip`.
  - `copyToCareer then delete the pack: forCareer still returns it` (Review Focus 2, storage half).
  - Migration test: `52 → 53 keeps every career and adds empty world tables`.
  - Bundle test: `a career on a world exports and imports with its world and trophies`; and `a bundle written before 53 imports as a default career`.
- [ ] **Step 2: Run** them. Expected: FAIL.
- [ ] **Step 3: Implement.** Add the tables and bump `currentSchemaVersion` to 53 following the recipe. Add `career_worlds` and `career_world_trophies` to `CareerBundle`'s `references`/`insertOrder` keyed by career id. Bump `CareerBundle.formatVersion` to 2, and keep accepting 1.
- [ ] **Step 4: Run** the tests plus `test/unit/data/`. Expected: PASS.
- [ ] **Step 5: Commit** `feat(world-pack): storage tables, schema 53, bundle carries the world`.

### Task 5: A new pack from the default world

**Files:**
- Create: `lib/features/world_pack/world_pack_providers.dart` (`WorldPackService` part 1)
- Test: `test/unit/world_pack/pack_from_default_test.dart`

**Interfaces:**
- Consumes: `PlayerRepository.byNation(...)` with `saveSeed: kPackDrawSeed`, `careerId: null`, `agingYears: 0`; `NationRepository.newCareerWorld()`; `WorldPackRepository.insert`.
- Produces:
  - `const int kPackDrawSeed = 20261104;` This is the one fixed name draw.
  - `final worldPackRepositoryProvider`, `final worldPacksProvider = FutureProvider<List<...>>`
  - `class WorldPackService { Future<int> createFromDefault(String name); Future<int> duplicate(int id, String name); Future<void> delete(int id); }`, exposed through `worldPackServiceProvider`.
  - `createFromDefault` stores the 23 core players of every `newCareerWorld()` nation, including their drawn name and attributes. Each player's `potential` is set to the peak overall that `PlayerLifecycle` would reach for that id (`PlayerBuild` is not involved). Every override map is empty and `formatVersion = kPackFormatVersion`.

- [ ] **Step 1: Write the failing tests.**
  - `the default pack is complete` (`PackRules.isComplete`).
  - `two packs created a day apart have the same names` (the draw is fixed).
  - `names are the drawn names, not players.json placeholders`.
- [ ] **Step 2: Run** them. Expected: FAIL.
- [ ] **Step 3: Implement.** Use the repository with `saveSeed: kPackDrawSeed`. Core players are the stored ids in `players.json`; fringe ids are not stored. For `potential`, use a new helper `PlayerLifecycle.peakOverall(int id, PlayerPosition pos, PlayerAttributes now, int age)`: the overall after aging to 27 at full minutes under default development.
- [ ] **Step 4: Run** the tests. Expected: PASS.
- [ ] **Step 5: Commit** `feat(world-pack): new pack from one fixed draw of the default world`.

### Task 6: Starting ranks from squads; career creation with a world

**Files:**
- Create: `lib/domain/services/world_pack/pack_ranking.dart`
- Modify: `lib/features/career/career_providers.dart` (`create`, :177), `lib/features/campaign/campaign_providers.dart` (assert it never passes a world)
- Test: `test/unit/world_pack/pack_ranking_test.dart`, `test/unit/world_pack/career_on_pack_test.dart`

**Interfaces:**
- Produces:
  - `Map<int,int> PackRanking.startingRanks({required Map<int,int> baseRanks, required Map<int,int> defaultStrength, required Map<int,int> packStrength})`
    - Strength is the average of the top 18 overalls (`squadStrength` in `overall_rating.dart:12` if it fits; otherwise a new top-18 helper).
    - Score = `-baseRank + 4 * (packStrength - defaultStrength)`. Sort by score descending and break ties by baseRank. Return ranks 1..n.
  - `CareerService.create(..., int? worldPackId)`. Inside the transaction it calls `copyToCareer`, writes marker `world:<uuid>` at cycle 0, and passes the computed `startingRanks`.

- [ ] **Step 1: Write the failing tests.**
  - `an untouched pack gives exactly the base ranks`.
  - `Andorra at 90 overall climbs into the top 10`.
  - `career on a pack, then the pack is edited and deleted, the career's squads are unchanged` (Review Focus 2, end to end through `byNation`; relies on Task 7, so write it here and expect it to pass after Task 7).
  - `campaigns never get a world`.
- [ ] **Step 2: Run** them. Expected: FAIL.
- [ ] **Step 3: Implement** both parts.
- [ ] **Step 4: Run** `pack_ranking_test.dart`. Expected: PASS. (`career_on_pack_test.dart` passes after Task 7.)
- [ ] **Step 5: Commit** `feat(world-pack): starting ranks follow the pack; careers copy their world`.

### Task 7: Player world reads the career's pack

**Files:**
- Modify: `lib/data/repositories/drift_player_repository.dart`, `lib/domain/services/club/clubs.dart`
- Test: `test/unit/world_pack/player_repo_world_test.dart`; extend an existing default-world golden (pick the namer fingerprint test that pins V4/V5 names).

**Interfaces:**
- Consumes: `WorldPackRepository.forCareer` (Task 4).
- Produces, inside the repository:
  - `_worldFor(int? careerId)`, a cached `WorldPack?`, null for default careers.
  - **Core rows:** `_seededRows(nationId)` becomes `_seededRowsFor(careerId, nationId)`. When the pack has `squads[nationId]`, they replace the stored core rows; fringe rows are kept.
  - **Names:** pack players keep the pack's name exactly (the namer skips them). Other players are named from `nameLists[nationId]` when present, otherwise from the normal pools.
  - **Removed and added players:** removed core players are simply absent. Added players (`id >= kPackPlayerIdBase`) are found by `byId`.
  - **Clubs:** in `_withClub`, a pack player's `club` applies while `ClubService.contractAt(p.id, p.age).index` equals the index at his career-start age. After that the normal clock carries on.
  - **Club renames:** `ClubService.renamed(ClubSide side, Map<String,String> renames)` is applied to every returned club.
  - **Clubs for the editor:** `ClubService.leagueClubs(String countryCode) -> List<String>`.

- [ ] **Step 1: Write the failing tests.**
  - `default career: names, attributes and clubs identical to before` (Review Focus 1). Snapshot 3 nations at seed 42 before the change; the golden is committed with the test.
  - `pack career: the edited name and attributes come back exactly`.
  - `pack career: an added player is in byNation and byId`.
  - `a removed player is gone`.
  - `day-one club holds until his first contract ends, then the clock moves him`.
  - `a renamed club is renamed for every player`.
  - `youth intake reads the edited squad strength` (a nation at all-90 gets a higher intake average than default).
- [ ] **Step 2: Run** them. Expected: FAIL.
- [ ] **Step 3: Implement** the seams listed above. Key every repository cache by `careerId` as well as nation.
- [ ] **Step 4: Run** the tests, `test/unit/world_pack/`, and every `test/**/*name*`, `*pool*`, `*club*` test. Expected: PASS.
- [ ] **Step 5: Commit** `feat(world-pack): careers read squads, names and clubs from their world`.

### Task 8: Potential is a ceiling; no hidden superstars in pack careers

**Files:**
- Create: `lib/domain/services/world_pack/active_world.dart` (`WorldZone` part)
- Modify: `lib/domain/services/squad/player_lifecycle.dart`, `lib/domain/services/squad/player_aging.dart`, `drift_player_repository.dart` (wrap reads in the zone)
- Test: `test/unit/world_pack/pack_potential_test.dart`

**Interfaces:**
- Produces:
  - `abstract final class WorldZone`:
    - `static R run<R>(Map<int,int> potentials, R Function() body)`, which uses `runZoned` with zone key `#fnmWorldPotentials`.
    - `static int? potentialOf(int playerId)`
    - `static bool get active`
  - `PlayerLifecycle.isSuperstar(id)` returns false when `WorldZone.active`.
  - Development caps a player's overall at `potentialOf(id)`. Below the cap, growth uses the pack target: `developmentPotential` maps `(target - currentOverall)` to the existing multiplier range 0.35..1.75 (linear: gap 0 → 0.35, gap ≥ 30 → 1.75).

- [ ] **Step 1: Write the failing tests.**
  - `potential 90 for an 19-year-old 70: reaches 86..90 by 27 with full minutes, never above 90`.
  - `potential equal to overall: stays within 1 of it until decline`.
  - `a default-superstar id plays at the edited overall in a pack career`.
  - `default careers: superstar behaviour unchanged` (re-run the existing superstar tests).
- [ ] **Step 2: Run** them. Expected: FAIL.
- [ ] **Step 3: Implement.** Every public read in `DriftPlayerRepository` for a pack career runs inside `WorldZone.run(pack potentials, ...)`; zones carry across `await`.
- [ ] **Step 4: Run** the tests plus `test/unit/squad/`. Expected: PASS.
- [ ] **Step 5: Commit** `feat(world-pack): edited potential is the peak; pack careers have no hidden superstars`.

### Task 9: ActiveWorld display overrides: nations and competitions

**Files:**
- Modify: `lib/domain/services/world_pack/active_world.dart`, `lib/domain/entities/nation.dart`, `lib/data/repositories/mappers.dart:17`, `lib/data/data_providers.dart:78`, `lib/core/util/competition_label.dart`, and the raw-code sites (`world_ranking_screen.dart:380`, `world_ranking_tablet_layout.dart:242`, `head_to_head_screen.dart:418,420`, `match_frame.dart:532`, `cup_detail_screen.dart:1276`, plus any other `.code` printed as text: grep for it).
- Test: `test/unit/world_pack/active_world_labels_test.dart`, `test/widget/world_labels_widget_test.dart`

**Interfaces:**
- Produces:
  - `class ActiveWorld` holds a `WorldPack?` and trophy bytes, with:
    - `static ActiveWorld current = ActiveWorld.none;`
    - `String? nationName(int id)`, `String? nationCode(int id)`
    - `String? competition(String stored)`, `String? sponsor(String brand)`, `String? stadium(int nationId, String city)`, `PackReporter? reporter(int index)`, `String? yAccount(String original)`
    - `Uint8List? trophy(String key)`
  - `final activeWorldProvider = StateProvider<ActiveWorld>`. A listener in the app root mirrors it into `ActiveWorld.current`. It is set when a career route opens (the provider watches the `careerId` from the router state) and reset on home/menu routes.
  - `Nation.displayCode` (`@Default('')`) plus `String get shortCode => displayCode.isEmpty ? code : displayCode;`. `code` stays the real FIFA key for flags and data.
  - `NationRowMapper.toDomain` applies the overrides, and `nationRepositoryProvider` watches `activeWorldProvider`.
  - `competitionLabel(l, stored)` returns `ActiveWorld.current.competition(stored)`, or for `'<X> Qualifiers'` uses the renamed base plus the localised qualifiers suffix, before translating. `continentalCupLabel` does the same.

- [ ] **Step 1: Write the failing tests.**
  - `renamed nation shows the new name in every language` (en, cs, ja).
  - `renamed code shows on the ranking row but the flag still uses the real code`.
  - `renamed European Championship shows in the cup header and in its Qualifiers label`.
  - `default world: labels unchanged` (run the existing `competition_label` tests).
  - `opening the menu resets the active world`.
- [ ] **Step 2: Run** them. Expected: FAIL.
- [ ] **Step 3: Implement.** Messages that already froze a nation or player name stay as written; that is accepted.
- [ ] **Step 4: Run** the tests plus `test/unit/l10n/`. Expected: PASS.
- [ ] **Step 5: Commit** `feat(world-pack): nation and competition names follow the career's world`.

### Task 10: ActiveWorld display overrides: sponsors, stadiums, press, Y, name lists

**Files:**
- Modify:
  - `lib/core/util/sponsor_label.dart`
  - `lib/domain/services/federation/national_stadiums.dart:575` (`forNation` output names) and `lib/domain/services/competition/venues.dart:471` (`_groundName`)
  - `lib/domain/services/press/press.dart`: add `int index` to `PressReporter`; `_Byline` in `press_sheet.dart:258` reads `ActiveWorld.current.reporter(index)`.
  - `lib/features/y/y_providers.dart`: rename the `displayName`/`handle` on the final post lists, after `traitFor`, so a renamed account keeps its voice.
  - `lib/features/federation/staff_providers.dart:47-61` and `lib/domain/services/press/y_locals.dart:60`: use the pack's `nameLists` when present.
- Test: `test/unit/world_pack/active_world_misc_test.dart`

- [ ] **Step 1: Write the failing tests.**
  - `renamed sponsor brand shows on the sponsor screen and its Y post`.
  - `renamed national stadium and renamed host venue show`.
  - `renamed reporter shows in the byline`.
  - `renamed Y account keeps its trait and shows its new name and handle`. The handle is derived as `'@' + name without spaces`, checked with `PackRules.handleMax`.
  - `staff and local fans draw from the pack's name lists`.
  - `default world unchanged`.
- [ ] **Step 2: Run** them. Expected: FAIL.
- [ ] **Step 3: Implement.**
- [ ] **Step 4: Run** the tests plus `test/unit/press/`, `test/widget/*y*`, `test/widget/*sponsor*`. Expected: PASS.
- [ ] **Step 5: Commit** `feat(world-pack): sponsors, stadiums, press, Y and name lists follow the world`.

### Task 11: Trophies: normaliser and TrophyImage

**Files:**
- Create: `lib/features/world_pack/trophy_image.dart`
- Modify: the five trophy render sites listed in File Structure.
- Test: `test/unit/world_pack/trophy_normaliser_test.dart`, `test/widget/trophy_image_test.dart`

**Interfaces:**
- Produces:
  - `abstract final class TrophyNormaliser`:
    - `static Size sizeFor(String key)`: `world` → 400×400, otherwise 400×600.
    - `static Future<({Uint8List png, bool hasAlpha})?> normalise(Uint8List input, String key, {Rect? crop})`. Decodes with `ui.instantiateImageCodec`, rejects inputs over 15 MB or images over 4096 px a side, crops, scales to fit `sizeFor` centred on a transparent canvas, and re-encodes with `toByteData(format: png)`. Returns null on anything undecodable.
  - `class TrophyImage extends StatelessWidget { const TrophyImage(this.trophyKey, {double? height}); }` shows `ActiveWorld.current.trophy(key)` as `Image.memory`, otherwise the asset (`Trophies.*`).

- [ ] **Step 1: Write the failing tests.**
  - `a 1000×1500 PNG comes out 400×600`.
  - `the world trophy comes out 400×400`.
  - `garbage bytes return null`.
  - `a JPEG is re-encoded to PNG, hasAlpha false`.
  - `TrophyImage shows the custom picture in a pack career and the asset otherwise`.
- [ ] **Step 2: Run** them. Expected: FAIL.
- [ ] **Step 3: Implement**, and replace each `Image.asset(trophy…)` with `TrophyImage(key)`.
- [ ] **Step 4: Run** the tests plus the trophy and tournament widget tests. Expected: PASS.
- [ ] **Step 5: Commit** `feat(world-pack): custom trophies, re-encoded, shown everywhere`.

### Task 12: `.fnmdb` export and import, with safety

**Files:**
- Create: `lib/domain/services/world_pack/pack_codec.dart`
- Modify: `world_pack_providers.dart` (`export`, `importFile`)
- Test: `test/unit/world_pack/pack_codec_test.dart`

**Interfaces:**
- Produces:
  - `abstract final class PackCodec`:
    - `static const extension = 'fnmdb', maxFileBytes = 8 << 20, maxJsonBytes = 6 << 20, maxPlayersPerNation = PackRules.squadMax, maxTrophies = 9`
    - `static Uint8List encode(WorldPack p, Map<String, Uint8List> trophies)`, gzip JSON `{format, pack, trophies: {key: base64}}`
    - `static Future<PackDecode> decode(Uint8List bytes)`
  - `sealed class PackDecode`: `PackDecoded(pack, trophies)` or `PackRejected(PackRejection reason)`.
  - `enum PackRejection { tooBig, notAPack, newerFormat, badData, badTrophy }`
  - Decode order:
    1. Check the size.
    2. Gunzip, streamed, aborting past `maxJsonBytes`.
    3. Parse the JSON.
    4. Migrate older formats.
    5. `WorldPack.fromJson`. Any length or range breach is `badData`. `PackRules` field checks run here, but completeness does not.
    6. Run every trophy through `TrophyNormaliser.normalise`; a null result is `badTrophy`.
    7. Unknown trophy keys are `badData`.
  - `WorldPackService.export(int id) -> Future<File>` writes `<name>.fnmdb` to temp and the UI shares it via `share_plus`.
  - `WorldPackService.importFile(String path) -> Future<Result<int>>` always inserts a new pack with a new uuid; the name gets " (2)" when it is already taken.

- [ ] **Step 1: Write the failing tests** (Review Focus 3 and 4).
  - `round trip`.
  - `9 MB file → tooBig`.
  - `gzip bomb (1 MB → 200 MB of spaces) → tooBig without exhausting memory`.
  - `a .fnmcareer or random bytes → notAPack`.
  - `format 99 → newerFormat`.
  - `10 000-character name → badData`.
  - `5 000 players in one nation → badData`.
  - `trophy that is not an image → badTrophy`.
  - `an extra 'script' key → badData`.
  - `a rejected import writes nothing` (repository count unchanged).
- [ ] **Step 2: Run** them. Expected: FAIL.
- [ ] **Step 3: Implement.**
- [ ] **Step 4: Run** the tests. Expected: PASS.
- [ ] **Step 5: Commit** `feat(world-pack): fnmdb export and safe import`.

### Task 13: Open a `.fnmdb` from the OS

**Files:**
- Modify: `ios/Runner/Info.plist` (`CFBundleDocumentTypes` + `UTExportedTypeDeclarations` for `com.fnm.fnmdb`, conforming to `public.data`, extension `fnmdb`), `ios/Runner/SceneDelegate.swift` (`scene(_:openURLContexts:)` and `connectionOptions.urlContexts`), `android/app/src/main/AndroidManifest.xml` (VIEW intent-filters for `content`/`file` schemes, `application/octet-stream` + `*/*` with `pathPattern .*\\.fnmdb`), `MainActivity.kt`.
- Create: `lib/features/world_pack/incoming_file.dart`
- Test: `test/unit/world_pack/incoming_file_test.dart` (channel mocked)

**Interfaces:**
- The native side copies the opened file into the app cache and calls `fnm/incoming_file` `opened(path)`. It also answers `initial()` with the path for a cold start.
- Needs `Routes.editorPack`, which Task 14 adds. Run Task 14 before Task 13, or add the route constant here first.
- Produces `final incomingFileProvider` and `IncomingFileListener` (a widget at the app root):
  - For a `.fnmdb`, it runs `WorldPackService.importFile` and navigates to `Routes.editorPack?id=` with a snackbar.
  - For a rejection, it shows the rejection text.

- [ ] **Step 1: Write the failing test**: `an opened path imports and navigates`, and `a rejected file shows the reason and stays put`.
- [ ] **Step 2: Run** it. Expected: FAIL.
- [ ] **Step 3: Implement** the native and Dart parts.
- [ ] **Step 4: Run** the test, then build both platforms: `flutter build apk --debug`, `flutter build ios --debug --no-codesign`. Expected: both build.
- [ ] **Step 5: Commit** `feat(world-pack): open fnmdb files from other apps`.

### Task 14: Editor list and database home

**Files:**
- Create: `lib/features/editor/editor_list_screen.dart` (+ `_tablet_layout`), `lib/features/editor/pack_home_screen.dart` (+ `_tablet_layout`), `lib/features/editor/editor_providers.dart`
- Modify: `home_screen.dart:151`, `home_tablet_layout.dart:93` (an Editor button under Campaigns), `app_router.dart` (`Routes.editor = '/editor'`, `Routes.editorPack = '/editor/pack'`, both in `fullScreen` and `tabletReadyPaths`), the sweep tests.
- Test: `test/widget/editor_list_test.dart`, `test/widget/pack_home_test.dart`

**Interfaces:**
- Produces:
  - `final packEditorProvider = StateNotifierProvider.family<PackEditor, AsyncValue<WorldPack>, int>`:
    - `update(WorldPack Function(WorldPack))` saves with a 400 ms debounce and flushes on dispose.
    - `undo()` keeps the last 20 states.
    - `issues` returns `PackRules.issues`.
  - **Editor list:**
    - Shows each pack with a status chip: Ready, N things missing, or Needs attention (Task 18).
    - Actions: New (name prompt, then `createFromDefault`), Import (`file_picker`), and per row Edit, Rename, Duplicate, Export (share), Delete (confirm).
  - **Pack home:**
    - Sections Players, Nations, Clubs, Stadiums, Competitions, Y accounts, Press, Name lists, Sponsors, Trophies. Each shows a count or a missing count.
    - A ready bar, and a missing list where each entry jumps to its target.

- [ ] **Step 1: Write the failing tests.**
  - `menu shows Editor and opens the list`.
  - `New makes a complete pack`.
  - `deleting asks first`.
  - `a pack with a 22-man nation shows '1 thing missing' and the jump opens that nation`.
  - `undo reverts the last edit`.
  - `tablet sizes render without overflow` (`kTabletSizes`).
- [ ] **Step 2: Run** them. Expected: FAIL.
- [ ] **Step 3: Implement.**
- [ ] **Step 4: Run** the tests plus both sweep tests. Expected: PASS.
- [ ] **Step 5: Commit** `feat(editor): editor list and database home`.

### Task 15: Players section

**Files:**
- Create: `lib/features/editor/players/nation_list_screen.dart`, `squad_screen.dart`, `player_edit_screen.dart` (each + `_tablet_layout`)
- Modify: `app_router.dart` (`Routes.editorNations`, `Routes.editorSquad`, `Routes.editorPlayer`)
- Test: `test/widget/editor_players_test.dart`

**Interfaces:**
- Consumes: `PlayerBuild` (Task 2), `ClubService.leagueClubs` (Task 7), `packEditorProvider` (Task 14).
- Screens:
  - **Nation list:** search, confederation filter chips, and a completeness mark per nation.
  - **Squad:** sorted by position. Add player creates a new id from `kPackPlayerIdBase + max`. Swipe to remove. A duplicate-name warning badge.
  - **Player edit:** name, age stepper, position picker, club search (the country's league clubs plus "Free agent"), an Overall slider with a big number, type chips (labels from ARB), and a Potential slider limited to ≥ overall. Changing overall or type rewrites the attributes via `PlayerBuild`.

- [ ] **Step 1: Write the failing tests.**
  - `edit name, overall 85, type Athlete: pack stores attributes whose forPosition is 85`.
  - `potential cannot go below overall`.
  - `add a goalkeeper fixes the missing-goalkeeper issue`.
  - `search finds a nation by its renamed name`.
  - `tablet layouts render`.
- [ ] **Step 2: Run** them. Expected: FAIL.
- [ ] **Step 3: Implement**, using lazy lists (`ListView.builder`) everywhere.
- [ ] **Step 4: Run** the tests plus the sweep tests. Expected: PASS.
- [ ] **Step 5: Commit** `feat(editor): players section`.

### Task 16: Name sections

**Files:**
- Create: `lib/features/editor/names/name_section_screen.dart` (+ `_tablet_layout`), a generic list of `(original, current)` rows with search, an inline edit sheet and "reset to original"
- Modify: `app_router.dart` (`Routes.editorNames?id=&section=`)
- Test: `test/widget/editor_names_test.dart`

**Interfaces:**
- `enum NameSection { nations, clubs, stadiums, competitions, yAccounts, press, nameLists, sponsors }`. For each section the plan fixes the source of the original rows and how an edit is written:
  - **Nations:** `newCareerWorld()`; name and code are edited together, the code checked with `PackRules.checkCode` and for duplicates.
  - **Clubs:** `ClubService.leagueClubs` for every country, grouped by country.
  - **Stadiums:** `nationalStadiumData`; the key is `'$nationId:$city'`.
  - **Competitions:** the canonical names from `ContinentalCups`, `NationsCups`, `'World Championship'`, `'Continental Clash'` and `'Intercontinental Play-off'`, shown through `competitionLabel` in the current language.
  - **Y accounts:** the fixed personas and the `YCast` name lists, exposed as `YFeed.namedAccounts` (a new static list).
  - **Press:** `Press.reporters` (newly public), name and outlet.
  - **Name lists:** per nation, a first-name list and a surname list, edited as a comma or newline separated text area, at least 20 each.
  - **Sponsors:** `SponsorBrand.values`, shown through `sponsorBrandName`.

- [ ] **Step 1: Write the failing tests.**
  - `rename a club and reset it`.
  - `renaming Czechia's code to an existing code is refused with a message`.
  - `competitions list shows Czech names in Czech`.
  - `name lists under 20 entries show as missing`.
  - `tablet layouts render`.
- [ ] **Step 2: Run** them. Expected: FAIL.
- [ ] **Step 3: Implement.**
- [ ] **Step 4: Run** the tests plus the sweep tests. Expected: PASS.
- [ ] **Step 5: Commit** `feat(editor): name sections`.

### Task 17: Trophies section

**Files:**
- Create: `lib/features/editor/trophy_section_screen.dart` (+ `_tablet_layout`)
- Modify: `app_router.dart` (`Routes.editorTrophies`)
- Test: `test/widget/editor_trophies_test.dart`

**Interfaces:**
- A grid of the 9 trophies, showing the custom picture or the default.
- Tapping one opens `file_picker` (images). A crop frame with the trophy's aspect (pan and pinch) then calls `TrophyNormaliser.normalise` and `setTrophy`.
- If `hasAlpha` is false, a warning line is shown.
- A preview in a mock champion banner, plus a "Back to default" action.

- [ ] **Step 1: Write the failing tests.**
  - `picking a PNG stores a 400×600 trophy and the grid shows it`.
  - `an opaque picture shows the rectangle warning`.
  - `back to default removes it`.
  - `tablet layouts render`.
- [ ] **Step 2: Run** them. Expected: FAIL.
- [ ] **Step 3: Implement.**
- [ ] **Step 4: Run** the tests. Expected: PASS.
- [ ] **Step 5: Commit** `feat(editor): trophies section`.

### Task 18: New Game world choice, save cards, compatibility

**Files:**
- Modify: `settings_screen.dart` + `settings_tablet_layout.dart` + `settings_providers.dart` (default world), `nation_select_screen.dart` (+ tablet), `new_game_screen.dart:45`, `unemployed_start_screen.dart`, `saves_screen.dart:546`, `saves_tablet_layout.dart:193`, `home_screen.dart:214` (`_ContinueCard`), `pack_rules.dart` (`compatibility`)
- Test: `test/widget/new_game_world_test.dart`, `test/unit/world_pack/pack_compat_test.dart`

**Interfaces:**
- **World choice:**
  - `final newGameWorldProvider = StateProvider<int?>` holds a pack id; null means Default.
  - The nation picker header shows a "World: Default ▾" chip. Its sheet lists Default plus every pack that is complete and compatible. Others are greyed out with the reason.
  - The choice flows into `CareerService.create(worldPackId:)` from `_start`, Random, and From the bottom.
- **Compatibility:**
  - `PackRules.compatibility(WorldPack p, {required Set<int> nationIds, required Set<String> competitionNames, required Set<String> trophyKeys, required Set<String> sponsorBrands}) -> List<PackIssue>` returns an `UnknownId` for every key the current game no longer has.
  - An incompatible pack shows "Needs attention" in the editor list and on the pack home, with each unknown entry listed and a "Remove" fix.
- **Save cards:** the `SaveTile`, tablet save pane and continue card show the world name (`CareerWorlds.packName`) under the nation when the career has one.
- **Default world in Settings (owner request, 2026-11-05):**
  - Settings gets a "Default world" row (phone and tablet). It opens the same sheet as the New Game chip: Default plus every complete, compatible pack.
  - The choice persists in SharedPreferences (`settings_providers.dart`), stored as the pack's uuid so it survives an id change. Null means Default.
  - `newGameWorldProvider` starts from this setting. If the stored pack is gone, incomplete or incompatible, New Game starts on Default and the Settings row shows Default. The stored value is cleared when that pack is deleted.
  - Changing the chip in New Game affects that one career only. It does not change the Settings default.

- [ ] **Step 1: Write the failing tests.**
  - `choosing a pack starts a career on it; the squad screen shows the pack names`.
  - `an incomplete pack is greyed out with its reason`.
  - `a pack naming nation 999 is incompatible, cannot be chosen, and Remove fixes it` (Review Focus 4).
  - `save card shows the world name`.
  - `default stays the default choice after the app restarts`.
  - `a default world set in Settings is preselected in New Game after a restart; deleting that pack falls back to Default`.
  - `the Settings default-world row lists only complete, compatible packs`.
- [ ] **Step 2: Run** them. Expected: FAIL.
- [ ] **Step 3: Implement.**
- [ ] **Step 4: Run** the tests plus `test/widget/*nation_select*`, `*new_game*`, `*save*`. Expected: PASS.
- [ ] **Step 5: Commit** `feat(world-pack): choose a world in New Game; save cards name it`.

### Task 19: Copy in 28 languages

**Files:**
- Modify: `lib/l10n/app_*.arb` via `copy/strings.csv`
- Test: the existing guards in `test/unit/l10n/`, plus a new `test/unit/l10n/editor_copy_test.dart`

- [ ] **Step 1: Write the failing test.** `every editor key exists in all 28 languages and none is the English text outside en`. Allow-list the keys whose English is a proper noun.
- [ ] **Step 2: Run** it. Expected: FAIL for the keys Tasks 14–18 added in English only.
- [ ] **Step 3: Implement.** Export the CSV, translate every new key in all 28 columns, import, then run `flutter gen-l10n`. The player type labels need short forms that fit the chips (test at 390 px in de, fi, hu).
- [ ] **Step 4: Run** `test/unit/l10n/` and the editor widget tests in `cs` and `de`. Expected: PASS.
- [ ] **Step 5: Commit** `feat(editor): editor copy in all languages`.

### Task 20: End-to-end story and full suite

**Files:**
- Create: `test/story/world_pack_story_test.dart`

- [ ] **Step 1: Write the story.** Create a pack from default. Rename Czechia's 23 players, set Kadlec to overall 88, potential 92, type Playmaker. Rename the European Championship and set a custom trophy. Export the pack, import it as a copy, and start a career on the copy. Drive with `StoryDriver` to the end of the first continental finals.
  Assert:
  - names and ratings are as edited at the first call-up;
  - the renamed cup and the custom trophy appear on the cup screen;
  - deleting both packs mid-run changes nothing;
  - a default career run alongside on the same seed matches its pre-feature golden.
- [ ] **Step 2: Run** it. Expected: PASS.
- [ ] **Step 3: Run the full suite** with `caffeinate -dimsu flutter test`. Expected: all green. A failure that comes from sleep or a timeout is rerun file by file, never assumed.
- [ ] **Step 4: Commit** `test(world-pack): end-to-end story`.
