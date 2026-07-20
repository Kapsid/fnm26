import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/achievements/challenges.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/features/career/career_providers.dart';

/// The World Cup finals round codes (bare — continental/Nations Cup rounds are
/// prefixed), used to tell a finals match from a qualifier.
const _wcFinalsRounds = {'GROUP', 'R32', 'R16', 'QF', 'SF', '3RD', 'FINAL'};

/// One challenge with its live progress, for the Challenges screen.
typedef ChallengeView = ({
  ChallengeDef def,
  int current,
  int target,
  bool complete,
});

/// Gathers the whole-career [ChallengeStats] and evaluates the catalogue.
final AutoDisposeFutureProviderFamily<List<ChallengeView>, int>
    challengesViewProvider =
    FutureProvider.autoDispose.family<List<ChallengeView>, int>((
  ref,
  careerId,
) async {
  await ref.watch(seedLoaderProvider).ensureSeeded();
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) return const [];
  final comp = ref.watch(competitionRepositoryProvider);
  final nations = {
    for (final n in await ref.watch(nationRepositoryProvider).all()) n.id: n,
  };

  final honours = await comp.honours(careerId);
  final stints = await ref.watch(careerRepositoryProvider).stints(careerId);

  // Which cycle an honour belongs to (mirrors the career summary): the cycle
  // whose World Cup is the next one on or after the honour's year.
  int cycleForYear(int year) {
    final c = ((year - CareerService.worldCupYear(0)) / 4).ceil();
    return c < 0 ? 0 : c;
  }

  // Only this career's own editions count — not the pre-seeded real history.
  final ownHonours =
      honours.where((h) => h.year >= CareerService.cycleStart.year);

  final continentalNames = {
    for (final c in ContinentalCups.byConfederation.values) c.name,
  };

  final wcWinNations = <int>{};
  final wcWinConfs = <Confederation>{};
  final wcWinYears = <int>[];
  final continentalCupsWon = <String>{};
  var continentalTitles = 0;
  var nationsCupTitles = 0;
  var clashTitles = 0;

  for (final h in ownHonours) {
    final managed = stints[cycleForYear(h.year)] ?? career.nationId;
    if (h.championId != managed) continue; // a title the manager actually won
    if (h.competition == 'World Championship') {
      wcWinNations.add(managed);
      wcWinYears.add(h.year);
      final conf = nations[managed]?.confederation;
      if (conf != null) wcWinConfs.add(conf);
    } else if (continentalNames.contains(h.competition)) {
      continentalTitles++;
      continentalCupsWon.add(h.competition);
    } else if (h.competition == 'Nations Cup') {
      nationsCupTitles++;
    } else if (h.competition == 'Continental Clash') {
      clashTitles++;
    }
  }

  // Longest run of consecutive World Cups won (editions are 4 years apart).
  wcWinYears.sort();
  var streak = 0;
  var best = 0;
  int? prev;
  for (final y in wcWinYears) {
    if (prev != null && y - prev == 4) {
      streak++;
    } else {
      streak = 1;
    }
    if (streak > best) best = streak;
    prev = y;
  }

  // Distinct nations led across the career (stints + the current job).
  final nationsLed = {...stints.values, career.nationId};

  // Fixture-driven brutal challenges. Walk each cycle's managed nation and its
  // matches: perfect qualifying campaigns, undefeated title runs, host/away
  // triumphs, minnow miracles, and the longest unbeaten run.
  final fixturesByNation = <int, List<Fixture>>{};
  Future<List<Fixture>> fx(int nationId) async =>
      fixturesByNation[nationId] ??=
          await comp.fixturesForNation(careerId, nationId);

  // Which World Cup years the manager actually lifted (for undefeated/host).
  final wcWinYearSet = wcWinYears.toSet();
  var undefeated = false;
  var perfectQual = false;
  var wonAsHost = false;
  var wonAsVisitor = false;
  var wonAsMinnow = false;
  final managerResults = <Fixture>[];

  for (var c = 0; c <= career.cyclePointer; c++) {
    final nationId = stints[c] ?? career.nationId;
    final start = DateTime(CareerService.cycleStart.year + 4 * c, 8);
    final end = DateTime(CareerService.cycleStart.year + 4 * (c + 1), 8);
    final mine = (await fx(nationId)).where(
      (f) =>
          f.hasResult && !f.date.isBefore(start) && f.date.isBefore(end),
    );

    var qualPlayed = 0;
    var qualWins = 0;
    var finalsLosses = 0;
    for (final f in mine) {
      final home = f.homeNationId == nationId;
      final my = home ? f.homeScore! : f.awayScore!;
      final other = home ? f.awayScore! : f.homeScore!;
      final round = f.round;
      if (round == 'FRIENDLY') continue; // competitive only
      managerResults.add(f);
      if (round == null) {
        // A bare (round-less) competitive game is World Cup qualifying.
        qualPlayed++;
        if (my > other) qualWins++;
      } else if (_wcFinalsRounds.contains(round)) {
        // A World Cup finals match; a shootout lists the winner as home so a
        // level knockout score is not a loss.
        if (my < other) finalsLosses++;
      }
    }
    // A perfect qualifying campaign: a real one (six+ games), all won.
    if (qualPlayed >= 6 && qualWins == qualPlayed) perfectQual = true;

    // Did the manager win the World Cup this cycle with this nation?
    final wcYear = CareerService.worldCupYear(c);
    if (wcWinYearSet.contains(wcYear) &&
        (stints[c] ?? career.nationId) == nationId) {
      if (finalsLosses == 0) undefeated = true;
      final honour = ownHonours.firstWhere(
        (h) => h.competition == 'World Championship' && h.year == wcYear,
        orElse: () => (
          year: wcYear,
          competition: '',
          championId: 0,
          runnerUpId: 0,
          thirdId: null,
          hostId: null,
          finalHomeScore: null,
          finalAwayScore: null,
          topScorerName: null,
          topScorerGoals: null,
        ),
      );
      if (honour.hostId == nationId) {
        wonAsHost = true;
      } else {
        wonAsVisitor = true;
      }
      if ((nations[nationId]?.ranking ?? 0) > 32) wonAsMinnow = true;
    }
  }

  // Longest unbeaten run across every competitive match the manager oversaw.
  managerResults.sort((a, b) => a.date.compareTo(b.date));
  var run = 0;
  var longestUnbeaten = 0;
  for (final f in managerResults) {
    // Determine the managed side: the manager's nation for that fixture is
    // whichever side appears in a managed cycle. We already filtered to the
    // managed nation's fixtures, but a fixture can belong to two managed
    // nations if both were led — rare; treat by the home/away that isn't a
    // loss for either is ambiguous, so use the stint nation via date.
    final cycle = ((f.date.year - CareerService.cycleStart.year) / 4).floor();
    final nationId = stints[cycle] ?? career.nationId;
    final home = f.homeNationId == nationId;
    if (f.homeNationId != nationId && f.awayNationId != nationId) continue;
    final my = home ? f.homeScore! : f.awayScore!;
    final other = home ? f.awayScore! : f.homeScore!;
    if (my >= other) {
      run++;
      if (run > longestUnbeaten) longestUnbeaten = run;
    } else {
      run = 0;
    }
  }

  final stats = ChallengeStats(
    worldCupTitles: wcWinYears.length,
    distinctWorldCupNations: wcWinNations.length,
    worldCupConfederations: wcWinConfs,
    mostWorldCupsInARow: best,
    continentalTitles: continentalTitles,
    continentalCupsWon: continentalCupsWon,
    nationsCupTitles: nationsCupTitles,
    clashTitles: clashTitles,
    yearsManaged: career.inGameDate.year - CareerService.cycleStart.year,
    nationsManaged: nationsLed.length,
    wonWorldCupUndefeated: undefeated,
    perfectQualifying: perfectQual,
    wonWorldCupAsHost: wonAsHost,
    wonWorldCupAsVisitor: wonAsVisitor,
    wonWorldCupAsMinnow: wonAsMinnow,
    longestUnbeatenRun: longestUnbeaten,
  );

  return [
    for (final c in ChallengeCatalog.all)
      () {
        final (cur, target) = c.progressOf(stats);
        return (
          def: c,
          current: cur.clamp(0, target),
          target: target,
          complete: cur >= target,
        );
      }(),
  ];
});
