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

part 'moment_staging/plan.dart';
part 'moment_staging/shot.dart';
part 'moment_staging/penalty.dart';
part 'moment_staging/dead_ball.dart';
part 'moment_staging/foul_offside.dart';
part 'moment_staging/sub_injury.dart';

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
