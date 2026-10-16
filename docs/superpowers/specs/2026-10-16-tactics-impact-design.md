# Tactics that bite: design

2026-10-16. Owner request: "make it a bit harder, so tactics matter".

## Intent

The owner sets a plan, is never forced to change it, and cannot tell whether
it did anything. Tactics should feel like **visible risk and reward**:

- more attackers / attacking mentality → crazier scorelines, at both ends;
- defensive setups → tight, low-scoring games;
- high pressing → bigger reward AND bigger risk;
- the opponent reacts to what you do, so a plan that works against one side
  can backfire against the next;
- no safe middle: a cautious all-neutral plan has a weakness too.

The game gets harder as a by-product (a careless plan now costs matches), but
"lower the manager's win rate" is not the goal. **The goal is that his choices
move the outcome distribution, visibly.** Squad quality must still decide most
matches.

The owner's words on method: "we need to run proper simulations". Every change
below is measured before and after; nothing is tuned by feel.

## Where it stands today (from the code)

All in `lib/domain/services/match/match_engine.dart`, which plays the manager's
own matches.

1. **Formation does almost nothing.** `_attack`/`_defence` use `_mean` of each
   line, so three strikers and one striker of the same quality give the same
   attack. The shape only changes WHO plays.
2. **Mentality is nearly free.** +0.35 attack vs −0.18 defence per point off 50
   (`kMentalityAttack` / `kMentalityDefence`): going forward makes you better,
   not the game wilder.
3. **Pressing has no real downside.** It is a flat defence bonus
   (`kPressingDefence`) plus a little extra energy drain.
4. **The AI does not read the manager.** `AiTactics.forOpponent`
   (`lib/domain/services/match/ai_tactics.dart`) picks a posture from the
   strength gap and the nation's style, never from the manager's plan.
5. **Neutral is uncounterable.** Every `_matchup` term is an offset from 50,
   so an all-50 plan gives the opponent nothing to exploit (noted already on
   2026-10-04: tactics swing only ~±4pp wins).

## Goals

The owner picked three of the four proposals: **A, B and D**. "Make shape
matter" and "pressing as risk" came out of the conversation as part of what he
means by B.

- **A. The AI counters the manager's plan.** Before the match the opponent
  reads the manager's RECENT plans (see Owner's answers) and shifts its own instructions towards the counter
  the `_matchup` terms reward (pace in behind a high line, pressing a slow
  build-up, going direct against a high press, the width mismatch, sitting deep
  against all-out attack). How sharply it counters scales with the opponent's
  quality, and is sharper when the manager is predictable (the existing
  `predictability` figure on `tactic_familiarities`). A weak side sometimes
  misreads.
- **B. Attacking costs what it gains, and bold plans open the game.**
  - Mentality's defensive cost is brought close to its attacking gain.
  - Both sides' attacking commitment (mentality, and the number of attackers
    in the shape) raises the game's total chance rate, so two open sides make a
    wild game and two cautious sides a tight one.
  - Shape counts: more men in a line make that line count for more (a
    weighting on the line's count against the formation's baseline, not just
    its mean).
  - Pressing becomes two-sided: it creates more turnovers high up (more
    chances for) AND leaves space behind (more chances against, worse against
    a direct, pacey side), and drains energy faster.
- **D. Neutral is counterable.** The `_matchup` terms are re-anchored so a
  middle setting still has something an opponent can exploit (for example,
  direct play gains a little against an average line, not only a high one).
  Only a committed choice closes a door, and it opens another.
- **The skip path tells the same story.** A match the manager skips runs
  through `RatingMatchSimulator` via `_withManagerTactics`
  (`lib/features/hub/hub_providers.dart`). It must apply the same plan, shape,
  counter and match-up effects as the live engine, as rating points. Skipping
  must never be the way to dodge a counter. (This is the hole fixed for
  chemistry on 2026-10-04.)

## Non-goals

