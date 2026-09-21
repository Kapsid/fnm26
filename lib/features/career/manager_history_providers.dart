import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/trophies.dart';
import 'package:fnm/features/career/career_providers.dart';

/// One cycle of the manager's career: the nation led, the win/loss balance, and
/// how each tournament ended.
class ManagerCycle {
  const ManagerCycle({
    required this.cycle,
    required this.year,
    required this.nation,
    required this.played,
    required this.won,
    required this.drawn,
    required this.lost,
    required this.goalsFor,
    required this.goalsAgainst,
    required this.worldCup,
    required this.continental,
    this.nationsCup = '',
  });

  final int cycle;

  /// The World Cup year that closes the cycle.
  final int year;
  final Nation? nation;
  final int played;
  final int won;
  final int drawn;
  final int lost;
  final int goalsFor;
  final int goalsAgainst;

  /// Placement strings, e.g. 'Champions', 'Semi-finals', 'Did not qualify'.
  final String worldCup;
  final String continental;

  /// The Nations Cup finish, e.g. 'League B · 2nd' or 'League A · Runners-up'.
  /// Empty when the manager didn't play a Nations Cup that cycle.
  final String nationsCup;

  int get goalDifference => goalsFor - goalsAgainst;
  bool get wonWorldCup => worldCup == 'Champions';
  bool get wonContinental => continental == 'Champions';
}

/// A single notable result in the manager's career — the nation they led, the
/// opponent, the scoreline (from the manager's perspective) and when/where.
typedef ManagerResult = ({
  String code,
  String opponentCode,
  String opponentName,
  int scoreFor,
  int scoreAgainst,
  DateTime date,
  String? round,
});

/// The manager's whole journey — every cycle, and the totals across them all.
class ManagerHistory {
  const ManagerHistory({
    required this.managerName,
    required this.cycles,
    required this.played,
    required this.won,
    required this.drawn,
    required this.lost,
    required this.goalsFor,
    required this.goalsAgainst,
    required this.titles,
    this.trophyCounts = const {},
    this.biggestWin,
    this.biggestLoss,
  });

  /// The manager's record win and record defeat across the whole career (by
  /// goal margin, then by goals scored/conceded), or null before any result.
  final ManagerResult? biggestWin;
  final ManagerResult? biggestLoss;

  final String managerName;

  /// Newest cycle first.
  final List<ManagerCycle> cycles;
  final int played;
  final int won;
  final int drawn;
  final int lost;
  final int goalsFor;
  final int goalsAgainst;

  /// Total championships (World Cup + continental) won across the career.
  final int titles;

  /// Trophy-cabinet tallies keyed by trophy id (see [Trophies]): how many of
  /// each the manager has won, for the cabinet display.
  final Map<String, int> trophyCounts;

  int get goalDifference => goalsFor - goalsAgainst;

  /// The distinct nations the manager has led.
  int get nationsLed =>
      {for (final c in cycles) c.nation?.id}.whereType<int>().length;

  /// World Cups won across the whole career.
  int get worldCups => cycles.where((c) => c.wonWorldCup).length;

  /// Continental titles won across the whole career.
  int get continentalTitles => cycles.where((c) => c.wonContinental).length;

  /// The manager's win percentage (0–100), 0 with no matches.
  int get winRate => played == 0 ? 0 : (won * 100 / played).round();
}

const _wcRounds = ['GROUP', 'R32', 'R16', 'QF', 'SF', '3RD', 'FINAL'];

