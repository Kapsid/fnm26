# Match schedule on the hub

Date: 2026-10-20 · For release 1.0.6 · Status: approved 2026-10-20

## Why

Players asked for a better match schedule they can reach from the hub
(dashboard). Today the hub's "Next match" card (`_NextMatch` in
`lib/features/hub/hub_screen.dart`) shows one fixture, and the Results tab
(`lib/features/results/results_screen.dart`) lists matches grouped by
competition, results-first in spirit. With fluid 2-4 match windows in 1.0.6,
"what is coming and when" matters more, and neither screen answers it at a
glance.

## Goals (owner's choice: hub card plus full calendar)

1. **Upcoming card on the hub:** the matches of the current or next
   international window (2-4 of them), each with opponent flag and name,
   competition label, date, and home/away; a played one shows its score.
   Tapping a match opens its preview when it is the next to play, otherwise
   the opponent's team page (via `openNation`, see the team overview design).
   A "Full schedule" action opens the calendar. It replaces the single
   "Next match" card on phone and fills the tablet next-match panel
   (`HubScreen.nextMatchPanelKey`).
2. **Schedule screen** (new route, phone and tablet layouts): the whole cycle
   month by month, from the current month on, with:
   - each international window as a block (its month, the matches in it,
     results for played ones);
   - tournaments the nation is in shown as one block per stage (group
     matches with dates; knockout rounds shown as "Round of 16, from date" until
     the opponent is known);
   - months with nothing for the nation omitted, so the screen reads as a list
     of windows and tournaments, not a grid of empty months;
   - a "Today" marker at the current position, and the screen opens scrolled
     to it;
   - earlier months of the cycle reachable by scrolling up.
   Friendlies the manager has arranged appear in their window.

## Non-goals

- No change to the Results tab, which stays the history view.
- No other nations' schedules, and no league-style "all fixtures" view.
- No editing from the schedule (arranging friendlies stays where it is).
- No schema change; everything comes from the cycle's fixtures and the
  calendar already built (`cycleFixturesForNation`, the window plan).

## Anti-goals

- Showing fixtures the game has not drawn yet as if they were known (a
  knockout opponent, a qualifying draw not yet made). Unknowns read as
  stages with dates, or "Draw on date".
- A hub that gets longer on phones: the card takes the place of the current
  next-match card, it does not sit beside it.

## Constraints

- Existing saves: works on 1.0.5 saves too (legacy fixed windows read as
  windows of the same month).
- Tablet route sweep: the new route is in `tabletReadyPaths` with a
  `TabletPage` layout.
- Copy in seven languages through the `.arb` route and `copy/strings.csv`; no
  em dashes; never "World Cup"; Czech in label: value forms.
- Goldens for the hub update only where the card legitimately changes.

## Left to the builder

The visual design of the card and the month blocks, the route name, empty
and loading states (between cycles, after elimination), whether the hub card
shows the window's dates as a range.

## Claude's calls (for the owner to check)

- The card shows the current window, or the next one between windows.
- Tapping the next match opens its preview; any other opens the opponent.
- Empty months are omitted from the schedule.
