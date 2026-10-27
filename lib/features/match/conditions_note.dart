import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/services/match/match_conditions.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// The altitude and heat of the ground, said out loud under it: who the thin
/// air will tire, how hot it will be, and (when the manager's own side is
/// the one that will fade) a word to plan the changes early.
///
/// Every line reads the same [MatchConditions] the engine plays the match
/// with, so it never promises an effect the match does not have. Nothing at
/// all is shown at sea level in temperate weather.
class ConditionsNote extends StatelessWidget {
  const ConditionsNote({
    required this.conditions,
    required this.playerIsHome,
    super.key,
  });

  final MatchConditions conditions;

  /// Whether the manager's side is the home one (so which drain is his).
  final bool playerIsHome;

  /// From this much extra drain the manager is told to plan his changes.
  static const double adviseFrom = 0.2;

  /// The lines to show, in order; empty when the conditions change nothing.
  static List<(IconData, String)> linesFor(
    AppLocalizations l,
    MatchConditions c, {
    required bool playerIsHome,
  }) {
    final mineAlt = playerIsHome ? c.homeFeelsAltitude : c.awayFeelsAltitude;
    final theirsAlt = playerIsHome ? c.awayFeelsAltitude : c.homeFeelsAltitude;
    final mine = (playerIsHome ? c.homeDrain : c.awayDrain) - 1;
    return [
      if (c.showsAltitude)
        (
          Icons.terrain_outlined,
          mineAlt && theirsAlt
              ? l.matchAltitudeBothTire(c.altitude)
              : mineAlt
              ? l.matchAltitudeYouTire(c.altitude)
              : theirsAlt
              ? l.matchAltitudeOpponentsTire(c.altitude)
              : l.matchAltitudeUsedTo(c.altitude),
        ),
      if (c.isHot)
        (Icons.thermostat_outlined, l.matchHeatExpected(c.temperature)),
      if (mine >= adviseFrom)
        (Icons.swap_horiz_rounded, l.matchConditionsAdvice),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lines = linesFor(l, conditions, playerIsHome: playerIsHome);
    if (lines.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (icon, text) in lines)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, size: 16, color: AppColors.onSurfaceVariant),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      text,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
