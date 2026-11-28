import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/repositories/drift_player_repository.dart';
import 'package:fnm/data/seed/seed_loader.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/player/learned_positions.dart';
import 'package:fnm/domain/services/player/secondary_positions.dart';
import 'package:fnm/domain/services/tactics/best_eleven.dart';
import 'package:fnm/domain/services/tactics/position_fit.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/test_database.dart';

/// A left winger who runs and tackles: left-back suits him.
const _runner = PlayerAttributes(physical: 74, technical: 66, stamina: 80);

/// A left winger who never defends: centre-back does not suit him at all.
const _flair = PlayerAttributes(physical: 60, technical: 84, stamina: 56);

Player _lw(
  PlayerAttributes a, {
  Map<PlayerPosition, double> learned = const {},
  int id = 1,
}) => Player(
  id: id,
  nationId: 1,
  name: 'W$id',
  age: 25,
  position: PlayerPosition.lw,
  attributes: a,
  // No derived secondary in the way: what is measured is the learning.
  fixedSecondaries: const [],
  learned: learned,
);

void main() {
  group('LearnedPositions', () {
    test('nothing changes for the first few starts', () {
      for (final n in [0.0, 1, 3, 5]) {
        final p = _lw(_runner, learned: {PlayerPosition.lb: n.toDouble()});
        expect(PositionFit.factorFor(p, PlayerPosition.lb), 0.60);
      }
    });

    test('the penalty shrinks start by start, then caps when learned', () {
      var last = 0.60;
      for (var n = 6; n <= 18; n++) {
        final p = _lw(_runner, learned: {PlayerPosition.lb: n.toDouble()});
        final f = PositionFit.factorFor(p, PlayerPosition.lb);
        expect(f, greaterThan(last), reason: '$n starts');
        last = f;
      }
      expect(
        last,
        inInclusiveRange(
          LearnedPositions.learnedMin,
          LearnedPositions.learnedMax,
        ),
      );
      // Learned: more starts add nothing.
      final more = _lw(_runner, learned: {PlayerPosition.lb: 60});
      expect(PositionFit.factorFor(more, PlayerPosition.lb), last);
      expect(
        LearnedPositions.standing(more, PlayerPosition.lb)!.learned,
        isTrue,
      );
    });

    test('a move his qualities do not suit is slower and caps lower', () {
      final suited = _lw(_runner, learned: {PlayerPosition.lb: 18});
      final unsuited = _lw(_flair, learned: {PlayerPosition.lb: 18});
      expect(
        LearnedPositions.suits(PlayerPosition.lw, PlayerPosition.lb, _flair),
        isFalse,
      );
      final halfway = PositionFit.factorFor(unsuited, PlayerPosition.lb);
      expect(
        halfway,
        lessThan(PositionFit.factorFor(suited, PlayerPosition.lb)),
      );
      final done = _lw(_flair, learned: {PlayerPosition.lb: 100});
      expect(
        PositionFit.factorFor(done, PlayerPosition.lb),
        LearnedPositions.unsuitedCap,
      );
      expect(
        LearnedPositions.unsuitedCap,
        lessThan(LearnedPositions.learnedMin),
      );
    });

    test('a move right out of his type barely helps, however long', () {
      // A winger at centre-back: a pair the game never makes.
      expect(
        LearnedPositions.offType(PlayerPosition.lw, PlayerPosition.cb),
        isTrue,
      );
      final none = _lw(_runner);
      final base = PositionFit.factorFor(none, PlayerPosition.cb);
      final years = _lw(_runner, learned: {PlayerPosition.cb: 200});
      final learned = PositionFit.factorFor(years, PlayerPosition.cb);
      expect(learned, greaterThan(base));
      expect(
        learned,
        lessThanOrEqualTo(base + LearnedPositions.offTypeGain + 1e-9),
      );
      // And slowly: after a suited move's whole course, little of it.
      final early = _lw(_runner, learned: {PlayerPosition.cb: 18});
      expect(
        PositionFit.factorFor(early, PlayerPosition.cb) - base,
        lessThan(LearnedPositions.offTypeGain * 0.5),
      );
    });

    test('never above his own position, never below the slot without it', () {
      for (final pos in PlayerPosition.values) {
        for (final n in [0.0, 6, 12, 18, 40]) {
          for (final a in [_runner, _flair]) {
            final p = _lw(a, learned: {pos: n.toDouble()});
            final f = PositionFit.factorFor(p, pos);
            final without = PositionFit.factorFor(_lw(a), pos);
            expect(f, greaterThanOrEqualTo(without));
            if (pos != PlayerPosition.lw) {
              expect(f, lessThanOrEqualTo(LearnedPositions.learnedMax));
            }
          }
        }
      }
      // A keeper never learns the outfield, nor anyone goal.
      final keeper = player(
        id: 9,
        nationId: 1,
        position: PlayerPosition.gk,
      ).copyWith(learned: {PlayerPosition.cb: 40});
      expect(PositionFit.factorFor(keeper, PlayerPosition.cb), 0.55);
      final inGoal = _lw(_runner, learned: {PlayerPosition.gk: 40});
      expect(PositionFit.factorFor(inGoal, PlayerPosition.gk), 0.40);
    });

    test('the better of a secondary position and what he has learned', () {
      final second = _lw(_runner).copyWith(
        fixedSecondaries: const [PlayerPosition.lb],
      );
      final f = PositionFit.factorFor(second, PlayerPosition.lb);
      // A few starts teach him less than he already has: the secondary wins.
      expect(
        PositionFit.factorFor(
          second.copyWith(learned: {PlayerPosition.lb: 8}),
          PlayerPosition.lb,
        ),
        f,
      );
      expect(
        PositionFit.factorFor(
          second.copyWith(learned: {PlayerPosition.lb: 40}),
          PlayerPosition.lb,
        ),
        greaterThanOrEqualTo(f),
      );
    });

    test('fitRank and the best eleven count a learned position', () {
      final learned = _lw(_runner, learned: {PlayerPosition.lb: 40});
      expect(PositionFit.fitRank(_lw(_runner), PlayerPosition.lb), 0);
      expect(PositionFit.fitRank(learned, PlayerPosition.lb), 1);
      expect(PositionFit.boostAt(learned, PlayerPosition.lb), isNotNull);
      expect(PositionFit.boostAt(_lw(_runner), PlayerPosition.lb), isNull);
    });

    test('it fades only after a couple of seasons away', () {
      expect(LearnedPositions.fade(20, 0), 20);
      expect(LearnedPositions.fade(20, 2), 20);
      expect(LearnedPositions.fade(20, 3), 15);
      expect(LearnedPositions.fade(20, 6), 0);
    });

    test('the page reads dots toward learning it', () {
      final p = _lw(_runner, learned: {PlayerPosition.lb: 7});
      final s = LearnedPositions.standing(p, PlayerPosition.lb)!;
      expect((s.starts, s.dots, s.learned), (7.0, 2, false));
      expect(
        LearnedPositions.standing(_lw(_runner), PlayerPosition.lb),
        isNull,
      );
    });
  });

  group('the engine plays a learned position', () {
    test('a side of forwards at the back defends better once learned', () {
      const engine = MatchEngine();
      final places = Formation.f433.positions;
      MatchTeam side(int nationId, {double starts = 0}) => MatchTeam(
        nationId: nationId,
        instructions: const TacticalInstructions(),
        xi: [
          for (var i = 0; i < 11; i++)
            Player(
              id: nationId * 100 + i,
              nationId: nationId,
              name: 'P$i',
              age: 26,
              // Everyone a left winger who can run: wherever the slot is,
              // he is out of position, and a defender's slot suits him.
              position: places[i] == PlayerPosition.gk
                  ? PlayerPosition.gk
                  : PlayerPosition.lw,
              attributes: _runner,
              fixedSecondaries: const [],
              learned: {places[i]: starts},
            ),
        ],
      );
      double conceded({required double starts}) {
        var total = 0.0;
        for (var seed = 0; seed < 120; seed++) {
          final r = engine.play(
            home: side(1, starts: starts),
            away: ratedTeam(2, 72),
            rng: SeededRng(seed),
          );
          total += r.awayXg;
        }
        return total;
      }

      expect(conceded(starts: 40), lessThan(conceded(starts: 0)));
    });
  });

  group('the career history', () {
    late AppDatabase db;
    late DriftPlayerRepository repo;

    setUp(() async {
      db = createTestDatabase();
      await SeedLoader(
        db,
        InMemorySeedSource(
          nationList: [nation(id: 1)],
          playerList: [
            for (var i = 0; i < 16; i++)
              Player(
                id: 100 + i,
                nationId: 1,
                name: 'P$i',
                age: 25,
                position: i == 0 ? PlayerPosition.gk : PlayerPosition.lw,
                attributes: _runner,
              ),
          ],
        ),
      ).ensureSeeded();
      await db.customStatement('PRAGMA foreign_keys = OFF');
      await db.customStatement(
        'INSERT INTO careers (id, nation_id, manager_name, created_at, '
        'in_game_date, rng_seed, cycle_pointer, budget) '
        "VALUES (1, 1, 'M', 0, 0, 7, 1, 5000000)",
      );
      repo = DriftPlayerRepository(db);
    });

    tearDown(() => db.close());

    Future<Player> read(int id, {int aging = 0}) async => (await repo.byNation(
      1,
      careerId: 1,
      agingYears: aging,
      saveSeed: 7,
    )).firstWhere((p) => p.id == id);

    test('an old save with no starts plays as before', () async {
      final p = await read(105);
      expect(p.learned, isEmpty);
      expect(
        PositionFit.factorFor(p, PlayerPosition.lb),
        PositionFit.factor(
          p.position,
          PlayerPosition.lb,
          secondaries: SecondaryPositions.of(p),
        ),
      );
    });

    test(
      'starts accrue, a friendly counts half, his own place nothing',
      () async {
        final p = await read(105);
        for (var i = 0; i < 10; i++) {
          await repo.recordPositionStarts(1, [
            (player: p, position: PlayerPosition.lb),
            (player: p, position: PlayerPosition.lw),
          ], aging: 0);
        }
        await repo.recordPositionStarts(
          1,
          [
            (player: p, position: PlayerPosition.lb),
          ],
          aging: 0,
          friendly: true,
        );
        final again = await read(105);
        expect(again.learned, {PlayerPosition.lb: 10.5});
        // Deterministic from the history: the same read, the same factor.
        expect(
          PositionFit.factorFor(again, PlayerPosition.lb),
          PositionFit.factorFor(await read(105), PlayerPosition.lb),
        );
        expect(
          PositionFit.factorFor(again, PlayerPosition.lb),
          greaterThan(PositionFit.factorFor(p, PlayerPosition.lb)),
        );
        // Another career knows nothing of it.
        final other = (await repo.byNation(
          1,
          saveSeed: 7,
        )).firstWhere((x) => x.id == 105);
        expect(other.learned, isEmpty);
      },
    );

    test('it fades after seasons away', () async {
      final p = await read(105);
      for (var i = 0; i < 20; i++) {
        await repo.recordPositionStarts(1, [
          (player: p, position: PlayerPosition.lb),
        ], aging: 0);
      }
      expect((await read(105, aging: 1)).learned[PlayerPosition.lb], 20);
      expect((await read(105, aging: 3)).learned[PlayerPosition.lb], 15);
    });

    test('an AI side fields a learned man where he learned it', () async {
      final pool = [
        for (final p in await repo.byNation(1, careerId: 1, saveSeed: 7)) p,
      ];
      final keep = pool.firstWhere((p) => p.id == 105);
      const f = Formation.f433;
      final lb = f.positions.indexOf(PlayerPosition.lb);
      // Every man a winger: someone has to play left-back. After a season
      // there, the man who learned it is the one picked.
      for (var i = 0; i < 20; i++) {
        await repo.recordPositionStarts(1, [
          (player: keep, position: PlayerPosition.lb),
        ], aging: 0);
      }
      // Nobody's derived secondary positions in the way.
      final now = [
        for (final p in await repo.byNation(1, careerId: 1, saveSeed: 7))
          p.copyWith(fixedSecondaries: const []),
      ];
      expect(bestEleven(f, now)[lb], 105);
      expect(defaultEleven(f, now)[lb], 105);
    });
  });
}
