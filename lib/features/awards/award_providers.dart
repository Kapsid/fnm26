import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/util/message_text.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/awards/award_year.dart';
import 'package:fnm/domain/services/achievements/achievements.dart'
    show worldCupHonourName;
import 'package:fnm/domain/services/awards/player_of_year.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/domain/services/competition/rounds.dart';
import 'package:fnm/domain/services/competition/tournament_stars.dart';
import 'package:fnm/features/tournaments/tournament_stars_of.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/career_pool.dart';
import 'package:fnm/features/federation/federation_providers.dart';
import 'package:fnm/features/messages/poty_card.dart';
import 'package:fnm/features/press/press_providers.dart' show potyPressPrefix;
import 'package:fnm/features/settings/settings_providers.dart';

/// A player's trophy cabinet, newest first.
typedef AwardArg = ({int careerId, int playerId});

final AutoDisposeFutureProviderFamily<List<PlayerAward>, AwardArg>
playerAwardsProvider = FutureProvider.autoDispose
    .family<List<PlayerAward>, AwardArg>(
      (
        ref,
        arg,
      ) => ref
          .watch(competitionRepositoryProvider)
          .playerHonours(arg.careerId, arg.playerId),
    );

/// Marks a year whose vote was filed with a ceremony to watch (the vote body
/// of [encodePotyVote]). Stored at cycle 0 with the year, like the campaign
/// markers, so no schema change; a year filed by an older build has none and
/// so never offers a ceremony.
String potyDueKind(int year) => 'potyDue:$year';

/// Marks a year's ceremony as taken: watched, skipped to the list, or
/// simulated past.
String potySeenKind(int year) => 'potySeen:$year';

/// The year whose awards the vote on [date] belongs to: the year itself from
/// 1 December (see [AwardService.settleYear]), else the one before.
int potyYearOn(DateTime date) =>
    date.month >= CareerService.developmentMonth ? date.year : date.year - 1;

/// The year whose ceremony is waiting to be seen, or null.
///
/// Only the latest two years are ever asked: a ceremony is marked seen the
/// moment the world moves on (see [AwardService.markCeremoniesSeen]), so an
/// older one cannot still be waiting.
Future<int?> pendingCeremonyYear(
  CompetitionRepository comp,
  Career career,
) async {
  final latest = potyYearOn(career.inGameDate);
  for (final year in [latest, latest - 1]) {
    if (await comp.hasWatchedDraw(career.id, 0, potyDueKind(year)) &&
        !await comp.hasWatchedDraw(career.id, 0, potySeenKind(year))) {
      return year;
    }
  }
  return null;
}

/// A year's filed vote, from its inbox message, or null when the year has
/// none (or was filed by an older build, whose body is the old two cards).
final AutoDisposeFutureProviderFamily<PotyVote?, ({int careerId, int year})>
potyVoteProvider = FutureProvider.autoDispose
    .family<PotyVote?, ({int careerId, int year})>((ref, arg) async {
      final messages = await ref
          .watch(competitionRepositoryProvider)
          .messages(arg.careerId);
      for (final m in messages) {
        if (m.category != 'award' || m.year != arg.year) continue;
        if (decodePotyVote(m.body) case final vote?) return vote;
      }
      return null;
    });

/// Hands out the trophies a finished year has earned.
///
/// One place, run on every advance and idempotent by the table's own primary
/// key, rather than a hook on each settling path — an award handed out twice is
/// a bug nobody notices until a cabinet reads wrong years later.
class AwardService {
  AwardService(this._ref);

  final Ref _ref;

  /// How many of a year's best (on [PlayerOfYear.ceiling]) are looked up by
  /// name, age and position. Positions decide the vote and ages the young
  /// award, and resolving every player in the world would mean building two
  /// hundred squads. Every nation a shortlisted man plays for is resolved
  /// whole, so the field is wider than this in practice.
  static const int _shortlist = 60;

  /// The squad morale a manager's man winning the award is worth, through
  /// the press effect (as a camp scandal's cost is).
  static const int winnerMorale = 2;

