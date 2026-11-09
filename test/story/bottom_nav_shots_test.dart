import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/config/ui_language.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/seeded_save.dart';
import 'capture.dart' show loadMaterialIcons;

/// PREVIEWS ONLY (not part of the suite): the phone screens that carry the
/// floating dock, at iPhone 15 size (393 x 852 points, 3x, home indicator
/// inset), in the app's own fonts and icons, for a human to look at.
///
///   NAV_OUT=dir LANGS=en,de flutter test test/story/bottom_nav_shots_test.dart
///
/// Writes `final_<screen>[_<lang>].png`, plus `final_<screen>_end.png` with
/// the list scrolled to its end.
const Size _iphone15 = Size(393, 852);
const double _dpr = 3;
const Key _root = Key('navShots.root');

void main() {
  final out =
      Platform.environment['NAV_OUT'] ??
      '${Platform.environment['HOME']}/Downloads/nav-drafts';
  final langs = (Platform.environment['LANGS'] ?? 'en').split(',');
  setUpAll(loadMaterialIcons);

  testWidgets('dock screens', (tester) async {
    tester.view
      ..physicalSize = _iphone15 * _dpr
      ..devicePixelRatio = _dpr
      ..padding = const FakeViewPadding(top: 59 * _dpr, bottom: 34 * _dpr)
      ..viewPadding = const FakeViewPadding(top: 59 * _dpr, bottom: 34 * _dpr);
    addTearDown(tester.view.reset);
    final save = await seedSave(tester);
    for (final code in langs) {
      final suffix = code == 'en' ? '' : '_$code';
      for (final (name, route) in const [
        ('hub', Routes.hub),
        ('standings', Routes.tournaments),
        ('squad', Routes.tactics),
        ('ranking', Routes.ranking),
        ('career', Routes.careers),
      ]) {
        await _pump(
          tester,
          save.container,
          '$route?careerId=${save.careerId}',
          Locale(code),
        );
        expect(tester.takeException(), isNull, reason: '$name $code');
        await _shoot(tester, '$out/final_$name$suffix.png');
        // And at the foot of the list: the last item clear of the dock.
        final list = find
            .byWidgetPredicate(
              (w) => w is ListView && w.scrollDirection == Axis.vertical,
            )
            .first;
        final position = tester
            .state<ScrollableState>(
              find
                  .descendant(of: list, matching: find.byType(Scrollable))
                  .first,
            )
            .position;
        position.jumpTo(position.maxScrollExtent);
        await tester.pump();
        await _shoot(tester, '$out/final_${name}_end$suffix.png');
      }
    }
  });
}

Future<void> _pump(
  WidgetTester tester,
  ProviderContainer container,
  String location,
  Locale locale,
) async {
  container.read(localeProvider.notifier).state = locale;
  final router = container.read(routerProvider)..go(location);
  await tester.pumpWidget(
    RepaintBoundary(
      key: _root,
      child: UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.theme,
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    ),
  );
  await settle(tester);
  // Let the trophy art decode.
  await tester.runAsync(() async {
    for (final e in find.byType(Image).evaluate()) {
      await precacheImage((e.widget as Image).image, e);
    }
  });
  await tester.pump(const Duration(milliseconds: 300));
}

Future<void> _shoot(WidgetTester tester, String path) async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(_root),
  );
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: _dpr);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    File(path)
      ..createSync(recursive: true)
      ..writeAsBytesSync(data!.buffer.asUint8List());
    image.dispose();
  });
}
