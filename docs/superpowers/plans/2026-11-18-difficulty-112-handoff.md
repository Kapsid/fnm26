# Difficulty 1.1.2: handoff

Branch: `feature/difficulty-112` (off `main` 25374896). Last commit: `wip: difficulty 1.1.2 ...` (96a4b858). Not pushed, not merged.

Spec with the final magnitudes and the full lab table: `docs/superpowers/specs/2026-11-18-difficulty-112-design.md`.

## Original brief (verbatim content)

### Why
Players report that a human manager with a near-top nation (Serbia, Turkey, Canada; best XI ~78-81) wins the World Championship too easily, even in cycle 1. The owner wants a GENTLE change: titles for such sides should take a few cycles of building, not be routine in cycle 1. Elite and minnow sides must feel unchanged. The AI-v-AI world must not change.

### Investigation already done
Lab (one-off neutral knockout incl. ET+pens, win prob of the weaker side):
- AI-v-AI WC KO: 80v88 = .08, 80v84 = .26.
- Manager played "typical" (0.75 drilled + good scout): 80v88 = .38, 80v84 = .48.
- "hot+smart" (good condition, team talks, best plan): 80v88 = .51, 80v84 = .59.
- Skipped knockouts were also kind: .62 at equal strength vs .54 played.

Original lab files are throwaways in a local scratchpad (`zz_ko_lab_test.dart`, `zz_ko_lab2_test.dart`, env switches BIG, SYM, HS). Their content now lives in `test/helpers/knockout_lab.dart`. Existing harness: `test/helpers/difficulty_lab.dart`, `test/unit/match/mid_tier_difficulty_test.dart`, `lib/domain/services/match/mid_tier_difficulty.dart` (the model for a manager-only, both-paths, dithered, salted hidden term).

### Key code locations
- Played seam: `MidTierDifficulty.chemistryByNation` at `lib/features/match/match_providers.dart` (~593). It had the manager key only.
- Skipped seam: `lib/features/hub/hub_providers.dart` (~2007, `MidTierDifficulty.skippedStrength`) and `SeasonService._withManagerTactics`.
- AI WC knockout finals edge: `hub_providers` `_worldFinalsEdge`, applied only when neither side is the manager's. Related: `match_simulator.dart` stretch 1.5; world_pedigree cap 2.5; `finalsKnockoutEdge` = 0.5×gap + pedigree diff; `knockoutWeight = exp(0.1·s)` used in decideKnockout.
- Live shootout: `match_screen.dart` (~1164) passed no strength pair. Composure comes from the ET half-time talk (×0.94..×1.08).
- Team talks: `match_engine.dart` (~223).
- Host crowd: `match_engine.dart` (~785, +3/+2 × atmosphere). Background finals pass `homeAdvantage:false` even for the host.
- Condition: `match_providers` (~446) and `condition.dart` (net clamp −9..+6). Base camp adds +1..+3.
- Game-time development: `player_lifecycle.dart` `withCareerDev` (+round(√starts × 0.30 × tier × potential × club-minutes), cap +3). Only the manager's reads pass starts.
- Youth intake: `player_lifecycle` intake (`0.56 + rng×0.38 + bonus`, clamp 0.40..1.05). Totals are in `federation_providers.dart` `youthBonusByCycleProvider` (academy ≤0.18, skill 0.01/level ≤0.15, assistant 0.025-0.04, standing −0.04..+0.06). Skill and assistant used to be applied to EVERY cycle 0..now.

### Items (owner approved all)
All new rules apply only to cycles carrying a per-cycle `draws_watched` marker, written at cycle rollover for new cycles. With no marker every new factor is exactly 1.0 / 0, there are no new RNG draws, and results are byte-identical.