final AutoDisposeFutureProviderFamily<ManagerHistory?, int>
managerHistoryProvider = FutureProvider.autoDispose.family<ManagerHistory?, int>(
  (
    ref,
    careerId,
  ) async {
    await ref.watch(seedLoaderProvider).ensureSeeded();
    final careerRepo = ref.watch(careerRepositoryProvider);
    final career = await careerRepo.byId(careerId);
    if (career == null) return null;
    final comp = ref.watch(competitionRepositoryProvider);
    final nations = {
      for (final n in await ref.watch(nationRepositoryProvider).all()) n.id: n,
    };
    final stints = await careerRepo.stints(careerId);

    // Fixtures per nation the manager led (cached — a nation can recur).
    final fixturesByNation = <int, List<Fixture>>{};
    Future<List<Fixture>> fx(int nationId) async =>
        fixturesByNation[nationId] ??= await comp.fixturesForNation(
          careerId,
          nationId,
        );

    // Nations Cup finishes per nation, indexed by cycle (cached like fixtures).
    final ncByNation = <int, Map<int, String>>{};
    Future<Map<int, String>> ncFor(int nationId) async =>
        ncByNation[nationId] ??= {
          for (final e in await comp.nationsCupFinishes(careerId, nationId))
            e.cycle: e.finals != null
                ? 'League ${e.league} · ${e.finals}'
                : 'League ${e.league} · ${_ordinal(e.position)}',
        };

    ManagerResult? biggestWin;
    ManagerResult? biggestLoss;

    final cycles = <ManagerCycle>[];
    for (var c = 0; c <= career.cyclePointer; c++) {
      final nationId = stints[c] ?? career.nationId;
      final start = DateTime(CareerService.cycleStart.year + 4 * c, 8);
      final end = DateTime(CareerService.cycleStart.year + 4 * (c + 1), 8);
      final all = await fx(nationId);
      final mine = all.where(
        (f) => f.hasResult && !f.date.isBefore(start) && f.date.isBefore(end),
      );

      var played = 0;
      var won = 0;
      var drawn = 0;
      var lost = 0;
      var gf = 0;
      var ga = 0;
      for (final f in mine) {
        final home = f.homeNationId == nationId;
        final my = home ? f.homeScore! : f.awayScore!;
        final other = home ? f.awayScore! : f.homeScore!;
        played++;
        gf += my;
        ga += other;
        final oppId = home ? f.awayNationId : f.homeNationId;
        final result = (
          code: nations[nationId]?.code ?? '??',
          opponentCode: nations[oppId]?.code ?? '??',
          opponentName: nations[oppId]?.name ?? 'Unknown',
          scoreFor: my,
          scoreAgainst: other,
          date: f.date,
          round: f.round,
        );
        if (my > other) {
          won++;
          // Record win: biggest margin, then most goals scored.
          final w = biggestWin;
          if (w == null ||
              my - other > w.scoreFor - w.scoreAgainst ||
              (my - other == w.scoreFor - w.scoreAgainst && my > w.scoreFor)) {
            biggestWin = result;
          }
        } else if (my == other) {
          drawn++;
        } else {
          lost++;
          // Record defeat: biggest margin, then most goals conceded.
          final l = biggestLoss;
          if (l == null ||
              other - my > l.scoreAgainst - l.scoreFor ||
              (other - my == l.scoreAgainst - l.scoreFor &&
                  other > l.scoreAgainst)) {
            biggestLoss = result;
          }
        }
      }

      final inCycle = all
          .where((f) => !f.date.isBefore(start) && f.date.isBefore(end))
          .toList();
      cycles.add(
        ManagerCycle(
          cycle: c,
          year: CareerService.worldCupYear(c),
          nation: nations[nationId],
          played: played,
          won: won,
          drawn: drawn,
          lost: lost,
          goalsFor: gf,
          goalsAgainst: ga,
          worldCup: _placement(inCycle, nationId, continental: false),
          continental: _placement(inCycle, nationId, continental: true),
          nationsCup: (await ncFor(nationId))[c] ?? '',
        ),
      );
    }
    cycles.sort((a, b) => b.cycle.compareTo(a.cycle));

    var played = 0;
    var won = 0;
    var drawn = 0;
    var lost = 0;
    var gf = 0;
    var ga = 0;
    var titles = 0;
    for (final c in cycles) {
      played += c.played;
      won += c.won;
      drawn += c.drawn;
      lost += c.lost;
      gf += c.goalsFor;
      ga += c.goalsAgainst;
      if (c.wonWorldCup) titles++;
      if (c.wonContinental) titles++;
    }

    // Trophy cabinet: every trophy the manager lifted, keyed by trophy id. Only
    // this career's own editions, and only when the champion was the nation the
    // manager led that cycle.
    final honours = await comp.honours(careerId);
    final trophyCounts = <String, int>{};
    int cycleForYear(int year) {
      final c = ((year - CareerService.worldCupYear(0)) / 4).ceil();
      return c < 0 ? 0 : c;
    }

    for (final h in honours) {
      if (!CareerService.isOwnHonourYear(h.year)) continue;
      final managed = stints[cycleForYear(h.year)] ?? career.nationId;
      if (h.championId != managed) continue;
      final key = Trophies.keyForCompetitionName(h.competition);
      if (key != null) trophyCounts[key] = (trophyCounts[key] ?? 0) + 1;
    }

    return ManagerHistory(
      managerName: career.managerName,
      cycles: cycles,
      played: played,
      won: won,
      drawn: drawn,
      lost: lost,
      goalsFor: gf,
      goalsAgainst: ga,
      titles: titles,
      trophyCounts: trophyCounts,
      biggestWin: biggestWin,
      biggestLoss: biggestLoss,
    );
  },
);

String _ordinal(int n) => switch (n) {
  1 => '1st',
  2 => '2nd',
  3 => '3rd',
  _ => '${n}th',
};

/// The nation's finish in a competition this cycle, from its finals fixtures.
String _placement(
  List<Fixture> fixtures,
  int nationId, {
  required bool continental,
}) {
  final rounds = fixtures.where((f) {
    final r = f.round;
    if (r == null) return false;
    final isC = r.startsWith('C');
    if (isC != continental) return false;
    final core = isC ? r.substring(1) : r;
    return _wcRounds.contains(core);
  }).toList();
  if (rounds.isEmpty) return 'Did not qualify';

  var deepest = -1;
  Fixture? finalTie;
  Fixture? thirdTie;
  for (final f in rounds) {
    final r = f.round!;
    final core = r.startsWith('C') ? r.substring(1) : r;
    final idx = _wcRounds.indexOf(core);
    if (idx > deepest) deepest = idx;
    if (core == 'FINAL') finalTie = f;
    if (core == '3RD') thirdTie = f;
  }

  bool wonAt(Fixture? f) {
    if (f == null || !f.hasResult) return false;
    final home = f.homeNationId == nationId;
    final my = home ? f.homeScore! : f.awayScore!;
    final other = home ? f.awayScore! : f.homeScore!;
    return my >= other; // ties (pens) list the winner as home
  }

  return switch (_wcRounds[deepest]) {
    'FINAL' => wonAt(finalTie) ? 'Champions' : 'Runners-up',
    '3RD' => wonAt(thirdTie) ? 'Third place' : 'Fourth place',
    // Continental cups have no third-place match — both beaten semi-finalists
    // share the bronze, so a lost semi there is a third-place finish.
    'SF' => continental ? 'Third place' : 'Semi-finals',
    'QF' => 'Quarter-finals',
    'R16' => 'Round of 16',
    'R32' => 'Round of 32',
    _ => 'Group stage',
  };
}
