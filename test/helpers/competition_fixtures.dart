import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/competition/nations_cups.dart';
import 'package:fnm/features/tournaments/continental_clash_providers.dart';
import 'package:fnm/features/tournaments/continental_detail_providers.dart';
import 'package:fnm/features/tournaments/cup_detail_providers.dart';
import 'package:fnm/features/tournaments/finals_draw_providers.dart';
import 'package:fnm/features/tournaments/intercontinental_playoff_providers.dart';
import 'package:fnm/features/tournaments/nations_cup_draw_providers.dart';
import 'package:fnm/features/tournaments/nations_cup_providers.dart';

import 'seeded_save.dart';

// Fake competition data drawn with the REAL nations, for the screens a fresh
// save has nothing to show on yet (a finals draw, a bracket, a Clash). The
// manager's nation always heads the first group.

Map<int, Nation> get realNationsById => {for (final n in realNations) n.id: n};

/// [count] nations: [first], then the best-ranked of the rest.
List<Nation> fieldOf(int first, int count) {
  final others = [
    for (final n in realNations)
      if (n.id != first) n,
  ]..sort((a, b) => a.ranking.compareTo(b.ranking));
  return [
    realNations.firstWhere((n) => n.id == first),
    ...others.take(count - 1),
  ];
}

/// [groupCount] groups of [size] drawn from [field] as pots would: the first
/// [groupCount] nations are pot 1, one per group, and so on. Each group lists
/// its nations in pot order. Group names run A, B, C...
List<({String name, List<int> nationIds})> groupsOf(
  List<Nation> field, {
  required int groupCount,
  required int size,
}) => [
  for (var g = 0; g < groupCount; g++)
    (
      name: String.fromCharCode(65 + g),
      nationIds: [for (var p = 0; p < size; p++) field[p * groupCount + g].id],
    ),
];

/// A finished round-robin table for [ids], first to last.
List<GroupStanding> standingsOf(List<int> ids) => [
  for (var i = 0; i < ids.length; i++)
    GroupStanding(ids[i])
      ..played = ids.length - 1
      ..won = ids.length - 1 - i
      ..lost = i
      ..goalsFor = 2 * (ids.length - i)
      ..goalsAgainst = i,
];

FinalsDraw finalsDrawOf(List<({String name, List<int> nationIds})> groups) =>
    FinalsDraw(
      groups: [
        for (final g in groups)
          FinalsGroupDraw(
            name: g.name,
            nationIds: g.nationIds,
            fixtures: const [],
          ),
      ],
    );

/// A World Championship finals draw of eight groups of four, not yet watched.
FinalsDrawData fakeFinalsDraw(int playerNationId) {
  final groups = groupsOf(fieldOf(playerNationId, 32), groupCount: 8, size: 4);
  return FinalsDrawData(
    draw: finalsDrawOf(groups),
    nations: realNationsById,
    playerNationId: playerNationId,
    potByNation: {
      for (final g in groups)
        for (var p = 0; p < g.nationIds.length; p++) g.nationIds[p]: p + 1,
    },
    cycle: 0,
    alreadyWatched: false,
  );
}

/// A continental finals draw of six groups of four.
ContinentalDrawData fakeContinentalDraw(int playerNationId) =>
    ContinentalDrawData(
      draw: finalsDrawOf(
        groupsOf(fieldOf(playerNationId, 24), groupCount: 6, size: 4),
      ),
      nations: realNationsById,
      playerNationId: playerNationId,
    );

/// A Nations Cup league draw of four groups of four, not yet watched.
NationsCupDrawData fakeNationsCupDraw(int playerNationId) => NationsCupDrawData(
  leagueLetter: 'A',
  groups: groupsOf(fieldOf(playerNationId, 16), groupCount: 4, size: 4),
  nations: realNationsById,
  playerNationId: playerNationId,
  cycle: 0,
  alreadyWatched: false,
);

