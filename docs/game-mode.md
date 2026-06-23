# Game Mode — Design

Everything is **local** (offline-first, SQLite). A "game" is a `Career` save. The
manager picks a nation, names themselves, and plays through a **4-year World Cup
cycle** starting **1 September 2026** (cycle 2026→2030).

## Saves & slots
- **2** concurrent saves free, **5** with Pro (`maxSaveSlots(premiumUnlocked:)`).
- Creation is blocked when slots are full (returns a `Result.failure`).
- **Continue** = resume a save; the home button opens the Saves list.

## Time & calendar
- Progression is **matchday advance**: an *Advance* action jumps to the next
  fixture/event; squad, tactics, and (auto) friendlies happen in between.
- FIFA-style **international windows**: Sep, Oct, Nov, Mar, Jun — each window
  holds 2 matchdays. The cycle's competitive fixtures are placed into these
  windows across the four seasons (26/27 … 29/30); open window days are filled
  with **auto-scheduled friendlies**.

## Qualification — realistic, but config-driven
Real per-confederation formats differ a lot, so rather than hardcode six code
paths we model each confederation as a **`QualificationFormat` config** consumed
by generic scheduling primitives. This keeps "realistic" tractable and testable.

Generic primitives (all deterministic via `SeededRng`, seeded from the save):
- **Pot draw** — rank nations into pots, draw into groups avoiding clashes.
- **Round-robin generator** — single/double round-robin fixtures for a group
  or league (circle method).
- **Group stage** — standings (pts, GD, GF) with deterministic tie-breaks.
- **Knockout / playoff** — bracket from seeds/qualifiers.

Per-confederation config (approximate real 2030 shapes; tunable):

| Confed | Format | Direct berths | Playoff |
| ------ | ------ | ------------- | ------- |
| UEFA (Europe, 55) | 12 groups (5–6), double RR | 12 group winners | runners-up → playoff for ~4 |
| CONMEBOL (S. America, 10) | single league, double RR | top 6 | 7th → inter-confed playoff |
| CAF (Africa, 54) | 9 groups of 6, double RR | 9 winners | best runners-up mini-playoff |
| AFC (Asia, 47) | staged → final groups | ~8 | next → inter-confed playoff |
| CONCACAF (N. America, 35) | rounds → final group(s) | ~6 | next → inter-confed playoff |
| OFC (Oceania, 11) | mini-tournament | 1 | winner of playoff path |

> Berth counts are config values, not literals in code. v1 may simplify the
> multi-stage confederations (AFC/CONCACAF) to a single final group stage and
> refine later — the config shape stays the same.

## Schedule generation pipeline (on save creation)
Deterministic, seeded by `career.rngSeed`:
1. Resolve the player's confederation → its `QualificationFormat`.
2. Build the **draw**: pots by ranking → groups/league (player's nation always
   included).
3. Generate **round-robin fixtures**; assign matchdays to the Sep/Oct/Nov/Mar/Jun
   windows across seasons.
4. Fill remaining open window days with **auto friendlies**.
5. Persist `Competition / Group / GroupMember / Standing / Fixture` rows scoped
   to the `careerId`; build the date→fixture **calendar**.

(For non-player confederations we don't need full fixtures — only enough to
produce qualified nations for the finals. v1 can simulate their qualifying
abstractly. The player's confederation gets the full schedule.)

## Results
Until the M6 tactical engine lands, a **deterministic placeholder sim**
(rating-based scoreline from team strengths + `SeededRng`) fills results so
standings and progression work end-to-end. It sits behind a `MatchSimulator`
interface that the real engine later implements — no call-site changes.

## Hub screen (in-game home)
From the provided mock: **next match**, **calendar strip**, **squad status**,
**mini group table**, **news**, bottom nav (Hub / Squad / Matches / Trophy /
More). Loads for a `careerId`.

## Data model additions (Drift, per-save)
All keyed by `careerId` so saves are isolated:
- `Competitions` (type: qualifier/friendly/finals, confederation, season)
- `Groups`, `GroupMembers`, `Standings`
- `Fixtures` (home/away nationId, date, competitionId, matchday, status, score)
- `MatchResults` / `MatchEvents` (M6)

## Milestones
- **M3a** — slots + new-game flow (manager name) + save creation (this step).
- **M3b** — Saves screen + Hub stub + navigation.
- **M4a** — competition data model + `QualificationFormat` config + generic
  draw/round-robin/standings primitives (unit-tested, deterministic).
- **M4b** — full Hub + calendar + standings + matchday advance with placeholder
  results.
- **Later** — finals tournament, real match engine (M6) replaces placeholder.

## First scope (confirmed)
Qualifiers + Hub. Finals tournament and the real match engine are deferred.
