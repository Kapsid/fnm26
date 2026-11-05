/// The stagers: every real moment of a match played on the pitch from its
/// data, inside the window the story layer leaves for it.
///
/// One plan per moment type: a shot (by its origin), a corner, a free kick,
/// a penalty, a long throw, a foul with its card, an offside, a sub and an
/// injury. Each reads the moment (who, where, what happened) and the state
/// the window opens on, and says where the men it needs go and what the
/// ball does. The outcome is the record's: a goal ends in the net, a save
/// in the keeper's hands (or parried by him), a shot wide passes outside a
/// post or over the bar, one off the woodwork strikes a post or the bar, a
/// blocked one is stopped by a defender in its path. The men the moment
/// names do what it says they did, and every pass in a goal's move finds a
/// man onside.
///
/// Plans react to the state they are handed each step rather than
/// replaying a fixed script, so a window staged from part-way through (a
/// resume) carries on coherently. Their own randomness (a penalty's lane,
/// where in its zone a shot is struck) comes from the window's seed only.
/// Pure Dart: no Flutter.
library;

import 'dart:math' as math;

import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_moments.dart';
import 'package:fnm/domain/services/match/pitch/pitch_geometry.dart';
import 'package:fnm/domain/services/match/pitch/pitch_script.dart';
import 'package:fnm/domain/services/match/pitch/story_layer.dart';

/// Half the goal's width: each post stands this far from the long axis.
const double goalHalfWidth = 3.66;

/// The crossbar's height.
const double crossbarHeight = 2.44;

/// How far up the pitch the penalty mark is, from the goal a side defends
/// (11 m out from the goal it attacks).
const double penaltySpotDepth = PitchDims.length - 11;

/// How far the defending side stands from a dead ball.
const double wallDistance = 9.15;

/// How high a header is met.
const double headerHeight = 1.9;

const double _goalLine = PitchDims.length;
const double _boxEdge = PitchDims.length - PitchDims.boxDepth;

/// The point [depth] metres up from the goal it defends and [lateral] to its
/// right, for a side attacking [dir].
Offset2 _pt(int dir, double depth, double lateral) =>
    Offset2(depthToX(depth, dir), lateralToY(lateral, dir));

int _spotKey(int minute, int stoppage, int team) =>
    (minute * 7919 + stoppage * 131 + team * 40503) & 0x7FFFFFFF;

double _unit(int key, int salt) =>
    SeededRng((key ^ (salt * 0x85EBCA6B)) & 0xFFFFFFFF).nextDouble();

/// Where a foul in [zone] happens, for the side fouled attacking [dir]: a
/// fixed point inside the zone, the same for the foul and the free kick it
/// gives ([key] from their minute and side).
Offset2 foulSpot(PitchZone zone, int dir, int key) {
  double r(int salt, double lo, double hi) => lo + (hi - lo) * _unit(key, salt);
  final (depth, lat) = switch (zone) {
    PitchZone.sixYard => (r(1, 99.5, 101.5), r(2, -4, 4)),
    PitchZone.boxCentre => (r(1, 90.5, 96), r(2, -5.5, 5.5)),
    PitchZone.boxLeft => (r(1, 90, 98), r(2, -16, -7)),
    PitchZone.boxRight => (r(1, 90, 98), r(2, 7, 16)),
    PitchZone.edgeOfBox => (r(1, 80.5, 86.5), r(2, -9, 9)),
    PitchZone.longRange => (r(1, 72, 79), r(2, -11, 11)),
    PitchZone.wideLeft => (r(1, 86, 97), r(2, -30, -21)),
    PitchZone.wideRight => (r(1, 86, 97), r(2, 21, 30)),
    PitchZone.midfield => (r(1, 38, 66), r(2, -22, 22)),
  };
  return _pt(dir, depth, lat);
}

/// Where [p] is taken from, for its side attacking [dir]: a corner from the
/// arc on the flank [SetPieceMoment.left] names, a throw from that
/// touchline, a free kick from where its foul was.
Offset2 deadBallSpot(SetPieceMoment p, int dir) {
  final key = _spotKey(p.minute, p.stoppage, p.teamNationId);
  final sign = p.left ? -1.0 : 1.0;
  return switch (p.kind) {
    SetPieceKind.corner => _pt(dir, _goalLine - 0.4, sign * 33.6),
    SetPieceKind.longThrow || SetPieceKind.throwIn => _pt(
      dir,
      84 + 12 * _unit(key, 3),
      sign * 33.5,
    ),
    SetPieceKind.goalKick => _pt(dir, 5.5, sign * 5),
    SetPieceKind.freeKick => foulSpot(p.zone, dir, key),
  };
}

/// Stages every real moment from its data. The story layer's default.
class MomentStaging implements MomentStager {
  const MomentStaging();

  @override
  StagedPlan stage(StagingContext context) {
    final w = context.window;
    final injury = w.injury;
    if (injury != null || w.moments.isEmpty) {
      return _InjuryPlan(context, injury?.playerId);
    }
    final m = w.moments.first;
    ShotMoment? folded;
    for (final x in w.moments.skip(1)) {
      if (x is ShotMoment) folded = x;
    }
    return switch (m) {
      ShotMoment(:final origin) when origin == ShotOrigin.penalty =>
        _PenaltyPlan(context, m),
      ShotMoment() => _OpenShotPlan(context, m),
      SetPieceMoment(:final kind) when kind == SetPieceKind.corner =>
        _CornerPlan(context, m, folded),
      SetPieceMoment(:final kind)
          when kind == SetPieceKind.longThrow || kind == SetPieceKind.throwIn =>
        _ThrowPlan(context, m, folded),
      SetPieceMoment() => _FreeKickPlan(context, m, folded),
      FoulMoment() => _FoulPlan(context, m),
      OffsideMoment() => _OffsidePlan(context, m),
      SubMoment() => _SubPlan(context, m),
    };
  }
}

