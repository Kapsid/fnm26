import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/config/ui_language.dart' show uiLanguageCodeProvider;
import 'package:fnm/core/util/sponsor_label.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/real_internationals.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/domain/services/competition/rounds.dart';
import 'package:fnm/domain/services/federation/sponsors.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/venue.dart' show isNeutralFinalsRound;
import 'package:fnm/domain/services/press/expectation.dart';
import 'package:fnm/domain/services/press/fan_mood.dart';
import 'package:fnm/domain/services/press/half_time_swing.dart';
import 'package:fnm/domain/services/press/persona.dart' show YPersona;
import 'package:fnm/domain/services/press/press.dart';
import 'package:fnm/domain/services/press/public_mood.dart';
import 'package:fnm/domain/services/press/pundit_predictions.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/domain/services/press/y_locals.dart';
import 'package:fnm/domain/services/press/y_tournaments.dart';
import 'package:fnm/domain/services/squad/camp_scandal.dart';
import 'package:fnm/data/repositories/world_pack_repository.dart';
import 'package:fnm/domain/services/world_pack/active_world.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart'
    show PackYAccount;
import 'package:fnm/features/ranking/world_ranking_providers.dart';
import 'package:fnm/domain/services/achievements/board_satisfaction.dart';
import 'package:fnm/features/achievements/achievement_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/sponsor_providers.dart'
    show careerSponsorsForDisplay;
import 'package:fnm/features/press/press_providers.dart';
import 'package:fnm/features/press/story_providers.dart';
import 'package:fnm/features/settings/settings_providers.dart'
    show appLocalizationsProvider;
import 'package:fnm/features/squad/camp_scandal_providers.dart';
import 'package:fnm/features/squad/grievance_providers.dart';
import 'package:fnm/features/squad/international_retirement_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart'
    show squadDataProvider;
import 'package:fnm/features/world_pack/world_pack_providers.dart'
    show worldPackRepositoryProvider;

/// The manager's played matches, newest first, with both sides' world
/// positions — the raw material both Y and the public's mood are built from.
///
/// Ranks are the ones frozen at the start of the cycle each match was played
/// in (see [seedRankByIdProvider]), the reading the board uses too. They used
/// to be today's live ranking, which already holds the match's own result:
/// Montenegro beat Sweden 6-2, climbed while Sweden dropped, and the same
/// night was re-read as a win between nearer equals. Every older result was
/// re-judged each time the ranking moved, too. A frozen baseline does
/// neither.
typedef YJudged = ({
  String opponent,
  int nationRank,
  int opponentRank,
  int scored,
  int conceded,
  DateTime date,
  String key,
  bool competitive,
  YStakes stakes,
  bool? shootoutWon,

  /// Whether it was played at home (not away, not a neutral finals ground):
  /// the only matches after which the stands can describe their own ground.
  bool home,

  /// Whether it was played at the opponent's ground.
  bool away,
});

final AutoDisposeFutureProviderFamily<List<YJudged>, int> yJudgedProvider =
    FutureProvider.autoDispose.family<List<YJudged>, int>((
      ref,
      careerId,
    ) async {
      await ref.watch(seedLoaderProvider).ensureSeeded();
      final career = await ref.watch(careerRepositoryProvider).byId(careerId);
      if (career == null) return const [];
      // Watched only so a sim step refreshes this list: the hub invalidates
      // the live ranking after every step, and the fixtures read below go
      // through no provider that would notice a new result. Its positions
      // are NOT used (see above); without the watch the feed and the public
      // mood kept showing the state before the match.
      await ref.watch(worldRankingProvider(careerId).future);
      final nations = {
        for (final n
            in await ref.watch(nationRepositoryProvider).forCareer(careerId))
          n.id: n,
      };
      final total = nations.length;
      // The ranking frozen at the start of the cycle a match was played in.
      final baselines = <int, Map<int, int>>{};
      Future<Map<int, int>> ranksOn(DateTime date) async {
        var cycle = 0;
        while (cycle < career.cyclePointer &&
            !date.isBefore(CareerService.cycleOpens(cycle + 1))) {
          cycle++;
        }
        return baselines[cycle] ??= await ref.watch(
          seedRankByIdProvider((careerId: careerId, cycle: cycle)).future,
        );
      }

      final fixtures = await ref
          .watch(competitionRepositoryProvider)
          .fixturesForNation(careerId, career.nationId);
      final played = [
        for (final f in fixtures)
          if (f.hasResult) f,
      ]..sort((a, b) => b.date.compareTo(a.date));

      final out = <YJudged>[];
      for (final f in played) {
        final home = f.homeNationId == career.nationId;
        final opponentId = home ? f.awayNationId : f.homeNationId;
        final opponent = nations[opponentId];
        if (opponent == null) continue;
        final ranks = await ranksOn(f.date);
        int rankOf(int id) => ranks[id] ?? nations[id]?.ranking ?? total;
        out.add((
          opponent: opponent.name,
          nationRank: rankOf(career.nationId),
          opponentRank: rankOf(opponentId),
          scored: home ? f.homeScore! : f.awayScore!,
          conceded: home ? f.awayScore! : f.homeScore!,
          date: f.date,
          key: 'fx:${f.id}',
          competitive: f.round != Rounds.friendly,
          stakes: YFeed.stakesOf(f.round),
          // A tie settled on penalties is level on the scoreline; who won the
          // shoot-out is the result.
          shootoutWon: f.wentToShootout
              ? (home
                    ? f.homePenalties! > f.awayPenalties!
                    : f.awayPenalties! > f.homePenalties!)
              : null,
          home: home && !isNeutralFinalsRound(f.round),
          away: !home && !isNeutralFinalsRound(f.round),
        ));
      }
      return out;
    });

