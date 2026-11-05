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
/// The native code copies each opened file into the app's cache and hands
/// over the copy's path: through `opened(path)` while the app runs, and in
/// the answer to [initial] for the files that came before Dart could take
/// them (the one that started the app, or several opened in quick
/// succession). A file bigger than [PackCodec.maxFileBytes] is never
/// copied; [tooBig] comes instead, and [unreadable] when the copy failed.
///
/// The native side answers [initial] once with what it holds and then
/// forgets it, and only calls `opened` after that first question, so
/// neither a rebuild nor a hot restart imports the same file twice.
class IncomingFileChannel {
  IncomingFileChannel([this._channel = const MethodChannel(name)]);

  static const String name = 'fnm/incoming_file';

  /// In place of a path: the file was over [PackCodec.maxFileBytes].
  static const String tooBig = 'fnm:tooBig';

  /// In place of a path: the file could not be read or copied.
  static const String unreadable = 'fnm:unreadable';

  final MethodChannel _channel;
  bool _askedInitial = false;

  /// Whose handler is on the channel: see [listen] and [cancel].
  Object? _owner;

  /// The files that came before Dart was listening, once; empty after the
  /// first call, and on a platform with no native side.
  Future<List<String>> initial() async {
    if (_askedInitial) return const [];
    _askedInitial = true;
    try {
      final answer = await _channel.invokeMethod<Object?>('initial');
      return switch (answer) {
        final String path => [path],
        final List<Object?> paths => paths.whereType<String>().toList(),
        _ => const [],
      };
    } on MissingPluginException {
      return const [];
    } on PlatformException catch (e, st) {
      AppLog.error('incoming-initial', e, st);
      return const [];
    }
  }

  /// Hands every file opened from now on to [onOpened], until [cancel] is
  /// called with the token this returns.
  Object listen(void Function(String path) onOpened) {
    final token = Object();
    _owner = token;
    _channel.setMethodCallHandler((call) async {
      final path = call.arguments;
      if (call.method == 'opened' && path is String) onOpened(path);
    });
    return token;
  }

  /// Takes the handler [listen] set for [token] off the channel; a handler
  /// someone set since stays.
  void cancel(Object token) {
    if (!identical(_owner, token)) return;
    _owner = null;
    _channel.setMethodCallHandler(null);
  }
}

final incomingFileProvider = Provider<IncomingFileChannel>(
  (ref) => IncomingFileChannel(),
);

/// Imports every `.fnmdb` the OS hands the app, wherever the manager is.
///
/// Sits at the app root (inside `MaterialApp.router`'s builder), so it hears
/// a file on any screen, and says in a snackbar how the import went.
///
/// A file opened while the app runs never takes the manager anywhere on its
/// own: whatever is on screen (a live match, a draw, a press conference
/// half answered, an edit in progress) may hold something not yet written,
/// and leaving it could lose that. The snackbar offers Open instead, which
/// goes to the new database's home unless the screen by then is one with no
/// way out but through ([systemBackAction] says [StayPut]); the database
/// waits in the editor list either way.
///
/// The files the app was started with ([IncomingFileChannel.initial]) open
/// straight away: nothing was on screen yet.
///
/// Files are imported one at a time, in the order they came.
class IncomingFileListener extends ConsumerStatefulWidget {
  const IncomingFileListener({required this.child, super.key});

  static const Key openActionKey = Key('incomingFile.open');

  final Widget child;

  @override
  ConsumerState<IncomingFileListener> createState() =>
      _IncomingFileListenerState();
}

class _IncomingFileListenerState extends ConsumerState<IncomingFileListener> {
  late final IncomingFileChannel _incoming;
  late final Object _listening;
  Future<void> _queue = Future<void>.value();

  @override
  void initState() {
    super.initState();
    _incoming = ref.read(incomingFileProvider);
    _listening = _incoming.listen((path) => _enqueue(path, coldStart: false));
    // The router has built its first screen by the end of the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      for (final path in await _incoming.initial()) {
        _enqueue(path, coldStart: true);
      }
    });
  }

  @override
  void dispose() {
    _incoming.cancel(_listening);
    super.dispose();
  }

  void _enqueue(String path, {required bool coldStart}) =>
      _queue = _queue.then((_) => _open(path, coldStart: coldStart));

  Future<void> _open(String path, {required bool coldStart}) async {
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
    final packId = id;
    if (packId == null) {
      ScaffoldMessenger.maybeOf(
        context,
      )?.showSnackBar(SnackBar(content: Text(importRefusal(l, refused!))));
      return;
    }
    if (coldStart) {
      ScaffoldMessenger.maybeOf(
        context,
      )?.showSnackBar(SnackBar(content: Text(l.editorImported)));
      _goToPack(packId);
      return;
    }
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(
        content: Text(l.editorImported),
        action: SnackBarAction(
          key: IncomingFileListener.openActionKey,
          label: l.editorImportOpen,
          onPressed: () => _goToPack(packId),
        ),
      ),
    );
  }

  /// Opens pack [packId]'s home, unless the screen is one with no way out
  /// but through.
  void _goToPack(int packId) {
    if (!mounted) return;
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
