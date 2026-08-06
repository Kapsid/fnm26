import 'dart:math';

import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/club/clubs.dart';
import 'package:fnm/domain/services/player/depth_chart.dart';
import 'package:fnm/domain/services/player/player_aging.dart';

/// Keeps a nation's player pool alive across an endless run of seasons. Like
/// [PlayerAging], this is a *pure, derived* layer — nothing is stored per save.
/// Given a nation's base (year-0) seeded players and how many years have
/// elapsed, it returns the pool as it stands now: veterans who have aged past
/// [retirementAge] are dropped, and every intake year's newly-generated
/// eleven-year-olds ("newgens") are added, aged from the year they came in.
/// Roughly [releasedPercent] of each intake is released before seventeen and
/// never reaches the senior pool.
///
/// Because it is derived from `(nationId, intakeYear, playerId)` only — never
/// the save's random seed — two saves at the same year see the same squads and
/// the same youth pyramid, as aging already behaves.
abstract final class PlayerLifecycle {
  /// The age around which players retire from international football. An
  /// individual's own age varies either side of it — see [retirementAgeFor].
  static const retirementAge = 37;

  /// How far either side of [retirementAge] a career can run, in years.
  static const retirementSpread = 3;

  /// The age [playerId] retires from internationals.
  ///
  /// A single hard cut-off made every squad turn over the same way: the manager
  /// learned that thirty-seven was the wall and planned around it, and no
  /// veteran was ever a question. Careers now end anywhere from
  /// [retirementAge] − [retirementSpread] to [retirementAge] +
  /// [retirementSpread], so one thirty-five-year-old is finished while another
  /// is still first choice at thirty-nine, and the manager has to read the
  /// player rather than the calendar.
  ///
  /// The spread is deliberately SYMMETRIC and derived from the id alone: pool
  /// turnover has to stay balanced against [intakePerYear] (or squads slowly
  /// grow or shrink), and — like everything else here — two saves at the same
  /// cycle must see the same squads.
  static int retirementAgeFor(int playerId) {
    // A distinct bit window from `developmentPotential`, so how good a player
    // was going to be says nothing about how long they last.
    final h = (_mix(playerId ^ 0x5EA50E) >> 7) & 0xffff;
    // Weighted toward the middle: most careers end near the norm, and the very
    // short and very long ones are the exceptions worth noticing.
    const offsets = [-3, -2, -2, -1, -1, -1, 0, 0, 0, 0, 1, 1, 1, 2, 2, 3];
    return retirementAge + offsets[h % offsets.length];
  }

  /// The age a player enters the world. Nobody is ever created older than this
  /// — a seventeen-year-old in this game was an eleven-year-old six years ago,
  /// and the manager could have watched him the whole way.
  static const int intakeAge = 11;

  /// Boys a nation takes in each year. Sized against the senior pool's
  /// equilibrium: seven a year at [releasedPercent] attrition is the ~5.5 a
  /// year that reach seventeen, which is exactly what the old
  /// twenty-two-per-four-years produced.
  static const int intakePerYear = 7;

  /// How many intake years before the save opens are generated, so ages 11–17
  /// are already there on day one and the ladder is continuous up to the
  /// youngest seeded player (18).
  static const int backfillYears = 6;

  /// Roughly what share of an intake is released before reaching seventeen.
  static const int releasedPercent = 21;

  /// The offset that keeps the backfilled (negative) intake years positive in
  /// the encoded id.
  static const int _bornYearOffset = 8;

  /// The age [playerId] is released, or null if he comes through.
  ///
  /// Its own bit window, distinct from [developmentPotential] and
  /// [retirementAgeFor]: how good a boy was going to be must not decide whether
  /// he is let go, or the pyramid would quietly be a ranked queue with the
  /// bottom lopped off instead of a set of careers.
  static int? releasedAgeFor(int playerId) {
    final h = (_mix(playerId ^ 0x2E1EA5E) >> 5) & 0xffffff;
    if (h % 100 >= releasedPercent) return null;
    return 12 + (h ~/ 100) % 5; // 12 … 16
  }

  /// Whether [playerId] has already been released by [age].
  static bool isReleasedBy(int playerId, int age) {
    final at = releasedAgeFor(playerId);
    return at != null && age >= at;
  }

