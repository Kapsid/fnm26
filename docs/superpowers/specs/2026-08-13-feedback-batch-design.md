# Feedback batch — 2026-08-13

**Date:** 2026-08-13
**Status:** approved design

## Problem

A play session produced ~28 pieces of feedback across the whole app: hard bugs
that break a career (an intercontinental play-off decided without the manager
playing it), UI that overflows on real data, generated content that repeats
itself until it reads as wallpaper, and balance that sits in the wrong place.

They are unrelated as features but they arrived together and they are being
fixed together, as one batch on one branch.

## Decisions

- **One batch, one branch.** Not phased. Review at the end.
- **Newgens enter the pyramid at 13–15**, not 17, and grow up through it. Same
  world, discovered earlier.
- **Y and the press get real generators**, not bigger template pools. Both key
  off save state — named players, actual scorelines, streaks, rivalries,
  injuries, board mood — with a no-repeat window over recent output.
- **Call-up screen gets GK/DEF/MID/FWD tabs.** No "All" tab; the tabs replace
  the scroll rather than sitting beside it.
- **Balance items are tuned, then playtested.** Scoreline tails, ranking
  weights and board tolerance cannot be signed off by tests alone.

## A. Live match

### Substitution counter overflows

`match_screen.dart:1596` builds a single string into a fixed-width chip:

```dart
spent > 0 && subsUsed < kMaxSubs
    ? 'TIRED ×$spent · $subsUsed/$kMaxSubs'
    : 'TACTICS · $subsUsed/$kMaxSubs'
```

With tired players the string grows and clips. Split it into a two-part chip
that lays out rather than concatenates, so the sub count survives whatever the
tired count does.

### Substitutions are not capped

`in_match_tactics.dart:137` computes `_overLimit` and `:185` shows
`tacticsTooManySubs` — but it is a *banner*, not a gate. The confirm path
applies the change regardless, which is why the manager could occasionally
substitute without limit and re-substitute players already withdrawn.

Enforce at apply time: a change that would exceed `maxSubs`, or that would
bring back a player already substituted off, is rejected. The banner stays as
the explanation; it stops being the only defence.

### Second yellows never appear

The engine models them — `match_engine.dart:961` emits `redCard` with
`secondYellow: true` — but in practice only straight reds land, because
`_straightRedPerMinute = 0.0006` (`:406`) fires far more often than the
two-booking path is reached.

Two changes: rebalance so a second booking is the *common* dismissal and a
straight red the rare one, matching real football; and render the two
distinctly (🟨🟥 versus 🟥) in the match timeline and report, so the manager can
see which one cost him the player.

### Team overall on the match

Show each side's squad-average overall on the match and preview headers, and
the per-team overall on team detail.

### 7+ goal results

Blowouts of seven or more must be ultra rare. Add tail damping to the scoreline
draw. This lands in **both** `match_engine` and `match_simulator` — they are
tuned together and a change to one alone desyncs live and background football.

## B. Tournament flow

### The intercontinental play-off is never playable

The root bug, and the worst of the batch: a manager qualified for the play-off,
never played it, and was eliminated.

`Finals.playoffWinners` (`finals.dart:492`) settles every tie through
`_playoffMatch` — a deterministic, ranking-weighted coin flip — at the moment
finalists are selected. `intercontinental_playoff_screen.dart` then *replays
that same computation for display*. The screen is a viewer. There was never a
match to play.

Fix: when the manager's nation is in `playoffPoolFor`, its ties become real
fixtures that are played or watched like any other knockout, and the recorded
result feeds back so `playoffWinners` reads the played outcome instead of
flipping its own coin. Ties not involving the manager keep the existing
deterministic path.

The two must agree exactly — the bracket display, the finalist selection and
the played result are the same six-team field, or the finals draw contains a
nation the bracket says lost.

### Best player awarded before the tournament ends

Gate the award on every fixture in the tournament being played. This is the
same participant/completeness check the finals-watch routing already needs.

### Passive World Cup simulation scrolls forever

Paginate the passive-sim view by round rather than emitting one long list.

### Gold Cup winners stop at 2023

`real_history.dart:1197` (North America Cup) ends early. Extend the record.

## C. Squad, youth, players

### Call-up screen — overflow, scrolling, and the club label

Three reported items, all in `call_up_screen.dart`:

- The screen overflows on real squads.
- It requires scrolling to pick a squad.
- "Plays every week" (`clubFirstChoice`, rendered at `:728` via
  `clubStandingLabel`) overlaps its neighbours.

Restructure around **GK / DEF / MID / FWD tabs**, fixing the overflow and the
label layout in the same pass. Selection state is shared across tabs — the
squad is one squad, viewed four ways.

