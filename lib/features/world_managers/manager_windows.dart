import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/domain/services/competition/qualification_format.dart';
import 'package:fnm/domain/services/press/expectation.dart';
import 'package:fnm/domain/services/world_managers/manager_decisions.dart';
import 'package:fnm/features/hub/objective_providers.dart';

/// A finals tournament whose brief settles at one decision point: the World
/// Championship (`confederation` null) or one confederation's championship.
/// `finalOn` is the day its final was played.
typedef SettlingTournament = ({
  String key,
  Confederation? confederation,
  DateTime finalOn,
});

/// What each AI nation did in one cycle, read the way the board reads the
/// player: the briefs from the pure targets off the cycle's seeding ranking,
/// the finishes from the same ordinals, the results through
/// [Expectation.surprise]. Built from one read of the cycle's competitions
/// and fixtures; everything here is in memory.
class ManagerWindows {
  ManagerWindows({
    required List<Nation> nations,
    required Map<int, int> baseline,
    required Map<int, ({CompetitionKind kind, Confederation confederation})>
    competitions,
    required List<Fixture> fixtures,
  }) : _baseline = baseline,
       _competitions = competitions {
    for (final n in nations) {
      _nations[n.id] = n;
    }
    for (final f in fixtures) {
      (_fixturesOf[f.homeNationId] ??= []).add(f);
      (_fixturesOf[f.awayNationId] ??= []).add(f);
      final comp = competitions[f.competitionId];
      if (comp == null || !f.hasResult) continue;
      final finalRound = switch (comp.kind) {
        CompetitionKind.worldCupFinals => 'FINAL',
        CompetitionKind.continentalFinals => 'CFINAL',
        _ => null,
      };
      if (f.round != finalRound) continue;
      final world = comp.kind == CompetitionKind.worldCupFinals;
      decided.add((
        key: world
            ? worldKey(f.date.year)
            : continentalKey(comp.confederation, f.date.year),
        confederation: world ? null : comp.confederation,
        finalOn: f.date,
      ));
    }
  }

  final Map<int, int> _baseline;
  final Map<int, ({CompetitionKind kind, Confederation confederation})>
  _competitions;
  final Map<int, Nation> _nations = {};
  final Map<int, List<Fixture>> _fixturesOf = {};

  /// The cycle's tournaments whose final has been played.
  final List<SettlingTournament> decided = [];

  /// The decision key of the World Championship of [year].
  static String worldKey(int year) => 'wc:$year';

  /// The decision key of [c]'s championship of [year].
  static String continentalKey(Confederation c, int year) =>
      'cont:${c.name.toUpperCase()}:$year';

  /// The tournament the decision point [key] (see [worldKey] and
  /// [continentalKey]) settles on [on]; null for any other key.
  static SettlingTournament? fromKey(String key, DateTime on) {
    final parts = key.split(':');
    if (parts.first == 'wc') {
      return (key: key, confederation: null, finalOn: on);
    }
    if (parts.first == 'cont' && parts.length == 3) {
      for (final c in Confederation.values) {
        if (c.name.toUpperCase() == parts[1]) {
          return (key: key, confederation: c, finalOn: on);
        }
      }
    }
    return null;
  }

  /// Whether [t]'s brief is one [nationId] is set.
  bool touches(int nationId, SettlingTournament t) =>
      t.confederation == null ||
      _nations[nationId]?.confederation == t.confederation;

  int _rank(int nationId) =>
      _baseline[nationId] ?? _nations[nationId]?.ranking ?? 211;

  int _rankWithin(Nation n) {
    final peers = [
      for (final p in _nations.values)
        if (p.confederation == n.confederation) p,
    ]..sort((a, b) => _rank(a.id).compareTo(_rank(b.id)));
    return peers.indexWhere((p) => p.id == n.id) + 1;
  }

  int _sizeOf(Confederation c) =>
      _nations.values.where((n) => n.confederation == c).length;

  /// The brief [nationId] is set for [t], as the board sets the player's
  /// (the graded qualifying rules included); 0 is no brief.
  int target(int nationId, SettlingTournament t) {
    final n = _nations[nationId];
    if (n == null) return 0;
    final confRank = _rankWithin(n);
    final size = _sizeOf(n.confederation);
    if (t.confederation == null) {
      return gradedQualifyingTarget(
        worldObjectiveTarget(
          worldRank: _rank(nationId),
          confederationRank: confRank,
          confederation: n.confederation,
          confederationSize: size,
        ),
        confederationRank: confRank,
        places: QualificationFormat.forConfederation(
          n.confederation,
        ).finalsBerths,
      ).target;
    }
    final cup = ContinentalCups.byConfederation[n.confederation];
    if (cup == null) return 0;
    final usual = continentalObjectiveTarget(
      confRank,
      cupSize: cup.size,
      confederationSize: size,
    );
    return cup.qualifying
        ? gradedQualifyingTarget(
            usual,
            confederationRank: confRank,
            places: cup.size,
          ).target
        : usual;
  }

