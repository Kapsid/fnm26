/// One match's picture read back the way a viewer would judge it: the
/// staging audit `moment_staging_test.dart` runs over 200 matches, shared
/// so other pitch tests can judge their own matches the same way.
library;

import 'dart:math' as math;

import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_moments.dart';
import 'package:fnm/domain/services/match/pitch/moment_staging.dart';
import 'package:fnm/domain/services/match/pitch/pitch_geometry.dart';
import 'package:fnm/domain/services/match/pitch/pitch_script.dart';

Duration _at(double t) => Duration(microseconds: (t * 1e6).round());

/// The findings that are never allowed, in any match: what the engine
/// recorded always reaches the screen (the Ruling 9 outcome classes and
/// the zero gate widened since).
const pitchOutcomeClasses = [
  'never struck',
  'save not',
  'goal not in the net',
  'leaves the net',
  'wide shot not wide',
  'woodwork shot misses',
  'block',
  'goal move',
  'goal not set up',
  'offside: no ball',
  'was onside',
  'offside: no flag',
  'wall',
  'no wall',
  'shown to',
  'm from the free kick',
  'of the corner',
  'corner from the wrong place',
  'penalty not taken from the mark',
  'keeper',
  'taker not at the ball',
  'not out of the area at the penalty',
  'never on the ball',
  'never reaches him',
  'never taken',
  'long throw from the wrong place',
  'the scorers kick off',
  'does not leave',
  'the attackers keep the ball',
  'not tagged',
  'goal line',
  'card shown to somebody',
  'corner off an attacker',
];

/// One match's picture read back, the way a viewer would judge it.
class PitchAudit {
  PitchAudit(this.s, this.label);

  final PitchScript s;
  final String label;
  final List<String> problems = [];
  final Map<String, int> counts = {};
  final Map<String, double> worst = {};

  void fail(double t, String what) =>
      problems.add('$label ${s.minuteLabel(t)}: $what');

  void count(String key) => counts[key] = (counts[key] ?? 0) + 1;

  void note(String key, double v) =>
      worst[key] = math.max(worst[key] ?? double.negativeInfinity, v);

  int team(int actor) => s.actorList[actor].teamNationId;
  int? idx(int? id) => id == null ? null : s.actorIndexOf(id);

  int dirOf(int nation, double t) => attackDir(
    home: nation == s.homeNationId,
    minute: s.pacer.matchAt(_at(t + 1e-4)).minute,
  );

  double depth(Offset2 p, int dir) => xToDepth(p.x, dir);
  double lat(Offset2 p, int dir) => (p.y - PitchDims.width / 2) * dir;

  List<FlightPhase> flights(double from, double to) => [
    for (final p in s.ballPhases)
      if (p is FlightPhase && !p.resting && p.t0 >= from - 1e-9 && p.t0 < to) p,
  ];

  /// The end of [w]'s moment: its window, or as far as it may play on
  /// into the quiet time after (3 s, never into the next window).
  double _until(StagedWindow w) {
    var u = w.end + 3;
    for (final o in s.windows) {
      if (o.start > w.start + 1e-9) u = math.min(u, o.start);
    }
    return u;
  }

  BallPhase? phaseBefore(BallPhase p) {
    final i = s.ballPhases.indexOf(p);
    return i > 0 ? s.ballPhases[i - 1] : null;
  }

  /// The second-last man of [nation]'s opponents, as [nation] attacking
  /// [dir] sees it, at [t]; walkers apart.
  double offsideLine(int nation, int dir, double t) {
    final f = s.sample(_at(t + 2e-6));
    final ds = <double>[];
    f.players.forEach((id, p) {
      final i = s.actorIndexOf(id)!;
      if (team(i) == nation) return;
      final dep = s.departures[id];
      if (dep != null && dep <= t + 1e-9) return;
      ds.add(depth(p, dir));
    });
    ds.sort();
    return ds.length < 2 ? PitchDims.length : ds[ds.length - 2];
  }

  bool onsideAt(int receiver, Offset2 ball, double t) {
    final nation = team(receiver);
    final dir = dirOf(nation, t);
    final p = s.sample(_at(t + 2e-6)).players[s.actorList[receiver].playerId]!;
    final d = depth(p, dir);
    if (d <= PitchDims.length / 2) return true;
    return d <= math.max(offsideLine(nation, dir, t), depth(ball, dir)) + 0.05;
  }

