import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/features/match/live_group_table.dart';

/// The live table marks its places as the hub's group table does: only where
/// a side is headed as things stand, never a "still in the race" stripe.
void main() {
  test('qualifiers, ladder sides, play-off nations and the drop', () {
    const z = LiveTableZones(
      direct: 2,
      relegate: 1,
      playoffNations: {40},
      directNations: {30},
    );
    expect(z.colorAt(1, 10, count: 6), AppColors.positive);
    expect(z.colorAt(2, 20, count: 6), AppColors.positive);
    // A third through on the cross-group ladder right now is green.
    expect(z.colorAt(3, 30, count: 6), AppColors.positive);
    // One that is not is unmarked.
    expect(z.colorAt(3, 31, count: 6), isNull);
    // A play-off nation reads yellow wherever it stands below the direct
    // places.
    expect(z.colorAt(4, 40, count: 6), AppColors.playoff);
    expect(z.colorAt(5, 50, count: 6), isNull);
    expect(z.colorAt(6, 60, count: 6), AppColors.error);
    // No drop in a group that relegates none.
    expect(const LiveTableZones(direct: 1).colorAt(6, 60, count: 6), isNull);
  });

  test('a Nations Cup side the ladder leaves in place is unmarked', () {
    const z = LiveTableZones(direct: 1, relegate: 1, undecided: {10, 40});
    expect(z.colorAt(1, 10, count: 4), isNull);
    expect(z.colorAt(4, 40, count: 4), isNull);
    expect(z.colorAt(1, 11, count: 4), AppColors.positive);
    expect(z.colorAt(4, 41, count: 4), AppColors.error);
  });
}
