import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/config/ui_language.dart';
import 'package:fnm/core/theme/text_size.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

// The language providers live in core so the data layer can read them too;
// re-exported here because Settings is where the rest of the app expects them.
export 'package:fnm/core/config/ui_language.dart'
    show localeProvider, uiLanguageCodeProvider;

/// Prefs key for the sound-and-haptics toggle.
const String _kSoundHapticsKey = 'settings.soundHaptics';

/// Prefs key for the chosen text size (the option's name; absent = normal).
const String _kTextSizeKey = 'settings.textSize';

/// Prefs key for the chosen UI language ('en', 'cs', 'fr', 'it', 'pl', 'es', 'de', 'pt', 'tr', 'nl', 'id', 'el', 'sv', 'nb', 'vi', 'bg', 'da', 'fi', 'hu', 'hr', 'uk', 'fil', 'hi', 'ja', 'ko', 'ro', 'th', 'ms', or absent = follow device).
const String _kLocaleKey = 'settings.locale';

/// The languages the app can be forced to, beyond following the device.
const List<Locale> supportedAppLocales = [
  Locale('en'),
  Locale('cs'),
  Locale('fr'),
  Locale('it'),
  Locale('pl'),
  Locale('es'),
  Locale('de'),
  Locale('pt'),
  Locale('tr'),
  Locale('nl'),
  Locale('id'),
  Locale('el'),
  Locale('sv'),
  Locale('nb'),
  Locale('vi'),
  Locale('bg'),
  Locale('da'),
  Locale('fi'),
  Locale('hu'),
  Locale('hr'),
  Locale('uk'),
  Locale('fil'),
  Locale('hi'),
  Locale('ja'),
  Locale('ko'),
  Locale('ro'),
  Locale('th'),
  Locale('ms'),
];

/// Whether match sound effects and haptics are on (default on). Read across the
/// app; persisted to [SharedPreferences] so it survives relaunches. Loaded once
/// at startup via [loadSettings].
final soundHapticsEnabledProvider = StateProvider<bool>((ref) => true);

/// The manager's chosen text size (default normal), applied app-wide on top of
/// the phone's own text scale. Persisted; loaded at startup via [loadSettings].
final textSizeProvider = StateProvider<TextSize>((ref) => TextSize.normal);

/// [AppLocalizations] for the current UI language, usable WITHOUT a
/// BuildContext — for providers/services that generate user-facing text (board
/// objectives, tournament finishes, news). Resolves like the app itself does:
/// the chosen override, else the device language, falling back to English for
/// any unsupported one.
final appLocalizationsProvider = Provider<AppLocalizations>((ref) {
  return lookupAppLocalizations(Locale(ref.watch(uiLanguageCodeProvider)));
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
  final size = prefs.getString(_kTextSizeKey);
  if (size != null) {
    ref.read(textSizeProvider.notifier).state = TextSize.fromName(size);
  }
}

/// Sets and persists the text size.
Future<void> setTextSize(WidgetRef ref, TextSize size) async {
  ref.read(textSizeProvider.notifier).state = size;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_kTextSizeKey, size.name);
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
