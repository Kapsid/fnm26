import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/player/player_aging.dart';

import '../../helpers/fixtures.dart';

void main() {
  test('cycles=0 returns the player unchanged', () {
    final p = player(id: 1, nationId: 1, position: PlayerPosition.cm, age: 24);
    expect(PlayerAging.aged(p, 0), p);
  });

  test('a young player develops over a cycle', () {
    final young = player(
      id: 1,
      nationId: 1,
      position: PlayerPosition.cm,
      age: 19,
      attributes: flatAttributes(60),
    );
    final aged = PlayerAging.aged(young, 1); // +4 years -> age 23
    expect(aged.age, 23);
    expect(aged.overall, greaterThan(young.overall));
  });

  test('an old player declines over a cycle', () {
    final old = player(
      id: 1,
      nationId: 1,
      position: PlayerPosition.st,
      age: 32,
      attributes: flatAttributes(80),
    );
    final aged = PlayerAging.aged(old, 1); // +4 years -> age 36
    expect(aged.age, 36);
    expect(aged.overall, lessThan(old.overall));
  });

  test('aging is deterministic', () {
    final p = player(id: 1, nationId: 1, position: PlayerPosition.cb, age: 27);
    expect(PlayerAging.aged(p, 2).overall, PlayerAging.aged(p, 2).overall);
  });
}
