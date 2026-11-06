part of '../moment_staging.dart';

/// A shot from the moment it is struck: where it goes for its outcome, what
/// the keeper and a blocker do, and how its ending hands the ball on.
class _Shot {
  _Shot(this.p, this.m);

  final _Plan p;
  final ShotMoment m;

  bool struck = false;
  double struckAt = 0;
  int? keeper;
  int? blocker;
  Offset2? keeperTo;
  double keeperSpeed = 8.8;
  bool parry = false;
  bool deflectDone = false;
  bool afterDone = false;
  double? landedAt;

  bool get goal => m.outcome == ShotOutcome.goal;

  /// Struck, arrived, and the ball in the net or with somebody.
  bool settledNow(ScriptState now) =>
      struck && now.flight == null && (goal || now.carrierId != null);

  /// How long its ending needs after the ball arrives, in screen seconds.
  double get tail => switch (m.outcome) {
    ShotOutcome.goal => 1.2,
    ShotOutcome.saved => 0.2,
    ShotOutcome.wide => 0.7,
    ShotOutcome.woodwork => 0.8,
    ShotOutcome.blocked => 0.5,
  };

  double speedFor({bool header = false}) {
    if (header) return 14 + 3 * p.rng.nextDouble();
    return switch (m.origin) {
      ShotOrigin.penalty => m.outcome == ShotOutcome.saved ? 19 : 23,
      ShotOrigin.directFreeKick => 22 + 3 * p.rng.nextDouble(),
      _ => 23 + 6 * p.rng.nextDouble(),
    };
  }

  /// A defending outfielder to stand in the shot's path from [from].
  int? pickBlocker(ScriptState now, Offset2 from, {Set<int> skip = const {}}) {
    final g = p.goal;
    final ahead = (g - from).unit;
    int? best;
    var bestScore = double.infinity;
    for (final id in p.available(now, p.opp)) {
      if (now.keepers.contains(id) || skip.contains(id)) continue;
      final q = now.players[id]!;
      final rel = q - from;
      final along = rel.x * ahead.x + rel.y * ahead.y;
      final across = (rel.x * ahead.y - rel.y * ahead.x).abs();
      final score = (along < 0.5 ? 30 : 0) + across + (along - 2.0).abs() * 0.7;
      if (score < bestScore) {
        bestScore = score;
        best = id;
      }
    }
    return best;
  }

  /// Where the keeper sets himself against a ball at [b]: on the line from
  /// the middle of his goal toward it, a little off his line.
  Offset2 keeperSet(Offset2 b) {
    final g = p.goal;
    final dist = b.distanceTo(g);
    final off = (dist * 0.12).clamp(1.0, 4.0);
    var spot = g + (b - g).unit * off;
    final lat = p
        .latOf(spot)
        .clamp(-PitchDims.goalHalfWidth + 0.6, PitchDims.goalHalfWidth - 0.6);
    spot = p.at(math.min(p.depthOf(spot), _goalLine - 0.6), lat);
    return spot;
  }

