/// Identifiers the cloud backups need from outside the code.
///
/// Both are set up by the owner in Apple's and Google's consoles; see the
/// cloud-backup checklist. Until they are, the matching feature reports itself
/// as not set up and stays off. Nothing crashes.
library;

/// The iCloud container automatic backups live in. Must match
/// `ios/Runner/Runner.entitlements` and the container registered on the App ID.
const String kICloudContainerId = 'iCloud.com.fnm.fnm';

/// Whether this build carries the iCloud entitlement at all. On since 1.0.7
/// (12): the container is registered on the App ID and the three Runner
/// build configurations of project.pbxproj point at Runner.entitlements. A
/// build that somehow lacks the entitlement still reports "not set up",
/// because the container path comes back empty. `--dart-define=FNM_ICLOUD=
/// false` switches it off.
const bool kICloudEnabled = bool.fromEnvironment(
  'FNM_ICLOUD',
  defaultValue: true,
);

/// The client ID of the WEB application OAuth client in the Google Cloud
/// project (it ends in `.apps.googleusercontent.com`). Android's Google Sign-In
/// needs it as the "server client ID" even though there is no server; the
/// Android OAuth clients (package name plus SHA-1) must exist in the same
/// project. Empty means Google Drive backup is not set up in this build.
///
/// Paste it as the default value below, or pass it at build time with
/// `--dart-define=FNM_GOOGLE_SERVER_CLIENT_ID=...`.
const String kGoogleServerClientId = String.fromEnvironment(
  'FNM_GOOGLE_SERVER_CLIENT_ID',
);
