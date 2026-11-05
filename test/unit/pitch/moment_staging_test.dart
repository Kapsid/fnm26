import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_moments.dart';
import 'package:fnm/domain/services/match/pitch/moment_staging.dart';
import 'package:fnm/domain/services/match/pitch/pitch_geometry.dart';
import 'package:fnm/domain/services/match/pitch/pitch_pacer.dart';
import 'package:fnm/domain/services/match/pitch/pitch_script.dart';
import 'package:fnm/domain/services/match/pitch/story_layer.dart';

import '../../helpers/fixtures.dart';

const _engine = MatchEngine();

MatchTeam _team(
  int nation,
  int rating,
  Formation f,
  TacticalInstructions i, {
  ThrowInStyle throwIn = ThrowInStyle.neutral,
}) => MatchTeam(
  nationId: nation,
  formation: f,
  instructions: i,
  throwInStyle: throwIn,
  xi: [
    for (var k = 0; k < 11; k++)
      player(
        id: nation * 100 + k,
        nationId: nation,
        position: f.positions[k],
        attributes: flatAttributes(rating),
      ),
  ],
);

TacticalInstructions _dials(SeededRng r) => TacticalInstructions(
  mentality: r.rangeInt(10, 90),
  pressing: r.rangeInt(10, 90),
  tempo: r.rangeInt(10, 90),
  width: r.rangeInt(10, 90),
  defensiveLine: r.rangeInt(10, 90),
  directness: r.rangeInt(10, 90),
);

typedef _Match = ({MatchResult result, MatchLineups lineups});

/// A varied engine match: shapes, dials, strengths, subs, long throws and
/// extra time all move with [seed].
_Match _match(int seed) {
  final r = SeededRng(seed * 7919 + 13);
  const fs = Formation.values;
  final home = _team(
    1,
    r.rangeInt(62, 84),
    fs[seed % fs.length],
    _dials(r),
    throwIn: seed % 4 == 1 ? ThrowInStyle.long : ThrowInStyle.neutral,
  );
  final away = _team(
    2,
    r.rangeInt(62, 84),
    fs[(seed * 7 + 3) % fs.length],
    _dials(r),
    throwIn: seed % 5 == 2 ? ThrowInStyle.long : ThrowInStyle.neutral,
  );
  final subs = <Substitution>[];
  final homeBench = <int>[];
  final awayBench = <int>[];
  for (var k = 0; k < 1 + seed % 3; k++) {
    final on = player(id: 150 + k, nationId: 1);
    homeBench.add(on.id);
    subs.add(
      Substitution(
        teamNationId: 1,
        minute: 50 + k * 12 + seed % 9,
        offId: 100 + 1 + (seed + k * 3) % 10,
        on: on,
      ),
    );
  }
  if (seed.isEven) {
    final on = player(id: 250, nationId: 2);
    awayBench.add(on.id);
    subs.add(
      Substitution(teamNationId: 2, minute: 46 + seed % 30, offId: 209, on: on),
    );
  }
  final result = _engine.play(
    home: home,
    away: away,
    rng: SeededRng.forFixture(0xB0A7, seed),
    subs: subs,
    neutralVenue: true,
    bigMatch: true,
    extraTimeIfLevel: seed % 3 == 0,
  );
  return (
    result: result,
    lineups: matchLineupsOf(
      home: home,
      away: away,
      homeBench: homeBench,
      awayBench: awayBench,
      result: result,
    ),
  );
}

PitchScript _script(_Match m, PitchSpeed speed, {int seed = 7}) =>
    StoryLayer.build(
      result: m.result,
      lineups: m.lineups,
      pacer: PitchPacer(m.result, speed),
      seed: seed,
    );

Duration _at(double t) => Duration(microseconds: (t * 1e6).round());

/// One match's picture read back, the way a viewer would judge it.
class _Audit {
  _Audit(this.s, this.label);

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

