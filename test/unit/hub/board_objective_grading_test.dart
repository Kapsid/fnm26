import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/achievements/board_satisfaction.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/budget_setup_screen.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/hub/objective_providers.dart';

import '../../helpers/test_database.dart';

/// The board's continental objective must actually be GRADED once the
/// manager's own championship has a winner.
///
/// Every confederation's cup is a competition of the same kind in the same
/// cycle, so a lookup that doesn't name the confederation returns an arbitrary
/// one — which left the manager's own cup unprogressed and its objective
/// reading "still to be decided" forever.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'the continental objective is graded once the cup has a champion',
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
      // Europe's best side: it reaches the finals, so the objective is graded on
      // a real run rather than on "did not qualify".
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
      await comp.markDrawWatched(
        career.id,
        career.cyclePointer,
        budgetSetupKind,
      );

      // Advance until the manager's OWN continental championship is decided.
      var last = DateTime(1900);
      int? champion;
      for (var i = 0; i < 500; i++) {
        champion = await comp.continentalChampion(
          career.id,
          confederation: Confederation.europe,
        );
        if (champion != null) break;
        await season.advance(career.id);
        final hub = await container.read(hubDataProvider(career.id).future);
        if (hub == null) break;
        if (!hub.career.inGameDate.isAfter(last)) break;
        last = hub.career.inGameDate;
      }
      expect(
        champion,
        isNotNull,
        reason: "the manager's own continental cup must be played out",
      );

      // The grading itself now lives in `cycleObjectiveOutcomesProvider` (so the
      // simulation can read it without a Flutter binding) and the worded provider
      // watches it — busting only the outer one would hand back the wording of a
      // cached, pre-champion grade.
      container
        ..invalidate(cycleObjectiveOutcomesProvider)
        ..invalidate(cycleObjectivesProvider);
      final objectives = await container.read(
        cycleObjectivesProvider(career.id).future,
      );
      final continental = objectives
          .where((o) => o.tier == TournamentTier.continental)
          .toList();
      expect(continental, hasLength(1));
      expect(
        continental.single.decided,
        isTrue,
        reason: 'the cup has a champion, so the brief is settled',
      );
      // The continental brief must not be worded as a World Cup one — it is the
      // same set of labels, so they have to stay competition-neutral.
      expect(continental.single.competition, isNot(contains('World')));
      expect(continental.single.label, isNot(contains('World Cup')));

      // The World Cup objective is still open at this point in the cycle.
      final world = objectives
          .where((o) => o.tier == TournamentTier.world)
          .single;
      expect(world.decided, isFalse);
    },
    timeout: const Timeout(Duration(minutes: 10)),
  );
}
