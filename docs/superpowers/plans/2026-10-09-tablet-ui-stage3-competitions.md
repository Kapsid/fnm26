# Tablet UI, Stage 3: Competitions. Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Every competition screen has a tablet layout: Tournaments (competition list left, the picked competition's tabs right), World Championship, continental and Nations Cup detail (group tables in a grid, the bracket full width), the Continental Clash, the intercontinental play-off, the world ranking (sortable grid with the nation in a detail pane), results (cycles beside their matches), every draw ceremony (a landscape stage: pots left, groups filling the right) and the tournament kickoff. Competition screens stay correct while the tablet's top-bar Continue runs the sim underneath them.

**Architecture:** Same pattern as stage 2. Each screen keeps its providers and State and picks a layout at the top of `build`: in-shell screens by `TabletShellScope.isActive(context)`, full-screen routes by `useTabletLayout(context, ref)`. Tablet layouts live in `part` files beside their screen. The four tabbed detail screens get a public `*View` (`CupDetailView`, `ContinentalDetailView`, `NationsCupView`, `ContinentalClashView`: a tab bar over the tab bodies, no Scaffold) that both their own tablet page and the Tournaments right pane render; the tab bodies are moved into shared functions the phone tree calls in the same places, so the phone is pixel-identical (tall goldens prove it). `NationView` is extracted from the nation vitrine and hosted by `DetailPaneHost` (`NationTarget`). `DrawCeremony` chooses its landscape layout INSIDE its own State, so a window crossing 1000 keeps the draw where it was. Every converted path joins `tabletReadyPaths`; the route sweep runs at all three iPad sizes and now also sweeps the full-screen routes.

**Tech Stack:** Flutter, flutter_riverpod 2.6 (manual providers, no codegen), go_router 17, gen_l10n (5 ARB locales on this branch: en cs fr it pl), flutter_test golden files for the phone guards.

**Spec:** `docs/superpowers/specs/2026-10-09-tablet-ui-design.md` (stage 3 = "Competitions"; read the Screen layouts table and the "Stage 1 adjustments" and "Stage 2 adjustments" sections, which this plan follows).

**Stage 2 plan (format and conventions):** `docs/superpowers/plans/2026-10-09-tablet-ui-stage2-core-loop.md`. Where it and the code differ, the code is the source of truth: `kTabletLayoutMinWidth` (1000), per-page framing (`ShellPhoneFrame` in `_tabletRoutes`, `FullScreenPhoneFrame` for full-screen routes), `PanelBox` is a `Material`, `DataGrid` scrolls sideways when its columns do not fit, `MasterDetail.minDetailWidth`, `sheetIsDialog`, and the seeded-save harness (`seedSave`, `pumpRoute`, `settle`, `expectAppGolden`).

## Global Constraints

- Phones keep the current UI exactly. Nothing in the phone path changes behaviour. Every converted screen gets a phone guard golden BEFORE it is touched (a tall one, 390 wide, when the screen scrolls), and that golden must pass unchanged after.
- Tablet = `shortestSide >= 600` logical px. Landscape only. Tablet layouts need a window at least `kTabletLayoutMinWidth` (1000) wide; narrower tablet windows get the phone app.
- In-shell screens pick their tablet layout with `TabletShellScope.isActive(context)`. Full-screen routes pick it with `useTabletLayout(context, ref)`, never `context.isTabletWindow` alone (the default test window, 800 x 600, is tablet sized).
- A screen whose tablet layout uses the whole content area (in the shell) or the whole screen (full-screen route) is added to `tabletReadyPaths`. A screen that asks `TabletShellScope.isActive` but is NOT in `tabletReadyPaths` would draw its tablet layout inside a 600 phone frame: register in the same commit as the layout.
- Every tablet layout is tested at 1194 x 834, 1080 x 810 and 1024 x 768 (`kTabletSizes`, Task 1): no exception, the layout's key present, no phone frame. The route sweep stays green after every task.
- Release target: v1.0.4 on both iOS and Android. Do not bump `pubspec.yaml` in this stage.
- No `@riverpod` codegen; providers by hand. No change to game logic or the database schema. Task 4 moves three providers into their own files (renamed public, bodies verbatim) and adds invalidations to the sim's cascade; nothing else changes a provider.
- Derived providers go stale after a sim step. On a tablet the top bar's Continue runs the sim while ANY in-shell screen is on show, so every competition screen's provider is invalidated by the sim cascade (Task 4). A new tablet layout may only watch providers that cascade refreshes or that the phone already watches on the same screen.
- Draw ceremonies read stored groups; nothing here re-runs or re-derives a draw. The tablet ceremony is fed the exact `groups` list the phone ceremony is. Every continental, Nations Cup or kickoff lookup names its confederation.
- If any `build_runner` step is needed, run it with `--force-jit`. (Nothing in this plan should need it.)
- All new user-facing strings go into all 5 ARB files (`en cs fr it pl`), then `flutter gen-l10n`, then `dart run tool/export_copy.dart` so `copy/strings.csv` stays in sync. German and Spanish ARB files are not on this branch; the 9 new keys of Task 3 must be added to them when that work merges (values listed in Task 3). Prefer existing keys; reused keys are named in each task.
- No em dashes in user-facing copy. Never "World Cup" in English copy (it is "World Championship").
- Sheets: inside a sheet builder pop with the sheet's own context, and pop BEFORE navigating from sheet content (`showAdaptiveSheet`, `sheetIsDialog`).
- Never push a shell route from a top-level (full-screen) route; leave a full-screen route with `go`. The draw ceremonies, the kickoff and their tablet layouts already do.
- Never run `flutter install` against a physical device. Simulators only in this stage; a simulator build is installed in place with `xcrun simctl install`, never uninstalled first.
- Commit messages end with `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`.
- Run tests with `flutter test` from the repo root. Golden baselines are created ONLY in the "create the baseline" step of a task (`flutter test --update-goldens <file>`), before the screen is changed, and committed in that step. Never update a golden to make a later step pass; a changed phone golden is a phone regression.
- `settle` fails loudly from Task 1 on: a screen still showing a `CircularProgressIndicator` when the cap runs out fails the test unless the call passes `allowSpinner: true` with a comment saying why the spinner is the screen's content.

## Review depth

User-approved: low-risk read-only display screens get ONE combined review per stage; logic, navigation, shared code and full-screen event screens are reviewed per task. Each task is tagged:

- **risk: high (per-task review)**: Tasks 1, 2, 4, 5, 12, 13, 14, 15, 16, 17, 18.
- **risk: low (batched review)**: Tasks 3, 6, 7, 8, 9, 10, 11. Review them together once Task 11 lands: one reviewer, given the list of those tasks' commit SHAs from the ledger, before Task 13 (which builds on Tasks 8 to 11) starts.

## Review Focus

1. **A ceremony that is not the stored draw.** The tablet stage is a second layout of the same ceremony, and the easiest mistake is to feed it something re-derived (from pots, from a re-run schedule) instead of the stored groups the phone gets. Pinned in Task 14: on a seeded save the landscape qualifying ceremony's groups equal `tournamentGroupTables(..., continentalQualifying, confederation: mine)` group for group, nation for nation.
2. **A resize that restarts the draw.** iPadOS windows resize; a ceremony that swaps widgets above its State on crossing 1000 starts the draw again (and could fire its mark-watched twice). Pinned in Task 14: two balls pulled on the landscape stage, the window shrunk to 700 x 810 and grown back: the same `DrawCeremonyState` object, still on 2 revealed, and the layout follows the window.
3. **Stale competition screens under the top bar's Continue.** On a phone these screens are never on show while the sim runs. On a tablet they are, and their auto-disposed providers are kept alive by being watched. Pinned in Task 4: with a listener on each competition provider, one `SeasonService.advance` hands every one of them a new future.
4. **The wrong confederation in a pane.** The Tournaments list opens other confederations' cups in its right pane; a view that falls back to the manager's own confederation (a null `conf`, a default) shows the wrong cup under the right heading. Pinned in Task 13: picking the Asian Championship row puts `ContinentalDetailView(confederation: asia)` in the pane, and the African Nations Cup row `NationsCupView(confederation: africa)`.
5. **Phone drift from the moved tab bodies.** Tasks 8 to 11 move each detail screen's tab bodies (and Task 2 the bracket's columns) into shared code. Any change to what a phone draws is a regression. Pinned by tall phone goldens of the bracket, qualifying and finals tabs (Task 8), the continental qualifying tab (Task 9), the Nations Cup leagues (Task 10), the Clash (Task 11), each created before its screen is touched, and by `tournament_bracket_test`'s phone case (Task 2).

---

## File structure

**Create**
- `lib/shared/tablet/column_flow.dart`: `ColumnFlow` (tiles in as many equal columns as fit).
- `lib/shared/tablet/screen_header.dart`: `TabletScreenHeader` (back arrow, title, trailing action).
- `lib/features/tournaments/nations_cup_providers.dart`: `NationsCupData`, `NationsCupKey`, `nationsCupProvider` (moved out of the screen, renamed public).
- `lib/features/tournaments/continental_clash_providers.dart`: `ContinentalClashData`, `continentalClashProvider` (moved, renamed public).
- `lib/features/tournaments/intercontinental_playoff_providers.dart`: `PlayoffView`, `intercontinentalPlayoffProvider` (moved).
- `lib/features/ranking/world_ranking_tablet_layout.dart` (part of `world_ranking_screen.dart`): `_WorldRankingTabletLayout`, `rankingColumnSets`.
- `lib/features/results/results_tablet_layout.dart` (part of `results_screen.dart`): `_ResultsTabletLayout`, `_CycleListRow`, `_TabletResultRow`.
- `lib/features/tournaments/cup_detail_view.dart` (part of `cup_detail_screen.dart`): `CupDetailView`, `_CupDetailTabletLayout`.
- `lib/features/tournaments/continental_detail_view.dart` (part of `continental_detail_screen.dart`): `ContinentalDetailView`, `_ContinentalDetailTabletLayout`.
- `lib/features/tournaments/nations_cup_view.dart` (part of `nations_cup_screen.dart`): `NationsCupView`, `_NationsCupTabletLayout`.
- `lib/features/tournaments/continental_clash_view.dart` (part of `continental_clash_screen.dart`): `ContinentalClashView`, `_ContinentalClashTabletLayout`.
- `lib/features/tournaments/intercontinental_playoff_tablet_layout.dart` (part of `intercontinental_playoff_screen.dart`).
- `lib/features/tournaments/tournaments_tablet_layout.dart` (part of `tournaments_screen.dart`): `_TournamentsTabletLayout`, `_CompetitionListRow`, `_RankingListRow`, `_StatusChip`.
- `test/helpers/competition_fixtures.dart`: fake competition data on the real nations.
- `test/golden/phone_guard_*_test.dart` and `test/golden/goldens/*.png`: one guard per screen family.
- Tests listed per task.

**Modify**
- `test/helpers/seeded_save.dart`: loud `settle`, `kTabletSizes`, `kSeededCareerId`, `seededNationId`, `realNations`, `watchContinentalQualifyingDraw`.
- `test/widget/tablet_route_sweep_test.dart`: three sizes, full-screen sweep.
- `lib/shared/tablet/data_grid.dart` (`controller`), `detail_pane.dart` (`NationTarget`), `tablet.dart` (barrel).
- `lib/features/shell/detail_pane_host.dart` (`NationTarget`, `openNation`), `tablet_shell.dart` (`tabletReadyPaths`).
- `lib/features/hub/hub_providers.dart` (`SeasonService._invalidateCompetitionViews`).
- `lib/features/nations/nation_vitrine_screen.dart` (`NationView`).
- `lib/features/ranking/world_ranking_screen.dart`, `lib/features/results/results_screen.dart`, `lib/features/results/round_results_screen.dart` (no change; tests only).
- `lib/features/tournaments/tournament_bracket.dart` (`wide`), `cup_detail_screen.dart`, `continental_detail_screen.dart`, `nations_cup_screen.dart`, `continental_clash_screen.dart`, `intercontinental_playoff_screen.dart`, `tournaments_screen.dart`, `draw_ceremony.dart`, `qualifying_draw_screen.dart`, `continental_draw_screen.dart`, `nations_cup_draw_screen.dart`, `finals_draw_screen.dart`, `host_draw_screen.dart`, `tournament_kickoff_screen.dart`.
- `lib/features/match/match_preview_screen.dart`, `match_preview_tablet_layout.dart` (Task 18, stage 2 carry-over).
- `lib/l10n/app_{en,cs,fr,it,pl}.arb`, generated `app_localizations*.dart`, `copy/strings.csv`.
- `docs/superpowers/specs/2026-10-09-tablet-ui-design.md` (Task 19).

## Stage 2 carry-overs folded in

| Finding (stage 2 ledger) | Where |
|---|---|
| No tablet-router test that full-screen routes get `FullScreenPhoneFrame` | Task 1 (full-screen sweep asserts the frame on every unconverted full-screen route and its absence on converted ones) |
| Full-screen routes not swept at tablet size | Task 1 |
| Phone goldens cover only above the fold: use tall goldens for moves | Tasks 5 to 18 (every scrolling screen gets a 390-wide tall golden) |
| `settle`'s cap is silent | Task 1 |
| No tablet tour-run test / resize key-move test | Task 13 (the tour's Tournaments step on tablet, and the `worldRanking` key across a resize through 1000) |
| Tablet preview duplicates the phone's derivation | Task 18 |
| Knockout and friendlies tablet branches of round results untested | Task 7 |

---
### Task 1: Harness: loud settle, three iPad sizes, full-screen sweep

**risk: high (per-task review)**. Every later task's tests run on this.

**Files:**
- Modify: `test/helpers/seeded_save.dart`
- Modify: `test/widget/tablet_route_sweep_test.dart`
- Create: `test/helpers/competition_fixtures.dart`
- Test: `test/widget/settle_test.dart` (new)

**Interfaces:**
- Produces (in `seeded_save.dart`):
  - `const List<Size> kTabletSizes` = 1194 x 834, 1080 x 810, 1024 x 768.
  - `const int kSeededCareerId = 1;`
  - `int get seededNationId` (the strongest European nation, the one `seedSave` starts with).
  - `List<Nation> get realNations`.
  - `Future<void> settle(WidgetTester tester, {int rounds = 30, Duration maxWait = const Duration(seconds: 10), bool allowSpinner = false})`: fails the test when the cap runs out with a spinner on screen, unless `allowSpinner`.
  - `Future<void> pumpRoute(WidgetTester tester, SeededSave save, String location, {Size size = kPhoneSize, bool allowSpinner = false})`.
  - `Future<void> watchContinentalQualifyingDraw(WidgetTester tester, SeededSave save)`.
- Produces (in `competition_fixtures.dart`): `Map<int, Nation> get realNationsById`, `List<Nation> fieldOf(int first, int count)`, `List<({String name, List<int> nationIds})> groupsOf(List<Nation> field, {required int groupCount, required int size})`, `List<GroupStanding> standingsOf(List<int> ids)`, `FinalsDraw finalsDrawOf(List<({String name, List<int> nationIds})> groups)`, `FinalsDrawData fakeFinalsDraw(int playerNationId)`, `ContinentalDrawData fakeContinentalDraw(int playerNationId)`, `NationsCupDrawData fakeNationsCupDraw(int playerNationId)`, `CupData fakeCupData(int playerNationId)`. Tasks 10 to 12 add more fakes to this file.
- Consumes: `qualifyingDrawProvider` (`qualifying_draw_providers.dart`), `competitionRepositoryProvider`, `routerProvider`, `tabletReadyPaths`, `Routes.fullScreen`.

- [ ] **Step 1: Write the failing settle test**

Create `test/widget/settle_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/seeded_save.dart';

/// `settle` used to give up silently on a spinner that never went away, so a
/// golden could be taken of a screen still loading. It must say so instead.
void main() {
  testWidgets('a spinner that outlives the cap fails the test', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
    );
    await expectLater(
      settle(tester, maxWait: const Duration(milliseconds: 200)),
      throwsA(isA<TestFailure>()),
    );
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('unless the spinner is the content', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
    );
    await settle(
      tester,
      maxWait: const Duration(milliseconds: 200),
      allowSpinner: true,
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a screen without a spinner settles', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Text('ready')));
    await settle(tester, rounds: 2);
    expect(find.text('ready'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run it to verify it fails**

Run: `flutter test test/widget/settle_test.dart`
Expected: FAIL. The first test does not throw (the cap is silent) and the second does not compile (`allowSpinner` does not exist).

- [ ] **Step 3: The harness**

In `test/helpers/seeded_save.dart`:

Add the imports (keep the list sorted):

```dart
import 'package:fnm/features/tournaments/qualifying_draw_providers.dart';
```

Under `const Size kTabletSize = Size(1194, 834);` add:

```dart
/// The sizes every tablet layout is tested at: the 11 inch iPad, the 10.2
/// inch one, and the 9.7 inch one, where everything has the least room.
const List<Size> kTabletSizes = [
  Size(1194, 834),
  Size(1080, 810),
  Size(1024, 768),
];

/// The id [seedSave]'s career always gets: the first row of a fresh database.
/// A provider-family override handed to [seedSave] is fixed before the career
/// exists, so it keys on this.
const int kSeededCareerId = 1;
```

Under the `_cities` declaration add:

```dart
/// The real nations, for fake competition data drawn with real flags.
List<Nation> get realNations => _nations;

/// The nation [seedSave] starts the career with: the strongest in Europe.
int get seededNationId => _nations
    .where((n) => n.confederation == Confederation.europe)
    .reduce((a, b) => a.ranking <= b.ranking ? a : b)
    .id;
```

In `seedSave`, replace the two lines that pick `strongest` and pass `strongest.id`:

```dart
    career =
        (await container
                .read(careerServiceProvider)
                .create(
                  nationId: seededNationId,
                  managerName: 'M',
                  rngSeed: 20260922,
                ))
            .valueOrNull!;
```

and after the `tester.runAsync` block (before the `container..invalidate(...)` cascade) add:

```dart
  expect(
    career.id,
    kSeededCareerId,
    reason: 'an override keyed on kSeededCareerId would miss this save',
  );
```

Replace `settle` with:

```dart
/// Lets the database work and the frames catch up.
///
/// At least [rounds] rounds of (real delay, pump), then on until no
/// [CircularProgressIndicator] is left, so a slow provider chain cannot leave
/// a golden on its spinner. Stops after [maxWait] of real time. If a spinner
/// is still showing then, the test FAILS: a screen stuck loading is a bug,
/// not a state to take a golden of. Pass [allowSpinner] only for a screen
/// whose spinner is its content, and say why at the call site. The final
/// pump runs out route transitions.
Future<void> settle(
  WidgetTester tester, {
  int rounds = 30,
  Duration maxWait = const Duration(seconds: 10),
  bool allowSpinner = false,
}) async {
  final clock = Stopwatch()..start();
  var i = 0;
  while (true) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 30)),
    );
    await tester.pump();
    i++;
    final spinning = find
        .byType(CircularProgressIndicator)
        .evaluate()
        .isNotEmpty;
    if (i >= rounds && !spinning) break;
    if (clock.elapsed >= maxWait) {
      if (spinning && !allowSpinner) {
        fail(
          'settle: still loading after ${maxWait.inMilliseconds} ms. '
          'A screen stuck on its spinner is a bug; pass allowSpinner: true '
          'only when the spinner is the content.',
        );
      }
      break;
    }
  }
  await tester.pump(const Duration(milliseconds: 500));
}
```

In `pumpRoute`, add the parameter `bool allowSpinner = false,` after `Size size = kPhoneSize,` and change its last line to:

```dart
  await settle(tester, allowSpinner: allowSpinner);
```

Append at the end of the file:

```dart
/// Marks the current cycle's continental qualifying draw watched, as the
/// manager does by sitting through it: the seeded save opens on that draw,
/// and the results list, the continental detail and the tournaments overview
/// keep its groups and fixtures hidden until it has been seen.
Future<void> watchContinentalQualifyingDraw(
  WidgetTester tester,
  SeededSave save,
) async {
  await tester.runAsync(() async {
    final sub = save.container.listen(
      qualifyingDrawProvider((
        careerId: save.careerId,
        worldCup: false,
      )).future,
      (_, _) {},
    );
    try {
      final data = await sub.read();
      expect(data, isNotNull, reason: 'the seeded save has no such draw');
      await save.container
          .read(competitionRepositoryProvider)
          .markDrawWatched(save.careerId, data!.cycle, data.watchedKind);
    } finally {
      sub.close();
    }
  });
}
```

(`competitionRepositoryProvider` comes from `data_providers.dart`, already imported.)

- [ ] **Step 4: Fake competition data**

Create `test/helpers/competition_fixtures.dart`:

```dart
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/features/tournaments/continental_detail_providers.dart';
import 'package:fnm/features/tournaments/cup_detail_providers.dart';
import 'package:fnm/features/tournaments/finals_draw_providers.dart';
import 'package:fnm/features/tournaments/nations_cup_draw_providers.dart';

import 'seeded_save.dart';

// Fake competition data drawn with the REAL nations, for the screens a fresh
// save has nothing to show on yet (a finals draw, a bracket, a Clash). The
// manager's nation always heads the first group.

Map<int, Nation> get realNationsById => {for (final n in realNations) n.id: n};

/// [count] nations: [first], then the best-ranked of the rest.
List<Nation> fieldOf(int first, int count) {
  final others = [
    for (final n in realNations)
      if (n.id != first) n,
  ]..sort((a, b) => a.ranking.compareTo(b.ranking));
  return [
    realNations.firstWhere((n) => n.id == first),
    ...others.take(count - 1),
  ];
}

/// [groupCount] groups of [size] drawn from [field] as pots would: the first
/// [groupCount] nations are pot 1, one per group, and so on. Each group lists
/// its nations in pot order. Group names run A, B, C...
List<({String name, List<int> nationIds})> groupsOf(
  List<Nation> field, {
  required int groupCount,
  required int size,
}) => [
  for (var g = 0; g < groupCount; g++)
    (
      name: String.fromCharCode(65 + g),
      nationIds: [for (var p = 0; p < size; p++) field[p * groupCount + g].id],
    ),
];

/// A finished round-robin table for [ids], first to last.
List<GroupStanding> standingsOf(List<int> ids) => [
  for (var i = 0; i < ids.length; i++)
    GroupStanding(ids[i])
      ..played = ids.length - 1
      ..won = ids.length - 1 - i
      ..lost = i
      ..goalsFor = 2 * (ids.length - i)
      ..goalsAgainst = i,
];

FinalsDraw finalsDrawOf(List<({String name, List<int> nationIds})> groups) =>
    FinalsDraw(
      groups: [
        for (final g in groups)
          FinalsGroupDraw(name: g.name, nationIds: g.nationIds, fixtures: const []),
      ],
    );

/// A World Championship finals draw of eight groups of four, not yet watched.
FinalsDrawData fakeFinalsDraw(int playerNationId) {
  final groups = groupsOf(
    fieldOf(playerNationId, 32),
    groupCount: 8,
    size: 4,
  );
  return FinalsDrawData(
    draw: finalsDrawOf(groups),
    nations: realNationsById,
    playerNationId: playerNationId,
    potByNation: {
      for (final g in groups)
        for (var p = 0; p < g.nationIds.length; p++) g.nationIds[p]: p + 1,
    },
    cycle: 0,
    alreadyWatched: false,
  );
}

/// A continental finals draw of six groups of four.
ContinentalDrawData fakeContinentalDraw(int playerNationId) =>
    ContinentalDrawData(
      draw: finalsDrawOf(
        groupsOf(fieldOf(playerNationId, 24), groupCount: 6, size: 4),
      ),
      nations: realNationsById,
      playerNationId: playerNationId,
    );

/// A Nations Cup league draw of four groups of four, not yet watched.
NationsCupDrawData fakeNationsCupDraw(int playerNationId) =>
    NationsCupDrawData(
      leagueLetter: 'A',
      groups: groupsOf(fieldOf(playerNationId, 16), groupCount: 4, size: 4),
      nations: realNationsById,
      playerNationId: playerNationId,
      cycle: 0,
      alreadyWatched: false,
    );

/// A World Championship deep into its finals: six qualifying groups of five
/// for the manager's confederation, eight finals groups of four and a played
/// bracket from the last sixteen (the home side always goes through).
CupData fakeCupData(int playerNationId) {
  final me = realNationsById[playerNationId]!;
  final qualifying = groupsOf(
    fieldOf(playerNationId, 30),
    groupCount: 6,
    size: 5,
  );
  final finals = groupsOf(fieldOf(playerNationId, 32), groupCount: 8, size: 4);
  var nextId = 1000;
  Fixture tie(String round, int home, int away) => Fixture(
    id: nextId++,
    careerId: kSeededCareerId,
    competitionId: 99,
    matchday: 1,
    date: DateTime(2030, 7, 1),
    homeNationId: home,
    awayNationId: away,
    homeScore: 2,
    awayScore: 1,
    round: round,
    played: true,
  );
  final r16 = [
    for (var i = 0; i < 8; i++)
      tie(
        WorldCupFinals.r16,
        finals[i].nationIds[0],
        finals[(i + 1) % 8].nationIds[1],
      ),
  ];
  final qf = [
    for (var i = 0; i < 4; i++)
      tie(WorldCupFinals.qf, r16[2 * i].homeNationId, r16[2 * i + 1].homeNationId),
  ];
  final sf = [
    for (var i = 0; i < 2; i++)
      tie(WorldCupFinals.sf, qf[2 * i].homeNationId, qf[2 * i + 1].homeNationId),
  ];
  final last = tie(
    WorldCupFinals.finalRound,
    sf[0].homeNationId,
    sf[1].homeNationId,
  );
  return CupData(
    groups: [
      for (final g in qualifying)
        (
          confederation: me.confederation,
          groupName: g.name,
          standings: standingsOf(g.nationIds),
        ),
    ],
    nations: realNationsById,
    playerNationId: playerNationId,
    playerConfederation: me.confederation,
    finalsGroups: [
      for (final g in finals)
        (name: g.name, standings: standingsOf(g.nationIds)),
    ],
    knockout: [...r16, ...qf, ...sf, last],
    champion: last.homeNationId,
    hostId: null,
    scorersQualifying: const [],
    scorersFinals: const [],
    honours: const [],
    playerNames: const {},
  );
}
```

- [ ] **Step 5: The sweep at three sizes, and the full-screen sweep**

Replace `test/widget/tablet_route_sweep_test.dart` with:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/widgets/app_error_state.dart';
import 'package:go_router/go_router.dart';

import '../helpers/seeded_save.dart';

/// Every route, on a real save, at every iPad size: none may report a layout
/// error, land somewhere else, sit on a spinner or show an error. In the
/// shell, screens without a tablet layout yet are drawn at phone width
/// (ShellPhoneFrame). Full screen, they are drawn through FullScreenPhoneFrame,
/// and a converted one (in tabletReadyPaths) never is.
void main() {
  for (final size in kTabletSizes) {
    testWidgets('every shell route lays out on a tablet, $size', (
      tester,
    ) async {
      await _sweepShell(tester, size);
    });
    testWidgets('every full-screen route lays out on a tablet, $size', (
      tester,
    ) async {
      await _sweepFullScreen(tester, size);
    });
  }
}

Future<void> _sweepShell(WidgetTester tester, Size size) async {
  final save = await seedSave(tester, formFactor: FormFactor.tablet);
  final id = save.careerId;
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
  final me = save.nations.firstWhere((n) => n.id == save.nationId);
  final other = save.nations.firstWhere((n) => n.id != save.nationId);

  /// Each in-shell path, and the extra query it needs to show something.
  final extra = <String, String>{
    Routes.hub: '',
    Routes.manager: '',
    Routes.tactics: '',
    Routes.callUps: '',
    Routes.matchPreview: '',
    Routes.roundResults: '',
    Routes.player: '&playerId=$playerId',
    Routes.teamStats: '',
    Routes.nationVitrine: '&nationId=${other.id}',
    Routes.careers: '',
    Routes.careerSummary: '',
    Routes.achievements: '',
    Routes.challenges: '',
    Routes.messages: '',
    Routes.finances: '',
    Routes.youth: '',
    Routes.y: '',
    Routes.boardObjectives: '',
    Routes.budgetSetup: '',
    Routes.records: '',
    Routes.legends: '',
    Routes.allTimeRecords: '',
    Routes.headToHead: '',
    Routes.h2hMeetings: '&a=${me.id}&b=${other.id}',
    Routes.nationsCup: '',
    Routes.naturalization: '',
    Routes.managerHistory: '',
    Routes.friendlies: '',
    Routes.results: '',
    Routes.tournaments: '',
    Routes.cup: '',
    Routes.continental: '&conf=${me.confederation.name}',
    Routes.continentalClash: '',
    Routes.ranking: '',
    Routes.trainingCamp: '',
    Routes.intercontinentalPlayoff: '',
  };

  // The list above must be the shell's routes, all of them: a route added
  // later without a line here fails this, rather than going unswept.
  final shell = save.container
      .read(routerProvider)
      .configuration
      .routes
      .whereType<ShellRoute>()
      .single;
  expect(
    extra.keys.toSet(),
    {for (final r in shell.routes.whereType<GoRoute>()) r.path},
  );

  /// Routes allowed to keep an ambient spinner (reason beside each).
  final stillLoading = <String>{};

  final locations = [
    for (final e in extra.entries) '${e.key}?careerId=$id${e.value}',
    // Squad is the tactics screen on its fourth tab.
    '${Routes.tactics}?careerId=$id&tab=3',
  ];

  await pumpRoute(tester, save, locations.first, size: size);
  final router = save.container.read(routerProvider);
  for (final location in locations) {
    final path = Uri.parse(location).path;
    router.go(location);
    await settle(tester, allowSpinner: stillLoading.contains(path));
    expect(tester.takeException(), isNull, reason: location);
    // It really rendered: no silent redirect, no endless spinner, no error.
    expect(
      router.routeInformationProvider.value.uri.path,
      path,
      reason: 'redirected: $location',
    );
    if (!stillLoading.contains(path)) {
      expect(
        find.byType(CircularProgressIndicator),
        findsNothing,
        reason: 'stuck loading: $location',
      );
    }
    expect(
      find.byType(AppErrorState),
      findsNothing,
      reason: 'error state: $location',
    );
    // A converted screen gets the whole content area; any other is framed.
    expect(
      find.byType(PhoneWidthFrame),
      tabletReadyPaths.contains(path) ? findsNothing : findsOneWidget,
      reason: 'frame: $location',
    );
  }

  // Unmount, so no screen's timers outlive the test.
  await tester.pumpWidget(const SizedBox());
  await tester.pump();
}

Future<void> _sweepFullScreen(WidgetTester tester, Size size) async {
  final save = await seedSave(tester, formFactor: FormFactor.tablet);
  final id = save.careerId;
  final me = save.nations.firstWhere((n) => n.id == save.nationId);

  /// Each full-screen path and the query it needs. The draws that write to
  /// the save (a watched qualifying draw) come last.
  final locations = <String, String>{
    Routes.home: '',
    Routes.nations: '',
    Routes.saves: '',
    Routes.settings: '',
    Routes.diagnostics: '',
    Routes.startFromBottom: '',
    Routes.newGame: '?nationId=${me.id}',
    Routes.gallery: '',
    Routes.hostDraw: '?careerId=$id',
    Routes.finalsDraw: '?careerId=$id',
    Routes.continentalDraw: '?careerId=$id&conf=${me.confederation.name}',
    Routes.nationsCupDraw: '?careerId=$id',
    Routes.tournamentKickoff: '?careerId=$id',
    Routes.cycleRollover: '?careerId=$id',
    Routes.qualifyingDraw: '?careerId=$id',
  };

  /// Full-screen routes swept elsewhere (reason beside each).
  const elsewhere = {
    // Needs its pre-simulated preview warmed first: match_tablet_test.
    Routes.match,
  };

  // Every full-screen route is either swept here or named above.
  expect({...locations.keys, ...elsewhere}, Routes.fullScreen);

  /// Routes allowed to keep a spinner as their content (reason beside each).
  final stillLoading = <String>{};

  await pumpRoute(tester, save, '${Routes.hub}?careerId=$id', size: size);
  final router = save.container.read(routerProvider);
  for (final e in locations.entries) {
    final location = '${e.key}${e.value}';
    router.go(location);
    await settle(tester, allowSpinner: stillLoading.contains(e.key));
    expect(tester.takeException(), isNull, reason: location);
    expect(
      router.routeInformationProvider.value.uri.path,
      e.key,
      reason: 'redirected: $location',
    );
    expect(
      find.byType(AppErrorState),
      findsNothing,
      reason: 'error state: $location',
    );
    expect(
      find.byType(FullScreenPhoneFrame),
      tabletReadyPaths.contains(e.key) ? findsNothing : findsOneWidget,
      reason: 'frame: $location',
    );
  }

  await tester.pumpWidget(const SizedBox());
  await tester.pump();
}
```

