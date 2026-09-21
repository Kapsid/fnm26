import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// The line above an all-time scorer chart: what the chart is, and what the
/// badge on some of its rows means.
///
/// A widget of its own rather than a Row buried in a screen, so the one thing
/// that can go wrong with it — running off the side of a phone in a language
/// that spells both halves longer than English does — can be pumped and
/// proven instead of eyeballed.
class AllTimeScorersLegend extends StatelessWidget {
  const AllTimeScorersLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Row(
      children: [
        // The heading shares the row with the legend, which is the half that
        // must be printed whole: a badge nobody has explained is worse than a
        // heading nobody needed.
        //
        // That was the excuse for letting the heading ellipsise, and it was
        // not good enough — "NEJLEPSI STRELCI HIST..." is not a heading. The
        // Czech gives up its first word instead ("STRELCI HISTORIE"), and
        // both halves of the row are now printed in full at 360 and at 400.
        Expanded(
          child: Text(
            l.tourCupAllTimeScorers,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelSmall.copyWith(color: AppColors.primary),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        const ActiveBadge(),
        const SizedBox(width: AppSpacing.xs),
        Text(
          l.tourCupStillActive,
          maxLines: 1,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
