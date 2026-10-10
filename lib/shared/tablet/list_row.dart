import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/shared/tablet/tablet_text.dart';

/// One line of a tablet master list (an achievement category, a challenge
/// tier): an optional icon, the label, a count on the right, and a lit
/// background and edge when it is the one open beside the list.
class TabletListRow extends StatelessWidget {
  const TabletListRow({
    required this.label,
    required this.onTap,
    this.leading,
    this.trailing,
    this.selected = false,
    super.key,
  });

  static const double height = 44;

  final String label;
  final VoidCallback onTap;
  final Widget? leading;

  /// A short count, right-aligned ("3/12").
  final String? trailing;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected
            ? AppColors.surfaceContainerHighest
            : Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: height,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: selected ? AppColors.primary : Colors.transparent,
                  width: 3,
                ),
              ),
            ),
            child: Row(
              children: [
                if (leading case final icon?) ...[
                  icon,
                  const SizedBox(width: AppSpacing.sm),
                ],
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TabletText.cell.copyWith(
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                ),
                if (trailing case final count?)
                  Text(
                    count,
                    style: TabletText.cellNumeric.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
