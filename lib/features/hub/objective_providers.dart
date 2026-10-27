import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/util/competition_label.dart';
import 'package:fnm/core/util/message_text.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/achievements/board_satisfaction.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/domain/services/competition/finals_participation.dart';
import 'package:fnm/domain/services/competition/nations_cup.dart';
import 'package:fnm/domain/services/competition/nations_cups.dart';
import 'package:fnm/domain/services/competition/qualification_format.dart';
import 'package:fnm/domain/services/competition/rounds.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';
import 'package:fnm/features/settings/settings_providers.dart';
import 'package:fnm/features/tournaments/nations_cup_draw_providers.dart'
    show nationsCupDrawKind;
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

  /// A minnow's Nations Cup brief to finish above the bottom of a group with
  /// no relegation from it (see [ObjectiveOutcome.offTheBottom]).
  bool offTheBottom,
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

  /// Whether this is a minnow's Nations Cup brief to finish above the bottom
  /// of a group nobody is relegated from (the lowest league of a ladder, or an
  /// African zone): target 2, worded for that rather than as "avoid
  /// relegation". Only a minnow's brief is ever one (see
  /// [minnowNationsCupTarget]); every other brief reads false.
  bool offTheBottom,
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
  int target, {
  String? competition,
  bool offTheBottom = false,
}) => _labelFor(
  l,
  tier,
  target,
  competition: competition,
  offTheBottom: offTheBottom,
);

/// The same demand WITHOUT the words: which string it is, so the board's
/// verdict can be stored as meaning and read in the manager's language
/// whenever he opens it.
///
/// [competition] is the objective's stored competition name: the African
/// Nations Cup is played in zones with a Round of 16 and no promotion, so its
/// rungs are worded for that.
MsgKey objectiveDemandKey(
  TournamentTier tier,
  int target, {
  String? competition,
  bool offTheBottom = false,
}) {
  if (tier == TournamentTier.nationsCup && offTheBottom && target == 2) {
    return MsgKey.objectiveNcOffTheBottom;
  }
  if (tier == TournamentTier.nationsCup && _isZonesCup(competition)) {
    return switch (target) {
      7 => _ncWinIt(competition),
      6 => _ncReachFinal(competition),
      5 => MsgKey.objectiveNcFinalsEight,
      4 => MsgKey.objectiveNcZoneWinGroup,
      _ => MsgKey.objectiveNcTopHalf,
    };
  }
  if (tier == TournamentTier.nationsCup) {
    return switch (target) {
      7 => _ncWinIt(competition),
      6 => _ncReachFinal(competition),
      5 => MsgKey.objectiveNcFinalsFour,
      4 => MsgKey.objectiveNcWinGroup,
      3 => MsgKey.objectiveNcTopHalf,
      _ => MsgKey.objectiveNcSurvive,
    };
  }
  return switch (target) {
    7 => MsgKey.objectiveWinTournament,
    6 => MsgKey.objectiveReachFinal,
    5 => MsgKey.objectiveReachSemis,
    4 => MsgKey.objectiveReachQuarters,
    3 => MsgKey.objectiveReachKnockouts,
    2 => MsgKey.objectiveQualifyGeneric,
    _ => MsgKey.objectiveQualifyingTopHalf,
  };
}

