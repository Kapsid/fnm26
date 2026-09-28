import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/manager/staff.dart';
import 'package:fnm/domain/services/match/match_engine.dart';

import '../../helpers/fixtures.dart';

/// The scout's opponent dossier reaches the match itself, not just the panel.
///
/// It rides `MatchTeam.ratingBonus`, the same seam condition and morale use,
/// so a side with nobody in the job must play byte-for-byte as before and a
/// side with an elite scout must be measurably, and only modestly, better.
MatchTeam side(int nationId, {int bonus = 0}) {
  final positions = Formation.f433.positions;
  return MatchTeam(
    nationId: nationId,
    instructions: const TacticalInstructions(),
    ratingBonus: bonus,
    xi: [
      for (var i = 0; i < 11; i++)
        player(
          id: nationId * 100 + i,
          nationId: nationId,
          position: positions[i],
          attributes: flatAttributes(75),
        ),
    ],
  );
}

void main() {
  const engine = MatchEngine();

  test('no scout: the match is exactly the match it always was', () {
    for (var i = 0; i < 40; i++) {
      final plain = engine.play(
        home: side(1),
        away: side(2),
        rng: SeededRng.forFixture(0xD055, i),
      );
      final zero = engine.play(
        home: side(1, bonus: Staff.dossierBonus(StaffTier.none)),
        away: side(2),
        rng: SeededRng.forFixture(0xD055, i),
      );
      expect(zero.homeScore, plain.homeScore);
      expect(zero.awayScore, plain.awayScore);
      expect(zero.events.length, plain.events.length);
    }
  });

  test('an elite dossier tilts even matches, without deciding them', () {
    const n = 600;
    var plainDiff = 0;
    var scoutedDiff = 0;
    var scoutedWins = 0;
    for (var i = 0; i < n; i++) {
      final plain = engine.play(
        home: side(1),
        away: side(2),
        rng: SeededRng.forFixture(0xD055, i),
        neutralVenue: true,
      );
      final scouted = engine.play(
        home: side(1, bonus: Staff.dossierBonus(StaffTier.elite)),
        away: side(2),
        rng: SeededRng.forFixture(0xD055, i),
        neutralVenue: true,
      );
      plainDiff += plain.homeScore - plain.awayScore;
      scoutedDiff += scouted.homeScore - scouted.awayScore;
      if (scouted.homeScore > scouted.awayScore) scoutedWins++;
    }
    expect(scoutedDiff, greaterThan(plainDiff));
    // A few rating points is an edge, not a walkover.
    expect(100 * scoutedWins / n, lessThan(65));
  });
}
