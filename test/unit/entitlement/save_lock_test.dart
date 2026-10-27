import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/campaign/campaigns.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/entitlement/entitlement_service.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/paywall/save_lock.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../story/driver.dart';

/// The refund hole: pay at the end of the free cycle, roll into the second,
/// refund, and play the second cycle for nothing. A save past the free cycle,
/// or a Pro campaign run, now needs Pro to be OPENED, not only to roll on.

/// The router's redirect, reachable from a plain container.
final _redirect = Provider<FutureOr<String?> Function(Uri)>(
  (ref) =>
      (uri) => proLockRedirect(ref, uri),
);

/// A store with nothing to sell; `init()` only has to survive it.
class _SilentStore implements InAppPurchase {
  final StreamController<List<PurchaseDetails>> purchases =
      StreamController<List<PurchaseDetails>>.broadcast();

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => purchases.stream;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<void> _setCycle(ProviderContainer c, int id, int cycle) async {
  final db = c.read(appDatabaseProvider);
  await (db.update(db.careers)..where((t) => t.id.equals(id))).write(
    CareersCompanion(cyclePointer: Value(cycle)),
  );
}

Future<bool> _locked(ProviderContainer c, int id) => careerIsProLocked(
  careers: c.read(careerRepositoryProvider),
  competitions: c.read(competitionRepositoryProvider),
  careerId: id,
  premiumUnlocked: c.read(premiumUnlockedProvider),
  settled: c.read(entitlementSettledProvider),
);

/// Records a World Championship final in the career's current cycle.
Future<void> _decideWorldChampionship(ProviderContainer c, int id) async {
  final comp = c.read(competitionRepositoryProvider);
  final cycle = (await c.read(careerRepositoryProvider).byId(id))!.cyclePointer;
  await comp.createKnockout(
    careerId: id,
    cycle: cycle,
    confederation: Confederation.europe,
    kind: CompetitionKind.worldCupFinals,
    name: 'World Championship',
    pairings: [(26, 1)],
    date: DateTime(CareerService.worldCupYear(cycle), 7, 19),
    firstRound: 'FINAL',
  );
  final fin = await comp.fixturesByRound(id, 'FINAL');
  await comp.recordResult(fixtureId: fin.single.id, homeScore: 1, awayScore: 0);
}

void main() {
  group('saveNeedsPremium, the pure rule', () {
    test('a free save in its first cycle stays playable', () {
      expect(
        saveNeedsPremium(cyclePointer: 0, premiumUnlocked: false),
        isFalse,
      );
    });

    test('a free save past the free cycle is locked', () {
      for (final c in [1, 2, 7]) {
        expect(
          saveNeedsPremium(cyclePointer: c, premiumUnlocked: false),
          isTrue,
        );
      }
    });

    test('a Pro campaign run is locked without Pro, even at cycle 0', () {
      expect(
        saveNeedsPremium(
          cyclePointer: 0,
          premiumUnlocked: false,
          proCampaign: true,
        ),
        isTrue,
      );
    });

    test('a free campaign run follows the cycle rule only', () {
      expect(
        saveNeedsPremium(cyclePointer: 0, premiumUnlocked: false),
        isFalse,
      );
      expect(
        saveNeedsPremium(cyclePointer: 1, premiumUnlocked: false),
        isTrue,
      );
    });

    test('Pro unlocks everything', () {
      for (final c in [0, 1, 5]) {
        for (final pro in [false, true]) {
          expect(
            saveNeedsPremium(
              cyclePointer: c,
              premiumUnlocked: true,
              proCampaign: pro,
            ),
            isFalse,
          );
        }
      }
    });

    test('import asks the same question', () {
      expect(
        importNeedsPremium(cyclePointer: 0, premiumUnlocked: false),
        isFalse,
      );
      expect(
        importNeedsPremium(cyclePointer: 1, premiumUnlocked: false),
        isTrue,
      );
      expect(
        importNeedsPremium(
          cyclePointer: 0,
          premiumUnlocked: false,
          proCampaign: true,
        ),
        isTrue,
      );
      expect(
        importNeedsPremium(cyclePointer: 3, premiumUnlocked: true),
        isFalse,
      );
    });
  });

  group('the launch decision settles', () {
    Future<ProviderContainer> launch(Set<String>? owned) async {
      SharedPreferences.setMockInitialValues(const {});
      final store = _SilentStore();
      addTearDown(store.purchases.close);
      final c = ProviderContainer(
        overrides: [
          entitlementServiceProvider.overrideWith(
            (ref) => EntitlementService(
              ref,
              iap: store,
              storeEntitlements: () async => owned,
            ),
          ),
        ],
      );
      addTearDown(c.dispose);
      expect(c.read(entitlementSettledProvider), isFalse);
      await c.read(entitlementServiceProvider).init();
      return c;
    }

    test('an owner is granted before the decision counts as settled', () async {
      final c = await launch({kPremiumProductId});
      expect(c.read(entitlementSettledProvider), isTrue);
      expect(c.read(premiumUnlockedProvider), isTrue);
    });

    test('a store that no longer lists the purchase settles locked', () async {
      final c = await launch(const {});
      expect(c.read(entitlementSettledProvider), isTrue);
      expect(c.read(premiumUnlockedProvider), isFalse);
    });

    test('an offline launch with a cached grant stays unlocked', () async {
      SharedPreferences.setMockInitialValues({'entitlement.premium': true});
      final store = _SilentStore();
      addTearDown(store.purchases.close);
      final c = ProviderContainer(
        overrides: [
          entitlementServiceProvider.overrideWith(
            (ref) => EntitlementService(
              ref,
              iap: store,
              storeEntitlements: () async => null,
            ),
          ),
        ],
      );
      addTearDown(c.dispose);
      await c.read(entitlementServiceProvider).init();
      expect(c.read(entitlementSettledProvider), isTrue);
      expect(c.read(premiumUnlockedProvider), isTrue);
    });
  });

  group('saves in a world', () {
    test('unsettled: nothing locks and nothing redirects', () async {
      final c = freeStoryContainer();
      addTearDown(c.dispose);
      final d = await StoryDriver.start(c, 7);
      await _setCycle(c, d.careerId, 1);
      expect(c.read(entitlementSettledProvider), isFalse);
      expect(await _locked(c, d.careerId), isFalse);
      // Synchronous null: no database read before the store has answered.
      expect(
        c.read(_redirect)(Uri.parse('${Routes.hub}?careerId=${d.careerId}')),
        isNull,
      );
      expect(await c.read(lockedCareerIdsProvider.future), isEmpty);
    });

    test('settled and free: past the free cycle locks, the first does not, and '
        'every route into the save goes to the gate', () async {
      final c = freeStoryContainer();
      addTearDown(c.dispose);
      final d = await StoryDriver.start(c, 7);
      c.read(entitlementSettledProvider.notifier).state = true;
      expect(await _locked(c, d.careerId), isFalse);
      expect(
        await c.read(_redirect)(
          Uri.parse('${Routes.hub}?careerId=${d.careerId}'),
        ),
        isNull,
      );

      await _setCycle(c, d.careerId, 1);
      expect(await _locked(c, d.careerId), isTrue);
      for (final route in [Routes.hub, Routes.match, Routes.tactics]) {
        expect(
          await c.read(_redirect)(
            Uri.parse('$route?careerId=${d.careerId}'),
          ),
          saveLockedLocation(d.careerId),
          reason: route,
        );
      }
      // The gate itself and routes outside a save are left alone.
      expect(
        c.read(_redirect)(Uri.parse(saveLockedLocation(d.careerId))),
        isNull,
      );
      expect(c.read(_redirect)(Uri.parse(Routes.saves)), isNull);
      expect(await c.read(lockedCareerIdsProvider.future), {d.careerId});

      // Bought or restored: open at once.
      c.read(premiumUnlockedProvider.notifier).state = true;
      expect(await _locked(c, d.careerId), isFalse);
      expect(await c.read(lockedCareerIdsProvider.future), isEmpty);
    });

    test(
      'a Pro campaign at cycle 0 locks without Pro; a free one does not',
      () async {
        final c = storyContainer();
        addTearDown(c.dispose);
        final pro = await StoryDriver.startCampaign(c, Campaigns.guineas);
        final free = await StoryDriver.startCampaign(c, Campaigns.grudge);
        c
          ..read(premiumUnlockedProvider.notifier).state = false
          ..read(entitlementSettledProvider.notifier).state = true;
        expect(await _locked(c, pro.careerId), isTrue);
        expect(await _locked(c, free.careerId), isFalse);
        expect(await c.read(lockedCareerIdsProvider.future), {pro.careerId});
      },
      timeout: const Timeout(Duration(minutes: 3)),
    );

    test('the refund: pay, roll into the second cycle, refund, and the save '
        'is locked; nothing in it is changed', () async {
      final c = freeStoryContainer();
      addTearDown(c.dispose);
      c.read(entitlementSettledProvider.notifier).state = true;
      final d = await StoryDriver.start(c, 7);
      final season = c.read(seasonServiceProvider);
      final careers = c.read(careerRepositoryProvider);

      // The end of the free cycle, and the wall.
      await _decideWorldChampionship(c, d.careerId);
      expect((await d.nextEvent()).kind, HubEventKind.cycleRollover);
      expect(await season.trialBlocksNextCycle(d.careerId), isTrue);

      // He pays, and rolls into the second cycle.
      c.read(premiumUnlockedProvider.notifier).state = true;
      await season.startNextCycle(d.careerId);
      final rolled = (await careers.byId(d.careerId))!;
      expect(rolled.cyclePointer, 1);
      expect(await _locked(c, d.careerId), isFalse);

      // Refunded: the store no longer names the unlock.
      c.read(premiumUnlockedProvider.notifier).state = false;
      expect(await _locked(c, d.careerId), isTrue);
      expect(
        await c.read(_redirect)(
          Uri.parse('${Routes.hub}?careerId=${d.careerId}'),
        ),
        saveLockedLocation(d.careerId),
      );
      expect(await c.read(careerProLockedProvider(d.careerId).future), isTrue);
      // Locked, not lost.
      final kept = (await careers.byId(d.careerId))!;
      expect(kept, rolled);
    }, timeout: const Timeout(Duration(minutes: 5)));
  });
}
