import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/rating/overall_rating.dart';

import '../../helpers/fixtures.dart';

void main() {
  test('squad overall averages the best eleven, not the whole squad', () {
    final squad = [
      for (var i = 0; i < 11; i++) playerWithOverall(80, id: i),
      for (var i = 0; i < 12; i++) playerWithOverall(50, id: 100 + i),
    ];
    expect(squadOverall(squad), 80);
  });

  test('a short squad averages what it has', () {
    expect(
      squadOverall([
        playerWithOverall(70, id: 1),
        playerWithOverall(60, id: 2),
      ]),
      65,
    );
  });

  test('an empty squad has no overall', () {
    expect(squadOverall(const []), 0);
  });
}
