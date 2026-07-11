import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/features/career/career_summary_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

const _gold = Color(0xFFEFC94C);
const _silver = Color(0xFFBFC7CE);
const _bronze = Color(0xFFCD8B62);

/// The manager's career at a glance: team, world standing, overall record, a
/// trophy cabinet, and a finish-by-finish tournament history.
class CareerSummaryScreen extends ConsumerWidget {
  const CareerSummaryScreen({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(careerSummaryProvider(careerId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.go('${Routes.hub}?careerId=$careerId'),
        ),
        title: Text(
          'CAREER',
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load career.\n$e')),
        data: (s) {
          if (s == null) return const Center(child: Text('No career.'));
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            children: [
              _Header(s),
              const SizedBox(height: AppSpacing.sm),
              _RecordCard(s),
              const SizedBox(height: AppSpacing.md),
              Text(
                'TROPHY CABINET',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              _TrophyCabinet(s),
              const SizedBox(height: AppSpacing.md),
              Text(
                'TOURNAMENT HISTORY',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              if (s.runs.isEmpty)
                const AppCard(child: Text('No tournaments completed yet.'))
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
                  s.nation?.name ?? 'Team',
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
                      TacticalChip('WORLD #$rank', emphasized: true),
                    if (s.worldPoints != null)
                      TacticalChip('${s.worldPoints} PTS'),
                    TacticalChip(
                      'SEASON ${s.seasons}',
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
    final gd = s.goalDifference;
    return AppCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _stat('P', '${s.played}'),
          _stat('W', '${s.won}', color: const Color(0xFF3FA34D)),
          _stat('D', '${s.drawn}'),
          _stat('L', '${s.lost}', color: const Color(0xFFD64545)),
          _stat('GF', '${s.goalsFor}'),
          _stat('GA', '${s.goalsAgainst}'),
          _stat('GD', '${gd >= 0 ? '+' : ''}$gd'),
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

class _TrophyCabinet extends StatelessWidget {
  const _TrophyCabinet(this.s);

  final CareerSummary s;

  @override
  Widget build(BuildContext context) {
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
                  'No silverware yet — go win one.',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _medal(_gold, s.golds, 'GOLD'),
                _medal(_silver, s.silvers, 'SILVER'),
                _medal(_bronze, s.bronzes, 'BRONZE'),
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
              color: medalColor ??
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
                      'Winners: ${run.championName}',
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
