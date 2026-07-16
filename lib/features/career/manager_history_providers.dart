import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
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

  int get goalDifference => goalsFor - goalsAgainst;
  bool get wonWorldCup => worldCup == 'Champions';
  bool get wonContinental => continental == 'Champions';
}

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
  });

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

  int get goalDifference => goalsFor - goalsAgainst;

  /// The distinct nations the manager has led.
  int get nationsLed =>
      {for (final c in cycles) c.nation?.id}.whereType<int>().length;
}

const _wcRounds = ['GROUP', 'R32', 'R16', 'QF', 'SF', '3RD', 'FINAL'];

final AutoDisposeFutureProviderFamily<ManagerHistory?, int>
    managerHistoryProvider =
    FutureProvider.autoDispose.family<ManagerHistory?, int>((
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
      fixturesByNation[nationId] ??=
          await comp.fixturesForNation(careerId, nationId);

  final cycles = <ManagerCycle>[];
  for (var c = 0; c <= career.cyclePointer; c++) {
    final nationId = stints[c] ?? career.nationId;
    final start = DateTime(CareerService.cycleStart.year + 4 * c, 8);
    final end = DateTime(CareerService.cycleStart.year + 4 * (c + 1), 8);
    final all = await fx(nationId);
    final mine = all.where(
      (f) =>
          f.hasResult && !f.date.isBefore(start) && f.date.isBefore(end),
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
      if (my > other) {
        won++;
      } else if (my == other) {
        drawn++;
      } else {
        lost++;
      }
    }

    final inCycle = all
        .where((f) => !f.date.isBefore(start) && f.date.isBefore(end))
        .toList();
    cycles.add(ManagerCycle(
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
    ));
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
  );
});

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
    'SF' => 'Semi-finals',
    'QF' => 'Quarter-finals',
    'R16' => 'Round of 16',
    'R32' => 'Round of 32',
    _ => 'Group stage',
  };
}
