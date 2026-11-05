import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';
import 'package:fnm/domain/services/rating/overall_rating.dart';
import 'package:fnm/domain/services/world_pack/active_world.dart';

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
    final target = WorldZone.potentialOf(p.id);
    if (target != null) return _packAged(p, years, target);
    final grown = years <= 0 ? p.age : p.age + years;
    final attrs = years <= 0 ? p.attributes : _age(p.attributes, p.age, grown);
    return p.copyWith(
      age: grown,
      attributes: _superstarLift(
        _youthDiscount(attrs, grown, p.id),
        grown,
        p.id,
      ),
    );
  }

  /// How far short of his edited potential a pack player peaks on the age
  /// curve alone; game time ([PlayerLifecycle.withCareerDev]) is what takes
  /// him the rest of the way. Potential is a ceiling, not a guarantee.
  static const int packShortfall = 2;

  /// [agedYears] for a pack player in a career on a custom world
  /// ([WorldZone]), whose edited [potential] is his peak overall.
  ///
  /// [p] is his base row: the world's day-one player with the plain youth
  /// markdown added back ([packYouthDiscount]). The age curve and the
  /// markdown run as for everybody, but on no 95 clamp and with no wonderkid
  /// relief or superstar lift, so day one is exactly the editor's player. On
  /// top, a steady pull, spread evenly over the years to
  /// [PlayerLifecycle.peakOverallAge], moves his peak from where the curve
  /// alone would leave it to [packShortfall] under his potential (or to his
  /// day-one overall, if that is already there). Past the peak he declines on
  /// the curve from wherever the pull left him. His overall never passes
  /// [potential] (or his day-one overall, if a world set it lower).
  static Player _packAged(Player p, int years, int potential) {
    final from = p.age;
    final to = years <= 0 ? from : from + years;
    PlayerAttributes at(int age, double pull) {
      int one(int base, {required bool physical}) {
        var v = base.toDouble();
        for (var a = from; a < age; a++) {
          v += _yearlyDelta(a, physical: physical);
        }
        return (v - _plainYouthDiscount(age) + pull).round().clamp(
          1,
          PlayerLifecycle.superstarCeiling,
        );
      }

      return PlayerAttributes(
        physical: one(p.attributes.physical, physical: true),
        technical: one(p.attributes.technical, physical: false),
        stamina: one(p.attributes.stamina, physical: true),
      );
    }

    const peak = PlayerLifecycle.peakOverallAge;
    final dayOne = OverallRating.forPosition(p.position, at(from, 0));
    var pull = 0.0;
    if (to > from && from < peak) {
      final natural = OverallRating.forPosition(p.position, at(peak, 0));
      final aim = (potential - packShortfall) < dayOne
          ? dayOne
          : potential - packShortfall;
      pull = (aim - natural) * ((to - from) / (peak - from)).clamp(0.0, 1.0);
    }
    return p.copyWith(
      age: to,
      // Never under his day-one overall: a world whose potential is below
      // it (only an unchecked one) still fields the player it gives.
      attributes: capAt(
        p.position,
        at(to, pull),
        potential < dayOne ? dayOne : potential,
      ),
    );
  }

  /// [a] with every attribute taken down evenly until a [position] player's
  /// overall is no more than [cap] (unchanged when it already is).
  static PlayerAttributes capAt(
    PlayerPosition position,
    PlayerAttributes a,
    int cap,
  ) {
    var out = a;
    for (
      var over = OverallRating.forPosition(position, out) - cap;
      over > 0;
      over = OverallRating.forPosition(position, out) - cap
    ) {
      int down(int v) => (v - over).clamp(1, PlayerLifecycle.superstarCeiling);
      final next = PlayerAttributes(
        physical: down(out.physical),
        technical: down(out.technical),
        stamina: down(out.stamina),
      );
      if (next == out) break;
      out = next;
    }
    return out;
  }

  /// The youth markdown of a pack player of [age]: the plain one, no
  /// wonderkid relief (a custom world has no hidden potential to relieve
  /// it). What a world's day-one rating is marked down by.
  static int packYouthDiscount(int age) => _plainYouthDiscount(age);

  /// How much of the gap to his own level a superstar is carried across.
  ///
  /// Not all of it: pulling every attribute onto the same number would make
  /// every superstar the same footballer. At 0.85 he arrives unmistakably world
  /// class while keeping the shape he was born with — the quick one is still
  /// the quick one.
  static const double superstarBlend = 0.85;

  /// Lifts a superstar to the level he actually plays at (see
  /// [PlayerLifecycle.superstarLevel]). Everyone else passes through untouched.
  ///
  /// Applied AFTER the age curve and the youth discount, so it is the last word
  /// on what he is: the curve still decides the shape of his career, and the
  /// level itself falls away in his mid-thirties.
  static PlayerAttributes _superstarLift(
    PlayerAttributes a,
    int age,
    int playerId,
  ) {
    if (!PlayerLifecycle.isSuperstar(playerId)) return a;
    final level = PlayerLifecycle.superstarLevel(playerId, age);
    int up(int v) => v >= level
        ? v
        : (v + (level - v) * superstarBlend).round().clamp(
            20,
            PlayerLifecycle.superstarCeiling,
          );
    return a.copyWith(
      physical: up(a.physical),
      technical: up(a.technical),
      stamina: up(a.stamina),
    );
  }

  /// The age at and below which a player is still visibly raw.
  static const int youthCeiling = 22;

  /// The markdown applied at eighteen. Younger players are marked down harder
  /// still — see the bands in [_plainYouthDiscount].
  static const int maxYouthDiscount = 9;

  /// A player is not the finished article at twenty.
  ///
  /// The curve above already had them improving quickly, but they arrived good
  /// enough that the improvement barely mattered: a nineteen-year-old walked
  /// into most sides and there was nothing to develop him for. Marking the
  /// young down — hardest at eighteen, gone by twenty-three — leaves real room
  /// to grow into, so blooding a teenager is a bet on what he becomes rather
  /// than a free upgrade.
  ///
  /// The exception is the wonderkid: a player in the very top tail of hidden
  /// potential is spared most of the discount and really is ready at nineteen.
  /// Deliberately rare (a few per cent of any intake), so finding one is an
  /// event.
  static PlayerAttributes _youthDiscount(
    PlayerAttributes a,
    int age,
    int playerId,
  ) {
    final discount = youthDiscountOf(playerId, age);
    if (discount == 0) return a;
    int down(int v) => (v - discount).clamp(20, 95);
    return a.copyWith(
      physical: down(a.physical),
      technical: down(a.technical),
      stamina: down(a.stamina),
    );
  }

  /// The markdown [_youthDiscount] takes off each of [playerId]'s attributes
  /// at [age], his wonderkid relief included; nought from twenty-three on.
  ///
  /// Public so a stored rating that is already marked down (a custom world's
  /// day-one squad) can be turned back into the base row the curve reads.
  static int youthDiscountOf(int playerId, int age) {
    final base = _plainYouthDiscount(age);
    if (base == 0) return 0;
    if (WorldZone.potentialOf(playerId) != null) return base;
    // Relief only in the top tail of the potential draw (~1.55 of a 0.35–1.75
    // range), rising to a full exemption at the very top.
    final potential = PlayerLifecycle.developmentPotential(playerId);
    final relief = ((potential - 1.55) / 0.20).clamp(0.0, 1.0);
    return (base * (1 - relief)).round();
  }

  static PlayerAttributes _age(PlayerAttributes a, int from, int to) =>
      PlayerAttributes(
        physical: _grow(a.physical, from, to, physical: true),
        technical: _grow(a.technical, from, to, physical: false),
        stamina: _grow(a.stamina, from, to, physical: true),
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
  ///
  /// The rise is deliberately slower than the fall. A prospect used to add the
  /// better part of ten points between eighteen and twenty-three, so one cycle
  /// away from the squad turned a raw teenager into a finished international
  /// and the manager never had to decide when to blood him — he simply arrived
  /// ready. Growth now takes most of a decade, which is what makes bringing a
  /// young player through a choice: he costs you results while he learns.
  /// How far a player of [age] is from his own peak, in overall points, on the
  /// curve above — the PREDICTABLE part of a rating, which every player of that
  /// age carries whatever else he is.
  ///
  /// Positive at every age but the peak: a teenager is that far short of what
  /// he will be, a veteran that far past it. Subtracting it from a live overall
  /// leaves the part that is actually about the footballer, which is what a
  /// club has to be picked off — see [ClubService.clubLevel]. Reading the
  /// figure off [_yearlyDelta] and [_youthDiscount] rather than restating it
  /// keeps the two from drifting the day the curve is retuned.
  static double peakOffset(int age) {
    // The overall is a position-weighted blend of the three attributes, two of
    // which move on the physical curve; a plain mean of the three is close
    // enough for a club pick and needs no position.
    double mean(int a) =>
        (_yearlyDelta(a, physical: true) * 2 +
            _yearlyDelta(a, physical: false)) /
        3;
    var gap = 0.0;
    if (age < peakAge) {
      for (var a = age; a < peakAge; a++) {
        gap += mean(a);
      }
    } else {
      for (var a = peakAge; a < age; a++) {
        gap -= mean(a);
      }
    }
    // The youth markdown comes off as he grows up, so it is part of the gap
    // between a boy and the player he becomes. The wonderkid's relief is left
    // out on purpose: he really IS ahead of his age group, and a club should
    // see that.
    return gap + _plainYouthDiscount(age);
  }

  /// How much [playerId]'s overall is EXPECTED to change between ages [from]
  /// and [to]: the curve, his own youth markdown (a wonderkid's relief
  /// included). The predictable part of HIS career, where [peakOffset] is
  /// everybody's. A superstar's climb is his own level instead (see
  /// [PlayerLifecycle.superstarLevel]).
  ///
  /// A club deal is decided off the player he was when he signed it (see
  /// `ClubService.clubForSeed`); without this a superstar, who climbs six or
  /// seven points a season in his late teens, changed club every year.
  static double expectedGain(int playerId, int from, int to) {
    if (to == from) return 0;
    double mean(int a) =>
        (_yearlyDelta(a, physical: true) * 2 +
            _yearlyDelta(a, physical: false)) /
        3;
    var curve = 0.0;
    for (var a = from; a < to; a++) {
      curve += mean(a);
    }
    for (var a = to; a < from; a++) {
      curve -= mean(a);
    }
    final potential = WorldZone.potentialOf(playerId);
    if (potential != null) {
      return curve +
          _plainYouthDiscount(from) -
          _plainYouthDiscount(to) +
          _packPullBetween(playerId, potential, from, to);
    }
    final relief =
        ((PlayerLifecycle.developmentPotential(playerId) - 1.55) / 0.20).clamp(
          0.0,
          1.0,
        );
    double markdown(int age) => _plainYouthDiscount(age) * (1 - relief);
    return curve + markdown(from) - markdown(to);
  }

  /// The share of [_packAged]'s pull a pack player takes between ages [from]
  /// and [to], estimated on the position-free mean curve [expectedGain]
  /// reads; nought when his day one is not known.
  static double _packPullBetween(
    int playerId,
    int potential,
    int from,
    int to,
  ) {
    final dayOne = WorldZone.dayOneOf(playerId);
    const peak = PlayerLifecycle.peakOverallAge;
    if (dayOne == null || dayOne.age >= peak) return 0;
    var natural = dayOne.overall + _plainYouthDiscount(dayOne.age).toDouble();
    for (var a = dayOne.age; a < peak; a++) {
      natural +=
          (_yearlyDelta(a, physical: true) * 2 +
              _yearlyDelta(a, physical: false)) /
          3;
    }
    final aim = (potential - packShortfall) < dayOne.overall
        ? dayOne.overall
        : potential - packShortfall;
    double frac(int age) =>
        ((age - dayOne.age) / (peak - dayOne.age)).clamp(0.0, 1.0);
    return (aim - natural) * (frac(to) - frac(from));
  }

  /// The age the curve tops out at — where [peakOffset] is nought.
  static const int peakAge = 28;

  /// [_youthDiscount]'s markdown at an age, before any wonderkid relief.
  /// The markdown sheds EVENLY, about two points a season from seventeen. It
  /// used to go 9, 7, 6, 5 across the four teenage years — a flat spot right
  /// where the U-19s and the U-21s are compared, so two years of development
  /// separated the bands by barely two rating points and the seven boys in an
  /// intake are noisier than that. A nation's U-19s therefore read as good as
  /// its U-21s about one save in six, which is not a golden generation, it is
  /// the ramp. Evened out, a year older is a year better and the pyramid reads
  /// like one.
  static int _plainYouthDiscount(int age) => switch (age) {
    <= 12 => 24,
    13 => 21,
    14 => 18,
    15 => 15,
    16 => 13,
    17 => 11,
    18 => maxYouthDiscount,
    19 => 6,
    20 => 4,
    21 => 3,
    22 => 1,
    _ => 0,
  };

  static double _yearlyDelta(int age, {required bool physical}) {
    // A child grows into an athlete far faster than a young man improves as a
    // footballer. Without these bands an eleven-year-old would arrive at
    // seventeen barely changed, and the whole point of the pyramid — watching
    // him become a player — would be a list of static numbers.
    if (age < 15) return physical ? 2.6 : 2.2;
    if (age < 17) return physical ? 1.8 : 1.5;
    if (age < 21) return physical ? 1.0 : 0.85; // early development
    if (age < 24) return physical ? 0.7 : 0.65;
    if (age < 28) return physical ? 0.15 : 0.35; // peak / experience gains
    if (age < 31) return physical ? -1.1 : 0.1; // physical starts to go
    if (age < 34) return physical ? -2.4 : -0.7;
    return physical ? -3.4 : -1.6; // veteran decline
  }
}
