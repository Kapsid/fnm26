import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

typedef _StatsView = ({
  Nation? nation,
  List<ScorerTally> allTime,
  List<ScorerTally> qualifying,
  List<ScorerTally> finals,
  Map<int, String> names,
});

final AutoDisposeFutureProviderFamily<_StatsView?, int> _teamStatsProvider =
    FutureProvider.autoDispose.family<_StatsView?, int>((ref, careerId) async {
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) return null;
  final comp = ref.watch(competitionRepositoryProvider);
  final nationId = career.nationId;

  final allTime = await comp.nationTopScorers(careerId, nationId, limit: 25);
  final qualifying = await comp.nationTopScorers(
    careerId,
    nationId,
    kind: CompetitionKind.worldCupQualifying,
    limit: 15,
  );
  final finals = await comp.nationTopScorers(
    careerId,
    nationId,
    kind: CompetitionKind.worldCupFinals,
    limit: 15,
  );

  final playerRepo = ref.watch(playerRepositoryProvider);
  final ids = {
    for (final s in [...allTime, ...qualifying, ...finals]) s.playerId,
  };
  final names = <int, String>{};
  for (final id in ids) {
    names[id] = (await playerRepo.byId(id))?.name ?? 'Unknown';
  }

  final nations = await ref.watch(nationRepositoryProvider).all();
  return (
    nation: nations.where((n) => n.id == nationId).firstOrNull,
    allTime: allTime,
    qualifying: qualifying,
    finals: finals,
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
  int _tab = 0; // 0 all-time, 1 qualifying, 2 finals

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
      ),
      body: viewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load stats.\n$e')),
        data: (view) {
          if (view == null) return const Center(child: Text('No data.'));
          final lists = [view.allTime, view.qualifying, view.finals];
          final list = lists[_tab];

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
                    ButtonSegment(value: 0, label: Text('All-time')),
                    ButtonSegment(value: 1, label: Text('Qualifying')),
                    ButtonSegment(value: 2, label: Text('Finals')),
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
                      'TOP SCORERS',
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
                            goals: s.goals,
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
    required this.goals,
    required this.onInfo,
  });

  final int rank;
  final String name;
  final int goals;
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
              '$goals',
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
