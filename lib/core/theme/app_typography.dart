import 'package:flutter/material.dart';

/// Bundled font families (variable TTFs; weight drives the `wght` axis).
abstract final class AppFonts {
  /// Primary sans — sharp, technical, highly legible on dark.
  static const sans = 'Hanken Grotesk';

  /// Monospace for technical read-outs (stats, timers, positions).
  static const mono = 'JetBrains Mono';
}

/// "Pro Pitch Executive" type scale.
///
/// Sizes/weights/line-heights/tracking come straight from the design tokens.
/// `em` letter-spacing is converted to logical pixels (`em × fontSize`) and
/// line-heights to Flutter's `height` multiplier (`lineHeightPx ÷ fontSize`).
abstract final class AppTypography {
  static const displayLarge = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 48,
    fontWeight: FontWeight.w800,
    height: 56 / 48,
    letterSpacing: -0.96, // -0.02em × 48
  );

  static const headlineLarge = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 40 / 32,
  );

  /// Mobile-tuned variant of [headlineLarge] (smaller, for narrow screens).
  static const headlineLargeMobile = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 36 / 28,
  );

  static const headlineMedium = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 32 / 24,
  );

  static const titleMedium = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 24 / 18,
  );

  static const bodyLarge = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 28 / 18,
  );

  static const bodyMedium = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
  );

  static const bodySmall = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 18 / 13,
  );

  /// Monospace "tactical read-out" label (positions, stat values, timers).
  static const labelMedium = TextStyle(
    fontFamily: AppFonts.mono,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 20 / 14,
    letterSpacing: 0.7, // 0.05em × 14
  );

  /// Button text — sans, semibold, slightly tracked for a "machined" feel.
  static const labelLarge = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 20 / 16,
    letterSpacing: 0.2,
  );

  /// Small monospace label (e.g. compact chips).
  static const labelSmall = TextStyle(
    fontFamily: AppFonts.mono,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16 / 12,
    letterSpacing: 0.6,
  );

  /// The assembled [TextTheme] used by the app's [ThemeData].
  static const TextTheme textTheme = TextTheme(
    displayLarge: displayLarge,
    displayMedium: headlineLarge,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall: titleMedium,
    titleLarge: headlineMedium,
    titleMedium: titleMedium,
    titleSmall: bodyMedium,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );
}
