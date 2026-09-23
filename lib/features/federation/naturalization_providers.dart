import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/federation_providers.dart';

/// The pending naturalisation offer resolved for the decision screen: the
/// candidate player (with their real name/attributes) and the nations either
/// side of the switch.
typedef NaturalizationOffer = ({
  Player player,
  Nation sourceNation,
  Nation playerNation,
});

final AutoDisposeFutureProviderFamily<NaturalizationOffer?, int>
pendingNaturalizationProvider = FutureProvider.autoDispose
    .family<NaturalizationOffer?, int>((
      ref,
      careerId,
    ) async {
      final career = await ref.watch(careerRepositoryProvider).byId(careerId);
      if (career == null) return null;
      final link = await ref
          .watch(careerRepositoryProvider)
          .pendingNaturalization(careerId);
      if (link == null) return null;
      // The SAME four development inputs the squad pool is built from — see
      // [naturalizedPlayersFor]. Reconstructing him from a subset showed the
      // manager a base rating on the offer screen and the developed one the
      // moment he signed: one footballer reading two ratings, and the decision
      // taken on the wrong one.
      final player = await ref
          .watch(playerRepositoryProvider)
          .byId(
            link.playerId,
            agingYears: CareerService.agingYears(career),
            saveSeed: career.rngSeed,
            youthBonusByCycle: await ref.watch(
              youthBonusByCycleProvider(careerId).future,
            ),
            careerStartsByPlayer: await ref.watch(
              careerDevBonusProvider(careerId).future,
            ),
          );
      if (player == null) return null;
      final nations = {
        for (final n in await ref.watch(nationRepositoryProvider).all())
          n.id: n,
      };
      final source = nations[link.sourceNationId];
      final home = nations[career.nationId];
      if (source == null || home == null) return null;
      return (player: player, sourceNation: source, playerNation: home);
    });

/// The naturalised players available to [career]'s nation: each accepted
/// foreign player resolved live from their original id (so their name and
/// attributes stay their own), then re-homed to the manager's nation so they
/// slot into the squad, call-ups and match pool alongside home-grown players.
///
/// Resolved with the save's development inputs — the youth-intake bonuses and
/// the per-player start counts — exactly as the nation's own pool is. Without
/// them a naturalised player was frozen at his base rating for the rest of the
/// save: he could play fifty tournament matches and never gain a point, while
/// every home-grown team-mate around him grew.
Future<List<Player>> naturalizedPlayersFor(Ref ref, Career career) async {
  final links = await ref
      .read(careerRepositoryProvider)
      .acceptedNaturalizations(
        career.id,
      );
  if (links.isEmpty) return const [];
  final repo = ref.read(playerRepositoryProvider);
  final agingYears = CareerService.agingYears(career);
  final youthBonus = await ref.read(
    youthBonusByCycleProvider(career.id).future,
  );
  final careerDev = await ref.read(careerDevBonusProvider(career.id).future);
  final out = <Player>[];
  for (final link in links) {
    final p = await repo.byId(
      link.playerId,
      agingYears: agingYears,
      saveSeed: career.rngSeed,
      youthBonusByCycle: youthBonus,
      careerStartsByPlayer: careerDev,
    );
    // Only field a naturalised player who is still active (not retired out of
    // the pool); re-home them to the manager's nation for selection. The test
    // is his own retirement age, exactly as the pool's is — a flat cut-off
    // both dropped men still playing and kept men who had finished.
    if (p != null && !PlayerLifecycle.hasRetiredAt(p.id, p.age, agingYears)) {
      out.add(p.copyWith(nationId: career.nationId));
    }
  }
  return out;
}

/// The count of accepted naturalised players in the manager's squad — a small
/// badge for the finances screen.
final AutoDisposeFutureProviderFamily<int, int> naturalizedCountProvider =
    FutureProvider.autoDispose.family<int, int>((ref, careerId) async {
      final links = await ref
          .watch(careerRepositoryProvider)
          .acceptedNaturalizations(
            careerId,
          );
      return links.length;
    });
