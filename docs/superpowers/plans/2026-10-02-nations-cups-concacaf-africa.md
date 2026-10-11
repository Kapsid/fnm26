# Nations Cups for CONCACAF and Africa: Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Run three Nations Cups every cycle (Europe and CONCACAF as tiered ladders, Africa as four geographic zones with a November Finals Eight), all scoped per confederation, wherever the manager is.

**Architecture:** A pure registry (`NationsCups`) maps confederation → cup name + format; the Africa zone map lives beside it. Every Nations Cup read/write gains a `confederation:` scope, copying the per-confederation pattern of `_progressContinental`/`_progressContinentalFor` (`season_cycle.dart:397-470`) and the calendar loop in `career_providers.dart:222-314`. Manager-facing surfaces use the manager's confederation's cup.

**Tech Stack:** Flutter, Riverpod (no codegen), Drift, gen-l10n (en, cs, fr, it, pl).

**Spec:** `docs/superpowers/specs/2026-10-02-nations-cups-concacaf-africa-design.md`

## Global Constraints

- Riverpod WITHOUT codegen. No schema change (tiers already per nation in `NationsCupTiers`; competitions already carry `confederation`).
- Stored names (canonical English, never translated in storage): `Nations Cup` (Europe, unchanged), `North America Nations Cup`, `African Nations Cup`. Translated only at display via `competitionLabel`.
- Round codes: groups `NGROUP`; ladder finals `NSF`, `NFINAL`; Africa finals `NQF`, `NSF`, `NFINAL`. Group names: ladder `A1`.. (league letter + index, as now); Africa `N1 N2 W1..W4 E1..E4 S1..S4`.
- All three cups: groups Sep/Oct of wcYear − 2 (existing window days 6/9/12); ladder Finals Four 18 June of wcYear − 1 (final 3 days later, as now); Africa Finals Eight November of wcYear − 2, QF day 12, SF day 15, final day 18.
- Copy: all five ARBs, no em dashes, no "World Cup", no "Nations League" (trademark); re-export `copy/strings.csv` after ARB edits (`dart run tool/export_copy.dart`); `flutter gen-l10n`.
- Never run `flutter install`/`flutter clean`. `dart format` only touched files. Stage only task files: the tree carries unrelated uncommitted session work (match screen/frame/providers, backups, settings, iOS/Android, pubspec) — never stage it.
- Commits end with `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`.

## Review Focus

1. **Two ladder cups in one cycle colliding** — any remaining unscoped `nationsLeague` lookup (`_tournamentComp` without `confederation:` returns an arbitrary row) makes Europe and CONCACAF mix groups/finals or drop a champion. Expected: every lookup scoped; Task 3's test records three distinct champions.
2. **A nation playing two matches on one day** — Nations Cup fixtures vs other competitions (continental finals are Jan/June of wcYear − 2, qualifying draws Jan wcYear − 1). Expected: no clash; Task 2 test checks per-nation dates are unique.
3. **Old saves mid-cycle** — a save whose current cycle was built with only Europe's cup. Expected: progression/rollover/hub tolerate the missing cups (no crash, no phantom events); the new cups appear from the next cycle. Task 4 test.
4. **Manager switching confederation at rollover** (e.g. Europe → CONCACAF job). Expected: his hub/objectives follow the new confederation's cup; ladders of both persist. Task 5 test.
5. **Achievements/challenges keyed on `'Nations Cup'`** — must count all three names without double-counting a single win. Task 5 test.

---

## File Structure