  /// The strike from wherever the ball is now (at the shooter's feet, met
  /// in the air at [fromHeight], or lying for a dead-ball kick by [by]).
  KickAction strike(
    double t,
    ScriptState now, {
    double fromHeight = 0,
    int? by,
    double? speed,
    double? wallDepth,
  }) {
    struck = true;
    struckAt = t;
    p.cue(t, PitchCueKind.shot, m.shooterId);
    final b = now.ball;
    final bd = p.depthOf(b);
    final bl = p.latOf(b);
    final r = p.rng;
    keeper = p.keeperOf(now, p.opp, m.keeperId);
    final kp = keeper == null ? null : now.players[keeper];
    final kLat = kp == null ? 0.0 : p.latOf(kp);
    final v = speed ?? speedFor(header: fromHeight > 1);
    // It arrives inside its window, whatever comes next: a goal half a
    // second before the cut to the kick-off, anything else before the
    // next moment (or an interval) may cut in. Faster if it has to, never
    // above 34 m/s.
    final limit = math.min(p.end, p.c.hardEnd) - (goal ? 0.5 : 0.05);
    double arr(double d, double vv, {double atLeast = 0}) {
      final quickest = d / 34;
      final want = math.max(d / vv, atLeast);
      return t + want.clamp(quickest, math.max(quickest, limit - t));
    }

    // Clear a wall [wallDepth] in front (a free kick): high enough there.
    double peakOver(double lineDepth, double floor) {
      if (wallDepth == null) return floor;
      final u = (wallDepth - bd) / math.max(lineDepth - bd, 1e-3);
      if (u <= 0 || u >= 1) return floor;
      final need = (2.4 - fromHeight * (1 - u)) / (4 * u * (1 - u));
      return math.max(floor, need);
    }

    // The point on the goal line, then a point just beyond it on the same
    // line: the ball's straight path crosses the line exactly there.
    Offset2 beyond(double lat, double extra) {
      final c = p.at(_goalLine, lat);
      final span = math.max(_goalLine - bd, 0.5);
      final k = (span + extra) / span;
      return b + (c - b) * k;
    }

    switch (m.outcome) {
      case ShotOutcome.goal:
        final sign = kLat > 0.4
            ? -1.0
            : kLat < -0.4
            ? 1.0
            : (r.chance(0.5) ? 1.0 : -1.0);
        final lane = sign * (1.6 + 1.5 * r.nextDouble());
        final to = beyond(lane, 0.9);
        var peak = peakOver(_goalLine, fromHeight > 1 ? 0.2 : r.nextDouble());
        // Under the bar where it crosses the line.
        final u = (_goalLine - bd) / math.max(p.depthOf(to) - bd, 1e-3);
        double h(double pk) => fromHeight * (1 - u) + 4 * pk * u * (1 - u);
        while (peak > 0 && h(peak) > PitchDims.crossbarHeight - 0.35) {
          peak *= 0.8;
          if (peak < 0.05) peak = 0;
        }
        if (kp != null) {
          // He goes the right way and is beaten, or the wrong way.
          final dive = r.chance(0.5) ? lane * 0.45 : -lane * 0.5;
          keeperTo = p.at(p.depthOf(kp), dive);
          keeperSpeed = 6;
        }
        return KickAction(
          shot: true,
          to: to,
          arriveAt: arr(b.distanceTo(to), v),
          peak: peak,
          fromHeight: fromHeight,
          byPlayerId: by,
        );
      case ShotOutcome.saved:
        if (kp != null) {
          final reach =
              (kLat + (r.chance(0.5) ? 1 : -1) * (0.4 + 1.4 * r.nextDouble()))
                  .clamp(
                    -PitchDims.goalHalfWidth + 0.5,
                    PitchDims.goalHalfWidth - 0.5,
                  );
          keeperTo = p.at(p.depthOf(kp), reach);
          keeperSpeed = 8.8;
          parry = r.chance(0.4) && p.owedSide(now) == p.side;
          final d = b.distanceTo(kp);
          return KickAction(
            shot: true,
            toPlayerId: keeper,
            arriveAt: arr(d, math.min(v, 21), atLeast: 0.42),
            peak: peakOver(p.depthOf(kp), fromHeight > 1 ? 0.2 : 0.4),
            fromHeight: fromHeight,
            byPlayerId: by,
          );
        }
        // Nobody in goal: it is cleared off the line instead.
        final saver = pickBlocker(now, b);
        keeper = saver;
        return KickAction(
          shot: true,
          toPlayerId: saver ?? m.shooterId,
          arriveAt: t + 0.5,
          fromHeight: fromHeight,
          byPlayerId: by,
        );
      case ShotOutcome.wide:
        final overBar = bd < 92 && r.chance(0.35);
        if (overBar) {
          final lane = (r.nextDouble() * 2 - 1) * 2.8;
          final to = beyond(lane, 6);
          final u = (_goalLine - bd) / math.max(p.depthOf(to) - bd, 1e-3);
          final target = 2.9 + 0.8 * r.nextDouble();
          final peak = ((target - fromHeight * (1 - u)) / (4 * u * (1 - u)))
              .clamp(0.0, 9.0);
          if (kp != null) {
            keeperTo = p.at(p.depthOf(kp), lane * 0.3);
            keeperSpeed = 4;
          }
          return KickAction(
            shot: true,
            to: to,
            arriveAt: arr(b.distanceTo(to), v),
            peak: peak,
            fromHeight: fromHeight,
            byPlayerId: by,
          );
        }
        final sign = bl.abs() > 2 ? bl.sign : (r.chance(0.5) ? 1.0 : -1.0);
        final lane =
            sign * (PitchDims.goalHalfWidth + 0.6 + 3 * r.nextDouble());
        final to = beyond(lane, 2.5);
        if (kp != null) {
          keeperTo = p.at(p.depthOf(kp), sign * 1.2);
          keeperSpeed = 4;
        }
        return KickAction(
          shot: true,
          to: to,
          arriveAt: arr(b.distanceTo(to), v),
          peak: peakOver(
            _goalLine,
            fromHeight > 1 ? 0.2 : 0.5 * r.nextDouble(),
          ),
          fromHeight: fromHeight,
          byPlayerId: by,
        );
      case ShotOutcome.woodwork:
        final bar = r.chance(0.3);
        final double lane;
        final double height;
        if (bar) {
          lane = (r.nextDouble() * 2 - 1) * 3.0;
          height = PitchDims.crossbarHeight;
        } else {
          lane =
              (bl.abs() > 2 ? bl.sign : (r.chance(0.5) ? 1.0 : -1.0)) *
              PitchDims.goalHalfWidth;
          height = 0.3 + 1.6 * r.nextDouble();
        }
        final to = p.at(_goalLine - 0.12, lane);
        if (kp != null) {
          keeperTo = p.at(p.depthOf(kp), lane * 0.4);
          keeperSpeed = 6;
        }
        return KickAction(
          shot: true,
          to: to,
          arriveAt: arr(b.distanceTo(to), v),
          peak: peakOver(_goalLine, 0),
          fromHeight: fromHeight,
          toHeight: height,
          byPlayerId: by,
        );
      case ShotOutcome.blocked:
        // Whoever is nearest in its path: the man sent to block it, or one
        // closer still.
        final cand = pickBlocker(now, b);
        double away(int? id) {
          final q = id == null ? null : now.players[id];
          if (q == null) return double.infinity;
          final rel = q - b;
          final ahead = (p.goal - b).unit;
          final along = rel.x * ahead.x + rel.y * ahead.y;
          return along < 0.3 ? double.infinity : q.distanceTo(b);
        }

        if (blocker == null || away(cand) < away(blocker)) blocker = cand;
        final bk = blocker;
        if (bk == null) {
          // Nobody to block it: it is blocked by the keeper's legs.
          keeper = p.keeperOf(now, p.opp, m.keeperId);
          return KickAction(
            shot: true,
            toPlayerId: keeper ?? m.shooterId,
            arriveAt: t + 0.5,
            byPlayerId: by,
          );
        }
        final d = b.distanceTo(now.players[bk]!);
        return KickAction(
          shot: true,
          toPlayerId: bk,
          arriveAt: arr(d, v, atLeast: 0.12),
          peak: fromHeight > 1 ? 0 : 0.2,
          fromHeight: fromHeight,
          toHeight: math.min(fromHeight, 1.2),
          byPlayerId: by,
        );
    }
  }

