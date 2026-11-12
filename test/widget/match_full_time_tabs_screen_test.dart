import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/match/full_time_tabs.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/features/match/pitch/pitch_view_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/expect_whole.dart';
import '../helpers/seeded_save.dart';

/// The match screen's Player and Stadium tabs: there only once the match is
/// over, on a phone (both views) and on a tablet.

Future<SeededSave> _open(
  WidgetTester tester,
  FormFactor f,
  MatchViewMode mode,
  Size size,
) async {
  final save = await seedSave(tester, formFactor: f);
  await tester.runAsync(() => const MatchViewModeStore().save(mode));
  final warm = save.container.listen(
    matchPreviewProvider(save.careerId),
    (_, _) {},
  );
  addTearDown(warm.close);
  await tester.runAsync(
    () => save.container.read(matchPreviewProvider(save.careerId).future),
  );
  await pumpRoute(
    tester,
    save,
    '${Routes.match}?careerId=${save.careerId}',
    size: size,
  );
  return save;
}

final Finder _continue = find.byWidgetPredicate(
  (w) => w is PrimaryButton && w.label == enL.matchContinue,
);

/// Plays a Pitch-mode match to its final whistle.
Future<void> _toFullTime(WidgetTester tester) async {
  final screen = tester.state(find.byType(MatchScreen)) as MatchScreenProbe;
  final half = find.descendant(
    of: find.byType(HalfTimePrompt),
    matching: find.text(enL.matchContinue),
  );
  final pb = screen.pitchMode.playback!;
  screen.seekPitch(pb.halfTime - const Duration(milliseconds: 100));
  for (var i = 0; i < 400 && half.evaluate().isEmpty; i++) {
    await tester.pump(const Duration(milliseconds: 16));
  }
  await tester.tap(half);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
  screen.seekPitch(pb.pacer.total - const Duration(milliseconds: 200));
  for (var i = 0; i < 400 && _continue.evaluate().isEmpty; i++) {
    await tester.pump(const Duration(milliseconds: 16));
  }
  await tester.pump(const Duration(seconds: 3));
}

/// Waits for the Pitch view to be built and its clock running.
Future<void> _awaitPitch(WidgetTester tester) async {
  for (
    var i = 0;
    i < 200 &&
        (tester.state(find.byType(MatchScreen)) as MatchScreenProbe)
                .pitchMode
                .playback ==
            null;
    i++
  ) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pump(const Duration(milliseconds: 16));
  }
}

int _phoneTabs(WidgetTester tester) => find
    .descendant(
      of: find.byType(MatchDetailTabs),
      matching: find.byType(AppTabSegment),
    )
    .evaluate()
    .length;

/// The index of the tab controller around [of].
int _tabIndex(WidgetTester tester, Finder of) =>
    DefaultTabController.of(tester.element(of)).index;

