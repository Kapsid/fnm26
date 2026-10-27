import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/caps.dart';
import 'package:fnm/domain/services/campaign/campaigns.dart';
import 'package:fnm/features/campaign/campaign_providers.dart';
import 'package:fnm/features/campaign/campaign_record_store.dart';
import 'package:fnm/features/campaign/campaign_stamp.dart';
import 'package:fnm/features/campaign/campaign_ui.dart';
import 'package:fnm/features/campaign/campaigns_screen.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/paywall/paywall_sheet.dart';
import 'package:fnm/features/paywall/save_lock.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

part 'campaign_brief_tablet_layout.dart';

/// A campaign's page, opened from its tile in the list: the story, the goal,
/// what earns each star, the stamp of its best finished run, and the
/// manager's name. Start makes the run and opens its hub; a Pro campaign
/// says on the button that it is part of Unlimited, and opens the paywall
/// for a manager without Pro. When a run of this campaign already exists,
/// Resume, Move to saves (a settled run that may carry on) and Abandon
/// replace Start: there is never a second run. Abandoning brings Start
/// back, to begin afresh.
class CampaignBriefScreen extends ConsumerStatefulWidget {
  const CampaignBriefScreen({required this.campaignId, super.key});

  final String campaignId;

  static const Key tabletLayoutKey = Key('campaignBrief.tabletLayout');
  static const Key startKey = Key('campaignBrief.start');
  static const Key resumeKey = Key('campaignBrief.resume');
  static const Key lockedNoteKey = Key('campaignBrief.lockedNote');
  static const Key abandonKey = Key('campaignBrief.abandon');
  static const Key moveKey = Key('campaignBrief.move');
  static const Key nameKey = Key('campaignBrief.name');

  @override
  ConsumerState<CampaignBriefScreen> createState() =>
      _CampaignBriefScreenState();
}

class _CampaignBriefScreenState extends ConsumerState<CampaignBriefScreen> {
  final _controller = TextEditingController(text: 'Manager');
  bool _starting = false;

  /// Whether the manager has typed in the field: the default name from the
  /// last save never overwrites what he wrote.
  bool _edited = false;

  @override
  void initState() {
    super.initState();
    unawaited(
      ref.read(savesProvider.future).then((saves) {
        if (!mounted || _edited || saves.isEmpty) return;
        final name = saves.first.managerName.trim();
        if (name.isNotEmpty) _controller.text = name;
      }, onError: (_) {}),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Starts a fresh run and opens its hub.
  Future<void> _start(CampaignDef def) async {
    if (_starting) return;
    // A Pro campaign for a manager without Pro: the paywall, never a run.
    if (campaignNeedsPaywall(ref, def)) {
      await showPaywall(context);
      return;
    }
    setState(() => _starting = true);
    // Taken before the awaits: a resize rebuilds this page in the other
    // layout meanwhile, and a manager who has gone elsewhere is left there.
    final router = GoRouter.of(context);
    final service = ref.read(campaignServiceProvider);
    final name = _controller.text;
    try {
      final career = await service.start(def, managerName: name);
      if (router.state.uri.path == Routes.campaignBrief) {
        router.go('${Routes.hub}?careerId=${career.id}');
      }
      // start() signals an existing run with a StateError, by design.
      // ignore: avoid_catching_errors
    } on StateError {
      // A run appeared meanwhile: the page now offers Resume or Abandon.
      ref.invalidate(campaignRunsProvider);
    } finally {
      if (mounted) setState(() => _starting = false);
    }
  }

  /// Throws the run away, once confirmed; the page then offers Start again.
  Future<void> _abandon(int runId) async {
    if (_starting) return;
    final service = ref.read(campaignServiceProvider);
    if (!await confirmAbandonCampaign(context)) return;
    if (!mounted) return;
    setState(() => _starting = true);
    try {
      await service.abandon(runId);
    } finally {
      if (mounted) setState(() => _starting = false);
    }
  }

  /// Moves a settled run into the save slots; says so when they are full.
  Future<void> _move(int runId) async {
    if (_starting) return;
    final service = ref.read(campaignServiceProvider);
    final messenger = ScaffoldMessenger.of(context);
    final l = AppLocalizations.of(context);
    setState(() => _starting = true);
    try {
      final result = await service.moveToSaves(runId);
      if (result == CampaignMoveResult.needsPremium) {
        if (mounted) context.go(saveLockedLocation(runId));
        return;
      }
      if (result == CampaignMoveResult.slotsFull) {
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(l.campaignMoveSlotsFull)));
      }
    } finally {
      if (mounted) setState(() => _starting = false);
    }
  }

