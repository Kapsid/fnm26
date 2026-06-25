import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/repositories/career_repository.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/domain/services/competition/qualification.dart';
import 'package:fnm/domain/services/competition/qualification_format.dart';
import 'package:fnm/domain/services/competition/schedule_generator.dart';
import 'package:fnm/domain/services/competition/tournament_sim.dart';
import 'package:fnm/domain/services/match/goal_attribution.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_simulator.dart';
import 'package:fnm/features/career/career_providers.dart';

/// Everything the Hub screen needs for a save, in one fetch.
class HubData {
  const HubData({
    required this.career,
    required this.group,
    required this.next,
    required this.fixtures,
    required this.nations,
    required this.squadSize,
    required this.squadRating,
    required this.championNationId,
    required this.hasFinals,
  });

  final Career career;
  final GroupTable? group;
  final Fixture? next;
  final List<Fixture> fixtures;
  final Map<int, Nation> nations;

  /// The World Cup winner once the final is played, else null.
  final int? championNationId;

  /// Whether the World Cup finals have been drawn (draw ceremony available).
  final bool hasFinals;

  /// Number of players in the nation's pool.
  final int squadSize;

  /// Average overall rating of the nation's pool.
  final int squadRating;

  /// Played fixtures, most recent first.
  List<Fixture> get recentResults =>
      fixtures.where((f) => f.hasResult).toList().reversed.toList();
}

final FutureProviderFamily<HubData?, int>
hubDataProvider = FutureProvider.family<HubData?, int>((ref, careerId) async {
  await ref.watch(seedLoaderProvider).ensureSeeded();
  final careerRepo = ref.watch(careerRepositoryProvider);
  final compRepo = ref.watch(competitionRepositoryProvider);

  final career = await careerRepo.byId(careerId);
  if (career == null) return null;

  final group = await compRepo.groupTableForNation(careerId, career.nationId);
  final next = await compRepo.nextFixtureForNation(
    careerId,
    career.nationId,
    career.inGameDate,
  );
  final fixtures = await compRepo.fixturesForNation(careerId, career.nationId);
  final nations = {
    for (final n in await ref.watch(nationRepositoryProvider).all()) n.id: n,
  };
  final squad = await ref
      .watch(playerRepositoryProvider)
      .byNation(
        career.nationId,
      );
  final squadRating = squad.isEmpty
      ? 0
      : (squad.fold<int>(0, (s, p) => s + p.overall) / squad.length).round();

  final champion = await compRepo.worldChampion(careerId);
  final hasFinals = await compRepo.hasFinals(careerId);

  return HubData(
    career: career,
    group: group,
    next: next,
    fixtures: fixtures,
    nations: nations,
    squadSize: squad.length,
    squadRating: squadRating,
    championNationId: champion,
    hasFinals: hasFinals,
  );
});

/// Drives the whole-world simulation: quick-sims due matches, advances the
/// date, and progresses the cycle (qualifying → finals draw → knockout →
/// champion). Knockout ties are always resolved to a winner.
class SeasonService {
  SeasonService(this._ref);

  final Ref _ref;

  CompetitionRepository get _comp => _ref.read(competitionRepositoryProvider);
  CareerRepository get _careers => _ref.read(careerRepositoryProvider);

  /// Player pools are static seed data, so cache them across the run.
  final Map<int, List<Player>> _poolCache = {};

  Future<Map<int, Nation>> _nationsById() async => {
    for (final n in await _ref.read(nationRepositoryProvider).all()) n.id: n,
  };

  Future<List<Player>> _pool(int nationId) async => _poolCache[nationId] ??=
      await _ref.read(playerRepositoryProvider).byNation(nationId);

  static bool _isKnockout(Fixture f) => f.round != null && f.round != 'GROUP';

  Future<void> _simAndRecord(
    Fixture f,
    Map<int, Nation> nations,
    int rngSeed,
  ) async {
    final home = nations[f.homeNationId];
    final away = nations[f.awayNationId];
    if (home == null || away == null) return;
    const sim = RatingMatchSimulator();
    final outcome = sim.simulate(
      homeStrength: RatingMatchSimulator.strengthOf(home),
      awayStrength: RatingMatchSimulator.strengthOf(away),
      rng: SeededRng.forFixture(rngSeed, f.id),
    );
    // Attribute scorers from the pre-shootout score (penalties don't count).
    await _attributeGoals(
      f,
      f.homeNationId,
      outcome.homeScore,
      rngSeed,
      0x6001,
    );
    await _attributeGoals(
      f,
      f.awayNationId,
      outcome.awayScore,
      rngSeed,
      0x6002,
    );

    var hs = outcome.homeScore;
    var as = outcome.awayScore;
    if (_isKnockout(f)) {
      final resolved = WorldCupFinals.resolveTie(
        hs,
        as,
        SeededRng.forFixture(rngSeed, f.id ^ 0x7F),
      );
      hs = resolved.$1;
      as = resolved.$2;
    }
    await _comp.recordResult(fixtureId: f.id, homeScore: hs, awayScore: as);
  }

