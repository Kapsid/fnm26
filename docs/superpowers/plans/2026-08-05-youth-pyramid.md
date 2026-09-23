# Youth Pyramid (U-13 → U-21) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Every nation gets five youth levels (U-13 … U-21) a manager can watch players grow through, with players entering the world at 11 instead of materialising at 16–19.

**Architecture:** Everything stays *derived, never stored*. `PlayerLifecycle` swaps its four-year batch of 22 sixteen-to-nineteen-year-olds for an annual intake of 7 eleven-year-olds, with the years before the save backfilled so every level is populated on day one and ~21% released before 17. `PlayerAging` gains sub-17 curve bands so a child is rated like a child. `poolAt` gains a `minAge` (default 17) so the world sim and every existing caller are untouched; a new `youthPoolAt` builds ages 11–20 for one nation on demand, for the new `YouthScreen`.

**Tech Stack:** Dart / Flutter, Riverpod (no codegen), Drift, `flutter gen-l10n` for EN+CS strings.

## Global Constraints

- **Riverpod without codegen** — never add `@riverpod`; it conflicts with `drift_dev`. Declare providers explicitly with their full type, as every existing provider does.
- **Nothing is persisted.** No new Drift tables, no new columns. The pyramid is derived from `(nationId, agingYears)` and the player id alone.
- **Determinism is a hard requirement.** Two saves at the same aging year must produce identical pyramids. Never use the save seed inside intake generation; never use `Random()` without a seed.
- **Line length 80 characters** (`lines_longer_than_80_chars` is enforced as an info lint across the repo — match the surrounding style).
- **All new user-facing strings go in BOTH `lib/l10n/app_en.arb` and `lib/l10n/app_cs.arb`**, then `flutter gen-l10n`. EN entries need an `@key` description block; CS entries do not.
- **Age bands are strict under-N:** U-13 = 11–12, U-15 = 13–14, U-17 = 15–16, U-19 = 17–18, U-21 = 19–20.
- **Verification commands:** `flutter analyze lib test` must report no `error •` or `warning •` lines. `flutter test test/unit` must end `All tests passed!`.
- **Known pre-existing flake:** `test/unit/hub/season_service_exclusive_test.dart` "two advances in one frame" fails under full-suite parallel load and passes in isolation. It is not yours. Do not chase it.

---

### Task 1: The `YouthLevel` enum

**Files:**
- Modify: `lib/domain/entities/enums.dart` (append at end of file)
- Test: `test/unit/domain/youth_level_test.dart` (create)

**Interfaces:**
- Consumes: nothing.
- Produces: `enum YouthLevel { u13, u15, u17, u19, u21 }` with instance fields
  `int minAge`, `int maxAge`; getters `bool callable`, `String label`; and
  `static YouthLevel? forAge(int age)` returning `null` for 21 and over and for
  ages below 11.

- [ ] **Step 1: Write the failing test**

Create `test/unit/domain/youth_level_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';

void main() {
  group('YouthLevel.forAge', () {
    test('bands are strict under-N', () {
      expect(YouthLevel.forAge(11), YouthLevel.u13);
      expect(YouthLevel.forAge(12), YouthLevel.u13);
      expect(YouthLevel.forAge(13), YouthLevel.u15);
      expect(YouthLevel.forAge(14), YouthLevel.u15);
      expect(YouthLevel.forAge(15), YouthLevel.u17);
      expect(YouthLevel.forAge(16), YouthLevel.u17);
      expect(YouthLevel.forAge(17), YouthLevel.u19);
      expect(YouthLevel.forAge(18), YouthLevel.u19);
      expect(YouthLevel.forAge(19), YouthLevel.u21);
      expect(YouthLevel.forAge(20), YouthLevel.u21);
    });

    test('twenty-one and over is nobody\'s youth level', () {
      expect(YouthLevel.forAge(21), isNull);
      expect(YouthLevel.forAge(30), isNull);
    });

    test('below the intake age there is nobody', () {
      expect(YouthLevel.forAge(10), isNull);
    });

    test('every level covers exactly two years, and they do not overlap', () {
      final covered = <int>[];
      for (final level in YouthLevel.values) {
        expect(level.maxAge - level.minAge, 1);
        for (var age = level.minAge; age <= level.maxAge; age++) {
          covered.add(age);
        }
      }
      expect(covered, covered.toSet().toList());
      expect(covered.length, YouthLevel.values.length * 2);
    });

    test('U-17 and up can be capped, below cannot', () {
      expect(YouthLevel.u13.callable, isFalse);
      expect(YouthLevel.u15.callable, isFalse);
      expect(YouthLevel.u17.callable, isTrue);
      expect(YouthLevel.u19.callable, isTrue);
      expect(YouthLevel.u21.callable, isTrue);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/unit/domain/youth_level_test.dart`
Expected: FAIL — compilation error, "Undefined name 'YouthLevel'".

- [ ] **Step 3: Write minimal implementation**

Append to `lib/domain/entities/enums.dart`:

```dart
/// A nation's youth levels, strict under-N: a player is in [YouthLevel.u17]
/// while he is *under* seventeen, so "rarely cap a sub-17" reads directly as
/// "rarely cap from U-17".
///
/// Not persisted — a player's level is a function of his age, recomputed
/// wherever it is needed.
enum YouthLevel {
  /// 11–12.
  u13(11, 12),

  /// 13–14.
  u15(13, 14),

  /// 15–16.
  u17(15, 16),

  /// 17–18.
  u19(17, 18),

  /// 19–20.
  u21(19, 20);

  const YouthLevel(this.minAge, this.maxAge);

  /// The youngest and oldest age in this band, inclusive.
  final int minAge;
  final int maxAge;

  /// Whether players at this level appear in the senior call-up list. Under-15s
  /// are watched, not picked.
  bool get callable => minAge >= 15;

  /// Display label, e.g. `U-17`.
  String get label => 'U-${maxAge + 1}';

  /// The level [age] belongs to, or null once a player is 21 (and so simply a
  /// senior) or younger than the intake age.
  static YouthLevel? forAge(int age) {
    for (final level in values) {
      if (age >= level.minAge && age <= level.maxAge) return level;
    }
    return null;
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/unit/domain/youth_level_test.dart`
Expected: PASS, 5 tests.