- **The background AI-vs-AI simulator stays as tuned on 2026-10-01.** World
  results, seeds and `world_variance_test` are not to move. (Owner's earlier
  call: only the manager's matches feel off.)
- No difficulty setting (proposal C was not picked).
- No new screens. The effect must show in scorelines, match stats and the live
  match itself. Explaining counters in the UI (a pre-match "they will press
  you" note, for instance) is a later idea, not this build.
- No schema change unless the counter's "read" truly needs new stored state.
  The predictability column already exists.

## Anti-goals (a failure even if it technically works)

- **A lottery.** A clearly better squad must still win clearly more often.
  Tactics shift the odds; they do not replace the squad.
- **One dominant plan.** If one setting (all-out attack, max press, anything)
  is best against everybody, the build has failed.
- **Skipping beats playing**, or the other way round, by a margin you can feel.
- **A psychic, unfair AI.** The counter is a read of the plan you go in with,
  not a reaction to every in-match change, and weak sides read worse.
- Em dashes in any new user-facing copy (standing rule).

## Method: simulations first

1. **Build a harness before changing anything.** Engine-level match runs
   (the style of `test/unit/match/tactics_swing_test.dart` and
   `match_balance_test.dart`), not whole careers, except for the final check.
   For a grid of plans (all-out attack, park the bus, high press, possession,
   counter, neutral, and two or three shapes: 4-3-3, 5-3-2/5-4-1, 3-4-3)
   against equal, stronger and weaker opponents set up by `AiTactics`. At least
   2000 matches per cell. Report per cell: goals for/against per game, total
   goals, W/D/L, spread of goal difference, share of 4+ goal games.
2. **Record today's numbers** as the baseline.
3. **Make the changes, re-run, tune.**
4. **Whole-career check** with the deterministic career harness from the
   2026-10-01 calibration (`careerService.create(rngSeed:)` + advance to the
   champion, ≥200 careers): manager's results at a mid nation (Czechia) on a
   sensible plan, a bad plan and neutral, played and skipped.

### Targets (builder's call to refine; these are the starting bar)

- All-out attack vs neutral, equal sides: total goals up roughly 40-60%, and
  goals AGAINST up clearly too.
- Park the bus: total goals down roughly 30-40%; harder to lose, harder to win.
- High press: both xG for and against higher than neutral; clearly worse
  against a direct, pacey opponent, clearly better against slow possession.
- A well-judged plan vs a badly-judged one, equal squads: worth roughly
  0.3-0.5 goals a game (today's `tactics_swing_test` pins about a sixth).
- Neutral plan vs a countering AI: measurably worse than today; a sensible
  committed plan beats neutral on average.
- Rating gaps still dominate: a 10-point-better squad on a bad plan still wins
  more than it loses.
- Skip vs play for the same plan: win rate within ~3pp.
- `world_variance_test` and the background `match_balance_test` group:
  unchanged.

## Guard tests

The existing guards pin today's magnitudes and will need re-pinning to the new
targets (`tactics_swing_test`, the engine half of `match_balance_test`,
`scoreline_distribution_test`). New guards: no dominant plan across the grid,
openness (attack/attack games score more than bus/bus games), the AI counter
moves the right sliders, and skip/play parity.

## Owner's answers (2026-10-16)

- **The AI reads your RECENT plans, not this match's.** Opponents counter what
  they have seen you play lately, more sharply the longer you have stuck with
  it (the stored `predictability`). This cannot be gamed with a decoy plan
  switched at 1', and varying your approach is a real way to stay hard to
  read. A manager with no history yet gets only a weak, general read.
- **The AI may change its formation to counter, depending on the team.** Not
  every side does it: it depends on the opponent (its quality, and its national
  style: a rigid identity changes shape less than a pragmatic one). Most of the
  time the counter is in the sliders; sometimes, for the right team, it is a
  shape change too (three strikers met by a back five).

## Calls made in review (Claude's, owner to check)

- **Skip/play parity is about the plan's EFFECT, not absolute win rate.** The
  two simulators were deliberately tuned apart on 2026-10-01 and are not
  re-synced. What must match: the change a plan makes against neutral, played
  vs skipped, within ~3pp of win rate.
- **The skip path may change the scoring rate.** `RatingMatchSimulator` gets an
  optional openness multiplier (default 1.0, so world results and
  `world_variance_test` cannot move). Without it a skipped all-out-attack match
  would still look like a 1-0, which breaks "the same story".
- **Predictability is charged once.** Its chemistry penalty
  (`TeamChemistry.factor` read penalty) moves into the counter: being
  predictable now costs you by letting the opponent counter you more sharply,
  instead of as a hidden flat multiplier as well.
- **Harness budget:** the career harness can only skip today. Rather than build
  a headless "play every match live" career mode, played-vs-skipped parity is
  proven at match level (same squads and opponents through both simulators),
  and the whole-career check runs on the skip path, which the parity test ties
  to the played one.

## Left to the builder

- All coefficients and curve shapes, settled by the simulations.
- Exactly how shape counts (count weighting, which positions count as
  attackers).
- How the AI's read quality maps from strength and predictability, and how far
  it moves from its style-based posture (it should still look like itself:
  Italy still sits deeper than the Dutch).
- How the skip path converts the match-up and counter into rating points.
