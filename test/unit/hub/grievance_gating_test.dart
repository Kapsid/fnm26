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
import 'package:fnm/domain/services/squad/grievances.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/squad/grievance_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';

import '../../helpers/test_database.dart';

/// A player asking where he stands is a good event; asking before the manager
/// has ever picked a squad is not, and neither is asking again every time the
/// app is restarted after he has had his answer.
void main() {
  late AppDatabase db;
  late List<Nation> nations;
  late List<Player> players;

  ProviderContainer open() {
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
    return container;
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

  test('nobody wants a word before the first squad is named', () async {
    final container = open();
    await container.read(seedLoaderProvider).ensureSeeded();
    final career =
        (await container
                .read(careerServiceProvider)
                .create(
                  nationId: nations.first.id,
                  managerName: 'M',
                ))
            .valueOrNull!;

    expect(
      await container.read(grievanceProvider(career.id).future),
      isEmpty,
      reason: 'there is no squad yet to be left out of',
    );
  });

  test('a grievance answered stays answered after a restart', () async {
    final container = open();
    await container.read(seedLoaderProvider).ensureSeeded();
    final career =
        (await container
                .read(careerServiceProvider)
                .create(
                  nationId: nations.first.id,
                  managerName: 'M',
                ))
            .valueOrNull!;

    // Name a squad that leaves out the men at the top of the pool — which is
    // exactly what a player comes to ask about.
    final pool = (await container.read(
      squadDataProvider(career.id).future,
    ))!.pool;
    final named = pool.reversed.take(kMinSquadSize).map((p) => p.id).toSet();
    expect(
      await container.read(squadServiceProvider).setCallUps(career.id, named),
      isTrue,
    );
    container.invalidate(squadDataProvider);

    final open1 = await container.read(grievanceProvider(career.id).future);
    expect(open1, isNotEmpty, reason: 'a man left out should want a word');

    await container
        .read(grievanceServiceProvider)
        .answer(career.id, open1.first, GrievanceTone.honest);

    // A restart is a fresh container over the same database: nothing is
    // remembered but what was written down.
    final restarted = open();
    final after = await restarted.read(grievanceProvider(career.id).future);
    expect(
      after.any((g) => g.key == open1.first.key),
      isFalse,
      reason: 'the man who has had his answer does not ask again',
    );
  });
}
