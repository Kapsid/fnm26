import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/federation/naturalization_rules.dart';
import 'package:fnm/domain/services/federation/naturalization_suitors.dart';
import 'package:fnm/domain/services/nation/dormant_nations.dart';
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
    /// A world of [size] nations ranked 1..size (id = ranking), plus the
    /// dormant micro-nations where a campaign world would put them.
    List<Nation> world(int size) => [
      for (var r = 1; r <= size; r++)
        _n(r, r, c: r.isEven ? Confederation.europe : Confederation.asia),
    ];

    test('only a stronger side asks, never the home nation', () {
      final w = world(200);
      for (final rank in [5, 40, 80, 150]) {
        final home = w[rank - 1];
        for (var seed = 0; seed < 300; seed++) {
          final r = Poaching.pickRival(home, w, SeededRng(seed))!;
          expect(r.id, isNot(home.id));
          expect(
            r.ranking,
            lessThan(home.ranking),
            reason: 'a weaker side than #$rank never asks',
          );
        }
      }
      expect(
        Poaching.pickRival(w.first, w, SeededRng(1)),
        isNull,
        reason: 'nobody stands above the top side',
      );
    });

    test('the suitors lean to the top of the table', () {
      final w = world(200);
      final home = w[119]; // 120th
      var top60 = 0;
      var clearlyAbove = 0;
      const n = 2000;
      for (var seed = 0; seed < n; seed++) {
        final r = Poaching.pickRival(home, w, SeededRng(seed))!;
        if (r.ranking <= 60) top60++;
        if (home.ranking - r.ranking >= 10) clearlyAbove++;
      }
      expect(top60 / n, greaterThan(0.75));
      expect(clearlyAbove / n, greaterThan(0.95));
    });

    test('the bottom of the table and the micro-nations never ask', () {
      final w = [
        ...world(208),
        DormantNations.vatican, // 209th, the weakest side there is
        DormantNations.greenland,
      ];
      // Even for a home side below them on paper, they stay out.
      final home = _n(999, 230);
      final all = [...w, home];
      final seen = <int>{};
      for (var seed = 0; seed < 2000; seed++) {
        seen.add(Poaching.pickRival(home, all, SeededRng(seed))!.id);
      }
      expect(seen, isNot(contains(DormantNations.vaticanId)));
      expect(seen, isNot(contains(DormantNations.greenlandId)));
      expect(
        seen.every((id) => id <= 211 - NaturalizationSuitors.bottomExcluded),
        isTrue,
        reason: 'the last places of the table never ask',
      );
    });

    test('a keener rival the further above it stands', () {
      final w = world(200);
      final home = w[99];
      final near = NaturalizationSuitors.appetite(home, w[95], w);
      final far = NaturalizationSuitors.appetite(home, w[9], w);
      expect(far, greaterThan(near));
      expect(near, greaterThan(0));
      expect(NaturalizationSuitors.appetite(home, w[150], w), 0);
    });

    test("he has to walk into the rival's squad, or nearly", () {
      final ratings = [for (var r = 90; r > 60; r--) r]; // 90 down to 61
      // The 23rd best is 68: 66 and up interest it.
      expect(Poaching.interestBar(ratings), 68 - Poaching.nearlyMargin);
      expect(Poaching.interestBar([70, 65]), 65 - Poaching.nearlyMargin);
      expect(Poaching.interestBar(const []), isNull);
    });

    test('excluded nations are never picked; an empty world picks none', () {
      final home = _n(1, 50);
      final w = [home, _n(2, 10), _n(3, 20)];
      for (var seed = 0; seed < 30; seed++) {
        expect(
          Poaching.pickRival(home, w, SeededRng(seed), excluded: {2})?.id,
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
