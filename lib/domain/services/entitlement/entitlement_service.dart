import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/entitlement/store_entitlements.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The store product id of the one-time premium unlock. Must match the
/// non-consumable product configured in App Store Connect and the managed
/// product in the Play Console.
const String kPremiumProductId = 'com.fnm.fnm.premium';

/// Local cache key for the granted entitlement, so an offline launch keeps
/// premium without asking the store.
const String _kPremiumCacheKey = 'entitlement.premium';

/// The key an even earlier build wrote. Read, never written: a player who
/// bought under it keeps his unlock.
const String _kLegacyPremiumCacheKey = 'premium_unlocked';

/// The one-off purchase state the paywall shows.
enum PurchaseFlowState { idle, loading, pending, error }

/// Drives the real store purchase for the premium unlock and keeps
/// [premiumUnlockedProvider] true across offline launches.
///
/// Trust model (an offline game with no backend): the OS store is the
/// authority. A purchase or restore only ever arrives through the platform's
/// billing pipeline (StoreKit verifies transaction signatures itself; Play
/// only reports purchases it accepted), and the grant is then cached locally
/// so the game never needs the network just to launch. `restorePurchases()`
/// re-asks the store, which is what heals a reinstall or a new device.
///
/// On iOS the cached boolean is no longer the source of truth. StoreKit 2's
/// verified transactions are, and they read locally: [init] asks the OS what
/// this Apple ID owns before it trusts anything on disk. That also fixes the
/// honest player's side of it, because a reinstall or a second device is
/// entitled without anyone having to find the Restore button. The cache stays
/// as the fallback for when the store cannot answer, and for Android, whose
/// own verification is not built yet.
class EntitlementService {
  EntitlementService(
    this._ref, {
    InAppPurchase? iap,
    StoreEntitlementReader? storeEntitlements,
  }) : _iap = iap ?? InAppPurchase.instance,
       _storeEntitlements = storeEntitlements ?? readAppleEntitlements;

  final Ref _ref;
  final InAppPurchase _iap;
  final StoreEntitlementReader _storeEntitlements;
  StreamSubscription<List<PurchaseDetails>>? _sub;

  /// Human-readable reason the last purchase attempt failed, for the paywall.
  String? lastError;

  /// Why the last [product] lookup came back empty, or null if it did not.
  /// Untranslated on purpose: see `kShowStoreDiagnostics`.
  String? storeDiagnostic;

  /// Establishes the entitlement and starts listening to the store's purchase
  /// stream. Call once at app start; safe if the store is unreachable.
  ///
  /// The order is the whole point. The store is asked first, because on iOS
  /// it knows what was actually bought and the file on disk does not. Only
  /// when the store cannot answer at all does the cached grant decide, and
  /// then it always decides in the player's favour: nothing here ever writes
  /// `false`, and a check that fails to run is not evidence of anything.
  Future<void> init() async {
    final cached = await _cachedGrant();
    final owned = await _storeOwnedProducts();
    if (owned != null) {
      // The store answered. Its answer is the truth on this device, in both
      // directions: it entitles a reinstall nobody restored by hand, and it
      // is the one thing that can decline a boolean somebody wrote himself.
      if (owned.contains(kPremiumProductId)) await _grant();
    } else if (cached) {
      // Simulator, StoreKit missing, a wedged channel, Android. Grant, and
      // leave the cache alone so the next launch can try the store again.
      _ref.read(premiumUnlockedProvider.notifier).state = true;
    }
    try {
      _sub ??= _iap.purchaseStream.listen(_onPurchases);
    } on Object {
      // No store on this device (or it refused to start). The game runs; the
      // paywall will simply report the store as unavailable.
    }
  }

  /// The products the OS says this account owns, or null when it would not
  /// say. Never throws: an entitlement read that blows up is an unanswered
  /// question, not a denial.
  Future<Set<String>?> _storeOwnedProducts() async {
    try {
      return await _storeEntitlements();
    } on Object {
      return null;
    }
  }

