import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';

/// One player's international retirement in a career, and his comeback if he
/// made one.
///
/// This is NOT the age wave [PlayerLifecycle.hasRetiredAt] derives: that one
/// ends every career somewhere between 34 and 40 and is the same in every
/// save. This is the decision a veteran makes after a tournament, which
/// differs from save to save and so has to be stored. The player still exists
/// (his club career goes on, his records still name him); he is simply not
/// selectable for his nation from [retiredAging] until [comebackAging].
class IntlRetirement {
  const IntlRetirement({
    required this.playerId,
    required this.retiredAging,
    required this.retiredYear,
    this.retiredOn,
    this.nationId,
    this.notable = false,
    this.retiredCycle,
    this.comebackAging,
    this.comebackYear,
  });

  final int playerId;

  /// The aging year (see `CareerService.agingYears`) he stopped being
  /// selectable in.
  final int retiredAging;

  /// The calendar year he announced it, for the player page.
  final int retiredYear;

  /// The day he announced it, where the marker carries it (null for a marker
  /// that stores only the year).
  final DateTime? retiredOn;

  /// The nation he retired from, where the marker carries it.
  final int? nationId;

  /// Whether he was a real international (a regular, the captain, a record
  /// holder) rather than a squad man: only those get the country's farewell.
  final bool notable;

  /// The cycle the retirement was filed in, where known.
  final int? retiredCycle;

  /// The aging year he made himself available again, or null.
  final int? comebackAging;

  /// The calendar year of the comeback, or null.
  final int? comebackYear;

  /// Whether he is out of his nation's pool [agingYears] into the save.
  ///
  /// Keyed on the aging year so a read of an EARLIER year (the yearly squad
  /// report diffs last year against this one) still sees him in the squad he
  /// was in then.
  bool isRetiredAt(int agingYears) =>
      agingYears >= retiredAging &&
      (comebackAging == null || agingYears < comebackAging!);

  IntlRetirement withComeback(int aging, int year) => IntlRetirement(
    playerId: playerId,
    retiredAging: retiredAging,
    retiredYear: retiredYear,
    retiredOn: retiredOn,
    nationId: nationId,
    notable: notable,
    retiredCycle: retiredCycle,
    comebackAging: aging,
    comebackYear: year,
  );
}

/// Why a veteran stopped, which decides how his announcement reads.
enum IntlRetireReason {
  /// The age caught up with him: the ordinary case.
  age,

  /// A star going out on a high, with a trophy just won.
  onAHigh,

  /// A star of a side that did not make the tournament.
  missedOut,

  /// Not yet thirty-one: nobody saw it coming.
  surprise,
}

/// A retirement the wave decided.
typedef IntlRetireDecision = ({Player player, IntlRetireReason reason});

/// What a nation brought to (or missed) the tournament a wave follows.
typedef IntlRetireContext = ({
  /// Whether the nation played in the finals at all.
  bool participated,

  /// Whether it won them.
  bool champion,

  /// Whether the tournament was a World Championship (else a continental
  /// finals, after which only the oldest and the fringe stop).
  bool worldChampionship,

  /// Tournament appearances by player (empty when it did not take part).
  Map<int, int> appsByPlayer,

  /// Mean tournament match rating by player, where one was recorded.
  Map<int, double> ratingByPlayer,
});

/// Veterans announcing they are done with international football after a
/// major tournament, and the odd one coming back. Pure: every input is passed
/// in, every roll comes from the [SeededRng] the caller seeds, so one save
/// seed always tells the same story.
abstract final class InternationalRetirement {
  // ---- Storage --------------------------------------------------------------
  //
  // Stored as per-career `draws_watched` markers rather than a table, so saves
  // stay on schema 51 and a career bundle carries them with no change. Player
  // ids are global (seeded rows and derived newgens alike), so they survive a
  // bundle's career-id remapping as they are.

