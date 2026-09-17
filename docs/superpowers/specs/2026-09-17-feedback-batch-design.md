# Feedback batch — 2026-09-17

**Date:** 2026-09-17
**Status:** approved design

## Problem

A play session on the current build (personas, expectation reading and the
active-scorer flag all included) produced 36 pieces of feedback. They fall into
three kinds, and the mix is the point:

* **Mechanics that already exist and are invisible.** Fatigue, club form,
  tactical familiarity and staff all move numbers in the engine today. None of
  them are shown, so the manager cannot tell whether any of it is doing
  anything — which reads as "it does nothing".
* **Rules that are implemented in one place and not enforced in another.**
  Absence is counted in matches and `SquadSelection.usableInPeriod` already says
  who may be named; the manual call-up screen and the XI do not all ask.
* **Recorded history with holes in it.** A co-hosted edition keeps one host, a
  2026 World Championship that is never crowned, scorer names that resolve to
  "Unknown" in future editions.

They are unrelated as features. They arrived together and are being fixed
together, as one batch on one branch.

## Decisions

- **One batch, one branch**, on top of a checkpoint commit of the press & Y
  work. Review at the end.
- **Türkiye stays.** It is the current official English name; the item is
  answered, not worked.
- **Only tactics gets stronger.** Fatigue, club form and staff are surfaced at
  their tuned magnitudes — the balance those numbers sit in was playtested
  recently and re-tuning four dials at once would make the playtest
  uninterpretable. Familiarity and the instruction effects get a bigger swing,
  because "zkoumat vliv taktik" is a complaint that the dial does not move.
- **WC 2026 is seeded, not simulated.** A fixed champion and its three co-hosts
  go into the pre-seeded history, which also exercises the co-host column.
- **Honours gain a schema bump.** Co-hosts are recorded, not re-derived: what a
  roll of honour holds must be what happened, not what a host-rotation function
  would say today.
- **Set-piece takers are automatic by default**, recomputed when the XI changes,
  overridable per duty.
- **The standing pass is one pass.** Ranking weight, youth intake and federation
  funds all key off the same thing — how the nation is doing — so they are tuned
  together and playtested together.

## A. Selection and availability

### The rule exists; not everyone asks it

`SquadSelection.usableInPeriod` (`squad_selection.dart:27`) already encodes the
rule the feedback asks for: a player is nameable when his ban or knock does not
cover *every* match the squad is being picked for. `call_up_screen.dart:231`
filters on `isAvailable` instead — the stricter, wrong question — and the XI has
a hole that let an injured man be fielded at all.

* The manual call-up screen asks `usableInPeriod` with the camp's real match
  count, so a man banned for one of three games travels.
* The XI gate is **debugged, not patched**: something let a player with
  `injuryMatches == 1` into the eleven for the very match he is missing. The fix
  follows the cause, wherever it is (a stale stored XI, a gate that reads the
  pool rather than the absence, an auto-pick that runs before absences load).
* Absence is already counted in matches everywhere in the model. The displays
  that still say otherwise are corrected to read "Suspended · 2 games".

### The substitution sheet is missing what the manager needs to see

A man already withdrawn, and a man carrying a knock, look exactly like everyone
else in the list. Both get a marker and are not selectable as an incoming
player; the outgoing list excludes anyone already off.

### A misclick is final

A change applied in the sheet cannot be taken back without leaving the screen.
The sheet keeps a pending change the manager can undo before it is committed.

### Set pieces

Penalties, free kicks and corners fill with the best available taker for each
duty, recomputed when the XI changes and when a taker leaves the field.
A manual pick sticks until its player is out of the side.

## B. Hidden effects, made visible

### A pre-match readout

One panel on the match preview that names what is moving the side's strength
right now, each line with its direction and size: tactical familiarity with this
shape, squad fatigue, club form coming into the camp, the staff room, morale,
the captain. The numbers are the ones the engine already uses — this reads them,
it does not invent a parallel model.

Fatigue before a camp and club form are the two the feedback names explicitly:
a tired man shows a minus, a man in form at his club shows a plus, and both are
legible before the manager picks rather than inferred afterwards from a bad
result.

### Familiarity you can see

The tactics screen shows, per formation, how drilled the side is in it — a bar
that fills as the same shape is fielded and decays when it is abandoned.
Predictability stays hidden: it is what the opposition knows, not what the
manager is told. That asymmetry is deliberate and survives this change.

