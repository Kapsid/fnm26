# Match Schedule Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** An "Upcoming" card on the hub showing the current (or next) international window, and a new Schedule screen listing the whole cycle as windows and tournament stages, opening at today.

**Architecture:** One pure domain service (`MatchSchedule`) folds a nation's cycle fixtures into blocks using the existing nomination-period rule (`Nomination.isPeriodStart`), so a "window" on screen is exactly the window the call-ups use. One provider (`scheduleProvider`) adds the nations and draw-watched gating and watches `hubDataProvider`, so it refreshes on every hub invalidation. Shared row widgets serve the hub card (phone and tablet panel) and the Schedule screen (phone and `TabletPage`).

**Tech Stack:** Flutter, Riverpod 2.6.1 without codegen (`FutureProvider.autoDispose.family`), go_router, gen-l10n (7 languages), drift (read only, no schema change).

**Spec:** `docs/superpowers/specs/2026-10-20-match-schedule-design.md`

## Global Constraints

- No schema change, no new stored state; works on 1.0.5 saves (legacy fixed 3-match months read as one window).
- Riverpod without codegen (no `@riverpod`).
- Copy in all seven `.arb` files (en, cs, de, es, fr, it, pl), then `flutter gen-l10n` and `dart run tool/export_copy.dart` to refresh `copy/strings.csv`. No em dashes. Never "World Cup" in English copy. Czech in label: value forms, no nation names after prepositions.
- The new route is in `tabletReadyPaths` (`lib/features/shell/tablet_shell.dart`) with a `TabletPage` layout, and in the route map of `test/widget/tablet_route_sweep_test.dart`.
- Tablet dashboard tiles must report an intrinsic height: no lists, no `LayoutBuilder` inside `_NextMatchPanel` (see `DashboardGrid`).
- Goldens update only where the card legitimately changes (`test/golden/goldens/hub_phone.png`).
- Never show an undrawn opponent: a fixture whose `drawKindForFixture` kind is not yet watched shows `l.topBarDrawPending` instead of the opponent and is not tappable.
- Run `flutter test` files one at a time (parallel processes clash on native assets).
- Commit steps mean "commit only when the owner asks" (owner rule: nothing is committed without an explicit request).
- Depends on the existing `openNation(context, careerId:, nationId:)` in `lib/features/shell/detail_pane_host.dart`. The team-overview plan (`docs/superpowers/plans/2026-10-20-team-overview-presets-live-et.md`) may change what that page shows; this plan only calls it.

## Review Focus

1. **Stale after a match or sim step:** the card and the schedule must move on after a result is recorded. `scheduleProvider` watches `hubDataProvider(careerId).future`, which every sim step already invalidates. Pinned in Task 2.
2. **Tapping the next match while another hub step is pending** (a draw, a call-up, injury cover) must not skip that step: the next match opens the preview only when `nextEventProvider` is `HubEventKind.match`; otherwise it behaves like any other row (opens the opponent). Pinned in Task 4.
3. **Undrawn opponents:** draw not yet watched means no name, no flag and no tap, on the card and on the screen. Pinned in Tasks 2 and 4.
4. **Cycle over, eliminated, or champion:** no current block. The card shows `l.hubNoMoreFixtures`, the screen shows no Today marker, and nothing crashes. Pinned in Tasks 1 and 4.
5. **A stale unplayed fixture left behind** (a friendly a tournament swallowed) must not pin "current" in the past: current follows `Nomination`'s "first unplayed after the last played" rule. Pinned in Task 1.

---

## File Structure

