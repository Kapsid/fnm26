import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';

/// One step of a pager: a chevron and a word, greyed when there is nowhere to
/// go.
///
/// A popup is a fixed amount of room, and several of them now show more rows
/// than fit in it — a transfer window, a World Cup matchday. Paging them all
/// the same way means a manager learns the control once.
class PagerButton extends StatelessWidget {
  const PagerButton({
    required this.label,
    required this.icon,
    required this.leading,
    required this.onTap,
    super.key,
  });

  final String label;
  final IconData icon;

  /// Whether the chevron sits before the label (going back) or after it.
  final bool leading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = onTap == null
        ? AppColors.onSurfaceVariant.withValues(alpha: 0.4)
        : AppColors.primary;
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        minimumSize: const Size(0, 36),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading) Icon(icon, size: 16, color: color),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(color: color),
          ),
          if (!leading) Icon(icon, size: 16, color: color),
        ],
      ),
    );
  }
}
