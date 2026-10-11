import 'package:flutter/widgets.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_typography.dart';

/// The tablet's denser type: one step smaller than the phone's, for tables,
/// panels and the shell. Same faces and colours as [AppTypography].
abstract final class TabletText {
  static const sectionLabel = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 1,
    color: AppColors.outline,
  );
  static const navItem = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 13,
    color: AppColors.onSurfaceVariant,
  );
  static const barTitle = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.onSurface,
  );
  static const barMeta = TextStyle(
    fontFamily: AppFonts.mono,
    fontSize: 12,
    color: AppColors.onSurfaceVariant,
  );
  static const barStrong = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
  );
  static const panelTitle = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.9,
    color: AppColors.onSurfaceVariant,
  );

  /// A tablet screen's own heading, top left of its content ("Squad").
  static const screenTitle = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.onSurface,
  );
  static const panelLink = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );
  static const header = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.outline,
  );
  static const cell = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 13,
    height: 1.2,
    color: AppColors.onSurface,
  );
  static const cellNumeric = TextStyle(
    fontFamily: AppFonts.mono,
    fontSize: 12,
    height: 1.2,
    color: AppColors.onSurface,
  );
}
