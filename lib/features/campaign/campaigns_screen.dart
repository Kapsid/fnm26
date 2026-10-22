import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/caps.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/services/campaign/campaigns.dart';
import 'package:fnm/features/campaign/campaign_providers.dart';
import 'package:fnm/features/campaign/campaign_record_store.dart';
import 'package:fnm/features/campaign/campaign_stamp.dart';
import 'package:fnm/features/campaign/campaign_ui.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/paywall/paywall_sheet.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

part 'campaigns_tablet_layout.dart';

/// The hand-built scenarios: one card each, with the stamp the manager has
/// earned there, and the way into a run (start, resume, abandon, keep).
class CampaignsScreen extends ConsumerWidget {
  const CampaignsScreen({super.key});

  static const Key tabletLayoutKey = Key('campaigns.tabletLayout');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (useTabletLayout(context, ref)) return const _CampaignsTabletLayout();
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.go(Routes.home),
        ),
        title: Text(
          l.campaignsTitle,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.marginMobile),
        itemCount: Campaigns.all.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (context, i) => CampaignCard(def: Campaigns.all[i]),
      ),
    );
  }
}

/// One campaign: flag, name, twist, goal, what earns each star, difficulty,
/// the Free or Pro badge and the stamp, with the actions its run allows.
///
/// A free campaign never opens the paywall. A Pro one does, from Start, for a
/// manager without Pro: he is never handed a run he could not have bought.
class CampaignCard extends ConsumerStatefulWidget {
  const CampaignCard({required this.def, super.key});

  final CampaignDef def;

  static const Key startKey = Key('campaign.start');
  static const Key resumeKey = Key('campaign.resume');
  static const Key abandonKey = Key('campaign.abandon');
  static const Key moveKey = Key('campaign.move');
  static const Key proBadgeKey = Key('campaign.proBadge');

  @override
  ConsumerState<CampaignCard> createState() => _CampaignCardState();
}

class _CampaignCardState extends ConsumerState<CampaignCard> {
  /// A move or an abandon is running: the buttons wait for it.
  bool _busy = false;

  Future<void> _abandon(Career run) async {
    if (_busy) return;
    final service = ref.read(campaignServiceProvider);
    if (!await confirmAbandonCampaign(context)) return;
    if (!mounted) return;
    setState(() => _busy = true);
    try {
      await service.abandon(run.id);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _move(Career run) async {
    if (_busy) return;
    final service = ref.read(campaignServiceProvider);
    final messenger = ScaffoldMessenger.of(context);
    final l = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      final result = await service.moveToSaves(run.id);
      if (result == CampaignMoveResult.slotsFull) {
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(l.campaignMoveSlotsFull)));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final def = widget.def;
    final words = campaignWords(l, def);
    final difficulty = campaignDifficulty(l, def);
    final nation = ref.watch(nationByIdProvider(def.nationId)).valueOrNull;
    final best = ref.watch(campaignBestProvider(def.id)).valueOrNull;
    final run = ref.watch(campaignRunsProvider).valueOrNull?[def.id];
    final settled =
        run != null &&
        (ref.watch(campaignProgressProvider(run.id)).valueOrNull?.settled ??
            false);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (nation != null) ...[
                FlagDisc(nation.code, size: 48),
                const SizedBox(width: AppSpacing.md),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(words.title, style: AppTypography.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      words.twist,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.xs,
                      children: [
                        if (def.needsPro)
                          // A lock, not the word: it marks a Pro campaign for
                          // everyone; the word is its screen-reader label.
                          _Badge(
                            key: CampaignCard.proBadgeKey,
                            label: l.campaignPro,
                            color: AppColors.warning,
                            icon: Icons.lock,
                          )
                        else
                          _Badge(
                            label: l.campaignFree,
                            color: AppColors.positive,
                          ),
                        _Badge(
                          label: difficulty.label,
                          color: difficulty.color,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (best != null) ...[
                const SizedBox(width: AppSpacing.sm),
                CampaignStamp(best: best),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            l.campaignGoalLabel.capsIn(l.localeName),
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          Text(words.goal, style: AppTypography.bodyMedium),
          const SizedBox(height: AppSpacing.sm),
          CampaignStarRules(stars: words.stars),
          const SizedBox(height: AppSpacing.md),
          _actions(l, run, settled),
        ],
      ),
    );
  }

  Widget _actions(AppLocalizations l, Career? run, bool settled) {
    if (run == null) {
      // A Pro campaign the manager cannot start yet says so on the button
      // itself, rather than a Start that turns out to open the paywall.
      final locked = campaignNeedsPaywall(ref, widget.def);
      return PrimaryButton(
        key: CampaignCard.startKey,
        label: locked ? l.campaignPartOfUnlimited : l.campaignStart,
        icon: locked ? Icons.lock : Icons.play_arrow_rounded,
        onPressed: () {
          if (locked) {
            unawaited(showPaywall(context));
            return;
          }
          context.go('${Routes.campaignBrief}?id=${widget.def.id}');
        },
      );
    }
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        FilledButton(
          key: CampaignCard.resumeKey,
          onPressed: () => context.go('${Routes.hub}?careerId=${run.id}'),
          child: Text(l.campaignResume),
        ),
        if (settled && widget.def.canContinue)
          OutlinedButton(
            key: CampaignCard.moveKey,
            onPressed: _busy ? null : () => _move(run),
            child: Text(l.campaignMoveToSaves),
          ),
        TextButton(
          key: CampaignCard.abandonKey,
          onPressed: _busy ? null : () => _abandon(run),
          child: Text(l.campaignAbandon),
        ),
      ],
    );
  }
}

/// The three star conditions, one star per line.
class CampaignStarRules extends StatelessWidget {
  const CampaignStarRules({required this.stars, super.key});

  final List<String> stars;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < stars.length; i++)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 54,
                  child: Row(
                    children: [
                      for (var s = 0; s <= i; s++)
                        const Icon(
                          Icons.star_rounded,
                          size: 14,
                          color: AppColors.warning,
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: Text(stars[i], style: AppTypography.bodySmall),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    required this.color,
    this.icon,
    super.key,
  });

  final String label;
  final Color color;

  /// Shown instead of [label], which then only labels it for a screen reader.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: AppRadii.smAll,
        border: Border.all(color: color),
      ),
      child: icon == null
          ? Text(label, style: AppTypography.labelSmall.copyWith(color: color))
          : Semantics(
              label: label,
              excludeSemantics: true,
              child: Icon(icon, size: 14, color: color),
            ),
    );
  }
}
