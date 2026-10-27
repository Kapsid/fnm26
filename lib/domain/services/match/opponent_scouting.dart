import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/manager/staff.dart';
import 'package:fnm/domain/services/match/ai_tactics.dart';

/// How much the scout's report on the next opponent says, by the man in the
/// job. Nobody in the job still leaves the world ranking and a look from a
/// distance; every tier above adds to what the tier below says.
enum ScoutDepth {
  /// No scout: the ranking and one vague line.
  glimpse,

  /// Basic: the usual shape and the one thing they do best.
  outline,

  /// Good: two strengths and a way to hurt them.
  detailed,

  /// Elite: all of that and how they are likely to approach YOU.
  full,
}

/// One thing a side does well, read either off how it sets up (the first
/// eight) or off the men it fields (the rest).
enum ScoutStrength {
  pressing,
  direct,
  possession,
  counter,
  deepDefence,
  wide,
  attacking,
  quickForwards,
  passingMidfield,
  hardRunning,
  setPieces,
  quickDefence,
}

/// One way to hurt a side. The tactical ones are the engine's own match-up
/// rules (`MatchEngine.matchupBonus`) turned round; the squad ones are the
/// lines it reads.
enum ScoutWeakness {
  spaceBehind,
  pressedBuildUp,
  deepBlock,
  longBall,
  slowDefence,
  aerial,
  poorPassing,
  tiringMidfield,
  bluntAttack,
}

/// How a side is likely to approach the manager's: the strength band
/// `AiTactics` picks its posture from.
enum ScoutApproach { takeTheGame, even, sitDeep }

/// A side's line readings (see `OpponentScouting.lineReadings`).
typedef LineReadings = ({
  double fwdPace,
  double defPace,
  double midPassing,
  double midLegs,
  double aerial,
  double aerialDefence,
});

/// What a side looks like from a distance, for a report without a scout.
enum ScoutLeaning { attacking, cautious, unclear }

/// The scout's report on one opponent: everything the dossier's "how they
/// play" section says, as meaning rather than text.
class ScoutReport {
  const ScoutReport({
    required this.depth,
    this.worldRank,
    this.leaning,
    this.formation,
    this.strengths = const [],
    this.weakness,
    this.approach,
  });

  final ScoutDepth depth;

  /// Their live world ranking position, null when there is none to read.
  final int? worldRank;

  /// [ScoutDepth.glimpse] only.
  final ScoutLeaning? leaning;

  /// The shape they use most. Null at [ScoutDepth.glimpse].
  final Formation? formation;

  /// Best first: one at [ScoutDepth.outline], up to two above it. Empty
  /// when nothing stands out (or at [ScoutDepth.glimpse]).
  final List<ScoutStrength> strengths;

  /// [ScoutDepth.detailed] and up, when there is one.
  final ScoutWeakness? weakness;

  /// [ScoutDepth.full] only.
  final ScoutApproach? approach;
}

/// Builds the scout's report from what really drives the opponent's play.
///
/// Every line is read off the model, never invented:
///  * the SHAPE and the TACTICAL strengths come from the postures
///    `AiTactics.forOpponent` gives the side, replayed for its recent
///    fixtures (or, with none, the postures it could take against the
///    manager, [AiTactics.typicalSetups]);
///  * the SQUAD strengths and weaknesses are the line attributes the engine
///    reads in a match (pace up front and at the back, the midfield's
///    passing and legs, the aerial threat at set pieces);
///  * the approach is the strength band the posture is picked from.
///
/// Deliberately NOT read: the counter the opponent prepares against the
/// manager's recent plans (`AiCounter`) and how predictable he has been.
/// That is hidden on purpose, so the report only ever says what a side
/// USUALLY does, from its history, never what it has planned for today.
abstract final class OpponentScouting {
  /// How many recent matches the report reads a side's habits from.
  static const int recentMatches = 6;

  /// A dial this far from 50 in the typical setup is a strength worth naming.
  static const int dialThreshold = 12;

  /// A line reading this many spreads above or below the world's usual reads
  /// as a strength or a weakness (see [standouts]): roughly the top and
  /// bottom sixth of the world.
  static const double lineThreshold = 1;

