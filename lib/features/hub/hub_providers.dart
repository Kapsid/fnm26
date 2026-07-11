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
import 'package:fnm/domain/services/competition/tournament_sim.dart';
import 'package:fnm/domain/services/match/goal_attribution.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_simulator.dart';
import 'package:fnm/domain/services/player/discipline.dart';
import 'package:fnm/domain/services/ranking/elo.dart';
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
        agingCycles: career.cyclePointer,
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

  /// Player pools cached per (nation, cycle) — cheap seed data aged to the
  /// cycle currently being simulated.
  final Map<(int, int), List<Player>> _poolCache = {};

  /// The cyclePointer of the save currently being simulated (drives aging in
  /// [_pool]); set at the start of each top-level sim operation.
  int _simCycle = 0;

  Future<Map<int, Nation>> _nationsById() async => {
    for (final n in await _ref.read(nationRepositoryProvider).all()) n.id: n,
  };

  Future<List<Player>> _pool(int nationId) async =>
      _poolCache[(nationId, _simCycle)] ??= await _ref
          .read(playerRepositoryProvider)
          .byNation(nationId, agingCycles: _simCycle);

  /// Live world-ranking points for the save currently being simulated, held in
  /// memory across a whole operation and flushed once at the end (a result adds
  /// only an in-memory nudge, not a database write).
  Map<int, int>? _rankPoints;
  int? _rankCareer;

  /// Loads (seeding if needed) the ranking points for [careerId].
  Future<void> _ensureRank(int careerId) async {
    if (_rankCareer == careerId && _rankPoints != null) return;
    final nations = await _nationsById();
    final seed = {
      for (final n in nations.values) n.id: Elo.seedFromRanking(n.ranking),
    };
    _rankPoints =
        await _ref.read(rankingRepositoryProvider).pointsFor(careerId, seed);
    _rankCareer = careerId;
  }

  /// Nudges both nations' points by this result (finals count for more than
  /// qualifiers). No-op until [_ensureRank] has run.
  void _bumpRank(Fixture f, int home, int away, int hs, int as) {
    final pts = _rankPoints;
    if (pts == null) return;
    final hp = pts[home] ?? Elo.base;
    final ap = pts[away] ?? Elo.base;
    final weight =
        (_isKnockout(f) || f.round == 'GROUP') ? Elo.finals : Elo.qualifier;
    final delta = Elo.homeDelta(
      homePoints: hp,
      awayPoints: ap,
      homeScore: hs,
      awayScore: as,
      weight: weight,
    );
    pts[home] = hp + delta;
    pts[away] = ap - delta;
  }

  /// Persists the in-memory ranking points for [careerId].
  Future<void> _flushRank(int careerId) async {
    final pts = _rankPoints;
    if (pts != null && _rankCareer == careerId) {
      await _ref.read(rankingRepositoryProvider).save(careerId, pts);
    }
  }

  /// World positions (1 = top) from the live points held in memory, tie-broken
  /// by the static seed order. Used to freeze a cycle's seeding ranking.
  Map<int, int> _liveRankById(Map<int, Nation> nations) {
    final pts = _rankPoints ??
        {for (final n in nations.values) n.id: Elo.seedFromRanking(n.ranking)};
    final seedRank = {for (final n in nations.values) n.id: n.ranking};
    return Elo.positions(pts, seedRankById: seedRank);
  }

  /// Ensures the [host] is in the finals field (it qualifies automatically),
  /// taking the last/weakest qualifier's place if it isn't already there.
  List<int> _withHost(List<int> field, int host) {
    if (field.isEmpty || field.contains(host)) return field;
    return [...field.take(field.length - 1), host];
  }

  /// The frozen seeding ranking for [cycle] (nationId → position), falling back
  /// to the static seed ranking when the cycle was never snapshotted.
  Future<Map<int, int>> _seedRankById(
    int careerId,
    int cycle,
    Map<int, Nation> nations,
  ) async {
    final snap = await _ref
        .read(seedRankingRepositoryProvider)
        .forCycle(careerId, cycle);
    if (snap.isNotEmpty) return snap;
    return {for (final n in nations.values) n.id: n.ranking};
  }

  /// Whether a fixture is a knockout tie (so a level score is settled by a
  /// shootout). Group and qualifying rounds are never knockouts — note the
  /// continental group round is `CGROUP`, which must not be mistaken for one.
  static bool _isKnockout(Fixture f) {
    final r = f.round;
    if (r == null) return false;
    const knockoutSuffixes = ['R32', 'R16', 'QF', 'SF', '3RD', 'FINAL'];
    return knockoutSuffixes.any(r.endsWith);
  }

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
    _bumpRank(f, f.homeNationId, f.awayNationId, hs, as);
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

  /// Simulates everything due by [upTo] and keeps spawning + playing the next
  /// tournament stages until nothing more is due. Without this a tournament
  /// whose window has already passed (e.g. the continental cup once World Cup
  /// qualifying begins) trickles out one knockout round per call and lags —
  /// this fully resolves it so its champion is known on time.
  Future<void> _catchUp(int careerId, DateTime upTo, int rngSeed) async {
    for (var pass = 0; pass < 40; pass++) {
      await _simDue(careerId, upTo, rngSeed);
      await _progress(careerId);
      if ((await _comp.unplayedDueBy(careerId, upTo)).isEmpty) break;
    }
  }

  /// Quick-sims the world to the player's next match, or — if the player has
  /// no fixture — fast-forwards through the rest of the cycle (other regions'
  /// qualifiers, the finals draw, and the knockout) to the champion.
  Future<void> advance(int careerId) async {
    await _ensureRank(careerId);
    while (true) {
      final career = await _careers.byId(careerId);
      if (career == null) break;
      _simCycle = career.cyclePointer;

      final next = await _comp.nextFixtureForNation(
        careerId,
        career.nationId,
        career.inGameDate,
      );
      if (next != null) {
        await _careers.updateInGameDate(careerId, next.date);
        await _catchUp(careerId, next.date, career.rngSeed);
        break;
      }

      // Player idle: spawn the next stage if due, then sim one world matchday.
      await _progress(careerId);
      final earliest = await _comp.earliestUnplayedDate(
        careerId,
        career.inGameDate,
      );
      if (earliest == null) break; // cycle complete
      await _careers.updateInGameDate(careerId, earliest);
      await _catchUp(careerId, earliest, career.rngSeed);

      // While the World Cup finals are being contested, surface each matchday
      // to the player — a non-qualifier (or a knocked-out nation) can then
      // follow the tournament instead of it fast-forwarding to the champion.
      if (await _comp.hasFinals(careerId) &&
          await _comp.worldChampion(careerId) == null) {
        break;
      }
    }
    await _flushRank(careerId);
    _ref.invalidate(hubDataProvider);
  }

  /// Fast-forwards straight to the World Cup champion — the "skip to the final"
  /// option when the player is watching the finals rather than playing them.
  Future<void> skipToChampion(int careerId) async {
    await _ensureRank(careerId);
    for (var i = 0; i < 300; i++) {
      final career = await _careers.byId(careerId);
      if (career == null) break;
      _simCycle = career.cyclePointer;
      if (await _comp.worldChampion(careerId) != null) break;
      final earliest = await _comp.earliestUnplayedDate(
        careerId,
        career.inGameDate,
      );
      if (earliest == null) break;
      await _careers.updateInGameDate(careerId, earliest);
      await _catchUp(careerId, earliest, career.rngSeed);
    }
    await _flushRank(careerId);
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
    _simCycle = career.cyclePointer;
    await _ensureRank(careerId);

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
    _bumpRank(fixture, fixture.homeNationId, fixture.awayNationId, hs, as);
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

    // Update the squad's suspensions and injuries from this match's cards and
    // knocks (players who sat this one out have now served a game).
    final absenceRepo = _ref.read(absenceRepositoryProvider);
    final before = await absenceRepo.forCareer(careerId);
    final after = Discipline.applyMatch(
      before: before,
      events: result.events,
      nationId: career.nationId,
      rng: SeededRng.forFixture(career.rngSeed, fixture.id ^ 0x0AB5),
    );
    await absenceRepo.replace(careerId, after.values);

    await _careers.updateInGameDate(careerId, fixture.date);
    await _catchUp(careerId, fixture.date, career.rngSeed);
    await _flushRank(careerId);
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

    // Round of 32 (after the 12-group stage): 24 group qualifiers + 8 thirds.
    if ((await _comp.fixturesByRound(careerId, WorldCupFinals.r32)).isEmpty) {
      if (await _roundComplete(careerId, 'GROUP')) {
        final tables = await _comp.finalsGroupTables(careerId);
        final pairings = WorldCupFinals.roundOf32(
          tables.map((t) => t.standings).toList(),
        );
        await _comp.addKnockoutFixtures(
          careerId: careerId,
          round: WorldCupFinals.r32,
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
    const kind = CompetitionKind.continentalFinals;
    if (!await _comp.hasTournament(careerId, kind)) {
      // Once continental qualifying is complete, draw the finals from the
      // qualifiers (the finals didn't exist yet for the qualifying path).
      if (await _comp.hasTournament(
            careerId,
            CompetitionKind.continentalQualifying,
          ) &&
          await _comp.allPlayedForKind(
            careerId,
            CompetitionKind.continentalQualifying,
          )) {
        await _generateContinentalFinals(careerId);
      }
      return;
    }

    // Group stage → first knockout round, once every group game is played. The
    // round depends on how many teams advance: a 24-team cup (6 groups) sends
    // the top two plus the four best third-placed teams into a round of 16; a
    // 16-team cup (4 groups) opens at the quarter-finals; an 8-team cup (2
    // groups) at the semi-finals.
    final tables = await _comp.tournamentGroupTables(careerId, kind);
    if (tables.isNotEmpty) {
      final standings = tables.map((t) => t.standings).toList();
      final bestThirds = WorldCupFinals.bestThirdsFor(tables.length);
      final firstRound = switch (tables.length) {
        6 => 'CR16',
        4 => 'CQF',
        _ => 'CSF',
      };
      final started =
          (await _comp.fixturesByRound(careerId, firstRound, kind: kind))
              .isNotEmpty;
      if (!started) {
        if (!await _roundComplete(careerId, 'CGROUP', kind: kind)) return;
        await _comp.addKnockoutFixtures(
          careerId: careerId,
          round: firstRound,
          kind: kind,
          pairings: bestThirds > 0
              ? WorldCupFinals.knockoutWithThirds(standings, bestThirds)
              : WorldCupFinals.knockoutFromGroups(standings),
          date: (await _maxDate(careerId, 'CGROUP', kind: kind)).add(
            const Duration(days: 7),
          ),
        );
        return;
      }
    }

    await _advanceTournamentKnockout(careerId, kind, prefix: 'C');
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
    final r32 = '${prefix}R32';
    final r16 = '${prefix}R16';
    final qf = '${prefix}QF';
    final sf = '${prefix}SF';
    final third = '${prefix}3RD';
    final fin = '${prefix}FINAL';

    // The R32 step is a no-op for brackets that start later (continental cups
    // open at the quarter- or semi-finals — their R32 round never exists).
    await _advanceRound(careerId, r32, r16, 4, kind: kind);
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

  /// Draws the continental finals (a group stage) from the teams that came
  /// through continental qualifying, mirroring the World Cup finals draw.
  Future<void> _generateContinentalFinals(int careerId) async {
    final career = await _careers.byId(careerId);
    if (career == null) return;
    final nations = await _nationsById();
    final conf = nations[career.nationId]?.confederation;
    final cont = conf == null
        ? null
        : ContinentalCups.byConfederation[conf];
    if (conf == null || cont == null) return;

    final tables = await _comp.tournamentGroupTables(
      careerId,
      CompetitionKind.continentalQualifying,
    );
    final qualifiers = Qualification.qualifiers(
      tables.map((t) => t.standings).toList(),
      cont.size,
    );
    if (qualifiers.length < cont.size) return;

    // The host qualifies automatically and is seeded into Group A.
    final host = WorldCupHosts.continentalHostFor(
      confederation: conf,
      cycle: career.cyclePointer,
      seed: career.rngSeed,
      nations: nations.values.toList(),
    );
    final field = _withHost(qualifiers, host);

    final wcYear = CareerService.worldCupYear(career.cyclePointer);
    final draw = WorldCupFinals.drawGroups(
      qualifierIds: field,
      rankingById: await _seedRankById(careerId, career.cyclePointer, nations),
      rngSeed: career.rngSeed ^ (career.cyclePointer * 0x71) ^ 0xC0FF,
      host: host,
    );
    await _comp.saveTournamentGroups(
      careerId: careerId,
      cycle: career.cyclePointer,
      confederation: conf,
      kind: CompetitionKind.continentalFinals,
      name: cont.name,
      draw: draw,
      groupStart: DateTime(wcYear - 2, cont.month, 8),
      round: 'CGROUP',
    );
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
      hostId: WorldCupHosts.continentalHostFor(
        confederation: conf,
        cycle: career.cyclePointer,
        seed: career.rngSeed,
        nations: nations.values.toList(),
      ),
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

    final nations = await _nationsById();
    final rankingById =
        await _seedRankById(careerId, career.cyclePointer, nations);
    final year = finalsYear(career.cyclePointer);

    // The host qualifies automatically. Finalist selection (direct berths +
    // intercontinental playoff + host swap) is shared with the draw ceremony.
    final host = WorldCupHosts.hostFor(
      year: year,
      nations: nations.values.toList(),
      seed: career.rngSeed,
    );
    final qualifiers = WorldCupFinals.selectFinalists(
      byConfederation: grouped,
      rankingById: rankingById,
      host: host,
    );

    final draw = WorldCupFinals.drawGroups(
      qualifierIds: qualifiers,
      rankingById: rankingById,
      rngSeed: career.rngSeed ^ (career.cyclePointer * 0x2D31),
      host: host,
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

    await _careers.advanceCycle(careerId, nextCycle, nextStart);

    // Freeze the current standings as the seeding ranking for the new cycle, so
    // its draws reflect how nations have actually performed — and stay in step
    // with the draw ceremonies no matter when they are viewed.
    await _ensureRank(careerId);
    final nations = await _nationsById();
    final seedRank = _liveRankById(nations);
    await _ref
        .read(seedRankingRepositoryProvider)
        .snapshot(careerId, nextCycle, seedRank);

    // Build the whole next cycle in real-world order (continental qualifying →
    // continental finals → World Cup qualifying → World Cup finals) plus
    // friendlies, mirroring a fresh save.
    await CareerService.buildCalendar(
      comp: _comp,
      nations: nations.values.toList(),
      careerId: careerId,
      nationId: career.nationId,
      rngSeed: career.rngSeed,
      cycle: nextCycle,
      cycleStart: nextStart,
      wcYear: finalsYear(nextCycle),
      rankById: seedRank,
    );

    _ref.invalidate(hubDataProvider);
  }
}

final Provider<SeasonService> seasonServiceProvider = Provider(
  SeasonService.new,
);
