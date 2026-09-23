# Recorded rating history

2026-09-05

## The problem

A player's rating is derived, never stored. `PlayerAging.agedYears` walks the
age curve, `PlayerLifecycle.poolAt` adds intakes and retirements, and the number
on a player's card is recomputed from `(seeded base row, agingYears, saveSeed)`
every time it is asked for. That is what lets the game run offline with no
backend, and it should stay.

It has two costs, and both of them show up the moment anything asks about the
past.

**It is expensive.** `teamOverallHistoryProvider` charts a nation's strength year
by year by rebuilding the whole national pool once per elapsed season. At in-game
year 40 that is 41 full `byNation` builds, each aging ~130 seeded players and
generating every intake since the save opened, to draw one line.

**It is not a record.** That provider passes *today's* `careerStartsByPlayer` and
`youthBonusByCycle` into every past year, so `PlayerLifecycle.withCareerDev`
applies a player's current tournament-start count retroactively to 2027. Every
cap he wins silently rewrites what he was rated six years ago. The curve is not
what happened; it is a recomputation under today's inputs.

The same wall was hit from the other side on 2026-09-05 building the club
contract clock: a club needed the rating a player had when he signed, there was
no way to ask for it, and the fix had to be an approximation (detrending the age
curve) rather than a lookup. See `clubs-system` in project memory.

## What we are building

One row per player per season, for the nation the manager runs, written at the
moment the pool actually re-rates. The derived model is untouched; this records
its output as it goes past.

Explicitly NOT a cache of the derivation. A cache would be recomputed and would
inherit the retroactive rewriting. This is a log: what he was, that year,
written down that year, never revised.

## Data

A new drift table:

```
PlayerRatingHistory
  careerId  int, references Careers(id) on delete cascade
  playerId  int
  year      int          -- calendar year, CareerService.cycleStart.year + agingYears
  overall   int
  physical  int
  technical int
  stamina   int
  primary key (careerId, playerId, year)
```

The primary key is the idempotency: writing a year twice replaces the row rather
than duplicating it, so the "two advances in one frame" path and any replay are
safe by construction rather than by a guard somebody has to remember.

`overall` is stored rather than recomputed from the three attributes because it
is position-weighted (`OverallRating.forPosition`), and a player's position is
itself derived. Storing the number that was shown keeps the row self-contained.

Size: the manager's pool including the youth pyramid is roughly 180 players, so
~180 rows a season and ~7,000 across a 40-year save. Negligible against a save
that is already 40 MB.

Schema 46. Purely additive: `from45To46` creates the table and moves no data. An
existing save gains an empty table and loses nothing.

## When it is written

On the aging tick: the moment `CareerService.agingYears(career)` increases,
which is 1 December, which is exactly when the pool re-rates. No other moment is
correct, because on any other date the year is half-played.

A new `RatingHistoryService.recordYear(careerId)` snapshots the nation's whole
pool at `minAge: PlayerLifecycle.intakeAge` (11) so the youth pyramid is included
and a boy's curve shows the youth markdown coming off, which is the part of a
prospect's development a manager most wants to watch.

It derives the pool with **the same inputs the squad screen uses** -
`youthBonusByCycle` and `careerStartsByPlayer` - or the recorded number will not
match the rating on the player's own card, and a chart that disagrees with the
number above it is worse than no chart.

Note for whoever implements it: the existing yearly squad report
(`message_providers.dart`, the `missingYears` loop) builds its pools *without*
those inputs. That is a pre-existing discrepancy in a different feature. Match
the squad screen here; do not change that call as part of this work.

### Existing saves

Recording starts at the current year the first time a save opens on the new
build. Nothing is reconstructed. A save five seasons in gets one point
immediately and a new one each December; only a fresh save ever has a complete
curve.

This was a deliberate choice over backfilling. A backfill could only reconstruct
the years under today's inputs, which is precisely the inaccuracy this feature
exists to remove, so it would have written down a number and called it a record
when it was a guess.

## What reads it

A rating-progress chart on the player detail screen, below `ClubHistoryCard`.
Overall alone by default, the three attributes behind a toggle, so the card does
not turn into a spaghetti graph.

There is no reusable chart widget in the codebase - `team_stats_screen` draws its
curve inline - so this adds one small shared painter under
`lib/shared/widgets/`. The team chart can adopt it later; that is not part of
this work.

Fewer than two points means no chart. A single dot is not a curve, and a save
that has just upgraded will sit in that state for a season.

## Out of scope

`teamOverallHistoryProvider` keeps deriving. Moving it onto stored rows would fix
both its cost and its retroactive rewriting, but it needs a "stored where we have
it, derived before that" merge for saves that predate the table, and that is its
own decision with its own honesty question about which half of the line the
reader is looking at.

Also out of scope: recording the club alongside the rating (which would turn
`ClubHistory` from a re-derivation into a record), and recording other nations'
players.

## Testing

- Recording the same year twice leaves one row.
- A career id that does not exist is a no-op, not a throw.
- The recorded `overall` equals the number `byNation` reports for that player at
  that `agingYears`, with the squad screen's inputs. This is the test that would
  have caught the inputs mismatch.
- The youth pyramid is included: an eleven-year-old in the pool gets a row.
- Rows written at schema 45 survive the step to 46, using
  `verifier.schemaAt(45)` rather than `startAt` - only `schemaAt` shares one
  underlying database, so rows written before the step are still there when it
  runs. See `schema-bumps-preserve-saves` in project memory.
- The chart renders nothing for a player with fewer than two recorded years.
