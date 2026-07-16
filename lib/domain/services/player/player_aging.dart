import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';

/// Ages a player across cycles: young players develop, players peak in their
/// mid-to-late twenties, then decline — physical attributes (pace, stamina,
/// strength) falling faster than technical/mental ones. Deterministic and pure,
/// derived from the base seed + the number of four-year cycles elapsed, so no
/// per-save storage is needed and every save evolves on its own timeline.
abstract final class PlayerAging {
  /// The player as they are [cycles] four-year cycles after their seed state.
  static Player aged(Player p, int cycles) => agedYears(p, cycles * 4);

  /// The player as they are [years] years after their seed state — the same
  /// curve as [aged], but at one-year resolution so squads evolve every season
  /// rather than jumping four years at a time.
  static Player agedYears(Player p, int years) {
    if (years <= 0) return p;
    final toAge = p.age + years;
    return p.copyWith(
      age: toAge,
      attributes: _age(p.attributes, p.age, toAge),
    );
  }

  static PlayerAttributes _age(PlayerAttributes a, int from, int to) =>
      PlayerAttributes(
        passing: _grow(a.passing, from, to, physical: false),
        shooting: _grow(a.shooting, from, to, physical: false),
        dribbling: _grow(a.dribbling, from, to, physical: true),
        tackling: _grow(a.tackling, from, to, physical: false),
        positioning: _grow(a.positioning, from, to, physical: false),
        composure: _grow(a.composure, from, to, physical: false),
        decisions: _grow(a.decisions, from, to, physical: false),
        pace: _grow(a.pace, from, to, physical: true),
        stamina: _grow(a.stamina, from, to, physical: true),
        strength: _grow(a.strength, from, to, physical: true),
      );

  /// Walks a single attribute year by year through the age curve.
  static int _grow(int base, int from, int to, {required bool physical}) {
    var v = base.toDouble();
    for (var age = from; age < to; age++) {
      v += _yearlyDelta(age, physical: physical);
    }
    return v.round().clamp(20, 95);
  }

  /// The per-year change to an attribute at a given [age].
  static double _yearlyDelta(int age, {required bool physical}) {
    if (age < 21) return physical ? 1.6 : 1.3; // rapid early development
    if (age < 24) return physical ? 1.1 : 1.0;
    if (age < 28) return physical ? 0.2 : 0.5; // peak / experience gains
    if (age < 31) return physical ? -1.1 : 0.1; // physical starts to go
    if (age < 34) return physical ? -2.4 : -0.7;
    return physical ? -3.4 : -1.6; // veteran decline
  }
}