  /// Open play between the staged moments, as a viewer would count it:
  /// passes, carries (dribbles and runs with the ball) and turnovers
  /// (tackles and interceptions: the ball goes from one side's man to the
  /// other's), each started outside every staged window; with the screen
  /// seconds of open play and of staged moments. Counted into [counts] as
  /// 'open play: ...'.
  void openPlay() {
    bool staged(double t) =>
        s.windows.any((w) => t >= w.start - 1e-9 && t < w.end - 1e-9);
    int? lastSide;
    for (final p in s.ballPhases) {
      final out = !staged(p.t0);
      switch (p) {
        case CarryPhase(:final carrier):
          final side = team(carrier);
          if (out) {
            if (p.t1 - p.t0 > 0.6) count('open play: carry');
            if (lastSide != null && lastSide != side) {
              count('open play: turnover');
            }
          }
          lastSide = side;
        case FlightPhase(:final pass, :final toActor, :final resting):
          if (out && !resting && pass && toActor != null) {
            count('open play: pass');
            if ((p.to.y - p.from.y).abs() > 30) {
              count('open play: switch of play');
            }
          }
          if (toActor == null) lastSide = null;
      }
    }
    var stagedSecs = 0.0;
    for (final w in s.windows) {
      stagedSecs += w.end - w.start;
    }
    counts['open play: screen seconds'] = (s.totalSeconds - stagedSecs).round();
    counts['staged: screen seconds'] = stagedSecs.round();
  }

  /// Whether [t] is a set piece's or a penalty's staging, or a goal's
  /// strike and celebration (from the shot's kick to the kick-off): the
  /// times men may stand on a goal line.
  bool setPieceOrCelebration(double t) {
    for (final w in s.windows) {
      if (t < w.start - 1e-9 || t >= _until(w) - 1e-9) continue;
      if (w.moments.isEmpty) continue;
      final first = w.moments.first;
      if (first is SetPieceMoment) return true;
      if (first is ShotMoment && first.origin == ShotOrigin.penalty) {
        return true;
      }
      for (final m in w.moments) {
        if (m is ShotMoment && m.outcome == ShotOutcome.goal) {
          // The celebration: from the strike on (the run-in to the net
          // included), so from the shot's kick, not its landing.
          for (final f in flights(w.start, _until(w))) {
            if (f.fromActor == idx(m.shooterId) && !f.pass) {
              if (t >= f.t0 - 1e-9) return true;
              break;
            }
          }
        }
      }
    }
    return false;
  }

  /// Men parked on a goal line in play (Task 15c f): in every keyframe
  /// outside a set piece or a goal's celebration, the outfield men the
  /// moment does not name within [near] m of a goal line and across the
  /// width of the box, counted per side: the side defending that goal
  /// ('goal line: defenders') and the side attacking it ('goal line:
  /// attackers'). The worst of each goes into [worst]; frames with
  /// [crowd] or more of a side into [counts].
  void goalLineCrowds({double near = 6, int crowd = 3}) {
    final n = s.actorList.length;
    final frames = s.keyframes;
    for (var k = 0; k < frames.length; k++) {
      final f = frames[k];
      // A frame a cut replaces on the same instant is never seen.
      if (k + 1 < frames.length && frames[k + 1].t <= f.t + 1e-9) continue;
      if (f.t < s.start - 1e-9 || setPieceOrCelebration(f.t)) continue;
      final w = s.windowAt(f.t + 1e-6);
      final named = w?.actors ?? const <int>{};
      // [end] 0: the goal at x 0, 1: at x 105.
      for (var end = 0; end < 2; end++) {
        var defenders = 0;
        var attackers = 0;
        for (var i = 0; i < n; i++) {
          if (!f.present(i) || f.keeper(i)) continue;
          final a = s.actorList[i];
          if (named.contains(a.playerId)) continue;
          final dep = s.departures[a.playerId];
          if (dep != null && dep <= f.t + 1e-9) continue;
          final p = f.at(i);
          final fromLine = end == 0 ? p.x : PitchDims.length - p.x;
          if (fromLine > near || fromLine < -2) continue;
          if ((p.y - PitchDims.width / 2).abs() > 20.16) continue;
          // Which way this man's side attacks: toward x 105 is +1.
          final dir = dirOf(a.teamNationId, f.t);
          final defending = (dir == 1) == (end == 0);
          if (defending) {
            defenders++;
          } else {
            attackers++;
          }
        }
        note('goal line: defenders', defenders.toDouble());
        note('goal line: attackers', attackers.toDouble());
        if (defenders >= crowd) count('goal line: $crowd+ defenders');
        if (attackers >= crowd) count('goal line: $crowd+ attackers');
      }
    }
  }

