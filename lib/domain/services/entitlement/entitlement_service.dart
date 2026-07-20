import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The store product id of the one-time premium unlock. Must match the
/// non-consumable product configured in App Store Connect and the managed
/// product in the Play Console.
const String kPremiumProductId = 'com.fnm.fnm.premium';

/// Local cache key for the granted entitlement, so an offline launch keeps
/// premium without asking the store.
const String _kPremiumCacheKey = 'entitlement.premium';

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
class EntitlementService {
  EntitlementService(this._ref, {InAppPurchase? iap})
      : _iap = iap ?? InAppPurchase.instance;

  final Ref _ref;
  final InAppPurchase _iap;
  StreamSubscription<List<PurchaseDetails>>? _sub;

  /// Human-readable reason the last purchase attempt failed, for the paywall.
  String? lastError;

  /// Loads the cached entitlement and starts listening to the store's purchase
  /// stream. Call once at app start; safe if the store is unreachable.
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_kPremiumCacheKey) ?? false) {
      _ref.read(premiumUnlockedProvider.notifier).state = true;
    }
    _sub ??= _iap.purchaseStream.listen(_onPurchases);
  }

  void dispose() {
    unawaited(_sub?.cancel());
    _sub = null;
  }

  /// The premium product's store listing (localised price), or null when the
  /// store can't be reached or the product isn't configured yet.
  Future<ProductDetails?> product() async {
    if (!await _iap.isAvailable()) return null;
    final response = await _iap.queryProductDetails({kPremiumProductId});
    return response.productDetails
        .where((p) => p.id == kPremiumProductId)
        .firstOrNull;
  }

  /// Starts the store purchase flow. Completion arrives via the purchase
  /// stream (see [_onPurchases]); returns false if the flow could not start.
  Future<bool> buy() async {
    _setFlow(PurchaseFlowState.loading);
    final details = await product();
    if (details == null) {
      lastError = 'The store is unavailable right now — try again later.';
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kPremiumCacheKey, true);
    _ref.read(premiumUnlockedProvider.notifier).state = true;
    _setFlow(PurchaseFlowState.idle);
  }

  // ignore: use_setters_to_change_properties - mutates a provider, not a field
  void _setFlow(PurchaseFlowState s) =>
      _ref.read(purchaseFlowProvider.notifier).state = s;
}

/// The purchase flow's UI state, for the paywall sheet.
final StateProvider<PurchaseFlowState> purchaseFlowProvider =
    StateProvider((_) => PurchaseFlowState.idle);

final Provider<EntitlementService> entitlementServiceProvider = Provider(
  (ref) {
    final service = EntitlementService(ref);
    ref.onDispose(service.dispose);
    return service;
  },
);
