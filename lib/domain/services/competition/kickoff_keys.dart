/// The `DrawsWatched` keys for the finals opening ceremonies.
///
/// They live here, apart from the timeline that fires them, because anything
/// that has to know a tournament has been *opened* needs them — the press, for
/// one — and reaching into the hub's event module for a pair of string
/// constants would tie those features to it for no reason.

/// Watched key for the World Cup opening ceremony (fires once per edition,
/// after the finals draw and before the first matchday).
const String worldCupKickoffKind = 'worldCupKickoff';

/// Watched key for a continental championship's opening ceremony (trophy +
/// host reveal), so it fires once per edition like the World Cup kickoff.
const String continentalKickoffKind = 'contKickoff';
