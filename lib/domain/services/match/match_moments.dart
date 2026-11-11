/// The richer record of a match the Pitch view stages: every real moment the
/// engine decides, in the order it decides them.
///
/// Moments are recorded alongside the match events and never change them. The
/// Timeline and the other views keep reading the events; only the Pitch view
/// draws the moments. Each moment carries enough to stage it without
/// inventing an outcome: who, where (a coarse [PitchZone]) and what happened.
library;

import 'package:meta/meta.dart' show immutable;

/// A coarse area of the pitch, from the view of the side the moment belongs
/// to (the shooting side, the side fouled, the side taking a set piece), for
/// placing a moment on the pitch. Every value but [midfield] is in that
/// side's attacking third; [midfield] is everywhere short of it. Left and
/// right are as that side faces the goal it attacks.
enum PitchZone {
  boxCentre,
  boxLeft,
  boxRight,
  sixYard,
  edgeOfBox,
  longRange,
  wideLeft,
  wideRight,

  /// Outside the attacking third altogether: the middle of the pitch or
  /// deeper. Only fouls (and the free kicks they give) are placed here.
  midfield,
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

/// One real moment of a match. Ordered in `MatchResult.moments` by
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
  ///
  /// For a penalty or a direct free kick it is the kick's own chance of
  /// going in, given the taker and the keeper.
  final double xg;
  final ShotOutcome outcome;
  final bool header;
  final ShotOrigin origin;

  /// The index into `MatchResult.events` of the goal this shot scored, when
  /// [outcome] is [ShotOutcome.goal]; null otherwise. An own goal's event
  /// names the defender who turned it in ([MatchEvent.ownGoal]); the shot is
  /// still the attacker's.
  final int? goalEventIndex;

  /// The chance a save has to have been to count as a big one.
  static const double bigSaveXg = 0.15;

  /// Whether the keeper kept out a good chance: a key moment on the Pitch
  /// view, a line of its own in the commentary and a row on the Timeline.
  bool get isBigSave => outcome == ShotOutcome.saved && xg >= bigSaveXg;

  /// This shot with its goal's index into `MatchResult.events`.
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

/// The kind of dead ball a [SetPieceMoment] restarts play with.
enum SetPieceKind { corner, freeKick, longThrow, throwIn, goalKick }

/// A dead ball: a corner, a free kick or a long throw into the box.
///
/// One that leads to a shot sits right before its [ShotMoment]; one that
/// comes to nothing (cleared, overhit, played short and lost) stands alone.
final class SetPieceMoment extends MatchMoment {
  const SetPieceMoment({
    required this.minute,
    required this.stoppage,
    required this.seq,
    required this.teamNationId,
    required this.kind,
    required this.takerId,
    required this.left,
    required this.zone,
    this.routine = false,
  });

  @override
  final int minute;
  @override
  final int stoppage;
  @override
  final int seq;

  /// The side taking it.
  @override
  final int teamNationId;

  final SetPieceKind kind;
  final int takerId;

  /// Whether it is taken from the left, as the taking side faces the goal.
  final bool left;

  /// Where it is taken from, from the taking side's view.
  final PitchZone zone;

  /// A flow-only restart: play goes on with no staging stop and no
  /// commentary line. Every free kick short of the attacking third's
  /// dangerous places is one: those in midfield or deeper, and the long-range
  /// ones in the attacking half ([PitchZone.longRange]), played short.
  final bool routine;

  @override
  bool operator ==(Object other) =>
      other is SetPieceMoment &&
      other.minute == minute &&
      other.stoppage == stoppage &&
      other.seq == seq &&
      other.teamNationId == teamNationId &&
      other.kind == kind &&
      other.takerId == takerId &&
      other.left == left &&
      other.zone == zone &&
      other.routine == routine;

  @override
  int get hashCode => Object.hash(
    minute,
    stoppage,
    seq,
    teamNationId,
    kind,
    takerId,
    left,
    zone,
    routine,
  );

  @override
  String toString() =>
      'SetPieceMoment($minute+$stoppage #$seq, team $teamNationId, '
      '${kind.name}, taker $takerId, ${left ? 'left' : 'right'}, '
      '${zone.name}${routine ? ', routine' : ''})';
}

/// A foul. [teamNationId] is the side FOULED (the one given the free kick),
/// and [zone] is from that side's view, like a shot's.
final class FoulMoment extends MatchMoment {
  const FoulMoment({
    required this.minute,
    required this.stoppage,
    required this.seq,
    required this.teamNationId,
    required this.foulerId,
    required this.fouledId,
    required this.zone,
    this.cardEventIndex,
    this.advantage = false,
  });

