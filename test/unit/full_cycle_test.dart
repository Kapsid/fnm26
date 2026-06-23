import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';

import '../helpers/test_database.dart';

/// Drives an entire World Cup cycle with the real nation set: all
/// confederations qualify, the finals are drawn, the knockout runs, and a
/// champion is crowned.
void main() {
  test('a full cycle qualifies, runs the finals, and crowns a champion', () async {
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
    final career = (await container.read(careerServiceProvider).create(
          nationId: nations.first.id,
          managerName: 'A',
        ))
        .valueOrNull!;

    final season = container.read(seasonServiceProvider);
    int? champion;
    var lastDate = DateTime(1900);
    for (var i = 0; i < 400; i++) {
      await season.advance(career.id);
      final hub = await container.read(hubDataProvider(career.id).future);
      champion = hub!.championNationId;
      if (champion != null) break;
      // Stop if the clock stops moving (would mean nothing left to do).
      if (!hub.career.inGameDate.isAfter(lastDate)) break;
      lastDate = hub.career.inGameDate;
    }

    expect(champion, isNotNull, reason: 'a World Cup champion should emerge');
    expect(nations.map((n) => n.id), contains(champion));

    // The roll of honour records the completed tournament.
    final honours = await container
        .read(competitionRepositoryProvider)
        .honours(career.id);
    expect(honours, isNotEmpty);
    expect(honours.first.championId, champion);
  }, timeout: const Timeout(Duration(minutes: 3)));
}
