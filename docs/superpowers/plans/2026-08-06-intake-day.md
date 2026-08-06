# Intake Day Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Once a year the inbox reports the new eleven-year-olds who have just entered the nation's academy — the scouts' impression of them, not the truth.

**Architecture:** No new state and no schema change. The yearly-report block in `MessageService` already backfills keyed messages per aging year; intake day is a third one alongside `aging:$y` and `newcomers:$y`. Its content is built by pure functions in a new `intake_report.dart`, and rendered by the existing squad-report table, which gains an optional note line above it.

**Tech Stack:** Dart / Flutter, Riverpod (no codegen), Drift.

## Global Constraints

- **Riverpod without codegen** — never add `@riverpod`; it conflicts with `drift_dev`. Declare providers explicitly with their full type.
- **No new tables, no new columns, no schema bump.** The only thing persisted is the message row itself, through the existing `Messages` table.
- **Backwards compatibility is load-bearing:** messages already sitting in players' saves were written with the `SQUADDEV1` tag and must keep rendering. A change that breaks them silently corrupts existing inboxes.
- **Line length 80 characters** (`lines_longer_than_80_chars` is enforced repo-wide as an info lint) — match the surrounding style.
- **Verification:** `flutter analyze lib test` must report no `error •` or `warning •` lines outside `test/generated_migrations/` (which carries pre-existing `strict_raw_type` warnings that are not yours). `flutter test test/unit` must end `All tests passed!`.
- **Known pre-existing flake:** `test/unit/hub/season_service_exclusive_test.dart` "two advances in one frame" fails roughly one run in three under load and passes in isolation. It is not yours. Do not chase it.
- **Message bodies are stored, not localised at write time.** The existing reports write English titles and encode structured bodies that the sheet localises at render. Follow that: the note is English text in the body, exactly as the sibling reports' titles already are.

---

### Task 1: An optional note on the squad-development report

**Files:**
- Modify: `lib/features/messages/squad_dev_report.dart`
- Modify: `lib/features/messages/message_sheet.dart:91-92` (the one call site)
- Test: `test/unit/messages/squad_dev_report_test.dart` (create if absent; append if it exists)

**Interfaces:**
- Consumes: nothing.
- Produces:
  - `typedef SquadDevReport = ({String? note, List<SquadDevRow> rows});`
  - `String encodeSquadDevReport(List<SquadDevRow> rows, {String? note})`
  - `SquadDevReport? decodeSquadDevReport(String body)` — note the CHANGED
    return type; it used to return `List<SquadDevRow>?`.

- [ ] **Step 1: Write the failing test**

Create (or append to) `test/unit/messages/squad_dev_report_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/messages/squad_dev_report.dart';

void main() {
  SquadDevRow row(String name, {int stars = 3}) => SquadDevRow(
        name: name,
        age: 11,
        position: 'CM',
        rating: 40,
        status: SquadDevStatus.arrived,
        stars: stars,
      );

  group('the report body', () {
    test('carries a note when one is given', () {
      final body = encodeSquadDevReport(
        [row('Jan Novak')],
        note: 'The academy money is showing.',
      );
      final decoded = decodeSquadDevReport(body);
      expect(decoded, isNotNull);
      expect(decoded!.note, 'The academy money is showing.');
      expect(decoded.rows.single.name, 'Jan Novak');
    });

    test('has no note when none is given', () {
      final decoded =
          decodeSquadDevReport(encodeSquadDevReport([row('Jan Novak')]));
      expect(decoded!.note, isNull);
      expect(decoded.rows, hasLength(1));
    });

    test('a body written before notes existed still decodes', () {
      // The guard that matters: messages already in players' saves were
      // written with the v1 tag and must keep rendering, rows intact.
      const legacy = 'SQUADDEV1\n'
          'Old Player|24|ST|78|3||\n'
          'Gone Player|35|GK|70||out|';
      final decoded = decodeSquadDevReport(legacy);
      expect(decoded, isNotNull);
      expect(decoded!.note, isNull);
      expect(decoded.rows, hasLength(2));
      expect(decoded.rows.first.name, 'Old Player');
      expect(decoded.rows.first.change, 3);
      expect(decoded.rows.last.status, SquadDevStatus.gone);
    });

    test('a note with no rows decodes to an empty table, not an error', () {
      final decoded = decodeSquadDevReport(
        encodeSquadDevReport(const [], note: 'A quiet year.'),
      );
      expect(decoded!.note, 'A quiet year.');
      expect(decoded.rows, isEmpty);
    });

    test('a note containing a newline cannot break the format', () {
      final decoded = decodeSquadDevReport(
        encodeSquadDevReport([row('Jan Novak')], note: 'one\ntwo'),
      );
      expect(decoded!.note, 'one two');
      expect(decoded.rows, hasLength(1));
    });

    test('anything that is not a report decodes to null', () {
      expect(decodeSquadDevReport('just some prose'), isNull);
      expect(decodeSquadDevReport(''), isNull);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/unit/messages/squad_dev_report_test.dart`
