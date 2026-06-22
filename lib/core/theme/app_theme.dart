import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';

/// Centralised Material 3 theming for the app.
///
/// Both a light and dark theme are derived from the same pitch-green seed so
/// the brand reads consistently. The dark theme is the primary experience
/// (matching the logo); the light theme is provided for system preference.
abstract final class AppTheme {
  /// Shared shape used for cards and large surfaces.
  static const _cardRadius = 16.0;

  /// The dark theme — the app's default look.
  static ThemeData get dark => _build(Brightness.dark);

  /// The light theme — used when the device prefers light mode.
  static ThemeData get light => _build(Brightness.light);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.pitchGreen,
      brightness: brightness,
      surface: isDark ? AppColors.charcoal : null,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      cardTheme: CardThemeData(
        elevation: 0,
        color: isDark ? AppColors.charcoalRaised : scheme.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_cardRadius),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
