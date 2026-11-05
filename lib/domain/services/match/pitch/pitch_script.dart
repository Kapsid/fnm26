/// What the Pitch view draws, as a function of screen time: every player's
/// position, the ball, the name tags and the camera. Built by the story layer
/// (and, inside staged moments, by the stagers); sampled by the renderer.
/// Pure Dart.
library;

import 'dart:math' as math;
import 'dart:typed_data';

import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_moments.dart';
import 'package:fnm/domain/services/match/pitch/pitch_geometry.dart';
import 'package:fnm/domain/services/match/pitch/pitch_pacer.dart';

/// One man who appears on the pitch at some point of the match.
typedef PitchActor = ({int playerId, int teamNationId, int shirt, bool keeper});

/// Where the camera looks: the pitch x it centres on, and how far in it is
/// (1 = the whole pitch's width fills the view).
typedef PitchCamera = ({double centreX, double zoom});

/// How far ahead of a carrier's feet the ball sits, in metres.
const double ballLead = 0.6;

/// One sampled moment of the picture.
class PitchFrame {
  const PitchFrame({
    required this.players,
    required this.facing,
    required this.ball,
    required this.ballHeight,
    required this.ballCarrierId,
    required this.tagged,
    required this.camera,
  });

  /// Every player on the pitch (walking off included), by player id.
  final Map<int, Offset2> players;

  /// Which way each player in [players] faces, in radians (0 = toward +x).
  final Map<int, double> facing;
  final Offset2 ball;

  /// The ball's height above the grass, in metres (0 on the ground).
  final double ballHeight;

  /// The player with the ball at his feet, or null while it is in flight.
  final int? ballCarrierId;

  /// The players whose name tags show.
  final List<int> tagged;
  final PitchCamera camera;
}

/// A recorded instant: each actor's position and facing, indexed like
/// [PitchScript.actorList]. An absent actor has NaN coordinates.
class ScriptKeyframe {
  ScriptKeyframe({
    required this.t,
    required this.xs,
    required this.ys,
    required this.facing,
    required this.cameraX,
    required this.zoom,
  });

  /// Screen seconds.
  final double t;
  final Float64List xs;
  final Float64List ys;
  final Float64List facing;
  final double cameraX;
  final double zoom;

  bool present(int actor) => !xs[actor].isNaN;
  Offset2 at(int actor) => Offset2(xs[actor], ys[actor]);
}

/// What the ball is doing over [t0, t1) screen seconds. Consecutive phases
/// meet end to start and together cover the whole match.
sealed class BallPhase {
  const BallPhase(this.t0, this.t1);
  final double t0;
  final double t1;
}

/// The ball at a player's feet, [ballLead] ahead of him.
final class CarryPhase extends BallPhase {
  const CarryPhase(super.t0, super.t1, this.carrier);

  /// Index into [PitchScript.actorList].
  final int carrier;
}

/// The ball travelling in a straight line from [from] to [to], rising to
/// [peak] metres halfway when lofted.
final class FlightPhase extends BallPhase {
  const FlightPhase(
    super.t0,
    super.t1, {
    required this.from,
    required this.to,
    required this.peak,
    this.fromActor,
    this.toActor,
  });

  final Offset2 from;
  final Offset2 to;
  final double peak;

  /// The passer and the receiver, as indexes into [PitchScript.actorList].
  final int? fromActor;
  final int? toActor;
}

/// The live state at one instant, as a stager sees it: who is where, and who
/// has the ball.
class ScriptState {
  const ScriptState({
    required this.t,
    required this.players,
    required this.ball,
    required this.carrierId,
    required this.possessionNationId,
  });

  /// Screen seconds.
  final double t;
  final Map<int, Offset2> players;
  final Offset2 ball;

  /// The player with the ball at his feet; null while it is in flight.
  final int? carrierId;

  /// The side last in control of the ball.
  final int possessionNationId;
}

/// One staged-moment window: the gap the story layer leaves for a real
/// moment (see `PitchPacer.momentLength`), with the state it hands over at
/// [start] and the state it resumes from at [end].
class StagedWindow {
  StagedWindow({
    required this.start,
    required this.end,
    required this.moments,
    this.injury,
  });

  /// Screen seconds.
  final double start;
  final double end;

  /// The moment staged here, followed by any zero-length moment folded into
  /// it (a set piece's shot). Empty for an injury.
  final List<MatchMoment> moments;

  /// The injury staged here, when this window is one.
  final MatchEvent? injury;

  late ScriptState entry;
  late ScriptState exit;
}

