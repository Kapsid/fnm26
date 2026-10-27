import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fnm/core/config/cloud_config.dart';
import 'package:fnm/domain/services/cloud/cloud_backup_target.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/googleapis_auth.dart' as gapis;
import 'package:http/http.dart' as http;

/// The one Drive permission the app asks for: its own hidden app-data folder.
/// It cannot see, list or touch anything else in the player's Drive, and the
/// folder does not show up in the Drive app.
const List<String> kDriveScopes = [drive.DriveApi.driveAppdataScope];

/// Signing in with Google for Drive backups, kept apart from the folder
/// operations so the settings screen can drive it and tests can fake it.
abstract interface class GoogleDriveAccount {
  /// Whether this build carries an OAuth client at all.
  bool get configured;

  /// Asks the player to sign in and grant the app-data scope. Returns the
  /// account's email, or null when the player backed out. Throws
  /// [CloudSetupException] when the build is not set up for it.
  Future<String?> signIn();

  /// Signs out and forgets the grant on this device.
  Future<void> signOut();
}

/// The build is missing the OAuth client (or it is wrong). Not the player's
/// doing, and not something he can fix.
class CloudSetupException implements Exception {
  const CloudSetupException(this.message);
  final String message;
  @override
  String toString() => 'CloudSetupException: $message';
}

/// Google Sign-In, initialised once per process as the plugin requires.
class GoogleSignInDriveAccount implements GoogleDriveAccount {
  GoogleSignInDriveAccount({this.serverClientId = kGoogleServerClientId});

  final String serverClientId;

  static Future<void>? _init;

  @override
  bool get configured => serverClientId.isNotEmpty && Platform.isAndroid;

  /// Initialises the plugin, once. Throws [CloudSetupException] when it cannot.
  Future<void> ensureInitialized() {
    if (!configured) {
      return Future.error(const CloudSetupException('no OAuth client'));
    }
    return _init ??= GoogleSignIn.instance
        .initialize(serverClientId: serverClientId)
        .catchError((Object e) {
          _init = null;
          throw CloudSetupException('$e');
        });
  }

  @override
  Future<String?> signIn() async {
    await ensureInitialized();
    try {
      final account = await GoogleSignIn.instance.authenticate(
        scopeHint: kDriveScopes,
      );
      await account.authorizationClient.authorizeScopes(kDriveScopes);
      return account.email;
    } on GoogleSignInException catch (e) {
      switch (e.code) {
        case GoogleSignInExceptionCode.canceled:
        case GoogleSignInExceptionCode.interrupted:
        case GoogleSignInExceptionCode.uiUnavailable:
          return null;
        case GoogleSignInExceptionCode.clientConfigurationError:
        case GoogleSignInExceptionCode.providerConfigurationError:
          throw CloudSetupException(e.description ?? e.code.name);
        case GoogleSignInExceptionCode.unknownError:
        case GoogleSignInExceptionCode.userMismatch:
          rethrow;
      }
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await ensureInitialized();
      await GoogleSignIn.instance.disconnect();
    } on Object {
      // Signed out as far as this app is concerned either way.
    }
  }

  /// An access token for the app-data scope WITHOUT showing anything, or null
  /// when that would need the player (signed out, or the grant withdrawn).
  Future<GoogleSignInClientAuthorization?> silentAuthorization() async {
    await ensureInitialized();
    return GoogleSignIn.instance.authorizationClient.authorizationForScopes(
      kDriveScopes,
    );
  }

  /// Drops a token Drive has refused, so the next request fetches a new one.
  Future<void> forget(String accessToken) => GoogleSignIn
      .instance
      .authorizationClient
      .clearAuthorizationToken(accessToken: accessToken);
}

/// Automatic backups in the Google Drive app-data folder.
///
/// Every call fetches a token silently; a background upload never puts a
/// sign-in screen in front of the player. When the token is missing the
/// target reports [CloudAvailability.signedOut] and the settings screen asks
/// him to sign in again.
class DriveBackupTarget implements CloudBackupTarget {
  DriveBackupTarget(this.account);

  final GoogleSignInDriveAccount account;

  /// Name to Drive file id, from the latest listing.
  final Map<String, String> _ids = {};

  @override
  CloudProvider get provider => CloudProvider.googleDrive;

  @override
  Future<CloudAvailability> availability() async {
    if (!account.configured) return CloudAvailability.notConfigured;
    try {
      final authz = await account.silentAuthorization();
      return authz == null
          ? CloudAvailability.signedOut
          : CloudAvailability.available;
    } on CloudSetupException {
      return CloudAvailability.notConfigured;
    } on GoogleSignInException catch (e) {
      return switch (e.code) {
        GoogleSignInExceptionCode.clientConfigurationError ||
        GoogleSignInExceptionCode.providerConfigurationError =>
          CloudAvailability.notConfigured,
        _ => CloudAvailability.unavailable,
      };
    } on Object {
      return CloudAvailability.unavailable;
    }
  }

