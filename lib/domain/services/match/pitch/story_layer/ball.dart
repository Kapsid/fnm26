part of '../story_layer.dart';

/// The ball: carried, in the air, lying still; kicks, landings and cuts.
extension _BallMechanics on _Builder {
  void _stagedBall(double t) {
    final plan = activePlan;
    final c = carrier;
    if (plan == null) return;
    final inAir = flight != null;
    if (!inAir && c == null && restAt == null) return;
    final action = plan.ball(t, _state(t));
    // While the ball is in the air only a cut may interrupt it, and only
    // a pass between team-mates still well short of its man: anything else
    // (a shot, a save, a clearance) comes down first, the cut on landing.
    if (inAir && action is! CutAction) return;
    if (inAir && action is CutAction && !_mayCutFlight(t)) {
      pendingCut = action;
      pendingPlan = plan;
      return;
    }
    switch (action) {
      case PassAction(:final toPlayerId, :final arriveAt, :final peak):
        if (c == null) return;
        final to = indexOf[toPlayerId];
        if (to == null || to == c) return;
        final target = agents[to];
        if (!target.present || target.walkStart != null) return;
        _startFlight(
          t,
          agents[c],
          target,
          intercept: target.side != agents[c].side,
          arriveAt: arriveAt,
          peak: peak,
        );
      case final KickAction k:
        _kick(t, k);
      case final CutAction k:
        _cut(t, k);
        // The moment goes on at once from what the cut shows.
        final next = plan.ball(t, _state(t));
        switch (next) {
          case final KickAction n:
            _kick(t, n);
          case PassAction(:final toPlayerId, :final arriveAt, :final peak):
            final cc = carrier;
            final to = indexOf[toPlayerId];
            if (cc == null || to == null || to == cc) break;
            final target = agents[to];
            if (!target.present || target.walkStart != null) break;
            _startFlight(
              t,
              agents[cc],
              target,
              intercept: target.side != agents[cc].side,
              arriveAt: arriveAt,
              peak: peak,
            );
          case CutAction() || null:
            break;
        }
      case null:
        break;
    }
  }

  /// Whether the ball in the air may be cut short. A shot never is (its
  /// outcome is the record's), and a ball about to land comes down first;
  /// anything else with a while still to go may be.
  bool _mayCutFlight(double t) {
    final f = flight;
    if (f == null) return true;
    if (f.shot) return false;
    return f.t1 - t >= 0.6;
  }

  /// A cut asked for while the ball was in the air, made as it lands.
  void _cutOnLanding(double t) {
    final k = pendingCut;
    final plan = pendingPlan;
    pendingCut = null;
    pendingPlan = null;
    if (k == null || plan == null || !identical(plan, activePlan)) return;
    // Whatever is due now happens first (a man starting his walk off).
    _applyDue(t, atBreak: false);
    _processArrivals(t);
    _cut(t, k);
    final next = plan.ball(t, _state(t));
    if (next is KickAction) _kick(t, next);
  }

