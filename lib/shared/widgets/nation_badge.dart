import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';

/// A national-team emblem: a circular "enamel badge" (with a subtle lens
/// highlight) housed inside a rounded-square container to keep a consistent
/// structural grid.
///
/// Until real flag artwork is bundled it falls back to the nation [code]; pass
/// a [flag] widget (e.g. an `Image`) to show the actual flag.
class NationBadge extends StatelessWidget {
  const NationBadge({
    required this.code,
    this.flag,
    this.size = 40,
    super.key,
  });

  /// Short country code shown when no [flag] is supplied (e.g. `BRA`).
  final String code;

  /// Optional flag artwork, clipped to the circle.
  final Widget? flag;

  /// Outer container side length.
  final double size;

  @override
  Widget build(BuildContext context) {
    final circleSize = size * 0.82;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: AppRadii.smAll,
        border: Border.all(color: AppColors.outlineVariant),
      ),
      alignment: Alignment.center,
      child: ClipOval(
        child: Container(
          width: circleSize,
          height: circleSize,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            // "Lens" highlight: a soft radial sheen from the top-left.
            gradient: RadialGradient(
              center: Alignment(-0.4, -0.5),
              radius: 1,
              colors: [AppColors.surfaceBright, AppColors.surfaceContainerHigh],
            ),
          ),
          child: flag ??
              Text(
                code.toUpperCase(),
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurface,
                  fontSize: circleSize * 0.3,
                ),
              ),
        ),
      ),
    );
  }
}