  void run() {
    openPlay();
    // A phase cut lines both sides up in their shapes: never a crowd on a
    // goal line (the moment's own men apart).
    for (final e in s.cutKinds.entries) {
      if (e.value != PitchCutKind.phase) continue;
      final f = s.sample(_at(e.key + 2e-6));
      final w = s.windowAt(e.key + 1e-6);
      final named = w?.actors ?? const <int>{};
      final perSide = <int, int>{};
      f.players.forEach((id, p) {
        if (f.keepers.contains(id) || named.contains(id)) return;
        final edge = math.min(p.x, PitchDims.length - p.x);
        if (edge < 4) {
          final n = team(s.actorIndexOf(id)!);
          perSide[n] = (perSide[n] ?? 0) + 1;
        }
      });
      final worst = perSide.values.fold(0, math.max);
      count('phase cut');
      note(
        'phase cut: most men of a side within 4 m of a goal line',
        worst.toDouble(),
      );
      if (worst > 2) {
        fail(e.key, 'phase cut leaves $worst men on a goal line');
      }
    }
    for (final p in s.ballPhases) {
      if (p.t1 <= p.t0 + 1e-9) fail(p.t0, 'a ball phase of no length');
    }
    for (final w in s.windows) {
      if (w.moments.isEmpty) {
        _injury(w);
        continue;
      }
      final first = w.moments.first;
      switch (first) {
        case ShotMoment(:final origin) when origin == ShotOrigin.penalty:
          count('penalty');
          _penalty(w, first);
        case ShotMoment():
          count('shot ${first.origin.name}');
        case SetPieceMoment(:final kind) when kind == SetPieceKind.corner:
          count('corner');
          _corner(w, first);
        case SetPieceMoment(:final kind) when kind == SetPieceKind.freeKick:
          count('free kick');
          freeKick(w, first);
        case SetPieceMoment():
          count('long throw');
          _throw(w, first);
        case FoulMoment():
          count('foul + card');
          _foul(w, first);
        case OffsideMoment():
          count('offside');
          _offside(w, first);
        case SubMoment():
          count('sub');
          _sub(w, first);
      }
      for (final m in w.moments) {
        if (m is ShotMoment) _shot(w, m);
      }
      final cut = s.cuts.any(
        (c) => c >= w.start - 1e-9 && c < _until(w) - 1e-9,
      );
      if (cut) count('cut in ${_kind(w)}');

      // The moment's men wear their tags throughout.
      final mid = s.sample(_at((w.start + w.end) / 2));
      for (final id in w.actors) {
        if (mid.players.containsKey(id) && !mid.tagged.contains(id)) {
          fail(w.start, 'player $id in the moment is not tagged');
        }
      }
    }
  }

  static String _kind(StagedWindow w) {
    final m = w.moments.first;
    return switch (m) {
      ShotMoment(:final origin, :final outcome) =>
        origin == ShotOrigin.penalty
            ? 'penalty'
            : outcome == ShotOutcome.goal
            ? 'goal'
            : 'shot',
      SetPieceMoment(:final kind) => kind.name,
      FoulMoment() => 'foul',
      OffsideMoment() => 'offside',
      SubMoment() => 'sub',
    };
  }

