import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/budget_setup_screen.dart';
import 'package:fnm/features/hub/hub_event.dart';

import '../../helpers/test_database.dart';

/// Two skill points arrive at the end of every cycle and one with every
/// trophy, and nothing ever said so: the manager's page is reachable from a
/// menu, so a manager who never opened it banked points for a decade and
/// played the whole save with the skills he started with.
void main() {
  late AppDatabase db;
  late List<Nation> nations;
  late List<Player> players;

  ProviderContainer open() {
    final c = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: players),
        ),
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  setUp(() {
    db = createTestDatabase();
    addTearDown(db.close);
    nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Nation.fromJson(e as Map<String, Object?>))
            .toList();
    players =
        (jsonDecode(File('assets/data/players.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Player.fromJson(e as Map<String, Object?>))
            .toList();
  });

  /// A career that has finished a cycle, with the budget already settled — the
  /// budget is the forced first event of every cycle and would otherwise be
  /// the answer to every question here.
  Future<int> careerPastFirstCycle(ProviderContainer c) async {
    await c.read(seedLoaderProvider).ensureSeeded();
    final career =
        (await c
                .read(careerServiceProvider)
                .create(nationId: nations.first.id, managerName: 'M'))
            .valueOrNull!;
    final repo = c.read(careerRepositoryProvider);
    await repo.advanceCycle(career.id, 1, DateTime(2034));
    await c
        .read(competitionRepositoryProvider)
        .markDrawWatched(career.id, 1, budgetSetupKind);
    return career.id;
  }

  test(
    'a manager with points to spend is told so, once the cycle opens',
    () async {
      final c = open();
      final careerId = await careerPastFirstCycle(c);
      final event = await c.read(nextEventProvider(careerId).future);
      expect(event.kind, HubEventKind.managerSkills);
      expect(event.route, contains('/manager'));
    },
  );

  test('and is not asked again once he has answered', () async {
    final c = open();
    final careerId = await careerPastFirstCycle(c);
    await c
        .read(competitionRepositoryProvider)
        .markDrawWatched(careerId, 1, skillsPromptKind);
    c.invalidate(nextEventProvider);

    final event = await c.read(nextEventProvider(careerId).future);
    expect(
      event.kind,
      isNot(HubEventKind.managerSkills),
      reason:
          'a prompt that comes back every time he returns to the hub is not a '
          'prompt, it is a toll — he may bank his points',
    );
  });

  test(
    'a brand-new manager has nothing to spend and is not prompted',
    () async {
      final c = open();
      await c.read(seedLoaderProvider).ensureSeeded();
      final career =
          (await c
                  .read(careerServiceProvider)
                  .create(nationId: nations.first.id, managerName: 'M'))
              .valueOrNull!;
      await c
          .read(competitionRepositoryProvider)
          .markDrawWatched(career.id, 0, budgetSetupKind);

      final event = await c.read(nextEventProvider(career.id).future);
      expect(event.kind, isNot(HubEventKind.managerSkills));
    },
  );
}
