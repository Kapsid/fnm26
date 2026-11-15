import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/services/squad/friendly_rotation.dart';

import '../../helpers/fixtures.dart';

/// An AI side rests two to four of its eight best men for a friendly
/// against the manager, the same men every time the fixture is read.
void main() {
  final pool = [
    for (var i = 0; i < 26; i++)
      player(id: i, nationId: 1, attributes: flatAttributes(90 - i)),
  ];

  test('two to four of the best eight rest, nobody else', () {
    for (var seed = 0; seed < 40; seed++) {
      final rested = FriendlyRotation.rested(pool, SeededRng(seed));
      final out = {for (final p in pool) p.id}
        ..removeAll(rested.map((p) => p.id));
      expect(out.length, inInclusiveRange(2, 4));
      expect(out.every((id) => id < 8), isTrue);
    }
  });

  test('the same fixture rests the same men', () {
    List<int> ids() => [
      for (final p in FriendlyRotation.rested(
        pool,
        FriendlyRotation.rngFor(42, 7),
      ))
        p.id,
    ];
    expect(ids(), ids());
  });

  test('a thin pool is left whole', () {
    final thin = pool.take(16).toList();
    expect(FriendlyRotation.rested(thin, SeededRng(1)), thin);
  });
}