  /// The keeper's (and the blocker's) moves once the shot is struck.
  PlayerDrive? drive(int id, double t, ScriptState now) {
    if (!struck) return null;
    if (id == keeper && keeperTo != null && !afterDone) {
      if (now.carrierId == id) return (target: now.players[id]!, maxSpeed: 0);
      return (target: keeperTo!, maxSpeed: keeperSpeed);
    }
    if (id == blocker && now.flight != null) {
      return (target: now.players[id]!, maxSpeed: 0);
    }
    return null;
  }

  /// What the ball does once the shot has arrived.
  BallAction? after(double t, ScriptState now) {
    if (now.flight != null) return null;
    landedAt ??= t;
    switch (m.outcome) {
      case ShotOutcome.goal:
        p.cue(t, PitchCueKind.goal, m.shooterId);
        return null;
      case ShotOutcome.saved:
        if (afterDone || !parry || now.carrierId == null) {
          afterDone = true;
          return null;
        }
        afterDone = true;
        final k = now.carrierId!;
        final kp = now.players[k]!;
        final mates = p.available(now, p.side).where((id) {
          final d = now.players[id]!.distanceTo(kp);
          return d >= 5 && d <= 22;
        }).toList();
        final to = p.nearest(now, mates, kp);
        if (to == null) return null;
        final d = now.players[to]!.distanceTo(kp);
        return KickAction(
          toPlayerId: to,
          arriveAt: t + math.max(d / 13, 0.3),
          peak: 0.8,
        );
      case ShotOutcome.wide:
        if (now.carrierId != null) {
          afterDone = true;
          return null;
        }
        if (t < landedAt! + 0.25) return null;
        // The ball comes back for the goal kick.
        final k = p.keeperOf(now, p.opp, m.keeperId);
        if (k == null) return null;
        final d = now.players[k]!.distanceTo(now.ball);
        return KickAction(
          toPlayerId: k,
          arriveAt: t + math.max(d / 14, 0.25),
          peak: 0.6,
        );
      case ShotOutcome.woodwork:
        if (now.carrierId != null || afterDone) return null;
        afterDone = true;
        final b = now.ball;
        final out = p.at(
          _goalLine - 7 - 5 * p.rng.nextDouble(),
          p.latOf(b) * 0.6 + (p.rng.nextDouble() * 2 - 1) * 5,
        );
        final team = p.owedSide(now);
        final to = p.nearest(now, p.available(now, team), out);
        if (to == null) return null;
        final d = now.players[to]!.distanceTo(b);
        final h = p.depthOf(b) > _goalLine - 0.5
            ? PitchDims.crossbarHeight
            : 0.0;
        return KickAction(
          toPlayerId: to,
          arriveAt: t + math.max(d / 15, 0.3),
          peak: 1,
          fromHeight: h > 0 ? h : 0.8,
        );
      case ShotOutcome.blocked:
        final car = now.carrierId;
        if (car == null || deflectDone) return null;
        deflectDone = true;
        if (p.owedSide(now) == p.opp) return null;
        // It breaks back to an attacker.
        final cp = now.players[car]!;
        final mates = p.available(now, p.side).where((id) {
          final d = now.players[id]!.distanceTo(cp);
          return d >= 3 && d <= 20;
        }).toList();
        final to = p.nearest(now, mates, cp);
        if (to == null) return null;
        final d = now.players[to]!.distanceTo(cp);
        return KickAction(
          toPlayerId: to,
          arriveAt: t + math.max(d / 14, 0.25),
          peak: 0.6,
        );
    }
  }