  Future<void> _attributeGoals(
    Fixture f,
    int nationId,
    int goals,
    int rngSeed,
    int salt,
  ) async {
    if (goals <= 0) return;
    final pool = await _pool(nationId);
    if (pool.isEmpty) return;
    final rng = SeededRng.forFixture(rngSeed, f.id ^ salt);
    final ids = GoalAttribution.scorers(pool: pool, goals: goals, rng: rng);
    await _comp.recordGoals([
      for (final id in ids)
        (
          careerId: f.careerId,
          competitionId: f.competitionId,
          fixtureId: f.id,
          nationId: nationId,
          playerId: id,
          minute: 1 + rng.nextInt(90),
        ),
    ]);
  }

  Future<void> _simDue(int careerId, DateTime upTo, int rngSeed) async {
    final due = await _comp.unplayedDueBy(careerId, upTo);
    final nations = await _nationsById();
    for (final f in due) {
      await _simAndRecord(f, nations, rngSeed);
    }
  }

  /// Quick-sims the world to the player's next match, or — if the player has
  /// no fixture — fast-forwards through the rest of the cycle (other regions'
  /// qualifiers, the finals draw, and the knockout) to the champion.
  Future<void> advance(int careerId) async {
    while (true) {
      final career = await _careers.byId(careerId);
      if (career == null) break;

      final next = await _comp.nextFixtureForNation(
        careerId,
        career.nationId,
        career.inGameDate,
      );
      if (next != null) {
        await _simDue(careerId, next.date, career.rngSeed);
        await _careers.updateInGameDate(careerId, next.date);
        await _progress(careerId);
        break;
      }

      // Player idle: spawn the next stage if due, then sim one world matchday.
      await _progress(careerId);
      final earliest = await _comp.earliestUnplayedDate(
        careerId,
        career.inGameDate,
      );
      if (earliest == null) break; // cycle complete
      await _simDue(careerId, earliest, career.rngSeed);
      await _careers.updateInGameDate(careerId, earliest);
      await _progress(careerId);
    }
    _ref.invalidate(hubDataProvider);
  }

  /// Records the player's [result] for [fixture] (from the tactical engine),
  /// quick-sims every other match due that day, advances and progresses.
  Future<void> playPlayerMatch(
    int careerId,
    Fixture fixture,
    MatchResult result,
  ) async {
    final career = await _careers.byId(careerId);
    if (career == null) return;

    var hs = result.homeScore;
    var as = result.awayScore;
    if (_isKnockout(fixture)) {
      final resolved = WorldCupFinals.resolveTie(
        hs,
        as,
        SeededRng.forFixture(career.rngSeed, fixture.id ^ 0x7F),
      );
      hs = resolved.$1;
      as = resolved.$2;
    }
    await _comp.recordResult(
      fixtureId: fixture.id,
      homeScore: hs,
      awayScore: as,
    );
    // Persist the engine's actual scorers for the player's match.
    await _comp.recordGoals([
      for (final e in result.events)
        if (e.type == MatchEventType.goal)
          (
            careerId: careerId,
            competitionId: fixture.competitionId,
            fixtureId: fixture.id,
            nationId: e.teamNationId,
            playerId: e.playerId,
            minute: e.minute,
          ),
    ]);

    await _simDue(careerId, fixture.date, career.rngSeed);
    await _careers.updateInGameDate(careerId, fixture.date);
    await _progress(careerId);
    _ref.invalidate(hubDataProvider);
  }

  // --- Cycle progression ----------------------------------------------------

  static int _winner(Fixture f) =>
      f.homeScore! >= f.awayScore! ? f.homeNationId : f.awayNationId;
  static int _loser(Fixture f) =>
      f.homeScore! >= f.awayScore! ? f.awayNationId : f.homeNationId;

