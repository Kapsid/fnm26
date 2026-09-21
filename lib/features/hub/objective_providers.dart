import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/achievements/board_satisfaction.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/domain/services/competition/nations_cup.dart';
import 'package:fnm/domain/services/competition/rounds.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';
import 'package:fnm/features/settings/settings_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// One of the board's expectations for the cycle, and — once that tournament is
/// over — whether it was met. Fully DERIVED (no storage): the target comes from
/// the nation's standing at the start of the cycle, the outcome from how far it
/// actually went.
typedef CycleObjective = ({
  /// Which tournament this expectation is about.
  TournamentTier tier,

  /// The competition's name, for the label ("European Championship").
  String competition,

  /// e.g. "Reach the quarter-finals".
  String label,

  /// Ordinal target (2 qualify … 7 win it), for comparison.
  int target,

  /// Whether that tournament has finished (so the objective is graded).
  bool decided,

  /// Whether the nation met (or beat) the target — only meaningful once decided.
  bool met,

  /// The nation's actual finish as an ordinal, for the board's maths.
  int actual,

  /// The nation's actual finish, e.g. "Quarter-finals" / "Top half of the
  /// qualifying group".
  String resultLabel,
});

/// The same expectation, WITHOUT any localised wording: the tournament, the
/// bar the board set, and how the nation actually did.
///
/// The grading is pure data, so the simulation layer can read it — it grades
/// and announces each objective the moment its tournament settles, and it runs
/// with no Flutter binding at all. [CycleObjective] is this plus the words.
typedef ObjectiveOutcome = ({
  TournamentTier tier,

  /// The competition's own name ('European Championship', 'World Cup').
  String competition,

  /// Ordinal target (2 qualify … 7 win it).
  int target,

  /// Whether that tournament has finished for this nation.
  bool decided,

  /// Whether the nation met (or beat) the target — only once decided.
  bool met,

  /// The nation's actual finish as an ordinal.
  int actual,
});

/// The board's demand for a target ordinal in [tier], worded for the manager.
///
/// A thin alias for [_labelFor], which is what every screen already uses: this
/// used to be a SECOND, English-only copy of the same ladder, so the board's
/// verdict in the inbox was the one place in the app still speaking English to
/// a Czech manager.
String objectiveDemandText(
  AppLocalizations l,
  TournamentTier tier,
  int target,
) => _labelFor(l, tier, target);

/// A finish ordinal, worded for the manager.
String objectiveFinishText(
  AppLocalizations l,
  TournamentTier tier,
  int ordinal,
) => _resultLabel(l, tier, ordinal);