  /// The scorer and his team-mates celebrating, once it is in.
  PlayerDrive? celebrate(int id, ScriptState now) {
    if (!goal || !struck || landedAt == null) return null;
    final s = now.players[m.shooterId];
    if (s == null) return null;
    if (id == m.shooterId) {
      final sign = p.latOf(s) >= 0 ? 1.0 : -1.0;
      return (target: p.at(_goalLine - 8, sign * 27), maxSpeed: 6);
    }
    if (now.teams[id] == p.side && !now.keepers.contains(id)) {
      final q = now.players[id]!;
      if (q.distanceTo(s) < 30) return (target: s, maxSpeed: 5);
    }
    return null;
  }
}

/// Where in [zone] a shot from it is struck, for the side attacking [dir]
/// in [p]'s frame.
Offset2 _strikePoint(_Plan p, PitchZone zone) {
  final r = p.rng;
  double between(double lo, double hi) => lo + (hi - lo) * r.nextDouble();
  final (depth, lat) = switch (zone) {
    PitchZone.sixYard => (between(99.5, 101), between(-3.5, 3.5)),
    PitchZone.boxCentre => (between(90.5, 96), between(-5.5, 5.5)),
    PitchZone.boxLeft => (between(90, 97.5), between(-15, -7)),
    PitchZone.boxRight => (between(90, 97.5), between(7, 15)),
    PitchZone.edgeOfBox => (between(81.5, 87.5), between(-9, 9)),
    PitchZone.longRange => (between(72, 80), between(-11, 11)),
    PitchZone.wideLeft => (between(88, 96), between(-23, -17)),
    PitchZone.wideRight => (between(88, 96), between(17, 23)),
    PitchZone.midfield => (between(62, 70), between(-10, 10)),
  };
  return p.at(depth, lat);
}

