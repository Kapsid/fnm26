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

  _weakNationIsNotInflated();

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

  group('who the senior pool contains', () {
    test('by default it starts at seventeen', () {
      final pool = PlayerLifecycle.poolAt(seeded, 1, 5);
      expect(pool, isNotEmpty);
      expect(pool.every((p) => p.age >= 17), isTrue);
    });

    test('the call-up path can ask for fifteen', () {
      final pool = PlayerLifecycle.poolAt(seeded, 1, 5, minAge: 15);
      expect(pool.any((p) => p.age == 15 || p.age == 16), isTrue);
    });

    test('the youth pool populates every band from U-13 to U-21', () {
      final youth = PlayerLifecycle.youthPoolAt(seeded, 1, 5);
      expect(youth, isNotEmpty);
      for (final level in YouthLevel.values) {
        expect(
          youth.any((p) => p.age >= level.minAge && p.age <= level.maxAge),
          isTrue,
          reason: '${level.label} has nobody in it',
        );
      }
    });

    test(
        'the best sixteen-year-old is still well below the squad-boundary '
        'senior', () {
      // The intent: naming a fifteen- or sixteen-year-old must cost you
      // results, so it stays a rare, deliberate gamble rather than a free
      // upgrade. The senior a teenager actually displaces is the one at the
      // SQUAD BOUNDARY — roughly the 23rd-best player, the last man into a
      // squad — not some arbitrary fringe veteran three-quarters of the way
      // down the pool. And the player who could threaten that boundary is
      // the BEST available sixteen-year-old, not a middling one: if even he
      // falls well short, naming a lesser one is that much more obviously a
      // mistake.
      final seniors = PlayerLifecycle.poolAt(seeded, 1, 12)
        ..sort((a, b) => b.overall.compareTo(a.overall));
      // The 23rd-best (index 22) is the last man into a standard squad.
      expect(seniors.length, greaterThan(22),
          reason: 'senior pool too small to have a squad boundary');
      final boundarySenior = seniors[22];
      final sixteens = PlayerLifecycle.youthPoolAt(seeded, 1, 12)
          .where((p) => p.age == 16)
          .toList()
        ..sort((a, b) => b.overall.compareTo(a.overall));
      expect(sixteens, isNotEmpty);
      final bestSixteen = sixteens.first;
      expect(
        boundarySenior.overall - bestSixteen.overall,
        greaterThanOrEqualTo(12),
      );
    });
  });

  group('club minutes and development', () {
    test('a seed of zero leaves development exactly as it was', () {
      // Every existing caller passes no seed; none of them may move.
      final without = PlayerLifecycle.poolAt(seeded, 1, 8,
          careerStartsByPlayer: {for (final p in seeded) p.id: 9});
      final explicit = PlayerLifecycle.poolAt(seeded, 1, 8,
          clubSeed: 0, careerStartsByPlayer: {for (final p in seeded) p.id: 9});
      expect(
        [for (final p in explicit) p.overall],
        [for (final p in without) p.overall],
      );
    });

    test('the minutes factor moves a well-used player', () {
      final base = PlayerLifecycle.withCareerDev(seeded.first, 16);
      final starved =
          PlayerLifecycle.withCareerDev(seeded.first, 16, minutesFactor: 0.6);
      final feasted =
          PlayerLifecycle.withCareerDev(seeded.first, 16, minutesFactor: 1.4);
      expect(starved.overall, lessThanOrEqualTo(base.overall));
      expect(feasted.overall, greaterThanOrEqualTo(base.overall));
    });

    test('a real club seed does not shift the pool as a whole', () {
      // The equilibrium guard at the pool level: individuals move, the world
      // does not.
      double meanOverall(int seed) {
        final pool = PlayerLifecycle.poolAt(seeded, 1, 20,
            clubSeed: seed,
            careerStartsByPlayer: {for (final p in seeded) p.id: 12});
        return pool.map((p) => p.overall).reduce((a, b) => a + b) /
            pool.length;
      }

      expect(meanOverall(7777), closeTo(meanOverall(0), 0.6));
    });
  });
}

/// The reconstruction that turns a seventeen-year-old draw into an
/// eleven-year-old has to be faithful at the BOTTOM of the range, not just the
/// middle — and a poor nation lives at the bottom.
void _weakNationIsNotInflated() {
  group('a weak nation is not inflated by the reconstruction', () {
    // A nation whose players average 45. The intake is drawn at 0.56–0.94 of
    // the nation's own top-thirty average, so its weakest boys come out around
    // 45 × 0.56 − 4 ≈ 21, and the youth discount at seventeen (−9) puts them
    // on the display floor of 20. A flat-70 nation never gets near it, which is
    // why the pool-size test above cannot see this.
    final weak = [
      for (var i = 0; i < 23; i++)
        player(
          id: 100 + i,
          nationId: 1,
          name: 'First$i Last$i',
          position: PlayerPosition.values[i % PlayerPosition.values.length],
          age: 20 + (i % 15),
          attributes: flatAttributes(45),
        ),
    ];

    test('its seventeen-year-olds still reach the display floor', () {
      // A boy is generated as his seventeen-year-old draw minus six years of
      // growth (−14 physical/stamina, −12 technical), which the sub-17 curve
      // then gives back. If that subtraction is floored at 20 — the bound every
      // DISPLAYED attribute is clamped to — then every draw below 34 is
      // truncated and the curve grows those boys back to MORE than they were
      // drawn as. The low tail is what disappears first: under truncation the
      // weakest seventeen-year-old attribute a nation this poor can produce is
      // 23, and not one of its boys reaches the floor. Faithful, about a
      // quarter of them do.
      final attrs = <int>[];
      for (var year = 0; year <= 20; year++) {
        for (final p in PlayerLifecycle.poolAt(weak, 1, year)) {
          if (p.age != 17 || !PlayerLifecycle.isNewgenId(p.id)) continue;
          attrs.addAll([
            p.attributes.physical,
            p.attributes.technical,
            p.attributes.stamina,
          ]);
        }
      }
      expect(attrs, isNotEmpty);
      expect(attrs.reduce((a, b) => a < b ? a : b), 20);
      final atFloor = attrs.where((v) => v <= 20).length / attrs.length;
      expect(atFloor, greaterThan(0.10), reason: 'the low tail was truncated');
    });
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
