import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/match/match_simulator.dart';

/// One other nation's friendly result shown alongside the player's own.
typedef FriendlyResult = ({
  int homeId,
  int awayId,
  int homeScore,
  int awayScore,
});

/// The rest of the world's friendlies in an international window.
///
/// Real windows are full: almost every European side with no qualifier plays
/// a friendly, and most of the rest of the world does too. These are
/// generated, never persisted, deterministically from the save seed and the
/// window, so the same window always reads the same results and old saves
/// load untouched (nothing new is stored, no rankings move).
abstract final class WindowFriendlies {
  /// How likely a free nation is to arrange a friendly in a window. Europe's
  /// calendar is the fullest; Oceania's small, far-flung federations play
  /// least.
  static const Map<Confederation, double> _playChance = {
    Confederation.europe: 0.92,
    Confederation.southAmerica: 0.9,
    Confederation.northAmerica: 0.75,
    Confederation.africa: 0.8,
    Confederation.asia: 0.8,
    Confederation.oceania: 0.55,
  };

  /// The share of friendlies played against a side from another continent.
  static const double _crossContinent = 0.18;

  /// The friendlies of the window [windowKey] (any stable year/month key)
  /// among [nations], skipping everyone in [busyIds] (they have a competitive
  /// match in the window, or are the player and his opponent).
  ///
  /// Most free nations play; partners come mostly from the same continent,
  /// with a few intercontinental fixtures. Each nation plays at most once.
  static List<FriendlyResult> generate({
    required List<Nation> nations,
    required Set<int> busyIds,
    required int seed,
    required int windowKey,
  }) {
    final rng = SeededRng(seed ^ (windowKey * 0x9E3D) ^ 0x7F1E);
    // A stable order before any draw, so the result never depends on how the
    // caller happened to list the nations.
    final free = [
      for (final n in nations)
        if (!busyIds.contains(n.id)) n,
    ]..sort((a, b) => a.id.compareTo(b.id));

    // Who plays, and whether they look abroad for an opponent.
    final byConf = <Confederation, List<Nation>>{};
    final abroad = <Nation>[];
    for (final n in free) {
      if (!rng.chance(_playChance[n.confederation] ?? 0.75)) continue;
      if (rng.chance(_crossContinent)) {
        abroad.add(n);
      } else {
        (byConf[n.confederation] ??= []).add(n);
      }
    }

    final pairs = <(Nation, Nation)>[];
    for (final c in Confederation.values) {
      final list = rng.shuffled(byConf[c] ?? const <Nation>[]);
      for (var i = 0; i + 1 < list.length; i += 2) {
        pairs.add((list[i], list[i + 1]));
      }
      // The odd one out looks for an opponent abroad.
      if (list.length.isOdd) abroad.add(list.last);
    }
    // Pair the travellers with sides from other continents where possible.
    final travellers = rng.shuffled(abroad);
    while (travellers.length >= 2) {
      final a = travellers.removeAt(0);
      var j = travellers.indexWhere((b) => b.confederation != a.confederation);
      if (j < 0) j = 0;
      pairs.add((a, travellers.removeAt(j)));
    }

    const sim = RatingMatchSimulator();
    return [
      for (var i = 0; i < pairs.length; i++)
        () {
          final swap = rng.chance(0.5);
          final home = swap ? pairs[i].$2 : pairs[i].$1;
          final away = swap ? pairs[i].$1 : pairs[i].$2;
          final out = sim.simulate(
            homeStrength: RatingMatchSimulator.strengthOf(home),
            awayStrength: RatingMatchSimulator.strengthOf(away),
            rng: SeededRng(rng.nextInt(1 << 30) ^ (i * 0x51ED)),
          );
          return (
            homeId: home.id,
            awayId: away.id,
            homeScore: out.homeScore,
            awayScore: out.awayScore,
          );
        }(),
    ];
  }
}
