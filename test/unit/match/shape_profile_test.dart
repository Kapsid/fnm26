import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/shape_profile.dart';

import '../../helpers/fixtures.dart';

MatchTeam _team(int nationId, Formation formation) {
  final positions = formation.positions;
  return MatchTeam(
    nationId: nationId,
    formation: formation,
    instructions: const TacticalInstructions(),
    xi: [
      for (var i = 0; i < 11; i++)
        player(
          id: nationId * 100 + i,
          nationId: nationId,
          position: positions[i],
          attributes: flatAttributes(82),
        ),
    ],
  );
}

/// Goals (for, against) of [shape] against a 4-3-3, every seed played both
/// ways round on a neutral venue so the venue slot cancels exactly.
({double goalsFor, double goalsAgainst}) _versus433(
  Formation shape, {
  int seeds = 2000,
}) {
  const engine = MatchEngine();
  var goalsFor = 0;
  var goalsAgainst = 0;
  for (var i = 0; i < seeds; i++) {
    for (final shapeAtHome in const [true, false]) {
      final a = _team(1, shape);
      final b = _team(2, Formation.f433);
      final r = engine.play(
        home: shapeAtHome ? a : b,
        away: shapeAtHome ? b : a,
        rng: SeededRng.forFixture(0x5A9E, i),
        neutralVenue: true,
      );
      goalsFor += shapeAtHome ? r.homeScore : r.awayScore;
      goalsAgainst += shapeAtHome ? r.awayScore : r.homeScore;
    }
  }
  final n = seeds * 2;
  return (goalsFor: goalsFor / n, goalsAgainst: goalsAgainst / n);
}

void main() {
  group('ShapeProfile', () {
    test('attackers fall and defenders rise from 4-2-4 to 4-3-3 to 5-4-1', () {
      final a = ShapeProfile.of(Formation.f424.positions);
      final n = ShapeProfile.of(Formation.f433.positions);
      final d = ShapeProfile.of(Formation.f541.positions);
      expect(a.attackers, greaterThan(n.attackers));
      expect(n.attackers, greaterThan(d.attackers));
      expect(a.defenders, lessThan(n.defenders));
      expect(n.defenders, lessThan(d.defenders));
    });

    test('4-3-3 is the neutral reading', () {
      final n = ShapeProfile.of(Formation.f433.positions);
      expect(n.attackers, ShapeProfile.neutralAttackers);
      expect(n.defenders, ShapeProfile.neutralDefenders);
    });
  });

  group('shape in the engine', () {
    test('4-2-4 scores more and concedes more than an identical 4-3-3', () {
      final r = _versus433(Formation.f424);
      final base = _versus433(Formation.f433);
      expect(base.goalsFor, closeTo(base.goalsAgainst, 0.05));
      expect(r.goalsFor, greaterThan(base.goalsFor));
      expect(r.goalsAgainst, greaterThan(base.goalsAgainst));
    });

    test('5-4-1 scores less and concedes less than an identical 4-3-3', () {
      final r = _versus433(Formation.f541);
      final base = _versus433(Formation.f433);
      expect(r.goalsFor, lessThan(base.goalsFor));
      expect(r.goalsAgainst, lessThan(base.goalsAgainst));
    });
  });
}
