import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_moments.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/match_baseline.dart';

/// Task 2 of the pitch view: the engine records every shot it counts as a
/// [ShotMoment], without changing any outcome (the baseline golden pins that).
void main() {
  const engine = MatchEngine();

  // A spread of matches: flat sides, a mismatch, long throws on, and
  // knockouts that go to extra time.
  final matches = <MatchResult>[
    for (var i = 0; i < 60; i++)
      engine.play(
        home: ratedTeam(1, 78),
        away: ratedTeam(2, 74),
        rng: SeededRng.forFixture(0x5107, i),
      ),
    for (var i = 0; i < 40; i++)
      engine.play(
        home: longThrowTeam(1, 80),
        away: longThrowTeam(2, 72),
        rng: SeededRng.forFixture(0x5108, i),
      ),
    for (var i = 0; i < 60; i++)
      engine.play(
        home: ratedTeam(1, 75),
        away: ratedTeam(2, 75),
        rng: SeededRng.forFixture(0x5109, i),
        neutralVenue: true,
        extraTimeIfLevel: true,
      ),
  ];

  List<ShotMoment> shotsOf(MatchResult r) =>
      r.moments.whereType<ShotMoment>().toList();

  test('the shot moments add up to the shot counts', () {
    for (final r in matches) {
      final shots = shotsOf(r);
      for (final (nation, byMinute) in [
        (1, r.homeShotsByMinute),
        (2, r.awayShotsByMinute),
      ]) {
        for (var m = 1; m < byMinute.length; m++) {
          final count = shots
              .where((s) => s.teamNationId == nation && s.minute == m)
              .length;
          expect(
            count,
            byMinute[m] - byMinute[m - 1],
            reason: 'nation $nation minute $m',
          );
        }
      }
      expect(
        shots.where((s) => s.teamNationId == 1).length,
        r.homeShots,
      );
      expect(
        shots.where((s) => s.teamNationId == 2).length,
        r.awayShots,
      );
    }
  });

  test('every goal has exactly one goal shot pointing at it', () {
    for (final r in matches) {
      final goalShots = shotsOf(
        r,
      ).where((s) => s.outcome == ShotOutcome.goal).toList();
      final goalIdx = [
        for (var i = 0; i < r.events.length; i++)
          if (r.events[i].type == MatchEventType.goal) i,
      ];
      expect(goalShots.length, goalIdx.length);
      expect(goalShots.map((s) => s.goalEventIndex).toSet(), goalIdx.toSet());
      for (final s in goalShots) {
        final e = r.events[s.goalEventIndex!];
        expect(e.type, MatchEventType.goal);
        expect(s.shooterId, e.playerId);
        expect(s.assistId, e.assistPlayerId);
        expect(s.teamNationId, e.teamNationId);
        expect(s.minute, e.minute);
        expect(s.stoppage, e.stoppage);
        expect(s.origin == ShotOrigin.penalty, e.penalty);
        expect(s.origin == ShotOrigin.longThrow, e.longThrow);
        expect(
          s.origin == ShotOrigin.corner || s.origin == ShotOrigin.longThrow,
          e.setPiece,
        );
      }
      for (final s in shotsOf(r)) {
        if (s.outcome != ShotOutcome.goal) expect(s.goalEventIndex, isNull);
      }
    }
  });

  test('sum of moment xg equals homeXg within 1e-6', () {
    for (final r in matches) {
      final shots = shotsOf(r);
      double sum(int n) =>
          shots.where((s) => s.teamNationId == n).fold(0, (a, s) => a + s.xg);
      expect(sum(1), closeTo(r.homeXg, 1e-6));
      expect(sum(2), closeTo(r.awayXg, 1e-6));
    }
  });

  test('moments are ordered by minute, stoppage, seq with 0-based seq', () {
    for (final r in matches) {
      final ms = r.moments;
      for (var i = 1; i < ms.length; i++) {
        final a = ms[i - 1];
        final b = ms[i];
        final key = (a.minute, a.stoppage) == (b.minute, b.stoppage);
        if (key) {
          expect(b.seq, a.seq + 1);
        } else {
          expect(b.seq, 0);
          expect(
            b.minute > a.minute ||
                (b.minute == a.minute && b.stoppage > a.stoppage),
            isTrue,
          );
        }
      }
      if (ms.isNotEmpty) expect(ms.first.seq, 0);
    }
  });

  test('extra-time shots carry their real minutes', () {
    final et = matches.where((r) => r.extraTime != null).toList();
    expect(et, isNotEmpty);
    var etShots = 0;
    for (final r in et) {
      for (final s in shotsOf(r)) {
        expect(s.minute, inInclusiveRange(1, 120));
        if (s.minute > 90) {
          expect(s.stoppage, 0);
          etShots++;
        }
      }
    }
    expect(etShots, greaterThan(0));
  });

  test('origins, zones, keepers and headers fit the code path', () {
    final origins = <ShotOrigin>{};
    for (final r in matches) {
      for (final s in shotsOf(r)) {
        origins.add(s.origin);
        final defending = s.teamNationId == 1 ? 2 : 1;
        // ratedTeam's keeper is the first slot: id nation*100.
        expect(s.keeperId, defending * 100);
        expect(s.shooterId ~/ 100, s.teamNationId);
        expect(
          s.header,
          s.origin == ShotOrigin.corner || s.origin == ShotOrigin.longThrow,
        );
        if (s.origin == ShotOrigin.penalty) {
          expect(s.zone, PitchZone.boxCentre);
        } else if (s.xg >= 0.35) {
          expect(s.zone, anyOf(PitchZone.sixYard, PitchZone.boxCentre));
        } else if (s.xg >= 0.12) {
          expect(
            s.zone,
            anyOf(PitchZone.boxLeft, PitchZone.boxCentre, PitchZone.boxRight),
          );
        } else if (s.xg >= 0.05) {
          expect(s.zone, PitchZone.edgeOfBox);
        } else {
          expect(s.zone, PitchZone.longRange);
        }
      }
    }
    expect(
      origins,
      containsAll([
        ShotOrigin.openPlay,
        ShotOrigin.corner,
        ShotOrigin.longThrow,
        ShotOrigin.penalty,
      ]),
    );
  });

  test('a side with no keeper on the pitch faces shots with keeperId null', () {
    final t = ratedTeam(2, 74);
    final noKeeper = MatchTeam(
      nationId: 2,
      instructions: t.instructions,
      xi: [
        for (final p in t.xi)
          if (p.category == PositionCategory.goalkeeper)
            player(
              id: p.id,
              nationId: 2,
              position: PlayerPosition.cb,
              attributes: p.attributes,
            )
          else
            p,
      ],
    );
    final r = engine.play(
      home: ratedTeam(1, 78),
      away: noKeeper,
      rng: SeededRng.forFixture(0x510A, 1),
    );
    final home = shotsOf(r).where((s) => s.teamNationId == 1).toList();
    expect(home, isNotEmpty);
    expect(home.every((s) => s.keeperId == null), isTrue);
  });

  test('non-goal outcomes land near the target shares', () {
    final counts = <ShotOutcome, int>{};
    for (var i = 0; i < 300; i++) {
      final r = engine.play(
        home: ratedTeam(1, 76),
        away: ratedTeam(2, 74),
        rng: SeededRng.forFixture(0x510B, i),
      );
      for (final s in shotsOf(r)) {
        counts[s.outcome] = (counts[s.outcome] ?? 0) + 1;
      }
    }
    final nonGoal = counts.entries
        .where((e) => e.key != ShotOutcome.goal)
        .fold(0, (a, e) => a + e.value);
    double share(ShotOutcome o) => (counts[o] ?? 0) / nonGoal;
    expect(share(ShotOutcome.saved), closeTo(0.35, 0.05));
    expect(share(ShotOutcome.wide), closeTo(0.31, 0.05));
    expect(share(ShotOutcome.blocked), closeTo(0.29, 0.05));
    expect(share(ShotOutcome.woodwork), closeTo(0.045, 0.02));
  });

  test('higher xg means more saved and woodwork, fewer wide', () {
    final lo = <ShotOutcome, int>{};
    final hi = <ShotOutcome, int>{};
    for (var i = 0; i < 300; i++) {
      final r = engine.play(
        home: ratedTeam(1, 76),
        away: ratedTeam(2, 74),
        rng: SeededRng.forFixture(0x510C, i),
      );
      for (final s in shotsOf(r)) {
        if (s.outcome == ShotOutcome.goal) continue;
        final bucket = s.xg >= 0.12 ? hi : lo;
        bucket[s.outcome] = (bucket[s.outcome] ?? 0) + 1;
      }
    }
    double share(Map<ShotOutcome, int> m, ShotOutcome o) =>
        (m[o] ?? 0) / m.values.fold(0, (a, b) => a + b);
    expect(
      share(hi, ShotOutcome.saved),
      greaterThan(share(lo, ShotOutcome.saved)),
    );
    expect(
      share(hi, ShotOutcome.wide),
      lessThan(share(lo, ShotOutcome.wide)),
    );
  });

  test('the same match records the same moments', () {
    MatchResult once() => engine.play(
      home: longThrowTeam(1, 78),
      away: ratedTeam(2, 74),
      rng: SeededRng.forFixture(0x510D, 3),
    );
    expect(once().moments, once().moments);
    expect(once().moments, isNotEmpty);
  });
}