  /// `intlRet:<playerId>:<agingYear>:<yyyymmdd>:<nationId>:<notable 0|1>`.
  /// (A marker with only the first three fields still decodes.)
  static const String retiredPrefix = 'intlRet:';

  /// `intlBack:<playerId>:<agingYear>:<yyyymmdd>`.
  static const String comebackPrefix = 'intlBack:';

  /// Written once, the first time a career is settled: everything already
  /// finished by then is history, so an old save starts with nobody retired.
  static const String initMarker = 'intlRetInit';

  /// `intlRetDone:<waveKey>`: this tournament's wave has been run.
  ///
  /// Keyed on what the tournament IS (see [waveKey]), never on its row id:
  /// competition ids are autoincrement across careers and are remapped when
  /// a career bundle is imported, so an id-keyed marker would re-run every
  /// past wave after an import.
  static const String donePrefix = 'intlRetDone:';

  /// The stable name of one finals tournament: the World Championship of a
  /// cycle, or one confederation's championship of a cycle.
  static String waveKey(
    CompetitionKind kind,
    Confederation confederation,
    int cycle,
  ) => kind == CompetitionKind.worldCupFinals
      ? 'wc:$cycle'
      : 'cont:${confederation.name}:$cycle';

  /// A stable 31-bit hash of [s] (FNV-1a), for seeding a wave from its
  /// [waveKey]. `String.hashCode` is not promised to be stable.
  static int stableHash(String s) {
    var h = 0x811c9dc5;
    for (final c in s.codeUnits) {
      h = ((h ^ c) * 0x01000193) & 0x7fffffff;
    }
    return h;
  }

  /// `intlBackCheck:<agingYear>`: this year's comeback roll has been made.
  static const String comebackCheckPrefix = 'intlBackCheck:';

  static String retiredKind(
    int playerId,
    int aging,
    DateTime on, {
    int nationId = 0,
    bool notable = false,
  }) =>
      '$retiredPrefix$playerId:$aging:${_day(on)}:$nationId:'
      '${notable ? 1 : 0}';

  static String comebackKind(int playerId, int aging, DateTime on) =>
      '$comebackPrefix$playerId:$aging:${_day(on)}';

  static int _day(DateTime d) => d.year * 10000 + d.month * 100 + d.day;

  /// The day a marker's last field names: a `yyyymmdd`, or a bare year.
  static (int year, DateTime? on) _readDay(int v) => v < 10000
      ? (v, null)
      : (v ~/ 10000, DateTime(v ~/ 10000, (v ~/ 100) % 100, v % 100));

  /// The retirements stored under [kinds] (any other marker is ignored).
  static Map<int, IntlRetirement> decode(Iterable<String> kinds) =>
      decodeRows([for (final k in kinds) (kind: k, cycle: null)]);

  /// [decode], with the cycle each marker row was filed in.
  static Map<int, IntlRetirement> decodeRows(
    Iterable<({String kind, int? cycle})> rows,
  ) {
    final retired = <int, IntlRetirement>{};
    final back = <int, (int, int)>{};
    for (final row in rows) {
      final k = row.kind;
      final isRet = k.startsWith(retiredPrefix);
      final isBack = k.startsWith(comebackPrefix);
      if (!isRet && !isBack) continue;
      final parts = k
          .substring(isRet ? retiredPrefix.length : comebackPrefix.length)
          .split(':');
      if (parts.length != 3 && parts.length != 5) continue;
      final id = int.tryParse(parts[0]);
      final aging = int.tryParse(parts[1]);
      final day = int.tryParse(parts[2]);
      if (id == null || aging == null || day == null) continue;
      final (year, on) = _readDay(day);
      if (isRet) {
        // Once per player: the earliest announcement is the one that stands.
        final had = retired[id];
        if (had == null || aging < had.retiredAging) {
          retired[id] = IntlRetirement(
            playerId: id,
            retiredAging: aging,
            retiredYear: year,
            retiredOn: on,
            nationId: parts.length == 5 ? int.tryParse(parts[3]) : null,
            notable: parts.length == 5 && parts[4] == '1',
            retiredCycle: row.cycle,
          );
        }
      } else {
        back[id] = (aging, year);
      }
    }
    return {
      for (final e in retired.entries)
        e.key: switch (back[e.key]) {
          (final a, final y) when a > e.value.retiredAging =>
            e.value.withComeback(a, y),
          _ => e.value,
        },
    };
  }

