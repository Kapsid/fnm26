import 'dart:convert';
import 'dart:io';

import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/awards/award_year.dart';
import 'package:fnm/domain/services/awards/player_of_year.dart';

/// The Player of the Year calibration set: simulated world-years from the
/// awards lab (`test/story/awards_lab_test.dart`), packed down to what the
/// vote reads (the leading candidates' lines, the trophies decided, the
/// knockout ties that give each nation its run, and each candidate's
/// position, age and rating).
const String kPotyPackPath = 'test/fixtures/awards/poty_world_years.json.gz';

/// One packed world-year.
typedef PackedYear = ({
  int seed,
  int year,

  /// The year's appearance floor over the whole world (see
  /// [PlayerOfYear.floorFor]).
  int floor,
  AwardYear awardYear,
  Map<int, VoterProfile> profiles,
});

/// Packs one year: the top [top] lines on [PlayerOfYear.ceiling], and the
/// [perTrophy] best of every World Championship and continental
/// championship (on the Golden Ball's own score) plus its best keepers.
Map<String, Object?> packYear({
  required int seed,
  required AwardYear y,
  required Map<int, VoterProfile> profiles,
  int top = 40,
  int perTrophy = 25,
}) {
  final keep = <int>{};
  final floor = PlayerOfYear.floorFor(
    y.lines.values,
    need: PlayerOfYear.bestField,
  );
  double ceil(YearLine l) =>
      PlayerOfYear.ceiling(l, y.trophies, minApps: floor);
  final eligible =
      [
        for (final l in y.lines.values)
          if (l.apps >= floor && profiles.containsKey(l.playerId)) l,
      ]..sort((a, b) {
        final s = ceil(b).compareTo(ceil(a));
        return s != 0 ? s : a.playerId.compareTo(b.playerId);
      });
  keep.addAll(eligible.take(top).map((l) => l.playerId));
  // And the young award's field, whose floor falls on its own count.
  final youth =
      [
        for (final l in y.lines.values)
          if (l.apps >= PlayerOfYear.floors.last &&
              PlayerOfYear.young(profiles[l.playerId] ?? _old))
            l,
      ]..sort((a, b) {
        final s = PlayerOfYear.ceiling(b, y.trophies, minApps: 3).compareTo(
          PlayerOfYear.ceiling(a, y.trophies, minApps: 3),
        );
        return s != 0 ? s : a.playerId.compareTo(b.playerId);
      });
  keep.addAll(youth.take(12).map((l) => l.playerId));
  for (final t in y.trophies) {
    if (t.family != TrophyFamily.worldChampionship &&
        t.family != TrophyFamily.continental) {
      continue;
    }
    final inIt = [
      for (final l in y.lines.values)
        if ((l.competitions[t.competitionId]?.apps ?? 0) >= 2 &&
            profiles.containsKey(l.playerId))
          l,
    ];
    double gb(YearLine l) {
      final c = l.competitions[t.competitionId]!;
      return (c.meanRating - 6) * 26 + c.motms * 6 + c.goals * 4;
    }

    inIt.sort((a, b) => gb(b).compareTo(gb(a)));
    keep.addAll(inIt.take(perTrophy).map((l) => l.playerId));
    final keepers =
        inIt
            .where(
              (l) =>
                  profiles[l.playerId]!.position.category ==
                  PositionCategory.goalkeeper,
            )
            .toList()
          ..sort((a, b) {
            final ca = a.competitions[t.competitionId]!;
            final cb = b.competitions[t.competitionId]!;
            return (cb.meanRating * 20 + cb.cleanSheets * 5).compareTo(
              ca.meanRating * 20 + ca.cleanSheets * 5,
            );
          });
    keep.addAll(keepers.take(3).map((l) => l.playerId));
  }
  final trophyComps = {for (final t in y.trophies) t.competitionId};
  double r(double v) => (v * 1000).roundToDouble() / 1000;
  return {
    's': seed,
    'y': y.year,
    'm': floor,
    't': [
      for (final t in y.trophies)
        [
          t.competitionId,
          t.family.name,
          t.confederation.name,
          t.champion,
          t.runnerUp,
          t.semiFinalists,
          {for (final e in t.matchesByNation.entries) '${e.key}': e.value},
        ],
    ],
    'f': [
      for (final f in y.fixtures.values)
        if (trophyComps.contains(f.competitionId) &&
            AwardYear.knockoutDepth(f.round) > 0)
          [f.competitionId, f.round, f.homeNationId, f.awayNationId],
    ],
    'l': [
      for (final id in keep.toList()..sort())
        () {
          final l = y.lines[id]!;
          return [
            l.playerId,
            l.nationId,
            l.apps,
            r(l.ratingSum),
            l.goals,
            l.assists,
            l.motms,
            l.cleanSheets,
            r(l.weight),
            r(l.weightedRating),
            r(l.weightedGoals),
            r(l.weightedAssists),
            r(l.weightedMotms),
            r(l.weightedCleanSheets),
            [
              for (final e in l.competitions.entries)
                if (trophyComps.contains(e.key))
                  [
                    e.key,
                    e.value.apps,
                    r(e.value.ratingSum),
                    e.value.goals,
                    e.value.assists,
                    e.value.motms,
                    e.value.cleanSheets,
                    e.value.depth,
                  ],
            ],
            profiles[id]!.position.name,
            profiles[id]!.age,
            profiles[id]!.overall,
          ];
        }(),
    ],
  };
}