// ---------------------------------------------------------------------------

/// A shot from open play (or a second ball after a set piece): the ball
/// worked to the shooter (through the assister, for a goal that has one),
/// carried into the zone it was recorded in, struck.
class _OpenShotPlan extends _Plan {
  _OpenShotPlan(StagingContext c, this.m) : super(c, m.teamNationId) {
    shot = _Shot(this, m);
    zone = _strikePoint(this, m.zone);
    final e = c.entry;
    final a = m.assistId;
    if (m.outcome == ShotOutcome.goal &&
        a != null &&
        a != m.shooterId &&
        onPitch(e, a) &&
        e.teams[a] == side) {
      assister = a;
    }
    earliest = start + (0.3 * len).clamp(0.15, 1.4);
    final flightEst = zone.distanceTo(goal) / 24;
    deadline = end - flightEst - shot.tail;

    if (resumed) _readResume(e);
  }

  final ShotMoment m;
  late final _Shot shot;
  late final Offset2 zone;
  int? assister;
  int? crosser;
  bool delivered = false;
  late final double earliest;
  late final double deadline;

  @override
  bool settled(double t, ScriptState now) => shot.settledNow(now);

  void _readResume(ScriptState e) {
    final f = e.flight;
    // A ball on its way from the assister to the scorer: set up already.
    if (f != null && f.fromId == assister && f.toId == m.shooterId) {
      delivered = true;
    }
    if (f != null &&
        f.fromId == m.shooterId &&
        !f.pass &&
        f.toId != m.shooterId) {
      shot.struck = true;
    } else if (e.carrierId == null &&
        f == null &&
        (depthOf(e.ball) > _goalLine - 0.5)) {
      shot.struck = true;
    } else if (e.carrierId == m.shooterId) {
      delivered = true;
    }
    if (shot.struck) {
      shot.keeper = keeperOf(e, opp, m.keeperId);
      // His dive follows the ball already struck.
      final kp = shot.keeper == null ? null : e.players[shot.keeper];
      if (f != null && kp != null) {
        final lane = latOf(f.lead).clamp(
          -PitchDims.goalHalfWidth + 0.5,
          PitchDims.goalHalfWidth - 0.5,
        );
        shot.keeperTo = at(
          depthOf(kp),
          m.outcome == ShotOutcome.saved ? lane : lane * 0.4,
        );
        shot.keeperSpeed = m.outcome == ShotOutcome.saved ? 8.8 : 6;
      }
    }
  }

  bool? cutWanted;

