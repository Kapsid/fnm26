import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/achievements/achievement_providers.dart';
import 'package:fnm/features/career/nation_offers_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/objective_providers.dart';
import 'package:fnm/features/press/press_providers.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';
import 'package:fnm/features/y/y_providers.dart';

import 'driver.dart';

/// Minnow board lab: plays LAB_CYCLES (default 2) cycles on autopilot as each
/// of the world's weakest sides, LAB_RUNS times each (every run its own world
/// seed and match salt), and prints the board's briefs, the last ten results,
/// the gauge and whether the manager would have been sacked at each rollover.
/// Not part of the suite: without LAB_RUNS it plays nothing.
///
/// LAB_NATIONS=45,2 picks the sides by id (default: San Marino, Andorra,
/// Liechtenstein, Gibraltar, Anguilla, American Samoa, Cook Islands,
/// Montserrat). The autopilot is the story driver's: best XI, even budget,
/// the same friendlies against England's rivals.
///
/// The verdict at a rollover is read, then the driver carries on with the same
/// nation whatever it said, so cycle 2 is "had he been kept".
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final runs = int.parse(Platform.environment['LAB_RUNS'] ?? '0');
  if (runs == 0) {
    test('minnow board lab', () {}, skip: 'set LAB_RUNS to run the lab');
    return;
  }
  final cycles = int.parse(Platform.environment['LAB_CYCLES'] ?? '2');
  final ids =
      Platform.environment['LAB_NATIONS']?.split(',').map(int.parse).toList() ??
      const [45, 2, 30, 21, 66, 201, 202, 89];
  final sacks = <int, List<int>>{}; // cycle -> sacked flags (1/0)

  for (final id in ids) {
    final n = nationById[id]!;
    for (var run = 0; run < runs; run++) {
      test('${n.name} run $run', () async {
        final c = storyContainer(null, run + 1);
        addTearDown(c.dispose);
        final d = await StoryDriver.start(c, 1000 + run, nationId: id);
        var cycle = 0;
        var done = false;
        d.beforeEvent = (e) async {
          if (e.kind != HubEventKind.cycleRollover) return;
          cycle++;
          c
            ..invalidate(cycleObjectiveOutcomesProvider(d.careerId))
            ..invalidate(satisfactionProvider(d.careerId))
            ..invalidate(rolloverVerdictProvider(d.careerId));
          final objectives = await c.read(
            cycleObjectivesProvider(d.careerId).future,
          );
          final sat = await c.read(satisfactionProvider(d.careerId).future);
          final verdict = await c.read(
            rolloverVerdictProvider(d.careerId).future,
          );
          final press = await c.read(pressEffectProvider(d.careerId).future);
          final mood = await c.read(publicMoodProvider(d.careerId).future);
          final career = (await c
              .read(careerRepositoryProvider)
              .byId(d.careerId))!;
          final fixtures = [
            for (final f
                in await c
                    .read(competitionRepositoryProvider)
                    .fixturesForNation(d.careerId, career.nationId))
              if (f.hasResult) f,
          ]..sort((a, b) => b.date.compareTo(a.date));
          final ranking = await c.read(
            worldRankingProvider(d.careerId).future,
          );
          final rankOf = ranking?.position ?? const <int, int>{};
          final games = <String>[];
          var w = 0, dr = 0, l = 0, gf = 0, ga = 0, heavy = 0;
          for (final f in fixtures.take(10)) {
            final home = f.homeNationId == career.nationId;
            final mine = home ? f.homeScore! : f.awayScore!;
            final theirs = home ? f.awayScore! : f.homeScore!;
            final opp = home ? f.awayNationId : f.homeNationId;
            games.add('${f.round ?? 'Q'}$mine-$theirs#${rankOf[opp]}');
            gf += mine;
            ga += theirs;
            if (mine > theirs) {
              w++;
            } else if (mine == theirs) {
              dr++;
            } else {
              l++;
              if (theirs - mine >= 4) heavy++;
            }
          }
          final parts = [
            for (final o in objectives)
              '${o.tier.name}:${o.target}/${o.actual}${o.met ? '+' : '-'}',
          ];
          (sacks[cycle] ??= []).add(verdict!.sacked ? 1 : 0);
          // ignore: avoid_print
          print(
            'LAB ${n.name} run=$run cycle=$cycle | ${parts.join(' ')} | '
            'last10 W$w D$dr L$l gf$gf ga$ga heavy$heavy | press=${press.board} '
            'mood=$mood | sat=$sat sacked=${verdict.sacked} | '
            'own#${rankOf[career.nationId]} ${games.join(' ')}',
          );
          if (cycle >= cycles) done = true;
        };
        var steps = 0;
        while (!done && await d.step()) {
          if (++steps > 4000 * cycles) throw StateError('runaway');
        }
      }, timeout: Timeout(Duration(minutes: 10 * cycles)));
    }
  }
  // LAB_MIN_KEPT=75: fail unless at least that share of managers keeps the
  // job through cycle 1 (the owner's target for an average minnow manager).
  final minKept = int.tryParse(Platform.environment['LAB_MIN_KEPT'] ?? '');
  test('minnow board lab summary', () {
    for (final e in sacks.entries) {
      final n = e.value.length;
      final kept = n - e.value.fold<int>(0, (a, b) => a + b);
      if (e.key == 1 && minKept != null) {
        expect(100 * kept, greaterThanOrEqualTo(minKept * n));
      }
      // ignore: avoid_print
      print(
        'LAB SUMMARY cycle=${e.key} n=$n kept=$kept '
        '(${n == 0 ? '-' : (100 * kept / n).round()}%)',
      );
    }
  });
}