  Future<void> settleYear(int careerId) async {
    final career = await _ref.read(careerRepositoryProvider).byId(careerId);
    if (career == null) return;
    // Only years whose FOOTBALL has finished: an award handed out in June would
    // be handed to whoever happened to have played by then. That moment is 1
    // December — the gap between the November qualifying window and January's
    // African and Asian finals, and the same date the squads re-rate on (see
    // [CareerService.developmentMonth]).
    //
    // It used to wait for the calendar to roll over instead, which put the
    // trophy in the inbox in the NEW year: at a cycle boundary that meant
    // "Player of the Year 2029" arriving as the first thing a manager read in
    // 2030, alongside the new cycle, months after the season it was for.
    //
    // The year before is looked at too. A manager who plays every match of
    // his own can step over December without a single quick-sim, and the
    // vote used to look only at the year the clock was in, so that year was
    // skipped for good. Settling also runs before his own matches now (see
    // [SeasonService]), and a year missed is still voted the next time.
    final latest = potyYearOn(career.inGameDate);
    for (final year in [latest - 1, latest]) {
      await _settle(career, year);
    }
  }

  Future<void> _settle(Career career, int year) async {
    final careerId = career.id;
    final comp = _ref.read(competitionRepositoryProvider);
    final l = _ref.read(appLocalizationsProvider);
    if (year < CareerService.cycleStart.year) return;
    final existing = await comp.messageKeys(careerId);
    // A year already voted is never voted again, by this build or an older
    // one — and an older one's year gets no ceremony.
    if (existing.contains('poty:$year')) return;

    final raw = await comp.awardYearData(careerId, year);
    if (raw.appearances.isEmpty) return;
    final nations = {
      for (final n
          in await _ref.read(nationRepositoryProvider).forCareer(careerId))
        n.id: n,
    };
    final awardYear = AwardYear.build(
      year: year,
      fixtures: raw.fixtures,
      appearances: raw.appearances,
      rankOf: (id) => nations[id]?.ranking ?? 150,
    );

    // The shortlist, on what each man could score in his best position, and
    // every nation that reached a semi-final of a championship decided this
    // year (whose men collect the tournament honours).
    // A ceremony every year: in a thin one the floor falls from six towards
    // three until five men reach it (see [PlayerOfYear.floorFor]).
    final floor = PlayerOfYear.floorFor(
      awardYear.lines.values,
      need: PlayerOfYear.bestField,
    );
    final ceiling = <int, double>{
      for (final line in awardYear.lines.values)
        if (line.apps >= floor)
          line.playerId: PlayerOfYear.ceiling(
            line,
            awardYear.trophies,
            minApps: floor,
          ),
    };
    // Nobody played even three games: a year with no football to speak of.
    // It is asked again on the next step.
    if (ceiling.isEmpty) return;
    final ranked =
        [
          for (final id in ceiling.keys) awardYear.lines[id]!,
        ]..sort((a, b) {
          final s = ceiling[b.playerId]!.compareTo(ceiling[a.playerId]!);
          return s != 0 ? s : a.playerId.compareTo(b.playerId);
        });
    // The tournament honours first: their holders' nations join the field.
    final stored = await _tournamentHonours(career, awardYear, raw.fixtures);
    final nationIds = <int>{
      for (final line in ranked.take(_shortlist)) line.nationId,
      ...stored.nations,
      for (final t in awardYear.trophies)
        if (t.family == TrophyFamily.worldChampionship ||
            t.family == TrophyFamily.continental) ...[
          t.champion,
          t.runnerUp,
          ...t.semiFinalists,
        ],
    };
    final profiles = <int, VoterProfile>{};
    for (final nationId in nationIds.toList()..sort()) {
      final pool = await careerPoolOf(
        _ref,
        career,
        nationId,
        // History: a man who retired since still played here.
        includeIntlRetired: true,
      );
      for (final p in pool) {
        if (!awardYear.lines.containsKey(p.id)) continue;
        profiles[p.id] = (
          name: p.name,
          age: p.age,
          position: p.position,
          overall: p.overall,
        );
      }
    }
    if (profiles.isEmpty) return;

    final honours = stored.honours;
    final best = PlayerOfYear.rank(
      awardYear,
      profiles,
      honours: honours,
      minApps: floor,
    );
    final young = PlayerOfYear.rank(
      awardYear,
      profiles,
      honours: honours,
      eligible: PlayerOfYear.young,
      limit: 3,
    );
    if (best.isEmpty) return;
    for (final (entry, kind) in [
      (best.first, AwardKind.playerOfYear),
      if (young.isNotEmpty) (young.first, AwardKind.youngPlayerOfYear),
    ]) {
      await comp.recordPlayerHonour(
        careerId: careerId,
        playerId: entry.playerId,
        nationId: entry.nationId,
        kind: kind,
        year: year,
      );
    }

    final vote = await _vote(
      career: career,
      nations: nations,
      best: best,
      young: young,
    );
    await comp.addTextMessage(
      l: l,
      careerId: careerId,
      dedupKey: 'poty:$year',
      category: 'award',
      title: MsgText(MsgKey.newsPotyTitle, [year]),
      rawBody: encodePotyVote(vote),
      year: year,
    );
    await comp.markDrawWatched(careerId, 0, potyDueKind(year));

    // The manager's own man is the best in the world: the dressing room
    // feels it. Small, and through the press effect every other mood swing
    // uses, so it expires with the cycle like the rest.
    if (best.first.nationId == career.nationId) {
      final repo = _ref.read(careerRepositoryProvider);
      final key = '$potyPressPrefix$year';
      final already = (await repo.pressAnswers(
        careerId,
        cycle: career.cyclePointer,
      )).any((a) => a.questionKey == key);
      if (!already) {
        await repo.recordPressAnswer(
          careerId: careerId,
          cycle: career.cyclePointer,
          questionKey: key,
          tone: 'potyWin',
          moraleDelta: winnerMorale,
          boardDelta: 0,
          answeredAt: career.inGameDate,
        );
      }
    }
    _ref
      ..invalidate(playerAwardsProvider)
      ..invalidate(potyVoteProvider);
  }

