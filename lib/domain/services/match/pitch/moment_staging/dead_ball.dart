part of '../moment_staging.dart';

/// The dead ball's taker getting to it and the ball being put there: shared
/// by corners, free kicks and throws.
abstract class _DeadBallPlan extends _Plan {
  _DeadBallPlan(StagingContext c, this.sp, this.shotMoment)
    : super(c, sp.teamNationId) {
    final s = shotMoment;
    if (s != null) shot = _Shot(this, s);
  }

  final SetPieceMoment sp;
  final ShotMoment? shotMoment;
  _Shot? shot;

  /// Where the ball is taken from.
  late Offset2 ballSpot;

  /// Where the taker stands to take it.
  late Offset2 takerSpot;

  bool taken = false;
  double? takenAt;

  /// Who the first ball goes to, and who meets the second.
  int? first;
  int? receiver;
  bool secondDone = false;

  int get taker => sp.takerId;

  /// The time the kick is planned for, at the earliest, and the latest it
  /// can wait to leave room for what follows.
  double earliest = 0;
  double latest = 0;

  void setTimes({required double shotPart}) {
    latest = math.max(start + 0.3, end - shotPart);
    earliest = math.min(start + 0.5 * (len - shotPart), latest);
  }

  /// Where each man the set piece needs stands for it.
  Map<int, Offset2> get marks;

  /// Whether the picture cuts to the set piece ready (decided once, as the
  /// window opens), and when it did.
  bool? cutWanted;
  bool cutDone = false;

  /// Whether the set piece cannot be set up in time on the pitch: the
  /// taker (or the man who meets it) cannot reach his place before the
  /// kick has to go, or the ball is far from its spot.
  bool needCut(double t, ScriptState now) {
    // Staged from part-way through: carry on from what is there.
    if (resumed) return false;
    var need = 0.0;
    final tp = now.players[taker];
    if (tp != null) need = tp.distanceTo(takerSpot) / 7;
    final s = shotMoment?.shooterId;
    final sp = s == null ? null : now.players[s];
    final sm = s == null ? null : marks[s];
    if (sp != null && sm != null) need = math.max(need, sp.distanceTo(sm) / 7);
    need = math.max(need, now.ball.distanceTo(ballSpot) / 22);
    return t + need > latest + (room - len) - 0.3;
  }

  /// The cut to the set piece ready: the taker at the ball, everybody in
  /// his place, the defending keeper in his.
  CutAction cutTo(double t, ScriptState now, {Offset2? keeperAt}) {
    cutDone = true;
    earliest = math.max(earliest, t + 0.9);
    final positions = <int, Offset2>{...marks, taker: takerSpot};
    final k = keeperOf(now, opp, shotMoment?.keeperId);
    if (k != null && keeperAt != null) positions[k] = keeperAt;
    // A header that is blocked: its blocker right on the man who meets it.
    final s = shotMoment;
    if (s != null &&
        s.outcome == ShotOutcome.blocked &&
        s.origin != ShotOrigin.directFreeKick) {
      final at = marks[s.shooterId];
      if (at != null) {
        headBlocker ??= nearest(
          now,
          available(
            now,
            opp,
          ).where((o) => !now.keepers.contains(o) && !reserved.contains(o)),
          at,
        );
        shot?.blocker = headBlocker;
        final hb = headBlocker;
        if (hb != null) positions[hb] = at + (goal - at).unit * 1.0;
      }
    }
    // Nobody of theirs nearer the ball than 9.15 m.
    for (final id in now.players.keys) {
      if (now.teams[id] != opp || now.walking.contains(id)) continue;
      if (id == k || positions.containsKey(id)) continue;
      final q = now.players[id]!;
      if (q.distanceTo(ballSpot) < wallDistance + 0.5) {
        var away = (q - ballSpot).unit;
        if (away.length < 1e-6) away = (goal - ballSpot).unit;
        final p = ballSpot + away * (wallDistance + 0.9);
        positions[id] = Offset2(
          p.x.clamp(0.6, PitchDims.length - 0.6),
          p.y.clamp(0.6, PitchDims.width - 0.6),
        );
      }
    }
    return CutAction(ballAt: ballSpot, positions: positions);
  }

  /// Where the defending keeper stands for it.
  Offset2? get keeperSpot => null;

  /// Men the set piece needs where they are (a free kick's wall).
  Set<int> get reserved => const {};

  /// When a delivery of [d] metres from [t] lands: at about [v] m/s, but
  /// faster when late, so the man who meets it still has time.
  double arrival(double t, double d, double v) {
    final sh = shot;
    final need = sh == null ? 0.4 : 0.7 + sh.tail;
    final by = end - need;
    var at = t + d / v;
    if (at > by) at = math.max(by, t + d / 30);
    return math.max(at, t + 0.3);
  }

  bool secondCut2 = false;

  /// The man who meets the second ball is offside: he steps back onside
  /// (once by a cut, when he cannot in time) before it is played.
  BallAction? secondBallOnside(ScriptState now, ShotMoment s) {
    if (secondCut2) return null;
    secondCut2 = true;
    return holdOnside(now, s.shooterId, PitchCutKind.setPiece);
  }

  /// The man who meets the delivery is where he meets it (or near).
  bool shooterSet(ScriptState now) {
    final s = shotMoment;
    if (s == null || s.shooterId == taker) return true;
    final at = marks[s.shooterId];
    final sp = now.players[s.shooterId];
    if (at == null || sp == null) return true;
    return sp.distanceTo(at) < 4;
  }

