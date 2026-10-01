# Press Overhaul Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the topic/tone/probe press system with rare, fact-driven conferences (big results and crises only) whose answers can go on record as statements that are judged later and thrown back.

**Architecture:** Pure domain units (`ConferenceTrigger`, `ConferenceBuilder`, `StatementJudge`, `Credibility`) in `lib/domain/services/press/`. Two new Drift tables (`press_statements`, `press_conferences`, schema 49). One idempotent `PressDesk.afterMatches` step called from both match-commit paths in `SeasonService` judges statements and stores a pending conference; the hub's forced press event and a rewritten `PressSheet` hold it. Effects keep flowing through `press_answers` into the existing morale/board totals.

**Tech Stack:** Flutter, Riverpod (no codegen), Drift (+ drift_dev schema steps), gen-l10n (EN + CS ARB).

**Spec:** `docs/superpowers/specs/2026-10-01-press-overhaul-design.md` (read the "Amendments after the code survey" section: it overrides the body where they differ).

## Global Constraints

- Riverpod WITHOUT codegen: no `@riverpod`; declare providers by hand like the existing ones.
- Codegen: `dart run build_runner build --force-jit` (plain `build_runner build` fails on the sqlite3 hook).
- Schema bump recipe (from `lib/data/db/app_database.dart:119-130`): edit `tables.dart`, bump `currentSchemaVersion` to 49, then `dart run drift_dev schema dump lib/data/db/app_database.dart drift_schemas/`, `dart run drift_dev schema steps drift_schemas/ lib/data/db/schema_versions.dart`, fill `from48To49`, `dart run drift_dev schema generate drift_schemas/ test/generated_migrations/`, then build_runner.
- Domain code speaks no English (`test/unit/l10n/domain_speaks_no_english_test.dart`): domain returns enums/ids; all words live in ARBs, mapped in `lib/features/press/`.
- User-facing copy: NO em dashes; "World Championship", never "World Cup", in EN; EN and CS for every key; CS uses the "vy" register like the existing press copy.
- After ARB edits: `flutter gen-l10n`, then `dart run tool/export_copy.dart` (rewrites `copy/strings.csv`).
- Never run `flutter install` on a device.
- `dart format` only the files a task touches (formatting the whole tree rewrites unrelated files on this branch).
- Commit after each task with the attribution line `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`. Stage only the task's files: the branch carries unrelated uncommitted work (iOS project files, match/settings/backup changes).

## Review Focus