  Future<bool> _roundComplete(
    int careerId,
    String round, {
    CompetitionKind kind = CompetitionKind.worldCupFinals,
  }) async {
    final fx = await _comp.fixturesByRound(careerId, round, kind: kind);
    return fx.isNotEmpty && fx.every((f) => f.hasResult);
  }

  Future<DateTime> _maxDate(
    int careerId,
    String round, {
    CompetitionKind kind = CompetitionKind.worldCupFinals,
  }) async {
    final fx = await _comp.fixturesByRound(careerId, round, kind: kind);
    return fx.map((f) => f.date).reduce((a, b) => a.isAfter(b) ? a : b);
  }

  /// Creates the next competition stage when the current one finishes.
  Future<void> _progress(int careerId) async {
    await _progressWorldCup(careerId);
    await _progressContinental(careerId);
  }

  Future<void> _progressWorldCup(int careerId) async {
    if (!await _comp.hasFinals(careerId)) {
      if (await _comp.allQualifyingPlayed(careerId)) {
        await _generateFinals(careerId);
      }
      return;
    }

    // Round of 16 (after the group stage).
    if ((await _comp.fixturesByRound(careerId, WorldCupFinals.r16)).isEmpty) {
      if (await _roundComplete(careerId, 'GROUP')) {
        final tables = await _comp.finalsGroupTables(careerId);
        final pairings = WorldCupFinals.roundOf16(
          tables.map((t) => t.standings).toList(),
        );
        await _comp.addKnockoutFixtures(
          careerId: careerId,
          round: WorldCupFinals.r16,
          pairings: pairings,
          date: (await _maxDate(careerId, 'GROUP')).add(
            const Duration(days: 7),
          ),
        );
      }
      return;
    }

    await _advanceTournamentKnockout(careerId, CompetitionKind.worldCupFinals);
    await _recordHonourIfDecided(careerId);
  }

  Future<void> _progressContinental(int careerId) async {
    if (!await _comp.hasTournament(
      careerId,
      CompetitionKind.continentalFinals,
    )) {
      return;
    }
    await _advanceTournamentKnockout(
      careerId,
      CompetitionKind.continentalFinals,
      prefix: 'C',
    );
    await _recordContinentalHonourIfDecided(careerId);
  }

  /// Advances a knockout from its first round to the final + third-place game.
  /// The R16 step is a no-op for brackets that start later (e.g. an 8-team
  /// continental cup that opens at the quarter-finals). [prefix] namespaces the
  /// round labels so the continental cup is distinct from the World Cup.
  Future<void> _advanceTournamentKnockout(
    int careerId,
    CompetitionKind kind, {
    String prefix = '',
  }) async {
    final r16 = '${prefix}R16';
    final qf = '${prefix}QF';
    final sf = '${prefix}SF';
    final third = '${prefix}3RD';
    final fin = '${prefix}FINAL';

    await _advanceRound(careerId, r16, qf, 4, kind: kind);
    await _advanceRound(careerId, qf, sf, 4, kind: kind);

    if ((await _comp.fixturesByRound(careerId, fin, kind: kind)).isEmpty &&
        await _roundComplete(careerId, sf, kind: kind)) {
      final semis = await _comp.fixturesByRound(careerId, sf, kind: kind);
      final date = (await _maxDate(
        careerId,
        sf,
        kind: kind,
      )).add(const Duration(days: 5));
      await _comp.addKnockoutFixtures(
        careerId: careerId,
        round: third,
        kind: kind,
        pairings: WorldCupFinals.pairWinners(semis.map(_loser).toList()),
        date: date,
      );
      await _comp.addKnockoutFixtures(
        careerId: careerId,
        round: fin,
        kind: kind,
        pairings: WorldCupFinals.pairWinners(semis.map(_winner).toList()),
        date: date,
      );
    }
  }

