import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';

/// Which nation's vitrine to show, within a given save.
typedef NationVitrineArg = ({int careerId, int nationId});

/// A tally of finishes in one class of competition (World Cup or continental).
class MedalHaul {
  const MedalHaul({
    required this.golds,
    required this.silvers,
    required this.bronzes,
    required this.appearances,
  });

  final int golds;
  final int silvers;
  final int bronzes;

  /// Distinct editions the nation reached the finals of.
  final int appearances;

  int get podiums => golds + silvers + bronzes;
}

/// One title the nation has won, for the honours list.
class TitleWon {
  const TitleWon({
    required this.year,
    required this.competition,
    required this.wasHost,
  });

  final int year;
  final String competition;
  final bool wasHost;
}

/// A nation's all-time top scorer entry.
class ScorerRecord {
  const ScorerRecord({required this.name, required this.goals});
  final String name;
  final int goals;
}

/// One point on the world-ranking history line: the world position the nation
/// held at the start of a cycle (or right now).
class RankPoint {
  const RankPoint({
    required this.year,
    required this.rank,
    required this.isNow,
  });

  final int year;
  final int rank;
  final bool isNow;
}

/// Everything the nation-vitrine screen shows: a country's roll of honour,
/// record-breakers, and how its world standing has moved over the save.
class NationVitrine {
  const NationVitrine({
    required this.nation,
    required this.currentRank,
    required this.currentPoints,
    required this.worldCup,
    required this.continental,
    required this.titles,
    required this.topScorers,
    required this.rankHistory,
    required this.isPlayerNation,
  });

  final Nation nation;
  final int? currentRank;
  final int? currentPoints;

  final MedalHaul worldCup;
  final MedalHaul continental;

  /// Every title won (both competitions), newest first.
  final List<TitleWon> titles;

  /// All-time leading scorers for the nation, best first.
  final List<ScorerRecord> topScorers;

  /// World-position history, oldest first, ending on "now".
  final List<RankPoint> rankHistory;

  final bool isPlayerNation;

  int get totalGolds => worldCup.golds + continental.golds;
}

const _roundOrder = ['GROUP', 'R32', 'R16', 'QF', 'SF', '3RD', 'FINAL'];

bool _isFinalsRound(String? round) {
  if (round == null) return false;
  final core = round.startsWith('C') ? round.substring(1) : round;
  return _roundOrder.contains(core);
}

final AutoDisposeFutureProviderFamily<NationVitrine?, NationVitrineArg>
nationVitrineProvider = FutureProvider.autoDispose
    .family<NationVitrine?, NationVitrineArg>((
      ref,
      arg,
    ) async {
      await ref.watch(seedLoaderProvider).ensureSeeded();
      final career = await ref
          .watch(careerRepositoryProvider)
          .byId(arg.careerId);
      if (career == null) return null;
      final nation = await ref
          .watch(nationRepositoryProvider)
          .byId(arg.nationId);
      if (nation == null) return null;

      final comp = ref.watch(competitionRepositoryProvider);
      // A nation's full roll of honour across all time (incl. the pre-seeded
      // real-world history) — the career summary is the career-only view.
      final honours = await comp.honours(arg.careerId);
      final fixtures = await comp.fixturesForNation(arg.careerId, arg.nationId);

      // Medals, split World Cup vs. continental, plus the titles list. A
      // nation's continental honours are only for its OWN confederation's cup —
      // a European side never shows a South America Cup, even if it once hosted
      // one in the seeded history.
      final ownCup =
          ContinentalCups.byConfederation[nation.confederation]?.name;
      var wcG = 0;
      var wcS = 0;
      var wcB = 0;
      var coG = 0;
      var coS = 0;
      var coB = 0;
      final titles = <TitleWon>[];
      // Global competitions any nation can win, shown alongside its own
      // confederation's continental cup.
      const globalCups = {'Nations Cup', 'Continental Clash'};
      for (final h in honours) {
        final isWc = h.competition == 'World Championship';
        if (!isWc &&
            h.competition != ownCup &&
            !globalCups.contains(h.competition)) {
          continue; // a foreign confederation's cup — skip
        }
        final gold = h.championId == arg.nationId;
        final silver = h.runnerUpId == arg.nationId;
        final bronze = h.thirdId == arg.nationId || h.thirdId2 == arg.nationId;
        if (isWc) {
          if (gold) wcG++;
          if (silver) wcS++;
          if (bronze) wcB++;
        } else {
          if (gold) coG++;
          if (silver) coS++;
          if (bronze) coB++;
        }
        if (gold) {
          titles.add(
            TitleWon(
              year: h.year,
              competition: h.competition,
              wasHost: h.hostId == arg.nationId,
            ),
          );
        }
      }
      titles.sort((a, b) => b.year.compareTo(a.year));

      // Finals appearances: distinct years the nation had a finals-round
      // fixture, split by World Cup vs. continental. (Continental fixtures
      // exist only for the player's own confederation; others honours-only.)
      final wcYears = <int>{};
      final coYears = <int>{};
      for (final f in fixtures) {
        if (!_isFinalsRound(f.round)) continue;
        if (f.round!.startsWith('C')) {
          coYears.add(f.date.year);
        } else {
          wcYears.add(f.date.year);
        }
      }

      // All-time top scorers, resolving names (even for retired legends).
      final tallies = await comp.nationTopScorers(
        arg.careerId,
        arg.nationId,
        limit: 8,
      );
      final playerRepo = ref.watch(playerRepositoryProvider);
      final scorers = <ScorerRecord>[];
      for (final t in tallies) {
        final p = await playerRepo.byId(
          t.playerId,
          agingYears: CareerService.agingYears(career),
          saveSeed: career.rngSeed,
        );
        scorers.add(ScorerRecord(name: p?.name ?? 'Unknown', goals: t.goals));
      }

      // World-ranking history: the frozen snapshot entering each past cycle,
      // then the live position now.
      final ranking = await ref.watch(
        worldRankingProvider(arg.careerId).future,
      );
      final seedRepo = ref.watch(seedRankingRepositoryProvider);
      final baseYear = CareerService.cycleStart.year;
      final history = <RankPoint>[];
      for (var c = 0; c <= career.cyclePointer; c++) {
        final snap = await seedRepo.forCycle(arg.careerId, c);
        final rank = snap[arg.nationId] ?? nation.ranking;
        history.add(
          RankPoint(year: baseYear + 4 * c, rank: rank, isNow: false),
        );
      }
      final liveRank = ranking?.position[arg.nationId];
      if (liveRank != null) {
        history.add(
          RankPoint(
            year: baseYear + 4 * career.cyclePointer,
            rank: liveRank,
            isNow: true,
          ),
        );
      }

      return NationVitrine(
        nation: nation,
        currentRank: liveRank,
        currentPoints: ranking?.points[arg.nationId],
        worldCup: MedalHaul(
          golds: wcG,
          silvers: wcS,
          bronzes: wcB,
          appearances: wcYears.length,
        ),
        continental: MedalHaul(
          golds: coG,
          silvers: coS,
          bronzes: coB,
          appearances: coYears.length,
        ),
        titles: titles,
        topScorers: scorers,
        rankHistory: history,
        isPlayerNation: arg.nationId == career.nationId,
      );
    });