  /// The picture cuts to [k]'s set piece, ready.
  void _cut(double t, CutAction k) {
    _cutFlight(t);
    _closePhase(t);
    // The picture just before the cut, as it stands now.
    _record(t);
    final minute = pacer.matchAt(_Builder._dur(t)).minute;
    final poss = k.possession;
    if (poss != null) {
      // A new phase: both sides in their shapes around the ball, as the
      // story layer would have them there.
      final s = poss == lineups.home.nationId ? 0 : 1;
      possession = s;
      _updateBackLines(minute, k.ballAt);
      final shape = <int, Offset2>{
        ..._anchors(0, minute, t, k.ballAt, s == 0),
        ..._anchors(1, minute, t, k.ballAt, s == 1),
      };
      shape.forEach((i, p) {
        final a = agents[i];
        if (!a.present || a.walkStart != null) return;
        a
          ..pos = _Builder._clampPitch(p)
          ..vel = Offset2.zero;
      });
    }
    final placed = <int>{};
    k.positions.forEach((id, p) {
      final i = indexOf[id];
      if (i == null) return;
      final a = agents[i];
      if (!a.present || a.walkStart != null) return;
      var q = _Builder._clampPitch(p);
      if (a.slot == sides[a.side].gkSlot) {
        // A keeper stays within reach of his goal, whatever is asked.
        final dir = _dir(a.side, minute);
        final d = xToDepth(q.x, dir);
        if (d > _keeperMaxDepth)
          q = Offset2(depthToX(_keeperMaxDepth, dir), q.y);
      }
      a
        ..pos = q
        ..vel = Offset2.zero;
      placed.add(i);
    });
    // The man to be flagged beyond the line; the men who must be onside
    // behind it.
    final off = k.offside == null ? null : indexOf[k.offside];
    if (off != null && agents[off].present && agents[off].walkStart == null) {
      final a = agents[off];
      final dir = _dir(a.side, minute);
      final line = math.max(
        _secondLastDepth(a.side, dir),
        xToDepth(k.ballAt.x, dir),
      );
      final d = (line + 2.5).clamp(55.0, 100.0);
      a.pos = _Builder._clampPitch(Offset2(depthToX(d, dir), a.pos.y));
      placed.add(off);
    }
    for (final id in k.onside) {
      final i = indexOf[id];
      if (i == null) continue;
      final a = agents[i];
      if (!a.present || a.walkStart != null) continue;
      final dir = _dir(a.side, minute);
      final line = math.max(
        _secondLastDepth(a.side, dir),
        xToDepth(k.ballAt.x, dir),
      );
      final d = xToDepth(a.pos.x, dir);
      if (d > PitchDims.length / 2 && d > line - 1.0) {
        final to = math.max(line - 1.0, PitchDims.length / 2);
        a.pos = _Builder._clampPitch(Offset2(depthToX(to, dir), a.pos.y));
      }
      placed.add(i);
    }
    // Nobody heaped on anybody on screen: the men not placed step aside,
    // across the pitch only, so no line of offside moves. The moment's own
    // men (the one cut to, or the one under way) stay exactly where they
    // were put.
    final named = <int>{
      ...?activeWindow?.actors,
      for (final w in windows)
        if (w.start >= t - 1e-9 && w.start < t + 12) ...w.actors,
    };
    final spread = DisplaySpacing.spread(
      {
        for (final a in agents)
          if (a.present) a.index: a.pos,
      },
      {
        for (final a in agents)
          if (a.present &&
              a.walkStart == null &&
              !placed.contains(a.index) &&
              !named.contains(a.id) &&
              a.slot != sides[a.side].gkSlot)
            a.index,
      },
      target: 0.35,
      passes: 8,
      maxStep: 3,
      acrossOnly: true,
    );
    spread.forEach((i, p) => agents[i].pos = p);
    // Nobody left standing on anybody: those not placed step aside first.
    for (var it = 0; it < 80; it++) {
      var moved = false;
      for (final a in agents) {
        if (!a.present) continue;
        for (final b in agents) {
          if (b.index <= a.index || !b.present) continue;
          final d = a.pos.distanceTo(b.pos);
          if (d >= 1.05) continue;
          moved = true;
          final away = d < 1e-6 ? const Offset2(0, 1) : (a.pos - b.pos).unit;
          final push = (1.05 - d) / 2 + 0.02;
          // A man walking off never moves; a man placed moves only for
          // another placed man.
          final walkA = a.walkStart != null;
          final walkB = b.walkStart != null;
          final fixA = placed.contains(a.index) || walkA;
          final fixB = placed.contains(b.index) || walkB;
          final moveA = !walkA && (!fixA || fixB);
          final moveB = !walkB && (!fixB || fixA);
          final both = moveA && moveB;
          if (moveA)
            a.pos = _Builder._clampPitch(
              a.pos + away * (both ? push : push * 2),
            );
          if (moveB)
            b.pos = _Builder._clampPitch(
              b.pos - away * (both ? push : push * 2),
            );
        }
      }
      if (!moved) break;
    }
    // Anybody still too close (pinned against a line) finds the nearest
    // free spot.
    for (final a in agents) {
      if (!a.present || placed.contains(a.index) || a.walkStart != null) {
        continue;
      }
      bool clear(Offset2 p) => agents.every(
        (o) => o == a || !o.present || o.pos.distanceTo(p) >= 1.05,
      );
      if (clear(a.pos)) continue;
      for (var k = 1; k < 200; k++) {
        final ring = 1.1 * (1 + k ~/ 8);
        final p = _Builder._clampPitch(
          a.pos + Offset2.fromAngle(k * math.pi / 4 + ring, ring),
        );
        if (clear(p)) {
          a.pos = p;
          break;
        }
      }
    }
    // Everybody faces the ball.
    for (final a in agents) {
      if (!a.present || a.walkStart != null) continue;
      final to = k.ballAt - a.pos;
      if (to.length > 0.3) a.facing = to.angle;
    }
    carrier = null;
    flight = null;
    restAt = k.ballAt;
    restHeight = 0;
    phaseStart = t;
    _record(t);
    cuts[t] = k.kind;
  }

