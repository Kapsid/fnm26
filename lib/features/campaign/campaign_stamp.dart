import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// The passport stamp on a campaign card: what the manager has earned there.
///
/// [best] is the campaign's record: null never finished (nothing is drawn),
/// 0 failed, 1..3 conquered with that many stars. Tilted, with a double ring,
/// in the theme's own green or red, so it reads as ink pressed on the card
/// rather than a badge printed on it.
class CampaignStamp extends StatelessWidget {
  const CampaignStamp({required this.best, this.size = 96, super.key});

  final int? best;
  final double size;

  static const Key stampKey = Key('campaign.stamp');

  @override
  Widget build(BuildContext context) {
    final best = this.best;
    if (best == null) return const SizedBox.shrink();
    final l = AppLocalizations.of(context);
    final conquered = best > 0;
    final ink = conquered ? AppColors.positive : AppColors.error;
    final word = conquered ? l.campaignStampConquered : l.campaignStampFailed;
    final stars = best.clamp(0, 3);
    return Transform.rotate(
      angle: -12 * math.pi / 180,
      child: Container(
        key: stampKey,
        width: size,
        height: size,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: ink, width: 3),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: size * 0.08),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: ink, width: 1.2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (stars > 0)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 0; i < stars; i++)
                      Icon(
                        Icons.star_rounded,
                        size: size * 0.2,
                        color: ink,
                      ),
                  ],
                ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  word,
                  maxLines: 1,
                  style: AppTypography.labelMedium.copyWith(
                    color: ink,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              if (stars == 0)
                Icon(Icons.close_rounded, size: size * 0.22, color: ink),
            ],
          ),
        ),
      ),
    );
  }
}
