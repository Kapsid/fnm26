import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/match_engine.dart';

import '../../helpers/fixtures.dart';

MatchTeam team(int nationId, int rating) {
  final positions = Formation.f433.positions;
  final xi = [
    for (var i = 0; i < 11; i++)
      player(
        id: nationId * 100 + i,
        nationId: nationId,
        position: positions[i],
        attributes: flatAttributes(rating),
      ),
  ];
  return MatchTeam(
    nationId: nationId,
    xi: xi,
    instructions: const TacticalInstructions(),
  );
}

void main() {
  const engine = MatchEngine();

  test('same teams + same seed produce an identical match', () {
    final home = team(1, 80);
    final away = team(2, 75);
    final a = engine.play(home: home, away: away, rng: SeededRng.forFixture(9, 1));
    final b = engine.play(home: home, away: away, rng: SeededRng.forFixture(9, 1));

    expect(a.homeScore, b.homeScore);
    expect(a.awayScore, b.awayScore);
    expect(a.events.map((e) => '${e.minute}:${e.playerId}').toList(),
        b.events.map((e) => '${e.minute}:${e.playerId}').toList());
  });

  test('goal events belong to a scoring team and one of its players', () {
    final home = team(1, 82);
    final away = team(2, 70);
    final result =
        engine.play(home: home, away: away, rng: SeededRng.forFixture(3, 7));

    final homeIds = home.xi.map((p) => p.id).toSet();
    final awayIds = away.xi.map((p) => p.id).toSet();
    var homeGoals = 0;
    var awayGoals = 0;
    for (final e in result.events) {
      if (e.teamNationId == 1) {
        expect(homeIds.contains(e.playerId), isTrue);
        homeGoals++;
      } else {
        expect(awayIds.contains(e.playerId), isTrue);
        awayGoals++;
      }
    }
    expect(homeGoals, result.homeScore);
    expect(awayGoals, result.awayScore);
  });

  test('stronger teams outscore weaker ones across many matches', () {
    final strong = team(1, 86);
    final weak = team(2, 56);
    var strongGoals = 0;
    var weakGoals = 0;
    for (var seed = 0; seed < 30; seed++) {
      final r = engine.play(
        home: strong,
        away: weak,
        rng: SeededRng.forFixture(seed, seed),
      );
      strongGoals += r.homeScore;
      weakGoals += r.awayScore;
    }
    expect(strongGoals, greaterThan(weakGoals));
  });
}