| File | Responsibility |
|---|---|
| `lib/domain/services/competition/nations_cups.dart` (new) | `NationsCupFormat`, `NationsCups.forConfederation`, `allNames`, `isNationsCup(name)`, Africa zone map + `AfricaZone` enum, Finals Eight seeding/pairing (pure) |
| `lib/features/career/career_providers.dart` | calendar: schedule all three cups (ladder remainder merge; Africa zones) |
| `lib/features/hub/season_cycle.dart` | progression per confederation (ladder Finals Four; Africa Finals Eight), honours by cup name |
| `lib/features/hub/season_rollover.dart` | promotion/relegation per ladder confederation |
| `lib/data/repositories/drift_competition_repository.dart` + interface | `confederation:` on `hasLiveNationsCupFinals`, `earliestUnplayedNationsCupFinalsDate`, `latestPlayedWatchedFinalsDate` (Nations Cup part) |
| hub/tournaments/objectives/achievements files listed per task | manager-scoped reads; name checks via `NationsCups.isNationsCup` |
| ARBs + `competition_label.dart` | names, zones, Africa lines |

---

### Task 1: NationsCups registry, Africa zones, Finals Eight (pure domain)

**Files:**
- Create: `lib/domain/services/competition/nations_cups.dart`
- Test: `test/unit/competition/nations_cups_test.dart`

**Interfaces — Produces:**

```dart
enum NationsCupFormat { ladder, zones }
enum AfricaZone { north, west, east, centralSouthern }

typedef NationsCupInfo = ({String name, NationsCupFormat format});

abstract final class NationsCups {
  static const String europe = 'Nations Cup';
  static const String northAmerica = 'North America Nations Cup';
  static const String africa = 'African Nations Cup';
  static const List<String> allNames = [europe, northAmerica, africa];
  static const List<Confederation> confederations = [
    Confederation.europe, Confederation.northAmerica, Confederation.africa,
  ];
  static NationsCupInfo? forConfederation(Confederation c);
  static bool isNationsCup(String competitionName); // trims; true for allNames
  /// FIFA code → zone for the 54 African nations (spec §3 lists).
  static const Map<String, AfricaZone> africaZoneByCode;
  /// Group-name prefix per zone: north 'N', west 'W', east 'E', centralSouthern 'S'.
  static String zonePrefix(AfricaZone z);
  static AfricaZone? zoneOfGroupName(String groupName);
  /// Groups for one zone: 16 nations → 4 groups of 4, 6 → 2 groups of 3;
  /// ranking-seeded pots (pot k = k-th quarter/third of the zone by rank),
  /// deterministic from [seed]. Returns lists of nation ids in group order.
  static List<List<int>> zoneGroups(List<int> rankedIds, int seed);
  /// Finals Eight: from each zone's group winners pick the best two
  /// (points, goal difference, goals for, then ranking), and pair QFs so the
  /// two qualifiers of a zone, and zone winners, are kept apart:
  /// W1 v E2, E1 v S2, S1 v N2, N1 v W2. Input: winners per zone already
  /// ordered best-first. Output: 4 (home, away) pairs.
  static List<(int, int)> finalsEightPairs(Map<AfricaZone, List<int>> bestTwoByZone);
  /// Ladder leagues with the remainder rule: chunks of 16 by tier, but a
  /// trailing league with fewer than 4 nations is merged into the one above.
  static List<List<int>> ladderLeagues(List<int> idsByTierThenRank, List<int> tierOf);
}
```

