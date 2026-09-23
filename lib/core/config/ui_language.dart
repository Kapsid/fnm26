import 'dart:ui' show Locale, PlatformDispatcher;

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The language the app is drawn in.
///
/// It lives in core rather than with the rest of the settings because the DATA
/// layer needs it: nation names are written for the current language as they
/// are read out of the database, so every screen, every news item and every
/// social post gets them right without each one having to ask.

/// The UI language override, or null to follow the device locale. Read by the
/// root `MaterialApp`; persisted so a chosen language survives relaunches.
final localeProvider = StateProvider<Locale?>((ref) => null);

/// The two-letter language the app is currently drawn in — the override if the
/// manager has set one, else the device's, falling back to English for any
/// language the app does not speak.
///
/// Read straight off [PlatformDispatcher], not off `WidgetsBinding.instance`:
/// the data layer depends on this now, and a plain VM unit test builds
/// repositories without ever initialising a widgets binding.
final uiLanguageCodeProvider = Provider<String>((ref) {
  final override = ref.watch(localeProvider);
  final code =
      override?.languageCode ?? PlatformDispatcher.instance.locale.languageCode;
  return code == 'cs' ? 'cs' : 'en';
});
