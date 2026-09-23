import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/test_database.dart';

/// The hub fires [SeasonService.advance] without awaiting it, so nothing at the
/// call site stops a second tap from starting a second world simulation over
/// the first. Both would drive the same career through the same scratch state
/// and interleave writes across transaction boundaries.
///
/// These tests pin the gate by its OBSERVABLE effect — how far the world moved
/// — rather than by which future object comes back, so the policy can be
/// re-implemented without rewriting them.
///
/// EVERY world here is built from the SAME fixed seed. Without that these
/// compare two independently generated worlds: a new career seeds itself from
/// the clock, the seed decides the qualifying draw, and the draw decides what
/// date the first advance lands on. Two runs of the identical scenario
/// disagreed about half the time, which made this file fail at random and say
/// nothing whatsoever about coalescing.
void main() {
  /// A fresh world, advanced by [taps] calls made in the same frame (a
  /// double-tap) or [sequential] calls awaited one after another. Returns the
  /// in-game date the save ends on.
  /// One fixed world for every run in this file — see the note above.
  const seed = 20260819;

  Future<DateTime> advancedDate({int taps = 0, int sequential = 0}) async {
    final db = createTestDatabase();
    final nations = [
      for (var i = 1; i <= 6; i++) nation(id: i, ranking: i),
      nation(id: 7, ranking: 7, confederation: Confederation.asia),
    ];
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: const []),
        ),
      ],
    );
    try {
      await container.read(seedLoaderProvider).ensureSeeded();
      final career =
          (await container
                  .read(careerServiceProvider)
                  .create(
                    nationId: 1,
                    managerName: 'A',
                    rngSeed: seed,
                  ))
              .valueOrNull!;
      final season = container.read(seasonServiceProvider);

      if (taps > 0) {
        // All in one frame, nothing awaited in between — the double-tap.
        await Future.wait([
          for (var i = 0; i < taps; i++) season.advance(career.id),
        ]);
      }
      for (var i = 0; i < sequential; i++) {
        await season.advance(career.id);
      }

      final hub = await container.read(hubDataProvider(career.id).future);
      return hub!.career.inGameDate;
    } finally {
      container.dispose();
      await db.close();
    }
  }

  test('the same scenario twice gives the same world', () async {
    // The bug this pins is in the TEST, and it hid a real question for months:
    // every case below compares two separately built worlds, so unless the
    // world is reproducible a passing run proves nothing and a failing one
    // accuses the wrong code. It failed about half the time.
    expect(
      await advancedDate(sequential: 1),
      await advancedDate(sequential: 1),
    );
  });

  test('two advances in one frame move the world exactly once', () async {
    final once = await advancedDate(sequential: 1);
    final doubleTapped = await advancedDate(taps: 2);
    expect(doubleTapped, equals(once));
  });

  test('advances that are actually awaited still each do their work', () async {
    // The guard against over-correcting: coalescing must not swallow a second
    // advance the player genuinely asked for after the first had finished.
    final once = await advancedDate(sequential: 1);
    final twice = await advancedDate(sequential: 2);
    expect(twice.isAfter(once), isTrue);
  });

  test('isBusy reports a run in progress and clears afterwards', () async {
    final db = createTestDatabase();
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(
            nationList: [
              for (var i = 1; i <= 6; i++) nation(id: i, ranking: i),
              nation(id: 7, ranking: 7, confederation: Confederation.asia),
            ],
            playerList: const [],
          ),
        ),
      ],
    );
    addTearDown(() async {
      container.dispose();
      await db.close();
    });

    await container.read(seedLoaderProvider).ensureSeeded();
    final career =
        (await container
                .read(careerServiceProvider)
                .create(
                  nationId: 1,
                  managerName: 'A',
                  rngSeed: seed,
                ))
            .valueOrNull!;
    final season = container.read(seasonServiceProvider);

    expect(season.isBusy, isFalse);
    final run = season.advance(career.id);
    expect(season.isBusy, isTrue);
    await run;
    expect(season.isBusy, isFalse);

    // A career that does not exist returns early; the gate must still release,
    // or the hub would be wedged for the rest of the session.
    await season.advance(999);
    expect(season.isBusy, isFalse);
  });
}
