import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_moments.dart';

import '../../helpers/fixtures.dart';

/// Task 4 of the pitch view, the play pass: a penalty is given for a foul in
/// the box and can be scored, saved or missed; a foul at the edge of the box
/// can give a direct free kick, which can hit the wall. Both are drawn on
/// their own stream. The figures they are tuned to hold are pinned by
/// `match_baseline_test.dart` ("figures stay near baseline").
void main() {
  const engine = MatchEngine();
  const box = [PitchZone.boxCentre, PitchZone.boxLeft, PitchZone.boxRight];

  // 600 matches of two ordinary sides at home.
  final matches = <MatchResult>[
    for (var i = 0; i < 600; i++)
      engine.play(
        home: ratedTeam(1, 78),
        away: ratedTeam(2, 74),
        rng: SeededRng.forFixture(0x9A55, i),
      ),
  ];

  int sideOf(int playerId) => playerId ~/ 100;

  Iterable<(MatchResult, int)> shotsOf(ShotOrigin origin) sync* {
    for (final r in matches) {
      for (var k = 0; k < r.moments.length; k++) {
        final m = r.moments[k];
        if (m is ShotMoment && m.origin == origin) yield (r, k);
      }
    }
  }

  test('a penalty can be missed or saved', () {
    final outcomes = <ShotOutcome, int>{};
    for (final (r, k) in shotsOf(ShotOrigin.penalty)) {
      final s = r.moments[k] as ShotMoment;
      outcomes[s.outcome] = (outcomes[s.outcome] ?? 0) + 1;
    }
    final total = outcomes.values.fold(0, (a, b) => a + b);
    final scored = outcomes[ShotOutcome.goal] ?? 0;
    final saved = outcomes[ShotOutcome.saved] ?? 0;
    final missed =
        (outcomes[ShotOutcome.wide] ?? 0) +
        (outcomes[ShotOutcome.woodwork] ?? 0);
    // ignore: avoid_print
    print(
      'penalties ${total / matches.length} a match: scored '
      '${scored / total}, saved ${saved / total}, missed ${missed / total}',
    );
    expect(total, greaterThan(80));
    expect(outcomes.keys, isNot(contains(ShotOutcome.blocked)));
    expect((saved + missed) / total, greaterThanOrEqualTo(0.15));
    expect(saved, greaterThan(0));
    expect(missed, greaterThan(0));
  });

  test('penalty outcomes sit near 76% scored, 17% saved, 7% missed', () {
    var total = 0, scored = 0, saved = 0;
    for (var i = 0; i < 4000; i++) {
      final r = engine.play(
        home: ratedTeam(1, 78),
        away: ratedTeam(2, 74),
        rng: SeededRng.forFixture(0x9A56, i),
      );
      for (final s in r.moments.whereType<ShotMoment>()) {
        if (s.origin != ShotOrigin.penalty) continue;
        total++;
        if (s.outcome == ShotOutcome.goal) scored++;
        if (s.outcome == ShotOutcome.saved) saved++;
      }
    }
    // ignore: avoid_print
    print(
      'over $total penalties: scored ${scored / total}, saved '
      '${saved / total}, missed ${(total - scored - saved) / total}',
    );
    expect(scored / total, closeTo(0.76, 0.04));
    expect(saved / total, closeTo(0.17, 0.035));
    expect((total - scored - saved) / total, closeTo(0.07, 0.025));
  });

  test('every penalty follows a foul in the box', () {
    var n = 0;
    for (final (r, k) in shotsOf(ShotOrigin.penalty)) {
      n++;
      final s = r.moments[k] as ShotMoment;
      final foul = r.moments[k - 1];
      expect(foul, isA<FoulMoment>(), reason: '$s');
      final f = foul as FoulMoment;
      expect(f.zone, isIn(box));
      expect((f.minute, f.stoppage), (s.minute, s.stoppage));
      expect(f.teamNationId, s.teamNationId);
      expect(sideOf(f.fouledId), s.teamNationId);
      expect(sideOf(f.foulerId), isNot(s.teamNationId));
      expect(f.advantage, isFalse);
      expect(s.zone, PitchZone.boxCentre);
      expect(s.header, isFalse);
      // The designated taker, here the best finisher: no assist.
      expect(s.assistId, isNull);
      expect(sideOf(s.shooterId), s.teamNationId);
    }
    expect(n, greaterThan(80));
    // And no foul in the box gives anything but a penalty.
    for (final r in matches) {
      final ms = r.moments;
      for (var k = 0; k < ms.length; k++) {
        final f = ms[k];
        if (f is! FoulMoment || !box.contains(f.zone)) continue;
        final next = ms[k + 1];
        expect(
          next is ShotMoment && next.origin == ShotOrigin.penalty,
          isTrue,
          reason: '$f then $next',
        );
      }
    }
  });

  test('a penalty goal is a penalty event by the taker; a miss is no '
      'event', () {
    for (final r in matches) {
      final penaltyGoals = [
        for (var i = 0; i < r.events.length; i++)
          if (r.events[i].type == MatchEventType.goal && r.events[i].penalty) i,
      ];
      final scored = [
        for (final s in r.moments.whereType<ShotMoment>())
          if (s.origin == ShotOrigin.penalty && s.outcome == ShotOutcome.goal)
            s.goalEventIndex,
      ];
      expect(scored.toSet(), penaltyGoals.toSet());
      for (final i in penaltyGoals) {
        expect(r.events[i].assistPlayerId, isNull);
        expect(r.events[i].setPiece, isFalse);
      }
      for (final s in r.moments.whereType<ShotMoment>()) {
        if (s.origin == ShotOrigin.penalty && s.outcome != ShotOutcome.goal) {
          expect(s.goalEventIndex, isNull);
        }
      }
    }
  });

  test('a penalty or free-kick foul can draw a card, never a straight red', () {
    var carded = 0, kickCards = 0;
    for (var i = 0; i < 3000; i++) {
      final r = engine.play(
        home: ratedTeam(1, 78),
        away: ratedTeam(2, 74),
        rng: SeededRng.forFixture(0x9A57, i),
      );
      final ms = r.moments;
      for (var k = 1; k < ms.length; k++) {
        final s = ms[k];
        if (s is! ShotMoment) continue;
        final FoulMoment f;
        if (s.origin == ShotOrigin.penalty) {
          f = ms[k - 1] as FoulMoment;
        } else if (s.origin == ShotOrigin.directFreeKick) {
          f = ms[k - 2] as FoulMoment;
          if (f.cardEventIndex != null) kickCards++;
        } else {
          continue;
        }
        final c = f.cardEventIndex;
        if (c == null) continue;
        carded++;
        final card = r.events[c];
        expect(card.playerId, f.foulerId);
        if (card.type == MatchEventType.redCard) {
          expect(card.secondYellow, isTrue);
        }
      }
    }
    expect(carded, greaterThan(20));
    expect(kickCards, greaterThan(20));
  });

  test('rates: 0.34-0.46 penalties and 0.7-1.2 direct free kicks a match '
      'over 600 matches', () {
    final pens = shotsOf(ShotOrigin.penalty).length / matches.length;
    final kicks = shotsOf(ShotOrigin.directFreeKick).length / matches.length;
    // ignore: avoid_print
    print('per match: penalties $pens, direct free kicks $kicks');
    expect(pens, inInclusiveRange(0.34, 0.46));
    expect(kicks, inInclusiveRange(0.7, 1.2));
  });

  // The owner saw none in five matches (2026-11-07). Real international
  // football gives about 0.25-0.32 penalties a match and scores 75-78% of
  // them; at about 0.245 the engine sat just under that, so it was raised
  // into it (about 0.26-0.27). Ten more of his own matches without one
  // (2026-11-08), and he asked for one most second or third match: about
  // 0.40 (see `penalty_rate_test.dart` for his matches as he plays them).
  // Measured over 3,000 matches of mixed strengths (55-90 each side, half at
  // neutral grounds).
  test('penalties: 0.34-0.46 a match over 3,000 mixed-strength matches', () {
    final pick = SeededRng(0x9E7A);
    const n = 3000;
    var pens = 0, scored = 0;
    for (var i = 0; i < n; i++) {
      final r = engine.play(
        home: ratedTeam(1, 55 + pick.nextInt(36)),
        away: ratedTeam(2, 55 + pick.nextInt(36)),
        rng: SeededRng.forFixture(0x7E11, i),
        neutralVenue: i.isEven,
      );
      for (final s in r.moments.whereType<ShotMoment>()) {
        if (s.origin != ShotOrigin.penalty) continue;
        pens++;
        if (s.outcome == ShotOutcome.goal) scored++;
      }
    }
    // ignore: avoid_print
    print('mixed: ${pens / n} penalties a match, scored ${scored / pens}');
    expect(pens / n, inInclusiveRange(0.34, 0.46));
    expect(scored / pens, inInclusiveRange(0.70, 0.80));
  });

  test('a direct free kick can hit the wall', () {
    final outcomes = <ShotOutcome, int>{};
    for (final (r, k) in shotsOf(ShotOrigin.directFreeKick)) {
      final s = r.moments[k] as ShotMoment;
      outcomes[s.outcome] = (outcomes[s.outcome] ?? 0) + 1;
      // The foul at the edge of the box, then the free kick, then the shot,
      // all by the same dead-ball man.
      final sp = r.moments[k - 1];
      final foul = r.moments[k - 2];
      expect(sp, isA<SetPieceMoment>(), reason: '$s');
      expect(foul, isA<FoulMoment>(), reason: '$s');
      final kick = sp as SetPieceMoment;
      final f = foul as FoulMoment;
      expect(kick.kind, SetPieceKind.freeKick);
      expect(kick.routine, isFalse);
      expect(kick.zone, PitchZone.edgeOfBox);
      expect(kick.takerId, s.shooterId);
      expect(kick.teamNationId, s.teamNationId);
      expect(f.zone, PitchZone.edgeOfBox);
      expect(f.teamNationId, s.teamNationId);
      expect(s.zone, PitchZone.edgeOfBox);
      expect(s.header, isFalse);
      expect(s.assistId, isNull);
      // ratedTeam's keeper is slot 0 (id nation*100): never the taker.
      expect(s.shooterId % 100, isNot(0));
      if (s.outcome == ShotOutcome.goal) {
        final e = r.events[s.goalEventIndex!];
        expect(e.playerId, s.shooterId);
        expect(e.penalty, isFalse);
        expect(e.setPiece, isFalse);
      }
    }
    final total = outcomes.values.fold(0, (a, b) => a + b);
    final wall = outcomes[ShotOutcome.blocked] ?? 0;
    final goals = outcomes[ShotOutcome.goal] ?? 0;
    // ignore: avoid_print
    print(
      'direct free kicks ${total / matches.length} a match: wall '
      '${wall / total}, scored ${goals / total}, $outcomes',
    );
    expect(total, greaterThan(300));
    expect(wall / total, closeTo(0.25, 0.05));
    expect(goals / total, closeTo(0.07, 0.03));
    expect(outcomes.keys, containsAll(ShotOutcome.values));
  });

  test('the same match plays the same penalties and free kicks', () {
    MatchResult once() => engine.play(
      home: ratedTeam(1, 78),
      away: ratedTeam(2, 74),
      rng: SeededRng.forFixture(0x9A55, 7),
    );
    expect(once().moments, once().moments);
    expect(
      [for (final e in once().events) '${e.type} ${e.playerId}'],
      [for (final e in once().events) '${e.type} ${e.playerId}'],
    );
  });
}