/// A whole match's picture.
class PitchScript {
  PitchScript({
    required this.actorList,
    required this.keyframes,
    required this.ballPhases,
    required this.resets,
    required this.windows,
    required this.departures,
    required this.arrivals,
    required this.pacer,
    required this.result,
    required this.homeNationId,
  }) : _index = {
         for (var i = 0; i < actorList.length; i++) actorList[i].playerId: i,
       };

  final List<PitchActor> actorList;
  final List<ScriptKeyframe> keyframes;
  final List<BallPhase> ballPhases;

  /// Screen seconds at which play restarts from a kick-off with the sides
  /// lined up afresh (the second half, extra time). The picture jumps there;
  /// the screen pauses for the interval.
  final List<double> resets;
  final List<StagedWindow> windows;

  /// Player id -> the screen second he starts walking off. He is gone
  /// [walkOffSeconds] later.
  final Map<int, double> departures;

  /// Player id -> the screen second a substitute steps on.
  final Map<int, double> arrivals;
  final PitchPacer pacer;
  final MatchResult result;
  final int homeNationId;
  final Map<int, int> _index;

  /// How long a player takes to walk off.
  static const double walkOffSeconds = 2;

  double get totalSeconds => pacer.total.inMicroseconds / 1e6;

  int? actorIndexOf(int playerId) => _index[playerId];

  /// The men on the pitch (walking off included) at the start of [minute]
  /// (+[stoppage]).
  List<PitchActor> actors(int minute, {int stoppage = 0}) {
    final t = pacer.screenAt(minute, stoppage).inMicroseconds / 1e6;
    final k = _frameAt(t);
    return [
      for (var i = 0; i < actorList.length; i++)
        if (_presentAt(i, k, t)) actorList[i],
    ];
  }

  /// The picture at [screen].
  PitchFrame sample(Duration screen) {
    final t = (screen.inMicroseconds / 1e6).clamp(0.0, totalSeconds);
    final k = _frameAt(t);
    final a = keyframes[k];
    final b = k + 1 < keyframes.length ? keyframes[k + 1] : a;
    final u = b.t > a.t ? ((t - a.t) / (b.t - a.t)).clamp(0.0, 1.0) : 0.0;
    final players = <int, Offset2>{};
    final facing = <int, double>{};
    for (var i = 0; i < actorList.length; i++) {
      if (!_presentAt(i, k, t)) continue;
      final id = actorList[i].playerId;
      players[id] = b.present(i) ? Offset2.lerp(a.at(i), b.at(i), u) : a.at(i);
      facing[id] = b.present(i)
          ? _lerpAngle(a.facing[i], b.facing[i], u)
          : a.facing[i];
    }
    final phase = _phaseAt(t);
    final (ball, height) = ballAt(t, phase: phase);
    final int? carrier;
    final List<int> tagged;
    switch (phase) {
      case CarryPhase(carrier: final ci):
        carrier = actorList[ci].playerId;
        tagged = [carrier];
      case FlightPhase(:final toActor):
        carrier = null;
        tagged = [if (toActor != null) actorList[toActor].playerId];
    }
    return PitchFrame(
      players: players,
      facing: facing,
      ball: ball,
      ballHeight: height,
      ballCarrierId: carrier,
      tagged: tagged,
      camera: (
        centreX: a.cameraX + (b.cameraX - a.cameraX) * u,
        zoom: a.zoom + (b.zoom - a.zoom) * u,
      ),
    );
  }

  /// The ball's position and height at screen second [t].
  (Offset2, double) ballAt(double t, {BallPhase? phase}) {
    final p = phase ?? _phaseAt(t);
    switch (p) {
      case CarryPhase(carrier: final ci):
        final (pos, face) = actorAt(ci, t);
        return (pos + Offset2.fromAngle(face, ballLead), 0);
      case FlightPhase(:final from, :final to, :final peak):
        final len = p.t1 - p.t0;
        final u = len <= 0 ? 1.0 : ((t - p.t0) / len).clamp(0.0, 1.0);
        return (Offset2.lerp(from, to, u), 4 * peak * u * (1 - u));
    }
  }

  /// Actor [i]'s interpolated position and facing at [t] (his last known
  /// ones when he is absent).
  (Offset2, double) actorAt(int i, double t) {
    final k = _frameAt(t);
    final a = keyframes[k];
    final b = k + 1 < keyframes.length ? keyframes[k + 1] : a;
    if (!a.present(i) || !b.present(i) || b.t <= a.t) {
      return (a.at(i), a.facing[i]);
    }
    final u = ((t - a.t) / (b.t - a.t)).clamp(0.0, 1.0);
    return (
      Offset2.lerp(a.at(i), b.at(i), u),
      _lerpAngle(a.facing[i], b.facing[i], u),
    );
  }

