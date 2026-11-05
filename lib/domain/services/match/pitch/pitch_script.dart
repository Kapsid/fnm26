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

/// One man who appears on the pitch at some point of the match. [keeper] says
/// whether he holds his side's keeper slot when he first appears; who keeps
/// goal at a given instant is [PitchFrame.keepers].
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
    required this.keepers,
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

  /// The players keeping goal right now: whoever holds each side's keeper
  /// slot (a substitute keeper, or an outfielder sent in after a red).
  final Set<int> keepers;
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
    required this.keepers,
    required this.cameraX,
    required this.zoom,
  });

  /// Screen seconds.
  final double t;
  final Float64List xs;
  final Float64List ys;
  final Float64List facing;

  /// 1 where the actor holds his side's keeper slot.
  final Uint8List keepers;
  final double cameraX;
  final double zoom;

  bool present(int actor) => !xs[actor].isNaN;
  bool keeper(int actor) => keepers[actor] == 1;
  Offset2 at(int actor) => Offset2(xs[actor], ys[actor]);
}

/// What the ball is doing over [t0, t1) screen seconds. Consecutive phases
/// meet end to start and together cover the whole script.
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

/// A ball in the air when a [ScriptState] was taken: it left [from] at
/// [t0] for [toId], aimed at [lead], and lands at [t1] (screen seconds of
/// the script it was taken from).
typedef ScriptFlight = ({
  int fromId,
  int toId,
  Offset2 from,
  Offset2 lead,
  double t0,
  double t1,
  double peak,
});

/// The live state at one instant: who is where, and who has the ball. A
/// stager reads it; [PitchScript.stateAt] captures one for the story layer
/// to resume from after a re-simulation.
class ScriptState {
  const ScriptState({
    required this.t,
    required this.players,
    required this.ball,
    required this.carrierId,
    required this.possessionNationId,
    this.teams = const {},
    this.facing = const {},
    this.velocity = const {},
    this.walking = const {},
    this.keepers = const {},
    this.flight,
    this.homeBallTime = 0,
    this.awayBallTime = 0,
    this.cameraX = PitchDims.length / 2,
    this.minute = 1,
    this.stoppage = 0,
    this.within = 0,
  });

  /// Screen seconds.
  final double t;
  final Map<int, Offset2> players;
  final Offset2 ball;

  /// The player with the ball at his feet; null while it is in flight.
  final int? carrierId;

  /// The side last in control of the ball.
  final int possessionNationId;

  /// Each player's side (nation id).
  final Map<int, int> teams;
  final Map<int, double> facing;
  final Map<int, Offset2> velocity;

  /// Players walking off.
  final Set<int> walking;

  /// Players keeping goal.
  final Set<int> keepers;

  /// The ball in the air, when it is.
  final ScriptFlight? flight;

  /// Screen seconds each side has had the ball so far.
  final double homeBallTime;
  final double awayBallTime;
  final double cameraX;

  /// The match position of [t].
  final int minute;
  final int stoppage;
  final double within;
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

  /// The players this window's moments name: the only ones a stager may
  /// take out of their usual places (a keeper off his line included).
  Set<int> get actors => {
    for (final m in moments)
      ...switch (m) {
        ShotMoment(:final shooterId, :final assistId, :final keeperId) => [
          shooterId,
          ?assistId,
          ?keeperId,
        ],
        SetPieceMoment(:final takerId) => [takerId],
        FoulMoment(:final foulerId, :final fouledId) => [foulerId, fouledId],
        OffsideMoment(:final playerId) => [playerId],
        SubMoment(:final onId, :final offId) => [onId, ?offId],
      },
    ?injury?.playerId,
  };
}

