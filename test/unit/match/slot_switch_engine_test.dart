import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/shape_profile.dart';

import '../../helpers/fixtures.dart';

/// A place changed within the formation reaches the engine as the slot's
/// position, through the positional logic the engine already has (fit, the
/// shape's bodies), and nothing else.
void main() {
  const f433 = Formation.f433;
  const toDm = SlotSwitches({6: PlayerPosition.dm});

  List<Player> xi(int nationId, List<PlayerPosition> positions) => [
    for (var i = 0; i < 11; i++)
      player(
        id: nationId * 100 + i,
        nationId: nationId,
        position: positions[i],
      ),
  ];

  test('the team sheet hands the engine the switched slot', () {
    final team = MatchTeam(
      nationId: 1,
      xi: xi(1, f433.positions),
      instructions: const TacticalInstructions(),
      formation: f433,
      switches: toDm,
    );
    expect(team.positions[6], PlayerPosition.dm);
    expect(team.formation, f433);
    // A live change carries them too, for a man the change does not place.
    final change = TacticalChange(
      teamNationId: 1,
      minute: 60,
      formation: f433,
      instructions: const TacticalInstructions(),
      xi: xi(1, f433.positions),
      switches: toDm,
    );
    expect(change.slotOf(6), PlayerPosition.dm);
    expect(
      ShapeProfile.of(team.positions).defenders,
      ShapeProfile.ofFormation(f433).defenders + 0.5,
    );
  });

  test('the engine plays the switched slot, not the drawn one', () {
    // A natural holding midfielder in slot 6: out of place as a CM (docked),
    // at home once the slot is switched to DM. Same seeds, so any difference
    // is the switch.
    final positions = [...f433.positions]..[6] = PlayerPosition.dm;
    MatchTeam mine(SlotSwitches s) => MatchTeam(
      nationId: 1,
      xi: xi(1, positions),
      instructions: const TacticalInstructions(),
      formation: f433,
      switches: s,
    );
    final them = MatchTeam(
      nationId: 2,
      xi: xi(2, f433.positions),
      instructions: const TacticalInstructions(),
      formation: f433,
    );
    const engine = MatchEngine();
    var differs = 0;
    for (var i = 0; i < 40; i++) {
      final plain = engine.play(
        home: mine(SlotSwitches.none),
        away: them,
        rng: SeededRng.forFixture(0x5107, i),
        neutralVenue: true,
      );
      final switched = engine.play(
        home: mine(toDm),
        away: them,
        rng: SeededRng.forFixture(0x5107, i),
        neutralVenue: true,
      );
      if (plain.homeScore != switched.homeScore ||
          plain.awayScore != switched.awayScore ||
          plain.homeShots != switched.homeShots ||
          plain.awayShots != switched.awayShots) {
        differs++;
      }
    }
    expect(differs, greaterThan(0));
  });

  test('a skipped match reads the switched shape too, and only then', () {
    final drawn = MatchEngine.planEffect(
      plan: const TacticalInstructions(),
      formation: f433,
      opponent: const TacticalInstructions(),
      opponentFormation: f433,
    );
    // No switches: exactly the old figure (the calibrated path is untouched).
    final same = MatchEngine.planEffect(
      plan: const TacticalInstructions(),
      formation: f433,
      opponent: const TacticalInstructions(),
      opponentFormation: f433,
      slots: f433.positions,
    );
    expect(same.ratingDelta, drawn.ratingDelta);
    expect(same.openness, drawn.openness);
    final switched = MatchEngine.planEffect(
      plan: const TacticalInstructions(),
      formation: f433,
      opponent: const TacticalInstructions(),
      opponentFormation: f433,
      slots: toDm.apply(f433),
    );
    expect(switched.ratingDelta, isNot(drawn.ratingDelta));
  });
}
