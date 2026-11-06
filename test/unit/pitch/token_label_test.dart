import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/match/pitch/token_painter.dart';

void main() {
  test('a name label never lies on another player when there is room', () {
    final r = math.Random(5);
    var clear = 0;
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
      // The full token box: shirt and chevron, wherever it points.
      final boxes = [
        for (final o in others.skip(1)) PlayerToken.box(o.$1, o.$2),
      ];
      final covered = boxes.any((b) => b.overlaps(box));
      // Covered only when every place it could go is covered too.
      final somewhereClear = PlayerToken.labelCandidates(
        me,
        9,
        size,
      ).any((p) => !boxes.any((b) => b.overlaps(p)));
      expect(!covered || !somewhereClear, isTrue);
      if (!covered) clear++;
    }
    expect(clear, greaterThan(200));
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

  test('a long name does not even clip the head of a man below', () {
    // HARGREAVES over No. 10 in the white-kit mock: the old rule took a
    // token as 2.2 r wide and 2 r high, so a label could still graze the
    // shirt's shoulders and the chevron above them.
    const me = Offset(200, 150);
    const r = 10.0;
    const size = Size(72, 11);
    const below = Offset(214, 178);
    const facingUp = -math.pi / 2;
    final avoid = [PlayerToken.box(below, r, facingUp)];
    final label = PlayerToken.labelRectAvoiding(me, r, size, avoid);
    expect(label.overlaps(avoid.single), isFalse);
    // The first place, right under him, would have clipped the chevron.
    final first = PlayerToken.labelCandidates(me, r, size).first;
    expect(first.overlaps(avoid.single), isTrue);
  });

  test('the full box takes in the chevron on the side he faces', () {
    const c = Offset(50, 50);
    final right = PlayerToken.box(c, 10, 0);
    expect(right.right, greaterThan(c.dx + 15));
    expect(right.left, closeTo(c.dx - 10.4, 0.01));
    final any = PlayerToken.box(c, 10);
    expect(any.contains(right.centerRight.translate(-0.1, 0)), isTrue);
  });

  test('a label by the edge of the frame stays inside it', () {
    const frame = Rect.fromLTWH(0, 0, 390, 280);
    final label = PlayerToken.labelRectAvoiding(
      const Offset(6, 150),
      9,
      const Size(70, 11),
      const [],
      bounds: frame,
    );
    expect(label.left, greaterThanOrEqualTo(0));
    expect(frame.contains(label.topLeft), isTrue);
  });
}
