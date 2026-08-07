import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/features/career/career_providers.dart';

void main() {
  Career at(DateTime date) => Career(
        id: 1,
        managerName: 'Test',
        nationId: 1,
        rngSeed: 7,
        createdAt: CareerService.cycleStart,
        inGameDate: date,
      );

  int agingAt(DateTime date) => CareerService.agingYears(at(date));

  group('CareerService.agingYears', () {
    test('ticks on 1 December, not 1 January', () {
      // The African and Asian championships are played in January. A
      // calendar-year boundary re-rated the whole squad in the middle of those
      // finals — a side reaching the semi-final was not the side that came
      // through the group.
      expect(agingAt(DateTime(2026, 11, 30)), 0);
      expect(agingAt(DateTime(2026, 12, 1)), 1);
      expect(agingAt(DateTime(2027, 1, 1)), 1);
      expect(agingAt(DateTime(2027, 1, 31)), 1);
      expect(agingAt(DateTime(2027, 11, 30)), 1);
      expect(agingAt(DateTime(2027, 12, 1)), 2);
    });

    test('no tick falls inside a January finals', () {
      // Whatever the year, the value on 1 January equals the value through the
      // whole of that month and matches the preceding December.
      for (var year = 2027; year < 2047; year++) {
        final december = agingAt(DateTime(year - 1, 12, 15));
        for (final day in [1, 8, 20, 31]) {
          expect(agingAt(DateTime(year, 1, day)), december,
              reason: 'squad re-rated during January $year');
        }
      }
    });

    test('still advances one year per year', () {
      expect(agingAt(DateTime(2030, 6, 1)) - agingAt(DateTime(2029, 6, 1)), 1);
      expect(agingAt(DateTime(2036, 6, 1)), 10);
    });

    test('never goes negative before the first boundary', () {
      expect(agingAt(CareerService.cycleStart), 0);
      expect(agingAt(DateTime(2026, 9, 1)), 0);
    });
  });
}
