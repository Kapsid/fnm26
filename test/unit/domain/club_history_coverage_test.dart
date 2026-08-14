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
import 'package:fnm/features/player/club_history_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';

import '../../helpers/test_database.dart';

/// A player's card shows where he has played. Every player has played
/// somewhere — a card with an empty club history is a card with a hole in it.
void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late List<Nation> nations;

  setUp(() async {
    db = createTestDatabase();
    addTearDown(db.close);
    nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Nation.fromJson(e as Map<String, Object?>))
            .toList();
    final players =
        (jsonDecode(File('assets/data/players.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Player.fromJson(e as Map<String, Object?>))
            .toList();
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: players),
        ),
      ],
    );
    addTearDown(container.dispose);
    await container.read(seedLoaderProvider).ensureSeeded();
  });

  test('every player has at least one club spell, in any nation', () async {
    final career =
        (await container
                .read(careerServiceProvider)
                .create(nationId: nations.first.id, managerName: 'M'))
            .valueOrNull!;

    // The manager's own pool, and two foreign ones — a player card is opened
    // from an opponent's squad as often as from your own.
    final repo = container.read(playerRepositoryProvider);
    final pools = <Player>[
      ...(await container.read(squadDataProvider(career.id).future))!.pool,
      for (final n in [nations[nations.length ~/ 2], nations.last])
        ...await repo.byNation(n.id, saveSeed: career.rngSeed),
    ];
    expect(pools, isNotEmpty);

    for (final p in pools) {
      final spells = await container.read(
        clubHistoryProvider((careerId: career.id, playerId: p.id)).future,
      );
      expect(
        spells,
        isNotEmpty,
        reason: '${p.name} (${p.id}, age ${p.age}) has no club history',
      );
      for (final s in spells) {
        expect(s.club, isNotEmpty, reason: 'an unnamed club for ${p.name}');
      }
    }
  });
}
