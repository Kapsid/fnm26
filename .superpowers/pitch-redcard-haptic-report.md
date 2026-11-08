# Pitch red card + goal haptic (branch feat/pitch-redcard-haptic, from main 48d83d60)

## Item A: 2D TV goal vibration

**Result: no Dart-side break. The 2D TV path calls `HapticFeedback.heavyImpact` exactly once per goal, the same as the Timeline does.**

Evidence (`test/widget/pitch_feedback_test.dart`, group "the goal buzz"). The tests record `SystemChannels.platform` calls with `soundHapticsEnabledProvider` on. All of them passed on the unmodified main code before any change:
- 2D TV, seek to just before a goal: one `HapticFeedbackType.heavyImpact` call, plus `SystemSound.play alert`. There is no second buzz while the goal is held under the flash.
- 2D TV played from kick-off at match pace in 16 ms frames, with no seek: the first goal buzzes once.
- 2D TV built off the UI thread with the real `Isolate.run` builder, as on a phone: the goal buzzes.
- The Timeline control buzzes once, unchanged.
- The half-time whistle on the 2D TV does not send a heavy buzz.

The five candidates from the brief:
- The goal counted as `_reached` before the diff: no. `_held` keeps the minute's unshown goal out until its reveal.
- `dueStop` plus `markRead` swallowed it: no. The goal is announced on the stop frame, and the existing long-frame test covers that case too.
- The pitch has its own celebration that bypasses `_flashGoal`: no. The pitch has no haptic or feedback code at all.
- The feedback order: `MatchFeedback.goal` runs first inside `_flashGoal`.
- A frame that is never reached: the only structural difference from the Timeline is that the 2D TV sends the call from inside the Pitch clock's Ticker callback, where the Timeline sends it from a Timer.

So the problem is on the device, or it is a matter of perception. Facts worth knowing:
- `SystemSoundType.alert` is ignored on Android and iOS (Flutter SDK docs say desktop only). The "short tone" on a goal has never played on a phone, in either view.
- Android maps `heavyImpact` to `HapticFeedbackConstants.CONTEXT_CLICK`, a very weak tick on many phones, Samsung especially. iOS fires a freshly allocated `UIImpactFeedbackGenerator(.heavy)` that was never prepared.
- iPads have no Taptic Engine. If the 2D TV was played on a tablet, nothing can buzz.

I tried deferring the 2D TV's buzz out of the frame callback (`Timer.run`). I reverted it: there is no evidence it changes anything, and it left timers pending in three existing pitch tests. **No production change for item A. The regression tests stay and guard the path.**

Suggested next step on the device: which phone and OS showed it? If it was Android, a stronger effect for goals (for example `HapticFeedback.vibrate()`, the long-press effect) is a one-line change in `MatchFeedback.goal`. It would also change the Timeline's feel, so it is the owner's call.

### Update: the owner says it was the iPhone. The goal buzz is now robust (both views)
`MatchFeedback.goal` now does three things:
- It sends `HapticFeedback.vibrate()` first. On iOS that is `kSystemSoundID_Vibrate`, an audio-services buzz with no feedback generator to drop.
- `HapticFeedback.heavyImpact()` follows 120 ms later (`goalImpactDelay`, one cancelable timer). Phones that honour impacts still feel a goal.
- The alert sound plays as before; it is ignored on phones.

The `soundHapticsEnabledProvider` gate is unchanged, and kick-off and full time are unchanged. The match screen's `dispose` calls `MatchFeedback.cancelPending()`, so no impact fires after the screen is gone and no test is left with a pending timer.

The regression tests now expect `vibrate`, then `heavyImpact` 120 ms later, once per goal. That holds on the Timeline and on the 2D TV (seeked, played from kick-off, and built off the UI thread). Half-time and the red card send neither.

**This needs checking on the iPhone ("Bison's iPhone").** Tests only prove the calls are made, not that iOS plays them. The working theory: an unprepared `UIImpactFeedbackGenerator` gets dropped under the 2D TV's rendering load.

## Item B: red card moment on the 2D TV

**The design reads only the script, so it is deterministic per seed. There are no engine, result, schema, pacing or staging-timing changes.**

- **The foul (or a second booking):** the existing `_FoulPlan` already stages it. Its `foul` and `redCard` cues stay as they are.
- **The referee:** new `lib/domain/services/match/pitch/referee_card.dart`, pure Dart. `RefereeCardShow.of(script)` reads each red card window's cues.
  - He runs in over 1.0 s with a fade-in, to a spot 2.4 m from the man, on the side toward the pitch centre. He starts from 11 m further toward the centre; which side depends on the man's id, so it is fixed.
  - A second booking raises the yellow first (from cue minus 0.5 s, down by cue minus 0.1 s), but only when that falls after the foul whistle. The red goes up at the card cue, never before the foul, and is held for **1.8 s of screen time**. Then he jogs away and fades over 0.9 s.
  - A cut or restart inside his run makes him appear after it, or fade out with the picture (0.12 s).
- **Drawing:** new `lib/features/match/pitch/referee_painter.dart`. It is the `foregroundPainter` of the actors' `CustomPaint` in `pitch_match_view.dart`, drawn over the players. He is a dark rounded token with a lime collar, his arm raised, and a red or yellow card with a white edge and a shadow.
- **Walk-off:** the existing departure starts at the window end, so the man is walking while the card is still up (unit-tested). The side plays on with ten, as before.
- **Banner:** new part file `lib/features/match/match_red_card_banner.dart`, styled like the goal banner. It shows the team colour stripe, the flag, a red plate with a small card icon and "RED CARD", the player's name and the minute.
  - It drops from the top of the pitch, just under the score stripe, on phone and tablet. It is out for `kRedCardBannerHold` (2.4 s); with reduced motion it is static.
  - It is hidden while a goal's flash is out.
  - **It never pauses the clock.** It is not tied to `kGoalFlashHold` or `_syncPitchClock`.
