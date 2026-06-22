import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';

/// Primary call-to-action button: a brushed silver-to-steel vertical gradient
/// with a 1px metal stroke and dark text, per the "Pro Pitch Executive" button
/// spec. Centralised so every screen's primary action looks identical (DRY).
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    super.key,
  });

  /// Button text.
  final String label;

  /// Tap handler. When `null` (or while [isLoading]) the button is disabled.
  final VoidCallback? onPressed;

  /// Optional leading icon.
  final IconData? icon;

  /// When `true`, shows a spinner and disables interaction.
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isLoading;

    final child = isLoading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: AppColors.onPrimary,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: AppColors.onPrimary),
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(
                label,
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.onPrimary,
                ),
              ),
            ],
          );

    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadii.mdAll,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: AppRadii.mdAll,
          child: Ink(
            height: AppSpacing.minHitArea + 8,
            decoration: BoxDecoration(
              borderRadius: AppRadii.mdAll,
              border: Border.all(color: AppColors.primaryFixed),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.primaryFixed, AppColors.primaryContainer],
              ),
            ),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}
