import 'package:flutter/material.dart';

/// "Pro Pitch Executive" colour tokens — a restricted, high-contrast dark
/// palette of brushed-steel silvers over a near-black industrial canvas.
///
/// UI code should read colours from `Theme.of(context).colorScheme`; these
/// raw tokens exist to build that scheme (and for the few brand-specific
/// surfaces the scheme doesn't cover, e.g. dividers and the active-row bar).
abstract final class AppColors {
  // Surfaces
  static const surface = Color(0xFF121416);
  static const surfaceDim = Color(0xFF121416);
  static const surfaceBright = Color(0xFF38393C);
  static const surfaceContainerLowest = Color(0xFF0C0E10);
  static const surfaceContainerLow = Color(0xFF1A1C1E);
  static const surfaceContainer = Color(0xFF1E2022);
  static const surfaceContainerHigh = Color(0xFF282A2C);
  static const surfaceContainerHighest = Color(0xFF333537);
  static const surfaceVariant = Color(0xFF333537);

  // On-surface text
  static const onSurface = Color(0xFFE2E2E5);
  static const onSurfaceVariant = Color(0xFFC4C6CB);

  // Inverse
  static const inverseSurface = Color(0xFFE2E2E5);
  static const inverseOnSurface = Color(0xFF2F3133);
  static const inversePrimary = Color(0xFF565F69);

  // Outlines
  static const outline = Color(0xFF8E9195);
  static const outlineVariant = Color(0xFF44474B);

  // Primary (metallic silver)
  static const surfaceTint = Color(0xFFBEC8D3);
  static const primary = Color(0xFFC3CDD9);
  static const onPrimary = Color(0xFF28313A);
  static const primaryContainer = Color(0xFFA8B2BD);
  static const onPrimaryContainer = Color(0xFF3B454E);
  static const primaryFixed = Color(0xFFDAE4EF);
  static const primaryFixedDim = Color(0xFFBEC8D3);
  static const onPrimaryFixed = Color(0xFF131D25);
  static const onPrimaryFixedVariant = Color(0xFF3E4851);

  // Secondary
  static const secondary = Color(0xFFC6C6C9);
  static const onSecondary = Color(0xFF2F3133);
  static const secondaryContainer = Color(0xFF454749);
  static const onSecondaryContainer = Color(0xFFB4B5B7);
  static const secondaryFixed = Color(0xFFE2E2E5);
  static const secondaryFixedDim = Color(0xFFC6C6C9);
  static const onSecondaryFixed = Color(0xFF1A1C1E);
  static const onSecondaryFixedVariant = Color(0xFF454749);

  // Tertiary
  static const tertiary = Color(0xFFC9CCD3);
  static const onTertiary = Color(0xFF2D3136);
  static const tertiaryContainer = Color(0xFFAEB1B7);
  static const onTertiaryContainer = Color(0xFF404449);
  static const tertiaryFixed = Color(0xFFE0E2E9);
  static const tertiaryFixedDim = Color(0xFFC3C7CD);
  static const onTertiaryFixed = Color(0xFF181C21);
  static const onTertiaryFixedVariant = Color(0xFF43474C);

  // Error
  static const error = Color(0xFFFFB4AB);
  static const onError = Color(0xFF690005);
  static const errorContainer = Color(0xFF93000A);
  static const onErrorContainer = Color(0xFFFFDAD6);

  /// Positive accent (qualification / advancing positions).
  static const positive = Color(0xFF7FD1A6);

  /// Caution accent (a best-third place that may advance via the play-off).
  static const warning = Color(0xFFE7A85A);

  // --- Rating / performance marks (match & player ratings) -----------------
  // One scale, used app-wide. Previously these three hexes were copy-pasted
  // into every screen that drew a rating pill; read [ratingColor] instead.
  /// A strong performance (rating ≥ 7.5).
  static const ratingGreat = Color(0xFF2E9E5B);

