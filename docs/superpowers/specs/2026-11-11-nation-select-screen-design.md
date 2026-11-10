# Choose your nation: the flag wall (planned for the next 1.1.x update)

Status: direction chosen by the owner on 2026-11-11 (option C of three).
Mockup: `mockups/2026-11-11-nation-select-screen.html` (option C is the
right phone). Not built yet. Companion to
`2026-11-10-competitions-screen-design.md`: same calm, silver look with
fixed type sizes.

## Why

The owner wants the nation pick (`lib/features/nations/nation_select_screen.dart`)
to look more impressive and calmer. Today it is a list with a SELECT
button on every row.

## What it is (phone)

- Top: the screen title, the search field and the continent chips, kept
  as today (random team and "from the bottom" stay reachable).
- Body: a grid of silver cells, three per row. Each cell: the nation's
  flag, large, then its name on one line (fixed size, ellipsis, never
  scaled down) and its world ranking (#4) in small monospace.
- Tapping a cell selects it (light outline) and shows a slim silver
  summary bar at the bottom: flag, name, squad overall and the star
  player, plus one "Manage <nation>" button. No button on the cells.
- Every cell the same size in every language.

The tablet already shows a grid of flags; it should adopt the same
silver cell so both form factors match.

## Rules

- Fixed type sizes from the theme; no FittedBox / scale-down on names.
- Copy in `copy/strings.csv`; no em dashes.
- Keep the existing flows that start from this screen (new career,
  campaign, switching nation between cycles) working unchanged.

## Left to the builder

Cell size and spacing, the selected state, the summary bar's exact
contents beyond flag, name, squad and star, and how the bar sits above the
keyboard while searching.