| File | Responsibility |
|---|---|
| Create `lib/domain/services/competition/match_schedule.dart` | Pure: fixtures to blocks, pending stage rows, current block, hub window |
| Create `lib/features/hub/schedule_providers.dart` | `scheduleProvider`: blocks plus nations plus watched draw kinds |
| Create `lib/features/hub/schedule_widgets.dart` | `ScheduleFixtureRow`, `SchedulePendingRow`, `scheduleRowTap` (shared tap rule) |
| Create `lib/features/hub/schedule_screen.dart` | Schedule screen, phone `Scaffold` and `TabletPage` |
| Modify `lib/features/hub/hub_screen.dart` | Replace `_NextMatch` with `_Upcoming` |
| Modify `lib/features/hub/hub_tablet_layout.dart` | `_NextMatchPanel` body becomes the window rows plus a Full schedule action |
| Modify `lib/core/routing/app_router.dart` | `Routes.schedule = '/schedule'` and its `GoRoute` |
| Modify `lib/features/shell/tablet_shell.dart` | Add `Routes.schedule` to `tabletReadyPaths` |
| Modify `lib/l10n/app_*.arb` (7) | New strings |
| Tests | `test/unit/competition/match_schedule_test.dart`, `test/unit/hub/schedule_provider_test.dart`, `test/widget/schedule_screen_test.dart`, `test/widget/hub_upcoming_test.dart`; update `test/widget/hub_tablet_test.dart`, `test/widget/tablet_route_sweep_test.dart`, `test/golden/goldens/hub_phone.png` |

---

### Task 1: `MatchSchedule`, the pure fold

**Files:**
- Create: `lib/domain/services/competition/match_schedule.dart`
- Test: `test/unit/competition/match_schedule_test.dart`

**Interfaces:**
- Consumes: `Fixture` (`lib/domain/entities/fixture.dart`), `Nomination.isPeriodStart` (`lib/domain/services/squad/nomination.dart`), `Rounds.isKnockout` (`lib/domain/services/competition/rounds.dart`), `FinalsRounds.worldChampionship` / `FinalsRounds.continental` (`finals_participation.dart`).
- Produces:
  ```dart
  /// A stage the nation may still reach whose fixtures are not drawn yet.
  typedef SchedulePending = ({bool knockoutStage, DateTime from});

  /// One window, or one stage of a tournament.
  typedef ScheduleBlock = ({
    int year,
    int month,          // of the block's first fixture
    List<Fixture> fixtures, // date order
    SchedulePending? pending,
  });

  abstract final class MatchSchedule {
    static List<ScheduleBlock> blocks(List<Fixture> fixtures, {required int nationId});
    /// Index into [blocks] of the block holding the match the nation is on, -1 when none.
    static int currentIndex(List<ScheduleBlock> blocks);
  }
  ```