  /// Stores a finished tournament's individual honours (Golden Ball, Golden
  /// Boot, Golden Glove, Team of the Tournament) for the cabinet, the
  /// tournament screens and the vote, unless they are stored already.
  ///
  /// Computed once, with [tournamentStarsOf] (the function the screens
  /// call), and never again: the screens rebuild their picks from these rows
  /// from then on, so a re-rating years later cannot change who won.
  Future<void> _storeTournament(
    Career career, {
    required int competitionId,
    required bool worldChampionship,
    required Confederation confederation,
    required int year,
    required Iterable<(String?, int, int)> knockout,
    required int champion,
  }) async {
    final comp = _ref.read(competitionRepositoryProvider);
    final name = worldChampionship
        ? worldCupHonourName
        : ContinentalCups.byConfederation[confederation]?.name;
    if (name == null) return;
    final stored = await storedTournamentHonours(
      comp,
      career.id,
      competition: name,
      year: year,
    );
    if (stored.isNotEmpty) return;
    final stars = await tournamentStarsOf(
      _ref,
      career,
      competitionId: competitionId,
      knockout: knockout,
      roundDepth: worldChampionship
          ? worldChampionshipRoundDepth
          : continentalRoundDepth,
      champion: champion,
    );
    final boot = TournamentStars.goldenBoot(stars.team);
    for (final (star, kind) in [
      if (stars.team.isNotEmpty) (stars.team.first, AwardKind.goldenBall),
      if (boot != null) (boot, AwardKind.goldenBoot),
      if (stars.keeper != null) (stars.keeper!, AwardKind.goldenGlove),
      for (final s in stars.team) (s, AwardKind.teamOfTournament),
    ]) {
      await comp.recordPlayerHonour(
        careerId: career.id,
        playerId: star.id,
        nationId: star.nationId,
        kind: kind,
        year: year,
        competition: name,
      );
    }
  }

