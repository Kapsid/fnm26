import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/world_managers/manager_decisions.dart';

import 'manager_lab_world.dart';

/// Pins the turnover the owner asked for (spec section 2, owner ruling
/// 2026-11-09 second): mostly after finals, never more than 15% of the world
/// at once and never more than 20% in a World Championship's year. With
/// changes falling only in finals years, those caps put the mean tenure near
/// 11 years and about 9% of the world changing in an average year.
///
/// The spec bounds a mean tenure, not each synthetic world, so tenure and the
/// yearly share are asserted on the mean over the seeds; the per-point cap
/// and the post-finals share hold for every seed.
void main() {
  test('the lab stays in the tenure band', () {
    const seeds = [1, 2];
    final runs = {for (final s in seeds) s: runManagerLab(seed: s)};
    String f(double v) => v.toStringAsFixed(3);
    final perSeed = [
      for (final e in runs.entries)
        [
          'seed ${e.key}: tenure ${f(e.value.meanTenureYears)}y',
          'yearly ${f(e.value.yearlyChangeShare)}',
          'postFinals ${f(e.value.postFinalsShare)}',
          'maxPoint ${f(e.value.maxPointShare)}',
          'wcYear ${f(e.value.maxWcYearShare)}',
          'perObserved ${f(e.value.yearsPerObservedSpell)}y',
        ].join(' '),
    ].join('; ');
    // ignore: avoid_print, the per-seed figures go to the ledger.
    print(perSeed);

    double mean(double Function(LabStats) g) =>
        runs.values.map(g).reduce((a, b) => a + b) / runs.length;
    expect(
      mean((s) => s.meanTenureYears),
      inInclusiveRange(9.0, 13.0),
      reason: 'mean tenure over seeds; $perSeed',
    );
    expect(
      mean((s) => s.yearlyChangeShare),
      inInclusiveRange(0.07, 0.12),
      reason: 'mean yearly change share over seeds; $perSeed',
    );
    for (final e in runs.entries) {
      expect(
        e.value.postFinalsShare,
        greaterThanOrEqualTo(0.5),
        reason: 'seed ${e.key} post-finals share; $perSeed',
      );
      expect(
        e.value.maxPointShare,
        lessThanOrEqualTo(ManagerDecisions.capShare),
        reason: 'seed ${e.key} max share at one point; $perSeed',
      );
      expect(
        e.value.maxWcYearShare,
        lessThanOrEqualTo(ManagerDecisions.yearShare),
        reason: 'seed ${e.key} World Championship year; $perSeed',
      );
    }
  });
}
