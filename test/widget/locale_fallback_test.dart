import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// What a phone in a language this app does not speak ends up reading.
///
/// Flutter's default locale resolution, when it can match neither the device's
/// language nor its country, falls back to the FIRST entry of
/// `supportedLocales`. gen-l10n orders that list alphabetically by locale code
/// unless it is told otherwise, and "cs" sorts before "en" — so every German,
/// French, Spanish or Japanese phone in the world opened this app entirely in
/// Czech. English is the template language (`app_en.arb`) and every string
/// exists in it, so English is the fallback; `preferred-supported-locales` in
/// l10n.yaml is what puts it first, and this file is what notices if that ever
/// comes back out.
void main() {
  /// The language the app actually renders in when the DEVICE is set to
  /// [deviceLocales] and the manager has chosen no language of his own.
  ///
  /// Resolution is done by the same `MaterialApp` configuration the app runs
  /// (`lib/app.dart`): no `locale:`, so the platform's list is used, and the
  /// app's own delegates and supported locales. Reading a translated STRING
  /// rather than the resolved `Locale` is deliberate — a locale that resolves
  /// to English while the strings come out Czech would be the same bug.
  Future<({Locale locale, String greeting})> render(
    WidgetTester tester,
    List<Locale> deviceLocales,
  ) async {
    tester.platformDispatcher.localesTestValue = deviceLocales;
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);

    late Locale resolved;
    late String greeting;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            resolved = Localizations.localeOf(context);
            greeting = AppLocalizations.of(context).matchPreviewTitle;
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    return (locale: resolved, greeting: greeting);
  }

  testWidgets('a language the app does not speak reads English', (
    tester,
  ) async {
    final german = await render(tester, [const Locale('de', 'DE')]);

    expect(
      german.locale.languageCode,
      'en',
      reason: 'a German phone is being handed a language nobody asked for',
    );
    expect(german.greeting, 'MATCH PREVIEW');
  });

  testWidgets('every unsupported language reads English, not just German', (
    tester,
  ) async {
    // One test on one language would pass on an accident of alphabetisation:
    // any of these sorting before "cs" would be read as a fix that is not one.
    for (final code in ['fr', 'es', 'ja', 'ar', 'ab']) {
      final rendered = await render(tester, [Locale(code)]);
      expect(
        rendered.greeting,
        'MATCH PREVIEW',
        reason: 'a phone set to "$code" is not reading English',
      );
    }
  });

  testWidgets('a Czech phone still reads Czech', (tester) async {
    final czech = await render(tester, [const Locale('cs', 'CZ')]);

    expect(czech.locale.languageCode, 'cs');
    expect(
      czech.greeting,
      'NÁHLED ZÁPASU',
      reason: 'the fallback has been fixed by taking Czech away',
    );
  });

  testWidgets('a supported language further down the device list still wins', (
    tester,
  ) async {
    // A phone set to German with Czech second: Czech is SUPPORTED and the
    // manager asked for it, so it beats the fallback. This is what separates
    // "English is the fallback" from "English always".
    final rendered = await render(tester, [
      const Locale('de', 'DE'),
      const Locale('cs', 'CZ'),
    ]);

    expect(rendered.greeting, 'NÁHLED ZÁPASU');
  });

  test('English is first in the supported list, which is what makes it the '
      'fallback', () {
    // The resolution above rests entirely on this order, and the order comes
    // from `preferred-supported-locales` in l10n.yaml, because the file that
    // declares it is GENERATED and must never be hand-edited.
    expect(AppLocalizations.supportedLocales.first, const Locale('en'));
    expect(AppLocalizations.supportedLocales, contains(const Locale('cs')));
  });
}
