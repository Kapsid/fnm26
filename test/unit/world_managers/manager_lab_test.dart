@Tags(['slow'])
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'manager_lab_world.dart';

/// The tenure lab: 5 cycles x 8 seeds. Run with
/// `FNM_LAB=1 flutter test test/unit/world_managers/manager_lab_test.dart`.
void main() {
  test(
    'manager tenure lab',
    () {
      final rows = [
        for (var seed = 1; seed <= 8; seed++) runManagerLab(seed: seed),
      ];
      String f(double v) => v.toStringAsFixed(3);
      for (var i = 0; i < rows.length; i++) {
        final s = rows[i];
        // ignore: avoid_print, the lab's whole point is its printout.
        print(
          'seed ${i + 1}: tenure ${f(s.meanTenureYears)}y '
          'perObserved ${f(s.yearsPerObservedSpell)}y '
          'yearly ${f(s.yearlyChangeShare)} '
          'postFinals ${f(s.postFinalsShare)} '
          'maxPoint ${f(s.maxPointShare)} '
          'wcYear ${f(s.maxWcYearShare)} '
          'changes ${s.changes} ended ${s.completedSpells}',
        );
      }
      double mean(double Function(LabStats) g) =>
          rows.map(g).reduce((a, b) => a + b) / rows.length;
      // ignore: avoid_print, the lab's whole point is its printout.
      print(
        'MEAN: tenure ${f(mean((s) => s.meanTenureYears))}y '
        'yearly ${f(mean((s) => s.yearlyChangeShare))} '
        'postFinals ${f(mean((s) => s.postFinalsShare))} '
        'maxPoint ${f(rows.map((s) => s.maxPointShare).reduce((a, b) => a > b ? a : b))} '
        'wcYear ${f(rows.map((s) => s.maxWcYearShare).reduce((a, b) => a > b ? a : b))}',
      );
    },
    skip: Platform.environment['FNM_LAB'] == '1' ? false : 'set FNM_LAB=1',
  );
}
