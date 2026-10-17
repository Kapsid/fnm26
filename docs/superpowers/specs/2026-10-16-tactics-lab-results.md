# Tactics lab results

The lab measures what a manager's plan is worth in `MatchEngine`: seven plans (shape plus the six dials, see `labPlans` in `test/helpers/tactics_lab.dart`) played by an 80-rated side against an AI opponent whose setup comes from `AiTactics.forOpponent`. Every cell is 2000 seeds, each played both ways round at a neutral venue, so each cell is 4000 matches. Columns are the manager side's goals for/against per match, total goals, result shares, the standard deviation of goal difference, and the share of matches with 4+ goals.

Run it with:

    FNM_LAB=1 flutter test test/unit/match/tactics_lab_test.dart

(about 2 minutes). Opponent cells: equal (80v80), stronger opponent (80v86), weaker opponent (80v74).

## Baseline (before)

Date: 2026-10-16, branch `feature/tactics-impact` at 1574f85 (engine untouched). `aiCounters` has no effect yet.

### equal 80v80

| Cell | GF | GA | Total | Win | Draw | Loss | GD sd | 4+ goals |
|---|---|---|---|---|---|---|---|---|
| neutral | 1.34 | 1.36 | 2.70 | 37.8% | 23.5% | 38.7% | 1.77 | 28.3% |
| allOutAttack | 2.06 | 1.91 | 3.97 | 44.5% | 18.3% | 37.3% | 2.15 | 55.1% |
| parkTheBus | 0.91 | 1.08 | 1.99 | 30.3% | 29.9% | 39.8% | 1.52 | 14.1% |
| highPress | 1.53 | 1.49 | 3.01 | 40.3% | 22.1% | 37.7% | 1.88 | 34.8% |
| possession | 1.29 | 1.35 | 2.65 | 36.7% | 24.1% | 39.2% | 1.76 | 27.0% |
| counter | 1.22 | 1.17 | 2.39 | 37.9% | 25.9% | 36.1% | 1.67 | 22.1% |
| wide | 1.35 | 1.43 | 2.78 | 36.9% | 23.2% | 40.0% | 1.79 | 30.2% |


### stronger 80v86

| Cell | GF | GA | Total | Win | Draw | Loss | GD sd | 4+ goals |
|---|---|---|---|---|---|---|---|---|
| neutral | 1.18 | 1.63 | 2.81 | 28.7% | 23.6% | 47.7% | 1.78 | 30.9% |
| allOutAttack | 1.81 | 2.26 | 4.07 | 32.3% | 18.3% | 49.4% | 2.12 | 57.1% |
| parkTheBus | 0.80 | 1.34 | 2.14 | 23.3% | 26.8% | 50.0% | 1.57 | 16.9% |
| highPress | 1.32 | 1.76 | 3.08 | 30.1% | 22.0% | 47.9% | 1.86 | 36.6% |
| possession | 1.13 | 1.62 | 2.75 | 27.3% | 23.6% | 49.1% | 1.77 | 29.7% |
| counter | 1.09 | 1.44 | 2.53 | 29.9% | 24.3% | 45.7% | 1.70 | 24.2% |
| wide | 1.18 | 1.73 | 2.91 | 26.9% | 22.4% | 50.7% | 1.81 | 33.6% |


### weaker 80v74

| Cell | GF | GA | Total | Win | Draw | Loss | GD sd | 4+ goals |
|---|---|---|---|---|---|---|---|---|
| neutral | 1.52 | 1.04 | 2.55 | 48.8% | 23.8% | 27.5% | 1.75 | 25.0% |
| allOutAttack | 2.23 | 1.51 | 3.74 | 55.5% | 18.4% | 26.1% | 2.09 | 51.0% |
| parkTheBus | 1.05 | 0.82 | 1.87 | 40.3% | 31.1% | 28.6% | 1.48 | 12.1% |
| highPress | 1.69 | 1.22 | 2.91 | 48.8% | 22.1% | 29.1% | 1.83 | 32.6% |
| possession | 1.46 | 1.03 | 2.49 | 47.7% | 23.8% | 28.5% | 1.72 | 23.3% |
| counter | 1.33 | 0.91 | 2.24 | 47.6% | 25.8% | 26.6% | 1.61 | 18.1% |
| wide | 1.51 | 1.10 | 2.61 | 46.8% | 24.4% | 28.8% | 1.75 | 26.1% |