Match day (the manager's matches only):
1. Big-game knockout term at WC and continental finals knockouts when the opponent is stronger: manager ×(1−s·gap), opponent ×(1+s·gap) on the chemistry seam, with s growing by round, plus pedigree. A skipped twin is required, calibrated so that played and skipped land within ~0.02.
2. The live shootout gets a mild strength lean.
3. Host crowd for his side at finals: atmosphere ~×0.5.
4. Condition net positive cap in finals knockouts goes from +6 to +3.
5. Team talks' positive effect ~30% smaller; shootout composure cap ×1.04.
6. Mid-tier band widened: bandHigh 78 → 81, eliteEdge 84 → 87.

Growth (the manager's nation only):
7. Youth intake total bonus capped at +0.10 for marked intakes. Skill and assistant are credited only from the cycle they were acquired.
8. Game-time development coefficient 0.30 → 0.22 and cap 3 → 2, for starts banked in marked cycles.

TARGET: a well-run 80 vs 88 finals KO ≈ .25-.30 (from .51); vs 84 ≈ .45 (from .59); typical 80v88 ≈ .20-.25. Equal-strength, elite and minnow behaviour essentially unchanged. Keep it gentle.

## Hard rules
- Everything is marker-gated. Unmarked cycles stay byte-identical; never shift an existing RNG stream, and new draws get new salts. (None were needed: the skipped twin uses the simulator's real-valued `strengthEdge`, not a dither.)
- The AI-v-AI world is unchanged. Only the manager's fixtures read the marker (`_playBackground` checks `managerFixture` first).
- Saves stay safe: no schema bump, only new `draws_watched` rows. Any persisted shape change needs a real old-save upgrade test.
- Riverpod without codegen; build_runner needs `--force-jit`.
- No user-facing copy was added. If any is added: all 28 ARBs, `flutter gen-l10n`, `dart run tool/export_copy.dart`, CRLF copy/strings.csv, no em dashes, never "World Cup" in English.
- Tests run with `TZ=Europe/Prague`. If `flutter test` rewrites pubspec.lock, `git checkout pubspec.lock`.

## Marker
- Name: `difficulty2` (`BigGameDifficulty.kind`). Read through `isDifficulty2(comp, careerId, cycle)` in `lib/domain/services/match/big_game_difficulty.dart`.
- Written at `CareerService.create` (cycle 0, param `difficulty2`, default true; tests pass false for old behaviour: `pinned_world_test`, `seeded_save.dart`) and in `season_rollover.dart` for every new cycle.
- Youth hand records: kinds `difficulty2.youthHand:<cycle>:<permille>` (`GrowthDifficulty`). Written by `stampYouthHand` (`lib/features/federation/youth_hand.dart`) at creation, at rollover, after a youthDevelopment skill point and after an assistant hire (`manager_providers.dart`).
- Read in:
  - `match_providers.dart` (`hard`, played seam)
  - `hub_providers.dart` (`_difficulty2` cache, skipped seam and `_bigGameEdge`)
  - `federation_providers.dart` (youth bonus)
  - `drift_competition_repository.careerStartsByPlayer` (marked starts → `CareerStarts.marked`)

## Status per item
1. DONE. `BigGameDifficulty.term` with slope [0.008, 0.010, 0.011] by stage (R32/R16, QF, SF/3RD/FINAL; C-prefixed continental the same), 0.010 per pedigree point, cap 0.13. It is weighted by the manager's XI rating: 0 at ≤62, full 70-82, 0 at ≥87, with smoothstep ramps. The weight was added because without it minnows lost about half their KO chance. Played: `withTerm` on the chemistry map (an opponent key is added). Skipped: `_bigGameEdge` → `strengthEdge = -65×term`, which also leans ET/pens.
2. DONE. `shootoutWeight = exp(0.05×XI mean)`, any knockout in a marked cycle, carried via `MatchPreview.shootoutWeights`.
3. DONE. `MatchPreview.atmosphereScale` 0.5 when he hosts a finals round.
4. DONE. In `match_providers`, `conditionDeltas` are capped at +3 in a marked finals KO.
5. DONE. `MatchEngine.play(talkScaleByNation:)` scales only positive swings; `MatchPreview.composureCap` 1.04.
6. DONE. `MidTierDifficulty` `wide:` parameter (bandHighWide 81, eliteEdgeWide 87), passed on both paths.
7. DONE. Cap 0.10 (`GrowthDifficulty.cappedIntake`). Per-cycle recorded hand (the best seen in the cycle, else the last earlier record). Unmarked cycles keep the old rule.
8. DONE. `withCareerDev(markedStarts:)` = max(old rule on unmarked starts, blended coefficient on all starts capped at 2). It never drops below what was already earned.

## Measured lab (QF; before -> after)
| | typical played | well-run played | typical skipped |
|---|---|---|---|
| 80v88 | .373 -> .207 (target .20-.25) | .509 -> .287 (target .25-.30) | .216 -> .079 |
| 80v84 | .468 -> .352 | .585 -> .472 (target ~.45) | .418 -> .300 |
| 80v80 | .541 -> .535 | .664 -> .656 | .621 -> .609 |
| 88v84 / 88v88 | .603 -> .609 / .551 -> .551 | .750 -> .748 / .675 -> .667 | unchanged |
| 60v70 | .328 -> .319 | .487 -> .472 | unchanged |

Played vs skipped deltas: -.116 vs -.118 at 80v84, but -.166 vs -.137 at 80v88. The 80v88 gap is .03, slightly outside the ~.02 aim. Most of it is the new live-shootout lean, which the skip path already had. A hosting side with +6 condition drops more (60v70 .601 -> .494) from items 3+4. The full table is in the spec.

## Left to do
- **Known failure (investigate first):** `test/unit/hub/skip_records_drilling_test.dart` "skipped knockouts (extra time) and finals matches record once each" fails with "no knockout went to extra time". It is probably seed-dependent: the new career is now marked, so its skipped KOs moved. The likely fix is to pass `difficulty2: false` to its career creation or pick another seed; check that the test intent survives.
- The targeted suite run was stopped at about 30 min (+882 passed, 1 failure, still running `test/unit/hub/end_of_cycle_has_a_next_action_test.dart`). It needs to be re-run to completion, then one full suite before a build. Other story/pinned tests that create new careers through `StoryDriver.start` may shift similarly; fix by passing `difficulty2: false` where a test pins old behaviour, or re-pin where the new behaviour is intended.
- Optional: tune `skipPointsPerUnit` (65) if a tighter played/skipped match at 8-point gaps is wanted (~75 closes 80v88 but overshoots 80v84).
- A device playtest of a near-top nation's first cycle.
- Update memory/notes after merge.

## Commands
```
# lab table (~5 min); FNM_KO_PAIRS=80:88,80:84 FNM_KO_STAGES=0,1,2 FNM_KO_EDGES=typical,hot,host
FNM_KO_LAB=1 TZ=Europe/Prague flutter test test/unit/match/big_game_difficulty_lab_test.dart
# new tests
TZ=Europe/Prague flutter test test/unit/match/big_game_difficulty_test.dart test/unit/player/growth_difficulty_test.dart test/unit/match/mid_tier_difficulty_test.dart test/unit/world_managers/pinned_world_test.dart test/story/difficulty2_old_save_test.dart test/story/difficulty2_world_test.dart
# targeted suites
TZ=Europe/Prague flutter test test/unit/match test/unit/player test/unit/world_managers test/unit/hub test/unit/federation test/unit/manager
git checkout pubspec.lock   # if rewritten
```
Pre-existing failures: `test/unit/pitch/tactical_style_test.dart`, `test/widget/preview_tactics_reach_kickoff_test.dart`.

Passing so far: all new tests above; `pinned_world_test` (unmarked byte-identical); `mid_tier_difficulty_test`; `calendar2_old_save_test` was in the stopped run (unverified).