/// How many times two nations have to have met before the feed treats the
/// fixture as a rivalry.
const int rivalryMeetings = 4;

/// The feed: what the world has been saying, newest first, and where the
/// reserved older landmarks begin (see [YFeed.timeline]).
final AutoDisposeFutureProviderFamily<YTimeline, int> yFeedProvider =
    FutureProvider.autoDispose.family<YTimeline, int>((
      ref,
      careerId,
    ) async {
      final career = await ref.watch(careerRepositoryProvider).byId(careerId);
      if (career == null) return _emptyFeed;
      // The accounts the career's own world added for its nation post in the
      // casts of their voices: every YFeed call below runs inside the scope.
      final accounts = await careerYAccountsForDisplay(
        ref.watch(worldPackRepositoryProvider),
        career,
      );
      return YAccountsScope.run(accounts, () => _feedOf(ref, career));
    });

const YTimeline _emptyFeed = (posts: <YPost>[], reserveFrom: null);

/// The Y accounts career [career]'s own world added that post in its
/// nation's feed: the ones bound to its nation and the ones bound to none
/// ([YAccountsScope.forNation]). Read off the career's copy, never the world
/// on screen; none for a default-world career.
///
/// Only what is SHOWN depends on it, so a world that cannot be read is
/// reported and reads as adding none: the feed still builds.
Future<List<PackYAccount>> careerYAccountsForDisplay(
  WorldPackRepository worlds,
  Career career,
) async {
  try {
    return YAccountsScope.forNation(
      await worlds.addedYAccountsFor(career.id),
      career.nationId,
    );
  } on Object catch (e, st) {
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: e,
        stack: st,
        library: 'y',
        context: ErrorDescription(
          'reading the Y accounts of career ${career.id}',
        ),
      ),
    );
    return const [];
  }
}

