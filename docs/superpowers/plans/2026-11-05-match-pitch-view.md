# Match Pitch View Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** A free, switchable Pitch view of the live match. It shows a tilted stadium with 22 moving players and a ball, and stages every real moment the (now richer) match engine produced, in step with the clock and the commentary.

**Architecture:** There are three layers.

1. **Engine (domain).** `MatchEngine` gains a parallel, ordered `moments` list. It holds every shot, set piece, foul, offside, penalty and card with the players, zone and outcome. Existing `events` keep their meaning for every current consumer. The work runs in two passes:
   - **record-only pass:** a separate detail RNG stream; every existing outcome is byte-identical to today, proved by a golden;
   - **play pass:** real penalty awards and misses, and direct free kicks with a wall, recalibrated to the captured baseline.
2. **Pure-Dart staging (domain).**
   - A `PitchPacer` maps match time to screen time per speed.
   - A `PitchScript` builds keyframes for 22 players and the ball. Formation-anchored build-up runs between moments, and each moment type is staged from its data.
3. **Rendering (features).**
   - A perspective `PitchProjection`.
   - A cached static `StadiumPainter`: stands by capacity, crowd by attendance and away share, flags, landmark.
   - A per-frame actors painter.
   - A `PitchMatchView` that the existing match screen switches to on phone and tablet.

**Tech Stack:** Flutter/Dart, Riverpod 2.6.1 (no codegen), Drift, `CustomPainter`/`dart:ui` canvas, gen_l10n with the `copy/strings.csv` round trip.

**Spec:** `docs/superpowers/specs/2026-11-05-match-pitch-view-design.md`

## Global Constraints

- **Free.** There is no Pro gate on the Pitch view.
- **Release.** Ships in 1.1.0 alongside the database editor. Work on branch `feature/pitch-view` in worktree `../fnm26-pitch-view`.
- **One engine.** The engine plays the richer match for every view. Other views keep showing what they show today, and the Timeline keeps its current event types.
- **No invented outcomes.** The picture must agree exactly with the engine. The animation never decides an outcome.
- **Background matches.** `RatingMatchSimulator` is untouched, and so is its October calibration.
- **Duration.** A full 90 minutes takes 180–240 s on screen at the slowest speed, 120–180 s at the middle speed and 60–120 s at the fastest. The figure depends on how eventful the match is, and real moments are never rushed.
- **Minor moments.** Routine throw-ins, inconsequential fouls and goal kicks flow on with no stop and no commentary line. Shots, corners, dangerous free kicks, penalties, cards, long throws into the box, attack-ending offsides, injuries and subs are staged in full.
- **Commentary.** Real moments only, several wordings each, in all 28 languages.
- **Performance.** 60 fps on a Galaxy A56 at phone size, and never below 30 fps on weaker supported phones. The static stadium and crowd are cached.
- **Look.**
  - The "Pro Pitch Executive" dark theme: `AppColors`, `AppTypography`, `AppRadii`, and the app's disc style.
  - No arcade look, and nothing copied from the reference video.
  - No real players, kits, crests or brand logos. Landmarks are generic silhouettes drawn in code, with no image files.
- **Saves.** Saves stay compatible. Already played matches keep their stored results. Any schema change follows the stepwise migration recipe.
- **Determinism.**
  - The match stays deterministic within an attempt, and tactics changes land at minute+1.
  - Animation randomness is seeded from the match seed plus the moment index, never from the engine's streams.
