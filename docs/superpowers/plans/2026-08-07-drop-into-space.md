# Dropping a Player Into Space — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Drag a player and release him in open pitch space, and the formation rearranges to the nearest real shape that puts him where you dropped him.

**Architecture:** A pure resolver beside the existing `resolveDrag`, reading the target line off the same adjusted layout the pitch renders, and only ever returning one of the 17 defined formations. The widget gains a `DragTarget` *behind* the player stack, so dropping on a team-mate still takes today's path untouched.

**Tech Stack:** Dart / Flutter, Riverpod (no codegen).

## Global Constraints

- **Only real formations are reachable.** Every outcome must be a member of `Formation.values`. The existing `formationForCounts` is the only way a formation is chosen; do not synthesise line counts that no formation has.
- **Dropping ON a player must not change.** `resolveDrag`, `onSwap` and `onBenchIn` keep their current behaviour exactly. This work is additive.
- **One definition of the layout maths.** The y-adjustment currently lives in `TacticsPitch._adjusted`. It gets extracted so the resolver and the renderer share it — two copies would drift, and the feature would then disagree with what is on screen precisely when the instructions are extreme.
- **Riverpod without codegen** — never add `@riverpod`.
- **Line length 80 characters**, matching the surrounding style.
- **Verification:** `flutter analyze lib test` reports no `error •` or `warning •` outside `test/generated_migrations/` (pre-existing `strict_raw_type` noise, not yours). `flutter test test/unit test/widget` ends `All tests passed!`.
- **Known pre-existing flake:** `test/unit/hub/season_service_exclusive_test.dart` "two advances in one frame" fails about one run in three under load and passes alone. Not yours.

---

### Task 1: The resolver

**Files:**
- Modify: `lib/features/tactics/tactics_pitch.dart`
- Test: `test/unit/tactics/space_drag_test.dart` (create)

**Interfaces:**
- Consumes: `DragOutcome` / `ReshapeTo` (already in the file), `lineCounts`,
  `formationForCounts`, the private `_layouts` table, `_keeperLine`.
- Produces:
  - `double adjustedSlotY(double baseY, PositionCategory category, TacticalInstructions i)`
    — top-level, the y half of what `TacticsPitch._adjusted` does today
  - `PositionCategory? bandAt(Formation f, TacticalInstructions i, double dropY)`
    — which line a drop lands in, null never returned (nearest always wins)
  - `DragOutcome? resolveSpaceDrag(Formation formation, TacticalInstructions instructions, int slot, double dropY)`
    — `null` means bounce

- [ ] **Step 1: Write the failing test**