- [ ] **Step 5: Commit**

```bash
git add lib/domain/entities/enums.dart test/unit/domain/youth_level_test.dart
git commit -m "feat: add YouthLevel age bands"
```

---

### Task 2: Sub-17 rating curve

**Files:**
- Modify: `lib/domain/services/player/player_aging.dart` (`_yearlyDelta`, `_youthDiscount`)
- Test: `test/unit/domain/player_aging_test.dart` (append a new group)

**Interfaces:**
- Consumes: nothing.
- Produces: `PlayerAging.agedYears` now rates ages 11–16 far below senior
  standard. Nothing above 18 changes — Task 4's senior guard depends on that.

**Why this task is separate:** it changes ratings for ages that do not yet exist
in the game, so it is provably inert until Task 3 creates them. Landing it alone
keeps the diff reviewable.

- [ ] **Step 1: Write the failing test**

Append inside `main()` in `test/unit/domain/player_aging_test.dart`:

```dart
  group('the sub-17 curve', () {
    Player boy(int age) => player(
          id: 4242,
          nationId: 1,
          name: 'Boy',
          position: PlayerPosition.cm,
          age: age,
          attributes: flatAttributes(70),
        );

    test('a child is rated far below the same attributes at senior age', () {
      // Same raw attributes, read at different ages: the discount is what
      // makes a twelve-year-old a twelve-year-old.
      final child = PlayerAging.agedYears(boy(12), 0);
      final senior = PlayerAging.agedYears(boy(25), 0);
      expect(senior.overall - child.overall, greaterThanOrEqualTo(20));
    });

    test('the discount eases year by year all the way up', () {
      var previous = PlayerAging.agedYears(boy(11), 0).overall;
      for (var age = 12; age <= 18; age++) {
        final current = PlayerAging.agedYears(boy(age), 0).overall;
        expect(current, greaterThanOrEqualTo(previous),
            reason: 'the discount jumped backwards at $age');
        previous = current;
      }
    });

    test('nothing above eighteen moved', () {
      // The senior world must be untouched — ages 19+ keep exactly the
      // discounts they had before this change.
      expect(PlayerAging.agedYears(boy(19), 0).overall, 70 - 6);
      expect(PlayerAging.agedYears(boy(20), 0).overall, 70 - 5);
      expect(PlayerAging.agedYears(boy(21), 0).overall, 70 - 3);
      expect(PlayerAging.agedYears(boy(22), 0).overall, 70 - 1);
      expect(PlayerAging.agedYears(boy(23), 0).overall, 70);
    });

    test('a boy grows fast and then slows down', () {
      // Eleven to seventeen must add clearly more than seventeen to twenty
      // does — childhood is where the growth is.
      final childhood = PlayerAging.agedYears(boy(11), 6).attributes.physical -
          boy(11).attributes.physical;
      final teens = PlayerAging.agedYears(boy(17), 3).attributes.physical -
          boy(17).attributes.physical;
      expect(childhood, greaterThan(teens * 2));
    });
  });
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/unit/domain/player_aging_test.dart`
Expected: FAIL — "a child is rated far below…" fails, because `_youthDiscount`
currently flatlines at −7 for every age ≤ 18, so the gap is only 7.

- [ ] **Step 3: Write minimal implementation**

In `lib/domain/services/player/player_aging.dart`, replace the `base` switch
inside `_youthDiscount`:

```dart
    final base = switch (age) {
      <= 12 => 24,
      13 => 21,
      14 => 18,
      15 => 15,
      16 => 12,
      17 => 9,
      18 => maxYouthDiscount,
      19 => 6,
      20 => 5,
      21 => 3,
      22 => 1,
      _ => 0,
    };
```

and replace `_yearlyDelta` in the same file:

```dart
  static double _yearlyDelta(int age, {required bool physical}) {
    // A child grows into an athlete far faster than a young man improves as a
    // footballer. Without these bands an eleven-year-old would arrive at
    // seventeen barely changed, and the whole point of the pyramid — watching
    // him become a player — would be a list of static numbers.
    if (age < 15) return physical ? 2.6 : 2.2;
    if (age < 17) return physical ? 1.8 : 1.5;
    if (age < 21) return physical ? 1.0 : 0.85; // early development
    if (age < 24) return physical ? 0.7 : 0.65;
    if (age < 28) return physical ? 0.15 : 0.35; // peak / experience gains
    if (age < 31) return physical ? -1.1 : 0.1; // physical starts to go
    if (age < 34) return physical ? -2.4 : -0.7;
    return physical ? -3.4 : -1.6; // veteran decline
  }
```

Also update the doc comment above `maxYouthDiscount` to say it is the *18-year-old*
markdown rather than the most a teenager is marked down:

```dart
  /// The markdown applied at eighteen. Younger players are marked down harder
  /// still — see the bands in [_youthDiscount].
  static const int maxYouthDiscount = 7;
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/unit/domain/player_aging_test.dart`
Expected: PASS — the new group plus every pre-existing aging test. If "the
youth discount it eases year by year and is gone by twenty-three" fails, the
19–23 bands were altered; they must be left exactly as they were.

- [ ] **Step 5: Commit**

```bash
git add lib/domain/services/player/player_aging.dart \
        test/unit/domain/player_aging_test.dart
git commit -m "feat: rate children like children below 17"
```

---

### Task 3: Annual intake at 11, with backfill and wash-out

**Files:**
- Modify: `lib/domain/services/player/player_lifecycle.dart`
- Test: `test/unit/domain/player_lifecycle_test.dart`

**Interfaces:**
- Consumes: `YouthLevel` (Task 1) is *not* needed here; `PlayerAging` sub-17
  bands (Task 2) are.