## After

Date: 2026-10-16, branch `feature/tactics-impact`, Task 8 (tune and re-pin). Every cell 2000 seeds both ways round, neutral venue, as above. The "countering AI" tables have the opponent bend its posture with `AiCounter.apply`, reading the manager's lab plan at predictability 1 (he has fielded nothing else).

### Targets against the final numbers

| Target (spec) | Achieved |
|---|---|
| All-out attack vs neutral, equal: total goals +40-60%, goals against clearly up | +43.8% (3.94 vs 2.74); against 2.00 vs 1.41 |
| Park the bus: total goals -30-40% | -33.6% (1.82); loses least of any plan but the counter (35.0%) and wins least (32.9%) |
| High press: for and against both above neutral | 1.46 / 1.56 vs 1.33 / 1.41 in the lab; 1.340 / 1.347 vs 1.290 / 1.290 alone against a neutral side |
| High press worse vs direct pace, better vs slow possession | -1.05 vs -0.11 a game (`tactics_tradeoffs_test`); beats possession +0.23, loses to counter -0.49 |
| Well-judged vs badly-judged plan, equal squads: 0.3-0.5 goals | +0.362 (`tactics_swing_test` dial guard); strongest pair in the grid +0.49 |
| Neutral vs countering AI measurably worse than before; a committed plan beats neutral on average | neutral -0.08 a game (W 35.7%, L 39.1%) against -0.02 (37.8% / 38.7%) before; committed mean +0.093 |
| 10-point-better squad on a bad plan still wins more than it loses | 80 highPress v 70 counter: W 48.4% L 28.5%; 80 counter v 70 bus: W 36.1% L 22.3% |
| Skip vs play within ~3pp | largest gap 1.8pp over six plans at 75v75 and 65v65 (4000 seeds) |
| Every plan has a counter >= 0.15 (equal squads) | neutral 0.17, allOut 0.35, bus 0.32, press 0.49, possession 0.23, counter 0.21, wide 0.18 |
| No dominant plan | none beats every other |
| All-out mirror wild (>= 1.4x neutral) but never routs (4+ margins <= 6%) | 4.70 goals (1.82x), 5.3% routs |
| A predictable plan does worse against a countering side | committed plans' mean GD -0.157 at predictability 1 against -0.046 at 0 |
| World / `RatingMatchSimulator` default path untouched | `world_variance_test` and the `RatingMatchSimulator balance` group unchanged and green |

### What changed, and why

The constants alone could not reach the bar; four terms changed shape (each is explained where it lives, in `match_engine.dart` and `ai_counter.dart`):

- **Openness: one side opens a game, it takes both to shut it.** The bolder side's commitment sets how open the game is (a max), caution is averaged. With both averaged, an all-out mirror paid twice (each side's flat lift met the other's flat hole, and the multiplier doubled on top): 8-9 goals a game.
- **The scoreline bends openness.** In an open game the side in front sits on its lead (`1 / open`) and the side behind chases (`open^2`). Goals at a constant rate spread margins as widely as totals (10% routs at 4.9 goals); with the bend, 5%.
- **The line's defensive term was a gain, not a cost.** `_defence` added `(line - 50) * kLineDefence`, contradicting every comment around it; a high line is now a cost at the back.
- **New match-up relations.** A patient build-up against a deep block (`kPatience`), a deep line smothering long balls (`kDeepLineSmother`), and a back three exposed in behind like a higher line (`kBackLineExposure`): without them the counter-attacking plan beat everything and the 3-4-3 had no counter. The mentality clash term was removed (openness carries its upper half; its lower half made all-out attack a loss against a passive side). "Direct beats press" folded into the space-behind term, which now reads a neutral build-up as part-direct, so a press concedes against a neutral side too.
- **The AI counter** answers a deep block with patience and a direct side with a deeper line, reads the middle as part-exposed, and moves 0.8 of a point per point (was 0.5).

### Tuning rounds (equal squads, 500-1000 seeds per cell in a scratch harness)

