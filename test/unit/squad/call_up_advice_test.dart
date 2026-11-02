import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_absence.dart';
import 'package:fnm/domain/services/manager/staff.dart';
import 'package:fnm/domain/services/squad/call_up_advice.dart';
import 'package:fnm/domain/services/squad/condition.dart';
import 'package:fnm/domain/services/squad/squad_selection.dart';

import '../../helpers/fixtures.dart';

const _min = 16;
const _max = 23;

typedef _World = ({
  List<Player> pool,
  Map<int, PlayerCondition> condition,
  Map<int, PlayerAbsence> absences,
});

/// A believable nation pool for [seed]: five keepers and thirty-five
/// outfielders aged 17 to 34, rated 56 to 85, with condition drawn per man
/// the way the game derives it, and a handful hurt or banned.
_World _world(int seed) {
  final rng = SeededRng(seed * 7919 + 13);
  const outfield = [
    PlayerPosition.cb,
    PlayerPosition.cb,
    PlayerPosition.cb,
    PlayerPosition.lb,
    PlayerPosition.rb,
    PlayerPosition.dm,
    PlayerPosition.cm,
    PlayerPosition.cm,
    PlayerPosition.am,
    PlayerPosition.lm,
    PlayerPosition.rm,
    PlayerPosition.lw,
    PlayerPosition.rw,
    PlayerPosition.st,
    PlayerPosition.st,
  ];
  final pool = <Player>[
    for (var i = 0; i < 5; i++)
      player(
        id: 100 + i,
        nationId: 1,
        age: 17 + rng.nextInt(18),
        position: PlayerPosition.gk,
        attributes: flatAttributes(56 + rng.nextInt(30)),
      ),
    for (var i = 0; i < 35; i++)
      player(
        id: 200 + i,
        nationId: 1,
        age: 17 + rng.nextInt(18),
        position: outfield[i % outfield.length],
        attributes: flatAttributes(56 + rng.nextInt(30)),
      ),
  ];
  final condition = <int, PlayerCondition>{};
  for (final p in pool) {
    final form = PlayerForm.values[rng.nextInt(PlayerForm.values.length)];
    final fatigue =
        FatigueState.values[rng.nextInt(FatigueState.values.length)];
    final formDelta = switch (form) {
      PlayerForm.onFire => 4,
      PlayerForm.good => 2,
      PlayerForm.steady => 0,
      PlayerForm.poor => -2,
      PlayerForm.cold => -4,
    };
    final tired = switch (fatigue) {
      FatigueState.fresh => 0,
      FatigueState.ready => -1,
      FatigueState.tired => -3,
      FatigueState.exhausted => -6,
    };
    final morale = rng.nextInt(5) - 2;
    condition[p.id] = (
      form: form,
      formRating: 6.7,
      fatigueState: fatigue,
      gamesInWindow: fatigue.index + 1,
      overallDelta: (formDelta + tired + morale).clamp(-9, 6),
      clubStanding: null,
    );
  }
  final absences = <int, PlayerAbsence>{};
  for (final p in pool) {
    final roll = rng.nextDouble();
    if (roll < 0.06) {
      absences[p.id] = PlayerAbsence(playerId: p.id, injuryMatches: 1);
    } else if (roll < 0.10) {
      absences[p.id] = PlayerAbsence(playerId: p.id, banMatches: 1);
    } else if (roll < 0.13) {
      // Out for longer than the whole window.
      absences[p.id] = PlayerAbsence(playerId: p.id, injuryMatches: 9);
    }
  }
  return (pool: pool, condition: condition, absences: absences);
}

CallUpAdviceSet? _ask(
  StaffTier tier,
  _World w,
  int seed, {
  Formation formation = Formation.f433,
  bool? opponentsStronger,
}) => CallUpAdvice.propose(
  tier: tier,
  pool: w.pool,
  absences: w.absences,
  coverage: 2,
  formation: formation,
  seed: seed,
  min: _min,
  max: _max,
  // The screen hands a basic assistant no condition; neither does this.
  condition: tier == StaffTier.basic ? const {} : w.condition,
  opponentsStronger: opponentsStronger,
);

double _strength(_World w, Set<int> squad, Formation formation) =>
    CallUpAdvice.squadStrength(
      squad,
      formation,
      {for (final p in w.pool) p.id: p},
      {for (final e in w.condition.entries) e.key: e.value.overallDelta},
    );

