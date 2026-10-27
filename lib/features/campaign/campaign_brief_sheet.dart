import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/caps.dart';
import 'package:fnm/features/campaign/campaign_providers.dart';
import 'package:fnm/features/campaign/campaign_ui.dart';
import 'package:fnm/features/campaign/campaigns_screen.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/adaptive_sheet.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// Opens the full brief of the campaign run [careerId] is, from inside the
/// run: the story, the goal and every star with whether it is earned so far.
///
/// Read only. The brief screen is where a run is started, resumed, moved or
/// abandoned; from the hub the manager is already in the run, so none of that
/// is offered here and nothing can be reset. A bottom sheet on a phone, a
/// dialog on a tablet ([showAdaptiveSheet]).
Future<void> showCampaignBriefSheet(BuildContext context, int careerId) =>
    showAdaptiveSheet<void>(
      context: context,
      backgroundColor: AppColors.surfaceContainer,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => CampaignBriefSheet(careerId: careerId),
    );

/// The body of [showCampaignBriefSheet].
class CampaignBriefSheet extends ConsumerWidget {
  const CampaignBriefSheet({required this.careerId, super.key});

  final int careerId;

  static const Key sheetKey = Key('campaign.briefSheet');
  static const Key soFarKey = Key('campaign.briefSheet.soFar');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final progress = ref.watch(campaignProgressProvider(careerId)).valueOrNull;
    if (progress == null) {
      return const Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    final def = progress.def;
    final words = campaignWords(l, def);
    final nation = ref.watch(nationByIdProvider(def.nationId)).valueOrNull;
    // The verdict's grade once settled, else where the run stands now.
    final earned = progress.settled ? progress.stars : progress.reached;
    final label = AppTypography.labelSmall.copyWith(
      color: AppColors.onSurfaceVariant,
    );
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        key: sheetKey,
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
            Row(
              children: [
                if (nation != null) ...[
                  FlagDisc(nation.code),
                  const SizedBox(width: AppSpacing.md),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(words.title, style: AppTypography.headlineMedium),
                      Text(words.twist, style: label),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(words.intro, style: AppTypography.bodyMedium),
            const SizedBox(height: AppSpacing.md),
            Text(l.campaignGoalLabel.capsIn(l.localeName), style: label),
            Text(words.goal, style: AppTypography.titleMedium),
            const SizedBox(height: AppSpacing.md),
            Text(l.campaignStarsLabel.capsIn(l.localeName), style: label),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l.campaignStarsSoFar(earned, words.stars.length),
              key: soFarKey,
              style: AppTypography.bodyMedium.copyWith(
                color: earned > 0 ? AppColors.warning : AppColors.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            CampaignStarRules(stars: words.stars, earned: earned),
          ],
        ),
      ),
    );
  }
}