/// A finish ordinal as a key, for the same reason as [objectiveDemandKey].
MsgKey objectiveFinishKey(
  TournamentTier tier,
  int ordinal, {
  String? competition,
  bool offTheBottom = false,
}) {
  // A ladder's lowest league has nothing to stay up in.
  if (tier == TournamentTier.nationsCup &&
      offTheBottom &&
      ordinal == 2 &&
      !_isZonesCup(competition)) {
    return MsgKey.finishNcClearOfBottom;
  }
  if (tier == TournamentTier.nationsCup && _isZonesCup(competition)) {
    return switch (ordinal) {
      7 => _ncChampions(competition),
      6 => MsgKey.finishRunnersUp,
      5 => MsgKey.finishNcFinalsEight,
      4 => MsgKey.finishNcGroupWinners,
      3 => MsgKey.finishNcTopHalf,
      2 => MsgKey.finishNcBottomHalf,
      _ => MsgKey.finishNcBottom,
    };
  }
  if (tier == TournamentTier.nationsCup) {
    return switch (ordinal) {
      7 => _ncChampions(competition),
      6 => MsgKey.finishRunnersUp,
      5 => MsgKey.finishNcFinalsFour,
      4 => MsgKey.finishNcGroupWinners,
      3 => MsgKey.finishNcTopHalf,
      2 => MsgKey.finishNcStayedUp,
      _ => MsgKey.finishNcBottom,
    };
  }
  return switch (ordinal) {
    7 => MsgKey.finishChampions,
    6 => MsgKey.finishRunnersUp,
    5 => MsgKey.finishSemiFinals,
    4 => MsgKey.finishQuarterFinals,
    3 => MsgKey.finishRoundOf16,
    2 => MsgKey.finishGroupStage,
    // Both bottom rungs describe the QUALIFYING campaign, because that is what
    // a side that never reached the tournament actually played. A flat "did not
    // qualify" here read as a contradiction next to a met verdict, and told a
    // manager whose brief was the campaign itself nothing about how it went.
    1 => MsgKey.finishQualifyingTopHalf,
    _ => MsgKey.finishQualifyingBottomHalf,
  };
}

/// A finish ordinal, worded for the manager.
String objectiveFinishText(
  AppLocalizations l,
  TournamentTier tier,
  int ordinal, {
  String? competition,
  bool offTheBottom = false,
}) => _resultLabel(
  l,
  tier,
  ordinal,
  competition: competition,
  offTheBottom: offTheBottom,
);

/// The rungs that name the cup say which one: a CONCACAF manager is told to
/// win the North America Nations Cup, not Europe's.
MsgKey _ncWinIt(String? competition) => switch (competition?.trim()) {
  NationsCups.northAmerica => MsgKey.objectiveNcWinItNorthAmerica,
  NationsCups.africa => MsgKey.objectiveNcWinItAfrica,
  _ => MsgKey.objectiveNcWinIt,
};

MsgKey _ncReachFinal(String? competition) => switch (competition?.trim()) {
  NationsCups.northAmerica => MsgKey.objectiveNcReachFinalNorthAmerica,
  NationsCups.africa => MsgKey.objectiveNcReachFinalAfrica,
  _ => MsgKey.objectiveNcReachFinal,
};

MsgKey _ncChampions(String? competition) => switch (competition?.trim()) {
  NationsCups.northAmerica => MsgKey.finishNcChampionsNorthAmerica,
  NationsCups.africa => MsgKey.finishNcChampionsAfrica,
  _ => MsgKey.finishNcChampions,
};

