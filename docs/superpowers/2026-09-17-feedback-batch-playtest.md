# Device playtest list — 2026-09-17 feedback batch

Consolidated from every task's report. This is what tests could not settle.
Task 24 (the standing-pass playtest) was folded into this list rather than run separately.

## 1. Balance — the four standing changes, and tactics

These are the only changes that alter how a career FEELS. Tuned and guarded,
but a guard only proves direction and bounds.

- **Does winning something move you visibly?** A champion from 25th should land
  around 6th on a played-in table, 5th in a save's first cycle. Not 1st.
- **Does the youth intake improve as you rise?** Deliberately a nudge for a
  mid-table climb (~+0.6 overall an intake). If it reads as invisible, the dial
  is `IntakeStanding.fullClimbPoints` — but only move it after watching real
  rank movement, since placings now award points directly.
- **Does the budget change enough to notice without breaking?** Band is EUR 9.0M
  to 19.2M, anchored at 12.0M. The floor is guarded to clear an elite staff
  wage bill (EUR 8.4M), so you cannot be bankrupted by one bad cycle.
- **Does a drilled shape feel different from a scattered one?** A settled,
  well-judged side is worth about a goal every three games. Before this batch
  the dials measured BELOW the noise floor — picking the textbook counter left
  you marginally worse off than not bothering.
- **Scorelines** after the width fix: a full width mismatch now adds ~0.47
  goals to a 2.5 baseline, down from ~0.87.

## 2. Things a test cannot see

- **The World Championship final in passive simulation.** The fix covers the
  round BEFORE the final (the third-place play-off), which vanished when you
  reached the final yourself. Across 54 simulated career-cycles the final
  itself was always shown. IF YOUR SAVE SHOWED THE FINAL ITSELF VANISHING,
  that is a different bug and I need to know.
- **"Matchday" in the Nations Cup item** was read as the LEAGUES view, because
  there is no separate Nations Cup matchday screen. Confirm that is the view
  you meant.
- **The inbox is busier.** The transfer report went from a handful of rows to
  ~15 a year, because 82% of moves were previously invisible.
- **The development report popup** is now 12 slots rather than 10 rows.

## 3. Width and legibility — the test font is ~40% pessimistic

Measurements in tests use a font that draws every glyph a full em wide; the real
face is ~0.6em. So these are the places where a marginal test result may or may
not be real on glass:

- The Y feed row shrinks the longest account name to roughly 40-45% on a real
  device. Legible or not is a human call.
- Band words on the tactics formation tiles draw at 9px.
- The player-of-the-year card's award label now wraps to two lines.
- The nation vitrine and record book carry the active-player badge beside a long
  Czech name, covered only by a source guard.
- The staff card gained a line per row, so it grew vertically.
- The dashboard gained a provider read that sorts every nation. First thing to
  check if the dashboard feels slow.

## 4. Copy to read in Czech

- `teamOverall` is "Celkový přehled" — a mistranslation meaning "overall
  summary" rather than "overall". It is the cause of the match-preview label
  being tight in Czech.
- "Misses 1/3" on the call-up row is deliberately terse to survive 360px.
- Czech dates now render properly with the ordinal full stop. Worth a look.

## 5. Standing questions for you, not bugs

- **Familiarity only grows in a match you WATCH.** So a manager who drills a
  shape for four years and then skips everything keeps peak familiarity and
  never accrues predictability. Coherent, but a decision.
- **Staff are near-cosmetic.** A full elite staff room is worth about +1 rating
  point, the Chief Scout does literally nothing for EUR 400k-2.8M a cycle, and
  `Staff.familiarityGain` is defined and wired to nothing. You chose to show the
  truth now and make staff matter later; this is the content of that work.
- **`initialBudget` has a step cliff** — ninth place opens EUR 15M poorer than
  eighth.
- **Condition, morale, captaincy and staff still do not reach a skipped match.**
  Now the only remaining asymmetry, and proportionally bigger than before.

