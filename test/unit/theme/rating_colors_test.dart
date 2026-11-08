import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/core/theme/rating_colors.dart';

/// WCAG contrast ratio between two opaque colours.
double _contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final hi = la > lb ? la : lb;
  final lo = la > lb ? lb : la;
  return (hi + 0.05) / (lo + 0.05);
}

void main() {
  group('bands at their edges', () {
    final cases = {
      5.9: RatingBand.poor,
      6.0: RatingBand.fair,
      6.9: RatingBand.fair,
      7.0: RatingBand.good,
      7.9: RatingBand.good,
      8.0: RatingBand.great,
    };
    for (final MapEntry(key: rating, value: band) in cases.entries) {
      test('$rating is $band', () {
        expect(RatingBand.of(rating), band);
      });
    }

    test('the extremes', () {
      expect(RatingBand.of(3.0), RatingBand.poor);
      expect(RatingBand.of(10.0), RatingBand.great);
    });

    test('a value is banded as printed: 6.96 shows 7.0, so it is good', () {
      expect(RatingBand.of(6.96), RatingBand.good);
      expect(RatingBand.of(5.94), RatingBand.poor);
    });

    test('each boundary changes colour', () {
      for (final set in [RatingBandColors.dark, RatingBandColors.light]) {
        Color fill(double r) => set.fill(RatingBand.of(r));
        expect(fill(5.9), set.poor);
        expect(fill(6.0), set.fair);
        expect(fill(6.9), set.fair);
        expect(fill(7.0), set.good);
        expect(fill(7.9), set.good);
        expect(fill(8.0), set.great);
        expect({set.poor, set.fair, set.good, set.great}, hasLength(4));
      }
    });
  });

  group('contrast', () {
    test('every ink passes AA (4.5:1) on its fill, dark and light', () {
      for (final (name, set) in [
        ('dark', RatingBandColors.dark),
        ('light', RatingBandColors.light),
      ]) {
        for (final band in RatingBand.values) {
          expect(
            _contrast(set.ink(band), set.fill(band)),
            greaterThanOrEqualTo(4.5),
            reason: '$name $band',
          );
        }
      }
    });

    test('every dark fill stands 3:1 off the card surface', () {
      for (final band in RatingBand.values) {
        expect(
          _contrast(
            RatingBandColors.dark.fill(band),
            AppColors.surfaceContainer,
          ),
          greaterThanOrEqualTo(3),
          reason: '$band',
        );
      }
    });

    test('the app theme carries the dark set', () {
      expect(
        AppTheme.theme.extension<RatingBandColors>(),
        RatingBandColors.dark,
      );
    });
  });
}
