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
///  * and must NOT simply hand it the number one spot: a scrappy champion is
///    not thereby the best side in the world;
///  * going out in the group stage of a tournament you were favoured to win
///    must cost ground;
///  * an ordinary qualifying win must still be worth less than a world place.
///
/// EVERY BAND IS MEASURED ON A SPREAD TABLE, and on three of them, across the
/// range a played-in world ranking actually occupies (the gap from 1st to 25th
/// runs 321 to 436 points after a cycle or more of football). A flat table
/// flatters every one of these numbers: places on it are four points apart, so
/// any tournament at all sweeps a nation to the top, and a band measured there
/// is measuring the table's compression and not the change.
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
///  * a nation that did not enter the tournament does not gain or lose a point;
///  * and the rounding residue has NO preference between nations: summing to
///    zero is not enough, because it can sum to zero while the same nations
///    collect it every edition. That one is measured as a distribution.
void main() {
  // --- the harness ------------------------------------------------------

  /// A world of 220 nations, id == static seed rank, at the shape a played-in
  /// ranking settles into ([Elo.seedFromRanking]).
  ///
  /// [stretch] pulls the table out around mid-table to cover the range a real
  /// save occupies: 0.87 and 1.18 are the ends of the measured 321–436 point
  /// gap from 1st to 25th. Every band below is asserted at all three.
  Map<int, int> spreadWorld({double stretch = 1}) => {
    for (var rank = 1; rank <= 220; rank++)
      rank: (1495 + (Elo.seedFromRanking(rank) - 1495) * stretch).round(),
  };

  const stretches = [0.87, 1.0, 1.18];

  int positionOf(Map<int, int> points, int id) => Elo.positions(points)[id]!;

  /// What one world place costs in points around [rank] — no longer a constant:
  /// the top of the table is stretched and mid-table is dense.
  int placeSizeAt(Map<int, int> points, int rank) =>
      points[rank - 1]! - points[rank]!;

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

  /// The shape of a 48-team field: 16 group exits, 16 out in the last 32, 8 in
  /// the last 16, 4 quarter-finalists, then the semi-finalists and finalists.
  final fieldShape = <FinalsPlacing>[
    ...List.filled(16, FinalsPlacing.groupStage),
    ...List.filled(16, FinalsPlacing.roundOf32),
    ...List.filled(8, FinalsPlacing.roundOf16),
    ...List.filled(4, FinalsPlacing.quarterFinal),
    FinalsPlacing.fourth,
    FinalsPlacing.third,
    FinalsPlacing.runnerUp,
    FinalsPlacing.champion,
  ];

  /// A full field with [nation] finishing [placing] and the rest filling the
  /// bracket out. Nations are drawn from ids the runs below do not use.
  Map<int, FinalsPlacing> fieldWith(int nation, FinalsPlacing placing) {
    final rest = [...fieldShape]..remove(placing);
    final field = <int, FinalsPlacing>{nation: placing};
    var id = 101;
    for (final p in rest) {
      while (field.containsKey(id)) {
        id++;
      }
      field[id++] = p;
    }
    return field;
  }

  /// The year a settlement is stamped with; it decides only which of the tied
  /// nations take the rounding residue (see [Elo.placementDeltas]).
  const year = 2030;

  /// Settles a whole tournament: the matches, then the placings.
  void settle(
    Map<int, int> points,
    int nation,
    List<(int, double)> run,
    FinalsPlacing placing,
  ) {
    playRun(points, nation, run);
    final placings = Elo.placementDeltas(
      fieldWith(nation, placing),
      rotation: year,
    );
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
      final deltas = Elo.placementDeltas(
        fieldWith(7, placing),
        rotation: year,
      );
      expect(deltas.length, 48);
      expect(
        deltas.values.fold<int>(0, (a, b) => a + b),
        0,
        reason: 'the world total must be conserved (field of ${deltas.length})',
      );
    }
    // Field sizes that leave a real residue to hand back (16, 17, 24 and 48 do;
    // 3 and 5 are vacuous — nothing is left over — and are here to show the
    // branch is not entered rather than to exercise it).
    for (final size in [3, 5, 16, 17, 24]) {
      final field = {
        for (var i = 0; i < size; i++)
          i: FinalsPlacing.values[i % FinalsPlacing.values.length],
      };
      expect(
        Elo.placementDeltas(field, rotation: year).values.fold<int>(
          0,
          (a, b) => a + b,
        ),
        0,
        reason: 'field of $size',
      );
    }
  });

  test('NULL CONTROL: the rounding residue has no favourites', () {
    // Summing to zero is not enough. A 48-team field's residue is the same
    // handful of points EVERY edition, and the nations tied for it are the
    // whole group stage — so a tie-break that reads the nation id hands those
    // points to the same nations forever. Measured when the tie-break was the
    // id: ids 1-20 collected 322 residue points over 200 editions while ids
    // 181-220 collected none, monotone across every bucket.
    //
    // So this looks at the DISTRIBUTION, not the sum.
    var lcg = 1;
    int nextRandom(int bound) {
      lcg = (lcg * 1103515245 + 12345) & 0x3FFFFFFF;
      return lcg % bound;
    }

    /// The residue points [deltas] handed out, by nation: what each nation got
    /// beyond the plain rounding of its share.
    Map<int, int> residueIn(
      Map<int, FinalsPlacing> field,
      Map<int, int> deltas,
    ) {
      final mean =
          field.values.fold<double>(0, (a, p) => a + p.credit) / field.length;
      return {
        for (final e in field.entries)
          e.key:
              deltas[e.key]! -
              (Elo.placement * (e.value.credit - mean)).round(),
      };
    }

    // 200 editions, a fresh 48 of the 220 nations each time, placings dealt
    // out independently of the ids.
    final byBucket = List.filled(4, 0);
    final appearances = List.filled(4, 0);
    var handedOut = 0;
    for (var edition = 0; edition < 200; edition++) {
      final pool = [for (var id = 1; id <= 220; id++) id];
      for (var i = pool.length - 1; i > 0; i--) {
        final j = nextRandom(i + 1);
        final swap = pool[i];
        pool[i] = pool[j];
        pool[j] = swap;
      }
      final field = <int, FinalsPlacing>{
        for (var i = 0; i < fieldShape.length; i++) pool[i]: fieldShape[i],
      };
      final deltas = Elo.placementDeltas(field, rotation: 2026 + 4 * edition);
      final residue = residueIn(field, deltas);
      for (final e in residue.entries) {
        final bucket = (e.key - 1) ~/ 55;
        appearances[bucket]++;
        byBucket[bucket] += e.value.abs();
        handedOut += e.value.abs();
      }
    }
    expect(handedOut, greaterThan(0), reason: 'there is a residue to place');
    for (var b = 0; b < 4; b++) {
      final expectedShare =
          appearances[b] / appearances.reduce((a, c) => a + c);
      final share = byBucket[b] / handedOut;
      expect(
        share,
        greaterThan(expectedShare / 2),
        reason:
            'bucket $b took ${(share * 100).round()}% of the residue against '
            '${(expectedShare * 100).round()}% of the places — the residue is '
            'picking nations by id',
      );
      expect(share, lessThan(expectedShare * 2));
    }
  });

  test('NULL CONTROL: no confederation collects the residue', () {
    // The same measurement, shaped the way a real field is: one confederation
    // holds a block of neighbouring ids. With the id as the tie-break that
    // block took 59% of the residue on 33% of the field, permanently.
    var uefa = 0;
    var rest = 0;
    var lcg = 7;
    int nextRandom(int bound) {
      lcg = (lcg * 1103515245 + 12345) & 0x3FFFFFFF;
      return lcg % bound;
    }

    for (var edition = 0; edition < 100; edition++) {
      final ids = [
        for (var i = 1; i <= 16; i++) i,
        for (var i = 0; i < 32; i++) 17 + (i * 6 + edition) % 200,
      ];
      // The placings are dealt out at random, NOT in id order: leaving the
      // block of low ids to fill the group stage every time would put them in
      // the residue's tie set by construction and measure the harness.
      final dealt = [...fieldShape];
      for (var i = dealt.length - 1; i > 0; i--) {
        final j = nextRandom(i + 1);
        final swap = dealt[i];
        dealt[i] = dealt[j];
        dealt[j] = swap;
      }
      final field = <int, FinalsPlacing>{};
      for (var i = 0; i < dealt.length && i < ids.length; i++) {
        field[ids[i]] = dealt[i];
      }
      final deltas = Elo.placementDeltas(field, rotation: 2026 + 4 * edition);
      final mean =
          field.values.fold<double>(0, (a, p) => a + p.credit) / field.length;
      for (final e in field.entries) {
        final residue =
            (deltas[e.key]! - (Elo.placement * (e.value.credit - mean)).round())
                .abs();
        if (e.key <= 16) {
          uefa += residue;
        } else {
          rest += residue;
        }
      }
    }
    final share = uefa / (uefa + rest);
    expect(
      share,
      lessThan(0.5),
      reason:
          'one confederation took ${(share * 100).round()}% of the residue on '
          'a third of the field',
    );
    expect(share, greaterThan(0.15));
  });

  test('the residue is stable for an edition and moves between editions', () {
    final field = fieldWith(7, FinalsPlacing.champion);
    final a = Elo.placementDeltas(field, rotation: 2030);
    final again = Elo.placementDeltas(field, rotation: 2030);
    expect(again, a, reason: 'a settlement must be reproducible');
    var moved = false;
    for (final rotation in [2034, 2038, 2042]) {
      final b = Elo.placementDeltas(field, rotation: rotation);
      if (!_sameMap(a, b)) moved = true;
      expect(b.values.fold<int>(0, (x, y) => x + y), 0);
    }
    expect(moved, isTrue, reason: 'a later edition pays a different nine');
  });

  test('NULL CONTROL: a field that all finished level moves nobody', () {
    for (final placing in FinalsPlacing.values) {
      final field = {for (var i = 0; i < 16; i++) i: placing};
      final deltas = Elo.placementDeltas(field, rotation: year);
      expect(
        deltas.values.every((d) => d == 0),
        isTrue,
        reason: 'no placing was better than any other, so nothing is owed',
      );
    }
    expect(Elo.placementDeltas(const {}), isEmpty);
  });

  test('NULL CONTROL: a nation that stayed at home keeps its points', () {
    final points = spreadWorld();
    final before = Map<int, int>.from(points);
    settle(points, 25, unconvincingRun, FinalsPlacing.champion);
    // Id 200 is neither in the run nor in the field this harness builds.
    expect(points[200], before[200]);
  });

  // --- the bands --------------------------------------------------------

  test('winning the championship from outside the top twenty makes a nation '
      'one of the best handful', () {
    for (final stretch in stretches) {
      for (final start in [25, 30, 40]) {
        final points = spreadWorld(stretch: stretch);
        expect(positionOf(points, start), start);
        settle(points, start, unconvincingRun, FinalsPlacing.champion);
        final after = positionOf(points, start);
        expect(
          after,
          lessThanOrEqualTo(12),
          reason:
              'a champion from #$start finished #$after on a x$stretch table — '
              'it just beat the world and should be read as one of the best',
        );
        expect(
          start - after,
          greaterThanOrEqualTo(12),
          reason: 'the climb must be visible from #$start (x$stretch)',
        );
      }
    }
  });

  test('...but winning scrappily does not make it the best side in the world', () {
    // THE UPPER BAND. [Elo.placement] is the largest constant in the class and
    // nothing else caps it: without this, the award could be doubled and every
    // other band here would still pass. A champion that beat the sides it was
    // supposed to beat and won three shootouts has not proved it is number one.
    for (final stretch in stretches) {
      final points = spreadWorld(stretch: stretch);
      settle(points, 25, unconvincingRun, FinalsPlacing.champion);
      expect(
        positionOf(points, 25),
        greaterThan(1),
        reason: 'an unconvincing champion from #25 took the top spot outright',
      );
    }
  });

  test('a convincing champion goes to the very top', () {
    for (final stretch in stretches) {
      final points = spreadWorld(stretch: stretch);
      settle(points, 25, convincingRun, FinalsPlacing.champion);
      expect(positionOf(points, 25), lessThanOrEqualTo(5));
    }
  });

  test('the trophy itself is worth a real part of the climb', () {
    // The whole point of the change: winning moves a nation BECAUSE it won,
    // not only because the eight matches happened to read as upsets. Measured
    // in places gained beyond where the matches alone left it.
    for (final stretch in stretches) {
      final matchesOnly = spreadWorld(stretch: stretch);
      playRun(matchesOnly, 25, unconvincingRun);
      final withTrophy = spreadWorld(stretch: stretch);
      settle(withTrophy, 25, unconvincingRun, FinalsPlacing.champion);
      final fromMatches = 25 - positionOf(matchesOnly, 25);
      final fromTrophy =
          positionOf(matchesOnly, 25) - positionOf(withTrophy, 25);
      expect(
        fromTrophy,
        greaterThanOrEqualTo(5),
        reason: 'the placing alone should be worth a stretch of the table',
      );
      // ...and still not the whole story: how the tournament was won matters.
      expect(
        fromTrophy,
        lessThanOrEqualTo((fromMatches * 1.5).round()),
        reason: 'the trophy tops the run up, it does not replace it',
      );
    }
  });

  test('a favourite dumped out in the group stage loses ground', () {
    for (final stretch in stretches) {
      for (final fav in [2, 6]) {
        final points = spreadWorld(stretch: stretch);
        final before = points[fav]!;
        settle(points, fav, const [
          (30, 0.0),
          (45, 1.0),
          (20, 0.0),
        ], FinalsPlacing.groupStage);
        expect(
          before - points[fav]!,
          greaterThanOrEqualTo(60),
          reason: 'going out in the group must cost real points',
        );
        expect(
          positionOf(points, fav),
          greaterThanOrEqualTo(fav + 2),
          reason: 'a favourite out in the group must visibly slip',
        );
      }
    }
  });

  test('finishing higher is always worth more', () {
    // Ordering of the placings themselves, independent of any match.
    final field = <int, FinalsPlacing>{};
    var id = 0;
    for (final p in fieldShape) {
      field[id++] = p;
    }
    final deltas = Elo.placementDeltas(field, rotation: year);
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
    for (final stretch in stretches) {
      final points = spreadWorld(stretch: stretch);
      final before = positionOf(points, 5);
      final d = deltaFor(
        aPoints: points[5]!,
        bPoints: points[100]!,
        actual: 1,
        weight: Elo.qualifier,
      );
      expect(d.abs(), lessThan(placeSizeAt(points, 5)));
      points[5] = points[5]! + d;
      points[100] = points[100]! - d;
      expect(positionOf(points, 5), before);
    }
  });

  test('the table a new save starts on is the shape a played one settles into', () {
    // The seeding used to be a flat 4 points a place, which is about four times
    // too compressed at the top; on that table the matches alone took a champion
    // from #25 into the top ten, so nothing about a tournament could be judged.
    final points = spreadWorld();
    final topGap = points[1]! - points[25]!;
    expect(
      topGap,
      inInclusiveRange(321, 436),
      reason: 'the gap from 1st to 25th must match a played-in table',
    );
    // Mid-table stays dense — that is where qualifying is played, and where
    // every weight floor in [Elo] was argued.
    expect(placeSizeAt(points, 100), inInclusiveRange(2, 6));
    // And the top is sticky: a place up there costs a tournament, not a friendly.
    expect(placeSizeAt(points, 5), greaterThan(20));
    // Monotone, with no cliffs.
    for (var rank = 2; rank <= 220; rank++) {
      final above = points[rank - 1]!;
      expect(points[rank], lessThan(above), reason: 'at #$rank');
    }
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

bool _sameMap(Map<int, int> a, Map<int, int> b) {
  if (a.length != b.length) return false;
  for (final e in a.entries) {
    if (b[e.key] != e.value) return false;
  }
  return true;
}
