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

    for (final code in ['system', 'en', 'cs', 'fr', 'it', 'pl']) {
      expect(find.byKey(Key('language-option-$code')), findsOneWidget);
    }
    for (final name in [
      'English',
      'Čeština',
      'Français',
      'Italiano',
      'Polski',
    ]) {
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
}