Create `test/unit/tactics/space_drag_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart';

void main() {
  const flat = TacticalInstructions();

  /// The y a band sits at for [f], so a test can aim at a line without
  /// hardcoding a coordinate that the layout table owns.
  double bandY(Formation f, PositionCategory c) {
    final ys = <double>[];
    final positions = f.positions;
    for (var slot = 0; slot < positions.length; slot++) {
      if (positions[slot].category != c) continue;
      ys.add(adjustedSlotY(layoutOf(f)[slot].$2, c, flat));
    }
    return ys.reduce((a, b) => a + b) / ys.length;
  }

  int slotOf(Formation f, PositionCategory c) =>
      f.positions.indexWhere((p) => p.category == c);

  group('resolveSpaceDrag', () {
    test('a midfielder dropped among the forwards makes 4-4-2 into 4-3-3', () {
      final out = resolveSpaceDrag(
        Formation.f442,
        flat,
        slotOf(Formation.f442, PositionCategory.midfielder),
        bandY(Formation.f442, PositionCategory.forward),
      );
      expect(out, isA<ReshapeTo>());
      expect((out! as ReshapeTo).formation, Formation.f433);
    });

    test('a forward dropped among the defenders makes 4-3-3 into 5-3-2', () {
      final out = resolveSpaceDrag(
        Formation.f433,
        flat,
        slotOf(Formation.f433, PositionCategory.forward),
        bandY(Formation.f433, PositionCategory.defender),
      );
      expect(out, isA<ReshapeTo>());
      expect((out! as ReshapeTo).formation, Formation.f532);
    });

    test('a drop in the player\'s own band does nothing', () {
      expect(
        resolveSpaceDrag(
          Formation.f442,
          flat,
          slotOf(Formation.f442, PositionCategory.midfielder),
          bandY(Formation.f442, PositionCategory.midfielder),
        ),
        isNull,
      );
    });

    test('the keeper cannot be dragged out of goal', () {
      for (final band in [
        PositionCategory.defender,
        PositionCategory.midfielder,
        PositionCategory.forward,
      ]) {
        expect(
          resolveSpaceDrag(
            Formation.f442,
            flat,
            slotOf(Formation.f442, PositionCategory.goalkeeper),
            bandY(Formation.f442, band),
          ),
          isNull,
          reason: 'the keeper reached the $band band',
        );
      }
    });

    test('nobody can be dropped into the keeper\'s band', () {
      expect(
        resolveSpaceDrag(
          Formation.f442,
          flat,
          slotOf(Formation.f442, PositionCategory.forward),
          0.99, // below the goal line
        ),
        isNull,
      );
    });

    test('an extreme defensive line does not move the bands out from under '
        'the drop', () {
      // The bands are read off the RENDERED layout, so a drop aimed at where
      // the defenders actually are must resolve the same whatever the
      // instructions have done to them.
      const high = TacticalInstructions(defensiveLine: 100);
      final out = resolveSpaceDrag(
        Formation.f433,
        high,
        slotOf(Formation.f433, PositionCategory.forward),
        bandYWith(Formation.f433, PositionCategory.defender, high),
      );
      expect(out, isA<ReshapeTo>());
      expect((out! as ReshapeTo).formation, Formation.f532);
    });

    test('every outcome is a real formation, from every band of every shape',
        () {
      // The constraint the whole feature rests on: a drag can never invent a
      // shape the game does not have.
      for (final f in Formation.values) {
        for (var slot = 0; slot < f.positions.length; slot++) {
          for (final band in PositionCategory.values) {
            final out = resolveSpaceDrag(f, flat, slot, bandY(f, band));
            if (out is ReshapeTo) {
              expect(Formation.values, contains(out.formation));
            }
          }
        }
      }
    });
  });

  /// [bandY] with explicit instructions.
  double bandYWith(
    Formation f,
    PositionCategory c,
    TacticalInstructions i,
  ) {
    final ys = <double>[];
    final positions = f.positions;
    for (var slot = 0; slot < positions.length; slot++) {
      if (positions[slot].category != c) continue;
      ys.add(adjustedSlotY(layoutOf(f)[slot].$2, c, i));
    }
    return ys.reduce((a, b) => a + b) / ys.length;
  }
}
```

Note: `bandY` for `PositionCategory.goalkeeper` returns the keeper line, which
the "every outcome" test aims at deliberately — it must produce `null`, not a
formation.

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/unit/tactics/space_drag_test.dart`
Expected: FAIL — `adjustedSlotY`, `layoutOf` and `resolveSpaceDrag` do not
exist.

- [ ] **Step 3: Extract the y maths and expose the layout**

In `lib/features/tactics/tactics_pitch.dart`, add these top-level functions
above `resolveDrag`, and change `TacticsPitch._adjusted` to call
`adjustedSlotY` for its y rather than computing it inline (its x/width maths and
its final clamping stay exactly where they are):

```dart
/// A formation's base slot coordinates, before the instructions move anybody.
List<(double, double)> layoutOf(Formation f) => _layouts[f]!;

/// Where a slot actually sits up the pitch once the instructions have had
/// their say — the y half of what the pitch renders.
///
/// Shared with [resolveSpaceDrag] rather than duplicated: a drop is judged
/// against the line the manager can SEE, and a second copy of this arithmetic
/// would drift from the first exactly when a tactic is extreme.
double adjustedSlotY(
  double baseY,
  PositionCategory category,
  TacticalInstructions i,
) {
  if (category == PositionCategory.goalkeeper) return _keeperLine;
  var y = baseY - (i.mentality - 50) / 50 * 0.05;
  if (category == PositionCategory.defender) {
    y -= (i.defensiveLine - 50) / 50 * 0.10;
  } else if (category == PositionCategory.forward) {
    y -= (i.mentality - 50) / 50 * 0.02;
  }
  return y;
}
```

- [ ] **Step 4: Write the resolver**

Add below `resolveDrag`:

```dart
/// Which line a drop at [dropY] lands in: the nearest of the formation's own
/// rendered line bands.
PositionCategory bandAt(
  Formation f,
  TacticalInstructions i,
  double dropY,
) {
  final sums = <PositionCategory, double>{};
  final counts = <PositionCategory, int>{};
  final positions = f.positions;
  for (var slot = 0; slot < positions.length; slot++) {
    final c = positions[slot].category;
    sums[c] = (sums[c] ?? 0) + adjustedSlotY(layoutOf(f)[slot].$2, c, i);
    counts[c] = (counts[c] ?? 0) + 1;
  }
  var best = PositionCategory.midfielder;
  var bestGap = double.infinity;
  for (final c in sums.keys) {
    final gap = (sums[c]! / counts[c]! - dropY).abs();
    if (gap < bestGap) {
      bestGap = gap;
      best = c;
    }
  }
  return best;
}