  /// Starts [k]: the ball leaves its carrier's feet, or the spot it lies
  /// on, for a point or a man.
  void _kick(double t, KickAction k) {
    final int? to;
    if (k.toPlayerId != null) {
      to = indexOf[k.toPlayerId];
      if (to == null) return;
      final target = agents[to];
      if (!target.present || target.walkStart != null || to == carrier) {
        return;
      }
    } else {
      to = null;
    }
    final c = carrier;
    final Offset2 from;
    final int? by;
    if (c != null) {
      from = _ballPoint(agents[c]);
      by = c;
    } else {
      from = restAt!;
      final named = k.byPlayerId == null ? null : indexOf[k.byPlayerId];
      by = named ?? lastTouch;
    }
    final lead = to != null ? _ballPoint(agents[to]) : k.to!;
    // A man it is played to may move a little before it lands: room under
    // the cap.
    final fastest = t + from.distanceTo(lead) / (to != null ? 26 : 34);
    _closePhase(t);
    flight = _Flight(
      t0: t,
      t1: math.max(math.max(k.arriveAt, fastest), t + 0.05),
      from: from,
      fromActor: by,
      toActor: to,
      peak: k.peak,
      lead: lead,
      pass: k.pass,
      fromHeight: c != null ? k.fromHeight : math.max(k.fromHeight, restHeight),
      toHeight: k.toHeight,
      shot: k.shot,
    );
    carrier = null;
    restAt = null;
    restHeight = 0;
    if (by != null) lastTouch = by;
  }

  /// Outside a moment, a ball lying loose (one a moment left out of play,
  /// or in the open) goes to whoever is nearest: a ball behind a goal line
  /// to the keeper there, for his goal kick.
  void _collectLoose(double t) {
    final at = restAt!;
    final minute = pacer.matchAt(_Builder._dur(t)).minute;
    _Agent? best;
    var bestD = double.infinity;
    final behindHome = at.x < 0;
    final behindFar = at.x > PitchDims.length;
    for (final a in agents) {
      if (!a.present || a.walkStart != null) continue;
      if (_departsWithin(a, t, 6)) continue;
      var d = a.pos.distanceTo(at);
      if (behindHome || behindFar) {
        final dir = _dir(a.side, minute);
        final defends = (dir > 0) == behindHome;
        final keeper = a.slot == sides[a.side].gkSlot;
        if (!(defends && keeper)) d += 1000;
      }
      if (d < bestD) {
        bestD = d;
        best = a;
      }
    }
    if (best == null) return;
    final v = (8 + 0.6 * bestD).clamp(8.0, 24.0);
    _kick(
      t,
      KickAction(
        toPlayerId: best.id,
        arriveAt: t + math.max(0.15, best.pos.distanceTo(at) / v),
      ),
    );
  }

  /// A ball still in the air when play stops (an interval, a kick-off, the
  /// final whistle) stops where it is: its flight so far, then it lies.
  void _cutFlight(double t) {
    final f = flight;
    if (f == null) return;
    if (t >= f.t1 - 1e-9) {
      _land(t);
      return;
    }
    final here = _ballNow(t);
    final height = _heightNow(t);
    if (t > f.t0 + 1e-9) {
      final k = (t - f.t0) / (f.t1 - f.t0);
      phases.add(
        FlightPhase(
          f.t0,
          t,
          from: f.from,
          to: here,
          // The same arc, cut short: a parabola's first part is one too.
          peak: f.peak * k * k,
          fromActor: f.fromActor,
          // Still the man it was played to, though it never reached him.
          toActor: f.toActor,
          pass: false,
          fromHeight: f.fromHeight,
          toHeight: height,
        ),
      );
    }
    flight = null;
    restAt = here;
    restHeight = height;
    phaseStart = t;
  }

