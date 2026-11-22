import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/repositories/drift_competition_repository.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/features/career/career_providers.dart';

import '../../helpers/test_database.dart';

/// After a regional cup's knockout game (the ASEAN-style cup's two-legged
/// semi, say) the round results showed nothing: the repository only knew the
/// big tournaments' knockout rounds, so it fell through to the group path and
/// found no group. Every tie of the round is listed now, as for any knockout.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('a regional semi lists every tie of that round', () async {
    final db = createTestDatabase();
    addTearDown(db.close);
    final repo = DriftCompetitionRepository(db);
    final careerId = await _aCareer(db);
    final any = (await repo.allFixtures(careerId)).first;
    final me = (await db.select(db.careers).getSingle()).nationId;
    final day = DateTime(2040, 12, 20);
    Future<void> tie(int home, int away) => db
        .into(db.fixtures)
        .insert(
          FixturesCompanion.insert(
            careerId: careerId,
            competitionId: any.competitionId,
            matchday: 4,
            date: day,
            homeNationId: home,
            awayNationId: away,
            homeScore: const Value(2),
            awayScore: const Value(1),
            played: const Value(true),
            round: const Value('XASFL1'),
          ),
        );
    await tie(me, 9001);
    await tie(9002, 9003);

    final results = await repo.lastRoundResults(careerId, me);
    expect(results, isNotNull);
    expect(results!.stage, 'Semi-finals');
    expect(results.knockoutFixtures, hasLength(2));
  });

  test(
    'a regional second leg brings its first legs, for the aggregate',
    () async {
      final db = createTestDatabase();
      addTearDown(db.close);
      final repo = DriftCompetitionRepository(db);
      final careerId = await _aCareer(db);
      final any = (await repo.allFixtures(careerId)).first;
      final me = (await db.select(db.careers).getSingle()).nationId;
      Future<void> leg(String round, DateTime day, int home, int away) => db
          .into(db.fixtures)
          .insert(
            FixturesCompanion.insert(
              careerId: careerId,
              competitionId: any.competitionId,
              matchday: round.endsWith('1') ? 4 : 5,
              date: day,
              homeNationId: home,
              awayNationId: away,
              homeScore: const Value(1),
              awayScore: const Value(0),
              played: const Value(true),
              round: Value(round),
            ),
          );
      await leg('XASFL1', DateTime(2040, 12, 10), me, 9001);
      await leg('XASFL1', DateTime(2040, 12, 10), 9002, 9003);
      await leg('XASFL2', DateTime(2040, 12, 14), 9001, me);
      await leg('XASFL2', DateTime(2040, 12, 14), 9003, 9002);

      final results = (await repo.lastRoundResults(careerId, me))!;
      expect(results.knockoutFixtures, hasLength(2));
      expect(results.firstLegs, hasLength(2));
      expect(results.firstLegs.every((f) => f.round == 'XASFL1'), isTrue);
    },
  );
}

Future<int> _aCareer(AppDatabase db) async {
  final nations =
      (jsonDecode(File('assets/data/nations.json').readAsStringSync())
              as List<dynamic>)
          .map((e) => Nation.fromJson(e as Map<String, Object?>))
          .toList();
  final container = ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
      seedSourceProvider.overrideWithValue(
        InMemorySeedSource(nationList: nations, playerList: const []),
      ),
    ],
  );
  addTearDown(container.dispose);
  await container.read(seedLoaderProvider).ensureSeeded();
  final career =
      (await container
              .read(careerServiceProvider)
              .create(nationId: nations.first.id, managerName: 'M'))
          .valueOrNull!;
  return career.id;
}
