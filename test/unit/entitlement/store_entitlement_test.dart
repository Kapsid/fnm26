import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/entitlement/entitlement_service.dart';
import 'package:fnm/domain/services/entitlement/store_entitlements.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// On iOS the entitlement comes from StoreKit 2's verified transactions, not
/// from a boolean in a file that anyone who can write the file could set.
///
/// What these tests are really about is which way the doubt runs. A store that
/// answers is believed, both ways round. A store that cannot answer is never
/// read as a no: the player who was granted stays granted, because a check
/// that failed to run is not evidence that anybody pirated anything.

/// A store that is present but sells nothing. The purchase pipeline is
/// covered by the paywall tests; what matters here is only that `init()`
/// survives it.
class _SilentStore implements InAppPurchase {
  final StreamController<List<PurchaseDetails>> purchases =
      StreamController<List<PurchaseDetails>>.broadcast();

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => purchases.stream;

  @override
  Future<bool> isAvailable() async => false;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// A device with no billing at all: even subscribing to the stream throws.
class _BrokenStore extends _SilentStore {
  @override
  Stream<List<PurchaseDetails>> get purchaseStream =>
      throw StateError('no billing on this device');
}

/// The store knows about these products, and says so.
StoreEntitlementReader _answers(Set<String> owned) =>
    () async => owned;

/// The store cannot be asked: simulator, missing StoreKit, a dead channel.
Future<Set<String>?> _noAnswer() async => null;

/// The read itself blows up. Same meaning as [_noAnswer], harder road.
Future<Set<String>?> _explodes() async =>
    throw StateError('StoreKit is not here');

const String _legacyKey = 'premium_unlocked';
const String _cacheKey = 'entitlement.premium';
const String _confirmedKey = 'entitlement.confirmedAtMs';

/// "Today" for every launch here, and a confirmation [days] before it.
final DateTime _today = DateTime(2026, 11, 2, 12);
int _daysAgo(num days) => _today
    .subtract(Duration(minutes: (days * 24 * 60).round()))
    .millisecondsSinceEpoch;

void main() {
  /// Runs a launch with a given cache and a given answer from the store, and
  /// reports whether the player ended up unlocked.
  Future<bool> launch({
    required StoreEntitlementReader store,
    Map<String, Object> prefs = const {},
    InAppPurchase? iap,
    DateTime? now,
  }) async {
    SharedPreferences.setMockInitialValues(prefs);
    final billing = iap ?? _SilentStore();
    if (billing is _SilentStore) addTearDown(billing.purchases.close);
    final container = ProviderContainer(
      overrides: [
        entitlementServiceProvider.overrideWith(
          (ref) => EntitlementService(
            ref,
            iap: billing,
            storeEntitlements: store,
            now: () => now ?? _today,
          ),
        ),
      ],
    );
    addTearDown(container.dispose);
    await container.read(entitlementServiceProvider).init();
    return container.read(premiumUnlockedProvider);
  }

  group('the store answers', () {
    test('owning the product unlocks a device nobody restored on', () async {
      // Empty preferences on purpose: a reinstall wipes them, and a second
      // phone never had them. The Apple ID bought it, so the game is unlocked
      // without anyone having to go looking for a Restore button.
      expect(
        await launch(store: _answers({kPremiumProductId})),
        isTrue,
      );
    });

    test('not owning it overrules a boolean somebody wrote himself', () async {
      // This is the hardening, and the only case that may end in a no: the
      // store was asked, it answered, and the answer did not include us.
      expect(
        await launch(
          prefs: {
            _legacyKey: true,
            _cacheKey: true,
            _confirmedKey: _daysAgo(4),
          },
          store: _answers({'com.fnm.fnm.something.else'}),
        ),
        isFalse,
      );
    });

    test(
      'a refund clears the cache so an offline launch stays locked',
      () async {
        // Pay, refund, then launch in airplane mode: the stale grant must not
        // unlock again once the store has said no.
        expect(
          await launch(
            prefs: {
              _legacyKey: true,
              _cacheKey: true,
              _confirmedKey: _daysAgo(3.1),
            },
            store: _answers(const {}),
          ),
          isFalse,
        );
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getBool(_cacheKey), isNull);
        expect(prefs.getBool(_legacyKey), isNull);
        expect(prefs.getInt(_confirmedKey), isNull);

        // The second launch, offline: no store answer, and only what the
        // first launch left on disk. launch() resets the mock prefs, so the
        // leftovers are carried over by hand.
        final leftover = <String, Object>{
          for (final k in prefs.getKeys())
            if (prefs.get(k) case final Object v) k: v,
        };
        expect(await launch(prefs: leftover, store: _noAnswer), isFalse);
      },
    );

    test(
      'a grant from the store is cached for the next offline launch',
      () async {
        SharedPreferences.setMockInitialValues({});
        final billing = _SilentStore();
        addTearDown(billing.purchases.close);
        final container = ProviderContainer(
          overrides: [
            entitlementServiceProvider.overrideWith(
              (ref) => EntitlementService(
                ref,
                iap: billing,
                storeEntitlements: _answers({kPremiumProductId}),
              ),
            ),
          ],
        );
        addTearDown(container.dispose);
        await container.read(entitlementServiceProvider).init();

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getBool(_cacheKey), isTrue);
        expect(prefs.getInt(_confirmedKey), isNotNull);
      },
    );
  });

  // StoreKit drops every transaction it cannot verify at that moment, so an
  // offline iPhone can answer an empty list for a player who bought (1.0.8,
  // on a flight). A "not owned" is believed only once the last "owned" is
  // older than kEntitlementGrace.
  group('a "not owned" within the grace window', () {
    test(
      'keeps a buyer confirmed two days ago unlocked, cache intact',
      () async {
        expect(
          await launch(
            prefs: {_cacheKey: true, _confirmedKey: _daysAgo(2)},
            store: _answers(const {}),
          ),
          isTrue,
        );
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getBool(_cacheKey), isTrue);
        // Not reconfirmed: the window still counts from two days ago.
        expect(prefs.getInt(_confirmedKey), _daysAgo(2));
      },
    );

    test('launching offline again and again does not stretch it', () async {
      var prefs = <String, Object>{
        _cacheKey: true,
        _confirmedKey: _daysAgo(0),
      };
      for (final (day, unlocked) in [(1, true), (2, true), (4, false)]) {
        expect(
          await launch(
            prefs: prefs,
            store: _answers(const {}),
            now: _today.add(Duration(days: day)),
          ),
          unlocked,
          reason: 'day $day',
        );
        final p = await SharedPreferences.getInstance();
        prefs = {
          for (final k in p.getKeys())
            if (p.get(k) case final Object v) k: v,
        };
      }
    });

    test('a store "owned" restarts it', () async {
      expect(
        await launch(
          prefs: {_cacheKey: true, _confirmedKey: _daysAgo(10)},
          store: _answers({kPremiumProductId}),
        ),
        isTrue,
      );
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt(_confirmedKey), _today.millisecondsSinceEpoch);
    });

    test(
      'a cache from 1.0.8 (no date) starts its window at that launch',
      () async {
        expect(
          await launch(prefs: {_cacheKey: true}, store: _answers(const {})),
          isTrue,
        );
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getInt(_confirmedKey), _today.millisecondsSinceEpoch);
        expect(
          await launch(
            prefs: {_cacheKey: true, _confirmedKey: _daysAgo(0)},
            store: _answers(const {}),
            now: _today.add(const Duration(days: 4)),
          ),
          isFalse,
        );
      },
    );

    test('a clock wound back past the confirmation does not help', () async {
      expect(
        await launch(
          prefs: {_cacheKey: true, _confirmedKey: _daysAgo(-10)},
          store: _answers(const {}),
        ),
        isFalse,
      );
    });

    test('nothing cached is still simply locked', () async {
      expect(await launch(store: _answers(const {})), isFalse);
    });
  });

  group('the store cannot answer, so it never denies', () {
    test('no answer plus the legacy boolean still grants', () async {
      expect(
        await launch(prefs: {_legacyKey: true}, store: _noAnswer),
        isTrue,
        reason: 'verification got stricter; an old buyer must not pay for it',
      );
    });

    test('no answer plus the current cache key still grants', () async {
      expect(await launch(prefs: {_cacheKey: true}, store: _noAnswer), isTrue);
    });

    test('a read that throws is an unanswered question, not a no', () async {
      expect(await launch(prefs: {_cacheKey: true}, store: _explodes), isTrue);
    });

    test('a read that hangs past its timeout still grants', () async {
      expect(
        await launch(
          prefs: {_cacheKey: true},
          store: () =>
              Future<Set<String>?>.delayed(
                const Duration(milliseconds: 20),
              ).timeout(
                const Duration(milliseconds: 1),
                onTimeout: () => throw TimeoutException('wedged channel'),
              ),
        ),
        isTrue,
      );
    });

    test('nothing cached and nothing answered simply stays locked', () async {
      expect(await launch(store: _explodes), isFalse);
    });
  });

  group('a device with no store at all', () {
    test(
      'an unsubscribable purchase stream does not cost the unlock',
      () async {
        // The product does not exist in App Store Connect yet, so this is the
        // state the owner's own testers will launch in. It must be quiet.
        expect(
          await launch(
            prefs: {_cacheKey: true},
            store: _noAnswer,
            iap: _BrokenStore(),
          ),
          isTrue,
        );
      },
    );

    test('and the store can still grant through it', () async {
      expect(
        await launch(
          store: _answers({kPremiumProductId}),
          iap: _BrokenStore(),
        ),
        isTrue,
      );
    });
  });

  group('the real Apple reader', () {
    test('answers null off iOS rather than an empty set', () async {
      // Under `flutter test` the host is a Mac, not an iPhone. If this ever
      // returned {} instead of null, every desktop and Android launch would
      // read as "the store says you own nothing" and the cached grant would
      // stop counting. Null is the difference between "no" and "not asked".
      expect(await readAppleEntitlements(), isNull);
    });

    test(
      'the Google reader and the dispatcher answer null off device',
      () async {
        // The same guard for Play: a Mac is not a phone with Play on it, and
        // "not asked" must never turn into "owns nothing".
        expect(await readGoogleEntitlements(), isNull);
        expect(await readStoreEntitlements(), isNull);
      },
    );

    test('a refunded transaction is not a current entitlement', () async {
      expect(
        isRevokedTransaction(
          '{"productId":"p","revocationDate":1737000000000}',
        ),
        isTrue,
      );
      expect(
        isRevokedTransaction('{"productId":"p","revocationReason":1}'),
        isTrue,
      );
    });

    test(
      'an ordinary transaction is kept, and so is an unreadable one',
      () async {
        expect(isRevokedTransaction('{"productId":"p"}'), isFalse);
        expect(
          isRevokedTransaction('{"productId":"p","revocationDate":null}'),
          isFalse,
        );
        // Our parse failing is our problem, never the buyer's.
        expect(isRevokedTransaction('not json at all'), isFalse);
        expect(isRevokedTransaction(null), isFalse);
        expect(isRevokedTransaction(''), isFalse);
      },
    );
  });
}