/// A World Championship deep into its finals: six qualifying groups of five
/// for the manager's confederation, eight finals groups of four and a played
/// bracket from the last sixteen (the home side always goes through).
CupData fakeCupData(int playerNationId) {
  final me = realNationsById[playerNationId]!;
  final qualifying = groupsOf(
    fieldOf(playerNationId, 30),
    groupCount: 6,
    size: 5,
  );
  final finals = groupsOf(fieldOf(playerNationId, 32), groupCount: 8, size: 4);
  var nextId = 1000;
  Fixture tie(String round, int home, int away) => Fixture(
    id: nextId++,
    careerId: kSeededCareerId,
    competitionId: 99,
    matchday: 1,
    date: DateTime(2030, 7, 1),
    homeNationId: home,
    awayNationId: away,
    homeScore: 2,
    awayScore: 1,
    round: round,
    played: true,
  );
  final r16 = [
    for (var i = 0; i < 8; i++)
      tie(
        WorldCupFinals.r16,
        finals[i].nationIds[0],
        finals[(i + 1) % 8].nationIds[1],
      ),
  ];
  final qf = [
    for (var i = 0; i < 4; i++)
      tie(
        WorldCupFinals.qf,
        r16[2 * i].homeNationId,
        r16[2 * i + 1].homeNationId,
      ),
  ];
  final sf = [
    for (var i = 0; i < 2; i++)
      tie(
        WorldCupFinals.sf,
        qf[2 * i].homeNationId,
        qf[2 * i + 1].homeNationId,
      ),
  ];
  final last = tie(
    WorldCupFinals.finalRound,
    sf[0].homeNationId,
    sf[1].homeNationId,
  );
  return CupData(
    groups: [
      for (final g in qualifying)
        (
          confederation: me.confederation,
          groupName: g.name,
          standings: standingsOf(g.nationIds),
        ),
    ],
    nations: realNationsById,
    playerNationId: playerNationId,
    playerConfederation: me.confederation,
    finalsGroups: [
      for (final g in finals)
        (name: g.name, standings: standingsOf(g.nationIds)),
    ],
    knockout: [...r16, ...qf, ...sf, last],
    champion: last.homeNationId,
    hostId: null,
    scorersQualifying: const [],
    scorersFinals: const [],
    honours: const [],
    playerNames: const {},
  );
}

/// Europe's Nations Cup mid-season: Leagues A and B, two groups of four each,
/// the manager's nation heading B1. No finals drawn yet.
NationsCupData fakeNationsCup(int playerNationId) {
  final groups = groupsOf(fieldOf(playerNationId, 16), groupCount: 4, size: 4);
  const names = ['B1', 'A1', 'A2', 'B2'];
  return (
    confederation: Confederation.europe,
    cupName: NationsCups.europe,
    format: NationsCupFormat.ladder,
    isMine: true,
    playerLeague: 'B',
    playerGroup: 'B1',
    groups: [
      for (var i = 0; i < 4; i++)
        (name: names[i], standings: standingsOf(groups[i].nationIds)),
    ]..sort((a, b) => a.name.compareTo(b.name)),
    roundOf16: const [],
    quarters: const [],
    semis: const [],
    finalFx: const [],
    honours: const [],
    scorers: const [],
    playerNames: const {},
    drawWatched: true,
    playerNationId: playerNationId,
    myNationIds: {playerNationId},
    nations: realNationsById,
    maxTier: 1,
  );
}

/// This cycle's Clash, played: the manager's nation beat the next best 2-1.
ContinentalClashData fakeClash(int playerNationId) {
  final f = fieldOf(playerNationId, 2);
  return (
    tie: Fixture(
      id: 2000,
      careerId: kSeededCareerId,
      competitionId: 98,
      matchday: 1,
      date: DateTime(2029, 6, 1),
      homeNationId: f[0].id,
      awayNationId: f[1].id,
      homeScore: 2,
      awayScore: 1,
      round: 'FFINAL',
      played: true,
    ),
    nations: realNationsById,
    playerNationId: playerNationId,
    honours: const [],
  );
}

/// The play-off: two seeded sides with a bye to a path final, four in the
/// semis. The manager's nation is seeded and wins its final.
PlayoffView fakePlayoff(int playerNationId) {
  final f = [for (final n in fieldOf(playerNationId, 6)) n.id];
  PlayoffTie tie(int home, int away, {bool isFinal = false}) => (
    home: home,
    away: away,
    homeScore: 2,
    awayScore: 1,
    winner: home,
    isFinal: isFinal,
  );
  return (
    ties: [
      tie(f[2], f[3]),
      tie(f[4], f[5]),
      tie(f[0], f[2], isFinal: true),
      tie(f[1], f[4], isFinal: true),
    ],
    nations: realNationsById,
    playerNationId: playerNationId,
  );
}
