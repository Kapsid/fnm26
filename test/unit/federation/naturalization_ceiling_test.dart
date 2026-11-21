import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/federation/naturalization_rules.dart';

/// Who may be offered for naturalisation: the young may come in good, the
/// older only a notch below, and no world-class man near thirty.
void main() {
  test('the best a candidate may be falls as he gets older', () {
    expect(naturalizationCeiling(20), 82);
    expect(naturalizationCeiling(23), 82);
    expect(naturalizationCeiling(25), 79);
    expect(naturalizationCeiling(29), 76);
    expect(naturalizationCeiling(31), 73);
    expect(naturalizationCeiling(33), isNull);
    for (var age = 18; age < kNaturalizationMaxAge; age++) {
      expect(
        naturalizationCeiling(age + 1)!,
        lessThanOrEqualTo(naturalizationCeiling(age)!),
        reason: 'age $age',
      );
    }
  });

  test('a star only ever comes young', () {
    expect(kNaturalizationStarMaxAge, lessThanOrEqualTo(23));
    expect(kNaturalizationStarMax, lessThan(90));
  });
}
