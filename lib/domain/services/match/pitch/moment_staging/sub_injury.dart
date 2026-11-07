part of '../moment_staging.dart';

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
