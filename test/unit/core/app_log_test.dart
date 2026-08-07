import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/diagnostics/app_log.dart';

/// [AppLog] is the whole of the game's crash reporting, and it runs at the
/// worst possible moment — while something else is already failing. These
/// tests cover the two things that matter there: that an error actually
/// survives to be read back, and that the logger never throws on its own.
void main() {
  late Directory dir;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('fnm_log');
    AppLog.debugUse(File('${dir.path}/diagnostics.log')..createSync());
  });

  tearDown(() {
    AppLog.debugUse(null);
    dir.deleteSync(recursive: true);
  });

  test('an error is written with its context and readable back', () async {
    AppLog.error('hub:advance', StateError('boom'), StackTrace.current);
    await AppLog.debugFlush();

    final log = await AppLog.read();
    expect(log, contains('hub:advance'));
    expect(log, contains('boom'));
    expect(log, contains('app_log_test.dart')); // the stack trace made it
  });

  test('errors logged in the same frame all survive', () async {
    for (var i = 0; i < 5; i++) {
      AppLog.error('ctx$i', Exception('failure $i'));
    }
    await AppLog.debugFlush();

    final log = await AppLog.read();
    for (var i = 0; i < 5; i++) {
      expect(log, contains('failure $i'));
    }
  });

  test('clear empties the log', () async {
    AppLog.error('ctx', Exception('gone'));
    await AppLog.debugFlush();
    await AppLog.clear();

    expect((await AppLog.read()).trim(), isEmpty);
  });

  test('an error with no stack trace still records', () async {
    AppLog.error('no-stack', Exception('bare'));
    await AppLog.debugFlush();

    expect(await AppLog.read(), contains('bare'));
  });

  test('with no writable file it falls back to memory, never throws', () async {
    AppLog.debugUse(null);

    expect(() => AppLog.error('ctx', Exception('memory only')), returnsNormally);
    await AppLog.debugFlush();
    expect(await AppLog.read(), contains('memory only'));
  });

  test('a deleted log file does not take the app down with it', () async {
    final file = File('${dir.path}/diagnostics.log');
    AppLog.debugUse(file);
    file.deleteSync();

    // The file is gone underneath us — appending recreates or fails silently,
    // but either way the caller (already handling a crash) must not see a
    // second exception.
    expect(() => AppLog.error('ctx', Exception('after delete')), returnsNormally);
    await AppLog.debugFlush();
    expect(() => AppLog.read(), returnsNormally);
  });
}