  /// For a header that is blocked: its blocker goal-side of the man who
  /// meets it, close enough to block it.
  bool blockerSet(ScriptState now) {
    if (!shooterSet(now)) return false;
    final s = shotMoment;
    if (s == null ||
        s.outcome != ShotOutcome.blocked ||
        s.origin == ShotOrigin.directFreeKick) {
      return true;
    }
    final hb = headBlocker;
    final sp = now.players[s.shooterId];
    final bp = hb == null ? null : now.players[hb];
    if (sp == null || bp == null) return false;
    final rel = bp - sp;
    final ahead = (goal - sp).unit;
    final along = rel.x * ahead.x + rel.y * ahead.y;
    return along > 0.4 && rel.length < 2.0;
  }

  /// Nobody of theirs nearer the ball than 9.15 m.
  bool _clearOf(ScriptState now) {
    for (final id in now.players.keys) {
      if (now.teams[id] != opp || now.walking.contains(id)) continue;
      if (now.keepers.contains(id)) continue;
      if (now.players[id]!.distanceTo(ballSpot) < wallDistance - 0.25) {
        return false;
      }
    }
    return true;
  }

  /// The taker's own men stand off the ball and out of his run-up.
  void clearTheBall(ScriptState e) {
    for (final id in available(e, side, except: {taker})) {
      if (e.keepers.contains(id)) continue;
      final q = marks[id] ?? e.players[id]!;
      final near = math.min(q.distanceTo(ballSpot), q.distanceTo(takerSpot));
      if (near >= 3) continue;
      var away = (q - ballSpot).unit;
      if (away.length < 1e-6) away = (ballSpot - takerSpot).unit;
      var spot = ballSpot + away * 4;
      if (spot.distanceTo(takerSpot) < 3) spot = ballSpot - away * 4;
      marks[id] = Offset2(
        spot.x.clamp(0.6, PitchDims.length - 0.6),
        spot.y.clamp(0.6, PitchDims.width - 0.6),
      );
    }
  }

  /// For a header that is blocked: the defender who blocks it, and his
  /// move, goal-side of the man who meets the ball.
  int? headBlocker;

  PlayerDrive? blockerDrive(int id, ScriptState now) {
    final sh = shot;
    final s = shotMoment;
    if (sh == null || s == null || s.outcome != ShotOutcome.blocked) {
      return null;
    }
    if (s.origin == ShotOrigin.directFreeKick || sh.struck) return null;
    if (headBlocker == null) {
      final at = marks[s.shooterId] ?? now.players[s.shooterId];
      if (at == null) return null;
      headBlocker = nearest(
        now,
        available(
          now,
          opp,
        ).where((o) => !now.keepers.contains(o) && !reserved.contains(o)),
        at,
      );
      sh.blocker = headBlocker;
    }
    if (id != headBlocker) return null;
    final sp = now.players[s.shooterId];
    if (sp == null) return null;
    return (target: sp + (goal - sp).unit * 1.0, maxSpeed: 8.8);
  }

  @override
  bool settled(double t, ScriptState now) {
    if (!taken) return false;
    final sh = shot;
    if (sh != null) return sh.settledNow(now);
    return now.flight == null && now.carrierId != null;
  }

  bool ballSet(ScriptState now) =>
      now.flight == null &&
      now.carrierId == null &&
      now.ball.distanceTo(ballSpot) < 1e-6;
}

/// A corner from the arc on the flank its record names: the taker there,
/// the box filled, the delivery to the man who meets it (and his shot), or
/// headed clear.
class _CornerPlan extends _DeadBallPlan {
  _CornerPlan(StagingContext c, SetPieceMoment sp, ShotMoment? s)
    : super(c, sp, s) {
    sigma = sp.left ? -1.0 : 1.0;
    ballSpot = deadBallSpot(sp, dir);
    final kick = (at(97, 0) - ballSpot).unit;
    final stand = ballSpot - kick * 0.8;
    takerSpot = Offset2(
      stand.x.clamp(0.6, PitchDims.length - 0.6),
      stand.y.clamp(0.6, PitchDims.width - 0.6),
    );
    final sh = shotMoment;
    setTimes(shotPart: sh == null ? 1.6 : 1.7 + 0.6 + (shot!.tail));
    out = at(_goalLine + 1.5, sigma * (22 + 6 * rng.nextDouble()));
    _arrange(c.entry);
    if (resumed) _readResume(c.entry);
  }

  late final double sigma;
  late final Offset2 out;
  bool wentOut = false;
  bool lateCut = false;
  bool overhit = false;
  int? clearer;
  @override
  final Map<int, Offset2> marks = {};

  @override
  Offset2 get keeperSpot => at(_goalLine - 0.8, sigma * 0.8);

  void _readResume(ScriptState e) {
    final f = e.flight;
    if (f != null && f.fromId == taker && f.from.distanceTo(ballSpot) < 1e-6) {
      taken = true;
    }
    if (shot != null &&
        f != null &&
        f.fromId == shotMoment!.shooterId &&
        !f.pass) {
      taken = true;
      shot!.struck = true;
    }
  }