  void _shot(StagedWindow w, ShotMoment m) {
    count('shot ${m.outcome.name}');
    final si = idx(m.shooterId)!;
    FlightPhase? shot;
    // After a set piece's own kick (the taker may set the ball down first).
    var from = w.start;
    final sp = w.moments.first;
    if (sp is SetPieceMoment) {
      final k = switch (sp.kind) {
        SetPieceKind.longThrow || SetPieceKind.throwIn => _throwKick(w, sp),
        SetPieceKind.corner => _cornerKick(w, sp),
        _ => _deadKick(w, sp.takerId),
      };
      if (k != null) from = k.t0;
    }
    if (m.origin == ShotOrigin.penalty) {
      // The kick from the mark, not the ball set down on it.
      final dir = dirOf(m.teamNationId, w.start);
      final spot = Offset2(
        depthToX(PitchDims.penaltySpotDepth, dir),
        PitchDims.width / 2,
      );
      for (final f in flights(w.start, _until(w))) {
        if (f.fromActor == si && f.from.distanceTo(spot) < 1e-6) {
          from = f.t0;
          break;
        }
      }
    }
    for (final f in flights(from, _until(w))) {
      if (f.fromActor == si &&
          !f.pass &&
          (f.toActor == null || team(f.toActor!) != m.teamNationId)) {
        shot = f;
        break;
      }
    }
    if (shot == null) {
      fail(w.start, 'shot by ${m.shooterId} (${m.outcome.name}) never struck');
      return;
    }
    if (shot.t0 > w.end - 1e-6) count('shot struck in the spill-over');
    // Key moments (goals, penalties, big saves): reached by a cut before
    // the shot, or played on from what came before.
    final key =
        m.outcome == ShotOutcome.goal ||
        m.origin == ShotOrigin.penalty ||
        (m.outcome == ShotOutcome.saved && m.xg >= 0.15);
    if (key) {
      final cutBefore = s.cuts.any(
        (c) => c >= w.start - 1e-9 && c <= shot!.t0 + 1e-9,
      );
      count(cutBefore ? 'key moment after a cut' : 'key moment continuous');
    }
    note('shot lands after window (s)', shot.t1 - w.end);
    final dir = dirOf(m.teamNationId, shot.t0);
    final fromD = depth(shot.from, dir);
    final toD = depth(shot.to, dir);
    // Where it crosses the goal line, and how high.
    double? crossLat;
    double? crossH;
    if (toD > PitchDims.length - 1e-9 && toD > fromD) {
      final u = (PitchDims.length - fromD) / (toD - fromD);
      crossLat = lat(Offset2.lerp(shot.from, shot.to, u), dir);
      crossH = shot.heightAt(u);
    }
    final keeperAt = s.keepersAt(shot.t1 - 1e-3);
    switch (m.outcome) {
      case ShotOutcome.goal:
        if (shot.toActor != null ||
            crossLat == null ||
            crossLat.abs() > PitchDims.goalHalfWidth - 0.11 ||
            crossH! > PitchDims.crossbarHeight - 0.11 ||
            toD > PitchDims.length + 2.5) {
          fail(shot.t0, 'goal not in the net: ${shot.to} h $crossH');
        }
        // It lies there until the kick-off.
        final after = s.ballPhases.indexOf(shot) + 1;
        if (after < s.ballPhases.length) {
          final rest = s.ballPhases[after];
          if (rest is! FlightPhase || !rest.resting && rest.t0 < w.end - 1e-6) {
            fail(shot.t1, 'the ball leaves the net before the kick-off');
          }
        }
        final restart = s.cuts.any((r) => (r - w.end).abs() < 1e-6);
        final interval = s.resets.any((r) => (r - w.end).abs() < 1e-6);
        if (!restart && !interval && w.end < s.totalSeconds - 1e-6) {
          fail(w.end, 'no kick-off after the goal');
        }
        final straightOn = s.windows.any(
          (o) => (o.start - w.end).abs() < 1e-6,
        );
        if (restart && straightOn) count('goal kick-off, next moment at once');
        // A moment opening on the kick-off may cut to itself at once.
        final frames = s.keyframes
            .where((f) => (f.t - w.end).abs() < 1e-6)
            .length;
        if (restart && !straightOn && frames <= 2) {
          count('goal kick-off');
          // The first touch after the cut: the conceding side's, on the
          // centre spot.
          BallPhase? ko;
          for (final p in s.ballPhases) {
            if ((p.t0 - w.end).abs() < 1e-6) {
              ko = p;
              break;
            }
          }
          final kicker = switch (ko) {
            CarryPhase(:final carrier) => carrier,
            FlightPhase(:final fromActor) => fromActor,
            null => null,
          };
          if (kicker == null || team(kicker) == m.teamNationId) {
            fail(w.end, 'the scorers kick off');
          }
          if (ko != null &&
              s
                      .ballAt(w.end + 1e-7, phase: ko)
                      .$1
                      .distanceTo(
                        PitchDims.centre,
                      ) >
                  0.7) {
            fail(w.end, 'kick-off away from the centre spot');
          }
        }
      case ShotOutcome.saved:
        final k = shot.toActor;
        final named = idx(m.keeperId);
        if (k == null ||
            (named != null && k != named) ||
            (named == null && !keeperAt.contains(s.actorList[k].playerId))) {
          fail(shot.t0, 'save not made by the keeper');
        } else {
          final kp = s
              .sample(_at(shot.t1 - 1e-4))
              .players[s.actorList[k].playerId];
          if (kp == null || kp.distanceTo(shot.to) > 1.0) {
            fail(shot.t1, "save not in the keeper's hands");
          }
          if (crossLat != null) fail(shot.t1, 'saved behind the goal line');
        }
      case ShotOutcome.wide:
        if (shot.toActor != null ||
            crossLat == null ||
            (crossLat.abs() <= PitchDims.goalHalfWidth + 0.11 &&
                crossH! <= PitchDims.crossbarHeight + 0.11)) {
          fail(shot.t0, 'wide shot not wide: lat $crossLat h $crossH');
        }
        // Back for the goal kick: the next man on the ball defends (unless
        // the next moment takes over first).
        for (final p in s.ballPhases) {
          if (p.t0 < shot.t1 - 1e-9) continue;
          if (p.t0 >= _until(w) - 1e-9) break;
          final got = switch (p) {
            CarryPhase(:final carrier) => carrier,
            FlightPhase(:final toActor) => toActor,
          };
          if (got != null) {
            if (team(got) == m.teamNationId) {
              fail(p.t0, 'wide shot comes back to the attackers');
            }
            break;
          }
        }
      case ShotOutcome.woodwork:
        final l = lat(shot.to, dir);
        final onLine = (toD - PitchDims.length).abs() < 0.3;
        final post =
            (l.abs() - PitchDims.goalHalfWidth).abs() < 0.15 &&
            shot.toHeight <= PitchDims.crossbarHeight;
        final bar =
            l.abs() <= PitchDims.goalHalfWidth &&
            (shot.toHeight - PitchDims.crossbarHeight).abs() < 0.05;
        if (shot.toActor != null || !onLine || !(post || bar)) {
          fail(shot.t0, 'woodwork shot misses the frame: ${shot.to}');
        }
        count(post ? 'woodwork post' : 'woodwork bar');
      case ShotOutcome.blocked:
        final b = shot.toActor;
        if (b == null ||
            team(b) == m.teamNationId ||
            keeperAt.contains(s.actorList[b].playerId)) {
          fail(shot.t0, 'block not by a defender');
        } else {
          final bp = s
              .sample(_at(shot.t1 - 1e-4))
              .players[s.actorList[b].playerId]!;
          if (bp.distanceTo(shot.to) > 1.0) {
            fail(shot.t1, 'blocked shot not stopped at the defender');
          }
          final dist = shot.from.distanceTo(shot.to);
          note('block distance (m)', dist);
          // A free kick is blocked by its wall; anything else by a man
          // right on the shooter.
          final reach = m.origin == ShotOrigin.directFreeKick
              ? wallDistance + 1.2
              : 3.0;
          if (dist > reach) {
            fail(shot.t0, 'blocked ${dist.toStringAsFixed(1)} m out');
          }
          if (depth(bp, dir) < fromD - 0.5) {
            fail(shot.t0, 'blocked by a man behind the shooter');
          }
        }
    }
    // The right men: the assist (or the set piece's deliverer) gives the
    // last ball to the shooter.
    final assist = m.assistId;
    if (m.outcome == ShotOutcome.goal &&
        assist != null &&
        assist != m.shooterId &&
        s.actorIndexOf(assist) != null) {
      FlightPhase? last;
      for (final f in flights(w.start, shot.t0)) {
        if (f.toActor == si) last = f;
      }
      if (last == null || last.fromActor != idx(assist)) {
        fail(shot.t0, 'goal not set up by the assist $assist');
      }
    }
    // A goal is never offside: every ball between team-mates in its move
    // finds a man onside (a corner and a throw-in excepted, as the law has
    // it).
    if (m.outcome == ShotOutcome.goal) {
      final sp = w.moments.first;
      final noOffside =
          sp is SetPieceMoment &&
          (sp.kind == SetPieceKind.corner ||
              sp.kind == SetPieceKind.longThrow ||
              sp.kind == SetPieceKind.throwIn);
      final taker = sp is SetPieceMoment ? idx(sp.takerId) : null;
      for (final f in flights(w.start, shot.t0 + 1e-6)) {
        final from = f.fromActor;
        final to = f.toActor;
        if (from == null || to == null || f == shot) continue;
        if (team(from) != m.teamNationId || team(to) != m.teamNationId) {
          continue;
        }
        if (noOffside &&
            from == taker &&
            phaseBefore(f) is FlightPhase &&
            (phaseBefore(f)! as FlightPhase).resting) {
          continue;
        }
        count('goal passes checked onside');
        if (!onsideAt(to, f.from, f.t0)) {
          fail(f.t0, 'goal move: ${s.actorList[to].playerId} offside');
        }
      }
    }
  }