Future<YTimeline> _feedOf(Ref ref, Career career) async {
  final careerId = career.id;
  const empty = _emptyFeed;
  // The career's world: its sponsor names (read through `sponsorBrandName`),
  // its renamed accounts and its local fans' name lists.
  final world = ref.watch(activeWorldProvider);
  final nations = await ref.watch(nationRepositoryProvider).forCareer(careerId);
  final nation = nations
      .where((Nation n) => n.id == career.nationId)
      .map((n) => n.name)
      .firstOrNull;
  if (nation == null) return empty;
  final judged = await ref.watch(yJudgedProvider(careerId).future);

  // What else the world knows about each of those results: who scored,
  // what run the side was on, whether it was the neighbours. Without this
  // every post is assembled from a scoreline and repeats within a season.
  final comp = ref.watch(competitionRepositoryProvider);
  final scorers = await comp.scorersByFixture(careerId, career.nationId);
  final playerRepo = ref.watch(playerRepositoryProvider);
  final aging = CareerService.agingYears(career);

  // What happened on the pitch, match by match: the sendings-off the
  // press room can also see. Each belongs to the date it happened on, not
  // to today, so it is read inside the walk below rather than hung on the
  // newest result the way an injury is.
  final incidents = await comp.incidentsByFixture(
    careerId,
    career.nationId,
  );

  // And how each of those results GOT to its scoreline. The fixture row
  // keeps only the end of the story, so without the goal minutes the feed
  // cannot tell a comfortable win from a match that was two down at the
  // break — which is the one afternoon the country talks about for years.
  final timeline = await comp.goalTimeline(careerId);

  // Oldest first, so a streak counts the matches BEFORE it.
  final chronological = judged.reversed.toList();
  final meetings = <String, int>{};
  var wins = 0;
  var losses = 0;
  final contexts = <YContext>[];
  final incidentPosts = <YPost>[];
  final standingsSoFar = <ResultStanding>[];
  // The same run with its dates, so a post dated before the newest result
  // can be toned by what was known on its own day.
  final datedStandings = <({DateTime date, ResultStanding standing})>[];
  for (final j in chronological) {
    final won = j.scored > j.conceded;
    final lost = j.scored < j.conceded;
    wins = won ? wins + 1 : 0;
    losses = lost ? losses + 1 : 0;
    final met = meetings.update(
      j.opponent,
      (v) => v + 1,
      ifAbsent: () => 1,
    );

    // Who got them, if anybody got more than one goal's worth of credit.
    String? scorerName;
    int? scorerGoals;
    final fixtureId = int.tryParse(j.key.replaceFirst('fx:', ''));
    final byPlayer = fixtureId == null ? null : scorers[fixtureId];
    if (byPlayer != null && byPlayer.isNotEmpty) {
      final best = byPlayer.entries.reduce(
        (a, b) => b.value > a.value ? b : a,
      );
      final p = await playerRepo.byId(
        best.key,
        agingYears: aging,
        saveSeed: career.rngSeed,
        careerId: career.id,
      );
      if (p != null) {
        scorerName = p.name;
        scorerGoals = best.value;
      }
    }

    final match = (
      opponent: j.opponent,
      nationRank: j.nationRank,
      opponentRank: j.opponentRank,
      scored: j.scored,
      conceded: j.conceded,
      date: j.date,
      key: j.key,
      competitive: j.competitive,
      stakes: j.stakes,
      shootoutWon: j.shootoutWon,
      away: j.away,
    );

    // One of ours walked. The cast reads it through the stance it held on
    // the day, exactly as it reads a result — see [YFeed.forIncident].
    final standing = YFeed.standingOf(match);
    for (final i in incidents[fixtureId] ?? const <MatchIncident>[]) {
      if (i.type != MatchEventType.redCard) continue;
      final p = await playerRepo.byId(
        i.playerId,
        agingYears: aging,
        saveSeed: career.rngSeed,
        careerId: career.id,
      );
      if (p == null) continue;
      incidentPosts.addAll(
        YFeed.forIncident(
          incident: PressSubjectIncident(
            type: i.type,
            minute: i.minute,
            playerId: i.playerId,
            name: p.name,
          ),
          date: j.date,
          key: 'red:${j.key}:${i.playerId}',
          nation: nation,
          seed: career.rngSeed,
          standing: standing,
          history: [...standingsSoFar],
        ),
      );
    }
    // An afternoon the second half turned over, either way. Competitive
    // only, like the press room's version: a warm-up that swings two goals
    // is not evidence and the country does not treat it as any.
    final swing = fixtureId == null || !j.competitive
        ? null
        : halfTimeSwingOf(
            goals: timeline[fixtureId] ?? const [],
            nationId: career.nationId,
            scored: j.scored,
            conceded: j.conceded,
          );
    if (swing != null) {
      incidentPosts.addAll(
        YFeed.forSwing(
          swing: swing,
          opponent: j.opponent,
          date: j.date,
          key: 'swing:${j.key}',
          nation: nation,
          seed: career.rngSeed,
          standing: standing,
          history: [...standingsSoFar],
        ),
      );
    }
    standingsSoFar.add(standing);
    datedStandings.add((date: j.date, standing: standing));

    contexts.add((
      match: match,
      scorerName: scorerName,
      scorerGoals: scorerGoals,
      winStreak: wins,
      lossStreak: losses,
      // A fixture the two have played several times over is not just
      // another game — the save's own history is what makes it a rivalry,
      // rather than a list of grudges written in advance.
      isRivalry: met >= rivalryMeetings,
      // "Now" facts belong only to the newest match: hanging today's
      // injuries on a post from three years ago would rewrite history.
      injuredNames: const [],
      boardMood: BoardSatisfaction.neutral,
    ));
  }

  // The latest result is the one the world is still reacting to, so it is
  // the one that carries the injuries and the board's patience.
  if (contexts.isNotEmpty) {
    final absences = await ref
        .watch(absenceRepositoryProvider)
        .forCareer(careerId);
    // His own men only. The world simulation injures every nation's
    // players too, and the first of the WHOLE world's injured was posted
    // as his loss after every match, a man from another continent who was
    // out for months (tester, 1.0.9).
    final hurt = <String>[];
    for (final a in absences.values) {
      if (a.injuryMatches <= 0) continue;
      final p = await playerRepo.byId(
        a.playerId,
        agingYears: aging,
        saveSeed: career.rngSeed,
        careerId: career.id,
      );
      if (p != null && p.nationId == career.nationId) hurt.add(p.name);
    }
    final last = contexts.last;
    contexts[contexts.length - 1] = (
      match: last.match,
      scorerName: last.scorerName,
      scorerGoals: last.scorerGoals,
      winStreak: last.winStreak,
      lossStreak: last.lossStreak,
      isRivalry: last.isRivalry,
      injuredNames: hurt,
      boardMood: await ref.watch(satisfactionProvider(careerId).future),
    );
  }

  // The tournaments, read once: they are posts of their own (below) and
  // part of what the stands feel about the side (see [FanMood]).
  final milestones = await ref.watch(
    yMilestonesProvider(careerId).future,
  );
  final since = (await currentSpell(
    ref.watch(careerRepositoryProvider),
    career,
  )).since;
  final posts = YFeed.forRun(
    contexts,
    nation: nation,
    seed: career.rngSeed,
    fanEvents: fanEventsOf(milestones),
    manager: career.managerName,
    managerSince: since,
    homeKeys: {
      for (final j in judged)
        if (j.home) j.key,
    },
    familyFirst: familyFirstLanguages.contains(
      ref.watch(uiLanguageCodeProvider),
    ),
  )..addAll(incidentPosts);
  // The one post drawn from a match that has NOT been played. Every other
  // shape on the feed reacts to a result, so the biggest game of a cycle
  // used to arrive in silence and the reaction to it landed before any
  // anticipation of it — the wrong way round for the game everybody is
  // waiting for.
  final upcoming =
      (await ref
              .watch(competitionRepositoryProvider)
              .fixturesForNation(careerId, career.nationId))
          .where((f) => !f.hasResult && f.round != null)
          .where((f) => YFeed.hypeRounds.contains(f.round))
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date));
  if (upcoming.isNotEmpty) {
    final next = upcoming.first;
    final opponentId = next.homeNationId == career.nationId
        ? next.awayNationId
        : next.homeNationId;
    final opponent = nations
        .where((n) => n.id == opponentId)
        .map((n) => n.name)
        .firstOrNull;
    if (opponent != null) {
      posts.addAll(
        YFeed.forUpcoming(
          round: next.round!,
          opponent: opponent,
          date: next.date,
          nation: nation,
          seed: career.rngSeed,
        ),
      );
    }
  }

  // The tournaments themselves. Every post above reacts to a SCORELINE,
  // which left the biggest things that happen to a nation — lifting the
  // trophy, going out, booking the place at all — passing without a word:
  // `YFeed.forEvent` had full copy in both languages, its own tests, and
  // not one caller anywhere in the app.
  posts.addAll(
    _tournamentPosts(
      milestones,
      nation: nation,
      seed: career.rngSeed,
      judged: judged,
      fixtures: await ref
          .watch(competitionRepositoryProvider)
          .fixturesForNation(careerId, career.nationId),
      dated: datedStandings,
    ),
  );

  // The pundits' call before a finals, as the inbox piece made it: the
  // call is in the piece's key, so no squad is weighed twice.
  final nameOf = {for (final n in nations) n.id: n.name};
  for (final key
      in await ref.watch(competitionRepositoryProvider).messageKeys(careerId)) {
    final call = PunditPredictions.decodeKey(key);
    if (call == null) continue;
    final conf = Confederation.values
        .where((c) => c.name == call.region)
        .firstOrNull;
    final competition = conf == null
        ? 'World Championship'
        : ContinentalCups.byConfederation[conf]?.name;
    final favourite = nameOf[call.favourite];
    final darkHorse = nameOf[call.darkHorse];
    if (competition == null || favourite == null || darkHorse == null) {
      continue;
    }
    posts.addAll(
      YFeed.forPundits(
        competition: competition,
        favourite: favourite,
        darkHorse: darkHorse,
        date: call.date,
        key: key,
        nation: nation,
        seed: career.rngSeed,
        history: YFeed.standingsAsOf(datedStandings, call.date),
      ),
    );
  }

  // And anybody left to stew says so in public — the thing he could not get
  // said in the manager's office.
  for (final g in await ref.watch(grievanceProvider(careerId).future)) {
    posts.addAll(
      YFeed.forGrievance(
        playerName: g.playerName,
        date: career.inGameDate,
        key: g.key,
        nation: nation,
        seed: career.rngSeed,
      ),
    );
  }

  // One of ours announcing his international retirement: the country
  // says goodbye (or that it was a tournament too late). Dated the day he
  // announced it, so it sits among the reports of the finals it followed.
  final retirements = await ref.watch(
    intlRetirementsProvider(careerId).future,
  );
  // Filtered on the marker alone before any player is resolved: the map
  // holds the whole world's retirees, and only a handful are ours and
  // worth a farewell. Recent waves only, like the rest of the feed.
  final nowYears = CareerService.agingYears(career);
  for (final r in retirements.values) {
    final on = r.retiredOn;
    if (on == null || on.isAfter(career.inGameDate)) continue;
    if (r.nationId != career.nationId || !r.notable) continue;
    if (nowYears - r.retiredAging > 4) continue;
    final p = await ref
        .watch(playerRepositoryProvider)
        .byId(
          r.playerId,
          agingYears: CareerService.agingYears(career),
          saveSeed: career.rngSeed,
          careerId: careerId,
        );
    if (p == null || p.nationId != career.nationId) continue;
    posts.addAll(
      YFeed.forEvent(
        template: YTemplate.legendRetires,
        args: [p.name],
        date: on,
        key: 'intlRet:${r.playerId}',
        nation: nation,
        seed: career.rngSeed,
      ),
    );
  }

  // WHO is in the squad, and who they are playing next. The same two
  // readings the conference is built on — see [squadStoriesProvider] —
  // so the room and the country are talking about one week rather than
  // two. Dated today, like a grievance: a selection is a thing that is
  // true now, not a thing that happened on an afternoon.
  final mood = standingsSoFar.isEmpty
      ? ResultStanding.par
      : standingsSoFar.last;
  for (final s in await ref.watch(squadStoriesProvider(careerId).future)) {
    posts.addAll(
      YFeed.forPlayer(
        topic: s.topic,
        subject: PressSubjectPlayer(
          playerId: s.playerId,
          name: s.name,
          count: s.count,
        ),
        date: career.inGameDate,
        // ':' and never '|': the detail view groups a conversation by the
        // part before the FIRST pipe.
        key: '${s.topic.name}:${s.playerId}:${s.count}',
        nation: nation,
        seed: career.rngSeed,
        standing: mood,
        history: standingsSoFar,
      ),
    );
  }
  for (final s in await ref.watch(
    opponentStoriesProvider(careerId).future,
  )) {
    final them = nations
        .where((n) => n.id == s.nationId)
        .map((n) => n.name)
        .firstOrNull;
    if (them == null) continue;
    posts.addAll(
      YFeed.forOpponent(
        topic: s.topic,
        subject: PressSubjectOpponent(
          s.nationId,
          count: s.count,
          favourable: s.favourable,
        ),
        opponent: them,
        date: career.inGameDate,
        key: '${s.topic.name}:${s.nationId}:${s.count}',
        nation: nation,
        seed: career.rngSeed,
        standing: mood,
        history: standingsSoFar,
      ),
    );
  }

  // And what he said on the record, once it has been judged. Dated the
  // day it was settled, so it sits next to the match that decided it.
  for (final s in await ref.watch(
    pressStatementsProvider(careerId).future,
  )) {
    // A statement from a previous job is not posted under the new nation.
    if (s.nationId != career.nationId) continue;
    final judgedOn = s.judgedOn;
    if (judgedOn == null) continue;
    // Toned by the run as it stood the day it was judged, never by today's:
    // an older post says now what it said then.
    final then = YFeed.standingsAsOf(datedStandings, judgedOn);
    posts.addAll(
      YFeed.forStatement(
        s: s,
        nation: nation,
        seed: career.rngSeed,
        standing: then.isEmpty ? ResultStanding.par : then.last,
        history: then,
      ),
    );
  }

  // A camp scandal: the story when it breaks, and the room on what the
  // manager did about it. A Czech feed has its cameos under it too.
  final czech = ref.watch(uiLanguageCodeProvider) == 'cs';
  final familyFirst = familyFirstLanguages.contains(
    ref.watch(uiLanguageCodeProvider),
  );
  final scandals = <({CampScandalRecord? record, PendingScandal? pending})>[
    for (final r in await ref.watch(campScandalsProvider(careerId).future))
      (record: r, pending: null),
    if (await ref.watch(pendingScandalProvider(careerId).future) case final p?)
      (record: null, pending: p),
  ];
  for (final s in scandals) {
    final record = s.record;
    final pending = s.pending;
    final cycle = record?.cycle ?? pending!.cycle;
    final playerId = record?.playerId ?? pending!.playerId;
    final window = record?.window ?? pending!.window;
    // A scandal from a previous job is not posted under the new nation,
    // like a statement (above). A job only changes as a cycle turns, so
    // the spell's first day is the line.
    if (window.isBefore(since)) continue;
    final name =
        pending?.playerName ??
        (await playerRepo.byId(
          playerId,
          agingYears: aging,
          saveSeed: career.rngSeed,
          careerId: career.id,
        ))?.name;
    if (name == null) continue;
    final on = CampScandal.brokeOn(window);
    final then = YFeed.standingsAsOf(datedStandings, on);
    posts.addAll(
      YFeed.forScandal(
        kind: record?.kind ?? pending!.kind,
        playerName: name,
        choice: record?.choice,
        date: on,
        key: CampScandal.pressKeyOf(cycle, playerId),
        nation: nation,
        seed: career.rngSeed,
        czechCameos: czech,
        familyFirst: familyFirst,
        standing: then.isEmpty ? ResultStanding.par : then.last,
        history: then,
      ),
    );
  }

  // A dubious general sponsor (see `Sponsors`): the story the day it was
  // signed, and the room laughing under it. Read off the press row the deal
  // left, which carries the brand and the day; only this job's.
  // A brand the career's world added is read off its own copy of that world;
  // one that cannot be read is reported and the feed goes on without it.
  final words = ref.watch(appLocalizationsProvider);
  final addedSponsors = await careerSponsorsForDisplay(
    ref.watch(worldPackRepositoryProvider),
    careerId,
  );
  for (final a
      in await ref.watch(careerRepositoryProvider).pressAnswers(careerId)) {
    final brand = Sponsors.brandOfPressKey(
      a.questionKey,
      extra: addedSponsors,
    );
    if (brand == null || !brand.risky) continue;
    if (a.answeredAt.isBefore(since)) continue;
    final then = YFeed.standingsAsOf(datedStandings, a.answeredAt);
    posts.addAll(
      YFeed.forSponsor(
        brand: sponsorBrandName(words, brand),
        date: a.answeredAt,
        key: a.questionKey,
        nation: nation,
        seed: career.rngSeed,
        standing: then.isEmpty ? ResultStanding.par : then.last,
        history: then,
      ),
    );
  }

  // Ivan Havíř, Czech feed only, rarely: under the big disappointments
  // and on his own when a qualifying campaign came up short.
  final all = YFeed.withHavir(
    posts,
    czechCameos: czech,
    // Read only for a Czech feed, and only what a miss is read off:
    // this cycle's campaigns and the group stages of the two finals they
    // feed. Never the career's every fixture, which grows without end.
    misses: czech ? await _cycleMisses(ref, career, nations) : const [],
  );

  // Mařena, KudyChodíKrálík and POŠUK under the results, Czech feed only.
  final withRegulars = YFeed.withRegulars(all, czechCameos: czech);

  // The nation's own supporters, under the side's results and big moments,
  // in every language (see [YLocals]).
  final withLocals = YLocals.withLocals(
    withRegulars,
    cast: await _localFans(ref, career, world),
    seed: career.rngSeed,
    dated: datedStandings,
  );

  // Ordering, the cap and the reserve live in the tested pure layer. A
  // custom world's renamed accounts take their new names last, on the
  // finished feed, so each keeps the voice it posted in.
  return YFeed.renamedIn(YFeed.timeline(withLocals), world);
}

