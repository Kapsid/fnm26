# 2D TV playtest feedback, 2026-11-09 (branch feat/feedback-pitch-1109, from main 7ad4a3a2)

Four owner items. Not merged, not pushed. No schema, save or copy changes (no new strings).

## 1. Goalkeepers run into players

**How it was measured.** A throwaway lab run over 30 lab matches (`labMatch`/`labScript`, every speed) sampled every 0.05 s, drew each frame through `Declutter.frame` (what the view draws) and counted episodes where a keeper's drawn token overlapped anybody else's by more than 45% of a token (`DisplaySpacing.overlap > 0.45`).

Before: 135 episodes. 55 were in open play and 36 just around a cut. In almost all of them the keeper had the ball in his hands (a catch, a claim, a collected shot) and an opponent stood 1.5 to 2.5 m off him.

**Root cause: two parts working together.**
- `lib/domain/services/match/pitch/story_layer.dart:2673-2700` (`_step`, "Who presses"): in open play the one or two nearest men of the side without the ball press it. That included the keeper holding the ball. Each presser's target is `ball + (ownGoal - ball).unit * 2.2` (`story_layer.dart:2982`). That is 2.2 m from the keeper, about two thirds of a token on a phone, so the forward ran straight onto him.
- `lib/domain/services/match/pitch/display_spacing.dart:300-312` (`Declutter.contactIn`): any man the ball is with, or coming to, is "in a challenge" with any opponent near him. A challenge allows `contactRoom` (60% overlap) instead of `room` (30%). So the draw-time declutter also let the forward sit on the keeper instead of easing him aside.

**Fix.**
- Nobody presses a keeper who has the ball inside his own area. He cannot be challenged there, so the forwards turn back into their shape (`story_layer.dart` `_step`, `keeperHolds`).
- A keeper on the ball sets himself to play it on: a step forward at most, never a dribble out of his area (`_drive`, a new carrier branch for keepers). Without the press, the old carrier drive walked one keeper 23 m out with a back pass, which `set_piece_shape_test` caught. The press had been what made him release the ball.
- A keeper's own ball never counts as a challenge in `Declutter.contactIn`. Anyone near a keeper holding the ball is kept to the normal 30% and eased aside (`display_spacing.dart:310`).
- The moment pairs are unchanged: shooter and keeper in a shot, a foul, a blocker. A one-on-one or a save at a shooter's feet may still touch.

After: 45 episodes, with 3 in open play and 7 around a cut. What is left is inside staged moments, where touching is intended: a corner's six-yard crowd, a blocked shot on the line, a keeper's own foul.

## 2. Players walk off the pitch and play continues

**What it was.** Nobody drifts over the lines. The same lab run found no player (keepers included, men walking off excluded) more than 1 m outside the lines, ever: the story layer clamps every position to 0.5 m inside (`story_layer.dart` `_clampPitch`). It was the **walk-offs**:
- `story_layer.dart:1474-1500` (`_scheduleChanges`): a red-carded or injured man starts his walk as his moment's window *ends*. A substituted man starts as his sub window opens.
- Those windows last 1 to 3 s (`pitch_pacer.dart`: `_sub` 2.5 s, `_card` 3 s, `_injurySeconds` 3 s, less at mid and fast speed). The walk goes to the nearest boundary at 2 m/s (`pitch_script.dart` `walkSpeed`), and from the middle of the pitch it took 3 to 17 s.
- So almost the whole walk happened in open play, with the ball moving around him. In 40 lab matches, 118 departures took 3 to 17 s each and nearly all of it was live play.

Separately, the draw-time declutter could push a man standing on a touchline up to 1.5 m over it (`display_spacing.dart` `Declutter.of`, clamp `-1.5..69.5`). The lab caught this 4 times.

