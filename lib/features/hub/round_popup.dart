import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// The knockout results of the round a background tournament just played,
/// ready to show as a popup after the player steps it forward on the hub.
typedef RoundPopup = ({
  String competition,
  String stage,
  List<Fixture> fixtures,
});

/// Human labels and bracket order for the knockout rounds of both the World Cup
/// finals and the continental championships.
const _knockoutRounds = <String, ({int order, String label})>{
  'R32': (order: 0, label: 'Round of 32'),
  'R16': (order: 1, label: 'Round of 16'),
  'QF': (order: 2, label: 'Quarter-finals'),
  'SF': (order: 3, label: 'Semi-finals'),
  '3RD': (order: 4, label: 'Third-place play-off'),
  'FINAL': (order: 5, label: 'Final'),
  'CR16': (order: 0, label: 'Round of 16'),
  'CQF': (order: 1, label: 'Quarter-finals'),
  'CSF': (order: 2, label: 'Semi-finals'),
  'C3RD': (order: 3, label: 'Third-place play-off'),
  'CFINAL': (order: 4, label: 'Final'),
  'NSF': (order: 0, label: 'Semi-finals'),
  'NFINAL': (order: 1, label: 'Final'),
};

/// The localised name for a knockout [round] code (empty/unknown = group stage),
/// shared by the World Cup, continental (C…) and Nations Cup (N…) prefixes. The
/// record still carries a canonical English [RoundPopup.stage]; this resolves
/// the code to the viewer's language only when the popup is shown.
String stageLabelFor(AppLocalizations l, String round) => switch (round) {
      'R32' => l.hubStageRoundOf32,
      'R16' || 'CR16' => l.finishRoundOf16,
      'QF' || 'CQF' => l.finishQuarterFinals,
      'SF' || 'CSF' || 'NSF' => l.finishSemiFinals,
      '3RD' || 'C3RD' => l.hubStageThirdPlace,
      'FINAL' || 'CFINAL' || 'NFINAL' => l.hubFinal,
      _ => l.finishGroupStage,
    };

/// The results of the most recent day of whichever tournament the player is
/// following — the fixtures played on the latest date across the World Cup
/// finals, their continental championship and the Nations Cup Finals Four,
/// whether a group matchday or a knockout round, so a knocked-out or
/// non-qualifying manager can step through every day.
///
/// The competition is chosen by what actually played most recently rather than
/// by which tournament happens to exist: they overlap across a cycle, and the
/// Nations Cup is stepped on the hub too.
///
/// Null when nothing has been played yet.
final AutoDisposeFutureProviderFamily<RoundPopup?, int>
    latestRoundPopupProvider =
    FutureProvider.autoDispose.family<RoundPopup?, int>((ref, careerId) async {
  final comp = ref.watch(competitionRepositoryProvider);
  final hub = await ref.watch(hubDataProvider(careerId).future);
  if (hub == null) return null;

  final conf = hub.nations[hub.career.nationId]?.confederation;
  final continentalName = conf == null
      ? 'Continental Championship'
      : ContinentalCups.byConfederation[conf]?.name ??
          'Continental Championship';

  // Every confederation's championship is a competition of the same kind, so
  // the continental source names the player's own: without it the popup could
  // report a round from a cup on the other side of the world under the name of
  // the manager's.
  final sources = <({
    CompetitionKind kind,
    String name,
    List<String> rounds,
    Confederation? confederation,
  })>[
    (
      kind: CompetitionKind.worldCupFinals,
      name: 'World Cup',
      rounds: const ['GROUP', 'R32', 'R16', 'QF', 'SF', '3RD', 'FINAL'],
      confederation: null,
    ),
    (
      kind: CompetitionKind.continentalFinals,
      name: continentalName,
      rounds: const ['CGROUP', 'CR16', 'CQF', 'CSF', 'C3RD', 'CFINAL'],
      confederation: conf,
    ),
    (
      kind: CompetitionKind.nationsLeague,
      name: 'Nations Cup',
      rounds: const ['NSF', 'NFINAL'],
      confederation: null,
    ),
  ];

  ({String name, Fixture fixture})? newest;
  final byName = <String, List<Fixture>>{};
  for (final source in sources) {
    for (final round in source.rounds) {
      final fixtures = await comp.fixturesByRound(
        careerId,
        round,
        kind: source.kind,
        confederation: source.confederation,
      );
      for (final f in fixtures.where((f) => f.hasResult)) {
        (byName[source.name] ??= []).add(f);
        if (newest == null || f.date.isAfter(newest.fixture.date)) {
          newest = (name: source.name, fixture: f);
        }
      }
    }
  }
  final latest = newest;
  if (latest == null) return null;

  // Everything that competition played on its most recent date — the day the
  // player just stepped.
  final latestDate = latest.fixture.date;
  final sameDay = byName[latest.name]!
      .where((f) => f.date.isAtSameMomentAs(latestDate))
      .toList()
    ..sort((a, b) {
      final ao = _knockoutRounds[a.round ?? '']?.order ?? -1;
      final bo = _knockoutRounds[b.round ?? '']?.order ?? -1;
      return ao.compareTo(bo);
    });
  // Title by the day's most important round: should a play-off and the final
  // ever share a day, the popup reads "Final" (with the final listed last)
  // rather than burying it under "Third-place play-off".
  final round = sameDay.last.round ?? '';
  final label = _knockoutRounds[round]?.label ?? 'Group Stage';
  return (competition: latest.name, stage: label, fixtures: sameDay);
});

