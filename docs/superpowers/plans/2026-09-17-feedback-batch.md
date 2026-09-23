# Feedback batch 2026-09-17 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Land 35 pieces of playtest feedback (one item is answered, not worked) as one reviewed batch: close the gates that are implemented in one place and not asked in another, show the manager the effects the engine has always applied, fill the holes in recorded history, and make a nation's standing matter.

**Architecture:** Seven areas, executed in dependency order. Data and schema first (the honours bump is the only migration, and later history work reads it), then selection rules, then the visibility layer that reads existing engine numbers without inventing a parallel model, then press and feed, then the standing pass, then dashboard and presentation. Every rule change is a pure function in `lib/domain/services/` with a unit test; every screen change reads a provider and gets a widget test.

**Tech Stack:** Flutter, Riverpod (manual providers, no codegen), Drift, freezed, go_router, `flutter_test`.

**Spec:** `docs/superpowers/specs/2026-09-17-feedback-batch-design.md`

## Global Constraints

Every task's requirements implicitly include all of these.

- **Riverpod without codegen.** Never add `@riverpod`. Its codegen package pins an older `analyzer` that conflicts with `drift_dev`. Write manual providers.
- **Drift codegen needs the JIT flag:** `dart run build_runner build --delete-conflicting-outputs --force-jit`. Without `--force-jit` the sqlite3 build hook fails.
- **All user-facing text is localised.** Add the string to `lib/l10n/app_en.arb` AND `lib/l10n/app_cs.arb`, run `flutter gen-l10n`, then `dart run tool/export_copy.dart` so `copy/strings.csv` stays in sync. Never hardcode a user-facing string in a widget.
- **No em dashes in user-facing copy.** Code comments may use them; strings in the `.arb` files may not.
- **Never "World Cup" in English user-facing copy.** It is the **World Championship**. Stored competition names are canonical and translated at display time. A guard test enforces this; do not weaken it.
- **The two simulators move together.** Any balance change to `lib/domain/services/match/match_engine.dart` must be mirrored in the background simulator, or live and simulated football desync.
- **Derived providers go stale.** After any simulation step, invalidate the providers that read the database imperatively. A provider that is not invalidated grades against a pre-tournament snapshot.
- **Schema bumps preserve saves.** From `firstManagedVersion` on, every bump is a recorded stepwise migration. Follow the five-step recipe in `lib/data/db/app_database.dart:117-127`.
- **The analyzer stays at zero errors.** `flutter analyze` reports ~595 `info`-level lints as its baseline; that is fine. `error •` count must remain 0.
- **Run the full suite before each commit:** `flutter test`.

## Out of scope

Türkiye stays. It is the current official English name. No work.

---

## Area 1: History and the schema

### Task 1: Honours record every host, not just the first

A co-hosted edition stores one host (`Honours.hostId`), so a World Championship shared by three nations shows one flag in history and the manager's own co-hosted tournament reads as somebody else's.

**Files:**
- Modify: `lib/data/db/tables.dart:642-666` (the `Honours` table)
- Modify: `lib/data/db/app_database.dart:83` (schema version), and the `stepByStep` block for the new step
- Modify: `lib/data/db/schema_versions.dart` (generated stub, then filled in)
- Modify: `lib/domain/repositories/competition_repository.dart:177-192` (the `Honour` typedef), and `recordHonour`
- Modify: `lib/data/repositories/drift_competition_repository.dart` (around `:1493`, the honours insert and the row mapper)
- Test: `test/unit/data/schema_migration_test.dart`, `test/unit/competition/honour_cohosts_test.dart` (create)

**Interfaces:**
- Produces: `Honour` gains `List<int> hostIds` (empty when nothing was recorded). `hostId` stays as the primary host so existing call sites keep working; `hostIds` is the full list, primary first.
- Produces: `CompetitionRepository.recordHonour(... , List<int> hostIds = const [])`.

- [ ] **Step 1: Write the failing test**

Create `test/unit/competition/honour_cohosts_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/repositories/drift_competition_repository.dart';

import '../../helpers/test_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('a co-hosted edition keeps every host, primary first', () async {
    final db = createTestDatabase();
    addTearDown(db.close);
    final repo = DriftCompetitionRepository(db);
    final careerId = await aCareer(db);

    await repo.recordHonour(
      careerId: careerId,
      year: 2026,
      competition: 'World Championship',
      championId: 1,
      runnerUpId: 2,
      thirdId: 3,
      hostIds: const [10, 11, 12],
    );

    final honours = await repo.honours(careerId);
    expect(honours.single.hostId, 10);
    expect(honours.single.hostIds, [10, 11, 12]);
  });

  test('a single-host edition reads back one host', () async {
    final db = createTestDatabase();
    addTearDown(db.close);
    final repo = DriftCompetitionRepository(db);
    final careerId = await aCareer(db);

    await repo.recordHonour(
      careerId: careerId,
      year: 2030,
      competition: 'World Championship',
      championId: 1,
      runnerUpId: 2,
      hostIds: const [7],
    );

    final honours = await repo.honours(careerId);
    expect(honours.single.hostIds, [7]);
  });
}
```

`createTestDatabase()` is the real helper (`test/helpers/test_database.dart:6`); there is no career-seeding helper yet. Write `aCareer(db)` as a local helper in this test file, following the setup in `test/unit/competition/lazy_wc_qualifying_test.dart:29-58`: a `ProviderContainer` overriding `appDatabaseProvider` and `seedSourceProvider`, `seedLoaderProvider.ensureSeeded()`, then `careerServiceProvider.create(nationId:, managerName:)`. If a later task needs the same helper, lift it into `test/helpers/` then, not now.

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/unit/competition/honour_cohosts_test.dart`
Expected: FAIL — `hostIds` is not defined on `Honour`, and `recordHonour` has no `hostIds` parameter.

- [ ] **Step 3: Add the column and bump the schema**

In `lib/data/db/tables.dart`, inside `Honours`:

```dart
  /// Every host of this edition, primary first, comma-separated ("10,11,12").
  ///
  /// [hostId] holds the primary host on its own and stays authoritative for
  /// the single-host case. A co-hosted tournament used to lose everyone but
  /// the first, so a shared edition read as one country's in the history.
  /// Recorded rather than re-derived: a roll of honour must hold what
  /// happened, not what a host-rotation function would say today.
  TextColumn get hostIds => text().nullable()();
```

Then:
1. `lib/data/db/app_database.dart:83` — `currentSchemaVersion = 46`.
2. `dart run drift_dev schema dump lib/data/db/app_database.dart drift_schemas/`
3. `dart run drift_dev schema steps drift_schemas/ lib/data/db/schema_versions.dart`
4. Fill the new callback in the `stepByStep` block in `app_database.dart`:

```dart
        // 45 → 46 records every host of an edition, not only the first. Purely
        // additive and nullable: an existing honour simply has no list, and
        // reads back as its single stored [hostId], which is what it was.
        from45To46: (m, schema) async {
          await m.addColumn(schema.honours, schema.honours.hostIds);
        },
```
5. `dart run drift_dev schema generate drift_schemas/ test/generated_migrations/` and extend `test/unit/data/schema_migration_test.dart` with the 45→46 step following the pattern already in that file.
6. `dart run build_runner build --delete-conflicting-outputs --force-jit`

- [ ] **Step 4: Thread `hostIds` through the repository**

In `lib/domain/repositories/competition_repository.dart`, add to the `Honour` typedef:

```dart
  /// Every host, primary first. Single-element for an ordinary edition, empty
  /// only for a historical row that never recorded one.
  List<int> hostIds,
```

Add `List<int> hostIds = const []` to the `recordHonour` signature. In `drift_competition_repository.dart`, write `hostIds.join(',')` on insert (null when empty), and on read parse it back, falling back to `[hostId]` when the column is null so pre-migration rows still answer the question.

- [ ] **Step 5: Run the tests**

Run: `flutter test test/unit/competition/honour_cohosts_test.dart test/unit/data/schema_migration_test.dart`
Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add -A
git commit -m "feat: a co-hosted edition keeps every host in the record

Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>"
```

---

### Task 2: Every screen that names a host names all of them

**Files:**
- Modify: `lib/features/tournaments/cup_detail_screen.dart`, `lib/features/tournaments/continental_detail_screen.dart`, `lib/features/tournaments/tournament_history.dart` — wherever a stored honour's host is rendered
- Modify: wherever honours are recorded, to pass the full host list (grep `recordHonour(`)
- Test: `test/widget/honour_cohost_row_test.dart` (create)

**Interfaces:**
- Consumes: `Honour.hostIds` from Task 1.

- [ ] **Step 1: Find every caller**

```bash
grep -rn "recordHonour(" lib --include="*.dart"
grep -rn "hostId" lib/features/tournaments --include="*.dart"
```

Every recording site that knows the tournament's hosts (the World Championship crowning path already computes `WorldCupHosts.hostsFor`) passes the whole list.

- [ ] **Step 2: Write the failing widget test**

Create `test/widget/honour_cohost_row_test.dart` asserting that a history row built from an honour with `hostIds: [10, 11, 12]` renders all three nation codes, and one with a single host renders exactly one. Use `test/helpers/pump_app.dart` for the harness, following an existing widget test in `test/widget/` for the setup shape.

- [ ] **Step 3: Run it to verify it fails**

Run: `flutter test test/widget/honour_cohost_row_test.dart`
Expected: FAIL — only the primary host renders.

- [ ] **Step 4: Render the list**

Where a single host flag/code is shown, render each of `hostIds` (falling back to `hostId` when the list is empty). Keep the row on one line at phone width: codes, not full names, when there is more than one host.

- [ ] **Step 5: Run the tests**

