import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/match_engine.dart';

import '../../helpers/fixtures.dart';

MatchTeam _team(int nationId, int rating) {
  final positions = Formation.f433.positions;
  return MatchTeam(
    nationId: nationId,
    xi: [
      for (var i = 0; i < 11; i++)
        player(
          id: nationId * 100 + i,
          nationId: nationId,
          position: positions[i],
          attributes: flatAttributes(rating),
        ),
    ],
    instructions: const TacticalInstructions(),
  );
}

MatchResult _simulateOneMatch(int seed) => const MatchEngine().play(
  home: _team(1, 78),
  away: _team(2, 76),
  rng: SeededRng.forFixture(seed, 1),
);

void main() {
  test('second yellows outnumber straight reds across a season', () {
    var secondYellows = 0;
    var straightReds = 0;

    for (var seed = 0; seed < 400; seed++) {
      final result = _simulateOneMatch(seed);
      for (final e in result.events) {
        if (e.type != MatchEventType.redCard) continue;
        if (e.secondYellow) {
          secondYellows++;
        } else {
          straightReds++;
        }
      }
    }

    // Real football sends far more players off for a second booking than for
    // violent conduct. The exact ratio is a tuning choice; the ordering is not.
    expect(secondYellows, greaterThan(straightReds));
    // And dismissals stay rare overall — roughly one in every few matches.
    expect(secondYellows + straightReds, lessThan(400 ~/ 2));
  });
}