**Fix.**
- **Play holds for him.** A sub, injury or card window now stays open (play stopped) past its end until every man walking off has reached the line, for up to 9 s (`_departureSpill`). It never runs into the next moment, an interval or a kick-off. See `_spills` and `_sendingOff` in `story_layer.dart:1205-1250`.
- **The camera takes him off.** At any cut (set piece, phase, or a goal's kick-off), a man still walking off is gone when the picture comes back: he left while the camera was away. See `_offAtCut` in `story_layer/ball.dart:93`, called from `_cut` and from the goal kick-off. The validator's cut contract now allows exactly this: a walker may vanish at a cut (`pitch_script.dart:852`).
- **He jogs off**, at 3.5 m/s instead of 2 m/s (`PitchScript.walkSpeed`, validator `maxWalkSpeed` 2.5 to 4).
- **Drawn on the pitch.** The declutter keeps an on-pitch man's drawn centre within the lines (`display_spacing.dart:463`).

After: 2 of 118 departures still show a man walking in live play (1.7 s and 0.8 s). In both, the next moment's window follows straight on with no cut, so there is nothing to hold.

**New test** `test/unit/pitch/on_the_pitch_test.dart`, over 40 lab matches at every speed, 0.05 s steps:
- Every player, keepers included and men walking off excluded, stays inside the lines in both script and drawn positions. The only allowance, made explicitly: the taker of a throw-in or corner (a routine restart's `takerId` around its restart, or a staged set piece's named men in its window) may stand up to 1 m past the line.
- Fewer than 1 in 10 departures may show the man walking in live play for more than 0.5 s.

The glitch-lab helper (`test/helpers/pitch_glitches.dart`) now treats the hold as play stopped for its "frozen in open play" count. Men standing still while play is held for a man going off are not frozen open play.

## 3. In-match penalty in the shootout close-up

- **Domain.** `InMatchPenalty.of(script)` lives in `lib/domain/services/match/pitch/moment_staging/shootout.dart`. For every penalty `ShotMoment` it reads the kick the script actually plays: the shooter's strike from the spot, the lane from where the ball goes (left, centre or right as the taker faces it, low or high), and the dive from where the keeper ends up. The result maps from the engine's outcome: goal to scored, saved to saved, wide to wide, woodwork to post. A save is in the keeper's lane, a goal never is, and a miss is always wide of a post. The keeper is the moment's own `keeperId`. Nothing is re-rolled.
- **View.**
  - `ShootoutPainter` now draws from a small `ShootoutView` interface (kick, seconds, cast). `ShootoutStageController` implements it unchanged.
  - The new `PenaltyCloseUp` (`lib/features/match/pitch/shootout_stage.dart`) implements it from the pitch clock. The close-up runs from 1.0 s into a shootout kick (the taker almost set) to the kick's end at 4.0 s. The strike lines up with the script's strike, so a pause, a seek or the GOAL flash's held clock all hold the close-up too.
  - `PitchMatchView` swaps the players layer for the close-up while it is on, then the pitch comes back.
  - It is the same painter as the shootout, so there are no target cells, no green box and no chevrons (`paintShirt(chevron: false)`).
- **Tests.**
  - `test/unit/pitch/shootout_staging_test.dart`, the new "a penalty in the match plays in the close-up as the match had it" test: every staged penalty in 80 lab matches is checked for taker, side, result, lanes, keeper and timing.
  - `test/golden/pitch_penalty_test.dart`: the close-up is up at the strike and the pitch is back before and after it. Three new goldens: `pitch_penalty_run_up`, `pitch_penalty_strike`, `pitch_penalty_result`. I looked at all three.
- **Preview.** The three frames are copied to `~/Downloads/penalty-preview/`. They show a scored penalty: the run-up, the strike, and the ball in the net with the net rippling.

## 4. Goal haptic

- `MatchFeedback.goal` is now exactly the full-time haptic: one `HapticFeedback.mediumImpact()`. The goal's alert tone is kept; it is desktop only.
- The second delayed `heavyImpact`, its `Timer`, `goalImpactDelay` and `cancelPending()` are gone. The one caller, in `MatchScreen.dispose`, is removed.
- `vibrate()` is never used.
- `test/widget/pitch_feedback_test.dart`: `_expectGoalFelt` now expects one alert tone per goal, each straight after a medium tap, and no heavy taps or buzz with nothing delayed. The other assertions count the goal tone instead of heavy taps. The kick-off and red card also tap medium, so the tone is what tells a goal apart.

## Goldens

- New: `pitch_penalty_run_up.png`, `pitch_penalty_strike.png`, `pitch_penalty_result.png`.
- Regenerated (intended: the scripts changed):
  - `pitch_live_goal.png`: players placed slightly differently.
  - `match_phone_pitch_goal.png`: its frame is a penalty goal, so it now shows the close-up.
  - `match_phone_pitch_red_card.png` regenerated back to identical with main after the keeper-carrier change, so no diff.
- All of them were looked at.

## Tests run

- `flutter test test/unit/pitch`: 190 passed, 0 failed (final run, all changes in).
- Widget and golden pitch/match tests (31 widget files and 9 golden files, the new one included): 354 passed, 3 skipped. 3 goldens failed for intended script changes; they were regenerated and looked at (11/11 pass after). `test/widget/pitch_feedback_test.dart`: 7/7.
- `flutter analyze` on the touched dirs: no new warnings. Four pre-existing ones remain: three unused imports in `shootout_stage.dart` and an unused local in `ShootoutStaging.restOf`.

## Concerns

- **A visible change in pace.** Men going off now jog, play waits for them where there is room, and they vanish at a cut otherwise. Holds take screen time from the quiet minutes after a change, not from the match clock. They need a device look, especially at fast speed.
- **Staged moments are untouched.** Keeper overlap inside them (a corner's crowded six-yard box, a shot blocked on the line) is as before, by design (contact pairs).
- **The phone's score banner covers the taker's name.** The close-up draws the name at the top of the frame, and on the phone the GOAL banner sits over it (see the regenerated `match_phone_pitch_goal.png`, which happens to land on a penalty). The shootout has the same layout. Moving the name down is a small follow-up if the owner wants it.
- **The close-up is a single fixed camera at one goal**, as in the shootout. The taker walks in from the side for its first second. That is the shootout's own choreography reused, not the in-match run-up.
- **A penalty whose kick was before a resume point** (a live tactics change after it) is not re-shown in the close-up.