const VoterProfile _old = (
  name: '',
  age: 99,
  position: PlayerPosition.cm,
  overall: 0,
);

/// Reads the packed calibration set.
List<PackedYear> loadPotyPack([String path = kPotyPackPath]) {
  final raw =
      jsonDecode(
            utf8.decode(gzip.decode(File(path).readAsBytesSync())),
          )
          as List<dynamic>;
  return [for (final y in raw) _unpack(y as Map<String, dynamic>)];
}

PackedYear _unpack(Map<String, dynamic> j) {
  final trophies = <TrophyResult>[
    for (final t in j['t'] as List<dynamic>)
      () {
        final a = t as List<dynamic>;
        return TrophyResult(
          competitionId: a[0] as int,
          family: TrophyFamily.values.byName(a[1] as String),
          confederation: Confederation.values.byName(a[2] as String),
          champion: a[3] as int,
          runnerUp: a[4] as int,
          semiFinalists: [for (final s in a[5] as List<dynamic>) s as int],
          matchesByNation: {
            for (final e in (a[6] as Map<String, dynamic>).entries)
              int.parse(e.key): e.value as int,
          },
        );
      }(),
  ];
  final fixtures = <int, AwardFixture>{};
  var fid = 0;
  for (final f in j['f'] as List<dynamic>) {
    final a = f as List<dynamic>;
    fid++;
    fixtures[fid] = (
      id: fid,
      competitionId: a[0] as int,
      kind: CompetitionKind.worldCupFinals,
      confederation: Confederation.europe,
      round: a[1] as String?,
      date: DateTime(j['y'] as int),
      homeNationId: a[2] as int,
      awayNationId: a[3] as int,
      homeScore: 0,
      awayScore: 0,
      homePenalties: null,
      awayPenalties: null,
    );
  }
  final lines = <int, YearLine>{};
  final profiles = <int, VoterProfile>{};
  for (final l in j['l'] as List<dynamic>) {
    final a = l as List<dynamic>;
    double d(int i) => (a[i] as num).toDouble();
    final line = YearLine(a[0] as int, a[1] as int)
      ..apps = a[2] as int
      ..ratingSum = d(3)
      ..goals = a[4] as int
      ..assists = a[5] as int
      ..motms = a[6] as int
      ..cleanSheets = a[7] as int
      ..weight = d(8)
      ..weightedRating = d(9)
      ..weightedGoals = d(10)
      ..weightedAssists = d(11)
      ..weightedMotms = d(12)
      ..weightedCleanSheets = d(13);
    for (final c in a[14] as List<dynamic>) {
      final b = c as List<dynamic>;
      line.competitions[b[0] as int] = CompetitionLine()
        ..apps = b[1] as int
        ..ratingSum = (b[2] as num).toDouble()
        ..goals = b[3] as int
        ..assists = b[4] as int
        ..motms = b[5] as int
        ..cleanSheets = b[6] as int
        ..depth = b[7] as int;
    }
    lines[line.playerId] = line;
    profiles[line.playerId] = (
      name: 'P${line.playerId}',
      age: a[16] as int,
      position: PlayerPosition.values.byName(a[15] as String),
      overall: a[17] as int,
    );
  }
  return (
    seed: j['s'] as int,
    year: j['y'] as int,
    floor: j['m'] as int? ?? 6,
    awardYear: AwardYear(
      year: j['y'] as int,
      lines: lines,
      trophies: trophies,
      fixtures: fixtures,
    ),
    profiles: profiles,
  );
}