/// The manager's nation's local fans (see [YLocals.castFor]): named from the
/// nation's own lists (a custom [world]'s, when it has them), ordinary given
/// names first, and never a real international, a player in the nation's
/// current pool or the manager.
Future<List<YPersona>> _localFans(
  Ref ref,
  Career career,
  ActiveWorld world,
) async {
  final YNamePool pool;
  if (world.pack?.nameLists[career.nationId] case final packLists?) {
    pool = YLocals.poolFromPack(packLists);
  } else {
    final lists = (await ref
        .watch(seedSourceProvider)
        .nameLists())[career.nationId];
    if (lists == null) return const [];
    pool = YLocals.poolFrom(
      first: lists.first,
      firstMore: lists.firstMore,
      sur: lists.sur,
      surMore: lists.surMore,
    );
  }
  final squad = await ref.watch(squadDataProvider(career.id).future);
  return YLocals.castFor(
    pool: pool,
    nation: '${career.nationId}',
    seed: career.rngSeed,
    avoid: {
      ...realInternationalNames,
      for (final p in squad?.pool ?? const <Player>[]) p.name,
      career.managerName,
    },
  );
}

/// How many posts the manager has not seen.
///
/// Y posts are derived from events rather than stored, so there is nothing to
/// mark read one by one: the count is everything newer than the watermark the
/// feed writes when he opens it. A save that has never opened the feed has
/// everything unread, which is what a brand-new manager should see.
final AutoDisposeFutureProviderFamily<int, int> yUnreadCountProvider =
    FutureProvider.autoDispose.family<int, int>((ref, careerId) async {
      final career = await ref.watch(careerRepositoryProvider).byId(careerId);
      if (career == null) return 0;
      final posts = (await ref.watch(yFeedProvider(careerId).future)).posts;
      final since = career.yReadAt;
      if (since == null) return posts.length;
      return posts.where((p) => p.date.isAfter(since)).length;
    });

