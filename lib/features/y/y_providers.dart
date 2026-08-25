import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/rounds.dart';
import 'package:fnm/domain/services/press/public_mood.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';
import 'package:fnm/domain/services/achievements/board_satisfaction.dart';
import 'package:fnm/features/achievements/achievement_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/squad/grievance_providers.dart';

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
        for (final n in await ref.watch(nationRepositoryProvider).all())
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
        ));
      }
      return out;
    });

/// How many times two nations have to have met before the feed treats the
/// fixture as a rivalry.
const int rivalryMeetings = 4;

/// The feed: what the world has been saying, newest first.
final AutoDisposeFutureProviderFamily<List<YPost>, int> yFeedProvider =
    FutureProvider.autoDispose.family<List<YPost>, int>((ref, careerId) async {
      final career = await ref.watch(careerRepositoryProvider).byId(careerId);
      if (career == null) return const [];
      final nations = await ref.watch(nationRepositoryProvider).all();
      final nation = nations
          .where((Nation n) => n.id == career.nationId)
          .map((n) => n.name)
          .firstOrNull;
      if (nation == null) return const [];
      final judged = await ref.watch(_judgedProvider(careerId).future);

      // What else the world knows about each of those results: who scored,
      // what run the side was on, whether it was the neighbours. Without this
      // every post is assembled from a scoreline and repeats within a season.
      final comp = ref.watch(competitionRepositoryProvider);
      final scorers = await comp.scorersByFixture(careerId, career.nationId);
      final playerRepo = ref.watch(playerRepositoryProvider);
      final aging = CareerService.agingYears(career);

      // Oldest first, so a streak counts the matches BEFORE it.
      final chronological = judged.reversed.toList();
      final meetings = <String, int>{};
      var wins = 0;
      var losses = 0;
      final contexts = <YContext>[];
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
          );
          if (p != null) {
            scorerName = p.name;
            scorerGoals = best.value;
          }
        }

        contexts.add((
          match: (
            opponent: j.opponent,
            nationRank: j.nationRank,
            opponentRank: j.opponentRank,
            scored: j.scored,
            conceded: j.conceded,
            date: j.date,
            key: j.key,
          ),
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

      final posts = YFeed.forRun(
        contexts,
        nation: nation,
        seed: career.rngSeed,
      );
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
        await _tournamentPosts(
          ref,
          careerId: careerId,
          nationId: career.nationId,
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

      // Ordering and the cap live in the tested pure layer, not here.
      return YFeed.mostRecent(posts);
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
      final posts = await ref.watch(yFeedProvider(careerId).future);
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
    final posts = await _ref.read(yFeedProvider(careerId).future);
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
      return PublicMood.of([
        for (final j in judged)
          (
            nationRank: j.nationRank,
            opponentRank: j.opponentRank,
            won: j.scored > j.conceded,
            drew: j.scored == j.conceded,
          ),
      ]);
    });

/// A qualifying campaign counts as a place BOOKED when the nation turns up at
/// a finals within this long of its last qualifier. Two years: qualifying ends
/// roughly a year before the tournament it feeds, and a slack window is safer
/// than a tight one — a missed campaign has no finals fixtures at all, so
/// nothing here can turn a miss into a celebration.
const Duration _qualifyingReach = Duration(days: 730);

/// What the country said about the tournaments themselves — the trophy, the
/// exit, the place booked, the one that is nearly here.
///
/// Everything is derived from fixtures the save already holds, so each post
/// carries a REAL date and sorts among the match reports where it belongs. A
/// tournament is one competition row, which is what makes this safe across an
/// endless career: round codes repeat every four years, competition ids do not.
Future<List<YPost>> _tournamentPosts(
  Ref ref, {
  required int careerId,
  required int nationId,
  required String nation,
  required int seed,
}) async {
  final comp = ref.watch(competitionRepositoryProvider);
  final fixtures = await comp.fixturesForNation(careerId, nationId);
  if (fixtures.isEmpty) return const [];
  final names = await comp.competitionNames(careerId);

  final byCompetition = <int, List<Fixture>>{};
  for (final f in fixtures) {
    (byCompetition[f.competitionId] ??= []).add(f);
  }
  for (final list in byCompetition.values) {
    list.sort((a, b) => a.date.compareTo(b.date));
  }

  final milestones = <YMilestone>[];
  for (final entry in byCompetition.entries) {
    final list = entry.value;
    final competition = names[entry.key];
    if (competition == null) continue;
    final played = [
      for (final f in list)
        if (f.hasResult) f,
    ];
    // A campaign still has matches to come: nobody writes its obituary yet.
    final finished = played.length == list.length;
    final last = played.isEmpty ? null : played.last;

    // A finals tournament the nation has finished: it ended in a trophy, a
    // runners-up medal, or an exit. Which one is the last round they played.
    if (finished && last != null) {
      final home = last.homeNationId == nationId;
      final mine = home ? last.homeScore! : last.awayScore!;
      final theirs = home ? last.awayScore! : last.homeScore!;
      final milestone = YFeed.endOfCampaign(
        round: last.round,
        competition: competition,
        // A final settled on penalties is won by the shoot-out, not the score.
        won: last.wentToShootout
            ? (home
                  ? last.homePenalties! > last.awayPenalties!
                  : last.awayPenalties! > last.homePenalties!)
            : mine > theirs,
        date: last.date,
        key: 'cmp:${entry.key}',
      );
      if (milestone != null) milestones.add(milestone);
    }

    // A qualifying campaign that ended in a place at the finals. Qualifying is
    // the rounds a finals tournament does NOT use — World Cup qualifiers carry
    // no round code at all, continental ones carry 'CQ'.
    if (finished && last != null && _isQualifying(list)) {
      final reached = _finalsAfter(byCompetition, _familyOf(list), last.date);
      if (reached != null && names[reached] != null) {
        milestones.add((
          template: YTemplate.qualified,
          args: [names[reached]!],
          date: last.date,
          key: 'qual:${entry.key}',
        ));
      }
    }

    // And the one that has not started yet. Dated at its first match rather
    // than invented: the feed sorts by date, and a post about a tournament
    // must not land before the results it is anticipating.
    final firstUnplayed = list.where((f) => !f.hasResult).firstOrNull;
    if (firstUnplayed != null && played.isEmpty && _isFinals(list)) {
      milestones.add((
        template: YTemplate.tournamentSoon,
        args: [competition],
        date: firstUnplayed.date,
        key: 'soon:${entry.key}',
      ));
    }
  }

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

/// The core (confederation prefix stripped) of a fixture's round code.
String? _coreRound(String? round) {
  if (round == null) return null;
  return round.startsWith('C') || round.startsWith('N')
      ? round.substring(1)
      : round;
}

/// Whether a competition is a FINALS tournament — the rounds a trophy is won
/// in, as opposed to the campaign that gets a nation there.
bool _isFinals(List<Fixture> list) => list.any(
  (f) => YFeed.finalsRounds.contains(_coreRound(f.round)),
);

/// Whether a competition is a QUALIFYING campaign: no finals round anywhere in
/// it, and not a run of friendlies.
bool _isQualifying(List<Fixture> list) =>
    !_isFinals(list) && list.any((f) => f.round != Rounds.friendly);

/// Which competition a set of fixtures belongs to: 'C' for the continental
/// cup and its qualifiers, 'N' for the Nations Cup, '' for the World Cup and
/// its qualifiers (which carry the bare round codes, or none at all).
///
/// This is what stops a European qualifying campaign being credited with a
/// place at the NATIONS CUP, which runs alongside it: without a family the
/// rule "a finals tournament started shortly after this campaign ended" is
/// true of every tournament in the calendar.
String _familyOf(List<Fixture> list) {
  for (final f in list) {
    final round = f.round;
    if (round == null || round == Rounds.friendly) continue;
    if (round.startsWith('C')) return 'C';
    if (round.startsWith('N')) return 'N';
    return '';
  }
  // Nothing but uncoded fixtures: World Cup qualifying carries no round code.
  return '';
}

/// The finals competition of [family] the nation turned up at after [after],
/// or null when they did not — which is what a missed campaign looks like.
int? _finalsAfter(
  Map<int, List<Fixture>> byCompetition,
  String family,
  DateTime after,
) {
  for (final entry in byCompetition.entries) {
    final list = entry.value;
    if (!_isFinals(list)) continue;
    if (_familyOf(list) != family) continue;
    final first = list.first.date;
    if (first.isAfter(after) && first.difference(after) <= _qualifyingReach) {
      return entry.key;
    }
  }
  return null;
}