  /// The usual line readings of a side ([lineReadings], its best eleven in a
  /// 4-3-3) and how widely they spread (about one standard deviation),
  /// measured over all 211 nations of the seeded world on 2026-10-23.
  ///
  /// The attribute model keeps a line's three qualities close together, so
  /// the raw readings are small numbers that all lean positive (physical sits
  /// a little above the overall everywhere). Read raw, every side had "a
  /// quick back line" and nobody had "a midfield that passes well"; measured
  /// against what is usual, a reading means what it says.
  static const LineReadings worldUsual = (
    fwdPace: 0.9,
    defPace: 1.85,
    midPassing: 0.05,
    midLegs: 1.55,
    aerial: 1.45,
    aerialDefence: 2.05,
  );
  static const LineReadings worldSpread = (
    fwdPace: 0.65,
    defPace: 0.5,
    midPassing: 0.5,
    midLegs: 1.05,
    aerial: 0.45,
    aerialDefence: 0.55,
  );

  static ScoutDepth depthFor(StaffTier scout) => switch (scout) {
    StaffTier.none => ScoutDepth.glimpse,
    StaffTier.basic => ScoutDepth.outline,
    StaffTier.good => ScoutDepth.detailed,
    StaffTier.elite => ScoutDepth.full,
  };

  /// The shape used most in [recent] (newest first), a tie going to the one
  /// used most recently; [fallback] when there is no history.
  static Formation typicalFormation(
    List<Formation> recent, {
    required Formation fallback,
  }) {
    if (recent.isEmpty) return fallback;
    final counts = <Formation, int>{};
    for (final f in recent) {
      counts[f] = (counts[f] ?? 0) + 1;
    }
    var best = recent.first;
    for (final f in recent) {
      if (counts[f]! > counts[best]!) best = f;
    }
    return best;
  }

  /// The mean of [setups]' instructions: how the side typically sets up.
  static TacticalInstructions meanInstructions(List<AiSetup> setups) {
    if (setups.isEmpty) return const TacticalInstructions();
    int mean(int Function(TacticalInstructions) pick) =>
        (setups.fold<int>(0, (s, e) => s + pick(e.instructions)) /
                setups.length)
            .round();
    return TacticalInstructions(
      mentality: mean((i) => i.mentality),
      pressing: mean((i) => i.pressing),
      tempo: mean((i) => i.tempo),
      width: mean((i) => i.width),
      defensiveLine: mean((i) => i.defensiveLine),
      directness: mean((i) => i.directness),
    );
  }

  /// The tactical strengths of a typical setup [i], best first, each with how
  /// strongly it shows.
  static List<(ScoutStrength, double)> tacticalStrengths(
    TacticalInstructions i,
  ) {
    final out = <(ScoutStrength, double)>[];
    void add(ScoutStrength s, num score) {
      if (score >= dialThreshold) out.add((s, score.toDouble()));
    }

    // Deep, direct and quick is a counter-attacking side, not merely a
    // direct one: one sentence, not two. Only when the counter itself shows
    // clearly; otherwise the deep line and the long ball speak for
    // themselves.
    final counterScore = ((50 - i.defensiveLine) + (i.directness - 50)) / 2;
    final counter =
        i.defensiveLine <= 50 - dialThreshold &&
        i.directness >= 58 &&
        i.tempo >= 55 &&
        counterScore >= dialThreshold;
    add(ScoutStrength.pressing, i.pressing - 50);
    if (counter) {
      add(ScoutStrength.counter, counterScore);
    } else {
      add(ScoutStrength.direct, i.directness - 50);
      add(ScoutStrength.deepDefence, 50 - i.defensiveLine);
    }
    add(ScoutStrength.possession, 50 - i.directness);
    add(ScoutStrength.wide, i.width - 50);
    add(ScoutStrength.attacking, i.mentality - 50);
    out.sort((a, b) => b.$2.compareTo(a.$2));
    return out;
  }