/// Marks the feed read up to its newest post.
final Provider<YReadService> yReadServiceProvider = Provider<YReadService>(
  YReadService.new,
);

/// Records that the manager has looked at Y.
class YReadService {
  YReadService(this._ref);

  final Ref _ref;

  /// Stamps the watermark at the newest post's date, so opening the feed
  /// clears the badge — and a post that arrives later still counts as unread.
  Future<void> markRead(int careerId) async {
    final posts = (await _ref.read(yFeedProvider(careerId).future)).posts;
    if (posts.isEmpty) return;
    final newest = posts
        .map((p) => p.date)
        .reduce((a, b) => a.isAfter(b) ? a : b);
    await _ref.read(careerRepositoryProvider).setYReadAt(careerId, newest);
    _ref
      ..invalidate(careerByIdProvider(careerId))
      ..invalidate(yUnreadCountProvider(careerId));
  }
}

/// What the country thinks of the manager, 0–100.
///
/// Read by the board — see [PublicMood] for why this measures expectation
/// against reality rather than re-reading the results the board already weighs.
final AutoDisposeFutureProviderFamily<int, int> publicMoodProvider =
    FutureProvider.autoDispose.family<int, int>((ref, careerId) async {
      final judged = await ref.watch(yJudgedProvider(careerId).future);
      // The mood the board reads is about HIM: only the matches of his own
      // spell (the feed still remembers the rest).
      final repo = ref.watch(careerRepositoryProvider);
      final career = await repo.byId(careerId);
      final since = career == null
          ? null
          : (await currentSpell(repo, career)).since;
      return PublicMood.of([
        for (final j in judged)
          if (since == null || !j.date.isBefore(since))
            (
              nationRank: j.nationRank,
              opponentRank: j.opponentRank,
              won: j.scored > j.conceded,
              drew: j.scored == j.conceded,
            ),
      ]);
    });

