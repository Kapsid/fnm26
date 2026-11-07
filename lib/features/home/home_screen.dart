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
import 'package:fnm/features/career/saves_screen.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/paywall/save_lock.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

part 'home_phone_layout.dart';
part 'home_tablet_layout.dart';

/// The app's landing screen: jump straight back into the last save, start a new
/// game, or open the full saves list.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const Key tabletLayoutKey = Key('home.tabletLayout');
  static const Key campaignsKey = Key('home.campaigns');
  static const Key campaignContinueKey = Key('home.campaignContinue');
  static const Key editorKey = Key('home.editor');

  /// The way back into the last normal save: the big card or the slim one.
  static const Key continueCareerKey = Key('home.continueCareer');

  /// The big continue card, whichever save it is for.
  static const Key heroKey = Key('home.hero');

  /// The big New Game tile.
  static const Key newGameKey = Key('home.newGame');

  /// The small Settings tile.
  static const Key settingsKey = Key('home.settings');

  /// The slim continue card under the big one.
  static const Key secondContinueKey = Key('home.secondContinue');

  /// The logo, title and tagline over the grid.
  static const Key brandKey = Key('home.brand');

  /// The saves tile (Load game before the first save).
  static const Key savesKey = Key('home.saves');

  /// The continue card's line naming the database its save runs on.
  static const Key continueWorldKey = Key('home.continueWorld');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    // The most recent save (saves are listed most-recently-PLAYED first) —
    // powers the one-tap "continue where you left off" action.
    final saves = ref.watch(savesProvider).valueOrNull;
    final lastSave = (saves != null && saves.isNotEmpty) ? saves.first : null;
    final lastNation = lastSave == null
        ? null
        : ref.watch(nationByIdProvider(lastSave.nationId)).valueOrNull;
    final lastWorld = lastSave == null
        ? null
        : ref.watch(careerWorldNamesProvider).valueOrNull?[lastSave.id];
    // Its nation as its own world names it.
    final lastWorldNation = lastSave == null
        ? null
        : ref.watch(careerWorldNationNamesProvider).valueOrNull?[lastSave.id];
    final campaign = _latestCampaignRun(ref);
    final campaignNation = campaign == null
        ? null
        : ref.watch(nationByIdProvider(campaign.def.nationId)).valueOrNull;
    final tablet = useTabletLayout(context, ref);
    // A card for a Pro-locked save still shows, padlocked, and opens the gate.
    final lockedIds = watchLockedCareerIds(ref);
    // Whichever was played last leads; the other sits under it.
    final campaignFirst =
        campaign != null &&
        (lastSave == null ||
            _playedAt(campaign.run).isAfter(_playedAt(lastSave)));
    if (tablet) {
      final cards = <Widget>[
        if (lastSave != null)
          _ContinueCard(
            nationName: lastWorldNation ?? lastNation?.name ?? l.homeYourNation,
            nationCode: lastNation?.code,
            worldName: lastWorld,
            inGameDate: lastSave.inGameDate,
            cyclePointer: lastSave.cyclePointer,
            locked: lockedIds.contains(lastSave.id),
            onResume: () => _resume(context, ref, lastSave),
          ),
        if (campaign != null)
          _CampaignContinueCard(
            def: campaign.def,
            run: campaign.run,
            nationCode: campaignNation?.code,
            compact: false,
            locked: lockedIds.contains(campaign.run.id),
            onResume: () => _resume(context, ref, campaign.run),
          ),
      ];
      if (campaignFirst && cards.length > 1) {
        cards.insert(0, cards.removeLast());
      }
      return _HomeTabletLayout(hasSave: lastSave != null, cards: cards);
    }

    final careerNation =
        lastWorldNation ?? lastNation?.name ?? l.homeYourNation;
    final career = lastSave == null
        ? null
        : _Resumable(
            key: HomeScreen.continueCareerKey,
            label: l.homeContinue,
            nationName: careerNation,
            nationCode: lastNation?.code,
            name: careerNation,
            worldName: lastWorld,
            date: AppDate.monthYear(context, lastSave.inGameDate),
            subtitle: _careerNextLine(
              context,
              lastSave,
              ref.watch(hubDataProvider(lastSave.id)).valueOrNull,
            ),
            locked: lockedIds.contains(lastSave.id),
            onResume: () => _resume(context, ref, lastSave),
          );
    final run = campaign == null
        ? null
        : _campaignResumable(
            context,
            def: campaign.def,
            run: campaign.run,
            nationName: campaignNation?.name ?? l.homeYourNation,
            nationCode: campaignNation?.code,
            locked: lockedIds.contains(campaign.run.id),
            onResume: () => _resume(context, ref, campaign.run),
          );
    final (hero, second) = campaignFirst ? (run, career) : (career, run);
    return _HomePhoneLayout(
      hasSave: lastSave != null,
      hero: hero,
      second: second,
    );
  }
}

