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
import 'package:fnm/features/campaign/campaign_ui.dart';
import 'package:fnm/features/campaign/campaigns_screen.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/paywall/paywall_sheet.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

part 'campaign_brief_tablet_layout.dart';

/// A campaign before it starts: the story, the goal, what earns each star,
/// and the manager's name. Start makes the run and opens its hub. When a run
/// of this campaign already exists, Resume or Abandon (which starts afresh)
/// replace Start: there is never a second run.
class CampaignBriefScreen extends ConsumerStatefulWidget {
  const CampaignBriefScreen({required this.campaignId, super.key});

  final String campaignId;

  static const Key tabletLayoutKey = Key('campaignBrief.tabletLayout');
  static const Key startKey = Key('campaignBrief.start');
  static const Key resumeKey = Key('campaignBrief.resume');
  static const Key abandonKey = Key('campaignBrief.abandon');
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

  /// Starts a fresh run and opens its hub. With [replacing] set, the run in
  /// progress is deleted first (the manager has confirmed).
  Future<void> _start(CampaignDef def, {int? replacing}) async {
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
      if (replacing != null) await service.abandon(replacing);
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

  Future<void> _abandonAndRestart(CampaignDef def, int runId) async {
    if (!await confirmAbandonCampaign(context)) return;
    await _start(def, replacing: runId);
  }

  /// The story: flag, name, twist, intro, goal, star rules.
  Widget _story(AppLocalizations l, CampaignDef def) {
    final words = campaignWords(l, def);
    final nation = ref.watch(nationByIdProvider(def.nationId)).valueOrNull;
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
        CampaignStarRules(stars: words.stars),
      ],
    );
  }

  /// The name field and the actions the campaign's run allows.
  Widget _form(AppLocalizations l, CampaignDef def) {
    final run = ref.watch(campaignRunsProvider).valueOrNull?[def.id];
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
            label: l.campaignStart,
            icon: Icons.play_arrow_rounded,
            isLoading: _starting,
            onPressed: _starting ? null : () => _start(def),
          )
        else ...[
          PrimaryButton(
            key: CampaignBriefScreen.resumeKey,
            label: l.campaignResume,
            icon: Icons.play_arrow_rounded,
            onPressed: _starting
                ? null
                : () => context.go('${Routes.hub}?careerId=${run.id}'),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            key: CampaignBriefScreen.abandonKey,
            onPressed: _starting ? null : () => _abandonAndRestart(def, run.id),
            child: Text(l.campaignAbandon),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final def = Campaigns.byId(widget.campaignId);
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
