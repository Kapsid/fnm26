part of '../story_layer.dart';

/// A routine restart on its way (spec item 13): the ball going out, then
/// the throw or the goal kick that opens the build-up to the next moment.
class _Restart {
  _Restart({
    required this.kind,
    required this.side,
    required this.taker,
    required this.outAt,
    required this.stand,
    required this.window,
    required this.slot,
  });

  final PitchRestartKind kind;
  final int side;

  /// The man who takes it (agent index), and where he takes it from.
  final int taker;
  final Offset2 stand;

  /// Where the ball goes out: just over the touchline for a throw, behind
  /// the goal line for a goal kick.
  final Offset2 outAt;

  /// The window whose build-up it opens, and the engine's minute it is
  /// counted against.
  final int window;
  final int slot;

  /// When the ball went out (lay still beyond the line).
  double? out;

  /// A goal kick: when the ball was set down in the six-yard box.
  bool placed = false;
}

/// How long a restart may take, from the ball going out to the taker
/// putting it back in play.
const double _restartMax = 1.0;

/// The longest a restart may be taken before the moment it opens the
/// build-up to: the lead-in and a second, and for a goal kick two more for
/// its long ball.
double _restartLead(PitchRestartKind kind) =>
    LeadIn.ball + (kind == PitchRestartKind.goalKick ? 3 : 1);

/// How near the ball the taker stands to take it: a throw or a goal kick
/// leaves from him.
const double _takerReach = 1.6;

/// Routine restarts shown in the flow: only one that opens the build-up to
/// the next staged moment, that side's shot or corner, and only as many in
/// a minute as the engine counted.
extension _Restarts on _Builder {
  /// The engine's `routineRestarts` index for a match minute: stoppage
  /// folds onto 90.
  int _restartSlot(double t) {
    final m = pacer.matchAt(_Builder._dur(t));
    return m.minute > 90 || m.stoppage == 0 ? m.minute : 90;
  }

  bool _restartLeft(int slot) {
    final counts = result.routineRestarts;
    if (slot < 0 || slot >= counts.length) return false;
    return (restartsIn[slot] ?? 0) < counts[slot];
  }

