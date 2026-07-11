import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
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
    // The strongest European nation: room for a Nations League and a top-16
    // seed for the continental championship.
    final player = nations
        .where((n) => n.confederation == Confederation.europe)
        .reduce((a, b) => a.ranking <= b.ranking ? a : b);
    final career = (await container.read(careerServiceProvider).create(
          nationId: player.id,
          managerName: 'A',
        ))
        .valueOrNull!;

    // Europe has room before the Euros, so the player contests a real
    // qualifying stage (its finals are drawn from the qualifiers mid-season).
    // Friendlies are no longer auto-scheduled — the manager arranges them.
    final ownFixtures = await container
        .read(competitionRepositoryProvider)
        .fixturesForNation(career.id, player.id);
    expect(
      ownFixtures.any((f) => f.round == 'CQ'),
      isTrue,
      reason: 'the player should contest continental qualifying',
    );
    expect(
      await container
          .read(competitionRepositoryProvider)
          .hasTournament(career.id, CompetitionKind.continentalQualifying),
      isTrue,
      reason: 'a continental qualifying competition should exist',
    );
    expect(
      ownFixtures.any((f) => f.round == 'FRIENDLY'),
      isFalse,
      reason: 'friendlies are now manager-arranged, not auto-scheduled',
    );

    final season = container.read(seasonServiceProvider);

    Future<int?> runToChampion() async {
      var lastDate = DateTime(1900);
      for (var i = 0; i < 400; i++) {
        await season.advance(career.id);
        final hub = await container.read(hubDataProvider(career.id).future);
        if (hub!.championNationId != null) return hub.championNationId;
        if (!hub.career.inGameDate.isAfter(lastDate)) return null;
        lastDate = hub.career.inGameDate;
      }
      return null;
    }

    // Cycle 1: qualify → finals → champion.
    final champion = await runToChampion();
    expect(champion, isNotNull, reason: 'a World Cup champion should emerge');
    expect(nations.map((n) => n.id), contains(champion));

    // Endless rollover: starting the next cycle crowns a second champion.
    await season.startNextCycle(career.id);
    final secondChampion = await runToChampion();
    expect(
      secondChampion,
      isNotNull,
      reason: 'the next cycle should also crown a champion',
    );

    final comp = container.read(competitionRepositoryProvider);
    final honours = await comp.honours(career.id);
    // Real history (≤2024) plus two simulated World Cups (2030, 2034).
    expect(honours.where((h) => h.year >= 2030).length, greaterThanOrEqualTo(2));

    // Continental cups are simulated each cycle (held two years before the WC).
    expect(
      honours.any(
        (h) => h.competition == 'European Championship' && h.year == 2028,
      ),
      isTrue,
      reason: 'continental championships should run each cycle',
    );
  }, timeout: const Timeout(Duration(minutes: 4)));
}
