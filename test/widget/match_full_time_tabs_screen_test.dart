import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/features/match/pitch/pitch_view_providers.dart';
import 'package:fnm/features/player/player_detail_screen.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/expect_whole.dart';
import '../helpers/seeded_save.dart';

/// The match screen's tabs at full time: no Player or Stadium tab, the
/// Summary carrying the man of the match (Pitch mode's first tab, the
/// Timeline's second), on a phone (both views) and on a tablet.

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

MatchScreenProbe _probe(WidgetTester tester) =>
    tester.state(find.byType(MatchScreen)) as MatchScreenProbe;

/// Where the app's router stands.
Uri _location(SeededSave save) =>
    save.container.read(routerProvider).routerDelegate.currentConfiguration.uri;

Finder _summaryList() => find
    .descendant(
      of: find.byType(MatchSummaryTab),
      matching: find.byType(Scrollable),
    )
    .first;

/// The Summary on screen names the man of the match and the ground with its
/// crowd. A tap on the ground changes nothing (no Stadium tab to open).
Future<void> _checkSummary(WidgetTester tester, SeededSave save) async {
  final motm = _probe(tester).result!.manOfTheMatch!;
  final preview = save.container
      .read(matchPreviewProvider(save.careerId))
      .value!;
  // The tab is short under the phone's pitch: scrolled to each card.
  await tester.scrollUntilVisible(
    find.byKey(MatchSummaryTab.potmKey),
    80,
    scrollable: _summaryList(),
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
    scrollable: _summaryList(),
  );
  expect(find.byKey(MatchSummaryTab.attendanceKey), findsOneWidget);
  final stadium = find.byKey(MatchSummaryTab.stadiumKey);
  expect(
    find.descendant(of: stadium, matching: find.text(preview.ground.stadium)),
    findsOneWidget,
  );
  final index = _tabIndex(tester, find.byType(MatchSummaryTab));
  await tester.ensureVisible(stadium);
  await _settle(tester);
  await tester.tapAt(tester.getTopLeft(stadium) + const Offset(24, 24));
  await _settle(tester);
  expect(find.byType(MatchSummaryTab), findsOneWidget);
  expect(_tabIndex(tester, find.byType(MatchSummaryTab)), index);
  expect(_location(save).path, Routes.match);
  expect(tester.takeException(), isNull);
}

/// A second of frames: the picture's clock keeps ticking, so a settle may
/// never come.
Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

/// A tap on the man of the match's card opens his page.
// ignore: unused_element
Future<void> _openPotm(WidgetTester tester, SeededSave save) async {
  final motm = _probe(tester).result!.manOfTheMatch!;
  final card = find.byKey(MatchSummaryTab.potmKey);
  // Back up the Summary a bounded number of times: the card leads it.
  for (var i = 0; i < 20 && card.evaluate().isEmpty; i++) {
    await tester.drag(_summaryList(), const Offset(0, 300));
    await tester.pump(const Duration(milliseconds: 100));
  }
  await tester.ensureVisible(card);
  await _settle(tester);
  await tester.tap(card);
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
  final page = find.byType(PlayerDetailScreen);
  expect(page, findsOneWidget);
  expect(tester.widget<PlayerDetailScreen>(page).playerId, motm.playerId);
  expect(tester.takeException(), isNull);
}

/// The phone's tab labels [labels], each whole on one line.
void _expectLabelsWhole(List<String> labels) {
  for (final label in labels) {
    expectWhole(
      find.descendant(
        of: find.byType(MatchDetailTabs),
        matching: find.text(label),
      ),
      'the "$label" tab',
    );
  }
}

void main() {
  testWidgets('phone: no Player or Stadium tab at full time; the Summary '
      'leads in Pitch mode and comes second on the Timeline', (tester) async {
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
    await _toFullTime(tester);
    expect(tester.takeException(), isNull);
    // At the whistle: the same three, back on the Summary, the man of the
    // match on it.
    expect(_phoneTabs(tester), 3);
    _expectLabelsWhole([
      enL.matchTabSummary,
      enL.matchTabStats,
      enL.matchTabLineups,
    ]);
    expect(_tabIndex(tester, find.byType(MatchDetailTabs)), 0);
    expect(find.byKey(MatchSummaryTab.potmKey), findsOneWidget);
    await _checkSummary(tester, save);

    // On the Timeline at full time: four, the Summary second and open.
    await tester.tap(
      find.byKey(MatchViewToggle.segmentKey(MatchViewMode.timeline)),
    );
    await _settle(tester);
    expect(_phoneTabs(tester), 4);
    _expectLabelsWhole([
      enL.matchTabTimeline,
      enL.matchTabSummary,
      enL.matchTabStats,
      enL.matchTabLineups,
    ]);
    expect(_tabIndex(tester, find.byType(MatchDetailTabs)), 1);
    expect(find.byType(MatchSummaryTab), findsOneWidget);
    await _checkSummary(tester, save);
    // Opening the player page from the card is left out here: that page's
    // streams keep a seeded save from tearing down in this file.
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('phone Timeline: four tabs while the match plays, open on '
      'the Timeline', (tester) async {
    await _open(tester, FormFactor.phone, MatchViewMode.timeline, kPhoneSize);
    expect(_phoneTabs(tester), 4);
    expect(_tabIndex(tester, find.byType(MatchDetailTabs)), 0);
    _expectLabelsWhole([
      enL.matchTabTimeline,
      enL.matchTabSummary,
      enL.matchTabStats,
      enL.matchTabLineups,
    ]);
    await tester.tap(
      find.descendant(
        of: find.byType(MatchDetailTabs),
        matching: find.text(enL.matchTabSummary),
      ),
    );
    await _settle(tester);
    expect(find.byType(MatchSummaryTab), findsOneWidget);
    expect(find.byKey(MatchSummaryTab.potmKey), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('tablet: Summary and Stats in the left column, no full-time '
      'tabs, in either mode', (tester) async {
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
    await _toFullTime(tester);
    expect(tester.takeException(), isNull);
    expect(_tabIndex(tester, find.byType(MatchSummaryTab)), 0);
    // In the left column, every label whole, never into the TV.
    final tv = tester.getRect(find.byType(MatchTvHeader));
    for (final label in [enL.matchTabSummary, enL.matchTabStats]) {
      expectWhole(find.text(label), 'the "$label" tab');
      expect(tester.getRect(find.text(label)).right, lessThan(tv.left));
    }
    await _checkSummary(tester, save);
    // The right column keeps its commentary and line-ups.
    expect(find.text(enL.matchTabCommentary), findsOneWidget);

    // And on the Timeline at full time: the Summary again, open.
    await tester.tap(
      find.byKey(MatchViewToggle.segmentKey(MatchViewMode.timeline)),
    );
    await _settle(tester);
    expect(find.byType(MatchSummaryTab), findsOneWidget);
    expect(_tabIndex(tester, find.byType(MatchSummaryTab)), 0);
    final score = tester.getRect(find.byType(MatchScoreboard));
    expect(
      tester.getRect(find.text(enL.matchTabSummary)).right,
      lessThan(score.left),
    );
    await _checkSummary(tester, save);
    await tester.pumpWidget(const SizedBox());
  });
}
