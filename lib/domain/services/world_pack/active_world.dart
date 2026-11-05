import 'dart:async';
import 'dart:typed_data';

import 'package:fnm/domain/services/rating/overall_rating.dart';
import 'package:fnm/domain/services/world_pack/pack_paths.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';

/// A pack player as the world gives him on day one.
typedef PackDayOne = ({int age, int overall});

/// What a career on a custom world tells the development code: each pack
/// player's edited potential (his peak overall) and who he is on day one.
/// Built once per world and handed to [WorldZone.runFor].
class WorldZoneData {
  const WorldZoneData(this.potentials, [this.dayOne = const {}]);

  /// Every squad and fixed-pool player of [pack].
  factory WorldZoneData.of(WorldPack pack) {
    final potentials = <int, int>{};
    final dayOne = <int, PackDayOne>{};
    // Pools first, so a squad player wins should an unchecked world hold an
    // id in both (as the repository's index does).
    for (final squad in [...pack.pools.values, ...pack.squads.values]) {
      for (final p in squad) {
        potentials[p.id] = p.potential;
        dayOne[p.id] = (
          age: p.age,
          overall: OverallRating.forPosition(p.position, p.attributes),
        );
      }
    }
    return WorldZoneData(
      Map.unmodifiable(potentials),
      Map.unmodifiable(dayOne),
    );
  }

  final Map<int, int> potentials;
  final Map<int, PackDayOne> dayOne;
}

/// The custom world the code running now belongs to, carried in a [Zone].
///
/// Player development is static and reads a player by id alone, so a career
/// on a custom world says so by running its reads inside [run]: there, a pack
/// player grows toward the potential the editor gave him
/// (`PlayerLifecycle.developmentPotential`) and nobody is a hidden superstar
/// (`PlayerLifecycle.isSuperstar`). Outside a zone (every default career)
/// nothing changes. Zone values carry across `await`.
abstract final class WorldZone {
  static const Symbol _key = #fnmWorldPotentials;

  /// Runs [body] as a career on a world whose pack players have
  /// [potentials] (id → peak overall) and, optionally, [dayOne] standings.
  static R run<R>(
    Map<int, int> potentials,
    R Function() body, {
    Map<int, PackDayOne> dayOne = const {},
  }) => runZoned(
    body,
    zoneValues: {_key: WorldZoneData(potentials, dayOne)},
  );

  /// [run] with [world]'s data. A null [world] (a default career) runs
  /// [body] outside any world, even when called from inside one.
  static R runFor<R>(WorldZoneData? world, R Function() body) =>
      world == null && !active
      ? body()
      : runZoned(body, zoneValues: {_key: world});

  /// Whether the code running now is in [world]'s zone ([world] null: in
  /// none).
  static bool runs(WorldZoneData? world) => identical(_current, world);

  /// The zone [_current] was last read in, and what it held. Development
  /// asks this on every player of every pool, and a zone value lookup walks
  /// the whole chain of zones each time; a zone's values never change, so
  /// one identity check answers all but the first ask per zone.
  static Zone? _lastZone;
  static WorldZoneData? _lastData;

  static WorldZoneData? get _current {
    final zone = Zone.current;
    if (!identical(zone, _lastZone)) {
      _lastData = zone[_key] as WorldZoneData?;
      _lastZone = zone;
    }
    return _lastData;
  }

  /// Whether the code running now belongs to a career on a custom world.
  static bool get active => _current != null;

  /// [playerId]'s edited potential in the current world; null outside a
  /// zone and for a player the world does not hold (an untouched pool's
  /// fringe, newgens).
  static int? potentialOf(int playerId) => _current?.potentials[playerId];

  /// [playerId]'s day-one age and overall in the current world, if known.
  static PackDayOne? dayOneOf(int playerId) => _current?.dayOne[playerId];
}

/// The custom world the career on screen belongs to, for the display code.
///
/// Names are printed by pure functions with no Riverpod at hand
/// (`competitionLabel`, `nationCodeLabel`, and in later steps the sponsor,
/// press, Y, stadium and trophy labels), so the world they print for is held
/// here, in [current]. It is mirrored from `activeWorldProvider`, which
/// follows the route: a career's world while one of its screens is open,
/// [none] on the menus. Every getter answers null when the world has nothing
/// to say, and the caller then prints exactly what it printed before.
///
/// Only DISPLAY reads this. Stored names (competitions, nations) stay the
/// canonical English ones the logic compares; the real nation code stays
/// the key for flags and data.
class ActiveWorld {
  /// [pack]'s overrides, with its custom [trophies] (key → PNG) and the real
  /// code of every nation id ([realCodes]), which lets a code printed on its
  /// own be swapped for the world's ([codeLabel]).
  ActiveWorld(
    WorldPack this.pack, {
    this.trophies = const {},
    Map<int, String> realCodes = const {},
  }) : _codeLabels = {
         for (final e in pack.nations.entries)
           if (realCodes[e.key] case final real?)
             if (e.value.code.trim().isNotEmpty) real: e.value.code,
       };

