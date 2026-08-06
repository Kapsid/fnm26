import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';

import '../../helpers/fixtures.dart';

void main() {
  _retirementVariance();
  // A plausible seeded nation: a spread of ages so some age out over cycles.
  final seeded = [
    for (var i = 0; i < 23; i++)
      player(
        id: 100 + i,
        nationId: 1,
        name: 'First$i Last$i',
        position: PlayerPosition.values[i % PlayerPosition.values.length],
        age: 20 + (i % 15), // 20 … 34
        attributes: flatAttributes(70),
      ),
  ];

  test('career starts develop a player (capped) and none leaves them as-is', () {
    final base = PlayerLifecycle.poolAt(seeded, 1, 0);
    final target = base.first;
    // With many starts, the same player's overall is a touch higher — but
    // capped, so it can't run away.
    final developed = PlayerLifecycle.poolAt(
      seeded,
      1,
      0,
      careerStartsByPlayer: {target.id: 40},
    ).firstWhere((p) => p.id == target.id);
    expect(developed.overall, greaterThan(target.overall));
    expect(developed.overall - target.overall, lessThanOrEqualTo(3));
    // No starts → identical to the undeveloped pool.
    final none = PlayerLifecycle.poolAt(seeded, 1, 0)
        .firstWhere((p) => p.id == target.id);
    expect(none.overall, target.overall);
  });

  group('annual intake at eleven', () {
    List<Player> youth(int years) =>
        PlayerLifecycle.poolAt(seeded, 1, years, minAge: 0);

    test('every level is populated on the first day of a save', () {
      // The backfill: nobody may appear mid-career, so ages 11 through 17 have
      // to already exist at aging year 0, sitting directly under the youngest
      // seeded player (18).
      final byAge = <int, int>{};
      for (final p in youth(0)) {
        byAge[p.age] = (byAge[p.age] ?? 0) + 1;
      }
      for (var age = 11; age <= 17; age++) {
        expect(byAge[age] ?? 0, greaterThan(0), reason: 'nobody aged $age');
      }
    });

    test('an intake is seven boys, all eleven', () {
      final eleven = youth(0).where((p) => p.age == 11).toList();
      expect(eleven, hasLength(PlayerLifecycle.intakePerYear));
    });

    test('a fresh intake arrives every year, not every fourth', () {
      for (var year = 1; year <= 4; year++) {
        final eleven = youth(year).where((p) => p.age == 11).toList();
        expect(eleven, hasLength(PlayerLifecycle.intakePerYear),
            reason: 'no intake in year $year');
      }
    });

    test('about a fifth are released before seventeen', () {
      var released = 0;
      const sample = 4000;
      for (var id = 1; id <= sample; id++) {
        if (PlayerLifecycle.releasedAgeFor(id) != null) released++;
      }
      final pct = released / sample * 100;
      expect(pct, greaterThan(15));
      expect(pct, lessThan(27));
    });

    test('a released boy is released between twelve and sixteen', () {
      for (var id = 1; id <= 4000; id++) {
        final age = PlayerLifecycle.releasedAgeFor(id);
        if (age == null) continue;
        expect(age, greaterThanOrEqualTo(12));
        expect(age, lessThanOrEqualTo(16));
      }
    });

    test('a released boy never comes back', () {
      // Find a newgen who is released, then prove he is absent from every
      // later year rather than reappearing.
      final all = youth(0);
      final doomed = all.firstWhere(
        (p) =>
            PlayerLifecycle.isNewgenId(p.id) &&
            PlayerLifecycle.releasedAgeFor(p.id) != null,
      );
      final releaseAge = PlayerLifecycle.releasedAgeFor(doomed.id)!;
      for (var year = 0; year <= 20; year++) {
        final present = youth(year).any((p) => p.id == doomed.id);
        final ageThen = doomed.age + year;
        expect(present, ageThen < releaseAge,
            reason: 'at age $ageThen (release $releaseAge)');
      }
    });

    test('the senior pool stays the size it has always been', () {
      // The equilibrium this whole intake is sized against: seven a year at
      // 79% survival is the 5.5 a year the old 22-per-four-years produced.
      // Asked for from seventeen up, which is the pool the old batch fed —
      // the schoolboys beneath it are new and would otherwise be counted as
      // growth that never happened.
      for (final year in [20, 40, 80]) {
        final seniors =
            PlayerLifecycle.poolAt(seeded, 1, year, minAge: 17).length;
        expect(seniors, greaterThan(105), reason: 'year $year');
        expect(seniors, lessThan(150), reason: 'year $year');
      }
    });

    test('two saves at the same year see the same pyramid', () {
      final a = youth(9)..sort((x, y) => x.id.compareTo(y.id));
      final b = youth(9)..sort((x, y) => x.id.compareTo(y.id));
      expect([for (final p in a) '${p.id}:${p.name}:${p.overall}'],
          [for (final p in b) '${p.id}:${p.name}:${p.overall}']);
    });
  });

  test('veterans retire once they pass the retirement age', () {
    // Seed one 36-year-old; after four years they are 40 and gone.
    final vets = [
      player(id: 900, nationId: 1, name: 'Old Timer', age: 36),
      ...seeded,
    ];
    final now = PlayerLifecycle.poolAt(vets, 1, 4);
    expect(now.any((p) => p.id == 900), isFalse);
  });

  test('deterministic: same inputs produce identical newgens', () {
    final a = PlayerLifecycle.poolAt(seeded, 1, 8);
    final b = PlayerLifecycle.poolAt(seeded, 1, 8);
    expect(
      a.map((p) => '${p.id}:${p.name}:${p.overall}'),
      b.map((p) => '${p.id}:${p.name}:${p.overall}'),
    );
  });

  test('newgenById round-trips a generated player', () {
    final pool = PlayerLifecycle.poolAt(seeded, 1, 8);
    final ng = pool.firstWhere((p) => PlayerLifecycle.isNewgenId(p.id));
    final byId = PlayerLifecycle.newgenById(seeded, ng.id, 8);
    expect(byId, isNotNull);
    expect(byId!.id, ng.id);
    expect(byId.name, ng.name);
    expect(byId.age, ng.age);
    expect(PlayerLifecycle.nationIdOf(ng.id), 1);
  });

  test('newgenById returns null for a seeded id', () {
    expect(PlayerLifecycle.newgenById(seeded, 100, 12), isNull);
  });
}