/// Whether [competition] is a zones-format Nations Cup (Africa's).
bool _isZonesCup(String? competition) =>
    competition != null &&
    NationsCups.confederations.any(
      (c) =>
          NationsCups.forConfederation(c)!.name == competition &&
          NationsCups.forConfederation(c)!.format == NationsCupFormat.zones,
    );

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
  // Which rulebook set this cycle's briefs. A save carried over from before
  // the 1.0.6 retune keeps the briefs its cycle opened with until that cycle
  // ends: they are derived, so changing the rules would otherwise rewrite a
  // brief already announced as met (see [briefRulesV2Kind]).
  final v2 = await comp.hasWatchedDraw(
    careerId,
    career.cyclePointer,
    briefRulesV2Kind,
  );

  final nations = await ref.watch(nationRepositoryProvider).forCareer(careerId);
  final me = nations.where((n) => n.id == career.nationId).firstOrNull;
  // A minnow's softer Nations Cup brief, for a cycle opened under the 1.0.7
  // rules (see [briefRulesV3Kind]); 0 for everyone else.
  final minnow =
      v2 &&
          await comp.hasWatchedDraw(
            careerId,
            career.cyclePointer,
            briefRulesV3Kind,
          )
      ? boardMinnowFactor(baseline, nations, career.nationId)
      : 0.0;
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
    final target = v2
        ? continentalObjectiveTarget(
            continentalRank,
            cupSize: cup.size,
            confederationSize: _sizeOf(nations, conf),
          )
        : _continentalTargetBefore106(continentalRank);
    final run = await continentalRun(
      comp: comp,
      careerId: careerId,
      nationId: career.nationId,
      confederation: conf,
      fixtures: fixtures,
    );
    final decided = run.over;
    var actual = run.ordinal;
    if (actual == 0) {
      actual = await _qualifyingOrdinal(
        comp: comp,
        careerId: careerId,
        nationId: career.nationId,
        kind: CompetitionKind.continentalQualifying,
        confederation: conf,
      );
    }
    // No brief (0): nothing for the board to grade.
    if (target > 0) {
      out.add((
        tier: TournamentTier.continental,
        competition: cup.name,
        target: target,
        decided: decided,
        met: decided && actual >= target,
        actual: actual,
        offTheBottom: false,
      ));
    }
  }

  // --- The Nations Cup -------------------------------------------------------
  // Only the confederations that actually run one have a group to stand in, and
  // the board judges the cup of the manager's OWN confederation: all three cups
  // live in the cycle as competitions of the same kind, so the lookup names it.
  // It used to have no objective at all: the manager played a whole league
  // campaign, went up or came down, and the board never once said what it had
  // wanted from it.
  final ncConf = NationsCups.ofManager(conf);
  final ncCup = ncConf == null ? null : NationsCups.forConfederation(ncConf);
  final ncTables = ncConf == null
      ? const <FinalsGroupTable>[]
      : await comp.tournamentGroupTables(
          careerId,
          CompetitionKind.nationsLeague,
          confederation: ncConf,
        );
  final myNcGroup = ncTables
      .where((t) => t.standings.any((s) => s.nationId == career.nationId))
      .firstOrNull;
  if (ncConf != null && ncCup != null && myNcGroup != null) {
    final zones = ncCup.format == NationsCupFormat.zones;
    final int usual;
    // Whether the side's group has no relegation to avoid: Africa's zones,
    // or the lowest league of a ladder.
    var noDrop = zones;
    if (zones) {
      usual = _zonesCupTarget(
        baseline: baseline,
        nations: nations,
        nationId: career.nationId,
      );
    } else {
      final tiers = await ref
          .watch(careerRepositoryProvider)
          .nationsCupTiers(careerId);
      final confOf = {for (final n in nations) n.id: n.confederation};
      noDrop =
          NationsCup.tierOfGroupName(myNcGroup.name) >=
          NationsCup.lowestTier(
            tiers: tiers,
            confederation: ncConf,
            confederationOf: (id) => confOf[id],
          );
      usual = _nationsCupTarget(
        tiers: tiers,
        baseline: baseline,
        nations: nations,
        confederation: ncConf,
        nationId: career.nationId,
        groupName: myNcGroup.name,
        groupWinnerShare: v2
            ? (top: 0.45, below: 0.25)
            : (top: 0.6, below: 0.35),
      );
    }
    final target = minnowNationsCupTarget(usual, minnow: minnow);
    // The league is built when the cycle opens, two years before a ball is
    // kicked: a table of nothing played lists its members in draw order, and
    // read as a place it printed "So far: top half" on day one. No place
    // until the side has played in its group (0: not progress).
    final ncStarted = fixtures.any((f) => f.round == 'NGROUP' && f.hasResult);
    final actual = !ncStarted
        ? 0
        : _nationsCupOrdinal(
            standings: myNcGroup.standings,
            fixtures: fixtures,
            nationId: career.nationId,
          );
    // Settled once the league campaign is played out — and, for a side that
    // reached the finals, once those have been played too.
    final ncFixtures = [
      for (final f in fixtures)
        if (f.round == 'NGROUP' || FinalsRounds.nationsCup.contains(f.round)) f,
    ];
    var decided = ncFixtures.isNotEmpty && ncFixtures.every((f) => f.hasResult);
    // A zone group winner only learns whether he is one of his zone's best two
    // once EVERY group of the cup is played — a side with a bye on the last
    // matchday has finished before the others have.
    if (decided && zones) {
      final cupGroups = await comp.fixturesByRound(
        careerId,
        'NGROUP',
        kind: CompetitionKind.nationsLeague,
        confederation: ncConf,
      );
      decided = cupGroups.every((f) => f.hasResult);
    }
    out.add((
      tier: TournamentTier.nationsCup,
      competition: ncCup.name,
      target: target,
      decided: decided,
      met: decided && actual >= target,
      actual: actual,
      offTheBottom: noDrop && target == 2 && target < usual,
    ));
  }

  // --- The World Cup ---------------------------------------------------------
  final champion = await comp.worldChampion(careerId);
  final wcTarget = !v2
      ? _worldTargetBefore106(worldRank)
      : me == null
      ? worldObjectiveTarget(
          worldRank: worldRank,
          confederationRank: worldRank,
          confederation: Confederation.europe,
          confederationSize: nations.length,
        )
      : worldObjectiveTarget(
          worldRank: worldRank,
          confederationRank: _rankWithin(
            baseline,
            nations,
            me.confederation,
            me.id,
          ),
          confederation: me.confederation,
          confederationSize: _sizeOf(nations, me.confederation),
        );
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
  if (wcTarget > 0) {
    out.add((
      tier: TournamentTier.world,
      competition: _worldCupName,
      target: wcTarget,
      decided: wcDecided,
      met: wcDecided && wcActual >= wcTarget,
      actual: wcActual,
      offTheBottom: false,
    ));
  }

  return out;
});

