import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Prefs key for the sound-and-haptics toggle.
const String _kSoundHapticsKey = 'settings.soundHaptics';

/// Whether match sound effects and haptics are on (default on). Read across the
/// app; persisted to [SharedPreferences] so it survives relaunches. Loaded once
/// at startup via [loadSettings].
final soundHapticsEnabledProvider = StateProvider<bool>((ref) => true);

/// Reads the persisted settings into their providers. Call once at app start
/// (safe offline). Absent keys keep the provider defaults.
Future<void> loadSettings(WidgetRef ref) async {
  final prefs = await SharedPreferences.getInstance();
  final v = prefs.getBool(_kSoundHapticsKey);
  if (v != null) {
    ref.read(soundHapticsEnabledProvider.notifier).state = v;
  }
}

/// Sets and persists the sound-and-haptics toggle.
Future<void> setSoundHaptics(WidgetRef ref, bool enabled) async {
  ref.read(soundHapticsEnabledProvider.notifier).state = enabled;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_kSoundHapticsKey, enabled);
}
