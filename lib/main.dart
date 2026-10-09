import 'dart:async';
import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/app.dart';
import 'package:fnm/core/diagnostics/app_log.dart';
import 'package:fnm/core/layout/form_factor.dart';
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
      // The form factor is read once, before anything is built: the router's
      // shape depends on it, and a tablet is held in landscape so it will not
      // change under us. It comes from the physical DISPLAY, not the window:
      // an iPad held in portrait at launch letterboxes the landscape-only app
      // into a window under 600 logical px, which would wrongly read as a
      // phone for the whole session. The window is only the fallback when the
      // display size is unavailable.
      final dispatcher = PlatformDispatcher.instance;
      final display = logicalDisplaySizeOf(dispatcher);
      final formFactor = formFactorAtStartup(
        display: display,
        window: display.isEmpty
            ? await firstLogicalWindowSize(dispatcher)
            : Size.zero,
      );
      if (formFactor == FormFactor.tablet) {
        await SystemChrome.setPreferredOrientations(const [
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      }
      runApp(FnmRoot(formFactor: formFactor));
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
  const FnmRoot({this.formFactor = FormFactor.phone, super.key});

  /// Detected at startup; survives [restart], which rebuilds the scope.
  final FormFactor formFactor;

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
      overrides: [formFactorProvider.overrideWithValue(widget.formFactor)],
      child: const FnmApp(),
    ),
  );
}
