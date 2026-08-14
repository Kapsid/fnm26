import 'package:fnm/core/rng/seeded_rng.dart';

/// A tournament edition's flavour identity — its official mascot and match
/// ball. Both are generated deterministically from the host, year and save
/// seed, so an edition always has the same mascot/ball (and re-viewing the
/// summary never reshuffles them).
typedef TournamentIdentity = ({String mascot, String ball});

/// Generates the mascot and match-ball names for a tournament edition.
///
/// Real tournaments name a themed mascot (usually a spirited animal or figure)
/// and an official ball each edition; these are invented, generic names so the
/// game carries the same colour without borrowing any real branding.
abstract final class TournamentBranding {
  static const _mascotAdjectives = <String>[
    'Brave', 'Golden', 'Roaring', 'Little', 'Mighty', 'Swift', 'Happy',
    'Wild', 'Bold', 'Dancing', 'Shining', 'Lucky', //
  ];

  static const _mascotAnimals = <String>[
    'Lion', 'Falcon', 'Fox', 'Bear', 'Eagle', 'Wolf', 'Tiger', 'Stallion',
    'Panther', 'Ram', 'Dragon', 'Hawk', 'Bull', 'Elephant', 'Crane', //
  ];

  static const _mascotNames = <String>[
    'Rico', 'Pip', 'Zizou', 'Bolo', 'Kiko', 'Tato', 'Nino', 'Gigi', 'Momo',
    'Coco', 'Fabi', 'Leo', 'Milo', 'Suri', //
  ];

  static const _ballRoots = <String>[
    'Unity', 'Fiesta', 'Aurora', 'Tempo', 'Estrella', 'Comet', 'Vento',
    'Azzurra', 'Lumen', 'Terra', 'Sol', 'Mirage', 'Ciela', 'Onda', //
  ];

  static const _ballSuffixes = <String>[
    'Prime', 'X', 'Pro', 'Flight', 'Elite', '25', 'Rush', 'Star', 'Nova', //
  ];

  /// The identity for an edition [hostName] hosts in [year], stable per save
  /// [seed].
  static TournamentIdentity forEdition({
    required String hostName,
    required int year,
    required int seed,
  }) {
    final rng = SeededRng(seed ^ (year * 0x9E37) ^ hostName.hashCode);
    final mascot =
        '${rng.pick(_mascotNames)} the '
        '${rng.pick(_mascotAdjectives)} ${rng.pick(_mascotAnimals)}';
    final ball = '${rng.pick(_ballRoots)} ${rng.pick(_ballSuffixes)}';
    return (mascot: mascot, ball: ball);
  }
}
