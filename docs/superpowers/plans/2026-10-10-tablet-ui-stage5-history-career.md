# Tablet UI, Stage 5: History and career. Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Every history and career screen has a tablet layout: the record book as headline records over sortable leaderboards beside the picked player's card, the world's all-time records and the legends as sortable grids beside the same pane, head to head as the picker and the manager's ledger beside every meeting of the picked pairing, achievements and challenges as a list of categories (tiers) beside a grid of the phone's cards, the career summary and the manager's career as two columns, the Career menu beside the career summary, the saves list as a sortable table beside the picked save's career (with Continue, Back up and Delete on it), and the home screen as a landscape title screen. History screens stay correct while the tablet's top-bar Continue runs the sim underneath them, and exporting a save works on an iPad.

**Architecture:** Same pattern as stages 2 to 4. Ten of the twelve screens are in-shell routes: each picks its layout at the top of `build` with `TabletShellScope.isActive(context)`, keeps its providers, State and write paths, and draws its tablet layout from a `part` file beside it, inside `TabletPage`. The two full-screen routes (home, saves) pick theirs with `useTabletLayout(context, ref)` and draw it full screen with no shell. Where a phone card's body is reused inside a tablet `Panel`, the body is moved into a private widget that the phone card wraps unchanged; where a screen's whole body is shown in a pane (the career summary, the meetings of a pairing) it is extracted into a public `*View` (`CareerSummaryView`, `H2hMeetingsView`) that the phone screen renders as its body. Tall phone goldens, created first, prove the phone is pixel-identical. Screens whose State holds something the manager chose (the all-time search, the head-to-head pair, the picked save) build both layouts from that one State, so a window crossing 1000 px keeps it. The sim's invalidation cascade gains `_invalidateHistoryViews`. Every converted path joins `tabletReadyPaths`; both route sweeps (in-shell and full-screen, three sizes) must stay green.

**Tech Stack:** Flutter, flutter_riverpod 2.6.1 (manual providers, no codegen), go_router 17, gen_l10n (5 ARB locales on this branch: en cs fr it pl), share_plus 12.0.2, flutter_test golden files for the phone guards.

**Spec:** `docs/superpowers/specs/2026-10-09-tablet-ui-design.md` (stage 5 = "History and career"; read the Screen layouts rows for "Records, legends, all-time records, achievements, challenges", "Head to head", "Careers / saves" and "Home", and the Stage 1, 2, 3 and 4 adjustments sections, which this plan follows).

**Stage 4 plan (format and conventions):** `docs/superpowers/plans/2026-10-10-tablet-ui-stage4-federation.md`. Where it and the code differ, the code is the source of truth: `kTabletLayoutMinWidth` (1000), per-page framing (`ShellPhoneFrame`/`PhoneWidthFrame` in the shell, `FullScreenPhoneFrame` outside it), `PanelBox` is a `Material`, `DataGrid` scrolls sideways when its columns do not fit and has a `DataGridController`, `MasterDetail.minDetailWidth`, `TabletTabBar`/`TabletDetailPage`, `TabletPage`, `ColumnFlow`, `DashboardGrid`'s intrinsic-height rule, `sheetIsDialog`, `DetailPaneHost` with `PlayerTarget`/`NationTarget`, `openPlayer`, `TabletScreenHeader.backTooltip`, and the seeded-save harness (`seedSave`, `pumpRoute`, `settle` that fails on a stuck spinner, `kTabletSizes`, `kSeededCareerId`, `seededNationId`, `showTab`, `expectAppGolden`).

## Global Constraints

- Phones keep the current UI exactly. Nothing in the phone path changes behaviour. Every converted screen gets a phone guard golden BEFORE it is touched (a tall one, 390 x 2400, for every screen that scrolls, beside the 390 x 844 one where the screen fits), and those goldens must pass unchanged after. The only phone-path code changes that are not pure moves are named in their tasks and are invisible on a phone: the share sheets carry an origin (an iPhone and Android ignore it), the delete dialog pops with its own context, the head-to-head picker checks `mounted` after its await, and the delete takes its services before its await.
- Tablet = `shortestSide >= 600` logical px. Landscape only. Tablet layouts need a window at least `kTabletLayoutMinWidth` (1000) wide; narrower tablet windows get the phone app.
- In-shell routes pick their tablet layout with `TabletShellScope.isActive(context)`: records, all-time records, legends, head to head, h2h meetings, achievements, challenges, careers, career summary, manager history. Full-screen routes (`Routes.fullScreen`) pick theirs with `useTabletLayout(context, ref)`: home and saves. Never the other way round: a full-screen route has no shell scope, and an in-shell screen must follow the shell, which steps aside under 1000 px.
- A screen whose tablet layout uses the whole content area (or the whole screen) is added to `tabletReadyPaths` IN THE SAME COMMIT as the layout. An unregistered in-shell screen would draw its tablet layout inside a 600 phone frame; an unregistered full-screen one inside `FullScreenPhoneFrame`.
- Every tablet layout is tested at 1194 x 834, 1080 x 810 and 1024 x 768 (`kTabletSizes`): no exception, the layout's key present, no `PhoneWidthFrame` (in-shell) or `FullScreenPhoneFrame` (full screen). Both route sweeps (`test/widget/tablet_route_sweep_test.dart`, `test/widget/tablet_full_screen_sweep_test.dart`) stay green after every task.
- `DashboardGrid` rows and `ColumnFlow` rows are `IntrinsicHeight`s: nothing inside a tile may be a scrollable, a `LayoutBuilder` or a `WholeText`. `LeaderRow` is built on `WholeText`, so leaderboards on a tablet are `DataGrid`s, never `LeaderRow`s in a tile. A panel whose body scrolls is `Panel(expand: true)` in a Row or Column.
- Release target: v1.0.4 on both iOS and Android. Do not bump `pubspec.yaml` in this stage.
- No `@riverpod` codegen; providers by hand. No change to game logic or the database schema. Providers are not edited; Task 3 only adds invalidations to the sim's cascade.
- Derived providers go stale after a sim step. On a tablet the top bar's Continue runs the sim while ANY in-shell screen is on show, so every history provider a tablet keeps on show is invalidated by the cascade (Task 3). A tablet layout may only watch providers that cascade refreshes or that the phone layout of the same screen already watches.
- Writes and navigation go through the phone's own code: the tablet calls the same State methods and functions (`_SavesScreenState._continue`, `_confirmDelete`, `_shareCareer`, `_backupAll`, `_importCareer`, the home screen's `_resume`, the head-to-head `_pick`). Nothing here adds a second write path.
- Post-await safety: a handler that awaits takes what it needs (container reads, services, the router) BEFORE the await, and navigates after a write only if `router.state.uri.path` is still its own route. In this stage no handler navigates after an await: Continue (home, saves) stamps the save without awaiting and goes at once, and the delete stays on the saves screen. Task 12 makes the delete take its two services before the dialog.
- Sheets and dialogs: on a tablet `showAdaptiveSheet` is a root dialog. Inside its builder pop with the sheet's own context, and pop BEFORE navigating from sheet content. The head-to-head picker already pops with its own context (Task 7 pins it); the saves delete dialog is changed to (Task 12).
- Draws read stored groups and are never re-run; every continental or nationsLeague lookup names a confederation. Nothing in this stage reads a draw or a continental competition; keep it that way.
- If any `build_runner` step is needed, run it with `--force-jit`. (Nothing in this plan should need it.)
- All new user-facing strings go into all 5 ARB files (`en cs fr it pl`), then `flutter gen-l10n`, then `dart run tool/export_copy.dart` so `copy/strings.csv` stays in sync. German and Spanish ARB files are not on this branch; the 15 new keys of Task 2 must be added to them when that work merges (values listed in Task 2). Prefer existing keys; reused keys are named in each task.
- No em dashes in user-facing copy. Never "World Cup" in English copy (it is "World Championship"). French text puts a space before a colon (the copy avoids colons altogether in this stage).
- Tests asserting a write read the stored value BEFORE the action as well as after. `SeededSave.career` is the career as created; read stored values from `careerRepositoryProvider`.
- Riverpod 2.6.1 teardown quirk (Stage 4 adjustments): an invalidated FutureProvider element that is never rebuilt before the container is disposed has its future completed twice on that dispose ("Bad state: Future already completed"). Tests that tap a Continue (which stamps the save and invalidates `savesProvider`, then leaves the screen that watched it) end with `stopPlayClock` (Task 1), which stops the play-time timer and re-reads `savesProvider`. If another test hits the quirk, override the invalidated provider with a value that has no awaits and say why in a comment, as stage 4 did.
- Never run `flutter install` against a physical device. Simulators only in this stage; a simulator build is installed in place with `xcrun simctl install`, never uninstalled first.
- Commit messages end with `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`.
- Run tests with `flutter test` from the repo root. Golden baselines are created ONLY in the "create the baseline" step of a task (`flutter test --update-goldens <file>`), before the screen is changed, and committed in that step. Never update a golden to make a later step pass; a changed phone golden is a phone regression.
- `settle` fails loudly when a screen is still showing a `CircularProgressIndicator` at its cap, unless the call passes `allowSpinner: true` with a comment saying why the spinner is the screen's content. No call in this plan needs it.

## Review depth

User-approved: low-risk read-only display screens get ONE combined review per batch; anything that writes, navigates, manages saves, shared code and event flows are reviewed per task. Each task is tagged:

