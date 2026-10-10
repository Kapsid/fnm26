# Tablet UI, Stage 6: The remaining screens. Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Every route that is not yet tablet-ready gets a tablet layout, except the dev-only style gallery: the nation pick as a grid of tiles beside a preview of the nation (the approved mockup, with only facts that exist before a career starts), naming the manager beside that same preview, the three out-of-work offers side by side, the cycle rollover's three steps in two columns each, settings in two columns, the friendlies as the picks beside every window's card, the team records as sortable grids beside the player pane, the full player page and the nation page in two columns, and the diagnostics log across the screen. Every screen the tablet's top-bar Continue can run the sim under stays correct, and after this stage nothing inside the shell is drawn at phone width.

**Architecture:** Same pattern as stages 2 to 5. Six of the ten screens are full-screen routes (`Routes.fullScreen`: nations, new game, start from the bottom, cycle rollover, settings, diagnostics): each picks its layout at the top of its `build` with `useTabletLayout(context, ref)` and stops being drawn through `FullScreenPhoneFrame` the moment its path joins `tabletReadyPaths`. Four are in-shell (friendlies, player, team stats, nation): each picks with `TabletShellScope.isActive(context)` and draws inside `TabletPage`. Each tablet layout lives in a `part` file beside its screen and keeps the screen's providers, State and write paths; where the phone's code is reused it is moved (verbatim) into private widgets or top-level functions both layouts call. Anything the manager chose (the previewed nation, a half-typed name, the offers drawn, the rollover's step and job, the friendlies picked) lives in the screen's State, so a window crossing 1000 px keeps it. The nation pick, new game and out-of-work offers share one new `NationPreview` widget fed by a new `nationStrengthsProvider` and `openingObjectiveTargets`, both computed without a career. The sim's cascade gains `_invalidateTeamViews` (team records, friendlies plan) and `invalidatePlayerDetails` widens to the player card's club history and cabinet. Phone goldens (a tall one for every screen that scrolls) are created before each screen is touched.

**Tech Stack:** Flutter, flutter_riverpod 2.6.1 (manual providers, no codegen), go_router 17, gen_l10n (5 ARB locales on this branch: en cs fr it pl), share_plus 12.0.2, shared_preferences, flutter_test golden files for the phone guards.

**Spec:** `docs/superpowers/specs/2026-10-09-tablet-ui-design.md` (stage 6 is the user's replacement scope recorded in "Stage 5 adjustments": convert the remaining screens; read the Screen layouts rows for "Settings, diagnostics, dev gallery, onboarding" and the "Detail pane" and "Outside the shell" sections, and every "Stage N adjustments" section, which this plan follows).

**Approved design (nation pick):** `/private/tmp/claude-501/-Users-martinurbanczyk-Documents-Work-fnm26/a581ec45-f7fb-4eb2-93a7-a828dc8142aa/scratchpad/nation-select/nation-select-tiles.html` (a top bar with back, "National level / Choose your nation", search, Random team and From the bottom; confederation chips with counts and an "N nations / sorted by world rank" line; a grid of tiles with the rank top left, a five-bar strength meter top right, a flag disc, the name and a star line; a tap previews the nation in a pane on the right with a big flag, the name, the confederation, a facts grid, a star-player card and a "Manage <nation>" metallic button over "You name your manager next"). Where the mockup's example data has no real counterpart before a career exists, the ruling table below says what replaced it and why.

**Stage 5 plan (format and conventions):** `docs/superpowers/plans/2026-10-10-tablet-ui-stage5-history-career.md`. Where it and the code differ, the code is the source of truth: `kTabletLayoutMinWidth` (1000), `useTabletLayout`, per-page framing (`ShellPhoneFrame`/`PhoneWidthFrame` in the shell, `FullScreenPhoneFrame` outside it), `PanelBox` is a `Material`, `DataGrid` (sideways scroll, `DataGridController`), `MasterDetail.minDetailWidth`, `TabletTabBar`, `TabletPage`, `TabletScreenHeader.backKey`/`backTooltip`, `ColumnFlow`, `TabletListRow`, `DetailPaneHost` with `PlayerTarget`/`NationTarget`, `openPlayer`, `shareOriginOf`, and the harness (`seedSave`, `pumpRoute`, `settle` that fails on a stuck spinner, `kTabletSizes`, `kTabletSize`, `kSeededCareerId`, `seededNationId`, `realNations`, `realPlayers`, `showTab`, `expectAppGolden`, and in `history_fixtures.dart` `squadOf`, `rivalNation`, `stopPlayClock`; in `competition_fixtures.dart` `fieldOf`, `realNationsById`).

## Global Constraints

- Phones keep the current UI exactly. Nothing in the phone path changes behaviour. Every converted screen gets a phone guard golden BEFORE it is touched (a tall one, 390 x 2400, for every screen that scrolls, beside the 390 x 844 one), and those goldens, and every golden already in `test/golden/`, must pass unchanged after. The only phone-path code changes that are not pure moves are named in their tasks and are invisible on a phone: the new game, the rollover and the friendlies navigate after their write only if the manager is still on that page (they already did only while mounted), the rollover refreshes the inbox through a captured container, the out-of-work screen gains a test-only seed (`UnemployedStartScreen.debugSeed`, null in the app), and the diagnostics clear checks `mounted` before it reloads.
- Tablet = `shortestSide >= 600` logical px. Landscape only. Tablet layouts need a window at least `kTabletLayoutMinWidth` (1000) wide; narrower tablet windows get the phone app.
- In-shell routes pick their tablet layout with `TabletShellScope.isActive(context)`: friendlies, player, team stats, nation. Full-screen routes (`Routes.fullScreen`) pick theirs with `useTabletLayout(context, ref)`: nations, new game, start from the bottom, cycle rollover, settings, diagnostics. Never the other way round.
- A screen's path is added to `tabletReadyPaths` IN THE SAME COMMIT as its layout. An unregistered in-shell screen would draw its tablet layout inside a 600 phone frame; an unregistered full-screen one inside `FullScreenPhoneFrame`. After this stage the only route not in `tabletReadyPaths` is `Routes.gallery` (dev only, stays phone-framed).
- Every tablet layout is tested at 1194 x 834, 1080 x 810 and 1024 x 768 (`kTabletSizes`): no exception, the layout's key present, no `PhoneWidthFrame` (in-shell) or `FullScreenPhoneFrame` (full screen). Both route sweeps (`test/widget/tablet_route_sweep_test.dart`, `test/widget/tablet_full_screen_sweep_test.dart`) stay green after every task.
- `DashboardGrid` rows and `ColumnFlow` rows are `IntrinsicHeight`s: nothing inside a tile may be a scrollable, a `LayoutBuilder` or a `WholeText`. Leaderboards are `DataGrid`s, never `LeaderRow`s in a tile. A panel whose body scrolls is `Panel(expand: true)` in a Row or Column.
- Release target: v1.0.4 on both iOS and Android. Do not bump `pubspec.yaml` in this stage.
- No `@riverpod` codegen; providers by hand. No change to game logic or the database schema. New providers here are display reads only (`nationStrengthsProvider`), and the cascade only gains invalidations (Task 2). `teamStatsProvider` is the existing private provider moved and made public, unchanged.
- Derived providers go stale after a sim step. On a tablet the top bar's Continue runs the sim while ANY in-shell screen is on show, so every provider an in-shell tablet layout keeps on show is refreshed by the cascade (Task 2) or is one the phone layout of the same screen already watches and the cascade already refreshes. Full-screen screens have no top bar.
- Writes and navigation go through the phone's own code: the tablet calls the same State methods and functions (`_NewGameScreenState._start`, `_CycleRolloverScreenState._begin`, `_FriendliesScreenState._confirm`, `setSoundHaptics`, `_pickLanguage`, `_BackupCardState._export`/`_restore`, the nation pick's `_startRandom`). Nothing here adds a second write path.
- Post-await safety: a handler that awaits takes what it needs (the router, the container, services, ids) BEFORE its first await, and navigates after a write only if `router.state.uri.path` is still its own route. Tasks 5, 7 and 9 pin it by leaving the page while the write is held at a gate.
- Sheets and dialogs: on a tablet `showAdaptiveSheet` is a root dialog. Inside its builder pop with the sheet's own context. The language picker already does (`Navigator.of(ctx).pop(v)`); Task 8 pins it.
- Share sheets keep their anchor: the settings backup export passes `shareOriginOf(button)` from a `Builder` around its button. It is moved, not rewritten; Task 8 pins the rect the share channel receives.
- Draws read stored groups and are never re-run; every continental or nationsLeague lookup names a confederation. `openingObjectiveTargets` and `NationPreview` look the continental cup up by the nation's own confederation (`ContinentalCups.byConfederation[nation.confederation]`). Nothing here reads a draw.
- If any `build_runner` step is needed, run it with `--force-jit`. (Nothing in this plan should need it.)
- All new user-facing strings go into all 5 ARB files (`en cs fr it pl`), then `flutter gen-l10n`, then `dart run tool/export_copy.dart` so `copy/strings.csv` stays in sync. German and Spanish ARB files are not on this branch; the 15 new keys of Task 1 must be added to them when that work merges (values listed in Task 1). Prefer existing keys; reused keys are named in each task.
- No em dashes in user-facing copy (new code never falls back to '—'; it uses `l.hubUnknown` or an empty string). Never "World Cup" in English copy (it is "World Championship"). French text puts a no-break space before a clause colon; the new copy avoids colons.
- Tests asserting a write read the stored value BEFORE the action as well as after. `SeededSave.career` is the career as created (its `budget` is 0, the opening grant is written after): read stored values from `careerRepositoryProvider`, `competitionRepositoryProvider` or `SharedPreferences`.
- Riverpod 2.6.1 teardown quirk (Stage 4 adjustments): an invalidated FutureProvider element that is never rebuilt before the container is disposed throws "Bad state: Future already completed" at dispose. Tests that create a save end with `stopPlayClock` (it re-reads `savesProvider`); a provider a test overrides and the screen invalidates is overridden with a value that has no awaits (`(ref) async => value`). Say why in a comment wherever a test does either.
- Never run `flutter install` against a physical device. Simulators only in this stage; a simulator build is installed in place with `xcrun simctl install`, never uninstalled first.
- Commit messages end with `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`.
- Run tests with `flutter test` from the repo root. Golden baselines are created ONLY in the "create the baseline" step of a task (`flutter test --update-goldens <file>`), before the screen is changed, and committed in that step. Never update a golden to make a later step pass; a changed phone golden is a phone regression. If a phone screen already overflows when its guard is first run, do NOT fix it: count the overflows in the guard as `test/golden/phone_guard_legends_test.dart` does, and report it.
- `settle` fails loudly when a screen is still showing a `CircularProgressIndicator` at its cap, unless the call passes `allowSpinner: true` with a comment saying why the spinner is the screen's content. No call in this plan needs it.
- Text fields in goldens: tests that pump a screen with a focused `TextField` set `EditableText.debugDeterministicCursor = true` (and reset it in a tear-down), so a blinking cursor never decides a golden.

## Review depth

User-approved: low-risk read-only display screens get ONE combined review per batch; anything that writes, navigates, starts a career, shared code and event flows are reviewed per task. Each task is tagged:

- **risk: high (per-task review)**: Tasks 2, 3, 4, 5, 6, 7, 8, 9.
- **risk: low (batched review)**: Tasks 1, 10, 11, 12, 13. Review Tasks 1, 10, 11, 12 and 13 together once Task 13 lands (one reviewer, given those tasks' commit SHAs from the ledger), before Task 14 starts. The batch reviewer checks Task 12's retirement of `shell_frame_transition_test.dart` and the guard that replaces it explicitly.

## Review Focus

1. **A fact before the career that the career then contradicts.** The nation pick, new game and out-of-work offers show a nation before any save exists. A number the first hub then contradicts (another budget, another brief, another overall) or a player name the save does not use reads as the game lying. Every save renames its players (measured on the seeded save: all 209 nations' best players carry another name in the save), so no name is shown. Pinned in Task 3: on the seeded save, the preview's opening budget is the budget the repository holds, its two briefs are the targets `cycleObjectiveOutcomesProvider` set, its squad overall is within 2 of the save's own (club minutes), and the best player's seed name is nowhere on screen.
2. **One stray tap starts a career.** A tile tap only previews; only "Manage <nation>" goes to the new game. Pinned in Task 4: a tile tap leaves the page on `/nations` and the pane on that nation; Manage goes to `/new-game?nationId=` that nation.
3. **A resize that throws away a choice.** iPadOS windows resize. The previewed nation and the search (Task 4), a half-typed manager name (Task 5), the three offers drawn (Task 6), the rollover's step and the job picked (Task 7) and the friendlies picked (Task 9) live in the State both layouts share; each is pinned by shrinking the window to 900 x 810 (the phone shows the same choice) and growing it back.
4. **A write that drags back a manager who has left.** Creating a save, rolling the cycle and saving friendlies all await, and on a tablet the manager can push Settings or tap the sidebar meanwhile. Pinned by holding the write at a gate and leaving: Task 5 (Settings pushed over the new game), Task 7 (back to the saves mid-roll), Task 9 (the ranking from the sidebar mid-save). The write still lands; the manager stays where he went.
5. **Stale screens under the top bar's Continue.** The team records read appearances and goals imperatively; the friendlies page keeps the plan alive, and the hub's next event reads that same plan, so a stale one would let the sim run past a new gap; the player card shown beside every grid also carries a club history (it moves each 1 December) and a cabinet (awards land at the end of a tournament). Pinned in Task 2: one `advance` and one `playPlayerMatch` each hand `teamStatsProvider`, `friendliesPlanProvider`, `clubHistoryProvider` and `playerAwardsProvider` a new future, plus the source guard that `_skipToChampion` runs the same cascade.
6. **Phone drift from moved code.** Tasks 2, 4, 5, 6, 7, 8, 9, 10, 11 and 13 move phone code (the team records provider, the nation pick's filter and random pick, the free-cycle note, the out-of-work seed, the rollover's step setters and `_begin`, the settings cards, the friendlies helpers and `_confirm`, the player card's sections, the vitrine's section label, the diagnostics' copy and clear). Pinned by phone goldens of each screen created before it is touched, and by the existing `nation_select_screen_test`, `language_picker_test`, `settings_free_scope_test`, `cycle_rollover_always_has_a_way_out_test`, `phone_guard_player_test` and `phone_guard_nation_vitrine_test`, which must pass untouched.
7. **The settings backup on an iPad.** The export is the whole-database backup; an iPad refuses a share sheet without an on-screen anchor. Pinned in Task 8: the share channel receives exactly the Export button's rect from the tablet layout.

---

## File structure

**Create**
- `lib/features/nations/nation_preview.dart`: `StrengthMeter`, `NationPreview` (a nation before any career: facts, best player, the board's first demands).
- `lib/features/nations/nation_select_tablet_layout.dart` (part of `nation_select_screen.dart`).
- `lib/features/career/new_game_tablet_layout.dart` (part of `new_game_screen.dart`).
- `lib/features/career/unemployed_start_tablet_layout.dart` (part of `unemployed_start_screen.dart`).
- `lib/features/hub/cycle_rollover_tablet_layout.dart` (part of `cycle_rollover_screen.dart`).
- `lib/features/settings/settings_tablet_layout.dart` (part of `settings_screen.dart`).
- `lib/features/settings/diagnostics_tablet_layout.dart` (part of `diagnostics_screen.dart`).
- `lib/features/friendlies/friendlies_tablet_layout.dart` (part of `friendlies_screen.dart`).
- `lib/features/player/player_tablet_layout.dart` (part of `player_detail_screen.dart`).
- `lib/features/nations/nation_vitrine_tablet_layout.dart` (part of `nation_vitrine_screen.dart`).
- `lib/features/stats/team_stats_tablet_layout.dart` (part of `team_stats_screen.dart`).
- `test/helpers/team_fixtures.dart`: a fake friendlies plan and fake team records.
- `test/golden/phone_guard_{team_stats,nations,new_game,unemployed,rollover,settings,friendlies,player_tall,diagnostics}_test.dart` and their `test/golden/goldens/*.png`.
- Tests listed per task.

**Modify**
- `lib/features/shell/tablet_shell.dart` (`tabletReadyPaths`).
- `lib/features/hub/hub_providers.dart` (`SeasonService._invalidateTeamViews`).
- `lib/features/hub/objective_providers.dart` (`openingObjectiveTargets`).
- `lib/features/stats/stats_providers.dart` (`teamStatsProvider` and its typedefs, moved in).
- `lib/features/nations/nation_select_providers.dart` (`NationStrength`, `nationStrengthsProvider`, `strengthTiers`).
- `lib/features/nations/nation_select_screen.dart`, `nation_vitrine_screen.dart`.
- `lib/features/career/new_game_screen.dart`, `unemployed_start_screen.dart`.
- `lib/features/hub/cycle_rollover_screen.dart`.
- `lib/features/settings/settings_screen.dart`, `diagnostics_screen.dart`.
- `lib/features/friendlies/friendlies_screen.dart`.
- `lib/features/player/player_detail_screen.dart` (`invalidatePlayerDetails`, the card's sections).
- `lib/features/stats/team_stats_screen.dart`.
- `test/widget/competition_refresh_after_step_test.dart` (Task 2), `test/widget/home_tablet_test.dart` (Task 4), `test/widget/tablet_route_sweep_test.dart` (Task 12).
- Delete: `test/widget/shell_frame_transition_test.dart` (Task 12; see the rulings).
- `lib/l10n/app_{en,cs,fr,it,pl}.arb`, generated `app_localizations*.dart`, `copy/strings.csv`.
- `docs/superpowers/specs/2026-10-09-tablet-ui-design.md` (Task 14).

## Rulings on the spec (recorded in the spec by Task 14)

| Spec text | Ruling |
|---|---|
| Phasing, "6. Polish: column picker views persisted, collapsible sidebar, store screenshots, iPad App Store listing" | Replaced by the user: stage 6 converts every route not yet in `tabletReadyPaths` except the dev-only gallery (nations, new game, start from the bottom, team stats, cycle rollover, settings, friendlies, player, nation, diagnostics). The column picker, the collapsible sidebar, the store screenshots, the iPad listing and the Android tablet check are dropped from this release, and so is the "per-table column view choice" the spec's Out of scope names as the one persisted addition. |
| "Settings, diagnostics, dev gallery, onboarding: phone layout centred in the content area, max width 600" | Settings and diagnostics get landscape layouts (the user's scope): settings in two columns of the phone's cards, the diagnostics log across the screen with Copy and Clear in the heading. The style gallery is a developer tool and stays in `FullScreenPhoneFrame`. Onboarding is the tour overlay drawn on real screens; it has no route of its own to convert. |
| "Detail pane: player, nation, team stats and H2H ... `TeamStatsView`" | There is no `TeamStatsView`: nothing in the app opens the team records beside a list. Its own page is converted instead, like the record book: the boards as sortable grids beside the player pane. The full player and nation pages get two-column layouts; the panes keep rendering `PlayerView` and `NationView` in one column. |
| Nation-pick mockup: "Star <player name>" on a tile and in the star card | No name. Every save names its players afresh (`_namerFor` with the save's seed): in the seeded save all 209 nations' best players carry a different name from the seed data. A name shown before the career would not exist in it. The tile reads "Star ST 93" and the card shows the best player's position, age and rating, which are the same in the save. |
| Nation-pick mockup: "Budget" fact | Kept, as "Opening budget": `FederationFinance.initialBudget(rank)` is exactly what `CareerService.create` stores (€45M for the seeded France, read back from the repository in Task 3). |
| Nation-pick mockup: "The board expects" | Kept, as the two headline briefs of the first cycle: the World Championship and the nation's continental championship. The first cycle's baseline is the static seed ranking (cycle 0 is never snapshotted), so `openingObjectiveTargets` returns exactly the targets `cycleObjectiveOutcomesProvider` sets (Task 3 compares them on the seeded save). The Nations Cup brief is left to the board screen: it depends on the league tier the save seeds, and two briefs fit the pane. |
| Nation-pick mockup: "Strength N of 5", "Squad overall" | Both kept, from real data: the squad overall is `squadOverall` of the nation's seed-free pool (`byNation(id)`, the pool the world simulation draws every opponent from); a save's own pool also feels club minutes, which moved every nation by at most 2 on the seeded save. Strength is which fifth of the world that overall falls in (`strengthTiers`, ties share a tier). |
| Nation-pick mockup: "World rank" fact | Kept: `nation.ranking`, the seed ranking a save starts on. |
| "The previewed nation must survive a resize" (user) | The previewed nation is the screen State's (`_NationSelectScreenState._previewId`). The pane shows it while it is among the tiles on show and the first tile otherwise (a confederation change or a search can hide it), so the pane is never empty while there are tiles. The search and the confederation are the phone's global providers, so they survive too; the tablet's search field is seeded from the query each time the tablet layout is built. The phone's own search field is uncontrolled and shows empty after a resize while its list stays filtered, as it already does when the manager leaves the screen and comes back; that is phone behaviour and is not changed. |
| Cycle rollover freshness (no cascade) | None needed. The rollover is a full-screen route entered with `go`, so the shell and every in-shell screen are torn down while it runs (the comment in `_startNextCycle` says so); `_startNextCycle` already invalidates the hub's data, the ranking and the board. The screen now refreshes the inbox through a captured container, so it happens even if the manager leaves mid-roll. |
| Friendlies freshness | The cascade invalidates `friendliesPlanProvider`. While friendlies are due the top bar's Continue only routes to them, but a friendlies page on show keeps the plan alive and the hub's next event reads the same plan: left stale after a step, a gap the step opened would never be offered. |
| `test/widget/shell_frame_transition_test.dart` ("/team-stats is the phone-framed destination ... until it converts (then pick another)") | Retired deliberately in Task 12: after team stats converts there is no phone-framed in-shell page left to leave for, so the bug it guarded (a page framed by the CURRENT location while it transitions out) cannot happen in the app. `ShellPhoneFrame` stays as the fallback for a future route, and the shell sweep gains a guard that fails on any in-shell route without a tablet layout, which is what keeps it unreachable. Its unit tests in `tablet_shell_test.dart` stay. |
| The rollover has "no way out" on the phone's first two steps | On the tablet every step carries the phone's own "Back to your saves" (`_backToSaves`), as the phone's own comment requires of every state of that screen. The phone is not changed. |
| Back arrows | Team records go back to the Career page when there is nothing to pop (a page under a sidebar destination, the stage 5 rule); the player page to the hub; the nation page to the ranking (as on the phone); friendlies to the hub (as on the phone); settings to home; diagnostics to settings; new game to the nations (as on the phone); out of work and the nation pick to the nations and home (as on the phone). The out-of-work "Back to menu" button is the tablet's back arrow (same destination). |

## Stage 5 carry-overs

None. Stage 5 closed its findings on the branch (up to `476a189`) and recorded them in the spec's Stage 5 adjustments.

---

### Task 1: Stage 6 copy in all 5 languages

**risk: low (batched review)**.

**Files:**
- Modify: `lib/l10n/app_en.arb`, `app_cs.arb`, `app_fr.arb`, `app_it.arb`, `app_pl.arb`
- Regenerate: `lib/l10n/app_localizations*.dart`, `copy/strings.csv`
- Test: existing `test/unit/l10n/*` guards

**Interfaces:**
- Produces these `AppLocalizations` members: `nationsShownCount(int count)`, `nationsSortedByRank`, `nationsStrength`, `nationsStrengthOf(int tier)`, `nationsSquadOverall`, `nationsOpeningBudget`, `nationsStarPlayer`, `nationsStarTile(String position, int rating)`, `nationsStarAge(int age)`, `nationsBoardExpects`, `nationsManage(String nation)`, `nationsManagerNext`, `playerPageTitle`, `nationPageTitle`, `friendliesYourGames`.
- Reused existing getters (do not add): `hubWorldRankLabel`, `nationsNationalLevel`, `nationsSelectHeading`, `nationsSearchHint`, `nationsRandomTeam`, `nationsFromTheBottom`, `nationsNoMatch`, `nationsCouldNotLoadNations`, `objectiveWorldCup`, `careerNewGame`, `careerManagerName`, `careerManagerNameHint`, `careerBeginsBlurb`, `careerFreeCycleNote`, `careerStartCareer`, `careerCouldNotLoadNation`, `careerNationNotFound`, `bottomStartTitle`, `bottomStartHeading`, `bottomStartBlurb`, `bottomStartAccept`, `bottomStartRankOf`, `hubContinue`, `hubBackToSaves`, `hubWorldChampionsYear`, `hubCycleComplete`, `hubYourJob`, `hubStayProject`, `hubChooseNextJob`, `hubOffersOnTable`, `hubContinueWith`, `hubYourNation`, `hubTakeTheJob`, `hubFederationFinances`, `hubBudgetIntro`, `hubStarting`, `hubContinueCareer`, `hubBeginNextCycle`, `hubCouldNotLoad`, `hubCouldNotLoadFinances`, `hubUnknown`, `homeSettings`, `settingsDiagnosticsTitle`, `diagnosticsCopy`, `diagnosticsClear`, `diagnosticsEmpty`, `hubEventArrangeFriendlies`, `friendliesArrangeIntro`, `friendliesFree`, `friendliesNoneThisWindow`, `friendliesConfirmCount`, `friendliesContinue`, `friendliesLoadError`, `careerTeamRecords`, `statsTopScorersShort`, `statsMostGames`, `statsBestRated`, `statsMyCareer`, `statsNoGoalsRecorded`, `statsNoRatingsRecorded`, `statsNoData`, `statsUnknown`, `statsCouldNotLoadStats`, `playerStatGoals`, `playerStatCaps`, `playerLoadError`, `playerNotFound`, `nationsNoNation`, `nationsCouldNotLoad`, `nationsHonours`, `nationsRankingHistory`, `nationsTopScorers`, `nationsTitles`, `gridViewOverview`, `gridColRank`, `gridColPlayer`, `gridColActive`, `gridColMotm`, `gridColAvg`.

- [ ] **Step 1: Add the English strings with descriptions**

Append before the closing `}` of `lib/l10n/app_en.arb` (add a comma after the previous last entry, `"@gridColManager": {...}`):

```json
  "nationsShownCount": "{count, plural, =1{1 nation} other{{count} nations}}",
  "@nationsShownCount": {
    "description": "Tablet nation pick: how many nation tiles are on show for the current confederation or search.",
    "placeholders": { "count": { "type": "int" } }
  },
  "nationsSortedByRank": "Sorted by world rank",
  "@nationsSortedByRank": { "description": "Tablet nation pick: says the tiles are ordered by world ranking." },
  "nationsStrength": "Strength",
  "@nationsStrength": { "description": "Tablet nation preview: label of the nation's strength out of five (which fifth of the world its squad's overall puts it in)." },
  "nationsStrengthOf": "{tier} of 5",
  "@nationsStrengthOf": {
    "description": "Tablet nation preview: the strength value, out of five.",
    "placeholders": { "tier": { "type": "int" } }
  },
  "nationsSquadOverall": "Squad overall",
  "@nationsSquadOverall": { "description": "Tablet nation preview: label of the average overall of the nation's best eleven." },
  "nationsOpeningBudget": "Opening budget",
  "@nationsOpeningBudget": { "description": "Tablet nation preview: the money a new save with this nation starts with." },
  "nationsStarPlayer": "Star player",
  "@nationsStarPlayer": { "description": "Tablet nation preview: heading over the nation's best player (position, age and rating; no name, because every save names its players)." },
  "nationsStarTile": "Star {position} {rating}",
  "@nationsStarTile": {
    "description": "Tablet nation tile: the best player's position code and rating, e.g. 'Star ST 93'.",
    "placeholders": { "position": { "type": "String" }, "rating": { "type": "int" } }
  },
  "nationsStarAge": "Age {age}",
  "@nationsStarAge": {
    "description": "Tablet nation preview: the best player's age.",
    "placeholders": { "age": { "type": "int" } }
  },
  "nationsBoardExpects": "The board expects",
  "@nationsBoardExpects": { "description": "Tablet nation preview: heading over what the board will demand in the first cycle." },
  "nationsManage": "Manage {nation}",
  "@nationsManage": {
    "description": "Tablet nation pick: the button that takes the previewed nation's job.",
    "placeholders": { "nation": { "type": "String" } }
  },
  "nationsManagerNext": "You name your manager next",
  "@nationsManagerNext": { "description": "Tablet nation pick: the hint under the Manage button." },
  "playerPageTitle": "Player",
  "@playerPageTitle": { "description": "Tablet heading of a player's full page." },
  "nationPageTitle": "Nation",
  "@nationPageTitle": { "description": "Tablet heading of a nation's page (its honours, ranking history, scorers and titles)." },
  "friendliesYourGames": "Your friendlies",
  "@friendliesYourGames": { "description": "Tablet friendlies: heading of the panel listing each open window and the opponent picked for it." }
```

- [ ] **Step 2: Add the translations**

Append the same keys (values only, no `@` entries) to each locale file, after its last entry (add the comma). The plural forms are Czech one/few/other and Polish one/few/many/other, as in the existing `friendliesConfirmCount`:

| key | cs | fr | it | pl |
|---|---|---|---|---|
| nationsShownCount | `{count, plural, one{1 reprezentace} few{{count} reprezentace} other{{count} reprezentací}}` | `{count, plural, one{{count} sélection} other{{count} sélections}}` | `{count, plural, one{1 nazionale} other{{count} nazionali}}` | `{count, plural, one{1 reprezentacja} few{{count} reprezentacje} many{{count} reprezentacji} other{{count} reprezentacji}}` |
| nationsSortedByRank | Seřazeno podle světového žebříčku | Classées par rang mondial | Ordinate per ranking mondiale | Według rankingu światowego |
| nationsStrength | Síla | Force | Forza | Siła |
| nationsStrengthOf | {tier} z 5 | {tier} sur 5 | {tier} su 5 | {tier} z 5 |
| nationsSquadOverall | Hodnocení kádru | Note de l'effectif | Valore della rosa | Ocena kadry |
| nationsOpeningBudget | Počáteční rozpočet | Budget de départ | Budget iniziale | Budżet na start |
| nationsStarPlayer | Hvězda týmu | Joueur vedette | Stella della squadra | Gwiazda drużyny |
| nationsStarTile | Hvězda {position} {rating} | Vedette {position} {rating} | Stella {position} {rating} | Gwiazda {position} {rating} |
| nationsStarAge | Věk {age} | {age} ans | {age} anni | Wiek {age} |
| nationsBoardExpects | Vedení očekává | La direction attend | La dirigenza si aspetta | Zarząd oczekuje |
| nationsManage | Převzít tým ({nation}) | Prendre les rênes ({nation}) | Prendi le redini ({nation}) | Obejmij kadrę ({nation}) |
| nationsManagerNext | Jméno trenéra zadáte v dalším kroku | Vous nommerez votre sélectionneur ensuite | Subito dopo scegli il nome dell'allenatore | Imię trenera podasz w następnym kroku |
| playerPageTitle | Hráč | Joueur | Giocatore | Zawodnik |
| nationPageTitle | Reprezentace | Sélection | Nazionale | Reprezentacja |
| friendliesYourGames | Vaše přátelská utkání | Vos matchs amicaux | Le tue amichevoli | Twoje sparingi |

(`nationsManage` keeps the nation's name in the nominative, in brackets, in the four inflected languages, so no case ending is needed; English and the de/es values put it after the verb.)

For the de/es files when they merge (not on this branch): nationsShownCount `{count, plural, one{1 Nationalteam} other{{count} Nationalteams}}` / `{count, plural, one{1 selección} other{{count} selecciones}}`; nationsSortedByRank `Nach Weltrangliste sortiert` / `Ordenadas por ranking mundial`; nationsStrength `Stärke` / `Fuerza`; nationsStrengthOf `{tier} von 5` / `{tier} de 5`; nationsSquadOverall `Kaderwertung` / `Media de la plantilla`; nationsOpeningBudget `Startbudget` / `Presupuesto inicial`; nationsStarPlayer `Star des Teams` / `Estrella del equipo`; nationsStarTile `Star {position} {rating}` / `Estrella {position} {rating}`; nationsStarAge `{age} Jahre` / `{age} años`; nationsBoardExpects `Der Vorstand erwartet` / `La directiva espera`; nationsManage `{nation} übernehmen` / `Dirigir a {nation}`; nationsManagerNext `Als Nächstes gibst du deinem Trainer einen Namen` / `A continuación eliges el nombre de tu seleccionador`; playerPageTitle `Spieler` / `Jugador`; nationPageTitle `Nationalteam` / `Selección`; friendliesYourGames `Deine Testspiele` / `Tus amistosos`.

- [ ] **Step 3: Regenerate typed strings and the copy file**

```bash
flutter gen-l10n
dart run tool/export_copy.dart
```

Expected: no "untranslated" entries for the new keys in `lib/l10n/untranslated.txt`; `copy/strings.csv` gains 15 rows.

- [ ] **Step 4: Run the l10n guards**

Run: `flutter test test/unit/l10n`
Expected: PASS (the round-trip guard checks every translation carries its English placeholders; the French guard finds no colon).

- [ ] **Step 5: Commit**

```bash
git add lib/l10n copy/strings.csv
git commit -m "feat(tablet): stage 6 copy (nation preview, player and nation pages, friendlies)

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 2: The team records, the friendlies plan and the player card refresh after a sim step

**risk: high (per-task review)**. Touches `SeasonService`'s invalidation cascade, and moves a provider out of a phone screen.

Stages 3 to 5 made the cascade (`_invalidateCompetitionViews`, run at the end of the advance step, `_skipToChampion` and `_playPlayerMatch`) refresh every competition, federation, manager, Y, history and career screen. Three things a tablet keeps on show while the top bar's Continue runs are still missed:

- **The team records** (`/team-stats`, in-shell): its private `_teamStatsProvider` reads the goals, caps and ratings imperatively. It is already in the shell (phone-framed today), so this is a live bug on a tablet now. The provider moves, unchanged, to `stats_providers.dart` as the public `teamStatsProvider` so the cascade can name it (its typedefs become public: `TeamStatEntry`, `TeamRatingEntry`, `TeamStatsData`).
- **The friendlies plan** (`friendliesPlanProvider`): the friendlies page keeps it alive, and the hub's `nextEventProvider` reads the SAME plan. Left stale after a step, a friendly gap the step opened would never be offered and the sim would run past it. On a phone the plan is effectively re-read after every step (nobody keeps it alive across one), so invalidating it changes nothing a phone can see.
- **The player card's club history and cabinet** (`clubHistoryProvider`, `playerAwardsProvider`): `PlayerView`, shown in every stage 2 to 5 detail pane and on the player page, watches both. The club history moves each 1 December; awards land when a tournament ends. `invalidatePlayerDetails` (already called by the cascade) widens to them.

**Files:**
- Create: `test/golden/phone_guard_team_stats_test.dart` (and `test/golden/goldens/team_stats_phone.png`)
- Modify: `lib/features/stats/stats_providers.dart`, `lib/features/stats/team_stats_screen.dart`, `lib/features/player/player_detail_screen.dart`, `lib/features/hub/hub_providers.dart`
- Modify: `test/widget/competition_refresh_after_step_test.dart`

**Interfaces:**
- Produces (`stats_providers.dart`): `typedef TeamStatEntry = ({int playerId, int value});`, `typedef TeamRatingEntry = ({int playerId, int apps, double meanRating, int motms});`, `typedef TeamStatsData = ({Nation? nation, List<TeamStatEntry> scorers, List<TeamStatEntry> appearances, List<TeamRatingEntry> ratings, Map<int, String> names, Set<int> active});`, `final AutoDisposeFutureProviderFamily<TeamStatsData?, int> teamStatsProvider`. Tasks 9 and 12 build fakes of `TeamStatsData` and override `teamStatsProvider(kSeededCareerId)`.
- Produces: `SeasonService._invalidateTeamViews()` (private), called from the end of `_invalidateCompetitionViews()`, after `_invalidateHistoryViews();`.
- Changes: `void invalidatePlayerDetails(Ref ref)` also invalidates `clubHistoryProvider` and `playerAwardsProvider`.
- Consumes: `friendliesPlanProvider` (`friendlies_providers.dart`), `clubHistoryProvider` (`club_history_providers.dart`), `playerAwardsProvider` (`award_providers.dart`).

- [ ] **Step 1: Pin the phone team records before the provider moves**

Create `test/golden/phone_guard_team_stats_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';

import '../helpers/seeded_save.dart';

/// The phone team records, pinned before their provider moves out of the
/// screen (Task 2) and before the tablet layout is added beside them (Task
/// 12): a fresh save, nothing scored yet.
void main() {
  testWidgets('team_stats_phone', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.teamStats}?careerId=${save.careerId}',
    );
    expect(find.text(enL.statsNoGoalsRecorded), findsOneWidget);
    await expectAppGolden('goldens/team_stats_phone.png');
  });
}
```

- [ ] **Step 2: Create the baseline, confirm it holds, commit it**

```bash
flutter test --update-goldens test/golden/phone_guard_team_stats_test.dart
flutter test test/golden/phone_guard_team_stats_test.dart
git add test/golden/phone_guard_team_stats_test.dart test/golden/goldens/team_stats_phone.png
git commit -m "test(tablet): phone guard for the team records

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

- [ ] **Step 3: Write the failing tests**

In `test/widget/competition_refresh_after_step_test.dart`, add these imports, sorted into the existing `package:fnm/features/...` block (`stats_providers.dart` is already imported):

```dart
import 'package:fnm/features/awards/award_providers.dart';
import 'package:fnm/features/friendlies/friendlies_providers.dart';
import 'package:fnm/features/player/club_history_providers.dart';
```

Add, directly below `_historyViews`:

```dart
/// The remaining screens' data (stage 6): the team records, the friendlies
/// plan (which the hub's next event also reads), and the player card's club
/// history and cabinet, shown beside every grid and on the player page.
_Views _teamViews(SeededSave save, int playerId) {
  final id = save.careerId;
  final player = (careerId: id, playerId: playerId);
  return {
    'teamStats': teamStatsProvider(id).future,
    'friendlies': friendliesPlanProvider(id).future,
    'clubHistory': clubHistoryProvider(player).future,
    'playerAwards': playerAwardsProvider(player).future,
  };
}
```

In BOTH step tests ('a step refreshes every screen a tablet keeps on show' and "so does committing the manager's own match") replace

```dart
      {
        ..._competitionViews(save),
        ..._federationViews(save),
        ..._historyViews(save, playerId),
      },
```

with

```dart
      {
        ..._competitionViews(save),
        ..._federationViews(save),
        ..._historyViews(save, playerId),
        ..._teamViews(save, playerId),
      },
```

In the source-guard test 'skipping to the champion runs the same refresh', directly after

```dart
    expect(cascadeBody, _callLine('_invalidateHistoryViews'));
```

add

```dart
    expect(cascadeBody, _callLine('_invalidateTeamViews'));
```

and make the first line of the doc comment above `main()` read `/// Review Focus 3 (stage 3), 1 (stage 4), 1 (stage 5) and 5 (stage 6). A tablet's top bar runs the sim`.

- [ ] **Step 4: Run them to verify they fail**

Run: `flutter test test/widget/competition_refresh_after_step_test.dart`
Expected: FAIL to compile (`teamStatsProvider` does not exist yet).

- [ ] **Step 5: Move the team records provider, unchanged, into `stats_providers.dart`**

In `lib/features/stats/stats_providers.dart` add the imports (sorted into the existing block):

```dart
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';
```

and append at the end of the file:

```dart
/// One player's line on a team leaderboard: who, and his tally.
typedef TeamStatEntry = ({int playerId, int value});

/// One player's line on the team's ratings board.
typedef TeamRatingEntry = ({
  int playerId,
  int apps,
  double meanRating,
  int motms,
});

/// The team records page's data: the manager's nation, its three all-time
/// boards, the name of everyone on them, and which of them still play.
typedef TeamStatsData = ({
  Nation? nation,
  List<TeamStatEntry> scorers,
  List<TeamStatEntry> appearances,
  List<TeamRatingEntry> ratings,
  Map<int, String> names,
  Set<int> active,
});

/// The team records (`/team-stats`) of [careerId]'s nation.
///
/// Moved here from the screen, unchanged, so the sim's cascade can refresh
/// it (`SeasonService._invalidateTeamViews`): it reads the goals, the caps and
/// the ratings imperatively, and a tablet keeps the page on show while the
/// top bar's Continue runs a step.
final AutoDisposeFutureProviderFamily<TeamStatsData?, int> teamStatsProvider =
    FutureProvider.autoDispose.family<TeamStatsData?, int>((
      ref,
      careerId,
    ) async {
      final career = await ref.watch(careerRepositoryProvider).byId(careerId);
      if (career == null) return null;
      final comp = ref.watch(competitionRepositoryProvider);
      final nationId = career.nationId;

      final scorers = [
        for (final s in await comp.nationTopScorers(
          careerId,
          nationId,
          limit: 25,
        ))
          (playerId: s.playerId, value: s.goals),
      ];
      final appearances = [
        for (final a in await comp.nationTopAppearances(
          careerId,
          nationId,
          limit: 25,
        ))
          (playerId: a.playerId, value: a.games),
      ];
      // Best average match rating. Every match in the world is rated now, so
      // this is a full record rather than only the games the manager was in
      // charge for.
      final ratings = await comp.nationTopRatings(
        careerId,
        nationId,
        limit: 25,
      );

      final playerRepo = ref.watch(playerRepositoryProvider);
      final aging = CareerService.agingYears(career);
      final youth = await ref.watch(
        youthBonusByCycleProvider(careerId).future,
      );
      final careerDev = await ref.watch(
        careerDevBonusProvider(careerId).future,
      );
      final ids = {
        for (final s in [...scorers, ...appearances]) s.playerId,
        for (final r in ratings) r.playerId,
      };
      final names = <int, String>{};
      // Who on these all-time boards is still playing — the same rule the
      // pool retires on, so a chart-topper you could still pick stands apart
      // from the legends above and below him.
      final active = <int>{};
      for (final id in ids) {
        final p = await playerRepo.byId(
          id,
          agingYears: aging,
          saveSeed: career.rngSeed,
          youthBonusByCycle: youth,
          careerStartsByPlayer: careerDev,
        );
        names[id] = p?.name ?? 'Unknown';
        if (p != null && !PlayerLifecycle.hasRetiredAt(p.id, p.age, aging)) {
          active.add(id);
        }
      }

      final nations = await ref.watch(nationRepositoryProvider).all();
      return (
        nation: nations.where((n) => n.id == nationId).firstOrNull,
        scorers: scorers,
        appearances: appearances,
        ratings: ratings,
        names: names,
        active: active,
      );
    });
```

In `lib/features/stats/team_stats_screen.dart`:

1. Delete everything from `typedef _StatEntry = ({int playerId, int value});` down to and including the closing `});` of `_teamStatsProvider` (the three typedefs and the provider).
2. Replace `ref.watch(_teamStatsProvider(widget.careerId))` with `ref.watch(teamStatsProvider(widget.careerId))`.
3. In `_RatingRow`, replace `final _RatingEntry entry;` with `final TeamRatingEntry entry;`.
4. Remove the imports the screen no longer uses: `package:fnm/data/data_providers.dart`, `package:fnm/domain/services/player/player_lifecycle.dart`, `package:fnm/features/career/career_providers.dart` and `package:fnm/features/federation/federation_providers.dart` (`flutter analyze` names any other that has become unused; remove only those it names).

Nothing else in the screen changes.

- [ ] **Step 6: Widen the player card's refresh**

In `lib/features/player/player_detail_screen.dart` add the import `package:fnm/features/player/club_history_providers.dart` (sorted into the `features/` block; `award_providers.dart` is already imported) and replace

```dart
/// Drops every cached player detail, so a pane on show re-reads its player.
/// The sim's cascade calls it after a step: on a tablet a [PlayerView] pane
/// stays on show beside the history, squad and ranking grids while the top
/// bar's Continue runs the sim, and the provider reads the appearances and
/// goals imperatively, so nothing else would notice the step.
void invalidatePlayerDetails(Ref ref) => ref.invalidate(_playerDetailProvider);
```

with

```dart
/// Drops every cached player detail, so a card on show re-reads its player.
/// The sim's cascade calls it after a step: on a tablet a [PlayerView] (a
/// pane beside the history, squad and ranking grids, or the player page)
/// stays on show while the top bar's Continue runs the sim. The detail reads
/// the appearances and goals imperatively, the club history moves each 1
/// December and the cabinet fills when a tournament ends, so nothing else
/// would notice the step.
void invalidatePlayerDetails(Ref ref) {
  ref
    ..invalidate(_playerDetailProvider)
    ..invalidate(clubHistoryProvider)
    ..invalidate(playerAwardsProvider);
}
```

- [ ] **Step 7: Invalidate the team records and the friendlies plan in the sim's cascade**

In `lib/features/hub/hub_providers.dart`:

Replace

```dart
import 'package:fnm/features/stats/stats_providers.dart'
    show careerStatsProvider, teamOverallHistoryProvider;
```

with

```dart
import 'package:fnm/features/stats/stats_providers.dart'
    show careerStatsProvider, teamOverallHistoryProvider, teamStatsProvider;
```

and add, sorted into the `features/` block:

```dart
import 'package:fnm/features/friendlies/friendlies_providers.dart'
    show friendliesPlanProvider;
```

(`friendlies_providers.dart` already imports this file; Dart allows the cycle, as it does for `player_detail_screen.dart`. Do not restructure.)

Make the last statement of `_invalidateCompetitionViews()` (after `_invalidateHistoryViews();`):

```dart
    _invalidateTeamViews();
```

and add this method directly below `_invalidateHistoryViews()`:

```dart
  /// The team records and the friendlies plan, refreshed by hand after a step
  /// for the same reason as [_invalidateCompetitionViews]. The team records
  /// read the goals, caps and ratings imperatively. The friendlies page keeps
  /// its plan alive while it is on show, and the hub's next event reads that
  /// same plan: left stale, a friendly gap the step has just opened would
  /// never be offered and the sim would run straight past it.
  void _invalidateTeamViews() {
    _ref
      ..invalidate(teamStatsProvider)
      ..invalidate(friendliesPlanProvider);
  }
```

- [ ] **Step 8: Run the tests, expect PASS**

Run: `flutter test test/widget/competition_refresh_after_step_test.dart test/golden/phone_guard_team_stats_test.dart test/golden/phone_guard_player_test.dart`
Expected: PASS, phone goldens unchanged. If the sanity line fails for one provider (a second read without a step already returns a new future), that provider is rebuilt by something else on each read; report it rather than weakening the test.

- [ ] **Step 9: Prove it bites**

Comment out the `_invalidateTeamViews();` call, run the refresh test, confirm both step tests FAIL naming `teamStats` and `friendlies` (and the source guard fails), restore it. Then restore `invalidatePlayerDetails` to its old one-liner, confirm both step tests FAIL naming `clubHistory` and `playerAwards`, restore the new body.

- [ ] **Step 10: Analyze, full suite, commit**

Run: `flutter analyze && flutter test` (final summary line: all passed).

```bash
git add lib/features/stats/stats_providers.dart lib/features/stats/team_stats_screen.dart lib/features/player/player_detail_screen.dart lib/features/hub/hub_providers.dart test/widget/competition_refresh_after_step_test.dart
git commit -m "fix(tablet): a sim step refreshes the team records, the friendlies plan and the player card

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 3: What a nation is before a career: strengths, the first briefs, `NationPreview`

**risk: high (per-task review)**. Shared code the nation pick, new game and out-of-work offers all render, and every number in it is a promise about a save that does not exist yet.

The approved mockup shows, per nation, a world rank, a strength meter, a squad overall, a budget, a star player and what the board expects. What exists before a career (measured on the seeded save):

- **World rank**: `nation.ranking`, the seed ranking every save starts on.
- **Squad overall**: `squadOverall` of `playerRepository.byNation(id)` with no save seed, the pool the world simulation draws every opponent from. A save's own pool also feels club minutes: on the seeded save every nation's own overall was within 2 of it. The seed rows (`playerRepository.all()`, what `starPlayersProvider` reads) are NOT that pool (167 of 209 nations differ), so they are not used.
- **Strength**: which fifth of the world that overall falls in.
- **Opening budget**: `FederationFinance.initialBudget(nation.ranking)`, exactly what `CareerService.create` stores.
- **The board's first briefs**: cycle 0 is never snapshotted, so its baseline is the seed ranking and the World Championship and continental targets are `worldObjectiveTarget(rank)` and `continentalObjectiveTarget(rank within the confederation)`, exactly what `cycleObjectiveOutcomesProvider` sets once the career exists.
- **Best player**: position, age and rating from the same seed-free pool. NOT his name: every save names its players afresh (all 209 best players carry another name in the seeded save).

**Files:**
- Modify: `lib/features/nations/nation_select_providers.dart`, `lib/features/hub/objective_providers.dart`
- Create: `lib/features/nations/nation_preview.dart`
- Test: `test/unit/nations/strength_tiers_test.dart` (new), `test/widget/nation_preview_test.dart` (new)

**Interfaces:**
- Produces (`nation_select_providers.dart`): `typedef NationStrength = ({int overall, int tier, Player best});`, `final FutureProvider<Map<int, NationStrength>> nationStrengthsProvider`, `Map<int, int> strengthTiers(Map<int, int> overalls)`.
- Produces (`objective_providers.dart`): `({int world, int? continental}) openingObjectiveTargets(Nation nation, List<Nation> nations)`.
- Produces (`nation_preview.dart`): `class StrengthMeter extends StatelessWidget { const StrengthMeter({required int tier, double barHeight = 10, Key? key}); final int tier; }`; `class NationPreview extends ConsumerWidget { const NationPreview({required Nation nation, String? caption, Key? key}); final Nation nation; static const Key factsKey, rankKey, strengthKey, overallKey, budgetKey, bestKey, briefKey; }` (a Column at its natural height; give it a scroll view). Tasks 4, 5 and 6 render it.
- Consumes: `nationsProvider`, `playerRepositoryProvider.byNation`, `squadOverall`, `FederationFinance.initialBudget`, `worldObjectiveTarget`, `continentalObjectiveTarget`, `_rankWithin` (private, same file), `objectiveDemandText`, `ContinentalCups.byConfederation`, `competitionLabel`, `confederationLabel`, `positionName`, `formatEuros`, `FlagDisc`, `TabletText`, Task 1's `nations*` strings.

- [ ] **Step 1: Write the failing tests**

Create `test/unit/nations/strength_tiers_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/nations/nation_select_providers.dart';

void main() {
  test('fifths of the field, strongest fifth five bars', () {
    final overalls = {for (var i = 0; i < 10; i++) i: 90 - i};
    expect(
      [for (var i = 0; i < 10; i++) strengthTiers(overalls)[i]],
      [5, 5, 4, 4, 3, 3, 2, 2, 1, 1],
    );
  });

  test('nations level on overall share the tier of the first of them', () {
    expect(strengthTiers({1: 80, 2: 80, 3: 70, 4: 60, 5: 50}), {
      1: 5,
      2: 5,
      3: 3,
      4: 2,
      5: 1,
    });
  });

  test('one nation is the strongest fifth; none is nothing', () {
    expect(strengthTiers({7: 61}), {7: 5});
    expect(strengthTiers(const {}), isEmpty);
  });
}
```

Create `test/widget/nation_preview_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/achievements/board_satisfaction.dart';
import 'package:fnm/domain/services/rating/overall_rating.dart';
import 'package:fnm/features/federation/investment_editor.dart';
import 'package:fnm/features/hub/objective_providers.dart';
import 'package:fnm/features/nations/nation_preview.dart';
import 'package:fnm/features/nations/nation_select_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/seeded_save.dart';

/// Reads an auto-disposed future while holding it, as a screen would.
Future<T> _hold<T>(ProviderContainer c, ProviderListenable<Future<T>> p) async {
  final sub = c.listen(p, (_, _) {});
  try {
    return await sub.read();
  } finally {
    sub.close();
  }
}

Future<void> _pumpPreview(
  WidgetTester tester,
  SeededSave save,
  Nation nation,
) async {
  tester.view.physicalSize = kTabletSize;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: save.container,
      child: MaterialApp(
        theme: AppTheme.theme,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(width: 340, child: NationPreview(nation: nation)),
          ),
        ),
      ),
    ),
  );
  await settle(tester);
}

Finder _in(Key key, String text) =>
    find.descendant(of: find.byKey(key), matching: find.text(text));

void main() {
  testWidgets("every fact is the save's own on its first day "
      '(Review Focus 1)', (tester) async {
    final save = await seedSave(tester);
    final c = save.container;
    final me = save.nations.firstWhere((n) => n.id == save.nationId);
    // What the career really holds, read BEFORE the preview is drawn.
    late int budget;
    late List<ObjectiveOutcome> outcomes;
    late int saveOverall;
    await tester.runAsync(() async {
      budget = (await c.read(careerRepositoryProvider).byId(save.careerId))!
          .budget;
      outcomes = await _hold(c, cycleObjectiveOutcomesProvider(save.careerId).future);
      saveOverall = squadOverall(
        await c
            .read(playerRepositoryProvider)
            .byNation(me.id, saveSeed: save.career.rngSeed),
      );
      await c.read(nationStrengthsProvider.future);
      await c.read(nationsProvider.future);
    });
    expect(budget, greaterThan(0), reason: 'the opening grant is stored');
    final world = outcomes.firstWhere((o) => o.tier == TournamentTier.world);
    final continental = outcomes.firstWhere(
      (o) => o.tier == TournamentTier.continental,
    );
    expect(openingObjectiveTargets(me, save.nations), (
      world: world.target,
      continental: continental.target,
    ));

    await _pumpPreview(tester, save, me);
    expect(tester.takeException(), isNull);
    expect(_in(NationPreview.budgetKey, formatEuros(budget)), findsOneWidget);
    expect(_in(NationPreview.rankKey, '#${me.ranking}'), findsOneWidget);
    // The seeded France is asked for different things at the two
    // tournaments, so each demand is on screen exactly once.
    expect(
      _in(
        NationPreview.briefKey,
        objectiveDemandText(enL, TournamentTier.world, world.target),
      ),
      findsOneWidget,
    );
    expect(
      _in(
        NationPreview.briefKey,
        objectiveDemandText(
          enL,
          TournamentTier.continental,
          continental.target,
          competition: continental.competition,
        ),
      ),
      findsOneWidget,
    );
    expect(_in(NationPreview.briefKey, enL.objectiveWorldCup), findsOneWidget);
    // The world's reading of the best eleven; the save's own pool also feels
    // club minutes, which move it by a point or two.
    final strength = c.read(nationStrengthsProvider).requireValue[me.id]!;
    expect((strength.overall - saveOverall).abs(), lessThanOrEqualTo(2));
    expect(
      _in(NationPreview.overallKey, '${strength.overall}'),
      findsOneWidget,
    );
    expect(
      _in(NationPreview.strengthKey, enL.nationsStrengthOf(strength.tier)),
      findsOneWidget,
    );
    // The best player by position, age and rating; never by a name the save
    // will not use.
    expect(
      _in(NationPreview.bestKey, '${strength.best.overall}'),
      findsOneWidget,
    );
    expect(
      _in(NationPreview.bestKey, enL.nationsStarAge(strength.best.age)),
      findsOneWidget,
    );
    expect(find.text(strength.best.name), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the strongest fifth wears five bars, the weakest one', (
    tester,
  ) async {
    final save = await seedSave(tester);
    late Map<int, NationStrength> all;
    await tester.runAsync(() async {
      all = await save.container.read(nationStrengthsProvider.future);
    });
    expect(all.length, save.nations.length, reason: 'every nation has players');
    final best = all.values.reduce((a, b) => a.overall >= b.overall ? a : b);
    final worst = all.values.reduce((a, b) => a.overall <= b.overall ? a : b);
    expect(best.tier, 5);
    expect(worst.tier, 1);
    for (var tier = 1; tier <= 5; tier++) {
      expect(
        all.values.where((s) => s.tier == tier),
        isNotEmpty,
        reason: 'no nation in tier $tier',
      );
    }
  });

  testWidgets('the meter lights as many bars as the tier', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: Center(child: StrengthMeter(tier: 3))),
      ),
    );
    expect(tester.getSize(find.byType(StrengthMeter)), const Size(28, 10));
    expect(find.bySemanticsLabel('Strength 3 of 5'), findsOneWidget);
  });
}
```

(The meter is five 4 px bars with 2 px between them: 28 x 10.)

- [ ] **Step 2: Run them to verify they fail**

Run: `flutter test test/unit/nations/strength_tiers_test.dart test/widget/nation_preview_test.dart`
Expected: FAIL to compile (`strengthTiers`, `nationStrengthsProvider`, `openingObjectiveTargets` and `nation_preview.dart` do not exist).

- [ ] **Step 3: The strengths**

In `lib/features/nations/nation_select_providers.dart` add the import `package:fnm/domain/services/rating/overall_rating.dart` and append:

```dart
/// A nation as it stands before any career exists.
///
/// [overall] is the mean of its best eleven as the world simulation rates
/// them: the seed-free pool every opponent is drawn from (a save's own pool
/// also feels club minutes, which move it by a point or two). [tier] is the
/// fifth of the world that puts it in, 5 the strongest fifth. [best] is its
/// highest-rated player; only his position, age and rating are shown, never
/// his name, because every save names its players afresh.
typedef NationStrength = ({int overall, int tier, Player best});

