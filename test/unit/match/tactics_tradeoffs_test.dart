import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/shape_profile.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/tactics_lab.dart';

MatchTeam _team(
  int nationId,
  TacticalInstructions instructions, [
  Formation formation = Formation.f433,
  int forwardPhysical = 80,
  int defenderPhysical = 80,
]) {
  final positions = formation.positions;
  return MatchTeam(
    nationId: nationId,
    formation: formation,
    instructions: instructions,
    xi: [
      for (var i = 0; i < 11; i++)
        player(
          id: nationId * 100 + i,
          nationId: nationId,
          position: positions[i],
          attributes: switch (positions[i].category) {
            PositionCategory.forward => PlayerAttributes(
              physical: forwardPhysical,
              technical: 80,
              stamina: 80,
            ),
            PositionCategory.defender => PlayerAttributes(
              physical: defenderPhysical,
              technical: 80,
              stamina: 80,
            ),
            _ => flatAttributes(80),
          },
        ),
    ],
  );
}

/// Goals (for, against) per game of the plan side against an identical
/// default-instruction side. Every seed is played both ways round on a neutral
/// venue so the venue slot cancels exactly.
({double goalsFor, double goalsAgainst}) _plan(
  TacticalInstructions plan, {
  int seeds = 2000,
}) {
  const engine = MatchEngine();
  var goalsFor = 0;
  var goalsAgainst = 0;
  for (var i = 0; i < seeds; i++) {
    for (final planAtHome in const [true, false]) {
      final a = _team(1, plan);
      final b = _team(2, const TacticalInstructions());
      final r = engine.play(
        home: planAtHome ? a : b,
        away: planAtHome ? b : a,
        rng: SeededRng.forFixture(0x7ADE, i),
        neutralVenue: true,
      );
      goalsFor += planAtHome ? r.homeScore : r.awayScore;
      goalsAgainst += planAtHome ? r.awayScore : r.homeScore;
    }
  }
  final n = seeds * 2;
  return (goalsFor: goalsFor / n, goalsAgainst: goalsAgainst / n);
}

LabPlan _lab(String name) => labPlans.firstWhere((p) => p.name == name);

/// Total goals per game and the share of 4+ goal margins when two identical
/// sides play [a] against [b], every seed both ways round.
({double total, double bigMargin}) _mirror(
  LabPlan a,
  LabPlan b, {
  int seeds = 2000,
}) {
  const engine = MatchEngine();
  var goals = 0;
  var routs = 0;
  for (var i = 0; i < seeds; i++) {
    for (final aAtHome in const [true, false]) {
      final x = _team(1, a.instructions, a.formation);
      final y = _team(2, b.instructions, b.formation);
      final r = engine.play(
        home: aAtHome ? x : y,
        away: aAtHome ? y : x,
        rng: SeededRng.forFixture(0x7ADE, i),
        neutralVenue: true,
      );
      goals += r.homeScore + r.awayScore;
      if ((r.homeScore - r.awayScore).abs() >= 4) routs++;
    }
  }
  final n = seeds * 2;
  return (total: goals / n, bigMargin: routs / n);
}

/// Goal difference per game of [plan] against [opp] where the opponent's
/// forwards run at [forwardPhysical] and the plan side's defenders at
/// [defenderPhysical]; every seed both ways round, neutral venue.
double _goalDifference(
  TacticalInstructions plan,
  TacticalInstructions opp, {
  required int forwardPhysical,
  required int defenderPhysical,
  int seeds = 2000,
}) {
  const engine = MatchEngine();
  var gd = 0;
  for (var i = 0; i < seeds; i++) {
    for (final planAtHome in const [true, false]) {
      final a = _team(1, plan, Formation.f433, 80, defenderPhysical);
      final b = _team(2, opp, Formation.f433, forwardPhysical, 80);
      final r = engine.play(
        home: planAtHome ? a : b,
        away: planAtHome ? b : a,
        rng: SeededRng.forFixture(0x7ADE, i),
        neutralVenue: true,
      );
      gd += planAtHome ? r.homeScore - r.awayScore : r.awayScore - r.homeScore;
    }
  }
  return gd / (seeds * 2);
}