---

# Open work this batch found but did not do

Each of these was found while fixing something else, reviewed, and deliberately
left. They are specified well enough to pick up cold.

## 1. Make the staff room matter

The batch's biggest honest finding. Today:
- the **Chief Scout does literally nothing** at any tier, for EUR 400k-2.8M a
  cycle. `Staff.capsToKnow` is defined and never called;
- a full elite staff room is worth about **+1 rating point** in a match, and the
  only effect a match feels is the injury rate;
- **both** familiarity-gain seams in the game are dead: `Staff.familiarityGain`
  AND `ManagerSkills.familiarityGain` (manager_skills.dart:78, tested but with
  no caller in `lib/`). Tactical familiarity is bumped only by match usage.

Two false blurbs were corrected during the batch (the scout's "tells you what a
young player will become, sooner", and the assistant's promise from a
training-focus mechanic that no longer exists), so the app no longer lies about
this. But the original feedback, "chybi mi jasny vliv zamestnancu", is NOT
answered by this branch. Wiring those two dead seams is the content of the work.

## 2. Settle whether a continental round of 32 exists, then migrate the copies

`match_preview_screen.dart:35` and the knockout set in `match_providers.dart`
carry `'CR32'`; `FinalsRounds.continental` does not. Separately,
`stats_providers.dart` `_finalsRounds` carries `'NGROUP'`, which
`FinalsRounds.nationsCup` does not. Two copies have already diverged.

Settle the question, then migrate the remaining round-set copies. The map in
`lib/domain/services/competition/finals_participation.dart` names every one of
them by symbol.

## 3. Guard the watched-versus-skipped balance

The engine half of the tactics work is protected by a harness with a null
control and two-sided bands. The background half has a single-seed directional
check. The final review measured them and they agree (worst gap 0.075 GD/game,
no systematic direction), but nothing pins that. That asymmetry is how a stale
test expectation survived eight tasks earlier in this batch.

## 4. Decide: familiarity grows only in a match you WATCH

`recordMatch` is called from `_playPlayerMatch` only. So a manager who drills a
shape for four years and then skips everything keeps peak familiarity AND never
accrues predictability: permanently drilled, permanently unread. Now that
skipped matches honour the stored figure, this pays out every match instead of
never. It needs a decision, not just a fix.

## 5. The pre-match panel shows a ceiling, not what you get

`StrengthFactors._familiarity` computes the drilled bonus with predictability at
zero, because predictability is deliberately hidden. But every match, watched or
skipped, applies the discounted figure. At rating 70 the panel reads +6 and the
engine applies +3, and the gap GROWS with tenure. Either label the line as a
ceiling, or show the true figure and accept that predictability becomes
derivable by subtraction.

## 6. Smaller, specified

- `_generateContinentalFinals` has no "never in the past" anchor where
  `_generateFinals` does. If a confederation's qualifying overruns, its whole
  cup resolves in one catch-up.
- `SeasonService.skipToChampion` is dead (~45 lines, no caller anywhere). Dead
  before this batch, not orphaned by the in-match skip removal.
- `copy/strings.tsv.backup` is tracked, dated 24 Aug, and holds 1,916 rows
  against today's 2,147. Anyone who trusts it loses 230 strings. **Needs the
  owner's call: delete, or regenerate.**
- `Player` carries no shirt number, so a lineup disc shows the position rating.
  A real team sheet shows a squad number and a surname.

# Two things that cannot be fixed, only known

- **Honour rows already written in an affected save keep a nameless golden
  boot.** The name was never recorded; nothing can recover it. Correct from this
  branch forward only.
- **The World Championship final in passive simulation:** across 54 simulated
  career-cycles the final itself was always shown. What is demonstrably lost is
  the third-place play-off immediately before it, which produces the same felt
  shape. The fix covers both competitions' finals either way, but if your save
  showed the FINAL itself vanishing, that is a different bug.