- Produces:
  - `static const int intakeAge = 11`
  - `static const int intakePerYear = 7`
  - `static const int backfillYears = 6`
  - `static const int releasedPercent = 21`
  - `static int? releasedAgeFor(int playerId)` — the age a boy is released, or
    null if he makes it through
  - `static bool isReleasedBy(int playerId, int age)`
  - `_intake(List<Player> seeded, int nationId, int intakeYear, {double youthBonus})`
    — note the third parameter is now an INTAKE YEAR (which may be negative),
    not a born cycle
  - `newgenSequence(int id)` keeps its name and meaning (a distinct per-nation
    sequence number for naming)
  - `poolAt` and `newgenById` keep their names; `poolAt` gains `minAge` in Task 4

**Note on the id scheme:** `bornYearIndex = intakeYear + 8`, so the backfilled
years −6…−1 stay positive. `_cycleStride` (1000) and `_nationStride`
(1 000 000) are unchanged, giving ~990 intake years of headroom and 1000 slots
per year against the 7 used.

- [ ] **Step 1: Write the failing test**

Replace the whole of `test/unit/domain/player_lifecycle_test.dart`'s newgen
group — the existing tests assert the old four-year batch and must go. Delete
these three tests by name: `'year 0 returns exactly the seeded players, unaged'`,
`'each past cycle boundary adds a fresh newgen intake'`, and
`'newgens accumulate across cycles, aged from their debut'`. Add in their place:

```dart
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
        (p) => PlayerLifecycle.releasedAgeFor(p.id) != null,
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
      for (final year in [20, 40, 80]) {
        final seniors = PlayerLifecycle.poolAt(seeded, 1, year).length;
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
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/unit/domain/player_lifecycle_test.dart`
Expected: FAIL — `minAge` is not a parameter of `poolAt`, and
`releasedAgeFor` / `intakePerYear` do not exist.

- [ ] **Step 3: Write minimal implementation**

In `lib/domain/services/player/player_lifecycle.dart`:

**3a.** Replace the `intakePerCycle` constant and its comment with:

```dart
  /// The age a player enters the world. Nobody is ever created older than this
  /// — a seventeen-year-old in this game was an eleven-year-old six years ago,
  /// and the manager could have watched him the whole way.
  static const int intakeAge = 11;

  /// Boys a nation takes in each year. Sized against the senior pool's
  /// equilibrium: seven a year at [releasedPercent] attrition is the ~5.5 a
  /// year that reach seventeen, which is exactly what the old
  /// twenty-two-per-four-years produced.
  static const int intakePerYear = 7;

  /// How many intake years before the save opens are generated, so ages 11–17
  /// are already there on day one and the ladder is continuous up to the
  /// youngest seeded player (18).
  static const int backfillYears = 6;

  /// Roughly what share of an intake is released before reaching seventeen.
  static const int releasedPercent = 21;

  /// The offset that keeps the backfilled (negative) intake years positive in
  /// the encoded id.
  static const int _bornYearOffset = 8;
```

**3b.** Add the wash-out, next to `retirementAgeFor`:

```dart
  /// The age [playerId] is released, or null if he comes through.
  ///
  /// Its own bit window, distinct from [developmentPotential] and
  /// [retirementAgeFor]: how good a boy was going to be must not decide whether
  /// he is let go, or the pyramid would quietly be a ranked queue with the
  /// bottom lopped off instead of a set of careers.
  static int? releasedAgeFor(int playerId) {
    final h = (_mix(playerId ^ 0x2E1EA5E) >> 5) & 0xffffff;
    if (h % 100 >= releasedPercent) return null;
    return 12 + (h ~/ 100) % 5; // 12 … 16
  }

  /// Whether [playerId] has already been released by [age].
  static bool isReleasedBy(int playerId, int age) {
    final at = releasedAgeFor(playerId);
    return at != null && age >= at;
  }
```

**3c.** Replace `newgenSequence`:

```dart
  /// A stable per-nation sequence number for a newgen [id] across all intake
  /// years and slots, so every generated player gets a distinct name.
  static int newgenSequence(int id) {
    final within = (id - _idBase) % _nationStride;
    final bornYearIndex = within ~/ _cycleStride;
    final slot = within % _cycleStride;
    return bornYearIndex * intakePerYear + slot;
  }
```

**3d.** Replace the newgen loop inside `poolAt`. The seeded loop above it is
unchanged. Replace from `final cyclesElapsed = agingYears ~/ 4;` through the end
of that `for` loop with:

```dart
    // Every intake year that has happened, including the ones backfilled from
    // before the save opened.
    for (var year = -backfillYears; year <= agingYears; year++) {
      final bonus = youthBonusByCycle[_cycleOfIntake(year)] ?? 0.0;
      for (final g in _intake(seeded, nationId, year, youthBonus: bonus)) {
        final aged = PlayerAging.agedYears(g, agingYears - year);
        if (isReleasedBy(aged.id, aged.age)) continue;
        if (retired(aged)) continue;
        out.add(withCareerDev(aged, careerStartsByPlayer[aged.id] ?? 0));
      }
    }
    return out;
  }

  /// The four-year cycle an intake year belongs to, for the academy bonus.
  /// Backfilled years are before the save and take no investment.
  static int _cycleOfIntake(int intakeYear) =>
      intakeYear < 0 ? -1 : intakeYear ~/ 4;
```

**3e.** Replace the decode block in `newgenById` — from `final rem = id - _idBase;`
down to (and including) the `if (born < 1 || debutYears > agingYears) return null;`
line — with:

```dart
    final rem = id - _idBase;
    final bornYearIndex = (rem % _nationStride) ~/ _cycleStride;
    final intakeYear = bornYearIndex - _bornYearOffset;
    if (intakeYear < -backfillYears || intakeYear > agingYears) return null;
```

and update the two uses below it: the bonus lookup becomes
`youthBonusByCycle[_cycleOfIntake(intakeYear)] ?? 0.0`, the `_intake` call
passes `intakeYear`, and the aging call becomes
`PlayerAging.agedYears(g, agingYears - intakeYear)`. Delete the now-unused
`debutYears` and `born` locals.

**3f.** Rewrite `_intake`'s signature, id, age and attributes. Keep the name,
club and depth-chart logic exactly as it is; change only these parts:

```dart
  static List<Player> _intake(
    List<Player> seeded,
    int nationId,
    int intakeYear, {
    double youthBonus = 0,
  }) {
    if (seeded.isEmpty) return const [];
    final rng = SeededRng(
      (nationId * 0x9E3779B1) ^ (intakeYear * 0x85EBCA77) ^ 0x2545F491,
    );
```

the depth chart call becomes:

```dart
    final positions = DepthChart.forNation(
      nationId: nationId,
      count: intakePerYear,
      salt: intakeYear,
    );
```

and the generation loop becomes:

```dart
    final bornYearIndex = intakeYear + _bornYearOffset;
    final out = <Player>[];
    for (var i = 0; i < intakePerYear; i++) {
      final pos = positions[i];
      final talent =
          (0.56 + rng.nextDouble() * 0.38 + youthBonus).clamp(0.40, 1.05);
      // `talent` describes the player he will be at SEVENTEEN — the same
      // number the old intake used, so the senior world is unchanged. What is
      // generated here is that player minus the growing-up he has yet to do,
      // which the sub-17 curve then gives back over six years.
      out.add(
        Player(
          id: _idBase +
              nationId * _nationStride +
              bornYearIndex * _cycleStride +
              i,
          nationId: nationId,
          name: '${firsts[rng.nextInt(firsts.length)]} '
              '${lasts[rng.nextInt(lasts.length)]}',
          age: intakeAge,
          position: pos,
          attributes: _asChild(_scale(avg, talent, rng)),
          club: clubs[rng.nextInt(clubs.length)],
        ),
      );
    }
    return out;
  }

  /// What a seventeen-year-old's attributes looked like when he was eleven.
  ///
  /// The mirror of the sub-17 bands in [PlayerAging]: four years at +2.6/+2.2
  /// and two at +1.8/+1.5. Subtracting them here and adding them back through
  /// the curve is what keeps the senior pool exactly where it was while giving
  /// the youth levels six years of visible growth.
  static PlayerAttributes _asChild(PlayerAttributes a) => PlayerAttributes(
        physical: (a.physical - 14).clamp(20, 95),
        technical: (a.technical - 12).clamp(20, 95),
        stamina: (a.stamina - 14).clamp(20, 95),
      );
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/unit/domain/player_lifecycle_test.dart`
Expected: PASS. `minAge` does not exist yet, so temporarily the two tests using
`minAge:` will not compile — add `int minAge = 0` as a parameter of `poolAt`
now (Task 4 changes the default to 17 and wires it through), filtering with
`if (aged.age < minAge) continue;` in BOTH the seeded loop and the intake loop.

- [ ] **Step 5: Verify the whole suite still passes**

Run: `flutter test test/unit` — expect `All tests passed!`.
`test/unit/data/player_repository_test.dart` and `pool_generator_test.dart` both
touch newgens; if either fails on a hard-coded count of 22, update it to
`PlayerLifecycle.intakePerYear` and re-run.

- [ ] **Step 6: Commit**

```bash
git add lib/domain/services/player/player_lifecycle.dart \
        test/unit/domain/player_lifecycle_test.dart
git commit -m "feat: annual intake at eleven, backfilled, with wash-out"
```

---

### Task 4: `minAge` default and `youthPoolAt`

**Files:**
- Modify: `lib/domain/services/player/player_lifecycle.dart`
- Modify: `lib/domain/repositories/player_repository.dart`
- Modify: `lib/data/repositories/drift_player_repository.dart`
- Test: `test/unit/domain/player_lifecycle_test.dart`

**Interfaces:**
- Consumes: Task 3's `poolAt(..., {int minAge})`.
- Produces:
  - `poolAt`'s `minAge` now **defaults to 17**
  - `static List<Player> youthPoolAt(List<Player> seeded, int nationId, int agingYears, {Map<int, double> youthBonusByCycle, Map<int, int> careerStartsByPlayer})`
    returning ages 11–20
  - `PlayerRepository.byNation(..., {int minAge})` and
    `PlayerRepository.youthByNation(int nationId, {int agingYears, int saveSeed, Map<int, double> youthBonusByCycle, Map<int, int> careerStartsByPlayer})`

- [ ] **Step 1: Write the failing test**

Append inside `main()` in `test/unit/domain/player_lifecycle_test.dart`:

```dart
  group('who the senior pool contains', () {
    test('by default it starts at seventeen', () {
      final pool = PlayerLifecycle.poolAt(seeded, 1, 5);
      expect(pool.every((p) => p.age >= 17), isTrue);
    });

    test('the call-up path can ask for fifteen', () {
      final pool = PlayerLifecycle.poolAt(seeded, 1, 5, minAge: 15);
      expect(pool.any((p) => p.age == 15 || p.age == 16), isTrue);
    });

    test('the youth pool is the five levels and nothing else', () {
      final youth = PlayerLifecycle.youthPoolAt(seeded, 1, 5);
      expect(youth, isNotEmpty);
      expect(youth.every((p) => p.age >= 11 && p.age <= 20), isTrue);
    });

    test('a sixteen-year-old is far below the weakest senior', () {
      // The balance guard, and the whole reason capping one is rare.
      final seniors = PlayerLifecycle.poolAt(seeded, 1, 12)
        ..sort((a, b) => a.overall.compareTo(b.overall));
      final sixteens = PlayerLifecycle.youthPoolAt(seeded, 1, 12)
          .where((p) => p.age == 16)
          .toList()
        ..sort((a, b) => a.overall.compareTo(b.overall));
      expect(sixteens, isNotEmpty);
      final medianSixteen = sixteens[sixteens.length ~/ 2].overall;
      expect(seniors.first.overall - medianSixteen, greaterThanOrEqualTo(12));
    });
  });
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/unit/domain/player_lifecycle_test.dart`
Expected: FAIL — "by default it starts at seventeen" fails (default is still 0),
and `youthPoolAt` is undefined.

- [ ] **Step 3: Write minimal implementation**

In `player_lifecycle.dart`, change the parameter default to `int minAge = 17`
and document it:

```dart
  /// The youngest age the pool contains. Seventeen by default, which is what
  /// the world simulation, AI squad selection, the rankings and every existing
  /// caller want: the U-17 band is ~13 extra players per nation, aged
  /// year-by-year on every sim step, for players who would essentially never be
  /// picked. Only the player's own call-up path asks for 15.
```

then add, directly below `poolAt`:

```dart
  /// A nation's whole youth pyramid — ages 11 to 20 — for one nation, on
  /// demand. The Youth screen is the only caller; the hot path never builds
  /// this.
  static List<Player> youthPoolAt(
    List<Player> seeded,
    int nationId,
    int agingYears, {
    Map<int, double> youthBonusByCycle = const {},
    Map<int, int> careerStartsByPlayer = const {},
  }) =>
      poolAt(
        seeded,
        nationId,
        agingYears,
        youthBonusByCycle: youthBonusByCycle,
        careerStartsByPlayer: careerStartsByPlayer,
        minAge: intakeAge,
      ).where((p) => p.age <= YouthLevel.u21.maxAge).toList();
```

Add `import 'package:fnm/domain/entities/enums.dart';` at the top of
`player_lifecycle.dart` if it is not already there.

In `lib/domain/repositories/player_repository.dart`, add `int minAge` to
`byNation`'s parameter list and declare the sibling:

```dart
  /// The nation's youth pyramid (ages 11–20), for the Youth screen. Never used
  /// by the simulation.
  Future<List<Player>> youthByNation(
    int nationId, {
    int agingYears,
    int saveSeed,
    Map<int, double> youthBonusByCycle,
    Map<int, int> careerStartsByPlayer,
  });
```

In `lib/data/repositories/drift_player_repository.dart`, add `int minAge = 17`
to `byNation`, pass it into the `poolAt` call, and add `youthByNation` as a copy
of `byNation` that calls `PlayerLifecycle.youthPoolAt` instead — it must apply
the same `_namerFor` and `_withClub` layering, or youth players will have blank
names and clubs.

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/unit/domain/player_lifecycle_test.dart` — expect PASS.
Then `flutter analyze lib test` — expect no errors or warnings.

- [ ] **Step 5: Verify the senior world did not move**

Run: `flutter test test/unit` — expect `All tests passed!`. This is the senior
guard: `match_engine_test`, `tournament_sim_test`, `overall_rating_test` and the
ranking tests all read the senior pool, and none of them may shift.

- [ ] **Step 6: Commit**

```bash
git add lib/domain/services/player/player_lifecycle.dart \
        lib/domain/repositories/player_repository.dart \
        lib/data/repositories/drift_player_repository.dart \
        test/unit/domain/player_lifecycle_test.dart
git commit -m "feat: senior pool starts at 17, youth pool built on demand"
```

---

### Task 5: Scouting uncertainty widens for the young

**Files:**
- Modify: `lib/domain/services/player/prospects.dart`
- Test: `test/unit/squad/prospects_test.dart`

**Interfaces:**
- Consumes: `YouthLevel` (Task 1).
- Produces: `Prospects.watchlist` unchanged in signature; `scoutedStars` gains an
  `age` parameter — `static int scoutedStars(int playerId, {int age = 20})`.
  `Prospects.maxAge` becomes 20 (was 21) to match `YouthLevel.u21.maxAge`.

- [ ] **Step 1: Write the failing test**

Append inside `main()` in `test/unit/squad/prospects_test.dart`:

```dart
  group('how well a scout can read a boy', () {
    test('a sixteen-year-old can be two stars out either way', () {
      var sawTwo = false;
      for (var id = 1; id < 3000; id++) {
        final gap =
            (Prospects.scoutedStars(id, age: 16) - Prospects.trueStars(id))
                .abs();
        expect(gap, lessThanOrEqualTo(2));
        if (gap == 2) sawTwo = true;
      }
      expect(sawTwo, isTrue, reason: 'the young read is never really wrong');
    });

    test('a nineteen-year-old is never more than one star out', () {
      for (var id = 1; id < 3000; id++) {
        final gap =
            (Prospects.scoutedStars(id, age: 19) - Prospects.trueStars(id))
                .abs();
        expect(gap, lessThanOrEqualTo(1));
      }
    });

    test('the read is stable — a scout does not change his mind', () {
      expect(Prospects.scoutedStars(77, age: 15),
          Prospects.scoutedStars(77, age: 15));
    });
  });
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/unit/squad/prospects_test.dart`
Expected: FAIL — `scoutedStars` takes no `age` argument.

- [ ] **Step 3: Write minimal implementation**

In `lib/domain/services/player/prospects.dart`:

```dart
  /// The age at which a player leaves the youth pyramid.
  static const int maxAge = 20;

  /// The scout's read on an unproven player: the truth, off by up to a star for
  /// a nineteen- or twenty-year-old and up to TWO for anyone younger.
  ///
  /// A boy of fifteen has played nothing anyone can judge him on, so the read
  /// on him is barely a read at all — which is what makes bringing him through
  /// and finding out the interesting decision.
  static int scoutedStars(int playerId, {int age = 20}) {
    final spread = age >= YouthLevel.u19.maxAge ? 1 : 2;
    final wobble = (_mix(playerId ^ 0x5CADE) % (spread * 2 + 1)) - spread;
    return (trueStars(playerId) + wobble).clamp(1, 5);
  }
```

Delete the private `_scoutedStars` and update the one call site inside
`watchlist` to `scoutedStars(p.id, age: p.age)`. Add
`import 'package:fnm/domain/entities/enums.dart';` at the top.

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/unit/squad/prospects_test.dart`
Expected: PASS. The pre-existing test `'a scout is never more than a star out'`
will now fail if it calls `scoutedStars(id)` for young players — update it to
pass `age: 19` explicitly, since that is the case it was written for.

- [ ] **Step 5: Commit**

```bash
git add lib/domain/services/player/prospects.dart \
        test/unit/squad/prospects_test.dart
git commit -m "feat: widen the scouting read below U-19"
```

---

### Task 6: Youth providers

**Files:**
- Create: `lib/features/squad/youth_providers.dart`
- Delete: `lib/features/squad/u21_providers.dart`
- Test: none (provider wiring is covered by the widget test in Task 7)

