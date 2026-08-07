import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/press/public_mood.dart';

void main() {
  MoodResult r(int mine, int theirs, {bool won = false, bool drew = false}) =>
      (nationRank: mine, opponentRank: theirs, won: won, drew: drew);

  group('PublicMood', () {
    test('nothing to judge reads as neutral', () {
      expect(PublicMood.of(const []), 50);
    });

    test('beating a far better side thrills the public', () {
      // 60th in the world beating the 3rd.
      expect(PublicMood.of([r(60, 3, won: true)]), greaterThan(70));
    });

    test('beating a much weaker side barely registers', () {
      // The board counts this as a win; the public expected it.
      final routine = PublicMood.of([r(10, 90, won: true)]);
      expect(routine, greaterThan(48));
      expect(routine, lessThan(60),
          reason: 'a routine win should not read as triumph');
    });

    test('losing to a far weaker side is a catastrophe', () {
      expect(PublicMood.of([r(10, 90)]), lessThan(25));
    });

    test('losing to a far better side is forgiven', () {
      final noble = PublicMood.of([r(90, 2)]);
      expect(noble, greaterThan(35),
          reason: 'nobody blames you for losing to the best side alive');
    });

    test('a draw sits between the two', () {
      final drewUp = PublicMood.of([r(60, 5, drew: true)]);
      final wonUp = PublicMood.of([r(60, 5, won: true)]);
      final lostUp = PublicMood.of([r(60, 5)]);
      expect(drewUp, lessThan(wonUp));
      expect(drewUp, greaterThan(lostUp));
    });

    test('the public is short-memoried', () {
      // A run of disasters, then one great day: mood should have moved a long
      // way, because the newest result weighs most.
      final after = PublicMood.of([
        r(50, 4, won: true),
        r(50, 80),
        r(50, 80),
        r(50, 80),
      ]);
      expect(after, greaterThan(45));
    });

    test('mood stays inside its range whatever it is fed', () {
      final wild = [
        for (var i = 0; i < 30; i++) r(1, 200, won: i.isEven),
      ];
      final m = PublicMood.of(wild);
      expect(m, inInclusiveRange(0, 100));
    });
  });

  group('boardShift', () {
    test('a neutral public moves the board not at all', () {
      expect(PublicMood.boardShift(50), 0);
    });

    test('the extremes are worth about five points', () {
      expect(PublicMood.boardShift(100), inInclusiveRange(3, 6));
      expect(PublicMood.boardShift(0), inInclusiveRange(-6, -3));
    });
  });
}