  /// Whether the shot cannot be reached from here in the time it has.
  bool _needCut(ScriptState now) {
    if (resumed) return false;
    final holder = assister ?? m.shooterId;
    final hp = now.players[holder];
    if (hp == null) return false;
    var need = ballTo(now, holder) + hp.distanceTo(zone) / 6.5 * 0.6;
    if (assister != null) need += 0.7;
    need += zone.distanceTo(goal) / 24 + shot.tail;
    if (m.outcome == ShotOutcome.blocked) {
      // Somebody has to get across to block it.
      final lane = zone + (goal - zone).unit * 2.0;
      final defs = available(now, opp).where((o) => !now.keepers.contains(o));
      final b = nearest(now, defs, lane);
      final bp = b == null ? null : now.players[b];
      if (bp != null) need = math.max(need, bp.distanceTo(lane) / 7 + 0.5);
    }
    return need > room + 0.2;
  }

  /// The latest the shot can still be worked and struck in its window.
  double get strikeBy {
    final flight = switch (m.outcome) {
      ShotOutcome.goal => 1.1,
      ShotOutcome.blocked => 0.3,
      ShotOutcome.saved => 0.7,
      _ => 0.9,
    };
    return end - flight - (assister != null && !delivered ? 0.55 : 0);
  }

  bool lateCut = false;
  bool onsideCut = false;

  /// The cut to the shot about to happen: the man who has the ball (the
  /// assister, for a goal he sets up) in the zone with it at his feet, the
  /// scorer onside ahead of him, a blocker on the shot's path.
  CutAction _phaseCut(ScriptState now) {
    final holder = assister != null && !delivered ? assister! : m.shooterId;
    final setUp = holder != m.shooterId;
    final back = setUp ? 10.0 : 2.0;
    final spot = at(
      math.max(depthOf(zone) - back, PitchDims.length / 2),
      latOf(zone) * (setUp ? 0.6 : 1),
    );
    final extra = <int, Offset2>{};
    if (m.outcome == ShotOutcome.blocked) {
      // The man who blocks it is right on him.
      final lane = spot + (goal - spot).unit * 2.0;
      final defs = available(now, opp).where((o) => !now.keepers.contains(o));
      final b = nearest(now, defs, lane);
      if (b != null) {
        extra[b] = lane;
        shot.blocker = b;
      }
    }
    // The scorer up toward the zone, held onside by the cut itself.
    if (setUp) extra[m.shooterId] = at(depthOf(zone) - 1, latOf(zone));
    return cutToPhase(
      now,
      holder,
      spot,
      extra: extra,
      onside: {if (setUp) m.shooterId},
    );
  }

