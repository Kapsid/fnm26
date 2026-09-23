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

import '../helpers/expect_whole.dart';
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

    test('every step points at a specific control', () {
      // A step that lights nothing teaches nothing — that was the first
      // version of this and it read as a scroller. Two steps were left aiming
      // at "the screen" on the grounds that a records page has no one button
      // worth pointing at; on a device they were simply the two steps where
      // the tour stopped working.
      for (final step in kTourSteps) {
        expect(step.target, isNotNull, reason: 'step on ${step.route}');
      }
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
      expectNothingCut(tester);
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
      expectNothingCut(tester);
    });
  });

  group('the light settles', () {
    testWidgets('the hole lands on a control that arrives late', (
      tester,
    ) async {
      // A route transition slides, ensureVisible scrolls, a list settles. A
      // rect read in the middle of any of that is one the control has already
      // left — the ring sitting slightly off the thing it is meant to circle.
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
                body: Center(
                  // Slides into place over 300ms, like a route does.
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 200),
                    duration: const Duration(milliseconds: 300),
                    builder: (context, offset, child) => Transform.translate(
                      offset: Offset(0, offset),
                      child: child,
                    ),
                    child: SizedBox(
                      key: TourKeys.hubAction,
                      width: 120,
                      height: 40,
                      child: const Text('the button'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final spotlight = tester
          .widgetList<CustomPaint>(find.byType(CustomPaint))
          .map((p) => p.painter)
          .whereType<SpotlightPainter>()
          .single;
      final settled = tester.getRect(find.byKey(TourKeys.hubAction));

      expect(spotlight.hole, isNotNull, reason: 'nothing was lit');
      expect(
        spotlight.hole!.center.dy,
        closeTo(settled.center.dy, 1),
        reason: 'the ring is where the control USED to be',
      );
    });
  });

  group('the light stays on the screen', () {
    testWidgets('a control off the edge is not lit at all', (tester) async {
      // A ring hanging off the side of the screen, around nothing, is worse
      // than no ring: the manager looks where it points and there is nothing
      // there.
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
                body: Transform.translate(
                  // Well past the right-hand edge.
                  offset: const Offset(5000, 0),
                  child: SizedBox(
                    key: TourKeys.hubAction,
                    width: 120,
                    height: 40,
                    child: const Text('miles away'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final spotlight = tester
          .widgetList<CustomPaint>(find.byType(CustomPaint))
          .map((p) => p.painter)
          .whereType<SpotlightPainter>()
          .single;
      expect(
        spotlight.hole,
        isNull,
        reason: 'it lit a control that is not on the screen',
      );
      // The caption still reads — the step is not lost, only the ring.
      expect(find.text('This is the whole game'), findsOneWidget);
    });

    testWidgets('a control half off the edge is trimmed to what is visible', (
      tester,
    ) async {
      tester.view
        ..physicalSize = const Size(400, 800)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

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
                body: Transform.translate(
                  offset: const Offset(340, 100),
                  child: SizedBox(
                    key: TourKeys.hubAction,
                    width: 200,
                    height: 40,
                    child: const Text('half off'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final spotlight = tester
          .widgetList<CustomPaint>(find.byType(CustomPaint))
          .map((p) => p.painter)
          .whereType<SpotlightPainter>()
          .single;
      expect(spotlight.hole, isNotNull);
      expect(
        spotlight.hole!.right,
        lessThanOrEqualTo(400),
        reason: 'the ring ran off the side of the screen',
      );
    });
  });

  group('the ring is exactly where the control is', () {
    testWidgets('even when the overlay does not start at the screen corner', (
      tester,
    ) async {
      // localToGlobal gives a rect in SCREEN space; the canvas is in the
      // overlay's own. They are identical only while the overlay starts at the
      // top-left, and anything that insets it shifts every ring by that inset
      // — the highlight sitting slightly off the control with no obvious
      // cause. This pads the overlay to force the two spaces apart.
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
            home: Padding(
              padding: const EdgeInsets.only(left: 40, top: 60),
              child: TourOverlay(
                child: Scaffold(
                  body: Center(
                    child: SizedBox(
                      key: TourKeys.hubAction,
                      width: 120,
                      height: 40,
                      child: const Text('the button'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final paint = find.byType(CustomPaint).evaluate().map((e) => e.widget);
      final spotlight = paint.whereType<CustomPaint>().firstWhere(
        (p) => p.painter is SpotlightPainter,
      );
      final hole = (spotlight.painter! as SpotlightPainter).hole;
      expect(hole, isNotNull, reason: 'nothing was lit');

      // Convert the painted hole back into screen space and compare it with
      // where the control actually is.
      final surface = tester.renderObject<RenderBox>(
        find.byWidget(spotlight),
      );
      final drawn = Rect.fromPoints(
        surface.localToGlobal(hole!.topLeft),
        surface.localToGlobal(hole.bottomRight),
      );
      final control = tester.getRect(find.byKey(TourKeys.hubAction));

      expect(
        drawn.center.dx,
        closeTo(control.center.dx, 1),
        reason: 'the ring is ${drawn.center.dx - control.center.dx}px sideways',
      );
      expect(
        drawn.center.dy,
        closeTo(control.center.dy, 1),
        reason: 'the ring is ${drawn.center.dy - control.center.dy}px out',
      );
    });
  });

  group('a transformed control', () {
    testWidgets('is ringed at the size it is actually drawn', (tester) async {
      // A route mid-transition is scaled as well as moved. Reading the box's
      // own size and translating one corner gets the position roughly right
      // and the SIZE wrong, which is a ring a few pixels out from what it is
      // meant to be around — the "moved a little bit" that survives every
      // other fix.
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
                body: Center(
                  child: Transform.scale(
                    scale: 0.5,
                    child: SizedBox(
                      key: TourKeys.hubAction,
                      width: 200,
                      height: 80,
                      child: const Text('shrunk'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final spotlight = tester
          .widgetList<CustomPaint>(find.byType(CustomPaint))
          .map((p) => p.painter)
          .whereType<SpotlightPainter>()
          .single;
      final hole = spotlight.hole;
      expect(hole, isNotNull);

      // Drawn at 200x80 scaled by a half: 100x40, plus the ring's padding.
      expect(
        hole!.width,
        closeTo(100 + 12, 2),
        reason: 'ring is ${hole.width}px wide for a 100px control',
      );
      expect(hole.height, closeTo(40 + 12, 2));
    });
  });

  group('a screen that is still arriving', () {
    testWidgets('is waited for, not written off', (tester) async {
      // The control is not in the tree at all for the first few frames, which
      // is what a route still building looks like. This pins the WAIT: the
      // search keeps looking rather than lighting nothing.
      //
      // It does not reproduce the careers step going dark — that survived
      // this test — so it is coverage, not the regression test for that bug.
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(tourStepProvider.notifier).state = 0;

      var arrived = false;
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.theme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: TourOverlay(
              child: Scaffold(
                body: StatefulBuilder(
                  builder: (context, setState) {
                    if (!arrived) {
                      // Turn up a few frames late, like a route does.
                      Future<void>.delayed(
                        const Duration(milliseconds: 40),
                        () {
                          arrived = true;
                          setState(() {});
                        },
                      );
                      return const SizedBox.shrink();
                    }
                    return Center(
                      child: SizedBox(
                        key: TourKeys.hubAction,
                        width: 120,
                        height: 40,
                        child: const Text('finally here'),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final spotlight = tester
          .widgetList<CustomPaint>(find.byType(CustomPaint))
          .map((p) => p.painter)
          .whereType<SpotlightPainter>()
          .single;
      expect(
        spotlight.hole,
        isNotNull,
        reason: 'it gave up before the control had arrived',
      );
      final control = tester.getRect(find.byKey(TourKeys.hubAction));
      expect(spotlight.hole!.width, closeTo(control.width + 12, 2));
    });
  });

  group('a page still sliding in', () {
    testWidgets('the ring ends up on the control, not behind it', (
      tester,
    ) async {
      // The reported bug: steps that follow a route change lit slightly to the
      // LEFT of their control. A page slides horizontally into place, and a
      // rect read during that slide is where the control was, not where it
      // stops. "Two identical frames" did not save it — at the tail of an ease
      // curve two consecutive positions round to the same rect with a pixel or
      // two still to travel.
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
                body: Center(
                  child: TweenAnimationBuilder<double>(
                    // Slides in from the left, decelerating — a page arriving.
                    tween: Tween(begin: -140, end: 0),
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutCubic,
                    builder: (context, dx, child) => Transform.translate(
                      offset: Offset(dx, 0),
                      child: child,
                    ),
                    child: SizedBox(
                      key: TourKeys.hubAction,
                      width: 160,
                      height: 44,
                      child: const Text('arriving'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final spotlight = tester
          .widgetList<CustomPaint>(find.byType(CustomPaint))
          .map((p) => p.painter)
          .whereType<SpotlightPainter>()
          .single;
      final control = tester.getRect(find.byKey(TourKeys.hubAction));
      expect(spotlight.hole, isNotNull, reason: 'nothing was lit');
      expect(
        spotlight.hole!.center.dx,
        closeTo(control.center.dx, 1),
        reason:
            'the ring is ${control.center.dx - spotlight.hole!.center.dx}px '
            'left of where the control came to rest',
      );
    });
  });
}