- **Screen wiring:** `_syncPitchState` (2D TV only) calls `_showRedCard` when a red card arrives. This sets `_redFlash`, starts a timer, and calls the new `MatchFeedback.redCard` (`mediumImpact`, gated by the same setting). The Timeline is unchanged and shows no banner (tested).
- **New string:** `matchRedCardShout`, "RED CARD", in all 28 languages. It went through `copy/strings.csv` (one CRLF row), then `dart run tool/import_copy.dart`, then `flutter gen-l10n`. There are no em dashes and no "World Cup".

**Narrow edits to shared files.** `match_screen.dart` got a part line, two fields, a dispose line, the red branch in `_syncPitchState`, `_showRedCard`, and a Stack around `PitchMatchView`. `pitch_match_view.dart` got the foreground painter. `match_feedback.dart` got `redCard`. I did not touch `story_layer*`, `ball.dart`, `dead_ball.dart`, `shot.dart`, `foul_offside.dart`, `pitch_pacer.dart`, `match_score_bug.dart` or `match_frame.dart`.

## What I took from the other agent's WIP (76504c96, being reverted there)
Its `RefereeShow` was nearly the same design: drawn over the picture, read off the red card cue, standing on the middle side of the man.

I adopted two of its ideas, in a follow-up commit:
- **The red card cue is now 1.2 s after the whistle** (a yellow stays at 0.6 s), in `_FoulPlan._card` (`foul_offside.dart`), so the referee has time to get there. Only the cue and reveal time move, clamped as before to the window end minus 0.15 s. The window length, the pacing and the outcome are unchanged.
- **He sets off at the whistle, never before the foul.** `RefereeCardShow.start` is no earlier than the foul cue.

I kept my painter as a separate foreground layer rather than drawing inside `ActorsPainter`. That keeps the shared painter untouched.

I did not take the other things in that WIP:
- `flashesAsEvent` including red cards: the red card has its own banner here.
- Its untested `referee_show_test`.

## Living alongside the substitution pop-up (6b279063)
**The rule: the red card wins, then the sub's pop-up comes back.** Their `_EventBanner` and my `_RedCardBanner` share the goal banner's dress (kit edge, flag, plate shout, name, minute), and both drop into the same place under the stripe. Two lines settle it at merge time, because `_eventFlash` exists only on their branch:
1. In `build`, the `MatchScoreboard(...)` notice: `notice: bug && _redFlash == null ? _eventFlash : null,`. While the red banner is out, the sub banner is held back, and it returns if its timer is still running.
2. Keep `flashesAsEvent` for substitutions only, so a red card never fills `_eventFlash` too and the two banners never double up. The tablet and Timeline `_EventFlash` card is then unaffected.

A goal's flash beats both, as it already does on each branch.

## Tests
- `test/unit/pitch/referee_card_test.dart` (7 tests):
  - one referee per staged red card, on its own cue;
  - the run-in, the hold, the jog away, and staying on the pitch;
  - the second yellow, and no card before the foul;
  - determinism;
  - the man is walking during the hold;
  - no red card means no referee.
- `test/widget/pitch_feedback_test.dart` (7 tests):
  - the goal buzz group from item A;
  - the red card on the 2D TV: the referee painter's show matches the event, the banner shows the shout, name and minute, one medium buzz, no heavy buzz, the clock keeps playing, the man walks during the hold, and the banner clears;
  - the Timeline shows no banner.
- `test/golden/phone_pitch_red_card_test.dart`: new golden `goldens/match_phone_pitch_red_card.png` (inspected). It uses the seeded save with attempt salt 5: a red card at 20', and the earlier goal is flashed and cleared first.
- Preview frames: `~/Downloads/pitch-redcard-preview/` has `frame_00` to `frame_16` (every 0.25 s fake time from 1.6 s before the card) and `still_banner.png`, at 2x. Regenerate with `flutter test test/golden/phone_pitch_red_card_test.dart --dart-define=RED_FRAMES=<dir>`.
- Runs:
  - `test/widget/pitch_mode_test.dart`, `pitch_feedback_test.dart` and the red card golden: all 53 pass.
  - The broad run covered all of `test/unit/pitch`, `test/unit/l10n`, `test/unit/match`, `pitch_match_view_test`, `score_bug_test`, `match_*` and `in_match_*` widget tests, and the goldens (`phone_pitch_mode`, `phone_guard_match`, `pitch_live`, `pitch_shootout`, `tablet_match_pitch`, `match_lineups_ratings`). See the final line in the reply for its result.
  - No existing golden was refreshed.

## Concerns
- Item A is not reproduced. Without the device and OS, I cannot confirm what the owner felt. Please ask which phone it was.
- The referee is drawn over every player, not depth-sorted, and in a crowded foul he can sit on top of name labels. The card is small at phone scale (I enlarged it once). The owner should look at the frames.
- The "hold 1.5 to 2 s" is screen time. At the faster speed steps the clock runs about 1.3 to 1.9 times faster, so the real hold is shorter.
- A red card in the same minute as a goal: the goal's banner wins, and the red banner shows only if its timer outlives the goal flash.
- `match_screen.dart` is also being edited on `feat/pitch-animation-feedback`. My hunks are small but sit near `_syncPitchState` and the `pitchSurface` build, so a textual merge conflict is possible there.
