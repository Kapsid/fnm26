import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/player/player_aging.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';

/// A golden generation: a fixed cohort of teenagers that stands in for a
/// nation's whole senior pool, in a career that asks for it (the Young Finns
/// campaign). Pure and derived like the rest of the pool: nothing about the
/// players is stored. A career carries only the marker ([markerFor]) and the
/// player repository builds the nation's pool from this on every read.
///
/// What the pool becomes ([poolAt]): the nation's own newgen intakes, exactly
/// as an ordinary career has them (every one of them seventeen or younger on
/// the save's first day, and the youth pyramid goes on producing more), plus
/// the cohort. Every stored player, the real squad and its seeded fringe, is
/// gone from it: the seniors are simply not Finland's in this world.
///
/// The cohort's members are ordinary players in every other respect. Their
/// ids live in a range of their own (below the newgens, above the seeded
/// fringe), their potential is the id's own draw ([PlayerLifecycle.
/// basePotential]; the cohort is made of ids whose draw is high), and they
/// age, grow, retire and develop with game time through the same curves as
/// everyone else.
abstract final class GoldenGeneration {
  /// Where cohort ids begin. Below [PlayerLifecycle]'s newgen space (1e9),
  /// far above the seeded fringe (from 1e7, a few thousand of them), and
  /// clear of the staff candidates' ids, which start at 900M and climb ten
  /// thousand a cycle (they would reach 950M after five thousand cycles).
  static const int idBase = 950000000;

  /// Ids per nation: room to scan for the potential draws the cohort wants.
  static const int _nationStride = 10000;

  /// Whether [id] belongs to a cohort member.
  static bool isGoldenId(int id) =>
      id >= idBase && id < idBase + 1000 * _nationStride;

  /// The nation a cohort [id] belongs to.
  static int nationOf(int id) => (id - idBase) ~/ _nationStride;

  /// The draw-watched kind (cycle 0) that gives a career [nationId]'s golden
  /// generation. Written once, when the campaign run is created; a career
  /// without it (every normal career, every other campaign) never sees one.
  static String markerFor(int nationId) => 'goldenGeneration:$nationId';

  /// Whether [nationId] has a cohort at all. The repository only looks for
  /// the marker on these nations' reads.
  static bool hasCohort(int nationId) => _specs.containsKey(nationId);

  /// The cohort as it stands on the save's first day (aging year 0), or empty
  /// for a nation without one. Built once per nation.
  static List<Player> cohort(int nationId) =>
      _cache[nationId] ??= cohortUncached(nationId);

  static final Map<int, List<Player>> _cache = {};

  /// [cohort] without the cache (it is a pure function of the nation).
  static List<Player> cohortUncached(int nationId) {
    final spec = _specs[nationId];
    if (spec == null) return const [];
    final rng = SeededRng((nationId * 0x9E3779B1) ^ 0x60D1E7);
    final ids = _pickIds(nationId, [for (final m in _template) m.band]);
    return [
      for (var i = 0; i < _template.length; i++)
        _member(nationId, ids[i], _template[i], spec, rng),
    ];
  }

  /// [nationId]'s pool [agingYears] into the save: its newgen intakes as
  /// [PlayerLifecycle.poolAt] builds them, plus the cohort aged to the year.
  /// The same floor ([minAge]) and the same development inputs as the
  /// ordinary pool. Not sorted.
  static List<Player> poolAt(
    List<Player> seeded,
    int nationId,
    int agingYears, {
    int minAge = PlayerLifecycle.seniorMinAge,
    Map<int, double> youthBonusByCycle = const {},
    Map<int, int> careerStartsByPlayer = const {},
    int clubSeed = 0,
  }) {
    final out = [
      for (final p in PlayerLifecycle.poolAt(
        seeded,
        nationId,
        agingYears,
        minAge: minAge,
        youthBonusByCycle: youthBonusByCycle,
        careerStartsByPlayer: careerStartsByPlayer,
        clubSeed: clubSeed,
      ))
        if (PlayerLifecycle.isNewgenId(p.id)) p,
    ];
    for (final g in cohort(nationId)) {
      final p = _aged(g, agingYears, careerStartsByPlayer, clubSeed);
      if (p.age < minAge) continue;
      if (PlayerLifecycle.hasRetiredAt(p.id, p.age, agingYears)) continue;
      out.add(p);
    }
    return out;
  }

