import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/repositories/tactic_familiarity_repository.dart';
import 'package:fnm/domain/services/match/ai_counter.dart';
import 'package:fnm/domain/services/match/ai_tactics.dart';
import 'package:fnm/domain/services/nation/nation_identity.dart';
import 'package:fnm/domain/services/tactics/best_eleven.dart';
import 'package:fnm/domain/services/tactics/team_chemistry.dart';

import '../../helpers/fixtures.dart';

/// A plain AI posture to counter FROM: every dial at 50, a 4-4-2.
const AiSetup _base = (
  formation: Formation.f442,
  instructions: TacticalInstructions(),
);

ScoutedPlan _scouted(
  Formation formation,
  TacticalInstructions instructions, {
  double predictability = 1,
}) => ScoutedPlan(
  formation: formation,
  instructions: instructions,
  predictability: predictability,
);

void main() {
  group('TeamChemistry.decodePlanKey', () {
    test('inverts planKey, to bands of ten', () {
      for (final x in const [
        TacticalInstructions(),
        TacticalInstructions(
          mentality: 90,
          pressing: 10,
          tempo: 74,
          width: 0,
          defensiveLine: 100,
          directness: 33,
        ),
        TacticalInstructions(
          mentality: 15,
          pressing: 86,
          tempo: 41,
          width: 66,
          defensiveLine: 25,
          directness: 58,
        ),
      ]) {
        int band(int v) => (v / 10).round() * 10;
        expect(
          TeamChemistry.decodePlanKey(TeamChemistry.planKey(x)),
          TacticalInstructions(
            mentality: band(x.mentality),
            pressing: band(x.pressing),
            tempo: band(x.tempo),
            width: band(x.width),
            defensiveLine: band(x.defensiveLine),
            directness: band(x.directness),
          ),
        );
      }
    });

    test('0 means never fielded and has no plan to decode', () {
      expect(() => TeamChemistry.decodePlanKey(0), throwsArgumentError);
    });
  });

  group('ScoutedPlan.fromDrilling', () {
    test('legacy rows (a key on several shapes): the most predictable', () {
      // Saves recorded before 2026-10-17 kept a key on every shape fielded.
      // The most predictable is the one most likely played last.
      const plan = TacticalInstructions(width: 80, directness: 20);
      final scouted = ScoutedPlan.fromDrilling({
        // Most drilled, but never stored a plan (a pre-plan-key row).
        Formation.f433: (familiarity: 0.9, predictability: 0.9, lastPlanKey: 0),
        Formation.f343: (
          familiarity: 0.6,
          predictability: 0.4,
          lastPlanKey: TeamChemistry.planKey(plan),
        ),
        Formation.f442: (
          familiarity: 0.2,
          predictability: 0.1,
          lastPlanKey: TeamChemistry.planKey(const TacticalInstructions()),
        ),
      });
      expect(scouted, isNotNull);
      expect(scouted!.formation, Formation.f343);
      expect(scouted.instructions, plan);
      expect(scouted.predictability, 0.4);
    });

    test('an unreadable stored key means no history, not an exception', () {
      // 5 is no plan key (the leading 1 of a key sits six base-11 digits
      // up). One such row must not break the preview or an advance.
      final rows = <Formation, ShapeDrilling>{
        Formation.f433: (familiarity: 0.8, predictability: 0.8, lastPlanKey: 5),
      };
      expect(ScoutedPlan.fromDrilling(rows), isNull);
      expect(
        AiCounter.forFixture(
          base: _base,
          drilling: rows,
          opponentStrength: 90,
          style: NationStyle.balanced,
          seed: 1,
        ),
        _base,
      );
      expect(TeamChemistry.tryDecodePlanKey(5), isNull);
      expect(TeamChemistry.tryDecodePlanKey(-3), isNull);
    });

    test('no stored plan, nothing to scout', () {
      expect(ScoutedPlan.fromDrilling(const {}), isNull);
      expect(
        ScoutedPlan.fromDrilling({
          Formation.f433: (
            familiarity: 0.5,
            predictability: 0.5,
            lastPlanKey: 0,
          ),
        }),
        isNull,
      );
    });
  });

  group('AiTactics.readStrength', () {
    test('the best eleven by overall, positions ignored', () {
      // Eleven forwards at 90 and four defenders at 60: a best 4-3-3 would
      // field the defenders and read lower; the posture and the counter read
      // the eleven best men, on the live path and the skip path alike.
      final pool = [
        for (var i = 0; i < 11; i++)
          player(
            id: i,
            nationId: 1,
            position: PlayerPosition.st,
            attributes: flatAttributes(90),
          ),
        for (var i = 11; i < 15; i++)
          player(
            id: i,
            nationId: 1,
            position: PlayerPosition.cb,
            attributes: flatAttributes(60),
          ),
      ];
      expect(AiTactics.readStrength(pool), 90);
      expect(AiTactics.readStrength(pool.skip(5)), (6 * 90 + 4 * 60) / 10);
      expect(AiTactics.readStrength(const []), 0);
    });
  });

  group('reading the most recent plan', () {
    const a = TacticalInstructions(pressing: 85, defensiveLine: 75);
    const b = TacticalInstructions(directness: 20, tempo: 40);

    Map<Formation, ShapeDrilling> play(
      Map<Formation, ShapeDrilling> rows,
      Formation shape,
      TacticalInstructions plan,
      int matches,
    ) {
      var out = rows;
      for (var i = 0; i < matches; i++) {
        out = TeamChemistry.afterMatch(
          out,
          shape,
          planKey: TeamChemistry.planKey(plan),
        );
      }
      return out;
    }

    // Full-quality opponent, so the read is just the predictability term.
    double readOf(ScoutedPlan s) =>
        AiCounter.read(predictability: s.predictability, opponentStrength: 90);
    final weak = AiCounter.read(predictability: 0, opponentStrength: 90);

    test('a long run on one plan is read sharply', () {
      final rows = play(const {}, Formation.f433, a, 20);
      final s = ScoutedPlan.fromDrilling(rows)!;
      expect(s.formation, Formation.f433);
      expect(
        s.instructions,
        TeamChemistry.decodePlanKey(TeamChemistry.planKey(a)),
      );
      expect(s.predictability, closeTo(0.95, 1e-9));
      expect(readOf(s), greaterThan(0.9));
    });

    test('a change of plan is read weakly, as the new plan', () {
      var rows = play(const {}, Formation.f433, a, 15);
      rows = play(rows, Formation.f433, b, 1);
      final s = ScoutedPlan.fromDrilling(rows)!;
      expect(
        s.instructions,
        TeamChemistry.decodePlanKey(TeamChemistry.planKey(b)),
      );
      expect(readOf(s), closeTo(weak, 1e-9));
      // ...and a second match on it is the first step of a new run.
      final again = ScoutedPlan.fromDrilling(play(rows, Formation.f433, b, 1))!;
      expect(again.predictability, closeTo(0.05, 1e-9));
    });

    test('returning to an old plan is not a continued run', () {
      var rows = play(const {}, Formation.f433, a, 15);
      rows = play(rows, Formation.f433, b, 1);
      rows = play(rows, Formation.f433, a, 1);
      final s = ScoutedPlan.fromDrilling(rows)!;
      expect(readOf(s), closeTo(weak, 1e-9));
    });

    test('a formation change is read from the new shape', () {
      var rows = play(const {}, Formation.f433, a, 15);
      rows = play(rows, Formation.f532, a, 1);
      // The 4-3-3 is still far more familiar (0.9 against 0.08)...
      expect(
        rows[Formation.f433]!.familiarity,
        greaterThan(rows[Formation.f532]!.familiarity),
      );
      // ...but the video shows the back five.
      final s = ScoutedPlan.fromDrilling(rows)!;
      expect(s.formation, Formation.f532);
      expect(readOf(s), closeTo(weak, 1e-9));
    });
  });

  group('AiCounter.apply', () {
    test('no history, no counter', () {
      final out = AiCounter.apply(
        base: _base,
        scouted: null,
        opponentStrength: 90,
        style: NationStyle.balanced,
        seed: 7,
      );
      expect(identical(out, _base) || out == _base, isTrue);
    });

    test('a high line draws a direct opponent', () {
      final out = AiCounter.apply(
        base: _base,
        scouted: _scouted(
          Formation.f433,
          const TacticalInstructions(defensiveLine: 80),
        ),
        opponentStrength: 85,
        style: NationStyle.balanced,
        seed: 1,
      );
      expect(
        out.instructions.directness,
        greaterThan(_base.instructions.directness + 10),
      );
    });

    test('a weak, rigid side barely reads you', () {
      // A pronounced plan, fully predictable, in a shape with no extra men at
      // either end (so the only counter on offer is in the sliders).
      final scouted = _scouted(
        Formation.f433,
        const TacticalInstructions(
          mentality: 70,
          pressing: 80,
          width: 70,
          defensiveLine: 75,
          directness: 30,
        ),
      );
      var unchanged = 0;
      for (var seed = 0; seed < 200; seed++) {
        final out = AiCounter.apply(
          base: _base,
          scouted: scouted,
          opponentStrength: 60,
          style: NationStyle.defensive,
          seed: seed,
        );
        final a = out.instructions;
        final b = _base.instructions;
        for (final (x, y) in [
          (a.mentality, b.mentality),
          (a.pressing, b.pressing),
          (a.tempo, b.tempo),
          (a.width, b.width),
          (a.defensiveLine, b.defensiveLine),
          (a.directness, b.directness),
        ]) {
          // The weakest read is 0.3 of a full one (`AiCounter.read`), so no
          // slider moves more than 30% of the largest full answer (a dial at
          // the edge, 50 points of shift). A full read moves up to 40.
          expect(
            (x - y).abs(),
            lessThanOrEqualTo((50 * AiCounter.counterGain * 0.3).ceil()),
          );
        }
        if (out.formation == _base.formation) unchanged++;
      }
      expect(unchanged / 200, greaterThanOrEqualTo(0.95));
    });

    test('a weak, rigid side rarely answers a lopsided shape in kind', () {
      // Unlike the case above, the scouted shape here IS lopsided enough to be
      // worth a back five, so the formation roll is live. A weak side (read
      // 0.3) with a rigid identity (flexibility 0.4) takes it at most 12% of
      // the time.
      final scouted = _scouted(
        Formation.f424,
        const TacticalInstructions(mentality: 90),
      );
      var changed = 0;
      for (var seed = 0; seed < 500; seed++) {
        final out = AiCounter.apply(
          base: _base,
          scouted: scouted,
          opponentStrength: 60,
          style: NationStyle.defensive,
          seed: seed,
        );
        if (out.formation != _base.formation) changed++;
      }
      expect(changed / 500, lessThanOrEqualTo(0.15));
    });

    test('a deep block draws a patient opponent', () {
      final out = AiCounter.apply(
        base: _base,
        scouted: _scouted(
          Formation.f433,
          const TacticalInstructions(defensiveLine: 20),
        ),
        opponentStrength: 85,
        style: NationStyle.balanced,
        seed: 1,
      );
      // Ten points shorter (the scouted press, at a neutral 50, still reads
      // as part-exposed and pulls the other way by a little).
      expect(
        out.instructions.directness,
        lessThan(_base.instructions.directness - 5),
      );
    });

    test('a direct side draws a deeper line', () {
      final out = AiCounter.apply(
        base: _base,
        scouted: _scouted(
          Formation.f433,
          const TacticalInstructions(directness: 80),
        ),
        opponentStrength: 85,
        style: NationStyle.balanced,
        seed: 1,
      );
      expect(
        out.instructions.defensiveLine,
        lessThan(_base.instructions.defensiveLine - 10),
      );
    });

    test('even a neutral plan draws a small answer', () {
      // No safe middle: the middle of the line, the press and the build-up
      // is still exposed, so a side that reads a neutral plan leans into it
      // a little (going longer, pressing more), and no further.
      final out = AiCounter.apply(
        base: _base,
        scouted: _scouted(Formation.f433, const TacticalInstructions()),
        opponentStrength: 85,
        style: NationStyle.balanced,
        seed: 1,
      );
      final i = out.instructions;
      final b = _base.instructions;
      expect(
        i.directness,
        inInclusiveRange(b.directness + 3, b.directness + 15),
      );
      expect(i.pressing, inInclusiveRange(b.pressing + 3, b.pressing + 15));
      expect(i.width, b.width);
      expect(i.mentality, b.mentality);
    });

    test('three up front meets a back five, sometimes', () {
      final scouted = _scouted(
        Formation.f424,
        const TacticalInstructions(mentality: 90),
      );
      var backFive = 0;
      for (var seed = 0; seed < 500; seed++) {
        final out = AiCounter.apply(
          base: _base,
          scouted: scouted,
          opponentStrength: 85,
          style: NationStyle.balanced,
          seed: seed,
        );
        if (out.formation == Formation.f532 ||
            out.formation == Formation.f541) {
          backFive++;
        }
      }
      expect(backFive / 500, inInclusiveRange(0.40, 0.90));
    });
  });

  group('AiCounter.forFixture', () {
    test('the plan set for today is not read', () {
      // The manager's CURRENT tactic is not an input to the opponent's setup
      // at all: only the stored rows (written after each match he has played)
      // are. Two previews of the same fixture with the same stored history
      // must give the same opponent, whatever he has set up for today.
      final stored = <Formation, ShapeDrilling>{
        Formation.f433: (
          familiarity: 0.7,
          predictability: 0.8,
          lastPlanKey: TeamChemistry.planKey(
            const TacticalInstructions(defensiveLine: 85, pressing: 80),
          ),
        ),
      };
      AiSetup preview(TacticalInstructions today) {
        // `today` is deliberately unused below: there is no parameter to pass
        // it through, which is the guarantee this test pins.
        final base = AiTactics.forOpponent(
          opponentStrength: 82,
          playerStrength: 80,
          seed: AiTactics.fixtureSeed(
            opponentId: 9,
            fixtureId: 1234,
            rngSeed: 42,
          ),
        );
        return AiCounter.forFixture(
          base: base,
          drilling: stored,
          opponentStrength: 82,
          style: NationStyle.balanced,
          seed: AiCounter.fixtureSeed(
            opponentId: 9,
            fixtureId: 1234,
            rngSeed: 42,
          ),
        );
      }

      final a = preview(const TacticalInstructions(mentality: 95));
      final b = preview(const TacticalInstructions(defensiveLine: 10));
      expect(a, b);
      // And the stored history really was read (otherwise the equality above
      // proves nothing).
      expect(
        a.instructions.directness,
        greaterThan(
          AiTactics.forOpponent(
            opponentStrength: 82,
            playerStrength: 80,
            seed: AiTactics.fixtureSeed(
              opponentId: 9,
              fixtureId: 1234,
              rngSeed: 42,
            ),
          ).instructions.directness,
        ),
      );
    });
  });

  test('a thin pool still fields eleven after a shape change', () {
    final pool = [
      player(id: 1, nationId: 1, position: PlayerPosition.gk),
      for (var i = 2; i <= 4; i++)
        player(id: i, nationId: 1, position: PlayerPosition.cb),
      for (var i = 5; i <= 11; i++)
        player(id: i, nationId: 1, position: PlayerPosition.cm),
      for (var i = 12; i <= 14; i++)
        player(id: i, nationId: 1, position: PlayerPosition.st),
    ];
    final xi = bestEleven(Formation.f541, pool);
    expect(xi.whereType<int>().length, 11);
  });

  test('predictability is no longer charged in the chemistry factor', () {
    for (final f in const [0.0, 0.5, 1.0]) {
      expect(TeamChemistry.factor(f, 1), TeamChemistry.factor(f, 0));
    }
  });
}