  /// In quiet time, with the other side on the ball and the next moment
  /// [side]'s shot or corner a few seconds away: the ball goes out, and
  /// [side] restarts it into the build-up. True when one has begun.
  bool _maybeRestart(double t, _Agent a) {
    if (restart != null || wi >= windows.length) return false;
    final w = windows[wi];
    if (w.moments.isEmpty || restartedFor == wi) return false;
    final m = w.moments.first;
    final leads = switch (m) {
      ShotMoment(:final origin) => origin != ShotOrigin.penalty,
      SetPieceMoment(:final kind) => kind == SetPieceKind.corner,
      _ => false,
    };
    if (!leads) return false;
    final s = m.teamNationId == lineups.home.nationId ? 0 : 1;
    if (a.side == s) return false;
    final gap = w.start - t;
    if (gap < 3.0 || gap > 8.5 || _nextStop(t) < w.start - 1e-9) return false;
    final slot = _restartSlot(t);
    if (!_restartLeft(slot)) return false;
    final minute = pacer.matchAt(_Builder._dur(t)).minute;
    final ball = _ballPoint(a);
    final from = ball;
    final dir = _dir(s, minute);
    final side = sides[s];
    _Restart? plan;
    // A goal kick: the other side's ball runs out behind [side]'s goal, and
    // the keeper's long kick starts the counter that ends in the moment.
    final keeperIdx = side.owner[side.gkSlot];
    if (xToDepth(ball.x, dir) < 35 &&
        keeperIdx != null &&
        side.standIn == null &&
        agents[keeperIdx].walkStart == null &&
        !agents[keeperIdx].headingInGoal &&
        !_departsWithin(agents[keeperIdx], t, 10)) {
      final latSign = (ball.y - PitchDims.width / 2) * dir >= 0 ? 1.0 : -1.0;
      final outAt = Offset2(
        depthToX(-1.5, dir),
        lateralToY(latSign * 14, dir),
      );
      final stand = Offset2(depthToX(5.5, dir), lateralToY(latSign * 5, dir));
      final k = agents[keeperIdx];
      final kick = _Restart(
        kind: PitchRestartKind.goalKick,
        side: s,
        taker: keeperIdx,
        outAt: outAt,
        stand: stand,
        window: wi,
        slot: slot,
      );
      // Only with somebody up the pitch to kick it to: no counter, no goal
      // kick to show.
      if (k.pos.distanceTo(stand) < 12 &&
          _restartReceiver(kick, t, stand) != null) {
        plan = kick;
      }
    }
    // A throw-in: it runs out over the touchline by one of [side]'s men.
    if (plan == null) {
      final avoid = _busyAhead(t);
      final wanted = _wantedOnBall(w);
      _Agent? taker;
      var best = double.infinity;
      for (final o in agents) {
        if (!o.present || o.side != s || o.walkStart != null) continue;
        if (o.slot == side.gkSlot || o.headingInGoal) continue;
        if (_departsWithin(o, t, 10) || avoid.contains(o.id)) continue;
        if (o.id == wanted) continue;
        final edge = math.min(o.pos.y, PitchDims.width - o.pos.y);
        if (edge > 14) continue;
        final d = o.pos.distanceTo(from);
        if (d < 8 || d > 36) continue;
        final depth = xToDepth(o.pos.x, dir);
        if (depth < 8 || depth > 95) continue;
        if (edge < best) {
          best = edge;
          taker = o;
        }
      }
      if (taker == null) return false;
      final top = taker.pos.y < PitchDims.width / 2;
      final outAt = Offset2(taker.pos.x, top ? -0.6 : PitchDims.width + 0.6);
      final stand = Offset2(taker.pos.x, top ? 0.5 : PitchDims.width - 0.5);
      plan = _Restart(
        kind: PitchRestartKind.throwIn,
        side: s,
        taker: taker.index,
        outAt: outAt,
        stand: stand,
        window: wi,
        slot: slot,
      );
    }
    // The ball has to be out, back in and on its way with time to spare.
    final d = from.distanceTo(plan.outAt);
    final flightTime = math.max(0.5, d / 17);
    // A goal kick's long ball is in the air a couple of seconds more, and
    // the counter has to land before the moment.
    final after = plan.kind == PitchRestartKind.goalKick ? 3.6 : 1.2;
    if (flightTime + _restartMax + after > gap) return false;
    // ... and not so long before the moment that it is a build-up of its
    // own: the moment follows within the lead-in.
    if (gap - flightTime - 0.3 > _restartLead(plan.kind)) return false;
    restart = plan;
    restartedFor = wi;
    _kick(
      t,
      KickAction(
        to: plan.outAt,
        arriveAt: t + flightTime,
        peak: d > 26 ? math.min(1.5 + 0.1 * d, 5).toDouble() : 0.3,
      ),
    );
    return true;
  }

  /// Whether side [s] is on the build-up a restart of its own opened: it
  /// keeps the ball into the moment.
  bool _restartBuildUp(int s) {
    if (restartedFor != wi || wi >= windows.length) return false;
    final w = windows[wi];
    if (w.moments.isEmpty) return false;
    return (w.moments.first.teamNationId == lineups.home.nationId ? 0 : 1) == s;
  }

  /// Where the restart's taker goes: to his place to take it.
  (Offset2, double, int)? _restartDrive(_Agent a) {
    final r = restart;
    if (r == null || r.taker != a.index) return null;
    return (r.stand, 7.0, 2);
  }