  @override
  final int minute;
  @override
  final int stoppage;
  @override
  final int seq;

  /// The side fouled.
  @override
  final int teamNationId;

  final int foulerId;
  final int fouledId;
  final PitchZone zone;

  /// The index into `MatchResult.events` of the card this foul drew, or null
  /// when it drew none.
  final int? cardEventIndex;

  /// Whether the referee played advantage: no free kick follows.
  final bool advantage;

  /// This foul with its card's index into `MatchResult.events`.
  FoulMoment withCardEventIndex(int index) => FoulMoment(
    minute: minute,
    stoppage: stoppage,
    seq: seq,
    teamNationId: teamNationId,
    foulerId: foulerId,
    fouledId: fouledId,
    zone: zone,
    cardEventIndex: index,
    advantage: advantage,
  );

  @override
  bool operator ==(Object other) =>
      other is FoulMoment &&
      other.minute == minute &&
      other.stoppage == stoppage &&
      other.seq == seq &&
      other.teamNationId == teamNationId &&
      other.foulerId == foulerId &&
      other.fouledId == fouledId &&
      other.zone == zone &&
      other.cardEventIndex == cardEventIndex &&
      other.advantage == advantage;

  @override
  int get hashCode => Object.hash(
    minute,
    stoppage,
    seq,
    teamNationId,
    foulerId,
    fouledId,
    zone,
    cardEventIndex,
    advantage,
  );

  @override
  String toString() =>
      'FoulMoment($minute+$stoppage #$seq, team $teamNationId, '
      '$foulerId on $fouledId, ${zone.name}'
      '${cardEventIndex == null ? '' : ', card #$cardEventIndex'}'
      '${advantage ? ', advantage' : ''})';
}

/// A player caught offside. [teamNationId] is his side.
final class OffsideMoment extends MatchMoment {
  const OffsideMoment({
    required this.minute,
    required this.stoppage,
    required this.seq,
    required this.teamNationId,
    required this.playerId,
    this.endsAttack = true,
  });

  @override
  final int minute;
  @override
  final int stoppage;
  @override
  final int seq;
  @override
  final int teamNationId;

  final int playerId;

  /// Whether the flag killed a real attack (staged in full) rather than a
  /// hopeful ball nobody was going to reach (flows on).
  final bool endsAttack;

  @override
  bool operator ==(Object other) =>
      other is OffsideMoment &&
      other.minute == minute &&
      other.stoppage == stoppage &&
      other.seq == seq &&
      other.teamNationId == teamNationId &&
      other.playerId == playerId &&
      other.endsAttack == endsAttack;

  @override
  int get hashCode =>
      Object.hash(minute, stoppage, seq, teamNationId, playerId, endsAttack);

  @override
  String toString() =>
      'OffsideMoment($minute+$stoppage #$seq, team $teamNationId, '
      'player $playerId${endsAttack ? ', ends attack' : ''})';
}

/// A substitution: the same change as the substitution event at
/// [eventIndex] in `MatchResult.events`.
final class SubMoment extends MatchMoment {
  const SubMoment({
    required this.minute,
    required this.stoppage,
    required this.seq,
    required this.teamNationId,
    required this.onId,
    required this.offId,
    required this.eventIndex,
  });

  @override
  final int minute;
  @override
  final int stoppage;
  @override
  final int seq;
  @override
  final int teamNationId;

  final int onId;

  /// The player going off, or null when the newcomer fills a place already
  /// empty (a man who left injured).
  final int? offId;

  final int eventIndex;

  /// This sub with its event's index into `MatchResult.events`.
  SubMoment withEventIndex(int index) => SubMoment(
    minute: minute,
    stoppage: stoppage,
    seq: seq,
    teamNationId: teamNationId,
    onId: onId,
    offId: offId,
    eventIndex: index,
  );

  @override
  bool operator ==(Object other) =>
      other is SubMoment &&
      other.minute == minute &&
      other.stoppage == stoppage &&
      other.seq == seq &&
      other.teamNationId == teamNationId &&
      other.onId == onId &&
      other.offId == offId &&
      other.eventIndex == eventIndex;

  @override
  int get hashCode =>
      Object.hash(minute, stoppage, seq, teamNationId, onId, offId, eventIndex);

  @override
  String toString() =>
      'SubMoment($minute+$stoppage #$seq, team $teamNationId, '
      '$onId for $offId, event #$eventIndex)';
}
