# Feedback Batch Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Fix the ~28 items reported from a play session — a career-breaking play-off bug, an uncapped substitution path, UI that clips real data, generated content that repeats, and four balance asks.

**Architecture:** Five independent phases (live match, tournament flow, squad/players, generated content, naming/UI/balance). Phases share no state and can land in any order; within a phase, tasks are ordered by dependency. Domain services stay pure and derived — the project's rule that a player, a club and a Y post are functions of seed and year, never stored rows, holds throughout.

**Tech Stack:** Flutter / Dart, Riverpod (no codegen — see project memory), drift for persistence, `flutter test` for unit and widget tests, gen_l10n for EN/CS strings.

**Spec:** `docs/superpowers/specs/2026-08-13-feedback-batch-design.md`

## Global Constraints

- **No `@riverpod` codegen.** Hand-write providers; the annotation conflicts with `drift_dev` in this project.
- **`build_runner` needs `--force-jit`** when codegen is unavoidable (sqlite3 build hook).
- **Every user-facing string is localised** in both `lib/l10n/app_en.arb` and `lib/l10n/app_cs.arb`. Never inline a literal into a widget.
- **Licence-safe naming:** the World Cup is **"World Championship"** in user-facing text. `worldCupHonourName` (`achievements.dart:101`) is a *stored* value and must not change.
- **Match engine and match simulator are tuned together.** A scoreline or discipline change to `match_engine.dart` requires the matching change in `match_simulator.dart`, or live and background football desync.
- **Derived, never stored:** clubs, Y posts, board mood, player attributes. Do not add tables for these.
- **A schema bump wipes existing saves.** Confirm with the user before bumping (current: 40, `test/generated_migrations/schema_v40.dart`).
- **Verification:** `dart format` check + `flutter analyze` + `flutter test` all pass before any commit.

---

## Phase A — Live match

### Task 1: Substitution count survives the tired label [A1]

**Files:**
- Modify: `lib/features/match/match_screen.dart:1580-1605`
- Test: `test/widget/match_control_bar_test.dart` (create)

The tactics pill already wraps its text in `Flexible` with `TextOverflow.ellipsis`. That is the bug: when `spent > 0` the string grows to `TIRED ×3 · 1/3` and the ellipsis eats the *end* — the substitution count — which is the one part the manager needs.

**Interfaces:**
- Consumes: `kMaxSubs` (existing const), `_PillButton` (existing, same file)
- Produces: no new public API

- [x] **Step 1: Write the failing widget test**

```dart
// test/widget/match_control_bar_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('sub count stays visible when the tired label is long',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await pumpMatchControlBar(tester, spent: 5, subsUsed: 1);

    // The count is its own widget and is never the thing that gets clipped.
    expect(find.text('1/3'), findsOneWidget);
  });
}
```

Write `pumpMatchControlBar` as a local helper in the test file that pumps
`_MatchControlBar` inside a `MaterialApp` with the app's localizations
delegates. `_MatchControlBar` is private — make it package-visible for the test
by adding `@visibleForTesting` to the class, or extract the pill's content into
a small public widget. Prefer the extraction; it is what the fix needs anyway.

- [x] **Step 2: Run the test to verify it fails**

Run: `flutter test test/widget/match_control_bar_test.dart`
Expected: FAIL — `1/3` not found (it is inside the concatenated, ellipsized string).

- [x] **Step 3: Split the label from the count**

Replace the single `Flexible(child: Text(...))` with two children: an
ellipsizing label and a fixed count that never shrinks.

```dart
Flexible(
  child: Text(
    spent > 0 && subsUsed < kMaxSubs
        ? l.matchTiredCount(spent)
        : l.matchTacticsLabel,
    overflow: TextOverflow.ellipsis,
    softWrap: false,
    style: AppTypography.labelMedium.copyWith(color: tone),
  ),
),
const SizedBox(width: AppSpacing.xs),
// Never Flexible: the count is the number the manager is actually reading,
// so the label gives way to it rather than the other way round.
Text(
  '$subsUsed/$kMaxSubs',
  style: AppTypography.labelMedium.copyWith(color: tone),
),
```

Hoist the repeated `spent > 0 && subsUsed < kMaxSubs` into a single local
`final tired = spent > 0 && subsUsed < kMaxSubs;` and `final tone = tired ?
AppColors.warning : AppColors.primary;` — it is currently evaluated five times
in this widget.

- [x] **Step 4: Add the two new strings to both ARB files**

```json
// lib/l10n/app_en.arb
"matchTiredCount": "TIRED ×{count}",
"@matchTiredCount": { "placeholders": { "count": { "type": "int" } } },
"matchTacticsLabel": "TACTICS",
```

```json
// lib/l10n/app_cs.arb
"matchTiredCount": "ÚNAVA ×{count}",
"matchTacticsLabel": "TAKTIKA",
```

- [x] **Step 5: Regenerate localizations and run the test**

Run: `flutter gen-l10n && flutter test test/widget/match_control_bar_test.dart`
Expected: PASS

- [x] **Step 6: Commit**

```bash
git add lib/features/match/match_screen.dart lib/l10n/app_en.arb lib/l10n/app_cs.arb lib/l10n/ test/widget/match_control_bar_test.dart
git commit -m "fix: the substitution count no longer gets eaten by the tired label"
```

---

### Task 2: The substitution cap is enforced, not just announced [A2]

**Files:**
- Modify: `lib/features/tactics/in_match_tactics.dart:137-200`
- Test: `test/unit/tactics/in_match_subs_test.dart` (create)

`_overLimit` (`:137`) gates only the `_apply()` snackbar (`:185`). Nothing stops
the board from reaching an over-limit state, and nothing prevents bringing back
a player already substituted off — which is why the manager could occasionally
substitute without limit.

The fix is to make the *rule* a pure function that both the UI and the test can
call, then have `_setSlot` refuse a change that breaks it.

**Interfaces:**
- Produces: `bool canBringOn({required Set<int> startingIds, required Set<int> onPitch, required Set<int> sentOffIds, required Set<int> withdrawnIds, required int maxSubs, required int playerId})` in a new file `lib/domain/services/tactics/substitution_rules.dart`

- [x] **Step 1: Write the failing test**

```dart
// test/unit/tactics/in_match_subs_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/tactics/substitution_rules.dart';

void main() {
  group('canBringOn', () {
    test('refuses a fourth change once three are spent', () {
      expect(
        canBringOn(
          startingIds: {1, 2, 3, 4},
          onPitch: {4, 11, 12, 13},
          sentOffIds: const {},
          withdrawnIds: {1, 2, 3},
          maxSubs: 3,
          playerId: 14,
        ),
        isFalse,
      );
    });

    test('refuses a player already substituted off', () {
      expect(
        canBringOn(
          startingIds: {1, 2, 3, 4},
          onPitch: {2, 3, 4, 11},
          sentOffIds: const {},
          withdrawnIds: {1},
          maxSubs: 3,
          playerId: 1,
        ),
        isFalse,
      );
    });

    test('allows a change while changes remain', () {
      expect(
        canBringOn(
          startingIds: {1, 2, 3, 4},
          onPitch: {2, 3, 4, 11},
          sentOffIds: const {},
          withdrawnIds: {1},
          maxSubs: 3,
          playerId: 12,
        ),
        isTrue,
      );
    });

    test('a sending-off does not consume a substitution', () {
      expect(
        canBringOn(
          startingIds: {1, 2, 3, 4},
          onPitch: {3, 4},
          sentOffIds: {2},
          withdrawnIds: {1},
          maxSubs: 3,
          playerId: 12,
        ),
        isTrue,
      );
    });
  });
}
```

- [x] **Step 2: Run the test to verify it fails**

