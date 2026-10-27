import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/domain/services/ranking/elo.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';
import 'package:fnm/features/y/y_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_database.dart';

const int _montenegro = 35; // 79th in the seed ranking
const int _sweden = 51; // 36th

/// Tester feedback: "I am managing with Montenegro (ranked in the 80s), I
/// drew France (1) at home and beat Sweden (35) at home, and on both
/// occasions the fan reaction was lukewarm."
///
/// Two fixes. Y judged every result on TODAY's live ranking, which already
/// holds the match's own result (the board had the same flaw, see
/// board_upset_win_test.dart): it now reads the ranking frozen at the start
/// of the cycle the match was played in. And giant killing has a tier of
/// its own: a euphoric win and a draw the country is proud of.
void main() {
  YMatch match({
    required int mine,
    required int theirs,
    required int scored,
    required int conceded,
    bool away = false,
    bool competitive = true,
    String opponent = 'France',
  }) => (
    opponent: opponent,
    nationRank: mine,
    opponentRank: theirs,
    scored: scored,
    conceded: conceded,
    date: DateTime(2030, 6, 10),
    key: 'fx:1',
    competitive: competitive,
    stakes: YStakes.qualifier,
    shootoutWon: null,
    away: away,
  );

  YContext ctx(YMatch m) => plainContext(m);

  group('the giant-killing tier', () {
    test('Montenegro (80s) holding France (1) at home: a proud draw', () {
      final m = match(mine: 84, theirs: 1, scored: 2, conceded: 2);
      expect(YFeed.classify(m), YTemplate.drewGiant);
      // The room turns up for it: the stats desk, a fan and a pundit at
      // least, and the fan is cheering.
      expect(YFeed.magnitudeOf(m).heat, greaterThanOrEqualTo(2));
      final posts = YFeed.forMatch(ctx(m), nation: 'Montenegro', seed: 7);
      expect(
        posts.where(
          (p) => p.voice == YVoice.fan && p.template == YTemplate.drewGiant,
        ),
        isNotEmpty,
      );
      expect(YFeed.moodOf(YTemplate.drewGiant), YMood.elation);
    });

    test('Montenegro beating Sweden (35) 6-2: euphoria', () {
      final m = match(
        mine: 79,
        theirs: 36,
        scored: 6,
        conceded: 2,
        opponent: 'Sweden',
      );
      expect(YFeed.classify(m), YTemplate.winEuphoric);
      final posts = YFeed.forMatch(ctx(m), nation: 'Montenegro', seed: 7);
      final result = posts.where((p) => p.template == YTemplate.winEuphoric);
      expect(result.map((p) => p.voice), containsAll([YVoice.fan]));
      // The scoreline and the opponent are in the post.
      expect(result.first.args, ['Sweden', '6–2']);
      expect(YFeed.moodOf(YTemplate.winEuphoric), YMood.elation);
    });

    test('a result between equals is no giant killing', () {
      expect(
        YFeed.classify(match(mine: 45, theirs: 47, scored: 2, conceded: 1)),
        isNot(YTemplate.winEuphoric),
      );
      expect(
        YFeed.classify(match(mine: 45, theirs: 47, scored: 1, conceded: 1)),
        YTemplate.drew,
      );
      // A good win over a side somewhat above stays the ordinary upset.
      expect(
        YFeed.classify(match(mine: 50, theirs: 25, scored: 1, conceded: 0)),
        YTemplate.winUpset,
      );
    });

    test('the top ten against a minnow needs a smaller gap', () {
      expect(
        YFeed.classify(match(mine: 35, theirs: 5, scored: 1, conceded: 1)),
        YTemplate.drewGiant,
      );
      expect(
        YFeed.classify(match(mine: 45, theirs: 20, scored: 1, conceded: 1)),
        YTemplate.drewHeroic,
      );
    });

    test('an away upset is bigger still', () {
      final home = match(mine: 60, theirs: 30, scored: 2, conceded: 1);
      final away = match(
        mine: 60,
        theirs: 30,
        scored: 2,
        conceded: 1,
        away: true,
      );
      expect(YFeed.classify(home), YTemplate.winUpset);
      expect(YFeed.classify(away), YTemplate.winEuphoric);
      final big = match(mine: 84, theirs: 1, scored: 1, conceded: 0);
      final bigAway = match(
        mine: 84,
        theirs: 1,
        scored: 1,
        conceded: 0,
        away: true,
      );
      expect(
        YFeed.magnitudeOf(bigAway).heat,
        greaterThanOrEqualTo(YFeed.magnitudeOf(big).heat),
      );
      final draw = match(mine: 84, theirs: 1, scored: 0, conceded: 0);
      final drawAway = match(
        mine: 84,
        theirs: 1,
        scored: 0,
        conceded: 0,
        away: true,
      );
      expect(
        YFeed.magnitudeOf(drawAway).heat,
        greaterThan(YFeed.magnitudeOf(draw).heat),
      );
    });

    test('the bigger the margin, the louder the night', () {
      final narrow = match(mine: 79, theirs: 36, scored: 1, conceded: 0);
      final rout = match(mine: 79, theirs: 36, scored: 6, conceded: 2);
      expect(YFeed.classify(narrow), YTemplate.winEuphoric);
      expect(
        YFeed.magnitudeOf(rout).heat,
        greaterThan(YFeed.magnitudeOf(narrow).heat),
      );
    });

    test('a friendly can be noticed, never celebrated', () {
      final m = match(
        mine: 84,
        theirs: 1,
        scored: 2,
        conceded: 2,
        competitive: false,
      );
      expect(YFeed.classify(m), isNot(YTemplate.drewGiant));
    });

    test('each tier has twelve wordings, four to a tone band', () {
      expect(YFeed.variantsFor(YTemplate.winEuphoric), 12);
      expect(YFeed.variantsFor(YTemplate.drewGiant), 12);
    });
  });

  test('Y judges a result on the ranking frozen at the cycle start', () async {
    SharedPreferences.setMockInitialValues({});
    final db = createTestDatabase();
    addTearDown(db.close);
    final nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List)
            .map((e) => Nation.fromJson(e as Map<String, Object?>))
            .toList();
    final c = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: const []),
        ),
      ],
    );
    addTearDown(c.dispose);
    await c.read(seedLoaderProvider).ensureSeeded();
    final rank = {for (final n in nations) n.id: n.ranking};
    final career =
        (await c
                .read(careerServiceProvider)
                .create(nationId: _montenegro, managerName: 'M'))
            .valueOrNull!;
    final comp = c.read(competitionRepositoryProvider);
    await comp.saveFriendlies(
      careerId: career.id,
      nationId: _montenegro,
      cycle: 0,
      friendlies: [
        (date: DateTime(2026, 8, 1), opponentId: _sweden, home: true),
      ],
    );
    final f = [
      for (final f in await comp.fixturesForNation(career.id, _montenegro))
        if (f.round == 'FRIENDLY') f,
    ].single;
    await comp.recordResult(fixtureId: f.id, homeScore: 6, awayScore: 2);
    // Move the live ranking the way the hub's sim step does after a result:
    // Montenegro climbs well above where it started, Sweden drops.
    final ranking = c.read(rankingRepositoryProvider);
    final seed = {
      for (final n in nations) n.id: Elo.seedFromRanking(n.ranking),
    };
    final points = {...await ranking.pointsFor(career.id, seed)};
    final order = points.keys.toList()
      ..sort((a, b) => points[b]!.compareTo(points[a]!));
    int at(int place) => points[order[place - 1]]!;
    points[_montenegro] = at(50) + 1;
    points[_sweden] = at(55) - 1;
    await ranking.save(career.id, points);
    c.invalidate(worldRankingProvider);

    final sub = c.listen(yJudgedProvider(career.id).future, (_, _) {});
    final judged = await sub.read();
    sub.close();
    final j = judged.single;
    expect(j.nationRank, rank[_montenegro]);
    expect(j.opponentRank, rank[_sweden]);
    expect(j.away, isFalse);
  });

  test('after a sim step the new match is talked about', () async {
    SharedPreferences.setMockInitialValues({});
    final db = createTestDatabase();
    addTearDown(db.close);
    final nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List)
            .map((e) => Nation.fromJson(e as Map<String, Object?>))
            .toList();
    final c = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: const []),
        ),
      ],
    );
    addTearDown(c.dispose);
    await c.read(seedLoaderProvider).ensureSeeded();
    final career =
        (await c
                .read(careerServiceProvider)
                .create(nationId: _montenegro, managerName: 'M'))
            .valueOrNull!;
    final comp = c.read(competitionRepositoryProvider);
    await comp.saveFriendlies(
      careerId: career.id,
      nationId: _montenegro,
      cycle: 0,
      friendlies: [
        (date: DateTime(2026, 8, 1), opponentId: _sweden, home: true),
      ],
    );
    // Kept alive, as the hub's Y panel and the public mood keep it.
    final judged = c.listen(yJudgedProvider(career.id).future, (_, _) {});
    final mood = c.listen(publicMoodProvider(career.id).future, (_, _) {});
    addTearDown(judged.close);
    addTearDown(mood.close);
    expect(await judged.read(), isEmpty);
    await mood.read();

    final f = [
      for (final f in await comp.fixturesForNation(career.id, _montenegro))
        if (f.round == 'FRIENDLY') f,
    ].single;
    await comp.recordResult(fixtureId: f.id, homeScore: 6, awayScore: 2);
    // What the hub's step does once the results are in: it refreshes the
    // live ranking (and the Y feed, the stands' mood and the rest by hand).
    c.invalidate(worldRankingProvider);
    final after = await judged.read();
    expect(after, hasLength(1));
    expect((after.single.scored, after.single.conceded), (6, 2));
  });
}
