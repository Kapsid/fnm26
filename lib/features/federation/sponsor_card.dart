import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/sponsor_label.dart';
import 'package:fnm/features/federation/sponsor_providers.dart';
import 'package:fnm/features/federation/sponsor_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// This season's general sponsor on the finances screen: the brand and its
/// trade, what the deal does and how long it runs, or that there is none.
/// Nothing at all while the round is still open (the hub asks first) or
/// where there is no round (an unmoved campaign run). Pads its own bottom.
class SponsorCard extends ConsumerWidget {
  const SponsorCard({required this.careerId, super.key});

  static const Key cardKey = Key('finances.sponsor');

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final round = ref.watch(sponsorRoundProvider(careerId)).valueOrNull;
    if (round == null || !round.decided) return const SizedBox.shrink();
    final l = AppLocalizations.of(context);
    final muted = AppTypography.labelSmall.copyWith(
      color: AppColors.onSurfaceVariant,
    );
    final o = round.chosen;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        key: cardKey,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l.sponsorTitle,
            style: AppTypography.labelSmall.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            child: o == null
                ? Text(l.sponsorNoneSeason, style: AppTypography.bodyMedium)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.campaign_rounded,
                            size: 20,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              sponsorBrandName(l, o.brand),
                              style: AppTypography.titleMedium,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        sponsorIndustryLabel(l, o.brand),
                        style: muted,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      SponsorEffectChips(offer: o),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        l.sponsorUntilSeasonEnd(
                          sponsorSeasonLabel(round.season),
                        ),
                        style: muted,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

/// The cycle's sponsor, as one line for the end-of-cycle summary. Nothing
/// when the cycle had none.
class SponsorSummaryLine extends ConsumerWidget {
  const SponsorSummaryLine({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final o = ref.watch(sponsorRoundProvider(careerId)).valueOrNull?.chosen;
    if (o == null) return const SizedBox.shrink();
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: Text(
        l.sponsorRolloverLine(sponsorBrandName(l, o.brand)),
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),
    );
  }
}
