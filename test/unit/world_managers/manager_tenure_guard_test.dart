import 'package:flutter_test/flutter_test.dart';

import 'manager_lab_world.dart';

/// Pins the turnover the owner asked for (spec section 2): mean tenure 4 to
/// 6 years, about 20% of nations changing per year, mostly after finals, and
/// never more than a quarter of the world at once.
void main() {
  for (final seed in [1, 2]) {
    test('lab seed $seed stays in the tenure band', () {
      final s = runManagerLab(seed: seed);
      expect(s.meanTenureYears, inInclusiveRange(4.0, 6.0));
      expect(s.yearlyChangeShare, inInclusiveRange(0.12, 0.28));
      expect(s.postFinalsShare, greaterThanOrEqualTo(0.5));
      expect(s.maxPointShare, lessThanOrEqualTo(0.25));
    });
  }
}