  void _arrange(ScriptState e) {
    final s = shotMoment;
    final shooter = s?.shooterId;
    // Attackers in the box: the shooter, and the nearest few.
    final atk =
        available(
          e,
          side,
          except: {taker},
        ).where((id) => !e.keepers.contains(id)).toList()..sort((a, b) {
          final x = e.players[a]!
              .distanceTo(goal)
              .compareTo(
                e.players[b]!.distanceTo(goal),
              );
          return x != 0 ? x : a.compareTo(b);
        });
    final atkSpots = [
      at(100.6, sigma * 3.2),
      at(100.6, 0),
      at(100.2, -sigma * 3.6),
      at(94.5, sigma * 1.5),
      at(93.5, -sigma * 4.5),
      at(86, sigma * 6),
    ];
    final goingIn = <int>[];
    if (shooter != null && e.players.containsKey(shooter)) goingIn.add(shooter);
    for (final id in atk) {
      if (goingIn.length >= 5) break;
      if (!goingIn.contains(id)) goingIn.add(id);
    }
    if (shooter != null && goingIn.contains(shooter)) {
      final hp = _strikePoint(this, s!.zone);
      // A header is met inside the area, toward where it was recorded.
      final d = depthOf(hp).clamp(92.0, 102.0);
      final l = latOf(hp).clamp(-9.0, 9.0);
      marks[shooter] = at(d, l);
      final rest = goingIn.where((id) => id != shooter).toList();
      final free = atkSpots
          .where((q) => q.distanceTo(marks[shooter]!) > 2.6)
          .toList();
      marks.addAll(assign(e, rest, free));
    } else {
      marks.addAll(assign(e, goingIn, atkSpots));
    }
    // Defenders zonal on the six-yard line and around the spot.
    final def = available(
      e,
      opp,
    ).where((id) => !e.keepers.contains(id)).toList();
    final defSpots = [
      at(103.6, sigma * 2.6),
      at(98.6, sigma * 4.8),
      at(98.6, sigma * 1.6),
      at(98.6, -sigma * 1.6),
      at(98.6, -sigma * 4.8),
      at(92.5, sigma * 3.2),
      at(92.5, -sigma * 2.0),
      at(87, -sigma * 2.5),
    ];
    final taken = <Offset2>[...marks.values];
    final usable = defSpots
        .where((q) => taken.every((o) => o.distanceTo(q) > 1.8))
        .toList();
    def.sort((a, b) {
      final x = e.players[a]!
          .distanceTo(goal)
          .compareTo(
            e.players[b]!.distanceTo(goal),
          );
      return x != 0 ? x : a.compareTo(b);
    });
    marks.addAll(assign(e, def.take(usable.length).toList(), usable));
    // Nobody of theirs within 9.15 m of the arc.
    for (final id in def) {
      final q = marks[id] ?? e.players[id]!;
      if (q.distanceTo(ballSpot) < wallDistance + 0.8) {
        marks[id] = ballSpot + (q - ballSpot).unit * (wallDistance + 1.5);
      }
    }
    clearTheBall(e);
  }

  @override
  BallAction? ball(double t, ScriptState now) {
    final sh = shot;
    if (sh != null && sh.struck) return sh.after(t, now);
    final s = shotMoment;
    if (!taken) {
      final ob = outBy;
      if (ob != null && now.carrierId == ob) {
        // Off his foot and out.
        outBy = null;
        return place(t, now, out, speed: 18);
      }
      if (ob != null && now.flight != null) return null;
      cutWanted ??= needCut(t, now);
      if (cutWanted! && !cutDone && settledIn(t)) {
        // The ball goes out first when there is time to see it; then the
        // picture cuts to the corner ready.
        if (!wentOut &&
            now.flight == null &&
            len >= 5 &&
            now.ball.distanceTo(ballSpot) > 8 &&
            now.ball.distanceTo(out) < 35) {
          final r = _runOut(t, now);
          if (r != null) return r;
        }
        return cutTo(t, now, keeperAt: keeperSpot);
      }
      // Still not set when it has to go: the picture cuts to it set.
      final tc = now.players[taker];
      final set =
          ballSet(now) &&
          tc != null &&
          tc.distanceTo(ballSpot) <= 1.3 &&
          _clearOf(now) &&
          blockerSet(now);
      if (!set && t >= latest && settledIn(t) && !lateCut) {
        lateCut = true;
        return cutTo(t, now, keeperAt: keeperSpot);
      }
      if (!ballSet(now)) {
        if (now.flight != null) return null;
        // Out over the goal line first, when there is time, then onto the
        // arc.
        if (!wentOut &&
            len >= 4 &&
            now.ball.distanceTo(ballSpot) > 8 &&
            now.ball.distanceTo(out) < 35) {
          final r = _runOut(t, now);
          if (r != null) return r;
        }
        wentOut = true;
        return place(t, now, ballSpot, speed: 12);
      }
      if (!set) return null;
      if (t < latest && (t < earliest || !_ready(now))) return null;
      taken = true;
      takenAt = t;
      return _deliver(t, now);
    }
    if (now.flight != null) return null;
    // The second ball: a short corner's cross, a header at goal, a clearance.
    final car = now.carrierId;
    if (s != null) {
      if (car == s.shooterId) {
        return sh!.strike(t, now, fromHeight: _metHeight(s));
      }
      if (first != null && holds(now, first!) && !secondDone) {
        if (!onside(now, s.shooterId)) return secondBallOnside(now, s);
        secondDone = true;
        return fetch(
          s.shooterId,
          t,
          now,
          needOnside: true,
          cross: true,
          toHeight: _metHeight(s),
        );
      }
      return null;
    }
    if (overhit) {
      if (car != null) return null;
      final k = keeperOf(now, opp);
      if (k == null) return null;
      final d = now.players[k]!.distanceTo(now.ball);
      return KickAction(
        toPlayerId: k,
        arriveAt: t + math.max(d / 14, 0.3),
        peak: 0.6,
      );
    }
    if (car == clearer && !secondDone) {
      secondDone = true;
      final team = owedSide(now);
      final spot = at(
        66 + 8 * rng.nextDouble(),
        (rng.nextDouble() * 2 - 1) * 14,
      );
      final to = nearest(now, available(now, team), spot);
      if (to == null) return null;
      final d = now.players[to]!.distanceTo(now.ball);
      return KickAction(
        toPlayerId: to,
        arriveAt: t + math.max(d / 18, 0.4),
        peak: math.min(2 + 0.12 * d, 8),
        fromHeight: headerHeight,
      );
    }
    return null;
  }

