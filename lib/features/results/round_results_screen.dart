import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/domain/services/competition/group_advancement.dart';
import 'package:fnm/domain/services/competition/nations_cup.dart';
import 'package:fnm/features/friendlies/other_friendlies_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// Everything the round-results screen needs: the grouped results plus the
/// nation lookup and which nation is the player's.
typedef _RoundView = ({
  RoundResults? results,
  Map<int, Nation> nations,
  int playerNationId,
  int directCount,
  int? contentionPos,
  int relegateCount,
  Set<String> noRelegationGroups,
});

final AutoDisposeFutureProviderFamily<_RoundView?, int> _roundResultsProvider =
    FutureProvider.autoDispose.family<_RoundView?, int>((ref, careerId) async {
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) return null;
  final results = await ref
      .watch(competitionRepositoryProvider)
      .lastRoundResults(careerId, career.nationId);
  final nations = {
    for (final n in await ref.watch(nationRepositoryProvider).all()) n.id: n,
  };

  // The advancing (green), in-contention (amber) and relegated (red) positions
  // for this competition, so the results tables match the hub and detail
  // screens.
  var direct = 2;
  int? contention;
  var relegate = 0;
  final noRelegation = <String>{};
  if (results != null && results.groupCount > 0) {
    final conf =
        nations[career.nationId]?.confederation ?? Confederation.europe;
    final size = ContinentalCups.byConfederation[conf]?.size ?? 24;
    final adv = GroupAdvancement.forGroup(
      kind: results.kind,
      confederation: conf,
      groupCount: results.groupCount,
      continentalSize: size,
    );
    direct = adv.direct;
    contention = adv.contention;
    relegate = adv.relegate;
    // The Nations Cup's lowest league has nowhere to fall — its groups show no
    // relegation zone, exactly as the hub and the Nations Cup screen decide.
    if (results.kind == CompetitionKind.nationsLeague) {
      final tiers =
          await ref.watch(careerRepositoryProvider).nationsCupTiers(careerId);
      for (final g in results.groups) {
        final lowest = NationsCup.isLowestLeague(
          groupName: g.name,
          tiers: tiers,
          confederation: conf,
          confederationOf: (id) => nations[id]?.confederation,
        );
        if (lowest) noRelegation.add(g.name);
      }
    }
  }

  return (
    results: results,
    nations: nations,
    playerNationId: career.nationId,
    directCount: direct,
    contentionPos: contention,
    relegateCount: relegate,
    noRelegationGroups: noRelegation,
  );
});

/// Shown after the player finishes a group-stage match: the rest of that
/// round's results, grouped by group, with the live standings. Continues to the
/// hub.
class RoundResultsScreen extends ConsumerWidget {
  const RoundResultsScreen({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final viewAsync = ref.watch(_roundResultsProvider(careerId));
    final friendlies =
        ref.watch(otherFriendliesProvider(careerId)).valueOrNull ?? const [];
    void toHub() => context.go('${Routes.hub}?careerId=$careerId');

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          l.resultsRoundResults,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: viewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l.resultsCouldNotLoad(e.toString()))),
        data: (view) {
          final results = view?.results;
          final hasContent = results != null &&
              (results.groups.isNotEmpty ||
                  results.knockoutFixtures.isNotEmpty);
          if (view == null || results == null || !hasContent) {
            // A friendly (or nothing competitive): show the other nations'
            // friendly internationals from this window, if any.
            if (view != null && friendlies.isNotEmpty) {
              String code(int id) => view.nations[id]?.code ?? '??';
              String name(int id) => view.nations[id]?.name ?? '—';
              return ListView(
                padding: const EdgeInsets.all(AppSpacing.marginMobile),
                children: [
                  Text(
                    l.resultsFriendlyInternationals,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppCard(
                    child: Column(
                      children: [
                        for (final f in friendlies)
                          _FriendlyRow(result: f, code: code, name: name),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              );
            }
            // Nothing to show — the bottom Continue button carries on.
            return const SizedBox.shrink();
          }
          String code(int id) => view.nations[id]?.code ?? '??';
          String name(int id) => view.nations[id]?.name ?? '—';
          final isKnockout = results.knockoutFixtures.isNotEmpty;

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            children: [
              Text(
                results.competition.toUpperCase(),
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
              Text(
                isKnockout
                    ? (results.stage ?? l.resultsKnockout).toUpperCase()
                    : l.resultsMatchday(results.matchday),
                style: AppTypography.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.md),
              if (isKnockout)
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final f in results.knockoutFixtures)
                        MatchResultRow(
                          fixture: f,
                          code: code,
                          emphasiseNationId: view.playerNationId,
                        ),
                    ],
                  ),
                )
              else
                for (final g in results.groups)
                  _GroupBlock(
                    group: g,
                    playerNationId: view.playerNationId,
                    directCount: view.directCount,
                    contentionPos: view.contentionPos,
                    relegateCount: view.noRelegationGroups.contains(g.name)
                        ? 0
                        : view.relegateCount,
                    code: code,
                    name: name,
                  ),
              const SizedBox(height: AppSpacing.xl),
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.marginMobile),
          child: PrimaryButton(
            label: l.resultsContinue,
            icon: Icons.check_rounded,
            onPressed: toHub,
          ),
        ),
      ),
    );
  }
}