/// What the country said about the tournaments themselves — the trophy, the
/// exit, the place booked, the one that is nearly here.
///
/// Everything is derived from fixtures the save already holds, so each post
/// carries a REAL date and sorts among the match reports where it belongs. The
/// reading of those fixtures lives in [YTournaments], where it can be asked
/// about every competition the game runs without simulating a career first.
///
/// Whether a place booked came against the odds, and an exit broke hearts, is
/// read off the campaign's own meetings ([judged], the cycle's frozen ranks;
/// [fixtures] tie each to its competition), so the fans lose their minds
/// only when the moment deserves it (see [YFeed.forMilestone]).
List<YPost> _tournamentPosts(
  List<YMilestone> milestones, {
  required String nation,
  required int seed,
  required List<YJudged> judged,
  required List<Fixture> fixtures,
  required List<({DateTime date, ResultStanding standing})> dated,
}) {
  final byId = {for (final f in fixtures) f.id: f};
  // The nation's played meetings in competition [id], oldest first.
  List<(Fixture, YJudged)> meetingsIn(int id) => [
    for (final j in judged.reversed)
      if (byId[int.tryParse(j.key.replaceFirst('fx:', ''))] case final f?
          when f.competitionId == id)
        (f, j),
  ];
  // The competition a milestone's key names: 'qual:<id>' or 'out:cmp:<id>'.
  int? competitionOf(String key) => int.tryParse(key.split(':').last);
  return [
    for (final m in milestones)
      ...() {
        final id = competitionOf(m.key);
        final meetings = id == null
            ? const <(Fixture, YJudged)>[]
            : meetingsIn(id);
        final last = meetings.lastOrNull;
        final ranks = [for (final (_, j) in meetings) j.opponentRank];
        return YFeed.forMilestone(
          m,
          nation: nation,
          seed: seed,
          againstTheOdds:
              m.template == YTemplate.qualified &&
              last != null &&
              YTournaments.qualifiedAgainstTheOdds(
                nationRank: last.$2.nationRank,
                opponentRanks: ranks,
              ),
          painful:
              m.template == YTemplate.eliminated &&
              last != null &&
              YTournaments.painfulExit(
                exitRound: YTournaments.coreRound(last.$1.round),
                nationRank: last.$2.nationRank,
                opponentRanks: ranks,
              ),
          history: YFeed.standingsAsOf(dated, m.date),
        );
      }(),
  ];
}