  /// Records the player's continental championship to the honours roll once its
  /// final is played (so the played result — not the background sim — counts).
  Future<void> _recordContinentalHonourIfDecided(int careerId) async {
    const kind = CompetitionKind.continentalFinals;
    final finals = await _comp.fixturesByRound(
      careerId,
      'CFINAL',
      kind: kind,
    );
    if (finals.isEmpty || !finals.first.hasResult) return;
    final f = finals.first;
    final year = f.date.year;

    final career = await _careers.byId(careerId);
    if (career == null) return;
    final nations = await _nationsById();
    final conf = nations[career.nationId]?.confederation;
    if (conf == null) return;
    final name = ContinentalCups.byConfederation[conf]?.name;
    if (name == null) return;
    if (await _comp.hasHonour(careerId, name, year)) return;

    final thirds = await _comp.fixturesByRound(careerId, 'C3RD', kind: kind);
    final boot = await _comp.topScorers(careerId, kind: kind, limit: 1);
    String? bootName;
    int? bootGoals;
    if (boot.isNotEmpty) {
      bootName = (await _ref
              .read(playerRepositoryProvider)
              .byId(boot.first.playerId))
          ?.name;
      bootGoals = boot.first.goals;
    }

    final champIsHome = f.homeScore! >= f.awayScore!;
    await _comp.recordHonour(
      careerId: careerId,
      year: year,
      competition: name,
      championId: _winner(f),
      runnerUpId: _loser(f),
      thirdId: thirds.isNotEmpty && thirds.first.hasResult
          ? _winner(thirds.first)
          : null,
      finalHomeScore: champIsHome ? f.homeScore : f.awayScore,
      finalAwayScore: champIsHome ? f.awayScore : f.homeScore,
      topScorerName: bootName,
      topScorerGoals: bootGoals,
    );
  }

  /// Records the World Cup roll-of-honour entry once the final is played.
  Future<void> _recordHonourIfDecided(int careerId) async {
    final finals = await _comp.fixturesByRound(
      careerId,
      WorldCupFinals.finalRound,
    );
    if (finals.isEmpty || !finals.first.hasResult) return;
    final f = finals.first;
    final year = f.date.year;
    if (await _comp.hasHonour(careerId, 'World Championship', year)) return;

    final thirds = await _comp.fixturesByRound(careerId, WorldCupFinals.third);
    final nations = await _nationsById();
    final host = WorldCupHosts.hostFor(
      year: year,
      nations: nations.values.toList(),
      seed: (await _careers.byId(careerId))?.rngSeed ?? 0,
    );

    final boot = await _comp.topScorers(
      careerId,
      kind: CompetitionKind.worldCupFinals,
      limit: 1,
    );
    String? bootName;
    int? bootGoals;
    if (boot.isNotEmpty) {
      final p = await _ref.read(playerRepositoryProvider).byId(
            boot.first.playerId,
          );
      bootName = p?.name;
      bootGoals = boot.first.goals;
    }

    // The champion is the home/away winner; orient the score accordingly.
    final champIsHome = f.homeScore! >= f.awayScore!;
    await _comp.recordHonour(
      careerId: careerId,
      year: year,
      competition: 'World Championship',
      championId: _winner(f),
      runnerUpId: _loser(f),
      thirdId: thirds.isNotEmpty && thirds.first.hasResult
          ? _winner(thirds.first)
          : null,
      hostId: host,
      finalHomeScore: champIsHome ? f.homeScore : f.awayScore,
      finalAwayScore: champIsHome ? f.awayScore : f.homeScore,
      topScorerName: bootName,
      topScorerGoals: bootGoals,
    );

    await _simulateContinentalCups(careerId, year);
  }

  /// Background-simulates each confederation's continental championship (held
  /// two years before the World Cup). The player's own confederation is played
  /// out and recorded separately, so its honour is skipped here when present.
  Future<void> _simulateContinentalCups(int careerId, int wcYear) async {
    final year = wcYear - 2;
    final career = await _careers.byId(careerId);
    if (career == null) return;
    final nations = await _ref.read(nationRepositoryProvider).all();
    final strengthById = {
      for (final n in nations) n.id: (220 - n.ranking).clamp(1, 220),
    };

    for (final entry in ContinentalCups.byConfederation.entries) {
      final cont = entry.value;
      if (await _comp.hasHonour(careerId, cont.name, year)) continue;

      final members =
          nations.where((n) => n.confederation == entry.key).toList()
            ..sort((a, b) => a.ranking.compareTo(b.ranking));
      if (members.length < 4) continue;

      final result = TournamentSim.run(
        seededByStrength: members.take(cont.size).map((n) => n.id).toList(),
        strengthById: strengthById,
        seed: career.rngSeed ^ (year * 0x33) ^ entry.key.index,
      );
      if (result == null) continue;

      await _comp.recordHonour(
        careerId: careerId,
        year: year,
        competition: cont.name,
        championId: result.champion,
        runnerUpId: result.runnerUp,
        thirdId: result.third,
        hostId: members.first.id,
        finalHomeScore: result.finalHome,
        finalAwayScore: result.finalAway,
      );
    }
  }

