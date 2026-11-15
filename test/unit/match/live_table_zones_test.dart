import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/features/match/live_group_table.dart';

/// The live table marks its places as the hub's group table does.
void main() {
  test('qualifiers, contention, play-off nations and the drop', () {
    const z = LiveTableZones(
      direct: 2,
      contention: 3,
      relegate: 1,
      playoffNations: {40},
    );
    expect(z.colorAt(1, 10, count: 6), AppColors.positive);
    expect(z.colorAt(2, 20, count: 6), AppColors.positive);
    expect(z.colorAt(3, 30, count: 6), AppColors.warning);
    // A play-off nation reads yellow wherever it stands below the direct
    // places.
    expect(z.colorAt(4, 40, count: 6), AppColors.playoff);
    expect(z.colorAt(5, 50, count: 6), isNull);
    expect(z.colorAt(6, 60, count: 6), AppColors.error);
    // No drop in a group that relegates none.
    expect(const LiveTableZones(direct: 1).colorAt(6, 60, count: 6), isNull);
  });
}