The shell sweep's new `PhoneWidthFrame` assertion is the in-shell twin of the full-screen frame check: a screen that asks `TabletShellScope.isActive` but was never registered would otherwise pass while drawing its tablet layout at 600.

If a full-screen route fails "still loading" because a spinner IS its content, add its path to `stillLoading` with the reason beside it. Any other stuck spinner is a bug: stop and report it, do not allow-list it.

- [ ] **Step 6: Run the new tests and the sweep**

Run: `flutter test test/widget/settle_test.dart test/widget/tablet_route_sweep_test.dart`
Expected: PASS (6 sweep cases, 3 settle cases).

- [ ] **Step 7: Prove the frame assertion bites**

In `lib/core/routing/app_router.dart`, `_tabletRoutes`, temporarily change the full-screen line `if (tabletReadyPaths.contains(r.path)) r else _phoneFramed(r),` to `r,` (no frame on any full-screen route). Run `flutter test test/widget/tablet_route_sweep_test.dart --plain-name "full-screen route"` and confirm it FAILS with `frame: /`. Revert (`git diff -- lib` shows nothing).

- [ ] **Step 8: Full suite**

Run: `flutter analyze && flutter test`
Expected: analyzer clean; the final summary line says all tests passed. The loud `settle` may surface tests that used to give up on a spinner silently. For each: if the spinner is the screen's content, pass `allowSpinner: true` with a comment; if the screen is stuck loading, that is a real bug: stop and report it with the test name.

- [ ] **Step 9: Commit**

```bash
git add test/helpers/seeded_save.dart test/helpers/competition_fixtures.dart test/widget/settle_test.dart test/widget/tablet_route_sweep_test.dart
git commit -m "test(tablet): loud settle, three iPad sizes, full-screen route sweep

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

(Add any test file Step 8 had to touch to the `git add`.)

---

### Task 2: Kit: ColumnFlow, TabletScreenHeader, DataGrid controller, wide bracket

**risk: high (per-task review)**. Shared by Tasks 6 to 13.

**Files:**
- Create: `lib/shared/tablet/column_flow.dart`, `lib/shared/tablet/screen_header.dart`
- Modify: `lib/shared/tablet/tablet.dart`, `lib/shared/tablet/data_grid.dart`, `lib/features/tournaments/tournament_bracket.dart`
- Test: `test/widget/column_flow_test.dart` (new), `test/widget/data_grid_controller_test.dart` (new), `test/widget/tournament_bracket_wide_test.dart` (new)

**Interfaces:**
- Produces:
  - `class ColumnFlow extends StatelessWidget { const ColumnFlow({required List<Widget> children, double minTileWidth = 280, int maxColumns = 3, double gap = 12, Key? key}); static int columnsFor(double width, {double minTileWidth = 280, int maxColumns = 3, double gap = 12}); }`
  - `class TabletScreenHeader extends StatelessWidget { const TabletScreenHeader({required String title, VoidCallback? onBack, Widget? trailing, Color? accent, Key? key}); static const Key backKey; }`
  - `DataGrid({..., ScrollController? controller})`: the body's vertical scroll controller.
  - `TournamentBracket({..., bool wide = false})`: opens on the bracket view and stretches its round columns across the width when they fit.
- Consumes: `TabletText.screenTitle`, `AppSpacing`, `AppColors`.

- [ ] **Step 1: Write the failing tests**

Create `test/widget/column_flow_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/pump_app.dart';

Widget _tile(int i, {double height = 40}) =>
    SizedBox(key: ValueKey(i), height: height, child: Text('tile $i'));

Future<void> _pump(WidgetTester tester, double width, List<Widget> tiles) =>
    tester.pumpApp(
      Scaffold(
        body: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: width,
            child: SingleChildScrollView(child: ColumnFlow(children: tiles)),
          ),
        ),
      ),
    );

void main() {
  test('columns: as many 280 tiles as fit, one to three', () {
    expect(ColumnFlow.columnsFor(200), 1);
    expect(ColumnFlow.columnsFor(571), 1);
    expect(ColumnFlow.columnsFor(572), 2);
    expect(ColumnFlow.columnsFor(864), 3);
    expect(ColumnFlow.columnsFor(3000), 3);
    expect(ColumnFlow.columnsFor(double.infinity), 1);
    expect(ColumnFlow.columnsFor(3000, maxColumns: 5), 5);
  });

  testWidgets('two a row at 600, the odd one alone below', (tester) async {
    await _pump(tester, 600, [for (var i = 0; i < 3; i++) _tile(i)]);
    final a = tester.getRect(find.byKey(const ValueKey(0)));
    final b = tester.getRect(find.byKey(const ValueKey(1)));
    final c = tester.getRect(find.byKey(const ValueKey(2)));
    expect(a.top, b.top);
    expect(b.left, greaterThan(a.right));
    expect(c.top, greaterThan(a.bottom));
    expect(c.left, a.left);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a row is as tall as its tallest tile', (tester) async {
    await _pump(tester, 600, [_tile(0), _tile(1, height: 90)]);
    // The short tile is stretched to the row's height.
    expect(
      tester.getSize(find.byKey(const ValueKey(0))).height,
      tester.getSize(find.byKey(const ValueKey(1))).height,
    );
  });

  testWidgets('stacked at 300', (tester) async {
    await _pump(tester, 300, [for (var i = 0; i < 2; i++) _tile(i)]);
    final a = tester.getRect(find.byKey(const ValueKey(0)));
    final b = tester.getRect(find.byKey(const ValueKey(1)));
    expect(b.top, a.bottom + 12);
    expect(a.width, 300);
  });

  testWidgets('the screen header: back, title, trailing', (tester) async {
    var back = 0;
    await tester.pumpApp(
      Scaffold(
        body: TabletScreenHeader(
          title: 'RANKING',
          onBack: () => back++,
          trailing: const Text('action'),
        ),
      ),
    );
    expect(find.text('RANKING'), findsOneWidget);
    expect(find.text('action'), findsOneWidget);
    await tester.tap(find.byKey(TabletScreenHeader.backKey));
    expect(back, 1);
  });

  testWidgets('no back arrow without onBack', (tester) async {
    await tester.pumpApp(
      const Scaffold(body: TabletScreenHeader(title: 'RANKING')),
    );
    expect(find.byKey(TabletScreenHeader.backKey), findsNothing);
  });
}
```

Create `test/widget/data_grid_controller_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/pump_app.dart';