/// The World Cup's own name, for [cycleObjectiveOutcomesProvider], which has no
/// localisations to read. The UI substitutes `l.objectiveWorldCup` for it.
const _worldCupName = 'World Cup';

/// Europe's Nations Cup's own name, as above (the other cups are named by
/// [competitionLabel]).
const _nationsCupName = NationsCups.europe;

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
              final name => competitionLabel(l, name),
            },
            label: _labelFor(
              l,
              o.tier,
              o.target,
              competition: o.competition,
              offTheBottom: o.offTheBottom,
            ),
            target: o.target,
            decided: o.decided,
            met: o.met,
            actual: o.actual,
            resultLabel: _resultLabel(
              l,
              o.tier,
              o.actual,
              competition: o.competition,
              offTheBottom: o.offTheBottom,
            ),
            offTheBottom: o.offTheBottom,
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

/// Why a competition the nation plays this cycle has no board objective.
enum ObjectiveGapReason {
  /// The board set no brief: the side is outside the finals' own field and
  /// outside the top three-fifths of its confederation (see
  /// [worldObjectiveTarget] and [continentalObjectiveTarget]). It is judged
  /// on its results there instead.
  noBrief,

  /// This cycle's Nations Cup exists but its draw is still to come, so there
  /// is no group to set a target in yet.
  awaitingDraw,
}

/// A competition the nation plays this cycle that carries no objective, so
/// the board screen can say so instead of leaving it out.
typedef ObjectiveGap = ({
  TournamentTier tier,

  /// Already worded for the screen, as [CycleObjective.competition].
  String competition,
  ObjectiveGapReason reason,
});

/// The competitions of this cycle the board set no objective for (b8 item 4).
///
/// A side outside the top three-fifths of its confederation gets no World
/// Championship or continental brief (by design: it is judged on its
/// results). The board screen used to list only the briefs, so Montenegro's
/// board showed one objective, the Nations Cup, and read as broken. Display
/// only: grading, the board's mood and every verdict still read
/// [cycleObjectiveOutcomesProvider] alone.
final AutoDisposeFutureProviderFamily<List<ObjectiveGap>, int>
cycleObjectiveGapsProvider = FutureProvider.autoDispose
    .family<List<ObjectiveGap>, int>((ref, careerId) async {
      final outcomes = await ref.watch(
        cycleObjectiveOutcomesProvider(careerId).future,
      );
      final career = await ref.watch(careerRepositoryProvider).byId(careerId);
      if (career == null) return const [];
      final nations = await ref
          .watch(nationRepositoryProvider)
          .forCareer(careerId);
      final conf = nations
          .where((n) => n.id == career.nationId)
          .firstOrNull
          ?.confederation;
      if (conf == null) return const [];
      final l = ref.watch(appLocalizationsProvider);
      final have = {for (final o in outcomes) o.tier};
      final cup = ContinentalCups.byConfederation[conf];
      final ncCup = NationsCups.forConfederation(conf);
      // A Nations Cup row with no brief only while this cycle's cup exists and
      // its draw is still to come. A cup the cycle does not have (a cycle
      // opened before the cup existed) or one already drawn without the
      // nation in it gets no row: no draw is coming to set a target.
      final comp = ref.watch(competitionRepositoryProvider);
      final ncAwaitingDraw =
          ncCup != null &&
          !have.contains(TournamentTier.nationsCup) &&
          await comp.hasTournament(
            careerId,
            CompetitionKind.nationsLeague,
            confederation: conf,
          ) &&
          !await comp.hasWatchedDraw(
            careerId,
            career.cyclePointer,
            nationsCupDrawKind,
          );
      return [
        if (cup != null && !have.contains(TournamentTier.continental))
          (
            tier: TournamentTier.continental,
            competition: competitionLabel(l, cup.name),
            reason: ObjectiveGapReason.noBrief,
          ),
        if (ncAwaitingDraw)
          (
            tier: TournamentTier.nationsCup,
            competition: ncCup.name == _nationsCupName
                ? l.careerNationsCupLabel
                : competitionLabel(l, ncCup.name),
            reason: ObjectiveGapReason.awaitingDraw,
          ),
        if (!have.contains(TournamentTier.world))
          (
            tier: TournamentTier.world,
            competition: l.objectiveWorldCup,
            reason: ObjectiveGapReason.noBrief,
          ),
      ];
    });