/// Goal difference per game of lab plan [a] against lab plan [b] between equal
/// squads (80 across, formation-driven slots aside), every seed both ways round
/// on a neutral venue.
double _planGd(LabPlan a, LabPlan b, {int seeds = 2000}) {
  const engine = MatchEngine();
  var gd = 0;
  for (var i = 0; i < seeds; i++) {
    for (final aAtHome in const [true, false]) {
      final x = _team(1, a.instructions, a.formation);
      final y = _team(2, b.instructions, b.formation);
      final r = engine.play(
        home: aAtHome ? x : y,
        away: aAtHome ? y : x,
        rng: SeededRng.forFixture(0x7ADE, i),
        neutralVenue: true,
      );
      gd += aAtHome ? r.homeScore - r.awayScore : r.awayScore - r.homeScore;
    }
  }
  return gd / (seeds * 2);
}

/// Mean energy of a side's starting XI at the final whistle.
double _finalEnergy(TacticalInstructions plan, {int seeds = 300}) {
  const engine = MatchEngine();
  var sum = 0.0;
  var count = 0;
  for (var i = 0; i < seeds; i++) {
    final r = engine.play(
      home: _team(1, plan),
      away: _team(2, const TacticalInstructions()),
      rng: SeededRng.forFixture(0x7ADE, i),
      neutralVenue: true,
    );
    for (var k = 0; k < 11; k++) {
      sum += r.energyByPlayer[100 + k] ?? 100;
      count++;
    }
  }
  return sum / count;
}

