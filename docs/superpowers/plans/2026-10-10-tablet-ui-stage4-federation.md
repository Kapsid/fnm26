# Tablet UI, Stage 4: Federation and manager. Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Every federation and manager screen has a tablet layout: Finances and Board objectives as dashboards of panels, the manager's page as skills beside name and staff, the budget setup as the investment editor beside what it buys (with the staff and the Confirm), the youth pyramid as sortable grids by age group beside the picked boy's card, Y as the timeline with trending conversations and voices at the side (a post or an account opens in that side pane), and the two event screens Continue opens (training camp, naturalisation) as landscape pages. Federation, manager and Y screens stay correct while the tablet's top-bar Continue runs the sim underneath them, and an event decided on a tablet no longer leaves the top bar offering it again.

**Architecture:** Same pattern as stages 2 and 3. Every screen in this stage is an in-shell route, so each picks its layout at the top of `build` with `TabletShellScope.isActive(context)`, keeps its providers, State and write paths, and draws its tablet layout from a `part` file beside it. Where a phone card's body is reused inside a tablet `Panel`, the body is moved into a private widget that the phone card wraps unchanged (tall phone goldens, created first, prove the phone is pixel-identical). The two screens with writes the user drives through State (budget setup, naturalisation) build both layouts from the same State, so a window crossing 1000 px keeps an allocation in progress, and both layouts call the same confirm/resolve methods. A new kit widget, `TabletPage` (heading over content), frames every page of this stage. The sim's invalidation cascade gains `_invalidateFederationViews`. Every converted path joins `tabletReadyPaths`; the route sweep (three sizes) must stay green.

**Tech Stack:** Flutter, flutter_riverpod 2.6 (manual providers, no codegen), go_router 17, gen_l10n (5 ARB locales on this branch: en cs fr it pl), flutter_test golden files for the phone guards.

**Spec:** `docs/superpowers/specs/2026-10-09-tablet-ui-design.md` (stage 4 = "Federation and manager"; read the Screen layouts rows for Finances/board objectives/manager, Budget setup, Youth, Training camp and Y, and the Stage 1, 2 and 3 adjustments sections, which this plan follows).

**Stage 3 plan (format and conventions):** `docs/superpowers/plans/2026-10-09-tablet-ui-stage3-competitions.md`. Where it and the code differ, the code is the source of truth: `kTabletLayoutMinWidth` (1000), per-page framing (`ShellPhoneFrame`/`PhoneWidthFrame` in the shell, `FullScreenPhoneFrame` outside it), `PanelBox` is a `Material`, `DataGrid` scrolls sideways when its columns do not fit and has a `DataGridController`, `MasterDetail.minDetailWidth`, `TabletTabBar`/`TabletDetailPage`, `ColumnFlow`, `DashboardGrid`'s intrinsic-height rule, `sheetIsDialog`, and the seeded-save harness (`seedSave`, `pumpRoute`, `settle` that fails on a stuck spinner, `kTabletSizes`, `kSeededCareerId`, `seededNationId`, `showTab`, `expectAppGolden`).

## Global Constraints

