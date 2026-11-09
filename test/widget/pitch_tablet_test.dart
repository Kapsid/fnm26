import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/features/match/ground_card.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/features/match/pitch/pitch_match_view.dart';
import 'package:fnm/features/match/pitch/pitch_view_providers.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/whole_text.dart' show initialledName;

import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/seeded_save.dart';

/// The tablet match screen in Pitch mode: the TV down the centre (the
/// broadcast header with the ground in it, the momentum under it, then the
/// big pitch), the stats on the left, the commentary and Your XI on the
/// right. Nothing is drawn over the picture: every moment takes the
/// header's strip in its turn.

Future<SeededSave> _open(
  WidgetTester tester,
  MatchViewMode? mode,
  Size size, {
  Locale locale = const Locale('en'),
}) async {
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
    locale: locale,
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
      // The picture is the big thing in the middle, under the TV's
      // broadcast header (which stands for the scoreboard) and the
      // momentum, all three as wide as each other, at the column's top.
      final pitch = tester.getRect(find.byType(PitchMatchView));
      expect(find.byType(MatchScoreboard), findsNothing);
      final header = tester.getRect(find.byType(MatchTvHeader));
      final momentum = tester.getRect(
        find
            .ancestor(
              of: find.text(enL.matchMomentum.toUpperCase()),
              matching: find.byType(ColoredBox),
            )
            .first,
      );
      expect(momentum.top, closeTo(header.bottom, 0.5));
      expect(pitch.top, closeTo(momentum.bottom, 0.5));
      expect(pitch.width, closeTo(header.width, 0.5));
      expect(momentum.width, closeTo(header.width, 0.5));
      expect(pitch.width, greaterThan(size.width * 0.4));
      // Whole: nothing of it under the bar.
      expect(
        pitch.bottom,
        lessThanOrEqualTo(tester.getRect(find.byType(MatchBarDock)).top),
      );
      // Top-aligned with the side columns.
      final stats = tester.getRect(
        find.ancestor(
          of: find.byType(MatchStatsPanel),
          matching: find.byType(Panel),
        ),
      );
      expect(header.top, closeTo(stats.top, 0.5));
      // The ground is in the header now, not over the stats.
      expect(
        find.descendant(
          of: find.byType(MatchTvHeader),
          matching: find.byKey(GroundStrip.stripKey),
        ),
        findsOneWidget,
      );
      expect(find.byType(GroundCard), findsNothing);
      // Stats on the left, the feed and Your XI on the right.
      expect(
        tester.getCenter(find.byType(MatchStatsPanel)).dx,
        lessThan(pitch.left),
      );
      expect(
        tester.getCenter(find.byType(PitchCommentaryFeed)).dx,
        greaterThan(pitch.right),
      );
      expect(find.text(enL.matchTabCommentary), findsOneWidget);
      expect(find.text(enL.matchTabLineups), findsNothing);
      expect(find.text(enL.matchYourXi), findsOneWidget);
      // The phone's one-line commentary is not used here.
      expect(find.byType(PitchCommentaryLine), findsNothing);
      await tester.pumpWidget(const SizedBox());
    });
  }

  // The 2D TV's broadcast dress: the header over the picture, a goal on its
  // strip for the goal's pause and the other moments after it in their
  // turn, nothing drawn over the picture, none of it overflowing, in a short
  // language and a long one.
  for (final size in const [Size(1366, 1024), Size(1180, 820)]) {
    for (final lang in const ['en', 'de']) {
      testWidgets('the 2D TV header and its moment strip fit at '
          '${size.width.toInt()}x${size.height.toInt()} ($lang)', (
        tester,
      ) async {
        await _open(
          tester,
          MatchViewMode.pitch,
          size,
          locale: Locale(lang),
        );
        await tester.tap(find.byIcon(Icons.pause_rounded));
        await tester.pump();
        final screen = _screen(tester);
        final pb = screen.pitchMode.playback!;
        final r = screen.result!;
        final header = find.byKey(matchTvHeaderKey);
        expect(header, findsOneWidget);
        final strip = find.descendant(
          of: header,
          matching: find.byKey(matchTvEventStripKey),
        );
        expect(strip, findsNothing);
        // The first goal goes in: its strip, in the header.
        final gi = r.events.indexWhere((e) => e.type == MatchEventType.goal);
        expect(gi, isNonNegative, reason: 'the seeded match has a goal');
        final goal = r.events[gi];
        screen.seekPitch(
          Duration(microseconds: ((pb.revealAt(gi) + 0.05) * 1e6).round()),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 600));
        expect(tester.takeException(), isNull);
        expect(strip, findsOneWidget);
        expect(
          find.descendant(of: strip, matching: find.text(initialledName(goal.playerName))),
          findsOneWidget,
        );
        final pitch = tester.getRect(find.byType(PitchMatchView));
        expect(tester.getRect(strip).bottom, lessThan(pitch.top));
        // Nothing over the picture but the game.
        final over = find.descendant(
          of: find.ancestor(
            of: find.byType(PitchMatchView),
            matching: find.byType(AspectRatio),
          ),
          matching: find.byType(Positioned),
        );
        expect(over, findsNothing);
        // The goal's pause over, the strip is the figures again (or the
        // next moment's, each gone in its turn).
        await tester.pump(kGoalFlashHold);
        await tester.pump(const Duration(milliseconds: 300));
        expect(
          find.descendant(of: strip, matching: find.text(initialledName(goal.playerName))),
          findsNothing,
        );
        for (var i = 0; i < kTvEventQueueMax + 1; i++) {
          await tester.pump(kTvEventHold);
          await tester.pump(const Duration(milliseconds: 300));
        }
        expect(strip, findsNothing);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      });
    }
  }

  testWidgets('a card or a substitution takes the strip in its turn', (
    tester,
  ) async {
    await _open(tester, MatchViewMode.pitch, const Size(1180, 820));
    await tester.tap(find.byIcon(Icons.pause_rounded));
    await tester.pump();
    final screen = _screen(tester);
    final pb = screen.pitchMode.playback!;
    final r = screen.result!;
    final ei = r.events.indexWhere(
      (e) =>
          e.type == MatchEventType.substitution ||
          e.type == MatchEventType.yellowCard,
    );
    expect(ei, isNonNegative, reason: 'the seeded match has a sub or a card');
    final e = r.events[ei];
    // Just before it, and the moments so far through the strip first.
    screen.seekPitch(
      Duration(microseconds: ((pb.revealAt(ei) - 0.3) * 1e6).round()),
    );
    await tester.pump();
    for (var i = 0; i < kTvEventQueueMax + 2; i++) {
      await tester.pump(kTvEventHold);
      await tester.pump(const Duration(milliseconds: 300));
    }
    screen.seekPitch(
      Duration(microseconds: ((pb.revealAt(ei) + 0.05) * 1e6).round()),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    final strip = find.descendant(
      of: find.byKey(matchTvHeaderKey),
      matching: find.byKey(matchTvEventStripKey),
    );
    expect(strip, findsOneWidget);
    expect(
      find.descendant(
        of: strip,
        matching: find.textContaining(surnameOf(e.playerName)),
      ),
      findsWidgets,
    );
    for (var i = 0; i < kTvEventQueueMax + 2; i++) {
      await tester.pump(kTvEventHold);
      await tester.pump(const Duration(milliseconds: 300));
    }
    expect(strip, findsNothing);
    await tester.pumpWidget(const SizedBox());
  });

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

  testWidgets('the right column is as wide in Pitch and Timeline mode, Your '
      'XI in both', (tester) async {
    Future<Rect> column(MatchViewMode mode) async {
      await _open(tester, mode, kTabletSize);
      // Held still: settling with the match running would play it on to
      // half time, whose card covers the column.
      await tester.tap(find.byIcon(Icons.pause_rounded));
      await tester.pump();
      expect(find.text(enL.matchYourXi), findsOneWidget);
      await tester.tap(find.text(enL.matchYourXi));
      await tester.pumpAndSettle();
      expect(find.byType(TacticsPitch), findsOneWidget);
      final rect = tester.getRect(
        find.ancestor(
          of: find.byType(TacticsPitch),
          matching: find.byType(PanelBox),
        ),
      );
      await tester.pumpWidget(const SizedBox());
      return rect;
    }

    final timelineRect = await column(MatchViewMode.timeline);
    final pitchRect = await column(MatchViewMode.pitch);
    expect(pitchRect.width, timelineRect.width);
    expect(pitchRect.right, timelineRect.right);
  });
}