/// The Summary on screen names the man of the match and the ground with its
/// crowd; a tap on his card opens the Player tab, one on the ground the
/// Stadium tab.
Future<void> _checkSummary(
  WidgetTester tester,
  SeededSave save, {
  required int playerTab,
}) async {
  final motm = _probe(tester).result!.manOfTheMatch!;
  final preview = save.container
      .read(matchPreviewProvider(save.careerId))
      .value!;
  // The tab is short under the phone's pitch: scrolled to each card.
  final list = find.descendant(
    of: find.byType(MatchSummaryTab),
    matching: find.byType(Scrollable),
  );
  await tester.scrollUntilVisible(
    find.byKey(MatchSummaryTab.potmKey),
    80,
    scrollable: list.first,
  );
  expect(
    find.descendant(
      of: find.byKey(MatchSummaryTab.potmKey),
      matching: find.text(motm.playerName),
    ),
    findsOneWidget,
  );
  await tester.scrollUntilVisible(
    find.byKey(MatchSummaryTab.attendanceKey),
    80,
    scrollable: list.first,
  );
  expect(find.byKey(MatchSummaryTab.attendanceKey), findsOneWidget);
  expect(
    find.descendant(
      of: find.byKey(MatchSummaryTab.stadiumKey),
      matching: find.text(preview.ground.stadium),
    ),
    findsOneWidget,
  );
  await tester.scrollUntilVisible(
    find.byKey(MatchSummaryTab.potmKey),
    -80,
    scrollable: list.first,
  );
  final summary = find.byType(MatchSummaryTab);
  await tester.tap(find.byKey(MatchSummaryTab.potmKey));
  await tester.pumpAndSettle(const Duration(milliseconds: 100));
  expect(_tabIndex(tester, find.byType(PlayerOfMatchTab)), playerTab);
  expect(find.byType(PlayerOfMatchTab), findsOneWidget);
  // Back to the Summary, then its ground, brought to the top of the tab.
  DefaultTabController.of(
    tester.element(find.byType(PlayerOfMatchTab)),
  ).animateTo(0);
  await tester.pumpAndSettle(const Duration(milliseconds: 100));
  final stadium = find.byKey(MatchSummaryTab.stadiumKey);
  await tester.scrollUntilVisible(
    stadium,
    80,
    scrollable: find
        .descendant(
          of: find.byType(MatchSummaryTab),
          matching: find.byType(Scrollable),
        )
        .first,
  );
  await tester.ensureVisible(stadium);
  await tester.pumpAndSettle(const Duration(milliseconds: 100));
  await tester.tapAt(tester.getTopLeft(stadium) + const Offset(24, 24));
  await tester.pumpAndSettle(const Duration(milliseconds: 100));
  expect(find.byType(MatchStadiumTab), findsOneWidget);
  expect(_tabIndex(tester, find.byType(MatchStadiumTab)), playerTab + 1);
  expect(summary, findsNothing);
  expect(tester.takeException(), isNull);
}

MatchScreenProbe _probe(WidgetTester tester) =>
    tester.state(find.byType(MatchScreen)) as MatchScreenProbe;

/// Opens the Player tab and checks it names the probe's man of the match,
/// then the Stadium tab and its ground.
Future<void> _checkTabs(WidgetTester tester, SeededSave save) async {
  await tester.tap(find.text(enL.matchTabPlayer));
  await tester.pumpAndSettle(const Duration(milliseconds: 100));
  expect(find.byType(PlayerOfMatchTab), findsOneWidget);
  final motm = _probe(tester).result!.manOfTheMatch!;
  expect(
    find.descendant(
      of: find.byKey(PlayerOfMatchTab.headerKey),
      matching: find.text(motm.playerName),
    ),
    findsOneWidget,
  );
  await tester.tap(find.text(enL.matchTabStadium));
  await tester.pumpAndSettle(const Duration(milliseconds: 100));
  final preview = save.container
      .read(matchPreviewProvider(save.careerId))
      .value!;
  expect(find.byType(MatchStadiumTab), findsOneWidget);
  expect(find.text(preview.ground.stadium), findsWidgets);
  expect(find.byKey(MatchStadiumTab.capacityKey), findsOneWidget);
  expect(find.byKey(MatchStadiumTab.attendanceKey), findsOneWidget);
  expect(tester.takeException(), isNull);
}

