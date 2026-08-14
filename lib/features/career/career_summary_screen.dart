import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/features/career/career_summary_providers.dart';
import 'package:fnm/features/stats/stats_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

const _gold = AppColors.medalGold;
const _silver = AppColors.medalSilver;
const _bronze = AppColors.medalBronze;

/// The manager's career at a glance: team, world standing, overall record, a
/// trophy cabinet, and a finish-by-finish tournament history.
class CareerSummaryScreen extends ConsumerWidget {
  const CareerSummaryScreen({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(careerSummaryProvider(careerId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.go('${Routes.hub}?careerId=$careerId'),
        ),
        title: Text(
          l.careerTitle,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.careerCouldNotLoadCareer('$e'))),
        data: (s) {
          if (s == null) return Center(child: Text(l.careerNoCareer));
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            children: [
              _Header(s),
              const SizedBox(height: AppSpacing.sm),
              _RecordCard(s),
              _CareerStatsSection(careerId),
              const SizedBox(height: AppSpacing.md),
              Text(
                l.careerTrophyCabinet,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              _TrophyCabinet(s),
              if (s.titles.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                _TitlesList(s.titles),
              ],
              const SizedBox(height: AppSpacing.md),
              Text(
                l.careerTournamentHistory,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              if (s.runs.isEmpty)
                AppCard(child: Text(l.careerNoTournamentsYet))
              else
                for (final r in s.runs) _RunRow(r),
              const SizedBox(height: AppSpacing.xl),
            ],
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.s);

  final CareerSummary s;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final rank = s.worldRank;
    return AppCard(
      child: Row(
        children: [
          if (s.nation != null)
            FlagDisc(s.nation!.code, size: 48, highlighted: true),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.nation?.name ?? l.careerTeamFallback,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.headlineMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  s.career.managerName,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xs,
                  children: [
                    if (rank != null)
                      TacticalChip(l.careerWorldNum(rank), emphasized: true),
                    if (s.worldPoints != null)
                      TacticalChip(l.careerPointsNum(s.worldPoints!)),
                    TacticalChip(
                      l.careerSeasonNum(s.seasons),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecordCard extends StatelessWidget {
  const _RecordCard(this.s);

  final CareerSummary s;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final gd = s.goalDifference;
    return AppCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _stat(l.careerStatPlayedShort, '${s.played}'),
          _stat(
            l.careerStatWonShort,
            '${s.won}',
            color: const Color(0xFF3FA34D),
          ),
          _stat(l.careerStatDrawnShort, '${s.drawn}'),
          _stat(
            l.careerStatLostShort,
            '${s.lost}',
            color: const Color(0xFFD64545),
          ),
          _stat(l.careerStatGoalsForShort, '${s.goalsFor}'),
          _stat(l.careerStatGoalsAgainstShort, '${s.goalsAgainst}'),
          _stat(l.careerStatGoalDiffShort, '${gd >= 0 ? '+' : ''}$gd'),
        ],
      ),
    );
  }

  Widget _stat(String label, String value, {Color? color}) => Column(
    children: [
      Text(
        value,
        style: AppTypography.titleMedium.copyWith(
          color: color ?? AppColors.onSurface,
        ),
      ),
      const SizedBox(height: 2),
      Text(
        label,
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),
    ],
  );
}

/// The deeper career numbers beyond the W/D/L line — streaks, clean sheets,
/// shootouts and the manager's players' feats — from [careerStatsProvider].
/// Renders nothing until at least one match has been played.
class _CareerStatsSection extends ConsumerWidget {
  const _CareerStatsSection(this.careerId);

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final s = ref.watch(careerStatsProvider(careerId)).valueOrNull;
    if (s == null || s.played == 0) return const SizedBox.shrink();
    final tiles = <(String, String)>[
      (l.careerStatsWinRate, '${(s.winRate * 100).round()}%'),
      (l.careerStatsCleanSheets, '${s.cleanSheets}'),
      (l.careerStatsBiggestWin, '+${s.biggestWinMargin}'),
      (l.careerStatsWinStreak, '${s.longestWinStreak}'),
      (l.careerStatsUnbeaten, '${s.longestUnbeatenRun}'),
      (l.careerStatsShootouts, '${s.shootoutsWon}–${s.shootoutsLost}'),
      (l.careerStatsMotms, '${s.playerMotms}'),
      if (s.hatTricks > 0) (l.careerStatsHatTricks, '${s.hatTricks}'),
      if (s.bestPlayerRating > 0)
        (l.careerStatsBestRating, s.bestPlayerRating.toStringAsFixed(1)),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.md),
        Text(
          l.careerStatsHeading,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          child: LayoutBuilder(
            builder: (context, c) {
              const cols = 3;
              final w = (c.maxWidth - AppSpacing.md * (cols - 1)) / cols;
              return Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                children: [
                  for (final t in tiles)
                    SizedBox(
                      width: w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.$2,
                            style: AppTypography.titleMedium.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            t.$1,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Every title the manager has won: each competition, how many times, and the
/// year and nation of each win.
class _TitlesList extends StatelessWidget {
  const _TitlesList(this.titles);

  final List<TrophyTitle> titles;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < titles.length; i++) ...[
            if (i > 0) const Divider(height: AppSpacing.md),
            _titleRow(titles[i]),
          ],
        ],
      ),
    );
  }

  Widget _titleRow(TrophyTitle t) {
    // "2038 (Brazil) · 2030 (Argentina)" — each win with its nation, since a
    // manager can lift the same trophy with different countries.
    final wins = t.wins.map((w) => '${w.year} (${w.nationName})').join('  ·  ');
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.emoji_events, color: _gold, size: 20),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      t.competition,
                      style: AppTypography.titleMedium,
                    ),
                  ),
                  if (t.count > 1)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryContainer,
                        borderRadius: AppRadii.smAll,
                      ),
                      child: Text(
                        '×${t.count}',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                wins,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TrophyCabinet extends StatelessWidget {
  const _TrophyCabinet(this.s);

  final CareerSummary s;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final empty = s.golds == 0 && s.silvers == 0 && s.bronzes == 0;
    return AppCard(
      child: empty
          ? Row(
              children: [
                const Icon(
                  Icons.emoji_events_outlined,
                  color: AppColors.onSurfaceVariant,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  l.careerNoSilverware,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _medal(_gold, s.golds, l.careerMedalGold),
                _medal(_silver, s.silvers, l.careerMedalSilver),
                _medal(_bronze, s.bronzes, l.careerMedalBronze),
              ],
            ),
    );
  }

  Widget _medal(Color color, int count, String label) => Column(
    children: [
      Icon(Icons.emoji_events, color: color, size: 30),
      const SizedBox(height: 4),
      Text(
        '$count',
        style: AppTypography.headlineMedium.copyWith(color: color),
      ),
      Text(
        label,
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),
    ],
  );
}

class _RunRow extends StatelessWidget {
  const _RunRow(this.run);

  final TournamentRun run;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final medalColor = switch (run.medal) {
      1 => _gold,
      2 => _silver,
      3 => _bronze,
      _ => null,
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Icon(
              run.medal > 0
                  ? Icons.emoji_events
                  : run.qualified
                  ? Icons.sports_soccer
                  : Icons.block,
              color:
                  medalColor ??
                  (run.qualified
                      ? AppColors.onSurfaceVariant
                      : AppColors.outlineVariant),
              size: 20,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${run.competition} ${run.year}',
                    style: AppTypography.bodyMedium,
                  ),
                  if (run.championName != null)
                    Text(
                      l.careerWinnersName(run.championName!),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.outline,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              run.placement,
              style: AppTypography.labelMedium.copyWith(
                color: medalColor ?? AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
