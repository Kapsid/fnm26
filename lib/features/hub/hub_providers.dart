import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/core/util/competition_label.dart';
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
import 'package:fnm/domain/services/competition/finals_participation.dart';
import 'package:fnm/domain/services/competition/group_advancement.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/domain/services/competition/nations_cup.dart';
import 'package:fnm/domain/services/competition/qualification.dart';
import 'package:fnm/domain/services/competition/rounds.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/federation/federation_finance.dart';
import 'package:fnm/domain/services/match/background_match.dart';
import 'package:fnm/domain/services/match/goal_attribution.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_simulator.dart';
import 'package:fnm/domain/services/match/venue.dart';
import 'package:fnm/domain/services/manager/staff.dart';
import 'package:fnm/domain/services/manager/manager_skills.dart';
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
import 'package:fnm/features/tactics/absence_providers.dart';
import 'package:fnm/features/tactics/nation_squad_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:fnm/features/settings/settings_providers.dart';
import 'package:fnm/features/hub/round_popup.dart' show stageLabelFor;
import 'package:fnm/features/tournaments/playoff_paths.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/domain/services/club/clubs.dart';
import 'package:fnm/domain/services/club/transfer_window.dart';
import 'package:fnm/features/messages/transfer_report.dart';

part 'season_cycle.dart';
part 'season_finals.dart';
part 'season_rollover.dart';

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

/// How a transfer's destination is written in the feed.
///
/// A move abroad used to read exactly like a move across town — same sentence,
/// no country — so every transfer in the manager's feed looked domestic. When
/// the player crosses a border the country is named, because that is the part
/// of the news that is the news.
String transferDestination(
  AppLocalizations l, {
  required String club,
  required String? toCountryName,
  required bool crossedBorder,
}) => crossedBorder && toCountryName != null && toCountryName.isNotEmpty
    ? l.newsTransferAbroad(club, toCountryName)
    : club;

/// What the manager has actually picked for his own nation: the squad he called
/// up, the tactic he saved (shape, eleven, instructions) and how drilled — and
/// how read — that shape is. See [SeasonService._ensureManagerSetup].
typedef _ManagerSetup = ({
  int nationId,
  Set<int> callUps,
  Tactic? tactic,
  double familiarity,
  double predictability,
});

/// Drives the whole-world simulation: quick-sims due matches, advances the
/// date, and progresses the cycle (qualifying → finals draw → knockout →
/// champion). Knockout ties are always resolved to a winner.
class SeasonService {
  SeasonService(this._ref);

  final Ref _ref;

  /// The manager's language, for the news this service files. Read per call
  /// rather than cached so a mid-save language change is picked up.
  AppLocalizations get _l => _ref.read(appLocalizationsProvider);

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
    // The manager's selection is re-read at the start of every operation: he
    // may have named a different squad, a different eleven or a different shape
    // since the last one, and a cache that outlived the operation would field
    // the team he used to pick.
    Future<void> run() {
      _managerSetup = null;
      _managerSetupCareer = null;
      return body();
    }

    // Chain behind whatever is running. Its failure is not ours to report —
    // that call surfaces its own error to its own caller — so either outcome
    // simply lets us start.
    final next = running == null
        ? run()
        : running.then((_) => run(), onError: (_) => run());
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

  /// The manager's own selection for the save being simulated: who he called
  /// up, the eleven and shape he named, and how drilled that shape is. Null
  /// until the first fixture of an operation asks for it, and dropped at the
  /// start of every operation (see [_exclusive]).
  _ManagerSetup? _managerSetup;
  int? _managerSetupCareer;

