import 'dart:async';

import 'package:fnm/domain/services/rating/overall_rating.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';

/// A pack player as the world gives him on day one.
typedef PackDayOne = ({int age, int overall});

/// What a career on a custom world tells the development code: each pack
/// player's edited potential (his peak overall) and who he is on day one.
/// Built once per world and handed to [WorldZone.runFor].
class WorldZoneData {
  const WorldZoneData(this.potentials, [this.dayOne = const {}]);

  /// Every squad player of [pack].
  factory WorldZoneData.of(WorldPack pack) {
    final potentials = <int, int>{};
    final dayOne = <int, PackDayOne>{};
    for (final squad in pack.squads.values) {
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
  /// zone and for a player the world does not hold (fringe, newgens).
  static int? potentialOf(int playerId) => _current?.potentials[playerId];

  /// [playerId]'s day-one age and overall in the current world, if known.
  static PackDayOne? dayOneOf(int playerId) => _current?.dayOne[playerId];
}
