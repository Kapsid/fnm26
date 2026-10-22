import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/entitlement/entitlement_service.dart';
import 'package:fnm/domain/services/entitlement/integrity.dart';
import 'package:fnm/domain/services/entitlement/store_entitlements.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The two Android integrity checks: the signing certificate the APK carries,
/// and Play's signature on each purchase.
///
/// Both exist to stop a repackaged or patched build, and both are written so
/// that a check which cannot run (no keys configured yet, a debug build, a
/// channel that would not answer) leaves the buyer exactly where today's code
/// leaves him. Only a check that ran and said no may lock anything.

const String _playCert = 'AA:BB:CC:DD';
const String _uploadCert = '11:22:33:44';
const String _key = 'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA';
const String _cacheKey = 'entitlement.premium';

/// The platform side, scripted: which certificates the APK reports, and
/// whether a signature holds. Null for either means the channel did not
/// answer.
class _FakeIntegrity implements AppIntegrity {
  _FakeIntegrity({this.certificates = const [_playCert], this.signatureOk});

  final List<String>? certificates;
  final bool? signatureOk;
  int certificateReads = 0;
  final List<String> verified = [];

  @override
  Future<List<String>?> signingCertificates() async {
    certificateReads++;
    return certificates;
  }

  @override
  Future<bool?> verifyPurchase({
    required String originalJson,
    required String signature,
    required String publicKey,
  }) async {
    verified.add(originalJson);
    return signatureOk;
  }
}

/// A release build with every key filled in.
const IntegrityPolicy _armed = IntegrityPolicy(
  enforceCertificate: true,
  allowedCertificates: [_playCert, _uploadCert],
  licensingPublicKey: _key,
);

/// What a release build looks like before the owner has pasted any value.
const IntegrityPolicy _unconfigured = IntegrityPolicy(
  enforceCertificate: true,
  allowedCertificates: ['', ''],
  licensingPublicKey: '',
);

/// A debug or profile build: keys present, certificate check off.
const IntegrityPolicy _debug = IntegrityPolicy(
  enforceCertificate: false,
  allowedCertificates: [_playCert, _uploadCert],
  licensingPublicKey: _key,
);

class _Store implements InAppPurchase {
  final StreamController<List<PurchaseDetails>> purchases =
      StreamController<List<PurchaseDetails>>.broadcast();
  final List<PurchaseDetails> completed = [];

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => purchases.stream;

  @override
  Future<bool> isAvailable() async => false;

