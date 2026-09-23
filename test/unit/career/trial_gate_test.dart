import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';

import '../../helpers/test_database.dart';

/// The one rule the free tier rests on: a complete first cycle, then the wall.
void main() {
  group('the trial gate', () {
    // The question is never "may he play the cycle he is in" — it is "may he
    // start the next one". A save sitting in its first cycle has had the whole
    // free allowance, so the roll OUT of it is the one being sold.
    test('the roll out of the first cycle is the wall', () {
      expect(trialExhausted(cyclePointer: 0, premiumUnlocked: false), isTrue);
    });

    test('and every roll after it', () {
      expect(trialExhausted(cyclePointer: 1, premiumUnlocked: false), isTrue);
    });

    test('paying lifts it for good', () {
      for (var c = 0; c < 10; c++) {
        expect(trialExhausted(cyclePointer: c, premiumUnlocked: true), isFalse);
      }
    });

    test('a save already past the wall stays behind it', () {
      // Nothing in the app can put a free save at pointer 2, but a restored
      // backup from a paid device can. It is still the wall, not a crash.
      expect(trialExhausted(cyclePointer: 5, premiumUnlocked: false), isTrue);
    });

    test('the free allowance is one whole cycle', () {
      expect(kFreeCycles, 1);
    });

    test('the free tier runs two saves, the paid tier has no ceiling', () {
      expect(saveSlotLimit(premiumUnlocked: false), 2);
      expect(saveSlotLimit(premiumUnlocked: true), isNull);
    });
  });

  group('the gate at the rollover', () {
    ProviderContainer build({required bool premium}) {
      final db = createTestDatabase();
      final c = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          premiumUnlockedProvider.overrideWith((ref) => premium),
        ],
      );
      addTearDown(c.dispose);
      addTearDown(db.close);
      return c;
    }

    // The bug this pins: a brand-new free save answered "not blocked" here, so
    // the end of its first cycle rolled straight through and the wall was
    // never opened. The manager got a second complete cycle for nothing and
    // the one moment the product is sold at never happened.
    test('a free save is blocked at the end of its FIRST cycle', () async {
      final c = build(premium: false);
      final career =
          (await c
                  .read(careerServiceProvider)
                  .create(nationId: 1, managerName: 'M'))
              .valueOrNull!;
      expect(career.cyclePointer, 0);
      expect(
        await c.read(seasonServiceProvider).trialBlocksNextCycle(career.id),
        isTrue,
      );
    });

    test('a free save that has finished its cycle is blocked, and the '
        'refused roll leaves it exactly as it was', () async {
      final c = build(premium: false);
      final repo = c.read(careerRepositoryProvider);
      final season = c.read(seasonServiceProvider);
      final career =
          (await c
                  .read(careerServiceProvider)
                  .create(nationId: 1, managerName: 'M'))
              .valueOrNull!;
      await repo.advanceCycle(career.id, 1, DateTime(2030, 7));

      expect(await season.trialBlocksNextCycle(career.id), isTrue);

      final before = (await repo.byId(career.id))!;
      // Must not throw, and must not half-roll.
      await season.startNextCycle(career.id);
      final after = (await repo.byId(career.id))!;
      expect(after.cyclePointer, before.cyclePointer);
      expect(after.budget, before.budget);
      expect(after.nationId, before.nationId);
      expect(after.inGameDate, before.inGameDate);
    });

    test('paying takes the gate away', () async {
      final c = build(premium: true);
      final repo = c.read(careerRepositoryProvider);
      final career =
          (await c
                  .read(careerServiceProvider)
                  .create(nationId: 1, managerName: 'M'))
              .valueOrNull!;
      await repo.advanceCycle(career.id, 1, DateTime(2030, 7));
      expect(
        await c.read(seasonServiceProvider).trialBlocksNextCycle(career.id),
        isFalse,
      );
    });

    test('a career that cannot be read is not blocked (fail open)', () async {
      final c = build(premium: false);
      expect(
        await c.read(seasonServiceProvider).trialBlocksNextCycle(9999),
        isFalse,
      );
    });
  });
}
