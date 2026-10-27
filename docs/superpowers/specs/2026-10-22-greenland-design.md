# Campaign: Greenland (Pro, two cycles, can continue)

Date: 2026-10-22 · Status: design, not built · Base commit: 2cc8645

## What the owner asked

"Add Greenland campaign (not free but you can continue). New nation, lowest ranking, Greenland country and nationality. Replaces worst european team."

Greenland is a **real new nation**: its own id, its own code, its own players (`player.nationId == 212`). It is not San Marino with a Greenland skin.

- New nation **Greenland**, id **212** (next free id; 6 and 44 are retired ids that old saves may still reference, so they are not reused). Code `GRL`, confederation `europe`, seed ranking **210** (last in the world; today's last is American Samoa at 209), colours `#C8102E` / `#FFFFFF`, `isFreeDemo: false`.
- **Dormant**: Greenland exists only in a career whose world includes it. Every other career, and every screen outside a career (new-game picker, random and from-the-bottom starts, unemployed start, saves list counts), sees exactly today's 209 nations.
- In a Greenland world, Greenland takes the place of the worst European nation by seed ranking, **San Marino (id 45, ranking 203)**. San Marino does not exist in that world: no draws, qualifying, Nations Cup ladder, rankings, friendlies, hosts, news or records. Team counts stay the same, so every format, pot and slot is unchanged.
- Campaign: Pro (`needsPro: true`), `canContinue: true`, two cycles, so the board cannot sack (`campaignBarsSacking` already shields any active campaign with `cycles > 1`).

## Hard constraints

1. **Normal careers are byte-for-byte unchanged**: same nation list, same order, same draws, same seeds. Guaranteed by construction (below) and pinned by tests.
2. **No drift schema change.** Greenland reaches existing databases through the seed loader on launch (insert-if-missing). The world variant is a per-career marker in `draws_watched` (cycle 0), like `goldenGeneration:17`.
3. Existing saves keep working; a whole-DB backup or a bundle from an older build gains Greenland on the next launch.
4. Copy: no em dashes, never "World Cup" (use "World Championship"), all 22 languages plus Hindi `hi` if it has landed by then.

---

## 1. How nations reach the app today (findings)

- `assets/data/nations.json` (209 rows, max id 211) and `assets/data/players.json` (23 per nation) are read by `AssetSeedSource` (`lib/data/seed/seed_source.dart`). `PoolGenerator.expand` (`lib/data/seed/pool_generator.dart`) pads each nation with 80 fringe players whose ids run **sequentially from 10 000 000 across nations in file order**.
- `SeedLoader.ensureSeeded` (`lib/data/seed/seed_loader.dart`) inserts the seed **only into an empty DB**. On an existing DB it runs `_reconcileNations` (deletes any nation not in the source, with its players) and `_ensureDeepPool` (pre-v10 saves: delete all players, reinsert the source). **Nothing adds a new nation to an existing DB**, and `_reconcileNations` would delete one that is not in `nations.json`.
- `DriftNationRepository` (`lib/data/repositories/drift_nation_repository.dart`): `all()` (every row, ordered by ranking), `freeDemo()`, `byId()`. It is exposed as `nationRepositoryProvider` (`lib/data/data_providers.dart`). There is no career scoping anywhere.
- Players are stored rows (base plus fringe). Names are reassigned per save by `DriftPlayerRepository._namerFor` from `assets/data/country_names.json` (classic pools) or `+ country_names_more.json` (richer pools, every career since `namePoolsV2Kind`), keyed by nation id. Clubs come from `ClubService.clubForSeed` with the home code (raw `_db.nations` read in `_home`) and `country_cities.json`.
- The world is generated from a `List<Nation>`: `CareerService.create` calls `nationRepositoryProvider.all()` and passes it to `CareerService.buildCalendar`, `NationsCup.seedTiers`, `FederationFinance.initialBudget` and `_seedHistory`. Rollover and the in-cycle draws use `SeasonService._nationsById()` (`lib/features/hub/hub_providers.dart:423`, a part-file shared by `season_cycle.dart`, `season_finals.dart`, `season_rollover.dart`), plus direct `all()` calls at `season_cycle.dart:1204` and `season_rollover.dart:141`.
- Hosts (`WorldCupHosts.hostsFor`, `continentalHostsFor`, `continentalQualifiers`) are **recomputed from the nation list on read** by display providers (`match_providers.dart:631`, `cup_detail_providers.dart:217`, `wc_host_theme.dart`, `host_draw_providers.dart`), and the draw ceremonies recompute pots from it. So every reader in a career must see **the same list the world was generated from**, or a Greenland career would show San Marino as a host or in a pot.
- Ranking: `worldRankingProvider` seeds Elo with `Elo.seedFromRanking(n.ranking)` for each nation in the list, sorts by points, then by `ranking`. `seedFromRanking(210)` extrapolates below 209, so Greenland starts last with no code change.
- Career bundles (`lib/data/db/career_bundle.dart`) never export `nations`/`players` (`seedTables`) and never remap nation or player ids; `draws_watched` markers travel with the career.
- About 60 call sites read `nationRepositoryProvider).all()` (list in section 4). Most only build an `id -> Nation` lookup; some enumerate the world (friendly opponents, rankings, draws, hosts, offers).

## 2. Design

### 2.1 Dormant nation data (no change to nations.json or players.json)

Greenland is **not** added to `nations.json` or `players.json`. Nearly 100 tests build their world from `nations.json`, and some pass it straight into domain services. Keeping the file untouched keeps every one of those worlds identical.

New file `lib/domain/services/nation/dormant_nations.dart`:

```dart
abstract final class DormantNations {
  static const int greenlandId = 212;
  static const Nation greenland = Nation(
    id: 212, name: 'Greenland', code: 'GRL',
    confederation: Confederation.europe, ranking: 210,
    primaryColor: '#C8102E', secondaryColor: '#FFFFFF',
  );
  static const List<Nation> all = [greenland];
  static const Set<int> ids = {greenlandId};
  /// The nation each dormant nation stands in for when its world is active.
  static const Map<int, int> replaces = {greenlandId: 45}; // San Marino
  /// The draws_watched kind (cycle 0) that makes [nationId] part of a career's world.
  static String markerFor(int nationId) => 'dormantNation:$nationId';
}
```

New file `lib/data/seed/dormant_seed.dart`:
- `const List<Player> greenlandSquad`: 23 literal base players, ids **21201 to 21223** (the `nationId * 100 + n` pattern; nothing uses 212xx today). Positions are San Marino's 23 positions (copy the list). Attributes are San Marino's per-slot attributes x 0.94, rounded, clamped to at least 25. That gives a base mean overall of about 36.4 (San Marino 38.7, Gibraltar 42.7, American Samoa 36.8): the weakest side in Europe, a little below San Marino. Ages 18 to 34. Names come from the Greenland pool (2.3) and must pass the guard. Write the list out as literals (generate it once with a throwaway script), so the data can be reviewed.
- `List<Player> greenlandPool()` returns `greenlandSquad` plus `PoolGenerator.fringeFor(nationId: 212, squad: greenlandSquad, firstId: 20212000, names: <Greenland pool>)`. That makes fringe ids **20 212 000 to 20 212 079**: clear of the seeded fringe (10 000 000 up to about 10 017 000), staff (900M+), golden cohorts (950M+) and newgens (1e9+). The fixed range matters: if the ids were computed off the end of the shared sequence, they could collide with a surviving nation's fringe in an old DB that had nations pruned.

`PoolGenerator` refactor (behaviour-neutral): move the body of `expand`'s per-nation fringe loop into `static List<Player> fringeFor({required int nationId, required List<Player> squad, required int firstId, ({List<String> first, List<String> sur})? names})`. `expand` calls it with `firstId: nextId` and then adds `extraPerNation` to `nextId`. Its RNG (`SeededRng((nationId * 0x9E3779B1) ^ 0xF00DBEEF)`), its order and `_club(id)` stay identical. A test pins `expand(players.json)` output to a hash taken before the change.

### 2.2 Getting the row into every DB (no schema bump)

`SeedSource` gains `Future<({List<Nation> nations, List<Player> players})> dormant();`
- `AssetSeedSource.dormant()` returns `(nations: DormantNations.all, players: greenlandPool())`.
- `InMemorySeedSource` gets the constructor parameter `this.dormantNations = const [], this.dormantPlayers = const []`. **Default empty**, so every existing test DB is unchanged. Greenland tests pass `DormantNations.all` and `greenlandPool()`.

`SeedLoader.ensureSeeded` changes:
1. Fresh DB: after the main batch, call `_ensureDormant()`.
2. Existing DB: `_reconcileNations()`, then `_ensureDeepPool()`, then **`_ensureDormant()` last**. The order matters: the deep-pool rebuild deletes every player and would take Greenland's with it.
3. `_reconcileNations`: `keep = source ids ∪ DormantNations.ids ∪ dormant().nations ids`. Never prune a dormant nation, even when a source fails to supply it.
4. `_ensureDormant()`: for each dormant nation, `insertOrIgnore` the nation row (same `_nationCompanion`). Then, if `count(players where nationId = id) == 0`, `insertOrIgnore` its players. It is idempotent, and safe under the documented concurrent-seeder race.
5. `_ensureDeepPool` needs no change. With Greenland's 103 rows present, `nationCount * 103` and `have` both rise by 103.

This runs on every launch through `databaseReadyProvider` / `seedLoaderProvider`, so an upgraded install, a restored older backup and a fresh install all hold Greenland before any career reads. No migration and no `schemaVersion` bump are needed.

### 2.3 Names, guard, display tables

- `assets/data/country_names.json` key `"212"`: `first` (about 50 names) and `sur` (about 50 names). `assets/data/country_names_more.json` key `"212"`: `firstMore`, `surMore` (about 30 each). Adding keys does not touch any other nation's pool.
  - First names (Kalaallisut plus the Danish names common in Greenland): Nuka, Malik, Aputsiaq, Inunnguaq, Minik, Kunuk, Pavia, Aqqaluk, Kaali, Angunnguaq, Inuk, Hansi, Enok, Efraim, Abel, Isak, Jakob, Tobias, Ole, Hans, Jens, Lars, Niels, Peter, Karl, Frederik, Kristian, Nikolaj, Mikael, Rasmus, Emil, Magnus, Anders, Kasper, Ulrik, Otto, Jonas, Mads, Simon, Thomas. Check each Kalaallisut name is male before committing.
  - Surnames: Kleist, Lynge, Motzfeldt, Berthelsen, Heilmann, Rosing, Olsen, Petersen, Kristiansen, Frederiksen, Kreutzmann, Egede, Josefsen, Lennert, Larsen, Nielsen, Jensen, Hansen, Davidsen, Mathaeussen, Poulsen, Korneliussen, Brandt, Høegh, Geisler, Chemnitz, Fleischer, Lyberth, Abelsen, Enoksen, Johansen, Sandgreen, Isaksen, Jakobsen, Karlsen, Danielsen, Thomsen, Sørensen.
- `lib/data/seed/real_internationals.dart`: add `const Set<String> realGreenlandInternationals`. Seed it with the men's team as listed on Wikipedia (captain **Patrick Frederiksen**, **Rene Eriksen Petersen**, **Niklas Thorleifsen**, **Nick Reimer**, coach **Morten Rutkjær**), **Jesper Grønkjær** (born in Nuuk, Denmark international), and famous Greenlanders the pools could produce: Kuupik Kleist, Jonathan Motzfeldt, Hans Enoksen, Kim Kielsen, Múte Egede, Jens-Frederik Nielsen, Lars-Emil Johansen, Aqqaluk Lynge, Hans Lynge. **The implementer completes the list** from the Wikipedia squads (2023 futsal call-ups, the 2026 CONIFA European Football Cup squad) and Greenlandic sources (KAK, Sermitsiaq). Add `const Map<int, Set<String>> guardedNamesByNation = {212: realGreenlandInternationals};`.
- `DriftPlayerRepository._namerFor`: apply the guard only for nations in `guardedNamesByNation` **that are dormant**, so Finland's ordinary namer, and every name in existing saves, stays as it is. For such a nation, build once per `(nation, save, rich)` an `allowed` index list, `[for k in 0..length) if (!guard.contains(nameAt(k))) k]`, then `nameAt'(i) = nameAt(allowed[i % allowed.length])`. Names stay distinct and only Greenland pays for the scan (about 2.5k classic, about 6k rich combinations).
- `assets/data/country_cities.json` key `"212"`: Nuuk, Sisimiut, Ilulissat, Qaqortoq, Aasiaat, Maniitsoq, Tasiilaq, Paamiut, Narsaq, Nanortalik, Uummannaq, Upernavik.
- Nation names by code `GRL`:
  - English (seed name): Greenland.
  - `nation_names.dart`: `csByCode` Grónsko, `csDativeByCode` Grónsku.
  - Per-language tables `nation_names_<lang>.dart`: de Grönland · es Groenlandia · fr Groenland · it Groenlandia · pl Grenlandia · pt Groenlândia · tr Grönland · nl Groenland · id Greenland · el Γροιλανδία · sv Grönland · nb Grønland · vi Greenland · bg Гренландия · da Grønland · fi Grönlanti · hu Grönland · hr Grenland · uk Гренландія · fil Greenland · hi ग्रीनलैंड.
- `nation_geography.dart`: `'GRL': 'scandinavia'`, so a co-host is a realm neighbour (Iceland, Faroes, Denmark).
- `nation_identity.dart`: `'GRL': (nickname: null, style: NationStyle.direct, pedigree: 5)`.
- `lib/domain/services/competition/stadium_capacity.dart`: `212: 2000`. Nuuk Stadium; the exact figure is the implementer's to check.
- Flag `assets/flags/grl.svg` (asset folder already listed in pubspec): `viewBox="0 0 18 12"`, top half white, bottom half `#C8102E`, a disc centred at (7, 6) with r = 4 whose upper half is red and lower half white. Add `GRL` to `tool/download_flags.py` if that tool lists codes.

### 2.4 The choke point: a career-aware nation set on `NationRepository`

```dart
abstract interface class NationRepository {
  /// The BASE world: every nation except the dormant ones, ordered by ranking.
  /// Identical to today's all() (no dormant row is in it), so every global
  /// screen and every normal career is unchanged by construction.
  Future<List<Nation>> all();
  Future<List<Nation>> freeDemo();               // unchanged (also excludes dormant)
  Future<Nation?> byId(int id);                  // unchanged: finds Greenland too
  /// Every stored row, dormant ones included. A DICTIONARY for lookups that
  /// are not tied to one career (the saves list). Never enumerate it as a world.
  Future<List<Nation>> everyKnown();
  /// The world of [careerId]: all(), or, for a career carrying
  /// DormantNations.markerFor(d), all() minus replaces[d] plus d, re-sorted
  /// by ranking. For a normal career it returns exactly all().
  Future<List<Nation>> forCareer(int careerId);
}
```

`DriftNationRepository.forCareer` reads `draws_watched` for `careerId`, cycle 0, `kind LIKE 'dormantNation:%'`, with one small query. Following `DriftPlayerRepository._richCareers`, only a "yes" is cached (`Map<int, Set<int>>`): career ids are never reused and the marker is never removed. A "no" is asked again each time, which is one indexed query.

New providers in `lib/features/nations/nation_select_providers.dart`, or a new `lib/features/nations/career_nations_providers.dart`:
- `careerNationsProvider`: `FutureProvider.autoDispose.family<List<Nation>, int>` returning `forCareer(careerId)`.
- `careerNationsByIdProvider`: the same, as a `Map<int, Nation>`.
- `knownNationsByIdProvider`: `FutureProvider<Map<int, Nation>>` over `everyKnown()`.
- `nationsProvider` stays as it is (the base world for the global pickers).

**The rule for every call site.** If it has a `careerId` (or a `Career`) in scope, it uses `forCareer(careerId)`, whether it enumerates or only looks up. If it has no career and only looks up, it uses `everyKnown()`. If it has no career and enumerates, it uses `all()`. For a normal career, `forCareer == all()`, so migrating a call site cannot change a normal career.

### 2.5 Creating the Greenland world

- `CampaignDef` gains `final int? dormantNationId;` (default null). The campaign's `nationId` is 212.
- `CareerService.create` gains `List<String> worldMarkers = const []`. Right after `repo.create(...)`, before `namePoolsV2Kind` and before **anything** reads nations or players, it writes each marker with `comp.markDrawWatched(career.id, 0, marker)`. Then it replaces `nationRepositoryProvider.all()` with `.forCareer(career.id)` (line 202). The same change goes into `_seedHistory` (line 635). `buildCalendar`'s `nations.any((n) => n.id == nationId)` check now passes for 212.
- `CampaignService.start` passes `worldMarkers: [if (def.dormantNationId case final d?) DormantNations.markerFor(d)]` to `create`. It must not write the marker afterwards the way `goldenGeneration` does: the calendar is drawn **inside** `create`.
- `SeasonService._nationsById()` becomes `_nationsById(int careerId)` and reads `forCareer(careerId)`. Update its 16 callers (hub_providers 636, 859, 1592, 1682, 2323; season_cycle 150, 384, 808, 948, 1042, 1133; season_finals 33, 209; season_rollover 200, 513). Each already has a `careerId` or `career` in scope. Make it explicit and do **not** rely on `_simCareer`: it is a field that can go stale between operations. `season_cycle.dart:1204` (`_simulateContinentalCups`) and `season_rollover.dart:141` switch to `forCareer(careerId)`.
- A moved run keeps its marker, so it stays a Greenland world for life, including after a job change. That is intended.

### 2.6 Ranking

No code change. In a Greenland world the list holds Greenland at `ranking: 210`. Elo seeds it with `seedFromRanking(210)`, the lowest value, and the tie-break by `ranking` keeps it last. The cycle-0 seeding snapshot (`seedRankByIdProvider` fallback, `world_ranking_providers.dart:91`) and the movement baseline (251) must use `forCareer`, which the migration below covers. Board budget: `FederationFinance.initialBudget(210)`.

## 3. Campaign definition

```dart
/// Greenland, a nation the world does not have, takes San Marino's place in
/// Europe for two cycles, from the very bottom of the world ranking. Pro, and
/// a settled run may be moved into the saves (the world is a fair one: one
/// minnow swapped for a weaker one). Seed: see "Seed" below.
static const greenland = CampaignDef(
  id: 'greenland',
  nationId: 212,                       // DormantNations.greenlandId
  dormantNationId: 212,
  goal: CampaignGoal.climbFromBottom,
  friendlyNationId: 16,                // Faroe Islands: opening home friendly, flavour
  canContinue: true,
  cycles: 2,
  needsPro: true,
  difficulty: CampaignDifficulty.hard,
  rngSeed: <found by search, see below>,
);
```

Add it to `Campaigns.all` after `youngFinns`. The Faroes friendly is optional flavour (a realm neighbour) and the owner's call.

### Goal: new `CampaignGoal.climbFromBottom`

None of the existing goal types fits. `qualifyContinental` grades the finals ordinal only, which would leave a bottom-of-Europe side with 0 stars nearly every time. A new goal and a pure grader:

- **★ Win a competitive match:** any fixture with `round != 'FRIENDLY'` (continental qualifying `CQ`, World Championship qualifying `round == null`, Nations Cup, play-offs, finals), won on the score or on penalties (`campaignNationWon`), in either cycle. A tiny nation in the bottom Nations Cup league and two qualifying groups gets maybe a dozen and a half chances per cycle. Hard but reachable.
- **★★ Finish off the bottom of a qualifying group:** in any fully played continental (`CQ`) or World Championship (`round == null`, `groupId != null`) qualifying group, in either cycle, Greenland finishes strictly above at least one other member on points, then goal difference, then goals for. An exact three-way tie with the last side does not count. That is deliberately conservative so it never disagrees with the stored table's finer tiebreaks. Nations Cup groups do not count: league D is too easy and is not "qualifying".
- **★★★ Qualify for a European Championship:** continental `ordinal >= 2` in either cycle (the `cycleRuns` already computed).
- **Grade = highest tier reached** (same rule as `worldThenTitlesStars`). The tiers are separate goals, and ★★★ practically implies ★.

`lib/domain/services/campaign/campaign_grading.dart`:
```dart
int climbFromBottomStars({required bool wonCompetitive, required bool offBottom,
    required bool qualifiedContinental}) =>
    qualifiedContinental ? 3 : offBottom ? 2 : wonCompetitive ? 1 : 0;

/// Whether [nationId] finished strictly above at least one other side of a
/// fully played group, on (points, goal difference, goals for). [groupFixtures]
/// are every fixture between the group's members.
bool finishedOffBottom(List<Fixture> groupFixtures, int nationId);
```

`campaign_providers.dart`, `campaignProgressProvider`:
- Add `int competitiveWins` and `bool offBottom` to `CampaignProgress`, and update every record literal (the provider, plus any test that builds one).
- For `climbFromBottom`: `span = campaignSpanFixtures(...)` gives `competitiveWins = span.where(round != 'FRIENDLY' && campaignNationWon)`. For `offBottom`, group the span's qualifying fixtures by `groupId`. For each group, members = Greenland plus its opponents in that group. Read each member's `fixturesForNation` cut to the same date span and keep fixtures with the same `groupId`. A group counts when every fixture has a result and `finishedOffBottom` holds.
- `reached = climbFromBottomStars(wonCompetitive: competitiveWins > 0, offBottom: offBottom, qualifiedContinental: cycleRuns.any((r) => r.ordinal >= 2))`.
- `settled = reached == 3`. Otherwise the existing end-of-last-cycle rule settles it (`worldChampion != null && cyclePointer >= cycles - 1`). No sacking is possible (`cycles > 1`).

UI:
- `campaign_hub_card.dart:120`: add `climbFromBottom` to `perCycle` (lists each cycle's European Championship through `_cupTexts`). Add one line `campaignProgressCompetitiveWins` while `reached == 0`.
- `campaign_verdict_screen.dart`, `campaignRunCounts`: for `climbFromBottom`, return `round != 'FRIENDLY'` (every competitive match is the run).
- `campaign_ui.dart`, `campaignWords`: add a `'greenland'` arm.
- Brief and campaigns screens read the nation through `nationByIdProvider(212)`. `byId` finds the dormant row, so the flag and name show.

### Seed

Search from **212 upward** and take the first seed that, in the **Greenland world list** (`forCareer` shape: base minus 45 plus 212):
1. never makes Greenland a host or co-host of the European Championship or the World Championship in cycles 0 and 1 (`WorldCupHosts.continentalHostsFor`, `hostsFor`, as `campaign_seeds_test.dart` does for the others);
2. puts Greenland in a European qualifying group of 5 or more in cycle 0 (`euroQualifyingGroups`), so ★★ has a real table.

Pin it in `campaign_seeds_test.dart`. Calibrate on `test/story/campaign_lab_test.dart` (autopilot, about 200 runs). "Hard" target: ★ in roughly half the runs, ★★ in about one run in five, ★★★ rare (under 3%). If the rates are off, tune Greenland's attribute factor (0.94) rather than the goal, and report the rates to the owner.

### Copy (copy/strings.csv, then ARB through `tool/import_copy.dart`; all languages)

| key | English |
|---|---|
| `campaignGreenlandTitle` | Greenland |
| `campaignGreenlandTwist` | Greenland take San Marino's place in Europe, for two cycles |
| `campaignGreenlandGoal` | Win a competitive match |
| `campaignGreenlandIntro` | Greenland have never played a competitive international. In this world they have taken San Marino's place in Europe, and they start at the very bottom of the world ranking: amateur players, artificial pitches and a season squeezed between the snows. You have two cycles to win a competitive match, climb off the bottom of a qualifying group and, if you dare to dream, reach the European Championship. The Faroe Islands are already booked for a friendly. |
| `campaignStars1Greenland` | Win a competitive match |
| `campaignStars2Greenland` | Finish off the bottom of a qualifying group |
| `campaignStars3Greenland` | Qualify for a European Championship |
| `campaignProgressCompetitiveWins` | Competitive wins: {count} (placeholder `count`, int) |

Drop the last sentence of the intro if the Faroes friendly is dropped. Czech: Grónsko, and "proti Grónsku" wherever a dative is used.

## 4. Call-site migration (grep at 2cc8645; the guard test catches new ones)

**Switch to `forCareer(careerId)` / `careerNationsProvider`** (career in scope):
- career: `career_providers.dart:202` (create), `:635` (`_seedHistory`); `manager_history_providers.dart:147`; `career_summary_providers.dart:148` (if it serves the saves list without a single career, use `everyKnown`)
- ranking: `world_ranking_providers.dart:91, 251, 262`
- records: `record_book_providers.dart:75`, `all_time_records_providers.dart:49`, `legends_providers.dart:29`, `rivalry_providers.dart:50`, `head_to_head_providers.dart:92`
- achievements: `achievement_providers.dart:160, 374`, `challenge_providers.dart:115`
- match: `match_providers.dart:400, 631` (hosts)
- messages: `message_providers.dart:86, 1124`
- squad/federation: `training_camp_providers.dart:100`, `staff_providers.dart:26`, `federation_service.dart:64`, `naturalization_providers.dart:79`
- misc: `award_providers.dart:162`, `press_providers.dart:145`, `stats_providers.dart:264`, `y_providers.dart:49, 95`, `nomination_providers.dart:58`, `results_providers.dart:99`, `round_results_screen.dart:51`, `player_detail_screen.dart:101`
- friendlies (**enumerate opponents, critical**): `friendlies_providers.dart:92`, `other_friendlies_providers.dart:41`
- campaign: `campaign_providers.dart:576`
- hub: `hub_providers.dart:193`, `:423` (`_nationsById`, see 2.5), `objective_providers.dart:249`, `cycle_rollover_screen.dart:55`, `season_cycle.dart:1204`, `season_rollover.dart:141`
- tournaments (**hosts and pots recomputed, critical**): `qualifying_draw_providers.dart:59`, `nations_cup_draw_providers.dart:54`, `cup_detail_providers.dart:217`, `tournaments_providers.dart:109`, `wc_host_theme.dart:90, 138`, `continental_clash_providers.dart:34`, `nations_cup_providers.dart:59`, `continental_detail_providers.dart:174, 310, 392` (the `firstWhere` there would **throw** for 212 under `all()`), `intercontinental_playoff_providers.dart:36`, `tournament_kickoff_screen.dart:47`, `finals_draw_providers.dart:63`, `host_draw_providers.dart:56`

**`nationsProvider` consumers:**
- `saves_screen.dart:112`: use `knownNationsByIdProvider`, or a Greenland save row has no name or flag.
- `head_to_head_screen.dart:41`, `h2h_meetings_screen.dart:109`: use `careerNationsProvider(careerId)` (the picker must offer Greenland, not San Marino).
- `nation_preview.dart:89`: in out-of-work offers inside a career, use `careerNationsProvider`; in new game, keep it.
- Keep: `nation_select_screen.dart`, `nation_select_tablet_layout.dart`, `unemployed_start_screen.dart` (global).

**Unchanged:** `nation_select_providers.dart:11, 53` (`nationsProvider`, `nationStrengthsProvider`; global, base world). Every `byId` and `nationByIdProvider` caller. `starPlayersProvider` (gains a 212 key that nothing enumerates). `DriftPlayerRepository._home` and `DriftCompetitionRepository` raw nation reads (lookups by id or name).

## 5. Risks

1. **Leakage of the base list into a Greenland career.** Any reader still on `all()` shows San Marino (a phantom host, a pot member, a friendly offer) or loses Greenland (`firstWhere` throws, a "A nation" label). Mitigation: the rule in 2.4, the full list in section 4, and a **static guard test** that fails on any `nationRepositoryProvider).all()` or `ref.watch(nationsProvider)` outside an allowlist (`nation_select_providers.dart`, `nation_select_screen.dart`, `nation_select_tablet_layout.dart`, `unemployed_start_screen.dart`, `nation_preview.dart` when it has no career).
2. **Seeding order and pruning.** If `_ensureDormant` runs before `_ensureDeepPool`, or `_reconcileNations` does not keep dormant ids, Greenland (and with it every Greenland career) vanishes on some launch. Pinned by seed-loader tests.
3. Bundle import into an **older** build (1.0.6) that lacks nation 212 would accept a Greenland career and break. No schema bump means the old build cannot refuse it. This is accepted: it needs a cross-version share of a Pro campaign run. A newer build always has the row.
4. The marker must land before the calendar. If `CampaignService.start` writes it after `create` (the golden-generation pattern), the world is drawn with San Marino. Covered by the campaign test.
5. Namer guard scope: the guard applies only to dormant nations. Widening it to Finland would rename players in existing Finnish saves.
6. Performance: `forCareer` adds one indexed query per call for normal careers. A hot loop (the world sim) uses `_nationsById(careerId)` once per operation, as today.

## 6. Test plan

New files under `test/unit/greenland/`:
- `dormant_seed_test.dart`:
  - The fresh-DB seed inserts 212 plus its 103 players when the source supplies them.
  - On an existing DB (seeded without dormant), the next `ensureSeeded` adds them; a second call is a no-op.
  - `_reconcileNations` keeps 212 even with an empty dormant source.
  - A forced deep-pool rebuild still ends with Greenland's players.
  - `PoolGenerator.expand(players.json)` is byte-identical to the pre-refactor snapshot (hash).
  - Greenland ids sit in 21201 to 21223 and 20212000 to 20212079; the base mean overall is below every other European nation's.
- `dormant_names_test.dart`:
  - No stored Greenland name, and no namer output for seeds 1 to 50 (classic and rich pools, first 300 indices), is in `realGreenlandInternationals`; names are distinct.
  - `GRL` exists in every language table, in `csDativeByCode`, in geography, in `stadium_capacity`, in `country_cities.json`, in both name files, and in `assets/flags/grl.svg`. Extend `nation_names_complete_test.dart` and `nation_dative_test.dart` to iterate `DormantNations.all` too.
- `normal_career_unchanged_test.dart` (**the guard**):
  - With the dormant data seeded, `all()` has no 212 and equals the `nations.json` list (ids and order).
  - For a normal career (seed 1 and seed 10), `forCareer(id)` deep-equals `all()`.
  - The career's stored cycle-0 European qualifying groups, Nations Cup tiers and both cycles' hosts equal those computed from `nations.json` alone.
  - No fixture, ranking row or message of that career references 212.
  - The existing `campaign_seeds_test.dart` pins for transplant, grudge, guineas and youngFinns must stay green untouched.
- `greenland_world_test.dart`:
  - Start the campaign (premium on). `forCareer` holds 212 and not 45, and has the same length as `all()`.
  - No fixture (cycle 0, and cycle 1 after a forced rollover), Nations Cup tier entry, seed-ranking snapshot, ranking row, honour or message references 45.
  - Greenland sits in a European qualifying group, in the Nations Cup bottom league, and is last in `worldRankingProvider` on day one.
  - The Europe member count equals the base's.
  - The default XI is Greenland's own players (`nationId == 212`).
  - After a career bundle round-trip, the marker survives and the world is still Greenland's.
  - After `moveToSaves`, the saves list shows Greenland's name and flag.
- `dormant_nation_guard_test.dart`: the static scan of risk 1.
- `campaign_grading_test.dart`: `climbFromBottomStars` truth table. `finishedOffBottom` on a played-out group, an unfinished group and the exact-tie case.
- `campaign_seeds_test.dart`: the Greenland seed delivers both conditions in "Seed".
- Lab: add Greenland to `campaign_lab_test.dart` and report the star rates.

## 7. Tasks, in order

1. **PoolGenerator refactor:** add `fringeFor`; `expand` calls it; hash test. Files: `lib/data/seed/pool_generator.dart`, `test/unit/greenland/dormant_seed_test.dart` (hash case).
2. **Dormant data:** add `DormantNations`, `greenlandSquad`, `greenlandPool()`. Files: `lib/domain/services/nation/dormant_nations.dart`, `lib/data/seed/dormant_seed.dart`.
3. **Seeding:** add `SeedSource.dormant()` to Asset and InMemory sources, plus `SeedLoader._ensureDormant` with the ordering and the reconcile keep. Files: `lib/data/seed/seed_source.dart`, `lib/data/seed/seed_loader.dart`, tests.
4. **Names, guard and display tables:** name pools, cities, real-international guard plus the namer filter, 22 (+hi) name tables plus Czech dative, geography, identity, stadium, flag SVG. Files: `assets/data/country_names.json`, `assets/data/country_names_more.json`, `assets/data/country_cities.json`, `lib/data/seed/real_internationals.dart`, `lib/data/repositories/drift_player_repository.dart`, `lib/domain/services/nation/nation_names*.dart`, `nation_geography.dart`, `nation_identity.dart`, `lib/domain/services/competition/stadium_capacity.dart`, `assets/flags/grl.svg`, l10n tests.
5. **Repository API:** `all()` filters dormant, `freeDemo()` likewise, `everyKnown()`, `forCareer()`; the providers `careerNationsProvider`, `careerNationsByIdProvider`, `knownNationsByIdProvider`. Files: `lib/domain/repositories/nation_repository.dart`, `lib/data/repositories/drift_nation_repository.dart`, `lib/features/nations/career_nations_providers.dart` (no test fakes implement `NationRepository`; checked).
6. **World generation:** `CareerService.create(worldMarkers:)`, `forCareer` in create and `_seedHistory`; `SeasonService._nationsById(careerId)` plus its 16 callers, `season_cycle.dart:1204`, `season_rollover.dart:141`. Files: `lib/features/career/career_providers.dart`, `lib/features/hub/hub_providers.dart`, `season_cycle.dart`, `season_finals.dart`, `season_rollover.dart`.
7. **Call-site migration:** every file in section 4, plus the static guard test.
8. **Normal-career invariance test** (`normal_career_unchanged_test.dart`). Run the full suite: every existing test must pass untouched.
9. **Campaign:** `CampaignDef.dormantNationId`, `CampaignGoal.climbFromBottom`, `Campaigns.greenland`, the grader, progress fields and logic, the `CampaignService.start` marker pass-through, hub card, verdict counts, `campaignWords`. Files: `lib/domain/services/campaign/campaigns.dart`, `campaign_grading.dart`, `lib/features/campaign/campaign_providers.dart`, `campaign_hub_card.dart`, `campaign_verdict_screen.dart`, `campaign_ui.dart`.
10. **Copy:** add the eight keys to `copy/strings.csv` in every language, run `tool/import_copy.dart`, regenerate l10n. Check there are no em dashes and no "World Cup".
11. **Seed search, seed test, world test** (`greenland_world_test.dart`); lab calibration, with the star rates reported to the owner.
12. **Device playtest** (release build, upgrade in place, never `flutter install`): an existing save still opens unchanged; start Greenland; check the saves list, rankings, draws ceremony, friendlies offers and news show no San Marino.
