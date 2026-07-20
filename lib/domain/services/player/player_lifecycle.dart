import 'dart:math';

import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/club/clubs.dart';
import 'package:fnm/domain/services/player/player_aging.dart';

/// Keeps a nation's player pool alive across an endless run of four-year
/// cycles. Like [PlayerAging], this is a *pure, derived* layer — nothing is
/// stored per save. Given a nation's base (cycle-0) seeded players and how many
/// cycles have elapsed, it returns the pool as it stands now: veterans who have
/// aged past [retirementAge] are dropped, and every past cycle's intake of
/// newly-generated youngsters ("newgens") is added, aged from their debut.
///
/// Because it is derived from `(nationId, cycle)` only — never the save's
/// random seed — two saves at the same cycle see the same squads, as aging
/// already behaves.
abstract final class PlayerLifecycle {
  /// A player is considered retired (and drops out of the pool) at this age.
  static const retirementAge = 37;

  /// Youngsters a nation introduces at the start of each new cycle. Chosen so
  /// the pool converges on a stable size: intake ≈ retirements once the seed
  /// generation has aged out (~[intakePerCycle] × (37−17)/4 ≈ the seeded pool).
  static const intakePerCycle = 22;

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

  /// A stable per-nation sequence number for a newgen [id] across all cycles
  /// and slots (born cycle 1 slot 0 → 0, born cycle 2 slot 0 →
  /// [intakePerCycle], …). Used to give every generated player a distinct name.
  static int newgenSequence(int id) {
    final within = (id - _idBase) % _nationStride;
    final cycle = within ~/ _cycleStride;
    final slot = within % _cycleStride;
    return (cycle - 1) * intakePerCycle + slot;
  }

  /// A nation's pool as it stands [agingYears] years into the save: seeded
  /// players aged and de-retired, plus each past cycle's newgen intake aged
  /// from its debut. Newgens still debut at four-year cycle boundaries (so
  /// their ids stay stable), but everyone ages one year at a time. Not sorted.
  ///
  /// [youthBonusByCycle] optionally boosts an intake's talent for the cycle it
  /// was born in (a federation's youth-academy investment). It only shifts
  /// attribute magnitudes — it is applied after the RNG draw, so ids, names and
  /// positions are unchanged and the pool stays deterministic per stored input.
  static List<Player> poolAt(
    List<Player> seeded,
    int nationId,
    int agingYears, {
    Map<int, double> youthBonusByCycle = const {},
    Map<int, int> careerStartsByPlayer = const {},
  }) {
    final out = <Player>[];
    for (final p in seeded) {
      final aged = PlayerAging.agedYears(p, agingYears);
      if (aged.age < retirementAge) {
        out.add(withCareerDev(aged, careerStartsByPlayer[aged.id] ?? 0));
      }
    }
    final cyclesElapsed = agingYears ~/ 4;
    for (var born = 1; born <= cyclesElapsed; born++) {
      final debutYears = born * 4; // the newgen debuts at this cycle boundary
      final bonus = youthBonusByCycle[born] ?? 0.0;
      for (final g in _intake(seeded, nationId, born, youthBonus: bonus)) {
        final aged = PlayerAging.agedYears(g, agingYears - debutYears);
        if (aged.age < retirementAge) {
          out.add(withCareerDev(aged, careerStartsByPlayer[aged.id] ?? 0));
        }
      }
    }
    return out;
  }

  /// The career-development bump: a player who has started many tournament
  /// matches grows a little, faster if they play in a strong club league. A
  /// small, capped, deterministic uplift to every attribute — applied AFTER
  /// aging, so ids/names/positions and the pool are unchanged. No [starts] (or
  /// an opponent, who is passed none) leaves the player exactly as aged.
  static Player withCareerDev(Player aged, int starts) {
    if (starts <= 0) return aged;
    // Weight by the club-league tier the player's (pre-bump) overall implies,
    // so a top-flight regular improves faster than a lower-league one.
    final tier = ClubService.tierForOverall(aged.overall);
    final tierWeight = (6 - tier) / 5.0; // tier 1 → 1.0 … tier 5 → 0.2
    final delta =
        (sqrt(starts) * 0.5 * tierWeight).clamp(0.0, 3.0).round();
    if (delta == 0) return aged;
    return aged.copyWith(attributes: _bumpAll(aged.attributes, delta));
  }

