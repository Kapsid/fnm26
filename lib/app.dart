import 'dart:async';

import 'dart:ui' show AppExitResponse;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/routing/back_navigation.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/core/theme/text_size.dart';
import 'package:fnm/domain/services/cloud/cloud_backup_policy.dart';
import 'package:fnm/domain/services/entitlement/entitlement_service.dart';
import 'package:fnm/features/career/play_time.dart';
import 'package:fnm/features/cloud/cloud_backup_providers.dart';
import 'package:fnm/features/onboarding/tour_overlay.dart';
import 'package:fnm/features/onboarding/tour_providers.dart';
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

  /// Android's back button, heard ahead of the router.
  SystemBackHandler? _back;

  @override
  void initState() {
    super.initState();
    // Load the cached premium grant and start listening to the store's
    // purchase stream (buys/restores land there) — safe when offline.
    unawaited(ref.read(entitlementServiceProvider).init());
    // Load persisted settings (sound & haptics) into their providers.
    unawaited(loadSettings(ref));
    // Whether the walk through has ever been offered — see [loadTourOffered],
    // which defaults to "already offered" so a slow read cannot flash the
    // question at somebody who answered it long ago.
    unawaited(loadTourOffered(ref));
    // The backup bookkeeping (last backup, the automatic toggle, reminders).
    unawaited(ref.read(backupSettingsProvider.notifier).ensureLoaded());
    // After a restore, automatic uploads wait until the restored saves have
    // opened and checked out.
    unawaited(ref.read(cloudBackupServiceProvider).confirmHealthyStart());
    // Time spent with the phone in a pocket is not time spent playing, so the
    // play clock stops with the app and picks up again when it comes back.
    _lifecycle = AppLifecycleListener(
      onPause: () {
        unawaited(ref.read(playTimeTrackerProvider).pause());
        // The likeliest last moment before the phone is put away: an
        // automatic cloud backup if one is on, due and anything changed.
        unawaited(
          ref.read(cloudBackupServiceProvider).trigger(
            BackupTrigger.appBackground,
          ),
        );
      },
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

  void _watchBack(GoRouter router) {
    if (_back != null) return;
    _back = SystemBackHandler(router)..attach();
  }

  @override
  void dispose() {
    _back?.dispose();
    _routeListener?.call();
    _lifecycle?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    _watchRoute(router);
    _watchBack(router);
    // A null override follows the device language; a chosen language wins.
    final locale = ref.watch(localeProvider);
    final textSize = ref.watch(textSizeProvider);

    return MaterialApp.router(
      title: 'Football Nations Manager',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
      // Tells Android back goes somewhere on every screen but home: see
      // [SystemBackHandler].
      onNavigationNotification: _back!.onNavigationNotification,
      // The tour draws over whatever screen it has navigated to, so it wraps
      // the router's output rather than living on any one screen. The chosen
      // text size wraps both, so the tour's own copy grows with the rest.
      builder: (context, child) => AppTextScale(
        size: textSize,
        child: TourOverlay(child: child ?? const SizedBox.shrink()),
      ),
    );
  }
}
