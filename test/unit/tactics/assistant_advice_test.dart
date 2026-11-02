import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/manager/staff.dart';
import 'package:fnm/domain/services/squad/condition.dart';
import 'package:fnm/domain/services/tactics/assistant_advice.dart';

import '../../helpers/fixtures.dart';

/// A believable squad of 23 for [seed]: three keepers, the rest spread over
/// the outfield, ratings 58–84, with condition drawn per man.
({List<Player> pool, Map<int, PlayerCondition> condition}) _squad(int seed) {
  final rng = SeededRng(seed * 7919 + 13);
  const outfield = [
    PlayerPosition.cb,
    PlayerPosition.cb,
    PlayerPosition.cb,
    PlayerPosition.cb,
    PlayerPosition.lb,
    PlayerPosition.rb,
    PlayerPosition.dm,
    PlayerPosition.cm,
    PlayerPosition.cm,
    PlayerPosition.cm,
    PlayerPosition.am,
    PlayerPosition.lm,
    PlayerPosition.rm,
    PlayerPosition.lw,
    PlayerPosition.rw,
    PlayerPosition.st,
    PlayerPosition.st,
    PlayerPosition.st,
    PlayerPosition.lb,
    PlayerPosition.rb,
  ];
  final pool = <Player>[
    for (var i = 0; i < 3; i++)
      player(
        id: 100 + i,
        nationId: 1,
        position: PlayerPosition.gk,
        attributes: flatAttributes(60 + rng.nextInt(24)),
      ),
    for (var i = 0; i < outfield.length; i++)
      player(
        id: 200 + i,
        nationId: 1,
        position: outfield[i],
        attributes: flatAttributes(58 + rng.nextInt(26)),
      ),
  ];
  const forms = PlayerForm.values;
  const fatigues = FatigueState.values;
  final condition = <int, PlayerCondition>{
    for (final p in pool)
      p.id: () {
        final form = forms[rng.nextInt(forms.length)];
        final fatigue = fatigues[rng.nextInt(fatigues.length)];
        final delta =
            switch (form) {
              PlayerForm.onFire => 3,
              PlayerForm.good => 1,
              PlayerForm.steady => 0,
              PlayerForm.poor => -1,
              PlayerForm.cold => -3,
            } +
            switch (fatigue) {
              FatigueState.fresh => 0,
              FatigueState.ready => -1,
              FatigueState.tired => -3,
              FatigueState.exhausted => -6,
            };
        return (
          form: form,
          formRating: 6.7,
          fatigueState: fatigue,
          gamesInWindow: 0,
          overallDelta: delta,
          clubStanding: null,
        );
      }(),
  };
  return (pool: pool, condition: condition);
}

