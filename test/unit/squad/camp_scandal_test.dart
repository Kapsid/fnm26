import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/squad/camp_scandal.dart';

/// "A small chance for a player to have a scandal during the camp."
///
/// Small is the point: grievances were switched off because they fired
/// between every pair of matches. These pin the per-cycle rule (about one
/// cycle in two, its date drawn across the cycle's calendar, breaking at the
/// first window on or after it) and the determinism a reload depends on. The
/// rate walked in game, with fixtures written as they are in play, is pinned
/// in camp_scandal_flow_test.dart.
void main() {
  final squad = [
    for (var i = 0; i < 23; i++) (playerId: 1000 + i, age: 18 + i % 17),
  ];
  final opens = DateTime(2030, 9);
  final closes = DateTime(2034, 7, 19);

  /// A window every couple of months across the whole cycle.
  final windows = [
    for (
      var d = DateTime(2030, 9, 5);
      d.isBefore(closes);
      d = d.add(const Duration(days: 61))
    )
      d,
  ];

  int? scandalWindow(int seed, List<DateTime> starts) {
    for (var i = 0; i < starts.length; i++) {
      if (CampScandal.fires(
        seed: seed,
        cycle: 1,
        window: starts[i],
        starts: starts,
        opens: opens,
        closes: closes,
      )) {
        return i;
      }
    }
    return null;
  }

  test('about one cycle in two, and never two windows in one', () {
    var withOne = 0;
    const runs = 4000;
    for (var seed = 0; seed < runs; seed++) {
      var fired = 0;
      for (final w in windows) {
        if (CampScandal.fires(
          seed: seed,
          cycle: 1,
          window: w,
          starts: windows,
          opens: opens,
          closes: closes,
        )) {
          fired++;
        }
      }
      expect(fired, lessThanOrEqualTo(1));
      withOne += fired;
    }
    expect(withOne / runs, inInclusiveRange(0.45, 0.55));
  });

  test('the target is spread evenly across the whole cycle', () {
    final quarters = List<int>.filled(4, 0);
    final span = closes.difference(opens).inDays;
    for (var seed = 0; seed < 4000; seed++) {
      final t = CampScandal.targetDate(
        seed: seed,
        cycle: 1,
        opens: opens,
        closes: closes,
      );
      expect(t.isBefore(opens), isFalse);
      expect(t.isAfter(closes), isFalse);
      quarters[(t.difference(opens).inDays * 4 ~/ (span + 1))]++;
    }
    for (final q in quarters) {
      expect(q / 4000, closeTo(0.25, 0.03), reason: '$quarters');
    }
  });

  test('so late windows get scandals as often as early ones', () {
    final halves = [0, 0];
    for (var seed = 0; seed < 4000; seed++) {
      final w = scandalWindow(seed, windows);
      if (w == null) continue;
      halves[w < windows.length / 2 ? 0 : 1]++;
    }
    expect(halves[1] / (halves[0] + halves[1]), closeTo(0.5, 0.05));
  });

  test('it breaks at the first window on or after the target', () {
    for (var seed = 0; seed < 300; seed++) {
      if (!CampScandal.cycleHasScandal(seed: seed, cycle: 1)) {
        expect(scandalWindow(seed, windows), isNull);
        continue;
      }
      final t = CampScandal.targetDate(
        seed: seed,
        cycle: 1,
        opens: opens,
        closes: closes,
      );
      final i = scandalWindow(seed, windows);
      final due = windows.where((d) => !d.isBefore(t));
      if (due.isEmpty) {
        expect(i, isNull, reason: 'no window left after the target');
      } else {
        expect(windows[i!], due.first);
      }
    }
  });

  test('a window added later (a draw, a friendly) is counted', () {
    // Before the World Championship qualifiers exist the save knows only
    // the first half of the cycle; their windows are drawn in later.
    final early = windows.where((d) => d.isBefore(DateTime(2032, 7))).toList();
    for (var seed = 0; seed < 600; seed++) {
      final t = CampScandal.targetDate(
        seed: seed,
        cycle: 1,
        opens: opens,
        closes: closes,
      );
      if (!t.isAfter(early.last)) continue;
      // Target in the second half: nothing fires while only the early
      // windows exist, and the full schedule finds it later.
      expect(scandalWindow(seed, early), isNull);
    }
  });

  test('the same save and window always give the same answer', () {
    for (var seed = 0; seed < 200; seed++) {
      for (final w in windows) {
        final a = CampScandal.roll(
          seed: seed,
          cycle: 1,
          window: w,
          starts: windows,
          opens: opens,
          closes: closes,
          candidates: squad,
        );
        final b = CampScandal.roll(
          seed: seed,
          cycle: 1,
          window: w,
          starts: windows,
          opens: opens,
          closes: closes,
          // The order the squad is handed over in never matters.
          candidates: squad.reversed.toList(),
        );
        expect(a, b);
      }
    }
  });

  /// A scandal for [seed] in a one-window cycle whose target is that window.
  ScandalRoll? only(int seed, List<ScandalCandidate> candidates) {
    final w = DateTime(2031, 3, 20);
    return CampScandal.roll(
      seed: seed,
      cycle: 0,
      window: w,
      starts: [w],
      opens: w,
      closes: w,
      candidates: candidates,
    );
  }

  test('the twenty-somethings are the likely ones', () {
    var inBand = 0;
    var fired = 0;
    for (var i = 0; i < 40000 && fired < 600; i++) {
      final r = only(i, squad);
      if (r == null) continue;
      fired++;
      final age = squad.firstWhere((p) => p.playerId == r.playerId).age;
      if (age >= 20 && age <= 30) inBand++;
    }
    final share = inBand / fired;
    // 15 of the 23 are 20-30; weighted 3:1 they are about 85% of the picks.
    expect(share, greaterThan(0.75));
    expect(share, lessThan(0.95), reason: 'the others can still be picked');
  });

  test('a boy is only ever the curfew story', () {
    final boys = [for (var i = 0; i < 23; i++) (playerId: 2000 + i, age: 16)];
    var fired = 0;
    for (var i = 0; i < 2000; i++) {
      final r = only(i, boys);
      if (r == null) continue;
      fired++;
      expect(r.kind, ScandalKind.curfew);
    }
    expect(fired, greaterThan(500));
    // Grown men get every kind.
    final kinds = {
      for (var i = 0; i < 2000; i++)
        if (only(i, squad) case final r?) r.kind,
    };
    expect(kinds, ScandalKind.values.toSet());
  });

  test('nobody to pick, no scandal', () {
    for (var s = 0; s < 500; s++) {
      expect(only(s, const []), isNull);
    }
  });

  test('a marker carries the whole story and reads back', () {
    final r = (
      cycle: 3,
      window: DateTime(2039, 9, 4),
      playerId: 98765,
      kind: ScandalKind.casino,
      choice: ScandalChoice.sentHome,
    );
    final marker = CampScandal.markerOf(r);
    expect(marker, startsWith(CampScandal.cyclePrefix(3)));
    expect(CampScandal.parse(marker), r);
    // A different cycle's prefix does not claim it.
    expect(marker.startsWith(CampScandal.cyclePrefix(30)), isFalse);
    expect(CampScandal.parse('scandal:nonsense'), isNull);
    expect(CampScandal.parse('callup:12'), isNull);
  });
}
