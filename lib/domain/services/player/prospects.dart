import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/manager/staff.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';

/// A young player as the manager sees them: what they are now, what they might
/// become, and how sure anyone is about it.
typedef Prospect = ({
  Player player,

  /// Rating points gained over the last year — a breakout jumps out.
  int yearGain,

  /// International caps won so far. Nought means nobody has really seen him.
  int caps,

  /// The scouting read on his ceiling, 1–5 stars.
  int stars,

  /// Whether that read is the truth. Until a prospect has played, it is an
  /// ESTIMATE and can be a star out either way — which is what makes handing a
  /// teenager his debut a decision rather than a lookup.
  bool certain,
});

/// The under-21 watchlist: who is coming through, and who is worth a cap.
abstract final class Prospects {
  /// The age at which a player leaves the youth pyramid.
  static const int maxAge = 20;

  /// Caps after which the scouting estimate settles into the truth — you have
  /// seen enough of him to know. This is the figure with NOBODY in the scout's
  /// job; [capsToKnowWith] is what a hired one brings it down to.
  static const int capsToKnow = 3;

  /// Caps before the ceiling is known, with [scout] in the job: three with no
  /// scout, two for a basic or good one, one for an elite one.
  static int capsToKnowWith(StaffTier scout) =>
      Staff.capsToKnow(scout, capsToKnow);

  /// The one read every screen shows for a player's ceiling: the truth once
  /// he has [caps] enough for [scout] to know it, the scout's estimate
  /// before that.
  static ({int stars, bool certain}) read(
    int playerId, {
    required int age,
    required int caps,
    StaffTier scout = StaffTier.none,
  }) {
    final certain = caps >= capsToKnowWith(scout);
    return (
      stars: certain
          ? trueStars(playerId, age: age)
          : scoutedStars(playerId, age: age, scout: scout),
      certain: certain,
    );
  }

  /// The nation's under-21s, best prospect first.
  ///
  /// [previousPool] is the same nation a year ago, for the year's gain;
  /// [capsByPlayer] their international appearances; [scout] the tier of the
  /// man reading them, which tightens the estimate and settles it sooner.
  static List<Prospect> watchlist(
    List<Player> pool, {
    List<Player> previousPool = const [],
    Map<int, int> capsByPlayer = const {},
    StaffTier scout = StaffTier.none,
  }) {
    final before = {for (final p in previousPool) p.id: p.overall};
    final out = <Prospect>[];
    for (final p in pool) {
      if (p.age > maxAge) continue;
      final caps = capsByPlayer[p.id] ?? 0;
      final r = read(p.id, age: p.age, caps: caps, scout: scout);
      out.add((
        player: p,
        yearGain: p.overall - (before[p.id] ?? p.overall),
        caps: caps,
        stars: r.stars,
        certain: r.certain,
      ));
    }
    out.sort((a, b) => _rank(b).compareTo(_rank(a)));
    return out;
  }

  /// The honest read on a player's ceiling, 1–5 stars, from the same hidden
  /// potential that decides whether game time turns him into anything.
  /// [age] is how old he is NOW. It matters only for the few who bloom late:
  /// their uplift has not happened yet at thirteen, so reading them then gives
  /// the boy they were always going to be, and the one they turn into shows up
  /// when it actually shows up. Defaults to fully grown, which is what every
  /// caller looking at a senior player means.
  static int trueStars(int playerId, {int age = 99}) {
    final potential = PlayerLifecycle.developmentPotential(
      playerId,
      age: age,
    ); // .35–1.75
    // Bands chosen so five stars is genuinely rare — most players are ordinary.
    //
    // The five-star bar moved from 1.45 to 1.50 when the WONDERKID badge was
    // fixed. At 1.45, roughly one intake child in eleven had a genuine
    // five-star ceiling; at 1.50 it is one in seventeen, which at seven boys a
    // year is one every two or three intakes — a generation, which is what the
    // word is supposed to mean.
    if (potential >= 1.50) return 5;
    if (potential >= 1.2) return 4;
    if (potential >= 0.95) return 3;
    if (potential >= 0.7) return 2;
    return 1;
  }

  /// The scout's read on an unproven player.
  ///
  /// With nobody in the job it is the truth, off by up to a star from
  /// seventeen up and up to TWO below that. A boy under seventeen has played
  /// nothing anyone can judge him on, so the read on him is barely a read at
  /// all — which is what makes bringing him through and finding out the
  /// interesting decision.
  ///
  /// A hired [scout] does two things to it. He never misses by more than a
  /// star, whatever the age. And he reads [Staff.exactReadShare] of players
  /// dead right, the rest being the ordinary ±1 guess. Both are hashed from
  /// the player's id, never rolled, so the read is the same on every screen
  /// and every refresh; and with [StaffTier.none] the arithmetic is exactly
  /// what it always was.
  static int scoutedStars(
    int playerId, {
    int age = 20,
    StaffTier scout = StaffTier.none,
  }) {
    final truth = trueStars(playerId, age: age);
    if (scout != StaffTier.none &&
        _mix(playerId ^ 0x5C0A7) % 100 <
            (Staff.exactReadShare(scout) * 100).round()) {
      return truth;
    }
    final spread = scout == StaffTier.none && age < YouthLevel.u19.minAge
        ? 2
        : 1;
    final wobble = (_mix(playerId ^ 0x5CADE) % (spread * 2 + 1)) - spread;
    return (truth + wobble).clamp(1, 5);
  }

  /// Sort key: promise first, then what he already is, then who is closest to
  /// being ready.
  static double _rank(Prospect p) =>
      p.stars * 12.0 + p.player.overall + p.yearGain * 1.5;

  static int _mix(int x) {
    var h = x & 0x7fffffff;
    h = (h ^ (h >> 16)) * 0x45d9f3b & 0x7fffffff;
    h = (h ^ (h >> 16)) * 0x45d9f3b & 0x7fffffff;
    return (h ^ (h >> 16)) & 0x7fffffff;
  }
}