void main() {
  final places = Formation.f433.positions;

  test('nobody in the job gives no advice', () {
    final s = _squad(1);
    expect(
      AssistantAdvice.lineup(
        tier: StaffTier.none,
        places: places,
        pool: s.pool,
        seed: 1,
      ),
      isNull,
    );
  });

  test(
    'a better assistant fields a stronger eleven, by the engine measure',
    () {
      var elite = 0.0;
      var good = 0.0;
      var basic = 0.0;
      var eliteBelowBasic = 0;
      const seeds = 300;
      for (var seed = 0; seed < seeds; seed++) {
        final s = _squad(seed);
        final byId = {for (final p in s.pool) p.id: p};
        final deltas = {
          for (final e in s.condition.entries) e.key: e.value.overallDelta,
        };
        double strengthOf(StaffTier tier) => AssistantAdvice.strength(
          AssistantAdvice.lineup(
            tier: tier,
            places: places,
            pool: s.pool,
            seed: seed,
            condition: s.condition,
          )!.main.lineup,
          places,
          byId,
          deltas,
        );
        final e = strengthOf(StaffTier.elite);
        final g = strengthOf(StaffTier.good);
        final b = strengthOf(StaffTier.basic);
        elite += e;
        good += g;
        basic += b;
        if (e < b - 1e-6) eliteBelowBasic++;
      }
      expect(elite / seeds, greaterThan(good / seeds));
      expect(good / seeds, greaterThan(basic / seeds));
      // The elite eleven is a local optimum of the true measure; the basic one
      // is the same search on a rougher read, so it should essentially never
      // come out ahead.
      expect(eliteBelowBasic, lessThanOrEqualTo(seeds ~/ 50));
    },
  );

  test('never fields an unavailable man, at any tier and any seed', () {
    for (var seed = 0; seed < 100; seed++) {
      final s = _squad(seed);
      // The three best outfielders are out.
      final out = ([...s.pool]..sort((a, b) => b.overall.compareTo(a.overall)))
          .where((p) => p.position != PlayerPosition.gk)
          .take(3)
          .map((p) => p.id)
          .toSet();
      for (final tier in [StaffTier.basic, StaffTier.good, StaffTier.elite]) {
        final advice = AssistantAdvice.lineup(
          tier: tier,
          places: places,
          pool: s.pool,
          seed: seed,
          condition: s.condition,
          unavailableIds: out,
        )!;
        for (final proposal in [advice.main, ...advice.alternatives]) {
          final ids = {
            ...proposal.lineup.whereType<int>(),
            for (final b in proposal.bench) b.playerId,
          };
          expect(ids.intersection(out), isEmpty);
          expect(proposal.lineup.whereType<int>().toSet(), hasLength(11));
        }
      }
    }
  });

  test('alternatives differ from his pick and from each other', () {
    var seen = 0;
    for (var seed = 0; seed < 60; seed++) {
      final s = _squad(seed);
      for (final tier in [StaffTier.basic, StaffTier.good, StaffTier.elite]) {
        final advice = AssistantAdvice.lineup(
          tier: tier,
          places: places,
          pool: s.pool,
          seed: seed,
          condition: s.condition,
        )!;
        expect(
          advice.alternatives.length,
          lessThanOrEqualTo(tier == StaffTier.basic ? 1 : 2),
        );
        for (final alt in advice.alternatives) {
          seen++;
          expect(alt.sameEleven(advice.main.lineup), isFalse);
          expect(alt.variant, isNot(AdviceVariant.main));
        }
        if (advice.alternatives.length == 2) {
          expect(
            advice.alternatives[0].sameEleven(advice.alternatives[1].lineup),
            isFalse,
          );
        }
      }
    }
    expect(seen, greaterThan(0));
  });

  test('asking twice gives the same answer', () {
    final s = _squad(5);
    PreMatchAdvice ask() => AssistantAdvice.lineup(
      tier: StaffTier.basic,
      places: places,
      pool: s.pool,
      seed: 42,
      condition: s.condition,
    )!;
    final a = ask();
    final b = ask();
    expect(a.main.lineup, b.main.lineup);
    expect(a.alternatives.length, b.alternatives.length);
  });

  group('in-match', () {
    ({
      List<int?> lineup,
      Map<int, Player> byId,
      List<Player> bench,
    })
    setup(int seed) {
      final s = _squad(seed);
      final byId = {for (final p in s.pool) p.id: p};
      final xi = AssistantAdvice.lineup(
        tier: StaffTier.elite,
        places: places,
        pool: s.pool,
        seed: seed,
      )!.main.lineup;
      final on = xi.whereType<int>().toSet();
      return (
        lineup: xi,
        byId: byId,
        bench: s.pool.where((p) => !on.contains(p.id)).toList(),
      );
    }

    test('never proposes more changes than are left', () {
      for (var seed = 0; seed < 80; seed++) {
        final m = setup(seed);
        // Everybody on the pitch is spent.
        final energy = {for (final id in m.lineup.whereType<int>()) id: 30};
        for (final tier in StaffTier.values) {
          for (var left = 0; left <= 5; left++) {
            final subs = AssistantAdvice.substitutions(
              tier: tier,
              lineup: m.lineup,
              places: places,
              byId: m.byId,
              bench: m.bench,
              subsLeft: left,
              minute: 70,
              seed: seed,
              energy: energy,
            );
            expect(subs.length, lessThanOrEqualTo(left));
            expect(subs.length, lessThanOrEqualTo(AssistantAdvice.maxSubs));
            if (tier == StaffTier.none) expect(subs, isEmpty);
            final benchIds = {for (final p in m.bench) p.id};
            for (final s in subs) {
              expect(m.lineup, contains(s.offId));
              expect(benchIds, contains(s.onId));
            }
            expect({for (final s in subs) s.onId}, hasLength(subs.length));
            expect({for (final s in subs) s.offId}, hasLength(subs.length));
          }
        }
      }
    });

    test('an injured man is the first one off, at every tier', () {
      final m = setup(3);
      final hurt = m.lineup[5]!;
      for (final tier in [StaffTier.basic, StaffTier.good, StaffTier.elite]) {
        final subs = AssistantAdvice.substitutions(
          tier: tier,
          lineup: m.lineup,
          places: places,
          byId: m.byId,
          bench: m.bench,
          subsLeft: 3,
          minute: 30,
          seed: 3,
          injured: {hurt},
        );
        expect(subs.first.offId, hurt);
        expect(subs.first.reason, AdviceReason.injured);
      }
    });

    test('only the elite assistant reads the booking and the scoreline', () {
      final m = setup(9);
      final booked = m.lineup[6]!;
      final good = AssistantAdvice.substitutions(
        tier: StaffTier.good,
        lineup: m.lineup,
        places: places,
        byId: m.byId,
        bench: m.bench,
        subsLeft: 3,
        minute: 80,
        seed: 9,
        booked: {booked},
        scoreDiff: -1,
      );
      expect(
        good.map((s) => s.reason),
        isNot(
          anyOf(contains(AdviceReason.booked), contains(AdviceReason.chasing)),
        ),
      );
    });

    test('a hole a red card left is never filled', () {
      final m = setup(4);
      final lineup = [...m.lineup]..[3] = null;
      final subs = AssistantAdvice.substitutions(
        tier: StaffTier.elite,
        lineup: lineup,
        places: places,
        byId: m.byId,
        bench: m.bench,
        subsLeft: 3,
        minute: 75,
        seed: 4,
        energy: {for (final id in lineup.whereType<int>()) id: 20},
      );
      expect(subs, isNotEmpty);
      for (final s in subs) {
        expect(lineup, contains(s.offId));
      }
    });
  });
}
