import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/squad/legends.dart';

LegendStat stat({
  required int id,
  required PlayerPosition position,
  int caps = 0,
  int goals = 0,
  int assists = 0,
  int motm = 0,
  double avgRating = 6.7,
}) =>
    (
      playerId: id,
      name: 'P$id',
      position: position,
      caps: caps,
      goals: goals,
      assists: assists,
      motm: motm,
      avgRating: avgRating,
    );

void main() {
  test('a long-serving scorer outranks a one-cap cameo', () {
    final ranked = Legends.rank([
      stat(id: 1, position: PlayerPosition.st, caps: 80, goals: 50, motm: 20),
      stat(id: 2, position: PlayerPosition.st, caps: 1, avgRating: 9.9),
    ]);
    expect(ranked.first.playerId, 1);
  });

  test('all-time XI fills a 4-3-3 from the best per line', () {
    final stats = <LegendStat>[
      for (var i = 0; i < 3; i++)
        stat(id: 100 + i, position: PlayerPosition.gk, caps: 50 - i),
      for (var i = 0; i < 6; i++)
        stat(id: 200 + i, position: PlayerPosition.cb, caps: 50 - i),
      for (var i = 0; i < 6; i++)
        stat(id: 300 + i, position: PlayerPosition.cm, caps: 50 - i),
      for (var i = 0; i < 6; i++)
        stat(id: 400 + i, position: PlayerPosition.st, caps: 50 - i, goals: 30),
    ];
    final xi = Legends.allTimeXi(Legends.rank(stats));
    expect(xi.length, 11);
    expect(
      xi.where((l) => l.position.category == PositionCategory.goalkeeper).length,
      1,
    );
    expect(
      xi.where((l) => l.position.category == PositionCategory.defender).length,
      4,
    );
    expect(
      xi.where((l) => l.position.category == PositionCategory.forward).length,
      3,
    );
  });
}
