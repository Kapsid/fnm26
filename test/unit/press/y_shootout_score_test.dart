import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/y/y_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_database.dart';

const int _montenegro = 35;
const int _sweden = 51;

/// Promo-reel run: a 1-1 won 4-3 on penalties was quoted by the feed as
/// "2-1", the stored score that credits the shootout winner an extra goal.
/// The feed reads the level score, and who won the kicks separately.
void main() {
  test('Y reads a shootout at its level score, the kicks apart', () async {
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
    final f = [
      for (final f in await comp.fixturesForNation(career.id, _montenegro))
        if (f.round == 'FRIENDLY') f,
    ].single;
    // 1-1, won 4-3 on penalties: stored 2-1, as every tie on penalties is.
    await comp.recordResult(
      fixtureId: f.id,
      homeScore: 2,
      awayScore: 1,
      afterExtraTime: true,
      homePenalties: 4,
      awayPenalties: 3,
    );

    final sub = c.listen(yJudgedProvider(career.id).future, (_, _) {});
    final j = (await sub.read()).single;
    sub.close();
    expect((j.scored, j.conceded), (1, 1));
    expect(j.shootoutWon, isTrue);
  });
}