/// Every board objective for [careerId]'s current cycle, graded but unworded —
/// the CONTINENTAL championship first, then the Nations Cup (for the nations
/// that contest one), then the World Cup.
///
/// A cycle contains two tournaments that matter, and the board used to state an
/// expectation for only one of them: the manager could win their continent and
/// still be judged solely on the World Cup two years later.
final AutoDisposeFutureProviderFamily<List<ObjectiveOutcome>, int>
cycleObjectiveOutcomesProvider = FutureProvider.autoDispose.family<List<ObjectiveOutcome>, int>((
  ref,
  careerId,
) async {
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) return const [];
  final comp = ref.watch(competitionRepositoryProvider);

  // Set once, at the start of the cycle, and never re-graded mid-cycle: read
  // the nation's rank from the frozen cycle-start baseline (the same snapshot
  // the draws seed from), not the live world ranking that shifts with results.
  final baseline = await ref.watch(
    seedRankByIdProvider((
      careerId: careerId,
      cycle: career.cyclePointer,
    )).future,
  );
  final worldRank = baseline[career.nationId] ?? 50;

  final nations = await ref.watch(nationRepositoryProvider).all();
  final me = nations.where((n) => n.id == career.nationId).firstOrNull;
  // THIS cycle's fixtures only. Reading the nation's whole history meant a
  // manager who once reached a World Cup semi-final was still credited with it
  // four, eight and twelve years later: every objective read as met the moment
  // it was graded and then never moved again, whatever the side had actually
  // done this time round.
  final fixtures = await comp.cycleFixturesForNation(careerId, career.nationId);

  final out = <ObjectiveOutcome>[];

  // --- The continental championship -----------------------------------------
  final conf = me?.confederation;
  final cup = conf == null ? null : ContinentalCups.byConfederation[conf];
  if (conf != null && cup != null) {
    // Judged on standing WITHIN the confederation: being 25th in the world is
    // a very different expectation in Europe than in Oceania.
    final continentalRank = _rankWithin(
      baseline,
      nations,
      conf,
      career.nationId,
    );
    final target = continentalObjectiveTarget(continentalRank);
    // Graded the moment the manager's OWN continental championship has a
    // winner, exactly as the World Cup objective is graded off the world
    // champion.
    //
    // It used to ask whether every fixture of kind `continentalFinals` had been
    // played — and that kind covers all six confederations' cups at once, so
    // the manager's cup could be won and lifted while the objective still read
    // "still to be decided" because another continent's championship was
    // mid-knockout.
    final contChampion = await comp.continentalChampion(
      careerId,
      confederation: conf,
    );
    // …or, sooner, the moment the manager's OWN run in it is over. Waiting for
    // the champion meant a side knocked out in the group stage sat on "still to
    // be decided" for the fortnight the rest of the cup took to finish, which
    // read as a brief nobody was ever going to judge.
    final decided =
        contChampion != null ||
        await _runIsOver(
          comp: comp,
          careerId: careerId,
          nationId: career.nationId,
          fixtures: fixtures,
          prefix: 'C',
          kind: CompetitionKind.continentalFinals,
          confederation: conf,
        );
    var actual = _finishOrdinal(fixtures, career.nationId, prefix: 'C');
    if (actual == 0) {
      actual = await _qualifyingOrdinal(
        comp: comp,
        careerId: careerId,
        nationId: career.nationId,
        kind: CompetitionKind.continentalQualifying,
        confederation: conf,
      );
    }
    out.add((
      tier: TournamentTier.continental,
      competition: cup.name,
      target: target,
      decided: decided,
      met: decided && actual >= target,
      actual: actual,
    ));
  }

  // --- The Nations Cup -------------------------------------------------------
  // Only the confederations that actually run one have a group to stand in, so
  // this simply asks whether the nation is in this cycle's cup. It used to have
  // no objective at all: the manager played a whole league campaign, went up or
  // came down, and the board never once said what it had wanted from it.
  final ncTables = await comp.tournamentGroupTables(
    careerId,
    CompetitionKind.nationsLeague,
  );
  final myNcGroup = ncTables
      .where((t) => t.standings.any((s) => s.nationId == career.nationId))
      .firstOrNull;
  if (conf != null && myNcGroup != null) {
    final tiers = await ref
        .watch(careerRepositoryProvider)
        .nationsCupTiers(careerId);
    final target = _nationsCupTarget(
      tiers: tiers,
      baseline: baseline,
      nations: nations,
      confederation: conf,
      nationId: career.nationId,
      groupName: myNcGroup.name,
    );
    final actual = _nationsCupOrdinal(
      standings: myNcGroup.standings,
      fixtures: fixtures,
      nationId: career.nationId,
    );
    // Settled once the league campaign is played out — and, for a side that
    // reached the Finals Four, once that has been played too.
    final ncFixtures = [
      for (final f in fixtures)
        if (f.round == 'NGROUP' || f.round == 'NSF' || f.round == 'NFINAL') f,
    ];
    final decided =
        ncFixtures.isNotEmpty && ncFixtures.every((f) => f.hasResult);
    out.add((
      tier: TournamentTier.nationsCup,
      competition: _nationsCupName,
      target: target,
      decided: decided,
      met: decided && actual >= target,
      actual: actual,
    ));
  }

  // --- The World Cup ---------------------------------------------------------
  final champion = await comp.worldChampion(careerId);
  final wcTarget = worldObjectiveTarget(worldRank);
  var wcActual = _finishOrdinal(fixtures, career.nationId);
  if (wcActual == 0) {
    wcActual = await _qualifyingOrdinal(
      comp: comp,
      careerId: careerId,
      nationId: career.nationId,
      kind: CompetitionKind.worldCupQualifying,
      confederation: conf,
    );
  }
  final wcDecided =
      champion != null ||
      await _runIsOver(
        comp: comp,
        careerId: careerId,
        nationId: career.nationId,
        fixtures: fixtures,
        prefix: '',
        kind: CompetitionKind.worldCupFinals,
      );
  out.add((
    tier: TournamentTier.world,
    competition: _worldCupName,
    target: wcTarget,
    decided: wcDecided,
    met: wcDecided && wcActual >= wcTarget,
    actual: wcActual,
  ));

  return out;
});