  @override
  Future<void> completePurchase(PurchaseDetails purchase) async =>
      completed.add(purchase);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

GooglePlayPurchaseDetails _playPurchase({
  String product = kPremiumProductId,
  String signature = 'c2lnbmF0dXJl',
  PurchaseStateWrapper state = PurchaseStateWrapper.purchased,
  bool acknowledged = true,
}) => GooglePlayPurchaseDetails.fromPurchase(
  PurchaseWrapper(
    orderId: 'GPA.1',
    packageName: 'com.fnm.fnm',
    purchaseTime: 1,
    purchaseToken: 'token',
    signature: signature,
    products: [product],
    isAutoRenewing: false,
    originalJson: '{"productId":"$product"}',
    isAcknowledged: acknowledged,
    purchaseState: state,
  ),
).single;

/// A purchase from somewhere that is not Play: StoreKit on iOS.
PurchaseDetails _applePurchase() => PurchaseDetails(
  productID: kPremiumProductId,
  verificationData: PurchaseVerificationData(
    localVerificationData: 'jws',
    serverVerificationData: 'jws',
    source: 'app_store',
  ),
  transactionDate: '1',
  status: PurchaseStatus.purchased,
);

void main() {
  late _Store store;
  late ProviderContainer container;

  Future<EntitlementService> boot({
    required IntegrityPolicy policy,
    required AppIntegrity integrity,
    StoreEntitlementReader? owned,
    Map<String, Object> prefs = const {},
  }) async {
    SharedPreferences.setMockInitialValues(prefs);
    store = _Store();
    addTearDown(store.purchases.close);
    container = ProviderContainer(
      overrides: [
        entitlementServiceProvider.overrideWith(
          (ref) => EntitlementService(
            ref,
            iap: store,
            storeEntitlements: owned ?? () async => null,
            integrity: integrity,
            policy: policy,
          ),
        ),
      ],
    );
    addTearDown(container.dispose);
    final service = container.read(entitlementServiceProvider);
    await service.init();
    return service;
  }

  bool unlocked() => container.read(premiumUnlockedProvider);

  Future<bool?> cached() async =>
      (await SharedPreferences.getInstance()).getBool(_cacheKey);

  /// Pushes purchases through the stream and lets the listener finish.
  Future<void> deliver(List<PurchaseDetails> purchases) async {
    store.purchases.add(purchases);
    await pumpEventQueue();
  }

  group('(a) the build is ours and the purchase is genuine', () {
    test('the Play-signed build unlocks from the store', () async {
      await boot(
        policy: _armed,
        integrity: _FakeIntegrity(signatureOk: true),
        owned: () async => {kPremiumProductId},
      );
      expect(unlocked(), isTrue);
      expect(await cached(), isTrue);
    });

    test('an upload-signed sideload is ours too', () async {
      // The owner pushes release builds to his own phone with adb install -r.
      // Those carry the upload certificate, and he has paid like anyone else.
      await boot(
        policy: _armed,
        integrity: _FakeIntegrity(
          certificates: ['11:22:33:44'],
          signatureOk: true,
        ),
        prefs: {_cacheKey: true},
      );
      expect(unlocked(), isTrue);
    });

    test(
      'a fresh purchase from the stream verifies, unlocks and caches',
      () async {
        final integrity = _FakeIntegrity(signatureOk: true);
        await boot(policy: _armed, integrity: integrity, owned: () async => {});
        await deliver([_playPurchase()]);
        expect(integrity.verified, hasLength(1));
        expect(unlocked(), isTrue);
        expect(await cached(), isTrue);
      },
    );

    test('a foreign signer beside ours still counts as ours', () async {
      // Key rotation history, or a second signer: one of them being ours is
      // enough.
      await boot(
        policy: _armed,
        integrity: _FakeIntegrity(certificates: ['DE:AD:BE:EF', _uploadCert]),
        prefs: {_cacheKey: true},
      );
      expect(unlocked(), isTrue);
    });

    test('fingerprints match however they were pasted', () async {
      // Play Console shows colon-separated upper case; keytool can print
      // either. The comparison must not care.
      await boot(
        policy: _armed,
        integrity: _FakeIntegrity(certificates: ['aabbccdd']),
        prefs: {_cacheKey: true},
      );
      expect(unlocked(), isTrue);
    });
  });

  group('(b) a certificate that is not ours', () {
    test('locks a store-owned purchase and a cached unlock alike', () async {
      await boot(
        policy: _armed,
        integrity: _FakeIntegrity(
          certificates: ['DE:AD:BE:EF'],
          signatureOk: true,
        ),
        owned: () async => {kPremiumProductId},
        prefs: {_cacheKey: true},
      );
      expect(unlocked(), isFalse);
    });

    test('and the purchase stream cannot unlock it either', () async {
      await boot(
        policy: _armed,
        integrity: _FakeIntegrity(
          certificates: ['DE:AD:BE:EF'],
          signatureOk: true,
        ),
      );
      await deliver([_playPurchase(acknowledged: false)]);
      expect(unlocked(), isFalse);
      expect(await cached(), isNull);
      // Still acknowledged: an unacknowledged purchase is refunded by Play,
      // and whatever is wrong with this install is not the store's business.
      expect(store.completed, hasLength(1));
    });

    test('the cache it finds is left alone, not erased', () async {
      await boot(
        policy: _armed,
        integrity: _FakeIntegrity(certificates: ['DE:AD:BE:EF']),
        prefs: {_cacheKey: true},
      );
      expect(await cached(), isTrue);
    });

    test('a channel that will not say which certificate fails open', () async {
      // Our own MainActivity not answering is our bug, never evidence.
      await boot(
        policy: _armed,
        integrity: _FakeIntegrity(certificates: null),
        prefs: {_cacheKey: true},
      );
      expect(unlocked(), isTrue);
    });
  });

  group('(c) a purchase whose signature fails', () {
    test(
      'is not owned when the stream delivers it, and is not cached',
      () async {
        await boot(
          policy: _armed,
          integrity: _FakeIntegrity(signatureOk: false),
          owned: () async => {},
        );
        await deliver([_playPurchase()]);
        expect(unlocked(), isFalse);
        expect(await cached(), isNull);
      },
    );

    test('a refused purchase leaves the purchase flow idle', () async {
      final service = await boot(
        policy: _armed,
        integrity: _FakeIntegrity(signatureOk: false),
        owned: () async => {},
      );
      container.read(purchaseFlowProvider.notifier).state =
          PurchaseFlowState.pending;
      await deliver([_playPurchase()]);
      expect(container.read(purchaseFlowProvider), PurchaseFlowState.idle);
      expect(service.lastError, isNull);
      expect(unlocked(), isFalse);
    });

    test('is not owned when the past-purchase read finds it', () async {
      final owned = await ownedPlayProducts(
        [_playPurchase()],
        signatureHolds: (p) => playSignatureHolds(
          p,
          integrity: _FakeIntegrity(signatureOk: false),
          licensingPublicKey: _key,
        ),
      );
      expect(owned, isEmpty);
    });

    test('a purchase with no signature at all fails without asking', () async {
      final integrity = _FakeIntegrity(signatureOk: true);
      expect(
        await playSignatureHolds(
          _playPurchase(signature: ''),
          integrity: integrity,
          licensingPublicKey: _key,
        ),
        isFalse,
      );
      expect(integrity.verified, isEmpty);
    });

    test('a verify that could not run counts the purchase', () async {
      // A malformed key in release_keys.dart, a dead channel: not the
      // buyer's signature failing, so not a reason to take anything away.
      expect(
        await playSignatureHolds(
          _playPurchase(),
          integrity: _FakeIntegrity(),
          licensingPublicKey: _key,
        ),
        isTrue,
      );
    });

    test('the past-purchase read keeps verified and drops pending', () async {
      final owned = await ownedPlayProducts(
        [
          _playPurchase(),
          _playPurchase(
            product: 'other',
            state: PurchaseStateWrapper.pending,
          ),
        ],
        signatureHolds: (_) async => true,
      );
      expect(owned, {kPremiumProductId});
    });
  });

  group('(d) the store cannot answer', () {
    test('a trusted build keeps its cached unlock offline', () async {
      await boot(
        policy: _armed,
        integrity: _FakeIntegrity(),
        prefs: {_cacheKey: true},
      );
      expect(unlocked(), isTrue);
    });

    test('nothing cached stays locked, as today', () async {
      await boot(policy: _armed, integrity: _FakeIntegrity());
      expect(unlocked(), isFalse);
    });
  });

  group('(e) no keys configured yet', () {
    test("both checks are skipped and today's behaviour stands", () async {
      final integrity = _FakeIntegrity(
        certificates: ['DE:AD:BE:EF'],
        signatureOk: false,
      );
      await boot(
        policy: _unconfigured,
        integrity: integrity,
        owned: () async => {},
      );
      await deliver([_playPurchase()]);
      expect(unlocked(), isTrue);
      expect(integrity.certificateReads, 0);
      expect(integrity.verified, isEmpty);
    });

    test('the cached unlock still decides offline', () async {
      await boot(
        policy: _unconfigured,
        integrity: _FakeIntegrity(certificates: ['DE:AD:BE:EF']),
        prefs: {_cacheKey: true},
      );
      expect(unlocked(), isTrue);
    });
  });

  group('(f) iOS', () {
    test('a StoreKit purchase is never sent to the Play verifier', () async {
      final integrity = _FakeIntegrity(signatureOk: false);
      await boot(
        policy: _debug,
        integrity: integrity,
        owned: () async => {},
      );
      await deliver([_applePurchase()]);
      expect(unlocked(), isTrue);
      expect(integrity.verified, isEmpty);
    });

    test('the build policy only arms the certificate check on Android', () {
      expect(
        IntegrityPolicy.forBuild(
          release: true,
          android: false,
        ).enforceCertificate,
        isFalse,
      );
      expect(
        IntegrityPolicy.forBuild(
          release: true,
          android: true,
        ).enforceCertificate,
        isTrue,
      );
    });
  });

  group('(g) debug and profile builds', () {
    test('skip the certificate check', () async {
      final integrity = _FakeIntegrity(certificates: ['DE:AD:BE:EF']);
      await boot(
        policy: _debug,
        integrity: integrity,
        prefs: {_cacheKey: true},
      );
      expect(unlocked(), isTrue);
      expect(integrity.certificateReads, 0);
    });

    test('are not release builds as far as the policy is concerned', () {
      expect(
        IntegrityPolicy.forBuild(
          release: false,
          android: true,
        ).enforceCertificate,
        isFalse,
      );
    });
  });
}