| Round | Change | Result |
|---|---|---|
| Start (Tasks 1-7) | as built | all-out mirror 8.9 goals, 18% routs; counter plan beats every plan; well-judged plan +0.02; no counter >= 0.15 for allOut, press or counter |
| B | line sign fixed; mentality 0.35/0.28 -> 0.2/0.17; shape 4/2.5 -> 2.5/1.5 | mirror 7.0; counter still dominant |
| C-D | patience + smother terms; match-up weight 1.4; openness by max; flat dials cut | mirror 5.0 (16% routs); every counter but two >= 0.15; plan +0.21 |
| E-F | back-three exposure; mentality clash removed; press space reads neutral | all-out vs passive turns positive; counters all >= 0.15 at weight 1.7; routs 10% |
| G-H | scoreline bend (leader `1/open`, trailer `open^2`) | routs 10% -> 6% at the same total |
| J-K | AI patience/smother/exposure reads, counter gain 0.8, kOpenDown 0.6, lead/trail from one goal | predictable plans countered clearly; bus -32%; routs 4.4% |
| L (final) | weight 1.85 after the clamp, kOpenUp 0.42, skip headroom 65 | the table above |

### equal 80v80

| Cell | GF | GA | Total | Win | Draw | Loss | GD sd | 4+ goals |
|---|---|---|---|---|---|---|---|---|
| neutral | 1.33 | 1.41 | 2.74 | 35.6% | 25.1% | 39.3% | 1.73 | 29.2% |
| allOutAttack | 1.94 | 2.00 | 3.94 | 36.0% | 26.1% | 37.9% | 1.69 | 54.9% |
| parkTheBus | 0.89 | 0.93 | 1.82 | 32.9% | 32.1% | 35.0% | 1.41 | 11.8% |
| highPress | 1.46 | 1.56 | 3.02 | 36.9% | 23.0% | 40.2% | 1.81 | 35.4% |
| possession | 1.50 | 1.44 | 2.94 | 39.4% | 23.7% | 36.9% | 1.77 | 33.6% |
| counter | 1.21 | 1.11 | 2.32 | 38.8% | 27.5% | 33.8% | 1.62 | 20.9% |
| wide | 1.51 | 1.58 | 3.09 | 36.4% | 23.8% | 39.8% | 1.81 | 37.0% |

### equal 80v80, countering AI (predictability 1)

| Cell | GF | GA | Total | Win | Draw | Loss | GD sd | 4+ goals |
|---|---|---|---|---|---|---|---|---|
| neutral | 1.34 | 1.42 | 2.76 | 35.7% | 25.2% | 39.1% | 1.73 | 30.1% |
| allOutAttack | 1.71 | 1.91 | 3.62 | 33.6% | 24.2% | 42.2% | 1.76 | 48.2% |
| parkTheBus | 0.89 | 1.05 | 1.95 | 30.7% | 30.6% | 38.7% | 1.48 | 13.7% |
| highPress | 1.46 | 1.92 | 3.37 | 29.1% | 21.9% | 49.0% | 1.86 | 43.4% |
| possession | 1.42 | 1.43 | 2.85 | 37.1% | 25.1% | 37.9% | 1.71 | 31.4% |
| counter | 1.08 | 1.10 | 2.18 | 35.0% | 29.2% | 35.8% | 1.57 | 18.2% |
| wide | 1.60 | 1.69 | 3.29 | 37.0% | 22.7% | 40.3% | 1.87 | 41.9% |

### stronger 80v86

| Cell | GF | GA | Total | Win | Draw | Loss | GD sd | 4+ goals |
|---|---|---|---|---|---|---|---|---|
| neutral | 1.23 | 1.74 | 2.96 | 26.5% | 23.3% | 50.2% | 1.71 | 34.4% |
| allOutAttack | 1.76 | 2.21 | 3.97 | 26.7% | 25.5% | 47.8% | 1.64 | 55.1% |
| parkTheBus | 0.83 | 1.26 | 2.09 | 24.5% | 28.9% | 46.6% | 1.53 | 16.2% |
| highPress | 1.28 | 1.82 | 3.10 | 26.6% | 22.6% | 50.8% | 1.72 | 37.1% |
| possession | 1.27 | 1.74 | 3.01 | 27.6% | 23.8% | 48.6% | 1.71 | 35.3% |
| counter | 1.18 | 1.46 | 2.64 | 31.9% | 23.8% | 44.3% | 1.71 | 27.0% |
| wide | 1.34 | 1.88 | 3.22 | 26.7% | 22.8% | 50.5% | 1.75 | 40.2% |

### stronger 80v86, countering AI (predictability 1)

