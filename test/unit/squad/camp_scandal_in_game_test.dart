import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/competition/finals_participation.dart';
import 'package:fnm/domain/services/squad/camp_scandal.dart';
import 'package:fnm/domain/services/squad/nomination.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/squad/camp_scandal_providers.dart';

import '../../story/driver.dart';

/// The scandal rate as a manager meets it: a whole cycle walked through the
/// hub, with fixtures written as they are in play (World Championship
/// qualifying drawn only once the continental cup is decided, a finals only
/// at its draw, friendlies as they are arranged).
///
/// At every call-up the test records the window and the windows the save
/// knew of AT THAT MOMENT, which is what the hub asks with. Then it asks the
/// same question for thousands of save seeds. Counting only the windows that
/// already existed is the bug this pins: it put every scandal into the early
/// campaigns and never into the World Championship qualifiers or its camp.
void main() {
  test(
    'about one cycle in two, landing in every part of the cycle',
    () async {
      final c = storyContainer();
      addTearDown(c.dispose);
      final d = await StoryDriver.start(c, 11);
      final comp = c.read(competitionRepositoryProvider);
      final career = (await c.read(careerRepositoryProvider).byId(d.careerId))!;
      final seen =
          <({DateTime window, String? round, List<DateTime> starts})>[];
      d.beforeEvent = (e) async {
        if (e.kind != HubEventKind.callUp) return;
        final uri = Uri.parse(e.route!);
        if (!(uri.queryParameters['event'] ?? '').startsWith('callup:')) {
          return;
        }
        final fixtures = await comp.cycleFixturesForNation(
          d.careerId,
          career.nationId,
        );
        final period = Nomination.currentPeriod(fixtures);
        if (period.isEmpty) return;
        seen.add((
          window: period.first.date,
          round: period.first.round,
          starts: CampScandal.windowStarts(fixtures),
        ));
      };
      for (var i = 0; i < 2000; i++) {
        if (!await d.step(stopAtRollover: true)) break;
      }
      expect(seen.length, greaterThan(8), reason: 'a whole cycle of call-ups');
      expect(
        seen.any((s) => s.round == 'GROUP'),
        isTrue,
        reason: 'the walk reached a World Championship camp',
      );

      final span = scandalSpan(0);
      var withOne = 0;
      var wcQualifying = 0;
      var finalsCamp = 0;
      var early = 0;
      const saves = 4000;
      for (var seed = 0; seed < saves; seed++) {
        var fired = 0;
        String? round;
        for (final s in seen) {
          if (CampScandal.fires(
            seed: seed,
            cycle: 0,
            window: s.window,
            starts: s.starts,
            opens: span.opens,
            closes: span.closes,
          )) {
            fired++;
            round ??= s.round ?? 'WCQ';
          }
        }
        expect(fired, lessThanOrEqualTo(1), reason: 'seed $seed');
        if (fired == 0) continue;
        withOne++;
        if (round == 'WCQ') wcQualifying++;
        if (FinalsRounds.worldChampionship.contains(round) ||
            FinalsRounds.continental.contains(round)) {
          finalsCamp++;
        }
        if (round == 'CQ' || round == 'NGROUP') early++;
      }
      final rate = withOne / saves;
      // ignore: avoid_print
      print(
        'scandal rate $rate over ${seen.length} windows: '
        'WC qualifying $wcQualifying, finals camps $finalsCamp, '
        'early campaigns $early',
      );
      expect(rate, inInclusiveRange(0.4, 0.55));
      expect(wcQualifying, greaterThan(withOne ~/ 10));
      expect(finalsCamp, greaterThan(0));
      expect(early, greaterThan(withOne ~/ 10));
    },
    timeout: const Timeout(Duration(minutes: 30)),
  );
}
