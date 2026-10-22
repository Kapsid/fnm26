import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:fnm/core/config/release_keys.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

/// The two questions only the Android side can answer: which certificate
/// signed this APK, and whether Play really signed a purchase.
///
/// Every answer may be null, meaning "could not be asked". Null is never a no:
/// the callers below turn it into a pass, because a check that failed to run
/// is our problem and never the buyer's.
abstract class AppIntegrity {
  /// SHA-256 fingerprints (hex) of the certificates that signed this APK, or
  /// null when the platform would not say.
  Future<List<String>?> signingCertificates();

  /// Whether [signature] is Play's SHA1withRSA signature over [originalJson]
  /// under [publicKey]. False only when the check ran and the signature does
  /// not hold; null when it could not run (bad key, no channel).
  Future<bool?> verifyPurchase({
    required String originalJson,
    required String signature,
    required String publicKey,
  });
}

/// [AppIntegrity] over MainActivity's `fnm/integrity` channel.
class ChannelAppIntegrity implements AppIntegrity {
  const ChannelAppIntegrity();

  static const MethodChannel _channel = MethodChannel('fnm/integrity');

  @override
  Future<List<String>?> signingCertificates() async {
    try {
      return await _channel.invokeListMethod<String>('signingCertificates');
    } on Object {
      return null;
    }
  }

  @override
  Future<bool?> verifyPurchase({
    required String originalJson,
    required String signature,
    required String publicKey,
  }) async {
    try {
      return await _channel.invokeMethod<bool>('verifyPurchase', {
        'originalJson': originalJson,
        'signature': signature,
        'publicKey': publicKey,
      });
    } on Object {
      return null;
    }
  }
}

/// Which integrity checks this build runs, and against what.
///
/// An empty allow-list or an empty key turns its check off. That is the
/// shipping default until the owner pastes the values into release_keys.dart,
/// and it is deliberate: a missing value can make the game easier to pirate,
/// never harder to play.
class IntegrityPolicy {
  const IntegrityPolicy({
    required this.enforceCertificate,
    required this.allowedCertificates,
    required this.licensingPublicKey,
  });

  /// The policy for a build: the certificate check runs only in an Android
  /// release build. Debug and profile builds are signed with the debug key,
  /// and iOS has no equivalent to ask (Apple re-signs everything anyway).
  factory IntegrityPolicy.forBuild({
    required bool release,
    required bool android,
  }) => IntegrityPolicy(
    enforceCertificate: release && android,
    allowedCertificates: const [kPlayAppSigningCertSha256, kUploadCertSha256],
    licensingPublicKey: kPlayLicensingPublicKey,
  );

  /// The policy for the build that is running.
  factory IntegrityPolicy.current() => IntegrityPolicy.forBuild(
    release: kReleaseMode,
    android: !kIsWeb && Platform.isAndroid,
  );

  final bool enforceCertificate;
  final List<String> allowedCertificates;
  final String licensingPublicKey;
}

/// A fingerprint reduced to bare upper-case hex, so `ab:cd` and `ABCD` match.
String normaliseFingerprint(String fingerprint) =>
    fingerprint.replaceAll(RegExp('[^0-9A-Fa-f]'), '').toUpperCase();

/// Whether this install may honour premium at all.
///
/// False only when the check is armed, the platform named its certificates,
/// and none of them is ours: a repackaged APK. Everything else passes.
Future<bool> certificateTrusted({
  required IntegrityPolicy policy,
  required AppIntegrity integrity,
}) async {
  if (!policy.enforceCertificate) return true;
  final allowed = {
    for (final c in policy.allowedCertificates)
      if (normaliseFingerprint(c).isNotEmpty) normaliseFingerprint(c),
  };
  if (allowed.isEmpty) return true;
  final List<String>? signers;
  try {
    signers = await integrity.signingCertificates();
  } on Object {
    return true;
  }
  if (signers == null || signers.isEmpty) return true;
  return signers.any((s) => allowed.contains(normaliseFingerprint(s)));
}

/// Whether Play's signature on [purchase] holds under [licensingPublicKey].
///
/// No key configured: skipped, true. A purchase that carries no signature at
/// all, with a key configured, is false without asking: Play signs every one.
/// A verify that could not run is true; only a signature that was checked and
/// failed takes the purchase away.
Future<bool> playSignatureHolds(
  GooglePlayPurchaseDetails purchase, {
  required AppIntegrity integrity,
  required String licensingPublicKey,
}) async {
  final key = licensingPublicKey.trim();
  if (key.isEmpty) return true;
  final json = purchase.billingClientPurchase.originalJson;
  final signature = purchase.billingClientPurchase.signature;
  if (json.isEmpty || signature.isEmpty) return false;
  try {
    final ok = await integrity.verifyPurchase(
      originalJson: json,
      signature: signature,
      publicKey: key,
    );
    return ok ?? true;
  } on Object {
    return true;
  }
}

/// The product ids among Play's past [purchases] that count as owned: paid
/// for (`pending` has not been) and signed by Play.
///
/// Anything paid but never acknowledged (the app died between the payment and
/// `completePurchase`) is acknowledged through [complete] whether or not it
/// verified, because Play refunds an unacknowledged purchase after three days
/// and a key pasted wrong must not turn into a buyer's lost money.
Future<Set<String>> ownedPlayProducts(
  Iterable<GooglePlayPurchaseDetails> purchases, {
  required Future<bool> Function(GooglePlayPurchaseDetails) signatureHolds,
  Future<void> Function(PurchaseDetails)? complete,
}) async {
  final owned = <String>{};
  for (final p in purchases) {
    if (p.billingClientPurchase.purchaseState !=
        PurchaseStateWrapper.purchased) {
      continue;
    }
    if (await signatureHolds(p)) owned.add(p.productID);
    if (p.pendingCompletePurchase && complete != null) {
      try {
        await complete(p);
      } on Object {
        // The purchase stream replays it, and completes it, next time.
      }
    }
  }
  return owned;
}