  @override
  BallAction? ball(double t, ScriptState now) {
    if (shot.struck) return shot.after(t, now);
    final s = m.shooterId;
    final car = now.carrierId;
    // The ball at a man's feet, or lying at them after a cut.
    bool atFeet(int id) {
      if (car == id) return true;
      final q = now.players[id];
      return car == null &&
          now.flight == null &&
          q != null &&
          q.distanceTo(now.ball) < 1.3;
    }

    cutWanted ??= _needCut(now);
    // A ball in the air comes down before any cut.
    if (cutWanted! && !sceneCut && settledIn(t)) {
      if (landing(now)) return null;
      return _phaseCut(now);
    }
    // Late: by the time it could be struck and arrive, the window is out
    // (a step's grace, and a goal half a second before its cut).
    final toGoal = now.ball.distanceTo(goal);
    final flight = switch (m.outcome) {
      ShotOutcome.goal => toGoal / 30 + 0.5,
      ShotOutcome.blocked => 0.2,
      ShotOutcome.saved => math.max(toGoal / 21, 0.42),
      _ => toGoal / 30,
    };
    final setUp = assister != null && !delivered ? 0.6 : 0.0;
    // A ball still in the air has to come down first.
    final f = now.flight;
    final pending = f == null ? 0.0 : math.max(0.0, f.t1 - t);
    final late =
        (t >= strikeBy - 1e-9 || t + pending + flight + setUp + 0.3 >= end) &&
        settledIn(t);
    // Never a shot from his own half: a man that far out is not where it
    // happened.
    final inRange = toGoal <= math.max(zone.distanceTo(goal) + 12, 32);
    final ready =
        atFeet(s) &&
        inRange &&
        (assister == null || delivered) &&
        (m.outcome != ShotOutcome.blocked || _blockerInPath(now));
    if (late && !ready && !lateCut) {
      // Out of time: the picture cuts to it about to happen.
      final assisting = assister != null && !delivered && atFeet(assister!);
      if (!assisting) {
        if (landing(now)) return null;
        lateCut = true;
        return _phaseCut(now);
      }
    }
    if (m.outcome == ShotOutcome.blocked && shot.blocker == null) {
      // The defender nearest the shot's path closes it.
      final lane = zone + (goal - zone).unit * 2.0;
      shot.blocker = nearest(
        now,
        available(now, opp).where((id) => !now.keepers.contains(id)),
        lane,
      );
    }
    final by = car == null ? s : null;
    if (atFeet(s) && (assister == null || delivered) && inRange) {
      final sp = now.players[s]!;
      final near = sp.distanceTo(_strikeFrom(now)) < 2.0;
      if (m.header && delivered && car == s) {
        return shot.strike(t, now, fromHeight: headerHeight, by: by);
      }
      if (m.outcome == ShotOutcome.blocked) {
        // Struck into the man in its path; until then the nearest man
        // goal-side closes it down.
        if (_blockerInPath(now)) return shot.strike(t, now, by: by);
        shot.blocker = _aheadOf(now) ?? shot.blocker;
        return null;
      }
      if ((t >= earliest && near) || t >= deadline || late) {
        return shot.strike(t, now, by: by);
      }
      return null;
    }
    // Late, the set-up man plays it straight in.
    final x = assister;
    if (late && x != null && !delivered && atFeet(x)) {
      // Only ever to a man onside.
      if (!onside(now, s)) {
        if (onsideCut) return null;
        onsideCut = true;
        return holdOnside(now, s, PitchCutKind.phase);
      }
      final d = now.players[s]!.distanceTo(now.ball);
      delivered = true;
      return KickAction(
        toPlayerId: s,
        byPlayerId: car == null ? x : null,
        arriveAt: t + math.max(d / 30, 0.2),
        pass: d >= 9,
      );
    }
    // A header needs a ball into the air: a cross from a team-mate.
    if (m.header) {
      crosser ??= _pickCrosser(now);
      final x = assister ?? crosser;
      if (x == null || x == s) {
        final a = fetch(
          s,
          t,
          now,
          needOnside: true,
          cross: true,
          toHeight: headerHeight,
        );
        if (a != null) delivered = true;
        return a;
      }
      if (car == x) {
        final a = fetch(
          s,
          t,
          now,
          needOnside: true,
          cross: true,
          toHeight: headerHeight,
        );
        if (a != null) delivered = true;
        return a;
      }
      return fetch(x, t, now, needOnside: true);
    }
    if (x != null && !delivered) {
      if (car == x) {
        final a = fetch(s, t, now, needOnside: true);
        if (a != null) delivered = true;
        return a;
      }
      return fetch(x, t, now, needOnside: true);
    }
    // No time left to play it to him and still shoot before the window (or
    // the whistle) runs out: cut to him with it instead.
    final sp = now.players[s];
    if (sp != null && !lateCut && car != s && settledIn(t) && !landing(now)) {
      final reach = sp.distanceTo(now.ball) / 22 + 0.15;
      final strike = sp.distanceTo(goal) / 30;
      if (t + reach + strike + 0.3 >= math.min(end, c.hardEnd)) {
        lateCut = true;
        return _phaseCut(now);
      }
    }
    return fetch(s, t, now, needOnside: true);
  }