Run: `flutter test test/unit/tactics/in_match_subs_test.dart`
Expected: FAIL — `substitution_rules.dart` does not exist.

- [x] **Step 3: Write the rule**

```dart
// lib/domain/services/tactics/substitution_rules.dart

/// Whether [playerId] may be put on the pitch.
///
/// Two things stop him. The side may have spent its changes — a starter who is
/// no longer on the pitch and was not sent off has cost a substitution, and a
/// sending-off costs a player rather than a change, so it never counts. And a
/// player already withdrawn cannot return: football has no re-entry, and the
/// board previously allowed it because nothing but a snackbar said otherwise.
bool canBringOn({
  required Set<int> startingIds,
  required Set<int> onPitch,
  required Set<int> sentOffIds,
  required Set<int> withdrawnIds,
  required int maxSubs,
  required int playerId,
}) {
  if (withdrawnIds.contains(playerId)) return false;
  if (sentOffIds.contains(playerId)) return false;
  if (onPitch.contains(playerId)) return true;
  final spent = startingIds
      .where((id) => !onPitch.contains(id) && !sentOffIds.contains(id))
      .length;
  return spent < maxSubs;
}
```

- [x] **Step 4: Run the test to verify it passes**

Run: `flutter test test/unit/tactics/in_match_subs_test.dart`
Expected: PASS

- [x] **Step 5: Wire the rule into the board**

In `in_match_tactics.dart`, track `withdrawnIds` in state (a starter leaves the
pitch → add; the state is per-sheet, so seed it from `widget.startingIds`
minus the current lineup on init). Then in `_setSlot`, refuse the change rather
than applying it:

```dart
void _setSlot(int slot, int playerId) {
  if (!canBringOn(
    startingIds: widget.startingIds.toSet(),
    onPitch: _onPitch,
    sentOffIds: widget.sentOffIds,
    withdrawnIds: _withdrawn,
    maxSubs: widget.maxSubs,
    playerId: playerId,
  )) {
    final l = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l.tacticsTooManySubs(widget.maxSubs))),
    );
    return;
  }
  setState(() {
    final l = [..._lineup];
    final existing = l.indexOf(playerId);
    if (existing != -1) {
      l[existing] = l[slot];
    } else if (l[slot] case final out?) {
      _withdrawn = {..._withdrawn, out};
    }
    l[slot] = playerId;
    _lineup = l;
  });
}
```

Keep the `_apply()` guard as a backstop — it costs nothing and covers any path
that does not go through `_setSlot`.

- [x] **Step 6: Verify and commit**

Run: `flutter analyze && flutter test test/unit/tactics/ test/widget/tactics_pitch_test.dart`
Expected: PASS

```bash
git add lib/domain/services/tactics/substitution_rules.dart lib/features/tactics/in_match_tactics.dart test/unit/tactics/in_match_subs_test.dart
git commit -m "fix: the substitution cap is enforced at the point of change"
```

---

### Task 3: Second yellows outnumber straight reds, and read differently [A3]

**Files:**
- Modify: `lib/domain/services/match/match_engine.dart:406`, `:940-1000`
- Modify: `lib/domain/services/match/match_simulator.dart` (matching discipline rates)
- Modify: match timeline rendering in `lib/features/match/match_screen.dart`
- Test: `test/unit/match/discipline_rates_test.dart` (create)

The engine already emits `redCard` with `secondYellow: true` (`:961`). It almost
never fires, because a second booking needs `_pickCulprit` to return the *same*
player twice out of ~1.3 bookings a team a game, while `_straightRedPerMinute =
0.0006` fires roughly once every 20 games. So straight reds dominate — the
reported bug.

Two changes: bias the culprit draw toward an already-booked player (a booked
player is the one on a knife edge), and cut the straight-red rate.

**Interfaces:**
- Consumes: `MatchEvent.secondYellow` (existing, `match_engine.dart:221`)
- Produces: no new API; rates change only

- [x] **Step 1: Write the failing distribution test**

```dart
// test/unit/match/discipline_rates_test.dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('second yellows outnumber straight reds across a season', () {
    var secondYellows = 0;
    var straightReds = 0;

    for (var seed = 0; seed < 400; seed++) {
      final result = simulateOneMatch(seed); // helper: see below
      for (final e in result.events) {
        if (e.type != MatchEventType.redCard) continue;
        if (e.secondYellow) {
          secondYellows++;
        } else {
          straightReds++;
        }
      }
    }

    // Real football sends far more players off for a second booking than for
    // violent conduct. The exact ratio is a tuning choice; the ordering is not.
    expect(secondYellows, greaterThan(straightReds));
    // And dismissals stay rare overall — roughly one in every few matches.
    expect(secondYellows + straightReds, lessThan(400 ~/ 2));
  });
}
```

Write `simulateOneMatch(int seed)` as a local helper using
`test/helpers/fixtures.dart` for the two squads and a `SeededRng(seed)`. Read
`test/unit/match/` for the existing engine-test setup and follow it rather than
inventing a new harness.

- [x] **Step 2: Run the test to verify it fails**

Run: `flutter test test/unit/match/discipline_rates_test.dart`
Expected: FAIL — straight reds outnumber second yellows.

- [x] **Step 3: Bias the culprit draw and cut the straight-red rate**

In `match_engine.dart`, change the rate:

```dart
/// Per-team, per-minute probability of a straight red. Deliberately well below
/// the second-booking rate: violent conduct is the rare dismissal, a second
/// caution the ordinary one.
static const double _straightRedPerMinute = 0.00015;
```

And give `_pickCulprit` an optional bias so a booked player is likelier to
concede the next foul:

```dart
/// [booked] players are likelier to be the culprit again — a man on a yellow
/// is the man mistiming the next challenge. Without this the same player has to
/// be drawn twice at random, which is why second bookings effectively never
/// happened.
Player _pickCulprit(
  _Live live,
  SeededRng rng, {
  bool injury = false,
  Set<int> booked = const {},
});
```

Weight already-booked players roughly 3× in the draw. Apply the same rate
change and the same bias in `match_simulator.dart` — per the global constraint,
these two move together.

- [x] **Step 4: Run the test to verify it passes**

Run: `flutter test test/unit/match/`
Expected: PASS — including the existing engine tests, which must not regress.

- [x] **Step 5: Render the two dismissals differently**

In the match timeline and the match report, a `redCard` with `secondYellow ==
true` shows the two-card icon (🟨🟥) and the second-booking wording; a straight
red shows 🟥. Add both strings to the ARB files:

```json
"matchSecondYellow": "Second yellow",
"matchStraightRed": "Red card",
```

```json
"matchSecondYellow": "Druhá žlutá",
"matchStraightRed": "Červená karta",
```

- [x] **Step 6: Verify and commit**

Run: `dart format --set-exit-if-changed lib test && flutter analyze && flutter test`
Expected: PASS

```bash
git add lib/domain/services/match/ lib/features/match/match_screen.dart lib/l10n/ test/unit/match/discipline_rates_test.dart
git commit -m "fix: second bookings are the common dismissal, and look like one"
```

---

### Task 4: Team overall on the match and on team detail [A4]

**Files:**
- Modify: `lib/features/match/match_preview_screen.dart`
- Modify: `lib/features/stats/team_stats_screen.dart`
- Test: `test/unit/tactics/squad_overall_test.dart` (create)

**Interfaces:**
- Produces: `int squadOverall(List<Player> squad)` in `lib/domain/services/rating/overall_rating.dart` — the rounded mean overall of the strongest eleven, not of the whole squad (a 26-man squad's mean is dragged down by its third-choice keeper and reads wrong next to a rival's).

- [x] **Step 1: Write the failing test**

