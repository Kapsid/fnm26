import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/budget_setup_screen.dart';
import 'package:fnm/features/hub/hub_providers.dart';

import '../../helpers/test_database.dart';

/// The world outside the manager's own fixtures must carry real match data.
///
/// It used to be results-only: nobody else was ever booked, suspended or
/// injured, and no performance data existed for any match the manager did not
/// play. That made squad depth the manager's problem alone and left awards
/// like a Team of the Tournament with nothing but goals to go on.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('background matches record ratings, box scores and absences', () async {
    final db = createTestDatabase();
    final nations = (jsonDecode(
      File('assets/data/nations.json').readAsStringSync(),
    ) as List<dynamic>)
        .map((e) => Nation.fromJson(e as Map<String, Object?>))
        .toList();
    // Real squads: this test is about what the world's players accumulate, so
    // an empty pool would make it pass vacuously.
    final players = (jsonDecode(
      File('assets/data/players.json').readAsStringSync(),
    ) as List<dynamic>)
        .map((e) => Player.fromJson(e as Map<String, Object?>))
        .toList();

    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: players),
        ),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(db.close);

    await container.read(seedLoaderProvider).ensureSeeded();
    final player = nations
        .where((n) => n.confederation == Confederation.europe)
        .reduce((a, b) => a.ranking <= b.ranking ? a : b);
    final career = (await container.read(careerServiceProvider).create(
          nationId: player.id,
          managerName: 'M',
        ))
        .valueOrNull!;

    final comp = container.read(competitionRepositoryProvider);
    final season = container.read(seasonServiceProvider);
    await comp.markDrawWatched(career.id, career.cyclePointer, budgetSetupKind);

    // Play a chunk of the cycle out in the background.
    var last = DateTime(1900);
    for (var i = 0; i < 25; i++) {
      await season.advance(career.id);
      final hub = await container.read(hubDataProvider(career.id).future);
      if (hub == null) break;
      if (!hub.career.inGameDate.isAfter(last)) break;
      last = hub.career.inGameDate;
    }

    // Ratings exist for nations the manager has nothing to do with.
    final others = nations
        .where((n) => n.id != player.id)
        .map((n) => n.id)
        .toSet();
    final lines = await comp.careerPlayerLines(career.id, others);
    expect(
      lines,
      isNotEmpty,
      reason: 'the rest of the world is rated, not just the manager',
    );
    expect(
      lines.any((l) => l.rating > 0),
      isTrue,
      reason: 'marks are real numbers',
    );
    expect(
      lines.any((l) => l.motm),
      isTrue,
      reason: 'background matches name a man of the match',
    );

    // Somebody, somewhere, has picked up a card or a knock.
    final absences =
        await container.read(absenceRepositoryProvider).forCareer(career.id);
    expect(
      absences.values.any((a) => a.isNotable),
      isTrue,
      reason: 'the world collects cards and injuries',
    );
  }, timeout: const Timeout(Duration(minutes: 10)));
}
