# Tablet UI, Stage 2: Core loop. Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** A full cycle is playable on a tablet in landscape: Hub, Inbox, Squad, Tactics, Call-ups, match preview, the live Match (and its in-match tactics editor) and round results each get a tablet layout, players open in a right-hand detail pane, and every in-shell route is swept at tablet size for layout errors.

**Architecture:** Each converted screen keeps its providers and its State and only chooses a layout at the top of `build`. In-shell screens choose by `TabletShellScope.isActive(context)`; full-screen routes (Match, the in-match editor) choose by `useTabletLayout(context, ref)` (startup form factor is tablet AND the window is tablet sized). The phone tree is left exactly where it is (the tablet branch returns early) or, where the two layouts must share pieces, the pieces are pulled into private builder methods that the phone tree calls in the same places. Tablet layouts live in `part` files next to their screen so they can reuse its private widgets. A screen whose tablet layout uses the whole content area is added to `tabletReadyPaths`. `PlayerView` is extracted from the player screen and hosted by a new `DetailPaneHost`.

**Tech Stack:** Flutter, flutter_riverpod 2.6 (manual providers, no codegen), go_router 17, gen_l10n (5 ARB locales on this branch), flutter_test golden files for the phone guards.

**Spec:** `docs/superpowers/specs/2026-10-09-tablet-ui-design.md` (stage 2 = "Core loop"; read "Stage 1 adjustments", which moved `DetailPaneHost`, the `*View` extractions and the route sweep into this stage).

**Stage 1 plan (conventions, shell and kit APIs):** `docs/superpowers/plans/2026-10-09-tablet-ui-stage1-foundation.md`. The code is the source of truth where the two differ: `TabletTopBar.height` is 56, `TabletShell` wraps its frame in a `Material`, sheets on tablet are root dialogs of width `min(560, window - 64)`.

## Global Constraints

- Phones keep the current UI exactly. Nothing in the phone path changes behaviour. Every converted screen gets a phone guard golden BEFORE it is touched, and that golden must pass unchanged after.
- Tablet = `shortestSide >= 600` logical px. Landscape only on tablets. Portrait is not designed or tested.
- In-shell screens pick their tablet layout with `TabletShellScope.isActive(context)`. Full-screen routes pick it with `useTabletLayout(context, ref)` (added in Task 1), never with `context.isTabletWindow` alone: Flutter's default test window is 800 x 600 logical, which is tablet sized, and every existing match test would silently switch layouts.
- Release target: v1.0.4 on both iOS and Android. Do not bump `pubspec.yaml` in this stage.
- No `@riverpod` codegen; write providers by hand (`Provider`, `StateProvider`, `FutureProvider`). No change to game logic, existing providers' behaviour or the database schema. The one new provider (`opponentKeyMenProvider`, Task 12) is a read-only UI query.
- Derived providers go stale after a sim step (they read the DB imperatively). A tablet panel may only `watch` providers the phone hub already keeps alive or that `SeasonService`'s invalidation cascade refreshes; `federationBuildingsProvider` is the one exception and only changes on the budget screen and at rollover, both of which leave the hub.
- Draw ceremonies read stored groups; nothing here re-runs a draw. The opponent stays hidden until the draw is watched (`HubData.nextDrawWatched`).
- If any `build_runner` step is needed, run it with `--force-jit`. (Nothing in this plan should need it.)
- All new user-facing strings go into all 5 ARB files on this branch (`en cs fr it pl`), then `flutter gen-l10n`, then `dart run tool/export_copy.dart` so `copy/strings.csv` stays in sync. German and Spanish ARB files are not on this branch; the 8 new keys of Task 2 must be added to them when that work merges (values listed in Task 2). Prefer existing keys; every reused key is named in its task.
- No em dashes in user-facing copy. Never "World Cup" in English copy (it is "World Championship").
- Sheets: inside a sheet builder pop with the sheet's own context, never the screen's, and pop BEFORE navigating (`go`/`push`) from sheet content (stage 1 rule; see `showAdaptiveSheet`).
- Never push a shell route from a top-level (full-screen) route; use `go` (Task 1 records this in the router).
- Never run `flutter install` against a physical device. Use simulators/emulators for this stage.
- Commit messages end with `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`.
- Run all tests with `flutter test` from the repo root. `test/flutter_test_config.dart` loads the real fonts automatically. Golden baselines are created ONLY in the "create the baseline" step of a task (`flutter test --update-goldens <file>`), before the screen is changed, and are committed in that step. Never update a golden to make a later step pass; a changed phone golden is a phone regression.

## Spec adjustments made for stage 2

Recorded in the spec by Task 14.