```dart
// test/unit/tactics/squad_overall_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/rating/overall_rating.dart';

void main() {
  test('squad overall averages the best eleven, not the whole squad', () {
    final squad = [
      for (var i = 0; i < 11; i++) playerWithOverall(80),
      for (var i = 0; i < 12; i++) playerWithOverall(50),
    ];
    expect(squadOverall(squad), 80);
  });

  test('a short squad averages what it has', () {
    expect(squadOverall([playerWithOverall(70), playerWithOverall(60)]), 65);
  });

  test('an empty squad has no overall', () {
    expect(squadOverall(const []), 0);
  });
}
```

Use the existing player factory in `test/helpers/fixtures.dart` for
`playerWithOverall`; add it there if it is missing rather than defining a
second player builder in this file.

- [x] **Step 2: Run the test to verify it fails**

Run: `flutter test test/unit/tactics/squad_overall_test.dart`
Expected: FAIL — `squadOverall` is not defined.

- [x] **Step 3: Implement `squadOverall`**

```dart
/// The rounded mean overall of a squad's strongest eleven.
///
/// The best eleven rather than the whole squad: a 26-man mean is dragged down
/// by the third-choice keeper, so two sides that would field identical teams
/// would show different numbers purely on squad depth.
int squadOverall(List<Player> squad) {
  if (squad.isEmpty) return 0;
  final rated = [for (final p in squad) overallOf(p)]..sort((a, b) => b - a);
  final best = rated.take(11).toList();
  return (best.reduce((a, b) => a + b) / best.length).round();
}
```

Use whichever existing per-player overall function this file already exposes
in place of `overallOf` — read the file first and reuse it; do not add a second
way to compute a player's overall.

- [x] **Step 4: Run the test to verify it passes**

Run: `flutter test test/unit/tactics/squad_overall_test.dart`
Expected: PASS

- [x] **Step 5: Show it in both places**

On the match preview header, show each side's `squadOverall` beside its name.
On team detail (`team_stats_screen.dart`), show the nation's overall. Localise
the label:

```json
"teamOverall": "Overall",
```
```json
"teamOverall": "Celkový přehled",
```

- [x] **Step 6: Verify and commit**

Run: `flutter analyze && flutter test`

```bash
git add lib/domain/services/rating/overall_rating.dart lib/features/match/match_preview_screen.dart lib/features/stats/team_stats_screen.dart lib/l10n/ test/
git commit -m "feat: team overall on the match preview and team detail"
```

---

### Task 5: Seven-goal results become ultra rare [A5]

**Files:**
- Modify: `lib/domain/services/match/match_engine.dart` (scoreline draw)
- Modify: `lib/domain/services/match/match_simulator.dart` (same damping)
- Test: `test/unit/match/scoreline_distribution_test.dart` (create)

**Interfaces:**
- Consumes: the existing goal-chance-per-minute model in `match_engine`
- Produces: no new API

- [x] **Step 1: Write the failing distribution test**

```dart
// test/unit/match/scoreline_distribution_test.dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('scorelines of 7+ for one side are ultra rare', () {
    var blowouts = 0;
    const runs = 2000;

    for (var seed = 0; seed < runs; seed++) {
      final r = simulateOneMatch(seed); // same helper style as Task 3 [A3]
      if (r.homeGoals >= 7 || r.awayGoals >= 7) blowouts++;
    }

    // Well under one in two hundred. A 7-0 should be a story, not a Tuesday.
    expect(blowouts / runs, lessThan(0.005));
  });

  test('ordinary scorelines are unaffected', () {
    var totalGoals = 0;
    const runs = 2000;
    for (var seed = 0; seed < runs; seed++) {
      final r = simulateOneMatch(seed);
      totalGoals += r.homeGoals + r.awayGoals;
    }
    // Mean goals a game stays in the normal international band.
    expect(totalGoals / runs, inInclusiveRange(2.0, 3.6));
  });
}
```

The second test is the guard: damping the tail must not flatten ordinary
scorelines. Per project memory there is already a match-balance guard test —
find it (`test/unit/match/`) and make sure it still passes rather than
loosening it.

- [x] **Step 2: Run the test to verify it fails**

Run: `flutter test test/unit/match/scoreline_distribution_test.dart`
Expected: FAIL on the blowout rate.

- [x] **Step 3: Damp the tail**

Apply a progressive penalty to each additional goal once a side is three or
more clear: the per-minute goal chance for the leading side scales down as the
margin grows. A real side four up stops pressing; the model should too.

```dart
/// Once a side is well clear it stops chasing goals — substitutions, a dropped
/// tempo, and an opponent packing the box. Without this the per-minute model is
/// memoryless and a hot seed runs away to 8-0 far more often than football does.
double _blowoutDamping(int scored, int conceded) {
  final margin = scored - conceded;
  if (margin < 3) return 1.0;
  return 1.0 / (1.0 + (margin - 2) * 0.6);
}
```

Multiply the leading side's per-minute goal chance by this. Apply the identical
function in `match_simulator.dart`.

- [x] **Step 4: Run the tests to verify they pass**

Run: `flutter test test/unit/match/`
Expected: PASS, including the existing balance guard test.

- [x] **Step 5: Commit**

```bash
git add lib/domain/services/match/ test/unit/match/scoreline_distribution_test.dart
git commit -m "fix: a seven-goal win is ultra rare again"
```

---

## Phase B — Tournament flow

### Task 6: The intercontinental play-off becomes playable [B1]

**Files:**
- Modify: `lib/domain/services/competition/finals.dart:468-600`
- Modify: `lib/features/tournaments/intercontinental_playoff_screen.dart`
- Modify: `lib/features/hub/hub_event.dart:227-240`
- Test: `test/unit/competition/intercontinental_playoff_test.dart` (create)

This is the career-breaking bug and the most delicate task in the batch.

Today `Finals.playoffWinners` (`:492`) settles every tie through `_playoffMatch`
— a ranking-weighted coin flip — at the moment finalists are selected, and
`intercontinental_playoff_screen.dart` merely *replays that computation for
display*. There is no fixture and never was, so a manager in the pool is
eliminated without playing.

**The invariant that must hold:** the bracket display, the finalist selection
and the played result are the same six-team field with the same winners. If they
disagree, the finals draw contains a nation the bracket says lost.

**Interfaces:**
- Consumes: `Finals.playoffPoolFor(...) → List<int>` (existing, `:473`), `Finals.playoffBracket(...) → List<PlayoffTie>` (existing, `:532`)
- Produces: `Finals.playoffWinners(pool, rankingById, rng, {Map<int, int> playedResults = const {}})` — `playedResults` maps a tie key to the winning nation id; any tie present there uses the played result instead of `_playoffMatch`.

- [x] **Step 1: Write the failing test**

```dart
// test/unit/competition/intercontinental_playoff_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/services/competition/finals.dart';

void main() {
  final ranking = {1: 5, 2: 12, 3: 20, 4: 31, 5: 44, 6: 58};
  final pool = [1, 2, 3, 4, 5, 6];

  test('a played result overrides the deterministic tie', () {
    // Seed 7 with no played results gives some baseline winner set.
    final baseline = Finals.playoffWinners(pool, ranking, SeededRng(7));

    // Force the weakest side through its path final.
    final forced = Finals.playoffWinners(
      pool,
      ranking,
      SeededRng(7),
      playedResults: {Finals.tieKey(round: 'FINAL', slot: 0): 6},
    );

    expect(forced, contains(6));
    expect(forced, isNot(equals(baseline)));
  });

  test('winners still number exactly the available berths', () {
    final w = Finals.playoffWinners(pool, ranking, SeededRng(3));
    expect(w, hasLength(2));
  });

  test('the bracket and the winners agree', () {
    final rng = SeededRng(11);
    final winners = Finals.playoffWinners(pool, ranking, SeededRng(11));
    final bracket = Finals.playoffBracket(
      byConfederation: const {},
      rankingById: ranking,
      pool: pool,
      rng: rng,
    );
    final finalWinners =
        bracket.where((t) => t.round == 'FINAL').map((t) => t.winner).toList();
    expect(finalWinners.toSet(), winners.toSet());
  });
}
```