1. **Manager changes nation with statements open.** A `backPlayer` about a player of his old nation would keep being judged against that player's later caps. Expected: open statements made for another nation lapse silently. (Task 2 `judge` takes `currentNationId`; test added there.)
2. **One `advance` call commits several of his matches.** Expected: the judge uses every match since the statement (window judged by the FIRST later match for `winNext`), the trigger considers only his latest competitive match, nothing double-records. (Task 2 and Task 5 tests.)
3. **A pending conference never opened, then the cycle rolls over.** Expected: it is marked `skipped` and the hub is not stuck on a stale press event. (Task 5 test.)
4. **Old saves with legacy `press_answers` rows** (`defeat:12`, `grv:...`). Expected: `grv:` rows never count; legacy press rows still count toward their own cycle's totals; carry-over halves the previous cycle without double counting. (Task 6 test.)
5. **A player named in a beat who did not play** (bench, injured, other nation). Expected: never named; the reaction falls back to a follow-up about the result. (Task 3 builder gets player ids only from that fixture's ratings for his nation; test added there.)

---

## File Structure

| File | Responsibility |
|---|---|
| `lib/domain/services/press/statement.dart` (new) | `StatementKind`, `StatementStatus`, `PressStatement`, `StatementJudge`, `Credibility`, per-player condition term |
| `lib/domain/services/press/conference.dart` (new) | `ConferenceReason`, `ConferenceStatus`, `BeatKind`, `AnswerKind`, `OwnMatch`, `ConferenceFacts`, `Beat`, `PressConferenceRow`, `ConferenceTrigger`, `ConferenceBuilder` |
| `lib/domain/services/press/press.dart` (shrinks) | keeps `PressEffect`, `PressVerdict`, reporters (`PressReporter`, `PressAngle`, `roomFor`), `verdictOf`, `arrowsFor`, `totalOf`; adds `carryOver` |
| `lib/data/db/tables.dart`, `app_database.dart`, `schema_versions.dart` | two tables, schema 49 |
| `lib/domain/repositories/career_repository.dart` + `lib/data/repositories/drift_career_repository.dart` | statement/conference persistence |
| `lib/data/db/career_bundle.dart` | fixture-id remapping for the new tables |
| `lib/features/press/press_desk.dart` (new) | `PressDesk.afterMatches` (judge + trigger), provider |
| `lib/features/press/press_providers.dart` (rewritten) | `pendingConferenceProvider`, `pressStatementsProvider`, `credibilityProvider`, `pressEffectProvider`, `PressService` |
| `lib/features/press/press_copy.dart` (new) | enum → localized strings |
| `lib/features/press/press_sheet.dart` (rewritten) | beat-based sheet |
| `lib/features/hub/hub_providers.dart`, `hub_event.dart`, `hub_screen.dart` | hook + event + opener |
| `lib/features/tactics/condition_providers.dart`, `lib/domain/services/squad/condition.dart` | per-player statement term |
| `lib/domain/services/press/y_feed.dart`, `lib/features/y/y_providers.dart`, `lib/features/y/y_screen.dart` | statement verdict posts |

---

### Task 1: Schema 49, persistence, bundle

**Files:**
- Modify: `lib/data/db/tables.dart` (after `PressAnswers`, ~line 772)
- Modify: `lib/data/db/app_database.dart:63` (tables list), `:85` (version), migration steps
- Regenerate: `lib/data/db/schema_versions.dart`, `drift_schemas/`, `test/generated_migrations/`, `lib/data/db/app_database.g.dart`
- Modify: `lib/domain/repositories/career_repository.dart:153-165`, `lib/data/repositories/drift_career_repository.dart:375-415`
- Modify: `lib/data/db/career_bundle.dart:58` (`references`)
- Create: `lib/domain/services/press/statement.dart` (types only in this task), `lib/domain/services/press/conference.dart` (types only)
- Test: `test/unit/data/press_persistence_test.dart`, `test/unit/data/schema_migration_test.dart` (add v49 case), `test/unit/data/career_bundle_test.dart` (add remap case)

**Interfaces:**
- Produces (domain types, used by every later task):

```dart
// lib/domain/services/press/statement.dart
enum StatementKind { winNext, jobOnTheLine, backPlayer, blamePlayer }
enum StatementStatus { open, kept, broken, lapsed }

typedef PressStatement = ({
  int id,
  int cycle,
  int nationId,
  StatementKind kind,
  int? playerId,
  DateTime madeOn, // the date of the match the conference was about
  int madeAfterFixtureId,
  StatementStatus status,
  DateTime? judgedOn,
  bool thrownBack,
});
```

```dart
// lib/domain/services/press/conference.dart
enum ConferenceReason { bigWin, bigLoss, crisis, jobVerdict }
enum ConferenceStatus { pending, held, skipped }

typedef PressConferenceRow = ({
  int id,
  int cycle,
  ConferenceReason reason,
  int fixtureId,
  DateTime triggeredOn, // the match date
  ConferenceStatus status,
});
```

- Produces (repository, on `CareerRepository`):

```dart
Future<int> recordStatement({required int careerId, required int cycle, required int nationId, required StatementKind kind, int? playerId, required DateTime madeOn, required int madeAfterFixtureId});
Future<List<PressStatement>> statements(int careerId); // oldest first
Future<void> judgeStatement(int id, {required StatementStatus status, required DateTime judgedOn});
Future<void> markThrownBack(int id);
Future<int> recordConference({required int careerId, required int cycle, required ConferenceReason reason, required int fixtureId, required DateTime triggeredOn});
Future<List<PressConferenceRow>> conferences(int careerId); // oldest first
Future<void> setConferenceStatus(int id, ConferenceStatus status);
```

- [ ] **Step 1: Write the domain type files** with exactly the declarations above (each with a short doc comment in the codebase's style). No logic yet.

- [ ] **Step 2: Write the failing persistence test**

```dart
// test/unit/data/press_persistence_test.dart
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/repositories/drift_career_repository.dart';
import 'package:fnm/domain/services/press/conference.dart';
import 'package:fnm/domain/services/press/statement.dart';

void main() {
  late AppDatabase db;
  late DriftCareerRepository repo;
  late int careerId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = DriftCareerRepository(db);
    careerId = await db.into(db.careers).insert(
      CareersCompanion.insert(
        nationId: 1,
        managerName: 'M',
        createdAt: DateTime.utc(2030),
        inGameDate: DateTime.utc(2030, 6, 1),
        rngSeed: 7,
      ),
    );
  });
  tearDown(() => db.close());

  test('a statement is stored open, judged, then thrown back', () async {
    final id = await repo.recordStatement(
      careerId: careerId,
      cycle: 0,
      nationId: 1,
      kind: StatementKind.backPlayer,
      playerId: 42,
      madeOn: DateTime.utc(2030, 6, 1),
      madeAfterFixtureId: 9,
    );
    var s = (await repo.statements(careerId)).single;
    expect(s.id, id);
    expect(s.status, StatementStatus.open);
    expect(s.thrownBack, isFalse);
    await repo.judgeStatement(id, status: StatementStatus.kept, judgedOn: DateTime.utc(2030, 9, 1));
    await repo.markThrownBack(id);
    s = (await repo.statements(careerId)).single;
    expect(s.status, StatementStatus.kept);
    expect(s.judgedOn, DateTime.utc(2030, 9, 1));
    expect(s.thrownBack, isTrue);
  });

  test('a conference is stored pending and can be held', () async {
    final id = await repo.recordConference(
      careerId: careerId,
      cycle: 0,
      reason: ConferenceReason.crisis,
      fixtureId: 9,
      triggeredOn: DateTime.utc(2030, 6, 1),
    );
    expect((await repo.conferences(careerId)).single.status, ConferenceStatus.pending);
    await repo.setConferenceStatus(id, ConferenceStatus.held);
    final c = (await repo.conferences(careerId)).single;
    expect(c.status, ConferenceStatus.held);
    expect(c.reason, ConferenceReason.crisis);
  });
}
```

(Check the repository's real class/constructor name in `lib/data/repositories/drift_career_repository.dart` and use it.)

- [ ] **Step 3: Run it, expect a compile failure** (`recordStatement` undefined).
Run: `flutter test test/unit/data/press_persistence_test.dart`

- [ ] **Step 4: Add the tables** to `tables.dart` after `PressAnswers`:

```dart
/// What the manager put on the record at a press conference, to be judged by
/// what happens next. See `StatementJudge`.
class PressStatements extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get careerId =>
      integer().references(Careers, #id, onDelete: KeyAction.cascade)();
  IntColumn get cycle => integer()();

  /// The nation he managed when he said it: a statement about a squad he has
  /// since left lapses rather than being judged against another team.
  IntColumn get nationId => integer()();

  /// A `StatementKind` name.
  TextColumn get kind => text()();
  IntColumn get playerId => integer().nullable()();

  /// The date of the match the conference was about; its window opens after.
  DateTimeColumn get madeOn => dateTime()();
  IntColumn get madeAfterFixtureId => integer()();

  /// A `StatementStatus` name.
  TextColumn get status => text().withDefault(const Constant('open'))();
  DateTimeColumn get judgedOn => dateTime().nullable()();
  BoolColumn get thrownBack => boolean().withDefault(const Constant(false))();
}

/// A press conference the season has called. Stored when it is triggered, so
/// the quiet period and the per-cycle ceiling count conferences whether or
/// not the manager opened them.
class PressConferences extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get careerId =>
      integer().references(Careers, #id, onDelete: KeyAction.cascade)();
  IntColumn get cycle => integer()();

  /// A `ConferenceReason` name.
  TextColumn get reason => text()();
  IntColumn get fixtureId => integer()();
  DateTimeColumn get triggeredOn => dateTime()();

  /// A `ConferenceStatus` name.
  TextColumn get status => text().withDefault(const Constant('pending'))();
}
```

Add `PressStatements, PressConferences,` after `PressAnswers,` in the `@DriftDatabase(tables: [...])` list and set `currentSchemaVersion = 49`.

- [ ] **Step 5: Run the schema recipe** (Global Constraints) and fill the step:

```dart
from48To49: (m, schema) async {
  await m.createTable(schema.pressStatements);
  await m.createTable(schema.pressConferences);
},
```

- [ ] **Step 6: Implement the repository methods** in the abstract interface (doc comments) and the drift class:

```dart
@override
Future<int> recordStatement({
  required int careerId,
  required int cycle,
  required int nationId,
  required StatementKind kind,
  int? playerId,
  required DateTime madeOn,
  required int madeAfterFixtureId,
}) => _db.into(_db.pressStatements).insert(
  PressStatementsCompanion.insert(
    careerId: careerId,
    cycle: cycle,
    nationId: nationId,
    kind: kind.name,
    playerId: Value(playerId),
    madeOn: madeOn,
    madeAfterFixtureId: madeAfterFixtureId,
  ),
);

@override
Future<List<PressStatement>> statements(int careerId) async {
  final rows = await (_db.select(_db.pressStatements)
        ..where((t) => t.careerId.equals(careerId))
        ..orderBy([(t) => OrderingTerm.asc(t.id)]))
      .get();
  return [
    for (final r in rows)
      (
        id: r.id,
        cycle: r.cycle,
        nationId: r.nationId,
        kind: StatementKind.values.byName(r.kind),
        playerId: r.playerId,
        madeOn: r.madeOn,
        madeAfterFixtureId: r.madeAfterFixtureId,
        status: StatementStatus.values.byName(r.status),
        judgedOn: r.judgedOn,
        thrownBack: r.thrownBack,
      ),
  ];
}

@override
Future<void> judgeStatement(int id, {required StatementStatus status, required DateTime judgedOn}) =>
    (_db.update(_db.pressStatements)..where((t) => t.id.equals(id))).write(
      PressStatementsCompanion(status: Value(status.name), judgedOn: Value(judgedOn)),
    );

@override
Future<void> markThrownBack(int id) =>
    (_db.update(_db.pressStatements)..where((t) => t.id.equals(id))).write(
      const PressStatementsCompanion(thrownBack: Value(true)),
    );

@override
Future<int> recordConference({
  required int careerId,
  required int cycle,
  required ConferenceReason reason,
  required int fixtureId,
  required DateTime triggeredOn,
}) => _db.into(_db.pressConferences).insert(
  PressConferencesCompanion.insert(
    careerId: careerId,
    cycle: cycle,
    reason: reason.name,
    fixtureId: fixtureId,
    triggeredOn: triggeredOn,
  ),
);

@override
Future<List<PressConferenceRow>> conferences(int careerId) async {
  final rows = await (_db.select(_db.pressConferences)
        ..where((t) => t.careerId.equals(careerId))
        ..orderBy([(t) => OrderingTerm.asc(t.id)]))
      .get();
  return [
    for (final r in rows)
      (
        id: r.id,
        cycle: r.cycle,
        reason: ConferenceReason.values.byName(r.reason),
        fixtureId: r.fixtureId,
        triggeredOn: r.triggeredOn,
        status: ConferenceStatus.values.byName(r.status),
      ),
  ];
}

@override
Future<void> setConferenceStatus(int id, ConferenceStatus status) =>
    (_db.update(_db.pressConferences)..where((t) => t.id.equals(id))).write(
      PressConferencesCompanion(status: Value(status.name)),
    );
```

Any other `CareerRepository` implementations/fakes in `test/` must get the methods too (grep `implements CareerRepository`).

- [ ] **Step 7: Bundle remapping.** In `career_bundle.dart` `references`, extend the `'fixtures'` list with `('press_statements', 'made_after_fixture_id')` and `('press_conferences', 'fixture_id')`. In `career_bundle_test.dart`, copy the `'goal events follow their fixture to its new number'` test (line 230) as `'press statements and conferences follow their fixture'`: insert one statement and one conference pointing at the career's fixture, export, import into a DB that already holds another career, assert both new rows point at the imported fixture's new id.

- [ ] **Step 8: Migration test.** In `schema_migration_test.dart`, following the "v48 keeps an old message" pattern (line 212), add `'v49 adds the press tables to a populated v48 save'`: open `verifier.schemaAt(48)`, insert a career and a `press_answers` row, `migrateAndValidate(db, 49)`, assert the old answer is still there and both new tables are empty.

- [ ] **Step 9: Run** `flutter test test/unit/data/` and expect PASS.

- [ ] **Step 10: Commit** the tables, migration files, generated files, repository, bundle, tests, and both domain type files: `feat(press): schema 49 statements and conferences`.

---

### Task 2: StatementJudge and Credibility

**Files:**
- Modify: `lib/domain/services/press/statement.dart`
- Test: `test/unit/press/statement_judge_test.dart`

**Interfaces:**
- Consumes: `PressEffect` (`press.dart:27`, `({int morale, int board})`), Task 1 types.
- Produces:

```dart
typedef JudgedMatch = ({int fixtureId, DateTime date, int scored, int conceded});
typedef Appearance = ({int fixtureId, DateTime date, double rating});
typedef StatementVerdict = ({StatementStatus status, PressEffect effect});

abstract final class StatementJudge {
  static StatementVerdict? judge(
    PressStatement s, {
    required List<JudgedMatch> matches, // his competitive matches for s.nationId, any order
    required List<Appearance> appearances, // s.playerId's appearances, any order ([] if none)
    required int currentNationId,
    required int currentCycle,
  });
  static Map<int, int> conditionDeltas(Iterable<PressStatement> all, DateTime asOf);
}

enum CredibilityBand { low, mid, high }
abstract final class Credibility {
  static int of(Iterable<PressStatement> statements, {required int deflects});
  static CredibilityBand band(int credibility);
  static double multiplier(int credibility);
}
```

- [ ] **Step 1: Write the failing tests**

```dart
// test/unit/press/statement_judge_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/press/statement.dart';

PressStatement st(StatementKind kind, {int? playerId, int nationId = 1, int cycle = 0,
    StatementStatus status = StatementStatus.open, DateTime? judgedOn}) => (
  id: 1, cycle: cycle, nationId: nationId, kind: kind, playerId: playerId,
  madeOn: DateTime.utc(2030, 1, 1), madeAfterFixtureId: 100,
  status: status, judgedOn: judgedOn, thrownBack: false,
);
JudgedMatch m(int day, int scored, int conceded) =>
    (fixtureId: day, date: DateTime.utc(2030, 1, 1 + day), scored: scored, conceded: conceded);
Appearance a(int day, double rating) =>
    (fixtureId: day, date: DateTime.utc(2030, 1, 1 + day), rating: rating);

StatementVerdict? judge(PressStatement s, {List<JudgedMatch> matches = const [],
    List<Appearance> apps = const [], int nation = 1, int cycle = 0}) =>
    StatementJudge.judge(s, matches: matches, appearances: apps,
        currentNationId: nation, currentCycle: cycle);

void main() {
  group('winNext', () {
    test('waits for the next match', () => expect(judge(st(StatementKind.winNext)), isNull));
    test('is judged by the FIRST match after it, not a later one', () {
      final v = judge(st(StatementKind.winNext), matches: [m(9, 3, 0), m(3, 0, 1)])!;
      expect(v.status, StatementStatus.broken);
      expect(v.effect, StatementJudge.winNextBroken);
    });
    test('a win keeps it', () {
      expect(judge(st(StatementKind.winNext), matches: [m(3, 2, 1)])!.status, StatementStatus.kept);
    });
    test('matches before it do not count', () {
      final early = (fixtureId: 1, date: DateTime.utc(2029, 12, 1), scored: 5, conceded: 0);
      expect(judge(st(StatementKind.winNext), matches: [early]), isNull);
    });
  });

  group('jobOnTheLine', () {
    test('needs three matches', () {
      expect(judge(st(StatementKind.jobOnTheLine), matches: [m(1, 1, 0), m(2, 1, 0)]), isNull);
    });
    test('two wins in three keep it', () {
      final v = judge(st(StatementKind.jobOnTheLine), matches: [m(1, 1, 0), m(2, 0, 0), m(3, 2, 1)])!;
      expect(v.status, StatementStatus.kept);
      expect(v.effect, StatementJudge.jobKept);
    });
    test('one win in three breaks it', () {
      final v = judge(st(StatementKind.jobOnTheLine), matches: [m(1, 1, 0), m(2, 0, 0), m(3, 0, 1)])!;
      expect(v.status, StatementStatus.broken);
      expect(v.effect, StatementJudge.jobBroken);
    });
  });

  group('players', () {
    test('backing a player who delivers keeps it', () {
      final v = judge(st(StatementKind.backPlayer, playerId: 5),
          apps: [a(1, 7.0), a(2, 6.9), a(3, 6.8)])!;
      expect(v.status, StatementStatus.kept);
    });
    test('backing a flop breaks it', () {
      final v = judge(st(StatementKind.backPlayer, playerId: 5),
          apps: [a(1, 6.0), a(2, 6.2), a(3, 6.4)])!;
      expect(v.status, StatementStatus.broken);
      expect(v.effect, StatementJudge.backBroken);
    });
    test('blame stands when he stays poor', () {
      final v = judge(st(StatementKind.blamePlayer, playerId: 5),
          apps: [a(1, 6.0), a(2, 6.2), a(3, 6.4)])!;
      expect(v.status, StatementStatus.kept);
      expect(v.effect, StatementJudge.blameStood);
    });
    test('blame is proved wrong when he responds, and costs nothing more', () {
      final v = judge(st(StatementKind.blamePlayer, playerId: 5),
          apps: [a(1, 7.5), a(2, 7.0), a(3, 7.2)])!;
      expect(v.status, StatementStatus.broken);
      expect(v.effect, StatementJudge.none);
    });
  });

  group('lapsing', () {
    test('an incomplete window lapses once the cycle is over', () {
      final v = judge(st(StatementKind.jobOnTheLine), matches: [m(1, 1, 0)], cycle: 1)!;
      expect(v.status, StatementStatus.lapsed);
      expect(v.effect, StatementJudge.none);
    });
    test('a statement about a squad he has left lapses at once', () {
      final v = judge(st(StatementKind.backPlayer, playerId: 5, nationId: 1),
          apps: [a(1, 9.0), a(2, 9.0), a(3, 9.0)], nation: 2)!;
      expect(v.status, StatementStatus.lapsed);
    });
    test('a judged statement is never judged again', () {
      expect(judge(st(StatementKind.winNext, status: StatementStatus.kept), matches: [m(1, 0, 3)]), isNull);
    });
  });

  group('credibility', () {
    test('starts at 50 and moves with the record', () {
      expect(Credibility.of(const [], deflects: 0), 50);
      expect(Credibility.of([st(StatementKind.winNext, status: StatementStatus.kept)], deflects: 0), 58);
      expect(Credibility.of([st(StatementKind.winNext, status: StatementStatus.broken)], deflects: 1), 38);
    });
    test('is clamped and banded', () {
      final many = List.filled(20, st(StatementKind.winNext, status: StatementStatus.broken));
      expect(Credibility.of(many, deflects: 0), 0);
      expect(Credibility.band(34), CredibilityBand.low);
      expect(Credibility.band(50), CredibilityBand.mid);
      expect(Credibility.band(66), CredibilityBand.high);
      expect(Credibility.multiplier(0), closeTo(0.6, 1e-9));
      expect(Credibility.multiplier(100), closeTo(1.4, 1e-9));
    });
  });

  group('condition deltas', () {
    test('an open blame weighs on him, a recent kept backing lifts him', () {
      final asOf = DateTime.utc(2030, 3, 1);
      final d = StatementJudge.conditionDeltas([
        st(StatementKind.blamePlayer, playerId: 5),
        st(StatementKind.backPlayer, playerId: 6, status: StatementStatus.kept, judgedOn: DateTime.utc(2030, 2, 1)),
        st(StatementKind.backPlayer, playerId: 7, status: StatementStatus.kept, judgedOn: DateTime.utc(2029, 6, 1)),
      ], asOf);
      expect(d, {5: -2, 6: 1});
    });
  });
}
```

- [ ] **Step 2: Run, expect failure** (`judge` undefined). Run: `flutter test test/unit/press/statement_judge_test.dart`

- [ ] **Step 3: Implement** in `statement.dart` (add `import 'package:fnm/domain/services/press/press.dart' show PressEffect;`):

```dart
/// Judging what the manager said against what happened next. Pure: the press
/// desk gathers the matches and appearances and stores the verdicts.
abstract final class StatementJudge {
  static const int jobWindow = 3;
  static const int playerWindow = 3;
  static const double playerBar = 6.8;

  /// A backed player who came good stays a little sharper for this long.
  static const int backingDays = 90;

  static const PressEffect none = (morale: 0, board: 0);
  static const PressEffect winNextKept = (morale: 4, board: 3);
  static const PressEffect winNextBroken = (morale: -2, board: -6);
  static const PressEffect jobKept = (morale: 0, board: 10);
  static const PressEffect jobBroken = (morale: 0, board: -12);
  static const PressEffect backKept = (morale: 2, board: 0);
  static const PressEffect backBroken = (morale: 0, board: -2);
  static const PressEffect blameStood = (morale: 0, board: 2);

  static StatementVerdict? judge(
    PressStatement s, {
    required List<JudgedMatch> matches,
    required List<Appearance> appearances,
    required int currentNationId,
    required int currentCycle,
  }) {
    if (s.status != StatementStatus.open) return null;
    const lapsed = (status: StatementStatus.lapsed, effect: none);
    if (s.nationId != currentNationId) return lapsed;
    final cycleOver = s.cycle < currentCycle;
    switch (s.kind) {
      case StatementKind.winNext:
      case StatementKind.jobOnTheLine:
        final after = [
          for (final x in matches)
            if (x.date.isAfter(s.madeOn)) x,
        ]..sort((a, b) => a.date.compareTo(b.date));
        final need = s.kind == StatementKind.winNext ? 1 : jobWindow;
        if (after.length < need) return cycleOver ? lapsed : null;
        final wins = after.take(need).where((x) => x.scored > x.conceded).length;
        if (s.kind == StatementKind.winNext) {
          return wins == 1
              ? (status: StatementStatus.kept, effect: winNextKept)
              : (status: StatementStatus.broken, effect: winNextBroken);
        }
        return wins >= 2
            ? (status: StatementStatus.kept, effect: jobKept)
            : (status: StatementStatus.broken, effect: jobBroken);
      case StatementKind.backPlayer:
      case StatementKind.blamePlayer:
        final after = [
          for (final x in appearances)
            if (x.date.isAfter(s.madeOn)) x,
        ]..sort((a, b) => a.date.compareTo(b.date));
        if (after.length < playerWindow) return cycleOver ? lapsed : null;
        final mean =
            after.take(playerWindow).map((x) => x.rating).reduce((a, b) => a + b) /
            playerWindow;
        final cameGood = mean >= playerBar;
        if (s.kind == StatementKind.backPlayer) {
          return cameGood
              ? (status: StatementStatus.kept, effect: backKept)
              : (status: StatementStatus.broken, effect: backBroken);
        }
        return cameGood
            ? (status: StatementStatus.broken, effect: none)
            : (status: StatementStatus.kept, effect: blameStood);
    }
  }

  /// Player id → rating shift the record puts on him: an open blame is −2, a
  /// backing that came good within [backingDays] is +1.
  static Map<int, int> conditionDeltas(Iterable<PressStatement> all, DateTime asOf) {
    final out = <int, int>{};
    for (final s in all) {
      final id = s.playerId;
      if (id == null) continue;
      if (s.kind == StatementKind.blamePlayer && s.status == StatementStatus.open) {
        out[id] = (out[id] ?? 0) - 2;
      } else if (s.kind == StatementKind.backPlayer &&
          s.status == StatementStatus.kept &&
          s.judgedOn != null &&
          asOf.difference(s.judgedOn!).inDays <= backingDays) {
        out[id] = (out[id] ?? 0) + 1;
      }
    }
    return out;
  }
}

enum CredibilityBand { low, mid, high }

/// How far the room believes him. Derived from the record, never stored.
abstract final class Credibility {
  static const int start = 50;
  static const int keptStep = 8;
  static const int brokenStep = -10;
  static const int deflectStep = -2;

  static int of(Iterable<PressStatement> statements, {required int deflects}) {
    var c = start + deflects * deflectStep;
    for (final s in statements) {
      if (s.status == StatementStatus.kept) c += keptStep;
      if (s.status == StatementStatus.broken) c += brokenStep;
    }
    return c.clamp(0, 100);
  }

  static CredibilityBand band(int c) => c < 35
      ? CredibilityBand.low
      : c > 65
      ? CredibilityBand.high
      : CredibilityBand.mid;

  /// How hard an answer lands: ×0.6 with no credibility, ×1.4 with full.
  static double multiplier(int c) => 0.6 + 0.8 * c / 100;
}
```

Note: `Credibility.of` applies steps in order and clamps only at the end; the "20 broken" test expects 0, which the final clamp gives.

- [ ] **Step 4: Run, expect PASS.**
- [ ] **Step 5: Commit** `feat(press): statement judge and credibility`.

---

### Task 3: ConferenceTrigger and ConferenceBuilder

**Files:**
- Modify: `lib/domain/services/press/conference.dart`
- Test: `test/unit/press/conference_trigger_test.dart`, `test/unit/press/conference_builder_test.dart`

**Interfaces:**
- Consumes: `ResultStanding` (`expectation.dart:10`), `PressEffect`, Task 1/2 types.
- Produces:

```dart
typedef OwnMatch = ({
  int fixtureId, DateTime date, int scored, int conceded,
  bool knockout, bool lastGroupMatch, ResultStanding standing,
}); // competitive matches only

abstract final class ConferenceTrigger {
  static const int quietDays = 45;
  static const int maxPerCycle = 6;
  static const int crisisBoardBelow = 40;
  static const int runLength = 3;
  static ConferenceReason? reasonFor({
    required List<OwnMatch> played, // his competitive matches, any order
    required int board,
    required bool jobJustBroken,
    required int conferencesThisCycle,
    required DateTime? lastConference,
  });
}

enum BeatKind { moment, whoToBlame, ifYouDont, standout, struggler, followUp, throwback }
enum AnswerKind {
  creditPlayers, takeResponsibility, demandMore, promiseWinNext, jobOnTheLine,
  backPlayer, blamePlayer, deflect, takeCredit, standByIt, admitMistake,
}

```

```dart
typedef ConferenceFacts = ({
  ConferenceReason reason,
  int? bestPlayerId,  // his side's best rated player IN this match
  int? worstPlayerId, // his side's worst rated player IN this match
  bool hasOpenWinNext,
  bool hasOpenJob,
  Set<int> playersWithOpenStatement,
  PressStatement? throwback, // judged (kept/broken), not yet thrown back
});

typedef Beat = ({BeatKind kind, List<AnswerKind> answers, int? playerId});

abstract final class ConferenceBuilder {
  static Beat opening(ConferenceFacts f);
  static Beat reaction(ConferenceFacts f, AnswerKind first);
  static Beat? throwback(ConferenceFacts f);
  static StatementKind? statementOf(AnswerKind a);
  static PressEffect effectOf(AnswerKind a, int credibility);
  static bool asksAboutFuture(Beat b, ConferenceReason r);
}
```

- [ ] **Step 1: Write the failing trigger tests**

```dart
// test/unit/press/conference_trigger_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/press/conference.dart';
import 'package:fnm/domain/services/press/expectation.dart';

OwnMatch om(int day, int s, int c, {ResultStanding standing = ResultStanding.par,
    bool knockout = false, bool last = false}) => (
  fixtureId: day, date: DateTime.utc(2030, 1, 1).add(Duration(days: day)),
  scored: s, conceded: c, knockout: knockout, lastGroupMatch: last, standing: standing,
);

ConferenceReason? reason(List<OwnMatch> played, {int board = 60, bool job = false,
    int count = 0, DateTime? last}) => ConferenceTrigger.reasonFor(
  played: played, board: board, jobJustBroken: job,
  conferencesThisCycle: count, lastConference: last,
);

void main() {
  test('nothing before his first competitive match', () {
    expect(reason(const [], board: 10), isNull);
  });

  test('a heroic knockout win is a big win', () {
    expect(reason([om(10, 2, 0, standing: ResultStanding.heroic, knockout: true)]),
        ConferenceReason.bigWin);
  });

  test('a heroic win that changes nothing is not', () {
    expect(reason([om(10, 2, 0, standing: ResultStanding.heroic)]), isNull);
  });

  test('a humiliating loss on the last group matchday is a big loss', () {
    expect(reason([om(10, 0, 4, standing: ResultStanding.humiliating, last: true)]),
        ConferenceReason.bigLoss);
  });

  test('a heroic win that ends a winless run of three matters', () {
    expect(reason([om(1, 0, 1), om(2, 0, 0), om(3, 0, 2),
        om(10, 3, 0, standing: ResultStanding.heroic)]), ConferenceReason.bigWin);
  });

  test('three winless with two losses is a crisis; three draws are not', () {
    expect(reason([om(1, 0, 1), om(2, 0, 0), om(3, 0, 2)]), ConferenceReason.crisis);
    expect(reason([om(1, 0, 0), om(2, 1, 1), om(3, 2, 2)]), isNull);
  });

  test('a worried board is a crisis only after a match he did not win', () {
    expect(reason([om(1, 0, 1)], board: 39), ConferenceReason.crisis);
    expect(reason([om(1, 1, 0)], board: 39), isNull);
  });

  test('crisis outranks a big result', () {
    expect(reason([om(1, 0, 1), om(2, 0, 2),
        om(3, 0, 5, standing: ResultStanding.humiliating, knockout: true)]),
        ConferenceReason.crisis);
  });

  test('45 quiet days, which only a broken job promise breaks', () {
    final played = [om(10, 0, 1), om(20, 0, 0), om(30, 0, 2)];
    final last = DateTime.utc(2030, 1, 1).add(const Duration(days: 0));
    expect(reason(played, last: last), isNull);
    expect(reason(played, last: last, job: true), ConferenceReason.jobVerdict);
  });

  test('six a cycle at most, except a job verdict', () {
    final played = [om(1, 0, 1), om(2, 0, 0), om(3, 0, 2)];
    expect(reason(played, count: 6), isNull);
    expect(reason(played, count: 6, job: true), ConferenceReason.jobVerdict);
  });
}
```

- [ ] **Step 2: Write the failing builder tests**

```dart
// test/unit/press/conference_builder_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/press/conference.dart';
import 'package:fnm/domain/services/press/statement.dart';

ConferenceFacts facts(ConferenceReason r, {int? best = 7, int? worst = 8,
    bool openWin = false, bool openJob = false, Set<int> open = const {},
    PressStatement? throwback}) => (
  reason: r, bestPlayerId: best, worstPlayerId: worst, hasOpenWinNext: openWin,
  hasOpenJob: openJob, playersWithOpenStatement: open, throwback: throwback,
);

void main() {
  test('only a crisis or a job verdict asks about his future', () {
    for (final r in ConferenceReason.values) {
      final f = facts(r);
      final beats = [
        ConferenceBuilder.opening(f),
        for (final a in ConferenceBuilder.opening(f).answers) ConferenceBuilder.reaction(f, a),
      ];
      final asks = beats.any((b) => ConferenceBuilder.asksAboutFuture(b, r));
      expect(asks, r == ConferenceReason.crisis || r == ConferenceReason.jobVerdict,
          reason: r.name);
    }
  });

  test('no free answer: every opening has something that costs', () {
    for (final r in ConferenceReason.values) {
      final answers = ConferenceBuilder.opening(facts(r)).answers;
      expect(answers.length, inInclusiveRange(3, 4));
      expect(answers.where((a) => a != AnswerKind.deflect).every((a) {
        final e = ConferenceBuilder.effectOf(a, 50);
        return e.morale != 0 || e.board != 0;
      }), isTrue);
    }
  });

  test('a promise is not offered twice while one is open', () {
    expect(ConferenceBuilder.opening(facts(ConferenceReason.bigLoss, openWin: true)).answers,
        isNot(contains(AnswerKind.promiseWinNext)));
    expect(ConferenceBuilder.opening(facts(ConferenceReason.crisis, openJob: true)).answers,
        isNot(contains(AnswerKind.jobOnTheLine)));
  });

  test('demanding more asks who, naming his worst player of the match', () {
    final b = ConferenceBuilder.reaction(facts(ConferenceReason.bigLoss), AnswerKind.demandMore);
    expect(b.kind, BeatKind.whoToBlame);
    expect(b.playerId, 8);
    expect(b.answers, contains(AnswerKind.blamePlayer));
  });

  test('nobody to name means a follow-up about the result', () {
    final b = ConferenceBuilder.reaction(
        facts(ConferenceReason.bigLoss, worst: null), AnswerKind.demandMore);
    expect(b.kind, BeatKind.followUp);
    expect(b.playerId, isNull);
  });

  test('a player already on the record is not named again', () {
    final b = ConferenceBuilder.reaction(
        facts(ConferenceReason.bigWin, open: {7}), AnswerKind.creditPlayers);
    expect(b.kind, BeatKind.followUp);
  });

  test('a promise is met with "and if you don\'t?"', () {
    final b = ConferenceBuilder.reaction(facts(ConferenceReason.bigLoss), AnswerKind.promiseWinNext);
    expect(b.kind, BeatKind.ifYouDont);
    expect(b.answers, contains(AnswerKind.jobOnTheLine));
  });

  test('a throwback only when something is due, with answers to its verdict', () {
    expect(ConferenceBuilder.throwback(facts(ConferenceReason.bigWin)), isNull);
    PressStatement s(StatementStatus status) => (
      id: 1, cycle: 0, nationId: 1, kind: StatementKind.backPlayer, playerId: 7,
      madeOn: DateTime.utc(2030), madeAfterFixtureId: 1, status: status,
      judgedOn: DateTime.utc(2030, 2), thrownBack: false,
    );
    final kept = ConferenceBuilder.throwback(facts(ConferenceReason.bigWin, throwback: s(StatementStatus.kept)))!;
    expect(kept.answers, contains(AnswerKind.takeCredit));
    expect(kept.playerId, 7);
    final broken = ConferenceBuilder.throwback(facts(ConferenceReason.bigWin, throwback: s(StatementStatus.broken)))!;
    expect(broken.answers, contains(AnswerKind.admitMistake));
  });

  test('credibility scales effects', () {
    expect(ConferenceBuilder.effectOf(AnswerKind.demandMore, 100).board,
        greaterThan(ConferenceBuilder.effectOf(AnswerKind.demandMore, 0).board));
  });

  test('statement answers map to their kinds', () {
    expect(ConferenceBuilder.statementOf(AnswerKind.promiseWinNext), StatementKind.winNext);
    expect(ConferenceBuilder.statementOf(AnswerKind.jobOnTheLine), StatementKind.jobOnTheLine);
    expect(ConferenceBuilder.statementOf(AnswerKind.backPlayer), StatementKind.backPlayer);
    expect(ConferenceBuilder.statementOf(AnswerKind.blamePlayer), StatementKind.blamePlayer);
    expect(ConferenceBuilder.statementOf(AnswerKind.deflect), isNull);
  });
}
```

- [ ] **Step 3: Run both, expect failure.** Run: `flutter test test/unit/press/conference_trigger_test.dart test/unit/press/conference_builder_test.dart`

- [ ] **Step 4: Implement** in `conference.dart` (imports: `expectation.dart`, `press.dart show PressEffect`, `statement.dart`):

```dart
abstract final class ConferenceTrigger {
  static const int quietDays = 45;
  static const int maxPerCycle = 6;
  static const int crisisBoardBelow = 40;
  static const int runLength = 3;

  static ConferenceReason? reasonFor({
    required List<OwnMatch> played,
    required int board,
    required bool jobJustBroken,
    required int conferencesThisCycle,
    required DateTime? lastConference,
  }) {
    if (played.isEmpty) return null;
    if (jobJustBroken) return ConferenceReason.jobVerdict;
    final ms = [...played]..sort((a, b) => a.date.compareTo(b.date));
    final latest = ms.last;
    if (lastConference != null &&
        latest.date.difference(lastConference).inDays < quietDays) {
      return null;
    }
    if (conferencesThisCycle >= maxPerCycle) return null;

    bool won(OwnMatch m) => m.scored > m.conceded;
    // The trailing run ending at [end] (exclusive of later matches): its
    // length and kind (wins, or winless).
    ({int length, bool wins, int losses}) runEndingAt(int end) {
      if (end < 0) return (length: 0, wins: false, losses: 0);
      final kind = won(ms[end]);
      var n = 0;
      var losses = 0;
      for (var i = end; i >= 0 && won(ms[i]) == kind; i--) {
        n++;
        if (ms[i].scored < ms[i].conceded) losses++;
      }
      return (length: n, wins: kind, losses: losses);
    }

    final now = runEndingAt(ms.length - 1);
    final crisis =
        (!now.wins && now.length >= runLength && now.losses >= 2) ||
        (board < crisisBoardBelow && !won(latest));
    if (crisis) return ConferenceReason.crisis;

    final loud = latest.standing == ResultStanding.heroic ||
        latest.standing == ResultStanding.humiliating;
    if (!loud) return null;
    final before = runEndingAt(ms.length - 2);
    final endsRun = before.length >= runLength && before.wins != now.wins;
    final startsRun = now.length == runLength;
    if (!(latest.knockout || latest.lastGroupMatch || endsRun || startsRun)) {
      return null;
    }
    return latest.standing == ResultStanding.heroic
        ? ConferenceReason.bigWin
        : ConferenceReason.bigLoss;
  }
}

abstract final class ConferenceBuilder {
  static const Map<AnswerKind, PressEffect> _base = {
    AnswerKind.creditPlayers: (morale: 5, board: -2),
    AnswerKind.takeResponsibility: (morale: 3, board: -1),
    AnswerKind.demandMore: (morale: -4, board: 4),
    AnswerKind.promiseWinNext: (morale: 3, board: 2),
    AnswerKind.jobOnTheLine: (morale: 2, board: 3),
    AnswerKind.backPlayer: (morale: 3, board: 0),
    AnswerKind.blamePlayer: (morale: -2, board: 2),
    AnswerKind.deflect: (morale: 0, board: 0),
    AnswerKind.takeCredit: (morale: -1, board: 3),
    AnswerKind.standByIt: (morale: 1, board: -3),
    AnswerKind.admitMistake: (morale: 1, board: 1),
  };

  static PressEffect effectOf(AnswerKind a, int credibility) {
    final b = _base[a]!;
    final k = Credibility.multiplier(credibility);
    return (morale: (b.morale * k).round(), board: (b.board * k).round());
  }

  static StatementKind? statementOf(AnswerKind a) => switch (a) {
    AnswerKind.promiseWinNext => StatementKind.winNext,
    AnswerKind.jobOnTheLine => StatementKind.jobOnTheLine,
    AnswerKind.backPlayer => StatementKind.backPlayer,
    AnswerKind.blamePlayer => StatementKind.blamePlayer,
    _ => null,
  };

  static bool asksAboutFuture(Beat b, ConferenceReason r) =>
      b.kind == BeatKind.moment &&
      (r == ConferenceReason.crisis || r == ConferenceReason.jobVerdict);

  static Beat opening(ConferenceFacts f) {
    final answers = switch (f.reason) {
      ConferenceReason.bigWin => [
        AnswerKind.creditPlayers,
        AnswerKind.demandMore,
        if (!f.hasOpenWinNext) AnswerKind.promiseWinNext,
        AnswerKind.deflect,
      ],
      ConferenceReason.bigLoss => [
        AnswerKind.takeResponsibility,
        AnswerKind.demandMore,
        if (!f.hasOpenWinNext) AnswerKind.promiseWinNext,
        AnswerKind.deflect,
      ],
      ConferenceReason.crisis => [
        AnswerKind.takeResponsibility,
        AnswerKind.demandMore,
        if (!f.hasOpenJob) AnswerKind.jobOnTheLine,
        AnswerKind.deflect,
      ],
      ConferenceReason.jobVerdict => [
        AnswerKind.takeResponsibility,
        AnswerKind.creditPlayers,
        AnswerKind.deflect,
      ],
    };
    return (kind: BeatKind.moment, answers: answers, playerId: null);
  }

  static const Beat _followUp = (
    kind: BeatKind.followUp,
    answers: [AnswerKind.takeResponsibility, AnswerKind.demandMore, AnswerKind.deflect],
    playerId: null,
  );

  static int? _nameable(ConferenceFacts f, int? id) =>
      id == null || f.playersWithOpenStatement.contains(id) ? null : id;

  static Beat reaction(ConferenceFacts f, AnswerKind first) {
    switch (first) {
      case AnswerKind.demandMore:
        final worst = _nameable(f, f.worstPlayerId);
        if (worst == null) return _followUp;
        return (
          kind: BeatKind.whoToBlame,
          answers: [AnswerKind.blamePlayer, AnswerKind.takeResponsibility, AnswerKind.deflect],
          playerId: worst,
        );
      case AnswerKind.promiseWinNext:
        return (
          kind: BeatKind.ifYouDont,
          answers: [
            if (!f.hasOpenJob) AnswerKind.jobOnTheLine,
            AnswerKind.takeResponsibility,
            AnswerKind.deflect,
          ],
          playerId: null,
        );
      case AnswerKind.deflect:
        return _followUp;
      default:
        if (f.reason == ConferenceReason.bigWin) {
          final best = _nameable(f, f.bestPlayerId);
          if (best == null) return _followUp;
          return (
            kind: BeatKind.standout,
            answers: [AnswerKind.backPlayer, AnswerKind.creditPlayers, AnswerKind.deflect],
            playerId: best,
          );
        }
        final worst = _nameable(f, f.worstPlayerId);
        if (worst == null) return _followUp;
        return (
          kind: BeatKind.struggler,
          answers: [AnswerKind.backPlayer, AnswerKind.blamePlayer, AnswerKind.deflect],
          playerId: worst,
        );
    }
  }

  static Beat? throwback(ConferenceFacts f) {
    final s = f.throwback;
    if (s == null) return null;
    final kept = s.status == StatementStatus.kept;
    return (
      kind: BeatKind.throwback,
      answers: kept
          ? [AnswerKind.takeCredit, AnswerKind.creditPlayers, AnswerKind.deflect]
          : [AnswerKind.admitMistake, AnswerKind.standByIt, AnswerKind.deflect],
      playerId: s.playerId,
    );
  }
}
```

- [ ] **Step 5: Run both tests, expect PASS.** If "no free answer" fails for an `effectOf(..., 50)` that rounds to 0, raise that answer's base effect by 1 rather than special-casing the test.
- [ ] **Step 6: Run** `flutter test test/unit/l10n/domain_speaks_no_english_test.dart` (domain must have no English).
- [ ] **Step 7: Commit** `feat(press): conference trigger and builder`.

---

### Task 4: Condition term for statements

**Files:**
- Modify: `lib/domain/services/squad/condition.dart:87-110` (`Condition.of`)
- Modify: `lib/features/tactics/condition_providers.dart:89-145` (`squadConditionProvider`)
- Test: `test/unit/squad/condition_statement_test.dart`

**Interfaces:**
- Consumes: `StatementJudge.conditionDeltas` (Task 2), `CareerRepository.statements` (Task 1).
- Produces: `Condition.of(..., int statementDelta = 0)`.

- [ ] **Step 1: Failing test**

```dart
// test/unit/squad/condition_statement_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/squad/condition.dart';

void main() {
  test('the record shifts one player and nobody else', () {
    final asOf = DateTime.utc(2030, 3, 1);
    final base = Condition.of(const [7.0], [DateTime.utc(2030, 2, 1)], asOf, 0);
    final blamed = Condition.of(const [7.0], [DateTime.utc(2030, 2, 1)], asOf, 0,
        statementDelta: -2);
    expect(blamed.overallDelta, base.overallDelta - 2);
  });
}
```

- [ ] **Step 2: Run, expect failure** (unknown named parameter).
- [ ] **Step 3: Implement.** Add `int statementDelta = 0,` to `Condition.of`'s named parameters and add it into `net`: `(f.delta + tired + moraleDelta + campBonus + clubDelta + statementDelta).clamp(-9, ...)` (keep the existing clamp bounds). In `squadConditionProvider`, after `final asOf = career.inGameDate;`:

```dart
      // What he has said about a player on the record: an open public blame
      // weighs on the man, a backing that came good lifts him.
      final said = StatementJudge.conditionDeltas(
        await ref.watch(careerRepositoryProvider).statements(careerId),
        asOf,
      );
```

and pass `statementDelta: said[entry.key] ?? 0,` to `Condition.of`.

- [ ] **Step 4: Run** `flutter test test/unit/squad/` and expect PASS.
- [ ] **Step 5: Commit** `feat(press): statements shift the named player's condition`.

---

### Task 5: PressDesk (judge + trigger) and season hooks

**Files:**
- Create: `lib/features/press/press_desk.dart`
- Modify: `lib/features/hub/hub_providers.dart` (after `_gradeObjectivesIfDecided` at ~1406 in `_advance` and ~1778 in `_playPlayerMatch`, plus their invalidation blocks)
- Test: `test/unit/press/press_desk_test.dart`

**Interfaces:**
- Consumes: Tasks 1–3; `CompetitionRepository.fixturesForNation(careerId, nationId)`, `ratingsForFixture(careerId, fixtureId)`, `playerMatchHistory(careerId, playerId, limit:)`; `worldRankingProvider(careerId)` (`RankingData?` with `.position[id]`); `satisfactionProvider(careerId)` (0-100); `Expectation.standing(...)`; `Rounds.isKnockout`, `Rounds.friendly`; `CareerRepository.recordPressAnswer`.
- Produces: `class PressDesk { Future<void> afterMatches(int careerId); }`, `final Provider<PressDesk> pressDeskProvider`.

- [ ] **Step 1: Failing tests.** Build the DB the way `test/unit/hub/end_of_cycle_has_a_next_action_test.dart` does (container with `appDatabaseProvider`, `premiumUnlockedProvider`, `seedSourceProvider` from `assets/data/nations.json` and an EMPTY player list, `ensureSeeded`, `careerServiceProvider.create(nationId:, managerName: 'M', rngSeed: 7)`). Then write played fixtures directly through `competitionRepositoryProvider.recordResult` (read its signature in `competition_repository.dart`) for the career's own unplayed fixtures returned by `fixturesForNation`. Tests:

```dart
test('nothing is called before his first competitive match', () async {
  await desk.afterMatches(careerId);
  expect(await repo.conferences(careerId), isEmpty);
});

test('a pending conference from an earlier cycle is skipped', () async {
  final id = await repo.recordConference(careerId: careerId, cycle: -1,
      reason: ConferenceReason.crisis, fixtureId: 1, triggeredOn: DateTime.utc(2020));
  await desk.afterMatches(careerId);
  expect((await repo.conferences(careerId)).firstWhere((c) => c.id == id).status,
      ConferenceStatus.skipped);
});

test('a broken job promise is judged once and calls a job-verdict conference', () async {
  // record three losses after a jobOnTheLine statement made before them
  ...
  await desk.afterMatches(careerId);
  await desk.afterMatches(careerId); // idempotent
  final s = (await repo.statements(careerId)).single;
  expect(s.status, StatementStatus.broken);
  final stmtRows = (await repo.pressAnswers(careerId))
      .where((a) => a.questionKey == 'stmt:${s.id}');
  expect(stmtRows, hasLength(1));
  expect((await repo.conferences(careerId)).last.reason, ConferenceReason.jobVerdict);
});

test('running twice for the same match calls one conference', () async {
  // three losses -> crisis
  ...
  await desk.afterMatches(careerId);
  await desk.afterMatches(careerId);
  expect(await repo.conferences(careerId), hasLength(1));
});
```

Fill the `...` with concrete `recordResult` calls on the first three of the career's own competitive fixtures (sorted by date), setting `inGameDate` past them with `careerRepository.updateInGameDate`. For the job test, insert the statement with `madeOn` one day before the first of those fixtures and `nationId: career.nationId`.

- [ ] **Step 2: Run, expect failure** (no `press_desk.dart`).

- [ ] **Step 3: Implement `press_desk.dart`**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/competition/rounds.dart';
import 'package:fnm/domain/services/press/conference.dart';
import 'package:fnm/domain/services/press/expectation.dart';
import 'package:fnm/domain/services/press/statement.dart';
import 'package:fnm/features/achievements/achievement_providers.dart';
import 'package:fnm/features/press/press_providers.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';

/// The press's side of the season: after the manager's matches are in, judge
/// what he said and decide whether the room is called. Idempotent, and called
/// from both ways a match of his is committed (the live screen and the
/// quick-sim inside `advance`).
class PressDesk {
  PressDesk(this._ref);

  final Ref _ref;

  /// An unheld conference older than this is no longer news.
  static const int staleDays = 14;

  Future<void> afterMatches(int careerId) async {
    final careers = _ref.read(careerRepositoryProvider);
    final comp = _ref.read(competitionRepositoryProvider);
    final career = await careers.byId(careerId);
    if (career == null) return;
    final now = career.inGameDate;

    final all = await comp.fixturesForNation(careerId, career.nationId);
    final own = [
      for (final f in all)
        if (f.hasResult) f,
    ]..sort((a, b) => a.date.compareTo(b.date));
    final competitive = [
      for (final f in own)
        if (f.round != Rounds.friendly) f,
    ];
    int mine(Fixture f) =>
        f.homeNationId == career.nationId ? f.homeScore! : f.awayScore!;
    int theirs(Fixture f) =>
        f.homeNationId == career.nationId ? f.awayScore! : f.homeScore!;

    // 1. Judge.
    var jobJustBroken = false;
    for (final s in await careers.statements(careerId)) {
      if (s.status != StatementStatus.open) continue;
      final apps = s.playerId == null
          ? const <Appearance>[]
          : [
              for (final h in await comp.playerMatchHistory(
                careerId,
                s.playerId!,
                limit: 30,
              ))
                (fixtureId: h.fixtureId, date: h.date, rating: h.rating),
            ];
      final v = StatementJudge.judge(
        s,
        matches: [
          for (final f in competitive)
            (fixtureId: f.id, date: f.date, scored: mine(f), conceded: theirs(f)),
        ],
        appearances: apps,
        currentNationId: career.nationId,
        currentCycle: career.cyclePointer,
      );
      if (v == null) continue;
      await careers.judgeStatement(s.id, status: v.status, judgedOn: now);
      if (v.effect.morale != 0 || v.effect.board != 0) {
        await careers.recordPressAnswer(
          careerId: careerId,
          cycle: career.cyclePointer,
          questionKey: 'stmt:${s.id}',
          tone: v.status.name,
          moraleDelta: v.effect.morale,
          boardDelta: v.effect.board,
          answeredAt: now,
        );
      }
      if (s.kind == StatementKind.jobOnTheLine &&
          v.status == StatementStatus.broken) {
        jobJustBroken = true;
      }
    }

    // 2. Retire stale invitations.
    final calls = await careers.conferences(careerId);
    for (final c in calls) {
      if (c.status == ConferenceStatus.pending &&
          (c.cycle != career.cyclePointer ||
              now.difference(c.triggeredOn).inDays > staleDays)) {
        await careers.setConferenceStatus(c.id, ConferenceStatus.skipped);
      }
    }

    // 3. Call the room, at most once per match.
    if (competitive.isEmpty) return;
    final latest = competitive.last;
    if (calls.any((c) => c.fixtureId == latest.id)) return;
    final ranking = await _ref.read(worldRankingProvider(careerId).future);
    int rankOf(int id) => ranking?.position[id] ?? 100;
    final played = [
      for (final f in competitive)
        (
          fixtureId: f.id,
          date: f.date,
          scored: mine(f),
          conceded: theirs(f),
          knockout: Rounds.isKnockout(f.round),
          // The group's last game for him: nothing of his left to play in it.
          lastGroupMatch: f.groupId != null &&
              !all.any(
                (o) =>
                    o.competitionId == f.competitionId &&
                    o.groupId == f.groupId &&
                    o.matchday > f.matchday,
              ),
          standing: Expectation.standing(
            nationRank: rankOf(career.nationId),
            opponentRank: rankOf(
              f.homeNationId == career.nationId ? f.awayNationId : f.homeNationId,
            ),
            scored: mine(f),
            conceded: theirs(f),
          ),
        ),
    ];
    _ref.invalidate(pressEffectProvider(careerId));
    final board = await _ref.read(satisfactionProvider(careerId).future);
    final thisCycle = [
      for (final c in calls)
        if (c.cycle == career.cyclePointer) c,
    ];
    final reason = ConferenceTrigger.reasonFor(
      played: played,
      board: board,
      jobJustBroken: jobJustBroken,
      conferencesThisCycle: thisCycle.length,
      lastConference: calls.isEmpty ? null : calls.last.triggeredOn,
    );
    if (reason == null) return;
    for (final c in calls) {
      if (c.status == ConferenceStatus.pending) {
        await careers.setConferenceStatus(c.id, ConferenceStatus.skipped);
      }
    }
    await careers.recordConference(
      careerId: careerId,
      cycle: career.cyclePointer,
      reason: reason,
      fixtureId: latest.id,
      triggeredOn: latest.date,
    );
  }
}

final Provider<PressDesk> pressDeskProvider = Provider<PressDesk>(PressDesk.new);
```

- [ ] **Step 4: Hook it into `SeasonService`.** In `hub_providers.dart`, right after each `await _gradeObjectivesIfDecided(careerId);` (in `_advance` ~1406 and `_playPlayerMatch` ~1778) add:

```dart
    // The press: judge what he said and decide whether the room is called,
    // now that his result is in (both ways a match of his is committed).
    await _ref.read(pressDeskProvider).afterMatches(careerId);
```

and add `..invalidate(pendingConferenceProvider)..invalidate(pressStatementsProvider)..invalidate(pressEffectProvider)` to both invalidation blocks (those providers are created in Task 6; until then add only `pressEffectProvider`, and add the other two in Task 6 Step 5).

- [ ] **Step 5: Run** `flutter test test/unit/press/press_desk_test.dart test/unit/hub/` and expect PASS (hub tests must not regress).
- [ ] **Step 6: Commit** `feat(press): press desk judges statements and calls conferences`.

---

### Task 6: Providers and PressService

**Files:**
- Rewrite: `lib/features/press/press_providers.dart` (the old question provider, tone history, needle, mood provider go; keep nothing that depends on `PressTopic`)
- Modify: `lib/domain/services/press/press.dart` (add `carryOver`)
- Test: `test/unit/press/press_effect_carry_test.dart`, `test/unit/press/press_service_test.dart`

**Interfaces:**
- Consumes: Tasks 1–3, 5.
- Produces:

```dart
typedef PendingConference = ({
  PressConferenceRow row,
  ConferenceFacts facts,
  int credibility,
  int opponentNationId,
});
final AutoDisposeFutureProviderFamily<PendingConference?, int> pendingConferenceProvider;
final AutoDisposeFutureProviderFamily<List<PressStatement>, int> pressStatementsProvider;
final AutoDisposeFutureProviderFamily<int, int> credibilityProvider;
final AutoDisposeFutureProviderFamily<PressEffect, int> pressEffectProvider; // same name/type as today
class PressService {
  Future<PressEffect> answer(int careerId, PendingConference c, int beatIndex, Beat beat, AnswerKind a);
  Future<void> finish(int careerId, int conferenceId);
}
final Provider<PressService> pressServiceProvider;
// in press.dart:
static PressEffect carryOver(Iterable<PressEffect> current, Iterable<PressEffect> previous);
```

- [ ] **Step 1: Failing tests**

```dart
// test/unit/press/press_effect_carry_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/press/press.dart';

void main() {
  test('half of last cycle carries in, the caps still hold', () {
    expect(Press.carryOver([(morale: 4, board: 2)], [(morale: 6, board: -4)]),
        (morale: 7, board: 0));
    expect(Press.carryOver([(morale: 12, board: 10)], [(morale: 12, board: 10)]),
        (morale: 12, board: 10));
  });
}
```

`press_service_test.dart` (container + in-memory DB as in Task 5): store a pending conference for a played fixture; `answer(..., AnswerKind.promiseWinNext)` records a `press_answers` row keyed `conf:<id>:0` with tone `promiseWinNext` and one open `winNext` statement whose `madeOn` is the fixture's date and `madeAfterFixtureId` its id; answering a throwback beat marks that statement thrown back; `finish` marks the conference held; a `grv:` row in `press_answers` does not change `pressEffectProvider`.

- [ ] **Step 2: Run, expect failure.**

- [ ] **Step 3: Implement.** `Press.carryOver`:

```dart
  /// This cycle's press, plus half of last cycle's: what was said lingers
  /// rather than vanishing at the turn of the cycle. Capped like [totalOf].
  static PressEffect carryOver(
    Iterable<PressEffect> current,
    Iterable<PressEffect> previous,
  ) {
    final prev = totalOf(previous);
    return totalOf([
      ...current,
      (morale: prev.morale ~/ 2, board: prev.board ~/ 2),
    ]);
  }
```

`press_providers.dart` (new content; keep the file's import style):

```dart
bool _counts(PressAnswerRow a) => !a.questionKey.startsWith('grv:');

final AutoDisposeFutureProviderFamily<List<PressStatement>, int>
pressStatementsProvider = FutureProvider.autoDispose
    .family<List<PressStatement>, int>(
      (ref, careerId) => ref.watch(careerRepositoryProvider).statements(careerId),
    );

final AutoDisposeFutureProviderFamily<int, int> credibilityProvider =
    FutureProvider.autoDispose.family<int, int>((ref, careerId) async {
      final statements = await ref.watch(pressStatementsProvider(careerId).future);
      final answers = await ref.watch(careerRepositoryProvider).pressAnswers(careerId);
      final deflects = answers
          .where((a) => a.questionKey.startsWith('conf:') && a.tone == AnswerKind.deflect.name)
          .length;
      return Credibility.of(statements, deflects: deflects);
    });

final AutoDisposeFutureProviderFamily<PressEffect, int> pressEffectProvider =
    FutureProvider.autoDispose.family<PressEffect, int>((ref, careerId) async {
      final repo = ref.watch(careerRepositoryProvider);
      final career = await repo.byId(careerId);
      if (career == null) return (morale: 0, board: 0);
      PressEffect of(PressAnswerRow a) => (morale: a.moraleDelta, board: a.boardDelta);
      final now = await repo.pressAnswers(careerId, cycle: career.cyclePointer);
      final before = career.cyclePointer == 0
          ? const <PressAnswerRow>[]
          : await repo.pressAnswers(careerId, cycle: career.cyclePointer - 1);
      return Press.carryOver(
        [for (final a in now) if (_counts(a)) of(a)],
        [for (final a in before) if (_counts(a)) of(a)],
      );
    });

typedef PendingConference = ({
  PressConferenceRow row,
  ConferenceFacts facts,
  int credibility,
  int opponentNationId,
});

final AutoDisposeFutureProviderFamily<PendingConference?, int>
pendingConferenceProvider = FutureProvider.autoDispose
    .family<PendingConference?, int>((ref, careerId) async {
      final repo = ref.watch(careerRepositoryProvider);
      final comp = ref.watch(competitionRepositoryProvider);
      final career = await repo.byId(careerId);
      if (career == null) return null;
      final calls = await repo.conferences(careerId);
      final pending = calls.where((c) => c.status == ConferenceStatus.pending);
      if (pending.isEmpty) return null;
      final row = pending.last;
      final fixture = (await comp.fixturesForNation(careerId, career.nationId))
          .where((f) => f.id == row.fixtureId)
          .firstOrNull;
      if (fixture == null) return null;
      final lines = [
        for (final r in await comp.ratingsForFixture(careerId, fixture.id))
          if (r.nationId == career.nationId) r,
      ]..sort((a, b) => b.rating.compareTo(a.rating));
      final statements = await ref.watch(pressStatementsProvider(careerId).future);
      final open = [
        for (final s in statements)
          if (s.status == StatementStatus.open) s,
      ];
      final due = [
        for (final s in statements)
          if ((s.status == StatementStatus.kept || s.status == StatementStatus.broken) &&
              !s.thrownBack)
            s,
      ];
      return (
        row: row,
        facts: (
          reason: row.reason,
          bestPlayerId: lines.isEmpty ? null : lines.first.playerId,
          worstPlayerId: lines.length < 2 ? null : lines.last.playerId,
          hasOpenWinNext: open.any((s) => s.kind == StatementKind.winNext),
          hasOpenJob: open.any((s) => s.kind == StatementKind.jobOnTheLine),
          playersWithOpenStatement: {for (final s in open) if (s.playerId != null) s.playerId!},
          throwback: due.isEmpty ? null : due.first,
        ),
        credibility: await ref.watch(credibilityProvider(careerId).future),
        opponentNationId: fixture.homeNationId == career.nationId
            ? fixture.awayNationId
            : fixture.homeNationId,
      );
    });

class PressService {
  PressService(this._ref);
  final Ref _ref;

  Future<PressEffect> answer(
    int careerId,
    PendingConference c,
    int beatIndex,
    Beat beat,
    AnswerKind a,
  ) async {
    final repo = _ref.read(careerRepositoryProvider);
    final career = (await repo.byId(careerId))!;
    final effect = ConferenceBuilder.effectOf(a, c.credibility);
    await repo.recordPressAnswer(
      careerId: careerId,
      cycle: career.cyclePointer,
      questionKey: 'conf:${c.row.id}:$beatIndex',
      tone: a.name,
      moraleDelta: effect.morale,
      boardDelta: effect.board,
      answeredAt: career.inGameDate,
    );
    final kind = ConferenceBuilder.statementOf(a);
    if (kind != null) {
      await repo.recordStatement(
        careerId: careerId,
        cycle: career.cyclePointer,
        nationId: career.nationId,
        kind: kind,
        playerId: beat.playerId,
        madeOn: c.row.triggeredOn,
        madeAfterFixtureId: c.row.fixtureId,
      );
    }
    if (beat.kind == BeatKind.throwback && c.facts.throwback != null) {
      await repo.markThrownBack(c.facts.throwback!.id);
    }
    return effect;
  }

  Future<void> finish(int careerId, int conferenceId) async {
    await _ref
        .read(careerRepositoryProvider)
        .setConferenceStatus(conferenceId, ConferenceStatus.held);
    _ref
      ..invalidate(pendingConferenceProvider(careerId))
      ..invalidate(pressStatementsProvider(careerId))
      ..invalidate(credibilityProvider(careerId))
      ..invalidate(pressEffectProvider(careerId));
  }
}

final Provider<PressService> pressServiceProvider = Provider<PressService>(PressService.new);
```

Note `beat.playerId` for `promiseWinNext`/`jobOnTheLine` is null by construction (moment and ifYouDont beats carry no player).

- [ ] **Step 4: Fix compile fallout** from removing the old providers (`pressQuestionProvider`, `pressToneHistoryProvider`, `pressMoodProvider`, `squadStoriesProvider`/`opponentStoriesProvider` invalidations): `hub_event.dart` and `hub_screen.dart` move in Task 8; for now point them at `pendingConferenceProvider` (event: `await ref.watch(pendingConferenceProvider(careerId).future) != null`; screen: read it and pass to the sheet once Task 7 lands, so temporarily leave the screen case returning early). Run `flutter analyze lib` until clean of errors.

- [ ] **Step 5: Add** `..invalidate(pendingConferenceProvider)..invalidate(pressStatementsProvider)` to both `SeasonService` invalidation blocks (Task 5 Step 4).
- [ ] **Step 6: Run** `flutter test test/unit/press/press_effect_carry_test.dart test/unit/press/press_service_test.dart` and expect PASS.
- [ ] **Step 7: Commit** `feat(press): conference providers and press service`.

---

### Task 7: Copy (EN + CS) and press_copy.dart

**Files:**
- Modify: `lib/l10n/app_en.arb`, `lib/l10n/app_cs.arb`
- Create: `lib/features/press/press_copy.dart`
- Regenerate: `lib/l10n/app_localizations*.dart`, `copy/strings.csv`
- Test: `test/widget/press_copy_test.dart` (rewrite: the old one walks `PressTopic`)

**Interfaces:**
- Consumes: `BeatKind`, `AnswerKind`, `ConferenceReason`, `CredibilityBand`, `StatementKind`, `StatementStatus`.
- Produces:

```dart
String beatQuestion(AppLocalizations l, Beat beat, PendingConference c, {required String? playerName, required String opponentName, required int seed});
String answerLabel(AppLocalizations l, AnswerKind a, {required String? playerName, required int seed});
String? onRecordLine(AppLocalizations l, AnswerKind a, {required String? playerName});
```

**Key schema** (every key exists in BOTH ARBs; EN entries get `"@key": {"description": "Press conference: ..."}` plus a `placeholders` map where used):

| Family | Keys | Placeholders |
|---|---|---|
| Moment questions | `pressMoment{BigWin,BigLoss,Crisis,JobVerdict}{Warm,Neutral,Hostile}{1,2}` (24) | `{opponent}` |
| Reaction questions | `pressBeat{WhoToBlame,IfYouDont,FollowUp}{Warm,Neutral,Hostile}{1,2}` (18) | none |
| Player questions | `pressBeat{Standout,Struggler}{Warm,Neutral,Hostile}{1,2}` (12) | `{player}` |
| Throwbacks | `pressThrowback{WinNext,Job}{Kept,Broken}{Warm,Neutral,Hostile}` (12) | none |
| Player throwbacks | `pressThrowback{Back,Blame}{Kept,Broken}{Warm,Neutral,Hostile}` (12) | `{player}` |
| Answers | `pressReply{CreditPlayers,TakeResponsibility,DemandMore,PromiseWinNext,JobOnTheLine,Deflect,TakeCredit,StandByIt,AdmitMistake}{1..4}` (36) | none |
| Player answers | `pressReply{BackPlayer,BlamePlayer}{1..4}` (8) | `{player}` |
| On the record | `pressOnRecordWinNext`, `pressOnRecordJob` (none), `pressOnRecordBack`, `pressOnRecordBlame` (`{player}`) | as noted |

Writing rules for the copy (this is authored in the task, not pasted from the plan):
- Questions are things a reporter says; warm/neutral/hostile is the reporter's attitude to the MANAGER (credibility), not to the result.
- Only `pressMoment{Crisis,JobVerdict}*` may mention his job, his future, resigning or being sacked. No other key may (the guard test greps for it).
- `pressBeatIfYouDont*` asks what happens if the promise fails, without resignation words.
- Throwback `Blame` + `Kept` = he stayed poor (the manager was right); `Blame` + `Broken` = he responded.
- Answers are first person, short (under ~110 characters), and the four variants of one answer say the same thing four ways.
- On-record lines are terse: EN "On the record: you will win the next match.", "On the record: judge you on the next three.", "On the record: backing {player}.", "On the record: {player} let you down."
- Reuse fitting lines from the retired `pressAsk*`/`pressAnswer*` keys where they fit the new families.

- [ ] **Step 1: Failing guard test** (`test/widget/press_copy_test.dart`, replacing the old file):

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/press/conference.dart';
import 'package:fnm/features/press/press_copy.dart';
import 'package:fnm/l10n/app_localizations.dart';

void main() {
  for (final locale in const [Locale('en'), Locale('cs')]) {
    test('${locale.languageCode}: every answer has words, none of them empty', () async {
      final l = await AppLocalizations.delegate.load(locale);
      for (final a in AnswerKind.values) {
        for (var seed = 0; seed < 8; seed++) {
          final text = answerLabel(l, a, playerName: 'Novák', seed: seed);
          expect(text.trim(), isNotEmpty, reason: a.name);
          expect(text.contains('—'), isFalse, reason: 'em dash in ${a.name}');
        }
      }
    });
  }

  test('only crisis and job-verdict questions talk about his job', () async {
    final l = await AppLocalizations.delegate.load(const Locale('en'));
    final job = RegExp(r'resign|sack|your job|your future|step down', caseSensitive: false);
    // Walk every beat kind for every reason via press_copy's helper that lists
    // all question variants: expose `allQuestionVariants(l)` returning
    // (ConferenceReason?, BeatKind, String) triples for this test.
    for (final (reason, kind, text) in allQuestionVariants(l)) {
      final allowed = kind == BeatKind.moment &&
          (reason == ConferenceReason.crisis || reason == ConferenceReason.jobVerdict);
      if (!allowed) expect(job.hasMatch(text), isFalse, reason: '$reason $kind: $text');
    }
  });
}
```

Add `allQuestionVariants(AppLocalizations l)` to `press_copy.dart` (filled with placeholder names) so the test can see every question wording.

- [ ] **Step 2: Run, expect failure.**
- [ ] **Step 3: Write the copy** in both ARBs per the schema and rules, then `flutter gen-l10n`.
- [ ] **Step 4: Implement `press_copy.dart`.** Variant choice: `pick(list, seed) => list[seed.abs() % list.length]`. Question band from `Credibility.band(c.credibility)`: low → Hostile, mid → Neutral, high → Warm; `{1,2}` chosen by seed. Throwback key from `c.facts.throwback!.kind` and `.status` plus band. Answers pick `{1..4}` by seed. Write each mapping as an exhaustive `switch` over the enums so a new enum value fails to compile.
- [ ] **Step 5: Run** `flutter test test/widget/press_copy_test.dart test/unit/l10n/` and expect PASS; run `dart run tool/export_copy.dart`.
- [ ] **Step 6: Commit** ARBs, generated l10n, `copy/strings.csv`, `press_copy.dart`, test: `feat(press): conference copy in English and Czech`.

---

### Task 8: PressSheet rewrite and hub wiring

**Files:**
- Rewrite: `lib/features/press/press_sheet.dart` (keep `AnswerTile`, `_Swing`, `_Byline`, `_Verdict` and their look; drop topic/tone/probe/needle code)
- Modify: `lib/features/hub/hub_event.dart:429-453, 558-566`, `lib/features/hub/hub_screen.dart:653-675`
- Test: `test/widget/press_conference_test.dart`; update `test/widget/press_arrows_test.dart`, `test/unit/hub/press_during_watched_finals_test.dart`

**Interfaces:**
- Consumes: `PendingConference`, `ConferenceBuilder`, `PressService`, `press_copy.dart`, `Press.roomFor`, `Press.verdictOf`, `Press.totalOf`.
- Produces: `PressSheet({required int careerId, required PendingConference conference, required Map<int, String> playerNames, required String opponentName, super.key})`.

- [ ] **Step 1: Failing widget test** (`press_conference_test.dart`): pump `PressSheet` with a hand-built `PendingConference` (`reason: bigLoss`, worst player 8 named "Novák", a kept `backPlayer` throwback), override `pressServiceProvider` with a fake recording `answer` calls and `finish`. Tap the first `demandMore` answer: expect the second question to contain "Novák" and an answer that `onRecordLine` marks; tap the blame answer: expect "On the record: Novák let you down." visible; then the throwback question appears as question 3 of 3; answer it; expect the verdict card; tap leave: expect `finish` called once with the conference id.

- [ ] **Step 2: Run, expect failure.**
- [ ] **Step 3: Implement the sheet.** State: `final _beats = <Beat>[ConferenceBuilder.opening(facts)]`, `_said = <AnswerKind>[]`, `_total = <PressEffect>[]`, `_room = Press.roomFor(varietySeed('conf:${row.id}'))`. Length shown as `_said.isEmpty ? (throwback == null ? 2 : 3) : ...` (fixed after the first answer: 2 + (throwback != null ? 1 : 0)). On answer: `await service.answer(...)`; append to `_said`/`_total`; if `_said.length == 1` push `ConferenceBuilder.reaction(facts, a)`; else if `_said.length == 2` and throwback beat exists push it; otherwise show `_Verdict`. Each `AnswerTile` shows `ConferenceBuilder.effectOf(a, credibility)` arrows and, under statement answers, the `onRecordLine` in `AppTypography.labelSmall` / `AppColors.primary`. Leaving calls `service.finish(careerId, row.id)` then pops. Reporter per beat: `_room[i % _room.length]`; question text from `beatQuestion`.
- [ ] **Step 4: Hub wiring.** In both `hub_event.dart` spots replace `pressQuestionProvider(careerId)` with `pendingConferenceProvider(careerId)` (keep the watched-finals ordering logic as is). In `hub_screen.dart` `case HubEventKind.press`: read `pendingConferenceProvider(careerId).valueOrNull`; build `playerNames` from `ref.read(playerRepositoryProvider).byNation(...)` (same call as `squadConditionProvider`, keyed id → name) for the best/worst/throwback ids; `opponentName` from `hub.nations[conference.opponentNationId]?.name ?? ''`; open `PressSheet` as before.
- [ ] **Step 5: Update** `press_during_watched_finals_test.dart` to create its press state by inserting a pending conference with `recordConference` instead of relying on the old derived question, keeping its assertions about ordering. Update `test/widget/press_arrows_test.dart` to the new `AnswerTile` usage or delete it if `AnswerTile`'s API is unchanged and covered by `press_conference_test`.
- [ ] **Step 6: Run** `flutter test test/widget/press_conference_test.dart test/unit/hub/ test/widget/` and expect PASS.
- [ ] **Step 7: Commit** `feat(press): beat-based press sheet on the hub`.

---

### Task 9: Y feed posts for judged statements

**Files:**
- Modify: `lib/domain/services/press/y_feed.dart` (`YTemplate` enum ~68, `variantsFor` ~306, `moodOf` ~1273, new `forStatement`)
- Modify: `lib/features/y/y_providers.dart:89-401` (gather), `lib/features/y/y_screen.dart:24` (`yPostBody`)
- Modify: ARBs (`yStatementKept0..5`, `yStatementBroken0..5` with `{nation}`), regenerate, export copy
- Test: `test/unit/press/y_statement_test.dart`

**Interfaces:**
- Consumes: `PressStatement`; `YFeed._post(voice:, template:, args:, date:, key:, nation:, seed:, tone:)` (see `forGrievance`, y_providers.dart:333-344, for a complete example).
- Produces: `static List<YPost> forStatement({required PressStatement s, required String nation, required int seed})` returning one post (plus `repliesTo` replies like `forGrievance` does) for a `kept` or `broken` statement, none for `open`/`lapsed`; key `stmt:${s.id}`; date `s.judgedOn!`.

- [ ] **Step 1: Failing test**: a kept and a broken statement each produce exactly one top-level post with template `statementKept`/`statementBroken`; open and lapsed produce none; two calls give identical posts (deterministic).
- [ ] **Step 2: Run, expect failure.**
- [ ] **Step 3: Implement**: add `statementKept, statementBroken` to `YTemplate`; `variantsFor` → `subjectVariantCount` (6, tone-banded); `moodOf` → kept positive, broken negative (match how `forGrievance` sets mood); write `forStatement` mirroring `forGrievance`. In `yFeedProvider`, read `pressStatementsProvider(careerId)` and add `YFeed.forStatement(...)` for each judged one with the career's nation name. In `yPostBody` map both templates' indices to the new ARB keys. Write the 12 EN + 12 CS lines (fan voices reacting to "he said X and it happened / did not"; no em dashes). `flutter gen-l10n`; export copy.
- [ ] **Step 4: Run** `flutter test test/unit/press/y_statement_test.dart test/unit/press/y_feed_test.dart` and expect PASS.
- [ ] **Step 5: Commit** `feat(press): the feed remembers what he said`.

---

### Task 10: Retire the old press system

**Files:**
- Modify: `lib/domain/services/press/press.dart` (remove `PressTone`, `PressTopic`, `PressSubject`, `PressProbe`, `PressQuestion`, `PressExchange`, `pick`, `silences`, `precedenceOf`, `effectOf`, `effectInContext`, `effectOfExchange`, `lengthFor`, `maxConferenceLength`, `openingExchange`, `followUp`, `probeAfter`, `closingProbe`, `_tonesFor`, `quietDays`; KEEP `PressEffect`, `PressVerdict`, `PressAngle`, `PressReporter`, `roomFor`, `_reporters`, `verdictOf`, `arrowsFor`, `totalOf`, `carryOver`)
- Delete or rewrite: `test/unit/press/press_test.dart`, `press_variety_test.dart`, `press_context_test.dart`, `press_context_effect_test.dart`, `press_suppression_test.dart`, `press_incident_test.dart`, `press_relevance_test.dart`, `press_subject_order_test.dart`, `press_day_one_test.dart`, `press_squad_test.dart` (delete each whose subject no longer exists; move any still-meaningful assertion about `verdictOf`/`arrowsFor`/`roomFor` into `test/unit/press/press_core_test.dart`)
- Check: `squad_stories.dart`, `half_time_swing.dart`, `story_providers.dart`, `y_incident_test.dart`, `y_subject_test.dart`, `seeded_honour_not_mine_test.dart`: KEEP anything the Y feed still uses; remove only press-only paths
- Modify: ARBs: delete `pressAsk*`, `pressProbe*`, `pressAnswer*` (old per-tone answers), `pressNeedle*` and any other key no longer referenced (verify with grep in `lib/` after regenerating)

- [ ] **Step 1: Remove the code** listed above, then `flutter analyze lib test` and fix every error by deleting the dependent dead code (never by stubbing).
- [ ] **Step 2: Remove dead ARB keys**: for each `"press...":` key in `app_en.arb`, grep `lib/` for `l.<key>` / `.<key>(`; delete unreferenced keys from BOTH ARBs; `flutter gen-l10n`; `dart run tool/export_copy.dart`.
- [ ] **Step 3: Run the full suite**: `flutter test`. Expect PASS.
- [ ] **Step 4: Commit** `refactor(press): retire topics, tones and probes`.

---

### Task 11: Long-sim cadence test and tuning

**Files:**
- Create: `test/unit/press/press_cadence_test.dart`
- Possibly tune: constants in `conference.dart` / `statement.dart`

**Interfaces:**
- Consumes: the season loop pattern of `test/unit/hub/end_of_cycle_has_a_next_action_test.dart` (container setup, ceremony clearing via `comp.markDrawWatched`, `trainingCampServiceProvider.choose`, `season.startNextCycle` on `HubEventKind.cycleRollover`, otherwise `season.advance`), `CareerRepository.conferences`.

- [ ] **Step 1: Write the test.** Copy the loop from `end_of_cycle_has_a_next_action_test.dart` (seeds `[1, 7, 2026, 8080]`, two full cycles each, timeout 8 minutes). Never answer press. After the run:

```dart
final calls = await c.read(careerRepositoryProvider).conferences(careerId);
final perCycle = <int, int>{};
for (final x in calls) {
  perCycle[x.cycle] = (perCycle[x.cycle] ?? 0) + 1;
}
// Ceiling holds (a job verdict may exceed it, but nothing answers press here,
// so no statement exists and no job verdict can occur).
expect(perCycle.values.every((n) => n <= ConferenceTrigger.maxPerCycle), isTrue,
    reason: '$perCycle');
// No conference before his first competitive match.
final first = (await comp.fixturesForNation(careerId, nationId))
    .where((f) => f.hasResult && f.round != Rounds.friendly)
    .map((f) => f.date)
    .reduce((a, b) => a.isBefore(b) ? a : b);
expect(calls.every((x) => !x.triggeredOn.isBefore(first)), isTrue);
// Quiet period between consecutive calls.
for (var i = 1; i < calls.length; i++) {
  expect(calls[i].triggeredOn.difference(calls[i - 1].triggeredOn).inDays,
      greaterThanOrEqualTo(ConferenceTrigger.quietDays));
}
print('seed $seed conferences per cycle: $perCycle');
```

and, across all seeds, `expect(mean, inInclusiveRange(2.0, 6.0))` where `mean` is the average count per completed cycle.

- [ ] **Step 2: Run**: `flutter test test/unit/press/press_cadence_test.dart`. If the mean is outside 2–6, tune ONLY `quietDays`, the "matters" rules, or `crisisBoardBelow` (in that order), rerun, and note the final numbers in the spec's Amendments.
- [ ] **Step 3: Full suite**: `flutter test`. Expect PASS.
- [ ] **Step 4: Commit** `test(press): conference cadence over full cycles`.

---

## Self-Review Notes

- Spec coverage: triggers/cadence (T3, T5, T11), stored conferences (T1, T5), beats and gates (T3, T7, T8), statements and judging (T1, T2, T5), per-player term (T4), credibility hidden + tone bands (T2, T6, T7), carry-over (T6), grievance filter (T6), bundle (T1), Y feed (T9), cleanup (T10), copy rules (T7, T9), long-sim (T11).
- Out of scope per spec: tournament-milestone conferences, `outOfGroup`/`reachRound` promises, visible credibility, style claims.
