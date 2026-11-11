import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/repositories/drift_competition_repository.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/features/career/career_providers.dart';

import '../../helpers/test_database.dart';

/// An own goal is stored for the side it counted for with the defender's id
/// negated (see `GoalRecord`): the match's goal timeline keeps it, so a
/// comeback still reads as one, and no scorer chart ever lists it. No schema
/// change: old saves hold no negative id and read exactly as before.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'own goals stay in the timeline and out of every scorer tally',
    () async {
      final db = createTestDatabase();
      addTearDown(db.close);
      final repo = DriftCompetitionRepository(db);
      final careerId = await _aCareer(db);
      final f = (await repo.allFixtures(careerId)).first;
      const scorer = 4242;
      const defender = 5151;
      await repo.recordGoals([
        (
          careerId: careerId,
          competitionId: f.competitionId,
          fixtureId: f.id,
          nationId: f.homeNationId,
          playerId: scorer,
          minute: 12,
        ),
        // The visitors' defender turned it in: the hosts' goal.
        (
          careerId: careerId,
          competitionId: f.competitionId,
          fixtureId: f.id,
          nationId: f.homeNationId,
          playerId: -defender,
          minute: 70,
        ),
      ]);

      final timeline = await repo.goalTimeline(careerId, fixtureId: f.id);
      expect(timeline[f.id]!.map((g) => g.nationId), [
        f.homeNationId,
        f.homeNationId,
      ]);

      final byFixture = await repo.scorersByFixture(careerId, f.homeNationId);
      expect(byFixture[f.id], {scorer: 1});

      final ids = {
        for (final t in await repo.topScorers(careerId)) t.playerId,
        for (final t in await repo.allTimeTopScorers(careerId)) t.playerId,
        for (final t in await repo.nationTopScorers(careerId, f.homeNationId))
          t.playerId,
      };
      expect(ids, contains(scorer));
      expect(ids.any((id) => id < 0 || id == defender), isFalse);
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