  /// Loads (once per operation) what the manager has actually picked.
  ///
  /// THE RULE this serves: a quick-simmed match for the MANAGER'S nation is
  /// played with his squad, his XI, his formation and his tactical standing —
  /// the stored familiarity for that shape, and his instructions — so that
  /// skipping a match is a choice about WATCHING, not a choice about how his
  /// side plays. Every OTHER nation keeps the best-available behaviour, since
  /// nobody picked them.
  ///
  /// Four repository reads, paid ONCE per operation and never per nation: a
  /// world matchday is hundreds of fixtures and only one of them is his.
  Future<_ManagerSetup?> _ensureManagerSetup(int careerId) async {
    if (_managerSetupCareer == careerId && _managerSetup != null) {
      return _managerSetup;
    }
    final career = await _careers.byId(careerId);
    if (career == null) return null;
    final tactic = await _ref
        .read(tacticsRepositoryProvider)
        .tacticForCareer(careerId);
    final drilling = await _ref
        .read(tacticFamiliarityRepositoryProvider)
        .forCareer(careerId);
    final shape = drilling[tactic?.formation ?? Formation.f433];
    _managerSetup = (
      nationId: career.nationId,
      callUps: await _ref.read(squadRepositoryProvider).callUps(careerId),
      tactic: tactic,
      familiarity: shape?.familiarity ?? 0,
      predictability: shape?.predictability ?? 0,
    );
    _managerSetupCareer = careerId;
    return _managerSetup;
  }

