import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/core/theme/text_size.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/seeded_save.dart';

/// The busiest screens at the Settings text size "Larger", on a phone and on
/// the smallest tablet, and again at the app's ceiling ([kMaxAppTextScale]:
/// "Larger" on a phone whose own text is already a notch up). Any RenderFlex
/// overflow is a Flutter error, so it fails the test.
///
/// The app is pumped through the real router with the real [AppTextScale] in
/// the MaterialApp builder, exactly as `app.dart` wires it.
const _routes = <String>[
  Routes.hub,
  Routes.tactics,
  '${Routes.tactics}?tab=3',
  Routes.match,
  Routes.matchPreview,
  Routes.results,
  Routes.tournaments,
  Routes.ranking,
  Routes.messages,
  Routes.campaigns,
  Routes.schedule,
  Routes.careerSummary,
  Routes.cup,
  Routes.settings,
  Routes.nations,
];

/// Routes that live outside a save take no career id.
const Set<String> _outsideSave = {Routes.settings, Routes.nations};

String _location(String route, int careerId) {
  if (_outsideSave.contains(route)) return route;
  return route.contains('?')
      ? '$route&careerId=$careerId'
      : '$route?careerId=$careerId';
}

Future<void> _pumpLarger(
  WidgetTester tester,
  String route, {
  required Size size,
  required FormFactor formFactor,
  double systemScale = 1,
}) async {
  final save = await seedSave(tester, formFactor: formFactor);
  if (route == Routes.match) {
    // Warmed as the pre-match screen does, so the match opens on it.
    final warm = save.container.listen(
      matchPreviewProvider(save.careerId),
      (_, _) {},
    );
    addTearDown(warm.close);
    await tester.runAsync(
      () => save.container.read(matchPreviewProvider(save.careerId).future),
    );
  }
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  tester.platformDispatcher.textScaleFactorTestValue = systemScale;
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  final router = save.container.read(routerProvider)
    ..go(_location(route, save.careerId));
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: save.container,
      child: MaterialApp.router(
        theme: AppTheme.theme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
        builder: (context, child) =>
            AppTextScale(size: TextSize.larger, child: child!),
      ),
    ),
  );
  await settle(tester, allowSpinner: true);
}

void main() {
  for (final route in _routes) {
    testWidgets('$route fits a phone at Larger', (tester) async {
      await _pumpLarger(
        tester,
        route,
        size: kPhoneSize,
        formFactor: FormFactor.phone,
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('$route fits a phone at the text scale ceiling', (
      tester,
    ) async {
      await _pumpLarger(
        tester,
        route,
        size: kPhoneSize,
        formFactor: FormFactor.phone,
        systemScale: 1.2,
      );
      // 1.2 x 1.2 = 1.44, so the ceiling is what is drawn.
      expect(
        MediaQuery.textScalerOf(
          tester.element(find.byType(Scaffold).first),
        ).scale(10),
        closeTo(10 * kMaxAppTextScale, 1e-9),
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('$route fits the smallest tablet at Larger', (tester) async {
      await _pumpLarger(
        tester,
        route,
        size: kTabletSizes.last,
        formFactor: FormFactor.tablet,
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }
}