/// A whole match's picture, or (after a resume) the part of it from [start].
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
    this.start = 0,
  }) : _index = {
         for (var i = 0; i < actorList.length; i++) actorList[i].playerId: i,
       };

  final List<PitchActor> actorList;
  final List<ScriptKeyframe> keyframes;
  final List<BallPhase> ballPhases;

  /// Screen seconds at which play restarts from a kick-off with the sides
  /// lined up afresh (the second half, extra time and its second half). The
  /// picture jumps there; the screen pauses for the interval.
  final List<double> resets;
  final List<StagedWindow> windows;

  /// Player id -> the screen second he starts walking off. He walks to the
  /// nearer touchline at [walkSpeed] and is gone once he reaches it (or at
  /// the next interval, whichever comes first).
  final Map<int, double> departures;

  /// Player id -> the screen second a substitute steps on.
  final Map<int, double> arrivals;
  final PitchPacer pacer;
  final MatchResult result;
  final int homeNationId;

  /// The screen second the script begins at: 0, or the resume point.
  final double start;
  final Map<int, int> _index;

  /// How fast a player walks off, in metres per second.
  static const double walkSpeed = 2;

  double get totalSeconds => pacer.total.inMicroseconds / 1e6;

  int? actorIndexOf(int playerId) => _index[playerId];

  /// The men on the pitch (walking off included) at the start of [minute]
  /// (+[stoppage]).
  List<PitchActor> actors(int minute, {int stoppage = 0}) {
    final t = _clampT(pacer.screenAt(minute, stoppage).inMicroseconds / 1e6);
    final k = _frameAt(t);
    return [
      for (var i = 0; i < actorList.length; i++)
        if (_presentAt(i, k, t)) actorList[i],
    ];
  }

  /// Who keeps goal for each side at screen second [t].
  Set<int> keepersAt(double t) {
    final at = _clampT(t);
    final k = _frameAt(at);
    final f = keyframes[k];
    return {
      for (var i = 0; i < actorList.length; i++)
        if (_presentAt(i, k, at) && f.keeper(i)) actorList[i].playerId,
    };
  }

  /// The picture at [screen].
  PitchFrame sample(Duration screen) {
    final t = _clampT(screen.inMicroseconds / 1e6);
    final k = _frameAt(t);
    final a = keyframes[k];
    final b = k + 1 < keyframes.length ? keyframes[k + 1] : a;
    final u = b.t > a.t ? ((t - a.t) / (b.t - a.t)).clamp(0.0, 1.0) : 0.0;
    final players = <int, Offset2>{};
    final facing = <int, double>{};
    final keepers = <int>{};
    for (var i = 0; i < actorList.length; i++) {
      if (!_presentAt(i, k, t)) continue;
      final id = actorList[i].playerId;
      players[id] = b.present(i) ? Offset2.lerp(a.at(i), b.at(i), u) : a.at(i);
      facing[id] = b.present(i)
          ? _lerpAngle(a.facing[i], b.facing[i], u)
          : a.facing[i];
      if (a.keeper(i)) keepers.add(id);
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
      keepers: keepers,
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

  /// Everything the story layer needs to carry on from [screen] with no
  /// jump: hand it to `StoryLayer.build(resumeFrom:)` after a
  /// re-simulation, and the new script starts exactly here.
  ScriptState stateAt(Duration screen) {
    final t = _clampT(screen.inMicroseconds / 1e6);
    final f = sample(Duration(microseconds: (t * 1e6).round()));
    final k = _frameAt(t);
    final a = keyframes[k];
    final b = k + 1 < keyframes.length ? keyframes[k + 1] : a;
    final velocity = <int, Offset2>{};
    final teams = <int, int>{};
    for (final id in f.players.keys) {
      final i = _index[id]!;
      teams[id] = actorList[i].teamNationId;
      final dt = b.t - a.t;
      velocity[id] = dt > 1e-9 && a.present(i) && b.present(i)
          ? (b.at(i) - a.at(i)) * (1 / dt)
          : Offset2.zero;
    }
    final phase = _phaseAt(t);
    ScriptFlight? flight;
    if (phase is FlightPhase &&
        phase.fromActor != null &&
        phase.toActor != null) {
      flight = (
        fromId: actorList[phase.fromActor!].playerId,
        toId: actorList[phase.toActor!].playerId,
        from: phase.from,
        lead: phase.to,
        t0: phase.t0,
        t1: phase.t1,
        peak: phase.peak,
      );
    }
    // Ball time so far: a carried ball is its carrier's side's, a ball in
    // flight its passer's.
    var home = 0.0;
    var away = 0.0;
    var possession = homeNationId;
    for (final p in ballPhases) {
      if (p.t0 >= t) break;
      final len = math.min(p.t1, t) - p.t0;
      final actor = switch (p) {
        CarryPhase(carrier: final ci) => ci,
        FlightPhase(:final fromActor) => fromActor,
      };
      if (actor == null) continue;
      possession = actorList[actor].teamNationId;
      if (possession == homeNationId) {
        home += len;
      } else {
        away += len;
      }
    }
    final m = pacer.matchAt(Duration(microseconds: (t * 1e6).round()));
    return ScriptState(
      t: t,
      players: f.players,
      ball: f.ball,
      carrierId: f.ballCarrierId,
      possessionNationId: possession,
      teams: teams,
      facing: f.facing,
      velocity: velocity,
      walking: {
        for (final e in departures.entries)
          if (e.value <= t && f.players.containsKey(e.key)) e.key,
      },
      keepers: f.keepers,
      flight: flight,
      homeBallTime: home,
      awayBallTime: away,
      cameraX: f.camera.centreX,
      minute: m.minute,
      stoppage: m.stoppage,
      within: m.within,
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

  double _clampT(double t) => t.clamp(start, totalSeconds);

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

  /// The fastest a man walking off may go.
  static const double maxWalkSpeed = 2.5;

  /// How near a touchline a man walking off has to be to leave the picture.
  static const double offTheLine = 1;

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
    StagedWindow? windowAt(double t) {
      for (final w in s.windows) {
        if (t >= w.start - 1e-9 && t < w.end - 1e-9) return w;
      }
      return null;
    }

    bool walking(int i, double t) {
      final d = s.departures[s.actorList[i].playerId];
      return d != null && t >= d - 1e-9;
    }

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
      // Keepers near their own goal. In open play a keeper never goes
      // beyond [keeperReach]; one already beyond it (back from a moment, or
      // a man just sent in goal) only comes back. In a moment's window only
      // the moment's own keeper may leave his area.
      final last = k + 1 < frames.length && frames[k + 1].t <= a.t + 1e-9;
      final judgedAt = last ? a.t - 1e-3 : a.t;
      final m = s.pacer.matchAt(
        Duration(microseconds: (judgedAt * 1e6).round()),
      );
      final prev = k > 0 && frames[k - 1].t < a.t - 1e-9 ? frames[k - 1] : null;
      final window = windowAt(a.t);
      for (var i = 0; i < n; i++) {
        final actor = s.actorList[i];
        if (!a.keeper(i) || !a.present(i)) continue;
        final dir = attackDir(
          home: actor.teamNationId == s.homeNationId,
          minute: m.minute,
        );
        final depth = xToDepth(a.xs[i], dir);
        if (depth <= keeperReach + 1e-6) continue;
        if (window != null) {
          if (!window.actors.contains(actor.playerId)) {
            add(
              a.t,
              'keeper ${actor.playerId} ${depth.toStringAsFixed(1)} m '
              'from his goal line in a moment that is not his',
            );
          }
          continue;
        }
        if (prev == null || !prev.present(i) || !prev.keeper(i)) continue;
        final before = xToDepth(prev.xs[i], dir);
        if (before <= keeperReach + 1e-6 && windowAt(prev.t) == null) {
          add(
            a.t,
            'keeper ${actor.playerId} ${depth.toStringAsFixed(1)} m '
            'from his goal line',
          );
        } else if (depth > before + 1e-6) {
          add(
            a.t,
            'keeper ${actor.playerId} ${depth.toStringAsFixed(1)} m '
            'from his goal line and going further',
          );
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
        if (a.present(i) && !b.present(i) && !resets.contains(b.t)) {
          // Leaving the picture: only a man walking off, at the touchline.
          final id = s.actorList[i].playerId;
          final y = a.ys[i];
          final edge = math.min(y, PitchDims.width - y);
          if (!walking(i, a.t)) {
            add(a.t, 'player $id vanishes');
          } else if (edge > offTheLine + 1e-6) {
            add(
              a.t,
              'player $id vanishes ${edge.toStringAsFixed(1)} m '
              'from the touchline',
            );
          }
        }
        if (!a.present(i) || !b.present(i)) continue;
        final v = a.at(i).distanceTo(b.at(i)) / dt;
        if (v > maxPlayerSpeed + 1e-6) {
          add(
            a.t,
            'player ${s.actorList[i].playerId} moved '
            '${v.toStringAsFixed(1)} m/s',
          );
        }
        if (walking(i, a.t) && v > maxWalkSpeed + 1e-6) {
          add(
            a.t,
            'player ${s.actorList[i].playerId} walked off at '
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

    _checkComingsAndGoings(s, add);
    _checkBall(s, add);
    return out;
  }

  static void _checkComingsAndGoings(
    PitchScript s,
    void Function(double, String) add,
  ) {
    final frames = s.keyframes;
    double secs(Duration d) => d.inMicroseconds / 1e6;
    // Each leaver's window: from his event's minute to the end of the
    // moment that stages it (or of its minute, when nothing does).
    final bounds = <int, (double, double)>{};
    final result = s.result;
    for (var idx = 0; idx < result.events.length; idx++) {
      final e = result.events[idx];
      final id = switch (e.type) {
        MatchEventType.redCard || MatchEventType.injury => e.playerId,
        MatchEventType.substitution => e.secondaryPlayerId,
        _ => null,
      };
      if (id == null) continue;
      final from = secs(s.pacer.screenAt(e.minute, e.stoppage));
      var to = secs(s.pacer.screenAt(e.minute, e.stoppage, within: 1));
      for (final w in s.windows) {
        final m = w.moments.isEmpty ? null : w.moments.first;
        final mine = switch (e.type) {
          MatchEventType.redCard => m is FoulMoment && m.cardEventIndex == idx,
          MatchEventType.injury => identical(w.injury, e),
          MatchEventType.substitution => m is SubMoment && m.eventIndex == idx,
          _ => false,
        };
        if (mine) to = math.max(to, w.end);
      }
      bounds.putIfAbsent(id, () => (from, to));
    }
    bounds.forEach((id, b) {
      if (s.actorIndexOf(id) == null) return;
      final start = s.departures[id];
      if (start == null) {
        if (b.$1 >= s.start) add(b.$1, 'player $id never leaves the pitch');
        return;
      }
      if (start < b.$1 - 1e-6)
        add(start, 'player $id leaves before his minute');
      if (start > b.$2 + 1e-6) add(start, 'player $id leaves after his moment');
    });
    // Once gone, gone for good.
    s.departures.forEach((id, start) {
      final i = s.actorIndexOf(id)!;
      var gone = false;
      for (final f in frames) {
        if (f.t < start) continue;
        if (!f.present(i)) {
          gone = true;
        } else if (gone) {
          add(f.t, 'player $id comes back after leaving');
          break;
        }
      }
    });
    // Substitutes: off the pitch until they come on, then on it until they
    // leave.
    for (final e in result.events) {
      if (e.type != MatchEventType.substitution) continue;
      final i = s.actorIndexOf(e.playerId);
      if (i == null) continue;
      final on = s.arrivals[e.playerId];
      final eventAt = secs(s.pacer.screenAt(e.minute, e.stoppage));
      if (on == null) {
        // Waiting for the man he replaces to reach the touchline is fine;
        // never coming on at all is not.
        if (s.totalSeconds - eventAt > 25 && eventAt >= s.start) {
          add(eventAt, 'substitute ${e.playerId} never comes on');
        }
        continue;
      }
      if (on < eventAt - 1e-6) add(on, 'substitute ${e.playerId} on early');
      final leaves = s.departures[e.playerId] ?? double.infinity;
      var seen = false;
      for (final f in frames) {
        if (f.t < on - 1e-9) {
          if (f.present(i)) {
            add(f.t, 'substitute ${e.playerId} on before he comes on');
            break;
          }
        } else if (f.present(i)) {
          seen = true;
        } else if (seen && f.t < leaves) {
          add(f.t, 'substitute ${e.playerId} disappears');
          break;
        }
      }
      if (!seen && on < s.totalSeconds - 1e-6) {
        add(on, 'substitute ${e.playerId} never appears');
      }
    }
  }

  static void _checkBall(PitchScript s, void Function(double, String) add) {
    final frames = s.keyframes;
    final phases = s.ballPhases;
    final resets = s.resets.toSet();
    if (phases.isEmpty || phases.first.t0 > s.start + 1e-9) {
      add(s.start, 'the ball has no phase at the start');
    }
    for (var p = 0; p < phases.length; p++) {
      final ph = phases[p];
      if (p + 1 < phases.length) {
        final next = phases[p + 1];
        if ((next.t0 - ph.t1).abs() > 1e-6) {
          add(ph.t1, 'the ball has no phase between two of its phases');
        } else if (!resets.contains(ph.t1)) {
          // The ball where one phase leaves it is where the next takes it.
          final end = s.ballAt(ph.t1, phase: ph).$1;
          final begin = s.ballAt(next.t0, phase: next).$1;
          final gap = end.distanceTo(begin);
          if (gap > 1e-6) {
            add(ph.t1, 'the ball jumps ${gap.toStringAsFixed(2)} m');
          }
        }
      }
      switch (ph) {
        case CarryPhase(carrier: final ci):
          for (final f in frames) {
            if (f.t < ph.t0 - 1e-9) continue;
            if (f.t > ph.t1 + 1e-9) break;
            if (!f.present(ci)) {
              add(f.t, 'the ball is carried by a player not on the pitch');
              break;
            }
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
    var prevT = s.start;
    var prev = s.ballAt(prevT).$1;
    final resetList = [...s.resets]..sort();
    var r = 0;
    for (var t = s.start + step; t <= total + 1e-9; t += step) {
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
