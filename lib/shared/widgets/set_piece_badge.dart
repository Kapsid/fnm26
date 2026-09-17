import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';

/// A round set-piece toggle: filled in the accent when this player is the
/// current taker, an outline otherwise.
///
/// Shared because the same badge appears in two places that must agree — the
/// tactics screen before kick-off and the in-match editor during the game. A
/// manager who changes his penalty taker at 70 minutes should be tapping the
/// control he already knows.
class SetPieceBadge extends StatelessWidget {
  const SetPieceBadge({
    required this.icon,
    required this.active,
    required this.tooltip,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final bool active;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? AppColors.primary.withValues(alpha: 0.18) : null,
            shape: BoxShape.circle,
            border: Border.all(
              color: active ? AppColors.primary : AppColors.outlineVariant,
            ),
          ),
          child: Icon(
            icon,
            size: 18,
            color: active ? AppColors.primary : AppColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