  /// The story: flag, name, twist, intro, goal, star rules.
  Widget _story(AppLocalizations l, CampaignDef def) {
    final words = campaignWords(l, def);
    final nation = ref.watch(nationByIdProvider(def.nationId)).valueOrNull;
    final best = ref.watch(campaignBestProvider(def.id)).valueOrNull;
    // A run under way says which stars are in hand so far.
    final run = ref.watch(campaignRunsProvider).valueOrNull?[def.id];
    final progress = run == null
        ? null
        : ref.watch(campaignProgressProvider(run.id)).valueOrNull;
    final earned = progress == null
        ? null
        : progress.settled
        ? progress.stars
        : progress.reached;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                  Text(
                    words.twist,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (best != null) ...[
              const SizedBox(width: AppSpacing.sm),
              CampaignStamp(best: best, size: 80),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(words.intro, style: AppTypography.bodyMedium),
        const SizedBox(height: AppSpacing.md),
        Text(
          l.campaignGoalLabel.capsIn(l.localeName),
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        Text(words.goal, style: AppTypography.titleMedium),
        const SizedBox(height: AppSpacing.md),
        Text(
          l.campaignStarsLabel.capsIn(l.localeName),
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        CampaignStarRules(stars: words.stars, earned: earned),
      ],
    );
  }

  /// The name field and the actions the campaign's run allows.
  Widget _form(AppLocalizations l, CampaignDef def) {
    final run = ref.watch(campaignRunsProvider).valueOrNull?[def.id];
    final settled =
        run != null &&
        (ref.watch(campaignProgressProvider(run.id)).valueOrNull?.settled ??
            false);
    // A Pro campaign the manager cannot start yet says so on the button
    // itself, rather than a Start that turns out to open the paywall.
    final locked = campaignLockedForBuild(ref, def);
    // A run that needs Pro to be opened (a Pro run whose purchase has gone):
    // its Resume and Move say so and open the gate.
    final runLocked = run != null && watchLockedCareerIds(ref).contains(run.id);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (run != null) ...[
          Text(
            l.campaignRunInProgress,
            style: AppTypography.bodyMedium.copyWith(color: AppColors.warning),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        TextField(
          key: CampaignBriefScreen.nameKey,
          controller: _controller,
          onChanged: (_) => _edited = true,
          textInputAction: TextInputAction.done,
          onSubmitted: run == null ? (_) => _start(def) : null,
          style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurface),
          decoration: InputDecoration(
            labelText: l.careerManagerName,
            hintText: l.careerManagerNameHint,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (run == null)
          PrimaryButton(
            key: CampaignBriefScreen.startKey,
            label: locked ? l.campaignPartOfUnlimited : l.campaignStart,
            icon: locked ? Icons.lock : Icons.play_arrow_rounded,
            isLoading: _starting,
            onPressed: _starting ? null : () => _start(def),
          )
        else ...[
          if (runLocked) ...[
            const SaveLockedNote(key: CampaignBriefScreen.lockedNoteKey),
            const SizedBox(height: AppSpacing.sm),
          ],
          PrimaryButton(
            key: CampaignBriefScreen.resumeKey,
            label: l.campaignResume,
            icon: runLocked ? Icons.lock_rounded : Icons.play_arrow_rounded,
            onPressed: _starting
                ? null
                : () => context.go(
                    runLocked
                        ? saveLockedLocation(run.id)
                        : '${Routes.hub}?careerId=${run.id}',
                  ),
          ),
          if (settled && def.canContinue) ...[
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton(
              key: CampaignBriefScreen.moveKey,
              onPressed: _starting
                  ? null
                  : runLocked
                  ? () => context.go(saveLockedLocation(run.id))
                  : () => _move(run.id),
              child: Text(l.campaignMoveToSaves),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            key: CampaignBriefScreen.abandonKey,
            onPressed: _starting ? null : () => _abandon(run.id),
            child: Text(l.campaignAbandon),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final def = ref
        .watch(campaignCatalogProvider)
        .where((c) => c.id == widget.campaignId)
        .firstOrNull;
    if (def == null) {
      // A stale link: back to the list rather than an empty page.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go(Routes.campaigns);
      });
      return const Scaffold(body: SizedBox.shrink());
    }
    if (useTabletLayout(context, ref)) {
      return _CampaignBriefTabletLayout(
        story: _story(l, def),
        form: _form(l, def),
      );
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.go(Routes.campaigns),
        ),
        title: Text(
          l.campaignsTitle,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.marginMobile),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _story(l, def),
              const SizedBox(height: AppSpacing.xl),
              _form(l, def),
            ],
          ),
        ),
      ),
    );
  }
}
