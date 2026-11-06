import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/match/pitch/token_painter.dart';

void main() {
  test('a name label never lies on another player when there is room', () {
    final r = math.Random(5);
    for (var trial = 0; trial < 300; trial++) {
      const me = Offset(200, 150);
      const size = Size(60, 12);
      final others = <(Offset, double)>[
        (me, 9),
        for (var i = 0; i < 6; i++)
          (
            Offset(150 + r.nextDouble() * 100, 120 + r.nextDouble() * 60),
            7 + r.nextDouble() * 3,
          ),
      ];
      final box = PlayerToken.labelRect(me, 9, size, others);
      // Every candidate place blocked can happen; then it falls back under
      // the token. Otherwise nothing is covered.
      final covered = others
          .skip(1)
          .any(
            (o) => Rect.fromCenter(
              center: o.$1,
              width: o.$2 * 2.2,
              height: o.$2 * 2,
            ).inflate(1).overlaps(box),
          );
      final fallback = box.top > me.dy && box.center.dx == me.dx;
      expect(!covered || fallback, isTrue);
    }
  });

  test('with a man right under him, the label goes above', () {
    const me = Offset(100, 100);
    final box = PlayerToken.labelRect(me, 9, const Size(50, 12), [
      (me, 9),
      (const Offset(100, 122), 9),
      (const Offset(100 + 30, 122), 9),
      (const Offset(100 - 30, 122), 9),
    ]);
    expect(box.bottom, lessThan(me.dy));
  });
}
