import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/settings/settings_providers.dart';
import 'package:fnm/features/settings/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/pump_app.dart';

void main() {
  testWidgets('the language row opens a picker of six and sets the locale', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpApp(const SettingsScreen());
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(const Key('settings-language-tile')));
    await tester.tap(find.byKey(const Key('settings-language-tile')));
    await tester.pumpAndSettle();
    final sheetList = find.descendant(
      of: find.byKey(const Key('language-sheet-list')),
      matching: find.byType(Scrollable),
    );

    for (final code in [
      'system',
      'en',
      'cs',
      'fr',
      'it',
      'pl',
      'es',
      'de',
      'pt',
      'tr',
      'nl',
      'id',
      'el',
      'sv',
      'nb',
      'vi',
      'bg',
      'da',
      'fi',
      'hu',
      'hr',
      'uk',
      'fil',
    ]) {
      // The list is lazy and capped in height: scroll each row into view.
      await tester.scrollUntilVisible(
        find.byKey(Key('language-option-$code')),
        80,
        scrollable: sheetList,
      );
      expect(find.byKey(Key('language-option-$code')), findsOneWidget);
    }
    await tester.scrollUntilVisible(
      find.text('English'),
      -80,
      scrollable: sheetList,
    );
    for (final name in ['English', 'Čeština', 'Français']) {
      expect(find.text(name), findsOneWidget);
    }

    await tester.tap(find.text('Français'));
    await tester.pumpAndSettle();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(SettingsScreen)),
    );
    expect(container.read(localeProvider), const Locale('fr'));
    expect(container.read(uiLanguageCodeProvider), 'fr');
  });

  testWidgets('on a phone the language sheet leaves room above it and closes', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues({});
    await tester.pumpApp(const SettingsScreen());
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('settings-language-tile')));
    await tester.tap(find.byKey(const Key('settings-language-tile')));
    await tester.pumpAndSettle();

    // Never the whole screen: there is always barrier left to tap away.
    final screen = tester.getSize(find.byType(SettingsScreen)).height;
    final list = find
        .ancestor(
          of: find.byKey(const Key('language-option-system')),
          matching: find.byType(Scrollbar),
        )
        .first;
    expect(tester.getSize(list).height, lessThan(screen * 0.8));
    expect(
      tester.widget<Scrollbar>(list).thumbVisibility,
      isTrue,
    );

    await tester.tap(find.byKey(const Key('language-sheet-close')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('language-sheet-close')), findsNothing);
  });
}
