import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/player/player_traits.dart';

/// Who steps up in a shootout, and how good they are from twelve yards.
///
/// A shootout used to be settled by team strength alone: the same eleven could
/// have Baggio or a centre-half on the fifth kick and it made no difference.
/// The order is now the manager's to set, and each taker's own composure
/// decides their kick — which is the whole drama of a shootout.
abstract final class PenaltyTakers {
  /// How many kicks a best-of-five order covers. Beyond that, sudden death
  /// cycles back through the same list.
  static const int kOrderSize = 5;

  /// The five [xi] players a manager would name by default, best first:
  /// composure on the ball above all, then how far up the pitch they play.
  /// Never the goalkeeper unless there is nobody else left.
  static List<Player> autoOrder(
    List<Player> xi, {
    Set<int> unavailable = const {},
    Map<int, List<PlayerTrait>> traitsByPlayer = const {},
  }) {
    final pool = [
      for (final p in xi)
        if (!unavailable.contains(p.id)) p,
    ];
    final outfield = [
      for (final p in pool)
        if (p.position.category != PositionCategory.goalkeeper) p,
    ];
    final candidates = outfield.isEmpty ? pool : outfield;
    final ranked = [...candidates]
      ..sort((a, b) {
        final byNerve = _nerve(
          b,
          traitsByPlayer[b.id] ?? const [],
        ).compareTo(_nerve(a, traitsByPlayer[a.id] ?? const []));
        return byNerve != 0 ? byNerve : b.overall.compareTo(a.overall);
      });
    return ranked.take(kOrderSize).toList();
  }

  /// A taker's per-kick conversion MULTIPLIER on the side's base rate (1.0 is
  /// an ordinary penalty taker). Composure carries it; a dead-ball specialist
  /// is surer, a wasteful forward less so, and the biggest occasion is exactly
  /// where a big-game player shows up.
  static double skillOf(Player p, List<PlayerTrait> traits) {
    var factor = 0.86 + (p.attributes.technical.clamp(20, 99) - 60) / 220;
    if (traits.contains(PlayerTrait.setPiece)) factor *= 1.06;
    if (traits.contains(PlayerTrait.bigGame)) factor *= 1.04;
    if (traits.contains(PlayerTrait.wasteful)) factor *= 0.92;
    if (p.position.category == PositionCategory.goalkeeper) factor *= 0.88;
    return factor.clamp(0.72, 1.16);
  }

  /// The per-kick multipliers for an ordered list of takers, for the engine.
  static List<double> skillOrder(
    List<Player> order, {
    Map<int, List<PlayerTrait>> traitsByPlayer = const {},
  }) => [
    for (final p in order) skillOf(p, traitsByPlayer[p.id] ?? const []),
  ];

  /// How composed a player is from the spot, for ordering. Attacking players
  /// take more penalties in real life, so position breaks ties among equally
  /// composed players rather than deciding it outright.
  static double _nerve(Player p, List<PlayerTrait> traits) {
    final positional = switch (p.position.category) {
      PositionCategory.forward => 6.0,
      PositionCategory.midfielder => 4.0,
      PositionCategory.defender => 1.0,
      PositionCategory.goalkeeper => 0.0,
    };
    return skillOf(p, traits) * 100 + positional;
  }
}
