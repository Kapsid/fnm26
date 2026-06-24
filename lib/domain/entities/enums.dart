/// Core domain enumerations shared across entities.
///
/// JSON encoding uses the enum member name (e.g. `europe`, `st`) via
/// json_serializable's default behaviour, and Drift persists the same names
/// via `textEnum`, so the wire/storage format is stable and human-readable.
library;

/// The continental region a nation belongs to.
///
/// Named by continent (not by the governing federation acronym) so the wire,
/// storage, and display forms all read naturally.
enum Confederation {
  /// Europe.
  europe,

  /// South America.
  southAmerica,

  /// North & Central America and the Caribbean.
  northAmerica,

  /// Africa.
  africa,

  /// Asia.
  asia,

  /// Oceania.
  oceania,
}

/// The kind of competition a record represents.
enum CompetitionKind {
  /// A confederation's World Cup qualifying tournament.
  worldCupQualifying,

  /// The World Cup finals (group stage + knockout).
  worldCupFinals,

  /// Friendly matches (warm-ups in otherwise empty windows).
  friendly,
}

/// Display helpers for [Confederation].
extension ConfederationX on Confederation {
  /// Human-readable region name (e.g. `South America`).
  String get label => switch (this) {
        Confederation.europe => 'Europe',
        Confederation.southAmerica => 'South America',
        Confederation.northAmerica => 'North America',
        Confederation.africa => 'Africa',
        Confederation.asia => 'Asia',
        Confederation.oceania => 'Oceania',
      };
}

/// On-pitch playing positions, ordered roughly back-to-front.
enum PlayerPosition {
  /// Goalkeeper.
  gk,

  /// Left-back.
  lb,

  /// Centre-back.
  cb,

  /// Right-back.
  rb,

  /// Defensive midfielder.
  dm,

  /// Central midfielder.
  cm,

  /// Attacking midfielder.
  am,

  /// Left midfielder / winger.
  lm,

  /// Right midfielder / winger.
  rm,

  /// Left wing-forward.
  lw,

  /// Right wing-forward.
  rw,

  /// Striker.
  st,
}

/// Broad positional groupings, derived from a [PlayerPosition].
enum PositionCategory {
  /// Goalkeepers.
  goalkeeper,

  /// Defenders.
  defender,

  /// Midfielders.
  midfielder,

  /// Forwards.
  forward,
}

/// Maps a fine-grained [PlayerPosition] to its broad [PositionCategory].
extension PlayerPositionX on PlayerPosition {
  /// The broad grouping this position belongs to.
  PositionCategory get category => switch (this) {
        PlayerPosition.gk => PositionCategory.goalkeeper,
        PlayerPosition.lb ||
        PlayerPosition.cb ||
        PlayerPosition.rb =>
          PositionCategory.defender,
        PlayerPosition.dm ||
        PlayerPosition.cm ||
        PlayerPosition.am ||
        PlayerPosition.lm ||
        PlayerPosition.rm =>
          PositionCategory.midfielder,
        PlayerPosition.lw ||
        PlayerPosition.rw ||
        PlayerPosition.st =>
          PositionCategory.forward,
      };

  /// Short uppercase label for UI (e.g. `GK`, `ST`).
  String get label => name.toUpperCase();

  /// Full descriptive role name (e.g. `Defensive Mid`).
  String get roleName => switch (this) {
        PlayerPosition.gk => 'Goalkeeper',
        PlayerPosition.lb => 'Left Back',
        PlayerPosition.cb => 'Centre Back',
        PlayerPosition.rb => 'Right Back',
        PlayerPosition.dm => 'Defensive Mid',
        PlayerPosition.cm => 'Central Mid',
        PlayerPosition.am => 'Attacking Mid',
        PlayerPosition.lm => 'Left Mid',
        PlayerPosition.rm => 'Right Mid',
        PlayerPosition.lw => 'Left Wing',
        PlayerPosition.rw => 'Right Wing',
        PlayerPosition.st => 'Striker',
      };
}
