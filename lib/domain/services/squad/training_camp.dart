import 'package:fnm/core/rng/seeded_rng.dart';

/// The kind of ground a base camp sits on. It is the whole of the decision: a
/// camp is not a better or worse choice, it is a *different* one, and each
/// terrain trades one preparation against another.
enum CampTerrain {
  /// In or beside the biggest host city. Nothing to travel to, everything on
  /// hand — but a squad living in the middle of the tournament gets no peace.
  cityCentre,

  /// A resort on the coast. Comfortable and calm; a long coach ride to
  /// everywhere the tournament actually is.
  coastal,

  /// A quiet valley up in the hills. Cool air and a medical set-up that gets
  /// knocks turned round quickly; a long way from the grounds.
  mountain,

  /// High altitude. Brutal to train in, and the legs that come down off it last
  /// deep into a tournament.
  altitude,

  /// A purpose-built national training centre out of town. The safe pick.
  nationalCentre,
}

/// One camp on offer, with what it is worth.
///
/// Every effect is a multiplier or a small delta on something the rest of the
/// game already models, so a camp never becomes its own hidden subsystem:
///
/// * [travelFatigue] scales the fatigue a match costs — under 1 is a squad
///   that arrives fresh, over 1 one that spends the tournament on a coach.
/// * [injuryRecovery] scales how quickly knocks clear.
/// * [conditionBonus] is a flat lift to sharpness for the tournament.
typedef TrainingCamp = ({
  /// Stable index within the host's list, which is what gets stored.
  int index,
  String name,
  String region,
  CampTerrain terrain,
  double travelFatigue,
  double injuryRecovery,
  int conditionBonus,
});

/// The base camps a tournament host can offer.
///
/// Deterministic in the host's id, so the same country always offers the same
/// places — a manager who came here four years ago recognises the list — and
/// generated for EVERY nation, so there is never a host with nowhere to stay.
abstract final class TrainingCamps {
  /// How many camps a host offers. Enough to make it a choice, few enough to
  /// read in one screen.
  static const int count = 4;

  /// The fixed profile of each terrain. Kept here rather than rolled, so the
  /// trade-off a manager learns in one tournament holds in the next.
  static ({double travel, double recovery, int condition}) profileOf(
    CampTerrain terrain,
  ) => switch (terrain) {
    CampTerrain.cityCentre => (travel: 0.88, recovery: 1.0, condition: -1),
    CampTerrain.coastal => (travel: 1.08, recovery: 1.05, condition: 2),
    CampTerrain.mountain => (travel: 1.12, recovery: 1.25, condition: 1),
    CampTerrain.altitude => (travel: 1.05, recovery: 1.0, condition: 3),
    CampTerrain.nationalCentre => (travel: 1.0, recovery: 1.1, condition: 1),
  };

  /// Suffixes that turn a city name into a plausible base-camp name.
  static const _suffixes = <CampTerrain, List<String>>{
    CampTerrain.cityCentre: ['City Campus', 'Riverside Complex'],
    CampTerrain.coastal: ['Bay Resort', 'Coast Retreat'],
    CampTerrain.mountain: ['Valley Lodge', 'Highland Retreat'],
    CampTerrain.altitude: ['Plateau Centre', 'Sierra Camp'],
    CampTerrain.nationalCentre: ['National Centre', 'Federation Campus'],
  };

  /// The camps [hostId] offers, in a stable order.
  ///
  /// [cities] are the host's real cities (biggest first) when the seed data has
  /// them; the names fall back to a generic set otherwise. The first camp is
  /// always the national centre — every federation has one, and a manager who
  /// does not want to think about this should have an obvious answer.
  static List<TrainingCamp> forHost({
    required int hostId,
    List<String>? cities,
  }) {
    final rng = SeededRng((hostId * 0x27D4EB2F) ^ 0xCA11);
    final pool = (cities == null || cities.isEmpty)
        ? const ['Montara', 'Kastel', 'Westport', 'Belgrave', 'Ashford']
        : cities;
    // The national centre first, then three terrains drawn from the rest — the
    // draw is seeded, so a host's list never shuffles between visits.
    final rest = [
      CampTerrain.cityCentre,
      CampTerrain.coastal,
      CampTerrain.mountain,
      CampTerrain.altitude,
    ];
    final chosen = <CampTerrain>[
      CampTerrain.nationalCentre,
      ...rng.shuffled(rest).take(count - 1),
    ];
    return [
      for (var i = 0; i < chosen.length; i++)
        () {
          final terrain = chosen[i];
          final region = pool[(i * 2 + 1) % pool.length];
          final names = _suffixes[terrain]!;
          final p = profileOf(terrain);
          return (
            index: i,
            name: '$region ${names[i % names.length]}',
            region: region,
            terrain: terrain,
            travelFatigue: p.travel,
            injuryRecovery: p.recovery,
            conditionBonus: p.condition,
          );
        }(),
    ];
  }

  /// The camp stored under [index] for [hostId], or the national centre when
  /// nothing has been chosen (or the stored index no longer exists).
  static TrainingCamp resolve({
    required int hostId,
    List<String>? cities,
    int? index,
  }) {
    final camps = forHost(hostId: hostId, cities: cities);
    if (index == null || index < 0 || index >= camps.length) return camps.first;
    return camps[index];
  }
}