  const ActiveWorld._none()
    : pack = null,
      trophies = const {},
      _codeLabels = const {};

  /// The default world: no overrides at all.
  static const ActiveWorld none = ActiveWorld._none();

  /// The world the screens on show belong to. See the class comment.
  static ActiveWorld current = none;

  /// The career's world, or null for the default world.
  final WorldPack? pack;

  /// Custom trophy PNGs, by trophy key.
  final Map<String, Uint8List> trophies;

  /// Real code → the world's code, for the renamed nations only.
  final Map<String, String> _codeLabels;

  /// Whether this is the default world, with nothing overridden.
  bool get isDefault => pack == null;

  /// The stored names the World Championship has gone by, all printed as
  /// it is (see `competitionLabel`'s table).
  static const _worldChampionshipAliases = {
    'World Cup',
    'the World Cup',
    'World Championship Finals',
  };

  /// Nation [id]'s name in this world, in every language.
  String? nationName(int id) => textOrNull(pack?.nations[id]?.name);

  /// Nation [id]'s 3-letter display code in this world.
  String? nationCode(int id) => textOrNull(pack?.nations[id]?.code);

  /// The world's code for the nation whose real code is [realCode].
  String? codeLabel(String realCode) => _codeLabels[realCode];

  /// The world's name for the competition stored as [stored].
  String? competition(String stored) {
    final p = pack;
    if (p == null || p.competitions.isEmpty) return null;
    final key = stored.trim();
    return textOrNull(p.competitions[key]) ??
        (_worldChampionshipAliases.contains(key)
            ? textOrNull(p.competitions['World Championship'])
            : null);
  }

  /// The world's name for the sponsor brand [brand].
  String? sponsor(String brand) => textOrNull(pack?.sponsors[brand]);

  /// This world's [language] name for the sponsor it added with id [id], or
  /// null. Only a per-language override: the sponsor's own copy carries its
  /// main name. Answers only when this is the world that added it ([world],
  /// the uuid of the career's own copy), since another world's added
  /// sponsors share the same ids.
  String? addedSponsorName(
    int id, {
    required String? world,
    required String language,
  }) => _ownLocalized(PackPaths.addedSponsor(id), world, language);

  /// This world's [language] description for the sponsor it added with id
  /// [id]; see [addedSponsorName].
  String? addedSponsorDescription(
    int id, {
    required String? world,
    required String language,
  }) => _ownLocalized(PackPaths.addedSponsorDescription(id), world, language);

  String? _ownLocalized(String path, String? world, String language) {
    final p = pack;
    if (p == null || world == null || p.uuid != world) return null;
    return textOrNull(p.localized[path]?[language]);
  }

  /// The world's name for the ground in [city], nation [nationId].
  String? stadium(int nationId, String city) =>
      textOrNull(pack?.stadiums['$nationId:$city']);

  /// The reporter replacing the press desk's reporter [index].
  PackReporter? reporter(int index) => pack?.reporters[index];

  /// The world's name for the Y account [original].
  String? yAccount(String original) => textOrNull(pack?.yAccounts[original]);

  /// The account the world renamed to [shown], by its original name: what
  /// its disposition is read off, so a renamed account keeps its voice.
  ///
  /// `PackRules` refuses two accounts under one name; should a pack carry a
  /// clash anyway (one not yet checked), the lowest original wins, so the
  /// answer never depends on the order the pack was read in.
  String? yAccountOriginal(String shown) {
    final accounts = pack?.yAccounts;
    if (accounts == null) return null;
    String? found;
    for (final e in accounts.entries) {
      if (textOrNull(e.value) != shown) continue;
      if (found == null || e.key.compareTo(found) < 0) found = e.key;
    }
    return found;
  }

  /// The world's picture of trophy [key].
  Uint8List? trophy(String key) => trophies[key];

  /// [s], unless there is nothing in it to print: a blank override counts
  /// as none.
  static String? textOrNull(String? s) =>
      s == null || s.trim().isEmpty ? null : s;
}