### Tactics that bite

`TeamChemistry.drilledBonus` and the instruction effects in the engine are
widened so the difference between a drilled, well-judged plan and a careless one
shows up in results. Both simulators move together — `match_engine` and
`match_simulator` are tuned as a pair or live and background football desync.

### Staff you can feel

Each hire states its effect in the terms the manager already understands
(training gain, injury risk, scouting reach, press handling), on the staff
screen and in the pre-match readout.

## C. Press and the feed

### The feed is quiet for everything but the Nations Cup

`_tournamentPosts` builds its posts per competition, and only the competitions
it recognises as finals produce them. The continental championship falls through
that recognition, which is why the country tweeted about the Nations Cup and
said nothing about the Euro. The recognition is fixed at its source so every
finals competition — continental, World Championship, Nations Cup — feeds the
same generator.

### Questions a real journalist would not ask

Two faults, one symptom:

* A tournament the nation never entered produces triumph and elimination
  questions. The press asks only about competitions the manager's nation has a
  fixture in.
* `Press.askWindowDays` is thirty, so a month-old result is still "news" and
  gets asked about after two more games have been played. Recency is measured
  against what has happened *since*, not against the calendar alone.

### The accounts get faces

Personas exist and are invisible. Each account shows its handle, its display
name and a stance that reads consistently across a career, and a post opens a
profile with that account's recent history. The cast stays small and derived —
nothing new is stored.

## D. History and records

### WC 2026

A fixed champion, runner-up, third place, final scoreline and the three
co-hosts are added to the pre-seeded history, ending the gap the comment at
`real_history.dart:299` describes.

### Co-hosts are recorded

`Honours.hostId` is joined by a stored list of co-hosts (schema bump, stepwise
migration from the current version, existing saves preserved). Every screen that
names a host names all of them.

### Holders, strength, active scorers, names

* Tournament detail shows the current holders.
* Team history gains a strength curve — where the side's rating has been across
  the career.
* All-time scorer lists mark who is still playing.
* Scorer names in future editions resolve properly instead of falling back to
  "Unknown"; the fallback itself stays, but it stops being the common case.

## E. Dashboard and navigation

* World ranking, with its movement since last time, sits beside the date.
* Squad status stays where it is.
* Challenges gets its own entry in My Career rather than living inside another
  screen.
* The Nations Cup matchday splits its leagues into tabs.

## F. Standing matters

One pass, three seams, all keyed to how the nation is actually doing:

* **Ranking.** A tournament placing weighs more than it does now, so winning
  something moves the nation visibly rather than by a few points.
* **Youth.** Intake quality keys off ranking movement and recent results: a
  nation on the rise attracts and produces better teenagers.
* **Money.** Federation funds scale with the last cycle's results, up and down.
* **And it is shown.** The jump after a tournament appears — in the ranking
  screen's movement column and as an inbox item — instead of having to be
  noticed.

This is the group that cannot be signed off by tests. Tests guard direction and
bounds; the feel needs a device playtest.

## G. Presentation

* Lineup names stop wrapping.
* The transfer report: one icon language for in/out/loan, destinations that make
  sense for the player's level, a layout that reads, and a player's full move
  history rather than a truncated slice of it.
* The results screen leads with the current round, newest first, and folds older
  rounds away.
* The development report groups by tier — regulars, fringe, youth — with named
  movers inside each, so "improved from 34" becomes "who got better, and does it
  change the side".
* Player of the year shows flag, stats and rating.
* The World Championship final is shown when the manager simulates passively, as
  the continental final already is. Only the champion popping up is the bug.
* The naturalised player whose rating differs in the preview is debugged; a man
  must read the same rating everywhere.

## Testing

* Unit tests for every rule change: availability at call-up and in the XI,
  ranking weights, intake quality, federation funds, familiarity and the
  instruction effects.
* A migration test for the honours bump, with an existing save carried across.
* Widget tests for the pre-match readout, the familiarity bar, the substitution
  gate and undo, the results ordering, and the development report's grouping.
* A guard test that the feed produces posts for every finals competition, not
  only the one that happened to work.
* Balance items (F, and the tactics widening in B) carry a playtest note. They
  are directional in tests and judged on a device.

## Out of scope

Türkiye. It is answered, not worked.
