import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/y/y_screen.dart';

/// The tablet voices list's avatar initial.
void main() {
  test('the first character of the name', () {
    expect(yInitial('Ana Fan'), 'A');
  });

  test('a whole grapheme, not half of one', () {
    expect(yInitial('Šárka'), 'Š');
    expect(yInitial('👍🏽 fan'), '👍🏽');
  });

  test('an empty name has an empty initial, and does not throw', () {
    expect(yInitial(''), '');
  });
}