  /// The cohort member [id], aged to [agingYears], or null when [id] is no
  /// member. Resolves a retired member too (identity lookup), as the seeded
  /// players' lookup does.
  static Player? byId(
    int id,
    int agingYears, {
    Map<int, int> careerStartsByPlayer = const {},
    int clubSeed = 0,
  }) {
    if (!isGoldenId(id)) return null;
    for (final g in cohort(nationOf(id))) {
      if (g.id == id) {
        return _aged(g, agingYears, careerStartsByPlayer, clubSeed);
      }
    }
    return null;
  }

  /// A member aged [years], with the career-development bump: the same two
  /// steps the ordinary pool takes for a seeded player.
  static Player _aged(
    Player g,
    int years,
    Map<int, int> careerStartsByPlayer,
    int clubSeed,
  ) {
    final aged = PlayerAging.agedYears(g, years);
    return PlayerLifecycle.withCareerDev(
      aged,
      careerStartsByPlayer[g.id] ?? 0,
      minutesFactor: PlayerLifecycle.minutesFactorFor(aged, years, clubSeed),
    );
  }

  /// Per nation, how good the cohort is: its `level` is the overall a
  /// first-choice member is drawn to have at twenty-three, before the
  /// career-development bump. The calibration lab (`campaign_lab_test.dart`)
  /// tuned it.
  static const Map<int, _CohortSpec> _specs = {
    // Finland. A little under today's side on day one (the teenage markdown
    // takes some ten points off), near the world's top ten by the third
    // cycle. On autopilot, no sacking (ten runs each): 80 gave one star or
    // more in 10 of 10 and three stars in 1; 79 gave 10 and 3, 78 gave 9
    // and 2. Three stars hardly moves across that range (a world title is a
    // knockout draw once there); lower costs the first star first.
    17: _CohortSpec(level: 80),
  };

  /// The cohort's shape, in depth order: a first eleven (4-3-3), a second,
  /// and a third. Ages 15 to 18, most of them 17 or 18, the youngest in the
  /// third eleven; one superstar draw, three wonderkids, the rest drawn high.
  static const List<_Member> _template = [
    // First eleven.
    _Member(PlayerPosition.gk, 18, 0),
    _Member(PlayerPosition.rb, 18, 0),
    _Member(PlayerPosition.cb, 18, 0),
    _Member(PlayerPosition.cb, 17, 0),
    _Member(PlayerPosition.lb, 17, 0),
    _Member(PlayerPosition.dm, 18, 0),
    _Member(PlayerPosition.cm, 17, 0, band: _Band.wonder),
    _Member(PlayerPosition.cm, 18, 0),
    _Member(PlayerPosition.rw, 17, 0, band: _Band.wonder),
    _Member(PlayerPosition.st, 18, 0, band: _Band.star),
    _Member(PlayerPosition.lw, 18, 0),
    // Second eleven.
    _Member(PlayerPosition.gk, 17, 1),
    _Member(PlayerPosition.rb, 17, 1),
    _Member(PlayerPosition.cb, 18, 1),
    _Member(PlayerPosition.cb, 16, 1),
    _Member(PlayerPosition.lb, 18, 1),
    _Member(PlayerPosition.dm, 17, 1),
    _Member(PlayerPosition.cm, 16, 1, band: _Band.wonder),
    _Member(PlayerPosition.am, 18, 1),
    _Member(PlayerPosition.rw, 18, 1),
    _Member(PlayerPosition.st, 17, 1),
    _Member(PlayerPosition.lw, 17, 1),
    // Third eleven.
    _Member(PlayerPosition.gk, 16, 2),
    _Member(PlayerPosition.rb, 15, 2),
    _Member(PlayerPosition.cb, 17, 2),
    _Member(PlayerPosition.cb, 15, 2),
    _Member(PlayerPosition.lb, 16, 2),
    _Member(PlayerPosition.dm, 16, 2),
    _Member(PlayerPosition.am, 15, 2),
    _Member(PlayerPosition.lm, 17, 2),
    _Member(PlayerPosition.rm, 16, 2),
    _Member(PlayerPosition.st, 15, 2),
    _Member(PlayerPosition.st, 18, 2),
  ];

