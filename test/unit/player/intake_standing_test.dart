import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/player/intake_standing.dart';

void main() {
  group('IntakeStanding.bonus', () {
    test('a nation climbing the ladder produces better boys than a falling one', () {
      final rising = IntakeStanding.bonus(
        worldRank: 30,
        rankChangeOverCycle: 25,
        titlesWon: const {},
      );
      final falling = IntakeStanding.bonus(
        worldRank: 30,
        rankChangeOverCycle: -25,
        titlesWon: const {},
      );
      expect(rising, greaterThan(falling));
      expect(rising, greaterThan(0));
      expect(falling, lessThan(0));
    });

    test('the bonus stays inside a band a generation cannot break', () {
      final best = IntakeStanding.bonus(
        worldRank: 1,
        rankChangeOverCycle: 60,
        titlesWon: const {'World Championship'},
      );
      expect(best, lessThanOrEqualTo(0.06));
    });

    // THE NULL CONTROL. A nation that neither moved nor won anything must draw
    // exactly the academy's own bonus and not a point more — at any rank. Two
    // balance changes in this batch shipped a systematic bias that a control
    // like this would have caught on the first run, so it is permanent.
    test('a side that neither moved nor won anything earns nothing', () {
      for (final rank in [1, 5, 25, 40, 100, 180]) {
        expect(
          IntakeStanding.bonus(
            worldRank: rank,
            rankChangeOverCycle: 0,
            titlesWon: const {},
          ),
          0.0,
          reason: 'rank $rank standing still must add nothing',
        );
      }
    });

    test('a hard ceiling no run of form can break', () {
      // Every trophy in the world, from last to first, is still capped.
      final absurd = IntakeStanding.bonus(
        worldRank: 1,
        rankChangeOverCycle: 400,
        titlesWon: const {
          'World Championship',
          'European Championship',
          'Copa America',
          'Nations Cup',
        },
      );
      expect(absurd, IntakeStanding.maxBonus);
    });

    test('a collapse is thinner than a rise is generous, and has a floor', () {
      final collapse = IntakeStanding.bonus(
        worldRank: 190,
        rankChangeOverCycle: -189,
        titlesWon: const {},
      );
      expect(collapse, IntakeStanding.minBonus);
      expect(IntakeStanding.minBonus.abs(), lessThan(IntakeStanding.maxBonus));
    });

    test('movement is priced in ranking points, not places', () {
      // The world table is not a straight line: five places at the top are
      // worth far more than five in the middle of it.
      final atTheTop = IntakeStanding.bonus(
        worldRank: 1,
        rankChangeOverCycle: 5,
        titlesWon: const {},
      );
      final midTable = IntakeStanding.bonus(
        worldRank: 60,
        rankChangeOverCycle: 5,
        titlesWon: const {},
      );
      expect(atTheTop, greaterThan(midTable * 4));
    });

    test('a title counts even when the table barely moved', () {
      final quietChampion = IntakeStanding.bonus(
        worldRank: 3,
        rankChangeOverCycle: 0,
        titlesWon: const {'World Championship'},
      );
      expect(quietChampion, IntakeStanding.maxTitleBonus);
      final continental = IntakeStanding.bonus(
        worldRank: 3,
        rankChangeOverCycle: 0,
        titlesWon: const {'European Championship'},
      );
      expect(continental, lessThan(quietChampion));
      expect(continental, greaterThan(0));
    });

    test('the realistic middle of the range is a nudge, not a rebuild', () {
      // A good but unremarkable cycle: up ten places in mid-table.
      final decent = IntakeStanding.bonus(
        worldRank: 45,
        rankChangeOverCycle: 10,
        titlesWon: const {},
      );
      expect(decent, greaterThan(0));
      expect(decent, lessThan(0.01));
    });
  });

  group('measured', () {
    test('the range, printed for the balance record', () {
      String at(int rank, int change, Set<String> titles) => IntakeStanding
          .bonus(
            worldRank: rank,
            rankChangeOverCycle: change,
            titlesWon: titles,
          )
          .toStringAsFixed(4);
      // Not assertions — a readable trace of what the dial is set to.
      // ignore: avoid_print
      print(
        'ceiling ${at(1, 60, const {'World Championship'})} | '
        'champion 25 to 5 ${at(5, 20, const {'World Championship'})} | '
        'climb 55 to 30 ${at(30, 25, const {})} | '
        'still ${at(30, 0, const {})} | '
        'fall 5 to 30 ${at(30, -25, const {})} | '
        'floor ${at(190, -189, const {})}',
      );
    });
  });
}
