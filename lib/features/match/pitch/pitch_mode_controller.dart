/// The match screen's Pitch mode, apart from the screen: the picture, the
/// clock that plays it, building it (off the UI thread) and reading the
/// match off the clock. The screen keeps the rules of the match (the
/// intervals, the goal flash, the injuries, full time) and asks this what
/// the picture says. The phone layout uses it now; the tablet's will too.
library;

import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/pitch/pitch_script.dart';
import 'package:fnm/domain/services/match/pitch/story_layer.dart';
import 'package:fnm/features/match/pitch/pitch_clock.dart';
import 'package:fnm/features/match/pitch/pitch_playback.dart';
import 'package:fnm/features/match/pitch/pitch_view_providers.dart';

/// An event as the screen recognises it across re-simulations: a re-sim
/// replays every minute already shown identically, but hands out new
/// objects.
typedef MatchEventKey = (MatchEventType, int, int, int, int);

MatchEventKey matchEventKey(MatchEvent e) =>
    (e.type, e.minute, e.stoppage, e.teamNationId, e.playerId);

/// Everything one build of the picture needs. Plain data, so it can be sent
/// to another isolate; [run] builds it there (the pacer is made where the
/// script is, because it keys a map on the moments' identity).
class PitchBuild {
  const PitchBuild({
    required this.result,
    required this.lineups,
    required this.speedStep,
    required this.seed,
    required this.isFinal,
    this.resume,
  });

  final MatchResult result;
  final MatchLineups lineups;
  final int speedStep;
  final int seed;
  final bool isFinal;

  /// Where the old picture stood, to tell the new one from (a re-sim or a
  /// new speed); null to tell it from kick-off.
  final ScriptState? resume;

  PitchPlayback run() => PitchPlayback.build(
    result: result,
    lineups: lineups,
    speed: pitchSpeedForStep(speedStep),
    seed: seed,
    isFinal: isFinal,
    resumeState: resume,
  );
}

/// Builds a picture. The app's runs off the UI thread; tests may run it in
/// place.
typedef PitchPlaybackBuilder = Future<PitchPlayback> Function(PitchBuild b);

/// A full build costs about 340 ms on a desktop (a resumed one about 170 ms;
/// see `script_build_cost_test`), far more than a frame, so it runs on
/// another isolate and the screen keeps the old picture until it is in.
final Provider<PitchPlaybackBuilder> pitchPlaybackBuilderProvider =
    Provider<PitchPlaybackBuilder>(
      (ref) =>
          (b) => Isolate.run(b.run),
    );

/// The match screen's Pitch mode: see the library comment.
class PitchModeController {
  PitchModeController({
    required TickerProvider vsync,
    required PitchPlaybackBuilder builder,
    required void Function() onTick,
  }) : _vsync = vsync,
       _builder = builder,
       _onTick = onTick;

  final TickerProvider _vsync;
  final PitchPlaybackBuilder _builder;
  final void Function() _onTick;

  PitchPlayback? _playback;
  PitchClock? _clock;
  MatchResult? _builtFor;
  int _builtSpeed = -1;
  int _generation = 0;
  bool _building = false;
  bool _fresh = false;
  bool _busy = false;
  bool _disposed = false;
  Duration _lastT = Duration.zero;

  /// The ground and the names, made once per match by the screen.
  PitchStadium? stadium;
  Map<int, String> names = const {};

  /// The picture on show (the old one while a new one is built).
  PitchPlayback? get playback => _playback;
  PitchClock? get clock => _clock;

  /// A new picture is being built: the clock is held.
  bool get building => _building;

  /// A picture told from kick-off is being built, so the one on show (if
  /// any) belongs to another moment of the match and must not be drawn.
  bool get buildingFresh => _building && _fresh;

  /// Whether the picture on show is the one for [result] at [speedStep].
  bool isCurrentFor(MatchResult result, int speedStep) =>
      _playback != null &&
      !_building &&
      identical(_builtFor, result) &&
      _builtSpeed == speedStep;

