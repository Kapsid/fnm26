import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';

import '../../helpers/fixtures.dart';

void main() {
  final pool = [
    for (var age = 15; age <= 30; age++)
      player(
        id: age,
        nationId: 1,
        name: 'P$age',
        position: PlayerPosition.cm,
        age: age,
        attributes: flatAttributes(70),
      ),
  ];

  test('the default squad never sweeps in a boy', () {
    // The pool reaches down to fifteen so a wonderkid CAN be named — but a
    // manager who has named nobody yet gets the seniors, not the academy.
    final ids = defaultCallUpIds(pool);
    expect(ids.contains(15), isFalse);
    expect(ids.contains(16), isFalse);
    expect(ids.contains(17), isTrue);
    expect(ids.contains(30), isTrue);
  });

  test('it takes every senior, so nobody is quietly dropped', () {
    final seniors = pool.where((p) => p.age >= 17).map((p) => p.id).toSet();
    expect(defaultCallUpIds(pool), seniors);
  });

  test('the boys it excludes are exactly the un-callable levels', () {
    // U-17 is 15–16: selectable when the manager reaches for one, never
    // selected by default. U-19 and up are ordinary squad members.
    for (final p in pool) {
      final level = YouthLevel.forAge(p.age);
      final defaulted = defaultCallUpIds(pool).contains(p.id);
      if (level == YouthLevel.u17) {
        expect(defaulted, isFalse, reason: 'age ${p.age} defaulted in');
      } else {
        expect(defaulted, isTrue, reason: 'age ${p.age} was dropped');
      }
    }
  });
}
