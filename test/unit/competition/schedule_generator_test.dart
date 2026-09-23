import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/competition/schedule_generator.dart';

import '../../helpers/fixtures.dart';

void main() {
  const generator = ScheduleGenerator();

  final europe = [
    for (var i = 1; i <= 6; i++) nation(id: i, ranking: i),
  ];

  test('draws every nation into a group exactly once', () {
    final schedule = generator.generate(
      confederation: Confederation.europe,
      nations: europe,
      rngSeed: 42,
    );

    final drawn = schedule.groups.expand((g) => g.nationIds).toList();
    expect(drawn.toSet(), {1, 2, 3, 4, 5, 6});
    expect(drawn.length, 6); // no duplicates
  });

  test('double round-robin fixtures (n*(n-1) per group)', () {
    final schedule = generator.generate(
      confederation: Confederation.europe,
      nations: europe,
      rngSeed: 42,
    );
    for (final group in schedule.groups) {
      final n = group.nationIds.length;
      expect(group.fixtures.length, n * (n - 1));
    }
  });

  test('no group exceeds the confederation target size', () {
    // The target is a ceiling: an overfilled group runs extra matchdays and
    // spills the competition out of its window (see _matchdayDates).
    for (final (confederation, size) in [
      (Confederation.europe, 5),
      (Confederation.africa, 6),
      (Confederation.southAmerica, 10),
    ]) {
      final schedule = generator.generate(
        confederation: confederation,
        nations: [for (var i = 1; i <= 13; i++) nation(id: i, ranking: i)],
        rngSeed: 42,
      );
      for (final group in schedule.groups) {
        expect(group.nationIds.length, lessThanOrEqualTo(size));
      }
    }
  });

  test('fixtures start in the September 2026 window', () {
    final schedule = generator.generate(
      confederation: Confederation.europe,
      nations: europe,
      rngSeed: 42,
      start: DateTime(2026, 9),
    );
    final firstDate = schedule.groups
        .expand((g) => g.fixtures)
        .map((f) => f.date)
        .reduce((a, b) => a.isBefore(b) ? a : b);
    expect(firstDate.year, 2026);
    expect(firstDate.month, 9);
  });

  test('a spring start really begins in spring, not the season opener', () {
    // Regression: _matchdayDates used to ignore start.month and always open at
    // the September window, which pushed World Cup qualifying nine months late
    // and past its own finals.
    final schedule = generator.generate(
      confederation: Confederation.europe,
      nations: europe,
      rngSeed: 42,
      start: DateTime(2029, 3),
    );
    final firstDate = schedule.groups
        .expand((g) => g.fixtures)
        .map((f) => f.date)
        .reduce((a, b) => a.isBefore(b) ? a : b);
    expect(firstDate.year, 2029);
    expect(firstDate.month, 3);
  });

  test('seeding follows the supplied current ranking', () {
    final teams = [for (var i = 1; i <= 12; i++) nation(id: i, ranking: i)];
    String groupsOf(Map<int, int>? rank) => generator
        .generate(
          confederation: Confederation.europe,
          nations: teams,
          rngSeed: 7,
          rankById: rank,
        )
        .groups
        .map((g) => ([...g.nationIds]..sort()).toString())
        .toString();

    // Reversing the current ranking changes who is a top seed, so the draw
    // must come out differently than seeding by the static ranking.
    final reversed = {for (var i = 1; i <= 12; i++) i: 13 - i};
    expect(groupsOf(reversed), isNot(groupsOf(null)));
    // Still deterministic given the same ranking.
    expect(groupsOf(reversed), groupsOf(reversed));
  });

  test('deterministic for a given seed', () {
    String draw(int seed) => generator
        .generate(
          confederation: Confederation.europe,
          nations: europe,
          rngSeed: seed,
        )
        .groups
        .map((g) => g.nationIds)
        .toString();

    expect(draw(99), draw(99));
  });
}
