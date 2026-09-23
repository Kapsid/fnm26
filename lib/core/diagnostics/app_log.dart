import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// An on-device crash log.
///
/// The game has no backend and asks for no network permission, so a crash on
/// someone else's phone is otherwise invisible: the app dies, and nothing is
/// left behind to say why. This writes the same errors Flutter would have
/// printed to a debug console into a small rolling file the player can read
/// and send back from Settings → Diagnostics.
///
/// Deliberately dependency-free: no reporting SDK, no network, nothing that
/// would add a privacy disclosure to an app that currently collects nothing.
///
/// Every method here swallows its own failures. A logger that throws while
/// recording a crash turns one bug into two, and there is nowhere left to
/// report the second one.
abstract final class AppLog {
  /// The log is trimmed to the most recent [_maxBytes] on launch. Big enough
  /// to hold a good run of stack traces, small enough to paste into a message.
  static const int _maxBytes = 128 * 1024;

  /// How many entries the in-memory mirror keeps for the diagnostics screen,
  /// so it can render without waiting on the disk.
  static const int _memoryEntries = 50;

  static File? _file;
  static final List<String> _recent = [];

  /// Serializes appends so two crashes in the same frame can't interleave
  /// halfway through each other's stack traces.
  static Future<void> _writes = Future<void>.value();

  /// Installs the global error handlers and prepares the log file. Call once,
  /// inside the same zone as `runApp` (see `main.dart`).
  static Future<void> init() async {
    FlutterError.onError = (details) {
      // Keep the console behaviour developers expect in debug…
      FlutterError.presentError(details);
      // …and record it either way.
      error(
        'flutter:${details.library ?? 'framework'}',
        details.exception,
        details.stack,
      );
    };
    // Errors from the engine/platform side that never reach FlutterError.
    PlatformDispatcher.instance.onError = (e, st) {
      error('platform', e, st);
      return true;
    };
    await _open();
  }

  static Future<void> _open() async {
    try {
      final dir = await getApplicationSupportDirectory();
      final file = File(p.join(dir.path, 'diagnostics.log'));
      if (!file.existsSync()) {
        await file.create(recursive: true);
      } else if (await file.length() > _maxBytes) {
        // Roll by keeping the tail: the most recent crash is the one being
        // investigated, and dropping the head costs nothing.
        final tail = await file.readAsString();
        await file.writeAsString(tail.substring(tail.length - _maxBytes ~/ 2));
      }
      _file = file;
    } on Object {
      // No writable support directory (or a platform without one): the
      // in-memory mirror still serves the diagnostics screen for this run.
      _file = null;
    }
  }

  /// Records one error. [context] says where it came from ('hub:advance',
  /// 'platform', …) so a stack trace has something to hang on.
  static void error(String context, Object e, [StackTrace? st]) {
    final entry = StringBuffer()
      ..writeln('--- ${DateTime.now().toIso8601String()}  [$context]')
      ..writeln(e);
    if (st != null) entry.writeln(st);
    _append(entry.toString());
  }

  static void _append(String entry) {
    _recent.add(entry);
    if (_recent.length > _memoryEntries) _recent.removeAt(0);
    final file = _file;
    if (file == null) return;
    _writes = _writes.then((_) async {
      try {
        await file.writeAsString(entry, mode: FileMode.append, flush: true);
      } on Object {
        // Disk full, sandbox revoked — nothing useful left to do.
      }
    });
  }

  /// The log as the diagnostics screen shows it, newest last. Falls back to
  /// this run's in-memory entries when the file could not be opened.
  static Future<String> read() async {
    final file = _file;
    if (file == null) return _recent.join('\n');
    try {
      final onDisk = await file.readAsString();
      return onDisk.isEmpty ? _recent.join('\n') : onDisk;
    } on Object {
      return _recent.join('\n');
    }
  }

  /// Empties the log (the diagnostics screen's "clear" action).
  static Future<void> clear() async {
    _recent.clear();
    final file = _file;
    if (file == null) return;
    try {
      await file.writeAsString('');
    } on Object {
      // Nothing to do — the screen will simply keep showing what it read.
    }
  }

  /// Test seam: point the log at a temporary file (or nowhere) and reset state.
  @visibleForTesting
  static void debugUse(File? file) {
    _file = file;
    _recent.clear();
    _writes = Future<void>.value();
  }

  /// Test seam: waits for every queued append to reach the disk.
  @visibleForTesting
  static Future<void> debugFlush() => _writes;
}