  /// Whether a defender stands in the shot's path, a stride or two out.
  bool _blockerInPath(ScriptState now) {
    final b = now.ball;
    final ahead = (goal - b).unit;
    for (final id in available(now, opp)) {
      if (now.keepers.contains(id)) continue;
      final rel = now.players[id]! - b;
      final along = rel.x * ahead.x + rel.y * ahead.y;
      final across = (rel.x * ahead.y - rel.y * ahead.x).abs();
      if (along > 0.9 && rel.length < 2.6 && across < 0.8 * along) {
        shot.blocker = id;
        return true;
      }
    }
    return false;
  }

  /// The defending outfielder nearest the ball among those between it and
  /// the goal.
  int? _aheadOf(ScriptState now) {
    final b = now.ball;
    final ahead = (goal - b).unit;
    int? best;
    var bestD = double.infinity;
    for (final id in available(now, opp)) {
      if (now.keepers.contains(id)) continue;
      final rel = now.players[id]! - b;
      final along = rel.x * ahead.x + rel.y * ahead.y;
      final across = (rel.x * ahead.y - rel.y * ahead.x).abs();
      if (along < 0.8 || across > along) continue;
      if (rel.length < bestD) {
        bestD = rel.length;
        best = id;
      }
    }
    return best;
  }

  /// Where the shooter strikes from: the zone it was recorded in, but a
  /// man already well past it toward goal goes back only a few yards.
  Offset2 _strikeFrom(ScriptState now) {
    final sp = now.players[m.shooterId];
    if (sp == null) return zone;
    final d = math.max(depthOf(zone), depthOf(sp) - 6);
    return at(d, latOf(zone));
  }

  int? _pickCrosser(ScriptState now) {
    final s = m.shooterId;
    final car = now.carrierId;
    if (car != null && car != s && now.teams[car] == side) return car;
    final sp = now.players[s];
    final wide = at(88, (sp == null || latOf(sp) >= 0) ? -24 : 24);
    final cands = available(
      now,
      side,
      except: {s},
    ).where((id) => !now.keepers.contains(id)).toList();
    return nearest(now, cands, wide);
  }

  @override
  PlayerDrive? steer(int id, double t, ScriptState now) {
    final s = m.shooterId;
    final celebrate = shot.celebrate(id, now);
    if (celebrate != null) return celebrate;
    final sd = shot.drive(id, t, now);
    if (sd != null) return sd;
    final car = now.carrierId;
    final f = now.flight;
    if (id == s) {
      if (shot.struck) return (target: now.players[id]!, maxSpeed: 2);
      if (f != null && f.toId == s) return null;
      if (car == s) {
        // Into a block he goes at the man closing him down.
        final bk = shot.blocker;
        final bp = bk == null ? null : now.players[bk];
        if (m.outcome == ShotOutcome.blocked && bp != null) {
          final me = now.players[s]!;
          return (target: bp + (me - bp).unit * 2.0, maxSpeed: 4.5);
        }
        return (target: _strikeFrom(now), maxSpeed: 6.5);
      }
      return (target: keepOnside(now, zone), maxSpeed: 7.5);
    }
    if (shot.struck) return null;
    final k = keeperOf(now, opp, m.keeperId);
    if (id == k) return (target: shot.keeperSet(now.ball), maxSpeed: 6);
    if (id == shot.blocker) {
      final from = car == s ? now.ball : zone;
      final lane = from + (goal - from).unit * 2.0;
      return (target: lane, maxSpeed: 8.8);
    }
    if (id == assister || id == crosser) {
      if (car == id) return (target: now.players[id]!, maxSpeed: 1.5);
      if (f != null && f.toId == id) return null;
      if (id == crosser) {
        final p = now.players[id]!;
        return (
          target: keepOnside(now, at(88, latOf(p) >= 0 ? 24 : -24)),
          maxSpeed: 6,
        );
      }
      final p = now.players[id]!;
      return (
        target: keepOnside(now, at(depthOf(p) + 2, latOf(p))),
        maxSpeed: 4,
      );
    }
    return react(id, now);
  }
}
