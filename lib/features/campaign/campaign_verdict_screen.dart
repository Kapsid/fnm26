import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/caps.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/campaign/campaigns.dart';
import 'package:fnm/features/campaign/campaign_providers.dart';
import 'package:fnm/features/campaign/campaign_stamp.dart';
import 'package:fnm/features/campaign/campaign_ui.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

part 'campaign_verdict_tablet_layout.dart';

/// A campaign run's record in numbers: the results played in its cycles.
typedef CampaignRunNumbers = ({
  int played,
  int won,
  int drawn,
  int lost,
  int goalsFor,
  int goalsAgainst,
});

/// Whether a fixture of [round] belongs to the run in numbers: the campaign's
/// own competition, so no friendlies, World Championship qualifying or
/// play-offs. The Grudge is its continental qualifying group ('CQ'); the
/// Transplant adds the continental finals ('C' + group or knockout code).
/// Best of Guineas counts the continental finals only, and every meeting
/// with its rivals whatever the round (see [campaignRunNumbersProvider]).
/// Young Finns counts both championships' finals, continental and world (the
/// World Championship's rounds carry no prefix). Greenland counts every
/// competitive match, qualifying included: anything but a friendly. Finish
/// the Legacy counts the three titles it is after: both championships' finals
/// and the whole Nations Cup, groups and Finals Four.
bool campaignRunCounts(CampaignGoal goal, String? round) {
  if (goal == CampaignGoal.qualifyBothThenTitle) return round != 'FRIENDLY';
  if (round == null) return false;
  const finals = {'GROUP', 'R32', 'R16', 'QF', 'SF', '3RD', 'FINAL'};
  if (goal == CampaignGoal.titleTreble) {
    const nationsCup = {'NGROUP', 'NL', 'NR16', 'NQF', 'NSF', 'NFINAL'};
    return finals.contains(round) ||
        nationsCup.contains(round) ||
        (round.startsWith('C') && finals.contains(round.substring(1)));
  }
  if (goal == CampaignGoal.qualifyWorldThenTitles) {
    return finals.contains(round) ||
        (round.startsWith('C') && finals.contains(round.substring(1)));
  }
  if (round == 'CQ') return goal != CampaignGoal.beatRivalsThenContinental;
  return goal != CampaignGoal.aboveRival &&
      round.startsWith('C') &&
      finals.contains(round.substring(1));
}

/// The nation's played results in the campaign's competition (careerId), or
/// null for a normal career. Read after the progress so it is never older than the verdict.
final AutoDisposeFutureProviderFamily<CampaignRunNumbers?, int>
campaignRunNumbersProvider = FutureProvider.autoDispose
    .family<CampaignRunNumbers?, int>((ref, careerId) async {
      final progress = await ref.watch(
        campaignProgressProvider(careerId).future,
      );
      if (progress == null) return null;
      final def = progress.def;
      final nationId = def.nationId;
      var won = 0;
      var drawn = 0;
      var lost = 0;
      var gf = 0;
      var ga = 0;
      final comp = ref.read(competitionRepositoryProvider);
      final current = await comp.cycleFixturesForNation(careerId, nationId);
      final career = await ref.read(careerRepositoryProvider).byId(careerId);
      // Every cycle of a longer campaign, not only the one being played.
      final fixtures = career == null
          ? current
          : await campaignSpanFixtures(
              comp,
              careerId,
              def,
              career.cyclePointer,
              current,
            );
      for (final f in fixtures) {
        final opp = f.homeNationId == nationId
            ? f.awayNationId
            : f.homeNationId;
        if (!f.hasResult ||
            !(campaignRunCounts(def.goal, f.round) ||
                def.rivalNationIds.contains(opp))) {
          continue;
        }
        final home = f.homeNationId == nationId;
        final mine = home ? f.homeScore! : f.awayScore!;
        final theirs = home ? f.awayScore! : f.homeScore!;
        gf += mine;
        ga += theirs;
        if (mine > theirs) {
          won++;
        } else if (mine == theirs) {
          drawn++;
        } else {
          lost++;
        }
      }
      return (
        played: won + drawn + lost,
        won: won,
        drawn: drawn,
        lost: lost,
        goalsFor: gf,
        goalsAgainst: ga,
      );
    });

