# Tactics That Bite Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the manager's tactical choices visibly move his match outcomes (open vs tight games, real risk on pressing, AI that counters his recent plans, no safe neutral) while squad quality still decides most matches.

**Architecture:** All changes land in the manager-match path: `MatchEngine` (live/played matches), `AiTactics` (the opponent's setup), and the skip conversion in `hub_providers.dart` `_withManagerTactics` plus an optional `openness` input on `RatingMatchSimulator`. A simulation "lab" (env-gated test) measures a plan grid before and after; guard tests pin the tuned bands. Background AI-vs-AI matches are untouched.

**Tech Stack:** Dart / Flutter, flutter_test, Riverpod, drift. Codegen (if ever needed) runs with `dart run build_runner build --force-jit`.

**Spec:** `docs/superpowers/specs/2026-10-16-tactics-impact-design.md`

## Global Constraints

- Background world results must not move: `RatingMatchSimulator.simulate` with no `openness` argument behaves byte-for-byte as today; `test/unit/match/world_variance_test.dart` and the `RatingMatchSimulator balance` group in `match_balance_test.dart` pass unchanged.
- No schema change (the AI reads the existing `tactic_familiarities` `predictability` + `lastPlanKey`).
- No new screens. No new user-facing copy unless unavoidable; if any, all 7 ARBs + `dart run tool/export_copy.dart`, and NO em dashes.
- Squad quality still dominates: a 10-point-better squad on a bad plan still wins more than it loses.
- Counter reads RECENT plans only (stored history), never the plan set for this match or in-match changes.
- Predictability is charged once: removed from `TeamChemistry.factor`, used only for counter sharpness.
- Simulation cells: ≥2000 matches each, every seed played both ways round (see the venue-parity note in `tactics_swing_test.dart` `swing()`), neutral venue.

## Review Focus

1. A manager with NO history (new career, or new nation): the AI must play its normal style-based setup, never crash on missing `tactic_familiarities` rows or `lastPlanKey == 0`. → test in Task 6.
2. A decoy plan: changing the plan right before kick-off must not change the AI's counter (it reads stored history only). → test in Task 6.
3. Skipping vs playing the same plan: the plan's effect against neutral must match within 3pp win rate. → test in Task 7.
4. Short-handed / exhausted sides with extreme plans: openness and press terms must not blow scorelines up (4+ goal margins between equals stay rare, ≤ today's rate + a little). → test in Task 3.
5. AI formation change producing an XI from a thin pool (injuries, suspensions): `bestEleven` must still fill 11 slots. → test in Task 6.

---

### Task 0: Branch and baseline lab

Pending uncommitted fixes on `main` (import gate, friendly draw kind, record rows, shootout copy, version 1.0.5+9) are committed on `main` first as their own commit, then branch.

**Files:**
- Create: `test/helpers/tactics_lab.dart`
- Create: `test/unit/match/tactics_lab_test.dart`
- Create: `docs/superpowers/specs/2026-10-16-tactics-lab-results.md`

**Interfaces:**
- Produces:
  - `typedef LabPlan = ({String name, Formation formation, TacticalInstructions instructions});`
  - `const List<LabPlan> labPlans` — at least: `neutral` (4-3-3, all 50), `allOutAttack` (4-2-4, mentality 90, line 75, tempo 75), `parkTheBus` (5-4-1, mentality 15, line 25, pressing 30), `highPress` (4-3-3, pressing 90, line 80, tempo 70), `possession` (4-2-3-1, directness 20, tempo 40), `counter` (4-1-4-1, mentality 35, directness 80, line 30, tempo 70), `wide` (3-4-3, width 85).
  - `typedef LabStats = ({double gf, double ga, double total, double win, double draw, double loss, double gdSpread, double fourPlus});`
  - `LabStats runCell({required LabPlan manager, required double managerRating, required double opponentRating, required bool aiCounters, int seeds = 1000, double familiarity = 0, double predictability = 0})` — manager side vs an opponent whose setup comes from `AiTactics.forOpponent` (and, once Task 6 lands, the counter when `aiCounters`); every seed played both ways round; neutral venue.
  - `String labTable(Map<String, LabStats> rows)` — markdown table.

- [ ] **Step 1:** `git add -A && git commit` the pending main fixes ("fix: import gate, friendly draw kind, record rows, shootout copy; 1.0.5+9"), then `git checkout -b feature/tactics-impact`.
- [ ] **Step 2:** Write `tactics_lab.dart` (build XIs with `player(...)`/`flatAttributes` from `test/helpers/fixtures.dart`, slot positions from the formation, uniform rating = the cell's rating).
- [ ] **Step 3:** Write `tactics_lab_test.dart`: one test `'lab report'`, `skip: Platform.environment['FNM_LAB'] == null ? 'set FNM_LAB=1' : false`, which runs every plan × opponent rating {equal 80v80, stronger opp 80v86, weaker opp 80v74} at 2000 seeds and prints `labTable`. Also one always-on sanity test: `runCell(neutral vs equal, seeds: 50)` returns win+draw+loss == 1.
- [ ] **Step 4:** Run `FNM_LAB=1 flutter test test/unit/match/tactics_lab_test.dart` and paste the table into the results doc under "Baseline (before)".
- [ ] **Step 5:** `flutter test test/unit/match/tactics_lab_test.dart` (sanity passes, lab skipped). Commit "test: tactics lab harness + baseline".

### Task 1: Shape counts

**Files:**
- Create: `lib/domain/services/match/shape_profile.dart`
- Modify: `lib/domain/services/match/match_engine.dart` (`_attack`, `_defence`)
- Test: `test/unit/match/shape_profile_test.dart`

**Interfaces:**
- Produces: `abstract final class ShapeProfile { static ({double attackers, double defenders}) of(List<PlayerPosition> slots); static const double neutralAttackers; static const double neutralDefenders; }` — attackers: st/lw/rw = 1.0, am = 0.5, lm/rm = 0.25; defenders: cb/lb/rb = 1.0, dm = 0.5. Neutral = the 4-3-3 values.
- Produces engine constants `kShapeAttack`, `kShapeDefence` (rating points per attacker/defender off neutral; attacking shape also costs at the back and vice versa via `kShapeAttackCost`, `kShapeDefenceCost`).

- [ ] **Step 1: Tests** `ShapeProfile.of(Formation.f424.positions).attackers > ShapeProfile.of(Formation.f433.positions).attackers > ShapeProfile.of(Formation.f541.positions).attackers`, and the reverse order for defenders. Engine test: identical XIs, all-50 instructions, 4-2-4 vs 4-3-3 over 2000×2 seeds → 4-2-4 side has higher goals FOR and higher goals AGAINST than the 4-3-3 side; 5-4-1 lower on both.
- [ ] **Step 2:** Run, see fail.
- [ ] **Step 3:** Implement. `_Live` already holds `slots`; compute the profile once per side (and again after a formation `TacticalChange`). Add `(attackers - neutral) * kShapeAttack` to `_attack` and subtract `(attackers - neutral) * kShapeAttackCost` in `_defence`; symmetric for defenders. Start values: `kShapeAttack 4.0`, `kShapeAttackCost 2.5`, `kShapeDefence 4.0`, `kShapeDefenceCost 2.5` (Task 8 tunes). Extend `planRatingDelta` to take the formation (`planRatingDelta(TacticalInstructions i, {Formation formation = Formation.f433})`) using the same constants.
- [ ] **Step 4:** Run shape tests + `flutter test test/unit/match` (existing guards may drift; note failures, do not re-pin yet — Task 8 owns re-pinning).
- [ ] **Step 5:** Commit "feat(engine): formation shape counts in attack and defence".

### Task 2: Mentality costs what it gains

**Files:** Modify `match_engine.dart` (`kMentalityDefence`); Test: add to `test/unit/match/shape_profile_test.dart`'s sibling `test/unit/match/tactics_tradeoffs_test.dart` (create).

- [ ] **Step 1: Test** `'all-out mentality concedes clearly more'`: identical sides, mentality 90 vs 50 → the 90 side's goals AGAINST per game ≥ 1.25× the neutral mirror's.
- [ ] **Step 2:** Run, fail.
- [ ] **Step 3:** `kMentalityDefence` 0.18 → 0.28 (start; Task 8 tunes toward attack ≈ cost while keeping attacking a slight net positive against a passive side).
- [ ] **Step 4:** Run, pass. Commit "feat(engine): attacking mentality costs at the back".

### Task 3: Openness — bold plans make wild games

**Files:** Modify `match_engine.dart` (`_chance` call sites); Test: `tactics_tradeoffs_test.dart`.

**Interfaces:**
- Produces: `static double openness({required TacticalInstructions home, required TacticalInstructions away, required double homeAttackers, required double awayAttackers})` on `MatchEngine` — a multiplier ≥ ~0.7 and ≤ ~1.45 applied to BOTH sides' chance rate each minute (after the clamp, alongside `damping`). Driven by both sides' mentality, pressing and shape attackers off neutral. Public and static so Task 7 reuses it.

- [ ] **Step 1: Tests** (2000×2 seeds, identical 80-rated XIs):
  - `'two attacking sides play a wild game'`: allOutAttack vs allOutAttack total goals ≥ 1.4× neutral vs neutral.
  - `'two buses play a tight one'`: parkTheBus vs parkTheBus total ≤ 0.7× neutral.
  - `'openness never turns equals into routs'`: allOutAttack vs allOutAttack share of 4+ goal margins ≤ 6%.
  - `openness(neutral, neutral, 4-3-3, 4-3-3) == 1.0` exactly.
- [ ] **Step 2:** Run, fail.
- [ ] **Step 3:** Implement and apply at both `_chance(...)` calls (the live instructions, so in-match changes count).
- [ ] **Step 4:** Run, pass. Commit "feat(engine): open and closed games from both sides' plans".

### Task 4: Pressing as risk and reward

**Files:** Modify `match_engine.dart` (`_matchup`, `_defence`, energy drain at ~line 1860); Test: `tactics_tradeoffs_test.dart`.

- [ ] **Step 1: Tests:**
  - `'a high press creates more and concedes more'`: highPress vs neutral (equal) → press side has higher gf AND higher ga than neutral-vs-neutral baseline.
  - `'a press is punished by direct pace'`: highPress vs counter-plan side with forwards physical 90 vs press side defenders physical 70 → press side goal difference < its GD vs a slow possession side by ≥ 0.25.
  - `'pressing tires a side'`: mean energy at 90' for pressing 90 < pressing 50 by a clear margin (read via the existing energy series / result field the engine exposes; if none, assert on late-game (75'+) goals conceded share).
- [ ] **Step 2:** Run, fail.
- [ ] **Step 3:** Replace the flat `kPressingDefence` gain with: a turnover term in `_matchup` for the presser (attack bonus scaled by the opponent's low directness, as now) PLUS a new "space behind" term giving the OPPONENT an attack bonus scaled by `n(press)` × (opponent directness + pace duel); raise press energy drain (the `(i.pressing - 50) / 250` term) to `/150`. Keep `planRatingDelta` in sync.
- [ ] **Step 4:** Run, pass. Commit "feat(engine): pressing is a gamble".

### Task 5: Neutral is counterable (D)

**Files:** Modify `match_engine.dart` (`_matchup`); Test: `tactics_tradeoffs_test.dart`.

- [ ] **Step 1: Tests:**
  - `'a committed plan beats neutral on average'`: averaged over the opponent plans {counter, highPress, possession, wide}, each of those beats `neutral` (equal squads) by GD > 0.05.
  - `'every plan has a counter'`: for each `labPlan`, some other `labPlan` beats it by GD ≥ 0.15 (equal squads).
- [ ] **Step 2:** Run, fail.
- [ ] **Step 3:** Re-anchor `_matchup`: direct-vs-line uses `n(line) + 0.3` (a mid line is still exposed; only a deep line ≤ ~35 closes it); press-vs-build-up uses `(-n(directness) + 0.3)`; width terms treat a neutral 50 as half-stretched. Keep the ±clamp. Start offsets 0.3; Task 8 tunes.
- [ ] **Step 4:** Run, pass. Commit "feat(engine): no safe middle in the match-up".

### Task 6: The AI counters the manager's recent plans

**Files:**
- Create: `lib/domain/services/match/ai_counter.dart`
- Modify: `lib/domain/services/tactics/team_chemistry.dart` (drop predictability from `factor`; add `decodePlanKey`)
- Modify: `lib/features/match/match_providers.dart` (~lines 300-380)
- Modify: `lib/domain/services/match/ai_tactics.dart` (expose style flexibility)
- Test: `test/unit/match/ai_counter_test.dart`, update `test/unit/match/tactics_swing_test.dart` read-penalty case

**Interfaces:**
- Produces: `static TacticalInstructions TeamChemistry.decodePlanKey(int key)` (inverse of `planKey`, bands × 10; throws `ArgumentError` on 0).
- Produces: `typedef ScoutedPlan = ({Formation formation, TacticalInstructions instructions, double predictability});`
- Produces: `static ScoutedPlan? ScoutedPlan.fromDrilling(Map<Formation, ({double familiarity, double predictability, int lastPlanKey})> rows)` — the formation with the highest familiarity whose `lastPlanKey != 0`; null when none. (Extend `ShapeDrilling` with `lastPlanKey` in `tactic_familiarity_repository.dart` + the drift repo.)
- Produces: `abstract final class AiCounter { static AiSetup apply({required AiSetup base, required ScoutedPlan? scouted, required double opponentStrength, required NationStyle style, required int seed}); }`
  - `scouted == null` → returns `base` unchanged.
  - read = `(0.25 + 0.75 * predictability) * quality`, quality = `((opponentStrength - 60) / 30).clamp(0.3, 1.0)`.
  - Each slider moves from `base` toward the counter target by `read`: high scouted line → directness up; low scouted directness → pressing up; high scouted pressing → directness up; scouted wide → narrow and vice versa; scouted mentality ≥ 70 → mentality down + line down.
  - Formation change: only when the scouted shape's attackers/defenders are ≥1.0 off neutral; probability = `read × flex(style)` with flex: balanced/possession/counter 1.0, direct/physical 0.7, flair 0.5, defensive/highPress 0.4; seed-deterministic. Counter shape: many attackers → `f532`/`f541`; many defenders → `f433`/`f424` (pick by style).
- Consumes: `AiTactics.forOpponent` (unchanged signature), `ShapeProfile.of` (Task 1).

- [ ] **Step 1: Tests:**
  - `decodePlanKey(planKey(x))` equals x rounded to bands of ten, for several x.
  - `'no history, no counter'`: `apply(scouted: null)` returns base exactly.
  - `'a high line draws a direct opponent'`: scouted line 80, predictability 1, opponent 85 → result directness > base directness + 10.
  - `'a weak, rigid side barely reads you'`: opponent 60, style defensive → every slider within 6 of base and formation unchanged over 200 seeds ≥ 95%.
  - `'three up front meets a back five, sometimes'`: scouted 4-2-4, predictability 1, opponent 85, style balanced → over 500 seeds formation is f532/f541 in 40-90%.
  - `'the plan set for today is not read'` (provider-level, in `test/unit/match/ai_counter_test.dart` with a `ProviderContainer`): two previews of the same fixture, identical stored familiarity rows, different CURRENT manager instructions → identical AI setup.
  - `'a thin pool still fields eleven after a shape change'`: `bestEleven(Formation.f541, pool of 14 incl. only 3 defenders)` returns 11.
  - `TeamChemistry.factor(f, 1.0) == TeamChemistry.factor(f, 0)` (predictability no longer charged there).
- [ ] **Step 2:** Run, fail.
- [ ] **Step 3:** Implement `decodePlanKey`, `ScoutedPlan.fromDrilling`, `AiCounter.apply`; drop the predictability term from `factor` (keep the optional parameter for call-site compatibility, ignored, documented); in `match_providers.dart` load `drilling` BEFORE `AiTactics.forOpponent`, then `AiCounter.apply(...)` with seed `varietySeed('aicounter:$opponentId:${fixture.id}:${career.rngSeed}')`; pick the opponent XI from the countered formation. Update the read-penalty case in `tactics_swing_test.dart` to assert the new behaviour (factor ignores predictability).
- [ ] **Step 4:** Run `flutter test test/unit/match test/unit/career`. Commit "feat(ai): opponents counter the manager's recent plans".

### Task 7: Skipped matches tell the same story

**Files:**
- Modify: `lib/domain/services/match/match_simulator.dart` (`simulate` gains `double openness = 1.0`, multiplies both xG; default path untouched)
- Modify: `lib/domain/services/match/match_engine.dart` (`planRatingDelta` → also add matchup-vs-counter)
- Modify: `lib/features/hub/hub_providers.dart` (`_withManagerTactics` and its call site ~842)
- Test: `test/unit/match/skip_parity_test.dart`

**Interfaces:**
- Produces: `static ({double ratingDelta, double openness}) MatchEngine.planEffect({required TacticalInstructions plan, required Formation formation, required TacticalInstructions opponent, required Formation opponentFormation})` — flat terms (as `planRatingDelta`) + the instruction-only part of `_matchup` (pace/passing terms at neutral) for both directions halved into one scalar, and `openness(...)` from Task 3.
- `_withManagerTactics(careerId, nationId, strength, {required int opponentId, required int opponentStrength, required int fixtureId})` returns `({int strength, double openness})`; it builds the opponent's setup exactly as Task 6 does for a live match (`AiTactics.forOpponent` + `AiCounter.apply` with the same seed strings) and calls `planEffect`. Both sides' strengths are computed first, then the manager side converted; `sim.simulate(..., openness: effect.openness)`.

- [ ] **Step 1: Tests:**
  - `'the world is untouched'`: for 500 seeds, `simulate(h, a, rng)` == `simulate(h, a, rng, openness: 1.0)` score for score.
  - `'skip and play agree on what a plan is worth'`: for plans {allOutAttack, parkTheBus, highPress, counter} vs an `AiTactics` opponent of equal rating (with counter, predictability 0.5): (win% with plan − win% with neutral) played via `MatchEngine` vs skipped via `RatingMatchSimulator` + `planEffect` differ by ≤ 3pp; total-goals ratio vs neutral agrees within 15%.
- [ ] **Step 2:** Run, fail.
- [ ] **Step 3:** Implement; keep `_chemistryPoints` and `Staff.dossierBonus` as they are.
- [ ] **Step 4:** Run `flutter test test/unit/match test/unit/hub test/unit/career`. Commit "feat(skip): skipped matches carry the plan, the counter and the openness".

### Task 8: Tune and re-pin

**Files:** constants in `match_engine.dart`, `ai_counter.dart`; guards `test/unit/match/tactics_swing_test.dart`, `match_balance_test.dart` (MatchEngine group only), `scoreline_distribution_test.dart`; results doc.

Targets (spec, verbatim bar):
- allOutAttack vs neutral, equal: total goals +40-60%, goals against clearly up.
- parkTheBus vs neutral: total goals −30-40%.
- highPress: gf and ga both above neutral; worse vs direct pace, better vs slow possession.
- well-judged vs badly-judged, equal squads: 0.3-0.5 goals a game.
- neutral vs countering AI: measurably worse than baseline; a sensible committed plan beats neutral on average.
- 10-point-better squad on a bad plan still wins more than it loses.
- skip vs play plan effect within ~3pp.

- [ ] **Step 1:** Run `FNM_LAB=1 flutter test test/unit/match/tactics_lab_test.dart`; compare with targets; adjust constants; repeat until all targets hold. Record each round's table briefly in the results doc ("After" section, final table in full).
- [ ] **Step 2:** Add always-on guards to `tactics_lab_test.dart` (1000 seeds, wide bands): `'no dominant plan'` (no labPlan beats every other labPlan, equal squads), `'open beats closed on goals'`, `'squad still decides'` (80 bad plan vs 70 best plan → 80 wins > losses).
- [ ] **Step 3:** Re-pin `tactics_swing_test` bands to the new "0.3-0.5 goal" intent, update the MatchEngine group of `match_balance_test` and `scoreline_distribution_test` bounds to the measured values with the same relative slack they had. Update their header comments to say why (2026-10-16 tactics impact).
- [ ] **Step 4:** `flutter test` (full suite, expect ~11 min) all green; `flutter analyze` no new errors/warnings.
- [ ] **Step 5:** Commit "tune: tactics impact constants + re-pinned guards".

### Task 9: Whole-career check

**Files:** Create `test/unit/match/tactics_career_lab_test.dart` (env-gated `FNM_CAREER_LAB`), results doc.

- [ ] **Step 1:** Harness: `careerService.create(nationId: <Czechia>, rngSeed: s)` then advance with skips to the World Championship champion (pattern from the 2026-10-01 calibration; ≥200 careers, shardable by `FNM_SHARD=i/n`), with the manager's stored tactic set to {sensible committed plan, neutral, badly-judged}. Report qualify %, finals reached %, W/D/L in the manager's matches, goals/game.
- [ ] **Step 2:** Run for the three plans; paste into the results doc. Expected: neutral below today's baseline, sensible plan ≥ neutral, bad plan clearly worst, world top-8 winner share unchanged (± noise).
- [ ] **Step 3:** Commit "test: tactics career lab + results". Leave a "device playtest" checklist in the results doc (live match: all-out attack feels wild; bus feels tight; pressing gets caught on the break; same plan for many matches gets countered; changing plan escapes it).