void _retirementVariance() {
  group('retirement age varies by player', () {
    test('every career ends within the allowed spread', () {
      for (var id = 1; id < 5000; id++) {
        expect(
          PlayerLifecycle.retirementAgeFor(id),
          inInclusiveRange(
            PlayerLifecycle.retirementAge - PlayerLifecycle.retirementSpread,
            PlayerLifecycle.retirementAge + PlayerLifecycle.retirementSpread,
          ),
        );
      }
    });

    test('it is stable for a given player', () {
      for (var id = 1; id < 200; id++) {
        expect(
          PlayerLifecycle.retirementAgeFor(id),
          PlayerLifecycle.retirementAgeFor(id),
        );
      }
    });

    test('careers really do end at different ages', () {
      final ages = {
        for (var id = 1; id < 2000; id++) PlayerLifecycle.retirementAgeFor(id),
      };
      expect(ages.length, greaterThan(4), reason: 'not one hard cut-off');
    });

    test('the spread stays centred, so pool turnover stays balanced', () {
      var total = 0;
      const n = 20000;
      for (var id = 1; id <= n; id++) {
        total += PlayerLifecycle.retirementAgeFor(id);
      }
      final mean = total / n;
      expect(mean, closeTo(PlayerLifecycle.retirementAge.toDouble(), 0.3));
    });
  });
}
