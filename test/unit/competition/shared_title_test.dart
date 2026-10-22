import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';

import '../../helpers/test_database.dart';

/// Czechoslovakia's 1976 European Championship belongs to both its successor
/// states: UEFA recognises the Czech Republic and Slovakia alike. Slovakia
/// used to have no European title at all.
void main() {
  test(
    'the 1976 European Championship is Czechia\'s and Slovakia\'s',
    () async {
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
                  .create(nationId: nations.first.id, managerName: 'M'))
              .valueOrNull!;
      int id(String name) => nations.firstWhere((n) => n.name == name).id;

      final honours = await c
          .read(competitionRepositoryProvider)
          .honours(career.id);
      final euro76 = honours.singleWhere(
        (h) => h.competition == 'European Championship' && h.year == 1976,
      );
      expect(
        euro76.champions,
        unorderedEquals([id('Czechia'), id('Slovakia')]),
      );
      // Still one final, one runner-up: West Germany lost it once.
      expect(euro76.runnerUpId, id('Germany'));

      // Nothing else is shared.
      expect(
        honours.where((h) => h.coChampionId != null),
        [euro76],
      );
      expect(
        honours
            .where((h) => h.champions.contains(id('Slovakia')))
            .map((h) => '${h.competition} ${h.year}'),
        ['European Championship 1976'],
      );
    },
  );
}
