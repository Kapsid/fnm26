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

