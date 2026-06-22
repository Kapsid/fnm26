import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';

/// A row in a data list: optional leading widget, a title (+ optional
/// subtitle), an optional trailing widget, a 1px silver-tinted bottom divider,
/// and — when [selected] — a vertical primary "active" bar on the far left.
class AppListRow extends StatelessWidget {
  const AppListRow({
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.selected = false,
    this.showDivider = true,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool selected;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final row = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm + 2,
      ),
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: AppSpacing.md),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AppSpacing.md),
            trailing!,
          ],
        ],
      ),
    );

    // The active bar occupies the far left when selected.
    final content = Row(
      children: [
        Container(
          width: 3,
          height: AppSpacing.minHitArea + 4,
          color: selected ? AppColors.activeBar : Colors.transparent,
        ),
        Expanded(child: row),
      ],
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: selected ? AppColors.surfaceContainerHigh : Colors.transparent,
        border: showDivider
            ? Border(bottom: BorderSide(color: AppColors.divider))
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(onTap: onTap, child: content),
      ),
    );
  }
}
