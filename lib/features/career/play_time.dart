import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/career/career_providers.dart';

/// Counts the real-world time a manager spends in a save.
///
/// Ticking rather than timing a session end-to-end: a save is left by closing
/// the app as often as by tapping anything, and a crash or a flat battery is
/// not rare enough to lose an evening's play time to. Each tick writes the
/// seconds since the last one, so the most that can ever be lost is a tick.
///
/// The clock only runs while a save is actually open and the app is in the
/// foreground — see [pause] and [stop].
class PlayTimeTracker {
  PlayTimeTracker(this._ref);

  final Ref _ref;

  /// How often the elapsed time is written down.
  static const Duration tick = Duration(seconds: 30);

  /// The most one tick may ever credit.
  ///
  /// A timer does not fire while the device sleeps, so the first tick after a
  /// wake would otherwise credit the whole night. Anything longer than a tick
  /// and a bit is time the manager was not playing.
  static const Duration maxPerTick = Duration(seconds: 45);

  Timer? _timer;
  int? _careerId;
  DateTime? _since;

  /// The save being timed, or null when the clock is not running.
  int? get careerId => _careerId;

  /// Starts (or restarts) the clock on [careerId].
  void start(int careerId) {
    if (_careerId == careerId && _timer != null) return;
    // What the PREVIOUS save is owed, captured before the fields move. The
    // credit itself is fire-and-forget, so it must not read state that this
    // method is about to overwrite — an earlier version called `stop()`
    // unawaited here and its continuation wiped the save just started.
    final owed = _elapsed();
    final previous = _careerId;

    _timer?.cancel();
    _careerId = careerId;
    _since = DateTime.now();
    _timer = Timer.periodic(tick, (_) => unawaited(flush()));

    if (previous != null && owed != null) {
      unawaited(_credit(previous, owed));
    }
  }

  /// Writes down what has been played so far and keeps counting.
  Future<void> flush() async {
    final id = _careerId;
    final owed = _elapsed();
    if (id == null || owed == null) return;
    _since = DateTime.now();
    await _credit(id, owed);
  }

  /// Stops counting while the app is in the background, keeping the save.
  ///
  /// Resuming starts a fresh interval, so the time spent elsewhere on the
  /// phone is not counted as time spent playing.
  Future<void> pause() async {
    _timer?.cancel();
    _timer = null;
    final id = _careerId;
    final owed = _elapsed();
    _since = null;
    if (id != null && owed != null) await _credit(id, owed);
  }

  /// Picks the clock back up on the same save.
  void resume() {
    if (_careerId == null || _timer != null) return;
    _since = DateTime.now();
    _timer = Timer.periodic(tick, (_) => unawaited(flush()));
  }

  /// Stops the clock and writes down the last of it — the save is closed.
  Future<void> stop() async {
    _timer?.cancel();
    _timer = null;
    final id = _careerId;
    final owed = _elapsed();
    _careerId = null;
    _since = null;
    if (id != null && owed != null) await _credit(id, owed);
  }

  /// How long the clock has been running, capped at [maxPerTick], or null when
  /// it is not running or has nothing whole to report.
  ///
  /// A negative span means the device clock moved backwards; nothing is
  /// credited rather than time already played being taken away.
  Duration? _elapsed() {
    final since = _since;
    if (since == null) return null;
    final elapsed = DateTime.now().difference(since);
    if (elapsed.isNegative || elapsed.inSeconds <= 0) return null;
    return elapsed > maxPerTick ? maxPerTick : elapsed;
  }

  Future<void> _credit(int careerId, Duration played) async {
    await _ref
        .read(careerRepositoryProvider)
        .addPlayedSeconds(careerId, played.inSeconds);
    _ref.invalidate(savesProvider);
  }
}

final Provider<PlayTimeTracker> playTimeTrackerProvider =
    Provider<PlayTimeTracker>((ref) {
      final tracker = PlayTimeTracker(ref);
      ref.onDispose(() => unawaited(tracker.stop()));
      return tracker;
    });
