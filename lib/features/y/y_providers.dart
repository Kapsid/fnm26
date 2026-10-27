import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/config/ui_language.dart' show uiLanguageCodeProvider;
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/rounds.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/venue.dart' show isNeutralFinalsRound;
import 'package:fnm/domain/services/press/expectation.dart';
import 'package:fnm/domain/services/press/fan_mood.dart';
import 'package:fnm/domain/services/press/half_time_swing.dart';
import 'package:fnm/domain/services/press/press.dart';
import 'package:fnm/domain/services/press/public_mood.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/domain/services/press/y_tournaments.dart';
import 'package:fnm/domain/services/squad/camp_scandal.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';
import 'package:fnm/domain/services/achievements/board_satisfaction.dart';
import 'package:fnm/features/achievements/achievement_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/press/press_providers.dart';
import 'package:fnm/features/press/story_providers.dart';
import 'package:fnm/features/squad/camp_scandal_providers.dart';
import 'package:fnm/features/squad/grievance_providers.dart';
import 'package:fnm/features/squad/international_retirement_providers.dart';

/// The manager's played matches, newest first, with both sides' world
/// positions — the raw material both Y and the public's mood are built from.
///
/// Ranks are the CURRENT ones rather than the ones held on the day: the game
/// does not store a historical position per fixture, and a feed that quietly
/// re-judged old results as the ranking moved would be worse than one that
/// judges them all by today's standing.
typedef _Judged = ({
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
});

final AutoDisposeFutureProviderFamily<List<_Judged>, int> _judgedProvider =
    FutureProvider.autoDispose.family<List<_Judged>, int>((
      ref,
      careerId,
    ) async {
      await ref.watch(seedLoaderProvider).ensureSeeded();
      final career = await ref.watch(careerRepositoryProvider).byId(careerId);
      if (career == null) return const [];
      final ranking = await ref.watch(worldRankingProvider(careerId).future);
      final nations = {
        for (final n
            in await ref.watch(nationRepositoryProvider).forCareer(careerId))
          n.id: n,
      };
      final total = nations.length;
      int rankOf(int id) =>
          ranking?.position[id] ?? nations[id]?.ranking ?? total;

      final fixtures = await ref
          .watch(competitionRepositoryProvider)
          .fixturesForNation(careerId, career.nationId);
      final played = [
        for (final f in fixtures)
          if (f.hasResult) f,
      ]..sort((a, b) => b.date.compareTo(a.date));

      final out = <_Judged>[];
      for (final f in played) {
        final home = f.homeNationId == career.nationId;
        final opponentId = home ? f.awayNationId : f.homeNationId;
        final opponent = nations[opponentId];
        if (opponent == null) continue;
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
    FutureProvider.autoDispose.family<YTimeline, int>((ref, careerId) async {
      const empty = (posts: <YPost>[], reserveFrom: null);
      final career = await ref.watch(careerRepositoryProvider).byId(careerId);
      if (career == null) return empty;
      final nations = await ref
          .watch(nationRepositoryProvider)
          .forCareer(careerId);
      final nation = nations
          .where((Nation n) => n.id == career.nationId)
          .map((n) => n.name)
          .firstOrNull;
      if (nation == null) return empty;
      final judged = await ref.watch(_judgedProvider(careerId).future);

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
        final hurt = <String>[];
        for (final a in absences.values) {
          if (a.injuryMatches <= 0) continue;
          final p = await playerRepo.byId(
            a.playerId,
            agingYears: aging,
            saveSeed: career.rngSeed,
            careerId: career.id,
          );
          if (p != null) hurt.add(p.name);
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
        ),
      );

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
        if (await ref.watch(pendingScandalProvider(careerId).future)
            case final p?)
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

      // Ordering, the cap and the reserve live in the tested pure layer.
      return YFeed.timeline(all);
    });

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
      final judged = await ref.watch(_judgedProvider(careerId).future);
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
List<YPost> _tournamentPosts(
  List<YMilestone> milestones, {
  required String nation,
  required int seed,
}) {
  return [
    for (final m in milestones)
      ...YFeed.forEvent(
        template: m.template,
        args: m.args,
        date: m.date,
        key: m.key,
        nation: nation,
        seed: seed,
      ),
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
      final judged = await ref.watch(_judgedProvider(careerId).future);
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
