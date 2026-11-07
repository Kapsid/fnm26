import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/features/match/pitch/pitch_match_view.dart';
import 'package:fnm/features/match/pitch/pitch_view_providers.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/seeded_save.dart';

/// The tablet match screen in Pitch mode: the big pitch down the centre, the
/// stats and the momentum on the left, the commentary and the line-ups on
/// the right.

Future<SeededSave> _open(
  WidgetTester tester,
  MatchViewMode? mode,
  Size size,
) async {
  final save = await seedSave(tester, formFactor: FormFactor.tablet);
  // seedSave stores Timeline; a manager who never chose has nothing stored.
  if (mode == null) SharedPreferences.setMockInitialValues(<String, Object>{});
  await tester.runAsync(
    () => mode == null
        ? const MatchViewModeStore().load()
        : const MatchViewModeStore().save(mode),
  );
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

MatchScreenProbe _screen(WidgetTester tester) =>
    tester.state(find.byType(MatchScreen)) as MatchScreenProbe;

void main() {
  for (final size in kTabletSizes) {
    testWidgets('tablet renders in Pitch mode without overflow at '
        '${size.width.toInt()}x${size.height.toInt()}', (tester) async {
      await _open(tester, MatchViewMode.pitch, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(MatchScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PitchMatchView), findsOneWidget);
      expect(find.byType(PitchCommentaryFeed), findsOneWidget);
      // The picture is the big thing in the middle.
      final pitch = tester.getRect(find.byType(PitchMatchView));
      final score = tester.getRect(find.byType(MatchScoreboard));
      expect(pitch.top, greaterThanOrEqualTo(score.bottom));
      expect(pitch.width, greaterThan(size.width * 0.4));
      // Stats and momentum on the left, the feed and line-ups on the right.
      expect(
        tester.getCenter(find.byType(MatchStatsPanel)).dx,
        lessThan(pitch.left),
      );
      expect(
        tester.getCenter(find.byType(PitchCommentaryFeed)).dx,
        greaterThan(pitch.right),
      );
      expect(
        tester.getCenter(find.text(enL.matchMomentum.toUpperCase())).dx,
        lessThan(pitch.left),
      );
      expect(find.text(enL.matchTabCommentary), findsOneWidget);
      expect(find.text(enL.matchTabLineups), findsOneWidget);
      // The phone's one-line commentary is not used here.
      expect(find.byType(PitchCommentaryLine), findsNothing);
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('commentary feed lists lines in order, newest first', (
    tester,
  ) async {
    final save = await _open(tester, MatchViewMode.pitch, kTabletSize);
    // A first attempt plays from the fixture's own seed (salt 0).
    final seed = save.container
        .read(matchPreviewProvider(save.careerId))
        .value!
        .saveSeed;
    await tester.tap(find.byIcon(Icons.pause_rounded));
    await tester.pump();
    final screen = _screen(tester);
    final pb = screen.pitchMode.playback!;
    // Early on there is nothing to say yet.
    expect(find.byKey(const Key('match.pitchFeed')), findsNothing);
    // To the end of the first half: every line said by then.
    final t = pb.halfTime;
    screen.seekPitch(t);
    await tester.pump();
    final l = enL;
    final said = pb.linesUpTo(l, t, screen.pitchMode.names, seed);
    expect(pb.lineCountAt(t), said.length);
    final shown = <String>[
      for (final w in tester.widgetList<Text>(
        find.descendant(
          of: find.byKey(const Key('match.pitchFeed')),
          matching: find.byType(Text),
        ),
      ))
        w.data!,
    ];
    // A lazy list: what fits on screen is built.
    expect(shown.length, greaterThan(1));
    // The feed is the lines in the order they came, read back to front.
    expect(shown, said.reversed.take(shown.length).toList());
    // And a later moment only ever adds to the top.
    final later = pb.halfTime + const Duration(minutes: 2);
    screen.seekPitch(later);
    await tester.pump();
    final after = pb.linesUpTo(l, later, screen.pitchMode.names, seed);
    expect(after.take(said.length), said);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('Timeline mode on a tablet keeps its three columns', (
    tester,
  ) async {
    await _open(tester, MatchViewMode.timeline, kTabletSize);
    expect(tester.takeException(), isNull);
    expect(find.byType(PitchMatchView), findsNothing);
    expect(find.byType(PitchCommentaryFeed), findsNothing);
    expect(find.text(enL.matchTabTimeline.toUpperCase()), findsOneWidget);
    expect(find.text(enL.matchYourXi), findsOneWidget);
    // The switch to the pitch is on offer, and takes the manager there.
    await tester.tap(find.byKey(matchViewSwitchKey));
    await tester.pump();
    for (
      var i = 0;
      i < 100 && find.byType(PitchMatchView).evaluate().isEmpty;
      i++
    ) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pump(const Duration(milliseconds: 16));
    }
    expect(find.byType(PitchMatchView), findsOneWidget);
    expect(find.text(enL.matchTabTimeline.toUpperCase()), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a tablet that never chose is asked, and Pitch lands in the '
      'pitch layout', (tester) async {
    await _open(tester, null, kTabletSize);
    expect(tester.takeException(), isNull);
    expect(find.byKey(MatchScreen.tabletLayoutKey), findsOneWidget);
    expect(find.byType(MatchViewChooser), findsOneWidget);
    expect(find.byType(PitchMatchView), findsNothing);
    await tester.tap(find.byKey(MatchViewChooser.pitchKey));
    await tester.pump();
    for (
      var i = 0;
      i < 100 && find.byType(PitchMatchView).evaluate().isEmpty;
      i++
    ) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pump(const Duration(milliseconds: 16));
    }
    expect(find.byType(MatchViewChooser), findsNothing);
    expect(find.byType(PitchMatchView), findsOneWidget);
    expect(find.byType(PitchCommentaryFeed), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}