void main() {
  testWidgets('a controller scrolls the rows (the header stays)', (
    tester,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    final rows = [for (var i = 0; i < 100; i++) i];
    await tester.pumpApp(
      Scaffold(
        body: SizedBox(
          width: 400,
          height: 400,
          child: DataGrid<int>(
            rows: rows,
            controller: controller,
            columnSets: [
              GridColumnSet(
                id: 'all',
                label: 'All',
                columns: [
                  GridColumn(id: 'n', label: 'N', cell: (r) => Text('row $r')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    expect(find.text('row 0'), findsOneWidget);
    controller.jumpTo(DataGrid.rowHeight * 50);
    await tester.pump();
    expect(find.text('row 0'), findsNothing);
    expect(find.text('row 50'), findsOneWidget);
    expect(find.byKey(DataGrid.headerKey), findsOneWidget);
  });
}
```

Create `test/widget/tournament_bracket_wide_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/features/tournaments/tournament_bracket.dart';

import '../helpers/pump_app.dart';

/// The list view's pages; their headers are written in capitals, so none of
/// them reads 'R16' or 'Final' the way the bracket's column labels do.
const _rounds = <BracketRound>[
  ('R16', 'Round of 16'),
  ('QF', 'Quarter-finals'),
  ('SF', 'Semi-finals'),
  ('FINAL', 'Final'),
];

const _ladder = <BracketRound>[
  ('R16', 'R16'),
  ('QF', 'QF'),
  ('SF', 'SF'),
  ('FINAL', 'Final'),
];

List<Fixture> _bracket() {
  var id = 0;
  Fixture tie(String round, int home, int away) => Fixture(
    id: id++,
    careerId: 1,
    competitionId: 1,
    matchday: 1,
    date: DateTime(2030, 7, 1),
    homeNationId: home,
    awayNationId: away,
    homeScore: 1,
    awayScore: 0,
    round: round,
    played: true,
  );
  return [
    for (var i = 0; i < 8; i++) tie('R16', 2 * i + 1, 2 * i + 2),
    for (var i = 0; i < 4; i++) tie('QF', 4 * i + 1, 4 * i + 3),
    for (var i = 0; i < 2; i++) tie('SF', 8 * i + 1, 8 * i + 5),
    tie('FINAL', 1, 9),
  ];
}

Future<void> _pump(WidgetTester tester, {required bool wide}) async {
  tester.view.physicalSize = const Size(1000, 1400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpApp(
    Scaffold(
      body: TournamentBracket(
        fixtures: _bracket(),
        rounds: _rounds,
        ladder: _ladder,
        playerNationId: 1,
        code: (id) => 'N$id',
        name: (id) => 'Nation $id',
        wide: wide,
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('wide: opens on the bracket, columns across the width', (
    tester,
  ) async {
    await _pump(tester, wide: true);
    final r16 = tester.getCenter(find.text('R16'));
    final last = tester.getCenter(find.text('Final'));
    // Four 150-wide columns 8 apart would put the centres 3 x 158 apart.
    expect(last.dx - r16.dx, greaterThan(3 * 158 + 100));
    expect(find.byType(SingleChildScrollView), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('phone (not wide): opens on the list, as before', (
    tester,
  ) async {
    await _pump(tester, wide: false);
    // The list view pages one round at a time; the bracket's column labels
    // are not on screen until the manager switches to it.
    expect(find.text('R16'), findsNothing);
    await tester.tap(find.text('Bracket'));
    await tester.pump();
    final r16 = tester.getCenter(find.text('R16'));
    final last = tester.getCenter(find.text('Final'));
    expect(last.dx - r16.dx, 3 * 158);
  });
}
```

(`'Bracket'` is `tourSharedBracket` in English. The list view opens on the last played round and writes its label in capitals ("FINAL"), so `'R16'` and `'Final'` exist only as the bracket's column labels.)

- [ ] **Step 2: Run them to verify they fail**

Run: `flutter test test/widget/column_flow_test.dart test/widget/data_grid_controller_test.dart test/widget/tournament_bracket_wide_test.dart`
Expected: FAIL to compile (`ColumnFlow`, `TabletScreenHeader`, `DataGrid.controller`, `TournamentBracket.wide` do not exist).

- [ ] **Step 3: `ColumnFlow`**

Create `lib/shared/tablet/column_flow.dart`:

```dart
import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Tiles in as many equal columns as fit, row by row: the tablet's grid of
/// group tables.
///
/// The column count is how many [minTileWidth] tiles fit side by side with
/// [gap] between them, at least one and at most [maxColumns]. Tiles in a row
/// share the row's height (each row is an [IntrinsicHeight]), so a tile must
/// be able to report its intrinsic height: no [ListView], [LayoutBuilder] or
/// `WholeText` inside one. With one column the tiles are stacked [gap] apart.
///
/// Sits inside a vertical scroll view and sizes itself to its content. It is
/// built on a [LayoutBuilder] itself, so it must not go inside a
/// `DashboardGrid` tile.
class ColumnFlow extends StatelessWidget {
  const ColumnFlow({
    required this.children,
    this.minTileWidth = 280,
    this.maxColumns = 3,
    this.gap = 12,
    super.key,
  }) : assert(maxColumns >= 1, 'at least one column');

  final List<Widget> children;
  final double minTileWidth;
  final int maxColumns;
  final double gap;

  /// How many columns [width] holds.
  static int columnsFor(
    double width, {
    double minTileWidth = 280,
    int maxColumns = 3,
    double gap = 12,
  }) {
    if (!width.isFinite) return 1;
    final fit = ((width + gap) / (minTileWidth + gap)).floor();
    return math.max(1, math.min(maxColumns, fit));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        final columns = columnsFor(
          box.maxWidth,
          minTileWidth: minTileWidth,
          maxColumns: maxColumns,
          gap: gap,
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < children.length; i += columns) ...[
              if (i > 0) SizedBox(height: gap),
              if (columns == 1)
                children[i]
              else
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (var j = 0; j < columns; j++) ...[
                        if (j > 0) SizedBox(width: gap),
                        Expanded(
                          child: i + j < children.length
                              ? children[i + j]
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          ],
        );
      },
    );
  }
}
```

- [ ] **Step 4: `TabletScreenHeader`**

Create `lib/shared/tablet/screen_header.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/shared/tablet/tablet_text.dart';

/// A tablet screen's heading row: a back arrow when the screen has somewhere
/// to go back to, the title, and an action on the right (a Continue button).
class TabletScreenHeader extends StatelessWidget {
  const TabletScreenHeader({
    required this.title,
    this.onBack,
    this.trailing,
    this.accent,
    super.key,
  });

  static const Key backKey = Key('tabletScreenHeader.back');

  final String title;
  final VoidCallback? onBack;
  final Widget? trailing;

  /// The title's colour; the screen title's own when null.
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          if (onBack != null) ...[
            IconButton(
              key: backKey,
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              icon: const Icon(Icons.arrow_back, color: AppColors.primary),
              onPressed: onBack,
            ),
            const SizedBox(width: AppSpacing.xs),
          ],
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TabletText.screenTitle.copyWith(color: accent),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
```

Add both to the barrel `lib/shared/tablet/tablet.dart`, keeping it sorted:

```dart
export 'adaptive_sheet.dart';
export 'column_flow.dart';
export 'dashboard_grid.dart';
export 'data_grid.dart';
export 'detail_pane.dart';
export 'master_detail.dart';
export 'panel.dart';
export 'screen_header.dart';
export 'tablet_shell_scope.dart';
export 'tablet_text.dart';
```

- [ ] **Step 5: `DataGrid.controller`**

In `lib/shared/tablet/data_grid.dart`, add the constructor parameter `this.controller,` after `this.onSelect,`, the field after `onSelect`:

```dart
  /// The rows' vertical scroll, for a screen that scrolls the table itself
  /// ("centre on my nation"). The header never scrolls.
  final ScrollController? controller;
```

and pass it to the body's list in `_table`:

```dart
          child: ListView.builder(
            controller: widget.controller,
            itemCount: rows.length,
```

- [ ] **Step 6: `TournamentBracket.wide`**

In `lib/features/tournaments/tournament_bracket.dart`:

Add `import 'dart:math' as math;` at the top.

Add the constructor parameter `this.wide = false,` after `this.extraHeader,` and the field after `extraHeader`:

```dart
  /// A tablet pane: open on the bracket rather than the list, and stretch the
  /// round columns across the width when they fit (they scroll sideways, as
  /// on a phone, when they do not).
  final bool wide;
```

In the State, change `bool _visual = false;` to:

```dart
  late bool _visual = widget.wide;
```

Replace `_bracketView` with the version below. On a phone (`wide` false) it builds exactly the widgets it built before: each round a `SizedBox(width: 150)` around the same `Column`, in the same horizontal scroll.

```dart
  /// A round column's width in the scrolling bracket.
  static const double _columnWidth = 150;

  /// A horizontal, aligned bracket: one column per round, ties spaced evenly so
  /// each next-round tie sits between its two feeders.
  Widget _bracketView() {
    final bodies = <Widget>[];
    for (final (round, label) in widget.ladder) {
      final inRound = _inRound(round);
      if (inRound.isEmpty) continue;
      bodies.add(
        Column(
          children: [
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [for (final f in inRound) _miniTie(f)],
              ),
            ),
          ],
        ),
      );
    }
    Widget scrolling() => SizedBox(
      height: _bracketHeight(),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < bodies.length; i++) ...[
              if (i > 0) const SizedBox(width: AppSpacing.sm),
              SizedBox(width: _columnWidth, child: bodies[i]),
            ],
          ],
        ),
      ),
    );
    if (!widget.wide) return scrolling();
    return LayoutBuilder(
      builder: (context, box) {
        final natural =
            bodies.length * _columnWidth +
            math.max(0, bodies.length - 1) * AppSpacing.sm;
        if (!box.maxWidth.isFinite || box.maxWidth < natural) {
          return scrolling();
        }
        return SizedBox(
          height: _bracketHeight(),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < bodies.length; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.sm),
                Expanded(child: bodies[i]),
              ],
            ],
          ),
        );
      },
    );
  }
```

- [ ] **Step 7: Run the new tests and the existing bracket tests, expect PASS**

Run: `flutter test test/widget/column_flow_test.dart test/widget/data_grid_controller_test.dart test/widget/tournament_bracket_wide_test.dart test/widget/tournament_bracket_test.dart test/widget/data_grid_test.dart`
Expected: PASS.

- [ ] **Step 8: Analyze, full suite, commit**

Run: `flutter analyze && flutter test` (read the final summary line; every `test/golden` guard must pass without `--update-goldens`).

```bash
git add lib/shared/tablet/column_flow.dart lib/shared/tablet/screen_header.dart lib/shared/tablet/tablet.dart lib/shared/tablet/data_grid.dart lib/features/tournaments/tournament_bracket.dart test/widget/column_flow_test.dart test/widget/data_grid_controller_test.dart test/widget/tournament_bracket_wide_test.dart
git commit -m "feat(tablet): ColumnFlow, screen header, grid scroll controller, wide bracket

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 3: Stage 3 copy in all 5 languages

**risk: low (batched review)**.

**Files:**
- Modify: `lib/l10n/app_en.arb`, `app_cs.arb`, `app_fr.arb`, `app_it.arb`, `app_pl.arb`
- Regenerate: `lib/l10n/app_localizations*.dart`, `copy/strings.csv`
- Test: existing `test/unit/l10n/*` guards

**Interfaces:**
- Produces these `AppLocalizations` getters: `gridColRank`, `gridColMove`, `gridColNation`, `gridColRegion`, `gridColPoints`, `panePickNation`, `resultsCyclesTitle`, `tourDrawStart`, `tourDrawViewGroups`.
- Reused existing getters (do not add): `gridViewOverview`, `paneFullProfile`, `nationsVitrineTitle`, `rankingWorldRanking`, `rankingCentreOnMe`, `rankingNoRanking`, `rankingCouldNotLoad`, `tourSharedWorldRankingTitle`, `resultsMyMatches`, `resultsNoFixtures`, `resultsCouldNotLoad`, `resultsVs`, `resultsCycleTitle`, `resultsCycleRecord`, `resultsCycleFinish`, `resultsCycleUnderway`, `resultsEarlierMatches`, `tourSharedCompetitions`, `tourWorldRanking`, `tourYourCompetitions`, `tourOtherContinents`, `tourSharedComingSoon`, `tourSharedSoon`, `compNationsCup`, `tourCupTitle`, `tourContNationsCup`, `tourContContinentalClash`, `tourContIntercontinentalPlayoff`, `tourContContinue`, `tourSharedContinue`, `tourSharedGroupName`, `tourSharedHostHeading`, `tourSharedCoHostsHeading`, `tourPot`, `tourCandidates`, `tourSharedLetFinalsBegin`.

- [ ] **Step 1: Add the English strings with descriptions**

Append before the closing `}` of `lib/l10n/app_en.arb` (add a comma after the previous last entry, `"@gridColStatus": {...}`):

```json
  "gridColRank": "Rank",
  "@gridColRank": { "description": "Tablet ranking table column: the nation's world ranking position." },
  "gridColMove": "Move",
  "@gridColMove": { "description": "Tablet ranking table column: places climbed or dropped since the last ranking freeze." },
  "gridColNation": "Nation",
  "@gridColNation": { "description": "Tablet ranking table column: the national team." },
  "gridColRegion": "Region",
  "@gridColRegion": { "description": "Tablet ranking table column: the nation's confederation." },
  "gridColPoints": "Points",
  "@gridColPoints": { "description": "Tablet ranking table column: world ranking points." },
  "panePickNation": "Pick a nation to see its record here",
  "@panePickNation": { "description": "Tablet detail pane: shown while no nation is selected." },
  "resultsCyclesTitle": "Cycles",
  "@resultsCyclesTitle": { "description": "Tablet results screen: heading of the list of the manager's four-year cycles." },
  "tourDrawStart": "Start the draw",
  "@tourDrawStart": { "description": "World Championship finals draw: button that starts the ball-drawing ceremony." },
  "tourDrawViewGroups": "View groups",
  "@tourDrawViewGroups": { "description": "World Championship finals draw, already watched: button that opens the drawn groups." }
```

`tourDrawStart` and `tourDrawViewGroups` replace two English literals in `finals_draw_screen.dart` (Task 15); in English they read exactly as before.

- [ ] **Step 2: Add the translations**

Append the same keys (values only, no `@` entries) to each locale file:

| key | cs | fr | it | pl |
|---|---|---|---|---|
| gridColRank | Pořadí | Rang | Posizione | Miejsce |
| gridColMove | Posun | Évolution | Variazione | Zmiana |
| gridColNation | Reprezentace | Nation | Nazionale | Reprezentacja |
| gridColRegion | Region | Région | Regione | Region |
| gridColPoints | Body | Points | Punti | Punkty |
| panePickNation | Vyberte reprezentaci a její historie se ukáže tady | Choisissez une nation pour voir son palmarès ici | Scegli una nazionale per vedere qui il suo palmarès | Wybierz reprezentację, aby zobaczyć tu jej historię |
| resultsCyclesTitle | Cykly | Cycles | Cicli | Cykle |
| tourDrawStart | Zahájit los | Lancer le tirage | Avvia il sorteggio | Rozpocznij losowanie |
| tourDrawViewGroups | Zobrazit skupiny | Voir les groupes | Vedi i gironi | Zobacz grupy |

For the de/es files when they merge (not on this branch): gridColRank `Rang` / `Puesto`; gridColMove `Veränderung` / `Cambio`; gridColNation `Nation` / `Selección`; gridColRegion `Region` / `Región`; gridColPoints `Punkte` / `Puntos`; panePickNation `Nation wählen, um ihre Bilanz hier zu sehen` / `Elige una selección para ver aquí su historial`; resultsCyclesTitle `Zyklen` / `Ciclos`; tourDrawStart `Auslosung starten` / `Empezar el sorteo`; tourDrawViewGroups `Gruppen ansehen` / `Ver los grupos`.

- [ ] **Step 3: Regenerate typed strings and the copy file**

```bash
flutter gen-l10n
dart run tool/export_copy.dart
```

Expected: no "untranslated" entries for the new keys in `lib/l10n/untranslated.txt`; `copy/strings.csv` gains 9 rows.

- [ ] **Step 4: Run the l10n guards**

Run: `flutter test test/unit/l10n`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/l10n copy/strings.csv
git commit -m "feat(tablet): stage 3 copy (ranking grid, nation pane, cycles, finals draw buttons)

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---
### Task 4: Competition screens refresh after a sim step

**risk: high (per-task review)**. Touches `SeasonService`, the sim's invalidation cascade.

On a phone a competition screen is never on show while the sim runs: Continue lives on the hub. On a tablet the top bar's Continue advances in place under ANY in-shell screen (stage 2 ruling), so the Tournaments list, a group table, the results or a nation's record would keep showing the world from before the step. Their providers are auto-disposed but kept alive by being watched, and they read the database imperatively, so nothing tells them. The cascade must.

**Files:**
- Create: `lib/features/tournaments/nations_cup_providers.dart`, `lib/features/tournaments/continental_clash_providers.dart`, `lib/features/tournaments/intercontinental_playoff_providers.dart`
- Modify: `lib/features/tournaments/nations_cup_screen.dart`, `continental_clash_screen.dart`, `intercontinental_playoff_screen.dart`, `cup_detail_screen.dart` (import only)
- Modify: `lib/features/hub/hub_providers.dart`
- Test: `test/widget/competition_refresh_after_step_test.dart` (new)

**Interfaces:**
- Produces:
  - `typedef NationsCupData = (...)` (the former private `_NcView`, same fields), `typedef NationsCupKey = ({int careerId, Confederation? confederation});`, `final AutoDisposeFutureProviderFamily<NationsCupData?, NationsCupKey> nationsCupProvider`.
  - `typedef ContinentalClashData = ({Fixture? tie, Map<int, Nation> nations, int playerNationId, List<Honour> honours});`, `final AutoDisposeFutureProviderFamily<ContinentalClashData?, int> continentalClashProvider`.
  - `intercontinentalPlayoffProvider` and `PlayoffView` now live in `intercontinental_playoff_providers.dart` (unchanged).
  - `SeasonService._invalidateCompetitionViews()` (private), called at the end of each of the three cascades.
- Consumes: `tournamentsOverviewProvider`, `cupDetailProvider`, `continentalDetailProvider`, `resultsProvider`, `nationVitrineProvider`.

- [ ] **Step 1: Write the failing test**

Create `test/widget/competition_refresh_after_step_test.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/nations/nation_vitrine_providers.dart';
import 'package:fnm/features/results/results_providers.dart';
import 'package:fnm/features/tournaments/continental_clash_providers.dart';
import 'package:fnm/features/tournaments/continental_detail_providers.dart';
import 'package:fnm/features/tournaments/cup_detail_providers.dart';
import 'package:fnm/features/tournaments/intercontinental_playoff_providers.dart';
import 'package:fnm/features/tournaments/nations_cup_providers.dart';
import 'package:fnm/features/tournaments/tournaments_providers.dart';

import '../helpers/seeded_save.dart';

/// Review Focus 3. A tablet's top bar runs the sim while a competition screen
/// is on show, and that screen's provider is kept alive by being watched. One
/// step must hand every one of them a fresh read.
void main() {
  testWidgets('a step refreshes every competition screen a tablet keeps '
      'on show', (tester) async {
    final save = await seedSave(tester);
    final id = save.careerId;
    final c = save.container;
    final providers = <String, ProviderListenable<Future<Object?>>>{
      'tournaments': tournamentsOverviewProvider(id).future,
      'cup': cupDetailProvider(id).future,
      'continental': continentalDetailProvider((
        careerId: id,
        confederation: Confederation.europe,
      )).future,
      'nationsCup': nationsCupProvider((
        careerId: id,
        confederation: null,
      )).future,
      'clash': continentalClashProvider(id).future,
      'playoff': intercontinentalPlayoffProvider(id).future,
      'results': resultsProvider(id).future,
      'vitrine': nationVitrineProvider((
        careerId: id,
        nationId: save.nationId,
      )).future,
    };
    // The listeners are the screens on show.
    final subs = {
      for (final e in providers.entries)
        e.key: c.listen<Future<Object?>>(e.value, (_, _) {}),
    };
    addTearDown(() {
      for (final s in subs.values) {
        s.close();
      }
    });
    final before = <String, Future<Object?>>{};
    await tester.runAsync(() async {
      for (final e in subs.entries) {
        before[e.key] = e.value.read();
        await before[e.key];
        // Sanity: with no step in between, the same read comes back.
        expect(identical(e.value.read(), before[e.key]), isTrue, reason: e.key);
      }
      await c.read(seasonServiceProvider).advance(id);
      for (final e in subs.entries) {
        final after = e.value.read();
        expect(
          identical(after, before[e.key]),
          isFalse,
          reason: '${e.key} kept its pre-step data',
        );
        // Let the fresh read finish inside the real-async zone, so no
        // database work is left pending when the test ends.
        await after;
      }
    });
  });
}
```

- [ ] **Step 2: Run it to verify it fails**

Run: `flutter test test/widget/competition_refresh_after_step_test.dart`
Expected: FAIL to compile (`nations_cup_providers.dart`, `continental_clash_providers.dart`, `intercontinental_playoff_providers.dart` do not exist).

- [ ] **Step 3: Move the three providers out of their screens**

Each move is verbatim: the provider body is not edited, only renamed where stated.

1. `lib/features/tournaments/nations_cup_providers.dart`: move the typedef `_NcView` (with its field docs), the typedef `_NcKey` and the provider `_nationsCupProvider` out of `nations_cup_screen.dart`. Rename `_NcView` to `NationsCupData`, `_NcKey` to `NationsCupKey`, `_nationsCupProvider` to `nationsCupProvider`. Give each a doc comment (the typedef: "Everything a Nations Cup screen shows: whose cup, its format, the manager's league and group, the tables, the finals rounds, the honours and the scorers."; the key: "Which cup: `confederation`'s, or (null) the manager's own, Europe's for a manager whose confederation has none."). Imports:

   ```dart
   import 'package:flutter_riverpod/flutter_riverpod.dart';
   import 'package:fnm/data/data_providers.dart';
   import 'package:fnm/domain/entities/enums.dart';
   import 'package:fnm/domain/entities/fixture.dart';
   import 'package:fnm/domain/entities/nation.dart';
   import 'package:fnm/domain/repositories/competition_repository.dart';
   import 'package:fnm/domain/services/competition/nations_cup.dart';
   import 'package:fnm/domain/services/competition/nations_cups.dart';
   import 'package:fnm/features/career/career_providers.dart';
   import 'package:fnm/features/tournaments/nations_cup_draw_providers.dart';
   ```

   In `nations_cup_screen.dart`, import the new file, replace every `_NcView` with `NationsCupData`, `_NcKey` with `NationsCupKey` and `_nationsCupProvider` with `nationsCupProvider`, and drop the imports the screen no longer uses (the analyzer names them).

2. `lib/features/tournaments/continental_clash_providers.dart`: move `_ClashData` and `_clashProvider` out of `continental_clash_screen.dart`, renamed `ContinentalClashData` and `continentalClashProvider`, keeping the doc comments. Imports:

   ```dart
   import 'package:flutter_riverpod/flutter_riverpod.dart';
   import 'package:fnm/data/data_providers.dart';
   import 'package:fnm/domain/entities/enums.dart';
   import 'package:fnm/domain/entities/fixture.dart';
   import 'package:fnm/domain/entities/nation.dart';
   import 'package:fnm/domain/repositories/competition_repository.dart';
   ```

   In the screen, import the new file and rename the uses.

3. `lib/features/tournaments/intercontinental_playoff_providers.dart`: move `PlayoffView` and `intercontinentalPlayoffProvider` (names unchanged) out of `intercontinental_playoff_screen.dart`, with the imports their body uses: `flutter_riverpod`, `core/rng/seeded_rng.dart`, `data/data_providers.dart`, `domain/entities/enums.dart`, `domain/entities/group_standing.dart`, `domain/entities/nation.dart`, `domain/services/competition/finals.dart`, `features/ranking/world_ranking_providers.dart`, `features/tournaments/playoff_paths.dart`. The screen imports the new file. In `cup_detail_screen.dart` replace

   ```dart
   import 'package:fnm/features/tournaments/intercontinental_playoff_screen.dart'
       show intercontinentalPlayoffProvider;
   ```

   with

   ```dart
   import 'package:fnm/features/tournaments/intercontinental_playoff_providers.dart';
   ```

Run `flutter analyze lib/features/tournaments` and fix only imports until it is clean.

- [ ] **Step 4: Invalidate them in the sim's cascade**

In `lib/features/hub/hub_providers.dart`, add the imports (sorted into the existing `features/` block):

```dart
import 'package:fnm/features/nations/nation_vitrine_providers.dart';
import 'package:fnm/features/results/results_providers.dart';
import 'package:fnm/features/tournaments/continental_clash_providers.dart';
import 'package:fnm/features/tournaments/continental_detail_providers.dart';
import 'package:fnm/features/tournaments/cup_detail_providers.dart';
import 'package:fnm/features/tournaments/intercontinental_playoff_providers.dart';
import 'package:fnm/features/tournaments/nations_cup_providers.dart';
import 'package:fnm/features/tournaments/tournaments_providers.dart';
```

Add this method to `SeasonService`, beside `_flushRank`:

```dart
  /// The competition screens' data, refreshed by hand after a step.
  ///
  /// On a phone none of these screens is on show while the sim runs: the
  /// Continue that runs it lives on the hub. A tablet's top bar runs it from
  /// any screen, and a screen on show keeps its auto-disposed provider alive,
  /// reading the world as it was before the step. Nothing else tells them:
  /// they read the database imperatively (see "derived providers go stale").
  void _invalidateCompetitionViews() {
    _ref
      ..invalidate(tournamentsOverviewProvider)
      ..invalidate(cupDetailProvider)
      ..invalidate(continentalDetailProvider)
      ..invalidate(nationsCupProvider)
      ..invalidate(continentalClashProvider)
      ..invalidate(intercontinentalPlayoffProvider)
      ..invalidate(resultsProvider)
      ..invalidate(nationVitrineProvider);
  }
```

Call it right after each of the three `_ref..invalidate(hubDataProvider)...` cascades (the ones that end with `..invalidate(squadConditionProvider)` or `..invalidate(pressStatementsProvider)`; `grep -n "invalidate(hubDataProvider)" lib/features/hub/hub_providers.dart` lists all three: in the advance step, `_skipToChampion` and `_playPlayerMatch`):

```dart
    _invalidateCompetitionViews();
```

If the analyzer reports an import cycle problem it is a lint, not an error: Dart allows cyclic imports, and `hub_providers.dart` already imports feature providers both ways. Do not restructure.

- [ ] **Step 5: Run the test, expect PASS**

Run: `flutter test test/widget/competition_refresh_after_step_test.dart`
Expected: PASS. If the sanity line fails for one provider (a second read without a step already returns a new future), that provider is rebuilt by something else on each read; report it rather than weakening the test.

- [ ] **Step 6: Prove it bites**

Comment out the `_invalidateCompetitionViews();` call in the advance step's cascade only, run the test, confirm it FAILS naming at least `tournaments` and `results`, restore it.

- [ ] **Step 7: Analyze, full suite, commit**

Run: `flutter analyze && flutter test` (final summary line: all passed; `nations_cup_screen_test`, `nations_cup_tabs_test` and the playoff tests must pass untouched).

```bash
git add lib/features/tournaments/nations_cup_providers.dart lib/features/tournaments/continental_clash_providers.dart lib/features/tournaments/intercontinental_playoff_providers.dart lib/features/tournaments/nations_cup_screen.dart lib/features/tournaments/continental_clash_screen.dart lib/features/tournaments/intercontinental_playoff_screen.dart lib/features/tournaments/cup_detail_screen.dart lib/features/hub/hub_providers.dart test/widget/competition_refresh_after_step_test.dart
git commit -m "fix(tablet): a sim step refreshes the competition screens a tablet keeps on show

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 5: `NationView` and the nation detail pane

**risk: high (per-task review)**. A shared view the ranking pane (Task 6) hosts.

**Files:**
- Modify: `lib/features/nations/nation_vitrine_screen.dart`
- Modify: `lib/shared/tablet/detail_pane.dart`, `lib/features/shell/detail_pane_host.dart`
- Test: `test/golden/phone_guard_nation_vitrine_test.dart` (new, with goldens), `test/widget/nation_view_test.dart` (new)

**Interfaces:**
- Produces:
  - `class NationView extends ConsumerWidget { const NationView({required int careerId, required int nationId, EdgeInsetsGeometry padding = const EdgeInsets.all(AppSpacing.marginMobile), Key? key}); }`
  - `final class NationTarget extends DetailTarget { const NationTarget(int nationId); final int nationId; }`
  - `void openNation(BuildContext context, {required int careerId, required int nationId})`: the nearest pane if any, otherwise pushes `Routes.nationVitrine`.
- Consumes: `nationVitrineProvider`, `DetailPaneScope`, `l.nationsVitrineTitle`, `l.paneFullProfile`.

- [ ] **Step 1: Pin the phone vitrine**

Create `test/golden/phone_guard_nation_vitrine_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';

import '../helpers/seeded_save.dart';

/// The phone vitrine, pinned before its body moves into NationView. Must pass
/// unchanged for the rest of the tablet work.
void main() {
  for (final (name, size) in [
    ('nation_vitrine_phone', kPhoneSize),
    ('nation_vitrine_phone_tall', const Size(390, 2000)),
  ]) {
    testWidgets(name, (tester) async {
      final save = await seedSave(tester);
      await pumpRoute(
        tester,
        save,
        '${Routes.nationVitrine}?careerId=${save.careerId}'
        '&nationId=${save.nationId}',
        size: size,
      );
      expect(find.text(enL.nationsHonours), findsOneWidget);
      await expectAppGolden('goldens/$name.png');
    });
  }
}
```

- [ ] **Step 2: Create the baseline, confirm it holds, commit it**

```bash
flutter test --update-goldens test/golden/phone_guard_nation_vitrine_test.dart
flutter test test/golden/phone_guard_nation_vitrine_test.dart
git add test/golden/phone_guard_nation_vitrine_test.dart test/golden/goldens/nation_vitrine_phone.png test/golden/goldens/nation_vitrine_phone_tall.png
git commit -m "test(tablet): phone guard for the nation vitrine

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

Open both PNGs and check they show the vitrine (header, honours, ranking history), not a spinner.

- [ ] **Step 3: Write the failing tests**

Create `test/widget/nation_view_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/features/nations/nation_vitrine_screen.dart';
import 'package:fnm/features/shell/detail_pane_host.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/detail_pane.dart';
import 'package:go_router/go_router.dart';

import '../helpers/seeded_save.dart';

Future<GoRouter> _pump(
  WidgetTester tester,
  SeededSave save,
  Widget Function(BuildContext context) home,
) async {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, _) => Scaffold(body: Builder(builder: home)),
      ),
      GoRoute(
        path: '/nation',
        builder: (_, state) =>
            Text('nation page ${state.uri.queryParameters['nationId']}'),
      ),
    ],
  );
  tester.view.physicalSize = kTabletSize;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: save.container,
      child: MaterialApp.router(
        theme: AppTheme.theme,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    ),
  );
  await settle(tester);
  return router;
}

void main() {
  testWidgets('NationView shows the nation, scrolling by itself', (
    tester,
  ) async {
    final save = await seedSave(tester);
    final me = save.nations.firstWhere((n) => n.id == save.nationId);
    await _pump(
      tester,
      save,
      (_) => SizedBox(
        height: 500,
        child: NationView(careerId: save.careerId, nationId: me.id),
      ),
    );
    expect(find.text(me.name), findsOneWidget);
    expect(find.text(enL.nationsHonours), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a nation in the pane, with a way to its full page', (
    tester,
  ) async {
    final save = await seedSave(tester);
    final other = save.nations.firstWhere((n) => n.id != save.nationId);
    final router = await _pump(
      tester,
      save,
      (_) => SizedBox(
        width: 380,
        child: DetailPaneHost(
          careerId: save.careerId,
          target: NationTarget(other.id),
        ),
      ),
    );
    expect(find.byType(NationView), findsOneWidget);
    expect(find.text(other.name), findsOneWidget);
    expect(find.text(enL.nationsVitrineTitle.toUpperCase()), findsOneWidget);
    await tester.tap(find.byKey(DetailPaneHost.fullProfileKey));
    await settle(tester);
    expect(find.text('nation page ${other.id}'), findsOneWidget);
    expect(router.state.uri.queryParameters['careerId'], '${save.careerId}');
  });

  testWidgets('openNation fills the pane when there is one', (tester) async {
    final save = await seedSave(tester);
    final pane = DetailPaneController();
    addTearDown(pane.dispose);
    await _pump(
      tester,
      save,
      (_) => DetailPaneScope(
        controller: pane,
        child: Builder(
          builder: (context) => TextButton(
            onPressed: () =>
                openNation(context, careerId: save.careerId, nationId: 7),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    expect(pane.value, const NationTarget(7));
  });

  testWidgets('and routes to the vitrine when there is none', (tester) async {
    final save = await seedSave(tester);
    await _pump(
      tester,
      save,
      (context) => TextButton(
        onPressed: () =>
            openNation(context, careerId: save.careerId, nationId: 7),
        child: const Text('open'),
      ),
    );
    await tester.tap(find.text('open'));
    await settle(tester);
    expect(find.text('nation page 7'), findsOneWidget);
  });

  test('targets compare by id', () {
    expect(const NationTarget(3), const NationTarget(3));
    expect(const NationTarget(3) == const PlayerTarget(3), isFalse);
  });
}
```

- [ ] **Step 4: Run them to verify they fail**

Run: `flutter test test/widget/nation_view_test.dart`
Expected: FAIL to compile (`NationView`, `NationTarget`, `openNation` do not exist).

- [ ] **Step 5: `NationTarget`**

In `lib/shared/tablet/detail_pane.dart`, change the `DetailTarget` doc to "What a tablet detail pane is showing: a player (stage 2) or a nation (stage 3); team stats and head to head join in later stages." and add after `PlayerTarget`:

```dart
final class NationTarget extends DetailTarget {
  const NationTarget(this.nationId);

  final int nationId;

  @override
  bool operator ==(Object other) =>
      other is NationTarget && other.nationId == nationId;

  @override
  int get hashCode => Object.hash(NationTarget, nationId);
}
```

(`PlayerTarget.hashCode` stays as it is: equal targets of different kinds are never compared by hash alone.)

- [ ] **Step 6: Extract `NationView`**

In `lib/features/nations/nation_vitrine_screen.dart`, make the screen's `body:` exactly:

```dart
      body: NationView(careerId: careerId, nationId: nationId),
```

delete the screen's `final async = ref.watch(...)` line and its `_sectionLabel` method, and add after the screen class:

```dart
/// A nation's whole record: its honours, how its world standing has moved,
/// its record scorers and its titles. The body of [NationVitrineScreen], on
/// its own so a tablet detail pane can show the same record beside the
/// ranking.
///
/// Scrolls itself; give it a bounded height.
class NationView extends ConsumerWidget {
  const NationView({
    required this.careerId,
    required this.nationId,
    this.padding = const EdgeInsets.all(AppSpacing.marginMobile),
    super.key,
  });

  final int careerId;
  final int nationId;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(
      nationVitrineProvider((careerId: careerId, nationId: nationId)),
    );
    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(l.nationsCouldNotLoad(e.toString()))),
      data: (v) {
        if (v == null) return Center(child: Text(l.nationsNoNation));
        return ListView(
          padding: padding,
          children: [
            // The children of the screen's former ListView, moved verbatim:
            // _Header(v) through the closing SizedBox(height: AppSpacing.lg).
          ],
        );
      },
    );
  }

  Widget _sectionLabel(String text) => Text(
    text,
    style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
  );
}
```

The comment inside `children:` marks a verbatim move, not a placeholder: cut the screen's `ListView` children (from `_Header(v),` to the final `const SizedBox(height: AppSpacing.lg),`) and paste them there unchanged; they read `l`, `v` and `_sectionLabel`, which this class provides under the same names. The screen becomes a `ConsumerWidget` that no longer uses `ref`: keep it a `ConsumerWidget` (its `build` signature unchanged) so the router and tests see the same type.

- [ ] **Step 7: The pane hosts nations**

In `lib/features/shell/detail_pane_host.dart`, import `package:fnm/features/nations/nation_vitrine_screen.dart`, and add a case to the `switch (t)` in `build`:

```dart
      NationTarget(:final nationId) => (
        l.nationsVitrineTitle,
        '${Routes.nationVitrine}?careerId=$careerId&nationId=$nationId',
        NationView(
          // A new nation is a new record: no scroll offset carried over.
          key: ValueKey(('nation', nationId)),
          careerId: careerId,
          nationId: nationId,
        ),
      ),
```

Change the `placeholder` field doc to "What the empty pane says; [AppLocalizations.panePickPlayer] by default. A screen whose pane holds nations passes [AppLocalizations.panePickNation]." and add after `openPlayer`:

```dart
/// Shows a nation's record: in the nearest detail pane when the screen has
/// one, otherwise on its own vitrine page, as every phone screen does.
///
/// From inside a sheet or dialog there is never a pane (see
/// [DetailPaneScope.maybeOf]); close the sheet BEFORE calling this.
void openNation(
  BuildContext context, {
  required int careerId,
  required int nationId,
}) {
  final pane = DetailPaneScope.maybeOf(context);
  if (pane != null) {
    pane.show(NationTarget(nationId));
    return;
  }
  unawaited(
    context.push(
      '${Routes.nationVitrine}?careerId=$careerId&nationId=$nationId',
    ),
  );
}
```

- [ ] **Step 8: Run the tests and the guard, expect PASS**

Run: `flutter test test/widget/nation_view_test.dart test/golden/phone_guard_nation_vitrine_test.dart test/widget/detail_pane_host_test.dart`
Expected: PASS, goldens unchanged.

- [ ] **Step 9: Analyze, full suite, commit**

Run: `flutter analyze && flutter test`

```bash
git add lib/features/nations/nation_vitrine_screen.dart lib/shared/tablet/detail_pane.dart lib/features/shell/detail_pane_host.dart test/widget/nation_view_test.dart
git commit -m "feat(tablet): NationView, and nations in the detail pane

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---
### Task 6: World ranking as a grid with the nation beside it

**risk: low (batched review)**. Read-only.

**Files:**
- Create: `lib/features/ranking/world_ranking_tablet_layout.dart` (part of `world_ranking_screen.dart`)
- Modify: `lib/features/ranking/world_ranking_screen.dart`, `lib/features/shell/tablet_shell.dart`
- Test: `test/golden/phone_guard_ranking_test.dart` (new, with goldens), `test/widget/world_ranking_tablet_test.dart` (new)

**Interfaces:**
- Produces: `WorldRankingScreen.tabletLayoutKey`; `List<GridColumnSet<Nation>> rankingColumnSets(AppLocalizations l, RankingData data)`.
- Consumes: `worldRankingProvider(careerId)`, `selectedRankRegionProvider` (the phone's own two reads, nothing else), `NationView` via `DetailPaneHost(target: NationTarget)`, `openNation`, `DataGrid.controller`, `TabletScreenHeader`, `RankMovementHeader`, `RankMovement`, `_RegionFilter` (reused from the phone file), `l.tourSharedWorldRankingTitle`, `l.rankingCentreOnMe`, `l.gridViewOverview`, `l.gridColRank`, `l.gridColMove`, `l.gridColNation`, `l.gridColRegion`, `l.gridColPoints`, `l.panePickNation`.

The phone's "your ranking over time" chart is not repeated on the tablet: the pane opens on the manager's own nation, whose record carries its ranking history.

- [ ] **Step 1: Pin the phone ranking**

Create `test/golden/phone_guard_ranking_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/ranking/world_ranking_screen.dart';

import '../helpers/seeded_save.dart';

/// The phone ranking, pinned before the tablet layout is added beside it.
void main() {
  for (final (name, size) in [
    ('ranking_phone', kPhoneSize),
    ('ranking_phone_tall', const Size(390, 2400)),
  ]) {
    testWidgets(name, (tester) async {
      final save = await seedSave(tester);
      await pumpRoute(
        tester,
        save,
        '${Routes.ranking}?careerId=${save.careerId}',
        size: size,
      );
      expect(find.byType(RankRow), findsWidgets);
      await expectAppGolden('goldens/$name.png');
    });
  }
}
```

- [ ] **Step 2: Create the baseline, confirm it holds, commit it**

```bash
flutter test --update-goldens test/golden/phone_guard_ranking_test.dart
flutter test test/golden/phone_guard_ranking_test.dart
git add test/golden/phone_guard_ranking_test.dart test/golden/goldens/ranking_phone.png test/golden/goldens/ranking_phone_tall.png
git commit -m "test(tablet): phone guard for the world ranking

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

- [ ] **Step 3: Write the failing tablet test**

Create `test/widget/world_ranking_tablet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/util/competition_label.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/features/nations/nation_vitrine_screen.dart';
import 'package:fnm/features/ranking/world_ranking_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/app_bottom_nav.dart';

import '../helpers/seeded_save.dart';

Future<SeededSave> _open(WidgetTester tester, Size size) async {
  final save = await seedSave(tester, formFactor: FormFactor.tablet);
  await pumpRoute(
    tester,
    save,
    '${Routes.ranking}?careerId=${save.careerId}',
    size: size,
  );
  return save;
}

Finder get _grid => find.byType(DataGrid<Nation>);

void main() {
  for (final size in kTabletSizes) {
    testWidgets('a grid of nations, the manager\'s own beside it, $size', (
      tester,
    ) async {
      final save = await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(WorldRankingScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBottomNav), findsNothing);
      expect(_grid, findsOneWidget);
      expect(
        tester.widget<NationView>(find.byType(NationView)).nationId,
        save.nationId,
      );
      expect(
        tester.getCenter(_grid).dx,
        lessThan(tester.getCenter(find.byType(NationView)).dx),
      );
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('picking a row puts that nation in the pane', (tester) async {
    final save = await _open(tester, kTabletSize);
    final other = tester
        .widget<DataGrid<Nation>>(_grid)
        .rows
        .firstWhere((n) => n.id != save.nationId);
    await tester.tap(
      find.descendant(of: _grid, matching: find.text(other.name)),
    );
    await settle(tester);
    expect(tester.widget<NationView>(find.byType(NationView)).nationId, other.id);
    expect(tester.widget<DataGrid<Nation>>(_grid).selected, other);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a region chip narrows the grid', (tester) async {
    await _open(tester, kTabletSize);
    // The chips come before the grid in the tree.
    await tester.tap(
      find.text(confederationLabel(enL, Confederation.asia).toUpperCase()).first,
    );
    await settle(tester);
    final rows = tester.widget<DataGrid<Nation>>(_grid).rows;
    expect(rows, isNotEmpty);
    expect(rows.every((n) => n.confederation == Confederation.asia), isTrue);
    await tester.pumpWidget(const SizedBox());
  });
}
```

- [ ] **Step 4: Run it to verify it fails**

Run: `flutter test test/widget/world_ranking_tablet_test.dart`
Expected: FAIL to compile (`WorldRankingScreen.tabletLayoutKey` does not exist).

- [ ] **Step 5: Hook in the layout**

In `lib/features/ranking/world_ranking_screen.dart`:

Add the imports `package:fnm/features/shell/detail_pane_host.dart` and `package:fnm/shared/tablet/tablet.dart`, and below the imports `part 'world_ranking_tablet_layout.dart';`.

In `WorldRankingScreen` add:

```dart
  static const Key tabletLayoutKey = Key('ranking.tabletLayout');
```

Make the first line of `_WorldRankingScreenState.build`:

```dart
    if (TabletShellScope.isActive(context)) {
      return _WorldRankingTabletLayout(careerId: widget.careerId);
    }
```

- [ ] **Step 6: The layout**

Create `lib/features/ranking/world_ranking_tablet_layout.dart`:

```dart
part of 'world_ranking_screen.dart';

/// The world ranking on a tablet: every nation in a sortable table, the
/// picked one's record in the pane beside it (the manager's own until he
/// picks another). The phone's two reads, nothing more.
class _WorldRankingTabletLayout extends ConsumerStatefulWidget {
  const _WorldRankingTabletLayout({required this.careerId});

  final int careerId;

  @override
  ConsumerState<_WorldRankingTabletLayout> createState() =>
      _WorldRankingTabletLayoutState();
}

class _WorldRankingTabletLayoutState
    extends ConsumerState<_WorldRankingTabletLayout> {
  final DetailPaneController _pane = DetailPaneController();
  final ScrollController _grid = ScrollController();

  /// The (region, row) the table was last centred on, so a filter change or a
  /// new release re-centres on the manager's nation, and nothing else does.
  ({Confederation? region, int index})? _centredOn;

  @override
  void dispose() {
    _pane.dispose();
    _grid.dispose();
    super.dispose();
  }

  // The grid caches its sort against list identity, and the pane rebuilds
  // this on every pick: keep the same lists until their inputs change.
  RankingData? _rowsData;
  Confederation? _rowsRegion;
  List<Nation> _rows = const [];

  List<Nation> _rowsFor(RankingData data, Confederation? region) {
    if (!identical(_rowsData, data) || _rowsRegion != region) {
      _rowsData = data;
      _rowsRegion = region;
      _rows = [
        for (final n in data.nations)
          if (region == null || n.confederation == region) n,
      ];
    }
    return _rows;
  }

  AppLocalizations? _setsL;
  RankingData? _setsData;
  List<GridColumnSet<Nation>> _sets = const [];

  List<GridColumnSet<Nation>> _setsFor(AppLocalizations l, RankingData data) {
    if (_setsL != l || !identical(_setsData, data)) {
      _setsL = l;
      _setsData = data;
      _sets = rankingColumnSets(l, data);
    }
    return _sets;
  }

  void _centre(int index, {bool animate = false}) {
    if (!mounted || !_grid.hasClients || index < 0) return;
    final viewport = _grid.position.viewportDimension;
    final target =
        (index * DataGrid.rowHeight + DataGrid.rowHeight / 2 - viewport / 2)
            .clamp(0.0, _grid.position.maxScrollExtent);
    if (animate) {
      _grid.animateTo(
        target,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    } else {
      _grid.jumpTo(target);
    }
  }

  void _focus(Confederation? region, int index) {
    if (index < 0) return;
    if (_centredOn?.region == region && _centredOn?.index == index) return;
    _centredOn = (region: region, index: index);
    WidgetsBinding.instance.addPostFrameCallback((_) => _centre(index));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final careerId = widget.careerId;
    final dataAsync = ref.watch(worldRankingProvider(careerId));
    final region = ref.watch(selectedRankRegionProvider);
    return Scaffold(
      key: WorldRankingScreen.tabletLayoutKey,
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorState(
          message: l.rankingCouldNotLoad('').trim(),
          onRetry: () => ref.invalidate(worldRankingProvider(careerId)),
        ),
        data: (data) {
          if (data == null) return Center(child: Text(l.rankingNoRanking));
          final rows = _rowsFor(data, region);
          final sets = _setsFor(l, data);
          final playerIndex = rows.indexWhere(
            (n) => n.id == data.playerNationId,
          );
          _focus(region, playerIndex);
          final now = data.position[data.playerNationId];
          return DetailPaneScope(
            controller: _pane,
            child: ListenableBuilder(
              listenable: _pane,
              builder: (context, _) {
                final target =
                    _pane.value ?? NationTarget(data.playerNationId);
                final selectedId = switch (target) {
                  NationTarget(:final nationId) => nationId,
                  _ => null,
                };
                final selected = rows
                    .where((n) => n.id == selectedId)
                    .firstOrNull;
                return Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: MasterDetail(
                    initialFraction: 0.58,
                    minFraction: 0.45,
                    maxFraction: 0.7,
                    minDetailWidth: 320,
                    master: PanelBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 8, 4, 0),
                            child: TabletScreenHeader(
                              title: l.tourSharedWorldRankingTitle,
                              trailing: IconButton(
                                tooltip: l.rankingCentreOnMe,
                                icon: const Icon(
                                  Icons.my_location_rounded,
                                  color: AppColors.primary,
                                ),
                                onPressed: () =>
                                    _centre(playerIndex, animate: true),
                              ),
                            ),
                          ),
                          RankMovementHeader(
                            baseline: data.baseline,
                            from: now == null
                                ? null
                                : now +
                                      (data.movement[data.playerNationId] ??
                                          0),
                            now: now,
                          ),
                          _RegionFilter(
                            selected: region,
                            onSelect: (r) =>
                                ref
                                        .read(
                                          selectedRankRegionProvider.notifier,
                                        )
                                        .state =
                                    r,
                          ),
                          Expanded(
                            child: DataGrid<Nation>(
                              rows: rows,
                              columnSets: sets,
                              selected: selected,
                              controller: _grid,
                              onSelect: (n) => openNation(
                                context,
                                careerId: careerId,
                                nationId: n.id,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    detail: PanelBox(
                      child: DetailPaneHost(
                        careerId: careerId,
                        target: target,
                        placeholder: l.panePickNation,
                      ),
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

/// The ranking table's one view: place, movement, nation, region, points.
/// Rank sorts best first on the first tap; movement and points biggest first.
List<GridColumnSet<Nation>> rankingColumnSets(
  AppLocalizations l,
  RankingData data,
) {
  return [
    GridColumnSet<Nation>(
      id: 'overview',
      label: l.gridViewOverview,
      columns: [
        GridColumn<Nation>(
          id: 'rank',
          label: l.gridColRank,
          width: 64,
          sortKey: (n) => data.position[n.id] ?? 1 << 20,
          cell: (n) => Text(
            '${data.position[n.id] ?? ''}',
            style: TabletText.cellNumeric,
          ),
        ),
        GridColumn<Nation>(
          id: 'move',
          label: l.gridColMove,
          width: 72,
          numeric: true,
          sortKey: (n) => data.movement[n.id] ?? 0,
          cell: (n) => RankMovement(data.movement[n.id] ?? 0),
        ),
        GridColumn<Nation>(
          id: 'nation',
          label: l.gridColNation,
          flex: 3,
          sortKey: (n) => n.name,
          cell: (n) {
            final mine = n.id == data.playerNationId;
            return Row(
              children: [
                FlagDisc(n.code, size: 22, highlighted: mine),
                const SizedBox(width: AppSpacing.sm),
                Flexible(
                  child: Text(
                    n.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: mine
                        ? TabletText.cell.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          )
                        : null,
                  ),
                ),
              ],
            );
          },
        ),
        GridColumn<Nation>(
          id: 'region',
          label: l.gridColRegion,
          flex: 2,
          sortKey: (n) => n.confederation.index,
          cell: (n) => Text(confederationLabel(l, n.confederation)),
        ),
        GridColumn<Nation>(
          id: 'points',
          label: l.gridColPoints,
          width: 80,
          numeric: true,
          sortKey: (n) => data.points[n.id] ?? 0,
          cell: (n) => Text('${data.points[n.id] ?? 0}'),
        ),
      ],
    ),
  ];
}
```

- [ ] **Step 7: Register, run, expect PASS**

Add `Routes.ranking,` to `tabletReadyPaths` in `lib/features/shell/tablet_shell.dart`.

Run: `flutter test test/widget/world_ranking_tablet_test.dart test/golden/phone_guard_ranking_test.dart test/widget/ranking_movement_test.dart test/widget/tablet_route_sweep_test.dart`
Expected: PASS, phone goldens unchanged.

- [ ] **Step 8: Analyze, full suite, commit**

Run: `flutter analyze && flutter test`

```bash
git add lib/features/ranking lib/features/shell/tablet_shell.dart test/widget/world_ranking_tablet_test.dart
git commit -m "feat(tablet): world ranking as a sortable grid beside the nation's record

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 7: Results as cycles beside their matches; round results carry-over tests

**risk: low (batched review)**. Read-only.

**Files:**
- Create: `lib/features/results/results_tablet_layout.dart` (part of `results_screen.dart`)
- Modify: `lib/features/results/results_screen.dart`, `lib/features/shell/tablet_shell.dart`
- Modify: `test/helpers/round_results_fixture.dart` (two more views)
- Test: `test/golden/phone_guard_results_test.dart` (new, with goldens), `test/widget/results_tablet_test.dart` (new), `test/widget/round_results_tablet_test.dart` (two more cases)

**Interfaces:**
- Produces: `ResultsScreen.tabletLayoutKey`; `RoundResultsView knockoutView()`, `RoundResultsView emptyRoundView()` in the fixture helper.
- Consumes: `resultsProvider(careerId)` (the phone's read), `ResultsScreen.cycles`, `_EarlierHeader` (reused), `l.resultsCyclesTitle`, `l.resultsMyMatches`, `l.resultsCycleTitle`, `l.resultsCycleRecord`, `l.resultsCycleFinish`, `l.resultsCycleUnderway`, `l.resultsNoFixtures`, `l.resultsCouldNotLoad`, `l.resultsVs`, `l.hubYourNation`.

The tablet layout lives in the SAME State as the phone tree (the State hands it its fold state and the picked cycle), so a window crossing 1000 keeps which campaigns are open and which cycle is picked.

- [ ] **Step 1: Pin the phone results**

Create `test/golden/phone_guard_results_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';

import '../helpers/seeded_save.dart';

/// The phone results list, pinned before the tablet layout is added beside
/// it. The qualifying draw is watched first, or every fixture stays hidden.
void main() {
  for (final (name, size) in [
    ('results_phone', kPhoneSize),
    ('results_phone_tall', const Size(390, 2400)),
  ]) {
    testWidgets(name, (tester) async {
      final save = await seedSave(tester);
      await watchContinentalQualifyingDraw(tester, save);
      await pumpRoute(
        tester,
        save,
        '${Routes.results}?careerId=${save.careerId}',
        size: size,
      );
      expect(find.text(enL.resultsNoFixtures), findsNothing);
      await expectAppGolden('goldens/$name.png');
    });
  }
}
```

- [ ] **Step 2: Create the baseline, confirm it holds, commit it**

```bash
flutter test --update-goldens test/golden/phone_guard_results_test.dart
flutter test test/golden/phone_guard_results_test.dart
git add test/golden/phone_guard_results_test.dart test/golden/goldens/results_phone.png test/golden/goldens/results_phone_tall.png
git commit -m "test(tablet): phone guard for the results list

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

- [ ] **Step 3: Write the failing tests**

Append to `test/helpers/round_results_fixture.dart`:

```dart
/// A knockout round: two quarter-finals, the manager's nation 1 in the first.
RoundResultsView knockoutView() {
  Fixture qf(int id, int home, int away) => Fixture(
    id: id,
    careerId: 1,
    competitionId: 2,
    matchday: 1,
    date: DateTime(2028, 6, 30),
    homeNationId: home,
    awayNationId: away,
    homeScore: 2,
    awayScore: 1,
    round: 'CQF',
    played: true,
  );
  return (
    results: (
      competition: 'European Championship',
      kind: CompetitionKind.continentalFinals,
      groupCount: 0,
      matchday: 1,
      groups: const <RoundResultGroup>[],
      stage: 'QUARTER-FINALS',
      knockoutFixtures: [qf(1, 1, 2), qf(2, 3, 4)],
    ),
    nations: {for (var i = 1; i <= 4; i++) i: nation(id: i)},
    playerNationId: 1,
    directCount: 2,
    contentionPos: null,
    relegateCount: 0,
    noRelegationGroups: const <String>{},
  );
}

/// A friendly window: no competition round at all.
RoundResultsView emptyRoundView() => (
  results: null,
  nations: {for (var i = 1; i <= 4; i++) i: nation(id: i)},
  playerNationId: 1,
  directCount: 2,
  contentionPos: null,
  relegateCount: 0,
  noRelegationGroups: const <String>{},
);
```

Add `import 'package:fnm/domain/repositories/competition_repository.dart';` to the helper for `RoundResultGroup`.

Append to `test/widget/round_results_tablet_test.dart`, inside `main`:

```dart
  for (final size in kTabletSizes) {
    testWidgets('a knockout round: one column of ties, no tables, $size', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpApp(
        const TabletShellScope(child: RoundResultsScreen(careerId: 1)),
        overrides: [
          roundResultsViewProvider(1).overrideWith((ref) async => knockoutView()),
          otherFriendliesProvider(1).overrideWith((ref) async => const []),
        ],
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byKey(RoundResultsScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(MatchResultRow), findsNWidgets(2));
      expect(find.text('QUARTER-FINALS'), findsOneWidget);
      // One column, centred: both ties share a left edge.
      final rows = find.byType(MatchResultRow);
      expect(tester.getRect(rows.at(0)).left, tester.getRect(rows.at(1)).left);
      expect(find.text(enL.resultsGroup('A').toUpperCase()), findsNothing);
    });

    testWidgets('a friendly window: the other friendlies in one panel, $size', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpApp(
        const TabletShellScope(child: RoundResultsScreen(careerId: 1)),
        overrides: [
          roundResultsViewProvider(1).overrideWith((ref) async => emptyRoundView()),
          otherFriendliesProvider(1).overrideWith(
            (ref) async => const [
              (homeId: 1, awayId: 2, homeScore: 1, awayScore: 1),
              (homeId: 3, awayId: 4, homeScore: 0, awayScore: 2),
            ],
          ),
        ],
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(
        find.text(enL.resultsFriendlyInternationals.toUpperCase()),
        findsOneWidget,
      );
      expect(find.text(enL.resultsContinue), findsOneWidget);
    });
  }
```

(`resultsFriendlyInternationals` is already upper case in English; `toUpperCase()` matches the `Panel`'s title either way.)

Create `test/widget/results_tablet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/results/results_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/seeded_save.dart';

Future<SeededSave> _open(WidgetTester tester, Size size) async {
  final save = await seedSave(tester, formFactor: FormFactor.tablet);
  await watchContinentalQualifyingDraw(tester, save);
  await pumpRoute(
    tester,
    save,
    '${Routes.results}?careerId=${save.careerId}',
    size: size,
  );
  return save;
}

void main() {
  for (final size in kTabletSizes) {
    testWidgets('cycles left, the picked cycle\'s matches right, $size', (
      tester,
    ) async {
      final save = await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(ResultsScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(MasterDetail), findsOneWidget);
      final me = save.nations.firstWhere((n) => n.id == save.nationId);
      // Scoped: the top bar names the nation too.
      final cycle = find.descendant(
        of: find.byType(MasterDetail),
        matching: find.textContaining(me.name),
      );
      expect(cycle, findsWidgets);
      // A competition panel on the right, with its fixtures in it.
      final panel = find.byType(Panel);
      expect(panel, findsWidgets);
      expect(
        tester.getCenter(cycle.first).dx,
        lessThan(tester.getCenter(panel.last).dx),
      );
      expect(find.text(enL.resultsCycleUnderway), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });
  }
}
```

- [ ] **Step 4: Run them to verify they fail**

Run: `flutter test test/widget/results_tablet_test.dart test/widget/round_results_tablet_test.dart`
Expected: the results test FAILS to compile (`ResultsScreen.tabletLayoutKey`); the two new round-results cases PASS already (they pin existing stage 2 branches; that is their job).

- [ ] **Step 5: Hook in the layout**

In `lib/features/results/results_screen.dart`:

Add the import `package:fnm/shared/tablet/tablet.dart` and below the imports `part 'results_tablet_layout.dart';`.

In `ResultsScreen` add:

```dart
  static const Key tabletLayoutKey = Key('results.tabletLayout');
```

In `_ResultsScreenState` add the field after `_cycles`:

```dart
  /// The cycle the tablet layout shows; the one being played until he picks.
  int? _picked;
```

and make the first lines of `build`:

```dart
    if (TabletShellScope.isActive(context)) {
      return _ResultsTabletLayout(
        careerId: careerId,
        picked: _picked,
        onPick: (c) => setState(() => _picked = c),
        opened: _opened,
        onToggleEarlier: (key) => setState(() {
          if (!_opened.remove(key)) _opened.add(key);
        }),
      );
    }
```

- [ ] **Step 6: The layout**

Create `lib/features/results/results_tablet_layout.dart`:

```dart
part of 'results_screen.dart';

/// The manager's matches on a tablet: his cycles listed on the left, the
/// picked one's competitions on the right, each a panel of dense rows. The
/// phone's read and its folding, with the fold state kept by the screen.
class _ResultsTabletLayout extends ConsumerWidget {
  const _ResultsTabletLayout({
    required this.careerId,
    required this.picked,
    required this.onPick,
    required this.opened,
    required this.onToggleEarlier,
  });

  final int careerId;
  final int? picked;
  final ValueChanged<int> onPick;

  /// The campaigns whose earlier matches are open, keyed as the phone keys
  /// them (`cycle|section`), so both layouts agree.
  final Set<String> opened;
  final ValueChanged<String> onToggleEarlier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final dataAsync = ref.watch(resultsProvider(careerId));
    return Scaffold(
      key: ResultsScreen.tabletLayoutKey,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TabletScreenHeader(title: l.resultsMyMatches),
            Expanded(
              child: dataAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) =>
                    Center(child: Text(l.resultsCouldNotLoad(e.toString()))),
                data: (data) {
                  if (data == null || data.fixtures.isEmpty) {
                    return Center(child: Text(l.resultsNoFixtures));
                  }
                  final cycles = ResultsScreen.cycles(l, data);
                  final shown =
                      cycles.where((c) => c.cycle == picked).firstOrNull ??
                      cycles.first;
                  String code(int id) => data.nations[id]?.code ?? '??';
                  return MasterDetail(
                    initialFraction: 0.32,
                    minFraction: 0.25,
                    maxFraction: 0.45,
                    minDetailWidth: 480,
                    master: Panel(
                      title: l.resultsCyclesTitle,
                      expand: true,
                      padding: EdgeInsets.zero,
                      child: ListView(
                        children: [
                          for (final c in cycles)
                            _CycleListRow(
                              cycle: c,
                              selected: c.cycle == shown.cycle,
                              onTap: () => onPick(c.cycle),
                            ),
                        ],
                      ),
                    ),
                    detail: ListView(
                      children: [
                        for (final section in shown.sections)
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.md,
                            ),
                            child: _section(
                              l,
                              section,
                              '${shown.cycle}|${section.key}',
                              code,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(
    AppLocalizations l,
    ResultSection section,
    String key,
    String Function(int) code,
  ) {
    final open = opened.contains(key);
    return Panel(
      title: section.key,
      action: Padding(
        padding: const EdgeInsets.only(left: AppSpacing.sm),
        child: Text(
          '${section.current.length + section.older.length}',
          style: TabletText.barMeta,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final f in section.current)
            _TabletResultRow(fixture: f, code: code),
          if (section.older.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            _EarlierHeader(
              count: section.older.length,
              open: open,
              onTap: () => onToggleEarlier(key),
            ),
            if (open)
              for (final f in section.older)
                _TabletResultRow(fixture: f, code: code),
          ],
        ],
      ),
    );
  }
}

/// One cycle in the tablet list: the same four facts as the phone's fold.
class _CycleListRow extends StatelessWidget {
  const _CycleListRow({
    required this.cycle,
    required this.selected,
    required this.onTap,
  });

  final ResultsCycle cycle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final finish = cycle.finish;
    return Material(
      color: selected ? AppColors.surfaceContainerHighest : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.divider)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.resultsCycleTitle(
                  cycle.year,
                  cycle.nation?.name ?? l.hubYourNation,
                ),
                maxLines: 2,
                style: TabletText.cell.copyWith(
                  fontWeight: FontWeight.w700,
                  color: selected ? AppColors.primary : null,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                l.resultsCycleRecord(
                  cycle.played,
                  cycle.won,
                  cycle.drawn,
                  cycle.lost,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TabletText.barMeta,
              ),
              Text(
                finish == null
                    ? l.resultsCycleUnderway
                    : l.resultsCycleFinish(cycleFinishLabel(l, finish)),
                maxLines: 2,
                style: TabletText.sectionLabel.copyWith(
                  color: finish == CycleFinish.champions
                      ? AppColors.primary
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One match as a table row: date, stage, home, score, away.
class _TabletResultRow extends StatelessWidget {
  const _TabletResultRow({required this.fixture, required this.code});

  final Fixture fixture;
  final String Function(int) code;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final f = fixture;
    return Container(
      height: DataGrid.rowHeight,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 104,
            child: Text(
              AppDate.dayMonthYear(context, f.date),
              maxLines: 1,
              style: TabletText.cellNumeric,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              MatchStage.stage(l, f.round),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TabletText.cell.copyWith(color: AppColors.primary),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(code(f.homeNationId), style: TabletText.cell),
                const SizedBox(width: AppSpacing.sm),
                FlagDisc(code(f.homeNationId), size: 20),
              ],
            ),
          ),
          SizedBox(
            width: 64,
            child: Text(
              f.hasResult ? '${f.homeScore} - ${f.awayScore}' : l.resultsVs,
              textAlign: TextAlign.center,
              style: f.hasResult
                  ? TabletText.cellNumeric.copyWith(fontWeight: FontWeight.w700)
                  : TabletText.cell.copyWith(color: AppColors.onSurfaceVariant),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                FlagDisc(code(f.awayNationId), size: 20),
                const SizedBox(width: AppSpacing.sm),
                Text(code(f.awayNationId), style: TabletText.cell),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

(`AppColors.divider` is the grid's row rule, a getter, so the decorations are not `const`; `cycleFinishLabel` and `CycleFinish` come from `career_label.dart` and `cycle_finish.dart`, both already imported by the screen. The score separator is a plain hyphen, as on the phone.)

- [ ] **Step 7: Register, run, expect PASS**

Add `Routes.results,` to `tabletReadyPaths`.

Run: `flutter test test/widget/results_tablet_test.dart test/widget/round_results_tablet_test.dart test/golden/phone_guard_results_test.dart test/widget/results_cycles_test.dart test/widget/results_order_test.dart test/widget/tablet_route_sweep_test.dart`
Expected: PASS, phone goldens unchanged.

- [ ] **Step 8: Analyze, full suite, commit**

Run: `flutter analyze && flutter test`

```bash
git add lib/features/results lib/features/shell/tablet_shell.dart test/helpers/round_results_fixture.dart test/widget/results_tablet_test.dart test/widget/round_results_tablet_test.dart
git commit -m "feat(tablet): results as cycles beside their matches; round results knockout and friendlies tests

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---
### Task 8: World Championship detail: `CupDetailView`, groups in a grid, bracket full width

**risk: low (batched review)**. Read-only; the tab bodies move into a shared function (Review Focus 5).

**Files:**
- Create: `lib/features/tournaments/cup_detail_view.dart` (part of `cup_detail_screen.dart`)
- Modify: `lib/features/tournaments/cup_detail_screen.dart`, `lib/features/shell/tablet_shell.dart`, `test/helpers/seeded_save.dart` (`showTab`)
- Test: `test/golden/phone_guard_cup_detail_test.dart` (new, with goldens), `test/widget/cup_detail_tablet_test.dart` (new)

**Interfaces:**
- Produces:
  - `class CupDetailView extends ConsumerWidget { const CupDetailView({required int careerId, Key? key}); }`: tab bar plus bodies, no Scaffold; fills the area it is given.
  - `CupDetailScreen.tabletLayoutKey`.
  - In the library: `List<Tab> _cupTabs(AppLocalizations l)`, `List<Widget> _cupTabViews(BuildContext context, CupData data, {required int careerId, bool grid = false})`; `_Qualifying({..., bool grid = false})`, `_FinalsGroups({..., bool grid = false})`.
  - In `seeded_save.dart`: `Future<void> showTab(WidgetTester tester, int tab, {int controller = 0})`.
- Consumes: `cupDetailProvider(careerId)`, `wcHostThemeProvider(careerId)` (the phone's two reads), `intercontinentalPlayoffProvider` (inside the Play-off tab, as on the phone), `ColumnFlow`, `TabletScreenHeader`, `TournamentBracket.wide`, `l.tourCupTitle`.

- [ ] **Step 1: A tab helper, and the phone guard**

Append to `test/helpers/seeded_save.dart`:

```dart
/// Moves the [controller]th tab bar in the tree (0, the outermost, by
/// default) to [tab], as a tap on that tab would, and lets the page land.
/// For tabs a narrow scrolling tab bar has scrolled out of reach.
Future<void> showTab(WidgetTester tester, int tab, {int controller = 0}) async {
  final element = tester.element(find.byType(TabBarView).at(controller));
  DefaultTabController.of(element).index = tab;
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 600));
}
```

Create `test/golden/phone_guard_cup_detail_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/tournaments/cup_detail_providers.dart';

import '../helpers/competition_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The phone World Championship screen on a finals-stage edition, pinned
/// before its tab bodies move into shared code: the bracket it lands on, and
/// the qualifying and finals group tabs, each in full.
void main() {
  for (final (name, size, tab) in [
    ('cup_detail_phone', kPhoneSize, null),
    ('cup_detail_phone_bracket_tall', const Size(390, 2000), null),
    ('cup_detail_phone_qualifying_tall', const Size(390, 2400), 1),
    ('cup_detail_phone_finals_tall', const Size(390, 2400), 3),
  ]) {
    testWidgets(name, (tester) async {
      final save = await seedSave(
        tester,
        overrides: [
          cupDetailProvider(
            kSeededCareerId,
          ).overrideWith((ref) async => fakeCupData(seededNationId)),
        ],
      );
      await pumpRoute(
        tester,
        save,
        '${Routes.cup}?careerId=${save.careerId}',
        size: size,
      );
      if (tab != null) await showTab(tester, tab);
      expect(tester.takeException(), isNull);
      await expectAppGolden('goldens/$name.png');
    });
  }
}
```

- [ ] **Step 2: Create the baseline, confirm it holds, commit it**

```bash
flutter test --update-goldens test/golden/phone_guard_cup_detail_test.dart
flutter test test/golden/phone_guard_cup_detail_test.dart
git add test/helpers/seeded_save.dart test/golden/phone_guard_cup_detail_test.dart test/golden/goldens/cup_detail_phone*.png
git commit -m "test(tablet): phone guard for the World Championship screen

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

Open the four PNGs: the bracket list (with the run summary and champion), the bracket tall, six qualifying groups of five, eight finals groups.

- [ ] **Step 3: Write the failing tablet test**

Create `test/widget/cup_detail_tablet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/tournaments/cup_detail_providers.dart';
import 'package:fnm/features/tournaments/cup_detail_screen.dart';
import 'package:fnm/features/tournaments/tournament_bracket.dart';

import '../helpers/competition_fixtures.dart';
import '../helpers/seeded_save.dart';

Future<void> _open(WidgetTester tester, Size size) async {
  final save = await seedSave(
    tester,
    formFactor: FormFactor.tablet,
    overrides: [
      cupDetailProvider(
        kSeededCareerId,
      ).overrideWith((ref) async => fakeCupData(seededNationId)),
    ],
  );
  await pumpRoute(
    tester,
    save,
    '${Routes.cup}?careerId=${save.careerId}',
    size: size,
  );
}

/// Two group headings side by side: same top, the second to the right.
void _sideBySide(WidgetTester tester, String a, String b) {
  final ra = tester.getRect(find.text(a).hitTestable());
  final rb = tester.getRect(find.text(b).hitTestable());
  expect(ra.top, rb.top, reason: '$a and $b share a row');
  expect(rb.left, greaterThan(ra.right));
}

void main() {
  for (final size in kTabletSizes) {
    testWidgets('the tabs fill the area, the bracket opens full width, $size', (
      tester,
    ) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(CupDetailScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(CupDetailView), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      expect(
        tester.widget<TournamentBracket>(find.byType(TournamentBracket)).wide,
        isTrue,
      );
      // Opened as the bracket, its columns wider than a phone's 150.
      final r16 = tester.getCenter(find.text('R16'));
      final last = tester.getCenter(find.text('Final'));
      expect(last.dx - r16.dx, greaterThan(3 * 158));
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('qualifying and finals groups sit in columns, $size', (
      tester,
    ) async {
      await _open(tester, size);
      await showTab(tester, 1);
      expect(tester.takeException(), isNull);
      _sideBySide(tester, enL.tourCupGroupName('A'), enL.tourCupGroupName('B'));
      await showTab(tester, 3);
      expect(tester.takeException(), isNull);
      _sideBySide(tester, enL.tourCupGroupName('A'), enL.tourCupGroupName('B'));
      await tester.pumpWidget(const SizedBox());
    });
  }
}
```

- [ ] **Step 4: Run it to verify it fails**

Run: `flutter test test/widget/cup_detail_tablet_test.dart`
Expected: FAIL to compile (`CupDetailScreen.tabletLayoutKey`, `CupDetailView` do not exist).

- [ ] **Step 5: Move the tabs and their bodies into shared functions**

In `lib/features/tournaments/cup_detail_screen.dart`:

1. Add the import `package:fnm/shared/tablet/tablet.dart` and below the imports `part 'cup_detail_view.dart';`.

2. Add top-level, after the `CupDetailScreen` class:

```dart
/// The World Championship's nine tabs, in the order [_cupTabViews] builds
/// their bodies.
List<Tab> _cupTabs(AppLocalizations l) => [
  Tab(text: l.tourCupTabSummary),
  Tab(text: l.tourCupTabQualifying),
  Tab(text: l.tourCupTabPlayoff),
  Tab(text: l.tourCupTabFinals),
  Tab(text: l.tourCupTabBracket),
  Tab(text: l.tourCupTabAwards),
  Tab(text: l.tourCupTabScorers),
  Tab(text: l.tourCupTabHistory),
  Tab(text: l.tourCupTabRecords),
];

/// The nine tab bodies. Shared by the phone screen and [CupDetailView]:
/// [grid] (a tablet) lays the group tables out in columns and opens the
/// bracket full width.
List<Widget> _cupTabViews(
  BuildContext context,
  CupData data, {
  required int careerId,
  bool grid = false,
}) {
  final l = AppLocalizations.of(context);
  String code(int id) => data.nations[id]?.code ?? '??';
  String name(int id) => data.nations[id]?.name ?? l.tourCupUnknown;
  return [
    // MOVED VERBATIM: the nine children of the phone's
    // `TabBarView(children: [...])`, from `TournamentSummaryTab(` to the
    // closing `TournamentStatsTab(...)`, with exactly three edits:
    //   _Qualifying(...)       gains  grid: grid,
    //   _FinalsGroups(...)     gains  grid: grid,
    //   TournamentBracket(...) gains  wide: grid,
  ];
}
```

The comment marks a cut-and-paste, not code to write: move the nine children there, make the three edits, delete the comment. Their comments move with them.

3. In `CupDetailScreen.build`, replace the `tabs: [ ... ]` list of the `TabBar` with `tabs: _cupTabs(l),` and the `TabBarView(children: [...])` with:

```dart
                  child: TabBarView(
                    children: _cupTabViews(context, data, careerId: careerId),
                  ),
```

The phone keeps its own `code`/`name` closures for the host banner and the holders row.

4. `_Qualifying`: add `this.grid = false,` to the constructor and the field

```dart
  /// A tablet: each confederation's groups in columns rather than stacked.
  final bool grid;
```

In `_QualifyingState._list`, replace the inner loop

```dart
          for (final g in _mineFirst(byConf[conf]!, widget.playerNationId)) ...[
            () { ... return _GroupCard(...); }(),
            const SizedBox(height: AppSpacing.sm),
          ],
```

with `..._groupCards(conf, byConf),` and add to `_QualifyingState`:

```dart
  /// [conf]'s group tables, the manager's own first: stacked with a gap under
  /// each on a phone, in columns on a tablet.
  List<Widget> _groupCards(
    Confederation conf,
    Map<Confederation, List<ConfederationGroupTable>> byConf,
  ) {
    final adv = GroupAdvancement.worldCupQualifying(
      conf,
      byConf[conf]!.length,
    );
    final cards = [
      for (final g in _mineFirst(byConf[conf]!, widget.playerNationId))
        _GroupCard(
          group: g,
          playerNationId: widget.playerNationId,
          code: widget.code,
          name: widget.name,
          directCount: adv.direct,
          contentionPos: adv.contention,
        ),
    ];
    if (widget.grid) {
      return [ColumnFlow(children: cards), const SizedBox(height: AppSpacing.sm)];
    }
    return [
      for (final card in cards) ...[card, const SizedBox(height: AppSpacing.sm)],
    ];
  }
```

(The phone computed `adv` once per group with the same arguments; the cards and gaps are the same widgets in the same order.)

5. `_FinalsGroups`: add `this.grid = false,` and `final bool grid;` (same doc). In `build`, replace

```dart
        for (final g in ordered) ...[
          _GroupCard( ... matches: matchesOf(g), ),
          const SizedBox(height: AppSpacing.md),
        ],
```

with

```dart
        if (grid) ...[
          ColumnFlow(children: [for (final g in ordered) card(g)]),
          const SizedBox(height: AppSpacing.md),
        ] else
          for (final g in ordered) ...[
            card(g),
            const SizedBox(height: AppSpacing.md),
          ],
```

and define, after `matchesOf`:

```dart
    Widget card(FinalsGroupTable g) => _GroupCard(
      group: (
        confederation: Confederation.europe,
        groupName: g.name,
        standings: g.standings,
      ),
      playerNationId: playerNationId,
      code: code,
      name: name,
      contentionPos: qualifyThirds > 0 ? 3 : null,
      matches: matchesOf(g),
    );
```

6. Make the first line of `CupDetailScreen.build`:

```dart
    if (TabletShellScope.isActive(context)) {
      return _CupDetailTabletLayout(careerId: careerId);
    }
```

and add to `CupDetailScreen`:

```dart
  static const Key tabletLayoutKey = Key('cupDetail.tabletLayout');
```

- [ ] **Step 6: The view and the tablet page**

Create `lib/features/tournaments/cup_detail_view.dart`:

```dart
part of 'cup_detail_screen.dart';

/// The World Championship's tabs and their bodies for a tablet: the tab bar
/// across the top of whatever area it is given, the host strip and the
/// holders under it, then the tab on show. Group tables come in columns and
/// the bracket opens full width. The tablet page and the Tournaments
/// screen's right-hand pane both show this.
class CupDetailView extends ConsumerWidget {
  const CupDetailView({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final dataAsync = ref.watch(cupDetailProvider(careerId));
    final liveTab = CupDetailScreen._liveTab(dataAsync.valueOrNull);
    // Once the opening ceremony has run, the WC takes on the host's colours.
    final host = ref.watch(wcHostThemeProvider(careerId)).valueOrNull;
    final themed = host?.active ?? false;
    final accent = themed ? host!.accent : AppColors.primary;
    return DefaultTabController(
      // See CupDetailScreen: initialIndex is read once, before the data lands.
      key: ValueKey(liveTab),
      length: 9,
      initialIndex: liveTab,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: AppColors.surfaceContainer,
            child: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: themed ? accent : AppColors.onSurface,
              unselectedLabelColor: AppColors.onSurfaceVariant,
              indicatorColor: accent,
              tabs: _cupTabs(l),
            ),
          ),
          Expanded(
            child: dataAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) =>
                  Center(child: Text(l.tourCupLoadError(e.toString()))),
              data: (data) {
                if (data == null) return Center(child: Text(l.tourCupNoData));
                String code(int id) => data.nations[id]?.code ?? '??';
                String name(int id) =>
                    data.nations[id]?.name ?? l.tourCupUnknown;
                return Column(
                  children: [
                    if (themed && host != null)
                      WcHostBanner(theme: host, code: code),
                    TournamentHoldersRow(
                      holders: data.holders,
                      code: code,
                      name: name,
                    ),
                    Expanded(
                      child: TabBarView(
                        children: _cupTabViews(
                          context,
                          data,
                          careerId: careerId,
                          grid: true,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// The World Championship page on a tablet: its heading over [CupDetailView]
/// in one panel filling the content area.
class _CupDetailTabletLayout extends ConsumerWidget {
  const _CupDetailTabletLayout({required this.careerId});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final host = ref.watch(wcHostThemeProvider(careerId)).valueOrNull;
    final accent = (host?.active ?? false) ? host!.accent : null;
    return Scaffold(
      key: CupDetailScreen.tabletLayoutKey,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TabletScreenHeader(
              title: l.tourCupTitle,
              accent: accent,
              onBack: () =>
                  context.go('${Routes.tournaments}?careerId=$careerId'),
            ),
            Expanded(child: PanelBox(child: CupDetailView(careerId: careerId))),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 7: The move must not show on the phone**

Run: `flutter test test/golden/phone_guard_cup_detail_test.dart test/widget/tournament_tabs_test.dart`
Expected: PASS with all four goldens unchanged. A changed golden means the move changed a phone widget: fix the move, never the golden.

- [ ] **Step 8: Register, run, expect PASS**

Add `Routes.cup,` to `tabletReadyPaths`. (The `/continental` route without a valid `conf` also builds `CupDetailScreen`; it joins in Task 9.)

Run: `flutter test test/widget/cup_detail_tablet_test.dart test/golden/phone_guard_cup_detail_test.dart test/widget/tournament_tabs_test.dart test/widget/tournament_bracket_test.dart test/widget/tablet_route_sweep_test.dart`
Expected: PASS, phone goldens unchanged.

- [ ] **Step 9: Analyze, full suite, commit**

Run: `flutter analyze && flutter test`

```bash
git add lib/features/tournaments/cup_detail_screen.dart lib/features/tournaments/cup_detail_view.dart lib/features/shell/tablet_shell.dart test/widget/cup_detail_tablet_test.dart
git commit -m "feat(tablet): World Championship tabs with groups in columns and a full-width bracket

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 9: Continental detail: `ContinentalDetailView`

**risk: low (batched review)**. Read-only; tab bodies move (Review Focus 5).

**Files:**
- Create: `lib/features/tournaments/continental_detail_view.dart` (part of `continental_detail_screen.dart`)
- Modify: `lib/features/tournaments/continental_detail_screen.dart`, `lib/features/shell/tablet_shell.dart`
- Test: `test/golden/phone_guard_continental_detail_test.dart` (new, with goldens), `test/widget/continental_detail_tablet_test.dart` (new)

**Interfaces:**
- Produces:
  - `class ContinentalDetailView extends ConsumerWidget { const ContinentalDetailView({required int careerId, required Confederation confederation, Key? key}); }`
  - `ContinentalDetailScreen.tabletLayoutKey`.
  - In the library: `static bool _hasQualifyingFor(Confederation c)`, `static int _liveTabFor(Confederation c, ContinentalData? data)` on the screen; `List<Tab> _continentalTabs(AppLocalizations l, Confederation c)`; `List<Widget> _continentalTabViews(BuildContext context, ContinentalData data, {required Confederation confederation, bool grid = false})`; `_Groups({..., bool grid = false})`, `_ContFinalsGroups({..., bool grid = false})`.
- Consumes: `continentalDetailProvider((careerId:, confederation:))` (the phone's one read; always with the confederation it was given), `ColumnFlow`, `TabletScreenHeader`, `TournamentBracket.wide`, `l.tourContChampionship`, `competitionLabel`.

- [ ] **Step 1: Pin the phone continental screen**

Create `test/golden/phone_guard_continental_detail_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/entities/enums.dart';

import '../helpers/seeded_save.dart';

/// The phone European Championship screen on the seeded save, its qualifying
/// draw watched, so it lands on the qualifying groups: pinned before its tab
/// bodies move into shared code.
void main() {
  for (final (name, size) in [
    ('continental_detail_phone', kPhoneSize),
    ('continental_detail_phone_tall', const Size(390, 3200)),
  ]) {
    testWidgets(name, (tester) async {
      final save = await seedSave(tester);
      await watchContinentalQualifyingDraw(tester, save);
      await pumpRoute(
        tester,
        save,
        '${Routes.continental}?careerId=${save.careerId}'
        '&conf=${Confederation.europe.name}',
        size: size,
      );
      expect(tester.takeException(), isNull);
      await expectAppGolden('goldens/$name.png');
    });
  }
}
```

- [ ] **Step 2: Create the baseline, confirm it holds, commit it**

```bash
flutter test --update-goldens test/golden/phone_guard_continental_detail_test.dart
flutter test test/golden/phone_guard_continental_detail_test.dart
git add test/golden/phone_guard_continental_detail_test.dart test/golden/goldens/continental_detail_phone*.png
git commit -m "test(tablet): phone guard for the continental championship screen

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

Open the tall PNG: it must show the qualifying groups (not "groups to be drawn").

- [ ] **Step 3: Write the failing tablet test**

Create `test/widget/continental_detail_tablet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/tournaments/continental_detail_providers.dart';
import 'package:fnm/features/tournaments/continental_detail_screen.dart';

import '../helpers/seeded_save.dart';

void main() {
  for (final size in kTabletSizes) {
    testWidgets('qualifying groups in columns, the cup named, $size', (
      tester,
    ) async {
      final save = await seedSave(tester, formFactor: FormFactor.tablet);
      await watchContinentalQualifyingDraw(tester, save);
      await pumpRoute(
        tester,
        save,
        '${Routes.continental}?careerId=${save.careerId}'
        '&conf=${Confederation.europe.name}',
        size: size,
      );
      expect(tester.takeException(), isNull);
      expect(find.byKey(ContinentalDetailScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(
        tester
            .widget<ContinentalDetailView>(find.byType(ContinentalDetailView))
            .confederation,
        Confederation.europe,
      );

      late ContinentalData data;
      await tester.runAsync(() async {
        final sub = save.container.listen(
          continentalDetailProvider((
            careerId: save.careerId,
            confederation: Confederation.europe,
          )).future,
          (_, _) {},
        );
        data = (await sub.read())!;
        sub.close();
      });
      // The manager's group first, the next beside it.
      final groups = data.qualifyingGroups;
      final mine = groups.firstWhere(
        (g) => g.standings.any((s) => s.nationId == save.nationId),
      );
      final next = groups.firstWhere((g) => g.name != mine.name);
      final a = tester.getRect(
        find.text(enL.tourContGroupHeading(mine.name)).hitTestable(),
      );
      final b = tester.getRect(
        find.text(enL.tourContGroupHeading(next.name)).hitTestable(),
      );
      expect(a.top, b.top);
      expect(b.left, greaterThan(a.right));
      await tester.pumpWidget(const SizedBox());
    });
  }
}
```

- [ ] **Step 4: Run it to verify it fails**

Run: `flutter test test/widget/continental_detail_tablet_test.dart`
Expected: FAIL to compile (`ContinentalDetailScreen.tabletLayoutKey`, `ContinentalDetailView` do not exist).

- [ ] **Step 5: Move the tabs and their bodies into shared functions**

In `lib/features/tournaments/continental_detail_screen.dart`:

1. Add the import `package:fnm/shared/tablet/tablet.dart` and `part 'continental_detail_view.dart';`.

2. In `ContinentalDetailScreen`, replace `_hasQualifying` and `_liveTab` with static versions keyed on the confederation, keeping the instance ones as one-line delegates (their doc comments move to the static ones):

```dart
  static bool _hasQualifyingFor(Confederation c) =>
      ContinentalCups.byConfederation[c]?.qualifying ?? true;

  bool get _hasQualifying => _hasQualifyingFor(confederation);

  static int _liveTabFor(Confederation c, ContinentalData? data) {
    final finals = _hasQualifyingFor(c) ? 2 : 1;
    final bracket = finals + 1;
    final history = bracket + 3; // awards, scorers, history
    if (data == null) return 0;
    if (!data.isPlayerRegion) {
      return data.knockout.isNotEmpty ? bracket : history;
    }
    if (data.knockout.isNotEmpty) return bracket;
    if (data.groups.isNotEmpty && data.finalsDrawWatched) return finals;
    return 1;
  }

  int _liveTab(ContinentalData? data) => _liveTabFor(confederation, data);
```

(Keep the original body's comments in `_liveTabFor`.)

3. Add top-level, after the screen class:

```dart
/// A continental championship's tabs, in the order [_continentalTabViews]
/// builds their bodies. A cup the whole confederation plays has no
/// qualifying tab.
List<Tab> _continentalTabs(AppLocalizations l, Confederation c) => [
  Tab(text: l.tourContTabSummary),
  if (ContinentalDetailScreen._hasQualifyingFor(c))
    Tab(text: l.tourContTabQualifying),
  Tab(text: l.tourContTabFinals),
  Tab(text: l.tourContTabBracket),
  Tab(text: l.tourContTabAwards),
  Tab(text: l.tourContTabScorers),
  Tab(text: l.tourContTabHistory),
  Tab(text: l.tourContTabRecords),
];

/// The tab bodies. Shared by the phone screen and [ContinentalDetailView]:
/// [grid] (a tablet) lays the group tables out in columns and opens the
/// bracket full width.
List<Widget> _continentalTabViews(
  BuildContext context,
  ContinentalData data, {
  required Confederation confederation,
  bool grid = false,
}) {
  final l = AppLocalizations.of(context);
  String code(int id) => data.nations[id]?.code ?? '??';
  String name(int id) => data.nations[id]?.name ?? l.tourContUnknown;

  // MOVED VERBATIM from the phone's data callback: `Widget qualifyingTab()`,
  // with one edit: its `_Groups(...)` gains  grid: grid,

  return [
    // MOVED VERBATIM: the children of the phone's `TabBarView(children:
    // [...])` (`final tabs = TabBarView(...)`), with these edits:
    //   `if (_hasQualifying) qualifyingTab(),` becomes
    //     `if (ContinentalDetailScreen._hasQualifyingFor(confederation))
    //       qualifyingTab(),`
    //   _ContFinalsGroups(...)  gains  grid: grid,
    //   TournamentBracket(...)  gains  wide: grid,
    //   `ContinentalDetailScreen._bracketRounds` / `._ladder` replace the
    //   bare `_bracketRounds` / `_ladder`.
  ];
}
```

Move the code the comments name, make the listed edits, delete the comments.

4. In `ContinentalDetailScreen.build`: `tabs: _continentalTabs(l, confederation),`, delete the moved `qualifyingTab()` and its local `code`/`name` only if nothing else in the callback uses them (the holders row does: keep them), and make

```dart
            final tabs = TabBarView(
              children: _continentalTabViews(
                context,
                data,
                confederation: confederation,
              ),
            );
```

5. `_Groups`: add `this.grid = false,` and `final bool grid;` (doc: "A tablet: the group tables in columns rather than stacked."). In `build`, replace

```dart
        for (final g in ordered) ...[
          AppCard( ... ),
          const SizedBox(height: AppSpacing.sm),
        ],
```

with

```dart
        if (grid) ...[
          ColumnFlow(children: [for (final g in ordered) card(g)]),
          const SizedBox(height: AppSpacing.sm),
        ] else
          for (final g in ordered) ...[
            card(g),
            const SizedBox(height: AppSpacing.sm),
          ],
```

and define, before the `return ListView(`, `Widget card(FinalsGroupTable g) => AppCard(...)` holding the moved `AppCard` exactly as it was.

6. `_ContFinalsGroups`: the same, with `widget.grid` and `AppSpacing.md`, the moved `AppCard` (matches on top, then the table) becoming `Widget card(FinalsGroupTable g)`.

7. First line of `ContinentalDetailScreen.build`:

```dart
    if (TabletShellScope.isActive(context)) {
      return _ContinentalDetailTabletLayout(
        careerId: careerId,
        confederation: confederation,
      );
    }
```

and `static const Key tabletLayoutKey = Key('continentalDetail.tabletLayout');` on the screen.

- [ ] **Step 6: The view and the tablet page**

Create `lib/features/tournaments/continental_detail_view.dart`:

```dart
part of 'continental_detail_screen.dart';

/// A continental championship's tabs and bodies for a tablet, the tab bar
/// across the top of the area it is given. Always [confederation]'s cup:
/// the Tournaments pane opens other confederations' cups with this.
class ContinentalDetailView extends ConsumerWidget {
  const ContinentalDetailView({
    required this.careerId,
    required this.confederation,
    super.key,
  });

  final int careerId;
  final Confederation confederation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final dataAsync = ref.watch(
      continentalDetailProvider((
        careerId: careerId,
        confederation: confederation,
      )),
    );
    final liveTab = ContinentalDetailScreen._liveTabFor(
      confederation,
      dataAsync.valueOrNull,
    );
    return DefaultTabController(
      key: ValueKey(liveTab),
      length: ContinentalDetailScreen._hasQualifyingFor(confederation) ? 8 : 7,
      initialIndex: liveTab,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: AppColors.surfaceContainer,
            child: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: AppColors.onSurface,
              unselectedLabelColor: AppColors.onSurfaceVariant,
              indicatorColor: AppColors.primary,
              tabs: _continentalTabs(l, confederation),
            ),
          ),
          Expanded(
            child: dataAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text(l.tourContCouldNotLoadCup(e.toString())),
              ),
              data: (data) {
                if (data == null) {
                  return Center(child: Text(l.tourContNoCupData));
                }
                String code(int id) => data.nations[id]?.code ?? '??';
                String name(int id) =>
                    data.nations[id]?.name ?? l.tourContUnknown;
                return Column(
                  children: [
                    TournamentHoldersRow(
                      holders: data.holders,
                      code: code,
                      name: name,
                    ),
                    Expanded(
                      child: TabBarView(
                        children: _continentalTabViews(
                          context,
                          data,
                          confederation: confederation,
                          grid: true,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// A continental championship's page on a tablet: its name over
/// [ContinentalDetailView] in one panel.
class _ContinentalDetailTabletLayout extends ConsumerWidget {
  const _ContinentalDetailTabletLayout({
    required this.careerId,
    required this.confederation,
  });

  final int careerId;
  final Confederation confederation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final data = ref
        .watch(
          continentalDetailProvider((
            careerId: careerId,
            confederation: confederation,
          )),
        )
        .valueOrNull;
    return Scaffold(
      key: ContinentalDetailScreen.tabletLayoutKey,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TabletScreenHeader(
              title: data == null
                  ? l.tourContChampionship
                  : competitionLabel(l, data.name).toUpperCase(),
              onBack: () =>
                  context.go('${Routes.tournaments}?careerId=$careerId'),
            ),
            Expanded(
              child: PanelBox(
                child: ContinentalDetailView(
                  careerId: careerId,
                  confederation: confederation,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 7: Register, run, expect PASS**

Add `Routes.continental,` to `tabletReadyPaths` (it builds `CupDetailScreen` when `conf` is missing, which has its own tablet layout since Task 8).

Run: `flutter test test/widget/continental_detail_tablet_test.dart test/golden/phone_guard_continental_detail_test.dart test/widget/tournament_tabs_test.dart test/widget/tablet_route_sweep_test.dart`
Expected: PASS, phone goldens unchanged.

- [ ] **Step 8: Analyze, full suite, commit**

Run: `flutter analyze && flutter test`

```bash
git add lib/features/tournaments/continental_detail_screen.dart lib/features/tournaments/continental_detail_view.dart lib/features/shell/tablet_shell.dart test/widget/continental_detail_tablet_test.dart
git commit -m "feat(tablet): continental championship tabs with groups in columns

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---
### Task 10: Nations Cup: `NationsCupView`

**risk: low (batched review)**. Read-only; the tab bodies move into a mixin (Review Focus 5).

**Files:**
- Create: `lib/features/tournaments/nations_cup_view.dart` (part of `nations_cup_screen.dart`)
- Modify: `lib/features/tournaments/nations_cup_screen.dart`, `lib/features/shell/tablet_shell.dart`, `test/helpers/competition_fixtures.dart`
- Test: `test/golden/phone_guard_nations_cup_test.dart` (new, with goldens), `test/widget/nations_cup_tablet_test.dart` (new)

**Interfaces:**
- Produces:
  - `class NationsCupView extends ConsumerStatefulWidget { const NationsCupView({required int careerId, Confederation? confederation, Key? key}); }`: a null confederation is the manager's own cup, as on the route.
  - `NationsCupScreen.tabletLayoutKey`.
  - In the library: `int _ncLiveTab(NationsCupData? v)` (the screen state's former static `_liveTab`), `mixin _NationsCupBodies<T extends StatefulWidget> on State<T>` with `bool get grid`, `List<Tab> _tabs(AppLocalizations l, {required bool zones})`, `List<Widget> _tabViews(NationsCupData v)` and the moved `_notYet`, `_leagues`, `_zones`, `_finals`.
  - In `competition_fixtures.dart`: `NationsCupData fakeNationsCup(int playerNationId)`.
- Consumes: `nationsCupProvider((careerId:, confederation:))` (the phone's one read, with the confederation it was given), `ColumnFlow`, `TabletScreenHeader`, `l.tourContNationsCup`, `competitionLabel`.

- [ ] **Step 1: A fake cup, and the phone guard**

Append to `test/helpers/competition_fixtures.dart` (add the imports `package:fnm/domain/entities/enums.dart`, `package:fnm/domain/services/competition/nations_cups.dart` and `package:fnm/features/tournaments/nations_cup_providers.dart`):

```dart
/// Europe's Nations Cup mid-season: Leagues A and B, two groups of four each,
/// the manager's nation heading B1. No finals drawn yet.
NationsCupData fakeNationsCup(int playerNationId) {
  final groups = groupsOf(fieldOf(playerNationId, 16), groupCount: 4, size: 4);
  const names = ['B1', 'A1', 'A2', 'B2'];
  return (
    confederation: Confederation.europe,
    cupName: NationsCups.europe,
    format: NationsCupFormat.ladder,
    isMine: true,
    playerLeague: 'B',
    playerGroup: 'B1',
    groups: [
      for (var i = 0; i < 4; i++)
        (name: names[i], standings: standingsOf(groups[i].nationIds)),
    ]..sort((a, b) => a.name.compareTo(b.name)),
    roundOf16: const [],
    quarters: const [],
    semis: const [],
    finalFx: const [],
    honours: const [],
    scorers: const [],
    playerNames: const {},
    drawWatched: true,
    playerNationId: playerNationId,
    myNationIds: {playerNationId},
    nations: realNationsById,
    maxTier: 1,
  );
}
```

(If `NationsCupFormat` lives in another file than `nations_cups.dart`, import it from where `nations_cup_providers.dart` does.)

Create `test/golden/phone_guard_nations_cup_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/tournaments/nations_cup_providers.dart';

import '../helpers/competition_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The phone Nations Cup on a mid-season ladder, pinned before its tab
/// bodies move into the shared mixin.
void main() {
  for (final (name, size) in [
    ('nations_cup_phone', kPhoneSize),
    ('nations_cup_phone_tall', const Size(390, 1600)),
  ]) {
    testWidgets(name, (tester) async {
      final save = await seedSave(
        tester,
        overrides: [
          nationsCupProvider((
            careerId: kSeededCareerId,
            confederation: null,
          )).overrideWith((ref) async => fakeNationsCup(seededNationId)),
        ],
      );
      await pumpRoute(
        tester,
        save,
        '${Routes.nationsCup}?careerId=${save.careerId}',
        size: size,
      );
      expect(find.text(enL.tourContGroupHeading('B1')), findsOneWidget);
      await expectAppGolden('goldens/$name.png');
    });
  }
}
```

- [ ] **Step 2: Create the baseline, confirm it holds, commit it**

```bash
flutter test --update-goldens test/golden/phone_guard_nations_cup_test.dart
flutter test test/golden/phone_guard_nations_cup_test.dart
git add test/helpers/competition_fixtures.dart test/golden/phone_guard_nations_cup_test.dart test/golden/goldens/nations_cup_phone*.png
git commit -m "test(tablet): phone guard for the Nations Cup

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

- [ ] **Step 3: Write the failing tablet test**

Create `test/widget/nations_cup_tablet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/tournaments/nations_cup_providers.dart';
import 'package:fnm/features/tournaments/nations_cup_screen.dart';

import '../helpers/competition_fixtures.dart';
import '../helpers/seeded_save.dart';

void main() {
  for (final size in kTabletSizes) {
    testWidgets('the manager\'s league, its groups in columns, $size', (
      tester,
    ) async {
      final save = await seedSave(
        tester,
        formFactor: FormFactor.tablet,
        overrides: [
          nationsCupProvider((
            careerId: kSeededCareerId,
            confederation: null,
          )).overrideWith((ref) async => fakeNationsCup(seededNationId)),
        ],
      );
      await pumpRoute(
        tester,
        save,
        '${Routes.nationsCup}?careerId=${save.careerId}',
        size: size,
      );
      expect(tester.takeException(), isNull);
      expect(find.byKey(NationsCupScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(NationsCupView), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      // Opens on League B, the manager's, B1 and B2 side by side.
      final b1 = tester.getRect(
        find.text(enL.tourContGroupHeading('B1')).hitTestable(),
      );
      final b2 = tester.getRect(
        find.text(enL.tourContGroupHeading('B2')).hitTestable(),
      );
      expect(b1.top, b2.top);
      expect(b2.left, greaterThan(b1.right));
      // The finals tab says they are still to come.
      await showTab(tester, 1);
      expect(find.text(enL.tourContFinalsFourSoon), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }
}
```

- [ ] **Step 4: Run it to verify it fails**

Run: `flutter test test/widget/nations_cup_tablet_test.dart`
Expected: FAIL to compile (`NationsCupScreen.tabletLayoutKey`, `NationsCupView`).

- [ ] **Step 5: Move the bodies into a mixin**

In `lib/features/tournaments/nations_cup_screen.dart`:

1. Add the import `package:fnm/shared/tablet/tablet.dart` and `part 'nations_cup_view.dart';`.

2. Move `_NationsCupScreenState._liveTab` to a top-level function, body unchanged:

```dart
/// The tab to land on: wherever the cup actually is.
int _ncLiveTab(NationsCupData? v) {
  // (the former static _liveTab's body, verbatim)
}
```

3. Add, after the screen state:

```dart
/// The cup's tabs and their bodies, shared by the phone screen and
/// [NationsCupView]. [grid] (a tablet) lays each league's or zone's group
/// tables out in columns.
mixin _NationsCupBodies<T extends StatefulWidget> on State<T> {
  bool get grid;

  List<Tab> _tabs(AppLocalizations l, {required bool zones}) => [
    Tab(text: zones ? l.tourContTabZones : l.tourContTabLeagues),
    Tab(text: zones ? l.tourContTabFinalsEight : l.tourContTabFinalsFour),
    Tab(text: l.tourContTabScorers),
    Tab(text: l.tourContTabHistory),
  ];

  List<Widget> _tabViews(NationsCupData v) {
    final l = AppLocalizations.of(context);
    String name(int id) => v.nations[id]?.name ?? l.tourContUnknown;
    String code(int id) => v.nations[id]?.code ?? '??';
    return [
      // MOVED VERBATIM: the four children of the phone's
      // `TabBarView(children: [...])`, from `if (v.format == ...)` to the
      // closing `TournamentHistory(...)`.
    ];
  }

  // MOVED VERBATIM from _NationsCupScreenState: _notYet, _leagues, _zones,
  // _finals, with the grid edits of step 4.
}
```

Move what the comments name; delete the comments.

4. The grid edits. In `_leagues`' builder, replace

```dart
            for (final g in shown) ...[
              _GroupCard( ... ),
              const SizedBox(height: AppSpacing.md),
            ],
```

with

```dart
            if (grid) ...[
              ColumnFlow(children: [for (final g in shown) card(g)]),
              const SizedBox(height: AppSpacing.md),
            ] else
              for (final g in shown) ...[
                card(g),
                const SizedBox(height: AppSpacing.md),
              ],
```

defining before its `return ListView(`:

```dart
        Widget card(FinalsGroupTable g) => _GroupCard(
          group: g,
          confederation: v.confederation,
          playerNationId: v.playerNationId,
          name: name,
          code: code,
          isLowestLeague: NationsCup.tierOfGroupName(g.name) >= v.maxTier,
        );
```

In `_zones`, pull the zone's sorted groups into a local function and do the same:

```dart
    List<FinalsGroupTable> groupsOf(AfricaZone zone) => [
      for (final g in v.groups)
        if (NationsCups.zoneOfGroupName(g.name) == zone) g,
    ]..sort((a, b) {
      if (a.name == v.playerGroup) return -1;
      if (b.name == v.playerGroup) return 1;
      return a.name.compareTo(b.name);
    });
    Widget card(FinalsGroupTable g) => _GroupCard(
      group: g,
      confederation: v.confederation,
      playerNationId: v.playerNationId,
      name: name,
      code: code,
      isLowestLeague: true,
    );
```

and replace the zone's inner `for (final g in [...]..sort(...)) ...[ _GroupCard(...), const SizedBox(height: AppSpacing.md) ]` with

```dart
          if (grid) ...[
            ColumnFlow(children: [for (final g in groupsOf(zone)) card(g)]),
            const SizedBox(height: AppSpacing.md),
          ] else
            for (final g in groupsOf(zone)) ...[
              card(g),
              const SizedBox(height: AppSpacing.md),
            ],
```

5. The phone state: `class _NationsCupScreenState extends ConsumerState<NationsCupScreen> with _NationsCupBodies<NationsCupScreen>`, with

```dart
  @override
  bool get grid => false;
```

In its `build`: `final liveTab = _ncLiveTab(view);`, the `TabBar`'s `tabs: _tabs(l, zones: zones),` and the data callback's `return TabBarView(children: _tabViews(v));` (its local `name`/`code` go: `_tabViews` makes its own). Make its first lines:

```dart
    if (TabletShellScope.isActive(context)) {
      return _NationsCupTabletLayout(
        careerId: widget.careerId,
        confederation: widget.confederation,
      );
    }
```

and add to `NationsCupScreen`: `static const Key tabletLayoutKey = Key('nationsCup.tabletLayout');`.

- [ ] **Step 6: The view and the tablet page**

Create `lib/features/tournaments/nations_cup_view.dart`:

```dart
part of 'nations_cup_screen.dart';

/// A Nations Cup's tabs and bodies for a tablet: the tab bar across the top
/// of the area it is given, group tables in columns. [confederation]'s cup,
/// or the manager's own when null, exactly as the route reads it.
class NationsCupView extends ConsumerStatefulWidget {
  const NationsCupView({required this.careerId, this.confederation, super.key});

  final int careerId;
  final Confederation? confederation;

  @override
  ConsumerState<NationsCupView> createState() => _NationsCupViewState();
}

class _NationsCupViewState extends ConsumerState<NationsCupView>
    with _NationsCupBodies<NationsCupView> {
  @override
  bool get grid => true;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(
      nationsCupProvider((
        careerId: widget.careerId,
        confederation: widget.confederation,
      )),
    );
    final view = async.valueOrNull;
    final liveTab = _ncLiveTab(view);
    final zones = view?.format == NationsCupFormat.zones;
    return DefaultTabController(
      // See CupDetailScreen: initialIndex is read once, before the data lands.
      key: ValueKey((liveTab, zones)),
      length: 4,
      initialIndex: liveTab,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: AppColors.surfaceContainer,
            child: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: AppColors.onSurface,
              unselectedLabelColor: AppColors.onSurfaceVariant,
              indicatorColor: AppColors.primary,
              tabs: _tabs(l, zones: zones),
            ),
          ),
          Expanded(
            child: async.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) =>
                  Center(child: Text(l.tourContCouldNotLoad(e.toString()))),
              data: (v) {
                if (v == null) {
                  return Center(child: Text(l.tourContNoSaveFound));
                }
                return TabBarView(children: _tabViews(v));
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// A Nations Cup's page on a tablet: the cup's name over [NationsCupView].
class _NationsCupTabletLayout extends ConsumerWidget {
  const _NationsCupTabletLayout({
    required this.careerId,
    required this.confederation,
  });

  final int careerId;
  final Confederation? confederation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final view = ref
        .watch(
          nationsCupProvider((careerId: careerId, confederation: confederation)),
        )
        .valueOrNull;
    // Europe's cup keeps the title it always had; the others are named.
    final title = view == null || view.cupName == NationsCups.europe
        ? l.tourContNationsCup
        : competitionLabel(l, view.cupName).toUpperCase();
    return Scaffold(
      key: NationsCupScreen.tabletLayoutKey,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TabletScreenHeader(
              title: title,
              onBack: () => context.canPop()
                  ? context.pop()
                  : context.go('${Routes.tournaments}?careerId=$careerId'),
            ),
            Expanded(
              child: PanelBox(
                child: NationsCupView(
                  careerId: careerId,
                  confederation: confederation,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 7: The move must not show on the phone; register; run**

Add `Routes.nationsCup,` to `tabletReadyPaths`.

Run: `flutter test test/widget/nations_cup_tablet_test.dart test/golden/phone_guard_nations_cup_test.dart test/widget/nations_cup_screen_test.dart test/widget/nations_cup_tabs_test.dart test/widget/nations_cup_zones_copy_fits_test.dart test/widget/tablet_route_sweep_test.dart`
Expected: PASS, phone goldens unchanged.

- [ ] **Step 8: Analyze, full suite, commit**

Run: `flutter analyze && flutter test`

```bash
git add lib/features/tournaments/nations_cup_screen.dart lib/features/tournaments/nations_cup_view.dart lib/features/shell/tablet_shell.dart test/widget/nations_cup_tablet_test.dart
git commit -m "feat(tablet): Nations Cup tabs with each league's groups in columns

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 11: Continental Clash: `ContinentalClashView`

**risk: low (batched review)**. Read-only.

**Files:**
- Create: `lib/features/tournaments/continental_clash_view.dart` (part of `continental_clash_screen.dart`)
- Modify: `lib/features/tournaments/continental_clash_screen.dart`, `lib/features/shell/tablet_shell.dart`, `test/helpers/competition_fixtures.dart`
- Test: `test/golden/phone_guard_clash_test.dart` (new, with golden), `test/widget/continental_clash_tablet_test.dart` (new)

**Interfaces:**
- Produces: `class ContinentalClashView extends ConsumerWidget { const ContinentalClashView({required int careerId, Key? key}); }`, `ContinentalClashScreen.tabletLayoutKey`, `List<Tab> _clashTabs(AppLocalizations l)`, `List<Widget> _clashTabViews(BuildContext context, ContinentalClashData data, {bool wide = false})`; `ContinentalClashData fakeClash(int playerNationId)` in the fixtures.
- Consumes: `continentalClashProvider(careerId)` (the phone's read), `TabletScreenHeader`, `l.tourContContinentalClash`.

- [ ] **Step 1: A fake Clash, and the phone guard**

Append to `test/helpers/competition_fixtures.dart` (import `package:fnm/features/tournaments/continental_clash_providers.dart`):

```dart
/// This cycle's Clash, played: the manager's nation beat the next best 2-1.
ContinentalClashData fakeClash(int playerNationId) {
  final f = fieldOf(playerNationId, 2);
  return (
    tie: Fixture(
      id: 2000,
      careerId: kSeededCareerId,
      competitionId: 98,
      matchday: 1,
      date: DateTime(2029, 6, 1),
      homeNationId: f[0].id,
      awayNationId: f[1].id,
      homeScore: 2,
      awayScore: 1,
      round: 'FFINAL',
      played: true,
    ),
    nations: realNationsById,
    playerNationId: playerNationId,
    honours: const [],
  );
}
```

Create `test/golden/phone_guard_clash_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/tournaments/continental_clash_providers.dart';

import '../helpers/competition_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The phone Clash with a played tie, pinned before its tab bodies move.
void main() {
  testWidgets('clash_phone', (tester) async {
    final save = await seedSave(
      tester,
      overrides: [
        continentalClashProvider(
          kSeededCareerId,
        ).overrideWith((ref) async => fakeClash(seededNationId)),
      ],
    );
    await pumpRoute(
      tester,
      save,
      '${Routes.continentalClash}?careerId=${save.careerId}',
    );
    final me = realNationsById[seededNationId]!;
    expect(find.text(enL.tourContWinTheClash(me.name)), findsOneWidget);
    await expectAppGolden('goldens/clash_phone.png');
  });
}
```

- [ ] **Step 2: Create the baseline, confirm it holds, commit it**

```bash
flutter test --update-goldens test/golden/phone_guard_clash_test.dart
flutter test test/golden/phone_guard_clash_test.dart
git add test/helpers/competition_fixtures.dart test/golden/phone_guard_clash_test.dart test/golden/goldens/clash_phone.png
git commit -m "test(tablet): phone guard for the Continental Clash

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

- [ ] **Step 3: Write the failing tablet test**

Create `test/widget/continental_clash_tablet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/tournaments/continental_clash_providers.dart';
import 'package:fnm/features/tournaments/continental_clash_screen.dart';

import '../helpers/competition_fixtures.dart';
import '../helpers/seeded_save.dart';

void main() {
  for (final size in kTabletSizes) {
    testWidgets('the Clash in a panel, the tie centred, $size', (
      tester,
    ) async {
      final save = await seedSave(
        tester,
        formFactor: FormFactor.tablet,
        overrides: [
          continentalClashProvider(
            kSeededCareerId,
          ).overrideWith((ref) async => fakeClash(seededNationId)),
        ],
      );
      await pumpRoute(
        tester,
        save,
        '${Routes.continentalClash}?careerId=${save.careerId}',
        size: size,
      );
      expect(tester.takeException(), isNull);
      expect(find.byKey(ContinentalClashScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(ContinentalClashView), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      final me = realNationsById[seededNationId]!;
      expect(find.text(enL.tourContWinTheClash(me.name)), findsOneWidget);
      // This cycle's tie is held to a readable width in the middle of the
      // pane (the history tab's list is not built until it is shown).
      final list = find
          .descendant(
            of: find.byType(ContinentalClashView),
            matching: find.byType(ListView),
          )
          .first;
      final view = tester.getRect(find.byType(ContinentalClashView));
      final tie = tester.getRect(list);
      expect(tie.width, lessThanOrEqualTo(640));
      expect((tie.center.dx - view.center.dx).abs(), lessThan(1));
      await tester.pumpWidget(const SizedBox());
    });
  }
}
```

- [ ] **Step 4: Run it to verify it fails**

Run: `flutter test test/widget/continental_clash_tablet_test.dart`
Expected: FAIL to compile.

- [ ] **Step 5: Shared tabs and bodies; hook in**

In `lib/features/tournaments/continental_clash_screen.dart`:

1. Import `package:fnm/shared/tablet/tablet.dart`; add `part 'continental_clash_view.dart';`.

2. Add top-level:

```dart
/// The Clash's two tabs, in the order [_clashTabViews] builds them.
List<Tab> _clashTabs(AppLocalizations l) => [
  Tab(text: l.tourContTabThisCycle),
  Tab(text: l.tourContTabHistory),
];

/// The two tab bodies. Shared by the phone screen and [ContinentalClashView];
/// [wide] (a tablet) holds this cycle's tie to a readable width, centred.
List<Widget> _clashTabViews(
  BuildContext context,
  ContinentalClashData data, {
  bool wide = false,
}) {
  final l = AppLocalizations.of(context);
  String code(int id) => data.nations[id]?.code ?? '??';
  String name(int id) => data.nations[id]?.name ?? l.tourContUnknown;
  final thisCycle = data.tie == null
      ? TournamentSoon(message: l.tourContClashSoon)
      : _ThisCycle(
          tie: data.tie!,
          playerNationId: data.playerNationId,
          code: code,
          name: name,
        );
  return [
    if (wide)
      Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: thisCycle,
        ),
      )
    else
      thisCycle,
    TournamentHistory(
      honours: data.honours,
      name: name,
      code: code,
      emptyMessage: l.tourContNoClashYet,
    ),
  ];
}
```

3. In `ContinentalClashScreen.build`: `tabs: _clashTabs(l),` and the data callback becomes

```dart
          data: (data) {
            if (data == null) {
              return Center(child: Text(l.tourContNoSaveFound));
            }
            return TabBarView(children: _clashTabViews(context, data));
          },
```

and its first lines:

```dart
    if (TabletShellScope.isActive(context)) {
      return _ContinentalClashTabletLayout(careerId: careerId);
    }
```

with `static const Key tabletLayoutKey = Key('clash.tabletLayout');` on the screen.

- [ ] **Step 6: The view and the tablet page**

Create `lib/features/tournaments/continental_clash_view.dart`:

```dart
part of 'continental_clash_screen.dart';

/// The Clash's tabs and bodies for a tablet, the tab bar across the top of
/// the area it is given.
class ContinentalClashView extends ConsumerWidget {
  const ContinentalClashView({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final dataAsync = ref.watch(continentalClashProvider(careerId));
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: AppColors.surfaceContainer,
            child: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: AppColors.onSurface,
              unselectedLabelColor: AppColors.onSurfaceVariant,
              indicatorColor: AppColors.primary,
              tabs: _clashTabs(l),
            ),
          ),
          Expanded(
            child: dataAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text(l.tourContCouldNotLoadClash(e.toString())),
              ),
              data: (data) {
                if (data == null) {
                  return Center(child: Text(l.tourContNoSaveFound));
                }
                return TabBarView(
                  children: _clashTabViews(context, data, wide: true),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// The Clash's page on a tablet: its name over [ContinentalClashView].
class _ContinentalClashTabletLayout extends StatelessWidget {
  const _ContinentalClashTabletLayout({required this.careerId});

  final int careerId;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      key: ContinentalClashScreen.tabletLayoutKey,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TabletScreenHeader(
              title: l.tourContContinentalClash,
              onBack: () =>
                  context.go('${Routes.tournaments}?careerId=$careerId'),
            ),
            Expanded(
              child: PanelBox(
                child: ContinentalClashView(careerId: careerId),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 7: Register, run, expect PASS**

Add `Routes.continentalClash,` to `tabletReadyPaths`.

Run: `flutter test test/widget/continental_clash_tablet_test.dart test/golden/phone_guard_clash_test.dart test/widget/tablet_route_sweep_test.dart`
Expected: PASS, phone golden unchanged.

- [ ] **Step 8: Analyze, full suite, commit**

Run: `flutter analyze && flutter test`

```bash
git add lib/features/tournaments/continental_clash_screen.dart lib/features/tournaments/continental_clash_view.dart lib/features/shell/tablet_shell.dart test/widget/continental_clash_tablet_test.dart
git commit -m "feat(tablet): Continental Clash in a panel

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

**Batched review checkpoint:** Tasks 3, 6, 7, 8, 9, 10, 11 are now in. Run their one combined review here, before Task 12.

---

### Task 12: Intercontinental play-off

**risk: high (per-task review)**. An event screen whose Continue writes to the save.

**Files:**
- Create: `lib/features/tournaments/intercontinental_playoff_tablet_layout.dart` (part of `intercontinental_playoff_screen.dart`)
- Modify: `lib/features/tournaments/intercontinental_playoff_screen.dart`, `lib/features/shell/tablet_shell.dart`, `test/helpers/competition_fixtures.dart`
- Test: `test/golden/phone_guard_playoff_test.dart` (new, with golden), `test/widget/intercontinental_playoff_tablet_test.dart` (new)

**Interfaces:**
- Produces: `IntercontinentalPlayoffScreen.tabletLayoutKey`; `List<Widget> _playoffBody(AppLocalizations l, PlayoffView data)` (the phone ListView's children: intro, the manager's verdict, the bracket); `PlayoffView fakePlayoff(int playerNationId)` in the fixtures.
- Consumes: `intercontinentalPlayoffProvider(careerId)` (the phone's read), the screen's own `_continue(context, ref)` (unchanged: marks `worldCupPlayoffKind` watched, goes to the hub), `TabletScreenHeader`, `l.tourContIntercontinentalPlayoff`, `l.tourContContinue`, `l.tourContNoPlayoffThisCycle`.

On a phone the Continue sits under the bracket and is only there when there is a play-off to show. The tablet puts it top right, on the same condition.

- [ ] **Step 1: A fake play-off, and the phone guard**

Append to `test/helpers/competition_fixtures.dart` (import `package:fnm/features/tournaments/intercontinental_playoff_providers.dart`):

```dart
/// The play-off: two seeded sides with a bye to a path final, four in the
/// semis. The manager's nation is seeded and wins its final.
PlayoffView fakePlayoff(int playerNationId) {
  final f = [for (final n in fieldOf(playerNationId, 6)) n.id];
  PlayoffTie tie(int home, int away, {bool isFinal = false}) => (
    home: home,
    away: away,
    homeScore: 2,
    awayScore: 1,
    winner: home,
    isFinal: isFinal,
  );
  return (
    ties: [
      tie(f[2], f[3]),
      tie(f[4], f[5]),
      tie(f[0], f[2], isFinal: true),
      tie(f[1], f[4], isFinal: true),
    ],
    nations: realNationsById,
    playerNationId: playerNationId,
  );
}
```

Create `test/golden/phone_guard_playoff_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/tournaments/intercontinental_playoff_providers.dart';

import '../helpers/competition_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The phone play-off event, pinned before the tablet layout is added.
void main() {
  testWidgets('playoff_phone', (tester) async {
    final save = await seedSave(
      tester,
      overrides: [
        intercontinentalPlayoffProvider(
          kSeededCareerId,
        ).overrideWith((ref) async => fakePlayoff(seededNationId)),
      ],
    );
    await pumpRoute(
      tester,
      save,
      '${Routes.intercontinentalPlayoff}?careerId=${save.careerId}',
    );
    expect(find.text(enL.tourContPlayoffThrough), findsOneWidget);
    await expectAppGolden('goldens/playoff_phone.png');
  });
}
```

- [ ] **Step 2: Create the baseline, confirm it holds, commit it**

```bash
flutter test --update-goldens test/golden/phone_guard_playoff_test.dart
flutter test test/golden/phone_guard_playoff_test.dart
git add test/helpers/competition_fixtures.dart test/golden/phone_guard_playoff_test.dart test/golden/goldens/playoff_phone.png
git commit -m "test(tablet): phone guard for the intercontinental play-off

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

- [ ] **Step 3: Write the failing tablet test**

Create `test/widget/intercontinental_playoff_tablet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/tournaments/intercontinental_playoff_bracket.dart';
import 'package:fnm/features/tournaments/intercontinental_playoff_providers.dart';
import 'package:fnm/features/tournaments/intercontinental_playoff_screen.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/competition_fixtures.dart';
import '../helpers/seeded_save.dart';

Future<SeededSave> _open(WidgetTester tester, Size size) async {
  final save = await seedSave(
    tester,
    formFactor: FormFactor.tablet,
    overrides: [
      intercontinentalPlayoffProvider(
        kSeededCareerId,
      ).overrideWith((ref) async => fakePlayoff(seededNationId)),
    ],
  );
  await pumpRoute(
    tester,
    save,
    '${Routes.intercontinentalPlayoff}?careerId=${save.careerId}',
    size: size,
  );
  return save;
}

void main() {
  for (final size in kTabletSizes) {
    testWidgets('the bracket under a header with Continue top right, $size', (
      tester,
    ) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(
        find.byKey(IntercontinentalPlayoffScreen.tabletLayoutKey),
        findsOneWidget,
      );
      expect(find.byType(PhoneWidthFrame), findsNothing);
      final bracket = find.byType(IntercontinentalPlayoffBracket);
      expect(bracket, findsOneWidget);
      final go = find.widgetWithText(PrimaryButton, enL.tourContContinue);
      expect(go, findsOneWidget);
      expect(tester.getCenter(go).dy, lessThan(tester.getRect(bracket).top));
      expect(
        tester.getCenter(go).dx,
        greaterThan(tester.getCenter(bracket).dx),
      );
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('Continue marks the play-off seen and goes to the hub', (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    await tester.tap(find.widgetWithText(PrimaryButton, enL.tourContContinue));
    await settle(tester);
    final router = save.container.read(routerProvider);
    expect(router.routeInformationProvider.value.uri.path, Routes.hub);
    late bool watched;
    await tester.runAsync(() async {
      watched = await save.container
          .read(competitionRepositoryProvider)
          .hasWatchedDraw(
            save.careerId,
            save.career.cyclePointer,
            worldCupPlayoffKind,
          );
    });
    expect(watched, isTrue);
    await tester.pumpWidget(const SizedBox());
  });
}
```

- [ ] **Step 4: Run it to verify it fails**

Run: `flutter test test/widget/intercontinental_playoff_tablet_test.dart`
Expected: FAIL to compile (`IntercontinentalPlayoffScreen.tabletLayoutKey`).

- [ ] **Step 5: Share the body; hook in**

In `lib/features/tournaments/intercontinental_playoff_screen.dart`:

1. Import `package:fnm/shared/tablet/tablet.dart`; add `part 'intercontinental_playoff_tablet_layout.dart';`.

2. Add top-level:

```dart
/// The play-off's body: what it is, how the manager's nation fared (when it
/// was in it), and the bracket. The phone's list and the tablet's both show
/// exactly this.
List<Widget> _playoffBody(AppLocalizations l, PlayoffView data) {
  String code(int id) => data.nations[id]?.code ?? '??';
  String name(int id) => data.nations[id]?.name ?? '—';
  final winners = {
    for (final t in data.ties)
      if (t.isFinal) t.winner,
  };
  final playerThrough = winners.contains(data.playerNationId);
  final playerInvolved = data.ties.any(
    (t) => t.home == data.playerNationId || t.away == data.playerNationId,
  );
  return [
    // MOVED VERBATIM: the phone ListView's children, from the intro
    // `Text(l.tourContPlayoffIntro, ...)` to `IntercontinentalPlayoffBracket(...)`.
  ];
}
```

(The `'—'` fallback is the phone's own, moved as it is: it is a missing-name glyph, never authored copy, and stage 2 ruled to keep it.) Move the children the comment names; delete the comment.

3. In the phone `build`'s data callback, delete the moved locals and make the list `child: ListView(padding: const EdgeInsets.all(AppSpacing.marginMobile), children: _playoffBody(l, data)),`.

4. First lines of `build`:

```dart
    if (TabletShellScope.isActive(context)) {
      return _PlayoffTabletLayout(screen: this);
    }
```

and `static const Key tabletLayoutKey = Key('playoff.tabletLayout');` on the screen.

- [ ] **Step 6: The layout**

Create `lib/features/tournaments/intercontinental_playoff_tablet_layout.dart`:

```dart
part of 'intercontinental_playoff_screen.dart';

/// The play-off on a tablet: the heading with Continue on its right, the
/// body held to a readable width under it.
class _PlayoffTabletLayout extends ConsumerWidget {
  const _PlayoffTabletLayout({required this.screen});

  final IntercontinentalPlayoffScreen screen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(intercontinentalPlayoffProvider(screen.careerId));
    final data = async.valueOrNull;
    return Scaffold(
      key: IntercontinentalPlayoffScreen.tabletLayoutKey,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TabletScreenHeader(
              title: l.tourContIntercontinentalPlayoff,
              // As on the phone: only with a play-off to have seen.
              trailing: data == null
                  ? null
                  : SizedBox(
                      width: 220,
                      child: PrimaryButton(
                        label: l.tourContContinue,
                        icon: Icons.check_rounded,
                        height: 44,
                        onPressed: () => screen._continue(context, ref),
                      ),
                    ),
            ),
            Expanded(
              child: async.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) =>
                    Center(child: Text(l.tourContCouldNotLoad(e.toString()))),
                data: (data) {
                  if (data == null) {
                    return Center(child: Text(l.tourContNoPlayoffThisCycle));
                  }
                  return Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 760),
                      child: ListView(children: _playoffBody(l, data)),
                    ),
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
```

- [ ] **Step 7: Register, run, expect PASS**

Add `Routes.intercontinentalPlayoff,` to `tabletReadyPaths`.

Run: `flutter test test/widget/intercontinental_playoff_tablet_test.dart test/golden/phone_guard_playoff_test.dart test/widget/tablet_route_sweep_test.dart`
Expected: PASS, phone golden unchanged.

- [ ] **Step 8: Analyze, full suite, commit**

Run: `flutter analyze && flutter test`

```bash
git add lib/features/tournaments/intercontinental_playoff_screen.dart lib/features/tournaments/intercontinental_playoff_tablet_layout.dart lib/features/shell/tablet_shell.dart test/widget/intercontinental_playoff_tablet_test.dart
git commit -m "feat(tablet): intercontinental play-off with Continue in the heading

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---
### Task 13: Tournaments: the competition list beside the picked competition

**risk: high (per-task review)**. Navigation, the tour's target, and every detail view in one pane.

**Files:**
- Create: `lib/features/tournaments/tournaments_tablet_layout.dart` (part of `tournaments_screen.dart`)
- Modify: `lib/features/tournaments/tournaments_screen.dart`, `lib/features/shell/tablet_shell.dart`
- Test: `test/golden/phone_guard_tournaments_test.dart` (new, with goldens), `test/widget/tournaments_tablet_test.dart` (new)

**Interfaces:**
- Produces:
  - `TournamentsScreen.tabletLayoutKey`.
  - In the library: `enum _PickKind { worldChampionship, continental, nationsCup, clash }`, `typedef _Pick = ({_PickKind kind, Confederation? conf})`, `typedef _Spec = ({_Championship championship, TournamentStatus? status, String? championName, String route, _Pick pick})`, and on `TournamentsScreen` the statics `_mineSpecs(int careerId, TournamentsOverview? overview)` and `_otherSpecs(int careerId, TournamentsOverview? overview)` that BOTH layouts list. Each list row has the key `Key('competition.<kind>.<confederation name or world>')`.
- Consumes: `tournamentsOverviewProvider(careerId)` (the phone's read), `CupDetailView`, `ContinentalDetailView`, `NationsCupView`, `ContinentalClashView`, `MasterDetail`, `MasterDetailPlaceholder`, `TourKeys.worldRanking`, `l.tourSharedCompetitions`, `l.tourWorldRanking`, `l.tourYourCompetitions`, `l.tourOtherContinents`, `l.tourSharedComingSoon`, `l.tourSharedSoon`, `l.compNationsCup`.

Every pick names its confederation (Review Focus 4): a continental row carries `conf`, the pane passes it on, and `ContinentalDetailView` requires it. Only the World Championship and the Clash have none.

- [ ] **Step 1: Pin the phone overview**

Create `test/golden/phone_guard_tournaments_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/onboarding/tour_keys.dart';

import '../helpers/seeded_save.dart';

/// The phone Tournaments overview, pinned before its tiles are built from
/// the specs both layouts share.
void main() {
  for (final (name, size) in [
    ('tournaments_phone', kPhoneSize),
    ('tournaments_phone_tall', const Size(390, 1600)),
  ]) {
    testWidgets(name, (tester) async {
      final save = await seedSave(tester);
      await pumpRoute(
        tester,
        save,
        '${Routes.tournaments}?careerId=${save.careerId}',
        size: size,
      );
      expect(find.byKey(TourKeys.worldRanking), findsOneWidget);
      await expectAppGolden('goldens/$name.png');
    });
  }
}
```

- [ ] **Step 2: Create the baseline, confirm it holds, commit it**

```bash
flutter test --update-goldens test/golden/phone_guard_tournaments_test.dart
flutter test test/golden/phone_guard_tournaments_test.dart
git add test/golden/phone_guard_tournaments_test.dart test/golden/goldens/tournaments_phone.png test/golden/goldens/tournaments_phone_tall.png
git commit -m "test(tablet): phone guard for the Tournaments overview

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

Open the tall PNG: every tile down to the other continents' grid must be on it, trophies drawn.

- [ ] **Step 3: Write the failing tablet tests**

Create `test/widget/tournaments_tablet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/features/onboarding/tour_keys.dart';
import 'package:fnm/features/onboarding/tour_overlay.dart';
import 'package:fnm/features/onboarding/tour_providers.dart';
import 'package:fnm/features/onboarding/tour_steps.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/tournaments/continental_detail_screen.dart';
import 'package:fnm/features/tournaments/cup_detail_screen.dart';
import 'package:fnm/features/tournaments/nations_cup_screen.dart';
import 'package:fnm/features/tournaments/tournaments_providers.dart';
import 'package:fnm/features/tournaments/tournaments_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/competition_fixtures.dart';
import '../helpers/seeded_save.dart';

/// Asia's championship and Africa's Nations Cup live, Africa's championship
/// not yet: other confederations' rows that open real views, and one that
/// does not.
TournamentsOverview _overview() {
  const live = TournamentStatus(
    phase: TournamentPhase.live,
    label: 'LIVE',
    championId: null,
  );
  const soon = TournamentStatus(
    phase: TournamentPhase.upcoming,
    label: 'SOON',
    championId: null,
  );
  return TournamentsOverview(
    playerConfederation: Confederation.europe,
    nations: realNationsById,
    nextMatches: const {},
    playerGroup: null,
    worldCupHostId: null,
    statuses: const {
      null: live,
      Confederation.europe: live,
      Confederation.asia: live,
      Confederation.africa: soon,
      Confederation.southAmerica: soon,
      Confederation.northAmerica: soon,
      Confederation.oceania: soon,
    },
    nationsCup: live,
    nationsCupConfederation: Confederation.europe,
    otherNationsCups: const {
      Confederation.africa: live,
      Confederation.northAmerica: soon,
    },
  );
}

Future<SeededSave> _open(
  WidgetTester tester,
  Size size, {
  bool fake = false,
}) async {
  final save = await seedSave(
    tester,
    formFactor: FormFactor.tablet,
    overrides: [
      if (fake)
        tournamentsOverviewProvider(
          kSeededCareerId,
        ).overrideWith((ref) async => _overview()),
    ],
  );
  await pumpRoute(
    tester,
    save,
    '${Routes.tournaments}?careerId=${save.careerId}',
    size: size,
  );
  return save;
}

Finder get _layout => find.byKey(TournamentsScreen.tabletLayoutKey);

Future<void> _pick(WidgetTester tester, String key) async {
  final row = find.byKey(Key(key));
  await tester.ensureVisible(row);
  await tester.pump();
  await tester.tap(row);
  await settle(tester);
}

void main() {
  for (final size in kTabletSizes) {
    testWidgets('the list left, the live competition open right, $size', (
      tester,
    ) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(_layout, findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBottomNav), findsNothing);
      expect(find.byType(MasterDetail), findsOneWidget);
      // The tour's target is the list's ranking row.
      expect(
        find.descendant(of: _layout, matching: find.byKey(TourKeys.worldRanking)),
        findsOneWidget,
      );
      // Something is open in the pane, right of the list.
      final open = find.byWidgetPredicate(
        (w) => w is CupDetailView || w is ContinentalDetailView,
      );
      expect(open, findsOneWidget);
      expect(
        tester.getCenter(find.byKey(TourKeys.worldRanking)).dx,
        lessThan(tester.getCenter(open).dx),
      );
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('another confederation\'s row opens THAT cup (Review Focus 4)', (
    tester,
  ) async {
    await _open(tester, kTabletSize, fake: true);
    // The live World Championship opens first.
    expect(find.byType(CupDetailView), findsOneWidget);

    await _pick(tester, 'competition.continental.asia');
    expect(
      tester
          .widget<ContinentalDetailView>(find.byType(ContinentalDetailView))
          .confederation,
      Confederation.asia,
    );

    await _pick(tester, 'competition.nationsCup.africa');
    expect(
      tester.widget<NationsCupView>(find.byType(NationsCupView)).confederation,
      Confederation.africa,
    );

    // The manager's own Nations Cup is Europe's, named, not a default.
    await _pick(tester, 'competition.nationsCup.europe');
    expect(
      tester.widget<NationsCupView>(find.byType(NationsCupView)).confederation,
      Confederation.europe,
    );

    // A competition with nothing yet says so.
    await _pick(tester, 'competition.continental.africa');
    expect(find.text(enL.tourSharedComingSoon), findsOneWidget);
    expect(find.byType(ContinentalDetailView), findsNothing);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the ranking row goes to the ranking', (tester) async {
    final save = await _open(tester, kTabletSize);
    await tester.tap(find.byKey(TourKeys.worldRanking));
    await settle(tester);
    expect(
      save.container.read(routerProvider).routeInformationProvider.value.uri.path,
      Routes.ranking,
    );
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the tour lights the ranking row on a tablet', (tester) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    tester.view.physicalSize = kTabletSize;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final router = save.container.read(routerProvider)
      ..go('${Routes.hub}?careerId=${save.careerId}');
    save.container.read(tourCareerProvider.notifier).state = save.careerId;
    save.container.read(tourStepProvider.notifier).state = kTourSteps
        .indexWhere((s) => s.route == Routes.tournaments);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: save.container,
        child: MaterialApp.router(
          theme: AppTheme.theme,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
          builder: (context, child) =>
              TourOverlay(child: child ?? const SizedBox.shrink()),
        ),
      ),
    );
    await settle(tester);
    // The overlay keeps measuring its target for 90 frames.
    for (var i = 0; i < 100; i++) {
      await tester.pump(const Duration(milliseconds: 16));
    }
    expect(router.routeInformationProvider.value.uri.path, Routes.tournaments);
    expect(
      find.descendant(of: _layout, matching: find.byKey(TourKeys.worldRanking)),
      findsOneWidget,
    );
    final painter =
        tester
                .widget<CustomPaint>(
                  find.byWidgetPredicate(
                    (w) => w is CustomPaint && w.painter is SpotlightPainter,
                  ),
                )
                .painter!
            as SpotlightPainter;
    expect(painter.hole, isNotNull, reason: 'the tour fell back to dimming');
    expect(
      painter.hole!.contains(
        tester.getCenter(find.byKey(TourKeys.worldRanking)),
      ),
      isTrue,
    );
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the ranking target follows a window through 1000', (
    tester,
  ) async {
    await _open(tester, kTabletSize);
    tester.view.physicalSize = const Size(700, 810);
    await settle(tester);
    expect(tester.takeException(), isNull);
    expect(_layout, findsNothing);
    expect(find.byKey(TourKeys.worldRanking), findsOneWidget);
    expect(tester.widget(find.byKey(TourKeys.worldRanking)), isA<AppCard>());
    tester.view.physicalSize = kTabletSize;
    await settle(tester);
    expect(tester.takeException(), isNull);
    expect(
      find.descendant(of: _layout, matching: find.byKey(TourKeys.worldRanking)),
      findsOneWidget,
    );
    await tester.pumpWidget(const SizedBox());
  });
}
```

(`_pick` scrolls a row into view before tapping it: at 1024 x 768 the other continents' rows can sit below the list's fold.)

- [ ] **Step 4: Run them to verify they fail**

Run: `flutter test test/widget/tournaments_tablet_test.dart`
Expected: FAIL to compile (`TournamentsScreen.tabletLayoutKey`).

- [ ] **Step 5: One list of competitions for both layouts**

In `lib/features/tournaments/tournaments_screen.dart`:

1. Add the imports (sorted):

```dart
import 'package:fnm/features/tournaments/continental_clash_screen.dart';
import 'package:fnm/features/tournaments/continental_detail_screen.dart';
import 'package:fnm/features/tournaments/cup_detail_screen.dart';
import 'package:fnm/features/tournaments/nations_cup_screen.dart';
import 'package:fnm/shared/tablet/tablet.dart';
```

and below them `part 'tournaments_tablet_layout.dart';`.

2. After the `_championships` list and the zone functions, add:

```dart
/// What the overview can open.
enum _PickKind { worldChampionship, continental, nationsCup, clash }

/// One openable competition: its kind, and whose it is where that matters.
typedef _Pick = ({_PickKind kind, Confederation? conf});

/// One competition as both layouts list it: how its tile looks, where it
/// stands, who won it, where its own page is, and what the tablet opens.
typedef _Spec = ({
  _Championship championship,
  TournamentStatus? status,
  String? championName,
  String route,
  _Pick pick,
});
```

3. In `TournamentsScreen`, replace `_tile`, `_nationsCupTile`, `_clashTile` and `_open` with:

```dart
  static const Key tabletLayoutKey = Key('tournaments.tabletLayout');

  static _Spec _championshipSpec(
    int careerId,
    TournamentsOverview? overview,
    _Championship c,
  ) {
    final conf = c.confederation;
    final championId = overview?.statuses[conf]?.championId;
    return (
      championship: c,
      status: overview?.statuses[conf],
      championName: championId == null
          ? null
          : overview?.nations[championId]?.name,
      route: conf == null
          ? '${Routes.cup}?careerId=$careerId'
          : '${Routes.continental}?careerId=$careerId&conf=${conf.name}',
      pick: (
        kind: conf == null
            ? _PickKind.worldChampionship
            : _PickKind.continental,
        conf: conf,
      ),
    );
  }

  /// A Nations Cup: the manager's own (strapped with his league on a ladder
  /// cup) or another confederation's.
  static _Spec _nationsCupSpec(
    int careerId,
    TournamentsOverview overview,
    Confederation conf,
    TournamentStatus status, {
    bool mine = false,
  }) {
    final cup = NationsCups.forConfederation(conf);
    final ladder = cup?.format == NationsCupFormat.ladder;
    return (
      championship: _Championship(
        name: cup?.name ?? NationsCups.europe,
        zone: (l) => mine && ladder
            ? l.tourZoneLeague(overview.nationsCupLeague)
            : _confederationZone(l, conf),
        icon: Icons.military_tech,
      ),
      status: status,
      championName: overview.nations[status.championId]?.name,
      route: '${Routes.nationsCup}?careerId=$careerId&conf=${conf.name}',
      pick: (kind: _PickKind.nationsCup, conf: conf),
    );
  }

  static _Spec _clashSpec(int careerId, TournamentsOverview overview) => (
    championship: const _Championship(
      name: 'Continental Clash',
      zone: _zoneIntercontinental,
      icon: Icons.flash_on,
    ),
    status: overview.continentalClash,
    championName: overview.nations[overview.continentalClash!.championId]?.name,
    route: '${Routes.continentalClash}?careerId=$careerId',
    pick: (kind: _PickKind.clash, conf: null),
  );

  /// Your competitions: the World Championship and your own continental cup,
  /// your Nations Cup, and the Continental Clash when your nation is one of
  /// its two entrants.
  static List<_Spec> _mineSpecs(int careerId, TournamentsOverview? overview) {
    final playerConf = overview?.playerConfederation;
    return [
      for (final c in _championships)
        if (c.confederation == null || c.confederation == playerConf)
          _championshipSpec(careerId, overview, c),
      if (overview?.nationsCup != null)
        _nationsCupSpec(
          careerId,
          overview!,
          overview.nationsCupConfederation ?? Confederation.europe,
          overview.nationsCup!,
          mine: true,
        ),
      if (overview?.continentalClash != null && overview!.clashInvolvesPlayer)
        _clashSpec(careerId, overview),
    ];
  }

  /// The other continents' championships (most relevant first), their
  /// Nations Cups, and the Clash when your nation is not in it.
  static List<_Spec> _otherSpecs(int careerId, TournamentsOverview? overview) {
    final playerConf = overview?.playerConfederation;
    return [
      for (final c in _ordered(overview))
        if (c.confederation != null && c.confederation != playerConf)
          _championshipSpec(careerId, overview, c),
      if (overview != null)
        for (final e in overview.otherNationsCups.entries)
          _nationsCupSpec(careerId, overview, e.key, e.value),
      if (overview?.continentalClash != null && !overview!.clashInvolvesPlayer)
        _clashSpec(careerId, overview),
    ];
  }

  Widget _specTile(BuildContext context, _Spec s) => _ChampionshipTile(
    championship: s.championship,
    status: s.status,
    championName: s.championName,
    onView: () => context.go(s.route),
  );
```

(Keep the old methods' doc comments on their replacements. Each spec says exactly what the old tile builder said: the same championship, status, champion and destination.)

4. In `build`, make the first lines

```dart
    if (TabletShellScope.isActive(context)) {
      return _TournamentsTabletLayout(careerId: careerId);
    }
```

and in the data callback replace the computation of `mine`/`others` and the two `_tileGrid([...])` lists with:

```dart
              _tileGrid([
                for (final s in _mineSpecs(careerId, overview))
                  _specTile(context, s),
              ]),
```

and

```dart
              _tileGrid([
                for (final s in _otherSpecs(careerId, overview))
                  _specTile(context, s),
              ]),
```

(The `playerConf`, `mine` and `others` locals go; the headings, spacers and the ranking card stay where they are.)

- [ ] **Step 6: The phone must not move**

Create `lib/features/tournaments/tournaments_tablet_layout.dart` containing only `part of 'tournaments_screen.dart';` for now, plus a stub so the library compiles:

```dart
class _TournamentsTabletLayout extends StatelessWidget {
  const _TournamentsTabletLayout({required this.careerId});
  final int careerId;
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
```

Run: `flutter test test/golden/phone_guard_tournaments_test.dart test/widget/tournaments_screen_test.dart test/widget/tour_navigation_test.dart test/widget/tour_test.dart`
Expected: PASS, goldens unchanged. (The stub is replaced in the next step; it exists so the spec refactor is proven on its own.)

- [ ] **Step 7: The layout**

Replace `lib/features/tournaments/tournaments_tablet_layout.dart` with:

```dart
part of 'tournaments_screen.dart';

/// The Tournaments screen on a tablet: every competition listed on the left
/// (the world ranking first, then yours, then the other continents'), the
/// picked one open on the right in its own tabs. Until the manager picks,
/// the pane shows the competition being played now.
class _TournamentsTabletLayout extends ConsumerStatefulWidget {
  const _TournamentsTabletLayout({required this.careerId});

  final int careerId;

  @override
  ConsumerState<_TournamentsTabletLayout> createState() =>
      _TournamentsTabletLayoutState();
}

class _TournamentsTabletLayoutState
    extends ConsumerState<_TournamentsTabletLayout> {
  /// What the manager picked, or null for the live competition.
  _Pick? _picked;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final careerId = widget.careerId;
    final overviewAsync = ref.watch(tournamentsOverviewProvider(careerId));
    return Scaffold(
      key: TournamentsScreen.tabletLayoutKey,
      body: overviewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) =>
            Center(child: Text(l.tourSharedCouldNotLoadTournaments)),
        data: (overview) {
          final mine = TournamentsScreen._mineSpecs(careerId, overview);
          final others = TournamentsScreen._otherSpecs(careerId, overview);
          final shown =
              [...mine, ...others].where((s) => s.pick == _picked).firstOrNull ??
              mine.firstWhere(
                (s) => s.status?.phase == TournamentPhase.live,
                orElse: () => mine.first,
              );
          Widget row(_Spec s) => _CompetitionListRow(
            key: Key(
              'competition.${s.pick.kind.name}.${s.pick.conf?.name ?? 'world'}',
            ),
            spec: s,
            selected: s.pick == shown.pick,
            onTap: () => setState(() => _picked = s.pick),
          );
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: MasterDetail(
              initialFraction: 0.28,
              minFraction: 0.22,
              maxFraction: 0.4,
              minDetailWidth: 480,
              master: PanelBox(
                child: ListView(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                      child: Text(
                        l.tourSharedCompetitions,
                        style: TabletText.screenTitle,
                      ),
                    ),
                    _RankingListRow(
                      key: TourKeys.worldRanking,
                      onTap: () =>
                          context.go('${Routes.ranking}?careerId=$careerId'),
                    ),
                    _ListLabel(l.tourYourCompetitions),
                    for (final s in mine) row(s),
                    _ListLabel(l.tourOtherContinents),
                    for (final s in others) row(s),
                  ],
                ),
              ),
              detail: PanelBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _PaneHeader(spec: shown),
                    Expanded(
                      child: KeyedSubtree(
                        // Another competition is another set of tabs: no
                        // tab index or scroll carried over from the last.
                        key: ValueKey(shown.pick),
                        child: _paneBody(l, shown),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// The picked competition's own view, for ITS confederation.
  Widget _paneBody(AppLocalizations l, _Spec s) {
    if (!(s.status?.available ?? false)) {
      return MasterDetailPlaceholder(text: l.tourSharedComingSoon);
    }
    final careerId = widget.careerId;
    return switch (s.pick.kind) {
      _PickKind.worldChampionship => CupDetailView(careerId: careerId),
      _PickKind.continental => ContinentalDetailView(
        careerId: careerId,
        confederation: s.pick.conf!,
      ),
      _PickKind.nationsCup => NationsCupView(
        careerId: careerId,
        confederation: s.pick.conf,
      ),
      _PickKind.clash => ContinentalClashView(careerId: careerId),
    };
  }
}

/// A status's colour: green while it is being played, the accent once there
/// is something to see, grey before.
Color _accentOf(TournamentStatus? status) {
  if (!(status?.available ?? false)) return AppColors.onSurfaceVariant;
  return status?.phase == TournamentPhase.live
      ? AppColors.positive
      : AppColors.primary;
}

/// A heading in the competition list.
class _ListLabel extends StatelessWidget {
  const _ListLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(12, 16, 12, 6),
    child: Text(text.toUpperCase(), style: TabletText.sectionLabel),
  );
}

/// The list's first line: the world ranking, which is a page of its own.
class _RankingListRow extends StatelessWidget {
  const _RankingListRow({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              const Icon(Icons.leaderboard, color: AppColors.primary, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l.tourWorldRanking,
                  style: TabletText.cell.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              const Icon(
                Icons.chevron_right,
                size: 18,
                color: AppColors.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One competition in the list: trophy, name, strap, status.
class _CompetitionListRow extends StatelessWidget {
  const _CompetitionListRow({
    required this.spec,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final _Spec spec;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = spec.championship;
    final available = spec.status?.available ?? false;
    final accent = _accentOf(spec.status);
    final trophy = Trophies.forCompetitionName(c.name);
    return Material(
      color: selected ? AppColors.surfaceContainerHighest : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              SizedBox(
                width: 32,
                height: 32,
                child: trophy == null
                    ? Icon(c.icon, size: 22, color: accent)
                    : Opacity(
                        opacity: available ? 1 : 0.5,
                        child: Image.asset(
                          trophy,
                          fit: BoxFit.contain,
                          errorBuilder: (_, _, _) =>
                              Icon(c.icon, size: 22, color: accent),
                        ),
                      ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // As on the phone tile: a Nations Cup says just that,
                      // and its strap names the continent.
                      NationsCups.isNationsCup(c.name)
                          ? l.compNationsCup
                          : competitionLabel(l, c.name),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TabletText.cell.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      c.zone(l),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TabletText.sectionLabel,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              _StatusChip(
                label: spec.status?.label ?? l.tourSharedSoon,
                accent: accent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The pane's heading: the competition's full name, its champion, its
/// status.
class _PaneHeader extends StatelessWidget {
  const _PaneHeader({required this.spec});

  final _Spec spec;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      height: 40,
      color: AppColors.surfaceContainer,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              competitionLabel(l, spec.championship.name).toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TabletText.panelTitle,
            ),
          ),
          if (spec.championName != null) ...[
            Text(spec.championName!, style: TabletText.barMeta),
            const SizedBox(width: AppSpacing.sm),
          ],
          _StatusChip(
            label: spec.status?.label ?? l.tourSharedSoon,
            accent: _accentOf(spec.status),
          ),
        ],
      ),
    );
  }
}

/// A competition's status, in its colour, never wider than a column allows.
class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.accent});

  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 120),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.14),
        borderRadius: AppRadii.smAll,
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.labelSmall.copyWith(color: accent),
      ),
    ),
  );
}
```

- [ ] **Step 8: Register, run, expect PASS**

Add `Routes.tournaments,` to `tabletReadyPaths`.

Run: `flutter test test/widget/tournaments_tablet_test.dart test/golden/phone_guard_tournaments_test.dart test/widget/tournaments_screen_test.dart test/widget/tour_navigation_test.dart test/widget/tour_test.dart test/widget/tablet_route_sweep_test.dart`
Expected: PASS, goldens unchanged.

- [ ] **Step 9: Prove Review Focus 4 bites**

In `_paneBody`, temporarily replace `confederation: s.pick.conf!,` with `confederation: Confederation.europe,`; the "another confederation's row" test must FAIL on `Confederation.asia`. Restore.

- [ ] **Step 10: Analyze, full suite, commit**

Run: `flutter analyze && flutter test`

```bash
git add lib/features/tournaments/tournaments_screen.dart lib/features/tournaments/tournaments_tablet_layout.dart lib/features/shell/tablet_shell.dart test/widget/tournaments_tablet_test.dart
git commit -m "feat(tablet): Tournaments as a competition list beside the picked competition

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---
### Task 14: The draw ceremony's landscape stage (qualifying, continental, Nations Cup draws)

**risk: high (per-task review)**. Animation state, stored groups, full-screen routing (Review Focus 1 and 2).

**Files:**
- Modify: `lib/features/tournaments/draw_ceremony.dart`
- Modify: `lib/features/tournaments/qualifying_draw_screen.dart`, `continental_draw_screen.dart`, `nations_cup_draw_screen.dart`
- Modify: `lib/features/shell/tablet_shell.dart`
- Test: `test/golden/phone_guard_draws_test.dart` (new, with goldens), `test/widget/draw_ceremony_tablet_test.dart` (new)

**Interfaces:**
- Produces:
  - `DrawCeremony({..., bool landscape = false})`, `static const Key landscapeKey`, `static const double landscapeSideWidth = 340`.
  - `class DrawCeremonyState extends State<DrawCeremony>` (was `_DrawCeremonyState`) with `@visibleForTesting int get revealed`.
  - In the library: `typedef _DrawFrame = ({Map<int, List<int>> revealedByGroup, Map<int, List<int>> waitingByPot, bool done, _Step? current, _Step? last})`; State methods `_frame()`, `_stage(_DrawFrame)`, `_groupCard(AppLocalizations, int, _DrawFrame)`, `_controls(AppLocalizations, bool done)`, `_landscape(AppLocalizations, _DrawFrame)`, `_landscapeGroups(AppLocalizations, _DrawFrame, BoxConstraints)`.
- Consumes: `qualifyingDrawProvider`, `continentalDrawProvider`, `continentalQualifyingDrawProvider`, `nationsCupDrawProvider` (unchanged; each already reads the STORED groups), `useTabletLayout`, `l.tourSharedGroupName`.

Where the landscape choice is made matters (Review Focus 2). The screens pass `landscape: useTabletLayout(context, ref)` into the SAME `DrawCeremony` at the same place in the tree, and the ceremony branches inside its own `build`. Nothing above it changes when the window crosses 1000, so its State, its running order and its revealed count survive. The routes join `tabletReadyPaths`, so `FullScreenPhoneFrame` no longer wraps them (that frame's swap is what remounted full-screen pages on a resize).

- [ ] **Step 1: Pin the phone ceremonies**

Create `test/golden/phone_guard_draws_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/features/tournaments/continental_detail_providers.dart';
import 'package:fnm/features/tournaments/nations_cup_draw_providers.dart';

import '../helpers/competition_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The phone draw ceremony, pinned before it gains a landscape stage: the
/// seeded save's own qualifying draw before the first ball and once skipped
/// to the end, and the continental and Nations Cup draws (fake, a fresh save
/// has none yet) once skipped.
Future<void> _skip(WidgetTester tester) async {
  await tester.tap(find.text(enL.tourSharedSkip));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

void main() {
  testWidgets('qualifying_draw_phone', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.qualifyingDraw}?careerId=${save.careerId}',
    );
    expect(find.text(enL.tourPot(1)), findsOneWidget);
    await expectAppGolden('goldens/qualifying_draw_phone.png');
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('qualifying_draw_phone_done_tall', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.qualifyingDraw}?careerId=${save.careerId}',
      size: const Size(390, 1800),
    );
    await _skip(tester);
    await expectAppGolden('goldens/qualifying_draw_phone_done_tall.png');
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('continental_draw_phone_done', (tester) async {
    final save = await seedSave(
      tester,
      overrides: [
        continentalDrawProvider((
          careerId: kSeededCareerId,
          confederation: Confederation.europe,
        )).overrideWith((ref) async => fakeContinentalDraw(seededNationId)),
      ],
    );
    await pumpRoute(
      tester,
      save,
      '${Routes.continentalDraw}?careerId=${save.careerId}'
      '&conf=${Confederation.europe.name}',
    );
    await _skip(tester);
    await expectAppGolden('goldens/continental_draw_phone_done.png');
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('nations_cup_draw_phone_done', (tester) async {
    final save = await seedSave(
      tester,
      overrides: [
        nationsCupDrawProvider(
          kSeededCareerId,
        ).overrideWith((ref) async => fakeNationsCupDraw(seededNationId)),
      ],
    );
    await pumpRoute(
      tester,
      save,
      '${Routes.nationsCupDraw}?careerId=${save.careerId}',
    );
    await _skip(tester);
    await expectAppGolden('goldens/nations_cup_draw_phone_done.png');
    await tester.pumpWidget(const SizedBox());
  });
}
```

- [ ] **Step 2: Create the baseline, confirm it holds, commit it**

```bash
flutter test --update-goldens test/golden/phone_guard_draws_test.dart
flutter test test/golden/phone_guard_draws_test.dart
git add test/golden/phone_guard_draws_test.dart test/golden/goldens/qualifying_draw_phone.png test/golden/goldens/qualifying_draw_phone_done_tall.png test/golden/goldens/continental_draw_phone_done.png test/golden/goldens/nations_cup_draw_phone_done.png
git commit -m "test(tablet): phone guards for the draw ceremonies

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

Open the PNGs: the first shows full pots and empty groups; the others show every group filled and "DRAW COMPLETE".

- [ ] **Step 3: Write the failing tablet tests**

Create `test/widget/draw_ceremony_tablet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/shell/tablet_sidebar.dart';
import 'package:fnm/features/tournaments/continental_detail_providers.dart';
import 'package:fnm/features/tournaments/draw_ceremony.dart';
import 'package:fnm/features/tournaments/nations_cup_draw_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/competition_fixtures.dart';
import '../helpers/seeded_save.dart';

Future<SeededSave> _qualifying(WidgetTester tester, Size size) async {
  final save = await seedSave(tester, formFactor: FormFactor.tablet);
  await pumpRoute(
    tester,
    save,
    '${Routes.qualifyingDraw}?careerId=${save.careerId}',
    size: size,
  );
  return save;
}

Future<void> _skip(WidgetTester tester) async {
  await tester.tap(find.text(enL.tourSharedSkip));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

/// The landscape stage: full screen (no shell, no phone frame), pots left of
/// the groups.
void _isStage(WidgetTester tester) {
  expect(tester.takeException(), isNull);
  expect(find.byKey(DrawCeremony.landscapeKey), findsOneWidget);
  expect(find.byType(FullScreenPhoneFrame), findsNothing);
  expect(find.byType(TabletSidebar), findsNothing);
  // The first group's card, whatever the draw named it.
  final groups = tester.widget<DrawCeremony>(find.byType(DrawCeremony)).groups;
  expect(
    tester.getCenter(find.text(enL.tourPot(1))).dx,
    lessThan(
      tester.getCenter(find.text(enL.tourSharedGroupName(groups.first.name))).dx,
    ),
  );
}

void main() {
  for (final size in kTabletSizes) {
    testWidgets('the qualifying draw on a landscape stage, $size', (
      tester,
    ) async {
      await _qualifying(tester, size);
      _isStage(tester);
      await _skip(tester);
      expect(tester.takeException(), isNull);
      expect(find.text(enL.tourSharedDrawComplete), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('the continental draw on a landscape stage, $size', (
      tester,
    ) async {
      final save = await seedSave(
        tester,
        formFactor: FormFactor.tablet,
        overrides: [
          continentalDrawProvider((
            careerId: kSeededCareerId,
            confederation: Confederation.europe,
          )).overrideWith((ref) async => fakeContinentalDraw(seededNationId)),
        ],
      );
      await pumpRoute(
        tester,
        save,
        '${Routes.continentalDraw}?careerId=${save.careerId}'
        '&conf=${Confederation.europe.name}',
        size: size,
      );
      _isStage(tester);
      await _skip(tester);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('the Nations Cup draw on a landscape stage, $size', (
      tester,
    ) async {
      final save = await seedSave(
        tester,
        formFactor: FormFactor.tablet,
        overrides: [
          nationsCupDrawProvider(
            kSeededCareerId,
          ).overrideWith((ref) async => fakeNationsCupDraw(seededNationId)),
        ],
      );
      await pumpRoute(
        tester,
        save,
        '${Routes.nationsCupDraw}?careerId=${save.careerId}',
        size: size,
      );
      _isStage(tester);
      await _skip(tester);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('the landscape stage draws exactly the stored groups '
      '(Review Focus 1)', (tester) async {
    final save = await _qualifying(tester, kTabletSize);
    final ceremony = tester.widget<DrawCeremony>(find.byType(DrawCeremony));
    expect(ceremony.landscape, isTrue);
    final me = save.nations.firstWhere((n) => n.id == save.nationId);
    late List<FinalsGroupTable> stored;
    await tester.runAsync(() async {
      stored = await save.container
          .read(competitionRepositoryProvider)
          .tournamentGroupTables(
            save.careerId,
            CompetitionKind.continentalQualifying,
            confederation: me.confederation,
          );
    });
    expect(
      stored,
      isNotEmpty,
      reason: 'the seeded save opens on a drawn continental qualifying campaign',
    );
    expect(
      {for (final g in ceremony.groups) g.name: g.nationIds.toSet()},
      {
        for (final t in stored) t.name: {for (final s in t.standings) s.nationId},
      },
    );
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a window crossing 1000 mid-draw keeps the draw where it was '
      '(Review Focus 2)', (tester) async {
    await _qualifying(tester, kTabletSize);
    final before = tester.state<DrawCeremonyState>(find.byType(DrawCeremony));
    // Two balls by hand (a tap pauses the autoplay, so nothing else moves).
    await tester.tap(find.byType(GridView));
    await tester.pump();
    await tester.tap(find.byType(GridView));
    await tester.pump();
    expect(before.revealed, 2);

    tester.view.physicalSize = const Size(700, 810);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(tester.takeException(), isNull);
    expect(find.byKey(DrawCeremony.landscapeKey), findsNothing);
    final narrow = tester.state<DrawCeremonyState>(find.byType(DrawCeremony));
    expect(identical(narrow, before), isTrue, reason: 'the draw restarted');
    expect(narrow.revealed, 2);

    tester.view.physicalSize = kTabletSize;
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byKey(DrawCeremony.landscapeKey), findsOneWidget);
    expect(
      identical(
        tester.state<DrawCeremonyState>(find.byType(DrawCeremony)),
        before,
      ),
      isTrue,
    );
    expect(before.revealed, 2);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('Continue after the landscape draw: watched, back to the hub', (
    tester,
  ) async {
    final save = await _qualifying(tester, kTabletSize);
    await _skip(tester);
    await tester.tap(find.widgetWithText(PrimaryButton, enL.tourSharedContinue));
    await settle(tester);
    expect(
      save.container.read(routerProvider).routeInformationProvider.value.uri.path,
      Routes.hub,
    );
    late bool watched;
    await tester.runAsync(() async {
      watched = await save.container
          .read(competitionRepositoryProvider)
          .hasWatchedDraw(
            save.careerId,
            save.career.cyclePointer,
            continentalQualDrawKind,
          );
    });
    expect(watched, isTrue);
    await tester.pumpWidget(const SizedBox());
  });
}
```

- [ ] **Step 4: Run them to verify they fail**

Run: `flutter test test/widget/draw_ceremony_tablet_test.dart`
Expected: FAIL to compile (`DrawCeremony.landscapeKey`, `DrawCeremonyState`, `landscape`).

- [ ] **Step 5: Split the ceremony's build**

In `lib/features/tournaments/draw_ceremony.dart`:

1. Add to `DrawCeremony` the constructor parameter `this.landscape = false,` and:

```dart
  static const Key landscapeKey = Key('drawCeremony.landscape');

  /// The landscape stage's left column: the ball, the pots, the controls.
  static const double landscapeSideWidth = 340;

  /// A tablet: the pots and controls in a column on the left, the groups
  /// filling the rest. Chosen INSIDE the ceremony's own State, so a window
  /// that crosses the tablet width mid-draw keeps the draw where it was.
  final bool landscape;
```

and change `createState` to `State<DrawCeremony> createState() => DrawCeremonyState();`.

2. Add top-level:

```dart
/// Where the draw stands after the balls revealed so far: what each group
/// holds, what each pot still holds, and the ball just drawn.
typedef _DrawFrame = ({
  Map<int, List<int>> revealedByGroup,
  Map<int, List<int>> waitingByPot,
  bool done,
  _Step? current,
  _Step? last,
});
```

3. Rename `_DrawCeremonyState` to `DrawCeremonyState` (public only so a test can check the same State survives a resize; its doc says so) and add:

```dart
  /// How many balls are out. For tests.
  @visibleForTesting
  int get revealed => _revealed;
```

4. Replace `build` with the following. `_frame`, `_stage`, `_groupCard` and `_controls` hold the phone's former inline code, moved unchanged (the long comments on waiting-pot order and on slots move with it):

```dart
  _DrawFrame _frame() {
    final revealedByGroup = <int, List<int>>{};
    for (final s in _steps.take(_revealed)) {
      (revealedByGroup[s.groupIndex] ??= []).add(s.nationId);
    }
    // (the moved comment on listing waiting nations in a FIXED order)
    final waitingByPot = <int, List<int>>{};
    for (var i = _revealed; i < _steps.length; i++) {
      (waitingByPot[_steps[i].pot] ??= []).add(_steps[i].nationId);
    }
    for (final pot in waitingByPot.values) {
      pot.sort();
    }
    final done = _revealed >= _steps.length;
    return (
      revealedByGroup: revealedByGroup,
      waitingByPot: waitingByPot,
      done: done,
      current: (!done && _revealed >= 0 && _revealed < _steps.length)
          ? _steps[_revealed]
          : null,
      last: _revealed > 0 ? _steps[_revealed - 1] : null,
    );
  }

  Widget _stage(_DrawFrame frame) {
    final last = frame.last;
    return _Stage(
      done: frame.done,
      step: last,
      groupName: last == null ? '' : widget.groups[last.groupIndex].name,
      // The teams already in the group the last team joined, for context.
      groupMembers: last == null
          ? const []
          : (frame.revealedByGroup[last.groupIndex] ?? const []),
      code: _code,
      name: _name,
    );
  }

  Widget _groupCard(AppLocalizations l, int gi, _DrawFrame frame) {
    final last = frame.last;
    return _GroupCard(
      title: l.tourSharedGroupName(widget.groups[gi].name),
      // (the moved comment on slots versus pots)
      slots: widget.groups[gi].nationIds.length,
      revealed: frame.revealedByGroup[gi] ?? const [],
      justAdded: !frame.done && last != null && last.groupIndex == gi
          ? last.nationId
          : null,
      highlightNationId: widget.highlightNationId,
      code: _code,
      name: _name,
    );
  }

  /// The draw-mode selector and its hint while the draw runs, then the
  /// buttons: pause or play and skip, or Continue once it is done.
  List<Widget> _controls(AppLocalizations l, bool done) => [
    // MOVED VERBATIM: the phone build's `if (!done) ...[ ... ],` block (the
    // SegmentedButton, its SizedBox and its hint) and the `SafeArea(...)`
    // that follows it.
  ];

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final frame = _frame();
    if (widget.landscape) return _landscape(l, frame);
    return Column(
      children: [
        _Pots(
          potCount: _pots,
          groupCount: widget.groups.length,
          waitingByPot: frame.waitingByPot,
          activePot: frame.current?.pot,
          highlightNationId: widget.highlightNationId,
          code: _code,
        ),
        _stage(frame),
        Expanded(
          // Tap anywhere over the groups to pull the next ball.
          child: GestureDetector(
            onTap: frame.done ? null : _drawNext,
            behavior: HitTestBehavior.opaque,
            child: GridView.count(
              crossAxisCount: widget.crossAxisCount,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.marginMobile,
              ),
              childAspectRatio: 0.92,
              mainAxisSpacing: AppSpacing.sm,
              crossAxisSpacing: AppSpacing.sm,
              children: [
                for (var gi = 0; gi < widget.groups.length; gi++)
                  _groupCard(l, gi, frame),
              ],
            ),
          ),
        ),
        ..._controls(l, frame.done),
      ],
    );
  }

  /// The landscape stage: the ball being drawn, the pots and the controls in
  /// a column on the left, the groups filling the rest.
  Widget _landscape(AppLocalizations l, _DrawFrame frame) {
    return Row(
      key: DrawCeremony.landscapeKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: DrawCeremony.landscapeSideWidth,
          child: Column(
            children: [
              _stage(frame),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (var pot = 0; pot < _pots; pot++)
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppSpacing.sm,
                          ),
                          child: _Pot(
                            index: pot,
                            total: widget.groups.length,
                            waiting: frame.waitingByPot[pot] ?? const [],
                            active: pot == frame.current?.pot,
                            highlightNationId: widget.highlightNationId,
                            code: _code,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              ..._controls(l, frame.done),
            ],
          ),
        ),
        const VerticalDivider(
          width: 1,
          thickness: 1,
          color: AppColors.outlineVariant,
        ),
        Expanded(
          // Tap anywhere over the groups to pull the next ball.
          child: GestureDetector(
            onTap: frame.done ? null : _drawNext,
            behavior: HitTestBehavior.opaque,
            child: LayoutBuilder(
              builder: (context, box) => _landscapeGroups(l, frame, box),
            ),
          ),
        ),
      ],
    );
  }

  /// The groups as a grid filling [box]: as many columns as fit at about 200
  /// wide (two at least), each card tall enough for a line per slot, and
  /// taller, up to half as much again, when every row fits without scrolling.
  Widget _landscapeGroups(
    AppLocalizations l,
    _DrawFrame frame,
    BoxConstraints box,
  ) {
    const pad = AppSpacing.md;
    const gap = AppSpacing.sm;
    final count = widget.groups.length;
    final width = box.maxWidth - 2 * pad;
    final height = box.maxHeight - 2 * pad;
    final columns = min(max(2, (width / 200).floor()), max(1, count));
    final rows = (count / columns).ceil();
    final minHeight = 34.0 + _largestGroup() * 24.0;
    final fitHeight = (height - (rows - 1) * gap) / rows;
    final tileHeight = max(minHeight, min(fitHeight, minHeight * 1.5));
    final tileWidth = (width - (columns - 1) * gap) / columns;
    return GridView.count(
      crossAxisCount: columns,
      padding: const EdgeInsets.all(pad),
      childAspectRatio: tileWidth / tileHeight,
      mainAxisSpacing: gap,
      crossAxisSpacing: gap,
      children: [
        for (var gi = 0; gi < count; gi++) _groupCard(l, gi, frame),
      ],
    );
  }
```

The two `MOVED`/`moved comment` markers are cut-and-paste instructions: paste the named code and comments, then delete the markers. `min` and `max` come from the file's existing unprefixed `import 'dart:math';`.

5. In `_Stage`, replace the English literal `'→ GROUP $groupName'` with

```dart
                        '→ ${AppLocalizations.of(context).tourSharedGroupName(groupName)}',
```

(`tourSharedGroupName` is "GROUP {name}" in English: the phone reads exactly as before, and other languages stop reading English.)

- [ ] **Step 6: The screens pass the choice**

In each of `qualifying_draw_screen.dart`, `continental_draw_screen.dart` and `nations_cup_draw_screen.dart`, import `package:fnm/core/layout/form_factor.dart` and add to the `DrawCeremony(...)` call:

```dart
            landscape: useTabletLayout(context, ref),
```

Nothing else in the screens changes: the Scaffold and app bar stay exactly where they are on both layouts, which is what keeps the ceremony's element (and State) in place across a resize.

Add `Routes.qualifyingDraw,`, `Routes.continentalDraw,` and `Routes.nationsCupDraw,` to `tabletReadyPaths`.

- [ ] **Step 7: Run, expect PASS**

Run: `flutter test test/widget/draw_ceremony_tablet_test.dart test/golden/phone_guard_draws_test.dart test/widget/draw_ceremony_test.dart test/widget/tablet_route_sweep_test.dart`
Expected: PASS, phone goldens unchanged. The full-screen sweep now asserts NO `FullScreenPhoneFrame` on the three draw routes.

- [ ] **Step 8: Prove Review Focus 2 bites**

Temporarily make the qualifying screen return `DrawCeremony(key: ValueKey(useTabletLayout(context, ref)), ...)` (a key that changes with the layout, so the ceremony remounts). The resize test must FAIL with "the draw restarted". Restore.

- [ ] **Step 9: Analyze, full suite, commit**

Run: `flutter analyze && flutter test`

```bash
git add lib/features/tournaments/draw_ceremony.dart lib/features/tournaments/qualifying_draw_screen.dart lib/features/tournaments/continental_draw_screen.dart lib/features/tournaments/nations_cup_draw_screen.dart lib/features/shell/tablet_shell.dart test/widget/draw_ceremony_tablet_test.dart
git commit -m "feat(tablet): draw ceremonies on a landscape stage, pots left, groups right

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 15: World Championship finals draw

**risk: high (per-task review)**. Full-screen event; its finish writes the watched flag and routes into the shell.

**Files:**
- Modify: `lib/features/tournaments/finals_draw_screen.dart`, `lib/features/shell/tablet_shell.dart`
- Test: `test/golden/phone_guard_finals_draw_test.dart` (new, with goldens), `test/widget/finals_draw_tablet_test.dart` (new)

**Interfaces:**
- Produces: `FinalsDrawScreen.potsLandscapeKey`; `_PotsPreview({..., bool landscape = false})`.
- Consumes: `finalsDrawProvider(careerId)` (unchanged), `DrawCeremony.landscape`, `useTabletLayout`, `Panel`, `l.tourDrawStart`, `l.tourDrawViewGroups` (replacing the English literals `'Start the draw'` and `'View groups'`; identical in English), `l.tourPot`, `l.tourFinalsDrawBlurb`.

- [ ] **Step 1: Pin the phone finals draw**

Create `test/golden/phone_guard_finals_draw_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/tournaments/finals_draw_providers.dart';

import '../helpers/competition_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The phone finals draw: the seeding pots, and the ceremony skipped to the
/// end. A fresh save has no finals draw, so it is a fake one.
void main() {
  testWidgets('finals_draw_phone_pots_tall', (tester) async {
    final save = await seedSave(
      tester,
      overrides: [
        finalsDrawProvider(
          kSeededCareerId,
        ).overrideWith((ref) async => fakeFinalsDraw(seededNationId)),
      ],
    );
    await pumpRoute(
      tester,
      save,
      '${Routes.finalsDraw}?careerId=${save.careerId}',
      size: const Size(390, 2400),
    );
    expect(find.text('Start the draw'), findsOneWidget);
    await expectAppGolden('goldens/finals_draw_phone_pots_tall.png');
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('finals_draw_phone_done', (tester) async {
    final save = await seedSave(
      tester,
      overrides: [
        finalsDrawProvider(
          kSeededCareerId,
        ).overrideWith((ref) async => fakeFinalsDraw(seededNationId)),
      ],
    );
    await pumpRoute(
      tester,
      save,
      '${Routes.finalsDraw}?careerId=${save.careerId}',
    );
    await tester.tap(find.text('Start the draw'));
    await tester.pump();
    await tester.tap(find.text(enL.tourSharedSkip));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await expectAppGolden('goldens/finals_draw_phone_done.png');
    await tester.pumpWidget(const SizedBox());
  });
}
```

(The literal `'Start the draw'` is the screen's text today; it stays the English value of `tourDrawStart`, so this test keeps passing after Step 5.)

- [ ] **Step 2: Create the baseline, confirm it holds, commit it**

```bash
flutter test --update-goldens test/golden/phone_guard_finals_draw_test.dart
flutter test test/golden/phone_guard_finals_draw_test.dart
git add test/golden/phone_guard_finals_draw_test.dart test/golden/goldens/finals_draw_phone_pots_tall.png test/golden/goldens/finals_draw_phone_done.png
git commit -m "test(tablet): phone guard for the finals draw

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

- [ ] **Step 3: Write the failing tablet test**

Create `test/widget/finals_draw_tablet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/tournaments/draw_ceremony.dart';
import 'package:fnm/features/tournaments/finals_draw_providers.dart';
import 'package:fnm/features/tournaments/finals_draw_screen.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/competition_fixtures.dart';
import '../helpers/seeded_save.dart';

Future<SeededSave> _open(WidgetTester tester, Size size) async {
  final save = await seedSave(
    tester,
    formFactor: FormFactor.tablet,
    overrides: [
      finalsDrawProvider(
        kSeededCareerId,
      ).overrideWith((ref) async => fakeFinalsDraw(seededNationId)),
    ],
  );
  await pumpRoute(
    tester,
    save,
    '${Routes.finalsDraw}?careerId=${save.careerId}',
    size: size,
  );
  return save;
}

void main() {
  for (final size in kTabletSizes) {
    testWidgets('four pots side by side, then the landscape stage, $size', (
      tester,
    ) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(FinalsDrawScreen.potsLandscapeKey), findsOneWidget);
      expect(find.byType(FullScreenPhoneFrame), findsNothing);
      final pot1 = tester.getCenter(find.text(enL.tourPot(1)));
      final pot4 = tester.getCenter(find.text(enL.tourPot(4)));
      expect(pot1.dy, pot4.dy, reason: 'the pots share a row');
      expect(pot4.dx, greaterThan(pot1.dx));

      await tester.tap(find.text(enL.tourDrawStart));
      await tester.pump();
      expect(find.byKey(DrawCeremony.landscapeKey), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('finishing the draw marks it watched and opens the cup', (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    await tester.tap(find.text(enL.tourDrawStart));
    await tester.pump();
    await tester.tap(find.text(enL.tourSharedSkip));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.widgetWithText(PrimaryButton, enL.tourSharedContinue));
    await settle(tester);
    expect(
      save.container.read(routerProvider).routeInformationProvider.value.uri.path,
      Routes.cup,
    );
    late bool watched;
    await tester.runAsync(() async {
      watched = await save.container
          .read(competitionRepositoryProvider)
          .hasWatchedDraw(save.careerId, 0, worldCupDrawKind);
    });
    expect(watched, isTrue);
    await tester.pumpWidget(const SizedBox());
  });
}
```

- [ ] **Step 4: Run it to verify it fails**

Run: `flutter test test/widget/finals_draw_tablet_test.dart`
Expected: FAIL to compile (`FinalsDrawScreen.potsLandscapeKey`, `tourDrawStart` exists since Task 3).

- [ ] **Step 5: The landscape pots and stage**

In `lib/features/tournaments/finals_draw_screen.dart`:

1. Import `package:fnm/core/layout/form_factor.dart` and `package:fnm/shared/tablet/tablet.dart`.

2. In `FinalsDrawScreen` add `static const Key potsLandscapeKey = Key('finalsDraw.potsLandscape');`.

3. In `_FinalsDrawScreenState.build`, add after `final dataAsync = ...`:

```dart
    final landscape = useTabletLayout(context, ref);
```

pass `landscape: landscape,` to the `DrawCeremony(...)` and to `_PotsPreview(...)`, and replace the button label expression with:

```dart
            buttonLabel: data.alreadyWatched
                ? l.tourDrawViewGroups
                : l.tourDrawStart,
```

4. `_PotsPreview`: add `this.landscape = false,` to the constructor and `final bool landscape;` (doc: "A tablet: the pots side by side, the button bottom right."). In `build`, after `name` is defined and before the phone `return Column(`, add:

```dart
    if (landscape) {
      return Column(
        key: FinalsDrawScreen.potsLandscapeKey,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              0,
            ),
            child: Text(
              l.tourFinalsDrawBlurb,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var pot = 1; pot <= potCount; pot++) ...[
                    if (pot > 1) const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Panel(
                        title: l.tourPot(pot),
                        expand: true,
                        child: ListView(
                          children: [
                            for (final id in byPot[pot] ?? const <int>[])
                              _potRow(
                                code(id),
                                name(id),
                                isPlayer: id == data.playerNationId,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 320,
                  child: PrimaryButton(
                    label: buttonLabel,
                    icon: buttonIcon,
                    onPressed: onStart,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
```

`_PotsPreview` swaps for the ceremony through the screen State's `_drawing` flag, which a resize does not touch.

5. Add `Routes.finalsDraw,` to `tabletReadyPaths`.

- [ ] **Step 6: Run, expect PASS**

Run: `flutter test test/widget/finals_draw_tablet_test.dart test/golden/phone_guard_finals_draw_test.dart test/widget/tablet_route_sweep_test.dart`
Expected: PASS, phone goldens unchanged.

- [ ] **Step 7: Analyze, full suite, commit**

Run: `flutter analyze && flutter test`

```bash
git add lib/features/tournaments/finals_draw_screen.dart lib/features/shell/tablet_shell.dart test/widget/finals_draw_tablet_test.dart
git commit -m "feat(tablet): finals draw with the pots side by side and the landscape stage

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 16: Host selection

**risk: high (per-task review)**. Full-screen event; opening the envelope writes the watched flag.

**Files:**
- Modify: `lib/features/tournaments/host_draw_screen.dart`, `lib/features/shell/tablet_shell.dart`
- Test: `test/golden/phone_guard_host_draw_test.dart` (new, with goldens), `test/widget/host_draw_tablet_test.dart` (new)

**Interfaces:**
- Produces: `HostDrawScreen.landscapeKey`; State helpers `List<Widget> _heading(AppLocalizations l, HostDrawData data, int hostCount)`, `Widget _candidates(HostDrawData data)`, `Widget _action(AppLocalizations l, HostDrawData data)`, `Widget _landscape(AppLocalizations l, HostDrawData data, List<({String code, String name})> hosts)`.
- Consumes: `hostDrawProvider` (unchanged), `useTabletLayout`, `l.tourSharedHostHeading`, `l.tourSharedCoHostsHeading` (replacing the English literals `'HOST'` and `'CO-HOSTS'` in `_Envelope`; identical in English), `l.tourCandidates`.

- [ ] **Step 1: Pin the phone host selection**

Create `test/golden/phone_guard_host_draw_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';

import '../helpers/seeded_save.dart';

/// The phone host selection on the seeded save (its first event is the
/// continental host draw): the sealed envelope, and the envelope opened.
void main() {
  testWidgets('host_draw_phone', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.hostDraw}?careerId=${save.careerId}',
    );
    expect(find.text(enL.tourCandidates), findsOneWidget);
    await expectAppGolden('goldens/host_draw_phone.png');
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('host_draw_phone_open_tall', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.hostDraw}?careerId=${save.careerId}',
      size: const Size(390, 1400),
    );
    await tester.tap(find.text(enL.tourSharedOpenEnvelope));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await settle(tester);
    await expectAppGolden('goldens/host_draw_phone_open_tall.png');
    await tester.pumpWidget(const SizedBox());
  });
}
```

- [ ] **Step 2: Create the baseline, confirm it holds, commit it**

```bash
flutter test --update-goldens test/golden/phone_guard_host_draw_test.dart
flutter test test/golden/phone_guard_host_draw_test.dart
git add test/golden/phone_guard_host_draw_test.dart test/golden/goldens/host_draw_phone.png test/golden/goldens/host_draw_phone_open_tall.png
git commit -m "test(tablet): phone guard for the host selection

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

Open the second PNG: the host's flag and name under "HOST" or "CO-HOSTS", the losing bids dimmed.

- [ ] **Step 3: Write the failing tablet test**

Create `test/widget/host_draw_tablet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/tournaments/host_draw_providers.dart';
import 'package:fnm/features/tournaments/host_draw_screen.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/seeded_save.dart';

Future<SeededSave> _open(WidgetTester tester, Size size) async {
  final save = await seedSave(tester, formFactor: FormFactor.tablet);
  await pumpRoute(
    tester,
    save,
    '${Routes.hostDraw}?careerId=${save.careerId}',
    size: size,
  );
  return save;
}

void main() {
  for (final size in kTabletSizes) {
    testWidgets('the envelope left, the candidates right, $size', (
      tester,
    ) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(HostDrawScreen.landscapeKey), findsOneWidget);
      expect(find.byType(FullScreenPhoneFrame), findsNothing);
      expect(
        tester.getCenter(find.byIcon(Icons.mail_outline_rounded).first).dx,
        lessThan(tester.getCenter(find.text(enL.tourCandidates)).dx),
      );
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('opening the envelope marks it seen; Continue goes home', (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    await tester.tap(find.text(enL.tourSharedOpenEnvelope));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await settle(tester);
    expect(tester.takeException(), isNull);
    late bool watched;
    await tester.runAsync(() async {
      watched = await save.container
          .read(competitionRepositoryProvider)
          .hasWatchedDraw(
            save.careerId,
            save.career.cyclePointer,
            continentalHostDrawKind,
          );
    });
    expect(watched, isTrue);
    await tester.tap(find.widgetWithText(PrimaryButton, enL.tourSharedContinue));
    await settle(tester);
    expect(
      save.container.read(routerProvider).routeInformationProvider.value.uri.path,
      Routes.hub,
    );
    await tester.pumpWidget(const SizedBox());
  });
}
```

- [ ] **Step 4: Run it to verify it fails**

Run: `flutter test test/widget/host_draw_tablet_test.dart`
Expected: FAIL to compile (`HostDrawScreen.landscapeKey`).

- [ ] **Step 5: Split the body; the landscape**

In `lib/features/tournaments/host_draw_screen.dart`:

1. Import `package:fnm/core/layout/form_factor.dart`; add `static const Key landscapeKey = Key('hostDraw.landscape');` to `HostDrawScreen`.

2. Add to `_HostDrawScreenState` (moved code; the phone calls them in the same places):

```dart
  /// The edition and what the envelope is about to say (or has said).
  List<Widget> _heading(
    AppLocalizations l,
    HostDrawData data,
    int hostCount,
  ) => [
    Text('${data.title} · ${data.year}', style: AppTypography.headlineMedium),
    const SizedBox(height: AppSpacing.xs),
    Text(
      _revealed
          ? (hostCount > 1 ? l.tourDrawHostsReveal : l.tourDrawHostReveal)
          : l.tourDrawHostCandidates,
      style: AppTypography.bodyMedium.copyWith(
        color: AppColors.onSurfaceVariant,
      ),
    ),
  ];

  /// Every bid on the table, the winning one lit once revealed.
  Widget _candidates(HostDrawData data) => Wrap(
    // MOVED VERBATIM: the phone's candidates `Wrap(...)` arguments
    // (spacing, runSpacing and the `children` building each `_Candidate`).
  );

  /// Open the envelope, then Continue.
  Widget _action(AppLocalizations l, HostDrawData data) => _revealed
      ? PrimaryButton(
          label: l.tourSharedContinue,
          icon: Icons.check_rounded,
          onPressed: _toHub,
        )
      : PrimaryButton(
          label: l.tourSharedOpenEnvelope,
          icon: Icons.mail_outline_rounded,
          onPressed: () => unawaited(_reveal(data)),
        );

  /// A tablet: the edition and the envelope on the left, the bids on the
  /// right, the action bottom right.
  Widget _landscape(
    AppLocalizations l,
    HostDrawData data,
    List<({String code, String name})> hosts,
  ) {
    return Padding(
      key: HostDrawScreen.landscapeKey,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ..._heading(l, data, hosts.length),
                        const SizedBox(height: AppSpacing.lg),
                        _Envelope(revealed: _revealed, hosts: hosts),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.xl),
                Expanded(
                  flex: 6,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.tourCandidates,
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _candidates(data),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(width: 320, child: _action(l, data)),
          ),
        ],
      ),
    );
  }
```

Paste the named `Wrap` arguments; delete the marker.

3. In `build`, add `final landscape = useTabletLayout(context, ref);` after the `async` watch. In the data callback, after `hosts` is built, add `if (landscape) return _landscape(l, data, hosts);`, and in the phone `ListView` replace the two heading texts (and the `SizedBox` between them) with `..._heading(l, data, hosts.length),`, the candidates `Wrap(...)` with `_candidates(data),`, and the bottom bar's `_revealed ? PrimaryButton(...) : PrimaryButton(...)` with `_action(l, data)`.

4. In `_Envelope`'s builder, replace `multi ? 'CO-HOSTS' : 'HOST'` with:

```dart
                              multi
                                  ? AppLocalizations.of(
                                      context,
                                    ).tourSharedCoHostsHeading
                                  : AppLocalizations.of(
                                      context,
                                    ).tourSharedHostHeading,
```

(English values "CO-HOSTS" and "HOST": the phone golden holds.)

5. Add `Routes.hostDraw,` to `tabletReadyPaths`.

- [ ] **Step 6: Run, expect PASS**

Run: `flutter test test/widget/host_draw_tablet_test.dart test/golden/phone_guard_host_draw_test.dart test/widget/tablet_route_sweep_test.dart`
Expected: PASS, phone goldens unchanged.

- [ ] **Step 7: Analyze, full suite, commit**

Run: `flutter analyze && flutter test`

```bash
git add lib/features/tournaments/host_draw_screen.dart lib/features/shell/tablet_shell.dart test/widget/host_draw_tablet_test.dart
git commit -m "feat(tablet): host selection with the envelope beside the bids

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---
### Task 17: Tournament kickoff

**risk: high (per-task review)**. Full-screen event with an entrance animation; its button writes the watched flag.

**Files:**
- Modify: `lib/features/tournaments/tournament_kickoff_screen.dart`, `lib/features/shell/tablet_shell.dart`
- Test: `test/golden/phone_guard_kickoff_test.dart` (new, with golden), `test/widget/tournament_kickoff_tablet_test.dart` (new)

**Interfaces:**
- Produces: `TournamentKickoffScreen.landscapeKey`; private helpers `Widget _rise(Widget child)` (the entrance animation), `Widget _trophy(KickoffData? data, {required double height, required double iconSize})`.
- Consumes: `tournamentKickoffProvider((careerId:, conf:))` (unchanged, names its confederation), `useTabletLayout`, the screen's own `_begin(context, ref)`.

- [ ] **Step 1: Pin the phone kickoff**

Create `test/golden/phone_guard_kickoff_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';

import '../helpers/seeded_save.dart';

/// The phone World Championship kickoff once its entrance has played out.
void main() {
  testWidgets('kickoff_phone', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.tournamentKickoff}?careerId=${save.careerId}',
    );
    await tester.pump(const Duration(milliseconds: 1200));
    expect(find.text(enL.tourSharedFinalsAreHere), findsOneWidget);
    await expectAppGolden('goldens/kickoff_phone.png');
    await tester.pumpWidget(const SizedBox());
  });
}
```

- [ ] **Step 2: Create the baseline, confirm it holds, commit it**

```bash
flutter test --update-goldens test/golden/phone_guard_kickoff_test.dart
flutter test test/golden/phone_guard_kickoff_test.dart
git add test/golden/phone_guard_kickoff_test.dart test/golden/goldens/kickoff_phone.png
git commit -m "test(tablet): phone guard for the tournament kickoff

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

Open the PNG: the trophy at full size (the entrance finished), not a faded, shrunken one.

- [ ] **Step 3: Write the failing tablet test**

Create `test/widget/tournament_kickoff_tablet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/competition/kickoff_keys.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/tournaments/tournament_kickoff_screen.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/seeded_save.dart';

Future<SeededSave> _open(WidgetTester tester, Size size) async {
  final save = await seedSave(tester, formFactor: FormFactor.tablet);
  await pumpRoute(
    tester,
    save,
    '${Routes.tournamentKickoff}?careerId=${save.careerId}',
    size: size,
  );
  await tester.pump(const Duration(milliseconds: 1200));
  return save;
}

void main() {
  for (final size in kTabletSizes) {
    testWidgets('the trophy beside the words, full screen, $size', (
      tester,
    ) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(TournamentKickoffScreen.landscapeKey), findsOneWidget);
      expect(find.byType(FullScreenPhoneFrame), findsNothing);
      expect(
        tester.getCenter(find.byType(Image).first).dx,
        lessThan(tester.getCenter(find.text(enL.tourSharedFinalsAreHere)).dx),
      );
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('beginning marks the kickoff seen and goes to the hub', (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    await tester.tap(
      find.widgetWithText(PrimaryButton, enL.tourSharedLetFinalsBegin),
    );
    await settle(tester);
    expect(
      save.container.read(routerProvider).routeInformationProvider.value.uri.path,
      Routes.hub,
    );
    late bool watched;
    await tester.runAsync(() async {
      watched = await save.container
          .read(competitionRepositoryProvider)
          .hasWatchedDraw(
            save.careerId,
            save.career.cyclePointer,
            worldCupKickoffKind,
          );
    });
    expect(watched, isTrue);
    await tester.pumpWidget(const SizedBox());
  });
}
```

(`find.byType(Image).first` is the trophy: the flags are drawn by `FlagDisc`, after it in the tree. If a flag implementation also uses `Image`, scope the finder with `find.descendant(of: find.byKey(TournamentKickoffScreen.landscapeKey), matching: find.byType(Image)).first`.)

- [ ] **Step 4: Run it to verify it fails**

Run: `flutter test test/widget/tournament_kickoff_tablet_test.dart`
Expected: FAIL to compile (`TournamentKickoffScreen.landscapeKey`).

- [ ] **Step 5: Share the animation and the trophy; the landscape**

In `lib/features/tournaments/tournament_kickoff_screen.dart`:

1. Import `package:fnm/core/layout/form_factor.dart`; add `static const Key landscapeKey = Key('kickoff.landscape');` to the screen.

2. Add to the screen class:

```dart
  /// The entrance: everything rises and fades in, overshooting a little.
  Widget _rise(Widget child) => TweenAnimationBuilder<double>(
    tween: Tween(begin: 0, end: 1),
    duration: const Duration(milliseconds: 1100),
    curve: Curves.easeOutBack,
    builder: (context, t, child) {
      final c = t.clamp(0.0, 1.0);
      return Opacity(
        opacity: c,
        child: Transform.scale(scale: 0.55 + 0.45 * c, child: child),
      );
    },
    child: child,
  );

  Widget _trophy(
    KickoffData? data, {
    required double height,
    required double iconSize,
  }) => Image.asset(
    data?.trophyAsset ?? Trophies.worldCup,
    height: height,
    fit: BoxFit.contain,
    errorBuilder: (_, _, _) =>
        Icon(Icons.emoji_events, size: iconSize, color: AppColors.primary),
  );
```

3. In `build`, add `final landscape = useTabletLayout(context, ref);` after the `async` watch. In the data callback, phone: replace the `TweenAnimationBuilder<double>(...)` with `_rise(Padding(...))` (the same `Padding` and `Column` it wrapped) and the `Image.asset(...)` inside it with `_trophy(data, height: 220, iconSize: 140)`. Before the phone `return Column(`, add:

```dart
            if (landscape) {
              return Row(
                key: landscapeKey,
                children: [
                  Expanded(
                    child: Center(
                      child: _rise(_trophy(data, height: 320, iconSize: 200)),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: _rise(
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: AppTypography.labelMedium.copyWith(
                                color: AppColors.primary,
                                letterSpacing: 3,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              l.tourSharedFinalsAreHere,
                              style: AppTypography.headlineMedium.copyWith(
                                color: AppColors.onSurface,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            if (data != null && data.hostCodes.isNotEmpty)
                              Wrap(
                                spacing: AppSpacing.sm,
                                children: [
                                  for (final c in data.hostCodes)
                                    FlagDisc(c, size: 36),
                                ],
                              ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              l.tourHostedBy(hostLabel),
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            SizedBox(
                              width: 320,
                              child: PrimaryButton(
                                label: l.tourSharedLetFinalsBegin,
                                icon: Icons.sports_soccer,
                                onPressed: () => _begin(context, ref),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
```

4. Add `Routes.tournamentKickoff,` to `tabletReadyPaths`.

- [ ] **Step 6: Run, expect PASS**

Run: `flutter test test/widget/tournament_kickoff_tablet_test.dart test/golden/phone_guard_kickoff_test.dart test/widget/tablet_route_sweep_test.dart`
Expected: PASS, phone golden unchanged.

- [ ] **Step 7: Analyze, full suite, commit**

Run: `flutter analyze && flutter test`

```bash
git add lib/features/tournaments/tournament_kickoff_screen.dart lib/features/shell/tablet_shell.dart test/widget/tournament_kickoff_tablet_test.dart
git commit -m "feat(tablet): tournament kickoff with the trophy beside the words

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 18: Match preview: one derivation for both layouts (stage 2 carry-over)

**risk: high (per-task review)**. A refactor of a core-loop screen on both form factors.

The stage 2 review found the tablet preview repeating about a hundred lines of the phone's derivation (which side is the manager's, the opponent, the key men, the XI with its slots), so a fix to one could miss the other. Both layouts now read one `_PreviewParts`.

**Files:**
- Modify: `lib/features/match/match_preview_screen.dart`, `lib/features/match/match_preview_tablet_layout.dart`
- Test: the existing `test/golden/phone_guard_match_preview_test.dart` (both goldens) and `test/widget/match_preview_tablet_test.dart` pin the two layouts; this task adds no behaviour, so it adds no failing test. Step 1 proves the pins are green before the move.

**Interfaces:**
- Produces: in the library, `class _PreviewParts { _PreviewParts({required MatchPreview preview, required int careerId, required AppLocalizations l10n, required WcHostTheme? host, required Set<String> themedRounds}); bool hosted; Fixture fixture; MatchTeam team; int myNationId; int oppNationId; String code(int); String name(int); Widget headline(); Widget briefing(); Widget groundTitle(); Widget ground(); Widget strength(); Widget xiHeader(); Widget xiCard(); }`.
- Consumes: `matchPreviewProvider` (unchanged), `_keyMen`, `_XiRow`, `MatchHeadline`, `OpponentBriefing`, `GroundCard`, `StrengthPanel`.

- [ ] **Step 1: The pins are green**

Run: `flutter test test/golden/phone_guard_match_preview_test.dart test/widget/match_preview_tablet_test.dart`
Expected: PASS.

- [ ] **Step 2: `_PreviewParts`**

In `lib/features/match/match_preview_screen.dart`, add the imports `package:fnm/domain/entities/fixture.dart` and `package:fnm/domain/services/match/match_engine.dart` (for `MatchTeam`; add `show MatchTeam` if the analyzer reports a name clash), and add after `MatchPreviewScreen`:

```dart
/// Everything both preview layouts read off one [MatchPreview], worked out
/// once, and the pieces both draw. The phone stacks them in one list; the
/// tablet splits them over two columns.
class _PreviewParts {
  _PreviewParts({
    required this.preview,
    required this.careerId,
    required this.l10n,
    required WcHostTheme? host,
    required Set<String> themedRounds,
  }) : hosted = host != null && themedRounds.contains(preview.fixture.round);

  final MatchPreview preview;
  final int careerId;
  final AppLocalizations l10n;

  /// Whether this match is played in the live finals, under its host's skin.
  final bool hosted;

  Fixture get fixture => preview.fixture;

  MatchTeam get team =>
      preview.playerIsHome ? preview.homeTeam : preview.awayTeam;

  int get myNationId =>
      preview.playerIsHome ? fixture.homeNationId : fixture.awayNationId;

  int get oppNationId =>
      preview.playerIsHome ? fixture.awayNationId : fixture.homeNationId;

  String code(int id) => preview.nations[id]?.code ?? '??';

  String name(int id) =>
      preview.nations[id]?.name ?? l10n.matchUnknownNation;

  Widget headline() => MatchHeadline(
    homeCode: code(fixture.homeNationId),
    homeOverall: squadOverall(preview.homeTeam.xi),
    awayCode: code(fixture.awayNationId),
    awayOverall: squadOverall(preview.awayTeam.xi),
    date: fixture.date,
  );

  // Head-to-head and the scouting report share one card as two tabs.
  Widget briefing() => OpponentBriefing(
    careerId: careerId,
    myNationId: myNationId,
    oppNationId: oppNationId,
    oppName: name(oppNationId),
    oppCode: code(oppNationId),
    keyMen: _keyMen(
      preview.playerIsHome ? preview.awayTeam.xi : preview.homeTeam.xi,
    ),
    saveSeed: preview.saveSeed,
  );

  Widget groundTitle() => Text(
    l10n.matchGroundTitle,
    style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
  );

  Widget ground() => GroundCard(
    ground: preview.ground,
    neutral: preview.neutralVenue,
    groundNationCode: code(preview.ground.groundNationId),
  );

  // What is helping and what is hurting, before he picks.
  Widget strength() => StrengthPanel(
    careerId: careerId,
    formation: team.formation,
    sideRating: team.xi.isEmpty
        ? StrengthFactors.defaultSideRating
        : squadOverall(team.xi),
  );

  Widget xiHeader() => Row(
    children: [
      Text(
        l10n.matchYourXi,
        style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
      ),
      const SizedBox(width: AppSpacing.sm),
      Text(
        team.formation.label,
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),
    ],
  );

  Widget xiCard() {
    final xi = team.xi;
    final positions = team.formation.positions;
    return AppCard(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.sm,
        horizontal: AppSpacing.md,
      ),
      child: Column(
        children: [
          for (var i = 0; i < xi.length; i++)
            _XiRow(
              player: xi[i],
              slot: i < positions.length ? positions[i] : xi[i].position,
            ),
        ],
      ),
    );
  }
}
```

(Move the phone's longer comments at these call sites onto the matching methods rather than dropping them.)

- [ ] **Step 3: The phone reads it**

In `MatchPreviewScreen.build`'s data callback, replace everything from `final f = preview.fixture;` to the end of the `ListView` with:

```dart
          final p = _PreviewParts(
            preview: preview,
            careerId: careerId,
            l10n: l10n,
            host: host,
            themedRounds: themedRounds,
          );
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            children: [
              if (p.hosted) ...[
                WcHostBanner(theme: host!, code: p.code),
                const SizedBox(height: AppSpacing.md),
              ],
              Center(
                child: Text(
                  MatchStage.label(l10n, p.fixture),
                  style: AppTypography.labelSmall.copyWith(
                    color: p.hosted ? accent : AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              // Both the armband and the set-piece takers default to "let the
              // engine decide", which is fine to play with and terrible to
              // never be told about.
              SquadSetupWarning(careerId: careerId),
              p.headline(),
              const SizedBox(height: AppSpacing.lg),
              p.briefing(),
              const SizedBox(height: AppSpacing.lg),
              p.groundTitle(),
              const SizedBox(height: AppSpacing.sm),
              p.ground(),
              const SizedBox(height: AppSpacing.lg),
              p.strength(),
              p.xiHeader(),
              const SizedBox(height: AppSpacing.sm),
              p.xiCard(),
              const SizedBox(height: AppSpacing.xl),
            ],
          );
```

(`host!` is safe: `p.hosted` is only true when `host` is not null. If the analyzer reports the `!` unnecessary, the existing code was relying on a promotion: drop the `!`.)

- [ ] **Step 4: The tablet reads it**

In `lib/features/match/match_preview_tablet_layout.dart`, in the data callback replace the locals from `final f = preview.fixture;` to `final hosted = ...;` with

```dart
          final p = _PreviewParts(
            preview: preview,
            careerId: careerId,
            l10n: l10n,
            host: host,
            themedRounds: themedRounds,
          );
```

and in the tree: `MatchStage.label(l10n, f)` becomes `MatchStage.label(l10n, p.fixture)`; `hosted` becomes `p.hosted`; `WcHostBanner(theme: host!, code: code)` becomes `WcHostBanner(theme: host!, code: p.code)`; the left column's `MatchHeadline(...)`, `StrengthPanel(...)`, the "Your XI" `Row(...)` and the XI `AppCard(...)` become `p.headline()`, `p.strength()`, `p.xiHeader()`, `p.xiCard()`; the right column's `OpponentBriefing(...)`, the ground title `Text(...)` and `GroundCard(...)` become `p.briefing()`, `p.groundTitle()`, `p.ground()`. The `SizedBox` spacers stay where they are.

- [ ] **Step 5: The pins still hold**

Run: `flutter test test/golden/phone_guard_match_preview_test.dart test/widget/match_preview_tablet_test.dart test/widget/tactics_tablet_test.dart`
Expected: PASS, both phone goldens unchanged. (`tactics_tablet_test` covers `OpponentBriefing`'s other host.)

- [ ] **Step 6: Analyze, full suite, commit**

Run: `flutter analyze && flutter test`

```bash
git add lib/features/match/match_preview_screen.dart lib/features/match/match_preview_tablet_layout.dart
git commit -m "refactor(tablet): one match preview derivation for phone and tablet

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 19: Record stage 3 in the spec, verify, simulator checks

**Files:**
- Modify: `docs/superpowers/specs/2026-10-09-tablet-ui-design.md`

- [ ] **Step 1: Add a section to the spec, after "Stage 2 adjustments"**

```markdown
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
```

- [ ] **Step 2: Full verification**

```bash
flutter analyze
flutter test
```

Expected: no analyzer issues (infos allowed only where they already existed at `9f70144`); the FINAL summary line of `flutter test` reads "All tests passed!" with no `-N` failures. Paste that line into the task report. Every `test/golden/phone_guard_*` golden passes WITHOUT `--update-goldens`; `git status` shows no changed PNG.

- [ ] **Step 3: Commit the spec**

```bash
git add docs/superpowers/specs/2026-10-09-tablet-ui-design.md
git commit -m "docs: record tablet stage 3 adjustments in the spec

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

`simctl install` over an installed app upgrades it in place and keeps its saves; never `simctl uninstall`. Then, with a save open, take one screenshot per screen family and attach their paths to the report:

```bash
mkdir -p /tmp/fnm-stage3
xcrun simctl io booted screenshot /tmp/fnm-stage3/tournaments.png
```

(repeat after navigating: `cup.png`, `continental.png`, `nations-cup.png`, `ranking.png`, `results.png`, `draw.png`, `kickoff.png`). Read each PNG back and check it against the mockup (`Competitions.dc.html`): list left, tabs right, group tables in columns.

- [ ] **Step 5: Manual checklist (the user drives the simulator)**

Ask the user to do each of these and report back; note each result in the task report:

1. **Tournaments.** Sidebar Tournaments: the competition list left, the live competition open on the right in its own tabs. Pick another continent's championship: its own tabs, its own groups. Pick a competition marked SOON: "Tournament coming soon". The World Ranking row opens the ranking.
2. **Groups in columns.** In the World Championship and your continental cup, the qualifying (and finals) group tables sit two or three to a row; the bracket tab opens as a bracket filling the width; the List and Bracket toggle still works.
3. **Nations Cup.** Sidebar Nations Cup: your league's tab first, its groups side by side; the other leagues' tabs; Finals, Scorers, History.
4. **Ranking.** A sortable table (tap Rank, Points, Nation); your nation's record on the right; tap another nation, the record follows; a region chip narrows the table; the locate button brings your row back into view.
5. **Results.** Your cycles on the left; the current cycle's competitions on the right; "Earlier matches" folds open and shut.
6. **A draw.** From the hub, Continue into a draw: full screen, pots left, groups right; Ball, Pot and All; Pause, Play, Skip; tap the groups to draw a ball; Continue back to the hub. The hub no longer offers that draw.
7. **Continue under a competition screen.** With Tournaments (or Results) open, press the top bar's Continue until a match is played: the table on screen updates without leaving the screen.
8. **Kickoff.** When a finals kicks off: the trophy left, the words and "Let the finals begin" right.
9. **Tour.** Settings, replay the tour; at its Competitions step the World Ranking row in the list is lit.

- [ ] **Step 6: Phone sanity check**

Run the app on an iPhone simulator (`flutter run -d <iPhone simulator id>`; a simulator, so `flutter run` upgrading in place is fine). Tournaments, the World Championship and continental screens, Nations Cup, ranking, results, a draw and a kickoff look and behave exactly as before: bottom nav where it was, tiles, tabs, the phone ceremony.

- [ ] **Step 7: Android tablet**

No Android emulator is installed on this Mac (stage 1 finding). Record in the report that the Android tablet check (Pixel Tablet AVD or a real tablet; installs upgrade in place with `adb install -r`, never `flutter install`, never `adb uninstall`) is left for the user.
