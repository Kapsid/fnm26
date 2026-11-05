import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/diagnostics/app_log.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/routing/back_navigation.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/world_pack/pack_codec.dart';
import 'package:fnm/features/editor/editor_list_screen.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// The native side's word on `.fnmdb` files opened from other apps (Files,
/// Mail, a chat, AirDrop, a downloads folder).
///
/// The native code copies the opened file into the app's cache and hands
/// over the copy's path: through `opened(path)` while the app runs, and as
/// the answer to [initial] for the file that started it. A file bigger than
/// [PackCodec.maxFileBytes] is never copied; [tooBig] comes instead, and
/// [unreadable] when the copy failed.
///
/// The native side answers [initial] once and then forgets the file, and
/// only calls `opened` after that first question, so neither a rebuild nor a
/// hot restart imports the same file twice.
class IncomingFileChannel {
  IncomingFileChannel([this._channel = const MethodChannel(name)]);

  static const String name = 'fnm/incoming_file';

  /// In place of a path: the file was over [PackCodec.maxFileBytes].
  static const String tooBig = 'fnm:tooBig';

  /// In place of a path: the file could not be read or copied.
  static const String unreadable = 'fnm:unreadable';

  final MethodChannel _channel;
  bool _askedInitial = false;

  /// The file the app was opened with, once; null after the first call, and
  /// on a platform with no native side.
  Future<String?> initial() async {
    if (_askedInitial) return null;
    _askedInitial = true;
    try {
      return await _channel.invokeMethod<String>('initial');
    } on MissingPluginException {
      return null;
    } on PlatformException catch (e, st) {
      AppLog.error('incoming-initial', e, st);
      return null;
    }
  }

  /// Hands every file opened from now on to [onOpened].
  void listen(void Function(String path) onOpened) =>
      _channel.setMethodCallHandler((call) async {
        final path = call.arguments;
        if (call.method == 'opened' && path is String) onOpened(path);
      });

  void cancel() => _channel.setMethodCallHandler(null);
}

final incomingFileProvider = Provider<IncomingFileChannel>(
  (ref) => IncomingFileChannel(),
);

/// Imports every `.fnmdb` the OS hands the app, wherever the manager is.
///
/// Sits at the app root (inside `MaterialApp.router`'s builder), so it hears
/// a file on any screen: the import says how it went in a snackbar and then
/// opens the new database's home. A save that was on screen loses nothing:
/// every step of a career is written as it is taken. Only an event screen
/// that has no way out but through (a live match, a draw: see
/// [systemBackAction]) is not left; the database waits in the editor.
///
/// Files are imported one at a time, in the order they came.
class IncomingFileListener extends ConsumerStatefulWidget {
  const IncomingFileListener({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<IncomingFileListener> createState() =>
      _IncomingFileListenerState();
}

class _IncomingFileListenerState extends ConsumerState<IncomingFileListener> {
  late final IncomingFileChannel _incoming;
  Future<void> _queue = Future<void>.value();

  @override
  void initState() {
    super.initState();
    _incoming = ref.read(incomingFileProvider)..listen(_enqueue);
    // The router has built its first screen by the end of the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final path = await _incoming.initial();
      if (path != null) _enqueue(path);
    });
  }

  @override
  void dispose() {
    _incoming.cancel();
    super.dispose();
  }

  void _enqueue(String path) => _queue = _queue.then((_) => _open(path));

  Future<void> _open(String path) async {
    int? id;
    PackRejection? refused;
    if (path == IncomingFileChannel.tooBig) {
      refused = PackRejection.tooBig;
    } else if (path == IncomingFileChannel.unreadable) {
      refused = PackRejection.notAPack;
    } else {
      try {
        // The file that started the app may come before the world is in.
        await ref.read(seedLoaderProvider).ensureSeeded();
        final result = await ref
            .read(worldPackServiceProvider)
            .importFile(path);
        result.fold(
          (value) => id = value,
          (f) => refused =
              PackRejection.values.asNameMap()[f.code] ??
              PackRejection.notAPack,
        );
      } on Object catch (e, st) {
        AppLog.error('incoming-import', e, st);
        refused = PackRejection.notAPack;
      } finally {
        _discard(path);
      }
    }
    if (!mounted) return;
    final l = AppLocalizations.of(context);
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(
        content: Text(
          id != null ? l.editorImported : importRefusal(l, refused!),
        ),
      ),
    );
    final packId = id;
    if (packId == null) return;
    final router = ref.read(routerProvider);
    final here = router.routerDelegate.currentConfiguration.uri;
    if (systemBackAction(here) is StayPut) return;
    router.go(editorPackLocation(packId));
  }

  /// Removes the native side's cached copy, imported or not.
  static void _discard(String path) {
    try {
      final file = File(path);
      if (file.existsSync()) file.deleteSync();
    } on Object catch (e, st) {
      AppLog.error('incoming-discard', e, st);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