  double _metHeight(ShotMoment s) => s.header ? headerHeight : 0.3;

  /// The ball out over the goal line off one of theirs: a defender gets a
  /// touch to it (a block, a clearance) and it runs out. Null when there
  /// is nobody to do it, and it goes straight to the arc instead.
  BallAction? _runOut(double t, ScriptState now) {
    wentOut = true;
    final car = now.carrierId;
    if (car != null && now.teams[car] == opp) {
      return place(t, now, out, speed: 18);
    }
    final defs = available(now, opp)
        .where((o) => !now.keepers.contains(o))
        .where((o) => now.players[o]!.distanceTo(now.ball) < 25)
        .toList();
    final d = nearest(now, defs, now.ball);
    if (d == null) return null;
    outBy = d;
    final dist = now.players[d]!.distanceTo(now.ball);
    return KickAction(
      toPlayerId: d,
      arriveAt: t + math.max(dist / 20, 0.2),
    );
  }

  /// The defender who puts it out, while he is about it.
  int? outBy;

  bool _ready(ScriptState now) {
    for (final e in marks.entries) {
      final p = now.players[e.key];
      if (p == null || now.walking.contains(e.key)) continue;
      if (p.distanceTo(e.value) > 1.5) return false;
    }
    return true;
  }

  BallAction? _deliver(double t, ScriptState now) {
    final s = shotMoment;
    if (s != null) {
      final a = s.assistId;
      if (a != null && a != taker && a != s.shooterId && onPitch(now, a)) {
        first = a;
      } else if (taker == s.shooterId) {
        // He takes it short and gets it back in the area.
        final mates = available(
          now,
          side,
          except: {taker},
        ).where((id) => !now.keepers.contains(id)).toList();
        first = nearest(now, mates, now.ball);
      } else {
        first = s.shooterId;
      }
      final f = first ?? s.shooterId;
      if (f == s.shooterId) {
        receiver = f;
        return _cross(t, now, f, _metHeight(s));
      }
      receiver = f;
      final d = now.players[f]!.distanceTo(now.ball);
      return KickAction(
        toPlayerId: f,
        byPlayerId: taker,
        arriveAt: t + math.max(d / 14, 0.3),
        pass: d >= 9,
      );
    }
    if (rng.chance(0.25)) {
      overhit = true;
      final far = at(_goalLine + 2.5, -sigma * (6 + 8 * rng.nextDouble()));
      final d = now.ball.distanceTo(far);
      return KickAction(
        to: far,
        byPlayerId: taker,
        arriveAt: t + d / 20,
        peak: 5,
      );
    }
    final defs = available(now, opp).where((id) => !now.keepers.contains(id));
    clearer = nearest(now, defs, at(98.5, sigma * 1.5));
    if (clearer == null) {
      overhit = true;
      final far = at(_goalLine + 2.5, -sigma * 10);
      return KickAction(to: far, byPlayerId: taker, arriveAt: t + 1.2, peak: 5);
    }
    return _cross(t, now, clearer!, headerHeight);
  }

  KickAction _cross(double t, ScriptState now, int to, double height) {
    final d = now.players[to]!.distanceTo(now.ball);
    return KickAction(
      toPlayerId: to,
      byPlayerId: taker,
      arriveAt: arrival(t, d, 19),
      peak: math.min(3 + 0.08 * d, 6).toDouble(),
      toHeight: height,
    );
  }

  @override
  PlayerDrive? steer(int id, double t, ScriptState now) {
    final sh = shot;
    if (sh != null) {
      final c = sh.celebrate(id, now);
      if (c != null) return c;
      final d = sh.drive(id, t, now);
      if (d != null) return d;
    }
    final bd = blockerDrive(id, now);
    if (bd != null) return bd;
    final f = now.flight;
    if (f != null && f.toId == id) return null;
    if (id == taker) {
      if (taken) return (target: now.players[id]!, maxSpeed: 1);
      return (target: takerSpot, maxSpeed: 8);
    }
    final k = keeperOf(now, opp, shotMoment?.keeperId);
    if (id == k && (sh == null || !sh.struck)) {
      return (target: at(_goalLine - 0.8, sigma * 0.8), maxSpeed: 5);
    }
    final mark = marks[id];
    if (mark != null) {
      if (taken && id == shotMoment?.shooterId) return null;
      return (target: mark, maxSpeed: 6.5);
    }
    return null;
  }
}