- **Inbox filters** are All, Board, Competitions, Squad. The spec named Press and Scouting, but neither is an inbox category (press conferences and the scouting dossier are not messages).
- **Tactics tabs** are Formation (with the instructions under it), Roles and set pieces, Opposition. Roles and set pieces stay one tab, as on the phone, where they were merged on purpose.
- **Opposition (scouting dossier)** reuses the match preview's briefing (head to head and dossier). Its danger men are the three best-rated players in the opponent's pool, read by a new read-only `opponentKeyMenProvider`; reading `matchPreviewProvider` from Tactics would keep a pre-simulated result alive across lineup changes.
- **Match centre** is the manager's live shape on the tactics pitch (read only; a tap opens the tactics editor) with the momentum bar under it. There is no 2D ball simulation and no "shouts" mechanic, so the bottom bar is the existing `MatchControlBar` (Tactics, play/pause, speed, skip when enabled). Live ratings sit in the right column's Line-ups tab.
- **"Subs open alongside the pitch"**: the in-match tactics editor gets a landscape layout, pitch left and the substitution lists and instructions right, so a substitution never scrolls the pitch away.
- **Hub** has no in-body Continue on tablet: the top bar's Continue is the one action and now carries the tour's `hubAction` key. The Next-match panel links to Call-ups and Tactics, not to the match preview (the preview's Kick off would let a match start out of order).
- **Full-screen routes without a tablet layout yet** (draws, kickoff, rollover, home, saves, settings) render their phone layout centred at 600 on tablets instead of stretched across the landscape screen, until their own stage.
- **Phone guards** are golden files of the phone layout on a seeded save at 390 x 844.

## Review Focus

1. **Opponent shown before the draw is watched.** Two new places show the next opponent: the hub's Next-match panel (by name, where the phone shows only codes) and the Tactics Opposition tab. Both must show "Draw to come" (`topBarDrawPending`) and nothing of the opponent while `HubData.nextDrawWatched` is false. Pinned in Task 5 (hub) and Task 12 (tactics).
2. **Phone path drift.** The tablet work touches the phone screens' files (early returns, extracted builder methods). Any change to what a phone draws is a regression. Pinned by a phone guard golden per screen, created before the screen is touched; the hub's (Task 5) is the reference pattern.
3. **IntrinsicHeight crash in `DashboardGrid`.** Rows are measured with `IntrinsicHeight`, which asserts on any tile containing a `ListView`, a `LayoutBuilder` or a widget built on one (`WholeText`, and therefore `YPostTile`). Pinned in Task 1 (documented rule plus the fixed-height escape hatch) and Task 5 (the real hub dashboard builds without an exception).
4. **A window crossing 600 mid-edit remounts the screen.** In iPad split view the shell steps aside and the routed screen is rebuilt under a different parent, so its `State` is new. Anything the manager was doing must survive through the screen's existing persistence. Pinned in Task 6: a call-up made on the tablet layout is still there after the window shrinks to phone size (via the call-up draft).
5. **Tablet layout leaking onto the phone path.** Full-screen routes are not inside `TabletShellScope`, and the default test window is tablet sized. The match screen and the in-match editor must stay on their phone layout unless the startup form factor is tablet. Pinned in Task 8 (phone form factor at 800 x 600 still draws `MatchDetailTabs`) and Task 9 (`tabletLayout: false` keeps the editor's tabbed phone body).

---

## File structure

**Create**
- `lib/shared/tablet/detail_pane.dart`: `DetailTarget`, `PlayerTarget`, `DetailPaneController`, `DetailPaneScope`.
- `lib/features/shell/detail_pane_host.dart`: `DetailPaneHost`, `openPlayer`.
- `lib/features/hub/hub_tablet_layout.dart` (part of `hub_screen.dart`): `_HubTabletLayout` and its panels.
- `lib/features/tactics/call_up_tablet_layout.dart` (part of `call_up_screen.dart`): `_CallUpTabletLayout`.
- `lib/features/match/match_preview_tablet_layout.dart` (part of `match_preview_screen.dart`): `_MatchPreviewTabletLayout`.
- `lib/features/match/match_tablet_layout.dart` (part of `match_screen.dart`): `_MatchTabletLayout`.
- `lib/features/results/round_results_tablet_layout.dart` (part of `round_results_screen.dart`): `_RoundResultsTabletLayout`, `_GroupResultsPanel`.
- `lib/features/messages/messages_tablet_layout.dart` (part of `messages_screen.dart`): `InboxFilter`, `inboxGroupOf`, `_MessagesTabletLayout`.
- `lib/features/tactics/tactics_tablet_layout.dart` (part of `tactics_screen.dart`): `_TacticsTabletLayout`, `_OppositionTab`.
- `lib/features/tactics/squad_tablet_layout.dart`: `SquadTabletLayout`.
- `test/helpers/seeded_save.dart`: `seedSave`, `settle`, `pumpRoute`, `kPhoneSize`, `kTabletSize`, `kAppRoot`, `enL`.
- `test/golden/phone_guard_*_test.dart` and `test/golden/goldens/*.png`: one phone guard per screen.
- Tests listed per task.

**Modify**
- `lib/core/layout/form_factor.dart`: `useTabletLayout`.
- `lib/shared/tablet/master_detail.dart`, `data_grid.dart`, `dashboard_grid.dart`, `panel.dart`, `tablet_text.dart`, `tablet.dart` (barrel).
- `lib/features/shell/tablet_shell.dart`: keyboard inset, `FullScreenPhoneFrame`, `tabletReadyPaths` (grows per task).
- `lib/features/shell/tablet_top_bar.dart`: chip, name, badge, tour key.
- `lib/features/shell/tablet_sidebar.dart`: the Squad item carries the tour's `squadTab` key (Task 13).
- `lib/core/routing/app_router.dart`: full-screen fallback frame, doc note.
- `lib/features/hub/hub_event_button.dart`: `tourTarget`.
- `lib/features/hub/hub_screen.dart`, `board_objectives_screen.dart`.
- `lib/features/player/player_detail_screen.dart`: `PlayerView`.
- `lib/features/tactics/call_up_screen.dart`, `tactics_screen.dart`, `tactics_pitch.dart` (`BenchChip`), `in_match_tactics.dart`.
- `lib/features/match/match_preview_screen.dart` (`OpponentBriefing`, `opponentKeyMenProvider`), `match_screen.dart`.
- `lib/features/results/round_results_screen.dart` (`roundResultsViewProvider`, `RoundResultsView`).
- `lib/features/messages/messages_screen.dart`.
- `lib/l10n/app_{en,cs,fr,it,pl}.arb`, generated `app_localizations*.dart`, `copy/strings.csv`.
- `docs/superpowers/specs/2026-10-09-tablet-ui-design.md` (Task 14).

---
### Task 1: Harden the kit and the shell before first use

Folds in the stage 1 findings triaged to stage 2: the MasterDetail divider is too thin to grab and drifts at its limits; the DataGrid header is a 30px target with hidden ink and no semantics; DashboardGrid crashes on scrollables without saying so; the top bar's next chip and nation name do not give way; the unread badge has no cap; `PhoneWidthFrame` passes the keyboard inset through with no test saying that is deliberate; full-screen routes draw phone layouts stretched across a landscape screen.

**Files:**
- Modify: `lib/core/layout/form_factor.dart`, `lib/shared/tablet/master_detail.dart`, `lib/shared/tablet/data_grid.dart`, `lib/shared/tablet/dashboard_grid.dart`, `lib/shared/tablet/panel.dart`, `lib/shared/tablet/tablet_text.dart`, `lib/features/shell/tablet_shell.dart`, `lib/features/shell/tablet_top_bar.dart`, `lib/core/routing/app_router.dart`
- Test: `test/widget/master_detail_test.dart`, `test/widget/data_grid_test.dart`, `test/widget/tablet_panel_grid_test.dart`, `test/widget/tablet_top_bar_test.dart`, `test/widget/tablet_shell_test.dart`, `test/widget/form_factor_window_test.dart`

**Interfaces:**
- Consumes: `FormFactor`, `formFactorProvider`, `BuildContext.isTabletWindow` (form_factor.dart); `PhoneWidthFrame`, `tabletReadyPaths`, `TabletShell` (tablet_shell.dart); `Routes.fullScreen` (app_router.dart).
- Produces:
  - `bool useTabletLayout(BuildContext context, WidgetRef ref)`
  - `MasterDetail.dividerWidth == 28` (static const), unchanged constructor.
  - `DataGrid.headerHeight == 36`, `DataGrid.headerKey`.
  - `Panel({required String title, required Widget child, Widget? action, EdgeInsetsGeometry padding, bool expand = false})`, `PanelBox({required Widget child})`, `PanelLink({required String label, required VoidCallback onTap})`.
  - `TabletText.screenTitle`, `TabletText.panelLink`.
  - `String unreadBadgeLabel(int unread)` (tablet_top_bar.dart).
  - `FullScreenPhoneFrame({required Widget child})` (tablet_shell.dart).

- [ ] **Step 1: Write the failing tests**

Append to `test/widget/master_detail_test.dart`, inside `main()`:

```dart
  testWidgets('the divider is wide enough for a finger', (tester) async {
    await pump(tester);
    expect(
      tester.getSize(find.byKey(MasterDetail.dividerKey)).width,
      greaterThanOrEqualTo(24),
    );
  });

  testWidgets('the divider follows the finger back from past a limit', (
    tester,
  ) async {
    await pump(tester);
    final gesture = await tester.startGesture(
      tester.getCenter(find.byKey(MasterDetail.dividerKey)),
    );
    // 400 -> past the 600 limit (finger at 700), then back to 600.
    await gesture.moveBy(const Offset(300, 0));
    await tester.pump();
    await gesture.moveBy(const Offset(-100, 0));
    await tester.pump();
    await gesture.up();
    await tester.pump();
    expect(tester.getSize(find.byKey(const Key('master'))).width, 600);
  });

  testWidgets('a zero-width parent draws nothing and does not throw', (
    tester,
  ) async {
    await tester.pumpApp(
      const Scaffold(
        body: SizedBox(
          width: 0,
          child: MasterDetail(master: SizedBox.expand()),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });
```

Append to `test/widget/data_grid_test.dart`, inside `main()`:

```dart
  testWidgets('the header is a full-height, labelled tap target', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await _pump(tester);
    expect(
      tester.getSize(find.byKey(DataGrid.headerKey)).height,
      DataGrid.headerHeight,
    );
    expect(
      tester.getSemantics(find.text('OVR')),
      containsSemantics(isButton: true, isSelected: false),
    );
    await tester.tap(find.text('OVR'));
    await tester.pump();
    expect(
      tester.getSemantics(find.text('OVR')),
      containsSemantics(isButton: true, isSelected: true),
    );
    semantics.dispose();
  });

  testWidgets('the selected row is highlighted', (tester) async {
    await _pump(tester, selected: _rows[1]);
    final material = tester.widget<Material>(
      find
          .ancestor(of: find.text('Kubišta'), matching: find.byType(Material))
          .first,
    );
    expect(material.color, AppColors.surfaceContainerHighest);
  });
```

Add `import 'package:fnm/core/theme/app_colors.dart';` to that file.

Append to `test/widget/tablet_panel_grid_test.dart`, inside `main()`:

```dart
  testWidgets('a tile may hold a list if it gives the list a fixed height', (
    tester,
  ) async {
    await tester.pumpApp(
      Scaffold(
        body: SingleChildScrollView(
          child: DashboardGrid(
            tiles: [
              DashboardTile(
                span: 6,
                child: SizedBox(
                  height: 120,
                  child: ListView(
                    children: [for (var i = 0; i < 20; i++) Text('row $i')],
                  ),
                ),
              ),
              const DashboardTile(span: 6, child: SizedBox(height: 40)),
            ],
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.text('row 0'), findsOneWidget);
  });

  testWidgets('an expanding panel gives its body all the height below the '
      'header', (tester) async {
    await tester.pumpApp(
      const Scaffold(
        body: SizedBox(
          height: 300,
          child: Panel(
            title: 'Pool',
            expand: true,
            padding: EdgeInsets.zero,
            child: SizedBox.expand(key: Key('body')),
          ),
        ),
      ),
    );
    // 300 minus the 34px header strip (the border is painted, not padded).
    expect(tester.getSize(find.byKey(const Key('body'))).height, 266);
  });

  testWidgets('a panel link is tappable', (tester) async {
    var taps = 0;
    await tester.pumpApp(
      Scaffold(
        body: Panel(
          title: 'Inbox',
          action: PanelLink(label: 'View all', onTap: () => taps++),
          child: const Text('body'),
        ),
      ),
    );
    await tester.tap(find.text('View all'));
    expect(taps, 1);
  });
```

Append to `test/widget/tablet_top_bar_test.dart`, inside `main()` (the file's `_hub` and `_pump` helpers already exist; `_pump` takes `unread`):

```dart
  test('the unread badge caps at 99+', () {
    expect(unreadBadgeLabel(7), '7');
    expect(unreadBadgeLabel(99), '99');
    expect(unreadBadgeLabel(100), '99+');
  });

  testWidgets('a long name and a narrow bar give way instead of overflowing', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(760, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final hub = _hub(drawWatched: true);
    final longName = HubData(
      career: hub.career,
      group: null,
      next: hub.next,
      fixtures: const [],
      nations: {
        1: nation(id: 1, name: 'Saint Vincent and the Grenadines'),
        2: nation(id: 2, name: 'Bosnia and Herzegovina'),
      },
      squadSize: 23,
      squadRating: 75,
      championNationId: null,
      hasFinals: false,
    );
    await tester.pumpApp(
      const Scaffold(body: TabletTopBar(careerId: 1)),
      overrides: [
        hubDataProvider(1).overrideWith((ref) async => longName),
        unreadMessagesProvider(1).overrideWith((ref) async => 150),
        nextEventProvider(1).overrideWith(
          (ref) async => const HubEvent(
            kind: HubEventKind.advance,
            label: 'Continue',
            icon: Icons.play_arrow_rounded,
          ),
        ),
      ],
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.text('99+'), findsOneWidget);
    expect(find.textContaining('Bosnia', findRichText: true), findsOneWidget);
  });
```

Append to `test/widget/tablet_shell_test.dart`, inside `main()`:

```dart
  testWidgets('a phone-width screen still sees the keyboard, so its '
      'Scaffold lifts above it', (tester) async {
    tester.view.physicalSize = const Size(1194, 834);
    tester.view.devicePixelRatio = 1;
    // With the keyboard up the system reports no bottom padding, only the
    // inset, so the shell's SafeArea takes nothing and the frame must pass
    // the whole inset on.
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    addTearDown(tester.view.reset);
    late double seen;
    await tester.pumpApp(
      TabletShell(
        location: Uri.parse('/youth?careerId=1'),
        child: Builder(
          builder: (context) {
            seen = MediaQuery.viewInsetsOf(context).bottom;
            return const SizedBox.expand();
          },
        ),
      ),
      overrides: overrides,
    );
    await tester.pump();
    expect(find.byType(PhoneWidthFrame), findsOneWidget);
    expect(seen, 300);
  });

  testWidgets('a full-screen phone layout is centred at 600 on a tablet', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1194, 834);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpApp(
      const FullScreenPhoneFrame(child: SizedBox.expand(key: Key('page'))),
    );
    expect(tester.getSize(find.byKey(const Key('page'))).width, 600);
  });

  testWidgets('and is left alone on a phone', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpApp(
      const FullScreenPhoneFrame(child: SizedBox.expand(key: Key('page'))),
    );
    expect(tester.getSize(find.byKey(const Key('page'))).width, 390);
  });
```

Append to `test/widget/form_factor_window_test.dart`, inside `main()` (add imports `package:flutter_riverpod/flutter_riverpod.dart`):

```dart
  Future<bool> probeLayout(
    WidgetTester tester,
    Size size,
    FormFactor formFactor,
  ) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    late bool result;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [formFactorProvider.overrideWithValue(formFactor)],
        child: MaterialApp(
          home: Consumer(
            builder: (context, ref, _) {
              result = useTabletLayout(context, ref);
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
    return result;
  }

  testWidgets('a tablet layout needs a tablet AND a tablet-sized window', (
    tester,
  ) async {
    expect(
      await probeLayout(tester, const Size(1194, 834), FormFactor.tablet),
      isTrue,
    );
  });

  testWidgets('the default 800x600 test window on a phone build stays phone', (
    tester,
  ) async {
    expect(
      await probeLayout(tester, const Size(800, 600), FormFactor.phone),
      isFalse,
    );
  });

  testWidgets('a tablet in split view stays phone', (tester) async {
    expect(
      await probeLayout(tester, const Size(507, 834), FormFactor.tablet),
      isFalse,
    );
  });
```

- [ ] **Step 2: Run them to verify they fail**

Run: `flutter test test/widget/master_detail_test.dart test/widget/data_grid_test.dart test/widget/tablet_panel_grid_test.dart test/widget/tablet_top_bar_test.dart test/widget/tablet_shell_test.dart test/widget/form_factor_window_test.dart`
Expected: FAIL. Compile errors for `DataGrid.headerKey`, `Panel.expand`, `PanelLink`, `unreadBadgeLabel`, `FullScreenPhoneFrame`, `useTabletLayout`; the divider width is 12.

- [ ] **Step 3: `useTabletLayout`**

Append to `lib/core/layout/form_factor.dart`:

```dart
/// Whether a FULL-SCREEN route should draw its tablet layout.
///
/// In-shell screens ask `TabletShellScope.isActive` instead. A full-screen
/// route has no shell around it, and the window size alone is not enough:
/// Flutter's default test window is 800 x 600 logical, which is tablet sized,
/// and a phone build must never switch layouts because of it. So both must
/// hold: the app started as a tablet, and the window is tablet sized right
/// now (an iPad in split view gets the phone layout).
bool useTabletLayout(BuildContext context, WidgetRef ref) =>
    ref.watch(formFactorProvider) == FormFactor.tablet &&
    context.isTabletWindow;
```

- [ ] **Step 4: MasterDetail divider**

Replace `_MasterDetailState` in `lib/shared/tablet/master_detail.dart` with:

```dart
class _MasterDetailState extends State<MasterDetail> {
  late double _fraction = widget.initialFraction;

  /// Where the finger is, as a fraction, for the length of one drag. Kept
  /// unclamped so a finger that goes past a limit and comes back finds the
  /// divider under it again, rather than ahead of it by the overshoot.
  double? _dragFraction;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        // Nothing to split: a zero-width first frame, or a parent collapsing.
        if (!width.isFinite || width <= MasterDetail.dividerWidth) {
          return const SizedBox.shrink();
        }
        final masterWidth = width * _fraction;
        return Row(
          children: [
            SizedBox(width: masterWidth, child: widget.master),
            MouseRegion(
              cursor: SystemMouseCursors.resizeColumn,
              child: GestureDetector(
                key: MasterDetail.dividerKey,
                behavior: HitTestBehavior.opaque,
                dragStartBehavior: DragStartBehavior.down,
                onHorizontalDragStart: (_) => _dragFraction = _fraction,
                onHorizontalDragUpdate: (d) => setState(() {
                  final raw =
                      (_dragFraction ?? _fraction) + d.delta.dx / width;
                  _dragFraction = raw;
                  _fraction = raw.clamp(
                    widget.minFraction,
                    widget.maxFraction,
                  );
                }),
                onHorizontalDragEnd: (_) => _dragFraction = null,
                onHorizontalDragCancel: () => _dragFraction = null,
                child: SizedBox(
                  width: MasterDetail.dividerWidth,
                  child: Center(
                    child: Container(
                      width: 1,
                      color: AppColors.outlineVariant,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child:
                  widget.detail ??
                  widget.placeholder ??
                  const SizedBox.shrink(),
            ),
          ],
        );
      },
    );
  }
}
```

And in `MasterDetail` add, next to `dividerKey`:

```dart
  /// The divider's touch target. Only a 1px line is drawn in it, but a finger
  /// needs 24 to 32 points to find it.
  static const double dividerWidth = 28;
```

- [ ] **Step 5: DataGrid header**

In `lib/shared/tablet/data_grid.dart`:

Add to `DataGrid`, beside `rowHeight`:

```dart
  /// The header row: as tall as a body row, so each column title is a whole
  /// tap target rather than a strip of text.
  static const double headerHeight = 36;
  static const Key headerKey = Key('dataGrid.header');
```

Extend the class doc comment with:

```dart
/// Pass a NEW list when the rows change. The sorted order is cached against
/// the list's identity, so a list mutated in place keeps its old order.
```

Replace the header `Container(height: 30, ...)` with:

```dart
        // A Material, not a coloured Container: the header cells' InkWells
        // paint on the nearest Material, and a Container's colour hid them.
        Material(
          key: DataGrid.headerKey,
          color: AppColors.surfaceContainer,
          child: SizedBox(
            height: DataGrid.headerHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  for (final c in columns)
                    _cellBox(
                      c,
                      Semantics(
                        container: true,
                        button: c.sortKey != null,
                        selected: c.id == _sortId,
                        child: InkWell(
                          onTap: () => _tapHeader(c),
                          child: Row(
                            mainAxisAlignment: c.numeric
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                  c.label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TabletText.header.copyWith(
                                    color: c.id == _sortId
                                        ? AppColors.onSurface
                                        : null,
                                  ),
                                ),
                              ),
                              if (c.id == _sortId)
                                Icon(
                                  _ascending
                                      ? Icons.arrow_drop_up
                                      : Icons.arrow_drop_down,
                                  size: 16,
                                  color: AppColors.onSurface,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
```

- [ ] **Step 6: DashboardGrid rule, Panel variants, text styles**

In `lib/shared/tablet/dashboard_grid.dart`, extend the `DashboardGrid` doc comment:

```dart
/// Each row is sized with [IntrinsicHeight], so every tile must be able to
/// report its intrinsic height. That rules out, anywhere inside a tile, a
/// [ListView] or other scrollable, a [LayoutBuilder], and widgets built on one
/// (`WholeText`, and so `YPostTile`): they assert. A tile that needs a list
/// gives it a fixed height (`SizedBox(height: ...)`), which IntrinsicHeight
/// reads without asking the list. A screen whose content must scroll inside a
/// panel uses `Panel(expand: true)` in a Row or Column, not this grid.
```

Replace `lib/shared/tablet/panel.dart` with:

```dart
import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/shared/tablet/tablet_text.dart';

/// A titled box for tablet dashboards: tighter than `AppCard`, with a header
/// strip and an optional action on its right.
class Panel extends StatelessWidget {
  const Panel({
    required this.title,
    required this.child,
    this.action,
    this.padding = const EdgeInsets.all(12),
    this.expand = false,
    super.key,
  });

  final String title;
  final Widget? action;
  final Widget child;
  final EdgeInsetsGeometry padding;

  /// Whether the panel fills the height it is given, its body taking all of
  /// it below the header. For a body that scrolls (a list, a grid). Never
  /// inside a `DashboardGrid`, whose rows measure intrinsic heights.
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final body = Padding(padding: padding, child: child);
    return PanelBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Container(
            height: 34,
            color: AppColors.surfaceContainer,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TabletText.panelTitle,
                  ),
                ),
                ?action,
              ],
            ),
          ),
          if (expand) Expanded(child: body) else body,
        ],
      ),
    );
  }
}

/// A panel's box without its header, for a pane whose content brings its own
/// (a tab bar, a detail view).
class PanelBox extends StatelessWidget {
  const PanelBox({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: AppColors.surfaceContainerLow,
      borderRadius: AppRadii.baseAll,
      border: Border.all(color: AppColors.outlineVariant),
    ),
    child: ClipRRect(borderRadius: AppRadii.baseAll, child: child),
  );
}

/// The small link on the right of a [Panel]'s header ("View all").
class PanelLink extends StatelessWidget {
  const PanelLink({required this.label, required this.onTap, super.key});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: AppRadii.smAll,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      child: Text(label, style: TabletText.panelLink),
    ),
  );
}
```

Add to `TabletText` in `lib/shared/tablet/tablet_text.dart`:

```dart
  /// A tablet screen's own heading, top left of its content ("Squad").
  static const screenTitle = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.onSurface,
  );
  static const panelLink = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );
```

- [ ] **Step 7: Top bar**

In `lib/features/shell/tablet_top_bar.dart`:

Add the top-level function:

```dart
/// The inbox badge's text: the count, capped so a long-ignored inbox does not
/// grow a pill wider than the icon it sits on.
String unreadBadgeLabel(int unread) => unread > 99 ? '99+' : '$unread';
```

Replace the `Row`'s children in `TabletTopBar.build` with:

```dart
        children: [
          if (nation != null) ...[
            FlagDisc(nation.code, size: 28),
            const SizedBox(width: AppSpacing.sm),
            // Capped, and ellipsised: "Saint Vincent and the Grenadines" must
            // not push the date and the next fixture off the bar.
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 180),
              child: Text(
                nation.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TabletText.barTitle,
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
          ],
          if (hub != null)
            Text(
              AppDate.dayMonthYear(context, hub.career.inGameDate),
              style: TabletText.barMeta,
            ),
          // The chip takes ALL the free space and sits at its left. Sharing
          // it with a Spacer gave it half, and it ellipsised long before the
          // bar was full.
          if (hub != null && next != null) ...[
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: _NextChip(hub: hub, next: next),
              ),
            ),
          ] else
            const Spacer(),
          IconButton(
            tooltip: l.hubMessages,
            onPressed: () =>
                context.go('${Routes.messages}?careerId=$careerId'),
            icon: Badge(
              isLabelVisible: unread > 0,
              label: Text(unreadBadgeLabel(unread)),
              child: const Icon(Icons.mail_outline, color: AppColors.primary),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          SizedBox(
            width: 220,
            child: HubEventButton(careerId: careerId, compact: true),
          ),
        ],
```

In `_NextChip.build`, use the compact stage label:

```dart
            TextSpan(
              text: '  ${MatchStage.labelCompact(l, next)}, '
                  '${AppDate.dayMonth(context, next.date)}',
              style: TabletText.barMeta,
            ),
```

- [ ] **Step 8: Document the frame's keyboard inset; add the full-screen frame**

The keyboard test of Step 1 already passes: `PhoneWidthFrame` keeps `viewInsets`, which is what lets the framed screen's `Scaffold` lift its content above the keyboard (on iOS and Android the system reports bottom padding 0 while the keyboard is up, so the shell's `SafeArea` takes nothing from it). It only lacked a test and a reason. In `lib/features/shell/tablet_shell.dart`, extend the `PhoneWidthFrame` doc comment:

```dart
///
/// Only the size and the padding are replaced. [MediaQueryData.viewInsets]
/// is passed through on purpose: the framed screen's Scaffold reads it to
/// lift its content above the keyboard.
```

Update the `tabletReadyPaths` doc comment:

```dart
/// Route paths whose screens have a tablet layout and may use the whole
/// content area (in the shell) or the whole screen (full-screen routes).
/// Everything else is drawn at phone width: [PhoneWidthFrame] in the shell,
/// [FullScreenPhoneFrame] outside it. Each stage adds the screens it converts.
```

Append to the file:

```dart
/// A full-screen route with no tablet layout yet, on a tablet: its phone
/// layout centred at [PhoneWidthFrame.maxWidth] on the app's background,
/// rather than stretched across a landscape screen. On a phone, or a tablet
/// window narrower than a tablet, the child is returned as it is.
class FullScreenPhoneFrame extends StatelessWidget {
  const FullScreenPhoneFrame({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!context.isTabletWindow) return child;
    return Material(
      color: AppColors.surface,
      child: SafeArea(child: PhoneWidthFrame(child: child)),
    );
  }
}
```

- [ ] **Step 9: Router**

In `lib/core/routing/app_router.dart`, replace `_tabletRoutes` with:

```dart
/// The same routes, with every in-save screen inside the tablet shell.
///
/// Full-screen routes stay top level. One whose screen has no tablet layout
/// yet is drawn through [FullScreenPhoneFrame].
///
/// Never PUSH a shell route from a top-level route (a match, a draw): go_router
/// would build a second shell, and its navigator key with it, on top of the
/// first. Leave a full-screen route with `go`.
List<RouteBase> _tabletRoutes(List<GoRoute> routes) => [
  ShellRoute(
    builder: (context, state, child) =>
        TabletShell(location: state.uri, child: child),
    routes: [
      for (final r in routes)
        if (!Routes.fullScreen.contains(r.path)) r,
    ],
  ),
  for (final r in routes)
    if (Routes.fullScreen.contains(r.path))
      tabletReadyPaths.contains(r.path) ? r : _phoneFramed(r),
];

/// [route] with its screen drawn through [FullScreenPhoneFrame].
GoRoute _phoneFramed(GoRoute route) => GoRoute(
  path: route.path,
  builder: (context, state) =>
      FullScreenPhoneFrame(child: route.builder!(context, state)),
);
```

- [ ] **Step 10: Run the tests, expect PASS**

Run: `flutter test test/widget/master_detail_test.dart test/widget/data_grid_test.dart test/widget/tablet_panel_grid_test.dart test/widget/tablet_top_bar_test.dart test/widget/tablet_shell_test.dart test/widget/form_factor_window_test.dart test/unit/core/routing/tablet_router_test.dart`
Expected: PASS, including the three original MasterDetail drag assertions (400 to 500, clamp at 600, clamp at 250).

- [ ] **Step 11: Analyze and run the whole suite**

Run: `flutter analyze && flutter test`
Expected: no issues; all tests pass.

- [ ] **Step 12: Commit**

```bash
git add lib/core/layout/form_factor.dart lib/shared/tablet/master_detail.dart lib/shared/tablet/data_grid.dart lib/shared/tablet/dashboard_grid.dart lib/shared/tablet/panel.dart lib/shared/tablet/tablet_text.dart lib/features/shell/tablet_shell.dart lib/features/shell/tablet_top_bar.dart lib/core/routing/app_router.dart test/widget/master_detail_test.dart test/widget/data_grid_test.dart test/widget/tablet_panel_grid_test.dart test/widget/tablet_top_bar_test.dart test/widget/tablet_shell_test.dart test/widget/form_factor_window_test.dart
git commit -m "fix(tablet): harden kit and shell before stage 2 (divider, header, insets, frames)

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 2: Stage 2 copy in all 5 languages

**Files:**
- Modify: `lib/l10n/app_en.arb`, `app_cs.arb`, `app_fr.arb`, `app_it.arb`, `app_pl.arb`
- Regenerate: `lib/l10n/app_localizations*.dart`, `copy/strings.csv`
- Test: existing `test/unit/l10n/*` guards

**Interfaces:**
- Produces these `AppLocalizations` getters: `paneFullProfile`, `panePickPlayer`, `inboxPickMessage`, `inboxFilterAll`, `panelViewAll`, `gridViewOverview`, `gridColCondition`, `gridColStatus`.
- Reused existing getters (do not add): `hubNextMatch`, `hubVs`, `hubNoMoreFixtures`, `hubGroupsToBeDrawn`, `hubSquadStatus`, `hubAvgRating`, `hubMorale`, `hubWorldChampions`, `hubViewBracket`, `hubSaveNotFound`, `topBarDrawPending`, `sideInbox`, `sideBoard`, `sideSquad`, `sideTactics`, `sideCallUps`, `sideCareer`, `sideGroupCompetitions`, `sideGroupFederation`, `navY`, `yEmpty`, `boardObjectivesConfidence`, `playerStatForm`, `playerTitle`, `playerAttributes`, `playerAttrPhysical`, `playerAttrTechnical`, `playerAttrStamina`, `playerAge`, `playerClub`, `teamOverall`, `squadDevPosition`, `squadSortName`, `squadSortCaps`, `squadSortGoals`, `squadStatPool`, `squadLineAll`, `squadShowingOf`, `squadLegendTitle`, `messagesNoMessagesYet`, `matchDossierTitle`, `matchDossierNoGames`, `matchMomentum`, `matchYourXi`, `matchTabTimeline`, `matchTabStats`, `matchTabLineups`, `matchTactics`, `matchKickOff`, `matchPreviewTitle`, `tacticsFormation`, `tacticsTabRolesSetPieces`, `tacticsTabBench`, `tacticsTabLineupSubs`, `tacticsTabTactics`, `tacticsTapOrDrag`, `tacticsTooltipPresets`, `tacticsNoSubs`, `tacticsSquad`, `federationFreeToSpend`, `federationLevelBadge`, `resultsRoundResults`, `resultsContinue`, `resultsGroup`, `resultsMatchday`.

- [ ] **Step 1: Add the English strings with descriptions**

Append before the closing `}` of `lib/l10n/app_en.arb` (add a comma after the previous last entry, `"@topBarDrawPending": {...}`):

```json
  "paneFullProfile": "Full profile",
  "@paneFullProfile": { "description": "Tablet detail pane: link that opens the player's full page." },
  "panePickPlayer": "Pick a player to see his card here",
  "@panePickPlayer": { "description": "Tablet detail pane: shown while no player is selected." },
  "inboxPickMessage": "Pick a message to read it here",
  "@inboxPickMessage": { "description": "Tablet inbox: shown in the reading pane while no message is open." },
  "inboxFilterAll": "All",
  "@inboxFilterAll": { "description": "Tablet inbox filter chip: every message." },
  "panelViewAll": "View all",
  "@panelViewAll": { "description": "Tablet dashboard panel header link to the panel's full screen." },
  "gridViewOverview": "Overview",
  "@gridViewOverview": { "description": "Tablet squad table: the default set of columns." },
  "gridColCondition": "Condition",
  "@gridColCondition": { "description": "Tablet squad table column: how fresh or tired a player is." },
  "gridColStatus": "Status",
  "@gridColStatus": { "description": "Tablet squad table column: injured or suspended, empty when available." }
```

- [ ] **Step 2: Add the translations**

Append the same keys (values only, no `@` entries) to each locale file:

| key | cs | fr | it | pl |
|---|---|---|---|---|
| paneFullProfile | Celý profil | Profil complet | Profilo completo | Pełny profil |
| panePickPlayer | Vyberte hráče a jeho karta se ukáže tady | Choisissez un joueur pour voir sa fiche ici | Scegli un giocatore per vedere qui la sua scheda | Wybierz zawodnika, aby zobaczyć tu jego kartę |
| inboxPickMessage | Vyberte zprávu a přečtěte si ji tady | Choisissez un message pour le lire ici | Scegli un messaggio per leggerlo qui | Wybierz wiadomość, aby ją tu przeczytać |
| inboxFilterAll | Vše | Tous | Tutti | Wszystkie |
| panelViewAll | Zobrazit vše | Tout voir | Vedi tutto | Zobacz wszystko |
| gridViewOverview | Přehled | Vue d’ensemble | Panoramica | Przegląd |
| gridColCondition | Kondice | Condition | Condizione | Kondycja |
| gridColStatus | Stav | Statut | Stato | Status |

For the de/es files when they merge (not on this branch): paneFullProfile `Vollständiges Profil` / `Perfil completo`; panePickPlayer `Spieler wählen, um seine Karte hier zu sehen` / `Elige un jugador para ver aquí su ficha`; inboxPickMessage `Nachricht wählen, um sie hier zu lesen` / `Elige un mensaje para leerlo aquí`; inboxFilterAll `Alle` / `Todos`; panelViewAll `Alle anzeigen` / `Ver todo`; gridViewOverview `Übersicht` / `Resumen`; gridColCondition `Verfassung` / `Condición`; gridColStatus `Status` / `Estado`.

- [ ] **Step 3: Regenerate typed strings and the copy file**

```bash
flutter gen-l10n
dart run tool/export_copy.dart
```

Expected: no "untranslated" entries for the new keys in `lib/l10n/untranslated.txt`; `copy/strings.csv` gains 8 rows.

- [ ] **Step 4: Run the l10n guards**

Run: `flutter test test/unit/l10n`
Expected: PASS (round trip, French colon spacing, Czech-only joke, message keys).

- [ ] **Step 5: Commit**

```bash
git add lib/l10n copy/strings.csv
git commit -m "feat(tablet): stage 2 copy (detail pane, inbox, panels, squad table)

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---
### Task 3: Seeded-save test harness and the tablet route sweep

Every later task tests a real screen on a real save, at phone size (the guard) and at tablet size. This task builds that harness once and uses it for the sweep the spec asks for: every in-shell route pumped on a seeded save at 1194 x 834 with no layout errors.

**Files:**
- Create: `test/helpers/seeded_save.dart`
- Test: `test/widget/tablet_route_sweep_test.dart`

**Interfaces:**
- Consumes: `appDatabaseProvider`, `seedLoaderProvider`, `competitionRepositoryProvider`, `playerRepositoryProvider` (data_providers.dart); `seedSourceProvider`, `InMemorySeedSource` (seed_source.dart); `premiumUnlockedProvider` (entitlement.dart); `matchAttemptSaltProvider` (match_providers.dart); `careerServiceProvider`, `CareerService.agingYears` (career_providers.dart); `messageInboxProvider`, `unreadMessagesProvider` (message_providers.dart); `routerProvider`, `Routes` (app_router.dart); `formFactorProvider`, `FormFactor`.
- Produces (test only):
  - `const Size kPhoneSize = Size(390, 844); const Size kTabletSize = Size(1194, 834); const Key kAppRoot`
  - `AppLocalizations get enL`
  - `class SeededSave { ProviderContainer container; Career career; int get careerId; int get nationId; List<Nation> get nations; }`
  - `Future<SeededSave> seedSave(WidgetTester tester, {FormFactor formFactor = FormFactor.phone, List<Override> overrides = const []})`
  - `Future<void> settle(WidgetTester tester, {int rounds = 30})`
  - `Future<void> pumpRoute(WidgetTester tester, SeededSave save, String location, {Size size = kPhoneSize})`
  - `Future<void> expectAppGolden(String file)`

- [ ] **Step 1: Write the harness**

`test/helpers/seeded_save.dart`:

```dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/messages/message_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'test_database.dart';

/// An iPhone 14 in portrait, the size every phone guard is drawn at.
const Size kPhoneSize = Size(390, 844);

/// An 11in iPad in landscape, the size the mockups were drawn at.
const Size kTabletSize = Size(1194, 834);

/// Wraps the whole app, so a golden captures exactly what the screen shows.
const Key kAppRoot = Key('test.appRoot');

/// English strings, for finders.
AppLocalizations get enL => lookupAppLocalizations(const Locale('en'));

final List<Nation> _nations =
    (jsonDecode(File('assets/data/nations.json').readAsStringSync())
            as List<dynamic>)
        .map((e) => Nation.fromJson(e as Map<String, Object?>))
        .toList();

final List<Player> _players =
    (jsonDecode(File('assets/data/players.json').readAsStringSync())
            as List<dynamic>)
        .map((e) => Player.fromJson(e as Map<String, Object?>))
        .toList();

/// A brand-new career on the real world data, in its own in-memory database.
class SeededSave {
  SeededSave(this.container, this.career);

  final ProviderContainer container;
  final Career career;

  int get careerId => career.id;
  int get nationId => career.nationId;
  List<Nation> get nations => _nations;
}

/// Seeds the real nations and players, starts a career with the strongest
/// European nation (which opens on a drawn qualifying campaign, so there is a
/// draw to be watched), and reads the welcome news so it does not pop over
/// the hub. Always the same save: the seed is fixed.
///
/// [formFactor] decides the router's shape, exactly as `main.dart` does.
Future<SeededSave> seedSave(
  WidgetTester tester, {
  FormFactor formFactor = FormFactor.phone,
  List<Override> overrides = const [],
}) async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final db = createTestDatabase();
  final container = ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
      premiumUnlockedProvider.overrideWith((ref) => true),
      matchAttemptSaltProvider.overrideWithValue(() => 0),
      seedSourceProvider.overrideWithValue(
        InMemorySeedSource(nationList: _nations, playerList: _players),
      ),
      formFactorProvider.overrideWithValue(formFactor),
      ...overrides,
    ],
  );
  addTearDown(db.close);
  addTearDown(container.dispose);

  late Career career;
  await tester.runAsync(() async {
    await container.read(seedLoaderProvider).ensureSeeded();
    final strongest = _nations
        .where((n) => n.confederation == Confederation.europe)
        .reduce((a, b) => a.ranking <= b.ranking ? a : b);
    career = (await container
            .read(careerServiceProvider)
            .create(
              nationId: strongest.id,
              managerName: 'M',
              rngSeed: 20260922,
            ))
        .valueOrNull!;
    await container.read(messageInboxProvider(career.id).future);
    await container
        .read(competitionRepositoryProvider)
        .markMessagesRead(career.id);
  });
  container
    ..invalidate(messageInboxProvider(career.id))
    ..invalidate(unreadMessagesProvider(career.id));
  return SeededSave(container, career);
}

/// Lets the database work and the frames catch up.
///
/// A FIXED number of rounds, never "until the spinners stop": a golden must
/// capture the same frame on every run, and a nested provider that resolved
/// one round later would otherwise change the picture. The final pump runs
/// out route transitions.
Future<void> settle(WidgetTester tester, {int rounds = 30}) async {
  for (var i = 0; i < rounds; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 30)),
    );
    await tester.pump();
  }
  await tester.pump(const Duration(milliseconds: 500));
}

/// Opens [location] in the real app router at [size] and settles.
///
/// The router comes from [routerProvider], so the shell is there exactly when
/// the save was seeded with [FormFactor.tablet].
Future<void> pumpRoute(
  WidgetTester tester,
  SeededSave save,
  String location, {
  Size size = kPhoneSize,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final router = save.container.read(routerProvider)..go(location);
  await tester.pumpWidget(
    RepaintBoundary(
      key: kAppRoot,
      child: UncontrolledProviderScope(
        container: save.container,
        child: MaterialApp.router(
          theme: AppTheme.theme,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    ),
  );
  await settle(tester);
}

/// Compares the whole app against [file] (relative to the calling test).
Future<void> expectAppGolden(String file) =>
    expectLater(find.byKey(kAppRoot), matchesGoldenFile(file));
```

- [ ] **Step 2: Write the sweep test**

`test/widget/tablet_route_sweep_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:go_router/go_router.dart';

import '../helpers/seeded_save.dart';

/// Every screen inside the tablet shell, on a real save, at iPad size: none
/// may report a layout error. Screens without a tablet layout yet are drawn
/// at phone width (PhoneWidthFrame); this proves that holds for every one of
/// them, and keeps holding as later tasks convert them.
void main() {
  testWidgets('every shell route lays out on a tablet', (tester) async {
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

    final locations = [
      for (final e in extra.entries) '${e.key}?careerId=$id${e.value}',
      // Squad is the tactics screen on its fourth tab.
      '${Routes.tactics}?careerId=$id&tab=3',
    ];

    await pumpRoute(tester, save, locations.first, size: kTabletSize);
    final router = save.container.read(routerProvider);
    for (final location in locations) {
      router.go(location);
      await settle(tester);
      expect(tester.takeException(), isNull, reason: location);
    }

    // Unmount, so no screen's timers outlive the test.
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });
}
```

- [ ] **Step 3: Run it**

Run: `flutter test test/widget/tablet_route_sweep_test.dart`
Expected: PASS. Every screen is still a phone layout inside `PhoneWidthFrame` at 600 wide, which phones up to 600 already fit. If a route fails, the reason names it: that is a real defect at a 600-wide, 777-tall content area. Fix it in that screen without changing what a phone draws (an overflow at 600 x 777 is reachable on a large phone too), and record the fix in the task report. Do not remove the route from the sweep.

- [ ] **Step 4: Commit**

```bash
git add test/helpers/seeded_save.dart test/widget/tablet_route_sweep_test.dart
git commit -m "test(tablet): seeded-save harness and the tablet route sweep

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 4: `PlayerView` and `DetailPaneHost`

The player page's body becomes `PlayerView`, which both the full-screen route and a right-hand detail pane render. `DetailPaneHost` maps what is selected to its view; `openPlayer` puts a player in the nearest pane, or routes to his page when there is none.

**Files:**
- Create: `lib/shared/tablet/detail_pane.dart`, `lib/features/shell/detail_pane_host.dart`
- Modify: `lib/features/player/player_detail_screen.dart`, `lib/shared/tablet/tablet.dart`
- Test: `test/golden/phone_guard_player_test.dart`, `test/widget/player_view_test.dart`, `test/widget/detail_pane_host_test.dart`

**Interfaces:**
- Consumes: `_playerDetailProvider` (player_detail_screen.dart, private); `Routes.player`; `MasterDetailPlaceholder`; `TabletText.panelTitle`.
- Produces:
  - `sealed class DetailTarget`; `final class PlayerTarget extends DetailTarget { const PlayerTarget(int playerId); final int playerId; }` (value equality)
  - `class DetailPaneController extends ValueNotifier<DetailTarget?> { void show(DetailTarget t); void clear(); }`
  - `class DetailPaneScope extends InheritedNotifier<DetailPaneController> { DetailPaneScope({required DetailPaneController controller, required Widget child}); static DetailPaneController? maybeOf(BuildContext); }`
  - `class PlayerView extends ConsumerWidget { const PlayerView({required int careerId, required int playerId, EdgeInsetsGeometry padding}); }`
  - `class DetailPaneHost extends StatelessWidget { const DetailPaneHost({required int careerId, required DetailTarget? target, String? placeholder}); static const Key fullProfileKey; }`
  - `void openPlayer(BuildContext context, {required int careerId, required int playerId})`

- [ ] **Step 1: Pin the phone player page**

`test/golden/phone_guard_player_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/player/player_detail_screen.dart';

import '../helpers/seeded_save.dart';

/// The phone player page, pinned before its body moves into PlayerView.
void main() {
  testWidgets('phone player page', (tester) async {
    final save = await seedSave(tester);
    late int playerId;
    late String name;
    await tester.runAsync(() async {
      final pool = await save.container
          .read(playerRepositoryProvider)
          .byNation(
            save.nationId,
            agingYears: CareerService.agingYears(save.career),
            saveSeed: save.career.rngSeed,
          );
      playerId = pool.first.id;
      name = pool.first.name;
    });
    await pumpRoute(
      tester,
      save,
      '${Routes.player}?careerId=${save.careerId}&playerId=$playerId',
    );
    expect(find.byType(PlayerDetailScreen), findsOneWidget);
    expect(find.text(name), findsOneWidget);
    await expectAppGolden('goldens/player_phone.png');
  });
}
```

- [ ] **Step 2: Create the baseline, then confirm it holds**

```bash
flutter test --update-goldens test/golden/phone_guard_player_test.dart
flutter test test/golden/phone_guard_player_test.dart
```

Expected: the first writes `test/golden/goldens/player_phone.png`; the second PASSES. Open the PNG and check it shows the player card (not a spinner).

- [ ] **Step 3: Commit the guard**

```bash
git add test/golden/phone_guard_player_test.dart test/golden/goldens/player_phone.png
git commit -m "test(tablet): pin the phone player page

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

- [ ] **Step 4: Write the failing tests**

`test/widget/player_view_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/player/player_detail_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/seeded_save.dart';

/// PlayerView is the player page's body, on its own: what both the route and
/// a tablet detail pane draw. Tested once here, at the pane's width.
void main() {
  testWidgets('a player card fits a 320-wide pane', (tester) async {
    final save = await seedSave(tester);
    late int playerId;
    late String name;
    await tester.runAsync(() async {
      final pool = await save.container
          .read(playerRepositoryProvider)
          .byNation(
            save.nationId,
            agingYears: CareerService.agingYears(save.career),
            saveSeed: save.career.rngSeed,
          );
      playerId = pool.first.id;
      name = pool.first.name;
    });
    tester.view.physicalSize = kTabletSize;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: save.container,
        child: MaterialApp(
          theme: AppTheme.theme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 320,
                height: 760,
                child: PlayerView(careerId: save.careerId, playerId: playerId),
              ),
            ),
          ),
        ),
      ),
    );
    await settle(tester);
    expect(tester.takeException(), isNull);
    expect(find.text(name), findsOneWidget);
    expect(find.text(enL.playerAttrPhysical), findsOneWidget);
    expect(find.byType(AppBar), findsNothing, reason: 'the view has no chrome');
  });
}
```

`test/widget/detail_pane_host_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/player/player_detail_screen.dart';
import 'package:fnm/features/shell/detail_pane_host.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/detail_pane.dart';
import 'package:go_router/go_router.dart';

import '../helpers/pump_app.dart';
import '../helpers/seeded_save.dart';

void main() {
  testWidgets('nothing picked: the placeholder', (tester) async {
    await tester.pumpApp(
      const Scaffold(body: DetailPaneHost(careerId: 1, target: null)),
    );
    expect(find.text(enL.panePickPlayer), findsOneWidget);
  });

  testWidgets('a player: his card, and a way to his full page', (
    tester,
  ) async {
    final save = await seedSave(tester);
    late int playerId;
    late String name;
    await tester.runAsync(() async {
      final pool = await save.container
          .read(playerRepositoryProvider)
          .byNation(
            save.nationId,
            agingYears: CareerService.agingYears(save.career),
            saveSeed: save.career.rngSeed,
          );
      playerId = pool.first.id;
      name = pool.first.name;
    });
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => Scaffold(
            body: SizedBox(
              width: 340,
              child: DetailPaneHost(
                careerId: save.careerId,
                target: PlayerTarget(playerId),
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/player',
          builder: (_, state) =>
              Text('player page ${state.uri.queryParameters['playerId']}'),
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
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await settle(tester);
    expect(find.byType(PlayerView), findsOneWidget);
    expect(find.text(name), findsOneWidget);
    expect(find.text(enL.playerTitle.toUpperCase()), findsOneWidget);

    await tester.tap(find.byKey(DetailPaneHost.fullProfileKey));
    await tester.pumpAndSettle();
    expect(find.text('player page $playerId'), findsOneWidget);
  });

  group('openPlayer', () {
    Future<GoRouter> pump(WidgetTester tester, Widget page) async {
      final router = GoRouter(
        routes: [
          GoRoute(path: '/', builder: (_, _) => Scaffold(body: page)),
          GoRoute(
            path: '/player',
            builder: (_, state) => Text('routed ${state.uri}'),
          ),
        ],
      );
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      return router;
    }

    testWidgets('with a pane above, the pane shows him', (tester) async {
      final pane = DetailPaneController();
      addTearDown(pane.dispose);
      await pump(
        tester,
        DetailPaneScope(
          controller: pane,
          child: Builder(
            builder: (context) => TextButton(
              onPressed: () => openPlayer(context, careerId: 1, playerId: 7),
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(pane.value, const PlayerTarget(7));
      expect(find.textContaining('routed'), findsNothing);
    });

    testWidgets('without one, his page opens as before', (tester) async {
      await pump(
        tester,
        Builder(
          builder: (context) => TextButton(
            onPressed: () => openPlayer(context, careerId: 1, playerId: 7),
            child: const Text('open'),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text('routed /player?careerId=1&playerId=7'), findsOneWidget);
    });
  });
}
```

- [ ] **Step 5: Run them to verify they fail**

Run: `flutter test test/widget/player_view_test.dart test/widget/detail_pane_host_test.dart`
Expected: FAIL to compile: `PlayerView`, `DetailPaneHost`, `detail_pane.dart` do not exist.

- [ ] **Step 6: The pane model**

`lib/shared/tablet/detail_pane.dart`:

```dart
import 'package:flutter/widgets.dart';

/// What a tablet detail pane is showing. Stage 2 has players; nations, team
/// stats and head to head join in later stages.
sealed class DetailTarget {
  const DetailTarget();
}

final class PlayerTarget extends DetailTarget {
  const PlayerTarget(this.playerId);

  final int playerId;

  @override
  bool operator ==(Object other) =>
      other is PlayerTarget && other.playerId == playerId;

  @override
  int get hashCode => playerId.hashCode;
}

/// The selection of one detail pane.
class DetailPaneController extends ValueNotifier<DetailTarget?> {
  DetailPaneController([super.value]);

  void show(DetailTarget target) => value = target;
  void clear() => value = null;
}

/// Marks a subtree whose screen hosts a detail pane, so anything in it that
/// opens a player can put him in the pane instead of routing away.
class DetailPaneScope extends InheritedNotifier<DetailPaneController> {
  const DetailPaneScope({
    required DetailPaneController controller,
    required super.child,
    super.key,
  }) : super(notifier: controller);

  /// The nearest pane's controller, or null when the screen has none.
  ///
  /// Not a dependency: callers use it from a tap handler, and must not
  /// rebuild when the selection changes. A sheet or dialog is NOT under the
  /// screen's scope (it sits on the root navigator), so code inside one gets
  /// null here and routes, which is why a sheet closes itself first.
  static DetailPaneController? maybeOf(BuildContext context) =>
      context.getInheritedWidgetOfExactType<DetailPaneScope>()?.notifier;
}
```

Add `export 'detail_pane.dart';` to `lib/shared/tablet/tablet.dart`.

- [ ] **Step 7: Extract `PlayerView`**

In `lib/features/player/player_detail_screen.dart`:

1. Replace the whole `body: viewAsync.when(...)` argument of the `Scaffold` in `PlayerDetailScreen.build` with `body: PlayerView(careerId: careerId, playerId: playerId),`, and delete the `viewAsync` local (keep `l`: the AppBar title uses it).
2. Move `_clubFact` and `_fact` from `PlayerDetailScreen` into `PlayerView` unchanged.
3. Add `PlayerView` after `PlayerDetailScreen`. Its `build` is the removed `viewAsync.when(...)` expression, moved VERBATIM, with exactly two edits: the `ListView`'s `padding:` becomes `padding: padding,`, and `money(p.value)` becomes `PlayerDetailScreen.money(p.value)`:

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
    // The loading:, error: and data: arguments are the ones cut from
    // PlayerDetailScreen's body in point 1, with the two edits above.
    return viewAsync.when(loading: ..., error: ..., data: ...);
  }

  // _clubFact and _fact, moved here from PlayerDetailScreen.
}
```

The phone page is pixel-identical: same provider, same widgets, same default padding (`AppSpacing.marginMobile` all round).

- [ ] **Step 8: `DetailPaneHost` and `openPlayer`**

`lib/features/shell/detail_pane_host.dart`:

```dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/features/player/player_detail_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/detail_pane.dart';
import 'package:fnm/shared/tablet/master_detail.dart';
import 'package:fnm/shared/tablet/tablet_text.dart';
import 'package:go_router/go_router.dart';

/// The right-hand pane of a tablet screen: whatever is selected, drawn with
/// the same `*View` its full page uses, under a header that links to that
/// page.
class DetailPaneHost extends StatelessWidget {
  const DetailPaneHost({
    required this.careerId,
    required this.target,
    this.placeholder,
    super.key,
  });

  static const Key fullProfileKey = Key('detailPane.fullProfile');

  final int careerId;
  final DetailTarget? target;

  /// What the empty pane says; [AppLocalizations.panePickPlayer] by default.
  final String? placeholder;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = target;
    if (t == null) {
      return MasterDetailPlaceholder(text: placeholder ?? l.panePickPlayer);
    }
    final (title, route, body) = switch (t) {
      PlayerTarget(:final playerId) => (
        l.playerTitle,
        '${Routes.player}?careerId=$careerId&playerId=$playerId',
        PlayerView(
          // A new player is a new card: no scroll offset carried over.
          key: ValueKey(playerId),
          careerId: careerId,
          playerId: playerId,
        ),
      ),
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 34,
          color: AppColors.surfaceContainer,
          padding: const EdgeInsets.only(left: 12, right: 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TabletText.panelTitle,
                ),
              ),
              TextButton(
                key: fullProfileKey,
                onPressed: () => context.push(route),
                child: Text(l.paneFullProfile, style: TabletText.panelLink),
              ),
            ],
          ),
        ),
        Expanded(child: body),
      ],
    );
  }
}

/// Shows a player: in the nearest detail pane when the screen has one,
/// otherwise on his own page, as every phone screen does.
///
/// From inside a sheet or dialog there is never a pane (see
/// [DetailPaneScope.maybeOf]); close the sheet BEFORE calling this.
void openPlayer(
  BuildContext context, {
  required int careerId,
  required int playerId,
}) {
  final pane = DetailPaneScope.maybeOf(context);
  if (pane != null) {
    pane.show(PlayerTarget(playerId));
    return;
  }
  unawaited(
    context.push('${Routes.player}?careerId=$careerId&playerId=$playerId'),
  );
}
```

- [ ] **Step 9: Run the tests and the guard, expect PASS**

Run: `flutter test test/widget/player_view_test.dart test/widget/detail_pane_host_test.dart test/golden/phone_guard_player_test.dart`
Expected: PASS. The golden must pass without `--update-goldens`.

- [ ] **Step 10: Analyze, full suite, commit**

```bash
flutter analyze && flutter test
git add lib/shared/tablet/detail_pane.dart lib/shared/tablet/tablet.dart lib/features/shell/detail_pane_host.dart lib/features/player/player_detail_screen.dart test/widget/player_view_test.dart test/widget/detail_pane_host_test.dart
git commit -m "feat(tablet): PlayerView, DetailPaneHost and openPlayer

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---
### Task 5: Hub dashboard

The mockup's Main (Hub): a header, then a 12-column `DashboardGrid` of panels. Row 1: Next match (5), Group or ladder (4), Board (3). Row 2: Form (3), Inbox (5), Y (4). Row 3: Federation strip (12). No app bar (the shell's top bar has the inbox and Continue) and no in-body Continue: the top bar's Continue becomes the tour's `hubAction` target.

**Files:**
- Create: `lib/features/hub/hub_tablet_layout.dart` (part of `hub_screen.dart`)
- Modify: `lib/features/hub/hub_screen.dart`, `lib/features/hub/board_objectives_screen.dart`, `lib/features/hub/hub_event_button.dart`, `lib/features/shell/tablet_top_bar.dart`, `lib/features/shell/tablet_shell.dart` (`tabletReadyPaths`)
- Test: `test/golden/phone_guard_hub_test.dart`, `test/widget/hub_tablet_test.dart`

**Interfaces:**
- Consumes: `hubDataProvider`, `HubData` (`next`, `nextDrawWatched`, `group`, `groupDrawWatched`, `groupDirectCount`, `groupContentionPos`, `groupRelegateCount`, `recentResults`, `nations`, `career`, `championNationId`, `squadRating`); `wcHostThemeProvider`, `continentalHostThemeProvider`, `WcHostBanner`; `playerRankProvider`; `satisfactionProvider`, `boardVerdict`; `cycleObjectivesProvider`, `CycleObjective`; `messageInboxProvider`, `messageStyle`, `readMessage`; `yFeedProvider`, `YPost`, `yPostBody`; `federationFundsProvider`, `federationBuildingsProvider`, `DepartmentBuilding`, `FederationBuildings.maxLevel`, `departmentLabel`, `formatEuros`; `moraleProvider`, `moraleLabel`; `HubHeader`, `_GroupTable`; `Panel`, `PanelLink`, `DashboardGrid`, `DashboardTile`, `TabletShellScope`, `TabletText`; `TourKeys.hubBoard`, `TourKeys.hubAction`; `drawKindForFixture` (draw_reveal.dart, test only).
- Produces:
  - `HubScreen.tabletLayoutKey`, `HubScreen.nextMatchPanelKey` (static const Keys)
  - `HubEventButton({required int careerId, bool compact = false, bool? tourTarget})`
  - `String objectiveStatusLabel(AppLocalizations l, CycleObjective o)`, `Color objectiveStatusColor(CycleObjective o)` (board_objectives_screen.dart)
  - `_GroupTable({..., bool framed = true})`
  - `tabletReadyPaths` gains `Routes.hub`.

- [ ] **Step 1: Pin the phone hub**

`test/golden/phone_guard_hub_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/hub/hub_screen.dart';
import 'package:fnm/shared/widgets/app_bottom_nav.dart';

import '../helpers/seeded_save.dart';

/// The phone hub, pinned before the tablet layout is added beside it. Must
/// pass unchanged for the rest of the tablet work.
void main() {
  testWidgets('phone hub', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(tester, save, '${Routes.hub}?careerId=${save.careerId}');
    expect(find.byType(HubHeader), findsOneWidget);
    expect(find.byType(AppBottomNav), findsOneWidget);
    await expectAppGolden('goldens/hub_phone.png');
  });
}
```

- [ ] **Step 2: Create the baseline, confirm it holds, commit it**

```bash
flutter test --update-goldens test/golden/phone_guard_hub_test.dart
flutter test test/golden/phone_guard_hub_test.dart
git add test/golden/phone_guard_hub_test.dart test/golden/goldens/hub_phone.png
git commit -m "test(tablet): pin the phone hub

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

Expected: the second command PASSES. Open the PNG: the hub with header, board strip, Continue button and bottom nav (no spinner).

- [ ] **Step 3: Write the failing tablet test**

`test/widget/hub_tablet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/hub/draw_reveal.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/hub/hub_screen.dart';
import 'package:fnm/features/onboarding/tour_keys.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/shell/tablet_top_bar.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/seeded_save.dart';

void main() {
  testWidgets('the hub is a dashboard of panels on a tablet', (tester) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    await pumpRoute(
      tester,
      save,
      '${Routes.hub}?careerId=${save.careerId}',
      size: kTabletSize,
    );
    // No IntrinsicHeight assertion from any panel (Review Focus 3).
    expect(tester.takeException(), isNull);
    expect(find.byKey(HubScreen.tabletLayoutKey), findsOneWidget);
    expect(find.byType(DashboardGrid), findsOneWidget);
    expect(find.byType(PhoneWidthFrame), findsNothing);
    expect(find.byType(AppBar), findsNothing);
    for (final title in [
      enL.hubNextMatch,
      enL.sideBoard,
      enL.playerStatForm,
      enL.sideInbox,
      enL.navY,
      enL.sideGroupFederation,
    ]) {
      // Scoped: the sidebar says "Y", "Inbox" and "FEDERATION" too.
      expect(
        find.descendant(
          of: find.byType(DashboardGrid),
          matching: find.text(title.toUpperCase()),
        ),
        findsOneWidget,
        reason: title,
      );
    }
    // The tour's first stop is the top bar's Continue now, and there is
    // exactly one of it.
    expect(find.byKey(TourKeys.hubAction), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(TabletTopBar),
        matching: find.byKey(TourKeys.hubAction),
      ),
      findsOneWidget,
    );
    expect(find.byKey(TourKeys.hubBoard), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the next opponent stays hidden until the draw is watched', (
    tester,
  ) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    late HubData hub;
    await tester.runAsync(() async {
      hub = (await save.container.read(
        hubDataProvider(save.careerId).future,
      ))!;
    });
    final next = hub.next!;
    expect(
      hub.nextDrawWatched,
      isFalse,
      reason: 'the seeded save opens before its first draw',
    );
    final oppId = next.homeNationId == save.nationId
        ? next.awayNationId
        : next.homeNationId;
    final oppName = hub.nations[oppId]!.name;

    await pumpRoute(
      tester,
      save,
      '${Routes.hub}?careerId=${save.careerId}',
      size: kTabletSize,
    );
    final panel = find.byKey(HubScreen.nextMatchPanelKey);
    expect(
      find.descendant(of: panel, matching: find.text(oppName)),
      findsNothing,
    );
    expect(
      find.descendant(of: panel, matching: find.text(enL.topBarDrawPending)),
      findsOneWidget,
    );

    await tester.runAsync(
      () => save.container
          .read(competitionRepositoryProvider)
          .markDrawWatched(
            save.careerId,
            save.career.cyclePointer,
            drawKindForFixture(next)!,
          ),
    );
    save.container.invalidate(hubDataProvider(save.careerId));
    await settle(tester);
    expect(
      find.descendant(of: panel, matching: find.text(oppName)),
      findsOneWidget,
    );
    await tester.pumpWidget(const SizedBox());
  });
}
```

- [ ] **Step 4: Run it to verify it fails**

Run: `flutter test test/widget/hub_tablet_test.dart`
Expected: FAIL to compile (`HubScreen.tabletLayoutKey` does not exist).

- [ ] **Step 5: Objective status helpers**

In `lib/features/hub/board_objectives_screen.dart`, add after `boardVerdict`:

```dart
/// The colour an objective's status is written in: grey while its tournament
/// is live, gold when the brief was beaten outright, green met, red missed.
/// Beating a brief by rounds is its own colour: a cycle carried three rounds
/// past what was asked should not look like one that scraped it.
Color objectiveStatusColor(CycleObjective o) {
  final gap = o.actual - o.target;
  return !o.decided
      ? AppColors.onSurfaceVariant
      : gap > 0
      ? AppColors.primary
      : (o.met ? AppColors.positive : AppColors.error);
}

/// An objective's status line: how far the run has got while it is live,
/// and once graded, by how much it was met, beaten or missed.
String objectiveStatusLabel(AppLocalizations l, CycleObjective o) =>
    !o.decided
    ? (o.actual >= 2
          ? l.boardObjectiveSoFar(o.resultLabel)
          : l.boardObjectivesPending)
    : switch (o.actual - o.target) {
        0 => l.hubObjectiveMet(o.resultLabel),
        final gap when gap > 0 => l.boardObjectiveBeatenBy(o.resultLabel, gap),
        final gap => l.boardObjectiveShortBy(o.resultLabel, -gap),
      };
```

In `_ObjectiveCard.build`, replace the `gap`/`color` locals with `final color = objectiveStatusColor(objective);`, and replace the status `Text`'s whole conditional expression (keep its comment block above it) with `objectiveStatusLabel(l, objective),`. Same colours and words as before.

- [ ] **Step 6: The tour target moves to the top bar on tablet**

In `lib/features/hub/hub_event_button.dart`, add a field and use it for the key:

```dart
  const HubEventButton({
    required this.careerId,
    this.compact = false,
    this.tourTarget,
    super.key,
  });

  /// Whether this button carries [TourKeys.hubAction]. Defaults to the
  /// full-size (in-body) button. The tablet top bar sets it, because the
  /// tablet hub has no in-body button; one GlobalKey, one widget, always.
  final bool? tourTarget;
```

and in `build`:

```dart
    final button = PrimaryButton(
      key: (widget.tourTarget ?? !widget.compact) ? TourKeys.hubAction : null,
```

In `lib/features/shell/tablet_top_bar.dart`:

```dart
            child: HubEventButton(
              careerId: careerId,
              compact: true,
              tourTarget: true,
            ),
```

(The shell and its top bar exist only on a tablet-sized window, where the hub is the tablet layout without an in-body button. In split view the shell steps aside and the phone hub's own button carries the key.)

- [ ] **Step 7: Hook the layout into `HubScreen`**

In `lib/features/hub/hub_screen.dart`:

1. Add imports:

```dart
import 'package:fnm/core/util/federation_label.dart';
import 'package:fnm/core/util/message_text.dart';
import 'package:fnm/domain/services/federation/federation_finance.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/features/hub/objective_providers.dart';
import 'package:fnm/features/messages/message_sheet.dart' show messageStyle;
import 'package:fnm/features/y/y_screen.dart' show yPostBody;
import 'package:fnm/shared/tablet/tablet.dart';
```

and below the imports: `part 'hub_tablet_layout.dart';`

2. Add to `HubScreen`:

```dart
  static const Key tabletLayoutKey = Key('hub.tabletLayout');
  static const Key nextMatchPanelKey = Key('hub.tablet.nextMatch');
```

3. Move the `_GroupTable`'s `onTap:` closure body into a method on `_HubScreenState`, unchanged:

```dart
  /// Opens the competition [hub]'s group belongs to: the Nations Cup, the
  /// World Championship for its qualifiers and finals, else the manager's
  /// continental cup.
  void _openGroup(BuildContext context, HubData hub) {
    final comp = hub.group!.competition;
    final conf = hub.nations[hub.career.nationId]?.confederation;
    // Any of the three cups (Europe's, North America's, Africa's): his own,
    // which the screen opens on.
    if (hub.group!.kind == CompetitionKind.nationsLeague ||
        NationsCups.isNationsCup(comp)) {
      context.go('${Routes.nationsCup}?careerId=$careerId');
      return;
    }
    final isWc = comp == 'World Cup Qualifiers' || comp == 'World Championship';
    context.go(
      isWc || conf == null
          ? '${Routes.cup}?careerId=$careerId'
          : '${Routes.continental}?careerId=$careerId&conf=${conf.name}',
    );
  }
```

and in the phone tree pass `onTap: () => _openGroup(context, hub),`.

4. In `_HubScreenState.build`, after the tour-offer block and before `return Scaffold(`, add:

```dart
    // The popups above run for both layouts; only the drawing differs.
    if (TabletShellScope.isActive(context)) {
      return _HubTabletLayout(
        careerId: careerId,
        onOpenGroup: (hub) => _openGroup(context, hub),
      );
    }
```

5. Give `_GroupTable` a `framed` flag. Add the field and constructor parameter `this.framed = true,`:

```dart
  /// False inside a tablet panel, which already supplies the box and names
  /// the competition: the table is drawn bare and without that first line.
  final bool framed;
```

and in its `build`, assign the existing `Column(...)` to `final content = Column(...)`, wrap its first child (the competition-label `Row`) in `if (framed)`, and return:

```dart
    return framed
        ? AppCard(onTap: onTap, child: content)
        : InkWell(onTap: onTap, child: content);
```

With `framed: true` the phone draws exactly what it drew.

- [ ] **Step 8: The tablet layout**

`lib/features/hub/hub_tablet_layout.dart`:

```dart
part of 'hub_screen.dart';

/// The hub on a tablet: the mockup's dashboard. Data comes from the same
/// providers the phone hub watches; the only additions are the objectives
/// and the Y feed (both already kept alive by the phone hub's satisfaction
/// and Y badge) and the federation buildings (changed only on screens that
/// leave the hub).
class _HubTabletLayout extends ConsumerWidget {
  const _HubTabletLayout({required this.careerId, required this.onOpenGroup});

  final int careerId;
  final void Function(HubData hub) onOpenGroup;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final dataAsync = ref.watch(hubDataProvider(careerId));
    final host = ref.watch(wcHostThemeProvider(careerId)).valueOrNull;
    final contHost = ref
        .watch(continentalHostThemeProvider(careerId))
        .valueOrNull;
    return Scaffold(
      key: HubScreen.tabletLayoutKey,
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorState(
          message: l.hubCouldNotLoadSave('').trim(),
          onRetry: () => ref.invalidate(hubDataProvider(careerId)),
        ),
        data: (hub) {
          if (hub == null) return Center(child: Text(l.hubSaveNotFound));
          final nation = hub.nations[hub.career.nationId];
          String code(int id) => hub.nations[id]?.code ?? '??';
          final playerRank = ref
              .watch(playerRankProvider(careerId))
              .valueOrNull;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HubHeader(
                  code: nation?.code ?? '??',
                  nationName: nation?.name ?? '…',
                  managerName: hub.career.managerName,
                  date: AppDate.dayMonthYear(context, hub.career.inGameDate),
                  rank: playerRank?.rank,
                  movement: playerRank?.movement ?? 0,
                ),
                const SizedBox(height: AppSpacing.md),
                if (host?.active ?? false) ...[
                  WcHostBanner(theme: host!, code: code),
                  const SizedBox(height: AppSpacing.md),
                ] else if (contHost?.active ?? false) ...[
                  WcHostBanner(theme: contHost!, code: code),
                  const SizedBox(height: AppSpacing.md),
                ],
                // Every tile must report an intrinsic height: no lists, no
                // LayoutBuilder, no WholeText (see DashboardGrid).
                DashboardGrid(
                  tiles: [
                    DashboardTile(
                      span: 5,
                      child: _NextMatchPanel(
                        key: HubScreen.nextMatchPanelKey,
                        careerId: careerId,
                        hub: hub,
                      ),
                    ),
                    DashboardTile(
                      span: 4,
                      child: _GroupPanel(
                        careerId: careerId,
                        hub: hub,
                        onOpen: () => onOpenGroup(hub),
                      ),
                    ),
                    DashboardTile(
                      span: 3,
                      child: _BoardPanel(
                        key: TourKeys.hubBoard,
                        careerId: careerId,
                      ),
                    ),
                    DashboardTile(
                      span: 3,
                      child: _FormPanel(careerId: careerId, hub: hub),
                    ),
                    DashboardTile(
                      span: 5,
                      child: _InboxPanel(careerId: careerId),
                    ),
                    DashboardTile(
                      span: 4,
                      child: _YPanel(careerId: careerId),
                    ),
                    DashboardTile(
                      span: 12,
                      child: _FederationPanel(careerId: careerId),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// The next fixture, both sides by flag and name, and the two places a
/// manager goes before it. The opponent is held back until the draw that
/// decides him has been watched, as everywhere else.
class _NextMatchPanel extends StatelessWidget {
  const _NextMatchPanel({
    required this.careerId,
    required this.hub,
    super.key,
  });

  final int careerId;
  final HubData hub;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final champion = hub.championNationId;
    final f = hub.next;
    final Widget body;
    if (champion != null) {
      body = Column(
        children: [
          const Icon(Icons.emoji_events, color: AppColors.primary, size: 32),
          const SizedBox(height: AppSpacing.xs),
          Text(l.hubWorldChampions, style: TabletText.barMeta),
          const SizedBox(height: AppSpacing.xs),
          _Team(
            code: hub.nations[champion]?.code ?? '??',
            name: hub.nations[champion]?.name ?? l.hubUnknown,
          ),
          TextButton(
            onPressed: () => context.go('${Routes.cup}?careerId=$careerId'),
            child: Text(l.hubViewBracket),
          ),
        ],
      );
    } else if (f == null) {
      body = Text(l.hubNoMoreFixtures, style: TabletText.cell);
    } else {
      final me = hub.career.nationId;
      Widget side(int id) => !hub.nextDrawWatched && id != me
          ? _HiddenTeam(label: l.topBarDrawPending)
          : _Team(
              code: hub.nations[id]?.code ?? '??',
              name: hub.nations[id]?.name ?? l.hubUnknown,
            );
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            MatchStage.label(l, f),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TabletText.barMeta,
          ),
          Text(
            AppDate.weekdayDayMonthCaps(context, f.date),
            style: TabletText.barMeta,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(child: side(f.homeNationId)),
              Text(l.hubVs, style: AppTypography.labelLarge),
              Expanded(child: side(f.awayNationId)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () =>
                      context.go('${Routes.callUps}?careerId=$careerId'),
                  child: Text(l.sideCallUps, maxLines: 1),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: OutlinedButton(
                  onPressed: () =>
                      context.go('${Routes.tactics}?careerId=$careerId'),
                  child: Text(l.sideTactics, maxLines: 1),
                ),
              ),
            ],
          ),
        ],
      );
    }
    return Panel(title: l.hubNextMatch, child: body);
  }
}

class _Team extends StatelessWidget {
  const _Team({required this.code, required this.name});

  final String code;
  final String name;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      FlagDisc(code, size: 44),
      const SizedBox(height: 6),
      Text(
        name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: TabletText.barStrong,
      ),
    ],
  );
}

/// Where the opponent will be once his draw has been watched.
class _HiddenTeam extends StatelessWidget {
  const _HiddenTeam({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surfaceContainerHigh,
        ),
        child: const Icon(Icons.casino, color: AppColors.onSurfaceVariant),
      ),
      const SizedBox(height: 6),
      Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: TabletText.barMeta,
      ),
    ],
  );
}

/// The group or ladder the manager is in, once its draw has been watched;
/// "to be drawn" before; the squad's state when there is no group at all.
class _GroupPanel extends ConsumerWidget {
  const _GroupPanel({
    required this.careerId,
    required this.hub,
    required this.onOpen,
  });

  final int careerId;
  final HubData hub;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final g = hub.group;
    if (g == null) {
      final morale = ref.watch(moraleProvider(careerId)).valueOrNull ?? 50;
      return Panel(
        title: l.hubSquadStatus,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Fact(label: l.hubAvgRating, value: '${hub.squadRating}'),
            const SizedBox(height: AppSpacing.xs),
            _Fact(label: l.hubMorale, value: moraleLabel(l, morale)),
          ],
        ),
      );
    }
    if (!hub.groupDrawWatched) {
      return Panel(
        title: competitionLabel(l, g.competition),
        child: Row(
          children: [
            const Icon(Icons.casino, color: AppColors.primary, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(l.hubGroupsToBeDrawn, style: TabletText.cell),
            ),
          ],
        ),
      );
    }
    return Panel(
      title: competitionLabel(l, g.competition),
      action: PanelLink(label: l.panelViewAll, onTap: onOpen),
      child: _GroupTable(
        framed: false,
        group: g,
        playerNationId: hub.career.nationId,
        directCount: hub.groupDirectCount,
        contentionPos: hub.groupContentionPos,
        relegateCount: hub.groupRelegateCount,
        code: (id) => hub.nations[id]?.code ?? '??',
        name: (id) => hub.nations[id]?.name ?? l.hubUnknown,
        onTap: onOpen,
      ),
    );
  }
}

/// The board's confidence and each objective's status, in short.
class _BoardPanel extends ConsumerWidget {
  const _BoardPanel({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final value = ref.watch(satisfactionProvider(careerId)).valueOrNull;
    final (color, verdict) = boardVerdict(l, value);
    final objectives =
        ref.watch(cycleObjectivesProvider(careerId)).valueOrNull ??
        const <CycleObjective>[];
    return Panel(
      title: l.sideBoard,
      action: PanelLink(
        label: l.panelViewAll,
        onTap: () =>
            context.go('${Routes.boardObjectives}?careerId=$careerId'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l.boardObjectivesConfidence,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TabletText.cell,
                ),
              ),
              if (value != null)
                Text(
                  '$value%',
                  style: TabletText.cellNumeric.copyWith(color: color),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          _Bar(fraction: (value ?? 0) / 100, color: color),
          // The verdict only once there is a figure: without one,
          // boardVerdict's placeholder is a dash, not a word.
          if (value != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(verdict, style: TabletText.barMeta.copyWith(color: color)),
          ],
          for (final o in objectives) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(o.label, style: TabletText.cell),
            Text(
              objectiveStatusLabel(l, o),
              style: TabletText.barMeta.copyWith(
                color: objectiveStatusColor(o),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// The last five results as pills, newest on the right, and the last three
/// spelled out.
class _FormPanel extends StatelessWidget {
  const _FormPanel({required this.careerId, required this.hub});

  final int careerId;
  final HubData hub;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final me = hub.career.nationId;
    final recent = hub.recentResults.take(5).toList();
    int sign(Fixture f) {
      final mine = f.homeNationId == me ? f.homeScore! : f.awayScore!;
      final theirs = f.homeNationId == me ? f.awayScore! : f.homeScore!;
      return (mine - theirs).sign;
    }

    return Panel(
      title: l.playerStatForm,
      action: PanelLink(
        label: l.panelViewAll,
        onTap: () => context.go('${Routes.results}?careerId=$careerId'),
      ),
      child: recent.isEmpty
          ? Text(l.matchDossierNoGames, style: TabletText.barMeta)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    for (final f in recent.reversed) ...[
                      Expanded(child: _FormPill(result: sign(f))),
                      if (f != recent.first) const SizedBox(width: 6),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                for (final f in recent.take(3))
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        FlagDisc(
                          hub
                                  .nations[f.homeNationId == me
                                      ? f.awayNationId
                                      : f.homeNationId]
                                  ?.code ??
                              '??',
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            hub
                                    .nations[f.homeNationId == me
                                        ? f.awayNationId
                                        : f.homeNationId]
                                    ?.name ??
                                l.hubUnknown,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TabletText.cell,
                          ),
                        ),
                        Text(
                          '${f.homeScore}-${f.awayScore}',
                          style: TabletText.cellNumeric,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}

/// W, D or L, as the scouting dossier writes it.
class _FormPill extends StatelessWidget {
  const _FormPill({required this.result});

  /// +1 win, 0 draw, -1 loss.
  final int result;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (result) {
      > 0 => ('W', AppColors.positive),
      < 0 => ('L', AppColors.error),
      _ => ('D', AppColors.outline),
    };
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.85),
        borderRadius: AppRadii.smAll,
      ),
      child: Text(
        label,
        style: TabletText.cellNumeric.copyWith(
          color: AppColors.surface,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// The five newest messages. A tap opens the inbox.
class _InboxPanel extends ConsumerWidget {
  const _InboxPanel({required this.careerId});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    // The same provider the hub's unread badge already keeps alive.
    final messages =
        ref.watch(messageInboxProvider(careerId)).valueOrNull?.messages ??
        const <MessageItem>[];
    void open() => context.go('${Routes.messages}?careerId=$careerId');
    return Panel(
      title: l.sideInbox,
      padding: EdgeInsets.zero,
      action: PanelLink(label: l.panelViewAll, onTap: open),
      child: messages.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(12),
              child: Text(l.messagesNoMessagesYet, style: TabletText.barMeta),
            )
          : Column(
              children: [
                for (final m in messages.take(5))
                  InkWell(
                    onTap: open,
                    child: Container(
                      height: 36,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: AppColors.divider),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: m.read
                                  ? AppColors.outlineVariant
                                  : messageStyle(m.category).color,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              readMessage(l, m).title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TabletText.cell,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text('${m.year}', style: TabletText.barMeta),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

/// The two newest stories on Y. Drawn here rather than with `YPostTile`,
/// which is built on WholeText (a LayoutBuilder) and would assert inside the
/// dashboard's IntrinsicHeight rows.
class _YPanel extends ConsumerWidget {
  const _YPanel({required this.careerId});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    // Already kept alive by the hub's Y badge (yUnreadCountProvider).
    final posts = [
      for (final p in ref.watch(yFeedProvider(careerId)).valueOrNull?.posts ??
          const <YPost>[])
        if (p.replyTo == null) p,
    ].take(2).toList();
    void open() => context.go('${Routes.y}?careerId=$careerId');
    return Panel(
      title: l.navY,
      action: PanelLink(label: l.panelViewAll, onTap: open),
      child: posts.isEmpty
          ? Text(l.yEmpty, style: TabletText.barMeta)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final p in posts)
                  InkWell(
                    onTap: open,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: p.displayName,
                                  style: TabletText.barStrong,
                                ),
                                TextSpan(
                                  text: '  ${p.handle}',
                                  style: TabletText.barMeta,
                                ),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            yPostBody(l, p),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TabletText.cell.copyWith(
                              color: AppColors.onSurfaceVariant,
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

/// What the federation can spend, and each department's building level.
class _FederationPanel extends ConsumerWidget {
  const _FederationPanel({required this.careerId});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final funds = ref.watch(federationFundsProvider(careerId)).valueOrNull;
    final buildings =
        ref.watch(federationBuildingsProvider(careerId)).valueOrNull ??
        const <DepartmentBuilding>[];
    return Panel(
      title: l.sideGroupFederation,
      action: PanelLink(
        label: l.panelViewAll,
        onTap: () => context.go('${Routes.finances}?careerId=$careerId'),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _Figure(
              label: l.federationFreeToSpend,
              value: formatEuros(funds?.free ?? 0),
            ),
          ),
          for (final b in buildings) ...[
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _Figure(
                label: departmentLabel(l, b.department),
                value: l.federationLevelBadge(b.level),
                fraction: b.level / FederationBuildings.maxLevel,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Figure extends StatelessWidget {
  const _Figure({required this.label, required this.value, this.fraction});

  final String label;
  final String value;
  final double? fraction;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TabletText.header,
      ),
      const SizedBox(height: 2),
      Text(
        value,
        style: TabletText.cellNumeric.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      if (fraction != null) ...[
        const SizedBox(height: AppSpacing.xs),
        _Bar(fraction: fraction!, color: AppColors.primary, height: 4),
      ],
    ],
  );
}

class _Fact extends StatelessWidget {
  const _Fact({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(child: Text(label, style: TabletText.cell)),
      Text(value, style: TabletText.barStrong),
    ],
  );
}

/// A thin filled bar. FractionallySizedBox rather than a progress indicator:
/// it reports an intrinsic height, which a dashboard tile needs.
class _Bar extends StatelessWidget {
  const _Bar({required this.fraction, required this.color, this.height = 6});

  final double fraction;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: AppRadii.smAll,
    child: Stack(
      children: [
        Container(height: height, color: AppColors.surfaceContainerHighest),
        FractionallySizedBox(
          widthFactor: fraction.clamp(0.0, 1.0),
          child: Container(height: height, color: color),
        ),
      ],
    ),
  );
}
```

If the analyzer reports `HubData`, `Fixture` or `MessageItem` as undefined in the part, the library already imports their files (`hub_providers.dart`, `fixture.dart`, `competition_repository.dart`); add any that is missing to `hub_screen.dart`'s imports.

- [ ] **Step 9: Register the hub as tablet ready**

In `lib/features/shell/tablet_shell.dart` (add `import 'package:fnm/core/routing/app_router.dart';`):

```dart
const Set<String> tabletReadyPaths = <String>{Routes.hub};
```

- [ ] **Step 10: Run the tablet test and the phone guard, expect PASS**

Run: `flutter test test/widget/hub_tablet_test.dart test/golden/phone_guard_hub_test.dart test/widget/hub_event_button_test.dart test/widget/tablet_top_bar_test.dart test/widget/hub_tour_news_test.dart test/widget/tablet_route_sweep_test.dart`
Expected: PASS. The golden passes without `--update-goldens`.

- [ ] **Step 11: Analyze, full suite, commit**

```bash
flutter analyze && flutter test
git add lib/features/hub/hub_screen.dart lib/features/hub/hub_tablet_layout.dart lib/features/hub/board_objectives_screen.dart lib/features/hub/hub_event_button.dart lib/features/shell/tablet_top_bar.dart lib/features/shell/tablet_shell.dart test/widget/hub_tablet_test.dart
git commit -m "feat(tablet): hub dashboard

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---
### Task 6: Call-ups in three columns

Pool grid on the left, the named squad with the draft summary and the confirm button in the middle, the focused player's card on the right. Selection, draft and confirm are the screen's existing ones: the toggle and the two auto-picks are pulled out of the phone tree into methods both layouts call.

**Files:**
- Create: `lib/features/tactics/call_up_tablet_layout.dart` (part of `call_up_screen.dart`)
- Modify: `lib/features/tactics/call_up_screen.dart`, `lib/features/shell/tablet_shell.dart`
- Test: `test/golden/phone_guard_call_ups_test.dart`, `test/widget/call_ups_tablet_test.dart`

**Interfaces:**
- Consumes: `squadDataProvider`, `SquadData`; `nominationWindowProvider`; `currentFormationProvider`; `callUpDraftProvider`, `callUpDraftKey`; `squadConditionProvider`; `absenceOutlookProvider`; `SquadSelection.bestQuality/previousSquad/usableInPeriod`; `kMinSquadSize`, `kMaxSquadSize`, `kMinFitPlayers`; private `_CoverageBanner`, `_FormDot`, `_order`, `_shortHeading`, `_initialSquad`, `_edit`, `_confirm`, `_exitRoute`; `DataGrid`, `GridColumn`, `GridColumnSet`, `Panel`, `PanelBox`, `TabletShellScope`; `DetailPaneController`, `DetailPaneScope`, `PlayerTarget`; `DetailPaneHost`, `openPlayer`; `TourKeys.callUpCount`.
- Produces:
  - `CallUpScreen.tabletLayoutKey` (static const Key)
  - private on `_CallUpScreenState`: `void _toggle(BuildContext context, Player p, bool on, {required Set<int> selected, required Map<int, PlayerAbsence> absences, required int coverage})`, `void _pickBest(SquadData data, int coverage, Formation formation)`, `void _pickPrevious(SquadData data, int coverage)`, `({int count, int fit, bool ok}) _squadStatus(Set<int> selected, SquadData data, int coverage)`, `void _setTabletLine(PositionCategory? line)`, fields `PositionCategory? _tabletLine`, `final DetailPaneController _pane`.
  - `tabletReadyPaths` gains `Routes.callUps`.

- [ ] **Step 1: Pin the phone call-ups**

`test/golden/phone_guard_call_ups_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/tactics/call_up_screen.dart';

import '../helpers/seeded_save.dart';

void main() {
  testWidgets('phone call-ups', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.callUps}?careerId=${save.careerId}',
    );
    expect(find.byType(CallUpScreen), findsOneWidget);
    expect(find.byType(TabBar), findsOneWidget);
    await expectAppGolden('goldens/call_ups_phone.png');
  });
}
```

- [ ] **Step 2: Create the baseline, confirm it holds, commit it**

```bash
flutter test --update-goldens test/golden/phone_guard_call_ups_test.dart
flutter test test/golden/phone_guard_call_ups_test.dart
git add test/golden/phone_guard_call_ups_test.dart test/golden/goldens/call_ups_phone.png
git commit -m "test(tablet): pin the phone call-ups

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

- [ ] **Step 3: Write the failing tablet test**

`test/widget/call_ups_tablet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/features/player/player_detail_screen.dart';
import 'package:fnm/features/shell/detail_pane_host.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/tactics/call_up_screen.dart';
import 'package:fnm/features/tactics/tactics_providers.dart' show kMaxSquadSize;
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/seeded_save.dart';

void main() {
  // Opened the way the hub opens it, as the timeline event: that always has a
  // draft key, so a part-named squad is stored as it is edited.
  String location(SeededSave save) =>
      '${Routes.callUps}?careerId=${save.careerId}'
      '&event=callup_test&cycle=${save.career.cyclePointer}';

  testWidgets('three columns: pool, squad, player', (tester) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    await pumpRoute(tester, save, location(save), size: kTabletSize);
    expect(tester.takeException(), isNull);
    expect(find.byKey(CallUpScreen.tabletLayoutKey), findsOneWidget);
    expect(find.byType(PhoneWidthFrame), findsNothing);
    expect(find.byType(DataGrid<Player>), findsOneWidget);
    expect(find.byType(DetailPaneHost), findsOneWidget);
    expect(
      find.text(enL.tacticsSquadCount(0, kMaxSquadSize)),
      findsOneWidget,
    );

    // Tapping a name puts that player in the right-hand pane.
    final grid = find.byType(DataGrid<Player>);
    final names = find.descendant(
      of: grid,
      matching: find.byKey(const ValueKey('callUps.name')),
    );
    final third = tester.widget<Text>(
      find.descendant(of: names.at(2), matching: find.byType(Text)),
    );
    await tester.tap(names.at(2));
    await settle(tester);
    expect(
      find.descendant(
        of: find.byType(PlayerView),
        matching: find.text(third.data!),
      ),
      findsOneWidget,
    );

    // Ticking a box names him.
    await tester.tap(find.descendant(of: grid, matching: find.byType(Checkbox)).first);
    await settle(tester);
    expect(
      find.text(enL.tacticsSquadCount(1, kMaxSquadSize)),
      findsOneWidget,
    );
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a squad named on the tablet layout survives the window '
      'shrinking to phone size', (tester) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    await pumpRoute(tester, save, location(save), size: kTabletSize);
    final grid = find.byType(DataGrid<Player>);
    await tester.tap(
      find.descendant(of: grid, matching: find.byType(Checkbox)).first,
    );
    await settle(tester);
    expect(
      find.text(enL.tacticsSquadCount(1, kMaxSquadSize)),
      findsOneWidget,
    );

    // iPad split view: the shell steps aside and the screen is rebuilt under
    // a new parent, with a new State (Review Focus 4).
    tester.view.physicalSize = kPhoneSize;
    await settle(tester);
    expect(find.byKey(CallUpScreen.tabletLayoutKey), findsNothing);
    expect(
      find.text(enL.tacticsSquadCount(1, kMaxSquadSize)),
      findsOneWidget,
      reason: 'the draft carried the pick across the remount',
    );
    await tester.pumpWidget(const SizedBox());
  });
}
```

- [ ] **Step 4: Run it to verify it fails**

Run: `flutter test test/widget/call_ups_tablet_test.dart`
Expected: FAIL to compile (`CallUpScreen.tabletLayoutKey`).

- [ ] **Step 5: Pull the shared actions out of the phone tree**

In `lib/features/tactics/call_up_screen.dart`:

1. Imports: add `import 'package:fnm/features/shell/detail_pane_host.dart';` and `import 'package:fnm/shared/tablet/tablet.dart';`, then `part 'call_up_tablet_layout.dart';`.

2. Add to `CallUpScreen`: `static const Key tabletLayoutKey = Key('callUps.tabletLayout');`

3. Add to `_CallUpScreenState`:

```dart
  /// The tablet pool's line filter (null: everyone).
  PositionCategory? _tabletLine;

  /// The tablet's right-hand pane.
  final DetailPaneController _pane = DetailPaneController();

  void _setTabletLine(PositionCategory? line) =>
      setState(() => _tabletLine = line);

  @override
  void dispose() {
    _pane.dispose();
    super.dispose();
  }

  /// How many are named, how many of them can play in the period, and
  /// whether that is a squad that may be confirmed.
  ///
  /// "Fit" is asked of the PERIOD, not of the next kick-off: a man serving one
  /// game of a three-match camp plays the other two.
  ({int count, int fit, bool ok}) _squadStatus(
    Set<int> selected,
    SquadData data,
    int coverage,
  ) {
    final count = selected.length;
    final fit = selected
        .where(
          (id) => SquadSelection.usableInPeriod(data.absences[id], coverage),
        )
        .length;
    return (
      count: count,
      fit: fit,
      ok:
          count >= kMinSquadSize &&
          count <= kMaxSquadSize &&
          fit >= kMinFitPlayers,
    );
  }

  /// Names or drops [p], refusing (with a snackbar) a man who misses every
  /// match of the period, or one more than the squad can hold.
  void _toggle(
    BuildContext context,
    Player p,
    bool on, {
    required Set<int> selected,
    required Map<int, PlayerAbsence> absences,
    required int coverage,
  }) {
    final l = AppLocalizations.of(context);
    if (on && !SquadSelection.usableInPeriod(absences[p.id], coverage)) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l.tacticsOutForWholeCamp)));
      return;
    }
    if (on && selected.length >= kMaxSquadSize) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(l.tacticsSquadFullMax(kMaxSquadSize))),
        );
      return;
    }
    _edit((s) {
      if (on) {
        s.add(p.id);
      } else {
        s.remove(p.id);
      }
    });
  }

  /// The best available squad for the shape being played.
  void _pickBest(SquadData data, int coverage, Formation formation) =>
      _edit((s) {
        s
          ..clear()
          ..addAll(
            SquadSelection.bestQuality(
              pool: data.pool,
              absences: data.absences,
              coverage: coverage,
              formation: formation,
              max: kMaxSquadSize,
            ),
          );
      });

  /// The last squad again, minus whoever cannot play in this period.
  void _pickPrevious(SquadData data, int coverage) => _edit((s) {
    s
      ..clear()
      ..addAll(
        SquadSelection.previousSquad(
          pool: data.pool,
          previous: data.callUps,
          absences: data.absences,
          coverage: coverage,
          max: kMaxSquadSize,
        ),
      );
  });
```

4. In the phone tree, use them in the same places (same behaviour):
   - replace the `count`/`fit`/`ok` locals with `final status = _squadStatus(selected, data, coverage); final count = status.count; final fit = status.fit; final ok = status.ok;`
   - Best quality button: `onPressed: () => _pickBest(data, coverage, formation),`
   - Previous squad button: `onPressed: !data.hasPreviousSquad ? null : () => _pickPrevious(data, coverage),`
   - in `_section`, the `_PlayerToggle`'s `onChanged:` becomes `locked ? null : (on) => _toggle(context, p, on, selected: selected, absences: absences, coverage: coverage),` (the long comment above it stays).

5. In `build`, after the draft-restoring block and before `return Scaffold(`:

```dart
    if (TabletShellScope.isActive(context)) {
      return Scaffold(
        key: CallUpScreen.tabletLayoutKey,
        body: dataAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) =>
              Center(child: Text(l.tacticsCouldNotLoadSquad(e.toString()))),
          data: (data) {
            if (data == null) return Center(child: Text(l.tacticsNoSquad));
            return _CallUpTabletLayout(
              state: this,
              data: data,
              selected: _selected ??= _initialSquad(data.pool, data.callUps),
              window: window,
              locked: locked,
              coverage: coverage,
              formation: formation,
              condition:
                  ref
                      .watch(squadConditionProvider(widget.careerId))
                      .valueOrNull ??
                  const <int, PlayerCondition>{},
              saveSeed: saveSeed,
            );
          },
        ),
      );
    }
```

- [ ] **Step 6: The tablet layout**

`lib/features/tactics/call_up_tablet_layout.dart`:

```dart
part of 'call_up_screen.dart';

/// Call-ups on a tablet: the pool as a table, the squad being named with its
/// summary and the confirm button, and the focused player's card. All state
/// is the screen's own (selection, draft, line filter, focused player).
class _CallUpTabletLayout extends StatelessWidget {
  const _CallUpTabletLayout({
    required this.state,
    required this.data,
    required this.selected,
    required this.window,
    required this.locked,
    required this.coverage,
    required this.formation,
    required this.condition,
    required this.saveSeed,
  });

  static const double _squadWidth = 260;
  static const double _paneWidth = 320;

  final _CallUpScreenState state;
  final SquadData data;
  final Set<int> selected;
  final NominationWindow? window;
  final bool locked;
  final int coverage;
  final Formation formation;
  final Map<int, PlayerCondition> condition;
  final int saveSeed;

  int get careerId => state.widget.careerId;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final rows = [
      for (final p in data.pool)
        if (state._tabletLine == null || p.category == state._tabletLine) p,
    ]..sort((a, b) => b.overall.compareTo(a.overall));
    final status = state._squadStatus(selected, data, coverage);
    return DetailPaneScope(
      controller: state._pane,
      child: ListenableBuilder(
        listenable: state._pane,
        builder: (context, _) {
          final focusedId = switch (state._pane.value) {
            PlayerTarget(:final playerId) => playerId,
            _ => null,
          };
          final focused = rows.where((p) => p.id == focusedId).firstOrNull;
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Panel(
                    title: l.squadStatPool,
                    expand: true,
                    padding: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _lineChips(context, l),
                        Expanded(
                          child: DataGrid<Player>(
                            rows: rows,
                            columnSets: [_columns(context, l)],
                            selected: focused,
                            onSelect: (p) => openPlayer(
                              context,
                              careerId: careerId,
                              playerId: p.id,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md - 4),
                SizedBox(
                  width: _squadWidth,
                  child: _squadPanel(context, l, status),
                ),
                const SizedBox(width: AppSpacing.md - 4),
                SizedBox(
                  width: _paneWidth,
                  child: PanelBox(
                    child: DetailPaneHost(
                      careerId: careerId,
                      target: state._pane.value,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _lineChips(BuildContext context, AppLocalizations l) {
    Widget chip(String label, PositionCategory? line) => Padding(
      padding: const EdgeInsets.only(right: AppSpacing.xs),
      child: ChoiceChip(
        label: Text(label),
        visualDensity: VisualDensity.compact,
        selected: state._tabletLine == line,
        onSelected: (_) => state._setTabletLine(line),
      ),
    );
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Wrap(
        children: [
          chip(l.squadLineAll, null),
          for (final c in _CallUpScreenState._order)
            chip(
              '${state._shortHeading(l, c)} '
              '${selected.where((id) => data.pool.any((p) => p.id == id && p.category == c)).length}',
              c,
            ),
        ],
      ),
    );
  }

  GridColumnSet<Player> _columns(BuildContext context, AppLocalizations l) =>
      GridColumnSet<Player>(
        id: 'pool',
        label: l.squadStatPool,
        columns: [
          GridColumn<Player>(
            id: 'pick',
            label: '',
            width: 40,
            cell: (p) => Checkbox(
              value: selected.contains(p.id),
              visualDensity: VisualDensity.compact,
              onChanged: locked
                  ? null
                  : (on) => state._toggle(
                      context,
                      p,
                      on ?? false,
                      selected: selected,
                      absences: data.absences,
                      coverage: coverage,
                    ),
            ),
          ),
          GridColumn<Player>(
            id: 'pos',
            label: l.squadDevPosition,
            width: 48,
            sortKey: (p) => p.position.index,
            cell: (p) => TacticalChip(p.position.label),
          ),
          GridColumn<Player>(
            id: 'name',
            label: l.squadSortName,
            flex: 3,
            sortKey: (p) => p.name,
            cell: (p) => Row(
              key: const ValueKey('callUps.name'),
              children: [
                if (!(data.absences[p.id]?.isAvailable ?? true))
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Icon(
                      (data.absences[p.id]?.injuryMatches ?? 0) > 0
                          ? Icons.personal_injury
                          : Icons.gavel_rounded,
                      size: 13,
                      color: (data.absences[p.id]?.injuryMatches ?? 0) > 0
                          ? AppColors.warning
                          : AppColors.error,
                    ),
                  ),
                Flexible(child: Text(p.name)),
              ],
            ),
          ),
          GridColumn<Player>(
            id: 'age',
            label: l.playerAge,
            width: 44,
            numeric: true,
            sortKey: (p) => p.age,
            cell: (p) => Text('${p.age}'),
          ),
          GridColumn<Player>(
            id: 'ovr',
            label: l.teamOverall,
            width: 64,
            numeric: true,
            sortKey: (p) => p.overall,
            cell: (p) => Text(
              '${p.overall}',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          GridColumn<Player>(
            id: 'form',
            label: l.playerStatForm,
            width: 48,
            numeric: true,
            sortKey: (p) => condition[p.id]?.formRating ?? 0,
            cell: (p) => _FormDot(
              form: condition[p.id]?.form ?? PlayerForm.steady,
            ),
          ),
        ],
      );

  Widget _squadPanel(
    BuildContext context,
    AppLocalizations l,
    ({int count, int fit, bool ok}) status,
  ) {
    final named = [
      for (final p in data.pool)
        if (selected.contains(p.id)) p,
    ]..sort((a, b) => b.overall.compareTo(a.overall));
    return Panel(
      title: l.tacticsSquad,
      expand: true,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          KeyedSubtree(
            key: TourKeys.callUpCount,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.tacticsSquadCount(status.count, kMaxSquadSize),
                    style: AppTypography.labelMedium.copyWith(
                      color: status.ok ? AppColors.onSurface : AppColors.error,
                    ),
                  ),
                  Text(
                    status.count >= kMinSquadSize &&
                            status.count <= kMaxSquadSize &&
                            status.fit < kMinFitPlayers
                        ? l.tacticsNeedFitPlayers(kMinFitPlayers, status.fit)
                        : l.tacticsMinMax(kMinSquadSize, kMaxSquadSize),
                    style: AppTypography.labelSmall.copyWith(
                      color: status.ok
                          ? AppColors.onSurfaceVariant
                          : AppColors.error,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (window != null && window!.matches.isNotEmpty)
            _CoverageBanner(window: window!, locked: locked),
          if (!locked)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () =>
                          state._pickBest(data, coverage, formation),
                      child: Text(
                        l.tacticsBestQuality,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: !data.hasPreviousSquad
                          ? null
                          : () => state._pickPrevious(data, coverage),
                      child: Text(
                        l.tacticsPreviousSquad,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              children: [
                for (final c in _CallUpScreenState._order)
                  if (named.any((p) => p.category == c)) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 2),
                      child: Text(
                        state._shortHeading(l, c).toUpperCase(),
                        style: TabletText.sectionLabel,
                      ),
                    ),
                    for (final p in named.where((p) => p.category == c))
                      ListTile(
                        dense: true,
                        visualDensity: VisualDensity.compact,
                        leading: TacticalChip(p.position.label),
                        title: Text(
                          p.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('${p.overall}', style: TabletText.cellNumeric),
                            if (!locked)
                              IconButton(
                                icon: const Icon(Icons.close, size: 16),
                                visualDensity: VisualDensity.compact,
                                onPressed: () => state._toggle(
                                  context,
                                  p,
                                  false,
                                  selected: selected,
                                  absences: data.absences,
                                  coverage: coverage,
                                ),
                              ),
                          ],
                        ),
                        onTap: () => openPlayer(
                          context,
                          careerId: careerId,
                          playerId: p.id,
                        ),
                      ),
                  ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: locked
                ? OutlinedButton.icon(
                    onPressed: () => context.go(state._exitRoute),
                    icon: const Icon(Icons.lock_outline, size: 18),
                    label: Text(l.tacticsSquadLockedBack),
                  )
                : PrimaryButton(
                    label: l.tacticsConfirmSquad,
                    icon: Icons.check_rounded,
                    onPressed: status.ok
                        ? () => state._confirm(selected)
                        : null,
                  ),
          ),
        ],
      ),
    );
  }
}
```

`_order` is a `static const` on the state and `_shortHeading` an instance method; both are reachable from the part.

- [ ] **Step 7: Register call-ups as tablet ready**

```dart
const Set<String> tabletReadyPaths = <String>{Routes.hub, Routes.callUps};
```

- [ ] **Step 8: Run, expect PASS**

Run: `flutter test test/widget/call_ups_tablet_test.dart test/golden/phone_guard_call_ups_test.dart test/widget/call_up_tabs_test.dart test/widget/call_up_availability_test.dart test/widget/call_up_home_away_test.dart test/widget/tablet_route_sweep_test.dart`
Expected: PASS; the phone golden unchanged. If the survival test fails because the restored count is 0, the draft was not stored: check `_draftKey` is set for the `event=` launch (it must be: `callUpDraftKey(eventKind: ...)` returns the kind) before changing anything else.

- [ ] **Step 9: Analyze, full suite, commit**

```bash
flutter analyze && flutter test
git add lib/features/tactics/call_up_screen.dart lib/features/tactics/call_up_tablet_layout.dart lib/features/shell/tablet_shell.dart test/widget/call_ups_tablet_test.dart
git commit -m "feat(tablet): call-ups in three columns

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---
### Task 7: Match preview in two columns

Your side on the left (setup warnings, the headline, what helps and hurts, your XI), the opponent on the right (head to head and scouting report, the ground). Kick off and Tactics sit bottom right. The opponent briefing becomes public as `OpponentBriefing`, since Tactics reuses it in Task 12.

**Files:**
- Create: `lib/features/match/match_preview_tablet_layout.dart` (part of `match_preview_screen.dart`)
- Modify: `lib/features/match/match_preview_screen.dart`, `lib/features/shell/tablet_shell.dart`
- Test: `test/golden/phone_guard_match_preview_test.dart`, `test/widget/match_preview_tablet_test.dart`

**Interfaces:**
- Consumes: `matchPreviewProvider`, `MatchPreview`; `wcHostThemeProvider`, `continentalHostThemeProvider`, `WcHostTheme`, `WcHostBanner`; `SquadSetupWarning`, `MatchHeadline`, `StrengthPanel`, `GroundCard`, `squadOverall`, `StrengthFactors.defaultSideRating`; private `_XiRow`, `_keyMen`, `_wcFinalsRounds`, `_continentalFinalsRounds`, `MatchPreviewScreen._openTactics`, `MatchPreviewScreen._barButtonHeight`; `TabletShellScope`, `TabletText`.
- Produces:
  - `MatchPreviewScreen.tabletLayoutKey` (static const Key)
  - `class OpponentBriefing extends StatefulWidget { const OpponentBriefing({required int careerId, required int myNationId, required int oppNationId, required String oppName, required String oppCode, required List<Player> keyMen, required int saveSeed}); }` (renamed from `_OpponentTabs`)
  - `tabletReadyPaths` gains `Routes.matchPreview`.

- [ ] **Step 1: Pin the phone preview**

`test/golden/phone_guard_match_preview_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/match/match_preview_screen.dart';

import '../helpers/seeded_save.dart';

void main() {
  testWidgets('phone match preview', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.matchPreview}?careerId=${save.careerId}',
    );
    expect(find.byType(MatchHeadline), findsOneWidget);
    await expectAppGolden('goldens/match_preview_phone.png');
  });
}
```

- [ ] **Step 2: Create the baseline, confirm it holds, commit it**

```bash
flutter test --update-goldens test/golden/phone_guard_match_preview_test.dart
flutter test test/golden/phone_guard_match_preview_test.dart
git add test/golden/phone_guard_match_preview_test.dart test/golden/goldens/match_preview_phone.png
git commit -m "test(tablet): pin the phone match preview

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

- [ ] **Step 3: Write the failing tablet test**

`test/widget/match_preview_tablet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/match/match_preview_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';

import '../helpers/seeded_save.dart';

void main() {
  testWidgets('the preview is two columns: your side, then theirs', (
    tester,
  ) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    await pumpRoute(
      tester,
      save,
      '${Routes.matchPreview}?careerId=${save.careerId}',
      size: kTabletSize,
    );
    expect(tester.takeException(), isNull);
    expect(find.byKey(MatchPreviewScreen.tabletLayoutKey), findsOneWidget);
    expect(find.byType(PhoneWidthFrame), findsNothing);
    final mine = tester.getCenter(find.byType(MatchHeadline));
    final theirs = tester.getCenter(find.byType(OpponentBriefing));
    expect(mine.dx, lessThan(theirs.dx));
    expect(find.text(enL.matchKickOff), findsOneWidget);
    expect(find.text(enL.matchTactics), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}
```

- [ ] **Step 4: Run it to verify it fails**

Run: `flutter test test/widget/match_preview_tablet_test.dart`
Expected: FAIL to compile (`MatchPreviewScreen.tabletLayoutKey`, `OpponentBriefing`).

- [ ] **Step 5: Make the briefing public and hook in the layout**

In `lib/features/match/match_preview_screen.dart`:

1. Rename `_OpponentTabs` to `OpponentBriefing` and `_OpponentTabsState` to `_OpponentBriefingState` (class, state, `createState`, the one use in the phone tree). Update its doc comment's first line to: `/// The opponent briefing: head to head and the scouting report as two tabs of one card, head to head open by default. Shared by the preview and the tablet Tactics screen's Opposition tab.`
2. Add `import 'package:fnm/shared/tablet/tablet.dart';` and `part 'match_preview_tablet_layout.dart';`.
3. Add to `MatchPreviewScreen`: `static const Key tabletLayoutKey = Key('matchPreview.tabletLayout');`
4. In `build`, right after `final accent = host?.accent ?? AppColors.primary;`:

```dart
    if (TabletShellScope.isActive(context)) {
      return _MatchPreviewTabletLayout(
        screen: this,
        host: host,
        themedRounds: themedRounds,
        accent: accent,
      );
    }
```

- [ ] **Step 6: The tablet layout**

`lib/features/match/match_preview_tablet_layout.dart`:

```dart
part of 'match_preview_screen.dart';

/// The preview on a tablet: two columns under one heading, the two actions
/// bottom right. The same widgets as the phone, laid side by side.
class _MatchPreviewTabletLayout extends ConsumerWidget {
  const _MatchPreviewTabletLayout({
    required this.screen,
    required this.host,
    required this.themedRounds,
    required this.accent,
  });

  final MatchPreviewScreen screen;
  final WcHostTheme? host;
  final Set<String> themedRounds;
  final Color accent;

  int get careerId => screen.careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final previewAsync = ref.watch(matchPreviewProvider(careerId));
    return Scaffold(
      key: MatchPreviewScreen.tabletLayoutKey,
      body: previewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.matchCouldNotLoad('$e'))),
        data: (preview) {
          if (preview == null) {
            return Center(child: Text(l10n.matchNoUpcoming));
          }
          final f = preview.fixture;
          String code(int id) => preview.nations[id]?.code ?? '??';
          String name(int id) =>
              preview.nations[id]?.name ?? l10n.matchUnknownNation;
          final team = preview.playerIsHome
              ? preview.homeTeam
              : preview.awayTeam;
          final positions = team.formation.positions;
          final myNationId = preview.playerIsHome
              ? f.homeNationId
              : f.awayNationId;
          final oppNationId = preview.playerIsHome
              ? f.awayNationId
              : f.homeNationId;
          final hosted = host != null && themedRounds.contains(f.round);
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text(
                      l10n.matchPreviewTitle,
                      style: TabletText.screenTitle.copyWith(color: accent),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        MatchStage.label(l10n, f),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TabletText.barMeta.copyWith(
                          color: hosted ? accent : AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                if (hosted) ...[
                  const SizedBox(height: AppSpacing.sm),
                  WcHostBanner(theme: host!, code: code),
                ],
                const SizedBox(height: AppSpacing.sm),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            SquadSetupWarning(careerId: careerId),
                            MatchHeadline(
                              homeCode: code(f.homeNationId),
                              homeOverall: squadOverall(preview.homeTeam.xi),
                              awayCode: code(f.awayNationId),
                              awayOverall: squadOverall(preview.awayTeam.xi),
                              date: f.date,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            StrengthPanel(
                              careerId: careerId,
                              formation: team.formation,
                              sideRating: team.xi.isEmpty
                                  ? StrengthFactors.defaultSideRating
                                  : squadOverall(team.xi),
                            ),
                            Row(
                              children: [
                                Text(
                                  l10n.matchYourXi,
                                  style: AppTypography.labelMedium.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Text(
                                  team.formation.label,
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            AppCard(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.sm,
                                horizontal: AppSpacing.md,
                              ),
                              child: Column(
                                children: [
                                  for (var i = 0; i < team.xi.length; i++)
                                    _XiRow(
                                      player: team.xi[i],
                                      slot: i < positions.length
                                          ? positions[i]
                                          : team.xi[i].position,
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: ListView(
                          children: [
                            OpponentBriefing(
                              careerId: careerId,
                              myNationId: myNationId,
                              oppNationId: oppNationId,
                              oppName: name(oppNationId),
                              oppCode: code(oppNationId),
                              keyMen: _keyMen(
                                preview.playerIsHome
                                    ? preview.awayTeam.xi
                                    : preview.homeTeam.xi,
                              ),
                              saveSeed: preview.saveSeed,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Text(
                              l10n.matchGroundTitle,
                              style: AppTypography.labelMedium.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            GroundCard(
                              ground: preview.ground,
                              neutral: preview.neutralVenue,
                              groundNationCode: code(
                                preview.ground.groundNationId,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              const Spacer(),
              SizedBox(
                width: 220,
                child: OutlinedButton.icon(
                  onPressed: () => screen._openTactics(context, ref),
                  icon: const Icon(Icons.tune, size: 18),
                  label: Text(l10n.matchTactics, maxLines: 1),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(
                      MatchPreviewScreen._barButtonHeight,
                    ),
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.outlineVariant),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              SizedBox(
                width: 220,
                child: PrimaryButton(
                  label: l10n.matchKickOff,
                  icon: Icons.sports_soccer,
                  height: MatchPreviewScreen._barButtonHeight,
                  onPressed: () =>
                      context.go('${Routes.match}?careerId=$careerId'),
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

(`_openTactics` pushes `/tactics` in the shell; Task 12's tablet Tactics shows a back arrow when it can pop, which returns here and refreshes the preview exactly as on the phone.)

- [ ] **Step 7: Register, run, expect PASS**

```dart
const Set<String> tabletReadyPaths = <String>{
  Routes.hub,
  Routes.callUps,
  Routes.matchPreview,
};
```

Run: `flutter test test/widget/match_preview_tablet_test.dart test/golden/phone_guard_match_preview_test.dart test/widget/setup_warning_test.dart test/widget/strength_panel_test.dart test/widget/tablet_route_sweep_test.dart`
Expected: PASS; phone golden unchanged.

- [ ] **Step 8: Analyze, full suite, commit**

```bash
flutter analyze && flutter test
git add lib/features/match/match_preview_screen.dart lib/features/match/match_preview_tablet_layout.dart lib/features/shell/tablet_shell.dart test/widget/match_preview_tablet_test.dart
git commit -m "feat(tablet): match preview in two columns

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 8: The live match in landscape

Commentary left; your live shape on the pitch and the momentum bar in the centre; stats and line-ups (with live ratings) right; the control bar along the bottom. The screen's State, its clock and its pinned preview are untouched: the build computes the same pieces it always did and arranges them one of two ways.

**Files:**
- Create: `lib/features/match/match_tablet_layout.dart` (part of `match_screen.dart`)
- Modify: `lib/features/match/match_screen.dart`, `lib/features/shell/tablet_shell.dart`
- Test: `test/golden/phone_guard_match_test.dart`, `test/widget/match_tablet_test.dart`

**Interfaces:**
- Consumes: `useTabletLayout`; the state's `_liveFormation`, `_liveLineup`, `_liveInstructions`, `_injuredIds`, `_sentOffIds()`, `_playerPool(preview)`, `_liveEnergy(r)`, `_openTactics(preview)`, `_fullTime`; private `_TopBar`, `MatchScoreboard`, `_MomentumBar`, `_ShootoutStrip`, `_Timeline`, `MatchStatsPanel`, `_Lineups`, `_GoalFlash`, `HalfTimePrompt`, `MatchControlBar`; `TacticsPitch`, `KitColors.discFill`; `Panel`, `PanelBox`.
- Produces:
  - `MatchScreen.tabletLayoutKey` (static const Key)
  - `tabletReadyPaths` gains `Routes.match` (so the full-screen route is no longer phone-framed).

- [ ] **Step 1: Pin the phone match**

`test/golden/phone_guard_match_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/match/match_screen.dart';

import '../helpers/seeded_save.dart';

void main() {
  testWidgets('phone match at kick-off', (tester) async {
    final save = await seedSave(tester);
    // Warm the preview as the pre-match screen does, so the match opens on
    // it rather than on a spinner.
    final warm = save.container.listen(
      matchPreviewProvider(save.careerId),
      (_, _) {},
    );
    addTearDown(warm.close);
    await tester.runAsync(
      () => save.container.read(matchPreviewProvider(save.careerId).future),
    );
    await pumpRoute(tester, save, '${Routes.match}?careerId=${save.careerId}');
    expect(find.byType(MatchScoreboard), findsOneWidget);
    expect(find.byType(MatchDetailTabs), findsOneWidget);
    await expectAppGolden('goldens/match_phone.png');
    await tester.pumpWidget(const SizedBox());
  });
}
```

- [ ] **Step 2: Create the baseline, confirm it holds, commit it**

```bash
flutter test --update-goldens test/golden/phone_guard_match_test.dart
flutter test test/golden/phone_guard_match_test.dart
git add test/golden/phone_guard_match_test.dart test/golden/goldens/match_phone.png
git commit -m "test(tablet): pin the phone match screen

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

If the second run differs from the first, the clock moved between captures: the harness pumps a fixed number of frames, so look for a real-time source in the screen before touching the harness.

- [ ] **Step 3: Write the failing tablet test**

`test/widget/match_tablet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart';

import '../helpers/seeded_save.dart';

Future<SeededSave> _warm(WidgetTester tester, FormFactor f) async {
  final save = await seedSave(tester, formFactor: f);
  final warm = save.container.listen(
    matchPreviewProvider(save.careerId),
    (_, _) {},
  );
  addTearDown(warm.close);
  await tester.runAsync(
    () => save.container.read(matchPreviewProvider(save.careerId).future),
  );
  return save;
}

void main() {
  testWidgets('three columns and the control bar, full screen', (
    tester,
  ) async {
    final save = await _warm(tester, FormFactor.tablet);
    await pumpRoute(
      tester,
      save,
      '${Routes.match}?careerId=${save.careerId}',
      size: kTabletSize,
    );
    expect(tester.takeException(), isNull);
    expect(find.byKey(MatchScreen.tabletLayoutKey), findsOneWidget);
    expect(find.byType(FullScreenPhoneFrame), findsNothing);
    expect(find.byType(TacticsPitch), findsOneWidget);
    expect(find.byType(MatchStatsPanel), findsOneWidget);
    expect(find.byType(MatchControlBar), findsOneWidget);
    expect(find.byType(MatchDetailTabs), findsNothing);
    // Commentary left of the pitch, stats right of it.
    final pitch = tester.getCenter(find.byType(TacticsPitch));
    expect(
      tester.getCenter(find.text(enL.matchTabTimeline.toUpperCase())).dx,
      lessThan(pitch.dx),
    );
    expect(tester.getCenter(find.byType(MatchStatsPanel)).dx,
        greaterThan(pitch.dx));
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a phone build keeps the phone match even in a tablet-sized '
      'test window (Review Focus 5)', (tester) async {
    final save = await _warm(tester, FormFactor.phone);
    await pumpRoute(
      tester,
      save,
      '${Routes.match}?careerId=${save.careerId}',
      size: const Size(800, 600),
    );
    expect(find.byKey(MatchScreen.tabletLayoutKey), findsNothing);
    expect(find.byType(MatchDetailTabs), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}
```

- [ ] **Step 4: Run it to verify it fails**

Run: `flutter test test/widget/match_tablet_test.dart`
Expected: FAIL to compile (`MatchScreen.tabletLayoutKey`).

- [ ] **Step 5: Split the build into pieces, then into two layouts**

In `lib/features/match/match_screen.dart`:

1. Imports: change `import 'package:fnm/features/tactics/tactics_pitch.dart' show energyColor;` to `show energyColor, TacticsPitch;` and add `import 'package:fnm/core/layout/form_factor.dart';` and `import 'package:fnm/shared/tablet/tablet.dart';`. Add `part 'match_tablet_layout.dart';` after the two existing `part` lines.

2. Add to `MatchScreen`: `static const Key tabletLayoutKey = Key('match.tabletLayout');`

3. At the top of `_MatchScreenState.build`: `final tablet = useTabletLayout(context, ref);`

4. Inside `data:`, replace `return DefaultTabController(...)` (the whole expression down to its closing `);`) with the pieces, then the two arrangements. Every expression below is the one the phone tree already had, at the same position:

```dart
            final topBar = _TopBar(occasion: MatchStage.label(l, preview.fixture));
            final scoreboard = MatchScoreboard(
              homeCode: code(homeId),
              awayCode: code(awayId),
              homeName: name(homeId),
              awayName: name(awayId),
              // The manager's own side is rated off the XI actually on the
              // pitch, so the number moves with his changes; the opponent's
              // off the team they named.
              homeOverall: squadOverall(
                preview.playerIsHome ? _currentXi(preview) : preview.homeTeam.xi,
              ),
              awayOverall: squadOverall(
                preview.playerIsHome ? preview.awayTeam.xi : _currentXi(preview),
              ),
              homeScore: homeScore,
              awayScore: awayScore,
              clock: ft
                  ? (decidedByShootout
                        ? l.matchClockFullTimePenalties
                        : knockout != null
                        ? l.matchClockAfterExtraTime
                        : l.matchClockFullTime)
                  : showingShootout
                  ? l.matchClockPenalties
                  : inExtraTime
                  // No trailing apostrophe: it adds right-side width that
                  // pushes the digits left of the plate's centre. The bare
                  // number reads as the minute and sits dead-centre.
                  ? 'ET $_minute'
                  : inStoppage
                  ? '90+$_added'
                  : '$_minute',
              live: !ft,
            );
            // The two nations' own colours, pushed apart from each other when
            // the kits are too alike to tell which end of the bar is whose.
            final Widget? momentum = !ft && !showingShootout
                ? () {
                    final (homeC, awayC) = KitColors.opposed(
                      (
                        preview.nations[homeId]?.primaryColor ?? '',
                        preview.nations[homeId]?.secondaryColor ?? '',
                      ),
                      (
                        preview.nations[awayId]?.primaryColor ?? '',
                        preview.nations[awayId]?.secondaryColor ?? '',
                      ),
                    );
                    return _MomentumBar(
                      homePercent: _homeMomentum(preview, homeId),
                      homeCode: code(homeId),
                      awayCode: code(awayId),
                      homeColor: homeC,
                      awayColor: awayC,
                    );
                  }()
                : null;
            final Widget? shootout = showingShootout || decidedByShootout
                ? _ShootoutStrip(
                    outcome: knockout!,
                    homeCode: code(homeId),
                    awayCode: code(awayId),
                    revealed: showingShootout ? _penRevealed : _penTotal,
                    homeTakers: preview.playerIsHome
                        ? _takerNames(preview)
                        : const [],
                    awayTakers: preview.playerIsHome
                        ? const []
                        : _takerNames(preview),
                  )
                : null;
            final timeline = _Timeline(
              events: timelineEvents,
              live: !ft,
              homeId: homeId,
            );
            final stats = MatchStatsPanel(
              result: r,
              homeCode: code(homeId),
              awayCode: code(awayId),
              homeNationId: homeId,
              ground: preview.ground,
              neutral: preview.neutralVenue,
              groundCode: code(preview.ground.groundNationId),
              // Read as of the clock, exactly like the timeline beside it, so
              // the box score moves through the match instead of arriving
              // whole at the whistle.
              minute: _minute,
              fullTime: ft,
              events: timelineEvents,
            );
            List<MatchEvent> subsOf(int nationId) => shown
                .where(
                  (e) =>
                      e.type == MatchEventType.substitution &&
                      e.teamNationId == nationId,
                )
                .toList();
            final lineups = _Lineups(
              home: preview.playerIsHome
                  ? _currentXi(preview)
                  : preview.homeTeam.xi,
              away: preview.playerIsHome
                  ? preview.awayTeam.xi
                  : _currentXi(preview),
              homeCode: code(homeId),
              awayCode: code(awayId),
              homeSubs: subsOf(homeId),
              awaySubs: subsOf(awayId),
              homeBench: preview.playerIsHome
                  ? preview.bench
                  : preview.opponentBench,
              awayBench: preview.playerIsHome
                  ? preview.opponentBench
                  : preview.bench,
              ratings: ft
                  ? {for (final x in r.ratings) x.playerId: x.rating}
                  : const {},
              energy: _liveEnergy(r),
            );
            final overlays = <Widget>[
              if (_goalFlash != null)
                _GoalFlash(
                  event: _goalFlash!,
                  flagCode: code(_goalFlash!.teamNationId),
                ),
              // Half-time interval: play only resumes on Continue (the
              // manager may reshape the side first).
              if (_atHalfTime)
                HalfTimePrompt(
                  heading: l.matchHalfTime,
                  homeCode: code(homeId),
                  awayCode: code(awayId),
                  homeScore: homeScore,
                  awayScore: awayScore,
                  playerIsHome: preview.playerIsHome,
                  possession: preview.playerIsHome
                      ? r.homePossession
                      : 100 - r.homePossession,
                  subsUsed: _subsUsed(preview),
                  selectedTalk: _halfTimeTalk,
                  options: offeredTalkTones(
                    preview.saveSeed,
                    preview.fixture.id,
                  ),
                  onTalk: (tone) => _applyTeamTalk(preview, tone),
                  onTactics: () => _openTactics(preview),
                  onContinue: _resumeFromHalfTime,
                ),
              // The two extra-time intervals of a level knockout: the huddle
              // before the first period, and the turnaround at 105'.
              if (_atExtraTimeStart || _atExtraTimeHalf)
                HalfTimePrompt(
                  heading: _atExtraTimeStart
                      ? l.matchExtraTimeAhead
                      : l.matchExtraTimeHalf,
                  homeCode: code(homeId),
                  awayCode: code(awayId),
                  homeScore: homeScore,
                  awayScore: awayScore,
                  playerIsHome: preview.playerIsHome,
                  possession: preview.playerIsHome
                      ? r.homePossession
                      : 100 - r.homePossession,
                  subsUsed: _subsUsed(preview),
                  selectedTalk: _atExtraTimeStart
                      ? _extraTimeTalk
                      : _extraTimeHalfTalk,
                  // A different salt per interval, so the huddle and the
                  // turnaround don't offer the identical three lines.
                  options: offeredTalkTones(
                    preview.saveSeed,
                    preview.fixture.id ^ (_atExtraTimeStart ? 0x0E71 : 0x0E72),
                  ),
                  onTalk: (tone) => _applyExtraTimeTalk(
                    preview,
                    tone,
                    atStart: _atExtraTimeStart,
                  ),
                  onTactics: () => _openTactics(preview),
                  onContinue: _resumeFromExtraTimeBreak,
                ),
            ];

            if (tablet) {
              return _MatchTabletLayout(
                ft: ft,
                topBar: topBar,
                scoreboard: scoreboard,
                momentum: momentum,
                shootout: shootout,
                timeline: timeline,
                stats: stats,
                lineups: lineups,
                pitch: _livePitch(preview, r),
                overlays: overlays,
              );
            }
            return DefaultTabController(
              length: 3,
              // Jump to the Stats tab (player ratings, MOTM) at full time; the
              // key recreates the controller so the switch takes effect.
              initialIndex: ft ? 1 : 0,
              key: ValueKey(ft),
              child: SafeArea(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        topBar,
                        scoreboard,
                        ?momentum,
                        ?shootout,
                        const MatchDetailTabs(),
                        Expanded(
                          child: TabBarView(
                            children: [timeline, stats, lineups],
                          ),
                        ),
                      ],
                    ),
                    ...overlays,
                  ],
                ),
              ),
            );
```

These are the existing tree's expressions, argument for argument (the two `homeSubs`/`awaySubs` filters become one local function returning the same lists). The phone draws the same widgets in the same order, which the golden checks. `MatchEvent` and `MatchEventType` are already imported (`match_engine.dart`).

5. Add to `_MatchScreenState`:

```dart
  /// The manager's side as it stands on the pitch right now, with each man's
  /// energy: the centre of the tablet match. Read only; a tap anywhere on it
  /// opens the tactics editor, where changes are made.
  Widget _livePitch(MatchPreview preview, MatchResult r) {
    final byId = {for (final p in _playerPool(preview)) p.id: p};
    final n = preview.nations[preview.playerNationId];
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _fullTime ? null : () => _openTactics(preview),
      child: IgnorePointer(
        child: Center(
          child: AspectRatio(
            aspectRatio: 3 / 4,
            child: TacticsPitch(
              formation: _liveFormation,
              instructions: _liveInstructions,
              lineup: _liveLineup,
              byId: byId,
              teamColors: n == null
                  ? null
                  : KitColors.discFill(n.primaryColor, n.secondaryColor),
              energyByPlayer: _liveEnergy(r),
              absentIds: {..._injuredIds, ..._sentOffIds()},
              injuredIds: _injuredIds,
              onTapSlot: (_) {},
              onSwap: (_, _) {},
              onBenchIn: (_, _) {},
            ),
          ),
        ),
      ),
    );
  }
```

6. In `bottomNavigationBar`, keep `bar` as it is and change the `SafeArea` child so the tablet bar does not stretch its controls across 1194 points:

```dart
              child: SafeArea(
                top: false,
                child: tablet
                    ? Center(
                        heightFactor: 1,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 760),
                          child: bar,
                        ),
                      )
                    : bar,
              ),
```

- [ ] **Step 6: The tablet layout**

`lib/features/match/match_tablet_layout.dart`:

```dart
part of 'match_screen.dart';

/// The live match on a tablet, landscape: commentary, your shape and the
/// momentum, then stats and line-ups. The same widgets the phone shows in
/// three tabs, all on screen at once. Overlays (goal, intervals) sit on top
/// exactly as on the phone.
class _MatchTabletLayout extends StatelessWidget {
  const _MatchTabletLayout({
    required this.ft,
    required this.topBar,
    required this.scoreboard,
    required this.momentum,
    required this.shootout,
    required this.timeline,
    required this.stats,
    required this.lineups,
    required this.pitch,
    required this.overlays,
  });

  static const double _commentaryWidth = 320;
  static const double _sideWidth = 340;

  final bool ft;
  final Widget topBar;
  final Widget scoreboard;
  final Widget? momentum;
  final Widget? shootout;
  final Widget timeline;
  final Widget stats;
  final Widget lineups;
  final Widget pitch;
  final List<Widget> overlays;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SafeArea(
      key: MatchScreen.tabletLayoutKey,
      child: Stack(
        children: [
          Column(
            children: [
              topBar,
              scoreboard,
              ?shootout,
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.sm,
                    AppSpacing.md,
                    AppSpacing.sm,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        width: _commentaryWidth,
                        child: Panel(
                          title: l.matchTabTimeline,
                          expand: true,
                          padding: EdgeInsets.zero,
                          child: timeline,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md - 4),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Panel(
                                title: l.matchYourXi,
                                expand: true,
                                padding: const EdgeInsets.all(AppSpacing.sm),
                                child: pitch,
                              ),
                            ),
                            if (momentum != null) ...[
                              const SizedBox(height: AppSpacing.sm),
                              Panel(
                                title: l.matchMomentum,
                                padding: EdgeInsets.zero,
                                child: momentum!,
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md - 4),
                      SizedBox(
                        width: _sideWidth,
                        child: PanelBox(
                          child: DefaultTabController(
                            length: 2,
                            // Recreated at the whistle, like the phone's.
                            key: ValueKey(ft),
                            child: Column(
                              children: [
                                Material(
                                  color: AppColors.surfaceContainer,
                                  child: TabBar(
                                    labelColor: AppColors.onSurface,
                                    unselectedLabelColor:
                                        AppColors.onSurfaceVariant,
                                    indicatorColor: AppColors.primary,
                                    tabs: [
                                      Tab(text: l.matchTabStats),
                                      Tab(text: l.matchTabLineups),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: TabBarView(
                                    children: [stats, lineups],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          ...overlays,
        ],
      ),
    );
  }
}
```

`_MomentumBar` already draws its own labels; inside the panel it keeps them. If it brings its own outer margin, leave it: the panel's zero padding is deliberate.

- [ ] **Step 7: Register, run, expect PASS**

```dart
const Set<String> tabletReadyPaths = <String>{
  Routes.hub,
  Routes.callUps,
  Routes.matchPreview,
  Routes.match,
};
```

Run: `flutter test test/widget/match_tablet_test.dart test/golden/phone_guard_match_test.dart test/widget/match_layout_fit_test.dart test/widget/match_stats_live_test.dart test/widget/match_control_bar_test.dart test/widget/match_screen_keeps_its_own_fixture_test.dart test/widget/match_skip_shootout_test.dart test/widget/scoreboard_no_rating_test.dart test/unit/core/routing/tablet_router_test.dart`
Expected: PASS; phone golden unchanged.

- [ ] **Step 8: Analyze, full suite, commit**

```bash
flutter analyze && flutter test
git add lib/features/match/match_screen.dart lib/features/match/match_tablet_layout.dart lib/features/shell/tablet_shell.dart test/widget/match_tablet_test.dart
git commit -m "feat(tablet): live match in landscape

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 9: In-match tactics editor in landscape

The editor is a full-screen page pushed over the match. On a tablet its pitch sits on the left at full height and the substitution lists and instructions sit on the right, so a substitution never scrolls the pitch away ("subs open alongside the pitch").

**Files:**
- Create: `test/helpers/in_match_editor.dart`
- Modify: `lib/features/tactics/in_match_tactics.dart`, `lib/features/match/match_screen.dart`
- Test: `test/golden/phone_guard_in_match_tactics_test.dart`, `test/widget/in_match_tactics_tablet_test.dart`

**Interfaces:**
- Consumes: `useTabletLayout` (match screen); the editor state's `_formation`, `_instructions`, `_lineup`, `_byId`, `_dead`, `_pickPlayer`, `_swap`, `_reshapeKeeping`, `_setSlot`, `_setFormation`, `_suitable`, `_otherPlaces`, `_onPitchPlayers`, `_tacticsTab()`.
- Produces:
  - `showInMatchTactics(..., bool tabletLayout = false)` (new last named parameter; the default keeps today's page)
  - `abstract final class InMatchTacticsKeys { static const Key tabletLayout; }`
  - private `Widget _pitchView()`, `Widget _lineupLists({required List<Player> onPitch, required List<Player> available, required List<Player> unavailable, required Player? comingOff})`, `Widget _tabletBody({...same...})` on the editor state.
  - test helper `Future<void> openEditor(WidgetTester tester, {required Size size, bool tabletLayout = false})` (the `tabletLayout` parameter is added in Step 5).

- [ ] **Step 1: The editor harness and the phone guard**

`test/helpers/in_match_editor.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/features/tactics/in_match_tactics.dart';
import 'package:fnm/l10n/app_localizations.dart';

import 'fixtures.dart';
import 'seeded_save.dart';

/// Eleven starters (1..11) in a 4-4-2 and five on the bench (12..16, 16 a
/// keeper).
List<Player> editorSquad() => [
  for (var i = 0; i < 11; i++)
    player(
      id: i + 1,
      nationId: 1,
      name: 'Starter${i + 1}',
      position: Formation.f442.positions[i],
    ),
  for (var i = 12; i <= 16; i++)
    player(
      id: i,
      nationId: 1,
      name: 'Bench$i',
      position: i == 16 ? PlayerPosition.gk : PlayerPosition.cm,
    ),
];

/// Opens the real editor over a launcher at 70', as the match screen does.
///
/// Both the view and the surface are sized: the view decides MediaQuery (and
/// so whether the window is tablet sized), the surface what a pushed route is
/// laid out in.
Future<void> openEditor(WidgetTester tester, {required Size size}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));
  final players = editorSquad();
  await tester.pumpWidget(
    RepaintBoundary(
      key: kAppRoot,
      child: ProviderScope(
        child: MaterialApp(
          theme: AppTheme.theme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (inner) => Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: () => showInMatchTactics(
                    inner,
                    minute: 70,
                    formation: Formation.f442,
                    lineup: [for (var i = 1; i <= 11; i++) i],
                    instructions: const TacticalInstructions(),
                    pool: players,
                    startingIds: {for (var i = 1; i <= 11; i++) i},
                    maxSubs: 5,
                  ),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}
```

`test/golden/phone_guard_in_match_tactics_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/in_match_editor.dart';
import '../helpers/seeded_save.dart';

void main() {
  testWidgets('phone in-match editor', (tester) async {
    await openEditor(tester, size: kPhoneSize);
    expect(find.byType(TabBar), findsOneWidget);
    await expectAppGolden('goldens/in_match_tactics_phone.png');
  });
}
```

- [ ] **Step 2: Create the baseline, confirm it holds, commit it**

```bash
flutter test --update-goldens test/golden/phone_guard_in_match_tactics_test.dart
flutter test test/golden/phone_guard_in_match_tactics_test.dart
git add test/helpers/in_match_editor.dart test/golden/phone_guard_in_match_tactics_test.dart test/golden/goldens/in_match_tactics_phone.png
git commit -m "test(tablet): pin the phone in-match tactics editor

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

- [ ] **Step 3: Write the failing tablet test**

`test/widget/in_match_tactics_tablet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/tactics/in_match_tactics.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart';

import '../helpers/in_match_editor.dart';
import '../helpers/seeded_save.dart';

void main() {
  testWidgets('pitch left, substitutions right, both on screen', (
    tester,
  ) async {
    await openEditor(tester, size: kTabletSize, tabletLayout: true);
    expect(tester.takeException(), isNull);
    expect(find.byKey(InMatchTacticsKeys.tabletLayout), findsOneWidget);
    final pitch = tester.getRect(find.byType(TacticsPitch));
    final suitable = tester.getRect(find.text(enL.tacticsTabSuitable));
    expect(pitch.right, lessThanOrEqualTo(suitable.left));
    expect(pitch.bottom, lessThanOrEqualTo(kTabletSize.height));
    expect(find.text('Bench12'), findsOneWidget, reason: 'subs on screen');
  });

  testWidgets('without the flag the editor keeps its phone body (Review '
      'Focus 5)', (tester) async {
    await openEditor(tester, size: const Size(800, 600));
    expect(find.byKey(InMatchTacticsKeys.tabletLayout), findsNothing);
  });
}
```

- [ ] **Step 4: Run it to verify it fails**

Run: `flutter test test/widget/in_match_tactics_tablet_test.dart`
Expected: FAIL to compile (`InMatchTacticsKeys`, `tabletLayout:`).

- [ ] **Step 5: Split the lineup tab, add the landscape body**

In `lib/features/tactics/in_match_tactics.dart` (add `import 'dart:math' as math;` and `import 'package:fnm/core/layout/form_factor.dart';` if missing):

1. Add:

```dart
abstract final class InMatchTacticsKeys {
  static const Key tabletLayout = Key('inMatchTactics.tabletLayout');
}
```

2. `showInMatchTactics` gains a last named parameter `bool tabletLayout = false,` and passes `tabletLayout: tabletLayout` to `_InMatchTacticsEditor`, which gains `this.tabletLayout = false,` and:

```dart
  /// Lay out for a landscape tablet: pitch left, lists right. Set by the
  /// match screen from useTabletLayout; false everywhere else, so phones and
  /// tests keep the tabbed page.
  final bool tabletLayout;
```

3. Split `_lineupTab`. The pitch, with the arguments it has today:

```dart
  /// The pitch, with every gesture the lineup tab has always had.
  Widget _pitchView() => TacticsPitch(
    formation: _formation,
    instructions: _instructions,
    lineup: _lineup,
    byId: _byId,
    teamColors: widget.teamColors,
    energyByPlayer: widget.energyByPlayer,
    // Mark the hurt players absent AND injured so their node renders the
    // orange "injured, replace" flag, exactly like a pre-match injury.
    absentIds: widget.injuredIds,
    injuredIds: widget.injuredIds,
    // The holes a red card left, drawn as holes rather than as spaces
    // waiting to be filled.
    deadSlots: _dead,
    onTapSlot: _pickPlayer,
    onSwap: (a, b) {
      switch (resolveDrag(_formation, a, b)) {
        case SwapSlots():
          _swap(a, b);
        case ReshapeTo(:final formation):
          _reshapeKeeping(formation, a, b);
      }
    },
    onBenchIn: _setSlot,
    onMoveToSpace: (slot, dropY) {
      final outcome = resolveSpaceDrag(_formation, _instructions, slot, dropY);
      // Through _setFormation, which refits the players already on the
      // pitch: assigning _formation directly would scramble the side
      // mid-match.
      if (outcome case ReshapeTo(:final formation)) {
        _setFormation(formation);
      }
    },
  );
```

The lists: a new method `_lineupLists` with the same four parameters as `_lineupTab`. It starts with the three locals `_lineupTab` computes today (`final suitable = _suitable(available); final other = _otherPlaces(available); final l = AppLocalizations.of(context);`) and returns the second child of `_lineupTab`'s `ListView`: the `Padding(padding: const EdgeInsets.all(AppSpacing.marginMobile), child: Column(...))`, cut and pasted whole, comments included. `_lineupTab` is then:

```dart
  Widget _lineupTab({
    required List<Player> onPitch,
    required List<Player> available,
    required List<Player> unavailable,
    required Player? comingOff,
  }) {
    return ListView(
      children: [
        // The formation picker lives on the Tactics tab and nowhere else. It
        // used to be repeated here, above the pitch, so the same row of shape
        // chips appeared twice in one sheet: two controls for one setting,
        // which reads as a bug whichever one you touch.
        AspectRatio(aspectRatio: 3 / 4, child: _pitchView()),
        _lineupLists(
          onPitch: onPitch,
          available: available,
          unavailable: unavailable,
          comingOff: comingOff,
        ),
      ],
    );
  }
```

4. Add the landscape body:

```dart
  /// The editor on a tablet: the pitch at full height on the left, the lists
  /// and the instructions as two tabs on the right.
  Widget _tabletBody({
    required List<Player> onPitch,
    required List<Player> available,
    required List<Player> unavailable,
    required Player? comingOff,
  }) {
    final l = AppLocalizations.of(context);
    final size = MediaQuery.sizeOf(context);
    final height =
        size.height -
        kToolbarHeight -
        MediaQuery.paddingOf(context).vertical -
        2 * AppSpacing.md;
    final pitchWidth = math.min(height * 3 / 4, size.width * 0.45);
    return Row(
      key: InMatchTacticsKeys.tabletLayout,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: pitchWidth + 2 * AppSpacing.md,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Center(
              child: AspectRatio(aspectRatio: 3 / 4, child: _pitchView()),
            ),
          ),
        ),
        const VerticalDivider(width: 1, color: AppColors.outlineVariant),
        Expanded(
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TabBar(
                  labelColor: AppColors.onSurface,
                  unselectedLabelColor: AppColors.onSurfaceVariant,
                  indicatorColor: AppColors.primary,
                  tabs: [
                    Tab(text: l.tacticsTabLineupSubs),
                    Tab(text: l.tacticsTabTactics),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      ListView(
                        children: [
                          _lineupLists(
                            onPitch: onPitch,
                            available: available,
                            unavailable: unavailable,
                            comingOff: comingOff,
                          ),
                        ],
                      ),
                      _tacticsTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
```

5. In `build`, the `Scaffold`'s `body:` becomes:

```dart
      body: widget.tabletLayout && context.isTabletWindow
          ? _tabletBody(
              onPitch: _onPitchPlayers,
              available: available,
              unavailable: unavailable,
              comingOff: coming,
            )
          : DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    labelColor: AppColors.onSurface,
                    unselectedLabelColor: AppColors.onSurfaceVariant,
                    indicatorColor: AppColors.primary,
                    tabs: [
                      Tab(text: l.tacticsTabLineupSubs),
                      Tab(text: l.tacticsTabTactics),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _lineupTab(
                          onPitch: _onPitchPlayers,
                          available: available,
                          unavailable: unavailable,
                          comingOff: coming,
                        ),
                        _tacticsTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
```

(The phone branch is today's `body:` value as it stands.)

6. In `lib/features/match/match_screen.dart`, `_openTactics` passes `tabletLayout: useTabletLayout(context, ref),` to `showInMatchTactics`.

7. In `test/helpers/in_match_editor.dart`, `openEditor` gains `bool tabletLayout = false,` and passes `tabletLayout: tabletLayout,` to `showInMatchTactics`. The guard calls it without the flag, so its picture is unchanged.

- [ ] **Step 6: Run, expect PASS**

Run: `flutter test test/widget/in_match_tactics_tablet_test.dart test/golden/phone_guard_in_match_tactics_test.dart test/widget/in_match_other_places_test.dart test/widget/in_match_red_card_test.dart test/widget/in_match_sub_sections_test.dart test/widget/in_match_sub_undo_test.dart test/widget/tactics_pitch_test.dart`
Expected: PASS; phone golden unchanged; the existing in-match tests (default 800 x 600 window, no flag) keep the tabbed page.

- [ ] **Step 7: Analyze, full suite, commit**

```bash
flutter analyze && flutter test
git add lib/features/tactics/in_match_tactics.dart lib/features/match/match_screen.dart test/helpers/in_match_editor.dart test/widget/in_match_tactics_tablet_test.dart
git commit -m "feat(tablet): in-match tactics editor in landscape, subs beside the pitch

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---
### Task 10: Round results beside standings

After a group-stage match: each group as a panel with that matchday's scores on the left and the table on the right, two groups to a row. Knockout rounds are one centred list; a friendly window shows the other nations' friendlies. Continue sits top right. The loop is now playable: hub, call-ups, preview, match, results.

**Files:**
- Create: `lib/features/results/round_results_tablet_layout.dart` (part of `round_results_screen.dart`)
- Modify: `lib/features/results/round_results_screen.dart`, `lib/features/shell/tablet_shell.dart`
- Test: `test/golden/phone_guard_round_results_test.dart`, `test/widget/round_results_tablet_test.dart`, `test/helpers/round_results_fixture.dart`

**Interfaces:**
- Consumes: `RoundResults`, `RoundResultGroup` (competition_repository.dart); `GroupStanding`; `otherFriendliesProvider`; `MatchResultRow`; private `_StandingRow`, `_FriendlyRow`; `Panel`, `TabletShellScope`, `TabletText`.
- Produces:
  - `typedef RoundResultsView` and `final roundResultsViewProvider` (renamed from `_RoundView` / `_roundResultsProvider`, made public so tests can override them)
  - `RoundResultsScreen.tabletLayoutKey` (static const Key)
  - `tabletReadyPaths` gains `Routes.roundResults`.

- [ ] **Step 1: Make the view provider public (a rename, no UI change)**

In `lib/features/results/round_results_screen.dart`, rename `_RoundView` to `RoundResultsView` and `_roundResultsProvider` to `roundResultsViewProvider` (declaration and the one `ref.watch`). Doc comment on the provider: `/// The last round the manager played, grouped, with the zones each table colours. Public so a test can hand the screen a round without playing one.`

- [ ] **Step 2: A round to show, and the phone guard**

`test/helpers/round_results_fixture.dart`:

```dart
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/features/results/round_results_screen.dart';

import 'fixtures.dart';

/// Four groups of four (nations 1..16), matchday 3, the manager's nation 1.
RoundResultsView fourGroupsView() {
  final groups = [
    for (var g = 0; g < 4; g++)
      (
        name: String.fromCharCode(65 + g),
        standings: [
          for (var i = 0; i < 4; i++)
            GroupStanding(g * 4 + i + 1)
              ..played = 3
              ..won = 3 - i
              ..lost = i,
        ],
        fixtures: [
          Fixture(
            id: g * 10 + 1,
            careerId: 1,
            competitionId: 1,
            matchday: 3,
            date: DateTime(2027, 9, 10),
            homeNationId: g * 4 + 1,
            awayNationId: g * 4 + 2,
            homeScore: 2,
            awayScore: 1,
            played: true,
          ),
          Fixture(
            id: g * 10 + 2,
            careerId: 1,
            competitionId: 1,
            matchday: 3,
            date: DateTime(2027, 9, 10),
            homeNationId: g * 4 + 3,
            awayNationId: g * 4 + 4,
            homeScore: 0,
            awayScore: 0,
            played: true,
          ),
        ],
      ),
  ];
  return (
    results: (
      competition: 'European Championship Qualifiers',
      kind: CompetitionKind.continentalQualifying,
      groupCount: 4,
      matchday: 3,
      groups: groups,
      stage: null,
      knockoutFixtures: const <Fixture>[],
    ),
    nations: {for (var i = 1; i <= 16; i++) i: nation(id: i)},
    playerNationId: 1,
    directCount: 2,
    contentionPos: 3,
    relegateCount: 0,
    noRelegationGroups: const <String>{},
  );
}
```

`test/golden/phone_guard_round_results_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/friendlies/other_friendlies_providers.dart';
import 'package:fnm/features/results/round_results_screen.dart';

import '../helpers/pump_app.dart';
import '../helpers/round_results_fixture.dart';
import '../helpers/seeded_save.dart';

void main() {
  testWidgets('phone round results', (tester) async {
    tester.view.physicalSize = kPhoneSize;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpApp(
      const RepaintBoundary(
        key: kAppRoot,
        child: RoundResultsScreen(careerId: 1),
      ),
      overrides: [
        roundResultsViewProvider(1).overrideWith((ref) async => fourGroupsView()),
        otherFriendliesProvider(1).overrideWith((ref) async => const []),
      ],
    );
    await tester.pumpAndSettle();
    expect(find.text(enL.resultsGroup('A')), findsOneWidget);
    await expectAppGolden('goldens/round_results_phone.png');
  });
}
```

- [ ] **Step 3: Create the baseline, confirm it holds, commit rename and guard**

```bash
flutter test --update-goldens test/golden/phone_guard_round_results_test.dart
flutter test test/golden/phone_guard_round_results_test.dart test/widget/tablet_route_sweep_test.dart
git add lib/features/results/round_results_screen.dart test/helpers/round_results_fixture.dart test/golden/phone_guard_round_results_test.dart test/golden/goldens/round_results_phone.png
git commit -m "test(tablet): pin the phone round results

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

- [ ] **Step 4: Write the failing tablet test**

`test/widget/round_results_tablet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/friendlies/other_friendlies_providers.dart';
import 'package:fnm/features/results/round_results_screen.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/pump_app.dart';
import '../helpers/round_results_fixture.dart';
import '../helpers/seeded_save.dart';

void main() {
  testWidgets('each group: scores beside the table, two groups a row', (
    tester,
  ) async {
    tester.view.physicalSize = kTabletSize;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpApp(
      const TabletShellScope(child: RoundResultsScreen(careerId: 1)),
      overrides: [
        roundResultsViewProvider(1).overrideWith((ref) async => fourGroupsView()),
        otherFriendliesProvider(1).overrideWith((ref) async => const []),
      ],
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byKey(RoundResultsScreen.tabletLayoutKey), findsOneWidget);
    expect(find.byType(MatchResultRow), findsNWidgets(8));

    final a = tester.getRect(find.text(enL.resultsGroup('A').toUpperCase()));
    final b = tester.getRect(find.text(enL.resultsGroup('B').toUpperCase()));
    final c = tester.getRect(find.text(enL.resultsGroup('C').toUpperCase()));
    expect(a.top, b.top, reason: 'A and B share a row');
    expect(c.top, greaterThan(a.bottom));

    // In group A the scores sit left of the table.
    final score = tester.getCenter(find.byType(MatchResultRow).first);
    final tableRow = tester.getCenter(find.text('Nation 3').first);
    expect(score.dx, lessThan(tableRow.dx));
    expect(find.text(enL.resultsContinue), findsOneWidget);
  });
}
```

- [ ] **Step 5: Run it to verify it fails**

Run: `flutter test test/widget/round_results_tablet_test.dart`
Expected: FAIL to compile (`RoundResultsScreen.tabletLayoutKey`).

- [ ] **Step 6: Hook in and write the layout**

In `round_results_screen.dart`: add `import 'package:fnm/shared/tablet/tablet.dart';`, `part 'round_results_tablet_layout.dart';`, `static const Key tabletLayoutKey = Key('roundResults.tabletLayout');` on `RoundResultsScreen`, and as the first line of its `build` after `final l = ...`:

```dart
    if (TabletShellScope.isActive(context)) {
      return _RoundResultsTabletLayout(careerId: careerId);
    }
```

`lib/features/results/round_results_tablet_layout.dart`:

```dart
part of 'round_results_screen.dart';

/// Round results on a tablet: every group as one panel, scores beside the
/// table, two to a row. Same provider and rows as the phone.
class _RoundResultsTabletLayout extends ConsumerWidget {
  const _RoundResultsTabletLayout({required this.careerId});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final viewAsync = ref.watch(roundResultsViewProvider(careerId));
    final friendlies =
        ref.watch(otherFriendliesProvider(careerId)).valueOrNull ?? const [];
    return Scaffold(
      key: RoundResultsScreen.tabletLayoutKey,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l.resultsRoundResults,
                    style: TabletText.screenTitle,
                  ),
                ),
                SizedBox(
                  width: 220,
                  child: PrimaryButton(
                    label: l.resultsContinue,
                    icon: Icons.check_rounded,
                    height: 44,
                    onPressed: () =>
                        context.go('${Routes.hub}?careerId=$careerId'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: viewAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) =>
                    Center(child: Text(l.resultsCouldNotLoad(e.toString()))),
                data: (view) => _body(context, l, view, friendlies),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _body(
    BuildContext context,
    AppLocalizations l,
    RoundResultsView? view,
    List<FriendlyResult> friendlies,
  ) {
    final results = view?.results;
    final hasContent =
        results != null &&
        (results.groups.isNotEmpty || results.knockoutFixtures.isNotEmpty);
    if (view == null || results == null || !hasContent) {
      if (view == null || friendlies.isEmpty) return const SizedBox.shrink();
      String code(int id) => view.nations[id]?.code ?? '??';
      String name(int id) => view.nations[id]?.name ?? '';
      return Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: SingleChildScrollView(
            child: Panel(
              title: l.resultsFriendlyInternationals,
              child: Column(
                children: [
                  for (final f in friendlies)
                    _FriendlyRow(result: f, code: code, name: name),
                ],
              ),
            ),
          ),
        ),
      );
    }
    String code(int id) => view.nations[id]?.code ?? '??';
    String name(int id) => view.nations[id]?.name ?? '';
    final heading = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          competitionLabel(l, results.competition).toUpperCase(),
          style: TabletText.panelTitle.copyWith(color: AppColors.primary),
        ),
        Text(
          results.knockoutFixtures.isNotEmpty
              ? (results.stage ?? l.resultsKnockout).toUpperCase()
              : l.resultsMatchday(results.matchday),
          style: AppTypography.headlineMedium,
        ),
        const SizedBox(height: AppSpacing.md),
      ],
    );
    if (results.knockoutFixtures.isNotEmpty) {
      return Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: ListView(
            children: [
              heading,
              PanelBox(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      for (final f in results.knockoutFixtures)
                        MatchResultRow(
                          fixture: f,
                          code: code,
                          emphasiseNationId: view.playerNationId,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    final groups = results.groups;
    Widget panel(RoundResultGroup g) => _GroupResultsPanel(
      group: g,
      view: view,
      code: code,
      name: name,
    );
    return ListView(
      children: [
        heading,
        for (var i = 0; i < groups.length; i += 2)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md - 4),
            // Plain Columns and Rows inside: IntrinsicHeight can measure them.
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: panel(groups[i])),
                  const SizedBox(width: AppSpacing.md - 4),
                  Expanded(
                    child: i + 1 < groups.length
                        ? panel(groups[i + 1])
                        : const SizedBox(),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// One group: this matchday's scores on the left, the table on the right.
class _GroupResultsPanel extends StatelessWidget {
  const _GroupResultsPanel({
    required this.group,
    required this.view,
    required this.code,
    required this.name,
  });

  final RoundResultGroup group;
  final RoundResultsView view;
  final String Function(int) code;
  final String Function(int) name;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final relegateCount = view.noRelegationGroups.contains(group.name)
        ? 0
        : view.relegateCount;
    return Panel(
      title: l.resultsGroup(group.name),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                for (final f in group.fixtures)
                  MatchResultRow(
                    fixture: f,
                    code: code,
                    emphasiseNationId: view.playerNationId,
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              children: [
                for (var i = 0; i < group.standings.length; i++)
                  _StandingRow(
                    pos: i + 1,
                    standing: group.standings[i],
                    isPlayer:
                        group.standings[i].nationId == view.playerNationId,
                    directCount: view.directCount,
                    contentionPos: view.contentionPos,
                    relegated:
                        relegateCount > 0 &&
                        i + 1 > group.standings.length - relegateCount,
                    name: name,
                    code: code,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 7: Register, run, expect PASS**

Add `Routes.roundResults` to `tabletReadyPaths`.

Run: `flutter test test/widget/round_results_tablet_test.dart test/golden/phone_guard_round_results_test.dart test/widget/match_result_row_test.dart test/widget/tablet_route_sweep_test.dart`
Expected: PASS; phone golden unchanged.

- [ ] **Step 8: Analyze, full suite, commit**

```bash
flutter analyze && flutter test
git add lib/features/results/round_results_screen.dart lib/features/results/round_results_tablet_layout.dart lib/features/shell/tablet_shell.dart test/widget/round_results_tablet_test.dart
git commit -m "feat(tablet): round results beside standings

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 11: Inbox as master and detail

A filterable list on the left (All, Board, Competitions, Squad) and the open message on the right, rendered by the same `MessageSheet` the phone pops up (so squad development, transfer and award reports keep their tables and cards). Opening the screen still marks everything read, once, as on the phone.

**Files:**
- Create: `lib/features/messages/messages_tablet_layout.dart` (part of `messages_screen.dart`)
- Modify: `lib/features/messages/messages_screen.dart`, `lib/features/shell/tablet_shell.dart`
- Test: `test/golden/phone_guard_messages_test.dart`, `test/widget/messages_tablet_test.dart`, `test/unit/messages/inbox_filter_test.dart`

**Interfaces:**
- Consumes: `messageInboxProvider`, `MessageInbox`, `MessageItem`; `MessageSheet`, `messageStyle`; `readMessage`; `MasterDetail`, `MasterDetailPlaceholder`, `TabletShellScope`, `TabletText`.
- Produces:
  - `enum InboxFilter { all, board, competitions, squad }`
  - `InboxFilter? inboxGroupOf(String category)` (null: shown under All only)
  - `MessagesScreen.tabletLayoutKey`, and row keys `ValueKey('inbox.row.<id>')`
  - private state on `_MessagesScreenState`: `InboxFilter _filter`, `int? _openId`
  - `tabletReadyPaths` gains `Routes.messages`.

- [ ] **Step 1: Pin the phone inbox**

`test/golden/phone_guard_messages_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/messages/messages_screen.dart';

import '../helpers/seeded_save.dart';

void main() {
  testWidgets('phone inbox', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.messages}?careerId=${save.careerId}',
    );
    expect(find.byType(MessagesScreen), findsOneWidget);
    await expectAppGolden('goldens/messages_phone.png');
  });
}
```

- [ ] **Step 2: Create the baseline, confirm it holds, commit it**

```bash
flutter test --update-goldens test/golden/phone_guard_messages_test.dart
flutter test test/golden/phone_guard_messages_test.dart
git add test/golden/phone_guard_messages_test.dart test/golden/goldens/messages_phone.png
git commit -m "test(tablet): pin the phone inbox

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

Open the PNG: it must show message cards (the seeded save files cycle and draw news), not "No messages yet".

- [ ] **Step 3: Write the failing tests**

`test/unit/messages/inbox_filter_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/messages/messages_screen.dart';

void main() {
  test('every message category the inbox files has a group', () {
    expect(inboxGroupOf('board'), InboxFilter.board);
    expect(inboxGroupOf('cycle'), InboxFilter.board);
    for (final c in [
      'draw',
      'qualify',
      'eliminated',
      'champion',
      'triumph',
      'ranking',
    ]) {
      expect(inboxGroupOf(c), InboxFilter.competitions, reason: c);
    }
    for (final c in [
      'aging',
      'youth',
      'injury',
      'discipline',
      'retirement',
      'milestone',
      'award',
      'halloffame',
      'naturalize',
      'transfer',
      'record',
    ]) {
      expect(inboxGroupOf(c), InboxFilter.squad, reason: c);
    }
  });

  test('an unknown category is shown under All only', () {
    expect(inboxGroupOf('something-new'), isNull);
  });
}
```

`test/widget/messages_tablet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/util/message_text.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/features/messages/message_providers.dart';
import 'package:fnm/features/messages/message_sheet.dart';
import 'package:fnm/features/messages/messages_screen.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/seeded_save.dart';

void main() {
  testWidgets('list left, the open message right; a tap opens another', (
    tester,
  ) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    late List<MessageItem> messages;
    await tester.runAsync(() async {
      messages = (await save.container.read(
        messageInboxProvider(save.careerId).future,
      )).messages;
    });
    expect(messages.length, greaterThanOrEqualTo(2));

    await pumpRoute(
      tester,
      save,
      '${Routes.messages}?careerId=${save.careerId}',
      size: kTabletSize,
    );
    expect(tester.takeException(), isNull);
    expect(find.byKey(MessagesScreen.tabletLayoutKey), findsOneWidget);
    expect(find.byType(MasterDetail), findsOneWidget);
    // The newest is open by default.
    final first = readMessage(enL, messages.first).title;
    expect(
      find.descendant(
        of: find.byType(MessageSheet),
        matching: find.text(first),
      ),
      findsOneWidget,
    );

    final second = messages[1];
    await tester.tap(find.byKey(ValueKey('inbox.row.${second.id}')));
    await settle(tester);
    expect(
      find.descendant(
        of: find.byType(MessageSheet),
        matching: find.text(readMessage(enL, second).title),
      ),
      findsOneWidget,
    );

    // A filter keeps only its own group in the list.
    await tester.tap(find.text(enL.sideGroupCompetitions));
    await settle(tester);
    for (final m in messages) {
      final row = find.byKey(ValueKey('inbox.row.${m.id}'));
      final shown = row.evaluate().isNotEmpty;
      expect(
        shown,
        inboxGroupOf(m.category) == InboxFilter.competitions,
        reason: '${m.category} ${m.id}',
      );
    }
    await tester.pumpWidget(const SizedBox());
  });
}
```

(The list is short on a new save, so every row is built; if it ever grows past one screen, scroll before asserting.)

- [ ] **Step 4: Run them to verify they fail**

Run: `flutter test test/unit/messages/inbox_filter_test.dart test/widget/messages_tablet_test.dart`
Expected: FAIL to compile (`InboxFilter`, `MessagesScreen.tabletLayoutKey`).

- [ ] **Step 5: Hook in and write the layout**

In `messages_screen.dart`: add `import 'package:fnm/shared/tablet/tablet.dart';`, `part 'messages_tablet_layout.dart';`, `static const Key tabletLayoutKey = Key('messages.tabletLayout');` on `MessagesScreen`, and on `_MessagesScreenState`:

```dart
  /// The tablet list's filter and the message open beside it. Null: the
  /// newest in the current filter.
  InboxFilter _filter = InboxFilter.all;
  int? _openId;
```

In `build`, after the mark-read block and before `return Scaffold(`:

```dart
    if (TabletShellScope.isActive(context)) {
      return _MessagesTabletLayout(
        inboxAsync: inboxAsync,
        filter: _filter,
        openId: _openId,
        onFilter: (f) => setState(() {
          _filter = f;
          _openId = null;
        }),
        onOpen: (id) => setState(() => _openId = id),
        onRetry: () => ref.invalidate(messageInboxProvider(widget.careerId)),
      );
    }
```

`lib/features/messages/messages_tablet_layout.dart`:

```dart
part of 'messages_screen.dart';

/// The tablet inbox's filters: the manager's own groupings of the inbox's
/// categories. Press and scouting are not inbox categories.
enum InboxFilter { all, board, competitions, squad }

/// Which filter a message [category] belongs to, or null for a category this
/// list does not know (shown under All only, never lost).
InboxFilter? inboxGroupOf(String category) => switch (category) {
  'board' || 'cycle' => InboxFilter.board,
  'draw' ||
  'qualify' ||
  'eliminated' ||
  'champion' ||
  'triumph' ||
  'ranking' => InboxFilter.competitions,
  'aging' ||
  'youth' ||
  'injury' ||
  'discipline' ||
  'retirement' ||
  'milestone' ||
  'award' ||
  'halloffame' ||
  'naturalize' ||
  'transfer' ||
  'record' => InboxFilter.squad,
  _ => null,
};

/// The inbox on a tablet: the list and the open message side by side. State
/// (filter, open message) is the screen's; this only draws it.
class _MessagesTabletLayout extends StatelessWidget {
  const _MessagesTabletLayout({
    required this.inboxAsync,
    required this.filter,
    required this.openId,
    required this.onFilter,
    required this.onOpen,
    required this.onRetry,
  });

  final AsyncValue<MessageInbox> inboxAsync;
  final InboxFilter filter;
  final int? openId;
  final ValueChanged<InboxFilter> onFilter;
  final ValueChanged<int> onOpen;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      key: MessagesScreen.tabletLayoutKey,
      body: inboxAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorState(
          message: l.messagesCouldNotLoad('').trim(),
          onRetry: onRetry,
        ),
        data: (inbox) {
          final visible = [
            for (final m in inbox.messages)
              if (filter == InboxFilter.all ||
                  inboxGroupOf(m.category) == filter)
                m,
          ];
          final open =
              visible.where((m) => m.id == openId).firstOrNull ??
              visible.firstOrNull;
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: MasterDetail(
              initialFraction: 0.36,
              minFraction: 0.28,
              maxFraction: 0.5,
              master: PanelBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                      child: Text(l.sideInbox, style: TabletText.screenTitle),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Wrap(
                        spacing: AppSpacing.xs,
                        children: [
                          for (final f in InboxFilter.values)
                            ChoiceChip(
                              label: Text(switch (f) {
                                InboxFilter.all => l.inboxFilterAll,
                                InboxFilter.board => l.sideBoard,
                                InboxFilter.competitions =>
                                  l.sideGroupCompetitions,
                                InboxFilter.squad => l.sideSquad,
                              }),
                              visualDensity: VisualDensity.compact,
                              selected: f == filter,
                              onSelected: (_) => onFilter(f),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    const Divider(height: 1),
                    Expanded(
                      child: visible.isEmpty
                          ? Center(
                              child: Text(
                                l.messagesNoMessagesYet,
                                style: TabletText.barMeta,
                              ),
                            )
                          : ListView.builder(
                              itemCount: visible.length,
                              itemBuilder: (context, i) => _InboxRow(
                                key: ValueKey('inbox.row.${visible[i].id}'),
                                message: visible[i],
                                selected: visible[i].id == open?.id,
                                onTap: () => onOpen(visible[i].id),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              detail: open == null
                  ? null
                  : PanelBox(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(top: AppSpacing.md),
                        // A new message is a new page: no scroll carried over.
                        child: MessageSheet(
                          key: ValueKey(open.id),
                          message: open,
                        ),
                      ),
                    ),
              placeholder: MasterDetailPlaceholder(text: l.inboxPickMessage),
            ),
          );
        },
      ),
    );
  }
}

/// One message in the tablet list: its category's mark, its title, its year.
class _InboxRow extends StatelessWidget {
  const _InboxRow({
    required this.message,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final MessageItem message;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final style = messageStyle(message.category);
    return Material(
      color: selected
          ? AppColors.surfaceContainerHighest
          : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.divider)),
          ),
          child: Row(
            children: [
              Icon(style.icon, color: style.color, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  readMessage(AppLocalizations.of(context), message).title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TabletText.cell.copyWith(
                    fontWeight: message.read
                        ? FontWeight.w500
                        : FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text('${message.year}', style: TabletText.barMeta),
            ],
          ),
        ),
      ),
    );
  }
}
```

`MessageInbox` is the record typedef in `message_providers.dart` (already imported); `MessageItem` comes from `competition_repository.dart` (already imported).

- [ ] **Step 6: Register, run, expect PASS**

Add `Routes.messages` to `tabletReadyPaths`.

Run: `flutter test test/unit/messages/inbox_filter_test.dart test/widget/messages_tablet_test.dart test/golden/phone_guard_messages_test.dart test/widget/message_popup_test.dart test/widget/message_language_switch_test.dart test/widget/squad_dev_report_test.dart test/widget/tablet_route_sweep_test.dart`
Expected: PASS; phone golden unchanged.

- [ ] **Step 7: Analyze, full suite, commit**

```bash
flutter analyze && flutter test
git add lib/features/messages/messages_screen.dart lib/features/messages/messages_tablet_layout.dart lib/features/shell/tablet_shell.dart test/unit/messages/inbox_filter_test.dart test/widget/messages_tablet_test.dart
git commit -m "feat(tablet): inbox as list and reading pane

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---
### Task 12: Tactics with the pitch left and the tabs right

Per the mockup: the starting XI on a full-height pitch (names inside the discs, `TacticsPitch` unchanged, so its disc-size ceiling of `0.145` of the pitch width and the 32..76 clamp still rule; the larger pitch is what makes the discs larger), the bench as chips under it, and on the right three tabs: Formation (with the instructions under it), Roles and set pieces, Opposition. The Opposition tab shows the scouting briefing only once the next opponent's draw has been watched.

The Squad destination (`/tactics?tab=3`) is the same route. Until Task 13 gives it a tablet layout it is drawn at phone width explicitly, because registering `/tactics` as tablet ready here would otherwise stretch it.

**Files:**
- Create: `lib/features/tactics/tactics_tablet_layout.dart` (part of `tactics_screen.dart`)
- Modify: `lib/features/tactics/tactics_screen.dart`, `lib/features/tactics/tactics_pitch.dart`, `lib/features/match/match_preview_screen.dart`, `lib/features/shell/tablet_shell.dart`
- Test: `test/golden/phone_guard_tactics_test.dart`, `test/widget/tactics_tablet_test.dart`

**Interfaces:**
- Consumes: `tacticDataProvider`, `TacticData`; `tacticServiceProvider`, `TacticService`; `playerRolesProvider`; `setPieceTakersProvider`, `setPieceTakersStoreProvider`, `SetPieceTakers`; `absenceOutlookProvider`; `shapeDrillingProvider`; `careerByIdProvider`, `nationByIdProvider`; `hubDataProvider`; `TacticsPitch`, `resolveDrag`, `resolveSpaceDrag`, private `_BenchDrag`, `kDragHoldDelay`, `surnameOf`; `FormationField`; private `_InstructionsTab`, `_CaptainCard`, `_PlayerTacticRow`, `_clearTakerAfterFrame`, `TacticsScreen._pickPlayer/_pickRole/_dragBetweenSlots/_openPresets`; `OpponentBriefing`; `PhoneWidthFrame`; `Panel`, `PanelBox`, `TabletShellScope`, `TabletText`; `TourKeys.tacticsFormation`, `TourKeys.tacticsPlaystyle`.
- Produces:
  - `TacticsScreen.tabletLayoutKey` (static const Key)
  - `class BenchChip extends StatelessWidget { const BenchChip({required Player player, VoidCallback? onTap}); }` (tactics_pitch.dart; draggable onto the pitch like a bench row)
  - `final AutoDisposeFutureProviderFamily<List<Player>, ({int careerId, int nationId})> opponentKeyMenProvider` (match_preview_screen.dart)
  - private in tactics_screen.dart: `typedef _Takers`, `_Takers _resolveTakers(WidgetRef ref, int careerId, TacticData data, SetPieceTakers? takers)`, and on `TacticsScreen`: `Widget _pitch(...)`, `Widget _outStartersCard(...)`, `List<Widget> _rolesChildren(...)`.
  - `tabletReadyPaths` gains `Routes.tactics`.

- [ ] **Step 1: Pin the phone tactics and squad**

`test/golden/phone_guard_tactics_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/tactics/nation_squad_tab.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart';

import '../helpers/seeded_save.dart';

void main() {
  testWidgets('phone tactics, line-up tab', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(tester, save, '${Routes.tactics}?careerId=${save.careerId}');
    expect(find.byType(TacticsPitch), findsOneWidget);
    await expectAppGolden('goldens/tactics_phone.png');
  });

  testWidgets('phone squad tab', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.tactics}?careerId=${save.careerId}&tab=3',
    );
    expect(find.byType(NationSquadTab), findsOneWidget);
    await expectAppGolden('goldens/squad_phone.png');
  });
}
```

- [ ] **Step 2: Create the baselines, confirm they hold, commit them**

```bash
flutter test --update-goldens test/golden/phone_guard_tactics_test.dart
flutter test test/golden/phone_guard_tactics_test.dart
git add test/golden/phone_guard_tactics_test.dart test/golden/goldens/tactics_phone.png test/golden/goldens/squad_phone.png
git commit -m "test(tablet): pin the phone tactics and squad tabs

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

- [ ] **Step 3: Write the failing tablet test**

`test/widget/tactics_tablet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/hub/draw_reveal.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/match/match_preview_screen.dart';
import 'package:fnm/features/onboarding/tour_keys.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/tactics/formation_picker.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:fnm/features/tactics/tactics_screen.dart';

import '../helpers/seeded_save.dart';

void main() {
  testWidgets('pitch and bench left, tabs right', (tester) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    late int bench;
    await tester.runAsync(() async {
      final data = (await save.container.read(
        tacticDataProvider(save.careerId).future,
      ))!;
      bench = data.pool
          .where((p) => !data.tactic.lineup.contains(p.id))
          .length;
    });
    await pumpRoute(
      tester,
      save,
      '${Routes.tactics}?careerId=${save.careerId}',
      size: kTabletSize,
    );
    expect(tester.takeException(), isNull);
    expect(find.byKey(TacticsScreen.tabletLayoutKey), findsOneWidget);
    expect(find.byType(PhoneWidthFrame), findsNothing);
    expect(find.byType(TacticsPitch), findsOneWidget);
    expect(find.byType(BenchChip), findsNWidgets(bench));
    expect(
      find.descendant(
        of: find.byKey(TourKeys.tacticsFormation),
        matching: find.byType(FormationField),
      ),
      findsOneWidget,
      reason: 'the tour still finds the shape control',
    );
    final pitch = tester.getCenter(find.byType(TacticsPitch));
    final tabs = tester.getCenter(find.text(enL.tacticsFormation).first);
    expect(pitch.dx, lessThan(tabs.dx));
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the Opposition tab keeps the opponent back until his draw is '
      'watched (Review Focus 1)', (tester) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    late HubData hub;
    await tester.runAsync(() async {
      hub = (await save.container.read(
        hubDataProvider(save.careerId).future,
      ))!;
    });
    final next = hub.next!;
    expect(hub.nextDrawWatched, isFalse);
    final oppId = next.homeNationId == save.nationId
        ? next.awayNationId
        : next.homeNationId;
    final oppName = hub.nations[oppId]!.name;

    await pumpRoute(
      tester,
      save,
      '${Routes.tactics}?careerId=${save.careerId}',
      size: kTabletSize,
    );
    await tester.tap(find.text(enL.matchDossierTitle));
    await settle(tester);
    expect(find.byType(OpponentBriefing), findsNothing);
    expect(find.textContaining(oppName), findsNothing);
    expect(find.text(enL.topBarDrawPending), findsWidgets);

    await tester.runAsync(
      () => save.container
          .read(competitionRepositoryProvider)
          .markDrawWatched(
            save.careerId,
            save.career.cyclePointer,
            drawKindForFixture(next)!,
          ),
    );
    save.container.invalidate(hubDataProvider(save.careerId));
    await settle(tester);
    expect(find.byType(OpponentBriefing), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(OpponentBriefing),
        matching: find.textContaining(oppName),
      ),
      findsWidgets,
    );
    await tester.pumpWidget(const SizedBox());
  });
}
```

(`find.text(enL.topBarDrawPending)` finds the tab body and the top bar's chip; `findsWidgets` accepts both.)

- [ ] **Step 4: Run it to verify it fails**

Run: `flutter test test/widget/tactics_tablet_test.dart`
Expected: FAIL to compile (`TacticsScreen.tabletLayoutKey`, `BenchChip`).

- [ ] **Step 5: `BenchChip`**

Append to `lib/features/tactics/tactics_pitch.dart`:

```dart
/// A substitute as a small chip: the tablet's bench strip under the pitch.
/// Hold and drag it onto a player on the pitch to bring it on, exactly like a
/// [SubDragRow]; a tap does [onTap].
class BenchChip extends StatelessWidget {
  const BenchChip({required this.player, this.onTap, super.key});

  final Player player;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Widget chip() => Material(
      color: AppColors.surfaceContainerHigh,
      borderRadius: AppRadii.lgAll,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.lgAll,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                player.position.label,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 10,
                ),
              ),
              const SizedBox(width: 5),
              Text(surnameOf(player.name), style: AppTypography.labelSmall),
            ],
          ),
        ),
      ),
    );
    return LongPressDraggable<Object>(
      data: _BenchDrag(player.id),
      delay: kDragHoldDelay,
      feedback: chip(),
      childWhenDragging: Opacity(opacity: 0.4, child: chip()),
      child: chip(),
    );
  }
}
```

- [ ] **Step 6: `opponentKeyMenProvider`**

In `lib/features/match/match_preview_screen.dart` add `import 'package:fnm/data/data_providers.dart';` and `import 'package:fnm/features/career/career_providers.dart';`, then after `_keyMen`:

```dart
/// The three best-rated players in [nationId]'s pool: the danger men for the
/// tablet Tactics screen's scouting dossier.
///
/// The preview reads them off the opponent's named XI. Tactics cannot: the
/// one provider holding that XI ([matchPreviewProvider]) also pre-simulates
/// the match, and keeping it alive while the manager changes his line-up
/// would hand the preview a result simulated with the old one. Barring an
/// injury the pool's best three are the XI's best three.
final AutoDisposeFutureProviderFamily<
  List<Player>,
  ({int careerId, int nationId})
>
opponentKeyMenProvider = FutureProvider.autoDispose
    .family<List<Player>, ({int careerId, int nationId})>((ref, key) async {
      final career = await ref
          .watch(careerRepositoryProvider)
          .byId(key.careerId);
      if (career == null) return const <Player>[];
      final pool = await ref
          .watch(playerRepositoryProvider)
          .byNation(
            key.nationId,
            agingYears: CareerService.agingYears(career),
            saveSeed: career.rngSeed,
          );
      return _keyMen(pool);
    });
```

- [ ] **Step 7: Pull the shared pieces out of the phone tree**

In `lib/features/tactics/tactics_screen.dart`:

1. Imports: add `import 'package:fnm/features/hub/hub_providers.dart';`, `import 'package:fnm/features/match/match_preview_screen.dart' show OpponentBriefing, opponentKeyMenProvider;`, `import 'package:fnm/features/shell/tablet_shell.dart' show PhoneWidthFrame;`, `import 'package:fnm/shared/tablet/tablet.dart';` (and drop the now-duplicate `tablet_shell_scope.dart` import if the analyzer flags it). Add `part 'tactics_tablet_layout.dart';`.

2. Add to `TacticsScreen`: `static const Key tabletLayoutKey = Key('tactics.tabletLayout');`

3. Add after `_clearTakerAfterFrame`:

```dart
/// The eleven as named, and who takes the set pieces: the manager's man where
/// he has named one who is still in the side, otherwise the engine's own pick.
typedef _Takers = ({
  List<Player> xi,
  int? namedPenalty,
  int? namedDeadBall,
  int? penaltyId,
  int? deadBallId,
});

/// Resolves [_Takers] for [data], clearing (after this frame) a designated
/// taker who is no longer in the eleven: null already means "let the engine
/// pick", so a stale id is cleared rather than kept as a second kind of empty.
_Takers _resolveTakers(
  WidgetRef ref,
  int careerId,
  TacticData data,
  SetPieceTakers? takers,
) {
  final xi = [
    for (final id in data.tactic.lineup.whereType<int>()) ?data.byId[id],
  ];
  final xiIds = {for (final p in xi) p.id};
  final namedPenalty = xiIds.contains(takers?.penalty) ? takers?.penalty : null;
  final namedDeadBall = xiIds.contains(takers?.deadBall)
      ? takers?.deadBall
      : null;
  if (takers != null && xi.isNotEmpty) {
    final store = ref.read(setPieceTakersStoreProvider);
    if (takers.penalty != null && namedPenalty == null) {
      _clearTakerAfterFrame(store, careerId, penalty: true);
    }
    if (takers.deadBall != null && namedDeadBall == null) {
      _clearTakerAfterFrame(store, careerId, penalty: false);
    }
  }
  return (
    xi: xi,
    namedPenalty: namedPenalty,
    namedDeadBall: namedDeadBall,
    penaltyId: namedPenalty ?? SetPiecePicks.penalty(xi),
    deadBallId: namedDeadBall ?? SetPiecePicks.deadBall(xi),
  );
}
```

In the phone tree, replace the block from `final xi = [` down to `final deadBallId = namedDeadBall ?? SetPiecePicks.deadBall(xi);` (comments included) with:

```dart
            final t = _resolveTakers(ref, careerId, data, takers);
            final xi = t.xi;
            final namedPenalty = t.namedPenalty;
            final namedDeadBall = t.namedDeadBall;
            final penaltyId = t.penaltyId;
            final deadBallId = t.deadBallId;
```

4. Move the line-up tab's `TacticsPitch(...)` (the `AspectRatio`'s child, unchanged) into a method on `TacticsScreen`, and the phone tree's `AspectRatio` becomes `AspectRatio(aspectRatio: 3 / 4, child: _pitch(context, ref, data, service: service, teamColors: teamColors, absentIds: absentIds, injuredIds: injuredIds)),`:

```dart
  /// The starting XI on the pitch, with every gesture the line-up has: tap a
  /// slot to pick, drag to swap or reshape, drop a substitute on.
  Widget _pitch(
    BuildContext context,
    WidgetRef ref,
    TacticData data, {
    required TacticService service,
    required List<Color>? teamColors,
    required Set<int> absentIds,
    required Set<int> injuredIds,
  }) {
    final tactic = data.tactic;
    return TacticsPitch(
      injuredIds: injuredIds,
      formation: tactic.formation,
      instructions: tactic.instructions,
      lineup: tactic.lineup,
      byId: data.byId,
      teamColors: teamColors,
      absentIds: absentIds,
      onTapSlot: (slot) => _pickPlayer(context, ref, data, slot),
      onSwap: (a, b) => _dragBetweenSlots(service, tactic, a, b),
      onBenchIn: (slot, playerId) =>
          service.setSlot(careerId, slot, playerId),
      onMoveToSpace: (slot, dropY) {
        final outcome = resolveSpaceDrag(
          tactic.formation,
          tactic.instructions,
          slot,
          dropY,
        );
        if (outcome case ReshapeTo(:final formation)) {
          unawaited(service.reshapeFormation(careerId, formation));
        }
      },
    );
  }
```

5. Move the out-starters card into a method:

```dart
  /// Names the starters who cannot play the next match, and why.
  Widget _outStartersCard(
    AppLocalizations l,
    TacticData data,
    Map<int, AbsenceOutlook> outlooks,
  ) {
    final outStarters = data.unavailableStarters;
    return AppCard(
      child: Row(
        children: [
          const Icon(
            Icons.personal_injury_outlined,
            color: AppColors.error,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.tacticsReplaceStarters(outStarters.length),
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(height: 2),
                for (final p in outStarters)
                  Text(
                    l.tacticsPlayerOut(
                      p.name,
                      switch (outlooks[p.id]) {
                        final o? => absenceLabel(l, o),
                        _ =>
                          absenceShortLabel(l, data.absences[p.id]) ??
                              l.tacticsOut,
                      },
                    ),
                    style: AppTypography.bodySmall,
                  ),
                const SizedBox(height: 2),
                Text(
                  l.tacticsTapSpotReplace,
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
```

and the phone tree's `Padding` child (the `AppCard` under `if (outStarters.isNotEmpty)`, which is exactly the tree above) becomes `_outStartersCard(l, data, outlooks)`. Keep the comment that sits above that `if`.

6. Move the roles-and-set-pieces `ListView`'s `children:` list into a method:

```dart
  /// The armband, the set-piece summary and one row per starter: the roles
  /// and set pieces tab, on both layouts.
  List<Widget> _rolesChildren(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l,
    TacticData data,
    _Takers t,
    Map<int, PlayerRole> roles,
  ) {
    final xi = t.xi;
    final namedPenalty = t.namedPenalty;
    final namedDeadBall = t.namedDeadBall;
    final penaltyId = t.penaltyId;
    final deadBallId = t.deadBallId;
    return [
      // The armband can go to a player nursing a knock (he is still the
      // captain, he just isn't playing), so the squad offered here is the
      // called-up group, not only the fit.
      _CaptainCard(careerId: careerId, pool: [...data.pool, ...data.unavailable]),
      const SizedBox(height: AppSpacing.md),
      Text(
        l.tacticsRolesSetPiecesBlurb,
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),
      const SizedBox(height: AppSpacing.sm),
      AppCard(
        child: SetPieceTakerSummary(
          penaltyName: data.byId[penaltyId]?.name,
          penaltyIsAuto: namedPenalty == null,
          deadBallName: data.byId[deadBallId]?.name,
          deadBallIsAuto: namedDeadBall == null,
          // One tap makes the two men already named above the manager's own
          // choice, which is also what settles the "set-piece takers are not
          // set" strip before kick-off.
          onQuickPick: () => ref
              .read(setPieceTakersStoreProvider)
              .setBoth(careerId, penalty: penaltyId, deadBall: deadBallId),
        ),
      ),
      const SizedBox(height: AppSpacing.sm),
      for (final p in xi)
        _PlayerTacticRow(
          player: p,
          role: roles[p.id] ?? PlayerRole.none,
          isPenaltyTaker: namedPenalty == p.id,
          isDeadBallTaker: namedDeadBall == p.id,
          isAutoPenalty: namedPenalty == null && penaltyId == p.id,
          isAutoDeadBall: namedDeadBall == null && deadBallId == p.id,
          onRole: () => _pickRole(context, ref, p),
          onTogglePenalty: () => ref
              .read(setPieceTakersStoreProvider)
              .set(
                careerId,
                penalty: true,
                playerId: namedPenalty == p.id ? null : p.id,
              ),
          onToggleDeadBall: () => ref
              .read(setPieceTakersStoreProvider)
              .set(
                careerId,
                penalty: false,
                playerId: namedDeadBall == p.id ? null : p.id,
              ),
        ),
    ];
  }
```

These are the phone tab's children as they stand (their longer comments may be kept verbatim instead of the shortened ones here). The phone `ListView` becomes `ListView(padding: const EdgeInsets.all(AppSpacing.marginMobile), children: _rolesChildren(context, ref, l, data, t, roles)),`.

7. At the top of `TacticsScreen.build`, before any read:

```dart
    if (TabletShellScope.isActive(context)) {
      // Squad is its own sidebar destination on the same route. Drawn at
      // phone width until it has a tablet layout of its own.
      if (initialTab == 3) {
        return Scaffold(
          body: PhoneWidthFrame(child: NationSquadTab(careerId: careerId)),
        );
      }
      return _TacticsTabletLayout(screen: this);
    }
```

- [ ] **Step 8: The tablet layout**

`lib/features/tactics/tactics_tablet_layout.dart`:

```dart
part of 'tactics_screen.dart';

/// Tactics on a tablet: the pitch and the bench on the left, the shape and
/// instructions, roles and set pieces, and the opposition on the right.
/// Every control is the phone's, calling the same screen methods.
class _TacticsTabletLayout extends ConsumerWidget {
  const _TacticsTabletLayout({required this.screen});

  static const double _pitchColumnWidth = 452;

  final TacticsScreen screen;

  int get careerId => screen.careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final dataAsync = ref.watch(tacticDataProvider(careerId));
    final service = ref.read(tacticServiceProvider);
    final career = ref.watch(careerByIdProvider(careerId)).valueOrNull;
    final nation = career == null
        ? null
        : ref.watch(nationByIdProvider(career.nationId)).valueOrNull;
    final teamColors = nation == null
        ? null
        : KitColors.discFill(nation.primaryColor, nation.secondaryColor);
    final outlooks =
        ref.watch(absenceOutlookProvider(careerId)).valueOrNull ??
        const <int, AbsenceOutlook>{};
    final drilling =
        ref.watch(shapeDrillingProvider(careerId)).valueOrNull ??
        const <Formation, double>{};
    return Scaffold(
      key: TacticsScreen.tabletLayoutKey,
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l.tacticsCouldNotLoadSquad(e.toString()))),
        data: (data) {
          if (data == null) return Center(child: Text(l.tacticsNoTacticSet));
          final tactic = data.tactic;
          final roles =
              ref.watch(playerRolesProvider(careerId)).valueOrNull ??
              const <int, PlayerRole>{};
          final takers = ref.watch(setPieceTakersProvider(careerId)).valueOrNull;
          final absentIds = {for (final p in data.unavailable) p.id};
          final injuredIds = {
            for (final p in data.unavailable)
              if ((data.absences[p.id]?.injuryMatches ?? 0) > 0) p.id,
          };
          final t = _resolveTakers(ref, careerId, data, takers);
          final bench = [
            for (final p in data.pool)
              if (!tactic.lineup.contains(p.id)) p,
          ]..sort((a, b) => b.overall.compareTo(a.overall));
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: _pitchColumnWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          // Pushed from the match preview: the way back to it.
                          if (context.canPop())
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: AppColors.primary,
                              ),
                              onPressed: () => context.pop(),
                            ),
                          Text(l.sideTactics, style: TabletText.screenTitle),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Text(
                              l.tacticsTapOrDrag,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                              style: TabletText.barMeta,
                            ),
                          ),
                        ],
                      ),
                      if (data.unavailableStarters.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.sm),
                        screen._outStartersCard(l, data, outlooks),
                      ],
                      const SizedBox(height: AppSpacing.sm),
                      Expanded(
                        child: Center(
                          child: AspectRatio(
                            aspectRatio: 3 / 4,
                            child: screen._pitch(
                              context,
                              ref,
                              data,
                              service: service,
                              teamColors: teamColors,
                              absentIds: absentIds,
                              injuredIds: injuredIds,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Panel(
                        title: l.tacticsTabBench,
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        // A fixed height: before a squad is named the whole
                        // pool sits here, and the pitch must keep its room.
                        child: SizedBox(
                          height: 88,
                          child: bench.isEmpty
                              ? Text(l.tacticsNoSubs, style: TabletText.barMeta)
                              : SingleChildScrollView(
                                  child: Wrap(
                                    spacing: 6,
                                    runSpacing: 6,
                                    children: [
                                      for (final p in bench)
                                        BenchChip(
                                          player: p,
                                          onTap: () => context.push(
                                            '${Routes.player}'
                                            '?careerId=$careerId'
                                            '&playerId=${p.id}',
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md - 4),
                Expanded(
                  child: PanelBox(
                    child: DefaultTabController(
                      length: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Material(
                            color: AppColors.surfaceContainer,
                            child: Row(
                              children: [
                                Expanded(
                                  child: TabBar(
                                    isScrollable: true,
                                    tabAlignment: TabAlignment.start,
                                    labelColor: AppColors.onSurface,
                                    unselectedLabelColor:
                                        AppColors.onSurfaceVariant,
                                    indicatorColor: AppColors.primary,
                                    tabs: [
                                      Tab(text: l.tacticsFormation),
                                      Tab(text: l.tacticsTabRolesSetPieces),
                                      Tab(text: l.matchDossierTitle),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.bookmark_border,
                                    color: AppColors.primary,
                                  ),
                                  tooltip: l.tacticsTooltipPresets,
                                  onPressed: () => screen._openPresets(
                                    context,
                                    ref,
                                    tactic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        AppSpacing.lg,
                                        AppSpacing.md,
                                        AppSpacing.lg,
                                        0,
                                      ),
                                      child: FormationField(
                                        key: TourKeys.tacticsFormation,
                                        selected: tactic.formation,
                                        drilling: drilling,
                                        onSelected: (f) =>
                                            service.setFormation(careerId, f),
                                      ),
                                    ),
                                    Expanded(
                                      // The playstyle opens the instructions;
                                      // the tour lights the whole block.
                                      child: KeyedSubtree(
                                        key: TourKeys.tacticsPlaystyle,
                                        child: _InstructionsTab(
                                          careerId: careerId,
                                          tactic: tactic,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                ListView(
                                  padding: const EdgeInsets.all(
                                    AppSpacing.marginMobile,
                                  ),
                                  children: screen._rolesChildren(
                                    context,
                                    ref,
                                    l,
                                    data,
                                    t,
                                    roles,
                                  ),
                                ),
                                _OppositionTab(careerId: careerId),
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
          );
        },
      ),
    );
  }
}

/// The next opponent's briefing, once his draw has been watched. Before then
/// it says so and nothing more: no name, no flag, no danger men.
class _OppositionTab extends ConsumerWidget {
  const _OppositionTab({required this.careerId});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final hub = ref.watch(hubDataProvider(careerId)).valueOrNull;
    if (hub == null) return const Center(child: CircularProgressIndicator());
    final next = hub.next;
    if (next == null) {
      return Center(child: Text(l.hubNoMoreFixtures, style: TabletText.cell));
    }
    if (!hub.nextDrawWatched) {
      return Center(child: Text(l.topBarDrawPending, style: TabletText.cell));
    }
    final me = hub.career.nationId;
    final opp = next.homeNationId == me ? next.awayNationId : next.homeNationId;
    final keyMen =
        ref
            .watch(opponentKeyMenProvider((careerId: careerId, nationId: opp)))
            .valueOrNull ??
        const <Player>[];
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        OpponentBriefing(
          careerId: careerId,
          myNationId: me,
          oppNationId: opp,
          oppName: hub.nations[opp]?.name ?? l.hubUnknown,
          oppCode: hub.nations[opp]?.code ?? '??',
          keyMen: keyMen,
          saveSeed: hub.career.rngSeed,
        ),
      ],
    );
  }
}
```

`_pitch`, `_outStartersCard`, `_rolesChildren`, `_openPresets` and `_pickPlayer` are private members of `TacticsScreen`; the part can call them through `screen`.

- [ ] **Step 9: Register, run, expect PASS**

```dart
const Set<String> tabletReadyPaths = <String>{
  Routes.hub,
  Routes.callUps,
  Routes.matchPreview,
  Routes.match,
  Routes.roundResults,
  Routes.messages,
  Routes.tactics,
};
```

Run: `flutter test test/widget/tactics_tablet_test.dart test/golden/phone_guard_tactics_test.dart test/widget/tactics_pitch_test.dart test/widget/tactics_tabs_test.dart test/widget/set_piece_auto_taker_test.dart test/widget/squad_tab_test.dart test/widget/formation_picker_test.dart test/widget/tour_navigation_test.dart test/widget/tablet_route_sweep_test.dart`
Expected: PASS; both phone goldens unchanged.

- [ ] **Step 10: Analyze, full suite, commit**

```bash
flutter analyze && flutter test
git add lib/features/tactics/tactics_screen.dart lib/features/tactics/tactics_tablet_layout.dart lib/features/tactics/tactics_pitch.dart lib/features/match/match_preview_screen.dart lib/features/shell/tablet_shell.dart test/widget/tactics_tablet_test.dart
git commit -m "feat(tablet): tactics with pitch and bench left, tabs right

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 13: Squad as a sortable table with the player beside it

The Squad destination: the whole national pool in a `DataGrid` with four column views (Overview, Attributes, Form, Career; attributes are physical, technical and stamina), a line filter, and the selected player's card in a draggable right-hand pane. The tour's Squad step lights the sidebar's Squad item, since on a tablet Squad is not a tab.

**Files:**
- Create: `lib/features/tactics/squad_tablet_layout.dart`
- Modify: `lib/features/tactics/tactics_screen.dart`, `lib/features/shell/tablet_sidebar.dart`
- Test: `test/widget/squad_tablet_test.dart`

**Interfaces:**
- Consumes: `nationSquadProvider`, `NationSquadData`, `NationSquadRow`; `absenceOutlookProvider`, `absenceLabel`, `absenceShortLabel`; `PlayerTraitGlyphs`; `showSquadLegend`; `FatigueState`; `DataGrid`, `GridColumn`, `GridColumnSet`, `MasterDetail`, `PanelBox`; `DetailPaneController`, `DetailPaneScope`, `PlayerTarget`; `DetailPaneHost`, `openPlayer`; `TourKeys.squadTab`.
- Produces:
  - `class SquadTabletLayout extends ConsumerStatefulWidget { const SquadTabletLayout({required int careerId}); static const Key layoutKey; }`
  - `List<GridColumnSet<NationSquadRow>> squadColumnSets(AppLocalizations l, {required Map<int, AbsenceOutlook> outlooks, required int saveSeed})` (top level, for the test and later stages)
  - Sidebar: the Squad item sits under `KeyedSubtree(key: TourKeys.squadTab)`.

- [ ] **Step 1: Write the failing test**

The phone squad tab was pinned in Task 12 (`goldens/squad_phone.png`).

`test/widget/squad_tablet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/onboarding/tour_keys.dart';
import 'package:fnm/features/player/player_detail_screen.dart';
import 'package:fnm/features/shell/detail_pane_host.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/shell/tablet_sidebar.dart';
import 'package:fnm/features/tactics/nation_squad_providers.dart';
import 'package:fnm/features/tactics/squad_tablet_layout.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/seeded_save.dart';

void main() {
  testWidgets('the pool as a table, the picked player beside it', (
    tester,
  ) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    late NationSquadData data;
    await tester.runAsync(() async {
      data = (await save.container.read(
        nationSquadProvider(save.careerId).future,
      ))!;
    });
    await pumpRoute(
      tester,
      save,
      '${Routes.tactics}?careerId=${save.careerId}&tab=3',
      size: kTabletSize,
    );
    expect(tester.takeException(), isNull);
    expect(find.byKey(SquadTabletLayout.layoutKey), findsOneWidget);
    expect(find.byType(PhoneWidthFrame), findsNothing);
    expect(find.byType(DataGrid<NationSquadRow>), findsOneWidget);
    expect(find.byType(MasterDetail), findsOneWidget);

    // Nothing picked yet: the best-rated player fills the pane.
    final pane = find.byType(DetailPaneHost);
    expect(
      find.descendant(
        of: pane,
        matching: find.text(data.rows.first.player.name),
      ),
      findsOneWidget,
    );

    // Picking the third fills it with him.
    final third = data.rows[2].player.name;
    await tester.tap(
      find
          .descendant(
            of: find.byType(DataGrid<NationSquadRow>),
            matching: find.text(third),
          )
          .first,
    );
    await settle(tester);
    expect(
      find.descendant(of: find.byType(PlayerView), matching: find.text(third)),
      findsOneWidget,
    );

    // The Attributes view swaps the columns.
    await tester.tap(find.text(enL.playerAttributes));
    await tester.pump();
    expect(find.text(enL.playerAttrPhysical), findsWidgets);

    // The tour's Squad step has something to light.
    expect(
      find.descendant(
        of: find.byType(TabletSidebar),
        matching: find.byKey(TourKeys.squadTab),
      ),
      findsOneWidget,
    );
    await tester.pumpWidget(const SizedBox());
  });
}
```

- [ ] **Step 2: Run it to verify it fails**

Run: `flutter test test/widget/squad_tablet_test.dart`
Expected: FAIL to compile (`squad_tablet_layout.dart` does not exist).

- [ ] **Step 3: The layout**

`lib/features/tactics/squad_tablet_layout.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/squad/absence_outlook.dart';
import 'package:fnm/domain/services/squad/condition.dart';
import 'package:fnm/features/player/player_detail_screen.dart'
    show PlayerTraitGlyphs;
import 'package:fnm/features/shell/detail_pane_host.dart';
import 'package:fnm/features/tactics/absence_providers.dart';
import 'package:fnm/features/tactics/nation_squad_providers.dart';
import 'package:fnm/features/tactics/squad_legend_sheet.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// The Squad destination on a tablet: every eligible player in a sortable
/// table with four views of the same rows, and the picked player's card in
/// the pane beside it.
class SquadTabletLayout extends ConsumerStatefulWidget {
  const SquadTabletLayout({required this.careerId, super.key});

  static const Key layoutKey = Key('squad.tabletLayout');

  final int careerId;

  @override
  ConsumerState<SquadTabletLayout> createState() => _SquadTabletLayoutState();
}

class _SquadTabletLayoutState extends ConsumerState<SquadTabletLayout> {
  final DetailPaneController _pane = DetailPaneController();
  PositionCategory? _line;

  static const _lines = [
    PositionCategory.goalkeeper,
    PositionCategory.defender,
    PositionCategory.midfielder,
    PositionCategory.forward,
  ];

  @override
  void dispose() {
    _pane.dispose();
    super.dispose();
  }

  String _lineLabel(AppLocalizations l, PositionCategory c) => switch (c) {
    PositionCategory.goalkeeper => l.squadLineKeepers,
    PositionCategory.defender => l.squadLineDefenders,
    PositionCategory.midfielder => l.squadLineMidfielders,
    PositionCategory.forward => l.squadLineForwards,
  };

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final dataAsync = ref.watch(nationSquadProvider(widget.careerId));
    final outlooks =
        ref.watch(absenceOutlookProvider(widget.careerId)).valueOrNull ??
        const <int, AbsenceOutlook>{};
    return Scaffold(
      key: SquadTabletLayout.layoutKey,
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l.tacticsCouldNotLoadSquad(e.toString()))),
        data: (data) {
          if (data == null) return Center(child: Text(l.tacticsNoSquad));
          final rows = [
            for (final r in data.rows)
              if (_line == null || r.player.category == _line) r,
          ];
          final sets = squadColumnSets(
            l,
            outlooks: outlooks,
            saveSeed: data.saveSeed,
          );
          return DetailPaneScope(
            controller: _pane,
            child: ListenableBuilder(
              listenable: _pane,
              builder: (context, _) {
                // Until a row is picked, the best-rated player shows: an
                // empty pane beside a full table is wasted room.
                final target =
                    _pane.value ??
                    (rows.isEmpty ? null : PlayerTarget(rows.first.player.id));
                final selectedId = switch (target) {
                  PlayerTarget(:final playerId) => playerId,
                  _ => null,
                };
                final selected = rows
                    .where((r) => r.player.id == selectedId)
                    .firstOrNull;
                return Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: MasterDetail(
                    initialFraction: 0.63,
                    minFraction: 0.45,
                    maxFraction: 0.72,
                    master: PanelBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 12, 4, 0),
                            child: Row(
                              children: [
                                Text(l.sideSquad, style: TabletText.screenTitle),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Text(
                                    l.squadShowingOf(rows.length, data.size),
                                    style: TabletText.barMeta,
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: () => showSquadLegend(context),
                                  icon: const Icon(
                                    Icons.help_outline_rounded,
                                    size: 15,
                                  ),
                                  label: Text(
                                    l.squadLegendTitle,
                                    style: TabletText.panelLink,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                            ),
                            child: Wrap(
                              spacing: AppSpacing.xs,
                              children: [
                                ChoiceChip(
                                  label: Text(l.squadLineAll),
                                  visualDensity: VisualDensity.compact,
                                  selected: _line == null,
                                  onSelected: (_) =>
                                      setState(() => _line = null),
                                ),
                                for (final c in _lines)
                                  ChoiceChip(
                                    label: Text(_lineLabel(l, c)),
                                    visualDensity: VisualDensity.compact,
                                    selected: _line == c,
                                    onSelected: (_) => setState(
                                      () => _line = _line == c ? null : c,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: DataGrid<NationSquadRow>(
                              rows: rows,
                              columnSets: sets,
                              selected: selected,
                              onSelect: (r) => openPlayer(
                                context,
                                careerId: widget.careerId,
                                playerId: r.player.id,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    detail: PanelBox(
                      child: DetailPaneHost(
                        careerId: widget.careerId,
                        target: target,
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

/// The squad table's four views of the same rows: who they are, what they
/// are made of, how they are going, and what they have done for the country.
List<GridColumnSet<NationSquadRow>> squadColumnSets(
  AppLocalizations l, {
  required Map<int, AbsenceOutlook> outlooks,
  required int saveSeed,
}) {
  GridColumn<NationSquadRow> pos() => GridColumn(
    id: 'pos',
    label: l.squadDevPosition,
    width: 52,
    sortKey: (r) => r.player.position.index,
    cell: (r) => TacticalChip(r.player.position.label),
  );
  GridColumn<NationSquadRow> name() => GridColumn(
    id: 'name',
    label: l.squadSortName,
    flex: 3,
    sortKey: (r) => r.player.name,
    cell: (r) => Row(
      children: [
        // In the XI, then merely in the squad: the two states a manager
        // scans this list for.
        if (r.starting)
          const Padding(
            padding: EdgeInsets.only(right: 4),
            child: Icon(Icons.star_rounded, size: 13, color: AppColors.primary),
          )
        else if (r.calledUp)
          const Padding(
            padding: EdgeInsets.only(right: 4),
            child: Icon(
              Icons.check_circle,
              size: 12,
              color: AppColors.positive,
            ),
          ),
        Flexible(child: Text(r.player.name)),
        PlayerTraitGlyphs(player: r.player, saveSeed: saveSeed),
      ],
    ),
  );
  GridColumn<NationSquadRow> number(
    String id,
    String label,
    int Function(NationSquadRow r) value, {
    double width = 64,
    bool bold = false,
  }) => GridColumn(
    id: id,
    label: label,
    width: width,
    numeric: true,
    sortKey: value,
    cell: (r) => Text(
      '${value(r)}',
      style: bold ? const TextStyle(fontWeight: FontWeight.w700) : null,
    ),
  );
  GridColumn<NationSquadRow> attr(
    String id,
    String label,
    int Function(PlayerAttributes a) value,
  ) => number(id, label, (r) => value(r.player.attributes), width: 92);
  final overall = number(
    'ovr',
    l.teamOverall,
    (r) => r.player.overall,
    width: 72,
    bold: true,
  );
  final age = number('age', l.playerAge, (r) => r.player.age, width: 52);
  final caps = number('caps', l.squadSortCaps, (r) => r.caps, width: 60);
  final goals = number('goals', l.squadSortGoals, (r) => r.goals, width: 60);
  final club = GridColumn<NationSquadRow>(
    id: 'club',
    label: l.playerClub,
    flex: 2,
    sortKey: (r) => r.player.club,
    cell: (r) => Text(r.player.club),
  );
  final status = GridColumn<NationSquadRow>(
    id: 'status',
    label: l.gridColStatus,
    flex: 2,
    sortKey: (r) => (r.absence?.isAvailable ?? true) ? 1 : 0,
    cell: (r) {
      if (r.absence?.isAvailable ?? true) return const SizedBox.shrink();
      final injured = (r.absence?.injuryMatches ?? 0) > 0;
      return Text(
        switch (outlooks[r.player.id]) {
          final o? => absenceLabel(l, o),
          _ => absenceShortLabel(l, r.absence) ?? l.tacticsOut,
        },
        style: TextStyle(color: injured ? AppColors.warning : AppColors.error),
      );
    },
  );
  final form = GridColumn<NationSquadRow>(
    id: 'form',
    label: l.playerStatForm,
    width: 64,
    numeric: true,
    sortKey: (r) => r.condition?.formRating ?? 0,
    cell: (r) {
      final rating = r.condition?.formRating ?? 0;
      return Text(rating > 0 ? rating.toStringAsFixed(1) : '-');
    },
  );
  final condition = GridColumn<NationSquadRow>(
    id: 'cond',
    label: l.gridColCondition,
    flex: 2,
    sortKey: (r) => r.condition?.fatigueState.index ?? 0,
    cell: (r) => Text(switch (r.condition?.fatigueState) {
      FatigueState.exhausted => l.tacticsFatigueExhausted,
      FatigueState.tired => l.tacticsFatigueTired,
      FatigueState.ready => l.tacticsFatigueMatchLegs,
      FatigueState.fresh || null => '',
    }),
  );
  return [
    GridColumnSet(
      id: 'overview',
      label: l.gridViewOverview,
      columns: [pos(), name(), age, club, overall, caps, goals, status],
    ),
    GridColumnSet(
      id: 'attributes',
      label: l.playerAttributes,
      columns: [
        pos(),
        name(),
        age,
        attr('phy', l.playerAttrPhysical, (a) => a.physical),
        attr('tec', l.playerAttrTechnical, (a) => a.technical),
        attr('sta', l.playerAttrStamina, (a) => a.stamina),
        overall,
      ],
    ),
    GridColumnSet(
      id: 'form',
      label: l.playerStatForm,
      columns: [pos(), name(), form, condition, overall, status],
    ),
    GridColumnSet(
      id: 'career',
      label: l.sideCareer,
      columns: [pos(), name(), age, caps, goals, club],
    ),
  ];
}
```

The DataGrid caches its sorted rows by list identity; `rows` is rebuilt whenever the filter or the data changes, which is what it needs. Shared `GridColumn` instances across sets are fine (columns are matched by `id`).

- [ ] **Step 4: Route Squad to it, and give the tour its target**

In `lib/features/tactics/tactics_screen.dart`, add `import 'package:fnm/features/tactics/squad_tablet_layout.dart';` and replace the temporary Squad branch from Task 12 with:

```dart
      if (initialTab == 3) return SquadTabletLayout(careerId: careerId);
```

(drop the now-unused `PhoneWidthFrame` import if nothing else uses it).

In `lib/features/shell/tablet_sidebar.dart`, add `import 'package:fnm/features/onboarding/tour_keys.dart';` and wrap the destination item so Squad carries the tour's key:

```dart
                  for (final d in shellDestinations.where(
                    (d) => d.section == section,
                  ))
                    () {
                      final item = _Item(
                        key: ValueKey(
                          d.id == active
                              ? 'sidebar.${d.id.name}.active'
                              : 'sidebar.${d.id.name}',
                        ),
                        icon: d.icon,
                        label: shellDestinationLabel(l, d.id),
                        active: d.id == active,
                        onTap: () => context.go(d.location(careerId)),
                      );
                      // The tour's Squad step: on a tablet Squad is this
                      // item, not a tab (the phone's Tab carries the key
                      // there; the two never exist at once).
                      return d.id == ShellDestinationId.squad
                          ? KeyedSubtree(key: TourKeys.squadTab, child: item)
                          : item;
                    }(),
```

- [ ] **Step 5: Run, expect PASS**

Run: `flutter test test/widget/squad_tablet_test.dart test/golden/phone_guard_tactics_test.dart test/widget/squad_tab_test.dart test/widget/squad_legend_test.dart test/widget/tablet_sidebar_test.dart test/widget/tour_test.dart test/widget/tour_navigation_test.dart test/widget/tablet_route_sweep_test.dart`
Expected: PASS; both phone goldens unchanged.

- [ ] **Step 6: Analyze, full suite, commit**

```bash
flutter analyze && flutter test
git add lib/features/tactics/squad_tablet_layout.dart lib/features/tactics/tactics_screen.dart lib/features/shell/tablet_sidebar.dart test/widget/squad_tablet_test.dart
git commit -m "feat(tablet): squad table with the player pane

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 14: Record stage 2 in the spec, verify, simulator checks

**Files:**
- Modify: `docs/superpowers/specs/2026-10-09-tablet-ui-design.md`

- [ ] **Step 1: Add a section to the spec, after "Stage 1 adjustments"**

```markdown
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
- Phone guards are golden files on a seeded save at 390 x 844
  (`test/golden/`).
- German and Spanish need the 8 stage 2 keys when they merge (values in the
  stage 2 plan, Task 2).
```

- [ ] **Step 2: Full verification**

```bash
flutter analyze
flutter test
```

Expected: no analyzer issues; all tests pass, including every `test/golden/phone_guard_*` golden WITHOUT `--update-goldens`. Paste the summary line of `flutter test` into the task report.

- [ ] **Step 3: Commit the spec**

```bash
git add docs/superpowers/specs/2026-10-09-tablet-ui-design.md
git commit -m "docs: record tablet stage 2 adjustments in the spec

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

- [ ] **Step 4: iPad simulator checks (the user drives the simulator)**

```bash
xcrun simctl list devices available | grep -i ipad
open -a Simulator
flutter run -d "<an iPad simulator id from the list>"
```

Ask the user to do each of these and report back; note each result in the task report:

1. **Landscape lock.** Launch with the simulator held in landscape: the app opens in landscape and does not follow a rotation to portrait.
2. **Portrait launch.** Rotate the simulator to portrait, quit and relaunch the app: it still gets the shell (sidebar and top bar) once in landscape, rather than a phone layout for the session.
3. **Hub.** The dashboard matches the mockup's shape: Next match, group, board on top; form, inbox, Y below; federation strip at the bottom. Before the first draw is watched the Next-match panel says "Draw to come" where the opponent will be. The top bar's Continue is the only Continue.
4. **Formation picker.** Tactics, Formation tab, tap the shape: the picker is a centred dialog, picking a shape closes it and the pitch reshapes; Tactics stays on screen.
5. **Tactics pickers.** Tap a player disc: the slot picker is a dialog; pick a player, the dialog closes and the pitch updates. Tap the info icon on a row: the dialog closes first, then the player page opens (and its back arrow returns to Tactics). Roles and set pieces tab: the role picker and the captain picker behave the same way.
6. **Bench drag.** Hold a bench chip under the pitch and drag it onto a starter: he comes on.
7. **Squad.** Sidebar Squad: the table fills the area, the best-rated player's card is on the right; tap another row, the card follows; drag the divider; switch between Overview, Attributes, Form and Career.
8. **Inbox.** List left, newest open on the right; filters narrow the list; a squad development report shows its table in the pane.
9. **A full matchday loop.** From the hub, follow Continue through: watch the draw, call-ups (three columns, name a squad, confirm), the match preview (two columns; Tactics opens the tablet Tactics with a back arrow that returns to the preview), Kick off (full-screen landscape match: commentary, live shape, stats; pause, speed; open Tactics mid-match and make a substitution in the landscape editor), full time, Continue to round results (groups beside their tables), Continue back to the hub, which shows the result in Form.
10. **Split view is not available** (the app requires full screen), so the narrow-window path is covered by the tests only.

- [ ] **Step 5: Phone sanity check**

Run the app on an iPhone simulator. Hub, inbox, call-ups, tactics, squad, preview, match (including the in-match editor) and round results must look and behave exactly as before: bottom nav present, no sidebar, tabs where there were tabs, sheets are bottom sheets.

- [ ] **Step 6: Android tablet**

No Android emulator is installed on this Mac (stage 1 finding). Record in the task report that the Android tablet check (Pixel Tablet AVD or a real tablet; installs upgrade in place with `adb install -r`, never `flutter install`) is left for the user.