  /// "37" or "90+2": the match minute screen second [t] falls in.
  String minuteLabel(double t) {
    final m = pacer.matchAt(Duration(microseconds: (t * 1e6).round()));
    return m.stoppage > 0 ? '${m.minute}+${m.stoppage}' : '${m.minute}';
  }

  bool _presentAt(int i, int k, double t) {
    final a = keyframes[k];
    if (!a.present(i)) return false;
    if (t <= a.t || k + 1 >= keyframes.length) return true;
    return keyframes[k + 1].present(i);
  }

  /// The last keyframe at or before [t].
  int _frameAt(double t) {
    var lo = 0;
    var hi = keyframes.length - 1;
    while (lo < hi) {
      final mid = (lo + hi + 1) ~/ 2;
      if (keyframes[mid].t <= t) {
        lo = mid;
      } else {
        hi = mid - 1;
      }
    }
    return lo;
  }

  BallPhase _phaseAt(double t) {
    var lo = 0;
    var hi = ballPhases.length - 1;
    while (lo < hi) {
      final mid = (lo + hi + 1) ~/ 2;
      if (ballPhases[mid].t0 <= t) {
        lo = mid;
      } else {
        hi = mid - 1;
      }
    }
    return ballPhases[lo];
  }

  static double _lerpAngle(double a, double b, double u) {
    var d = (b - a) % (2 * math.pi);
    if (d > math.pi) d -= 2 * math.pi;
    if (d < -math.pi) d += 2 * math.pi;
    return a + d * u;
  }
}

/// Checks a whole [PitchScript] against the Pitch view's invariants and says
/// what it finds in words, e.g. "minute 37: player 812 moved 14.2 m/s".
abstract final class PitchScriptValidator {
  static const double maxPlayerSpeed = 9;
  static const double maxBallSpeed = 35;
  static const double minGap = 0.8;
  static const double keeperReach = 25;
  static const double minPass = 6;