  /// [pool] without anyone [retirements] has out of it at [agingYears].
  /// Hands back [pool] itself when nobody is filtered.
  static List<Player> filterPool(
    List<Player> pool,
    Map<int, IntlRetirement> retirements,
    int agingYears,
  ) {
    if (retirements.isEmpty) return pool;
    bool out(Player p) => retirements[p.id]?.isRetiredAt(agingYears) ?? false;
    if (!pool.any(out)) return pool;
    return [
      for (final p in pool)
        if (!out(p)) p,
    ];
  }

  // ---- The pool guard -------------------------------------------------------

  /// The fewest selectable seniors a nation may be left with.
  static const int minPool = 30;

  /// The fewest per position line, so a squad of 23 with cover can always be
  /// named: three keepers, and a full back four, midfield and front line twice
  /// over.
  static const Map<PositionCategory, int> minByLine = {
    PositionCategory.goalkeeper: 3,
    PositionCategory.defender: 8,
    PositionCategory.midfielder: 8,
    PositionCategory.forward: 5,
  };

  /// Whether [p] may leave [pool] without leaving it short.
  ///
  /// Counts the pool AFTER he goes: [minPool] in all, [minByLine] per line,
  /// and for a keeper also two keepers still good enough to play (within
  /// [viableKeeperGap] of the squad's standard), so the nation is never down
  /// to one real goalkeeper.
  static bool poolCanLose(List<Player> pool, Player p) {
    final rest = [
      for (final q in pool)
        if (q.id != p.id) q,
    ];
    if (rest.length < minPool) return false;
    final line = p.category;
    final inLine = rest.where((q) => q.category == line).length;
    if (inLine < minByLine[line]!) return false;
    if (line == PositionCategory.goalkeeper) {
      final standard = _squadStandard(pool);
      final viable = rest
          .where(
            (q) =>
                q.category == PositionCategory.goalkeeper &&
                q.overall >= standard - viableKeeperGap,
          )
          .length;
      if (viable < 2) return false;
    }
    return true;
  }

  /// The pool the guard should count: [pool] as it will stand after the
  /// age wave due at the next aging year ([PlayerLifecycle.hasRetiredAt] at
  /// [agingYears] + 1), without the long-term injured ([longInjured]). A
  /// retirement is judged against the squad the nation will actually have,
  /// not the one it has the day after the final.
  static List<Player> guardPoolFor(
    List<Player> pool,
    int agingYears, {
    Set<int> longInjured = const {},
  }) => [
    for (final p in pool)
      if (!longInjured.contains(p.id) &&
          !PlayerLifecycle.hasRetiredAt(p.id, p.age + 1, agingYears + 1))
        p,
  ];

  /// Matches out from which an injury counts as long-term for the guard.
  static const int longInjuryMatches = 3;

  /// How far below the squad's standard a keeper may sit and still count.
  static const int viableKeeperGap = 10;

  /// The 23rd-best rating in [pool]: what "good enough for the squad" means.
  static int _squadStandard(List<Player> pool) {
    if (pool.isEmpty) return 0;
    final ratings = [for (final p in pool) p.overall]
      ..sort((a, b) => b.compareTo(a));
    return ratings[(ratings.length < 23 ? ratings.length : 23) - 1];
  }