Expected: FAIL — `encodeSquadDevReport` takes no `note` argument, and
`decodeSquadDevReport` returns a list with no `.note`.

- [ ] **Step 3: Write the implementation**

In `lib/features/messages/squad_dev_report.dart`, replace the tag constant and
add the report type:

```dart
/// Marks a message body as an encoded squad-development report. Versioned so a
/// message written by an older build still renders — as its own plain text.
///
/// v2 adds an optional note line directly under the tag. v1 bodies are still
/// decoded: they are sitting in players' saves and must keep rendering.
const String _devReportTagV1 = 'SQUADDEV1';
const String _devReportTagV2 = 'SQUADDEV2';

/// A decoded report: the table, and the line of context above it.
typedef SquadDevReport = ({String? note, List<SquadDevRow> rows});
```

Change the encoder's signature and its first lines (the sorting block above is
unchanged):

```dart
String encodeSquadDevReport(List<SquadDevRow> rows, {String? note}) {
```

and replace the `final lines = [...]` construction with:

```dart
  final lines = [
    _devReportTagV2,
    // Always present, so the row block always starts at the same offset. A
    // note is flattened to one line: the format is line-based, and a stray
    // newline would otherwise be read as a malformed row.
    (note ?? '').replaceAll('\n', ' ').trim(),
    for (final r in sorted)
      [
        r.name.replaceAll('|', ' '),
        '${r.age}',
        r.position,
        '${r.rating}',
        r.change?.toString() ?? '',
        switch (r.status) {
          SquadDevStatus.stayed => '',
          SquadDevStatus.arrived => 'new',
          SquadDevStatus.gone => 'out',
        },
        r.stars?.toString() ?? '',
      ].join('|'),
  ];
  return lines.join('\n');
}
```

Replace the decoder's signature and header handling. Everything from
`for (final line in ...)` onward that builds a `SquadDevRow` stays exactly as it
is; only the framing changes:

```dart
/// Decodes a body written by [encodeSquadDevReport], or null if [body] is not
/// one (an older plain-text report, or any other message).
SquadDevReport? decodeSquadDevReport(String body) {
  final lines = body.split('\n');
  if (lines.isEmpty) return null;
  final tag = lines.first.trim();
  if (tag != _devReportTagV1 && tag != _devReportTagV2) return null;
  final isV2 = tag == _devReportTagV2;
  final note = isV2 && lines.length > 1 && lines[1].trim().isNotEmpty
      ? lines[1].trim()
      : null;
  final rows = <SquadDevRow>[];
  for (final line in lines.skip(isV2 ? 2 : 1)) {
    // ... the existing row-parsing body, unchanged ...
  }
  return (note: note, rows: rows);
}
```

- [ ] **Step 4: Update the one call site**

In `lib/features/messages/message_sheet.dart`, replace lines 91-92:

```dart
            if (decodeSquadDevReport(message.body) case final report?) ...[
              if (report.note case final note?) ...[
                Text(
                  note,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              SquadDevTable(rows: report.rows),
            ],
```

- [ ] **Step 5: Run tests to verify they pass**

Run: `flutter test test/unit/messages/squad_dev_report_test.dart`
Expected: PASS, 6 tests.