  /// Stores the honours of every World Championship and continental
  /// championship of the current cycle whose final has been played and
  /// whose honours are not stored yet. Run after every step of the world,
  /// so they are fixed the moment the final is played: the picks the
  /// manager sees on the tournament screen that evening are the picks for
  /// good.
  Future<void> storeFinishedTournaments(int careerId) async {
    final career = await _ref.read(careerRepositoryProvider).byId(careerId);
    if (career == null) return;
    final comp = _ref.read(competitionRepositoryProvider);
    final cups = [
      (CompetitionKind.worldCupFinals, Confederation.europe, true),
      for (final c in Confederation.values)
        (CompetitionKind.continentalFinals, c, false),
    ];
    for (final (kind, conf, wc) in cups) {
      final depth = wc ? worldChampionshipRoundDepth : continentalRoundDepth;
      final finals = await comp.fixturesByRound(
        careerId,
        wc ? 'FINAL' : 'CFINAL',
        kind: kind,
        confederation: wc ? null : conf,
      );
      final last = finals.firstOrNull;
      if (last == null || !last.hasResult) continue;
      // Already fixed: the usual case, once the final is behind us.
      final name = wc
          ? worldCupHonourName
          : ContinentalCups.byConfederation[conf]?.name;
      if (name == null ||
          (await storedTournamentHonours(
            comp,
            careerId,
            competition: name,
            year: last.date.year,
          )).isNotEmpty) {
        continue;
      }
      final knockout = <(String?, int, int)>[];
      for (final round in depth.keys) {
        for (final f in await comp.fixturesByRound(
          careerId,
          round,
          kind: kind,
          confederation: wc ? null : conf,
        )) {
          knockout.add((f.round, f.homeNationId, f.awayNationId));
        }
      }
      await _storeTournament(
        career,
        competitionId: last.competitionId,
        worldChampionship: wc,
        confederation: conf,
        year: last.date.year,
        knockout: knockout,
        champion: AwardYear.winnerOf((
          id: last.id,
          competitionId: last.competitionId,
          kind: kind,
          confederation: conf,
          round: last.round,
          date: last.date,
          homeNationId: last.homeNationId,
          awayNationId: last.awayNationId,
          homeScore: last.homeScore!,
          awayScore: last.awayScore!,
          homePenalties: last.homePenalties,
          awayPenalties: last.awayPenalties,
        )),
      );
    }
  }

  /// The tournament honours the vote counts: READ from the stored honours
  /// of [awardYear], the very picks the tournament screens show.
  ///
  /// Normally stored the evening each final was played (see
  /// [storeFinishedTournaments]); any championship of the year still without
  /// them (a final played before this build, or one of a cycle already
  /// rolled over) is stored here first, the same way. Every one of them has
  /// finished by 1 December (the last finals end in July).
  ///
  /// Also hands back the nation of every holder, so his squad is resolved
  /// for the vote even when he is nowhere near the shortlist (a keeper's
  /// Golden Glove for a quarter-finalist).
  Future<({Map<int, List<VoteHonour>> honours, Set<int> nations})>
  _tournamentHonours(
    Career career,
    AwardYear awardYear,
    List<AwardFixture> fixtures,
  ) async {
    final comp = _ref.read(competitionRepositoryProvider);
    for (final t in awardYear.trophies) {
      final wc = t.family == TrophyFamily.worldChampionship;
      if (!wc && t.family != TrophyFamily.continental) continue;
      await _storeTournament(
        career,
        competitionId: t.competitionId,
        worldChampionship: wc,
        confederation: t.confederation,
        year: awardYear.year,
        knockout: [
          for (final f in fixtures)
            if (f.competitionId == t.competitionId &&
                Rounds.isKnockout(f.round))
              (f.round, f.homeNationId, f.awayNationId),
        ],
        champion: t.champion,
      );
    }
    final out = <int, List<VoteHonour>>{};
    final nations = <int>{};
    for (final h in await comp.playerHonoursForYear(
      career.id,
      awardYear.year,
    )) {
      if (h.kind == AwardKind.playerOfYear ||
          h.kind == AwardKind.youngPlayerOfYear) {
        continue;
      }
      final VoteHonour? vote = h.competition == worldCupHonourName
          ? (kind: h.kind, family: TrophyFamily.worldChampionship, prestige: 1)
          : switch (ContinentalCups.byConfederation.entries
                .where((e) => e.value.name == h.competition)
                .firstOrNull) {
              final e? => (
                kind: h.kind,
                family: TrophyFamily.continental,
                prestige: AwardYear.prestigeOf(e.key),
              ),
              null => null,
            };
      if (vote != null) {
        (out[h.playerId] ??= []).add(vote);
        nations.add(h.nationId);
      }
    }
    return (honours: out, nations: nations);
  }

