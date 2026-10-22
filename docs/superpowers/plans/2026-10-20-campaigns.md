# Campaigns Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** A Campaigns mode with two free one-cycle campaigns (The Transplant, Grudge) that live outside the save slots, give a verdict with stars, stamp the result on the device, and can be moved into the saves afterwards.

**Architecture:** A campaign is a normal career created with a fixed world seed and tagged with a per-career marker in the existing watched-draws table (`campaign:<id>`, plus `campaignMoved`). One helper answers "which campaign is this career?"; everything that behaves differently asks it, so normal careers are untouched. Goals are graded from data already recorded (continental qualifying tables and the continental finals run); the best result per campaign is kept in shared preferences.

**Tech Stack:** Flutter, Riverpod 2.6 (no codegen), drift, go_router, gen-l10n (7 languages), shared_preferences, flutter_test.

**Spec:** `docs/superpowers/specs/2026-10-20-campaigns-design.md`

## Global Constraints

- No schema change. Markers go through `CompetitionRepository.markDrawWatched` / `hasWatchedDraw` (table `draws_watched`), at cycle 0.
- Existing saves and normal careers behave exactly as before; 1.0.5 saves in the scratchpad `saves105/` still open (`test/story/compat_105_test.dart`).
- Free campaigns never trigger the paywall, never count toward `saveSlotLimit`, and never hit `trialExhausted` while unmoved.
- Deterministic: each campaign has a fixed `rngSeed`; results vary only by `matchAttemptSaltProvider`.
- Riverpod without codegen (plain `FutureProvider.autoDispose.family`, no `@riverpod`). build_runner, if ever needed, runs with `--force-jit`.
- Copy: all text in 7 `.arb` files (`lib/l10n/app_{en,cs,de,es,fr,it,pl}.arb`), then `flutter gen-l10n` and `dart run tool/export_copy.dart` to refresh `copy/strings.csv`. No em dashes. Never "World Cup" in English copy (it is "World Championship"). Czech: label: value forms, no nation names after prepositions.
- Every new route is added to `tabletReadyPaths` in `lib/features/shell/tablet_shell.dart` and has a `TabletPage` layout with a `tabletLayoutKey`.
- Tests run sequentially (`flutter test <file>`), never several `flutter test` processes at once.
- Commits: the "Commit" steps stage and describe the change; actually committing happens only when the owner asks (work is uncommitted on `main` for 1.0.6).
- Never `flutter install` on a device; device installs use `adb install -r` / `xcrun devicectl device install app`.

## Review Focus

1. A free player with both save slots full starts and plays a campaign: no paywall, no "slots full", and the home screen's Continue card still resumes the last real save, not the campaign. (Task 4 test.)
2. A campaign reaching the end of its cycle (World Championship decided) while unmoved: the hub offers "campaign complete", never the rollover or the trial wall. (Task 7 test.)
3. Starting a campaign that already has a run in progress: Resume or Abandon-and-restart, never a second run. (Task 4 test.)
4. Moving a settled campaign into the saves when the slots are full: refused with a message, the campaign stays where it was. (Task 4 test.)
5. A transplanted Italian never appears for Italy anywhere: the background simulation's Italy XI, the live match preview's Italy side, Italy's squad screen. (Task 3 tests.)

## File Structure