  /// The line readings the engine takes off a fielded side, each as how far
  /// the attribute sits above (+) or below (-) that line's own overall.
  static LineReadings lineReadings(
    List<Player> xi,
    List<PlayerPosition> slots,
  ) {
    double reading(
      Set<PositionCategory> lines,
      int Function(PlayerAttributes) pick,
    ) {
      var attr = 0.0;
      var overall = 0.0;
      var n = 0;
      for (var i = 0; i < xi.length; i++) {
        final slot = i < slots.length ? slots[i] : xi[i].position;
        if (!lines.contains(slot.category)) continue;
        attr += pick(xi[i].attributes);
        overall += xi[i].overall;
        n++;
      }
      return n == 0 ? 0 : (attr - overall) / n;
    }

    return (
      fwdPace: reading({PositionCategory.forward}, (a) => a.physical),
      defPace: reading({PositionCategory.defender}, (a) => a.physical),
      midPassing: reading({PositionCategory.midfielder}, (a) => a.technical),
      midLegs: reading({PositionCategory.midfielder}, (a) => a.stamina),
      aerial: reading({
        PositionCategory.forward,
        PositionCategory.defender,
      }, (a) => a.physical),
      aerialDefence: reading({
        PositionCategory.defender,
        PositionCategory.goalkeeper,
      }, (a) => a.physical),
    );
  }

  /// [r] measured against the world: how many [worldSpread]s each reading
  /// sits from [worldUsual].
  static LineReadings standouts(LineReadings r) => (
    fwdPace: (r.fwdPace - worldUsual.fwdPace) / worldSpread.fwdPace,
    defPace: (r.defPace - worldUsual.defPace) / worldSpread.defPace,
    midPassing: (r.midPassing - worldUsual.midPassing) / worldSpread.midPassing,
    midLegs: (r.midLegs - worldUsual.midLegs) / worldSpread.midLegs,
    aerial: (r.aerial - worldUsual.aerial) / worldSpread.aerial,
    aerialDefence:
        (r.aerialDefence - worldUsual.aerialDefence) /
        worldSpread.aerialDefence,
  );

  /// The squad strengths of a fielded side, best first.
  static List<(ScoutStrength, double)> squadStrengths(
    List<Player> xi,
    List<PlayerPosition> slots, {
    bool setPieceSpecialist = false,
  }) => squadStrengthsOf(
    standouts(lineReadings(xi, slots)),
    setPieceSpecialist: setPieceSpecialist,
  );

  /// [squadStrengths] on readings already measured against the world ([z]).
  static List<(ScoutStrength, double)> squadStrengthsOf(
    LineReadings z, {
    bool setPieceSpecialist = false,
  }) =>
      <(ScoutStrength, double)>[
          (ScoutStrength.quickForwards, z.fwdPace),
          (ScoutStrength.quickDefence, z.defPace),
          (ScoutStrength.passingMidfield, z.midPassing),
          (ScoutStrength.hardRunning, z.midLegs),
          // A specialist's delivery (`PlayerTraits.setPieceFactor`) is worth
          // a full spread of aerial edge on top.
          (
            ScoutStrength.setPieces,
            z.aerial + (setPieceSpecialist ? lineThreshold : 0),
          ),
        ].where((e) => e.$2 >= lineThreshold).toList()
        ..sort((a, b) => b.$2.compareTo(a.$2));

  /// The plainest way to hurt a side: a tactical weakness of its typical
  /// setup [i] when it has one, otherwise its weakest line.
  static ScoutWeakness? weaknessOf(
    TacticalInstructions i,
    List<Player> xi,
    List<PlayerPosition> slots,
  ) {
    final tactical =
        <(ScoutWeakness, int)>[
          // A high line or a high press leaves space in behind (engine rule 1).
          (
            ScoutWeakness.spaceBehind,
            (i.defensiveLine > i.pressing ? i.defensiveLine : i.pressing) - 50,
          ),
          // A slow, short build-up is strangled by a press (rule 2).
          (ScoutWeakness.pressedBuildUp, 50 - i.directness),
          // A deep block is picked apart by patience (rule 4).
          (ScoutWeakness.deepBlock, 50 - i.defensiveLine),
          // The long ball dies against a deep line (rule 1, the smother).
          (ScoutWeakness.longBall, i.directness - 50),
        ].where((e) => e.$2 >= dialThreshold).toList()..sort(
          (a, b) => b.$2.compareTo(a.$2),
        );
    if (tactical.isNotEmpty) return tactical.first.$1;

    final r = standouts(lineReadings(xi, slots));
    final lines =
        <(ScoutWeakness, double)>[
            (ScoutWeakness.slowDefence, r.defPace),
            (ScoutWeakness.aerial, r.aerialDefence),
            (ScoutWeakness.poorPassing, r.midPassing),
            (ScoutWeakness.tiringMidfield, r.midLegs),
            (ScoutWeakness.bluntAttack, r.fwdPace),
          ].where((e) => e.$2 <= -lineThreshold).toList()
          ..sort((a, b) => a.$2.compareTo(b.$2));
    return lines.isEmpty ? null : lines.first.$1;
  }