void main() {
  test('nobody in the job gives no advice', () {
    expect(_ask(StaffTier.none, _world(1), 1), isNull);
  });

  test('a better assistant names a stronger squad, by the engine\'s own '
      'measure, over many saves and days', () {
    const runs = 200;
    final total = {for (final t in StaffTier.values) t: 0.0};
    var basicClearlyOff = 0;
    for (var seed = 1; seed <= runs; seed++) {
      final w = _world(seed);
      final formation = Formation.values[seed % Formation.values.length];
      final by = <StaffTier, double>{};
      for (final tier in [StaffTier.basic, StaffTier.good, StaffTier.elite]) {
        final advice = _ask(tier, w, seed * 31, formation: formation)!;
        by[tier] = _strength(w, advice.main.squad, formation);
        total[tier] = total[tier]! + by[tier]!;
      }
      // "Sometimes clearly off": five points or more off the eleven the
      // elite man would field from his own squad.
      if (by[StaffTier.elite]! - by[StaffTier.basic]! >= 5) {
        basicClearlyOff++;
      }
    }
    final basic = total[StaffTier.basic]! / runs;
    final good = total[StaffTier.good]! / runs;
    final elite = total[StaffTier.elite]! / runs;
    expect(elite, greaterThan(good), reason: 'elite $elite vs good $good');
    expect(good, greaterThan(basic), reason: 'good $good vs basic $basic');
    expect(
      basicClearlyOff,
      greaterThan(runs ~/ 40),
      reason: 'the basic man is clearly off on some days',
    );
    expect(
      basicClearlyOff,
      lessThan(runs ~/ 4),
      reason: 'but not most of them',
    );
  });

  test('never names a man out for the whole period, and names one hurt or '
      'banned now only when his line is short of fit men', () {
    var unavailableSeen = 0;
    for (var seed = 1; seed <= 120; seed++) {
      final w = _world(seed);
      final byId = {for (final p in w.pool) p.id: p};
      final fielded = <PositionCategory, int>{};
      for (final pos in Formation.f433.positions) {
        fielded[pos.category] = (fielded[pos.category] ?? 0) + 1;
      }
      int fitIn(PositionCategory c) => w.pool
          .where(
            (p) =>
                p.position.category == c &&
                (w.absences[p.id]?.isAvailable ?? true),
          )
          .length;
      int floorOf(PositionCategory c) => c == PositionCategory.goalkeeper
          ? SquadSelection.keepers
          : (fielded[c] ?? 0) + 1;
      for (final tier in [StaffTier.basic, StaffTier.good, StaffTier.elite]) {
        final advice = _ask(tier, w, seed)!;
        for (final proposal in [advice.main, ...advice.alternatives]) {
          for (final id in proposal.squad) {
            final absence = w.absences[id];
            expect(
              SquadSelection.usableInPeriod(absence, 2),
              isTrue,
              reason: '$tier ${proposal.variant} named $id, out for good',
            );
            if (absence?.isAvailable ?? true) continue;
            unavailableSeen++;
            final line = byId[id]!.position.category;
            expect(
              fitIn(line),
              lessThan(floorOf(line)),
              reason: '$tier ${proposal.variant} named absent $id ($seed)',
            );
            expect(proposal.reasons[id], CallUpReason.lineCover);
          }
        }
      }
    }
    // The rule above is exercised, not vacuous: some pools are short.
    expect(unavailableSeen, greaterThan(0));
  });

  test('in a thin pool, tops up only with men back during the period', () {
    final w = _world(7);
    // Everyone but twelve is out: eight for one match, the rest for good.
    final absences = <int, PlayerAbsence>{
      for (final (i, p) in w.pool.indexed)
        if (i >= 12)
          p.id: PlayerAbsence(playerId: p.id, injuryMatches: i < 20 ? 1 : 9),
    };
    final advice = CallUpAdvice.propose(
      tier: StaffTier.elite,
      pool: w.pool,
      absences: absences,
      coverage: 2,
      formation: Formation.f433,
      seed: 3,
      min: _min,
      max: _max,
      condition: w.condition,
    )!;
    final squad = advice.main.squad;
    expect(squad, hasLength(_min));
    for (final id in squad) {
      expect(
        SquadSelection.usableInPeriod(absences[id], 2),
        isTrue,
        reason: '$id misses the whole period',
      );
    }
  });

  test('keeps the squad size and every line the screen\'s auto-pick keeps', () {
    for (var seed = 1; seed <= 80; seed++) {
      final w = _world(seed);
      final formation = Formation.values[seed % Formation.values.length];
      final fielded = <PositionCategory, int>{};
      for (final pos in formation.positions) {
        fielded[pos.category] = (fielded[pos.category] ?? 0) + 1;
      }
      final byId = {for (final p in w.pool) p.id: p};
      for (final tier in [StaffTier.basic, StaffTier.good, StaffTier.elite]) {
        final advice = _ask(tier, w, seed, formation: formation)!;
        for (final proposal in [advice.main, ...advice.alternatives]) {
          final squad = proposal.squad;
          expect(squad.length, inInclusiveRange(_min, _max));
          int count(PositionCategory c) =>
              squad.where((id) => byId[id]!.position.category == c).length;
          // As many as the line has who can play in the period, up to its
          // floor.
          int usable(PositionCategory c) => w.pool
              .where(
                (p) =>
                    p.position.category == c &&
                    SquadSelection.usableInPeriod(w.absences[p.id], 2),
              )
              .length;
          int atLeast(PositionCategory c, int floor) =>
              usable(c) < floor ? usable(c) : floor;
          expect(
            count(PositionCategory.goalkeeper),
            atLeast(PositionCategory.goalkeeper, SquadSelection.keepers),
            reason: '$tier ${proposal.variant} keepers ($seed)',
          );
          for (final line in [
            PositionCategory.defender,
            PositionCategory.midfielder,
            PositionCategory.forward,
          ]) {
            expect(
              count(line),
              greaterThanOrEqualTo(atLeast(line, (fielded[line] ?? 0) + 1)),
              reason: '$tier ${proposal.variant} $line ($seed)',
            );
          }
          // Every man named carries a reason.
          expect(proposal.reasons.keys.toSet(), squad);
        }
      }
    }
  });

  test('alternatives genuinely differ from his pick and from each other', () {
    var good = 0;
    var elite = 0;
    for (var seed = 1; seed <= 60; seed++) {
      final w = _world(seed);
      for (final tier in [StaffTier.basic, StaffTier.good, StaffTier.elite]) {
        final advice = _ask(tier, w, seed)!;
        final alts = advice.alternatives;
        expect(
          alts.length,
          lessThanOrEqualTo(tier == StaffTier.basic ? 1 : 2),
        );
        for (var i = 0; i < alts.length; i++) {
          expect(alts[i].variant, isNot(CallUpVariant.main));
          expect(alts[i].sameSquad(advice.main.squad), isFalse);
          for (var j = i + 1; j < alts.length; j++) {
            expect(alts[i].sameSquad(alts[j].squad), isFalse);
          }
        }
        // Only an elite man reads form.
        if (tier != StaffTier.elite) {
          expect(
            alts.map((a) => a.variant),
            isNot(contains(CallUpVariant.inForm)),
          );
        }
        if (tier == StaffTier.good && alts.length == 2) good++;
        if (tier == StaffTier.elite && alts.length == 2) elite++;
      }
    }
    // A real pool nearly always gives him two different ideas.
    expect(good, greaterThan(50));
    expect(elite, greaterThan(50));
  });

  test('asking twice on one day gives one answer', () {
    final w = _world(5);
    for (final tier in [StaffTier.basic, StaffTier.good, StaffTier.elite]) {
      final a = _ask(tier, w, 99)!;
      final b = _ask(tier, w, 99)!;
      expect(a.main.squad, b.main.squad);
      expect(
        [for (final x in a.alternatives) x.squad],
        [for (final x in b.alternatives) x.squad],
      );
    }
  });

  test('the elite man leads with experience against stronger opponents, '
      'with youth against weaker ones', () {
    var stronger = 0;
    var weaker = 0;
    for (var seed = 1; seed <= 40; seed++) {
      final w = _world(seed);
      final up = _ask(StaffTier.elite, w, seed, opponentsStronger: true)!;
      final down = _ask(StaffTier.elite, w, seed, opponentsStronger: false)!;
      if (up.alternatives.first.variant == CallUpVariant.experience) {
        stronger++;
      }
      if (down.alternatives.first.variant == CallUpVariant.youth) weaker++;
    }
    // Most of the time: a pool with nobody of that age left out has no such
    // squad to offer, and then he leads with the next idea.
    expect(stronger, greaterThan(30));
    expect(weaker, greaterThan(30));
  });

  test('reads the window\'s opponents on the ranking', () {
    expect(
      CallUpAdvice.opponentsStronger(
        ownRanking: 20,
        opponentRankings: [5, 12],
      ),
      isTrue,
    );
    expect(
      CallUpAdvice.opponentsStronger(
        ownRanking: 20,
        opponentRankings: [40, 31],
      ),
      isFalse,
    );
    expect(
      CallUpAdvice.opponentsStronger(ownRanking: 20, opponentRankings: []),
      isNull,
    );
  });

  test('says why a man is left out, as far as the man reads', () {
    final p = player(id: 1, nationId: 1);
    const tired = <int, PlayerCondition>{
      1: (
        form: PlayerForm.cold,
        formRating: 5,
        fatigueState: FatigueState.exhausted,
        gamesInWindow: 5,
        overallDelta: -9,
        clubStanding: null,
      ),
    };
    CallUpReason why(StaffTier t, [Map<int, PlayerAbsence> a = const {}]) =>
        CallUpAdvice.leftOutReason(
          p,
          tier: t,
          absences: a,
          condition: tired,
        );
    expect(
      why(StaffTier.basic, {
        1: const PlayerAbsence(playerId: 1, banMatches: 1),
      }),
      CallUpReason.banned,
    );
    expect(
      why(StaffTier.elite, {
        1: const PlayerAbsence(playerId: 1, injuryMatches: 2),
      }),
      CallUpReason.injured,
    );
    expect(why(StaffTier.basic), CallUpReason.othersAhead);
    expect(why(StaffTier.good), CallUpReason.tired);
    expect(why(StaffTier.elite), CallUpReason.tired);
  });
}
