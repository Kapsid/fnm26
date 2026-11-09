import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// How strong a club is, as a small row of five stars ([stars] filled):
/// `Player.clubStars`, `ClubService.starsOf`. Nothing at all for 0 (no
/// club known). Read out as "Club strength: 3 of 5".
///
/// Muted on purpose: it sits beside the club's name as a fact about the
/// club, not a rating of the player, and the gold star the squad screens
/// already use is theirs.
class ClubStars extends StatelessWidget {
  const ClubStars(this.stars, {this.size = 12, this.accent = false, super.key});

  final int stars;

  /// Whether the stars are tinted: a strength that was set by hand.
  final bool accent;

  /// Each star's size.
  final double size;

  @override
  Widget build(BuildContext context) {
    if (stars <= 0) return const SizedBox.shrink();
    final n = stars.clamp(1, 5);
    return Semantics(
      label: AppLocalizations.of(context).clubStrengthOf(n),
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < 5; i++)
            Icon(
              i < n ? Icons.star_rounded : Icons.star_outline_rounded,
              size: size,
              color: i < n
                  ? (accent ? AppColors.primary : AppColors.onSurfaceVariant)
                  : AppColors.outline,
            ),
        ],
      ),
    );
  }
}
