import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/repositories/career_repository.dart';
import 'package:fnm/domain/services/manager/stints.dart';
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

/// The naturalisation offer awaiting the manager's answer, if it was made to
/// the nation he manages now.
///
/// An offer made to a previous federation lapses with the job (see
/// `_resetSquadForNewNation`). A save that moved before that rule still holds
/// one as pending: it is lapsed here, once, the first time it is read, rather
/// than offered to a nation it was never made to.
Future<NaturalizationLink?> currentNaturalizationOffer(
  CareerRepository repo,
  Career career,
) async {
  final stints = await repo.stints(career.id);
  for (var i = 0; i < 8; i++) {
    final link = await repo.pendingNaturalization(career.id);
    if (link == null) return null;
    if (Stints.nationAt(stints, link.cycle, career.nationId) ==
        career.nationId) {
      return link;
    }
    await repo.setNaturalizationStatus(career.id, link.playerId, 'declined');
  }
  return null;
}

final AutoDisposeFutureProviderFamily<NaturalizationOffer?, int>
pendingNaturalizationProvider = FutureProvider.autoDispose
    .family<NaturalizationOffer?, int>((
      ref,
      careerId,
    ) async {
      final career = await ref.watch(careerRepositoryProvider).byId(careerId);
      if (career == null) return null;
      final link = await currentNaturalizationOffer(
        ref.watch(careerRepositoryProvider),
        career,
      );
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
            careerId: career.id,
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

/// The naturalisations [career]'s current nation has: the accepted ones made
/// while the manager was in charge of THAT nation.
///
/// A naturalisation is stored per career, and a career is the manager, so
/// left unfiltered every player he ever naturalised followed him from job to
/// job. The player switched allegiance to the federation that made the offer:
/// he stays with it, and is back in the squad if the manager ever returns.
Future<List<NaturalizationLink>> naturalizationsHeldBy(
  CareerRepository repo,
  Career career,
) => naturalizationsInto(repo, career, career.nationId);

/// The accepted naturalisations that went to [nationId]: those made while the
/// manager was in charge of it, whichever nation he manages now.
///
/// The read behind [naturalizationsHeldBy], opened up to every nation, since a
/// player naturalised for a federation the manager has since left still plays
/// for it in the rest of the world.
Future<List<NaturalizationLink>> naturalizationsInto(
  CareerRepository repo,
  Career career,
  int nationId,
) async {
  final links = await repo.acceptedNaturalizations(career.id);
  if (links.isEmpty) return links;
  final stints = await repo.stints(career.id);
  return [
    for (final link in links)
      if (Stints.nationAt(stints, link.cycle, career.nationId) == nationId)
        link,
  ];
}

/// The naturalised players available to [career]'s nation: each accepted
/// foreign player resolved live from their original id (so their name and
/// attributes stay their own), then re-homed to the manager's nation so they
/// slot into the squad, call-ups and match pool alongside home-grown players.
Future<List<Player>> naturalizedPlayersFor(Ref ref, Career career) =>
    naturalizedPlayersInto(ref, career, career.nationId);

/// The naturalised players who play for [nationId] in [career]: the accepted
/// links that went to it (see [naturalizationsInto]), resolved and re-homed
/// by [resolveNaturalized].
Future<List<Player>> naturalizedPlayersInto(
  Ref ref,
  Career career,
  int nationId,
) async {
  final links = await naturalizationsInto(
    ref.read(careerRepositoryProvider),
    career,
    nationId,
  );
  return resolveNaturalized(ref, career, links, nationId);
}

/// Resolves [links] into the players who now play for [nationId].
///
/// Resolved with the save's development inputs — the youth-intake bonuses and
/// the per-player start counts — exactly as the nation's own pool is. Without
/// them a naturalised player was frozen at his base rating for the rest of the
/// save: he could play fifty tournament matches and never gain a point, while
/// every home-grown team-mate around him grew.
///
/// Split from [naturalizedPlayersInto] so the world simulation, which reads
/// every nation's pool in one operation, can load the links once and resolve
/// them nation by nation. [agingYears] defaults to the career's own.
Future<List<Player>> resolveNaturalized(
  Ref ref,
  Career career,
  Iterable<NaturalizationLink> links,
  int nationId, {
  int? agingYears,
}) async {
  if (links.isEmpty) return const [];
  final repo = ref.read(playerRepositoryProvider);
  final years = agingYears ?? CareerService.agingYears(career);
  final youthBonus = await ref.read(
    youthBonusByCycleProvider(career.id).future,
  );
  final careerDev = await ref.read(careerDevBonusProvider(career.id).future);
  final out = <Player>[];
  for (final link in links) {
    final p = await repo.byId(
      link.playerId,
      agingYears: years,
      saveSeed: career.rngSeed,
      careerId: career.id,
      youthBonusByCycle: youthBonus,
      careerStartsByPlayer: careerDev,
    );
    // Only field a naturalised player who is still active (not retired out of
    // the pool); re-home them to the nation he switched to for selection. The
    // test is his own retirement age, exactly as the pool's is — a flat cut-off
    // both dropped men still playing and kept men who had finished.
    if (p != null && !PlayerLifecycle.hasRetiredAt(p.id, p.age, years)) {
      out.add(p.copyWith(nationId: nationId));
    }
  }
  return out;
}

/// The count of accepted naturalised players in the manager's squad — a small
/// badge for the finances screen.
final AutoDisposeFutureProviderFamily<int, int> naturalizedCountProvider =
    FutureProvider.autoDispose.family<int, int>((ref, careerId) async {
      final repo = ref.watch(careerRepositoryProvider);
      final career = await repo.byId(careerId);
      if (career == null) return 0;
      return (await naturalizationsHeldBy(repo, career)).length;
    });
