import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/federation_providers.dart';
import 'package:fnm/features/federation/naturalization_providers.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/test_database.dart';

/// A naturalised player is the one man in the squad who is always resolved by
/// identity (`PlayerRepository.byId`) while every team-mate around him comes
/// out of the nation pool (`byNation`). That makes him the first place a
/// missing development input shows: if one screen reconstructs him without the
/// save's development inputs and another with them, the same footballer reads
/// two different ratings, and the manager is picking on a number that is not
/// the one he will field.
///
/// The squad figure is the reference, because that is the one the manager picks
/// on — and it is also the one that is right, because it is built from the same
/// inputs as the rest of the pool he is being compared against.
void main() {
  // A player who has started a lot of tournament matches: the career-
  // development bump is exactly the input the offer screen used to drop.
  const naturalizedId = 4;
  const starts = {naturalizedId: 100};

  late ProviderContainer container;
  late Career career;

  setUp(() async {
    final db = createTestDatabase();
    addTearDown(db.close);
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(
            nationList: [nation(id: 1), nation(id: 2)],
            playerList: [
              for (var i = 1; i <= 3; i++) player(id: i, nationId: 1),
              for (var i = 4; i <= 6; i++) player(id: i, nationId: 2),
            ],
          ),
        ),
        // The save's development inputs, pinned: a fresh career has banked no
        // tournament starts of its own, and the whole point here is that both
        // read paths see the same non-empty history.
        careerDevBonusProvider.overrideWith((ref, careerId) async => starts),
      ],
    );
    addTearDown(container.dispose);
    await container.read(seedLoaderProvider).ensureSeeded();
    career = (await container
            .read(careerServiceProvider)
            .create(nationId: 1, managerName: 'M'))
        .valueOrNull!;
    await container
        .read(careerRepositoryProvider)
        .addNaturalizationOffer(
          careerId: career.id,
          playerId: naturalizedId,
          sourceNationId: 2,
          cycle: 0,
        );
  });

  /// The rating the offer screen shows while the decision is pending.
  Future<int> fromOffer() async {
    final offer = await container.read(
      pendingNaturalizationProvider(career.id).future,
    );
    return offer!.player.overall;
  }

  /// The rating the squad (and so the match preview, which shares this path)
  /// shows once he is ours.
  Future<int> fromSquad() async {
    await container
        .read(careerRepositoryProvider)
        .setNaturalizationStatus(career.id, naturalizedId, 'accepted');
    final probe = FutureProvider<List<Player>>(
      (ref) => naturalizedPlayersFor(ref, career),
    );
    final pool = await container.read(probe.future);
    return pool.singleWhere((p) => p.id == naturalizedId).overall;
  }

  test('the development inputs actually move this player', () async {
    // Guards the test itself: with no banked starts the two paths agree
    // trivially and the regression below would pass for the wrong reason.
    final base = await container
        .read(playerRepositoryProvider)
        .byId(naturalizedId, saveSeed: career.rngSeed);
    expect(await fromSquad(), greaterThan(base!.overall));
  });

  test('a naturalised player has one rating, wherever he is read', () async {
    final offer = await fromOffer();
    final squad = await fromSquad();
    expect(offer, squad);
  });

  test('an identity lookup rebuilds the same man as the nation pool', () async {
    // The deeper half of the same fault: `byNation` weighted development by
    // the player's club minutes and `byId` did not, so the one squad member
    // always read by identity drifted from team-mates read out of the pool.
    // Inert in a fresh save (nobody has banked starts yet), real in a deep one.
    // Swept across a range of banked game time, because the two only diverge
    // once the weighted bump rounds to a different whole point — a single
    // sample would be green by luck rather than by agreement.
    final repo = container.read(playerRepositoryProvider);
    for (var banked = 1; banked <= 60; banked++) {
      for (final id in [4, 5, 6]) {
        final byPlayer = {id: banked};
        final byId = await repo.byId(
          id,
          saveSeed: career.rngSeed,
          careerStartsByPlayer: byPlayer,
        );
        final pool = await repo.byNation(
          2,
          saveSeed: career.rngSeed,
          careerStartsByPlayer: byPlayer,
        );
        final fromPool = pool.singleWhere((p) => p.id == id);
        expect(
          byId!.attributes,
          fromPool.attributes,
          reason: 'player $id with $banked starts',
        );
      }
    }
  });
}
