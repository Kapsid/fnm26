import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Prefs key for the sound-and-haptics toggle.
const String _kSoundHapticsKey = 'settings.soundHaptics';

/// Prefs key for the chosen UI language ('en', 'cs', or absent = follow device).
const String _kLocaleKey = 'settings.locale';

/// The languages the app can be forced to, beyond following the device.
const List<Locale> supportedAppLocales = [Locale('en'), Locale('cs')];

/// Whether match sound effects and haptics are on (default on). Read across the
/// app; persisted to [SharedPreferences] so it survives relaunches. Loaded once
/// at startup via [loadSettings].
final soundHapticsEnabledProvider = StateProvider<bool>((ref) => true);

/// The UI language override, or null to follow the device locale. Read by the
/// root [MaterialApp]; persisted so a chosen language survives relaunches.
final localeProvider = StateProvider<Locale?>((ref) => null);

/// [AppLocalizations] for the current UI language, usable WITHOUT a
/// BuildContext — for providers/services that generate user-facing text (board
/// objectives, tournament finishes, news). Resolves like the app itself does:
/// the chosen override, else the device language, falling back to English for
/// any unsupported one.
final appLocalizationsProvider = Provider<AppLocalizations>((ref) {
  final override = ref.watch(localeProvider);
  final code = override?.languageCode ??
      WidgetsBinding.instance.platformDispatcher.locale.languageCode;
  return lookupAppLocalizations(
    code == 'cs' ? const Locale('cs') : const Locale('en'),
  );
});

/// Reads the persisted settings into their providers. Call once at app start
/// (safe offline). Absent keys keep the provider defaults.
Future<void> loadSettings(WidgetRef ref) async {
  final prefs = await SharedPreferences.getInstance();
  final v = prefs.getBool(_kSoundHapticsKey);
  if (v != null) {
    ref.read(soundHapticsEnabledProvider.notifier).state = v;
  }
  final code = prefs.getString(_kLocaleKey);
  if (code != null) {
    ref.read(localeProvider.notifier).state = Locale(code);
  }
}

/// Sets and persists the sound-and-haptics toggle.
Future<void> setSoundHaptics(WidgetRef ref, bool enabled) async {
  ref.read(soundHapticsEnabledProvider.notifier).state = enabled;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_kSoundHapticsKey, enabled);
}

/// Sets and persists the UI language. A null [locale] clears the override so the
/// app follows the device language again.
Future<void> setLocale(WidgetRef ref, Locale? locale) async {
  ref.read(localeProvider.notifier).state = locale;
  final prefs = await SharedPreferences.getInstance();
  if (locale == null) {
    await prefs.remove(_kLocaleKey);
  } else {
    await prefs.setString(_kLocaleKey, locale.languageCode);
  }
}
