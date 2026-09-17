import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';

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
    final base = _plainYouthDiscount(age);
    if (base == 0) return a;
    // Relief only in the top tail of the potential draw (~1.55 of a 0.35–1.75
    // range), rising to a full exemption at the very top.
    final potential = PlayerLifecycle.developmentPotential(playerId);
    final relief = ((potential - 1.55) / 0.20).clamp(0.0, 1.0);
    final discount = (base * (1 - relief)).round();
    if (discount == 0) return a;
    int down(int v) => (v - discount).clamp(20, 95);
    return a.copyWith(
      physical: down(a.physical),
      technical: down(a.technical),
      stamina: down(a.stamina),
    );
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