  Future<void> _advanceRound(
    int careerId,
    String from,
    String to,
    int plusDays, {
    CompetitionKind kind = CompetitionKind.worldCupFinals,
  }) async {
    if ((await _comp.fixturesByRound(careerId, to, kind: kind)).isNotEmpty) {
      return;
    }
    if (!await _roundComplete(careerId, from, kind: kind)) return;
    final fx = await _comp.fixturesByRound(careerId, from, kind: kind);
    await _comp.addKnockoutFixtures(
      careerId: careerId,
      round: to,
      kind: kind,
      pairings: WorldCupFinals.pairWinners(fx.map(_winner).toList()),
      date: (await _maxDate(
        careerId,
        from,
        kind: kind,
      )).add(Duration(days: plusDays)),
    );
  }

  /// The World Cup finals year for a cycle (clean 4-year cadence: 2030, 2034…).
  static int finalsYear(int cycle) => CareerService.worldCupYear(cycle);

  Future<void> _generateFinals(int careerId) async {
    final career = await _careers.byId(careerId);
    if (career == null) return;

    final byConfederation = await _comp.allGroupTablesByConfederation(
      careerId,
    );
    final grouped = <Confederation, List<List<GroupStanding>>>{};
    for (final t in byConfederation) {
      (grouped[t.confederation] ??= []).add(t.standings);
    }

    final qualifiers = <int>[];
    for (final entry in grouped.entries) {
      final berths = QualificationFormat.forConfederation(
        entry.key,
      ).finalsBerths;
      qualifiers.addAll(Qualification.qualifiers(entry.value, berths));
    }

    final nations = await _nationsById();
    final rankingById = {for (final n in nations.values) n.id: n.ranking};
    final year = finalsYear(career.cyclePointer);

    // The host nation qualifies automatically (replacing the weakest berth).
    final host = WorldCupHosts.hostFor(
      year: year,
      nations: nations.values.toList(),
      seed: career.rngSeed,
    );
    if (!qualifiers.contains(host) && qualifiers.isNotEmpty) {
      qualifiers
        ..sort((a, b) => (rankingById[a] ?? 9999).compareTo(
              rankingById[b] ?? 9999,
            ))
        ..removeLast()
        ..add(host);
    }

    final draw = WorldCupFinals.drawGroups(
      qualifierIds: qualifiers,
      rankingById: rankingById,
      rngSeed: career.rngSeed ^ (career.cyclePointer * 0x2D31),
    );
    if (draw.groups.isEmpty) return;

    await _comp.saveFinals(
      careerId: careerId,
      draw: draw,
      groupStart: DateTime(year, 6, 11),
      cycle: career.cyclePointer,
    );
  }

  /// Starts the next 4-year cycle once the current World Cup is decided:
  /// re-draws every confederation's qualifiers and advances the calendar.
  Future<void> startNextCycle(int careerId) async {
    final career = await _careers.byId(careerId);
    if (career == null) return;
    if (await _comp.worldChampion(careerId) == null) return; // not finished

    final nextCycle = career.cyclePointer + 1;
    final nextStart = DateTime(finalsYear(career.cyclePointer), 9);

    final byConfederation = <Confederation, List<Nation>>{};
    for (final n in await _ref.read(nationRepositoryProvider).all()) {
      (byConfederation[n.confederation] ??= []).add(n);
    }
    for (final entry in byConfederation.entries) {
      if (entry.value.length < 2) continue;
      final schedule = const ScheduleGenerator().generate(
        confederation: entry.key,
        nations: entry.value,
        rngSeed: career.rngSeed ^
            (nextCycle * 0x1B3D) ^
            (entry.key.index * 0x9E37),
        start: nextStart,
      );
      await _comp.saveSchedule(
        careerId: careerId,
        schedule: schedule,
        cycle: nextCycle,
      );
    }

    await _careers.advanceCycle(careerId, nextCycle, nextStart);

    // Nations League + friendlies fill the new cycle's windows.
    await CareerService.fillGap(
      comp: _comp,
      nations: await _ref.read(nationRepositoryProvider).all(),
      careerId: careerId,
      nationId: career.nationId,
      rngSeed: career.rngSeed,
      cycle: nextCycle,
      qualifyingStart: nextStart,
      wcYear: finalsYear(nextCycle),
    );

    _ref.invalidate(hubDataProvider);
  }
}

final Provider<SeasonService> seasonServiceProvider = Provider(
  SeasonService.new,
);
