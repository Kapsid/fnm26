import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';

/// Who takes a set piece when the manager has not said.
///
/// A deliberate duplicate of the engine's own automatic choice
/// (`MatchEngine._penaltyTaker` and `_setPieceTaker`): a screen that shows a
/// different taker than the one who actually steps up is worse than the blank
/// slot it replaced. If the engine's rule changes, this changes with it.
abstract final class SetPiecePicks {
  /// The best technical outfielder in [xi], or the best of whoever is there
  /// when a side is somehow all keepers. Null for an empty eleven.
  static int? penalty(List<Player> xi) {
    if (xi.isEmpty) return null;
    final outfield = xi
        .where((p) => p.position.category != PositionCategory.goalkeeper)
        .toList();
    final pool = outfield.isEmpty ? xi : outfield;
    return pool
        .reduce(
          (a, b) => b.attributes.technical > a.attributes.technical ? b : a,
        )
        .id;
  }

  /// The best technical player in [xi]. This is the engine's dead-ball rule
  /// without its "not the scorer" clause, which only exists at the moment a
  /// goal is being attributed and has no meaning on a team sheet.
  static int? deadBall(List<Player> xi) {
    if (xi.isEmpty) return null;
    return xi
        .reduce(
          (a, b) => b.attributes.technical > a.attributes.technical ? b : a,
        )
        .id;
  }
}
