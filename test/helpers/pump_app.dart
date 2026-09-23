import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// Shared test harness for pumping a widget inside the app's Riverpod scope
/// and theme. Keeps widget tests terse and consistent (DRY).
extension PumpApp on WidgetTester {
  /// Pumps [widget] wrapped in a [ProviderScope] + themed [MaterialApp].
  ///
  /// Pass [overrides] to swap providers for fakes/mocks in a given test, and
  /// [locale] to pump in a language other than the default — which a width
  /// test has to, because Czech is the longer language nearly everywhere.
  Future<void> pumpApp(
    Widget widget, {
    List<Override> overrides = const [],
    Locale? locale,
  }) {
    return pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: MaterialApp(
          locale: locale,
          theme: AppTheme.theme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: widget,
        ),
      ),
    );
  }
}
