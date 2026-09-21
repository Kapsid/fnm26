import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/tactics/set_piece_picks.dart';

/// The manager used to see two blank set-piece slots while the engine already
/// knew who would step up. These are the engine's own rules, restated, so the
/// name on the screen is the man who actually takes it.
void main() {
  Player player({
    required int id,
    required PlayerPosition position,
    required int technical,
  }) => Player(
    id: id,
    nationId: 1,
    name: 'P$id',
    position: position,
    age: 26,
    club: 'Club',
    attributes: PlayerAttributes(
      physical: 60,
      technical: technical,
      stamina: 60,
    ),
  );

  test('the penalty falls to the best technical outfielder', () {
    final xi = [
      player(id: 1, position: PlayerPosition.gk, technical: 99),
      player(id: 2, position: PlayerPosition.cb, technical: 60),
      player(id: 3, position: PlayerPosition.am, technical: 88),
    ];
    expect(SetPiecePicks.penalty(xi), 3);
  });

  test('an all-keeper side still finds a penalty taker', () {
    final xi = [
      player(id: 1, position: PlayerPosition.gk, technical: 70),
      player(id: 2, position: PlayerPosition.gk, technical: 80),
    ];
    expect(SetPiecePicks.penalty(xi), 2);
  });

  test('an empty eleven has no taker', () {
    expect(SetPiecePicks.penalty(const []), isNull);
    expect(SetPiecePicks.deadBall(const []), isNull);
  });

  test('the dead ball falls to the best technical player, keeper or not', () {
    final xi = [
      player(id: 1, position: PlayerPosition.gk, technical: 99),
      player(id: 2, position: PlayerPosition.am, technical: 88),
    ];
    expect(SetPiecePicks.deadBall(xi), 1);
  });
}
