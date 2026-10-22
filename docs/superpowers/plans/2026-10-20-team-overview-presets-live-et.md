# Team Overview, In-Match Presets and Live Extra Time Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Tapping any nation opens its team page, which now leads with the nation as it is today; saved tactic presets can be applied during a match; and extra time is played live by the match engine so tactics changed at the 90' and 105' breaks count.

**Architecture:** Three parts that ship on their own, in this order: A (team overview), B (in-match presets), C (live extra time). A adds one derived provider (`nationNowProvider`) and a "now" block above the existing vitrine, and routes every nation tap through the existing `openNation` helper. B passes the save's presets into the in-match editor and applies one through the editor's existing reshape path (no substitutions). C gives `MatchEngine.play` an opt-in extra-time continuation (minutes 91-120), splits the shootout out of `WorldCupFinals.decideKnockout` without changing its random stream, and makes the live screen and commit path use the engine's extra time instead of a second draw.

**Tech Stack:** Flutter, Riverpod 2.6 (no codegen), drift, go_router, gen-l10n (en, cs, de, es, fr, it, pl), flutter_test with goldens.

**Spec:** `docs/superpowers/specs/2026-10-20-team-overview-and-match-presets-design.md`

## Global Constraints

- No schema change; nothing stored changes shape. Existing (1.0.5) saves keep working; a knockout already played keeps its stored score.
- Riverpod without codegen (`FutureProvider.autoDispose.family`, no `@riverpod`).
- Every new string in all seven `.arb` files, then `flutter gen-l10n` and `dart run tool/export_copy.dart` to refresh `copy/strings.csv`.
- No em dashes in user-facing copy. Never "World Cup" in English copy (it is "World Championship").
- Czech: no nation names after prepositions; use label: value layouts.
- One tap behaviour: `openNation(context, careerId:, nationId:)` in `lib/features/shell/detail_pane_host.dart` (side pane where the screen has one, otherwise the full page).
- Never break an existing row tap: where a row already opens something, only the flag/name inside it becomes the team tap, or nothing changes.
- Background `RatingMatchSimulator` and AI-only knockouts (`hub_providers.dart` ~line 943) are unchanged, byte for byte.
- Tablet route sweep (`test/widget/tablet_route_sweep_test.dart`) and goldens stay green; update goldens only where the new "now" block legitimately changes the vitrine.
- Run `flutter test` files sequentially, never parallel processes (native-assets clash).
- Commit only when the owner asks; the commit steps below are the points to commit at once asked.

## Review Focus

1. **A nation with no fixtures yet this save** (fresh career, nation not in any drawn competition): the "now" block shows ranking and squad, and form/next read an empty state, no crash. Test in Task A1.
2. **The manager's own nation page:** "Against you" hidden; Overall comes from the current lineup, not the best XI. Test in Task A1.
3. **Preset applied with ten men** (a red card): still ten on the pitch, no substitution spent, the hole stays a hole. Test in Task B1.
4. **A level knockout skipped to full time** (`_skip`, testing aid) or **settled in 90 minutes**: no extra-time run, stored score unchanged; and a knockout that goes to extra time stores exactly the screen's after-extra-time score and shootout. Tests in Tasks C3 and C4.
5. **A tactical change made in regulation stoppage time** (clock at 90): it now lands at minute 91 and applies in extra time, never rewrites the ninety. Test in Task C1.

---

## File Structure

Part A
- Create `lib/features/nations/nation_now_providers.dart`: `NationNow` model and `nationNowProvider`.
- Create `lib/features/nations/nation_now_card.dart`: the "now" block widget (ranking, form, next match, squad, against you).
- Modify `lib/features/nations/nation_vitrine_screen.dart` (`NationView`) and `lib/features/nations/nation_vitrine_tablet_layout.dart`: show the block on top.
- Create `lib/shared/widgets/nation_tap.dart`: `NationTap` wrapper that calls `openNation`.
- Modify `lib/shared/widgets/match_result_row.dart`: optional `careerId` makes each side tappable.
- Modify the tap sites listed in Task A3.

Part B
- Create `lib/features/tactics/tactic_preset_tile.dart`: the preset row shared by both sheets.
- Modify `lib/features/tactics/tactics_screen.dart` (`_PresetsSheet` uses the tile).
- Modify `lib/features/tactics/in_match_tactics.dart`: `presets` parameter, presets button, `_applyPreset`.
- Modify `lib/features/match/match_screen.dart` (`_openTactics`): load and pass presets.
- Remove `matchInstructionsLocked` from the seven `.arb` files.

