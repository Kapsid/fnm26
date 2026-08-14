import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/federation/federation_finance.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';

/// The talent shift applied to the manager's nation's newgen intakes, keyed by
/// the cycle each intake was born in. Two things feed it, and both are derived
/// from stored history so it re-produces identically on replay/restore:
///
///  * the youth-academy investment committed for that cycle, and
///  * how the senior side moved in the world ranking over the cycle before —
///    a nation on the way up starts producing better kids, one sliding down
///    produces worse (see [PlayerLifecycle.rankTrendTalentBonus]).
///
/// Passed only for the player's own nation's pool.
final AutoDisposeFutureProviderFamily<Map<int, double>, int>
youthBonusByCycleProvider = FutureProvider.autoDispose.family<Map<int, double>, int>((
  ref,
  careerId,
) async {
  final invests = await ref
      .watch(careerRepositoryProvider)
      .investments(careerId);
  final bonuses = <int, double>{
    for (final e in invests.entries)
      if (e.value.youth > 0)
        e.key: FederationFinance.youthTalentBonus(e.value.youth),
  };

  // Where the nation finished each cycle in the world ranking. Releases arrive
  // oldest-first, so the last one written for a cycle is that cycle's standing.
  final releases = await ref
      .watch(rankingReleaseRepositoryProvider)
      .all(careerId);
  final rankByCycle = <int, int>{};
  final nationByCycle = <int, int>{};
  for (final r in releases) {
    rankByCycle[r.cycle] = r.playerRank;
    nationByCycle[r.cycle] = r.nationId;
  }
  for (final cycle in rankByCycle.keys) {
    final before = rankByCycle[cycle - 1];
    // Never measure a "climb" across a change of nation — taking over a better
    // side is not the same as having improved the one you had.
    if (before == null || nationByCycle[cycle - 1] != nationByCycle[cycle]) {
      continue;
    }
    // A lower rank number is better, so a drop in the number is a climb. The
    // intake that arrives at the NEXT cycle boundary is the one that inherits it.
    final trend = PlayerLifecycle.rankTrendTalentBonus(
      before - rankByCycle[cycle]!,
    );
    if (trend != 0) {
      bonuses[cycle + 1] = (bonuses[cycle + 1] ?? 0) + trend;
    }
  }
  return bonuses;
});

/// Total tournament STARTS per player across the save (playerId → starts) — the
/// career-development signal. A player who has started many matches grows a
/// touch (weighted by their club-league tier). Derived from stored appearance
/// rows, so it re-produces identically on replay.
final AutoDisposeFutureProviderFamily<Map<int, int>, int>
careerDevBonusProvider = FutureProvider.autoDispose.family<Map<int, int>, int>(
  (ref, careerId) =>
      ref.watch(competitionRepositoryProvider).careerStartsByPlayer(careerId),
);