  // Newgen ids live far above the seeded id space (real players ≤ ~21k, seed
  // fringe from 10_000_000). The id encodes nation/cycle/slot so a single id
  // round-trips back to the newgen that owns it, no lookup table needed.
  static const int _idBase = 1000000000;
  static const int _nationStride = 1000000;
  static const int _cycleStride = 1000;

  /// Whether [id] belongs to a generated newgen rather than a seeded player.
  static bool isNewgenId(int id) => id >= _idBase;

  /// The nation a newgen [id] belongs to (undefined for non-newgen ids).
  static int nationIdOf(int id) => (id - _idBase) ~/ _nationStride;

  /// A stable per-nation sequence number for a newgen [id] across all intake
  /// years and slots, so every generated player gets a distinct name.
  static int newgenSequence(int id) {
    final within = (id - _idBase) % _nationStride;
    final bornYearIndex = within ~/ _cycleStride;
    final slot = within % _cycleStride;
    return bornYearIndex * intakePerYear + slot;
  }

  /// A nation's pool as it stands [agingYears] years into the save: seeded
  /// players aged and de-retired, plus every intake year's newgens aged from
  /// the year they came in at [intakeAge] — including the [backfillYears]
  /// intakes from before the save opened, so the ladder is unbroken from eleven
  /// up to the youngest seeded player on day one. Not sorted.
  ///
  /// [minAge] drops anyone younger than it, so a caller that only wants the
  /// senior pool never sees the schoolboys underneath it. Seventeen by
  /// default, which is what the world simulation, AI squad selection, the
  /// rankings and every existing caller want: the U-17 band is ~13 extra
  /// players per nation, aged year-by-year on every sim step, for players who
  /// would essentially never be picked. Only the player's own call-up path
  /// asks for 15.
  ///
  /// [youthBonusByCycle] optionally boosts an intake's talent for the four-year
  /// cycle it came in at (a federation's youth-academy investment). It only
  /// shifts attribute magnitudes — it is applied after the RNG draw, so ids,
  /// names and positions are unchanged and the pool stays deterministic per
  /// stored input.
  static List<Player> poolAt(
    List<Player> seeded,
    int nationId,
    int agingYears, {
    int minAge = 17,
    Map<int, double> youthBonusByCycle = const {},
    Map<int, int> careerStartsByPlayer = const {},
  }) {
    // International retirements happen as a WAVE after a tournament, not at some
    // arbitrary off-season boundary. A major tournament falls on every even
    // aging-year (a continental cup or a World Cup every two years), so a
    // player's retirement is judged as of the most recent tournament they have
    // already played — [retireAging] freezes it there, keeping a 37-year-old in
    // the pool through the current cup and letting the whole wave drop together
    // the year after. Development still uses the live [agingYears]. Because the
    // yearly squad-report diffs this pool, the retirement NEWS lands in that
    // same post-tournament window automatically, so the inbox and the squad
    // always agree.
    final retireAging = agingYears < 2 ? 0 : 2 * ((agingYears - 1) ~/ 2);
    // A player's age at that frozen tournament year (`aged.age` is their live
    // developed age; back out the extra live years, add the frozen ones).
    bool retired(Player aged) =>
        aged.age - agingYears + retireAging >= retirementAgeFor(aged.id);

    final out = <Player>[];
    for (final p in seeded) {
      final aged = PlayerAging.agedYears(p, agingYears);
      if (aged.age < minAge) continue;
      if (!retired(aged)) {
        out.add(withCareerDev(aged, careerStartsByPlayer[aged.id] ?? 0));
      }
    }
    // Every intake year that has happened, including the ones backfilled from
    // before the save opened.
    for (var year = -backfillYears; year <= agingYears; year++) {
      final bonus = youthBonusByCycle[_cycleOfIntake(year)] ?? 0.0;
      for (final g in _intake(seeded, nationId, year, youthBonus: bonus)) {
        final aged = PlayerAging.agedYears(g, agingYears - year);
        if (aged.age < minAge) continue;
        if (isReleasedBy(aged.id, aged.age)) continue;
        if (retired(aged)) continue;
        out.add(withCareerDev(aged, careerStartsByPlayer[aged.id] ?? 0));
      }
    }
    return out;
  }

