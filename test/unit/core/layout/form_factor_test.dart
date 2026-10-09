import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';

void main() {
  group('logicalSizeOf', () {
    test('divides physical pixels by the pixel ratio', () {
      expect(
        logicalSizeOf(const Size(2388, 1668), 2),
        const Size(1194, 834),
      );
    });
    test('a zero pixel ratio gives Size.zero, never a division by zero', () {
      expect(logicalSizeOf(const Size(2388, 1668), 0), Size.zero);
    });
    test('an empty physical size gives Size.zero', () {
      expect(logicalSizeOf(Size.zero, 2), Size.zero);
    });
  });

  group('FormFactor.fromLogicalSize', () {
    test('a phone in portrait is a phone', () {
      expect(FormFactor.fromLogicalSize(const Size(390, 844)), FormFactor.phone);
    });
    test('a phone in landscape is still a phone', () {
      expect(FormFactor.fromLogicalSize(const Size(844, 390)), FormFactor.phone);
    });
    test('an 11in iPad in landscape is a tablet', () {
      expect(FormFactor.fromLogicalSize(const Size(1194, 834)), FormFactor.tablet);
    });
    test('600 on the short side is exactly the threshold', () {
      expect(FormFactor.fromLogicalSize(const Size(960, 600)), FormFactor.tablet);
      expect(FormFactor.fromLogicalSize(const Size(960, 599)), FormFactor.phone);
    });
  });
}
