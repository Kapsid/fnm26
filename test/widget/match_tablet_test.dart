import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/seeded_save.dart';

Future<SeededSave> _warm(WidgetTester tester, FormFactor f) async {
  final save = await seedSave(tester, formFactor: f);
  final warm = save.container.listen(
    matchPreviewProvider(save.careerId),
    (_, _) {},
  );
  addTearDown(warm.close);
  await tester.runAsync(
    () => save.container.read(matchPreviewProvider(save.careerId).future),
  );
  return save;
}

void main() {
  testWidgets('three columns and the control bar, full screen', (
    tester,
  ) async {
    final save = await _warm(tester, FormFactor.tablet);
    await pumpRoute(
      tester,
      save,
      '${Routes.match}?careerId=${save.careerId}',
      size: kTabletSize,
    );
    expect(tester.takeException(), isNull);
    expect(find.byKey(MatchScreen.tabletLayoutKey), findsOneWidget);
    expect(find.byType(FullScreenPhoneFrame), findsNothing);
    expect(find.byType(MatchStatsPanel), findsOneWidget);
    expect(find.byType(MatchControlBar), findsOneWidget);
    expect(find.byType(MatchDetailTabs), findsNothing);
    // Stats on the left, the score and the commentary down the centre, the
    // line-ups on the right.
    final score = tester.getRect(find.byType(MatchScoreboard));
    expect(
      tester.getCenter(find.byType(MatchStatsPanel)).dx,
      lessThan(score.left),
    );
    final lineups = tester.getCenter(find.text(enL.matchTabLineups));
    expect(lineups.dx, greaterThan(score.right));
    final timeline = tester.getCenter(
      find.text(enL.matchTabTimeline.toUpperCase()),
    );
    expect(timeline.dx, inExclusiveRange(score.left, score.right));
    expect(timeline.dy, greaterThan(score.bottom));
    // The momentum sits above the score.
    expect(
      tester.getCenter(find.text(enL.matchMomentum.toUpperCase())).dy,
      lessThan(score.top),
    );
    // Both names whole, never their codes.
    final preview = save.container
        .read(matchPreviewProvider(save.careerId))
        .value!;
    for (final id in [
      preview.fixture.homeNationId,
      preview.fixture.awayNationId,
    ]) {
      expect(
        find.descendant(
          of: find.byType(MatchScoreboard),
          matching: find.text(preview.nations[id]!.name),
        ),
        findsOneWidget,
      );
    }
    // The manager's own shape is a tab away, beside the line-ups.
    expect(find.byType(TacticsPitch), findsNothing);
    await tester.tap(find.text(enL.matchYourXi));
    await tester.pumpAndSettle();
    expect(find.byType(TacticsPitch), findsOneWidget);
    expect(
      tester.getCenter(find.byType(TacticsPitch)).dx,
      greaterThan(score.right),
    );
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the tablet scoreboard writes a long name whole in the centre '
      'column at 1024', (tester) async {
    const home = 'Bosnia and Herzegovina';
    const away = 'Saint Vincent and the Grenadines';
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Center(
            child: SizedBox(
              // The centre column at 1024 wide.
              width: 410,
              child: MatchScoreboard(
                homeCode: 'BIH',
                awayCode: 'VIN',
                homeName: home,
                awayName: away,
                homeScore: 2,
                awayScore: 1,
                clock: '67',
                live: true,
                wholeNames: true,
              ),
            ),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.text(home), findsOneWidget);
    expect(find.text(away), findsOneWidget);
    expect(find.text('BIH'), findsNothing);
    expect(find.text('VIN'), findsNothing);
    final style = tester.widget<Text>(find.text(away)).style!;
    // Wrapped, not shrunk to nothing, and both sides at one size.
    expect(style.fontSize, greaterThan(12));
    expect(
      tester.widget<Text>(find.text(home)).style!.fontSize,
      style.fontSize,
    );
  });

  testWidgets('a phone build keeps the phone match even in a tablet-sized '
      'test window (Review Focus 5)', (tester) async {
    final save = await _warm(tester, FormFactor.phone);
    await pumpRoute(
      tester,
      save,
      '${Routes.match}?careerId=${save.careerId}',
      size: const Size(800, 600),
    );
    expect(find.byKey(MatchScreen.tabletLayoutKey), findsNothing);
    expect(find.byType(MatchDetailTabs), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}
