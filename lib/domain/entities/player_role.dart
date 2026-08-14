/// A per-player tactical role — a job within the side that shapes how likely
/// they are to score, to create, and to threaten from set pieces. Roles never
/// change a team's raw strength (so they can't warp the balance); they tilt the
/// distribution of chances and the aerial threat, which is the tactical texture.
///
/// Every effect is a plain multiplier, so [none] (the default, and every
/// opponent) leaves the engine behaving exactly as it did before roles existed.
enum PlayerRole {
  none,

  /// A focal point up top: wins the ball in the air and lays it off — more
  /// assists and a big set-piece threat, fewer goals of their own.
  targetMan,

  /// A fox in the box: lives on the shoulder for tap-ins — many more goals, few
  /// assists.
  poacher,

  /// The creative hub: threads the passes — far more assists, fewer goals.
  playmaker,

  /// A destroyer in midfield: breaks play up rather than finishing it.
  ballWinner,

  /// Cuts in off the flank onto their stronger foot to shoot — more goals.
  invertedWinger,

  /// Steps out and starts moves from the back — a little more creative.
  ballPlayingDefender,
}

extension PlayerRoleX on PlayerRole {
  /// Short label for the UI.
  String get label => switch (this) {
    PlayerRole.none => 'No role',
    PlayerRole.targetMan => 'Target man',
    PlayerRole.poacher => 'Poacher',
    PlayerRole.playmaker => 'Playmaker',
    PlayerRole.ballWinner => 'Ball winner',
    PlayerRole.invertedWinger => 'Inverted winger',
    PlayerRole.ballPlayingDefender => 'Ball-playing defender',
  };

  /// One-line description of what the role does.
  String get blurb => switch (this) {
    PlayerRole.none => 'Plays their natural game.',
    PlayerRole.targetMan => 'Wins headers, lays it off — assists & set pieces.',
    PlayerRole.poacher => 'Lurks in the box — many more goals.',
    PlayerRole.playmaker => 'Creates chances — far more assists.',
    PlayerRole.ballWinner => 'Breaks up play rather than finishing it.',
    PlayerRole.invertedWinger => 'Cuts inside to shoot — more goals.',
    PlayerRole.ballPlayingDefender => 'Starts moves from the back.',
  };

  /// Multiplier on the player's weight to be the OPEN-PLAY scorer.
  double get scorerWeight => switch (this) {
    PlayerRole.poacher => 1.7,
    PlayerRole.invertedWinger => 1.4,
    PlayerRole.targetMan => 0.9,
    PlayerRole.playmaker => 0.8,
    PlayerRole.ballWinner => 0.6,
    PlayerRole.ballPlayingDefender => 0.7,
    PlayerRole.none => 1.0,
  };

  /// Multiplier on the player's weight to provide the ASSIST.
  double get assistWeight => switch (this) {
    PlayerRole.playmaker => 1.8,
    PlayerRole.targetMan => 1.4,
    PlayerRole.invertedWinger => 1.2,
    PlayerRole.ballPlayingDefender => 1.3,
    PlayerRole.ballWinner => 1.1,
    PlayerRole.poacher => 0.5,
    PlayerRole.none => 1.0,
  };

  /// Multiplier on the player's weight to score from a SET PIECE (aerial).
  double get aerialWeight => switch (this) {
    PlayerRole.targetMan => 2.4,
    PlayerRole.ballPlayingDefender => 1.2,
    PlayerRole.poacher => 1.1,
    PlayerRole.none ||
    PlayerRole.playmaker ||
    PlayerRole.ballWinner ||
    PlayerRole.invertedWinger => 1.0,
  };

  /// Which position categories the role is offered for, so the picker only
  /// shows sensible options (a poacher for a striker, not a keeper).
  bool get forForwards => switch (this) {
    PlayerRole.targetMan ||
    PlayerRole.poacher ||
    PlayerRole.invertedWinger ||
    PlayerRole.none => true,
    _ => false,
  };

  bool get forMidfielders => switch (this) {
    PlayerRole.playmaker ||
    PlayerRole.ballWinner ||
    PlayerRole.invertedWinger ||
    PlayerRole.none => true,
    _ => false,
  };

  bool get forDefenders => switch (this) {
    PlayerRole.ballPlayingDefender || PlayerRole.none => true,
    _ => false,
  };
}