- **Copy.** No em dashes in user-facing copy, and never "World Cup" in English copy.
- **Tooling.**
  - Riverpod without codegen.
  - `dart run build_runner build --delete-conflicting-outputs --force-jit`.
  - Never run two flutter processes at once (this includes the editor's worktree). Wrap runs in `caffeinate -dimsu` and `timeout`.
  - Never `dart format lib`; format only the files you touch.
- **Visual gate.** Task 11 ends with an owner sign-off of a static stadium mock. Tasks 12+ do not start until the owner approves.

## Review Focus

1. **A tactics change or sub mid-match.** The engine re-simulates from minute 1, so the script must rebuild from the current minute with no jump. Already-watched moments are unchanged and the players on screen match the new XI. Test in Task 15.
2. **A red card or injury leaving a side with 10 (or 9).** That side's shape re-forms with the right count, the player walks off and never reappears, and a substitution swaps the right player out using the new `offPlayerId`. Test in Task 8.
3. **Switching Pitch ⇄ Timeline mid-match, including during a moment, at half-time and in extra time.** The clock, score and commentary stay exactly in step, and no event is shown twice or skipped. Test in Task 15.
4. **Stoppage time and extra time.** "90+X" moments and minutes 91–120 are staged and paced, and the pacer budget still holds for a 120-minute match: it is scaled by 120/90 and does not overrun. Test in Task 7.
5. **Clashing and similar kits.** Two nations with near-identical primary colours, or a white-on-white clash, must stay distinguishable on the pitch, and the crowd split must still read. Test in Task 10.

---

## File Structure

**Domain: engine**
- `lib/domain/services/match/match_moments.dart`: the `MatchMoment` model.
- `lib/domain/services/match/match_engine.dart`: records and plays moments.
- `test/fixtures/match_baseline.json`: the baseline figures and event golden.

**Domain: staging (pure Dart, no Flutter imports)**
- `lib/domain/services/match/pitch/pitch_geometry.dart`: pitch coordinates and zones.
- `lib/domain/services/match/pitch/pitch_pacer.dart`
- `lib/domain/services/match/pitch/pitch_script.dart`: keyframes and sampling.
- `lib/domain/services/match/pitch/story_layer.dart`: build-up between moments.
- `lib/domain/services/match/pitch/moment_staging.dart`: one stager per moment type.

**Domain: stadium**
- `lib/domain/services/match/stadium/stadium_spec.dart`
- `lib/domain/services/match/stadium/away_fan_share.dart`
- `lib/domain/services/match/stadium/landmarks.dart`

**Core**
- `lib/core/theme/kit_colors.dart`: gains `KitClash`.

**Features: Pitch view**
- `lib/features/match/pitch/pitch_projection.dart`
- `lib/features/match/pitch/stadium_painter.dart`
- `lib/features/match/pitch/crowd_painter.dart`
- `lib/features/match/pitch/landmark_painter.dart`
- `lib/features/match/pitch/actors_painter.dart`
- `lib/features/match/pitch/pitch_match_view.dart`
- `lib/features/match/pitch/pitch_view_providers.dart`
- `lib/features/match/pitch/pitch_commentary.dart`

**Features: existing files that change**
- `lib/features/match/match_screen.dart`, `match_tablet_layout.dart` and `match_panels.dart`: mode choice, switch and clock drive.

---

### Task 1: Baseline capture and the "unchanged outcomes" golden

**Files:**
- Create: `test/unit/match/match_baseline_test.dart`
- Create: `tool/capture_match_baseline.dart`, which writes `test/fixtures/match_baseline.json`.

**Interfaces:**
- **Produces:** `test/fixtures/match_baseline.json` = `{figures: {...}, golden: [...]}`.
  - The `figures` are measured with today's engine over the matrix below. Every value is per match:
    - goals per match;
    - home win, draw and away win shares;
    - favourite win share;
    - rout share;
    - penalty-goal share;
    - set-piece-goal share;
    - long-throw-goal share;
    - yellows per match;
    - reds per match;
    - injuries per match;
    - shots per match;
    - xG per match;
    - mean stoppage.
  - The matrix: rating pairs (70,70), (78,70), (85,70), (85,85) and (70,85). Each pair is played 600 times, neutral and at home, with `SeededRng.forFixture(0xBA5E, i)`.
  - The `golden`: for 200 seeded matches (`forFixture(0x601D, i)`, pair (78,74)), the full `events` list serialised as `minute|stoppage|type|team|player|assist|penalty|setPiece|longThrow|secondYellow`, plus `homeShotsByMinute`, `awayShotsByMinute`, `homeXgByMinute` rounded to 1e-6, possession and ratings.

- [ ] **Step 1:** Write `tool/capture_match_baseline.dart`. Run it on the current engine. Commit the JSON it produces.
- [ ] **Step 2: Write the tests.**
  - `the engine still produces the golden`: replays the 200 golden matches and asserts equality.
  - `figures stay near baseline`: re-measures, and asserts each figure is within its band.
    - Bands: goals ±4%; win, draw and favourite shares ±3 percentage points; penalty-goal share ±1.5 points; cards ±8%; shots ±6%.
- [ ] **Step 3: Run.** Expected: PASS, since the code is unchanged.
- [ ] **Step 4: Commit** `test(match): baseline figures and outcome golden before the pitch view`.

### Task 2: `MatchMoment` model and shots (record-only)

**Files:**
- Create: `lib/domain/services/match/match_moments.dart`
- Modify: `match_engine.dart`, which gains a `moments` field on `MatchResult` and records shots.
- Test: `test/unit/match/match_moments_shots_test.dart`

**Interfaces:**
- **Produces:**
  - Zones: `enum PitchZone { boxCentre, boxLeft, boxRight, sixYard, edgeOfBox, longRange, wideLeft, wideRight }`.
  - Shot outcomes: `enum ShotOutcome { goal, saved, wide, blocked, woodwork }`.
  - The base class:

    ```dart
    sealed class MatchMoment {
      int get minute;
      int get stoppage;
      int get seq;          // order within the minute, 0-based
      int get teamNationId;
    }
    ```

  - `final class ShotMoment extends MatchMoment` has:
    - `int shooterId`, `int? assistId`, `int? keeperId`;
    - `PitchZone zone`, `double xg`, `ShotOutcome outcome`;
    - `bool header`;
    - `ShotOrigin origin`: one of `openPlay`, `corner`, `freeKickCross`, `directFreeKick`, `penalty`, `longThrow`;
    - `int? goalEventIndex`: the index into `events` when `outcome == goal`.
  - `MatchResult.moments`: `List<MatchMoment>` ordered by `(minute, stoppage, seq)`. It defaults to `const []`.
- **Determinism:** non-goal detail (shooter, keeper, zone, outcome) is drawn from a NEW stream, `detailRng = rng.fork(0xD7A1)`, forked after the existing four. Existing streams consume exactly as before.

- [ ] **Step 1: Write the tests.**
  - `the shot moments add up to the shot counts`: for each minute, the count of team shots equals the delta of `homeShotsByMinute`/`awayShotsByMinute`.
  - `every goal has exactly one goal shot pointing at it`: `goalEventIndex` matches, and so do the shooter and assist ids.
  - `sum of moment xg equals homeXg within 1e-6`.
  - `golden still holds`: the Task 1 golden test, re-run.
- [ ] **Step 2: Run.** Expected: FAIL.
- [ ] **Step 3: Implement.**
  - Where the engine rolls an open-play chance (around ME:904–985), keep the chance's existing values (`baseP`, the shooter pick, the xG) and append a `ShotMoment`.
  - The shooter for a non-goal comes from `_pickScorer` run on `detailRng`. The keeper is the defending XI's keeper. The zone comes from the xG band.
- [ ] **Step 4: Run** the new tests, the golden, and `test/unit/match/`. Expected: PASS, with the golden unchanged.
- [ ] **Step 5: Commit** `feat(match): the engine records every shot`.

### Task 3: Set pieces, fouls, offsides, subs (record-only)

**Files:**
- Modify: `match_moments.dart` and `match_engine.dart`.
- Test: `test/unit/match/match_moments_setpieces_test.dart`

**Interfaces:**
- **Produces:**
  - `SetPieceMoment` with:
    - `SetPieceKind kind`, one of `corner`, `freeKick`, `longThrow`, `throwIn`, `goalKick`;
    - `int takerId`, `bool left`, `PitchZone zone`;
    - `bool routine`. When `routine` is true the moment is flow-only: no staging stop and no commentary.
  - `FoulMoment` with `int foulerId`, `int fouledId`, `PitchZone zone`, `int? cardEventIndex` and `bool advantage`.
  - `OffsideMoment` with `int playerId` and `bool endsAttack`.
  - `SubMoment` with `int onId`, `int offId` and `int eventIndex`.
  - `MatchEvent` gains `int? secondaryPlayerId`, the id of the player going off. It is set wherever `secondaryName` is set.
  - `MatchResult.routineRestarts`: `List<int>`, the per-minute count of routine throw-ins and goal kicks. These are not individual moments.
- **Rules:**
  - Every card has a foul moment before it in the same minute.
  - Every set-piece goal and long-throw goal has a `SetPieceMoment` before its `ShotMoment`.
  - Corners and free kicks that come to nothing are recorded at plausible rates: about 10 corners, 20–25 fouls and 3–5 offsides per match.
  - All of this is drawn on `detailRng`, so outcomes are unchanged.

- [ ] **Step 1: Write the tests.**
  - `every card follows a foul by the carded player`.
  - `every set-piece goal follows its corner or free kick with the assister as taker`.
  - `rates: corners 8–12, fouls 18–28, offsides 2–6 per match over 600 matches`.
  - `sub moments carry the off player's id`.
  - `golden still holds`.
- [ ] **Step 2: Run.** Expected: FAIL.
- [ ] **Step 3: Implement.**
- [ ] **Step 4: Run** the tests and `test/unit/match/`. Expected: PASS, golden unchanged.
- [ ] **Step 5: Commit** `feat(match): the engine records set pieces, fouls, offsides and subs`.

### Task 4: Play pass: real penalties and direct free kicks, recalibrated

**Files:**
- Modify: `match_engine.dart`.
- Test: `test/unit/match/match_play_pass_test.dart`. Also update the Task 1 golden in place: regenerate it with the tool, and justify the change in the commit.

**Interfaces:**
- **Penalties.** The 9% goal relabel (ME:1738) is removed. Instead a foul in `boxCentre`, `boxLeft` or `boxRight` can award a penalty: a `FoulMoment` followed by a `ShotMoment(origin: penalty)`.
  - The outcome comes from the taker's penalty skill (`penalty_takers.dart`) against the keeper. Target rates: about 76% scored, about 17% saved, about 7% wide or woodwork.
- **Direct free kicks.** A foul in `edgeOfBox` can lead to a `ShotMoment(origin: directFreeKick)`, which can be blocked by the wall. Target: about 7% of direct free kicks scored.
- **New streams.** Penalties and free kicks use new RNG streams, `rng.fork(0xF0E1)`.
- **Recalibration.** Tune only the new award rates and the existing open-play chance base. The Task 1 `figures stay near baseline` test must pass. The penalty-goal share must stay within ±1.5 points of the baseline.
- **Unchanged guards.** `match_balance_test`, `skip_parity_test` (skip vs play goals ratio `closeTo(1, 0.15)`), `scoreline_distribution_test`, `discipline_rates_test` and `extra_time_calibration_test` must stay green without loosening their bounds.

- [ ] **Step 1: Write the tests.**
  - `a penalty can be missed or saved`: over 600 matches, missed plus saved is at least 15% of penalties.
  - `every penalty follows a foul in the box`.
  - `a direct free kick can hit the wall`.
  - `figures stay near baseline`, from Task 1.
- [ ] **Step 2: Run.** Expected: FAIL.
- [ ] **Step 3: Implement and tune.** Record each tuning run's figures in the commit message body.
- [ ] **Step 4: Run** all of `test/unit/match/`, `test/story/` and `test/unit/competition/`. Expected: PASS.
- [ ] **Step 5: Commit** `feat(match): penalties are awarded and can be missed; free kicks can hit the wall`.

### Task 5: Shootout detail

**Files:**
- Modify: `lib/domain/services/competition/finals.dart` (`KnockoutOutcome`, `decideShootout`).
- Test: `test/unit/competition/shootout_detail_test.dart`

**Interfaces:**
- **Produces:** `KnockoutOutcome` gains `List<ShootoutKick> homeDetail` and `List<ShootoutKick> awayDetail`.
  - `ShootoutKick` has:
    - `int takerId`;
    - `KickResult result`, one of `scored`, `saved`, `wide`, `post`;
    - `int lane`: 0–5, the goal grid left/centre/right × low/high;
    - `int diveLane`: 0–5.
  - The existing `homeKicks`/`awayKicks` bools are unchanged and are drawn exactly as before.
  - The detail comes from a fork, `rng.fork(0x5407)`, taken after them.
- **Consistency:** `scored` ⇔ the bool is true. A save means `diveLane == lane`. A goal means `diveLane != lane`, or the shot was struck high to a corner.

- [ ] **Step 1: Write the tests.**
  - `shootout results are unchanged`, against a golden of 200 shootouts.
  - `detail agrees with the bools`.
  - `takers follow the given order`.
- [ ] **Step 2: Run.** Expected: FAIL.
- [ ] **Step 3: Implement.**
- [ ] **Step 4: Run** the tests and `test/unit/competition/`. Expected: PASS.
- [ ] **Step 5: Commit** `feat(match): shootout kicks record taker, lane and dive`.

### Task 6: Stats and ratings read the richer match

**Files:**
- Modify:
  - `match_engine.dart`: ratings.
  - `lib/features/match/match_panels.dart`: Stats tab totals.
  - wherever shots or xG totals are read for post-match stats (grep `homeShots`, `homeXg`).
- Test: `test/unit/match/moment_stats_test.dart`

**Interfaces:**
- `MatchResult.homeShots`/`awayShots`/`homeXg`/`awayXg` equal the sums over `moments`.
- A missed or saved penalty lowers the taker's rating by 0.4.
- A penalty save raises the keeper's rating by 0.5.
- The Timeline (`_Timeline`) is unchanged.
- Achievements, press and stats change only where they already read shots or penalties. List each site in the report.

- [ ] **Step 1: Write the tests.**
  - `totals equal moment sums`.
  - `missed penalty lowers the taker's rating; save lifts the keeper`.
  - `timeline shows the same rows as before for a match without penalties`.
- [ ] **Step 2: Run.** Expected: FAIL.
- [ ] **Step 3: Implement.**
- [ ] **Step 4: Run** `test/unit/match/`, `test/widget/*match*` and `test/unit/records/`. Expected: PASS.
- [ ] **Step 5: Commit** `feat(match): stats and ratings follow the recorded shots and penalties`.

### Task 7: `PitchPacer`

**Files:**
- Create: `lib/domain/services/match/pitch/pitch_pacer.dart`
- Test: `test/unit/pitch/pitch_pacer_test.dart`

**Interfaces:**
- **Produces:**

  ```dart
  enum PitchSpeed { slow, mid, fast }

  class PitchPacer {
    PitchPacer(MatchResult r, PitchSpeed speed);
    Duration get total;                       // screen duration of the whole match incl. stoppage/ET
    Duration screenAt(int minute, int stoppage, {double within = 0});
    ({int minute, int stoppage, double within}) matchAt(Duration screen);
    Duration momentLength(MatchMoment m);     // fixed per type, speed-independent
  }
  ```

- **Budgets per 90 minutes:**
  - `slow`: 180–240 s;
  - `mid`: 120–180 s;
  - `fast`: 60–120 s.
- **Eventfulness.** Position inside a band is `clamp(stagedMoments / 40, 0, 1)`: more staged moments means nearer the upper bound.
- **Stoppage and extra time.** Both scale the budget by `(90 + stoppage + et) / 90`.
- **Staged moment lengths.** Real moments are never compressed:
  - shot 3.5 s;
  - corner 6 s;
  - free kick 6 s;
  - penalty 7 s;
  - card 3 s;
  - sub 2.5 s;
  - offside 2.5 s;
  - injury 3 s;
  - goal adds 2.5 s.
- **Quiet time** fills the remainder evenly per minute, with at least 0.25 s per quiet minute.
- **When moments alone exceed the budget**, quiet time drops to that minimum and the total may exceed the upper bound by at most 15%. Test this.

- [ ] **Step 1: Write the tests.**
  - `a quiet 0-0 lands in each band's lower half`.
  - `a 4-3 lands in the upper half`.
  - `screenAt and matchAt invert`.
  - `moments never shorter than their fixed length`.
  - `120-minute match scales and holds`.
  - `overflow capped at 15%`.
- [ ] **Step 2: Run.** Expected: FAIL.
- [ ] **Step 3: Implement.**
- [ ] **Step 4: Run.** Expected: PASS.
- [ ] **Step 5: Commit** `feat(pitch): pacing of a match on screen`.

### Task 8: Pitch geometry and story layer

**Files:**
- Create: `pitch_geometry.dart`, `pitch_script.dart`, `story_layer.dart` (under `lib/domain/services/match/pitch/`)
- Test: `test/unit/pitch/story_layer_test.dart`

**Interfaces:**
- **Produces:**
  - **Pitch units.** Metres, x 0..105 (home attacks +x in the first half), y 0..68.
  - **`PitchActor`:** `({int playerId, int teamNationId, int shirt, bool keeper})`.
  - **`MatchLineups`:** `({TeamSide home, TeamSide away})`, where `TeamSide = ({int nationId, Formation formation, List<({int playerId, PlayerPosition slot, int shirt})> xi, List<int> bench, TacticalInstructions instructions, MatchPlan plan})`. It is built in `pitch_view_providers.dart` from the `MatchPreview` the screen already pins.
  - **`PitchScript`:**
    - `actors()` returns the actors on the pitch at a match time;
    - `sample(Duration screen)` returns `PitchFrame`;
    - `PitchFrame` has `Map<int, Offset2> players`, `Offset2 ball`, `double ballHeight`, `int? ballCarrierId`, `List<int> tagged` (name-tag ids) and `PitchCamera camera`;
    - `PitchCamera` has `({double centreX, double zoom})`.
  - **`StoryLayer.build`:**

    ```dart
    StoryLayer.build({
      required MatchResult result,
      required MatchLineups lineups,       // both XIs with formation slots, tactics (width, line, press, tempo)
      required PitchPacer pacer,
      required int seed,
    }) -> PitchScript
    ```

    It covers quiet time only. Moments are left as gaps that Task 9 fills.
- **Anchoring.**
  - Formation slot coordinates come from `tactics_pitch.dart` `layoutOf` and `adjustedSlotY`, converted to metres. The opponent uses its own plan's formation, mirrored.
  - Shape shifts with ball position: block compactness, line height from tactics, and width from `instructions.width`.
  - Possession share drives the ball-time split. Momentum biases territory.
- **Invariants, enforced by a validator used in tests:**
  - player speed ≤ 9 m/s;
  - ball speed ≤ 35 m/s;
  - no two players closer than 0.8 m;
  - keepers stay within 25 m of their goal line in open play;
  - at most 11 per side;
  - sent-off, injured-off and subbed-off players are absent after their minute and walk off over 2 s;
  - the ball is always with a carrier or in flight between two points;
  - the ball never teleports.

- [ ] **Step 1: Write the tests.**
  - `quiet time obeys every invariant over 50 seeded matches`.
  - `a red card leaves the side with 10 and the shape re-forms`.
  - `a sub swaps the right player`.
  - `the same seed gives the same frames`.
  - `possession 60% gives the home side about 60% of ball time (±7)`.
- [ ] **Step 2: Run.** Expected: FAIL.
- [ ] **Step 3: Implement.**
- [ ] **Step 4: Run.** Expected: PASS.
- [ ] **Step 5: Commit** `feat(pitch): formation-anchored build-up between moments`.

### Task 9: Moment staging

**Files:**
- Create: `lib/domain/services/match/pitch/moment_staging.dart`
- Test: `test/unit/pitch/moment_staging_test.dart`

**Interfaces:**
- **Produces:** `abstract interface class MomentStager { void stage(MatchMoment m, StagingContext c); }`, with one stager per moment type:
  - shot, by origin;
  - corner (from the correct side, `left`);
  - free kick (wall of 3–5 at 9.15 m, when direct);
  - penalty (players outside the box, keeper on the line);
  - long throw;
  - foul plus card (play stops, then the referee);
  - offside (flag, restart from the right place);
  - sub (touchline);
  - injury.

  `StoryLayer.build` calls the stagers for every non-routine moment. Routine restarts become a 1 s flow restart from the right place.
- **Outcome geometry:**
  - a goal ends in the net;
  - a save ends in the keeper's hands, or parried wide;
  - a wide shot misses outside the post;
  - woodwork hits the post or bar;
  - a blocked shot is stopped by a defender within 3 m.
- **Players on screen:**
  - the shooter, assister, taker, fouler, fouled player and keeper are the moment's recorded ids;
  - they are added to `tagged` for the moment's duration;
  - a goal can never be offside: the attackers are onside at the pass.

- [ ] **Step 1: Write the tests.** For each moment type, over 200 seeded matches:
  - the right players act;
  - the outcome geometry matches the outcome;
  - invariants hold;
  - a corner comes from the side `left` says;
  - the wall is 9.15 m away;
  - a goal is onside.
- [ ] **Step 2: Run.** Expected: FAIL.
- [ ] **Step 3: Implement.**
- [ ] **Step 4: Run.** Expected: PASS.
- [ ] **Step 5: Commit** `feat(pitch): every real moment is staged from its data`.

### Task 10: Projection, stadium spec, away fans, kit clash

**Files:**
- Create:
  - `lib/features/match/pitch/pitch_projection.dart`;
  - `lib/domain/services/match/stadium/stadium_spec.dart`;
  - `away_fan_share.dart`.
- Modify: `lib/core/theme/kit_colors.dart`.
- Test: `test/unit/pitch/stadium_spec_test.dart`, `test/unit/pitch/kit_clash_test.dart`, `test/unit/pitch/projection_test.dart`

**Interfaces:**
- **`PitchProjection(Size viewport, PitchCamera cam, {double tilt = 0.55})`:**
  - `Offset toScreen(double x, double y, [double z = 0])`;
  - `double scaleAt(double y)`, which shrinks with depth.
  - The far touchline is drawn narrower than the near one.
- **`StadiumSpec.from(MatchGround g, Nation home, Nation away, double awayShare)`:**
  - `tiers`: 1 if capacity < 15000, 2 if < 45000, otherwise 3;
  - `openCorners = tiers == 1`;
  - `fill = attendance / capacity`;
  - `homeColour` and `awayColour` come from `KitClash`;
  - `awayShare`;
  - `flagCode = groundNation.code`;
  - `landmark = Landmarks.forCity(g.city)`.
- **`AwayFanShare.estimate({required Nation home, required Nation away, required bool neutral, required bool tournament, required double distanceKm})`:**
  - range 0.03–0.45;
  - a neighbour (< 800 km) gets +;
  - a big travelling nation (ranking top 20) gets +;
  - a tournament gets +;
  - a neutral ground splits roughly by following, 0.35–0.65.
- **`KitClash.resolve(Nation home, Nation away) -> ({KitPair home, KitPair away})`:**
  - Delta E (CIE76) between the primaries < 25, or both near-white or both near-black, means the away side wears a change kit built from its secondary colour.
  - If that still clashes, it uses `AppColors`'s neutral change kit.

- [ ] **Step 1: Write the tests.**
  - `capacity 12000 → one tier, open corners`.
  - `80000 → three tiers`.
  - `fill follows attendance`.
  - `neighbours bring more away fans than long-haul`.
  - `white vs white clashes and resolves`.
  - `similar reds resolve` (Review Focus 5).
  - `projection maps the four corners into the viewport and preserves left/right`.
- [ ] **Step 2: Run.** Expected: FAIL.
- [ ] **Step 3: Implement.**
- [ ] **Step 4: Run.** Expected: PASS.
- [ ] **Step 5: Commit** `feat(pitch): stadium spec, away fans and kit clash`.

### Task 11: Static stadium painter and the owner's mock (GATE)

**Files:**
- Create: `lib/features/match/pitch/stadium_painter.dart`
- Create: `test/golden/pitch_mock_test.dart`, which writes goldens into `test/golden/goldens/pitch_mock_*.png`.

**Interfaces:**
- **Produces:**
  - `class StadiumPainter extends CustomPainter { StadiumPainter(StadiumSpec s, PitchProjection p); }`. It draws the following, in the app palette:
    - the pitch with stripes;
    - the lines (penalty arcs, spots, centre circle);
    - the goals with nets;
    - stands by tiers;
    - ad boards in neutral FNM tones with no brands;
    - the home flags on the stand roofs.
  - `Future<ui.Image> StadiumPainter.bake(Size size)`: renders once to an image for caching.
- **The mock:** four goldens, each with static player discs in kick-off positions (`TacticsPitch` disc style) and the crowd as a flat placeholder colour band:
  - phone, small ground (8,000);
  - phone, big ground (80,000);
  - tablet, small;
  - tablet, big.

- [ ] **Step 1: Write the golden test** with the four cases.
- [ ] **Step 2: Implement** the painter until it looks right.
- [ ] **Step 3: Generate the goldens.** Commit them as `feat(pitch): static stadium mock for sign-off`.
- [ ] **Step 4: GATE.** The controller publishes the four PNGs to the owner and STOPS. Tasks 12+ start only after the owner approves the look. Any requested changes are made here and re-shown.

### Task 12: Crowd, flags, landmarks

**Files:**
- Create: `crowd_painter.dart` and `landmark_painter.dart` (under `lib/features/match/pitch/`), plus `lib/domain/services/match/stadium/landmarks.dart`.
- Test: `test/unit/pitch/landmarks_test.dart`; add cases to `test/golden/pitch_mock_test.dart`.

**Interfaces:**
- **`enum LandmarkKind { none, eiffel, colosseum, bigBen, christRedeemer, stBasil, ... }`**, about 30 kinds. `Landmarks.forCity(String city) -> LandmarkKind` uses a case-insensitive, accent-folded name table.
  - Cities without a landmark get `none`, which draws a generic skyline or hills chosen by a hash of the city.
- **Crowd:**
  - Dots per stand section, with density = `fill`.
  - Colour: the share `awayShare` (in the away end, or mixed on a neutral ground) uses the away colour; the rest uses the home colour, with 15% neutral clothing.
  - Positions are jittered by a seeded hash, so there is no visible repetition.
  - The crowd is baked into the stadium image.
- **Flags:** `CountryFlag` SVGs rasterised once to small images, then placed on the roofs.
- **Landmark:** a path silhouette behind the far stand. It is taller when `tiers == 1`.

- [ ] **Step 1: Write the tests.**
  - `Paris → eiffel, Roma/Rome → colosseum, London → bigBen, Rio de Janeiro → christRedeemer`.
  - `unknown city → none`.
  - `30 kinds each have a path`.
  - Goldens: Paris big ground, a small ground at 30% fill, a neutral venue split.
- [ ] **Step 2: Run.** Expected: FAIL.
- [ ] **Step 3: Implement.**
- [ ] **Step 4: Run.** Expected: PASS. Have the controller show the new goldens to the owner, without a gate.
- [ ] **Step 5: Commit** `feat(pitch): crowd in team colours, flags and landmarks`.

### Task 13: Actors painter and `PitchMatchView`

**Files:**
- Create: `actors_painter.dart`, `pitch_match_view.dart` and `pitch_view_providers.dart` (under `lib/features/match/pitch/`)
- Test: `test/widget/pitch_match_view_test.dart`, `test/unit/pitch/frame_budget_test.dart`

**Interfaces:**
- **Produces:**
  - `class PitchMatchView extends ConsumerStatefulWidget { const PitchMatchView({required this.script, required this.stadium, required this.clock}); }`.
  - `PitchClock`, a `ValueListenable<Duration>` driven by a `Ticker`. It exposes `play()`, `pause()`, `seekToMatch(minute, stoppage)` and `speed`.
- **The players:** discs in the app's disc style, drawn with `scaleAt` for depth.
  - Fills come from the `KitClash` pair; shirt numbers are inside the discs.
  - Name tags show for `tagged` ids, using `AppTypography` label styles on a pill.
- **The ball:** drawn with a shadow and lifted by `ballHeight`.
- **Caching:** the stadium is a cached `ui.Image`, so only the actors repaint each frame.
- **Frame budget:** sampling plus painting one frame must take ≤ 4 ms on the test machine (a proxy for 60 fps on an A56).

- [ ] **Step 1: Write the tests.**
  - `renders a frame for every second of a match without exceptions`.
  - `tagged players show their names`.
  - `frame budget ≤ 4 ms averaged over 600 frames`.
  - `stadium image is built once`.
- [ ] **Step 2: Run.** Expected: FAIL.
- [ ] **Step 3: Implement.**
- [ ] **Step 4: Run.** Expected: PASS.
- [ ] **Step 5: Commit** `feat(pitch): players and ball drawn over the cached stadium`.

### Task 14: Commentary for real moments

**Files:**
- Create: `lib/features/match/pitch/pitch_commentary.dart`
- Modify: `lib/l10n/app_en.arb` and `app_cs.arb` through the normal workflow.
- Test: `test/unit/pitch/pitch_commentary_test.dart`

**Interfaces:**
- **Produces:** `String? pitchLine(AppLocalizations l, MatchMoment m, Map<int, String> names, int seed)`. It returns null for routine moments. `names` maps player id to the display name the match screen already uses.
  - It picks variant `seed ^ m.seq ^ m.minute` mod the number of variants.
  - Keys are `pitchCom<Type><Outcome><n>`. Each staged (moment type, outcome) pair has at least 3 variants.
  - Covered: shots by outcome and origin, corner, free kick, penalty awarded, scored, saved and missed, foul plus yellow or red, offside, sub, injury.
- **Names:** placeholders `{player}`, `{other}` and `{keeper}`. Names come from the career, including world-pack names.
- **Line timing:** each line shows when its moment starts. A goal line also shows the score.

- [ ] **Step 1: Write the tests.**
  - `every staged moment kind has ≥3 variants in en and cs`.
  - `same seed same line`.
  - `no em dashes`.
  - `no "World Cup"`.
  - `routine moments return null`.
- [ ] **Step 2: Run.** Expected: FAIL.
- [ ] **Step 3: Implement.**
- [ ] **Step 4: Run** the tests and `test/unit/l10n`. Expected: PASS.
- [ ] **Step 5: Commit** `feat(pitch): commentary for every real moment`.

### Task 14b: Tactical style in movement (owner addition, spec item 14)

**Files:**
- Modify: `story_layer/*`, `moment_staging/*`, `match_engine.dart` (record AI instruction drift, outcomes untouched)
- Test: `test/unit/pitch/tactical_style_test.dart`

**Interfaces:**
- `MatchResult.instructionLog`: a list of `({int minute, int teamNationId, TacticalInstructions instr})`. In memory only.
- Each `TeamSide`'s instructions are followed per minute through the log.

- [ ] **Step 1: Write the tests.** Each one runs over 100 matches:
  - `high press: the defending side's mean depth is ≥ 8 m higher than a low block's`;
  - `direct sides average longer passes than patient ones (≥ 30%)`;
  - `counter sides reach the opponent's third faster after a turnover`;
  - `overlapping full-backs pass their winger's line in possession`;
  - `a false nine drops ≥ 10 m deeper than a target man`;
  - `AI drift changes the picture from the minute after it happens`;
  - `goldens unchanged`, `every Ruling 9 class still 0`, `validator 0`.
- [ ] **Step 2: Run them.** Expected: FAIL.
- [ ] **Step 3: Implement.**
- [ ] **Step 4: Run them.** Expected: PASS.
- [ ] **Step 5: Commit** `feat(pitch): tactics show in the play`.

### Task 15: Phone integration in the match screen

**Files:**
- Modify: `lib/features/match/match_screen.dart` and `match_panels.dart`.
- Modify: `pitch_view_providers.dart`, adding `matchViewModeProvider`, persisted in SharedPreferences per device.
- Test: `test/widget/pitch_mode_test.dart`

**Interfaces:**
- **`enum MatchViewMode { pitch, timeline }`.**
  - Before kick-off, the Timeline area shows a two-option choice, Pitch or Timeline. It is remembered for the next match.
  - A switch in the match header changes the mode at any time.
- **Pitch mode:**
  - The `PitchClock` drives the screen's `_minute` and `_stoppage` through `pacer.matchAt`.
  - It replaces the 360 ms tick, which Timeline mode keeps as today.
  - Existing pauses must behave identically: goal flash, injury pause, half-time and ET talks, tactics and subs.
  - The speed buttons map 1/2/3 to slow, mid and fast.
- **Phone layout in Pitch mode, top to bottom:**
  - the scoreboard;
  - the pitch;
  - one commentary line;
  - the momentum bar;
  - the controls;
  - the Stats and Lineups tabs;
  - the bottom bar unchanged.
- **Tactics change or sub mid-match:**
  - `_resim` produces a new result;
  - the script is rebuilt with the same seed;
  - the clock seeks to the current minute;
  - frames for minutes already watched may differ, but the clock never jumps backwards and the score never changes.

- [ ] **Step 1: Write the tests.**
  - `choose Pitch before kick-off and the pitch shows`.
  - `switching mid-match keeps minute, score and visible events identical` (Review Focus 3, including at half-time and in ET).
  - `a sub mid-match rebuilds the script at the current minute` (Review Focus 1).
  - `goal flash and injury pause still fire in Pitch mode`.
  - `the choice is remembered`.
- [ ] **Step 2: Run.** Expected: FAIL.
- [ ] **Step 3: Implement.**
- [ ] **Step 4: Run** the tests, `test/widget/*match*`, `match_screen_keeps_its_own_fixture_test` and `test/golden/` match goldens. Expected: PASS, with Timeline-mode goldens unchanged.
- [ ] **Step 5: Commit** `feat(pitch): watch the match on the pitch`.

### Task 16: Tablet layout

**Files:**
- Modify: `lib/features/match/match_tablet_layout.dart`.
- Test: `test/widget/pitch_tablet_test.dart`, plus both tablet sweeps.

**Interfaces:**
- **Pitch mode on tablet:**
  - the centre column becomes the large pitch;
  - the left column shows live stats and momentum;
  - the right column shows both line-ups and the full commentary feed (every staged moment's line so far, newest first).
- **Timeline mode:** stays exactly as today.

- [ ] **Step 1: Write the tests.**
  - `kTabletSizes render without overflow in Pitch mode`.
  - `commentary feed lists lines in order`.
  - `Timeline mode golden unchanged`.
- [ ] **Step 2: Run.** Expected: FAIL.
- [ ] **Step 3: Implement.**
- [ ] **Step 4: Run.** Expected: PASS.
- [ ] **Step 5: Commit** `feat(pitch): tablet pitch with stats, line-ups and commentary`.

### Task 17: Shootout on the pitch

**Files:**
- Modify: `moment_staging.dart`, `pitch_match_view.dart` and `match_screen.dart` (the shootout path, around MS:338–370).
- Test: `test/unit/pitch/shootout_staging_test.dart`, `test/widget/pitch_shootout_test.dart`

**Interfaces:**
- In Pitch mode, the shootout is staged kick by kick from `ShootoutKick`. It shows:
  - the camera on one goal;
  - the taker walking from the centre circle;
  - the run-up;
  - the ball into the lane;
  - the keeper's dive into `diveLane`;
  - the result.
- Each kick takes 4 s at every speed. `_ShootoutStrip` still shows the tally.

- [ ] **Step 1: Write the tests.**
  - `each kick's taker and result match the outcome`.
  - `a save has the keeper in the ball's lane`.
  - `the tally matches the strip`.
- [ ] **Step 2: Run.** Expected: FAIL.
- [ ] **Step 3: Implement.**
- [ ] **Step 4: Run.** Expected: PASS.
- [ ] **Step 5: Commit** `feat(pitch): penalty shootouts on the pitch`.

### Task 18: Copy in 28 languages

**Files:**
- Modify: `copy/strings.csv` and every `lib/l10n/app_*.arb` file.
- Test: `test/unit/l10n`.

- [ ] **Step 1:** Write every new key (the pitch commentary, the view choice and the switch) in the remaining 26 languages through the round trip.
  - Use variants that read naturally with names in each language. Use name-neutral phrasings where case endings would be needed, e.g. Czech/Polish "střílí {player}" order.
- [ ] **Step 2: Run** `test/unit/l10n` and the copy guards. Expected: PASS, with `untranslated.txt` free of `pitch*` keys.
- [ ] **Step 3: Commit** `feat(pitch): copy in 28 languages`.

### Task 19: End-to-end and full suite

**Files:**
- Create: `test/story/pitch_view_story_test.dart`

- [ ] **Step 1: Write the story test.** In a seeded career, watch a knockout match in Pitch mode at fast speed through to a shootout, and assert all of the following:
  - every goal event was staged;
  - the final score matches the fixture row;
  - `pacer.total` is within the fast band (scaled for ET);
  - no invariant violations.
- [ ] **Step 2: Run the full suite** in one process: `caffeinate -dimsu timeout 5400 flutter test`. Expected: PASS.
- [ ] **Step 3: Write the device checklist** into the report. Items to check:
  - 60 fps on the A56 in a big stadium;
  - 30 fps or better on the oldest test phone;
  - legibility at each speed;
  - the landmark look;
  - the crowd split at an away match;
  - a red card;
  - a shootout.
- [ ] **Step 4: Commit** `test(pitch): end-to-end story`.
