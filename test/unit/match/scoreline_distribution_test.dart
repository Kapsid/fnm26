import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/match_engine.dart';

import '../../helpers/fixtures.dart';

MatchTeam _team(int nationId, int rating) => MatchTeam(
  nationId: nationId,
  xi: [
    for (var i = 0; i < 11; i++)
      player(
        id: nationId * 100 + i,
        nationId: nationId,
        position: Formation.f433.positions[i],
        attributes: flatAttributes(rating),
      ),
  ],
  instructions: const TacticalInstructions(),
);

/// A mismatch rather than two equals: a blowout needs a favourite, so this is
/// the fixture the tail actually shows up in.
MatchResult _simulateOneMatch(int seed) => const MatchEngine().play(
  home: _team(1, 84),
  away: _team(2, 66),
  rng: SeededRng.forFixture(seed, 1),
);

void main() {
  const runs = 2000;

  test('scorelines of 7+ for one side are ultra rare', () {
    var blowouts = 0;
    for (var seed = 0; seed < runs; seed++) {
      final r = _simulateOneMatch(seed);
      if (r.homeScore >= 7 || r.awayScore >= 7) blowouts++;
    }

    // Well under one in two hundred. A 7-0 should be a story, not a Tuesday.
    expect(blowouts / runs, lessThan(0.005));
  });

  test('ordinary scorelines are unaffected', () {
    var totalGoals = 0;
    for (var seed = 0; seed < runs; seed++) {
      final r = _simulateOneMatch(seed);
      totalGoals += r.homeScore + r.awayScore;
    }
    // Mean goals a game stays in the normal international band.
    expect(totalGoals / runs, inInclusiveRange(2.0, 3.6));
  });
}
