import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/features/match/score_bug_theme.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/country_flag.dart';

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
    int home = 2,
    int away = 1,
    String locale = 'en',
    double width = 320,
    String homeCode = 'CZE',
    String awayCode = 'POR',
    String clock = '90+3',
    ScoreBugTheme? theme,
    String? tournament,
  }) async {
    tester.view
      ..physicalSize = Size(width, 400)
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
            size: Size(width, 400),
            disableAnimations: still,
          ),
          child: Scaffold(
            body: MatchScoreboard(
              homeCode: homeCode,
              awayCode: awayCode,
              homeName: 'Czechia',
              awayName: 'Portugal',
              homeScore: home,
              awayScore: away,
              clock: clock,
              live: true,
              compact: true,
              homeColor: Colors.red,
              awayColor: Colors.green,
              goal: event,
              goalForHome: true,
              bugTheme: theme,
              tournament: tournament,
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
    // Each side's flag, from the app's own flag art.
    expect(find.byType(CountryFlag), findsNWidgets(2));
    // A 28 px stripe in 2 px of margin above and below.
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

  Finder inBoard(Finder f) =>
      find.descendant(of: find.byType(MatchScoreboard), matching: f);

  testWidgets('reduced motion: the banner is simply there, nothing pulses', (
    tester,
  ) async {
    await pump(tester, event: goal, still: true);
    expect(find.byKey(matchGoalBannerKey), findsOneWidget);
    // No slide of its own (whatever the page's route transition does) and
    // no pulse of the score: nothing in the stripe animates.
    expect(inBoard(find.byType(FractionalTranslation)), findsNothing);
    expect(inBoard(find.byType(TweenAnimationBuilder<double>)), findsNothing);
    expect(inBoard(find.byType(Transform)), findsNothing);
    expect(find.byKey(matchScoreSheenKey), findsNothing);
    // The banner's flag is there all the same.
    expect(find.byType(CountryFlag), findsNWidgets(3));
  });

  // Every phone width, the longest codes, a double-digit score and a long
  // stoppage, with and without the banner: never an overflow.
  for (final width in [320.0, 360.0, 390.0, 430.0, 820.0]) {
    testWidgets('${width.toInt()} px: long codes and a 10-10 still fit', (
      tester,
    ) async {
      await pump(
        tester,
        width: width,
        home: 10,
        away: 10,
        homeCode: 'WWWWW',
        awayCode: 'MMMMM',
        clock: '90+12',
        event: goal,
      );
      await tester.pump(kGoalBannerSlide);
      expect(tester.takeException(), isNull);
      // The text itself, not the stand-in a flag with no art draws.
      Finder label(String t) => find.byWidgetPredicate(
        (w) =>
            w is Text && w.data == t && w.style?.fontWeight != FontWeight.w500,
      );
      for (final t in ['WWWWW', 'MMMMM', '90', '+12']) {
        final r = tester.getRect(label(t));
        expect(r.left, greaterThanOrEqualTo(0), reason: t);
        expect(r.right, lessThanOrEqualTo(width), reason: t);
      }
      // The codes stay on their own side of the plate.
      final plate = tester.getRect(
        find
            .ancestor(of: find.text('10').first, matching: find.byType(Row))
            .first,
      );
      expect(
        tester.getRect(label('WWWWW')).right,
        lessThanOrEqualTo(plate.left + 0.01),
      );
      expect(
        tester.getRect(label('MMMMM')).left,
        greaterThanOrEqualTo(plate.right - 0.01),
      );
      await tester.pump(kGoalFlashHold);
    });
  }

  testWidgets('with motion: the banner slides and the scorer pulses', (
    tester,
  ) async {
    await pump(tester, event: goal);
    // The banner's slide, the home figure's pulse and the plate's sheen.
    expect(
      inBoard(find.byType(TweenAnimationBuilder<double>)),
      findsNWidgets(3),
    );
    expect(find.byKey(matchScoreSheenKey), findsOneWidget);
    // The banner carries the scorer's flag (the stripe's two and its own).
    expect(find.byType(CountryFlag), findsNWidgets(3));
    await tester.pump(const Duration(milliseconds: 350));
    final scale = tester
        .widget<Transform>(
          find
              .ancestor(of: find.text('2'), matching: find.byType(Transform))
              .first,
        )
        .transform
        .getMaxScaleOnAxis();
    expect(scale, greaterThan(1.2));
  });

  testWidgets('a 10-9 is set whole, never clipped', (tester) async {
    await pump(tester, home: 10, away: 9);
    for (final t in ['10', '9']) {
      final p = tester.renderObject<RenderParagraph>(find.text(t));
      // Laid out at its full width (a fixed box too narrow clipped "10").
      expect(
        p.size.width,
        greaterThanOrEqualTo(p.getMaxIntrinsicWidth(double.infinity) - 0.01),
        reason: t,
      );
      // And drawn inside its share of the plate.
      final box = tester.getRect(
        find.ancestor(of: find.text(t), matching: find.byType(SizedBox)).first,
      );
      final drawn = tester.getRect(find.text(t));
      expect(drawn.left, greaterThanOrEqualTo(box.left - 0.01), reason: t);
      expect(drawn.right, lessThanOrEqualTo(box.right + 0.01), reason: t);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('silver: no tournament tab, the bar as it always was', (
    tester,
  ) async {
    await pump(tester);
    expect(find.byKey(const Key('match.scoreBugTab')), findsNothing);
  });

  for (final kind in ScoreBugThemeKind.values) {
    testWidgets('${kind.name}: the tab names the tournament, the score '
        'block wears its colours, a goal banner still fits', (tester) async {
      final theme = ScoreBugTheme.all[kind]!;
      await pump(
        tester,
        theme: theme,
        tournament: 'European Championship',
        event: goal,
        still: true,
      );
      expect(tester.takeException(), isNull);
      expect(find.byKey(const Key('match.scoreBugTab')), findsOneWidget);
      expect(find.text('EUROPEAN CHAMPIONSHIP'), findsOneWidget);
      final score = tester.widget<Text>(find.text('2'));
      expect(score.style?.color, theme.scoreText);
      final block = find.ancestor(
        of: find.text('2'),
        matching: find.byWidgetPredicate(
          (w) =>
              w is Container &&
              w.decoration is BoxDecoration &&
              (w.decoration! as BoxDecoration).gradient is LinearGradient &&
              ((w.decoration! as BoxDecoration).gradient! as LinearGradient)
                      .colors
                      .first ==
                  theme.score.first,
        ),
      );
      expect(block, findsWidgets);
      expect(find.byKey(matchGoalBannerKey), findsOneWidget);
    });
  }
}