class _GroupBlock extends StatelessWidget {
  const _GroupBlock({
    required this.group,
    required this.playerNationId,
    required this.directCount,
    required this.contentionPos,
    required this.relegateCount,
    required this.code,
    required this.name,
  });

  final RoundResultGroup group;
  final int playerNationId;
  final int directCount;
  final int? contentionPos;

  /// How many bottom places go down (red) — the Nations Cup relegates each
  /// group's last side (bar the lowest league's).
  final int relegateCount;
  final String Function(int) code;
  final String Function(int) name;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.resultsGroup(group.name),
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            // This matchday's scores.
            for (final f in group.fixtures)
              MatchResultRow(
                fixture: f,
                code: code,
                emphasiseNationId: playerNationId,
              ),
            const Divider(height: AppSpacing.md),
            // Standings snapshot (top spots advance).
            for (var i = 0; i < group.standings.length; i++)
              _StandingRow(
                pos: i + 1,
                standing: group.standings[i],
                isPlayer: group.standings[i].nationId == playerNationId,
                directCount: directCount,
                contentionPos: contentionPos,
                relegated: relegateCount > 0 &&
                    i + 1 > group.standings.length - relegateCount,
                name: name,
                code: code,
              ),
          ],
        ),
      ),
    );
  }
}

/// One other-nations' friendly result: flags and names either side of the
/// score.
class _FriendlyRow extends StatelessWidget {
  const _FriendlyRow({
    required this.result,
    required this.code,
    required this.name,
  });

  final FriendlyResult result;
  final String Function(int) code;
  final String Function(int) name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    name(result.homeId),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: AppTypography.bodySmall,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                FlagDisc(code(result.homeId), size: 18),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: AppRadii.smAll,
            ),
            child: Text(
              '${result.homeScore} - ${result.awayScore}',
              style: AppTypography.labelMedium,
            ),
          ),
          Expanded(
            child: Row(
              children: [
                FlagDisc(code(result.awayId), size: 18),
                const SizedBox(width: AppSpacing.sm),
                Flexible(
                  child: Text(
                    name(result.awayId),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StandingRow extends StatelessWidget {
  const _StandingRow({
    required this.pos,
    required this.standing,
    required this.isPlayer,
    required this.directCount,
    required this.contentionPos,
    required this.relegated,
    required this.name,
    required this.code,
  });

  final int pos;
  final GroupStanding standing;
  final bool isPlayer;
  final int directCount;
  final int? contentionPos;

  /// Whether this position drops a league (Nations Cup groups).
  final bool relegated;
  final String Function(int) name;
  final String Function(int) code;

  @override
  Widget build(BuildContext context) {
    final advancing = pos <= directCount;
    final inContention = pos == contentionPos;
    final accent = advancing
        ? AppColors.positive
        : inContention
            ? AppColors.warning
            : relegated
                ? AppColors.error
                : null;
    return Container(
      decoration: BoxDecoration(
        color: isPlayer ? AppColors.surfaceContainerHigh : null,
        border: Border(
          left: BorderSide(
            color: accent ?? Colors.transparent,
            width: 3,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
      child: Row(
        children: [
          SizedBox(
            width: 16,
            child: Text(
              '$pos',
              style: AppTypography.labelSmall.copyWith(
                color: accent ?? AppColors.onSurfaceVariant,
              ),
            ),
          ),
          FlagDisc(code(standing.nationId), size: 18),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              name(standing.nationId),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySmall.copyWith(
                fontWeight: isPlayer ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ),
          SizedBox(
            width: 28,
            child: Text(
              '${standing.played}',
              textAlign: TextAlign.center,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          SizedBox(
            width: 28,
            child: Text(
              '${standing.points}',
              textAlign: TextAlign.center,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
