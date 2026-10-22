import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/app_date.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/services/campaign/campaigns.dart';
import 'package:fnm/features/campaign/campaign_providers.dart';
import 'package:fnm/features/campaign/campaign_ui.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

part 'home_tablet_layout.dart';

/// The app's landing screen: jump straight back into the last save, start a new
/// game, or open the full saves list.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const Key tabletLayoutKey = Key('home.tabletLayout');
  static const Key campaignsKey = Key('home.campaigns');
  static const Key campaignContinueKey = Key('home.campaignContinue');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    // The most recent save (saves are listed most-recently-PLAYED first) —
    // powers the one-tap "continue where you left off" action.
    final saves = ref.watch(savesProvider).valueOrNull;
    final lastSave = (saves != null && saves.isNotEmpty) ? saves.first : null;
    final lastNation = lastSave == null
        ? null
        : ref.watch(nationByIdProvider(lastSave.nationId)).valueOrNull;
    final campaign = _latestCampaignRun(ref);
    final campaignNation = campaign == null
        ? null
        : ref.watch(nationByIdProvider(campaign.def.nationId)).valueOrNull;
    final tablet = useTabletLayout(context, ref);
    // Whichever was played last leads; the other sits under it.
    final cards = <Widget>[
      if (lastSave != null)
        _ContinueCard(
          nationName: lastNation?.name ?? l.homeYourNation,
          nationCode: lastNation?.code,
          inGameDate: lastSave.inGameDate,
          cyclePointer: lastSave.cyclePointer,
          onResume: () => _resume(context, ref, lastSave),
        ),
      if (campaign != null)
        _CampaignContinueCard(
          def: campaign.def,
          run: campaign.run,
          nationCode: campaignNation?.code,
          compact: !tablet,
          onResume: () => _resume(context, ref, campaign.run),
        ),
    ];
    if (lastSave != null &&
        campaign != null &&
        _playedAt(campaign.run).isAfter(_playedAt(lastSave))) {
      cards.insert(0, cards.removeLast());
    }
    if (tablet) {
      return _HomeTabletLayout(hasSave: lastSave != null, cards: cards);
    }
    final both = cards.length > 1;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.marginMobile,
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  tooltip: l.homeSettings,
                  icon: const Icon(
                    Icons.settings_outlined,
                    color: AppColors.onSurfaceVariant,
                  ),
                  onPressed: () => context.go(Routes.settings),
                ),
              ),
              // The logo block takes whatever the buttons and cards leave and
              // the logo gives way first, so two cards still fit a small phone.
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // The box MATCHES THE ARTWORK's aspect (about 0.96:1, a
                    // shade taller than square). A box of the wrong shape does
                    // not crop: it letterboxes, so the logo is drawn to
                    // whichever side runs out first and the rest of the box is
                    // wasted. Re-measure this if the artwork is ever replaced.
                    Flexible(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 200),
                        child: AspectRatio(
                          aspectRatio: 200 / 208,
                          child: Image.asset(
                            'assets/images/fnm_logo.png',
                            fit: BoxFit.contain,
                            // Graceful fallback if the asset is missing in a
                            // bare test env.
                            errorBuilder: (context, error, stack) => const Icon(
                              Icons.sports_soccer,
                              size: 112,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Football Nations\nManager',
                      textAlign: TextAlign.center,
                      style: textTheme.headlineLarge,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l.homeLeadTheNation,
                      textAlign: TextAlign.center,
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              // The headline action when a save or a campaign run exists:
              // resume it in one tap, visually lifted: "carry on".
              for (final card in cards) ...[
                card,
                const SizedBox(height: AppSpacing.sm),
              ],
              PrimaryButton(
                label: l.homeNewGame,
                icon: Icons.play_arrow_rounded,
                onPressed: () => context.go(Routes.nations),
              ),
              TextButton(
                style: both ? _tightButton : null,
                onPressed: () => context.go(Routes.saves),
                child: Text(lastSave != null ? l.homeAllSaves : l.homeLoadGame),
              ),
              TextButton(
                key: HomeScreen.campaignsKey,
                style: both ? _tightButton : null,
                onPressed: () => context.go(Routes.campaigns),
                child: Text(l.homeCampaigns),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }
}

/// Text buttons without the 48 px touch padding, for a small phone that shows
/// both continue cards. Still a full-width tap target.
final ButtonStyle _tightButton = TextButton.styleFrom(
  minimumSize: const Size.fromHeight(40),
  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
);

/// When [c] was last opened; a run never opened since it was made counts from
/// its creation.
DateTime _playedAt(Career c) => c.lastPlayedAt ?? c.createdAt;

/// The campaign run played most recently, with its definition; null when no
/// run is in progress. The campaigns screen offers Resume for every unmoved
/// run (settled or not), so every run in [campaignRunsProvider] is eligible.
({CampaignDef def, Career run})? _latestCampaignRun(WidgetRef ref) {
  final runs = ref.watch(campaignRunsProvider).valueOrNull;
  if (runs == null) return null;
  ({CampaignDef def, Career run})? best;
  for (final def in Campaigns.all) {
    final run = runs[def.id];
    if (run == null) continue;
    if (best == null || _playedAt(run).isAfter(_playedAt(best.run))) {
      best = (def: def, run: run);
    }
  }
  return best;
}

/// Opens [save] where the manager left it, stamping it so it heads the saves
/// list next time. Nothing is awaited, so there is no later moment at which
/// to go anywhere else.
void _resume(BuildContext context, WidgetRef ref, Career save) {
  unawaited(ref.read(careerServiceProvider).markPlayed(save.id));
  context.go('${Routes.hub}?careerId=${save.id}');
}

/// The highlighted "continue your last save" card — a flag, the nation, and a
/// bright resume button.
class _ContinueCard extends StatelessWidget {
  const _ContinueCard({
    required this.nationName,
    required this.nationCode,
    required this.inGameDate,
    required this.cyclePointer,
    required this.onResume,
  });

  final String nationName;
  final String? nationCode;
  final DateTime inGameDate;
  final int cyclePointer;
  final VoidCallback onResume;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return GestureDetector(
      onTap: onResume,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.secondaryContainer,
          borderRadius: AppRadii.baseAll,
          border: Border.all(color: AppColors.primary, width: 1.5),
        ),
        child: Row(
          children: [
            if (nationCode != null) ...[
              FlagDisc(nationCode!, size: 40, highlighted: true),
              const SizedBox(width: AppSpacing.md),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.homeContinue,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  Text(nationName, style: AppTypography.titleMedium),
                  const SizedBox(height: 2),
                  Text(
                    l.homeRoadToWorldCup(
                      AppDate.monthYear(context, inGameDate),
                      CareerService.worldCupYear(cyclePointer),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.play_circle_fill_rounded,
              color: AppColors.primary,
              size: 36,
            ),
          ],
        ),
      ),
    );
  }
}

/// The "continue your campaign" card: the same family as [_ContinueCard], a
/// shade smaller so two of them do not crowd a small phone. Flag of the
/// campaign's nation, its title, and the month plus the cycle it is on.
class _CampaignContinueCard extends StatelessWidget {
  const _CampaignContinueCard({
    required this.def,
    required this.run,
    required this.nationCode,
    required this.compact,
    required this.onResume,
  });

  final CampaignDef def;
  final Career run;
  final String? nationCode;
  final bool compact;
  final VoidCallback onResume;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final date = AppDate.monthYear(context, run.inGameDate);
    // A one-cycle campaign has no progress worth stating.
    final subtitle = def.cycles > 1
        ? l.homeCampaignCycle(
            date,
            (run.cyclePointer + 1).clamp(1, def.cycles),
            def.cycles,
          )
        : date;
    return GestureDetector(
      key: HomeScreen.campaignContinueKey,
      onTap: onResume,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: compact ? AppSpacing.sm : AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.secondaryContainer,
          borderRadius: AppRadii.baseAll,
          border: Border.all(color: AppColors.primary, width: 1.5),
        ),
        child: Row(
          children: [
            if (nationCode != null) ...[
              FlagDisc(nationCode!, size: compact ? 32 : 40, highlighted: true),
              const SizedBox(width: AppSpacing.md),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.homeContinueCampaign,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    campaignWords(l, def).title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.titleMedium,
                  ),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.play_circle_fill_rounded,
              color: AppColors.primary,
              size: compact ? 30 : 36,
            ),
          ],
        ),
      ),
    );
  }
}
