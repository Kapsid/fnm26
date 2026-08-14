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
import 'package:fnm/features/federation/budget_setup_screen.dart';
import 'package:fnm/features/hub/hub_providers.dart';

import '../../helpers/test_database.dart';

/// World Cup qualifying belongs in the second half of the cycle.
///
/// It used to be written with the rest of the calendar on the save's first day,
/// so the World Cup groups existed two years before the continental
/// championship that comes first had been played — and its draw ceremony was a
/// replay of fixtures that had been sitting in the database all along.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'qualifying is drawn only once the continental cup is decided',
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
                    managerName: 'M',
                  ))
              .valueOrNull!;

      final comp = container.read(competitionRepositoryProvider);
      final season = container.read(seasonServiceProvider);

      // Day one: the continental campaign exists, the World Cup does not.
      expect(
        await comp.hasTournament(
          career.id,
          CompetitionKind.continentalQualifying,
        ),
        isTrue,
        reason: 'the cycle opens with continental qualifying',
      );
      expect(
        await comp.hasTournament(career.id, CompetitionKind.worldCupQualifying),
        isFalse,
        reason: 'World Cup qualifying is not drawn on the first day',
      );

      await comp.markDrawWatched(
        career.id,
        career.cyclePointer,
        budgetSetupKind,
      );

      // Advance until the manager's continental championship has a winner.
      var last = DateTime(1900);
      int? champion;
      for (var i = 0; i < 500; i++) {
        champion = await comp.continentalChampion(
          career.id,
          confederation: Confederation.europe,
        );
        if (champion != null) break;
        // Before the cup is decided, qualifying must still be undrawn.
        expect(
          await comp.hasTournament(
            career.id,
            CompetitionKind.worldCupQualifying,
          ),
          isFalse,
          reason: 'qualifying must not appear before the continental cup ends',
        );
        await season.advance(career.id);
        final hub = await container.read(hubDataProvider(career.id).future);
        if (hub == null) break;
        if (!hub.career.inGameDate.isAfter(last)) break;
        last = hub.career.inGameDate;
      }
      expect(champion, isNotNull);

      // One more step and the qualifiers are drawn.
      await season.advance(career.id);
      expect(
        await comp.hasTournament(career.id, CompetitionKind.worldCupQualifying),
        isTrue,
        reason: 'the cup is over, so the road to the World Cup opens',
      );
    },
    timeout: const Timeout(Duration(minutes: 10)),
  );
}