| File | Responsibility |
|---|---|
| Create `lib/domain/services/campaign/campaigns.dart` | Pure registry: `CampaignDef`, `CampaignGoal`, `Campaigns.all`, `Campaigns.byId`, marker keys |
| Create `lib/domain/services/campaign/campaign_grading.dart` | Pure grading: stars from a finish ordinal or a rivalry record |
| Create `lib/features/campaign/campaign_providers.dart` | `campaignOf`, progress provider, `CampaignService` (start, abandon, move, record verdict) |
| Create `lib/features/campaign/campaign_record_store.dart` | Best result per campaign in shared preferences |
| Create `lib/features/campaign/campaigns_screen.dart` (+ `campaigns_tablet_layout.dart` part) | The list of campaign cards with stamps |
| Create `lib/features/campaign/campaign_brief_screen.dart` (+ tablet part) | Intro, rules, goal, manager name, Start |
| Create `lib/features/campaign/campaign_verdict_screen.dart` (+ tablet part) | Verdict, stars, run in numbers |
| Create `lib/features/campaign/campaign_stamp.dart` | The stamp widget (Conquered + stars / Failed) |
| Create `lib/features/campaign/campaign_hub_card.dart` | Hub card: goal and live progress |
| Create `lib/features/federation/career_pool.dart` | A nation's pool within a career: minus players naturalised away, plus players naturalised in |
| Modify `lib/features/career/career_providers.dart` | `savesProvider` and `CareerService.create` skip unmoved campaigns; `create(countsTowardSlots:)` |
| Modify `lib/features/career/career_transfer_providers.dart:86` | Import slot count skips unmoved campaigns |
| Modify `lib/domain/repositories/competition_repository.dart`, `lib/data/repositories/drift_competition_repository.dart` | `watchedKindsWithPrefix` |
| Modify `lib/features/federation/naturalization_providers.dart` | `naturalizedPlayersInto(ref, career, nationId)` |
| Modify `lib/features/hub/hub_providers.dart:398` (`_pool`) and `lib/features/match/match_providers.dart:288` (`oppPool`) plus other-nation pool reads | Use `careerPoolOf` |
| Modify `lib/features/hub/objective_providers.dart` | Extract `continentalRun` (public) from the continental block |
| Modify `lib/features/hub/hub_event.dart` | `HubEventKind.campaignVerdict`, step 1c, unmoved campaign at cycle end |
| Modify `lib/features/hub/hub_screen.dart`, `hub_tablet_layout.dart` | Show `CampaignHubCard` for campaign careers |
| Modify `lib/features/home/home_screen.dart`, `home_tablet_layout.dart` | "Campaigns" entry |
| Modify `lib/core/routing/app_router.dart`, `lib/features/shell/tablet_shell.dart` | Routes `campaigns`, `campaignBrief`, `campaignVerdict` |
| Modify `test/story/driver.dart` | Handle `campaignVerdict`; `StoryDriver.startCampaign` |
| Create `test/story/campaign_lab_test.dart` | Calibration lab (not part of the suite) |
| Tests under `test/unit/campaign/` and `test/widget/` | As named per task |

---

### Task 1: Campaign registry and fixed seeds

**Files:**
- Create: `lib/domain/services/campaign/campaigns.dart`
- Test: `test/unit/campaign/campaign_seeds_test.dart`

**Interfaces:**
- Produces:
  - `enum CampaignGoal { qualifyContinental, aboveRival }`
  - `class CampaignDef { final String id; final int nationId; final int rngSeed; final CampaignGoal goal; final int? rivalNationId; final int? donorNationId; final int transplantCount; final int cycles; final bool needsPro; final List<int> starThresholds; }` (const constructor). For `qualifyContinental`, `starThresholds` are finish ordinals for 1/2/3 stars: `[2, 3, 4]`. For `aboveRival` they are unused (stars are rule-based, Task 5).
  - `abstract final class Campaigns { static const transplant = CampaignDef(id: 'transplant', nationId: 45 /* San Marino */, donorNationId: 26 /* Italy */, transplantCount: 5, goal: CampaignGoal.qualifyContinental, starThresholds: [2, 3, 4], cycles: 1, needsPro: false, rngSeed: <found>); static const grudge = CampaignDef(id: 'grudge', nationId: 19 /* Georgia */, rivalNationId: 3 /* Armenia */, goal: CampaignGoal.aboveRival, cycles: 1, needsPro: false, rngSeed: <found>); static const all = [transplant, grudge]; static CampaignDef? byId(String id); }`
  - `String campaignMarker(String id) => 'campaign:$id';`, `const campaignMovedKind = 'campaignMoved';`, `const campaignVerdictKind = 'campaignVerdict';`

- [ ] **Step 1: Write the guard test** `campaign_seeds_test.dart`, pure (no DB), loading `assets/data/nations.json` as `injury_cover_test.dart` does:

```dart
test('no campaign nation hosts the European Championship', () {
  for (final c in Campaigns.all) {
    final hosts = WorldCupHosts.continentalHostsFor(
      confederation: Confederation.europe, cycle: 0, seed: c.rngSeed, nations: nations);
    expect(hosts, isNot(contains(c.nationId)), reason: c.id);
  }
});
test('Grudge draws Georgia and Armenia into the same qualifying group', () {
  final groups = euroQualifyingGroups(Campaigns.grudge.rngSeed); // helper below
  expect(groups.where((g) => g.contains(19) && g.contains(3)), hasLength(1));
});
test('Transplant: San Marino is in the qualifying draw', () {
  expect(euroQualifyingGroups(Campaigns.transplant.rngSeed).expand((g) => g), contains(45));
});
```

