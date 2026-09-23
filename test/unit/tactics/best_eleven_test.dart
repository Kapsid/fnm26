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
}
