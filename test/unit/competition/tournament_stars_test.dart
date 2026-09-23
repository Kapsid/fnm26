import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/competition/tournament_stars.dart';

import '../../helpers/fixtures.dart';

void main() {
  // Two nations: 1 (champion, deep run) and 2 (group stage).
  final candidates = [
    for (var i = 0; i < 11; i++)
      player(
        id: 100 + i,
        nationId: 1,
        position: PlayerPosition.values[i % PlayerPosition.values.length],
        attributes: flatAttributes(80),
      ),
    for (var i = 0; i < 11; i++)
      player(
        id: 200 + i,
        nationId: 2,
        position: PlayerPosition.values[i % PlayerPosition.values.length],
        attributes: flatAttributes(80),
      ),
  ];

  test('selects a valid 4-3-3 (1 GK, 4 DEF, 3 MID, 3 FWD)', () {
    final xi = TournamentStars.teamOfTournament(
      candidates: candidates,
      goalsByPlayer: const {},
      runByNation: const {1: 5, 2: 0},
      champion: 1,
    );
    expect(xi, hasLength(11));
    int count(PositionCategory c) =>
        xi.where((s) => s.position.category == c).length;
    expect(count(PositionCategory.goalkeeper), 1);
    expect(count(PositionCategory.defender), 4);
    expect(count(PositionCategory.midfielder), 3);
    expect(count(PositionCategory.forward), 3);
  });

  test('rewards goals, deep runs and the champion', () {
    final xi = TournamentStars.teamOfTournament(
      candidates: candidates,
      goalsByPlayer: const {205: 5}, // a nation-2 player scored a lot
      runByNation: const {1: 5, 2: 0},
      champion: 1,
    );
    // The prolific scorer forces their way in despite the group-stage exit.
    expect(xi.any((s) => s.id == 205), isTrue);
    // Champion players dominate the rest of the XI.
    expect(xi.where((s) => s.nationId == 1).length, greaterThan(5));
  });

  test('golden boot is the top scorer in the team', () {
    final xi = TournamentStars.teamOfTournament(
      candidates: candidates,
      goalsByPlayer: const {201: 3, 105: 1},
      runByNation: const {1: 5, 2: 2},
      champion: 1,
    );
    final boot = TournamentStars.goldenBoot(xi);
    expect(boot, isNotNull);
    expect(boot!.goals, 3);
  });
}
