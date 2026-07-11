import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

typedef _RolloverView = ({
  Honour? worldCup,
  Map<int, Nation> nations,
  int nextYear,
});

final AutoDisposeFutureProviderFamily<_RolloverView?, int> _rolloverProvider =
    FutureProvider.autoDispose.family<_RolloverView?, int>((
  ref,
  careerId,
) async {
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) return null;
  final honours =
      await ref.watch(competitionRepositoryProvider).honours(careerId);
  final wc = honours
      .where((h) => h.competition == 'World Championship')
      .toList()
    ..sort((a, b) => b.year.compareTo(a.year));
  final nations = {
    for (final n in await ref.watch(nationRepositoryProvider).all()) n.id: n,
  };
  return (
    worldCup: wc.isEmpty ? null : wc.first,
    nations: nations,
    nextYear: SeasonService.finalsYear(career.cyclePointer + 1),
  );
});

/// The end-of-cycle event: crowns the World Cup winner and rolls the save into
/// the next four-year cycle when the manager continues.
class CycleRolloverScreen extends ConsumerWidget {
  const CycleRolloverScreen({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewAsync = ref.watch(_rolloverProvider(careerId));

    Future<void> begin() async {
      await ref.read(seasonServiceProvider).startNextCycle(careerId);
      if (context.mounted) {
        context.go('${Routes.hub}?careerId=$careerId');
      }
    }

    return Scaffold(
      body: viewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load.\n$e')),
        data: (view) {
          final wc = view?.worldCup;
          String name(int id) => view?.nations[id]?.name ?? '—';
          String code(int id) => view?.nations[id]?.code ?? '??';

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.marginMobile),
              child: Column(
                children: [
                  const Spacer(),
                  const Icon(
                    Icons.emoji_events,
                    color: AppColors.primary,
                    size: 64,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (wc != null) ...[
                    Text(
                      '${wc.year} WORLD CHAMPIONS',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FlagDisc(
                          code(wc.championId),
                          size: 40,
                          highlighted: true,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Flexible(
                          child: Text(
                            name(wc.championId),
                            style: AppTypography.headlineLargeMobile,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _SummaryCard(wc: wc, name: name),
                  ] else
                    const Text(
                      'The cycle is complete.',
                      style: AppTypography.headlineMedium,
                    ),
                  const Spacer(),
                  Text(
                    'THE ROAD TO ${view?.nextYear ?? ''}',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'A new four-year cycle begins — continental qualifying '
                    'is drawn first.',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  PrimaryButton(
                    label: 'Begin ${view?.nextYear ?? ''} cycle',
                    icon: Icons.skip_next_rounded,
                    onPressed: () => unawaited(begin()),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.wc, required this.name});

  final Honour wc;
  final String Function(int) name;

  @override
  Widget build(BuildContext context) {
    final score = (wc.finalHomeScore != null && wc.finalAwayScore != null)
        ? (wc.finalHomeScore == wc.finalAwayScore
            ? '${wc.finalHomeScore}–${wc.finalAwayScore} (pens)'
            : '${wc.finalHomeScore}–${wc.finalAwayScore}')
        : null;
    return AppCard(
      child: Column(
        children: [
          _row('Final', '${name(wc.championId)} $score ${name(wc.runnerUpId)}'),
          if (wc.hostId != null)
            _row('Host', name(wc.hostId!)),
          if (wc.topScorerName != null)
            _row(
              'Golden Boot',
              '${wc.topScorerName} · ${wc.topScorerGoals} goals',
            ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 92,
            child: Text(
              label.toUpperCase(),
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySmall,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
