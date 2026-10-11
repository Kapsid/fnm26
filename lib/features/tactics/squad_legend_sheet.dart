import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/services/player/player_traits.dart';
import 'package:fnm/features/player/player_detail_screen.dart'
    show describeTrait;
import 'package:fnm/l10n/app_localizations.dart';

/// What every mark on a squad row means.
///
/// A tester read the form arrows, guessed the flame and could not work out the
/// rest: the star, the tick, and the trait glyphs. None of them is a bad
/// icon - a squad list of a hundred players cannot spell each state out on
/// every line - but a list of marks with nowhere to look them up is a puzzle
/// rather than a density trick.
///
/// The trait half is not restated here. It comes from [describeTrait], the
/// same mapping the player screen prints, so the legend cannot drift into
/// describing an icon the list no longer uses.
Future<void> showSquadLegend(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surfaceContainer,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => const _SquadLegendSheet(),
    );

class _SquadLegendSheet extends StatelessWidget {
  const _SquadLegendSheet();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.marginMobile,
          0,
          AppSpacing.marginMobile,
          AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l.squadLegendTitle,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Selection first: it is the thing a manager scans the list FOR.
            _Entry(
              icon: Icons.star_rounded,
              color: AppColors.primary,
              label: l.squadLegendStarting,
            ),
            _Entry(
              icon: Icons.check_circle,
              color: AppColors.positive,
              label: l.squadLegendCalledUp,
            ),
            _Entry(
              icon: Icons.trending_up_rounded,
              color: AppColors.positive,
              label: l.squadLegendRatingUp,
            ),
            _Entry(
              icon: Icons.trending_down_rounded,
              color: AppColors.error,
              label: l.squadLegendRatingDown,
            ),
            _Entry(
              icon: Icons.personal_injury,
              color: AppColors.warning,
              label: l.squadLegendInjured,
            ),
            _Entry(
              icon: Icons.gavel_rounded,
              color: AppColors.error,
              label: l.squadLegendSuspended,
            ),

            const SizedBox(height: AppSpacing.md),
            Text(
              l.squadLegendTraits,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            for (final t in PlayerTrait.values)
              () {
                final (icon, name, blurb, good) = describeTrait(l, t);
                return _Entry(
                  icon: icon,
                  color: good ? AppColors.positive : AppColors.warning,
                  label: name,
                  blurb: blurb,
                );
              }(),
          ],
        ),
      ),
    );
  }
}

class _Entry extends StatelessWidget {
  const _Entry({
    required this.icon,
    required this.color,
    required this.label,
    this.blurb,
  });

  final IconData icon;
  final Color color;
  final String label;
  final String? blurb;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            child: Icon(icon, size: 15, color: color),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTypography.bodySmall),
                if (blurb case final b?)
                  Text(
                    b,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
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
