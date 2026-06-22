import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';

/// A small dark-pill container with a high-contrast border, used for tactical
/// labels like player positions (`ST`, `GK`). Monospace text gives the
/// "tactical read-out" feel.
class TacticalChip extends StatelessWidget {
  const TacticalChip(
    this.label, {
    this.emphasized = false,
    super.key,
  });

  /// The short label (typically a position code).
  final String label;

  /// When `true`, uses the primary accent border/text to mark a highlighted
  /// chip (e.g. the player's natural position).
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final borderColor = emphasized ? AppColors.primary : AppColors.outline;
    final textColor = emphasized ? AppColors.primary : AppColors.onSurface;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: AppRadii.smAll,
        border: Border.all(color: borderColor),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTypography.labelSmall.copyWith(color: textColor),
      ),
    );
  }
}
