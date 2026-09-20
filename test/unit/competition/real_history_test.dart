import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/competition/real_history.dart';

int _lastYearOf(String competition) => RealHistory.editions
    .where((e) => e.competition == competition)
    .map((e) => e.year)
    .reduce((a, b) => a > b ? a : b);

void main() {
  test('the North America Cup record runs to the present', () {
    expect(
      _lastYearOf(RealHistory.northAmericaCup),
      greaterThanOrEqualTo(2025),
    );
  });

  test('the North America Cup runs biennially in odd years', () {
    final years =
        RealHistory.editions
            .where((e) => e.competition == RealHistory.northAmericaCup)
            .map((e) => e.year)
            .toList()
          ..sort();
    // A gap at 2024 is the tournament's cadence, not missing data.
    for (final y in years) {
      expect(y.isOdd, isTrue, reason: '$y is not an odd year');
    }
    for (var i = 1; i < years.length; i++) {
      expect(years[i] - years[i - 1], 2);
    }
  });

  test('every edition names a champion and a runner-up', () {
    for (final e in RealHistory.editions) {
      expect(e.champion, isNotEmpty, reason: '${e.competition} ${e.year}');
      expect(e.runnerUp, isNotEmpty, reason: '${e.competition} ${e.year}');
    }
  });

  test('the 2026 World Championship is in the seeded history, with its '
      'hosts', () {
    final editions = RealHistory.editions.where(
      (e) => e.year == 2026 && e.competition == RealHistory.worldChampionship,
    );
    expect(editions, hasLength(1));
    expect(editions.single.hosts, hasLength(3));
  });

  test('every other edition carries exactly one host', () {
    for (final e in RealHistory.editions.where((e) => e.year != 2026)) {
      expect(e.hosts, hasLength(1), reason: '${e.competition} ${e.year}');
    }
  });

  test(
    'the 2026 World Championship hosts resolve to real nations',
    () {
      // Cheap stand-in for the seeder's own resolution: it keys nations by
      // englishName (falling back to name), and every nation loaded straight
      // from the asset has an empty englishName, so the asset's `name` field
      // is what a host string must match here — through an alias if one
      // applies, exactly as `_seedHistory` does.
      final nations =
          (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                  as List<dynamic>)
              .map((e) => (e as Map<String, dynamic>)['name'] as String)
              .toSet();

      final hosts = RealHistory.editions
          .singleWhere(
            (e) =>
                e.year == 2026 &&
                e.competition == RealHistory.worldChampionship,
          )
          .hosts;

      for (final host in hosts) {
        final resolved = RealHistory.aliases[host] ?? host;
        expect(
          nations.contains(resolved),
          isTrue,
          reason:
              '"$host" (resolved: "$resolved") does not match any nation '
              'name in assets/data/nations.json',
        );
      }
    },
  );
}
