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
import 'package:fnm/features/tournaments/intercontinental_playoff_bracket.dart';
import 'package:fnm/l10n/app_localizations.dart';
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
intercontinentalPlayoffProvider = FutureProvider.autoDispose
    .family<PlayoffView?, int>((ref, careerId) async {
      await ref.watch(seedLoaderProvider).ensureSeeded();
      final career = await ref.watch(careerRepositoryProvider).byId(careerId);
      if (career == null) return null;
      final comp = ref.watch(competitionRepositoryProvider);
      if (!await comp.allQualifyingPlayed(careerId)) return null;

      final byConfederation = await comp.allGroupTablesByConfederation(
        careerId,
      );
      final grouped = <Confederation, List<List<GroupStanding>>>{};
      for (final t in byConfederation) {
        (grouped[t.confederation] ??= []).add(t.standings);
      }
      final nations = {
        for (final n in await ref.watch(nationRepositoryProvider).all())
          n.id: n,
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
        rng: SeededRng(
          career.rngSeed ^ (career.cyclePointer * 0x50FF) ^ 0xB1A0,
        ),
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
      await ref
          .read(competitionRepositoryProvider)
          .markDrawWatched(
            careerId,
            career.cyclePointer,
            worldCupPlayoffKind,
          );
    }
    if (context.mounted) context.go('${Routes.hub}?careerId=$careerId');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(intercontinentalPlayoffProvider(careerId));
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          l.tourContIntercontinentalPlayoff,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.tourContCouldNotLoad(e.toString()))),
        data: (data) {
          if (data == null) {
            return Center(child: Text(l.tourContNoPlayoffThisCycle));
          }
          String code(int id) => data.nations[id]?.code ?? '??';
          String name(int id) => data.nations[id]?.name ?? '—';
          final winners = {
            for (final t in data.ties)
              if (t.isFinal) t.winner,
          };
          final playerThrough = winners.contains(data.playerNationId);
          final playerInvolved = data.ties.any(
            (t) =>
                t.home == data.playerNationId || t.away == data.playerNationId,
          );
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.marginMobile),
                  children: [
                    Text(
                      l.tourContPlayoffIntro,
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
                          color:
                              (playerThrough
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
                              ? l.tourContPlayoffThrough
                              : l.tourContPlayoffOut,
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
                    IntercontinentalPlayoffBracket(
                      ties: data.ties,
                      code: code,
                      name: name,
                      playerNationId: data.playerNationId,
                    ),
                  ],
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.marginMobile),
                  child: PrimaryButton(
                    label: l.tourContContinue,
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
}
