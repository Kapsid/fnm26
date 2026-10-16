import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/achievements/achievement_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/budget_setup_screen.dart';
import 'package:fnm/features/hub/hub_providers.dart';

import '../../helpers/test_database.dart';

/// An achievement is unlocked when it happens, not at the next match the
/// manager happens to watch.
///
/// Achievements used to be checked only on the live match screen. Reaching the
/// World Championship is settled at the finals draw (the draw is the
/// qualification), and a side that plays no friendly in between watches its
/// first finals match next: so "World Championship Qualifier" popped up after
/// the first game AT the finals, as if it were news about getting there.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'the World Championship qualifier unlocks at the finals draw',
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

      // A side strong enough to be sure of the finals.
      final player = ([...nations]..sort((a, b) => a.ranking - b.ranking))[3];
      final career =
          (await container
                  .read(careerServiceProvider)
                  .create(nationId: player.id, managerName: 'M'))
              .valueOrNull!;
      final comp = container.read(competitionRepositoryProvider);
      final season = container.read(seasonServiceProvider);
      await comp.markDrawWatched(
        career.id,
        career.cyclePointer,
        budgetSetupKind,
      );

      // Step the world (never the live match screen) until the manager's
      // nation is in the finals draw.
      var drawn = false;
      var last = DateTime(1900);
      for (var i = 0; i < 800 && !drawn; i++) {
        await season.advance(career.id);
        final fixtures = await comp.fixturesForNation(career.id, player.id);
        drawn = fixtures.any((f) => f.round == 'GROUP');
        final now =
            (await container.read(careerRepositoryProvider).byId(career.id))!
                .inGameDate;
        if (!now.isAfter(last) && !drawn) break;
        last = now;
      }
      expect(drawn, isTrue, reason: 'the side must reach the finals draw');
      final fixtures = await comp.fixturesForNation(career.id, player.id);
      expect(
        fixtures.where((f) => f.round == 'GROUP' && f.hasResult),
        isEmpty,
        reason: 'no finals match has been played yet',
      );

      expect(
        await comp.earnedAchievements(career.id),
        contains('qual_wc'),
        reason: 'qualifying is locked in at the draw, so is its achievement',
      );
      expect(
        container
            .read(pendingAchievementUnlocksProvider(career.id))
            .map((a) => a.id),
        contains('qual_wc'),
        reason: 'and it is waiting to be shown at the hub, not after a match',
      );
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );
}
