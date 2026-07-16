import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

typedef _PlayerView = ({
  Player? player,
  Nation? nation,
  int goals,
  PlayerCareerStats? stats,
  List<PlayerMatchStat> history,
  Map<int, Nation> nationsById,
});
typedef _PlayerArg = ({int careerId, int playerId});

final AutoDisposeFutureProviderFamily<_PlayerView, _PlayerArg>
_playerDetailProvider =
    FutureProvider.autoDispose.family<_PlayerView, _PlayerArg>((
  ref,
  arg,
) async {
  final career = await ref.watch(careerRepositoryProvider).byId(arg.careerId);
  final player = await ref.watch(playerRepositoryProvider).byId(
        arg.playerId,
        agingYears: career == null ? 0 : CareerService.agingYears(career),
        saveSeed: career?.rngSeed ?? 0,
      );
  Nation? nation;
  var goals = 0;
  PlayerCareerStats? stats;
  var history = const <PlayerMatchStat>[];
  final nationsById = <int, Nation>{};
  if (player != null) {
    final comp = ref.watch(competitionRepositoryProvider);
    final nations = await ref.watch(nationRepositoryProvider).all();
    for (final n in nations) {
      nationsById[n.id] = n;
    }
    nation = nationsById[player.nationId];
    // All-time goals for this player in the career (across every competition).
    final tallies =
        await comp.nationTopScorers(arg.careerId, player.nationId, limit: 500);
    goals = tallies
        .where((t) => t.playerId == player.id)
        .fold(0, (s, t) => s + t.goals);
    stats = await comp.playerCareerStats(arg.careerId, player.id);
    history = await comp.playerMatchHistory(arg.careerId, player.id);
  }
  return (
    player: player,
    nation: nation,
    goals: goals,
    stats: stats,
    history: history,
    nationsById: nationsById,
  );
});

/// A player's detail card: identity, club/value, and the ten attributes. Base
/// data for now — reachable from anywhere a player is listed.
class PlayerDetailScreen extends ConsumerWidget {
  const PlayerDetailScreen({
    required this.careerId,
    required this.playerId,
    super.key,
  });

  final int careerId;
  final int playerId;

