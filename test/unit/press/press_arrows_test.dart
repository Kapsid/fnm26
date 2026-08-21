import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/press/press.dart';

/// How hard an answer hits, said in arrows.
///
/// The sheet used to print the raw figure — "Squad 6" — a point on a hidden
/// 0–100 scale the manager has never been shown. Six of what?
void main() {
  group('arrows say how far the room moves', () {
    test('saying nothing shows nothing', () {
      expect(Press.arrowsFor(0), 0);
    });

    test('a nudge is one arrow', () {
      expect(Press.arrowsFor(1), 1);
      expect(Press.arrowsFor(2), 1);
    });

    test('a real move is two', () {
      expect(Press.arrowsFor(3), 2);
      expect(Press.arrowsFor(5), 2);
    });

    test('the strongest stance is three', () {
      expect(Press.arrowsFor(6), 3);
      expect(Press.arrowsFor(20), 3);
    });

    test('it never runs past three, however big the total', () {
      for (var v = 0; v <= 200; v++) {
        expect(Press.arrowsFor(v), lessThanOrEqualTo(3));
      }
    });

    test('a fall reads as heavily as a rise', () {
      for (var v = 1; v <= 40; v++) {
        expect(
          Press.arrowsFor(-v),
          Press.arrowsFor(v),
          reason: 'a fall of $v should read as heavy as a rise of $v',
        );
      }
    });
  });

  group('every real answer lands somewhere on the scale', () {
    test('each tone shows at least one arrow somewhere, except silence', () {
      for (final tone in PressTone.values) {
        final e = Press.effectOf(tone);
        final shown = Press.arrowsFor(e.morale) + Press.arrowsFor(e.board);
        if (tone == PressTone.playItDown) {
          expect(shown, 0, reason: 'saying nothing costs nothing');
        } else {
          expect(shown, greaterThan(0), reason: '$tone must read as something');
        }
      }
    });

    test('the strongest stances reach three arrows', () {
      expect(Press.arrowsFor(Press.effectOf(PressTone.backThePlayers).morale), 3);
      expect(Press.arrowsFor(Press.effectOf(PressTone.raiseTheBar).board), 3);
    });

    test('a follow-up reads lighter than the stance it echoes', () {
      // Follow-ups are worth half, rounded toward zero.
      expect(Press.arrowsFor(3), lessThan(Press.arrowsFor(6)));
      expect(Press.arrowsFor(2), lessThan(Press.arrowsFor(4)));
    });
  });
}
