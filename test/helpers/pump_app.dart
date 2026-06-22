import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';

/// Shared test harness for pumping a widget inside the app's Riverpod scope
/// and theme. Keeps widget tests terse and consistent (DRY).
extension PumpApp on WidgetTester {
  /// Pumps [widget] wrapped in a [ProviderScope] + themed [MaterialApp].
  ///
  /// Pass [overrides] to swap providers for fakes/mocks in a given test.
  Future<void> pumpApp(
    Widget widget, {
    List<Override> overrides = const [],
  }) {
    return pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: MaterialApp(
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.dark,
          home: widget,
        ),
      ),
    );
  }
}
