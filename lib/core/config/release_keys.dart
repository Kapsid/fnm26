/// The three Play Console values the Android integrity checks compare against.
///
/// None of these is a secret: a certificate fingerprint is printed by anyone
/// who holds the APK, and a licensing key is a PUBLIC key. They live in one
/// file so there is exactly one place to paste them.
///
/// Every value may be left empty, and empty means "skip that check": a missing
/// value can never lock a paying player out, it only leaves the build as easy
/// to repackage as it was before the checks existed. The skipped test in
/// test/unit/entitlement/release_keys_test.dart is what makes shipping without
/// them visible.
library;

/// SHA-256 of the Play App Signing certificate: the key Google signs every
/// install from the Play Store with.
///
/// Play Console → the app → Test and release → App integrity → App signing →
/// "App signing key certificate" → SHA-256 certificate fingerprint. Paste it
/// as shown (`AB:CD:...`); case and colons do not matter.
const String kPlayAppSigningCertSha256 =
    'D1:5F:BC:D2:A7:00:E2:AC:D6:C6:92:67:AC:B4:97:FD:'
    'FE:19:F6:1D:D1:44:AF:71:B8:29:CE:D9:4C:3F:67:D3';

/// SHA-256 of the upload certificate: the key in android/key.properties that
/// signs the bundles uploaded to Play, and the release APKs the owner installs
/// on his own phone with `adb install -r`. Leave it out and those sideloads
/// read as repackaged and stay locked.
///
/// Same page as above → "Upload key certificate" → SHA-256 certificate
/// fingerprint (or `keytool -list -v -keystore ~/fnm-upload-key.jks`).
const String kUploadCertSha256 =
    '70:9D:59:36:E1:95:82:C9:12:EE:9F:CF:17:F3:C7:AD:'
    'D2:5D:D1:95:5E:EA:FC:DF:E7:F7:6B:17:79:FE:F6:5C';

/// The app's Play licensing public key: Base64 of an X.509 RSA public key,
/// which Play uses to sign every purchase it reports (SHA1withRSA over the
/// purchase's original JSON).
///
/// Play Console → the app → Monetize with Play → Monetization setup →
/// Licensing → the Base64-encoded RSA public key (one long line, starts with
/// `MIIB`).
const String kPlayLicensingPublicKey =
    'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAiAwg5dGfmVQtfv01WfTl'
    '/3gl762YeJ622xKvJbg0n3rkBGUX0ADR0yXoA+ouvx+p/RgI8juG8DO9m3V8S6qp'
    'EKMtgbMrH8tJ5/z85Ra0xpFsDxyp+3MWqr5gQ/ipCHCwe4N/ehZZqFh5pFro8wlN'
    'rswXnykKMoSU2mWFhIFq8dHxiwBf5803rYfKxiRqq/m2/ullGA0fTRugFHYNhoFp'
    'gWX5M3dbQV+PBJfTVZa1LG10YgqfwjZPCYVzWQ9+l1E/M/DZ4GRVt91eWETZO7uD'
    '1ns4EzvDlws71gOLSRKL0rEQVSQU6KW14cPYF12/mvcwj8rnaf5zK0EpYEgyklIL'
    'fQIDAQAB';
