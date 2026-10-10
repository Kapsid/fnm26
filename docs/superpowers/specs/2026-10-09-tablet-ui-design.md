# Tablet UI

Date: 2026-10-09. Approved in chat on 2026-10-09.

Mockups (iPad 11in landscape, 1194 x 834):
https://claude.ai/artifact/TpCh1SB6G5JJU9TsTb5Ler (Hub, Squad, Tactics,
Match, Competitions, Inbox).

## Goal

A tablet UI that feels like a desktop football manager: a persistent sidebar,
dense sortable tables, and several panes on screen at once. It ships as its own
release, **v1.0.4 on both iOS and Android**, good enough for store screenshots and reviews. Where the extra space
is worth it, tablet shows more than phone does (more columns, side-by-side
detail).

Phones keep the current UI exactly. Nothing in the phone path changes
behaviour.

## Decisions

- **Landscape only** on tablets. Portrait is not designed or tested.
- **All screens** get a tablet layout before the release ships.
- **Approach A: adaptive shell plus per-screen tablet layouts.** One app, one
  router, one data layer. Each screen keeps its providers and logic and splits
  only its build into a phone layout and a tablet layout. A separate tablet app
  tree (approach C) and pure reflow (approach B) were rejected.

## Detection and platform

- `FormFactor` (extension on `BuildContext` plus a provider): tablet when
  `MediaQuery.sizeOf(context).shortestSide >= 600`. Everything else is phone.
- iOS: `TARGETED_DEVICE_FAMILY = 1,2` (iPhone + iPad) in all three build
  configs. `UISupportedInterfaceOrientations~ipad` becomes landscape left and
  right only. iPhone orientations unchanged.
- Android: no manifest lock (it would hit phones too). At startup, when the
  form factor is tablet, `SystemChrome.setPreferredOrientations` to the two
  landscape orientations.

## Shell

A go_router `ShellRoute` wraps the existing flat routes. On phone its builder
returns the child unchanged, so routes, `?careerId=` parameters, back
behaviour and the existing `AppBottomNav` all stay as they are. On tablet it
renders:

- **Top bar** (52px): nation flag and name, game date, next-fixture chip, an
  inbox button with unread badge, and a permanent **Continue** button on the
  right. Continue drives the same advance logic the hub uses today; it is not a
  second implementation.
- **Sidebar** (208px, collapsible to icons in the polish stage), grouped:
  - Home: Hub, Inbox, Y
  - Team: Squad, Tactics, Call-ups, Youth, Training camp
  - Competitions: Tournaments, Nations Cup, Ranking, Results
  - Federation: Finances, Board, Manager & staff, Naturalization
  - History: Records, Legends, Head to head, Achievements, Career
  - Settings at the bottom.
  Sidebar taps use `context.go`, as the bottom nav does now.
- **Content area**: the routed screen.

`AppBottomNav` is not shown on tablet.

### Outside the shell (full screen on tablet)

Match, draw ceremonies (host, qualifying, finals, continental, Nations Cup),
tournament kickoff, cycle rollover, paywall, new game, home/saves. Each still
gets a landscape tablet layout.

### Detail pane

Player, nation, team stats and H2H open in a right-hand detail pane when the
screen they are opened from hosts one. Otherwise they route as now, inside the
shell. To make this possible each is extracted into a reusable `*View` widget
(`PlayerView`, `NationView`, `TeamStatsView`, `H2hView`) that both the existing
full-screen route and the pane render.

### Sheets

`showAdaptiveSheet` replaces the direct `showModalBottomSheet` calls (10 call
sites today). Phone: the same bottom sheet as now. Tablet: a centred dialog,
or a side panel where the sheet is a picker.

## Tablet widget kit

New folder `lib/shared/tablet/`. Phone layouts never import it.

- **`DataGrid<T>`**: columns declared as `GridColumn<T>(label, value, cell,
  sortable, width)`. Sticky header, sort on header tap (tap again to reverse),
  36px rows, zebra striping, selected row highlight, `onSelect`. Named column
  views (for example Overview / Attributes / Form / Career) chosen from a
  column picker. The chosen view is persisted per table in settings. Virtualised
  for long lists (ranking, legends).
- **`MasterDetail`**: list left, detail right, draggable divider, default
  40/60. Empty detail shows a quiet placeholder or a sensible default
  selection.
- **`Panel`**: titled box (header, optional action link, body). Denser than
  `AppCard`.
- **`DashboardGrid`**: 12-column grid of `Panel`s.
- **`DetailPaneHost`**: hosts the extracted `*View` widgets.
- **`showAdaptiveSheet` / `AdaptiveDialog`**.
- **Dense type scale**: a text-theme variant one step smaller for tables.
  Colours, `AppSpacing` and `AppRadii` are unchanged.

## Screen layouts

Each screen splits its build into `_PhoneLayout` (the current widget tree,
moved, not changed) and `_TabletLayout`.

