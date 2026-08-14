import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/rating/overall_rating.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/records/record_book_screen.dart';
import 'package:fnm/features/federation/federation_providers.dart';
import 'package:fnm/features/stats/stats_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

typedef _StatEntry = ({int playerId, int value});

typedef _RatingEntry = ({
  int playerId,
  int apps,
  double meanRating,
  int motms,
});

typedef _StatsView = ({
  Nation? nation,
  List<_StatEntry> scorers,
  List<_StatEntry> appearances,
  List<_RatingEntry> ratings,
  Map<int, String> names,
});

final AutoDisposeFutureProviderFamily<_StatsView?, int>
_teamStatsProvider = FutureProvider.autoDispose.family<_StatsView?, int>((
  ref,
  careerId,
) async {
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) return null;
  final comp = ref.watch(competitionRepositoryProvider);
  final nationId = career.nationId;

  final scorers = [
    for (final s in await comp.nationTopScorers(careerId, nationId, limit: 25))
      (playerId: s.playerId, value: s.goals),
  ];
  final appearances = [
    for (final a in await comp.nationTopAppearances(
      careerId,
      nationId,
      limit: 25,
    ))
      (playerId: a.playerId, value: a.games),
  ];
  // Best average match rating. Every match in the world is rated now, so this
  // is a full record rather than only the games the manager was in charge for.
  final ratings = await comp.nationTopRatings(careerId, nationId, limit: 25);

  final playerRepo = ref.watch(playerRepositoryProvider);
  final aging = CareerService.agingYears(career);
  final youth = await ref.watch(youthBonusByCycleProvider(careerId).future);
  final careerDev = await ref.watch(careerDevBonusProvider(careerId).future);
  final ids = {
    for (final s in [...scorers, ...appearances]) s.playerId,
    for (final r in ratings) r.playerId,
  };
  final names = <int, String>{};
  for (final id in ids) {
    final p = await playerRepo.byId(
      id,
      agingYears: aging,
      saveSeed: career.rngSeed,
      youthBonusByCycle: youth,
      careerStartsByPlayer: careerDev,
    );
    names[id] = p?.name ?? 'Unknown';
  }

  final nations = await ref.watch(nationRepositoryProvider).all();
  return (
    nation: nations.where((n) => n.id == nationId).firstOrNull,
    scorers: scorers,
    appearances: appearances,
    ratings: ratings,
    names: names,
  );
});

/// The player's national-team records: all-time and per-competition top
/// scorers ("who scored the most for your team").
class TeamStatsScreen extends ConsumerStatefulWidget {
  const TeamStatsScreen({required this.careerId, super.key});

  final int careerId;

  @override
  ConsumerState<TeamStatsScreen> createState() => _TeamStatsScreenState();
}

class _TeamStatsScreenState extends ConsumerState<TeamStatsScreen> {
  /// 0 top scorers · 1 most games · 2 best ratings · 3 the manager's career.
  int _tab = 0;

