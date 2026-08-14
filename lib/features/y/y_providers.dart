import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/nation.dart';
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
