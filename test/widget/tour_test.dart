import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/features/onboarding/tour_overlay.dart';
import 'package:fnm/features/onboarding/tour_keys.dart';
import 'package:fnm/features/onboarding/tour_providers.dart';
import 'package:fnm/features/onboarding/tour_steps.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/pump_app.dart';

/// The walk through a manager gets on his first day.
void main() {
  group('the steps themselves', () {
    test('every step points at a route the app actually has', () {
      const known = {
        Routes.hub,
        Routes.budgetSetup,
        Routes.tactics,
        Routes.callUps,
        Routes.careers,
        Routes.tournaments,
      };
      for (final step in kTourSteps) {
        expect(known, contains(step.route), reason: step.route);
      }
    });

    test('most steps point at a specific control, not just a screen', () {
      // A tour that only dims the screen teaches nothing — that was the first
      // version of this and it read as a scroller. The records page and the
      // list of cups have no one button worth pointing at and are allowed to
      // be about the screen; everything else must aim at something.
      final aimed = kTourSteps.where((s) => s.target != null).length;
      expect(aimed, greaterThanOrEqualTo(kTourSteps.length - 2));
    });

    test('it covers the screens without being a slog', () {
      expect(kTourSteps.length, inInclusiveRange(5, 12));
    });

    test('no two steps light the same control', () {
      final targets = [
        for (final s in kTourSteps)
          if (s.target != null) s.target,
      ];
      expect(targets.toSet().length, targets.length);
    });

    testWidgets('every caption reads in both languages', (tester) async {
      for (final locale in [const Locale('en'), const Locale('cs')]) {
        late AppLocalizations l;
        await tester.pumpWidget(
          MaterialApp(
            locale: locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) {
                l = AppLocalizations.of(context);
                return const SizedBox();
              },
            ),
          ),
        );
        for (final step in kTourSteps) {
          expect(step.title(l).trim(), isNotEmpty, reason: '$locale title');
          expect(step.body(l).trim(), isNotEmpty, reason: '$locale body');
          // A caption that is only a heading teaches nothing.
          expect(step.body(l).length, greaterThan(40));
        }
      }
    });
  });

  group('the overlay', () {
    Future<ProviderContainer> pumpTour(WidgetTester tester, int step) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(tourStepProvider.notifier).state = step;
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.theme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            // No careerId: the overlay must draw without navigating, so the
            // caption can be tested without a router underneath it.
            home: const TourOverlay(
              child: Scaffold(body: Text('the screen behind')),
            ),
          ),
        ),
      );
      await tester.pump();
      return container;
    }

    testWidgets('it dims the screen and captions it', (tester) async {
      await pumpTour(tester, 0);
      expect(find.text('This is the whole game'), findsOneWidget);
      expect(find.text('1/${kTourSteps.length}'), findsOneWidget);
      // The screen is still under there — the tour is about the real thing.
      expect(find.text('the screen behind'), findsOneWidget);
    });

    testWidgets('Next advances and Back returns', (tester) async {
      final container = await pumpTour(tester, 0);

      await tester.tap(find.text('Next'));
      await tester.pump();
      expect(container.read(tourStepProvider), 1);
      expect(find.text('2/${kTourSteps.length}'), findsOneWidget);

      await tester.tap(find.text('Back'));
      await tester.pump();
      expect(container.read(tourStepProvider), 0);
    });

    testWidgets('the first step offers no way back', (tester) async {
      await pumpTour(tester, 0);
      expect(find.text('Back'), findsNothing);
    });

    testWidgets('the last step says Done, not Next', (tester) async {
      await pumpTour(tester, kTourSteps.length - 1);
      expect(find.text('Done'), findsOneWidget);
      expect(find.text('Next'), findsNothing);
    });

    testWidgets('Skip ends it there and then', (tester) async {
      final container = await pumpTour(tester, 2);
      await tester.tap(find.text('Skip'));
      await tester.pump();
      expect(container.read(tourStepProvider), isNull);
    });

    testWidgets('Done ends it', (tester) async {
      final container = await pumpTour(tester, kTourSteps.length - 1);
      await tester.tap(find.text('Done'));
      await tester.pump();
      expect(container.read(tourStepProvider), isNull);
    });

    testWidgets('nothing behind the scrim can be tapped', (tester) async {
      var tapped = false;
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(tourStepProvider.notifier).state = 0;
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.theme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: TourOverlay(
              child: Scaffold(
                body: Align(
                  alignment: Alignment.topCenter,
                  child: ElevatedButton(
                    onPressed: () => tapped = true,
                    child: const Text('do not press me'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.text('do not press me'), warnIfMissed: false);
      await tester.pump();
      expect(
        tapped,
        isFalse,
        reason: 'a tour you can click through is not a tour',
      );
    });

    testWidgets('with no tour running it draws only the screen', (
      tester,
    ) async {
      await tester.pumpApp(
        const TourOverlay(
          child: Scaffold(body: Text('the screen behind')),
        ),
      );
      await tester.pump();
      expect(find.text('the screen behind'), findsOneWidget);
      expect(find.text('Skip'), findsNothing);
    });
  });

  group('the spotlight', () {
    testWidgets('it cuts a hole around the control it is describing', (
      tester,
    ) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(tourStepProvider.notifier).state = 0;

      final target = TourKeys.hubAction;
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.theme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: TourOverlay(
              child: Scaffold(
                body: Center(
                  child: SizedBox(
                    key: target,
                    width: 120,
                    height: 40,
                    child: const Text('the button'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Not "it painted something" — that was true of the version that lit
      // nothing. The hole has to land on the control's own rect.
      final spotlight = tester
          .widgetList<CustomPaint>(find.byType(CustomPaint))
          .map((p) => p.painter)
          .whereType<SpotlightPainter>()
          .single;
      final wanted = tester.getRect(find.byKey(target));
      expect(
        spotlight.hole,
        isNotNull,
        reason: 'nothing was lit — the tour is a curtain again',
      );
      expect(spotlight.hole!.center.dx, closeTo(wanted.center.dx, 1));
      expect(spotlight.hole!.center.dy, closeTo(wanted.center.dy, 1));
      expect(spotlight.hole!.width, greaterThanOrEqualTo(wanted.width));
      expect(tester.takeException(), isNull);
    });

    testWidgets('a step whose control is absent still reads', (tester) async {
      // The screen has not built the target — a save with no such control, or
      // a route that has not settled. The caption must still appear rather
      // than the tour dying on a null.
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(tourStepProvider.notifier).state = 0;

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.theme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const TourOverlay(
              child: Scaffold(body: Text('nothing keyed here')),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('This is the whole game'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
