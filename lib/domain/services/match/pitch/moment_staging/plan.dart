part of '../moment_staging.dart';

/// What every plan shares: the moment's side and the way it attacks, the
/// window's seeded randomness, and the small vocabulary of moves.
abstract class _Plan implements StagedPlan {
  _Plan(this.c, int nation)
    : w = c.window,
      rng = SeededRng(c.seed),
      side = nation {
    final homeSide = nation == c.lineups.home.nationId;
    opp = homeSide ? c.lineups.away.nationId : c.lineups.home.nationId;
    dir = homeSide ? c.homeDir : -c.homeDir;
    resumed = c.resuming || c.entry.t > w.start + 1e-6;
  }

  final StagingContext c;
  final StagedWindow w;
  final SeededRng rng;

  /// The side the moment belongs to.
  final int side;
  late final int opp;

  /// Which way [side] attacks.
  late final int dir;

  /// Whether this window is staged from part-way through.
  late final bool resumed;

  /// Fixed targets, set once.
  final Map<int, PlayerDrive> fixed = {};

  /// Screen seconds the moment has from its window's start: the window,
  /// and the quiet time after it that it may play on into.
  double get room {
    final n = c.next;
    var until = end + 2.5;
    if (n != null) until = math.min(until, n.start - 0.2);
    return math.max(len, until - start);
  }

  double get start => w.start;
  double get end => w.end;
  double get len => w.end - w.start;

  Offset2 at(double depth, double lateral) => _pt(dir, depth, lateral);
  double depthOf(Offset2 p) => xToDepth(p.x, dir);
  double latOf(Offset2 p) => (p.y - PitchDims.width / 2) * dir;
  Offset2 get goal => at(_goalLine, 0);

  @override
  bool settled(double t, ScriptState now) => true;

  /// The plan's own moves for [id]; null leaves it to [fixed] and the
  /// common ones.
  PlayerDrive? steer(int id, double t, ScriptState now);

  @override
  PlayerDrive? drive(int id, double t, ScriptState now) {
    if (now.walking.contains(id)) return null;
    return steer(id, t, now) ?? fixed[id] ?? _nextTaker(id, now);
  }

  /// The next moment's men, when it follows straight on, get where it
  /// needs them while this one plays out: a set piece's taker to his ball,
  /// a shooter toward where he shoots from (onside), the man to be flagged
  /// beyond the line, the man who fouls toward his victim.
  PlayerDrive? _nextTaker(int id, ScriptState now) {
    // Keepers keep goal until their own moment.
    if (w.actors.contains(id) || now.keepers.contains(id)) return null;
    for (final n in c.ahead) {
      if (n.moments.isEmpty || n.start - end > LeadIn.taker) continue;
      final d = _aheadDrive(n, id, now);
      if (d != null) return d;
    }
    return null;
  }

  PlayerDrive? _aheadDrive(StagedWindow n, int id, ScriptState now) {
    final m = n.moments.first;
    final mine = m.teamNationId == side;
    final ndir = mine ? dir : -dir;
    final p = now.players[id];
    if (p == null) return null;
    // The offside line [m]'s side faces, as depth up the pitch for it.
    double line() {
      return math.max(
        secondLastFor(now, m.teamNationId, ndir),
        xToDepth(now.ball.x, ndir),
      );
    }

    switch (m) {
      case SetPieceMoment(:final takerId) when takerId == id && !m.routine:
        return (target: deadBallSpot(m, ndir), maxSpeed: 7);
      case ShotMoment(:final shooterId, :final origin)
          when origin == ShotOrigin.penalty && shooterId == id:
        return (
          target: _pt(ndir, PitchDims.penaltySpotDepth - 4, 0),
          maxSpeed: 6,
        );
      case ShotMoment(:final shooterId, :final zone) when shooterId == id:
        final want = zonePoint(zone, ndir);
        var d = xToDepth(want.x, ndir);
        if (d > PitchDims.length / 2) {
          d = math.min(d, math.max(line() - 0.8, PitchDims.length / 2));
        }
        return (target: Offset2(depthToX(d, ndir), want.y), maxSpeed: 7);
      case OffsideMoment(:final playerId)
          when playerId == id && n.start - end < LeadIn.ball:
        final d = (line() + 2.5).clamp(55.0, 100.0);
        return (target: Offset2(depthToX(d, ndir), p.y), maxSpeed: 7);
      case FoulMoment(:final foulerId, :final fouledId)
          when foulerId == id && n.start - end < LeadIn.foul:
        final v = now.players[fouledId];
        if (v == null) return null;
        return (target: v + (p - v).unit * 2.0, maxSpeed: 7);
      default:
        return null;
    }
  }

