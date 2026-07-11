/// A player's disciplinary and fitness standing within a save.
///
/// [yellows] accumulate toward a suspension across the cycle; [banMatches] and
/// [injuryMatches] count the national-team games the player must still sit out.
/// A player with no ban, no injury, and no pending yellows has no row at all —
/// only players with something to track are stored.
class PlayerAbsence {
  const PlayerAbsence({
    required this.playerId,
    this.yellows = 0,
    this.banMatches = 0,
    this.injuryMatches = 0,
  });

  final int playerId;
  final int yellows;
  final int banMatches;
  final int injuryMatches;

  /// Whether the player can be selected for the next match.
  bool get isAvailable => banMatches == 0 && injuryMatches == 0;

  /// Whether this standing is worth persisting (anything non-zero).
  bool get isNotable => yellows > 0 || banMatches > 0 || injuryMatches > 0;

  /// A short reason the player is unavailable, or null if they are available.
  String? get reason {
    if (injuryMatches > 0) {
      return 'Injured · ${injuryMatches}g';
    }
    if (banMatches > 0) {
      return 'Suspended · ${banMatches}g';
    }
    return null;
  }

  PlayerAbsence copyWith({int? yellows, int? banMatches, int? injuryMatches}) =>
      PlayerAbsence(
        playerId: playerId,
        yellows: yellows ?? this.yellows,
        banMatches: banMatches ?? this.banMatches,
        injuryMatches: injuryMatches ?? this.injuryMatches,
      );
}
