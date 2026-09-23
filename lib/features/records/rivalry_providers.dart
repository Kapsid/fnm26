import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/stats/nation_results.dart';

/// The manager's fiercest rival — the nation they have met most often — and
/// the head-to-head record against them.
///
/// Every meeting counts, friendlies included, so this card and the
/// head-to-head screen tell the same story about the same pairing.
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

      // Everything played, friendlies included — the rule lives in
      // [nationResults]. This card used to drop friendlies while the
      // head-to-head screen kept them, so the same pairing read P4 here and P5
      // there.
      final ledger = opponentLedger(
        nationResults(
          await comp.fixturesForNation(careerId, nationId),
          nationId,
        ),
      );
      if (ledger.isEmpty) return null;

      // The most-met opponent — who you have been up against most often.
      final topOpp = ledger.values.reduce(
        (a, b) => b.played > a.played ? b : a,
      );
      if (topOpp.played < 3) return null;
      final opp = topOpp.opponentId;

      final nations = {
        for (final n in await ref.watch(nationRepositoryProvider).all())
          n.id: n,
      };
      final rival = nations[opp];
      if (rival == null) return null;

      return (
        rival: rival,
        played: topOpp.played,
        wins: topOpp.wins,
        draws: topOpp.draws,
        losses: topOpp.losses,
        goalsFor: topOpp.goalsFor,
        goalsAgainst: topOpp.goalsAgainst,
      );
    });