Read `finals.dart:532` first: `playoffBracket` takes `byConfederation` today.
The third test above asserts the invariant that matters — adapt its call to the
real signature rather than changing the signature to suit the test.

- [x] **Step 2: Run the test to verify it fails**

Run: `flutter test test/unit/competition/intercontinental_playoff_test.dart`
Expected: FAIL — `playedResults` and `tieKey` do not exist.

- [x] **Step 3: Add the played-result override**

Add a stable tie key and thread `playedResults` through `playoffWinners` and
`playoffBracket`, so both consult it before falling back to `_playoffMatch`:

```dart
/// A stable identifier for one play-off tie, so a played result can be matched
/// back to the slot it settled. Stable across rebuilds — the bracket is
/// recomputed every time it is shown, and a key derived from the nations in the
/// tie would move as soon as an earlier round was played for real.
static String tieKey({required String round, required int slot}) =>
    'ICPO-$round-$slot';

static int _settle(
  String key,
  int a,
  int b,
  Map<int, int> rankingById,
  SeededRng rng,
  Map<String, int> playedResults,
) {
  final played = playedResults[key];
  // A played tie is the truth. Only an unplayed one is settled by the model.
  if (played != null && (played == a || played == b)) return played;
  return _playoffMatch(a, b, rankingById, rng);
}
```

Route every `_playoffMatch` call in `playoffWinners` and `playoffBracket`
through `_settle` with the matching key. **Both functions must key ties
identically** — that is the invariant.

- [x] **Step 4: Run the test to verify it passes**

Run: `flutter test test/unit/competition/`
Expected: PASS — including existing finals and qualification tests.

- [x] **Step 5: Make the manager's ties real fixtures**

In `intercontinental_playoff_screen.dart`: when the manager's nation is in
`playoffPoolFor`, its ties are played or watched like any other knockout rather
than revealed. Persist each played result and feed it back as `playedResults`.