/// The World Cup's own name, for [cycleObjectiveOutcomesProvider], which has no
/// localisations to read. The UI substitutes `l.objectiveWorldCup` for it.
const _worldCupName = 'World Cup';

/// The Nations Cup's own name, as above.
const _nationsCupName = 'Nations Cup';

/// Every board objective for the current cycle, worded for the screen.
final AutoDisposeFutureProviderFamily<List<CycleObjective>, int>
cycleObjectivesProvider = FutureProvider.autoDispose
    .family<List<CycleObjective>, int>((
      ref,
      careerId,
    ) async {
      final outcomes = await ref.watch(
        cycleObjectiveOutcomesProvider(careerId).future,
      );
      final l = ref.watch(appLocalizationsProvider);
      return [
        for (final o in outcomes)
          (
            tier: o.tier,
            competition: switch (o.competition) {
              _worldCupName => l.objectiveWorldCup,
              _nationsCupName => l.careerNationsCupLabel,
              final name => name,
            },
            label: _labelFor(l, o.tier, o.target),
            target: o.target,
            decided: o.decided,
            met: o.met,
            actual: o.actual,
            resultLabel: _resultLabel(l, o.tier, o.actual),
          ),
      ];
    });

/// The objective the hub leads with: the next one still to be settled, or the
/// World Cup once both are done.
final AutoDisposeFutureProviderFamily<CycleObjective?, int>
cycleObjectiveProvider = FutureProvider.autoDispose
    .family<CycleObjective?, int>((ref, careerId) async {
      final all = await ref.watch(cycleObjectivesProvider(careerId).future);
      if (all.isEmpty) return null;
      return all.firstWhere((o) => !o.decided, orElse: () => all.last);
    });

/// The first knockout round of each tournament, in the order a field of that
/// size would start at — the continental cups vary in size, so the first round
/// that actually exists is the one that says who went through.
const _firstKnockouts = {
  '': ['R32', 'R16'],
  'C': ['CR16', 'CQF', 'CSF'],
};

/// Whether the manager's nation has FINISHED with the tournament whose rounds
/// carry [prefix] — won it, been knocked out of it, or never qualified for it.
///
/// An objective can be graded the moment this is true, without waiting for the
/// competition's own final: what the nation did is already settled, and the
/// board does not withhold its verdict while other teams play on.
Future<bool> _runIsOver({
  required CompetitionRepository comp,
  required int careerId,
  required int nationId,
  required List<Fixture> fixtures,
  required String prefix,
  required CompetitionKind kind,
  Confederation? confederation,
}) async {
  final mine = [
    for (final f in fixtures)
      if (f.round != null &&
          f.round!.startsWith(prefix) &&
          _isTournamentRound(f.round!, prefix))
        f,
  ];

  // Not in the field at all: the campaign fell short, and that is settled the
  // moment the draw is made without them — not weeks later when the tournament
  // finally kicks off. A manager who misses out on the World Cup should hear
  // the board's verdict on the missed brief there and then, rather than watch
  // "still to be decided" sit on the objective for the rest of the cycle.
  if (mine.isEmpty) {
    final groups = await comp.fixturesByRound(
      careerId,
      '${prefix}GROUP',
      kind: kind,
      confederation: confederation,
    );
    return groups.isNotEmpty;
  }

  // A knockout tie ends the run one way or the other: lose it and you are out,
  // win the final and you are champions.
  for (final f in mine) {
    if (!f.hasResult || !Rounds.isKnockout(f.round)) continue;
    final isHome = f.homeNationId == nationId;
    final my = isHome ? f.homeScore! : f.awayScore!;
    final other = isHome ? f.awayScore! : f.homeScore!;
    if (my < other) return true;
    final core = f.round!.substring(prefix.length);
    if (core == 'FINAL') return true;
  }

  // The group stage is complete: the run is over unless the knockout draw has
  // their name in it.
  final group = [
    for (final f in mine)
      if (f.round == '${prefix}GROUP') f,
  ];
  if (group.isEmpty || !group.every((f) => f.hasResult)) return false;
  for (final round in _firstKnockouts[prefix]!) {
    final ties = await comp.fixturesByRound(
      careerId,
      round,
      kind: kind,
      confederation: confederation,
    );
    if (ties.isEmpty) continue;
    return !ties.any(
      (t) => t.homeNationId == nationId || t.awayNationId == nationId,
    );
  }
  return false;
}