**Interfaces:**
- Consumes: `PlayerRepository.youthByNation` (Task 4), `Prospects.watchlist`
  (Task 5), `YouthLevel` (Task 1).
- Produces:
  - `typedef YouthPyramid = ({Map<YouthLevel, List<Prospect>> byLevel, Map<YouthLevel, List<String>> releasedByLevel});`
  - `final AutoDisposeFutureProviderFamily<YouthPyramid, int> youthPyramidProvider`

- [ ] **Step 1: Write the implementation**

Create `lib/features/squad/youth_providers.dart`. Model it on the deleted
`u21_providers.dart` — same `seedLoaderProvider.ensureSeeded()`, same career
lookup, same `youthBonusByCycleProvider` / `careerDevBonusProvider` inputs, same
`nationTopAppearances` caps map — with these differences: it calls
`youthByNation` instead of `byNation`, it buckets the result by
`YouthLevel.forAge`, and it derives the released list by diffing last year's
pyramid against this year's.

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';
import 'package:fnm/domain/services/player/prospects.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/federation_providers.dart';

/// A nation's youth pyramid: who is at each level, and who left this year.
typedef YouthPyramid = ({
  Map<YouthLevel, List<Prospect>> byLevel,
  Map<YouthLevel, List<String>> releasedByLevel,
});

/// The five youth levels, each ranked by promise, plus the boys released out of
/// each level this year — so a departure is seen rather than silent.
final AutoDisposeFutureProviderFamily<YouthPyramid, int> youthPyramidProvider =
    FutureProvider.autoDispose.family<YouthPyramid, int>((ref, careerId) async {
  await ref.watch(seedLoaderProvider).ensureSeeded();
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  final empty = (
    byLevel: <YouthLevel, List<Prospect>>{},
    releasedByLevel: <YouthLevel, List<String>>{},
  );
  if (career == null) return empty;
  final repo = ref.watch(playerRepositoryProvider);
  final years = CareerService.agingYears(career);
  final youth = await ref.watch(youthBonusByCycleProvider(careerId).future);
  final starts = await ref.watch(careerDevBonusProvider(careerId).future);

  Future<List<Player>> pyramidAt(int at) => repo.youthByNation(
        career.nationId,
        agingYears: at,
        saveSeed: career.rngSeed,
        youthBonusByCycle: youth,
        careerStartsByPlayer: starts,
      );

  final now = await pyramidAt(years);
  final before = years <= 0 ? const <Player>[] : await pyramidAt(years - 1);
  final caps = {
    for (final c in await ref
        .watch(competitionRepositoryProvider)
        .nationTopAppearances(careerId, career.nationId, limit: 500))
      c.playerId: c.games,
  };

  final byLevel = <YouthLevel, List<Prospect>>{};
  for (final level in YouthLevel.values) {
    final atLevel = [
      for (final p in now)
        if (YouthLevel.forAge(p.age) == level) p,
    ];
    byLevel[level] = Prospects.watchlist(
      atLevel,
      previousPool: before,
      capsByPlayer: caps,
    );
  }

  // Released this year: in last year's pyramid, gone from this one, and gone
  // because he was let go rather than because he turned twenty-one.
  final present = {for (final p in now) p.id};
  final releasedByLevel = <YouthLevel, List<String>>{};
  for (final p in before) {
    if (present.contains(p.id)) continue;
    if (!PlayerLifecycle.isReleasedBy(p.id, p.age + 1)) continue;
    final level = YouthLevel.forAge(p.age);
    if (level == null) continue;
    (releasedByLevel[level] ??= []).add(p.name);
  }
  return (byLevel: byLevel, releasedByLevel: releasedByLevel);
});
```

- [ ] **Step 2: Delete the old provider file**

```bash
git rm lib/features/squad/u21_providers.dart
```

- [ ] **Step 3: Verify it compiles**

Run: `flutter analyze lib`
Expected: errors only in `u21_screen.dart`, which Task 7 replaces. Any other
file still importing `u21_providers.dart` must be updated now.

- [ ] **Step 4: Commit**

```bash
git add lib/features/squad/youth_providers.dart
git commit -m "feat: youth pyramid provider"
```

---

### Task 7: The Youth screen

**Files:**
- Create: `lib/features/squad/youth_screen.dart`
- Delete: `lib/features/squad/u21_screen.dart`
- Modify: `lib/core/routing/app_router.dart:174` (`Routes.u21` → `Routes.youth`, path `/youth`) and its `GoRoute` at line ~433
- Modify: `lib/features/tactics/call_up_screen.dart:262` (the route it pushes)
- Modify: `lib/l10n/app_en.arb`, `lib/l10n/app_cs.arb`
- Test: `test/widget/youth_screen_test.dart` (create)

**Interfaces:**
- Consumes: `youthPyramidProvider` (Task 6), `YouthLevel` (Task 1).
- Produces: `class YouthScreen extends ConsumerWidget` with a required
  `int careerId`.

- [ ] **Step 1: Add the strings**

In `lib/l10n/app_en.arb`, beside the existing `u21Title` entry:

```json
  "youthTitle": "Youth",
  "@youthTitle": {
    "description": "Title of the youth pyramid screen."
  },
  "youthEmptyLevel": "Nobody at this level yet.",
  "@youthEmptyLevel": {
    "description": "Shown when a youth level has no players."
  },
  "youthReleased": "Released this year",
  "@youthReleased": {
    "description": "Heading above the boys let go from a level this year."
  },
```

In `lib/l10n/app_cs.arb` (no `@` blocks):

```json
  "youthTitle": "Mládež",
  "youthEmptyLevel": "Na této úrovni zatím nikdo není.",
  "youthReleased": "Letos uvolněni",