/// [NationStrength] of every nation with players, by nation id. The tablet's
/// nation pick, new game and out-of-work offers read it; the phone does not.
final FutureProvider<Map<int, NationStrength>> nationStrengthsProvider =
    FutureProvider<Map<int, NationStrength>>((ref) async {
      await ref.watch(seedLoaderProvider).ensureSeeded();
      final nations = await ref.watch(nationRepositoryProvider).all();
      final players = ref.watch(playerRepositoryProvider);
      final overall = <int, int>{};
      final best = <int, Player>{};
      for (final n in nations) {
        // Best first, and the same call the world simulation makes.
        final pool = await players.byNation(n.id);
        if (pool.isEmpty) continue;
        overall[n.id] = squadOverall(pool);
        best[n.id] = pool.first;
      }
      final tiers = strengthTiers(overall);
      return {
        for (final id in overall.keys)
          id: (overall: overall[id]!, tier: tiers[id]!, best: best[id]!),
      };
    });

/// Strength out of five for each nation in [overalls] (nation id to squad
/// overall): which fifth of the field it falls in, 5 for the strongest
/// fifth. Nations level on overall share the tier of the first of them, so
/// two equal sides never read as different strengths.
Map<int, int> strengthTiers(Map<int, int> overalls) {
  final sorted = overalls.values.toList()..sort((a, b) => b.compareTo(a));
  final firstAt = <int, int>{};
  for (var i = 0; i < sorted.length; i++) {
    firstAt.putIfAbsent(sorted[i], () => i);
  }
  return {
    for (final e in overalls.entries)
      e.key: 5 - firstAt[e.value]! * 5 ~/ sorted.length,
  };
}
```

- [ ] **Step 4: The first briefs**

In `lib/features/hub/objective_providers.dart`, directly below `continentalObjectiveTarget`, add:

```dart
/// The board's World Championship and continental demands of [nation] for a
/// save's FIRST cycle, known before the save exists.
///
/// The first cycle's baseline is the static seed ranking (cycle 0 is never
/// snapshotted; see `seedRankByIdProvider`), so these are exactly the targets
/// [cycleObjectiveOutcomesProvider] sets once the career starts. The tablet's
/// nation preview states them. [continental] is null for a confederation with
/// no continental championship.
({int world, int? continental}) openingObjectiveTargets(
  Nation nation,
  List<Nation> nations,
) {
  final baseline = {for (final n in nations) n.id: n.ranking};
  final hasCup = ContinentalCups.byConfederation.containsKey(
    nation.confederation,
  );
  return (
    world: worldObjectiveTarget(baseline[nation.id] ?? 50),
    continental: hasCup
        ? continentalObjectiveTarget(
            _rankWithin(baseline, nations, nation.confederation, nation.id),
          )
        : null,
  );
}
```

- [ ] **Step 5: The preview**

Create `lib/features/nations/nation_preview.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/competition_label.dart';
import 'package:fnm/core/util/squad_label.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/achievements/board_satisfaction.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/domain/services/federation/federation_finance.dart';
import 'package:fnm/features/federation/investment_editor.dart'
    show formatEuros;