  static String money(int euros) {
    if (euros >= 1000000) return '€${(euros / 1000000).toStringAsFixed(1)}M';
    if (euros >= 1000) return '€${(euros / 1000).round()}K';
    return '€$euros';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewAsync = ref.watch(
      _playerDetailProvider((careerId: careerId, playerId: playerId)),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.canPop()
              ? context.pop()
              : Navigator.of(context).maybePop(),
        ),
        title: Text(
          'PLAYER',
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: viewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load player.\n$e')),
        data: (view) {
          final p = view.player;
          if (p == null) return const Center(child: Text('Player not found.'));
          final a = p.attributes;

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            children: [
              AppCard(
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary, width: 2),
                      ),
                      child: Text(
                        '${p.overall}',
                        style: AppTypography.headlineMedium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.name, style: AppTypography.headlineMedium),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              TacticalChip(p.position.label),
                              const SizedBox(width: AppSpacing.sm),
                              if (view.nation != null)
                                FlagDisc(view.nation!.code, size: 18),
                              const SizedBox(width: AppSpacing.xs),
                              Flexible(
                                child: Text(
                                  view.nation?.name ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppCard(
                child: Column(
                  children: [
                    _fact('Club', p.club),
                    _fact('Position', p.position.roleName),
                    _fact('Age', '${p.age}'),
                    _fact('Value', money(p.value)),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'CAREER RECORD',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              if (view.stats case final s?)
                _CareerStatsCard(stats: s, goals: view.goals)
              else
                AppCard(child: _fact('International goals', '${view.goals}')),
              if (view.history.length >= 3) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  'RECENT FORM',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                AppCard(
                  child: _FormSparkline(
                    // Oldest → newest, capped to the last dozen games.
                    ratings: [
                      for (final m in view.history.take(12).toList().reversed)
                        m.rating,
                    ],
                  ),
                ),
              ],
              if (view.history.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  'MATCH HISTORY',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                AppCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      for (final m in view.history)
                        _HistoryRow(
                          stat: m,
                          playerNationId: p.nationId,
                          nationsById: view.nationsById,
                        ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              Text(
                'ATTRIBUTES',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              for (final s in <(String, int)>[
                ('Pace', a.pace),
                ('Shooting', a.shooting),
                ('Passing', a.passing),
                ('Dribbling', a.dribbling),
                ('Tackling', a.tackling),
                ('Positioning', a.positioning),
                ('Composure', a.composure),
                ('Decisions', a.decisions),
                ('Stamina', a.stamina),
                ('Strength', a.strength),
              ])
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: StatBar(label: s.$1, value: s.$2),
                ),
              const SizedBox(height: AppSpacing.xl),
            ],
          );
        },
      ),
    );
  }

  Widget _fact(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            Text(
              label.toUpperCase(),
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            Text(value, style: AppTypography.bodyMedium),
          ],
        ),
      );
}

/// One match on the player's history list: date, opponent, the scoreline from
/// this player's perspective (win/draw/loss coloured), any goals, and the mark.
class _HistoryRow extends StatelessWidget {
  const _HistoryRow({
    required this.stat,
    required this.playerNationId,
    required this.nationsById,
  });

  final PlayerMatchStat stat;
  final int playerNationId;
  final Map<int, Nation> nationsById;

  @override
  Widget build(BuildContext context) {
    final isHome = stat.homeNationId == playerNationId;
    final opponentId = isHome ? stat.awayNationId : stat.homeNationId;
    final opp = nationsById[opponentId];
    final my = isHome ? stat.homeScore : stat.awayScore;
    final other = isHome ? stat.awayScore : stat.homeScore;
    final resultColor = (my == null || other == null)
        ? AppColors.onSurfaceVariant
        : my > other
            ? AppColors.positive
            : my < other
                ? AppColors.error
                : AppColors.onSurfaceVariant;
    final score = (my == null || other == null) ? '–' : '$my–$other';

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 58,
            child: Text(
              DateFormat('d MMM yy').format(stat.date),
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          FlagDisc(opp?.code ?? '??', size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              opp?.name ?? 'Unknown',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySmall,
            ),
          ),
          if (stat.motm) ...[
            const Icon(Icons.star_rounded, size: 13, color: AppColors.primary),
            const SizedBox(width: AppSpacing.xs),
          ],
          if (stat.goals > 0) ...[
            const Icon(
              Icons.sports_soccer,
              size: 13,
              color: AppColors.onSurfaceVariant,
            ),
            const SizedBox(width: 2),
            Text(
              '${stat.goals}',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          if (stat.assists > 0) ...[
            const Icon(
              Icons.assistant_direction_outlined,
              size: 13,
              color: AppColors.onSurfaceVariant,
            ),
            const SizedBox(width: 2),
            Text(
              '${stat.assists}',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          SizedBox(
            width: 34,
            child: Text(
              score,
              textAlign: TextAlign.center,
              style: AppTypography.labelMedium.copyWith(color: resultColor),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          _RatingBadge(stat.rating),
        ],
      ),
    );
  }
}

/// A compact coloured match-rating badge (green strong → red poor).
class _RatingBadge extends StatelessWidget {
  const _RatingBadge(this.rating);

  final double rating;

  Color get _color {
    if (rating >= 7.5) return const Color(0xFF2E9E5B);
    if (rating >= 6.5) return const Color(0xFF4C86C6);
    if (rating >= 5.5) return AppColors.onSurfaceVariant;
    return const Color(0xFFD64545);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.16),
        borderRadius: AppRadii.smAll,
      ),
      child: Text(
        rating.toStringAsFixed(1),
        style: AppTypography.labelMedium.copyWith(color: _color),
      ),
    );
  }
}

/// The player's aggregated international record as a grid of stat tiles.
class _CareerStatsCard extends StatelessWidget {
  const _CareerStatsCard({required this.stats, required this.goals});

  final PlayerCareerStats stats;

  /// All-time goals from the scorer charts (spans quick-simmed games too), used
  /// when it exceeds the rated-match goal tally.
  final int goals;

  @override
  Widget build(BuildContext context) {
    final totalGoals = goals > stats.goals ? goals : stats.goals;
    final tiles = <(String, String)>[
      ('Caps', '${stats.caps}'),
      ('Goals', '$totalGoals'),
      ('Assists', '${stats.assists}'),
      ('Avg rating', stats.avgRating.toStringAsFixed(2)),
      ('Form', stats.formRating.toStringAsFixed(2)),
      ('Player of Match', '${stats.motm}'),
      ('Clean sheets', '${stats.cleanSheets}'),
      ('Best game', stats.bestRating.toStringAsFixed(1)),
      ('Cards', '${stats.yellows}Y ${stats.reds}R'),
    ];
    return AppCard(
      child: Wrap(
        spacing: AppSpacing.md,
        runSpacing: AppSpacing.md,
        children: [for (final t in tiles) _StatTile(label: t.$1, value: t.$2)],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 92,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: AppTypography.titleMedium),
          Text(
            label.toUpperCase(),
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// A tiny bar sparkline of recent match ratings (oldest → newest), each bar
/// coloured by its rating band, so a player's form reads at a glance.
class _FormSparkline extends StatelessWidget {
  const _FormSparkline({required this.ratings});

  final List<double> ratings;

  static Color _colorFor(double r) {
    if (r >= 7.5) return const Color(0xFF2E9E5B);
    if (r >= 6.5) return const Color(0xFF4C86C6);
    if (r >= 5.5) return AppColors.onSurfaceVariant;
    return const Color(0xFFD64545);
  }

  @override
  Widget build(BuildContext context) {
    const trackHeight = 52.0;
    return SizedBox(
      height: trackHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final r in ratings)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1.5),
                child: Container(
                  // Map the 3.0–10.0 mark onto the bar height.
                  height: (((r - 3) / 7).clamp(0.06, 1.0)) * trackHeight,
                  decoration: BoxDecoration(
                    color: _colorFor(r),
                    borderRadius: AppRadii.smAll,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