```

Run: `flutter gen-l10n`

- [ ] **Step 2: Write the failing widget test**

Create `test/widget/youth_screen_test.dart`, modelled on the existing
`test/widget/squad_tab_test.dart` for its ProviderScope override style:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/features/squad/youth_providers.dart';
import 'package:fnm/features/squad/youth_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/fixtures.dart';

void main() {
  testWidgets('every level has a tab, and its players are listed',
      (tester) async {
    final pyramid = (
      byLevel: {
        for (final level in YouthLevel.values)
          level: [
            (
              player: player(
                id: 1000 + level.index,
                nationId: 1,
                name: 'Boy ${level.label}',
                position: PlayerPosition.cm,
                age: level.minAge,
                attributes: flatAttributes(50),
              ),
              yearGain: 3,
              caps: 0,
              stars: 4,
              certain: false,
            ),
          ],
      },
      releasedByLevel: <YouthLevel, List<String>>{
        YouthLevel.u15: ['Gone Boy'],
      },
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          youthPyramidProvider(1).overrideWith((ref) async => pyramid),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: YouthScreen(careerId: 1),
        ),
      ),
    );
    await tester.pumpAndSettle();

    for (final level in YouthLevel.values) {
      expect(find.text(level.label), findsWidgets);
    }
    expect(find.text('Boy U-13'), findsOneWidget);
  });
}
```

- [ ] **Step 3: Run test to verify it fails**

Run: `flutter test test/widget/youth_screen_test.dart`
Expected: FAIL — `youth_screen.dart` does not exist.

- [ ] **Step 4: Write the screen**

Create `lib/features/squad/youth_screen.dart` with the scaffold below. The
per-player row (`_ProspectRow`) is the row body from the deleted
`u21_screen.dart` — position chip, name, age, overall, the year's gain, the star
read — lifted verbatim into its own widget; copy it out of git history
(`git show HEAD:lib/features/squad/u21_screen.dart`) rather than rewriting it,
so the rows keep the styling they already had.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/features/squad/youth_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

