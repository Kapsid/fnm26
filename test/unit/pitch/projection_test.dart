import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/match/pitch/pitch_projection.dart';

void main() {
  test(
    'projection maps the four corners into the viewport and preserves left/right',
    () {
      const size = Size(400, 300);
      final p = PitchProjection(size, (centreX: 52.5, zoom: 1));
      final fl = p.toScreen(0, 0), fr = p.toScreen(105, 0);
      final nl = p.toScreen(0, 68), nr = p.toScreen(105, 68);
      for (final o in [fl, fr, nl, nr]) {
        expect(o.dx, inInclusiveRange(0, size.width));
        expect(o.dy, inInclusiveRange(0, size.height));
      }
      expect(fl.dx, lessThan(fr.dx));
      expect(nl.dx, lessThan(nr.dx));
      expect(fr.dx - fl.dx, lessThan(nr.dx - nl.dx));
      expect(fl.dy, lessThan(nl.dy));
      expect(p.scaleAt(0), lessThan(p.scaleAt(68)));
    },
  );
}
