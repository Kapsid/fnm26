import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/features/career/careers_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../helpers/expect_whole.dart';

/// Challenges in the careers menu.
///
/// They were reachable only by opening Achievements and finding a button in
/// its app bar, so a manager who never went looking never knew they existed.
/// The menu is where the rest of a career lives, so they get a line of their
/// own there, beside Achievements, and tapping it opens the challenges route.
void main() {
  /// Asserts that every [finder] match is rendered WHOLE, not ellipsised.
  ///
  /// `takeException` alone is not enough and never was: it passes for any
  /// amount of quiet truncation.
  void expectWhole(Finder finder, String what) {
    final elements = finder.evaluate();
    expect(elements, isNotEmpty, reason: '$what is not on screen at all');
    for (final element in elements) {
      final paragraph = element.renderObject! as RenderParagraph;
      expect(
        paragraph.didExceedMaxLines,
        isFalse,
        reason:
            '$what is cut off: it wants '
            '${paragraph.getMaxIntrinsicWidth(double.infinity)}px '
            'and was given ${paragraph.size.width}px',
      );
    }
  }

  /// The menu on its own router, so a tap can be followed to the route it
  /// asks for without standing up the whole app (and its database).
  ///
  /// The locale goes on the MaterialApp, NOT on a Localizations.override
  /// around the menu: the destination is a pushed route, which such an
  /// override never reaches.
  Future<List<String>> pumpMenu(
    WidgetTester tester, {
    required double width,
    required String locale,
  }) async {
    tester.view.physicalSize = Size(width, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final visited = <String>[];
    final router = GoRouter(
      initialLocation: '/careers',
      routes: [
        GoRoute(
          path: '/careers',
          builder: (_, _) => const CareersScreen(careerId: 1),
        ),
        for (final path in [Routes.challenges, Routes.achievements])
          GoRoute(
            path: path,
            builder: (_, state) {
              visited.add(state.uri.toString());
              return const Scaffold(body: Text('elsewhere'));
            },
          ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      MaterialApp.router(
        locale: Locale(locale),
        theme: AppTheme.theme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    );
    await tester.pumpAndSettle();
    return visited;
  }

  AppLocalizations strings(WidgetTester tester) =>
      AppLocalizations.of(tester.element(find.byType(CareersScreen)));

  testWidgets('challenges have a line of their own in the menu', (
    tester,
  ) async {
    await pumpMenu(tester, width: 400, locale: 'en');
    final l = strings(tester);

    expect(find.text(l.careerChallenges), findsOneWidget);
    // Beside achievements, not instead of them.
    expect(find.text(l.careerAchievements), findsOneWidget);
  });

  testWidgets('tapping it opens the challenges screen', (tester) async {
    final visited = await pumpMenu(tester, width: 400, locale: 'en');
    final l = strings(tester);

    await tester.tap(find.text(l.careerChallenges));
    await tester.pumpAndSettle();

    expect(visited, ['${Routes.challenges}?careerId=1']);
  });

  group('the entry survives a narrow phone', () {
    for (final width in [360.0, 400.0]) {
      for (final locale in ['en', 'cs']) {
        testWidgets('its title is whole at $width in $locale', (tester) async {
          await pumpMenu(tester, width: width, locale: locale);
          final l = strings(tester);

          expectWhole(find.text(l.careerChallenges), 'the challenges title');
          expectWhole(
            find.text(l.careerChallengesSubtitle),
            'the challenges subtitle',
          );
          expect(tester.takeException(), isNull);
          expectNothingCut(tester);
        });
      }
    }
  });
}