Run: `flutter analyze lib test 2>&1 | grep -E "error •|warning •" | grep -v generated_migrations`
Expected: no output. If another file called `decodeSquadDevReport`, the analyzer
names it here — update it to the record form.

- [ ] **Step 6: Commit**

```bash
git add lib/features/messages/squad_dev_report.dart \
        lib/features/messages/message_sheet.dart \
        test/unit/messages/squad_dev_report_test.dart
git commit -m "feat: allow a note above a squad-development report"
```

---

### Task 2: The intake report's content

**Files:**
- Create: `lib/features/messages/intake_report.dart`
- Modify: `lib/domain/services/player/player_lifecycle.dart` (make the intake→cycle mapping public)
- Test: `test/unit/messages/intake_report_test.dart`

**Interfaces:**
- Consumes: `SquadDevRow`, `SquadDevStatus` from
  `lib/features/messages/squad_dev_report.dart`; `Prospects.scoutedStars(int
  playerId, {int age})`; `PlayerLifecycle.intakeAge` (11).
- Produces:
  - `PlayerLifecycle.cycleOfIntake(int intakeYear)` — public, returns `-1` for a
    backfilled (negative) year and `intakeYear ~/ 4` otherwise
  - `List<SquadDevRow> intakeRows(List<Player> pyramid)`
  - `String? intakeNote(double academyBonus)`

- [ ] **Step 1: Write the failing test**

Create `test/unit/messages/intake_report_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';
import 'package:fnm/features/messages/intake_report.dart';
import 'package:fnm/features/messages/squad_dev_report.dart';

import '../../helpers/fixtures.dart';

void main() {
  List<Player> pyramidOfAges(List<int> ages) => [
        for (var i = 0; i < ages.length; i++)
          player(
            id: 5000 + i,
            nationId: 1,
            name: 'Boy$i',
            position: PlayerPosition.cm,
            age: ages[i],
            attributes: flatAttributes(40 + i),
          ),
      ];

  group('intakeRows', () {
    test('takes this year\'s eleven-year-olds and nobody else', () {
      final rows = intakeRows(pyramidOfAges([11, 11, 12, 15, 20]));
      expect(rows, hasLength(2));
      expect(rows.every((r) => r.age == PlayerLifecycle.intakeAge), isTrue);
    });

    test('every boy is a newcomer with a scouting read and no change', () {
      final rows = intakeRows(pyramidOfAges([11, 11]));
      for (final r in rows) {
        expect(r.status, SquadDevStatus.arrived);
        expect(r.change, isNull, reason: 'there is nothing to compare with');
        expect(r.stars, isNotNull);
        expect(r.stars, inInclusiveRange(1, 5));
      }
    });

    test('an empty pyramid yields no rows rather than throwing', () {
      expect(intakeRows(const []), isEmpty);
    });
  });

  group('intakeNote', () {
    test('says nothing when the academy was not funded', () {
      expect(intakeNote(0), isNull);
    });

    test('speaks up when the academy money reached this intake', () {
      expect(intakeNote(0.04), isNotNull);
      expect(intakeNote(0.04), contains('academy'));
    });

    test('a negative pull is not reported as investment', () {
      // A sliding nation draws a NEGATIVE talent shift; that is not the
      // academy paying off and must not be announced as though it were.
      expect(intakeNote(-0.05), isNull);
    });
  });

  group('PlayerLifecycle.cycleOfIntake', () {
    test('maps an intake year to the cycle that funded it', () {
      expect(PlayerLifecycle.cycleOfIntake(0), 0);
      expect(PlayerLifecycle.cycleOfIntake(3), 0);
      expect(PlayerLifecycle.cycleOfIntake(4), 1);
      expect(PlayerLifecycle.cycleOfIntake(9), 2);
    });

    test('a backfilled year predates the save and draws nothing', () {
      expect(PlayerLifecycle.cycleOfIntake(-1), -1);
      expect(PlayerLifecycle.cycleOfIntake(-6), -1);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/unit/messages/intake_report_test.dart`
Expected: FAIL — `intake_report.dart` does not exist and
`PlayerLifecycle.cycleOfIntake` is private.

- [ ] **Step 3: Make the cycle mapping public**

