import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/federation_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

typedef _StatEntry = ({int playerId, int value});

typedef _StatsView = ({
  Nation? nation,
  List<_StatEntry> scorers,
  List<_StatEntry> appearances,
  Map<int, String> names,
});

final AutoDisposeFutureProviderFamily<_StatsView?, int> _teamStatsProvider =
    FutureProvider.autoDispose.family<_StatsView?, int>((ref, careerId) async {
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) return null;
  final comp = ref.watch(competitionRepositoryProvider);
  final nationId = career.nationId;

  final scorers = [
    for (final s in await comp.nationTopScorers(careerId, nationId, limit: 25))
      (playerId: s.playerId, value: s.goals),
  ];
  final appearances = [
    for (final a
        in await comp.nationTopAppearances(careerId, nationId, limit: 25))
      (playerId: a.playerId, value: a.games),
  ];

  final playerRepo = ref.watch(playerRepositoryProvider);
  final aging = CareerService.agingYears(career);
  final youth = await ref.watch(youthBonusByCycleProvider(careerId).future);
  final careerDev = await ref.watch(careerDevBonusProvider(careerId).future);
  final ids = {
    for (final s in [...scorers, ...appearances]) s.playerId,
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
  int _tab = 0; // 0 top scorers, 1 most games

  @override
  Widget build(BuildContext context) {
    final viewAsync = ref.watch(_teamStatsProvider(widget.careerId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () =>
              context.go('${Routes.hub}?careerId=${widget.careerId}'),
        ),
        title: Text(
          'TEAM RECORDS',
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Record book',
            icon: const Icon(Icons.auto_stories, color: AppColors.primary),
            onPressed: () =>
                context.go('${Routes.records}?careerId=${widget.careerId}'),
          ),
        ],
      ),
      body: viewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load stats.\n$e')),
        data: (view) {
          if (view == null) return const Center(child: Text('No data.'));
          final list = _tab == 0 ? view.scorers : view.appearances;
          final heading = _tab == 0 ? 'TOP SCORERS' : 'MOST GAMES PLAYED';

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.marginMobile),
                child: Row(
                  children: [
                    if (view.nation != null) ...[
                      FlagDisc(view.nation!.code, size: 22),
                      const SizedBox(width: AppSpacing.sm),
                    ],
                    Text(
                      view.nation?.name ?? 'Team',
                      style: AppTypography.headlineMedium,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.marginMobile,
                ),
                child: SegmentedButton<int>(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(value: 0, label: Text('Top scorers')),
                    ButtonSegment(value: 1, label: Text('Most games')),
                  ],
                  selected: {_tab},
                  onSelectionChanged: (s) => setState(() => _tab = s.first),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.marginMobile,
                ),
                child: Row(
                  children: [
                    Text(
                      heading,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: list.isEmpty
                    ? const Center(child: Text('No goals recorded yet.'))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.marginMobile,
                        ),
                        itemCount: list.length,
                        itemBuilder: (context, i) {
                          final s = list[i];
                          return _ScorerRow(
                            rank: i + 1,
                            name: view.names[s.playerId] ?? 'Unknown',
                            flagCode: view.nation?.code,
                            value: s.value,
                            onInfo: () => context.push(
                              '${Routes.player}?careerId=${widget.careerId}'
                              '&playerId=${s.playerId}',
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ScorerRow extends StatelessWidget {
  const _ScorerRow({
    required this.rank,
    required this.name,
    required this.flagCode,
    required this.value,
    required this.onInfo,
  });

  final int rank;
  final String name;
  final String? flagCode;
  final int value;
  final VoidCallback onInfo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              child: Text(
                '$rank',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
            if (flagCode != null) ...[
              FlagDisc(flagCode!, size: 22),
              const SizedBox(width: AppSpacing.sm),
            ],
            Expanded(
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodyMedium,
              ),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: const Icon(
                Icons.info_outline,
                size: 20,
                color: AppColors.onSurfaceVariant,
              ),
              onPressed: onInfo,
            ),
            Text(
              '$value',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
