import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/competition/group_advancement.dart';

import '../../helpers/competition_fixtures.dart';

/// Tables mark only where a side is headed as things stand (owner, 1.1.2):
/// the sides holding a cross-group ladder's places are green, the rest of
/// that position plain. [GroupAdvancement.ladderNations] names them for the
/// hub and round results, outside World Championship qualifying.
void main() {
  // Six groups of four; group g's third scores g extra goals, so the thirds
  // rank F, E, D, C, B, A.
  final groups = [
    for (var g = 0; g < 6; g++)
      standingsOf([for (var p = 0; p < 4; p++) 100 + g * 10 + p])
        ..[2].goalsFor += g,
  ];
  int third(int g) => 100 + g * 10 + 2;

  test('a finals group stage: the four best thirds', () {
    for (final kind in [
      CompetitionKind.worldCupFinals,
      CompetitionKind.continentalFinals,
    ]) {
      expect(
        GroupAdvancement.ladderNations(
          kind: kind,
          confederation: Confederation.europe,
          groupCount: 6,
          continentalSize: 24,
          groups: groups,
        ),
        {third(5), third(4), third(3), third(2)},
      );
    }
  });

  test('continental qualifying: the partly covered position', () {
    // Twenty places over six groups: the top three of each go (18), and the
    // two best fourth-placed sides take the rest.
    final out = GroupAdvancement.ladderNations(
      kind: CompetitionKind.continentalQualifying,
      confederation: Confederation.europe,
      groupCount: 6,
      continentalSize: 20,
      groups: groups,
    );
    expect(out, hasLength(2));
    expect(out.every((id) => id % 10 == 3), isTrue);
  });

  test('none where no ladder decides anything', () {
    expect(
      GroupAdvancement.ladderNations(
        kind: CompetitionKind.continentalQualifying,
        confederation: Confederation.europe,
        groupCount: 6,
        continentalSize: 24,
        groups: groups,
        continentalPlayoffRoute: true,
      ),
      isEmpty,
    );
    expect(
      GroupAdvancement.ladderNations(
        kind: CompetitionKind.regionalCup,
        confederation: Confederation.asia,
        groupCount: 2,
        continentalSize: 0,
        groups: groups.take(2).toList(),
      ),
      isEmpty,
    );
  });
}