| Family | Tablet layout |
|---|---|
| Hub | `DashboardGrid`: next match, group/ladder standing, board brief, form, inbox preview, Y snippet, federation budget strip |
| Inbox (messages) | `MasterDetail`: filterable list (All, Board, Press, Squad, Scouting) and the open message, incl. press and squad development reports |
| Y | timeline centre, trending and personas at the side |
| Squad / player lists | `DataGrid` (Overview, Attributes, Form, Career) with player detail pane |
| Tactics | pitch left (larger discs, names inside; pitch-disc ceiling rule still applies), bench strip below; right tabs: Formation and playstyle, Set pieces, Roles, Opposition (scouting dossier) |
| Call-ups | three columns: pool grid, selected squad with draft summary, player detail |
| Youth | watchlist grid by age group plus detail |
| Training camp | panels |
| Match (full screen) | commentary left, pitch and momentum centre, stats and live ratings right; bottom bar with Tactics, Substitutions, shouts, speed, Pause. Subs open alongside the pitch |
| Match preview | two columns, teams and line-ups |
| Round results | results beside standings |
| Tournaments | competition list left; selected competition right with tabs (Groups, Fixtures, Play-offs or Bracket, Stats) |
| Cup / continental detail | bracket full width; group tables in a grid |
| Draw ceremonies | landscape stage: pots left, groups filling right. Still read stored groups, never re-run a draw |
| Ranking | `DataGrid` with nation detail pane |
| Finances, board objectives, manager | `DashboardGrid` |
| Budget setup | investment editor left, effects right |
| Records, legends, all-time records, achievements, challenges | `DataGrid` or list plus detail |
| Head to head | picker left, meetings right |
| Careers / saves | list plus career summary |
| Home | landscape title screen |
| Settings, diagnostics, dev gallery, onboarding | phone layout centred in the content area, max width 600 |

## Phasing

One release, built in stages. Every stage leaves the app shippable: a screen
without a tablet layout yet renders its phone layout centred at max width 600
inside the shell.

1. **Foundation**: iPad enabled, landscape lock, `FormFactor`, `ShellRoute`
   shell, tablet widget kit, `showAdaptiveSheet` migration.
2. **Core loop**: Hub, Inbox, Squad, Tactics, Call-ups, match preview, Match,
   round results. A full cycle is playable on tablet.
3. **Competitions**: tournaments, cup and continental detail, Nations Cup,
   ranking, results, all draw ceremonies.
4. **Federation and manager**: finances, budget setup, board objectives,
   manager, youth, training camp, naturalization, Y.
5. **History and career**: records, legends, H2H, achievements, challenges,
   careers and saves, career summary, home.
6. **Polish**: column picker views persisted, collapsible sidebar, store
   screenshots, iPad App Store listing.

Each stage gets its own implementation plan.

## Stage 1 adjustments (2026-10-09)

- Training camp and Naturalization are not in the sidebar: they are event
  screens that Continue opens when due.
- Settings, diagnostics and the dev gallery are full-screen routes outside the
  shell (no `careerId`, so no save for the top bar).
- `DetailPaneHost` and the `*View` extractions move to stage 2, where Squad
  first hosts a detail pane; `MasterDetail` ships in stage 1.
- Stage 1 checks route parity (every path registered on tablet, full-screen
  paths outside the shell). Pumping every route on a seeded save moves to
  stage 2.
- iPad uses `UIRequiresFullScreen` (required for landscape-only iPad apps).
- German and Spanish ARB files are not on this branch; the 22 new keys must be
  added to them when that work merges (values in the stage 1 plan, Task 3).
- On tablets, sheets are dialogs of a fixed width min(560, window width - 64)
  on the root navigator.

## Stage 2 adjustments (2026-10-09)

- Inbox filters are All, Board, Competitions, Squad: Press and Scouting are
  not inbox categories.
- Tactics tabs are Formation (instructions under it), Roles and set pieces,
  Opposition. Roles and set pieces stay one tab, as on the phone.
- The Opposition tab reuses the preview's briefing. Its danger men are the
  opponent pool's best three (`opponentKeyMenProvider`), so Tactics never
  keeps the pre-simulated match preview alive. It shows nothing of the
  opponent until his draw has been watched.
- The match centre is the manager's live shape on the tactics pitch (read
  only; a tap opens the editor) above the momentum bar. There is no 2D ball
  view and no shouts; the bottom bar is the existing control bar.
- Substitutions "alongside the pitch" means the in-match editor's landscape
  layout: pitch left, lists and instructions right.
- The hub has no in-body Continue on tablet; the top bar's carries the tour
  key. Its Next-match panel links to Call-ups and Tactics, not the preview.
- Full-screen routes without a tablet layout yet are drawn centred at 600.
- Full-screen routes choose their tablet layout with `useTabletLayout`
  (tablet at startup AND a tablet-sized window).