`euroQualifyingGroups(seed)` (test-local helper) rebuilds the draw exactly as `CareerService.buildCalendar` step 1 does for cycle 0: members of Europe sorted by `ranking`, filtered by `WorldCupHosts.continentalQualifiers(confederation: europe, cycle: 0, seed: seed, nations: nations)`, then `const ScheduleGenerator().generate(confederation: europe, nations: field, rngSeed: seed ^ 0 ^ 0xCAFE, start: DateTime(2026, 9), groupSize: 6, windows: (start: DateTime(2026, 9), deadline: DateTime(2027, 6, 30), seed: seed ^ 0xCAFE ^ 0xF1D0, fillAll: false)).groups` mapped to nation-id lists. If the window span does not affect group membership, it may be omitted; check by comparing once.

Add a fourth test that pins the helper to the real thing: create a career with `CareerService.create(nationId: 19, managerName: 'M', rngSeed: Campaigns.grudge.rngSeed)` on `createTestDatabase()` and assert `tournamentGroupTables(careerId, CompetitionKind.continentalQualifying, confederation: Confederation.europe)` has a table holding both 19 and 3.

- [ ] **Step 2: Find the seeds.** Write a throwaway search in the scratchpad (not committed) using the same helper: the first seed from 1 upward for Grudge where Georgia and Armenia share a group and neither hosts; the first for Transplant where San Marino does not host. Europe has 53 nations; Georgia is 33rd and Armenia 39th by ranking, so with 9 groups they sit in adjacent pots and roughly one seed in nine works. If no Grudge seed exists below 100000, stop and report (the rival must change; owner decision).

- [ ] **Step 3: Implement `campaigns.dart`** with the found seeds.

- [ ] **Step 4: Run** `flutter test test/unit/campaign/campaign_seeds_test.dart`. Expected: all pass.

- [ ] **Step 5: Commit** `feat(campaigns): campaign registry with fixed world seeds`.

---

### Task 2: Campaign markers and lookups

**Files:**
- Modify: `lib/domain/repositories/competition_repository.dart` (next to `hasWatchedDraw`, ~line 386), `lib/data/repositories/drift_competition_repository.dart` (~line 1676)
- Create: `lib/features/campaign/campaign_providers.dart` (lookups only in this task)
- Test: `test/unit/campaign/campaign_marker_test.dart`

**Interfaces:**
- Consumes: Task 1 marker keys.
- Produces:
  - `Future<List<({int careerId, String kind})>> watchedKindsWithPrefix(String prefix)` on `CompetitionRepository` (all careers, any cycle; drift `kind LIKE '$prefix%'`). Fakes/mocks of the repository in `test/helpers` get the method too.
  - `typedef CampaignTag = ({CampaignDef def, bool moved});`
  - `Future<Map<int, CampaignTag>> campaignTags(CompetitionRepository comp)` (careerId → tag; one query for `campaign:` plus one for `campaignMoved`).
  - `final campaignOfProvider = FutureProvider.autoDispose.family<CampaignTag?, int>` (careerId).
  - `bool countsAsSave(CampaignTag? tag) => tag == null || tag.moved;`

- [ ] **Step 1: Write failing tests:** a normal career has `campaignOfProvider` null; after `markDrawWatched(id, 0, campaignMarker('grudge'))` it returns `def == Campaigns.grudge, moved == false`; after `campaignMovedKind` it reads `moved == true`; an unknown id (`campaign:nope`) reads null; `watchedKindsWithPrefix('campaign:')` returns rows from two careers.
- [ ] **Step 2: Run, expect FAIL** (method not defined).
- [ ] **Step 3: Implement.**
- [ ] **Step 4: Run** `flutter test test/unit/campaign/campaign_marker_test.dart`; PASS.
- [ ] **Step 5: Commit** `feat(campaigns): per-career campaign markers`.

---

### Task 3: Naturalised players play for one nation only (general fix)

**Files:**
- Create: `lib/features/federation/career_pool.dart`
- Modify: `lib/features/federation/naturalization_providers.dart` (generalise `naturalizedPlayersFor`)
- Modify: `lib/features/hub/hub_providers.dart` (`_pool`, ~line 398, and the cache key), `lib/features/match/match_providers.dart` (~line 288 `oppPool`), `lib/features/tactics/nation_squad_providers.dart:92`, `lib/features/tournaments/cup_detail_providers.dart:323,356`, `lib/features/tournaments/continental_detail_providers.dart:592,618`, `lib/features/awards/award_providers.dart:79`, `lib/features/stats/stats_providers.dart:142`
- Test: `test/unit/federation/naturalised_one_nation_test.dart`

