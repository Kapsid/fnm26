import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/features/onboarding/tour_keys.dart';
import 'package:fnm/features/onboarding/tour_overlay.dart';
import 'package:fnm/features/onboarding/tour_providers.dart';
import 'package:fnm/features/onboarding/tour_steps.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/tournaments/continental_detail_screen.dart';
import 'package:fnm/features/tournaments/cup_detail_screen.dart';
import 'package:fnm/features/tournaments/nations_cup_screen.dart';
import 'package:fnm/features/tournaments/tournaments_providers.dart';
import 'package:fnm/features/tournaments/tournaments_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/competition_fixtures.dart';
import '../helpers/seeded_save.dart';

/// Asia's championship and Africa's Nations Cup live, Africa's championship
/// not yet: other confederations' rows that open real views, and one that
/// does not.
TournamentsOverview _overview() {
  const live = TournamentStatus(
    phase: TournamentPhase.live,
    label: 'LIVE',
    championId: null,
  );
  const soon = TournamentStatus(
    phase: TournamentPhase.upcoming,
    label: 'SOON',
    championId: null,
  );
  return TournamentsOverview(
    playerConfederation: Confederation.europe,
    nations: realNationsById,
    nextMatches: const {},
    playerGroup: null,
    worldCupHostId: null,
    statuses: const {
      null: live,
      Confederation.europe: live,
      Confederation.asia: live,
      Confederation.africa: soon,
      Confederation.southAmerica: soon,
      Confederation.northAmerica: soon,
      Confederation.oceania: soon,
    },
    nationsCup: live,
    nationsCupConfederation: Confederation.europe,
    otherNationsCups: const {
      Confederation.africa: live,
      Confederation.northAmerica: soon,
    },
  );
}

Future<SeededSave> _open(
  WidgetTester tester,
  Size size, {
  bool fake = false,
}) async {
  final save = await seedSave(
    tester,
    formFactor: FormFactor.tablet,
    overrides: [
      if (fake)
        tournamentsOverviewProvider(
          kSeededCareerId,
        ).overrideWith((ref) async => _overview()),
    ],
  );
  await pumpRoute(
    tester,
    save,
    '${Routes.tournaments}?careerId=${save.careerId}',
    size: size,
  );
  return save;
}

Finder get _layout => find.byKey(TournamentsScreen.tabletLayoutKey);

Future<void> _pick(WidgetTester tester, String key) async {
  final row = find.byKey(Key(key));
  await tester.ensureVisible(row);
  await tester.pump();
  await tester.tap(row);
  await settle(tester);
}

void main() {
  for (final size in kTabletSizes) {
    testWidgets('the list left, the live competition open right, $size', (
      tester,
    ) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(_layout, findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBottomNav), findsNothing);
      expect(find.byType(MasterDetail), findsOneWidget);
      // The tour's target is the list's ranking row.
      expect(
        find.descendant(
          of: _layout,
          matching: find.byKey(TourKeys.worldRanking),
        ),
        findsOneWidget,
      );
      // Something is open in the pane, right of the list.
      final open = find.byWidgetPredicate(
        (w) => w is CupDetailView || w is ContinentalDetailView,
      );
      expect(open, findsOneWidget);
      expect(
        tester.getCenter(find.byKey(TourKeys.worldRanking)).dx,
        lessThan(tester.getCenter(open).dx),
      );
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets("another confederation's row opens THAT cup (Review Focus 4)", (
    tester,
  ) async {
    await _open(tester, kTabletSize, fake: true);
    // The live World Championship opens first.
    expect(find.byType(CupDetailView), findsOneWidget);

    await _pick(tester, 'competition.continental.asia');
    expect(
      tester
          .widget<ContinentalDetailView>(find.byType(ContinentalDetailView))
          .confederation,
      Confederation.asia,
    );

    await _pick(tester, 'competition.nationsCup.africa');
    expect(
      tester.widget<NationsCupView>(find.byType(NationsCupView)).confederation,
      Confederation.africa,
    );

    // The manager's own Nations Cup is Europe's, named, not a default.
    await _pick(tester, 'competition.nationsCup.europe');
    expect(
      tester.widget<NationsCupView>(find.byType(NationsCupView)).confederation,
      Confederation.europe,
    );

    // A competition with nothing yet says so.
    await _pick(tester, 'competition.continental.africa');
    expect(find.text(enL.tourSharedComingSoon), findsOneWidget);
    expect(find.byType(ContinentalDetailView), findsNothing);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the ranking row goes to the ranking', (tester) async {
    final save = await _open(tester, kTabletSize);
    await tester.tap(find.byKey(TourKeys.worldRanking));
    await settle(tester);
    expect(
      save.container
          .read(routerProvider)
          .routeInformationProvider
          .value
          .uri
          .path,
      Routes.ranking,
    );
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the tour lights the ranking row on a tablet', (tester) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    tester.view.physicalSize = kTabletSize;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final router = save.container.read(routerProvider)
      ..go('${Routes.hub}?careerId=${save.careerId}');
    save.container.read(tourCareerProvider.notifier).state = save.careerId;
    save.container.read(tourStepProvider.notifier).state = kTourSteps
        .indexWhere((s) => s.route == Routes.tournaments);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: save.container,
        child: MaterialApp.router(
          theme: AppTheme.theme,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
          builder: (context, child) =>
              TourOverlay(child: child ?? const SizedBox.shrink()),
        ),
      ),
    );
    await settle(tester);
    // The overlay keeps measuring its target for 90 frames.
    for (var i = 0; i < 100; i++) {
      await tester.pump(const Duration(milliseconds: 16));
    }
    expect(router.routeInformationProvider.value.uri.path, Routes.tournaments);
    expect(
      find.descendant(of: _layout, matching: find.byKey(TourKeys.worldRanking)),
      findsOneWidget,
    );
    final painter =
        tester
                .widget<CustomPaint>(
                  find.byWidgetPredicate(
                    (w) => w is CustomPaint && w.painter is SpotlightPainter,
                  ),
                )
                .painter!
            as SpotlightPainter;
    expect(painter.hole, isNotNull, reason: 'the tour fell back to dimming');
    expect(
      painter.hole!.contains(
        tester.getCenter(find.byKey(TourKeys.worldRanking)),
      ),
      isTrue,
    );
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the ranking target follows a window through 1000', (
    tester,
  ) async {
    await _open(tester, kTabletSize);
    tester.view.physicalSize = const Size(700, 810);
    await settle(tester);
    expect(tester.takeException(), isNull);
    expect(_layout, findsNothing);
    expect(find.byKey(TourKeys.worldRanking), findsOneWidget);
    expect(tester.widget(find.byKey(TourKeys.worldRanking)), isA<AppCard>());
    tester.view.physicalSize = kTabletSize;
    await settle(tester);
    expect(tester.takeException(), isNull);
    expect(
      find.descendant(of: _layout, matching: find.byKey(TourKeys.worldRanking)),
      findsOneWidget,
    );
    await tester.pumpWidget(const SizedBox());
  });
}