/// Whether [round] belongs to the tournament identified by [prefix] (rather
/// than to qualifying, a friendly, or — for the World Cup's empty prefix — a
/// continental round that merely starts with a 'C').
bool _isTournamentRound(String round, String prefix) {
  const cores = {'GROUP', 'R32', 'R16', 'QF', 'SF', '3RD', 'FINAL'};
  if (prefix.isEmpty && round.startsWith('C')) return false;
  return cores.contains(round.substring(prefix.length));
}

/// [nationId]'s position among its own confederation, from the cycle-start
/// ranking baseline (1 = the confederation's best-ranked nation).
int _rankWithin(
  Map<int, int> baseline,
  List<Nation> nations,
  Confederation conf,
  int nationId,
) {
  // A nation missing from the baseline falls back to its own seed ranking, not
  // to a sentinel: bucketing every unranked side at 9999 made the sort order
  // arbitrary, and an arbitrary confederation position sets an arbitrary
  // demand.
  final peers = <({int id, int rank})>[
    for (final n in nations)
      if (n.confederation == conf)
        (id: n.id, rank: baseline[n.id] ?? n.ranking),
  ]..sort((a, b) => a.rank.compareTo(b.rank));
  final idx = peers.indexWhere((p) => p.id == nationId);
  return idx < 0 ? peers.length + 1 : idx + 1;
}

/// What the board demands at the World Cup, by world rank — a heavyweight is
/// told to win it, a minnow just to be there.
///
/// Below that there is one more rung: a nation outside the world's top fifty
/// has no realistic route into a World Cup, and a board that demands one is
/// setting a brief nobody in the game could meet. Those sides are judged on
/// their qualifying campaign instead.
int worldObjectiveTarget(int rank) {
  if (rank <= 2) return 7; // win it
  if (rank <= 6) return 6; // reach the final
  if (rank <= 12) return 5; // semi-finals
  if (rank <= 20) return 4; // quarter-finals
  if (rank <= 32) return 3; // knockouts
  if (rank <= 50) return 2; // qualify
  return 1; // come through qualifying in the top half of the group
}

/// What the board demands at the continental championship, by standing within
/// the confederation. A smaller field than the World Cup, so the bar is higher
/// at every level: the continent's best side is expected to win its own cup.
///
/// As with the World Cup, a side well outside its continent's leading two dozen
/// is asked to compete in qualifying rather than to reach the finals.
int continentalObjectiveTarget(int confederationRank) {
  if (confederationRank <= 2) return 7; // win it
  if (confederationRank <= 4) return 6; // reach the final
  if (confederationRank <= 7) return 5; // semi-finals
  if (confederationRank <= 11) return 4; // quarter-finals
  if (confederationRank <= 16) return 3; // knockouts
  if (confederationRank <= 24) return 2; // qualify
  return 1; // come through qualifying in the top half of the group
}