  /// [nation]'s men on the pitch and free to play a part: not walking off
  /// and not due to.
  List<int> available(
    ScriptState now,
    int nation, {
    Set<int> except = const {},
  }) => [
    for (final e in now.players.entries)
      if (now.teams[e.key] == nation &&
          !now.walking.contains(e.key) &&
          !c.departing.contains(e.key) &&
          !except.contains(e.key))
        e.key,
  ]..sort();

  /// [nation]'s instructions as it plays them now.
  TacticalInstructions instr(int nation) =>
      c.instructions[nation] ?? const TacticalInstructions();

  /// How much [nation] looks to break the moment it wins the ball (0-1),
  /// as the story layer reads it: tempo and directness over mentality and
  /// pressing.
  double counterIntent(int nation) {
    final i = instr(nation);
    final k = ((i.tempo + i.directness) - (i.mentality + i.pressing)) / 100;
    return ((k - 0.2) / 0.4).clamp(0.0, 1.0);
  }

  /// [id]'s place on the team sheet (the live changes' last say), or null
  /// for a man who came on.
  PlayerPosition? slotOf(int id) {
    for (final ch in c.lineups.changes.reversed) {
      final k = ch.xi.indexOf(id);
      if (k < 0) continue;
      final slot = ch.slotOf[k];
      final pos = ch.formation.positions;
      return slot >= 0 && slot < pos.length ? pos[slot] : null;
    }
    for (final side in [c.lineups.home, c.lineups.away]) {
      for (final p in side.xi) {
        if (p.playerId == id) return p.slot;
      }
    }
    return null;
  }

  bool onPitch(ScriptState now, int? id) =>
      id != null && now.players.containsKey(id) && !now.walking.contains(id);

  /// Who keeps goal for [nation] now: [named] when he is on the pitch,
  /// else whoever holds the side's keeper slot.
  int? keeperOf(ScriptState now, int nation, [int? named]) {
    if (named != null && now.teams[named] == nation && onPitch(now, named)) {
      return named;
    }
    for (final k in now.keepers) {
      if (now.teams[k] == nation) return k;
    }
    return null;
  }

  /// The offside line for [side]: how far up the pitch the second-last
  /// opponent stands (men walking off apart).
  double offsideLine(ScriptState now) => secondLastFor(now, side, dir);

  /// How far up the pitch, for [nation] attacking [ndir], the second-last
  /// of its opponents stands (men walking off apart).
  static double secondLastFor(ScriptState now, int nation, int ndir) {
    var first = -1.0;
    var second = -1.0;
    now.players.forEach((id, p) {
      if (now.teams[id] == nation || now.walking.contains(id)) return;
      final d = xToDepth(p.x, ndir);
      if (d > first) {
        second = first;
        first = d;
      } else if (d > second) {
        second = d;
      }
    });
    return second < 0 ? _goalLine : second;
  }

  /// Whether [id] of [side] is onside now, the ball where it is.
  bool onside(ScriptState now, int id) {
    if (now.teams[id] != side) return true;
    final p = now.players[id];
    if (p == null) return true;
    final d = depthOf(p);
    // In his own half, by a hair more than the instant of the kick moves
    // him (on the line itself and running on, he is in theirs).
    if (d <= PitchDims.length / 2 - 0.1) return true;
    return d <= math.max(offsideLine(now), depthOf(now.ball)) + 1e-6;
  }

  /// Whether [id] is clearly onside: by [margin] metres behind the line
  /// (or halfway). For a ball played to a man running at speed, who on the
  /// very frame of the kick may already be a stride on from where the
  /// stager read him.
  bool clearlyOnside(ScriptState now, int id, {double margin = 0.5}) {
    if (now.teams[id] != side) return true;
    final p = now.players[id];
    if (p == null) return true;
    final d = depthOf(p);
    if (d <= PitchDims.length / 2 - margin) return true;
    return d <= math.max(offsideLine(now), depthOf(now.ball)) - margin;
  }

  /// [target] pulled back to where [side]'s man stays onside.
  Offset2 keepOnside(ScriptState now, Offset2 target) {
    final d = depthOf(target);
    if (d <= PitchDims.length / 2) return target;
    final limit = math.max(offsideLine(now), depthOf(now.ball)) - 0.6;
    if (d <= limit) return target;
    // Against a high line he waits a stride inside his own half, never on
    // the halfway line itself: a man held there and moving on is beyond
    // it, and offside, the instant the ball is played.
    return at(math.max(limit, PitchDims.length / 2 - 0.6), latOf(target));
  }