  /// How much of the base chance a nation of [poolSize] seniors keeps.
  ///
  /// A thin pool retires far less: a minnow whose third keeper is a schoolboy
  /// cannot afford a veteran walking, and neither, in practice, does he.
  static double depthFactor(int poolSize) =>
      ((poolSize - 40) / 60).clamp(0.08, 1.0);

  /// The most one nation can lose in one wave.
  static int maxPerWave(int poolSize) {
    final d = depthFactor(poolSize);
    return d >= 0.8
        ? 3
        : d >= 0.4
        ? 2
        : 1;
  }

  /// How far down his nation's ratings a player can sit and still be one
  /// whose retirement is an announcement. Below it (and without a game at the
  /// finals) he was never in the picture: he does not retire, he fades, and
  /// the age wave lets him go in its own time.
  static const int squadReach = 30;

  // ---- The wave -------------------------------------------------------------

  /// The base chance by age, as of the tournament just played.
  ///
  /// Rare before thirty-one (a surprise), rising from there and strong from
  /// thirty-four. The age wave still ends every career by 34-40; this is the
  /// decision a player makes before it does.
  static double ageChance(int age) => switch (age) {
    < earliestRetirementAge => 0,
    29 || 30 => 0.012,
    31 => 0.04,
    32 => 0.07,
    33 => 0.12,
    34 => 0.2,
    35 => 0.3,
    _ => 0.4,
  };

  /// The youngest a man may retire at after a continental finals, unless he
  /// is on the fringe ([fringeRank]).
  static const int continentalMinAge = 34;

  /// From this place in his nation's ratings (0 = best) a player is outside
  /// the best 23: on the fringe of the squad.
  static const int fringeRank = 23;

  /// The chance [p] announces it after a tournament.
  ///
  /// [rank] is his place in his nation's pool by rating (0 = best). A key man
  /// is less likely to stop, a fringe one more, and one below [squadReach]
  /// who did not play at the finals not at all; a star of a side that missed
  /// the tournament is the only one of his squad to consider it at all; a star
  /// who has just won the thing may go out on a high.
  static ({double chance, IntlRetireReason reason}) chanceFor({
    required Player p,
    required int rank,
    required int poolSize,
    required IntlRetireContext context,
  }) {
    final age = p.age;
    var chance = ageChance(age);
    if (chance == 0) return (chance: 0, reason: IntlRetireReason.age);
    // A continental finals is not the end of an era: only a veteran of
    // [continentalMinAge] or more, or a man on the fringe of the squad,
    // calls it a day after one. Going out on a high is for a World
    // Championship.
    if (!context.worldChampionship &&
        age < continentalMinAge &&
        rank < fringeRank) {
      return (chance: 0, reason: IntlRetireReason.age);
    }
    final star = rank < 6;
    if (!context.participated) {
      // Only the stars of a side that failed walk away over it.
      if (!star || age < 31) return (chance: 0, reason: IntlRetireReason.age);
      return (
        chance: chance * 0.7 * depthFactor(poolSize),
        reason: IntlRetireReason.missedOut,
      );
    }
    var reason = age < 31 ? IntlRetireReason.surprise : IntlRetireReason.age;
    final apps = context.appsByPlayer[p.id] ?? 0;
    // Never in the picture: he fades rather than announces anything.
    if (rank >= squadReach && apps == 0) {
      return (chance: 0, reason: reason);
    }
    // His standing in the squad.
    if (rank < 11) {
      chance *= 0.6;
    } else if (rank >= fringeRank) {
      chance *= 1.4;
    }
    // Did not get a game at the finals, or played them badly.
    if (apps == 0) chance *= 1.3;
    final rating = context.ratingByPlayer[p.id];
    if (rating != null && rating < 6.3) chance *= 1.3;
    if (context.worldChampionship &&
        context.champion &&
        rank < 8 &&
        age >= 30) {
      chance += 0.18;
      reason = IntlRetireReason.onAHigh;
    }
    return (
      chance: (chance * depthFactor(poolSize)).clamp(0.0, 0.85),
      reason: reason,
    );
  }