void main() {
  testWidgets('phone: Player and Stadium join the tabs at full time, in '
      'Pitch mode and on the Timeline', (tester) async {
    final save = await _open(
      tester,
      FormFactor.phone,
      MatchViewMode.pitch,
      kPhoneSize,
    );
    await _awaitPitch(tester);
    // Pitch mode opens on its Summary from kick-off: the ground, no man of
    // the match yet.
    expect(_phoneTabs(tester), 3);
    expect(_tabIndex(tester, find.byType(MatchDetailTabs)), 0);
    expect(find.byType(MatchSummaryTab), findsOneWidget);
    expect(find.byKey(MatchSummaryTab.stadiumKey), findsOneWidget);
    expect(find.byKey(MatchSummaryTab.potmKey), findsNothing);
    expect(find.text(enL.matchTabPlayer), findsNothing);
    expect(find.text(enL.matchTabStadium), findsNothing);
    await _toFullTime(tester);
    expect(tester.takeException(), isNull);
    expect(_phoneTabs(tester), 5);
    // At the whistle it lands on the Summary again, the man of the match
    // on it.
    expect(_tabIndex(tester, find.byType(MatchDetailTabs)), 0);
    expect(find.byKey(MatchSummaryTab.potmKey), findsOneWidget);
    // Five labels, each whole on one line: shared out or scrolling, never
    // cut or scaled.
    for (final label in [
      enL.matchTabSummary,
      enL.matchTabStats,
      enL.matchTabLineups,
      enL.matchTabPlayer,
      enL.matchTabStadium,
    ]) {
      expectWhole(
        find.descendant(
          of: find.byType(MatchDetailTabs),
          matching: find.text(label),
        ),
        'the "$label" tab',
      );
    }
    await _checkSummary(tester, save, playerTab: 3);
    await _checkTabs(tester, save);

    // On the Timeline at full time: five, opening on Stats, no Summary.
    await tester.tap(
      find.byKey(MatchViewToggle.segmentKey(MatchViewMode.timeline)),
    );
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    expect(_phoneTabs(tester), 5);
    expect(find.text(enL.matchTabSummary), findsNothing);
    expect(
      DefaultTabController.of(
        tester.element(find.byType(MatchDetailTabs)),
      ).index,
      1,
    );
    await _checkTabs(tester, save);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('phone Timeline: three tabs while the match plays', (
    tester,
  ) async {
    await _open(tester, FormFactor.phone, MatchViewMode.timeline, kPhoneSize);
    expect(_phoneTabs(tester), 3);
    expect(find.byType(MatchSummaryTab), findsNothing);
    expect(find.byType(PlayerOfMatchTab), findsNothing);
    expect(find.text(enL.matchTabStadium), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('tablet: the two tabs beside the stats at full time', (
    tester,
  ) async {
    final save = await _open(
      tester,
      FormFactor.tablet,
      MatchViewMode.pitch,
      const Size(1180, 820),
    );
    await _awaitPitch(tester);
    // The TV's left column opens on the Summary from kick-off.
    expect(find.byType(MatchTvHeader), findsOneWidget);
    expect(find.byType(MatchSummaryTab), findsOneWidget);
    expect(_tabIndex(tester, find.byType(MatchSummaryTab)), 0);
    expect(find.byKey(MatchSummaryTab.potmKey), findsNothing);
    expect(find.text(enL.matchTabPlayer), findsNothing);
    expect(find.text(enL.matchTabStadium), findsNothing);
    await _toFullTime(tester);
    expect(tester.takeException(), isNull);
    expect(_tabIndex(tester, find.byType(MatchSummaryTab)), 0);
    // In the left column, beside Stats, every label whole: four share the
    // column or the strip scrolls, never into the TV.
    final tv = tester.getRect(find.byType(MatchTvHeader));
    for (final label in [
      enL.matchTabSummary,
      enL.matchTabStats,
      enL.matchTabPlayer,
      enL.matchTabStadium,
    ]) {
      await tester.ensureVisible(find.text(label));
      await tester.pumpAndSettle(const Duration(milliseconds: 100));
      expectWhole(find.text(label), 'the "$label" tab');
      final r = tester.getRect(find.text(label));
      expect(r.right, lessThan(tv.left), reason: label);
    }
    // (Still on the Summary: a strip scrolled is no tab changed.)
    expect(_tabIndex(tester, find.byType(MatchSummaryTab)), 0);
    await _checkSummary(tester, save, playerTab: 2);
    await _checkTabs(tester, save);
    // The right column keeps its commentary and line-ups.
    expect(find.text(enL.matchTabCommentary), findsOneWidget);

    // And on the Timeline, the same.
    await tester.tap(
      find.byKey(MatchViewToggle.segmentKey(MatchViewMode.timeline)),
    );
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    expect(find.byType(MatchSummaryTab), findsNothing);
    final score = tester.getRect(find.byType(MatchScoreboard));
    expect(
      tester.getRect(find.text(enL.matchTabStadium)).right,
      lessThan(score.left),
    );
    await _checkTabs(tester, save);
    await tester.pumpWidget(const SizedBox());
  });
}
