# Youth pyramid: U-13 → U-21

**Date:** 2026-08-05
**Status:** approved design

## Problem

The young part of the game is invisible. A nation's only youth surface is the
U-21 watchlist, a flat list of the 18–21-year-olds already in the senior pool.
Below that there is nothing: the seed contains no player under 18, and
`PlayerLifecycle` introduces newgens in four-year batches at age 16–19. A
seventeen-year-old therefore *appears*, already formed, having never existed.

We want five age levels a manager can watch players grow through, and a call-up
rule that makes capping a fifteen- or sixteen-year-old a rare, deliberate
gamble rather than a default.

## Decisions

- The pyramid is a **development structure, not a competition**. Youth levels
  have squads, not fixtures. No youth matches, tournaments, schedules or
  results.
- Players **enter the world at 11** and are visible from that day. Nothing is
  ever created mid-career.
- Youth are **not promoted**; they simply appear in the senior call-up list
  carrying their level tag.
- Only the **rating gap** discourages capping a teenager. No hard age floor
  above 15, no burnout roll, no board reaction, no development penalty.

## Levels

| Level | Ages  | In senior call-up list |
| ----- | ----- | ---------------------- |
| U-13  | 11–12 | no                     |
| U-15  | 13–14 | no                     |
| U-17  | 15–16 | yes, tagged            |
| U-19  | 17–18 | yes, tagged            |
| U-21  | 19–20 | yes, tagged            |

Strict under-N banding: a player is in U-17 while he is under 17. "Rarely cap a
sub-17" therefore reads directly as "rarely cap from U-17".

A new `YouthLevel` enum lives in `lib/domain/entities/enums.dart`, with
`YouthLevel.forAge(int age)` returning `null` for 21 and over.

## Intake

Annual, seven players per nation per year, at age 11. This replaces
`intakePerCycle = 22` on a four-year boundary.

**Wash-out.** About 21% of an intake is released before reaching 17, at a
deterministic age between 12 and 16 derived from the player id alone (a bit
window distinct from `developmentPotential` and `retirementAgeFor`, so how good
a boy was going to be does not decide whether he is released). Seven in, ~5.5
out at 17 — exactly the 22-per-four-years the senior pool is balanced around
today, so pool size, retirement/intake equilibrium and squad sizes are
unchanged.

**Backfill.** Intake years −6 through 0 are generated at save start, giving
ages 11–17 on day one. The oldest backfilled cohort (17) sits directly beneath
the youngest seeded player (18), so the age ladder is continuous from the first
screen the player opens.

**Ids.** The newgen id encodes `bornYearIndex = intakeYear + 8` (so the
backfilled −6…−1 years stay positive) in place of the born-cycle. Slots per
year drop from 22 to 7; `nationStride` and `cycleStride` are unchanged, giving
~990 years of headroom. Existing saves' stored newgen ids (call-ups,
appearances, ratings, honours) no longer resolve, so this ships with a schema
bump and the usual save wipe.

**Academy investment.** `youthBonusByCycle` keeps its four-year cycle key; an
annual intake takes the bonus of the cycle containing its intake year.
Backfilled cohorts take no bonus.

## Ratings and balance

Two curve changes in `PlayerAging`, calibrated so the senior world's overall
distribution is unchanged:

1. `_yearlyDelta` gains sub-17 bands — children grow fast and then slow:
   roughly +2.6 physical / +2.2 technical per year under 15, +1.8 / +1.5 at
   15–16, then today's +1.0 / +0.85 from 17.
2. `_youthDiscount`, which today flatlines at −7 for 18 and under, extends
   downward: 17 → −9, 16 → −12, 15 → −15, 14 → −18, 13 → −21, 12 and under →
   −24.

Intake attribute scale is retuned so that a boy generated at 11 arrives, after
six years of the curve above, where today's 17-year-old newgen arrives.

Net effect: a 15–16-year-old sits roughly 12–18 overall below senior standard.
Naming one costs results, which is the whole deterrent. The existing wonderkid
relief — top-tail potential is spared most of the youth discount — still lets a
genuine prodigy be tempting at 16, which is the once-a-career moment worth
having.

Caps continue to accelerate development (`careerStartsByPlayer`) at every age.
This is a known pull toward blooding teenagers; the rating gap is accepted as
the sole counterweight.

## Code shape

- `PlayerLifecycle.poolAt(..., {int minAge = 17})` — the default excludes U-17s,
  so the world simulation, AI squad selection, rankings and every existing
  caller see exactly the pool they see today and the hot path costs no more.
  Only the player's own call-up path passes `minAge: 15`.
  Consequence, accepted: AI nations never name a 15–16-year-old. The band is
  ~13 extra players per nation, aged year-by-year, on every world-sim step —
  for players who would essentially never be picked. Admitting only the top
  potential tail (filterable by id before anyone is built) was considered and
  rejected in favour of zero added cost; the world simply does not produce
  sixteen-year-old internationals.
- `PlayerLifecycle.youthPoolAt(seeded, nationId, agingYears)` — builds ages
  11–20 for one nation on demand, for the Youth screen. Applies the same
  wash-out, aging and academy bonus as `poolAt`.
- `PlayerRepository.byNation` gains the `minAge` pass-through; a
  `youthByNation` sibling exposes `youthPoolAt`.
- Nothing new is persisted. No new tables.

## UI

`U21Screen` becomes `YouthScreen`: five level tabs (U-13 … U-21) over the
existing `Prospects` machinery. Each row shows age, position, overall, the
year's rating gain, and the scouting star read.

Scouting uncertainty widens for the young: ±1 star at U-19 and U-21 as today,
±2 at U-17 and below, settling to the truth after three caps. Every sub-17 is
therefore always an estimate — you cannot know a boy before you play him.

Each tab lists that year's **released** players, diffed against the previous
year's pool the provider already loads, so departures are seen rather than
silent.

The senior call-up screen tags youth entries with their level.

All new strings in EN and CS.

## Testing

Extending `test/unit/domain/player_lifecycle_test.dart`,
`player_aging_test.dart` and `test/unit/squad/prospects_test.dart`:

- every level is populated at aging year 0 (backfill)
- pool size stable across 40 aging years
- wash-out lands at ~21% of an intake, and a released player never reappears
- **senior guard:** the 21-and-over overall distribution matches the current
  implementation within tolerance
- **balance guard:** the median 16-year-old's overall is at least 12 below the
  nation's weakest senior
- `YouthLevel.forAge` banding, including the 20/21 boundary
- determinism: two saves at the same aging year produce identical pyramids

## Out of scope

Youth fixtures, youth tournaments, youth results, an explicit promotion action,
per-level squad selection, burnout, press or board reaction to a young call-up.
