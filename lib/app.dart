import 'dart:async';

import 'dart:ui' show AppExitResponse;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/services/entitlement/entitlement_service.dart';
import 'package:fnm/features/career/play_time.dart';
import 'package:fnm/features/settings/settings_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

/// Root application widget: wires theming and routing together.
class FnmApp extends ConsumerStatefulWidget {
  const FnmApp({super.key});

  @override
  ConsumerState<FnmApp> createState() => _FnmAppState();
}

class _FnmAppState extends ConsumerState<FnmApp> {
  AppLifecycleListener? _lifecycle;

  /// Removes the route listener again — see [_watchRoute].
  VoidCallback? _routeListener;

  @override
  void initState() {
    super.initState();
    // Load the cached premium grant and start listening to the store's
    // purchase stream (buys/restores land there) — safe when offline.
    unawaited(ref.read(entitlementServiceProvider).init());
    // Load persisted settings (sound & haptics) into their providers.
    unawaited(loadSettings(ref));
    // Time spent with the phone in a pocket is not time spent playing, so the
    // play clock stops with the app and picks up again when it comes back.
    _lifecycle = AppLifecycleListener(
      onPause: () => unawaited(ref.read(playTimeTrackerProvider).pause()),
      onResume: () => ref.read(playTimeTrackerProvider).resume(),
      // The last chance to write down the current session on a graceful exit;
      // an ungraceful one loses at most a tick, by design.
      onExitRequested: () async {
        await ref.read(playTimeTrackerProvider).flush();
        return AppExitResponse.exit;
      },
    );
  }

  /// Stops the play clock the moment the manager is no longer in a save.
  ///
  /// Every in-save route carries `?careerId=`; the home, saves, settings and
  /// new-game screens do not. Without this the clock would keep running while
  /// the app sat on the saves list, and the number it shows there would be the
  /// one thing on the screen that was wrong.
  void _watchRoute(GoRouter router) {
    if (_routeListener != null) return;
    final information = router.routeInformationProvider;
    void onRoute() {
      final inSave = information.value.uri.queryParameters.containsKey(
        'careerId',
      );
      if (!inSave) unawaited(ref.read(playTimeTrackerProvider).stop());
    }

    information.addListener(onRoute);
    _routeListener = () => information.removeListener(onRoute);
  }

  @override
  void dispose() {
    _routeListener?.call();
    _lifecycle?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    _watchRoute(router);
    // A null override follows the device language; a chosen language wins.
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'Football Nations Manager',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }
}