/// Every milestone the manager's nation's campaigns have reached in a career
/// (see [YTournaments.milestones]).
///
/// One provider that the feed and the fan mood both watch: each used to read
/// every fixture of the career on its own, which in a late save is tens of
/// thousands of rows twice per sim step. Invalidated with them after a step.
final AutoDisposeFutureProviderFamily<List<YMilestone>, int>
yMilestonesProvider = FutureProvider.autoDispose.family<List<YMilestone>, int>((
  ref,
  careerId,
) async {
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) return const [];
  return _milestones(ref, careerId: careerId, nationId: career.nationId);
});

Future<List<YMilestone>> _milestones(
  Ref ref, {
  required int careerId,
  required int nationId,
}) async {
  final comp = ref.watch(competitionRepositoryProvider);
  final fixtures = await comp.fixturesForNation(careerId, nationId);
  if (fixtures.isEmpty) return const [];
  return YTournaments.milestones(
    nationFixtures: fixtures,
    // The rest of the world's fixtures, which is what a group finish has to be
    // read against: the nation's own say only that it has no match left, and
    // that is true of a group winner waiting on a draw as much as of a side on
    // the plane home.
    worldFixtures: await comp.allFixtures(careerId),
    names: await comp.competitionNames(careerId),
    nationId: nationId,
  );
}