/// What comes next for [save], on the phone's continue card: his next
/// fixture as the hub's top bar names it (the opponent held back until the
/// draw has been watched), and with none, where the cycle stands. It used to
/// read "Road to the {year} World Championship" whatever the save was doing,
/// that World Championship played or not.
String _careerNextLine(BuildContext context, Career save, HubData? hub) {
  final l = AppLocalizations.of(context);
  final year = CareerService.worldCupYear(save.cyclePointer);
  if (hub == null) return l.careerRoadToWorldCup(year);
  final next = hub.next;
  if (next != null) {
    String name(int id) => hub.nations[id]?.name ?? l.hubUnknown;
    final match = hub.nextDrawWatched
        ? '${name(next.homeNationId)} ${l.hubVs.toLowerCase()} '
              '${name(next.awayNationId)}'
        : l.topBarDrawPending;
    // The day, not the stage: on the smallest phone the stage pushed the
    // date off the end of the card's two lines.
    return l.homeNextFixture(match, AppDate.dayMonth(context, next.date));
  }
  // No fixture of his own: the cycle's World Championship is either behind
  // him (the board's verdict is the next thing), running without him, or
  // still ahead.
  if (hub.championNationId != null) return l.homeCycleComplete(year);
  if (hub.hasFinals) return l.homeFollowingFinals(year);
  return l.careerRoadToWorldCup(year);
}

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
///
/// A Pro-locked save opens its gate instead, untouched (see [openSave]).
void _resume(BuildContext context, WidgetRef ref, Career save) =>
    openSave(context, ref, save.id);

/// The highlighted "continue your last save" card — a flag, the nation, and a
/// bright resume button.
class _ContinueCard extends StatelessWidget {
  const _ContinueCard({
    required this.nationName,
    required this.nationCode,
    required this.inGameDate,
    required this.cyclePointer,
    required this.onResume,
    this.locked = false,
    this.worldName,
  });

  final String nationName;
  final String? nationCode;

  /// The database the save runs on; null for the game's own world.
  final String? worldName;
  final DateTime inGameDate;
  final int cyclePointer;
  final VoidCallback onResume;
  final bool locked;

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
                  if (worldName case final world?)
                    SaveWorldLine(
                      key: HomeScreen.continueWorldKey,
                      name: world,
                    ),
                  if (locked) const SaveLockedNote(),
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
            Icon(
              locked ? Icons.lock_rounded : Icons.play_circle_fill_rounded,
              color: locked ? AppColors.warning : AppColors.primary,
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
    this.locked = false,
  });

  final CampaignDef def;
  final Career run;
  final String? nationCode;
  final bool compact;
  final VoidCallback onResume;
  final bool locked;

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
                  if (locked) const SaveLockedNote(),
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
              locked ? Icons.lock_rounded : Icons.play_circle_fill_rounded,
              color: locked ? AppColors.warning : AppColors.primary,
              size: compact ? 30 : 36,
            ),
          ],
        ),
      ),
    );
  }
}
