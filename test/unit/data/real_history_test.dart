import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/real_history.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';

import '../../helpers/test_database.dart';

/// The seeded roll of honour, including the Nations Cup (real UEFA Nations
/// League finals), so the records read as populated from the first day.
void main() {
  test('the Nations Cup honours roll is seeded with real winners', () async {
    final db = createTestDatabase();
    final nations = (jsonDecode(
      File('assets/data/nations.json').readAsStringSync(),
    ) as List<dynamic>)
        .map((e) => Nation.fromJson(e as Map<String, Object?>))
        .toList();

    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: const []),
        ),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(db.close);

    await container.read(seedLoaderProvider).ensureSeeded();
    final player = nations.first;
    final career = (await container.read(careerServiceProvider).create(
          nationId: player.id,
          managerName: 'M',
        ))
        .valueOrNull!;

    final honours = await container
        .read(competitionRepositoryProvider)
        .honours(career.id);
    final nc = honours.where((h) => h.competition == 'Nations Cup').toList();

    // Every seeded Nations League edition resolved to real nations.
    final seeded = RealHistory.editions
        .where((e) => e.competition == RealHistory.nationsCup)
        .toList();
    expect(seeded, isNotEmpty, reason: 'the data itself must carry them');
    expect(
      nc.length,
      seeded.length,
      reason: 'every seeded edition should resolve and be recorded',
    );

    final byName = {for (final n in nations) n.name: n.id};
    // 2023 Spain (won a 0–0 final on penalties) is a good spot-check.
    final spain2023 = nc.firstWhere((h) => h.year == 2023);
    expect(spain2023.championId, byName['Spain']);
    expect(spain2023.runnerUpId, byName['Croatia']);
    expect(
      spain2023.finalHomeScore,
      spain2023.finalAwayScore,
      reason: 'a level final marks a penalty win',
    );

    // 2019 Portugal, the first edition.
    final portugal2019 = nc.firstWhere((h) => h.year == 2019);
    expect(portugal2019.championId, byName['Portugal']);
  }, timeout: const Timeout(Duration(minutes: 2)));
}
