import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';

/// Maps competitions to their bundled trophy artwork (assets/trophies/*.png),
/// so the World Cup, each continental championship, the Nations Cup and the
/// Continental Clash all show their own trophy across the cup screens and the
/// manager's trophy cabinet.
abstract final class Trophies {
  static const _base = 'assets/trophies';

  static const worldCup = '$_base/world.png';
  static const nationsCup = '$_base/nationscup.png';
  static const continentalClash = '$_base/continentalclash.png';

  /// A confederation's continental-championship trophy.
  static String forConfederation(Confederation c) => switch (c) {
        Confederation.europe => '$_base/europe.png',
        Confederation.southAmerica => '$_base/southamerica.png',
        Confederation.africa => '$_base/africa.png',
        Confederation.asia => '$_base/asia.png',
        Confederation.northAmerica => '$_base/northamerica.png',
        Confederation.oceania => '$_base/oceania.png',
      };

  /// The trophy for a stored honour's competition name, or null if unknown.
  static String? forCompetitionName(String name) {
    switch (name) {
      case 'World Championship':
        return worldCup;
      case 'Nations Cup':
        return nationsCup;
      case 'Continental Clash':
        return continentalClash;
    }
    for (final e in ContinentalCups.byConfederation.entries) {
      if (e.value.name == name) return forConfederation(e.key);
    }
    return null;
  }

  /// A stable key for a competition (for tallying the trophy cabinet).
  static String? keyForCompetitionName(String name) {
    switch (name) {
      case 'World Championship':
        return 'world';
      case 'Nations Cup':
        return 'nationscup';
      case 'Continental Clash':
        return 'continentalclash';
    }
    for (final e in ContinentalCups.byConfederation.entries) {
      if (e.value.name == name) return e.key.name;
    }
    return null;
  }

  /// Every trophy, in cabinet display order, as (key, asset, label) — using the
  /// competitions' real names (e.g. 'European Championship', not 'Euros').
  static List<({String key, String asset, String label})> get cabinet {
    String cont(Confederation c) =>
        ContinentalCups.byConfederation[c]?.name ?? c.name;
    return [
      (key: 'world', asset: worldCup, label: 'World Cup'),
      (
        key: Confederation.europe.name,
        asset: forConfederation(Confederation.europe),
        label: cont(Confederation.europe),
      ),
      (
        key: Confederation.southAmerica.name,
        asset: forConfederation(Confederation.southAmerica),
        label: cont(Confederation.southAmerica),
      ),
      (
        key: Confederation.africa.name,
        asset: forConfederation(Confederation.africa),
        label: cont(Confederation.africa),
      ),
      (
        key: Confederation.asia.name,
        asset: forConfederation(Confederation.asia),
        label: cont(Confederation.asia),
      ),
      (
        key: Confederation.northAmerica.name,
        asset: forConfederation(Confederation.northAmerica),
        label: cont(Confederation.northAmerica),
      ),
      (
        key: Confederation.oceania.name,
        asset: forConfederation(Confederation.oceania),
        label: cont(Confederation.oceania),
      ),
      (key: 'nationscup', asset: nationsCup, label: 'Nations Cup'),
      (
        key: 'continentalclash',
        asset: continentalClash,
        label: 'Continental Clash',
      ),
    ];
  }
}
