import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/competition/venues.dart';
import 'package:fnm/domain/services/match/venue.dart' show isShowpieceRound;

/// Where a match is played and how many turned up.
typedef MatchGround = ({
  String stadium,
  String city,

  /// The nation whose ground it is — the tournament host at a finals, the home
  /// side otherwise. Its flag identifies the ground.
  int groundNationId,
  int capacity,
  int attendance,
  bool soldOut,
});

/// The ground a fixture is played at, and its crowd.
///
/// Every match now has somewhere to be played: a finals tie is at one of the
/// tournament host's stadiums, everything else at the home nation's biggest
/// ground. Attendance follows from the occasion — a World Cup final fills the
/// place, a friendly does not — so the crowd figure says something about the
/// match rather than being decoration.
///
/// Deterministic in the fixture id, so the same match always reads the same.
abstract final class Attendance {
  /// How full the ground gets before the occasion is taken into account.
  static const double _floor = 0.35;

  /// Picks the ground and computes the crowd. [neutral] and [tournamentHostIds]
  /// come from `venueForFixture`; [citiesByNation] from the seed data (biggest
  /// first). [homeStrength] and [awayStrength] are the two sides' ratings — a
  /// glamour opponent sells the last seats.
  static MatchGround forFixture({
    required Fixture fixture,
    required bool neutral,
    required Map<int, List<String>> citiesByNation,
    required int seed,
    List<int> tournamentHostIds = const [],
    int homeStrength = 70,
    int awayStrength = 70,
  }) {
    // Whose ground: at a neutral finals it belongs to the TOURNAMENT — one of
    // the host countries, whoever is playing — and everywhere else to the home
    // side. It used to fall back to the listed home nation whenever the host
    // wasn't one of the two teams, which put every knockout tie (the final
    // included) in a finalist's own country instead of the host's.
    final owner = neutral
        ? _neutralGroundOwner(fixture, tournamentHostIds, seed)
        : fixture.homeNationId;

    final venues = VenueGenerator.forHost(
      hostId: owner,
      cities: citiesByNation[owner],
      count: 8,
    );
    final venue = venues.isEmpty
        ? (city: '—', stadium: 'National Stadium', capacity: 42000)
        // The showpiece (the final and the third-place match) is played at the
        // tournament's marquee ground — the primary host's biggest stadium —
        // rather than wherever the shuffle lands.
        : neutral && isShowpieceRound(fixture.round)
        ? venues.first
        // The rest of a finals moves around the host's grounds; a home
        // qualifier is played at the national stadium, the biggest one.
        : neutral
        ? venues[_mix(fixture.id ^ seed) % venues.length]
        : venues.first;

    final fill = _fill(
      round: fixture.round,
      homeStrength: homeStrength,
      awayStrength: awayStrength,
      wobble: (_mix(fixture.id * 31 ^ seed) % 61) / 1000 - 0.03, // ±3%
    );
    final attendance = (venue.capacity * fill).round().clamp(
      1000,
      venue.capacity,
    );
    return (
      stadium: venue.stadium,
      city: venue.city,
      groundNationId: owner,
      capacity: venue.capacity,
      attendance: attendance,
      // Not literally every seat — a "sell-out" is the ground as full as it
      // realistically gets.
      soldOut: attendance >= (venue.capacity * 0.985).round(),
    );
  }

  /// How full the ground gets, 0..1.
  static double _fill({
    required String? round,
    required int homeStrength,
    required int awayStrength,
    required double wobble,
  }) {
    // The occasion is most of it: a final sells out, a friendly half-fills.
    final base = switch (round) {
      'FINAL' || 'CFINAL' => 1.0,
      '3RD' || 'C3RD' => 0.9,
      'SF' || 'CSF' || 'QF' || 'CQF' => 0.97,
      'R32' || 'R16' || 'CR16' => 0.93,
      'GROUP' || 'CGROUP' => 0.88,
      'NFINAL' || 'NSF' => 0.86,
      'FRIENDLY' => 0.62,
      'NGROUP' => 0.76,
      _ => 0.8, // qualifying, home and away
    };
    // A glamour tie fills the last seats; two poor sides do not.
    final quality = ((homeStrength + awayStrength) / 2 - 70) / 100;
    return (base + quality + wobble).clamp(_floor, 1.0);
  }

  /// How much of the home advantage the crowd is actually worth: a packed,
  /// hostile ground is worth more than a half-empty one. Centred on 1.0 at a
  /// well-filled ground so the engine's baseline is unchanged for a normal
  /// match.
  static double atmosphere(MatchGround ground) {
    if (ground.capacity <= 0) return 1;
    final fill = ground.attendance / ground.capacity;
    return (0.7 + 0.4 * fill).clamp(0.7, 1.15);
  }

  /// Which host country a neutral finals tie is played in.
  ///
  /// A joint candidature splits the tournament between its members, so the tie
  /// is assigned to one of them deterministically; the showpiece always belongs
  /// to the primary host (handled by the caller). The listed home nation is a
  /// last resort only when the hosts are unknown, so a stadium name can always
  /// be shown.
  static int _neutralGroundOwner(
    Fixture fixture,
    List<int> tournamentHostIds,
    int seed,
  ) {
    if (tournamentHostIds.isEmpty) return fixture.homeNationId;
    if (tournamentHostIds.length == 1) return tournamentHostIds.first;
    if (isShowpieceRound(fixture.round)) return tournamentHostIds.first;
    return tournamentHostIds[_mix(fixture.id ^ seed ^ 0x51A0) %
        tournamentHostIds.length];
  }

  static int _mix(int x) {
    var h = x & 0x7fffffff;
    h = (h ^ (h >> 16)) * 0x45d9f3b & 0x7fffffff;
    h = (h ^ (h >> 16)) * 0x45d9f3b & 0x7fffffff;
    return (h ^ (h >> 16)) & 0x7fffffff;
  }
}