In `lib/domain/services/player/player_lifecycle.dart`, rename the private
`_cycleOfIntake` to `cycleOfIntake`, update its two call sites inside that file
(in `poolAt` and in `newgenById`), and give it this doc comment:

```dart
  /// The four-year cycle an intake year belongs to, for the academy bonus.
  /// Backfilled years are before the save and take no investment.
  ///
  /// Public because the inbox reports whether that investment showed, and the
  /// mapping must be asked once rather than written out twice — the same
  /// duplication is how a draw ceremony once disagreed with the draw it was
  /// showing.
  static int cycleOfIntake(int intakeYear) =>
      intakeYear < 0 ? -1 : intakeYear ~/ 4;
```

- [ ] **Step 4: Write the intake report**

Create `lib/features/messages/intake_report.dart`:

```dart
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';
import 'package:fnm/domain/services/player/prospects.dart';
import 'package:fnm/features/messages/squad_dev_report.dart';

/// The year's academy intake, as report rows.
///
/// Only the boys who have just arrived — [PlayerLifecycle.intakeAge] — from a
/// pyramid that holds every age from eleven to twenty.
///
/// The rating is context; the STARS are the message. An eleven-year-old's
/// overall says almost nothing about what he becomes, and the read here is the
/// deliberately vague sub-17 one, two stars wide either way and never settled
/// until he has played. What the manager is being told is what the coaches
/// think, which is the only thing anybody could honestly tell him.
List<SquadDevRow> intakeRows(List<Player> pyramid) => [
      for (final p in pyramid)
        if (p.age == PlayerLifecycle.intakeAge)
          SquadDevRow(
            name: p.name,
            age: p.age,
            position: p.position.label,
            rating: p.overall,
            status: SquadDevStatus.arrived,
            stars: Prospects.scoutedStars(p.id, age: p.age),
          ),
    ];

/// The line above the table, or null when there is nothing to say.
///
/// Only a POSITIVE bonus is reported. A nation sliding down the rankings draws
/// a negative talent shift into its intake, and announcing that as though the
/// academy had paid off would be a lie in the manager's own inbox.
String? intakeNote(double academyBonus) => academyBonus <= 0
    ? null
    : 'The academy investment is showing: this intake arrived stronger than '
        'it would have.';
```

- [ ] **Step 5: Run tests to verify they pass**

Run: `flutter test test/unit/messages/intake_report_test.dart`
Expected: PASS, 8 tests.

Run: `flutter test test/unit/domain/player_lifecycle_test.dart`
Expected: PASS — the rename must not have changed behaviour.

- [ ] **Step 6: Commit**

```bash
git add lib/features/messages/intake_report.dart \
        lib/domain/services/player/player_lifecycle.dart \
        test/unit/messages/intake_report_test.dart
git commit -m "feat: build the academy intake report"
```

---

### Task 3: The yearly intake message

**Files:**
- Modify: `lib/features/messages/message_providers.dart` (the yearly-report block, around lines 500-560)
- Modify: `lib/features/messages/message_sheet.dart` (the `messageStyle` switch, around lines 11-35)
- Test: `test/unit/messages/intake_message_test.dart`

**Interfaces:**
- Consumes: `intakeRows`, `intakeNote` (Task 2);
  `encodeSquadDevReport(rows, {note})` (Task 1);
  `PlayerRepository.youthByNation(int nationId, {int agingYears, int saveSeed, Map<int, double> youthBonusByCycle, Map<int, int> careerStartsByPlayer})`;
  `youthBonusByCycleProvider(careerId)` and `careerDevBonusProvider(careerId)`
  from `lib/features/federation/federation_providers.dart`;
  `PlayerLifecycle.cycleOfIntake(int)`.
- Produces: a message with key `intake:$y` and category `youth`.

- [ ] **Step 1: Write the failing test**

Create `test/unit/messages/intake_message_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/messages/message_sheet.dart';

void main() {
  test('the youth category has its own look in the inbox', () {
    // A category with no entry falls through to the default, so an intake
    // message would be indistinguishable from any other note.
    final youth = messageStyle('youth');
    final fallback = messageStyle('no-such-category-xyz');
    expect(youth.icon, isNot(fallback.icon));
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/unit/messages/intake_message_test.dart`
Expected: FAIL — `'youth'` is not in the switch, so it returns the default and
the icons match.

