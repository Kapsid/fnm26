import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/repositories/drift_competition_repository.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/stats/stats_providers.dart';

import '../../helpers/test_database.dart';

/// `careerStatsProvider` reads only the managed nations' fixtures and their
/// goals. Those scoped reads must hand back exactly what the old whole-save
/// reads did once filtered in Dart: same fixtures, same order, same goals in
/// the same per-fixture order (same-minute ties included).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('scoped fixture and goal reads equal the filtered full scans', () async {
    final db = createTestDatabase();
    addTearDown(db.close);
    final repo = DriftCompetitionRepository(db);
    final (:careerId, :container) = await _aCareer(db);

    final all = await repo.allFixtures(careerId);
    expect(all.length, greaterThan(20));
    final career = await container
        .read(careerRepositoryProvider)
        .byId(careerId);
    // The manager's nation plus a second one, as after a job switch.
    final other = all
        .map((f) => f.homeNationId)
        .firstWhere((n) => n != career!.nationId);
    final managed = {career!.nationId, other};

    // Goals in a spread of fixtures, managed or not, with same-minute ties.
    final rng = Random(7);
    final goals = <GoalRecord>[];
    for (final f in all) {
      if (rng.nextInt(3) == 0) continue;
      for (var i = 0; i < 4; i++) {
        goals.add((
          careerId: careerId,
          competitionId: f.competitionId,
          fixtureId: f.id,
          nationId: rng.nextBool() ? f.homeNationId : f.awayNationId,
          playerId: rng.nextInt(1000) + 1,
          minute: 10 + rng.nextInt(3),
        ));
      }
    }
    goals.shuffle(rng);
    await repo.recordGoals(goals);

    bool mine(int home, int away) =>
        managed.contains(home) || managed.contains(away);

    final expectedFixtures = [
      for (final f in all)
        if (mine(f.homeNationId, f.awayNationId)) f.id,
    ];
    expect(expectedFixtures, isNotEmpty);
    final scoped = await repo.allFixturesForNations(careerId, managed);
    expect(scoped.map((f) => f.id).toList(), expectedFixtures);

    final fullTimeline = await repo.goalTimeline(careerId);
    final expectedTimeline = {
      for (final e in fullTimeline.entries)
        if (expectedFixtures.contains(e.key)) e.key: e.value,
    };
    expect(expectedTimeline, isNotEmpty);
    final scopedTimeline = await repo.goalTimeline(
      careerId,
      forNations: managed,
    );
    expect(scopedTimeline, expectedTimeline);

    expect(await repo.allFixturesForNations(careerId, {}), isEmpty);
    expect(await repo.goalTimeline(careerId, forNations: {}), isEmpty);

    // And the provider itself still builds from them.
    await container.read(careerStatsProvider(careerId).future);
  });
}

Future<({int careerId, ProviderContainer container})> _aCareer(
  AppDatabase db,
) async {
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
  return (careerId: career.id, container: container);
}
