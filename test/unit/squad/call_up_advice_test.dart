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
      personalDelta: (formDelta + tired).clamp(-9, 6),
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
  List<PlayerPosition>? positions,
  List<CallUpShape>? otherShapes,
  bool? opponentsStronger,
}) => CallUpAdvice.propose(
  tier: tier,
  pool: w.pool,
  absences: w.absences,
  coverage: 2,
  formation: formation,
  positions: positions,
  otherShapes: otherShapes,
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
      'banned now only when his line has too few fit men for its cover', () {
    var unavailableSeen = 0;
    final needs = CallUpAdvice.coverNeeds(Formation.f433.positions);
    for (var seed = 1; seed <= 120; seed++) {
      final w = _world(seed);
      final byId = {for (final p in w.pool) p.id: p};
      int fitIn(PositionCategory c) => w.pool
          .where(
            (p) =>
                p.position.category == c &&
                (w.absences[p.id]?.isAvailable ?? true),
          )
          .length;
      int needOf(PositionCategory c) => needs.entries
          .where((e) => e.key.category == c)
          .fold(0, (sum, e) => sum + e.value);
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
              lessThan(needOf(line)),
              reason: '$tier ${proposal.variant} named absent $id ($seed)',
            );
            expect(proposal.reasons[id], CallUpReason.backup);
            expect(proposal.positions[id], hasLength(1));
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
    // Twelve fit men are not enough to cover the shape: the men back during
    // the period make up the cover, and the squad is at least the minimum.
    expect(squad.length, inInclusiveRange(_min, 20));
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
        personalDelta: -9,
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

  group('built around the current tactic', () {
    /// [base] with the slot at [slot] switched to [to].
    List<PlayerPosition> switched(
      Formation base,
      int slot,
      PlayerPosition to,
    ) => [...base.positions]..[slot] = to;

    final shapes = <String, List<PlayerPosition>>{
      for (final f in [
        Formation.f433,
        Formation.f4231,
        Formation.f352,
        Formation.f442,
        Formation.f532,
        Formation.f41212,
      ])
        f.label: f.positions,
      // 4-3-3 with the holding midfielder pushed on: AM needs its cover.
      '4-3-3 DM>AM': switched(Formation.f433, 5, PlayerPosition.am),
      // 4-4-2 with a winger up front.
      '4-4-2 LM>LW': switched(Formation.f442, 5, PlayerPosition.lw),
    };

    Formation formationOf(String name) =>
        Formation.values.firstWhere((f) => name.startsWith(f.label));

    test('every position gets its first choice and a natural backup, one '
        'more where it is played twice, three keepers, in every proposal '
        'and at every tier', () {
      for (final MapEntry(key: name, value: positions) in shapes.entries) {
        final needs = CallUpAdvice.coverNeeds(positions);
        for (var seed = 1; seed <= 40; seed++) {
          final w = _world(seed);
          final byId = {for (final p in w.pool) p.id: p};
          int fitNaturals(PlayerPosition at) => w.pool
              .where(
                (p) =>
                    p.position == at && (w.absences[p.id]?.isAvailable ?? true),
              )
              .length;
          for (final tier in [
            StaffTier.basic,
            StaffTier.good,
            StaffTier.elite,
          ]) {
            final advice = _ask(
              tier,
              w,
              seed * 17,
              formation: formationOf(name),
              positions: positions,
            )!;
            for (final proposal in [advice.main, ...advice.alternatives]) {
              final squad = proposal.squad;
              expect(squad.length, inInclusiveRange(_min, _max));
              for (final MapEntry(key: at, value: need) in needs.entries) {
                final naturals = squad
                    .where((id) => byId[id]!.position == at)
                    .length;
                final want = fitNaturals(at) < need ? fitNaturals(at) : need;
                expect(
                  naturals,
                  greaterThanOrEqualTo(want),
                  reason:
                      '$name $tier ${proposal.variant} $at: $naturals of '
                      '$need ($seed)',
                );
                // And whoever plays it covers it, up to its need.
                final canPlay = squad
                    .where((id) => byId[id]!.position.category == at.category)
                    .length;
                expect(canPlay, greaterThanOrEqualTo(want));
              }
            }
          }
        }
      }
    });

    test('a slot switch changes the cover: DM pushed to AM names two AMs', () {
      // Plenty of everyone; the attacking midfielders the weakest men there.
      var id = 0;
      Player man(PlayerPosition at, int rating) => player(
        id: ++id,
        nationId: 1,
        position: at,
        attributes: flatAttributes(rating),
      );
      final pool = [
        for (final at in PlayerPosition.values)
          if (at != PlayerPosition.am)
            for (var i = 0; i < 4; i++) man(at, 80 - i),
        for (var i = 0; i < 3; i++) man(PlayerPosition.am, 55 - i),
      ];
      final w = (
        pool: pool,
        condition: <int, PlayerCondition>{},
        absences: <int, PlayerAbsence>{},
      );
      final byId = {for (final p in pool) p.id: p};
      int ams(Set<int> squad) =>
          squad.where((i) => byId[i]!.position == PlayerPosition.am).length;
      final plain = _ask(StaffTier.elite, w, 1)!;
      final pushed = _ask(
        StaffTier.elite,
        w,
        1,
        positions: switched(Formation.f433, 5, PlayerPosition.am),
      )!;
      expect(ams(plain.main.squad), 0);
      expect(ams(pushed.main.squad), 2);
      for (final p in [pushed.main, ...pushed.alternatives]) {
        expect(ams(p.squad), greaterThanOrEqualTo(2));
      }
    });

    test('beyond the cover, a man who plays two positions of the shape '
        'beats a slightly better one who plays only one', () {
      var id = 0;
      Player man(PlayerPosition at, int rating) => player(
        id: ++id,
        nationId: 1,
        position: at,
        attributes: flatAttributes(rating),
      );
      final needs = CallUpAdvice.coverNeeds(Formation.f433.positions);
      final pool = [
        for (final MapEntry(key: at, value: n) in needs.entries)
          for (var i = 0; i < n; i++) man(at, 80),
      ];
      final centreBack = man(PlayerPosition.cb, 74);
      final fullBack = man(PlayerPosition.lb, 72);
      pool.addAll([centreBack, fullBack]);
      expect(fullBack.overall, lessThan(centreBack.overall));
      final cover = needs.values.fold(0, (a, b) => a + b);
      final advice = CallUpAdvice.propose(
        tier: StaffTier.elite,
        pool: pool,
        absences: const {},
        coverage: 2,
        formation: Formation.f433,
        seed: 1,
        min: _min,
        // One place beyond the cover.
        max: cover + 1,
      )!;
      final main = advice.main;
      expect(main.squad, contains(fullBack.id));
      expect(main.squad, isNot(contains(centreBack.id)));
      expect(main.reasons[fullBack.id], CallUpReason.covers);
      expect(main.positions[fullBack.id], [
        PlayerPosition.lb,
        PlayerPosition.rb,
      ]);
    });

    test('the shapes he may change to: saved first, then drilled, then the '
        'neighbours, never the current one, each once', () {
      final shapes = CallUpAdvice.otherShapes(
        current: Formation.f433,
        saved: [
          (formation: Formation.f433, positions: Formation.f433.positions),
          (formation: Formation.f352, positions: Formation.f352.positions),
          (formation: Formation.f352, positions: Formation.f352.positions),
        ],
        familiarity: {
          Formation.f433: 0.9,
          Formation.f4231: 0.2,
          Formation.f541: 0.6,
          Formation.f442: 0,
        },
      );
      expect(
        [for (final s in shapes) s.formation],
        [
          Formation.f352,
          Formation.f541,
          Formation.f4231,
          Formation.f4141,
        ],
      );
      // With nothing saved or drilled, the neighbours.
      expect(
        CallUpAdvice.otherShapes(current: Formation.f433).first.formation,
        Formation.f4231,
      );
    });

    test('the change-of-tactics card is for his saved shape, names it, and '
        'brings in at most three men for its positions without touching '
        'the current cover', () {
      var cards = 0;
      var saved = 0;
      for (var seed = 1; seed <= 60; seed++) {
        final w = _world(seed);
        final byId = {for (final p in w.pool) p.id: p};
        final others = CallUpAdvice.otherShapes(
          current: Formation.f433,
          saved: [
            (formation: Formation.f352, positions: Formation.f352.positions),
          ],
          familiarity: {Formation.f541: 0.8},
        );
        for (final tier in [StaffTier.basic, StaffTier.good, StaffTier.elite]) {
          final advice = _ask(tier, w, seed, otherShapes: others)!;
          final change = advice.alternatives
              .where((a) => a.variant == CallUpVariant.tacticsChange)
              .toList();
          expect(change.length, lessThanOrEqualTo(1));
          if (change.isEmpty) continue;
          cards++;
          final card = change.single;
          // His saved shape, unless the squad already serves it as well as
          // it can: then the next likeliest.
          expect(others.map((o) => o.formation), contains(card.formation));
          if (card.formation == Formation.f352) saved++;
          final ins = card.squad.difference(advice.main.squad);
          expect(ins.length, inInclusiveRange(1, CallUpAdvice.maxChangeSwaps));
          for (final id in ins) {
            expect(card.reasons[id], CallUpReason.forChange);
            final at = card.positions[id]!.single;
            expect(card.formation!.positions, contains(at));
            expect(byId[id]!.position, at);
          }
          // Only men named on top of the current cover make way.
          final needs = CallUpAdvice.coverNeeds(Formation.f433.positions);
          for (final MapEntry(key: at, value: need) in needs.entries) {
            int naturals(Set<int> squad) =>
                squad.where((id) => byId[id]!.position == at).length;
            final before = naturals(advice.main.squad);
            expect(
              naturals(card.squad),
              greaterThanOrEqualTo(before < need ? before : need),
            );
          }
        }
      }
      // A real pool nearly always has something to say about a 3-5-2.
      expect(cards, greaterThan(150));
      expect(saved, greaterThan(cards * 3 ~/ 4));
    });

    test('with nothing saved, the most familiar other shape; with nothing '
        'drilled either, a neighbour', () {
      var drilled = 0;
      var neighbour = 0;
      for (var seed = 1; seed <= 40; seed++) {
        final w = _world(seed);
        final familiar = _ask(
          StaffTier.basic,
          w,
          seed,
          otherShapes: CallUpAdvice.otherShapes(
            current: Formation.f433,
            familiarity: {Formation.f541: 0.7, Formation.f4231: 0.4},
          ),
        )!;
        if (familiar.alternatives.firstOrNull?.formation == Formation.f541) {
          drilled++;
        }
        final plain = _ask(StaffTier.basic, w, seed)!;
        final alt = plain.alternatives.firstOrNull;
        if (alt?.variant == CallUpVariant.tacticsChange &&
            CallUpAdvice.otherShapes(
              current: Formation.f433,
            ).any((s) => s.formation == alt!.formation)) {
          neighbour++;
        }
      }
      expect(drilled, greaterThan(30));
      expect(neighbour, greaterThan(30));
    });
  });
}
