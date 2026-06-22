import 'package:flutter/widgets.dart';

/// Corner-radius tokens (from the `rounded` scale). 1rem = 16px.
abstract final class AppRadii {
  static const double sm = 4; // 0.25rem
  static const double base = 8; // 0.5rem — default for cards/containers
  static const double md = 12; // 0.75rem
  static const double lg = 16; // 1rem
  static const double xl = 24; // 1.5rem
  static const double full = 9999;

  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius baseAll = BorderRadius.all(Radius.circular(base));
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgAll = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius xlAll = BorderRadius.all(Radius.circular(xl));
}

/// Spacing tokens on an 8px baseline grid.
abstract final class AppSpacing {
  static const double base = 8;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24; // gutter-md
  static const double xl = 32;
  static const double xxl = 40; // desktop margin

  /// Side margin on mobile (single-column layout).
  static const double marginMobile = 16;

  /// Side margin on wide layouts.
  static const double marginDesktop = 40;

  /// Minimum touch target (thumb-friendly).
  static const double minHitArea = 44;
}