/// The first knockout round of each tournament, in the order a field of that
/// size would start at — the continental cups vary in size, so the first round
/// that actually exists is the one that says who went through.
const _firstKnockouts = {
  '': ['R32', 'R16'],
  'C': ['CR16', 'CQF', 'CSF'],
};

/// How far [nationId] went in its OWN continental championship this cycle,
/// and whether that run is over. [fixtures] are the nation's fixtures of the
/// current cycle.
///
/// `ordinal` is the finish (0 not in the finals, 2 group, 3 last 16,
/// 4 quarter-final, 5 semi-final, 6 final, 7 champions); a side that never
/// qualified reads 0 here, and the board's own fallback to the qualifying
/// group ([_qualifyingOrdinal]) stays with the board. Shared by the board
/// brief and the campaigns, so both read one run the same way.
Future<({int ordinal, bool over})> continentalRun({
  required CompetitionRepository comp,
  required int careerId,
  required int nationId,
  required Confederation confederation,
  required List<Fixture> fixtures,
}) async {
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
    confederation: confederation,
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
        nationId: nationId,
        fixtures: fixtures,
        prefix: 'C',
        kind: CompetitionKind.continentalFinals,
        confederation: confederation,
      );
  return (
    ordinal: _finishOrdinal(fixtures, nationId, prefix: 'C'),
    over: decided,
  );
}

/// How far [nationId] went in the World Championship this cycle, and whether
/// that run is over: [continentalRun]'s twin, on the same reading the board's
/// World Championship brief uses. [fixtures] are the nation's fixtures of the
/// current cycle.
Future<({int ordinal, bool over})> worldRun({
  required CompetitionRepository comp,
  required int careerId,
  required int nationId,
  required List<Fixture> fixtures,
}) async {
  final decided =
      await comp.worldChampion(careerId) != null ||
      await _runIsOver(
        comp: comp,
        careerId: careerId,
        nationId: nationId,
        fixtures: fixtures,
        prefix: '',
        kind: CompetitionKind.worldCupFinals,
      );
  return (ordinal: worldFinishOrdinal(fixtures, nationId), over: decided);
}

/// [nationId]'s deepest World Championship finish in [fixtures] as an ordinal
/// (0 not in the finals, 2 group … 7 champions), as the board reads it.
int worldFinishOrdinal(List<Fixture> fixtures, int nationId) =>
    _finishOrdinal(fixtures, nationId);

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

/// Marks a cycle opened by 1.0.6 or later, whose briefs follow the retuned
/// rules below (stored with the cycle's watched events: no schema change).
/// Written when a save is created and when a cycle starts; a cycle already
/// under way in a save carried over from 1.0.5 has no mark and keeps the briefs
/// it opened with until it ends.
const briefRulesV2Kind = 'briefRules2';

/// Marks a cycle opened by 1.0.7 or later, whose minnows get the softer
/// Nations Cup brief (see [minnowNationsCupTarget]). Written beside
/// [briefRulesV2Kind]; a cycle already under way when a save is updated keeps
/// the brief it opened with until it ends.
const briefRulesV3Kind = 'briefRules3';