  /// Runs [body] against Drive with a fresh token, retrying once with a new
  /// token if Drive turns the first one away.
  ///
  /// One HTTP client per attempt, created here and closed here. The client
  /// `authClient()` builds does not close the connection pool beneath it, so
  /// every call used to leave sockets open.
  Future<T> _drive<T>(Future<T> Function(drive.DriveApi api) body) async {
    for (var attempt = 0; ; attempt++) {
      final authz = await account.silentAuthorization();
      if (authz == null) {
        throw const CloudSetupException('not signed in to Google');
      }
      final inner = http.Client();
      final client = gapis.authenticatedClient(
        inner,
        gapis.AccessCredentials(
          gapis.AccessToken(
            'Bearer',
            authz.accessToken,
            DateTime.now().toUtc().add(const Duration(minutes: 50)),
          ),
          null,
          kDriveScopes,
        ),
      );
      try {
        return await body(drive.DriveApi(client));
      } on drive.DetailedApiRequestError catch (e) {
        if (e.status == 401 && attempt == 0) {
          await account.forget(authz.accessToken);
          continue;
        }
        rethrow;
      } finally {
        client.close();
        inner.close();
      }
    }
  }

  Future<String?> _idOf(String name) async {
    final known = _ids[name];
    if (known != null) return known;
    await list();
    return _ids[name];
  }

  @override
  Future<void> upload(File local, String name) => _put(
    name,
    local.openRead,
    local.lengthSync(),
    'application/octet-stream',
  );

  @override
  Future<void> writeText(String name, String text) {
    final bytes = utf8.encode(text);
    return _put(
      name,
      () => Stream.value(bytes),
      bytes.length,
      'application/json',
    );
  }

  Future<void> _put(
    String name,
    Stream<List<int>> Function() bytes,
    int length,
    String type,
  ) async {
    final existing = await _idOf(name);
    await _drive((api) async {
      // A fresh stream per attempt: a retried request cannot reuse one.
      final media = drive.Media(bytes(), length, contentType: type);
      if (existing != null) {
        await api.files.update(
          drive.File(),
          existing,
          uploadMedia: media,
          uploadOptions: drive.ResumableUploadOptions(),
        );
        return;
      }
      final created = await api.files.create(
        drive.File()
          ..name = name
          ..parents = ['appDataFolder'],
        uploadMedia: media,
        uploadOptions: drive.ResumableUploadOptions(),
        $fields: 'id',
      );
      if (created.id != null) _ids[name] = created.id!;
    });
  }

  @override
  Future<List<CloudFile>> list() => _drive((api) async {
    final out = <CloudFile>[];
    _ids.clear();
    String? page;
    do {
      final res = await api.files.list(
        spaces: 'appDataFolder',
        pageSize: 100,
        pageToken: page,
        $fields: 'nextPageToken, files(id, name, size, modifiedTime)',
      );
      for (final f in res.files ?? const <drive.File>[]) {
        final name = f.name;
        final id = f.id;
        if (name == null || id == null) continue;
        _ids[name] = id;
        out.add(
          CloudFile(
            name: name,
            size: int.tryParse(f.size ?? ''),
            modified: f.modifiedTime,
          ),
        );
      }
      page = res.nextPageToken;
    } while (page != null);
    return out;
  });

  Future<drive.Media?> _media(String name) async {
    final id = await _idOf(name);
    if (id == null) return null;
    return _drive(
      (api) async =>
          await api.files.get(
                id,
                downloadOptions: drive.DownloadOptions.fullMedia,
              )
              as drive.Media,
    );
  }

  @override
  Future<String?> readText(String name) async {
    final media = await _media(name);
    if (media == null) return null;
    final bytes = <int>[];
    await media.stream.forEach(bytes.addAll);
    return utf8.decode(bytes, allowMalformed: true);
  }

  @override
  Future<void> download(String name, String toPath) async {
    final media = await _media(name);
    if (media == null) throw FileSystemException('not in Drive', name);
    final sink = File(toPath).openWrite();
    try {
      await sink.addStream(media.stream);
    } finally {
      await sink.close();
    }
  }

  @override
  Future<void> delete(String name) async {
    final id = await _idOf(name);
    if (id == null) return;
    await _drive((api) => api.files.delete(id));
    _ids.remove(name);
  }
}