import 'package:fnm/features/hub/objective_providers.dart';
import 'package:fnm/features/nations/nation_select_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet_text.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// Five bars, [tier] of them lit: a nation's strength out of five.
class StrengthMeter extends StatelessWidget {
  const StrengthMeter({required this.tier, this.barHeight = 10, super.key});

  final int tier;
  final double barHeight;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Semantics(
      label: '${l.nationsStrength} ${l.nationsStrengthOf(tier)}',
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 1; i <= 5; i++) ...[
              if (i > 1) const SizedBox(width: 2),
              Container(
                width: 4,
                height: barHeight,
                decoration: BoxDecoration(
                  color: i <= tier
                      ? AppColors.primary
                      : AppColors.outlineVariant,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Everything a manager can know about [nation] before taking it on, and
/// nothing he could not: its flag and confederation, its world rank, its
/// strength and squad overall, the budget a save opens with, its best player
/// (position, age and rating; never a name, see [NationStrength]) and what
/// the board will demand in the first cycle (see [openingObjectiveTargets]).
/// The tablet's nation pick, new game and out-of-work offers all show it.
///
/// A column at its natural height; give it a scroll view when it may not fit.
/// The strengths load once for the whole world; until they have, the facts
/// they feed are blank rather than a spinner.
class NationPreview extends ConsumerWidget {
  const NationPreview({required this.nation, this.caption, super.key});

  static const Key factsKey = Key('nationPreview.facts');
  static const Key rankKey = Key('nationPreview.rank');
  static const Key strengthKey = Key('nationPreview.strength');
  static const Key overallKey = Key('nationPreview.overall');
  static const Key budgetKey = Key('nationPreview.budget');
  static const Key bestKey = Key('nationPreview.best');
  static const Key briefKey = Key('nationPreview.brief');

  final Nation nation;

  /// A line under the confederation (the out-of-work offers' "141 of 209 in
  /// the world").
  final String? caption;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final nations = ref.watch(nationsProvider).valueOrNull ?? const <Nation>[];
    final strength = ref
        .watch(nationStrengthsProvider)
        .valueOrNull?[nation.id];
    final targets = nations.isEmpty
        ? null
        : openingObjectiveTargets(nation, nations);
    // Looked up by the nation's OWN confederation, never "the" continental cup.
    final cup = ContinentalCups.byConfederation[nation.confederation];
    final continental = targets?.continental;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            FlagDisc(nation.code, size: 76),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nation.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.headlineMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    confederationLabel(l, nation.confederation).toUpperCase(),
                    style: TabletText.sectionLabel,
                  ),
                  if (caption case final line?) ...[
                    const SizedBox(height: 2),
                    Text(
                      line,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        ClipRRect(
          key: factsKey,
          borderRadius: AppRadii.baseAll,
          child: ColoredBox(
            color: AppColors.surfaceContainerHigh,
            child: Padding(
              padding: const EdgeInsets.all(1),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _Fact(
                          key: rankKey,
                          label: l.hubWorldRankLabel,
                          value: '#${nation.ranking}',
                        ),
                      ),
                      const SizedBox(width: 1),
                      Expanded(
                        child: _Fact(
                          key: strengthKey,
                          label: l.nationsStrength,
                          value: strength == null
                              ? ''
                              : l.nationsStrengthOf(strength.tier),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 1),
                  Row(
                    children: [
                      Expanded(
                        child: _Fact(
                          key: overallKey,
                          label: l.nationsSquadOverall,
                          value: strength == null ? '' : '${strength.overall}',
                        ),
                      ),
                      const SizedBox(width: 1),
                      Expanded(
                        child: _Fact(
                          key: budgetKey,
                          label: l.nationsOpeningBudget,
                          value: formatEuros(
                            FederationFinance.initialBudget(nation.ranking),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        if (strength != null) ...[
          const SizedBox(height: AppSpacing.md),
          Text(l.nationsStarPlayer.toUpperCase(), style: TabletText.sectionLabel),
          const SizedBox(height: 6),
          _BestPlayer(key: bestKey, player: strength.best),
        ],
        if (targets != null) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            l.nationsBoardExpects.toUpperCase(),
            style: TabletText.sectionLabel,
          ),
          const SizedBox(height: 6),
          Column(
            key: briefKey,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Brief(
                competition: l.objectiveWorldCup,
                demand: objectiveDemandText(
                  l,
                  TournamentTier.world,
                  targets.world,
                ),
              ),
              if (cup != null && continental != null)
                _Brief(
                  competition: competitionLabel(l, cup.name),
                  demand: objectiveDemandText(
                    l,
                    TournamentTier.continental,
                    continental,
                    competition: cup.name,
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

/// One cell of the facts grid: a small label over a number.
class _Fact extends StatelessWidget {
  const _Fact({required this.label, required this.value, super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceContainer,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TabletText.sectionLabel,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.titleMedium.copyWith(
              fontFamily: AppFonts.mono,
            ),
          ),
        ],
      ),
    );
  }
}

/// The nation's best player: position, age and rating.
class _BestPlayer extends StatelessWidget {
  const _BestPlayer({required this.player, super.key});

  final Player player;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: AppRadii.baseAll,
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainerHighest,
              borderRadius: AppRadii.smAll,
            ),
            child: Text(
              player.position.label,
              style: TabletText.cellNumeric.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm + 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  positionName(l, player.position),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.titleMedium,
                ),
                Text(
                  l.nationsStarAge(player.age),
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.outline,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${player.overall}',
            style: AppTypography.headlineMedium.copyWith(
              fontFamily: AppFonts.mono,
              color: AppColors.medalGold,
            ),
          ),
        ],
      ),
    );
  }
}

/// One of the board's first demands: the competition over what it asks.
class _Brief extends StatelessWidget {
  const _Brief({required this.competition, required this.demand});

  final String competition;
  final String demand;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            competition,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          Text(demand, style: AppTypography.bodyMedium),
        ],
      ),
    );
  }
}
```

- [ ] **Step 6: Run the tests, expect PASS**

Run: `flutter test test/unit/nations/strength_tiers_test.dart test/widget/nation_preview_test.dart test/widget/nation_select_screen_test.dart`
Expected: PASS. If the budget, the briefs or the overall do not match the save, the preview is promising something the career does not hold: report it with the numbers, do not loosen the test.

- [ ] **Step 7: Analyze, full suite, commit**

Run: `flutter analyze && flutter test`

```bash
git add lib/features/nations/nation_select_providers.dart lib/features/hub/objective_providers.dart lib/features/nations/nation_preview.dart test/unit/nations/strength_tiers_test.dart test/widget/nation_preview_test.dart
git commit -m "feat(tablet): what a nation is before a career, as the save will see it

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 4: The nation pick as a grid of tiles beside the previewed nation

**risk: high (per-task review)**. The way into every career: navigation, the search and the confederation filter, Random team, From the bottom, and a preview that must never start a save on its own.

**Files:**
- Create: `lib/features/nations/nation_select_tablet_layout.dart` (part of `nation_select_screen.dart`)
- Modify: `lib/features/nations/nation_select_screen.dart`, `lib/features/shell/tablet_shell.dart`, `test/widget/home_tablet_test.dart`
- Test: `test/golden/phone_guard_nations_test.dart` (new, with goldens), `test/widget/nation_select_tablet_test.dart` (new)

**Interfaces:**
- Produces: `NationSelectScreen` becomes a `ConsumerStatefulWidget` (still `const NationSelectScreen({Key? key})`) with `static const Key tabletLayoutKey, backKey, gridKey, previewKey, manageKey`, `static Key tileKey(int nationId)`, `static Key chipKey(Confederation c)`; private `_NationSelectScreenState` (`int? _previewId`, `void _preview(int nationId)`), top-level private `_filterNations(List<Nation>, Confederation, String)` and `_startRandom(BuildContext, List<Nation>?)`, `_NationSelectTabletLayout`.
- Consumes: `nationsProvider`, `selectedConfederationProvider`, `nationSearchProvider` (the phone's), `nationStrengthsProvider`, `NationPreview`, `StrengthMeter` (Task 3), `useTabletLayout`, `PrimaryButton`, `FlagDisc`, `MasterDetailPlaceholder`, `TabletText`, Task 1's `nationsShownCount`, `nationsSortedByRank`, `nationsStarTile`, `nationsManage`, `nationsManagerNext`, and the existing `nationsNationalLevel`, `nationsSelectHeading`, `nationsSearchHint`, `nationsRandomTeam`, `nationsFromTheBottom`, `nationsNoMatch`, `nationsCouldNotLoadNations`.

- [ ] **Step 1: Pin the phone nation pick**

Create `test/golden/phone_guard_nations_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';

import '../helpers/seeded_save.dart';

/// The phone nation pick, pinned before the tablet layout is added beside
/// it: Europe's list (as tall as it goes), and a search across every
/// confederation.
void main() {
  for (final (name, size) in [
    ('nations_phone', kPhoneSize),
    ('nations_phone_tall', const Size(390, 2400)),
  ]) {
    testWidgets(name, (tester) async {
      final save = await seedSave(tester);
      await pumpRoute(tester, save, Routes.nations, size: size);
      expect(find.text(enL.nationsSelectHeading), findsOneWidget);
      await expectAppGolden('goldens/$name.png');
    });
  }

  testWidgets('nations_search_phone', (tester) async {
    EditableText.debugDeterministicCursor = true;
    addTearDown(() => EditableText.debugDeterministicCursor = false);
    final save = await seedSave(tester);
    await pumpRoute(tester, save, Routes.nations);
    await tester.enterText(find.byType(TextField), 'ger');
    await settle(tester);
    await expectAppGolden('goldens/nations_search_phone.png');
  });
}
```

- [ ] **Step 2: Create the baseline, confirm it holds, commit it**

```bash
flutter test --update-goldens test/golden/phone_guard_nations_test.dart
flutter test test/golden/phone_guard_nations_test.dart
git add test/golden/phone_guard_nations_test.dart test/golden/goldens/nations_phone.png test/golden/goldens/nations_phone_tall.png test/golden/goldens/nations_search_phone.png
git commit -m "test(tablet): phone guard for the nation pick

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

- [ ] **Step 3: Write the failing tablet test**

Create `test/widget/nation_select_tablet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/features/nations/nation_preview.dart';
import 'package:fnm/features/nations/nation_select_providers.dart';
import 'package:fnm/features/nations/nation_select_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';

import '../helpers/seeded_save.dart';

Future<SeededSave> _open(WidgetTester tester, Size size) async {
  final save = await seedSave(tester, formFactor: FormFactor.tablet);
  await pumpRoute(tester, save, Routes.nations, size: size);
  return save;
}

Uri _uri(SeededSave save) =>
    save.container.read(routerProvider).routeInformationProvider.value.uri;

/// Europe's nations in the order the tiles show them (world rank).
List<Nation> _europe(SeededSave save) =>
    save.nations.where((n) => n.confederation == Confederation.europe).toList()
      ..sort((a, b) => a.ranking.compareTo(b.ranking));

/// The nation the preview pane is showing.
int _previewed(WidgetTester tester) => tester
    .widget<NationPreview>(
      find.descendant(
        of: find.byKey(NationSelectScreen.previewKey),
        matching: find.byType(NationPreview),
      ),
    )
    .nation
    .id;

void main() {
  for (final size in kTabletSizes) {
    testWidgets('tiles left, the previewed nation right, $size', (
      tester,
    ) async {
      final save = await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(NationSelectScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(FullScreenPhoneFrame), findsNothing);
      final grid = tester.getRect(find.byKey(NationSelectScreen.gridKey));
      final pane = tester.getRect(find.byKey(NationSelectScreen.previewKey));
      expect(pane.left, greaterThanOrEqualTo(grid.right));
      // Europe by default, as on the phone; its best-ranked side is open
      // first and is the first tile.
      final europe = _europe(save);
      expect(_previewed(tester), europe.first.id);
      expect(find.byKey(NationSelectScreen.tileKey(europe.first.id)), findsOneWidget);
      expect(
        find.text(enL.nationsShownCount(europe.length).toUpperCase()),
        findsOneWidget,
      );
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('a tile shows the rank, the strength and the best player', (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    final first = _europe(save).first;
    final s = save.container.read(nationStrengthsProvider).requireValue[first.id]!;
    final tile = find.byKey(NationSelectScreen.tileKey(first.id));
    expect(
      find.descendant(of: tile, matching: find.text('#${first.ranking}')),
      findsOneWidget,
    );
    expect(
      tester
          .widget<StrengthMeter>(
            find.descendant(of: tile, matching: find.byType(StrengthMeter)),
          )
          .tier,
      s.tier,
    );
    expect(
      find.descendant(
        of: tile,
        matching: find.text(enL.nationsStarTile(s.best.position.label, s.best.overall)),
      ),
      findsOneWidget,
    );
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a tap only previews; Manage takes the job (Review Focus 2)', (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    final pick = _europe(save)[3];
    await tester.tap(find.byKey(NationSelectScreen.tileKey(pick.id)));
    await settle(tester);
    expect(_uri(save).path, Routes.nations);
    expect(_previewed(tester), pick.id);
    expect(find.text(enL.nationsManage(pick.name)), findsOneWidget);
    expect(find.text(enL.nationsManagerNext), findsOneWidget);
    await tester.tap(find.byKey(NationSelectScreen.manageKey));
    await settle(tester);
    expect(_uri(save).path, Routes.newGame);
    expect(_uri(save).queryParameters['nationId'], '${pick.id}');
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the confederations and the search filter as on the phone', (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    final africa = save.nations
        .where((n) => n.confederation == Confederation.africa)
        .toList();
    await tester.tap(find.byKey(NationSelectScreen.chipKey(Confederation.africa)));
    await settle(tester);
    expect(
      find.text(enL.nationsShownCount(africa.length).toUpperCase()),
      findsOneWidget,
    );
    // The pane follows the tiles: Africa's best-ranked side is open now.
    expect(africa.map((n) => n.id), contains(_previewed(tester)));
    // A search looks across every confederation, whatever chip is lit.
    await tester.enterText(
      find.descendant(
        of: find.byKey(NationSelectScreen.tabletLayoutKey),
        matching: find.byType(TextField),
      ),
      'ger',
    );
    await settle(tester);
    final matches = save.nations
        .where((n) => n.name.toLowerCase().contains('ger'))
        .toList();
    expect(matches.length, greaterThan(1), reason: 'the search spans continents');
    for (final n in matches) {
      expect(find.byKey(NationSelectScreen.tileKey(n.id)), findsOneWidget, reason: n.name);
    }
    expect(
      find.text(enL.nationsShownCount(matches.length).toUpperCase()),
      findsOneWidget,
    );
    await tester.enterText(
      find.descendant(
        of: find.byKey(NationSelectScreen.tabletLayoutKey),
        matching: find.byType(TextField),
      ),
      'zzzz',
    );
    await settle(tester);
    expect(find.text(enL.nationsNoMatch), findsWidgets);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('Random team and From the bottom go where the phone\'s do', (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    final router = save.container.read(routerProvider);
    await tester.tap(find.text(enL.nationsRandomTeam));
    await settle(tester);
    expect(_uri(save).path, Routes.newGame);
    final id = int.parse(_uri(save).queryParameters['nationId']!);
    expect(save.nations.map((n) => n.id), contains(id));
    router.go(Routes.nations);
    await settle(tester);
    await tester.tap(find.text(enL.nationsFromTheBottom));
    await settle(tester);
    expect(_uri(save).path, Routes.startFromBottom);
    router.go(Routes.nations);
    await settle(tester);
    await tester.tap(find.byKey(NationSelectScreen.backKey));
    await settle(tester);
    expect(_uri(save).path, Routes.home);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a resize keeps the preview and the search (Review Focus 3)', (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    final pick = _europe(save)[5];
    await tester.tap(find.byKey(NationSelectScreen.tileKey(pick.id)));
    await settle(tester);
    // Under 1000 wide: the phone list.
    tester.view.physicalSize = const Size(900, 810);
    await settle(tester);
    expect(find.byKey(NationSelectScreen.tabletLayoutKey), findsNothing);
    expect(find.text(enL.nationsSelect), findsWidgets);
    // Back over 1000: the same nation in the pane.
    tester.view.physicalSize = kTabletSize;
    await settle(tester);
    expect(_previewed(tester), pick.id);
    // The search survives a crossing too: the tablet field is seeded from it.
    final field = find.descendant(
      of: find.byKey(NationSelectScreen.tabletLayoutKey),
      matching: find.byType(TextField),
    );
    await tester.enterText(field, 'cze');
    await settle(tester);
    tester.view.physicalSize = const Size(900, 810);
    await settle(tester);
    tester.view.physicalSize = kTabletSize;
    await settle(tester);
    expect(
      tester
          .widget<TextField>(
            find.descendant(
              of: find.byKey(NationSelectScreen.tabletLayoutKey),
              matching: find.byType(TextField),
            ),
          )
          .controller!
          .text,
      'cze',
    );
    expect(save.container.read(nationSearchProvider), 'cze');
    await tester.pumpWidget(const SizedBox());
  });
}
```

In `test/widget/home_tablet_test.dart`, add the import `package:fnm/features/nations/nation_select_screen.dart` and, in 'no save to continue, $size', replace

```dart
      // New game still leads to the nation pick, which a tablet shows in
      // the phone frame.
      await tester.tap(find.widgetWithText(PrimaryButton, enL.homeNewGame));
      await settle(tester);
      expect(tester.takeException(), isNull);
      expect(_uri(save).path, Routes.nations);
      expect(find.byType(FullScreenPhoneFrame), findsOneWidget);
```

with

```dart
      // New game still leads to the nation pick, which stage 6 drew as a
      // landscape grid of tiles.
      await tester.tap(find.widgetWithText(PrimaryButton, enL.homeNewGame));
      await settle(tester);
      expect(tester.takeException(), isNull);
      expect(_uri(save).path, Routes.nations);
      expect(find.byKey(NationSelectScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(FullScreenPhoneFrame), findsNothing);
```

- [ ] **Step 4: Run them to verify they fail**

Run: `flutter test test/widget/nation_select_tablet_test.dart`
Expected: FAIL to compile (`NationSelectScreen.tabletLayoutKey` does not exist).

- [ ] **Step 5: The screen keeps the preview; both layouts share the filter and the random pick**

In `lib/features/nations/nation_select_screen.dart`:

Add the imports `package:fnm/core/layout/form_factor.dart`, `package:fnm/features/nations/nation_preview.dart` and `package:fnm/shared/tablet/tablet.dart` (sorted), and below the imports `part 'nation_select_tablet_layout.dart';`.

Replace the whole `NationSelectScreen` class (from `class NationSelectScreen extends ConsumerWidget {` to the closing `}` after `_startRandom`) with the following. The phone body is the old `build` verbatim, with its inline filter moved into `_filterNations` and `_startRandom` moved out of the class unchanged:

```dart
class NationSelectScreen extends ConsumerStatefulWidget {
  const NationSelectScreen({super.key});

  static const Key tabletLayoutKey = Key('nationSelect.tabletLayout');
  static const Key backKey = Key('nationSelect.back');
  static const Key gridKey = Key('nationSelect.grid');
  static const Key previewKey = Key('nationSelect.preview');
  static const Key manageKey = Key('nationSelect.manage');

  /// The tablet tile of the nation with [nationId].
  static Key tileKey(int nationId) => ValueKey(('nationTile', nationId));

  /// The tablet chip of [confederation].
  static Key chipKey(Confederation confederation) =>
      ValueKey(('confChip', confederation));

  @override
  ConsumerState<NationSelectScreen> createState() =>
      _NationSelectScreenState();
}

class _NationSelectScreenState extends ConsumerState<NationSelectScreen> {
  /// The nation previewed beside the tiles on a tablet. Held here, not in
  /// the tablet layout, so a window crossing 1000 px keeps it.
  int? _previewId;

  void _preview(int nationId) => setState(() => _previewId = nationId);

  @override
  Widget build(BuildContext context) {
    if (useTabletLayout(context, ref)) {
      return _NationSelectTabletLayout(state: this);
    }
    final nationsAsync = ref.watch(nationsProvider);
    final stars = ref.watch(starPlayersProvider).valueOrNull ?? const {};
    final selectedConf = ref.watch(selectedConfederationProvider);
    final query = ref.watch(nationSearchProvider).trim().toLowerCase();
    final l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () =>
              context.canPop() ? context.pop() : context.go(Routes.home),
        ),
        title: Text(
          l.nationsSelectTitle,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
      ),
      body: Column(
        children: [
          _Header(
            query: query,
            onSearch: (v) => ref.read(nationSearchProvider.notifier).state = v,
          ),
          // Two ways into a save that are not "scroll to the country you were
          // always going to pick": let the draw choose, or take whatever job an
          // out-of-work manager can get.
          _StartModes(
            onRandom: () => _startRandom(context, nationsAsync.valueOrNull),
            onBottom: () => context.go(Routes.startFromBottom),
          ),
          _ConfederationTabs(
            selected: selectedConf,
            onSelect: (c) =>
                ref.read(selectedConfederationProvider.notifier).state = c,
          ),
          Expanded(
            child: nationsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text(
                  l.nationsCouldNotLoadNations(e.toString()),
                  textAlign: TextAlign.center,
                ),
              ),
              data: (nations) {
                final filtered = _filterNations(nations, selectedConf, query);

                if (filtered.isEmpty) {
                  return Center(child: Text(l.nationsNoMatch));
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.marginMobile,
                    AppSpacing.sm,
                    AppSpacing.marginMobile,
                    AppSpacing.xl,
                  ),
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm + 4),
                  itemBuilder: (context, i) {
                    final nation = filtered[i];
                    return _NationCard(
                      nation: nation,
                      star: stars[nation.id],
                      onSelect: () => context.go(
                        '${Routes.newGame}?nationId=${nation.id}',
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// The nations on show: with a search [query], every confederation's matches
/// (so a nation is findable from any tab); otherwise the [selected]
/// confederation's. Both layouts filter through here.
List<Nation> _filterNations(
  List<Nation> nations,
  Confederation selected,
  String query,
) => nations
    .where(
      (n) => query.isEmpty
          ? n.confederation == selected
          : n.name.toLowerCase().contains(query),
    )
    .toList();

/// Picks a nation at random from everything this player may manage and goes
/// straight to naming the manager.
void _startRandom(BuildContext context, List<Nation>? nations) {
  final pool = nations ?? const <Nation>[];
  if (pool.isEmpty) return;
  final pick = pool[Random().nextInt(pool.length)];
  context.go('${Routes.newGame}?nationId=${pick.id}');
}
```

Keep the class doc comment above `class NationSelectScreen` as it is. Nothing below the old class (`_Header`, `_ConfederationTabs`, `_StartModes`, `_ModeButton`, `_NationCard`, `_SelectButton`) changes.

- [ ] **Step 6: The layout**

Create `lib/features/nations/nation_select_tablet_layout.dart`:

```dart
part of 'nation_select_screen.dart';

/// The nation pick on a landscape tablet: a bar with the way back, the title,
/// the search and the two other ways in; the confederations as chips with
/// their counts; every nation as a tile (rank, strength, flag, name, best
/// player); and the previewed nation beside them. A tap only previews; Manage
/// takes the job. The search, the confederation, Random team and From the
/// bottom are the phone's own (the same providers and functions), and the
/// preview is the screen State's, so a resize keeps it.
class _NationSelectTabletLayout extends ConsumerStatefulWidget {
  const _NationSelectTabletLayout({required this.state});

  final _NationSelectScreenState state;

  @override
  ConsumerState<_NationSelectTabletLayout> createState() =>
      _NationSelectTabletLayoutState();
}

class _NationSelectTabletLayoutState
    extends ConsumerState<_NationSelectTabletLayout> {
  late final TextEditingController _search;

  @override
  void initState() {
    super.initState();
    // Seeded from the query, so a window crossing 1000 px keeps what was
    // typed on either side of it.
    _search = TextEditingController(text: ref.read(nationSearchProvider));
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final nationsAsync = ref.watch(nationsProvider);
    final strengths =
        ref.watch(nationStrengthsProvider).valueOrNull ??
        const <int, NationStrength>{};
    final selectedConf = ref.watch(selectedConfederationProvider);
    final query = ref.watch(nationSearchProvider).trim().toLowerCase();
    return Scaffold(
      key: NationSelectScreen.tabletLayoutKey,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TabletTopBar(
              search: _search,
              onSearch: (v) =>
                  ref.read(nationSearchProvider.notifier).state = v,
              onRandom: () => _startRandom(context, nationsAsync.valueOrNull),
              onBottom: () => context.go(Routes.startFromBottom),
            ),
            Expanded(
              child: nationsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Text(
                    l.nationsCouldNotLoadNations(e.toString()),
                    textAlign: TextAlign.center,
                  ),
                ),
                data: (nations) {
                  final shown = _filterNations(nations, selectedConf, query);
                  // The pick while it is on show, else the first tile: the
                  // pane is never empty while there are tiles.
                  final previewed =
                      shown
                          .where((n) => n.id == widget.state._previewId)
                          .firstOrNull ??
                      shown.firstOrNull;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _ConfederationChips(
                              nations: nations,
                              selected: selectedConf,
                              onSelect: (c) =>
                                  ref
                                          .read(
                                            selectedConfederationProvider
                                                .notifier,
                                          )
                                          .state =
                                      c,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                AppSpacing.lg,
                                0,
                                AppSpacing.lg,
                                AppSpacing.sm,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    l
                                        .nationsShownCount(shown.length)
                                        .toUpperCase(),
                                    style: TabletText.sectionLabel,
                                  ),
                                  const Spacer(),
                                  Text(
                                    l.nationsSortedByRank.toUpperCase(),
                                    style: TabletText.sectionLabel,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: shown.isEmpty
                                  ? Center(child: Text(l.nationsNoMatch))
                                  : GridView.builder(
                                      key: NationSelectScreen.gridKey,
                                      padding: const EdgeInsets.fromLTRB(
                                        AppSpacing.lg,
                                        AppSpacing.xs,
                                        AppSpacing.lg,
                                        AppSpacing.lg,
                                      ),
                                      gridDelegate:
                                          const SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent: 180,
                                            mainAxisExtent: 172,
                                            crossAxisSpacing: 12,
                                            mainAxisSpacing: 12,
                                          ),
                                      itemCount: shown.length,
                                      itemBuilder: (context, i) {
                                        final n = shown[i];
                                        return _NationTile(
                                          key: NationSelectScreen.tileKey(n.id),
                                          nation: n,
                                          strength: strengths[n.id],
                                          selected: n.id == previewed?.id,
                                          onTap: () =>
                                              widget.state._preview(n.id),
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),
                      const VerticalDivider(
                        width: 1,
                        thickness: 1,
                        color: AppColors.outlineVariant,
                      ),
                      SizedBox(
                        width: 340,
                        child: Material(
                          color: AppColors.surfaceContainerLow,
                          child: previewed == null
                              ? MasterDetailPlaceholder(text: l.nationsNoMatch)
                              : _PreviewPane(nation: previewed),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The bar across the top: back, the title, the search and the two other
/// ways into a career.
class _TabletTopBar extends StatelessWidget {
  const _TabletTopBar({
    required this.search,
    required this.onSearch,
    required this.onRandom,
    required this.onBottom,
  });

  final TextEditingController search;
  final ValueChanged<String> onSearch;
  final VoidCallback onRandom;
  final VoidCallback onBottom;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLow,
        border: Border(bottom: BorderSide(color: AppColors.outlineVariant)),
      ),
      child: Row(
        children: [
          IconButton(
            key: NationSelectScreen.backKey,
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: () =>
                context.canPop() ? context.pop() : context.go(Routes.home),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.nationsNationalLevel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TabletText.sectionLabel.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  l.nationsSelectHeading,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TabletText.screenTitle.copyWith(fontSize: 19),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 260,
            child: TextField(
              controller: search,
              onChanged: onSearch,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.onSurface,
              ),
              decoration: InputDecoration(
                isDense: true,
                hintText: l.nationsSearchHint,
                prefixIcon: const Icon(
                  Icons.search,
                  size: 18,
                  color: AppColors.outline,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          _BarModeButton(
            icon: Icons.casino_outlined,
            label: l.nationsRandomTeam,
            onTap: onRandom,
          ),
          const SizedBox(width: AppSpacing.sm),
          _BarModeButton(
            icon: Icons.trending_down_rounded,
            label: l.nationsFromTheBottom,
            onTap: onBottom,
          ),
        ],
      ),
    );
  }
}

/// The phone's [_ModeButton] at its own width, for a row it shares.
class _BarModeButton extends StatelessWidget {
  const _BarModeButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    onPressed: onTap,
    icon: Icon(icon, size: 16),
    label: Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTypography.labelSmall,
    ),
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary,
      side: const BorderSide(color: AppColors.outlineVariant),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      minimumSize: const Size(0, 40),
    ),
  );
}

/// The confederations as chips, each with how many nations it holds.
class _ConfederationChips extends StatelessWidget {
  const _ConfederationChips({
    required this.nations,
    required this.selected,
    required this.onSelect,
  });

  final List<Nation> nations;
  final Confederation selected;
  final ValueChanged<Confederation> onSelect;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final counts = {for (final c in Confederation.values) c: 0};
    for (final n in nations) {
      counts[n.confederation] = counts[n.confederation]! + 1;
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [
          for (final c in Confederation.values)
            _ConfederationChip(
              key: NationSelectScreen.chipKey(c),
              label: confederationLabel(l, c).toUpperCase(),
              count: counts[c]!,
              active: c == selected,
              onTap: () => onSelect(c),
            ),
        ],
      ),
    );
  }
}

class _ConfederationChip extends StatelessWidget {
  const _ConfederationChip({
    required this.label,
    required this.count,
    required this.active,
    required this.onTap,
    super.key,
  });

  final String label;
  final int count;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: active,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.xlAll,
        child: Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: active
                ? AppColors.secondaryContainer
                : AppColors.surfaceContainer,
            borderRadius: AppRadii.xlAll,
            border: Border.all(
              color: active ? AppColors.primary : AppColors.outlineVariant,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  color: active
                      ? AppColors.onSecondaryContainer
                      : AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '$count',
                style: TabletText.cellNumeric.copyWith(
                  fontSize: 10,
                  color: AppColors.outline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One nation as a tile: the world rank top left, the strength top right,
/// the flag, the name, and the best player's position and rating.
class _NationTile extends StatelessWidget {
  const _NationTile({
    required this.nation,
    required this.strength,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final Nation nation;
  final NationStrength? strength;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final s = strength;
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.mdAll,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: AppRadii.mdAll,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: selected
                    ? const [
                        AppColors.surfaceContainerHighest,
                        AppColors.surfaceContainerHigh,
                      ]
                    : const [
                        AppColors.surfaceContainerHigh,
                        AppColors.surfaceContainerLow,
                      ],
              ),
              border: Border.all(
                color: selected
                    ? AppColors.primary
                    : AppColors.surfaceContainerHighest,
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 8,
                  left: 9,
                  child: Text(
                    '#${nation.ranking}',
                    style: TabletText.cellNumeric.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                if (s != null)
                  Positioned(
                    top: 10,
                    right: 9,
                    child: StrengthMeter(tier: s.tier),
                  ),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 26, 10, 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FlagDisc(nation.code, size: 56, highlighted: selected),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          nation.name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.titleMedium.copyWith(
                            fontSize: 14,
                            height: 1.2,
                          ),
                        ),
                        if (s != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            l.nationsStarTile(
                              s.best.position.label,
                              s.best.overall,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.outline,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The previewed nation and the one button that takes its job.
class _PreviewPane extends StatelessWidget {
  const _PreviewPane({required this.nation});

  final Nation nation;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      key: NationSelectScreen.previewKey,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              // A new nation is a new preview: no scroll offset carried over.
              key: ValueKey(('preview', nation.id)),
              child: NationPreview(nation: nation),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          PrimaryButton(
            key: NationSelectScreen.manageKey,
            label: l.nationsManage(nation.name),
            icon: Icons.play_arrow_rounded,
            onPressed: () =>
                context.go('${Routes.newGame}?nationId=${nation.id}'),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l.nationsManagerNext,
            textAlign: TextAlign.center,
            style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 7: Register, run, expect PASS**

Add `Routes.nations,` to `tabletReadyPaths` in `lib/features/shell/tablet_shell.dart`.

Run: `flutter test test/widget/nation_select_tablet_test.dart test/golden/phone_guard_nations_test.dart test/widget/nation_select_screen_test.dart test/widget/home_tablet_test.dart test/widget/tablet_full_screen_sweep_test.dart`
Expected: PASS, phone goldens unchanged.

- [ ] **Step 8: Analyze, full suite, commit**

Run: `flutter analyze && flutter test`

```bash
git add lib/features/nations/nation_select_screen.dart lib/features/nations/nation_select_tablet_layout.dart lib/features/shell/tablet_shell.dart test/widget/nation_select_tablet_test.dart test/widget/home_tablet_test.dart
git commit -m "feat(tablet): the nation pick as tiles beside the previewed nation

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 5: Naming the manager beside the nation he is taking on

**risk: high (per-task review)**. Creates the save: the one write that starts a career, then navigates into it.

**Files:**
- Create: `lib/features/career/new_game_tablet_layout.dart` (part of `new_game_screen.dart`)
- Modify: `lib/features/career/new_game_screen.dart`, `lib/features/shell/tablet_shell.dart`
- Test: `test/golden/phone_guard_new_game_test.dart` (new, with golden), `test/widget/new_game_tablet_test.dart` (new)

**Interfaces:**
- Produces: `NewGameScreen.tabletLayoutKey`, `NewGameScreen.startKey`; private `_FreeCycleNote` (the phone's note, moved), `_NewGameTabletLayout`.
- Changes: `_NewGameScreenState._start` takes the router before its await and goes to the new save's hub only if the manager is still on `/new-game`.
- Consumes: `nationByIdProvider`, `careerServiceProvider.create` (through `_start`), `NationPreview` (Task 3), `AppTextField`, `PrimaryButton`, `PanelBox`, `TabletScreenHeader`, `useTabletLayout`, `stopPlayClock`, `rivalNation` (`history_fixtures.dart`), `l.careerNewGame`, `l.careerManagerName`, `l.careerManagerNameHint`, `l.careerBeginsBlurb`, `l.careerFreeCycleNote`, `l.careerStartCareer`.

- [ ] **Step 1: Pin the phone new game**

Create `test/golden/phone_guard_new_game_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';

import '../helpers/seeded_save.dart';

/// The phone new game, pinned before the tablet layout is added beside it.
/// The name field takes focus on its own, so the cursor is held still.
void main() {
  testWidgets('new_game_phone', (tester) async {
    EditableText.debugDeterministicCursor = true;
    addTearDown(() => EditableText.debugDeterministicCursor = false);
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.newGame}?nationId=${save.nationId}',
    );
    expect(find.text(enL.careerStartCareer), findsOneWidget);
    await expectAppGolden('goldens/new_game_phone.png');
  });
}
```

- [ ] **Step 2: Create the baseline, confirm it holds, commit it**

```bash
flutter test --update-goldens test/golden/phone_guard_new_game_test.dart
flutter test test/golden/phone_guard_new_game_test.dart
git add test/golden/phone_guard_new_game_test.dart test/golden/goldens/new_game_phone.png
git commit -m "test(tablet): phone guard for the new game

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

- [ ] **Step 3: Write the failing tablet test**

Create `test/widget/new_game_tablet_test.dart`:

```dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/result/result.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/career/new_game_screen.dart';
import 'package:fnm/features/nations/nation_preview.dart';
import 'package:fnm/features/shell/tablet_shell.dart';

import '../helpers/history_fixtures.dart';
import '../helpers/seeded_save.dart';

/// Creating a save, held at a gate until the test lets it through, so the
/// manager can leave the page while it is being made.
class _GatedCareers extends CareerService {
  _GatedCareers(super.ref);

  final Completer<void> gate = Completer<void>();

  @override
  Future<Result<Career>> create({
    required int nationId,
    required String managerName,
    int? rngSeed,
  }) async {
    await gate.future;
    return super.create(
      nationId: nationId,
      managerName: managerName,
      rngSeed: rngSeed,
    );
  }
}

Future<SeededSave> _open(
  WidgetTester tester,
  Size size, {
  bool gated = false,
}) async {
  final save = await seedSave(
    tester,
    formFactor: FormFactor.tablet,
    overrides: [
      if (gated) careerServiceProvider.overrideWith(_GatedCareers.new),
    ],
  );
  await pumpRoute(
    tester,
    save,
    '${Routes.newGame}?nationId=${rivalNation.id}',
    size: size,
  );
  return save;
}

Uri _uri(SeededSave save) =>
    save.container.read(routerProvider).routeInformationProvider.value.uri;

Future<List<Career>> _careers(WidgetTester tester, SeededSave save) async {
  late List<Career> all;
  await tester.runAsync(() async {
    all = await save.container.read(careerRepositoryProvider).all();
  });
  return all;
}

Finder get _nameField => find.descendant(
  of: find.byKey(NewGameScreen.tabletLayoutKey),
  matching: find.byType(TextField),
);

void main() {
  setUp(() => EditableText.debugDeterministicCursor = true);
  tearDown(() => EditableText.debugDeterministicCursor = false);

  for (final size in kTabletSizes) {
    testWidgets('the nation left, the name and Start right, $size', (
      tester,
    ) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(NewGameScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(FullScreenPhoneFrame), findsNothing);
      final preview = tester.getRect(find.byType(NationPreview));
      expect(tester.getRect(_nameField).left, greaterThan(preview.right));
      expect(
        tester.widget<NationPreview>(find.byType(NationPreview)).nation.id,
        rivalNation.id,
      );
      expect(find.byKey(NewGameScreen.startKey), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('Start career makes the save and opens its hub', (tester) async {
    final save = await _open(tester, kTabletSize);
    expect([for (final c in await _careers(tester, save)) c.id], [
      save.careerId,
    ]);
    await tester.enterText(_nameField, 'Zola');
    await tester.tap(find.byKey(NewGameScreen.startKey));
    await settle(tester);
    final after = await _careers(tester, save);
    expect(after, hasLength(2));
    final made = after.firstWhere((c) => c.id != save.careerId);
    expect(made.managerName, 'Zola');
    expect(made.nationId, rivalNation.id);
    expect(_uri(save).path, Routes.hub);
    expect(_uri(save).queryParameters['careerId'], '${made.id}');
    // create() invalidated the saves list; re-read it before teardown.
    await stopPlayClock(tester, save);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a resize keeps the half-typed name (Review Focus 3)', (
    tester,
  ) async {
    await _open(tester, kTabletSize);
    await tester.enterText(_nameField, 'Zola');
    await settle(tester);
    tester.view.physicalSize = const Size(900, 810);
    await settle(tester);
    expect(find.byKey(NewGameScreen.tabletLayoutKey), findsNothing);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      'Zola',
    );
    tester.view.physicalSize = kTabletSize;
    await settle(tester);
    expect(tester.widget<TextField>(_nameField).controller!.text, 'Zola');
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a manager who leaves while the save is made stays where he '
      'went (Review Focus 4)', (tester) async {
    final save = await _open(tester, kTabletSize, gated: true);
    final careers = save.container.read(careerServiceProvider) as _GatedCareers;
    await tester.enterText(_nameField, 'Zola');
    await tester.tap(find.byKey(NewGameScreen.startKey));
    await tester.pump();
    // The save is being made (the button spins). Settings pushed over the
    // page: the new game is still mounted under it. Not `settle` while the
    // gate is shut: the button's spinner is on purpose until it opens.
    unawaited(save.container.read(routerProvider).push(Routes.settings));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(_uri(save).path, Routes.settings);
    careers.gate.complete();
    await settle(tester);
    expect(_uri(save).path, Routes.settings);
    expect(await _careers(tester, save), hasLength(2), reason: 'still made');
    await stopPlayClock(tester, save);
    await tester.pumpWidget(const SizedBox());
  });
}
```

- [ ] **Step 4: Run it to verify it fails**

Run: `flutter test test/widget/new_game_tablet_test.dart`
Expected: FAIL to compile (`NewGameScreen.tabletLayoutKey` does not exist).

- [ ] **Step 5: The write waits for nobody; hook in the layout**

In `lib/features/career/new_game_screen.dart`:

Add the imports `package:fnm/core/layout/form_factor.dart`, `package:fnm/domain/entities/nation.dart`, `package:fnm/features/nations/nation_preview.dart` and `package:fnm/shared/tablet/tablet.dart` (sorted), and below the imports `part 'new_game_tablet_layout.dart';`.

In `NewGameScreen` add:

```dart
  static const Key tabletLayoutKey = Key('newGame.tabletLayout');
  static const Key startKey = Key('newGame.start');
```

Replace `_start` with:

```dart
  Future<void> _start() async {
    setState(() => _creating = true);
    // Taken before the await: a resize across 1000 px rebuilds this page in
    // the other layout meanwhile, and a manager who has gone elsewhere (a
    // pushed Settings, the back arrow) is left there rather than pulled into
    // the new save. `router.state` is the top-most route, pushed ones too.
    final router = GoRouter.of(context);
    final result = await ref
        .read(careerServiceProvider)
        .create(
          nationId: widget.nationId,
          managerName: _controller.text,
        );
    if (!mounted) return;
    setState(() => _creating = false);
    final l = AppLocalizations.of(context);

    result.fold(
      (career) {
        if (router.state.uri.path == Routes.newGame) {
          router.go('${Routes.hub}?careerId=${career.id}');
        }
      },
      (failure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(failure.message),
              action: SnackBarAction(
                label: l.careerManageSaves,
                onPressed: () => context.go(Routes.saves),
              ),
            ),
          );
      },
    );
  }
```

In `build`, directly after `final nationAsync = ref.watch(nationByIdProvider(widget.nationId));`, add:

```dart
    if (useTabletLayout(context, ref)) {
      return _NewGameTabletLayout(state: this, nationAsync: nationAsync);
    }
```

In the phone tree replace the whole free-cycle `Row(...)` (the one under the comment "What the manager is about to get for nothing, ...", from `Row(` to its closing `),`) with:

```dart
                          const _FreeCycleNote(),
```

keeping the comment above it, and add at the end of the file:

```dart
/// What the manager is getting for nothing, and what the one payment is for:
/// the phone's note under the name, shared with the tablet's form.
class _FreeCycleNote extends StatelessWidget {
  const _FreeCycleNote();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 1),
          child: Icon(
            Icons.info_outline_rounded,
            size: 13,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            l.careerFreeCycleNote,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
```

(The Row moved verbatim; inside a `StatelessWidget` it reads `l` itself. It sits in an `IntrinsicHeight` on the phone exactly as before.)

- [ ] **Step 6: The layout**

Create `lib/features/career/new_game_tablet_layout.dart`:

```dart
part of 'new_game_screen.dart';

/// Naming the manager on a landscape tablet: the nation he is taking on (the
/// nation pick's preview: rank, strength, budget, best player, the board's
/// first demands) on the left; the name, what the career is and Start career
/// on the right. The field, the button and the write are the screen State's
/// ([_NewGameScreenState._controller], [_NewGameScreenState._start]), so a
/// resize keeps a half-typed name and a save being made.
class _NewGameTabletLayout extends StatelessWidget {
  const _NewGameTabletLayout({required this.state, required this.nationAsync});

  final _NewGameScreenState state;
  final AsyncValue<Nation?> nationAsync;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      key: NewGameScreen.tabletLayoutKey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TabletScreenHeader(
                title: l.careerNewGame,
                onBack: () => context.go(Routes.nations),
              ),
              Expanded(
                child: nationAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) =>
                      Center(child: Text(l.careerCouldNotLoadNation('$e'))),
                  data: (nation) {
                    if (nation == null) {
                      return Center(child: Text(l.careerNationNotFound));
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 5,
                          child: PanelBox(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(20),
                              child: NationPreview(nation: nation),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          flex: 6,
                          // Scrolls, so the keyboard never pushes the
                          // button off the bottom.
                          child: ListView(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                              vertical: AppSpacing.md,
                            ),
                            children: [
                              AppTextField(
                                label: l.careerManagerName,
                                hint: l.careerManagerNameHint,
                                controller: state._controller,
                                autofocus: true,
                                textInputAction: TextInputAction.done,
                                onSubmitted: (_) => state._start(),
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                l.careerBeginsBlurb,
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              const _FreeCycleNote(),
                              const SizedBox(height: AppSpacing.lg),
                              PrimaryButton(
                                key: NewGameScreen.startKey,
                                label: l.careerStartCareer,
                                icon: Icons.play_arrow_rounded,
                                isLoading: state._creating,
                                onPressed: state._creating
                                    ? null
                                    : state._start,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 7: Register, run, expect PASS**

Add `Routes.newGame,` to `tabletReadyPaths` in `lib/features/shell/tablet_shell.dart`.

Run: `flutter test test/widget/new_game_tablet_test.dart test/golden/phone_guard_new_game_test.dart test/widget/tablet_full_screen_sweep_test.dart test/widget/nation_select_tablet_test.dart`
Expected: PASS, phone golden unchanged.

- [ ] **Step 8: Analyze, full suite, commit**

Run: `flutter analyze && flutter test`

```bash
git add lib/features/career/new_game_screen.dart lib/features/career/new_game_tablet_layout.dart lib/features/shell/tablet_shell.dart test/widget/new_game_tablet_test.dart
git commit -m "feat(tablet): naming the manager beside the nation he is taking on

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 6: Out of work: the three offers side by side

**risk: high (per-task review)**. A way into a career: the three jobs on the table are drawn at random once per visit and must not reshuffle under the manager.

The phone draws its offers from `DateTime.now()`, so its golden would differ on every run. A test-only seed comes first (`UnemployedStartScreen.debugSeed`, null in the app, which draws exactly as before), committed together with the guard it exists for.

**Files:**
- Create: `lib/features/career/unemployed_start_tablet_layout.dart` (part of `unemployed_start_screen.dart`)
- Modify: `lib/features/career/unemployed_start_screen.dart`, `lib/features/shell/tablet_shell.dart`
- Test: `test/golden/phone_guard_unemployed_test.dart` (new, with golden), `test/widget/unemployed_start_tablet_test.dart` (new)

**Interfaces:**
- Produces: `@visibleForTesting static int? UnemployedStartScreen.debugSeed`; `UnemployedStartScreen.tabletLayoutKey`; `static Key UnemployedStartScreen.takeKey(int nationId)`; private `_UnemployedStartTabletLayout`, `_OfferPanel`.
- Consumes: `nationsProvider`, `_UnemployedStartScreenState._offers` (the phone's draw), `NationPreview` (Task 3, with `caption`), `PanelBox`, `PrimaryButton`, `TabletScreenHeader`, `useTabletLayout`, `l.bottomStartTitle`, `l.bottomStartHeading`, `l.bottomStartBlurb`, `l.bottomStartAccept`, `l.bottomStartRankOf`.

- [ ] **Step 1: The seed, and the phone pinned with it**

In `lib/features/career/unemployed_start_screen.dart`, in `UnemployedStartScreen` add:

```dart
  /// Pins the offers' draw in tests (the phone guard draws the same three
  /// every run). Null in the app: a new draw on every visit, as always.
  @visibleForTesting
  static int? debugSeed;
```

and in `_UnemployedStartScreenState` replace

```dart
  final int _seed = DateTime.now().microsecondsSinceEpoch & 0x7FFFFFFF;
```

with

```dart
  final int _seed =
      UnemployedStartScreen.debugSeed ??
      (DateTime.now().microsecondsSinceEpoch & 0x7FFFFFFF);
```

Nothing else changes. Create `test/golden/phone_guard_unemployed_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/career/unemployed_start_screen.dart';

import '../helpers/seeded_save.dart';

/// The phone out-of-work offers, pinned before the tablet layout is added
/// beside them. The draw is seeded, so the same three come every run.
void main() {
  testWidgets('unemployed_phone', (tester) async {
    UnemployedStartScreen.debugSeed = 7;
    addTearDown(() => UnemployedStartScreen.debugSeed = null);
    final save = await seedSave(tester);
    await pumpRoute(tester, save, Routes.startFromBottom);
    expect(find.text(enL.bottomStartHeading), findsOneWidget);
    await expectAppGolden('goldens/unemployed_phone.png');
  });
}
```

- [ ] **Step 2: Create the baseline, confirm it holds twice, commit it**

```bash
flutter test --update-goldens test/golden/phone_guard_unemployed_test.dart
flutter test test/golden/phone_guard_unemployed_test.dart
flutter test test/golden/phone_guard_unemployed_test.dart
git add lib/features/career/unemployed_start_screen.dart test/golden/phone_guard_unemployed_test.dart test/golden/goldens/unemployed_phone.png
git commit -m "test(tablet): phone guard for the out-of-work offers, with a seeded draw

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

(Run twice: a second pass proves the draw is pinned.)

- [ ] **Step 3: Write the failing tablet test**

Create `test/widget/unemployed_start_tablet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/career/unemployed_start_screen.dart';
import 'package:fnm/features/nations/nation_preview.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/seeded_save.dart';

Future<SeededSave> _open(WidgetTester tester, Size size) async {
  final save = await seedSave(tester, formFactor: FormFactor.tablet);
  await pumpRoute(tester, save, Routes.startFromBottom, size: size);
  return save;
}

Uri _uri(SeededSave save) =>
    save.container.read(routerProvider).routeInformationProvider.value.uri;

/// The offers on show, left to right.
List<int> _offers(WidgetTester tester) => [
  for (final p in tester.widgetList<NationPreview>(find.byType(NationPreview)))
    p.nation.id,
];

void main() {
  for (final size in kTabletSizes) {
    testWidgets('three offers side by side, $size', (tester) async {
      final save = await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(
        find.byKey(UnemployedStartScreen.tabletLayoutKey),
        findsOneWidget,
      );
      expect(find.byType(FullScreenPhoneFrame), findsNothing);
      final ids = _offers(tester);
      expect(ids, hasLength(3));
      final rects = [
        for (final id in ids)
          tester.getRect(find.byKey(UnemployedStartScreen.takeKey(id))),
      ];
      expect(rects[1].left, greaterThan(rects[0].right));
      expect(rects[2].left, greaterThan(rects[1].right));
      // From the bottom half of the world, as on the phone.
      for (final id in ids) {
        final n = save.nations.firstWhere((x) => x.id == id);
        expect(n.ranking, greaterThan(save.nations.length ~/ 2), reason: n.name);
      }
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('Take it goes on to naming the manager', (tester) async {
    final save = await _open(tester, kTabletSize);
    final id = _offers(tester)[1];
    await tester.tap(find.byKey(UnemployedStartScreen.takeKey(id)));
    await settle(tester);
    expect(_uri(save).path, Routes.newGame);
    expect(_uri(save).queryParameters['nationId'], '$id');
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a resize shows the same three offers (Review Focus 3)', (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    final before = _offers(tester);
    tester.view.physicalSize = const Size(900, 810);
    await settle(tester);
    expect(find.byKey(UnemployedStartScreen.tabletLayoutKey), findsNothing);
    for (final id in before) {
      final n = save.nations.firstWhere((x) => x.id == id);
      expect(find.text(n.name), findsOneWidget, reason: n.name);
    }
    tester.view.physicalSize = kTabletSize;
    await settle(tester);
    expect(_offers(tester), before);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the back arrow returns to the nation pick', (tester) async {
    final save = await _open(tester, kTabletSize);
    await tester.tap(find.byKey(TabletScreenHeader.backKey));
    await settle(tester);
    expect(_uri(save).path, Routes.nations);
    await tester.pumpWidget(const SizedBox());
  });
}
```

- [ ] **Step 4: Run it to verify it fails**

Run: `flutter test test/widget/unemployed_start_tablet_test.dart`
Expected: FAIL to compile (`UnemployedStartScreen.tabletLayoutKey` does not exist).

- [ ] **Step 5: Hook in the layout**

In `lib/features/career/unemployed_start_screen.dart`:

Add the imports `package:fnm/core/layout/form_factor.dart`, `package:fnm/features/nations/nation_preview.dart` and `package:fnm/shared/tablet/tablet.dart` (sorted), and below the imports `part 'unemployed_start_tablet_layout.dart';`.

In `UnemployedStartScreen` add:

```dart
  static const Key tabletLayoutKey = Key('unemployedStart.tabletLayout');

  /// The tablet's Take it for the offer from [nationId].
  static Key takeKey(int nationId) => ValueKey(('takeOffer', nationId));
```

In `_UnemployedStartScreenState.build`, directly after `final nationsAsync = ref.watch(nationsProvider);`, add:

```dart
    if (useTabletLayout(context, ref)) {
      return _UnemployedStartTabletLayout(
        nationsAsync: nationsAsync,
        offersOf: _offers,
      );
    }
```

- [ ] **Step 6: The layout**

Create `lib/features/career/unemployed_start_tablet_layout.dart`:

```dart
part of 'unemployed_start_screen.dart';

/// Out of work on a landscape tablet: the three offers side by side, each the
/// nation pick's preview of that federation (where it sits in the world, its
/// strength, its budget, its best player, the board's first demands) over its
/// own Take it. The offers are the screen State's draw ([offersOf] is
/// [_UnemployedStartScreenState._offers]), so a resize shows the same three.
class _UnemployedStartTabletLayout extends StatelessWidget {
  const _UnemployedStartTabletLayout({
    required this.nationsAsync,
    required this.offersOf,
  });

  final AsyncValue<List<Nation>> nationsAsync;
  final List<Nation> Function(List<Nation> all) offersOf;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      key: UnemployedStartScreen.tabletLayoutKey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TabletScreenHeader(
                title: l.bottomStartTitle,
                onBack: () => context.canPop()
                    ? context.pop()
                    : context.go(Routes.nations),
              ),
              Expanded(
                child: nationsAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(
                    child: Text(l.nationsCouldNotLoadNations(e.toString())),
                  ),
                  data: (nations) {
                    final offers = offersOf(nations);
                    if (offers.isEmpty) {
                      return Center(child: Text(l.nationsNoMatch));
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          l.bottomStartHeading,
                          style: AppTypography.headlineLargeMobile,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          l.bottomStartBlurb,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              for (final (i, nation) in offers.indexed) ...[
                                if (i > 0) const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: _OfferPanel(
                                    nation: nation,
                                    total: nations.length,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One federation's offer: the preview of the nation over the button that
/// takes the job (the phone's whole-card tap, as a button).
class _OfferPanel extends StatelessWidget {
  const _OfferPanel({required this.nation, required this.total});

  final Nation nation;
  final int total;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return PanelBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: NationPreview(
                nation: nation,
                caption: l.bottomStartRankOf(nation.ranking, total),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: PrimaryButton(
              key: UnemployedStartScreen.takeKey(nation.id),
              label: l.bottomStartAccept,
              icon: Icons.arrow_forward_rounded,
              onPressed: () =>
                  context.go('${Routes.newGame}?nationId=${nation.id}'),
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 7: Register, run, expect PASS**

Add `Routes.startFromBottom,` to `tabletReadyPaths` in `lib/features/shell/tablet_shell.dart`.

Run: `flutter test test/widget/unemployed_start_tablet_test.dart test/golden/phone_guard_unemployed_test.dart test/widget/tablet_full_screen_sweep_test.dart test/widget/nation_select_tablet_test.dart`
Expected: PASS, phone golden unchanged.

- [ ] **Step 8: Analyze, full suite, commit**

Run: `flutter analyze && flutter test`

```bash
git add lib/features/career/unemployed_start_screen.dart lib/features/career/unemployed_start_tablet_layout.dart lib/features/shell/tablet_shell.dart test/widget/unemployed_start_tablet_test.dart
git commit -m "feat(tablet): the out-of-work offers side by side

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 7: The cycle rollover's three steps in two columns

**risk: high (per-task review)**. An event flow that ends in the biggest write in the game (`startNextCycle` rolls the world into the next cycle), with the paywall in front of it on a free save.

Freshness, judged: the rollover is a full-screen route entered with `go`, so the shell and every in-shell screen are torn down while it runs (the comment in `_startNextCycle` says so), and `_startNextCycle` already invalidates the hub's data, the ranking and the board. No cascade is needed. What does change: `_begin` takes the container and the router before its first await, refreshes the inbox through the container (so it happens even if the manager has left), and goes to the hub only if he is still on `/cycle-rollover`.

A real roll needs a finished cycle (`_startNextCycle` returns untouched while there is no world champion: on the seeded save the cycle pointer stays 0), far too long a drive for a widget test. The tablet test therefore overrides `seasonServiceProvider` with a `SeasonService` that records the roll it is asked for (and can hold it at a gate); the read before is "no roll asked for", the read after is the one roll, to the job picked.

**Files:**
- Create: `lib/features/hub/cycle_rollover_tablet_layout.dart` (part of `cycle_rollover_screen.dart`)
- Modify: `lib/features/hub/cycle_rollover_screen.dart`, `lib/features/shell/tablet_shell.dart`
- Test: `test/golden/phone_guard_rollover_test.dart` (new, with goldens), `test/widget/cycle_rollover_tablet_test.dart` (new)

**Interfaces:**
- Produces: `CycleRolloverScreen.tabletLayoutKey`, `CycleRolloverScreen.beginKey`; private `_CycleRolloverScreenState._goTo(int step)`, `_CycleRolloverScreenState._pick(int? nationId)`, `_RolloverTabletLayout`, `_ChampionStepTablet`, `_BoardStepTablet`, `_IncomeStepTablet`.
- Changes: `_CycleRolloverScreenState._begin` (captured container and router; see above).
- Consumes: `_rolloverProvider`, `rolloverVerdictProvider`, `cycleIncomeProvider`, `cycleObjectivesProvider` (through `_ObjectivesSummary`), `premiumUnlockedProvider`, `trialExhausted`, `seasonServiceProvider` (through `_begin`), the phone's `_SummaryCard`, `_VerdictCard`, `_ObjectivesSummary`, `_OfferTile`, `_IncomeCard`, `_waiting`, `_failed`, `_backToSaves`, `useTabletLayout`, `FlagDisc`, `PrimaryButton`.

- [ ] **Step 1: Pin the phone rollover, step by step**

Create `test/golden/phone_guard_rollover_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/seeded_save.dart';

/// The phone end of a cycle, pinned before the tablet layout is added beside
/// it: the champion (a fresh save has none, so "the cycle is complete"), the
/// board's verdict with the jobs on offer (tall), and the money banked.
void main() {
  Future<SeededSave> open(WidgetTester tester, Size size) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.cycleRollover}?careerId=${save.careerId}',
      size: size,
    );
    return save;
  }

  Future<void> next(WidgetTester tester) async {
    await tester.tap(find.byType(PrimaryButton).last);
    await settle(tester);
  }

  testWidgets('rollover_champion_phone', (tester) async {
    await open(tester, kPhoneSize);
    expect(find.text(enL.hubCycleComplete), findsOneWidget);
    await expectAppGolden('goldens/rollover_champion_phone.png');
  });

  testWidgets('rollover_board_phone_tall', (tester) async {
    await open(tester, const Size(390, 2400));
    await next(tester);
    expect(find.text(enL.hubOffersOnTable), findsOneWidget);
    await expectAppGolden('goldens/rollover_board_phone_tall.png');
  });

  testWidgets('rollover_income_phone', (tester) async {
    await open(tester, kPhoneSize);
    await next(tester);
    await next(tester);
    expect(find.text(enL.hubFederationFinances), findsOneWidget);
    await expectAppGolden('goldens/rollover_income_phone.png');
  });
}
```

- [ ] **Step 2: Create the baseline, confirm it holds, commit it**

```bash
flutter test --update-goldens test/golden/phone_guard_rollover_test.dart
flutter test test/golden/phone_guard_rollover_test.dart
git add test/golden/phone_guard_rollover_test.dart test/golden/goldens/rollover_champion_phone.png test/golden/goldens/rollover_board_phone_tall.png test/golden/goldens/rollover_income_phone.png
git commit -m "test(tablet): phone guard for the cycle rollover

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

- [ ] **Step 3: Write the failing tablet test**

Create `test/widget/cycle_rollover_tablet_test.dart`:

```dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/util/message_text.dart';
import 'package:fnm/domain/repositories/career_repository.dart';
import 'package:fnm/features/career/nation_offers_providers.dart';
import 'package:fnm/features/hub/cycle_rollover_screen.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/seeded_save.dart';

/// The season as the rollover screen uses it, with the roll itself recorded
/// instead of run: a real roll needs a finished cycle (`startNextCycle`
/// returns untouched mid-cycle), far too long a drive for a widget test. The
/// roll can be held at [gate], to leave the page while it runs.
class _RecordingSeason extends SeasonService {
  _RecordingSeason(super.ref);

  /// The job each roll was asked for (null: stay).
  final List<int?> rolledTo = [];
  Completer<void>? gate;

  @override
  Future<void> startNextCycle(
    int careerId, {
    int? switchToNationId,
    MsgPart? boardTitle,
    MsgPart? boardBody,
    FederationInvestment? nextInvestment,
  }) async {
    await gate?.future;
    rolledTo.add(switchToNationId);
  }
}

Future<SeededSave> _open(WidgetTester tester, Size size) async {
  final save = await seedSave(
    tester,
    formFactor: FormFactor.tablet,
    overrides: [seasonServiceProvider.overrideWith(_RecordingSeason.new)],
  );
  await pumpRoute(
    tester,
    save,
    '${Routes.cycleRollover}?careerId=${save.careerId}',
    size: size,
  );
  return save;
}

Uri _uri(SeededSave save) =>
    save.container.read(routerProvider).routeInformationProvider.value.uri;

_RecordingSeason _season(SeededSave save) =>
    save.container.read(seasonServiceProvider) as _RecordingSeason;

Future<RolloverVerdict> _verdict(WidgetTester tester, SeededSave save) async {
  late RolloverVerdict v;
  await tester.runAsync(() async {
    final sub = save.container.listen(
      rolloverVerdictProvider(save.careerId).future,
      (_, _) {},
    );
    try {
      v = (await sub.read())!;
    } finally {
      sub.close();
    }
  });
  return v;
}

Future<void> _continue(WidgetTester tester) async {
  await tester.tap(find.widgetWithText(PrimaryButton, enL.hubContinue));
  await settle(tester);
}

void main() {
  for (final size in kTabletSizes) {
    testWidgets('every step in two columns, a way out on each, $size', (
      tester,
    ) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(CycleRolloverScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(FullScreenPhoneFrame), findsNothing);
      // Step 0: the trophy left, Continue right.
      expect(find.text(enL.hubCycleComplete), findsOneWidget);
      expect(
        tester.getRect(find.widgetWithText(PrimaryButton, enL.hubContinue)).left,
        greaterThan(tester.getRect(find.text(enL.hubCycleComplete)).right),
      );
      expect(find.text(enL.hubBackToSaves), findsOneWidget);
      // Step 1: the verdict left, the jobs right.
      await _continue(tester);
      expect(tester.takeException(), isNull);
      expect(
        tester.getRect(find.text(enL.hubOffersOnTable)).left,
        greaterThan(
          tester.getRect(find.text(enL.boardObjectivesTitle.toUpperCase())).right,
        ),
      );
      expect(find.text(enL.hubBackToSaves), findsOneWidget);
      // Step 2: the money left, the roll right.
      await tester.tap(find.byType(PrimaryButton).last);
      await settle(tester);
      expect(tester.takeException(), isNull);
      expect(
        tester.getRect(find.byKey(CycleRolloverScreen.beginKey)).left,
        greaterThan(tester.getRect(find.text(enL.hubFederationFinances)).right),
      );
      expect(find.text(enL.hubBackToSaves), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('the job picked is the job the save rolls to', (tester) async {
    final save = await _open(tester, kTabletSize);
    final offer = (await _verdict(tester, save)).offers[1].nation;
    await _continue(tester);
    // The last match is the tile in the right-hand column (the verdict is
    // built first, on the left).
    await tester.tap(find.text(offer.name).last);
    await settle(tester);
    await tester.tap(find.widgetWithText(PrimaryButton, enL.hubTakeTheJob));
    await settle(tester);
    expect(_season(save).rolledTo, isEmpty);
    await tester.tap(find.byKey(CycleRolloverScreen.beginKey));
    await settle(tester);
    expect(_season(save).rolledTo, [offer.id]);
    expect(_uri(save).path, Routes.hub);
    expect(_uri(save).queryParameters['careerId'], '${save.careerId}');
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a resize keeps the step and the job (Review Focus 3)', (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    final offer = (await _verdict(tester, save)).offers[0].nation;
    await _continue(tester);
    // The last match is the tile in the right-hand column (the verdict is
    // built first, on the left).
    await tester.tap(find.text(offer.name).last);
    await settle(tester);
    tester.view.physicalSize = const Size(900, 810);
    await settle(tester);
    expect(find.byKey(CycleRolloverScreen.tabletLayoutKey), findsNothing);
    expect(
      find.widgetWithText(PrimaryButton, enL.hubTakeTheJob),
      findsOneWidget,
    );
    tester.view.physicalSize = kTabletSize;
    await settle(tester);
    expect(find.byKey(CycleRolloverScreen.tabletLayoutKey), findsOneWidget);
    expect(
      find.widgetWithText(PrimaryButton, enL.hubTakeTheJob),
      findsOneWidget,
    );
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a manager who leaves mid-roll stays where he went '
      '(Review Focus 4)', (tester) async {
    final save = await _open(tester, kTabletSize);
    final season = _season(save)..gate = Completer<void>();
    await _continue(tester);
    await tester.tap(find.byType(PrimaryButton).last);
    await settle(tester);
    await tester.tap(find.byKey(CycleRolloverScreen.beginKey));
    // Let the paywall check pass and the roll reach its gate: leaving any
    // sooner would leave before the roll began.
    await settle(tester);
    expect(find.text(enL.hubStarting), findsOneWidget);
    expect(season.rolledTo, isEmpty);
    save.container.read(routerProvider).go(Routes.saves);
    await settle(tester);
    season.gate!.complete();
    await settle(tester);
    expect(season.rolledTo, [null], reason: 'the roll still ran');
    expect(_uri(save).path, Routes.saves);
    await tester.pumpWidget(const SizedBox());
  });
}
```

- [ ] **Step 4: Run it to verify it fails**

Run: `flutter test test/widget/cycle_rollover_tablet_test.dart`
Expected: FAIL to compile (`CycleRolloverScreen.tabletLayoutKey` does not exist).

- [ ] **Step 5: Step setters, a roll that waits for nobody, the hook**

In `lib/features/hub/cycle_rollover_screen.dart`:

Add the imports `package:fnm/core/layout/form_factor.dart` (sorted), and below the imports `part 'cycle_rollover_tablet_layout.dart';`.

In `CycleRolloverScreen` add:

```dart
  static const Key tabletLayoutKey = Key('cycleRollover.tabletLayout');
  static const Key beginKey = Key('cycleRollover.begin');
```

In `_CycleRolloverScreenState`, directly below the three fields, add:

```dart
  /// Moves to [step]; the tablet's buttons call it (the phone's set the
  /// field inline).
  void _goTo(int step) => setState(() => _step = step);

  /// Picks the job (null: stay); the tablet's tiles call it.
  void _pick(int? nationId) => setState(() => _selected = nationId);
```

Replace `_begin` with:

```dart
  Future<void> _begin(RolloverVerdict? v) async {
    if (_busy) return;
    // The end of the FIRST cycle is where the free game stops: the manager has
    // had a complete four years with nothing held back, and carrying the save
    // on is what is being sold. This is the only gate — every later rollover
    // runs straight through. See the monetisation spec.
    final season = ref.read(seasonServiceProvider);
    // Taken before the first await: a resize across 1000 px rebuilds this
    // screen in the other layout meanwhile, and a manager may go back to his
    // saves while the world rolls. The inbox is refreshed whatever he does;
    // the hub is opened only for a manager still here.
    final container = ProviderScope.containerOf(context, listen: false);
    final router = GoRouter.of(context);
    final careerId = widget.careerId;
    if (await season.trialBlocksNextCycle(careerId)) {
      if (!mounted) return;
      // A full page, not a sheet. A sheet is something you flick away; this
      // is the decision the career turns on.
      final carriedOn = await PremiumGateScreen.show(context);
      if (!mounted) return;
      // Dismissed without buying. Nothing has rolled: the save sits exactly
      // where it was, this screen is still in front of him, and he can open
      // the wall again or go back to his saves. Declining costs him nothing.
      if (!carriedOn || !ref.read(premiumUnlockedProvider)) return;
      // Bought. Roll straight away rather than making him find the button
      // again.
    }
    if (!mounted) return;
    setState(() => _busy = true);
    // The rollover banks the finished cycle's income and advances; the new
    // cycle's budget is allocated in the forced budget-setup event that opens
    // it (see nextEventProvider).
    //
    // Wrapped, because this is the one screen with nowhere to fall back to.
    // The roll was awaited bare inside an unawaited call: a throw anywhere in
    // it (and it moves the whole world) went nowhere, `_busy` stayed true for
    // ever, and the single button on the screen was left reading "Starting…"
    // with nothing behind it.
    try {
      await season.startNextCycle(
        careerId,
        switchToNationId: _selected,
        boardTitle: v?.headline,
        boardBody: v?.detail,
      );
      container
        ..invalidate(messageInboxProvider(careerId))
        ..invalidate(unreadMessagesProvider(careerId));
      if (!mounted) return;
      // Once a cycle, with the new one in the save: the moment a career is
      // most worth keeping a copy of. The notice outlives this screen (the
      // messenger is the app's), so it is read on the hub.
      await CycleBackup.run(
        ScaffoldMessenger.of(context),
        AppLocalizations.of(context),
        ref,
        careerId,
      );
      if (!mounted) return;
      // `router.state` is the top-most route, a pushed one included.
      if (router.state.uri.path == Routes.cycleRollover) {
        router.go('${Routes.hub}?careerId=$careerId');
      }
    } on Object catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).hubCouldNotAdvance('$e')),
        ),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
```

(The comments are the old ones, kept; the old `if (!mounted) return;` before the inbox refresh moved below it, the old `context.go` became the router check, and `widget.careerId` is read once before the awaits.)

In `build`, directly after `final viewAsync = ref.watch(_rolloverProvider(widget.careerId));`, add:

```dart
    if (useTabletLayout(context, ref)) {
      return _RolloverTabletLayout(state: this, viewAsync: viewAsync);
    }
```

- [ ] **Step 6: The layout**

Create `lib/features/hub/cycle_rollover_tablet_layout.dart`:

```dart
part of 'cycle_rollover_screen.dart';

/// The end of a cycle on a landscape tablet, step by step as on the phone:
/// the champion beside the final's story; the board's verdict and graded
/// briefs beside the jobs on offer; the money banked beside the button that
/// rolls the save on. Every step, pick and button is the screen State's
/// ([_CycleRolloverScreenState._step], `_selected`, `_begin`), so a resize
/// keeps the step and the job picked, and the phone's way back to the saves
/// is on every step.
class _RolloverTabletLayout extends StatelessWidget {
  const _RolloverTabletLayout({required this.state, required this.viewAsync});

  final _CycleRolloverScreenState state;
  final AsyncValue<_RolloverView?> viewAsync;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      key: CycleRolloverScreen.tabletLayoutKey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: viewAsync.when(
            loading: state._waiting,
            error: (e, _) => state._failed(l.hubCouldNotLoad('$e')),
            data: (view) => switch (state._step) {
              0 => _ChampionStepTablet(state: state, view: view),
              1 => _BoardStepTablet(state: state),
              _ => _IncomeStepTablet(state: state, view: view),
            },
          ),
        ),
      ),
    );
  }
}

/// Step 0: the trophy and the champion on the left; the final, the host and
/// the golden boot over Continue on the right.
class _ChampionStepTablet extends StatelessWidget {
  const _ChampionStepTablet({required this.state, required this.view});

  final _CycleRolloverScreenState state;
  final _RolloverView? view;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final wc = view?.worldCup;
    String name(int id) => view?.nations[id]?.name ?? l.hubUnknown;
    String code(int id) => view?.nations[id]?.code ?? '??';
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.emoji_events,
                color: AppColors.primary,
                size: 96,
              ),
              const SizedBox(height: AppSpacing.md),
              if (wc != null) ...[
                Text(
                  l.hubWorldChampionsYear(wc.year),
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                FlagDisc(code(wc.championId), size: 72, highlighted: true),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  name(wc.championId),
                  textAlign: TextAlign.center,
                  style: AppTypography.headlineLargeMobile,
                ),
              ] else
                Text(
                  l.hubCycleComplete,
                  textAlign: TextAlign.center,
                  style: AppTypography.headlineMedium,
                ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.xl),
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (wc != null) ...[
                    _SummaryCard(wc: wc, name: name, code: code),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  PrimaryButton(
                    label: l.hubContinue,
                    icon: Icons.arrow_forward_rounded,
                    onPressed: () => state._goTo(1),
                  ),
                  state._backToSaves(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Step 1: the verdict and the graded briefs on the left; the job he has
/// and the jobs on offer over the button on the right.
class _BoardStepTablet extends ConsumerWidget {
  const _BoardStepTablet({required this.state});

  final _CycleRolloverScreenState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final careerId = state.widget.careerId;
    final verdictAsync = ref.watch(rolloverVerdictProvider(careerId));
    return verdictAsync.when(
      loading: state._waiting,
      error: (e, _) => state._failed(l.hubCouldNotLoad('$e')),
      data: (v) {
        if (v == null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PrimaryButton(
                  label: l.hubContinue,
                  icon: Icons.arrow_forward_rounded,
                  onPressed: () => state._goTo(2),
                ),
                state._backToSaves(),
              ],
            ),
          );
        }
        final canStay = !v.sacked;
        final ready = state._selected != null || canStay;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                children: [
                  _VerdictCard(verdict: v),
                  const SizedBox(height: AppSpacing.md),
                  _ObjectivesSummary(careerId: careerId),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        if (canStay && v.currentNation != null) ...[
                          Text(
                            l.hubYourJob,
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          _OfferTile(
                            nation: v.currentNation!,
                            subtitle: l.hubStayProject,
                            selected: state._selected == null,
                            onTap: () => state._pick(null),
                          ),
                          const SizedBox(height: AppSpacing.md),
                        ],
                        Text(
                          v.sacked ? l.hubChooseNextJob : l.hubOffersOnTable,
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        for (final o in v.offers)
                          _OfferTile(
                            nation: o.nation,
                            subtitle: l.hubOfferSubtitle(
                              offerTierLabel(l, o.tier),
                              o.position,
                            ),
                            selected: state._selected == o.nation.id,
                            onTap: () => state._pick(o.nation.id),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  PrimaryButton(
                    label: state._selected == null
                        ? l.hubContinueWith(
                            v.currentNation?.name ?? l.hubYourNation,
                          )
                        : l.hubTakeTheJob,
                    icon: Icons.arrow_forward_rounded,
                    onPressed: !ready ? null : () => state._goTo(2),
                  ),
                  state._backToSaves(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Step 2: the money banked on the left; the roll (or, on a free save that
/// has had its cycle, the way past the wall) on the right.
class _IncomeStepTablet extends ConsumerWidget {
  const _IncomeStepTablet({required this.state, required this.view});

  final _CycleRolloverScreenState state;
  final _RolloverView? view;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final careerId = state.widget.careerId;
    final incomeAsync = ref.watch(cycleIncomeProvider(careerId));
    final verdict = ref.watch(rolloverVerdictProvider(careerId)).valueOrNull;
    final blocked = trialExhausted(
      cyclePointer: view?.cyclePointer ?? 0,
      premiumUnlocked: ref.watch(premiumUnlockedProvider),
    );
    return incomeAsync.when(
      loading: state._waiting,
      error: (e, _) => state._failed(l.hubCouldNotLoadFinances('$e')),
      data: (income) => Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              children: [
                Text(
                  l.hubFederationFinances,
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                _IncomeCard(
                  income: income,
                  openingBalance: view?.budget ?? 0,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  l.hubBudgetIntro,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xl),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PrimaryButton(
                      key: CycleRolloverScreen.beginKey,
                      label: state._busy
                          ? l.hubStarting
                          : (blocked
                                ? l.hubContinueCareer
                                : l.hubBeginNextCycle),
                      icon: blocked
                          ? Icons.lock_open_rounded
                          : Icons.skip_next_rounded,
                      onPressed: state._busy
                          ? null
                          : () => unawaited(state._begin(verdict)),
                    ),
                    state._backToSaves(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 7: Register, run, expect PASS**

Add `Routes.cycleRollover,` to `tabletReadyPaths` in `lib/features/shell/tablet_shell.dart`.

Run: `flutter test test/widget/cycle_rollover_tablet_test.dart test/golden/phone_guard_rollover_test.dart test/widget/cycle_rollover_always_has_a_way_out_test.dart test/widget/tablet_full_screen_sweep_test.dart`
Expected: PASS, phone goldens unchanged.

- [ ] **Step 8: Analyze, full suite, commit**

Run: `flutter analyze && flutter test`

```bash
git add lib/features/hub/cycle_rollover_screen.dart lib/features/hub/cycle_rollover_tablet_layout.dart lib/features/shell/tablet_shell.dart test/widget/cycle_rollover_tablet_test.dart
git commit -m "feat(tablet): the cycle rollover's steps in two columns

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 8: Settings in two columns

**risk: high (per-task review)**. Every card writes something (sound, language, the walk through, the whole-database backup and restore) and the export opens a share sheet an iPad must be able to anchor.

The phone's one long `build` becomes seven card widgets (five extracted, `_ContactCard` and `_BackupCard` already are), moved verbatim, each watching what it shows. Both layouts lay out the same seven; nothing about a card changes.

**Files:**
- Create: `lib/features/settings/settings_tablet_layout.dart` (part of `settings_screen.dart`)
- Modify: `lib/features/settings/settings_screen.dart`, `lib/features/shell/tablet_shell.dart`
- Test: `test/golden/phone_guard_settings_test.dart` (new, with goldens), `test/widget/settings_tablet_test.dart` (new)

**Interfaces:**
- Produces: `SettingsScreen.tabletLayoutKey`; private `_SoundHapticsCard`, `_LanguageCard`, `_FreeScopeCard`, `_TourCard`, `_DiagnosticsCard` (each a moved phone card), `_SettingsTabletLayout`.
- Consumes: `soundHapticsEnabledProvider`, `setSoundHaptics`, `localeProvider`, `setLocale` (through `_pickLanguage`), `premiumUnlockedProvider`, `showPaywall`, `savesProvider`, `startTour`, `saveBackupServiceProvider` (through `_BackupCard`), `shareOriginOf` (unchanged, in `_BackupCard`), `useTabletLayout`, `TabletScreenHeader`, `l.homeSettings`.

- [ ] **Step 1: Pin the phone settings**

Create `test/golden/phone_guard_settings_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';

import '../helpers/seeded_save.dart';

/// The phone settings, pinned before their cards move into widgets of their
/// own and the tablet layout is added beside them. With a save, so the walk
/// through is offered; tall, so the backup card at the foot is in it.
void main() {
  for (final (name, size) in [
    ('settings_phone', kPhoneSize),
    ('settings_phone_tall', const Size(390, 2400)),
  ]) {
    testWidgets(name, (tester) async {
      final save = await seedSave(tester);
      await pumpRoute(tester, save, Routes.settings, size: size);
      expect(find.text(enL.settingsSoundHapticsTitle), findsOneWidget);
      await expectAppGolden('goldens/$name.png');
    });
  }
}
```

- [ ] **Step 2: Create the baseline, confirm it holds, commit it**

```bash
flutter test --update-goldens test/golden/phone_guard_settings_test.dart
flutter test test/golden/phone_guard_settings_test.dart
git add test/golden/phone_guard_settings_test.dart test/golden/goldens/settings_phone.png test/golden/goldens/settings_phone_tall.png
git commit -m "test(tablet): phone guard for settings

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

- [ ] **Step 3: Write the failing tablet test**

Create `test/widget/settings_tablet_test.dart`:

```dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/settings/save_backup_providers.dart';
import 'package:fnm/features/settings/settings_providers.dart';
import 'package:fnm/features/settings/settings_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/seeded_save.dart';

/// The whole-database export without the file system: the share sheet only
/// takes the path, so the file is never written.
class _FakeBackup extends SaveBackupService {
  _FakeBackup(super.ref);

  int exports = 0;

  @override
  Future<File> export({DateTime? at}) async {
    exports++;
    return File('fnm-test-backup.fnmbackup');
  }
}

Future<SeededSave> _open(WidgetTester tester, Size size) async {
  final save = await seedSave(
    tester,
    formFactor: FormFactor.tablet,
    overrides: [saveBackupServiceProvider.overrideWith(_FakeBackup.new)],
  );
  await pumpRoute(tester, save, Routes.settings, size: size);
  return save;
}

Uri _uri(SeededSave save) =>
    save.container.read(routerProvider).routeInformationProvider.value.uri;

Future<SharedPreferences> _prefs(WidgetTester tester) async {
  late SharedPreferences prefs;
  await tester.runAsync(() async {
    prefs = await SharedPreferences.getInstance();
  });
  return prefs;
}

void main() {
  for (final size in kTabletSizes) {
    testWidgets('the game left, the data right, $size', (tester) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(SettingsScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(FullScreenPhoneFrame), findsNothing);
      final sound = tester.getRect(find.text(enL.settingsSoundHapticsTitle));
      final backup = tester.getRect(find.text(enL.backupTitle));
      expect(backup.left, greaterThan(sound.right));
      expect(find.text(enL.settingsTourTitle), findsOneWidget);
      expect(find.text(enL.settingsDiagnosticsTitle), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets("the sound switch writes the phone's setting", (tester) async {
    final save = await _open(tester, kTabletSize);
    expect((await _prefs(tester)).getBool('settings.soundHaptics'), isNull);
    expect(save.container.read(soundHapticsEnabledProvider), isTrue);
    await tester.tap(find.text(enL.settingsSoundHapticsTitle));
    await settle(tester);
    expect(save.container.read(soundHapticsEnabledProvider), isFalse);
    expect((await _prefs(tester)).getBool('settings.soundHaptics'), isFalse);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the language dialog closes itself and the choice is kept', (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    expect((await _prefs(tester)).getString('settings.locale'), isNull);
    await tester.tap(find.byKey(const Key('settings-language-tile')));
    await settle(tester);
    // On a tablet the picker is a root dialog.
    expect(find.byType(Dialog), findsOneWidget);
    await tester.tap(find.byKey(const Key('language-option-cs')));
    await settle(tester);
    expect(find.byType(Dialog), findsNothing);
    expect(_uri(save).path, Routes.settings);
    expect(save.container.read(localeProvider), const Locale('cs'));
    expect((await _prefs(tester)).getString('settings.locale'), 'cs');
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the backup export points the share sheet at its button '
      '(Review Focus 7)', (tester) async {
    final save = await _open(tester, kTabletSize);
    const channel = MethodChannel('dev.fluttercommunity.plus/share');
    final calls = <MethodCall>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
      call,
    ) async {
      calls.add(call);
      return 'dev.fluttercommunity.plus/share/unavailable';
    });
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        channel,
        null,
      ),
    );
    final backup = save.container.read(saveBackupServiceProvider) as _FakeBackup;
    expect(backup.exports, 0);
    final export = find.widgetWithText(PrimaryButton, enL.backupExport);
    final button = tester.getRect(export);
    await tester.tap(export);
    await settle(tester);
    expect(backup.exports, 1);
    expect(calls, hasLength(1));
    final args = calls.single.arguments as Map<Object?, Object?>;
    expect(
      Rect.fromLTWH(
        args['originX']! as double,
        args['originY']! as double,
        args['originWidth']! as double,
        args['originHeight']! as double,
      ),
      button,
    );
    expect(find.text(enL.backupFailed), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets("diagnostics and the back arrow go where the phone's do", (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    await tester.tap(find.text(enL.settingsDiagnosticsTitle));
    await settle(tester);
    expect(_uri(save).path, Routes.diagnostics);
    save.container.read(routerProvider).go(Routes.settings);
    await settle(tester);
    await tester.tap(find.byKey(TabletScreenHeader.backKey));
    await settle(tester);
    expect(_uri(save).path, Routes.home);
    await tester.pumpWidget(const SizedBox());
  });
}
```

- [ ] **Step 4: Run it to verify it fails**

Run: `flutter test test/widget/settings_tablet_test.dart`
Expected: FAIL to compile (`SettingsScreen.tabletLayoutKey` does not exist).

- [ ] **Step 5: One widget per card; hook in the layout**

In `lib/features/settings/settings_screen.dart`:

Replace the import `package:fnm/shared/tablet/adaptive_sheet.dart` with `package:fnm/shared/tablet/tablet.dart`, add `package:fnm/core/layout/form_factor.dart` (sorted), and below the imports `part 'settings_tablet_layout.dart';`.

Replace the whole `SettingsScreen` class with the following (the screen keeps its app bar and list; each card's code is the old `build`'s, moved verbatim into its own widget below, with the reads it needs):

```dart
/// App settings: the sound-and-haptics toggle for match cues and the UI
/// language selector.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const Key tabletLayoutKey = Key('settings.tabletLayout');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (useTabletLayout(context, ref)) return const _SettingsTabletLayout();
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          // Settings is opened with go() (which replaces the route), so pop
          // back if we can, else return to the home screen.
          onPressed: () =>
              context.canPop() ? context.pop() : context.go(Routes.home),
        ),
        title: Text(
          l.settingsTitle,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: ListView(
        // A ListView given its own padding drops the safe-area inset it would
        // otherwise add, so on edge-to-edge Android the last card (Restore
        // from file) sat under the system navigation bar. Add it back.
        padding: EdgeInsets.fromLTRB(
          AppSpacing.marginMobile,
          AppSpacing.marginMobile,
          AppSpacing.marginMobile,
          AppSpacing.marginMobile + MediaQuery.viewPaddingOf(context).bottom,
        ),
        children: const [
          _SoundHapticsCard(),
          SizedBox(height: AppSpacing.md),
          _LanguageCard(),
          SizedBox(height: AppSpacing.md),
          _FreeScopeCard(),
          SizedBox(height: AppSpacing.md),
          _TourCard(),
          SizedBox(height: AppSpacing.md),
          _DiagnosticsCard(),
          SizedBox(height: AppSpacing.md),
          _ContactCard(),
          SizedBox(height: AppSpacing.md),
          _BackupCard(),
        ],
      ),
    );
  }
}

/// Sound and haptics for match cues, on or off.
class _SoundHapticsCard extends ConsumerWidget {
  const _SoundHapticsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final soundHaptics = ref.watch(soundHapticsEnabledProvider);
    return AppCard(
      padding: EdgeInsets.zero,
      child: SwitchListTile(
        value: soundHaptics,
        onChanged: (v) => setSoundHaptics(ref, v),
        activeColor: AppColors.primary,
        title: Text(
          l.settingsSoundHapticsTitle,
          style: AppTypography.bodyMedium,
        ),
        subtitle: Text(
          l.settingsSoundHapticsBlurb,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        secondary: const Icon(
          Icons.vibration_rounded,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

/// The UI language: the device's, or one forced.
class _LanguageCard extends ConsumerWidget {
  const _LanguageCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    // 'system' when there is no override, otherwise the forced language code.
    final current = ref.watch(localeProvider)?.languageCode ?? 'system';
    return AppCard(
      padding: EdgeInsets.zero,
      child: ListTile(
        key: const Key('settings-language-tile'),
        leading: const Icon(
          Icons.translate_rounded,
          color: AppColors.primary,
        ),
        title: Text(
          l.settingsLanguageTitle,
          style: AppTypography.bodyMedium,
        ),
        subtitle: Text(
          l.settingsLanguageBlurb,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              current == 'system'
                  ? l.settingsLanguageSystem
                  : _languageEndonyms[current] ?? current,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
            const Icon(
              Icons.arrow_drop_down_rounded,
              color: AppColors.primary,
            ),
          ],
        ),
        onTap: () => _pickLanguage(context, ref, current),
      ),
    );
  }
}

/// What the free game covers, stated plainly and stated ONCE, here.
///
/// Deliberately not on the hub, not before a tournament, and not on the way
/// into a save: a manager on his first day is being asked to care about a
/// nation, not about a price, and putting the terms in front of him there
/// costs the people who would have stayed. The trade is that the gate
/// arrives at the first rollover without a run-up — this page is where
/// somebody who wants to know can find out, and it is the whole of the
/// disclosure.
class _FreeScopeCard extends ConsumerWidget {
  const _FreeScopeCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final premium = ref.watch(premiumUnlockedProvider);
    return AppCard(
      // Tapping it opens the paywall, which is where "Restore
      // purchases" lives. A manager who paid on his old phone needs a
      // way to say so that does not involve finishing a whole cycle
      // first, and Apple requires a visible restore control for a
      // non-consumable.
      onTap: () => unawaited(showPaywall(context)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            premium ? Icons.verified_rounded : Icons.lock_open_rounded,
            size: 18,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  premium
                      ? l.settingsUnlockedTitle
                      : l.settingsFreeScopeTitle,
                  style: AppTypography.bodyMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  premium
                      ? l.settingsUnlockedBlurb
                      : l.settingsFreeScopeBlurb,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The way back into the walk through. It is offered once ever, so without
/// this a manager who said "no thanks" on his first day would have no way of
/// ever changing his mind.
///
/// It walks the save he played last, because the tour navigates real screens
/// and every one of them needs a save to show. With no save at all there is
/// nothing to walk, and the row says so rather than starting a tour of empty
/// rooms.
class _TourCard extends ConsumerWidget {
  const _TourCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    // The save to walk: the one played most recently, or the newest if none
    // has ever been opened.
    final saves = ref.watch(savesProvider).valueOrNull ?? const <Career>[];
    final replayable = saves.isEmpty
        ? null
        : (saves.toList()..sort((a, b) {
                final at = a.lastPlayedAt ?? a.createdAt;
                final bt = b.lastPlayedAt ?? b.createdAt;
                return bt.compareTo(at);
              }))
              .first;
    return AppCard(
      padding: EdgeInsets.zero,
      child: ListTile(
        enabled: replayable != null,
        onTap: replayable == null
            ? null
            : () {
                startTour(ref, replayable.id);
                context.go('${Routes.hub}?careerId=${replayable.id}');
              },
        leading: const Icon(
          Icons.school_outlined,
          color: AppColors.primary,
        ),
        title: Text(
          l.settingsTourTitle,
          style: AppTypography.bodyMedium,
        ),
        subtitle: Text(
          replayable == null ? l.settingsTourNoSave : l.settingsTourBlurb,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          size: 18,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

/// The on-device error log.
class _DiagnosticsCard extends StatelessWidget {
  const _DiagnosticsCard();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AppCard(
      padding: EdgeInsets.zero,
      child: ListTile(
        onTap: () => context.push(Routes.diagnostics),
        leading: const Icon(
          Icons.bug_report_outlined,
          color: AppColors.primary,
        ),
        title: Text(
          l.settingsDiagnosticsTitle,
          style: AppTypography.bodyMedium,
        ),
        subtitle: Text(
          l.settingsDiagnosticsBlurb,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          size: 18,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
```

`_ContactCard`, `_BackupCard` and everything above `SettingsScreen` are not touched. (The old `build`'s doc comments on the free-scope card and the walk through are now those widgets' doc comments; the text is unchanged.)

- [ ] **Step 6: The layout**

Create `lib/features/settings/settings_tablet_layout.dart`:

```dart
part of 'settings_screen.dart';

/// Settings on a landscape tablet: the game's own settings (sound, language,
/// what the free game covers, the walk through) on the left; the log, the
/// way to reach the maker and the saves' backup on the right. Every card is
/// the phone's own, writes and share sheet included.
class _SettingsTabletLayout extends StatelessWidget {
  const _SettingsTabletLayout();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      key: SettingsScreen.tabletLayoutKey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TabletScreenHeader(
                title: l.homeSettings,
                onBack: () =>
                    context.canPop() ? context.pop() : context.go(Routes.home),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ListView(
                        children: const [
                          _SoundHapticsCard(),
                          SizedBox(height: AppSpacing.md),
                          _LanguageCard(),
                          SizedBox(height: AppSpacing.md),
                          _FreeScopeCard(),
                          SizedBox(height: AppSpacing.md),
                          _TourCard(),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: ListView(
                        children: const [
                          _DiagnosticsCard(),
                          SizedBox(height: AppSpacing.md),
                          _ContactCard(),
                          SizedBox(height: AppSpacing.md),
                          _BackupCard(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 7: Register, run, expect PASS**

Add `Routes.settings,` to `tabletReadyPaths` in `lib/features/shell/tablet_shell.dart`.

Run: `flutter test test/widget/settings_tablet_test.dart test/golden/phone_guard_settings_test.dart test/widget/settings_free_scope_test.dart test/widget/language_picker_test.dart test/widget/home_tablet_test.dart test/widget/tablet_full_screen_sweep_test.dart`
Expected: PASS, phone goldens unchanged.

- [ ] **Step 8: Analyze, full suite, commit**

Run: `flutter analyze && flutter test`

```bash
git add lib/features/settings/settings_screen.dart lib/features/settings/settings_tablet_layout.dart lib/features/shell/tablet_shell.dart test/widget/settings_tablet_test.dart
git commit -m "feat(tablet): settings in two columns of the phone's cards

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 9: Friendlies: the games picked beside every window's card

**risk: high (per-task review)**. Schedules fixtures (a write), then navigates; and the picks are the manager's in-progress choice.

The seeded save opens with its first qualifier days away, so it has no friendly gap (`friendliesPlanProvider` is null; the page shows its Continue). The other states come from a fake plan of two windows, built with the real nations (`test/helpers/team_fixtures.dart`); it is overridden with a value that has no awaits, because confirming invalidates it (Global Constraints, the teardown quirk).

**Files:**
- Create: `lib/features/friendlies/friendlies_tablet_layout.dart` (part of `friendlies_screen.dart`), `test/helpers/team_fixtures.dart`
- Modify: `lib/features/friendlies/friendlies_screen.dart`, `lib/features/shell/tablet_shell.dart`
- Test: `test/golden/phone_guard_friendlies_test.dart` (new, with goldens), `test/widget/friendlies_tablet_test.dart` (new)

**Interfaces:**
- Produces (`team_fixtures.dart`): `FriendliesPlan fakeFriendliesPlan()`, `Override fakeFriendliesOverride()` (Task 12 appends the team records' fakes to this file).
- Produces: `FriendliesScreen.tabletLayoutKey`, `FriendliesScreen.confirmKey`; top-level private `_monthAbbr`, `_label`, `_opponentsFor`, `_markedPerWindow`, `_reasonFor` (moved out of the State, unchanged); `_FriendliesScreenState._pick(DateTime window, int nationId)`; `_FriendliesTabletLayout`, `_PickLine`.
- Changes: `_FriendliesScreenState._confirm` takes the router before its await and goes to the hub only if the manager is still on `/friendlies`.
- Consumes: `friendliesPlanProvider`, `friendliesServiceProvider.arrange` (through `_confirm`), `friendlyIsHome`, `friendlyWindowKey`, the phone's `_WindowCard` and `_VenueBadge`, `TabletPage`, `Panel`, `ColumnFlow`, `PrimaryButton`, `FlagDisc`, `fieldOf`, `realNationsById`, `l.hubEventArrangeFriendlies`, `l.friendliesYourGames`, `l.friendliesArrangeIntro`, `l.friendliesFree`, `l.friendliesNoneThisWindow`, `l.friendliesConfirmCount`, `l.friendliesContinue`, `l.friendliesLoadError`, `l.hubUnknown`.

- [ ] **Step 1: The fake plan, and the phone pinned with it**

Create `test/helpers/team_fixtures.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/features/friendlies/friendlies_providers.dart';

import 'competition_fixtures.dart';
import 'seeded_save.dart';

// Fakes for the team screens a fresh save has nothing to show on yet (an
// open friendly gap, the team's records), drawn with the REAL nations and
// players.

/// Two open windows before the next qualifier, March (away) and June (home)
/// of 2027, the manager's three qualifying rivals marked, and the
/// twenty-four best-ranked other sides dealt between the windows.
FriendliesPlan fakeFriendliesPlan() {
  final field = fieldOf(seededNationId, 25);
  return FriendliesPlan(
    windows: [DateTime(2027, 3, 14), DateTime(2027, 6, 14)],
    rivals: field.sublist(1, 4),
    reason: FriendlyReason.qualifyingGroup,
    opponents: field.sublist(1),
    nations: realNationsById,
    playerNationId: seededNationId,
    cycle: 0,
  );
}

/// Confirming invalidates the plan; the override has no awaits, so a plan
/// invalidated and never re-read does not trip riverpod 2.6.1 at teardown.
Override fakeFriendliesOverride() => friendliesPlanProvider(
  kSeededCareerId,
).overrideWith((ref) async => fakeFriendliesPlan());
```

Create `test/golden/phone_guard_friendlies_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';

import '../helpers/seeded_save.dart';
import '../helpers/team_fixtures.dart';

/// The phone friendlies, pinned before the tablet layout is added beside
/// them: no gap (a fresh save), and the fake gap of two windows, short and
/// whole.
void main() {
  testWidgets('friendlies_none_phone', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.friendlies}?careerId=${save.careerId}',
    );
    expect(find.text(enL.friendliesContinue), findsOneWidget);
    await expectAppGolden('goldens/friendlies_none_phone.png');
  });

  for (final (name, size) in [
    ('friendlies_phone', kPhoneSize),
    ('friendlies_phone_tall', const Size(390, 2400)),
  ]) {
    testWidgets(name, (tester) async {
      final save = await seedSave(
        tester,
        overrides: [fakeFriendliesOverride()],
      );
      await pumpRoute(
        tester,
        save,
        '${Routes.friendlies}?careerId=${save.careerId}',
        size: size,
      );
      expect(find.text(enL.friendliesNoneThisWindow), findsOneWidget);
      await expectAppGolden('goldens/$name.png');
    });
  }
}
```

- [ ] **Step 2: Create the baseline, confirm it holds, commit it**

```bash
flutter test --update-goldens test/golden/phone_guard_friendlies_test.dart
flutter test test/golden/phone_guard_friendlies_test.dart
git add test/helpers/team_fixtures.dart test/golden/phone_guard_friendlies_test.dart test/golden/goldens/friendlies_none_phone.png test/golden/goldens/friendlies_phone.png test/golden/goldens/friendlies_phone_tall.png
git commit -m "test(tablet): phone guard for the friendlies, with a fake gap

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

- [ ] **Step 3: Write the failing tablet test**

Create `test/widget/friendlies_tablet_test.dart`:

```dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/competition/rounds.dart';
import 'package:fnm/features/friendlies/friendlies_providers.dart';
import 'package:fnm/features/friendlies/friendlies_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/seeded_save.dart';
import '../helpers/team_fixtures.dart';

/// Arranging friendlies, held at a gate until the test lets it through, so
/// the manager can leave the page while the games are saved.
class _GatedFriendlies extends FriendliesService {
  _GatedFriendlies(super.ref);

  final Completer<void> gate = Completer<void>();

  @override
  Future<void> arrange(
    int careerId, {
    required int nationId,
    required int cycle,
    required Map<DateTime, int> picks,
    required List<DateTime> allWindows,
  }) async {
    await gate.future;
    return super.arrange(
      careerId,
      nationId: nationId,
      cycle: cycle,
      picks: picks,
      allWindows: allWindows,
    );
  }
}

Future<SeededSave> _open(
  WidgetTester tester,
  Size size, {
  bool gated = false,
}) async {
  final save = await seedSave(
    tester,
    formFactor: FormFactor.tablet,
    overrides: [
      fakeFriendliesOverride(),
      if (gated) friendliesServiceProvider.overrideWith(_GatedFriendlies.new),
    ],
  );
  await pumpRoute(
    tester,
    save,
    '${Routes.friendlies}?careerId=${save.careerId}',
    size: size,
  );
  return save;
}

Uri _uri(SeededSave save) =>
    save.container.read(routerProvider).routeInformationProvider.value.uri;

/// The manager's friendlies on the calendar.
Future<List<Fixture>> _friendlies(WidgetTester tester, SeededSave save) async {
  late List<Fixture> all;
  await tester.runAsync(() async {
    all = await save.container
        .read(competitionRepositoryProvider)
        .fixturesForNation(save.careerId, save.nationId);
  });
  return [
    for (final f in all)
      if (f.round == Rounds.friendly) f,
  ];
}

Future<bool> _decided(
  WidgetTester tester,
  SeededSave save,
  DateTime window,
) async {
  late bool watched;
  await tester.runAsync(() async {
    watched = await save.container
        .read(competitionRepositoryProvider)
        .hasWatchedDraw(save.careerId, 0, friendlyWindowKey(window));
  });
  return watched;
}

/// The first side dealt to the first window: the head of the shortlist.
String get _firstOpponentCode => fakeFriendliesPlan().opponents.first.code;

void main() {
  for (final size in kTabletSizes) {
    testWidgets('the picks left, every window right, $size', (tester) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(FriendliesScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      final picks = tester.getRect(
        find.text(enL.friendliesYourGames.toUpperCase()),
      );
      expect(tester.getRect(find.byType(ColumnFlow)).left, greaterThan(picks.right));
      expect(find.text(enL.friendliesFree), findsNWidgets(4));
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('no gap: the Continue to the hub, as on the phone', (
    tester,
  ) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    await pumpRoute(
      tester,
      save,
      '${Routes.friendlies}?careerId=${save.careerId}',
      size: kTabletSize,
    );
    expect(find.byKey(FriendliesScreen.tabletLayoutKey), findsOneWidget);
    await tester.tap(find.widgetWithText(PrimaryButton, enL.friendliesContinue));
    await settle(tester);
    expect(_uri(save).path, Routes.hub);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a pick and Confirm schedule the game the phone would', (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    final plan = fakeFriendliesPlan();
    final opponent = plan.opponents.first;
    final march = plan.windows.first;
    expect(await _friendlies(tester, save), isEmpty);
    expect(await _decided(tester, save, march), isFalse);
    await tester.tap(find.text(_firstOpponentCode).first);
    await settle(tester);
    // The picks panel names him; the button counts him.
    expect(find.text(opponent.name), findsWidgets);
    expect(find.text(enL.friendliesConfirmCount(1)), findsOneWidget);
    await tester.tap(find.byKey(FriendliesScreen.confirmKey));
    await settle(tester);
    final games = await _friendlies(tester, save);
    expect(games, hasLength(1));
    expect(games.single.date, march);
    expect({games.single.homeNationId, games.single.awayNationId}, {
      save.nationId,
      opponent.id,
    });
    for (final w in plan.windows) {
      expect(await _decided(tester, save, w), isTrue, reason: '$w');
    }
    expect(_uri(save).path, Routes.hub);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a resize keeps the picks (Review Focus 3)', (tester) async {
    await _open(tester, kTabletSize);
    await tester.tap(find.text(_firstOpponentCode).first);
    await settle(tester);
    tester.view.physicalSize = const Size(900, 810);
    await settle(tester);
    expect(find.byKey(FriendliesScreen.tabletLayoutKey), findsNothing);
    expect(find.text(enL.friendliesConfirmCount(1)), findsOneWidget);
    tester.view.physicalSize = kTabletSize;
    await settle(tester);
    expect(find.byKey(FriendliesScreen.tabletLayoutKey), findsOneWidget);
    expect(find.text(enL.friendliesConfirmCount(1)), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a manager who leaves while the games are saved stays where '
      'he went (Review Focus 4)', (tester) async {
    final save = await _open(tester, kTabletSize, gated: true);
    final service =
        save.container.read(friendliesServiceProvider) as _GatedFriendlies;
    final march = fakeFriendliesPlan().windows.first;
    await tester.tap(find.byKey(FriendliesScreen.confirmKey));
    await tester.pump();
    // The sidebar's ranking, while the save is held.
    save.container
        .read(routerProvider)
        .go('${Routes.ranking}?careerId=${save.careerId}');
    await settle(tester);
    service.gate.complete();
    await settle(tester);
    expect(await _decided(tester, save, march), isTrue, reason: 'still saved');
    expect(_uri(save).path, Routes.ranking);
    await tester.pumpWidget(const SizedBox());
  });
}
```

- [ ] **Step 4: Run it to verify it fails**

Run: `flutter test test/widget/friendlies_tablet_test.dart`
Expected: FAIL to compile (`FriendliesScreen.tabletLayoutKey` does not exist).

- [ ] **Step 5: The helpers move out of the State; the write waits for nobody**

In `lib/features/friendlies/friendlies_screen.dart`:

Add the imports `package:fnm/shared/tablet/tablet.dart` (sorted), and below the imports `part 'friendlies_tablet_layout.dart';`.

In `FriendliesScreen` add:

```dart
  static const Key tabletLayoutKey = Key('friendlies.tabletLayout');
  static const Key confirmKey = Key('friendlies.confirm');
```

Move `_monthAbbr`, `_label`, `_opponentsFor`, `_markedPerWindow` and `_reasonFor` out of `_FriendliesScreenState` to top-level private declarations directly above `class _WindowCard`, unchanged except that they are no longer members (`static const int _markedPerWindow = 3;` becomes `const int _markedPerWindow = 3;`; keep every doc comment). Their call sites in `build` do not change.

In `_FriendliesScreenState` add, directly below the two fields:

```dart
  /// Picks [nationId] for [window], or clears it when he is already the
  /// pick: a second tap on the same side leaves the window free.
  void _pick(DateTime window, int nationId) => setState(() {
    if (_picks[window] == nationId) {
      _picks.remove(window);
    } else {
      _picks[window] = nationId;
    }
  });
```

and in the phone's `_WindowCard(...)` replace

```dart
                        onPick: (id) => setState(() {
                          final w = plan.windows[i];
                          if (_picks[w] == id) {
                            _picks.remove(w);
                          } else {
                            _picks[w] = id;
                          }
                        }),
```

with

```dart
                        onPick: (id) => _pick(plan.windows[i], id),
```

Replace `_confirm` with:

```dart
  Future<void> _confirm(FriendliesPlan plan) async {
    setState(() => _saving = true);
    // Taken before the await: on a tablet the sidebar is always there, and
    // a resize swaps the layout under this State; the games are saved
    // whatever happens, and only a manager still on this page is taken on
    // to the hub. `router.state` is the top-most route, pushed ones too.
    final router = GoRouter.of(context);
    final careerId = widget.careerId;
    await ref
        .read(friendliesServiceProvider)
        .arrange(
          careerId,
          nationId: plan.playerNationId,
          cycle: plan.cycle,
          picks: _picks,
          allWindows: plan.windows,
        );
    if (router.state.uri.path == Routes.friendlies) {
      router.go('${Routes.hub}?careerId=$careerId');
    }
  }
```

At the top of `build`, before `final async = ...`, add:

```dart
    if (TabletShellScope.isActive(context)) {
      return _FriendliesTabletLayout(state: this);
    }
```

- [ ] **Step 6: The layout**

Create `lib/features/friendlies/friendlies_tablet_layout.dart`:

```dart
part of 'friendlies_screen.dart';

/// Arranging friendlies on a tablet: what is being arranged and why the
/// marked sides are marked, the game picked for each window and Confirm on
/// the left; every open window's card (the phone's, with its opponents)
/// beside them. The picks and the write are the screen State's
/// (`_picks`, [_FriendliesScreenState._confirm]), so a resize keeps them.
class _FriendliesTabletLayout extends ConsumerWidget {
  const _FriendliesTabletLayout({required this.state});

  final _FriendliesScreenState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final careerId = state.widget.careerId;
    final async = ref.watch(friendliesPlanProvider(careerId));
    return TabletPage(
      scaffoldKey: FriendliesScreen.tabletLayoutKey,
      title: l.hubEventArrangeFriendlies,
      onBack: () => context.go('${Routes.hub}?careerId=$careerId'),
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l.friendliesLoadError(e.toString()))),
        data: (plan) {
          if (plan == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: PrimaryButton(
                  label: l.friendliesContinue,
                  icon: Icons.check_rounded,
                  onPressed: () =>
                      context.go('${Routes.hub}?careerId=$careerId'),
                ),
              ),
            );
          }
          final picks = state._picks;
          Widget card(int i) {
            final window = plan.windows[i];
            final offered = _opponentsFor(
              plan.opponents,
              i,
              plan.windows.length,
            );
            return _WindowCard(
              label: _label(l, window),
              home: friendlyIsHome(window),
              opponents: offered,
              // The head of this window's own deal: the sides the line on
              // the left is talking about.
              marked: offered.take(_markedPerWindow).map((n) => n.id).toSet(),
              selected: picks[window],
              code: (id) => plan.nations[id]?.code ?? '??',
              name: (id) => plan.nations[id]?.name ?? l.hubUnknown,
              onPick: (id) => state._pick(window, id),
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l.friendliesArrangeIntro(plan.windows.length),
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Icon(
                            Icons.lightbulb_outline_rounded,
                            size: 14,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(
                            _reasonFor(l, plan),
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Expanded(
                      child: Panel(
                        title: l.friendliesYourGames,
                        expand: true,
                        padding: EdgeInsets.zero,
                        child: ListView(
                          padding: const EdgeInsets.all(12),
                          children: [
                            for (final w in plan.windows)
                              _PickLine(
                                label: _label(l, w),
                                home: friendlyIsHome(w),
                                pick: picks[w] == null
                                    ? null
                                    : plan.nations[picks[w]],
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    PrimaryButton(
                      key: FriendliesScreen.confirmKey,
                      label: picks.isEmpty
                          ? l.friendliesNoneThisWindow
                          : l.friendliesConfirmCount(picks.length),
                      icon: Icons.check_rounded,
                      onPressed: state._saving
                          ? null
                          : () => unawaited(state._confirm(plan)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: SingleChildScrollView(
                  child: ColumnFlow(
                    minTileWidth: 260,
                    maxColumns: 2,
                    children: [
                      for (var i = 0; i < plan.windows.length; i++) card(i),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// One window in the picks panel: when, home or away, and who (or free).
class _PickLine extends StatelessWidget {
  const _PickLine({
    required this.label,
    required this.home,
    required this.pick,
  });

  final String label;
  final bool home;
  final Nation? pick;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final nation = pick;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            child: Text(label, style: AppTypography.labelMedium),
          ),
          _VenueBadge(home: home),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: nation == null
                  ? Text(
                      l.friendliesFree,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FlagDisc(nation.code, size: 18, highlighted: true),
                        const SizedBox(width: AppSpacing.xs),
                        Flexible(
                          child: Text(
                            nation.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 7: Register, run, expect PASS**

Add `Routes.friendlies,` to `tabletReadyPaths` in `lib/features/shell/tablet_shell.dart`.

Run: `flutter test test/widget/friendlies_tablet_test.dart test/golden/phone_guard_friendlies_test.dart test/widget/tablet_route_sweep_test.dart test/widget/competition_refresh_after_step_test.dart`
Expected: PASS, phone goldens unchanged.

- [ ] **Step 8: Analyze, full suite, commit**

Run: `flutter analyze && flutter test`

```bash
git add lib/features/friendlies/friendlies_screen.dart lib/features/friendlies/friendlies_tablet_layout.dart lib/features/shell/tablet_shell.dart test/widget/friendlies_tablet_test.dart
git commit -m "feat(tablet): friendlies, the picks beside every window's card

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 10: The player's page in two columns

**risk: low (batched review)**. Read-only.

`PlayerView` (the detail pane of every stage 2 to 5 grid, and the phone page's body) stays one column. Its sections are moved, unchanged, into `_playerSections`, which returns them as two runs: who he is, and what he has done. `PlayerView` shows them one after the other, exactly as before; the tablet page shows them side by side.

**Files:**
- Create: `lib/features/player/player_tablet_layout.dart` (part of `player_detail_screen.dart`)
- Modify: `lib/features/player/player_detail_screen.dart`, `lib/features/shell/tablet_shell.dart`
- Test: `test/golden/phone_guard_player_tall_test.dart` (new, with golden), `test/widget/player_tablet_test.dart` (new)

**Interfaces:**
- Produces: `PlayerDetailScreen.tabletLayoutKey`, `PlayerDetailScreen.profileKey`, `PlayerDetailScreen.recordKey`; private `({List<Widget> profile, List<Widget> record}) _playerSections(BuildContext, _PlayerView, Player, int careerId)`; `_clubFact` and `_fact` become top-level private functions (unchanged bodies); `_PlayerTabletLayout`.
- Consumes: `_playerDetailProvider` (the phone's read), `TabletPage`, `TabletShellScope`, `l.playerPageTitle`, `l.playerAttributes`, `l.playerCareerRecord`.

- [ ] **Step 1: Pin the whole phone player page**

`test/golden/phone_guard_player_test.dart` already pins the first screenful (`player_phone.png`); it is not touched. Create `test/golden/phone_guard_player_tall_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/career/career_providers.dart';

import '../helpers/seeded_save.dart';

/// The whole phone player page in a tall window, pinned before the card's
/// sections are split into two runs for the tablet page.
void main() {
  testWidgets('player_phone_tall', (tester) async {
    final save = await seedSave(tester);
    late int playerId;
    await tester.runAsync(() async {
      final pool = await save.container
          .read(playerRepositoryProvider)
          .byNation(
            save.nationId,
            agingYears: CareerService.agingYears(save.career),
            saveSeed: save.career.rngSeed,
          );
      playerId = pool.first.id;
    });
    await pumpRoute(
      tester,
      save,
      '${Routes.player}?careerId=${save.careerId}&playerId=$playerId',
      size: const Size(390, 2400),
    );
    expect(find.text(enL.playerCareerRecord), findsOneWidget);
    await expectAppGolden('goldens/player_phone_tall.png');
  });
}
```

- [ ] **Step 2: Create the baseline, confirm it holds, commit it**

```bash
flutter test --update-goldens test/golden/phone_guard_player_tall_test.dart
flutter test test/golden/phone_guard_player_tall_test.dart
git add test/golden/phone_guard_player_tall_test.dart test/golden/goldens/player_phone_tall.png
git commit -m "test(tablet): phone guard for the whole player page

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

- [ ] **Step 3: Write the failing tablet test**

Create `test/widget/player_tablet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/player/player_detail_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/seeded_save.dart';

Future<SeededSave> _open(WidgetTester tester, Size size) async {
  final save = await seedSave(tester, formFactor: FormFactor.tablet);
  late int playerId;
  await tester.runAsync(() async {
    final pool = await save.container
        .read(playerRepositoryProvider)
        .byNation(
          save.nationId,
          agingYears: CareerService.agingYears(save.career),
          saveSeed: save.career.rngSeed,
        );
    playerId = pool.first.id;
  });
  await pumpRoute(
    tester,
    save,
    '${Routes.player}?careerId=${save.careerId}&playerId=$playerId',
    size: size,
  );
  return save;
}

void main() {
  for (final size in kTabletSizes) {
    testWidgets('who he is left, what he has done right, $size', (
      tester,
    ) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(PlayerDetailScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      final profile = tester.getRect(find.byKey(PlayerDetailScreen.profileKey));
      final record = tester.getRect(find.byKey(PlayerDetailScreen.recordKey));
      expect(record.left, greaterThan(profile.right));
      expect(
        find.descendant(
          of: find.byKey(PlayerDetailScreen.profileKey),
          matching: find.text(enL.playerAttributes.toUpperCase()),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byKey(PlayerDetailScreen.recordKey),
          matching: find.text(enL.playerCareerRecord),
        ),
        findsOneWidget,
      );
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('back with nothing to pop goes to the hub', (tester) async {
    final save = await _open(tester, kTabletSize);
    await tester.tap(find.byKey(TabletScreenHeader.backKey));
    await settle(tester);
    final uri = save.container
        .read(routerProvider)
        .routeInformationProvider
        .value
        .uri;
    expect(uri.path, Routes.hub);
    expect(uri.queryParameters['careerId'], '${save.careerId}');
    await tester.pumpWidget(const SizedBox());
  });
}
```

- [ ] **Step 4: Run it to verify it fails**

Run: `flutter test test/widget/player_tablet_test.dart`
Expected: FAIL to compile (`PlayerDetailScreen.tabletLayoutKey` does not exist).

- [ ] **Step 5: Split the card's sections; hook in the layout**

In `lib/features/player/player_detail_screen.dart`:

Add the imports `package:fnm/core/routing/app_router.dart` and `package:fnm/shared/tablet/tablet.dart` (sorted), and below the imports `part 'player_tablet_layout.dart';`.

In `PlayerDetailScreen` add:

```dart
  static const Key tabletLayoutKey = Key('player.tabletLayout');
  static const Key profileKey = Key('player.profile');
  static const Key recordKey = Key('player.record');
```

and make the first lines of `PlayerDetailScreen.build`:

```dart
    if (TabletShellScope.isActive(context)) {
      return _PlayerTabletLayout(careerId: careerId, playerId: playerId);
    }
```

Replace the whole `PlayerView` class (from its doc comment `/// A player's whole card: ...` down to the class's closing `}` after `_fact`) with the following. The children of the old `ListView` are moved verbatim into `_playerSections` (the first run ends at `_TrophyCabinet`, the second starts at the `SizedBox` above the career record heading), and `_clubFact`/`_fact` become top-level functions with the same bodies:

```dart
/// A player's whole card: identity, abilities, traits, club, cabinet, career
/// record, form and match history. The body of [PlayerDetailScreen], on its
/// own so a tablet detail pane can show the same card beside a list.
///
/// Scrolls itself; give it a bounded height.
class PlayerView extends ConsumerWidget {
  const PlayerView({
    required this.careerId,
    required this.playerId,
    this.padding = const EdgeInsets.all(AppSpacing.marginMobile),
    super.key,
  });

  final int careerId;
  final int playerId;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final viewAsync = ref.watch(
      _playerDetailProvider((careerId: careerId, playerId: playerId)),
    );

    return viewAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(l.playerLoadError('$e'))),
      data: (view) {
        final p = view.player;
        if (p == null) return Center(child: Text(l.playerNotFound));
        final sections = _playerSections(context, view, p, careerId);
        return ListView(
          padding: padding,
          children: [...sections.profile, ...sections.record],
        );
      },
    );
  }
}

/// The player card in two runs: [profile] (who he is: the headline card,
/// abilities, traits, club facts, club history, cabinet) and [record] (what
/// he has done: the career record, recent form, every match). One column
/// shows them one after the other ([PlayerView]); the tablet's player page
/// shows them side by side. The sections are the card's own, moved here
/// unchanged.
({List<Widget> profile, List<Widget> record}) _playerSections(
  BuildContext context,
  _PlayerView view,
  Player p,
  int careerId,
) {
  final l = AppLocalizations.of(context);
  final a = p.attributes;

  // The four numbers that actually identify a footballer — how old he
  // is, where he plays, how often he's played and what he's produced —
  // read as headlines rather than as rows in a list of facts.
  final caps = view.stats?.caps ?? view.history.length;
  final goals = view.goals > (view.stats?.goals ?? 0)
      ? view.goals
      : (view.stats?.goals ?? 0);

  return (
    profile: [
      AppCard(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withValues(alpha: 0.10),
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                  child: Text(
                    '${p.overall}',
                    style: AppTypography.headlineLargeMobile.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.name, style: AppTypography.headlineMedium),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (view.nation != null)
                            FlagDisc(view.nation!.code, size: 18),
                          const SizedBox(width: AppSpacing.xs),
                          Flexible(
                            child: Text(
                              view.nation?.name ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                _HeadlineStat(value: '${p.age}', label: l.playerAge),
                _HeadlineStat(
                  value: p.position.label,
                  label: l.playerPosition,
                  accent: true,
                ),
                _HeadlineStat(value: '$caps', label: l.playerStatCaps),
                _HeadlineStat(value: '$goals', label: l.playerStatGoals),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: AppSpacing.sm),
      // Abilities as filled rings — three numbers on a bar chart all
      // look alike, three dials do not: a lopsided player reads as
      // lopsided at a glance.
      AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.playerAttributes.toUpperCase(),
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                for (final s in <(String, int)>[
                  (l.playerAttrPhysical, a.physical),
                  (l.playerAttrTechnical, a.technical),
                  (l.playerAttrStamina, a.stamina),
                ])
                  Expanded(
                    child: _AbilityRing(label: s.$1, value: s.$2),
                  ),
              ],
            ),
          ],
        ),
      ),
      // What this player is KNOWN for. A squad of twenty-three ratings
      // is forgettable; a hothead, an iron man and a big-game striker
      // are not — and each one changes how they should be used.
      if (PlayerTraits.of(p, saveSeed: view.saveSeed) case final traits
          when traits.isNotEmpty) ...[
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.playerTraitsTitle,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              for (final t in traits) _TraitRow(trait: t),
            ],
          ),
        ),
      ],
      const SizedBox(height: AppSpacing.sm),
      AppCard(
        child: Column(
          children: [
            _clubFact(p, l.playerClub),
            // How much football he is actually getting THERE. It used
            // to be a badge on the call-up row, where it appeared on
            // some players and not others and read as a warning the
            // game had raised about the man rather than a fact about
            // his season. Here every player has one, and it sits next
            // to the club it is about.
            _fact(
              l.playerClubRole,
              clubStandingLabel(
                l,
                ClubForm.standingFor(
                  playerId: p.id,
                  overall: p.overall,
                  age: p.age,
                  saveSeed: view.saveSeed,
                  windowIndex: ClubForm.windowIndexFor(view.asOf),
                ),
              ),
            ),
            _fact(l.playerPosition, positionName(l, p.position)),
            _fact(l.playerAge, '${p.age}'),
            // The scouted ceiling for prospects: the same read the
            // youth screens give (the estimate until he has played
            // enough to be known), so developing youth stays a gamble
            // and a better scout narrows it.
            if (p.age <= 21)
              _fact(
                l.playerPotential,
                _potentialStars(
                  p,
                  caps: view.stats?.caps ?? 0,
                  scout: view.scout,
                ),
              ),
            _fact(l.playerValue, PlayerDetailScreen.money(p.value)),
          ],
        ),
      ),
      ClubHistoryCard(careerId: careerId, playerId: p.id),
      _TrophyCabinet(careerId: careerId, playerId: p.id),
    ],
    record: [
      const SizedBox(height: AppSpacing.md),
      Text(
        l.playerCareerRecord,
        style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
      ),
      const SizedBox(height: AppSpacing.sm),
      if (view.stats case final s?)
        _CareerStatsCard(stats: s, goals: view.goals)
      else
        AppCard(child: _fact(l.playerInternationalGoals, '${view.goals}')),
      if (view.history.length >= 3) ...[
        const SizedBox(height: AppSpacing.md),
        Text(
          l.playerRecentForm,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          child: _FormSparkline(
            // Oldest → newest, capped to the last dozen games.
            ratings: [
              for (final m in view.history.take(12).toList().reversed) m.rating,
            ],
          ),
        ),
      ],
      if (view.history.isNotEmpty) ...[
        const SizedBox(height: AppSpacing.md),
        Text(
          l.playerMatchHistory,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (final m in view.history)
                _HistoryRow(
                  stat: m,
                  playerNationId: p.nationId,
                  nationsById: view.nationsById,
                ),
            ],
          ),
        ),
      ],
      const SizedBox(height: AppSpacing.xl),
    ],
  );
}

/// The club row, with the club's country flag beside its name, hard-aligned
/// to the right (the trailing group takes the remaining width and ends right).
Widget _clubFact(Player p, String clubLabel) => Padding(
  padding: const EdgeInsets.symmetric(vertical: 3),
  child: Row(
    children: [
      Text(
        clubLabel,
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),
      const SizedBox(width: AppSpacing.sm),
      Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (p.clubCountry.isNotEmpty) ...[
              FlagDisc(p.clubCountry, size: 18),
              const SizedBox(width: AppSpacing.sm),
            ],
            Flexible(
              child: Text(
                p.club,
                textAlign: TextAlign.end,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    ],
  ),
);

Widget _fact(String label, String value) => Padding(
  padding: const EdgeInsets.symmetric(vertical: 3),
  child: Row(
    children: [
      Text(
        label.toUpperCase(),
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),
      // Takes the rest of the row and keeps the value at its right edge,
      // where the Spacer put it; a narrow pane (the tablet squad's)
      // ellipsises the value instead of overflowing.
      Expanded(
        child: Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodyMedium,
          ),
        ),
      ),
    ],
  ),
);
```

Run `dart format lib/features/player/player_detail_screen.dart` after the move.

- [ ] **Step 6: The layout**

Create `lib/features/player/player_tablet_layout.dart`:

```dart
part of 'player_detail_screen.dart';

/// A player's page on a tablet: who he is (the headline card, abilities,
/// traits, club, club history, cabinet) on the left; what he has done (the
/// career record, recent form, every match) on the right. The card's own
/// sections and read ([_playerSections], `_playerDetailProvider`), side by
/// side. The detail pane beside a grid keeps the one-column [PlayerView].
class _PlayerTabletLayout extends ConsumerWidget {
  const _PlayerTabletLayout({required this.careerId, required this.playerId});

  final int careerId;
  final int playerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final viewAsync = ref.watch(
      _playerDetailProvider((careerId: careerId, playerId: playerId)),
    );
    return TabletPage(
      scaffoldKey: PlayerDetailScreen.tabletLayoutKey,
      title: l.playerPageTitle,
      onBack: () => context.canPop()
          ? context.pop()
          : context.go('${Routes.hub}?careerId=$careerId'),
      child: viewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.playerLoadError('$e'))),
        data: (view) {
          final p = view.player;
          if (p == null) return Center(child: Text(l.playerNotFound));
          final sections = _playerSections(context, view, p, careerId);
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 5,
                child: ListView(
                  key: PlayerDetailScreen.profileKey,
                  children: sections.profile,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                flex: 6,
                child: ListView(
                  key: PlayerDetailScreen.recordKey,
                  children: sections.record,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
```

- [ ] **Step 7: Register, run, expect PASS**

Add `Routes.player,` to `tabletReadyPaths` in `lib/features/shell/tablet_shell.dart`.

Run: `flutter test test/widget/player_tablet_test.dart test/golden/phone_guard_player_tall_test.dart test/golden/phone_guard_player_test.dart test/widget/squad_tablet_test.dart test/widget/records_tablet_test.dart test/widget/tablet_route_sweep_test.dart`
Expected: PASS, phone goldens unchanged (the panes in the squad and records tests still show the one-column card).

- [ ] **Step 8: Analyze, full suite, commit**

Run: `flutter analyze && flutter test`

```bash
git add lib/features/player/player_detail_screen.dart lib/features/player/player_tablet_layout.dart lib/features/shell/tablet_shell.dart test/widget/player_tablet_test.dart
git commit -m "feat(tablet): the player's page in two columns

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 11: The nation's page in two columns

**risk: low (batched review)**. Read-only.

`NationView` (the ranking's detail pane, and the phone page's body) stays one column. The tablet page lays the same sections out side by side: the header, the honours and the ranking history on the left; the record scorers and the titles on the right. The phone already has its guards (`test/golden/phone_guard_nation_vitrine_test.dart`: `nation_vitrine_phone` and `nation_vitrine_phone_tall`), created before `NationView` was extracted; they are this task's phone guard and must pass untouched.

**Files:**
- Create: `lib/features/nations/nation_vitrine_tablet_layout.dart` (part of `nation_vitrine_screen.dart`)
- Modify: `lib/features/nations/nation_vitrine_screen.dart`, `lib/features/shell/tablet_shell.dart`
- Test: `test/widget/nation_page_tablet_test.dart` (new)

**Interfaces:**
- Produces: `NationVitrineScreen.tabletLayoutKey`; `_sectionLabel(String)` becomes a top-level private function (was a `NationView` method, same body); `_NationVitrineTabletLayout`.
- Consumes: `nationVitrineProvider` (the phone's read), the phone's `_Header`, `_HonoursCard`, `_RankingHistoryCard`, `_TopScorersCard`, `_TitlesCard`, `TabletPage`, `TabletShellScope`, `l.nationPageTitle`, `l.nationsHonours`, `l.nationsRankingHistory`, `l.nationsTopScorers`, `l.nationsTitles`.

- [ ] **Step 1: Confirm the phone guard holds before the change**

Run: `flutter test test/golden/phone_guard_nation_vitrine_test.dart`
Expected: PASS (no new golden in this task; the existing two are the guard).

- [ ] **Step 2: Write the failing tablet test**

Create `test/widget/nation_page_tablet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/nations/nation_vitrine_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/seeded_save.dart';

Future<SeededSave> _open(WidgetTester tester, Size size) async {
  final save = await seedSave(tester, formFactor: FormFactor.tablet);
  await pumpRoute(
    tester,
    save,
    '${Routes.nationVitrine}?careerId=${save.careerId}'
    '&nationId=${save.nationId}',
    size: size,
  );
  return save;
}

void main() {
  for (final size in kTabletSizes) {
    testWidgets('honours and standing left, scorers right, $size', (
      tester,
    ) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(NationVitrineScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      final honours = tester.getRect(find.text(enL.nationsHonours));
      final history = tester.getRect(find.text(enL.nationsRankingHistory));
      final scorers = tester.getRect(find.text(enL.nationsTopScorers));
      expect(history.top, greaterThan(honours.top));
      expect(scorers.left, greaterThan(honours.right));
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('back with nothing to pop goes to the ranking, as on the '
      'phone', (tester) async {
    final save = await _open(tester, kTabletSize);
    await tester.tap(find.byKey(TabletScreenHeader.backKey));
    await settle(tester);
    expect(
      save.container
          .read(routerProvider)
          .routeInformationProvider
          .value
          .uri
          .path,
      Routes.ranking,
    );
    await tester.pumpWidget(const SizedBox());
  });
}
```

- [ ] **Step 3: Run it to verify it fails**

Run: `flutter test test/widget/nation_page_tablet_test.dart`
Expected: FAIL to compile (`NationVitrineScreen.tabletLayoutKey` does not exist).

- [ ] **Step 4: Hook in the layout**

In `lib/features/nations/nation_vitrine_screen.dart`:

Add the import `package:fnm/shared/tablet/tablet.dart` (sorted), and below the imports `part 'nation_vitrine_tablet_layout.dart';`.

In `NationVitrineScreen` add:

```dart
  static const Key tabletLayoutKey = Key('nationVitrine.tabletLayout');
```

and make the first lines of `NationVitrineScreen.build`:

```dart
    if (TabletShellScope.isActive(context)) {
      return _NationVitrineTabletLayout(careerId: careerId, nationId: nationId);
    }
```

Move `NationView`'s `_sectionLabel` method out of the class to a top-level private function directly below `NationView`, same body:

```dart
Widget _sectionLabel(String text) => Text(
  text,
  style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
);
```

Its call sites in `NationView.build` do not change.

- [ ] **Step 5: The layout**

Create `lib/features/nations/nation_vitrine_tablet_layout.dart`:

```dart
part of 'nation_vitrine_screen.dart';

/// A nation's page on a tablet: who it is, its honours and how its standing
/// has moved on the left; its record scorers and titles on the right. The
/// phone's sections and read (`nationVitrineProvider`), side by side; the
/// ranking's detail pane keeps the one-column [NationView].
class _NationVitrineTabletLayout extends ConsumerWidget {
  const _NationVitrineTabletLayout({
    required this.careerId,
    required this.nationId,
  });

  final int careerId;
  final int nationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(
      nationVitrineProvider((careerId: careerId, nationId: nationId)),
    );
    return TabletPage(
      scaffoldKey: NationVitrineScreen.tabletLayoutKey,
      title: l.nationPageTitle,
      onBack: () => context.canPop()
          ? context.pop()
          : context.go('${Routes.ranking}?careerId=$careerId'),
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l.nationsCouldNotLoad(e.toString()))),
        data: (v) {
          if (v == null) return Center(child: Text(l.nationsNoNation));
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    _Header(v),
                    const SizedBox(height: AppSpacing.md),
                    _sectionLabel(l.nationsHonours),
                    const SizedBox(height: AppSpacing.sm),
                    _HonoursCard(v),
                    const SizedBox(height: AppSpacing.md),
                    _sectionLabel(l.nationsRankingHistory),
                    const SizedBox(height: AppSpacing.sm),
                    _RankingHistoryCard(v),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: ListView(
                  children: [
                    _sectionLabel(l.nationsTopScorers),
                    const SizedBox(height: AppSpacing.sm),
                    _TopScorersCard(v),
                    if (v.titles.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.md),
                      _sectionLabel(l.nationsTitles),
                      const SizedBox(height: AppSpacing.sm),
                      _TitlesCard(v),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
```

- [ ] **Step 6: Register, run, expect PASS**

Add `Routes.nationVitrine,` to `tabletReadyPaths` in `lib/features/shell/tablet_shell.dart`.

Run: `flutter test test/widget/nation_page_tablet_test.dart test/golden/phone_guard_nation_vitrine_test.dart test/widget/world_ranking_tablet_test.dart test/widget/tablet_route_sweep_test.dart`
Expected: PASS, phone goldens unchanged.

- [ ] **Step 7: Analyze, full suite, commit**

Run: `flutter analyze && flutter test`

```bash
git add lib/features/nations/nation_vitrine_screen.dart lib/features/nations/nation_vitrine_tablet_layout.dart lib/features/shell/tablet_shell.dart test/widget/nation_page_tablet_test.dart
git commit -m "feat(tablet): the nation's page in two columns

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 12: The team records as grids beside the player; nothing in the shell is phone-framed

**risk: low (batched review)**. Read-only, but it converts the last phone-framed in-shell screen, so it also retires `test/widget/shell_frame_transition_test.dart` and adds the guard that replaces it. The batch reviewer checks both explicitly.

The phone's team records are a header card, the strength curve, the legacy strip, four segments (scorers, most games, ratings, the manager's career) and a list per segment. The tablet page is the record book's shape (stage 5): the legacy strip and the team's header and curve at the top, the four boards as tabs over sortable grids, and the picked player's card in the pane beside them.

**Files:**
- Create: `lib/features/stats/team_stats_tablet_layout.dart` (part of `team_stats_screen.dart`)
- Modify: `lib/features/stats/team_stats_screen.dart`, `lib/features/shell/tablet_shell.dart`, `test/helpers/team_fixtures.dart`, `test/widget/tablet_route_sweep_test.dart`
- Delete: `test/widget/shell_frame_transition_test.dart`
- Test: `test/golden/phone_guard_team_stats_test.dart` (gains a tall golden), `test/widget/team_stats_tablet_test.dart` (new)

**Interfaces:**
- Produces (`team_fixtures.dart`): `TeamStatsData fakeTeamStats()`, `Override fakeTeamStatsOverride()`.
- Produces: `TeamStatsScreen.tabletLayoutKey`; private `_TeamStatsTabletLayout`, `_BoardGrid`, `_RatingsGrid`.
- Consumes: `teamStatsProvider`, `TeamStatEntry`, `TeamRatingEntry`, `TeamStatsData` (Task 2), `teamOverallHistoryProvider`, `careerStatsProvider` (through the phone's `_TeamHeader` and `_CareerRecord`), `LegacyTiles`, `TeamOverallHistoryCard`, `DataGrid`, `GridColumn`, `GridColumnSet`, `MasterDetail`, `DetailPaneScope`, `DetailPaneController`, `DetailPaneHost`, `openPlayer`, `PlayerTarget`, `TabletTabBar`, `PanelBox`, `TabletPage`, `ActiveBadge`, `squadOf` (`history_fixtures.dart`), `realNationsById`, `showTab`.

- [ ] **Step 1: Pin the phone team records with records in them**

Append to `test/helpers/team_fixtures.dart` (add the imports `package:fnm/features/stats/stats_providers.dart` and `history_fixtures.dart`, sorted):

```dart
/// The manager's team records after a few cycles, drawn from his real
/// squad: ten scorers, ten most-capped (from further down the squad) and
/// eight best-rated, every second man still playing.
TeamStatsData fakeTeamStats() {
  final squad = squadOf(seededNationId);
  return (
    nation: realNationsById[seededNationId],
    scorers: [
      for (var i = 0; i < 10; i++) (playerId: squad[i].id, value: 30 - 2 * i),
    ],
    appearances: [
      for (var i = 0; i < 10; i++)
        (playerId: squad[i + 5].id, value: 90 - 5 * i),
    ],
    ratings: [
      for (var i = 0; i < 8; i++)
        (
          playerId: squad[i].id,
          apps: 20 - i,
          meanRating: 7.6 - i * 0.1,
          motms: 6 - i ~/ 2,
        ),
    ],
    names: {for (final p in squad.take(15)) p.id: p.name},
    active: {for (var i = 0; i < 15; i += 2) squad[i].id},
  );
}

Override fakeTeamStatsOverride() => teamStatsProvider(
  kSeededCareerId,
).overrideWith((ref) async => fakeTeamStats());
```

In `test/golden/phone_guard_team_stats_test.dart` add the imports `package:flutter/material.dart` and `../helpers/team_fixtures.dart`, and append inside `main()`:

```dart
  testWidgets('team_stats_phone_tall', (tester) async {
    final save = await seedSave(tester, overrides: [fakeTeamStatsOverride()]);
    await pumpRoute(
      tester,
      save,
      '${Routes.teamStats}?careerId=${save.careerId}',
      size: const Size(390, 2400),
    );
    expect(find.text(fakeTeamStats().names.values.first), findsWidgets);
    await expectAppGolden('goldens/team_stats_phone_tall.png');
  });
```

and change the file's doc comment to end "...: a fresh save, nothing scored yet; and the fake records, whole."

- [ ] **Step 2: Create the new baseline, confirm both hold, commit**

```bash
flutter test --update-goldens test/golden/phone_guard_team_stats_test.dart --plain-name team_stats_phone_tall
flutter test test/golden/phone_guard_team_stats_test.dart
git add test/helpers/team_fixtures.dart test/golden/phone_guard_team_stats_test.dart test/golden/goldens/team_stats_phone_tall.png
git commit -m "test(tablet): phone guard for the team records with records in them

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

`--plain-name` limits `--update-goldens` to the new test: `team_stats_phone.png` from Task 2 must NOT be regenerated. `git status` must show no change to it.

- [ ] **Step 3: Write the failing tablet test**

Create `test/widget/team_stats_tablet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/shell/detail_pane_host.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/stats/stats_providers.dart';
import 'package:fnm/features/stats/team_stats_screen.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/seeded_save.dart';
import '../helpers/team_fixtures.dart';

Future<SeededSave> _open(
  WidgetTester tester,
  Size size, {
  bool records = true,
}) async {
  final save = await seedSave(
    tester,
    formFactor: FormFactor.tablet,
    overrides: [if (records) fakeTeamStatsOverride()],
  );
  await pumpRoute(
    tester,
    save,
    '${Routes.teamStats}?careerId=${save.careerId}',
    size: size,
  );
  return save;
}

DetailTarget? _pane(WidgetTester tester) =>
    tester.widget<DetailPaneHost>(find.byType(DetailPaneHost)).target;

void main() {
  for (final size in kTabletSizes) {
    testWidgets('the boards as grids beside the player pane, $size', (
      tester,
    ) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(TeamStatsScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      final grid = find.byType(DataGrid<TeamStatEntry>);
      expect(grid, findsOneWidget);
      expect(
        tester.widget<DataGrid<TeamStatEntry>>(grid).rows,
        fakeTeamStats().scorers,
      );
      expect(
        tester.getRect(find.byType(DetailPaneHost)).left,
        greaterThan(tester.getRect(grid).right),
      );
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('a fresh save says so, as on the phone', (tester) async {
    await _open(tester, kTabletSize, records: false);
    expect(find.byKey(TeamStatsScreen.tabletLayoutKey), findsOneWidget);
    expect(find.text(enL.statsNoGoalsRecorded), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a row opens the player beside the grid', (tester) async {
    await _open(tester, kTabletSize);
    expect(_pane(tester), isNull);
    final first = fakeTeamStats().scorers.first;
    await tester.tap(find.text(fakeTeamStats().names[first.playerId]!).first);
    await settle(tester);
    expect(_pane(tester), PlayerTarget(first.playerId));
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('most games, ratings and the career are the other tabs', (
    tester,
  ) async {
    await _open(tester, kTabletSize);
    await showTab(tester, 1);
    expect(
      tester
          .widget<DataGrid<TeamStatEntry>>(find.byType(DataGrid<TeamStatEntry>))
          .rows,
      fakeTeamStats().appearances,
    );
    await showTab(tester, 2);
    await settle(tester);
    expect(
      tester
          .widget<DataGrid<TeamRatingEntry>>(
            find.byType(DataGrid<TeamRatingEntry>),
          )
          .rows,
      fakeTeamStats().ratings,
    );
    await showTab(tester, 3);
    await settle(tester);
    // A fresh save's own record: nothing played yet.
    expect(find.text(enL.statsNoData), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('back with nothing to pop goes to the Career page', (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    await tester.tap(find.byKey(TabletScreenHeader.backKey));
    await settle(tester);
    expect(
      save.container
          .read(routerProvider)
          .routeInformationProvider
          .value
          .uri
          .path,
      Routes.careers,
    );
    await tester.pumpWidget(const SizedBox());
  });
}
```

- [ ] **Step 4: Run it to verify it fails**

Run: `flutter test test/widget/team_stats_tablet_test.dart`
Expected: FAIL to compile (`TeamStatsScreen.tabletLayoutKey` does not exist).

- [ ] **Step 5: Hook in the layout**

In `lib/features/stats/team_stats_screen.dart`:

Add the imports `package:fnm/features/shell/detail_pane_host.dart` and `package:fnm/shared/tablet/tablet.dart` (sorted), and below the imports `part 'team_stats_tablet_layout.dart';`.

In `TeamStatsScreen` add:

```dart
  static const Key tabletLayoutKey = Key('teamStats.tabletLayout');
```

and make the first lines of `_TeamStatsScreenState.build`:

```dart
    if (TabletShellScope.isActive(context)) {
      return _TeamStatsTabletLayout(careerId: widget.careerId);
    }
```

The phone tree is not otherwise touched.

- [ ] **Step 6: The layout**

Create `lib/features/stats/team_stats_tablet_layout.dart`:

```dart
part of 'team_stats_screen.dart';

/// The team records on a tablet: the way to the record book, the legends,
/// the world's records and head to head in a strip at the top; the team, the
/// manager's record with it and its strength curve under that; the four
/// boards (scorers, most games, ratings, the manager's career) as tabs over
/// sortable grids; the picked player's card in the pane beside them. The
/// phone's reads and sections, laid out as the record book is.
class _TeamStatsTabletLayout extends ConsumerStatefulWidget {
  const _TeamStatsTabletLayout({required this.careerId});

  final int careerId;

  @override
  ConsumerState<_TeamStatsTabletLayout> createState() =>
      _TeamStatsTabletLayoutState();
}

class _TeamStatsTabletLayoutState
    extends ConsumerState<_TeamStatsTabletLayout> {
  final DetailPaneController _pane = DetailPaneController();

  @override
  void dispose() {
    _pane.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final careerId = widget.careerId;
    final async = ref.watch(teamStatsProvider(careerId));
    return TabletPage(
      scaffoldKey: TeamStatsScreen.tabletLayoutKey,
      title: l.careerTeamRecords,
      onBack: () => context.canPop()
          ? context.pop()
          : context.go('${Routes.careers}?careerId=$careerId'),
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l.statsCouldNotLoadStats(e.toString()))),
        data: (view) {
          if (view == null) return Center(child: Text(l.statsNoData));
          final history =
              ref.watch(teamOverallHistoryProvider(careerId)).valueOrNull ??
              const <TeamOverallPoint>[];
          return DetailPaneScope(
            controller: _pane,
            child: ListenableBuilder(
              listenable: _pane,
              builder: (context, _) {
                final selectedId = switch (_pane.value) {
                  PlayerTarget(:final playerId) => playerId,
                  _ => null,
                };
                return MasterDetail(
                  initialFraction: 0.6,
                  minFraction: 0.45,
                  maxFraction: 0.7,
                  minDetailWidth: 320,
                  master: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      LegacyTiles(
                        careerId: careerId,
                        includeRecordBook: true,
                        dense: true,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _TeamHeader(
                              careerId: careerId,
                              nation: view.nation,
                            ),
                          ),
                          // One year is not a curve: the card draws nothing
                          // until there are two.
                          if (history.length > 1) ...[
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: TeamOverallHistoryCard(
                                key: const Key('team-overall-history'),
                                history: history,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Expanded(
                        child: PanelBox(
                          child: DefaultTabController(
                            length: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TabletTabBar(
                                  tabs: [
                                    Tab(text: l.statsTopScorersShort),
                                    Tab(text: l.statsMostGames),
                                    Tab(text: l.statsBestRated),
                                    Tab(text: l.statsMyCareer),
                                  ],
                                ),
                                Expanded(
                                  child: TabBarView(
                                    children: [
                                      _BoardGrid(
                                        rows: view.scorers,
                                        view: view,
                                        valueLabel: l.playerStatGoals,
                                        careerId: careerId,
                                        selectedId: selectedId,
                                      ),
                                      _BoardGrid(
                                        rows: view.appearances,
                                        view: view,
                                        valueLabel: l.playerStatCaps,
                                        careerId: careerId,
                                        selectedId: selectedId,
                                      ),
                                      _RatingsGrid(
                                        view: view,
                                        careerId: careerId,
                                        selectedId: selectedId,
                                      ),
                                      _CareerRecord(careerId: careerId),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  detail: PanelBox(
                    child: DetailPaneHost(
                      careerId: careerId,
                      target: _pane.value,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

/// A scorers or most-games board as a table, in the records' order until
/// the manager sorts it. Still-active players wear the badge every all-time
/// chart uses. Empty, it says what the phone's list says.
class _BoardGrid extends StatelessWidget {
  const _BoardGrid({
    required this.rows,
    required this.view,
    required this.valueLabel,
    required this.careerId,
    required this.selectedId,
  });

  final List<TeamStatEntry> rows;
  final TeamStatsData view;

  /// The tally's column heading (Goals, Caps).
  final String valueLabel;
  final int careerId;
  final int? selectedId;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    if (rows.isEmpty) {
      return Center(
        child: Text(
          l.statsNoGoalsRecorded,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      );
    }
    return DataGrid<TeamStatEntry>(
      rows: rows,
      columnSets: [
        GridColumnSet<TeamStatEntry>(
          id: 'overview',
          label: l.gridViewOverview,
          columns: [
            GridColumn<TeamStatEntry>(
              id: 'rank',
              label: l.gridColRank,
              width: 64,
              sortKey: (r) => rows.indexOf(r),
              cell: (r) => Text(
                '${rows.indexOf(r) + 1}',
                style: TabletText.cellNumeric,
              ),
            ),
            GridColumn<TeamStatEntry>(
              id: 'player',
              label: l.gridColPlayer,
              flex: 3,
              sortKey: (r) => view.names[r.playerId] ?? '',
              cell: (r) => Text(view.names[r.playerId] ?? l.statsUnknown),
            ),
            GridColumn<TeamStatEntry>(
              id: 'value',
              label: valueLabel,
              width: 80,
              numeric: true,
              sortKey: (r) => r.value,
              cell: (r) => Text('${r.value}'),
            ),
            GridColumn<TeamStatEntry>(
              id: 'active',
              label: l.gridColActive,
              width: 84,
              sortKey: (r) => view.active.contains(r.playerId) ? 1 : 0,
              cell: (r) => view.active.contains(r.playerId)
                  ? const ActiveBadge()
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ],
      selected: rows.where((r) => r.playerId == selectedId).firstOrNull,
      onSelect: (r) =>
          openPlayer(context, careerId: careerId, playerId: r.playerId),
    );
  }
}

/// The ratings board as a table: caps, man-of-the-match awards and the
/// average rating, in the board's colours.
class _RatingsGrid extends StatelessWidget {
  const _RatingsGrid({
    required this.view,
    required this.careerId,
    required this.selectedId,
  });

  final TeamStatsData view;
  final int careerId;
  final int? selectedId;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final rows = view.ratings;
    if (rows.isEmpty) {
      return Center(
        child: Text(
          l.statsNoRatingsRecorded,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      );
    }
    return DataGrid<TeamRatingEntry>(
      rows: rows,
      columnSets: [
        GridColumnSet<TeamRatingEntry>(
          id: 'overview',
          label: l.gridViewOverview,
          columns: [
            GridColumn<TeamRatingEntry>(
              id: 'rank',
              label: l.gridColRank,
              width: 64,
              sortKey: (r) => rows.indexOf(r),
              cell: (r) => Text(
                '${rows.indexOf(r) + 1}',
                style: TabletText.cellNumeric,
              ),
            ),
            GridColumn<TeamRatingEntry>(
              id: 'player',
              label: l.gridColPlayer,
              flex: 3,
              sortKey: (r) => view.names[r.playerId] ?? '',
              cell: (r) => Text(view.names[r.playerId] ?? l.statsUnknown),
            ),
            GridColumn<TeamRatingEntry>(
              id: 'caps',
              label: l.playerStatCaps,
              width: 72,
              numeric: true,
              sortKey: (r) => r.apps,
              cell: (r) => Text('${r.apps}'),
            ),
            GridColumn<TeamRatingEntry>(
              id: 'motm',
              label: l.gridColMotm,
              width: 72,
              numeric: true,
              sortKey: (r) => r.motms,
              cell: (r) => Text('${r.motms}'),
            ),
            GridColumn<TeamRatingEntry>(
              id: 'avg',
              label: l.gridColAvg,
              width: 72,
              numeric: true,
              sortKey: (r) => r.meanRating,
              cell: (r) => Text(
                r.meanRating.toStringAsFixed(2),
                style: TabletText.cellNumeric.copyWith(
                  color: AppColors.ratingColor(r.meanRating),
                ),
              ),
            ),
          ],
        ),
      ],
      selected: rows.where((r) => r.playerId == selectedId).firstOrNull,
      onSelect: (r) =>
          openPlayer(context, careerId: careerId, playerId: r.playerId),
    );
  }
}
```

- [ ] **Step 7: Register; retire the transition test; guard the shell**

Add `Routes.teamStats,` to `tabletReadyPaths` in `lib/features/shell/tablet_shell.dart`.

Delete `test/widget/shell_frame_transition_test.dart`:

```bash
git rm test/widget/shell_frame_transition_test.dart
```

Its own comment says it used `/team-stats` "until it converts (then pick another)". There is no other to pick: with team stats converted, every in-shell route is tablet-ready, so the bug it guarded (a page framed by the CURRENT location while it transitions out) cannot happen in the app. `ShellPhoneFrame` and `_shellFramed` stay as the fallback for a future route, with their unit tests in `tablet_shell_test.dart`.

In `test/widget/tablet_route_sweep_test.dart`, directly after the `expect(extra.keys.toSet(), {...});` statement, add:

```dart
  // Stage 6 converted the last in-shell screen, and
  // shell_frame_transition_test (a tablet page leaving for a phone-framed
  // one) was retired with it. ShellPhoneFrame stays as the fallback for a
  // future route, but none may ship without a tablet layout: that is what
  // keeps the retired test's bug unreachable.
  expect(
    [
      for (final p in extra.keys)
        if (!tabletReadyPaths.contains(p)) p,
    ],
    isEmpty,
    reason: 'an in-shell route with no tablet layout',
  );
```

- [ ] **Step 8: Run, expect PASS**

Run: `flutter test test/widget/team_stats_tablet_test.dart test/golden/phone_guard_team_stats_test.dart test/widget/careers_tablet_test.dart test/widget/tablet_route_sweep_test.dart test/widget/tablet_shell_test.dart`
Expected: PASS, phone goldens unchanged.

- [ ] **Step 9: Analyze, full suite, commit**

Run: `flutter analyze && flutter test`

```bash
git add lib/features/stats/team_stats_screen.dart lib/features/stats/team_stats_tablet_layout.dart lib/features/shell/tablet_shell.dart test/widget/team_stats_tablet_test.dart test/widget/tablet_route_sweep_test.dart
git commit -m "feat(tablet): the team records as grids beside the player

The last phone-framed in-shell screen. shell_frame_transition_test is
retired with it (nothing is left to leave for); the shell sweep now fails
on any in-shell route without a tablet layout.

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 13: The diagnostics log across the screen

**risk: low (batched review)**. Copies to the clipboard and clears the on-device log, both through the phone's own code.

**Files:**
- Create: `lib/features/settings/diagnostics_tablet_layout.dart` (part of `diagnostics_screen.dart`)
- Modify: `lib/features/settings/diagnostics_screen.dart`, `lib/features/shell/tablet_shell.dart`
- Test: `test/golden/phone_guard_diagnostics_test.dart` (new, with goldens), `test/widget/diagnostics_tablet_test.dart` (new)

**Interfaces:**
- Produces: `DiagnosticsScreen` becomes a `ConsumerStatefulWidget` (still `const DiagnosticsScreen({Key? key})`) with `static const Key tabletLayoutKey`; `_DiagnosticsScreenState._copy(BuildContext, String)` and `_clear()` (the phone's two button handlers, moved); `_DiagnosticsTabletLayout`.
- Consumes: `AppLog.read`, `AppLog.clear`, `AppLog.debugUse` (tests), `Clipboard`, `useTabletLayout`, `TabletScreenHeader`, `PanelBox`, `l.settingsDiagnosticsTitle`, `l.diagnosticsCopy`, `l.diagnosticsClear`, `l.diagnosticsEmpty`, `l.diagnosticsCopied`.

- [ ] **Step 1: Pin the phone log, empty and full**

Create `test/golden/phone_guard_diagnostics_test.dart`:

```dart
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/diagnostics/app_log.dart';
import 'package:fnm/core/routing/app_router.dart';

import '../helpers/seeded_save.dart';

/// A log with a fixed timestamp, so the golden is the same every run.
const String _log = '--- 2026-10-01T09:30:00.000  [hub:advance]\n'
    'Bad state: an example failure\n'
    '#0      SeasonService.advance '
    '(package:fnm/features/hub/hub_providers.dart:1200:7)\n';

/// Points the log at a file holding [_log] for this test.
void useFixedLog() {
  final dir = Directory.systemTemp.createTempSync('fnm-diagnostics');
  final file = File('${dir.path}/diagnostics.log')..writeAsStringSync(_log);
  AppLog.debugUse(file);
  addTearDown(() {
    AppLog.debugUse(null);
    dir.deleteSync(recursive: true);
  });
}

/// The phone diagnostics, pinned before the tablet layout is added beside
/// them: nothing recorded, and a recorded failure.
void main() {
  testWidgets('diagnostics_empty_phone', (tester) async {
    AppLog.debugUse(null);
    final save = await seedSave(tester);
    await pumpRoute(tester, save, Routes.diagnostics);
    expect(find.text(enL.diagnosticsEmpty), findsOneWidget);
    await expectAppGolden('goldens/diagnostics_empty_phone.png');
  });

  testWidgets('diagnostics_log_phone', (tester) async {
    useFixedLog();
    final save = await seedSave(tester);
    await pumpRoute(tester, save, Routes.diagnostics);
    expect(find.text(enL.diagnosticsCopy), findsOneWidget);
    await expectAppGolden('goldens/diagnostics_log_phone.png');
  });
}
```

- [ ] **Step 2: Create the baseline, confirm it holds, commit it**

```bash
flutter test --update-goldens test/golden/phone_guard_diagnostics_test.dart
flutter test test/golden/phone_guard_diagnostics_test.dart
git add test/golden/phone_guard_diagnostics_test.dart test/golden/goldens/diagnostics_empty_phone.png test/golden/goldens/diagnostics_log_phone.png
git commit -m "test(tablet): phone guard for the diagnostics log

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

- [ ] **Step 3: Write the failing tablet test**

Create `test/widget/diagnostics_tablet_test.dart`:

```dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/diagnostics/app_log.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/settings/diagnostics_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/seeded_save.dart';

/// Points the log at a temporary file holding one failure; returns it.
File _logFile() {
  final dir = Directory.systemTemp.createTempSync('fnm-diagnostics');
  final file = File('${dir.path}/diagnostics.log')
    ..writeAsStringSync('--- [hub:advance]\nBad state: an example failure\n');
  AppLog.debugUse(file);
  addTearDown(() {
    AppLog.debugUse(null);
    dir.deleteSync(recursive: true);
  });
  return file;
}

Future<SeededSave> _open(WidgetTester tester, Size size) async {
  final save = await seedSave(tester, formFactor: FormFactor.tablet);
  await pumpRoute(tester, save, Routes.diagnostics, size: size);
  return save;
}

void main() {
  for (final size in kTabletSizes) {
    testWidgets('nothing recorded, $size', (tester) async {
      AppLog.debugUse(null);
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(DiagnosticsScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(FullScreenPhoneFrame), findsNothing);
      expect(find.text(enL.diagnosticsEmpty), findsOneWidget);
      expect(find.text(enL.diagnosticsClear), findsNothing);
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('the log across the screen, Copy and Clear in the heading', (
    tester,
  ) async {
    _logFile();
    await _open(tester, kTabletSize);
    expect(find.textContaining('an example failure'), findsOneWidget);
    final title = tester.getRect(find.text(enL.settingsDiagnosticsTitle));
    final clear = tester.getRect(find.text(enL.diagnosticsClear));
    expect(clear.left, greaterThan(title.right));
    expect((clear.center.dy - title.center.dy).abs(), lessThan(24));
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets("Clear empties the log, as the phone's does", (tester) async {
    final file = _logFile();
    await _open(tester, kTabletSize);
    expect(file.readAsStringSync(), isNotEmpty);
    await tester.tap(find.text(enL.diagnosticsClear));
    await settle(tester);
    expect(file.readAsStringSync(), isEmpty);
    expect(find.text(enL.diagnosticsEmpty), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('back with nothing to pop goes to settings', (tester) async {
    AppLog.debugUse(null);
    final save = await _open(tester, kTabletSize);
    await tester.tap(find.byKey(TabletScreenHeader.backKey));
    await settle(tester);
    expect(
      save.container
          .read(routerProvider)
          .routeInformationProvider
          .value
          .uri
          .path,
      Routes.settings,
    );
    await tester.pumpWidget(const SizedBox());
  });
}
```

- [ ] **Step 4: Run it to verify it fails**

Run: `flutter test test/widget/diagnostics_tablet_test.dart`
Expected: FAIL to compile (`DiagnosticsScreen.tabletLayoutKey` does not exist).

- [ ] **Step 5: The handlers move into the State; hook in the layout**

In `lib/features/settings/diagnostics_screen.dart`:

Add the imports `package:flutter_riverpod/flutter_riverpod.dart`, `package:fnm/core/layout/form_factor.dart` and `package:fnm/shared/tablet/tablet.dart` (sorted), and below the imports `part 'diagnostics_tablet_layout.dart';`.

Make the screen a `ConsumerStatefulWidget` (`useTabletLayout` needs a `WidgetRef`):

```dart
class DiagnosticsScreen extends ConsumerStatefulWidget {
  const DiagnosticsScreen({super.key});

  static const Key tabletLayoutKey = Key('diagnostics.tabletLayout');

  @override
  ConsumerState<DiagnosticsScreen> createState() => _DiagnosticsScreenState();
}

class _DiagnosticsScreenState extends ConsumerState<DiagnosticsScreen> {
```

(the class doc comment stays above `DiagnosticsScreen`; `_log` and `_reload` are unchanged). Add, directly below `_reload`:

```dart
  /// Copies [text] to the clipboard and says so.
  Future<void> _copy(BuildContext context, String text) async {
    final l = AppLocalizations.of(context);
    await Clipboard.setData(ClipboardData(text: text));
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l.diagnosticsCopied)));
  }

  /// Empties the log and reads it again.
  Future<void> _clear() async {
    await AppLog.clear();
    if (!mounted) return;
    _reload();
  }
```

At the top of `build`, before `final l = AppLocalizations.of(context);`, add:

```dart
    if (useTabletLayout(context, ref)) {
      return _DiagnosticsTabletLayout(state: this);
    }
```

In the phone tree replace the Copy button's

```dart
                          onPressed: () async {
                            await Clipboard.setData(ClipboardData(text: text));
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l.diagnosticsCopied)),
                            );
                          },
```

with

```dart
                          onPressed: () => _copy(context, text),
```

and the Clear button's

```dart
                          onPressed: () async {
                            await AppLog.clear();
                            _reload();
                          },
```

with

```dart
                          onPressed: _clear,
```

(The only behaviour change: `_clear` no longer calls `setState` on a page that was closed while the log was being cleared.)

- [ ] **Step 6: The layout**

Create `lib/features/settings/diagnostics_tablet_layout.dart`:

```dart
part of 'diagnostics_screen.dart';

/// The log on a landscape tablet: the heading with Copy and Clear beside it,
/// and the log in one panel across the screen, scrolling both ways (stack
/// traces are long lines and are never reflowed). The read, the copy and the
/// clear are the screen State's.
class _DiagnosticsTabletLayout extends StatelessWidget {
  const _DiagnosticsTabletLayout({required this.state});

  final _DiagnosticsScreenState state;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      key: DiagnosticsScreen.tabletLayoutKey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: FutureBuilder<String>(
            future: state._log,
            builder: (context, snapshot) {
              final text = snapshot.data?.trim() ?? '';
              final hasLog = text.isNotEmpty;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TabletScreenHeader(
                    title: l.settingsDiagnosticsTitle,
                    onBack: () => context.canPop()
                        ? context.pop()
                        : context.go(Routes.settings),
                    trailing: hasLog
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () => state._copy(context, text),
                                icon: const Icon(Icons.copy_rounded, size: 18),
                                label: Text(l.diagnosticsCopy),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              OutlinedButton.icon(
                                onPressed: state._clear,
                                icon: const Icon(
                                  Icons.delete_outline_rounded,
                                  size: 18,
                                ),
                                label: Text(l.diagnosticsClear),
                              ),
                            ],
                          )
                        : null,
                  ),
                  Expanded(
                    child: !snapshot.hasData
                        ? const Center(child: CircularProgressIndicator())
                        : !hasLog
                        ? Center(
                            child: Text(
                              l.diagnosticsEmpty,
                              textAlign: TextAlign.center,
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          )
                        : PanelBox(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SelectableText(
                                  text,
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 12,
                                    height: 1.35,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 7: Register, run, expect PASS**

Add `Routes.diagnostics,` to `tabletReadyPaths` in `lib/features/shell/tablet_shell.dart`.

Run: `flutter test test/widget/diagnostics_tablet_test.dart test/golden/phone_guard_diagnostics_test.dart test/widget/settings_tablet_test.dart test/widget/tablet_full_screen_sweep_test.dart`
Expected: PASS, phone goldens unchanged.

- [ ] **Step 8: Analyze, full suite, commit**

Run: `flutter analyze && flutter test`

```bash
git add lib/features/settings/diagnostics_screen.dart lib/features/settings/diagnostics_tablet_layout.dart lib/features/shell/tablet_shell.dart test/widget/diagnostics_tablet_test.dart
git commit -m "feat(tablet): the diagnostics log across the screen

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

Then the batched review of Tasks 1, 10, 11, 12 and 13 (see Review depth) before Task 14.

---

### Task 14: Record stage 6 in the spec, verify, simulator checks

**Files:**
- Modify: `docs/superpowers/specs/2026-10-09-tablet-ui-design.md`

- [ ] **Step 1: Add a section to the spec, after "Stage 5 adjustments"**

```markdown
## Stage 6 adjustments (2026-10-11)

- Stage 6 converted every route that was not tablet-ready except the
  dev-only style gallery: the nation pick, new game, start from the
  bottom, team records, cycle rollover, settings, friendlies, the player
  page, the nation page and diagnostics. After it, nothing in the shell is
  drawn at phone width; the gallery is the one route still in
  `FullScreenPhoneFrame`. The column picker, the collapsible sidebar,
  store screenshots, the iPad listing and the Android tablet check were
  dropped from this release, and with the column picker the persisted
  per-table view the "Out of scope" section mentions.
- The nation pick is the approved tile grid: a bar with back, the title,
  the search, Random team and From the bottom; confederation chips with
  counts; tiles with the world rank, a five-bar strength meter, the flag,
  the name and the best player's position and rating. A tap previews the
  nation in a pane (`NationPreview`); only "Manage <nation>" starts the
  new game. The preview is the screen State's, so a resize keeps it; the
  search and the confederation are the phone's providers.
- `NationPreview` shows only what exists before a career, as the save
  will see it: the world rank (the seed ranking), the strength (which
  fifth of the world the squad overall falls in), the squad overall (the
  seed-free pool the world simulation uses; a save's own pool feels club
  minutes, within 2 on the seeded save), the opening budget
  (`FederationFinance.initialBudget`, what a new save stores), the best
  player's position, age and rating, and the first cycle's World
  Championship and continental briefs (`openingObjectiveTargets`, the
  targets the board then sets). No player name: every save names its
  players afresh. The Nations Cup brief is left to the board screen.
- New game puts the name form beside that preview; out of work puts the
  three offers side by side, each a preview over its Take it. The offers
  are the screen State's draw, so a resize keeps them;
  `UnemployedStartScreen.debugSeed` pins the draw in tests only.
- The cycle rollover keeps its three steps, each in two columns, with the
  phone's "Back to your saves" on every step. It needs no cascade (a
  full-screen route: the shell is torn down while it runs, and the roll
  invalidates the hub's data itself); it refreshes the inbox through a
  captured container and goes to the hub only for a manager still on it.
- Settings are two columns of the phone's cards (now one widget each);
  the backup export keeps its share anchor. Diagnostics put the log
  across the screen with Copy and Clear in the heading.
- Friendlies: the picks and Confirm beside every window's card; the picks
  are the State's. The team records are the record book's shape (tabs
  over sortable grids beside the player pane). The player and nation pages
  are two columns; their detail panes keep one.
- There is no `TeamStatsView`: nothing opens the team records beside a
  list.
- The sim's cascade also refreshes the team records (`teamStatsProvider`,
  moved to `stats_providers.dart`), the friendlies plan (the hub's next
  event reads the same plan), and the player card's club history and
  cabinet (`invalidatePlayerDetails`).
- New game, the rollover and friendlies take the router before their
  write and navigate after it only if the manager is still on that page.
- `shell_frame_transition_test` was retired when team stats converted:
  no phone-framed in-shell page is left to leave for. The shell sweep
  fails on any in-shell route without a tablet layout instead.
- German and Spanish need the 15 stage 6 keys when they merge (values in
  the stage 6 plan, Task 1).
```

- [ ] **Step 2: Full verification**

```bash
flutter analyze
flutter test
```

Expected: no new analyzer issues against the commit this stage started from (infos allowed only where they already existed); the FINAL summary line of `flutter test` reads "All tests passed!" with no `-N` failures. Paste that line into the task report. Every `test/golden/phone_guard_*` golden passes WITHOUT `--update-goldens`; `git status` shows no changed PNG. `tabletReadyPaths` holds every route but `Routes.gallery`:

```bash
grep -c "^  Routes\." lib/features/shell/tablet_shell.dart
```

Expected: 51 (the 41 before this stage and the 10 it adds); check by eye that `Routes.gallery` is not among them.

- [ ] **Step 3: Commit the spec**

```bash
git add docs/superpowers/specs/2026-10-09-tablet-ui-design.md
git commit -m "docs: record tablet stage 6 adjustments in the spec

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

- [ ] **Step 4: iPad simulator: build, install in place, screenshot**

```bash
xcrun simctl list devices available | grep -i ipad
xcrun simctl boot "iPad Pro 11-inch (M5)" 2>/dev/null || true
open -a Simulator
flutter build ios --simulator --debug
xcrun simctl install booted build/ios/iphonesimulator/Runner.app
xcrun simctl launch booted com.fnm.fnm
```

`simctl install` over an installed app upgrades it in place and keeps its saves; never `simctl uninstall`. Then take one screenshot per screen and attach their paths to the report:

```bash
mkdir -p /tmp/fnm-stage6
xcrun simctl io booted screenshot /tmp/fnm-stage6/nations.png
```

(repeat after navigating: `nations_preview.png` (a tile tapped), `new_game.png`, `bottom.png`, `settings.png`, `diagnostics.png`, and with a save open `team_stats.png`, `player.png`, `nation.png`, `friendlies.png` (when friendlies are due) and `rollover.png` (if a save at the end of a cycle is to hand)). Read each PNG back and check it against this plan's layouts: panes side by side, nothing clipped at the panel edges, no phone-width frame anywhere but the gallery.

- [ ] **Step 5: Manual checklist (the user drives the simulator)**

Ask the user to do each of these and report back; note each result in the task report:

1. **Nation pick.** Home, New game: the tiles, Europe lit, the best-ranked European side open on the right. Tap another tile: the pane changes and nothing else happens. Tap a chip: its nations, its count in the line above. Search "ger": matches from every continent. Random team and From the bottom go where they always went. Manage <nation> opens the new game.
2. **The preview's numbers.** Manage a nation, name the manager, start: the hub's budget is the preview's opening budget, and the board objectives screen's World Championship and continental briefs are the ones the preview promised.
3. **New game and out of work.** The name form beside the preview; Start career opens the hub. From the bottom: three offers side by side; Take it names the manager.
4. **Resize.** On the nation pick with a tile previewed, on the new game with a half-typed name, and on the out-of-work offers, narrow the window below the tablet width (Stage Manager or split view) and widen it again: the same nation, the same name, the same three offers.
5. **Settings and diagnostics.** Settings from home and from the sidebar: two columns; flip sound, change the language (the dialog closes), export a backup (the popover points at the button). Diagnostics: the log across the screen; Copy, Clear.
6. **Team records, player, nation.** Career, Team records: the boards as tabs, a player's card beside them; back returns to Career. Open a player's full profile: two columns. Open a nation from the ranking's pane, Full profile: two columns.
7. **Friendlies.** When the hub offers "Arrange friendlies": the picks beside the windows; pick one, Confirm, the hub.
8. **Continue under team records.** With Team records open, press the top bar's Continue until a match is played: the boards update without leaving the screen.

- [ ] **Step 6: Phone sanity check**

Run the app on an iPhone simulator (`flutter run -d <iPhone simulator id>`; a simulator, so `flutter run` upgrading in place is fine). Nation pick (search, a chip, Random team, From the bottom), new game, out of work, settings (sound, language, export), diagnostics, friendlies, team records, a player page, a nation page and, if a save at the end of a cycle is to hand, the rollover look and behave exactly as before.
