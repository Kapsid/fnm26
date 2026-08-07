import 'package:fnm/domain/services/club/clubs.dart';

/// Where a player stands at his club right now.
enum ClubStanding {
  /// Plays every week.
  firstChoice,

  /// In and out of the side.
  rotation,

  /// Occasional minutes off the bench.
  fringe,

  /// Not being picked at all.
  frozenOut,
}

/// A player's situation at the club this game does not simulate.
///
/// The defining constraint of international management: a manager's players
/// spend almost all of their lives somewhere he does not control, and turn up
/// sharp, rusty or barely playing. Derived — like everything else about a
/// player — from his id, his rating against his club's level, his age, the save
/// seed and the window, so nothing is stored and two saves agree.
abstract final class ClubForm {
  /// The months the international windows fall in.
  static const List<int> windowMonths = [3, 6, 9, 10, 11];

  /// A monotonic index that advances once per international window, so a
  /// standing holds for a camp and then is redrawn.
  static int windowIndexFor(DateTime date) {
    var opened = 0;
    for (final m in windowMonths) {
      if (date.month >= m) opened++;
    }
    return date.year * (windowMonths.length + 1) + opened;
  }

  /// Where [playerId] stands at his club this window.
  ///
  /// Three things decide it: how far his rating sits above the floor of his
  /// club's tier (a star at a modest club is never dropped, a squad man at an
  /// elite one swings), his age at both ends, and a per-window draw that is
  /// what makes a career have spells in and out of the side.
  static ClubStanding standingFor({
    required int playerId,
    required int overall,
    required int age,
    required int saveSeed,
    required int windowIndex,
  }) {
    // 0 … 1: where he sits inside his own league's band.
    final tier = ClubService.tierForOverall(overall);
    final floor = _tierFloor(tier);
    final ceiling = _tierCeiling(tier);
    final within = ((overall - floor) / (ceiling - floor)).clamp(0.0, 1.0);

    // Standing before the draw, on the same 0…1 scale. The young and the old
    // are squeezed: a teenager is behind established men, a veteran is being
    // phased out.
    var score = within;
    if (age <= 20) {
      score -= 0.45;
    } else if (age <= 22) {
      score -= 0.20;
    } else if (age >= 35) {
      score -= 0.30;
    } else if (age >= 33) {
      score -= 0.12;
    }

    // The window's own draw, ±0.30, so the same player moves over a career.
    final h = _mix(playerId ^ (saveSeed * 0x9E3779B1) ^ (windowIndex * 0x85EB));
    final swing = (h % 61) / 100.0 - 0.30;
    final total = score + swing;

    if (total >= 0.55) return ClubStanding.firstChoice;
    if (total >= 0.20) return ClubStanding.rotation;
    if (total >= -0.15) return ClubStanding.fringe;
    return ClubStanding.frozenOut;
  }

  /// What a standing does to a player's sharpness in the next match.
  ///
  /// Bounded on purpose: a frozen-out star may still be the right pick, and
  /// finding that out is the game. [Condition] clamps the combined delta too.
  static int sharpnessDelta(ClubStanding s) => switch (s) {
        ClubStanding.firstChoice => 1,
        ClubStanding.rotation => 0,
        ClubStanding.fringe => -2,
        ClubStanding.frozenOut => -5,
      };

  /// Roughly what share of his club's minutes a standing is worth.
  static double minutesShare(ClubStanding s) => switch (s) {
        ClubStanding.firstChoice => 0.90,
        ClubStanding.rotation => 0.55,
        ClubStanding.fringe => 0.20,
        ClubStanding.frozenOut => 0.0,
      };

  /// The population's mean [minutesShare]. The development factor is centred
  /// on this so the world's average development does not move — see the guard
  /// test.
  ///
  /// MEASURED, not assumed: sampled across the rating and age range the guard
  /// test walks. The obvious-looking 0.5 is wrong — the standing bands are not
  /// symmetric, and centring on it lifted average development by 6%, which
  /// over a career is every nation in the world quietly getting better.
  static const double meanMinutesShare = 0.578;

  /// How much a year's minutes multiply the career-development bump.
  ///
  /// Reads the YEAR, not the window: standing churns every camp, and a player
  /// should not be rewarded or punished for the timing of one draw. Centred on
  /// 1.0 across the population, because the senior pool's equilibrium depends
  /// on average development being unchanged.
  static double yearMinutesFactor({
    required int playerId,
    required int overall,
    required int age,
    required int saveSeed,
    required int year,
  }) {
    final base = year * (windowMonths.length + 1);
    var shares = 0.0;
    for (var i = 0; i < windowMonths.length; i++) {
      shares += minutesShare(
        standingFor(
          playerId: playerId,
          overall: overall,
          age: age,
          saveSeed: saveSeed,
          windowIndex: base + i,
        ),
      );
    }
    final avg = shares / windowMonths.length;
    return (1 + (avg - meanMinutesShare) * 0.8).clamp(0.6, 1.4);
  }

  static int _tierFloor(int tier) => switch (tier) {
        1 => 84,
        2 => 78,
        3 => 72,
        4 => 66,
        _ => 40,
      };

  static int _tierCeiling(int tier) => switch (tier) {
        1 => 95,
        2 => 84,
        3 => 78,
        4 => 72,
        _ => 66,
      };

  static int _mix(int x) {
    var h = x & 0x7fffffff;
    h = (h ^ (h >> 16)) * 0x45d9f3b & 0x7fffffff;
    h = (h ^ (h >> 16)) * 0x45d9f3b & 0x7fffffff;
    return (h ^ (h >> 16)) & 0x7fffffff;
  }
}