  /// The dead-ball kick of window [w]: the first ball [taker] plays from
  /// where it lay (or, for a throw, from his hands, the ball given him
  /// where it lay).
  FlightPhase? _deadKick(StagedWindow w, int taker, {bool thrown = false}) {
    final ti = idx(taker);
    final all = flights(w.start, _until(w));
    for (final f in all) {
      if (f.fromActor != ti) continue;
      // A ball merely set down on the spot is not the kick.
      final onPitch =
          f.to.x > 1 &&
          f.to.x < PitchDims.length - 1 &&
          f.to.y > 0 &&
          f.to.y < PitchDims.width;
      if (f.toActor == null &&
          onPitch &&
          all.any(
            (g) => g.t0 > f.t0 && g.fromActor == ti && g.from == f.to,
          )) {
        continue;
      }
      final before = phaseBefore(f);
      // Off a ball lying still (or one that has just come to rest there,
      // or that a cut has just set down).
      final atCut = s.cuts.any((c) => (c - f.t0).abs() < 1e-6);
      if (!thrown &&
          (atCut ||
              before is FlightPhase &&
                  before.toActor == null &&
                  before.to == f.from)) {
        return f;
      }
      if (thrown && before is CarryPhase && before.carrier == ti) {
        final given = phaseBefore(before);
        final lay = given == null ? null : phaseBefore(given);
        final givenAtCut =
            given != null && s.cuts.any((c) => (c - given.t0).abs() < 1e-6);
        if (given is FlightPhase &&
            given.toActor == ti &&
            (givenAtCut || lay is FlightPhase && lay.toActor == null)) {
          return f;
        }
      }
    }
    return null;
  }