  void _closePhase(double t) {
    final c = carrier;
    final rest = restAt;
    if (c != null && t > phaseStart + 1e-9) {
      phases.add(CarryPhase(phaseStart, t, c));
    } else if (rest != null && t > phaseStart + 1e-9) {
      phases.add(
        FlightPhase(
          phaseStart,
          t,
          from: rest,
          to: rest,
          peak: 0,
          fromActor: lastTouch,
          pass: false,
          fromHeight: restHeight,
          toHeight: restHeight,
        ),
      );
    }
    phaseStart = t;
  }

  void _land(double t) {
    final f = flight!;
    final toIndex = f.toActor;
    if (toIndex == null) {
      // Kicked to a point: it lies there.
      if (t > f.t0 + 1e-9) {
        phases.add(
          FlightPhase(
            f.t0,
            t,
            from: f.from,
            to: f.lead,
            peak: f.peak,
            fromActor: f.fromActor,
            pass: f.pass,
            fromHeight: f.fromHeight,
            toHeight: f.toHeight,
          ),
        );
      }
      flight = null;
      restAt = f.lead;
      restHeight = f.toHeight;
      phaseStart = t;
      return;
    }
    final to = agents[toIndex];
    if (!to.present && t < total - 1e-9) {
      _redirect(t);
      return;
    }
    final point = _ballPoint(to);
    phases.add(
      FlightPhase(
        f.t0,
        t,
        from: f.from,
        to: point,
        peak: f.peak,
        fromActor: f.fromActor,
        toActor: f.toActor,
        pass: f.pass,
        fromHeight: f.fromHeight,
        toHeight: f.toHeight,
      ),
    );
    flight = null;
    carrier = to.index;
    lastTouch = to.index;
    phaseStart = t;
    final side = sides[to.side];
    if (to.side != possession) {
      sides[possession].counterUntil = -1;
      possession = to.side;
      spellStart = t;
      spellEnd = t + _spellLength(possession);
      final minute = pacer.matchAt(_Builder._dur(t)).minute;
      spellDepth = _depthTarget(possession, minute);
      // Won in open play, short of the other third: a counter-minded side
      // breaks for goal.
      final intent = side.counterIntent;
      if (activeWindow == null &&
          intent > 0 &&
          xToDepth(point.x, _dir(to.side, minute)) < 60) {
        side.counterUntil = t + 2.5 + 2.5 * intent;
      }
      if (t < side.counterUntil) spellDepth = math.max(spellDepth, 84);
    }
    final tempo = side.instr.tempo;
    final hold = (0.55 + rng.nextDouble() * 0.8) * (1.15 - tempo / 250);
    // On the break the ball moves on at once.
    nextAction = t + (t < side.counterUntil ? hold * 0.3 : hold);
  }

  void _startFlight(
    double t,
    _Agent from,
    _Agent to, {
    required bool intercept,
    double? arriveAt,
    double? peak,
    bool quick = false,
  }) {
    final plan = _planFlight(t, from, to, intercept: intercept, quick: quick);
    final fastest = t + plan.$1.distanceTo(plan.$4) / 30;
    final t1 = arriveAt != null ? math.max(arriveAt, fastest) : t + plan.$2;
    _closePhase(t);
    flight = _Flight(
      t0: t,
      t1: t1,
      from: plan.$1,
      fromActor: from.index,
      toActor: to.index,
      peak: peak ?? plan.$3,
      lead: plan.$4,
    );
    carrier = null;
    restAt = null;
    lastTouch = from.index;
  }

