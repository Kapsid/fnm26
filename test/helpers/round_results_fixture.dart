import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/features/results/round_results_screen.dart';

import 'fixtures.dart';

/// Four groups of four (nations 1..16), matchday 3, the manager's nation 1.
RoundResultsView fourGroupsView() {
  final groups = [
    for (var g = 0; g < 4; g++)
      (
        name: String.fromCharCode(65 + g),
        standings: [
          for (var i = 0; i < 4; i++)
            GroupStanding(g * 4 + i + 1)
              ..played = 3
              ..won = 3 - i
              ..lost = i,
        ],
        fixtures: [
          Fixture(
            id: g * 10 + 1,
            careerId: 1,
            competitionId: 1,
            matchday: 3,
            date: DateTime(2027, 9, 10),
            homeNationId: g * 4 + 1,
            awayNationId: g * 4 + 2,
            homeScore: 2,
            awayScore: 1,
            played: true,
          ),
          Fixture(
            id: g * 10 + 2,
            careerId: 1,
            competitionId: 1,
            matchday: 3,
            date: DateTime(2027, 9, 10),
            homeNationId: g * 4 + 3,
            awayNationId: g * 4 + 4,
            homeScore: 0,
            awayScore: 0,
            played: true,
          ),
        ],
      ),
  ];
  return (
    results: (
      competition: 'European Championship Qualifiers',
      kind: CompetitionKind.continentalQualifying,
      groupCount: 4,
      matchday: 3,
      groups: groups,
      stage: null,
      knockoutFixtures: const <Fixture>[],
    ),
    nations: {for (var i = 1; i <= 16; i++) i: nation(id: i)},
    playerNationId: 1,
    directCount: 2,
    contentionPos: 3,
    relegateCount: 0,
    noRelegationGroups: const <String>{},
  );
}
