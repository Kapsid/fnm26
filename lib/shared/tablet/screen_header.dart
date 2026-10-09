import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/shared/tablet/tablet_text.dart';

/// A tablet screen's heading row: a back arrow when the screen has somewhere
/// to go back to, the title, and an action on the right (a Continue button).
class TabletScreenHeader extends StatelessWidget {
  const TabletScreenHeader({
    required this.title,
    this.onBack,
    this.trailing,
    this.accent,
    super.key,
  });

  static const Key backKey = Key('tabletScreenHeader.back');

  final String title;
  final VoidCallback? onBack;
  final Widget? trailing;

  /// The title's colour; the screen title's own when null.
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          if (onBack != null) ...[
            IconButton(
              key: backKey,
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              icon: const Icon(Icons.arrow_back, color: AppColors.primary),
              onPressed: onBack,
            ),
            const SizedBox(width: AppSpacing.xs),
          ],
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TabletText.screenTitle.copyWith(color: accent),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