  /// A nation's whole youth pyramid — ages 11 to 20 — for one nation, on
  /// demand. The Youth screen is the only caller; the hot path never builds
  /// this.
  static List<Player> youthPoolAt(
    List<Player> seeded,
    int nationId,
    int agingYears, {
    Map<int, double> youthBonusByCycle = const {},
    Map<int, int> careerStartsByPlayer = const {},
  }) =>
      poolAt(
        seeded,
        nationId,
        agingYears,
        youthBonusByCycle: youthBonusByCycle,
        careerStartsByPlayer: careerStartsByPlayer,
        minAge: intakeAge,
      ).where((p) => p.age <= YouthLevel.u21.maxAge).toList();

  /// The four-year cycle an intake year belongs to, for the academy bonus.
  /// Backfilled years are before the save and take no investment.
  static int _cycleOfIntake(int intakeYear) =>
      intakeYear < 0 ? -1 : intakeYear ~/ 4;

  /// The career-development bump: a player who has started many tournament
  /// matches grows, faster if they play in a strong club league AND have the
  /// hidden ceiling to kick on (see [developmentPotential]). A small, capped,
  /// deterministic uplift to every attribute — applied AFTER aging, so
  /// ids/names/positions and the pool are unchanged. No [starts] (or an
  /// opponent, who is passed none) leaves the player exactly as aged.
  ///
  /// Potential is what turns game time into a gamble worth caring about: two
  /// prospects who debut alike diverge as they play — a gem kicks on toward
  /// stardom, a bust plateaus however many caps you give them.
  static Player withCareerDev(Player aged, int starts) {
    if (starts <= 0) return aged;
    // Weight by the club-league tier the player's (pre-bump) overall implies,
    // so a top-flight regular improves faster than a lower-league one.
    final tier = ClubService.tierForOverall(aged.overall);
    final tierWeight = (6 - tier) / 5.0; // tier 1 → 1.0 … tier 5 … → 0.2
    // Game time is a slow burn on top of the age curve, not a second one
    // running alongside it. At the old rate a regular picked up the cap in a
    // single cycle and the two effects compounded into squads that improved
    // faster than they could possibly age out.
    final delta =
        (sqrt(starts) * 0.30 * tierWeight * developmentPotential(aged.id))
            .clamp(0.0, 3.0)
            .round();
    if (delta == 0) return aged;
    return aged.copyWith(attributes: _bumpAll(aged.attributes, delta));
  }

  /// The talent shift a nation's youth intake inherits from where the senior
  /// side is heading, given how many ranking places it [climbed] over the cycle
  /// just finished (negative = slid down).
  ///
  /// A rising national team is a magnet: the best kids in the country pick
  /// football over other sports, the good ones get taken seriously by bigger
  /// clubs, and the next generation arrives better than the last. A side falling
  /// out of the reckoning loses that pull. Sized to be a real but gradual tilt
  /// (±0.10 of talent scale, roughly ±7 overall at the extremes), so it takes a
  /// sustained rise or slump to reshape a nation — one good cycle doesn't.
  static double rankTrendTalentBonus(int climbed) =>
      (climbed / 30 * 0.06).clamp(-0.10, 0.10);

  /// A player's hidden development potential as a growth multiplier, derived
  /// deterministically from their [id] alone (so it's stable across saves, like
  /// the rest of the derived pool). Triangular around ~1.05 — most players are
  /// ordinary, with rare wonderkids (~1.75×) and busts (~0.35×) at the tails.
  static double developmentPotential(int id) {
    final h = _mix(id);
    // Two sub-draws averaged → a triangular distribution centred on 0.5, so the
    // extremes (a true gem, a total flop) are uncommon rather than uniform.
    final a = (h & 0x3ff) / 1024.0;
    final b = ((h >> 10) & 0x3ff) / 1024.0;
    final r = (a + b) / 2;
    return 0.35 + r * 1.4; // 0.35 … 1.75, clustered near ~1.05
  }

  /// The hidden potential at which a player is not merely a great one but a
  /// SUPERSTAR — the handful of names a whole era is described by.
  ///
  /// Sized against the tail of [developmentPotential]: the draw is triangular,
  /// so 1.70 keeps roughly a quarter of a per cent of the world, which is about
  /// a dozen players alive at once across every nation. The count is never
  /// managed — it drifts between five and twenty as one generation retires and
  /// the next comes through, which is exactly how it should read.
  static const double superstarPotential = 1.70;

