@Tags(['slow'])
library;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/squad/condition.dart';
import 'package:fnm/features/tactics/condition_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';

import 'driver.dart';

/// FATIGUE LAB: how much of a squad reads tired before a typical match.
///
/// Plays one full cycle as England on autopilot and, before each of the
/// manager's matches, reads every called-up player's condition as the
/// line-up would show it. The autopilot never rotates (the same eleven start
/// every match), so its numbers are the worst case. Beside it, the same match
/// dates are replayed through [Condition.fatigue] for a manager who rests
/// whoever the screen flags tired: what a sensibly rotated squad looks like.
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  test('fatigue at the decision points of one cycle', () async {
    final c = storyContainer();
    addTearDown(c.dispose);
    final d = await StoryDriver.start(c, 1);
    final dates = <DateTime>[];
    final rows = <String>[];
    var squadSeen = 0;
    var squadFlagged = 0;
    var squadDocked = 0;
    var xiSeen = 0;
    var xiFlagged = 0;
    d.beforeMatch = (p) async {
      dates.add(p.fixture.date);
      c
        ..invalidate(squadConditionProvider(d.careerId))
        ..invalidate(squadDataProvider(d.careerId));
      final sub = c.listen(
        squadConditionProvider(d.careerId).future,
        (_, _) {},
      );
      final sq = c.listen(squadDataProvider(d.careerId).future, (_, _) {});
      final conditions = await sub.read();
      final data = await sq.read();
      sub.close();
      sq.close();
      final me = p.playerIsHome ? p.homeTeam : p.awayTeam;
      final xi = {for (final pl in me.xi) pl.id};
      final squad = data?.callUps ?? xi;
      final count = <FatigueState, int>{};
      var docked = 0;
      for (final id in squad) {
        final s = conditions[id]?.fatigueState ?? FatigueState.fresh;
        count[s] = (count[s] ?? 0) + 1;
        if (s != FatigueState.fresh) docked++;
        squadSeen++;
        if (s == FatigueState.tired || s == FatigueState.exhausted) {
          squadFlagged++;
        }
        if (xi.contains(id)) {
          xiSeen++;
          if (s == FatigueState.tired || s == FatigueState.exhausted) {
            xiFlagged++;
          }
        }
      }
      squadDocked += docked;
      rows.add(
        '${p.fixture.date.toIso8601String().substring(0, 10)} '
        '${(p.fixture.round ?? 'FR').padRight(10)} squad=${squad.length} '
        'fresh=${count[FatigueState.fresh] ?? 0} '
        'ready=${count[FatigueState.ready] ?? 0} '
        'tired=${count[FatigueState.tired] ?? 0} '
        'exh=${count[FatigueState.exhausted] ?? 0}',
      );
    };
    var steps = 0;
    while (await d.step(stopAtRollover: true)) {
      if (++steps > 4000) throw StateError('runaway');
    }
    // ignore: avoid_print
    print('FATIGUE LAB (autopilot, no rotation)\n${rows.join('\n')}');
    // ignore: avoid_print
    print(
      'FATIGUE LAB autopilot: matches=${dates.length} '
      'squad tired+=${_pct(squadFlagged, squadSeen)} '
      'squad any penalty=${_pct(squadDocked, squadSeen)} '
      'XI tired+=${_pct(xiFlagged, xiSeen)}',
    );
    // ignore: avoid_print
    print('FATIGUE LAB rotated: ${_rotated(dates)}');
  }, timeout: const Timeout(Duration(minutes: 20)));
}

String _pct(int n, int of) =>
    of == 0 ? '-' : '${(100 * n / of).toStringAsFixed(1)}% ($n/$of)';

/// The same match dates, played by a manager with 23 men ranked best first
/// who starts his best eleven not flagged tired and brings three on.
String _rotated(List<DateTime> dates) {
  const squad = 23;
  final apps = List.generate(squad, (_) => <DateTime>[]);
  var seen = 0;
  var flagged = 0;
  var docked = 0;
  var xiTired = 0;
  for (final date in dates) {
    final asOf = date;
    final states = [
      for (final a in apps) Condition.fatigue(a.reversed.toList(), asOf),
    ];
    for (final s in states) {
      seen++;
      if (s.state == FatigueState.tired || s.state == FatigueState.exhausted) {
        flagged++;
      }
      if (s.delta != 0) docked++;
    }
    bool rest(int i) =>
        states[i].state == FatigueState.tired ||
        states[i].state == FatigueState.exhausted;
    final order = [
      for (var i = 0; i < squad; i++)
        if (!rest(i)) i,
      for (var i = 0; i < squad; i++)
        if (rest(i)) i,
    ];
    final xi = order.take(11).toList();
    xiTired += xi.where(rest).length;
    for (final i in order.take(14)) {
      apps[i].add(date);
    }
  }
  return 'squad tired+=${_pct(flagged, seen)} '
      'squad any penalty=${_pct(docked, seen)} '
      'XI tired+=${_pct(xiTired, dates.length * 11)}';
}
