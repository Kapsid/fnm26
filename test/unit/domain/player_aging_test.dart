import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
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

  group('the youth discount', () {
    Player at(int age, {int id = 1}) => player(
      id: id,
      nationId: 1,
      position: PlayerPosition.cm,
      age: age,
      attributes: flatAttributes(70),
    );

    test('a twenty-year-old is rated below the same player at peak age', () {
      expect(
        PlayerAging.agedYears(at(20), 0).overall,
        lessThan(PlayerAging.agedYears(at(26), 0).overall),
      );
    });

    test('it eases year by year and is gone by twenty-three', () {
      final ratings = [
        for (var age = 18; age <= 23; age++)
          PlayerAging.agedYears(at(age), 0).overall,
      ];
      for (var i = 1; i < ratings.length; i++) {
        expect(ratings[i], greaterThanOrEqualTo(ratings[i - 1]));
      }
      // Twenty-three is the same player untouched.
      expect(PlayerAging.agedYears(at(23), 0).overall, at(23).overall);
    });

    test('wonderkids exist, but are rare', () {
      // A wonderkid is a nineteen-year-old the discount barely touches. Across
      // a broad sweep of ids that has to be a small minority — finding one is
      // the point.
      const sample = 4000;
      var spared = 0;
      for (var id = 1; id <= sample; id++) {
        final raw = at(19, id: id);
        final shown = PlayerAging.agedYears(raw, 0);
        if (raw.overall - shown.overall <= 1) spared++;
      }
      expect(spared, greaterThan(0));
      expect(spared / sample, lessThan(0.06));
    });
  });

  group('the sub-17 curve', () {
    Player boy(int age) => player(
      id: 4242,
      nationId: 1,
      name: 'Boy',
      position: PlayerPosition.cm,
      age: age,
      attributes: flatAttributes(70),
    );

    test('a child is rated far below the same attributes at senior age', () {
      // Same raw attributes, read at different ages: the discount is what
      // makes a twelve-year-old a twelve-year-old.
      final child = PlayerAging.agedYears(boy(12), 0);
      final senior = PlayerAging.agedYears(boy(25), 0);
      expect(senior.overall - child.overall, greaterThanOrEqualTo(20));
    });

    test('the discount eases year by year all the way up', () {
      var previous = PlayerAging.agedYears(boy(11), 0).overall;
      for (var age = 12; age <= 18; age++) {
        final current = PlayerAging.agedYears(boy(age), 0).overall;
        expect(
          current,
          greaterThanOrEqualTo(previous),
          reason: 'the discount jumped backwards at $age',
        );
        previous = current;
      }
    });

    test('the markdown is pinned, and gone by twenty-three', () {
      // The table is pinned so it can only move on purpose: it decides what a
      // teenager is worth, and every youth band on the pyramid screen is read
      // off it. Twenty-three and up is the senior world and must stay at nought
      // whatever happens below it.
      expect(PlayerAging.agedYears(boy(17), 0).overall, 70 - 11);
      expect(PlayerAging.agedYears(boy(18), 0).overall, 70 - 9);
      expect(PlayerAging.agedYears(boy(19), 0).overall, 70 - 6);
      expect(PlayerAging.agedYears(boy(20), 0).overall, 70 - 4);
      expect(PlayerAging.agedYears(boy(21), 0).overall, 70 - 3);
      expect(PlayerAging.agedYears(boy(22), 0).overall, 70 - 1);
      expect(PlayerAging.agedYears(boy(23), 0).overall, 70);
      expect(PlayerAging.agedYears(boy(26), 0).overall, 70);
    });

    test('the markdown sheds evenly through the teenage years', () {
      // The flat spot between eighteen and twenty was why a nation's U-19s
      // read as good as its U-21s: two years of growing up separated them by
      // barely two rating points, and seven boys an intake are noisier than
      // that. No single year of the ramp may shed less than half of what its
      // neighbour does.
      final steps = [
        for (var age = 17; age <= 22; age++)
          PlayerAging.agedYears(boy(age + 1), 0).overall -
              PlayerAging.agedYears(boy(age), 0).overall,
      ];
      expect(steps.every((s) => s >= 1), isTrue, reason: '$steps');
      expect(steps.reduce((a, b) => a > b ? a : b), lessThanOrEqualTo(3));
    });

    test('a boy grows fast and then slows down', () {
      // Eleven to seventeen must add clearly more than seventeen to twenty
      // does — childhood is where the growth is.
      final childhood =
          PlayerAging.agedYears(boy(11), 6).attributes.physical -
          boy(11).attributes.physical;
      final teens =
          PlayerAging.agedYears(boy(17), 3).attributes.physical -
          boy(17).attributes.physical;
      expect(childhood, greaterThan(teens * 2));
    });
  });
}