  /// Adds [d] to every attribute, clamped to the same range aging uses.
  static PlayerAttributes _bumpAll(PlayerAttributes a, int d) {
    int up(int v) => (v + d).clamp(20, 95);
    return a.copyWith(
      passing: up(a.passing),
      shooting: up(a.shooting),
      dribbling: up(a.dribbling),
      tackling: up(a.tackling),
      positioning: up(a.positioning),
      composure: up(a.composure),
      decisions: up(a.decisions),
      pace: up(a.pace),
      stamina: up(a.stamina),
      strength: up(a.strength),
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
    final born = (rem % _nationStride) ~/ _cycleStride;
    final debutYears = born * 4;
    if (born < 1 || debutYears > agingYears) return null;
    final nationId = rem ~/ _nationStride;
    final bonus = youthBonusByCycle[born] ?? 0.0;
    for (final g in _intake(seeded, nationId, born, youthBonus: bonus)) {
      if (g.id != id) continue;
      final aged = PlayerAging.agedYears(g, agingYears - debutYears);
      return withCareerDev(aged, careerStartsByPlayer[aged.id] ?? 0);
    }
    return null;
  }

  /// The deterministic batch of newgens a nation debuts at [bornCycle], in
  /// their debut (age 16-19) state. [seeded] supplies culturally-plausible
  /// names, plausible clubs, and — via its strongest players — the nation's
  /// quality level, so strong nations keep producing better prospects.
  static List<Player> _intake(
    List<Player> seeded,
    int nationId,
    int bornCycle, {
    double youthBonus = 0,
  }) {
    if (seeded.isEmpty) return const [];
    final rng = SeededRng(
      (nationId * 0x9E3779B1) ^ (bornCycle * 0x85EBCA77) ^ 0x2545F491,
    );
    final firsts = [for (final p in seeded) _firstName(p.name)];
    final lasts = [for (final p in seeded) _lastName(p.name)];
    final clubs = [for (final p in seeded) p.club];
    // Anchor on a broad slice of the squad (not just the best XI) so youngsters
    // debut clearly below the established stars.
    final ranked = [...seeded]..sort((a, b) => b.overall.compareTo(a.overall));
    final avg = _averageAttributes(ranked.take(30).toList());

    final out = <Player>[];
    for (var i = 0; i < intakePerCycle; i++) {
      final pos = _intakePositions[i % _intakePositions.length];
      // A wide talent spread anchored on the nation's level: youngsters start
      // WELL below their eventual ceiling — even the best prospect debuts short
      // of the senior stars — then the aging curve develops the gems into stars
      // through their early twenties. Youth-academy investment lifts the whole
      // intake's ceiling (applied after the draw so the RNG stream — and thus
      // ids/names — is unchanged).
      final talent = 0.56 + rng.nextDouble() * 0.38 + youthBonus; // 0.56 … 0.94
      out.add(
        Player(
          id: _idBase + nationId * _nationStride + bornCycle * _cycleStride + i,
          nationId: nationId,
          name: '${firsts[rng.nextInt(firsts.length)]} '
              '${lasts[rng.nextInt(lasts.length)]}',
          age: 16 + rng.nextInt(4), // 16 … 19
          position: pos,
          attributes: _scale(avg, talent, rng),
          club: clubs[rng.nextInt(clubs.length)],
        ),
      );
    }
    return out;
  }

  /// A realistic spread of positions across an intake.
  static const List<PlayerPosition> _intakePositions = [
    PlayerPosition.gk,
    PlayerPosition.rb, PlayerPosition.cb, PlayerPosition.cb, PlayerPosition.lb,
    PlayerPosition.dm, PlayerPosition.cm, PlayerPosition.cm, PlayerPosition.am,
    PlayerPosition.rw, PlayerPosition.lw, PlayerPosition.st, PlayerPosition.st,
    PlayerPosition.cb, PlayerPosition.cm, PlayerPosition.rm, PlayerPosition.lm,
    PlayerPosition.gk, PlayerPosition.rb, PlayerPosition.lb, PlayerPosition.dm,
    PlayerPosition.st,
  ];

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
      passing: mean((a) => a.passing),
      shooting: mean((a) => a.shooting),
      dribbling: mean((a) => a.dribbling),
      tackling: mean((a) => a.tackling),
      positioning: mean((a) => a.positioning),
      composure: mean((a) => a.composure),
      decisions: mean((a) => a.decisions),
      pace: mean((a) => a.pace),
      stamina: mean((a) => a.stamina),
      strength: mean((a) => a.strength),
    );
  }

  static PlayerAttributes _scale(
    PlayerAttributes base,
    double scale,
    SeededRng rng,
  ) {
    int a(int v) => ((v * scale) + rng.nextInt(9) - 4).round().clamp(20, 92);
    return PlayerAttributes(
      passing: a(base.passing),
      shooting: a(base.shooting),
      dribbling: a(base.dribbling),
      tackling: a(base.tackling),
      positioning: a(base.positioning),
      composure: a(base.composure),
      decisions: a(base.decisions),
      pace: a(base.pace),
      stamina: a(base.stamina),
      strength: a(base.strength),
    );
  }
}
