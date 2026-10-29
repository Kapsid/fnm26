import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/tactics/best_eleven.dart';
import 'package:fnm/domain/services/tactics/set_piece_picks.dart';
import 'package:fnm/features/tactics/set_piece_takers_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/fixtures.dart';

/// Playtest: "the goalkeeper shouldn't take penalties and free kicks by
/// default". A good keeper's technical rating is as high as anyone's, and the
/// dead-ball pick ranked the whole eleven, so the keeper was named on corners
/// and free kicks, for the AI as well as for the manager.
void main() {
  /// A typical squad: two keepers rated well above the rest on technical (the
  /// case that used to go wrong), and a spread of outfielders.
  List<Player> squad(int nationId, {int keeperTechnical = 95}) {
    const outfield = [
      PlayerPosition.lb, PlayerPosition.cb, PlayerPosition.cb, //
      PlayerPosition.cb, PlayerPosition.rb, PlayerPosition.lb,
      PlayerPosition.rb, PlayerPosition.dm, PlayerPosition.cm,
      PlayerPosition.cm, PlayerPosition.cm, PlayerPosition.am,
      PlayerPosition.lm, PlayerPosition.rm, PlayerPosition.lw,
      PlayerPosition.rw, PlayerPosition.st, PlayerPosition.st,
      PlayerPosition.st,
    ];
    return [
      for (var k = 0; k < 2; k++)
        player(
          id: nationId * 100 + k,
          nationId: nationId,
          position: PlayerPosition.gk,
          attributes: PlayerAttributes(
            physical: 70,
            technical: keeperTechnical - k,
            stamina: 70,
          ),
        ),
      for (var i = 0; i < outfield.length; i++)
        player(
          id: nationId * 100 + 10 + i,
          nationId: nationId,
          position: outfield[i],
          attributes: PlayerAttributes(
            physical: 60 + (i * 7) % 25,
            technical: 55 + (i * 11) % 30,
            stamina: 70,
          ),
        ),
    ];
  }

  List<Player> xiFor(Formation f, List<Player> pool) {
    final byId = {for (final p in pool) p.id: p};
    return [for (final id in bestEleven(f, pool).whereType<int>()) byId[id]!];
  }

  bool isKeeper(Player p) => p.position.category == PositionCategory.goalkeeper;

  group('the default takers', () {
    for (final f in Formation.values) {
      test('never include the keeper in ${f.label}', () {
        for (final keeperTech in const [40, 80, 99]) {
          final xi = xiFor(f, squad(1, keeperTechnical: keeperTech));
          expect(xi.where(isKeeper), isNotEmpty);
          final byId = {for (final p in xi) p.id: p};
          expect(isKeeper(byId[SetPiecePicks.penalty(xi)]!), isFalse);
          expect(isKeeper(byId[SetPiecePicks.deadBall(xi)]!), isFalse);
        }
      });
    }
  });

  group('the engine', () {
    const engine = MatchEngine();

    test('an AI side never sends its keeper up for a set piece', () {
      var setPieces = 0;
      var penalties = 0;
      for (final f in const [Formation.f433, Formation.f352, Formation.f541]) {
        final home = MatchTeam(
          instructions: const TacticalInstructions(),
          nationId: 1,
          xi: xiFor(f, squad(1, keeperTechnical: 99)),
          formation: f,
        );
        final away = MatchTeam(
          instructions: const TacticalInstructions(),
          nationId: 2,
          xi: xiFor(Formation.f442, squad(2, keeperTechnical: 99)),
          formation: Formation.f442,
        );
        final keepers = {
          for (final p in [...home.xi, ...away.xi])
            if (isKeeper(p)) p.id,
        };
        for (var seed = 0; seed < 150; seed++) {
          final r = engine.play(
            home: home,
            away: away,
            rng: SeededRng.forFixture(seed, 3),
          );
          for (final g in r.events.where(
            (e) => e.type == MatchEventType.goal,
          )) {
            if (g.setPiece) {
              setPieces++;
              expect(keepers, isNot(contains(g.assistPlayerId)));
            }
            if (g.penalty) {
              penalties++;
              expect(keepers, isNot(contains(g.playerId)));
            }
          }
        }
      }
      // The check above means nothing unless set pieces were actually scored.
      expect(setPieces, greaterThan(20));
      expect(penalties, greaterThan(5));
    });

    test('a keeper named by hand is still honoured', () {
      final xi = xiFor(Formation.f433, squad(1));
      final keeper = xi.firstWhere(isKeeper);
      final home = MatchTeam(
        instructions: const TacticalInstructions(),
        nationId: 1,
        xi: xi,
        formation: Formation.f433,
        deadBallTakerId: keeper.id,
      );
      final away = MatchTeam(
        instructions: const TacticalInstructions(),
        nationId: 2,
        xi: xiFor(Formation.f442, squad(2)),
        formation: Formation.f442,
      );
      var byKeeper = 0;
      for (var seed = 0; seed < 150; seed++) {
        byKeeper += engine
            .play(home: home, away: away, rng: SeededRng.forFixture(seed, 5))
            .events
            .where(
              (e) =>
                  e.teamNationId == 1 &&
                  e.setPiece &&
                  e.assistPlayerId == keeper.id,
            )
            .length;
      }
      expect(byKeeper, greaterThan(0));
    });
  });

  group('saves from before the fix', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    ProviderContainer container(Set<int> keepers) {
      final c = ProviderContainer(
        overrides: [
          setPieceKeeperCheckProvider.overrideWithValue(
            (careerId, playerId) async => keepers.contains(playerId),
          ),
        ],
      )..listen(setPieceTakersProvider(1), (_, _) {});
      addTearDown(c.dispose);
      return c;
    }

    Future<void> stored(int? penalty, int? deadBall) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'set_piece_takers_v1:1',
        jsonEncode({'penalty': penalty, 'deadBall': deadBall}),
      );
    }

    test('a stored keeper goes back to automatic', () async {
      await stored(7, 1);
      final c = container({1});
      expect(await c.read(setPieceTakersProvider(1).future), (
        penalty: 7,
        deadBall: null,
      ));
      // And it is written back, so the store agrees with the screen.
      expect(
        await c.read(setPieceTakersStoreProvider).load(1),
        (penalty: 7, deadBall: null),
      );
    });

    test('outfield takers are left alone', () async {
      await stored(7, 8);
      final c = container({1});
      expect(await c.read(setPieceTakersProvider(1).future), (
        penalty: 7,
        deadBall: 8,
      ));
    });

    test("a keeper named after the sweep is the manager's to keep", () async {
      await stored(7, 8);
      final c = container({1});
      await c.read(setPieceTakersProvider(1).future);
      await c
          .read(setPieceTakersStoreProvider)
          .set(1, penalty: false, playerId: 1);
      expect(await c.read(setPieceTakersProvider(1).future), (
        penalty: 7,
        deadBall: 1,
      ));
    });

    test('a save on automatic keeps a keeper named later', () async {
      // Nothing stored: the first read must still mark the sweep done, or
      // the next read would wipe the keeper the manager then names.
      final c = container({1});
      expect(await c.read(setPieceTakersProvider(1).future), (
        penalty: null,
        deadBall: null,
      ));
      await c
          .read(setPieceTakersStoreProvider)
          .set(1, penalty: false, playerId: 1);
      expect(await c.read(setPieceTakersProvider(1).future), (
        penalty: null,
        deadBall: 1,
      ));
    });

    test('a failed lookup leaves the pair as stored', () async {
      await stored(1, 1);
      final c = ProviderContainer(
        overrides: [
          setPieceKeeperCheckProvider.overrideWithValue(
            (careerId, playerId) async => throw StateError('no database'),
          ),
        ],
      );
      addTearDown(c.dispose);
      c.listen(setPieceTakersProvider(1), (_, _) {});
      expect(await c.read(setPieceTakersProvider(1).future), (
        penalty: 1,
        deadBall: 1,
      ));
    });
  });
}
