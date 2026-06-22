import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';

/// A labelled attribute bar (e.g. a player's `Pace 88`). The value is rendered
/// in monospace for the "tactical read-out" feel, with a filled track showing
/// the value relative to [max].
class StatBar extends StatelessWidget {
  const StatBar({
    required this.label,
    required this.value,
    this.max = 99,
    super.key,
  });

  final String label;
  final int value;
  final int max;

  @override
  Widget build(BuildContext context) {
    final fraction = (value / max).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
            Text(
              '$value',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        ClipRRect(
          borderRadius: AppRadii.smAll,
          child: Stack(
            children: [
              Container(height: 6, color: AppColors.surfaceContainerHighest),
              FractionallySizedBox(
                widthFactor: fraction,
                child: Container(height: 6, color: AppColors.primary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