/// A free kick: the ball on the spot of the foul, the taker behind it, the
/// defending side 9.15 m away with a wall on the line to goal, then the
/// shot (direct), the cross to the man who meets it, or the ball cleared.
class _FreeKickPlan extends _DeadBallPlan {
  _FreeKickPlan(StagingContext c, SetPieceMoment sp, ShotMoment? s)
    : super(c, sp, s) {
    final e = c.entry;
    final own = deadBallSpot(sp, dir);
    // The foul's window may already have left the ball on the spot.
    final rests = e.carrierId == null && e.flight == null;
    ballSpot = rests && e.ball.distanceTo(own) < 6 ? e.ball : own;
    direct =
        s?.origin == ShotOrigin.directFreeKick ||
        (s == null && sp.zone == PitchZone.edgeOfBox);
    final nearSign = latOf(ballSpot).abs() > 0.5
        ? latOf(ballSpot).sign
        : (rng.chance(0.5) ? 1.0 : -1.0);
    final aim = at(_goalLine, direct ? nearSign * 1.2 : 0);
    toGoal = (aim - ballSpot).unit;
    takerSpot = _clamp(ballSpot - toGoal * 2.2);
    final d = ballSpot.distanceTo(goal);
    final n = direct
        ? (d < 22
              ? 4 + (rng.chance(0.5) ? 1 : 0)
              : 3 + (rng.chance(0.5) ? 1 : 0))
        : 2;
    final centre = ballSpot + toGoal * wallDistance;
    final perp = Offset2(-toGoal.y, toGoal.x);
    wallSpots = [
      for (var k = 0; k < n; k++) centre + perp * ((k - (n - 1) / 2) * 1.05),
    ];
    final sh = shot;
    setTimes(
      shotPart: sh == null
          ? 1.6
          : direct
          ? 1.0 + sh.tail
          : 1.3 + 0.6 + sh.tail,
    );
    _arrange(e);
    if (resumed) {
      final f = e.flight;
      if (f != null &&
          f.fromId == taker &&
          f.from.distanceTo(ballSpot) < 1e-6) {
        taken = true;
        if (direct && sh != null) sh.struck = true;
      }
      if (sh != null &&
          f != null &&
          f.fromId == shotMoment!.shooterId &&
          !f.pass) {
        taken = true;
        sh.struck = true;
      }
    }
  }

  late final bool direct;
  bool secondCut = false;

  @override
  Set<int> get reserved => wall.toSet();
  late final Offset2 toGoal;
  late final List<Offset2> wallSpots;
  @override
  final Map<int, Offset2> marks = {};

  @override
  Offset2 get keeperSpot {
    final l = latOf(ballSpot);
    final away = l.abs() > 0.5 ? -l.sign : 0.0;
    return direct
        ? at(_goalLine - 0.8, away * 1.0)
        : at(_goalLine - 2.5, (l >= 0 ? 1.0 : -1.0) * 0.8);
  }

  final List<int> wall = [];
  int? clearer;

  static Offset2 _clamp(Offset2 p) => Offset2(
    p.x.clamp(0.6, PitchDims.length - 0.6),
    p.y.clamp(0.6, PitchDims.width - 0.6),
  );

  void _arrange(ScriptState e) {
    final def =
        available(e, opp).where((id) => !e.keepers.contains(id)).toList()
          ..sort((a, b) {
            final x = e.players[a]!
                .distanceTo(ballSpot)
                .compareTo(
                  e.players[b]!.distanceTo(ballSpot),
                );
            return x != 0 ? x : a.compareTo(b);
          });
    final wallMen = assign(
      e,
      def.take(wallSpots.length + 2).toList(),
      wallSpots,
    );
    wall.addAll(wallMen.keys.toList()..sort());
    marks.addAll(wallMen);
    final s = shotMoment;
    final shooter = s?.shooterId;
    if (!direct) {
      // A cross: the defending line holds just off the six-yard box, the
      // attackers onside in front of it, the man who meets it among them.
      final sign = latOf(ballSpot) >= 0 ? 1.0 : -1.0;
      final defSpots = [
        for (final l in [-9.0, -5.0, -1.5, 2.0, 5.5, 9.0]) at(95.5, l * sign),
      ];
      final rest = def.where((id) => !wall.contains(id)).take(6).toList();
      marks.addAll(assign(e, rest, defSpots));
      final atkSpots = [
        for (final l in [-7.0, -3.0, 0.5, 4.0]) at(93.2, l * sign),
      ];
      final atk =
          available(
            e,
            side,
            except: {taker},
          ).where((id) => !e.keepers.contains(id)).toList()..sort((a, b) {
            final x = e.players[a]!
                .distanceTo(goal)
                .compareTo(
                  e.players[b]!.distanceTo(goal),
                );
            return x != 0 ? x : a.compareTo(b);
          });
      final going = <int>[
        if (shooter != null && e.players.containsKey(shooter)) shooter,
      ];
      for (final id in atk) {
        if (going.length >= 4) break;
        if (!going.contains(id)) going.add(id);
      }
      marks.addAll(assign(e, going, atkSpots));
    }
    // The 9.15 m: nobody of theirs nearer the ball than the wall.
    for (final id in def) {
      if (wall.contains(id)) continue;
      final q = marks[id] ?? e.players[id]!;
      if (q.distanceTo(ballSpot) < wallDistance + 0.8) {
        var away = (q - ballSpot).unit;
        if (away.length < 1e-6) away = toGoal * -1;
        marks[id] = _clamp(ballSpot + away * (wallDistance + 1.6));
      }
    }
    clearTheBall(e);
  }

  /// The wall made up again from the men there now (one may have gone).
  void _rebuildWall(ScriptState now) {
    for (final id in wall) {
      marks.remove(id);
    }
    wall.clear();
    final def =
        available(now, opp).where((id) => !now.keepers.contains(id)).toList()
          ..sort((a, b) {
            final x = now.players[a]!
                .distanceTo(ballSpot)
                .compareTo(now.players[b]!.distanceTo(ballSpot));
            return x != 0 ? x : a.compareTo(b);
          });
    final men = assign(now, def.take(wallSpots.length + 2).toList(), wallSpots);
    wall.addAll(men.keys.toList()..sort());
    marks.addAll(men);
  }

