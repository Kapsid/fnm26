import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/features/match/pitch/pitch_match_view.dart';
import 'package:fnm/features/match/pitch/pitch_view_providers.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart';
import 'package:fnm/shared/tablet/tablet.dart';

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
      // The line-ups as Timeline mode has them: Your XI a tab away too.
      expect(find.text(enL.matchYourXi), findsOneWidget);
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

  testWidgets('the commentary and the line-ups scroll on their own', (
    tester,
  ) async {
    await _open(tester, MatchViewMode.pitch, kTabletSize);
    await tester.tap(find.byIcon(Icons.pause_rounded));
    await tester.pump();
    final screen = _screen(tester);
    final pb = screen.pitchMode.playback!;
    screen.seekPitch(pb.pacer.total * 0.4);
    await tester.pump();
    final pitch = tester.getRect(find.byType(PitchMatchView));
    Future<double> dragged(Finder list) async {
      final scrollable = find
          .descendant(of: list, matching: find.byType(Scrollable))
          .first;
      await tester.drag(scrollable, const Offset(0, -300));
      await tester.pump();
      return tester.state<ScrollableState>(scrollable).position.pixels;
    }

    expect(
      await dragged(find.byKey(const Key('match.pitchFeed'))),
      greaterThan(0),
    );
    await tester.tap(find.text(enL.matchTabLineups));
    await tester.pumpAndSettle();
    final lineups = find.descendant(
      of: find.byType(TabBarView).last,
      matching: find.byType(ListView),
    );
    expect(await dragged(lineups.last), greaterThan(0));
    expect(tester.getRect(find.byType(PitchMatchView)), pitch);
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
    // The toggle on the bottom bar offers the pitch, and takes the manager
    // there; the stats panel's header no longer carries a switch.
    expect(find.byKey(matchViewSwitchKey), findsNothing);
    final toggle = find.descendant(
      of: find.byType(MatchBarDock),
      matching: find.byType(MatchViewToggle),
    );
    expect(toggle, findsOneWidget);
    await tester.tap(
      find.byKey(MatchViewToggle.segmentKey(MatchViewMode.pitch)),
    );
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

  testWidgets('the line-ups column is the same in Pitch and Timeline mode', (
    tester,
  ) async {
    Future<(Rect, List<String>)> column(MatchViewMode mode) async {
      await _open(tester, mode, kTabletSize);
      await tester.tap(find.text(enL.matchTabLineups));
      await tester.pumpAndSettle();
      final panel = find.ancestor(
        of: find.byType(MatchLineups),
        matching: find.byType(PanelBox),
      );
      final rect = tester.getRect(panel);
      final names = [
        for (final t in tester.widgetList<Text>(
          find.descendant(
            of: find.byType(MatchLineups),
            matching: find.byType(Text),
          ),
        ))
          ?t.data,
      ];
      expect(find.text(enL.matchYourXi), findsOneWidget);
      await tester.tap(find.text(enL.matchYourXi));
      await tester.pumpAndSettle();
      expect(find.byType(TacticsPitch), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      return (rect, names);
    }

    final (timelineRect, timelineNames) = await column(MatchViewMode.timeline);
    final (pitchRect, pitchNames) = await column(MatchViewMode.pitch);
    expect(pitchRect.width, timelineRect.width);
    expect(pitchRect.right, timelineRect.right);
    // The same list: the manager's side's names, in the same order.
    final names = timelineNames.where((n) => n.contains(' ')).take(5);
    expect(pitchNames.where((n) => n.contains(' ')).take(5), names);
  });
}
