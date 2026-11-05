/// The richer record of a match the Pitch view stages: every real moment the
/// engine decides, in the order it decides them.
///
/// Moments are recorded alongside [MatchEvent]s and never change them. The
/// Timeline and the other views keep reading the events; only the Pitch view
/// draws the moments. Each moment carries enough to stage it without
/// inventing an outcome: who, where (a coarse [PitchZone]) and what happened.
library;

import 'package:fnm/domain/services/match/match_engine.dart'
    show MatchEvent, MatchResult;
import 'package:meta/meta.dart' show immutable;

/// A coarse area of the attacking third (from the shooting side's view), for
/// placing a moment on the pitch. Left and right are as the attacking side
/// faces the goal.
enum PitchZone {
  boxCentre,
  boxLeft,
  boxRight,
  sixYard,
  edgeOfBox,
  longRange,
  wideLeft,
  wideRight,
}

/// How a shot ended.
enum ShotOutcome { goal, saved, wide, blocked, woodwork }

/// Where a shot came from.
enum ShotOrigin {
  openPlay,
  corner,
  freeKickCross,
  directFreeKick,
  penalty,
  longThrow,
}

/// One real moment of a match. Ordered in [MatchResult.moments] by
/// ([minute], [stoppage], [seq]).
@immutable
sealed class MatchMoment {
  const MatchMoment();

  /// The match minute: 1-90, 90 for second-half added time (with
  /// [stoppage] > 0), and 91-120 in extra time.
  int get minute;

  /// The "+X" of second-half added time, 0 otherwise.
  int get stoppage;

  /// The order within ([minute], [stoppage]), 0-based, as the engine
  /// produced the moments.
  int get seq;

  /// The side the moment belongs to (for a shot, the shooting side).
  int get teamNationId;
}

/// A shot: every attempt the engine counts in its shot totals, goal or not.
final class ShotMoment extends MatchMoment {
  const ShotMoment({
    required this.minute,
    required this.stoppage,
    required this.seq,
    required this.teamNationId,
    required this.shooterId,
    required this.zone,
    required this.xg,
    required this.outcome,
    required this.origin,
    this.assistId,
    this.keeperId,
    this.header = false,
    this.goalEventIndex,
  });

  @override
  final int minute;
  @override
  final int stoppage;
  @override
  final int seq;
  @override
  final int teamNationId;

  final int shooterId;

  /// For a goal, the goal event's assist; for a set piece or long throw that
  /// came to nothing, the player who delivered it. Null otherwise.
  final int? assistId;

  /// The defending side's goalkeeper on the pitch, or null when they have
  /// none (a keeper sent off with no replacement).
  final int? keeperId;

  final PitchZone zone;

  /// The chance's quality, exactly what the engine added to the side's xG.
  final double xg;
  final ShotOutcome outcome;
  final bool header;
  final ShotOrigin origin;

  /// The index into [MatchResult.events] of the goal this shot scored, when
  /// [outcome] is [ShotOutcome.goal]; null otherwise.
  final int? goalEventIndex;

  /// This shot with its goal's index into [MatchResult.events].
  ShotMoment withGoalEventIndex(int index) => ShotMoment(
    minute: minute,
    stoppage: stoppage,
    seq: seq,
    teamNationId: teamNationId,
    shooterId: shooterId,
    assistId: assistId,
    keeperId: keeperId,
    zone: zone,
    xg: xg,
    outcome: outcome,
    header: header,
    origin: origin,
    goalEventIndex: index,
  );

  @override
  bool operator ==(Object other) =>
      other is ShotMoment &&
      other.minute == minute &&
      other.stoppage == stoppage &&
      other.seq == seq &&
      other.teamNationId == teamNationId &&
      other.shooterId == shooterId &&
      other.assistId == assistId &&
      other.keeperId == keeperId &&
      other.zone == zone &&
      other.xg == xg &&
      other.outcome == outcome &&
      other.header == header &&
      other.origin == origin &&
      other.goalEventIndex == goalEventIndex;

  @override
  int get hashCode => Object.hash(
    minute,
    stoppage,
    seq,
    teamNationId,
    shooterId,
    assistId,
    keeperId,
    zone,
    xg,
    outcome,
    header,
    origin,
    goalEventIndex,
  );

  @override
  String toString() =>
      'ShotMoment($minute+$stoppage #$seq, team $teamNationId, '
      'shooter $shooterId, ${origin.name}, ${zone.name}, '
      'xg ${xg.toStringAsFixed(3)}, ${outcome.name})';
}
