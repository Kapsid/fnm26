import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/repositories/career_repository.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/competition/group_advancement.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/domain/services/competition/nations_cup.dart';
import 'package:fnm/domain/services/competition/qualification.dart';
import 'package:fnm/domain/services/competition/rounds.dart';
import 'package:fnm/domain/services/competition/tournament_sim.dart';
import 'package:fnm/domain/services/federation/federation_finance.dart';
import 'package:fnm/domain/services/match/goal_attribution.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_simulator.dart';
import 'package:fnm/domain/services/player/discipline.dart';
import 'package:fnm/domain/services/ranking/elo.dart';
import 'package:fnm/domain/services/tactics/best_eleven.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/federation_service.dart';
import 'package:fnm/features/hub/draw_reveal.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';

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
    this.nextDrawWatched = true,
    this.groupDrawWatched = true,
    this.groupDirectCount = 2,
    this.groupContentionPos,
    this.groupRelegateCount = 0,
    this.groupCaption = '',
  });

  final Career career;
  final GroupTable? group;

  /// Whether the draw for [next]'s competition has been watched — the opponent
  /// (next-match card) stays hidden until it has.
  final bool nextDrawWatched;

  /// Whether the draw for [group]'s competition has been watched — the group
  /// table stays "to be drawn" until it has.
  final bool groupDrawWatched;

  /// How many positions in [group] advance outright (green) and the single
  /// "in contention" position (amber best-third / play-off), if any.
  final int groupDirectCount;
  final int? groupContentionPos;

  /// How many bottom places in [group] are relegated (red) — the Nations Cup
  /// drops each group's last side a league.
  final int groupRelegateCount;

  /// A plain-English note on what the group's zones mean (who qualifies /
  /// relegates), shown under the table so the colours aren't left to guess.
  final String groupCaption;

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

