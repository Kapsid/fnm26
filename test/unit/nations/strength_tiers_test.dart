import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/nations/nation_select_providers.dart';

void main() {
  test('fifths of the field, strongest fifth five bars', () {
    final overalls = {for (var i = 0; i < 10; i++) i: 90 - i};
    expect(
      [for (var i = 0; i < 10; i++) strengthTiers(overalls)[i]],
      [5, 5, 4, 4, 3, 3, 2, 2, 1, 1],
    );
  });

  test('nations level on overall share the tier of the first of them', () {
    expect(strengthTiers({1: 80, 2: 80, 3: 70, 4: 60, 5: 50}), {
      1: 5,
      2: 5,
      3: 3,
      4: 2,
      5: 1,
    });
  });

  test('one nation is the strongest fifth; none is nothing', () {
    expect(strengthTiers({7: 61}), {7: 5});
    expect(strengthTiers(const {}), isEmpty);
  });
}
