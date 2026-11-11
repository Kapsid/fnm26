# Player and coach pages: header and tabs (1.1.1)

Status: direction chosen by the owner on 2026-11-11 (option A of three).
Mockup: `mockups/2026-11-11-player-coach-pages.html` (option A: player
left, manager right). Part of the calmer, more premium look with fixed
type sizes (see `2026-11-10-competitions-screen-design.md`).

## Why

The player page (`lib/features/player/player_detail_screen.dart`, tablet
`player_tablet_layout.dart`) and the world manager page
(`lib/features/world_managers/manager_detail_screen.dart`, tablet
`manager_detail_tablet_layout.dart`) are long, busy scrolls. The owner wants
them easier to read, calmer, more premium and nicer to use.

## What it is

**A silver header card** at the top of both pages:
- the rating disc (player: overall; manager: reputation), name large, a
  muted line with flag, nation, one chip (player: position; manager: style)
  and age;
- one row of four key numbers with small monospace labels (player: caps,
  goals, form rating, fitness dot; manager: matches, win rate, trophies,
  nations led).

**Three tabs** under it, so the page never becomes one long wall:
- player: Overview (attributes as horizontal bars with the number at the
  end, a sparkline of the last 8 match ratings, "known for" trait chips,
  club), Stats (everything statistical the page shows today), Career (club
  and international history, as today);
- manager: Overview (record bar W/D/L, style and background, in charge
  now), Vs you (his record against the player's nations, as today), Career
  (spells, as today).

Every block is a silver card of the same family as the competitions list.
Nothing the pages show today is lost: it is regrouped into the tabs.

## Rules

- Fixed type sizes from the theme; no scale-down; long names ellipsise;
  layouts grow, never clip, at the largest text size (text_size_fits).
- Phone and tablet: the tablet keeps its two-pane idea but uses the same
  header card and the same blocks.
- Copy: reuse existing strings; any new label in all 28 languages via
  copy/strings.csv; no em dashes.
- No data or schema change.

## Left to the builder

Exact spacing, tab control style (segmented, as in the mockup), the fitness
dot's colours, and where each existing block lands inside the tabs.