- Phones keep the current UI exactly. Nothing in the phone path changes behaviour. Every converted screen gets a phone guard golden BEFORE it is touched (a tall one, 390 x 2400, beside the 390 x 844 one), and those goldens must pass unchanged after. The only phone-visible behaviour changes in this stage are the two named fixes (Y re-marks the feed read if it refreshes while open, which cannot happen on a phone; a naturalisation decision refreshes the hub's data), both invisible on a phone.
- Tablet = `shortestSide >= 600` logical px. Landscape only. Tablet layouts need a window at least `kTabletLayoutMinWidth` (1000) wide; narrower tablet windows get the phone app.
- Every screen in this stage is an in-shell route: it picks its tablet layout with `TabletShellScope.isActive(context)`. None of them is in `Routes.fullScreen`; none uses `useTabletLayout`.
- A screen whose tablet layout uses the whole content area is added to `tabletReadyPaths` IN THE SAME COMMIT as the layout (a screen that asks `TabletShellScope.isActive` but is not registered would draw its tablet layout inside a 600 phone frame).
- Every tablet layout is tested at 1194 x 834, 1080 x 810 and 1024 x 768 (`kTabletSizes`): no exception, the layout's key present, no `PhoneWidthFrame`. The route sweep (`test/widget/tablet_route_sweep_test.dart`) stays green after every task.
- `DashboardGrid` rows are `IntrinsicHeight`s: nothing inside a tile may be a scrollable, a `LayoutBuilder` or a `WholeText` (so `StaffCard`, `YPostTile` and `ColumnFlow` never go in a tile). A panel whose body scrolls is `Panel(expand: true)` in a Row or Column.
- Release target: v1.0.4 on both iOS and Android. Do not bump `pubspec.yaml` in this stage.
- No `@riverpod` codegen; providers by hand. No change to game logic or the database schema. Providers are not edited; Task 3 only adds invalidations to the sim's cascade, and Task 11 two invalidations to the naturalisation decision.
- Derived providers go stale after a sim step. On a tablet the top bar's Continue runs the sim while ANY in-shell screen is on show, so every federation, manager and Y provider a tablet keeps on show is invalidated by the cascade (Task 3). A tablet layout may only watch providers that cascade refreshes or that the phone layout of the same screen already watches.
- Writes go through the phone's own code: the tablet calls the same State methods and services (`_confirm`, `_resolve`, `ManagerService.raise/rename`, `TrainingCampService.choose`, `YouthWatchStore.mark/unmark`, `StaffCard._pick`). Nothing here adds a second write path.
- Budget levels: the "budget invested in whole €4M levels" work is NOT on this branch (it is uncommitted in the main checkout). This plan targets the €500k sliders that ARE here, and keeps every budget rule in one place (`_budgetFor` in Task 9, `InvestmentEditor`) so the levels work merges into a single spot for both layouts. Do not port the levels work in this stage.
- If any `build_runner` step is needed, run it with `--force-jit`. (Nothing in this plan should need it.)
- All new user-facing strings go into all 5 ARB files (`en cs fr it pl`), then `flutter gen-l10n`, then `dart run tool/export_copy.dart` so `copy/strings.csv` stays in sync. German and Spanish ARB files are not on this branch; the 9 new keys of Task 2 must be added to them when that work merges (values listed in Task 2). Prefer existing keys; reused keys are named in each task.
- No em dashes in user-facing copy. Never "World Cup" in English copy (it is "World Championship"). French text puts a space before a colon (the copy avoids colons altogether in this stage).
- Sheets: inside a sheet builder pop with the sheet's own context, and pop BEFORE navigating from sheet content (`showAdaptiveSheet`, `sheetIsDialog`). The staff picker (`StaffCard._pick`) already does.
- Never run `flutter install` against a physical device. Simulators only in this stage; a simulator build is installed in place with `xcrun simctl install`, never uninstalled first.
- Commit messages end with `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`.
- Run tests with `flutter test` from the repo root. Golden baselines are created ONLY in the "create the baseline" step of a task (`flutter test --update-goldens <file>`), before the screen is changed, and committed in that step. Never update a golden to make a later step pass; a changed phone golden is a phone regression.
- `settle` fails loudly when a screen is still showing a `CircularProgressIndicator` at its cap, unless the call passes `allowSpinner: true` with a comment saying why the spinner is the screen's content. No call in this plan needs it.

## Review depth

User-approved: low-risk read-only display screens get ONE combined review per stage; anything that writes, shared code and event flows are reviewed per task. Each task is tagged:

- **risk: high (per-task review)**: Tasks 1, 3, 8, 9, 10, 11.
- **risk: low (batched review)**: Tasks 2, 4, 5, 6, 7, 12. Review Tasks 2, 4, 5, 6 and 7 together once Task 7 lands (one reviewer, given those tasks' commit SHAs from the ledger), before Task 8 starts. Task 12 (tests only) is reviewed with the stage's final review.

## Review Focus

1. **Stale federation screens under the top bar's Continue.** On a phone none of these screens is on show while the sim runs; on a tablet they are, their auto-disposed providers are kept alive by being watched, and they read the database imperatively. The tablet hub's Y panel already keeps the Y feed alive across the whole shell. Pinned in Task 3: with a listener on each of `financeViewProvider`, `federationFundsProvider`, `managerViewProvider`, `youthPyramidProvider`, `youthShortlistProvider`, `yFeedProvider`, `pendingNaturalizationProvider` and `trainingCampPlanProvider`, one `SeasonService.advance` and one `playPlayerMatch` each hand every one of them a new future; plus a source guard that `_skipToChampion` runs the same cascade.
2. **An event decided on a tablet that the top bar keeps offering.** The tablet top bar keeps `hubDataProvider` and `nextEventProvider` alive for the whole shell; on a phone they are rebuilt when the hub comes back. A decision whose write the next-event logic reads imperatively leaves the bar on the old event. Pinned in Task 11 (accept a naturalisation on a tablet: the bar read "Naturalisation" before, does not after) and Task 9 (confirm the budget on a tablet: the bar read "Set budget" before, does not after).
3. **A resize that throws away an allocation.** iPadOS windows resize; the budget State must survive the layout switch at 1000 px and both layouts must read the same `_alloc`. Pinned in Task 9: €8M put into Youth on the tablet, the window shrunk to 900 x 810 (phone layout, Youth slider at €8M) and grown back (tablet, still €8M, the effect line on the right still quoting €8M).
4. **A tablet control that spends or decides differently from the phone.** The tablet calls the phone's write paths; a copy would drift. Pinned in Task 8 (two points raise exactly two skills by one each, then every + is disabled), Task 9 (Confirm enabled exactly when `budgetReady` says so, and the stored investment equals the allocation), Task 10 (the camp tapped is the camp stored, country and index) and Task 11 (accept stores `accepted`, decline `declined`).
5. **Phone drift from moved bodies.** Tasks 4, 5, 7, 9, 10 and 11 move phone card bodies (balance, buildings, income, investment, board confidence and objective, Y thread and profile, budget banner and confirm bar, camp header, naturalisation offer card and decision row) into widgets both layouts share. Any change to what a phone draws is a regression. Pinned by tall phone goldens of each screen created before it is touched (Y's also of the post and profile pages), and by the existing `y_screen_test`, `youth_screen_test`, `youth_watchlist_test`, `budget_back_test` and `staff_effect_test`, which must pass untouched.

---

## File structure

**Create**
- `lib/shared/tablet/tablet_page.dart`: `TabletPage` (heading over the page's content).
- `lib/features/y/y_trends.dart`: `YTrend`, `YVoiceCount`, `yTrending`, `yVoices`.
- `lib/features/federation/finances_tablet_layout.dart` (part of `finances_screen.dart`).
- `lib/features/hub/board_objectives_tablet_layout.dart` (part of `board_objectives_screen.dart`).
- `lib/features/squad/youth_tablet_layout.dart` (part of `youth_screen.dart`).
- `lib/features/y/y_tablet_layout.dart` (part of `y_screen.dart`).
- `lib/features/manager/manager_tablet_layout.dart` (part of `manager_screen.dart`).
- `lib/features/federation/budget_setup_tablet_layout.dart` (part of `budget_setup_screen.dart`).
- `lib/features/squad/training_camp_tablet_layout.dart` (part of `training_camp_screen.dart`).
- `lib/features/federation/naturalization_tablet_layout.dart` (part of `naturalization_screen.dart`).
- `test/helpers/federation_fixtures.dart`: fake camp plans, a seeded naturalisation offer, a fake Y timeline, a manager with points, the budget marked set.
- `test/golden/phone_guard_{finances,board,youth,y,manager,budget,camp,naturalization}_test.dart` and their `test/golden/goldens/*.png`.
- Tests listed per task.

**Modify**
- `lib/shared/tablet/tablet.dart` (barrel).
- `lib/features/shell/tablet_shell.dart` (`tabletReadyPaths`).
- `lib/features/hub/hub_providers.dart` (`SeasonService._invalidateFederationViews`).
- `lib/features/federation/finances_screen.dart`, `budget_setup_screen.dart`, `investment_editor.dart` (`showEffects`), `naturalization_screen.dart`.
- `lib/features/hub/board_objectives_screen.dart`.
- `lib/features/manager/manager_screen.dart`.
- `lib/features/squad/youth_screen.dart`, `training_camp_screen.dart`.
- `lib/features/y/y_screen.dart`, `y_post_detail.dart` (`YPostThread`), `y_profile_sheet.dart` (`YProfileView`).
- `test/widget/competition_refresh_after_step_test.dart`, `test/helpers/competition_fixtures.dart`, `test/widget/continental_detail_tablet_test.dart`, `test/widget/nations_cup_tablet_test.dart`, `test/widget/cup_detail_tablet_test.dart`, `test/widget/detail_pane_host_test.dart`, `test/widget/match_preview_tablet_test.dart` (Task 12 carry-overs).
- `lib/l10n/app_{en,cs,fr,it,pl}.arb`, generated `app_localizations*.dart`, `copy/strings.csv`.
- `docs/superpowers/specs/2026-10-09-tablet-ui-design.md` (Task 13).

## Stage 3 carry-overs folded in

| Finding (stage 3 ledger) | Where |
|---|---|
| Only the advance cascade is tested; `skipToChampion` and the player-match commit are not | Task 3 (a `playPlayerMatch` variant on a seeded save; a source guard for `_skipToChampion`, whose real run simulates a whole cycle) |
| `liveTab` re-key may jump the tab after a refresh (decide/fix) | Task 12. Decision: keep. The controller is keyed by the landing tab, and `valueOrNull` keeps the old data while a refresh loads, so a refresh that does not move the stage keeps the manager's tab; a stage change re-lands on the live stage on purpose. Pinned by a test |
| No player to nation pane switch test | Task 12 |
| Continental finals, bracket and 7-tab cup untested on tablet | Task 12 (`fakeContinentalData`) |
| Nations Cup zones untested on tablet | Task 12 (`fakeAfricanNationsCup`) |
| Match preview hosted, friendly and away branches unpinned | Task 12 |

---

### Task 1: Kit and harness: `TabletPage`, federation fixtures

**risk: high (per-task review)**. Shared code every later task builds on.

**Files:**
- Create: `lib/shared/tablet/tablet_page.dart`
- Modify: `lib/shared/tablet/tablet.dart`
- Create: `test/helpers/federation_fixtures.dart`
- Test: `test/widget/tablet_page_test.dart` (new), `test/widget/federation_fixtures_test.dart` (new)

**Interfaces:**
- Produces (`tablet_page.dart`): `class TabletPage extends StatelessWidget { const TabletPage({required Key scaffoldKey, required String title, required Widget child, VoidCallback? onBack, Widget? trailing, Key? key}); }`.
- Produces (`federation_fixtures.dart`):
  - `List<int> campHosts(int count)`
  - `TrainingCampPlan fakeCampPlan(List<int> hostIds)`
  - `Future<({int playerId, int sourceNationId})> offerNaturalization(WidgetTester tester, SeededSave save)`
  - `Future<void> markBudgetSet(WidgetTester tester, SeededSave save)`
  - `Override managerWithPoints(int earned)`
  - `YPost fakePost(String name, YVoice voice, String key, DateTime date, {YTemplate template = YTemplate.winTight, List<String> args = const ['Spain', '2-1'], String? replyTo, YMood? mood})`
  - `YTimeline fakeYTimeline()`
  - `PrimaryButton topBarContinue(WidgetTester tester)`
- Consumes: `TabletScreenHeader`, `realNationsById`, `fieldOf` (`competition_fixtures.dart`), `TrainingCamps.forHost`, `careerRepositoryProvider`, `competitionRepositoryProvider`, `playerRepositoryProvider`, `budgetSetupKind`, `managerViewProvider`, `ManagerSkills`, `TabletTopBar`.

- [ ] **Step 1: Write the failing tests**

Create `test/widget/tablet_page_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/shared/tablet/tablet.dart';

void main() {
  testWidgets('the heading, then the child filling what is left', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      const MaterialApp(
        home: TabletPage(
          scaffoldKey: Key('page'),
          title: 'Finances',
          child: SizedBox.expand(key: Key('body')),
        ),
      ),
    );
    expect(find.byKey(const Key('page')), findsOneWidget);
    expect(find.text('Finances'), findsOneWidget);
    // Reached from the sidebar there is nowhere to go back to.
    expect(find.byKey(TabletScreenHeader.backKey), findsNothing);
    final header = tester.getRect(find.byType(TabletScreenHeader));
    final body = tester.getRect(find.byKey(const Key('body')));
    expect(body.top, greaterThanOrEqualTo(header.bottom));
    expect(body.bottom, 600 - AppSpacing.md);
    expect(body.width, 800 - 2 * AppSpacing.md);
  });

  testWidgets('a back arrow when there is somewhere to go, and an action', (
    tester,
  ) async {
    var back = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: TabletPage(
          scaffoldKey: const Key('page'),
          title: 'Youth',
          onBack: () => back++,
          trailing: const Text('call-ups'),
          child: const SizedBox(),
        ),
      ),
    );
    await tester.tap(find.byKey(TabletScreenHeader.backKey));
    expect(back, 1);
    expect(find.text('call-ups'), findsOneWidget);
  });
}
```

Create `test/widget/federation_fixtures_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/squad/training_camp.dart';
import 'package:fnm/features/federation/budget_setup_screen.dart';
import 'package:fnm/features/federation/naturalization_providers.dart';
import 'package:fnm/features/manager/manager_providers.dart';

import '../helpers/federation_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The fakes later tasks lean on must be what they say they are.
void main() {
  test('a solo host offers its four camps, three hosts two each', () {
    final solo = fakeCampPlan(campHosts(1));
    expect(solo.options, hasLength(TrainingCamps.count));
    expect(solo.decided, isFalse);
    final shared = fakeCampPlan(campHosts(3));
    expect(shared.options, hasLength(6));
    expect(shared.hostNames, hasLength(3));
    expect(campHosts(3), isNot(contains(seededNationId)));
  });

  test('the Y feed: three conversations, a seam, Ana twice', () {
    final feed = fakeYTimeline();
    expect(feed.posts, hasLength(7));
    expect(feed.reserveFrom, 6);
    expect(feed.posts.where((p) => p.handle == '@AnaFan'), hasLength(2));
  });

  testWidgets('an offer lands on the save; the budget can be marked set', (
    tester,
  ) async {
    final save = await seedSave(tester);
    final offer = await offerNaturalization(tester, save);
    await markBudgetSet(tester, save);
    await tester.runAsync(() async {
      final sub = save.container.listen(
        pendingNaturalizationProvider(save.careerId).future,
        (_, _) {},
      );
      final pending = await sub.read();
      sub.close();
      expect(pending?.player.id, offer.playerId);
      expect(pending?.sourceNation.id, offer.sourceNationId);
      expect(
        await save.container
            .read(competitionRepositoryProvider)
            .hasWatchedDraw(
              save.careerId,
              save.career.cyclePointer,
              budgetSetupKind,
            ),
        isTrue,
      );
    });
  });

  testWidgets('a manager with points has them to spend', (tester) async {
    final save = await seedSave(tester, overrides: [managerWithPoints(2)]);
    await tester.runAsync(() async {
      final sub = save.container.listen(
        managerViewProvider(save.careerId).future,
        (_, _) {},
      );
      final view = await sub.read();
      sub.close();
      expect(view?.pointsAvailable, 2);
    });
  });
}
```

- [ ] **Step 2: Run them to verify they fail**

Run: `flutter test test/widget/tablet_page_test.dart test/widget/federation_fixtures_test.dart`
Expected: FAIL to compile (`TabletPage` and `federation_fixtures.dart` do not exist).

- [ ] **Step 3: `TabletPage`**

Create `lib/shared/tablet/tablet_page.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/shared/tablet/screen_header.dart';

/// An in-shell tablet page: the screen's heading (a back arrow when [onBack]
/// is given, an action on the right) over [child], which takes the rest of
/// the content area and lays itself out: a dashboard in a scroll view, panes
/// in a Row.
///
/// `TabletDetailPage` is the competition screens' variant, which also boxes
/// its child in one panel.
class TabletPage extends StatelessWidget {
  const TabletPage({
    required this.scaffoldKey,
    required this.title,
    required this.child,
    this.onBack,
    this.trailing,
    super.key,
  });

  /// The page's key, which tests and the route sweeps look for.
  final Key scaffoldKey;
  final String title;
  final Widget child;

  /// Where the back arrow goes; no arrow when null (an event page, which is
  /// left by deciding).
  final VoidCallback? onBack;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TabletScreenHeader(
              title: title,
              onBack: onBack,
              trailing: trailing,
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
```

In `lib/shared/tablet/tablet.dart` add, in alphabetical place (after `export 'tablet_detail_page.dart';`):

```dart
export 'tablet_page.dart';
```

- [ ] **Step 4: The fixtures**

Create `test/helpers/federation_fixtures.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/manager/manager_skills.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/domain/services/squad/training_camp.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/budget_setup_screen.dart';
import 'package:fnm/features/manager/manager_providers.dart';
import 'package:fnm/features/shell/tablet_top_bar.dart';
import 'package:fnm/features/squad/training_camp_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import 'competition_fixtures.dart';
import 'seeded_save.dart';

// Fakes for the federation, manager and Y screens: the states a fresh save
// does not reach on its own (a camp to choose, an offer to decide, points to
// spend, a feed with something in it).

/// The best-ranked nations after the manager's, [count] of them: hosts for a
/// base-camp decision.
List<int> campHosts(int count) => [
  for (final n in fieldOf(seededNationId, count + 1).skip(1)) n.id,
];

/// A World Championship base-camp decision in [hostIds]' countries, the first
/// the primary host, nothing chosen yet. Cycle 0, as the seeded save is. A
/// solo host offers all its camps, co-hosts fewer each, as the provider does.
TrainingCampPlan fakeCampPlan(List<int> hostIds) {
  final byId = realNationsById;
  final perHost = switch (hostIds.length) {
    <= 1 => TrainingCamps.count,
    2 => 3,
    _ => 2,
  };
  final primary = byId[hostIds.first]!;
  return TrainingCampPlan(
    tournament: 'GROUP',
    competition: 'World Championship',
    hostId: primary.id,
    hostName: primary.name,
    hostCode: primary.code,
    hostNames: [for (final id in hostIds) byId[id]!.name],
    options: [
      for (final id in hostIds)
        for (final camp in TrainingCamps.forHost(
          hostId: id,
          cities: _fakeCities(byId[id]!.name),
        ).take(perHost))
          (
            hostId: id,
            hostName: byId[id]!.name,
            hostCode: byId[id]!.code,
            camp: camp,
          ),
    ],
    cycle: 0,
    chosen: null,
  );
}

/// Regions named after their country, so co-hosts' camps never share a
/// name (the built-in fallback regions are the same for every country).
List<String> _fakeCities(String nation) => [
  '$nation North',
  '$nation South',
  '$nation East',
  '$nation West',
  '$nation Central',
];

/// Puts a naturalisation offer on [save]: the best player of the best-ranked
/// nation after the manager's, asking to switch this cycle.
Future<({int playerId, int sourceNationId})> offerNaturalization(
  WidgetTester tester,
  SeededSave save,
) async {
  late ({int playerId, int sourceNationId}) out;
  await tester.runAsync(() async {
    final source = fieldOf(save.nationId, 2)[1];
    final pool = await save.container
        .read(playerRepositoryProvider)
        .byNation(
          source.id,
          agingYears: CareerService.agingYears(save.career),
          saveSeed: save.career.rngSeed,
        );
    final best = pool.reduce((a, b) => a.overall >= b.overall ? a : b);
    await save.container
        .read(careerRepositoryProvider)
        .addNaturalizationOffer(
          careerId: save.careerId,
          playerId: best.id,
          sourceNationId: source.id,
          cycle: save.career.cyclePointer,
        );
    out = (playerId: best.id, sourceNationId: source.id);
  });
  return out;
}

/// Marks this cycle's budget as set, as confirming it does, so the hub's
/// next event is whatever comes after the budget.
Future<void> markBudgetSet(WidgetTester tester, SeededSave save) async {
  await tester.runAsync(
    () => save.container
        .read(competitionRepositoryProvider)
        .markDrawWatched(
          save.careerId,
          save.career.cyclePointer,
          budgetSetupKind,
        ),
  );
}

/// The manager's page as the real provider builds it from the stored career,
/// but with [earned] points earned, so a fresh save has some to spend. The
/// skills are re-read on every build, so a raise shows.
Override managerWithPoints(int earned) =>
    managerViewProvider(kSeededCareerId).overrideWith((ref) async {
      final career = await ref
          .watch(careerRepositoryProvider)
          .byId(kSeededCareerId);
      if (career == null) return null;
      final skills = <ManagerSkill, int>{
        ManagerSkill.manManagement: career.skillManManagement,
        ManagerSkill.tactical: career.skillTactical,
        ManagerSkill.youthDevelopment: career.skillYouthDevelopment,
        ManagerSkill.negotiation: career.skillNegotiation,
      };
      return (
        career: career,
        skills: skills,
        pointsEarned: earned,
        pointsAvailable: ManagerSkills.pointsAvailable(
          earned: earned,
          levels: skills,
        ),
        staffWages: 0,
      );
    });

/// One Y post, its handle the name without spaces.
YPost fakePost(
  String name,
  YVoice voice,
  String key,
  DateTime date, {
  YTemplate template = YTemplate.winTight,
  List<String> args = const ['Spain', '2-1'],
  String? replyTo,
  YMood? mood,
}) => (
  voice: voice,
  handle: '@${name.replaceAll(' ', '')}',
  displayName: name,
  template: template,
  variant: 0,
  args: args,
  date: date,
  key: key,
  replyTo: replyTo,
  mood: mood,
);

/// A feed with something in it: the 2-1 win and three replies (the most
/// talked about), a draw and one reply, then a tournament exit kept back from
/// earlier in the cycle, below the seam. Ana Fan posts twice, so she leads
/// the voices.
YTimeline fakeYTimeline() {
  final win = DateTime(2027, 6, 10);
  final draw = DateTime(2027, 6, 6);
  return (
    posts: [
      fakePost('Ana Fan', YVoice.fan, 'fx:1|fan', win),
      fakePost(
        'Ben Stats',
        YVoice.stats,
        'fx:1|stats',
        win,
        replyTo: 'fx:1|fan',
      ),
      fakePost(
        'Cid Rival',
        YVoice.rival,
        'fx:1|rival',
        win,
        template: YTemplate.reaction,
        mood: YMood.fury,
        replyTo: 'fx:1|fan',
      ),
      fakePost(
        'Dee Pundit',
        YVoice.pundit,
        'fx:1|pundit',
        win,
        replyTo: 'fx:1|fan',
      ),
      fakePost(
        'Ana Fan',
        YVoice.fan,
        'fx:2|fan',
        draw,
        template: YTemplate.drew,
      ),
      fakePost(
        'Eli Meme',
        YVoice.meme,
        'fx:2|meme',
        draw,
        template: YTemplate.drew,
        replyTo: 'fx:2|fan',
      ),
      fakePost(
        'Fay Wire',
        YVoice.breaking,
        'out:1|breaking',
        DateTime(2026, 7, 1),
        template: YTemplate.eliminated,
        args: const ['European Championship'],
      ),
    ],
    reserveFrom: 6,
  );
}

/// The top bar's Continue, whose label is the hub's next event.
PrimaryButton topBarContinue(WidgetTester tester) =>
    tester.widget<PrimaryButton>(
      find.descendant(
        of: find.byType(TabletTopBar),
        matching: find.byType(PrimaryButton),
      ),
    );
```

- [ ] **Step 5: Run the tests, expect PASS**

Run: `flutter test test/widget/tablet_page_test.dart test/widget/federation_fixtures_test.dart`
Expected: PASS.

- [ ] **Step 6: Analyze, commit**

Run: `flutter analyze lib/shared/tablet test/helpers test/widget/tablet_page_test.dart test/widget/federation_fixtures_test.dart`
Expected: no new issues.

```bash
git add lib/shared/tablet/tablet_page.dart lib/shared/tablet/tablet.dart test/helpers/federation_fixtures.dart test/widget/tablet_page_test.dart test/widget/federation_fixtures_test.dart
git commit -m "feat(tablet): TabletPage and the federation test fixtures

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 2: Stage 4 copy in all 5 languages

**risk: low (batched review)**.

**Files:**
- Modify: `lib/l10n/app_en.arb`, `app_cs.arb`, `app_fr.arb`, `app_it.arb`, `app_pl.arb`
- Regenerate: `lib/l10n/app_localizations*.dart`, `copy/strings.csv`
- Test: existing `test/unit/l10n/*` guards

**Interfaces:**
- Produces these `AppLocalizations` getters: `gridColCeiling`, `gridColYearGain`, `gridColMarkedAt`, `budgetSetupTitle`, `budgetEffectsTitle`, `naturalisationTitle`, `yTrending`, `yVoices`, `yConversation`.
- Reused existing getters (do not add): `sideFinances`, `sideManager`, `youthTitle`, `yTitle`, `campTitle`, `boardObjectivesTitle`, `boardObjectivesConfidence`, `federationBalance`, `federationDevelopment`, `federationProjectedAtSeasonEnd`, `federationThisSeasonLocked`, `federationNextCycleLocked`, `federationBudgetHeading`, `federationDistributeBudget`, `deptEffectNone`, `youthWatching`, `youthReleased`, `youthEmptyLevel`, `u21CallUps`, `squadDevPosition`, `squadSortName`, `playerAge`, `playerStatCaps`, `teamOverall`, `gridColMove`, `gridColStatus`, `gridViewOverview`, `panePickPlayer`, `federationOfferToSwitchAllegiance`, `federationContinue`, `hubContinue`, `yEmpty`.

- [ ] **Step 1: Add the English strings with descriptions**

Append before the closing `}` of `lib/l10n/app_en.arb` (add a comma after the previous last entry, `"@tourDrawViewGroups": {...}`):

```json
  "gridColCeiling": "Ceiling",
  "@gridColCeiling": { "description": "Tablet youth table column: the scout's star read on how good a boy can become." },
  "gridColYearGain": "Gain",
  "@gridColYearGain": { "description": "Tablet youth table column: rating points a boy gained over the last year." },
  "gridColMarkedAt": "When marked",
  "@gridColMarkedAt": { "description": "Tablet youth watchlist column: the boy's rating when the manager put him on the list." },
  "budgetSetupTitle": "Set your budget",
  "@budgetSetupTitle": { "description": "Tablet budget setup screen heading." },
  "budgetEffectsTitle": "What this budget buys",
  "@budgetEffectsTitle": { "description": "Tablet budget setup: panel listing what each department's money buys this cycle." },
  "naturalisationTitle": "Naturalisation",
  "@naturalisationTitle": { "description": "Tablet naturalisation decision screen heading." },
  "yTrending": "Trending",
  "@yTrending": { "description": "Tablet Y feed side panel: the conversations with the most posts." },
  "yVoices": "Voices",
  "@yVoices": { "description": "Tablet Y feed side panel: the accounts that post the most." },
  "yConversation": "Conversation",
  "@yConversation": { "description": "Tablet Y feed side pane heading: one post and the replies to it." }
```

- [ ] **Step 2: Add the translations**

Append the same keys (values only, no `@` entries) to each locale file, after its last entry (add the comma):

| key | cs | fr | it | pl |
|---|---|---|---|---|
| gridColCeiling | Strop | Plafond | Potenziale | Potencjał |
| gridColYearGain | Zlepšení | Progrès | Crescita | Postęp |
| gridColMarkedAt | Při označení | Au repérage | Alla segnalazione | Przy oznaczeniu |
| budgetSetupTitle | Rozdělte rozpočet | Fixez votre budget | Imposta il budget | Ustal budżet |
| budgetEffectsTitle | Co za tento rozpočet získáte | Ce que ce budget apporte | Cosa compra questo budget | Co daje ten budżet |
| naturalisationTitle | Naturalizace | Naturalisation | Naturalizzazione | Naturalizacja |
| yTrending | Právě se řeší | Tendances | Di tendenza | Na czasie |
| yVoices | Hlasy | Voix | Voci | Głosy |
| yConversation | Konverzace | Conversation | Conversazione | Rozmowa |

For the de/es files when they merge (not on this branch): gridColCeiling `Potenzial` / `Techo`; gridColYearGain `Zuwachs` / `Mejora`; gridColMarkedAt `Beim Markieren` / `Al marcarlo`; budgetSetupTitle `Budget festlegen` / `Fija tu presupuesto`; budgetEffectsTitle `Was dieses Budget bringt` / `Lo que compra este presupuesto`; naturalisationTitle `Einbürgerung` / `Nacionalización`; yTrending `Im Trend` / `Tendencias`; yVoices `Stimmen` / `Voces`; yConversation `Unterhaltung` / `Conversación`.

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
git commit -m "feat(tablet): stage 4 copy (youth grid, budget, naturalisation, Y side panels)

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 3: Federation, manager and Y screens refresh after a sim step

**risk: high (per-task review)**. Touches `SeasonService`, the sim's invalidation cascade.

Stage 3 made the cascade refresh every competition screen (`_invalidateCompetitionViews`, called at the end of the advance step, `_skipToChampion` and `_playPlayerMatch`). The screens of this stage have the same problem: on a tablet the top bar's Continue runs the sim with any of them on show, their auto-disposed providers are kept alive by being watched, and they read the database imperatively. Concretely: the projected prize money (`financeViewProvider`), the balance (`federationFundsProvider`), the manager's points, which a trophy earns (`managerViewProvider`), the youth pyramid, which ages on 1 December (`youthPyramidProvider`, `youthShortlistProvider`), the Y feed, which grows with every match and which the tablet hub's Y panel already keeps alive across the whole shell (`yFeedProvider`), a naturalisation offer the step may roll (`pendingNaturalizationProvider`) and the base camp, which closes with the tournament's first match (`trainingCampPlanProvider`). `staffRoomProvider` needs nothing: it watches `squadDataProvider`, which the cascade already refreshes.

**Files:**
- Modify: `lib/features/hub/hub_providers.dart`
- Modify: `test/widget/competition_refresh_after_step_test.dart`

**Interfaces:**
- Produces: `SeasonService._invalidateFederationViews()` (private), called from the end of `_invalidateCompetitionViews()`, so all three step paths run it.
- Consumes: `financeViewProvider`, `federationFundsProvider` (`federation_service.dart`, already imported), `managerViewProvider` (`manager_providers.dart`), `youthPyramidProvider`, `youthShortlistProvider` (`youth_providers.dart`), `yFeedProvider` (`y_providers.dart`), `pendingNaturalizationProvider` (`naturalization_providers.dart`), `trainingCampPlanProvider` (`training_camp_providers.dart`, already imported), `matchPreviewProvider`, `SeasonService.playPlayerMatch`.

- [ ] **Step 1: Write the failing tests**

Replace the whole of `test/widget/competition_refresh_after_step_test.dart` with:

```dart
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/features/federation/federation_service.dart';
import 'package:fnm/features/federation/naturalization_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/manager/manager_providers.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/nations/nation_vitrine_providers.dart';
import 'package:fnm/features/results/results_providers.dart';
import 'package:fnm/features/squad/training_camp_providers.dart';
import 'package:fnm/features/squad/youth_providers.dart';
import 'package:fnm/features/tournaments/continental_clash_providers.dart';
import 'package:fnm/features/tournaments/continental_detail_providers.dart';
import 'package:fnm/features/tournaments/cup_detail_providers.dart';
import 'package:fnm/features/tournaments/intercontinental_playoff_providers.dart';
import 'package:fnm/features/tournaments/nations_cup_providers.dart';
import 'package:fnm/features/tournaments/tournaments_providers.dart';
import 'package:fnm/features/tournaments/wc_host_theme.dart';
import 'package:fnm/features/y/y_providers.dart';

import '../helpers/seeded_save.dart';

typedef _Views = Map<String, ProviderListenable<Future<Object?>>>;

/// The competition screens' data (stage 3).
_Views _competitionViews(SeededSave save) {
  final id = save.careerId;
  return {
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
    'wcHost': wcHostThemeProvider(id).future,
    'continentalHost': continentalHostThemeProvider(id).future,
    'vitrine': nationVitrineProvider((
      careerId: id,
      nationId: save.nationId,
    )).future,
  };
}

/// The federation, manager and Y screens' data (stage 4).
_Views _federationViews(SeededSave save) {
  final id = save.careerId;
  return {
    'finances': financeViewProvider(id).future,
    'funds': federationFundsProvider(id).future,
    'manager': managerViewProvider(id).future,
    'youth': youthPyramidProvider(id).future,
    'shortlist': youthShortlistProvider(id).future,
    'y': yFeedProvider(id).future,
    'naturalization': pendingNaturalizationProvider(id).future,
    'camp': trainingCampPlanProvider(id).future,
  };
}

/// Listens to every one of [views] as a screen on show would, runs [step],
/// and expects each to hand out a fresh read afterwards.
Future<void> _expectRefreshedBy(
  WidgetTester tester,
  SeededSave save,
  _Views views,
  Future<void> Function() step,
) async {
  final c = save.container;
  // The listeners are the screens on show. They are opened inside the real
  // async zone, so the reads they start are not stranded on fake time.
  final subs = <String, ProviderSubscription<Future<Object?>>>{};
  addTearDown(() {
    for (final s in subs.values) {
      s.close();
    }
  });
  final before = <String, Future<Object?>>{};
  await tester.runAsync(() async {
    for (final e in views.entries) {
      subs[e.key] = c.listen<Future<Object?>>(e.value, (_, _) {});
      before[e.key] = subs[e.key]!.read();
      await before[e.key];
      // Sanity: with no step in between, the same read comes back.
      expect(
        identical(subs[e.key]!.read(), before[e.key]),
        isTrue,
        reason: e.key,
      );
    }
    await step();
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
}

/// Review Focus 3 (stage 3) and 1 (stage 4). A tablet's top bar runs the sim
/// while a screen is on show, and that screen's provider is kept alive by
/// being watched. Every way a step is committed must hand every one of them
/// a fresh read.
void main() {
  testWidgets('a step refreshes every screen a tablet keeps on show', (
    tester,
  ) async {
    final save = await seedSave(tester);
    await _expectRefreshedBy(
      tester,
      save,
      {..._competitionViews(save), ..._federationViews(save)},
      () => save.container.read(seasonServiceProvider).advance(save.careerId),
    );
  });

  testWidgets('so does committing the manager\'s own match', (tester) async {
    final save = await seedSave(tester);
    final c = save.container;
    late MatchPreview preview;
    await tester.runAsync(() async {
      // Held, as the match screen holds it between whistle and commit.
      final held = c.listen(
        matchPreviewProvider(save.careerId).future,
        (_, _) {},
      );
      addTearDown(held.close);
      final p = await held.read();
      expect(p, isNotNull, reason: 'the seeded save has a next match');
      preview = p!;
    });
    await _expectRefreshedBy(
      tester,
      save,
      {..._competitionViews(save), ..._federationViews(save)},
      () => c
          .read(seasonServiceProvider)
          .playPlayerMatch(save.careerId, preview.fixture, preview.result),
    );
  });

  // Skipping to the champion simulates the rest of a cycle, far too long for
  // the suite, so its cascade is checked in the source: it must end on the
  // same refresh as the other two paths.
  test('skipping to the champion runs the same refresh', () {
    final src = File('lib/features/hub/hub_providers.dart').readAsStringSync();
    final start = src.indexOf('Future<void> _skipToChampion(');
    expect(start, isNonNegative);
    final end = src.indexOf('\n  Future<', start + 1);
    final body = src.substring(start, end < 0 ? src.length : end);
    expect(body, contains('_invalidateCompetitionViews();'));
    final cascade = src.substring(
      src.indexOf('void _invalidateCompetitionViews()'),
    );
    expect(
      cascade.substring(0, cascade.indexOf('\n  }')),
      contains('_invalidateFederationViews();'),
    );
  });
}
```

- [ ] **Step 2: Run them to verify they fail**

Run: `flutter test test/widget/competition_refresh_after_step_test.dart`
Expected: FAIL. Both step tests name at least `finances`, `manager`, `youth` and `y` as having kept their pre-step data; the source guard fails on `_invalidateFederationViews();`.

- [ ] **Step 3: Invalidate them in the sim's cascade**

In `lib/features/hub/hub_providers.dart`, add the imports (sorted into the existing `features/` block; `federation_service.dart` and `training_camp_providers.dart` are already there):

```dart
import 'package:fnm/features/federation/naturalization_providers.dart';
import 'package:fnm/features/manager/manager_providers.dart';
import 'package:fnm/features/squad/youth_providers.dart';
import 'package:fnm/features/y/y_providers.dart';
```

Make the last statement of `_invalidateCompetitionViews()` (after `..invalidate(continentalHostThemeProvider);`):

```dart
    _invalidateFederationViews();
```

and add this method directly below it:

```dart
  /// The federation, manager and Y screens' data, refreshed by hand after a
  /// step for the same reason as [_invalidateCompetitionViews]: a tablet's
  /// top bar runs the sim while one of them is on show. The prize money so
  /// far, the manager's points (a trophy is one), the youth pyramid (it ages
  /// on 1 December), the Y feed (every match is talked about, and the tablet
  /// hub's Y panel keeps it alive across the whole shell), a naturalisation
  /// offer the step may have rolled, and the base camp (closed once its
  /// tournament's first match is played). The staff room needs nothing: it
  /// watches the squad, which the step refreshes.
  void _invalidateFederationViews() {
    _ref
      ..invalidate(financeViewProvider)
      ..invalidate(federationFundsProvider)
      ..invalidate(managerViewProvider)
      ..invalidate(youthPyramidProvider)
      ..invalidate(youthShortlistProvider)
      ..invalidate(yFeedProvider)
      ..invalidate(pendingNaturalizationProvider)
      ..invalidate(trainingCampPlanProvider);
  }
```

Dart allows cyclic imports (`manager_providers.dart` already imports `hub_providers.dart`); do not restructure.

- [ ] **Step 4: Run the tests, expect PASS**

Run: `flutter test test/widget/competition_refresh_after_step_test.dart`
Expected: PASS. If the sanity line fails for one provider (a second read without a step already returns a new future), that provider is rebuilt by something else on each read; report it rather than weakening the test.

- [ ] **Step 5: Prove it bites**

Comment out the `_invalidateFederationViews();` call, run the test, confirm both step tests FAIL naming at least `finances`, `manager`, `youth` and `y`, restore it.

- [ ] **Step 6: Analyze, full suite, commit**

Run: `flutter analyze && flutter test` (final summary line: all passed).

```bash
git add lib/features/hub/hub_providers.dart test/widget/competition_refresh_after_step_test.dart
git commit -m "fix(tablet): a sim step refreshes the federation, manager and Y screens

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 4: Finances as a dashboard of panels

**risk: low (batched review)**. Read-only.

**Files:**
- Create: `lib/features/federation/finances_tablet_layout.dart` (part of `finances_screen.dart`)
- Modify: `lib/features/federation/finances_screen.dart`, `lib/features/shell/tablet_shell.dart`
- Test: `test/golden/phone_guard_finances_test.dart` (new, with goldens), `test/widget/finances_tablet_test.dart` (new)

**Interfaces:**
- Produces: `FinancesScreen.tabletLayoutKey`; private `_BalanceBody`, `_IncomeRows`, `_BuildingRows`, `_InvestmentRows`, `_anyInvested(FederationInvestment)` shared by both layouts.
- Consumes: `financeViewProvider(careerId)`, `federationFundsProvider(careerId)`, `federationBuildingsProvider(careerId)` (the phone screen's three reads, nothing else), `TabletPage`, `DashboardGrid`, `Panel`, `l.sideFinances`, `l.federationBalance`, `l.federationProjectedAtSeasonEnd`, `l.federationDevelopment`, `l.federationThisSeasonLocked`, `l.federationNextCycleLocked`.

- [ ] **Step 1: Pin the phone finances**

Create `test/golden/phone_guard_finances_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/util/federation_label.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/federation/federation_finance.dart';

import '../helpers/seeded_save.dart';

/// The phone finances, pinned before the tablet layout is added beside it:
/// once as a fresh save shows it, once with this cycle's investment locked
/// in (the screen's other section).
void main() {
  for (final (name, size) in [
    ('finances_phone', kPhoneSize),
    ('finances_phone_tall', const Size(390, 2400)),
  ]) {
    testWidgets(name, (tester) async {
      final save = await seedSave(tester);
      await pumpRoute(
        tester,
        save,
        '${Routes.finances}?careerId=${save.careerId}',
        size: size,
      );
      expect(
        find.text(
          '${departmentBuildingName(enL, Department.youth)}'
          '  ·  ${departmentLabel(enL, Department.youth)}',
        ),
        findsOneWidget,
      );
      await expectAppGolden('goldens/$name.png');
    });
  }

  testWidgets('finances_phone_invested_tall', (tester) async {
    final save = await seedSave(tester);
    await tester.runAsync(
      () => save.container
          .read(careerRepositoryProvider)
          .setInvestment(save.careerId, save.career.cyclePointer, (
            youth: 8000000,
            commercial: 4000000,
            medical: 2000000,
            naturalization: 0,
            boardRelations: 1000000,
          )),
    );
    await pumpRoute(
      tester,
      save,
      '${Routes.finances}?careerId=${save.careerId}',
      size: const Size(390, 2400),
    );
    expect(find.text(enL.federationThisSeasonLocked), findsOneWidget);
    await expectAppGolden('goldens/finances_phone_invested_tall.png');
  });
}
```

- [ ] **Step 2: Create the baseline, confirm it holds, commit it**

```bash
flutter test --update-goldens test/golden/phone_guard_finances_test.dart
flutter test test/golden/phone_guard_finances_test.dart
git add test/golden/phone_guard_finances_test.dart test/golden/goldens/finances_phone.png test/golden/goldens/finances_phone_tall.png test/golden/goldens/finances_phone_invested_tall.png
git commit -m "test(tablet): phone guard for the finances

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

- [ ] **Step 3: Write the failing tablet test**

Create `test/widget/finances_tablet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/util/federation_label.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/federation/federation_finance.dart';
import 'package:fnm/features/federation/finances_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/seeded_save.dart';

Future<SeededSave> _open(
  WidgetTester tester,
  Size size, {
  bool invested = false,
}) async {
  final save = await seedSave(tester, formFactor: FormFactor.tablet);
  if (invested) {
    await tester.runAsync(
      () => save.container
          .read(careerRepositoryProvider)
          .setInvestment(save.careerId, save.career.cyclePointer, (
            youth: 8000000,
            commercial: 0,
            medical: 0,
            naturalization: 0,
            boardRelations: 0,
          )),
    );
  }
  await pumpRoute(
    tester,
    save,
    '${Routes.finances}?careerId=${save.careerId}',
    size: size,
  );
  return save;
}

/// The panel headed [title]. `.first`: a body may repeat its own heading
/// (the balance does), and the header comes first in the tree.
Finder _panel(String title) => find
    .ancestor(of: find.text(title.toUpperCase()).first, matching: find.byType(Panel))
    .first;

void main() {
  for (final size in kTabletSizes) {
    testWidgets('balance beside the projection, the buildings below, $size', (
      tester,
    ) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(FinancesScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      final balance = tester.getRect(_panel(enL.federationBalance));
      final income = tester.getRect(_panel(enL.federationProjectedAtSeasonEnd));
      final buildings = tester.getRect(_panel(enL.federationDevelopment));
      expect(balance.top, income.top);
      expect(income.left, greaterThan(balance.right));
      expect(buildings.top, greaterThan(balance.bottom));
      for (final d in Department.values) {
        expect(
          find.text(
            '${departmentBuildingName(enL, d)}  ·  ${departmentLabel(enL, d)}',
          ),
          findsOneWidget,
        );
      }
      // Nothing invested yet: no locked-in panel.
      expect(_panel(enL.federationThisSeasonLocked), findsNothing);
      expect(find.text(enL.federationNextCycleLocked), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('this cycle\'s investment sits beside the buildings', (
    tester,
  ) async {
    await _open(tester, kTabletSize, invested: true);
    expect(tester.takeException(), isNull);
    final locked = tester.getRect(_panel(enL.federationThisSeasonLocked));
    final buildings = tester.getRect(_panel(enL.federationDevelopment));
    expect(locked.top, buildings.top);
    expect(locked.left, greaterThan(buildings.right));
    expect(
      find.descendant(
        of: _panel(enL.federationThisSeasonLocked),
        matching: find.text('€8M'),
      ),
      findsOneWidget,
    );
    await tester.pumpWidget(const SizedBox());
  });
}
```

- [ ] **Step 4: Run it to verify it fails**

Run: `flutter test test/widget/finances_tablet_test.dart`
Expected: FAIL to compile (`FinancesScreen.tabletLayoutKey` does not exist).

- [ ] **Step 5: Move the card bodies, hook in the layout**

In `lib/features/federation/finances_screen.dart`:

Add the imports `package:fnm/shared/tablet/tablet.dart` and, below the imports, `part 'finances_tablet_layout.dart';`.

In `FinancesScreen` add:

```dart
  static const Key tabletLayoutKey = Key('finances.tabletLayout');
```

Make the first line of `_FinancesScreenState.build`:

```dart
    if (TabletShellScope.isActive(context)) {
      return _FinancesTabletLayout(careerId: widget.careerId);
    }
```

In the phone tree, replace the `hasCurrent` computation (the `final hasCurrent = view.current.youth + ... > 0;` statement) with:

```dart
          final hasCurrent = _anyInvested(view.current);
```

and add at the end of the file:

```dart
/// Whether any money went into a department this cycle.
bool _anyInvested(FederationInvestment i) =>
    i.youth + i.commercial + i.medical + i.naturalization + i.boardRelations >
    0;
```

Replace the projected-income card

```dart
              AppCard(
                child: Column(
                  children: [
                    _row(l.federationCentralFunding, income.grant),
                    _row(l.federationPrizeMoneySoFar, income.prize),
                    if (income.commercial > 0)
                      _row(l.federationCommercialReturn, income.commercial),
                  ],
                ),
              ),
```

with

```dart
              AppCard(child: _IncomeRows(income: income)),
```

delete the `_row` method from `_FinancesScreenState`, and add:

```dart
/// What the cycle is projected to bring in: the grant, the prize money so
/// far, and the commercial return when there is one.
class _IncomeRows extends StatelessWidget {
  const _IncomeRows({required this.income});

  final IncomeBreakdown income;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      children: [
        _moneyRow(l.federationCentralFunding, income.grant),
        _moneyRow(l.federationPrizeMoneySoFar, income.prize),
        if (income.commercial > 0)
          _moneyRow(l.federationCommercialReturn, income.commercial),
      ],
    );
  }

  static Widget _moneyRow(String label, int euros) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Text(
            label.toUpperCase(),
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          Text(formatEuros(euros), style: AppTypography.bodyMedium),
        ],
      ),
    );
  }
}
```

(`IncomeBreakdown` is declared in `domain/services/federation/federation_finance.dart`, already imported; `DepartmentBuilding` and `FederationFunds` in `federation_service.dart`, already imported.)

Replace the whole of `_BalanceCard.build` with

```dart
  @override
  Widget build(BuildContext context) =>
      AppCard(child: _BalanceBody(funds: funds));
```

and add the body it used to hold, moved verbatim:

```dart
/// The balance, and when staff are employed, what is promised to them and
/// what is left to spend.
class _BalanceBody extends StatelessWidget {
  const _BalanceBody({required this.funds});

  final FederationFunds funds;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final budget = funds.balance;
    final wages = funds.wages;
    final free = funds.free;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Icon(
              Icons.account_balance,
              color: AppColors.primary,
              size: 32,
            ),
            const SizedBox(width: AppSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.federationBalance,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                Text(
                  formatEuros(budget),
                  style: AppTypography.headlineMedium,
                ),
              ],
            ),
          ],
        ),
        // Only worth breaking down when somebody is actually employed: with
        // no staff the balance IS the free money, and a second line saying
        // so twice is noise.
        if (wages > 0) ...[
          const Divider(height: AppSpacing.lg),
          _Split(
            label: l.federationCommittedToStaff,
            amount: wages,
            color: AppColors.warning,
          ),
          const SizedBox(height: AppSpacing.xs),
          _Split(
            label: l.federationFreeToSpend,
            amount: free,
            color: free > 0 ? AppColors.positive : AppColors.onSurfaceVariant,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l.federationWagesNote,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}
```

Replace the whole of `_LockedInvestment.build` with

```dart
  @override
  Widget build(BuildContext context) =>
      AppCard(child: _InvestmentRows(investment: investment));
```

and add, moved verbatim:

```dart
/// This cycle's money, department by department, and where it was decided.
class _InvestmentRows extends StatelessWidget {
  const _InvestmentRows({required this.investment});

  final FederationInvestment investment;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      children: [
        for (final d in Department.values)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    departmentLabel(l, d),
                    style: AppTypography.bodyMedium,
                  ),
                ),
                Text(
                  formatEuros(switch (d) {
                    Department.youth => investment.youth,
                    Department.commercial => investment.commercial,
                    Department.medical => investment.medical,
                    Department.naturalization => investment.naturalization,
                    Department.boardRelations => investment.boardRelations,
                  }),
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l.federationInvestAtCeremony,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
```

In `_BuildingsCard.build` replace the whole `data:` branch with

```dart
      data: (buildings) => AppCard(child: _BuildingRows(buildings: buildings)),
```

delete its now-unused `final l = AppLocalizations.of(context);`, and add, moved verbatim:

```dart
/// Each department's building: its level, how far it is to the next, and the
/// money keeping it there.
class _BuildingRows extends StatelessWidget {
  const _BuildingRows({required this.buildings});

  final List<DepartmentBuilding> buildings;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      children: [
        for (final b in buildings)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                SizedBox(
                  width: 34,
                  child: _LevelBadge(level: b.level),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${departmentBuildingName(l, b.department)}'
                        '  ·  ${departmentLabel(l, b.department)}',
                        style: AppTypography.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: b.progress,
                          minHeight: 5,
                          backgroundColor: AppColors.surfaceContainerHigh,
                          valueColor: const AlwaysStoppedAnimation(
                            AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  formatEuros(b.cumulativeEuros),
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
```

- [ ] **Step 6: The layout**

Create `lib/features/federation/finances_tablet_layout.dart`:

```dart
part of 'finances_screen.dart';

/// The finances on a tablet: the balance beside the projected income, the
/// federation's buildings beside this cycle's locked-in investment, the note
/// on next cycle's budget under them. The phone's three reads, nothing more.
class _FinancesTabletLayout extends ConsumerWidget {
  const _FinancesTabletLayout({required this.careerId});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final viewAsync = ref.watch(financeViewProvider(careerId));
    return TabletPage(
      scaffoldKey: FinancesScreen.tabletLayoutKey,
      title: l.sideFinances,
      onBack: () => context.canPop()
          ? context.pop()
          : context.go('${Routes.hub}?careerId=$careerId'),
      child: viewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l.federationCouldNotLoadFinances(e.toString()))),
        data: (view) {
          if (view == null) {
            return Center(child: Text(l.federationSaveNotFound));
          }
          final funds =
              ref.watch(federationFundsProvider(careerId)).valueOrNull ??
              (balance: view.budget, wages: 0, free: view.budget);
          final buildings = ref.watch(federationBuildingsProvider(careerId));
          final invested = _anyInvested(view.current);
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Every tile must report an intrinsic height: no lists, no
                // LayoutBuilder, no WholeText (see DashboardGrid).
                DashboardGrid(
                  tiles: [
                    DashboardTile(
                      span: 5,
                      child: Panel(
                        title: l.federationBalance,
                        child: _BalanceBody(funds: funds),
                      ),
                    ),
                    DashboardTile(
                      span: 7,
                      child: Panel(
                        title: l.federationProjectedAtSeasonEnd,
                        child: _IncomeRows(income: view.projectedIncome),
                      ),
                    ),
                    DashboardTile(
                      span: invested ? 7 : 12,
                      child: Panel(
                        title: l.federationDevelopment,
                        child: buildings.when(
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (_, _) => const SizedBox.shrink(),
                          data: (b) => _BuildingRows(buildings: b),
                        ),
                      ),
                    ),
                    if (invested)
                      DashboardTile(
                        span: 5,
                        child: Panel(
                          title: l.federationThisSeasonLocked,
                          child: _InvestmentRows(investment: view.current),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                // The next cycle's allocation is not editable here, on
                // either layout (see the phone tree).
                Text(
                  l.federationNextCycleLocked,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
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
```

- [ ] **Step 7: Register, run, expect PASS**

Add `Routes.finances,` to `tabletReadyPaths` in `lib/features/shell/tablet_shell.dart`.

Run: `flutter test test/widget/finances_tablet_test.dart test/golden/phone_guard_finances_test.dart test/widget/tablet_route_sweep_test.dart`
Expected: PASS, phone goldens unchanged.

- [ ] **Step 8: Analyze, full suite, commit**

Run: `flutter analyze && flutter test`

```bash
git add lib/features/federation/finances_screen.dart lib/features/federation/finances_tablet_layout.dart lib/features/shell/tablet_shell.dart test/widget/finances_tablet_test.dart
git commit -m "feat(tablet): finances as a dashboard of panels

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 5: Board objectives as a dashboard

**risk: low (batched review)**. Read-only.

**Files:**
- Create: `lib/features/hub/board_objectives_tablet_layout.dart` (part of `board_objectives_screen.dart`)
- Modify: `lib/features/hub/board_objectives_screen.dart`, `lib/features/shell/tablet_shell.dart`
- Test: `test/golden/phone_guard_board_test.dart` (new, with goldens), `test/widget/board_objectives_tablet_test.dart` (new)

**Interfaces:**
- Produces: `BoardObjectivesScreen.tabletLayoutKey`; private `_ConfidenceRow`, `_ObjectiveBody`, `_ObjectivesState` shared by both layouts.
- Consumes: `satisfactionProvider(careerId)`, `cycleObjectivesProvider(careerId)` (the phone's two reads), `boardVerdict`, `objectiveStatusColor`, `objectiveStatusLabel`, `TabletPage`, `DashboardGrid`, `Panel`, `l.boardObjectivesTitle`, `l.boardObjectivesConfidence`.

- [ ] **Step 1: Pin the phone board objectives**

Create `test/golden/phone_guard_board_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';

import '../helpers/seeded_save.dart';

/// The phone board objectives, pinned before the tablet layout is added.
void main() {
  for (final (name, size) in [
    ('board_phone', kPhoneSize),
    ('board_phone_tall', const Size(390, 2400)),
  ]) {
    testWidgets(name, (tester) async {
      final save = await seedSave(tester);
      await pumpRoute(
        tester,
        save,
        '${Routes.boardObjectives}?careerId=${save.careerId}',
        size: size,
      );
      expect(find.text(enL.boardObjectivesConfidence), findsOneWidget);
      await expectAppGolden('goldens/$name.png');
    });
  }
}
```

- [ ] **Step 2: Create the baseline, confirm it holds, commit it**

```bash
flutter test --update-goldens test/golden/phone_guard_board_test.dart
flutter test test/golden/phone_guard_board_test.dart
git add test/golden/phone_guard_board_test.dart test/golden/goldens/board_phone.png test/golden/goldens/board_phone_tall.png
git commit -m "test(tablet): phone guard for the board objectives

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

- [ ] **Step 3: Write the failing tablet test**

Create `test/widget/board_objectives_tablet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/hub/board_objectives_screen.dart';
import 'package:fnm/features/hub/objective_providers.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/seeded_save.dart';

void main() {
  for (final size in kTabletSizes) {
    testWidgets('confidence first, one panel per objective, $size', (
      tester,
    ) async {
      final save = await seedSave(tester, formFactor: FormFactor.tablet);
      late List<CycleObjective> objectives;
      await tester.runAsync(() async {
        final sub = save.container.listen(
          cycleObjectivesProvider(save.careerId).future,
          (_, _) {},
        );
        objectives = await sub.read();
        sub.close();
      });
      expect(objectives, isNotEmpty, reason: 'a fresh save has a brief');
      await pumpRoute(
        tester,
        save,
        '${Routes.boardObjectives}?careerId=${save.careerId}',
        size: size,
      );
      expect(tester.takeException(), isNull);
      expect(
        find.byKey(BoardObjectivesScreen.tabletLayoutKey),
        findsOneWidget,
      );
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      // One panel for the confidence and one per objective.
      expect(find.byType(Panel), findsNWidgets(objectives.length + 1));
      final confidence = tester.getRect(
        find
            .ancestor(
              of: find.text(enL.boardObjectivesConfidence.toUpperCase()),
              matching: find.byType(Panel),
            )
            .first,
      );
      final first = tester.getRect(
        find
            .ancestor(
              of: find.text(objectives.first.label),
              matching: find.byType(Panel),
            )
            .first,
      );
      expect(first.top, confidence.top);
      expect(first.left, greaterThan(confidence.right));
      await tester.pumpWidget(const SizedBox());
    });
  }
}
```

- [ ] **Step 4: Run it to verify it fails**

Run: `flutter test test/widget/board_objectives_tablet_test.dart`
Expected: FAIL to compile (`BoardObjectivesScreen.tabletLayoutKey` does not exist).

- [ ] **Step 5: Move the card bodies, hook in the layout**

In `lib/features/hub/board_objectives_screen.dart`:

Add the import `package:fnm/shared/tablet/tablet.dart` and, below the imports, `part 'board_objectives_tablet_layout.dart';`.

In `BoardObjectivesScreen` add:

```dart
  static const Key tabletLayoutKey = Key('boardObjectives.tabletLayout');
```

Make the first line of `build`:

```dart
    if (TabletShellScope.isActive(context)) {
      return _BoardObjectivesTabletLayout(careerId: careerId);
    }
```

In the phone tree: delete the `final (color, verdict) = boardVerdict(l, value);` line; replace the confidence card's `child: Row(...)` with `child: _ConfidenceRow(value: value)`; replace the empty-state card's `child: switch (objectivesAsync) {...}` with `child: _ObjectivesState(async: objectivesAsync)`. Then add, moved verbatim:

```dart
/// The board's confidence: the gavel, the verdict and the figure, in the
/// verdict's colour.
class _ConfidenceRow extends StatelessWidget {
  const _ConfidenceRow({required this.value});

  final int? value;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final (color, verdict) = boardVerdict(l, value);
    return Row(
      children: [
        Icon(Icons.gavel, color: color, size: 26),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.boardObjectivesConfidence,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Text(
                verdict,
                style: AppTypography.titleMedium.copyWith(color: color),
              ),
            ],
          ),
        ),
        Text(
          value == null ? '—' : '$value%',
          style: AppTypography.headlineMedium.copyWith(color: color),
        ),
      ],
    );
  }
}

/// What stands in for the objectives when there are none to list: still
/// loading, failed (said, not hidden), or a board with nothing to ask.
class _ObjectivesState extends StatelessWidget {
  const _ObjectivesState({required this.async});

  final AsyncValue<List<CycleObjective>> async;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return switch (async) {
      AsyncLoading() => const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: CircularProgressIndicator(),
        ),
      ),
      AsyncError(:final error) => Text(
        '$error',
        style: AppTypography.bodySmall.copyWith(color: AppColors.error),
      ),
      _ => Text(
        l.boardObjectivesEmpty,
        style: AppTypography.bodyMedium.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),
    };
  }
}
```

(The `'—'` shown for an unknown value is existing phone copy, moved, not new: changing it would change the phone golden. Leave it; it is out of this stage's scope.)

Replace the whole of `_ObjectiveCard.build` with

```dart
  @override
  Widget build(BuildContext context) =>
      AppCard(child: _ObjectiveBody(objective: objective));
```

and add, moved verbatim with one switch for the competition line:

```dart
/// One objective: its competition (unless a panel header already names it),
/// what the board asks, and how the run is going or how it was graded.
class _ObjectiveBody extends StatelessWidget {
  const _ObjectiveBody({required this.objective, this.showCompetition = true});

  final CycleObjective objective;

  /// False inside a tablet panel, whose header is the competition.
  final bool showCompetition;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final color = objectiveStatusColor(objective);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showCompetition) ...[
          Row(
            children: [
              Icon(Icons.flag_outlined, size: 18, color: color),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  objective.competition,
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        Text(objective.label, style: AppTypography.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: 3,
          ),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: AppRadii.smAll,
          ),
          child: Text(
            // An objective can only be GRADED when its tournament is over,
            // but a brief that says nothing at all until then reads as one
            // that is never judged. While it's live, say how far the run has
            // got — the manager can see themselves closing on it.
            // Ordinals below 2 are not progress — they are "out of it" and
            // "bottom of the group", which read as an achievement if shown
            // as how far the run has got.
            // Once graded, say by HOW MUCH. Met/missed alone read the same
            // whether a side scraped the brief or was carried three rounds
            // past it, and the two are not the same cycle.
            objectiveStatusLabel(l, objective),
            style: AppTypography.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
```

(The comment is the phone card's, moved with the code; its dashes are in a code comment, not in copy.) With `showCompetition` true the Column holds exactly the children the card held, in the same order.

- [ ] **Step 6: The layout**

Create `lib/features/hub/board_objectives_tablet_layout.dart`:

```dart
part of 'board_objectives_screen.dart';

/// The board's brief on a tablet: the confidence panel first, then one panel
/// per objective, three to a row, each headed by its competition. The
/// phone's two reads, nothing more.
class _BoardObjectivesTabletLayout extends ConsumerWidget {
  const _BoardObjectivesTabletLayout({required this.careerId});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final value = ref.watch(satisfactionProvider(careerId)).valueOrNull;
    final objectivesAsync = ref.watch(cycleObjectivesProvider(careerId));
    final objectives = objectivesAsync.valueOrNull ?? const <CycleObjective>[];
    return TabletPage(
      scaffoldKey: BoardObjectivesScreen.tabletLayoutKey,
      title: l.boardObjectivesTitle,
      onBack: () => context.canPop()
          ? context.pop()
          : context.go('${Routes.hub}?careerId=$careerId'),
      child: SingleChildScrollView(
        // Every tile must report an intrinsic height (see DashboardGrid).
        child: DashboardGrid(
          tiles: [
            DashboardTile(
              span: 4,
              child: Panel(
                title: l.boardObjectivesConfidence,
                child: _ConfidenceRow(value: value),
              ),
            ),
            if (objectives.isEmpty)
              DashboardTile(
                span: 8,
                child: Panel(
                  title: l.boardObjectivesTitle,
                  child: _ObjectivesState(async: objectivesAsync),
                ),
              )
            else
              for (final objective in objectives)
                DashboardTile(
                  span: 4,
                  child: Panel(
                    title: objective.competition,
                    child: _ObjectiveBody(
                      objective: objective,
                      showCompetition: false,
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

Add `Routes.boardObjectives,` to `tabletReadyPaths`.

Run: `flutter test test/widget/board_objectives_tablet_test.dart test/golden/phone_guard_board_test.dart test/widget/tablet_route_sweep_test.dart`
Expected: PASS, phone goldens unchanged.

- [ ] **Step 8: Analyze, full suite, commit**

Run: `flutter analyze && flutter test`

```bash
git add lib/features/hub/board_objectives_screen.dart lib/features/hub/board_objectives_tablet_layout.dart lib/features/shell/tablet_shell.dart test/widget/board_objectives_tablet_test.dart
git commit -m "feat(tablet): board objectives as a dashboard

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 6: Youth as grids by age group beside the boy's card

**risk: low (batched review)**. Display, plus the existing watchlist bookmark (a per-save preference, through `YouthWatchStore`, unchanged).

**Files:**
- Create: `lib/features/squad/youth_tablet_layout.dart` (part of `youth_screen.dart`)
- Modify: `lib/features/squad/youth_screen.dart`, `lib/features/shell/tablet_shell.dart`
- Test: `test/golden/phone_guard_youth_test.dart` (new, with goldens), `test/widget/youth_tablet_test.dart` (new)

**Interfaces:**
- Produces: `YouthScreen.tabletLayoutKey`; private `_watchStatus(AppLocalizations, WatchedBoy)` and `_WatchEmpty`, shared by both layouts; `_YouthTabletLayout`, `_LevelGrid`, `_WatchGrid`.
- Consumes: `youthPyramidProvider(careerId)`, `youthMarksProvider(careerId)`, `youthShortlistProvider(careerId)` (the phone's three reads), `_WatchButton`, `_Stars`, `_Tag` (the phone file's own), `DataGrid`, `MasterDetail`, `DetailPaneHost`, `DetailPaneScope`, `openPlayer`, `TabletTabBar`, `TabletPage`, `l.youthTitle`, `l.youthWatching`, `l.youthReleased`, `l.youthEmptyLevel`, `l.u21CallUps`, `l.u21Breakout`, `l.squadDevPosition`, `l.squadSortName`, `l.playerAge`, `l.playerStatCaps`, `l.teamOverall`, `l.gridColYearGain`, `l.gridColCeiling`, `l.gridColMarkedAt`, `l.gridColMove`, `l.gridColStatus`, `l.gridViewOverview`.

- [ ] **Step 1: Pin the phone youth screen**

Create `test/golden/phone_guard_youth_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/entities/enums.dart';

import '../helpers/seeded_save.dart';

/// The phone youth screen, pinned before the tablet layout is added: the
/// (empty) watchlist it opens on, and the oldest level in full.
void main() {
  testWidgets('youth_phone', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.youth}?careerId=${save.careerId}',
    );
    expect(find.text(enL.youthWatchEmpty), findsOneWidget);
    await expectAppGolden('goldens/youth_phone.png');
  });

  testWidgets('youth_u21_phone_tall', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.youth}?careerId=${save.careerId}',
      size: const Size(390, 2400),
    );
    await showTab(tester, YouthLevel.values.length);
    expect(find.text(YouthLevel.u21.label), findsWidgets);
    await expectAppGolden('goldens/youth_u21_phone_tall.png');
  });
}
```

- [ ] **Step 2: Create the baseline, confirm it holds, commit it**

```bash
flutter test --update-goldens test/golden/phone_guard_youth_test.dart
flutter test test/golden/phone_guard_youth_test.dart
git add test/golden/phone_guard_youth_test.dart test/golden/goldens/youth_phone.png test/golden/goldens/youth_u21_phone_tall.png
git commit -m "test(tablet): phone guard for the youth screen

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

- [ ] **Step 3: Write the failing tablet test**

Create `test/widget/youth_tablet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/player/prospects.dart';
import 'package:fnm/features/player/player_detail_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/squad/youth_providers.dart';
import 'package:fnm/features/squad/youth_screen.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/seeded_save.dart';

Future<SeededSave> _open(WidgetTester tester, Size size) async {
  final save = await seedSave(tester, formFactor: FormFactor.tablet);
  await pumpRoute(
    tester,
    save,
    '${Routes.youth}?careerId=${save.careerId}',
    size: size,
  );
  return save;
}

Finder get _levelGrid => find.byType(DataGrid<Prospect>);
Finder get _watchGrid => find.byType(DataGrid<WatchedBoy>);

void main() {
  for (final size in kTabletSizes) {
    testWidgets('the watchlist first, a level as a grid, the pane, $size', (
      tester,
    ) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(YouthScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      // Opens on the manager's own (empty) list, the pane waiting.
      expect(find.text(enL.youthWatchEmpty), findsOneWidget);
      expect(find.text(enL.panePickPlayer), findsOneWidget);
      await showTab(tester, YouthLevel.values.length);
      expect(tester.takeException(), isNull);
      expect(tester.widget<DataGrid<Prospect>>(_levelGrid).rows, isNotEmpty);
      expect(
        tester.getCenter(_levelGrid).dx,
        lessThan(tester.getCenter(find.text(enL.panePickPlayer)).dx),
      );
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('a picked boy opens in the pane', (tester) async {
    await _open(tester, kTabletSize);
    await showTab(tester, YouthLevel.values.length);
    final boy = tester.widget<DataGrid<Prospect>>(_levelGrid).rows.first;
    await tester.tap(
      find.descendant(of: _levelGrid, matching: find.text(boy.player.name)),
    );
    await settle(tester);
    expect(
      tester.widget<PlayerView>(find.byType(PlayerView)).playerId,
      boy.player.id,
    );
    expect(tester.widget<DataGrid<Prospect>>(_levelGrid).selected, boy);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the bookmark puts him on the watchlist grid', (tester) async {
    await _open(tester, kTabletSize);
    await showTab(tester, YouthLevel.values.length);
    final boy = tester.widget<DataGrid<Prospect>>(_levelGrid).rows.first;
    // The grid keeps the pyramid's order: his bookmark is the first.
    await tester.tap(find.byTooltip(enL.youthWatchMark).first);
    await settle(tester);
    await showTab(tester, 0);
    final watched = tester.widget<DataGrid<WatchedBoy>>(_watchGrid).rows;
    expect(watched, hasLength(1));
    expect(watched.single.mark.playerId, boy.player.id);
    expect(watched.single.mark.rating, boy.player.overall);
    await tester.pumpWidget(const SizedBox());
  });
}
```

- [ ] **Step 4: Run it to verify it fails**

Run: `flutter test test/widget/youth_tablet_test.dart`
Expected: FAIL to compile (`YouthScreen.tabletLayoutKey` does not exist).

- [ ] **Step 5: Share the status line and the empty list, hook in the layout**

In `lib/features/squad/youth_screen.dart`:

Add the imports `package:fnm/features/shell/detail_pane_host.dart` and `package:fnm/shared/tablet/tablet.dart`, and below the imports `part 'youth_tablet_layout.dart';`.

In `YouthScreen` add:

```dart
  static const Key tabletLayoutKey = Key('youth.tabletLayout');
```

Make the first line of `YouthScreen.build`:

```dart
    if (TabletShellScope.isActive(context)) {
      return _YouthTabletLayout(careerId: careerId);
    }
```

In `_WatchRow.build`, replace the status `Text(switch (boy.status) {...}, ...)`'s first argument (the whole `switch` expression) with `_watchStatus(l, boy)`, and add, moved verbatim:

```dart
/// Where a watched boy is now: his age and caps while he is coming through,
/// otherwise what became of him.
String _watchStatus(AppLocalizations l, WatchedBoy boy) {
  final player = boy.player;
  return switch (boy.status) {
    WatchedStatus.following =>
      player == null
          ? l.youthWatchGone
          : boy.caps > 0
          ? l.u21AgeCaps(player.age, boy.caps)
          : l.u21AgeUncapped(player.age),
    WatchedStatus.senior => l.youthWatchSenior,
    WatchedStatus.released => l.youthWatchReleased,
    WatchedStatus.gone => l.youthWatchGone,
  };
}
```

In `YouthWatchTab.build`, replace the `if (boys.isEmpty) { return Center(...); }` body with `return const _WatchEmpty();` and add, moved verbatim:

```dart
/// The empty watchlist: the bookmark itself above the words, so the manager
/// knows which shape to look for beside a boy's name.
class _WatchEmpty extends StatelessWidget {
  const _WatchEmpty();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // The control itself, above the words: the copy says to mark
            // a boy without naming a shape, so this is what says which
            // shape to look for beside his name.
            const Icon(
              Icons.bookmark_border_rounded,
              color: AppColors.onSurfaceVariant,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l.youthWatchEmpty,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 6: The layout**

Create `lib/features/squad/youth_tablet_layout.dart`:

```dart
part of 'youth_screen.dart';

/// The youth pyramid on a tablet: the manager's watchlist and the five levels
/// as tabs over sortable grids, the picked boy's card in the pane beside
/// them, the way to the U-21 call-ups in the heading. The phone's three
/// reads, nothing more.
class _YouthTabletLayout extends ConsumerStatefulWidget {
  const _YouthTabletLayout({required this.careerId});

  final int careerId;

  @override
  ConsumerState<_YouthTabletLayout> createState() =>
      _YouthTabletLayoutState();
}

class _YouthTabletLayoutState extends ConsumerState<_YouthTabletLayout> {
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
    final async = ref.watch(youthPyramidProvider(careerId));
    final marked = {
      for (final m
          in ref.watch(youthMarksProvider(careerId)).valueOrNull ??
              const <YouthMark>[])
        m.playerId,
    };
    return DefaultTabController(
      length: YouthLevel.values.length + 1,
      child: TabletPage(
        scaffoldKey: YouthScreen.tabletLayoutKey,
        title: l.youthTitle,
        onBack: () => context.canPop()
            ? context.pop()
            : context.go('${Routes.hub}?careerId=$careerId'),
        trailing: OutlinedButton.icon(
          onPressed: () => context.go('${Routes.callUps}?careerId=$careerId'),
          icon: const Icon(Icons.how_to_reg_rounded, size: 18),
          label: Text(l.u21CallUps),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.outlineVariant),
          ),
        ),
        child: DetailPaneScope(
          controller: _pane,
          child: ListenableBuilder(
            listenable: _pane,
            builder: (context, _) {
              final selectedId = switch (_pane.value) {
                PlayerTarget(:final playerId) => playerId,
                _ => null,
              };
              return MasterDetail(
                initialFraction: 0.64,
                minFraction: 0.5,
                maxFraction: 0.72,
                minDetailWidth: 300,
                master: PanelBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TabletTabBar(
                        tabs: [
                          Tab(text: l.youthWatching),
                          for (final level in YouthLevel.values)
                            Tab(text: level.label),
                        ],
                      ),
                      Expanded(
                        child: async.when(
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (e, _) => Center(child: Text('$e')),
                          data: (pyramid) => TabBarView(
                            children: [
                              _WatchGrid(
                                careerId: careerId,
                                years: pyramid.years,
                                selectedId: selectedId,
                              ),
                              for (final level in YouthLevel.values)
                                _LevelGrid(
                                  prospects:
                                      pyramid.byLevel[level] ?? const [],
                                  released:
                                      pyramid.releasedByLevel[level] ??
                                      const [],
                                  careerId: careerId,
                                  years: pyramid.years,
                                  marked: marked,
                                  selectedId: selectedId,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
        ),
      ),
    );
  }
}

/// One level's squad as a table, best prospect first until the manager
/// sorts it, with the boys who left the level this year under it.
class _LevelGrid extends StatelessWidget {
  const _LevelGrid({
    required this.prospects,
    required this.released,
    required this.careerId,
    required this.years,
    required this.marked,
    required this.selectedId,
  });

  final List<Prospect> prospects;
  final List<String> released;
  final int careerId;
  final int years;
  final Set<int> marked;
  final int? selectedId;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    if (prospects.isEmpty && released.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Text(
            l.youthEmptyLevel,
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
      );
    }
    final selected = prospects
        .where((p) => p.player.id == selectedId)
        .firstOrNull;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: DataGrid<Prospect>(
            rows: prospects,
            columnSets: [_columns(l)],
            selected: selected,
            onSelect: (p) =>
                openPlayer(context, careerId: careerId, playerId: p.player.id),
          ),
        ),
        // Boys who were here last year and have been let go. Shown, because
        // a career that ends at fifteen still happened.
        if (released.isNotEmpty)
          Container(
            color: AppColors.surfaceContainer,
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l.youthReleased.toUpperCase(),
                  style: TabletText.sectionLabel,
                ),
                const SizedBox(height: 2),
                Text(
                  released.join(' · '),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TabletText.cell.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  GridColumnSet<Prospect> _columns(AppLocalizations l) =>
      GridColumnSet<Prospect>(
        id: 'level',
        label: l.gridViewOverview,
        columns: [
          GridColumn<Prospect>(
            id: 'pos',
            label: l.squadDevPosition,
            width: 48,
            sortKey: (p) => p.player.position.index,
            cell: (p) => TacticalChip(p.player.position.label),
          ),
          GridColumn<Prospect>(
            id: 'name',
            label: l.squadSortName,
            flex: 3,
            sortKey: (p) => p.player.name,
            cell: (p) => Row(
              children: [
                Flexible(
                  child: Text(
                    p.player.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (p.yearGain >= 3) ...[
                  const SizedBox(width: AppSpacing.xs),
                  _Tag(
                    label: l.u21Breakout(p.yearGain),
                    color: AppColors.positive,
                  ),
                ],
              ],
            ),
          ),
          GridColumn<Prospect>(
            id: 'age',
            label: l.playerAge,
            width: 44,
            numeric: true,
            sortKey: (p) => p.player.age,
            cell: (p) => Text('${p.player.age}'),
          ),
          GridColumn<Prospect>(
            id: 'caps',
            label: l.playerStatCaps,
            width: 52,
            numeric: true,
            sortKey: (p) => p.caps,
            cell: (p) => Text('${p.caps}'),
          ),
          GridColumn<Prospect>(
            id: 'gain',
            label: l.gridColYearGain,
            width: 56,
            numeric: true,
            sortKey: (p) => p.yearGain,
            cell: (p) => Text(
              p.yearGain > 0 ? '+${p.yearGain}' : '${p.yearGain}',
              style: TabletText.cellNumeric.copyWith(
                color: p.yearGain > 0
                    ? AppColors.positive
                    : p.yearGain < 0
                    ? AppColors.error
                    : AppColors.onSurfaceVariant,
              ),
            ),
          ),
          GridColumn<Prospect>(
            id: 'ovr',
            label: l.teamOverall,
            width: 56,
            numeric: true,
            sortKey: (p) => p.player.overall,
            cell: (p) => Text(
              '${p.player.overall}',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          GridColumn<Prospect>(
            id: 'ceiling',
            label: l.gridColCeiling,
            width: 80,
            numeric: true,
            sortKey: (p) => p.stars,
            cell: (p) => _Stars(stars: p.stars, certain: p.certain),
          ),
          GridColumn<Prospect>(
            id: 'watch',
            label: '',
            width: 44,
            cell: (p) => _WatchButton(
              careerId: careerId,
              playerId: p.player.id,
              player: p.player,
              years: years,
              marked: marked.contains(p.player.id),
            ),
          ),
        ],
      );
}

/// The manager's shortlist as a table: what each boy was when he was marked,
/// what he is now, and the difference, which is the whole point of a
/// watchlist.
class _WatchGrid extends ConsumerWidget {
  const _WatchGrid({
    required this.careerId,
    required this.years,
    required this.selectedId,
  });

  final int careerId;
  final int years;
  final int? selectedId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(youthShortlistProvider(careerId));
    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (boys) {
        if (boys.isEmpty) return const _WatchEmpty();
        final selected = boys
            .where((b) => b.player != null && b.player!.id == selectedId)
            .firstOrNull;
        return DataGrid<WatchedBoy>(
          rows: boys,
          columnSets: [_columns(l)],
          selected: selected,
          onSelect: (b) {
            final p = b.player;
            if (p == null) return;
            openPlayer(context, careerId: careerId, playerId: p.id);
          },
        );
      },
    );
  }

  GridColumnSet<WatchedBoy> _columns(AppLocalizations l) =>
      GridColumnSet<WatchedBoy>(
        id: 'watching',
        label: l.gridViewOverview,
        columns: [
          GridColumn<WatchedBoy>(
            id: 'pos',
            label: l.squadDevPosition,
            width: 48,
            sortKey: (b) => b.player?.position.index ?? 1 << 20,
            cell: (b) => b.player == null
                ? const SizedBox.shrink()
                : TacticalChip(b.player!.position.label),
          ),
          GridColumn<WatchedBoy>(
            id: 'name',
            label: l.squadSortName,
            flex: 3,
            sortKey: (b) => b.player?.name ?? b.mark.name,
            cell: (b) => Text(
              b.player?.name ?? b.mark.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GridColumn<WatchedBoy>(
            id: 'marked',
            label: l.gridColMarkedAt,
            width: 92,
            numeric: true,
            sortKey: (b) => b.mark.rating,
            cell: (b) => Text('${b.mark.rating}'),
          ),
          GridColumn<WatchedBoy>(
            id: 'ovr',
            label: l.teamOverall,
            width: 56,
            numeric: true,
            sortKey: (b) => b.player?.overall ?? -1,
            cell: (b) => Text(
              b.player == null ? '' : '${b.player!.overall}',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          GridColumn<WatchedBoy>(
            id: 'move',
            label: l.gridColMove,
            width: 56,
            numeric: true,
            sortKey: (b) =>
                b.player == null ? -1 << 20 : b.player!.overall - b.mark.rating,
            cell: (b) {
              final p = b.player;
              if (p == null) return const SizedBox.shrink();
              final move = p.overall - b.mark.rating;
              return _Tag(
                label: move > 0 ? '+$move' : '$move',
                color: move > 0
                    ? AppColors.positive
                    : move < 0
                    ? AppColors.error
                    : AppColors.onSurfaceVariant,
              );
            },
          ),
          GridColumn<WatchedBoy>(
            id: 'status',
            label: l.gridColStatus,
            flex: 2,
            sortKey: (b) => b.status.index,
            cell: (b) => Text(
              _watchStatus(l, b),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GridColumn<WatchedBoy>(
            id: 'ceiling',
            label: l.gridColCeiling,
            width: 80,
            numeric: true,
            sortKey: (b) => b.stars,
            cell: (b) => b.player == null
                ? const SizedBox.shrink()
                : _Stars(stars: b.stars, certain: b.certain),
          ),
          GridColumn<WatchedBoy>(
            id: 'watch',
            label: '',
            width: 44,
            cell: (b) => _WatchButton(
              careerId: careerId,
              playerId: b.mark.playerId,
              player: b.player,
              years: years,
              marked: true,
            ),
          ),
        ],
      );
}
```

The level grid's columns add up to about 500 px at 1024 x 768 (the master side is 0.64 of the content width); where they do not fit the grid scrolls sideways, as `DataGrid` does.

- [ ] **Step 7: Register, run, expect PASS**

Add `Routes.youth,` to `tabletReadyPaths`.

Run: `flutter test test/widget/youth_tablet_test.dart test/golden/phone_guard_youth_test.dart test/widget/youth_screen_test.dart test/widget/youth_watchlist_test.dart test/widget/tablet_route_sweep_test.dart`
Expected: PASS, phone goldens unchanged.

- [ ] **Step 8: Analyze, full suite, commit**

Run: `flutter analyze && flutter test`

```bash
git add lib/features/squad/youth_screen.dart lib/features/squad/youth_tablet_layout.dart lib/features/shell/tablet_shell.dart test/widget/youth_tablet_test.dart
git commit -m "feat(tablet): youth levels as grids beside the boy's card

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 7: Y as the timeline with trending and voices beside it

**risk: low (batched review)**. Reading the feed. The one write (marking the feed read) is the phone's own, now repeated when the feed refreshes while open, which only a tablet can do.

On a tablet the timeline fills the centre and the side column shows what is being talked about most (trending: the conversations above the seam with the most posts) and who is talking most (voices). A post or an account tapped in the timeline opens in that side column instead of pushing a page; the side column's close button brings trending and voices back. The post and profile pages' bodies are moved into public views (`YPostThread`, `YProfileView`) that both the phone pages and the side column render.

The cascade (Task 3) now refreshes `yFeedProvider` under an open Y screen. Opening the feed IS reading it, so posts that arrive while it is on show must be read too: the State marks the feed read whenever it receives a new feed, not once per visit. On a phone the feed never refreshes while open, so it still marks once.

**Files:**
- Create: `lib/features/y/y_trends.dart`, `lib/features/y/y_tablet_layout.dart` (part of `y_screen.dart`)
- Modify: `lib/features/y/y_screen.dart`, `lib/features/y/y_post_detail.dart`, `lib/features/y/y_profile_sheet.dart`, `lib/features/shell/tablet_shell.dart`
- Test: `test/golden/phone_guard_y_test.dart` (new, with goldens), `test/unit/y/y_trends_test.dart` (new), `test/widget/y_tablet_test.dart` (new)

**Interfaces:**
- Produces:
  - `typedef YTrend = ({YPost head, int posts});`, `typedef YVoiceCount = ({YPersona persona, int posts});`, `List<YTrend> yTrending(YTimeline feed, {int limit = 5})`, `List<YVoiceCount> yVoices(YTimeline feed, {int limit = 8})`.
  - `class YPostThread extends StatelessWidget { const YPostThread({required YPost post, required List<YPost> all, required void Function(YPost) onAccountTap, Key? key}); }`
  - `class YProfileView extends StatelessWidget { const YProfileView({required YPersona persona, required List<YPost> all, required void Function(YPost) onPostTap, Key? key}); }`
  - `YFeedList({required YTimeline feed, void Function(YPost)? onOpenPost, void Function(YPost)? onOpenAccount, Key? key})` (both null: push the pages, as now).
  - `YScreen.tabletLayoutKey`, `YScreen.trendingKey`, `YScreen.voicesKey`, `YScreen.sideThreadKey`, `YScreen.sideProfileKey`, `YScreen.sideCloseKey`.
- Consumes: `yFeedProvider(careerId)`, `yReadServiceProvider` (the phone's reads), `YFeed.personaOf`, `YPostDetail.eventOf`, `yPostBody`, `yTraitLine`, `TabletPage`, `PanelBox`, `Panel`, `l.yTitle`, `l.yEmpty`, `l.yTrending`, `l.yVoices`, `l.yConversation`.

- [ ] **Step 1: Pin the phone feed, post and profile**

Create `test/golden/phone_guard_y_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/y/y_post_detail.dart';
import 'package:fnm/features/y/y_profile_sheet.dart';
import 'package:fnm/features/y/y_providers.dart';
import 'package:fnm/features/y/y_screen.dart';

import '../helpers/federation_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The phone Y feed, a post's page and an account's page, pinned before
/// their bodies are shared with the tablet's side column.
void main() {
  final feed = fakeYTimeline();

  Future<SeededSave> open(WidgetTester tester, Size size) async {
    final save = await seedSave(
      tester,
      overrides: [
        yFeedProvider(kSeededCareerId).overrideWith((ref) async => feed),
      ],
    );
    await pumpRoute(
      tester,
      save,
      '${Routes.y}?careerId=${save.careerId}',
      size: size,
    );
    return save;
  }

  for (final (name, size) in [
    ('y_phone', kPhoneSize),
    ('y_phone_tall', const Size(390, 2400)),
  ]) {
    testWidgets(name, (tester) async {
      await open(tester, size);
      expect(find.byType(YFeedList), findsOneWidget);
      await expectAppGolden('goldens/$name.png');
    });
  }

  testWidgets('y_post_phone and y_profile_phone', (tester) async {
    await open(tester, kPhoneSize);
    await tester.tap(find.text(yPostBody(enL, feed.posts.first)));
    await settle(tester);
    expect(find.byType(YPostDetail), findsOneWidget);
    await expectAppGolden('goldens/y_post_phone.png');
    await tester.tap(find.text('Ben Stats').last);
    await settle(tester);
    expect(find.byType(YProfileSheet), findsOneWidget);
    await expectAppGolden('goldens/y_profile_phone.png');
  });
}
```

- [ ] **Step 2: Create the baseline, confirm it holds, commit it**

```bash
flutter test --update-goldens test/golden/phone_guard_y_test.dart
flutter test test/golden/phone_guard_y_test.dart
git add test/golden/phone_guard_y_test.dart test/golden/goldens/y_phone.png test/golden/goldens/y_phone_tall.png test/golden/goldens/y_post_phone.png test/golden/goldens/y_profile_phone.png
git commit -m "test(tablet): phone guard for the Y feed, post and profile

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

- [ ] **Step 3: Write the failing tests**

Create `test/unit/y/y_trends_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/y/y_trends.dart';

import '../../helpers/federation_fixtures.dart';

void main() {
  test('trending: the most-posted conversations above the seam', () {
    final trends = yTrending(fakeYTimeline());
    // The win (four posts), then the draw (two). The exit is below the
    // seam: history, not news.
    expect([for (final t in trends) t.head.key], ['fx:1|fan', 'fx:2|fan']);
    expect([for (final t in trends) t.posts], [4, 2]);
  });

  test('trending heads a conversation with its opening post', () {
    final feed = fakeYTimeline();
    // Replies first in the list: the head is still the post they answer.
    final shuffled = (
      posts: [feed.posts[1], feed.posts[2], feed.posts[0], feed.posts[3]],
      reserveFrom: null,
    );
    expect(yTrending(shuffled).single.head.key, 'fx:1|fan');
  });

  test('trending is capped', () {
    expect(yTrending(fakeYTimeline(), limit: 1), hasLength(1));
  });

  test('voices: who posts most, then by name, across the whole feed', () {
    final voices = yVoices(fakeYTimeline());
    expect(voices.first.persona.handle, '@AnaFan');
    expect(voices.first.posts, 2);
    expect([for (final v in voices.skip(1)) v.persona.displayName], [
      'Ben Stats',
      'Cid Rival',
      'Dee Pundit',
      'Eli Meme',
      'Fay Wire',
    ]);
    expect(yVoices(fakeYTimeline(), limit: 3), hasLength(3));
  });
}
```

Create `test/widget/y_tablet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/y/y_post_detail.dart';
import 'package:fnm/features/y/y_profile_sheet.dart';
import 'package:fnm/features/y/y_providers.dart';
import 'package:fnm/features/y/y_screen.dart';

import '../helpers/federation_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The feed a test can change under an open screen, as a sim step would.
final _feed = StateProvider<YTimeline>((ref) => fakeYTimeline());

Future<SeededSave> _open(WidgetTester tester, Size size) async {
  final save = await seedSave(
    tester,
    formFactor: FormFactor.tablet,
    overrides: [
      yFeedProvider(kSeededCareerId).overrideWith(
        (ref) async => ref.watch(_feed),
      ),
    ],
  );
  await pumpRoute(
    tester,
    save,
    '${Routes.y}?careerId=${save.careerId}',
    size: size,
  );
  return save;
}

Finder _inFeed(Finder f) =>
    find.descendant(of: find.byType(YFeedList), matching: f);

Future<DateTime?> _readAt(WidgetTester tester, SeededSave save) async {
  late DateTime? at;
  await tester.runAsync(() async {
    at = (await save.container
            .read(careerRepositoryProvider)
            .byId(save.careerId))
        ?.yReadAt;
  });
  return at;
}

void main() {
  final feed = fakeYTimeline();

  for (final size in kTabletSizes) {
    testWidgets('the timeline, trending and voices beside it, $size', (
      tester,
    ) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(YScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      final timeline = tester.getRect(find.byType(YFeedList));
      final trending = tester.getRect(find.byKey(YScreen.trendingKey));
      final voices = tester.getRect(find.byKey(YScreen.voicesKey));
      expect(trending.left, greaterThan(timeline.right));
      expect(voices.top, greaterThan(trending.bottom));
      // The win heads trending; Ana heads the voices.
      expect(
        find.descendant(
          of: find.byKey(YScreen.trendingKey),
          matching: find.text(yPostBody(enL, feed.posts.first)),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byKey(YScreen.voicesKey),
          matching: find.text('Ana Fan'),
        ),
        findsOneWidget,
      );
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('a post opens beside the feed, its author from there', (
    tester,
  ) async {
    await _open(tester, kTabletSize);
    await tester.tap(_inFeed(find.text(yPostBody(enL, feed.posts.first))));
    await settle(tester);
    // Beside the feed, not a page of its own.
    expect(find.byType(YPostDetail), findsNothing);
    expect(find.byKey(YScreen.sideThreadKey), findsOneWidget);
    expect(
      tester.widget<YPostThread>(find.byType(YPostThread)).post.key,
      'fx:1|fan',
    );
    expect(find.byKey(YScreen.trendingKey), findsNothing);
    await tester.tap(
      find
          .descendant(
            of: find.byKey(YScreen.sideThreadKey),
            matching: find.text('Ben Stats'),
          )
          .first,
    );
    await settle(tester);
    expect(find.byType(YProfileSheet), findsNothing);
    expect(
      tester.widget<YProfileView>(find.byType(YProfileView)).persona.handle,
      '@BenStats',
    );
    await tester.tap(find.byKey(YScreen.sideCloseKey));
    await settle(tester);
    expect(find.byKey(YScreen.trendingKey), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a voice opens the account beside the feed', (tester) async {
    await _open(tester, kTabletSize);
    await tester.tap(
      find.descendant(
        of: find.byKey(YScreen.voicesKey),
        matching: find.text('Ana Fan'),
      ),
    );
    await settle(tester);
    expect(
      tester.widget<YProfileView>(find.byType(YProfileView)).persona.handle,
      '@AnaFan',
    );
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('posts that arrive while the feed is open are read too', (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    expect(await _readAt(tester, save), DateTime(2027, 6, 10));
    // A step adds a post to the feed on show.
    final later = fakePost(
      'Gus Fan',
      YVoice.fan,
      'fx:3|fan',
      DateTime(2027, 6, 20),
    );
    save.container.read(_feed.notifier).state = (
      posts: [later, ...feed.posts],
      reserveFrom: 7,
    );
    await settle(tester);
    expect(_inFeed(find.text('Gus Fan')), findsOneWidget);
    expect(await _readAt(tester, save), DateTime(2027, 6, 20));
    await tester.pumpWidget(const SizedBox());
  });
}
```

- [ ] **Step 4: Run them to verify they fail**

Run: `flutter test test/unit/y/y_trends_test.dart test/widget/y_tablet_test.dart`
Expected: FAIL to compile (`y_trends.dart`, `YPostThread`, `YProfileView`, `YScreen.tabletLayoutKey` do not exist).

- [ ] **Step 5: Trending and voices**

Create `lib/features/y/y_trends.dart`:

```dart
import 'package:fnm/domain/services/press/persona.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/features/y/y_post_detail.dart';

/// One conversation people are having: the post that opened it and how many
/// posts it has run to.
typedef YTrend = ({YPost head, int posts});

/// One account in the feed and how often it has spoken.
typedef YVoiceCount = ({YPersona persona, int posts});

/// The conversations with the most posts in the recent part of [feed], most
/// first, newest first among equals, at most [limit]. Only the posts above
/// the seam count: the landmarks kept back from earlier in the cycle are
/// history, not what anyone is talking about. A conversation is every post
/// about the same event (see [YPostDetail.eventOf]); its head is the post the
/// others answer.
List<YTrend> yTrending(YTimeline feed, {int limit = 5}) {
  final seam = feed.reserveFrom;
  final recent = seam == null ? feed.posts : feed.posts.take(seam);
  final byEvent = <String, List<YPost>>{};
  for (final p in recent) {
    (byEvent[YPostDetail.eventOf(p)] ??= []).add(p);
  }
  final trends = [
    for (final posts in byEvent.values)
      (
        head: posts.firstWhere(
          (p) => p.replyTo == null,
          orElse: () => posts.first,
        ),
        posts: posts.length,
      ),
  ]..sort((a, b) {
    final byCount = b.posts.compareTo(a.posts);
    return byCount != 0 ? byCount : b.head.date.compareTo(a.head.date);
  });
  return trends.take(limit).toList();
}

/// Who has said the most across the whole feed, most first, by name among
/// equals, at most [limit]. The persona is re-derived from a post, as the
/// profile page does, so nothing is stored.
List<YVoiceCount> yVoices(YTimeline feed, {int limit = 8}) {
  final byHandle = <String, List<YPost>>{};
  for (final p in feed.posts) {
    (byHandle[p.handle] ??= []).add(p);
  }
  final voices = [
    for (final posts in byHandle.values)
      (persona: YFeed.personaOf(posts.first), posts: posts.length),
  ]..sort((a, b) {
    final byCount = b.posts.compareTo(a.posts);
    return byCount != 0
        ? byCount
        : a.persona.displayName.compareTo(b.persona.displayName);
  });
  return voices.take(limit).toList();
}
```

- [ ] **Step 6: The post and profile bodies, shared**

In `lib/features/y/y_post_detail.dart`, replace the `body: ListView(...)` of `YPostDetail.build` (and the `event`/`replies` locals above it, which move) so the build reads:

```dart
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(l.yTitle, style: AppTypography.titleMedium),
        centerTitle: true,
      ),
      body: YPostThread(
        post: post,
        all: all,
        onAccountTap: (p) => _openAccount(context, p),
      ),
    );
  }
```

and add, moved verbatim from the old build:

```dart
/// One post and everything else said about the same event, as a list: the
/// body of [YPostDetail], and of the tablet's side column.
class YPostThread extends StatelessWidget {
  const YPostThread({
    required this.post,
    required this.all,
    required this.onAccountTap,
    super.key,
  });

  final YPost post;

  /// The whole feed, which the replies are drawn from.
  final List<YPost> all;

  /// Opens whoever wrote the post handed to it.
  final void Function(YPost post) onAccountTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final event = YPostDetail.eventOf(post);
    final replies = [
      for (final p in all)
        if (p.key != post.key && YPostDetail.eventOf(p) == event) p,
    ];
    // Edge to edge, like the feed it was opened from: the rows carry their
    // own margins now, so a page padding here would inset the conversation
    // by twice as much as the timeline behind it.
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        YPostTile(post: post, onAccountTap: () => onAccountTap(post)),
        if (replies.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.marginMobile,
              AppSpacing.sm,
              AppSpacing.marginMobile,
              AppSpacing.xs,
            ),
            child: Text(
              l.yReplies,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          for (final r in replies)
            YPostTile(post: r, onAccountTap: () => onAccountTap(r)),
        ],
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}
```

In `lib/features/y/y_profile_sheet.dart`, make `YProfileSheet.build`:

```dart
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(l.yTitle, style: AppTypography.titleMedium),
        centerTitle: true,
      ),
      body: YProfileView(
        persona: persona,
        all: all,
        // The post still opens its conversation, on a page of its own.
        onPostTap: (p) => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => YPostDetail(post: p, all: all),
          ),
        ),
      ),
    );
  }
```

and add, moved verbatim from the old build:

```dart
/// Who is behind a handle and everything they have said this save, as a
/// list: the body of [YProfileSheet], and of the tablet's side column.
class YProfileView extends StatelessWidget {
  const YProfileView({
    required this.persona,
    required this.all,
    required this.onPostTap,
    super.key,
  });

  final YPersona persona;

  /// The whole feed. The account's own posts are filtered out of it, so the
  /// profile can never disagree with the timeline it was opened from.
  final List<YPost> all;

  /// Opens the conversation a post of theirs belongs to.
  final void Function(YPost post) onPostTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final mine = [
      for (final p in all)
        if (p.handle == persona.handle) p,
    ]..sort((a, b) => b.date.compareTo(a.date));
    return ListView(
      // Edge to edge, like the feed: every row below carries its own
      // margins.
      padding: EdgeInsets.zero,
      children: [
        _Header(persona: persona),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.marginMobile,
            AppSpacing.md,
            AppSpacing.marginMobile,
            AppSpacing.xs,
          ),
          child: Text(
            l.yProfilePosts,
            maxLines: 1,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
        if (mine.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.marginMobile,
              vertical: AppSpacing.sm,
            ),
            child: Text(
              l.yProfileEmpty,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
        for (var i = 0; i < mine.length; i++)
          YPostTile(
            post: mine[i],
            topRule: i > 0,
            // The post still opens its conversation. What it must NOT do
            // here is offer the account again: tapping the name of the
            // account whose profile you are already reading would open the
            // same profile onto itself.
            onTap: () => onPostTap(mine[i]),
          ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}
```

- [ ] **Step 7: The feed list's callbacks, the read mark, the layout hook**

In `lib/features/y/y_screen.dart`:

Add the imports `package:fnm/domain/services/press/persona.dart`, `package:fnm/features/y/y_trends.dart` and `package:fnm/shared/tablet/tablet.dart`, and below the imports `part 'y_tablet_layout.dart';`.

In `YScreen` add:

```dart
  static const Key tabletLayoutKey = Key('y.tabletLayout');
  static const Key trendingKey = Key('y.trending');
  static const Key voicesKey = Key('y.voices');
  static const Key sideThreadKey = Key('y.side.thread');
  static const Key sideProfileKey = Key('y.side.profile');
  static const Key sideCloseKey = Key('y.side.close');
```

In `_YScreenState`, replace

```dart
  /// Whether the feed has been stamped read on this visit — once per visit, so
  /// a rebuild does not keep writing the same watermark.
  bool _marked = false;
```

with

```dart
  /// The feed last stamped read, so a rebuild does not keep writing the same
  /// watermark. A NEW feed is stamped again: on a tablet the sim runs under
  /// this screen, and posts that arrive while it is on show have been seen.
  YTimeline? _markedFeed;
```

and the marking block at the top of `build` with

```dart
    // Opening the feed IS reading it: the badge counts what has been said
    // since, not what has been tapped.
    final shown = async.valueOrNull;
    if (shown != null && !identical(shown, _markedFeed)) {
      _markedFeed = shown;
      unawaited(ref.read(yReadServiceProvider).markRead(careerId));
    }
    if (TabletShellScope.isActive(context)) {
      return _YTabletLayout(
        feedAsync: async,
        onBack: () => context.canPop()
            ? context.pop()
            : context.go('${Routes.hub}?careerId=$careerId'),
      );
    }
```

(`async.hasValue` and `async.valueOrNull != null` agree here: the feed is never null.)

Give `YFeedList` two optional callbacks; the pushes stay its default:

```dart
class YFeedList extends StatelessWidget {
  const YFeedList({
    required this.feed,
    this.onOpenPost,
    this.onOpenAccount,
    super.key,
  });

  final YTimeline feed;

  /// Opens a post; null pushes its page (the phone).
  final void Function(YPost post)? onOpenPost;

  /// Opens whoever wrote a post; null pushes the profile page (the phone).
  final void Function(YPost post)? onOpenAccount;
```

and in its `itemBuilder` make the two callbacks:

```dart
          onTap: () => onOpenPost != null
              ? onOpenPost!(posts[i])
              : Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => YPostDetail(post: posts[i], all: posts),
                  ),
                ),
          onAccountTap: () => onOpenAccount != null
              ? onOpenAccount!(posts[i])
              : Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => YProfileSheet(
                      persona: YFeed.personaOf(posts[i]),
                      all: posts,
                    ),
                  ),
                ),
```

keeping their two comments above them.

- [ ] **Step 8: The layout**

Create `lib/features/y/y_tablet_layout.dart`:

```dart
part of 'y_screen.dart';

/// What the side column is showing instead of trending and voices.
sealed class _YSide {
  const _YSide();
}

final class _YSidePost extends _YSide {
  const _YSidePost(this.post);

  final YPost post;
}

final class _YSideAccount extends _YSide {
  const _YSideAccount(this.persona);

  final YPersona persona;
}

/// Y on a tablet: the timeline in the centre, and beside it what is being
/// talked about most and who is talking most. A post or an account opens in
/// that side column (its close button brings trending back), so the feed
/// never leaves the screen. The feed and its read mark are the phone State's.
class _YTabletLayout extends StatefulWidget {
  const _YTabletLayout({required this.feedAsync, required this.onBack});

  final AsyncValue<YTimeline> feedAsync;
  final VoidCallback onBack;

  @override
  State<_YTabletLayout> createState() => _YTabletLayoutState();
}

class _YTabletLayoutState extends State<_YTabletLayout> {
  _YSide? _side;

  static const double _sideWidth = 340;

  void _show(_YSide? side) => setState(() => _side = side);

  void _openPost(YPost p) => _show(_YSidePost(p));

  void _openAccount(YPost p) => _show(_YSideAccount(YFeed.personaOf(p)));

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return TabletPage(
      scaffoldKey: YScreen.tabletLayoutKey,
      title: l.yTitle,
      onBack: widget.onBack,
      child: widget.feedAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (feed) {
          if (feed.posts.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  l.yEmpty,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: PanelBox(
                  child: YFeedList(
                    feed: feed,
                    onOpenPost: _openPost,
                    onOpenAccount: _openAccount,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              SizedBox(width: _sideWidth, child: _sideColumn(l, feed)),
            ],
          );
        },
      ),
    );
  }

  Widget _sideColumn(AppLocalizations l, YTimeline feed) {
    final all = feed.posts;
    return switch (_side) {
      null => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Panel(
              key: YScreen.trendingKey,
              title: l.yTrending,
              padding: EdgeInsets.zero,
              child: _TrendList(trends: yTrending(feed), onOpen: _openPost),
            ),
            const SizedBox(height: AppSpacing.md),
            Panel(
              key: YScreen.voicesKey,
              title: l.yVoices,
              padding: EdgeInsets.zero,
              child: _VoiceList(
                voices: yVoices(feed),
                onOpen: (persona) => _show(_YSideAccount(persona)),
              ),
            ),
          ],
        ),
      ),
      _YSidePost(:final post) => _SidePanel(
        key: YScreen.sideThreadKey,
        title: l.yConversation,
        onClose: () => _show(null),
        child: YPostThread(
          key: ValueKey(post.key),
          post: post,
          all: all,
          onAccountTap: _openAccount,
        ),
      ),
      _YSideAccount(:final persona) => _SidePanel(
        key: YScreen.sideProfileKey,
        title: persona.displayName,
        onClose: () => _show(null),
        child: YProfileView(
          key: ValueKey(persona.handle),
          persona: persona,
          all: all,
          onPostTap: _openPost,
        ),
      ),
    };
  }
}

/// A side-column panel with a close button in its header.
class _SidePanel extends StatelessWidget {
  const _SidePanel({
    required this.title,
    required this.onClose,
    required this.child,
    super.key,
  });

  final String title;
  final VoidCallback onClose;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PanelBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 34,
            color: AppColors.surfaceContainer,
            padding: const EdgeInsets.only(left: 12),
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
                IconButton(
                  key: YScreen.sideCloseKey,
                  tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                  iconSize: 18,
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.close, color: AppColors.primary),
                  onPressed: onClose,
                ),
              ],
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

/// The conversations with the most posts: who opened each, what they said,
/// and how many posts it has run to.
class _TrendList extends StatelessWidget {
  const _TrendList({required this.trends, required this.onOpen});

  final List<YTrend> trends;
  final void Function(YPost post) onOpen;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final t in trends)
          InkWell(
            onTap: () => onOpen(t.head),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.head.displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TabletText.barStrong,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          yPostBody(l, t.head),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TabletText.cell,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  const Icon(
                    Icons.chat_bubble_outline,
                    size: 14,
                    color: AppColors.outline,
                  ),
                  const SizedBox(width: 4),
                  Text('${t.posts}', style: TabletText.cellNumeric),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// The accounts that post most: who they are, what sort they are, and how
/// often they have spoken.
class _VoiceList extends StatelessWidget {
  const _VoiceList({required this.voices, required this.onOpen});

  final List<YVoiceCount> voices;
  final void Function(YPersona persona) onOpen;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final v in voices)
          InkWell(
            onTap: () => onOpen(v.persona),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withValues(alpha: 0.16),
                    ),
                    child: Text(
                      v.persona.displayName.characters.first,
                      style: TabletText.barStrong.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          v.persona.displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TabletText.barStrong,
                        ),
                        Text(
                          v.persona.handle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TabletText.barMeta,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          yTraitLine(l, v.persona.trait),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TabletText.cell.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text('${v.posts}', style: TabletText.cellNumeric),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
```

(`yTraitLine` comes from `y_profile_sheet.dart`, already imported by `y_screen.dart`.)

- [ ] **Step 9: Register, run, expect PASS**

Add `Routes.y,` to `tabletReadyPaths`.

Run: `flutter test test/unit/y/y_trends_test.dart test/widget/y_tablet_test.dart test/golden/phone_guard_y_test.dart test/widget/y_screen_test.dart test/widget/y_persona_test.dart test/widget/hub_tablet_test.dart test/widget/tablet_route_sweep_test.dart`
Expected: PASS, phone goldens unchanged.

- [ ] **Step 10: Analyze, full suite, commit**

Run: `flutter analyze && flutter test`

```bash
git add lib/features/y test/unit/y/y_trends_test.dart test/widget/y_tablet_test.dart lib/features/shell/tablet_shell.dart
git commit -m "feat(tablet): Y timeline with trending and voices beside it

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 8: The manager's page: skills beside name and staff

**risk: high (per-task review)**. Spends skill points and renames the manager.

The spec lists the manager with the dashboards, but `StaffCard` is built on `WholeText` (a `LayoutBuilder`), which cannot sit in a `DashboardGrid` tile. So the tablet page is two scrolling columns of the phone's own cards: the skills (the decision) on the left, the name and the staff (who is employed; hiring stays on the budget screen) on the right. The cards are reused as they are; nothing in the phone file moves.

**Files:**
- Create: `lib/features/manager/manager_tablet_layout.dart` (part of `manager_screen.dart`)
- Modify: `lib/features/manager/manager_screen.dart`, `lib/features/shell/tablet_shell.dart`
- Test: `test/golden/phone_guard_manager_test.dart` (new, with goldens), `test/widget/manager_tablet_test.dart` (new)

**Interfaces:**
- Produces: `ManagerScreen.tabletLayoutKey`, `ManagerScreen.skillsKey`.
- Consumes: `managerViewProvider(careerId)` (the phone's read), `_NameCard`, `_SkillsCard` (the phone file's own), `StaffCard(readOnly: true)`, `ManagerService.raise` and `rename` (through the cards), `TabletPage`, `l.sideManager`.

- [ ] **Step 1: Pin the phone manager page**

Create `test/golden/phone_guard_manager_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/federation/staff_card.dart';

import '../helpers/federation_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The phone manager page, pinned before the tablet layout is added: as a
/// fresh save shows it, and with points to spend (the + buttons lit).
void main() {
  for (final (name, size, points) in [
    ('manager_phone', kPhoneSize, 0),
    ('manager_phone_tall', const Size(390, 2400), 0),
    ('manager_points_phone_tall', const Size(390, 2400), 2),
  ]) {
    testWidgets(name, (tester) async {
      final save = await seedSave(
        tester,
        overrides: [if (points > 0) managerWithPoints(points)],
      );
      await pumpRoute(
        tester,
        save,
        '${Routes.manager}?careerId=${save.careerId}',
        size: size,
      );
      expect(find.byType(StaffCard), findsOneWidget);
      await expectAppGolden('goldens/$name.png');
    });
  }
}
```

- [ ] **Step 2: Create the baseline, confirm it holds, commit it**

```bash
flutter test --update-goldens test/golden/phone_guard_manager_test.dart
flutter test test/golden/phone_guard_manager_test.dart
git add test/golden/phone_guard_manager_test.dart test/golden/goldens/manager_phone.png test/golden/goldens/manager_phone_tall.png test/golden/goldens/manager_points_phone_tall.png
git commit -m "test(tablet): phone guard for the manager page

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

- [ ] **Step 3: Write the failing tablet test**

Create `test/widget/manager_tablet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/features/federation/staff_card.dart';
import 'package:fnm/features/manager/manager_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';

import '../helpers/federation_fixtures.dart';
import '../helpers/seeded_save.dart';

Future<SeededSave> _open(WidgetTester tester, Size size, {int points = 0}) async {
  final save = await seedSave(
    tester,
    formFactor: FormFactor.tablet,
    overrides: [if (points > 0) managerWithPoints(points)],
  );
  await pumpRoute(
    tester,
    save,
    '${Routes.manager}?careerId=${save.careerId}',
    size: size,
  );
  return save;
}

Future<Career> _career(WidgetTester tester, SeededSave save) async {
  late Career career;
  await tester.runAsync(() async {
    career = (await save.container
        .read(careerRepositoryProvider)
        .byId(save.careerId))!;
  });
  return career;
}

/// The + of each skill row, in the phone's order: man-management, tactical,
/// youth development, negotiation.
Finder _raise(int skill) => find.descendant(
  of: find.byKey(ManagerScreen.skillsKey),
  matching: find.widgetWithIcon(IconButton, Icons.add_circle),
).at(skill);

void main() {
  for (final size in kTabletSizes) {
    testWidgets('skills on the left, name and staff on the right, $size', (
      tester,
    ) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(ManagerScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      final skills = tester.getRect(find.byKey(ManagerScreen.skillsKey));
      final staff = tester.getRect(find.byType(StaffCard));
      expect(staff.left, greaterThan(skills.right));
      expect(find.text(enL.managerSkills), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('two points raise two skills by one each, then no more', (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize, points: 2);
    final before = await _career(tester, save);
    expect(find.text(enL.managerPointsAvailable(2)), findsOneWidget);
    await tester.tap(_raise(1));
    await settle(tester);
    await tester.tap(_raise(2));
    await settle(tester);
    final after = await _career(tester, save);
    expect(after.skillTactical, before.skillTactical + 1);
    expect(after.skillYouthDevelopment, before.skillYouthDevelopment + 1);
    expect(after.skillManManagement, before.skillManManagement);
    expect(after.skillNegotiation, before.skillNegotiation);
    expect(find.text(enL.managerPointsAvailable(0)), findsOneWidget);
    for (var i = 0; i < 4; i++) {
      expect(tester.widget<IconButton>(_raise(i)).onPressed, isNull);
    }
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the pencil renames the manager', (tester) async {
    final save = await _open(tester, kTabletSize);
    await tester.tap(find.byTooltip(enL.managerRename));
    await settle(tester);
    await tester.enterText(find.byType(TextField), 'Vera');
    await tester.tap(find.text(enL.managerRenameSave));
    await settle(tester);
    expect((await _career(tester, save)).managerName, 'Vera');
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text('Vera'), findsWidgets);
    await tester.pumpWidget(const SizedBox());
  });
}
```

- [ ] **Step 4: Run it to verify it fails**

Run: `flutter test test/widget/manager_tablet_test.dart`
Expected: FAIL to compile (`ManagerScreen.tabletLayoutKey` does not exist).

- [ ] **Step 5: Hook in the layout**

In `lib/features/manager/manager_screen.dart`:

Add the import `package:fnm/shared/tablet/tablet.dart` and, below the imports, `part 'manager_tablet_layout.dart';`.

In `ManagerScreen` add:

```dart
  static const Key tabletLayoutKey = Key('manager.tabletLayout');

  /// The skills card on the tablet page.
  static const Key skillsKey = Key('manager.skills');
```

Make the first line of `ManagerScreen.build`:

```dart
    if (TabletShellScope.isActive(context)) {
      return _ManagerTabletLayout(careerId: careerId);
    }
```

- [ ] **Step 6: The layout**

Create `lib/features/manager/manager_tablet_layout.dart`:

```dart
part of 'manager_screen.dart';

/// The manager's page on a tablet: his skills (where the points go) on the
/// left, his name and his staff on the right, each column scrolling on its
/// own. The phone's cards, side by side: a `DashboardGrid` cannot hold the
/// staff card, whose names size themselves with a LayoutBuilder.
class _ManagerTabletLayout extends ConsumerWidget {
  const _ManagerTabletLayout({required this.careerId});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(managerViewProvider(careerId));
    return TabletPage(
      scaffoldKey: ManagerScreen.tabletLayoutKey,
      title: l.sideManager,
      // Back to whatever opened this (the hub's skills prompt pushes it), or
      // to the hub when the sidebar did.
      onBack: () => context.canPop()
          ? context.pop()
          : context.go('${Routes.hub}?careerId=$careerId'),
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (view) => view == null
            ? const SizedBox.shrink()
            : Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 7,
                    child: SingleChildScrollView(
                      child: KeyedSubtree(
                        key: ManagerScreen.skillsKey,
                        child: _SkillsCard(careerId: careerId, view: view),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    flex: 5,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _NameCard(
                            careerId: careerId,
                            name: view.career.managerName,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          // Read-only: hiring is on the budget screen, where
                          // the wages are weighed against the departments.
                          StaffCard(careerId: careerId, readOnly: true),
                        ],
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

Add `Routes.manager,` to `tabletReadyPaths`.

Run: `flutter test test/widget/manager_tablet_test.dart test/golden/phone_guard_manager_test.dart test/widget/staff_effect_test.dart test/widget/tablet_route_sweep_test.dart`
Expected: PASS, phone goldens unchanged.

- [ ] **Step 8: Analyze, full suite, commit**

Run: `flutter analyze && flutter test`

```bash
git add lib/features/manager/manager_screen.dart lib/features/manager/manager_tablet_layout.dart lib/features/shell/tablet_shell.dart test/widget/manager_tablet_test.dart
git commit -m "feat(tablet): the manager's skills beside his name and staff

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 9: Budget setup: the editor beside what it buys

**risk: high (per-task review)**. Spends the federation's budget; the forced first event of every cycle; hiring staff.

On a tablet the sliders sit on the left (each with its department's blurb), and on the right the staff (hiring stays here, where the wages are weighed), a "What this budget buys" panel that states each department's effect live as the sliders move, and the Confirm bar. The sliders' own inline effect lines are hidden on the tablet (`InvestmentEditor.showEffects: false`) so the effects are said once, on the right. Every number both layouts show comes from one State method, `_budgetFor`, and both call the same `_confirm`; the State survives a window crossing 1000 px, so an allocation in progress survives a resize.

When the budget-levels work merges (not on this branch, see Global Constraints) it changes `kBudgetStep`, `budgetReady` and the `ready` line, all of which now live in `_budgetFor` and `budgetReady` only, plus `InvestmentEditor`, which the tablet reuses unchanged.

**Files:**
- Create: `lib/features/federation/budget_setup_tablet_layout.dart` (part of `budget_setup_screen.dart`)
- Modify: `lib/features/federation/budget_setup_screen.dart`, `lib/features/federation/investment_editor.dart`, `lib/features/shell/tablet_shell.dart`
- Test: `test/golden/phone_guard_budget_test.dart` (new, with goldens), `test/widget/budget_setup_tablet_test.dart` (new)

**Interfaces:**
- Produces:
  - `BudgetSetupScreen.tabletLayoutKey`, `BudgetSetupScreen.effectsKey`.
  - `InvestmentEditor({required int available, required FederationInvestment initial, required ValueChanged<FederationInvestment> onChanged, bool youthEnabled = true, bool showEffects = true, Key? key})`.
  - Private: `typedef _Budget = ({int available, FederationInvestment alloc, int allocated, bool overCommitted, bool ready, bool settled});`, `_BudgetSetupScreenState._budgetFor(Career)`, `_onAllocated(FederationInvestment)`, `_confirmBar(AppLocalizations, Career, _Budget)`, `_BudgetBanner`, `_EffectsList`, `_spentOn(FederationInvestment, Department)`.
- Consumes: `_budgetCareerProvider`, `federationFundsProvider`, `budgetSettledProvider` (the phone's three reads), `budgetReady`, `_confirm`, `StaffCard`, `DepartmentEffect.describe`, `departmentLabel`, `TourKeys.budgetStaff`, `TourKeys.budgetDepartments`, `TabletPage`, `Panel`, `l.budgetSetupTitle`, `l.budgetEffectsTitle`, `l.federationBudgetHeading`, `l.federationDistributeBudget`, `l.deptEffectNone`.

- [ ] **Step 1: Pin the phone budget setup**

Create `test/golden/phone_guard_budget_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/federation/investment_editor.dart';

import '../helpers/seeded_save.dart';

/// The phone budget setup, pinned before its banner and confirm bar are
/// shared with the tablet: as it opens, and with money in two departments
/// (effect lines lit, the over-budget and ready states of the bar).
void main() {
  for (final (name, size) in [
    ('budget_phone', kPhoneSize),
    ('budget_phone_tall', const Size(390, 2400)),
  ]) {
    testWidgets(name, (tester) async {
      final save = await seedSave(tester);
      await pumpRoute(
        tester,
        save,
        '${Routes.budgetSetup}?careerId=${save.careerId}',
        size: size,
      );
      expect(find.byType(InvestmentEditor), findsOneWidget);
      await expectAppGolden('goldens/$name.png');
    });
  }

  testWidgets('budget_allocated_phone_tall', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.budgetSetup}?careerId=${save.careerId}',
      size: const Size(390, 2400),
    );
    // Every slider to its top, in order: the first takes its cap, the next
    // what is left, and the budget is spent.
    for (var i = 0; i < 5; i++) {
      final slider = tester.widget<Slider>(find.byType(Slider).at(i));
      slider.onChanged?.call(slider.max);
      await tester.pump();
    }
    await settle(tester);
    await expectAppGolden('goldens/budget_allocated_phone_tall.png');
  });
}
```

- [ ] **Step 2: Create the baseline, confirm it holds, commit it**

```bash
flutter test --update-goldens test/golden/phone_guard_budget_test.dart
flutter test test/golden/phone_guard_budget_test.dart
git add test/golden/phone_guard_budget_test.dart test/golden/goldens/budget_phone.png test/golden/goldens/budget_phone_tall.png test/golden/goldens/budget_allocated_phone_tall.png
git commit -m "test(tablet): phone guard for the budget setup

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

- [ ] **Step 3: Write the failing tablet test**

Create `test/widget/budget_setup_tablet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/federation/federation_finance.dart';
import 'package:fnm/features/federation/budget_setup_screen.dart';
import 'package:fnm/features/federation/department_effect.dart';
import 'package:fnm/features/federation/investment_editor.dart';
import 'package:fnm/features/federation/staff_card.dart';
import 'package:fnm/features/onboarding/tour_keys.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/federation_fixtures.dart';
import '../helpers/seeded_save.dart';

Future<SeededSave> _open(WidgetTester tester, Size size) async {
  final save = await seedSave(tester, formFactor: FormFactor.tablet);
  await pumpRoute(
    tester,
    save,
    '${Routes.budgetSetup}?careerId=${save.careerId}',
    size: size,
  );
  return save;
}

Slider _slider(WidgetTester tester, int i) =>
    tester.widget<Slider>(find.byType(Slider).at(i));

/// Drags the [i]th slider (Youth first) to [euros], as a finger would.
Future<void> _set(WidgetTester tester, int i, double euros) async {
  _slider(tester, i).onChanged!(euros);
  await tester.pump();
}

Finder _effect(Department d) => find.byKey(ValueKey('budget.effect.${d.name}'));

/// The page's own Confirm (the top bar's Continue is outside the page).
PrimaryButton _confirmButton(WidgetTester tester) =>
    tester.widget<PrimaryButton>(
      find.descendant(
        of: find.byKey(BudgetSetupScreen.tabletLayoutKey),
        matching: find.byType(PrimaryButton),
      ),
    );

void main() {
  for (final size in kTabletSizes) {
    testWidgets('the sliders left, staff and effects right, $size', (
      tester,
    ) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(BudgetSetupScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      final editor = tester.getRect(find.byType(InvestmentEditor));
      final staff = tester.getRect(find.byType(StaffCard));
      final effects = tester.getRect(
        find.byKey(BudgetSetupScreen.effectsKey),
      );
      expect(staff.left, greaterThan(editor.right));
      expect(effects.left, staff.left);
      // The tour finds both of its targets.
      expect(find.byKey(TourKeys.budgetDepartments), findsOneWidget);
      expect(find.byKey(TourKeys.budgetStaff), findsOneWidget);
      // Nothing allocated: every department says so, once, on the right.
      for (final d in Department.values) {
        expect(
          tester.widget<Text>(_effect(d)).data,
          enL.deptEffectNone,
        );
      }
      expect(find.text(enL.deptEffectNone), findsNWidgets(5));
      expect(_confirmButton(tester).onPressed, isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('a slider moves its effect on the right', (tester) async {
    await _open(tester, kTabletSize);
    await _set(tester, 0, 8000000);
    final line = DepartmentEffect.describe(enL, Department.youth, 8000000);
    expect(tester.widget<Text>(_effect(Department.youth)).data, line);
    // Said once: the slider's own effect line is hidden on a tablet.
    expect(find.text(line), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a resize keeps the allocation', (tester) async {
    await _open(tester, kTabletSize);
    await _set(tester, 0, 8000000);
    tester.view.physicalSize = const Size(900, 810);
    await settle(tester);
    expect(find.byKey(BudgetSetupScreen.tabletLayoutKey), findsNothing);
    expect(_slider(tester, 0).value, 8000000);
    tester.view.physicalSize = kTabletSize;
    await settle(tester);
    expect(find.byKey(BudgetSetupScreen.tabletLayoutKey), findsOneWidget);
    expect(_slider(tester, 0).value, 8000000);
    expect(
      tester.widget<Text>(_effect(Department.youth)).data,
      DepartmentEffect.describe(enL, Department.youth, 8000000),
    );
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('spent in full, confirmed: stored, and the bar moves on', (
    tester,
  ) async {
    final save = await _open(tester, kTabletSize);
    // Review Focus 2: the bar offers the budget before...
    expect(topBarContinue(tester).label, enL.hubEventSetBudget);
    final budget = save.career.budget;
    for (var i = 0; i < 5; i++) {
      final slider = _slider(tester, i);
      await _set(tester, i, slider.max);
    }
    final ready = _confirmButton(tester);
    expect(ready.onPressed, isNotNull);
    await tester.tap(find.byWidget(ready));
    await settle(tester);
    expect(
      save.container
          .read(routerProvider)
          .routeInformationProvider
          .value
          .uri
          .path,
      Routes.hub,
    );
    await tester.runAsync(() async {
      final career = (await save.container
          .read(careerRepositoryProvider)
          .byId(save.careerId))!;
      final stored = await save.container
          .read(careerRepositoryProvider)
          .investment(save.careerId, career.cyclePointer);
      final spent =
          stored.youth +
          stored.commercial +
          stored.medical +
          stored.naturalization +
          stored.boardRelations;
      expect(budgetReady(available: budget, allocated: spent), isTrue);
      expect(career.budget, budget - spent);
    });
    // ...and not after.
    expect(topBarContinue(tester).label, isNot(enL.hubEventSetBudget));
    await tester.pumpWidget(const SizedBox());
  });
}
```

(`routerProvider` comes from `core/routing/app_router.dart`, imported. The seeded save employs nobody, so the free money is the whole balance.)

- [ ] **Step 4: Run it to verify it fails**

Run: `flutter test test/widget/budget_setup_tablet_test.dart`
Expected: FAIL to compile (`BudgetSetupScreen.tabletLayoutKey` does not exist).

- [ ] **Step 5: `InvestmentEditor.showEffects`**

In `lib/features/federation/investment_editor.dart` add to `InvestmentEditor`:

```dart
    this.showEffects = true,
```

(in the constructor, after `this.youthEnabled = true,`) and

```dart
  /// Whether each slider states, under its blurb, what its money buys. The
  /// tablet says that once, beside the sliders, and turns this off.
  final bool showEffects;
```

In `_slider`, wrap the effect line and the gap above it:

```dart
                if (widget.showEffects) ...[
                  const SizedBox(height: 2),
                  // What this money actually buys, live as the slider moves.
                  // The effect used to be legible only on the finances
                  // screen's impact table — a screen away from the decision.
                  Text(
                    value <= 0
                        ? AppLocalizations.of(context).deptEffectNone
                        : DepartmentEffect.describe(
                            AppLocalizations.of(context),
                            dept,
                            value,
                          ),
                    style: AppTypography.labelSmall.copyWith(
                      color: value > 0
                          ? AppColors.positive
                          : AppColors.onSurfaceVariant,
                      fontWeight: value > 0 ? FontWeight.w700 : null,
                    ),
                  ),
                ],
```

(The comment and the Text are the existing ones, unchanged; only the `if` wraps them. With the default `true` the phone draws exactly what it drew.)

- [ ] **Step 6: One set of numbers, one confirm bar, the layout hook**

In `lib/features/federation/budget_setup_screen.dart`:

Add the imports `package:fnm/core/util/federation_label.dart`, `package:fnm/domain/services/federation/federation_finance.dart`, `package:fnm/features/federation/department_effect.dart` and `package:fnm/shared/tablet/tablet.dart`, and below the imports `part 'budget_setup_tablet_layout.dart';`. (Move the stray first-line `tour_keys.dart` import into the sorted block while there; imports only.)

In `BudgetSetupScreen` add:

```dart
  static const Key tabletLayoutKey = Key('budgetSetup.tabletLayout');

  /// The tablet's "What this budget buys" panel.
  static const Key effectsKey = Key('budgetSetup.effects');
```

Above `_BudgetSetupScreenState` add:

```dart
/// Everything both layouts read off the allocation in progress, worked out
/// once (see [_BudgetSetupScreenState._budgetFor]).
typedef _Budget = ({
  int available,
  FederationInvestment alloc,
  int allocated,
  bool overCommitted,
  bool ready,
  bool settled,
});
```

Add these three members to `_BudgetSetupScreenState` (the bodies are the phone build's own lines, moved):

```dart
  /// The money there is, the split so far, and whether it may be confirmed.
  /// Both layouts read these and nothing else, so the rules live here once.
  _Budget _budgetFor(Career career) {
    // The wage bill comes off the top. Staff are a standing cost the
    // federation pays at the rollover, so money already promised to
    // people is not money there is to hand to a department — showing it
    // any other way is how a budget ends up overspent by exactly the
    // amount of an elite scout.
    final available =
        ref
            .watch(federationFundsProvider(widget.careerId))
            .valueOrNull
            ?.free ??
        career.budget;
    final alloc =
        _alloc ??
        const (
          youth: 0,
          commercial: 0,
          medical: 0,
          naturalization: 0,
          boardRelations: 0,
        );
    final allocated =
        alloc.youth +
        alloc.commercial +
        alloc.medical +
        alloc.naturalization +
        alloc.boardRelations;
    // Already distributed this cycle? Then this screen is a record, not
    // an editor. The hub only offers the event while it is unset, but
    // the guided tour visits this route directly and a re-cut here would
    // undo a decision the manager has already lived with.
    final settled =
        ref.watch(budgetSettledProvider(widget.careerId)).valueOrNull ?? false;
    return (
      available: available,
      alloc: alloc,
      allocated: allocated,
      overCommitted: allocated > available,
      ready:
          _alloc != null &&
          budgetReady(available: available, allocated: allocated),
      settled: settled,
    );
  }

  void _onAllocated(FederationInvestment a) => setState(() => _alloc = a);

  /// What is still to do (or what is over), and the button that commits it.
  Widget _confirmBar(AppLocalizations l, Career career, _Budget b) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!b.ready)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Text(
              // Over-committed says something different from
              // "not finished yet": the manager has promised
              // money that is not there, usually by hiring staff
              // after allocating, and needs to take some back.
              b.overCommitted
                  ? l.federationOverBudget(
                      formatEuros(b.allocated - b.available),
                    )
                  : l.federationAllocateFullBudget,
              style: AppTypography.labelSmall.copyWith(
                color: b.overCommitted
                    ? AppColors.error
                    : AppColors.onSurfaceVariant,
              ),
            ),
          ),
        PrimaryButton(
          label: b.settled
              ? l.federationBudgetAlreadySet
              : _busy
              ? l.federationConfirming
              : l.federationConfirmBudget,
          icon: Icons.savings_rounded,
          onPressed: (!b.ready || _busy || b.settled)
              ? null
              : () => unawaited(_confirm(career, b.alloc)),
        ),
      ],
    );
  }
```

(The comments are the phone's, moved; their dashes are code comments, not copy.)

Rewrite `build` so it reads (the phone half draws exactly the tree it drew, the banner now a widget of its own):

```dart
  @override
  Widget build(BuildContext context) {
    final careerAsync = ref.watch(_budgetCareerProvider(widget.careerId));
    final l = AppLocalizations.of(context);
    if (TabletShellScope.isActive(context)) {
      return TabletPage(
        scaffoldKey: BudgetSetupScreen.tabletLayoutKey,
        title: l.budgetSetupTitle,
        // A way out, as on the phone: forced is not the same as a trap.
        onBack: () => context.go('${Routes.hub}?careerId=${widget.careerId}'),
        child: careerAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Text(l.federationCouldNotLoadFinances(e.toString())),
          ),
          data: (career) => career == null
              ? Center(child: Text(l.federationSaveNotFound))
              : _BudgetSetupTabletLayout(
                  state: this,
                  career: career,
                  budget: _budgetFor(career),
                ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        // A way out. The budget is a FORCED event and stays one — the hub
        // presents it again and again until it is actually distributed, since
        // the event clears on the allocation being confirmed and on nothing
        // else. What it must not be is a TRAP: this screen replaces the stack,
        // so with no leading control and no swipe back, a manager who opened
        // it to look at the numbers could not leave without spending the
        // money. Forced and inescapable are different things.
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          tooltip: l.federationBudgetLater,
          onPressed: () =>
              context.go('${Routes.hub}?careerId=${widget.careerId}'),
        ),
        title: Text(
          l.federationSetYourBudget,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: careerAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l.federationCouldNotLoadFinances(e.toString()))),
        data: (career) {
          if (career == null) {
            return Center(child: Text(l.federationSaveNotFound));
          }
          final b = _budgetFor(career);
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.marginMobile),
                  children: [
                    // A bright banner so the season-defining decision can't be
                    // breezed past.
                    _BudgetBanner(available: b.available),
                    const SizedBox(height: AppSpacing.md),
                    StaffCard(
                      key: TourKeys.budgetStaff,
                      careerId: widget.careerId,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppCard(
                      key: TourKeys.budgetDepartments,
                      child: InvestmentEditor(
                        available: b.available,
                        initial: b.alloc,
                        onChanged: _onAllocated,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.marginMobile),
                  child: _confirmBar(l, career, b),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
```

(The comments are the phone's own, unchanged.) Add, moved verbatim from the old banner `Container`:

```dart
/// The bright banner over the budget, so the season-defining decision can't
/// be breezed past.
class _BudgetBanner extends StatelessWidget {
  const _BudgetBanner({required this.available});

  final int available;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.secondaryContainer,
        borderRadius: AppRadii.baseAll,
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.account_balance_rounded,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                l.federationBudgetHeading,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l.federationDistributeBudget(formatEuros(available)),
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 7: The layout**

Create `lib/features/federation/budget_setup_tablet_layout.dart`:

```dart
part of 'budget_setup_screen.dart';

/// The budget on a tablet: the banner and the sliders on the left; on the
/// right the staff (wages come off the top, so they are hired here), what
/// the allocation buys department by department, and the Confirm bar. Every
/// figure comes from the screen State's [_Budget]; Confirm is its
/// [_BudgetSetupScreenState._confirm].
class _BudgetSetupTabletLayout extends StatelessWidget {
  const _BudgetSetupTabletLayout({
    required this.state,
    required this.career,
    required this.budget,
  });

  final _BudgetSetupScreenState state;
  final Career career;
  final _Budget budget;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final careerId = state.widget.careerId;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 7,
          child: Panel(
            key: TourKeys.budgetDepartments,
            title: l.federationBudgetHeading,
            expand: true,
            padding: EdgeInsets.zero,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.federationDistributeBudget(
                      formatEuros(budget.available),
                    ),
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  InvestmentEditor(
                    available: budget.available,
                    initial: budget.alloc,
                    onChanged: state._onAllocated,
                    // Said once, on the right.
                    showEffects: false,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      StaffCard(key: TourKeys.budgetStaff, careerId: careerId),
                      const SizedBox(height: AppSpacing.md),
                      Panel(
                        key: BudgetSetupScreen.effectsKey,
                        title: l.budgetEffectsTitle,
                        child: _EffectsList(alloc: budget.alloc),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              state._confirmBar(l, career, budget),
            ],
          ),
        ),
      ],
    );
  }
}

/// What each department's money buys this cycle, live as the sliders move:
/// the same words the phone prints under each slider.
class _EffectsList extends StatelessWidget {
  const _EffectsList({required this.alloc});

  final FederationInvestment alloc;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final d in Department.values)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 120,
                  child: Text(
                    departmentLabel(l, d),
                    style: AppTypography.bodyMedium,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: _line(l, d, _spentOn(alloc, d))),
              ],
            ),
          ),
      ],
    );
  }

  Widget _line(AppLocalizations l, Department d, int euros) => Text(
    euros <= 0 ? l.deptEffectNone : DepartmentEffect.describe(l, d, euros),
    key: ValueKey('budget.effect.${d.name}'),
    style: AppTypography.labelSmall.copyWith(
      color: euros > 0 ? AppColors.positive : AppColors.onSurfaceVariant,
      fontWeight: euros > 0 ? FontWeight.w700 : null,
    ),
  );
}

/// What [i] puts into [d].
int _spentOn(FederationInvestment i, Department d) => switch (d) {
  Department.youth => i.youth,
  Department.commercial => i.commercial,
  Department.medical => i.medical,
  Department.naturalization => i.naturalization,
  Department.boardRelations => i.boardRelations,
};
```

- [ ] **Step 8: Register, run, expect PASS**

Add `Routes.budgetSetup,` to `tabletReadyPaths`.

Run: `flutter test test/widget/budget_setup_tablet_test.dart test/golden/phone_guard_budget_test.dart test/widget/budget_back_test.dart test/widget/staff_effect_test.dart test/widget/tablet_route_sweep_test.dart`
Expected: PASS, phone goldens unchanged. Also run any unit test that names `budgetReady` or `clampDepartment` (`grep -rln "budgetReady\|clampDepartment" test`) and expect PASS.

- [ ] **Step 9: Prove the resize test bites**

Temporarily make `_BudgetSetupTabletLayout` read `initial: const (youth: 0, commercial: 0, medical: 0, naturalization: 0, boardRelations: 0)` instead of `budget.alloc`; run the resize test; confirm it FAILS on the tablet slider value after growing back; restore.

- [ ] **Step 10: Analyze, full suite, commit**

Run: `flutter analyze && flutter test`

```bash
git add lib/features/federation/budget_setup_screen.dart lib/features/federation/budget_setup_tablet_layout.dart lib/features/federation/investment_editor.dart lib/features/shell/tablet_shell.dart test/widget/budget_setup_tablet_test.dart
git commit -m "feat(tablet): budget setup, the sliders beside what they buy

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 10: Training camp as panels

**risk: high (per-task review)**. An event screen Continue opens; choosing a camp writes the save and leaves for the hub.

The host card across the top, the camps under it as a grid of the phone's own cards (two columns at the narrower sizes, three when a co-hosted tournament offers six and there is room). A tap chooses through the phone's own code path.

**Files:**
- Create: `lib/features/squad/training_camp_tablet_layout.dart` (part of `training_camp_screen.dart`)
- Modify: `lib/features/squad/training_camp_screen.dart`, `lib/features/shell/tablet_shell.dart`
- Test: `test/golden/phone_guard_camp_test.dart` (new, with goldens), `test/widget/training_camp_tablet_test.dart` (new)

**Interfaces:**
- Produces: `TrainingCampScreen.tabletLayoutKey`; private `_CampHeader` and `TrainingCampScreen._cardFor(BuildContext, WidgetRef, TrainingCampPlan, CampOption)`, shared by both layouts.
- Consumes: `trainingCampPlanProvider(careerId)` (the phone's read), `TrainingCampService.choose` (through `_cardFor`), `_CampCard`, `ColumnFlow`, `TabletPage`, `l.campTitle`, `l.hubContinue`.

- [ ] **Step 1: Pin the phone training camp**

Create `test/golden/phone_guard_camp_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/squad/training_camp_providers.dart';

import '../helpers/federation_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The phone base-camp decision, pinned before its header and cards are
/// shared with the tablet: one host, three co-hosts, and nothing to decide.
void main() {
  for (final (name, hosts) in [
    ('camp_phone_tall', 1),
    ('camp_cohosts_phone_tall', 3),
  ]) {
    testWidgets(name, (tester) async {
      final plan = fakeCampPlan(campHosts(hosts));
      final save = await seedSave(
        tester,
        overrides: [
          trainingCampPlanProvider(
            kSeededCareerId,
          ).overrideWith((ref) async => plan),
        ],
      );
      await pumpRoute(
        tester,
        save,
        '${Routes.trainingCamp}?careerId=${save.careerId}',
        size: const Size(390, 2400),
      );
      expect(find.text(plan.options.first.camp.name), findsOneWidget);
      await expectAppGolden('goldens/$name.png');
    });
  }

  testWidgets('camp_none_phone', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.trainingCamp}?careerId=${save.careerId}',
    );
    expect(find.text(enL.hubContinue), findsOneWidget);
    await expectAppGolden('goldens/camp_none_phone.png');
  });
}
```

- [ ] **Step 2: Create the baseline, confirm it holds, commit it**

```bash
flutter test --update-goldens test/golden/phone_guard_camp_test.dart
flutter test test/golden/phone_guard_camp_test.dart
git add test/golden/phone_guard_camp_test.dart test/golden/goldens/camp_phone_tall.png test/golden/goldens/camp_cohosts_phone_tall.png test/golden/goldens/camp_none_phone.png
git commit -m "test(tablet): phone guard for the training camp

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

- [ ] **Step 3: Write the failing tablet test**

Create `test/widget/training_camp_tablet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/squad/training_camp_providers.dart';
import 'package:fnm/features/squad/training_camp_screen.dart';

import '../helpers/federation_fixtures.dart';
import '../helpers/seeded_save.dart';

Future<SeededSave> _open(
  WidgetTester tester,
  Size size, {
  TrainingCampPlan? plan,
}) async {
  final save = await seedSave(
    tester,
    formFactor: FormFactor.tablet,
    overrides: [
      if (plan != null)
        trainingCampPlanProvider(
          kSeededCareerId,
        ).overrideWith((ref) async => plan),
    ],
  );
  await pumpRoute(
    tester,
    save,
    '${Routes.trainingCamp}?careerId=${save.careerId}',
    size: size,
  );
  return save;
}

String _path(SeededSave save) => save.container
    .read(routerProvider)
    .routeInformationProvider
    .value
    .uri
    .path;

void main() {
  for (final size in kTabletSizes) {
    testWidgets('the host on top, the four camps two to a row, $size', (
      tester,
    ) async {
      final plan = fakeCampPlan(campHosts(1));
      await _open(tester, size, plan: plan);
      expect(tester.takeException(), isNull);
      expect(find.byKey(TrainingCampScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      expect(find.text(enL.campBasedIn(plan.hostName)), findsOneWidget);
      final names = [for (final o in plan.options) o.camp.name];
      final first = tester.getRect(find.text(names[0]));
      final second = tester.getRect(find.text(names[1]));
      final third = tester.getRect(find.text(names[2]));
      expect(second.top, first.top);
      expect(second.left, greaterThan(first.right));
      expect(third.top, greaterThan(first.bottom));
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('three co-hosts: their six camps three to a row', (
    tester,
  ) async {
    final plan = fakeCampPlan(campHosts(3));
    await _open(tester, kTabletSize, plan: plan);
    expect(tester.takeException(), isNull);
    final rects = [
      for (final o in plan.options) tester.getRect(find.text(o.camp.name)),
    ];
    expect(rects, hasLength(6));
    expect(rects[1].top, rects[0].top);
    expect(rects[2].top, rects[0].top);
    expect(rects[3].top, greaterThan(rects[0].bottom));
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a tapped camp is the camp stored, then the hub', (
    tester,
  ) async {
    final plan = fakeCampPlan(campHosts(2));
    final save = await _open(tester, kTabletSize, plan: plan);
    // The second host's first camp: the country is part of the choice.
    final option = plan.options.firstWhere((o) => o.hostId != plan.hostId);
    await tester.tap(find.text(option.camp.name));
    await settle(tester);
    expect(_path(save), Routes.hub);
    await tester.runAsync(() async {
      final stored = await save.container
          .read(careerRepositoryProvider)
          .trainingCamp(save.careerId, plan.cycle, plan.tournament);
      expect(stored?.hostId, option.hostId);
      expect(stored?.campIndex, option.camp.index);
    });
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('nothing to decide: Continue to the hub', (tester) async {
    final save = await _open(tester, kTabletSize);
    expect(find.byKey(TrainingCampScreen.tabletLayoutKey), findsOneWidget);
    await tester.tap(find.text(enL.hubContinue).last);
    await settle(tester);
    expect(_path(save), Routes.hub);
    await tester.pumpWidget(const SizedBox());
  });
}
```

(`find.text(enL.hubContinue).last`: the top bar's Continue may read the same word; the page's own button comes later in the tree.)

- [ ] **Step 4: Run it to verify it fails**

Run: `flutter test test/widget/training_camp_tablet_test.dart`
Expected: FAIL to compile (`TrainingCampScreen.tabletLayoutKey` does not exist).

- [ ] **Step 5: Share the header and the cards, hook in the layout**

In `lib/features/squad/training_camp_screen.dart`:

Add the import `package:fnm/shared/tablet/tablet.dart` and, below the imports, `part 'training_camp_tablet_layout.dart';`.

In `TrainingCampScreen` add:

```dart
  static const Key tabletLayoutKey = Key('trainingCamp.tabletLayout');

  /// One camp's card, wired to choose it and go back to the hub. The
  /// country is part of the choice when the tournament is shared, so then
  /// every card wears its flag.
  Widget _cardFor(
    BuildContext context,
    WidgetRef ref,
    TrainingCampPlan plan,
    CampOption option,
  ) => _CampCard(
    camp: option.camp,
    countryCode: plan.hostNames.length > 1 ? option.hostCode : null,
    countryName: plan.hostNames.length > 1 ? option.hostName : null,
    selected: plan.isChosen(option),
    onTap: () async {
      await ref
          .read(trainingCampServiceProvider)
          .choose(careerId, plan, option);
      if (context.mounted) context.go(_exit());
    },
  );
```

Make the first line of `build`:

```dart
    if (TabletShellScope.isActive(context)) {
      return _TrainingCampTabletLayout(screen: this);
    }
```

In the phone `ListView`, replace the first `AppCard(child: Row(...))` (the host card) with `_CampHeader(plan: plan),` and the loop's

```dart
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _CampCard(
                    ...
                  ),
                ),
```

with

```dart
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _cardFor(context, ref, plan, option),
                ),
```

and add, moved verbatim:

```dart
/// Where the squad will be based: the host's flag, every host country's
/// name, and what a base camp is for.
class _CampHeader extends StatelessWidget {
  const _CampHeader({required this.plan});

  final TrainingCampPlan plan;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AppCard(
      child: Row(
        children: [
          FlagDisc(plan.hostCode, size: 34),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // Every host country, not just the primary one —
                  // the squad may be based in any of them.
                  l.campBasedIn(plan.hostNames.join(' · ')),
                  style: AppTypography.titleMedium,
                ),
                Text(
                  l.campBlurb,
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
```

- [ ] **Step 6: The layout**

Create `lib/features/squad/training_camp_tablet_layout.dart`:

```dart
part of 'training_camp_screen.dart';

/// The base-camp decision on a tablet: the host card across the top, the
/// camps on offer under it in as many columns as fit. The phone's read and
/// the phone's cards; a tap chooses through [TrainingCampScreen._cardFor].
class _TrainingCampTabletLayout extends ConsumerWidget {
  const _TrainingCampTabletLayout({required this.screen});

  final TrainingCampScreen screen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final planAsync = ref.watch(trainingCampPlanProvider(screen.careerId));
    return TabletPage(
      scaffoldKey: TrainingCampScreen.tabletLayoutKey,
      title: l.campTitle,
      child: planAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.hubCouldNotLoad('$e'))),
        data: (plan) {
          if (plan == null) {
            // Nothing to decide (the tournament has started, or the nation
            // isn't in one): don't strand the manager on a blank page.
            return Center(
              child: SizedBox(
                width: 320,
                child: PrimaryButton(
                  label: l.hubContinue,
                  icon: Icons.arrow_forward_rounded,
                  onPressed: () => context.go(screen._exit()),
                ),
              ),
            );
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _CampHeader(plan: plan),
                const SizedBox(height: AppSpacing.md),
                ColumnFlow(
                  minTileWidth: 300,
                  // Four camps read as a square; six (co-hosts) in threes.
                  maxColumns: plan.options.length <= 4 ? 2 : 3,
                  children: [
                    for (final option in plan.options)
                      screen._cardFor(context, ref, plan, option),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          );
        },
      ),
    );
  }
}
```

(At 1194 wide the content area holds three 300 px tiles, at 1080 and 1024 two; four camps stay two to a row everywhere.)

- [ ] **Step 7: Register, run, expect PASS**

Add `Routes.trainingCamp,` to `tabletReadyPaths`.

Run: `flutter test test/widget/training_camp_tablet_test.dart test/golden/phone_guard_camp_test.dart test/widget/tablet_route_sweep_test.dart`
Expected: PASS, phone goldens unchanged.

- [ ] **Step 8: Analyze, full suite, commit**

Run: `flutter analyze && flutter test`

```bash
git add lib/features/squad/training_camp_screen.dart lib/features/squad/training_camp_tablet_layout.dart lib/features/shell/tablet_shell.dart test/widget/training_camp_tablet_test.dart
git commit -m "feat(tablet): the base-camp decision as panels

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 11: Naturalisation: the offer beside the player's card

**risk: high (per-task review)**. An event screen Continue opens; the decision writes the save, files a message and leaves for the hub.

On a tablet the offer (who, from where, what it means) and the two decisions sit on the left, and the player's full card (`PlayerView`, through `DetailPaneHost`) on the right, so the manager can read his attributes and history before he decides. That is more than the phone shows, and the point of the space.

The fix that comes with it (Review Focus 2): `nextEventProvider` reads the pending offer imperatively, and the tablet top bar keeps it (and `hubDataProvider`, which it watches) alive across the whole shell. After a decision the bar would keep offering "Naturalisation", and pressing it would open an empty decision screen. On a phone the hub's providers are rebuilt when the hub comes back, so the bug is tablet-only, but the fix is harmless on both: `_resolve` invalidates `pendingNaturalizationProvider` and `hubDataProvider`.

**Files:**
- Create: `lib/features/federation/naturalization_tablet_layout.dart` (part of `naturalization_screen.dart`)
- Modify: `lib/features/federation/naturalization_screen.dart`, `lib/features/shell/tablet_shell.dart`
- Test: `test/golden/phone_guard_naturalization_test.dart` (new, with goldens), `test/widget/naturalization_tablet_test.dart` (new)

**Interfaces:**
- Produces: `NaturalizationScreen.tabletLayoutKey`; private `_OfferCard` and `_NaturalizationScreenState._decision(AppLocalizations, NaturalizationOffer)`, shared by both layouts.
- Consumes: `pendingNaturalizationProvider(careerId)` (the phone's read), `_resolve`, `hubDataProvider`, `DetailPaneHost`, `PlayerTarget`, `TabletPage`, `PanelBox`, `l.naturalisationTitle`, `l.federationOfferToSwitchAllegiance`, `l.federationNaturalisationBlurb`, `l.federationContinue`.

- [ ] **Step 1: Pin the phone naturalisation**

Create `test/golden/phone_guard_naturalization_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';

import '../helpers/federation_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The phone naturalisation decision, pinned before its offer card and
/// buttons are shared with the tablet: an offer, and nothing to decide.
void main() {
  for (final (name, size) in [
    ('naturalization_phone', kPhoneSize),
    ('naturalization_phone_tall', const Size(390, 2400)),
  ]) {
    testWidgets(name, (tester) async {
      final save = await seedSave(tester);
      await offerNaturalization(tester, save);
      await pumpRoute(
        tester,
        save,
        '${Routes.naturalization}?careerId=${save.careerId}',
        size: size,
      );
      expect(find.text(enL.federationNaturalise), findsOneWidget);
      await expectAppGolden('goldens/$name.png');
    });
  }

  testWidgets('naturalization_none_phone', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.naturalization}?careerId=${save.careerId}',
    );
    expect(find.text(enL.federationContinue), findsOneWidget);
    await expectAppGolden('goldens/naturalization_none_phone.png');
  });
}
```

- [ ] **Step 2: Create the baseline, confirm it holds, commit it**

```bash
flutter test --update-goldens test/golden/phone_guard_naturalization_test.dart
flutter test test/golden/phone_guard_naturalization_test.dart
git add test/golden/phone_guard_naturalization_test.dart test/golden/goldens/naturalization_phone.png test/golden/goldens/naturalization_phone_tall.png test/golden/goldens/naturalization_none_phone.png
git commit -m "test(tablet): phone guard for the naturalisation decision

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

- [ ] **Step 3: Write the failing tablet test**

Create `test/widget/naturalization_tablet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/federation/naturalization_screen.dart';
import 'package:fnm/features/player/player_detail_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';

import '../helpers/federation_fixtures.dart';
import '../helpers/seeded_save.dart';

Future<void> _pump(WidgetTester tester, SeededSave save, Size size) =>
    pumpRoute(
      tester,
      save,
      '${Routes.naturalization}?careerId=${save.careerId}',
      size: size,
    );

String _path(SeededSave save) => save.container
    .read(routerProvider)
    .routeInformationProvider
    .value
    .uri
    .path;

Future<String?> _status(
  WidgetTester tester,
  SeededSave save,
  int playerId,
) async {
  late String? status;
  await tester.runAsync(() async {
    final repo = save.container.read(careerRepositoryProvider);
    final accepted = await repo.acceptedNaturalizations(save.careerId);
    final pending = await repo.pendingNaturalization(save.careerId);
    status = accepted.any((n) => n.playerId == playerId)
        ? 'accepted'
        : pending?.playerId == playerId
        ? 'pending'
        : 'declined';
  });
  return status;
}

void main() {
  for (final size in kTabletSizes) {
    testWidgets('the offer and the decision beside his card, $size', (
      tester,
    ) async {
      final save = await seedSave(tester, formFactor: FormFactor.tablet);
      final offer = await offerNaturalization(tester, save);
      await _pump(tester, save, size);
      expect(tester.takeException(), isNull);
      expect(
        find.byKey(NaturalizationScreen.tabletLayoutKey),
        findsOneWidget,
      );
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      final card = find.byType(PlayerView);
      expect(tester.widget<PlayerView>(card).playerId, offer.playerId);
      expect(
        tester.getCenter(find.text(enL.federationNaturalise)).dx,
        lessThan(tester.getRect(card).left),
      );
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('accepting stores it, and the top bar moves on', (
    tester,
  ) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    final offer = await offerNaturalization(tester, save);
    // The budget comes first in the hub's order; with it set, the offer is
    // the next event.
    await markBudgetSet(tester, save);
    await _pump(tester, save, kTabletSize);
    expect(topBarContinue(tester).label, enL.hubEventNaturalization);
    await tester.tap(find.text(enL.federationNaturalise));
    await settle(tester);
    expect(_path(save), Routes.hub);
    expect(await _status(tester, save, offer.playerId), 'accepted');
    expect(topBarContinue(tester).label, isNot(enL.hubEventNaturalization));
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('declining turns him away', (tester) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    final offer = await offerNaturalization(tester, save);
    await markBudgetSet(tester, save);
    await _pump(tester, save, kTabletSize);
    await tester.tap(find.text(enL.federationDecline));
    await settle(tester);
    expect(_path(save), Routes.hub);
    expect(await _status(tester, save, offer.playerId), 'declined');
    expect(topBarContinue(tester).label, isNot(enL.hubEventNaturalization));
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('nothing to decide: Continue to the hub', (tester) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    await _pump(tester, save, kTabletSize);
    expect(
      find.byKey(NaturalizationScreen.tabletLayoutKey),
      findsOneWidget,
    );
    await tester.tap(find.text(enL.federationContinue));
    await settle(tester);
    expect(_path(save), Routes.hub);
    await tester.pumpWidget(const SizedBox());
  });
}
```

- [ ] **Step 4: Run it to verify it fails**

Run: `flutter test test/widget/naturalization_tablet_test.dart`
Expected: FAIL to compile (`NaturalizationScreen.tabletLayoutKey` does not exist).

- [ ] **Step 5: The decision refreshes the hub; share the card and the buttons**

In `lib/features/federation/naturalization_screen.dart`:

Add the imports `package:fnm/features/hub/hub_providers.dart`, `package:fnm/features/shell/detail_pane_host.dart` and `package:fnm/shared/tablet/tablet.dart`, and below the imports `part 'naturalization_tablet_layout.dart';`.

In `NaturalizationScreen` add:

```dart
  static const Key tabletLayoutKey = Key('naturalization.tabletLayout');
```

In `_resolve`, directly after the `await repo.setNaturalizationStatus(...)` statement, add:

```dart
    // The hub's next event reads the offer straight from the save. A tablet
    // keeps the hub's data (and the top bar's Continue with it) alive across
    // this screen, so without this the bar would go on offering the decision
    // just taken.
    ref
      ..invalidate(pendingNaturalizationProvider(widget.careerId))
      ..invalidate(hubDataProvider(widget.careerId));
```

Add to `_NaturalizationScreenState`:

```dart
  /// Decline and naturalise, side by side. Both settle the offer, once.
  Widget _decision(AppLocalizations l, NaturalizationOffer offer) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _busy
                ? null
                : () => unawaited(_resolve(offer, accept: false)),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
            child: Text(l.federationDecline),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: PrimaryButton(
            label: l.federationNaturalise,
            icon: Icons.how_to_reg_rounded,
            onPressed: _busy
                ? null
                : () => unawaited(_resolve(offer, accept: true)),
          ),
        ),
      ],
    );
  }
```

Make the first lines of `build` (after `async` and `l` are read):

```dart
    if (TabletShellScope.isActive(context)) {
      return _NaturalizationTabletLayout(state: this, async: async);
    }
```

In the phone tree, replace the `AppCard(child: Column(children: [Row(...), Divider(...), Row(...)]))` after the heading with `_OfferCard(offer: offer),`, and the bottom bar's `child: Row(children: [Expanded(OutlinedButton...), SizedBox, Expanded(PrimaryButton...)])` with `child: _decision(l, offer),`. Add, moved verbatim:

```dart
/// Who is asking: his flag, name and age, where he plays now, his rating,
/// and the switch from his nation to the manager's.
class _OfferCard extends StatelessWidget {
  const _OfferCard({required this.offer});

  final NaturalizationOffer offer;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final p = offer.player;
    return AppCard(
      child: Column(
        children: [
          Row(
            children: [
              FlagDisc(offer.sourceNation.code, size: 40),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.name, style: AppTypography.titleMedium),
                    Text(
                      l.federationPlayerMeta(
                        p.position.name,
                        p.age,
                        offer.sourceNation.name,
                      ),
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              _RatingBadge(overall: p.overall),
            ],
          ),
          const Divider(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlagDisc(offer.sourceNation.code, size: 22),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: 18,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              FlagDisc(offer.playerNation.code, size: 22, highlighted: true),
              const SizedBox(width: AppSpacing.sm),
              Text(
                offer.playerNation.name,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
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

The phone's `final p = offer.player;` local stays (the blurb below still reads `p.name`).

- [ ] **Step 6: The layout**

Create `lib/features/federation/naturalization_tablet_layout.dart`:

```dart
part of 'naturalization_screen.dart';

/// The naturalisation decision on a tablet: the offer and the two answers on
/// the left, the player's full card on the right, so his attributes and
/// record are read before he is taken on. The phone State's read, card and
/// buttons; the answers are its [_NaturalizationScreenState._resolve].
class _NaturalizationTabletLayout extends StatelessWidget {
  const _NaturalizationTabletLayout({required this.state, required this.async});

  final _NaturalizationScreenState state;
  final AsyncValue<NaturalizationOffer?> async;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final careerId = state.widget.careerId;
    return TabletPage(
      scaffoldKey: NaturalizationScreen.tabletLayoutKey,
      title: l.naturalisationTitle,
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l.federationCouldNotLoadOffer(e.toString()))),
        data: (offer) {
          if (offer == null) {
            return Center(
              child: SizedBox(
                width: 320,
                child: PrimaryButton(
                  label: l.federationContinue,
                  icon: Icons.check_rounded,
                  onPressed: () =>
                      context.go('${Routes.hub}?careerId=$careerId'),
                ),
              ),
            );
          }
          final p = offer.player;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              l.federationOfferToSwitchAllegiance,
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            _OfferCard(offer: offer),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              l.federationNaturalisationBlurb(
                                p.name,
                                offer.playerNation.name,
                                offer.sourceNation.name,
                              ),
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    state._decision(l, offer),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                flex: 6,
                child: PanelBox(
                  child: DetailPaneHost(
                    careerId: careerId,
                    target: PlayerTarget(p.id),
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

Add `Routes.naturalization,` to `tabletReadyPaths`.

Run: `flutter test test/widget/naturalization_tablet_test.dart test/golden/phone_guard_naturalization_test.dart test/widget/tablet_route_sweep_test.dart`
Expected: PASS, phone goldens unchanged.

- [ ] **Step 8: Prove the refresh bites**

Comment out the new `ref..invalidate(...)` statement in `_resolve`, run the accept test, confirm it FAILS on the top bar still reading `enL.hubEventNaturalization`, restore it.

- [ ] **Step 9: Analyze, full suite, commit**

Run: `flutter analyze && flutter test`

```bash
git add lib/features/federation/naturalization_screen.dart lib/features/federation/naturalization_tablet_layout.dart lib/features/shell/tablet_shell.dart test/widget/naturalization_tablet_test.dart
git commit -m "feat(tablet): naturalisation beside the player's card; the decision refreshes the hub

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 12: Stage 3 carry-overs: the tests it left open

**risk: low (batched review)**. Tests only, plus two fakes. Reviewed with the stage's final review.

Five gaps the stage 3 reviews deferred. One needed a decision first: the competition views key their `DefaultTabController` by the landing tab (`ValueKey(liveTab)`), and stage 3's reviewer asked whether a top-bar refresh could jump the manager off the tab he picked. It cannot, unless the stage moves: during a refresh Riverpod keeps the previous value (`valueOrNull` still returns it), so `liveTab` and the key stay put; when the stage really moves (qualifying to finals, finals to bracket), re-landing on the live stage is the documented intent. Decision: keep the behaviour, pin it with a test.

**Files:**
- Modify: `test/helpers/competition_fixtures.dart` (`fakeContinentalData`, `fakeAfricanNationsCup`)
- Modify: `test/widget/cup_detail_tablet_test.dart`, `test/widget/detail_pane_host_test.dart`, `test/widget/continental_detail_tablet_test.dart`, `test/widget/nations_cup_tablet_test.dart`, `test/widget/match_preview_tablet_test.dart`

**Interfaces:**
- Produces (`competition_fixtures.dart`): `ContinentalData fakeContinentalData(int playerNationId, {Confederation confederation = Confederation.europe})`, `NationsCupData fakeAfricanNationsCup(int playerNationId)`.
- Consumes: `cupDetailProvider`, `continentalDetailProvider`, `nationsCupProvider`, `matchPreviewProvider`, `wcHostThemeProvider`, `DetailPaneHost`, `PlayerTarget`, `NationTarget`, `NationView`, `PlayerView`, `TournamentBracket`, `MatchHeadline`, `OpponentBriefing`, `WcHostBanner`, `MatchStage`, `africaZoneLabel`, `showTab`.

- [ ] **Step 1: The two fakes**

In `test/helpers/competition_fixtures.dart` add the imports (sorted into place; skip any already there):

```dart
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/domain/services/competition/nations_cups.dart';
```

and append:

```dart
/// A continental championship played to its end: six groups of four, a
/// round of 16 to the final, the manager's nation heading group A. Drawn with
/// the same real nations for any [confederation] (only the flags matter); it
/// is the manager's region only when it is his own confederation's cup.
ContinentalData fakeContinentalData(
  int playerNationId, {
  Confederation confederation = Confederation.europe,
}) {
  final info = ContinentalCups.byConfederation[confederation]!;
  final field = fieldOf(playerNationId, 24);
  final finals = groupsOf(field, groupCount: 6, size: 4);
  final qualifying = info.qualifying
      ? groupsOf(fieldOf(playerNationId, 30), groupCount: 6, size: 5)
      : const <({String name, List<int> nationIds})>[];
  var nextId = 3000;
  Fixture tie(String round, int home, int away) => Fixture(
    id: nextId++,
    careerId: kSeededCareerId,
    competitionId: 97,
    matchday: 1,
    date: DateTime(2028, 7, 1),
    homeNationId: home,
    awayNationId: away,
    homeScore: 2,
    awayScore: 1,
    round: round,
    played: true,
  );
  final r16 = [
    for (var i = 0; i < 8; i++) tie('CR16', field[i].id, field[15 - i].id),
  ];
  final qf = [
    for (var i = 0; i < 4; i++)
      tie('CQF', r16[2 * i].homeNationId, r16[2 * i + 1].homeNationId),
  ];
  final sf = [
    for (var i = 0; i < 2; i++)
      tie('CSF', qf[2 * i].homeNationId, qf[2 * i + 1].homeNationId),
  ];
  final last = tie('CFINAL', sf[0].homeNationId, sf[1].homeNationId);
  return ContinentalData(
    name: info.name,
    confederation: confederation,
    isPlayerRegion:
        realNationsById[playerNationId]!.confederation == confederation,
    hostCount: 1,
    qualifyingGroups: [
      for (final g in qualifying)
        (name: g.name, standings: standingsOf(g.nationIds)),
    ],
    groups: [
      for (final g in finals) (name: g.name, standings: standingsOf(g.nationIds)),
    ],
    knockout: [...r16, ...qf, ...sf, last],
    champion: last.homeNationId,
    scorers: const [],
    honours: const [],
    nations: realNationsById,
    playerNationId: playerNationId,
    playerNames: const {},
  );
}

/// The African Nations Cup mid-season, seen by a manager from elsewhere: in
/// each of the four zones, two groups of the zone's best-ranked nations
/// (N1 and N2, W1 and W2, and so on). No finals drawn yet.
NationsCupData fakeAfricanNationsCup(int playerNationId) {
  final groups = <FinalsGroupTable>[];
  for (final zone in AfricaZone.values) {
    final ranked = [
      for (final n in realNations)
        if (NationsCups.africaZoneByCode[n.code] == zone) n,
    ]..sort((a, b) => a.ranking.compareTo(b.ranking));
    final ids = [for (final n in ranked.take(6)) n.id];
    final half = ids.length ~/ 2;
    final prefix = NationsCups.zonePrefix(zone);
    groups
      ..add((name: '${prefix}1', standings: standingsOf(ids.sublist(0, half))))
      ..add((
        name: '${prefix}2',
        standings: standingsOf(ids.sublist(half, 2 * half)),
      ));
  }
  return (
    confederation: Confederation.africa,
    cupName: NationsCups.africa,
    format: NationsCupFormat.zones,
    isMine: false,
    playerLeague: '',
    playerGroup: null,
    groups: groups,
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
    maxTier: 0,
  );
}
```

- [ ] **Step 2: A refresh keeps the picked tab**

Append to `main()` in `test/widget/cup_detail_tablet_test.dart` (no new imports: `kSeededCareerId`, `seededNationId`, `showTab` and `settle` come from `seeded_save.dart`, `fakeCupData` from `competition_fixtures.dart`, both already imported):

```dart
  // Stage 3 carry-over (liveTab re-key). A top-bar step invalidates this
  // provider under the open page; a refresh that leaves the stage where it
  // was must leave the manager on the tab he picked.
  testWidgets('a refresh keeps the tab the manager picked', (tester) async {
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
      size: kTabletSize,
    );
    TabController controller() =>
        DefaultTabController.of(tester.element(find.byType(TabBarView)));
    expect(controller().index, 4, reason: 'opens on the bracket');
    await showTab(tester, 7);
    save.container.invalidate(cupDetailProvider(save.careerId));
    await settle(tester);
    expect(controller().index, 7);
    await tester.pumpWidget(const SizedBox());
  });
```

- [ ] **Step 3: A nation replaces a player in the pane**

Append to `main()` in `test/widget/detail_pane_host_test.dart` (add `import 'package:fnm/features/nations/nation_vitrine_screen.dart';`):

```dart
  // Stage 3 carry-over. One pane, its target switched from a player to a
  // nation (a ranking row after a squad row): the player's card goes, the
  // nation's record comes, under the nation's heading.
  testWidgets('a nation replaces a player in the same pane', (tester) async {
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
    final target = ValueNotifier<DetailTarget?>(PlayerTarget(playerId));
    addTearDown(target.dispose);
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
            body: SizedBox(
              width: 360,
              child: ValueListenableBuilder<DetailTarget?>(
                valueListenable: target,
                builder: (_, t, _) =>
                    DetailPaneHost(careerId: save.careerId, target: t),
              ),
            ),
          ),
        ),
      ),
    );
    await settle(tester);
    expect(find.byType(PlayerView), findsOneWidget);
    target.value = NationTarget(save.nationId);
    await settle(tester);
    expect(find.byType(PlayerView), findsNothing);
    expect(
      tester.widget<NationView>(find.byType(NationView)).nationId,
      save.nationId,
    );
    expect(find.text(enL.nationsVitrineTitle.toUpperCase()), findsOneWidget);
    target.value = null;
    await settle(tester);
    expect(find.text(enL.panePickPlayer), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
```

- [ ] **Step 4: Continental finals, bracket and the seven-tab cup**

Append to `main()` in `test/widget/continental_detail_tablet_test.dart` (add `import 'package:fnm/features/tournaments/tournament_bracket.dart';` and `import '../helpers/competition_fixtures.dart';`):

```dart
  Future<void> openCup(
    WidgetTester tester,
    Confederation conf,
    Size size,
  ) async {
    final save = await seedSave(
      tester,
      formFactor: FormFactor.tablet,
      overrides: [
        continentalDetailProvider((
          careerId: kSeededCareerId,
          confederation: conf,
        )).overrideWith(
          (ref) async => fakeContinentalData(seededNationId, confederation: conf),
        ),
      ],
    );
    await pumpRoute(
      tester,
      save,
      '${Routes.continental}?careerId=${save.careerId}&conf=${conf.name}',
      size: size,
    );
  }

  int tabIndex(WidgetTester tester) =>
      DefaultTabController.of(tester.element(find.byType(TabBarView))).index;

  for (final size in kTabletSizes) {
    testWidgets('a played cup opens on its bracket, finals in columns, $size', (
      tester,
    ) async {
      await openCup(tester, Confederation.europe, size);
      expect(tester.takeException(), isNull);
      // Summary, Qualifying, Finals, Bracket: the bracket is tab 3.
      expect(tabIndex(tester), 3);
      expect(
        tester.widget<TournamentBracket>(find.byType(TournamentBracket)).wide,
        isTrue,
      );
      await showTab(tester, 2);
      expect(tester.takeException(), isNull);
      final a = tester.getRect(
        find.text(enL.tourContGroupHeading('A')).hitTestable(),
      );
      final b = tester.getRect(
        find.text(enL.tourContGroupHeading('B')).hitTestable(),
      );
      expect(a.top, b.top);
      expect(b.left, greaterThan(a.right));
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('a cup with no qualifying has seven tabs', (tester) async {
    await openCup(tester, Confederation.southAmerica, kTabletSize);
    expect(tester.takeException(), isNull);
    expect(tester.widget<TabBar>(find.byType(TabBar)).tabs, hasLength(7));
    expect(find.text(enL.tourContTabQualifying), findsNothing);
    // Not the manager's region, and played: it opens on its bracket, which
    // is tab 2 once there is no qualifying tab.
    expect(tabIndex(tester), 2);
    expect(find.byType(TournamentBracket), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
```

- [ ] **Step 5: The African cup's zones**

Append to `main()` in `test/widget/nations_cup_tablet_test.dart` (add `import 'package:fnm/core/util/career_label.dart';`, `import 'package:fnm/domain/entities/enums.dart';` and `import 'package:fnm/domain/services/competition/nations_cups.dart';`):

```dart
  for (final size in kTabletSizes) {
    testWidgets('the African cup: its zones, groups in columns, $size', (
      tester,
    ) async {
      final save = await seedSave(
        tester,
        formFactor: FormFactor.tablet,
        overrides: [
          nationsCupProvider((
            careerId: kSeededCareerId,
            confederation: Confederation.africa,
          )).overrideWith((ref) async => fakeAfricanNationsCup(seededNationId)),
        ],
      );
      await pumpRoute(
        tester,
        save,
        '${Routes.nationsCup}?careerId=${save.careerId}'
        '&conf=${Confederation.africa.name}',
        size: size,
      );
      expect(tester.takeException(), isNull);
      expect(find.byKey(NationsCupScreen.tabletLayoutKey), findsOneWidget);
      expect(find.text(enL.tourContTabZones), findsOneWidget);
      expect(find.text(enL.tourContTabFinalsEight), findsOneWidget);
      // A manager from elsewhere: the zones in their own order, North first.
      expect(
        find.text(africaZoneLabel(enL, AfricaZone.north).toUpperCase()),
        findsOneWidget,
      );
      final n1 = tester.getRect(
        find.text(enL.tourContGroupHeading('N1')).hitTestable(),
      );
      final n2 = tester.getRect(
        find.text(enL.tourContGroupHeading('N2')).hitTestable(),
      );
      expect(n1.top, n2.top);
      expect(n2.left, greaterThan(n1.right));
      await showTab(tester, 1);
      expect(find.text(enL.tourContFinalsEightSoon), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }
```

- [ ] **Step 6: The preview's hosted, friendly and away branches**

Append to `test/widget/match_preview_tablet_test.dart` (add the imports `package:fnm/core/util/match_stage.dart`, `package:fnm/features/match/match_providers.dart` and `package:fnm/features/tournaments/wc_host_theme.dart`), above `main()`:

```dart
/// A seeded save's real next-match preview, read in a save of its own: a
/// provider cannot be overridden with a value derived from itself.
Future<MatchPreview> _realPreview(WidgetTester tester) async {
  final source = await seedSave(tester);
  late MatchPreview preview;
  await tester.runAsync(() async {
    final sub = source.container.listen(
      matchPreviewProvider(source.careerId).future,
      (_, _) {},
    );
    preview = (await sub.read())!;
    sub.close();
  });
  return preview;
}

/// [p] in another [round], or with the manager's side moved to the other
/// end ([swap]): the away branch.
MatchPreview _reshaped(MatchPreview p, {String? round, bool swap = false}) {
  var f = p.fixture;
  if (round != null) f = f.copyWith(round: round);
  if (swap) {
    f = f.copyWith(homeNationId: f.awayNationId, awayNationId: f.homeNationId);
  }
  return MatchPreview(
    fixture: f,
    result: p.result,
    nations: p.nations,
    homeTeam: swap ? p.awayTeam : p.homeTeam,
    awayTeam: swap ? p.homeTeam : p.awayTeam,
    playerNationId: p.playerNationId,
    bench: p.bench,
    saveSeed: p.saveSeed,
    opponentBench: p.opponentBench,
    opponentSubs: p.opponentSubs,
    injuryFactorByNation: p.injuryFactorByNation,
    chemistryByNation: p.chemistryByNation,
    neutralVenue: p.neutralVenue,
    venueHostId: p.venueHostId,
    bigMatch: p.bigMatch,
    ground: p.ground,
  );
}

Future<void> _openWith(
  WidgetTester tester,
  MatchPreview preview, {
  WcHostTheme? host,
}) async {
  final save = await seedSave(
    tester,
    formFactor: FormFactor.tablet,
    overrides: [
      matchPreviewProvider(
        kSeededCareerId,
      ).overrideWith((ref) async => preview),
      if (host != null)
        wcHostThemeProvider(kSeededCareerId).overrideWith((ref) async => host),
    ],
  );
  await pumpRoute(
    tester,
    save,
    '${Routes.matchPreview}?careerId=${save.careerId}',
    size: kTabletSize,
  );
}
```

and append inside `main()`:

```dart
  // Stage 3 carry-over: the branches the shared derivation took over.
  testWidgets('away: the manager\'s side is still his, on the right end', (
    tester,
  ) async {
    final real = await _realPreview(tester);
    final away = _reshaped(real, swap: true);
    expect(away.playerIsHome, isNot(real.playerIsHome));
    await _openWith(tester, away);
    expect(tester.takeException(), isNull);
    final briefing = tester.widget<OpponentBriefing>(
      find.byType(OpponentBriefing),
    );
    expect(briefing.myNationId, real.playerNationId);
    expect(briefing.oppNationId, isNot(real.playerNationId));
    expect(
      tester.widget<MatchHeadline>(find.byType(MatchHeadline)).homeCode,
      away.nations[away.fixture.homeNationId]!.code,
    );
    expect(find.text(enL.matchYourXi), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a friendly says so, unskinned', (tester) async {
    final friendly = _reshaped(await _realPreview(tester), round: 'FRIENDLY');
    await _openWith(tester, friendly);
    expect(tester.takeException(), isNull);
    expect(find.text(MatchStage.label(enL, friendly.fixture)), findsWidgets);
    expect(find.byType(WcHostBanner), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a finals match in the host\'s colours', (tester) async {
    final real = await _realPreview(tester);
    final hosted = _reshaped(real, round: 'GROUP');
    const accent = Color(0xFFC8102E);
    await _openWith(
      tester,
      hosted,
      host: (
        active: true,
        accent: accent,
        onAccent: const Color(0xFFFFFFFF),
        colors: const [accent, Color(0xFFFFC400)],
        hostIds: [real.fixture.awayNationId],
        hostLabel: real.nations[real.fixture.awayNationId]!.name.toUpperCase(),
        competitionLabel: 'WORLD CHAMPIONSHIP 2030',
        year: 2030,
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.byType(WcHostBanner), findsOneWidget);
    expect(
      tester.widget<Text>(find.text(enL.matchPreviewTitle)).style?.color,
      accent,
    );
    await tester.pumpWidget(const SizedBox());
  });
```

- [ ] **Step 7: Run them, expect PASS**

Run: `flutter test test/widget/cup_detail_tablet_test.dart test/widget/detail_pane_host_test.dart test/widget/continental_detail_tablet_test.dart test/widget/nations_cup_tablet_test.dart test/widget/match_preview_tablet_test.dart`
Expected: PASS. These pin behaviour that already exists; a failure here is a stage 3 bug: report it with the failing assertion rather than editing the test to pass.

- [ ] **Step 8: Analyze, commit**

Run: `flutter analyze test`

```bash
git add test/helpers/competition_fixtures.dart test/widget/cup_detail_tablet_test.dart test/widget/detail_pane_host_test.dart test/widget/continental_detail_tablet_test.dart test/widget/nations_cup_tablet_test.dart test/widget/match_preview_tablet_test.dart
git commit -m "test(tablet): stage 3 carry-overs (tab kept on refresh, pane switch, continental, zones, preview branches)

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 13: Record stage 4 in the spec, verify, simulator checks

**Files:**
- Modify: `docs/superpowers/specs/2026-10-09-tablet-ui-design.md`

- [ ] **Step 1: Add a section to the spec, after "Stage 3 adjustments"**

```markdown
## Stage 4 adjustments (2026-10-10)

- Finances and board objectives are `DashboardGrid`s of panels. The
  manager's page is not: the staff card sizes its names with a
  `LayoutBuilder`, which a dashboard row cannot measure, so the page is two
  scrolling columns of the phone's cards, skills left, name and staff
  right. Hiring stays on the budget screen.
- Budget setup: the sliders (with their blurbs) left; the staff, a "What
  this budget buys" panel and the Confirm bar right. The sliders' own
  effect lines are hidden on a tablet (`InvestmentEditor.showEffects`), so
  each effect is stated once. Both layouts read one set of numbers
  (`_budgetFor`) and one Confirm, and an allocation in progress survives a
  resize across 1000 px.
- Youth: the watchlist and the five levels are tabs over sortable grids,
  with the picked boy's card in a detail pane and the U-21 call-ups in the
  heading.
- Y: the timeline in the centre; beside it "Trending" (the conversations
  above the seam with the most posts) and "Voices" (the accounts that post
  most). A post or an account opens in that side column instead of a page
  of its own. The feed is marked read again whenever it refreshes while on
  show.
- Training camp: the host card over the camps as a grid of the phone's
  cards (four camps two to a row, a co-hosted six three to a row where
  they fit). Naturalisation: the offer and the two answers left, the
  player's full card right. Both are event pages with no back arrow, as on
  the phone.
- The sim's cascade also refreshes the federation, manager and Y screens
  (`SeasonService._invalidateFederationViews`): the prize money, the
  balance, the manager's points, the youth pyramid and watchlist, the Y
  feed, a pending naturalisation offer and the base camp.
- A naturalisation decision refreshes the hub's data, so the tablet top
  bar (which keeps it alive) stops offering the decision just taken.
- The competition views' tab key (`ValueKey(liveTab)`) is kept: a refresh
  that leaves the stage where it was keeps the manager's tab; a real stage
  change re-lands on the live stage.
- `TabletPage` (heading over content) frames the in-shell pages of this
  stage.
- The budget sliders here are the €500k ones on this branch. The
  budget-levels work merges into `_budgetFor`, `budgetReady` and
  `InvestmentEditor` only, which both layouts share.
- German and Spanish need the 9 stage 4 keys when they merge (values in the
  stage 4 plan, Task 2).
```

- [ ] **Step 2: Full verification**

```bash
flutter analyze
flutter test
```

Expected: no new analyzer issues against `2f9dc3a` (infos allowed only where they already existed); the FINAL summary line of `flutter test` reads "All tests passed!" with no `-N` failures. Paste that line into the task report. Every `test/golden/phone_guard_*` golden passes WITHOUT `--update-goldens`; `git status` shows no changed PNG.

- [ ] **Step 3: Commit the spec**

```bash
git add docs/superpowers/specs/2026-10-09-tablet-ui-design.md
git commit -m "docs: record tablet stage 4 adjustments in the spec

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

`simctl install` over an installed app upgrades it in place and keeps its saves; never `simctl uninstall`. Then, with a save open, take one screenshot per screen and attach their paths to the report:

```bash
mkdir -p /tmp/fnm-stage4
xcrun simctl io booted screenshot /tmp/fnm-stage4/finances.png
```

(repeat after navigating: `board.png`, `manager.png`, `budget.png`, `youth.png`, `y.png`, and, when Continue reaches them, `camp.png` and `naturalization.png`). Read each PNG back and check it against this plan's layouts: panels side by side, nothing clipped at the panel edges, no phone-width frame.

- [ ] **Step 5: Manual checklist (the user drives the simulator)**

Ask the user to do each of these and report back; note each result in the task report:

1. **Budget.** On a new save, the top bar offers "Set your federation budget". Move the sliders: the panel on the right says what each department's money buys, live. Hire a member of staff from the card on the right: the wages come off what is left. Spend it all, Confirm: back on the hub, the top bar now offers the next thing. Open Finances: this cycle's investment shows beside the buildings.
2. **Resize the budget.** Before confirming, with money in a department, narrow the iPad window (Stage Manager or split view) below the tablet width and widen it again: the allocation is still there.
3. **Finances and board.** Sidebar Finances, then Board: panels side by side, no clipped numbers; the board's objectives three to a row.
4. **Manager.** Sidebar Manager & staff: skills left, name and staff right. Rename the manager with the pencil. When points are available, spend one: the + goes grey when there are none left.
5. **Youth.** Sidebar Youth: the (empty) watchlist first; the U-21 tab is a sortable table; tap a boy, his card opens on the right; bookmark him, the Watching tab lists him with the rating he was marked at.
6. **Y.** Sidebar Y: the feed in the middle, Trending and Voices on the right. Tap a post: its conversation opens on the right; tap a name in it: the account opens there; close: Trending is back. Continue a few matches from the top bar with Y open: new posts appear; back on the hub, its Y panel does not count them as unread.
7. **Continue under federation screens.** With Finances (or Youth) open, press the top bar's Continue until a match is played: the prize money (or the pyramid, after 1 December) updates without leaving the screen.
8. **Training camp.** When Continue reaches the base camp: the host card on top, the camps in a grid; pick one, back to the hub, and the top bar moves on.
9. **Naturalisation.** When an offer arrives: the offer and the two buttons on the left, the player's full card on the right. Decide: back to the hub, and the top bar no longer offers the decision.

- [ ] **Step 6: Phone sanity check**

Run the app on an iPhone simulator (`flutter run -d <iPhone simulator id>`; a simulator, so `flutter run` upgrading in place is fine). Finances, board, manager, budget setup (sliders with their effect lines under them), youth, Y (a post and an account open as pages of their own), base camp and naturalisation look and behave exactly as before.

- [ ] **Step 7: Android tablet**

No Android emulator is installed on this Mac (stage 1 finding). Record in the report that the Android tablet check (Pixel Tablet AVD or a real tablet; installs upgrade in place with `adb install -r`, never `flutter install`, never `adb uninstall`) is left for the user.
