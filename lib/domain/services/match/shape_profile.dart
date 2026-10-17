import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';

/// How many men a formation commits forward and how many it keeps back.
///
/// The engine's attack and defence are built from LINE MEANS (forwards,
/// midfielders, defenders), which is blind to how many men stand in each
/// line: a 4-2-4 and a 5-4-1 of the same players read almost identically
/// there. This counts the bodies instead, so choosing a shape is a real
/// bargain (more attackers means more threat AND a thinner back) rather than
/// a label.
///
/// Wide midfielders and attacking midfielders count fractionally: they spend
/// part of the match in the attack, but not all of it.
abstract final class ShapeProfile {
  /// The 4-3-3 reading: three forwards, no wide or attacking midfielders.
  static const double neutralAttackers = 3.0;

  /// The 4-3-3 reading: four defenders and a holding midfielder (half a man).
  static const double neutralDefenders = 4.5;

  /// Attacker and defender weights of [slots] (the goalkeeper counts for
  /// neither; central midfielders are the balance between the two).
  static ({double attackers, double defenders}) of(List<PlayerPosition> slots) {
    var attackers = 0.0;
    var defenders = 0.0;
    for (final p in slots) {
      switch (p) {
        case PlayerPosition.st:
        case PlayerPosition.lw:
        case PlayerPosition.rw:
          attackers += 1.0;
        case PlayerPosition.am:
          attackers += 0.5;
        case PlayerPosition.lm:
        case PlayerPosition.rm:
          attackers += 0.25;
        case PlayerPosition.cb:
        case PlayerPosition.lb:
        case PlayerPosition.rb:
          defenders += 1.0;
        case PlayerPosition.dm:
          defenders += 0.5;
        case PlayerPosition.gk:
        case PlayerPosition.cm:
          break;
      }
    }
    return (attackers: attackers, defenders: defenders);
  }

  /// Convenience for a whole [Formation].
  static ({double attackers, double defenders}) ofFormation(Formation f) =>
      of(f.positions);
}
