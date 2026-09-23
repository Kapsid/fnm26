import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// The mark an all-time chart puts on a player who is still playing.
///
/// An all-time list mixes men you can still pick with legends who retired
/// cycles ago, and without a mark the two read the same. Every such list uses
/// this one badge, so "active" looks the same wherever it is said — and means
/// the same thing: his own career has not ended yet
/// (`PlayerLifecycle.hasRetiredAt`), not a flat age cut-off.
///
/// Deliberately small: it sits between a name that may already be ellipsizing
/// and a tally, on a 360px phone, in a language that runs longer than English.
class ActiveBadge extends StatelessWidget {
  const ActiveBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.positive.withValues(alpha: 0.15),
        borderRadius: AppRadii.smAll,
      ),
      child: Text(
        AppLocalizations.of(context).recordsActive,
        maxLines: 1,
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.positive,
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