/// Shows the just-played knockout round as a centered popup, with a button to
/// open the full bracket. Falls back to navigating straight to [route] when
/// there's no knockout round to show (group stage, or no results yet).
Future<void> showRoundPopup(
  BuildContext context,
  WidgetRef ref,
  int careerId, {
  String? route,
}) async {
  final popup = await ref.refresh(latestRoundPopupProvider(careerId).future);
  final hub = await ref.read(hubDataProvider(careerId).future);
  if (!context.mounted) return;
  if (popup == null || hub == null) {
    if (route != null) context.go(route);
    return;
  }
  await showAppPopup<void>(
    context: context,
    builder: (context) => _RoundSheet(
      popup: popup,
      nations: hub.nations,
      onBracket: route == null
          ? null
          : () {
              Navigator.of(context).pop();
              context.go(route);
            },
    ),
  );
}

class _RoundSheet extends StatelessWidget {
  const _RoundSheet({
    required this.popup,
    required this.nations,
    required this.onBracket,
  });

  final RoundPopup popup;
  final Map<int, Nation> nations;
  final VoidCallback? onBracket;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    // The canonical round is the day's most important tie (fixtures are ordered
    // by bracket depth), resolved to the viewer's language here.
    final round =
        popup.fixtures.isEmpty ? '' : (popup.fixtures.last.round ?? '');
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header and rows mirror the after-match round-results screen, so
            // a tournament the player follows reads like one they played in.
            Text(
              popup.competition.toUpperCase(),
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.primary,
              ),
            ),
            Text(
              stageLabelFor(l, round).toUpperCase(),
              style: AppTypography.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final f in popup.fixtures)
                    MatchResultRow(
                      fixture: f,
                      code: (id) => nations[id]?.code ?? '??',
                      // No side is the manager's here — bold whoever advanced.
                      emphasiseWinner: true,
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            // The classic bottom actions: Continue carries on (like every other
            // continue screen), Brackets opens the tournament in full.
            PrimaryButton(
              label: l.hubContinue,
              icon: Icons.check_rounded,
              onPressed: () => Navigator.of(context).pop(),
            ),
            if (onBracket != null) ...[
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onBracket,
                  icon: const Icon(Icons.account_tree_outlined, size: 18),
                  label: Text(l.hubBrackets),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.outlineVariant),
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