  /// How far below a first-choice member each eleven is drawn, in overall
  /// points at twenty-three.
  static const List<int> _tierDrop = [0, 3, 6];

  /// One id per wanted [bands] entry, in order: the nation's id range scanned
  /// from its first slot, each id taken by the first member still waiting for
  /// a draw in its band. Deterministic, and no id is used twice.
  static List<int> _pickIds(int nationId, List<_Band> bands) {
    final out = List<int?>.filled(bands.length, null);
    final first = idBase + nationId * _nationStride;
    for (var k = 0; k < _nationStride; k++) {
      final id = first + k;
      final band = _bandOf(PlayerLifecycle.basePotential(id));
      if (band == null) continue;
      final i = [
        for (var j = 0; j < bands.length; j++)
          if (out[j] == null && bands[j] == band) j,
      ].firstOrNull;
      if (i == null) continue;
      out[i] = id;
      if (!out.contains(null)) break;
    }
    if (out.contains(null)) {
      throw StateError('No golden generation ids for nation $nationId.');
    }
    return out.cast<int>();
  }

  /// The band a drawn potential falls in, or null for one the cohort never
  /// takes. The high band stops below the wonderkid one, and a late bloom
  /// (base under 1.30, +0.30) cannot reach the superstar bar, so the cohort's
  /// superstars are exactly the [_Band.star] members.
  static _Band? _bandOf(double potential) {
    if (potential >= PlayerLifecycle.superstarPotential) return _Band.star;
    if (potential >= 1.55) return _Band.wonder;
    if (potential >= 1.20) return _Band.high;
    return null;
  }

  /// A member: drawn as the player he is at twenty-three, then taken back to
  /// his age through the game's own curve, so aging him forward returns him
  /// there (the teenage markdown is applied on read, as for everybody).
  static Player _member(
    int nationId,
    int id,
    _Member m,
    _CohortSpec spec,
    SeededRng rng,
  ) {
    final level =
        spec.level -
        _tierDrop[m.tier] +
        (m.band == _Band.high ? 0 : 2) +
        rng.nextInt(5) -
        2;
    int draw() => level + rng.nextInt(7) - 3;
    final at23 = PlayerAttributes(
      physical: draw(),
      technical: draw(),
      stamina: draw(),
    );
    final growth = _growthTo23(m.age);
    return Player(
      id: id,
      nationId: nationId,
      // Named on read from the career's own pools, like every player.
      name: 'Golden ${id - idBase}',
      age: m.age,
      position: m.position,
      attributes: PlayerAttributes(
        physical: (at23.physical - growth.physical).clamp(20, 95),
        technical: (at23.technical - growth.technical).clamp(20, 95),
        stamina: (at23.stamina - growth.stamina).clamp(20, 95),
      ),
    );
  }

  /// What the age curve adds between [age] and twenty-three, per attribute,
  /// read off [PlayerAging] itself so a retune of the curve carries through.
  /// The probe's id draws the lowest potential: no superstar lift, no
  /// wonderkid relief, and at twenty-three no teenage markdown either.
  static PlayerAttributes _growthTo23(int age) {
    const probe = Player(
      id: 0,
      nationId: 0,
      name: '',
      age: 0,
      position: PlayerPosition.cm,
      attributes: PlayerAttributes(physical: 50, technical: 50, stamina: 50),
    );
    final grown = PlayerAging.agedYears(probe.copyWith(age: age), 23 - age);
    return PlayerAttributes(
      physical: grown.attributes.physical - 50,
      technical: grown.attributes.technical - 50,
      stamina: grown.attributes.stamina - 50,
    );
  }
}

/// How good a nation's cohort is (see [GoldenGeneration._specs]).
class _CohortSpec {
  const _CohortSpec({required this.level});

  final int level;
}

/// The potential draw a cohort member is made from.
enum _Band { star, wonder, high }

/// One place in the cohort: position, age on the first day, which eleven.
class _Member {
  const _Member(this.position, this.age, this.tier, {this.band = _Band.high});

  final PlayerPosition position;
  final int age;
  final int tier;
  final _Band band;
}