void main() {
  group('openness', () {
    final neutral = _mirror(_lab('neutral'), _lab('neutral'));
    test('two attacking sides play a wild game', () {
      // 4.70 goals a game against the neutral mirror's 2.58 (1.82x). The
      // ceiling is the other half of the bar: before the 2026-10-16 tuning
      // this mirror ran to 8 goals a game, a basketball score.
      final wild = _mirror(_lab('allOutAttack'), _lab('allOutAttack'));
      expect(wild.total, greaterThanOrEqualTo(neutral.total * 1.4));
      expect(wild.total, lessThanOrEqualTo(neutral.total * 2.0));
    });
    test('two buses play a tight one', () {
      // 1.19 goals a game.
      final tight = _mirror(_lab('parkTheBus'), _lab('parkTheBus'));
      expect(tight.total, lessThanOrEqualTo(neutral.total * 0.7));
    });
    test('openness never turns equals into routs', () {
      // 5.3% of all-out mirrors are decided by four or more (the neutral
      // mirror: 3.4%). Goals arriving at a steady rate would give about 10%
      // at 4.7 a game; what holds it down is the scoreline bend in the engine
      // (`MatchEngine._scorelineOpenness`): when both sides have opened the
      // game, the side in front sits on its lead and the side behind chases.
      // Until 2026-10-16 this
      // mirror was 8 goals a game with 14.5% routs.
      final wild = _mirror(_lab('allOutAttack'), _lab('allOutAttack'));
      expect(wild.bigMargin, lessThanOrEqualTo(0.06));
    });
    double mult(LabPlan h, LabPlan a) => MatchEngine.openness(
      home: h.instructions,
      away: a.instructions,
      homeAttackers: ShapeProfile.of(h.formation.positions).attackers,
      awayAttackers: ShapeProfile.of(a.formation.positions).attackers,
    );
    test('the multiplier itself opens bold pairs and closes cautious ones', () {
      expect(
        mult(_lab('allOutAttack'), _lab('allOutAttack')),
        greaterThan(1.2),
      );
      expect(mult(_lab('parkTheBus'), _lab('parkTheBus')), lessThan(0.85));
      expect(mult(_lab('neutral'), _lab('neutral')), 1.0);
    });
    test('the multiplier is symmetric in home and away', () {
      final ab = mult(_lab('allOutAttack'), _lab('parkTheBus'));
      final ba = mult(_lab('parkTheBus'), _lab('allOutAttack'));
      expect(ab, ba);
    });
    test('the multiplier rises with one side\'s mentality', () {
      double at(int m) => MatchEngine.openness(
        home: TacticalInstructions(mentality: m),
        away: const TacticalInstructions(),
        homeAttackers: ShapeProfile.neutralAttackers,
        awayAttackers: ShapeProfile.neutralAttackers,
      );
      for (var m = 0; m < 100; m += 10) {
        expect(at(m + 10), greaterThanOrEqualTo(at(m)));
      }
      expect(at(100), greaterThan(at(0)));
    });
    test('the extremes reach the documented range', () {
      const bold = TacticalInstructions(mentality: 100, pressing: 100);
      const meek = TacticalInstructions(mentality: 0, pressing: 0);
      double both(TacticalInstructions i, double att) => MatchEngine.openness(
        home: i,
        away: i,
        homeAttackers: att,
        awayAttackers: att,
      );
      expect(both(bold, 6), closeTo(1 + kOpenUp, 1e-9));
      expect(both(meek, 0), closeTo(1 - kOpenDown, 1e-9));
    });
    test('one bold side opens a game, it takes both to shut it', () {
      // The bolder side's commitment sets how open the game is, so a second
      // all-out side adds nothing to the MULTIPLIER (it adds its own flat
      // terms). Caution is averaged: one bus closes the game halfway.
      final allOut = _lab('allOutAttack');
      final bus = _lab('parkTheBus');
      final n = _lab('neutral');
      expect(mult(allOut, n), closeTo(mult(allOut, allOut), 1e-9));
      expect(mult(bus, n), closeTo((1 + mult(bus, bus)) / 2, 1e-9));
    });
    test('neutral against neutral is exactly 1.0', () {
      expect(
        MatchEngine.openness(
          home: const TacticalInstructions(),
          away: const TacticalInstructions(),
          homeAttackers: ShapeProfile.neutralAttackers,
          awayAttackers: ShapeProfile.neutralAttackers,
        ),
        1.0,
      );
    });
  });

  group('mentality trade-off', () {
    test('all-out mentality concedes clearly more', () {
      // Concedes 1.65 a game against 1.29 (1.28x), and that is close to all
      // it gains: it scores 1.67 (2026-10-17). Before the 2026-10-16 build
      // the same mentality conceded 1.257x but scored far more than it let
      // in, because its flat attacking gain was twice its defensive cost; the
      // second assertion is the one that would catch that coming back.
      final allOut = _plan(const TacticalInstructions(mentality: 90));
      final mirror = _plan(const TacticalInstructions(mentality: 50));
      expect(
        allOut.goalsAgainst,
        greaterThanOrEqualTo(mirror.goalsAgainst * 1.2),
      );
      final gained = allOut.goalsFor - mirror.goalsFor;
      final conceded = allOut.goalsAgainst - mirror.goalsAgainst;
      expect(conceded, greaterThanOrEqualTo(gained * 0.85));
    });
    test('all-out is still a slight net positive against a passive side', () {
      // +0.040 a game against a side at mentality 30 (2026-10-17). Attacking
      // must not be a loss everywhere, or nobody would ever do it; it must
      // not be a clear win either, or everybody would.
      final gd = _goalDifference(
        const TacticalInstructions(mentality: 90),
        const TacticalInstructions(mentality: 30),
        forwardPhysical: 80,
        defenderPhysical: 80,
      );
      expect(gd, inInclusiveRange(0.0, 0.15));
    });
  });

  group('pressing trade-off', () {
    test('a high press creates more and concedes more', () {
      // 1.353 for and 1.362 against (2026-10-17), on a base of 1.290 each
      // way: the press bites the neutral build-up and the neutral side finds
      // the space behind it (both read with the neutral exposure), and the
      // press opens the game. Before the 2026-10-16 tuning it conceded LESS
      // than the base.
      final base = _plan(const TacticalInstructions());
      final press = _plan(const TacticalInstructions(pressing: 90));
      expect(press.goalsFor, greaterThan(base.goalsFor + 0.03));
      expect(press.goalsAgainst, greaterThan(base.goalsAgainst + 0.03));
    });
    test('a press is punished by direct pace', () {
      const press = TacticalInstructions(pressing: 90, defensiveLine: 80);
      final fast = _goalDifference(
        press,
        _lab('counter').instructions,
        forwardPhysical: 90,
        defenderPhysical: 70,
      );
      final slow = _goalDifference(
        press,
        _lab('possession').instructions,
        forwardPhysical: 90,
        defenderPhysical: 70,
      );
      // -1.05 against -0.11.
      expect(fast, lessThan(slow - 0.25));
    });
    test('a press against slow forwards still loses to a direct side', () {
      // The space-behind term is SIGNED by the pace duel, so a press with
      // quick backs against slow forwards gains rather than pays. It must not
      // make pressing the answer to every slow side: the counter-attacking
      // plan still beats it (-0.10 for the press at 1000 seeds).
      final gd = _goalDifference(
        _lab('highPress').instructions,
        _lab('counter').instructions,
        forwardPhysical: 60,
        defenderPhysical: 80,
      );
      expect(gd, lessThan(0));
    });
    test('the punishment grows with the pace of the side pressed', () {
      // Defender pace is the only thing that moves, and it moves for a
      // pressing side and a non-pressing one alike, so what is left after the
      // subtraction is the press-specific cost of being out-run.
      double outrun(TacticalInstructions plan) =>
          _goalDifference(
            plan,
            _lab('counter').instructions,
            forwardPhysical: 90,
            defenderPhysical: 70,
          ) -
          _goalDifference(
            plan,
            _lab('counter').instructions,
            forwardPhysical: 90,
            defenderPhysical: 90,
          );
      // -0.46 against -0.33.
      final pressed = outrun(const TacticalInstructions(pressing: 90));
      final unpressed = outrun(const TacticalInstructions());
      expect(pressed, lessThan(unpressed - 0.08));
    });
    test('pressing tires a side', () {
      // 5.8 points of energy down at the final whistle. The press's share of
      // the drain settled at /200 in the 2026-10-16 tuning (see
      // `MatchEngine._deplete`); it was /150 when this bound was 6.
      final pressing = _finalEnergy(const TacticalInstructions(pressing: 90));
      final normal = _finalEnergy(const TacticalInstructions());
      expect(pressing, lessThan(normal - 5));
    });
  });

  group('no safe middle', () {
    test('two neutral sides get nothing from the width match-up', () {
      expect(
        MatchEngine.widthMatchup(attackerWidth: 50, defenderWidth: 50),
        0.0,
      );
      // A neutral attacker gets nothing whatever the defence does...
      for (final w in const [0, 25, 50, 75, 100]) {
        expect(
          MatchEngine.widthMatchup(attackerWidth: 50, defenderWidth: w),
          0,
        );
      }
      // ...while a committed attacker finds a neutral shape exposed.
      expect(
        MatchEngine.widthMatchup(attackerWidth: 85, defenderWidth: 50),
        greaterThan(0),
      );
      expect(
        MatchEngine.widthMatchup(attackerWidth: 15, defenderWidth: 50),
        greaterThan(0),
      );
    });
    test(
      'a neutral mirror scores exactly what it did before the re-anchor',
      () {
        // Recorded at b34fa9e (before Task 5): 10324 goals over the 4000 games
        // of 2000 seeds both ways round, neutral venue.
        final n = _lab('neutral');
        final m = _mirror(n, n);
        expect(m.total * 4000, closeTo(10324, 1e-6));
      },
    );
    // +0.092 on average (counter +0.127, highPress +0.020, possession +0.171,
    // wide +0.051; 2026-10-17). It read -0.03 before the 2026-10-16 tuning,
    // when the 3-4-3's shape costs alone lost the wide plan 0.26 a game.
    test('a committed plan beats neutral on average', () {
      final neutral = _lab('neutral');
      const names = ['counter', 'highPress', 'possession', 'wide'];
      final mean =
          names.map((n) => _planGd(_lab(n), neutral)).reduce((a, b) => a + b) /
          names.length;
      expect(mean, greaterThan(0.05));
    });

    /// Best goal difference any other lab plan achieves against [target]
    /// between equal squads, with that plan's name.
    ({String name, double gd}) bestCounter(String target) {
      ({String name, double gd})? best;
      for (final p in labPlans) {
        if (p.name == target) continue;
        final gd = _planGd(p, _lab(target));
        if (best == null || gd > best.gd) best = (name: p.name, gd: gd);
      }
      return best!;
    }

    test('most plans have a counter', () {
      for (final target in const [
        'neutral',
        'parkTheBus',
        'possession',
        'wide',
      ]) {
        final best = bestCounter(target);
        expect(
          best.gd,
          greaterThanOrEqualTo(0.15),
          reason: '$target: best counter ${best.name} at ${best.gd}',
        );
      }
    });

    // Best counters (2026-10-17): allOutAttack by counter +0.44, highPress by
    // counter +0.49, counter by possession +0.21 (the patience term), and in
    // the case above neutral by possession +0.17, parkTheBus by possession
    // +0.32, possession by highPress +0.23, wide by counter +0.18 (the back
    // three term).
    test('allOutAttack, highPress and counter have a counter', () {
      for (final target in const ['allOutAttack', 'highPress', 'counter']) {
        final best = bestCounter(target);
        expect(
          best.gd,
          greaterThanOrEqualTo(0.15),
          reason: '$target: best counter ${best.name} at ${best.gd}',
        );
      }
    });
  });
}
