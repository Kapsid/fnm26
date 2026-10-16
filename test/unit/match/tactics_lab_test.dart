import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../helpers/tactics_lab.dart';

/// The tactics lab. Always-on: a cheap sanity check that the harness returns a
/// coherent result, and the guards that hold the 2026-10-16 tactics impact
/// build to its bar (1000 seeds each, wide bands). Opt-in: the full report,
/// which is slow (every plan x three opponent strengths x 2000 seeds x both
/// ways round, with and without a countering AI) and exists to be pasted into
/// `docs/superpowers/specs/2026-10-16-tactics-lab-results.md`:
///
///     FNM_LAB=1 flutter test test/unit/match/tactics_lab_test.dart
void main() {
  LabPlan lab(String name) => labPlans.firstWhere((p) => p.name == name);

  test('a lab cell reports results that add up', () {
    final s = runCell(
      manager: labPlans.first,
      managerRating: 80,
      opponentRating: 80,
      aiCounters: false,
      seeds: 50,
    );
    expect(s.win + s.draw + s.loss, closeTo(1, 1e-9));
    expect(s.total, closeTo(s.gf + s.ga, 1e-9));
  });

  group('the bar', () {
    test('no dominant plan', () {
      // The anti-goal: if one setting beats every other between equal squads,
      // the build has failed. Every plan must lose to at least one other.
      final gd = <(String, String), double>{};
      for (var i = 0; i < labPlans.length; i++) {
        for (var j = i + 1; j < labPlans.length; j++) {
          final r = runPair(labPlans[i], labPlans[j]);
          gd[(labPlans[i].name, labPlans[j].name)] = r.gf - r.ga;
          gd[(labPlans[j].name, labPlans[i].name)] = r.ga - r.gf;
        }
      }
      for (final p in labPlans) {
        final beaten = [
          for (final q in labPlans)
            if (q.name != p.name && gd[(p.name, q.name)]! <= 0) q.name,
        ];
        expect(beaten, isNotEmpty, reason: '${p.name} beats every other plan');
      }
    });

    test('open beats closed on goals', () {
      // Two all-out sides play a wild game, two buses a tight one: 4.7 goals
      // a game against 1.2 at the tuned constants.
      final open = runPair(lab('allOutAttack'), lab('allOutAttack'));
      final closed = runPair(lab('parkTheBus'), lab('parkTheBus'));
      expect(open.total, greaterThan(closed.total * 2.5));
    });

    test('squad still decides', () {
      // A 10-point-better squad on the plan its opponent's plan beats most
      // between equals (a high press against the counter-attack, about half a
      // goal a game), and on the pairing that goes 0-0 most (the counter
      // against a parked bus), still wins more than it loses.
      for (final (bad, best) in const [
        ('highPress', 'counter'),
        ('counter', 'parkTheBus'),
      ]) {
        final r = runPair(lab(bad), lab(best), aRating: 80, bRating: 70);
        expect(
          r.win,
          greaterThan(r.loss),
          reason: '80 on $bad against 70 on $best: W ${r.win} L ${r.loss}',
        );
      }
    });

    test('a predictable plan does worse against a countering side', () {
      // The reason to vary the plan: a side that has seen the same plan all
      // along (predictability 1) answers it harder than one that has nothing
      // to go on (predictability 0). Averaged over the committed plans.
      double meanGd(double predictability) {
        var sum = 0.0;
        final committed = labPlans.where((p) => p.name != 'neutral');
        for (final p in committed) {
          final s = runCell(
            manager: p,
            managerRating: 80,
            opponentRating: 80,
            aiCounters: true,
            predictability: predictability,
          );
          sum += s.gf - s.ga;
        }
        return sum / committed.length;
      }

      expect(meanGd(1), lessThan(meanGd(0) - 0.05));
    });

    test('neutral is no safe harbour against a countering side', () {
      // The baseline lab (before the build, same seeds) had neutral at
      // 1.34-1.36 against an equal AI side: -0.02 a game. Its middle is now
      // exposed, and an AI side that reads it takes something from it.
      final s = runCell(
        manager: lab('neutral'),
        managerRating: 80,
        opponentRating: 80,
        aiCounters: true,
        predictability: 1,
        seeds: 2000,
      );
      expect(s.gf - s.ga, lessThan(-0.02 - 0.03));
    });
  });

  test(
    'lab report',
    () {
      const opponents = {
        'equal 80v80': 80.0,
        'stronger 80v86': 86.0,
        'weaker 80v74': 74.0,
      };
      opponents.forEach((label, opponentRating) {
        for (final counters in const [false, true]) {
          final rows = <String, LabStats>{
            for (final plan in labPlans)
              plan.name: runCell(
                manager: plan,
                managerRating: 80,
                opponentRating: opponentRating,
                aiCounters: counters,
                // A countering side reads the manager fully: his plan is
                // all it has seen of him (the worst case for him).
                predictability: counters ? 1 : 0,
                seeds: 2000,
              ),
          };
          final title = counters
              ? '$label, countering AI (predictability 1)'
              : label;
          // The report IS the output: it is read off the terminal and pasted.
          // ignore: avoid_print
          print('\n### $title\n\n${labTable(rows)}');
        }
      });
    },
    timeout: const Timeout(Duration(minutes: 60)),
    skip: Platform.environment['FNM_LAB'] == null ? 'set FNM_LAB=1' : false,
  );
}