/// The nation's youth pyramid: five levels, from the eleven-year-olds who have
/// just come in to the twenty-year-olds about to be seniors.
///
/// The levels are watched, not managed — there are no youth fixtures. What the
/// screen is for is the one thing the game could never show before: the same
/// boy, year after year, becoming a player.
class YouthScreen extends ConsumerWidget {
  const YouthScreen({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(youthPyramidProvider(careerId));

    return DefaultTabController(
      length: YouthLevel.values.length,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: () => context.canPop()
                ? context.pop()
                : context.go('${Routes.hub}?careerId=$careerId'),
          ),
          title: Text(l.youthTitle, style: AppTypography.titleMedium),
          centerTitle: true,
          bottom: TabBar(
            isScrollable: true,
            labelColor: AppColors.onSurface,
            unselectedLabelColor: AppColors.onSurfaceVariant,
            indicatorColor: AppColors.primary,
            tabs: [
              for (final level in YouthLevel.values) Tab(text: level.label),
            ],
          ),
        ),
        body: async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (pyramid) => TabBarView(
            children: [
              for (final level in YouthLevel.values)
                _LevelTab(
                  prospects: pyramid.byLevel[level] ?? const [],
                  released: pyramid.releasedByLevel[level] ?? const [],
                  careerId: careerId,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LevelTab extends StatelessWidget {
  const _LevelTab({
    required this.prospects,
    required this.released,
    required this.careerId,
  });

  final List<Prospect> prospects;
  final List<String> released;
  final int careerId;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    if (prospects.isEmpty && released.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Text(
            l.youthEmptyLevel,
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [
        for (final p in prospects)
          _ProspectRow(prospect: p, careerId: careerId),
        // Boys who were here last year and have been let go. Shown, because a
        // career that ends at fifteen still happened.
        if (released.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          Text(
            l.youthReleased,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          for (final name in released)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                name,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ],
    );
  }
}
```

`_ProspectRow` takes `({required Prospect prospect, required int careerId})` and
renders exactly what the old watchlist row rendered, including its tap-through to
`'${Routes.player}?careerId=$careerId&playerId=${prospect.player.id}'`.
`Prospect` comes from `package:fnm/domain/services/player/prospects.dart` — add
that import.

- [ ] **Step 5: Run test to verify it passes**

Run: `flutter test test/widget/youth_screen_test.dart` — expect PASS.

- [ ] **Step 6: Rewire the route**

In `lib/core/routing/app_router.dart`, rename `static const u21 = '/u21';` to
`static const youth = '/youth';`, point its `GoRoute` at `YouthScreen`, and
update the import. In `lib/features/tactics/call_up_screen.dart:262`, change the
pushed route to `'${Routes.youth}?careerId=${widget.careerId}'`.

```bash
git rm lib/features/squad/u21_screen.dart
```

- [ ] **Step 7: Verify**

Run: `flutter analyze lib test` — expect no errors or warnings.
Run: `flutter test test/widget` — expect `All tests passed!`.

- [ ] **Step 8: Commit**

```bash
git add -A lib/features/squad lib/core/routing/app_router.dart \
        lib/features/tactics/call_up_screen.dart lib/l10n \
        test/widget/youth_screen_test.dart
git commit -m "feat: youth screen with a tab per level"
```

---

### Task 8: U-17s in the call-up list, tagged

**Files:**
- Modify: `lib/features/tactics/tactics_providers.dart` (`squadDataProvider`, ~line 158)
- Modify: `lib/features/tactics/call_up_screen.dart` (`_PlayerToggle`, ~line 656)
- Modify: `lib/l10n/app_en.arb`, `lib/l10n/app_cs.arb`
- Test: `test/unit/squad/youth_callup_test.dart` (create)

**Interfaces:**
- Consumes: `byNation(..., minAge:)` (Task 4), `YouthLevel` (Task 1).
- Produces: no new API. `squadDataProvider` returns a pool that includes 15- and
  16-year-olds; its default-squad fallback does not.

**The trap:** `squadDataProvider` currently defaults the squad to the ENTIRE pool
when nothing is stored (`stored.isEmpty ? {for (final p in pool) p.id} : stored`).
Left alone, every new save would auto-name its under-17s. The default must stay
seniors-only.

- [ ] **Step 1: Write the failing test**

The predicate must be tested where it lives, not mirrored in the test file — a
copy in the test would keep passing while the provider regressed. So it becomes
a named, exported function in `tactics_providers.dart`, and the test calls that.

Create `test/unit/squad/youth_callup_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';

import '../../helpers/fixtures.dart';

void main() {
  final pool = [
    for (var age = 15; age <= 30; age++)
      player(
        id: age,
        nationId: 1,
        name: 'P$age',
        position: PlayerPosition.cm,
        age: age,
        attributes: flatAttributes(70),
      ),
  ];

  test('the default squad never sweeps in a boy', () {
    // A manager who has named nobody yet gets the seniors, not the academy.
    final ids = defaultCallUpIds(pool);
    expect(ids.contains(15), isFalse);
    expect(ids.contains(16), isFalse);
    expect(ids.contains(17), isTrue);
    expect(ids.contains(30), isTrue);
  });

  test('it takes every senior, so nobody is quietly dropped', () {
    final seniors = pool.where((p) => p.age >= 17).map((p) => p.id).toSet();
    expect(defaultCallUpIds(pool), seniors);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/unit/squad/youth_callup_test.dart`
Expected: FAIL — compilation error, `defaultCallUpIds` is not defined.

- [ ] **Step 3: Write the implementation**

In `lib/features/tactics/tactics_providers.dart`, add above `squadDataProvider`:

```dart
/// The squad a manager who has named nobody starts from: every senior.
///
/// The pool now reaches down to fifteen so a wonderkid CAN be named, but the
/// default must not name him — left as "everyone in the pool", a new save would
/// auto-select its whole academy.
Set<int> defaultCallUpIds(List<Player> pool) =>
    {for (final p in pool) if (p.age >= 17) p.id};
```

then in `squadDataProvider` add `minAge: 15,` to the `byNation` call and use it:

```dart
  final stored = await ref.watch(squadRepositoryProvider).callUps(careerId);
  final callUps = stored.isEmpty ? defaultCallUpIds(pool) : stored;
```

Leave `tacticDataProvider` (same file, ~line 83) on the default `minAge`: the
tactics screen picks from the named squad, and a 16-year-old only reaches it by
being called up.

Leave `tacticDataProvider` (same file, ~line 83) on the default `minAge`: the
tactics screen picks from the named squad, and a 16-year-old only reaches it by
being called up.

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/unit/squad/youth_callup_test.dart` — expect PASS.

- [ ] **Step 5: Add the level tag to the call-up row**

Add to `lib/l10n/app_en.arb`:

```json
  "youthLevelTag": "{level}",
  "@youthLevelTag": {
    "description": "The youth level badge on a call-up row, e.g. U-17.",
    "placeholders": { "level": { "type": "String" } }
  },
```

and to `lib/l10n/app_cs.arb`:

```json
  "youthLevelTag": "{level}",
```

Run `flutter gen-l10n`. In `call_up_screen.dart`'s `_PlayerToggle.build`, in the
`title` `Row`, directly after the name `Flexible`:

```dart
          if (YouthLevel.forAge(player.age) case final level?) ...[
            const SizedBox(width: AppSpacing.xs),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.16),
                borderRadius: AppRadii.smAll,
              ),
              child: Text(
                level.label,
                style: AppTypography.labelSmall
                    .copyWith(color: AppColors.primary),
              ),
            ),
          ],
```

Add `import 'package:fnm/domain/entities/enums.dart';` if absent.

- [ ] **Step 6: Verify**

Run: `flutter analyze lib test` — no errors or warnings.
Run: `flutter test test/unit test/widget` — expect `All tests passed!`.

- [ ] **Step 7: Commit**

```bash
git add lib/features/tactics lib/l10n test/unit/squad/youth_callup_test.dart
git commit -m "feat: under-17s selectable and tagged in the call-up list"
```

---

### Task 9: Schema bump and final verification

**Files:**
- Modify: `lib/data/db/app_database.dart:65` (`schemaVersion`)
- Test: full suite

**Interfaces:**
- Consumes: everything above.
- Produces: `schemaVersion => 39`.

**Why:** newgen ids changed shape, so every stored reference to one (call-ups,
appearances, ratings, honours) no longer resolves. The bump forces the wipe that
makes that safe, exactly as previous intake changes did.

- [ ] **Step 1: Bump the version**

In `lib/data/db/app_database.dart`, change `int get schemaVersion => 38;` to
`=> 39;`.

- [ ] **Step 2: Regenerate the Drift schema**

```bash
dart run build_runner build --delete-conflicting-outputs --force-jit
```

The `--force-jit` flag is required — the sqlite3 build hook fails without it.

- [ ] **Step 3: Run the whole suite**

Run: `flutter analyze lib test`
Expected: no `error •` or `warning •` lines.

Run: `flutter test test/unit`
Expected: `All tests passed!`

Run: `flutter test`
Expected: all pass except the known pre-existing
`season_service_exclusive_test` flake described in Global Constraints.

- [ ] **Step 4: Sanity-check the world by hand**

```bash
flutter test test/unit/domain/player_lifecycle_test.dart -r expanded
```

Confirm in the output that the senior-pool-size test passed at years 20, 40 and
80 — that is the single number proving the new intake did not inflate or starve
the world.

- [ ] **Step 5: Commit**

```bash
git add lib/data/db/app_database.dart lib/data/db/app_database.g.dart
git commit -m "chore: bump schema to 39 for the new newgen id scheme"
```

---

## Notes for the implementer

- **The senior world must not move.** Tasks 2 and 3 are written so that a
  seventeen-year-old newgen comes out where he used to: `_asChild` subtracts
  exactly what the sub-17 curve adds back. If `match_engine_test`,
  `tournament_sim_test` or the ranking tests start failing, that reconstruction
  is off — fix the offsets in `_asChild`, not the tests.
- **Rounding drift of ±1 overall on 17-year-olds is expected and fine.** The
  growth curve accumulates in doubles and rounds once; the subtraction is
  integer. Do not chase it.
- **Do not add a superstar interaction.** Superstars (`developmentPotential >=
  1.70`) already get their lift through `PlayerAging`, so a superstar boy is
  handled — he is simply the best eleven-year-old anyone has seen. Nothing extra
  is needed.
