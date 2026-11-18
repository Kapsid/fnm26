@Tags(['slow'])
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../helpers/knockout_lab.dart';

/// The knockout lab's full table (`FNM_KO_LAB=1`; several minutes). Prints,
/// for each pairing and stage, the manager's win probability in a one-off
/// finals knockout before (an older cycle) and after (a `difficulty2`
/// cycle), played and skipped, beside the AI world's. `FNM_KO_STAGES=0,2`
/// limits the stages, `FNM_KO_PAIRS=80:88,80:84` the pairings.
void main() {
  test(
    'knockout lab table',
    () {
      final stages = (Platform.environment['FNM_KO_STAGES'] ?? '0,1,2')
          .split(',')
          .map(int.parse);
      final pairs =
          (Platform.environment['FNM_KO_PAIRS'] ??
                  '80:80,80:84,80:88,76:84,88:84,88:88,64:72,60:70')
              .split(',')
              .map((p) {
                final [a, b] = p.split(':').map(double.parse).toList();
                return (a, b);
              });
      final edges = (Platform.environment['FNM_KO_EDGES'] ?? 'typical,hot')
          .split(',');
      String f(double v) => v.toStringAsFixed(3);
      for (final (mine, theirs) in pairs) {
        for (final stage in stages) {
          final out = StringBuffer(
            '${mine.toInt()}v${theirs.toInt()} ${koRound(stage)} '
            '| world ${f(koWorld(mine: mine, theirs: theirs))}',
          );
          for (final name in edges) {
            final e = switch (name) {
              'typical' => koTypical,
              'hot' => koHotSmart,
              'host' => koHotHost,
              _ => koBare,
            };
            double p(bool d) => koPlayed(
              mine: mine,
              theirs: theirs,
              edge: e,
              difficulty: d,
              stage: stage,
              seeds: name == 'typical' ? 1200 : 800,
            );
            double s(bool d) => koSkipped(
              mine: mine,
              theirs: theirs,
              edge: e,
              difficulty: d,
              stage: stage,
              seeds: name == 'typical' ? 4000 : 1500,
            );
            out.write(
              ' | ${e.name} played ${f(p(false))}->${f(p(true))}'
              ' skipped ${f(s(false))}->${f(s(true))}',
            );
          }
          // ignore: avoid_print
          print(out);
        }
      }
    },
    skip: Platform.environment['FNM_KO_LAB'] == '1'
        ? false
        : 'lab table: FNM_KO_LAB=1',
    timeout: const Timeout(Duration(minutes: 60)),
  );
}
