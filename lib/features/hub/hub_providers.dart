import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/core/util/text_variety.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_absence.dart';
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
import 'package:fnm/domain/services/federation/federation_finance.dart';
import 'package:fnm/domain/services/match/background_match.dart';
import 'package:fnm/domain/services/match/goal_attribution.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_simulator.dart';
import 'package:fnm/domain/services/match/venue.dart';
import 'package:fnm/domain/services/player/discipline.dart';
import 'package:fnm/domain/services/ranking/elo.dart';
import 'package:fnm/domain/services/tactics/best_eleven.dart';
import 'package:fnm/domain/services/tactics/team_chemistry.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/awards/award_providers.dart';
import 'package:fnm/features/squad/grievance_providers.dart';
import 'package:fnm/features/federation/federation_providers.dart';
import 'package:fnm/features/federation/federation_service.dart';
import 'package:fnm/features/hub/draw_reveal.dart';
import 'package:fnm/features/achievements/achievement_providers.dart';
import 'package:fnm/features/hub/objective_providers.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';
import 'package:fnm/features/squad/training_camp_providers.dart';
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
final AutoDisposeFutureProviderFamily<HubData?, int>
hubDataProvider = FutureProvider.autoDispose.family<HubData?, int>((
  ref,
  careerId,
) async {
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
      nextDrawWatched = await compRepo.hasWatchedDraw(
        careerId,
        career.cyclePointer,
        kind,
      );
    }
  }

  // The advancing (green) and in-contention (amber) positions for the shown
  // group, from its competition's exact format — plus whether that group's own
  // draw has been watched (the table stays hidden until it has).
  var groupDirect = 2;
  int? groupContention;
  var groupRelegate = 0;
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
    final gk = groupDrawKind(group.kind);
    if (gk != null) {
      groupDrawWatched = await compRepo.hasWatchedDraw(
        careerId,
        career.cyclePointer,
        gk,
      );
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

  /// The world-mutating operation currently running, if any.
  ///
  /// Every public entry point below drives the SAME career through the SAME
  /// scratch state ([_simSeed], [_simYears], [_poolCache]) and writes in
  /// batched transactions. Two of them running at once interleave those writes
  /// and stomp the scratch fields mid-run, so they are serialized here rather
  /// than at each call site — the hub fires [advance] without awaiting it, so
  /// a second tap used to start a whole second simulation over the first.
  Future<void>? _inFlight;

  /// Runs [body] with no other world-mutating operation in progress.
  ///
  /// [dropIfBusy] separates the two kinds of caller. "Move the world on"
  /// (advance, skip) is idempotent from the player's point of view: a second
  /// tap while the first is still working means nothing new, so it joins the
  /// running operation instead of queueing another advance behind it. Calls
  /// that carry data that would be LOST if dropped — a played match, a cycle
  /// rollover — queue behind the running one instead.
  Future<void> _exclusive(
    Future<void> Function() body, {
    required bool dropIfBusy,
  }) {
    final running = _inFlight;
    if (running != null && dropIfBusy) return running;
    // Chain behind whatever is running. Its failure is not ours to report —
    // that call surfaces its own error to its own caller — so either outcome
    // simply lets us start.
    final next = running == null
        ? body()
        : running.then((_) => body(), onError: (_) => body());
    _inFlight = next;
    return next.whenComplete(() {
      // Only clear the slot if nothing has queued behind us in the meantime.
      if (identical(_inFlight, next)) _inFlight = null;
    });
  }

  /// Whether a world-mutating operation is running right now (the hub disables
  /// its controls on this rather than starting work it will drop).
  bool get isBusy => _inFlight != null;

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

  /// Suspensions and injuries for the save currently being simulated, held in
  /// memory across a whole operation and written once at the end — exactly like
  /// [_rankPoints].
  ///
  /// EVERY nation carries absences now, not just the manager's, so a single
  /// advance can touch hundreds of rows; reading and rewriting the table per
  /// fixture would make advancing the world crawl.
  Map<int, PlayerAbsence>? _absences;
  int? _absenceCareer;

  Future<Map<int, PlayerAbsence>> _ensureAbsences(int careerId) async {
    if (_absenceCareer == careerId && _absences != null) return _absences!;
    _absences = await _ref.read(absenceRepositoryProvider).forCareer(careerId);
    _absenceCareer = careerId;
    return _absences!;
  }

  Future<void> _flushAbsences(int careerId) async {
    final a = _absences;
    if (a != null && _absenceCareer == careerId) {
      await _ref.read(absenceRepositoryProvider).replace(careerId, a.values);
    }
  }

  /// Applies one match's cards and knocks to [nationId]'s standing.
  ///
  /// [Discipline.applyMatch] serves a game off every ban and injury it is
  /// handed, so the career-wide map is narrowed to this nation's own players
  /// first. Handing it the whole world would tick a game off every suspension
  /// on the planet every time any match anywhere was played.
  Future<Map<int, PlayerAbsence>> _applyDiscipline({
    required int careerId,
    required int nationId,
    required List<MatchEvent> events,
    required SeededRng rng,
    required bool competitive,
  }) async {
    final all = await _ensureAbsences(careerId);
    final mine = {for (final p in await _pool(nationId)) p.id};
    final after = Discipline.applyMatch(
      before: {
        for (final e in all.entries)
          if (mine.contains(e.key)) e.key: e.value,
      },
      events: events,
      nationId: nationId,
      rng: rng,
      competitive: competitive,
    );
    all
      ..removeWhere((id, _) => mine.contains(id))
      ..addAll(after);
    return after;
  }

  /// Whether [playerId] is currently banned or injured.
  bool _isAbsent(int playerId) {
    final a = _absences?[playerId];
    return a != null && !a.isAvailable;
  }

  /// Loads (seeding if needed) the ranking points for [careerId].
  Future<void> _ensureRank(int careerId) async {
    if (_rankCareer == careerId && _rankPoints != null) return;
    final nations = await _nationsById();
    final seed = {
      for (final n in nations.values) n.id: Elo.seedFromRanking(n.ranking),
    };
    _rankPoints = await _ref
        .read(rankingRepositoryProvider)
        .pointsFor(careerId, seed);
    _rankCareer = careerId;
  }

  /// The World Cup finals rounds. Their results never move the ranking live —
  /// while the tournament is on the table sits still, and the whole run is
  /// settled in one heavier pass once the champion is known (see
  /// [_settleWorldCupRanking]). These round codes are unique to the World Cup
  /// finals (continental uses a 'C' prefix, the Nations Cup an 'N' prefix).
  static const _wcFinalsRounds = {
    'GROUP',
    'R32',
    'R16',
    'QF',
    'SF',
    '3RD',
    'FINAL',
  };

  static bool _isWcFinalsMatch(Fixture f) =>
      f.round != null && _wcFinalsRounds.contains(f.round);

  /// Nudges both nations' points by this result (finals count for more than
  /// qualifiers). No-op until [_ensureRank] has run. World Cup finals matches
  /// are skipped here — they are settled together after the tournament.
  void _bumpRank(Fixture f, int home, int away, int hs, int as) {
    final pts = _rankPoints;
    if (pts == null) return;
    if (_isWcFinalsMatch(f)) return; // settled post-tournament, not live
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

  /// Settles a decided World Cup finals into the ranking in one pass, heavier
  /// than any live result. Called once, from [_recordHonourIfDecided], so the
  /// whole tournament lands after the final rather than creeping through it.
  /// Rounds are replayed in bracket order for a stable, deterministic result.
  Future<void> _settleWorldCupRanking(int careerId) async {
    final pts = _rankPoints;
    if (pts == null) return;
    for (final round in const [
      'GROUP',
      'R32',
      'R16',
      'QF',
      'SF',
      '3RD',
      'FINAL',
    ]) {
      final fixtures = await _comp.fixturesByRound(careerId, round);
      for (final f in fixtures) {
        if (!f.hasResult) continue;
        final hp = pts[f.homeNationId] ?? Elo.base;
        final ap = pts[f.awayNationId] ?? Elo.base;
        final delta = Elo.homeDelta(
          homePoints: hp,
          awayPoints: ap,
          homeScore: f.homeScore!,
          awayScore: f.awayScore!,
          weight: Elo.finalsSettled,
        );
        pts[f.homeNationId] = hp + delta;
        pts[f.awayNationId] = ap - delta;
      }
    }
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

  /// Publishes a world-ranking release at most once every ~10 weeks of in-game
  /// time, mirroring how the real ranking works: results accumulate through
  /// several international windows, then the table is republished. A monthly
  /// cadence made the movement messages arrive too often for how much actually
  /// changes between them.
  ///
  /// Points move with every result, but a message per result would be noise.
  static const int _rankingReleaseGapDays = 70;

  Future<void> _publishRankingIfDue(int careerId) async {
    final career = await _careers.byId(careerId);
    if (career == null) return;
    // The ranking is never republished mid-tournament: while a finals is under
    // way its results (the heaviest-weighted of all) keep moving the points,
    // and the whole swing lands as one bigger update once it is decided —
    // rather than dribbling out round by round.
    if (await _finalsInProgress(careerId)) return;
    final releases = _ref.read(rankingReleaseRepositoryProvider);
    final last = await releases.latest(careerId);
    final now = career.inGameDate;
    if (last != null &&
        now.difference(last.publishedOn).inDays < _rankingReleaseGapDays) {
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

  /// Whether any finals tournament is currently live — the World Cup finals
  /// (drawn but no champion yet), the manager's continental championship, or
  /// the Nations Cup Finals Four. Ranking releases pause while one is.
  ///
  /// The continental check names the manager's own confederation: all six
  /// championships run at once now, so an unqualified lookup answers for
  /// whichever continent the query happened to return.
  Future<bool> _finalsInProgress(int careerId) async {
    if (await _comp.hasFinals(careerId) &&
        await _comp.worldChampion(careerId) == null) {
      return true;
    }
    if (await _comp.hasLiveContinentalFinals(
      careerId,
      confederation: await _managerConfederation(careerId),
    )) {
      return true;
    }
    if (await _comp.hasLiveNationsCupFinals(careerId)) return true;
    return false;
  }

  /// World positions (1 = top) from the live points held in memory, tie-broken
  /// by the static seed order. Used to freeze a cycle's seeding ranking.
  Map<int, int> _liveRankById(Map<int, Nation> nations) {
    final pts =
        _rankPoints ??
        {for (final n in nations.values) n.id: Elo.seedFromRanking(n.ranking)};
    final seedRank = {for (final n in nations.values) n.id: n.ranking};
    return Elo.positions(pts, seedRankById: seedRank);
  }

  /// The frozen seeding ranking for [cycle] (nationId → position), falling back
  /// to the static seed ranking when the cycle was never snapshotted.
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
    // The XI each side fields (its best 4-3-3): goals are attributed within
    // it, and every fielded player logs a cap — so a nation's all-time
    // scorers and appearance records accumulate across the whole save,
    // whether or not the manager is at that team. Fielding the XI first also
    // lets the scoreline be driven by the squad actually on the pitch (an
    // aging, evolving pool), not just the nation's static seeding.
    final homeXi = await _fieldedXi(f.homeNationId);
    final awayXi = await _fieldedXi(f.awayNationId);
    // …and the substitutes it brings on. Background sides used to play the
    // whole ninety with eleven men, so outside the manager's own fixtures no
    // substitute ever won a cap, scored, was booked or was marked — the rest of
    // the world had no bench at all. Strength is still read off the XI: the
    // subs change who is on the pitch, not how good the side is.
    final homeSubs = await _fieldedSubs(f.homeNationId, homeXi);
    final awaySubs = await _fieldedSubs(f.awayNationId, awayXi);
    final homeStrength = _squadStrength(homeXi, home);
    final awayStrength = _squadStrength(awayXi, away);
    const sim = RatingMatchSimulator();
    final outcome = sim.simulate(
      homeStrength: homeStrength,
      awayStrength: awayStrength,
      rng: SeededRng.forFixture(rngSeed, f.id),
      // A finals is played at a neutral host — no automatic home advantage.
      homeAdvantage: !isNeutralFinalsRound(f.round),
    );
    await _comp.recordAppearances(
      f.careerId,
      f.homeNationId,
      [...homeXi, ...homeSubs].map((p) => p.id),
    );
    await _comp.recordAppearances(
      f.careerId,
      f.awayNationId,
      [...awayXi, ...awaySubs].map((p) => p.id),
    );
    // Tournament-tagged participation (whole world) so records like "most World
    // Cup starts" / "most cups attended" accrue — the XI as starters, the
    // substitutes as appearances off the bench.
    await _comp.recordTournamentAppearances(
      f.careerId,
      f.competitionId,
      [
        for (final p in homeXi)
          (playerId: p.id, nationId: f.homeNationId, started: true),
        for (final p in homeSubs)
          (playerId: p.id, nationId: f.homeNationId, started: false),
        for (final p in awayXi)
          (playerId: p.id, nationId: f.awayNationId, started: true),
        for (final p in awaySubs)
          (playerId: p.id, nationId: f.awayNationId, started: false),
      ],
    );
    // Attribute scorers from the pre-shootout score (penalties don't count).
    final scorers = <int>[
      ...await _attributeGoals(
        f,
        f.homeNationId,
        outcome.homeScore,
        rngSeed,
        0x6001,
        xi: homeXi,
        subs: homeSubs,
      ),
      ...await _attributeGoals(
        f,
        f.awayNationId,
        outcome.awayScore,
        rngSeed,
        0x6002,
        xi: awayXi,
        subs: awaySubs,
      ),
    ];

    var hs = outcome.homeScore;
    var as = outcome.awayScore;
    var aet = false;
    int? homePens;
    int? awayPens;
    if (_isKnockout(f) && hs == as) {
      final ko = WorldCupFinals.decideKnockout(
        hs,
        as,
        SeededRng.forFixture(rngSeed, f.id ^ 0x7F),
        homeStrength: homeStrength.toDouble(),
        awayStrength: awayStrength.toDouble(),
      );
      aet = true;
      // The extra-time goals are attributed with 91'–120' minutes so they show
      // up in the scorer charts, not just on the scoreboard.
      scorers
        ..addAll(
          await _attributeGoals(
            f,
            f.homeNationId,
            ko.homeScore - hs,
            rngSeed,
            0x7E01,
            xi: homeXi,
            subs: homeSubs,
            minuteFrom: 91,
            minuteSpan: 30,
          ),
        )
        ..addAll(
          await _attributeGoals(
            f,
            f.awayNationId,
            ko.awayScore - as,
            rngSeed,
            0x7E02,
            xi: awayXi,
            subs: awaySubs,
            minuteFrom: 91,
            minuteSpan: 30,
          ),
        );
      if (ko.wentToShootout) {
        homePens = ko.homePens;
        awayPens = ko.awayPens;
        // Store the winner one clear so the bracket still reads a winner.
        hs = ko.homeWon ? ko.homeScore + 1 : ko.homeScore;
        as = ko.homeWon ? ko.awayScore : ko.awayScore + 1;
      } else {
        hs = ko.homeScore;
        as = ko.awayScore;
      }
    }
    await _comp.recordResult(
      fixtureId: f.id,
      homeScore: hs,
      awayScore: as,
      afterExtraTime: aet,
      homePenalties: homePens,
      awayPenalties: awayPens,
    );
    _bumpRank(f, f.homeNationId, f.awayNationId, hs, as);
    await _recordBackgroundDetail(
      f,
      homeXi: homeXi,
      awayXi: awayXi,
      homeSubs: homeSubs,
      awaySubs: awaySubs,
      homeScore: outcome.homeScore,
      awayScore: outcome.awayScore,
      homeStrength: homeStrength,
      awayStrength: awayStrength,
      scorers: scorers,
      rngSeed: rngSeed,
    );
  }

  /// Gives a background match everything the tactical engine would have given
  /// it apart from its scoreline: a box score, assists, cards, knocks and a
  /// mark for all twenty-two — see [BackgroundMatch].
  ///
  /// Every RNG draw here comes off a stream FORKED from the fixture's, so
  /// adding this changed no result already in any save.
  Future<void> _recordBackgroundDetail(
    Fixture f, {
    required List<Player> homeXi,
    required List<Player> awayXi,
    required List<Player> homeSubs,
    required List<Player> awaySubs,
    required int homeScore,
    required int awayScore,
    required int homeStrength,
    required int awayStrength,
    required List<int> scorers,
    required int rngSeed,
  }) async {
    if (homeXi.isEmpty || awayXi.isEmpty) return;
    final goalsByPlayer = <int, int>{};
    for (final id in scorers) {
      goalsByPlayer.update(id, (v) => v + 1, ifAbsent: () => 1);
    }
    final competitive = f.round != Rounds.friendly;
    final detail = BackgroundMatch.detail(
      homeXi: homeXi,
      awayXi: awayXi,
      homeSubs: homeSubs,
      awaySubs: awaySubs,
      homeNationId: f.homeNationId,
      awayNationId: f.awayNationId,
      homeScore: homeScore,
      awayScore: awayScore,
      homeStrength: homeStrength,
      awayStrength: awayStrength,
      goalsByPlayer: goalsByPlayer,
      rng: SeededRng.forFixture(rngSeed, f.id ^ 0x0D37),
      competitive: competitive,
      saveSeed: _simSeed,
    );

    await _comp.recordPlayerMatchStats(
      f.careerId,
      f.id,
      detail.lines.map(
        (l) => (
          playerId: l.playerId,
          nationId: l.nationId,
          rating: l.rating,
          goals: l.goals,
          assists: l.assists,
          cleanSheet: l.cleanSheet,
          motm: l.motm,
          yellows: l.yellows,
          reds: l.reds,
        ),
      ),
    );
    await _comp.recordTeamStats(
      f.careerId,
      f.id,
      homeShots: detail.homeShots,
      awayShots: detail.awayShots,
      homePossession: detail.homePossession,
      homeXg: detail.homeXg,
      awayXg: detail.awayXg,
    );

    // Both sides' cards and knocks, through the same rules the manager's own
    // squad lives under — so a rival really can lose its striker to a ban.
    for (final nationId in [f.homeNationId, f.awayNationId]) {
      await _applyDiscipline(
        careerId: f.careerId,
        nationId: nationId,
        events: detail.events,
        rng: SeededRng.forFixture(rngSeed, f.id ^ 0x0AB5 ^ nationId),
        competitive: competitive,
      );
    }
  }

  /// A background side's match strength, driven by the real XI it fields (an
  /// aging, evolving pool) rather than the nation's static seeding alone. Takes
  /// the mean overall of the fielded eleven and blends it with the ranking-based
  /// strength — so a golden generation lifts a nation and its decline is felt,
  /// while the ranking anchor keeps thin-pool edge cases stable. Falls back to
  /// the seeding when no XI can be formed.
  static int _squadStrength(List<Player> xi, Nation nation) {
    final ranked = RatingMatchSimulator.strengthOf(nation);
    if (xi.isEmpty) return ranked;
    final best = [...xi]..sort((a, b) => b.overall.compareTo(a.overall));
    final eleven = best.take(11).toList();
    final mean = eleven.fold<int>(0, (s, p) => s + p.overall) / eleven.length;
    // Weight the squad heavily; keep a quarter on the ranking as an anchor.
    return (mean * 0.75 + ranked * 0.25).round().clamp(40, 92);
  }

  /// The players a background-simulated side actually fields: its best 4-3-3
  /// from the pool (the whole pool if an XI can't be formed).
  Future<List<Player>> _fieldedXi(int nationId) async {
    final pool = await _pool(nationId);
    if (pool.isEmpty) return const [];
    // A suspended or injured player does not play — for ANY nation, not just
    // the manager's. This is what makes the world's cards and knocks mean
    // something: a rival losing its centre-forward for a quarter-final really
    // does field a weaker side, because `_squadStrength` reads this XI.
    final available = [
      for (final p in pool)
        if (!_isAbsent(p.id)) p,
    ];
    // Never field nobody: a pool decimated by absences still puts out its best
    // available eleven, and a pool somehow entirely absent falls back to itself
    // rather than forfeiting.
    final fit = available.isEmpty ? pool : available;
    final xiIds = bestEleven(Formation.f433, fit).whereType<int>().toSet();
    final xi = fit.where((p) => xiIds.contains(p.id)).toList();
    return xi.isEmpty ? fit : xi;
  }

  /// How many substitutes a background side brings on. Three is the number that
  /// matters: enough that a bench player is a real part of the world's records
  /// without pretending every game empties the bench.
  static const int _backgroundSubs = 3;

  /// The substitutes a background side uses: the best available players outside
  /// its [xi]. Deterministic — the same pool and the same absences always give
  /// the same bench, like everything else in the derived world.
  Future<List<Player>> _fieldedSubs(int nationId, List<Player> xi) async {
    if (xi.isEmpty) return const [];
    final pool = await _pool(nationId);
    final onPitch = xi.map((p) => p.id).toSet();
    final available = [
      for (final p in pool)
        if (!onPitch.contains(p.id) && !_isAbsent(p.id)) p,
    ]..sort((a, b) {
      final byOverall = b.overall.compareTo(a.overall);
      return byOverall != 0 ? byOverall : a.id.compareTo(b.id);
    });
    return available.take(_backgroundSubs).toList();
  }

  /// Attributes [goals] to the fielded XI and records them, returning the
  /// scorer of each goal (repeated for a brace) so the caller can build the
  /// match's player lines from the same attribution.
  Future<List<int>> _attributeGoals(
    Fixture f,
    int nationId,
    int goals,
    int rngSeed,
    int salt, {
    List<Player>? xi,
    List<Player> subs = const [],
    int minuteFrom = 1,
    int minuteSpan = 90,
  }) async {
    if (goals <= 0) return const [];
    // Attribute to the players who actually take the field, not the whole
    // 100-man pool — otherwise goals scatter across every fringe player and no
    // striker ever builds a tally. The best XI concentrates goals on the front
    // line, matching the detailed engine's behaviour. Substitutes are in the
    // draw too, weighted down for the half-hour they get.
    final fielded = xi ?? await _fieldedXi(nationId);
    if (fielded.isEmpty) return const [];
    final rng = SeededRng.forFixture(rngSeed, f.id ^ salt);
    final ids = GoalAttribution.scorers(
      pool: [...fielded, ...subs],
      goals: goals,
      rng: rng,
      benchIds: {for (final p in subs) p.id},
    );
    await _comp.recordGoals([
      for (final id in ids)
        (
          careerId: f.careerId,
          competitionId: f.competitionId,
          fixtureId: f.id,
          nationId: nationId,
          playerId: id,
          minute: minuteFrom + rng.nextInt(minuteSpan),
        ),
    ]);
    return ids;
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
  ///
  /// Dropped if a sim is already running — see [_exclusive].
  Future<void> advance(int careerId) =>
      _exclusive(() => _advance(careerId), dropIfBusy: true);

  Future<void> _advance(int careerId) async {
    await _ensureRank(careerId);
    // A foreign talent may declare interest at any random point in the cycle.
    await _rollNaturalizationIfDue(careerId);
    // And anybody who asked where he stood and was never answered may have
    // stopped waiting. Settled before the clock moves, so the squad the next
    // match is picked from is the squad that is actually available.
    await _ref.read(grievanceServiceProvider).settleWalkouts(careerId);
    // And the year's individual trophies, once a year has actually finished.
    await _ref.read(awardServiceProvider).settleYear(careerId);
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
      // A finals participant is never fast-forwarded past their own matches:
      // check ALL of the player's unplayed fixtures, not just the immediate one
      // (an intervening friendly must not lock them out of their finals games).
      final playerFixtures = await _comp.fixturesForNation(
        careerId,
        career.nationId,
      );
      final playerInFinals = playerFixtures.any(
        (f) => !f.hasResult && _isFinalsMatch(f),
      );
      // Only step the World Cup and the player's OWN continental finals day by
      // day; foreign continental finals resolve in the background (else their
      // dates hijack the WC "watch" step — see nextEventProvider).
      final playerConf = (await _nationsById())[career.nationId]?.confederation;
      final finalsDate = await _comp.earliestUnplayedFinalsDate(
        careerId,
        playerConfederation: playerConf,
      );
      // A live World Cup finals takes priority even over the player's own
      // friendlies, so its climax rounds (up to the final) are watched rather
      // than silently caught up — mirrors nextEventProvider's guard.
      final wcLive =
          await _comp.hasFinals(careerId) &&
          await _comp.worldChampion(careerId) == null;

      // 1. A live finals the player isn't in, due before their next fixture:
      //    step it ONE matchday and hand back so they watch the results. This
      //    is what lets a non-qualifier or knocked-out nation follow the whole
      //    tournament, day by day, instead of it fast-forwarding.
      if (finalsDate != null &&
          !nextIsFinals &&
          !playerInFinals &&
          (next == null || !finalsDate.isAfter(next.date) || wcLive)) {
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
      //     semis and final are watched rather than silently fast-forwarded. A
      //     participant is detected from ANY unplayed NSF/NFINAL fixture (not
      //     just their immediate next one), so a host whose pre-finals window is
      //     friendlies still plays their own semi/final instead of watching it.
      final ncFinalsDate = await _comp.earliestUnplayedNationsCupFinalsDate(
        careerId,
      );
      final nextIsNcFinals =
          next != null && (next.round == 'NSF' || next.round == 'NFINAL');
      final playerInNcFinals = playerFixtures.any(
        (f) => !f.hasResult && (f.round == 'NSF' || f.round == 'NFINAL'),
      );
      if (ncFinalsDate != null &&
          !nextIsNcFinals &&
          !playerInNcFinals &&
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
      final wcFinalsLive =
          await _comp.hasFinals(careerId) &&
          await _comp.worldChampion(careerId) == null;
      // The manager's OWN continental cup — a foreign continent's championship
      // resolves in the background and must not stop the world advancing.
      if (wcFinalsLive ||
          await _comp.hasLiveContinentalFinals(
            careerId,
            confederation: playerConf,
          )) {
        break;
      }
    }
    // The board's verdict on any objective this run has just settled, so it
    // lands with the result rather than at the end of the cycle.
    await _gradeObjectivesIfDecided(careerId);
    await _flushRank(careerId);
    await _flushAbsences(careerId);
    // The ranking screen's data is auto-disposed but can be kept alive by a
    // listener elsewhere (careers list, vitrine) — refresh it explicitly so
    // the full ranking always shows the points the sim just moved.
    _ref
      ..invalidate(hubDataProvider)
      ..invalidate(worldRankingProvider)
      ..invalidate(rankHistoryProvider)
      // The board's brief and its mood are derived from fixtures the sim has
      // just changed, and neither reads them through a provider that would
      // notice — so they are refreshed by hand, or the hub keeps showing the
      // verdict it computed before the tournament was played.
      ..invalidate(cycleObjectiveOutcomesProvider)
      ..invalidate(cycleObjectivesProvider)
      ..invalidate(satisfactionProvider);
  }

  /// Fast-forwards straight to the World Cup champion — the "skip to the final"
  /// option when the player is watching the finals rather than playing them.
  ///
  /// Dropped if a sim is already running — see [_exclusive].
  Future<void> skipToChampion(int careerId) =>
      _exclusive(() => _skipToChampion(careerId), dropIfBusy: true);

  Future<void> _skipToChampion(int careerId) async {
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
    // The board's verdict on any objective this run has just settled, so it
    // lands with the result rather than at the end of the cycle.
    await _gradeObjectivesIfDecided(careerId);
    await _flushRank(careerId);
    await _flushAbsences(careerId);
    // The ranking screen's data is auto-disposed but can be kept alive by a
    // listener elsewhere (careers list, vitrine) — refresh it explicitly so
    // the full ranking always shows the points the sim just moved.
    _ref
      ..invalidate(hubDataProvider)
      ..invalidate(worldRankingProvider)
      ..invalidate(rankHistoryProvider)
      // The board's brief and its mood are derived from fixtures the sim has
      // just changed, and neither reads them through a provider that would
      // notice — so they are refreshed by hand, or the hub keeps showing the
      // verdict it computed before the tournament was played.
      ..invalidate(cycleObjectiveOutcomesProvider)
      ..invalidate(cycleObjectivesProvider)
      ..invalidate(satisfactionProvider);
  }

  /// Records the player's [result] for [fixture] (from the tactical engine),
  /// quick-sims every other match due that day, advances and progresses.
  /// Records the manager's own match.
  ///
  /// [knockout] is the extra time / shootout as it was actually played out on
  /// the match screen (with the named takers and any extra-time team talk).
  /// When it is omitted — a match committed without the live screen — the tie
  /// is drawn here from the fixture's own seed, as it always was.
  ///
  /// Queued, never dropped — the result would be lost. See [_exclusive].
  Future<void> playPlayerMatch(
    int careerId,
    Fixture fixture,
    MatchResult result, {
    KnockoutOutcome? knockout,
  }) => _exclusive(
    () => _playPlayerMatch(careerId, fixture, result, knockout: knockout),
    dropIfBusy: false,
  );

  Future<void> _playPlayerMatch(
    int careerId,
    Fixture fixture,
    MatchResult result, {
    KnockoutOutcome? knockout,
  }) async {
    final career = await _careers.byId(careerId);
    if (career == null) return;
    _simSeed = career.rngSeed;
    _simYears = CareerService.agingYears(career);
    await _ensureRank(careerId);

    // Credit tactical familiarity with the shape the manager just fielded — a
    // settled side grows drilled (see TeamChemistry); other shapes decay. The
    // plan behind it goes in too: naming the same shape with the same
    // instructions again is what lets opponents read the side.
    final playedTactic = await _ref
        .read(tacticsRepositoryProvider)
        .tacticForCareer(careerId);
    await _ref
        .read(tacticFamiliarityRepositoryProvider)
        .recordMatch(
          careerId,
          playedTactic?.formation ?? Formation.f433,
          planKey: TeamChemistry.planKey(
            playedTactic?.instructions ?? const TacticalInstructions(),
          ),
        );

    var hs = result.homeScore;
    var as = result.awayScore;
    var aet = false;
    int? homePens;
    int? awayPens;
    if (_isKnockout(fixture) && hs == as) {
      final ko =
          knockout ??
          WorldCupFinals.decideKnockout(
            hs,
            as,
            SeededRng.forFixture(career.rngSeed, fixture.id ^ 0x7F),
          );
      aet = true;
      // Attribute the extra-time goals (91'–120') so they reach the scorer
      // charts too, matching the live screen.
      await _attributeGoals(
        fixture,
        fixture.homeNationId,
        ko.homeScore - hs,
        career.rngSeed,
        0x7E01,
        minuteFrom: 91,
        minuteSpan: 30,
      );
      await _attributeGoals(
        fixture,
        fixture.awayNationId,
        ko.awayScore - as,
        career.rngSeed,
        0x7E02,
        minuteFrom: 91,
        minuteSpan: 30,
      );
      if (ko.wentToShootout) {
        homePens = ko.homePens;
        awayPens = ko.awayPens;
        hs = ko.homeWon ? ko.homeScore + 1 : ko.homeScore;
        as = ko.homeWon ? ko.awayScore : ko.awayScore + 1;
      } else {
        hs = ko.homeScore;
        as = ko.awayScore;
      }
    }
    await _comp.recordResult(
      fixtureId: fixture.id,
      homeScore: hs,
      awayScore: as,
      afterExtraTime: aet,
      homePenalties: homePens,
      awayPenalties: awayPens,
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
    // knocks (players who sat this one out have now served a game). Scoped to
    // the manager's own nation — the rest of the world now carries absences
    // too, and they are not served by a game they had no part in.
    var after = await _applyDiscipline(
      careerId: careerId,
      nationId: career.nationId,
      events: result.events,
      rng: SeededRng.forFixture(career.rngSeed, fixture.id ^ 0x0AB5),
      competitive: fixture.round != Rounds.friendly,
    );
    // A base camp with a proper medical set-up turns knocks round faster (see
    // `TrainingCamps`), so a knee picked up in the group stage can cost a
    // tournament at one camp and a single match at another.
    final camp = await _ref.read(activeCampProvider(careerId).future);
    final recovery = camp?.injuryRecovery ?? 1;
    if (recovery > 1) {
      after = {
        for (final e in after.entries)
          e.key: e.value.injuryMatches <= 1
              ? e.value
              : e.value.copyWith(
                  injuryMatches: (e.value.injuryMatches / recovery)
                      .round()
                      .clamp(1, e.value.injuryMatches),
                ),
      };
      // The camp's faster recovery has to land back in the shared map, or the
      // flush at the end of the operation writes the un-shortened injuries.
      _absences?.addAll(after);
    }

    // Notify the manager of new suspensions and knocks from this match, so a
    // ban or injury never comes as a silent surprise next selection.
    final discYear = fixture.date.year;
    final competitive = fixture.round != Rounds.friendly;
    for (final e in result.events) {
      if (e.teamNationId != career.nationId) continue;
      if (e.type == MatchEventType.redCard && competitive) {
        final ban = after[e.playerId]?.banMatches ?? 1;
        final games = ban == 1 ? 'your next match' : 'the next $ban matches';
        final how = e.secondYellow
            ? 'was sent off for a second booking'
            : ban >= 3
            ? 'was shown a straight red for violent conduct'
            : 'was sent off';
        await _comp.addMessage(
          careerId: careerId,
          dedupKey: 'ban:${fixture.id}:${e.playerId}',
          category: 'discipline',
          title: '${e.playerName} suspended',
          body:
              '${e.playerName} $how and is banned for $games — they will '
              'be unavailable for selection.',
          year: discYear,
        );
      } else if (e.type == MatchEventType.injury) {
        final out = after[e.playerId]?.injuryMatches ?? 1;
        await _comp.addMessage(
          careerId: careerId,
          dedupKey: 'inj:${fixture.id}:${e.playerId}',
          category: 'injury',
          title: '${e.playerName} injured',
          body:
              '${e.playerName} picked up a knock and is out for '
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
      homeXg: result.homeXg,
      awayXg: result.awayXg,
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
    // Tournament-tagged participation (both teams). A player who came on as a
    // substitute featured but did not START — so records can tell the two apart.
    final subsOn = {
      for (final e in result.events)
        if (e.type == MatchEventType.substitution) e.playerId,
    };
    await _comp.recordTournamentAppearances(
      careerId,
      fixture.competitionId,
      [
        for (final r in result.ratings)
          (
            playerId: r.playerId,
            nationId: r.teamNationId,
            started: !subsOn.contains(r.playerId),
          ),
      ],
    );

    // Transfer window(s) for any calendar year the manager has just crossed
    // into — a player who grew or faded over the year changes club, reported
    // once a year rather than dumped four at a time each cycle. Idempotent
    // (deduped per player+year), so replays never double-post.
    for (var y = career.inGameDate.year + 1; y <= fixture.date.year; y++) {
      await _recordTransferYear(careerId, career.nationId, career.rngSeed, y);
    }
    // Records breaking live: announce a new all-time record holder as a headline.
    await _checkRecords(careerId, career, fixture.date.year);
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
    // If this match (or the round it completed) knocked the manager out of a
    // cup, tell them — a tournament exit shouldn't pass unremarked.
    await _fileEliminationIfOut(careerId, career, fixture, hs, as);
    // The board's verdict on any objective this run has just settled, so it
    // lands with the result rather than at the end of the cycle.
    await _gradeObjectivesIfDecided(careerId);
    await _flushRank(careerId);
    await _flushAbsences(careerId);
    // The ranking screen's data is auto-disposed but can be kept alive by a
    // listener elsewhere (careers list, vitrine) — refresh it explicitly so
    // the full ranking always shows the points the sim just moved.
    _ref
      ..invalidate(hubDataProvider)
      ..invalidate(worldRankingProvider)
      ..invalidate(rankHistoryProvider)
      // The board's brief and its mood are derived from fixtures the sim has
      // just changed, and neither reads them through a provider that would
      // notice — so they are refreshed by hand, or the hub keeps showing the
      // verdict it computed before the tournament was played.
      ..invalidate(cycleObjectiveOutcomesProvider)
      ..invalidate(cycleObjectivesProvider)
      ..invalidate(satisfactionProvider);
  }

  /// Files an inbox message when [fixture] knocked the manager out of a cup —
  /// a lost knockout tie, or the group match that left them short of the cut.
  Future<void> _fileEliminationIfOut(
    int careerId,
    Career career,
    Fixture fixture,
    int hs,
    int as,
  ) async {
    final round = fixture.round;
    final me = career.nationId;
    final playerIsHome = fixture.homeNationId == me;
    final myScore = playerIsHome ? hs : as;
    final oppScore = playerIsHome ? as : hs;
    final oppId = playerIsHome ? fixture.awayNationId : fixture.homeNationId;

    // Which cup, and its display name.
    final nations = await _nationsById();
    final conf = nations[me]?.confederation;
    final contName = conf == null
        ? 'the continental championship'
        : ContinentalCups.byConfederation[conf]?.name ??
              'the continental championship';
    final ({String name, CompetitionKind kind})? cup = switch (round) {
      'GROUP' || 'R32' || 'R16' || 'QF' || 'SF' || '3RD' || 'FINAL' => (
        name: 'the World Cup',
        kind: CompetitionKind.worldCupFinals,
      ),
      'CGROUP' || 'CR16' || 'CQF' || 'CSF' || 'CFINAL' => (
        name: contName,
        kind: CompetitionKind.continentalFinals,
      ),
      _ => null,
    };
    if (cup == null) return; // not a finals-tournament match

    final oppName = nations[oppId]?.name ?? 'their opponent';
    final year = fixture.date.year;

    // A knockout tie: losing it (bar the final, which is a runner-up finish)
    // ends the campaign.
    if (Rounds.isKnockout(round)) {
      if (myScore >= oppScore) return; // won the tie — still in
      final core = round!.startsWith('C') ? round.substring(1) : round;
      if (core == 'FINAL') {
        final s = varietySeed('runnerup:${fixture.id}');
        await _comp.addMessage(
          careerId: careerId,
          dedupKey: 'runnerup:${fixture.id}',
          category: 'eliminated',
          title: pickVariant([
            'Runners-up',
            'So near, yet so far',
            'Silver medals',
          ], s),
          body: pickVariant([
            'You reached ${cup.name} final but lost to $oppName. So '
                'close — silver this time.',
            'Beaten by $oppName in the ${cup.name} final. Runners-up — '
                'agonisingly close.',
            'The ${cup.name} final slipped away against $oppName. So much '
                'to be proud of, but not the trophy.',
          ], s),
          year: year,
        );
      } else {
        final s = varietySeed('out:${fixture.id}');
        await _comp.addMessage(
          careerId: careerId,
          dedupKey: 'out:${fixture.id}',
          category: 'eliminated',
          title: pickVariant([
            'Knocked out',
            'The end of the road',
            'Journey over',
          ], s),
          body: pickVariant([
            "You're out of ${cup.name}, beaten by $oppName in the "
                '${_stageName(core)}.',
            '$oppName end your ${cup.name} in the ${_stageName(core)}.',
            'Your ${cup.name} ends in the ${_stageName(core)}, '
                'beaten by $oppName.',
          ], s),
          year: year,
        );
      }
      return;
    }

    // A group match: if the group stage is now complete and the knockout has
    // been drawn without the manager's nation, they failed to advance.
    final firstKo = cup.kind == CompetitionKind.worldCupFinals
        ? ['R32']
        : ['CR16', 'CQF', 'CSF'];
    for (final ko in firstKo) {
      final ties = await _comp.fixturesByRound(careerId, ko, kind: cup.kind);
      if (ties.isEmpty) continue;
      final inKnockout = ties.any(
        (t) => t.homeNationId == me || t.awayNationId == me,
      );
      if (!inKnockout) {
        final s = varietySeed('groupout:${cup.kind.name}:$year');
        await _comp.addMessage(
          careerId: careerId,
          dedupKey: 'groupout:${cup.kind.name}:$year',
          category: 'eliminated',
          title: pickVariant([
            'Group stage exit',
            'Out at the group stage',
            'Early bath',
          ], s),
          body: pickVariant([
            'Your ${cup.name} is over at the group stage. Not enough to '
                'reach the knockouts.',
            'You failed to get out of the group. Your ${cup.name} ends here.',
            'No knockout place this time. Your ${cup.name} is done at the '
                'group stage.',
          ], s),
          year: year,
        );
      }
      return;
    }
  }

  /// A readable stage name from a bare knockout core code.
  static String _stageName(String core) => switch (core) {
    'R32' => 'round of 32',
    'R16' => 'round of 16',
    'QF' => 'quarter-finals',
    'SF' => 'semi-finals',
    '3RD' => 'third-place play-off',
    'FINAL' => 'final',
    _ => 'knockouts',
  };

  // --- Cycle progression ----------------------------------------------------

  /// Rounds that belong to the main finals tournaments (World Cup + continental
  /// championship) — the ones the player steps through even when not in them.
  static const _finalsMatchRounds = {
    'GROUP',
    'R32',
    'R16',
    'QF',
    'SF',
    '3RD',
    'FINAL',
    'CGROUP',
    'CR16',
    'CQF',
    'CSF',
    'C3RD',
    'CFINAL',
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
    Confederation? confederation,
  }) async {
    final fx = await _comp.fixturesByRound(
      careerId,
      round,
      kind: kind,
      confederation: confederation,
    );
    return fx.isNotEmpty && fx.every((f) => f.hasResult);
  }

  Future<DateTime> _maxDate(
    int careerId,
    String round, {
    CompetitionKind kind = CompetitionKind.worldCupFinals,
    Confederation? confederation,
  }) async {
    final fx = await _comp.fixturesByRound(
      careerId,
      round,
      kind: kind,
      confederation: confederation,
    );
    return fx.map((f) => f.date).reduce((a, b) => a.isAfter(b) ? a : b);
  }

  /// Creates the next competition stage when the current one finishes.
  /// Files the board's verdict on each of the cycle's objectives the moment
  /// that tournament is settled for the manager's nation — the cup is won, or
  /// their run in it is over.
  ///
  /// The board used to say nothing at all until the cycle rolled over, two
  /// years after a continental championship and weeks after a World Cup: the
  /// expectation was stated up front, the tournament was played, and the
  /// verdict on it only ever appeared inside the end-of-cycle summary. Both
  /// objectives are now graded and announced when they happen, so winning your
  /// continent is answered by the board in the same month you win it.
  ///
  /// Deduped per cycle and tier, so it is filed once however many times the
  /// world is stepped afterwards.
  Future<void> _gradeObjectivesIfDecided(int careerId) async {
    final career = await _careers.byId(careerId);
    if (career == null) return;
    // Grade from FRESH data. The objectives read the database imperatively, so
    // nothing about a played match invalidates them — and the hub keeps the
    // whole chain alive (its board strip watches satisfaction, which watches
    // the objectives), so this used to read a snapshot taken early in the cycle
    // where nothing was decided yet. The tournament was won or lost and the
    // board's verdict was graded against a cached "still to be decided",
    // which is why no verdict ever arrived, at the Euro or anywhere else.
    _ref.invalidate(cycleObjectiveOutcomesProvider(careerId));
    final objectives = await _ref.read(
      cycleObjectiveOutcomesProvider(careerId).future,
    );
    for (final o in objectives) {
      if (!o.decided) continue;
      final demand = objectiveDemandText(o.tier, o.target);
      final finish = objectiveFinishText(o.tier, o.actual);
      await _comp.addMessage(
        careerId: careerId,
        dedupKey: 'objective:${career.cyclePointer}:${o.tier.name}',
        category: 'board',
        title: o.met
            ? 'Objective met — ${o.competition}'
            : 'Objective missed — ${o.competition}',
        body: o.met
            ? 'The board asked you to $demand at the ${o.competition}. '
                  'You finished $finish. They have what they asked for.'
            : 'The board asked you to $demand at the ${o.competition}. '
                  'You finished $finish. That is short of what was expected.',
        year: career.inGameDate.year,
      );
    }
  }

  Future<void> _progress(int careerId) async {
    await _drawWorldCupQualifyingIfDue(careerId);
    await _progressWorldCup(careerId);
    await _progressContinental(careerId);
    await _progressNationsLeague(careerId);
    await _progressFinalissima(careerId);
  }

  /// Draws World Cup qualifying once the cycle reaches it.
  ///
  /// It used to be written with the rest of the calendar on the cycle's first
  /// day, so the World Cup groups existed before the continental championship
  /// that comes first had been played, and its "draw" ceremony was a replay of
  /// fixtures that had been in the database for two years. Drawing it here
  /// puts it in its proper place in the calendar.
  ///
  /// Drawn as soon as the manager's continental championship has a winner —
  /// that is the moment the cycle's first half is over — with the calendar date
  /// as a fallback.
  ///
  /// The fallback is not optional. `advance` moves the clock to the next
  /// unplayed fixture, so if the cup somehow never crowned a champion the
  /// calendar would empty, the date would stop, and a date-only trigger could
  /// never arrive: the save would stall with nothing left to play. Either
  /// condition alone is enough to draw.
  Future<void> _drawWorldCupQualifyingIfDue(int careerId) async {
    final career = await _careers.byId(careerId);
    if (career == null) return;
    final wcYear = finalsYear(career.cyclePointer);
    if (await _comp.hasTournament(
      careerId,
      CompetitionKind.worldCupQualifying,
    )) {
      return;
    }
    final conf = await _managerConfederation(careerId);
    final contDecided =
        conf != null &&
        await _comp.continentalChampion(careerId, confederation: conf) != null;
    if (!contDecided &&
        !CareerService.wcQualifyingDue(career.inGameDate, wcYear)) {
      return;
    }
    // Seed the pots from the LIVE ranking, snapshotted here so the ceremony
    // reproduces exactly the pots the draw used. It used to read the cycle-start
    // baseline, frozen two years earlier — a nation that had climbed to number
    // one in the meantime was still drawn out of the pot it started the cycle
    // in, which is the one thing a draw must never get wrong.
    await _ensureRank(careerId);
    final nations = await _nationsById();
    final seedRank = _liveRankById(nations);
    await _ref
        .read(seedRankingRepositoryProvider)
        .snapshot(
          careerId,
          drawSeedCycle(career.cyclePointer, drawSlotWorldCupQualifying),
          seedRank,
        );
    await CareerService.buildWorldCupQualifying(
      comp: _comp,
      nations: nations.values.toList(),
      careerId: careerId,
      nationId: career.nationId,
      rngSeed: career.rngSeed,
      cycle: career.cyclePointer,
      wcYear: wcYear,
      rankById: seedRank.isEmpty ? null : seedRank,
    );
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
          if (t.standings.isNotEmpty && NationsCup.tierOfGroupName(t.name) == 0)
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
        date: (await _maxDate(
          careerId,
          'NSF',
          kind: kind,
        )).add(const Duration(days: 3)),
      );
      return;
    }

    final f = finalFx.first;
    if (!f.hasResult) return;
    await _recordNationsLeagueHonour(
      careerId,
      _winner(f),
      _loser(f),
      finalFixture: f,
    );
  }

  Future<void> _recordNationsLeagueHonour(
    int careerId,
    int champion,
    int? runnerUp, {
    Fixture? finalFixture,
  }) async {
    final career = await _careers.byId(careerId);
    if (career == null) return;
    final year = finalsYear(career.cyclePointer) - 2;
    if (await _comp.hasHonour(careerId, 'Nations Cup', year)) return;
    // Store the final's scoreline champion-first, so the past-winners card
    // shows the result rather than a bare "beat".
    final f = finalFixture;
    final scored = f != null && f.hasResult;
    final champIsHome = scored && _winner(f) == f.homeNationId;
    await _comp.recordHonour(
      careerId: careerId,
      year: year,
      competition: 'Nations Cup',
      championId: champion,
      runnerUpId: runnerUp ?? champion,
      finalHomeScore: !scored
          ? null
          : (champIsHome ? f.homeScore : f.awayScore),
      finalAwayScore: !scored
          ? null
          : (champIsHome ? f.awayScore : f.homeScore),
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

    final existing = await _comp.fixturesByRound(
      careerId,
      'FFINAL',
      kind: kind,
    );
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
    // Champion-first scoreline, so the record shows the result, not "beat".
    final champIsHome = _winner(f) == f.homeNationId;
    await _comp.recordHonour(
      careerId: careerId,
      year: year,
      competition: 'Continental Clash',
      championId: _winner(f),
      runnerUpId: _loser(f),
      finalHomeScore: champIsHome ? f.homeScore : f.awayScore,
      finalAwayScore: champIsHome ? f.awayScore : f.homeScore,
    );
  }

  Future<void> _progressWorldCup(int careerId) async {
    if (!await _comp.hasFinals(careerId)) {
      if (await _comp.allQualifyingPlayed(careerId)) {
        await _progressPlayoff(careerId);
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

  /// Progresses EVERY confederation's championship, not only the manager's.
  ///
  /// The rest of the world's cups used to be created and then never played, so
  /// the only continent that ever put goals and caps on the record was the one
  /// the manager happened to be working in — the all-time world records read as
  /// a chart of a single confederation. It also meant the Continental Clash
  /// could only ever happen for a European or South American manager, since it
  /// needs both of those champions on the honours roll.
  ///
  /// The manager's own cup is progressed first so nothing about their season
  /// depends on the order the others resolve in.
  Future<void> _progressContinental(int careerId) async {
    final mine = await _managerConfederation(careerId);
    if (mine == null) return;
    await _progressContinentalFor(careerId, mine, isManagers: true);
    for (final conf in Confederation.values) {
      if (conf == mine) continue;
      await _progressContinentalFor(careerId, conf, isManagers: false);
    }
  }

  /// Progresses one confederation's championship from its group stage through
  /// to its final, recording the honour once it is decided.
  Future<void> _progressContinentalFor(
    int careerId,
    Confederation conf, {
    required bool isManagers,
  }) async {
    const kind = CompetitionKind.continentalFinals;
    // Already decided this cycle: nothing to advance, and this is by far the
    // cheapest way to say so — `_progress` runs up to forty times in a single
    // catch-up, and there are six cups to look at on every one of those passes.
    final cupName = ContinentalCups.byConfederation[conf]?.name;
    if (cupName != null) {
      final career = await _careers.byId(careerId);
      if (career == null) return;
      final cupYear = finalsYear(career.cyclePointer) - 2;
      if (await _comp.hasHonour(careerId, cupName, cupYear)) return;
    }
    // EVERY confederation's championship lives in this cycle as a competition
    // of this same kind, so a lookup that doesn't name the confederation picks
    // an arbitrary one. That let the manager's own cup be left undrawn (another
    // continent's existed, so "we already have a continental tournament" read
    // true) and another continent's bracket be advanced and recorded in its
    // place — after which the board's continental objective could never be
    // graded, because the manager's cup had no champion.
    if (!await _comp.hasTournament(careerId, kind, confederation: conf)) {
      // Once THIS confederation's qualifying is complete, draw its finals from
      // its own qualifiers. Every qualifying confederation now runs a campaign,
      // so every one of them draws its field the same way the manager's does —
      // and each lookup names its confederation, because all six live in this
      // cycle under the same competition kind.
      if (await _comp.hasTournament(
            careerId,
            CompetitionKind.continentalQualifying,
            confederation: conf,
          ) &&
          await _comp.allPlayedForKind(
            careerId,
            CompetitionKind.continentalQualifying,
            confederation: conf,
          )) {
        await _generateContinentalFinals(careerId, conf, isManagers: isManagers);
      }
      return;
    }

    // Group stage → first knockout round, once every group game is played. The
    // round depends on how many teams advance: a 24-team cup (6 groups) sends
    // the top two plus the four best third-placed teams into a round of 16; a
    // 16-team cup (4 groups) opens at the quarter-finals; an 8-team cup (2
    // groups) at the semi-finals.
    final tables = await _comp.tournamentGroupTables(
      careerId,
      kind,
      confederation: conf,
    );
    if (tables.isNotEmpty) {
      final standings = tables.map((t) => t.standings).toList();
      // Copa América: two groups of five, the top four of each into the
      // quarter-finals (only the fifth-placed side goes out).
      final copa = tables.length == 2 && standings.every((s) => s.length >= 5);
      final bestThirds = WorldCupFinals.bestThirdsFor(tables.length);
      final firstRound = copa
          ? 'CQF'
          : switch (tables.length) {
              6 => 'CR16',
              4 => 'CQF',
              _ => 'CSF',
            };
      final started = (await _comp.fixturesByRound(
        careerId,
        firstRound,
        kind: kind,
        confederation: conf,
      )).isNotEmpty;
      if (!started) {
        if (!await _roundComplete(
          careerId,
          'CGROUP',
          kind: kind,
          confederation: conf,
        )) {
          return;
        }
        await _comp.addKnockoutFixtures(
          careerId: careerId,
          round: firstRound,
          kind: kind,
          confederation: conf,
          pairings: copa
              ? WorldCupFinals.copaQuarters(standings)
              : bestThirds > 0
              ? WorldCupFinals.knockoutWithThirds(standings, bestThirds)
              : WorldCupFinals.knockoutFromGroups(standings),
          date: (await _maxDate(
            careerId,
            'CGROUP',
            kind: kind,
            confederation: conf,
          )).add(const Duration(days: 7)),
        );
        return;
      }
    }

    await _advanceTournamentKnockout(
      careerId,
      kind,
      prefix: 'C',
      thirdPlace: false,
      confederation: conf,
    );
    await _recordContinentalHonourIfDecided(careerId, conf);
  }

  /// The confederation of the nation the manager currently leads — the one
  /// whose continental championship is theirs to play.
  Future<Confederation?> _managerConfederation(int careerId) async {
    final career = await _careers.byId(careerId);
    if (career == null) return null;
    return (await _nationsById())[career.nationId]?.confederation;
  }

  /// Advances a knockout from its first round to the final (and, for the World
  /// Cup, the third-place game). The R16 step is a no-op for brackets that start
  /// later (e.g. an 8-team continental cup that opens at the quarter-finals).
  /// [prefix] namespaces the round labels so the continental cup is distinct
  /// from the World Cup.
  ///
  /// [thirdPlace] is true only for the World Cup: the continental championships
  /// (like the real European Championship) have NO third-place play-off — the
  /// two beaten semi-finalists share the bronze finish and no extra match is
  /// scheduled.
  Future<void> _advanceTournamentKnockout(
    int careerId,
    CompetitionKind kind, {
    String prefix = '',
    bool thirdPlace = true,
    Confederation? confederation,
  }) async {
    final r32 = '${prefix}R32';
    final r16 = '${prefix}R16';
    final qf = '${prefix}QF';
    final sf = '${prefix}SF';
    final third = '${prefix}3RD';
    final fin = '${prefix}FINAL';

    // The R32 step is a no-op for brackets that start later (continental cups
    // open at the quarter- or semi-finals — their R32 round never exists).
    await _advanceRound(
      careerId,
      r32,
      r16,
      4,
      kind: kind,
      confederation: confederation,
    );
    await _advanceRound(
      careerId,
      r16,
      qf,
      4,
      kind: kind,
      confederation: confederation,
    );
    await _advanceRound(
      careerId,
      qf,
      sf,
      4,
      kind: kind,
      confederation: confederation,
    );

    if ((await _comp.fixturesByRound(
              careerId,
              fin,
              kind: kind,
              confederation: confederation,
            ))
            .isEmpty &&
        await _roundComplete(
          careerId,
          sf,
          kind: kind,
          confederation: confederation,
        )) {
      final semis = await _comp.fixturesByRound(
        careerId,
        sf,
        kind: kind,
        confederation: confederation,
      );
      final afterSemis = await _maxDate(
        careerId,
        sf,
        kind: kind,
        confederation: confederation,
      );
      // The play-off comes first and the final closes the tournament, on their
      // own days — sharing one date collapsed them into a single round popup
      // titled after the play-off, so the final was never its own moment.
      if (thirdPlace) {
        await _comp.addKnockoutFixtures(
          careerId: careerId,
          round: third,
          kind: kind,
          confederation: confederation,
          pairings: WorldCupFinals.pairWinners(semis.map(_loser).toList()),
          date: afterSemis.add(const Duration(days: 5)),
        );
      }
      await _comp.addKnockoutFixtures(
        careerId: careerId,
        round: fin,
        kind: kind,
        confederation: confederation,
        pairings: WorldCupFinals.pairWinners(semis.map(_winner).toList()),
        date: afterSemis.add(const Duration(days: 7)),
      );
    }

    // Repair saves whose play-off and final were scheduled on the SAME day
    // (before the split above): push an unplayed final onto its own later day.
    if (!thirdPlace) return;
    final finFx = await _comp.fixturesByRound(
      careerId,
      fin,
      kind: kind,
      confederation: confederation,
    );
    final thirdFx = await _comp.fixturesByRound(
      careerId,
      third,
      kind: kind,
      confederation: confederation,
    );
    if (finFx.isNotEmpty && thirdFx.isNotEmpty) {
      final f = finFx.first;
      if (!f.hasResult && !f.date.isAfter(thirdFx.first.date)) {
        await _comp.rescheduleFixture(
          f.id,
          thirdFx.first.date.add(const Duration(days: 2)),
        );
      }
    }
  }

  /// Draws the continental finals (a group stage) from the teams that came
  /// through continental qualifying, mirroring the World Cup finals draw.
  Future<void> _generateContinentalFinals(
    int careerId,
    Confederation conf, {
    required bool isManagers,
  }) async {
    final career = await _careers.byId(careerId);
    if (career == null) return;
    final nations = await _nationsById();
    final cont = ContinentalCups.byConfederation[conf];
    if (cont == null) return;

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
    // Named confederation: every confederation's qualifying is a competition of
    // this same kind now, so an unqualified lookup would seed this continent's
    // finals out of another continent's group tables.
    final tables = await _comp.tournamentGroupTables(
      careerId,
      CompetitionKind.continentalQualifying,
      confederation: conf,
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
    // Pot the continental finals by the LIVE ranking (post-qualifying),
    // snapshotted so the draw ceremony reproduces the same pots.
    await _ensureRank(careerId);
    final rankingById = _liveRankById(nations);
    await _ref
        .read(seedRankingRepositoryProvider)
        .snapshot(
          careerId,
          drawSeedCycle(career.cyclePointer, drawSlotContinentalFinals),
          rankingById,
        );
    final draw = WorldCupFinals.drawGroups(
      qualifierIds: field,
      rankingById: rankingById,
      rngSeed: career.rngSeed ^ (career.cyclePointer * 0x71) ^ 0xC0FF,
      hosts: hosts,
      perGroup: cont.groupSize,
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

    // If the manager's nation didn't make the field, their continental
    // qualifying campaign fell short. Only ever filed for their OWN continent —
    // every confederation draws its finals through here now, and a manager does
    // not need telling they missed out on a cup they were never in.
    if (isManagers && !field.contains(career.nationId)) {
      final year = wcYear - 2;
      await _comp.addMessage(
        careerId: careerId,
        dedupKey: 'contmiss:$year',
        category: 'eliminated',
        title: '${cont.name} missed',
        body:
            "You didn't qualify for ${cont.name} — the campaign came up "
            'short this time.',
        year: year - 1,
      );
    }
  }

  /// Records [conf]'s continental championship to the honours roll once its
  /// final is played (so the played result — not the background sim — counts).
  /// Every confederation's cup is recorded, so the world's honours roll is
  /// complete and the Continental Clash always has two champions to call on.
  Future<void> _recordContinentalHonourIfDecided(
    int careerId,
    Confederation conf,
  ) async {
    const kind = CompetitionKind.continentalFinals;
    final career = await _careers.byId(careerId);
    if (career == null) return;
    final nations = await _nationsById();

    // THIS confederation's final: every confederation's cup is a competition of
    // this kind, and an unqualified lookup could hand back another continent's
    // final and file it under the wrong competition.
    final finals = await _comp.fixturesByRound(
      careerId,
      'CFINAL',
      kind: kind,
      confederation: conf,
    );
    if (finals.isEmpty || !finals.first.hasResult) return;
    final f = finals.first;
    final year = f.date.year;

    final name = ContinentalCups.byConfederation[conf]?.name;
    if (name == null) return;
    if (await _comp.hasHonour(careerId, name, year)) return;

    // No third-place play-off in the continental championships — the two beaten
    // semi-finalists SHARE the bronze, so record both as third place.
    final semis = await _comp.fixturesByRound(
      careerId,
      'CSF',
      kind: kind,
      confederation: conf,
    );
    final bronzes = [
      for (final s in semis)
        if (s.hasResult) _loser(s),
    ];
    final boot = await _comp.topScorers(
      careerId,
      kind: kind,
      confederation: conf,
      limit: 1,
    );
    String? bootName;
    int? bootGoals;
    if (boot.isNotEmpty) {
      bootName =
          (await _ref
                  .read(playerRepositoryProvider)
                  .byId(
                    boot.first.playerId,
                    agingYears: _simYears,
                    saveSeed: _simSeed,
                  ))
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
      thirdId: bronzes.isNotEmpty ? bronzes[0] : null,
      thirdId2: bronzes.length > 1 ? bronzes[1] : null,
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
      final p = await _ref
          .read(playerRepositoryProvider)
          .byId(
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

    // The finals didn't move the ranking live; settle the whole tournament now,
    // heavier than any qualifier, so the champion's run is the cycle's biggest
    // ranking swing and it lands as one update after the final.
    await _settleWorldCupRanking(careerId);

    await _simulateContinentalCups(careerId, year);
  }

  /// A BACKSTOP for any confederation whose championship never got played.
  ///
  /// Every confederation's cup is now drawn when the cycle is built and played
  /// out in its own window alongside the manager's (see [_progressContinental]),
  /// which is what puts the world's goals, caps and honours on the record at the
  /// right time — and what lets the Continental Clash find both its champions in
  /// the year it is meant to be staged. This runs after the World Cup final and
  /// only picks up a cup that somehow has neither a tournament nor an honour
  /// (an older save, or a cycle whose draw never happened), so a continent is
  /// never left with a missing edition.
  Future<void> _simulateContinentalCups(int careerId, int wcYear) async {
    final year = wcYear - 2;
    final career = await _careers.byId(careerId);
    if (career == null) return;
    final nations = await _ref.read(nationRepositoryProvider).all();

    for (final entry in ContinentalCups.byConfederation.entries) {
      final cont = entry.value;
      if (await _comp.hasHonour(careerId, cont.name, year)) continue;
      // Already drawn (and being played, or waiting on a round) — leave it to
      // the normal progression rather than drawing a second competition of the
      // same kind and confederation on top of it.
      if (await _comp.hasTournament(
        careerId,
        CompetitionKind.continentalFinals,
        confederation: entry.key,
      )) {
        continue;
      }

      final members =
          nations.where((n) => n.confederation == entry.key).toList()
            ..sort((a, b) => a.ranking.compareTo(b.ranking));
      if (members.length < 4) continue;

      await _simulateBackgroundCup(
        careerId: careerId,
        confederation: entry.key,
        year: year,
        career: career,
        allNations: nations,
        members: members,
      );

      // No message is filed here: every cup result is announced from its
      // honour row by the message service, which reads the scoreline recorded
      // just above. Announcing it here too filed each background cup's title
      // twice.
    }
  }

  /// Plays and persists one confederation's continental championship in full —
  /// group stage then knockout — and records its honour with the real final
  /// scoreline and golden boot. Deterministic from the save seed.
  Future<void> _simulateBackgroundCup({
    required int careerId,
    required Confederation confederation,
    required int year,
    required Career career,
    required List<Nation> allNations,
    required List<Nation> members,
  }) async {
    final cont = ContinentalCups.byConfederation[confederation]!;
    final nationsById = {for (final n in allNations) n.id: n};
    final rngSeed = career.rngSeed ^ (year * 0x33) ^ confederation.index;

    // Seed the finals field straight from the confederation ranking, into
    // groups of four (the largest power-of-the-format that fits).
    final field = members.take(cont.size).map((n) => n.id).toList();
    final draw = WorldCupFinals.drawGroups(
      qualifierIds: field,
      rankingById: {for (final n in allNations) n.id: n.ranking},
      rngSeed: rngSeed ^ 0xC0FF,
      perGroup: cont.groupSize,
    );
    if (draw.groups.isEmpty) return;

    await _comp.saveTournamentGroups(
      careerId: careerId,
      cycle: career.cyclePointer,
      confederation: confederation,
      kind: CompetitionKind.continentalFinals,
      name: cont.name,
      draw: draw,
      groupStart: DateTime(year, cont.month, 8),
      round: 'CGROUP',
    );

    const kind = CompetitionKind.continentalFinals;
    Future<List<Fixture>> byRound(String r) => _comp.fixturesByRound(
      careerId,
      r,
      kind: kind,
      confederation: confederation,
    );
    Future<void> simRound(String r) async {
      for (final f in await byRound(r)) {
        if (!f.hasResult) await _simAndRecord(f, nationsById, rngSeed);
      }
    }

    Future<DateTime> lastDate(String r) async => (await byRound(
      r,
    )).map((f) => f.date).reduce((a, b) => a.isAfter(b) ? a : b);

    // Group stage.
    await simRound('CGROUP');

    // First knockout round from the group tables (R16 / QF / SF by field size),
    // then advance round by round to the final + third-place play-off.
    final tables = await _comp.tournamentGroupTables(
      careerId,
      kind,
      confederation: confederation,
    );
    final standings = tables.map((t) => t.standings).toList();
    // Copa América: two groups of five, top four of each into the quarters.
    final copa = tables.length == 2 && standings.every((s) => s.length >= 5);
    final bestThirds = WorldCupFinals.bestThirdsFor(tables.length);
    final ladder = copa
        ? ['CQF', 'CSF']
        : switch (tables.length) {
            6 => ['CR16', 'CQF', 'CSF'],
            4 => ['CQF', 'CSF'],
            _ => ['CSF'],
          };
    final firstRound = ladder.first;
    await _comp.addKnockoutFixtures(
      careerId: careerId,
      round: firstRound,
      kind: kind,
      confederation: confederation,
      pairings: copa
          ? WorldCupFinals.copaQuarters(standings)
          : bestThirds > 0
          ? WorldCupFinals.knockoutWithThirds(standings, bestThirds)
          : WorldCupFinals.knockoutFromGroups(standings),
      date: (await lastDate('CGROUP')).add(const Duration(days: 5)),
    );
    // Play each round, seeding the next from its winners — straight to the
    // final. Continental championships have no third-place play-off.
    for (var i = 0; i < ladder.length; i++) {
      final round = ladder[i];
      await simRound(round);
      final winners = (await byRound(round)).map(_winner).toList();
      final next = i + 1 < ladder.length ? ladder[i + 1] : 'CFINAL';
      final base = (await lastDate(round)).add(const Duration(days: 4));
      await _comp.addKnockoutFixtures(
        careerId: careerId,
        round: next,
        kind: kind,
        confederation: confederation,
        pairings: WorldCupFinals.pairWinners(winners),
        date: base,
      );
    }
    await simRound('CFINAL');

    // Record the honour from the real final + golden boot. The continental
    // cups have no third-place play-off, so BOTH beaten semi-finalists share
    // the bronze — record the two 'CSF' losers as third place.
    final finals = await byRound('CFINAL');
    if (finals.isEmpty || !finals.first.hasResult) return;
    final f = finals.first;
    final bronzes = [
      for (final s in await byRound('CSF'))
        if (s.hasResult) _loser(s),
    ];
    final boot = await _comp.topScorers(
      careerId,
      kind: kind,
      confederation: confederation,
      limit: 1,
    );
    String? bootName;
    int? bootGoals;
    if (boot.isNotEmpty) {
      bootName =
          (await _ref
                  .read(playerRepositoryProvider)
                  .byId(
                    boot.first.playerId,
                    agingYears: _simYears,
                    saveSeed: _simSeed,
                  ))
              ?.name;
      bootGoals = boot.first.goals;
    }
    final champIsHome = f.homeScore! >= f.awayScore!;
    await _comp.recordHonour(
      careerId: careerId,
      year: year,
      competition: cont.name,
      championId: _winner(f),
      runnerUpId: _loser(f),
      thirdId: bronzes.isNotEmpty ? bronzes[0] : null,
      thirdId2: bronzes.length > 1 ? bronzes[1] : null,
      hostId: members.first.id,
      finalHomeScore: champIsHome ? f.homeScore : f.awayScore,
      finalAwayScore: champIsHome ? f.awayScore : f.homeScore,
      topScorerName: bootName,
      topScorerGoals: bootGoals,
    );
  }

  Future<void> _advanceRound(
    int careerId,
    String from,
    String to,
    int plusDays, {
    CompetitionKind kind = CompetitionKind.worldCupFinals,
    Confederation? confederation,
  }) async {
    if ((await _comp.fixturesByRound(
      careerId,
      to,
      kind: kind,
      confederation: confederation,
    )).isNotEmpty) {
      return;
    }
    if (!await _roundComplete(
      careerId,
      from,
      kind: kind,
      confederation: confederation,
    )) {
      return;
    }
    final fx = await _comp.fixturesByRound(
      careerId,
      from,
      kind: kind,
      confederation: confederation,
    );
    await _comp.addKnockoutFixtures(
      careerId: careerId,
      round: to,
      kind: kind,
      confederation: confederation,
      pairings: WorldCupFinals.pairWinners(fx.map(_winner).toList()),
      date: (await _maxDate(
        careerId,
        from,
        kind: kind,
        confederation: confederation,
      )).add(Duration(days: plusDays)),
    );
  }

  /// The World Cup finals year for a cycle (clean 4-year cadence: 2030, 2034…).
  static int finalsYear(int cycle) => CareerService.worldCupYear(cycle);

  /// The intercontinental play-off round code. It ends in `FINAL` so [Rounds]
  /// treats it as a knockout — a level tie is settled on penalties like any
  /// other, giving a clean winner.
  static const _poRound = 'POFINAL';

  /// Between qualifying ending and the finals being drawn, resolve the
  /// intercontinental play-off.
  ///
  /// When the manager's nation is NOT among the six entrants (the common case)
  /// this generates the finals exactly as before — the tie is decided instantly,
  /// zero behaviour change. When they ARE an entrant, their tie becomes a real,
  /// playable knockout: the finals wait until they've played it, then the real
  /// winner is fed into finalist selection. Any unexpected pool shape falls back
  /// to the instant path, so this can never stall the cycle.
  Future<void> _progressPlayoff(int careerId) async {
    final career = await _careers.byId(careerId);
    if (career == null) return;

    final tables = await _comp.allGroupTablesByConfederation(careerId);
    final grouped = <Confederation, List<List<GroupStanding>>>{};
    for (final t in tables) {
      (grouped[t.confederation] ??= []).add(t.standings);
    }
    await _ensureRank(careerId);
    final nations = await _nationsById();
    final rankingById = _liveRankById(nations);
    final pool = WorldCupFinals.playoffPoolFor(
      byConfederation: grouped,
      rankingById: rankingById,
    );
    final me = career.nationId;

    // Not the standard six, or the manager sits it out → decide instantly, as
    // the game always has.
    if (pool.length != 6 || !pool.contains(me)) {
      await _generateFinals(careerId);
      return;
    }

    final existing = await _comp.fixturesByRound(
      careerId,
      _poRound,
      kind: CompetitionKind.worldCupPlayoff,
    );
    if (existing.isEmpty) {
      // The manager's tie for a World Cup place: a one-off knockout against the
      // strongest rival in the pool. Dated just ahead so it's their next match
      // (never in the past, where the catch-up sim would take it off them).
      final rival = pool.firstWhere((id) => id != me);
      await _comp.createKnockout(
        careerId: careerId,
        cycle: career.cyclePointer,
        confederation: nations[me]?.confederation ?? Confederation.europe,
        kind: CompetitionKind.worldCupPlayoff,
        name: 'Intercontinental Play-off',
        pairings: [(me, rival)],
        date: career.inGameDate.add(const Duration(days: 7)),
        firstRound: _poRound,
      );
      return;
    }

    final tie = existing.first;
    if (!tie.hasResult) return; // still to be played

    // Played. The manager's berth goes to whoever won their tie; the other berth
    // goes to the best remaining entrant. Both feed into finalist selection so
    // the field reflects what was actually played.
    final winner = _winner(tie);
    final rivalId = tie.homeNationId == me
        ? tie.awayNationId
        : tie.homeNationId;
    final other = pool.firstWhere((id) => id != me && id != rivalId);
    await _generateFinals(careerId, playoffWinners: [winner, other]);
    // The manager just played their tie live, so skip the RNG display bracket —
    // but still satisfy the finals-draw gate that waits on the play-off "draw"
    // being seen (the constant is 'worldCupPlayoff', see hub_event.dart).
    await _comp.markDrawWatched(
      careerId,
      career.cyclePointer,
      'worldCupPlayoff',
    );
  }

  Future<void> _generateFinals(
    int careerId, {
    List<int>? playoffWinners,
  }) async {
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
    // Pot the finals by the LIVE world ranking as it stands now — after every
    // qualifying result — not the ranking frozen at the cycle's start. The
    // exact ranking used is snapshotted so the draw ceremony reproduces these
    // pots precisely.
    await _ensureRank(careerId);
    final rankingById = _liveRankById(nations);
    await _ref
        .read(seedRankingRepositoryProvider)
        .snapshot(
          careerId,
          drawSeedCycle(career.cyclePointer, drawSlotWorldCupFinals),
          rankingById,
        );
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
      // When the manager played their own play-off tie, its real winners are
      // passed in and override the instant resolution below.
      playoffWinnersOverride: playoffWinners,
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

    // The field is set — if the manager's nation isn't in it, their qualifying
    // campaign came up short.
    if (!qualifiers.contains(career.nationId)) {
      await _comp.addMessage(
        careerId: careerId,
        dedupKey: 'wcmiss:$year',
        category: 'eliminated',
        title: 'World Cup dream over',
        body:
            "You didn't make the $year World Cup — the qualifying campaign "
            'fell short. Four more years.',
        year: year - 1,
      );
    }
  }

  /// Starts the next 4-year cycle once the current World Cup is decided:
  /// re-draws every confederation's qualifiers and advances the calendar.
  /// Rolls into the next cycle. [switchToNationId] moves the manager to a new
  /// nation (an accepted offer or a forced move after the sack); [boardTitle]/
  /// [boardBody], when given, are filed as a board-verdict message.
  ///
  /// Queued, never dropped — the rollover would be lost. See [_exclusive].
  Future<void> startNextCycle(
    int careerId, {
    int? switchToNationId,
    String? boardTitle,
    String? boardBody,
    FederationInvestment? nextInvestment,
  }) => _exclusive(
    () => _startNextCycle(
      careerId,
      switchToNationId: switchToNationId,
      boardTitle: boardTitle,
      boardBody: boardBody,
      nextInvestment: nextInvestment,
    ),
    dropIfBusy: false,
  );

  Future<void> _startNextCycle(
    int careerId, {
    int? switchToNationId,
    String? boardTitle,
    String? boardBody,
    FederationInvestment? nextInvestment,
  }) async {
    final career = await _careers.byId(careerId);
    if (career == null) return;
    if (await _comp.worldChampion(careerId) == null) return; // not finished

    // The board answers for every brief it set BEFORE the cycle pointer moves
    // on. Grading is normally filed the moment a tournament settles, but every
    // one of those hooks hangs off a step of the world; a cycle that ends
    // without one (the last act being a foreign final, say) used to roll over
    // with an objective still ungraded, and once the pointer moved the cycle's
    // fixtures were out of reach and the verdict could never be filed at all.
    // Deduped per cycle and tier, so this is a no-op when it already landed.
    await _gradeObjectivesIfDecided(careerId);

    // Settle the finishing cycle's finances: bank income, then commit the
    // manager's allocation for the cycle about to begin.
    final income = await _ref
        .read(federationServiceProvider)
        .incomeForCycle(careerId, career.cyclePointer);
    var budget =
        career.budget + income.grant + income.prize + income.commercial;
    if (nextInvestment != null) {
      final spend =
          nextInvestment.youth +
          nextInvestment.commercial +
          nextInvestment.medical +
          nextInvestment.naturalization +
          nextInvestment.boardRelations;
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
              winner: t.standings.first,
              bottom: t.standings.last,
            ),
      ];
      ncTiers = NationsCup.promoteRelegate(tiers: ncTiers, groups: groups);
      await _careers.setNationsCupTiers(careerId, ncTiers);
    }

    if (switchToNationId != null && switchToNationId != career.nationId) {
      await _careers.switchNation(careerId, switchToNationId);
      await _resetSquadForNewNation(careerId, switchToNationId, career);
      // A new nation means an unfamiliar squad — the drilled-shape bonus resets.
      await _ref.read(tacticFamiliarityRepositoryProvider).reset(careerId);
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

    // The naturalisation roll is NOT done here: the cycle's naturalisation
    // budget isn't allocated until the forced budget-setup event that opens the
    // new cycle, so rolling now would always see zero investment. It is rolled
    // from [rollNaturalization], called once the budget is confirmed.

    // The ranking screen's data is auto-disposed but can be kept alive by a
    // listener elsewhere (careers list, vitrine) — refresh it explicitly so
    // the full ranking always shows the points the sim just moved.
    _ref
      ..invalidate(hubDataProvider)
      ..invalidate(worldRankingProvider)
      ..invalidate(rankHistoryProvider)
      // The board's brief and its mood are derived from fixtures the sim has
      // just changed, and neither reads them through a provider that would
      // notice — so they are refreshed by hand, or the hub keeps showing the
      // verdict it computed before the tournament was played.
      ..invalidate(cycleObjectiveOutcomesProvider)
      ..invalidate(cycleObjectivesProvider)
      ..invalidate(satisfactionProvider);
  }

  /// Posts transfer messages for the manager's nation's notable club moves over
  /// one calendar [year]. A player's club is derived from their overall, so a
  /// year of development (or decline) moves some of them between clubs — those
  /// are the transfers. Deterministic and idempotent (deduped per player+year),
  /// so re-running is a no-op.
  Future<void> _recordTransferYear(
    int careerId,
    int nationId,
    int saveSeed,
    int year,
  ) async {
    final agingNow = (year - CareerService.cycleStart.year).clamp(0, 400);
    final agingPrev = (agingNow - 1).clamp(0, 400);
    if (agingNow <= agingPrev) return; // save's first year — nothing before it
    final youth = await _ref.read(youthBonusByCycleProvider(careerId).future);
    final careerDev = await _ref.read(careerDevBonusProvider(careerId).future);
    final repo = _ref.read(playerRepositoryProvider);
    final before = await repo.byNation(
      nationId,
      agingYears: agingPrev,
      saveSeed: saveSeed,
      youthBonusByCycle: youth,
      careerStartsByPlayer: careerDev,
    );
    final after = await repo.byNation(
      nationId,
      agingYears: agingNow,
      saveSeed: saveSeed,
      youthBonusByCycle: youth,
      careerStartsByPlayer: careerDev,
    );
    final beforeById = {for (final p in before) p.id: p};
    // Notable players whose club changed over the year, biggest first.
    //
    // "Notable" is RELATIVE to the nation, not an absolute rating: a fixed
    // >=78 bar meant only the giants ever had a transfer window, and a manager
    // of anyone outside the top thirty nations saw an empty one every single
    // year. The bar is now the nation's own senior pool, so a minnow's best
    // players moving club is news there exactly as a superstar's move is news
    // in Brazil.
    final ranked = [...after]..sort((a, b) => b.overall.compareTo(a.overall));
    final notable = {for (final p in ranked.take(_transferPoolSize)) p.id};
    final moves = <(Player now, String fromClub)>[
      for (final p in after)
        if (notable.contains(p.id) &&
            beforeById[p.id] != null &&
            beforeById[p.id]!.club != p.club)
          (p, beforeById[p.id]!.club),
    ]..sort((a, b) => b.$1.value.compareTo(a.$1.value));

    for (final m in moves.take(3)) {
      final p = m.$1;
      final fee = _transferFee(p);
      await _comp.addMessage(
        careerId: careerId,
        dedupKey: 'transfer:${p.id}:$year',
        category: 'transfer',
        title: '${p.name} joins ${p.club}',
        body:
            '${p.name} (${p.position.label}, ${p.overall}) has left '
            '${m.$2} to sign for ${p.club} for ${_feeLabel(fee)}.',
        year: year,
      );
    }
  }

  /// Announces a new all-time record holder (leading scorer / most-capped) as a
  /// headline. Deduped per holder id, so a record only makes the news when a
  /// NEW player takes it — a threshold keeps trivial early-save "records" out.
  Future<void> _checkRecords(int careerId, Career career, int year) async {
    Future<String> nameOf(int id) async {
      final p = await _ref
          .read(playerRepositoryProvider)
          .byId(
            id,
            agingYears: CareerService.agingYears(career),
            saveSeed: career.rngSeed,
          );
      return p?.name ?? 'A new record-breaker';
    }

    final scorers = await _comp.allTimeTopScorers(careerId, limit: 1);
    if (scorers.isNotEmpty && scorers.first.goals >= 30) {
      final s = scorers.first;
      await _comp.addMessage(
        careerId: careerId,
        dedupKey: 'record:scorer:${s.playerId}',
        category: 'record',
        title: 'All-time top scorer',
        body:
            '${await nameOf(s.playerId)} is now the game\'s all-time leading '
            'goalscorer with ${s.goals} goals.',
        year: year,
      );
    }
    final caps = await _comp.allTimeTopAppearances(careerId, limit: 1);
    if (caps.isNotEmpty && caps.first.games >= 70) {
      final c = caps.first;
      await _comp.addMessage(
        careerId: careerId,
        dedupKey: 'record:caps:${c.playerId}',
        category: 'record',
        title: 'Most-capped player',
        body:
            '${await nameOf(c.playerId)} is now the game\'s most-capped '
            'player with ${c.games} appearances.',
        year: year,
      );
    }
  }

  /// How deep into a nation's pool a club move still counts as news: the
  /// nation's top ten, so the window reports the players a manager would
  /// actually recognise rather than the hundredth man on the depth chart.
  ///
  /// This is the dial that decides how BUSY a transfer window looks, and it was
  /// set far too deep at first. With sixteen players in scope, more than three
  /// of them moved in 69% of years — so the `take(3)` cap below was doing all
  /// the work and every window reported exactly three transfers. Measured over
  /// five nations × 16 years, ten in scope gives a mean of 1.4 moves a year and
  /// hits the cap in 18% of them: sometimes none, usually one or two,
  /// occasionally a full three.
  static const int _transferPoolSize = 10;

  /// A plausible transfer fee: the player's value with a deterministic premium
  /// (a fee usually tops the book value), so a marquee move reads big.
  ///
  /// Floored well above zero — [Player.value] is zero for anyone under 44
  /// overall, which would have every move in a smaller nation announced as a
  /// free transfer.
  int _transferFee(Player p) {
    final premium = 1.0 + (p.id.abs() % 60) / 100; // 1.00–1.59×
    final floor = 100000 + (p.overall.clamp(20, 99) * 6000);
    return (p.value * premium).round().clamp(floor, 1 << 62);
  }

  /// Formats a euro fee compactly: €X.XM / €XXXk / €X.
  String _feeLabel(int euros) {
    if (euros >= 1000000) {
      return '€${(euros / 1000000).toStringAsFixed(euros >= 10000000 ? 0 : 1)}M';
    }
    if (euros >= 1000) return '€${(euros / 1000).round()}k';
    return '€$euros';
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
    final players = await _ref
        .read(playerRepositoryProvider)
        .byNation(
          nationId,
          agingYears: CareerService.agingYears(career),
          saveSeed: career.rngSeed,
        );
    const formation = Formation.f433;
    await _ref
        .read(tacticsRepositoryProvider)
        .saveTactic(
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
  /// Rolls this cycle's naturalisation offer, weighted by the naturalisation
  /// budget just allocated for it. Called from the budget-setup event, so the
  /// investment is in place when the chance is computed (a strong naturalisation
  /// spend should make an offer likely). No-op if it can't run.
  Future<void> rollNaturalization(int careerId) async {
    final career = await _careers.byId(careerId);
    if (career == null) return;
    final nations = await _nationsById();
    await _maybeGenerateNaturalizationOffer(
      careerId,
      career.nationId,
      career.cyclePointer,
      career.inGameDate,
      nations,
    );
  }

  /// Rolls the cycle's naturalization interest at a seed-derived random point in
  /// the cycle (not tied to setting the budget), once per cycle. An approach
  /// from a foreign talent can then arrive at any time rather than always right
  /// after the budget is confirmed.
  Future<void> _rollNaturalizationIfDue(int careerId) async {
    final career = await _careers.byId(careerId);
    if (career == null) return;
    final cycle = career.cyclePointer;
    if (await _comp.hasWatchedDraw(careerId, cycle, 'natzrolled')) return;
    // A seed-derived due date between ~three and one years before the World Cup.
    final wcYear = CareerService.worldCupYear(cycle);
    final rng = SeededRng(career.rngSeed ^ (cycle * 0x2717) ^ 0x9A72CE);
    final due = DateTime(wcYear - 1 - rng.nextInt(3), 1 + rng.nextInt(12));
    if (career.inGameDate.isBefore(due)) return; // not time yet
    await _comp.markDrawWatched(careerId, cycle, 'natzrolled');
    await rollNaturalization(careerId);
  }

  Future<void> _maybeGenerateNaturalizationOffer(
    int careerId,
    int nationId,
    int nextCycle,
    DateTime cycleStart,
    Map<int, Nation> nations,
  ) async {
    final invest = await _careers.investment(careerId, nextCycle);
    final chance = FederationFinance.naturalizationChance(
      invest.naturalization,
    );
    final career = await _careers.byId(careerId);
    if (career == null) return;

    final others = nations.values.where((n) => n.id != nationId).toList()
      ..sort((a, b) => a.ranking.compareTo(b.ranking)); // strongest first
    if (others.isEmpty) return;
    final playerRepo = _ref.read(playerRepositoryProvider);
    final agingYears = (cycleStart.year - CareerService.cycleStart.year).clamp(
      0,
      400,
    );

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
          ? others
                .take(20)
                .toList() // only strong nations breed stars
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
        body:
            '${pick.name}, a ${pick.age}-year-old '
            '${pick.position.name} rated ${pick.overall} currently with $from, '
            '${pick.overall >= 85 ? 'is a star name who ' : ''}'
            'has family ties to $to and is open to switching. '
            'Open the Naturalisation offer to accept or decline.',
        year: finalsYear(nextCycle),
      );
    }
  }
}

final Provider<SeasonService> seasonServiceProvider = Provider(
  SeasonService.new,
);
