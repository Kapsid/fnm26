import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/app.dart';
import 'package:fnm/core/diagnostics/app_log.dart';
import 'package:fnm/shared/widgets/app_crash_box.dart';

void main() {
  // Everything runs inside one guarded zone so an async error with no `await`
  // behind it — a fire-and-forget sim step, a stray stream — still reaches
  // [AppLog] instead of vanishing. `ensureInitialized` has to happen in the
  // same zone as `runApp`, hence the async body here.
  // ignore: discarded_futures - the zone body must be async to await
  // AppLog.init() before runApp; runZonedGuarded owns its completion, and any
  // failure inside it lands in the handler below.
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await AppLog.init();
      // A build failure shows a legible card rather than the framework's grey
      // "red screen" text, and is recorded on the way past.
      ErrorWidget.builder = (details) {
        AppLog.error('build', details.exception, details.stack);
        return const AppCrashBox();
      };
      runApp(
        const ProviderScope(
          child: FnmApp(),
        ),
      );
    },
    (e, st) => AppLog.error('zone', e, st),
  );
}