Part C
- Modify `lib/domain/services/match/match_engine.dart`: `extraTimeIfLevel`, `MatchResult.extraTime`, ET chance factor.
- Modify `lib/domain/services/competition/finals.dart`: extract `decideShootout`.
- Modify `lib/domain/services/match/ai_substitutions.dart`: one extra-time sub.
- Modify `lib/features/match/match_providers.dart` (initial `MatchEngine().play`, ~line 427) and `lib/features/match/match_screen.dart` (`_resim`, `_ensureKnockoutSetup`, `_knockoutOutcome`, ET talk, sub limit, ET goal display).
- Modify `lib/features/hub/hub_providers.dart` (`_playPlayerMatch`, ~line 1878).
- Tests listed per task.

---

# Part A: Tap any team, see its overview

### Task A1: `nationNowProvider`

**Files:**
- Create: `lib/features/nations/nation_now_providers.dart`
- Test: `test/unit/nations/nation_now_test.dart`

**Interfaces:**
- Consumes: `NationVitrineArg` (`lib/features/nations/nation_vitrine_providers.dart`), `worldRankingProvider` (`RankingData.position/points/movement/baseline`), `competitionRepositoryProvider` (`fixturesForNation`, `cycleFixturesForNation`, `headToHead`), `playerRepositoryProvider.byNation`, `tacticDataProvider` (own nation lineup), `bestEleven`, `squadOverall`, `naturalizedPlayersFor`, `absenceRepositoryProvider`.
- Produces:
  ```dart
  typedef FormChip = ({Fixture fixture, int opponentId, int goalsFor, int goalsAgainst, String outcome}); // outcome 'W'|'D'|'L'
  class NationNow {
    final int? rank; final int? points; final int movement; final RankBaseline? baseline;
    final Confederation confederation;
    final List<FormChip> form;          // latest first, at most 5
    final Fixture? next;                // earliest unplayed this cycle
    final int? overall;                 // null when the pool is empty
    final List<Player> topPlayers;      // best 3 by overall
    final ({HeadToHead record, Fixture? last})? againstYou; // null on own page or no meetings
    final bool isPlayerNation;
  }
  final AutoDisposeFutureProviderFamily<NationNow?, NationVitrineArg> nationNowProvider;
  ```

- [ ] **Step 1: Write the failing tests** using `seedSave(tester)`-style setup from `test/helpers/seeded_save.dart` (or a `ProviderContainer` as in `test/unit/squad/injury_cover_test.dart`):
  - `another nation: ranking, form, next, squad and against-you`: record two results between the manager's nation and nation X; expect `rank == ranking.position[X]`, `movement == ranking.movement[X]`, `form.length == 2` latest first with correct `outcome`, `next` is the earliest unplayed cycle fixture, `topPlayers.length == 3` sorted by overall, `overall == squadOverall(xi of bestEleven(Formation.f433, available pool))`, `againstYou!.record.played == 2`, `againstYou!.last` is the later meeting.
  - `own nation: overall from the current lineup, no against-you`: `overall == squadOverall(lineup players of tacticDataProvider)`, `againstYou == null`, `isPlayerNation`.
  - `a nation with no fixtures: empty form, no next, ranking still shown` (Review Focus 1).
- [ ] **Step 2: Run** `flutter test test/unit/nations/nation_now_test.dart`; expected FAIL (file not found).
- [ ] **Step 3: Implement** in `nation_now_providers.dart`. Other nations' pool: `byNation(nationId, agingYears:, saveSeed:)` minus players with an active absence, plus naturalised players held by that nation; best XI in `Formation.f433` (the default the match preview uses). Own nation: the tactic's lineup from `tacticDataProvider(careerId)`. Form from `fixturesForNation` (all-time) filtered `hasResult`, sorted by date descending, take 5; a knockout settled on penalties counts as a draw-in-score but the chip outcome follows the winner.
- [ ] **Step 4: Run** the test; expected PASS.
- [ ] **Step 5: Commit** `feat(nations): nationNowProvider for the team page's now block`.

### Task A2: The "now" block on the team page