  /// A solid performance (rating ≥ 6.5).
  static const ratingGood = Color(0xFF4C86C6);

  /// A poor performance (rating < 5.5).
  static const ratingPoor = Color(0xFFD64545);

  /// Parses a `#RRGGBB` (or `#AARRGGBB`) hex string — e.g. a nation's team
  /// colour — into a [Color]. Falls back to [primary] on a malformed value.
  static Color hex(String s) {
    var h = s.replaceAll('#', '').trim();
    if (h.length == 6) h = 'FF$h';
    final v = int.tryParse(h, radix: 16);
    return v == null ? primary : Color(v);
  }

  /// A match rating's colour on the shared 0–10 scale; 5.5–6.5 reads neutral.
  static Color ratingColor(double r) {
    if (r >= 7.5) return ratingGreat;
    if (r >= 6.5) return ratingGood;
    if (r >= 5.5) return onSurfaceVariant;
    return ratingPoor;
  }

  // --- Podium / medals ------------------------------------------------------
  // Single source for gold/silver/bronze/platinum; the same four hexes had
  // drifted apart across the medal, achievement and challenge screens.
  static const medalGold = Color(0xFFEFC94C);
  static const medalSilver = Color(0xFFBFC7CE);
  static const medalBronze = Color(0xFFCD8B62);
  static const medalPlatinum = Color(0xFF8AD9D2);

  // --- Movement (rank moved up / down since the campaign began) ------------
  static const up = ratingGreat;
  static const down = ratingPoor;

  // Brand extras (not part of ColorScheme)
  /// Hairline divider — silver-tinted at ~10% opacity (per the data-list spec).
  static Color get divider => onSurface.withValues(alpha: 0.10);

  /// The vertical "active" bar on a selected data-list row.
  static const Color activeBar = primary;

  /// The full dark Material 3 colour scheme for the app.
  static const ColorScheme scheme = ColorScheme(
    brightness: Brightness.dark,
    primary: primary,
    onPrimary: onPrimary,
    primaryContainer: primaryContainer,
    onPrimaryContainer: onPrimaryContainer,
    primaryFixed: primaryFixed,
    primaryFixedDim: primaryFixedDim,
    onPrimaryFixed: onPrimaryFixed,
    onPrimaryFixedVariant: onPrimaryFixedVariant,
    secondary: secondary,
    onSecondary: onSecondary,
    secondaryContainer: secondaryContainer,
    onSecondaryContainer: onSecondaryContainer,
    secondaryFixed: secondaryFixed,
    secondaryFixedDim: secondaryFixedDim,
    onSecondaryFixed: onSecondaryFixed,
    onSecondaryFixedVariant: onSecondaryFixedVariant,
    tertiary: tertiary,
    onTertiary: onTertiary,
    tertiaryContainer: tertiaryContainer,
    onTertiaryContainer: onTertiaryContainer,
    tertiaryFixed: tertiaryFixed,
    tertiaryFixedDim: tertiaryFixedDim,
    onTertiaryFixed: onTertiaryFixed,
    onTertiaryFixedVariant: onTertiaryFixedVariant,
    error: error,
    onError: onError,
    errorContainer: errorContainer,
    onErrorContainer: onErrorContainer,
    surface: surface,
    onSurface: onSurface,
    surfaceDim: surfaceDim,
    surfaceBright: surfaceBright,
    surfaceContainerLowest: surfaceContainerLowest,
    surfaceContainerLow: surfaceContainerLow,
    surfaceContainer: surfaceContainer,
    surfaceContainerHigh: surfaceContainerHigh,
    surfaceContainerHighest: surfaceContainerHighest,
    onSurfaceVariant: onSurfaceVariant,
    outline: outline,
    outlineVariant: outlineVariant,
    inverseSurface: inverseSurface,
    onInverseSurface: inverseOnSurface,
    inversePrimary: inversePrimary,
    surfaceTint: surfaceTint,
  );
}