  /// Whether the wall cannot form before the kick has to go.
  bool _wallFar(ScriptState now) {
    for (final id in wall) {
      final p = now.players[id];
      if (p == null) continue;
      if (now.t + p.distanceTo(marks[id]!) / 6 > latest - 0.4) return true;
    }
    return false;
  }

  /// Nobody of theirs nearer the ball than 9.15 m (the wall included).
  bool _clear(ScriptState now) => _clearOf(now);

  bool _wallSet(ScriptState now) {
    // A wall of its full number, every man there.
    if (wall.length < wallSpots.length) return false;
    for (final id in wall) {
      if (!now.players.containsKey(id) || now.walking.contains(id)) {
        return false;
      }
      final p = now.players[id];
      if (p == null) continue;
      if (p.distanceTo(marks[id]!) > 0.35) return false;
    }
    return true;
  }

  @override
  BallAction? ball(double t, ScriptState now) {
    final sh = shot;
    if (sh != null && sh.struck) return sh.after(t, now);
    final s = shotMoment;
    if (!taken) {
      cutWanted ??= needCut(t, now) || (!resumed && _wallFar(now));
      if (cutWanted! && !cutDone && settledIn(t)) {
        return cutTo(t, now, keeperAt: keeperSpot);
      }
      final tk = now.players[taker];
      final set =
          ballSet(now) &&
          _wallSet(now) &&
          _clear(now) &&
          blockerSet(now) &&
          tk != null &&
          tk.distanceTo(ballSpot) <= 1.2;
      if (!set && t >= latest && settledIn(t) && !secondCut) {
        // Still not ready when it has to go: the picture cuts to it ready,
        // the taker over the ball, the wall up, everybody back 9.15 m.
        secondCut = true;
        _rebuildWall(now);
        final cut = cutTo(t, now, keeperAt: keeperSpot);
        cut.positions[taker] = _clamp(ballSpot - toGoal * 0.75);
        return cut;
      }
      if (!ballSet(now)) {
        if (now.flight != null) return null;
        return place(t, now, ballSpot, speed: 10);
      }
      // Never taken until it is set: the wall at 9.15 m, nobody nearer.
      if (!set) return null;
      if (t < earliest && t < latest) return null;
      taken = true;
      takenAt = t;
      if (direct && s != null && s.shooterId == taker) {
        return sh!.strike(
          t,
          now,
          by: taker,
          wallDepth: depthOf(ballSpot + toGoal * wallDistance),
          speed: 22 + 3 * rng.nextDouble(),
        );
      }
      return _deliver(t, now);
    }
    if (now.flight != null) return null;
    final car = now.carrierId;
    if (s != null) {
      if (car == s.shooterId) {
        return sh!.strike(t, now, fromHeight: s.header ? headerHeight : 0.3);
      }
      if (first != null && holds(now, first!) && !secondDone) {
        if (!onside(now, s.shooterId)) return secondBallOnside(now, s);
        secondDone = true;
        return fetch(
          s.shooterId,
          t,
          now,
          needOnside: true,
          cross: true,
          toHeight: s.header ? headerHeight : 0.3,
        );
      }
      return null;
    }
    if (car == clearer && !secondDone) {
      secondDone = true;
      final team = owedSide(now);
      final spot = at(
        64 + 8 * rng.nextDouble(),
        (rng.nextDouble() * 2 - 1) * 14,
      );
      final to = nearest(now, available(now, team), spot);
      if (to == null) return null;
      final d = now.players[to]!.distanceTo(now.ball);
      return KickAction(
        toPlayerId: to,
        arriveAt: t + math.max(d / 18, 0.4),
        peak: math.min(2 + 0.12 * d, 8),
        fromHeight: direct ? 1.4 : headerHeight,
      );
    }
    return null;
  }

  BallAction? _deliver(double t, ScriptState now) {
    final s = shotMoment;
    if (s != null) {
      final a = s.assistId;
      int f;
      if (a != null && a != taker && a != s.shooterId && onPitch(now, a)) {
        f = a;
      } else if (s.shooterId == taker) {
        final mates = available(
          now,
          side,
          except: {taker},
        ).where((id) => !now.keepers.contains(id)).toList();
        f = nearest(now, mates, now.ball) ?? s.shooterId;
      } else {
        f = s.shooterId;
      }
      first = f;
      final d = now.players[f]!.distanceTo(now.ball);
      if (f == s.shooterId) {
        return KickAction(
          toPlayerId: f,
          byPlayerId: taker,
          arriveAt: arrival(t, d, 19),
          peak: math.min(2.5 + 0.08 * d, 6).toDouble(),
          toHeight: s.header ? headerHeight : 0.3,
          pass: d >= 9,
        );
      }
      return KickAction(
        toPlayerId: f,
        byPlayerId: taker,
        arriveAt: t + math.max(d / 14, 0.3),
        pass: d >= 9,
      );
    }
    if (direct) {
      // Into the wall and away.
      clearer = wall.isEmpty ? null : wall[wall.length ~/ 2];
      if (clearer == null) return null;
      final d = now.players[clearer]!.distanceTo(now.ball);
      return KickAction(
        toPlayerId: clearer,
        byPlayerId: taker,
        arriveAt: t + math.max(d / 22, 0.3),
        peak: 0.6,
        toHeight: 1.4,
      );
    }
    final defs = available(now, opp).where((id) => !now.keepers.contains(id));
    clearer = nearest(now, defs, at(96, 0));
    if (clearer == null) return null;
    final d = now.players[clearer]!.distanceTo(now.ball);
    return KickAction(
      toPlayerId: clearer,
      byPlayerId: taker,
      arriveAt: t + math.max(d / 19, 0.5),
      peak: math.min(2.5 + 0.08 * d, 6).toDouble(),
      toHeight: headerHeight,
    );
  }