  /// One segment of the leaderboard selector, its label clipped to a single
  /// line so it can never overrun the segment it sits in.
  ButtonSegment<int> _segment(int value, String label) => ButtonSegment(
    value: value,
    label: Text(
      label,
      maxLines: 1,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: AppTypography.labelSmall,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final viewAsync = ref.watch(_teamStatsProvider(widget.careerId));
    final l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () =>
              context.go('${Routes.hub}?careerId=${widget.careerId}'),
        ),
        title: Text(
          l.statsTeamRecords,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: viewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l.statsCouldNotLoadStats(e.toString()))),
        data: (view) {
          if (view == null) return Center(child: Text(l.statsNoData));
          final list = _tab == 0 ? view.scorers : view.appearances;
          final unit = _tab == 0 ? l.recordsUnitGoals : '';

          return Column(
            children: [
              // One header, not three. The nation, the manager's record under
              // it, and the way out to the legacy screens all sit in the space
              // the old flag-and-name row used on its own — so a leaderboard is
              // visible on the first screenful instead of below 300px of chrome.
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.marginMobile,
                  AppSpacing.sm,
                  AppSpacing.marginMobile,
                  0,
                ),
                child: _TeamHeader(
                  careerId: widget.careerId,
                  nation: view.nation,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              // The all-time sections — the legends XI, the world records, the
              // head-to-head archive — used to hide behind a single unlabelled
              // icon in the app bar. They are the point of a long career, so
              // they stay named and on the page, as one compact strip.
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.marginMobile,
                ),
                child: LegacyTiles(
                  careerId: widget.careerId,
                  includeRecordBook: true,
                  dense: true,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.marginMobile,
                ),
                // The segment names the list, so the list needs no heading of
                // its own — that duplicate line is gone.
                child: SegmentedButton<int>(
                  showSelectedIcon: false,
                  style: const ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    padding: WidgetStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                    ),
                  ),
                  // Four equal segments on a phone leave very little room per
                  // label, and a translated one ("Nejlepší střelci") ran
                  // straight out of its segment. Each label is now a single
                  // ellipsised line, so a long word shortens instead of
                  // spilling over the button's edge.
                  segments: [
                    _segment(0, l.statsTopScorersShort),
                    _segment(1, l.statsMostGames),
                    _segment(2, l.statsBestRated),
                    _segment(3, l.statsMyCareer),
                  ],
                  selected: {_tab},
                  onSelectionChanged: (s) => setState(() => _tab = s.first),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: switch (_tab) {
                  3 => _CareerRecord(careerId: widget.careerId),
                  2 =>
                    view.ratings.isEmpty
                        ? Center(child: Text(l.statsNoRatingsRecorded))
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.marginMobile,
                            ),
                            itemCount: view.ratings.length,
                            itemBuilder: (context, i) {
                              final r = view.ratings[i];
                              return _RatingRow(
                                rank: i + 1,
                                name: view.names[r.playerId] ?? l.statsUnknown,
                                flagCode: view.nation?.code,
                                entry: r,
                                onInfo: () => context.push(
                                  '${Routes.player}?careerId=${widget.careerId}'
                                  '&playerId=${r.playerId}',
                                ),
                              );
                            },
                          ),
                  _ =>
                    list.isEmpty
                        ? Center(child: Text(l.statsNoGoalsRecorded))
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.marginMobile,
                            ),
                            itemCount: list.length,
                            itemBuilder: (context, i) {
                              final s = list[i];
                              return _ScorerRow(
                                rank: i + 1,
                                name: view.names[s.playerId] ?? l.statsUnknown,
                                flagCode: view.nation?.code,
                                value: s.value,
                                unit: unit,
                                onInfo: () => context.push(
                                  '${Routes.player}?careerId=${widget.careerId}'
                                  '&playerId=${s.playerId}',
                                ),
                              );
                            },
                          ),
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

/// The screen's one header: who the team is and what the manager has done with
/// it, on a single card.
///
/// The flag and the nation's name used to have a whole headline row to
/// themselves, above a "Legacy" caption and a grid of four tall cards — three
/// stacked blocks of chrome before a single record appeared. The record itself
/// is the interesting part of a records screen, so it leads here.
class _TeamHeader extends ConsumerWidget {
  const _TeamHeader({required this.careerId, required this.nation});

  final int careerId;
  final Nation? nation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final stats = ref.watch(careerStatsProvider(careerId)).valueOrNull;
    // The nation's own strength, read off its strongest eleven — the number the
    // match preview shows against the opponent's, in the one place a manager
    // comes to ask how good his side actually is.
    final pool = ref.watch(squadDataProvider(careerId)).valueOrNull?.pool;
    final overall = pool == null ? null : squadOverall(pool);
    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (nation != null) ...[
                FlagDisc(nation!.code, size: 26),
                const SizedBox(width: AppSpacing.sm),
              ],
              Expanded(
                child: Text(
                  nation?.name ?? l.statsTeam,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.titleMedium,
                ),
              ),
              if (overall != null) ...[
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '${l.teamOverall} $overall',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ],
          ),
          if (stats != null && stats.played > 0) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                _stat(l.statsPlayed, '${stats.played}'),
                _stat(
                  l.statsWinDrawLoss,
                  '${stats.wins}–${stats.draws}–${stats.losses}',
                ),
                _stat(
                  l.statsWinRate,
                  '${(stats.winRate * 100).round()}%',
                ),
                _stat(
                  l.statsGoals,
                  '${stats.goalsFor}:${stats.goalsAgainst}',
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _stat(String label, String value) => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.labelSmall.copyWith(
            fontSize: 9,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
      ],
    ),
  );
}

/// One leaderboard line. A tight row rather than a card of its own: a card per
/// player fitted six names on a phone screen and made a top-25 chart a scroll
/// with no shape to it.
class _ScorerRow extends StatelessWidget {
  const _ScorerRow({
    required this.rank,
    required this.name,
    required this.flagCode,
    required this.value,
    required this.onInfo,
    this.unit = '',
  });

  final int rank;
  final String name;
  final String? flagCode;
  final int value;

  /// What the number counts ('goals'), shown after it. Empty for a bare count.
  final String unit;
  final VoidCallback onInfo;

