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

/// The continental championships have NO third-place play-off (as the real
/// European Championship): no C3RD fixture is ever scheduled, but the two beaten
/// semi-finalists SHARE the bronze, so the honour records both of them.
void main() {
  test(
    'the continental cup shares bronze between both beaten semi-finalists',
    () async {
      final db = createTestDatabase();
      final nations =
          (jsonDecode(
                    File('assets/data/nations.json').readAsStringSync(),
                  )
                  as List<dynamic>)
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
      final player = nations
          .where((n) => n.confederation == Confederation.europe)
          .reduce((a, b) => a.ranking <= b.ranking ? a : b);
      final career =
          (await container
                  .read(careerServiceProvider)
                  .create(
                    nationId: player.id,
                    managerName: 'A',
                  ))
              .valueOrNull!;

      final season = container.read(seasonServiceProvider);
      final comp = container.read(competitionRepositoryProvider);

      // Advance until the European Championship (2028) is on the honours roll.
      var lastDate = DateTime(1900);
      for (var i = 0; i < 400; i++) {
        await season.advance(career.id);
        final hub = await container.read(hubDataProvider(career.id).future);
        final honours = await comp.honours(career.id);
        if (honours.any(
          (h) => h.competition == 'European Championship' && h.year == 2028,
        )) {
          break;
        }
        if (hub == null || !hub.career.inGameDate.isAfter(lastDate)) break;
        lastDate = hub.career.inGameDate;
      }

      final euro = (await comp.honours(career.id)).firstWhere(
        (h) => h.competition == 'European Championship' && h.year == 2028,
      );

      // No third-place play-off, but BOTH beaten semi-finalists share bronze —
      // recorded in the honour's two third-place slots.
      expect(
        euro.thirdId,
        isNotNull,
        reason: 'first bronze (a semi-final loser)',
      );
      expect(
        euro.thirdId2,
        isNotNull,
        reason: 'second bronze (the other semi-final loser)',
      );
      // Four distinct medallists: two finalists plus two shared-bronze sides.
      final medallists = {
        euro.championId,
        euro.runnerUpId,
        euro.thirdId,
        euro.thirdId2,
      };
      expect(
        medallists.length,
        4,
        reason: 'champion, runner-up and two distinct bronze medallists',
      );

      // No C3RD fixture is ever scheduled.
      final thirds = await comp.fixturesByRound(
        career.id,
        'C3RD',
        kind: CompetitionKind.continentalFinals,
      );
      expect(thirds, isEmpty, reason: 'no C3RD fixture should exist');
    },
  );
}