(If `ladderLeagues`'s signature reads awkwardly once you see how `career_providers.dart:325-345` builds `byTier`, keep the BEHAVIOUR — merge a <4 league into the one above — and implement it where `byTier` is built in Task 2 instead; then drop it from this file and say so in the report.)

- [ ] **Step 1: Failing tests** covering: `forConfederation` (europe → ladder 'Nations Cup', northAmerica → ladder 'North America Nations Cup', africa → zones 'African Nations Cup', asia/southAmerica/oceania → null); `isNationsCup` for the three names and false for 'European Championship'; the zone map covers EXACTLY the 54 African codes of `assets/data/nations.json` (read the file in the test) with sizes 6/16/16/16; `zoneGroups` sizes (16 → 4×4, 6 → 2×3), every id once, the four top-ranked of a 16-zone in four different groups, deterministic per seed; `finalsEightPairs` pairing rule and that no QF pairs two teams of one zone; `zoneOfGroupName('W3') == west`.
- [ ] **Step 2: Run, expect failure.** `flutter test test/unit/competition/nations_cups_test.dart`
- [ ] **Step 3: Implement** (pure Dart; no English strings — domain-speaks-no-English guard).
- [ ] **Step 4: Run, expect pass;** also `flutter test test/unit/l10n/domain_speaks_no_english_test.dart`.
- [ ] **Step 5: Commit** `feat(nations-cup): registry for three cups and African zones`.

---

### Task 2: Calendar — schedule all three cups

**Files:**
- Modify: `lib/features/career/career_providers.dart:316-385` (block 1c)
- Test: `test/unit/competition/nations_cups_calendar_test.dart`; keep `test/unit/competition/cycle_calendar_test.dart` passing

**Interfaces — Consumes:** Task 1. `comp.saveSchedule(careerId:, schedule: GeneratedSchedule(confederation:, name:, groups:), cycle:, kind: CompetitionKind.nationsLeague, fixtureRound: 'NGROUP')` as used today; `ScheduleGenerator().generate(confederation:, nations:, rngSeed:, start:, groupSize:, rankById:)`.

- [ ] **Step 1: Failing test** — create careers (pattern: `test/unit/hub/end_of_cycle_has_a_next_action_test.dart` setup, players can be empty) managing a European, a CONCACAF, an African and an Asian nation; after creation each has three `nationsLeague` competitions in cycle 0, one per confederation, with the right names; every European, CONCACAF and African nation appears in exactly one group of its cup (CONCACAF: 35 nations, no one dropped; League B has 19); African groups are named per zone with sizes 4 / 3; all group fixtures fall in Sep/Oct of wcYear − 2; no nation has two fixtures (any competition) on one date in the cycle.
- [ ] **Step 2: Run, expect failure.**
- [ ] **Step 3: Implement**: replace the `if (me.confederation == Confederation.europe)` block with a loop over `NationsCups.confederations` (manager's first is not required here; the calendar is built once). Ladder: current code, per confederation, seeding `rngSeed ^ (cycle * 0x71) ^ 0x5A17 ^ (tier * 0x9E37) ^ (confederation.index * 7)` so Europe's existing seeds change only by the confederation term (Europe's `confederation.index` term must be 0 or the Europe draw changes for old seeds — check `Confederation.europe.index`; if it isn't 0, apply the extra term only for non-Europe so Europe's draw is byte-identical to today), and the remainder merge. Zones: build each zone's ranked ids, `NationsCups.zoneGroups`, then generate each group's home-and-away fixtures with `ScheduleGenerator` (groupSize 4 or 3; start `DateTime(wcYear - 2, 9)`), group names `N1`.., one `saveSchedule` per cup with `confederation:` and `name:`.
- [ ] **Step 4: Run new test + `cycle_calendar_test` + `full_cycle_test`.** A Europe-managed save's European cup must be unchanged (same groups for a fixed rngSeed as before — assert it against a snapshot taken from the current code before your change).
- [ ] **Step 5: Commit** `feat(nations-cup): CONCACAF and Africa on the calendar`.

---

### Task 3: Progression and honours per confederation

**Files:**
- Modify: `lib/features/hub/season_cycle.dart` (`_progressNationsLeague` ~171-263, `_recordNationsLeagueHonour` ~266-290, call at ~101)
- Modify: `lib/data/repositories/drift_competition_repository.dart` + `lib/domain/repositories/competition_repository.dart` (`hasLiveNationsCupFinals`, `earliestUnplayedNationsCupFinalsDate`: add `Confederation? confederation` — null keeps today's any-cup behaviour; `latestPlayedWatchedFinalsDate` Nations Cup part scoped by the confederation it already takes)
- Modify: `lib/features/hub/hub_providers.dart:1346-1362` (Finals stepping) and `:652` (`hasLiveNationsCupFinals` call) to pass the manager's confederation
- Test: `test/unit/hub/nations_cups_progression_test.dart`

**Interfaces — Produces:** `_progressNationsLeague(careerId)` loops `NationsCups.confederations` (manager's first, like `_progressContinental`) calling `_progressNationsCupFor(careerId, conf)`; ladder path = today's logic with every repo call given `confederation: conf` and the honour recorded under `NationsCups.forConfederation(conf)!.name`; zones path: when all `NGROUP` fixtures of Africa's cup are played, compute each group's winner from `tournamentGroupTables(..., confederation: africa)`, best two per zone via the spec's order, `NationsCups.finalsEightPairs`, add `NQF` fixtures (November day 12 of wcYear − 2, or 14 days after `inGameDate` if already past, as the ladder does), then `NSF` (day 15) from QF winners (QF1 v QF2, QF3 v QF4), then `NFINAL` (day 18), then the honour. Knockout ties decided by the existing knockout path (background → `decideKnockout` with the background `knockoutWeight`; manager's matches via the live screen as for other N-rounds).

- [ ] **Step 1: Failing test** — drive one full cycle (season loop pattern from `end_of_cycle_has_a_next_action_test.dart`, never answering press/draw ceremonies beyond marking draws watched) for a European-managed and an African-managed career; assert three Nations Cup honours with three distinct names for the cycle year, Africa's final has `NQF` → `NSF` → `NFINAL` fixtures (4/2/1) whose participants are group winners, two per zone in the QFs, and that each ladder's Finals Four contains only its own confederation's nations.
- [ ] **Step 2: Run, expect failure.**
- [ ] **Step 3: Implement.**
- [ ] **Step 4: Run new test + `full_cycle_test`, `season_flow_test`, `hub_nations_cup_zones_test`, `test/unit/hub/`.**
- [ ] **Step 5: Commit** `feat(nations-cup): every cup progresses and crowns its own champion`.

---

### Task 4: Rollover per ladder confederation; old saves

**Files:**
- Modify: `lib/features/hub/season_rollover.dart:85-105`
- Test: `test/unit/hub/nations_cups_rollover_test.dart`

- [ ] **Step 1: Failing tests** — (a) after a full cycle, promotion/relegation applied separately to Europe and CONCACAF (`NationsCup.promoteRelegate` per confederation with that confederation's tables only); a CONCACAF result never moves a European nation's tier; African nations' tiers unchanged. (b) An OLD save: build a career, then delete the CONCACAF and African `nationsLeague` competitions of cycle 0 (simulating a save created before this change); drive to rollover: no crash, Europe progresses and relegates as before, and cycle 1's calendar has all three cups.
- [ ] **Step 2: Run, expect failure.**
- [ ] **Step 3: Implement** (loop ladder confederations; read tables with `confederation:`; skip a confederation with no cup).
- [ ] **Step 4: Run + `test/unit/hub/`.**
- [ ] **Step 5: Commit** `feat(nations-cup): ladders move per confederation at rollover`.

---

### Task 5: Manager-facing surfaces and name checks

**Files (from the code survey):**
- Hub: `hub_event.dart:127, 520-545, 587-625`; `hub_providers.dart:190-199`; `hub_screen.dart:368`; `round_popup.dart:112-116`; `draw_reveal.dart:27,42`; `nations_cup_draw_providers.dart:8, 44-55`
- Tournaments: `nations_cup_screen.dart:41-100, 463`; `tournaments_providers.dart:265-295`; `tournaments_screen.dart:197-208`; `round_results_screen.dart:69-76`; `group_advancement.dart:108-114, 161-165`
- Objectives: `objective_providers.dart:246-290, 333, 521-580`; `board_satisfaction.dart` (unchanged tiering, just make sure the manager's cup is the one graded)
- Name checks → `NationsCups.isNationsCup(name)`: `trophies.dart:30,46,94`; `achievement_providers.dart:185`; `challenge_providers.dart:155`; `challenges.dart:174,261,470`; `achievements.dart:328-330`; `nation_vitrine_providers.dart:157`; `nation_offers_providers.dart:244`; `message_text.dart:510`; `competition_label.dart:72` (labels added in Task 6)
- Test: `test/unit/hub/nations_cups_manager_test.dart` + widget/unit tests touched by these files

**Behaviour:**
- Every manager-facing read uses `confederation: <manager's confederation>`; if the manager's confederation has no Nations Cup (Asia/South America/Oceania) every Nations Cup hub event, draw ceremony and objective is absent (as today for non-Europeans), BUT the tournaments screen lists all three cups read-only for everyone.
- `nations_cup_screen.dart` takes a `Confederation` (route param, default the manager's) and renders ladder or zones format; zones: zone sections with their groups, then the Finals Eight bracket (QF/SF/F).
- Africa group advancement line: group winners may reach the Finals Eight; no relegation styling.
- Africa objectives (only for an African manager): by strength — win your group / reach the Finals Eight / reach the final / win it; ordinals fit the existing objective ordering (`objectiveNc*` pattern); no "avoid relegation".
- Name checks: any of the three names counts as "a Nations Cup" for achievements/challenges; a single win counts once.

- [ ] **Step 1: Failing tests**: African manager sees the draw ceremony + objectives for HIS cup and the Finals Eight watch; European manager's objectives/screens unchanged (existing tests); Asian manager has no Nations Cup events; a manager who switches Europe → CONCACAF at rollover sees CONCACAF's cup next cycle; an achievement for winning "the Nations Cup" unlocks for a North America Nations Cup win and counts it once.
- [ ] **Step 2–4:** implement, run focused tests + `test/unit/hub/ test/unit/achievements/ test/widget/`.
- [ ] **Step 5: Commit** `feat(nations-cup): the manager's own cup on the hub, all three on the tournaments screen`.

---

### Task 6: Copy in five languages

**Files:** `lib/l10n/app_{en,cs,fr,it,pl}.arb`, `lib/core/util/competition_label.dart`, regenerated l10n, `copy/strings.csv`; tests `test/widget/*copy_fits*` if headings are new.

- [ ] Keys (EN; translate into cs/fr/it/pl in the same register as each file): `compNorthAmericaNationsCup` ("North America Nations Cup"), `compAfricanNationsCup` ("African Nations Cup"); zone names `nationsCupZoneNorth` ("North Africa"), `nationsCupZoneWest` ("West Africa"), `nationsCupZoneEast` ("East Africa"), `nationsCupZoneCentralSouthern` ("Central and Southern Africa"); `nationsCupFinalsEight` ("Finals Eight"); the Africa advancement line and the Africa objective lines added in Task 5 (if Task 5 added placeholder English keys, translate them here). `competitionLabel` maps the two new stored names. Fit tests cover any new heading in all five languages.
- [ ] Run `flutter gen-l10n`, `dart run tool/export_copy.dart`, `flutter test test/unit/l10n test/widget`.
- [ ] Commit `feat(nations-cup): names, zones and lines in five languages`.

---

### Task 7: Full-cycle integration and suite

- [ ] Extend `test/unit/hub/end_of_cycle_has_a_next_action_test.dart` (or add `nations_cups_full_cycle_test.dart`) so at least one seed manages a CONCACAF nation and one an African nation through two cycles; assert every end of cycle still has a next action and each cycle has three Nations Cup champions.
- [ ] Run the full suite once. Commit `test(nations-cup): three cups through full cycles`.

## Self-Review Notes

Spec §1 → Tasks 3, 4, 5 (scoping) and Task 1 (registry); §2 → Tasks 1, 2, 4; §3 → Tasks 1, 2, 3, 5; §4 → Task 6; Testing → each task + Task 7. Review Focus 1 → Task 3; 2 → Task 2; 3 → Task 4; 4 and 5 → Task 5.