// Auto-disposed so it recomputes fresh whenever the hub is re-entered (e.g.
// after watching a draw), rather than serving a stale cached snapshot.
final AutoDisposeFutureProviderFamily<HubData?, int> hubDataProvider =
    FutureProvider.autoDispose.family<HubData?, int>((ref, careerId) async {
  await ref.watch(seedLoaderProvider).ensureSeeded();
  final careerRepo = ref.watch(careerRepositoryProvider);
  final compRepo = ref.watch(competitionRepositoryProvider);

  final career = await careerRepo.byId(careerId);
  if (career == null) return null;

  final group = await compRepo.groupTableForNation(careerId, career.nationId);
  final next = await compRepo.nextFixtureForNation(careerId, career.nationId);
  final fixtures = await compRepo.fixturesForNation(careerId, career.nationId);
  final nations = {
    for (final n in await ref.watch(nationRepositoryProvider).all()) n.id: n,
  };
  final squad = await ref
      .watch(playerRepositoryProvider)
      .byNation(
        career.nationId,
        agingYears: CareerService.agingYears(career),
        saveSeed: career.rngSeed,
      );
  final squadRating = squad.isEmpty
      ? 0
      : (squad.fold<int>(0, (s, p) => s + p.overall) / squad.length).round();

  final champion = await compRepo.worldChampion(careerId);
  final hasFinals = await compRepo.hasFinals(careerId);

  // Whether the draw for the next fixture's competition has been watched — the
  // opponent and group table stay hidden until it has. Computed here (not in a
  // separate provider) so it's always refreshed with the rest of the hub data.
  var nextDrawWatched = true;
  if (next != null) {
    final kind = drawKindForFixture(next);
    if (kind != null) {
      nextDrawWatched =
          await compRepo.hasWatchedDraw(careerId, career.cyclePointer, kind);
    }
  }

  // The advancing (green) and in-contention (amber) positions for the shown
  // group, from its competition's exact format — plus whether that group's own
  // draw has been watched (the table stays hidden until it has).
  var groupDirect = 2;
  int? groupContention;
  var groupRelegate = 0;
  var groupCaption = '';
  var groupDrawWatched = true;
  if (group != null) {
    final conf =
        nations[career.nationId]?.confederation ?? Confederation.europe;
    final size = ContinentalCups.byConfederation[conf]?.size ?? 24;
    // The Nations Cup relegates every group's bottom side except in the lowest
    // league, which has nowhere to fall.
    var isLowestLeague = false;
    if (group.kind == CompetitionKind.nationsLeague) {
      final tiers = await ref
          .watch(careerRepositoryProvider)
          .nationsCupTiers(careerId);
      isLowestLeague = NationsCup.isLowestLeague(
        groupName: group.name,
        tiers: tiers,
        confederation: conf,
        confederationOf: (id) => nations[id]?.confederation,
      );
    }
    final adv = GroupAdvancement.forGroup(
      kind: group.kind,
      confederation: conf,
      groupCount: group.groupCount,
      continentalSize: size,
      isLowestLeague: isLowestLeague,
    );
    groupDirect = adv.direct;
    groupContention = adv.contention;
    groupRelegate = adv.relegate;
    groupCaption = GroupAdvancement.caption(kind: group.kind, adv: adv);
    final gk = groupDrawKind(group.kind);
    if (gk != null) {
      groupDrawWatched =
          await compRepo.hasWatchedDraw(careerId, career.cyclePointer, gk);
    }
  }

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
    nextDrawWatched: nextDrawWatched,
    groupDrawWatched: groupDrawWatched,
    groupDirectCount: groupDirect,
    groupContentionPos: groupContention,
    groupRelegateCount: groupRelegate,
    groupCaption: groupCaption,
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
  int _simSeed = 0;
  int _simYears = 0;

  Future<Map<int, Nation>> _nationsById() async => {
    for (final n in await _ref.read(nationRepositoryProvider).all()) n.id: n,
  };

  Future<List<Player>> _pool(int nationId) async =>
      _poolCache[(nationId, _simYears)] ??= await _ref
          .read(playerRepositoryProvider)
          .byNation(nationId, agingYears: _simYears, saveSeed: _simSeed);

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
    final weight = Elo.weightForRound(f.round);
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

  /// Persists the in-memory ranking points for [careerId], and republishes the
  /// ranking if a new month of in-game time has begun.
  Future<void> _flushRank(int careerId) async {
    final pts = _rankPoints;
    if (pts != null && _rankCareer == careerId) {
      await _ref.read(rankingRepositoryProvider).save(careerId, pts);
      await _publishRankingIfDue(careerId);
    }
  }

  /// Publishes a world-ranking release at most once per calendar month of
  /// in-game time, mirroring how the real ranking works: results accumulate
  /// through an international window, then the table is republished.
  ///
  /// Points move with every result, but a message per result would be noise.
  Future<void> _publishRankingIfDue(int careerId) async {
    final career = await _careers.byId(careerId);
    if (career == null) return;
    final releases = _ref.read(rankingReleaseRepositoryProvider);
    final last = await releases.latest(careerId);
    final now = career.inGameDate;
    if (last != null &&
        last.publishedOn.year == now.year &&
        last.publishedOn.month == now.month) {
      return;
    }
    final nations = await _nationsById();
    final positions = _liveRankById(nations);
    final playerRank = positions[career.nationId];
    if (playerRank == null) return;
    final leader = positions.entries
        .where((e) => e.value == 1)
        .map((e) => e.key)
        .firstOrNull;
    if (leader == null) return;
    await releases.add(
      careerId: careerId,
      publishedOn: now,
      // Stamped with the cycle and nation this release describes, so its
      // movement is measured against the right baseline even after the manager
      // changes job.
      cycle: career.cyclePointer,
      nationId: career.nationId,
      playerRank: playerRank,
      leaderNationId: leader,
    );
  }

  /// World positions (1 = top) from the live points held in memory, tie-broken
  /// by the static seed order. Used to freeze a cycle's seeding ranking.
  Map<int, int> _liveRankById(Map<int, Nation> nations) {
    final pts = _rankPoints ??
        {for (final n in nations.values) n.id: Elo.seedFromRanking(n.ranking)};
    final seedRank = {for (final n in nations.values) n.id: n.ranking};
    return Elo.positions(pts, seedRankById: seedRank);
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
  static bool _isKnockout(Fixture f) => Rounds.isKnockout(f.round);

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
        homeStrength: RatingMatchSimulator.strengthOf(home).toDouble(),
        awayStrength: RatingMatchSimulator.strengthOf(away).toDouble(),
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
    // Attribute to the players who actually take the field, not the whole
    // 100-man pool — otherwise goals scatter across every fringe player and no
    // striker ever builds a tally. The best XI concentrates goals on the front
    // line, matching the detailed engine's behaviour.
    final xiIds = bestEleven(Formation.f433, pool).whereType<int>().toSet();
    final xi = pool.where((p) => xiIds.contains(p.id)).toList();
    final rng = SeededRng.forFixture(rngSeed, f.id ^ salt);
    final ids = GoalAttribution.scorers(
      pool: xi.isEmpty ? pool : xi,
      goals: goals,
      rng: rng,
    );
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

  Future<void> _simDue(
    int careerId,
    DateTime upTo,
    int rngSeed, {
    int? excludeNationId,
  }) async {
    final due = await _comp.unplayedDueBy(
      careerId,
      upTo,
      excludeNationId: excludeNationId,
    );
    final nations = await _nationsById();
    for (final f in due) {
      await _simAndRecord(f, nations, rngSeed);
    }
  }

  /// Simulates everything due by [upTo] and keeps spawning + playing the next
  /// tournament stages until nothing more is due. When [excludeNationId] is
  /// given (playing a match — see [playPlayerMatch]) that nation's own fixtures
  /// are never auto-simulated, so playing one match can't silently skip the
  /// manager's other competitive matches (even lazily-generated finals that
  /// land before [upTo]); they wait to be played. When it is null (an explicit
  /// quick-sim/skip) everything due is played. Without this loop a tournament
  /// whose window has already passed (e.g. the continental cup once World Cup
  /// qualifying begins) trickles out one knockout round per call and lags —
  /// this fully resolves it so its champion is known on time.
  Future<void> _catchUp(
    int careerId,
    DateTime upTo,
    int rngSeed, {
    int? excludeNationId,
  }) async {
    // Batch every write from this catch-up (all leagues' Nations Cup matches,
    // qualifiers, finals, goals) into ONE commit — the per-statement fsync is
    // what made a busy window feel slow, not the simulation itself.
    await _comp.transact(() async {
      for (var pass = 0; pass < 40; pass++) {
        await _simDue(
          careerId,
          upTo,
          rngSeed,
          excludeNationId: excludeNationId,
        );
        await _progress(careerId);
        final remaining = await _comp.unplayedDueBy(
          careerId,
          upTo,
          excludeNationId: excludeNationId,
        );
        if (remaining.isEmpty) break;
      }
    });
  }

  /// Quick-sims the world to the player's next match, or — if the player has
  /// no fixture — fast-forwards through the rest of the cycle (other regions'
  /// qualifiers, the finals draw, and the knockout) to the champion.
  Future<void> advance(int careerId) async {
    await _ensureRank(careerId);
    while (true) {
      final career = await _careers.byId(careerId);
      if (career == null) break;
    _simSeed = career.rngSeed;
    _simYears = CareerService.agingYears(career);

      // Spawn any due stage/finals first, so the tournament to step exists.
      await _progress(careerId);

      final next = await _comp.nextFixtureForNation(
        careerId,
        career.nationId,
      );
      final nextIsFinals = next != null && _isFinalsMatch(next);
      final finalsDate = await _comp.earliestUnplayedFinalsDate(careerId);

      // 1. A live finals the player isn't in, due before their next fixture:
      //    step it ONE matchday and hand back so they watch the results. This
      //    is what lets a non-qualifier or knocked-out nation follow the whole
      //    tournament, day by day, instead of it fast-forwarding.
      if (finalsDate != null &&
          !nextIsFinals &&
          (next == null || !finalsDate.isAfter(next.date))) {
        await _careers.updateInGameDate(careerId, finalsDate);
        await _catchUp(
          careerId,
          finalsDate,
          career.rngSeed,
          excludeNationId: career.nationId,
        );
        break;
      }

      // 1b. The Nations Cup Finals Four is under way and the player isn't in it
      //     — step it one matchday at a time, like the main finals, so the
      //     semis and final are watched rather than silently fast-forwarded.
      final ncFinalsDate =
          await _comp.earliestUnplayedNationsCupFinalsDate(careerId);
      final nextIsNcFinals =
          next != null && (next.round == 'NSF' || next.round == 'NFINAL');
      if (ncFinalsDate != null &&
          !nextIsNcFinals &&
          (next == null || !ncFinalsDate.isAfter(next.date))) {
        await _careers.updateInGameDate(careerId, ncFinalsDate);
        await _catchUp(
          careerId,
          ncFinalsDate,
          career.rngSeed,
          excludeNationId: career.nationId,
        );
        break;
      }

      // 2. The player's next fixture (a finals match they contest, or their
      //    next competition) — advance up to it and hand back to play it.
      if (next != null) {
        await _careers.updateInGameDate(careerId, next.date);
        await _catchUp(careerId, next.date, career.rngSeed);
        break;
      }

      // 3. Player idle with no finals to step: sim one world matchday.
      final earliest = await _comp.earliestUnplayedDate(
        careerId,
        career.inGameDate,
      );
      if (earliest == null) break; // cycle complete
      await _careers.updateInGameDate(careerId, earliest);
      await _catchUp(careerId, earliest, career.rngSeed);
      final wcFinalsLive = await _comp.hasFinals(careerId) &&
          await _comp.worldChampion(careerId) == null;
      if (wcFinalsLive || await _comp.hasLiveContinentalFinals(careerId)) {
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
    _simSeed = career.rngSeed;
    _simYears = CareerService.agingYears(career);
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
    _simSeed = career.rngSeed;
    _simYears = CareerService.agingYears(career);
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

    // Notify the manager of new suspensions and knocks from this match, so a
    // ban or injury never comes as a silent surprise next selection.
    final discYear = fixture.date.year;
    for (final e in result.events) {
      if (e.teamNationId != career.nationId) continue;
      if (e.type == MatchEventType.redCard) {
        await _comp.addMessage(
          careerId: careerId,
          dedupKey: 'ban:${fixture.id}:${e.playerId}',
          category: 'discipline',
          title: '${e.playerName} suspended',
          body: '${e.playerName} was sent off and is banned for your next '
              'match — they will be unavailable for selection.',
          year: discYear,
        );
      } else if (e.type == MatchEventType.injury) {
        final out = after[e.playerId]?.injuryMatches ?? 1;
        await _comp.addMessage(
          careerId: careerId,
          dedupKey: 'inj:${fixture.id}:${e.playerId}',
          category: 'injury',
          title: '${e.playerName} injured',
          body: '${e.playerName} picked up a knock and is out for '
              '$out match${out == 1 ? '' : 'es'}.',
          year: discYear,
        );
      }
    }

    // Persist every player's full stat line for this fixture (both teams),
    // powering match history, career aggregates and all-time records.
    final goalsBy = <int, int>{};
    final assistsBy = <int, int>{};
    final yellowsBy = <int, int>{};
    final redsBy = <int, int>{};
    for (final e in result.events) {
      switch (e.type) {
        case MatchEventType.goal:
          goalsBy.update(e.playerId, (v) => v + 1, ifAbsent: () => 1);
          final a = e.assistPlayerId;
          if (a != null) {
            assistsBy.update(a, (v) => v + 1, ifAbsent: () => 1);
          }
        case MatchEventType.yellowCard:
          yellowsBy.update(e.playerId, (v) => v + 1, ifAbsent: () => 1);
        case MatchEventType.redCard:
          redsBy.update(e.playerId, (v) => v + 1, ifAbsent: () => 1);
        case MatchEventType.substitution:
        case MatchEventType.injury:
          break;
      }
    }
    final motmId = result.manOfTheMatch?.playerId;
    await _comp.recordPlayerMatchStats(
      careerId,
      fixture.id,
      result.ratings.map((r) {
        final conceded = r.teamNationId == fixture.homeNationId
            ? result.awayScore
            : result.homeScore;
        return (
          playerId: r.playerId,
          nationId: r.teamNationId,
          rating: r.rating,
          goals: goalsBy[r.playerId] ?? 0,
          assists: assistsBy[r.playerId] ?? 0,
          cleanSheet: conceded == 0,
          motm: r.playerId == motmId,
          yellows: yellowsBy[r.playerId] ?? 0,
          reds: redsBy[r.playerId] ?? 0,
        );
      }),
    );
    await _comp.recordTeamStats(
      careerId,
      fixture.id,
      homeShots: result.homeShots,
      awayShots: result.awayShots,
      homePossession: result.homePossession,
    );

    // Log caps for the manager's players who featured (started or came on), for
    // the "most games played" team record.
    await _comp.recordAppearances(
      careerId,
      career.nationId,
      result.ratings
          .where((r) => r.teamNationId == career.nationId)
          .map((r) => r.playerId),
    );

    await _careers.updateInGameDate(careerId, fixture.date);
    // Sim the rest of the world up to this date, but never the manager's own
    // other fixtures — playing one match must not silently skip another (e.g. a
    // friendly must not sweep away a continental finals match in the same
    // window). Those wait to be played next.
    await _catchUp(
      careerId,
      fixture.date,
      career.rngSeed,
      excludeNationId: career.nationId,
    );
    await _flushRank(careerId);
    _ref.invalidate(hubDataProvider);
  }

  // --- Cycle progression ----------------------------------------------------

  /// Rounds that belong to the main finals tournaments (World Cup + continental
  /// championship) — the ones the player steps through even when not in them.
  static const _finalsMatchRounds = {
    'GROUP', 'R32', 'R16', 'QF', 'SF', '3RD', 'FINAL',
    'CGROUP', 'CR16', 'CQF', 'CSF', 'C3RD', 'CFINAL',
  };

  static bool _isFinalsMatch(Fixture f) =>
      f.round != null && _finalsMatchRounds.contains(f.round);

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
    await _progressNationsLeague(careerId);
    await _progressFinalissima(careerId);
  }

  static int _rankStandings(GroupStanding a, GroupStanding b) {
    final byPoints = b.points.compareTo(a.points);
    if (byPoints != 0) return byPoints;
    final byGd = b.goalDifference.compareTo(a.goalDifference);
    if (byGd != 0) return byGd;
    return b.goalsFor.compareTo(a.goalsFor);
  }

  /// Progresses the Nations Cup: once the groups are done, the four group
  /// winners contest a Finals Four (two semi-finals then a final); the final's
  /// winner takes the title. Leagues with fewer than four groups fall back to a
  /// single decider (or crown a lone winner outright).
  Future<void> _progressNationsLeague(int careerId) async {
    const kind = CompetitionKind.nationsLeague;
    if (!await _comp.hasTournament(careerId, kind)) return;

    final finalFx = await _comp.fixturesByRound(careerId, 'NFINAL', kind: kind);
    final semiFx = await _comp.fixturesByRound(careerId, 'NSF', kind: kind);

    // Stage 1 — groups done: seed the Finals Four from the group winners.
    if (finalFx.isEmpty && semiFx.isEmpty) {
      if (!await _roundComplete(careerId, 'NGROUP', kind: kind)) return;
      final tables = await _comp.tournamentGroupTables(careerId, kind);
      // The title is contested by League A (tier 0) — its group winners meet in
      // the Finals Four.
      final winners = [
        for (final t in tables)
          if (t.standings.isNotEmpty &&
              NationsCup.tierOfGroupName(t.name) == 0)
            t.standings.first,
      ]..sort(_rankStandings);
      if (winners.isEmpty) return;
      if (winners.length < 2) {
        await _recordNationsLeagueHonour(
          careerId,
          winners.first.nationId,
          null,
        );
        return;
      }
      // The Finals Four takes the real Nations League slot: the June window of
      // the year after the autumn group stage — the season before the World
      // Cup, so the whole Nations Cup is settled before the finals begin.
      // Days 18/21 sit clear of that window's qualifying matchdays.
      final career = await _careers.byId(careerId);
      if (career == null) return;
      final scheduled = DateTime(finalsYear(career.cyclePointer) - 1, 6, 18);
      final date = scheduled.isAfter(career.inGameDate)
          ? scheduled
          : career.inGameDate.add(const Duration(days: 14));
      if (winners.length < 4) {
        // Too few group winners for a Finals Four — a single decider.
        await _comp.addKnockoutFixtures(
          careerId: careerId,
          round: 'NFINAL',
          kind: kind,
          pairings: [(winners[0].nationId, winners[1].nationId)],
          date: date,
        );
        return;
      }
      // Semi-finals: top seed v fourth, second v third.
      await _comp.addKnockoutFixtures(
        careerId: careerId,
        round: 'NSF',
        kind: kind,
        pairings: [
          (winners[0].nationId, winners[3].nationId),
          (winners[1].nationId, winners[2].nationId),
        ],
        date: date,
      );
      return;
    }

    // Stage 2 — both semis played: the winners meet in the final.
    if (finalFx.isEmpty) {
      if (semiFx.length < 2 || !semiFx.every((f) => f.hasResult)) return;
      await _comp.addKnockoutFixtures(
        careerId: careerId,
        round: 'NFINAL',
        kind: kind,
        pairings: [(_winner(semiFx[0]), _winner(semiFx[1]))],
        date: (await _maxDate(careerId, 'NSF', kind: kind))
            .add(const Duration(days: 3)),
      );
      return;
    }

    final f = finalFx.first;
    if (!f.hasResult) return;
    await _recordNationsLeagueHonour(careerId, _winner(f), _loser(f));
  }

  Future<void> _recordNationsLeagueHonour(
    int careerId,
    int champion,
    int? runnerUp,
  ) async {
    final career = await _careers.byId(careerId);
    if (career == null) return;
    final year = finalsYear(career.cyclePointer) - 2;
    if (await _comp.hasHonour(careerId, 'Nations Cup', year)) return;
    await _comp.recordHonour(
      careerId: careerId,
      year: year,
      competition: 'Nations Cup',
      championId: champion,
      runnerUpId: runnerUp ?? champion,
    );
  }

  /// Creates and resolves the Finalissima: a one-off match between the
  /// European and South American champions of the cycle.
  Future<void> _progressFinalissima(int careerId) async {
    const kind = CompetitionKind.finalissima;
    final career = await _careers.byId(careerId);
    if (career == null) return;
    final year = finalsYear(career.cyclePointer) - 2;
    if (await _comp.hasHonour(careerId, 'Continental Clash', year)) return;

    final existing =
        await _comp.fixturesByRound(careerId, 'FFINAL', kind: kind);
    if (existing.isEmpty) {
      final honours = await _comp.honours(careerId);
      int? euro;
      int? copa;
      for (final h in honours) {
        if (h.year != year) continue;
        if (h.competition == 'European Championship') euro = h.championId;
        if (h.competition == 'South America Cup') copa = h.championId;
      }
      if (euro == null || copa == null) return;
      await _comp.saveTournamentGroups(
        careerId: careerId,
        cycle: career.cyclePointer,
        confederation: Confederation.europe,
        kind: kind,
        name: 'Continental Clash',
        draw: FinalsDraw(
          groups: [
            FinalsGroupDraw(
              name: 'F',
              nationIds: [euro, copa],
              fixtures: [(1, euro, copa)],
            ),
          ],
        ),
        groupStart: DateTime(year, 8, 15),
        round: 'FFINAL',
      );
      return;
    }
    final f = existing.first;
    if (!f.hasResult) return;
    await _comp.recordHonour(
      careerId: careerId,
      year: year,
      competition: 'Continental Clash',
      championId: _winner(f),
      runnerUpId: _loser(f),
    );
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
      final afterSemis = await _maxDate(careerId, sf, kind: kind);
      // The play-off comes first and the final closes the tournament, on their
      // own days — sharing one date collapsed them into a single round popup
      // titled after the play-off, so the final was never its own moment.
      final thirdDate = afterSemis.add(const Duration(days: 5));
      final finalDate = afterSemis.add(const Duration(days: 7));
      await _comp.addKnockoutFixtures(
        careerId: careerId,
        round: third,
        kind: kind,
        pairings: WorldCupFinals.pairWinners(semis.map(_loser).toList()),
        date: thirdDate,
      );
      await _comp.addKnockoutFixtures(
        careerId: careerId,
        round: fin,
        kind: kind,
        pairings: WorldCupFinals.pairWinners(semis.map(_winner).toList()),
        date: finalDate,
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

    // The hosts qualify automatically and reserve their berths, so only
    // (size − hosts) teams come through qualifying — a host does NOT bump the
    // last third-placed qualifier out.
    final hosts = WorldCupHosts.continentalHostsFor(
      confederation: conf,
      cycle: career.cyclePointer,
      seed: career.rngSeed,
      nations: nations.values.toList(),
    );
    final berths = (cont.size - hosts.length).clamp(1, cont.size);
    final tables = await _comp.tournamentGroupTables(
      careerId,
      CompetitionKind.continentalQualifying,
    );
    final qualifiers = Qualification.qualifiers(
      tables.map((t) => t.standings).toList(),
      berths,
    );
    if (qualifiers.length < berths) return;

    final field = [
      ...qualifiers,
      for (final h in hosts)
        if (!qualifiers.contains(h)) h,
    ].take(cont.size).toList();

    final wcYear = CareerService.worldCupYear(career.cyclePointer);
    final draw = WorldCupFinals.drawGroups(
      qualifierIds: field,
      rankingById: await _seedRankById(careerId, career.cyclePointer, nations),
      rngSeed: career.rngSeed ^ (career.cyclePointer * 0x71) ^ 0xC0FF,
      hosts: hosts,
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
              .byId(boot.first.playerId, saveSeed: _simSeed))
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

    // Every other confederation's championship is decided in the same window,
    // so record them now rather than two years later after the World Cup.
    await _simulateContinentalCups(careerId, year + 2);
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
            saveSeed: _simSeed,
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

      // No message is filed here: every cup result is announced from its
      // honour row by the message service, which reads the scoreline recorded
      // just above. Announcing it here too filed each background cup's title
      // twice.
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

    // The hosts (primary + any co-hosts) qualify automatically. Finalist
    // selection is shared with the draw ceremony.
    final hosts = WorldCupHosts.hostsFor(
      year: year,
      nations: nations.values.toList(),
      seed: career.rngSeed,
    );
    final qualifiers = WorldCupFinals.selectFinalists(
      byConfederation: grouped,
      rankingById: rankingById,
      hosts: hosts,
      playoffRng: SeededRng(
        career.rngSeed ^ (career.cyclePointer * 0x50FF) ^ 0xB1A0,
      ),
    );

    final draw = WorldCupFinals.drawGroups(
      qualifierIds: qualifiers,
      rankingById: rankingById,
      rngSeed: career.rngSeed ^ (career.cyclePointer * 0x2D31),
      hosts: hosts,
    );
    if (draw.groups.isEmpty) return;

    // The finals open in June of the World Cup year — but never in the past.
    // The draw waits on the slowest confederation's qualifying, so if that
    // ever overruns June the tournament would be created already-due and
    // _catchUp would resolve every round in one pass (crowning a champion with
    // nothing to watch). Anchoring to the in-game date keeps it step-by-step.
    final scheduled = DateTime(year, 6, 11);
    final inGame = career.inGameDate;
    await _comp.saveFinals(
      careerId: careerId,
      draw: draw,
      groupStart: scheduled.isAfter(inGame)
          ? scheduled
          : inGame.add(const Duration(days: 14)),
      cycle: career.cyclePointer,
    );
  }

  /// Starts the next 4-year cycle once the current World Cup is decided:
  /// re-draws every confederation's qualifiers and advances the calendar.
  /// Rolls into the next cycle. [switchToNationId] moves the manager to a new
  /// nation (an accepted offer or a forced move after the sack); [boardTitle]/
  /// [boardBody], when given, are filed as a board-verdict message.
  Future<void> startNextCycle(
    int careerId, {
    int? switchToNationId,
    String? boardTitle,
    String? boardBody,
    FederationInvestment? nextInvestment,
  }) async {
    final career = await _careers.byId(careerId);
    if (career == null) return;
    if (await _comp.worldChampion(careerId) == null) return; // not finished

    // Settle the finishing cycle's finances: bank income, then commit the
    // manager's allocation for the cycle about to begin.
    final income = await _ref
        .read(federationServiceProvider)
        .incomeForCycle(careerId, career.cyclePointer);
    var budget =
        career.budget + income.grant + income.prize + income.commercial;
    if (nextInvestment != null) {
      final spend = nextInvestment.youth +
          nextInvestment.commercial +
          nextInvestment.medical +
          nextInvestment.naturalization;
      // The UI validates spend <= budget; ignore an over-budget allocation
      // rather than going negative.
      if (spend <= budget) {
        await _careers.setInvestment(
          careerId,
          career.cyclePointer + 1,
          nextInvestment,
        );
        budget -= spend;
      }
    }
    await _careers.setBudget(careerId, budget);

    // Move the Nations Cup ladder on this cycle's cup — every league's group
    // winners climb, bottom sides drop. Read the tables BEFORE advancing the
    // cycle (they are scoped to the current, finishing cycle).
    var ncTiers = await _careers.nationsCupTiers(careerId);
    final ncTables = await _comp.tournamentGroupTables(
      careerId,
      CompetitionKind.nationsLeague,
    );
    if (ncTables.isNotEmpty && ncTiers.isNotEmpty) {
      final groups = [
        for (final t in ncTables)
          if (t.standings.length >= 2)
            (
              tier: NationsCup.tierOfGroupName(t.name),
              winner: t.standings.first.nationId,
              bottom: t.standings.last.nationId,
            ),
      ];
      ncTiers = NationsCup.promoteRelegate(tiers: ncTiers, groups: groups);
      await _careers.setNationsCupTiers(careerId, ncTiers);
    }

    if (switchToNationId != null && switchToNationId != career.nationId) {
      await _careers.switchNation(careerId, switchToNationId);
      await _resetSquadForNewNation(careerId, switchToNationId, career);
    }
    if (boardTitle != null) {
      await _comp.addMessage(
        careerId: careerId,
        dedupKey: 'board:${career.cyclePointer}',
        category: 'board',
        title: boardTitle,
        body: boardBody ?? '',
        year: finalsYear(career.cyclePointer),
      );
    }
    final nationId = switchToNationId ?? career.nationId;

    final nextCycle = career.cyclePointer + 1;
    final nextStart = DateTime(finalsYear(career.cyclePointer), 9);

    await _careers.advanceCycle(careerId, nextCycle, nextStart);
    await _careers.recordStint(careerId, nextCycle, nationId);

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
      nationId: nationId,
      rngSeed: career.rngSeed,
      cycle: nextCycle,
      cycleStart: nextStart,
      wcYear: finalsYear(nextCycle),
      rankById: seedRank,
      nationsCupTiers: ncTiers,
    );

    await _maybeGenerateNaturalizationOffer(
      careerId,
      nationId,
      nextCycle,
      nextStart,
      nations,
    );

    _ref.invalidate(hubDataProvider);
  }

  /// Hands the manager a real squad at their new nation.
  ///
  /// Call-ups, the tactic and its lineup are all keyed by career alone, and
  /// player ids are partitioned per nation — so left alone, the old nation's
  /// 23 names survive the move and select nothing from the new pool. The
  /// manager would arrive to an empty squad, an unfillable XI, and a call-up
  /// screen that can't reach the 16 needed to save a repair.
  Future<void> _resetSquadForNewNation(
    int careerId,
    int nationId,
    Career career,
  ) async {
    // No explicit selection: the whole new pool is available (as for a fresh
    // save) until the manager curates it.
    await _ref.read(squadRepositoryProvider).clearCallUps(careerId);

    // Rebuild the XI from the new nation's players; saveTactic replaces the
    // stored lineup slots, which still named the old squad.
    final players = await _ref.read(playerRepositoryProvider).byNation(
          nationId,
          agingYears: CareerService.agingYears(career),
          saveSeed: career.rngSeed,
        );
    const formation = Formation.f433;
    await _ref.read(tacticsRepositoryProvider).saveTactic(
          careerId,
          Tactic(
            formation: formation,
            lineup: bestEleven(formation, players),
          ),
        );

    _ref
      ..invalidate(squadDataProvider)
      ..invalidate(tacticDataProvider);
  }

  /// Rolls (up to twice) for a foreign player offering to naturalise this
  /// cycle. Each roll's chance scales with the Naturalisation Office
  /// investment; on a hit a plausible player from another nation is offered and
  /// announced in the inbox. Most are mid-tier, still-developing players, but
  /// there is a small chance of a marquee name — and, realistically, a genuine
  /// star only ever surfaces from a strong footballing nation (a minnow simply
  /// hasn't got one). Two hits queue: the second appears once the first is
  /// answered.
  Future<void> _maybeGenerateNaturalizationOffer(
    int careerId,
    int nationId,
    int nextCycle,
    DateTime cycleStart,
    Map<int, Nation> nations,
  ) async {
    final invest = await _careers.investment(careerId, nextCycle);
    final chance =
        FederationFinance.naturalizationChance(invest.naturalization);
    final career = await _careers.byId(careerId);
    if (career == null) return;

    final others = nations.values.where((n) => n.id != nationId).toList()
      ..sort((a, b) => a.ranking.compareTo(b.ranking)); // strongest first
    if (others.isEmpty) return;
    final playerRepo = _ref.read(playerRepositoryProvider);
    final agingYears = (cycleStart.year - CareerService.cycleStart.year)
        .clamp(0, 400);

    // Never re-offer a player already secured; keep the two rolls distinct.
    final taken = {
      for (final l in await _careers.acceptedNaturalizations(careerId))
        l.playerId,
    };
    final pending = await _careers.pendingNaturalization(careerId);
    if (pending != null) taken.add(pending.playerId);

    // Two independent rolls per cycle.
    for (var attempt = 0; attempt < 2; attempt++) {
      final rng = SeededRng(
        career.rngSeed ^ (nextCycle * 0x4E17) ^ (attempt * 0x51ED) ^ 0x9A72,
      );
      if (rng.nextDouble() >= chance) continue;

      // A small chance the candidate is a genuine star — but only ever from a
      // strong footballing nation (the top of the ranking), so the quality is
      // believable. Otherwise a mid-tier player from anywhere.
      final marquee = rng.nextDouble() < 0.05;
      final sources = marquee
          ? others.take(20).toList() // only strong nations breed stars
          : others;
      final minR = marquee ? 85 : 66;
      final maxR = marquee ? 93 : 84;
      final maxAge = marquee ? 32 : 29;

      final candidates = <Player>[];
      for (var i = 0; i < 8 && candidates.length < 12; i++) {
        final n = sources[rng.nextInt(sources.length)];
        final pool = await playerRepo.byNation(
          n.id,
          agingYears: agingYears,
          saveSeed: career.rngSeed,
        );
        candidates.addAll(
          pool.where(
            (p) =>
                p.age <= maxAge &&
                p.overall >= minR &&
                p.overall <= maxR &&
                !taken.contains(p.id),
          ),
        );
      }
      if (candidates.isEmpty) continue;
      final pick = candidates[rng.nextInt(candidates.length)];
      taken.add(pick.id);
      final from = nations[pick.nationId]?.name ?? 'their nation';
      final to = nations[nationId]?.name ?? 'your nation';

      await _careers.addNaturalizationOffer(
        careerId: careerId,
        playerId: pick.id,
        sourceNationId: pick.nationId,
        cycle: nextCycle,
      );
      await _comp.addMessage(
        careerId: careerId,
        dedupKey: 'natz:$nextCycle:${pick.id}',
        category: 'naturalize',
        title: pick.overall >= 85
            ? '⭐ ${pick.name} would switch to $to!'
            : '${pick.name} wants to play for $to',
        body: '${pick.name} — a ${pick.age}-year-old '
            '${pick.position.name} rated ${pick.overall}, currently of $from — '
            '${pick.overall >= 85 ? 'is a star name who ' : ''}'
            'has family ties to $to and is open to switching allegiance. '
            'Your growing reputation has caught their eye. Head to the '
            'Naturalisation offer to accept or decline.',
        year: finalsYear(nextCycle),
      );
    }
  }
}

final Provider<SeasonService> seasonServiceProvider = Provider(
  SeasonService.new,
);