  @override
  PlayerDrive? steer(int id, double t, ScriptState now) {
    final sh = shot;
    if (sh != null) {
      final c = sh.celebrate(id, now);
      if (c != null) return c;
      final d = sh.drive(id, t, now);
      if (d != null) return d;
    }
    final bd = blockerDrive(id, now);
    if (bd != null) return bd;
    final f = now.flight;
    if (f != null && f.toId == id) return null;
    if (id == taker) {
      if (taken) return (target: now.players[id]!, maxSpeed: 1);
      final tp = now.players[id]!;
      final ready = t >= earliest - 0.6 && tp.distanceTo(takerSpot) < 0.8;
      final stand = ready || t >= latest - 0.6
          ? ballSpot - toGoal * 0.75
          : takerSpot;
      return (target: _clamp(stand), maxSpeed: ready ? 4 : 8);
    }
    final k = keeperOf(now, opp, shotMoment?.keeperId);
    if (id == k && (sh == null || !sh.struck)) {
      final away = latOf(ballSpot).abs() > 0.5 ? -latOf(ballSpot).sign : 0.0;
      return (
        target: direct
            ? at(_goalLine - 0.8, away * 1.0)
            : at(_goalLine - 2.5, latOf(ballSpot).sign * 0.8),
        maxSpeed: 5,
      );
    }
    final mark = marks[id];
    if (mark != null) {
      // Once the cross is in, the attackers attack it.
      if (taken && now.teams[id] == side) {
        if (id == shotMoment?.shooterId) return null;
        return (target: at(depthOf(mark) + 3, latOf(mark)), maxSpeed: 5);
      }
      if (taken && wall.contains(id)) return (target: mark, maxSpeed: 2);
      return (target: mark, maxSpeed: wall.contains(id) ? 7 : 6.5);
    }
    return null;
  }
}

/// A long throw: the ball out over the touchline on the flank its record
/// names, the thrower collecting it there, the box filled, the throw to the
/// man who meets it and his header.
class _ThrowPlan extends _DeadBallPlan {
  _ThrowPlan(StagingContext c, SetPieceMoment sp, ShotMoment? s)
    : super(c, sp, s) {
    sigma = sp.left ? -1.0 : 1.0;
    takerSpot = deadBallSpot(sp, dir);
    ballSpot = at(depthOf(takerSpot), sigma * 35);
    final sh = shot;
    setTimes(shotPart: sh == null ? 1.6 : 1.6 + 0.6 + sh.tail);
    _arrange(c.entry);
    if (resumed) {
      final f = c.entry.flight;
      if (c.entry.carrierId == taker) wentOut = true;
      if (f != null && f.fromId == taker) {
        taken = true;
        wentOut = true;
      }
      if (sh != null &&
          f != null &&
          f.fromId == shotMoment!.shooterId &&
          !f.pass) {
        taken = true;
        sh.struck = true;
      }
    }
  }

  late final double sigma;
  bool wentOut = false;
  bool lateCut = false;
  @override
  final Map<int, Offset2> marks = {};
  int? clearer;

  void _arrange(ScriptState e) {
    final s = shotMoment;
    final shooter = s?.shooterId;
    final atkSpots = [
      at(99.5, sigma * 4),
      at(97, 0),
      at(99, -sigma * 4),
      at(92, sigma * 2),
    ];
    final atk =
        available(
          e,
          side,
          except: {taker},
        ).where((id) => !e.keepers.contains(id)).toList()..sort((a, b) {
          final x = e.players[a]!
              .distanceTo(goal)
              .compareTo(
                e.players[b]!.distanceTo(goal),
              );
          return x != 0 ? x : a.compareTo(b);
        });
    final going = <int>[
      if (shooter != null && e.players.containsKey(shooter)) shooter,
    ];
    for (final id in atk) {
      if (going.length >= 4) break;
      if (!going.contains(id)) going.add(id);
    }
    if (shooter != null && going.contains(shooter)) {
      final hp = _strikePoint(this, s!.zone);
      marks[shooter] = at(
        depthOf(hp).clamp(92.0, 101.5),
        latOf(hp).clamp(-8.0, 8.0),
      );
      final free = atkSpots
          .where((q) => q.distanceTo(marks[shooter]!) > 2.6)
          .toList();
      marks.addAll(
        assign(e, going.where((id) => id != shooter).toList(), free),
      );
    } else {
      marks.addAll(assign(e, going, atkSpots));
    }
    final def =
        available(e, opp).where((id) => !e.keepers.contains(id)).toList()
          ..sort((a, b) {
            final x = e.players[a]!
                .distanceTo(goal)
                .compareTo(
                  e.players[b]!.distanceTo(goal),
                );
            return x != 0 ? x : a.compareTo(b);
          });
    final defSpots = [
      at(98, sigma * 6.5),
      at(98, sigma * 1.5),
      at(98, -sigma * 2.5),
      at(94.5, sigma * 4.5),
      at(94.5, -sigma * 1),
      at(89, 0),
    ];
    final used = [...marks.values];
    final usable = defSpots
        .where((q) => used.every((o) => o.distanceTo(q) > 1.8))
        .toList();
    marks.addAll(assign(e, def.take(usable.length).toList(), usable));
  }

