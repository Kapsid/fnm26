import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';

void main() {
  group('YouthLevel.forAge', () {
    test('bands are strict under-N', () {
      expect(YouthLevel.forAge(11), YouthLevel.u13);
      expect(YouthLevel.forAge(12), YouthLevel.u13);
      expect(YouthLevel.forAge(13), YouthLevel.u15);
      expect(YouthLevel.forAge(14), YouthLevel.u15);
      expect(YouthLevel.forAge(15), YouthLevel.u17);
      expect(YouthLevel.forAge(16), YouthLevel.u17);
      expect(YouthLevel.forAge(17), YouthLevel.u19);
      expect(YouthLevel.forAge(18), YouthLevel.u19);
      expect(YouthLevel.forAge(19), YouthLevel.u21);
      expect(YouthLevel.forAge(20), YouthLevel.u21);
    });

    test('twenty-one and over is nobody\'s youth level', () {
      expect(YouthLevel.forAge(21), isNull);
      expect(YouthLevel.forAge(30), isNull);
    });

    test('below the intake age there is nobody', () {
      expect(YouthLevel.forAge(10), isNull);
    });

    test('every level covers exactly two years, and they do not overlap', () {
      final covered = <int>[];
      for (final level in YouthLevel.values) {
        expect(level.maxAge - level.minAge, 1);
        for (var age = level.minAge; age <= level.maxAge; age++) {
          covered.add(age);
        }
      }
      expect(covered, covered.toSet().toList());
      expect(covered.length, YouthLevel.values.length * 2);
    });

    test('U-17 and up can be capped, below cannot', () {
      expect(YouthLevel.u13.callable, isFalse);
      expect(YouthLevel.u15.callable, isFalse);
      expect(YouthLevel.u17.callable, isTrue);
      expect(YouthLevel.u19.callable, isTrue);
      expect(YouthLevel.u21.callable, isTrue);
    });
  });
}
