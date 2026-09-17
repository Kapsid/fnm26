import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_absence.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/squad/squad_selection.dart';

/// "Best quality" used to mean the highest-rated names in the country, which is
/// not a squad. A nation with a golden midfield generation got twenty
/// midfielders, two defenders and no cover anywhere: the shape could barely be
/// fielded, and the first suspension in the back line broke it outright.
void main() {
  var nextId = 0;

  Player player(PlayerPosition position, int overall) => Player(
    id: ++nextId,
    nationId: 1,
    name: 'P$nextId',
    position: position,
    age: 26,
    club: 'Club',
    attributes: PlayerAttributes(
      physical: overall,
      technical: overall,
      stamina: overall,
    ),
  );

  /// A pool that rates every midfielder above every defender and forward —
  /// exactly the shape of pool the old pick fell over on.
  List<Player> lopsidedPool() => [
    for (var i = 0; i < 5; i++) player(PlayerPosition.gk, 70),
    for (var i = 0; i < 20; i++) player(PlayerPosition.cm, 85),
    for (var i = 0; i < 10; i++) player(PlayerPosition.cb, 60),
    for (var i = 0; i < 10; i++) player(PlayerPosition.st, 60),
  ];

  Map<PositionCategory, int> linesOf(List<Player> pool, Set<int> picked) {
    final byId = {for (final p in pool) p.id: p};
    final count = <PositionCategory, int>{};
    for (final id in picked) {
      final c = byId[id]!.position.category;
      count[c] = (count[c] ?? 0) + 1;
    }
    return count;
  }

  test('every outfield line gets what the shape fields, plus one', () {
    final pool = lopsidedPool();
    final picked = SquadSelection.bestQuality(
      pool: pool,
      absences: const {},
      coverage: 1,
      formation: Formation.f433,
      max: 23,
    );
    final lines = linesOf(pool, picked);

    expect(
      lines[PositionCategory.defender],
      greaterThanOrEqualTo(5),
      reason: 'a back four is named with five defenders',
    );
    expect(
      lines[PositionCategory.forward],
      greaterThanOrEqualTo(4),
      reason: 'a front three is named with four forwards',
    );
    expect(
      lines[PositionCategory.midfielder],
      greaterThanOrEqualTo(4),
      reason: 'a midfield three is named with four',
    );
  });

  test('a back five is covered as a back five', () {
    final pool = lopsidedPool();
    final picked = SquadSelection.bestQuality(
      pool: pool,
      absences: const {},
      coverage: 1,
      formation: Formation.f532,
      max: 23,
    );
    expect(
      linesOf(pool, picked)[PositionCategory.defender],
      greaterThanOrEqualTo(6),
      reason: 'the floor follows the shape, it is not a fixed number',
    );
  });

  test('keepers are the exception and stay at three', () {
    final pool = lopsidedPool();
    final picked = SquadSelection.bestQuality(
      pool: pool,
      absences: const {},
      coverage: 1,
      formation: Formation.f433,
      max: 23,
    );
    expect(linesOf(pool, picked)[PositionCategory.goalkeeper], 3);
  });

  test('above the floors it is quality again', () {
    // The deep midfield still travels: the floors take 13 places, and the 10
    // that are left go to the best players unnamed, who are all midfielders.
    final pool = lopsidedPool();
    final picked = SquadSelection.bestQuality(
      pool: pool,
      absences: const {},
      coverage: 1,
      formation: Formation.f433,
      max: 23,
    );
    expect(picked, hasLength(23));
    expect(
      linesOf(pool, picked)[PositionCategory.midfielder],
      greaterThan(4),
      reason: 'quality decides everything the floors did not',
    );
  });

  test('a squad is never padded past its limit to hit a floor', () {
    final pool = lopsidedPool();
    final picked = SquadSelection.bestQuality(
      pool: pool,
      absences: const {},
      coverage: 1,
      formation: Formation.f433,
      max: 16,
    );
    expect(picked.length, lessThanOrEqualTo(16));
  });

  test('a thin line is filled as far as the pool allows, not faked', () {
    // Two defenders in the whole country is a problem the manager has, not one
    // the picker can invent its way out of.
    final pool = [
      for (var i = 0; i < 3; i++) player(PlayerPosition.gk, 70),
      for (var i = 0; i < 2; i++) player(PlayerPosition.cb, 60),
      for (var i = 0; i < 20; i++) player(PlayerPosition.cm, 85),
    ];
    final picked = SquadSelection.bestQuality(
      pool: pool,
      absences: const {},
      coverage: 1,
      formation: Formation.f433,
      max: 23,
    );
    expect(linesOf(pool, picked)[PositionCategory.defender], 2);
    expect(picked, hasLength(23));
  });

  test('a man banned for the whole period is not named to fill a line', () {
    final pool = lopsidedPool();
    final banned = pool.firstWhere(
      (p) => p.position.category == PositionCategory.defender,
    );
    final picked = SquadSelection.bestQuality(
      pool: pool,
      absences: {
        banned.id: PlayerAbsence(playerId: banned.id, banMatches: 4),
      },
      coverage: 3,
      formation: Formation.f433,
      max: 23,
    );
    expect(picked, isNot(contains(banned.id)));
    expect(
      linesOf(pool, picked)[PositionCategory.defender],
      greaterThanOrEqualTo(5),
      reason: 'the line is still covered, by somebody who can play',
    );
  });
}
