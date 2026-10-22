import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/pool_generator.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/campaign/campaigns.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/achievements/achievement_providers.dart';
import 'package:fnm/features/campaign/campaign_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/career/nation_offers_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_database.dart';

/// Owner ruling: a campaign longer than one cycle never sacks its manager.
/// The board may be furious; the run still goes on to its last cycle. The
/// one-cycle campaigns and every normal career keep the sack.
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
    final base =
        (jsonDecode(File('assets/data/players.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Player.fromJson(e as Map<String, Object?>))
            .toList();
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        // The worst cycle there is: the board's satisfaction at nought.
        satisfactionProvider.overrideWith((ref, careerId) async => 0),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(
            nationList: nations,
            playerList: PoolGenerator.expand(base),
          ),
        ),
      ],
    );
    addTearDown(() async {
      container.dispose();
      await db.close();
    });
    await container.read(seedLoaderProvider).ensureSeeded();
  });

  Future<RolloverVerdict> verdict(int careerId) async {
    final v = await container.read(rolloverVerdictProvider(careerId).future);
    return v!;
  }

  Future<int> run(CampaignDef def) async =>
      (await container
              .read(campaignServiceProvider)
              .start(def, managerName: 'Me'))
          .id;

  for (final def in [Campaigns.guineas, Campaigns.youngFinns]) {
    test('${def.id}: never sacked, whatever the verdict', () async {
      final id = await run(def);
      final v = await verdict(id);
      expect(v.performance, 0);
      expect(v.sacked, isFalse);
      // The last cycle too: the run is judged, not ended by the board.
      await container
          .read(careerRepositoryProvider)
          .advanceCycle(
            id,
            def.cycles - 1,
            CareerService.cycleOpens(def.cycles - 1),
          );
      container.invalidate(rolloverVerdictProvider(id));
      expect((await verdict(id)).sacked, isFalse);
    });
  }

  test('a one-cycle campaign still sacks', () async {
    final id = await run(Campaigns.grudge);
    expect((await verdict(id)).sacked, isTrue);
  });

  test('a normal career still sacks', () async {
    final career =
        (await container
                .read(careerServiceProvider)
                .create(nationId: 17, managerName: 'N', rngSeed: 17))
            .valueOrNull!;
    expect((await verdict(career.id)).sacked, isTrue);
  });

  test('a moved multi-cycle run is an ordinary career after its move '
      'cycle', () async {
    final id = await run(Campaigns.guineas);
    final comp = container.read(competitionRepositoryProvider);
    await comp.markDrawWatched(id, 0, campaignMovedKind);
    await comp.markDrawWatched(id, 0, campaignMovedAtKind);
    // Still the campaign for the rest of the cycle it was moved in.
    expect((await verdict(id)).sacked, isFalse);
    await container
        .read(careerRepositoryProvider)
        .advanceCycle(id, 1, CareerService.cycleOpens(1));
    container.invalidate(rolloverVerdictProvider(id));
    expect((await verdict(id)).sacked, isTrue);
  });
}