  void _corner(StagedWindow w, SetPieceMoment sp) {
    final kick = _cornerKick(w, sp);
    if (kick == null) {
      fail(w.start, 'corner never taken by ${sp.takerId}');
      return;
    }
    final dir = dirOf(sp.teamNationId, kick.t0);
    final d = depth(kick.from, dir);
    final l = lat(kick.from, dir);
    if (d < PitchDims.length - 1.2 || l.abs() < 32.8 || (l < 0) != sp.left) {
      fail(kick.t0, 'corner from the wrong place: depth $d lat $l');
    }
    // The ball went out off one of theirs.
    for (final g in flights(w.start, kick.t0)) {
      final a = depth(g.from, dir);
      final b = depth(g.to, dir);
      if (a < PitchDims.length && b > PitchDims.length) {
        final by = g.fromActor;
        if (by != null && team(by) == sp.teamNationId) {
          fail(g.t0, 'corner off an attacker');
        }
      }
    }
    final f = s.sample(_at(kick.t0 + 2e-6));
    f.players.forEach((id, p) {
      if (team(s.actorIndexOf(id)!) == sp.teamNationId) return;
      // A man walking off is out of it.
      final dep = s.departures[id];
      if (dep != null && dep <= kick.t0 + 1e-6) return;
      if (p.distanceTo(kick.from) < wallDistance - 0.3) {
        fail(kick.t0, 'defender $id within 9.15 m of the corner');
      }
    });
  }

