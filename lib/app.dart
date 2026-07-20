import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/services/entitlement/entitlement_service.dart';
import 'package:fnm/features/settings/settings_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// Root application widget: wires theming and routing together.
class FnmApp extends ConsumerStatefulWidget {
  const FnmApp({super.key});

  @override
  ConsumerState<FnmApp> createState() => _FnmAppState();
}

class _FnmAppState extends ConsumerState<FnmApp> {
  @override
  void initState() {
    super.initState();
    // Load the cached premium grant and start listening to the store's
    // purchase stream (buys/restores land there) — safe when offline.
    unawaited(ref.read(entitlementServiceProvider).init());
    // Load persisted settings (sound & haptics) into their providers.
    unawaited(loadSettings(ref));
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Football Nations Manager',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }
}