  void run() {
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
          _freeKick(w, first);
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
      // Key moments (goals, penalties, big saves): reached by a cut, or
      // played on from what came before.
      final key = w.moments.any(
        (m) =>
            m is ShotMoment &&
            (m.outcome == ShotOutcome.goal ||
                m.origin == ShotOrigin.penalty ||
                (m.outcome == ShotOutcome.saved && m.xg >= 0.15)),
      );
      if (key) count(cut ? 'key moment after a cut' : 'key moment continuous');
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
      final k = _deadKick(
        w,
        sp.takerId,
        thrown: sp.kind == SetPieceKind.longThrow,
      );
      if (k != null) from = k.t0;
    }
    if (m.origin == ShotOrigin.penalty) {
      // The kick from the mark, not the ball set down on it.
      final dir = dirOf(m.teamNationId, w.start);
      final spot = Offset2(
        depthToX(penaltySpotDepth, dir),
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
            crossLat.abs() > goalHalfWidth - 0.11 ||
            crossH! > crossbarHeight - 0.11 ||
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
            (crossLat.abs() <= goalHalfWidth + 0.11 &&
                crossH! <= crossbarHeight + 0.11)) {
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
            (l.abs() - goalHalfWidth).abs() < 0.15 &&
            shot.toHeight <= crossbarHeight;
        final bar =
            l.abs() <= goalHalfWidth &&
            (shot.toHeight - crossbarHeight).abs() < 0.05;
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
    // His kick from the arc, whichever way the ball got there.
    final cdir = dirOf(sp.teamNationId, w.start);
    FlightPhase? fromArc;
    for (final f in flights(w.start, _until(w))) {
      if (f.fromActor == idx(sp.takerId) &&
          depth(f.from, cdir) > PitchDims.length - 1.5 &&
          lat(f.from, cdir).abs() > 32.5) {
        fromArc = f;
        break;
      }
    }
    final kick = fromArc ?? _deadKick(w, sp.takerId);
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

  void _freeKick(StagedWindow w, SetPieceMoment sp) {
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

  void _throw(StagedWindow w, SetPieceMoment sp) {
    // His ball from the touchline.
    final tdir = dirOf(sp.teamNationId, w.start);
    FlightPhase? fromLine;
    for (final f in flights(w.start, _until(w))) {
      if (f.fromActor == idx(sp.takerId) &&
          f.toActor != null &&
          lat(f.from, tdir).abs() > 31.5) {
        fromLine = f;
        break;
      }
    }
    final kick = fromLine ?? _deadKick(w, sp.takerId, thrown: true);
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
    final spot = Offset2(depthToX(penaltySpotDepth, dir), PitchDims.width / 2);
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
      final d = depth(p, dir);
      final l = lat(p, dir);
      if (f.keepers.contains(id)) {
        if (team(s.actorIndexOf(id)!) != m.teamNationId) {
          if (PitchDims.length - d > 1.0 || l.abs() > goalHalfWidth) {
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

void main() {
  test('every moment type, staged over 200 seeded matches, shows its record', () {
    final counts = <String, int>{};
    final worst = <String, double>{};
    final problems = <String>[];
    final invalid = <String>[];
    for (var seed = 0; seed < 200; seed++) {
      final m = _match(seed);
      final speed = PitchSpeed.values[seed % 3];
      final s = _script(m, speed, seed: seed);
      final v = PitchScriptValidator.validate(s, limit: 5);
      if (v.isNotEmpty) invalid.add('match $seed ($speed): ${v.join('; ')}');
      final a = _Audit(s, 'match $seed ($speed)')..run();
      problems.addAll(a.problems);
      a.counts.forEach((k, n) => counts[k] = (counts[k] ?? 0) + n);
      a.worst.forEach((k, x) => worst[k] = math.max(worst[k] ?? x, x));
    }
    final keys = counts.keys.toList()..sort();
    // Findings by kind, numbers and names apart.
    final kinds = <String, int>{};
    for (final p in [...problems, ...invalid.expand((x) => x.split('; '))]) {
      final k = p
          .replaceAll(RegExp(r'^match \d+ \(PitchSpeed\.\w+\)( \S+)?:? '), '')
          .replaceAll(RegExp(r'minute \S+: '), '')
          .replaceAll(RegExp(r'-?\d+(\.\d+)?'), '#');
      kinds[k] = (kinds[k] ?? 0) + 1;
    }
    final byCount = kinds.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    // ignore: avoid_print
    print([for (final e in byCount) '${e.value} x ${e.key}'].join('\n'));
    // ignore: avoid_print
    print(
      'counts: ${[for (final k in keys) '$k ${counts[k]}'].join(', ')}\n'
      'worst: ${[for (final e in worst.entries) '${e.key} ${e.value.toStringAsFixed(2)}'].join(', ')}\n'
      'validator: ${invalid.length} matches; staging: ${problems.length} '
      'findings\n${invalid.take(10).join('\n')}\n${problems.take(40).join('\n')}',
    );
    // Every invariant holds in every match.
    expect(invalid, isEmpty);
    // What the engine recorded always reaches the screen: these findings
    // are never allowed, in any match.
    const mustNot = [
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
    ];
    final outcome = [
      for (final p in problems)
        if (mustNot.any(p.contains)) p,
    ];
    // ignore: avoid_print
    print(
      'outcome findings ${outcome.length}; other staging findings '
      '${problems.length - outcome.length}',
    );
    expect(outcome, isEmpty);
    // The rest (a fouler a stride short, a kick-off a moment that cuts in
    // at once) are bounded.
    expect(problems.length - outcome.length, lessThan(40));
    for (final k in [
      'shot openPlay',
      'corner',
      'free kick direct',
      'free kick crossed',
      'penalty',
      'long throw',
      'foul + card',
      'offside',
      'sub',
      'injury',
      'shot goal',
      'shot saved',
      'shot wide',
      'shot blocked',
      'shot woodwork',
      'goal kick-off',
    ]) {
      expect(counts[k] ?? 0, greaterThan(0), reason: '$k never staged');
    }
  });

  test('the same seed gives the same frames', () {
    final m = _match(17);
    final a = _script(m, PitchSpeed.slow, seed: 5);
    final b = _script(m, PitchSpeed.slow, seed: 5);
    expect(b.keyframes.length, a.keyframes.length);
    for (var t = 0.0; t < a.totalSeconds; t += 0.21) {
      final fa = a.sample(_at(t));
      final fb = b.sample(_at(t));
      expect(fb.players, fa.players);
      expect(fb.ball, fa.ball);
      expect(fb.ballHeight, fa.ballHeight);
      expect(fb.tagged, fa.tagged);
    }
  });

  test('a moment staged from part-way through still shows its record', () {
    var resumed = 0;
    final kinds = <String>{};
    for (var seed = 0; seed < 24 && resumed < 40; seed++) {
      final m = _match(seed);
      final speed = PitchSpeed.values[seed % 3];
      final first = _script(m, speed, seed: seed);
      for (final w in first.windows) {
        if (w.moments.isEmpty) continue;
        final k = w.moments.first;
        final key = switch (k) {
          ShotMoment(:final origin) => 'shot ${origin.name}',
          SetPieceMoment(:final kind) => kind.name,
          _ => k.runtimeType.toString(),
        };
        if (kinds.contains('$key $seed')) continue;
        kinds.add('$key $seed');
        for (final frac in [0.3, 0.7]) {
          final at = w.start + (w.end - w.start) * frac;
          final state = first.stateAt(_at(at));
          final second = StoryLayer.build(
            result: m.result,
            lineups: m.lineups,
            pacer: PitchPacer(m.result, speed),
            seed: seed,
            resumeFrom: state,
          );
          resumed++;
          final seam = second.sample(_at(second.start));
          for (final e in state.players.entries) {
            expect(
              seam.players[e.key]!.distanceTo(e.value),
              lessThan(1e-6),
              reason: 'player ${e.key}, match $seed, $key at $frac',
            );
          }
          expect(
            seam.ball.distanceTo(state.ball),
            lessThan(1e-6),
            reason: 'ball, match $seed, $key at $frac',
          );
          expect(
            PitchScriptValidator.validate(second),
            isEmpty,
            reason: 'match $seed, $key resumed at $frac',
          );
          // A goal still ends in the net.
          for (final x in w.moments) {
            if (x is ShotMoment && x.outcome == ShotOutcome.goal) {
              final f = second.sample(_at(w.end - 1e-3));
              final dir = attackDir(
                home: x.teamNationId == second.homeNationId,
                minute: x.minute,
              );
              expect(
                xToDepth(f.ball.x, dir),
                greaterThan(PitchDims.length),
                reason: 'match $seed: resumed goal not in the net',
              );
            }
          }
        }
      }
    }
    expect(resumed, greaterThan(20));
  });

  test('a resume exactly on a kick-off does not play it again', () {
    for (var seed = 0; seed < 30; seed++) {
      final m = _match(seed);
      final first = _script(m, PitchSpeed.mid, seed: seed);
      // The intervals and the kick-offs after goals.
      final goals = [
        for (final w in first.windows)
          if (w.moments.any(
            (x) => x is ShotMoment && x.outcome == ShotOutcome.goal,
          ))
            for (final c in first.cuts)
              if ((c - w.end).abs() < 1e-6) c,
      ];
      if (goals.isEmpty) continue;
      for (final r in [...first.resets, ...goals]) {
        final state = first.stateAt(_at(r));
        final second = StoryLayer.build(
          result: m.result,
          lineups: m.lineups,
          pacer: PitchPacer(m.result, PitchSpeed.mid),
          seed: seed,
          resumeFrom: state,
        );
        expect(second.start, closeTo(r, 1e-5));
        // The frames at the kick-off: never the play before it again (a
        // moment opening there may still cut to itself, as it did).
        int at(PitchScript x) =>
            x.keyframes.where((f) => (f.t - r).abs() < 1e-5).length;
        expect(
          at(second),
          lessThanOrEqualTo(at(first)),
          reason: 'replayed at $r',
        );
        final seam = second.sample(_at(r));
        for (final e in state.players.entries) {
          expect(seam.players[e.key]!.distanceTo(e.value), lessThan(1e-6));
        }
        expect(PitchScriptValidator.validate(second), isEmpty);
      }
      return;
    }
    fail('no match with a goal in 30');
  });

  test('a pass whose receiver walks off mid-flight goes to a team-mate', () {
    var redirected = 0;
    for (var seed = 0; seed < 60 && redirected == 0; seed++) {
      final m = _match(seed);
      if (!m.result.events.any((e) => e.type == MatchEventType.injury)) {
        continue;
      }
      final s = StoryLayer.build(
        result: m.result,
        lineups: m.lineups,
        pacer: PitchPacer(m.result, PitchSpeed.slow),
        seed: 3,
        stager: const _PassToLeaver(),
      );
      expect(PitchScriptValidator.validate(s), isEmpty, reason: 'match $seed');
      // No flight of no length, the re-aimed one included.
      for (final p in s.ballPhases) {
        expect(p.t1, greaterThan(p.t0 + 1e-9));
      }
      for (final w in s.windows) {
        final off = w.injury?.playerId;
        if (off == null) continue;
        final oi = s.actorIndexOf(off)!;
        for (final p in s.ballPhases) {
          if (p is! FlightPhase || (p.t0 - w.end).abs() > 1e-6) continue;
          // Re-aimed where it was as he set off, at a team-mate.
          if (p.toActor != null &&
              p.toActor != oi &&
              s.actorList[p.toActor!].teamNationId ==
                  s.actorList[oi].teamNationId) {
            redirected++;
          }
        }
      }
    }
    expect(redirected, greaterThan(0));
  });

  test('a stand-in keeps goal until the keeper coming on takes over', () {
    final home = _team(1, 75, Formation.f442, const TacticalInstructions());
    final away = _team(2, 75, Formation.f433, const TacticalInstructions());
    final backup = player(id: 150, nationId: 1, position: PlayerPosition.gk);
    const r = MatchResult(
      homeScore: 0,
      awayScore: 0,
      events: [
        MatchEvent(
          minute: 30,
          type: MatchEventType.substitution,
          teamNationId: 1,
          playerId: 150,
          playerName: 'Backup',
          secondaryPlayerId: 100,
          secondaryName: 'Keeper',
        ),
      ],
      homeShots: 0,
      awayShots: 0,
      homePossession: 50,
    );
    final s = StoryLayer.build(
      result: r,
      lineups: matchLineupsOf(
        home: home,
        away: away,
        homeBench: [backup.id],
      ),
      pacer: PitchPacer(r, PitchSpeed.mid),
      seed: 9,
    );
    expect(PitchScriptValidator.validate(s), isEmpty);
    Set<int> homeKeepers(double t) => {
      for (final id in s.keepersAt(t))
        if (s.actorList[s.actorIndexOf(id)!].teamNationId == 1) id,
    };
    final off = s.departures[100]!;
    final on = s.arrivals[150]!;
    double? takeover;
    // From the keeper's walk until the end, exactly one man keeps goal.
    for (final f in s.keyframes) {
      if (f.t < off) continue;
      final k = homeKeepers(f.t);
      expect(k.length, 1, reason: 'keepers $k at ${f.t}');
      if (takeover == null && k.contains(150)) takeover = f.t;
    }
    expect(takeover, isNotNull);
    expect(takeover!, greaterThanOrEqualTo(on));
    final standIn = homeKeepers(on + 0.3).single;
    expect(standIn, isNot(anyOf(100, 150)));
    // The stand-in goes back to his own place afterwards.
    final dir = attackDir(home: true, minute: 31);
    final before = xToDepth(s.sample(_at(takeover)).players[standIn]!.x, dir);
    final later = xToDepth(
      s.sample(_at(takeover + 6)).players[standIn]!.x,
      dir,
    );
    expect(later, greaterThan(before + 4));
  });

  test('a wall stands 9.15 m from a direct free kick, 3 to 5 men', () {
    var walls = 0;
    for (var seed = 0; seed < 120 && walls < 12; seed++) {
      final m = _match(seed);
      final s = _script(m, PitchSpeed.values[seed % 3], seed: seed);
      for (final w in s.windows) {
        if (w.moments.length < 2) continue;
        final sp = w.moments.first;
        final shot = w.moments[1];
        if (sp is! SetPieceMoment ||
            shot is! ShotMoment ||
            shot.origin != ShotOrigin.directFreeKick) {
          continue;
        }
        final a = _Audit(s, 'match $seed').._freeKick(w, sp);
        expect(a.problems, isEmpty);
        walls++;
      }
    }
    expect(walls, greaterThan(0));
  });
}

/// A stager that, in an injury's window, passes to the man hurt so that
/// the ball lands after he has started to walk off.
class _PassToLeaver implements MomentStager {
  const _PassToLeaver();

  @override
  StagedPlan stage(StagingContext context) => _PassToLeaverPlan(context);
}

class _PassToLeaverPlan implements StagedPlan {
  _PassToLeaverPlan(this.c);
  final StagingContext c;
  bool done = false;

  @override
  PlayerDrive? drive(int playerId, double t, ScriptState now) => null;

  @override
  bool settled(double t, ScriptState now) => true;

  @override
  BallAction? ball(double t, ScriptState now) {
    final off = c.window.injury?.playerId;
    if (done || off == null) return null;
    final car = now.carrierId;
    if (car == null || car == off) return null;
    if (now.teams[car] != now.teams[off]) return null;
    final p = now.players[off];
    if (p == null || p.distanceTo(now.ball) < 9) return null;
    if (t < c.window.end - 0.3) return null;
    done = true;
    return PassAction(toPlayerId: off, arriveAt: c.window.end + 0.8);
  }
}