Run: `flutter test test/widget/honour_cohost_row_test.dart && flutter test`
Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add -A
git commit -m "feat: history names every host of a shared edition

Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>"
```

---

### Task 3: WC 2026 enters the record

`lib/domain/services/competition/real_history.dart:299` deliberately omits 2026 because a save opens on 1 July 2026 while that tournament is being played. The manager expects to find it in history. Seed it with a fixed champion and its three co-hosts, which also exercises Task 1 end to end.

**Files:**
- Modify: `lib/domain/services/competition/real_history.dart` (the entry list, around `:299`; and the host handling so an entry can carry more than one host nation name)
- Test: `test/unit/competition/real_history_test.dart` (extend, or create if absent)

**Interfaces:**
- Consumes: `recordHonour(..., hostIds:)` from Task 1.
- Produces: the seeded entry record gains `hosts` (a `List<String>` of nation names) alongside the existing single `host`, or `host` becomes a list — pick one and apply it to every entry in the file so there is one shape, not two.

- [ ] **Step 1: Write the failing test**

```dart
test('the 2026 World Championship is in the seeded history, with its hosts', () {
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
```

The real names are `RealHistory.editions` (a `List<HistoryEdition>`) and the record typedef `HistoryEdition` at `real_history.dart:12-21`, whose host field is today a single `String host`.

- [ ] **Step 2: Run it to verify it fails**

Run: `flutter test test/unit/competition/real_history_test.dart`
Expected: FAIL — no 2026 entry.

- [ ] **Step 3: Add the entry and widen host to a list**

Widen `HistoryEdition.host` (`String`) to `hosts` (`List<String>`) and migrate every existing edition literal to a single-element list, so the file has one shape rather than two. **Do not research historical co-hosts**: editions that really were shared (2002, Euro 2000/2008/2012/2020) keep the single host they store today. Correcting real history is not in this batch. Then replace the "2026 is deliberately ABSENT" comment with the edition:

```dart
    (
      year: 2026,
      competition: worldChampionship,
      hosts: ['United States', 'Canada', 'Mexico'],
      champion: 'Spain',
      runnerUp: 'Argentina',
      third: 'France',
      finalHome: 2,
      finalAway: 1,
    ),
```

The comment that replaces the old one must say what changed and why: the edition is now seeded as finished, because a manager opening a save looks for it and finding nothing reads as a hole in the world rather than as a tournament still in progress.

Resolve the host names to nation ids the same way the existing loader resolves `champion`/`runnerUp`, and pass them as `hostIds`.

- [ ] **Step 4: Run the tests**

Run: `flutter test test/unit/competition/real_history_test.dart test/unit/competition/honour_cohosts_test.dart`
Expected: PASS.

- [ ] **Step 5: Verify in a real save**

Start a new career and open the World Championship history. 2026 is listed, with three hosts.

- [ ] **Step 6: Commit**

```bash
git add -A
git commit -m "feat: the 2026 World Championship is part of the world's history

Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>"
```

---

### Task 4: Scorers in future editions have names

Top-scorer lists in later World Championships mostly read "Unknown". The name comes from `playerRepository.byId(...)` (see `lib/features/tournaments/cup_detail_providers.dart:212-219`); when that returns null the UI falls back to the literal `'Unknown'`.

**Files:**
- Modify: `lib/features/tournaments/cup_detail_providers.dart:207-219` and any sibling provider doing the same resolution (grep for `playerNames`)
- Modify: `lib/data/repositories/drift_player_repository.dart:181` (`byId`) if the cause is there
- Test: `test/unit/records/scorer_names_test.dart` (create)

**Interfaces:**
- Consumes: `PlayerRepository.byId(id, agingYears:, saveSeed:, youthBonusByCycle:, careerStartsByPlayer:)`.

- [ ] **Step 1: Reproduce it in a test before changing anything**

This is a debugging task, not a known fix. Write a test that resolves the scorer ids of a simulated future World Championship and asserts every one of them has a name:

```dart
test('every scorer in a future edition resolves to a name', () async {
  // Simulate forward to a World Championship several cycles out, take the
  // stored goal events for its finals competition, and resolve each scorer.
  final ids = await repo.topScorers(careerId,
      kind: CompetitionKind.worldCupFinals, limit: 15);
  for (final s in ids) {
    final p = await players.byId(s.playerId,
        saveSeed: career.rngSeed,
        agingYears: agingYears,
        youthBonusByCycle: youthBonus,
        careerStartsByPlayer: careerStarts);
    expect(p, isNotNull, reason: 'scorer ${s.playerId} has no name');
  }
});
```

Follow `test/unit/full_cycle_test.dart` for how to advance a save far enough that newgens are scoring.

- [ ] **Step 2: Run it and read the failure**

Run: `flutter test test/unit/records/scorer_names_test.dart`
Expected: FAIL, naming the ids that do not resolve. **Before writing any fix, establish which kind of id fails** — a newgen id (`PlayerLifecycle.isNewgenId`) whose intake year is outside the seeded window, or a seeded id whose row was deleted. The fix follows the answer.

- [ ] **Step 3: Fix at the cause**

Likely candidates, in order of probability:
- the provider passes no `agingYears` / `youthBonusByCycle` / `careerStartsByPlayer`, so a newgen cannot be reconstructed (the other call sites at `match_providers.dart:177-195` do pass them — compare);
- `newgenById` returns null for an intake year the reconstruction no longer covers.

Fix whichever it is. Keep the `'Unknown'` fallback: it is correct for a genuinely missing player, it just must stop being the common case.

- [ ] **Step 4: Run the tests**

Run: `flutter test test/unit/records/scorer_names_test.dart && flutter test`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add -A
git commit -m "fix: a scorer in a future edition has a name

Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>"
```

---

### Task 5: Holders on tournament detail

**Files:**
- Modify: `lib/features/tournaments/cup_detail_providers.dart` (expose the most recent honour as `holders`), `lib/features/tournaments/cup_detail_screen.dart`, `lib/features/tournaments/continental_detail_screen.dart`
- Modify: `lib/l10n/app_en.arb`, `lib/l10n/app_cs.arb`
- Test: `test/widget/tournament_holders_test.dart` (create)

**Interfaces:**
- Consumes: `CompetitionRepository.honours(careerId)` (newest first).
- Produces: the detail view model gains `({int nationId, int year})? holders` — the champion of the most recent completed edition of THIS competition, null before there is one.

- [ ] **Step 1: Write the failing widget test**

Assert that a tournament detail built with a previous edition in the honours list shows the holders' name and the year, and that a first-ever edition shows no holders row at all.

- [ ] **Step 2: Run it to verify it fails**

Run: `flutter test test/widget/tournament_holders_test.dart`
Expected: FAIL — no holders row exists.

- [ ] **Step 3: Implement**

In the provider, pick the newest honour whose `competition` matches this competition's stored name and whose year is before this edition's year. In the screen, render a compact row under the header: flag, nation, and the year they won it. New strings: `tourHolders` ("Holders") and `tourHoldersSince` with a `{year}` placeholder. Add both to `app_en.arb` and `app_cs.arb`, run `flutter gen-l10n`, then `dart run tool/export_copy.dart`.

- [ ] **Step 4: Run the tests**

Run: `flutter test test/widget/tournament_holders_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add -A
git commit -m "feat: a tournament says who holds it

Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>"
```

---

### Task 6: A team's strength across the career

**Files:**
- Modify: `lib/features/stats/team_overall_history.dart` (read it first — a rating-history spec already exists at `docs/superpowers/specs/2026-09-05-rating-history-design.md`; reuse what is there rather than building a second curve)
- Modify: the history screen that should carry it (`lib/features/career/manager_history_screen.dart` or `lib/features/stats/team_stats_screen.dart` — put it where the manager looks for history)
- Test: `test/widget/team_strength_history_test.dart` (create)

**Interfaces:**
- Produces: a widget taking `List<({int year, int overall})>` and drawing the curve.

- [ ] **Step 1: Read what already exists**

```bash
cat lib/features/stats/team_overall_history.dart
cat docs/superpowers/specs/2026-09-05-rating-history-design.md
```

If the curve already exists and is simply not shown in history, this task is wiring, not building. Say which it was in the commit message.

- [ ] **Step 2: Write the failing widget test**

Assert the history screen renders a strength point per year of the career, and renders nothing (no empty chart frame) for a career with one year.

- [ ] **Step 3: Run it to verify it fails**

Run: `flutter test test/widget/team_strength_history_test.dart`
Expected: FAIL.

- [ ] **Step 4: Implement**

Squad-average overall per year, from the pool as it stood each year — the same average the match header already shows, so one number means one thing across the app.

- [ ] **Step 5: Run the tests and commit**

```bash
flutter test test/widget/team_strength_history_test.dart
git add -A
git commit -m "feat: history shows where the side's strength has been

Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>"
```

---

### Task 7: All-time scorers mark who is still playing

`AllTimeScorer` already carries an active flag (`cup_detail_providers.dart:73`). Verify it is rendered everywhere an all-time list appears; where it is not, render it.

**Files:**
- Modify: `lib/features/tournaments/tournament_history.dart:100-140` (`TournamentScorers`), `lib/features/records/all_time_records_screen.dart`, `lib/features/nations/nation_vitrine_providers.dart:205` and its screen
- Test: `test/widget/all_time_scorers_active_test.dart` (create)

- [ ] **Step 1: Write the failing widget test**

Assert an all-time scorer list marks an active player distinctly from a retired one, in every list that shows all-time scorers.

- [ ] **Step 2: Run it to verify it fails**

Run: `flutter test test/widget/all_time_scorers_active_test.dart`
Expected: FAIL in whichever lists do not mark it.

- [ ] **Step 3: Implement**

One marker, used in every list: a small dot or a bolder name for a player still in the pool. `nation_vitrine_providers.dart:205` builds `ScorerRecord` without an active flag — give it one from the same source the cup detail provider uses.

- [ ] **Step 4: Run the tests and commit**

```bash
flutter test test/widget/all_time_scorers_active_test.dart
git add -A
git commit -m "feat: an all-time list says who is still playing

Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>"
```

---
## Area 2: Selection and availability

### Task 8: The call-up screen asks the right question

`SquadSelection.usableInPeriod` (`lib/domain/services/squad/squad_selection.dart:27-31`) already encodes the rule: a player is nameable when his ban or knock does not cover EVERY match the squad is being picked for. The screen asks a stricter, wrong question — `isAvailable` (`lib/features/tactics/call_up_screen.dart:231`) — which is "can he play the very next game".

**Files:**
- Modify: `lib/features/tactics/call_up_screen.dart:228-236` and its per-row availability rendering around `:786`
- Test: `test/unit/squad/squad_selection_test.dart` (extend), `test/widget/call_up_availability_test.dart` (create)

**Interfaces:**
- Consumes: `SquadSelection.usableInPeriod(PlayerAbsence?, int coverage)`; the camp's match count from the coverage window the screen already reads (`_CoverageBanner(window: window)` — `window.matches.length`).

- [ ] **Step 1: Write the failing test**

Create `test/widget/call_up_availability_test.dart`. Given a camp covering three matches:
- a player banned for one match may be selected, and his row says he misses one of the three;
- a player banned for three matches may not be selected;
- the "fit players" count that gates the confirm button counts the men who can play at least one of the matches, not only those available for the first.

- [ ] **Step 2: Run it to verify it fails**

Run: `flutter test test/widget/call_up_availability_test.dart`
Expected: FAIL — the one-match ban is treated as unavailable.

- [ ] **Step 3: Implement**

Replace the `isAvailable` filter at `:231` with `SquadSelection.usableInPeriod(data.absences[id], coverage)` where `coverage` is the camp's match count (1 when there is no window). The row label already distinguishes injury from ban (`:786`); extend it to say how many of the camp's matches the player misses.

Keep `kMinFitPlayers` meaning what it says — eleven men who can actually be fielded in a given match is still the gate; what changes is that a man missing only the first game counts toward the squad, not toward that match's eleven.

- [ ] **Step 4: Run the tests**

Run: `flutter test test/widget/call_up_availability_test.dart test/unit/squad/squad_selection_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add -A
git commit -m "fix: a one-game ban no longer costs a player the whole camp

Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>"
```

---

### Task 9: An injured player cannot be fielded

A player carrying `injuryMatches == 1` was named in the XI for the very match he is missing. `selectable()` (`lib/features/tactics/tactics_providers.dart:46`) filters him out, so something else put him there. **Find the cause before fixing anything.**

**Files:**
- Investigate: `lib/features/tactics/tactics_providers.dart:40-140`, `lib/features/tactics/tactics_screen.dart:160-180`, `lib/features/match/setup_warning.dart`, the lineup repair on save (grep `repairLineup` / `lineup_slots`)
- Test: `test/unit/tactics/injured_not_fieldable_test.dart` (create)

- [ ] **Step 1: Reproduce with a failing test**

```dart
test('a player injured for one match cannot be in the XI for it', () {
  final pool = [player(1), player(2), player(3)];
  final absences = {2: const PlayerAbsence(playerId: 2, injuryMatches: 1)};
  expect(selectable(pool, absences).map((p) => p.id), [1, 3]);
});
```

That much probably passes already — which is the point. Then write the test that actually fails, at the level where the bug lives: a stored XI naming player 2, loaded through the tactics provider, must not hand player 2 to the match. Work outward from `selectable` until a test fails.

- [ ] **Step 2: Run it and read the failure**

Run: `flutter test test/unit/tactics/injured_not_fieldable_test.dart`
Expected: FAIL at the layer that has the hole. Candidates, to check in this order:
1. the stored XI is loaded and used without re-checking absences (a lineup saved before the injury);
2. `bestEleven` / auto-pick runs over `pool` rather than `selectable(pool, absences)`;
3. absences load asynchronously and the XI is built from an empty map on first frame, then never rebuilt;
4. the match start path reads the stored lineup directly rather than through the provider that filters.

- [ ] **Step 3: Fix at the cause**

Whatever the layer, the rule belongs in ONE place: the XI handed to the match is filtered through absences at the point it is read, not repaired in the widget. Add the guard where the lineup becomes a `MatchTeam`, so no future screen can route around it.

- [ ] **Step 4: Run the tests**

Run: `flutter test test/unit/tactics/injured_not_fieldable_test.dart && flutter test`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add -A
git commit -m "fix: an injured man stays out of the eleven

Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>"
```

---

### Task 10: The substitution sheet shows who cannot come on, and lets a misclick be taken back

Two faults in `lib/features/tactics/in_match_tactics.dart`:
- the bench list gives no sign that a man has already been withdrawn or is carrying a knock. `injuredIds` and `sentOffIds` are known to the editor (`:106-115`) and painted on the pitch, but the list a manager picks from does not say;
- a change made inside the sheet cannot be taken back without leaving. `_withdrawn` is seeded once at open (`:163-166`), so the rules are right, but there is no way to reverse a slot the manager has just filled by accident.

**Files:**
- Modify: `lib/features/tactics/in_match_tactics.dart` (the player list rows, and `_setSlot` / a new undo)
- Modify: `lib/l10n/app_en.arb`, `lib/l10n/app_cs.arb`
- Test: `test/widget/in_match_sub_undo_test.dart` (create)

**Interfaces:**
- Consumes: `refusalToBringOn(...)` and `SubRefusal` from `lib/domain/services/tactics/substitution_rules.dart`. Do not reimplement the rules; ask them.

- [ ] **Step 1: Write the failing widget test**

```
- a bench player already withdrawn renders with a marker and is not tappable
- a bench player injured this match renders with a marker
- after putting a substitute into a slot, an "undo" restores the previous
  occupant and gives the substitution back (the counter returns to its
  previous value)
- undo is available only for changes made in this sheet, never for one
  committed earlier in the match
```

- [ ] **Step 2: Run it to verify it fails**

Run: `flutter test test/widget/in_match_sub_undo_test.dart`
Expected: FAIL — no markers, no undo.

- [ ] **Step 3: Implement the markers**

In the bench/squad list, each row asks `refusalToBringOn` for its player and renders accordingly: already off, sent off, or carrying a knock (`widget.injuredIds`). A row that cannot come on is visibly out and does not respond to a tap. New strings: `tacticsSubOffAlready`, `tacticsSubInjured`.

- [ ] **Step 4: Implement undo**

Keep a stack of the changes made since the sheet opened:

```dart
  /// The slot states this sheet has changed, newest last, so a misclick can be
  /// taken back. Only changes made HERE are undoable: a substitution made ten
  /// minutes ago is part of the match, not of this sheet.
  final List<({int slot, int? previous})> _undo = [];
```

`_setSlot` pushes `(slot: slot, previous: _lineup[slot])` before it writes. An undo button (enabled only while `_undo` is not empty) pops the last entry and restores it. Because `_subsUsed` and `_withdrawn` are both derived from the lineup against `widget.startingIds`, restoring the slot restores the count with no extra bookkeeping — verify that in the test rather than assuming it.

- [ ] **Step 5: Run the tests**

Run: `flutter test test/widget/in_match_sub_undo_test.dart && flutter test`
Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add -A
git commit -m "feat: the bench says who cannot come on, and a misclick can be taken back

Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>"
```

---

### Task 11: Set-piece takers are filled in, not blank

`SetPieceTakers` stores null to mean "let the engine pick" (`lib/features/tactics/set_piece_takers_providers.dart:8-9`), and the engine's automatic rule is the best `technical` outfielder for a penalty (`match_engine.dart:1251-1262`) and the best `technical` other than the scorer for a dead ball (`:1440-1448`). The manager sees an empty slot and has to guess.

**Files:**
- Create: `lib/domain/services/tactics/set_piece_picks.dart`
- Modify: `lib/features/tactics/tactics_screen.dart` (the takers UI), `lib/features/tactics/in_match_tactics.dart` (the same UI mid-match)
- Test: `test/unit/tactics/set_piece_picks_test.dart` (create)

**Interfaces:**
- Produces:

```dart
/// Who takes a set piece when the manager has not said, mirroring the engine's
/// own automatic choice so the screen shows what will actually happen.
abstract final class SetPiecePicks {
  static int? penalty(List<Player> xi);
  static int? deadBall(List<Player> xi);
}
```

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/tactics/set_piece_picks.dart';

void main() {
  test('the penalty falls to the best technical outfielder', () {
    final xi = [
      player(id: 1, position: PlayerPosition.gk, technical: 99),
      player(id: 2, position: PlayerPosition.cb, technical: 60),
      player(id: 3, position: PlayerPosition.am, technical: 88),
    ];
    expect(SetPiecePicks.penalty(xi), 3);
  });

  test('an empty eleven has no taker', () {
    expect(SetPiecePicks.penalty(const []), isNull);
  });
}
```

Write the `player(...)` builder the way `test/unit/squad/squad_selection_test.dart` does.

- [ ] **Step 2: Run it to verify it fails**

Run: `flutter test test/unit/tactics/set_piece_picks_test.dart`
Expected: FAIL — the file does not exist.

- [ ] **Step 3: Implement**

```dart
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';

/// Who takes a set piece when the manager has not said.
///
/// A deliberate duplicate of the engine's own automatic choice
/// (`MatchEngine._penaltyTaker` and `_setPieceTaker`): a screen that shows a
/// different taker than the one who actually steps up is worse than the blank
/// slot it replaced. If the engine's rule changes, this changes with it.
abstract final class SetPiecePicks {
  /// The best technical outfielder in [xi], or the best of whoever is there
  /// when a side is somehow all keepers. Null for an empty eleven.
  static int? penalty(List<Player> xi) {
    if (xi.isEmpty) return null;
    final outfield = xi
        .where((p) => p.position.category != PositionCategory.goalkeeper)
        .toList();
    final pool = outfield.isEmpty ? xi : outfield;
    return pool
        .reduce((a, b) => b.attributes.technical > a.attributes.technical ? b : a)
        .id;
  }

  /// The best technical player in [xi]. This is the engine's dead-ball rule
  /// without its "not the scorer" clause, which only exists at the moment a
  /// goal is being attributed and has no meaning on a team sheet.
  static int? deadBall(List<Player> xi) {
    if (xi.isEmpty) return null;
    return xi
        .reduce((a, b) => b.attributes.technical > a.attributes.technical ? b : a)
        .id;
  }
}
```

- [ ] **Step 4: Show the automatic pick in the UI**

In both taker pickers, a slot with no manual choice shows the automatic pick's name with a marker saying it is automatic (a new string `tacticsTakerAuto`). Recompute whenever the XI changes. A manual pick sticks until that player is out of the side, at which point the slot falls back to automatic — the store already treats null as automatic, so clear the stored id rather than inventing a second state.

- [ ] **Step 5: Run the tests**

Run: `flutter test test/unit/tactics/set_piece_picks_test.dart && flutter test`
Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add -A
git commit -m "feat: the set-piece slots say who is actually taking them

Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>"
```

---

## Area 3: Effects made visible

### Task 12: One reading of what is moving the side

Fatigue, club form, familiarity, morale, the captain and the staff room all move the side's strength today and none of them are shown. Build the reading ONCE, as a pure function over numbers that already exist, and let every screen render the same thing.

**Files:**
- Create: `lib/domain/services/match/strength_factors.dart`
- Test: `test/unit/match/strength_factors_test.dart` (create)

**Interfaces:**
- Produces:

```dart
/// One thing making the side stronger or weaker, in the manager's terms.
typedef StrengthFactor = ({
  StrengthFactorKind kind,
  /// Rating points, signed. Positive helps.
  int delta,
  /// The subject when there is one: a formation name, a player's name.
  String? subject,
});

enum StrengthFactorKind { familiarity, fatigue, clubForm, morale, captain, staff }

abstract final class StrengthFactors {
  /// Every factor currently acting on the side, biggest absolute first,
  /// dropping the ones that are doing nothing.
  static List<StrengthFactor> of({
    required double familiarity,
    required Map<int, PlayerCondition> conditionByPlayer,
    required int morale,
    required bool hasCaptain,
    required Map<StaffRole, StaffTier> staff,
  });
}
```

- [ ] **Step 1: Write the failing test**

```dart
test('a drilled shape and a tired squad both show up, biggest first', () {
  final factors = StrengthFactors.of(
    familiarity: 1,
    // PlayerCondition is a plain record typedef: build it inline with the
    // overallDelta the case needs rather than reaching for a helper.
    conditionByPlayer: {1: aCondition(overallDelta: -6), 2: aCondition(overallDelta: -4)},
    morale: 50,
    hasCaptain: false,
    staff: const {},
  );
  expect(factors.first.kind, StrengthFactorKind.fatigue);
  expect(factors.map((f) => f.kind), contains(StrengthFactorKind.familiarity));
  expect(factors.every((f) => f.delta != 0), isTrue);
});

test('a neutral side has nothing to report', () {
  expect(
    StrengthFactors.of(
      familiarity: 0,
      conditionByPlayer: const {},
      morale: 50,
      hasCaptain: false,
      staff: const {},
    ),
    isEmpty,
  );
});
```

- [ ] **Step 2: Run it to verify it fails**

Run: `flutter test test/unit/match/strength_factors_test.dart`
Expected: FAIL — the file does not exist.

- [ ] **Step 3: Implement**

Read the numbers from where they already live, converting each to rating points so one scale means one thing:
- familiarity: `TeamChemistry.factor(familiarity)` minus 1, times the side's rating, rounded — the multiplier expressed as points;
- fatigue and club form: sum the per-player `overallDelta` contributions from `PlayerCondition` (`lib/domain/services/squad/condition.dart`), split by cause so a tired squad and a squad in form at their clubs read as two different lines;
- morale, captain, staff: the same values those seams already apply.

Do not invent a number anywhere. If a factor's effect is not currently computed as points, express it as the points it is worth and say so in a comment.

- [ ] **Step 4: Run the tests and commit**

```bash
flutter test test/unit/match/strength_factors_test.dart
git add -A
git commit -m "feat: one reading of what is making the side stronger or weaker

Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>"
```

---

### Task 13: The manager can see it before he picks

**Files:**
- Create: `lib/features/match/strength_panel.dart`
- Modify: `lib/features/match/match_preview_screen.dart`
- Modify: `lib/l10n/app_en.arb`, `lib/l10n/app_cs.arb`
- Test: `test/widget/strength_panel_test.dart` (create)

**Interfaces:**
- Consumes: `StrengthFactors.of(...)` from Task 12, via a provider assembled from the existing condition, familiarity, morale, captain and staff providers.

- [ ] **Step 1: Write the failing widget test**

Assert the preview shows a line per factor with its direction and size, that a side with nothing acting on it shows no panel at all (not an empty box), and that the panel survives phone width without overflow.

- [ ] **Step 2: Run it to verify it fails**

Run: `flutter test test/widget/strength_panel_test.dart`
Expected: FAIL.

- [ ] **Step 3: Implement**

A compact list: label, signed points, and the subject when there is one ("4-3-3", "12 tired legs"). New strings, one per `StrengthFactorKind`, plus a heading. No em dashes.

Predictability is NOT in this panel and must not be added to it. It is what the opposition knows, not what the manager is told; that asymmetry is deliberate and older than this batch.

- [ ] **Step 4: Run the tests and commit**

```bash
flutter test test/widget/strength_panel_test.dart
git add -A
git commit -m "feat: the preview says what is helping and what is hurting

Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>"
```

---

### Task 14: Familiarity you can watch build

**Files:**
- Modify: `lib/features/tactics/tactics_screen.dart` (and `formation_picker.dart` if the shape list lives there)
- Modify: `lib/l10n/app_en.arb`, `lib/l10n/app_cs.arb`
- Test: `test/widget/familiarity_bar_test.dart` (create)

**Interfaces:**
- Consumes: the stored familiarity per formation (`lib/domain/repositories/tactic_familiarity_repository.dart`).

- [ ] **Step 1: Write the failing widget test**

Assert each formation in the picker shows a fill proportional to its stored familiarity, that a never-fielded shape reads as empty rather than absent, and that no predictability value appears anywhere in the rendered tree.

- [ ] **Step 2: Run it to verify it fails**

Run: `flutter test test/widget/familiarity_bar_test.dart`
Expected: FAIL.

- [ ] **Step 3: Implement**

A thin bar under each formation name, with a label banding the value ("new", "settling", "drilled"). Bands, not a percentage: the manager is being told how well his side knows the shape, not given a number to optimise.

- [ ] **Step 4: Run the tests and commit**

```bash
flutter test test/widget/familiarity_bar_test.dart
git add -A
git commit -m "feat: the tactics screen shows how drilled each shape is

Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>"
```

---

### Task 15: Staff say what they do

**Files:**
- Modify: `lib/features/manager/manager_screen.dart` (the staff room)
- Modify: `lib/domain/services/manager/staff.dart` if the effect of a tier is not currently expressible as a sentence
- Modify: `lib/l10n/app_en.arb`, `lib/l10n/app_cs.arb`
- Test: `test/widget/staff_effect_test.dart` (create)

- [ ] **Step 1: Write the failing widget test**

Assert each staff role shows the effect of the tier currently hired, in the units the manager already understands, and that an empty role says what hiring one would be worth.

- [ ] **Step 2: Run it to verify it fails**

Run: `flutter test test/widget/staff_effect_test.dart`
Expected: FAIL.

- [ ] **Step 3: Implement**

Read the real effect each role has at each tier from where it is applied (grep each `StaffRole` to find its seam) and state it. Do not write a marketing line: if the fitness coach is worth one rating point of fatigue recovery, the screen says one point.

- [ ] **Step 4: Run the tests and commit**

```bash
flutter test test/widget/staff_effect_test.dart
git add -A
git commit -m "feat: the staff room says what each hire is doing

Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>"
```

---

### Task 16: Tactics that bite

The only balance change in Area 3. `TeamChemistry.drilledBonus` is 0.07 and `readPenalty` 0.04 (`lib/domain/services/tactics/team_chemistry.dart:18-22`); the instruction effects sit in the engine.

**Files:**
- Modify: `lib/domain/services/tactics/team_chemistry.dart:18-22`
- Modify: `lib/domain/services/match/match_engine.dart` (instruction effects) AND the background simulator, together
- Test: `test/unit/tactics/team_chemistry_test.dart` (extend), `test/unit/match/tactics_swing_test.dart` (create)

- [ ] **Step 1: Write the guard test first**

Over a large number of seeded matches between two equal sides, one drilled and well-judged, the other neither: the drilled side's points-per-game advantage must land inside a stated band. Write the band as the intent ("a drilled side is worth roughly a goal every three or four games, not every game") and assert bounds either side of it, so the test catches both "still does nothing" and "runs away".

Follow `test/unit/match/` for how existing balance guards are written; there is already one for rating-gap response.

- [ ] **Step 2: Run it to verify it fails**

Run: `flutter test test/unit/match/tactics_swing_test.dart`
Expected: FAIL below the band — which is the complaint.

- [ ] **Step 3: Widen the effects**

Raise `drilledBonus` and the instruction effects together until the guard passes. Keep `readPenalty` proportionally below `drilledBonus` so continuity stays worth having. Update the doc comments with the new numbers and the reason: the previous values were small enough that the manager could not tell the dial was connected.

Mirror every change in the background simulator in the same commit.

- [ ] **Step 4: Run the tests**

Run: `flutter test test/unit/match test/unit/tactics`
Expected: PASS, including the existing rating-gap guard. If the rating-gap guard now fails, the change went too far.

- [ ] **Step 5: Commit**

```bash
git add -A
git commit -m "balance: a drilled, well-judged side wins more than it used to

Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>"
```

---
## Area 4: The press and the feed

### Task 17: The feed talks about every tournament, not only the Nations Cup

The manager saw posts about the Nations Cup and nothing about the continental championship. `_tournamentPosts` (`lib/features/y/y_providers.dart:342-449`) looks correct on inspection — `_coreRound` strips the `C`/`N` prefix and `YFeed.finalsRounds` covers the stripped codes — so the fault is somewhere the reading did not reach. **Reproduce before changing.**

**Files:**
- Investigate: `lib/features/y/y_providers.dart:342-449`, `:495-540`, `lib/domain/services/press/y_feed.dart:690-728`
- Test: `test/unit/press/y_tournament_coverage_test.dart` (create)

- [ ] **Step 1: Write the failing test**

A table-driven test over every finals competition the game runs — World Championship, each continental championship, Nations Cup — asserting each one produces at least one post when the nation plays it and finishes it:

```dart
for (final family in ['', 'C', 'N']) {
  test('a finished finals tournament in family "$family" produces posts', () async {
    // fixtures: a group stage and a knockout exit, round codes prefixed by
    // `family`, all with results, in one competition with a name.
    final posts = await tournamentPostsFor(family);
    expect(posts, isNotEmpty, reason: 'family "$family" said nothing');
  });
}
```

Extract whatever `_tournamentPosts` needs into a testable seam if it is not reachable from a test today; a private function that cannot be tested is part of this bug's cause.

- [ ] **Step 2: Run it and read the failure**

Run: `flutter test test/unit/press/y_tournament_coverage_test.dart`
Expected: at least one family FAILS. Check, in order: whether `names[entry.key]` is null for that competition (a competition with no stored name is skipped outright at `:371`), whether the continental competition's fixtures carry the round codes the test assumes, and whether the feed's outer date window drops posts dated at the tournament.

- [ ] **Step 3: Fix at the cause and keep the guard**

The table-driven test stays in the suite. This bug's shape — "one competition works and the others silently do not" — is exactly what a guard over every family prevents recurring.

- [ ] **Step 4: Run the tests**

Run: `flutter test test/unit/press && flutter test`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add -A
git commit -m "fix: the country tweets about every tournament, not just the one that worked

Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>"
```

---

### Task 18: The press asks about things that happened to this manager, recently

Two faults with one symptom:
- a tournament the nation never entered produces triumph and elimination questions. There is already a participant-check pattern in the codebase for live-finals routing (hosts' friendlies trip a naive check) — reuse it rather than writing a second one;
- `Press.askWindowDays` is 30 (`lib/domain/services/press/press.dart:205`), so a month-old result is still asked about after two more games have been played.

**Files:**
- Modify: `lib/features/press/press_providers.dart:120-140` and the tournament-topic candidates further down
- Modify: `lib/domain/services/press/press.dart:205`
- Test: `test/unit/press/press_relevance_test.dart` (create)

**Interfaces:**
- Consumes: the all-fixtures participant check already used for finals routing (grep `participant` in `lib/features/hub/`).

- [ ] **Step 1: Write the failing test**

```
- a tournament in which the nation has no fixture produces no triumph,
  elimination, or tournament-preview question
- a defeat with two competitive matches played since produces no question
  about that defeat, even inside the calendar window
- a defeat with nothing played since still produces one
```

- [ ] **Step 2: Run it to verify it fails**

Run: `flutter test test/unit/press/press_relevance_test.dart`
Expected: FAIL on all three.

- [ ] **Step 3: Implement**

Gate every tournament topic on the nation having a fixture in that competition. Add a matches-since rule alongside the day window: a result stops being news once a stated number of competitive matches have been played after it. Keep `askWindowDays` as the outer bound.

Document the reason in the code: a manager who has played twice since being beaten is not still being asked about it, whatever the calendar says.

- [ ] **Step 4: Run the tests and commit**

```bash
flutter test test/unit/press
git add -A
git commit -m "fix: the press asks about this manager's recent football, and nothing else

Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>"
```

---

### Task 19: The accounts have faces

`YCast` derives a small recurring cast per voice with a `YTrait` each (`lib/domain/services/press/persona.dart`). None of it reaches the manager.

**Files:**
- Modify: `lib/features/y/y_screen.dart` (the post row), `lib/features/y/y_post_detail.dart`
- Create: `lib/features/y/y_profile_sheet.dart`
- Modify: `lib/l10n/app_en.arb`, `lib/l10n/app_cs.arb`
- Test: `test/widget/y_persona_test.dart` (create)

**Interfaces:**
- Consumes: `YPersona` (`{handle, displayName, trait}`) and `YCast` from `persona.dart`.

- [ ] **Step 1: Write the failing widget test**

```
- a post shows its account's display name and handle
- tapping the account opens a profile naming its disposition and listing its
  recent posts
- the same account shows the same disposition across a career (nothing stored,
  so this is a derivation test as much as a widget one)
```

- [ ] **Step 2: Run it to verify it fails**

Run: `flutter test test/widget/y_persona_test.dart`
Expected: FAIL.

- [ ] **Step 3: Implement**

The row gains the display name and handle. A tap opens a profile sheet: the account, a one-line description of its disposition (a string per `YTrait`), and its posts from this save, newest first. Nothing new is stored — the profile re-derives from the same seed and the same run of results the feed already walks.

- [ ] **Step 4: Run the tests and commit**

```bash
flutter test test/widget/y_persona_test.dart
git add -A
git commit -m "feat: the accounts in the feed are somebody

Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>"
```

---

## Area 5: Standing matters

These four tasks are tuned together and playtested together. Land them in order, and do not sign any of them off on tests alone.

### Task 20: A tournament run moves the ranking

`Elo` weights a finals match at 24 and a settled finals at 72 (`lib/domain/services/ranking/elo.dart:49-60`). Winning a tournament does not move a nation the way the manager expects.

**Files:**
- Modify: `lib/domain/services/ranking/elo.dart`
- Test: `test/unit/ranking/tournament_swing_test.dart` (create), `test/unit/ranking/` (existing tests must still pass)

- [ ] **Step 1: Write the failing test**

```
- a nation that wins the World Championship from outside the top twenty
  climbs by at least N places
- a nation that goes out in the group stage of a tournament it was expected
  to win loses ground
- an ordinary qualifier still moves a nation by less than a place
  (the existing guard: this must not regress)
```

Put real numbers on N from the intent: winning the biggest tournament there is should put a nation among the best handful, because that is what it has just proved.

- [ ] **Step 2: Run it to verify it fails**

Run: `flutter test test/unit/ranking/tournament_swing_test.dart`
Expected: FAIL — the climb is too small.

- [ ] **Step 3: Implement**

Raise the finals weights, and give a placing itself weight rather than only the matches that produced it. Update the doc comments: the file already records its retunings and why, and this one continues that record.

- [ ] **Step 4: Run every ranking test**

Run: `flutter test test/unit/ranking`
Expected: PASS, including the "an ordinary match must not swing the ladder" guard from 2026-08-14.

- [ ] **Step 5: Commit**

```bash
git add -A
git commit -m "balance: winning a tournament moves a nation up the ladder

Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>"
```

---

### Task 21: A rising nation produces better teenagers

`PlayerLifecycle` already takes `youthBonusByCycle` (`:152-210`), fed today by academy investment (`youthBonusByCycleProvider`). Add a standing term to the same bonus rather than a second mechanism.

**Files:**
- Modify: wherever `youthBonusByCycleProvider` is defined (grep it; it is read from `lib/features/messages/message_providers.dart:544` and six other places)
- Create: `lib/domain/services/player/intake_standing.dart`
- Test: `test/unit/player/intake_standing_test.dart` (create)

**Interfaces:**
- Produces:

```dart
/// The talent bonus a nation's intake earns from how the senior side is doing:
/// where it sits in the world, how far it has moved, and what it has just won.
/// Added to the academy's own bonus, never replacing it.
abstract final class IntakeStanding {
  static double bonus({
    required int worldRank,
    required int rankChangeOverCycle,
    required Set<String> titlesWon,
  });
}
```

- [ ] **Step 1: Write the failing test**

```dart
test('a nation climbing the ladder produces better boys than a falling one', () {
  final rising = IntakeStanding.bonus(
      worldRank: 30, rankChangeOverCycle: 25, titlesWon: const {});
  final falling = IntakeStanding.bonus(
      worldRank: 30, rankChangeOverCycle: -25, titlesWon: const {});
  expect(rising, greaterThan(falling));
});

test('the bonus stays inside a band a generation cannot break', () {
  final best = IntakeStanding.bonus(
      worldRank: 1, rankChangeOverCycle: 60,
      titlesWon: const {'World Championship'});
  expect(best, lessThanOrEqualTo(0.06));
});
```

The ceiling matters: `_intake` clamps talent around `0.56 + rng * 0.38 + bonus` (`player_lifecycle.dart:510`), so an unbounded bonus produces a nation of superstars inside two cycles.

- [ ] **Step 2: Run it to verify it fails**

Run: `flutter test test/unit/player/intake_standing_test.dart`
Expected: FAIL — the file does not exist.

- [ ] **Step 3: Implement and wire**

Implement the bonus, then add it to the academy bonus in `youthBonusByCycleProvider`. The intake report's note (`intakeNote`, `lib/features/messages/intake_report.dart:40`) should say when the nation's standing is what brought a better crop through, so the manager can connect the two.

- [ ] **Step 4: Run the tests and commit**

```bash
flutter test test/unit/player
git add -A
git commit -m "feat: a nation on the rise brings better teenagers through

Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>"
```

---

### Task 22: The federation's money follows the results

`FederationFinance.centralGrant` is a flat 12M every cycle (`lib/domain/services/federation/federation_finance.dart:52`), on top of prize money that already scales with the run. The flat half should move too.

**Files:**
- Modify: `lib/domain/services/federation/federation_finance.dart`
- Test: `test/unit/federation/` (extend the existing finance test; create `funding_by_results_test.dart` if there is none)

**Interfaces:**
- Produces: `FederationFinance.centralGrantFor({required int worldRank, required int rankChangeOverCycle})`, replacing the constant at its call sites. Keep `centralGrant` as the midpoint so existing tests have an anchor.

- [ ] **Step 1: Write the failing test**

```
- a nation that reached a final gets a bigger grant than one that missed out
- a nation that fell down the ladder gets less than it did last cycle
- the swing stays inside a band: the worst cycle a nation can have must still
  leave it able to run a federation
```

- [ ] **Step 2: Run it to verify it fails**

Run: `flutter test test/unit/federation`
Expected: FAIL.

- [ ] **Step 3: Implement**

Scale the grant around `centralGrant` by standing and movement. State the band in the doc comment. The prize tables stay as they are: they already do the "how far did you go" job, and doubling that signal would make one good tournament fund a decade.

- [ ] **Step 4: Run the tests and commit**

```bash
flutter test test/unit/federation
git add -A
git commit -m "balance: the federation's funding follows the results

Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>"
```

---

### Task 23: The jump is shown

After the World Championship the nation moves a long way up and the manager never sees it.

**Files:**
- Modify: `lib/features/ranking/` (the ranking screen — add movement since the last snapshot)
- Modify: `lib/features/messages/message_providers.dart` (a message when the nation's place changes materially after a tournament)
- Modify: `lib/l10n/app_en.arb`, `lib/l10n/app_cs.arb`
- Test: `test/widget/ranking_movement_test.dart` (create), `test/unit/messages/ranking_message_test.dart` (create)

**Interfaces:**
- Consumes: the per-draw ranking snapshots that already exist (memory: snapshots are stored per draw; grep `snapshot` in `lib/data/repositories/drift_competition_repository.dart`). Read the stored snapshot rather than recomputing, so the movement shown is the movement that happened.

- [ ] **Step 1: Write the failing tests**

```
- the ranking screen shows each nation's movement since the previous snapshot,
  with direction
- finishing a tournament that moves the manager's nation by five or more places
  files an inbox message saying where it came from and where it is now
- a tournament that moves it by one place files nothing
```

- [ ] **Step 2: Run them to verify they fail**

Run: `flutter test test/widget/ranking_movement_test.dart test/unit/messages/ranking_message_test.dart`
Expected: FAIL.

- [ ] **Step 3: Implement**

Remember the "derived providers go stale" constraint: the message is filed during the same sync that runs after a tournament, so invalidate the ranking providers before reading them or the message grades against a pre-tournament snapshot.

- [ ] **Step 4: Run the tests and commit**

```bash
flutter test test/widget/ranking_movement_test.dart test/unit/messages/ranking_message_test.dart
git add -A
git commit -m "feat: a nation's climb is something the manager can see

Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>"
```

---

### Task 24: Playtest the standing pass

Not a code task. Tasks 16 and 20 to 23 change how a career feels and cannot be signed off by tests.

- [ ] **Step 1: Build and install**

Follow the device recipe in memory: release APK over wireless ADB, or build and install to the connected iPhone.

- [ ] **Step 2: Play a full cycle**

Qualifying, the continental championship, the World Championship. Watch specifically: does winning something move the nation visibly; does the intake improve when the nation rises; does the budget change enough to notice without breaking the economy; does a drilled shape feel different from a scattered one.

- [ ] **Step 3: Record what you find**

Write the findings into the plan file under this task before adjusting any number, so the next pass knows what the last one saw.

---

## Area 6: Dashboard and navigation

### Task 25: World ranking beside the date

**Files:**
- Modify: `lib/features/hub/hub_screen.dart:215` (where the date is formatted)
- Test: `test/widget/hub_ranking_test.dart` (create)

- [ ] **Step 1: Write the failing widget test**

Assert the hub header shows the nation's world ranking beside the date, with its movement, and that squad status is still present (it stays).

- [ ] **Step 2: Run it to verify it fails**

Run: `flutter test test/widget/hub_ranking_test.dart`
Expected: FAIL.

- [ ] **Step 3: Implement**

Rank and movement arrow next to the formatted date. Keep the header on one line at 400px: the rank is a number and an arrow, not a sentence.

- [ ] **Step 4: Run the tests and commit**

```bash
flutter test test/widget/hub_ranking_test.dart
git add -A
git commit -m "feat: the dashboard says where the nation stands

Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>"
```

---

### Task 26: Challenges get their own place in My Career

**Files:**
- Modify: `lib/features/career/career_summary_screen.dart` (the menu), `lib/core/routing/app_router.dart` if a route is missing
- Modify: `lib/l10n/app_en.arb`, `lib/l10n/app_cs.arb`
- Test: `test/widget/career_menu_challenges_test.dart` (create)

- [ ] **Step 1: Write the failing widget test**

Assert My Career lists Challenges as its own entry and that tapping it routes to the challenges screen.

- [ ] **Step 2: Run it to verify it fails**

Run: `flutter test test/widget/career_menu_challenges_test.dart`
Expected: FAIL.

- [ ] **Step 3: Implement**

`lib/domain/services/achievements/challenges.dart` already exists; find where challenges are shown today and give them a first-class entry beside achievements.

- [ ] **Step 4: Run the tests and commit**

```bash
flutter test test/widget/career_menu_challenges_test.dart
git add -A
git commit -m "feat: challenges have their own place in My Career

Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>"
```

---

### Task 27: The Nations Cup matchday splits by league

**Files:**
- Modify: `lib/features/tournaments/nations_cup_screen.dart`
- Test: `test/widget/nations_cup_tabs_test.dart` (create)

- [ ] **Step 1: Write the failing widget test**

Assert the matchday view has a tab per league, that it opens on the manager's own league, and that a league with no matches this round still has its tab (empty, not missing).

- [ ] **Step 2: Run it to verify it fails**

Run: `flutter test test/widget/nations_cup_tabs_test.dart`
Expected: FAIL.

- [ ] **Step 3: Implement**

Follow the tab pattern already used in `lib/features/tournaments/` (see `tournament_history.dart:14`, `kTournamentTabBarHeight`) so the tabs match the rest of the app.

- [ ] **Step 4: Run the tests and commit**

```bash
flutter test test/widget/nations_cup_tabs_test.dart
git add -A
git commit -m "feat: the Nations Cup matchday splits into its leagues

Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>"
```

---
## Area 7: Presentation

### Task 28: Names in the lineup stop wrapping

**Files:**
- Modify: `lib/features/tactics/tactics_pitch.dart` (the disc labels), and the lineup lists that show a name in a constrained row
- Test: `test/widget/lineup_name_overflow_test.dart` (create)

**Constraint from memory:** the pitch discs are already as large as the layout allows. Do not enlarge the disc to fit the name; change how the name is rendered inside it.

- [ ] **Step 1: Write the failing widget test**

Render the pitch at 360px wide with the longest names in the seed data and assert no `RenderFlex` overflow and no wrapped label. Find a genuinely long name first:

```bash
grep -o '"[^"]\{18,\}"' assets/data/players.json | sort -u | head
```

- [ ] **Step 2: Run it to verify it fails**

Run: `flutter test test/widget/lineup_name_overflow_test.dart`
Expected: FAIL with an overflow or a two-line label.

- [ ] **Step 3: Implement**

One line, ellipsized, with the surname preferred over the full name when the full name does not fit. A shirt number plus a surname is what a real team sheet shows.

- [ ] **Step 4: Run the tests and commit**

```bash
flutter test test/widget/lineup_name_overflow_test.dart
git add -A
git commit -m "fix: a long name fits the team sheet instead of wrapping

Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>"
```

---

### Task 29: The transfer report reads like one thing

Four complaints: mismatched icons, implausible moves, a layout that is hard to follow, and a report that lists fewer moves than the player's own club history contains.

**Files:**
- Modify: `lib/features/messages/transfer_report.dart` (icons at `:173-179`, `:244-245`; the table at `:120-200`)
- Modify: `lib/features/player/club_history_card.dart`
- Modify: `lib/domain/services/club/clubs.dart` if the two sources genuinely disagree
- Test: `test/unit/club/transfer_report_matches_history_test.dart` (create), `test/widget/transfer_report_test.dart` (extend or create)

**Interfaces:**
- The report and the club history card must read the SAME source. `ClubService.contractAt(playerId, age)` is the one that knows a player's moves; whatever the window report is built from today must agree with it.

- [ ] **Step 1: Write the failing consistency test first — it is the real bug**

```dart
test('every move in a player\'s history appears in the window report', () {
  // For a player with several moves across a career: the moves the club
  // history card shows in a given window must be exactly the moves the
  // transfer report for that window lists.
  for (var age = 18; age < 34; age++) {
    final contract = ClubService.contractAt(playerId, age);
    // a change of contract index between two ages IS a move; assert the
    // window's report contains it.
  }
});
```

- [ ] **Step 2: Run it to verify it fails**

Run: `flutter test test/unit/club/transfer_report_matches_history_test.dart`
Expected: FAIL — the report is missing moves the history has.

- [ ] **Step 3: Fix the source disagreement**

Build the report from the same contract walk the history card uses. If the report is deliberately limited (a window shows only that window's moves), then the history card is what is wrong — establish which, and say so in the commit message.

- [ ] **Step 4: One icon language**

Every row uses the same three marks: in, out, and loan. `Icons.chevron_left_rounded` / `chevron_right_rounded` at `:173-179` are PAGING controls and must not look like move direction; `Icons.arrow_forward_rounded` at `:245` is the move. Make the paging controls unmistakably paging (a label with the page numbers) and reserve arrows for moves.

- [ ] **Step 5: Plausible destinations**

`TransferRow.step` already says whether a move went up, down or sideways between tiers. Assert in a test that a high-rated player does not move down more than a stated share of the time, and fix `ClubService` if he does.

- [ ] **Step 6: Layout**

`perPage` is 6 (`:125`). Make each row say, in order: who, from where, to where, for how much, and which way that is a step. Flags for the two countries are already in the row model (`fromCountry`, `toCountry`); use them instead of spelling out country names.

- [ ] **Step 7: Run the tests and commit**

```bash
flutter test test/unit/club test/widget/transfer_report_test.dart
git add -A
git commit -m "fix: the transfer report agrees with the players' own histories

Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>"
```

---

### Task 30: The results screen leads with now

`_grouped` (`lib/features/results/results_screen.dart:24-48`) orders competitions by the soonest unplayed fixture, but inside a group the fixtures are rendered in stored order, oldest first, and every past round is expanded.

**Files:**
- Modify: `lib/features/results/results_screen.dart:24-48` and the body at `:75-140`
- Test: `test/widget/results_order_test.dart` (create)

- [ ] **Step 1: Write the failing widget test**

```
- the current round's fixtures appear above older ones
- within the played fixtures, the most recent is first
- rounds older than the current one are collapsed behind a header that says
  how many they hold, and expand on tap
```

- [ ] **Step 2: Run it to verify it fails**

Run: `flutter test test/widget/results_order_test.dart`
Expected: FAIL — oldest first, everything expanded.

- [ ] **Step 3: Implement**

Sort within each group: unplayed by date ascending (what is coming), then played by date descending (what just happened). Collapse the tail.

- [ ] **Step 4: Run the tests and commit**

```bash
flutter test test/widget/results_order_test.dart
git add -A
git commit -m "fix: the results screen starts where the manager is

Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>"
```

---

### Task 31: The development report groups by tier

"Improved from 34" tells the manager nothing. `SquadDevRow` already carries name, age, position, rating, change, stars and the wonderkid flag (`lib/features/messages/squad_dev_report.dart:20-60`) — what is missing is the grouping.

**Files:**
- Modify: `lib/features/messages/squad_dev_report.dart`
- Modify: `lib/features/messages/message_providers.dart:600-640` (where the report is built)
- Modify: `lib/l10n/app_en.arb`, `lib/l10n/app_cs.arb`
- Test: `test/widget/squad_dev_report_test.dart` (create or extend)

**Interfaces:**
- Produces: `SquadDevRow` gains a tier — `enum SquadDevTier { regular, fringe, youth }` — derived from whether the player was called up in the last cycle, is in the pool, or is under 21.

- [ ] **Step 1: Write the failing widget test**

```
- the report renders three sections, regulars first
- a player who has been called up appears under regulars, not youth,
  whatever his age
- a section with nobody in it is not rendered at all
- each row names the player, his age and his old to new rating
```

- [ ] **Step 2: Run it to verify it fails**

Run: `flutter test test/widget/squad_dev_report_test.dart`
Expected: FAIL.

- [ ] **Step 3: Implement**

Tier from call-up history first, then age. Within a section, biggest mover first. The encoded message body must keep decoding older reports: follow the versioned-tag pattern the transfer report uses (`_tagV1` / `_tagV2` / `_tagV3` at `transfer_report.dart:43-45`) rather than breaking saved messages.

- [ ] **Step 4: Run the tests and commit**

```bash
flutter test test/widget/squad_dev_report_test.dart
git add -A
git commit -m "feat: the development report says who got better and whether it matters

Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>"
```

---

### Task 32: Player of the year is shown properly

**Files:**
- Modify: `lib/features/awards/award_providers.dart` and the popup that renders the award (grep `playerOfTheYear`)
- Test: `test/widget/player_of_year_test.dart` (create)

- [ ] **Step 1: Write the failing widget test**

Assert the popup shows the player's flag, his season stats (caps and goals at least) and his rating, alongside his name.

- [ ] **Step 2: Run it to verify it fails**

Run: `flutter test test/widget/player_of_year_test.dart`
Expected: FAIL.

- [ ] **Step 3: Implement**

The provider already resolves the player; add the nation for the flag and the season tally. Keep the popup to one screen at 400px.

- [ ] **Step 4: Run the tests and commit**

```bash
flutter test test/widget/player_of_year_test.dart
git add -A
git commit -m "feat: the player of the year arrives with his flag and his numbers

Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>"
```

---

### Task 33: The World Championship final is shown, not announced

Simulating passively, the continental final is shown and the World Championship's is not: the champion simply appears.

**Files:**
- Investigate: `lib/features/hub/season_finals.dart`, `lib/features/hub/season_cycle.dart`, `lib/features/hub/hub_event.dart`
- Test: `test/unit/hub/finals_shown_test.dart` (create)

- [ ] **Step 1: Reproduce with a test**

Assert that simulating through both finals produces the same kind of event for each: whatever the continental final emits, the World Championship final must emit too. A table over both competitions, so the asymmetry cannot come back.

- [ ] **Step 2: Run it and read the failure**

Run: `flutter test test/unit/hub/finals_shown_test.dart`
Expected: FAIL for the World Championship. Then find why: likely the World Championship's final is played inside a bulk world-simulation step that emits a champion rather than a match, while the continental final goes through the per-round path.

- [ ] **Step 3: Fix at the cause**

Route both finals through the same path. Do not special-case the World Championship in the UI.

- [ ] **Step 4: Run the tests and commit**

```bash
flutter test test/unit/hub
git add -A
git commit -m "fix: the World Championship final is played in front of you

Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>"
```

---

### Task 34: A naturalised player reads the same rating everywhere

A naturalised player shows a much lower rating in the match preview than elsewhere. There is a `naturalized_players` table (see the 38→39 migration in `app_database.dart`), so the preview is probably resolving him down a path that misses whatever the naturalisation applies.

**Files:**
- Investigate: `lib/features/match/match_preview_screen.dart`, `lib/features/match/match_providers.dart:177-195`, the naturalisation service (grep `naturaliz`)
- Test: `test/unit/player/naturalized_rating_test.dart` (create)

- [ ] **Step 1: Reproduce with a test**

```dart
test('a naturalised player has one rating, wherever he is read', () async {
  // Resolve the same naturalised player through the squad path and through
  // the match-preview path; the overall must match.
  expect(fromPreview.overall, fromSquad.overall);
});
```

- [ ] **Step 2: Run it and read the failure**

Run: `flutter test test/unit/player/naturalized_rating_test.dart`
Expected: FAIL. Compare the arguments each path passes to `PlayerRepository.byId` — `agingYears`, `saveSeed`, `youthBonusByCycle`, `careerStartsByPlayer`. A path that omits one reconstructs a different player. This is the same class of fault as Task 4 and the two may share a cause; if so, say so and fix once.

- [ ] **Step 3: Fix at the cause**

One resolution path, used by both. A rating that differs by screen is the bug; the number that is right is the one the squad screen shows, because that is the one the manager picks on.

- [ ] **Step 4: Run the tests and commit**

```bash
flutter test test/unit/player
git add -A
git commit -m "fix: a naturalised player is the same footballer on every screen

Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>"
```

---

## Wrap-up

### Task 35: Whole-suite verification and the copy round trip

- [ ] **Step 1: Regenerate the copy file**

```bash
flutter gen-l10n
dart run tool/export_copy.dart
git diff --stat copy/strings.csv
```

Every new string added in this batch must appear in `copy/strings.csv` with both an `en` and a `cs` value.

- [ ] **Step 2: Check the naming guard**

```bash
flutter test test/unit/l10n
```

No English user-facing string says "World Cup".

- [ ] **Step 3: Full suite and analyzer**

```bash
flutter test
flutter analyze 2>&1 | grep -c "error •"
```

Expected: all tests pass; the error count is `0`.

- [ ] **Step 4: Walk the 35 items**

Open the spec and check each item off against the branch. Anything not done is either done now or reported as not done, with the reason. Do not report the batch complete with silent gaps.

- [ ] **Step 5: Device playtest**

Tasks 16 and 20 to 23 changed how a career feels. Build to a device and play a cycle before calling the batch finished.

- [ ] **Step 6: Commit**

```bash
git add -A
git commit -m "chore: copy round trip and whole-suite verification for the batch

Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>"
```

---

### Task 36: A width sweep, with a guard that can actually fail

**Added mid-batch**, after four width bugs shipped past tests that were structurally incapable of catching them. Two of the four broke in ENGLISH, in files that already had width tests.

Two root causes, both now known:

- `expect(tester.takeException(), isNull)` passes for ANY amount of ellipsis. A `Text` that wants 220px and is given 120px does not throw; it truncates silently. Every width test in this repo that rests on `takeException` proves only "no RenderFlex overflow", which is a different and much weaker claim than "the manager can read this".
- `Localizations.override` around a launcher does NOT reach a route pushed on the root `Navigator`. A test written that way renders ENGLISH while claiming to test Czech. Confirmed in `test/widget/in_match_sub_undo_test.dart` before it was corrected.

**Files:**
- Create: `test/helpers/expect_whole.dart` — lift `expectWhole` out of `test/widget/in_match_sub_undo_test.dart:44-58`
- Audit: every file under `test/widget/` that sets `physicalSize` or calls `Localizations.override`
- Modify: whichever widgets the sweep proves are truncating

**Interfaces:**
- Produces: `void expectWhole(Finder finder, String what)` — reads `RenderParagraph.didExceedMaxLines`, and on failure reports the natural width it wanted against the width it was granted.

- [ ] **Step 1: Lift the helper**

Move `expectWhole` to `test/helpers/expect_whole.dart` and re-point `in_match_sub_undo_test.dart` at it. Run that file: it must stay green.

- [ ] **Step 2: Find every test making the weaker claim**

```bash
grep -rln "takeException" test/widget/
grep -rln "Localizations.override" test/widget/
```

For each hit, record in the report: does it pump a route (locale trap), and does it assert only `takeException` (ellipsis blind spot)?

- [ ] **Step 3: Fix the harnesses before trusting any of them**

Any test overriding the locale around a pushed route moves the locale onto the `MaterialApp`, and asserts a locale-only string is present before measuring. A test that cannot prove which language it rendered proves nothing about width.

- [ ] **Step 4: Strengthen the assertions where it matters**

Not every string needs this. Apply `expectWhole` to text carrying **a number or a name the manager acts on**: scores, counts, ratings, player names, nation names, money, dates. Decorative labels and headings can keep the weaker check.

Test at 360px AND 400px, in English AND Czech. Czech is the longer language, but note that two of this batch's four width bugs broke in English, so never test Czech alone.

- [ ] **Step 5: Fix what the sweep finds**

Expect to find some. A `ListTile` subtitle beside a 40px leading and a trailing widget has only about 198px usable at 360px, which is narrower than it looks. Where a string cannot be made to fit, shorten the string rather than letting the number give way: the count, score or rating is what the manager reads, and the label around it is what can yield.

- [ ] **Step 6: Commit**

```bash
git add -A
git commit -m "test: a width guard that fails when the manager cannot read it

Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>"
```

---

## Amendments (user decisions, 2026-09-21)

### Task 15 is rescoped: show the honest truth, do not make staff matter

Building `StrengthFactors` (Task 12) established that staff barely affect a match at all. A full elite staff room is worth about **+1 rating point**; anything less rounds to zero. The only effect a match feels is the injury rate. `Staff.familiarityGain` — the assistant coach's drilling work — is **defined but never wired into anything**, and the scouting reach never touches a match.

So the plan's premise for Task 15 ("surface the effect that already exists") was wrong: there is almost no effect to surface.

**The user's decision: show what staff actually do today, and leave "make staff matter" to its own piece of work with its own design.** Task 15 therefore states the real numbers plainly — the injury-rate percentage and what it is worth — and does NOT wire up `familiarityGain` or raise any staff constant. A manager reading that screen learns the truth, which is that the staff room is near-cosmetic. That is a finding to act on later, not a thing to paper over now.

---

### Task 37: A man you left at home cannot score your extra-time winner

Found during Task 9. In a match the manager **actually played**, extra-time goals are attributed through `_fieldedXi` with no `xi:` argument, so they are credited to the nation's best available 4-3-3 rather than the eleven he fielded.

**Files:**
- Modify: `lib/features/hub/hub_providers.dart:1235` and `:1244` (both inside `_playPlayerMatch`)
- Test: `test/unit/hub/extra_time_attribution_test.dart` (create)

**Interfaces:**
- Consumes: `result.ratings`, which normal-time attribution already uses to know who was on the pitch.

- [ ] **Step 1: Write the failing test**

Play a match that goes to extra time with a manager-named XI that deliberately EXCLUDES the nation's best player. Assert no goal in the match is credited to anyone outside the eleven actually fielded (plus substitutes who came on).

- [ ] **Step 2: Run it to verify it fails**

Run: `flutter test test/unit/hub/extra_time_attribution_test.dart`
Expected: FAIL, crediting a man who never played.

- [ ] **Step 3: Thread the real XI**

Pass the fielded eleven to `_attributeGoals` the way normal-time attribution already does, rather than letting it fall back to `xi ?? await _fieldedXi(...)`.

- [ ] **Step 4: Run the tests and commit**

```bash
flutter test test/unit/hub/extra_time_attribution_test.dart
git add -A
git commit -m "fix: extra-time goals go to the men who were on the pitch

Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>"
```

---

### Task 38: A quick-simmed match is still the manager's team

Found during Task 9. When the manager's own fixture is quick-simmed or skipped, `_fieldedXi` builds the nation's best 4-3-3 and ignores his call-ups, his saved XI and his formation entirely. Absences are now honoured (Task 9), but a man he never selected can still play for him.

This decides what "the manager's team" means in a match he did not watch, so it is a design decision as much as a fix.

**Files:**
- Modify: `lib/features/hub/hub_providers.dart` (`_fieldedXi` / `_fieldedSubs` and their callers)
- Test: `test/unit/hub/quick_sim_uses_squad_test.dart` (create)

**Interfaces:**
- Consumes: the stored lineup and call-ups for the manager's career; `selectable(pool, absences)` for per-match availability.

- [ ] **Step 1: Decide the rule and write it down**

The rule: a quick-simmed match for the MANAGER'S nation fields his saved XI and formation, with his call-ups as the pool, minus anyone the absences rule out, topped up from his named squad where the XI is short. Every OTHER nation keeps the current behaviour (best available, since nobody picked them).

State this in the commit message and in a doc comment. Do not change the rule for other nations.

- [ ] **Step 2: Write the failing test**

Name a squad and an XI that deliberately leaves out the nation's best player, quick-sim that fixture, and assert the best player did not appear while the named XI did.

- [ ] **Step 3: Run it to verify it fails**

Run: `flutter test test/unit/hub/quick_sim_uses_squad_test.dart`
Expected: FAIL, the best player plays.

- [ ] **Step 4: Implement**

`_fieldedXi` takes the manager's stored lineup when the nation is his and one exists. A stored XI may be stale (a named man since injured, retired or dropped), so filter through `selectable` and fill the gaps from his call-ups before falling back to the nation pool.

- [ ] **Step 5: Check what it breaks**

This changes which players appear in every skipped match, so results shift. Run `test/unit/hub`, `test/unit/match`, `test/unit/career/nation_switch_test.dart`, `test/unit/season_flow_test.dart` and `test/unit/full_cycle_test.dart` one file at a time. A test that encoded the OLD behaviour must be re-verified deliberately, not silently adjusted.

- [ ] **Step 6: Commit**

```bash
git add -A
git commit -m "fix: a match you skipped is still played by your team

Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>"
```

---

### Task 38 amendment: a skipped match must also use the manager's TACTICS

Found during Task 16. `HubProviders._simAndRecord` runs the manager's own fixtures through `RatingMatchSimulator` when he SKIPS a match. That simulator takes two integer strengths and has no formation, no instructions, no familiarity and no chemistry at all.

So the drilled bonus applies when the manager watches a match and not when he skips one — and Task 16 roughly doubled the size of that discrepancy by making tactics matter more.

This is the same seam Task 38 already opens (a skipped match should field the manager's own team), so it joins that task rather than becoming a separate one. Task 38's rule becomes:

> A quick-simmed match for the MANAGER'S nation is played with his squad, his XI, his formation AND his tactical standing — the stored familiarity for that shape, and his instructions — so that skipping a match is a choice about watching, not a choice about how his side plays. Every other nation keeps the current behaviour.

Closing it means threading the career's formation and stored familiarity into an async repository read per world fixture. That is real work, and it is why the effect is worth having at all: a manager who drills a shape for four years should not lose the benefit by pressing skip.

---

### Task 39: The width dials push both sides the same way

Found by the review of Task 16, and made three times louder by it.

In `MatchEngine._matchup`, the two width terms both fire POSITIVE for BOTH sides whenever the two widths straddle 50. With `a.width = 80` and `d.width = 20`: term 3 computes `(0.6 x 0.6) = 0.36` and term 3b computes `(-0.6 x -0.6) = 0.36`. Two negatives multiplied. Each side gains attack rating from the mismatch, rather than one side gaining what the other loses.

It nets out of goal DIFFERENCE, which is why no guard sees it, and it does not net out of SCORELINES:

| widths | goals/game before Task 16 | after |
|---|---|---|
| 50 vs 50 | 2.637 | 2.637 |
| 80 vs 20 | 2.731 | 2.912 |
| 100 vs 0 | 2.892 | **3.449** |

A full width mismatch now adds +0.81 goals per match to a 2.64 baseline, up from +0.26. Real playstyles straddle 50 on width routinely (wing play around 70, a low block or counter narrow), so this lifts scoring across ordinary world fixtures.

**Files:**
- Modify: `lib/domain/services/match/match_engine.dart` (`_matchup`, the two width terms)
- Test: `test/unit/match/tactics_swing_test.dart` (extend — a total-goals assertion with mismatched widths should already exist there from Task 16's fix round)

- [ ] **Step 1: Establish what the term is FOR before changing its sign**

Read the surrounding code and comments. A width mismatch plausibly SHOULD create chances at both ends — a wide side against a narrow one stretches the game. If that is the intent, the bug is only that it is now three times too strong, and the fix is a coefficient, not a sign. If the intent was that one side gains what the other loses, the fix is the sign. Decide which, state the reasoning in the report, and say so in a doc comment.

- [ ] **Step 2: Write the failing test**

Assert total goals per game with mismatched widths (100 vs 0, and 80 vs 20) sits within a stated band of the neutral 50-vs-50 baseline. Put the band on the intent: a width mismatch should be worth a fraction of a goal, not a third of the scoreline.

- [ ] **Step 3: Run it to verify it fails**

Run: `flutter test test/unit/match/tactics_swing_test.dart`
Expected: FAIL at the extreme mismatch.

- [ ] **Step 4: Fix per the decision in step 1, and re-measure**

Both the mismatch case AND the neutral case must land in band — a fix that flattens width entirely is as wrong as leaving it loud.

- [ ] **Step 5: Check the scoreline distribution guard**

Run `test/unit/match/scoreline_distribution_test.dart`. It runs at neutral 50s so it should be unmoved; if it moves, the fix reached further than intended.

- [ ] **Step 6: Commit**

```bash
git add -A
git commit -m "fix: a width mismatch stretches the game, it does not double it

Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>"
```

---

### Task 40: The manager is not credited with the 2026 World Championship

**A regression this batch introduced.** Task 3 seeded the 2026 World Championship into history. `CareerService.cycleStart` is `DateTime(2026, 7)`, so `cycleStart.year` is **2026**, and roughly a dozen places filter a manager's own honours with `h.year >= CareerService.cycleStart.year`.

That filter now includes the seeded 2026 edition. A manager who takes the nation that won it is credited with a World Championship before kicking a ball. `career_summary_providers.dart:158` carries the comment "Only this career's own editions — not the pre-seeded real-world history" directly above the line that no longer does that.

Found by Task 21's null control, which caught the same off-by-one in its own cycle arithmetic (`ceil((year - 2030) / 4)` filed a 2026 honour under cycle 0) and flagged the sibling sites.

**Files — every site that asks "is this honour the manager's?":**
- `lib/features/career/career_summary_providers.dart:158`
- `lib/features/career/nation_offers_providers.dart:234`, `:275`
- `lib/features/career/manager_history_providers.dart:266`
- `lib/features/messages/message_providers.dart:230`
- `lib/features/records/record_book_providers.dart:158`
- `lib/features/achievements/achievement_providers.dart:318`
- `lib/features/achievements/challenge_providers.dart:129`
- `lib/features/press/press_providers.dart:236`
- `lib/features/manager/manager_providers.dart:41`
- `lib/features/awards/award_providers.dart:56`
- Already correct, and the model for the fix: `lib/features/federation/federation_providers.dart:104` uses `h.year <= cycleStart.year` and so excludes 2026.
- Test: `test/unit/career/seeded_honour_not_mine_test.dart` (create)

- [ ] **Step 1: Write the failing test**

Start a career with the nation that won the seeded 2026 World Championship, before playing anything. Assert it has no honours of its own: the career summary shows none, the achievement for winning the World Championship is not unlocked, and the press does not ask about a triumph.

Read `RealHistory.editions` for the 2026 champion rather than hardcoding the name, so a change to the seeded result does not silently void the test.

- [ ] **Step 2: Run it to verify it fails**

Run: `flutter test test/unit/career/seeded_honour_not_mine_test.dart`
Expected: FAIL. The nation is credited with a trophy it won before the save began.

- [ ] **Step 3: One shared predicate, not a dozen fixed comparisons**

Add a single question to `CareerService` — "is this honour one this career could have won?" — and route every site above through it. Twelve copies of a date comparison is how this broke; a thirteenth copy would be the same bug waiting.

The boundary belongs to the career, not the calendar: the 2026 edition concluded before a save opens on 1 July 2026, and the first edition a manager can affect is the one their own cycle produces.

- [ ] **Step 4: Check each call site still means what it meant**

Some of these ask a slightly different question (a cycle index, a years-managed count). Do not flatten a site into the shared predicate if it was asking something else; convert only the ones asking "is this mine".

- [ ] **Step 5: Run the covering tests and commit**

```bash
flutter test test/unit/career/seeded_honour_not_mine_test.dart
flutter test test/unit/achievements
git add -A
git commit -m "fix: a trophy won before the save began is not the manager's

Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>"
```

---

### Task 41: No skipping a match you chose to play

**Requested by the user mid-batch.** The live match screen offers play/pause, a speed control and "skip to full time". The skip goes. Play and the speeds remain.

The reasoning is the manager's own: a match he opened is a match he is watching. If he does not want to watch it, the hub already lets him simulate it without opening it at all. Two ways to not watch a match is one too many, and the in-match one undercuts every decision the screen exists to offer.

**Files:**
- Modify: `lib/features/match/match_frame.dart:149-230` (`MatchControlBar` — the `onSkip` parameter and its pill button)
- Modify: `lib/features/match/match_screen.dart:843-858` (`_skip()`), and `:1459` (where it is wired in)
- Modify: `lib/l10n/app_en.arb` and `lib/l10n/app_cs.arb` (remove `matchSkipToFullTime`; leave `tourSkip` and `tourSharedSkip` alone, they belong to the guided tour)
- Test: `test/widget/match_control_bar_test.dart` (exists; update), plus wherever the control bar is pumped

**Interfaces:**
- `MatchControlBar` loses its required `onSkip`. Every call site must be updated; it is required, so the compiler finds them.

- [ ] **Step 1: Check what else the skip path was doing**

`_skip()` sets `_penOrderAsked = true`, with the comment "Skipping past a shootout accepts the automatic taker order". That is the ONLY thing in the method that is not simply jumping the clock. Establish where else `_penOrderAsked` is set, and confirm that with the skip gone the manager is always asked for his shoot-out order rather than the flag being left unset and the prompt never appearing — or appearing twice.

Write down what you find before changing anything. A shoot-out that silently takes an automatic order, or asks twice, is a worse bug than the button.

- [ ] **Step 2: Write the failing test**

The control bar renders play/pause and the speed control, and NO skip control. Assert by absence of the skip icon AND of its tooltip, so a renamed icon cannot let it back in.

- [ ] **Step 3: Run it to verify it fails**

Run: `flutter test test/widget/match_control_bar_test.dart`
Expected: FAIL, the skip control is present.

- [ ] **Step 4: Remove it**

Delete the pill button, the `onSkip` parameter, `_skip()`, and the wiring. Remove `matchSkipToFullTime` from both `.arb` files, then `flutter gen-l10n`, then `dart run tool/export_copy.dart`.

Do not leave a disabled button or a hidden flag. The control is gone.

- [ ] **Step 5: Confirm the shoot-out still behaves**

Run whatever covers the interactive shoot-out (grep test/ for the penalty order sheet). The manager must be asked exactly once for his order.

- [ ] **Step 6: Commit**

```bash
git add -A
git commit -m "feat: a match you opened is a match you watch

Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>"
```

---

### Task 42: Dates speak the manager's language

Found during Task 30. Every `DateFormat` in the app is constructed with no locale, so `intl` falls back to English and a Czech save reads "1 Sep 2030" and "WED 12 JUN". Twelve sites, none localised — including the dashboard date, which is the single most-seen string in the game.

This matters more than its size suggests: the manager who reported this whole batch plays in Czech, and the game otherwise translates carefully enough that English dates stand out as a defect rather than a convention.

**Files — every `DateFormat(` in `lib/`:**
- `lib/features/hub/hub_screen.dart:216` (the dashboard date) and `:667`
- `lib/features/home/home_screen.dart:165`
- `lib/features/career/manager_history_screen.dart:233`, `lib/features/career/saves_screen.dart:292`
- `lib/features/records/h2h_meetings_screen.dart:164`
- `lib/features/ranking/world_ranking_screen.dart:658`
- `lib/features/match/match_preview_screen.dart:151`
- `lib/features/tactics/call_up_screen.dart:733`
- `lib/features/results/results_screen.dart:165`
- `lib/features/player/player_detail_screen.dart:721`
- `lib/features/y/y_screen.dart:644`
- Test: `test/widget/localised_dates_test.dart` (create)

- [ ] **Step 1: Check the locale data is actually initialised**

`intl` needs its locale data loaded before a non-English `DateFormat` works. Find out whether this app does that (grep `initializeDateFormatting`, and check what `flutter gen-l10n` set up). If it does not, that is the first fix, and a `DateFormat('d MMM', 'cs')` will otherwise throw or silently fall back. Establish this BEFORE converting any call site.

- [ ] **Step 2: Write the failing test**

Pump a widget rendering a date under a Czech locale and assert the Czech month name appears. Then a second test asserting English under an English locale, so a change that hardcodes Czech fails too.

- [ ] **Step 3: Run it to verify it fails**

Run: `flutter test test/widget/localised_dates_test.dart`
Expected: FAIL, the Czech case renders English.

- [ ] **Step 4: One helper, not twelve conversions**

Add a single place that formats a date for the current locale, and route every site through it. Twelve hand-written `DateFormat` constructions is how all twelve came to be wrong together; a thirteenth would be the next one. The pattern to follow is `CareerService.isOwnHonourYear`, added earlier in this batch for exactly this reason.

Two sites uppercase their output (`match_preview_screen.dart:151`, `hub_screen.dart:667`). Czech month abbreviations uppercase differently and some carry diacritics; check the result reads properly rather than assuming `toUpperCase()` is safe.

- [ ] **Step 5: Width**

Czech day and month names differ in length from English, and several of these dates sit in tight rows. Use `expectNothingCut` (test/widget/transfer_report_test.dart) at 360px and 400px in BOTH languages on the dashboard header, the match preview and the results rows at minimum.

- [ ] **Step 6: Commit**

```bash
git add -A
git commit -m "fix: a Czech save reads Czech dates

Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>"
```

---

# Device playtest round 2 — 2026-09-21

Five items from playing the installed build. Two are regressions this batch
introduced; one is a partial revert of work this batch did.

### Task 44: a player injured for four games could play at once

**A correctness bug, and the second time this shape has appeared.** The manager
saw "injured 4g" against a name in the call-up list and that player was
available immediately.

Task 9 fixed one instance of this — a cold absence cache in the WORLD
SIMULATOR — and proved the tactics path innocent with tests that pass against
unmodified code. So this is either a third path, or the absence itself is wrong
(shown as 4 games but stored as something else), or the call-up display and the
XI are reading different absence sources.

Reproduce before fixing. Establish FIRST whether the player was wrongly
FIELDABLE or wrongly LABELLED — those are opposite bugs and the fix for one
makes the other worse. `PlayerAbsence.injuryMatches` is the stored figure;
`selectable()` (tactics_providers.dart:45) is the per-match gate;
`SquadSelection.usableInPeriod` is the squad-level rule.

Nine `selectable(` call sites exist. Task 9 established the rule belongs where
the XI becomes a `MatchTeam`, so no screen can route around it — check that
still holds.

### Task 45: passive matches take far too long

**A performance regression.** Several candidates, all introduced or widened in
this batch. MEASURE before changing anything; do not optimise by guesswork.

Known suspects, in the order they were flagged during the batch:
- `playerRankProvider` on the dashboard sorts every one of 209 nations, and the
  hub rebuilds repeatedly during a simulation. This was explicitly flagged as
  "the first thing to check if the dashboard feels slow on device".
- `_fieldedXi`/`_fieldedSubs` now await absences and filter through
  `selectable` per side per fixture (Task 9).
- `_withManagerTactics` and `_managerXi` per fixture for the manager's nation
  (Task 38), though the setup is cached per operation.
- `_pool` is cached per `(nation, simYears)`, so verify the cache is actually
  hitting rather than assuming it.

Profile a real passive cycle, report where the time goes with numbers, and fix
the largest cost. State the before and after in seconds.

### Task 46: the objectives news always says the board got what it asked for

`season_cycle.dart:68-85` picks the met/missed title and body from `o.met`, and
the selection logic is correct — so `o.met` is the suspect, in
`cycleObjectiveOutcomesProvider`. The manager reports ALWAYS seeing the "they
have what they asked for" wording, including when he did not meet the brief.

Reproduce with a missed objective before changing anything. Note that a nearby
comment records a previous bug in this exact area (a verdict graded against a
cached "still to be decided"), so check the invalidation is doing what that
comment claims.

### Task 47: the set-piece takers do nothing, and want a button

Task 11 made the taker slots SHOW the engine's automatic pick rather than sit
blank. The manager reports they "now do nothing" and asks for a button for a
quick pick.

Establish what is actually wrong before building the button: is the automatic
name not displaying, is it displaying but not applied, or is it applied but
there is no way to accept or change it quickly? `SetPiecePicks` mirrors the
engine's rule; `SetPieceTakers` stores null to mean automatic.

Then add the quick-pick button the manager asked for: one tap fills every duty
with the best available taker, storing the choice so it is visibly HIS rather
than an implicit default.

### Task 48: the transfer report's direction arrows go

Task 29 gave each move an arrow carrying `TransferRow.step` — up, level or
down between league tiers. The manager's verdict: "různé šipky - zbytečné,
prostě je to přestup". Different arrows, pointless, it is just a transfer.

Remove the per-move direction arrows and use ONE consistent mark for a move.
Keep `TransferRow.step` in the encoded body — old reports must still decode,
and the field costs nothing — but stop varying the icon by it.

Do not remove the paging controls or the flags; those were separate complaints
and are fine.