/// How much of a minnow [nationId] is (see [BoardSatisfaction.minnowFactor]),
/// from the cycle-start ranking [baseline] the briefs are set from.
double boardMinnowFactor(
  Map<int, int> baseline,
  List<Nation> nations,
  int nationId,
) {
  final me = nations.where((n) => n.id == nationId).firstOrNull;
  if (me == null) return 0;
  return BoardSatisfaction.minnowFactor(
    worldRank: baseline[nationId] ?? me.ranking,
    confederationRank: _rankWithin(baseline, nations, me.confederation, me.id),
    confederationSize: _sizeOf(nations, me.confederation),
  );
}

/// How much of a minnow the manager's nation is this cycle, for the board's
/// patience (see [BoardSatisfaction.minnowFactor]). Read off the frozen
/// cycle-start baseline, like the briefs, so it does not wobble with results.
final AutoDisposeFutureProviderFamily<double, int> boardMinnowProvider =
    FutureProvider.autoDispose.family<double, int>((ref, careerId) async {
      final career = await ref.watch(careerRepositoryProvider).byId(careerId);
      if (career == null) return 0;
      final baseline = await ref.watch(
        seedRankByIdProvider((
          careerId: careerId,
          cycle: career.cyclePointer,
        )).future,
      );
      final nations = await ref
          .watch(nationRepositoryProvider)
          .forCareer(careerId);
      return boardMinnowFactor(baseline, nations, career.nationId);
    });

/// The factor (see [BoardSatisfaction.minnowFactor]) from which the board
/// sets a minnow's Nations Cup brief.
const double minnowBriefFrom = 0.5;

/// A minnow's Nations Cup brief: one rung below the [usual] one, and never
/// below 2, finishing above the bottom of the group. San Marino was told to
/// finish in the top half of a League D group with Gibraltar and Andorra in
/// it, which it seldom does, and missing that brief took the board to the
/// edge of the sack on its own. Below [minnowBriefFrom] the brief is exactly
/// the [usual] one.
int minnowNationsCupTarget(int usual, {required double minnow}) =>
    minnow >= minnowBriefFrom && usual > 2 ? usual - 1 : usual;

/// The World Championship brief as 1.0.5 and earlier set it, for a cycle
/// opened before the retune (see [briefRulesV2Kind]).
int _worldTargetBefore106(int rank) {
  if (rank <= 2) return 7;
  if (rank <= 6) return 6;
  if (rank <= 12) return 5;
  if (rank <= 20) return 4;
  if (rank <= 32) return 3;
  if (rank <= 50) return 2;
  return 1;
}

/// The continental brief as 1.0.5 and earlier set it (see
/// [_worldTargetBefore106]).
int _continentalTargetBefore106(int confederationRank) {
  if (confederationRank <= 2) return 7;
  if (confederationRank <= 4) return 6;
  if (confederationRank <= 7) return 5;
  if (confederationRank <= 11) return 4;
  if (confederationRank <= 16) return 3;
  if (confederationRank <= 24) return 2;
  return 1;
}

/// What the board demands at the World Cup: a heavyweight is told to win it,
/// a minnow just to be there.
///
/// The knockout rungs go by world rank. Below them, "qualify" is asked only of
/// a side ranked inside its own confederation's share of the World
/// Championship places ([confederationRank] against [confederation]'s
/// berths): Europe's 20th-best had a global top-fifty rank and was told to
/// take one of Europe's sixteen places, while Asia's 7th, with eight places to
/// go for, was only asked to finish in the top half of its group. Everybody
/// else is judged on the qualifying campaign itself, and a side with no
/// realistic hope even of that (outside the top three-fifths of its
/// confederation, the pots a group's top half is drawn from) gets no brief at
/// all: 0, and the board judges it on its results.
int worldObjectiveTarget({
  required int worldRank,
  required int confederationRank,
  required Confederation confederation,
  required int confederationSize,
}) {
  if (worldRank <= 2) return 7; // win it
  if (worldRank <= 6) return 6; // reach the final
  if (worldRank <= 12) return 5; // semi-finals
  if (worldRank <= 20) return 4; // quarter-finals
  if (worldRank <= 32) return 3; // knockouts
  final berths = QualificationFormat.forConfederation(
    confederation,
  ).finalsBerths;
  if (confederationRank <= berths) return 2; // qualify
  return _qualifyingBrief(confederationRank, confederationSize);
}

