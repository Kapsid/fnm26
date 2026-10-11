import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/services/tactics/best_eleven.dart';

import '../../helpers/fixtures.dart';

void main() {
  // A pool covering every category, ids encode their tier.
  final pool = [
    player(
      id: 1,
      nationId: 1,
      position: PlayerPosition.gk,
      attributes: flatAttributes(85),
    ),
    player(
      id: 2,
      nationId: 1,
      position: PlayerPosition.gk,
      attributes: flatAttributes(70),
    ),
    player(
      id: 3,
      nationId: 1,
      position: PlayerPosition.cb,
      attributes: flatAttributes(84),
    ),
    player(
      id: 4,
      nationId: 1,
      position: PlayerPosition.cb,
      attributes: flatAttributes(80),
    ),
    player(
      id: 5,
      nationId: 1,
      position: PlayerPosition.lb,
      attributes: flatAttributes(78),
    ),
    player(
      id: 6,
      nationId: 1,
      position: PlayerPosition.rb,
      attributes: flatAttributes(77),
    ),
    player(
      id: 7,
      nationId: 1,
      position: PlayerPosition.dm,
      attributes: flatAttributes(82),
    ),
    player(
      id: 8,
      nationId: 1,
      position: PlayerPosition.cm,
      attributes: flatAttributes(83),
    ),
    player(
      id: 9,
      nationId: 1,
      position: PlayerPosition.cm,
      attributes: flatAttributes(79),
    ),
    player(
      id: 10,
      nationId: 1,
      position: PlayerPosition.lw,
      attributes: flatAttributes(86),
    ),
    player(
      id: 11,
      nationId: 1,
      position: PlayerPosition.rw,
      attributes: flatAttributes(81),
    ),
    player(
      id: 12,
      nationId: 1,
      position: PlayerPosition.st,
      attributes: flatAttributes(88),
    ),
    player(
      id: 13,
      nationId: 1,
      position: PlayerPosition.st,
      attributes: flatAttributes(75),
    ),
  ];

  test('fills all 11 slots with no player used twice', () {
    final xi = bestEleven(Formation.f433, pool);
    expect(xi, hasLength(11));
    final chosen = xi.whereType<int>().toList();
    expect(chosen, hasLength(11));
    expect(chosen.toSet(), hasLength(11));
  });

  test('picks the best goalkeeper for the keeper slot', () {
    final xi = bestEleven(Formation.f433, pool);
    expect(xi[0], 1); // the 85-rated GK, not the 70
  });

  test('honours positions: the striker slot gets a striker', () {
    final xi = bestEleven(Formation.f433, pool);
    final stPlayerId = xi[9]; // 4-3-3 slot 9 is ST
    final st = pool.firstWhere((p) => p.id == stPlayerId);
    expect(st.position, PlayerPosition.st);
  });

  group('a natural in the position is not picked at any price', () {
    // The only right-back is a 32-rated boy; three good centre-backs are
    // available. A side with a better defender on the bench does not start
    // the boy just because the label on his shirt matches.
    final squad = [
      player(
        id: 1,
        nationId: 1,
        position: PlayerPosition.gk,
        attributes: flatAttributes(80),
      ),
      player(
        id: 2,
        nationId: 1,
        position: PlayerPosition.lb,
        attributes: flatAttributes(78),
      ),
      player(
        id: 3,
        nationId: 1,
        position: PlayerPosition.cb,
        attributes: flatAttributes(84),
      ),
      player(
        id: 4,
        nationId: 1,
        position: PlayerPosition.cb,
        attributes: flatAttributes(82),
      ),
      player(
        id: 5,
        nationId: 1,
        position: PlayerPosition.cb,
        attributes: flatAttributes(80),
      ),
      player(
        id: 6,
        nationId: 1,
        position: PlayerPosition.rb,
        attributes: flatAttributes(32),
      ),
      for (var i = 0; i < 6; i++)
        player(
          id: 10 + i,
          nationId: 1,
          position: [
            PlayerPosition.cm,
            PlayerPosition.cm,
            PlayerPosition.dm,
            PlayerPosition.lw,
            PlayerPosition.rw,
            PlayerPosition.st,
          ][i],
          attributes: flatAttributes(80),
        ),
      player(
        id: 30,
        nationId: 1,
        position: PlayerPosition.gk,
        attributes: flatAttributes(60),
      ),
    ];

    test('the third centre-back plays right-back', () {
      final xi = bestEleven(Formation.f433, squad);
      expect(xi, isNot(contains(6)));
      expect(xi, containsAll([3, 4, 5]));
    });

    test('a natural close in quality still gets the shirt', () {
      final close = [
        for (final p in squad)
          if (p.id != 6) p,
        player(
          id: 7,
          nationId: 1,
          position: PlayerPosition.rb,
          attributes: flatAttributes(78),
        ),
      ];
      expect(bestEleven(Formation.f433, close), contains(7));
    });

    test('an outfield player never keeps goal while a keeper is left', () {
      final xi = bestEleven(Formation.f433, squad);
      final keepers = {1, 30};
      expect(xi.where(keepers.contains), hasLength(1));
    });
  });
}
