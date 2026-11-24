import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/federation/naturalization_rules.dart';
import 'package:fnm/domain/services/player/poaching.dart';

Player _p(int id, {int age = 21, int rating = 70}) => Player(
  id: id,
  nationId: 1,
  name: 'Player $id',
  age: age,
  position: PlayerPosition.st,
  attributes: PlayerAttributes(
    physical: rating,
    technical: rating,
    stamina: rating,
  ),
);

PoachCandidate _c(Player p, {int caps = 0, int competitive = 0}) =>
    (player: p, caps: caps, competitiveCaps: competitive);

Nation _n(int id, int ranking, {Confederation c = Confederation.europe}) =>
    Nation(
      id: id,
      name: 'Nation $id',
      code: 'N$id',
      confederation: c,
      ranking: ranking,
    );

void main() {
  group('markers', () {
    test('an approach reads back from its markers, open until it ends', () {
      final since = DateTime(2027, 3, 1, 12);
      final open = Poaching.parse([
        Poaching.openKind(42, 7, since),
        Poaching.rollKind(since),
        'somethingElse:1',
      ]);
      expect(open.keys, [42]);
      final c = open[42]!;
      expect(c.rivalId, 7);
      expect(c.since, since);
      expect(c.promised, isFalse);
      expect(c.outcome, isNull);
      expect(Poaching.openCase(open)?.playerId, 42);

      final promised = Poaching.parse([
        Poaching.openKind(42, 7, since),
        Poaching.promiseKind(42),
      ]);
      expect(promised[42]!.promised, isTrue);

      final ended = Poaching.parse([
        Poaching.openKind(42, 7, since),
        Poaching.endKind(42, PoachOutcome.switched),
      ]);
      expect(ended[42]!.outcome, PoachOutcome.switched);
      expect(Poaching.openCase(ended), isNull);
    });

    test('unreadable markers are skipped, not thrown on', () {
      final cases = Poaching.parse([
        '${Poaching.openPrefix}x:1:2',
        '${Poaching.openPrefix}1:2',
        '${Poaching.endPrefix}5:nonsense',
        '${Poaching.promisePrefix}abc',
      ]);
      expect(cases, isEmpty);
    });

    test('one roll per quarter of the year', () {
      expect(
        Poaching.rollKind(DateTime(2027, 1, 5)),
        Poaching.rollKind(DateTime(2027, 3, 31)),
      );
      expect(
        Poaching.rollKind(DateTime(2027, 3, 31)),
        isNot(Poaching.rollKind(DateTime(2027, 4, 1))),
      );
    });
  });

  group('targets', () {
    test('only a young man never capped in a competitive match', () {
      expect(Poaching.isTarget(_c(_p(1))), isTrue);
      expect(
        Poaching.isTarget(_c(_p(2), caps: 3)),
        isTrue,
        reason: 'friendly caps do not tie him',
      );
      expect(Poaching.isTarget(_c(_p(3), caps: 1, competitive: 1)), isFalse);
      expect(Poaching.isTarget(_c(_p(4, age: Poaching.maxAge + 1))), isFalse);
      expect(
        Poaching.isTarget(_c(_p(5), caps: kMaxCapsToSwitch + 1)),
        isFalse,
        reason: 'the naturalisation caps rule still holds',
      );
    });

    test('the better and the younger are picked more often', () {
      final star = _p(1, age: 20, rating: 80);
      final squad = _p(2, age: 26, rating: 66);
      var stars = 0;
      for (var seed = 0; seed < 400; seed++) {
        final pick = Poaching.pickTarget([
          _c(star),
          _c(squad),
        ], SeededRng(seed));
        if (pick?.id == star.id) stars++;
      }
      expect(stars, greaterThan(300));
      expect(stars, lessThan(400), reason: 'not a certainty');
      expect(Poaching.pickTarget(const [], SeededRng(1)), isNull);
    });

    test('the pick is the same for the same seed', () {
      final pool = [for (var i = 0; i < 10; i++) _c(_p(i, rating: 60 + i))];
      expect(
        Poaching.pickTarget(pool, SeededRng(99))?.id,
        Poaching.pickTarget(pool.reversed.toList(), SeededRng(99))?.id,
      );
    });
  });

  group('rival', () {
    test('a nation near on the ranking, never the home nation', () {
      final home = _n(1, 50);
      final world = [
        home,
        _n(2, 20),
        _n(3, 55),
        _n(4, 200),
        _n(5, 49, c: Confederation.asia),
      ];
      for (var seed = 0; seed < 50; seed++) {
        final r = Poaching.pickRival(home, world, SeededRng(seed))!;
        expect(r.id, isNot(home.id));
        expect(r.id, isNot(4), reason: '150 places below is not a suitor');
      }
    });

    test('excluded nations are never picked; an empty world picks none', () {
      final home = _n(1, 50);
      final world = [home, _n(2, 51), _n(3, 52)];
      for (var seed = 0; seed < 30; seed++) {
        expect(
          Poaching.pickRival(home, world, SeededRng(seed), excluded: {2})?.id,
          3,
        );
      }
      expect(Poaching.pickRival(home, [home], SeededRng(1)), isNull);
    });
  });

  group('deadline', () {
    PoachOutcome? resolve(
      List<bool> playedIn, {
      bool promised = false,
      bool timedOut = false,
      bool calledUp = false,
      bool friendly = false,
      int seed = 1,
    }) => Poaching.resolve(
      playedIn: playedIn,
      promised: promised,
      timedOut: timedOut,
      calledUp: calledUp,
      friendlyMinutes: friendly,
      rivalStronger: false,
      rng: SeededRng(seed),
    );

    test('minutes in a competitive match in time cap-tie him', () {
      expect(resolve([true]), PoachOutcome.tied);
      expect(resolve([false, true]), PoachOutcome.tied);
    });

    test('open until the deadline matches are played', () {
      expect(resolve(const []), isNull);
      expect(resolve([false]), isNull);
      expect(resolve([false, false], promised: true), isNull);
      expect(resolve(const [], timedOut: true), isNotNull);
    });

    test('a match after the deadline is too late', () {
      final o = resolve([false, false, true]);
      expect(o, isNot(PoachOutcome.tied));
      expect(o, isIn([PoachOutcome.stayed, PoachOutcome.switched]));
    });

    test('a promise buys one more match', () {
      expect(
        Poaching.deadlineFor(promised: true),
        Poaching.deadlineMatches + 1,
      );
      expect(resolve([false, false, true], promised: true), PoachOutcome.tied);
    });

    test('the switch is likelier the less he is involved', () {
      final involved = Poaching.switchChance(
        calledUp: true,
        friendlyMinutes: true,
        promised: false,
        rivalStronger: false,
      );
      final ignored = Poaching.switchChance(
        calledUp: false,
        friendlyMinutes: false,
        promised: false,
        rivalStronger: false,
      );
      final betrayed = Poaching.switchChance(
        calledUp: false,
        friendlyMinutes: false,
        promised: true,
        rivalStronger: true,
      );
      expect(involved, lessThan(ignored));
      expect(ignored, lessThan(betrayed));
      expect(involved, greaterThan(0));
      expect(betrayed, lessThan(1));

      var switched = 0;
      for (var seed = 0; seed < 500; seed++) {
        if (resolve([false, false], seed: seed) == PoachOutcome.switched) {
          switched++;
        }
      }
      expect(switched / 500, closeTo(ignored, 0.08));
    });
  });

  test('its seeds are its own stream', () {
    expect(
      Poaching.seedFor(7, Poaching.approachSalt(DateTime(2027, 2)), 1),
      isNot(Poaching.seedFor(7, Poaching.approachSalt(DateTime(2027, 5)), 1)),
    );
    expect(
      Poaching.seedFor(7, Poaching.deadlineSalt(5), 9),
      Poaching.seedFor(7, Poaching.deadlineSalt(5), 9),
    );
  });
}