Rules the tests pin:
- Sort by date. A new block starts where `Nomination.isPeriodStart(f, previous)` is true, and also inside a finals tournament where the stage changes: group rounds (`GROUP`, `CGROUP`) form one block, each knockout round its own block.
- Months with no fixtures produce no block.
- `pending` sits only on the LAST block of a WC or continental finals tournament the nation is in:
  - its group stage has an unplayed group fixture of the nation and no knockout fixture exists yet: `(knockoutStage: true, from: lastGroupFixture.date + 1 day)`;
  - its last fixture is a played knockout the nation won (score, else penalties), and the round is not a final or third-place match (`FINAL`, `3RD`, `CFINAL`, `C3RD`): `(knockoutStage: false, from: that date + 1 day)`;
  - otherwise null. The Nations Cup gets no pending row (Claude's call: its Finals Four is a year away and only for group winners).
- `currentIndex`: the block containing the first unplayed fixture AFTER the last played one (the same rule as `Nomination._currentIndex`), or -1.

- [ ] **Step 1: Write the failing tests**

Build fixtures by hand with a helper `fx(id, DateTime date, {String? round, int matchday = 1, int? home, int? away, bool played = false, int? groupId})`, nation 1 against nation 2.

```dart
test('a month of qualifiers is one block', () {
  final b = MatchSchedule.blocks([
    fx(1, DateTime(2026, 9, 6), round: 'CQ'),
    fx(2, DateTime(2026, 9, 9), round: 'CQ', matchday: 2),
    fx(3, DateTime(2026, 9, 12), round: 'CQ', matchday: 3),
  ], nationId: 1);
  expect(b, hasLength(1));
  expect((b.single.year, b.single.month), (2026, 9));
  expect(b.single.fixtures.map((f) => f.id), [1, 2, 3]);
});
test('a friendly after qualifiers in the same month is its own block', ...); // 2 blocks
test('empty months are omitted', ...); // Sep + Nov fixtures -> months [9, 11]
test('a tournament splits by stage', ...); // GROUP x3 then R16 -> 2 blocks
test('an unfinished group stage promises the knockouts from the day after', () {
  // GROUP on Jun 11 (played), 14, 17 (unplayed)
  expect(b.last.pending, (knockoutStage: true, from: DateTime(2030, 6, 18)));
});
test('a knockout won promises the next round, a loss or a final none', ...);
  // R16 won 2-1 on Jun 28 -> (knockoutStage: false, from: Jun 29)
  // R16 lost -> null; FINAL won -> null; QF won on penalties -> pending
test('current skips a stale unplayed fixture left behind', () {
  // FRIENDLY Mar 14 unplayed, CQ Jun 6 played, CQ Jun 9 unplayed
  expect(MatchSchedule.currentIndex(b), b.indexWhere((x) => x.fixtures.any((f) => f.id == 3)));
});
test('no current block once everything is played', ...); // -1
test('a legacy three-match month reads as one window', ...); // CQ 6/9/12 Oct, matchdays 4-6
```

- [ ] **Step 2: Run, expect FAIL** — `flutter test test/unit/competition/match_schedule_test.dart` fails: `match_schedule.dart` not found.
- [ ] **Step 3: Implement `MatchSchedule.blocks` and `currentIndex`** in `match_schedule.dart`. Winner of a knockout: higher score, else higher penalties (read the fixture, do not reach into `SeasonService._winner`).
- [ ] **Step 4: Run, expect PASS** — same command, all tests pass.
- [ ] **Step 5: Commit (when the owner asks)** — `feat(schedule): fold a cycle's fixtures into windows and stages`

---

### Task 2: `scheduleProvider`

**Files:**
- Create: `lib/features/hub/schedule_providers.dart`
- Test: `test/unit/hub/schedule_provider_test.dart`

**Interfaces:**
- Consumes: Task 1; `hubDataProvider` (`lib/features/hub/hub_providers.dart`); `CompetitionRepository.cycleFixturesForNation(careerId, nationId)`, `hasWatchedDraw(careerId, cycle, kind)`; `drawKindForFixture(Fixture)` (`lib/features/hub/draw_reveal.dart`).
- Produces:
  ```dart
  typedef ScheduleData = ({
    int nationId,
    List<ScheduleBlock> blocks,
    int currentIndex,            // -1 when the cycle has nothing left
    Map<int, Nation> nations,    // from HubData.nations
    Set<String> watchedDrawKinds,
  });

  final AutoDisposeFutureProviderFamily<ScheduleData?, int> scheduleProvider;

  /// False while the draw that decides [f]'s opponent is unwatched.
  bool opponentKnown(ScheduleData d, Fixture f);
  ```

The provider awaits `ref.watch(hubDataProvider(careerId).future)` first (null when the hub is null), which ties its refresh to the hub's existing invalidations (memory: derived providers go stale). It checks `hasWatchedDraw` once per distinct kind among the cycle's fixtures.

- [ ] **Step 1: Write the failing tests** (same container setup as `test/unit/squad/injury_cover_test.dart`: seeded DB, `create(nationId: europe[10].id, managerName: 'M', rngSeed: 7)`)

```dart
test('blocks cover the cycle and current is the first window', () async {
  final d = (await c.read(scheduleProvider(careerId).future))!;
  expect(d.blocks, isNotEmpty);
  expect(d.currentIndex, 0);
});
test('recording the first window moves current on', () async {
  // record every fixture of blocks[0], then c.invalidate(hubDataProvider(careerId))
  final d = (await c.read(scheduleProvider(careerId).future))!;
  expect(d.currentIndex, 1);
});
test('a qualifier is hidden until its draw is watched', () async {
  final d = (await c.read(scheduleProvider(careerId).future))!;
  final q = d.blocks.expand((b) => b.fixtures).firstWhere((f) => f.round == 'CQ');
  expect(opponentKnown(d, q), isFalse);
  // markDrawWatched(careerId, cycle, continentalQualDrawKind); invalidate hubDataProvider
  expect(opponentKnown(await reread(), q), isTrue);
});
```

- [ ] **Step 2: Run, expect FAIL** — `flutter test test/unit/hub/schedule_provider_test.dart`: `scheduleProvider` undefined.
- [ ] **Step 3: Implement** `scheduleProvider` and `opponentKnown` in `schedule_providers.dart`.
- [ ] **Step 4: Run, expect PASS**.
- [ ] **Step 5: Commit (when the owner asks)** — `feat(schedule): schedule provider tied to the hub's refresh`

---

### Task 3: Strings, shared rows, and the tap rule

**Files:**
- Modify: `lib/l10n/app_en.arb`, `app_cs.arb`, `app_de.arb`, `app_es.arb`, `app_fr.arb`, `app_it.arb`, `app_pl.arb`; regenerate `lib/l10n/app_localizations*.dart` and `copy/strings.csv`
- Create: `lib/features/hub/schedule_widgets.dart`
- Test: covered by Tasks 4 and 5 widget tests

**Interfaces:**
- Consumes: Task 2; `openNation` (`detail_pane_host.dart`); `nextEventProvider` / `HubEventKind.match` (`hub_event.dart`); `MatchStage.label`, `AppDate.weekdayDayMonthCaps`, `AppDate.dayMonth`, `AppDate.monthYear`; `FlagDisc`.
- Produces:
  ```dart
  class ScheduleFixtureRow extends StatelessWidget {
    const ScheduleFixtureRow({required this.fixture, required this.nationId,
      required this.opponent, required this.opponentKnown, this.onTap, super.key});
    final Fixture fixture; final int nationId; final Nation? opponent;
    final bool opponentKnown; final VoidCallback? onTap;
  }
  class SchedulePendingRow extends StatelessWidget {
    const SchedulePendingRow({required this.pending, super.key});
    final SchedulePending pending;
  }
  /// The one tap rule for a schedule row, or null when the row is not tappable.
  VoidCallback? scheduleRowTap(BuildContext context, {required int careerId,
    required ScheduleData data, required Fixture fixture, required HubEvent? next});
  ```

`scheduleRowTap`: unknown opponent gives null. The first unplayed fixture of the current block, when `next?.kind == HubEventKind.match`, gives `context.go(next.route!)`. Anything else gives `openNation(context, careerId:, nationId: <opponent>)`.

Row content: opponent flag and name (or `l.topBarDrawPending` and a blank disc), `MatchStage.label`, date, H/A marker (none for finals rounds, which are neutral), score when `hasResult` (with the existing AET and penalties markers the results rows use).

Strings (EN, then CS; the other five languages translated by the builder):

| Key | en | cs |
|---|---|---|
| `hubUpcoming` | UPCOMING | NADCHÁZEJÍCÍ |
| `hubFullSchedule` | Full schedule | Celý program |
| `scheduleTitle` | Schedule | Program zápasů |
| `scheduleToday` | Today | Dnes |
| `scheduleKnockoutPending` | Knockout stage, if you go through | Vyřazovací fáze, pokud postoupíte |
| `scheduleNextRoundPending` | Next round | Další kolo |
| `scheduleFromDate` | From {date} | Od: {date} |
| `scheduleHomeShort` | H | D |
| `scheduleAwayShort` | A | V |

- [ ] **Step 1: Add the 9 keys to all seven `.arb` files** (with `@` descriptions in `app_en.arb`; `scheduleFromDate` has a `date` String placeholder).
- [ ] **Step 2: Regenerate** — `flutter gen-l10n` then `dart run tool/export_copy.dart`; expected: no errors, `git diff --stat copy/strings.csv` shows the 9 new rows.
- [ ] **Step 3: Implement the widgets and `scheduleRowTap`** in `schedule_widgets.dart`. Rows are plain `Row`/`Column` (no lists), so the tablet tile keeps an intrinsic height.
- [ ] **Step 4: Analyze** — `flutter analyze lib/features/hub` shows no issues.
- [ ] **Step 5: Commit (when the owner asks)** — `feat(schedule): rows, tap rule and copy`

---

### Task 4: The Schedule screen and route

**Files:**
- Create: `lib/features/hub/schedule_screen.dart`
- Modify: `lib/core/routing/app_router.dart` (`Routes.schedule`, `GoRoute` reading `careerId` like `Routes.injuryCover`), `lib/features/shell/tablet_shell.dart` (`tabletReadyPaths`)
- Test: `test/widget/schedule_screen_test.dart`; modify `test/widget/tablet_route_sweep_test.dart` (add `Routes.schedule: ''`)

**Interfaces:**
- Consumes: Tasks 2 and 3.
- Produces: `class ScheduleScreen extends ConsumerWidget { const ScheduleScreen({required this.careerId, super.key}); static const Key tabletLayoutKey = Key('schedule.tabletLayout'); static const Key todayKey = Key('schedule.today'); }` and `Routes.schedule = '/schedule'` (doc comment "Expects `?careerId=`").

Layout: a `CustomScrollView` whose `center` is the current block's sliver key, so past blocks sit above and the screen opens at today with no post-frame jump. Each block: a month heading (`AppDate.monthYear`), the competition category (`MatchStage.category` of its first fixture), its rows, then its `SchedulePendingRow`. The `todayKey` marker goes immediately before the current block. When `currentIndex == -1`, no marker, `center` is null, and a `l.hubNoMoreFixtures` line follows the last block. Phone: `Scaffold` with an `AppBar` back to the hub (as `InjuryCoverScreen`). Tablet: `TabletPage(scaffoldKey: tabletLayoutKey, title: l.scheduleTitle, ...)` when `TabletShellScope.isActive(context)`.

- [ ] **Step 1: Write the failing widget tests** (use `seedSave` and `pumpRoute` from `test/helpers/seeded_save.dart`)

```dart
testWidgets('opens at today with the first window', (tester) async {
  final save = await seedSave(tester);
  await pumpRoute(tester, save, '${Routes.schedule}?careerId=${save.careerId}');
  expect(find.byKey(ScheduleScreen.todayKey), findsOneWidget);
  expect(find.text(enL.scheduleTitle), findsOneWidget);
  expect(find.byType(ScheduleFixtureRow), findsWidgets);
});
testWidgets('an unwatched draw hides the opponent and the tap', ...);
  // expect find.text(enL.topBarDrawPending) and tapping that row leaves the location unchanged
testWidgets('the next match opens the preview only when it is the next step', ...);
  // with the draw watched and call-ups named so nextEvent is match: tap -> location starts with Routes.matchPreview
  // with a pending call-up event: tap -> location starts with Routes.nationVitrine
testWidgets('tablet uses the TabletPage layout', ...); // formFactor: FormFactor.tablet, size: kTabletSize, find.byKey(ScheduleScreen.tabletLayoutKey)
testWidgets('a finished cycle shows no today marker', ...); // record every cycle fixture, expect todayKey findsNothing and hubNoMoreFixtures
```

- [ ] **Step 2: Run, expect FAIL** — `flutter test test/widget/schedule_screen_test.dart`.
- [ ] **Step 3: Implement** the screen, the route, and `tabletReadyPaths`; add `Routes.schedule: ''` to the sweep map.
- [ ] **Step 4: Run, expect PASS** — the test file above, then `flutter test test/widget/tablet_route_sweep_test.dart` and `flutter test test/widget/tablet_full_screen_sweep_test.dart`.
- [ ] **Step 5: Commit (when the owner asks)** — `feat(schedule): schedule screen, phone and tablet`

---

### Task 5: The Upcoming card on the hub

**Files:**
- Modify: `lib/features/hub/hub_screen.dart` (replace `_NextMatch`, used at about line 379, with `_Upcoming`; delete `_NextMatch` and its `_Side` if unused)
- Modify: `lib/features/hub/hub_tablet_layout.dart` (`_NextMatchPanel`: keep `HubScreen.nextMatchPanelKey`, the champion branch and the Call-ups/Tactics buttons; the two-flag body becomes the current block's rows; title `l.hubUpcoming`; add a `TextButton(l.hubFullSchedule)`)
- Test: create `test/widget/hub_upcoming_test.dart`; update `test/widget/hub_tablet_test.dart` (title list: `enL.hubUpcoming` replaces `enL.hubNextMatch`); update `test/golden/goldens/hub_phone.png`

**Interfaces:**
- Consumes: Tasks 2 to 4.
- Produces: nothing new for other tasks.

`_Upcoming` (a `ConsumerWidget` taking `careerId`) watches `scheduleProvider(careerId)` and `nextEventProvider(careerId)`, and shows `blocks[currentIndex]`: its rows (2 to 4 for a window, one stage for a tournament) plus its pending row, a `l.hubFullSchedule` action pushing `'${Routes.schedule}?careerId=$careerId'`, and `l.hubNoMoreFixtures` when `currentIndex == -1`. The phone keeps its current gate `hub.championNationId == null` but drops the `drawWatched` condition: rows gate themselves. The card takes the place of `_NextMatch` and nothing is added beside it.

- [ ] **Step 1: Write the failing tests**

```dart
testWidgets('the hub lists the current window and opens the schedule', (tester) async {
  final save = await seedSave(tester);
  await pumpRoute(tester, save, '${Routes.hub}?careerId=${save.careerId}');
  expect(find.text(enL.hubUpcoming), findsOneWidget);
  final d = (await save.container.read(scheduleProvider(save.careerId).future))!;
  expect(find.byType(ScheduleFixtureRow), findsNWidgets(d.blocks[d.currentIndex].fixtures.length));
  await tester.tap(find.text(enL.hubFullSchedule));
  await settle(tester);
  expect(find.byType(ScheduleScreen), findsOneWidget);
});
testWidgets('the card moves on after the window is played', ...); // record blocks[0], invalidate hubDataProvider, rows now show blocks[1]
```

- [ ] **Step 2: Run, expect FAIL** — `flutter test test/widget/hub_upcoming_test.dart`.
- [ ] **Step 3: Implement** `_Upcoming` and the tablet panel change.
- [ ] **Step 4: Run, expect PASS**, in order: `flutter test test/widget/hub_upcoming_test.dart`, `flutter test test/widget/hub_tablet_test.dart`, `flutter test test/widget/hub_event_button_test.dart`, then `flutter test --update-goldens test/golden/phone_guard_hub_test.dart`. Open `test/golden/goldens/hub_phone.png` and check that only the card changed.
- [ ] **Step 5: Full suite** — `flutter test`; expected: all pass (last baseline 3,476). `flutter analyze` is clean.
- [ ] **Step 6: Commit (when the owner asks)** — `feat(hub): upcoming window card with a full schedule`

---

## Self-review notes

- Spec coverage. Hub card: Task 5. Schedule month by month: Tasks 1 and 4. Windows as blocks: Task 1. Tournament stages: Task 1. Unknown knockouts with "from" dates: Task 1 pending rows. Empty months omitted: Task 1. Today marker and open at today: Task 4. Scroll up to the past: Task 4 (`center`). Friendlies in their window: Task 1 (own period, as call-ups treat them). Results tab untouched. Saves: no stored state. Tablet sweep: Task 4. Copy: Task 3. Goldens: Task 5.
- Narrowed from the spec, Claude's call: "Draw on date" is shown as `l.topBarDrawPending` without a date. The game stores no draw dates, and tournaments not yet drawn have no fixtures to show, so they are not listed until they exist. Nations Cup gets no pending row.