- **risk: high (per-task review)**: Tasks 1, 3, 7, 10, 11, 12, 13.
- **risk: low (batched review)**: Tasks 2, 4, 5, 6, 8, 9. Review Tasks 2, 4, 5 and 6 together once Task 6 lands (one reviewer, given those tasks' commit SHAs from the ledger), before Task 7 starts. Review Tasks 8 and 9 together once Task 9 lands, before Task 10 starts.

## Review Focus

1. **Stale history screens under the top bar's Continue.** On a phone none of these screens is on show while the sim runs; on a tablet they are, their auto-disposed providers are kept alive by being watched, and every one of them reads fixtures, appearances or honours imperatively. Pinned in Task 3: with a listener on each of `recordBookProvider`, `rivalryProvider`, `legendsProvider`, `allTimeRecordsProvider`, `myHeadToHeadsProvider`, `headToHeadProvider`, `h2hMeetingsProvider`, `achievementsViewProvider`, `challengesViewProvider`, `careerSummaryProvider`, `managerHistoryProvider`, `careerStatsProvider` and `teamOverallHistoryProvider`, one `SeasonService.advance` and one `playPlayerMatch` each hand every one of them a new future; plus the source guard that `_skipToChampion` runs the same cascade.
2. **The save acted on is the save on show.** The tablet saves screen opens a save's career beside the list, and Continue, Back up and Delete act on THAT save, not the first in the list. Pinned in Task 12: pick the second save, Continue opens the hub on the second save's id and stamps only that save (both stamps read before and after); delete the picked second save, the first one is left, the app-folder copy removed is the second's, and the pane falls back to the first save; the deleted save never stays in the pane.
3. **Exporting a save on an iPad.** An iPad shows the share sheet as a popover and refuses to share without `sharePositionOrigin` (share_plus 12 throws, the app catches it and says "Could not export that career"). Pinned in Task 11 (a source guard: every `SharePlus.instance.share(` in `lib` passes an origin) and Task 12 (exporting from the tablet pane hands the share channel exactly the button's rect).
4. **A resize that throws away a choice.** iPadOS windows resize. The all-time search (Task 5), the head-to-head pair (Task 7) and the picked save (Task 12) live in the State both layouts share; each is pinned by shrinking the window to 900 x 810 (the phone layout shows the same choice) and growing it back.
5. **Dialogs that pop the page.** On a tablet the head-to-head picker and the delete confirmation are root dialogs. Pinned in Task 7 (pick a nation through the picker: the dialog closes, the page is still `/head-to-head`, the pick lands) and Task 12 (confirm a delete: the dialog closes, the page is still `/saves`).
6. **Phone drift from moved bodies.** Tasks 4, 5, 7, 8, 9, 10, 11, 12 and 13 move phone code into shared widgets and methods (the record book's team rows, rival line and empty state; the all-time filter and search controller; `H2hMeetingsView` and `_Record`'s link; the achievement and challenge cards; `CareerSummaryView`; the careers menu list; the saves screen's `_continue`, `_actions` and dialog; the home screen's `_resume`). Any change to what a phone draws is a regression. Pinned by phone goldens of each screen created before it is touched, and by the existing `home_screen_test`, `saves_buttons_test`, `saves_played_time_test`, `career_menu_challenges_test` and `all_time_scorers_active_test`, which must pass untouched.
7. **Navigation parity.** The tablet Career menu (Task 10) and home buttons (Task 13) go exactly where the phone's do, and the onboarding tour's Career step still finds its target (`TourKeys.careerHistory`) on a tablet.

---

## File structure

**Create**
- `lib/shared/tablet/list_row.dart`: `TabletListRow` (one line of a tablet master list).
- `lib/core/util/share_origin.dart`: `shareOriginOf(BuildContext)`.
- `lib/features/records/record_book_tablet_layout.dart` (part of `record_book_screen.dart`).
- `lib/features/records/all_time_records_tablet_layout.dart` (part of `all_time_records_screen.dart`).
- `lib/features/records/legends_tablet_layout.dart` (part of `legends_screen.dart`).
- `lib/features/records/head_to_head_tablet_layout.dart` (part of `head_to_head_screen.dart`).
- `lib/features/achievements/achievements_tablet_layout.dart` (part of `achievements_screen.dart`).
- `lib/features/achievements/challenges_tablet_layout.dart` (part of `challenges_screen.dart`).
- `lib/features/career/career_summary_tablet_layout.dart` (part of `career_summary_screen.dart`).
- `lib/features/career/manager_history_tablet_layout.dart` (part of `manager_history_screen.dart`).
- `lib/features/career/careers_tablet_layout.dart` (part of `careers_screen.dart`).
- `lib/features/career/saves_tablet_layout.dart` (part of `saves_screen.dart`).
- `lib/features/home/home_tablet_layout.dart` (part of `home_screen.dart`).
- `test/helpers/history_fixtures.dart`: fake record book, rivalry, legends, all-time records, head-to-head ledger and meetings; a second save; a fake career transfer service; `stopPlayClock`.
- `test/golden/phone_guard_{records,all_time,legends,h2h,achievements,career_pages,careers,saves,home}_test.dart` and their `test/golden/goldens/*.png`.
- Tests listed per task.

**Modify**
- `lib/shared/tablet/tablet.dart` (barrel).
- `lib/features/shell/tablet_shell.dart` (`tabletReadyPaths`).
- `lib/features/hub/hub_providers.dart` (`SeasonService._invalidateHistoryViews`).
- `lib/features/records/record_book_screen.dart`, `all_time_records_screen.dart`, `legends_screen.dart`, `head_to_head_screen.dart`, `h2h_meetings_screen.dart` (`H2hMeetingsView`).
- `lib/features/achievements/achievements_screen.dart`, `challenges_screen.dart`.
- `lib/features/career/career_summary_screen.dart` (`CareerSummaryView`), `manager_history_screen.dart`, `careers_screen.dart`, `saves_screen.dart`.
- `lib/features/settings/settings_screen.dart` (the backup export's share origin, Task 11).
- `lib/features/home/home_screen.dart`.
- `test/helpers/seeded_save.dart` (`realPlayers`).
- `test/widget/competition_refresh_after_step_test.dart` (Task 3).
- `lib/l10n/app_{en,cs,fr,it,pl}.arb`, generated `app_localizations*.dart`, `copy/strings.csv`.
- `docs/superpowers/specs/2026-10-09-tablet-ui-design.md` (Task 14).

## Rulings on the spec (recorded in the spec by Task 14)

| Spec text | Ruling |
|---|---|
| "Careers / saves: list plus career summary" | Two screens. The in-shell Career page (`/careers`, the sidebar's Career) is the phone's menu beside the manager's own career summary. The full-screen saves list (`/saves`) is a sortable table of saves beside the PICKED save's career summary, with Continue, Back up and Delete on it. Both panes render one extracted `CareerSummaryView`. There is no rename: the app has no save rename. |
| "Home: landscape title screen" | The logo and title on the left, the Continue card, New game and saves on the right. "home/start" means this screen; the new-game flow (nation select, new game, start from the bottom) keeps its phone layout centred (`FullScreenPhoneFrame`) and is left for stage 6. |
| "Head to head: picker left, meetings right" and the detail-pane list naming `H2hView` | The picker (two nation slots and the manager's ledger as a grid) left; the pairing's record above every meeting right. The meetings body is extracted as `H2hMeetingsView`, which the `/h2h-meetings` page also renders. It is not made a `DetailTarget` in this stage: the match preview's head-to-head link keeps routing to its page. |
| "Records, legends, all-time records, achievements, challenges: DataGrid or list plus detail" | Leaderboards (record book, all-time, legends) are `DataGrid`s beside the player pane. Achievements and challenges are lists (categories, tiers) beside a grid of the phone's cards: an achievement has no more to show than its card. |
| Manager career (`/manager-history`), not in the stage list | Converted here: it sits under the sidebar's Career. Two columns: the overall record and the strength curve left, cycle by cycle right. |
| Team stats (`/team-stats`, "Team records" in the Career menu) and its `TeamStatsView` | Not converted in this stage; it stays phone-framed in the shell. |
| Back arrows | Sidebar destinations (records, legends, head to head, achievements) go back with `canPop ? pop : go(hub)`, as stage 4's pages do. Pages under a sidebar destination go back to it when there is nothing to pop: all-time records to records, h2h meetings to head to head, challenges to achievements, career summary and manager career to the Career page. The Career page has no back arrow, as on the phone. The saves list goes to home, as on the phone. |

## Stage 4 carry-overs

None. Stage 4 closed its findings on the branch (`56e4ea9` to `bd3ddfb`) and recorded them in the spec's Stage 4 adjustments.

---

### Task 1: Kit and harness: `TabletListRow`, history fixtures

**risk: high (per-task review)**. Shared code every later task builds on.

**Files:**
- Create: `lib/shared/tablet/list_row.dart`
- Modify: `lib/shared/tablet/tablet.dart`, `test/helpers/seeded_save.dart`
- Create: `test/helpers/history_fixtures.dart`
- Test: `test/widget/tablet_list_row_test.dart` (new), `test/widget/history_fixtures_test.dart` (new)

**Interfaces:**
- Produces (`list_row.dart`): `class TabletListRow extends StatelessWidget { const TabletListRow({required String label, required VoidCallback onTap, Widget? leading, String? trailing, bool selected = false, Key? key}); static const double height = 44; }`.
- Produces (`seeded_save.dart`): `List<Player> get realPlayers`.
- Produces (`history_fixtures.dart`):
  - `List<Player> squadOf(int nationId)`
  - `Nation get rivalNation`
  - `RecordBook fakeRecordBook()`, `Rivalry fakeRivalry()`, `List<Override> fakeRecordsOverrides()`
  - `LegendsView fakeLegends()`, `Override fakeLegendsOverride()`
  - `AllTimeRecords fakeAllTimeRecords()`, `Override fakeAllTimeOverride()`
  - `List<MyH2HLine> fakeLedger()`, `HeadToHead fakeHeadToHead()`, `List<H2HMeeting> fakeMeetings()`, `List<Override> fakeH2hOverrides()`
  - `Future<int> addSecondSave(WidgetTester tester, SeededSave save)`
  - `class FakeCareerTransfer extends CareerTransferService { final List<int> exported; final List<int> removed; }`, `Override fakeTransferOverride()`
  - `Future<void> stopPlayClock(WidgetTester tester, SeededSave save)`
- Consumes: `realNationsById`, `fieldOf` (`competition_fixtures.dart`), `Legends`, `recordBookProvider`, `rivalryProvider`, `legendsProvider`, `allTimeRecordsProvider`, `myHeadToHeadsProvider`, `headToHeadProvider`, `h2hMeetingsProvider`, `careerServiceProvider`, `careerTransferServiceProvider`, `playTimeTrackerProvider`, `savesProvider`.

- [ ] **Step 1: Write the failing tests**

Create `test/widget/tablet_list_row_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/shared/tablet/tablet.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget row) => tester.pumpWidget(
    MaterialApp(
      home: Scaffold(body: Column(children: [row])),
    ),
  );

  /// The row's own fill: the first Material inside it.
  Color? fill(WidgetTester tester) => tester
      .widget<Material>(
        find
            .descendant(
              of: find.byType(TabletListRow),
              matching: find.byType(Material),
            )
            .first,
      )
      .color;

  testWidgets('the label, the count, an icon, a tap', (tester) async {
    var taps = 0;
    await pump(
      tester,
      TabletListRow(
        label: 'Wins',
        trailing: '3/12',
        leading: const Icon(Icons.star),
        onTap: () => taps++,
      ),
    );
    expect(find.text('Wins'), findsOneWidget);
    expect(find.text('3/12'), findsOneWidget);
    expect(find.byIcon(Icons.star), findsOneWidget);
    expect(
      tester.getSize(find.byType(TabletListRow)).height,
      TabletListRow.height,
    );
    await tester.tap(find.text('Wins'));
    expect(taps, 1);
    expect(fill(tester), Colors.transparent);
  });

  testWidgets('the one open beside the list is lit', (tester) async {
    await pump(
      tester,
      TabletListRow(label: 'Goals', selected: true, onTap: () {}),
    );
    expect(fill(tester), AppColors.surfaceContainerHighest);
  });
}
```

Create `test/widget/history_fixtures_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';

import '../helpers/history_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The fakes later tasks lean on must be what they say they are.
void main() {
  test('a squad deep enough for three boards and a hall of fame', () {
    expect(squadOf(seededNationId).length, greaterThanOrEqualTo(16));
    final book = fakeRecordBook();
    final ids = {
      for (final board in [book.mostCaps, book.topScorers, book.topAssists])
        for (final r in board) r.playerId,
    };
    expect(ids, hasLength(15));
    expect(rivalNation.id, isNot(seededNationId));
    expect(fakeRivalry().rival.id, rivalNation.id);
  });

  test('legends: a ranked hall of fame and an XI of eleven at most', () {
    final legends = fakeLegends();
    expect(legends.hallOfFame, hasLength(16));
    expect(legends.allTimeXi.length, inInclusiveRange(1, 11));
    expect(
      legends.hallOfFame.first.score,
      greaterThanOrEqualTo(legends.hallOfFame.last.score),
    );
  });

  test("the world's boards span four nations, the manager's first", () {
    final records = fakeAllTimeRecords();
    expect({for (final r in records.topScorers) r.nationId}, hasLength(4));
    expect(records.topScorers.first.nationId, seededNationId);
    expect(records.myNationIds, {seededNationId});
  });

  test("the ledger adds up; the pairing's record matches its meetings", () {
    for (final line in fakeLedger()) {
      expect(line.wins + line.draws + line.losses, line.played);
    }
    expect(fakeLedger().first.opponentId, rivalNation.id);
    final h = fakeHeadToHead();
    final m = fakeMeetings();
    expect(h.played, m.length);
    expect(h.winsA, m.where((x) => x.forA > x.forB).length);
    expect(h.draws, m.where((x) => x.forA == x.forB).length);
    expect(h.winsB, m.where((x) => x.forA < x.forB).length);
  });

  testWidgets('a second save, on the rival nation', (tester) async {
    final save = await seedSave(tester);
    final second = await addSecondSave(tester, save);
    expect(second, isNot(save.careerId));
    await tester.runAsync(() async {
      final all = await save.container.read(careerRepositoryProvider).all();
      expect({for (final c in all) c.id}, {save.careerId, second});
      expect(all.firstWhere((c) => c.id == second).nationId, rivalNation.id);
    });
  });
}
```

- [ ] **Step 2: Run them to verify they fail**

Run: `flutter test test/widget/tablet_list_row_test.dart test/widget/history_fixtures_test.dart`
Expected: FAIL to compile (`TabletListRow` and `history_fixtures.dart` do not exist).

- [ ] **Step 3: `TabletListRow`**

Create `lib/shared/tablet/list_row.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/shared/tablet/tablet_text.dart';

/// One line of a tablet master list (an achievement category, a challenge
/// tier): an optional icon, the label, a count on the right, and a lit
/// background and edge when it is the one open beside the list.
class TabletListRow extends StatelessWidget {
  const TabletListRow({
    required this.label,
    required this.onTap,
    this.leading,
    this.trailing,
    this.selected = false,
    super.key,
  });

  static const double height = 44;

  final String label;
  final VoidCallback onTap;
  final Widget? leading;

  /// A short count, right-aligned ("3/12").
  final String? trailing;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected
            ? AppColors.surfaceContainerHighest
            : Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: height,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: selected ? AppColors.primary : Colors.transparent,
                  width: 3,
                ),
              ),
            ),
            child: Row(
              children: [
                if (leading case final icon?) ...[
                  icon,
                  const SizedBox(width: AppSpacing.sm),
                ],
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TabletText.cell.copyWith(
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                ),
                if (trailing case final count?)
                  Text(
                    count,
                    style: TabletText.cellNumeric.copyWith(
                      color: AppColors.onSurfaceVariant,
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
```

In `lib/shared/tablet/tablet.dart` add, in alphabetical place (after `export 'detail_pane.dart';`):

```dart
export 'list_row.dart';
```

- [ ] **Step 4: Real players in the harness**

In `test/helpers/seeded_save.dart`, directly below the `realNations` getter, add:

```dart
/// The real players, for fake records drawn with real names and ids (a
/// player opened in a pane must exist in the save).
List<Player> get realPlayers => _players;
```

- [ ] **Step 5: The fixtures**

Create `test/helpers/history_fixtures.dart`:

```dart
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/squad/legends.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/career/career_transfer_providers.dart';
import 'package:fnm/features/career/play_time.dart';
import 'package:fnm/features/records/all_time_records_providers.dart';
import 'package:fnm/features/records/head_to_head_providers.dart';
import 'package:fnm/features/records/legends_providers.dart';
import 'package:fnm/features/records/record_book_providers.dart';
import 'package:fnm/features/records/rivalry_providers.dart';

import 'competition_fixtures.dart';
import 'seeded_save.dart';

// Fakes for the history and career screens: the states a fresh save does
// not reach on its own (records, legends, a rivalry, meetings), drawn with
// the REAL players and nations, so a player opened in a pane exists.

/// [nationId]'s players in the real data, best first.
List<Player> squadOf(int nationId) => [
  for (final p in realPlayers)
    if (p.nationId == nationId) p,
]..sort((a, b) => b.overall.compareTo(a.overall));

/// The manager's opponent in every fake pairing: the best-ranked nation
/// after his.
Nation get rivalNation => fieldOf(seededNationId, 2)[1];

List<RecordLeader> _leaders(Iterable<Player> players, List<int> values) {
  final list = players.toList();
  return [
    for (var i = 0; i < values.length; i++)
      (
        playerId: list[i].id,
        name: list[i].name,
        value: values[i],
        active: i.isEven,
      ),
  ];
}

/// The manager's record book after a few cycles: three boards of five, each
/// drawn from a different slice of his squad, a 5-0 win over the rival.
RecordBook fakeRecordBook() {
  final squad = squadOf(seededNationId);
  return (
    nationName: realNationsById[seededNationId]!.name,
    mostCaps: _leaders(squad, const [61, 54, 48, 40, 33]),
    topScorers: _leaders(squad.skip(5), const [22, 17, 12, 9, 6]),
    topAssists: _leaders(squad.skip(10), const [14, 11, 8, 5, 3]),
    biggestWin: (oppId: rivalNation.id, gf: 5, ga: 0),
    longestUnbeaten: 9,
    bestFinish: 'Quarter-finals',
    nations: realNationsById,
  );
}

Rivalry fakeRivalry() => (
  rival: rivalNation,
  played: 6,
  wins: 3,
  draws: 1,
  losses: 2,
  goalsFor: 9,
  goalsAgainst: 7,
);

List<Override> fakeRecordsOverrides() => [
  recordBookProvider(
    kSeededCareerId,
  ).overrideWith((ref) async => fakeRecordBook()),
  rivalryProvider(kSeededCareerId).overrideWith((ref) async => fakeRivalry()),
];

/// Sixteen of the manager's players ranked into a hall of fame, and the
/// all-time XI the ranking picks from them.
LegendsView fakeLegends() {
  final squad = squadOf(seededNationId);
  final ranked = Legends.rank([
    for (var i = 0; i < 16; i++)
      (
        playerId: squad[i].id,
        name: squad[i].name,
        position: squad[i].position,
        caps: 60 - 3 * i,
        goals: squad[i].category == PositionCategory.forward ? 20 - i : i % 3,
        assists: 10 - i ~/ 2,
        motm: 5 - i ~/ 4,
        avgRating: 7.4 - i * 0.05,
      ),
  ]);
  return (
    nationName: realNationsById[seededNationId]!.name,
    allTimeXi: Legends.allTimeXi(ranked),
    hallOfFame: ranked.take(20).toList(),
  );
}

Override fakeLegendsOverride() => legendsProvider(
  kSeededCareerId,
).overrideWith((ref) async => fakeLegends());

AllTimeLeader _allTimeLeader(
  Nation nation,
  int depth,
  int value,
  bool active,
) {
  final p = squadOf(nation.id)[depth];
  return (
    playerId: p.id,
    nationId: nation.id,
    name: p.name,
    nationCode: nation.code,
    nationName: nation.name,
    value: value,
    active: active,
  );
}

/// The world's boards: players of the manager's nation and the three best
/// after it, in turn, so a board holds two of each nation's first four.
AllTimeRecords fakeAllTimeRecords() {
  final field = fieldOf(seededNationId, 4);
  List<AllTimeLeader> board(List<int> values) => [
    for (var i = 0; i < values.length; i++)
      _allTimeLeader(
        field[i % field.length],
        i ~/ field.length,
        values[i],
        i.isOdd,
      ),
  ];
  return (
    topScorers: board(const [71, 64, 58, 50, 44, 39]),
    mostCaps: board(const [180, 171, 166, 150, 142, 133]),
    mostWcStarts: board(const [26, 24, 21, 19]),
    mostCupsAttended: board(const [6, 5, 5, 4]),
    myNationIds: {seededNationId},
  );
}

Override fakeAllTimeOverride() => allTimeRecordsProvider(
  kSeededCareerId,
).overrideWith((ref) async => fakeAllTimeRecords());

/// The manager's ledger: the rival (met three times) first, then two more.
List<MyH2HLine> fakeLedger() {
  final field = fieldOf(seededNationId, 4);
  MyH2HLine line(Nation n, int won, int drawn, int lost, int gf, int ga) => (
    opponentId: n.id,
    opponentName: n.name,
    opponentCode: n.code,
    played: won + drawn + lost,
    wins: won,
    draws: drawn,
    losses: lost,
    goalsFor: gf,
    goalsAgainst: ga,
  );
  return [
    line(field[1], 1, 1, 1, 3, 2),
    line(field[2], 1, 0, 1, 2, 2),
    line(field[3], 0, 1, 0, 1, 1),
  ];
}

/// Any pairing's record, from side A: the three meetings below.
HeadToHead fakeHeadToHead() => (
  played: 3,
  winsA: 1,
  draws: 1,
  winsB: 1,
  goalsA: 3,
  goalsB: 2,
  biggestWinMarginA: 2,
  biggestWinMarginB: 1,
);

/// Three meetings, newest first: a World Championship draw settled on
/// penalties, a continental win, a friendly defeat.
List<H2HMeeting> fakeMeetings() => [
  (
    date: DateTime(2029, 6, 21),
    competition: 'World Championship',
    forA: 1,
    forB: 1,
    afterExtraTime: true,
    penA: 4,
    penB: 3,
  ),
  (
    date: DateTime(2028, 6, 14),
    competition: 'European Championship',
    forA: 2,
    forB: 0,
    afterExtraTime: false,
    penA: null,
    penB: null,
  ),
  (
    date: DateTime(2027, 3, 26),
    competition: 'Friendly',
    forA: 0,
    forB: 1,
    afterExtraTime: false,
    penA: null,
    penB: null,
  ),
];

List<Override> fakeH2hOverrides() => [
  myHeadToHeadsProvider(
    kSeededCareerId,
  ).overrideWith((ref) async => fakeLedger()),
  headToHeadProvider.overrideWith((ref, key) async => fakeHeadToHead()),
  h2hMeetingsProvider.overrideWith((ref, key) async => fakeMeetings()),
];

/// A second career, on [rivalNation], beside [save]'s. Returns its id.
Future<int> addSecondSave(WidgetTester tester, SeededSave save) async {
  late int id;
  await tester.runAsync(() async {
    final created = await save.container
        .read(careerServiceProvider)
        .create(nationId: rivalNation.id, managerName: 'N', rngSeed: 20261010);
    id = created.valueOrNull!.id;
  });
  return id;
}

/// The career transfer service without the file system: an export is a file
/// that is never written (the share sheet only takes its path), and the
/// app-folder copy a delete removes is only noted.
class FakeCareerTransfer extends CareerTransferService {
  FakeCareerTransfer(super.ref);

  final List<int> exported = [];
  final List<int> removed = [];

  @override
  Future<File> export(int careerId, {DateTime? at}) async {
    exported.add(careerId);
    return File('fnm-test-career-$careerId.fnmcareer');
  }

  @override
  Future<void> removeAppFolderBackup(int careerId) async =>
      removed.add(careerId);
}

Override fakeTransferOverride() =>
    careerTransferServiceProvider.overrideWith(FakeCareerTransfer.new);

/// Ends a test that tapped a Continue. The Continue started the play-time
/// clock, a periodic timer that would still be pending; stopping it credits
/// the time and invalidates `savesProvider`, which the screen that watched it
/// has left. Re-reading it rebuilds it, so riverpod 2.6.1 does not complete
/// its future a second time at teardown (Stage 4 adjustments).
Future<void> stopPlayClock(WidgetTester tester, SeededSave save) async {
  await tester.runAsync(() async {
    await save.container.read(playTimeTrackerProvider).stop();
    await save.container.read(savesProvider.future);
  });
}
```

- [ ] **Step 6: Run the tests, expect PASS**

Run: `flutter test test/widget/tablet_list_row_test.dart test/widget/history_fixtures_test.dart`
Expected: PASS. If `squadOf(seededNationId)` has fewer than 16 players the fakes are wrong for this data: report it rather than shrinking the fakes.

- [ ] **Step 7: Analyze, commit**

Run: `flutter analyze lib/shared/tablet test/helpers test/widget/tablet_list_row_test.dart test/widget/history_fixtures_test.dart`
Expected: no new issues.

```bash
git add lib/shared/tablet/list_row.dart lib/shared/tablet/tablet.dart test/helpers/seeded_save.dart test/helpers/history_fixtures.dart test/widget/tablet_list_row_test.dart test/widget/history_fixtures_test.dart
git commit -m "feat(tablet): TabletListRow and the history test fixtures

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 2: Stage 5 copy in all 5 languages

**risk: low (batched review)**.

**Files:**
- Modify: `lib/l10n/app_en.arb`, `app_cs.arb`, `app_fr.arb`, `app_it.arb`, `app_pl.arb`
- Regenerate: `lib/l10n/app_localizations*.dart`, `copy/strings.csv`
- Test: existing `test/unit/l10n/*` guards

**Interfaces:**
- Produces these `AppLocalizations` getters: `allTimeRecordsTitle`, `h2hMeetingsTitle`, `h2hPickOpponent`, `savesTitle`, `gridColPlayer`, `gridColPos`, `gridColActive`, `gridColMotm`, `gridColAvg`, `gridColOpponent`, `gridColStarts`, `gridColTournaments`, `gridColDate`, `gridColLastPlayed`, `gridColManager`.
- Reused existing getters (do not add): `sideRecords`, `sideLegends`, `sideHeadToHead`, `sideAchievements`, `sideCareer`, `sideGroupHistory`, `careerChallenges`, `careerSummaryTitle`, `careerManagerCareer`, `careerTeamRecords`, `careerTournamentHistory`, `careerTrophyCabinet`, `careerCycleByCycle`, `careerNoTournamentsYet`, `careerNoSavesYet`, `careerExportSave`, `careerDelete`, `careerThisSave`, `careerUnknownNation`, `careerSlotsUsed`, `careerSlotsCount`, `hubContinue`, `recordsFiercestRival`, `recordsMostCaps`, `recordsTopScorers`, `recordsMostAssists`, `recordsAllTimeTopScorers`, `recordsMostCapped`, `recordsMostWcStarts`, `recordsMostTournaments`, `recordsHallOfFame`, `recordsAllTimeXi`, `recordsGreatestSide`, `recordsYourRecord`, `recordsPickTwoDifferent`, `recordsPlayToBuildRecord`, `recordsNoMatches`, `recordsHome`, `recordsAway`, `recordsVs`, `recordsGoalsLabel`, `careerStatPlayedShort`, `careerStatWonShort`, `careerStatDrawnShort`, `careerStatLostShort`, `playerStatCaps`, `playerStatGoals`, `playerStatAssists`, `gridColRank`, `gridColNation`, `gridViewOverview`, `achievementsUnlockedCount`, `achievementsConqueredCount`, `achievementsHardestTests`, `achievementsThisSave`, `panelViewAll`, `panePickPlayer`.

- [ ] **Step 1: Add the English strings with descriptions**

Append before the closing `}` of `lib/l10n/app_en.arb` (add a comma after the previous last entry, `"@yConversation": {...}`):

```json
  "allTimeRecordsTitle": "All-time world records",
  "@allTimeRecordsTitle": { "description": "Tablet all-time records screen heading: the greatest players of every nation in the save." },
  "h2hMeetingsTitle": "Every meeting",
  "@h2hMeetingsTitle": { "description": "Tablet heading of the page listing every past match between two nations." },
  "h2hPickOpponent": "Pick an opponent to see every meeting here",
  "@h2hPickOpponent": { "description": "Tablet head to head: the empty right-hand pane before a second nation is picked." },
  "savesTitle": "Saves",
  "@savesTitle": { "description": "Tablet saves screen heading: the list of save games." },
  "gridColPlayer": "Player",
  "@gridColPlayer": { "description": "Tablet table column: the player's name." },
  "gridColPos": "Pos",
  "@gridColPos": { "description": "Tablet table column, short: the player's position (GK, CB, ST)." },
  "gridColActive": "Active",
  "@gridColActive": { "description": "Tablet records table column: whether the player is still playing." },
  "gridColMotm": "MOTM",
  "@gridColMotm": { "description": "Tablet legends table column, short: man of the match awards." },
  "gridColAvg": "Avg",
  "@gridColAvg": { "description": "Tablet legends table column, short: average match rating." },
  "gridColOpponent": "Opponent",
  "@gridColOpponent": { "description": "Tablet head-to-head ledger column: the nation played against." },
  "gridColStarts": "Starts",
  "@gridColStarts": { "description": "Tablet all-time records column: World Championship finals matches started." },
  "gridColTournaments": "Tournaments",
  "@gridColTournaments": { "description": "Tablet all-time records column: finals tournaments attended." },
  "gridColDate": "Date",
  "@gridColDate": { "description": "Tablet saves table column: the in-game date the save has reached." },
  "gridColLastPlayed": "Last played",
  "@gridColLastPlayed": { "description": "Tablet saves table column: how long ago the save was last opened." },
  "gridColManager": "Manager",
  "@gridColManager": { "description": "Tablet saves table column: the manager's name in that save." }
```

- [ ] **Step 2: Add the translations**

Append the same keys (values only, no `@` entries) to each locale file, after its last entry (add the comma):

| key | cs | fr | it | pl |
|---|---|---|---|---|
| allTimeRecordsTitle | Světové rekordy všech dob | Records mondiaux de tous les temps | Record mondiali di sempre | Rekordy świata wszech czasów |
| h2hMeetingsTitle | Všechna vzájemná utkání | Toutes les confrontations | Tutti i precedenti | Wszystkie spotkania |
| h2hPickOpponent | Vyberte soupeře a uvidíte tu všechna vzájemná utkání | Choisissez un adversaire pour voir ici toutes les confrontations | Scegli un avversario per vedere qui tutti i precedenti | Wybierz rywala, aby zobaczyć tu wszystkie spotkania |
| savesTitle | Uložené hry | Sauvegardes | Salvataggi | Zapisy |
| gridColPlayer | Hráč | Joueur | Giocatore | Zawodnik |
| gridColPos | Post | Poste | Ruolo | Poz. |
| gridColActive | Aktivní | En activité | In attività | Aktywny |
| gridColMotm | MOTM | HdM | MVP | MVP |
| gridColAvg | Prům. | Moy. | Media | Śr. |
| gridColOpponent | Soupeř | Adversaire | Avversario | Rywal |
| gridColStarts | Starty | Titularisations | Da titolare | W podstawie |
| gridColTournaments | Turnaje | Tournois | Tornei | Turnieje |
| gridColDate | Datum | Date | Data | Data |
| gridColLastPlayed | Naposledy hráno | Dernière partie | Ultima partita | Ostatnio grane |
| gridColManager | Trenér | Sélectionneur | Allenatore | Trener |

For the de/es files when they merge (not on this branch): allTimeRecordsTitle `Ewige Weltrekorde` / `Récords mundiales de todos los tiempos`; h2hMeetingsTitle `Alle Duelle` / `Todos los enfrentamientos`; h2hPickOpponent `Wähle einen Gegner, um hier alle Duelle zu sehen` / `Elige un rival para ver aquí todos los enfrentamientos`; savesTitle `Spielstände` / `Partidas guardadas`; gridColPlayer `Spieler` / `Jugador`; gridColPos `Pos.` / `Pos.`; gridColActive `Aktiv` / `En activo`; gridColMotm `MVP` / `MVP`; gridColAvg `Ø` / `Media`; gridColOpponent `Gegner` / `Rival`; gridColStarts `Startelf` / `Titularidades`; gridColTournaments `Turniere` / `Torneos`; gridColDate `Datum` / `Fecha`; gridColLastPlayed `Zuletzt gespielt` / `Última partida`; gridColManager `Trainer` / `Seleccionador`.

- [ ] **Step 3: Regenerate typed strings and the copy file**

```bash
flutter gen-l10n
dart run tool/export_copy.dart
```

Expected: no "untranslated" entries for the new keys in `lib/l10n/untranslated.txt`; `copy/strings.csv` gains 15 rows.

- [ ] **Step 4: Run the l10n guards**

Run: `flutter test test/unit/l10n`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/l10n copy/strings.csv
git commit -m "feat(tablet): stage 5 copy (history grids, head to head, saves)

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---
### Task 3: History screens refresh after a sim step

**risk: high (per-task review)**. Touches `SeasonService`, the sim's invalidation cascade.

Stages 3 and 4 made the cascade refresh every competition, federation, manager and Y screen (`_invalidateCompetitionViews` and `_invalidateFederationViews`, run at the end of the advance step, `_skipToChampion` and `_playPlayerMatch`). The history screens have the same problem: on a tablet the top bar's Continue runs the sim with any of them on show, their auto-disposed providers are kept alive by being watched, and each reads the database imperatively. Concretely: the record book and the rivalry (`recordBookProvider`, `rivalryProvider`), the legends (`legendsProvider`), the world's all-time boards (`allTimeRecordsProvider`), head to head (`myHeadToHeadsProvider`, `headToHeadProvider`, `h2hMeetingsProvider`), achievements and challenges (`achievementsViewProvider`, `challengesViewProvider`), the career summary and its numbers (`careerSummaryProvider`, `careerStatsProvider`), and the manager's career with its strength curve (`managerHistoryProvider`, `teamOverallHistoryProvider`). Re-reading the achievements records any the step earned, exactly as opening that screen does on a phone; the match screen's unlock popup runs from the match route, where no shell screen is mounted.

**Files:**
- Modify: `lib/features/hub/hub_providers.dart`
- Modify: `test/widget/competition_refresh_after_step_test.dart`

**Interfaces:**
- Produces: `SeasonService._invalidateHistoryViews()` (private), called from the end of `_invalidateCompetitionViews()`, so all three step paths run it.
- Consumes: the thirteen providers above, `fieldOf` (`competition_fixtures.dart`).

- [ ] **Step 1: Write the failing tests**

In `test/widget/competition_refresh_after_step_test.dart`, add these imports, sorted into the existing blocks:

```dart
import 'package:fnm/features/achievements/achievement_providers.dart';
import 'package:fnm/features/achievements/challenge_providers.dart';
import 'package:fnm/features/career/career_summary_providers.dart';
import 'package:fnm/features/career/manager_history_providers.dart';
import 'package:fnm/features/records/all_time_records_providers.dart';
import 'package:fnm/features/records/head_to_head_providers.dart';
import 'package:fnm/features/records/legends_providers.dart';
import 'package:fnm/features/records/record_book_providers.dart';
import 'package:fnm/features/records/rivalry_providers.dart';
import 'package:fnm/features/stats/stats_providers.dart';

import '../helpers/competition_fixtures.dart';
```

Add, directly below `_federationViews`:

```dart
/// The history and career screens' data (stage 5). The head-to-head pair is
/// the manager's nation against the best-ranked other one.
_Views _historyViews(SeededSave save) {
  final id = save.careerId;
  final pair = (
    careerId: id,
    nationA: save.nationId,
    nationB: fieldOf(save.nationId, 2)[1].id,
  );
  return {
    'recordBook': recordBookProvider(id).future,
    'rivalry': rivalryProvider(id).future,
    'legends': legendsProvider(id).future,
    'allTime': allTimeRecordsProvider(id).future,
    'myH2h': myHeadToHeadsProvider(id).future,
    'h2h': headToHeadProvider(pair).future,
    'meetings': h2hMeetingsProvider(pair).future,
    'achievements': achievementsViewProvider(id).future,
    'challenges': challengesViewProvider(id).future,
    'summary': careerSummaryProvider(id).future,
    'managerHistory': managerHistoryProvider(id).future,
    'careerStats': careerStatsProvider(id).future,
    'teamOverall': teamOverallHistoryProvider(id).future,
  };
}
```

In BOTH step tests ('a step refreshes every screen a tablet keeps on show' and "so does committing the manager's own match") replace

```dart
      {..._competitionViews(save), ..._federationViews(save)},
```

with

```dart
      {
        ..._competitionViews(save),
        ..._federationViews(save),
        ..._historyViews(save),
      },
```

In the source-guard test 'skipping to the champion runs the same refresh', replace its last statement

```dart
    expect(
      cascade.substring(0, cascade.indexOf('\n  }')),
      contains('_invalidateFederationViews();'),
    );
```

with

```dart
    final cascadeBody = cascade.substring(0, cascade.indexOf('\n  }'));
    expect(cascadeBody, contains('_invalidateFederationViews();'));
    expect(cascadeBody, contains('_invalidateHistoryViews();'));
```

and make the first line of the doc comment above `main()` read `/// Review Focus 3 (stage 3), 1 (stage 4) and 1 (stage 5). A tablet's top bar runs the sim`.

- [ ] **Step 2: Run them to verify they fail**

Run: `flutter test test/widget/competition_refresh_after_step_test.dart`
Expected: FAIL. Both step tests name at least `recordBook`, `legends`, `allTime` and `meetings` as having kept their pre-step data; the source guard fails on `_invalidateHistoryViews();`.

- [ ] **Step 3: Invalidate them in the sim's cascade**

In `lib/features/hub/hub_providers.dart`, add the imports (sorted into the existing `features/` block; `achievement_providers.dart` is already imported and already provides `achievementsViewProvider`). Import with `show`, so none of these files' types can clash with the many already imported here:

```dart
import 'package:fnm/features/achievements/challenge_providers.dart'
    show challengesViewProvider;
import 'package:fnm/features/career/career_summary_providers.dart'
    show careerSummaryProvider;
import 'package:fnm/features/career/manager_history_providers.dart'
    show managerHistoryProvider;
import 'package:fnm/features/records/all_time_records_providers.dart'
    show allTimeRecordsProvider;
import 'package:fnm/features/records/head_to_head_providers.dart'
    show h2hMeetingsProvider, headToHeadProvider, myHeadToHeadsProvider;
import 'package:fnm/features/records/legends_providers.dart'
    show legendsProvider;
import 'package:fnm/features/records/record_book_providers.dart'
    show recordBookProvider;
import 'package:fnm/features/records/rivalry_providers.dart'
    show rivalryProvider;
import 'package:fnm/features/stats/stats_providers.dart'
    show careerStatsProvider, teamOverallHistoryProvider;
```

Make the last statement of `_invalidateCompetitionViews()` (after `_invalidateFederationViews();`):

```dart
    _invalidateHistoryViews();
```

and add this method directly below `_invalidateFederationViews()`:

```dart
  /// The history and career screens' data, refreshed by hand after a step
  /// for the same reason as [_invalidateCompetitionViews]: a tablet's top bar
  /// runs the sim while one of them is on show, and every one of them reads
  /// the fixtures, the appearances or the honours imperatively. The record
  /// book and the rivalry, the legends, the world's all-time boards, head to
  /// head, the achievements and challenges, the career summary and its
  /// numbers, and the manager's career with its strength curve. Re-reading
  /// the achievements records any the step earned, exactly as opening that
  /// screen does on a phone.
  void _invalidateHistoryViews() {
    _ref
      ..invalidate(recordBookProvider)
      ..invalidate(rivalryProvider)
      ..invalidate(legendsProvider)
      ..invalidate(allTimeRecordsProvider)
      ..invalidate(myHeadToHeadsProvider)
      ..invalidate(headToHeadProvider)
      ..invalidate(h2hMeetingsProvider)
      ..invalidate(achievementsViewProvider)
      ..invalidate(challengesViewProvider)
      ..invalidate(careerSummaryProvider)
      ..invalidate(managerHistoryProvider)
      ..invalidate(careerStatsProvider)
      ..invalidate(teamOverallHistoryProvider);
  }
```

Dart allows cyclic imports; do not restructure.

- [ ] **Step 4: Run the tests, expect PASS**

Run: `flutter test test/widget/competition_refresh_after_step_test.dart`
Expected: PASS. If the sanity line fails for one provider (a second read without a step already returns a new future), that provider is rebuilt by something else on each read; report it rather than weakening the test.

- [ ] **Step 5: Prove it bites**

Comment out the `_invalidateHistoryViews();` call, run the test, confirm both step tests FAIL naming at least `recordBook`, `legends`, `allTime` and `meetings`, restore it.

- [ ] **Step 6: Analyze, full suite, commit**

Run: `flutter analyze && flutter test` (final summary line: all passed).

```bash
git add lib/features/hub/hub_providers.dart test/widget/competition_refresh_after_step_test.dart
git commit -m "fix(tablet): a sim step refreshes the history and career screens

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 4: The record book: headline records over the leaderboards, beside the player

**risk: low (batched review)**. Read-only.

**Files:**
- Create: `lib/features/records/record_book_tablet_layout.dart` (part of `record_book_screen.dart`)
- Modify: `lib/features/records/record_book_screen.dart`, `lib/features/shell/tablet_shell.dart`
- Test: `test/golden/phone_guard_records_test.dart` (new, with goldens), `test/widget/records_tablet_test.dart` (new)

**Interfaces:**
- Produces: `RecordBookScreen.tabletLayoutKey`; private `_hasRecords(RecordBook)`, `_NoHistoryYet`, `_TeamRecordRows`, `_RivalryLine`, `_LeaderGrid`, `_leaderColumns`.
- Consumes: `recordBookProvider(careerId)`, `rivalryProvider(careerId)` (the phone screen's two reads, nothing else), `LegacyTiles(dense: true)`, `TabletPage`, `MasterDetail`, `DashboardGrid`, `Panel`, `PanelBox`, `TabletTabBar`, `DataGrid`, `DetailPaneScope`, `DetailPaneController`, `DetailPaneHost`, `openPlayer`, `ActiveBadge`, `l.sideRecords`, `l.careerTeamRecords`, `l.recordsFiercestRival`, `l.recordsMostCaps`, `l.recordsTopScorers`, `l.recordsMostAssists`, `l.playerStatCaps`, `l.playerStatGoals`, `l.playerStatAssists`, `l.gridColRank`, `l.gridColPlayer`, `l.gridColActive`, `l.gridViewOverview`, `l.recordsNoMatches`.

- [ ] **Step 1: Pin the phone record book**

Create `test/golden/phone_guard_records_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';

import '../helpers/history_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The phone record book, pinned before the tablet layout is added beside
/// it: as a fresh save shows it (nothing played yet), and full (the fake
/// book and rivalry), every card in a tall window.
void main() {
  testWidgets('records_phone', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.records}?careerId=${save.careerId}',
    );
    final me = save.nations.firstWhere((n) => n.id == save.nationId);
    expect(find.text(enL.recordsPlayToWriteHistory(me.name)), findsOneWidget);
    await expectAppGolden('goldens/records_phone.png');
  });

  testWidgets('records_phone_tall', (tester) async {
    final save = await seedSave(tester, overrides: fakeRecordsOverrides());
    await pumpRoute(
      tester,
      save,
      '${Routes.records}?careerId=${save.careerId}',
      size: const Size(390, 2400),
    );
    expect(find.text(enL.recordsFiercestRival), findsOneWidget);
    expect(find.text(enL.recordsMostAssists), findsOneWidget);
    await expectAppGolden('goldens/records_phone_tall.png');
  });
}
```

- [ ] **Step 2: Create the baseline, confirm it holds, commit it**

```bash
flutter test --update-goldens test/golden/phone_guard_records_test.dart
flutter test test/golden/phone_guard_records_test.dart
git add test/golden/phone_guard_records_test.dart test/golden/goldens/records_phone.png test/golden/goldens/records_phone_tall.png
git commit -m "test(tablet): phone guard for the record book

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

- [ ] **Step 3: Write the failing tablet test**

Create `test/widget/records_tablet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/player/player_detail_screen.dart';
import 'package:fnm/features/records/record_book_providers.dart';
import 'package:fnm/features/records/record_book_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/history_fixtures.dart';
import '../helpers/seeded_save.dart';

Future<SeededSave> _open(
  WidgetTester tester,
  Size size, {
  bool fake = true,
}) async {
  final save = await seedSave(
    tester,
    formFactor: FormFactor.tablet,
    overrides: fake ? fakeRecordsOverrides() : const [],
  );
  await pumpRoute(
    tester,
    save,
    '${Routes.records}?careerId=${save.careerId}',
    size: size,
  );
  return save;
}

Finder get _grid => find.byType(DataGrid<RecordLeader>);

/// The panel headed [title] (panel headers are upper case).
Finder _panel(String title) => find
    .ancestor(
      of: find.text(title.toUpperCase()).first,
      matching: find.byType(Panel),
    )
    .first;

void main() {
  for (final size in kTabletSizes) {
    testWidgets('team records beside the rival, the boards as a grid, the '
        'pane, $size', (tester) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(RecordBookScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      final team = tester.getRect(_panel(enL.careerTeamRecords));
      final rival = tester.getRect(_panel(enL.recordsFiercestRival));
      expect(rival.top, team.top);
      expect(rival.left, greaterThan(team.right));
      expect(find.text(fakeRivalry().rival.name), findsOneWidget);
      expect(
        tester.widget<DataGrid<RecordLeader>>(_grid).rows,
        fakeRecordBook().mostCaps,
      );
      expect(find.text(enL.panePickPlayer), findsOneWidget);
      expect(
        tester.getRect(_grid).right,
        lessThan(tester.getCenter(find.text(enL.panePickPlayer)).dx),
      );
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('a leader opens in the pane', (tester) async {
    await _open(tester, kTabletSize);
    final leader = fakeRecordBook().mostCaps.first;
    await tester.tap(
      find.descendant(of: _grid, matching: find.text(leader.name)),
    );
    await settle(tester);
    expect(
      tester.widget<PlayerView>(find.byType(PlayerView)).playerId,
      leader.playerId,
    );
    expect(tester.widget<DataGrid<RecordLeader>>(_grid).selected, leader);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the other boards are the other tabs', (tester) async {
    await _open(tester, kTabletSize);
    await showTab(tester, 1);
    expect(
      tester.widget<DataGrid<RecordLeader>>(_grid).rows,
      fakeRecordBook().topScorers,
    );
    await showTab(tester, 2);
    expect(
      tester.widget<DataGrid<RecordLeader>>(_grid).rows,
      fakeRecordBook().topAssists,
    );
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a fresh save is told to play some matches', (tester) async {
    final save = await _open(tester, kTabletSize, fake: false);
    expect(find.byKey(RecordBookScreen.tabletLayoutKey), findsOneWidget);
    final me = save.nations.firstWhere((n) => n.id == save.nationId);
    expect(find.text(enL.recordsPlayToWriteHistory(me.name)), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}
```

- [ ] **Step 4: Run it to verify it fails**

Run: `flutter test test/widget/records_tablet_test.dart`
Expected: FAIL to compile (`RecordBookScreen.tabletLayoutKey` does not exist).

- [ ] **Step 5: Move the shared bodies, hook in the layout**

In `lib/features/records/record_book_screen.dart`:

Add the imports `package:fnm/features/shell/detail_pane_host.dart` and `package:fnm/shared/tablet/tablet.dart` and, below the imports, `part 'record_book_tablet_layout.dart';`.

In `RecordBookScreen` add:

```dart
  static const Key tabletLayoutKey = Key('records.tabletLayout');
```

Make the first lines of `RecordBookScreen.build`:

```dart
    if (TabletShellScope.isActive(context)) {
      return _RecordBookTabletLayout(careerId: careerId);
    }
```

In the phone `data:` branch, replace

```dart
          final hasData =
              book.mostCaps.isNotEmpty ||
              book.topScorers.isNotEmpty ||
              book.longestUnbeaten > 0;
          if (!hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  l.recordsPlayToWriteHistory(book.nationName),
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            );
          }
          String nation(int id) => book.nations[id]?.name ?? 'Unknown';
          String code(int id) => book.nations[id]?.code ?? '??';
```

with

```dart
          if (!_hasRecords(book)) {
            return _NoHistoryYet(nationName: book.nationName);
          }
```

and replace the `_TeamRecords(...)` call (the one with `bestFinish:`, `longestUnbeaten:`, `biggestWin:` and `biggestWinCode:`) with

```dart
              _TeamRecords(book: book),
```

Add, directly above `class LegacyTiles`:

```dart
/// Whether the book has anything in it yet: a fresh save has no caps, no
/// goals and no results.
bool _hasRecords(RecordBook book) =>
    book.mostCaps.isNotEmpty ||
    book.topScorers.isNotEmpty ||
    book.longestUnbeaten > 0;

/// What the record book says before anything has been played.
class _NoHistoryYet extends StatelessWidget {
  const _NoHistoryYet({required this.nationName});

  final String nationName;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Text(
          AppLocalizations.of(context).recordsPlayToWriteHistory(nationName),
          textAlign: TextAlign.center,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
```

In `_RivalryCard.build`, delete the `final record = ...;` and `final edge = ...;` statements, and replace the last child of the card's Column (the `Row(children: [FlagDisc(r.rival.code, size: 32), ...])`) with

```dart
            _RivalryLine(rivalry: r),
```

and add, directly below `_RivalryCard`, moved verbatim:

```dart
/// The rival's flag and name, the record against them, and the goals.
class _RivalryLine extends StatelessWidget {
  const _RivalryLine({required this.rivalry});

  final Rivalry rivalry;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final r = rivalry;
    final record = l.recordsWdl(r.wins, r.draws, r.losses);
    final edge = r.wins > r.losses
        ? l.recordsEdgeUpperHand
        : r.wins < r.losses
        ? l.recordsEdgeTheirNumber
        : l.recordsEdgeEven;
    return Row(
      children: [
        FlagDisc(r.rival.code, size: 32),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(r.rival.name, style: AppTypography.titleMedium),
              Text(
                l.recordsRivalLine(r.played, record, edge),
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Text(
          '${r.goalsFor}–${r.goalsAgainst}',
          style: AppTypography.titleMedium.copyWith(color: AppColors.primary),
        ),
      ],
    );
  }
}
```

Replace the whole `_TeamRecords` class with these two (the rows moved verbatim; the biggest-win line is now worked out from the book here, as the screen used to before passing it in):

```dart
class _TeamRecords extends StatelessWidget {
  const _TeamRecords({required this.book});

  final RecordBook book;

  @override
  Widget build(BuildContext context) =>
      AppCard(child: _TeamRecordRows(book: book));
}

/// The team's headline records: the best finish, the longest unbeaten run
/// and the biggest win.
class _TeamRecordRows extends StatelessWidget {
  const _TeamRecordRows({required this.book});

  final RecordBook book;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final win = book.biggestWin;
    return Column(
      children: [
        _row(l.recordsBestFinish, book.bestFinish, null),
        _row(
          l.recordsLongestUnbeaten,
          l.recordsMatchesCount(book.longestUnbeaten),
          null,
        ),
        if (win != null)
          _row(
            l.recordsBiggestWin,
            l.recordsBiggestWinValue(
              win.gf,
              win.ga,
              book.nations[win.oppId]?.name ?? 'Unknown',
            ),
            book.nations[win.oppId]?.code ?? '??',
          ),
      ],
    );
  }

  Widget _row(String label, String value, String? code) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          // Flexible, because a Row hands a plain Text every pixel it asks for
          // and the label is the piece nobody thinks about: "NEJVĚTŠÍ VÍTĚZSTVÍ"
          // is nearly twice "BIGGEST WIN", and a Spacer has nothing to give
          // back once the label has taken the row.
          Flexible(
            child: Text(
              label.toUpperCase(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          const Spacer(),
          if (code != null) ...[
            FlagDisc(code, size: 18),
            const SizedBox(width: AppSpacing.sm),
          ],
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
```

(`RecordBook` and `Rivalry` come from `record_book_providers.dart` and `rivalry_providers.dart`, both already imported.)

- [ ] **Step 6: The layout**

Create `lib/features/records/record_book_tablet_layout.dart`:

```dart
part of 'record_book_screen.dart';

/// The record book on a tablet: the way to the legends, the world's records
/// and head to head in a strip at the top; the team's headline records
/// beside the fiercest rival; the three leaderboards as tabs over sortable
/// grids; the picked player's card in the pane beside them. The phone's two
/// reads, nothing more.
class _RecordBookTabletLayout extends ConsumerStatefulWidget {
  const _RecordBookTabletLayout({required this.careerId});

  final int careerId;

  @override
  ConsumerState<_RecordBookTabletLayout> createState() =>
      _RecordBookTabletLayoutState();
}

class _RecordBookTabletLayoutState
    extends ConsumerState<_RecordBookTabletLayout> {
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
    final async = ref.watch(recordBookProvider(careerId));
    return TabletPage(
      scaffoldKey: RecordBookScreen.tabletLayoutKey,
      title: l.sideRecords,
      onBack: () => context.canPop()
          ? context.pop()
          : context.go('${Routes.hub}?careerId=$careerId'),
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l.recordsCouldNotLoadRecords(e.toString()))),
        data: (book) {
          if (book == null) return Center(child: Text(l.recordsSaveNotFound));
          if (!_hasRecords(book)) {
            return _NoHistoryYet(nationName: book.nationName);
          }
          final rivalry = ref.watch(rivalryProvider(careerId)).valueOrNull;
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
                      LegacyTiles(careerId: careerId, dense: true),
                      const SizedBox(height: AppSpacing.md),
                      // Every tile must report an intrinsic height: no
                      // lists, no LayoutBuilder, no WholeText.
                      DashboardGrid(
                        tiles: [
                          DashboardTile(
                            span: rivalry == null ? 12 : 6,
                            child: Panel(
                              title: l.careerTeamRecords,
                              child: _TeamRecordRows(book: book),
                            ),
                          ),
                          if (rivalry != null)
                            DashboardTile(
                              span: 6,
                              child: Panel(
                                title: l.recordsFiercestRival,
                                child: _RivalryLine(rivalry: rivalry),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Expanded(
                        child: PanelBox(
                          child: DefaultTabController(
                            length: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TabletTabBar(
                                  tabs: [
                                    Tab(text: l.recordsMostCaps),
                                    Tab(text: l.recordsTopScorers),
                                    Tab(text: l.recordsMostAssists),
                                  ],
                                ),
                                Expanded(
                                  child: TabBarView(
                                    children: [
                                      _LeaderGrid(
                                        leaders: book.mostCaps,
                                        valueLabel: l.playerStatCaps,
                                        careerId: careerId,
                                        selectedId: selectedId,
                                      ),
                                      _LeaderGrid(
                                        leaders: book.topScorers,
                                        valueLabel: l.playerStatGoals,
                                        careerId: careerId,
                                        selectedId: selectedId,
                                      ),
                                      _LeaderGrid(
                                        leaders: book.topAssists,
                                        valueLabel: l.playerStatAssists,
                                        careerId: careerId,
                                        selectedId: selectedId,
                                      ),
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

/// One leaderboard as a table, in the record book's order until the manager
/// sorts it. Still-active players wear the badge every all-time chart uses.
class _LeaderGrid extends StatelessWidget {
  const _LeaderGrid({
    required this.leaders,
    required this.valueLabel,
    required this.careerId,
    required this.selectedId,
  });

  final List<RecordLeader> leaders;

  /// The tally's column heading (Caps, Goals, Assists).
  final String valueLabel;
  final int careerId;
  final int? selectedId;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    if (leaders.isEmpty) {
      return Center(
        child: Text(
          l.recordsNoMatches,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      );
    }
    return DataGrid<RecordLeader>(
      rows: leaders,
      columnSets: [_leaderColumns(l, leaders, valueLabel)],
      selected: leaders.where((r) => r.playerId == selectedId).firstOrNull,
      onSelect: (r) =>
          openPlayer(context, careerId: careerId, playerId: r.playerId),
    );
  }
}

/// A leaderboard's one view: place, player, tally, still playing. The place
/// is the book's, so it stays put when the manager sorts by name.
GridColumnSet<RecordLeader> _leaderColumns(
  AppLocalizations l,
  List<RecordLeader> leaders,
  String valueLabel,
) {
  return GridColumnSet<RecordLeader>(
    id: 'overview',
    label: l.gridViewOverview,
    columns: [
      GridColumn<RecordLeader>(
        id: 'rank',
        label: l.gridColRank,
        width: 64,
        sortKey: (r) => leaders.indexOf(r),
        cell: (r) => Text(
          '${leaders.indexOf(r) + 1}',
          style: TabletText.cellNumeric,
        ),
      ),
      GridColumn<RecordLeader>(
        id: 'player',
        label: l.gridColPlayer,
        flex: 3,
        sortKey: (r) => r.name,
        cell: (r) => Text(r.name),
      ),
      GridColumn<RecordLeader>(
        id: 'value',
        label: valueLabel,
        width: 80,
        numeric: true,
        sortKey: (r) => r.value,
        cell: (r) => Text('${r.value}'),
      ),
      GridColumn<RecordLeader>(
        id: 'active',
        label: l.gridColActive,
        width: 84,
        sortKey: (r) => r.active ? 1 : 0,
        cell: (r) => r.active ? const ActiveBadge() : const SizedBox.shrink(),
      ),
    ],
  );
}
```

- [ ] **Step 7: Register, run, expect PASS**

Add `Routes.records,` to `tabletReadyPaths` in `lib/features/shell/tablet_shell.dart`.

Run: `flutter test test/widget/records_tablet_test.dart test/golden/phone_guard_records_test.dart test/widget/tablet_route_sweep_test.dart test/widget/all_time_scorers_active_test.dart`
Expected: PASS, phone goldens unchanged.

- [ ] **Step 8: Analyze, full suite, commit**

Run: `flutter analyze && flutter test`

```bash
git add lib/features/records/record_book_screen.dart lib/features/records/record_book_tablet_layout.dart lib/features/shell/tablet_shell.dart test/widget/records_tablet_test.dart
git commit -m "feat(tablet): the record book's leaderboards beside the player's card

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 5: The world's all-time records as grids beside the player

**risk: low (batched review)**. Read-only. The search text moves into a controller the State owns, so it survives a resize.

**Files:**
- Create: `lib/features/records/all_time_records_tablet_layout.dart` (part of `all_time_records_screen.dart`)
- Modify: `lib/features/records/all_time_records_screen.dart`, `lib/features/shell/tablet_shell.dart`
- Test: `test/golden/phone_guard_all_time_test.dart` (new, with golden), `test/widget/all_time_records_tablet_test.dart` (new)

**Interfaces:**
- Produces: `AllTimeRecordsScreen.tabletLayoutKey`; `_AllTimeRecordsScreenState._search` (a `TextEditingController` both layouts' search fields use); private `_filtered(List<AllTimeLeader>, String)`, `_AllTimeGrid`, `_allTimeColumns`; `_SearchField` gains `required TextEditingController controller`.
- Consumes: `allTimeRecordsProvider(careerId)` (the phone screen's one read), `TabletPage`, `MasterDetail`, `PanelBox`, `TabletTabBar`, `DataGrid`, `DetailPaneScope`, `DetailPaneHost`, `openPlayer`, `ActiveBadge`, `FlagDisc`, `l.allTimeRecordsTitle`, `l.recordsAllTimeTopScorers`, `l.recordsMostCapped`, `l.recordsMostWcStarts`, `l.recordsMostTournaments`, `l.playerStatGoals`, `l.playerStatCaps`, `l.gridColStarts`, `l.gridColTournaments`, `l.gridColRank`, `l.gridColPlayer`, `l.gridColNation`, `l.gridColActive`, `l.recordsNoMatches`, `l.recordsNoWorldHistory`.

- [ ] **Step 1: Pin the phone all-time records**

Create `test/golden/phone_guard_all_time_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';

import '../helpers/history_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The phone all-time world records, pinned before the tablet layout is
/// added beside it: the fake boards, all four, in a tall window.
void main() {
  testWidgets('all_time_phone_tall', (tester) async {
    final save = await seedSave(tester, overrides: [fakeAllTimeOverride()]);
    await pumpRoute(
      tester,
      save,
      '${Routes.allTimeRecords}?careerId=${save.careerId}',
      size: const Size(390, 2400),
    );
    expect(find.text(enL.recordsMostTournaments), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    await expectAppGolden('goldens/all_time_phone_tall.png');
  });
}
```

- [ ] **Step 2: Create the baseline, confirm it holds, commit it**

```bash
flutter test --update-goldens test/golden/phone_guard_all_time_test.dart
flutter test test/golden/phone_guard_all_time_test.dart
git add test/golden/phone_guard_all_time_test.dart test/golden/goldens/all_time_phone_tall.png
git commit -m "test(tablet): phone guard for the all-time world records

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

- [ ] **Step 3: Write the failing tablet test**

Create `test/widget/all_time_records_tablet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/player/player_detail_screen.dart';
import 'package:fnm/features/records/all_time_records_providers.dart';
import 'package:fnm/features/records/all_time_records_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/competition_fixtures.dart';
import '../helpers/history_fixtures.dart';
import '../helpers/seeded_save.dart';

Future<SeededSave> _open(WidgetTester tester, Size size) async {
  final save = await seedSave(
    tester,
    formFactor: FormFactor.tablet,
    overrides: [fakeAllTimeOverride()],
  );
  await pumpRoute(
    tester,
    save,
    '${Routes.allTimeRecords}?careerId=${save.careerId}',
    size: size,
  );
  return save;
}

Finder get _grid => find.byType(DataGrid<AllTimeLeader>);

List<AllTimeLeader> _rows(WidgetTester tester) =>
    tester.widget<DataGrid<AllTimeLeader>>(_grid).rows;

void main() {
  for (final size in kTabletSizes) {
    testWidgets('the search over the boards, the pane beside them, $size', (
      tester,
    ) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(AllTimeRecordsScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      expect(find.byType(TextField), findsOneWidget);
      expect(_rows(tester), fakeAllTimeRecords().topScorers);
      expect(find.text(enL.panePickPlayer), findsOneWidget);
      expect(
        tester.getCenter(_grid).dx,
        lessThan(tester.getCenter(find.text(enL.panePickPlayer)).dx),
      );
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('a player opens in the pane', (tester) async {
    await _open(tester, kTabletSize);
    final top = fakeAllTimeRecords().topScorers.first;
    await tester.tap(find.descendant(of: _grid, matching: find.text(top.name)));
    await settle(tester);
    expect(
      tester.widget<PlayerView>(find.byType(PlayerView)).playerId,
      top.playerId,
    );
    expect(tester.widget<DataGrid<AllTimeLeader>>(_grid).selected, top);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the search filters every board', (tester) async {
    await _open(tester, kTabletSize);
    final nation = fieldOf(seededNationId, 4)[1];
    await tester.enterText(find.byType(TextField), nation.name);
    await tester.pump();
    expect(_rows(tester), hasLength(2));
    expect(_rows(tester).every((r) => r.nationId == nation.id), isTrue);
    await showTab(tester, 1);
    expect(_rows(tester), hasLength(2));
    expect(_rows(tester).every((r) => r.nationId == nation.id), isTrue);
    await tester.enterText(find.byType(TextField), 'zzzz');
    await tester.pump();
    expect(_grid, findsNothing);
    expect(find.text(enL.recordsNoMatches), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a resize keeps the search (Review Focus 4)', (tester) async {
    await _open(tester, kTabletSize);
    final nation = fieldOf(seededNationId, 4)[1];
    await tester.enterText(find.byType(TextField), nation.name);
    await tester.pump();
    tester.view.physicalSize = const Size(900, 810);
    await settle(tester);
    expect(find.byKey(AllTimeRecordsScreen.tabletLayoutKey), findsNothing);
    expect(find.widgetWithText(TextField, nation.name), findsOneWidget);
    tester.view.physicalSize = kTabletSize;
    await settle(tester);
    expect(find.byKey(AllTimeRecordsScreen.tabletLayoutKey), findsOneWidget);
    expect(find.widgetWithText(TextField, nation.name), findsOneWidget);
    expect(_rows(tester).every((r) => r.nationId == nation.id), isTrue);
    await tester.pumpWidget(const SizedBox());
  });
}
```

- [ ] **Step 4: Run it to verify it fails**

Run: `flutter test test/widget/all_time_records_tablet_test.dart`
Expected: FAIL to compile (`AllTimeRecordsScreen.tabletLayoutKey` does not exist).

- [ ] **Step 5: Share the search, hook in the layout**

In `lib/features/records/all_time_records_screen.dart`:

Add the imports `package:fnm/features/shell/detail_pane_host.dart` and `package:fnm/shared/tablet/tablet.dart` and, below the imports, `part 'all_time_records_tablet_layout.dart';`.

In `AllTimeRecordsScreen` add:

```dart
  static const Key tabletLayoutKey = Key('allTimeRecords.tabletLayout');
```

In `_AllTimeRecordsScreenState`, below `String _query = '';`, add:

```dart
  /// The search box's text, owned here and handed to whichever layout is
  /// drawn, so a window resized across 1000 px keeps what was typed.
  final TextEditingController _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }
```

Make the first lines of `_AllTimeRecordsScreenState.build`:

```dart
    if (TabletShellScope.isActive(context)) {
      return _AllTimeTabletLayout(
        careerId: widget.careerId,
        query: _query,
        search: _search,
        onQuery: (v) => setState(() => _query = v),
      );
    }
```

In the phone `data:` branch replace

```dart
          final q = _query.trim().toLowerCase();
          bool match(AllTimeLeader l) =>
              q.isEmpty ||
              l.name.toLowerCase().contains(q) ||
              l.nationName.toLowerCase().contains(q);
          final scorers = records.topScorers.where(match).toList();
          final caps = records.mostCaps.where(match).toList();
          final wcStarts = records.mostWcStarts.where(match).toList();
          final cups = records.mostCupsAttended.where(match).toList();
```

with

```dart
          final scorers = _filtered(records.topScorers, _query);
          final caps = _filtered(records.mostCaps, _query);
          final wcStarts = _filtered(records.mostWcStarts, _query);
          final cups = _filtered(records.mostCupsAttended, _query);
```

and replace

```dart
              _SearchField(onChanged: (v) => setState(() => _query = v)),
```

with

```dart
              _SearchField(
                controller: _search,
                onChanged: (v) => setState(() => _query = v),
              ),
```

Add, directly above `class _SearchField`:

```dart
/// [leaders] whose name or nation contains [query], ignoring case; all of
/// them when the query is blank.
List<AllTimeLeader> _filtered(List<AllTimeLeader> leaders, String query) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return leaders;
  return [
    for (final l in leaders)
      if (l.name.toLowerCase().contains(q) ||
          l.nationName.toLowerCase().contains(q))
        l,
  ];
}
```

In `_SearchField`, make the constructor `const _SearchField({required this.controller, required this.onChanged});`, add the field

```dart
  final TextEditingController controller;
```

and add `controller: controller,` as the first argument of its `TextField(...)`.

- [ ] **Step 6: The layout**

Create `lib/features/records/all_time_records_tablet_layout.dart`:

```dart
part of 'all_time_records_screen.dart';

/// The world's all-time records on a tablet: the search over the four boards
/// as tabs of sortable grids, the picked player's card in the pane beside
/// them. The search is the screen State's ([search], [query]), so a resize
/// keeps it. The phone's one read, nothing more.
class _AllTimeTabletLayout extends ConsumerStatefulWidget {
  const _AllTimeTabletLayout({
    required this.careerId,
    required this.query,
    required this.search,
    required this.onQuery,
  });

  final int careerId;
  final String query;
  final TextEditingController search;
  final ValueChanged<String> onQuery;

  @override
  ConsumerState<_AllTimeTabletLayout> createState() =>
      _AllTimeTabletLayoutState();
}

class _AllTimeTabletLayoutState extends ConsumerState<_AllTimeTabletLayout> {
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
    final async = ref.watch(allTimeRecordsProvider(careerId));
    return TabletPage(
      scaffoldKey: AllTimeRecordsScreen.tabletLayoutKey,
      title: l.allTimeRecordsTitle,
      onBack: () => context.canPop()
          ? context.pop()
          : context.go('${Routes.records}?careerId=$careerId'),
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l.recordsCouldNotLoadRecords(e.toString()))),
        data: (records) {
          if (records == null) {
            return Center(child: Text(l.recordsSaveNotFound));
          }
          if (records.topScorers.isEmpty && records.mostCaps.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  l.recordsNoWorldHistory,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            );
          }
          final boards = [
            (
              label: l.recordsAllTimeTopScorers,
              value: l.playerStatGoals,
              all: records.topScorers,
            ),
            (
              label: l.recordsMostCapped,
              value: l.playerStatCaps,
              all: records.mostCaps,
            ),
            (
              label: l.recordsMostWcStarts,
              value: l.gridColStarts,
              all: records.mostWcStarts,
            ),
            (
              label: l.recordsMostTournaments,
              value: l.gridColTournaments,
              all: records.mostCupsAttended,
            ),
          ];
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
                  master: PanelBox(
                    child: DefaultTabController(
                      length: boards.length,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            child: _SearchField(
                              controller: widget.search,
                              onChanged: widget.onQuery,
                            ),
                          ),
                          TabletTabBar(
                            tabs: [for (final b in boards) Tab(text: b.label)],
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                for (final b in boards)
                                  _AllTimeGrid(
                                    board: b.all,
                                    shown: _filtered(b.all, widget.query),
                                    valueLabel: b.value,
                                    careerId: careerId,
                                    myNations: records.myNationIds,
                                    selectedId: selectedId,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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

/// One world board as a table: the rows the search leaves ([shown]), each
/// still at its place on the whole board. The manager's own nations stand
/// out, as they do on the phone.
class _AllTimeGrid extends StatelessWidget {
  const _AllTimeGrid({
    required this.board,
    required this.shown,
    required this.valueLabel,
    required this.careerId,
    required this.myNations,
    required this.selectedId,
  });

  final List<AllTimeLeader> board;
  final List<AllTimeLeader> shown;
  final String valueLabel;
  final int careerId;
  final Set<int> myNations;
  final int? selectedId;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    if (shown.isEmpty) {
      return Center(
        child: Text(
          l.recordsNoMatches,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      );
    }
    return DataGrid<AllTimeLeader>(
      rows: shown,
      columnSets: [_allTimeColumns(l, board, valueLabel, myNations)],
      selected: shown.where((r) => r.playerId == selectedId).firstOrNull,
      onSelect: (r) =>
          openPlayer(context, careerId: careerId, playerId: r.playerId),
    );
  }
}

/// A world board's one view: place on the board, player, nation, tally,
/// still playing.
GridColumnSet<AllTimeLeader> _allTimeColumns(
  AppLocalizations l,
  List<AllTimeLeader> board,
  String valueLabel,
  Set<int> myNations,
) {
  return GridColumnSet<AllTimeLeader>(
    id: 'overview',
    label: l.gridViewOverview,
    columns: [
      GridColumn<AllTimeLeader>(
        id: 'rank',
        label: l.gridColRank,
        width: 56,
        sortKey: (r) => board.indexOf(r),
        cell: (r) =>
            Text('${board.indexOf(r) + 1}', style: TabletText.cellNumeric),
      ),
      GridColumn<AllTimeLeader>(
        id: 'player',
        label: l.gridColPlayer,
        flex: 3,
        sortKey: (r) => r.name,
        cell: (r) => Text(
          r.name,
          style: myNations.contains(r.nationId)
              ? TabletText.cell.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                )
              : null,
        ),
      ),
      GridColumn<AllTimeLeader>(
        id: 'nation',
        label: l.gridColNation,
        flex: 2,
        sortKey: (r) => r.nationName,
        cell: (r) => Row(
          children: [
            FlagDisc(
              r.nationCode,
              size: 20,
              highlighted: myNations.contains(r.nationId),
            ),
            const SizedBox(width: AppSpacing.sm),
            Flexible(
              child: Text(
                r.nationName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      GridColumn<AllTimeLeader>(
        id: 'value',
        label: valueLabel,
        width: 72,
        numeric: true,
        sortKey: (r) => r.value,
        cell: (r) => Text('${r.value}'),
      ),
      GridColumn<AllTimeLeader>(
        id: 'active',
        label: l.gridColActive,
        width: 84,
        sortKey: (r) => r.active ? 1 : 0,
        cell: (r) => r.active ? const ActiveBadge() : const SizedBox.shrink(),
      ),
    ],
  );
}
```

(At 1024 wide the grid's columns need more than its pane; `DataGrid` scrolls them sideways, header and rows together.)

- [ ] **Step 7: Register, run, expect PASS**

Add `Routes.allTimeRecords,` to `tabletReadyPaths` in `lib/features/shell/tablet_shell.dart`.

Run: `flutter test test/widget/all_time_records_tablet_test.dart test/golden/phone_guard_all_time_test.dart test/widget/tablet_route_sweep_test.dart test/widget/all_time_scorers_active_test.dart`
Expected: PASS, phone golden unchanged.

- [ ] **Step 8: Analyze, full suite, commit**

Run: `flutter analyze && flutter test`

```bash
git add lib/features/records/all_time_records_screen.dart lib/features/records/all_time_records_tablet_layout.dart lib/features/shell/tablet_shell.dart test/widget/all_time_records_tablet_test.dart
git commit -m "feat(tablet): the world's all-time records as grids beside the player

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 6: Legends as a hall of fame grid beside the player

**risk: low (batched review)**. Read-only.

**Files:**
- Create: `lib/features/records/legends_tablet_layout.dart` (part of `legends_screen.dart`)
- Modify: `lib/features/records/legends_screen.dart`, `lib/features/shell/tablet_shell.dart`
- Test: `test/golden/phone_guard_legends_test.dart` (new, with goldens), `test/widget/legends_tablet_test.dart` (new)

**Interfaces:**
- Produces: `LegendsScreen.tabletLayoutKey`; private `_LegendGrid`, `_legendColumns`.
- Consumes: `legendsProvider(careerId)` (the phone screen's one read), `TabletPage`, `MasterDetail`, `PanelBox`, `TabletTabBar`, `DataGrid`, `DetailPaneScope`, `DetailPaneHost`, `openPlayer`, `TacticalChip`, `l.sideLegends`, `l.recordsHallOfFame`, `l.recordsAllTimeXi`, `l.recordsGreatestSide`, `l.recordsNoLegends`, `l.gridColRank`, `l.gridColPos`, `l.gridColPlayer`, `l.playerStatCaps`, `l.playerStatGoals`, `l.playerStatAssists`, `l.gridColMotm`, `l.gridColAvg`.

- [ ] **Step 1: Pin the phone legends**

Create `test/golden/phone_guard_legends_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';

import '../helpers/history_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The phone legends, pinned before the tablet layout is added beside them:
/// as a fresh save shows them (none yet), and the fake hall of fame in a
/// tall window.
void main() {
  testWidgets('legends_phone', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.legends}?careerId=${save.careerId}',
    );
    final me = save.nations.firstWhere((n) => n.id == save.nationId);
    expect(find.text(enL.recordsNoLegends(me.name)), findsOneWidget);
    await expectAppGolden('goldens/legends_phone.png');
  });

  testWidgets('legends_phone_tall', (tester) async {
    final save = await seedSave(tester, overrides: [fakeLegendsOverride()]);
    await pumpRoute(
      tester,
      save,
      '${Routes.legends}?careerId=${save.careerId}',
      size: const Size(390, 2400),
    );
    expect(find.text(enL.recordsHallOfFame), findsOneWidget);
    await expectAppGolden('goldens/legends_phone_tall.png');
  });
}
```

- [ ] **Step 2: Create the baseline, confirm it holds, commit it**

```bash
flutter test --update-goldens test/golden/phone_guard_legends_test.dart
flutter test test/golden/phone_guard_legends_test.dart
git add test/golden/phone_guard_legends_test.dart test/golden/goldens/legends_phone.png test/golden/goldens/legends_phone_tall.png
git commit -m "test(tablet): phone guard for the legends

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

- [ ] **Step 3: Write the failing tablet test**

Create `test/widget/legends_tablet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/services/squad/legends.dart';
import 'package:fnm/features/player/player_detail_screen.dart';
import 'package:fnm/features/records/legends_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/history_fixtures.dart';
import '../helpers/seeded_save.dart';

Future<SeededSave> _open(
  WidgetTester tester,
  Size size, {
  bool fake = true,
}) async {
  final save = await seedSave(
    tester,
    formFactor: FormFactor.tablet,
    overrides: fake ? [fakeLegendsOverride()] : const [],
  );
  await pumpRoute(
    tester,
    save,
    '${Routes.legends}?careerId=${save.careerId}',
    size: size,
  );
  return save;
}

Finder get _grid => find.byType(DataGrid<RankedLegend>);

void main() {
  for (final size in kTabletSizes) {
    testWidgets('the hall of fame as a grid, the pane beside it, $size', (
      tester,
    ) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(LegendsScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      expect(
        tester.widget<DataGrid<RankedLegend>>(_grid).rows,
        fakeLegends().hallOfFame,
      );
      expect(find.text(enL.panePickPlayer), findsOneWidget);
      expect(
        tester.getCenter(_grid).dx,
        lessThan(tester.getCenter(find.text(enL.panePickPlayer)).dx),
      );
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('a legend opens in the pane', (tester) async {
    await _open(tester, kTabletSize);
    final first = fakeLegends().hallOfFame.first;
    await tester.tap(
      find.descendant(of: _grid, matching: find.text(first.name)),
    );
    await settle(tester);
    expect(
      tester.widget<PlayerView>(find.byType(PlayerView)).playerId,
      first.playerId,
    );
    expect(tester.widget<DataGrid<RankedLegend>>(_grid).selected, first);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the all-time XI is the second tab', (tester) async {
    final save = await _open(tester, kTabletSize);
    await showTab(tester, 1);
    expect(
      tester.widget<DataGrid<RankedLegend>>(_grid).rows,
      fakeLegends().allTimeXi,
    );
    final me = save.nations.firstWhere((n) => n.id == save.nationId);
    expect(find.text(enL.recordsGreatestSide(me.name)), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a fresh save has no legends yet', (tester) async {
    final save = await _open(tester, kTabletSize, fake: false);
    expect(find.byKey(LegendsScreen.tabletLayoutKey), findsOneWidget);
    final me = save.nations.firstWhere((n) => n.id == save.nationId);
    expect(find.text(enL.recordsNoLegends(me.name)), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}
```

- [ ] **Step 4: Run it to verify it fails**

Run: `flutter test test/widget/legends_tablet_test.dart`
Expected: FAIL to compile (`LegendsScreen.tabletLayoutKey` does not exist).

- [ ] **Step 5: Hook in the layout**

In `lib/features/records/legends_screen.dart`:

Add the imports `package:fnm/features/shell/detail_pane_host.dart` and `package:fnm/shared/tablet/tablet.dart` and, below the imports, `part 'legends_tablet_layout.dart';`.

In `LegendsScreen` add:

```dart
  static const Key tabletLayoutKey = Key('legends.tabletLayout');
```

Make the first lines of `LegendsScreen.build`:

```dart
    if (TabletShellScope.isActive(context)) {
      return _LegendsTabletLayout(careerId: careerId);
    }
```

The phone tree is not otherwise touched.

- [ ] **Step 6: The layout**

Create `lib/features/records/legends_tablet_layout.dart`:

```dart
part of 'legends_screen.dart';

/// The legends on a tablet: the hall of fame and the all-time XI as tabs of
/// sortable grids, the picked legend's card in the pane beside them. The
/// phone's one read, nothing more.
class _LegendsTabletLayout extends ConsumerStatefulWidget {
  const _LegendsTabletLayout({required this.careerId});

  final int careerId;

  @override
  ConsumerState<_LegendsTabletLayout> createState() =>
      _LegendsTabletLayoutState();
}

class _LegendsTabletLayoutState extends ConsumerState<_LegendsTabletLayout> {
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
    final async = ref.watch(legendsProvider(careerId));
    return TabletPage(
      scaffoldKey: LegendsScreen.tabletLayoutKey,
      title: l.sideLegends,
      onBack: () => context.canPop()
          ? context.pop()
          : context.go('${Routes.hub}?careerId=$careerId'),
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l.recordsCouldNotLoadLegends(e.toString()))),
        data: (view) {
          if (view == null) return Center(child: Text(l.recordsSaveNotFound));
          if (view.hallOfFame.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  l.recordsNoLegends(view.nationName),
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            );
          }
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
                  initialFraction: 0.62,
                  minFraction: 0.45,
                  maxFraction: 0.72,
                  minDetailWidth: 300,
                  master: PanelBox(
                    child: DefaultTabController(
                      length: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TabletTabBar(
                            tabs: [
                              Tab(text: l.recordsHallOfFame),
                              Tab(text: l.recordsAllTimeXi),
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                _LegendGrid(
                                  legends: view.hallOfFame,
                                  ranked: true,
                                  careerId: careerId,
                                  selectedId: selectedId,
                                ),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        12,
                                        10,
                                        12,
                                        6,
                                      ),
                                      child: Text(
                                        l.recordsGreatestSide(view.nationName),
                                        style: AppTypography.bodySmall
                                            .copyWith(
                                              color: AppColors.onSurfaceVariant,
                                            ),
                                      ),
                                    ),
                                    Expanded(
                                      child: _LegendGrid(
                                        legends: view.allTimeXi,
                                        ranked: false,
                                        careerId: careerId,
                                        selectedId: selectedId,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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

/// Legends as a table, in their ranked (or XI) order until the manager
/// sorts it.
class _LegendGrid extends StatelessWidget {
  const _LegendGrid({
    required this.legends,
    required this.ranked,
    required this.careerId,
    required this.selectedId,
  });

  final List<RankedLegend> legends;

  /// Whether the place in the hall of fame is shown (the XI has none).
  final bool ranked;
  final int careerId;
  final int? selectedId;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return DataGrid<RankedLegend>(
      rows: legends,
      columnSets: [_legendColumns(l, legends, ranked: ranked)],
      selected: legends.where((r) => r.playerId == selectedId).firstOrNull,
      onSelect: (r) =>
          openPlayer(context, careerId: careerId, playerId: r.playerId),
    );
  }
}

/// A legend's line: place, position, name and the record the ranking is
/// built from.
GridColumnSet<RankedLegend> _legendColumns(
  AppLocalizations l,
  List<RankedLegend> legends, {
  required bool ranked,
}) {
  return GridColumnSet<RankedLegend>(
    id: 'overview',
    label: l.gridViewOverview,
    columns: [
      if (ranked)
        GridColumn<RankedLegend>(
          id: 'rank',
          label: l.gridColRank,
          width: 56,
          sortKey: (r) => legends.indexOf(r),
          cell: (r) =>
              Text('${legends.indexOf(r) + 1}', style: TabletText.cellNumeric),
        ),
      GridColumn<RankedLegend>(
        id: 'pos',
        label: l.gridColPos,
        width: 64,
        sortKey: (r) => r.position.index,
        cell: (r) => TacticalChip(r.position.label),
      ),
      GridColumn<RankedLegend>(
        id: 'player',
        label: l.gridColPlayer,
        flex: 3,
        sortKey: (r) => r.name,
        cell: (r) => Text(r.name),
      ),
      GridColumn<RankedLegend>(
        id: 'caps',
        label: l.playerStatCaps,
        width: 64,
        numeric: true,
        sortKey: (r) => r.caps,
        cell: (r) => Text('${r.caps}'),
      ),
      GridColumn<RankedLegend>(
        id: 'goals',
        label: l.playerStatGoals,
        width: 64,
        numeric: true,
        sortKey: (r) => r.goals,
        cell: (r) => Text('${r.goals}'),
      ),
      GridColumn<RankedLegend>(
        id: 'assists',
        label: l.playerStatAssists,
        width: 72,
        numeric: true,
        sortKey: (r) => r.assists,
        cell: (r) => Text('${r.assists}'),
      ),
      GridColumn<RankedLegend>(
        id: 'motm',
        label: l.gridColMotm,
        width: 64,
        numeric: true,
        sortKey: (r) => r.motm,
        cell: (r) => Text('${r.motm}'),
      ),
      GridColumn<RankedLegend>(
        id: 'avg',
        label: l.gridColAvg,
        width: 64,
        numeric: true,
        sortKey: (r) => r.avgRating,
        cell: (r) => Text(r.avgRating.toStringAsFixed(2)),
      ),
    ],
  );
}
```

(`RankedLegend` comes from `domain/services/squad/legends.dart`, already imported; `TacticalChip` from `widgets.dart`. At 1024 wide the columns scroll sideways.)

- [ ] **Step 7: Register, run, expect PASS**

Add `Routes.legends,` to `tabletReadyPaths` in `lib/features/shell/tablet_shell.dart`.

Run: `flutter test test/widget/legends_tablet_test.dart test/golden/phone_guard_legends_test.dart test/widget/tablet_route_sweep_test.dart`
Expected: PASS, phone goldens unchanged.

- [ ] **Step 8: Analyze, full suite, commit**

Run: `flutter analyze && flutter test`

```bash
git add lib/features/records/legends_screen.dart lib/features/records/legends_tablet_layout.dart lib/features/shell/tablet_shell.dart test/widget/legends_tablet_test.dart
git commit -m "feat(tablet): the legends as grids beside the player's card

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

Then the batched review of Tasks 2, 4, 5 and 6 (see Review depth) before Task 7.

---

### Task 7: Head to head: the picker and the ledger beside every meeting

**risk: high (per-task review)**. State that survives a resize, a root picker dialog, and an extracted view the meetings page renders too.

**Files:**
- Create: `lib/features/records/head_to_head_tablet_layout.dart` (part of `head_to_head_screen.dart`)
- Modify: `lib/features/records/head_to_head_screen.dart`, `lib/features/records/h2h_meetings_screen.dart`, `lib/features/shell/tablet_shell.dart`
- Test: `test/golden/phone_guard_h2h_test.dart` (new, with goldens), `test/widget/h2h_tablet_test.dart` (new)

**Interfaces:**
- Produces: `HeadToHeadScreen.tabletLayoutKey`, `H2HMeetingsScreen.tabletLayoutKey`; `class H2hMeetingsView extends ConsumerWidget { const H2hMeetingsView({required int careerId, required int nationA, required int nationB, Widget? header, EdgeInsetsGeometry padding = const EdgeInsets.all(AppSpacing.marginMobile), Key? key}); }` (scrolls itself; give it a bounded height); `_Record` gains `bool showAllMeetings = true`; `_HeadToHeadScreenState._pickA(List<Nation>)`, `_pickB(List<Nation>)`, `_chooseB(int)`; private `_LedgerGrid`, `_ledgerColumns`.
- Consumes: `nationsProvider`, `careerByIdProvider`, `myHeadToHeadsProvider`, `headToHeadProvider`, `h2hMeetingsProvider` (the phone screens' reads, nothing else), `showAdaptiveSheet` (through the phone's `_pick`), `TabletPage`, `MasterDetail`, `MasterDetailPlaceholder`, `PanelBox`, `DataGrid`, `FlagDisc`, `l.sideHeadToHead`, `l.h2hMeetingsTitle`, `l.h2hPickOpponent`, `l.recordsPickTwoDifferent`, `l.recordsYourRecord`, `l.recordsPlayToBuildRecord`, `l.recordsHome`, `l.recordsAway`, `l.recordsVs`, `l.gridColOpponent`, `l.careerStatPlayedShort`, `l.careerStatWonShort`, `l.careerStatDrawnShort`, `l.careerStatLostShort`, `l.recordsGoalsLabel`.

- [ ] **Step 1: Pin the phone head to head and meetings**

Create `test/golden/phone_guard_h2h_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';

import '../helpers/history_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The phone head to head, pinned before the tablet layout is added beside
/// it: a fresh save's empty ledger, the fake ledger, a pairing picked from
/// it (the record with its link to every meeting), and the meetings page.
void main() {
  testWidgets('h2h_phone', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.headToHead}?careerId=${save.careerId}',
    );
    expect(find.text(enL.recordsPlayToBuildRecord), findsOneWidget);
    await expectAppGolden('goldens/h2h_phone.png');
  });

  testWidgets('h2h_ledger_phone_tall', (tester) async {
    final save = await seedSave(tester, overrides: fakeH2hOverrides());
    await pumpRoute(
      tester,
      save,
      '${Routes.headToHead}?careerId=${save.careerId}',
      size: const Size(390, 2400),
    );
    expect(find.text(fakeLedger().first.opponentName), findsOneWidget);
    await expectAppGolden('goldens/h2h_ledger_phone_tall.png');
  });

  testWidgets('h2h_pair_phone_tall', (tester) async {
    final save = await seedSave(tester, overrides: fakeH2hOverrides());
    await pumpRoute(
      tester,
      save,
      '${Routes.headToHead}?careerId=${save.careerId}',
      size: const Size(390, 2400),
    );
    await tester.tap(find.text(fakeLedger().first.opponentName));
    await settle(tester);
    expect(find.text(enL.recordsSeeAllMeetings), findsOneWidget);
    await expectAppGolden('goldens/h2h_pair_phone_tall.png');
  });

  testWidgets('h2h_meetings_phone_tall', (tester) async {
    final save = await seedSave(tester, overrides: fakeH2hOverrides());
    await pumpRoute(
      tester,
      save,
      '${Routes.h2hMeetings}?careerId=${save.careerId}'
      '&a=${save.nationId}&b=${rivalNation.id}',
      size: const Size(390, 2400),
    );
    expect(find.text('2–0'), findsOneWidget);
    await expectAppGolden('goldens/h2h_meetings_phone_tall.png');
  });
}
```

- [ ] **Step 2: Create the baseline, confirm it holds, commit it**

```bash
flutter test --update-goldens test/golden/phone_guard_h2h_test.dart
flutter test test/golden/phone_guard_h2h_test.dart
git add test/golden/phone_guard_h2h_test.dart test/golden/goldens/h2h_phone.png test/golden/goldens/h2h_ledger_phone_tall.png test/golden/goldens/h2h_pair_phone_tall.png test/golden/goldens/h2h_meetings_phone_tall.png
git commit -m "test(tablet): phone guard for head to head and the meetings page

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

- [ ] **Step 3: Write the failing tablet test**

Create `test/widget/h2h_tablet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/records/h2h_meetings_screen.dart';
import 'package:fnm/features/records/head_to_head_providers.dart';
import 'package:fnm/features/records/head_to_head_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/competition_fixtures.dart';
import '../helpers/history_fixtures.dart';
import '../helpers/seeded_save.dart';

Future<SeededSave> _open(WidgetTester tester, Size size) async {
  final save = await seedSave(
    tester,
    formFactor: FormFactor.tablet,
    overrides: fakeH2hOverrides(),
  );
  await pumpRoute(
    tester,
    save,
    '${Routes.headToHead}?careerId=${save.careerId}',
    size: size,
  );
  return save;
}

Finder get _ledger => find.byType(DataGrid<MyH2HLine>);

H2hMeetingsView _pair(WidgetTester tester) =>
    tester.widget<H2hMeetingsView>(find.byType(H2hMeetingsView));

String _path(SeededSave save) =>
    save.container.read(routerProvider).routeInformationProvider.value.uri.path;

/// Picks [name] through the picker dialog the [slot] text opens.
Future<void> _pickThroughDialog(
  WidgetTester tester,
  String slot,
  String name,
) async {
  await tester.tap(find.text(slot));
  await settle(tester);
  expect(find.byType(Dialog), findsOneWidget);
  await tester.enterText(
    find.descendant(of: find.byType(Dialog), matching: find.byType(TextField)),
    name,
  );
  await tester.pump();
  await tester.tap(
    find.descendant(of: find.byType(Dialog), matching: find.text(name)).first,
  );
  await settle(tester);
}

void main() {
  for (final size in kTabletSizes) {
    testWidgets('the slots and the ledger, the pane waiting, $size', (
      tester,
    ) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(HeadToHeadScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      // Home is the manager's nation; away is still to pick.
      expect(find.text(enL.recordsSelect), findsOneWidget);
      expect(tester.widget<DataGrid<MyH2HLine>>(_ledger).rows, fakeLedger());
      expect(find.text(enL.h2hPickOpponent), findsOneWidget);
      expect(
        tester.getCenter(_ledger).dx,
        lessThan(tester.getCenter(find.text(enL.h2hPickOpponent)).dx),
      );
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('an opponent from the ledger opens the pairing beside it', (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    final me = save.nations.firstWhere((n) => n.id == save.nationId);
    final line = fakeLedger().first;
    await tester.tap(
      find.descendant(of: _ledger, matching: find.text(line.opponentName)),
    );
    await settle(tester);
    expect(tester.takeException(), isNull);
    expect(_pair(tester).nationA, save.nationId);
    expect(_pair(tester).nationB, line.opponentId);
    // The record above the meetings, without the link to the meetings.
    expect(find.text(enL.recordsCodeWins(me.code)), findsOneWidget);
    expect(find.text(enL.recordsSeeAllMeetings), findsNothing);
    expect(find.text('2–0'), findsOneWidget);
    expect(tester.widget<DataGrid<MyH2HLine>>(_ledger).selected, line);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the picker dialog closes itself, not the page (Review Focus '
      '5)', (tester) async {
    final save = await _open(tester, kTabletSize);
    final other = realNationsById[fakeLedger()[1].opponentId]!;
    await _pickThroughDialog(tester, enL.recordsSelect, other.name);
    expect(find.byType(Dialog), findsNothing);
    expect(_path(save), Routes.headToHead);
    expect(_pair(tester).nationB, other.id);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the same nation twice asks for two different ones', (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    final me = save.nations.firstWhere((n) => n.id == save.nationId);
    await _pickThroughDialog(tester, enL.recordsSelect, me.name);
    expect(find.byType(H2hMeetingsView), findsNothing);
    expect(find.text(enL.recordsPickTwoDifferent), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a resize keeps the pairing (Review Focus 4)', (tester) async {
    await _open(tester, kTabletSize);
    final line = fakeLedger().first;
    await tester.tap(
      find.descendant(of: _ledger, matching: find.text(line.opponentName)),
    );
    await settle(tester);
    tester.view.physicalSize = const Size(900, 810);
    await settle(tester);
    expect(find.byKey(HeadToHeadScreen.tabletLayoutKey), findsNothing);
    // The phone's record of the same pairing, with its link.
    expect(find.text(enL.recordsSeeAllMeetings), findsOneWidget);
    tester.view.physicalSize = kTabletSize;
    await settle(tester);
    expect(find.byKey(HeadToHeadScreen.tabletLayoutKey), findsOneWidget);
    expect(_pair(tester).nationB, line.opponentId);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('every meeting on a page of its own', (tester) async {
    final save = await seedSave(
      tester,
      formFactor: FormFactor.tablet,
      overrides: fakeH2hOverrides(),
    );
    final me = save.nations.firstWhere((n) => n.id == save.nationId);
    await pumpRoute(
      tester,
      save,
      '${Routes.h2hMeetings}?careerId=${save.careerId}'
      '&a=${me.id}&b=${rivalNation.id}',
      size: kTabletSize,
    );
    expect(tester.takeException(), isNull);
    expect(find.byKey(H2HMeetingsScreen.tabletLayoutKey), findsOneWidget);
    expect(find.byType(PhoneWidthFrame), findsNothing);
    expect(find.byType(AppBar), findsNothing);
    expect(
      find.text(enL.recordsVersus(me.name, rivalNation.name)),
      findsOneWidget,
    );
    expect(find.text('2–0'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}
```

- [ ] **Step 4: Run it to verify it fails**

Run: `flutter test test/widget/h2h_tablet_test.dart`
Expected: FAIL to compile (`HeadToHeadScreen.tabletLayoutKey` and `H2hMeetingsView` do not exist).

- [ ] **Step 5: Extract `H2hMeetingsView`**

Replace the whole of `lib/features/records/h2h_meetings_screen.dart` with (the screen's old body moved verbatim into `H2hMeetingsView`; `_MeetingRow` unchanged):

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/util/app_date.dart';
import 'package:fnm/core/util/competition_label.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/features/nations/nation_select_providers.dart';
import 'package:fnm/features/records/head_to_head_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// Every past meeting between two nations — result, date and competition — the
/// detail behind a head-to-head record. Reached from the match preview or the
/// head-to-head screen.
class H2HMeetingsScreen extends ConsumerWidget {
  const H2HMeetingsScreen({
    required this.careerId,
    required this.nationA,
    required this.nationB,
    super.key,
  });

  static const Key tabletLayoutKey = Key('h2hMeetings.tabletLayout');

  final int careerId;
  final int nationA;
  final int nationB;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    if (TabletShellScope.isActive(context)) {
      // On a tablet: the same list under the shell's heading, at a reading
      // width rather than stretched across the content area.
      return TabletPage(
        scaffoldKey: tabletLayoutKey,
        title: l.h2hMeetingsTitle,
        onBack: () => context.canPop()
            ? context.pop()
            : context.go('${Routes.headToHead}?careerId=$careerId'),
        child: Align(
          alignment: Alignment.topLeft,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: PanelBox(
              child: H2hMeetingsView(
                careerId: careerId,
                nationA: nationA,
                nationB: nationB,
                padding: const EdgeInsets.all(AppSpacing.md),
              ),
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.canPop() ? context.pop() : context.go('/'),
        ),
        title: Text(
          l.recordsMeetings,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: H2hMeetingsView(
        careerId: careerId,
        nationA: nationA,
        nationB: nationB,
      ),
    );
  }
}

/// Every meeting between [nationA] and [nationB], newest first, under the
/// pairing's name and its won-drawn-lost line. The body of
/// [H2HMeetingsScreen], on its own so the tablet head to head can show it
/// beside the picker, with the pairing's record as its [header].
///
/// Scrolls itself; give it a bounded height.
class H2hMeetingsView extends ConsumerWidget {
  const H2hMeetingsView({
    required this.careerId,
    required this.nationA,
    required this.nationB,
    this.header,
    this.padding = const EdgeInsets.all(AppSpacing.marginMobile),
    super.key,
  });

  final int careerId;
  final int nationA;
  final int nationB;

  /// Shown above the meetings when there are any.
  final Widget? header;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final nationsAsync = ref.watch(nationsProvider);
    final meetingsAsync = ref.watch(
      h2hMeetingsProvider(
        (careerId: careerId, nationA: nationA, nationB: nationB),
      ),
    );
    final byId = <int, Nation>{
      for (final n in nationsAsync.valueOrNull ?? const <Nation>[]) n.id: n,
    };
    final aName = byId[nationA]?.name ?? '';
    final bName = byId[nationB]?.name ?? '';

    return meetingsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(l.recordsCouldNotLoad(e.toString()))),
      data: (meetings) {
        if (meetings.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Text(
                l.recordsNeverMet(aName, bName),
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
          );
        }
        final wins = meetings.where((m) => m.forA > m.forB).length;
        final draws = meetings.where((m) => m.forA == m.forB).length;
        final losses = meetings.where((m) => m.forA < m.forB).length;
        return ListView(
          padding: padding,
          children: [
            if (header case final top?) ...[
              top,
              const SizedBox(height: AppSpacing.md),
            ],
            Text(l.recordsVersus(aName, bName), style: AppTypography.titleMedium),
            Text(
              l.recordsMeetingsWdl(meetings.length, wins, draws, losses),
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            for (final m in meetings) _MeetingRow(meeting: m),
            const SizedBox(height: AppSpacing.xl),
          ],
        );
      },
    );
  }
}
```

and then append the existing `_MeetingRow` class to the file exactly as it is today (from `class _MeetingRow extends StatelessWidget {` to its closing brace, unchanged).

- [ ] **Step 6: Share the pair and the picker, hook in the layout**

In `lib/features/records/head_to_head_screen.dart`:

Replace the import `package:fnm/shared/tablet/adaptive_sheet.dart` with `package:fnm/shared/tablet/tablet.dart` (the barrel also exports `showAdaptiveSheet`; keeping both would be an unnecessary import), add `package:fnm/features/records/h2h_meetings_screen.dart`, and, below the imports, `part 'head_to_head_tablet_layout.dart';`.

In `HeadToHeadScreen` add:

```dart
  static const Key tabletLayoutKey = Key('headToHead.tabletLayout');
```

In `_HeadToHeadScreenState.build`, directly after the `if (!_seeded) { ... }` block (so both layouts start from the manager's own nation) and before `return Scaffold(`, add:

```dart
    if (TabletShellScope.isActive(context)) {
      return _HeadToHeadTabletLayout(state: this, nationsAsync: nationsAsync);
    }
```

Replace `_pick` with (the `mounted` check is the only change: the State may be gone when the dialog answers):

```dart
  Future<void> _pick(List<Nation> nations, ValueChanged<int> onPick) async {
    final id = await showAdaptiveSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      builder: (_) => _NationPickerSheet(nations: nations),
    );
    if (id != null && mounted) onPick(id);
  }

  /// The home slot's picker; the tablet's slots call these, so both layouts
  /// set the pair the same way.
  void _pickA(List<Nation> nations) =>
      _pick(nations, (id) => setState(() => _a = id));

  void _pickB(List<Nation> nations) =>
      _pick(nations, (id) => setState(() => _b = id));

  /// An opponent picked off the manager's ledger, as the away side.
  void _chooseB(int id) => setState(() => _b = id);
```

In `_Record`, make the constructor

```dart
  const _Record({
    required this.careerId,
    required this.a,
    required this.b,
    this.showAllMeetings = true,
  });
```

add the field

```dart
  /// Whether to offer the full list of meetings. Not where that list is
  /// already on show under the record (the tablet's pane).
  final bool showAllMeetings;
```

and replace the last two children of its data Column

```dart
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => context.push(
                  '${Routes.h2hMeetings}?careerId=$careerId'
                  '&a=${a.id}&b=${b.id}',
                ),
                icon: const Icon(Icons.history, size: 18),
                label: Text(l.recordsSeeAllMeetings),
              ),
            ),
```

with

```dart
            if (showAllMeetings) ...[
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => context.push(
                    '${Routes.h2hMeetings}?careerId=$careerId'
                    '&a=${a.id}&b=${b.id}',
                  ),
                  icon: const Icon(Icons.history, size: 18),
                  label: Text(l.recordsSeeAllMeetings),
                ),
              ),
            ],
```

- [ ] **Step 7: The layout**

Create `lib/features/records/head_to_head_tablet_layout.dart`:

```dart
part of 'head_to_head_screen.dart';

/// Head to head on a tablet: the two nations and the manager's own ledger
/// on the left; the picked pairing on the right, its record above every
/// meeting, newest first. The pair is the screen State's ([state]), so a
/// resize keeps it, and the slots open the phone's own picker.
class _HeadToHeadTabletLayout extends StatelessWidget {
  const _HeadToHeadTabletLayout({
    required this.state,
    required this.nationsAsync,
  });

  final _HeadToHeadScreenState state;
  final AsyncValue<List<Nation>> nationsAsync;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final careerId = state.widget.careerId;
    return TabletPage(
      scaffoldKey: HeadToHeadScreen.tabletLayoutKey,
      title: l.sideHeadToHead,
      onBack: () => context.canPop()
          ? context.pop()
          : context.go('${Routes.hub}?careerId=$careerId'),
      child: nationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l.recordsCouldNotLoadNations(e.toString()))),
        data: (nations) {
          final byId = {for (final n in nations) n.id: n};
          final a = byId[state._a];
          final b = byId[state._b];
          final same = a != null && b != null && a.id == b.id;
          return MasterDetail(
            initialFraction: 0.48,
            minFraction: 0.38,
            maxFraction: 0.58,
            minDetailWidth: 380,
            master: PanelBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          child: _NationSlot(
                            label: l.recordsHome,
                            nation: a,
                            onTap: () => state._pickA(nations),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                          ),
                          child: Text(
                            l.recordsVs,
                            style: AppTypography.titleMedium.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                        Expanded(
                          child: _NationSlot(
                            label: l.recordsAway,
                            nation: b,
                            onTap: () => state._pickB(nations),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 6),
                    child: Text(
                      l.recordsYourRecord,
                      style: TabletText.sectionLabel,
                    ),
                  ),
                  Expanded(
                    child: _LedgerGrid(
                      careerId: careerId,
                      picked: state._b,
                      onPick: state._chooseB,
                    ),
                  ),
                ],
              ),
            ),
            detail: PanelBox(
              child: a != null && b != null && !same
                  ? H2hMeetingsView(
                      // A new pairing is a new list: no scroll carried over.
                      key: ValueKey((a.id, b.id)),
                      careerId: careerId,
                      nationA: a.id,
                      nationB: b.id,
                      padding: const EdgeInsets.all(AppSpacing.md),
                      header: _Record(
                        careerId: careerId,
                        a: a,
                        b: b,
                        showAllMeetings: false,
                      ),
                    )
                  : MasterDetailPlaceholder(
                      text: same
                          ? l.recordsPickTwoDifferent
                          : l.h2hPickOpponent,
                    ),
            ),
          );
        },
      ),
    );
  }
}

/// The manager's own record against everyone his nation has met, as a
/// sortable table; a row picks that opponent as the away side.
class _LedgerGrid extends ConsumerWidget {
  const _LedgerGrid({
    required this.careerId,
    required this.picked,
    required this.onPick,
  });

  final int careerId;

  /// The away side's id, lit in the table when it is one of these lines.
  final int? picked;
  final ValueChanged<int> onPick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(myHeadToHeadsProvider(careerId));
    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) =>
          Center(child: Text(l.recordsCouldNotLoadYourRecord(e.toString()))),
      data: (lines) {
        if (lines.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text(
                l.recordsPlayToBuildRecord,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
          );
        }
        return DataGrid<MyH2HLine>(
          rows: lines,
          columnSets: [_ledgerColumns(l)],
          selected: lines.where((x) => x.opponentId == picked).firstOrNull,
          onSelect: (x) => onPick(x.opponentId),
        );
      },
    );
  }
}

/// The ledger's one view: opponent, played, won, drawn, lost, goals.
GridColumnSet<MyH2HLine> _ledgerColumns(AppLocalizations l) {
  return GridColumnSet<MyH2HLine>(
    id: 'overview',
    label: l.gridViewOverview,
    columns: [
      GridColumn<MyH2HLine>(
        id: 'opponent',
        label: l.gridColOpponent,
        flex: 3,
        sortKey: (x) => x.opponentName,
        cell: (x) => Row(
          children: [
            FlagDisc(x.opponentCode, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Flexible(
              child: Text(
                x.opponentName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      GridColumn<MyH2HLine>(
        id: 'played',
        label: l.careerStatPlayedShort,
        width: 40,
        numeric: true,
        sortKey: (x) => x.played,
        cell: (x) => Text('${x.played}'),
      ),
      GridColumn<MyH2HLine>(
        id: 'won',
        label: l.careerStatWonShort,
        width: 40,
        numeric: true,
        sortKey: (x) => x.wins,
        cell: (x) => Text(
          '${x.wins}',
          style: TabletText.cellNumeric.copyWith(color: AppColors.positive),
        ),
      ),
      GridColumn<MyH2HLine>(
        id: 'drawn',
        label: l.careerStatDrawnShort,
        width: 40,
        numeric: true,
        sortKey: (x) => x.draws,
        cell: (x) => Text(
          '${x.draws}',
          style: TabletText.cellNumeric.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ),
      GridColumn<MyH2HLine>(
        id: 'lost',
        label: l.careerStatLostShort,
        width: 40,
        numeric: true,
        sortKey: (x) => x.losses,
        cell: (x) => Text(
          '${x.losses}',
          style: TabletText.cellNumeric.copyWith(color: AppColors.error),
        ),
      ),
      GridColumn<MyH2HLine>(
        id: 'goals',
        label: l.recordsGoalsLabel,
        width: 64,
        numeric: true,
        sortKey: (x) => x.goalsFor - x.goalsAgainst,
        cell: (x) => Text('${x.goalsFor}–${x.goalsAgainst}'),
      ),
    ],
  );
}
```

- [ ] **Step 8: Register, run, expect PASS**

Add `Routes.headToHead,` and `Routes.h2hMeetings,` to `tabletReadyPaths` in `lib/features/shell/tablet_shell.dart`.

Run: `flutter test test/widget/h2h_tablet_test.dart test/golden/phone_guard_h2h_test.dart test/widget/tablet_route_sweep_test.dart`
Expected: PASS, phone goldens unchanged.

- [ ] **Step 9: Analyze, full suite, commit**

Run: `flutter analyze && flutter test`

```bash
git add lib/features/records/head_to_head_screen.dart lib/features/records/head_to_head_tablet_layout.dart lib/features/records/h2h_meetings_screen.dart lib/features/shell/tablet_shell.dart test/widget/h2h_tablet_test.dart
git commit -m "feat(tablet): head to head, the picker and the ledger beside every meeting

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 8: Achievements and challenges: the list beside a grid of the cards

**risk: low (batched review)**. Read-only (the achievements provider's reconcile is the phone's, unchanged).

**Files:**
- Create: `lib/features/achievements/achievements_tablet_layout.dart` (part of `achievements_screen.dart`), `lib/features/achievements/challenges_tablet_layout.dart` (part of `challenges_screen.dart`)
- Modify: `lib/features/achievements/achievements_screen.dart`, `lib/features/achievements/challenges_screen.dart`, `lib/features/shell/tablet_shell.dart`
- Test: `test/golden/phone_guard_achievements_test.dart` (new, with goldens), `test/widget/achievements_tablet_test.dart` (new)

**Interfaces:**
- Produces: `AchievementsScreen.tabletLayoutKey`, `ChallengesScreen.tabletLayoutKey`; private `_byCategory(List<AchievementView>)`, `_AchievementCard`, `_ChallengeCard`, `_ChallengeSection`, `_sections(AppLocalizations, List<ChallengeView>)`. Row keys: `ValueKey('achievements.category.<AchievementCategory.name>')`, `ValueKey('challenges.section.<save|ChallengeTier.name>')`.
- Consumes: `achievementsViewProvider(careerId)`, `challengesViewProvider(careerId)` (the phone screens' reads, nothing else), `TabletPage`, `Panel`, `ColumnFlow`, `TabletListRow`, `achievementCategoryLabel`, `achievementText`, `challengeTierLabel`, `challengeText`, `l.sideAchievements`, `l.careerChallenges`, `l.achievementsUnlockedCount`, `l.achievementsConqueredCount`, `l.achievementsHardestTests`, `l.achievementsThisSave`.

- [ ] **Step 1: Pin the phone achievements and challenges**

Create `test/golden/phone_guard_achievements_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';

import '../helpers/seeded_save.dart';

/// The phone achievements and challenges, pinned before the tablet layouts
/// are added beside them: a fresh save's lists, the achievements as the
/// screen opens and both lists in a tall window.
void main() {
  testWidgets('achievements_phone', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.achievements}?careerId=${save.careerId}',
    );
    expect(find.text(enL.achievementsChallengesHeading), findsWidgets);
    await expectAppGolden('goldens/achievements_phone.png');
  });

  testWidgets('achievements_phone_tall', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.achievements}?careerId=${save.careerId}',
      size: const Size(390, 2400),
    );
    await expectAppGolden('goldens/achievements_phone_tall.png');
  });

  testWidgets('challenges_phone_tall', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.challenges}?careerId=${save.careerId}',
      size: const Size(390, 2400),
    );
    expect(find.text(enL.achievementsHardestTests), findsOneWidget);
    await expectAppGolden('goldens/challenges_phone_tall.png');
  });
}
```

- [ ] **Step 2: Create the baseline, confirm it holds, commit it**

```bash
flutter test --update-goldens test/golden/phone_guard_achievements_test.dart
flutter test test/golden/phone_guard_achievements_test.dart
git add test/golden/phone_guard_achievements_test.dart test/golden/goldens/achievements_phone.png test/golden/goldens/achievements_phone_tall.png test/golden/goldens/challenges_phone_tall.png
git commit -m "test(tablet): phone guard for achievements and challenges

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

- [ ] **Step 3: Write the failing tablet test**

Create `test/widget/achievements_tablet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/services/achievements/achievements.dart';
import 'package:fnm/domain/services/achievements/challenges.dart';
import 'package:fnm/features/achievements/achievement_providers.dart';
import 'package:fnm/features/achievements/achievements_screen.dart';
import 'package:fnm/features/achievements/challenge_providers.dart';
import 'package:fnm/features/achievements/challenges_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/seeded_save.dart';

Future<SeededSave> _open(WidgetTester tester, String path, Size size) async {
  final save = await seedSave(tester, formFactor: FormFactor.tablet);
  await pumpRoute(tester, save, '$path?careerId=${save.careerId}', size: size);
  return save;
}

String _path(SeededSave save) =>
    save.container.read(routerProvider).routeInformationProvider.value.uri.path;

/// The panel headed [title] (panel headers are upper case).
Finder _panel(String title) => find
    .ancestor(
      of: find.text(title.toUpperCase()).first,
      matching: find.byType(Panel),
    )
    .first;

String _firstTitle(AchievementCategory c) => achievementText(
  enL,
  AchievementCatalog.all.firstWhere((a) => a.category == c),
).title;

void main() {
  for (final size in kTabletSizes) {
    testWidgets('achievements: the categories beside the first one, $size', (
      tester,
    ) async {
      await _open(tester, Routes.achievements, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(AchievementsScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      // The layout opens on the first category, in the enum's order, that
      // has any achievement.
      final first = AchievementCategory.values.firstWhere(
        (c) => AchievementCatalog.all.any((a) => a.category == c),
      );
      final list = tester.getRect(
        find.byKey(ValueKey('achievements.category.${first.name}')),
      );
      final open = tester.getRect(
        _panel(achievementCategoryLabel(enL, first)),
      );
      expect(open.left, greaterThan(list.right));
      expect(find.text(_firstTitle(first)), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('challenges: the tiers beside the first one, $size', (
      tester,
    ) async {
      await _open(tester, Routes.challenges, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(ChallengesScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      expect(find.text(enL.achievementsHardestTests), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('a category opens beside the list', (tester) async {
    await _open(tester, Routes.achievements, kTabletSize);
    const picked = AchievementCategory.titles;
    expect(find.text(_firstTitle(picked)), findsNothing);
    await tester.tap(
      find.byKey(ValueKey('achievements.category.${picked.name}')),
    );
    await settle(tester);
    expect(_panel(achievementCategoryLabel(enL, picked)), findsOneWidget);
    expect(find.text(_firstTitle(picked)), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the heading goes to the challenges', (tester) async {
    final save = await _open(tester, Routes.achievements, kTabletSize);
    await tester.tap(find.text(enL.careerChallenges));
    await settle(tester);
    expect(_path(save), Routes.challenges);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a tier opens beside the list; back is the achievements', (
    tester,
  ) async {
    final save = await _open(tester, Routes.challenges, kTabletSize);
    late List<ChallengeView> views;
    await tester.runAsync(() async {
      final sub = save.container.listen(
        challengesViewProvider(save.careerId).future,
        (_, _) {},
      );
      views = await sub.read();
      sub.close();
    });
    final silver = views.firstWhere(
      (v) => !v.def.procedural && v.def.tier == ChallengeTier.silver,
    );
    final title = challengeText(enL, silver.def, silver.target).title;
    expect(find.text(title), findsNothing);
    await tester.tap(find.byKey(const ValueKey('challenges.section.silver')));
    await settle(tester);
    expect(find.text(title), findsOneWidget);
    await tester.tap(find.byKey(TabletScreenHeader.backKey));
    await settle(tester);
    expect(_path(save), Routes.achievements);
    await tester.pumpWidget(const SizedBox());
  });
}
```

- [ ] **Step 4: Run it to verify it fails**

Run: `flutter test test/widget/achievements_tablet_test.dart`
Expected: FAIL to compile (`AchievementsScreen.tabletLayoutKey` does not exist).

- [ ] **Step 5: Achievements: share the card and the grouping, hook in the layout**

In `lib/features/achievements/achievements_screen.dart`:

Add the import `package:fnm/shared/tablet/tablet.dart` and, below the imports, `part 'achievements_tablet_layout.dart';`.

In `AchievementsScreen` add:

```dart
  static const Key tabletLayoutKey = Key('achievements.tabletLayout');
```

Make the first lines of `AchievementsScreen.build`:

```dart
    if (TabletShellScope.isActive(context)) {
      return _AchievementsTabletLayout(careerId: careerId);
    }
```

In the phone `data:` branch replace

```dart
          final grouped = <AchievementCategory, List<AchievementView>>{};
          for (final v in views) {
            (grouped[v.def.category] ??= []).add(v);
          }
```

with

```dart
          final grouped = _byCategory(views);
```

and add, directly above `class _AchievementTile`:

```dart
/// [views] by category, each in the catalogue's order.
Map<AchievementCategory, List<AchievementView>> _byCategory(
  List<AchievementView> views,
) {
  final grouped = <AchievementCategory, List<AchievementView>>{};
  for (final v in views) {
    (grouped[v.def.category] ??= []).add(v);
  }
  return grouped;
}
```

Replace the whole of `_AchievementTile.build` with

```dart
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
    child: _AchievementCard(view: view),
  );
```

and add, directly below `_AchievementTile`, the card it used to hold, moved verbatim:

```dart
/// One achievement: unlocked or locked, its tier, what it asks, and how far
/// along a tally one is.
class _AchievementCard extends StatelessWidget {
  const _AchievementCard({required this.view});

  final AchievementView view;

  @override
  Widget build(BuildContext context) {
    final text = achievementText(AppLocalizations.of(context), view.def);
    final earned = view.earned;
    final showProgress = !earned && view.current != null && view.target != null;
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            earned ? Icons.emoji_events : Icons.lock_outline,
            color: earned ? AppColors.primary : AppColors.onSurfaceVariant,
            size: 24,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        text.title,
                        style: AppTypography.titleMedium.copyWith(
                          color: earned
                              ? AppColors.onSurface
                              : AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _TierBadge(view.def.tier, dimmed: !earned),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  text.description,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                if (showProgress) ...[
                  const SizedBox(height: AppSpacing.sm),
                  _ProgressBar(current: view.current!, target: view.target!),
                ],
              ],
            ),
          ),
          if (earned)
            const Padding(
              padding: EdgeInsets.only(left: AppSpacing.sm),
              child: Icon(
                Icons.check_circle,
                color: AppColors.positive,
                size: 20,
              ),
            ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 6: Challenges: share the card, hook in the layout**

In `lib/features/achievements/challenges_screen.dart`:

Add the import `package:fnm/shared/tablet/tablet.dart` and, below the imports, `part 'challenges_tablet_layout.dart';`.

In `ChallengesScreen` add:

```dart
  static const Key tabletLayoutKey = Key('challenges.tabletLayout');
```

Make the first lines of `ChallengesScreen.build`:

```dart
    if (TabletShellScope.isActive(context)) {
      return _ChallengesTabletLayout(careerId: careerId);
    }
```

Replace the whole of `_ChallengeTile.build` with

```dart
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
    child: _ChallengeCard(view: view),
  );
```

and add, directly below `_ChallengeTile`, the card it used to hold, moved verbatim:

```dart
/// One challenge: done or not, how brutal, what it asks, and the progress
/// bar towards it.
class _ChallengeCard extends StatelessWidget {
  const _ChallengeCard({required this.view});

  final ChallengeView view;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final text = challengeText(l, view.def, view.target);
    final complete = view.complete;
    final brutal = view.def.brutal;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                complete
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked,
                color: complete
                    ? AppColors.positive
                    : AppColors.onSurfaceVariant,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  text.title,
                  style: AppTypography.titleMedium.copyWith(
                    color: complete ? AppColors.positive : null,
                  ),
                ),
              ),
              if (brutal)
                TacticalChip(l.achievementsBrutalBadge, emphasized: true),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            text.description,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: AppRadii.smAll,
                  child: LinearProgressIndicator(
                    value: view.target == 0 ? 1 : view.current / view.target,
                    minHeight: 6,
                    backgroundColor: AppColors.surfaceContainerHigh,
                    valueColor: AlwaysStoppedAnimation(
                      complete ? AppColors.positive : AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                '${view.current}/${view.target}',
                style: AppTypography.labelMedium.copyWith(
                  color: complete
                      ? AppColors.positive
                      : AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 7: The layouts**

Create `lib/features/achievements/achievements_tablet_layout.dart`:

```dart
part of 'achievements_screen.dart';

/// The achievements on a tablet: the categories down the left with how many
/// of each are unlocked, the picked category's achievements beside them as a
/// grid of the phone's cards. The challenges are one button away in the
/// heading. The phone's one read, nothing more.
class _AchievementsTabletLayout extends ConsumerStatefulWidget {
  const _AchievementsTabletLayout({required this.careerId});

  final int careerId;

  @override
  ConsumerState<_AchievementsTabletLayout> createState() =>
      _AchievementsTabletLayoutState();
}

class _AchievementsTabletLayoutState
    extends ConsumerState<_AchievementsTabletLayout> {
  /// The category open on the right; the first one until the manager picks.
  AchievementCategory? _picked;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final careerId = widget.careerId;
    final viewAsync = ref.watch(achievementsViewProvider(careerId));
    return TabletPage(
      scaffoldKey: AchievementsScreen.tabletLayoutKey,
      title: l.sideAchievements,
      onBack: () => context.canPop()
          ? context.pop()
          : context.go('${Routes.hub}?careerId=$careerId'),
      trailing: OutlinedButton.icon(
        onPressed: () => context.go('${Routes.challenges}?careerId=$careerId'),
        icon: const Icon(Icons.local_fire_department_rounded, size: 18),
        label: Text(l.careerChallenges),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.outlineVariant),
        ),
      ),
      child: viewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l.achievementsCouldNotLoad(e.toString()))),
        data: (views) {
          final grouped = _byCategory(views);
          final categories = [
            for (final c in AchievementCategory.values)
              if (grouped.containsKey(c)) c,
          ];
          if (categories.isEmpty) return const SizedBox.shrink();
          final picked = categories.contains(_picked)
              ? _picked!
              : categories.first;
          final earned = views.where((v) => v.earned).length;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 280,
                child: Panel(
                  title: l.achievementsUnlockedCount(earned, views.length),
                  expand: true,
                  padding: EdgeInsets.zero,
                  child: ListView(
                    children: [
                      for (final c in categories)
                        TabletListRow(
                          key: ValueKey('achievements.category.${c.name}'),
                          label: achievementCategoryLabel(l, c),
                          trailing:
                              '${grouped[c]!.where((v) => v.earned).length}'
                              '/${grouped[c]!.length}',
                          selected: c == picked,
                          onTap: () => setState(() => _picked = c),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Panel(
                  title: achievementCategoryLabel(l, picked),
                  expand: true,
                  padding: EdgeInsets.zero,
                  child: SingleChildScrollView(
                    // A new category starts at its top.
                    key: ValueKey(picked),
                    padding: const EdgeInsets.all(12),
                    child: ColumnFlow(
                      minTileWidth: 300,
                      maxColumns: 2,
                      gap: AppSpacing.sm,
                      children: [
                        for (final v in grouped[picked]!)
                          _AchievementCard(view: v),
                      ],
                    ),
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
```

Create `lib/features/achievements/challenges_tablet_layout.dart`:

```dart
part of 'challenges_screen.dart';

/// One block of the challenges list: this save's own, or a tier of the
/// fixed ladder.
typedef _ChallengeSection = ({
  String id,
  String label,
  IconData icon,
  Color color,
  List<ChallengeView> views,
});

/// The phone's sections, in its order: this save's challenges first, then
/// the ladder bronze to legendary.
List<_ChallengeSection> _sections(
  AppLocalizations l,
  List<ChallengeView> views,
) {
  final procedural = views.where((v) => v.def.procedural).toList();
  final byTier = <ChallengeTier, List<ChallengeView>>{};
  for (final v in views.where((v) => !v.def.procedural)) {
    (byTier[v.def.tier] ??= []).add(v);
  }
  return [
    if (procedural.isNotEmpty)
      (
        id: 'save',
        label: l.achievementsThisSave,
        icon: Icons.auto_awesome_rounded,
        color: AppColors.primary,
        views: procedural,
      ),
    for (final tier in ChallengeTier.values)
      if (byTier[tier] case final list?)
        (
          id: tier.name,
          label: challengeTierLabel(l, tier),
          icon: Icons.workspace_premium_rounded,
          color: _tierColor(tier),
          views: list,
        ),
  ];
}

/// The challenges on a tablet: the tiers down the left with how many of each
/// are done, the picked tier's challenges beside them as a grid of the
/// phone's cards. The phone's one read, nothing more.
class _ChallengesTabletLayout extends ConsumerStatefulWidget {
  const _ChallengesTabletLayout({required this.careerId});

  final int careerId;

  @override
  ConsumerState<_ChallengesTabletLayout> createState() =>
      _ChallengesTabletLayoutState();
}

class _ChallengesTabletLayoutState
    extends ConsumerState<_ChallengesTabletLayout> {
  /// The section open on the right, by id; the first until the manager picks.
  String? _picked;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final careerId = widget.careerId;
    final viewAsync = ref.watch(challengesViewProvider(careerId));
    return TabletPage(
      scaffoldKey: ChallengesScreen.tabletLayoutKey,
      title: l.careerChallenges,
      onBack: () => context.canPop()
          ? context.pop()
          : context.go('${Routes.achievements}?careerId=$careerId'),
      child: viewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l.achievementsCouldNotLoad(e.toString()))),
        data: (views) {
          final sections = _sections(l, views);
          if (sections.isEmpty) return const SizedBox.shrink();
          final picked = sections.firstWhere(
            (s) => s.id == _picked,
            orElse: () => sections.first,
          );
          final done = views.where((v) => v.complete).length;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 280,
                child: Panel(
                  title: l.achievementsConqueredCount(done, views.length),
                  expand: true,
                  padding: EdgeInsets.zero,
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                        child: Text(
                          l.achievementsHardestTests,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                      for (final s in sections)
                        TabletListRow(
                          key: ValueKey('challenges.section.${s.id}'),
                          leading: Icon(s.icon, size: 18, color: s.color),
                          label: s.label,
                          trailing:
                              '${s.views.where((v) => v.complete).length}'
                              '/${s.views.length}',
                          selected: s.id == picked.id,
                          onTap: () => setState(() => _picked = s.id),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Panel(
                  title: picked.label,
                  expand: true,
                  padding: EdgeInsets.zero,
                  child: SingleChildScrollView(
                    // A new section starts at its top.
                    key: ValueKey(picked.id),
                    padding: const EdgeInsets.all(12),
                    child: ColumnFlow(
                      minTileWidth: 300,
                      maxColumns: 2,
                      gap: AppSpacing.sm,
                      children: [
                        for (final v in picked.views) _ChallengeCard(view: v),
                      ],
                    ),
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
```

(`ChallengeTier` comes from `domain/services/achievements/challenges.dart`, `ChallengeView`, `challengeText` and `challengeTierLabel` from `challenge_providers.dart`, all already imported by `challenges_screen.dart`; `_tierColor` is the phone file's.)

- [ ] **Step 8: Register, run, expect PASS**

Add `Routes.achievements,` and `Routes.challenges,` to `tabletReadyPaths` in `lib/features/shell/tablet_shell.dart`.

Run: `flutter test test/widget/achievements_tablet_test.dart test/golden/phone_guard_achievements_test.dart test/widget/tablet_route_sweep_test.dart`
Expected: PASS, phone goldens unchanged.

- [ ] **Step 9: Analyze, full suite, commit**

Run: `flutter analyze && flutter test`

```bash
git add lib/features/achievements/achievements_screen.dart lib/features/achievements/achievements_tablet_layout.dart lib/features/achievements/challenges_screen.dart lib/features/achievements/challenges_tablet_layout.dart lib/features/shell/tablet_shell.dart test/widget/achievements_tablet_test.dart
git commit -m "feat(tablet): achievements and challenges, the list beside a grid of cards

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 9: The career summary and the manager's career as two columns

**risk: low (batched review)**. Read-only.

**Files:**
- Create: `lib/features/career/career_summary_tablet_layout.dart` (part of `career_summary_screen.dart`), `lib/features/career/manager_history_tablet_layout.dart` (part of `manager_history_screen.dart`)
- Modify: `lib/features/career/career_summary_screen.dart`, `lib/features/career/manager_history_screen.dart`, `lib/features/shell/tablet_shell.dart`
- Test: `test/golden/phone_guard_career_pages_test.dart` (new, with goldens), `test/widget/career_pages_tablet_test.dart` (new)

**Interfaces:**
- Produces: `CareerSummaryScreen.tabletLayoutKey`, `ManagerHistoryScreen.tabletLayoutKey`; `class CareerSummaryView extends ConsumerWidget { const CareerSummaryView({required int careerId, EdgeInsetsGeometry padding = const EdgeInsets.all(AppSpacing.marginMobile), Key? key}); }` (the phone screen's body; scrolls itself; give it a bounded height). Tasks 10 and 12 render it in panes.
- Consumes: `careerSummaryProvider`, `careerStatsProvider` (through `_CareerStatsSection`), `managerHistoryProvider`, `teamOverallHistoryProvider` (the phone screens' reads, nothing else), `TabletPage`, `Panel`, `TeamOverallHistoryCard`, `l.careerSummaryTitle`, `l.careerManagerCareer`, `l.careerTournamentHistory`, `l.careerTrophyCabinet`, `l.careerCycleByCycle`, `l.careerNoTournamentsYet`.

- [ ] **Step 1: Pin the phone career summary and manager's career**

Create `test/golden/phone_guard_career_pages_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';

import '../helpers/seeded_save.dart';

/// The phone career summary and manager's career, pinned before the tablet
/// layouts are added beside them, each whole in a tall window.
void main() {
  testWidgets('career_summary_phone_tall', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.careerSummary}?careerId=${save.careerId}',
      size: const Size(390, 2400),
    );
    expect(find.text(enL.careerTournamentHistory), findsOneWidget);
    await expectAppGolden('goldens/career_summary_phone_tall.png');
  });

  testWidgets('manager_history_phone_tall', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.managerHistory}?careerId=${save.careerId}',
      size: const Size(390, 2400),
    );
    expect(find.text(enL.careerCycleByCycle), findsOneWidget);
    await expectAppGolden('goldens/manager_history_phone_tall.png');
  });
}
```

- [ ] **Step 2: Create the baseline, confirm it holds, commit it**

```bash
flutter test --update-goldens test/golden/phone_guard_career_pages_test.dart
flutter test test/golden/phone_guard_career_pages_test.dart
git add test/golden/phone_guard_career_pages_test.dart test/golden/goldens/career_summary_phone_tall.png test/golden/goldens/manager_history_phone_tall.png
git commit -m "test(tablet): phone guard for the career summary and manager's career

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

- [ ] **Step 3: Write the failing tablet test**

Create `test/widget/career_pages_tablet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/career/career_summary_screen.dart';
import 'package:fnm/features/career/manager_history_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/seeded_save.dart';

Future<SeededSave> _open(WidgetTester tester, String path, Size size) async {
  final save = await seedSave(tester, formFactor: FormFactor.tablet);
  await pumpRoute(tester, save, '$path?careerId=${save.careerId}', size: size);
  return save;
}

String _path(SeededSave save) =>
    save.container.read(routerProvider).routeInformationProvider.value.uri.path;

void main() {
  for (final size in kTabletSizes) {
    testWidgets('the summary: the record left, the tournaments right, $size', (
      tester,
    ) async {
      await _open(tester, Routes.careerSummary, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(CareerSummaryScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      // The cabinet heading is in the left column; the history is a panel.
      final cabinet = tester.getRect(find.text(enL.careerTrophyCabinet));
      final history = tester.getRect(
        find.text(enL.careerTournamentHistory.toUpperCase()),
      );
      expect(history.left, greaterThan(cabinet.right));
      expect(find.text(enL.careerNoTournamentsYet), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets("the manager's career: the totals left, the cycles right, "
        '$size', (tester) async {
      await _open(tester, Routes.managerHistory, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(ManagerHistoryScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      final cabinet = tester.getRect(find.text(enL.careerTrophyCabinet));
      final cycles = tester.getRect(find.text(enL.careerCycleByCycle));
      expect(cycles.left, greaterThan(cabinet.right));
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('both go back to the Career page', (tester) async {
    final save = await _open(tester, Routes.careerSummary, kTabletSize);
    await tester.tap(find.byKey(TabletScreenHeader.backKey));
    await settle(tester);
    expect(_path(save), Routes.careers);
    save.container
        .read(routerProvider)
        .go('${Routes.managerHistory}?careerId=${save.careerId}');
    await settle(tester);
    await tester.tap(find.byKey(TabletScreenHeader.backKey));
    await settle(tester);
    expect(_path(save), Routes.careers);
    await tester.pumpWidget(const SizedBox());
  });
}
```

- [ ] **Step 4: Run it to verify it fails**

Run: `flutter test test/widget/career_pages_tablet_test.dart`
Expected: FAIL to compile (`CareerSummaryScreen.tabletLayoutKey` does not exist).

- [ ] **Step 5: Extract `CareerSummaryView`, hook in the layouts**

In `lib/features/career/career_summary_screen.dart`:

Add the import `package:fnm/shared/tablet/tablet.dart` and, below the imports, `part 'career_summary_tablet_layout.dart';`.

Replace the whole `CareerSummaryScreen` class with these two (the screen's old body moved verbatim into `CareerSummaryView`, its padding a parameter):

```dart
/// The manager's career at a glance: team, world standing, overall record, a
/// trophy cabinet, and a finish-by-finish tournament history.
class CareerSummaryScreen extends ConsumerWidget {
  const CareerSummaryScreen({required this.careerId, super.key});

  static const Key tabletLayoutKey = Key('careerSummary.tabletLayout');

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (TabletShellScope.isActive(context)) {
      return _CareerSummaryTabletLayout(careerId: careerId);
    }
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.go('${Routes.hub}?careerId=$careerId'),
        ),
        title: Text(
          l.careerTitle,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: CareerSummaryView(careerId: careerId),
    );
  }
}

/// A career's summary in one column: the header, the record, the numbers,
/// the trophy cabinet and the tournament history. The body of
/// [CareerSummaryScreen], on its own so the tablet's Career page and saves
/// list can show it in a pane.
///
/// Scrolls itself; give it a bounded height.
class CareerSummaryView extends ConsumerWidget {
  const CareerSummaryView({
    required this.careerId,
    this.padding = const EdgeInsets.all(AppSpacing.marginMobile),
    super.key,
  });

  final int careerId;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(careerSummaryProvider(careerId));
    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(l.careerCouldNotLoadCareer('$e'))),
      data: (s) {
        if (s == null) return Center(child: Text(l.careerNoCareer));
        return ListView(
          padding: padding,
          children: [
            _Header(s),
            const SizedBox(height: AppSpacing.sm),
            _RecordCard(s),
            _CareerStatsSection(careerId),
            const SizedBox(height: AppSpacing.md),
            Text(
              l.careerTrophyCabinet,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            _TrophyCabinet(s),
            if (s.titles.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              _TitlesList(s.titles),
            ],
            const SizedBox(height: AppSpacing.md),
            Text(
              l.careerTournamentHistory,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            if (s.runs.isEmpty)
              AppCard(child: Text(l.careerNoTournamentsYet))
            else
              for (final r in s.runs) _RunRow(r, showNation: s.spansNations),
            const SizedBox(height: AppSpacing.xl),
          ],
        );
      },
    );
  }
}
```

In `lib/features/career/manager_history_screen.dart`:

Add the import `package:fnm/shared/tablet/tablet.dart` and, below the imports, `part 'manager_history_tablet_layout.dart';`.

In `ManagerHistoryScreen` add:

```dart
  static const Key tabletLayoutKey = Key('managerHistory.tabletLayout');
```

Make the first lines of `ManagerHistoryScreen.build`:

```dart
    if (TabletShellScope.isActive(context)) {
      return _ManagerHistoryTabletLayout(careerId: careerId);
    }
```

The phone tree is not otherwise touched.

- [ ] **Step 6: The layouts**

Create `lib/features/career/career_summary_tablet_layout.dart`:

```dart
part of 'career_summary_screen.dart';

/// The career summary on a tablet: the header, the record, the numbers and
/// the trophy cabinet in a column on the left; every tournament, newest
/// first, in a panel on the right. The phone's sections and reads, laid side
/// by side.
class _CareerSummaryTabletLayout extends ConsumerWidget {
  const _CareerSummaryTabletLayout({required this.careerId});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(careerSummaryProvider(careerId));
    return TabletPage(
      scaffoldKey: CareerSummaryScreen.tabletLayoutKey,
      title: l.careerSummaryTitle,
      onBack: () => context.canPop()
          ? context.pop()
          : context.go('${Routes.careers}?careerId=$careerId'),
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.careerCouldNotLoadCareer('$e'))),
        data: (s) {
          if (s == null) return Center(child: Text(l.careerNoCareer));
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 5,
                child: ListView(
                  children: [
                    _Header(s),
                    const SizedBox(height: AppSpacing.sm),
                    _RecordCard(s),
                    _CareerStatsSection(careerId),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      l.careerTrophyCabinet,
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _TrophyCabinet(s),
                    if (s.titles.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.sm),
                      _TitlesList(s.titles),
                    ],
                    const SizedBox(height: AppSpacing.md),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                flex: 6,
                child: Panel(
                  title: l.careerTournamentHistory,
                  expand: true,
                  padding: EdgeInsets.zero,
                  child: s.runs.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(l.careerNoTournamentsYet),
                        )
                      : ListView(
                          padding: const EdgeInsets.all(12),
                          children: [
                            for (final r in s.runs)
                              _RunRow(r, showNation: s.spansNations),
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
```

Create `lib/features/career/manager_history_tablet_layout.dart`:

```dart
part of 'manager_history_screen.dart';

/// The manager's career on a tablet: his totals, record results and cabinet
/// with the strength curve under them on the left; every cycle he has
/// managed, newest first, in a panel on the right. The phone's cards and
/// reads, laid side by side.
class _ManagerHistoryTabletLayout extends ConsumerWidget {
  const _ManagerHistoryTabletLayout({required this.careerId});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(managerHistoryProvider(careerId));
    return TabletPage(
      scaffoldKey: ManagerHistoryScreen.tabletLayoutKey,
      title: l.careerManagerCareer,
      onBack: () => context.canPop()
          ? context.pop()
          : context.go('${Routes.careers}?careerId=$careerId'),
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.careerCouldNotLoad('$e'))),
        data: (h) {
          if (h == null) return Center(child: Text(l.careerNoCareer));
          final strength =
              ref.watch(teamOverallHistoryProvider(careerId)).valueOrNull ??
              const <TeamOverallPoint>[];
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 5,
                child: ListView(
                  children: [
                    _OverallCard(history: h),
                    // One year is not a curve, and a career can be one year
                    // old.
                    if (strength.length > 1) ...[
                      const SizedBox(height: AppSpacing.md),
                      TeamOverallHistoryCard(
                        key: const Key('career-team-strength'),
                        history: strength,
                        nationName: h.cycles.isEmpty
                            ? null
                            : h.cycles.first.nation?.name,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                flex: 6,
                child: Panel(
                  title: l.careerCycleByCycle,
                  expand: true,
                  padding: EdgeInsets.zero,
                  child: ListView(
                    padding: const EdgeInsets.all(12),
                    children: [for (final c in h.cycles) _CycleCard(cycle: c)],
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
```

- [ ] **Step 7: Register, run, expect PASS**

Add `Routes.careerSummary,` and `Routes.managerHistory,` to `tabletReadyPaths` in `lib/features/shell/tablet_shell.dart`.

Run: `flutter test test/widget/career_pages_tablet_test.dart test/golden/phone_guard_career_pages_test.dart test/widget/tablet_route_sweep_test.dart`
Expected: PASS, phone goldens unchanged.

- [ ] **Step 8: Analyze, full suite, commit**

Run: `flutter analyze && flutter test`

```bash
git add lib/features/career/career_summary_screen.dart lib/features/career/career_summary_tablet_layout.dart lib/features/career/manager_history_screen.dart lib/features/career/manager_history_tablet_layout.dart lib/features/shell/tablet_shell.dart test/widget/career_pages_tablet_test.dart
git commit -m "feat(tablet): the career summary and the manager's career as two columns

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

Then the batched review of Tasks 8 and 9 (see Review depth) before Task 10.

---

### Task 10: The Career page: the menu beside the career summary

**risk: high (per-task review)**. Navigation, and the onboarding tour's Career target.

**Files:**
- Create: `lib/features/career/careers_tablet_layout.dart` (part of `careers_screen.dart`)
- Modify: `lib/features/career/careers_screen.dart`, `lib/features/shell/tablet_shell.dart`
- Test: `test/golden/phone_guard_careers_test.dart` (new, with golden), `test/widget/careers_tablet_test.dart` (new)

**Interfaces:**
- Produces: `CareersScreen.tabletLayoutKey`; private `_careerMenu(AppLocalizations, int)` (the menu's destinations, one list both layouts draw).
- Consumes: `CareerSummaryView` (Task 9), `TourKeys.careerHistory`, `TabletPage`, `Panel`, `PanelLink`, `l.sideCareer`, `l.sideGroupHistory`, `l.careerSummaryTitle`, `l.panelViewAll`.

- [ ] **Step 1: Pin the phone Career menu**

Create `test/golden/phone_guard_careers_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';

import '../helpers/seeded_save.dart';

/// The phone Career menu, pinned before the tablet layout is added beside
/// it. All six lines fit a phone.
void main() {
  testWidgets('careers_phone', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.careers}?careerId=${save.careerId}',
    );
    expect(find.text(enL.careerMyMatches), findsOneWidget);
    await expectAppGolden('goldens/careers_phone.png');
  });
}
```

- [ ] **Step 2: Create the baseline, confirm it holds, commit it**

```bash
flutter test --update-goldens test/golden/phone_guard_careers_test.dart
flutter test test/golden/phone_guard_careers_test.dart
git add test/golden/phone_guard_careers_test.dart test/golden/goldens/careers_phone.png
git commit -m "test(tablet): phone guard for the Career menu

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

- [ ] **Step 3: Write the failing tablet test**

Create `test/widget/careers_tablet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/career/career_summary_screen.dart';
import 'package:fnm/features/career/careers_screen.dart';
import 'package:fnm/features/onboarding/tour_keys.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/seeded_save.dart';

Future<SeededSave> _open(WidgetTester tester, Size size) async {
  final save = await seedSave(tester, formFactor: FormFactor.tablet);
  await pumpRoute(
    tester,
    save,
    '${Routes.careers}?careerId=${save.careerId}',
    size: size,
  );
  return save;
}

String _path(SeededSave save) =>
    save.container.read(routerProvider).routeInformationProvider.value.uri.path;

void main() {
  for (final size in kTabletSizes) {
    testWidgets('the menu beside the career summary, $size', (tester) async {
      final save = await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(CareersScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      // The page is a sidebar destination: nothing to go back to.
      expect(find.byKey(TabletScreenHeader.backKey), findsNothing);
      // The tour's Career step still finds its line (Review Focus 7).
      expect(find.byKey(TourKeys.careerHistory), findsOneWidget);
      final summary = find.byType(CareerSummaryView);
      expect(
        tester.widget<CareerSummaryView>(summary).careerId,
        save.careerId,
      );
      expect(
        tester.getRect(find.byKey(TourKeys.careerHistory)).right,
        lessThan(tester.getRect(summary).left),
      );
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets("every line goes where the phone's does (Review Focus 7)", (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    final router = save.container.read(routerProvider);
    final lines = {
      enL.careerManagerCareer: Routes.managerHistory,
      enL.careerSummaryTitle: Routes.careerSummary,
      enL.careerAchievements: Routes.achievements,
      enL.careerChallenges: Routes.challenges,
      enL.careerTeamRecords: Routes.teamStats,
      enL.careerMyMatches: Routes.results,
    };
    for (final e in lines.entries) {
      router.go('${Routes.careers}?careerId=${save.careerId}');
      await settle(tester);
      await tester.tap(
        find
            .descendant(
              of: find.byKey(CareersScreen.tabletLayoutKey),
              matching: find.text(e.key),
            )
            .first,
      );
      await settle(tester);
      expect(_path(save), e.value, reason: e.key);
    }
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets("the summary's link opens its full page", (tester) async {
    final save = await _open(tester, kTabletSize);
    await tester.tap(find.text(enL.panelViewAll));
    await settle(tester);
    expect(_path(save), Routes.careerSummary);
    await tester.pumpWidget(const SizedBox());
  });
}
```

(Each line is found inside the layout, not the whole app: the sidebar has lines with the same words, Achievements for one.)

- [ ] **Step 4: Run it to verify it fails**

Run: `flutter test test/widget/careers_tablet_test.dart`
Expected: FAIL to compile (`CareersScreen.tabletLayoutKey` does not exist).

- [ ] **Step 5: One menu for both layouts, hook in the layout**

In `lib/features/career/careers_screen.dart`:

Add the imports `package:fnm/features/career/career_summary_screen.dart` and `package:fnm/shared/tablet/tablet.dart` and, below the imports, `part 'careers_tablet_layout.dart';`.

In `CareersScreen` add:

```dart
  static const Key tabletLayoutKey = Key('careers.tabletLayout');
```

Make the first lines of `CareersScreen.build`:

```dart
    if (TabletShellScope.isActive(context)) {
      return _CareersTabletLayout(careerId: careerId);
    }
```

Replace the `children: [...]` of the phone `ListView` (the six `_MenuTile`s and the `SizedBox`es between them, with the comment about challenges) with:

```dart
        children: [
          for (final (i, e) in _careerMenu(l, careerId).indexed) ...[
            if (i > 0) const SizedBox(height: AppSpacing.sm),
            _MenuTile(
              key: e.key,
              icon: e.icon,
              title: e.title,
              subtitle: e.subtitle,
              onTap: () => context.go(e.location),
            ),
          ],
        ],
```

and add, directly above `class _MenuTile`:

```dart
/// One destination of the Career menu.
typedef _CareerEntry = ({
  Key? key,
  IconData icon,
  String title,
  String subtitle,
  String location,
});

/// The Career menu, top to bottom: the same destinations on both layouts.
List<_CareerEntry> _careerMenu(AppLocalizations l, int careerId) => [
  (
    // The onboarding tour's Career step points here, on both layouts.
    key: TourKeys.careerHistory,
    icon: Icons.timeline,
    title: l.careerManagerCareer,
    subtitle: l.careerManagerCareerSubtitle,
    location: '${Routes.managerHistory}?careerId=$careerId',
  ),
  (
    key: null,
    icon: Icons.workspace_premium,
    title: l.careerSummaryTitle,
    subtitle: l.careerSummarySubtitle,
    location: '${Routes.careerSummary}?careerId=$careerId',
  ),
  (
    key: null,
    icon: Icons.emoji_events,
    title: l.careerAchievements,
    subtitle: l.careerAchievementsSubtitle,
    location: '${Routes.achievements}?careerId=$careerId',
  ),
  // Beside achievements, not buried inside them: the challenges used to be
  // reachable only from a button in the achievements app bar, so a manager
  // who never went looking never knew they were there.
  (
    key: null,
    icon: Icons.local_fire_department_rounded,
    title: l.careerChallenges,
    subtitle: l.careerChallengesSubtitle,
    location: '${Routes.challenges}?careerId=$careerId',
  ),
  (
    key: null,
    icon: Icons.leaderboard,
    title: l.careerTeamRecords,
    subtitle: l.careerTeamRecordsSubtitle,
    location: '${Routes.teamStats}?careerId=$careerId',
  ),
  (
    key: null,
    icon: Icons.sports_soccer,
    title: l.careerMyMatches,
    subtitle: l.careerMyMatchesSubtitle,
    location: '${Routes.results}?careerId=$careerId',
  ),
];
```

(The phone draws exactly the six tiles it drew, in the same order, with the tour key on the first and none on the rest; `careers_phone.png` and `career_menu_challenges_test.dart` prove it.)

- [ ] **Step 6: The layout**

Create `lib/features/career/careers_tablet_layout.dart`:

```dart
part of 'careers_screen.dart';

/// The Career page on a tablet: the phone's menu down the left, the
/// manager's career summary beside it. Every line goes where the phone's
/// does; the summary's link opens its full two-column page.
class _CareersTabletLayout extends StatelessWidget {
  const _CareersTabletLayout({required this.careerId});

  final int careerId;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return TabletPage(
      scaffoldKey: CareersScreen.tabletLayoutKey,
      title: l.sideCareer,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 340,
            child: Panel(
              title: l.sideGroupHistory,
              expand: true,
              padding: EdgeInsets.zero,
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  for (final (i, e) in _careerMenu(l, careerId).indexed) ...[
                    if (i > 0) const SizedBox(height: AppSpacing.sm),
                    _MenuTile(
                      key: e.key,
                      icon: e.icon,
                      title: e.title,
                      subtitle: e.subtitle,
                      onTap: () => context.go(e.location),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Panel(
              title: l.careerSummaryTitle,
              expand: true,
              padding: EdgeInsets.zero,
              action: PanelLink(
                label: l.panelViewAll,
                onTap: () => context.go(
                  '${Routes.careerSummary}?careerId=$careerId',
                ),
              ),
              child: CareerSummaryView(
                careerId: careerId,
                padding: const EdgeInsets.all(12),
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

Add `Routes.careers,` to `tabletReadyPaths` in `lib/features/shell/tablet_shell.dart`.

Run: `flutter test test/widget/careers_tablet_test.dart test/golden/phone_guard_careers_test.dart test/widget/career_menu_challenges_test.dart test/widget/tour_test.dart test/widget/tablet_route_sweep_test.dart`
Expected: PASS, phone golden unchanged.

- [ ] **Step 8: Analyze, full suite, commit**

Run: `flutter analyze && flutter test`

```bash
git add lib/features/career/careers_screen.dart lib/features/career/careers_tablet_layout.dart lib/features/shell/tablet_shell.dart test/widget/careers_tablet_test.dart
git commit -m "feat(tablet): the Career page, the menu beside the career summary

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 11: Share sheets point somewhere, so an iPad can export a save

**risk: high (per-task review)**. Save management. A real iPad bug: share_plus refuses to show its popover on an iPad without `sharePositionOrigin`, and the app catches the refusal and says "Could not export that career." (Review Focus 3). The three share calls (export one career, back up all saves from the saves screen, and the Settings backup) gain an origin; an iPhone and Android ignore it.

**Files:**
- Create: `lib/core/util/share_origin.dart`
- Modify: `lib/features/career/saves_screen.dart` (`_shareCareer`, `_backupAll`), `lib/features/settings/settings_screen.dart` (`_BackupCardState._export`)
- Test: `test/golden/phone_guard_saves_test.dart` (new, with goldens), `test/widget/share_origin_test.dart` (new)

**Interfaces:**
- Produces: `Rect? shareOriginOf(BuildContext context)`; `_shareCareer(BuildContext, WidgetRef, int careerId, {Rect? origin})` and `_backupAll(BuildContext, WidgetRef, {Rect? origin})` (an absent origin is the calling context's own rect).
- Consumes: `ShareParams.sharePositionOrigin` (share_plus 12.0.2).

- [ ] **Step 1: Pin the phone saves list (the first task to touch `saves_screen.dart`)**

Create `test/golden/phone_guard_saves_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/career/saves_screen.dart';

import '../helpers/history_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The phone saves list, pinned before Tasks 11 and 12 touch it: one save,
/// and two.
void main() {
  testWidgets('saves_phone', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(tester, save, Routes.saves);
    expect(find.byType(SaveTile), findsOneWidget);
    await expectAppGolden('goldens/saves_phone.png');
  });

  testWidgets('saves_two_phone', (tester) async {
    final save = await seedSave(tester);
    await addSecondSave(tester, save);
    await pumpRoute(tester, save, Routes.saves);
    expect(find.byType(SaveTile), findsNWidgets(2));
    await expectAppGolden('goldens/saves_two_phone.png');
  });
}
```

```bash
flutter test --update-goldens test/golden/phone_guard_saves_test.dart
flutter test test/golden/phone_guard_saves_test.dart
git add test/golden/phone_guard_saves_test.dart test/golden/goldens/saves_phone.png test/golden/goldens/saves_two_phone.png
git commit -m "test(tablet): phone guard for the saves list

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

- [ ] **Step 2: Write the failing tests**

Create `test/widget/share_origin_test.dart`:

```dart
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/util/share_origin.dart';

void main() {
  testWidgets('the global rect of the widget it is given', (tester) async {
    late BuildContext target;
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(
          children: [
            Positioned(
              left: 40,
              top: 60,
              width: 120,
              height: 30,
              child: Builder(
                builder: (context) {
                  target = context;
                  return const SizedBox.expand();
                },
              ),
            ),
          ],
        ),
      ),
    );
    expect(shareOriginOf(target), const Rect.fromLTWH(40, 60, 120, 30));
  });

  // Review Focus 3. An iPad refuses a share sheet with nowhere to point
  // (share_plus: "sharePositionOrigin: argument must be set"), and every
  // caller catches that and says the export failed.
  test('every share sheet in the app says where it points from', () {
    final offenders = <String>[];
    for (final file in Directory('lib').listSync(recursive: true)) {
      if (file is! File || !file.path.endsWith('.dart')) continue;
      final src = file.readAsStringSync();
      final shares = 'SharePlus.instance.share('.allMatches(src).length;
      final origins = 'sharePositionOrigin:'.allMatches(src).length;
      if (shares > origins) offenders.add(file.path);
    }
    expect(offenders, isEmpty);
  });
}
```

- [ ] **Step 3: Run them to verify they fail**

Run: `flutter test test/widget/share_origin_test.dart`
Expected: FAIL to compile (`share_origin.dart` does not exist). Once Step 4 adds the helper, the source guard still FAILS naming `lib/features/career/saves_screen.dart` and `lib/features/settings/settings_screen.dart`.

- [ ] **Step 4: The helper**

Create `lib/core/util/share_origin.dart`:

```dart
import 'package:flutter/widgets.dart';

/// Where a share sheet points from: the global rect of the widget at
/// [context], or null when it has not been laid out.
///
/// An iPad shows the share sheet as a popover and refuses to show it with
/// nowhere to point; an iPhone and Android ignore the origin. Take it BEFORE
/// any await: the widget may be gone, or moved, once the file is written.
Rect? shareOriginOf(BuildContext context) {
  final box = context.findRenderObject();
  if (box is! RenderBox || !box.attached || !box.hasSize) return null;
  return box.localToGlobal(Offset.zero) & box.size;
}
```

- [ ] **Step 5: Every share call passes an origin**

In `lib/features/career/saves_screen.dart` add the import `package:fnm/core/util/share_origin.dart`, and replace `_backupAll` and `_shareCareer` (from the stray doc line `/// Writes one career to a file and hands it to the share sheet.` above `_backupAll`'s own doc comment, to the end of `_shareCareer`) with:

```dart
/// Writes EVERY save to one file and hands it to the share sheet.
///
/// The same export the settings screen offers, on the screen where a manager
/// is actually looking at what he would lose. [origin] is where an iPad's
/// share popover points; the calling context's own rect when absent.
Future<void> _backupAll(
  BuildContext context,
  WidgetRef ref, {
  Rect? origin,
}) async {
  final l = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  final from = origin ?? shareOriginOf(context);
  try {
    final file = await ref.read(saveBackupServiceProvider).export();
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        subject: l.backupExportSubject,
        sharePositionOrigin: from,
      ),
    );
  } on Object catch (e, stack) {
    AppLog.error('saves-backup-all', e, stack);
    messenger.showSnackBar(SnackBar(content: Text(l.careerBackupAllFailed)));
  }
}

/// Writes one career to a file and hands it to the share sheet. [origin] is
/// where an iPad's share popover points; the calling context's own rect when
/// absent.
Future<void> _shareCareer(
  BuildContext context,
  WidgetRef ref,
  int careerId, {
  Rect? origin,
}) async {
  final l = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  final from = origin ?? shareOriginOf(context);
  try {
    final file = await ref.read(careerTransferServiceProvider).export(careerId);
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        subject: l.careerShareSubject,
        sharePositionOrigin: from,
      ),
    );
  } on Object catch (e, stack) {
    AppLog.error('career-share', e, stack);
    messenger.showSnackBar(SnackBar(content: Text(l.careerShareFailed)));
  }
}
```

(The phone's call sites are unchanged: they pass no origin, so the share sheet points at the saves screen itself, which an iPhone ignores and an iPad in a narrow window accepts. Task 12 passes the tablet buttons' own rects.)

In `lib/features/settings/settings_screen.dart` add the import `package:fnm/core/util/share_origin.dart`, and in `_BackupCardState._export` add, directly below `final l = AppLocalizations.of(context);`:

```dart
    // Taken now, while the card is laid out: an iPad's share sheet must
    // point at something.
    final origin = shareOriginOf(context);
```

and add `sharePositionOrigin: origin,` to its `ShareParams(...)`, after `subject: l.backupExportSubject,`.

- [ ] **Step 6: Run, expect PASS**

Run: `flutter test test/widget/share_origin_test.dart test/golden/phone_guard_saves_test.dart test/widget/saves_buttons_test.dart test/widget/saves_played_time_test.dart`
Expected: PASS, phone goldens unchanged.

- [ ] **Step 7: Analyze, full suite, commit**

Run: `flutter analyze && flutter test`

```bash
git add lib/core/util/share_origin.dart lib/features/career/saves_screen.dart lib/features/settings/settings_screen.dart test/widget/share_origin_test.dart
git commit -m "fix(tablet): share sheets point at their button, so an iPad can export a save

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 12: Saves: the table beside the picked save's career

**risk: high (per-task review)**. Save management: open, back up and delete act on the picked save (Review Focus 2), export points at its button (Review Focus 3), the pick survives a resize (Review Focus 4), the delete dialog closes itself (Review Focus 5).

**Files:**
- Create: `lib/features/career/saves_tablet_layout.dart` (part of `saves_screen.dart`)
- Modify: `lib/features/career/saves_screen.dart`, `lib/features/shell/tablet_shell.dart`
- Test: `test/widget/saves_tablet_test.dart` (new); the phone guard is Task 11's `test/golden/phone_guard_saves_test.dart`

**Interfaces:**
- Produces: `SavesScreen.tabletLayoutKey`, `SavesScreen.continueKey`, `SavesScreen.exportKey`, `SavesScreen.deleteKey`; `_SavesScreenState._selectedId`, `_select(Career)`, `_continue(Career)`, `_actions(BuildContext, {required List<Career> saves, required bool full, required bool premium})`; private `_SavesTabletLayout`, `_SavePane`, `_saveColumns`.
- Consumes: `savesProvider`, `premiumUnlockedProvider`, `nationsProvider` (the phone screen's reads), `CareerSummaryView` (Task 9; its own reads), `_shareCareer`, `_backupAll` (Task 11), `shareOriginOf`, `useTabletLayout`, `TabletScreenHeader`, `MasterDetail`, `MasterDetailPlaceholder`, `PanelBox`, `DataGrid`, `PrimaryButton`, `FlagDisc`, `AppDate.monthYear`, `agoShort`, `playedLabel`, `l.savesTitle`, `l.hubContinue`, `l.careerExportSave`, `l.careerDelete`, `l.careerThisSave`, `l.careerUnknownNation`, `l.careerNoSavesYet`, `l.gridColNation`, `l.gridColManager`, `l.gridColDate`, `l.gridColLastPlayed`.

- [ ] **Step 1: Write the failing tablet test**

Create `test/widget/saves_tablet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/features/career/career_summary_screen.dart';
import 'package:fnm/features/career/career_transfer_providers.dart';
import 'package:fnm/features/career/saves_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/history_fixtures.dart';
import '../helpers/seeded_save.dart';

/// A save on a tablet's saves list, and (when [second]) a second one on the
/// rival nation, whose id comes back with it.
Future<(SeededSave, int?)> _open(
  WidgetTester tester,
  Size size, {
  bool second = false,
}) async {
  final save = await seedSave(
    tester,
    formFactor: FormFactor.tablet,
    overrides: [fakeTransferOverride()],
  );
  final secondId = second ? await addSecondSave(tester, save) : null;
  await pumpRoute(tester, save, Routes.saves, size: size);
  return (save, secondId);
}

Finder get _grid => find.byType(DataGrid<Career>);

/// Whose career the pane is showing.
int _paneId(WidgetTester tester) =>
    tester.widget<CareerSummaryView>(find.byType(CareerSummaryView)).careerId;

Uri _uri(SeededSave save) =>
    save.container.read(routerProvider).routeInformationProvider.value.uri;

Future<Career?> _career(WidgetTester tester, SeededSave save, int id) async {
  Career? career;
  await tester.runAsync(() async {
    career = await save.container.read(careerRepositoryProvider).byId(id);
  });
  return career;
}

Future<List<Career>> _all(WidgetTester tester, SeededSave save) async {
  var all = <Career>[];
  await tester.runAsync(() async {
    all = await save.container.read(careerRepositoryProvider).all();
  });
  return all;
}

/// Picks the rival nation's save in the table.
Future<void> _pickSecond(WidgetTester tester) async {
  await tester.tap(
    find.descendant(of: _grid, matching: find.text(rivalNation.name)),
  );
  await settle(tester);
}

void main() {
  for (final size in kTabletSizes) {
    testWidgets('the table beside the picked save, $size', (tester) async {
      final (save, _) = await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(SavesScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(FullScreenPhoneFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      expect(tester.widget<DataGrid<Career>>(_grid).rows, hasLength(1));
      // The only save is open beside the table, with its three actions.
      expect(_paneId(tester), save.careerId);
      expect(
        tester.getRect(_grid).right,
        lessThan(tester.getRect(find.byType(CareerSummaryView)).left),
      );
      expect(find.byKey(SavesScreen.continueKey), findsOneWidget);
      expect(find.byKey(SavesScreen.exportKey), findsOneWidget);
      expect(find.byKey(SavesScreen.deleteKey), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('Continue opens the picked save and stamps only it (Review '
      'Focus 2)', (tester) async {
    final (save, second) = await _open(tester, kTabletSize, second: true);
    await _pickSecond(tester);
    expect(_paneId(tester), second);
    expect((await _career(tester, save, second!))!.lastPlayedAt, isNull);
    expect((await _career(tester, save, save.careerId))!.lastPlayedAt, isNull);
    await tester.tap(find.byKey(SavesScreen.continueKey));
    await settle(tester);
    expect(_uri(save).path, Routes.hub);
    expect(_uri(save).queryParameters['careerId'], '$second');
    expect((await _career(tester, save, second))!.lastPlayedAt, isNotNull);
    expect((await _career(tester, save, save.careerId))!.lastPlayedAt, isNull);
    await stopPlayClock(tester, save);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('deleting the picked save leaves the other one open (Review '
      'Focus 2 and 5)', (tester) async {
    final (save, second) = await _open(tester, kTabletSize, second: true);
    await _pickSecond(tester);
    expect(await _all(tester, save), hasLength(2));
    await tester.tap(find.byKey(SavesScreen.deleteKey));
    await settle(tester);
    expect(find.byType(AlertDialog), findsOneWidget);
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text(enL.careerDelete),
      ),
    );
    await settle(tester);
    // The dialog closed itself; the page is still the saves list.
    expect(find.byType(AlertDialog), findsNothing);
    expect(_uri(save).path, Routes.saves);
    expect([for (final c in await _all(tester, save)) c.id], [save.careerId]);
    final transfer =
        save.container.read(careerTransferServiceProvider)
            as FakeCareerTransfer;
    expect(transfer.removed, [second]);
    expect(tester.widget<DataGrid<Career>>(_grid).rows, hasLength(1));
    expect(_paneId(tester), save.careerId);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets("export points the share sheet at its button (Review Focus 3)", (
    tester,
  ) async {
    final (save, _) = await _open(tester, kTabletSize);
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
    final button = tester.getRect(find.byKey(SavesScreen.exportKey));
    await tester.tap(find.byKey(SavesScreen.exportKey));
    await settle(tester);
    final transfer =
        save.container.read(careerTransferServiceProvider)
            as FakeCareerTransfer;
    expect(transfer.exported, [save.careerId]);
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
    expect(find.text(enL.careerShareFailed), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a resize keeps the pick (Review Focus 4)', (tester) async {
    final (_, second) = await _open(tester, kTabletSize, second: true);
    await _pickSecond(tester);
    expect(_paneId(tester), second);
    tester.view.physicalSize = const Size(900, 810);
    await settle(tester);
    expect(find.byKey(SavesScreen.tabletLayoutKey), findsNothing);
    expect(find.byType(SaveTile), findsNWidgets(2));
    tester.view.physicalSize = kTabletSize;
    await settle(tester);
    expect(find.byKey(SavesScreen.tabletLayoutKey), findsOneWidget);
    expect(_paneId(tester), second);
    await tester.pumpWidget(const SizedBox());
  });
}
```

- [ ] **Step 2: Run it to verify it fails**

Run: `flutter test test/widget/saves_tablet_test.dart`
Expected: FAIL to compile (`SavesScreen.tabletLayoutKey` does not exist).

- [ ] **Step 3: One State for both layouts**

In `lib/features/career/saves_screen.dart`:

Add the imports `package:fnm/core/layout/form_factor.dart`, `package:fnm/features/career/career_summary_screen.dart` and `package:fnm/shared/tablet/tablet.dart` and, below the imports, `part 'saves_tablet_layout.dart';`.

In `SavesScreen` add:

```dart
  static const Key tabletLayoutKey = Key('saves.tabletLayout');
  static const Key continueKey = Key('saves.continue');
  static const Key exportKey = Key('saves.export');
  static const Key deleteKey = Key('saves.delete');
```

Replace the whole `_SavesScreenState` class (from `class _SavesScreenState` to the closing brace after `_empty`) with the following. The phone tree is the one it was; what moved: the tile's Continue into `_continue`, the bottom block into `_actions` (the backup-all button now inside a `Builder`, to hand its own rect to the share sheet), and the delete dialog pops with its own context and takes its two services before it opens.

```dart
class _SavesScreenState extends ConsumerState<SavesScreen> {
  /// Whether one of the three file actions is running.
  ///
  /// Writing a career out, writing every save out, and reading one back all
  /// go to disk and can take seconds on a long save. Nothing said so: the
  /// manager pressed import, the share sheet did not appear yet, and the
  /// screen sat there looking exactly as it had before, so he pressed it
  /// again. One flag disables all three and puts a spinner on the one he
  /// pressed, because a control that is working has to look different from a
  /// control that ignored him.
  bool _busy = false;

  /// The save open beside the table on a tablet. Kept here, in the State both
  /// layouts share, so a window resized across 1000 px comes back to it. A
  /// pick that no longer exists (deleted) falls back to the first save.
  int? _selectedId;

  /// Runs a file action with the screen marked busy for its whole duration.
  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _select(Career save) => setState(() => _selectedId = save.id);

  /// Opens [save] where the manager left it. Stamps the open before
  /// navigating so this save is top of the list next time; nothing is
  /// awaited, so there is no later moment at which to go anywhere else.
  void _continue(Career save) {
    ref.read(careerServiceProvider).markPlayed(save.id);
    context.go('${Routes.hub}?careerId=${save.id}');
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final savesAsync = ref.watch(savesProvider);
    final premium = ref.watch(premiumUnlockedProvider);
    // Null means no ceiling, which is what the purchase buys.
    final limit = saveSlotLimit(premiumUnlocked: premium);
    final nations = ref.watch(nationsProvider).valueOrNull ?? const <Nation>[];
    final nationsById = {for (final n in nations) n.id: n};

    if (useTabletLayout(context, ref)) {
      return _SavesTabletLayout(
        state: this,
        savesAsync: savesAsync,
        nationsById: nationsById,
        premium: premium,
        limit: limit,
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.go(Routes.home),
        ),
        title: Text(
          l.careerSavesTitle,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: savesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.careerCouldNotLoadSaves('$e'))),
        data: (saves) {
          // Over the limit counts as full too. A manager can arrive here with
          // more saves than the free tier allows (they were made when it was
          // uncapped, or restored from a paid device); every one of them stays
          // in the list, playable and deletable. Only a NEW one is refused.
          final full = limit != null && saves.length >= limit;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.marginMobile),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        limit == null
                            ? l.careerSlotsUsed(saves.length)
                            : l.careerSlotsCount(saves.length, limit),
                        style: AppTypography.labelMedium,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: saves.isEmpty
                    ? _empty(context)
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.marginMobile,
                        ),
                        itemCount: saves.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, i) {
                          final save = saves[i];
                          return SaveTile(
                            save: save,
                            nation: nationsById[save.nationId],
                            onContinue: () => _continue(save),
                            onDelete: () => _confirmDelete(
                              context,
                              ref,
                              nationsById[save.nationId]?.name ??
                                  l.careerThisSave,
                              save.id,
                            ),
                            onShare: _busy
                                ? null
                                : () => _run(
                                    () => _shareCareer(
                                      context,
                                      ref,
                                      save.id,
                                    ),
                                  ),
                          );
                        },
                      ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.marginMobile),
                  child: _actions(
                    context,
                    saves: saves,
                    full: full,
                    premium: premium,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// What the manager can do besides open a save: start one (or buy room for
  /// one), take one in from a file, back them all up. Both layouts show it.
  Widget _actions(
    BuildContext context, {
    required List<Career> saves,
    required bool full,
    required bool premium,
  }) {
    final l = AppLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PrimaryButton(
          label: full
              ? (premium ? l.careerSlotsFull : l.careerSlotsUnlockMore)
              : l.careerNewGame,
          icon: full && !premium ? Icons.lock_open : Icons.add,
          // A full free player is not sent to a dead button: more saves are
          // exactly what the purchase sells, so the button becomes the door
          // to it.
          onPressed: !full
              ? () => context.go(Routes.nations)
              : premium
              ? null
              : () => unawaited(showPaywall(context)),
        ),
        if (full && !premium)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: Text(
              l.careerSlotsKeepNote,
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
        // The way to the shop, open whether or not the slots are full.
        //
        // It used to appear only when they were, which made the offer a
        // consequence of running out rather than something a manager could
        // take up when he wanted it. He asked for it on this screen with room
        // to spare, and he is right: what the purchase sells is endless
        // cycles, and the second save is the smaller half of it. When the
        // slots ARE full the primary button above is already that door, so
        // this one stands down rather than print the same offer twice.
        if (!premium && !full)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: TextButton.icon(
              onPressed: () => unawaited(showPaywall(context)),
              icon: const Icon(Icons.lock_open_rounded, size: 18),
              label: Text(l.paywallGoPro),
            ),
          ),
        // An imported career takes a slot like any other, so it is offered
        // only while there is room for one.
        if (!full)
          TextButton.icon(
            onPressed: _busy
                ? null
                : () => _run(() => _importCareer(context, ref)),
            icon: _busy
                ? const _Spinner()
                : const Icon(Icons.file_download_outlined, size: 18),
            label: Text(l.careerImport),
          ),
        // Every save at once, which is the backup that actually answers a
        // lost phone. Exporting one career at a time from the tiles covers
        // the save you remembered; this covers the ones you did not. The
        // Builder hands the share sheet this button's own rect (an iPad's
        // popover points at it).
        if (saves.isNotEmpty)
          Builder(
            builder: (button) => TextButton.icon(
              onPressed: () =>
                  _backupAll(context, ref, origin: shareOriginOf(button)),
              icon: const Icon(Icons.backup_outlined, size: 18),
              label: Text(l.careerBackupAll),
            ),
          ),
      ],
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    String label,
    int careerId,
  ) async {
    final l = AppLocalizations.of(context);
    // Taken before the dialog: the window may resize, or the screen go,
    // while it is up.
    final careers = ref.read(careerServiceProvider);
    final transfer = ref.read(careerTransferServiceProvider);
    final confirmed = await showDialog<bool>(
      context: context,
      // The dialog pops with its OWN context: on a tablet it is a root
      // dialog, and the screen's navigator is not necessarily its.
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surfaceContainer,
        title: Text(l.careerDeleteSaveTitle),
        content: Text(l.careerDeleteSaveBody(label)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l.careerCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l.careerDelete),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await careers.delete(careerId);
      // Its end-of-cycle copy goes with it: nothing else would ever clear it.
      await transfer.removeAppFolderBackup(careerId);
    }
  }

  Widget _empty(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Text(
        AppLocalizations.of(context).careerNoSavesYet,
        textAlign: TextAlign.center,
        style: AppTypography.bodyMedium.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),
    ),
  );
}
```

Diff the old and new phone trees by eye before moving on: every widget the phone drew is drawn again, in the same order, with the same arguments (`saves_phone.png` and `saves_two_phone.png` will prove it in Step 5).

- [ ] **Step 4: The layout**

Create `lib/features/career/saves_tablet_layout.dart`:

```dart
part of 'saves_screen.dart';

/// The saves on a landscape tablet: every save in a sortable table on the
/// left with the screen's other actions under it; the picked save's career
/// on the right, with what can be done to it (open, back up, delete). Every
/// action is the phone's own ([_SavesScreenState._continue], [_shareCareer],
/// [_SavesScreenState._confirmDelete], [_SavesScreenState._actions]), and the
/// pick is the State's, so a resize keeps it.
class _SavesTabletLayout extends StatelessWidget {
  const _SavesTabletLayout({
    required this.state,
    required this.savesAsync,
    required this.nationsById,
    required this.premium,
    required this.limit,
  });

  final _SavesScreenState state;
  final AsyncValue<List<Career>> savesAsync;
  final Map<int, Nation> nationsById;
  final bool premium;
  final int? limit;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cap = limit;
    return Scaffold(
      key: SavesScreen.tabletLayoutKey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: savesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) =>
                Center(child: Text(l.careerCouldNotLoadSaves('$e'))),
            data: (saves) {
              final full = cap != null && saves.length >= cap;
              // The pick, or the first save when there is none or it has
              // just been deleted: the pane never shows a save that is gone.
              final selected =
                  saves.where((s) => s.id == state._selectedId).firstOrNull ??
                  saves.firstOrNull;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TabletScreenHeader(
                    title: l.savesTitle,
                    onBack: () => context.go(Routes.home),
                    trailing: Text(
                      cap == null
                          ? l.careerSlotsUsed(saves.length)
                          : l.careerSlotsCount(saves.length, cap),
                      style: AppTypography.labelMedium,
                    ),
                  ),
                  Expanded(
                    child: MasterDetail(
                      initialFraction: 0.5,
                      minFraction: 0.4,
                      maxFraction: 0.6,
                      minDetailWidth: 380,
                      master: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: PanelBox(
                              child: saves.isEmpty
                                  ? state._empty(context)
                                  : DataGrid<Career>(
                                      rows: saves,
                                      columnSets: [
                                        _saveColumns(context, l, nationsById),
                                      ],
                                      selected: selected,
                                      onSelect: state._select,
                                    ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          state._actions(
                            context,
                            saves: saves,
                            full: full,
                            premium: premium,
                          ),
                        ],
                      ),
                      detail: PanelBox(
                        child: selected == null
                            ? MasterDetailPlaceholder(text: l.careerNoSavesYet)
                            : _SavePane(
                                // A new save is a new pane: no scroll or
                                // busy spinner carried over.
                                key: ValueKey(selected.id),
                                state: state,
                                save: selected,
                                nation: nationsById[selected.nationId],
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

/// The saves table's one view: whose nation, which manager, how far into
/// the game, and when last played.
GridColumnSet<Career> _saveColumns(
  BuildContext context,
  AppLocalizations l,
  Map<int, Nation> nationsById,
) {
  String name(Career c) =>
      nationsById[c.nationId]?.name ?? l.careerUnknownNation;
  return GridColumnSet<Career>(
    id: 'overview',
    label: l.gridViewOverview,
    columns: [
      GridColumn<Career>(
        id: 'nation',
        label: l.gridColNation,
        flex: 3,
        sortKey: name,
        cell: (c) => Row(
          children: [
            FlagDisc(nationsById[c.nationId]?.code ?? '??', size: 22),
            const SizedBox(width: AppSpacing.sm),
            Flexible(
              child: Text(
                name(c),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      GridColumn<Career>(
        id: 'manager',
        label: l.gridColManager,
        flex: 2,
        sortKey: (c) => c.managerName,
        cell: (c) => Text(c.managerName),
      ),
      GridColumn<Career>(
        id: 'date',
        label: l.gridColDate,
        width: 110,
        sortKey: (c) => c.inGameDate,
        cell: (c) => Text(AppDate.monthYear(context, c.inGameDate)),
      ),
      GridColumn<Career>(
        id: 'lastPlayed',
        label: l.gridColLastPlayed,
        width: 110,
        numeric: true,
        sortKey: (c) => c.lastPlayedAt ?? DateTime(0),
        cell: (c) => Text(
          c.lastPlayedAt == null ? '' : agoShort(c.lastPlayedAt!),
        ),
      ),
    ],
  );
}

/// The picked save: who and where, the three things to do with it, and its
/// career summary under them.
class _SavePane extends StatelessWidget {
  const _SavePane({
    required this.state,
    required this.save,
    required this.nation,
    super.key,
  });

  final _SavesScreenState state;
  final Career save;
  final Nation? nation;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final played = playedLabel(l, save.playedSeconds);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: Row(
            children: [
              FlagDisc(nation?.code ?? '??', size: 44, highlighted: true),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nation?.name ?? l.careerUnknownNation,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.titleMedium,
                    ),
                    Text(
                      '${save.managerName} · '
                      '${AppDate.monthYear(context, save.inGameDate)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    if (played != null)
                      Text(
                        played,
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              SizedBox(
                width: 180,
                child: PrimaryButton(
                  key: SavesScreen.continueKey,
                  label: l.hubContinue,
                  icon: Icons.play_arrow_rounded,
                  onPressed: () => state._continue(save),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              // The Builder hands the share sheet this button's own rect
              // (an iPad's popover points at it).
              Builder(
                builder: (button) => TextButton.icon(
                  key: SavesScreen.exportKey,
                  onPressed: state._busy
                      ? null
                      : () => state._run(
                          () => _shareCareer(
                            context,
                            state.ref,
                            save.id,
                            origin: shareOriginOf(button),
                          ),
                        ),
                  icon: state._busy
                      ? const _Spinner()
                      : const Icon(Icons.ios_share_rounded, size: 18),
                  label: Text(l.careerExportSave),
                ),
              ),
              const Spacer(),
              TextButton.icon(
                key: SavesScreen.deleteKey,
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
                onPressed: () => state._confirmDelete(
                  context,
                  state.ref,
                  nation?.name ?? l.careerThisSave,
                  save.id,
                ),
                icon: const Icon(Icons.delete_outline, size: 18),
                label: Text(l.careerDelete),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: CareerSummaryView(
            key: ValueKey(('save', save.id)),
            careerId: save.id,
            padding: const EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }
}
```

(`Career` and `Nation` are imported by `saves_screen.dart` already; `AsyncValue` comes with `flutter_riverpod`.)

- [ ] **Step 5: Register, run, expect PASS**

Add `Routes.saves,` to `tabletReadyPaths` in `lib/features/shell/tablet_shell.dart`.

Run: `flutter test test/widget/saves_tablet_test.dart test/golden/phone_guard_saves_test.dart test/widget/saves_buttons_test.dart test/widget/saves_played_time_test.dart test/widget/tablet_full_screen_sweep_test.dart`
Expected: PASS, phone goldens unchanged. If a test fails at teardown with "Bad state: Future already completed", an invalidated provider was left unbuilt: apply the Global Constraints' teardown rule and say which provider in the commit.

- [ ] **Step 6: Prove the pick test bites**

In `_SavePane`, temporarily change `onPressed: () => state._continue(save)` to open whichever save the list holds first instead of the picked one:

```dart
                  onPressed: () => state._continue(
                    state.ref.read(savesProvider).value!.first,
                  ),
```

Run `flutter test test/widget/saves_tablet_test.dart --plain-name 'Continue opens the picked save'` and confirm it FAILS (on the careerId or on which save was stamped). If `all()` happens to list the second save first, so this mutant passes, change `.first` to `.last` and run again: the test must fail under one of the two. Restore the original line.

- [ ] **Step 7: Analyze, full suite, commit**

Run: `flutter analyze && flutter test`

```bash
git add lib/features/career/saves_screen.dart lib/features/career/saves_tablet_layout.dart lib/features/shell/tablet_shell.dart test/widget/saves_tablet_test.dart
git commit -m "feat(tablet): saves as a table beside the picked save's career

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 13: Home as a landscape title screen

**risk: high (per-task review)**. Navigation, and Continue stamps the last save.

**Files:**
- Create: `lib/features/home/home_tablet_layout.dart` (part of `home_screen.dart`)
- Modify: `lib/features/home/home_screen.dart`, `lib/features/shell/tablet_shell.dart`
- Test: `test/golden/phone_guard_home_test.dart` (new, with golden), `test/widget/home_tablet_test.dart` (new)

**Interfaces:**
- Produces: `HomeScreen.tabletLayoutKey`; private `_resume(BuildContext, WidgetRef, Career)`, `_HomeTabletLayout`.
- Consumes: `savesProvider`, `nationByIdProvider` (the phone screen's reads), `careerServiceProvider.markPlayed` (through `_resume`), `_ContinueCard` (the phone's), `useTabletLayout`, `PrimaryButton`, `l.homeSettings`, `l.homeLeadTheNation`, `l.homeNewGame`, `l.homeAllSaves`, `l.homeLoadGame`.

- [ ] **Step 1: Pin the phone home screen**

Create `test/golden/phone_guard_home_test.dart` (one test in the file: the logo is an asset, and the second test of a file can find an asset load never completes):

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';

import '../helpers/seeded_save.dart';

/// The phone home screen, pinned before the tablet layout is added beside
/// it: the logo, the title, the Continue card for the save, New game.
void main() {
  testWidgets('home_phone', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(tester, save, Routes.home);
    expect(find.text(enL.homeContinue), findsOneWidget);
    await expectAppGolden('goldens/home_phone.png');
  });
}
```

- [ ] **Step 2: Create the baseline, confirm it holds, commit it**

```bash
flutter test --update-goldens test/golden/phone_guard_home_test.dart
flutter test test/golden/phone_guard_home_test.dart
git add test/golden/phone_guard_home_test.dart test/golden/goldens/home_phone.png
git commit -m "test(tablet): phone guard for the home screen

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

- [ ] **Step 3: Write the failing tablet test**

Create `test/widget/home_tablet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/features/home/home_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/history_fixtures.dart';
import '../helpers/seeded_save.dart';

Future<SeededSave> _open(WidgetTester tester, Size size) async {
  final save = await seedSave(tester, formFactor: FormFactor.tablet);
  await pumpRoute(tester, save, Routes.home, size: size);
  return save;
}

Uri _uri(SeededSave save) =>
    save.container.read(routerProvider).routeInformationProvider.value.uri;

Future<Career?> _career(WidgetTester tester, SeededSave save) async {
  Career? career;
  await tester.runAsync(() async {
    career = await save.container
        .read(careerRepositoryProvider)
        .byId(save.careerId);
  });
  return career;
}

void main() {
  for (final size in kTabletSizes) {
    testWidgets('the title left, the way in right, $size', (tester) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(HomeScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(FullScreenPhoneFrame), findsNothing);
      final title = tester.getRect(find.text('Football Nations\nManager'));
      final newGame = tester.getRect(
        find.widgetWithText(PrimaryButton, enL.homeNewGame),
      );
      expect(newGame.left, greaterThan(title.right));
      expect(find.text(enL.homeContinue), findsOneWidget);
      expect(find.byTooltip(enL.homeSettings), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('Continue opens the last save and stamps it', (tester) async {
    final save = await _open(tester, kTabletSize);
    expect((await _career(tester, save))!.lastPlayedAt, isNull);
    await tester.tap(find.text(enL.homeContinue));
    await settle(tester);
    expect(_uri(save).path, Routes.hub);
    expect(_uri(save).queryParameters['careerId'], '${save.careerId}');
    expect((await _career(tester, save))!.lastPlayedAt, isNotNull);
    await stopPlayClock(tester, save);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets("the other buttons go where the phone's do (Review Focus 7)", (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    final router = save.container.read(routerProvider);
    final buttons = {
      find.widgetWithText(PrimaryButton, enL.homeNewGame): Routes.nations,
      find.text(enL.homeAllSaves): Routes.saves,
      find.byTooltip(enL.homeSettings): Routes.settings,
    };
    for (final e in buttons.entries) {
      router.go(Routes.home);
      await settle(tester);
      await tester.tap(e.key);
      await settle(tester);
      expect(_uri(save).path, e.value);
    }
    await tester.pumpWidget(const SizedBox());
  });
}
```

- [ ] **Step 4: Run it to verify it fails**

Run: `flutter test test/widget/home_tablet_test.dart`
Expected: FAIL to compile (`HomeScreen.tabletLayoutKey` does not exist).

- [ ] **Step 5: Share the resume, hook in the layout**

In `lib/features/home/home_screen.dart`:

Add the imports `package:fnm/core/layout/form_factor.dart`, `package:fnm/domain/entities/career.dart` and `package:fnm/domain/entities/nation.dart` and, below the imports, `part 'home_tablet_layout.dart';`.

In `HomeScreen` add:

```dart
  static const Key tabletLayoutKey = Key('home.tabletLayout');
```

In `HomeScreen.build`, directly after the `final lastNation = ...;` statement, add:

```dart
    if (useTabletLayout(context, ref)) {
      return _HomeTabletLayout(
        lastSave: lastSave,
        lastNation: lastNation,
        onResume: lastSave == null
            ? null
            : () => _resume(context, ref, lastSave),
      );
    }
```

Replace the `_ContinueCard`'s

```dart
                  onResume: () {
                    ref.read(careerServiceProvider).markPlayed(lastSave.id);
                    context.go('${Routes.hub}?careerId=${lastSave.id}');
                  },
```

with

```dart
                  onResume: () => _resume(context, ref, lastSave),
```

and add, directly above `class _ContinueCard`:

```dart
/// Opens [save] where the manager left it, stamping it so it heads the saves
/// list next time. Nothing is awaited, so there is no later moment at which
/// to go anywhere else.
void _resume(BuildContext context, WidgetRef ref, Career save) {
  ref.read(careerServiceProvider).markPlayed(save.id);
  context.go('${Routes.hub}?careerId=${save.id}');
}
```

- [ ] **Step 6: The layout**

Create `lib/features/home/home_tablet_layout.dart`:

```dart
part of 'home_screen.dart';

/// The home screen on a landscape tablet: the logo and the title on the
/// left; on the right the way back into the last save, a new game, and the
/// saves list. Every button is the phone's own; settings stay top right.
class _HomeTabletLayout extends StatelessWidget {
  const _HomeTabletLayout({
    required this.lastSave,
    required this.lastNation,
    required this.onResume,
  });

  final Career? lastSave;
  final Nation? lastNation;

  /// Opens [lastSave]; null when there is none.
  final VoidCallback? onResume;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final save = lastSave;
    final resume = onResume;
    return Scaffold(
      key: HomeScreen.tabletLayoutKey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  tooltip: l.homeSettings,
                  icon: const Icon(
                    Icons.settings_outlined,
                    color: AppColors.onSurfaceVariant,
                  ),
                  onPressed: () => context.go(Routes.settings),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // The artwork's aspect (about 0.96:1), as on the
                          // phone: a box of another shape letterboxes it.
                          Image.asset(
                            'assets/images/fnm_logo.png',
                            width: 260,
                            height: 270,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stack) =>
                                const Icon(
                                  Icons.sports_soccer,
                                  size: 140,
                                  color: AppColors.primary,
                                ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Text(
                            'Football Nations\nManager',
                            textAlign: TextAlign.center,
                            style: textTheme.headlineLarge,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            l.homeLeadTheNation,
                            textAlign: TextAlign.center,
                            style: AppTypography.labelMedium.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xl),
                    Expanded(
                      flex: 5,
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 420),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (save != null && resume != null) ...[
                                _ContinueCard(
                                  nationName:
                                      lastNation?.name ?? l.homeYourNation,
                                  nationCode: lastNation?.code,
                                  inGameDate: save.inGameDate,
                                  cyclePointer: save.cyclePointer,
                                  onResume: resume,
                                ),
                                const SizedBox(height: AppSpacing.md),
                              ],
                              PrimaryButton(
                                label: l.homeNewGame,
                                icon: Icons.play_arrow_rounded,
                                onPressed: () => context.go(Routes.nations),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              TextButton(
                                onPressed: () => context.go(Routes.saves),
                                child: Text(
                                  save != null
                                      ? l.homeAllSaves
                                      : l.homeLoadGame,
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
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 7: Register, run, expect PASS**

Add `Routes.home,` to `tabletReadyPaths` in `lib/features/shell/tablet_shell.dart`.

Run: `flutter test test/widget/home_tablet_test.dart test/golden/phone_guard_home_test.dart test/widget/home_screen_test.dart test/widget/tablet_full_screen_sweep_test.dart`
Expected: PASS, phone golden unchanged.

- [ ] **Step 8: Analyze, full suite, commit**

Run: `flutter analyze && flutter test`

```bash
git add lib/features/home/home_screen.dart lib/features/home/home_tablet_layout.dart lib/features/shell/tablet_shell.dart test/widget/home_tablet_test.dart
git commit -m "feat(tablet): home as a landscape title screen

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 14: Record stage 5 in the spec, verify, simulator checks

**Files:**
- Modify: `docs/superpowers/specs/2026-10-09-tablet-ui-design.md`

- [ ] **Step 1: Add a section to the spec, after "Stage 4 adjustments"**

```markdown
## Stage 5 adjustments (2026-10-10)

- The record book, the world's all-time records and the legends are
  sortable `DataGrid`s (tabs for the record book's three boards, the
  world's four and the legends' hall of fame and XI) beside the player
  pane. Leaderboards on a tablet are never `LeaderRow`s in a dashboard
  tile: the row is built on `WholeText`, which a tile cannot measure. The
  record book's headline records and fiercest rival are panels above its
  grids; the all-time search is the screen State's, so a resize keeps it.
- Head to head: the two nation slots and the manager's ledger (a grid) on
  the left; the picked pairing on the right, its record above every
  meeting. The pair is the State's, so a resize keeps it; the slots open
  the phone's picker, a root dialog that pops with its own context. The
  meetings body is `H2hMeetingsView`, which the `/h2h-meetings` page also
  renders. It is not a `DetailTarget` yet: the match preview's head-to-head
  link still routes to its page.
- Achievements and challenges: the categories (tiers) down the left
  (`TabletListRow`, a new kit widget), the picked one's cards beside them
  in a two-column `ColumnFlow`. An achievement has no more to show than its
  card, so there is no detail pane.
- The career summary and the manager's career are two columns of the
  phone's cards. `CareerSummaryView` is the career summary's body; the
  Career page and the saves list show it in a pane.
- "Careers / saves" is two screens. The Career page (`/careers`) is the
  phone's menu beside the manager's career summary; the saves list
  (`/saves`) is a table of saves beside the picked save's career, with
  Continue, Back up and Delete acting on that save. Deleting the picked
  save falls back to the first. There is no save rename in the app.
- Home is a landscape title screen: the logo and title left, Continue, New
  game and the saves right. The new-game flow (nation select, new game,
  start from the bottom), team stats and the cycle rollover keep their
  phone layouts centred; they are left for stage 6.
- Sidebar destinations go back with pop or to the hub; pages under one go
  back to it (all-time records to records, meetings to head to head,
  challenges to achievements, the career pages to Career). The Career page
  has no back arrow, as on the phone.
- The sim's cascade also refreshes the history screens
  (`SeasonService._invalidateHistoryViews`): the record book and rivalry,
  the legends, the world's boards, head to head, achievements and
  challenges, the career summary and its numbers, and the manager's career
  with its strength curve.
- Every share sheet passes `sharePositionOrigin` (`shareOriginOf`): an iPad
  refuses one without it, which made exporting a save fail on iPad. The
  tablet's buttons pass their own rect; the phone's pass the screen's,
  which an iPhone ignores.
- The saves delete dialog pops with its own context and takes its services
  before it opens.
- German and Spanish need the 15 stage 5 keys when they merge (values in
  the stage 5 plan, Task 2).
```

- [ ] **Step 2: Full verification**

```bash
flutter analyze
flutter test
```

Expected: no new analyzer issues against the commit this stage started from (infos allowed only where they already existed); the FINAL summary line of `flutter test` reads "All tests passed!" with no `-N` failures. Paste that line into the task report. Every `test/golden/phone_guard_*` golden passes WITHOUT `--update-goldens`; `git status` shows no changed PNG.

- [ ] **Step 3: Commit the spec**

```bash
git add docs/superpowers/specs/2026-10-09-tablet-ui-design.md
git commit -m "docs: record tablet stage 5 adjustments in the spec

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
mkdir -p /tmp/fnm-stage5
xcrun simctl io booted screenshot /tmp/fnm-stage5/home.png
```

(repeat after navigating: `saves.png`, and with a save open `records.png`, `all_time.png`, `legends.png`, `h2h.png`, `achievements.png`, `challenges.png`, `career.png`, `career_summary.png`, `manager_history.png`). Read each PNG back and check it against this plan's layouts: panes side by side, nothing clipped at the panel edges, no phone-width frame.

- [ ] **Step 5: Manual checklist (the user drives the simulator)**

Ask the user to do each of these and report back; note each result in the task report:

1. **Home.** Cold start: the logo and title on the left, Continue (the last save), New game and All saves on the right; the cog top right opens Settings. Continue opens the hub of that save.
2. **Saves.** From home, All saves: the saves as a table, the first open on the right with its career summary. Pick another: its career opens. Back up this save: the share popover points at the button (it must appear; before this stage it failed with "Could not export that career"). Delete the picked save: the dialog closes, the other save is open. Back up all saves: the popover points at that button. Continue opens the picked save.
3. **Resize the saves list.** With a second save picked, narrow the iPad window below the tablet width (Stage Manager or split view) and widen it again: the same save is still open.
4. **Records.** Sidebar Records: the legends, world and head-to-head pills on top, team records beside the fiercest rival (once there is one), the boards as tabs; tap a player, his card opens on the right.
5. **World records and legends.** From the pills: the world's boards with the search over them; type a nation, every tab narrows. Sidebar Legends: the hall of fame as a grid, the XI on the second tab.
6. **Head to head.** Sidebar Head to head: tap an opponent in your ledger, the record and every meeting open on the right. Tap Away, pick a nation in the dialog: the dialog closes and the pairing changes; the page is still head to head.
7. **Achievements and challenges.** Sidebar Achievements: the categories on the left, the cards beside them; Challenges in the heading; back from Challenges returns to Achievements.
8. **Career.** Sidebar Career: the menu beside your career summary; every line opens its page; the career summary and manager career pages are two columns, and back returns to Career.
9. **Continue under history screens.** With Records (or Achievements) open, press the top bar's Continue until a match is played: the boards (or the progress) update without leaving the screen.

- [ ] **Step 6: Phone sanity check**

Run the app on an iPhone simulator (`flutter run -d <iPhone simulator id>`; a simulator, so `flutter run` upgrading in place is fine). Home, saves (export, delete), records, all-time records, legends, head to head (the picker sheet, a pairing, every meeting), achievements, challenges, the Career menu, the career summary and the manager's career look and behave exactly as before.

- [ ] **Step 7: Android tablet**

No Android emulator is installed on this Mac (stage 1 finding). Record in the report that the Android tablet check (Pixel Tablet AVD or a real tablet; installs upgrade in place with `adb install -r`, never `flutter install`, never `adb uninstall`) is left for the user.