  /// The ball to [to] by whatever means: a pass from a team-mate, a ball
  /// played to him from an opponent or from where it lies. Null once he has
  /// it, while it is in the air, or (with [needOnside]) while he is
  /// offside.
  BallAction? fetch(
    int to,
    double t,
    ScriptState now, {
    bool needOnside = false,
    bool cross = false,
    double toHeight = 0,
  }) {
    if (now.flight != null || now.carrierId == to) return null;
    final tp = now.players[to];
    if (tp == null || now.walking.contains(to)) return null;
    if (needOnside && !onside(now, to)) return null;
    final car = now.carrierId;
    final d = now.ball.distanceTo(tp);
    final mates = car != null && now.teams[car] == now.teams[to];
    final v = cross
        ? (15 + 0.2 * d).clamp(15.0, 22.0)
        : (12 + 0.45 * d).clamp(12.0, d > 35 ? 31.0 : 26.0);
    final arrive = t + math.max(d / v, 0.2);
    if (mates && !cross && toHeight == 0 && d >= 9) {
      return PassAction(toPlayerId: to, arriveAt: arrive);
    }
    return KickAction(
      toPlayerId: to,
      arriveAt: arrive,
      peak: cross ? math.min(1.5 + 0.12 * d, 6).toDouble() : 0,
      toHeight: toHeight,
      pass: mates && d >= 9,
    );
  }

  /// The ball to the point [p], where it lies: rolled there at about
  /// [speed], faster over a long way.
  KickAction place(double t, ScriptState now, Offset2 p, {double speed = 12}) {
    final d = now.ball.distanceTo(p);
    final v = math.max(speed, math.min(6 + 0.5 * d, 22));
    return KickAction(
      to: p,
      arriveAt: t + math.max(d / v, 0.15),
      peak: d > 20 ? 2 : (d > 3 ? 0.3 : 0),
    );
  }

  /// [nation]'s man nearest [p] among [ids].
  int? nearest(ScriptState now, Iterable<int> ids, Offset2 p) {
    int? best;
    var bestD = double.infinity;
    for (final id in ids) {
      final q = now.players[id];
      if (q == null) continue;
      final d = q.distanceTo(p);
      if (d < bestD) {
        bestD = d;
        best = id;
      }
    }
    return best;
  }

  /// Gives each of [ids] one of [spots], the closest pairs first. Returns
  /// the targets by player id.
  Map<int, Offset2> assign(
    ScriptState now,
    List<int> ids,
    List<Offset2> spots,
  ) {
    final pairs = <(double, int, int)>[];
    for (final id in ids) {
      final p = now.players[id];
      if (p == null) continue;
      for (var k = 0; k < spots.length; k++) {
        pairs.add((p.distanceTo(spots[k]), id, k));
      }
    }
    pairs.sort((a, b) {
      final x = a.$1.compareTo(b.$1);
      if (x != 0) return x;
      final y = a.$2.compareTo(b.$2);
      return y != 0 ? y : a.$3.compareTo(b.$3);
    });
    final out = <int, Offset2>{};
    final used = <int>{};
    for (final (_, id, k) in pairs) {
      if (out.containsKey(id) || used.contains(k)) continue;
      out[id] = spots[k];
      used.add(k);
    }
    return out;
  }

  /// Which side is owed more ball time now: the one a moment's open ending
  /// (a parry, a rebound) falls to.
  int owedSide(ScriptState now) =>
      c.owedTo(side, now) > c.owedTo(opp, now) + 0.5 ? side : opp;

  /// Whether this plan has cut the picture to a new phase of play.
  bool sceneCut = false;

  /// Whether the plan may cut now: never on the very frame a resume
  /// starts from, which has to match what was shown.
  bool settledIn(double t) => !resumed || t > c.entry.t + 0.2;

  /// Whether [id] has the ball: at his feet, or lying there after a cut.
  bool holds(ScriptState now, int id) {
    if (now.carrierId == id) return true;
    final q = now.players[id];
    return now.carrierId == null &&
        now.flight == null &&
        q != null &&
        q.distanceTo(now.ball) < 1.3;
  }

  /// A cut that only puts [id] onside, behind their second-last man, the
  /// ball lying where it is.
  CutAction holdOnside(ScriptState now, int id, PitchCutKind kind) => CutAction(
    ballAt: now.ball,
    positions: const {},
    kind: kind,
    onside: {id},
  );

  /// Whether a ball in the air is about to come down: a cut waits for it.
  bool landing(ScriptState now) {
    final f = now.flight;
    if (f == null) return false;
    return f.t1 - now.t < 0.6 || _isShot(now, f);
  }

  /// Whether the ball in the air is a moment's shot (struck at goal, at a
  /// keeper or into a blocker by the last moment's shooter): it is never
  /// cut short.
  static bool _isShot(ScriptState now, ScriptFlight f) =>
      !f.pass &&
      (f.toId == null || now.keepers.contains(f.toId)) &&
      f.lead.x > 0 &&
      (f.lead.x < 6 || f.lead.x > PitchDims.length - 6);