  /// Marks every ceremony still waiting as seen, without showing it: the
  /// manager has moved the world on past it. The inbox message stays.
  Future<void> markCeremoniesSeen(int careerId) async {
    final career = await _ref.read(careerRepositoryProvider).byId(careerId);
    if (career == null) return;
    final comp = _ref.read(competitionRepositoryProvider);
    while (true) {
      final year = await pendingCeremonyYear(comp, career);
      if (year == null) break;
      await comp.markDrawWatched(careerId, 0, potySeenKind(year));
    }
  }

  /// The manager has taken [year]'s ceremony (watched or skipped to the
  /// list): it is seen, and its inbox message has been read.
  Future<void> takeCeremony(int careerId, int year) async {
    final comp = _ref.read(competitionRepositoryProvider);
    await comp.markDrawWatched(careerId, 0, potySeenKind(year));
    final ids = [
      for (final m in await comp.messages(careerId))
        if (!m.read &&
            m.category == 'award' &&
            m.year == year &&
            decodePotyVote(m.body) != null)
          m.id,
    ];
    if (ids.isNotEmpty) await comp.markMessagesRead(careerId, ids: ids);
  }

  /// The year's vote as it is filed: every place resolved by id with all of
  /// the repository's inputs, because a rating is only right with all four of
  /// them (the pool the shortlist was read from has two).
  Future<PotyVote> _vote({
    required Career career,
    required Map<int, Nation> nations,
    required List<PotyEntry> best,
    required List<PotyEntry> young,
  }) async {
    final repo = _ref.read(playerRepositoryProvider);
    final youth = await _ref.read(youthBonusByCycleProvider(career.id).future);
    final careerDev = await _ref.read(
      careerDevBonusProvider(career.id).future,
    );
    Future<PotyPlace> place(PotyEntry e, int rank) async {
      final player = await repo.byId(
        e.playerId,
        agingYears: CareerService.agingYears(career),
        saveSeed: career.rngSeed,
        careerId: career.id,
        youthBonusByCycle: youth,
        careerStartsByPlayer: careerDev,
      );
      final nation = nations[e.nationId];
      final l = e.line;
      return (
        rank: rank,
        playerId: e.playerId,
        nationId: e.nationId,
        own: e.nationId == career.nationId,
        name: e.profile.name,
        nationCode: nation?.code.toLowerCase() ?? '',
        // Meaning, not words: the screens name the nation from its id, in
        // whatever language is being read when they are opened.
        nationName: '',
        age: e.profile.age,
        overall: player?.overall ?? e.profile.overall,
        position: e.profile.position,
        apps: l.apps,
        goals: l.goals,
        assists: l.assists,
        cleanSheets: l.cleanSheets,
        meanRating: l.meanRating,
        motms: l.motms,
        score: e.total,
      );
    }

    return (
      best: [for (var i = 0; i < best.length; i++) await place(best[i], i + 1)],
      young: [
        for (var i = 0; i < young.length; i++) await place(young[i], i + 1),
      ],
    );
  }
}

final Provider<AwardService> awardServiceProvider = Provider(AwardService.new);
