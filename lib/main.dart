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
      runApp(const FnmRoot());
    },
    (e, st) => AppLog.error('zone', e, st),
  );
}

/// The app, and the one thing that can tear it down and build it again.
///
/// Restoring a backup replaces the database FILE under a running app. Nothing
/// short of a full teardown is safe after that: every provider is holding
/// queries against the handle that was open a moment ago. Rebuilding the
/// [ProviderScope] under a new key disposes the old container — which closes
/// the old database — and the new one opens whatever is on disk now.
///
/// Flutter cannot relaunch itself on iOS, so this is the closest thing there
/// is to a restart, and it is enough: nothing outside the scope holds state.
class FnmRoot extends StatefulWidget {
  const FnmRoot({super.key});

  /// Bumped to rebuild everything. A [ValueNotifier] rather than a callback so
  /// the trigger does not need a BuildContext — a restore finishes on a screen
  /// that is about to stop existing.
  static final ValueNotifier<int> generation = ValueNotifier<int>(0);

  /// Throws the whole app away and builds it again.
  static void restart() => generation.value++;

  @override
  State<FnmRoot> createState() => _FnmRootState();
}

class _FnmRootState extends State<FnmRoot> {
  @override
  Widget build(BuildContext context) => ValueListenableBuilder<int>(
    valueListenable: FnmRoot.generation,
    builder: (_, generation, _) => ProviderScope(
      key: ValueKey(generation),
      child: const FnmApp(),
    ),
  );
}