  /// The attribute ceiling a superstar plays to. Above the 95 everyone else is
  /// clamped at, because the point of him is that he is better than the best
  /// player anyone else has.
  static const int superstarCeiling = 99;

  /// Whether [id] belongs to a superstar. Derived from the id alone, like
  /// everything else about a player, so no save stores a list of them and two
  /// saves at the same year see the same greats.
  static bool isSuperstar(int id) =>
      developmentPotential(id) >= superstarPotential;

  /// The level a superstar plays at, by [age].
  ///
  /// An ABSOLUTE level, not a bonus on what he happened to be born with. A
  /// superstar out of a weak nation is the whole point of the idea — the boy
  /// from a squad rated in the sixties who is himself one of the best players
  /// in the world — and a flat bonus on top of his own pool could never produce
  /// him. His own ceiling still varies (92–99), and the shape below carries him
  /// up through his early twenties, holds him there, and lets him go in his
  /// mid-thirties like anyone else.
  static int superstarLevel(int id, int age) {
    final ceiling = 92 + (_mix(id ^ 0x57A25AB) % 8); // 92 … 99
    final shape = switch (age) {
      <= 17 => 0.62,
      18 => 0.70,
      19 => 0.78,
      20 => 0.85,
      21 => 0.91,
      22 => 0.96,
      < 31 => 1.0,
      < 33 => 0.96,
      < 35 => 0.90,
      < 37 => 0.82,
      _ => 0.74,
    };
    return (ceiling * shape).round();
  }

  /// A stable non-negative avalanche hash, for [developmentPotential].
  static int _mix(int x) {
    var h = x & 0x7fffffff;
    h = (h ^ (h >> 16)) * 0x45d9f3b & 0x7fffffff;
    h = (h ^ (h >> 16)) * 0x45d9f3b & 0x7fffffff;
    return (h ^ (h >> 16)) & 0x7fffffff;
  }

  /// Adds [d] to every attribute, clamped to the same range aging uses.
  static PlayerAttributes _bumpAll(PlayerAttributes a, int d) {
    int up(int v) => (v + d).clamp(20, 95);
    return a.copyWith(
      physical: up(a.physical),
      technical: up(a.technical),
      stamina: up(a.stamina),
    );
  }

  /// Rebuilds the single newgen with [id], aged to [agingYears]; `null` if [id]
  /// is not a newgen or has not debuted yet. Resolves even a retired newgen
  /// (identity lookup) — the pool assembly in [poolAt] handles retirement.
  /// [seeded] is the base pool of the newgen's nation ([nationIdOf]).
  static Player? newgenById(
    List<Player> seeded,
    int id,
    int agingYears, {
    Map<int, double> youthBonusByCycle = const {},
    Map<int, int> careerStartsByPlayer = const {},
  }) {
    if (!isNewgenId(id)) return null;
    final rem = id - _idBase;
    final bornYearIndex = (rem % _nationStride) ~/ _cycleStride;
    final intakeYear = bornYearIndex - _bornYearOffset;
    if (intakeYear < -backfillYears || intakeYear > agingYears) return null;
    final nationId = rem ~/ _nationStride;
    final bonus = youthBonusByCycle[_cycleOfIntake(intakeYear)] ?? 0.0;
    for (final g in _intake(seeded, nationId, intakeYear, youthBonus: bonus)) {
      if (g.id != id) continue;
      final aged = PlayerAging.agedYears(g, agingYears - intakeYear);
      return withCareerDev(aged, careerStartsByPlayer[aged.id] ?? 0);
    }
    return null;
  }