  @override
  Widget build(BuildContext context) {
    // The top three carry the chart, so they are marked rather than left to be
    // counted down to.
    final podium = rank <= 3;
    return InkWell(
      onTap: onInfo,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          children: [
            SizedBox(
              width: 22,
              child: Text(
                '$rank',
                style: AppTypography.labelMedium.copyWith(
                  color: podium
                      ? AppColors.primary
                      : AppColors.onSurfaceVariant,
                ),
              ),
            ),
            if (flagCode != null) ...[
              FlagDisc(flagCode!, size: 18),
              const SizedBox(width: AppSpacing.sm),
            ],
            Expanded(
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: rank == 1 ? FontWeight.w700 : null,
                ),
              ),
            ),
            Text(
              unit.isEmpty ? '$value' : '$value $unit',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One player's average-rating line.
class _RatingRow extends StatelessWidget {
  const _RatingRow({
    required this.rank,
    required this.name,
    required this.flagCode,
    required this.entry,
    required this.onInfo,
  });

  final int rank;
  final String name;
  final String? flagCode;
  final _RatingEntry entry;
  final VoidCallback onInfo;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return InkWell(
      onTap: onInfo,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            SizedBox(
              width: 26,
              child: Text(
                '$rank',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
            if (flagCode != null) ...[
              FlagDisc(flagCode!, size: 18),
              const SizedBox(width: AppSpacing.sm),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodyMedium,
                  ),
                  Text(
                    entry.motms > 0
                        ? '${l.statsAppsShort(entry.apps)} · '
                              '${l.statsMotmShort(entry.motms)}'
                        : l.statsAppsShort(entry.apps),
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              entry.meanRating.toStringAsFixed(2),
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.ratingColor(entry.meanRating),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The manager's own record, in full.
///
/// It existed only as a compact summary card buried on the career screen —
/// a handful of the numbers the aggregation layer already computes. This is
/// the whole thing: the record, the runs, the extremes and what the squad has
/// done under this manager.
class _CareerRecord extends ConsumerWidget {
  const _CareerRecord({required this.careerId});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(careerStatsProvider(careerId));
    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) =>
          Center(child: Text(l.statsCouldNotLoadStats(e.toString()))),
      data: (s) {
        if (s.played == 0) return Center(child: Text(l.statsNoData));
        return ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.marginMobile,
          ),
          children: [
            _group(l.statsGroupRecord, [
              (l.statsPlayed, '${s.played}'),
              (
                l.statsWinDrawLoss,
                '${s.wins}–${s.draws}–${s.losses}',
              ),
              (l.statsWinRate, '${(s.winRate * 100).round()}%'),
              (
                l.statsGoals,
                '${s.goalsFor}:${s.goalsAgainst} '
                    '(${s.goalDifference >= 0 ? '+' : ''}${s.goalDifference})',
              ),
              (l.statsCleanSheets, '${s.cleanSheets}'),
              (l.statsFailedToScore, '${s.failedToScore}'),
            ]),
            _group(l.statsGroupRuns, [
              (l.statsLongestWinStreak, '${s.longestWinStreak}'),
              (l.statsLongestUnbeaten, '${s.longestUnbeatenRun}'),
              (l.statsLongestCleanSheets, '${s.longestCleanSheetStreak}'),
              (l.statsLongestWinless, '${s.longestWinlessRun}'),
              (l.statsCurrentRun, '${s.currentUnbeatenRun}'),
            ]),
            _group(l.statsGroupExtremes, [
              (l.statsBiggestWin, '+${s.biggestWinMargin}'),
              (l.statsHeaviestDefeat, '−${s.heaviestDefeatMargin}'),
              (l.statsMostGoalsInAGame, '${s.mostGoalsInAGame}'),
              (
                l.statsShootouts,
                '${s.shootoutsWon}–${s.shootoutsLost}',
              ),
              (l.statsComebackWins, '${s.comebackWins}'),
            ]),
            _group(l.statsGroupSplits, [
              (
                l.statsHome,
                '${s.homeWins}–${s.homeDraws}–${s.homeLosses}',
              ),
              (
                l.statsAway,
                '${s.awayWins}–${s.awayDraws}–${s.awayLosses}',
              ),
              (
                l.statsNeutral,
                '${s.neutralWins}–${s.neutralDraws}–${s.neutralLosses}',
              ),
              (l.statsCompetitive, '${s.competitivePlayed}'),
              (l.statsFriendlies, '${s.friendlyPlayed}'),
            ]),
            _group(l.statsGroupSquad, [
              (l.statsHatTricks, '${s.hatTricks}'),
              (l.statsBraces, '${s.braces}'),
              (l.statsMotms, '${s.playerMotms}'),
              (l.statsAssists, '${s.playerAssists}'),
              (
                l.statsCards,
                '${s.playerYellows}Y / ${s.playerReds}R',
              ),
              (
                l.statsBestRating,
                s.bestPlayerRating.toStringAsFixed(2),
              ),
            ]),
            const SizedBox(height: AppSpacing.xl),
          ],
        );
      },
    );
  }

  Widget _group(String title, List<(String, String)> rows) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.md),
    child: AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final (label, value) in rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                  Text(value, style: AppTypography.labelMedium),
                ],
              ),
            ),
        ],
      ),
    ),
  );
}