  /// How far [nationId] went in [t], as an ordinal (see
  /// [worldFinishOrdinal]); a side that missed the finals reads its
  /// qualifying group, top half 1, else 0.
  int actual(int nationId, SettlingTournament t) {
    final conf = _nations[nationId]?.confederation;
    final world = t.confederation == null;
    final finalsKind = world
        ? CompetitionKind.worldCupFinals
        : CompetitionKind.continentalFinals;
    final mine = _fixturesOf[nationId] ?? const <Fixture>[];
    final finals = [
      for (final f in mine)
        if (_competitions[f.competitionId] case final c?
            when c.kind == finalsKind &&
                (world || c.confederation == t.confederation))
          f,
    ];
    final ordinal = world
        ? worldFinishOrdinal(finals, nationId)
        : continentalFinishOrdinal(finals, nationId);
    if (ordinal > 0 || conf == null) return ordinal;
    return _qualifyingOrdinal(
      nationId,
      world
          ? CompetitionKind.worldCupQualifying
          : CompetitionKind.continentalQualifying,
      conf,
    );
  }

  /// The board's qualifying reading: the top half of the group (an odd
  /// group gives the middle place to the top half) is 1. As the board's own,
  /// it reads the first such competition of the confederation, and a side
  /// in none of its groups reads 1.
  int _qualifyingOrdinal(int nationId, CompetitionKind kind, Confederation c) {
    int? compId;
    for (final MapEntry(key: id, value: comp) in _competitions.entries) {
      if (comp.kind != kind || comp.confederation != c) continue;
      if (compId == null || id < compId) compId = id;
    }
    if (compId == null) return 1;
    int? groupId;
    for (final f in _fixturesOf[nationId] ?? const <Fixture>[]) {
      if (f.competitionId == compId && f.groupId != null) {
        groupId = f.groupId;
        break;
      }
    }
    if (groupId == null) return 1;
    // A group plays a round robin, so this nation meets every member.
    final members = <int>{};
    for (final f in _fixturesOf[nationId]!) {
      if (f.groupId != groupId) continue;
      members
        ..add(f.homeNationId)
        ..add(f.awayNationId);
    }
    // Every member's games, not only this nation's: the table needs them all.
    final all = <int, Fixture>{};
    for (final m in members) {
      for (final f in _fixturesOf[m] ?? const <Fixture>[]) {
        if (f.groupId == groupId) all[f.id] = f;
      }
    }
    final table = GroupStanding.table(
      members.toList()..sort(),
      all.values.toList(),
    );
    final idx = table.indexWhere((s) => s.nationId == nationId);
    if (idx < 0) return 1;
    return idx < (table.length + 1) ~/ 2 ? 1 : 0;
  }

  /// Whether [nationId] met its brief for [t]: a brief was set, and reached.
  bool met(int nationId, SettlingTournament t) {
    final tg = target(nationId, t);
    return tg > 0 && actual(nationId, t) >= tg;
  }

  /// [nationId]'s window from [from] (exclusive) to [to] (inclusive), in
  /// which [settled] (each touching it) settled; null if nothing did.
  NationWindow? window(
    int nationId, {
    required DateTime from,
    required DateTime to,
    required List<SettlingTournament> settled,
  }) {
    if (settled.isEmpty) return null;
    var briefNet = 0;
    var anyBrief = false;
    var allMet = true;
    for (final t in settled) {
      final tg = target(nationId, t);
      if (tg <= 0) continue;
      anyBrief = true;
      final a = actual(nationId, t);
      briefNet += a - tg;
      if (a < tg) allMet = false;
    }
    var surprise = 0.0;
    final me = _rank(nationId);
    for (final f in _fixturesOf[nationId] ?? const <Fixture>[]) {
      if (!f.hasResult || !f.date.isAfter(from) || f.date.isAfter(to)) {
        continue;
      }
      final kind = _competitions[f.competitionId]?.kind;
      if (kind == null || kind == CompetitionKind.friendly) continue;
      final home = f.homeNationId == nationId;
      surprise += Expectation.surprise(
        nationRank: me,
        opponentRank: _rank(home ? f.awayNationId : f.homeNationId),
        scored: (home ? f.shownHomeScore : f.shownAwayScore)!,
        conceded: (home ? f.shownAwayScore : f.shownHomeScore)!,
      );
    }
    return (
      briefNet: briefNet,
      surpriseSum: surprise,
      settledFinalsBriefMet: anyBrief && allMet,
      anyBriefSettled: anyBrief,
    );
  }
}
