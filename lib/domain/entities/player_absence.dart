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

  // There is deliberately no `reason` getter here. It returned a hard-coded
  // English "Injured · 4g", which three screens printed whenever the localised
  // outlook had nothing for a player — untranslated in a Czech save, and built
  // from a snapshot of this table that the rest of the game had already moved
  // past. `absenceShortLabel` (absence_providers.dart) says the same thing in
  // the manager's language, and says nothing at all for an available player.

  PlayerAbsence copyWith({int? yellows, int? banMatches, int? injuryMatches}) =>
      PlayerAbsence(
        playerId: playerId,
        yellows: yellows ?? this.yellows,
        banMatches: banMatches ?? this.banMatches,
        injuryMatches: injuryMatches ?? this.injuryMatches,
      );
}