  /// Seconds until the ball can be at [id]'s feet, from where it is now.
  double ballTo(ScriptState now, int id) {
    if (now.carrierId == id) return 0;
    final p = now.players[id];
    if (p == null) return double.infinity;
    final f = now.flight;
    final wait = f == null ? 0.0 : math.max(0.0, f.t1 - now.t);
    final from = f == null ? now.ball : f.lead;
    // One long ball (40-60 m in about two seconds) is fine before cutting.
    final d = from.distanceTo(p);
    return wait + d / (d > 35 ? 30 : 26) + 0.15;
  }

  /// A cut to a new phase of play, for a moment that cannot be reached
  /// from where play is (the last moment ended at the other end, a minute
  /// of match time ago): the picture cuts, as a broadcast does between two
  /// attacks, to [anchor] at [anchorAt] with the ball at his feet and both
  /// sides lined up in their shapes around it (the story layer's own shape
  /// model). [extra] places a few named men exactly; [offside] is put
  /// beyond the line and [onside] behind it. The defending keeper is set
  /// for the ball; men walking off are left alone.
  CutAction cutToPhase(
    ScriptState now,
    int anchor,
    Offset2 anchorAt, {
    Map<int, Offset2> extra = const {},
    int? offside,
    Set<int> onside = const {},
  }) {
    sceneCut = true;
    final toGoal = (goal - anchorAt).unit;
    final ball = anchorAt + toGoal * 0.7;
    final positions = <int, Offset2>{anchor: anchorAt};
    final k = keeperOf(now, opp);
    if (k != null) {
      final g = goal;
      final off = (ball.distanceTo(g) * 0.12).clamp(1.0, 4.0);
      final spot = g + (ball - g).unit * off;
      positions[k] = at(
        math.min(depthOf(spot), _goalLine - 0.6),
        latOf(
          spot,
        ).clamp(-PitchDims.goalHalfWidth + 0.6, PitchDims.goalHalfWidth - 0.6),
      );
    }
    positions.addAll(extra);
    return CutAction(
      ballAt: ball,
      positions: positions,
      kind: PitchCutKind.phase,
      possession: side,
      offside: offside,
      onside: onside,
    );
  }

  void cue(double t, PitchCueKind kind, int playerId) {
    if (w.cues.any((q) => q.kind == kind && q.playerId == playerId)) return;
    w.cues.add((t: t, kind: kind, playerId: playerId));
  }

  /// A light reaction of the men the moment does not name, near the ball:
  /// defenders drop goal-side of it, attackers ease forward, onside.
  ///
  /// Each settles, asked anew every step: a defender on the line from the
  /// ball to his goal, an attacker a few metres beyond the ball; and
  /// neither is ever nearer the goal line than
  /// [_reactFloor] (a man nearer it steps out to it). A step
  /// toward goal from wherever he now stood was asked of them before, so
  /// over a moment of a few seconds the men near the ball walked on and on
  /// until they stood on the goal line.
  PlayerDrive? react(int id, ScriptState now, {Set<int> skip = const {}}) {
    if (skip.contains(id) || now.keepers.contains(id)) return null;
    final p = now.players[id];
    if (p == null || p.distanceTo(now.ball) > 26) return null;
    // A man a set piece left on the goal line steps straight out first.
    const cap = _goalLine - _reactFloor;
    if (depthOf(p) > cap + 0.1) {
      return (target: at(cap - 0.5, latOf(p)), maxSpeed: 4.0);
    }
    if (now.teams[id] == opp) {
      // Goal-side: toward the line from the ball to the goal it defends.
      final g = goal;
      final b = now.ball;
      final ab = g - b;
      final l2 = ab.x * ab.x + ab.y * ab.y;
      var u = l2 < 1e-9
          ? 0.0
          : (((p.x - b.x) * ab.x + (p.y - b.y) * ab.y) / l2).clamp(0.15, 0.8);
      if (u.isNaN) u = 0.5;
      final onLine = b + ab * u;
      return (target: _floored(p + (onLine - p) * 0.6), maxSpeed: 3.2);
    }
    if (now.teams[id] == side && now.carrierId != id) {
      // Up with the ball until a few metres beyond it, then he holds.
      final d = depthOf(p);
      final want = math.min(d + 3, math.max(d, depthOf(now.ball) + 6));
      final target = keepOnside(now, at(want, latOf(p)));
      return (target: _floored(target), maxSpeed: 3);
    }
    return null;
  }

  /// The nearest a man reacting to the ball comes to the goal line it
  /// faces: the six-yard box's edge. Set pieces and the moment's named men
  /// are not reactions and go where they must.
  static const double _reactFloor = 6.5;

  /// [target] held off the goal line by [_reactFloor]: a man nearer it
  /// (one a set piece left there) steps out to it.
  Offset2 _floored(Offset2 target) {
    final cap = _goalLine - _reactFloor;
    return depthOf(target) <= cap ? target : at(cap, latOf(target));
  }
}