  /// Every violation in [s]; empty when it keeps every invariant. Stops
  /// after [limit] findings.
  static List<String> validate(PitchScript s, {int limit = 50}) {
    final out = <String>[];
    void add(double t, String what) {
      if (out.length < limit) out.add('minute ${s.minuteLabel(t)}: $what');
    }

    final frames = s.keyframes;
    final n = s.actorList.length;
    final resets = s.resets.toSet();
    bool inWindow(double t) =>
        s.windows.any((w) => t >= w.start - 1e-9 && t < w.end - 1e-9);

    for (var k = 0; k < frames.length; k++) {
      final a = frames[k];
      // At most eleven a side.
      final count = <int, int>{};
      for (var i = 0; i < n; i++) {
        if (!a.present(i)) continue;
        final team = s.actorList[i].teamNationId;
        count[team] = (count[team] ?? 0) + 1;
      }
      count.forEach((team, c) {
        if (c > 11) add(a.t, 'team $team has $c players on the pitch');
      });
      // Keepers near their own goal in open play. A keyframe followed by
      // another at the same instant is the last of the period before a
      // kick-off, so it is judged by that period's ends.
      final last = k + 1 < frames.length && frames[k + 1].t <= a.t + 1e-9;
      if (!inWindow(a.t)) {
        final m = s.pacer.matchAt(
          Duration(microseconds: ((last ? a.t - 1e-3 : a.t) * 1e6).round()),
        );
        for (var i = 0; i < n; i++) {
          final actor = s.actorList[i];
          if (!actor.keeper || !a.present(i)) continue;
          final dir = attackDir(
            home: actor.teamNationId == s.homeNationId,
            minute: m.minute,
          );
          final depth = xToDepth(a.xs[i], dir);
          if (depth > keeperReach + 1e-6) {
            add(
              a.t,
              'keeper ${actor.playerId} ${depth.toStringAsFixed(1)} m '
              'from his goal line',
            );
          }
        }
      }
      if (k + 1 >= frames.length) continue;
      final b = frames[k + 1];
      final dt = b.t - a.t;
      if (dt < 0) add(a.t, 'keyframes out of order');
      if (dt <= 1e-9) {
        if (!resets.contains(b.t)) add(a.t, 'the picture jumps (no kick-off)');
        continue;
      }
      for (var i = 0; i < n; i++) {
        if (!a.present(i) || !b.present(i)) continue;
        final v = a.at(i).distanceTo(b.at(i)) / dt;
        if (v > maxPlayerSpeed + 1e-6) {
          add(
            a.t,
            'player ${s.actorList[i].playerId} moved '
            '${v.toStringAsFixed(1)} m/s',
          );
        }
        for (var j = i + 1; j < n; j++) {
          if (!a.present(j) || !b.present(j)) continue;
          final d = closestApproach(a.at(i), b.at(i), a.at(j), b.at(j));
          if (d < minGap - 1e-6) {
            add(
              a.t,
              'players ${s.actorList[i].playerId} and '
              '${s.actorList[j].playerId} ${d.toStringAsFixed(2)} m apart',
            );
          }
        }
      }
    }

    // Departures: gone after the walk, and only after his minute.
    final eventTime = <int, double>{};
    for (final e in s.result.events) {
      final id = switch (e.type) {
        MatchEventType.redCard || MatchEventType.injury => e.playerId,
        MatchEventType.substitution => e.secondaryPlayerId,
        _ => null,
      };
      if (id == null) continue;
      final at = s.pacer.screenAt(e.minute, e.stoppage).inMicroseconds / 1e6;
      eventTime[id] = math.min(eventTime[id] ?? at, at);
      if (!s.departures.containsKey(id) && s.actorIndexOf(id) != null) {
        add(eventTime[id]!, 'player $id never leaves the pitch');
      }
    }
    s.departures.forEach((id, start) {
      final i = s.actorIndexOf(id);
      if (i == null) return;
      final at = eventTime[id];
      if (at != null && start < at - 1e-6) {
        add(start, 'player $id leaves before his minute');
      }
      final gone = start + PitchScript.walkOffSeconds;
      for (final f in frames) {
        if (f.t > gone + 1e-6 && f.present(i)) {
          add(f.t, 'player $id still on the pitch after leaving');
          break;
        }
      }
    });

    // The ball: always carried or in flight, and never teleporting.
    final phases = s.ballPhases;
    if (phases.isEmpty || phases.first.t0 > 1e-9) {
      add(0, 'the ball has no phase at kick-off');
    }
    for (var p = 0; p < phases.length; p++) {
      final ph = phases[p];
      if (p + 1 < phases.length && (phases[p + 1].t0 - ph.t1).abs() > 1e-6) {
        add(ph.t1, 'the ball has no phase between two of its phases');
      }
      switch (ph) {
        case CarryPhase(carrier: final ci):
          final f = frames[s._frameAt(ph.t0)];
          if (!f.present(ci)) {
            add(ph.t0, 'the ball is carried by a player not on the pitch');
          }
        case FlightPhase(:final from, :final to, :final toActor):
          final d = from.distanceTo(to);
          final len = ph.t1 - ph.t0;
          if (toActor != null && d < minPass - 1e-6) {
            add(ph.t0, 'a pass of ${d.toStringAsFixed(1)} m');
          }
          if (len > 0 && d / len > maxBallSpeed + 1e-6) {
            add(ph.t0, 'the ball flew ${(d / len).toStringAsFixed(1)} m/s');
          }
      }
    }
    if (phases.isNotEmpty && (phases.last.t1 - s.totalSeconds).abs() > 1e-6) {
      add(phases.last.t1, "the ball's phases stop before the end");
    }
    const step = 1 / 50;
    final total = s.totalSeconds;
    var prev = s.ballAt(0).$1;
    var prevT = 0.0;
    final resetList = [...s.resets]..sort();
    var r = 0;
    for (var t = step; t <= total + 1e-9; t += step) {
      final now = s.ballAt(t).$1;
      var crossed = false;
      while (r < resetList.length && resetList[r] <= t) {
        if (resetList[r] > prevT) crossed = true;
        r++;
      }
      if (!crossed) {
        final v = prev.distanceTo(now) / (t - prevT);
        if (v > maxBallSpeed + 1e-6) {
          add(t, 'the ball jumped at ${v.toStringAsFixed(1)} m/s');
        }
      }
      prev = now;
      prevT = t;
    }
    return out;
  }

  /// The least distance between two points moving in straight lines from
  /// [a0] to [a1] and [b0] to [b1] over the same interval.
  static double closestApproach(
    Offset2 a0,
    Offset2 a1,
    Offset2 b0,
    Offset2 b1,
  ) {
    final r0 = a0 - b0;
    final dv = (a1 - a0) - (b1 - b0);
    final dd = dv.x * dv.x + dv.y * dv.y;
    var s = 0.0;
    if (dd > 1e-12) {
      s = (-(r0.x * dv.x + r0.y * dv.y) / dd).clamp(0.0, 1.0);
    }
    return (r0 + dv * s).length;
  }
}