  /// Builds the picture for [result] at [speedStep] off the UI thread,
  /// holding the clock meanwhile. With [resume] it is told from where the
  /// clock stands now and the clock is put on its start (the same match
  /// position, never back); otherwise it is told from kick-off and the
  /// clock goes to [place] (asked once it is built). Returns whether this
  /// build is the one now on show (a later call supersedes it).
  Future<bool> build({
    required MatchResult result,
    required MatchLineups lineups,
    required int speedStep,
    required int seed,
    required bool isFinal,
    required bool resume,
    required Duration Function(PitchPlayback pb) place,
  }) async {
    final generation = ++_generation;
    final old = _playback;
    final clock = _clock;
    clock?.pause();
    final state = resume && old != null && clock != null
        ? old.script.stateAt(clock.value)
        : null;
    _building = true;
    _fresh = state == null;
    final job = PitchBuild(
      result: result,
      lineups: lineups,
      speedStep: speedStep,
      seed: seed,
      isFinal: isFinal,
      resume: state,
    );
    PitchPlayback pb;
    try {
      pb = await _builder(job);
    } on Object catch (e, st) {
      // The worker failed (an isolate that could not start, or one that
      // died): build in place rather than leave the pitch on its spinner.
      debugPrint('Pitch script build off the UI thread failed: $e\n$st');
      if (_disposed || generation != _generation) return false;
      pb = job.run();
    }
    if (_disposed || generation != _generation) return false;
    _building = false;
    _playback = pb;
    _builtFor = result;
    _builtSpeed = speedStep;
    final c =
        _clock ??
        (_clock = PitchClock(vsync: _vsync, pacer: pb.pacer)
          ..addListener(_listen));
    _busy = true;
    c
      ..pause()
      ..pacer = pb.pacer;
    _busy = false;
    jump(state != null ? pb.start : place(pb));
    return true;
  }

  void _listen() {
    if (!_busy && !_building) _onTick();
  }

  /// Moves the clock to [t] without it reading as play: nothing between
  /// here and there stops it (see [dueStop]).
  void jump(Duration t) {
    final c = _clock;
    if (c == null) return;
    _busy = true;
    c.seek(t);
    _busy = false;
    _lastT = c.value;
  }

  /// Where the clock stood when the screen last read it.
  Duration get lastRead => _lastT;

  /// The screen has read the clock where it stands.
  void markRead() => _lastT = _clock?.value ?? Duration.zero;

  /// The first of [whistles] (screen times, taken or not) that play has
  /// reached at [t] and is not taken yet.
  static Duration? dueWhistle(Duration t, List<(Duration?, bool)> whistles) {
    for (final (at, taken) in whistles) {
      if (at != null && !taken && t >= at) return at;
    }
    return null;
  }

  /// The screen time of the first event that stops play ([stops]: a goal,
  /// an injury to one of the manager's own, not yet shown) that play has
  /// run past since the clock was last read, however long the frame was.
  /// A [jump] is not play and stops nowhere.
  Duration? dueStop(Duration t, bool Function(MatchEvent e) stops) {
    final pb = _playback;
    if (pb == null || t <= _lastT) return null;
    final events = pb.result.events;
    double? first;
    for (var i = 0; i < events.length; i++) {
      if (!pb.shown(i, t) || !stops(events[i])) continue;
      final at = pb.revealAt(i);
      if (first == null || at < first) first = at;
    }
    if (first == null) return null;
    final stop = Duration(microseconds: (first * 1e6).ceil());
    return stop < t ? stop : null;
  }

  /// The match position at the clock and the events of that minute the
  /// picture has not shown yet. Within the minute the screen is on
  /// ([minute], [added]), what it has shown ([held] no longer holds) stays
  /// shown, whatever a re-sim's new picture times it at.
  ({int minute, int added, Set<MatchEventKey> held}) read({
    required int minute,
    required int added,
    required Set<MatchEventKey> held,
  }) {
    final pb = _playback!;
    final t = _clock!.value;
    final pos = pb.positionAt(t);
    final events = pb.result.events;
    final now = <MatchEventKey>{};
    for (var i = 0; i < events.length; i++) {
      final e = events[i];
      if (e.minute == pos.minute &&
          e.stoppage == pos.added &&
          !pb.shown(i, t)) {
        now.add(matchEventKey(e));
      }
    }
    if (pos.minute == minute && pos.added == added) {
      now.retainWhere(held.contains);
    }
    return (minute: pos.minute, added: pos.added, held: now);
  }

  void dispose() {
    _disposed = true;
    _clock
      ?..removeListener(_listen)
      ..dispose();
  }
}