- [ ] **Step 3: Add the category style**

In `lib/features/messages/message_sheet.dart`, inside the `messageStyle`
switch, beside the `'aging'` entry:

```dart
      'youth' => (icon: Icons.school_outlined, color: AppColors.primary),
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/unit/messages/intake_message_test.dart`
Expected: PASS.

- [ ] **Step 5: Add the intake draft**

In `lib/features/messages/message_providers.dart`, inside the
`if (missingYears.isNotEmpty)` block, the existing `for (final y in
missingYears)` loop already computes `reportYear`. Read the academy bonuses once
above that loop, beside where `playerRepo` is read:

```dart
      final academyBonus = await _ref.read(
        youthBonusByCycleProvider(careerId).future,
      );
      final careerDev = await _ref.read(
        careerDevBonusProvider(careerId).future,
      );
```

Then, inside the year loop, after the existing `newcomers:$y` draft is added:

```dart
        // The year's academy intake: the eleven-year-olds who have just come
        // in. The pyramid is otherwise silent — a manager only learned an
        // intake had happened by going and looking for it.
        final pyramid = await playerRepo.youthByNation(
          career.nationId,
          agingYears: y,
          saveSeed: career.rngSeed,
          youthBonusByCycle: academyBonus,
          careerStartsByPlayer: careerDev,
        );
        final rows = intakeRows(pyramid);
        if (rows.isNotEmpty) {
          drafts.add(
            _Draft(
              'intake:$y',
              'youth',
              'Academy intake · $reportYear',
              encodeSquadDevReport(
                rows,
                note: intakeNote(
                  academyBonus[PlayerLifecycle.cycleOfIntake(y)] ?? 0,
                ),
              ),
              reportYear,
              4,
            ),
          );
        }
```

Add these imports at the top of the file if absent:

```dart
import 'package:fnm/domain/services/player/player_lifecycle.dart';
import 'package:fnm/features/federation/federation_providers.dart';
import 'package:fnm/features/messages/intake_report.dart';
```

- [ ] **Step 6: Verify the whole thing**

Run: `flutter analyze lib test 2>&1 | grep -E "error •|warning •" | grep -v generated_migrations`
Expected: no output.

Run: `flutter test test/unit`
Expected: `All tests passed!` (barring the known
`season_service_exclusive_test` flake — re-run that file alone to confirm).

- [ ] **Step 7: Commit**

```bash
git add lib/features/messages/message_providers.dart \
        lib/features/messages/message_sheet.dart \
        test/unit/messages/intake_message_test.dart
git commit -m "feat: report the year's academy intake in the inbox"
```

---

## Notes for the implementer

- **Which years get an intake message, and why.** The draft rides the existing
  `missingYears` list, which is computed from the `aging:$y` key — not its own.
  The consequence is deliberate: a NEW save backfills intake messages for every
  year alongside its squad reports, while a save that already has this build's
  predecessor keeps its history and starts seeing intake messages from the next
  yearly tick. An existing career does not get forty years of academy news
  dumped into its inbox on upgrade. If you change `missingYears` to key off
  `intake:$y` as well, that is exactly what will happen.
- **Duplicates are structurally impossible**, which is why no test asserts it:
  `Messages` has a unique key on `(careerId, dedupKey)`, and the draft loop
  filters against the keys already stored. The key `intake:$y` is stable across
  runs because `y` is the aging year, not a wall-clock date.

- **The v1 compatibility test is the one that matters.** Everything else here is
  additive; that test is the only thing standing between this change and a
  player's existing inbox rendering as raw `SQUADDEV1|...` text.
- **`youthByNation` needs the save seed.** Its `saveSeed` defaults to 0, and a
  zero seed routes the name generator down an identity branch that produces
  placeholder names like "First3 Last3". The draft above passes
  `career.rngSeed`; do not drop it.
- **Do not add a golden-generation detector.** It was designed, costed and
  deliberately cut. If the intake looks exceptional, the stars already say so.