  /// The locally cached grant, under either key any build has written.
  Future<bool> _cachedGrant() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return (prefs.getBool(_kPremiumCacheKey) ?? false) ||
          (prefs.getBool(_kLegacyPremiumCacheKey) ?? false);
    } on Object {
      // Unreadable cache: it grants nothing, and it takes nothing away.
      return false;
    }
  }

  void dispose() {
    unawaited(_sub?.cancel());
    _sub = null;
  }

  /// The premium product's store listing (localised price), or null when the
  /// store can't be reached or the product isn't configured yet.
  ///
  /// Every null return leaves a reason in [storeDiagnostic], because the three
  /// of them are unrelated problems wearing one message. A device with no
  /// store is a device; a store that answers with an error is a store; a
  /// product id the store has never heard of is App Store Connect. The paywall
  /// prints the reason behind `kShowStoreDiagnostics`.
  Future<ProductDetails?> product() async {
    storeDiagnostic = null;
    if (!await _iap.isAvailable()) {
      storeDiagnostic =
          'No store on this device. In TestFlight, sign in under '
          'Settings > App Store > Sandbox Account.';
      return null;
    }
    final response = await _iap.queryProductDetails({kPremiumProductId});
    final found = response.productDetails
        .where((p) => p.id == kPremiumProductId)
        .firstOrNull;
    if (found != null) return found;
    if (response.error case final e?) {
      storeDiagnostic = 'Store error ${e.code}: ${e.message}';
    } else {
      // The store answered and does not sell this. Either the id does not
      // match App Store Connect, or the product is not Ready to Submit, or
      // the Paid Applications Agreement is not active.
      storeDiagnostic = 'Store has no product "$kPremiumProductId".';
    }
    return null;
  }

  /// Starts the store purchase flow. Completion arrives via the purchase
  /// stream (see [_onPurchases]); returns false if the flow could not start.
  Future<bool> buy() async {
    _setFlow(PurchaseFlowState.loading);
    final details = await product();
    if (details == null) {
      lastError =
          storeDiagnostic ??
          'The store is unavailable right now. Try again later.';
      _setFlow(PurchaseFlowState.error);
      return false;
    }
    _setFlow(PurchaseFlowState.pending);
    return _iap.buyNonConsumable(
      purchaseParam: PurchaseParam(productDetails: details),
    );
  }

  /// Asks the store to replay past purchases (reinstall / new device). The
  /// grant, if any, arrives via the purchase stream.
  Future<void> restore() async {
    _setFlow(PurchaseFlowState.pending);
    await _iap.restorePurchases();
    // No purchases to replay ends the flow silently — reflect that instead of
    // spinning forever. A replayed purchase flips this to idle via _grant.
    Timer(const Duration(seconds: 8), () {
      if (_ref.read(purchaseFlowProvider) == PurchaseFlowState.pending &&
          !_ref.read(premiumUnlockedProvider)) {
        lastError = 'No previous purchase found for this store account.';
        _setFlow(PurchaseFlowState.error);
      }
    });
  }

  Future<void> _onPurchases(List<PurchaseDetails> purchases) async {
    for (final p in purchases) {
      if (p.productID != kPremiumProductId) continue;
      switch (p.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          await _grant();
        case PurchaseStatus.error:
          lastError = p.error?.message ?? 'Purchase failed.';
          _setFlow(PurchaseFlowState.error);
        case PurchaseStatus.canceled:
          _setFlow(PurchaseFlowState.idle);
        case PurchaseStatus.pending:
          _setFlow(PurchaseFlowState.pending);
      }
      // Stores require every delivered purchase to be acknowledged, or they
      // refund it (Play) / redeliver it forever (StoreKit).
      if (p.pendingCompletePurchase) {
        await _iap.completePurchase(p);
      }
    }
  }

  Future<void> _grant() async {
    // The grant lands in memory first: a preferences write that fails must not
    // cost a player the unlock he has just paid for in this session.
    _ref.read(premiumUnlockedProvider.notifier).state = true;
    _setFlow(PurchaseFlowState.idle);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kPremiumCacheKey, true);
    } on Object {
      // Not cached. The store replays the purchase on the next launch, and
      // `restore()` is always there.
    }
  }

  // ignore: use_setters_to_change_properties - mutates a provider, not a field
  void _setFlow(PurchaseFlowState s) =>
      _ref.read(purchaseFlowProvider.notifier).state = s;
}

/// The purchase flow's UI state, for the paywall sheet.
final StateProvider<PurchaseFlowState> purchaseFlowProvider = StateProvider(
  (_) => PurchaseFlowState.idle,
);

final Provider<EntitlementService> entitlementServiceProvider = Provider(
  (ref) {
    final service = EntitlementService(ref);
    ref.onDispose(service.dispose);
    return service;
  },
);
