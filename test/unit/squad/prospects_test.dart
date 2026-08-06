import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/player/prospects.dart';

import '../../helpers/fixtures.dart';

Player kid(int id, {int age = 19, int rating = 62}) => player(
  id: id,
  nationId: 1,
  age: age,
  position: PlayerPosition.cm,
  attributes: flatAttributes(rating),
);

void main() {
  test('only under-21s are on the watchlist', () {
    final list = Prospects.watchlist([
      kid(1, age: 18),
      kid(2, age: 20),
      kid(3, age: 21),
      kid(4, age: 30),
    ]);
    expect(list.map((p) => p.player.id), containsAll([1, 2]));
    expect(list.map((p) => p.player.id), isNot(contains(3)));
    expect(list.map((p) => p.player.id), isNot(contains(4)));
  });

  test('the year\'s improvement is reported', () {
    final list = Prospects.watchlist(
      [kid(1, rating: 68)],
      previousPool: [kid(1, rating: 62)],
    );
    expect(list.single.yearGain, 6);
  });

  test('a newcomer with no history has gained nothing, not everything', () {
    final list = Prospects.watchlist([kid(7, rating: 70)]);
    expect(list.single.yearGain, 0);
  });

  test('the read is a guess until a player has been capped', () {
    final unproven = Prospects.watchlist([kid(11)]).single;
    expect(unproven.certain, isFalse);

    final proven = Prospects.watchlist(
      [kid(11)],
      capsByPlayer: {11: Prospects.capsToKnow},
    ).single;
    expect(proven.certain, isTrue);
    expect(proven.stars, Prospects.trueStars(11));
  });

  test('a scout is never more than a star out', () {
    for (var id = 1; id < 400; id++) {
      final guess = Prospects.watchlist([kid(id, age: 19)]).single.stars;
      expect((guess - Prospects.trueStars(id)).abs(), lessThanOrEqualTo(1));
      expect(guess, inInclusiveRange(1, 5));
    }
  });

  test('the read is stable — a scout does not change his mind on a refresh', () {
    final a = Prospects.watchlist([kid(21)]).single.stars;
    final b = Prospects.watchlist([kid(21)]).single.stars;
    expect(a, b);
  });

  test('promise outranks current ability', () {
    // A five-star teenager on 60 should sit above a one-star on 68: the list
    // is about who they might become.
    final gem = List.generate(
      400,
      (i) => i,
    ).firstWhere((i) => Prospects.trueStars(i) == 5);
    final dud = List.generate(
      400,
      (i) => i,
    ).firstWhere((i) => Prospects.trueStars(i) == 1);
    final list = Prospects.watchlist(
      [kid(dud, rating: 68), kid(gem, rating: 60)],
      capsByPlayer: {gem: 5, dud: 5},
    );
    expect(list.first.player.id, gem);
  });

  test('five stars are rare and one star is uncommon', () {
    var five = 0;
    var one = 0;
    for (var id = 0; id < 2000; id++) {
      final s = Prospects.trueStars(id);
      if (s == 5) five++;
      if (s == 1) one++;
    }
    expect(five / 2000, lessThan(0.2));
    expect(one / 2000, lessThan(0.2));
  });

  group('how well a scout can read a boy', () {
    test('a sixteen-year-old can be two stars out either way', () {
      var sawTwo = false;
      for (var id = 1; id < 3000; id++) {
        final gap =
            (Prospects.scoutedStars(id, age: 16) - Prospects.trueStars(id))
                .abs();
        expect(gap, lessThanOrEqualTo(2));
        if (gap == 2) sawTwo = true;
      }
      expect(sawTwo, isTrue, reason: 'the young read is never really wrong');
    });

    test('a nineteen-year-old is never more than one star out', () {
      var sawOne = false;
      for (var id = 1; id < 3000; id++) {
        final gap =
            (Prospects.scoutedStars(id, age: 19) - Prospects.trueStars(id))
                .abs();
        expect(gap, lessThanOrEqualTo(1));
        if (gap == 1) sawOne = true;
      }
      expect(sawOne, isTrue, reason: 'the older read is not always spot on');
    });

    test('seventeen is the boundary: never more than one star out', () {
      for (var id = 1; id < 3000; id++) {
        final gap =
            (Prospects.scoutedStars(id, age: 17) - Prospects.trueStars(id))
                .abs();
        expect(gap, lessThanOrEqualTo(1));
      }
    });

    test('the read is stable — a scout does not change his mind', () {
      expect(Prospects.scoutedStars(77, age: 15),
          Prospects.scoutedStars(77, age: 15));
    });
  });
}