/// The brief below "qualify": the top half of the qualifying group for a side
/// drawn from the pots that half comes from, and nothing (0) for one drawn
/// below them. Andorra and Bhutan were told to finish in the top half of
/// their groups, which no side in their pots ever does.
int _qualifyingBrief(int confederationRank, int confederationSize) =>
    confederationRank <= (confederationSize * 3 / 5).ceil() ? 1 : 0;

/// What the board demands at the continental championship, by standing within
/// the confederation. A smaller field than the World Cup, so the bar is higher
/// at every level: the continent's best side is expected to win its own cup.
///
/// The rungs are set for a 24-team championship and scaled to the size of the
/// confederation's own ([cupSize]): with the same absolute ranks a sixteen-team
/// Gold Cup told its 5th-7th to reach the semi-finals, and Oceania's eight told
/// its second-best side to win it. As with the World Cup, a side outside the
/// finals' own field is asked to compete in qualifying instead.
int continentalObjectiveTarget(
  int confederationRank, {
  required int cupSize,
  required int confederationSize,
}) {
  // Rounded down, so a smaller field never asks more of a side than a 24-team
  // one would; but a continent's top two are always asked for the final.
  int scaled(int at24, {int atLeast = 1}) =>
      (at24 * cupSize ~/ 24).clamp(atLeast, cupSize);
  if (confederationRank <= scaled(2)) return 7; // win it
  if (confederationRank <= scaled(4, atLeast: 2)) return 6; // reach the final
  if (confederationRank <= scaled(7)) return 5; // semi-finals
  if (confederationRank <= scaled(11)) return 4; // quarter-finals
  if (confederationRank <= scaled(16)) return 3; // knockouts
  if (confederationRank <= cupSize) return 2; // qualify
  return _qualifyingBrief(confederationRank, confederationSize);
}

/// How many nations play in [conf].
int _sizeOf(List<Nation> nations, Confederation conf) =>
    nations.where((n) => n.confederation == conf).length;

/// The board's World Championship and continental demands of [nation] for a
/// save's FIRST cycle, known before the save exists.
///
/// The first cycle's baseline is the static seed ranking (cycle 0 is never
/// snapshotted; see `seedRankByIdProvider`), so these are exactly the targets
/// [cycleObjectiveOutcomesProvider] sets once the career starts. The tablet's
/// nation preview states them. `continental` is null for a confederation with
/// no continental championship.
({int? world, int? continental}) openingObjectiveTargets(
  Nation nation,
  List<Nation> nations,
) {
  final baseline = {for (final n in nations) n.id: n.ranking};
  final cup = ContinentalCups.byConfederation[nation.confederation];
  final confRank = _rankWithin(
    baseline,
    nations,
    nation.confederation,
    nation.id,
  );
  final size = _sizeOf(nations, nation.confederation);
  final world = worldObjectiveTarget(
    worldRank: baseline[nation.id] ?? 50,
    confederationRank: confRank,
    confederation: nation.confederation,
    confederationSize: size,
  );
  final continental = cup == null
      ? 0
      : continentalObjectiveTarget(
          confRank,
          cupSize: cup.size,
          confederationSize: size,
        );
  // Null where the board sets no brief (see [worldObjectiveTarget]).
  return (
    world: world > 0 ? world : null,
    continental: continental > 0 ? continental : null,
  );
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
  ({double top, double below}) groupWinnerShare = (top: 0.45, below: 0.25),
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

  // A league of sixteen has four group winners: only that many sides are told
  // to win a group. League A used to tell its top 60% (nine sides for four
  // places) and every other league its top 35%.
  if (tier == 0) {
    // League A: the top sides are expected in the Finals Four, which is what
    // winning your group there means.
    if (share <= 0.25) return 5;
    return share <= groupWinnerShare.top ? 4 : 3;
  }
  // Below League A the ladder is the point: the strong go up, the rest hold
  // their place. There is nothing beneath the lowest league to drop into, so
  // "avoid the drop" would be a brief that grades itself.
  if (share <= groupWinnerShare.below) return 4; // win your group and go up
  if (share <= 0.7) return 3; // top half
  return tier >= lowest ? 3 : 2; // stay up
}

