import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/features/shell/tablet_top_bar.dart';

double _contrast(Color a, Color b) {
  final x = a.computeLuminance();
  final y = b.computeLuminance();
  final hi = x > y ? x : y;
  final lo = x > y ? y : x;
  return (hi + 0.05) / (lo + 0.05);
}

bool _isColourful(Color c) => HSLColor.fromColor(c).saturation >= 0.15;

void main() {
  const base = AppColors.surfaceContainerLowest;
  final kits = [
    for (final n
        in (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List)
            .cast<Map<String, dynamic>>())
      (
        code: n['code'] as String,
        primary: n['primaryColor'] as String,
        secondary: n['secondaryColor'] as String,
      ),
  ];

  test('every nation: the bar text and icons keep AA contrast', () {
    expect(kits, hasLength(greaterThan(200)));
    for (final k in kits) {
      final t = TopBarTint.of(k.primary, k.secondary);
      for (final fill in [t.start, t.end]) {
        for (final text in [AppColors.onSurface, AppColors.onSurfaceVariant]) {
          expect(
            _contrast(text, fill),
            greaterThanOrEqualTo(4.5),
            reason: '${k.code}: text on $fill',
          );
        }
        // The inbox icon, in primary: non-text, 3:1 is AA, but it clears 4.5.
        expect(
          _contrast(AppColors.primary, fill),
          greaterThanOrEqualTo(4.5),
          reason: '${k.code}: icon on $fill',
        );
      }
      expect(t.strip, isNotNull, reason: k.code);
    }
  });

  test('the wash stays subtle: never more than 14% of the colour', () {
    for (final k in kits) {
      final t = TopBarTint.of(k.primary, k.secondary);
      for (final fill in [t.start, t.end]) {
        // Each channel moved at most 14% of the way to the strip colour.
        for (final (f, b, s) in [
          (fill.r, base.r, t.strip!.r),
          (fill.g, base.g, t.strip!.g),
          (fill.b, base.b, t.strip!.b),
        ]) {
          expect(
            (f - b).abs(),
            lessThanOrEqualTo((s - b).abs() * 0.14 + 1e-3),
            reason: k.code,
          );
        }
      }
    }
  });

  test('Czech Republic: a red wash, a red strip', () {
    final t = TopBarTint.of('#D7141A', '#11457E');
    expect(t.start, isNot(base));
    expect(t.start.r, greaterThan(t.start.b));
    expect(t.start.r, greaterThan(t.end.r), reason: 'fades to the right');
    final hue = HSLColor.fromColor(t.strip!).hue;
    expect(hue < 10 || hue > 350, isTrue, reason: 'red, at hue $hue');
  });

  test("a white shirt washes in the trim's colour (England's navy)", () {
    final t = TopBarTint.of('#FFFFFF', '#00205B');
    expect(t.start, isNot(base));
    expect(t.start.b, greaterThan(t.start.r));
    expect(_isColourful(t.strip!), isTrue);
  });

  test('a kit with no colour (white and black) keeps the plain bar and '
      'gets a clean light strip', () {
    final t = TopBarTint.of('#FFFFFF', '#000000');
    expect(t.start, base);
    expect(t.end, base);
    expect(t.strip!.computeLuminance(), greaterThan(0.5));
    expect(_isColourful(t.strip!), isFalse);
  });

  test('no nation: the bar as it was, no strip', () {
    expect(TopBarTint.none.start, base);
    expect(TopBarTint.none.end, base);
    expect(TopBarTint.none.strip, isNull);
    final d = TopBarTint.none.decoration;
    expect(d.color, base);
    expect(d.gradient, isNull);
    expect((d.border! as Border).bottom.color.a, 0);
  });
}
