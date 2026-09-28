import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_2_wrappers.dart';

/// Answers which product ids the operating system says this account owns.
///
/// Returns null for "would not say" - no store on this platform, it refused,
/// the platform channel is not there, the call never came back. Null is never
/// evidence that somebody did not buy, and callers must treat it as a question
/// left unanswered rather than as a no. A non-null set is an answer: the store
/// was asked, and these are the entitlements it named.
typedef StoreEntitlementReader = Future<Set<String>?> Function();

/// How long the entitlement read may take before it counts as unanswered.
///
/// The read itself is local, so this only bounds a wedged platform channel.
/// Nothing about launch waits on it (`FnmApp` leaves `init()` unawaited), and
/// a timeout grants rather than denies.
const Duration kStoreEntitlementTimeout = Duration(seconds: 5);

/// The entitlement read for whichever store this device has: StoreKit 2 on
/// iOS, Play Billing on Android, and no answer anywhere else (the Mac that
/// runs `flutter test` included).
Future<Set<String>?> readStoreEntitlements() async {
  if (kIsWeb) return null;
  if (Platform.isIOS) return readAppleEntitlements();
  if (Platform.isAndroid) return readGoogleEntitlements();
  return null;
}

/// The premium entitlement as StoreKit 2 knows it.
///
/// `SK2Transaction.transactions()` wraps Apple's `Transaction.all`, and the
/// plugin hands back only the `.verified` cases: the OS has already checked
/// each transaction's signature, which is why there is nothing to verify by
/// hand here and no key to ship. It reads the device's own transaction store,
/// so it answers with the radio off. Revoked transactions (a refund, family
/// sharing withdrawn) stay in `Transaction.all` with a revocation date on
/// them, so they are filtered out to leave what Apple calls the current
/// entitlements.
Future<Set<String>?> readAppleEntitlements() async {
  // iOS only, deliberately: the host under `flutter test` is a Mac, which
  // must never be mistaken for a device that answered.
  if (kIsWeb || !Platform.isIOS) return null;
  // StoreKit 2 has been the plugin's default since 0.4.9. If anything has put
  // the app back on StoreKit 1 there are no verified transactions to read.
  if (!InAppPurchaseStoreKitPlatform.isStoreKit2Enabled) return null;
  try {
    final transactions = await SK2Transaction.transactions().timeout(
      kStoreEntitlementTimeout,
    );
    return <String>{
      for (final t in transactions)
        if (!isRevokedTransaction(t.jsonRepresentation)) t.productId,
    };
  } on Object {
    // No store, no channel, no answer. Say so rather than guessing "no".
    return null;
  }
}

/// The premium entitlement as Google Play knows it.
///
/// `queryPastPurchases` wraps Play Billing's `queryPurchasesAsync`, which
/// Play answers from its own on-device record of what this Google account
/// owns: no network of ours, and it answers with the radio off once Play has
/// synced. A refunded or voided purchase drops out of that record, which is
/// what lets Play take an unlock back the way StoreKit's revocation date does.
///
/// Only `purchased` counts. A `pending` purchase (cash at a shop, a slow card)
/// has not been paid for yet; the purchase stream grants it when it clears.
///
/// Anything bought but never acknowledged (the app died between the payment
/// and `completePurchase`) is acknowledged here, because Play refunds an
/// unacknowledged purchase after three days and the player would lose an
/// unlock he paid for.
Future<Set<String>?> readGoogleEntitlements() async {
  if (kIsWeb || !Platform.isAndroid) return null;
  try {
    final addition = InAppPurchase.instance
        .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
    final response = await addition.queryPastPurchases().timeout(
      kStoreEntitlementTimeout,
    );
    // Any error is "would not say", even with a partial list beside it: the
    // cache decides then, and it only ever decides in the player's favour.
    if (response.error != null) return null;
    final owned = <String>{};
    for (final p in response.pastPurchases) {
      if (p.billingClientPurchase.purchaseState !=
          PurchaseStateWrapper.purchased) {
        continue;
      }
      owned.add(p.productID);
      if (p.pendingCompletePurchase) {
        try {
          await InAppPurchase.instance.completePurchase(p);
        } on Object {
          // The purchase stream replays it, and completes it, next time.
        }
      }
    }
    return owned;
  } on Object {
    // No Play Store, no signed-in account, no channel: no answer.
    return null;
  }
}

/// Whether Apple's JSON for a transaction says it has been revoked.
///
/// Unreadable JSON counts as not revoked: the OS verified the transaction to
/// get it this far, and a parse failure is our problem, not the buyer's.
@visibleForTesting
bool isRevokedTransaction(String? jsonRepresentation) {
  if (jsonRepresentation == null || jsonRepresentation.isEmpty) return false;
  try {
    final decoded = jsonDecode(jsonRepresentation);
    if (decoded is! Map<String, dynamic>) return false;
    return decoded['revocationDate'] != null ||
        decoded['revocationReason'] != null;
  } on Object {
    return false;
  }
}