/// The milestones that move the stands, as [FanMood] reads them.
List<FanEvent> fanEventsOf(Iterable<YMilestone> milestones) => [
  for (final m in milestones)
    if (switch (m.template) {
          YTemplate.trophy => FanEventKind.trophy,
          YTemplate.runnerUp => FanEventKind.runnerUp,
          YTemplate.qualified => FanEventKind.qualified,
          YTemplate.eliminated => FanEventKind.eliminated,
          _ => null,
        }
        case final kind?)
      (kind: kind, date: m.date),
];

/// What the supporters feel about the manager's nation today (see
/// [FanMood]): the nation's recent run against expectation and what the
/// tournaments did (a place booked, an exit, a trophy). Read by the crowd at a home game, the stadium
/// income and the mood line on the finances screen.
///
/// The nation's whole run, not only his spell: the stands were there before
/// he was. Derived, never stored. Deliberately NOT leaning on the board's
/// verdict: the match preview reads this for the crowd, and a press answer
/// that moved the board would otherwise re-simulate the match behind it.
final AutoDisposeFutureProviderFamily<FanMoodReading, int> fanMoodProvider =
    FutureProvider.autoDispose.family<FanMoodReading, int>((
      ref,
      careerId,
    ) async {
      final career = await ref.watch(careerRepositoryProvider).byId(careerId);
      if (career == null) {
        return FanMood.of(results: const [], asOf: DateTime(2000));
      }
      final judged = await ref.watch(yJudgedProvider(careerId).future);
      final milestones = await ref.watch(
        yMilestonesProvider(careerId).future,
      );
      return FanMood.of(
        results: [
          for (final j in judged)
            (
              nationRank: j.nationRank,
              opponentRank: j.opponentRank,
              scored: j.scored,
              conceded: j.conceded,
              competitive: j.competitive,
              date: j.date,
              shootoutWon: j.shootoutWon,
            ),
        ],
        asOf: career.inGameDate,
        events: fanEventsOf(milestones),
      );
    });

/// The game languages whose names are written family name first, so a
/// protest hashtag chants the first word of the manager's name (see
/// [YFeed.hashtagOf]).
const Set<String> familyFirstLanguages = {'hu', 'ja', 'ko', 'vi'};

/// This cycle's failed qualifications for the manager's nation (see
/// [YTournaments.missedQualifications]), read off the current World
/// Championship and the manager's continental finals group stages only: a
/// few dozen fixtures, whatever the age of the career.
Future<List<({DateTime date, String key})>> _cycleMisses(
  Ref ref,
  Career career,
  List<Nation> nations,
) async {
  final comp = ref.read(competitionRepositoryProvider);
  final conf = nations
      .where((n) => n.id == career.nationId)
      .firstOrNull
      ?.confederation;
  return YTournaments.missedQualifications(
    nationFixtures: await comp.cycleFixturesForNation(
      career.id,
      career.nationId,
    ),
    worldFixtures: [
      ...await comp.fixturesByRound(career.id, 'GROUP'),
      if (conf != null)
        ...await comp.fixturesByRound(
          career.id,
          'CGROUP',
          kind: CompetitionKind.continentalFinals,
          confederation: conf,
        ),
    ],
    nationId: career.nationId,
  );
}