/// What the board demands of an African Nations Cup campaign, by strength:
/// the continent's leading sides are told to win it or reach the final, the
/// best two of a zone to reach the quarter-finals, a zone's group seeds to win their group, and everybody else
/// to finish in the top half. There is no promotion to earn and no relegation
/// to avoid.
int _zonesCupTarget({
  required Map<int, int> baseline,
  required List<Nation> nations,
  required int nationId,
}) {
  final me = nations.where((n) => n.id == nationId).firstOrNull;
  final zone = me == null ? null : NationsCups.africaZoneByCode[me.code];
  if (me == null || zone == null) return 3;
  final continentRank = _rankWithin(baseline, nations, me.confederation, me.id);
  if (continentRank <= 2) return 7; // win it
  if (continentRank <= 4) return 6; // reach the final
  int rankOf(Nation n) => baseline[n.id] ?? n.ranking;
  final peers = [
    for (final n in nations)
      if (NationsCups.africaZoneByCode[n.code] == zone) n,
  ]..sort((a, b) => rankOf(a).compareTo(rankOf(b)));
  final idx = peers.indexWhere((n) => n.id == nationId);
  if (idx < 0) return 3;
  if (idx < 2) return 5; // one of the zone's best two: the quarter-finals
  // The zone's group seeds: one per group (two groups in the North).
  final groupsInZone = peers.length <= 6 ? 2 : 4;
  if (idx < groupsInZone) return 4; // win your group
  return 3; // top half
}

/// How the Nations Cup campaign actually went, on the ladder's own scale:
/// 7 champions, 6 runners-up, 5 the finals (Finals Four, or Africa's
/// quarter-finals), 4 group winners (or Africa's Round of 16), 3 top half, 2 clear of the bottom, 1 bottom of the
/// group.
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
  // Reached the finals: a ladder cup's Finals Four, or Africa's last eight.
  if (fixtures.any((f) => f.round == 'NSF' || f.round == 'NQF')) return 5;
  // Africa's Round of 16: as good as winning the group, which a runner-up
  // through on the best-runners-up ladder did not quite do.
  if (fixtures.any((f) => f.round == 'NR16')) return 4;

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
String _labelFor(
  AppLocalizations l,
  TournamentTier tier,
  int target, {
  String? competition,
  bool offTheBottom = false,
}) => renderMsgKey(
  l,
  MsgText(
    objectiveDemandKey(
      tier,
      target,
      competition: competition,
      offTheBottom: offTheBottom,
    ),
  ),
);

/// [nationId]'s deepest finish this cycle as an ordinal (0 = did not qualify,
/// 2 = group stage … 7 = champions). [prefix] selects the competition's rounds
/// ('' = World Cup, 'C' = the continental championship).
///
/// A round counts the moment the nation is IN it, played or not: being drawn
/// into the finals is qualifying, and a quarter-final on the calendar is a
/// quarter-final reached. Counting only played games kept a side that had
/// qualified a year earlier on "top half of the qualifying group" until its
/// first finals match, so a brief to qualify was met in the inbox and still
/// unmet on the board.
int _finishOrdinal(
  List<Fixture> fixtures,
  int nationId, {
  String prefix = '',
}) {
  var best = 0;
  for (final f in fixtures) {
    final round = f.round;
    if (round == null || !round.startsWith(prefix)) continue;
    final base = round.substring(prefix.length);
    if (base == 'FINAL') {
      // Reaching the final is a runners-up finish at the least.
      if (!f.hasResult) {
        if (6 > best) best = 6;
        continue;
      }
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

String _resultLabel(
  AppLocalizations l,
  TournamentTier tier,
  int ordinal, {
  String? competition,
  bool offTheBottom = false,
}) => renderMsgKey(
  l,
  MsgText(
    objectiveFinishKey(
      tier,
      ordinal,
      competition: competition,
      offTheBottom: offTheBottom,
    ),
  ),
);