/// The verdict on a settled campaign: the stamp it earns, the run in numbers
/// and, for a Grudge, the meetings with the rival. Continue files the result
/// in the campaign's record and returns to the hub; it is the only way out,
/// like any event page.
class CampaignVerdictScreen extends ConsumerStatefulWidget {
  const CampaignVerdictScreen({required this.careerId, super.key});

  final int careerId;

  static const Key tabletLayoutKey = Key('campaignVerdict.tabletLayout');
  static const Key continueKey = Key('campaignVerdict.continue');
  static const Key headlineKey = Key('campaignVerdict.headline');
  static const Key cannotContinueKey = Key('campaignVerdict.cannotContinue');
  static const Key meetingsKey = Key('campaignVerdict.meetings');

  @override
  ConsumerState<CampaignVerdictScreen> createState() =>
      _CampaignVerdictScreenState();
}

class _CampaignVerdictScreenState extends ConsumerState<CampaignVerdictScreen> {
  bool _busy = false;

  Future<void> _continue() async {
    if (_busy) return;
    setState(() => _busy = true);
    final router = GoRouter.of(context);
    try {
      await ref
          .read(campaignServiceProvider)
          .acknowledgeVerdict(widget.careerId);
      router.go('${Routes.hub}?careerId=${widget.careerId}');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Widget _row(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
        Text(value, style: AppTypography.titleMedium),
      ],
    ),
  );

  /// The title, headline and stamp. Without a verdict (a normal career, or a
  /// run still open) only the title shows.
  Widget _verdict(AppLocalizations l, CampaignProgress? progress) {
    final settled = progress != null && progress.settled;
    return Column(
      children: [
        if (progress != null)
          Text(
            campaignWords(l, progress.def).title,
            style: AppTypography.headlineMedium,
            textAlign: TextAlign.center,
          ),
        if (settled) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            progress.stars > 0 ? l.campaignVerdictWon : l.campaignVerdictLost,
            key: CampaignVerdictScreen.headlineKey,
            style: AppTypography.titleMedium.copyWith(
              color: progress.stars > 0 ? AppColors.positive : AppColors.error,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          CampaignStamp(best: progress.stars, size: 150),
          // No Move to saves for this scenario: say why the run just ends.
          if (!progress.def.canContinue) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              l.campaignCannotContinue,
              key: CampaignVerdictScreen.cannotContinueKey,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ],
    );
  }

  /// The run in numbers, and the two meetings with the rival of a Grudge.
  Widget _numbers(
    AppLocalizations l,
    CampaignProgress? progress,
    CampaignRunNumbers? n,
  ) {
    if (progress == null || n == null) return const SizedBox.shrink();
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l.campaignRunInNumbers.capsIn(l.localeName),
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _row(l.statsPlayed, '${n.played}'),
          _row(l.statsWinDrawLoss, '${n.won}–${n.drawn}–${n.lost}'),
          _row(l.statsGoals, '${n.goalsFor}:${n.goalsAgainst}'),
          if (progress.rivalMatchesPlayed > 0)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: Text(
                l.campaignRunMeetings(
                  progress.rivalWins,
                  progress.rivalMatchesPlayed,
                ),
                key: CampaignVerdictScreen.meetingsKey,
                style: AppTypography.bodyMedium,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final progress = ref
        .watch(campaignProgressProvider(widget.careerId))
        .valueOrNull;
    final numbers = ref
        .watch(campaignRunNumbersProvider(widget.careerId))
        .valueOrNull;
    final verdict = _verdict(l, progress);
    final stats = _numbers(l, progress, numbers);
    final action = PrimaryButton(
      key: CampaignVerdictScreen.continueKey,
      label: l.campaignVerdictContinue,
      icon: Icons.arrow_forward_rounded,
      isLoading: _busy,
      onPressed: _busy ? null : _continue,
    );
    if (useTabletLayout(context, ref)) {
      return _CampaignVerdictTabletLayout(
        title: progress == null
            ? l.campaignsTitle
            : campaignWords(l, progress.def).title,
        verdict: verdict,
        numbers: stats,
        action: action,
      );
    }
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.marginMobile),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.lg),
              verdict,
              const SizedBox(height: AppSpacing.xl),
              stats,
              const SizedBox(height: AppSpacing.xl),
              action,
            ],
          ),
        ),
      ),
    );
  }
}
