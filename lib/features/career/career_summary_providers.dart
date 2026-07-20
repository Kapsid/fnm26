import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';

/// One tournament in the manager's career: how far the team went, and who won.
class TournamentRun {
  const TournamentRun({
    required this.year,
    required this.competition,
    required this.placement,
    required this.medal,
    required this.qualified,
    this.championName,
  });

  final int year;

  /// Display name, e.g. 'World Cup' or a continental cup name.
  final String competition;

  /// Human placement, e.g. 'Champions', 'Runners-up', 'Round of 16',
  /// 'Group stage', 'Did not qualify'.
  final String placement;

  /// 1 = gold, 2 = silver, 3 = bronze, 0 = none.
  final int medal;

  /// Whether the team reached this tournament's finals at all.
  final bool qualified;

  /// The tournament winner's name (context), if known.
  final String? championName;
}

/// One of the manager's titles: the year it was won and the nation they were
/// managing at the time (which can change across a career).
typedef TrophyWin = ({int year, String nationName});

/// A competition the manager has won, and every time they won it.
class TrophyTitle {
  const TrophyTitle({required this.competition, required this.wins});

  /// Display name, e.g. 'World Cup'.
  final String competition;

  /// Each win, newest first.
  final List<TrophyWin> wins;

  int get count => wins.length;
}

/// Everything the career summary screen shows for a save.
class CareerSummary {
  const CareerSummary({
    required this.career,
    required this.nation,
    required this.worldRank,
    required this.worldPoints,
    required this.seasons,
    required this.played,
    required this.won,
    required this.drawn,
    required this.lost,
    required this.goalsFor,
    required this.goalsAgainst,
    required this.golds,
    required this.silvers,
    required this.bronzes,
    required this.runs,
    required this.titles,
  });

  final Career career;
  final Nation? nation;

  /// Current live world position and points (null before any ranking exists).
  final int? worldRank;
  final int? worldPoints;

  /// Four-year cycles managed so far (cyclePointer + 1).
  final int seasons;

  final int played;
  final int won;
  final int drawn;
  final int lost;
  final int goalsFor;
  final int goalsAgainst;

  final int golds;
  final int silvers;
  final int bronzes;

  /// Tournament history, newest first.
  final List<TournamentRun> runs;

  /// Every competition the manager has won, with each win's year and nation —
  /// the trophy cabinet in full, most-won first.
  final List<TrophyTitle> titles;

  int get goalDifference => goalsFor - goalsAgainst;
  int get trophies => golds;
}

/// Knockout progression, deepest last, shared by World Cup and continental cups
/// (the latter carry a 'C' prefix, stripped before lookup).
const _roundOrder = ['GROUP', 'R32', 'R16', 'QF', 'SF', '3RD', 'FINAL'];

String? _coreRound(String? round) {
  if (round == null) return null;
  final core = round.startsWith('C') ? round.substring(1) : round;
  return _roundOrder.contains(core) ? core : null;
}

bool _isContinentalRound(String round) => round.startsWith('C');

