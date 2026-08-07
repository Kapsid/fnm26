import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/press/public_mood.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';
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
    FutureProvider.autoDispose.family<List<_Judged>, int>((ref, careerId) async {
  await ref.watch(seedLoaderProvider).ensureSeeded();
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) return const [];
  final ranking = await ref.watch(worldRankingProvider(careerId).future);
  final nations = {
    for (final n in await ref.watch(nationRepositoryProvider).all()) n.id: n,
  };
  final total = nations.length;
  int rankOf(int id) => ranking?.position[id] ?? nations[id]?.ranking ?? total;

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

  final posts = <YPost>[];
  for (final j in judged) {
    posts.addAll(
      YFeed.forMatch(
        (
          opponent: j.opponent,
          nationRank: j.nationRank,
          opponentRank: j.opponentRank,
          scored: j.scored,
          conceded: j.conceded,
          date: j.date,
          key: j.key,
        ),
        nation: nation,
        seed: career.rngSeed,
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

  // Ordering and the cap live in the tested pure layer, not here.
  return YFeed.mostRecent(posts);
});

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