/// What the board demands of the nation's Nations Cup campaign, from where it
/// stands INSIDE its own league — the ladder is the competition, so a League C
/// side is judged against League C, not against the continent.
int _nationsCupTarget({
  required Map<int, int> tiers,
  required Map<int, int> baseline,
  required List<Nation> nations,
  required Confederation confederation,
  required int nationId,
  required String groupName,
}) {
  final tier = NationsCup.tierOfGroupName(groupName);
  final confOf = {for (final n in nations) n.id: n.confederation};
  final rankOf = {
    for (final n in nations) n.id: baseline[n.id] ?? n.ranking,
  };
  final peers = [
    for (final e in tiers.entries)
      if (e.value == tier && confOf[e.key] == confederation) e.key,
  ]..sort((a, b) => (rankOf[a] ?? 9999).compareTo(rankOf[b] ?? 9999));
  final idx = peers.indexOf(nationId);
  // No ladder recorded for this side: ask for the middle of the road.
  if (idx < 0 || peers.isEmpty) return 3;
  final share = (idx + 1) / peers.length;
  final lowest = NationsCup.lowestTier(
    tiers: tiers,
    confederation: confederation,
    confederationOf: (id) => confOf[id],
  );

  if (tier == 0) {
    // League A: the top sides are expected in the Finals Four, which is what
    // winning your group there means.
    if (share <= 0.25) return 5;
    return share <= 0.6 ? 4 : 3;
  }
  // Below League A the ladder is the point: the strong go up, the rest hold
  // their place. There is nothing beneath the lowest league to drop into, so
  // "avoid the drop" would be a brief that grades itself.
  if (share <= 0.35) return 4; // win your group and go up
  if (share <= 0.7) return 3; // top half
  return tier >= lowest ? 3 : 2; // stay up
}

/// How the Nations Cup campaign actually went, on the ladder's own scale:
/// 7 champions, 6 runners-up, 5 the Finals Four, 4 group winners, 3 top half,
/// 2 clear of the bottom, 1 bottom of the group.
int _nationsCupOrdinal({
  required List<GroupStanding> standings,
  required List<Fixture> fixtures,
  required int nationId,
}) {
  for (final f in fixtures) {
    if (f.round != 'NFINAL' || !f.hasResult) continue;
    final isHome = f.homeNationId == nationId;
    final mine = isHome ? f.homeScore! : f.awayScore!;
    final theirs = isHome ? f.awayScore! : f.homeScore!;
    final myPens = isHome ? (f.homePenalties ?? 0) : (f.awayPenalties ?? 0);
    final theirPens = isHome ? (f.awayPenalties ?? 0) : (f.homePenalties ?? 0);
    return mine > theirs || (mine == theirs && myPens > theirPens) ? 7 : 6;
  }
  if (fixtures.any((f) => f.round == 'NSF')) return 5;

  final pos = standings.indexWhere((s) => s.nationId == nationId) + 1;
  if (pos <= 0) return 3;
  if (pos == 1) return 4;
  if (pos <= (standings.length + 1) ~/ 2) return 3;
  return pos < standings.length ? 2 : 1;
}

/// How the nation's QUALIFYING campaign went, for a side that never reached the
/// tournament: 1 when it came through in the TOP HALF of its group, 0 when it
/// finished in the bottom half. The lowest rung of the board's ladder is judged
/// on this.
///
/// The bar used to be "did not finish last", and that is why the board's news
/// said "they have what they asked for" whatever happened. In a group of five
/// or six, four or five sides in every group clear a not-last bar: the brief
/// passed itself, and a manager who was never within sight of the tournament
/// was congratulated for it every cycle — with the verdict printed next to a
/// finish line that read "did not qualify". Half a group is a bar a campaign
/// can actually fall under, which is what makes the rung a brief at all.
///
/// A nation with no qualifying group at all (a host, or a confederation that
/// seeds its field straight off the ranking) is credited with the 1: there was
/// no campaign to fall short in.
Future<int> _qualifyingOrdinal({
  required CompetitionRepository comp,
  required int careerId,
  required int nationId,
  required CompetitionKind kind,
  Confederation? confederation,
}) async {
  final tables = await comp.tournamentGroupTables(
    careerId,
    kind,
    confederation: confederation,
  );
  for (final t in tables) {
    final idx = t.standings.indexWhere((s) => s.nationId == nationId);
    if (idx < 0) continue;
    // Top half, counted the same way the Nations Cup counts it: an odd group
    // gives the middle place to the top half.
    return idx < (t.standings.length + 1) ~/ 2 ? 1 : 0;
  }
  return 1;
}

