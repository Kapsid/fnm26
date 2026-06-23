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
    final group = schedule.groups.single; // 6 nations, target 5 -> 1 group
    expect(group.fixtures.length, 6 * 5);
  });

  test('fixtures start in the September 2026 window', () {
    final schedule = generator.generate(
      confederation: Confederation.europe,
      nations: europe,
      rngSeed: 42,
      start: DateTime(2026, 9),
    );
    final firstDate = schedule.groups.single.fixtures
        .map((f) => f.date)
        .reduce((a, b) => a.isBefore(b) ? a : b);
    expect(firstDate.year, 2026);
    expect(firstDate.month, 9);
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
