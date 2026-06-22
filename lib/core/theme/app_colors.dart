import 'package:flutter/material.dart';

/// Brand colour tokens for Football Nations Manager.
///
/// Derived from the app logo: a dark charcoal pitch with silver "FNM"
/// lettering, paired with a vivid pitch-green as the primary brand accent.
/// Use these tokens via [AppColors]; UI code should read colours from the
/// `ThemeData.colorScheme` rather than referencing these constants directly.
abstract final class AppColors {
  /// Primary brand accent — a vivid pitch green.
  static const Color pitchGreen = Color(0xFF1FA463);

  /// A brighter green for highlights and success states.
  static const Color pitchGreenBright = Color(0xFF2ED47A);

  /// Logo-matching near-black charcoal used for dark surfaces.
  static const Color charcoal = Color(0xFF16181C);

  /// Slightly lighter charcoal for raised surfaces/cards.
  static const Color charcoalRaised = Color(0xFF202329);

  /// Silver used for the "FNM" wordmark and high-emphasis text on dark.
  static const Color silver = Color(0xFFD7DBE0);

  /// Warm amber for warnings / locked (premium) content accents.
  static const Color amber = Color(0xFFF2B100);

  /// Red used for cards/sendings-off and destructive actions.
  static const Color cardRed = Color(0xFFE5484D);
}