  /// The band `AiTactics` picks a posture from, as an approach.
  static ScoutApproach approachFor({
    required double opponentStrength,
    required double playerStrength,
  }) {
    final diff = opponentStrength - playerStrength;
    if (diff >= 3) return ScoutApproach.takeTheGame;
    if (diff <= -3) return ScoutApproach.sitDeep;
    return ScoutApproach.even;
  }

  /// What a typical setup [i] looks like from a distance.
  static ScoutLeaning leaningOf(TacticalInstructions i) {
    if (i.mentality >= 55) return ScoutLeaning.attacking;
    if (i.mentality <= 45) return ScoutLeaning.cautious;
    return ScoutLeaning.unclear;
  }

  /// The whole report.
  ///
  /// [recentSetups] are the side's postures in its recent matches, newest
  /// first (see the provider for how they are replayed); [fallbackSetups]
  /// what it would typically do against the manager, read when there is no
  /// history. [xiFor] fields the side's best eleven in a shape, for the
  /// squad lines (always asked for the 4-3-3, see [worldUsual]).
  static ScoutReport build({
    required StaffTier scout,
    required int? worldRank,
    required List<AiSetup> recentSetups,
    required List<AiSetup> fallbackSetups,
    required List<Player> Function(Formation) xiFor,
    required double opponentStrength,
    required double playerStrength,
    bool Function(List<Player> xi)? hasSetPieceSpecialist,
  }) {
    final depth = depthFor(scout);
    final setups = recentSetups.isNotEmpty ? recentSetups : fallbackSetups;
    final typical = meanInstructions(setups);
    if (depth == ScoutDepth.glimpse) {
      return ScoutReport(
        depth: depth,
        worldRank: worldRank,
        leaning: leaningOf(typical),
      );
    }
    final formation = typicalFormation(
      [for (final s in recentSetups) s.formation],
      fallback: typicalFormation(
        [for (final s in fallbackSetups) s.formation],
        fallback: Formation.f433,
      ),
    );
    // The squad's lines are read off its best eleven in the neutral 4-3-3,
    // the shape [worldUsual] was measured in: a lone striker's pace is not
    // the same reading as a front three's, and the comparison has to be
    // like for like.
    final xi = xiFor(Formation.f433);
    final slots = Formation.f433.positions;
    final tactical = [for (final e in tacticalStrengths(typical)) e.$1];
    final squad = [
      for (final e in squadStrengths(
        xi,
        slots,
        setPieceSpecialist: hasSetPieceSpecialist?.call(xi) ?? false,
      ))
        e.$1,
    ];
    // The best of how they set up first, then the best of who they have:
    // two different kinds of thing say more than two of one kind.
    final strengths = <ScoutStrength>[];
    if (tactical.isNotEmpty) strengths.add(tactical.first);
    if (squad.isNotEmpty) strengths.add(squad.first);
    for (final s in [...tactical.skip(1), ...squad.skip(1)]) {
      if (strengths.length >= 2) break;
      strengths.add(s);
    }
    final wanted = depth == ScoutDepth.outline ? 1 : 2;
    return ScoutReport(
      depth: depth,
      worldRank: worldRank,
      formation: formation,
      strengths: strengths.take(wanted).toList(),
      weakness: depth.index >= ScoutDepth.detailed.index
          ? weaknessOf(typical, xi, slots)
          : null,
      approach: depth == ScoutDepth.full
          ? approachFor(
              opponentStrength: opponentStrength,
              playerStrength: playerStrength,
            )
          : null,
    );
  }
}