  @override
  BallAction? ball(double t, ScriptState now) {
    final sh = shot;
    if (sh != null && sh.struck) return sh.after(t, now);
    final s = shotMoment;
    final car = now.carrierId;
    if (!taken) {
      cutWanted ??= car != taker && needCut(t, now);
      if (cutWanted! && !cutDone && settledIn(t)) {
        wentOut = true;
        return cutTo(t, now);
      }
      final tq = now.players[taker];
      final inPlace =
          car == taker && tq != null && tq.distanceTo(takerSpot) <= 1.0;
      if (!lateCut && t >= latest && settledIn(t) && !inPlace) {
        lateCut = true;
        wentOut = true;
        return cutTo(t, now);
      }
      if (now.flight != null) return null;
      if (car == taker) {
        if (!wentOut) wentOut = true;
        final tp = now.players[taker]!;
        if (tp.distanceTo(takerSpot) > 1.0) return null;
        if (!blockerSet(now) && !lateCut) {
          if (t < latest) return null;
          lateCut = true;
          return cutTo(t, now);
        }
        if (t < latest && (t < earliest || !_ready(now))) return null;
        taken = true;
        takenAt = t;
        return _throw(t, now);
      }
      // Over the touchline, then into the thrower's hands.
      if (!wentOut) {
        wentOut = true;
        if (now.ball.distanceTo(ballSpot) > 1e-6) {
          return place(t, now, ballSpot, speed: 15);
        }
      }
      final tp = now.players[taker];
      if (tp == null || tp.distanceTo(takerSpot) > 2.0) return null;
      final d = tp.distanceTo(now.ball);
      return KickAction(
        toPlayerId: taker,
        arriveAt: t + math.max(d / 8, 0.2),
        peak: 0.5,
      );
    }
    if (now.flight != null) return null;
    if (s != null) {
      if (car == s.shooterId) {
        return sh!.strike(t, now, fromHeight: s.header ? headerHeight : 0.3);
      }
      if (first != null && holds(now, first!) && !secondDone) {
        if (!onside(now, s.shooterId)) return secondBallOnside(now, s);
        secondDone = true;
        return fetch(
          s.shooterId,
          t,
          now,
          needOnside: true,
          cross: true,
          toHeight: s.header ? headerHeight : 0.3,
        );
      }
      return null;
    }
    if (car == clearer && !secondDone) {
      secondDone = true;
      final team = owedSide(now);
      final spot = at(
        66 + 8 * rng.nextDouble(),
        (rng.nextDouble() * 2 - 1) * 14,
      );
      final to = nearest(now, available(now, team), spot);
      if (to == null) return null;
      final d = now.players[to]!.distanceTo(now.ball);
      return KickAction(
        toPlayerId: to,
        arriveAt: t + math.max(d / 18, 0.4),
        peak: math.min(2 + 0.12 * d, 8),
        fromHeight: headerHeight,
      );
    }
    return null;
  }

  bool _ready(ScriptState now) {
    for (final e in marks.entries) {
      final p = now.players[e.key];
      if (p == null || now.walking.contains(e.key)) continue;
      if (p.distanceTo(e.value) > 1.5) return false;
    }
    return true;
  }

  BallAction? _throw(double t, ScriptState now) {
    final s = shotMoment;
    int? to;
    double height = headerHeight;
    if (s != null) {
      final a = s.assistId;
      if (a != null && a != taker && a != s.shooterId && onPitch(now, a)) {
        to = a;
      } else if (s.shooterId == taker) {
        final mates = available(
          now,
          side,
          except: {taker},
        ).where((id) => !now.keepers.contains(id)).toList();
        to = nearest(now, mates, at(96, 0));
      } else {
        to = s.shooterId;
        height = s.header ? headerHeight : 0.3;
      }
      first = to;
    } else {
      final defs = available(now, opp).where((id) => !now.keepers.contains(id));
      clearer = nearest(now, defs, at(97, 0));
      to = clearer;
    }
    if (to == null) return null;
    final d = now.players[to]!.distanceTo(now.ball);
    return KickAction(
      toPlayerId: to,
      arriveAt: arrival(t, d, 17),
      peak: math.min(2.5 + 0.1 * d, 5.5).toDouble(),
      toHeight: height,
    );
  }

  @override
  PlayerDrive? steer(int id, double t, ScriptState now) {
    final sh = shot;
    if (sh != null) {
      final c = sh.celebrate(id, now);
      if (c != null) return c;
      final d = sh.drive(id, t, now);
      if (d != null) return d;
    }
    final bd = blockerDrive(id, now);
    if (bd != null) return bd;
    final f = now.flight;
    if (f != null && f.toId == id) return null;
    if (id == taker) {
      if (taken) return (target: now.players[id]!, maxSpeed: 1);
      return (target: takerSpot, maxSpeed: 8);
    }
    final k = keeperOf(now, opp, shotMoment?.keeperId);
    if (id == k && (sh == null || !sh.struck)) {
      return (target: at(_goalLine - 1.5, sigma * 1.2), maxSpeed: 5);
    }
    final mark = marks[id];
    if (mark != null) {
      if (taken && id == shotMoment?.shooterId) return null;
      return (target: mark, maxSpeed: 6.5);
    }
    return null;
  }
}
