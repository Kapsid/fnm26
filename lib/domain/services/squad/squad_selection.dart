import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_absence.dart';

/// The squads the call-up screen offers when the manager would rather not pick
/// twenty-three names by hand.
///
/// Pure functions over a pool, kept out of the screen so what "the best squad"
/// means is a thing that can be stated and tested rather than a private method
/// on a widget's state.
abstract final class SquadSelection {
  /// How many keepers a squad carries, whatever the shape.
  ///
  /// The one line the formation does not get a say over: every side fields
  /// exactly one goalkeeper, and every real squad still travels with three.
  static const int keepers = 3;

  /// Whether a player is worth naming for a squad covering [coverage] matches.
  ///
  /// A one-match knock or ban does NOT rule a player out of a squad that covers
  /// four games — he sits out the first and plays the rest, exactly as a real
  /// call-up list works. Only someone missing EVERY match in the period is left
  /// out, which is what the auto-picks used to do to anyone carrying so much as
  /// a single-game absence.
  static bool usableInPeriod(PlayerAbsence? absence, int coverage) {
    if (absence == null || absence.isAvailable) return true;
    final out = absence.injuryMatches > absence.banMatches
        ? absence.injuryMatches
        : absence.banMatches;
    return out < (coverage < 1 ? 1 : coverage);
  }

  /// The best [max] players who are usable at some point in the period, with
  /// every line of [formation] actually covered.
  ///
  /// Straight quality alone is not a squad. Taking the twenty best outfielders
  /// a nation has produced squads with two defenders and nine midfielders in
  /// them, because that is how the pool happened to rate — and the first
  /// suspension in the back line then forced a winger into it.
  ///
  /// So each outfield line gets a FLOOR of what the shape fields plus one: a
  /// back four means five defenders named, a midfield three means four. One
  /// spare per line is what covers a knock or a ban without reshaping the
  /// side. Above the floor it is quality again, so a deep midfield still
  /// travels. Keepers are the exception, on [keepers] whatever the shape.
  static Set<int> bestQuality({
    required List<Player> pool,
    required Map<int, PlayerAbsence> absences,
    required int coverage,
    required Formation formation,
    required int max,
  }) {
    final fit = _fit(pool, absences, coverage);
    bool isGk(Player p) => p.position.category == PositionCategory.goalkeeper;

    final fielded = <PositionCategory, int>{};
    for (final pos in formation.positions) {
      fielded[pos.category] = (fielded[pos.category] ?? 0) + 1;
    }

    final picked = {...fit.where(isGk).take(keepers).map((p) => p.id)};
    for (final line in PositionCategory.values) {
      if (line == PositionCategory.goalkeeper) continue;
      final floor = (fielded[line] ?? 0) + 1;
      var named = 0;
      for (final p in fit) {
        if (named >= floor || picked.length >= max) break;
        if (p.position.category != line || picked.contains(p.id)) continue;
        picked.add(p.id);
        named++;
      }
    }
    // The floors are a floor, not the squad: whatever is left over goes to the
    // best outfielders still unnamed, wherever they play.
    for (final p in fit) {
      if (picked.length >= max) break;
      if (isGk(p) || picked.contains(p.id)) continue;
      picked.add(p.id);
    }
    return picked;
  }

  /// Last time's squad, minus anyone who cannot play at all in this period.
  static Set<int> previousSquad({
    required List<Player> pool,
    required Iterable<int> previous,
    required Map<int, PlayerAbsence> absences,
    required int coverage,
    required int max,
  }) {
    final was = previous.toSet();
    return _fit(
      pool.where((p) => was.contains(p.id)).toList(),
      absences,
      coverage,
    ).take(max).map((p) => p.id).toSet();
  }

  /// Everyone usable in the period, best first.
  ///
  /// Whoever can play the FIRST match comes first at equal quality, so the
  /// named squad can always field an XI straight away.
  static List<Player> _fit(
    List<Player> pool,
    Map<int, PlayerAbsence> absences,
    int coverage,
  ) =>
      pool.where((p) => usableInPeriod(absences[p.id], coverage)).toList()
        ..sort((a, b) {
          final aFit = absences[a.id]?.isAvailable ?? true;
          final bFit = absences[b.id]?.isAvailable ?? true;
          if (aFit != bFit) return aFit ? -1 : 1;
          return b.overall.compareTo(a.overall);
        });
}