- Tablet layouts need a window at least 1000 logical px wide
  (`kTabletLayoutMinWidth`); narrower tablet windows (iPadOS 26 resizable
  windows, split view) get the phone app. Sheets stay dialogs on any
  tablet-sized window.
- In-shell pages are framed per page: routes not in `tabletReadyPaths` are
  wrapped in a phone-width frame inside the tablet router; `TabletShell`
  gives the full content area.
- `PanelBox` is a Material, so ink is visible inside panels.
- `DataGrid` scrolls sideways (header and body together) when its columns
  do not fit.
- Live match: player ratings are shown from full time only. They are
  pre-simulated, so showing them live would spoil the result.
- On tablet the top bar Continue owns the onboarding tour's hub target, and
  the sidebar Squad item owns the Squad tour target.
- Test harness: the seeded-save settle waits until no spinner is showing
  (10 s cap); `countryCitiesProvider` is overridden from disk in tests,
  because a cached `rootBundle` load never completes for the second test in
  a file.
- Phone guards are golden files on a seeded save at 390 x 844
  (`test/golden/`).
- German and Spanish need the 8 stage 2 keys when they merge (values in the
  stage 2 plan, Task 2).

## Stage 3 adjustments (2026-10-09)

- The Tournaments pane shows the picked competition's OWN tabs (the World
  Championship's nine, a continental cup's seven or eight, the Nations
  Cup's four, the Clash's two), not a new Groups, Fixtures, Play-offs,
  Stats set. A competition with nothing played yet says "Tournament coming
  soon". The pane opens on the competition being played now.
- Cup, continental and Nations Cup detail keep their tabs; group tables sit
  in columns (as many 280 px columns as fit, up to three) and the bracket
  opens as a bracket stretched across the width.
- Results (not in the layouts table): the manager's cycles on the left, the
  picked cycle's competitions on the right as panels of dense rows.
- Ranking: a `DataGrid` with the nation's record (`NationView`, a new
  detail pane target) beside it, the manager's own nation open first. The
  phone's "ranking over time" chart is not repeated; the nation's record
  carries its ranking history.
- The Continental Clash and the intercontinental play-off (not in the
  table) keep their phone content at a readable width; the play-off's
  Continue sits in its heading.
- Draw ceremonies choose their landscape stage inside the ceremony, so a
  resize keeps the draw. The finals draw's seeding pots sit side by side;
  the host selection puts the envelope beside the bids; the kickoff puts
  the trophy beside the words.
- A tablet's top-bar Continue runs the sim under any screen, so the sim's
  cascade invalidates every competition screen's provider
  (`SeasonService._invalidateCompetitionViews`).
- The seeded-save `settle` fails when a screen is still loading at its
  cap; the route sweep runs at 1194, 1080 and 1024 wide and covers the
  full-screen routes.
- German and Spanish need the 9 stage 3 keys when they merge (values in the
  stage 3 plan, Task 3).
- The top bar is 64 px high; the compact Continue is 44 px tall and 260
  wide so the brushed-metal button reads.
- `DataGrid` has a `DataGridController` (`indexOf`, `revealRow`) so
  "centre on my nation" follows the current sort.
- The competition detail screens share `TabletTabBar` and
  `TabletDetailPage`.
- The draw ceremonies, the finals draw, the host draw and the kickoff
  choose landscape inside their own State, so resizing keeps the draws'
  state; the kickoff's entrance fade replays when the window crosses
  1000px. Those routes are tablet-ready.
- On non-English phones, five previously hard-coded English strings in the
  draw screens are now translated ("GROUP", "Start the draw", "View
  groups", "HOST" and "CO-HOSTS"). English is unchanged.
- Known pre-existing phone bug, not fixed on this branch: on the phone
  Tournaments screen, 6 tiles with two-line names overflow by 16 px at 390
  wide. The phone guard pins it.
- Test harness: `settle` advances fake time only after its minimum rounds
  while a spinner shows; the full-screen route sweep is its own file.

## Testing

- **Phone guard**: before a screen gets a tablet layout, a widget or golden
  test at phone size pins its current UI. It must pass unchanged after.
- **Tablet tests**: each tablet layout gets a widget test at 1194 x 834: no
  overflow, panes render, selecting a row fills the detail pane.
- **Route sweep**: one test pumps every shell route at tablet size and asserts
  no layout errors.
- **Shared views**: each extracted `*View` is tested once; both hosts reuse it.
- **Copy**: all new strings go through `copy/strings.csv` and the existing
  guards (EN and CS, no em dashes, World Championship naming).
- **Devices**: iPad simulator during development; at least one real Android
  tablet before release. Installs on real devices upgrade in place (never
  `flutter install`).

## Out of scope

- Tablet portrait.
- Desktop (macOS, Windows) builds. The shell and kit are a foundation for
  them, but nothing here targets them.
- Any change to game logic, providers or the database schema. The only
  persisted addition is the per-table column view choice, held in settings (SharedPreferences).
