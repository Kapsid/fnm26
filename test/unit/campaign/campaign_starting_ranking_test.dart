import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/repositories/drift_nation_repository.dart';
import 'package:fnm/data/seed/legacy_seed_ranking.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/campaign/campaigns.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/campaign/campaign_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_database.dart';

// 1.0.7 moved campaigns onto the real starting ranking (nations.json, FIFA
// 20 July 2026), the one a new career starts on. A run begun on the 1.0.6
// ranking keeps it.

List<T> _load<T>(String f, T Function(Map<String, Object?>) from) =>
    (jsonDecode(File('assets/data/$f').readAsStringSync()) as List)
        .map((e) => from(e as Map<String, Object?>))
        .toList();

final List<Nation> _nations = _load('nations.json', Nation.fromJson);
final List<Player> _players = _load('players.json', Player.fromJson);

/// The same world on the ranking every build up to 1.0.6 shipped.
final List<Nation> _legacyNations = [
  for (final n in _nations) n.copyWith(ranking: legacySeedRanking[n.id]!),
];

ProviderContainer _container(AppDatabase db, List<Nation> nations) {
  final c = ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
      premiumUnlockedProvider.overrideWith((ref) => true),
      seedSourceProvider.overrideWithValue(
        InMemorySeedSource(nationList: nations, playerList: _players),
      ),
    ],
  );
  addTearDown(c.dispose);
  return c;
}

Future<Map<int, int>> _cycle0Rows(AppDatabase db, int careerId) async => {
  for (final r in await (db.select(
    db.seedRankings,
  )..where((t) => t.careerId.equals(careerId) & t.cycle.equals(0))).get())
    r.nationId: r.rank,
};

Future<Map<int, int>> _ranksOf(AppDatabase db, int careerId) async => {
  for (final n in await DriftNationRepository(db).forCareer(careerId))
    n.id: n.ranking,
};

Future<Set<String>> _qualifyingGroups(
  ProviderContainer c,
  int careerId,
  Confederation confederation,
) async {
  final tables = await c
      .read(competitionRepositoryProvider)
      .tournamentGroupTables(
        careerId,
        CompetitionKind.continentalQualifying,
        confederation: confederation,
      );
  return {
    for (final t in tables)
      ([for (final s in t.standings) s.nationId]..sort()).join(','),
  };
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final current = {for (final n in _nations) n.id: n.ranking};

  test('a new campaign run starts on the nations.json ranking, frozen as '
      'its cycle-0 snapshot', () async {
    SharedPreferences.setMockInitialValues({});
    final db = createTestDatabase();
    addTearDown(db.close);
    final c = _container(db, _nations);
    await c.read(seedLoaderProvider).ensureSeeded();

    for (final def in [Campaigns.grudge, Campaigns.guineas]) {
      final run = await c
          .read(campaignServiceProvider)
          .start(def, managerName: 'Me');
      expect(await _cycle0Rows(db, run.id), current, reason: def.id);
      expect(await _ranksOf(db, run.id), current, reason: def.id);
    }
    // Spain lead it, as on the new-game picker.
    expect(current[Campaigns.legacy.nationId], 1);
  });

  test('a run started on the 1.0.6 ranking keeps it after the update: its '
      'ranks and its stored draw do not move', () async {
    SharedPreferences.setMockInitialValues({});
    final db = createTestDatabase();
    addTearDown(db.close);

    // Before: a 1.0.6 database (no cycle-0 rows anywhere), with a Grudge run
    // on its old seed, and a run from an early 1.0.7 build that already
    // froze the legacy ranking into its cycle-0 rows.
    final before = _container(db, _legacyNations);
    await before.read(seedLoaderProvider).ensureSeeded();
    Future<int> oldRun({Map<int, int> startingRanks = const {}}) async {
      final career =
          (await before
                  .read(careerServiceProvider)
                  .create(
                    nationId: Campaigns.grudge.nationId,
                    managerName: 'M',
                    rngSeed: 10, // Grudge's seed on the 1.0.6 ranking
                    countsTowardSlots: false,
                    startingRanks: startingRanks,
                  ))
              .valueOrNull!;
      await before
          .read(competitionRepositoryProvider)
          .markDrawWatched(career.id, 0, campaignMarker(Campaigns.grudge.id));
      return career.id;
    }

    final v106 = await oldRun();
    final early107 = await oldRun(startingRanks: legacySeedRanking);
    expect(await _cycle0Rows(db, v106), isEmpty);
    expect(await _cycle0Rows(db, early107), legacySeedRanking);
    final groups106 = await _qualifyingGroups(
      before,
      v106,
      Confederation.europe,
    );
    final groupsEarly = await _qualifyingGroups(
      before,
      early107,
      Confederation.europe,
    );
    // The scenario it was built on: Georgia and Albania drawn together.
    expect(groups106.where((g) => g.split(',').contains('19')), hasLength(1));
    expect(
      groups106.singleWhere((g) => g.split(',').contains('19')).split(','),
      contains('1'),
    );

    // The update: the same database, the new nations.json.
    final after = _container(db, _nations);
    await after.read(seedLoaderProvider).ensureSeeded();

    for (final id in [v106, early107]) {
      expect(await _cycle0Rows(db, id), legacySeedRanking);
      expect(await _ranksOf(db, id), legacySeedRanking);
    }
    expect(
      await _qualifyingGroups(after, v106, Confederation.europe),
      groups106,
    );
    expect(
      await _qualifyingGroups(after, early107, Confederation.europe),
      groupsEarly,
    );

    // Both still read as Grudge runs; a fresh run of another campaign starts
    // on the new ranking beside them.
    final runs = await after.read(campaignRunsProvider.future);
    expect(runs[Campaigns.grudge.id], isNotNull);
    final fresh = await after
        .read(campaignServiceProvider)
        .start(Campaigns.transplant, managerName: 'Me');
    expect(await _cycle0Rows(db, fresh.id), current);
  });
}