  void freeKick(StagedWindow w, SetPieceMoment sp) {
    final kick = _deadKick(w, sp.takerId);
    if (kick == null) {
      fail(w.start, 'free kick never taken by ${sp.takerId}');
      return;
    }
    final dir = dirOf(sp.teamNationId, kick.t0);
    final ball = kick.from;
    final goal = Offset2(depthToX(PitchDims.length, dir), PitchDims.width / 2);
    final u = (goal - ball).unit;
    final f = s.sample(_at(kick.t0 + 2e-6));
    var wall = 0;
    var along = 0.0;
    f.players.forEach((id, p) {
      if (team(s.actorIndexOf(id)!) == sp.teamNationId) return;
      // A man walking off is out of it.
      final dep = s.departures[id];
      if (dep != null && dep <= kick.t0 + 1e-6) return;
      if (f.keepers.contains(id)) return;
      final r = p - ball;
      final a = r.x * u.x + r.y * u.y;
      final c = (r.x * u.y - r.y * u.x).abs();
      if (p.distanceTo(ball) < wallDistance - 0.4) {
        fail(
          kick.t0,
          'defender $id ${p.distanceTo(ball).toStringAsFixed(1)} '
          'm from the free kick',
        );
      }
      if (a > 8.4 && a < 10.2 && c < 3.6) {
        wall++;
        along += a;
      }
    });
    final direct = w.moments.length > 1
        ? (w.moments[1] as ShotMoment).origin == ShotOrigin.directFreeKick
        : sp.zone == PitchZone.edgeOfBox;
    if (wall == 0) {
      final near = <String>[];
      f.players.forEach((id, p) {
        if (team(s.actorIndexOf(id)!) == sp.teamNationId) return;
        final r = p - ball;
        near.add(
          '$id:${(r.x * u.x + r.y * u.y).toStringAsFixed(1)}/'
          '${(r.x * u.y - r.y * u.x).toStringAsFixed(1)}',
        );
      });
      fail(kick.t0, 'free kick with no wall $near');
      return;
    }
    if (direct && (wall < 3 || wall > 5)) {
      fail(kick.t0, 'direct free kick with a wall of $wall');
    }
    final mean = along / wall;
    note('wall mean distance (m)', mean);
    note('wall mean distance short of 9.15 (m)', wallDistance - mean);
    if ((mean - wallDistance).abs() > 0.45) {
      fail(kick.t0, 'wall ${mean.toStringAsFixed(2)} m away');
    }
    count(direct ? 'free kick direct' : 'free kick crossed');
  }

  /// A throw: his ball from the touchline.
  FlightPhase? _throwKick(StagedWindow w, SetPieceMoment sp) {
    final tdir = dirOf(sp.teamNationId, w.start);
    for (final f in flights(w.start, _until(w))) {
      if (f.fromActor == idx(sp.takerId) &&
          f.toActor != null &&
          lat(f.from, tdir).abs() > 31.5) {
        return f;
      }
    }
    return _deadKick(w, sp.takerId, thrown: true);
  }

  /// A corner: his ball from the arc.
  FlightPhase? _cornerKick(StagedWindow w, SetPieceMoment sp) {
    final cdir = dirOf(sp.teamNationId, w.start);
    for (final f in flights(w.start, _until(w))) {
      if (f.fromActor == idx(sp.takerId) &&
          depth(f.from, cdir) > PitchDims.length - 1.5 &&
          lat(f.from, cdir).abs() > 32.5) {
        return f;
      }
    }
    return _deadKick(w, sp.takerId);
  }

  void _throw(StagedWindow w, SetPieceMoment sp) {
    final kick = _throwKick(w, sp);
    if (kick == null) {
      fail(w.start, 'long throw never taken by ${sp.takerId}');
      return;
    }
    final dir = dirOf(sp.teamNationId, kick.t0);
    final l = lat(kick.from, dir);
    if (l.abs() < 31.5 || (l < 0) != sp.left) {
      fail(kick.t0, 'long throw from the wrong place: lat $l');
    }
  }

  void _penalty(StagedWindow w, ShotMoment m) {
    final si = idx(m.shooterId)!;
    final dir = dirOf(m.teamNationId, w.start);
    final spot = Offset2(
      depthToX(PitchDims.penaltySpotDepth, dir),
      PitchDims.width / 2,
    );
    // The kick: his first ball from the mark (he may set it down first).
    FlightPhase? kick;
    FlightPhase? any;
    for (final f in flights(w.start, _until(w))) {
      if (f.fromActor != si || f.pass) continue;
      any ??= f;
      if (f.from.distanceTo(spot) < 1e-6) {
        kick = f;
        break;
      }
    }
    kick ??= any;
    if (kick == null) return; // reported by the shot check
    if (kick.from.distanceTo(spot) > 1e-6) {
      fail(kick.t0, 'penalty not taken from the mark: ${kick.from}');
    }
    final t0 = kick.t0;
    final f = s.sample(_at(t0 + 2e-6));
    final tp = f.players[m.shooterId]!;
    if (tp.distanceTo(spot) > 1.3) fail(t0, 'taker not at the ball');
    f.players.forEach((id, p) {
      if (id == m.shooterId) return;
      final dep = s.departures[id];
      if (dep != null && dep <= t0 + 1e-6) return;
      final d = depth(p, dir);
      final l = lat(p, dir);
      if (f.keepers.contains(id)) {
        if (team(s.actorIndexOf(id)!) != m.teamNationId) {
          if (PitchDims.length - d > 1.0 || l.abs() > PitchDims.goalHalfWidth) {
            fail(t0, 'keeper $id off his line ($d, $l)');
          }
        }
        return;
      }
      final inBox =
          d > PitchDims.length - PitchDims.boxDepth &&
          l.abs() < PitchDims.boxHalfWidth;
      if (inBox || p.distanceTo(spot) < wallDistance - 0.2 || d > 94) {
        fail(
          t0,
          'player $id not out of the area at the penalty '
          '(${d.toStringAsFixed(1)}, ${l.toStringAsFixed(1)})',
        );
      }
    });
  }