| Cell | GF | GA | Total | Win | Draw | Loss | GD sd | 4+ goals |
|---|---|---|---|---|---|---|---|---|
| neutral | 1.23 | 1.74 | 2.97 | 26.2% | 23.2% | 50.6% | 1.69 | 34.8% |
| allOutAttack | 1.46 | 2.15 | 3.61 | 22.9% | 23.0% | 54.0% | 1.71 | 48.0% |
| parkTheBus | 0.84 | 1.49 | 2.33 | 21.8% | 25.3% | 52.8% | 1.62 | 21.0% |
| highPress | 1.32 | 2.34 | 3.66 | 18.7% | 19.2% | 62.1% | 1.78 | 49.8% |
| possession | 1.14 | 1.73 | 2.87 | 23.8% | 24.4% | 51.8% | 1.62 | 31.9% |
| counter | 1.01 | 1.47 | 2.48 | 26.7% | 25.6% | 47.8% | 1.68 | 24.1% |
| wide | 1.45 | 2.03 | 3.49 | 26.0% | 22.5% | 51.5% | 1.78 | 45.0% |

### weaker 80v74

| Cell | GF | GA | Total | Win | Draw | Loss | GD sd | 4+ goals |
|---|---|---|---|---|---|---|---|---|
| neutral | 1.40 | 1.02 | 2.42 | 46.4% | 25.3% | 28.3% | 1.66 | 22.1% |
| allOutAttack | 2.07 | 1.68 | 3.75 | 47.6% | 22.8% | 29.5% | 1.81 | 50.7% |
| parkTheBus | 0.89 | 0.62 | 1.51 | 39.1% | 37.0% | 23.9% | 1.27 | 7.4% |
| highPress | 1.54 | 1.29 | 2.82 | 43.1% | 24.1% | 32.8% | 1.79 | 30.9% |
| possession | 1.70 | 1.06 | 2.76 | 52.3% | 22.9% | 24.9% | 1.77 | 29.4% |
| counter | 1.19 | 0.75 | 1.94 | 46.1% | 29.3% | 24.7% | 1.48 | 13.4% |
| wide | 1.61 | 1.24 | 2.84 | 46.1% | 23.1% | 30.8% | 1.82 | 31.2% |

### weaker 80v74, countering AI (predictability 1)

| Cell | GF | GA | Total | Win | Draw | Loss | GD sd | 4+ goals |
|---|---|---|---|---|---|---|---|---|
| neutral | 1.42 | 1.04 | 2.46 | 46.5% | 25.0% | 28.5% | 1.68 | 22.9% |
| allOutAttack | 1.94 | 1.67 | 3.60 | 44.9% | 23.0% | 32.1% | 1.82 | 48.4% |
| parkTheBus | 0.91 | 0.66 | 1.57 | 39.1% | 35.9% | 25.1% | 1.30 | 7.8% |
| highPress | 1.58 | 1.54 | 3.12 | 39.4% | 22.5% | 38.1% | 1.86 | 37.0% |
| possession | 1.70 | 1.07 | 2.77 | 51.7% | 23.4% | 24.9% | 1.77 | 29.5% |
| counter | 1.07 | 0.76 | 1.82 | 41.9% | 31.3% | 26.8% | 1.45 | 11.6% |
| wide | 1.71 | 1.33 | 3.04 | 46.6% | 22.4% | 31.0% | 1.83 | 35.5% |

## Whole-career check (Task 9)

Date: 2026-10-17. Harness: `test/unit/match/tactics_career_lab_test.dart` (env-gated, `FNM_CAREER_LAB`). Each career is `careerService.create(nationId: 12 /* Czechia, world ranking 36 */, rngSeed: 1000 + k)` with the real nation and player data, the plan stored through `TacticService.setFormation` + `setInstructions` (as the tactics screen does), then `SeasonService.advance` (skip) until the first World Championship has a champion: one cycle, about 26-30 manager matches (continental qualifying, Euro, Nations Cup, World Championship qualifying and finals). Every manager match is therefore played by the skip path (`_withManagerTactics`). 200 careers per row, seeds 1000-1199, the same seeds for every plan and for both commits, so rows are paired. Run in 8 shards:

    FNM_CAREER_LAB=neutral,possession,highPress FNM_CAREER_LAB_CAREERS=200 \
      FNM_CAREER_LAB_MODE=skip FNM_SHARD=i/8 FNM_CAREER_LAB_OUT=build/career_lab \
      flutter test test/unit/match/tactics_career_lab_test.dart
    FNM_CAREER_LAB=report FNM_CAREER_LAB_OUT=build/career_lab \
      flutter test test/unit/match/tactics_career_lab_test.dart