  /// The ball lies out of play (or set down for the goal kick): the
  /// restart's next step, once the taker is there.
  void _restartBall(double t) {
    final r = restart!;
    final at = restAt!;
    final taker = agents[r.taker];
    if (!taker.present || taker.walkStart != null) {
      restart = null;
      return;
    }
    if (r.out == null) {
      r.out = t;
      if (_restartSlot(t) != r.slot && !_restartLeft(_restartSlot(t))) {
        // Counted in a minute with none left: it flows on unseen.
        restart = null;
        return;
      }
    }
    final since = t - r.out!;
    if (r.kind == PitchRestartKind.goalKick && !r.placed) {
      // Back from behind the goal to the six-yard box.
      r.placed = true;
      _kick(
        t,
        KickAction(to: r.stand, arriveAt: t + 0.45, peak: 0.5),
      );
      return;
    }
    final ready = taker.pos.distanceTo(at) <= _takerReach && since >= 0.3;
    if (!ready && since < _restartMax - 1e-9) {
      wakeAt = math.min(wakeAt, t + 0.05);
      return;
    }
    if (taker.pos.distanceTo(at) > _takerReach) {
      // He never got to the ball: no restart to show.
      restart = null;
      return;
    }
    final to = _restartReceiver(r, t, at);
    if (to == null) {
      restart = null;
      return;
    }
    final d = to.pos.distanceTo(at);
    final throwIn = r.kind == PitchRestartKind.throwIn;
    final arrive =
        t + (throwIn ? math.max(d / 13, 0.5) : math.max(d / 25, 0.9));
    // A goal kick becomes a counter: the side breaks from the moment the
    // long ball lands, whatever its usual style.
    if (!throwIn) sides[r.side].counterUntil = arrive + 3;
    _kick(
      t,
      KickAction(
        toPlayerId: to.id,
        byPlayerId: taker.id,
        arriveAt: arrive,
        peak: throwIn ? 0.8 : math.min(2 + 0.12 * d, 8).toDouble(),
        fromHeight: throwIn ? 2.0 : 0,
        pass: true,
      ),
    );
    restarts.add((
      out: r.out!,
      taken: t,
      kind: r.kind,
      teamNationId: sides[r.side].nationId,
      takerId: taker.id,
    ));
    restartsIn[r.slot] = (restartsIn[r.slot] ?? 0) + 1;
    restart = null;
  }

  /// Who a restart goes to: a team-mate in range and onside; for a throw
  /// the nearest sensible one up the line, for a goal kick a man well up
  /// the pitch.
  _Agent? _restartReceiver(_Restart r, double t, Offset2 at) {
    final minute = pacer.matchAt(_Builder._dur(t)).minute;
    final dir = _dir(r.side, minute);
    final onsideUpTo = math.max(
      _secondLastDepth(r.side, dir),
      PitchDims.length / 2,
    );
    final avoid = _busyAhead(t);
    final throwIn = r.kind == PitchRestartKind.throwIn;
    _Agent? best;
    var bestScore = -double.infinity;
    for (final o in agents) {
      if (!o.present || o.side != r.side || o.index == r.taker) continue;
      if (o.walkStart != null || o.slot == sides[r.side].gkSlot) continue;
      if (_departsWithin(o, t, 6) || avoid.contains(o.id)) continue;
      final depth = xToDepth(o.pos.x, dir);
      if (depth > onsideUpTo) continue;
      // To where the ball meets him (his feet, a stride in front of him),
      // as the throw is played: never a pass under the shortest.
      final d = _ballPoint(o).distanceTo(at);
      final double score;
      if (throwIn) {
        if (d < 7 || d > 22) continue;
        score = -(d - 12).abs() / 4 + (depth - xToDepth(at.x, dir)) / 10;
      } else {
        // Long, to the man furthest up the pitch: the start of a counter.
        if (d < 30 || d > 65 || depth < 40) continue;
        score = depth / 8 - (d - 50).abs() / 20;
      }
      if (score > bestScore) {
        bestScore = score;
        best = o;
      }
    }
    return best;
  }
}
