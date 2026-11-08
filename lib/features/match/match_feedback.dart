import 'dart:async';

import 'package:flutter/services.dart';

/// Sound + haptic cues for live-match moments. Uses only the OS's built-in
/// haptics and system sounds — no audio package or assets — so it's
/// dependency-free and respects the device's silent switch. Every call is a
/// no-op when [enabled] is false (the settings toggle).
abstract final class MatchFeedback {
  /// How long after a goal's buzz its heavy impact follows.
  static const Duration goalImpactDelay = Duration(milliseconds: 120);

  static Timer? _goalImpact;

  /// A goal: a full buzz, a heavy impact [goalImpactDelay] after it, and a
  /// short alert tone (desktop only; phones ignore it).
  ///
  /// The buzz is `HapticFeedback.vibrate`, on iOS the audio services'
  /// vibrate: no feedback generator to drop. `heavyImpact` alone, a fresh
  /// unprepared `UIImpactFeedbackGenerator` on iOS, went missing on an
  /// iPhone under the 2D TV's rendering while the Timeline's was felt. The
  /// impact still follows, so a goal feels like one on a phone that
  /// honours impacts.
  static void goal(bool enabled) {
    if (!enabled) return;
    HapticFeedback.vibrate();
    _goalImpact?.cancel();
    _goalImpact = Timer(goalImpactDelay, () {
      _goalImpact = null;
      HapticFeedback.heavyImpact();
    });
    SystemSound.play(SystemSoundType.alert);
  }

  /// Drops a goal's impact still to come: the match screen is going away.
  static void cancelPending() {
    _goalImpact?.cancel();
    _goalImpact = null;
  }

  /// Kick-off / restart: a light buzz.
  static void kickoff(bool enabled) {
    if (!enabled) return;
    HapticFeedback.mediumImpact();
  }

  /// A sending-off on the 2D TV: a lighter buzz than a goal's.
  static void redCard(bool enabled) {
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