About 8 s a career alone, 15-30 s with 8-16 shards sharing 8 cores; the whole check (2400 careers) took about 2 h of wall clock.

**Plans** (the match lab's `labPlans`): `neutral` (control), `possession` as the sensible committed plan (4-2-3-1, directness 20, tempo 40: positive GD in the equal and weaker After cells, and the best mean GD of any plan against a countering AI, -0.01 / +0.63 / -0.59), and `highPress` as the badly-judged one (the plan a countering side punishes hardest in the After tables: -0.46 a game at equal strength, 49% losses).

**Two modes, because a skipped match records no drilling.** Only `playPlayerMatch` calls `TacticFamiliarityRepository.recordMatch`, so a manager who skips everything never builds familiarity or predictability, `ScoutedPlan.fromDrilling` finds nothing, and the AI never counters him.
- `skip`: the app exactly as it is for a manager who skips every match. No counter.
- `drilled`: after each manager match the harness calls `recordMatch` with his shape and plan key, as the played path would, so the next match is countered as it would be for a manager who plays live and never changes plan.

**Baseline** ("today", before the build): the same test file run unchanged on 1574f85 in a separate worktree (only `test/helpers/tactics_lab.dart` reduced to the plan definitions, since the lab helper did not exist yet). The old skip path stores and applies the plan the same way (via `MatchEngine.planRatingDelta`, no opponent, no counter, predictability charged in chemistry).

Columns: WC qualify = in the World Championship finals; Euro finals = in the European Championship finals; WC KO = reached the WC knockout rounds; WC QF+ = quarter-final or better; W/D/L and goals over all the manager's matches (a shootout counts as a draw); Top-8 champion = share of careers whose world champion has a start ranking of 8 or better.

### After (feature/tactics-impact, cc2f385)

| Mode-plan | Careers | WC qualify | Euro finals | WC KO | WC QF+ | WC won | Win | Draw | Loss | GF/g | GA/g | Goals/g | Top-8 champion |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| skip-neutral | 200 | 28.5% | 88.5% | 10.5% | 0.0% | 0.0% | 49.6% | 20.0% | 30.5% | 1.40 | 1.03 | 2.43 | 69.5% |
| skip-possession | 200 | 44.5% | 93.5% | 19.5% | 0.5% | 0.0% | 55.2% | 15.8% | 29.0% | 1.71 | 1.09 | 2.80 | 73.0% |
| skip-highPress | 200 | 38.0% | 86.0% | 14.0% | 0.0% | 0.0% | 50.9% | 18.3% | 30.8% | 1.62 | 1.14 | 2.76 | 63.5% |
| drilled-neutral | 200 | 45.0% | 91.5% | 22.5% | 2.5% | 0.0% | 53.5% | 18.8% | 27.7% | 1.51 | 0.98 | 2.49 | 67.0% |
| drilled-possession | 200 | 58.5% | 94.5% | 29.5% | 0.5% | 0.0% | 58.4% | 15.2% | 26.4% | 1.79 | 1.01 | 2.80 | 72.5% |
| drilled-highPress | 200 | 42.5% | 88.0% | 13.5% | 1.0% | 0.0% | 53.4% | 16.3% | 30.3% | 1.75 | 1.21 | 2.96 | 65.5% |

### Before (1574f85)

| Mode-plan | Careers | WC qualify | Euro finals | WC KO | WC QF+ | WC won | Win | Draw | Loss | GF/g | GA/g | Goals/g | Top-8 champion |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| skip-neutral | 200 | 45.5% | 94.0% | 20.0% | 0.5% | 0.0% | 54.0% | 17.2% | 28.8% | 1.65 | 1.02 | 2.67 | 68.5% |
| skip-possession | 200 | 41.5% | 94.5% | 18.0% | 1.5% | 0.0% | 54.0% | 17.1% | 28.9% | 1.65 | 1.02 | 2.67 | 68.0% |
| skip-highPress | 200 | 61.0% | 97.5% | 39.5% | 1.0% | 0.0% | 58.3% | 15.8% | 25.9% | 1.76 | 0.93 | 2.69 | 75.0% |
| drilled-neutral | 200 | 52.0% | 94.5% | 27.5% | 1.0% | 0.0% | 56.8% | 16.3% | 26.9% | 1.71 | 0.96 | 2.68 | 69.0% |
| drilled-possession | 200 | 46.0% | 94.5% | 24.0% | 1.0% | 0.0% | 56.0% | 16.8% | 27.2% | 1.69 | 0.98 | 2.67 | 66.0% |
| drilled-highPress | 200 | 61.0% | 97.5% | 43.0% | 1.5% | 0.0% | 59.5% | 15.8% | 24.7% | 1.79 | 0.90 | 2.70 | 76.0% |

### Paired differences (same seeds; mean ± standard error over 200 careers)

| Comparison | GD per game | WC qualify |
|---|---|---|
| skip: possession - neutral | +0.255 ± 0.014 | +16.0 ± 4.0 pp |
| skip: highPress - neutral | +0.108 ± 0.015 | +9.5 ± 4.0 pp |
| skip: highPress - possession | -0.147 ± 0.014 | -6.5 ± 3.9 pp |
| drilled: possession - neutral | +0.241 ± 0.013 | +13.5 ± 4.1 pp |
| drilled: highPress - neutral | +0.012 ± 0.016 | -2.5 ± 4.0 pp |
| drilled: highPress - possession | -0.229 ± 0.015 | -16.0 ± 4.3 pp |
| skip-neutral: after - before | -0.263 ± 0.015 | -17.0 ± 4.2 pp |
| drilled-neutral: after - before | -0.216 ± 0.013 | -7.0 ± 4.5 pp |
| skip-possession: after - before | -0.002 ± 0.012 | +3.0 ± 3.6 pp |
| drilled-possession: after - before | +0.063 ± 0.013 | +12.5 ± 3.9 pp |
| skip-highPress: after - before | -0.350 ± 0.015 | -23.0 ± 4.1 pp |
| drilled-highPress: after - before | -0.345 ± 0.016 | -18.5 ± 4.6 pp |

Per-career GD a game: after skip neutral +0.363, possession +0.618, highPress +0.471; drilled neutral +0.528, possession +0.769, highPress +0.540. Before skip +0.626 / +0.620 / +0.821; drilled +0.743 / +0.706 / +0.885.

### Against the expectations

| Expectation | Result |
|---|---|
| Neutral below today's baseline | **Met.** -0.26 GD a game and -17 pp WC qualification skipped; -0.22 and -7 pp drilled. |
| Sensible plan >= neutral | **Met.** Possession +0.24 to +0.26 GD a game and +13.5 to +16 pp WC qualification over neutral, in both modes. |
| Bad plan clearly worst | **Not met.** High press is clearly below possession (-0.15 / -0.23 GD a game) but not below neutral: +0.11 GD and +9.5 pp qualification when skipped, level when drilled (+0.01 GD, -2.5 pp qualification, WC knockouts 13.5% vs 22.5%). Neutral is the worst plan of the three in the skip mode. |
| World top-8 winner share unchanged | **Met within noise.** 68.5% after vs 70.4% before over all 1200 careers each (±1.3 each); per-row shares (63.5-76%) are 200-career noise (±3.3). |

Reading it: the build removed today's "high press is free" (it was the best plan before, +0.20 GD a game over neutral when skipped) and made neutral costly, but over a Czechia career the press is not punished below neutral. Two reasons visible in the code: in a skip-only career no drilling is recorded so nothing is countered at all, and when it is drilled most of Czechia's opponents (qualifying, Nations Cup) are weaker sides whose read quality is scaled down towards its 0.3 floor (`AiCounter.read`: quality `(strength - 60) / 30`), while the match lab's "countering AI" cells read at predictability 1 and full quality. Not retuned here (Task 9 is measure-only); flagged for the controller.

### Device playtest checklist

- [ ] Live match, all-out attack: feels wild (chances both ways, big scorelines possible, not routs every game).
- [ ] Live match, park the bus: feels tight (few chances, 0-0 / 1-0 games, hard to lose and hard to win).
- [ ] Live match, high press: gets caught on the break by a direct, pacey opponent (goals conceded from balls in behind).
- [ ] Same plan for many matches in a row: opponents visibly counter it (their setup shifts against it; results get harder).
- [ ] Changing plan escapes the counter (the next opponents stop answering the old plan).
- [ ] Skipped matches tell the same story as played ones for the same plan (all-out attack skipped still produces open scorelines).
- [ ] Skip-only career: decide whether skipped matches should add to drilling/predictability (today they do not, so a manager who skips is never countered).
