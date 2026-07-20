import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/competition/group_advancement.dart';
import 'package:fnm/domain/services/competition/trophies.dart';
import 'package:fnm/features/tournaments/best_thirds.dart';
import 'package:fnm/features/tournaments/continental_detail_providers.dart';
import 'package:fnm/features/tournaments/tournament_bracket.dart';
import 'package:fnm/features/tournaments/tournament_awards.dart';
import 'package:fnm/features/tournaments/tournament_history.dart';
import 'package:fnm/features/tournaments/tournament_stats.dart';
import 'package:fnm/features/tournaments/tournament_summary.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// Continental-championship detail: this cycle's knockout bracket (for the
/// player's own region), the scorer chart, and the full roll of honour for the
/// competition (which includes background-simulated editions of other regions).
class ContinentalDetailScreen extends ConsumerWidget {
  const ContinentalDetailScreen({
    required this.careerId,
    required this.confederation,
    super.key,
  });

  final int careerId;
  final Confederation confederation;

  static const List<BracketRound> _bracketRounds = [
    ('CR16', 'Round of 16'),
    ('CQF', 'Quarter-finals'),
    ('CSF', 'Semi-finals'),
    ('CFINAL', 'Final'),
  ];

  /// The main knockout ladder (excludes the third-place play-off, which hangs
  /// off the side rather than feeding the final), for the bracket columns.
  static const List<BracketRound> _ladder = [
    ('CR16', 'R16'),
    ('CQF', 'QF'),
    ('CSF', 'SF'),
    ('CFINAL', 'Final'),
  ];

  /// The tab to land on: wherever this championship actually is.
  static int _liveTab(ContinentalData? data) {
    if (data == null) return 0;
    // Another confederation's cup is simulated in the background but now has
    // real fixtures — land on its bracket if one exists, else its history.
    if (!data.isPlayerRegion) return data.knockout.isNotEmpty ? 2 : 4;
    if (data.knockout.isNotEmpty) return 2; // bracket
    if (data.groups.isNotEmpty && data.finalsDrawWatched) return 1; // finals
    return 0; // qualifying
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(
      continentalDetailProvider((
        careerId: careerId,
        confederation: confederation,
      )),
    );
    final liveTab = _liveTab(dataAsync.valueOrNull);

    return DefaultTabController(
      // See CupDetailScreen: initialIndex is read once, before the data lands.
      key: ValueKey(liveTab),
      length: 8,
      // +1 because SUMMARY is now the first tab.
      initialIndex: liveTab + 1,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: () =>
                context.go('${Routes.tournaments}?careerId=$careerId'),
          ),
          title: Text(
            dataAsync.maybeWhen(
              data: (d) => d?.name.toUpperCase() ?? 'CHAMPIONSHIP',
              orElse: () => 'CHAMPIONSHIP',
            ),
            style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
          ),
          centerTitle: true,
          // The tabs sit right on top of the content otherwise; the extra
          // height gives them room to breathe.
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(kTournamentTabBarHeight),
            child: TabBar(
              isScrollable: true,
              labelColor: AppColors.onSurface,
              unselectedLabelColor: AppColors.onSurfaceVariant,
              indicatorColor: AppColors.primary,
              tabs: [
                Tab(text: 'SUMMARY'),
                Tab(text: 'QUALIFYING'),
                Tab(text: 'FINALS'),
                Tab(text: 'BRACKET'),
                Tab(text: 'AWARDS'),
                Tab(text: 'SCORERS'),
                Tab(text: 'HISTORY'),
                Tab(text: 'RECORDS'),
              ],
            ),
          ),
        ),
        body: dataAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Could not load cup.\n$e')),
          data: (data) {
            if (data == null) {
              return const Center(child: Text('No cup data.'));
            }
            String code(int id) => data.nations[id]?.code ?? '??';
            String name(int id) => data.nations[id]?.name ?? 'Unknown';

            return TabBarView(
              children: [
                TournamentSummaryTab(
                  hostIds: data.hostIds,
                  hostCities: data.hostCities,
                  identity: data.identity,
                  trophyAsset: Trophies.forConfederation(data.confederation),
                  code: code,
                  name: name,
                ),
                if (data.qualifyingGroups.isNotEmpty && !data.qualDrawWatched)
                  const TournamentSoon(
                    message:
                        'Groups to be drawn — watch the qualifying '
                        'draw from the hub to reveal them.',
                  )
                else if (data.qualifyingGroups.isNotEmpty)
                  () {
                    final size =
                        ContinentalCups
                            .byConfederation[data.confederation]
                            ?.size ??
                        24;
                    // Hosts reserve finals berths, so fewer teams (and fewer
                    // best-thirds) come through qualifying.
                    final adv = GroupAdvancement.continentalQualifying(
                      (size - data.hostCount).clamp(1, size),
                      data.qualifyingGroups.length,
                    );
                    return _Groups(
                      groups: data.qualifyingGroups,
                      playerNationId: data.playerNationId,
                      directCount: adv.direct,
                      contentionPos: adv.contention,
                      thirdsQualify: adv.thirdsQualify,
                      runnersQualify: adv.runnersQualify,
                      // Qualifying thirds advance to the finals, not knockouts.
                      thirdsDestination: 'the finals',
                      code: code,
                      name: name,
                    );
                  }()
                else
                  TournamentSoon(
                    message: data.isPlayerRegion
                        ? 'Qualifying is seeded by ranking this cycle.'
                        : 'Only your own confederation is played in detail. '
                              '${data.name} is decided in the background — see '
                              'its full results under History.',
                  ),
                if (data.groups.isNotEmpty && !data.finalsDrawWatched)
                  const TournamentSoon(
                    message:
                        'Groups to be drawn — watch the finals draw '
                        'from the hub to reveal them.',
                  )
                else if (data.groups.isNotEmpty)
                  () {
                    // Copa América: two groups of five, top four into the
                    // quarters. Every other format advances the top two (plus
                    // any best-thirds).
                    final copa = data.groups.length == 2 &&
                        data.groups
                            .every((g) => g.standings.length >= 5);
                    return _Groups(
                    groups: data.groups,
                    playerNationId: data.playerNationId,
                    // Finals: top two advance; best thirds are in contention
                    // (top four for the Copa América groups of five).
                    directCount: copa ? 4 : 2,
                    contentionPos: copa
                        ? null
                        : WorldCupFinals.bestThirdsFor(data.groups.length) > 0
                            ? 3
                            : null,
                    thirdsQualify: copa
                        ? 0
                        : WorldCupFinals.bestThirdsFor(
                            data.groups.length,
                          ),
                    code: code,
                    name: name,
                  );
                  }()
                else
                  TournamentSoon(
                    message: data.isPlayerRegion
                        ? 'The finals draw happens once qualifying ends.'
                        : 'Only your own confederation is played in detail. '
                              '${data.name} is decided in the background — see '
                              'its full results under History.',
                  ),
                if (data.knockout.isNotEmpty)
                  TournamentBracket(
                    fixtures: data.knockout,
                    rounds: _bracketRounds,
                    ladder: _ladder,
                    champion: data.champion,
                    championLabel: '${data.name.toUpperCase()} CHAMPIONS',
                    playerNationId: data.playerNationId,
                    // Only the manager's own confederation is played out, so a
                    // run to highlight exists only there.
                    runSummary: !data.isPlayerRegion
                        ? null
                        : playerRunSummary(
                            playerNationId: data.playerNationId,
                            champion: data.champion,
                            knockout: data.knockout,
                            groups: data.groups,
                            championTitle: '${data.name} winners! 🏆',
                          ),
                    groupSeeds: groupSeedsOf(data.groups),
                    code: code,
                    name: name,
                  )
                else
                  TournamentSoon(
                    message: data.isPlayerRegion
                        ? 'Your continental championship is contested in the '
                              'season before the World Cup.'
                        : 'Only your own confederation is played in detail. '
                              '${data.name} is decided in the background — see '
                              'its full results under History.',
                  ),
                TournamentAwardsTab(
                  team: data.teamOfTournament,
                  goldenGlove: data.goldenGlove,
                  code: code,
                  name: name,
                ),
                TournamentScorers(
                  scorers: data.scorers,
                  playerNames: data.playerNames,
                  allTime: data.allTimeScorers,
                  code: code,
                  emptyMessage: 'No goals recorded yet.',
                ),
                TournamentHistory(
                  honours: data.honours,
                  name: name,
                  code: code,
                ),
                TournamentStatsTab(
                  honours: data.honours,
                  allTimeScorers: data.allTimeScorers,
                  code: code,
                  name: name,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Groups extends StatelessWidget {
  const _Groups({
    required this.groups,
    required this.playerNationId,
    required this.directCount,
    required this.contentionPos,
    required this.thirdsQualify,
    required this.code,
    required this.name,
    this.runnersQualify = 0,
    this.thirdsDestination = 'the knockouts',
  });

  final List<FinalsGroupTable> groups;
  final int playerNationId;

  /// Positions that advance/qualify outright (green).
  final int directCount;

  /// A single position marked "in contention" (amber — best runner-up / best
  /// third), or null when there is no such spot.
  final int? contentionPos;

  /// How many best third-placed teams qualify (drives the best-thirds card).
  final int thirdsQualify;

  /// How many runners-up qualify. When only some do (fewer than there are
  /// groups), a cross-group runners-up ladder is shown so second place's real
  /// chances are visible instead of just an amber stripe.
  final int runnersQualify;

  /// Where the best thirds advance to ('the finals' in qualifying).
  final String thirdsDestination;

  final String Function(int) code;
  final String Function(int) name;

  @override
  Widget build(BuildContext context) {
    final thirds = [
      for (final g in groups)
        if (g.standings.length > 2) g.standings[2],
    ]..sort(rankStandings);
    final qualifyThirds = thirdsQualify;

    // The player's own group first, the rest in their drawn order.
    final ordered = [
      for (final g in groups)
        if (g.standings.any((s) => s.nationId == playerNationId)) g,
      for (final g in groups)
        if (!g.standings.any((s) => s.nationId == playerNationId)) g,
    ];

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [
        for (final g in ordered) ...[
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'GROUP ${g.name}',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                for (var i = 0; i < g.standings.length; i++)
                  _row(i + 1, g.standings[i]),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        if (runnersQualify > 0 && runnersQualify < groups.length) ...[
          BestThirdsCard(
            thirds: [
              for (final g in groups)
                if (g.standings.length > 1) g.standings[1],
            ]..sort(rankStandings),
            qualifyCount: runnersQualify,
            playerNationId: playerNationId,
            code: code,
            name: name,
            destination: thirdsDestination,
            title: 'BEST RUNNERS-UP',
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        if (qualifyThirds > 0 && thirds.length > qualifyThirds)
          BestThirdsCard(
            thirds: thirds,
            qualifyCount: qualifyThirds,
            playerNationId: playerNationId,
            code: code,
            name: name,
            destination: thirdsDestination,
          ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  Widget _row(int pos, GroupStanding s) {
    final isPlayer = s.nationId == playerNationId;
    final advancing = pos <= directCount;
    final inContention = pos == contentionPos;
    final accent = advancing
        ? AppColors.positive
        : inContention
        ? AppColors.warning
        : null;
    final gd = s.goalDifference;
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
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
      child: Row(
        children: [
          SizedBox(
            width: 18,
            child: Text(
              '$pos',
              style: AppTypography.labelSmall.copyWith(
                color: accent ?? AppColors.onSurfaceVariant,
                fontWeight: accent != null ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
          FlagDisc(code(s.nationId), size: 22),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              name(s.nationId),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySmall.copyWith(
                fontWeight: isPlayer ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ),
          _cell('${s.played}'),
          _cell(gd > 0 ? '+$gd' : '$gd'),
          _cell('${s.points}', emphasize: true),
        ],
      ),
    );
  }

  Widget _cell(String text, {bool emphasize = false}) => SizedBox(
    width: 30,
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: AppTypography.labelSmall.copyWith(
        color: emphasize ? AppColors.primary : AppColors.onSurface,
        fontWeight: emphasize ? FontWeight.w700 : FontWeight.w500,
      ),
    ),
  );
}