### Newgens enter at 13–15

Intake currently starts at 17, so a whole generation appears fully formed. Move
entry to the bottom of the pyramid and let players progress up through it.

Note `prospects.dart:80` — the spread already branches on
`YouthLevel.u19.minAge`; the age bands need revisiting as a whole, not patching
at one edge.

### U-21 must not be weaker than U-19

A strong U-19 player is currently outshone by the U-21 group he should have
been promoted into. Add the promotion rule: reaching the age moves the player
up rather than leaving a better player in a lower band.

### The grievance event fires before the first call-up, and again on restart

`hub_event.dart:383` (`wantsAWord`) surfaces a player grievance before the
manager has ever picked a squad — there is nothing to have a grievance about —
and it returns after an app restart, so it reads as unresolved.

Two fixes: gate it on at least one squad having been named, and persist the
resolution so a restart does not resurrect it.

### Club history only for some players

Make it universal. `ClubHistory.spells` derives from season-by-season clubs, so
the gap is in which players get a populated `byYear`, not in the collapsing.

### Too few players abroad, and transfers are domestic only

`clubs.dart:82` already models the foreign path. Retune retention so more
players are abroad, and let the transfer feed surface international moves —
currently the manager only ever sees domestic ones.

### All-time stats show an active scorer as inactive

A player appearing in a live tournament is listed as not active in the all-time
scorer table. The active flag is being read from the wrong source.

## D. Y and the press

The largest work item. Both currently pull from fixed template pools, so a long
save repeats itself and the posts stop carrying information.

Rewrite both as **context-driven generators**. They read what actually
happened — the scoreline and its scorers, a winning or losing streak, the
rivalry the fixture sits in, who is injured, where the board's mood is — and
produce output that names it. A no-repeat window prevents the same shape
recurring within a run of posts.

Y additionally gets:

- a **notification count**, so the tab says how much is unread;
- **tappable posts**, opening a detail view rather than being inert text.

The existing `YPost` structure (voice, handle, template, args, date, key) is
kept — it localises at render, and that stays true. What changes is how much
context feeds the args, and how many distinct shapes exist.

## E. Naming, UI, balance

### Achievements say "World Cup"

`achievements.dart:101` defines the licence-safe stored name:

```dart
const worldCupHonourName = 'World Championship';
```

...but the achievement titles and descriptions around `:283`–`:422` say "World
Cup" in user-facing text. Rename the strings to match the stored honour.
`worldCupHonourName` itself is a stored value — changing it would orphan
existing honours, so it stays.

### Team overall development history

Show the nation's overall over time, so a rebuild is visible as a curve rather
than inferred.

### Ranking weights

Two related asks in `elo.dart`:

- **A World Cup should move you more.** Raise `finalsSettled` (currently 48).
- **A single match should move you less.** Lower the per-match K factors
  (`friendly` 4, `nationsCup` 10, `qualifier` 16, `finals` 30).

The floor is documented in the file and holds: below about K=4 an expected
friendly win rounds to zero and the table looks frozen.

### Board objectives

From `board_satisfaction.dart` (`win` +2, `draw` 0, `loss` −4, `formWindow`
10):

- **More tolerant targets for weaker nations** — a low-ranked side should not
  be handed a target it cannot reach.
- **A firmer sacking bar for genuinely bad results** — tolerance on the
  objective, not on collapse.

These pull in opposite directions by design, and the interaction with
`nationOffers`' sacking threshold is where it can go wrong.

## Testing

Unit-testable, and tested: the substitution cap, second-yellow versus straight
red rates, the play-off result feeding finalist selection, the award
completeness gate, the U-21 promotion rule, the grievance gating, the all-time
active flag, ranking weights, board tolerance.

Not verifiable by test — needs a device playtest:

- scoreline distribution (7+ goals actually rare across a season)
- ranking feel after the weight change
- board tolerance across a weak and a strong nation
- Y and press variety over a long save
- the call-up tabs and match chip on a real screen

## Schema

The youth-entry change and the team-overall history both likely need stored
shape changes → a schema bump. Per project history, **a schema bump wipes
existing saves.** Confirm before the bump lands.

## Risks

- **The play-off fix is the one that can corrupt a save.** Bracket display,
  finalist selection and played result must agree, or the finals contain a
  nation the bracket eliminated.
- **Balance changes compound.** Scoreline damping, ranking weights and board
  tolerance all move how a career feels, in the same batch. If the playtest
  reads wrong, isolate which of the three before re-tuning.
- **Batch size.** ~28 items across every subsystem in one review.
