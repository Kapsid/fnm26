import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/repositories/drift_competition_repository.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/features/achievements/challenge_providers.dart';
import 'package:fnm/features/career/career_providers.dart';

import '../../helpers/test_database.dart';

/// A co-hosted edition used to lose every host but the first, so a tournament
/// shared by three nations read as one country's in the roll of honour — and
/// the manager's own co-hosted World Championship read as somebody else's.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('a co-hosted edition keeps every host, primary first', () async {
    final db = createTestDatabase();
    addTearDown(db.close);
    final repo = DriftCompetitionRepository(db);
    final careerId = await aCareer(db);

    // 2058, not 2026: the real seeded history now carries a 2026 World
    // Championship of its own, and `aCareer` seeds it into this same
    // database, so a synthetic edition needs a year real history never uses.
    await repo.recordHonour(
      careerId: careerId,
      year: 2058,
      competition: 'World Championship',
      championId: 1,
      runnerUpId: 2,
      thirdId: 3,
      hostIds: const [10, 11, 12],
    );

    final edition = await _edition(repo, careerId, 2058);
    expect(edition.hostId, 10);
    expect(edition.hostIds, [10, 11, 12]);
  });

  test('a single-host edition reads back one host', () async {
    final db = createTestDatabase();
    addTearDown(db.close);
    final repo = DriftCompetitionRepository(db);
    final careerId = await aCareer(db);

    await repo.recordHonour(
      careerId: careerId,
      year: 2030,
      competition: 'World Championship',
      championId: 1,
      runnerUpId: 2,
      hostIds: const [7],
    );

    expect((await _edition(repo, careerId, 2030)).hostIds, [7]);
  });

  test('an edition recorded with only a primary host still names it', () async {
    // What every call site that predates `hostIds` writes, and what every row
    // written before the column existed holds: a lone [hostId] and no list.
    final db = createTestDatabase();
    addTearDown(db.close);
    final repo = DriftCompetitionRepository(db);
    final careerId = await aCareer(db);

    await repo.recordHonour(
      careerId: careerId,
      year: 2034,
      competition: 'World Championship',
      championId: 1,
      runnerUpId: 2,
      hostId: 9,
    );

    expect((await _edition(repo, careerId, 2034)).hostIds, [9]);
  });

  test(
    'recordHonour given both hostId and a disagreeing hostIds normalises '
    'the list to start with hostId',
    () async {
      final db = createTestDatabase();
      addTearDown(db.close);
      final repo = DriftCompetitionRepository(db);
      final careerId = await aCareer(db);

      // hostIds.first (11) disagrees with hostId (10) — the stored list must
      // still begin with the stored primary, so the history row and the "won
      // at home" check never name different countries.
      await repo.recordHonour(
        careerId: careerId,
        year: 2038,
        competition: 'World Championship',
        championId: 1,
        runnerUpId: 2,
        hostId: 10,
        hostIds: const [11, 10, 12],
      );

      final edition = await _edition(repo, careerId, 2038);
      expect(edition.hostId, 10);
      expect(edition.hostIds, [10, 11, 12]);
    },
  );

  test(
    'a nation that is the second of three co-hosts is credited with winning '
    'at home',
    () async {
      final db = createTestDatabase();
      addTearDown(db.close);
      final repo = DriftCompetitionRepository(db);
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

      final coHostA = nations[1].id;
      final coHostB = nations[2].id;
      // The manager's own nation wins the World Championship it co-hosted —
      // but sits in the SECOND slot of the bid, behind coHostA.
      await repo.recordHonour(
        careerId: career.id,
        year: CareerService.worldCupYear(0),
        competition: 'World Championship',
        championId: career.nationId,
        runnerUpId: coHostA,
        hostIds: [coHostA, career.nationId, coHostB],
      );

      final views = await container.read(
        challengesViewProvider(career.id).future,
      );
      final grandTour = views.firstWhere((v) => v.def.id == 'ch_grand_tour');
      // "Home & Away" tracks two sub-goals (won as host, won as visitor); a
      // co-host win in any slot must still tick off the "host" half.
      expect(grandTour.current, 1);
    },
  );
}

/// The roll-of-honour entry for [year].
///
/// A new career is seeded with the real world's history, so the save already
/// holds decades of honours before this test records one of its own.
Future<Honour> _edition(
  DriftCompetitionRepository repo,
  int careerId,
  int year,
) async => (await repo.honours(careerId)).singleWhere((h) => h.year == year);

/// Seeds a world and starts a career in it, returning its id.
///
/// There is no shared helper for this yet; lift it into `test/helpers/` the
/// first time a second test file wants the same thing.
Future<int> aCareer(AppDatabase db) async {
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
