import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/caps.dart';
import 'package:fnm/core/util/competition_label.dart';
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
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:fnm/features/tournaments/wc_host_berths.dart';

part 'round_results_tablet_layout.dart';

/// Everything the round-results screen needs: the grouped results plus the
/// nation lookup and which nation is the player's.
typedef RoundResultsView = ({
  RoundResults? results,
  Map<int, Nation> nations,
  int playerNationId,
  int directCount,
  int? contentionPos,
  Set<int> playoffNations,
  int relegateCount,
  Set<String> noRelegationGroups,
});

/// The last round the manager played, grouped, with the zones each table
/// colours. Public so a test can hand the screen a round without playing one.
final AutoDisposeFutureProviderFamily<RoundResultsView?, int>
roundResultsViewProvider = FutureProvider.autoDispose.family<RoundResultsView?, int>((
  ref,
  careerId,
) async {
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) return null;
  final results = await ref
      .watch(competitionRepositoryProvider)
      .lastRoundResults(careerId, career.nationId);
  final nations = {
    for (final n
        in await ref.watch(nationRepositoryProvider).forCareer(careerId))
      n.id: n,
  };

  // The advancing (green), in-contention (amber) and relegated (red) positions
  // for this competition, so the results tables match the hub and detail
  // screens.
  var direct = 2;
  int? contention;
  var playoff = const <int>{};
  var relegate = 0;
  final noRelegation = <String>{};
  if (results != null && results.groupCount > 0) {
    final conf =
        nations[career.nationId]?.confederation ?? Confederation.europe;
    final size = ContinentalCups.byConfederation[conf]?.size ?? 24;
    // World Cup hosts' places come out of their own confederation's
    // allocation, exactly as the hub cuts it.
    final wcHosts = results.kind == CompetitionKind.worldCupQualifying
        ? (await worldCupHostBerthsFor(ref, careerId))[conf] ?? 0
        : 0;
    final adv = GroupAdvancement.forGroup(
      kind: results.kind,
      confederation: conf,
      groupCount: results.groupCount,
      continentalSize: size,
      worldCupHosts: wcHosts,
    );
    direct = adv.direct;
    contention = adv.contention;
    if (results.kind == CompetitionKind.worldCupQualifying) {
      playoff = GroupAdvancement.worldCupPlayoffNations(conf, [
        for (final g in results.groups) g.standings,
      ], hosts: wcHosts);
    }
    relegate = adv.relegate;
    // The Nations Cup's lowest league has nowhere to fall — its groups show no
    // relegation zone, exactly as the hub and the Nations Cup screen decide.
    if (results.kind == CompetitionKind.nationsLeague) {
      final tiers = await ref
          .watch(careerRepositoryProvider)
          .nationsCupTiers(careerId);
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
    playoffNations: playoff,
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

  static const Key tabletLayoutKey = Key('roundResults.tabletLayout');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    if (TabletShellScope.isActive(context)) {
      return _RoundResultsTabletLayout(careerId: careerId);
    }
    final viewAsync = ref.watch(roundResultsViewProvider(careerId));
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
          final hasContent =
              results != null &&
              (results.groups.isNotEmpty ||
                  results.knockoutFixtures.isNotEmpty);
          if (view == null || results == null || !hasContent) {
            // A friendly (or nothing competitive): show the other nations'
            // friendly internationals from this window, if any.
            if (view != null && friendlies.isNotEmpty) {
              String code(int id) => view.nations[id]?.code ?? '??';
              String name(int id) => view.nations[id]?.name ?? l.hubUnknown;
              // The whole window, grouped by continent and scrollable.
              return ListView(
                padding: const EdgeInsets.all(AppSpacing.marginMobile),
                children: [
                  Text(
                    l.resultsFriendlyInternationals,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  for (final g in friendlyGroups(l, friendlies, view)) ...[
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      g.label.capsIn(l.localeName),
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    AppCard(
                      child: Column(
                        children: [
                          for (final f in g.results)
                            _FriendlyRow(
                              result: f,
                              code: code,
                              name: name,
                              careerId: careerId,
                            ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xl),
                ],
              );
            }
            // Nothing to show — the bottom Continue button carries on.
            return const SizedBox.shrink();
          }
          String code(int id) => view.nations[id]?.code ?? '??';
          String name(int id) => view.nations[id]?.name ?? l.hubUnknown;
          final isKnockout = results.knockoutFixtures.isNotEmpty;

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            children: [
              Text(
                competitionLabel(l, results.competition).capsIn(l.localeName),
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
              Text(
                isKnockout
                    ? (results.stage ?? l.resultsKnockout).capsIn(l.localeName)
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
                          careerId: careerId,
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
                    playoffNations: view.playoffNations,
                    relegateCount: view.noRelegationGroups.contains(g.name)
                        ? 0
                        : view.relegateCount,
                    code: code,
                    name: name,
                    careerId: careerId,
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
    required this.playoffNations,
    required this.relegateCount,
    required this.code,
    required this.name,
    required this.careerId,
  });

  final int careerId;
  final RoundResultGroup group;
  final int playerNationId;
  final int directCount;
  final int? contentionPos;
  final Set<int> playoffNations;

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
                careerId: careerId,
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
                playoffNations: playoffNations,
                relegated:
                    relegateCount > 0 &&
                    i + 1 > group.standings.length - relegateCount,
                name: name,
                code: code,
                careerId: careerId,
              ),
          ],
        ),
      ),
    );
  }
}

/// The window's friendlies grouped by continent: the player's own continent
/// first, the rest in the usual order, and the matches between two continents
/// last under their own heading. Public so a test can check the grouping.
List<({String label, List<FriendlyResult> results})> friendlyGroups(
  AppLocalizations l,
  List<FriendlyResult> friendlies,
  RoundResultsView view,
) {
  final mine = view.nations[view.playerNationId]?.confederation;
  final byConf = <Confederation, List<FriendlyResult>>{};
  final cross = <FriendlyResult>[];
  for (final f in friendlies) {
    final a = view.nations[f.homeId]?.confederation;
    final b = view.nations[f.awayId]?.confederation;
    if (a != null && a == b) {
      (byConf[a] ??= []).add(f);
    } else {
      cross.add(f);
    }
  }
  final order = [
    ?mine,
    for (final c in Confederation.values)
      if (c != mine) c,
  ];
  return [
    for (final c in order)
      if (byConf[c] != null)
        (label: confederationLabel(l, c), results: byConf[c]!),
    if (cross.isNotEmpty) (label: l.tourZoneIntercontinental, results: cross),
  ];
}

/// One other-nations' friendly result: flags and names either side of the
/// score.
class _FriendlyRow extends StatelessWidget {
  const _FriendlyRow({
    required this.result,
    required this.code,
    required this.name,
    required this.careerId,
  });

  final int careerId;
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
            child: Align(
              alignment: Alignment.centerRight,
              child: NationTap(
                careerId: careerId,
                nationId: result.homeId,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
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
            child: Align(
              alignment: Alignment.centerLeft,
              child: NationTap(
                careerId: careerId,
                nationId: result.awayId,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
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
    required this.playoffNations,
    required this.relegated,
    required this.name,
    required this.code,
    required this.careerId,
  });

  final int careerId;
  final int pos;
  final GroupStanding standing;
  final bool isPlayer;
  final int directCount;
  final int? contentionPos;
  final Set<int> playoffNations;

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
        : playoffNations.contains(standing.nationId)
        ? AppColors.playoff
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
          Expanded(
            child: NationTap(
              careerId: careerId,
              nationId: standing.nationId,
              child: Row(
                children: [
                  FlagDisc(code(standing.nationId), size: 18),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      name(standing.nationId),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySmall.copyWith(
                        fontWeight: isPlayer
                            ? FontWeight.w700
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ],
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
