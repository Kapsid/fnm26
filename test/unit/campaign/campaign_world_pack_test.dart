import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/repositories/world_pack_repository.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/campaign/campaigns.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/campaign/campaign_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/editor_app.dart' show testSquad;
import '../../helpers/test_database.dart';

/// A campaign run may start on a custom database: it plays the database's
/// squads and names, keeps the designed starting ranking, and is refused a
/// database that renames a nation its story names.
void main() {
  late ProviderContainer container;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final db = createTestDatabase();
    final nations =
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
        premiumUnlockedProvider.overrideWith((ref) => false),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: players),
        ),
      ],
    );
    addTearDown(() async {
      container.dispose();
      await db.close();
    });
    await container.read(seedLoaderProvider).ensureSeeded();
  });

  const georgia = 19;
  const albania = 1;

  /// A Georgia of world-beaters: on a normal career it would climb the
  /// starting ranking.
  List<PackPlayer> superSquad() => [
    for (final p in testSquad())
      PackPlayer(
        id: p.id,
        name: p.name,
        age: p.age,
        position: p.position,
        attributes: const PlayerAttributes(
          physical: 99,
          technical: 99,
          stamina: 99,
        ),
        potential: 99,
      ),
  ];

  Future<int> insert(WorldPack pack) =>
      container.read(worldPackRepositoryProvider).insert(pack, {});

  WorldPack pack(
    String name, {
    Map<int, List<PackPlayer>> squads = const {},
    Map<int, ({String name, String code})> nations = const {},
  }) => WorldPack(
    uuid: 'uuid-$name',
    name: name,
    author: '',
    formatVersion: kPackFormatVersion,
    madeWithVersion: kPackGameVersion,
    squads: squads,
    nations: nations,
  );

  Future<Map<int, int>> startingRanks(int careerId) =>
      container.read(seedRankingRepositoryProvider).forCycle(careerId, 0);

  test(
    'a run on a database takes it, and keeps the designed ranking',
    () async {
      final svc = container.read(campaignServiceProvider);
      final plain = await svc.start(Campaigns.grudge, managerName: 'Me');
      final designed = await startingRanks(plain.id);
      await svc.abandon(plain.id);

      final id = await insert(pack('Strong', squads: {georgia: superSquad()}));
      final run = await svc.start(
        Campaigns.grudge,
        managerName: 'Me',
        worldPackId: id,
      );
      expect(
        await container
            .read(competitionRepositoryProvider)
            .hasWatchedDraw(run.id, 0, worldPackMarker('uuid-Strong')),
        isTrue,
      );
      expect(
        (await container.read(campaignOfProvider(run.id).future))?.def.id,
        'grudge',
      );
      // The same draw-shaping ranking as the run on the game's own world...
      expect(await startingRanks(run.id), designed);
      // ...where a normal career on the same database moves Georgia up.
      final career =
          (await container
                  .read(careerServiceProvider)
                  .create(nationId: georgia, managerName: 'C', worldPackId: id))
              .valueOrNull!;
      expect(
        (await startingRanks(career.id))[georgia],
        lessThan(designed[georgia]!),
      );
    },
  );

  test('a database that renames a nation the campaign names is refused, and '
      'nothing is made', () async {
    final id = await insert(
      pack('Renamed', nations: {albania: (name: 'Illyria', code: '')}),
    );
    final svc = container.read(campaignServiceProvider);
    await expectLater(
      svc.start(Campaigns.grudge, managerName: 'Me', worldPackId: id),
      throwsA(
        isA<CampaignWorldRefused>()
            .having((e) => e.code, 'code', campaignWorldRenamesCode)
            .having((e) => e.nationId, 'nationId', albania),
      ),
    );
    expect(await container.read(campaignRunsProvider.future), isEmpty);

    // A campaign that names no renamed nation starts on it.
    final run = await svc.start(
      Campaigns.transplant,
      managerName: 'Me',
      worldPackId: id,
    );
    expect(run.nationId, Campaigns.transplant.nationId);
  });

  test('a database that is gone is refused', () async {
    await expectLater(
      container
          .read(campaignServiceProvider)
          .start(Campaigns.grudge, managerName: 'Me', worldPackId: 999),
      throwsA(
        isA<CampaignWorldRefused>().having(
          (e) => e.code,
          'code',
          worldPackMissingCode,
        ),
      ),
    );
    expect(await container.read(campaignRunsProvider.future), isEmpty);
  });

  test('namedNations covers the story', () {
    expect(Campaigns.grudge.namedNations, {georgia, albania});
    expect(
      Campaigns.transplant.namedNations,
      {Campaigns.transplant.nationId, Campaigns.transplant.donorNationId},
    );
    expect(campaignRenamedNation(Campaigns.grudge, {albania}), albania);
    expect(campaignRenamedNation(Campaigns.grudge, {50}), isNull);
  });
}
