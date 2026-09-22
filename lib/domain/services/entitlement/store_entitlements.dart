import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_2_wrappers.dart';

/// Answers which product ids the operating system says this account owns.
///
/// Returns null for "would not say" - not iOS, StoreKit refused, the platform
/// channel is not there, the call never came back. Null is never evidence
/// that somebody did not buy, and callers must treat it as a question left
/// unanswered rather than as a no. A non-null set is an answer: the store was
/// asked, and these are the entitlements it named.
typedef StoreEntitlementReader = Future<Set<String>?> Function();

/// How long the entitlement read may take before it counts as unanswered.
///
/// The read itself is local, so this only bounds a wedged platform channel.
/// Nothing about launch waits on it (`FnmApp` leaves `init()` unawaited), and
/// a timeout grants rather than denies.
const Duration kStoreEntitlementTimeout = Duration(seconds: 5);

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
  // iOS only, deliberately. Android's entitlement is a different mechanism
  // and is not built yet; and the host under `flutter test` is a Mac, which
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
