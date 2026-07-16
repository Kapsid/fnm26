import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/nation.dart';

/// The manager's fiercest rival — the nation they've met most often in
/// competitive football — and the head-to-head record against them.
typedef Rivalry = ({
  Nation rival,
  int played,
  int wins,
  int draws,
  int losses,
  int goalsFor,
  int goalsAgainst,
});

/// Derives the nation's top rival from every competitive result (friendlies
/// excluded). Null until they've met the same opponent at least three times.
final AutoDisposeFutureProviderFamily<Rivalry?, int> rivalryProvider =
    FutureProvider.autoDispose.family<Rivalry?, int>((ref, careerId) async {
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) return null;
  final comp = ref.watch(competitionRepositoryProvider);
  final nationId = career.nationId;

  final fixtures = (await comp.fixturesForNation(careerId, nationId))
      .where((f) => f.hasResult && f.round != 'FRIENDLY')
      .toList();

  // Tally meetings and the head-to-head record per opponent.
  final meetings = <int, int>{};
  final wins = <int, int>{};
  final draws = <int, int>{};
  final losses = <int, int>{};
  final gf = <int, int>{};
  final ga = <int, int>{};
  for (final f in fixtures) {
    final home = f.homeNationId == nationId;
    final opp = home ? f.awayNationId : f.homeNationId;
    final my = home ? f.homeScore! : f.awayScore!;
    final other = home ? f.awayScore! : f.homeScore!;
    meetings.update(opp, (v) => v + 1, ifAbsent: () => 1);
    gf.update(opp, (v) => v + my, ifAbsent: () => my);
    ga.update(opp, (v) => v + other, ifAbsent: () => other);
    if (my > other) {
      wins.update(opp, (v) => v + 1, ifAbsent: () => 1);
    } else if (my == other) {
      draws.update(opp, (v) => v + 1, ifAbsent: () => 1);
    } else {
      losses.update(opp, (v) => v + 1, ifAbsent: () => 1);
    }
  }
  if (meetings.isEmpty) return null;

  // The most-met opponent (ties broken by the tighter aggregate).
  final topOpp = meetings.entries.reduce((a, b) => b.value > a.value ? b : a);
  if (topOpp.value < 3) return null;
  final opp = topOpp.key;

  final nations = {
    for (final n in await ref.watch(nationRepositoryProvider).all()) n.id: n,
  };
  final rival = nations[opp];
  if (rival == null) return null;

  return (
    rival: rival,
    played: meetings[opp] ?? 0,
    wins: wins[opp] ?? 0,
    draws: draws[opp] ?? 0,
    losses: losses[opp] ?? 0,
    goalsFor: gf[opp] ?? 0,
    goalsAgainst: ga[opp] ?? 0,
  );
});