  /// The veterans of one nation who announce it after a tournament.
  ///
  /// [pool] is the nation's selectable senior pool as it stands (already
  /// without anyone retired), best first or not. [alreadyRetired] are ids
  /// that are never rolled for (a man back from retirement). Each acceptance
  /// re-checks the pool guard against what is left ([guardPool] when given),
  /// so a wave can never take a nation below [minPool] or a line below
  /// [minByLine] however the rolls fall.
  static List<IntlRetireDecision> waveFor({
    required List<Player> pool,
    required IntlRetireContext context,
    required SeededRng rng,
    Set<int> alreadyRetired = const {},
    List<Player>? guardPool,
  }) {
    final ranked = [...pool]
      ..sort((a, b) {
        final by = b.overall.compareTo(a.overall);
        return by != 0 ? by : a.id.compareTo(b.id);
      });
    // The guard counts the pool as it WILL stand (see [guardPoolFor]), so a
    // wave cannot pass today and leave the nation short after December.
    final remaining = [...(guardPool ?? ranked)];
    final cap = maxPerWave(ranked.length);
    final out = <IntlRetireDecision>[];
    for (var i = 0; i < ranked.length; i++) {
      final p = ranked[i];
      // A roll for every man, in a fixed order, so one more candidate never
      // shifts the dice of the next.
      final roll = rng.nextDouble();
      if (out.length >= cap) continue;
      if (alreadyRetired.contains(p.id)) continue;
      final c = chanceFor(
        p: p,
        rank: i,
        poolSize: ranked.length,
        context: context,
      );
      if (roll >= c.chance) continue;
      if (!poolCanLose(remaining, p)) continue;
      remaining.removeWhere((q) => q.id == p.id);
      out.add((player: p, reason: c.reason));
    }
    return out;
  }

  // ---- Comebacks ------------------------------------------------------------

  /// Nobody announces it younger (see [ageChance]).
  static const int earliestRetirementAge = 29;

  /// Nobody comes back older.
  static const int comebackMaxAge = 36;

  /// The most aging years a retiree can have been away and still come back:
  /// one who retired at [earliestRetirementAge] is past [comebackMaxAge]
  /// after that. Lets the yearly roll skip the long-retired on the marker
  /// alone, without reading the player.
  static const int maxYearsAwayForComeback =
      comebackMaxAge - earliestRetirementAge;

  /// The yearly chance a retired player who is still good enough returns.
  static const double comebackBase = 0.03;

  /// The ceiling on it, however bad the crisis.
  static const double comebackCap = 0.35;

  /// Whether a retired [p] comes back this year.
  ///
  /// He must still be good: at least the 15th-best rating in [pool] (the pool
  /// he would rejoin). A squad crisis ([injuredInSquad] of the best 23 out
  /// injured, three or more) or a new manager in charge makes it likelier.
  static bool comesBack({
    required Player p,
    required List<Player> pool,
    required int injuredInSquad,
    required bool newManager,
    required SeededRng rng,
  }) {
    final roll = rng.nextDouble();
    if (p.age > comebackMaxAge) return false;
    final ratings = [for (final q in pool) q.overall]
      ..sort((a, b) => b.compareTo(a));
    final bar = ratings.isEmpty
        ? 0
        : ratings[(ratings.length < 15 ? ratings.length : 15) - 1];
    if (p.overall < bar) return false;
    var chance = comebackBase;
    if (injuredInSquad >= 3) chance *= 4;
    if (newManager) chance *= 3;
    return roll < chance.clamp(0.0, comebackCap);
  }

  /// A deterministic seed for one nation's roll in one wave.
  static int seedFor(int saveSeed, int salt, int nationId) =>
      (saveSeed * 0x9E3779B1) ^ (salt * 0x85EBCA77) ^ (nationId * 0xC2B2AE3D);
}
