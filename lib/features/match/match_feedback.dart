import 'package:flutter/services.dart';

/// Sound + haptic cues for live-match moments. Uses only the OS's built-in
/// haptics and system sounds — no audio package or assets — so it's
/// dependency-free and respects the device's silent switch. Every call is a
/// no-op when [enabled] is false (the settings toggle).
abstract final class MatchFeedback {
  /// A goal: a strong buzz and a short alert tone.
  static void goal(bool enabled) {
    if (!enabled) return;
    HapticFeedback.heavyImpact();
    SystemSound.play(SystemSoundType.alert);
  }

  /// Kick-off / restart: a light buzz.
  static void kickoff(bool enabled) {
    if (!enabled) return;
    HapticFeedback.mediumImpact();
  }

  /// The full-time whistle: a buzz and a click.
  static void fullTime(bool enabled) {
    if (!enabled) return;
    HapticFeedback.mediumImpact();
    SystemSound.play(SystemSoundType.click);
  }
}
