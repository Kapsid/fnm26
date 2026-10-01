import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/press/press.dart';

void main() {
  test('half of last cycle carries in, the caps still hold', () {
    expect(Press.carryOver([(morale: 4, board: 2)], [(morale: 6, board: -4)]), (
      morale: 7,
      board: 0,
    ));
    expect(
      Press.carryOver([(morale: 12, board: 10)], [(morale: 12, board: 10)]),
      (morale: 12, board: 10),
    );
  });
}
