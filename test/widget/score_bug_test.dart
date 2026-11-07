import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// The phone's Pitch mode score bug: one bar, the clock's stoppage set
/// apart, and on a goal a banner that slides out from under it (shown at
/// once when the platform asks for reduced motion).
void main() {
  const goal = MatchEvent(
    minute: 90,
    stoppage: 3,
    type: MatchEventType.goal,
    teamNationId: 1,
    playerId: 7,
    playerName: 'Jan Novak',
  );

  Future<void> pump(
    WidgetTester tester, {
    MatchEvent? event,
    bool still = false,
    String locale = 'en',
  }) async {
    tester.view
      ..physicalSize = const Size(320, 400)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme,
        locale: Locale(locale),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MediaQuery(
          data: MediaQueryData(
            size: const Size(320, 400),
            disableAnimations: still,
          ),
          child: Scaffold(
            body: MatchScoreboard(
              homeCode: 'CZE',
              awayCode: 'POR',
              homeName: 'Czechia',
              awayName: 'Portugal',
              homeScore: 2,
              awayScore: 1,
              clock: '90+3',
              live: true,
              compact: true,
              homeColor: Colors.red,
              awayColor: Colors.green,
              goal: event,
              goalForHome: true,
            ),
          ),
        ),
      ),
    );
  }

  double slide(WidgetTester tester) => tester
      .widget<FractionalTranslation>(
        find
            .ancestor(
              of: find.byKey(matchGoalBannerKey),
              matching: find.byType(FractionalTranslation),
            )
            .first,
      )
      .translation
      .dy;

  testWidgets('one stripe: codes, score, the minute and its stoppage', (
    tester,
  ) async {
    await pump(tester);
    for (final t in ['CZE', 'POR', '2', '1', '90', '+3']) {
      expect(find.text(t), findsOneWidget, reason: t);
      // All on the one line.
      expect(
        tester.getCenter(find.text(t)).dy,
        closeTo(tester.getCenter(find.text('CZE')).dy, 1.5),
        reason: t,
      );
    }
    expect(find.byKey(matchGoalBannerKey), findsNothing);
    // A 24 px stripe in 4 px of margin above and below.
    expect(tester.getSize(find.byType(MatchScoreboard)).height, 32);
    expect(tester.takeException(), isNull);
  });

  for (final locale in ['en', 'cs']) {
    testWidgets('$locale: a goal slides the banner out from under the bar', (
      tester,
    ) async {
      final l = await AppLocalizations.delegate.load(Locale(locale));
      await pump(tester, event: goal, locale: locale);
      expect(find.text(l.matchGoalShout), findsOneWidget);
      expect(find.text('Jan Novak'), findsOneWidget);
      expect(find.text('90+3'), findsOneWidget);
      // Tucked under the stripe at first, out after the slide, held, and
      // back in by the end of the flash.
      expect(slide(tester), lessThan(-0.9));
      await tester.pump(kGoalBannerSlide ~/ 2);
      expect(slide(tester), allOf(greaterThan(-0.9), lessThan(0)));
      await tester.pump(kGoalBannerSlide);
      expect(slide(tester), 0);
      // 1.42 s in: still out.
      await tester.pump(const Duration(milliseconds: 1000));
      expect(slide(tester), 0);
      // At the end of the flash: back in under the stripe.
      await tester.pump(kGoalFlashHold - const Duration(milliseconds: 1420));
      expect(slide(tester), lessThan(-0.95));
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('reduced motion: the banner is simply there', (tester) async {
    await pump(tester, event: goal, still: true);
    expect(find.byKey(matchGoalBannerKey), findsOneWidget);
    expect(slide(tester), 0);
  });
}