**Files:**
- Create: `lib/features/nations/nation_now_card.dart`
- Modify: `lib/features/nations/nation_vitrine_screen.dart` (`NationView.build`, above `_HonoursCard`), `lib/features/nations/nation_vitrine_tablet_layout.dart` (left column, under `_Header`)
- Modify: seven `.arb` files
- Test: `test/widget/nation_view_test.dart` (extend), `test/widget/nation_page_tablet_test.dart` (extend)

**Interfaces:**
- Consumes: `nationNowProvider` (A1), `openNation`, `Routes.ranking`, `Routes.h2hMeetings` (`?careerId=&a=&b=`), `openPlayer`.
- Produces: `class NationNowCard extends ConsumerWidget { const NationNowCard({required int careerId, required int nationId}); static const Key rankingKey, formKey, nextKey, squadKey, againstYouKey; }`

New strings (keys; English values are the builder's, within Global Constraints): `nationNowRanking`, `nationNowForm`, `nationNowNoForm`, `nationNowNext`, `nationNowNoNext`, `nationNowSquad`, `nationNowAgainstYou`, `nationNowRecord` (placeholders `w`, `d`, `l`), `nationNowLastMeeting`.

- [ ] **Step 1: Write failing widget tests:**
  - `NationView leads with the now block`: `find.byKey(NationNowCard.rankingKey)` appears above the honours section (compare `tester.getTopLeft` dy).
  - `tapping the ranking opens the world ranking`: router lands on `Routes.ranking`.
  - `against-you links to the meetings`: tap `againstYouKey` → router location starts with `Routes.h2hMeetings` and carries `a=<own>&b=<nation>`.
  - `own page hides against-you`: `findsNothing` for `againstYouKey`.
  - Tablet: the block is in the left column on `kTabletSize`.
- [ ] **Step 2: Run** both test files; expected FAIL.
- [ ] **Step 3: Implement** `NationNowCard` with the five sections in the spec's order; squad players tap through `openPlayer`. Add the strings to all seven `.arb` files, run `flutter gen-l10n`, then `dart run tool/export_copy.dart`.
- [ ] **Step 4: Run** the two files plus `flutter test test/widget/czech_copy_fits_test.dart test/widget/world_championship_copy_fits_test.dart`; expected PASS. Re-record vitrine goldens only if they fail on the new block: `flutter test --update-goldens <golden file>`.
- [ ] **Step 5: Commit** `feat(nations): team page leads with the nation as it is now`.

### Task A3: Every nation is a tap

**Files:**
- Create: `lib/shared/widgets/nation_tap.dart` (export from `lib/shared/widgets/widgets.dart`)
- Modify: `lib/shared/widgets/match_result_row.dart`; `lib/features/ranking/world_ranking_screen.dart:192` (direct push → `openNation`); the known places: `lib/features/results/results_screen.dart`, `results_tablet_layout.dart`, `round_results_screen.dart`, `round_results_tablet_layout.dart`, `lib/features/hub/round_popup.dart`, `lib/features/hub/hub_screen.dart` (`_GroupTable`), `lib/features/tournaments/cup_detail_screen.dart`, `continental_detail_screen.dart`, `nations_cup_screen.dart`, `continental_clash_screen.dart`, `tournament_bracket.dart`, `intercontinental_playoff_bracket.dart`, `best_thirds.dart`, `draw_ceremony.dart` (finished groups only), `lib/features/match/match_preview_screen.dart` (`_Side` blocks) and its tablet layout, `lib/features/records/head_to_head_screen.dart` and tablet layout.
- Test: `test/widget/nation_tap_test.dart`, `test/widget/match_result_row_test.dart` (extend)

**Interfaces:**
- Consumes: `openNation`.
- Produces: `class NationTap extends StatelessWidget { const NationTap({required int careerId, required int nationId, required Widget child, Key? key}); }` (an `InkWell` around an already labelled child). `MatchResultRow` gains `final int? careerId;` (null keeps today's behaviour).

- [ ] **Step 1: Write failing tests:**
  - `NationTap opens the nation page on a phone` and `…in the detail pane on a tablet` (pattern from `test/widget/nation_view_test.dart` with a `DetailPaneScope`).
  - `MatchResultRow sides tap through when given a careerId`: tap the away flag → `nation page <awayId>`; without `careerId` nothing navigates.
  - `a row that already opens a match keeps doing so`: on the results list, tapping the row's score area still opens the match/round it opened before; tapping the flag opens the nation.
  - `world ranking row uses openNation`: on tablet the pane shows `NationView` for the tapped nation.
- [ ] **Step 2: Run** the two files; expected FAIL.
- [ ] **Step 3: Implement** `NationTap` and wire the listed places. Rule from the spec: identifiable entries only (standings rows, fixture sides, bracket slots, finished draw groups, preview team blocks, head-to-head sides); decorative flags in news and Y text stay inert. Sweep `grep -rl "FlagDisc(" lib/features` for any further identifiable entries and wire those that match the rule.
- [ ] **Step 4: Run** the two new files, then the existing widget tests for every touched screen (`results_*`, `round_results_tablet_test.dart`, `cup_detail_tablet_test.dart`, `continental_detail_tablet_test.dart`, `nations_cup_*`, `tournament_bracket*`, `draw_ceremony*`, `match_preview_tablet_test.dart`, `h2h_tablet_test.dart`, `world_ranking_tablet_test.dart`, `tablet_route_sweep_test.dart`); expected PASS.
- [ ] **Step 5: Commit** `feat(nations): tapping a nation anywhere opens its page`.

---

# Part B: Tactic presets during the match

### Task B1: Presets in the in-match editor

**Files:**
- Create: `lib/features/tactics/tactic_preset_tile.dart`
- Modify: `lib/features/tactics/tactics_screen.dart` (`_PresetsSheetState` list rows use the tile), `lib/features/tactics/in_match_tactics.dart`, `test/helpers/in_match_editor.dart` (`openEditor` gains `List<TacticPreset> presets = const []`, `Set<int> sentOffIds = const {}`, `List<int?>? lineup`)
- Test: `test/widget/in_match_presets_test.dart`

**Interfaces:**
- Consumes: `TacticPreset` (`lib/domain/entities/tactic_preset.dart`), the editor's `_setFormation` (refits only the players already on the pitch via `bestEleven(f, reshapePool(_eligible, _onPitch))`).
- Produces:
  - `class TacticPresetTile extends StatelessWidget { const TacticPresetTile({required TacticPreset preset, required VoidCallback onApply, VoidCallback? onDelete}); }`
  - `showInMatchTactics(..., List<TacticPreset> presets = const [])`
  - `abstract final class InMatchTacticsKeys { static const Key presetsButton = Key('inMatchTactics.presets'); }`

- [ ] **Step 1: Write failing tests** (presets `Chase it` = `f424`, mentality 85, pressing 80, tempo 75, width 70, defensiveLine 75, directness 70):
  - `applying a preset sets shape and all six sliders, same eleven`: open editor, tap `presetsButton`, tap `Chase it`, tap Apply; expect `result.formation == Formation.f424`, `result.instructions` equal field by field, `result.lineup.whereType<int>().toSet() == {1..11}`.
  - `applying the current shape changes only the sliders`: preset in `f442` leaves `lineup` identical slot by slot.
  - `ten men stay ten`: `sentOffIds: {5}`, lineup with slot 4 null; after the preset, exactly 10 non-null and none of 12..16 on (Review Focus 3).
  - `sliders stay editable after a preset`: drag mentality after applying; result carries the dragged value.
  - `no presets: the button explains how to save one`: tapping shows `l.tacticsPresetsBlurb` text and no tiles.
  - Tablet: the button exists with `tabletLayout: true` on `kTabletSize`.
- [ ] **Step 2: Run** `flutter test test/widget/in_match_presets_test.dart`; expected FAIL.
- [ ] **Step 3: Implement** `void _applyPreset(TacticPreset p)` in `_InMatchTacticsEditorState`: `_setFormation(p.formation)` then `setState(() => _instructions = p.instructions)`. The app-bar action (icon and tooltip `l.tacticsTooltipPresets`, as on the tactics screen) opens a bottom sheet of `TacticPresetTile`s, apply only (saving from inside the match is not offered). Move the pre-match sheet's row markup into `TacticPresetTile` so both read the same.
- [ ] **Step 4: Run** the new file plus `in_match_red_card_test.dart`, `in_match_sub_undo_test.dart`, `in_match_tactics_tablet_test.dart`, `tactics_tablet_test.dart`, `tactics_tabs_test.dart`; expected PASS.
- [ ] **Step 5: Commit** `feat(tactics): saved presets in the in-match editor`.

### Task B2: The match screen passes presets; leftover string removed

**Files:**
- Modify: `lib/features/match/match_screen.dart` (`_openTactics`, ~line 1061), seven `.arb` files (delete `matchInstructionsLocked` and `@matchInstructionsLocked`)
- Test: `test/widget/match_presets_wiring_test.dart`

**Interfaces:**
- Consumes: `tacticPresetsProvider(careerId)` (`lib/features/tactics/tactic_preset_providers.dart`), `showInMatchTactics(presets:)` (B1).

- [ ] **Step 1: Write the failing test** `the match screen offers the save's presets`: seed a save, store one preset with `TacticPresetStore.save`, pump the match screen, open tactics (half-time prompt's tactics action), expect the preset tile after tapping `InMatchTacticsKeys.presetsButton`; apply it and Apply; expect the live tactics bar shows the preset's formation label.
- [ ] **Step 2: Run** it; expected FAIL.
- [ ] **Step 3: Implement**: `final presets = await ref.read(tacticPresetsProvider(widget.careerId).future);` before `showInMatchTactics`, passed through; it then flows to `_applyTactics` as any manual change. Delete the string from all `.arb` files, `flutter gen-l10n`, `dart run tool/export_copy.dart`.
- [ ] **Step 4: Run** the test, `flutter analyze`, and `grep -rn matchInstructionsLocked lib copy` (expected: no output); PASS.
- [ ] **Step 5: Commit** `feat(match): presets reachable during play and at every break`.

---

# Part C: Extra time responds to tactics

Decisions (Claude's, within the owner's choice):
- **Inside `play()`, not a continuation.** `MatchEngine.play` gains `bool extraTimeIfLevel = false`. After regulation stoppage, if the score is level and the flag is set, it plays minutes 91-120 with the same `playMinute` (changes, talks, subs fire on their minute; fatigue and AI management continue; `urgency` already clamps at 1). Regulation is untouched because extra time only consumes the stream after it. Every re-sim already replays from minute 1, so a continuation API would add state for nothing.
- **`homeScore`/`awayScore` stay the regulation score.** Every knockout path keys off "level after ninety"; the after-extra-time totals go in a new field. Extra-time events use real minutes 91-120 (stoppage events keep minute 90 with a stoppage index), so they are unambiguous.
- **The shootout is split out** of `decideKnockout` into `decideShootout`, called by `decideKnockout` after its extra-time loop with the same rng, so the background path stays byte-identical.

### Task C1: Engine plays extra time

**Files:**
- Modify: `lib/domain/services/match/match_engine.dart` (`play`, ~line 582; loop ~line 910; `MatchResult`, ~line 295)
- Test: `test/unit/match/extra_time_engine_test.dart`; move `team(int nationId, int rating)` from `test/unit/match/match_balance_test.dart` into `test/helpers/fixtures.dart` as `ratedTeam` and use it from both.

**Interfaces:**
- Produces:
  - `MatchResult.extraTime`: `final ({int homeScore, int awayScore})? extraTime;` (after-ET totals; null when not played)
  - `play({..., bool extraTimeIfLevel = false})`
  - `static const double extraTimeChanceFactor` on `MatchEngine` (tired legs; starts at 0.8, set by Task C2)
  - Per-minute series (`homeXgByMinute` etc.) have 121 entries when extra time was played, 91 otherwise.

- [ ] **Step 1: Write failing tests:**
  - `regulation is identical with or without the flag`: for 300 seeds, `homeScore`, `awayScore`, and events with `minute <= 90` are equal between `extraTimeIfLevel: false` and `true`.
  - `extra time only when level`: `extraTime != null` iff `homeScore == awayScore` with the flag on; always null with it off.
  - `extra-time goals carry minutes 91-120 and sum to the totals`: goal events with `minute > 90` per side equal `extraTime.homeScore - homeScore` (same for away).
  - `a change at minute 91 bites in extra time only`: same seed, one run with a `TacticalChange(minute: 91, instructions: mentality 100, …)` for home; regulation equal to the run without it; across 400 level seeds the changed side's ET goals total is higher (Review Focus 5).
  - `a substitution at 91 brings the player on`: `Substitution(minute: 91)` appears as an event at 91.
  - `series run to 120 when extra time is played`: `homeXgByMinute.length == 121`.
- [ ] **Step 2: Run** `flutter test test/unit/match/extra_time_engine_test.dart`; expected FAIL.
- [ ] **Step 3: Implement**: after the stoppage loop and its series fold, `if (extraTimeIfLevel && homeScore == awayScore)` run `for (minute = 91..120) playMinute(minute, 0)` with chance creation scaled by `extraTimeChanceFactor` for `minute > 90`, appending series points; compute ratings from the after-ET score; set `extraTime`.
- [ ] **Step 4: Run** the new file and `test/unit/match/` sequentially (`match_engine_test`, `match_balance_test`, `scoreline_distribution_test`, `tactics_*`); expected PASS, no balance guard moved.
- [ ] **Step 5: Commit** `feat(engine): opt-in extra time, minutes 91-120`.

### Task C2: Shootout split and calibration guard

**Files:**
- Modify: `lib/domain/services/competition/finals.dart` (`decideKnockout`, ~line 515)
- Modify: `lib/domain/services/match/ai_substitutions.dart`
- Test: `test/unit/match/extra_time_calibration_test.dart`, `test/unit/match/penalty_takers_test.dart` (must stay green)

**Interfaces:**
- Produces:
  - `static KnockoutOutcome decideShootout(int home, int away, SeededRng rng, {double homeStrength = 1, double awayStrength = 1, List<double> homeTakerSkill = const [], List<double> awayTakerSkill = const []})` (inputs: the level after-ET score)
  - `static Substitution? AiSubstitutions.planExtraTime({required int nationId, required List<Player> onPitchAt90, required List<Player> bench, required SeededRng rng})` (one sub at minute 91, drawn on `fixture.id ^ 0x5196`, so the regulation plan's stream is untouched)

- [ ] **Step 1: Write failing tests:**
  - `decideKnockout is unchanged`: for 500 seeds and three strength pairs, `decideKnockout` output equals a frozen copy of the current implementation pasted into the test as `_legacyDecideKnockout` (scores, kicks).
  - `extra time settles about a third of level ties`: 1,500 level-at-90 engine runs (`ratedTeam` 80 v 80 and 84 v 76, `extraTimeIfLevel: true`); share with `extraTime` not level is in `[0.25, 0.45]` and within `0.10` of the share `decideKnockout` gives for the same pairs with `RatingMatchSimulator.knockoutWeight`.
  - `the stronger side's edge is not inflated`: for 84 v 76, the stronger side's win share among ET-decided ties is at most its win share among decided 90-minute matches of the same pair `+ 0.05`.
- [ ] **Step 2: Run**; expected FAIL (`decideShootout` undefined; calibration unknown).
- [ ] **Step 3: Implement** `decideShootout` (body moved out of `decideKnockout`, which now calls it) and `planExtraTime`; tune `MatchEngine.extraTimeChanceFactor` until the guards pass. Record the final factor and both measured shares in the constant's doc comment.
- [ ] **Step 4: Run** the new file, `penalty_takers_test.dart`, `match_balance_test.dart`, `world_variance_test.dart`; expected PASS.
- [ ] **Step 5: Commit** `feat(engine): shootout split out; extra-time calibration guard`.

### Task C3: The live screen plays extra time through the engine

**Files:**
- Modify: `lib/features/match/match_providers.dart` (~line 427: pass `extraTimeIfLevel: Rounds.isKnockout(fixture.round)`), `lib/features/match/match_screen.dart`
- Test: `test/widget/live_extra_time_test.dart`, `test/widget/match_skip_shootout_test.dart` (must stay green)

**Interfaces:**
- Consumes: `play(extraTimeIfLevel:)`, `MatchResult.extraTime` (C1), `decideShootout`, `AiSubstitutions.planExtraTime` (C2).
- Produces: `const int kMaxSubsExtraTime = 6;` in `match_screen.dart` beside `kMaxSubs`.

Changes in `match_screen.dart`:
- `_resim` passes `extraTimeIfLevel: _isKnockoutFixture(preview.fixture)` and appends the AI's `planExtraTime` sub to `subs`.
- `_ensureKnockoutSetup` no longer locks at 90 and drops `_etGoals`/`_etEvents` synthesis; extra-time goals and the scoreline come from `r.events` with `minute > 90`, revealed by the clock like regulation events.
- `_knockoutOutcome`: when `r.extraTime` is level, `decideShootout` on `SeededRng.forFixture(_seed(preview), preview.fixture.id ^ 0x7F)` with the existing taker skills and composure; otherwise a `KnockoutOutcome(afterExtraTime: true, …)` from `r.extraTime`.
- The pre-extra-time talk becomes `TeamTalk(minute: 91, tone:)` in `_talks` (re-sim) instead of tilting `_extraTimeStrengths`; the turnaround talk keeps its shootout composure effect and is also `TeamTalk(minute: 106)`.
- `_openTactics` passes `maxSubs: _minute >= 90 && _isKnockoutFixture(...) ? kMaxSubsExtraTime : kMaxSubs`.
- Update the `_applyTactics` comment that says changes past 90 are inert.

- [ ] **Step 1: Write failing widget tests** (seed a save with a knockout fixture and a salt that ends level at 90; pattern from `match_skip_shootout_test.dart`):
  - `tactics at the 90' huddle change extra time`: two runs from the same seed, one applies a preset with mentality 100 at the huddle; the extra-time events differ and regulation events are identical.
  - `an extra substitution is allowed in extra time`: after five regulation subs, the editor at the huddle accepts a sixth.
  - `a knockout settled in ninety plays no extra time`: clock ends at 90 + stoppage.
  - `skip to full time on a level knockout reveals the engine's extra time` (Review Focus 4).
- [ ] **Step 2: Run** them; expected FAIL.
- [ ] **Step 3: Implement** the changes above.
- [ ] **Step 4: Run** the new file, `match_skip_shootout_test.dart`, `match_tablet_test.dart`, `match_stats_live_test.dart`, `preview_tactics_reach_kickoff_test.dart`, `test/unit/match/penalty_takers_test.dart`; expected PASS.
- [ ] **Step 5: Commit** `feat(match): extra time is played live and responds to tactics`.

### Task C4: Store what the screen showed

**Files:**
- Modify: `lib/features/hub/hub_providers.dart` (`_playPlayerMatch`, ~lines 1878-1925)
- Test: `test/unit/hub/extra_time_attribution_test.dart` (update), `test/unit/hub/live_extra_time_commit_test.dart`

**Interfaces:**
- Consumes: `MatchResult.extraTime`, `KnockoutOutcome` from the screen (C3).

- [ ] **Step 1: Write failing tests:**
  - `the stored score is the engine's after-extra-time score`: commit a `MatchResult` with `extraTime: (homeScore: 2, awayScore: 1)` and regulation 1-1 plus the matching `KnockoutOutcome`; stored fixture `2-1`, `afterExtraTime: true`, no penalties.
  - `extra-time goals are recorded once, with their real scorers`: goal rows for the fixture equal the engine's goal events (count and minutes); no extra `_attributeGoals` rows in 91-120.
  - `a shootout stores the winner one clear`: `extraTime` level 1-1, outcome with kicks; stored score and penalties match the outcome.
  - `a knockout without engine extra time keeps the old path`: `extraTime == null`, no `knockout` → `decideKnockout` draw as before (save compatibility for any caller that still passes a regulation-only result).
- [ ] **Step 2: Run** both files; expected FAIL.
- [ ] **Step 3: Implement**: when `result.extraTime != null`, skip both `_attributeGoals` calls (the engine's goal events already reach `recordGoals`) and take scores from `knockout` as today; leave the `knockout ?? decideKnockout(...)` fallback for `extraTime == null`.
- [ ] **Step 4: Run** both files, `test/unit/hub/skip_records_drilling_test.dart`, then the full suite `flutter test` once; expected all PASS.
- [ ] **Step 5: Commit** `fix(hub): a live knockout stores the extra time the manager watched`.

---

## Self-review notes

- Spec coverage: A goals 1-2 → A1-A3; "now" sections 1-5 → A1/A2; anti-goals (one helper, no stolen gestures, lists pass ids only) → A3 tests. B goals and behaviour (no subs, re-place, every break, sliders editable, no in-match saving, delete leftover string) → B1/B2. Live extra time bullets (two periods, changes from that minute, AI reacts, shootout unchanged, store what is shown, extra sub, calibration guard, saves) → C1-C4. Tests per spec "Constraints" → each task.
- Owner check: one extra substitution in extra time (spec's Claude's call), the AI side also gets one (`planExtraTime`).
