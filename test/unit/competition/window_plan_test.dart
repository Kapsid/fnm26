import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/schedule_generator.dart';
import 'package:fnm/domain/services/competition/window_plan.dart';

/// "International windows could be fluid: 2, 3, 4 matches (usually 2, 3)."
void main() {
  WindowSpan span(
    DateTime start,
    DateTime deadline, {
    int seed = 1,
    bool fillAll = false,
  }) => (start: start, deadline: deadline, seed: seed, fillAll: fillAll);

  Map<(int, int), int> perWindow(List<DateTime> dates) {
    final out = <(int, int), int>{};
    for (final d in dates) {
      out.update((d.year, d.month), (v) => v + 1, ifAbsent: () => 1);
    }
    return out;
  }

  // Continental qualifying: ten matchdays from the September a cycle opens,
  // done by the June after.
  final cq = span(DateTime(2026, 9), DateTime(2027, 6, 30));

  test('every window holds two to four matches, in date order', () {
    for (var seed = 0; seed < 200; seed++) {
      final dates = WindowPlan.dates((
        start: cq.start,
        deadline: cq.deadline,
        seed: seed,
        fillAll: false,
      ), 10)!;
      expect(dates, hasLength(10));
      expect([...dates]..sort(), dates);
      for (final n in perWindow(dates).values) {
        expect(n, inInclusiveRange(2, 4));
      }
      for (final d in dates) {
        expect(d.isBefore(cq.start), isFalse);
        expect(d.isAfter(cq.deadline), isFalse);
        expect(d.day, lessThanOrEqualTo(12), reason: 'clear of the 14th');
      }
    }
  });

  test('windows are used in order, without gaps', () {
    final order = WindowPlan.windowsOf(cq);
    expect(order.map((w) => w.month), [9, 10, 11, 3, 6]);
    for (var seed = 0; seed < 100; seed++) {
      final used = perWindow(
        WindowPlan.dates((
          start: cq.start,
          deadline: cq.deadline,
          seed: seed,
          fillAll: false,
        ), 10)!,
      ).keys.toList();
      expect(
        used,
        [for (final w in order.take(used.length)) (w.year, w.month)],
      );
    }
  });

  test('mostly two or three a window, sometimes four', () {
    final sizes = <int, int>{};
    for (var seed = 0; seed < 400; seed++) {
      for (final n in perWindow(
        WindowPlan.dates((
          start: cq.start,
          deadline: cq.deadline,
          seed: seed,
          fillAll: false,
        ), 10)!,
      ).values) {
        sizes.update(n, (v) => v + 1, ifAbsent: () => 1);
      }
    }
    expect(sizes[2]! + sizes[3]!, greaterThan(sizes[4]! * 3));
    expect(sizes[4], greaterThan(0), reason: 'four does happen');
  });

  test('the same save draws the same windows', () {
    expect(WindowPlan.dates(cq, 10), WindowPlan.dates(cq, 10));
  });

  test('a campaign that must fill its span plays every window', () {
    // South America: eighteen matchdays, March to the next March.
    final sa = span(DateTime(2029, 3), DateTime(2030, 3, 31), fillAll: true);
    for (var seed = 0; seed < 50; seed++) {
      final dates = WindowPlan.dates((
        start: sa.start,
        deadline: sa.deadline,
        seed: seed,
        fillAll: true,
      ), 18)!;
      expect(perWindow(dates).keys, hasLength(6));
      expect(dates.last.year, 2030);
      expect(dates.last.month, 3);
    }
  });

  test('a campaign that cannot fit gets no plan', () {
    // Ten matchdays in one autumn of two windows: at most eight.
    expect(
      WindowPlan.dates(span(DateTime(2028, 9), DateTime(2028, 10, 31)), 10),
      isNull,
    );
  });

  test('the draw is the same with or without fluid windows', () {
    final nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List)
            .map((e) => Nation.fromJson(e as Map<String, Object?>))
            .where((n) => n.confederation == Confederation.europe)
            .toList();
    const gen = ScheduleGenerator();
    final legacy = gen.generate(
      confederation: Confederation.europe,
      nations: nations,
      rngSeed: 42,
      start: DateTime(2026, 9),
      groupSize: 6,
    );
    final fluid = gen.generate(
      confederation: Confederation.europe,
      nations: nations,
      rngSeed: 42,
      start: DateTime(2026, 9),
      groupSize: 6,
      windows: cq,
    );
    expect(
      [for (final g in fluid.groups) g.nationIds],
      [for (final g in legacy.groups) g.nationIds],
    );
    // The pairings by matchday too: only the dates move.
    String pairings(GeneratedSchedule s) => [
      for (final g in s.groups)
        for (final f in g.fixtures)
          '${f.matchday}:${f.homeNationId}-${f.awayNationId}',
    ].join(',');
    expect(pairings(fluid), pairings(legacy));
  });
}