/// The board's demand, worded generically — the competition it applies to is
/// named alongside it, since a cycle now carries a continental objective as
/// well as a World Cup one.
String _labelFor(AppLocalizations l, TournamentTier tier, int target) {
  if (tier == TournamentTier.nationsCup) {
    return switch (target) {
      7 => l.objectiveNcWinIt,
      6 => l.objectiveNcReachFinal,
      5 => l.objectiveNcFinalsFour,
      4 => l.objectiveNcWinGroup,
      3 => l.objectiveNcTopHalf,
      _ => l.objectiveNcSurvive,
    };
  }
  return switch (target) {
    7 => l.objectiveWinTournament,
    6 => l.objectiveReachFinal,
    5 => l.objectiveReachSemis,
    4 => l.objectiveReachQuarters,
    3 => l.objectiveReachKnockouts,
    2 => l.objectiveQualifyGeneric,
    _ => l.objectiveQualifyingTopHalf,
  };
}

/// [nationId]'s deepest finish this cycle as an ordinal (0 = did not qualify,
/// 2 = group stage … 7 = champions). [prefix] selects the competition's rounds
/// ('' = World Cup, 'C' = the continental championship).
int _finishOrdinal(
  List<Fixture> fixtures,
  int nationId, {
  String prefix = '',
}) {
  var best = 0;
  for (final f in fixtures) {
    if (!f.hasResult) continue;
    final round = f.round;
    if (round == null || !round.startsWith(prefix)) continue;
    final base = round.substring(prefix.length);
    if (base == 'FINAL') {
      // Winning the final is the title; losing it is a runners-up finish. A
      // level score means it was settled on penalties.
      final mineIsHome = f.homeNationId == nationId;
      final mine = mineIsHome ? f.homeScore! : f.awayScore!;
      final theirs = mineIsHome ? f.awayScore! : f.homeScore!;
      final myPens = mineIsHome
          ? (f.homePenalties ?? 0)
          : (f.awayPenalties ?? 0);
      final theirPens = mineIsHome
          ? (f.awayPenalties ?? 0)
          : (f.homePenalties ?? 0);
      final won = mine > theirs || (mine == theirs && myPens > theirPens);
      final ord = won ? 7 : 6;
      if (ord > best) best = ord;
      continue;
    }
    final ord = switch (base) {
      '3RD' || 'SF' => 5,
      'QF' => 4,
      'R16' || 'R32' => 3,
      'GROUP' => 2,
      _ => 0,
    };
    if (ord > best) best = ord;
  }
  return best;
}

String _resultLabel(AppLocalizations l, TournamentTier tier, int ordinal) {
  if (tier == TournamentTier.nationsCup) {
    return switch (ordinal) {
      7 => l.finishNcChampions,
      6 => l.finishRunnersUp,
      5 => l.finishNcFinalsFour,
      4 => l.finishNcGroupWinners,
      3 => l.finishNcTopHalf,
      2 => l.finishNcStayedUp,
      _ => l.finishNcBottom,
    };
  }
  return switch (ordinal) {
    7 => l.finishChampions,
    6 => l.finishRunnersUp,
    5 => l.finishSemiFinals,
    4 => l.finishQuarterFinals,
    3 => l.finishRoundOf16,
    2 => l.finishGroupStage,
    // Both bottom rungs describe the QUALIFYING campaign, because that is what
    // a side that never reached the tournament actually played. A flat "did not
    // qualify" here read as a contradiction next to a met verdict, and told a
    // manager whose brief was the campaign itself nothing about how it went.
    1 => l.finishQualifyingTopHalf,
    _ => l.finishQualifyingBottomHalf,
  };
}