/// Resolves a drag from [slot] released in open space at [dropY].
///
/// Null means bounce: the drop asked for something the game has no shape for,
/// or for nothing at all. Aiming at a team-mate instead is [resolveDrag]; this
/// is the "push him up into the attack" gesture, which is how a manager thinks
/// about it rather than "swap him with the left winger".
DragOutcome? resolveSpaceDrag(
  Formation formation,
  TacticalInstructions instructions,
  int slot,
  double dropY,
) {
  final from = formation.positions[slot].category;
  // A formation has exactly one keeper: he cannot leave, and nobody may join
  // him.
  if (from == PositionCategory.goalkeeper) return null;
  final to = bandAt(formation, instructions, dropY);
  if (to == PositionCategory.goalkeeper) return null;
  if (to == from) return null; // already there

  final counts = lineCounts(formation);
  final want = (
    _shift(counts.$1, PositionCategory.defender, from, to),
    _shift(counts.$2, PositionCategory.midfielder, from, to),
    _shift(counts.$3, PositionCategory.forward, from, to),
  );
  final exact = formationForCounts(want.$1, want.$2, want.$3);
  if (exact != null && exact != formation) return ReshapeTo(exact);

  // No shape has those counts. Snap to the nearest one that still moves the
  // player the way the drag asked — a near-miss should do something
  // recognisable, but never something the game cannot draw.
  Formation? best;
  var bestScore = 1 << 30;
  for (final f in Formation.values) {
    if (f == formation) continue;
    final c = lineCounts(f);
    if (_inLine(c, to) <= _inLine(counts, to)) continue; // must move him there
    final score = (c.$1 - want.$1).abs() +
        (c.$2 - want.$2).abs() +
        (c.$3 - want.$3).abs();
    if (score < bestScore ||
        (score == bestScore &&
            best != null &&
            _inLine(c, to) > _inLine(lineCounts(best), to))) {
      bestScore = score;
      best = f;
    }
  }
  return best == null ? null : ReshapeTo(best);
}

int _inLine((int, int, int) counts, PositionCategory line) => switch (line) {
      PositionCategory.defender => counts.$1,
      PositionCategory.midfielder => counts.$2,
      PositionCategory.forward => counts.$3,
      PositionCategory.goalkeeper => 0,
    };

int _shift(
  int count,
  PositionCategory line,
  PositionCategory from,
  PositionCategory to,
) {
  var n = count;
  if (from == line) n--;
  if (to == line) n++;
  return n;
}
```

- [ ] **Step 5: Run tests to verify they pass**

Run: `flutter test test/unit/tactics/space_drag_test.dart`
Expected: PASS, 7 tests.

Run: `flutter test test/widget/tactics_pitch_test.dart`
Expected: PASS — extracting the y maths must not have moved anybody on screen.

- [ ] **Step 6: Commit**

```bash
git add lib/features/tactics/tactics_pitch.dart \
        test/unit/tactics/space_drag_test.dart
git commit -m "feat: resolve a player dropped into open pitch space"
```

---

### Task 2: Wiring it to the pitch and both screens

**Files:**
- Modify: `lib/features/tactics/tactics_pitch.dart` (the `TacticsPitch` widget)
- Modify: `lib/features/tactics/tactics_screen.dart` (the `TacticsPitch(...)` call, around line 215)
- Modify: `lib/features/tactics/in_match_tactics.dart` (its `TacticsPitch(...)` call)
- Test: `test/widget/tactics_pitch_test.dart` (append)

**Interfaces:**
- Consumes: `resolveSpaceDrag` (Task 1).
- Produces: `TacticsPitch({..., void Function(int slot, double dropY)? onMoveToSpace})`.

- [ ] **Step 1: Write the failing test**

Append inside `main()` in `test/widget/tactics_pitch_test.dart`, following the
pump/drag helpers already in that file:

```dart
  testWidgets('dropping a player in open space reports the drop', (
    tester,
  ) async {
    int? movedSlot;
    double? movedY;
    await tester.pumpWidget(
      harness(
        onSwap: (_, __) {},
        onMoveToSpace: (slot, dropY) {
          movedSlot = slot;
          movedY = dropY;
        },
      ),
    );

    // Pick up a midfielder and release him high up the pitch, away from any
    // team-mate's disc.
    final disc = find.byType(TacticsPitch);
    final box = tester.getRect(disc);
    final gesture = await tester.startGesture(
      tester.getCenter(find.text('MID').first),
    );
    await tester.pump(kDragHoldDelay + const Duration(milliseconds: 20));
    await gesture.moveTo(Offset(box.center.dx, box.top + box.height * 0.12));
    await gesture.up();
    await tester.pumpAndSettle();

    expect(movedSlot, isNotNull);
    expect(movedY, isNotNull);
    expect(movedY, lessThan(0.3), reason: 'dropped high up the pitch');
  });
