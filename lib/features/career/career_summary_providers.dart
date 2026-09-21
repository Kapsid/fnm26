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
    required this.nationName,
    required this.nationCode,
    this.championName,
  });

  final int year;

  /// The nation the manager was in charge of for this tournament, and its
  /// three-letter code. A career can run through several, and a row that does
  /// not say which one leaves the manager reading his own history guessing.
  final String nationName;
  final String nationCode;

  /// Stored competition name, e.g. 'World Championship' or a continental cup
  /// name. Written for the manager with `competitionLabel` at display.
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

  /// Stored competition name, e.g. 'World Championship'. Written for the
  /// manager with `competitionLabel` at display.
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
    required this.spansNations,
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

  /// Whether this career has been spent at more than one nation. A one-nation
  /// manager does not need every row telling him who he manages.
  final bool spansNations;

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
careerSummaryProvider = FutureProvider.autoDispose.family<CareerSummary?, int>((
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
  final honours = (await comp.honours(
    careerId,
  )).where((h) => CareerService.isOwnHonourYear(h.year)).toList();

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
  // A campaign belongs to the nation that was managed THAT cycle, so its
  // fixtures have to be read from that nation's list. Read from the current
  // one, every tournament contested before a change of job came back empty and
  // the row said "Did not qualify" for a cup the manager had actually won.
  final fixturesByNation = <int, List<Fixture>>{career.nationId: fixtures};
  Future<List<Fixture>> fixturesOf(int nationId) async =>
      fixturesByNation[nationId] ??= await comp.fixturesForNation(
        careerId,
        nationId,
      );
  for (final h in honours) {
    final isWc = h.competition == 'World Championship';
    final managedId = stints[cycleForYear(h.year)] ?? career.nationId;
    if (!isWc) {
      final conf = nations[managedId]?.confederation;
      final ownCup = conf == null
          ? null
          : ContinentalCups.byConfederation[conf]?.name;
      if (h.competition != ownCup) continue;
    }
    // The stored name IS the name; `competitionLabel` writes it for the
    // manager at the point it is printed. Rewriting it to a second English
    // spelling here just to have that map it back was a detour that had to be
    // kept in step with the copy, and wasn't.
    final display = h.competition;
    final mine = (await fixturesOf(managedId)).where((f) {
      final core = _coreRound(f.round);
      return f.hasResult &&
          core != null &&
          _isContinentalRound(f.round!) == !isWc &&
          f.date.year == h.year;
    }).toList();

    final (placement, medal) = _placement(mine, managedId);
    runs.add(
      TournamentRun(
        year: h.year,
        competition: display,
        placement: placement,
        medal: medal,
        qualified: mine.isNotEmpty,
        nationName: nations[managedId]?.name ?? '',
        nationCode: nations[managedId]?.code ?? '',
        championName: nations[h.championId]?.name,
      ),
    );
  }
  runs.sort((a, b) => b.year.compareTo(a.year));

  // The medal tally counts EVERY competition the manager's side placed in, read
  // straight off the roll of honour. It used to be a by-product of the runs
  // above, which list only the World Cup and the manager's own continental cup
  // — so a Nations Cup or a Continental Clash could be won and the cabinet
  // would not show it, while the career tab (which reads the honours) did.
  for (final h in honours) {
    final managed = stints[cycleForYear(h.year)] ?? career.nationId;
    if (h.championId == managed) {
      golds++;
    } else if (h.runnerUpId == managed) {
      silvers++;
    } else if (h.thirdId == managed || h.thirdId2 == managed) {
      bronzes++;
    }
  }

  // The full trophy cabinet: every honour this career won, grouped by
  // competition. A trophy counts as the manager's when the nation they were
  // managing that cycle is the champion — so titles survive a change of nation
  // (the runs above only track the current nation's own campaigns).
  final byCompetition = <String, List<TrophyWin>>{};
  for (final h in honours) {
    final managedNation = stints[cycleForYear(h.year)] ?? career.nationId;
    if (h.championId != managedNation) continue;
    (byCompetition[h.competition] ??= []).add((
      year: h.year,
      nationName: nations[managedNation]?.name ?? 'Unknown',
    ));
  }
  final titles =
      [
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
    spansNations: {...stints.values, career.nationId}.length > 1,
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
  // Continental championships play no third-place match, so the two beaten
  // semi-finalists SHARE the bronze — a lost semi there is a third-place finish,
  // not a medal-less "semi-finals". (The World Cup, which has a 3RD play-off,
  // resolves its semi losers into 3rd/4th and never stops at 'SF'.)
  final noThirdPlace = fixtures.any(
    (f) => f.round != null && _isContinentalRound(f.round!),
  );

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
    'SF' => noThirdPlace ? ('Third place', 3) : ('Semi-finals', 0),
    'QF' => ('Quarter-finals', 0),
    'R16' => ('Round of 16', 0),
    'R32' => ('Round of 32', 0),
    _ => ('Group stage', 0),
  };
}
