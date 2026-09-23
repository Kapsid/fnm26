import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/match/goal_attribution.dart';

Player _p(int id, PlayerPosition pos, int technical) => Player(
  id: id,
  nationId: 1,
  name: 'P$id',
  age: 25,
  position: pos,
  attributes: PlayerAttributes(
    physical: 50,
    technical: technical,
    stamina: 50,
  ),
);

void main() {
  test('returns one scorer per goal from the pool', () {
    final pool = [
      _p(1, PlayerPosition.gk, 20),
      _p(2, PlayerPosition.cb, 40),
      _p(3, PlayerPosition.st, 90),
    ];
    final scorers = GoalAttribution.scorers(
      pool: pool,
      goals: 3,
      rng: SeededRng(1),
    );
    expect(scorers, hasLength(3));
    expect(scorers.every((id) => pool.any((p) => p.id == id)), isTrue);
  });

  test('no goals or empty pool yields no scorers', () {
    expect(
      GoalAttribution.scorers(pool: const [], goals: 2, rng: SeededRng(1)),
      isEmpty,
    );
    expect(
      GoalAttribution.scorers(
        pool: [_p(1, PlayerPosition.st, 80)],
        goals: 0,
        rng: SeededRng(1),
      ),
      isEmpty,
    );
  });

  test('strikers heavily out-score goalkeepers over many goals', () {
    final pool = [
      _p(1, PlayerPosition.gk, 60),
      _p(2, PlayerPosition.st, 60),
    ];
    final scorers = GoalAttribution.scorers(
      pool: pool,
      goals: 200,
      rng: SeededRng(7),
    );
    final strikerGoals = scorers.where((id) => id == 2).length;
    expect(strikerGoals, greaterThan(150));
  });
}
