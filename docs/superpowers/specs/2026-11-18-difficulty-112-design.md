# Difficulty 1.1.2: big games and slower growth for the manager's side

Date: 2026-11-18. Status: built on `feature/difficulty-112` (not merged).

## Problem

A near-top nation (best XI about 78 to 81: Serbia, Türkiye, Canada) run by a manager wins the World Championship too easily, even in cycle 1. In a one-off neutral finals knockout (ET and penalties included) the AI world gives an 80 side 0.08 against an 88 and 0.26 against an 84; the same side run "typically" (drilled 0.75 + good scout) won 0.37 / 0.47, and "well run" (also +3 condition, a believe talk at 46' and 91', the best plan) 0.51 / 0.59. Owner goal: gentle. A title should take a few cycles of building. Elite and minnow sides feel unchanged, and the AI-v-AI world does not change.

## Save rule

Everything is gated by a per-cycle `draws_watched` marker, `difficulty2` (`BigGameDifficulty.kind`). It is stamped at career creation (cycle 0, `create(difficulty2: true)` by default) and at every rollover. An old save's cycle in progress is unmarked: every factor is exactly 1.0 or 0, no new RNG draws, results byte-identical (guard: `pinned_world_test` with `difficulty2: false`). There is no schema bump and no persisted shape change, only new marker rows.

## Match day (the manager's matches only)

Code: `lib/domain/services/match/big_game_difficulty.dart`.

1. **Big-game term** in World Championship and continental finals knockouts (R32/R16 and CR16, QF and CQF, SF/3RD/FINAL and C-prefixed): `term = weight(mine) x (slope[stage] x max(0, theirs - mine) + 0.010 x max(0, pedigree_them - pedigree_me))`, capped at 0.13. Here `mine`/`theirs` are the fielded XI means, `slope = [0.008, 0.010, 0.011]`, and pedigree is `WorldPedigree.edges` (World Championship rounds only). `weight` is 0 at 62 or below, full from 70 to 82, 0 at 87 or above, with smoothstep ramps, so minnows and the elite are untouched.
   - Played: on the chemistry seam, his side `x (1 - term)` and the opponent `x (1 + term)` (a new opponent key).
   - Skipped: `_playBackground` stops excluding his ties. In a marked cycle his finals knockout takes `strengthEdge = -65 x term` (from his side's view), which also leans ET/penalties through `knockoutWeight`. The simulator's edge is a real number, so no dither and no new RNG stream were needed.
2. **Live shootout lean**: in any knockout of a marked cycle, `decideShootout` gets `exp(0.05 x XI mean)` for each side (half the background `knockoutWeight` slope). Before this, the live screen passed no strength pair.
3. **Host crowd** at a finals he hosts: atmosphere x 0.5 (the skipped path never had a crowd).
4. **Condition** in a finals knockout: net positive capped at +3 (was +6).
5. **Team talks**: the positive attack/defence swing x 0.7 (`MatchEngine.play(talkScaleByNation:)`); downsides unchanged. ET shootout composure is capped at 1.04 (was 1.08).
6. **Mid-tier band** (`MidTierDifficulty`, `wide: true`): bandHigh 78 to 81, eliteEdge 84 to 87.

## Growth (the manager's nation only)

Code: `lib/domain/services/player/growth_difficulty.dart`.

7. **Youth intake**: for marked cycles the total bonus is capped at +0.10. His skill and assistant are credited only with the hand he had while that cycle ran, recorded as marker kinds `difficulty2.youthHand:<cycle>:<permille>`. These are stamped at cycle open, after a youth-development skill point and after an assistant hire. The best value seen in the cycle counts, and a cycle with no record inherits the last earlier one. Unmarked cycles keep the old rule (current hand to every cycle).
8. **Game-time development**: starts banked in competitions of marked cycles count at a coefficient of 0.22 (was 0.30), and the cap is 2 (was 3). The bump is `max(old rule on unmarked starts, blended rate on all starts capped at 2)`, so nobody loses rating at a rollover. `careerStartsByPlayer` returns a `CareerStarts` map that carries `marked`.

## Measured (knockout lab, QF unless stated; before -> after)

| Cell | AI world | typical played | typical skipped | well-run played |
|---|---|---|---|---|
| 80 v 88 | .077 | .373 -> .207 (SF .191) | .216 -> .079 | .509 -> .287 (R16 .338, SF .264) |
| 80 v 84 | .260 | .468 -> .352 | .418 -> .300 | .585 -> .472 (SF .466) |
| 76 v 84 | .102 | .379 -> .192 | .243 -> .096 | .504 -> .286 |
| 80 v 80 | .501 | .541 -> .535 | .621 -> .609 | .664 -> .656 |
| 88 v 84 | .802 | .603 -> .609 | .815 -> .815 | .750 -> .748 |
| 88 v 88 | .501 | .551 -> .551 | .651 -> .651 | .675 -> .667 |
| 60 v 70 | .060 | .328 -> .319 | .205 -> .205 | .487 -> .472 |
| 64 v 72 | .129 | .348 -> .319 | .287 -> .259 | .510 -> .469 |

The change from before to after is close between played and skipped: 80v84 typical moves -.116 played and -.118 skipped; 80v88 moves -.166 played and -.137 skipped, because the played delta also carries the new shootout lean that skipped already had. Skipped was already harsher than played against a stronger side before this change, and that is unchanged. A hosting well-run side with +6 condition loses more (80v80 .729 -> .666, 60v70 .601 -> .494), from items 3 and 4.

## Tests

`test/unit/match/big_game_difficulty_test.dart`, `test/unit/player/growth_difficulty_test.dart`, `test/story/difficulty2_old_save_test.dart` (a real 1.1.0 save: unmarked until rollover, past intakes and starts unchanged), `test/story/difficulty2_world_test.dart` (Türkiye cycle 0, marked vs unmarked: AI-v-AI fixtures identical up to the manager's first differing result), and `pinned_world_test` (unmarked = byte-identical). The full table is `FNM_KO_LAB=1 flutter test test/unit/match/big_game_difficulty_lab_test.dart`.
