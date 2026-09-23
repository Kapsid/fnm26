import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';

/// A distinguishing quirk a player is known for.
///
/// Traits exist because a squad of twenty-three numbers is forgettable. Each
/// one gives a player something the manager remembers them BY — and, crucially,
/// something that changes how they should be used, so remembering matters.
///
/// Every trait is derived (never stored) from the player's id, position and
/// attributes, so it is stable for a given player in a given save and costs
/// nothing to keep in step with the procedural pool.
enum PlayerTrait {
  /// Turns up in finals and knockout rounds.
  bigGame,

  /// Free-kicks and penalties.
  setPiece,

  /// Books and sendings-off.
  hothead,

  /// Rarely gets injured, rarely tires.
  ironMan,

  /// Young and improving fast.
  wonderkid,

  /// Lifts the players around them.
  leader,

  /// Blistering over the ground.
  pacey,

  /// A veteran whose reading of the game outlasts their legs.
  oldHead,

  /// Wasteful with good chances.
  wasteful,
}

/// A trait's presentation and its effect, so screens and the engine agree.
typedef TraitInfo = ({String label, String glyph, String blurb, bool positive});

/// Derives and describes a player's traits.
///
/// A player carries at most [maxTraits]; most carry one, some none. They are
/// deliberately sparse — if everyone has three, nobody stands out.
abstract final class PlayerTraits {
  /// The most traits any one player can carry.
  static const int maxTraits = 2;

  /// [p]'s traits, stable for a given player and [saveSeed].
  static List<PlayerTrait> of(Player p, {int saveSeed = 0}) {
    final h = _hash(p.id ^ (saveSeed * 0x9E3779B1));
    final a = p.attributes;
    final out = <PlayerTrait>[];

    // Attribute-led traits come first: these are earned, not rolled, so a
    // genuinely quick player reads as quick.
    if (a.physical >= 84) out.add(PlayerTrait.pacey);
    if (a.stamina >= 86) out.add(PlayerTrait.ironMan);
    if (p.age <= 21 && p.overall >= 68) out.add(PlayerTrait.wonderkid);
    if (p.age >= 33 && a.technical >= 76) out.add(PlayerTrait.oldHead);

    // Rolled traits fill the rest of the allowance. The gates keep each one
    // plausible for the player it lands on — a centre-back is not the set-piece
    // specialist, and only a senior player captains the side.
    if (out.length < maxTraits) {
      final roll = h % 100;
      final candidates = <PlayerTrait>[
        if (a.technical >= 72 && _takesSetPieces(p.position))
          PlayerTrait.setPiece,
        if (p.overall >= 74) PlayerTrait.bigGame,
        if (p.age >= 27 && p.overall >= 72) PlayerTrait.leader,
        if (a.physical >= 70 && p.category != PositionCategory.goalkeeper)
          PlayerTrait.hothead,
        if (p.category == PositionCategory.forward && a.technical < 68)
          PlayerTrait.wasteful,
      ];
      // Only about a third of eligible players actually get a rolled trait,
      // so a trait stays a distinguishing mark rather than wallpaper.
      if (candidates.isNotEmpty && roll < 34) {
        final pick = candidates[(h ~/ 100) % candidates.length];
        if (!out.contains(pick)) out.add(pick);
      }
    }

    return out.take(maxTraits).toList();
  }

  /// Whether a player in [position] would plausibly stand over a dead ball.
  static bool _takesSetPieces(PlayerPosition position) =>
      position.category == PositionCategory.midfielder ||
      position.category == PositionCategory.forward ||
      position == PlayerPosition.lb ||
      position == PlayerPosition.rb;

  /// A stable non-negative hash (avalanche mix).
  static int _hash(int x) {
    var h = x & 0x7fffffff;
    h = (h ^ (h >> 16)) * 0x45d9f3b & 0x7fffffff;
    h = (h ^ (h >> 16)) * 0x45d9f3b & 0x7fffffff;
    return (h ^ (h >> 16)) & 0x7fffffff;
  }

  // --- Effects, read by the match engine ------------------------------------

  /// The rating shift a trait is worth in a KNOCKOUT or finals match — the
  /// occasion players are remembered for.
  static const int bigGameBonus = 4;

  /// How much a hothead's card risk is multiplied.
  static const double hotheadCardFactor = 1.9;

  /// How much an iron man's injury risk is multiplied (below 1 = tougher).
  static const double ironManInjuryFactor = 0.45;

  /// How much slower an iron man's energy drains.
  static const double ironManStaminaFactor = 0.80;

  /// The set-piece specialist's conversion multiplier on free-kicks and
  /// penalties.
  static const double setPieceFactor = 1.30;

  /// A wasteful forward's finishing multiplier.
  static const double wastefulFinishFactor = 0.85;

  /// The rating a leader adds to EVERY OTHER player on the pitch.
  static const int leaderTeamBonus = 1;
}
