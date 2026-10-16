import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/match_engine.dart';

import '../../helpers/fixtures.dart';

MatchTeam _team(int nationId, TacticalInstructions instructions) {
  final positions = Formation.f433.positions;
  return MatchTeam(
    nationId: nationId,
    formation: Formation.f433,
    instructions: instructions,
    xi: [
      for (var i = 0; i < 11; i++)
        player(
          id: nationId * 100 + i,
          nationId: nationId,
          position: positions[i],
          attributes: flatAttributes(80),
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

void main() {
  group('mentality trade-off', () {
    test('all-out mentality concedes clearly more', () {
      final allOut = _plan(const TacticalInstructions(mentality: 90));
      final mirror = _plan(const TacticalInstructions(mentality: 50));
      expect(
        allOut.goalsAgainst,
        greaterThanOrEqualTo(mirror.goalsAgainst * 1.25),
      );
    });
  });
}
