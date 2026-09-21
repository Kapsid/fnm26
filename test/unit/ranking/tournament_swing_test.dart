import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/ranking/elo.dart';

/// What a tournament is worth to the ranking.
///
/// The reported complaint: "success at a tournament should boost the ranking
/// more", and "I don't see the big jump after the World Championship anywhere".
/// A championship won on penalties against sides you were already expected to
/// beat moved a nation barely at all, because only the MATCHES counted and none
/// of those matches read as an upset. The trophy itself was worth nothing.
///
/// The bands below are written as intent, not as magic numbers:
///  * winning the World Championship from outside the top twenty must leave a
///    nation among the best handful — that is what it has just proved;
///  * going out in the group stage of a tournament you were favoured to win
///    must cost ground;
///  * an ordinary qualifying win must still be worth less than a world place.
///
/// THE NULL CONTROLS (a lesson from the tactics-balance harness earlier in this
/// batch, which tied "who is at home" to the parity of the seed index and read
/// +0.083 on a case whose true answer was 0.000): every measurement here has a
/// companion case whose correct answer is known to be exactly zero, asserted as
/// a permanent test —
///  * which side is nominally at home changes nothing (this Elo has no home
///    advantage), so every match below is played both ways and averaged;
///  * the placing exchange is zero-sum: the whole field's placing points sum to
///    exactly zero;
///  * a field in which everybody finished level moves nobody;
///  * a nation that did not enter the tournament does not gain or lose a point.
void main() {
  // --- the harness ------------------------------------------------------

  /// A seeded world of 220 nations, id == static seed rank.
  Map<int, int> seededWorld() => {
    for (var rank = 1; rank <= 220; rank++) rank: Elo.seedFromRanking(rank),
  };

  /// One world place, in points, at the seeded spread (see
  /// [Elo.seedFromRanking]: 4 points per place).
  const pointsPerPlace = 4;

  int positionOf(Map<int, int> points, int id) => Elo.positions(points)[id]!;

  /// The points [a] takes from a match against [b], where [actual] is 1 (win),
  /// 0.5 (draw, including a shootout) or 0 (defeat).
  ///
  /// Played BOTH ways and averaged rather than picking an orientation: this
  /// model has no home advantage, so the two must agree, and averaging keeps
  /// the harness from smuggling an orientation bias into a measurement.
  int deltaFor({
    required int aPoints,
    required int bPoints,
    required double actual,
    required double weight,
  }) {
    final aScore = actual == 1.0 ? 1 : (actual == 0.5 ? 1 : 0);
    final bScore = actual == 1.0 ? 0 : (actual == 0.5 ? 1 : 1);
    final asHome = Elo.homeDelta(
      homePoints: aPoints,
      awayPoints: bPoints,
      homeScore: aScore,
      awayScore: bScore,
      weight: weight,
    );
    final asAway = -Elo.homeDelta(
      homePoints: bPoints,
      awayPoints: aPoints,
      homeScore: bScore,
      awayScore: aScore,
      weight: weight,
    );
    return ((asHome + asAway) / 2).round();
  }

  /// Plays [run] — (opponent id, result for [nation]) — through [points] at the
  /// settled-finals weight, the way the World Championship is settled.
  void playRun(Map<int, int> points, int nation, List<(int, double)> run) {
    for (final (opponent, actual) in run) {
      final d = deltaFor(
        aPoints: points[nation]!,
        bPoints: points[opponent]!,
        actual: actual,
        weight: Elo.finalsSettled,
      );
      points[nation] = points[nation]! + d;
      points[opponent] = points[opponent]! - d;
    }
  }

  /// A full 48-team field's placings, with [nation] finishing [placing] and the
  /// rest of the field filling the bracket out (16 group exits, 16 in the round
  /// of 32, 8 in the last 16, 4 quarter-finalists, then the four semi-finalists
  /// and the finalists). Nations are drawn from ids the run does not use.
  Map<int, FinalsPlacing> fieldWith(int nation, FinalsPlacing placing) {
    final shape = <FinalsPlacing>[
      ...List.filled(16, FinalsPlacing.groupStage),
      ...List.filled(16, FinalsPlacing.roundOf32),
      ...List.filled(8, FinalsPlacing.roundOf16),
      ...List.filled(4, FinalsPlacing.quarterFinal),
      FinalsPlacing.fourth,
      FinalsPlacing.third,
      FinalsPlacing.runnerUp,
      FinalsPlacing.champion,
    ]..remove(placing);
    final field = <int, FinalsPlacing>{nation: placing};
    var id = 101;
    for (final p in shape) {
      while (field.containsKey(id)) {
        id++;
      }
      field[id++] = p;
    }
    return field;
  }

  /// Settles a whole tournament: the matches, then the placings.
  void settle(
    Map<int, int> points,
    int nation,
    List<(int, double)> run,
    FinalsPlacing placing,
  ) {
    playRun(points, nation, run);
    final placings = Elo.placementDeltas(fieldWith(nation, placing));
    for (final e in placings.entries) {
      points[e.key] = (points[e.key] ?? Elo.base) + e.value;
    }
  }

  /// A championship won without ever looking convincing: two expected wins and
  /// a draw in the group, a win over a weaker side in the last 32, three
  /// shootouts, and a final won against a better-ranked opponent.
  const unconvincingRun = <(int, double)>[
    (60, 1.0),
    (75, 0.5),
    (90, 1.0),
    (45, 1.0),
    (28, 0.5),
    (22, 0.5),
    (18, 0.5),
    (15, 1.0),
  ];

  /// A run that beat good sides all the way.
  const convincingRun = <(int, double)>[
    (40, 1.0),
    (55, 0.5),
    (70, 1.0),
    (30, 1.0),
    (15, 0.5),
    (10, 1.0),
    (4, 0.5),
    (2, 1.0),
  ];

  // --- the null controls ------------------------------------------------

  test('NULL CONTROL: which side is at home changes nothing', () {
    // This model carries no home advantage, so the same match played from the
    // other end must move the same nation by exactly the same amount. If this
    // ever reads non-zero, every number measured above it is an artefact.
    for (final gap in [0, 40, 120, 400, -250]) {
      for (final actual in [0.0, 0.5, 1.0]) {
        final home = Elo.base + gap;
        final aScore = actual == 1.0 ? 1 : (actual == 0.5 ? 1 : 0);
        final bScore = actual == 1.0 ? 0 : (actual == 0.5 ? 1 : 1);
        final asHome = Elo.homeDelta(
          homePoints: home,
          awayPoints: Elo.base,
          homeScore: aScore,
          awayScore: bScore,
          weight: Elo.finalsSettled,
        );
        final asAway = -Elo.homeDelta(
          homePoints: Elo.base,
          awayPoints: home,
          homeScore: bScore,
          awayScore: aScore,
          weight: Elo.finalsSettled,
        );
        expect(
          asHome - asAway,
          0,
          reason: 'orientation bias at gap $gap, result $actual',
        );
      }
    }
  });

  test('NULL CONTROL: the placing exchange is zero-sum', () {
    for (final placing in FinalsPlacing.values) {
      final deltas = Elo.placementDeltas(fieldWith(7, placing));
      expect(deltas.length, 48);
      expect(
        deltas.values.fold<int>(0, (a, b) => a + b),
        0,
        reason: 'the world total must be conserved (field of ${deltas.length})',
      );
    }
    // Odd field sizes round differently; conservation must still be exact.
    for (final size in [3, 5, 16, 17, 24]) {
      final field = {
        for (var i = 0; i < size; i++)
          i: FinalsPlacing.values[i % FinalsPlacing.values.length],
      };
      expect(
        Elo.placementDeltas(field).values.fold<int>(0, (a, b) => a + b),
        0,
        reason: 'field of $size',
      );
    }
  });

  test('NULL CONTROL: a field that all finished level moves nobody', () {
    for (final placing in FinalsPlacing.values) {
      final field = {for (var i = 0; i < 16; i++) i: placing};
      final deltas = Elo.placementDeltas(field);
      expect(
        deltas.values.every((d) => d == 0),
        isTrue,
        reason: 'no placing was better than any other, so nothing is owed',
      );
    }
    expect(Elo.placementDeltas(const {}), isEmpty);
  });

  test('NULL CONTROL: a nation that stayed at home keeps its points', () {
    final points = seededWorld();
    final before = Map<int, int>.from(points);
    settle(points, 25, unconvincingRun, FinalsPlacing.champion);
    // Id 200 is neither in the run nor in the field this harness builds.
    expect(points[200], before[200]);
  });

  // --- the bands --------------------------------------------------------

  test('winning the championship from outside the top twenty makes a nation '
      'one of the best handful', () {
    for (final start in [25, 30, 40]) {
      final points = seededWorld();
      expect(positionOf(points, start), start);
      settle(points, start, unconvincingRun, FinalsPlacing.champion);
      final after = positionOf(points, start);
      expect(
        after,
        lessThanOrEqualTo(5),
        reason:
            'a champion from #$start finished #$after — it just beat the '
            'world and should be read as one of the best',
      );
      expect(after, lessThan(start - 15));
    }
  });

  test('a convincing champion goes to the very top', () {
    final points = seededWorld();
    settle(points, 25, convincingRun, FinalsPlacing.champion);
    expect(positionOf(points, 25), lessThanOrEqualTo(3));
  });

  test('the trophy itself is worth a real part of the climb', () {
    // The whole point of the change: winning moves a nation BECAUSE it won,
    // not only because the eight matches happened to read as upsets.
    // Measured in POINTS, not positions: near the top of the table the places
    // are only four points apart and a champion runs out of table to climb, so
    // positions understate what the trophy is worth.
    final matchesOnly = seededWorld();
    playRun(matchesOnly, 25, unconvincingRun);
    final withTrophy = seededWorld();
    settle(withTrophy, 25, unconvincingRun, FinalsPlacing.champion);
    final fromMatches = matchesOnly[25]! - Elo.seedFromRanking(25);
    final fromTrophy = withTrophy[25]! - matchesOnly[25]!;
    expect(
      fromTrophy,
      greaterThanOrEqualTo(10 * pointsPerPlace),
      reason: 'the placing alone should be worth a stretch of the table',
    );
    // ...and still not the whole story: how the tournament was won matters.
    expect(
      fromTrophy,
      lessThan(fromMatches * 2),
      reason: 'the trophy tops the run up, it does not replace it',
    );
  });

  test('a favourite dumped out in the group stage loses ground', () {
    for (final fav in [2, 6]) {
      final points = seededWorld();
      final before = points[fav]!;
      settle(points, fav, const [
        (30, 0.0),
        (45, 1.0),
        (20, 0.0),
      ], FinalsPlacing.groupStage);
      expect(points[fav], lessThan(before));
      expect(
        positionOf(points, fav),
        greaterThan(fav + 5),
        reason: 'a favourite out in the group must visibly slip',
      );
    }
  });

  test('going out early costs a favourite more than a deep run pays a '
      'no-hoper nothing', () {
    // Ordering of the placings themselves, independent of any match.
    final field = <int, FinalsPlacing>{};
    var id = 0;
    for (final p in [
      ...List.filled(16, FinalsPlacing.groupStage),
      ...List.filled(16, FinalsPlacing.roundOf32),
      ...List.filled(8, FinalsPlacing.roundOf16),
      ...List.filled(4, FinalsPlacing.quarterFinal),
      FinalsPlacing.fourth,
      FinalsPlacing.third,
      FinalsPlacing.runnerUp,
      FinalsPlacing.champion,
    ]) {
      field[id++] = p;
    }
    final deltas = Elo.placementDeltas(field);
    int forPlacing(FinalsPlacing p) =>
        deltas[field.entries.firstWhere((e) => e.value == p).key]!;
    expect(forPlacing(FinalsPlacing.champion), greaterThan(0));
    expect(forPlacing(FinalsPlacing.groupStage), lessThan(0));
    for (var i = 1; i < FinalsPlacing.values.length; i++) {
      expect(
        forPlacing(FinalsPlacing.values[i]),
        greaterThan(forPlacing(FinalsPlacing.values[i - 1])),
        reason: 'finishing higher must always be worth more',
      );
    }
  });

  test('an ordinary qualifier still moves a nation by less than a place', () {
    // THE EXISTING GUARD, restated in places: the routine qualifier — a good
    // side beating a much weaker one — must not rewrite the table. (Elo only
    // pays well for an upset, so this is the case that recurs most.)
    final points = seededWorld();
    final before = positionOf(points, 5);
    final d = deltaFor(
      aPoints: points[5]!,
      bPoints: points[100]!,
      actual: 1,
      weight: Elo.qualifier,
    );
    expect(d.abs(), lessThan(pointsPerPlace));
    points[5] = points[5]! + d;
    points[100] = points[100]! - d;
    expect(positionOf(points, 5), before);
  });

  test('the placings are read off the rounds a nation played', () {
    // How the settlement derives a placing from the fixtures it already walks.
    final placings = Elo.placingsFromRounds(const [
      (round: 'GROUP', home: 1, away: 2, homeScore: 1, awayScore: 0),
      (round: 'GROUP', home: 3, away: 4, homeScore: 2, awayScore: 2),
      (round: 'R16', home: 1, away: 3, homeScore: 1, awayScore: 0),
      (round: 'QF', home: 1, away: 5, homeScore: 2, awayScore: 1),
      (round: 'SF', home: 1, away: 6, homeScore: 1, awayScore: 0),
      (round: 'SF', home: 7, away: 8, homeScore: 0, awayScore: 1),
      (round: '3RD', home: 6, away: 7, homeScore: 3, awayScore: 1),
      (round: 'FINAL', home: 8, away: 1, homeScore: 0, awayScore: 2),
    ]);
    expect(placings[1], FinalsPlacing.champion);
    expect(placings[8], FinalsPlacing.runnerUp);
    expect(placings[6], FinalsPlacing.third);
    expect(placings[7], FinalsPlacing.fourth);
    expect(placings[5], FinalsPlacing.quarterFinal);
    expect(placings[3], FinalsPlacing.roundOf16);
    expect(placings[2], FinalsPlacing.groupStage);
    expect(placings[4], FinalsPlacing.groupStage);
  });

  test(
    'a continental bracket with no third-place play-off shares the bronze',
    () {
      final placings = Elo.placingsFromRounds(const [
        (round: 'CGROUP', home: 1, away: 2, homeScore: 1, awayScore: 0),
        (round: 'CSF', home: 1, away: 3, homeScore: 1, awayScore: 0),
        (round: 'CSF', home: 4, away: 5, homeScore: 2, awayScore: 1),
        (round: 'CFINAL', home: 1, away: 4, homeScore: 1, awayScore: 0),
      ]);
      expect(placings[1], FinalsPlacing.champion);
      expect(placings[4], FinalsPlacing.runnerUp);
      expect(placings[3], FinalsPlacing.third);
      expect(placings[5], FinalsPlacing.third);
    },
  );
}