  /// The deterministic batch of newgens a nation takes in at [intakeYear], as
  /// eleven-year-olds. [intakeYear] is an aging year and may be negative — the
  /// backfilled intakes from before the save opened. [seeded] supplies
  /// culturally-plausible names, plausible clubs, and — via its strongest
  /// players — the nation's quality level, so strong nations keep producing
  /// better prospects.
  static List<Player> _intake(
    List<Player> seeded,
    int nationId,
    int intakeYear, {
    double youthBonus = 0,
  }) {
    if (seeded.isEmpty) return const [];
    final rng = SeededRng(
      (nationId * 0x9E3779B1) ^ (intakeYear * 0x85EBCA77) ^ 0x2545F491,
    );
    final firsts = [for (final p in seeded) _firstName(p.name)];
    final lasts = [for (final p in seeded) _lastName(p.name)];
    final clubs = [for (final p in seeded) p.club];
    // Anchor on a broad slice of the squad (not just the best XI) so youngsters
    // debut clearly below the established stars.
    final ranked = [...seeded]..sort((a, b) => b.overall.compareTo(a.overall));
    final avg = _averageAttributes(ranked.take(30).toList());

    // The nation's own depth chart for this intake — see [DepthChart]. Every
    // country used to produce the same fixed cycle of positions every cycle, so
    // no nation ever developed a shape of its own.
    final positions = DepthChart.forNation(
      nationId: nationId,
      count: intakePerYear,
      salt: intakeYear,
    );

    final bornYearIndex = intakeYear + _bornYearOffset;
    final out = <Player>[];
    for (var i = 0; i < intakePerYear; i++) {
      final pos = positions[i];
      // A wide talent spread anchored on the nation's level: youngsters start
      // WELL below their eventual ceiling — even the best prospect debuts short
      // of the senior stars — then the aging curve develops the gems into stars
      // through their early twenties. Youth-academy investment lifts the whole
      // intake's ceiling (applied after the draw so the RNG stream — and thus
      // ids/names — is unchanged).
      // Clamped: a nation in freefall still produces footballers, and no amount
      // of academy money plus momentum makes a 16-year-old a finished article.
      final talent =
          (0.56 + rng.nextDouble() * 0.38 + youthBonus).clamp(0.40, 1.05);
      // `talent` describes the player he will be at SEVENTEEN — the same
      // number the old intake used, so the senior world is unchanged. What is
      // generated here is that player minus the growing-up he has yet to do,
      // which the sub-17 curve then gives back over six years.
      out.add(
        Player(
          id: _idBase +
              nationId * _nationStride +
              bornYearIndex * _cycleStride +
              i,
          nationId: nationId,
          name: '${firsts[rng.nextInt(firsts.length)]} '
              '${lasts[rng.nextInt(lasts.length)]}',
          age: intakeAge,
          position: pos,
          attributes: _asChild(_scale(avg, talent, rng)),
          club: clubs[rng.nextInt(clubs.length)],
        ),
      );
    }
    return out;
  }

  /// What a seventeen-year-old's attributes looked like when he was eleven.
  ///
  /// The mirror of the sub-17 bands in [PlayerAging]: four years at +2.6/+2.2
  /// and two at +1.8/+1.5. Subtracting them here and adding them back through
  /// the curve is what keeps the senior pool exactly where it was while giving
  /// the youth levels six years of visible growth.
  ///
  /// The floor is 5, NOT the 20 everything else is clamped at. These are the
  /// child's internal numbers, six years short of the player he was drawn as,
  /// and they are never shown raw — [PlayerAging] floors every displayed value
  /// at 20 on the way back out. Clamping here at 20 instead would truncate the
  /// subtraction for any draw below 34, and the curve would then grow those
  /// boys back to MORE than they were drawn as: a weak nation, whose intake
  /// sits low precisely because the nation is weak, would have a third of every
  /// intake quietly inflated, and the senior pool would drift up under it.
  static PlayerAttributes _asChild(PlayerAttributes a) => PlayerAttributes(
        physical: (a.physical - 14).clamp(5, 95),
        technical: (a.technical - 12).clamp(5, 95),
        stamina: (a.stamina - 14).clamp(5, 95),
      );

  static String _firstName(String full) => full.trim().split(' ').first;

  static String _lastName(String full) {
    final parts = full.trim().split(' ');
    return parts.length > 1 ? parts.last : parts.first;
  }

  static PlayerAttributes _averageAttributes(List<Player> squad) {
    final n = squad.length;
    int mean(int Function(PlayerAttributes) pick) =>
        squad.fold<int>(0, (s, p) => s + pick(p.attributes)) ~/ n;
    return PlayerAttributes(
      physical: mean((a) => a.physical),
      technical: mean((a) => a.technical),
      stamina: mean((a) => a.stamina),
    );
  }

  static PlayerAttributes _scale(
    PlayerAttributes base,
    double scale,
    SeededRng rng,
  ) {
    int a(int v) => ((v * scale) + rng.nextInt(9) - 4).round().clamp(20, 92);
    return PlayerAttributes(
      physical: a(base.physical),
      technical: a(base.technical),
      stamina: a(base.stamina),
    );
  }
}