Follow the existing pattern for live knockout ties (`cup_detail_screen.dart`
routes to the match screen for the manager's fixtures) rather than inventing a
new one. Ties not involving the manager keep the deterministic path and are
simply revealed.

In `hub_event.dart:227`, the event currently gates on
`allQualifyingPlayed && !hasWatchedDraw(worldCupPlayoffKind)`. When the manager
is in the pool this must become *play the tie*, not *watch the reveal* — and
the World Cup finals draw at `:242` must stay gated behind it, so the draw can
never run before the manager's play-off is settled.

- [x] **Step 6: Add an end-to-end regression test**

```dart
test('a manager in the pool is never eliminated without a fixture', () async {
  // Build a career whose nation lands in the play-off pool, advance to the
  // point the finals field is selected, and assert a playable fixture exists
  // for that nation before any finalist list is produced.
});
```

Use `test/unit/full_cycle_test.dart` as the model for driving a career forward
— it already advances a save through a full cycle.

- [x] **Step 7: Verify and commit**

Run: `flutter analyze && flutter test`
Expected: PASS

```bash
git add lib/domain/services/competition/finals.dart lib/features/tournaments/intercontinental_playoff_screen.dart lib/features/hub/hub_event.dart test/unit/competition/intercontinental_playoff_test.dart
git commit -m "fix: the intercontinental play-off is played, not decided for you"
```

---

### Task 7: The tournament's best player is named only at the end [B2]

**Files:**
- Modify: `lib/domain/services/awards/awards.dart`
- Test: `test/unit/awards/award_timing_test.dart` (create)

**Interfaces:**
- Produces: awards return `null` (no award) until every fixture in the tournament has been played.

- [x] **Step 1: Write the failing test**

```dart
// test/unit/awards/award_timing_test.dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('no best player while a fixture is unplayed', () {
    final fixtures = [playedFixture(), playedFixture(), unplayedFixture()];
    expect(bestPlayerOf(fixtures, someStats), isNull);
  });

  test('the best player is named once every fixture is played', () {
    final fixtures = [playedFixture(), playedFixture()];
    expect(bestPlayerOf(fixtures, someStats), isNotNull);
  });
}
```

Read `awards.dart` first for the real award entry point and its parameter list;
name the test after that function rather than assuming `bestPlayerOf`.

- [x] **Step 2: Run the test to verify it fails**

Run: `flutter test test/unit/awards/award_timing_test.dart`
Expected: FAIL — an award is returned mid-tournament.

- [x] **Step 3: Gate the award on completeness**

```dart
/// No award until the tournament is actually over. The golden ball was being
/// handed out from the stats accumulated so far, so a group-stage hot streak
/// won it before the knockouts had been played.
if (fixtures.any((f) => !f.played)) return null;
```

Per project memory, the completeness check must cover *all* fixtures for the
tournament — the same all-fixtures participant check the live-finals routing
needs. Reuse that helper if one exists rather than writing a second.

- [x] **Step 4: Run the test to verify it passes**

Run: `flutter test test/unit/awards/`
Expected: PASS

- [x] **Step 5: Commit**

```bash
git add lib/domain/services/awards/awards.dart test/unit/awards/award_timing_test.dart
git commit -m "fix: the tournament's best player is named after the final, not before it"
```

---

### Task 8: The passive World Cup simulation paginates by round [B3]

**Files:**
- Modify: `lib/features/tournaments/cup_detail_screen.dart`
- Test: `test/widget/passive_sim_pagination_test.dart` (create)

**Interfaces:**
- Consumes: existing round codes (`'GROUP'`, `'R32'`, `'R16'`, `'QF'`, `'SF'`, `'3RD'`, `'FINAL'` — see `elo.dart:_knockoutSuffixes`)

- [ ] **Step 1: Write the failing widget test**

```dart
// test/widget/passive_sim_pagination_test.dart
testWidgets('the passive sim shows one round at a time', (tester) async {
  await pumpPassiveSim(tester, rounds: ['GROUP', 'R16', 'QF', 'SF', 'FINAL']);

  // Only the current round's fixtures are on screen.
  expect(find.byType(MatchResultRow), findsNWidgets(groupFixtureCount));
  expect(find.text('QF'), findsNothing);

  await tester.tap(find.byKey(const Key('passive-sim-next-round')));
  await tester.pumpAndSettle();

  expect(find.text('R16'), findsOneWidget);
});
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/widget/passive_sim_pagination_test.dart`
Expected: FAIL — everything renders in one list.

- [ ] **Step 3: Paginate**

Replace the single scrolling list with a round-at-a-time view: a header naming
the round, that round's fixtures, and previous/next controls. Key the next
control `passive-sim-next-round`.

- [ ] **Step 4: Run the test to verify it passes**

Run: `flutter test test/widget/passive_sim_pagination_test.dart`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add lib/features/tournaments/cup_detail_screen.dart test/widget/passive_sim_pagination_test.dart
git commit -m "feat: the passive tournament sim pages by round instead of scrolling"
```

---

### Task 9: Gold Cup winners after 2023 [B4]

**Files:**
- Modify: `lib/domain/services/competition/real_history.dart:1197+`
- Test: `test/unit/competition/real_history_test.dart` (extend if it exists, else create)

- [x] **Step 1: Write the failing test**

```dart
test('the North America Cup record runs to the present', () {
  final winners = RealHistory.northAmericaCupWinners;
  expect(winners.keys.reduce((a, b) => a > b ? a : b),
      greaterThanOrEqualTo(2025));
});
```

Read `real_history.dart:1197` for the actual field name and shape of the record
before writing this; match it exactly.

- [x] **Step 2: Run the test to verify it fails**

Run: `flutter test test/unit/competition/real_history_test.dart`
Expected: FAIL — the record stops at 2023.

- [x] **Step 3: Extend the record**

Add the 2025 edition (Mexico won, beating the United States 2-1 in the final).
There was no 2024 edition — the tournament runs biennially in odd years, so a
gap at 2024 is correct, not missing data.

- [x] **Step 4: Run the test to verify it passes**

Run: `flutter test test/unit/competition/real_history_test.dart`
Expected: PASS

- [x] **Step 5: Commit**

```bash
git add lib/domain/services/competition/real_history.dart test/unit/competition/real_history_test.dart
git commit -m "fix: the North America Cup record no longer stops at 2023"
```

---

## Phase C — Squad, youth, players

### Task 10: The call-up screen gets position tabs [C1]

**Files:**
- Modify: `lib/features/tactics/call_up_screen.dart` (all three reported items live here)
- Test: `test/widget/call_up_tabs_test.dart` (create)

Three reported problems, one fix: the screen overflows, it demands scrolling,
and the `clubFirstChoice` label ("Plays every week", rendered at `:728` via
`clubStandingLabel`) overlaps its neighbours.

**Interfaces:**
- Consumes: `clubStandingLabel(AppLocalizations, ClubStanding)` (existing, `:620`), `_PlayerToggle` (existing, `:627`)
- Produces: no new public API

- [ ] **Step 1: Write the failing widget test**

```dart
// test/widget/call_up_tabs_test.dart
testWidgets('the call-up screen groups players by line', (tester) async {
  await tester.binding.setSurfaceSize(const Size(360, 690));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await pumpCallUpScreen(tester, squad: mixedSquad());

  expect(find.text('GK'), findsOneWidget);
  expect(find.text('DEF'), findsOneWidget);
  expect(find.text('MID'), findsOneWidget);
  expect(find.text('FWD'), findsOneWidget);

  // The keepers tab shows keepers and nobody else.
  await tester.tap(find.text('GK'));
  await tester.pumpAndSettle();
  expect(find.byType(PlayerToggle), findsNWidgets(keeperCount));

  // Selection survives a tab change — it is one squad, viewed four ways.
  await tester.tap(find.byType(PlayerToggle).first);
  await tester.tap(find.text('DEF'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('GK'));
  await tester.pumpAndSettle();
  expect(selectedCount(tester), 1);

  // And nothing overflows at phone width.
  expect(tester.takeException(), isNull);
});
```

`test/widget/layout_regression_test.dart` already exists — read it and follow
its overflow-detection convention instead of inventing a second one.

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/widget/call_up_tabs_test.dart`
Expected: FAIL — no tabs exist.

- [ ] **Step 3: Restructure around four tabs**

Replace the single `ListView` (`:383`) with a `TabBar`/`TabBarView` over GK,
DEF, MID, FWD. Selection state stays where it is on `_CallUpScreenState` — the
tabs are a view over one squad, so nothing about selection moves.

Keep the coverage banner (`_CoverageBanner`, `:507`) *outside* the tab view: it
reports on the whole squad and must not disappear when the manager is looking
at keepers.

- [ ] **Step 4: Fix the club-standing label overlap**

In `_PlayerToggle` (`:656-776`), the standing label at `:728` sits in a row that
cannot give it room. Constrain it — `Flexible` with `TextOverflow.ellipsis` —
and let the badges beside it keep their intrinsic width.

- [ ] **Step 5: Run the tests to verify they pass**

Run: `flutter test test/widget/call_up_tabs_test.dart test/widget/layout_regression_test.dart test/widget/club_standing_badge_test.dart`
Expected: PASS

- [ ] **Step 6: Commit**

```bash
git add lib/features/tactics/call_up_screen.dart test/widget/call_up_tabs_test.dart
git commit -m "feat: call-ups are picked line by line instead of scrolled"
```

---

### Task 11: Newgens enter the pyramid at 13–15 [C2]

**Files:**
- Modify: `lib/domain/services/player/prospects.dart:80` and its age bands
- Modify: `lib/domain/services/player/player_lifecycle.dart` (intake age)
- Test: `test/unit/squad/youth_intake_test.dart` (create)

Intake starts at 17 today, so a generation appears fully formed. It should start
at the bottom of the pyramid and grow up through it.

**Read first:** `docs/superpowers/specs/2026-08-05-youth-pyramid-design.md` and
`2026-08-06-intake-day-design.md` — the pyramid is a recent, deliberate design
and this task changes one of its parameters, not its shape.

**Interfaces:**
- Consumes: `YouthLevel` (u13 … u21) with `minAge` (existing)
- Produces: no new API; intake age changes

- [ ] **Step 1: Write the failing test**

```dart
// test/unit/squad/youth_intake_test.dart
test('new faces first appear in the youngest bands', () {
  final intake = Prospects.poolAt(year: 2030, seed: 1, minAge: 13);
  final ages = intake.map((p) => p.age).toSet();
  expect(ages.reduce((a, b) => a < b ? a : b), lessThanOrEqualTo(15));
});

test('a player generated at 13 is still present at 17', () {
  final young = Prospects.poolAt(year: 2030, seed: 1, minAge: 13)
      .firstWhere((p) => p.age == 13);
  final later = Prospects.poolAt(year: 2034, seed: 1, minAge: 13);
  expect(later.map((p) => p.id), contains(young.id));
});
```

The second test is the one that matters — it asserts the players *progress*
rather than a new cohort being generated per band. Read `prospects.dart` for the
real `poolAt` signature (project memory records `minAge 17`) and match it.

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/unit/squad/youth_intake_test.dart`
Expected: FAIL — nobody below 17 exists.

- [ ] **Step 3: Lower the intake age**

Move intake to 13 and revisit the age bands as a whole. Note `prospects.dart:80`
already branches on `YouthLevel.u19.minAge` for its spread — that branch was
written for a 17+ world and needs redoing across the full range, not patching
at one edge.

- [ ] **Step 4: Run the tests to verify they pass**

Run: `flutter test test/unit/squad/ test/widget/youth_screen_test.dart`
Expected: PASS

- [ ] **Step 5: Check whether the schema needs a bump**

Per project memory, schema 39 exists specifically to clear stale newgen rows. If
this change invalidates stored newgens the same way, a bump is needed — **and a
bump wipes saves. Stop and ask the user before bumping.**

- [ ] **Step 6: Commit**

```bash
git add lib/domain/services/player/ test/unit/squad/youth_intake_test.dart
git commit -m "feat: prospects are discovered at thirteen and grow up through the pyramid"
```

---

### Task 12: A player promoted out of U-19 is not outshone in U-21 [C3]

**Files:**
- Modify: `lib/domain/services/player/prospects.dart`
- Test: `test/unit/squad/youth_promotion_test.dart` (create)

The reported bug: the U-21 group reads weaker than the U-19 group, because
reaching the age generates a new cohort rather than promoting the players who
were already there.

- [ ] **Step 1: Write the failing test**

```dart
// test/unit/squad/youth_promotion_test.dart
test('the U-21 group is never weaker than the U-19 group', () {
  for (var seed = 0; seed < 50; seed++) {
    final u19 = Prospects.poolFor(YouthLevel.u19, year: 2030, seed: seed);
    final u21 = Prospects.poolFor(YouthLevel.u21, year: 2030, seed: seed);
    expect(bestOverall(u21), greaterThanOrEqualTo(bestOverall(u19)),
        reason: 'seed $seed: the best U-19 should have been promoted');
  }
});
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/unit/squad/youth_promotion_test.dart`
Expected: FAIL on at least one seed.

- [ ] **Step 3: Promote rather than regenerate**

A player's band must be a function of his age, so the same generated player
moves up as the years pass. If bands are currently generated independently, the
fix is to generate once at intake (Task 11 [C2]) and derive the band from age.

- [ ] **Step 4: Run the tests to verify they pass**

Run: `flutter test test/unit/squad/`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add lib/domain/services/player/prospects.dart test/unit/squad/youth_promotion_test.dart
git commit -m "fix: the best under-19 is promoted rather than replaced"
```

---

### Task 13: The grievance event waits for a squad, and stays resolved [C4]

**Files:**
- Modify: `lib/features/hub/hub_event.dart:383`
- Modify: `lib/features/squad/grievance_providers.dart`
- Test: `test/unit/hub/grievance_gating_test.dart` (create)

`wantsAWord` (`:383`) surfaces a player grievance before the manager has ever
named a squad — there is nothing to have a grievance about — and it returns
after an app restart, so it reads as unresolved.

- [ ] **Step 1: Write the failing test**

```dart
// test/unit/hub/grievance_gating_test.dart
test('no grievance before the first squad is named', () async {
  final career = await freshCareer();
  expect(await grievanceFor(career), isNull);
});

test('a resolved grievance does not return after a restart', () async {
  final career = await careerWithNamedSquad();
  final g = await grievanceFor(career);
  expect(g, isNotNull);

  await resolveGrievance(career, g!);
  // A second read is what a restart does — providers rebuild from the database.
  expect(await grievanceFor(career), isNull);
});
```

Use `test/helpers/test_database.dart` for the career fixtures. Per project
memory, derived providers go stale — invalidate explicitly between the write
and the second read rather than trusting a cached value.

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/unit/hub/grievance_gating_test.dart`
Expected: FAIL on both.

- [ ] **Step 3: Gate and persist**

Gate `grievanceProvider` on at least one squad having been named, and persist
the resolution so a rebuild does not resurrect it.

- [ ] **Step 4: Run the tests to verify they pass**

Run: `flutter test test/unit/hub/`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add lib/features/hub/hub_event.dart lib/features/squad/grievance_providers.dart test/unit/hub/grievance_gating_test.dart
git commit -m "fix: players do not air grievances before they have been picked"
```

---

### Task 14: Every player has a club history [C5]

**Files:**
- Modify: `lib/domain/services/club/club_history.dart` callers
- Test: `test/unit/domain/club_history_test.dart` (extend if it exists)

`ClubHistory.spells` is sound — it collapses a season-by-season list. The gap is
in which players get a populated `byYear`.

- [ ] **Step 1: Write the failing test**

```dart
test('every player in the pool has at least one club spell', () {
  for (final p in poolFor(nation: 'BRA', year: 2032, seed: 4)) {
    expect(clubHistoryFor(p), isNotEmpty, reason: 'player ${p.id} has none');
  }
});
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/unit/domain/club_history_test.dart`
Expected: FAIL for some players.

- [ ] **Step 3: Populate `byYear` for every player**

Find why some players yield an empty year list — likely players whose career
years predate a boundary the builder starts from. Clubs are derived from rating
and seed (`ClubService`), so every player who existed in a season has a club in
it; the history should never be empty for a player with any seasons at all.

- [ ] **Step 4: Run the test to verify it passes**

Run: `flutter test test/unit/domain/`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add lib/domain/services/club/ test/unit/domain/club_history_test.dart
git commit -m "fix: every player carries a club history, not just some"
```

---

### Task 15: More players abroad, and international transfers are visible [C6]

**Files:**
- Modify: `lib/domain/services/club/clubs.dart:40-200`
- Test: `test/unit/domain/clubs_abroad_test.dart` (create)

The foreign path already exists (`:82`) — retention is simply tuned too far
toward home. Separately, the transfer feed only shows domestic moves.

**Read first:** `clubs.dart:115-200`. The comments there are explicit that
retention is about pull rather than tier and that no single ordering gets both
strong-domestic and export nations right. Retune within that model; do not
replace it.

- [ ] **Step 1: Write the failing test**

```dart
// test/unit/domain/clubs_abroad_test.dart
test('a strong nation exports most of its best players', () {
  final squad = bestSquadFor(nation: 'BRA', year: 2032, seed: 9);
  final abroad = squad.where((p) => clubOf(p).country != 'BRA').length;
  expect(abroad / squad.length, greaterThan(0.6));
});

test('a strong-domestic nation still keeps most of its own', () {
  final squad = bestSquadFor(nation: 'ENG', year: 2032, seed: 9);
  final home = squad.where((p) => clubOf(p).country == 'ENG').length;
  expect(home / squad.length, greaterThan(0.5));
});
```

The second test is the guard — it is the case `clubs.dart` warns about, and
loosening retention must not break it.

- [ ] **Step 2: Run the tests to verify the first fails**

Run: `flutter test test/unit/domain/clubs_abroad_test.dart`
Expected: FAIL on the export rate, PASS on the guard.

- [ ] **Step 3: Retune retention**

Shift the home/abroad draw toward abroad for nations whose model says export.

- [ ] **Step 4: Show international moves in the transfer feed**

Find the transfer feed's filter and remove the domestic-only restriction so a
move to a foreign league is reported like any other.

- [ ] **Step 5: Run the tests to verify they pass**

Run: `flutter test test/unit/domain/`
Expected: PASS on both.

- [ ] **Step 6: Commit**

```bash
git add lib/domain/services/club/clubs.dart test/unit/domain/clubs_abroad_test.dart
git commit -m "feat: more players ply their trade abroad, and the move is reported"
```

---

### Task 16: An active scorer is not listed as inactive [C7]

**Files:**
- Modify: `lib/domain/services/stats/career_stats.dart` or the all-time scorer query in `lib/features/stats/`
- Test: `test/unit/stats/all_time_active_test.dart` (create)

A player appearing in a live tournament shows as not active in the all-time
scorer table — the active flag is read from the wrong source.

- [ ] **Step 1: Write the failing test**

```dart
// test/unit/stats/all_time_active_test.dart
test('a player in the current squad is active in the all-time table', () async {
  final career = await careerMidTournament();
  final scorer = await topScorer(career);
  expect(scorer.isActive, isTrue);
});
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/unit/stats/all_time_active_test.dart`
Expected: FAIL — `isActive` is false.

- [ ] **Step 3: Read the flag from the right source**

A player is active if he has not retired as of the current in-game date. Find
where the all-time table derives this and correct it. Per project memory,
imperative database reads never notice a sim step — if the flag is computed
against a snapshot taken before the tournament, that is the bug.

- [ ] **Step 4: Run the test to verify it passes**

Run: `flutter test test/unit/stats/`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add lib/domain/services/stats/ lib/features/stats/ test/unit/stats/all_time_active_test.dart
git commit -m "fix: a player still playing is not listed as retired"
```

---

## Phase D — Y and the press

### Task 17: Y posts read the save, not a template pool [D1]

**Files:**
- Modify: `lib/domain/services/press/y_feed.dart`
- Test: `test/unit/press/y_variety_test.dart` (create)

**Read first:** `docs/superpowers/specs/2026-08-07-y-feed-design.md`. The
structure it sets — `YPost` carrying a template plus args, localised at render —
is correct and stays. What changes is how much context reaches the args and how
many distinct shapes exist.

Today: `YTemplate` with `variantCount = 4` (`:77`) and `maxPostsPerEvent = 3`
(`:80`), classified from a `YMatch` (`:58`) that carries little more than the
scoreline. A long save therefore repeats.

**Interfaces:**
- Consumes: `YPost`, `YVoice`, `YTemplate`, `YFeed.mostRecent` (existing)
- Produces: `YContext` — the record of save state a post can draw on:

```dart
/// What the world knows when it writes about a match. Everything here is
/// already recorded elsewhere; gathering it is what lets a post name a player
/// and a streak rather than saying "a good result".
typedef YContext = ({
  YMatch match,
  String? scorerName,
  int? scorerGoals,
  int winStreak,
  int lossStreak,
  bool isRivalry,
  List<String> injuredNames,
  int boardMood,
});
```

- [ ] **Step 1: Write the failing variety test**

```dart
// test/unit/press/y_variety_test.dart
test('a long run of results does not repeat itself', () {
  final posts = <YPost>[];
  for (var i = 0; i < 40; i++) {
    posts.addAll(YFeed.forMatch(contextForRun(i), seed: 1));
  }
  // No template-and-args pair appears twice inside any window of ten posts.
  for (var i = 0; i < posts.length - 10; i++) {
    final window = posts.skip(i).take(10);
    final shapes = window.map((p) => '${p.template}|${p.args.join(",")}');
    expect(shapes.toSet(), hasLength(window.length),
        reason: 'repeat inside window at $i');
  }
});

test('a post names the scorer when there was one', () {
  final posts = YFeed.forMatch(
    contextWithScorer('Halvorsen', goals: 2),
    seed: 1,
  );
  expect(posts.any((p) => p.args.contains('Halvorsen')), isTrue);
});

test('a streak is remarked on', () {
  final posts = YFeed.forMatch(contextWithWinStreak(5), seed: 1);
  expect(posts.any((p) => p.template == YTemplate.streak), isTrue);
});
```

- [ ] **Step 2: Run the tests to verify they fail**

Run: `flutter test test/unit/press/y_variety_test.dart`
Expected: FAIL — no `YContext`, no streak template, repeats inside the window.

- [ ] **Step 3: Widen the context and the template set**

Change `forMatch` to take a `YContext`. Add templates for the shapes the
context now makes possible — a named scorer, a streak, a rivalry result, an
injury blow, a board under pressure — and raise `variantCount` so each has
several wordings.

Add a no-repeat window: a template-and-args pair already used in the last ten
posts is skipped in favour of the next candidate.

- [ ] **Step 4: Add the strings for every new template**

Every new `YTemplate` needs its wordings in **both** `app_en.arb` and
`app_cs.arb`. A template with no Czech wording renders blank in a Czech save.

- [ ] **Step 5: Run the tests to verify they pass**

Run: `flutter test test/unit/press/ test/widget/y_screen_test.dart`
Expected: PASS

- [ ] **Step 6: Commit**

```bash
git add lib/domain/services/press/y_feed.dart lib/l10n/ test/unit/press/y_variety_test.dart
git commit -m "feat: Y writes about what actually happened"
```

---

### Task 18: Y gets an unread count and tappable posts [D2]

**Files:**
- Modify: `lib/features/y/y_screen.dart`, `lib/features/y/y_providers.dart`
- Create: `lib/features/y/y_post_detail.dart`
- Test: `test/widget/y_screen_test.dart` (extend)

**Interfaces:**
- Consumes: `YPost.key` (existing — the stable per-event id, which is what marks a post read)
- Produces: `yUnreadCountProvider(careerId) → int`

- [ ] **Step 1: Write the failing test**

```dart
testWidgets('the Y tab shows how much is unread', (tester) async {
  await pumpYScreen(tester, posts: threeUnreadPosts());
  expect(find.text('3'), findsOneWidget);
});

testWidgets('a post opens its detail', (tester) async {
  await pumpYScreen(tester, posts: threeUnreadPosts());
  await tester.tap(find.byType(YPostTile).first);
  await tester.pumpAndSettle();
  expect(find.byType(YPostDetail), findsOneWidget);
});
```

- [ ] **Step 2: Run the tests to verify they fail**

Run: `flutter test test/widget/y_screen_test.dart`
Expected: FAIL — no count, posts are inert.

- [ ] **Step 3: Add the unread count**

Store the last-read post key per career and count posts newer than it. The
count is on the bottom-nav Y tab.

- [ ] **Step 4: Add the detail view**

A tapped post opens `YPostDetail`: the post itself, its author, the event it
came from, and any replies from other voices about that same event (they share
a `key`).

- [ ] **Step 5: Run the tests to verify they pass**

Run: `flutter test test/widget/y_screen_test.dart`
Expected: PASS

- [ ] **Step 6: Commit**

```bash
git add lib/features/y/ lib/l10n/ test/widget/y_screen_test.dart
git commit -m "feat: Y counts what is unread and posts open"
```

---

### Task 19: Press conferences ask about what happened [D3]

**Files:**
- Modify: `lib/domain/services/press/press.dart`
- Test: `test/unit/press/press_variety_test.dart` (create)

`storyPool = 4` (`:101`) over a fixed `PressTopic` enum (`:44`) is why the same
questions recur.

**Interfaces:**
- Consumes: `PressTopic`, `PressTone`, `PressQuestion`, `Press.optionsFor` (existing)
- Produces: `Press.questionsFor(YContext context, {required int seed})` — reusing the `YContext` from Task 17 [D1] rather than defining a second context record. **Task 17 [D1] must land first.**

- [ ] **Step 1: Write the failing test**

```dart
// test/unit/press/press_variety_test.dart
test('consecutive conferences do not ask the same thing', () {
  final asked = <PressTopic>[];
  for (var i = 0; i < 12; i++) {
    asked.addAll(Press.questionsFor(contextForRun(i), seed: 1).map((q) => q.topic));
  }
  for (var i = 0; i < asked.length - 4; i++) {
    final window = asked.skip(i).take(4);
    expect(window.toSet(), hasLength(window.length),
        reason: 'the same topic recurs inside four questions at $i');
  }
});

test('a heavy defeat is asked about', () {
  final qs = Press.questionsFor(contextWithDefeat(0, 4), seed: 1);
  expect(qs.any((q) => q.topic == PressTopic.heavyDefeat), isTrue);
});
```

- [ ] **Step 2: Run the tests to verify they fail**

Run: `flutter test test/unit/press/press_variety_test.dart`
Expected: FAIL.

- [ ] **Step 3: Drive questions from context**

Select topics by what the context makes relevant — a heavy defeat, a striker's
drought, a rivalry coming up, an injury, a board losing patience — and keep a
no-repeat window over recently asked topics. Add the new `PressTopic` values
and their `optionsFor` tone sets.

- [ ] **Step 4: Add the strings**

Every new topic needs its question wordings and its answer options in **both**
ARB files.

- [ ] **Step 5: Run the tests to verify they pass**

Run: `flutter test test/unit/press/`
Expected: PASS

- [ ] **Step 6: Commit**

```bash
git add lib/domain/services/press/press.dart lib/l10n/ test/unit/press/press_variety_test.dart
git commit -m "feat: the press asks about the match you just played"
```

---

## Phase E — Naming, UI, balance

### Task 20: Achievements use the licence-safe name [E1]

**Files:**
- Modify: `lib/domain/services/achievements/achievements.dart:283-422`
- Test: `test/unit/achievements/naming_test.dart` (create)

`worldCupHonourName = 'World Championship'` (`:101`) is the licence-safe stored
name, but the achievement titles and descriptions say "World Cup".

**`worldCupHonourName` itself must not change** — it is a stored value and
changing it orphans every honour already recorded in existing saves.

- [ ] **Step 1: Write the failing test**

```dart
// test/unit/achievements/naming_test.dart
test('no achievement says "World Cup"', () {
  for (final a in Achievements.all) {
    expect(a.title, isNot(contains('World Cup')), reason: a.id);
    expect(a.description, isNot(contains('World Cup')), reason: a.id);
  }
});

test('the stored honour name is unchanged', () {
  // Existing saves key their honours on this exact string.
  expect(worldCupHonourName, 'World Championship');
});
```

- [ ] **Step 2: Run the tests to verify the first fails**

Run: `flutter test test/unit/achievements/naming_test.dart`
Expected: FAIL on the naming test, PASS on the guard.

- [ ] **Step 3: Rename the user-facing strings**

"World Cup Qualifier" → "World Championship Qualifier", "Win the World Cup." →
"Win the World Championship.", "World Cup Marksman" → "World Championship
Marksman", and the remaining occurrences at `:283`, `:301`, `:334`, `:335`,
`:414`, `:422`. Update the Czech strings to match.

- [ ] **Step 4: Run the tests to verify they pass**

Run: `flutter test test/unit/achievements/`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add lib/domain/services/achievements/achievements.dart lib/l10n/ test/unit/achievements/naming_test.dart
git commit -m "fix: achievements use the licence-safe competition name"
```

---

### Task 21: A nation's overall over time [E2]

**Files:**
- Modify: `lib/features/stats/team_stats_screen.dart`
- Test: `test/widget/team_overall_history_test.dart` (create)

**Interfaces:**
- Consumes: `squadOverall` from Task 4 [A4]. **Task 4 [A4] must land first.**
- Produces: `teamOverallHistoryProvider(careerId) → List<({int year, int overall})>`

- [ ] **Step 1: Write the failing test**

```dart
testWidgets('team detail charts the nation overall by year', (tester) async {
  await pumpTeamStats(tester, history: [
    (year: 2030, overall: 71),
    (year: 2031, overall: 74),
    (year: 2032, overall: 78),
  ]);
  expect(find.byKey(const Key('team-overall-history')), findsOneWidget);
});
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/widget/team_overall_history_test.dart`
Expected: FAIL.

- [ ] **Step 3: Build the history**

Compute `squadOverall` per year from the players who existed that year. Derived,
not stored — a player is a function of seed and year, so the history is
recomputable and needs no table.

- [ ] **Step 4: Chart it**

A simple line, keyed `team-overall-history`. Follow whatever chart or sparkline
convention the app already uses; do not add a charting dependency.

- [ ] **Step 5: Run the test to verify it passes**

Run: `flutter test test/widget/team_overall_history_test.dart`
Expected: PASS

- [ ] **Step 6: Commit**

```bash
git add lib/features/stats/ test/widget/team_overall_history_test.dart
git commit -m "feat: a nation's overall is a curve you can see"
```

---

### Task 22: The World Cup moves you more, a single match less [E3]

**Files:**
- Modify: `lib/domain/services/ranking/elo.dart:28-48`
- Test: `test/unit/ranking/elo_weights_test.dart` (extend if it exists)

**Read the comments at `elo.dart:17-27` before changing anything.** They record
a floor that has already been hit once: below roughly K=4 an expected friendly
win rounds to zero and the table looks frozen. Do not go under it.

- [ ] **Step 1: Write the failing test**

```dart
// test/unit/ranking/elo_weights_test.dart
test('a World Cup run outweighs any run of ordinary results', () {
  expect(Elo.finalsSettled, greaterThan(Elo.finals * 2));
});

test('a single qualifier moves a side less than it used to', () {
  expect(Elo.qualifier, lessThan(16));
});

test('an expected friendly win still moves the table', () {
  final before = Elo.base;
  final after = Elo.applyResult(
    points: before,
    opponentPoints: before - 100,
    weight: Elo.friendly,
    outcome: MatchOutcome.win,
  );
  // The documented floor: this must not round to zero.
  expect(after, greaterThan(before));
});
```

Read `elo.dart` for the real result-application function and match its
signature; `applyResult` above is illustrative.

- [ ] **Step 2: Run the tests to verify they fail**

Run: `flutter test test/unit/ranking/elo_weights_test.dart`
Expected: FAIL on the first two.

- [ ] **Step 3: Retune the weights**

```dart
static const double friendly = 4;      // at the floor; do not lower
static const double nationsCup = 8;    // was 10
static const double qualifier = 12;    // was 16
static const double finals = 24;       // was 30
static const double finalsSettled = 72; // was 48
```

Update the doc comments to record *why* — the same way the existing comments
record the last retune.

- [ ] **Step 4: Run the tests to verify they pass**

Run: `flutter test test/unit/ranking/`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add lib/domain/services/ranking/elo.dart test/unit/ranking/elo_weights_test.dart
git commit -m "balance: a World Championship moves a nation further, a single match less"
```

---

### Task 23: Board objectives are kinder to weak nations and harsher on collapse [E4]

**Files:**
- Modify: `lib/domain/services/achievements/board_satisfaction.dart`
- Modify: `lib/features/hub/objective_providers.dart` (target selection)
- Test: `test/unit/achievements/board_tolerance_test.dart` (create)

Two asks that pull in opposite directions by design: a weak nation should not be
handed a target it cannot reach, but genuinely bad results should end a job
faster. Tolerance goes on the *objective*; severity goes on the *collapse*.

- [ ] **Step 1: Write the failing test**

```dart
// test/unit/achievements/board_tolerance_test.dart
test('a weak nation is not asked to win the tournament', () {
  final target = objectiveFor(worldRanking: 120, tier: TournamentTier.world);
  expect(target, lessThanOrEqualTo(2)); // qualify, no more
});

test('a strong nation is still asked for a trophy', () {
  final target = objectiveFor(worldRanking: 3, tier: TournamentTier.world);
  expect(target, greaterThanOrEqualTo(6));
});

test('ten straight defeats costs the job whatever the ranking', () {
  var mood = BoardSatisfaction.neutral;
  for (var i = 0; i < 10; i++) {
    mood = BoardSatisfaction.afterMatch(mood, MatchOutcome.loss);
  }
  expect(mood, lessThan(sackingThreshold));
});
```

The third test is a guard the existing code already documents at
`board_satisfaction.dart` — a manager who loses ten straight should not be saved
by their world ranking. Keep it passing.

- [ ] **Step 2: Run the tests to verify they fail**

Run: `flutter test test/unit/achievements/board_tolerance_test.dart`
Expected: FAIL on the first.

- [ ] **Step 3: Scale the target by ranking, sharpen the collapse**

Make the objective target a function of world ranking so a 120th-ranked nation
is asked to qualify and nothing more. Separately, steepen the loss weight (`loss
= -4` today) or lower the sacking bar so a genuinely bad run ends sooner.

Change one at a time and re-run — these two interact, and the third test is the
boundary between them.

- [ ] **Step 4: Run the tests to verify they pass**

Run: `flutter test test/unit/achievements/ test/unit/hub/`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add lib/domain/services/achievements/board_satisfaction.dart lib/features/hub/objective_providers.dart test/unit/achievements/board_tolerance_test.dart
git commit -m "balance: gentler objectives for weak nations, a firmer bar for collapse"
```

---

## Final verification

- [ ] **Full suite green**

Run: `dart format --set-exit-if-changed lib test && flutter analyze && flutter test`
Expected: PASS, no analyzer warnings.

- [ ] **Device playtest** — the five things no test can sign off:

1. Scoreline distribution over a full season — 7+ results should feel like news.
2. Ranking movement after E3 — a World Championship run should visibly climb.
3. Board tolerance across one weak and one strong nation.
4. Y and press variety over a long save — read 30+ posts and look for repeats.
5. The call-up tabs and the match control bar on a real phone screen.

Per project memory: build the release APK and push over wireless ADB (the mDNS
port goes stale — re-pair if it fails), or build to "Bison's iPhone".

- [ ] **Update project memory** with the batch outcome and any schema bump.
