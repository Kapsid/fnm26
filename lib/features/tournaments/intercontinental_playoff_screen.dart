import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// The intercontinental play-off, replayed deterministically for display: the
/// ties that decided the last two World Cup places.
typedef PlayoffView = ({
  List<PlayoffTie> ties,
  Map<int, Nation> nations,
  int playerNationId,
});

final AutoDisposeFutureProviderFamily<PlayoffView?, int>
    intercontinentalPlayoffProvider =
    FutureProvider.autoDispose.family<PlayoffView?, int>((ref, careerId) async {
  await ref.watch(seedLoaderProvider).ensureSeeded();
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) return null;
  final comp = ref.watch(competitionRepositoryProvider);
  if (!await comp.allQualifyingPlayed(careerId)) return null;

  final byConfederation = await comp.allGroupTablesByConfederation(careerId);
  final grouped = <Confederation, List<List<GroupStanding>>>{};
  for (final t in byConfederation) {
    (grouped[t.confederation] ??= []).add(t.standings);
  }
  final nations = {
    for (final n in await ref.watch(nationRepositoryProvider).all()) n.id: n,
  };
  final rankingById = await ref.watch(
    seedRankByIdProvider((
      careerId: careerId,
      cycle: drawSeedCycle(career.cyclePointer, drawSlotWorldCupFinals),
    )).future,
  );
  // Same seed the finalist selection uses, so the shown ties are exactly how
  // the last two places were decided.
  final ties = WorldCupFinals.playoffBracket(
    byConfederation: grouped,
    rankingById: rankingById,
    rng: SeededRng(career.rngSeed ^ (career.cyclePointer * 0x50FF) ^ 0xB1A0),
  );
  if (ties.isEmpty) return null;
  return (ties: ties, nations: nations, playerNationId: career.nationId);
});

/// A one-shot event surfaced before the World Cup finals draw: the
/// intercontinental play-off that decided the final two berths, shown as its own
/// step (passively simulated) rather than buried on the draw screen.
class IntercontinentalPlayoffScreen extends ConsumerWidget {
  const IntercontinentalPlayoffScreen({required this.careerId, super.key});

  final int careerId;

  Future<void> _continue(BuildContext context, WidgetRef ref) async {
    final career = await ref.read(careerRepositoryProvider).byId(careerId);
    if (career != null) {
      await ref.read(competitionRepositoryProvider).markDrawWatched(
            careerId,
            career.cyclePointer,
            worldCupPlayoffKind,
          );
    }
    if (context.mounted) context.go('${Routes.hub}?careerId=$careerId');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(intercontinentalPlayoffProvider(careerId));
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'INTERCONTINENTAL PLAY-OFF',
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load.\n$e')),
        data: (data) {
          if (data == null) {
            return const Center(child: Text('No play-off this cycle.'));
          }
          String code(int id) => data.nations[id]?.code ?? '??';
          String name(int id) => data.nations[id]?.name ?? '—';
          final winners = {
            for (final t in data.ties)
              if (t.isFinal) t.winner,
          };
          final playerThrough = winners.contains(data.playerNationId);
          final playerInvolved = data.ties.any(
            (t) => t.home == data.playerNationId || t.away == data.playerNationId,
          );
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.marginMobile),
                  children: [
                    Text(
                      'Two World Cup places decided across a knockout of the '
                      'best qualifying also-rans.',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    if (playerInvolved) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: (playerThrough
                                  ? AppColors.positive
                                  : AppColors.error)
                              .withValues(alpha: 0.12),
                          borderRadius: AppRadii.baseAll,
                          border: Border.all(
                            color: playerThrough
                                ? AppColors.positive
                                : AppColors.error,
                          ),
                        ),
                        child: Text(
                          playerThrough
                              ? 'You came through the play-off — you\'re at the '
                                  'World Cup!'
                              : 'You fell short in the play-off — no World Cup '
                                  'this time.',
                          style: AppTypography.bodyMedium.copyWith(
                            color: playerThrough
                                ? AppColors.positive
                                : AppColors.error,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.md),
                    for (final t in data.ties)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 58,
                              child: Text(
                                t.isFinal ? 'FINAL' : 'SEMI',
                                style: AppTypography.labelSmall.copyWith(
                                  color: t.isFinal
                                      ? AppColors.primary
                                      : AppColors.onSurfaceVariant,
                                  fontWeight: t.isFinal
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                ),
                              ),
                            ),
                            Expanded(
                              child: _side(code, name, t.home, t,
                                  data.playerNationId),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                '${t.homeScore}-${t.awayScore}',
                                style: AppTypography.labelMedium.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Expanded(
                              child: _side(code, name, t.away, t,
                                  data.playerNationId),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.marginMobile),
                  child: PrimaryButton(
                    label: 'Continue',
                    icon: Icons.check_rounded,
                    onPressed: () => _continue(context, ref),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _side(
    String Function(int) code,
    String Function(int) name,
    int id,
    PlayoffTie t,
    int playerNationId,
  ) {
    final won = t.winner == id;
    final isPlayer = id == playerNationId;
    return Row(
      children: [
        FlagDisc(code(id), size: 18, highlighted: isPlayer),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            name(id),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelSmall.copyWith(
              color: won ? AppColors.primary : AppColors.onSurfaceVariant,
              fontWeight: won ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
