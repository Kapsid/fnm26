import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/pool_generator.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/repositories/player_repository.dart';
import 'package:fnm/domain/services/campaign/campaigns.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/campaign/campaign_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_database.dart';

/// Campaigns live outside the save slots: a free player with both slots full
/// can start one, abandon it, and moves it in only when it is settled and a
/// slot is free.
void main() {
  late ProviderContainer container;
  late List<Player> players;

  setUp(() async {
    // Moving or abandoning a settled run records its stamp.
    SharedPreferences.setMockInitialValues({});
    final db = createTestDatabase();
    final nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Nation.fromJson(e as Map<String, Object?>))
            .toList();
    final base =
        (jsonDecode(File('assets/data/players.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Player.fromJson(e as Map<String, Object?>))
            .toList();
    final namesRaw =
        jsonDecode(File('assets/data/country_names.json').readAsStringSync())
            as Map<String, Object?>;
    final names = <int, ({List<String> first, List<String> sur})>{
      for (final e in namesRaw.entries)
        int.parse(e.key): (
          first: ((e.value! as Map)['first'] as List).cast<String>(),
          sur: ((e.value! as Map)['sur'] as List).cast<String>(),
        ),
    };
    players = PoolGenerator.expand(base, namesByNation: names);
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

  Future<void> fillSlots() async {
    final svc = container.read(careerServiceProvider);
    for (final n in ['A', 'B']) {
      expect(
        (await svc.create(nationId: 26, managerName: n)).isSuccess,
        isTrue,
      );
    }
  }

  test('a campaign starts with both slots full and takes none', () async {
    await fillSlots();
    final career = await container
        .read(campaignServiceProvider)
        .start(Campaigns.grudge, managerName: 'Me');
    expect(career.nationId, Campaigns.grudge.nationId);
    expect(career.rngSeed, Campaigns.grudge.rngSeed);
    // A run started now names its players from the richer pools. Its seed is
    // fixed, so this is also what keeps it apart from a run of the same
    // campaign started before them and since moved into the saves.
    expect(
      await container
          .read(competitionRepositoryProvider)
          .hasWatchedDraw(career.id, 0, namePoolsV2Kind),
      isTrue,
    );
    expect(await container.read(savesProvider.future), hasLength(2));
    final third = await container
        .read(careerServiceProvider)
        .create(nationId: 26, managerName: 'C');
    expect(third.isSuccess, isFalse);
  });

  test('the transplant is eight of the donor\'s best, naturalised', () async {
    final career = await container
        .read(campaignServiceProvider)
        .start(Campaigns.transplant, managerName: 'Me');
    final links = await container
        .read(careerRepositoryProvider)
        .acceptedNaturalizations(career.id);
    expect(links, hasLength(8));
    final italy = [
      ...await container
          .read(playerRepositoryProvider)
          .byNation(
            26,
            agingYears: 0,
            saveSeed: career.rngSeed,
            careerId: career.id,
          ),
    ]..sort((a, b) => b.overall.compareTo(a.overall));
    final top = italy.take(8).map((p) => p.id).toSet();
    expect(links.every((l) => l.sourceNationId == 26), isTrue);
    expect(links.map((l) => l.playerId).toSet().difference(top), isEmpty);
  });

  test('the transplanted players start: the default XI is picked after them',
      () async {
    // The default tactic is picked when the career is created, before the
    // transplant. Left there, the Italians sat outside the XI until the
    // manager re-picked it by hand.
    final career = await container
        .read(campaignServiceProvider)
        .start(Campaigns.transplant, managerName: 'Me');
    final links = await container
        .read(careerRepositoryProvider)
        .acceptedNaturalizations(career.id);
    final tactic = await container
        .read(tacticsRepositoryProvider)
        .tacticForCareer(career.id);
    final xi = tactic!.lineup.whereType<int>().toSet();
    expect(links.map((l) => l.playerId).toSet().difference(xi), isEmpty);
  });

  test('a second start throws; one run per campaign', () async {
    final svc = container.read(campaignServiceProvider);
    await svc.start(Campaigns.grudge, managerName: 'Me');
    await svc.start(Campaigns.transplant, managerName: 'Me');
    expect(
      () => svc.start(Campaigns.grudge, managerName: 'Me'),
      throwsStateError,
    );
    expect(
      (await container.read(campaignRunsProvider.future)).keys.toSet(),
      {'grudge', 'transplant'},
    );
  });

  test('abandon removes the run and its markers', () async {
    final svc = container.read(campaignServiceProvider);
    final career = await svc.start(Campaigns.grudge, managerName: 'Me');
    await svc.abandon(career.id);
    expect(
      await container.read(careerRepositoryProvider).byId(career.id),
      isNull,
    );
    expect(await container.read(campaignRunsProvider.future), isEmpty);
    final marks = await container
        .read(competitionRepositoryProvider)
        .watchedKindsWithPrefix('campaign');
    expect(marks.where((m) => m.careerId == career.id), isEmpty);
  });

  test('moveToSaves before settlement is notSettled', () async {
    final svc = container.read(campaignServiceProvider);
    final career = await svc.start(Campaigns.grudge, managerName: 'Me');
    expect(await svc.moveToSaves(career.id), CampaignMoveResult.notSettled);
    expect(await container.read(campaignRunsProvider.future), isNotEmpty);
  });

  test('a transplant run is refused the move even with a free slot', () async {
    final svc = container.read(campaignServiceProvider);
    final career = await svc.start(Campaigns.transplant, managerName: 'Me');
    // Settle it: the European Championship drawn without San Marino.
    await container
        .read(competitionRepositoryProvider)
        .saveTournamentGroups(
          careerId: career.id,
          cycle: career.cyclePointer,
          confederation: Confederation.europe,
          kind: CompetitionKind.continentalFinals,
          name: 'European Championship',
          draw: const FinalsDraw(
            groups: [
              FinalsGroupDraw(
                name: 'A',
                nationIds: [26, 1, 3, 19],
                fixtures: [(1, 26, 1), (1, 3, 19)],
              ),
            ],
          ),
          groupStart: DateTime(2028, 6, 8),
          round: 'CGROUP',
        );
    expect(
      (await container.read(
        campaignProgressProvider(career.id).future,
      ))!.settled,
      isTrue,
    );
    expect(await svc.moveToSaves(career.id), CampaignMoveResult.notAllowed);
    expect(await container.read(campaignRunsProvider.future), isNotEmpty);
    expect(await container.read(savesProvider.future), isEmpty);
  });
}
