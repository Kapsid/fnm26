import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/federation/federation_finance.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/federation_service.dart';

import '../../helpers/test_database.dart';

/// The grant is now paid off the stored ranking releases, which makes that read
/// part of the money path: if it silently defaulted, or measured a climb across
/// a change of nation, nobody would be told. The manager would just have a
/// vague sense that the federation's money was odd, cycle after cycle, with
/// every test still green.
///
/// So these drive `FederationService.incomeForCycle` end to end — a seeded
/// database, a real career, real release rows — and read the cheque.
///
/// Each case owns its own cycles so the rows never collide. Where three cases
/// need comparing they all FINISH at the same world rank, so standing is
/// identical between them and the only thing that can move the number is the
/// movement term.
void main() {
  late List<Nation> nations;
  late List<Player> players;
  late ProviderContainer container;
  late int careerId;
  late int nationId;

  setUpAll(() async {
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

    final db = createTestDatabase();
    addTearDown(db.close);
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
    nationId = nations.first.id;
    final career =
        (await container
                .read(careerServiceProvider)
                .create(nationId: nationId, managerName: 'M'))
            .valueOrNull!;
    careerId = career.id;
  });

  /// Files one release: [cycle] finished with the nation [nation] sitting
  /// [rank] in the world.
  Future<void> publish({
    required int cycle,
    required int rank,
    int? nation,
  }) => container
      .read(rankingReleaseRepositoryProvider)
      .add(
        careerId: careerId,
        // Unique and ordered, so `all()` hands them back oldest first.
        publishedOn: DateTime(2030 + cycle, 6, 1),
        cycle: cycle,
        nationId: nation ?? nationId,
        playerRank: rank,
        leaderNationId: nationId,
      );

  Future<int> grantFor(int cycle) async {
    final income = await container
        .read(federationServiceProvider)
        .incomeForCycle(careerId, cycle);
    return income.grant;
  }

  group('incomeForCycle reads the ranking releases', () {
    test('a cycle with no release at all pays the anchor', () async {
      // Cycle 9 has nothing filed for it or for cycle 8. No evidence either
      // way is not the same as evidence of a bad cycle: pay the anchor.
      expect(await grantFor(9), FederationFinance.centralGrant);
    }, timeout: const Timeout(Duration(minutes: 2)));

    test('the first cycle, with no cycle before it, pays the anchor', () async {
      // A release exists for cycle 0, at the midpoint rank, but there is no
      // cycle -1 to have climbed from. The movement term must contribute
      // nothing at all, which at the midpoint means the anchor to the euro.
      await publish(cycle: 0, rank: FederationFinance.midpointRank);
      expect(await grantFor(0), FederationFinance.centralGrant);
    }, timeout: const Timeout(Duration(minutes: 2)));

    test('climbing pays more than holding, and sliding pays less', () async {
      // All three finish 20th. Standing is therefore identical and only the
      // journey differs, so any difference in the cheque IS the release read.
      await publish(cycle: 2, rank: 5);
      await publish(cycle: 3, rank: 20); // slid: 5th to 20th
      await publish(cycle: 4, rank: 40);
      await publish(cycle: 5, rank: 20); // climbed: 40th to 20th
      await publish(cycle: 6, rank: 20);
      await publish(cycle: 7, rank: 20); // held station

      final slid = await grantFor(3);
      final climbed = await grantFor(5);
      final held = await grantFor(7);

      expect(
        climbed,
        greaterThan(held),
        reason: 'a climb to 20th paid no better than sitting at 20th, so the '
            'previous cycle is not being read',
      );
      expect(
        held,
        greaterThan(slid),
        reason: 'a slide to 20th paid the same as holding 20th',
      );
      // And the figures are the ones the model says, not merely ordered.
      expect(
        held,
        FederationFinance.centralGrantFor(
          worldRank: 20,
          rankChangeOverCycle: 0,
        ),
      );
      expect(
        climbed,
        FederationFinance.centralGrantFor(
          worldRank: 20,
          rankChangeOverCycle: 20,
        ),
      );
      expect(
        slid,
        FederationFinance.centralGrantFor(
          worldRank: 20,
          rankChangeOverCycle: -15,
        ),
      );
    }, timeout: const Timeout(Duration(minutes: 2)));

    test('a climb the PREVIOUS nation made is never paid for', () async {
      // The subtle one. A manager who left 40th-placed nation A for 20th-placed
      // nation B has not climbed twenty places; he has changed jobs. The
      // release rows look exactly like the climb above and must pay exactly
      // like holding station.
      final other = nations.firstWhere((n) => n.id != nationId).id;
      await publish(cycle: 10, rank: 40, nation: other);
      await publish(cycle: 11, rank: 20);

      final switched = await grantFor(11);
      expect(
        switched,
        FederationFinance.centralGrantFor(
          worldRank: 20,
          rankChangeOverCycle: 0,
        ),
        reason: 'the manager was paid for a climb the previous nation made',
      );
      expect(
        switched,
        lessThan(
          FederationFinance.centralGrantFor(
            worldRank: 20,
            rankChangeOverCycle: 20,
          ),
        ),
      );
    }, timeout: const Timeout(Duration(minutes: 2)));
  });
}