**Interfaces:**
- Produces:
  - `Future<List<Player>> naturalizedPlayersInto(Ref ref, Career career, int nationId)`: accepted links whose `Stints.nationAt(stints, link.cycle, career.nationId) == nationId`, resolved and re-homed exactly as today. `naturalizedPlayersFor(ref, career)` becomes `naturalizedPlayersInto(ref, career, career.nationId)`.
  - `Future<Set<int>> naturalizedAwayIds(CareerRepository repo, int careerId)`: every accepted link's `playerId`.
  - `Future<List<Player>> careerPoolOf(Ref ref, Career career, int nationId, {int? agingYears})`: `byNation(nationId, agingYears: agingYears ?? CareerService.agingYears(career), saveSeed: career.rngSeed)` minus `naturalizedAwayIds`, plus `naturalizedPlayersInto(ref, career, nationId)`, sorted by `overall` descending. For the manager's own nation, callers keep passing the youth/career-dev inputs they pass today (leave those call sites on `byNation` + `naturalizedPlayersFor`, but filter `naturalizedAwayIds` out of the `byNation` part).
  - Background sim: `_pool(nationId)` filters by a `Set<int>` loaded once per operation (cached beside `_poolCache`) and appends players naturalised into that nation; the cache stays keyed per career.

- [ ] **Step 1: Write failing tests** (setup as `test/unit/squad/injury_cover_test.dart`): create a career for San Marino (45), take Italy's (26) best player `p`, `addNaturalizationOffer(careerId, p.id, sourceNationId: 26, cycle: 0)` then `setNaturalizationStatus(careerId, p.id, 'accepted')`. Assert:
  - `careerPoolOf(ref, career, 26)` does not contain `p.id`;
  - the manager's match pool (`naturalizedPlayersFor` + filtered byNation) contains `p.id` with `nationId == 45`;
  - after `switchNation` to another nation (cycle 1 stint), `careerPoolOf(ref, career, 45)` still contains `p.id` and Italy's still does not;
  - a match preview against Italy (`matchPreviewProvider`, with the first fixture's opponent overridden by a friendly vs 26 if needed) has no `p.id` in the Italy XI or bench;
  - a normal career with no naturalisations returns the same pool as `byNation` (equality of id lists).
- [ ] **Step 2: Run, expect FAIL.**
- [ ] **Step 3: Implement** and switch the listed call sites.
- [ ] **Step 4: Run** the new test plus `test/unit/career/nation_switch_test.dart` and `test/unit/hub/` (sequentially). PASS.
- [ ] **Step 5: Commit** `fix(naturalisation): a naturalised player leaves his old nation everywhere`.

---

### Task 4: Starting, abandoning and moving a campaign; slots

**Files:**
- Modify: `lib/features/campaign/campaign_providers.dart` (add `CampaignService`)
- Modify: `lib/features/career/career_providers.dart` (`savesProvider` line 28, `CareerService.create` line 142)
- Modify: `lib/features/career/career_transfer_providers.dart:86`
- Test: `test/unit/campaign/campaign_service_test.dart`

**Interfaces:**
- Consumes: Tasks 1-3.
- Produces:
  - `CareerService.create({required int nationId, required String managerName, int? rngSeed, bool countsTowardSlots = true})`. The slot check counts only careers where `countsAsSave(tags[id])`; skipped entirely when `countsTowardSlots` is false.
  - `savesProvider` returns only careers where `countsAsSave`.
  - `final campaignRunsProvider = FutureProvider.autoDispose<Map<String, Career>>` (campaign id → its unmoved run).
  - `class CampaignService { Future<Career> start(CampaignDef def, {required String managerName}); Future<void> abandon(int careerId); Future<CampaignMoveResult> moveToSaves(int careerId); }` with `enum CampaignMoveResult { moved, slotsFull, notSettled }`.
  - `start`: refuses (throws `StateError`) if a run exists for `def.id` (the UI asks first, Task 8); calls `create(..., rngSeed: def.rngSeed, countsTowardSlots: false)`; marks `campaignMarker(def.id)` at cycle 0; for `donorNationId != null` attaches the donor's top `transplantCount` players (from `careerPoolOf(ref, career, donorNationId)`, i.e. `overall` order at cycle 0) as accepted naturalisations with `cycle: 0`; invalidates `savesProvider`, `campaignRunsProvider`.
  - `abandon`: `CareerService.delete(careerId)`.
  - `moveToSaves`: `notSettled` unless the progress (Task 5) is settled; `slotsFull` when `!canCreateSave(existingSaves: <saves count>, premiumUnlocked: ...)`; otherwise marks `campaignMovedKind` and invalidates.
  - `final campaignServiceProvider = Provider<CampaignService>((ref) => CampaignService(ref));`

- [ ] **Step 1: Write failing tests** with `premiumUnlockedProvider` overridden to **false**:
  - two normal saves exist (slots full); `start(Campaigns.grudge)` succeeds; `savesProvider` still lists 2; `CareerService.create` for a third normal save still fails `slots_full`;
  - `start(Campaigns.transplant)` gives San Marino exactly five accepted naturalisations from Italy, all among Italy's top five by `overall` at cycle 0;
  - a second `start(Campaigns.grudge)` throws `StateError`; `campaignRunsProvider` has one entry per campaign;
  - `abandon` removes the run and its markers (careers row gone);
  - `moveToSaves` before settlement returns `notSettled`; with progress forced settled (record Grudge qualifying results as in Task 5's helper) and two saves present returns `slotsFull`; after deleting one save returns `moved` and `savesProvider` now lists the campaign career.
- [ ] **Step 2: Run, expect FAIL.**
- [ ] **Step 3: Implement.** (Move-to-saves needs Task 5's progress; implement Task 5 first if working strictly in order, or stub the settled check behind `campaignProgressProvider` and finish the test after Task 5.)
- [ ] **Step 4: Run** the new test, `test/unit/career/save_slots_test.dart`, `test/unit/career/trial_gate_test.dart`. PASS.
- [ ] **Step 5: Commit** `feat(campaigns): start, abandon and move campaigns outside the save slots`.

---

### Task 5: Goal progress and grading

**Files:**
- Create: `lib/domain/services/campaign/campaign_grading.dart`
- Modify: `lib/features/hub/objective_providers.dart` (extract the continental block's run/ordinal into a public function; `cycleObjectiveOutcomesProvider` calls it, behaviour unchanged)
- Modify: `lib/features/campaign/campaign_providers.dart` (progress provider)
- Test: `test/unit/campaign/campaign_grading_test.dart`, `test/unit/campaign/campaign_progress_test.dart`

**Interfaces:**
- Produces:
  - `Future<({int ordinal, bool over})> continentalRun({required CompetitionRepository comp, required int careerId, required int nationId, required Confederation confederation, required List<Fixture> fixtures})`: `ordinal` is `_finishOrdinal(fixtures, nationId, prefix: 'C')` (0 not qualified, 2 group, 3 last 16, 4 quarter-final, 5 semi, 6 final, 7 champions); `over` is `continentalChampion != null || _runIsOver(...)`. The board's 0→`_qualifyingOrdinal` fallback stays in the board code only.
  - Pure: `int starsForFinish(int ordinal, List<int> thresholds)` (count of thresholds met, 0..3).
  - Pure: `int grudgeStars({required bool aboveRival, required bool qualified, required bool wonBoth})` = `aboveRival ? 1 + (qualified ? 1 : 0) + (qualified && wonBoth ? 1 : 0) : 0`.
  - `typedef CampaignProgress = ({CampaignDef def, bool settled, int stars, int? myPosition, int? rivalPosition, int? goalDifferenceGap, int ordinal, int rivalWins, int rivalMatchesPlayed});` (`stars > 0` is success).
  - `final campaignProgressProvider = FutureProvider.autoDispose.family<CampaignProgress?, int>` (careerId; null for a non-campaign career).
  - Transplant: `settled = run.over` (not qualified is over when the finals groups exist without San Marino, as `_runIsOver` already does); `stars = starsForFinish(run.ordinal, [2, 3, 4])` once settled.
  - Grudge: from `tournamentGroupTables(careerId, CompetitionKind.continentalQualifying, confederation: europe)`, the table holding 19 and 3; positions are the standings index + 1. `aboveRival` = Georgia's index < Armenia's. `wonBoth` from the two `CQ` fixtures between 19 and 3 (both played, Georgia scored more in each). Settled when every fixture in that group has a result AND the finals field is known (`fixturesByRound(careerId, 'CGROUP', kind: CompetitionKind.continentalFinals, confederation: europe)` non-empty); `qualified = ordinal >= 2`.
  - At the end of the cycle (`worldChampion` decided) an unsettled campaign is settled with what it has; if the rollover verdict (`rolloverVerdictProvider`) says `sacked`, stars are 0.

- [ ] **Step 1: Write failing pure tests:** `starsForFinish(0,[2,3,4]) == 0`, `(2) == 1`, `(3) == 2`, `(4) == 3`, `(7) == 3`; `grudgeStars(aboveRival: false, qualified: true, wonBoth: true) == 0`; `(true,false,true) == 1`; `(true,true,false) == 2`; `(true,true,true) == 3`.
- [ ] **Step 2: Write failing provider tests** on a started Grudge career (seed from Task 1): record every `CQ` fixture of the group with scores that put Georgia 2nd and Armenia 4th and Georgia winning both meetings (`recordResult` as in `injury_cover_test.dart`); before the finals draw `settled == false`; after running the season service to the continental finals draw (or saving the `CGROUP` draw with Georgia in it via `saveTournamentGroups`), `settled == true, stars == 3`. A second case with Armenia above: `stars == 0, settled == true`. Transplant: with San Marino absent from a saved finals draw, `settled == true, stars == 0`; with San Marino drawn and knocked out in the group, `stars == 1`.
- [ ] **Step 3: Add the regression guard** that `cycleObjectiveOutcomesProvider` is unchanged: run `test/unit/hub/` board objective tests (`board_objective_missed_test.dart`, `brief_rules_carry_over_test.dart`).
- [ ] **Step 4: Implement**, run the three test files. PASS.
- [ ] **Step 5: Commit** `feat(campaigns): grade campaign goals from recorded tables and runs`.

---

### Task 6: Best result on the device

**Files:**
- Create: `lib/features/campaign/campaign_record_store.dart`
- Test: `test/unit/campaign/campaign_record_store_test.dart`

**Interfaces:**
- Produces:
  - Key `'campaign_best_v1:<id>'` holding an int: `-1` never finished (absent), `0` failed, `1..3` best stars.
  - `class CampaignRecordStore { Future<int?> best(String id); Future<void> record(String id, int stars); }` keeping the maximum (a later failure never lowers a conquest).
  - `final campaignBestProvider = FutureProvider.autoDispose.family<int?, String>`; `record` invalidates it.
  - Pattern: as `TacticPresetStore` (`lib/features/tactics/tactic_preset_providers.dart`), `SharedPreferences.getInstance()`.

- [ ] **Step 1: Failing tests** with `SharedPreferences.setMockInitialValues({})`: `best('grudge') == null`; `record('grudge', 0)` → `0`; `record('grudge', 2)` → `2`; `record('grudge', 1)` → still `2`; `record('grudge', 0)` → still `2`; another id unaffected.
- [ ] **Step 2: Run, FAIL. Step 3: Implement. Step 4: Run, PASS.**
- [ ] **Step 5: Commit** `feat(campaigns): remember the best result per campaign`.

---

### Task 7: Verdict event and the end of a campaign's cycle

**Files:**
- Modify: `lib/features/hub/hub_event.dart` (enum, step 1 and new step 1c after the naturalisation step, ~line 258)
- Modify: `lib/features/campaign/campaign_providers.dart` (`CampaignService.acknowledgeVerdict`)
- Modify: `test/story/driver.dart` (switch case; `startCampaign`)
- Test: `test/unit/campaign/campaign_verdict_event_test.dart`

**Interfaces:**
- Consumes: Tasks 2, 5, 6.
- Produces:
  - `HubEventKind.campaignVerdict` (doc: "A campaign's goal is settled: see the verdict.").
  - Step 1c: for a campaign career where `campaignProgressProvider.settled` and `!hasWatchedDraw(careerId, 0, campaignVerdictKind)`: `HubEvent(kind: campaignVerdict, label: l.hubEventCampaignVerdict, icon: Icons.verified_rounded, route: '${Routes.campaignVerdict}?careerId=$careerId')`.
  - Step 1 (World Championship decided): for an UNMOVED campaign career, return the verdict event if not yet acknowledged, otherwise `HubEvent(kind: campaignVerdict, label: l.hubEventCampaignComplete, route: '${Routes.campaigns}')` instead of `cycleRollover`. Moved campaigns roll over normally.
  - `Future<void> acknowledgeVerdict(int careerId)`: marks `campaignVerdictKind` at cycle 0 and calls `CampaignRecordStore.record(def.id, progress.stars)`. Called by the verdict screen's Continue (Task 9).
  - Driver: `case HubEventKind.campaignVerdict:` calls `acknowledgeVerdict` and, if the route is `Routes.campaigns`, returns false (run over). `static Future<StoryDriver> startCampaign(ProviderContainer c, CampaignDef def)` uses `CampaignService.start`.

- [ ] **Step 1: Failing tests:** play a Grudge career with `StoryDriver.startCampaign` (premium overridden false) until the event kind is `campaignVerdict`; assert it arrives no later than the first event after the continental finals draw; after `acknowledgeVerdict`, it does not reappear mid-cycle and `campaignBestProvider('grudge')` equals the progress stars. Continue stepping to the cycle end: the event is "campaign complete" (route `Routes.campaigns`), never `cycleRollover`, and `trialExhausted` is never consulted (the rollover screen route never appears). A normal career's event sequence over the same steps is unchanged (compare kinds against a run of `StoryDriver.start` with the same seed for 200 steps).
- [ ] **Step 2: Run, FAIL. Step 3: Implement. Step 4: Run** the test and `test/story/smoke_test.dart`; PASS.
- [ ] **Step 5: Commit** `feat(campaigns): verdict event, and a campaign's cycle ends in the campaigns list`.

---

### Task 8: Campaigns list, stamp, brief, home entry, routes

**Files:**
- Create: `lib/features/campaign/campaigns_screen.dart` (+ `campaigns_tablet_layout.dart`), `campaign_brief_screen.dart` (+ `campaign_brief_tablet_layout.dart`), `campaign_stamp.dart`
- Modify: `lib/core/routing/app_router.dart` (`Routes.campaigns = '/campaigns'`, `Routes.campaignBrief = '/campaign-brief'` with `?id=`), `lib/features/shell/tablet_shell.dart` (`tabletReadyPaths`), `lib/features/home/home_screen.dart` (a `TextButton`/secondary button "Campaigns" under New game) and `home_tablet_layout.dart`
- Modify: 7 `.arb` files, then `flutter gen-l10n`, `dart run tool/export_copy.dart`
- Test: `test/widget/campaigns_screen_test.dart`, `test/widget/tablet_route_sweep_test.dart` (add routes)

**Interfaces:**
- Consumes: Tasks 1, 2, 4, 6.
- Produces:
  - `CampaignsScreen` (`static const Key tabletLayoutKey = Key('campaigns.tabletLayout')`): one card per `Campaigns.all` with flag, title, twist, goal, star thresholds, difficulty label, a "Free" badge, and `CampaignStamp(best: int?)`. Actions: no run → Start (opens brief); run unsettled → Resume (hub) and Abandon; run settled → Resume, Move to saves, Abandon. Abandon asks to confirm in-app. Move shows a snackbar on `slotsFull` (`l.campaignMoveSlotsFull`).
  - `CampaignStamp`: `best == null` draws nothing; `0` "Failed"; `1..3` "Conquered" with that many stars. Tilted, double-ring passport stamp drawn with the theme's colours (no new assets).
  - `CampaignBriefScreen` (`?id=`): intro, rules, goal, manager name field (default from the last save's manager or "Manager"), Start → `CampaignService.start` → `context.go('${Routes.hub}?careerId=$id')`. If a run exists, the brief offers Resume / Abandon and restart instead.
  - String keys (English given; translate the other six): `homeCampaigns` "Campaigns", `campaignsTitle` "Campaigns", `campaignTransplantTitle` "The Transplant", `campaignTransplantTwist` "Five of Italy's best switch allegiance to San Marino", `campaignTransplantGoal` "Qualify for the European Championship", `campaignGrudgeTitle` "Grudge", `campaignGrudgeTwist` "Georgia and Armenia, drawn together", `campaignGrudgeGoal` "Finish above Armenia in qualifying", `campaignTransplantIntro`, `campaignGrudgeIntro` (two or three sentences each), `campaignStars1/2/3Transplant` "Qualify" / "Reach the knockouts" / "Quarter-final or better", `campaignStars1/2/3Grudge` "Above Armenia" / "And qualify" / "And beat them twice", `campaignFree` "Free", `campaignStart` "Start", `campaignResume` "Resume", `campaignAbandon` "Abandon", `campaignAbandonConfirm` "Abandon this run? Its progress is lost; your stamp stays.", `campaignMoveToSaves` "Move to saves", `campaignMoveSlotsFull` "Your save slots are full. Free one first.", `campaignStampConquered` "Conquered", `campaignStampFailed` "Failed", `campaignDifficultyHard` "Hard", `campaignDifficultyMedium` "Medium".

- [ ] **Step 1: Failing widget tests** (`pumpApp` from `test/helpers/pump_app.dart`): the list shows two cards; with a prefs best of 2 for transplant the card shows "Conquered" and two stars; best 0 shows "Failed"; a started unsettled run shows Resume and Abandon, not Start; tapping Start → brief → Start lands on the hub of a career whose `campaignOfProvider` is the campaign; the home screen shows the Campaigns entry and its Continue card resumes the newest normal save, not the campaign (Review Focus 1).
- [ ] **Step 2:** add `Routes.campaigns` and `Routes.campaignBrief` to the route sweep's list.
- [ ] **Step 3: Run, FAIL. Step 4: Implement**, gen-l10n, export copy.
- [ ] **Step 5: Run** the two tests plus `test/unit/l10n/` (sequentially). PASS.
- [ ] **Step 6: Commit** `feat(campaigns): campaigns list with stamps, brief and home entry`.

---

### Task 9: Verdict screen and hub card

**Files:**
- Create: `lib/features/campaign/campaign_verdict_screen.dart` (+ tablet part), `campaign_hub_card.dart`
- Modify: `app_router.dart` (`Routes.campaignVerdict = '/campaign-verdict'`), `tablet_shell.dart`, `lib/features/hub/hub_screen.dart` (above `_NextMatch` when `campaignOfProvider` is non-null), `hub_tablet_layout.dart`
- Modify: 7 `.arb` files, gen-l10n, export copy
- Test: `test/widget/campaign_verdict_test.dart`, route sweep

**Interfaces:**
- Consumes: Tasks 5, 6, 7.
- Produces:
  - `CampaignVerdictScreen(careerId)`: title, success/failure headline, `CampaignStamp(best: progress.stars)`, the run in numbers (played, won, drawn, lost, goals for/against in the campaign's competition; Grudge adds the two meetings), Continue → `acknowledgeVerdict` → back to the hub.
  - `CampaignHubCard(careerId)`: goal line and progress line. Transplant: "Qualifying: 3rd" then the finals stage; Grudge: "Qualifying: 2nd, Armenia 4th" or "Level with Armenia on points, ahead on goal difference" (label: value forms in Czech).
  - Keys: `hubEventCampaignVerdict` "Campaign settled: see the verdict", `hubEventCampaignComplete` "Campaign complete", `campaignVerdictWon` "Conquered", `campaignVerdictLost` "Not this time", `campaignVerdictContinue` "Continue", `campaignProgressQualifying` "Qualifying: {position}", `campaignProgressRival` "{rival}: {position}", `campaignProgressFinals` "Finals: {stage}", `campaignRunInNumbers` "The run in numbers".

- [ ] **Step 1: Failing widget tests:** a settled 2-star Grudge career shows "Conquered" and two stars; Continue marks `campaignVerdictKind` and records 2; a failed one shows "Not this time" and records 0; the hub of a campaign career shows the card with the rival's position; a normal career's hub has no card (golden `hub_*` unchanged).
- [ ] **Step 2: Run, FAIL. Step 3: Implement. Step 4: Run** the test, route sweep, hub goldens (`test/golden/`). PASS.
- [ ] **Step 5: Commit** `feat(campaigns): verdict screen and hub progress card`.

---

### Task 10: Calibration

**Files:**
- Create: `test/story/campaign_lab_test.dart` (not part of the suite; like `objective_lab_test.dart`, reads `LAB_RUNS`, default 40)
- Modify (only if calibration requires): `lib/domain/services/campaign/campaigns.dart` thresholds or `transplantCount`

**Interfaces:**
- Consumes: `StoryDriver.startCampaign`, `campaignProgressProvider`.

- [ ] **Step 1: Write the lab:** for each campaign and run `i` in `0..LAB_RUNS-1`, a `storyContainer()` with `matchAttemptSaltProvider.overrideWithValue(() => i)`, play until the verdict; print stars per run and the distribution.
- [ ] **Step 2: Run** `LAB_RUNS=40 flutter test test/story/campaign_lab_test.dart`. Target per campaign: one star or more in 20-50% of runs, three stars rare (under 10%).
- [ ] **Step 3:** If outside the target, adjust in this order and re-run: Transplant `transplantCount` (4-6) or thresholds; Grudge thresholds only. Re-run Task 1's seed guard after any seed change. Report the final figures to the owner.
- [ ] **Step 4: Commit** `test(campaigns): calibration lab and tuned thresholds`.

---

### Task 11: Whole-app verification

- [ ] **Step 1:** `flutter analyze` → "No issues found!".
- [ ] **Step 2:** `flutter test` (full suite, one process) → all pass (last baseline 3,476).
- [ ] **Step 3:** `flutter test test/story/compat_105_test.dart` → 1.0.5 saves open; no campaign markers appear in them; `savesProvider` lists them all.
- [ ] **Step 4:** Update memory `release-106.md` with the campaigns status and the found seeds.