  (Offset2, double, double, Offset2) _planFlight(
    double t,
    _Agent from,
    _Agent to, {
    required bool intercept,
    bool quick = false,
  }) {
    final start = _ballPoint(from);
    final away = (to.pos - start).unit;
    final dir = _dir(to.side, pacer.matchAt(_Builder._dur(t)).minute);
    var lead = intercept
        ? to.pos - away * 0.6
        : to.pos + away * 1.2 + Offset2(dir * 0.6, 0);
    lead = _Builder._clampPitch(lead, margin: 1.5);
    final dist = lead.distanceTo(start);
    final lofted = dist > 26;
    // Tempo sets the pace of the ball: zipped about, or rolled.
    final pace = 0.85 + 0.3 * sides[from.side].instr.tempo / 100;
    final v = quick
        ? (18 + 0.4 * dist).clamp(18.0, 28.0)
        : ((lofted ? 15 + 0.2 * dist : 11 + 0.4 * dist) * pace).clamp(
            10.0,
            27.0,
          );
    final dur = math.max(quick ? 0.25 : 0.4, dist / v);
    final peak = lofted ? math.min(1.5 + 0.12 * dist, 7).toDouble() : 0.0;
    return (start, dur, peak, lead);
  }

  /// The ball's receiver has gone: it carries on along its line to where
  /// it is now, and from there to the nearest team-mate of the passer.
  void _redirect(double t) {
    final f = flight!;
    final here = _ballNow(t);
    final height = _heightNow(t);
    // A receiver gone the instant the ball leaves adds no flight at all.
    if (t > f.t0 + 1e-9) {
      phases.add(
        FlightPhase(
          f.t0,
          t,
          from: f.from,
          to: here,
          peak: f.peak,
          fromActor: f.fromActor,
          pass: false,
          fromHeight: f.fromHeight,
          toHeight: height,
        ),
      );
    }
    final kicker = f.fromActor ?? f.toActor!;
    final side = agents[kicker].side;
    _Agent? best;
    var bestD = double.infinity;
    for (final o in agents) {
      if (!o.present || o.side != side || o.walkStart != null) continue;
      final d = o.pos.distanceTo(here);
      final score = d < PitchScriptValidator.minPass ? d + 1000 : d;
      if (score < bestD) {
        bestD = score;
        best = o;
      }
    }
    if (best == null) {
      flight = null;
      restAt = here;
      restHeight = 0;
      phaseStart = t;
      return;
    }
    final d = best.pos.distanceTo(here);
    flight = _Flight(
      t0: t,
      t1: t + math.max(0.3, d / 18),
      from: here,
      fromActor: f.fromActor,
      toActor: best.index,
      peak: 0,
      lead: best.pos,
      pass: false,
      fromHeight: height,
    );
  }

  /// A carrier who has to leave plays the ball off first: to the nearest
  /// team-mate a pass's length away, or failing that the furthest one.
  void _forcePass(_Agent a, double t) {
    _Agent? near;
    _Agent? far;
    var nearD = double.infinity;
    var farD = -1.0;
    for (final o in agents) {
      if (!o.present || o.side != a.side || o == a || o.walkStart != null) {
        continue;
      }
      final d = o.pos.distanceTo(a.pos);
      if (d >= 8 && d < nearD) {
        nearD = d;
        near = o;
      }
      if (d > farD) {
        farD = d;
        far = o;
      }
    }
    final to = near ?? far;
    if (to != null) _startFlight(t, a, to, intercept: false);
  }

  Offset2 _ballNow(double t) {
    final f = flight;
    if (f != null) {
      final u = f.t1 <= f.t0
          ? 1.0
          : ((t - f.t0) / (f.t1 - f.t0)).clamp(0.0, 1.0);
      return Offset2.lerp(f.from, f.lead, u);
    }
    final c = carrier;
    if (c != null) return _ballPoint(agents[c]);
    return restAt ?? PitchDims.centre;
  }

  double _heightNow(double t) {
    final f = flight;
    if (f == null) return carrier == null ? restHeight : 0;
    final u = f.t1 <= f.t0 ? 1.0 : ((t - f.t0) / (f.t1 - f.t0)).clamp(0.0, 1.0);
    return f.fromHeight +
        (f.toHeight - f.fromHeight) * u +
        4 * f.peak * u * (1 - u);
  }
}
