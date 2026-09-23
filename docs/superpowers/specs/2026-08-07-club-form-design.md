# Club form feeds call-ups

**Date:** 2026-08-07
**Status:** approved design

## Problem

A national manager's players spend almost all of their lives at clubs this game
does not simulate. `ClubService` says so itself — "purely cosmetic flavour". A
club currently does two things: it prints a name, and its tier weights
development in `PlayerLifecycle.withCareerDev`. Nothing else.

So the defining constraint of international management is absent. Form and
fatigue in `Condition` are derived from *international* matches alone, which
means a striker who has not started for his club since October arrives at camp
exactly as sharp as one playing every week. Selection is therefore a sort: pick
the top 23 ratings and you are done.

This makes a club situation real, so that selection becomes a judgement.

## Decisions

- Club standing affects **match sharpness** and **development**. It does not
  make a player unavailable — clubs never refuse to release anybody. That was
  considered and cut: a squad gutted for a friendly through no fault of the
  manager's is frustration, not drama.
- Standing is **redrawn every international window**, so a spell out of the side
  lasts a camp or two and then turns.
- **Development reads the year, not the window.** Standing churns per window;
  growth reads the average across the year's windows, so a player is not
  rewarded or punished for the timing of a single draw.
- Derived, never stored. Standing is a pure function of the player id, his
  rating, the save seed and the window — like everything else about a player.

## Club standing

```dart
enum ClubStanding { firstChoice, rotation, fringe, frozenOut }
```

Derived from three inputs:

- **How far his rating sits above his club's level.** `ClubService.tierForOverall`
  already bands ratings into the five league tiers; a player near the top of his
  band is comfortably first choice, one near the bottom is squad filler.
- **A per-window hash** of his id and the save seed, which moves him a step
  either way. This is what makes the same player's standing move over a career.
- **Age.** A teenager at a big club is far more likely to be fringe; a
  thirty-five-year-old drifts down as well.

The combination matters more than any single number: a star at a modest club is
almost never dropped, while a squad man at an elite club swings between rotation
and fringe from window to window. That asymmetry is the point — it is why
"he should move club" becomes a thought the manager has.

**The window index** is derived from the in-game date, with no storage: the FIFA
window months are March, June, September, October and November, and the index is
`year * 5 + (how many of those months have opened this year)`. Two saves at the
same date therefore see the same standings.

## Sharpness

A third term in `Condition.of`, beside form, fatigue, morale and the camp bonus,
carrying its own delta:

| Standing | Delta |
| --- | --- |
| first choice | +1 |
| rotation | 0 |
| fringe | −2 |
| frozen out | −5 |

`Condition.of` already clamps its combined delta to (−9, +6), so a rusty man in
poor form is bad but never unusable. The feature is meant to force a decision,
not to disqualify a player: a frozen-out star may still be the right pick, and
finding out is the game.

## Development

`PlayerLifecycle.withCareerDev` gains a minutes factor, multiplying the bump it
already computes:

```dart
static Player withCareerDev(Player aged, int starts, {double minutesFactor = 1})
```

The factor comes from the **average** of that year's five window standings,
mapped so a regular sits near 1.2 and a frozen-out player near 0.75 — and,
critically, **centred on 1.0 across the population**. The senior pool's
equilibrium (~126–130 players, measured during the youth pyramid work) depends
on average development being unchanged, so a test pins that the mean factor over
a large sample is 1.0 within a small tolerance. Skewing it is how this feature
would quietly inflate or starve the world.

Being straight about the size of this lever: `withCareerDev` is capped at +3
overall, so minutes are a real but modest influence and the age curve remains
the dominant force in what a player becomes. Making minutes dominate would mean
re-tuning that curve and re-measuring the equilibrium — a separate decision, not
this one.

## Where it shows

- **Call-up screen:** a standing badge beside the existing form dot, so the cost
  of picking a frozen-out player is visible at the moment of picking him.
- **Pre-match dossier:** the opponent's key men carry theirs too.
- **Player card:** his current club situation, under the club history.

## Testing

- Standing is deterministic for a given (id, rating, seed, window, age).
- A player at the top of his league band is first choice far more often than one
  at the bottom — asserted over a large sample, not a single draw.
- A teenager is fringe more often than a peak-age player of the same rating.
- The sharpness delta is bounded, and `Condition.of`'s combined delta still
  respects its existing (−9, +6) clamp with the new term present.
- **The guard:** the mean development factor across a large pool is 1.0 within
  tolerance, so the world's average development is unchanged.
- Standing changes across windows for a mid-band player, and rarely for a player
  far above his club's level.

## Out of scope

Clubs refusing to release players, club fixtures or results, transfers driven by
anything other than the existing rating-based club assignment, club form for
the AI world's own selection (the world sim keeps picking on rating), and any
change to the age curve.
