import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/press/press.dart';

void main() {
  group('arrows say how far the room moves', () {
    test('saying nothing shows nothing', () {
      expect(Press.arrowsFor(0), 0);
    });

    test('a nudge is one arrow, a real move two, a stance three', () {
      expect(Press.arrowsFor(1), 1);
      expect(Press.arrowsFor(2), 1);
      expect(Press.arrowsFor(3), 2);
      expect(Press.arrowsFor(5), 2);
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
        expect(Press.arrowsFor(-v), Press.arrowsFor(v));
      }
    });
  });

  group('a conference lands as a verdict', () {
    test('nothing said is flat', () {
      expect(Press.verdictOf((morale: 0, board: 0)), PressVerdict.flat);
    });

    test('a good net is went, a bad one badly, the middle mixed', () {
      expect(Press.verdictOf((morale: 3, board: 1)), PressVerdict.went);
      expect(Press.verdictOf((morale: -3, board: -1)), PressVerdict.badly);
      expect(Press.verdictOf((morale: 3, board: -3)), PressVerdict.mixed);
      expect(Press.verdictOf((morale: 1, board: 2)), PressVerdict.mixed);
    });
  });

  group('the totals are capped', () {
    test('a manager cannot talk their way to a title', () {
      final total = Press.totalOf(List.filled(20, (morale: 6, board: 6)));
      expect(total, (morale: 12, board: 10));
      final low = Press.totalOf(List.filled(20, (morale: -6, board: -6)));
      expect(low, (morale: -12, board: -10));
    });

    test('opposite answers cancel out', () {
      expect(
        Press.totalOf([(morale: 6, board: -3), (morale: -5, board: 4)]),
        (morale: 1, board: 1),
      );
    });

    test('half of last cycle carries in, the caps still hold', () {
      expect(
        Press.carryOver([(morale: 4, board: 2)], [(morale: 6, board: -4)]),
        (morale: 7, board: 0),
      );
      expect(
        Press.carryOver([(morale: 12, board: 10)], [(morale: 12, board: 10)]),
        (morale: 12, board: 10),
      );
    });
  });

  group('the room', () {
    test('is the same for the same seed and holds every reporter once', () {
      final a = Press.roomFor(7);
      expect(Press.roomFor(7), a);
      expect({for (final r in a) r.name}.length, a.length);
    });

    test('differs between seeds', () {
      expect(Press.roomFor(1), isNot(Press.roomFor(2)));
    });
  });
}
