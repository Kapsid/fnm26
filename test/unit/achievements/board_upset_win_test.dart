import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/achievements/board_satisfaction.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/ranking/elo.dart';
import 'package:fnm/features/achievements/achievement_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_database.dart';

const int _montenegro = 35; // 79th in the seed ranking
const int _sweden = 51; // 36th
const int _wales = 55; // 37th
const int _hungary = 23; // 38th
const int _serbia = 47; // 39th

/// b8 item 5: "I beat Sweden 6-2 with Montenegro and the board didn't seem
/// impressed, I actually lost 1%."
///
/// The board weighs a result against a clearly stronger side as the
/// underdog's (+5 for a win, -1 for a defeat). It used to judge who was the
/// underdog on TODAY's live ranking, which already held the match's own
/// result: the win lifted Montenegro and dropped Sweden, so the same win was
/// re-read as one between near equals (+2), and every earlier defeat by a
/// side just above Montenegro was re-read from -1 to -5. A famous win could
/// leave the board flat or cost it a point. It is now judged on the ranking
/// frozen at the start of the cycle the match was played in.
void main() {
  test('an upset win over a much stronger side raises the board', () async {
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
    for (final id in [_sweden, _wales, _hungary, _serbia]) {
      // Each one the clear favourite against Montenegro by the seed ranking.
      expect(
        BoardSatisfaction.isUnderdog(
          ownRank: rank[_montenegro]!,
          opponentRank: rank[id]!,
        ),
        isTrue,
      );
    }
    final career =
        (await c
                .read(careerServiceProvider)
                .create(nationId: _montenegro, managerName: 'M'))
            .valueOrNull!;
    final comp = c.read(competitionRepositoryProvider);
    // Narrow defeats by the sides just above, then the night against Sweden.
    // Fewer than a full form window, so nothing drops out of it.
    final opponents = [_wales, _hungary, _serbia, _sweden];
    await comp.saveFriendlies(
      careerId: career.id,
      nationId: _montenegro,
      cycle: 0,
      friendlies: [
        for (var i = 0; i < opponents.length; i++)
          (
            date: DateTime(2026, 8, 1 + i * 3),
            opponentId: opponents[i],
            home: true,
          ),
      ],
    );
    final mine = [
      for (final f in await comp.fixturesForNation(career.id, _montenegro))
        if (f.round == 'FRIENDLY') f,
    ]..sort((a, b) => a.date.compareTo(b.date));
    expect(mine, hasLength(4));
    for (final f in mine.take(3)) {
      await comp.recordResult(fixtureId: f.id, homeScore: 0, awayScore: 1);
    }

    Future<int> satisfaction() async {
      c.invalidate(satisfactionProvider);
      final sub = c.listen(satisfactionProvider(career.id).future, (_, _) {});
      try {
        return await sub.read();
      } finally {
        sub.close();
      }
    }

    final before = await satisfaction();
    await comp.recordResult(
      fixtureId: mine.last.id,
      homeScore: 6,
      awayScore: 2,
    );
    // Move the live ranking the way the hub's sim step does after a result
    // (it saves rank_points): Montenegro climbs to about 65th and Sweden
    // drops to about 46th. Read live, that puts every match of the window
    // across the underdog line (46 x 2 > 65, 38 x 2 > 65): the old code
    // re-scored the win from +5 to +2 and each defeat from -1 to -5.
    final ranking = c.read(rankingRepositoryProvider);
    final seed = {
      for (final n in nations) n.id: Elo.seedFromRanking(n.ranking),
    };
    final points = {...await ranking.pointsFor(career.id, seed)};
    final order = points.keys.toList()
      ..sort((a, b) => points[b]!.compareTo(points[a]!));
    int at(int place) => points[order[place - 1]]!;
    points[_montenegro] = at(65) + 1;
    points[_sweden] = at(46) - 1;
    await ranking.save(career.id, points);
    c.invalidate(worldRankingProvider);
    final sub = c.listen(worldRankingProvider(career.id).future, (_, _) {});
    final live = (await sub.read())!;
    sub.close();
    final mneNow = live.position[_montenegro]!;
    final sweNow = live.position[_sweden]!;
    expect(
      BoardSatisfaction.isUnderdog(ownRank: mneNow, opponentRank: sweNow),
      isFalse,
      reason:
          'live, the win now reads as one between near equals '
          '($mneNow vs $sweNow)',
    );
    final after = await satisfaction();
    expect(
      after - before,
      greaterThanOrEqualTo(BoardSatisfaction.winAsUnderdog),
      reason:
          'the win is an underdog win, and the defeats before it stay '
          'underdog defeats (before $before, after $after)',
    );
  });
}