final AutoDisposeFutureProviderFamily<CareerSummary?, int>
careerSummaryProvider =
    FutureProvider.autoDispose.family<CareerSummary?, int>((
  ref,
  careerId,
) async {
  await ref.watch(seedLoaderProvider).ensureSeeded();
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) return null;

  final comp = ref.watch(competitionRepositoryProvider);
  final nations = {
    for (final n in await ref.watch(nationRepositoryProvider).all()) n.id: n,
  };
  final nation = nations[career.nationId];

  final ranking = await ref.watch(worldRankingProvider(careerId).future);

  final fixtures = await comp.fixturesForNation(careerId, career.nationId);
  // Only this career's own editions — not the pre-seeded real-world history.
  final honours = (await comp.honours(careerId))
      .where((h) => h.year >= CareerService.cycleStart.year)
      .toList();

  // Overall record across every played international.
  var played = 0;
  var won = 0;
  var drawn = 0;
  var lost = 0;
  var gf = 0;
  var ga = 0;
  for (final f in fixtures) {
    if (!f.hasResult) continue;
    final isHome = f.homeNationId == career.nationId;
    final my = isHome ? f.homeScore! : f.awayScore!;
    final other = isHome ? f.awayScore! : f.homeScore!;
    played++;
    gf += my;
    ga += other;
    if (my > other) {
      won++;
    } else if (my == other) {
      drawn++;
    } else {
      lost++;
    }
  }

  // Which cycle an honour belongs to: worldCupYear(c) = 2030 + 4c; an honour
  // belongs to the cycle whose World Cup is the next one on or after it
  // (continental cups sit two years before their cycle's World Cup).
  final stints = await ref.watch(careerRepositoryProvider).stints(careerId);
  int cycleForYear(int year) {
    final c = ((year - CareerService.worldCupYear(0)) / 4).ceil();
    return c < 0 ? 0 : c;
  }

  // One run per tournament the manager's team could actually contest: the
  // World Cup and the continental cup of the nation they managed that cycle.
  // Other confederations' cups (and the background Nations Cup / Continental
  // Clash entries) are NOT the manager's campaigns — listing them filled the
  // career page with "Did not qualify" rows for cups the team can't enter.
  final runs = <TournamentRun>[];
  var golds = 0;
  var silvers = 0;
  var bronzes = 0;
  for (final h in honours) {
    final isWc = h.competition == 'World Championship';
    if (!isWc) {
      final managedId = stints[cycleForYear(h.year)] ?? career.nationId;
      final conf = nations[managedId]?.confederation;
      final ownCup =
          conf == null ? null : ContinentalCups.byConfederation[conf]?.name;
      if (h.competition != ownCup) continue;
    }
    final display = isWc ? 'World Cup' : h.competition;
    final mine = fixtures.where((f) {
      final core = _coreRound(f.round);
      return f.hasResult &&
          core != null &&
          _isContinentalRound(f.round!) == !isWc &&
          f.date.year == h.year;
    }).toList();

    final (placement, medal) = _placement(mine, career.nationId);
    if (medal == 1) golds++;
    if (medal == 2) silvers++;
    if (medal == 3) bronzes++;
    runs.add(TournamentRun(
      year: h.year,
      competition: display,
      placement: placement,
      medal: medal,
      qualified: mine.isNotEmpty,
      championName: nations[h.championId]?.name,
    ));
  }
  runs.sort((a, b) => b.year.compareTo(a.year));

  // The full trophy cabinet: every honour this career won, grouped by
  // competition. A trophy counts as the manager's when the nation they were
  // managing that cycle is the champion — so titles survive a change of nation
  // (the runs above only track the current nation's own campaigns).
  final byCompetition = <String, List<TrophyWin>>{};
  for (final h in honours) {
    final managedNation = stints[cycleForYear(h.year)] ?? career.nationId;
    if (h.championId != managedNation) continue;
    final display =
        h.competition == 'World Championship' ? 'World Cup' : h.competition;
    (byCompetition[display] ??= []).add((
      year: h.year,
      nationName: nations[managedNation]?.name ?? 'Unknown',
    ));
  }
  final titles = [
    for (final entry in byCompetition.entries)
      TrophyTitle(
        competition: entry.key,
        wins: entry.value..sort((a, b) => b.year.compareTo(a.year)),
      ),
  ]..sort((a, b) {
      final byCount = b.count.compareTo(a.count);
      return byCount != 0 ? byCount : a.competition.compareTo(b.competition);
    });

  return CareerSummary(
    career: career,
    nation: nation,
    worldRank: ranking?.position[career.nationId],
    worldPoints: ranking?.points[career.nationId],
    seasons: career.cyclePointer + 1,
    played: played,
    won: won,
    drawn: drawn,
    lost: lost,
    goalsFor: gf,
    goalsAgainst: ga,
    golds: golds,
    silvers: silvers,
    bronzes: bronzes,
    runs: runs,
    titles: titles,
  );
});

/// The team's placement and medal (1/2/3/0) from its finals [fixtures].
(String, int) _placement(List<Fixture> fixtures, int nationId) {
  if (fixtures.isEmpty) return ('Did not qualify', 0);

  var deepest = -1;
  for (final f in fixtures) {
    final idx = _roundOrder.indexOf(_coreRound(f.round)!);
    if (idx > deepest) deepest = idx;
  }
  final deepestRound = _roundOrder[deepest];

  bool wonAt(String core) {
    final f = fixtures.firstWhere(
      (f) => _coreRound(f.round) == core,
      orElse: () => fixtures.first,
    );
    final isHome = f.homeNationId == nationId;
    final my = isHome ? (f.homeScore ?? 0) : (f.awayScore ?? 0);
    final other = isHome ? (f.awayScore ?? 0) : (f.homeScore ?? 0);
    return my > other;
  }

  return switch (deepestRound) {
    'FINAL' => wonAt('FINAL') ? ('Champions', 1) : ('Runners-up', 2),
    '3RD' => wonAt('3RD') ? ('Third place', 3) : ('Fourth place', 0),
    'SF' => ('Semi-finals', 0),
    'QF' => ('Quarter-finals', 0),
    'R16' => ('Round of 16', 0),
    'R32' => ('Round of 32', 0),
    _ => ('Group stage', 0),
  };
}