// ---------------------------------------------------------------------------

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
    if (w.actors.contains(id)) return null;
    for (final n in c.ahead) {
      if (n.moments.isEmpty || n.start - end > 15) continue;
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
      var first = -1.0;
      var second = -1.0;
      now.players.forEach((o, q) {
        if (now.teams[o] == m.teamNationId || now.walking.contains(o)) return;
        final d = xToDepth(q.x, ndir);
        if (d > first) {
          second = first;
          first = d;
        } else if (d > second) {
          second = d;
        }
      });
      return math.max(
        second < 0 ? _goalLine : second,
        xToDepth(now.ball.x, ndir),
      );
    }

    switch (m) {
      case SetPieceMoment(:final takerId) when takerId == id && !m.routine:
        return (target: deadBallSpot(m, ndir), maxSpeed: 7);
      case ShotMoment(:final shooterId, :final origin)
          when origin == ShotOrigin.penalty && shooterId == id:
        return (target: _pt(ndir, penaltySpotDepth - 4, 0), maxSpeed: 6);
      case ShotMoment(:final shooterId, :final zone) when shooterId == id:
        final want = zonePoint(zone, ndir);
        var d = xToDepth(want.x, ndir);
        if (d > PitchDims.length / 2) {
          d = math.min(d, math.max(line() - 0.8, PitchDims.length / 2));
        }
        return (target: Offset2(depthToX(d, ndir), want.y), maxSpeed: 7);
      case OffsideMoment(:final playerId)
          when playerId == id && n.start - end < 3.5:
        final d = (line() + 2.5).clamp(55.0, 100.0);
        return (target: Offset2(depthToX(d, ndir), p.y), maxSpeed: 7);
      case FoulMoment(:final foulerId, :final fouledId)
          when foulerId == id && n.start - end < 8:
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
  double offsideLine(ScriptState now) {
    var first = -1.0;
    var second = -1.0;
    now.players.forEach((id, p) {
      if (now.teams[id] != opp || now.walking.contains(id)) return;
      final d = depthOf(p);
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
    if (d <= PitchDims.length / 2) return true;
    return d <= math.max(offsideLine(now), depthOf(now.ball)) + 1e-6;
  }

  /// [target] pulled back to where [side]'s man stays onside.
  Offset2 keepOnside(ScriptState now, Offset2 target) {
    final d = depthOf(target);
    if (d <= PitchDims.length / 2) return target;
    final limit = math.max(offsideLine(now), depthOf(now.ball)) - 0.6;
    if (d <= limit) return target;
    return at(math.max(limit, PitchDims.length / 2), latOf(target));
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

  /// Whether a ball in the air is about to come down: a cut waits for it.
  bool landing(ScriptState now) {
    final f = now.flight;
    if (f == null) return false;
    if (f.t1 - now.t < 0.45) return true;
    // The last moment's shot (or save, or block) plays out first; a ball
    // merely played between team-mates may be cut.
    final to = f.toId;
    final from = f.fromId;
    final mates =
        to != null && from != null && now.teams[to] == now.teams[from];
    return !mates || now.keepers.contains(to);
  }

  /// Seconds until the ball can be at [id]'s feet, from where it is now.
  double ballTo(ScriptState now, int id) {
    if (now.carrierId == id) return 0;
    final p = now.players[id];
    if (p == null) return double.infinity;
    final f = now.flight;
    final wait = f == null ? 0.0 : math.max(0.0, f.t1 - now.t);
    final from = f == null ? now.ball : f.lead;
    return wait + from.distanceTo(p) / 26 + 0.15;
  }

  /// A cut to a new phase of play, for a moment that cannot be reached
  /// from where play is (the last moment ended at the other end, a minute
  /// of match time ago): the picture cuts, as a broadcast does between two
  /// attacks, to the same two shapes shifted along the pitch together so
  /// that [anchor] stands at [anchorAt] with the ball at his feet. [extra]
  /// places a few named men exactly. The keepers stay in their goals (the
  /// defending one set for the ball); men walking off are left alone.
  CutAction cutToPhase(
    ScriptState now,
    int anchor,
    Offset2 anchorAt, {
    Map<int, Offset2> extra = const {},
  }) {
    sceneCut = true;
    final ap = now.players[anchor]!;
    final shift = depthOf(anchorAt) - depthOf(ap);
    double fit(double d) {
      if (d > 99) return math.min(99 + (d - 99) * 0.2, 103.5);
      if (d < 6) return math.max(6 - (6 - d) * 0.2, 1.5);
      return d;
    }

    final positions = <int, Offset2>{};
    now.players.forEach((id, p) {
      if (now.walking.contains(id) || now.keepers.contains(id)) return;
      positions[id] = at(fit(depthOf(p) + shift), latOf(p));
    });
    positions[anchor] = anchorAt;
    final toGoal = (goal - anchorAt).unit;
    final ball = anchorAt + toGoal * 0.7;
    final k = keeperOf(now, opp);
    if (k != null) {
      final g = goal;
      final off = (ball.distanceTo(g) * 0.12).clamp(1.0, 4.0);
      final spot = g + (ball - g).unit * off;
      positions[k] = at(
        math.min(depthOf(spot), _goalLine - 0.6),
        latOf(spot).clamp(-goalHalfWidth + 0.6, goalHalfWidth - 0.6),
      );
    }
    positions.addAll(extra);
    return CutAction(ballAt: ball, positions: positions);
  }

  void cue(double t, PitchCueKind kind, int playerId) {
    if (w.cues.any((q) => q.kind == kind && q.playerId == playerId)) return;
    w.cues.add((t: t, kind: kind, playerId: playerId));
  }

  /// A light reaction of the men the moment does not name, near the ball:
  /// defenders drop goal-side of it, attackers ease forward, onside.
  PlayerDrive? react(int id, ScriptState now, {Set<int> skip = const {}}) {
    if (skip.contains(id) || now.keepers.contains(id)) return null;
    final p = now.players[id];
    if (p == null || p.distanceTo(now.ball) > 26) return null;
    if (now.teams[id] == opp) {
      // Goal-side: toward the line from the ball to the goal it defends.
      final g = goal;
      final b = now.ball;
      final ab = g - b;
      final l2 = ab.x * ab.x + ab.y * ab.y;
      var u = l2 < 1e-9
          ? 0.0
          : (((p.x - b.x) * ab.x + (p.y - b.y) * ab.y) / l2).clamp(0.15, 1.0);
      if (u.isNaN) u = 0.5;
      final onLine = b + ab * u;
      final target = p + (onLine - p) * 0.35 + (g - p).unit * 1.5;
      return (target: target, maxSpeed: 3.2);
    }
    if (now.teams[id] == side && now.carrierId != id) {
      final target = keepOnside(now, at(depthOf(p) + 3, latOf(p)));
      return (target: target, maxSpeed: 3);
    }
    return null;
  }
}

// ---------------------------------------------------------------------------

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
    final lat = p.latOf(spot).clamp(-goalHalfWidth + 0.6, goalHalfWidth - 0.6);
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
    var v = speed ?? speedFor(header: fromHeight > 1);
    final hard = goal ? p.end : p.c.hardEnd;
    if (hard.isFinite) {
      // In before the picture cuts (to the kick-off, or the interval).
      final d = b.distanceTo(p.goal);
      final left = hard - 0.5 - t;
      if (left > 0.1 && d / v > left) v = math.min(34, d / left);
      if (left <= 0.1) v = 34;
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
        while (peak > 0 && h(peak) > crossbarHeight - 0.35) {
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
          to: to,
          arriveAt: t + b.distanceTo(to) / v,
          peak: peak,
          fromHeight: fromHeight,
          byPlayerId: by,
        );
      case ShotOutcome.saved:
        if (kp != null) {
          final reach =
              (kLat + (r.chance(0.5) ? 1 : -1) * (0.4 + 1.4 * r.nextDouble()))
                  .clamp(-goalHalfWidth + 0.5, goalHalfWidth - 0.5);
          keeperTo = p.at(p.depthOf(kp), reach);
          keeperSpeed = 8.8;
          parry = r.chance(0.4) && p.owedSide(now) == p.side;
          final d = b.distanceTo(kp);
          return KickAction(
            toPlayerId: keeper,
            arriveAt: t + math.max(d / math.min(v, 21), 0.42),
            peak: peakOver(p.depthOf(kp), fromHeight > 1 ? 0.2 : 0.4),
            fromHeight: fromHeight,
            byPlayerId: by,
          );
        }
        // Nobody in goal: it is cleared off the line instead.
        final saver = pickBlocker(now, b);
        keeper = saver;
        return KickAction(
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
            to: to,
            arriveAt: t + b.distanceTo(to) / v,
            peak: peak,
            fromHeight: fromHeight,
            byPlayerId: by,
          );
        }
        final sign = bl.abs() > 2 ? bl.sign : (r.chance(0.5) ? 1.0 : -1.0);
        final lane = sign * (goalHalfWidth + 0.6 + 3 * r.nextDouble());
        final to = beyond(lane, 2.5);
        if (kp != null) {
          keeperTo = p.at(p.depthOf(kp), sign * 1.2);
          keeperSpeed = 4;
        }
        return KickAction(
          to: to,
          arriveAt: t + b.distanceTo(to) / v,
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
          height = crossbarHeight;
        } else {
          lane =
              (bl.abs() > 2 ? bl.sign : (r.chance(0.5) ? 1.0 : -1.0)) *
              goalHalfWidth;
          height = 0.3 + 1.6 * r.nextDouble();
        }
        final to = p.at(_goalLine - 0.12, lane);
        if (kp != null) {
          keeperTo = p.at(p.depthOf(kp), lane * 0.4);
          keeperSpeed = 6;
        }
        return KickAction(
          to: to,
          arriveAt: t + b.distanceTo(to) / v,
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
            toPlayerId: keeper ?? m.shooterId,
            arriveAt: t + 0.5,
            byPlayerId: by,
          );
        }
        final d = b.distanceTo(now.players[bk]!);
        return KickAction(
          toPlayerId: bk,
          arriveAt: t + math.max(d / v, 0.12),
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
        final h = p.depthOf(b) > _goalLine - 0.5 ? crossbarHeight : 0.0;
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
    if (shot.struck) shot.keeper = keeperOf(e, opp, m.keeperId);
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

  @override
  BallAction? ball(double t, ScriptState now) {
    if (shot.struck) return shot.after(t, now);
    cutWanted ??= _needCut(now);
    // A ball still in the air (the last moment's) lands first.
    if (cutWanted! && !sceneCut && landing(now)) return null;
    if (cutWanted! && !sceneCut) {
      final holder = assister ?? m.shooterId;
      final back = assister == null ? 3.0 : 12.0;
      final spot = at(
        math.max(depthOf(zone) - back, PitchDims.length / 2),
        latOf(zone) * (assister == null ? 1 : 0.6),
      );
      final extra = <int, Offset2>{};
      if (m.outcome == ShotOutcome.blocked && assister == null) {
        // The man who blocks it is right on him.
        final lane = spot + (goal - spot).unit * 2.0;
        final defs = available(
          now,
          opp,
        ).where((o) => !now.keepers.contains(o));
        final b = nearest(now, defs, lane);
        if (b != null) {
          extra[b] = lane;
          shot.blocker = b;
        }
      }
      if (assister != null) {
        // The scorer is up with him, onside: one of theirs is deeper.
        final sd = depthOf(zone) - 1;
        extra[m.shooterId] = at(sd, latOf(zone));
      }
      final cut = cutToPhase(now, holder, spot, extra: extra);
      if (assister != null) {
        final sd = depthOf(zone) - 1;
        final k = keeperOf(now, opp);
        int? deepest;
        var dd = -1.0;
        cut.positions.forEach((id, q) {
          if (now.teams[id] != opp || id == k) return;
          if (depthOf(q) > dd) {
            dd = depthOf(q);
            deepest = id;
          }
        });
        if (deepest != null && dd < sd + 0.5) {
          cut.positions[deepest!] = at(sd + 1.5, latOf(zone) + 2.5);
        }
      }
      return cut;
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
    final car = now.carrierId;
    final s = m.shooterId;
    if (car == s &&
        (assister == null || delivered) &&
        (!m.header || delivered)) {
      final sp = now.players[s]!;
      final near = sp.distanceTo(_strikeFrom(now)) < 2.0;
      if (m.header && delivered) {
        return shot.strike(t, now, fromHeight: headerHeight);
      }
      // A shot that is blocked waits (a little) for the man who blocks it
      // to be in its path.
      if (m.outcome == ShotOutcome.blocked) {
        // It goes as soon as a man is in its path: struck into him. Until
        // then the nearest man goal-side is the one closing it down.
        if (_blockerInPath(now)) return shot.strike(t, now);
        shot.blocker = _aheadOf(now) ?? shot.blocker;
        if (t < deadline + 1.2) return null;
        shot.blocker = _aheadOf(now) ?? shot.blocker;
        return shot.strike(t, now);
      }
      if ((t >= earliest && near) || t >= deadline) {
        return shot.strike(t, now);
      }
      return null;
    }
    // A header needs a ball into the air: a cross from a team-mate.
    if (m.header) {
      crosser ??= _pickCrosser(now);
      final x = assister ?? crosser;
      if (x == null || x == s) {
        final a = fetch(s, t, now, cross: true, toHeight: headerHeight);
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
    final x = assister;
    if (x != null && !delivered) {
      if (car == x) {
        final a = fetch(s, t, now, needOnside: true);
        if (a != null) delivered = true;
        return a;
      }
      return fetch(x, t, now, needOnside: true);
    }
    final a = fetch(s, t, now, needOnside: true);
    return a;
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
      if (along > 0.9 && along < 3.0 && across < 0.8 * along) {
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

// ---------------------------------------------------------------------------

/// A penalty: the ball on the mark, the taker's run-up, everybody else out
/// of the area and the arc and behind the ball, the keeper on his line,
/// the kick and the dive.
class _PenaltyPlan extends _Plan {
  _PenaltyPlan(StagingContext c, this.m) : super(c, m.teamNationId) {
    shot = _Shot(this, m);
    spot = at(penaltySpotDepth, 0);
    final goalPlus = m.outcome == ShotOutcome.goal ? 1.0 : 0.0;
    latest = end - 2.2 - goalPlus;
    earliest = math.min(start + 0.5 * len, latest);
    final r = rng;
    final side = r.chance(0.5) ? 1.0 : -1.0;
    switch (m.outcome) {
      case ShotOutcome.goal:
        lane = side * (1.6 + 1.5 * r.nextDouble());
        dive = r.chance(0.55)
            ? -side * (1.5 + r.nextDouble())
            : side * (0.6 + 0.6 * r.nextDouble());
      case ShotOutcome.saved:
        lane = side * (0.6 + 1.6 * r.nextDouble());
        dive = lane;
      case ShotOutcome.wide || ShotOutcome.woodwork || ShotOutcome.blocked:
        lane = side * (goalHalfWidth + 0.5);
        dive = -side * (0.8 + r.nextDouble());
    }
    targets = _outside(c.entry);
    if (resumed) {
      final f = c.entry.flight;
      if ((f != null && f.fromId == m.shooterId && !f.pass) ||
          (c.entry.carrierId == null &&
              f == null &&
              depthOf(c.entry.ball) > _goalLine - 0.5)) {
        shot.struck = true;
      }
    }
  }

  final ShotMoment m;
  late final _Shot shot;
  late final Offset2 spot;
  late final double earliest;
  late final double latest;
  late final double lane;
  late final double dive;
  late final Map<int, Offset2> targets;
  double? kickAt;
  bool? cutWanted;
  bool cutDone = false;

  @override
  bool settled(double t, ScriptState now) => shot.settledNow(now);

  bool _needCut(double t, ScriptState now) {
    if (resumed) return false;
    var need = now.ball.distanceTo(spot) / 20;
    final tp = now.players[m.shooterId];
    if (tp != null) need = math.max(need, tp.distanceTo(spot) / 6.5);
    for (final e in targets.entries) {
      final p = now.players[e.key];
      if (p != null) need = math.max(need, p.distanceTo(e.value) / 6);
    }
    return t + need > latest + (room - len) - 0.8;
  }

  /// Everybody but the taker and the keepers: out of the area and the arc,
  /// behind the ball, a little apart.
  Map<int, Offset2> _outside(ScriptState e) {
    final out = <int, Offset2>{};
    final ids = e.players.keys.toList()..sort();
    final placed = <Offset2>[];
    final order =
        ids
            .where(
              (id) =>
                  id != m.shooterId &&
                  !e.keepers.contains(id) &&
                  !e.walking.contains(id),
            )
            .toList()
          ..sort((a, b) {
            final da = depthOf(e.players[a]!);
            final db = depthOf(e.players[b]!);
            final x = da.compareTo(db);
            return x != 0 ? x : a.compareTo(b);
          });
    bool clear(Offset2 q) {
      final d = depthOf(q);
      final l = latOf(q);
      final inBox =
          d > _boxEdge - 0.8 && l.abs() < PitchDims.boxHalfWidth + 0.8;
      if (inBox || q.distanceTo(spot) < wallDistance + 0.8) return false;
      if (d > penaltySpotDepth - 0.5) return false;
      if (l.abs() > 32.5 || d < 1) return false;
      for (final o in placed) {
        if (o.distanceTo(q) < 1.8) return false;
      }
      return true;
    }

    for (final id in order) {
      final p = e.players[id]!;
      var q = p;
      if (!clear(q)) {
        // The nearest clear point: back to the edge of the area, out of
        // the arc, then step along it until free.
        final l = latOf(p);
        var d = math.min(depthOf(p), _boxEdge - 1.2);
        q = at(d, l);
        if (q.distanceTo(spot) < wallDistance + 1.0) {
          q = spot + (q - spot).unit * (wallDistance + 1.2);
          if ((q - spot).length < 1e-6) q = at(_boxEdge - 1.2, 10);
          d = math.min(depthOf(q), _boxEdge - 1.2);
          q = at(d, latOf(q));
        }
        var k = 0;
        while (!clear(q) && k < 60) {
          final step = 1.9 * ((k ~/ 2) + 1) * (k.isEven ? 1 : -1);
          final cand = at(d - (k ~/ 8) * 1.9, l + step);
          if (clear(cand)) {
            q = cand;
            break;
          }
          k++;
        }
        if (!clear(q)) {
          // Failing that, the nearest clear point of a grid around the area.
          Offset2? best;
          var bestD = double.infinity;
          for (var dd = _boxEdge - 1.2; dd > 50; dd -= 1.9) {
            for (var ll = -32.0; ll <= 32; ll += 1.9) {
              final cand = at(dd, ll);
              final dist = cand.distanceTo(p);
              if (dist < bestD && clear(cand)) {
                bestD = dist;
                best = cand;
              }
            }
          }
          if (best != null) q = best;
        }
      }
      placed.add(q);
      out[id] = q;
    }
    return out;
  }

  bool _ready(ScriptState now) {
    if (now.carrierId != null || now.flight != null) return false;
    if (now.ball.distanceTo(spot) > 1e-6) return false;
    for (final e in targets.entries) {
      final p = now.players[e.key];
      if (p == null || now.walking.contains(e.key)) continue;
      if (p.distanceTo(e.value) > 0.8) return false;
    }
    final k = keeperOf(now, opp, m.keeperId);
    if (k != null) {
      final kp = now.players[k]!;
      if (_goalLine - depthOf(kp) > 1.0) return false;
    }
    return true;
  }

  @override
  BallAction? ball(double t, ScriptState now) {
    if (shot.struck) return shot.after(t, now);
    final taker = m.shooterId;
    // When the area cannot be cleared (or the taker get there) in the time
    // the moment has, the picture cuts to the penalty ready.
    cutWanted ??= _needCut(t, now);
    if (cutWanted! && !cutDone) {
      if (now.flight != null) return null;
      cutDone = true;
      final positions = <int, Offset2>{
        ...targets,
        taker: at(penaltySpotDepth - 2.8, -lane.sign * 1.4),
      };
      final k = keeperOf(now, opp, m.keeperId);
      if (k != null) positions[k] = at(_goalLine - 0.5, 0);
      return CutAction(ballAt: spot, positions: positions);
    }
    // Still not ready when it has to go: the picture cuts to it ready.
    if (!cutDone &&
        t >= latest &&
        settledIn(t) &&
        now.flight == null &&
        kickAt == null) {
      final tp = now.players[taker];
      final set =
          now.carrierId == null &&
          now.ball.distanceTo(spot) < 1e-6 &&
          tp != null &&
          _ready(now);
      if (!set) {
        cutDone = true;
        final positions = <int, Offset2>{
          ...targets,
          taker: at(penaltySpotDepth - 2.8, -lane.sign * 1.4),
        };
        final k = keeperOf(now, opp, m.keeperId);
        if (k != null) positions[k] = at(_goalLine - 0.5, 0);
        kickAt = t + 0.9;
        return CutAction(ballAt: spot, positions: positions);
      }
    }
    // The ball onto the mark.
    if (now.ball.distanceTo(spot) > 1e-6 || now.carrierId != null) {
      return place(t, now, spot, speed: 10);
    }
    final tp = now.players[taker];
    if (tp == null) return null;
    final atBall = tp.distanceTo(spot) < 1.2;
    kickAt ??= (_ready(now) && t >= earliest) || t >= latest ? t + 0.75 : null;
    if (kickAt != null && t >= kickAt! && atBall) {
      return shot.strike(
        t,
        now,
        by: taker,
        speed: m.outcome == ShotOutcome.saved ? 18 : 23,
      );
    }
    if (kickAt != null && t >= kickAt! + 1.0) {
      return shot.strike(t, now, by: taker);
    }
    return null;
  }

  @override
  PlayerDrive? steer(int id, double t, ScriptState now) {
    final celebrate = shot.celebrate(id, now);
    if (celebrate != null) return celebrate;
    final k = keeperOf(now, opp, m.keeperId);
    if (id == k) {
      if (shot.struck || (kickAt != null && t >= kickAt! - 0.12)) {
        if (shot.afterDone || now.carrierId == id) return null;
        return (target: at(_goalLine - 0.5, dive), maxSpeed: 8.8);
      }
      return (target: at(_goalLine - 0.5, 0), maxSpeed: 4);
    }
    if (id == m.shooterId) {
      if (shot.struck) return (target: now.players[id]!, maxSpeed: 2);
      final runUp = at(penaltySpotDepth - 2.8, -lane.sign * 1.4);
      if (kickAt != null && t >= kickAt! - 0.7) {
        return (
          target: at(penaltySpotDepth - 0.75, -lane.sign * 0.2),
          maxSpeed: 5,
        );
      }
      return (target: runUp, maxSpeed: 5);
    }
    final tgt = targets[id];
    if (tgt != null && !shot.struck) return (target: tgt, maxSpeed: 6.5);
    return null;
  }
}

// ---------------------------------------------------------------------------

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
    // Nobody of theirs nearer the ball than 9.15 m.
    for (final id in available(now, opp)) {
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
        available(now, opp).where((o) => !now.keepers.contains(o)),
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
      cutWanted ??= needCut(t, now);
      if (cutWanted! && !cutDone) {
        if (now.flight != null) return null;
        // The ball goes out first when there is time to see it; then the
        // picture cuts to the corner ready.
        if (!wentOut &&
            len >= 5 &&
            now.ball.distanceTo(ballSpot) > 8 &&
            now.ball.distanceTo(out) < 35) {
          wentOut = true;
          return place(t, now, out, speed: 20);
        }
        return cutTo(t, now, keeperAt: keeperSpot);
      }
      // Still not set when it has to go: the picture cuts to it set.
      final tc = now.players[taker];
      if (!cutDone &&
          t >= latest - 0.9 &&
          settledIn(t) &&
          now.flight == null &&
          !(ballSet(now) && tc != null && tc.distanceTo(ballSpot) <= 1.3)) {
        return cutTo(t, now, keeperAt: keeperSpot);
      }
      if (!ballSet(now)) {
        if (now.flight != null) return null;
        // Out over the goal line first, when there is time, then onto the
        // arc.
        if (!wentOut && len >= 4 && now.ball.distanceTo(ballSpot) > 8) {
          wentOut = true;
          return place(t, now, out, speed: 16);
        }
        wentOut = true;
        return place(t, now, ballSpot, speed: 12);
      }
      final tp = now.players[taker];
      if (tp == null || tp.distanceTo(ballSpot) > 1.3) return null;
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
      if (car != null && car == first && !secondDone) {
        secondDone = true;
        return fetch(s.shooterId, t, now, cross: true, toHeight: _metHeight(s));
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
  bool _clear(ScriptState now) {
    for (final id in available(now, opp)) {
      if (now.keepers.contains(id)) continue;
      if (now.players[id]!.distanceTo(ballSpot) < wallDistance - 0.25) {
        return false;
      }
    }
    return true;
  }

  bool _wallSet(ScriptState now) {
    for (final id in wall) {
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
      if (cutWanted! && !cutDone) {
        if (now.flight != null) return null;
        return cutTo(t, now, keeperAt: keeperSpot);
      }
      final tk = now.players[taker];
      final takerNear = tk != null && tk.distanceTo(ballSpot) < 2.6;
      if (now.flight == null &&
          settledIn(t) &&
          ((!cutDone &&
                  t >= latest - 0.9 &&
                  !(ballSet(now) &&
                      _wallSet(now) &&
                      _clear(now) &&
                      takerNear)) ||
              (t >= latest + 0.6 && !secondCut))) {
        if (t >= latest + 0.6) secondCut = true;
        // Still not ready when it has to go: the picture cuts to it ready,
        // the taker over the ball.
        final cut = cutTo(t, now, keeperAt: keeperSpot);
        cut.positions[taker] = _clamp(ballSpot - toGoal * 0.75);
        return cut;
      }
      if (!ballSet(now)) {
        if (now.flight != null) return null;
        return place(t, now, ballSpot, speed: 10);
      }
      final tp = now.players[taker];
      if (tp == null || tp.distanceTo(ballSpot) > 1.2) return null;
      final set = _wallSet(now) && _clear(now);
      if (t < latest + 0.8 && (t < earliest || !set)) return null;
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
      if (car != null && car == first && !secondDone) {
        secondDone = true;
        return fetch(
          s.shooterId,
          t,
          now,
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
      if (now.flight != null) return null;
      cutWanted ??= car != taker && needCut(t, now);
      if (cutWanted! && !cutDone) {
        wentOut = true;
        return cutTo(t, now);
      }
      if (!cutDone && t >= latest - 0.9 && settledIn(t) && car != taker) {
        wentOut = true;
        return cutTo(t, now);
      }
      if (car == taker) {
        if (!wentOut) wentOut = true;
        final tp = now.players[taker]!;
        if (tp.distanceTo(takerSpot) > 1.0) return null;
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
      if (car != null && car == first && !secondDone) {
        secondDone = true;
        return fetch(
          s.shooterId,
          t,
          now,
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

// ---------------------------------------------------------------------------

/// A foul worth a card: the fouled man on the ball, the fouler closing in
/// and bringing him down, play stopped, the card. The ball is left on the
/// spot when its free kick is staged next; otherwise the fouled side takes
/// it quickly.
class _FoulPlan extends _Plan {
  _FoulPlan(StagingContext c, this.m) : super(c, m.teamNationId) {
    final idx = m.cardEventIndex;
    if (idx != null && idx >= 0 && idx < c.events.length) {
      red = c.events[idx].type == MatchEventType.redCard;
    }
    final n = c.next;
    final nm = n == null || n.moments.isEmpty ? null : n.moments.first;
    leaveBall =
        n != null &&
        n.start <= end + 0.05 &&
        nm != null &&
        nm.teamNationId == side &&
        ((nm is SetPieceMoment && !nm.routine) ||
            (nm is ShotMoment && nm.origin == ShotOrigin.penalty));
    spot = foulSpot(m.zone, dir, _spotKey(m.minute, m.stoppage, side));
    foulBy = start + (0.3 * len).clamp(0.2, 1.0);
    foulLatest = math.max(foulBy, start + room - math.max(0.9, 0.3 * len));
    if (resumed) {
      final e = c.entry;
      if (e.carrierId == null || e.carrierId != m.fouledId) fouled = true;
    }
  }

  final FoulMoment m;
  bool red = false;
  late final bool leaveBall;
  late final Offset2 spot;
  late final double foulBy;
  late final double foulLatest;
  bool fouled = false;
  double foulAt = 0;
  double? gotAt;
  bool restarted = false;

  bool? cutWanted;

  @override
  BallAction? ball(double t, ScriptState now) {
    final car = now.carrierId;
    if (!fouled) {
      cutWanted ??= !resumed && _needCut(now);
      if (cutWanted! && !sceneCut && landing(now)) return null;
      if (cutWanted! && !sceneCut) {
        return cutToPhase(
          now,
          m.fouledId,
          spot,
          extra: {m.foulerId: spot + (goal - spot).unit * 1.6},
        );
      }
      if (car != m.fouledId) {
        // The ball to the man who is fouled; if it cannot reach him in
        // time, the foul is on him as it arrives.
        final a = fetch(m.fouledId, t, now);
        if (a != null) return a;
        if (now.flight == null && car == null && t >= foulLatest) {
          fouled = true;
          foulAt = t;
          cue(t, PitchCueKind.foul, m.foulerId);
          _card(t);
        }
        return null;
      }
      final fp = now.players[m.fouledId]!;
      final xp = now.players[m.foulerId];
      final close = xp != null && xp.distanceTo(fp) < 1.4;
      gotAt ??= t;
      final settledOnIt = t >= gotAt! + 0.3;
      if ((close && settledOnIt && t >= foulBy) ||
          (t >= foulLatest && (settledOnIt || t >= foulLatest + 0.4))) {
        fouled = true;
        foulAt = t;
        cue(t, PitchCueKind.foul, m.foulerId);
        _card(t);
        // The ball runs loose a yard or two.
        final ahead = now.ball + (now.ball - fp).unit * 1.4;
        final rest = leaveBall
            ? ahead
            : Offset2(
                ahead.x.clamp(1.0, PitchDims.length - 1),
                ahead.y.clamp(1.0, PitchDims.width - 1),
              );
        return KickAction(to: rest, arriveAt: t + 0.35, peak: 0);
      }
      return null;
    }
    if (now.flight != null) return null;
    if (leaveBall) {
      // Set down where the free kick is taken from.
      if (car == null && t >= foulAt + 0.4) {
        final target = _setSpot(now);
        if (now.ball.distanceTo(target) > 1e-6) {
          return place(t, now, target, speed: 6);
        }
      }
      return null;
    }
    if (restarted || car != null || t < end - 0.55) return null;
    // A quick free kick: the nearest of the fouled side takes the ball.
    restarted = true;
    final mates = available(now, side, except: {m.foulerId})
        .where((id) => !now.keepers.contains(id) || depthOf(now.ball) < 20)
        .toList();
    final to = nearest(now, mates, now.ball);
    if (to == null) return null;
    final d = now.players[to]!.distanceTo(now.ball);
    return KickAction(toPlayerId: to, arriveAt: t + math.max(d / 12, 0.2));
  }

  @override
  bool settled(double t, ScriptState now) =>
      fouled &&
      now.flight == null &&
      (leaveBall || now.carrierId != null || restarted);

  /// Whether the two men and the ball cannot meet in the time it has.
  bool _needCut(ScriptState now) {
    final fp = now.players[m.fouledId];
    final xp = now.players[m.foulerId];
    if (fp == null || xp == null) return false;
    // Where it happens matters too: the free kick is taken from there.
    final need =
        ballTo(now, m.fouledId) +
        xp.distanceTo(fp) / 9 +
        math.max(0.0, fp.distanceTo(spot) - 12) / 6 +
        0.3;
    return need > foulLatest - start;
  }

  /// The card, shown a beat after the whistle.
  void _card(double t) => cue(
    math.max(t, math.min(t + 0.6, end - 0.15)),
    red ? PitchCueKind.redCard : PitchCueKind.yellowCard,
    m.foulerId,
  );

  /// Where the next moment takes the ball from.
  Offset2 _setSpot(ScriptState now) {
    final n = c.next!.moments.first;
    if (n is SetPieceMoment) {
      final spot = deadBallSpot(n, dir);
      return now.ball.distanceTo(spot) < 6 ? now.ball : spot;
    }
    return at(penaltySpotDepth, 0);
  }

  @override
  PlayerDrive? steer(int id, double t, ScriptState now) {
    final car = now.carrierId;
    if (id == m.fouledId) {
      if (fouled) return (target: now.players[id]!, maxSpeed: 0);
      if (car == id) {
        // He takes his man on.
        final xp = now.players[m.foulerId];
        final fp = now.players[id]!;
        if (xp == null || xp.distanceTo(fp) < 3) {
          return (target: fp, maxSpeed: 1);
        }
        return (target: Offset2.lerp(fp, xp, 0.5), maxSpeed: 5);
      }
      if (now.flight?.toId == id) return null;
      return (target: now.players[id]!, maxSpeed: 0);
    }
    if (id == m.foulerId) {
      final fp = now.players[m.fouledId];
      final xp = now.players[id];
      if (fp == null || xp == null) return null;
      if (fouled) {
        // Back off a step for the card.
        final away = (xp - fp).unit;
        return (target: fp + away * 2.2, maxSpeed: 1.5);
      }
      return (target: fp + (xp - fp).unit * 1.0, maxSpeed: 7.5);
    }
    if (fouled) {
      // The free kick's taker comes for the ball; the opposition give it
      // room.
      if (now.teams[id] == opp) {
        final p = now.players[id]!;
        if (p.distanceTo(now.ball) < wallDistance + 0.5 && leaveBall) {
          return (
            target: now.ball + (p - now.ball).unit * (wallDistance + 1),
            maxSpeed: 4,
          );
        }
      }
      return null;
    }
    return react(id, now, skip: {m.fouledId, m.foulerId});
  }
}

/// An offside: the ball played through to the man beyond the second-last
/// defender, the flag, and the defending side's free kick from where he
/// was.
class _OffsidePlan extends _Plan {
  _OffsidePlan(StagingContext c, this.m) : super(c, m.teamNationId) {
    if (resumed) {
      final f = c.entry.flight;
      if (f != null && f.toId == m.playerId) played = true;
      if (c.entry.carrierId == m.playerId) played = true;
    }
  }

  @override
  bool settled(double t, ScriptState now) {
    final car = now.carrierId;
    return played && car != null && now.teams[car] == opp;
  }

  final OffsideMoment m;
  int? cutPasser;
  bool played = false;
  bool flagged = false;
  Offset2? offence;
  int? taker;

  bool? cutWanted;

  /// The team-mate who plays the ball through: whoever has it, else the
  /// nearest man behind the one to be flagged.
  int? _passer(ScriptState now) {
    final car = now.carrierId;
    if (car != null && car != m.playerId && now.teams[car] == side) return car;
    final pp = now.players[m.playerId]!;
    final mates = available(now, side, except: {m.playerId})
        .where(
          (id) =>
              !now.keepers.contains(id) &&
              depthOf(now.players[id]!) < depthOf(pp) - 4,
        )
        .toList();
    return nearest(now, mates, pp);
  }

  bool _needCut(ScriptState now) {
    final pp = now.players[m.playerId];
    final passer = _passer(now);
    if (pp == null || passer == null) return pp != null;
    final pd = depthOf(pp);
    final line = math.max(offsideLine(now), depthOf(now.ball));
    var need = ballTo(now, passer);
    final want = math.max(line + 2.8, 55.0);
    if (pd <= math.max(line + 0.3, 52.8)) need += (want - pd).abs() / 6;
    need += now.players[passer]!.distanceTo(pp) / 20 + 0.6;
    return need > room - 0.3;
  }

  @override
  BallAction? ball(double t, ScriptState now) {
    final car = now.carrierId;
    final pid = m.playerId;
    if (!played && !resumed) {
      cutWanted ??= _needCut(now);
      if (cutWanted! && !sceneCut && landing(now)) return null;
      if (cutWanted! && !sceneCut) {
        final pp = now.players[pid]!;
        final passer =
            _passer(now) ??
            nearest(
              now,
              available(now, side, except: {pid}),
              pp,
            );
        if (passer != null) {
          final lat = latOf(pp).clamp(-16.0, 16.0);
          cutPasser = passer;
          final cut = cutToPhase(
            now,
            passer,
            at(73, latOf(now.players[passer]!).clamp(-16.0, 16.0)),
            extra: {pid: at(84, lat)},
          );
          // Their back line stepped up behind him; their keeper deeper.
          final k = keeperOf(now, opp);
          cut.positions.forEach((id, q) {
            if (now.teams[id] != opp || id == k) return;
            if (depthOf(q) > 81.4) cut.positions[id] = at(81.4, latOf(q));
          });
          return cut;
        }
      }
    }
    if (!played) {
      if (car == pid) {
        // He has it already: it is laid back to a team-mate first.
        final mates = available(
          now,
          side,
          except: {pid},
        ).where((id) => onside(now, id) && !now.keepers.contains(id)).toList();
        final to = nearest(now, mates, now.players[pid]!);
        if (to == null) return null;
        return fetch(to, t, now);
      }
      final cp = cutPasser;
      if (car == null &&
          cp != null &&
          now.players[cp] != null &&
          now.players[cp]!.distanceTo(now.ball) < 1.5) {
        // Played through straight from where the cut left it.
        final pp = now.players[pid]!;
        final d = now.ball.distanceTo(pp);
        played = true;
        offence = pp;
        flagged = true;
        final arrive = t + math.max(d / 24, 0.25);
        cue(arrive, PitchCueKind.offsideFlag, pid);
        return KickAction(
          toPlayerId: pid,
          byPlayerId: cp,
          arriveAt: arrive,
          pass: d >= 9,
        );
      }
      if (car == null || now.teams[car] != side) {
        final mates = available(
          now,
          side,
          except: {pid},
        ).where((id) => onside(now, id)).toList();
        final to = nearest(now, mates, now.ball);
        return to == null ? null : fetch(to, t, now);
      }
      final pp = now.players[pid];
      if (pp == null) return null;
      final beyond =
          depthOf(pp) > PitchDims.length / 2 &&
          depthOf(pp) > math.max(offsideLine(now), depthOf(now.ball)) + 0.3;
      if (!beyond && t < end - 0.6) return null;
      if (!beyond) return null;
      played = true;
      offence = pp;
      final d = now.ball.distanceTo(pp);
      final v = (14 + 0.4 * d).clamp(14.0, 26.0);
      // The flag goes up as it reaches him.
      flagged = true;
      cue(t + math.max(d / v, 0.25), PitchCueKind.offsideFlag, pid);
      return KickAction(
        toPlayerId: pid,
        arriveAt: t + math.max(d / v, 0.25),
        peak: d > 22 ? 2.5 : 0,
        pass: d >= 9,
      );
    }
    if (now.flight != null) return null;
    if (!flagged) {
      flagged = true;
      cue(t, PitchCueKind.offsideFlag, pid);
    }
    if (car == null || now.teams[car] == opp) return null;
    // The defending side takes the free kick where he was.
    final o = offence ?? now.players[pid]!;
    taker ??= nearest(
      now,
      available(
        now,
        opp,
      ).where((id) => !now.keepers.contains(id) || depthOf(o) > 88),
      o,
    );
    final tk = taker;
    if (tk == null) return null;
    if (t < end - 0.5 && now.players[tk]!.distanceTo(o) > 3) return null;
    final d = now.players[tk]!.distanceTo(now.ball);
    return KickAction(toPlayerId: tk, arriveAt: t + math.max(d / 12, 0.2));
  }

  @override
  PlayerDrive? steer(int id, double t, ScriptState now) {
    final pid = m.playerId;
    if (id == pid) {
      if (played) {
        if (now.flight?.toId == id) return null;
        return (target: now.players[id]!, maxSpeed: 0);
      }
      final line = math.max(offsideLine(now), depthOf(now.ball));
      final p = now.players[id]!;
      return (
        target: at((line + 2.5).clamp(55.0, 101.0), latOf(p)),
        maxSpeed: 7.5,
      );
    }
    if (played && id == taker) {
      final o = offence ?? now.players[pid]!;
      final p = now.players[pid]!;
      return (target: o + (now.players[id]! - p).unit * 1.5, maxSpeed: 6);
    }
    if (played) return null;
    // The defenders step up past him: the trap.
    if (now.teams[id] == opp) {
      final pp = now.players[pid];
      final q = now.players[id];
      if (pp == null || q == null || now.keepers.contains(id)) return null;
      final pd = depthOf(pp);
      if (depthOf(q) > pd - 1.5 && pd > PitchDims.length / 2 + 2) {
        return (target: at(pd - 3, latOf(q)), maxSpeed: 6);
      }
      return null;
    }
    return react(id, now, skip: {pid});
  }
}

/// A substitution: play stopped, the man going off on his way to the line.
class _SubPlan extends _Plan {
  _SubPlan(StagingContext c, this.m) : super(c, m.teamNationId);

  final SubMoment m;
  bool handed = false;

  @override
  BallAction? ball(double t, ScriptState now) {
    final off = m.offId;
    if (handed || off == null || now.carrierId != off) return null;
    // The man going off gives the ball up first.
    handed = true;
    final mates = available(now, side, except: {off});
    final to = nearest(now, mates, now.ball);
    return to == null ? null : fetch(to, t, now);
  }

  @override
  PlayerDrive? steer(int id, double t, ScriptState now) {
    if (id != m.offId) return null;
    final p = now.players[id];
    if (p == null) return null;
    final edges = [
      (p.y, Offset2(p.x, 0.5)),
      (PitchDims.width - p.y, Offset2(p.x, PitchDims.width - 0.5)),
      (p.x, Offset2(0.5, p.y)),
      (PitchDims.length - p.x, Offset2(PitchDims.length - 0.5, p.y)),
    ]..sort((a, b) => a.$1.compareTo(b.$1));
    return (target: edges.first.$2, maxSpeed: 1.8);
  }
}

/// An injury: the man hurt goes down and play stops; the ball is given up
/// if he had it.
class _InjuryPlan extends _Plan {
  _InjuryPlan(StagingContext c, this.injured)
    : super(c, c.entry.teams[injured] ?? c.lineups.home.nationId);

  final int? injured;
  bool handed = false;

  @override
  BallAction? ball(double t, ScriptState now) {
    final id = injured;
    if (handed || id == null || now.carrierId != id || t < start + 0.8) {
      return null;
    }
    handed = true;
    final mates = available(now, side, except: {id});
    final to = nearest(now, mates, now.ball);
    return to == null ? null : fetch(to, t, now);
  }

  @override
  PlayerDrive? steer(int id, double t, ScriptState now) {
    if (id == injured) return (target: now.players[id]!, maxSpeed: 0);
    return null;
  }
}
