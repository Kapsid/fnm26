import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/competition/rounds.dart';
import 'package:fnm/domain/services/competition/venues.dart';
import 'package:fnm/domain/services/match/match_conditions.dart';

/// Which of a nation's grounds one of its home games (not a neutral finals)
/// is played in.
///
/// A national team does not play every home game in one stadium: the big
/// nights go to the national stadium, the rest move around the country's
/// biggest grounds, and a friendly can go further afield. The rules:
///
/// - `override` wins outright: the seam a future "the manager picks the
///   ground" choice goes through. Nothing sets it today.
/// - A nation with one ground plays there.
/// - A nation that plays up in the mountains (its
///   `MatchClimate.acclimatisedAltitude` at or above
///   `MatchClimate.altitudeFloor`: Ecuador in Quito, Colombia in Bogotá,
///   Bolivia in La Paz, Ethiopia, Mexico) ALWAYS plays at `national`: the
///   thin air is its edge.
/// - A big match (`bigMatch`, see [HomeGround.isBigMatch]: a knockout leg,
///   or a visitor ranked in the top 20) is at `national`.
/// - A competitive home game (qualifier, Nations Cup) rotates among the 3
///   biggest grounds ([HomeGround.competitivePool]), `national` always among
///   them and weighted 2 to 1 ([HomeGround.nationalWeight]), so with three
///   grounds it hosts half.
/// - A friendly rotates among the 5 biggest ([HomeGround.friendlyPool]),
///   `national` no more often than any other.
/// - A rotation never takes a side up to a ground higher than its home city
///   (Peru never leaves sea level for Cusco): the climate a nation is used to
///   stays what it plays in.
///
/// `candidates` are biggest first; `national` is one of them (the home
/// city's ground, or the biggest once a manager's estate has been worked
/// on: see `nationalGroundOf`). Deterministic in the fixture id and `seed`
/// alone, so the shown match and a skipped one always agree, and nothing is
/// stored.
abstract final class HomeGround {
  /// How many of the biggest grounds a competitive home game rotates over.
  static const int competitivePool = 3;

  /// How many of the biggest grounds a friendly rotates over.
  static const int friendlyPool = 5;

  /// How many shares of a competitive rotation the national ground gets,
  /// against one for each other ground.
  static const int nationalWeight = 2;

  /// A visitor ranked this high or higher is a big match.
  static const int bigOpponentRanking = 20;

  /// Whether a home game is the national stadium's: a knockout leg (a
  /// play-off, a Nations Cup knockout) or a visitor in the world's top
  /// [bigOpponentRanking] ([awayRanking] is its `Nation.ranking`; null when
  /// unknown). A friendly is never one.
  static bool isBigMatch({required Fixture fixture, int? awayRanking}) {
    if (fixture.round == Rounds.friendly) return false;
    if (Rounds.isKnockout(fixture.round)) return true;
    return awayRanking != null &&
        awayRanking > 0 &&
        awayRanking <= bigOpponentRanking;
  }

  /// The ground; null only when [candidates] is empty and no [override].
  static Venue? pick({
    required List<Venue> candidates,
    required Venue national,
    required Fixture fixture,
    required int seed,
    required bool bigMatch,
    Venue? override,
  }) {
    if (override != null) return override;
    if (candidates.isEmpty) return null;
    if (candidates.length == 1) return candidates.first;
    final nation = fixture.homeNationId;
    final usedTo = MatchClimate.acclimatisedAltitude(nation);
    if (usedTo >= MatchClimate.altitudeFloor || bigMatch) return national;

    final friendly = fixture.round == Rounds.friendly;
    final size = friendly ? friendlyPool : competitivePool;
    final pool = <Venue>[national];
    for (final v in candidates) {
      if (pool.length >= size) break;
      if (v == national) continue;
      if (MatchClimate.altitudeOf(nation, v.city) > usedTo) continue;
      pool.add(v);
    }
    final shares = [
      for (var i = 0; i < (friendly ? 1 : nationalWeight); i++) national,
      ...pool.skip(1),
    ];
    return shares[_mix(fixture.id * 0x2545F491 ^ seed ^ 0x40E6) %
        shares.length];
  }

  static int _mix(int x) {
    var h = x & 0x7fffffff;
    h = (h ^ (h >> 16)) * 0x45d9f3b & 0x7fffffff;
    h = (h ^ (h >> 16)) * 0x45d9f3b & 0x7fffffff;
    return (h ^ (h >> 16)) & 0x7fffffff;
  }
}

/// See [HomeGround.pick]: the one function every home game's ground goes
/// through, so a later manager's choice ([override]) can bypass it.
Venue? homeGroundFor({
  required List<Venue> candidates,
  required Venue national,
  required Fixture fixture,
  required int seed,
  int? awayRanking,
  Venue? override,
}) => HomeGround.pick(
  candidates: candidates,
  national: national,
  fixture: fixture,
  seed: seed,
  bigMatch: HomeGround.isBigMatch(fixture: fixture, awayRanking: awayRanking),
  override: override,
);
