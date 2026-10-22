import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/repositories/career_repository.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/naturalization_providers.dart';

/// Every player [careerId] has naturalised: the men who no longer play for the
/// nation they were born to, wherever they went.
///
/// A naturalisation is a switch of allegiance, and it is for good. The seeded
/// pool knows nothing of it (it is a function of seed and year), so every read
/// of a nation's pool within a career takes these out of their old nation, or
/// Italy's best player turned out for San Marino in the manager's matches and
/// for Italy in everybody else's.
Future<Set<int>> naturalizedAwayIds(
  CareerRepository repo,
  int careerId,
) async => {
  for (final link in await repo.acceptedNaturalizations(careerId))
    link.playerId,
};

/// [pool] without the players [careerId] has naturalised away (see
/// [naturalizedAwayIds]): the manager's own nation's seeded pool, for the call
/// sites that build it with their own development inputs and add
/// [naturalizedPlayersFor] themselves.
///
/// Hands back [pool] itself when nobody has been naturalised, so a career
/// without a naturalisation reads exactly the list it always did.
Future<List<Player>> withoutNaturalizedAway(
  Ref ref,
  int careerId,
  List<Player> pool,
) async {
  final away = await naturalizedAwayIds(
    ref.read(careerRepositoryProvider),
    careerId,
  );
  return dropNaturalizedAway(pool, away);
}

/// [pool] minus the ids in [away], or [pool] itself when there is nothing to
/// take out — the one filter [withoutNaturalizedAway], [careerPoolOf] and the
/// world simulation share.
List<Player> dropNaturalizedAway(List<Player> pool, Set<int> away) {
  if (away.isEmpty || !pool.any((p) => away.contains(p.id))) return pool;
  return [
    for (final p in pool)
      if (!away.contains(p.id)) p,
  ];
}

/// [pool] with the players naturalised into its nation ([incoming]) slotted in
/// by rating, best first, as the seeded pool is ordered.
///
/// The merge is stable: the seeded players keep their relative order, ties
/// included, and a naturalised player goes after any seeded man of the same
/// rating. A plain re-sort could shuffle equal ratings and change who a
/// "best eleven" picks. [pool] itself comes back when [incoming] is empty.
List<Player> withNaturalizedIn(List<Player> pool, List<Player> incoming) {
  if (incoming.isEmpty) return pool;
  final all = [...pool, ...incoming];
  final order = List<int>.generate(all.length, (i) => i)
    ..sort((a, b) {
      final byOverall = all[b].overall.compareTo(all[a].overall);
      return byOverall != 0 ? byOverall : a.compareTo(b);
    });
  return [for (final i in order) all[i]];
}

/// [nationId]'s pool within [career]: the seeded pool aged to [agingYears]
/// (the career's own by default), minus every player naturalised away from it,
/// plus every player naturalised into it, best first.
///
/// The read for ANY nation's players as the rest of the world sees them: the
/// opponent in a match preview, a team page, a tournament's team of the
/// tournament. The manager's own squad screens keep their own reads (they pass
/// the youth and club-development inputs), filtered through
/// [withoutNaturalizedAway].
///
/// A career with no accepted naturalisation gets the seeded list back as it
/// is, element for element.
Future<List<Player>> careerPoolOf(
  Ref ref,
  Career career,
  int nationId, {
  int? agingYears,
}) async {
  final years = agingYears ?? CareerService.agingYears(career);
  final seeded = await ref
      .read(playerRepositoryProvider)
      .byNation(
        nationId,
        agingYears: years,
        saveSeed: career.rngSeed,
        careerId: career.id,
      );
  final repo = ref.read(careerRepositoryProvider);
  final away = await naturalizedAwayIds(repo, career.id);
  if (away.isEmpty) return seeded;
  final incoming = await resolveNaturalized(
    ref,
    career,
    await naturalizationsInto(repo, career, nationId),
    nationId,
    agingYears: years,
  );
  return withNaturalizedIn(dropNaturalizedAway(seeded, away), incoming);
}