```

The file's existing `harness({required onSwap, onBenchIn})` helper
(`tactics_pitch_test.dart:28`) builds the pitch inside a `ListView`; add an
optional `onMoveToSpace` parameter to it and pass it through. Call
`sizeSurface(tester)` first, as the neighbouring drag tests do, or slots fall
off the surface and are not hit-testable.

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/widget/tactics_pitch_test.dart`
Expected: FAIL — `TacticsPitch` has no `onMoveToSpace` parameter.

- [ ] **Step 3: Add the drop target**

In `TacticsPitch`, add the field and constructor parameter:

```dart
  /// A player released in open space, with where he landed as a fraction of
  /// the pitch's height. Null disables the gesture.
  final void Function(int slot, double dropY)? onMoveToSpace;
```

Inside `build`, wrap the existing `Stack` children so a full-pitch
`DragTarget` sits FIRST — behind every player node, so a drop on a team-mate
still reaches that player's own target and today's behaviour is untouched:

```dart
            return Stack(
              children: [
                if (onMoveToSpace case final onSpace?)
                  Positioned.fill(
                    child: DragTarget<Object>(
                      onWillAcceptWithDetails: (d) => d.data is _SlotDrag,
                      onAcceptWithDetails: (d) {
                        final box = context.findRenderObject() as RenderBox?;
                        if (box == null || box.size.height <= 0) return;
                        final local = box.globalToLocal(d.offset);
                        onSpace(
                          (d.data as _SlotDrag).slot,
                          (local.dy / box.size.height).clamp(0.0, 1.0),
                        );
                      },
                    ),
                  ),
                // ... the existing `for (var slot = 0; slot < 11; slot++)` block,
                // unchanged ...
              ],
            );
```

`_SlotDrag` is the file's existing payload (`tactics_pitch.dart:240`), carrying
the source slot; a substitute being dragged carries `_BenchDrag` instead, so the
`d.data is _SlotDrag` guard is what makes a bench player dropped into space do
nothing, as the design requires. Do not introduce a second payload type.

- [ ] **Step 4: Wire both screens**

In `lib/features/tactics/tactics_screen.dart`, on the `TacticsPitch(...)` call
beside the existing `onSwap`:

```dart
                        onMoveToSpace: (slot, dropY) {
                          final outcome = resolveSpaceDrag(
                            tactic.formation,
                            tactic.instructions,
                            slot,
                            dropY,
                          );
                          if (outcome case ReshapeTo(:final formation)) {
                            unawaited(
                              service.reshapeFormation(careerId, formation),
                            );
                          }
                        },
```

In `lib/features/tactics/in_match_tactics.dart`, on its `TacticsPitch(...)`
call, routing through the editor's own reshape so the XI is refitted rather
than reset:

```dart
        onMoveToSpace: (slot, dropY) {
          final outcome = resolveSpaceDrag(
            _formation,
            _instructions,
            slot,
            dropY,
          );
          if (outcome case ReshapeTo(:final formation)) {
            _setFormation(formation);
          }
        },
```

- [ ] **Step 5: Verify**

Run: `flutter test test/widget/tactics_pitch_test.dart` — expect PASS,
including every pre-existing drag test: dropping ON a player must still swap and
still reshape.

Run: `flutter analyze lib test 2>&1 | grep -E "error •|warning •" | grep -v generated_migrations`
Expected: no output.

Run: `flutter test test/unit test/widget`
Expected: `All tests passed!`

- [ ] **Step 6: Commit**

```bash
git add lib/features/tactics/tactics_pitch.dart \
        lib/features/tactics/tactics_screen.dart \
        lib/features/tactics/in_match_tactics.dart \
        test/widget/tactics_pitch_test.dart
git commit -m "feat: drop a player into space to reshape the side"
```

---

## Notes for the implementer

- **The drop target goes behind the players, not in front.** In front, it would
  swallow every drop and the existing swap/reshape gesture would die. The
  pre-existing drag tests in `tactics_pitch_test.dart` are what prove you got
  this the right way round — if they fail, that is why.
- **Do not relax the formation constraint to make a drop "work".** If a shape
  does not exist, bouncing is the designed answer. The "every outcome is a real
  formation" test exists to stop exactly that shortcut.
- **The in-match editor already refits the XI on a formation change**
  (`_setFormation` keeps the players who are on the pitch). Route through it
  rather than assigning `_formation` directly, or a reshape mid-match will
  scramble the side.
