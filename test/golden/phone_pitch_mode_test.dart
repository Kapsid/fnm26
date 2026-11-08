import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/features/match/pitch/pitch_match_view.dart';
import 'package:fnm/features/match/pitch/pitch_view_providers.dart';
import 'package:fnm/features/match/score_bug_theme.dart';

import '../helpers/seeded_save.dart';

void main() {
  testWidgets('phone match in Pitch mode', (tester) async {
    final save = await seedSave(tester);
    await tester.runAsync(
      () => const MatchViewModeStore().save(MatchViewMode.pitch),
    );
    final warm = save.container.listen(
      matchPreviewProvider(save.careerId),
      (_, _) {},
    );
    addTearDown(warm.close);
    await tester.runAsync(
      () => save.container.read(matchPreviewProvider(save.careerId).future),
    );
    // The bake shows a spinner until the ground is in: settle waits for it.
    await pumpRoute(tester, save, '${Routes.match}?careerId=${save.careerId}');
    expect(find.byType(PitchMatchView), findsOneWidget);
    expect(find.byType(PitchCommentaryLine), findsOneWidget);
    // Stopped, then on a fixed moment: the 20th minute's first staged one.
    await tester.tap(find.byIcon(Icons.pause_rounded));
    await tester.pump();
    final screen = tester.state(find.byType(MatchScreen)) as MatchScreenProbe;
    final pb = screen.pitchMode.playback!;
    final from = pb.pacer.screenAt(20, 0).inMicroseconds / 1e6;
    final w = pb.script.windows.firstWhere((w) => w.start >= from);
    screen.seekPitch(
      Duration(microseconds: ((w.start + w.end) / 2 * 1e6).round()),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 3)); // any flash clears
    await expectAppGolden('goldens/match_phone_pitch.png');
    await tester.pumpWidget(const SizedBox());
  });

  // Task 15c: the goal banner out from under the score stripe.
  testWidgets('phone match in Pitch mode: the goal banner', (tester) async {
    final save = await seedSave(tester);
    await tester.runAsync(
      () => const MatchViewModeStore().save(MatchViewMode.pitch),
    );
    final warm = save.container.listen(
      matchPreviewProvider(save.careerId),
      (_, _) {},
    );
    addTearDown(warm.close);
    await tester.runAsync(
      () => save.container.read(matchPreviewProvider(save.careerId).future),
    );
    await pumpRoute(tester, save, '${Routes.match}?careerId=${save.careerId}');
    final screen = tester.state(find.byType(MatchScreen)) as MatchScreenProbe;
    final pb = screen.pitchMode.playback!;
    final gi = pb.result.events.indexWhere(
      (e) => e.type == MatchEventType.goal,
    );
    expect(gi, greaterThanOrEqualTo(0), reason: 'a goal to show');
    // Just short of the goal, playing: the flash fires as it goes in.
    screen.seekPitch(
      Duration(microseconds: ((pb.revealAt(gi) - 0.3) * 1e6).round()),
    );
    for (
      var i = 0;
      i < 120 && find.byKey(matchGoalBannerKey).evaluate().isEmpty;
      i++
    ) {
      await tester.pump(const Duration(milliseconds: 16));
    }
    expect(find.byKey(matchGoalBannerKey), findsOneWidget);
    // Fully out.
    await tester.pump(kGoalBannerSlide + const Duration(milliseconds: 50));
    await expectAppGolden('goldens/match_phone_pitch_goal.png');
    await tester.pumpWidget(const SizedBox());
  });

  // The 2D TV bar in a tournament's colours: the seeded save's next match
  // moved into the World Championship finals, then the European
  // Championship's (the seeded nation is European).
  for (final (round, kind, file) in [
    ('FINAL', ScoreBugThemeKind.worldChampionship, 'wc'),
    ('CFINAL', ScoreBugThemeKind.europe, 'europe'),
  ]) {
    testWidgets('phone match in Pitch mode at a finals: $file', (tester) async {
      final save = await seedSave(tester);
      await tester.runAsync(
        () => const MatchViewModeStore().save(MatchViewMode.pitch),
      );
      // The next match, moved into the finals before anything reads it.
      await tester.runAsync(() async {
        final f = await save.container
            .read(competitionRepositoryProvider)
            .nextFixtureForNation(save.careerId, save.nationId);
        await save.container.read(appDatabaseProvider).customStatement(
          'UPDATE fixtures SET round = ? WHERE id = ?',
          [
            round,
            f!.id,
          ],
        );
      });
      final warm = save.container.listen(
        matchPreviewProvider(save.careerId),
        (_, _) {},
      );
      addTearDown(warm.close);
      final p = await tester.runAsync(
        () => save.container.read(matchPreviewProvider(save.careerId).future),
      );
      expect(p?.fixture.round, round);
      await pumpRoute(
        tester,
        save,
        '${Routes.match}?careerId=${save.careerId}',
      );
      final board = tester.widget<MatchScoreboard>(
        find.byType(MatchScoreboard),
      );
      expect(board.bugTheme?.kind, kind);
      await tester.tap(find.byIcon(Icons.pause_rounded));
      await tester.pump();
      final screen = tester.state(find.byType(MatchScreen)) as MatchScreenProbe;
      final pb = screen.pitchMode.playback!;
      final from = pb.pacer.screenAt(20, 0).inMicroseconds / 1e6;
      final w = pb.script.windows.firstWhere((w) => w.start >= from);
      screen.seekPitch(
        Duration(microseconds: ((w.start + w.end) / 2 * 1e6).round()),
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 3)); // any flash clears
      await expectAppGolden('goldens/match_phone_pitch_theme_$file.png');
      await tester.pumpWidget(const SizedBox());
    });
  }
}
