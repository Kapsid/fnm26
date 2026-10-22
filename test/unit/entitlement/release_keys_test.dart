import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/config/release_keys.dart';
import 'package:fnm/domain/services/entitlement/integrity.dart';

/// The runtime treats an empty value as "skip that check", so a release built
/// with a key blanked or mangled by accident would quietly stop protecting
/// itself. This fails it instead.
void main() {
  test(
    'the release keys are filled in and well formed',
    () {
      for (final cert in [kPlayAppSigningCertSha256, kUploadCertSha256]) {
        // Any form the runtime accepts: colons or not, either case. What is
        // left after normalising must be exactly 32 bytes of hex, and nothing
        // but hex and separators may have been stripped to get there.
        expect(
          normaliseFingerprint(cert).length,
          64,
          reason: '"$cert" is not a SHA-256 fingerprint',
        );
        expect(
          RegExp(r'^[0-9A-Fa-f:\s]+$').hasMatch(cert.trim()),
          isTrue,
          reason: '"$cert" holds something other than hex and colons',
        );
      }
      // A 2048-bit RSA SubjectPublicKeyInfo is 294 bytes of DER.
      final key = base64.decode(kPlayLicensingPublicKey.trim());
      expect(key.length, greaterThanOrEqualTo(290));
      expect(
        normaliseFingerprint(kPlayAppSigningCertSha256),
        isNot(normaliseFingerprint(kUploadCertSha256)),
      );
    },
  );
}
