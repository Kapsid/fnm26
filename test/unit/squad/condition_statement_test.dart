import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/squad/condition.dart';

void main() {
  test('the record shifts one player and nobody else', () {
    final asOf = DateTime.utc(2030, 3, 1);
    final base = Condition.of(const [7.0], [DateTime.utc(2030, 2, 1)], asOf, 0);
    final blamed = Condition.of(
      const [7.0],
      [DateTime.utc(2030, 2, 1)],
      asOf,
      0,
      statementDelta: -2,
    );
    expect(blamed.overallDelta, base.overallDelta - 2);
  });
}