  void _foul(StagedWindow w, FoulMoment m) {
    final fouled = idx(m.fouledId)!;
    var hadBall = false;
    for (final p in s.ballPhases) {
      if (p.t1 <= w.start || p.t0 >= w.end) continue;
      if (p is CarryPhase && p.carrier == fouled) hadBall = true;
      if (p is FlightPhase && p.toActor == fouled) hadBall = true;
    }
    if (!hadBall) fail(w.start, 'fouled man ${m.fouledId} never on the ball');
    var close = double.infinity;
    for (final f in s.keyframes) {
      if (f.t < w.start || f.t > w.end) continue;
      final a = f.at(fouled);
      final b = f.at(idx(m.foulerId)!);
      if (f.present(fouled)) close = math.min(close, a.distanceTo(b));
    }
    note('fouler distance at the foul (m)', close);
    if (close > 2.0) fail(w.start, 'fouler ${m.foulerId} never reaches him');
    final idxCard = m.cardEventIndex!;
    final red = s.result.events[idxCard].type == MatchEventType.redCard;
    if (s.result.events[idxCard].playerId != m.foulerId) {
      fail(w.start, 'card shown to somebody other than the fouler');
    }
    final want = red ? PitchCueKind.redCard : PitchCueKind.yellowCard;
    if (!w.cues.any((c) => c.kind == want && c.playerId == m.foulerId)) {
      fail(w.start, 'no ${want.name} shown to ${m.foulerId}');
    }
  }

  void _offside(StagedWindow w, OffsideMoment m) {
    final pi = idx(m.playerId)!;
    FlightPhase? ball;
    for (final f in flights(w.start, _until(w))) {
      if (f.toActor == pi &&
          f.fromActor != null &&
          team(f.fromActor!) == team(pi)) {
        ball = f;
        break;
      }
    }
    if (ball == null) {
      fail(w.start, 'offside: no ball played to ${m.playerId}');
      return;
    }
    if (onsideAt(pi, ball.from, ball.t0)) {
      fail(ball.t0, 'offside: ${m.playerId} was onside');
    }
    if (!w.cues.any((c) => c.kind == PitchCueKind.offsideFlag)) {
      fail(w.start, 'offside: no flag');
    }
    // The defending side restarts, from where he was.
    final end = s.sample(_at(w.end - 1e-3));
    final car = end.ballCarrierId;
    if (car != null &&
        s.actorList[s.actorIndexOf(car)!].teamNationId == m.teamNationId) {
      fail(w.end, 'offside: the attackers keep the ball');
    }
    final offence = s.sample(_at(ball.t0)).players[m.playerId]!;
    note('offside restart from the offence (m)', end.ball.distanceTo(offence));
  }

  void _sub(StagedWindow w, SubMoment m) {
    // A sub at an interval is made in it.
    if (m.stoppage == 0 && const {46, 91, 106}.contains(m.minute)) return;
    final off = m.offId;
    if (off != null && s.actorIndexOf(off) != null) {
      // He goes as it opens (the newcomer steps on) or as it ends.
      final d = s.departures[off];
      if (d == null || d < w.start - 1e-6 || d > w.end + 1e-6) {
        fail(w.start, 'sub: $off does not leave in its window');
      }
    }
  }

  void _injury(StagedWindow w) {
    count('injury');
    final id = w.injury!.playerId;
    final d = s.departures[id];
    if (s.actorIndexOf(id) != null && (d == null || (d - w.end).abs() > 1e-6)) {
      fail(w.start, 'injury: $id does not leave as it ends');
    }
  }
}
