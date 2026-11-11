import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/match/full_time_tabs.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/features/match/pitch/pitch_view_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';

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
    .descendant(of: find.byType(MatchDetailTabs), matching: find.byType(Tab))
    .evaluate()
    .length;

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
    expect(_phoneTabs(tester), 2);
    expect(find.text(enL.matchTabPlayer), findsNothing);
    expect(find.text(enL.matchTabStadium), findsNothing);
    await _toFullTime(tester);
    expect(tester.takeException(), isNull);
    expect(_phoneTabs(tester), 4);
    final bar = tester.widget<TabBar>(
      find.descendant(
        of: find.byType(MatchDetailTabs),
        matching: find.byType(TabBar),
      ),
    );
    expect(bar.isScrollable, isTrue);
    await _checkTabs(tester, save);

    // On the Timeline at full time: five, opening on Stats.
    await tester.tap(
      find.byKey(MatchViewToggle.segmentKey(MatchViewMode.timeline)),
    );
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    expect(_phoneTabs(tester), 5);
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
    expect(find.text(enL.matchTabPlayer), findsNothing);
    expect(find.text(enL.matchTabStadium), findsNothing);
    await _toFullTime(tester);
    expect(tester.takeException(), isNull);
    // In the left column, beside Stats, every label whole on screen.
    final tv = tester.getRect(find.byType(MatchTvHeader));
    for (final label in [
      enL.matchTabStats,
      enL.matchTabPlayer,
      enL.matchTabStadium,
    ]) {
      final r = tester.getRect(find.text(label));
      expect(r.right, lessThan(tv.left), reason: label);
    }
    await _checkTabs(tester, save);
    // The right column keeps its commentary and line-ups.
    expect(find.text(enL.matchTabCommentary), findsOneWidget);

    // And on the Timeline, the same.
    await tester.tap(
      find.byKey(MatchViewToggle.segmentKey(MatchViewMode.timeline)),
    );
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    final score = tester.getRect(find.byType(MatchScoreboard));
    expect(
      tester.getRect(find.text(enL.matchTabStadium)).right,
      lessThan(score.left),
    );
    await _checkTabs(tester, save);
    await tester.pumpWidget(const SizedBox());
  });
}