  /// Writes the operation's suspensions and injuries back, and tells the
  /// screens that show them.
  ///
  /// THE INVALIDATION IS PART OF THE WRITE, not an afterthought at the call
  /// site. Every screen that reads an absence — the call-up list, the tactics
  /// board, the nation squad — does so through an auto-disposed provider, and
  /// an auto-disposed provider that a mounted screen keeps alive is never told
  /// the world moved. Nothing here refreshed them, so a knock served down to
  /// nothing on the database went on being BADGED: the call-up row still read
  /// "Injured · 4g" for a man the match path (whose provider the preview screen
  /// does refresh) would quite correctly field. The badge and the eleven read
  /// the same column, so they have to read it at the same moment.
  Future<void> _flushAbsences(int careerId) async {
    final a = _absences;
    if (a == null || _absenceCareer != careerId) return;
    await _ref.read(absenceRepositoryProvider).replace(careerId, a.values);
    _ref
      ..invalidate(absenceOutlookProvider)
      ..invalidate(squadDataProvider)
      ..invalidate(tacticDataProvider)
      ..invalidate(nationSquadProvider);
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
  static const Set<String> _wcFinalsRounds = FinalsRounds.worldChampionship;

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
  ///
  /// Two things are settled: the matches, and then the FINISHING PLACES
  /// themselves ([Elo.placementDeltas]). Elo pays for results against
  /// expectation, so a champion who beat the sides it was supposed to beat and
  /// won its shootouts barely moved on the matches alone — the trophy has to
  /// be worth something of its own (see [Elo.placement]).
  Future<void> _settleWorldCupRanking(int careerId) async {
    final pts = _rankPoints;
    if (pts == null) return;
    final played = <FinalsResult>[];
    var year = 0;
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
        played.add((
          round: round,
          home: f.homeNationId,
          away: f.awayNationId,
          homeScore: f.homeScore!,
          awayScore: f.awayScore!,
        ));
        if (f.date.year > year) year = f.date.year;
      }
    }
    // The edition's year decides only which of the nations tied for the
    // rounding residue take it — without it the same nations, and in practice
    // the same confederation, would collect it at every World Championship
    // there will ever be (see [Elo.placementDeltas]).
    final placings = Elo.placementDeltas(
      Elo.placingsFromRounds(played),
      rotation: year,
    );
    for (final e in placings.entries) {
      pts[e.key] = (pts[e.key] ?? Elo.base) + e.value;
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
    final homeXi = await _fieldedXi(f.careerId, f.homeNationId);
    final awayXi = await _fieldedXi(f.careerId, f.awayNationId);
    // …and the substitutes it brings on. Background sides used to play the
    // whole ninety with eleven men, so outside the manager's own fixtures no
    // substitute ever won a cap, scored, was booked or was marked — the rest of
    // the world had no bench at all. Strength is still read off the XI: the
    // subs change who is on the pitch, not how good the side is.
    final homeSubs = await _fieldedSubs(f.careerId, f.homeNationId, homeXi);
    final awaySubs = await _fieldedSubs(f.careerId, f.awayNationId, awayXi);
    final homeStrength = await _withManagerTactics(
      f.careerId,
      f.homeNationId,
      _squadStrength(homeXi, home),
    );
    final awayStrength = await _withManagerTactics(
      f.careerId,
      f.awayNationId,
      _squadStrength(awayXi, away),
    );
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

  /// [strength] as the manager's own side plays it: his instructions and his
  /// tactical standing applied, exactly as the live engine would apply them.
  /// Returned unchanged for every other nation — nobody drills them.
  ///
  /// The drilled bonus used to arrive only when he WATCHED, because a skipped
  /// match goes through [RatingMatchSimulator], which has no formation, no
  /// instructions and no chemistry at all. So a manager who had spent four
  /// years drilling a shape gave the benefit back the moment he pressed skip —
  /// and the more tactics were made to matter, the bigger that hole grew.
  ///
  /// Two conversions, neither of them invented here:
  ///  * the plan, via [MatchEngine.planRatingDelta] — the engine's own slider
  ///    coefficients, read as the one number this simulator works in;
  ///  * the drilling, via [TeamChemistry.factor] — a MULTIPLIER on a side's
  ///    attack and defence, both of which are built from its players' ratings,
  ///    so it multiplies a rating here too (the same reading `StrengthFactors`
  ///    shows the manager). Predictability goes in with it: the engine passes
  ///    the stored figure, so a side the world has worked out gives the same
  ///    part of it back whether or not he watched.
  ///
  /// The result is deliberately NOT re-clamped to the 40–92 ranking scale that
  /// [_squadStrength] ends on: that scale describes a nation, and this is what
  /// his side is worth on the day.
  Future<int> _withManagerTactics(
    int careerId,
    int nationId,
    int strength,
  ) async {
    final setup = await _ensureManagerSetup(careerId);
    if (setup == null || setup.nationId != nationId) return strength;
    final plan =
        strength +
        MatchEngine.planRatingDelta(
          setup.tactic?.instructions ?? const TacticalInstructions(),
        );
    return (plan *
            TeamChemistry.factor(setup.familiarity, setup.predictability))
        .round();
  }

  /// The men the manager may field for his own nation in a match he skipped:
  /// his call-ups, minus anyone the absences rule out. Empty when he is not the
  /// manager of [nationId], and empty when nothing he named can play — both
  /// leave the caller on the ordinary best-available path.
  Future<List<Player>> _managerSquad(
    int careerId,
    int nationId,
    List<Player> pool,
  ) async {
    final setup = await _ensureManagerSetup(careerId);
    if (setup == null || setup.nationId != nationId) return const [];
    return selectable(
      availableSquad(pool, setup.callUps),
      await _ensureAbsences(careerId),
    );
  }

  /// The eleven the MANAGER named, for a match of his the world simulated
  /// rather than him playing it out. Null when this is not his nation, or when
  /// he has named nothing that can play — then the ordinary best-available XI
  /// stands.
  ///
  /// A stored XI goes stale: a man in it may since have been injured, banned,
  /// dropped from the squad or retired out of the pool. So the saved names are
  /// filtered through [selectable] first, and every slot they no longer fill is
  /// topped up from the rest of his squad — in HIS shape, so the replacement
  /// suits the hole — before the nation pool is touched at all. The alternative
  /// (throw the whole XI away the moment one name is stale) is how the live
  /// match screen does it, and it would hand a skipped match back to the
  /// automatic selection for the sake of one hamstring.
  Future<List<Player>?> _managerXi(
    int careerId,
    int nationId,
    List<Player> pool,
  ) async {
    final squad = await _managerSquad(careerId, nationId, pool);
    if (squad.isEmpty) return null;
    final setup = _managerSetup!;
    final shape = setup.tactic?.formation ?? Formation.f433;
    final byId = {for (final p in squad) p.id: p};
    final lineup = setup.tactic?.lineup ?? const <int?>[];
    final slots = List<Player?>.filled(11, null);
    final used = <int>{};
    for (var i = 0; i < slots.length && i < lineup.length; i++) {
      final p = byId[lineup[i]];
      if (p != null && used.add(p.id)) slots[i] = p;
    }
    if (used.length < slots.length) {
      // Gap-filling is slot-aware: `bestEleven` picks for the same shape in the
      // same slot order, so the man who comes in for a missing centre-half is a
      // centre-half.
      final rest = [
        for (final p in squad)
          if (!used.contains(p.id)) p,
      ];
      final filler = bestEleven(shape, rest);
      final restById = {for (final p in rest) p.id: p};
      for (var i = 0; i < slots.length; i++) {
        if (slots[i] != null) continue;
        final p = restById[filler[i]];
        if (p != null && used.add(p.id)) slots[i] = p;
      }
    }
    final xi = slots.whereType<Player>().toList();
    return xi.isEmpty ? null : xi;
  }

  /// The players a background-simulated side actually fields: its best 4-3-3
  /// from the pool (the whole pool if an XI can't be formed).
  ///
  /// The manager's OWN nation is the exception, and the only one: it fields the
  /// team he picked (see [_managerXi] for the rule). Every other nation is the
  /// best available, since nobody picked them.
  ///
  /// The absences are LOADED here, never merely consulted. They used to be read
  /// off the in-memory cache, which is empty until the first match of an
  /// operation has been played and its discipline applied — and this runs
  /// BEFORE that. So the first fixture any session simulated fielded every
  /// banned and injured man in it, the manager's own side included whenever he
  /// skipped a match rather than playing it out.
  Future<List<Player>> _fieldedXi(int careerId, int nationId) async {
    final pool = await _pool(nationId);
    if (pool.isEmpty) return const [];
    final mine = await _managerXi(careerId, nationId, pool);
    if (mine != null) return mine;
    // A suspended or injured player does not play — for ANY nation, not just
    // the manager's. This is what makes the world's cards and knocks mean
    // something: a rival losing its centre-forward for a quarter-final really
    // does field a weaker side, because `_squadStrength` reads this XI.
    // The same [selectable] the manager's own XI is filtered through, so "can
    // he play the next match" has one answer in the whole game.
    final available = selectable(pool, await _ensureAbsences(careerId));
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
  Future<List<Player>> _fieldedSubs(
    int careerId,
    int nationId,
    List<Player> xi,
  ) async {
    if (xi.isEmpty) return const [];
    final pool = await _pool(nationId);
    final onPitch = xi.map((p) => p.id).toSet();
    final absences = await _ensureAbsences(careerId);
    // The manager's bench is drawn from the squad HE named, like his XI — a
    // man he left at home does not come on in the 60th minute of a match he
    // skipped. Every other nation benches its best available.
    final mine = await _managerSquad(careerId, nationId, pool);
    final fit = mine.isEmpty ? selectable(pool, absences) : mine;
    final available =
        [
          for (final p in fit)
            if (!onPitch.contains(p.id)) p,
        ]..sort((a, b) {
          final byOverall = b.overall.compareTo(a.overall);
          return byOverall != 0 ? byOverall : a.id.compareTo(b.id);
        });
    return available.take(_backgroundSubs).toList();
  }

  /// The men who actually took the field for [nationId] in a match the manager
  /// played out, read off the engine's ratings — one mark per participant, the
  /// substitutes who came on included.
  ///
  /// Extra-time goals in his own match are drawn from THIS eleven. They used to
  /// be drawn from [_fieldedXi], the best available 4-3-3, so a man he left out
  /// of the squad entirely could score his winner in the 113th minute.
  ///
  /// Null when the result carries no marks for the side (nothing to go on), so
  /// attribution falls back to the best XI rather than crediting nobody.
  Future<List<Player>?> _playedXi(MatchResult result, int nationId) async {
    final ids = {
      for (final r in result.ratings)
        if (r.teamNationId == nationId) r.playerId,
    };
    if (ids.isEmpty) return null;
    final played = [
      for (final p in await _pool(nationId))
        if (ids.contains(p.id)) p,
    ];
    return played.isEmpty ? null : played;
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
    final fielded = xi ?? await _fieldedXi(f.careerId, nationId);
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
      //
      //    A finals round due BEFORE the player's own next finals match is
      //    stepped the same way, even though they are contesting the
      //    tournament: the World Championship's third-place play-off is played
      //    two days ahead of its final, and the catch-up that carries a
      //    finalist to his own match swallowed it whole — a round of the
      //    tournament resolved with nothing to watch. The continental
      //    championship has no third-place play-off, so its final is always the
      //    last fixture of its tournament and nothing could ever hide behind
      //    it: that is the ONLY reason it looked right while this did not, and
      //    it is why the rule belongs here rather than on one competition.
      //    `next` is the player's earliest unplayed fixture, so a finals
      //    fixture strictly before it is never one of theirs.
      final finalsRoundBeforeOwn =
          finalsDate != null &&
          nextIsFinals &&
          finalsDate.isBefore(next.date);
      if (finalsDate != null &&
          (finalsRoundBeforeOwn ||
              (!nextIsFinals &&
                  !playerInFinals &&
                  (next == null ||
                      !finalsDate.isAfter(next.date) ||
                      wcLive)))) {
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
      //    next competition) — advance the clock to it and QUICK-SIM it along
      //    with everything else due. It is not handed back to be played by
      //    hand: this is the skip path, and the manager's own match is
      //    simulated with the squad he named, the XI he picked and his
      //    tactics, exactly as it would be if he watched it.
      //
      //    No `excludeNationId` here, and that is deliberate. `_catchUp` reads
      //    a null exclude as "an explicit quick-sim/skip, everything due is
      //    played" (see its doc comment); passing the manager's nation would
      //    hold his own fixture back, the clock would stop moving and the
      //    cycle would never reach a champion.
      //    `test/unit/career/nation_switch_test.dart` drives a whole cycle
      //    through repeated `advance` calls and depends on exactly that.
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
      // charts too, matching the live screen. They go to the eleven that was
      // ACTUALLY on the pitch — the manager's own selection, subs included —
      // and not to the best XI the game would have picked for him.
      await _attributeGoals(
        fixture,
        fixture.homeNationId,
        ko.homeScore - hs,
        career.rngSeed,
        0x7E01,
        xi: await _playedXi(result, fixture.homeNationId),
        minuteFrom: 91,
        minuteSpan: 30,
      );
      await _attributeGoals(
        fixture,
        fixture.awayNationId,
        ko.awayScore - as,
        career.rngSeed,
        0x7E02,
        xi: await _playedXi(result, fixture.awayNationId),
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
        final l = _l;
        final how = e.secondYellow
            ? l.hubBanHowSecondYellow
            : ban >= 3
            ? l.hubBanHowViolent
            : l.hubBanHowRed;
        await _comp.addMessage(
          careerId: careerId,
          dedupKey: 'ban:${fixture.id}:${e.playerId}',
          category: 'discipline',
          title: l.hubBanTitle(e.playerName),
          body: l.hubBanBody(e.playerName, how, ban),
          year: discYear,
        );
      } else if (e.type == MatchEventType.injury) {
        final out = after[e.playerId]?.injuryMatches ?? 1;
        await _comp.addMessage(
          careerId: careerId,
          dedupKey: 'inj:${fixture.id}:${e.playerId}',
          category: 'injury',
          title: _l.hubInjuryTitle(e.playerName),
          body: _l.hubInjuryBody(e.playerName, out),
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
    final l = _l;
    final conf = nations[me]?.confederation;
    final contName = conf == null
        ? l.compContinentalChampionship
        : continentalCupLabel(l, conf);
    final ({String name, CompetitionKind kind})? cup = switch (round) {
      'GROUP' || 'R32' || 'R16' || 'QF' || 'SF' || '3RD' || 'FINAL' => (
        name: l.compWorldCup,
        kind: CompetitionKind.worldCupFinals,
      ),
      'CGROUP' || 'CR16' || 'CQF' || 'CSF' || 'CFINAL' => (
        name: contName,
        kind: CompetitionKind.continentalFinals,
      ),
      _ => null,
    };
    if (cup == null) return; // not a finals-tournament match

    final oppName = nations[oppId]?.name ?? l.msgANation;
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
            l.hubRunnerUpTitle1,
            l.hubRunnerUpTitle2,
            l.hubRunnerUpTitle3,
          ], s),
          body: pickVariant([
            l.hubRunnerUpBody1(cup.name, oppName),
            l.hubRunnerUpBody2(oppName, cup.name),
            l.hubRunnerUpBody3(cup.name, oppName),
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
            l.hubKnockedOutTitle1,
            l.hubKnockedOutTitle2,
            l.hubKnockedOutTitle3,
          ], s),
          body: () {
            final stage = stageLabelFor(l, core).toLowerCase();
            return pickVariant([
              l.hubKnockedOutBody1(cup.name, oppName, stage),
              l.hubKnockedOutBody2(oppName, cup.name, stage),
              l.hubKnockedOutBody3(cup.name, stage, oppName),
            ], s);
          }(),
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
            l.hubGroupExitTitle1,
            l.hubGroupExitTitle2,
            l.hubGroupExitTitle3,
          ], s),
          body: pickVariant([
            l.hubGroupExitBody1(cup.name),
            l.hubGroupExitBody2(cup.name),
            l.hubGroupExitBody3(cup.name),
          ], s),
          year: year,
        );
      }
      return;
    }
  }

  /// The World Cup finals year for a cycle (clean 4-year cadence: 2030, 2034…).
  static int finalsYear(int cycle) => CareerService.worldCupYear(cycle);

  /// Starts the next 4-year cycle once the current World Cup is decided:
  /// re-draws every confederation's qualifiers and advances the calendar.
  /// Rolls into the next cycle. [switchToNationId] moves the manager to a new
  /// nation (an accepted offer or a forced move after the sack); [boardTitle]/
  /// [boardBody], when given, are filed as a board-verdict message.
  ///
  /// Whether [careerId] has used up the free trial, so [startNextCycle] would
  /// refuse to roll it. The rollover screen asks this to put the paywall where
  /// the roll would have been.
  ///
  /// Fails open: a career it cannot read is not blocked.
  Future<bool> trialBlocksNextCycle(int careerId) async {
    final career = await _careers.byId(careerId);
    if (career == null) return false;
    return trialExhausted(
      cyclePointer: career.cyclePointer,
      premiumUnlocked: _ref.read(premiumUnlockedProvider),
    );
  }

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

  // --- Shared match/round predicates -----------------------------------
  //
  // These stay on the class rather than in a part: the extensions and the
  // class itself both read them, and a static is only reachable through the
  // type that declares it.
  /// Rounds that belong to the main finals tournaments (World Cup + continental
  /// championship) — the ones the player steps through even when not in them.
  static const Set<String> _finalsMatchRounds = {
    ...FinalsRounds.worldChampionship,
    ...FinalsRounds.continental,
  };

  static bool _isFinalsMatch(Fixture f) =>
      f.round != null && _finalsMatchRounds.contains(f.round);

  static int _winner(Fixture f) =>
      f.homeScore! >= f.awayScore! ? f.homeNationId : f.awayNationId;

  static int _loser(Fixture f) =>
      f.homeScore! >= f.awayScore! ? f.awayNationId : f.homeNationId;

  static int _rankStandings(GroupStanding a, GroupStanding b) {
    final byPoints = b.points.compareTo(a.points);
    if (byPoints != 0) return byPoints;
    final byGd = b.goalDifference.compareTo(a.goalDifference);
    if (byGd != 0) return byGd;
    return b.goalsFor.compareTo(a.goalsFor);
  }
}

final Provider<SeasonService> seasonServiceProvider = Provider(
  SeasonService.new,
);
