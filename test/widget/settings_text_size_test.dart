import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/core/theme/text_size.dart';
import 'package:fnm/features/settings/settings_providers.dart';
import 'package:fnm/features/settings/settings_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The Settings text size: Normal, Large, Larger, on top of the phone's own
/// text scale, never past [kMaxAppTextScale], and remembered.
void main() {
  group('appTextScaler', () {
    test('Normal leaves the phone scale untouched', () {
      const system = TextScaler.linear(1.15);
      expect(identical(appTextScaler(system, TextSize.normal), system), isTrue);
    });

    test('Large and Larger multiply the phone scale', () {
      expect(
        appTextScaler(TextScaler.noScaling, TextSize.large).scale(10),
        closeTo(11, 1e-9),
      );
      expect(
        appTextScaler(const TextScaler.linear(1.1), TextSize.larger).scale(10),
        closeTo(13.2, 1e-9),
      );
    });

    test('the product is capped, the phone scale included', () {
      const big = TextScaler.linear(2);
      expect(
        appTextScaler(big, TextSize.normal).scale(10),
        closeTo(10 * kMaxAppTextScale, 1e-9),
      );
      expect(
        appTextScaler(big, TextSize.larger).scale(10),
        closeTo(10 * kMaxAppTextScale, 1e-9),
      );
    });

    test('a stored name reads back, junk reads as Normal', () {
      for (final t in TextSize.values) {
        expect(TextSize.fromName(t.name), t);
      }
      expect(TextSize.fromName('huge'), TextSize.normal);
      expect(TextSize.fromName(null), TextSize.normal);
    });
  });

  testWidgets('picking Larger scales the app and is remembered', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await tester.binding.setSurfaceSize(const Size(390, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: Consumer(
          builder: (context, ref, _) => MaterialApp(
            theme: AppTheme.theme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) =>
                AppTextScale(size: ref.watch(textSizeProvider), child: child!),
            home: const SettingsScreen(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    double scaleOf(String text) =>
        MediaQuery.textScalerOf(tester.element(find.text(text))).scale(10) / 10;

    expect(find.text('Text size'), findsOneWidget);
    expect(scaleOf('Text size'), closeTo(1, 1e-9));

    await tester.tap(find.byKey(const Key('settings-text-size-larger')));
    await tester.pumpAndSettle();

    expect(container.read(textSizeProvider), TextSize.larger);
    expect(scaleOf('Text size'), closeTo(1.2, 1e-9));
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('settings.textSize'), 'larger');
  });
}
