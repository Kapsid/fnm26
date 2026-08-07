# Dropping a player into space

**Date:** 2026-08-07
**Status:** approved design

## Problem

The tactics pitch already reshapes: hold a player, drag him onto a team-mate in
another line, and the formation becomes the one implied by the swap
(`resolveDrag` in `lib/features/tactics/tactics_pitch.dart`). Only the 17
defined formations are reachable, so the shape is always a real one.

But you have to aim at a specific team-mate. A manager thinks "push him up into
the attack", not "swap him with the left winger", and there is no way to express
the first. Dropping into open space does nothing at all.

## Decisions

- Dropping ON a player keeps today's behaviour exactly — swap within a line,
  reshape across lines. This design only adds a path for drops that land in
  space.
- Only real formations are reachable. That constraint is not relaxed anywhere.
- A drop that cannot produce a sensible shape **bounces**: nothing changes.
  Silently doing nothing on a near-miss is worse than snapping, but inventing a
  shape the game does not have is worse than both.

## Behaviour

**Reading the drop.** The drop's y-fraction is compared against the current
formation's own line bands — the mean y of its defenders, of its midfielders and
of its forwards, taken from the same layout table the pitch draws from. Nearest
band wins.

The bands are derived from the live layout rather than hardcoded thirds because
the instructions already move players vertically: a high defensive line lifts
the back four up the pitch, and fixed thresholds would then disagree with what
the manager can see. The comparison must use the same adjusted coordinates the
pitch renders, or the feature will feel wrong exactly when the tactic is
extreme.

**Choosing the shape.** Take the formation's line counts, subtract one from the
dragged player's line, add one to the target line, and ask `formationForCounts`
for a formation with those counts. If one exists and differs from the current
formation, reshape to it.

**When no formation matches.** Drag a defender forward out of 4-3-3 and 3-3-4
does not exist. Rather than doing nothing, snap to the closest formation by
line-count distance (the sum of the absolute differences across the three
lines), among those that still move the dragged player toward the target line —
so the drag always does something recognisably like what was asked, or nothing
at all. Ties break toward the formation with more players in the target line. If
no candidate qualifies, the drag bounces.

**Exclusions.**

- The goalkeeper cannot be dragged out of goal, and no outfield player can be
  dropped into the keeper's band. A formation always has exactly one keeper.
- A drop landing in the dragged player's own band is a no-op — he is already
  there, and rearranging within a line is what dropping on a team-mate is for.
- A substitute dragged into empty space does nothing. Which player he replaces
  is the whole question, so he must be dropped onto one, as now.

## Code shape

One pure function beside the existing `resolveDrag`, in
`lib/features/tactics/tactics_pitch.dart`:

```dart
DragOutcome? resolveSpaceDrag(
  Formation formation,
  TacticalInstructions instructions,
  int slot,
  double dropY,
)
```

Returning `null` for "bounce, nothing happens", and otherwise the existing
`ReshapeTo`. It takes the instructions because the bands are read from the
adjusted layout, which the instructions shift.

`TacticsPitch` gains a `DragTarget` behind the player `Stack` — behind, so a
drop on a player still reaches that player's own target and today's path is
untouched — and a new callback:

```dart
final void Function(int slot, double dropY)? onMoveToSpace;
```

wired from `TacticsScreen` and the in-match editor the same way `onSwap`
already is. Both screens route it through the reshape they already perform.

Nothing is persisted that is not persisted today; a reshape saves the formation
exactly as the existing cross-line drag does.

## Testing

Against `resolveSpaceDrag`, with no widget pumping:

- a midfielder dropped in the forward band of 4-4-2 gives 4-3-3
- a forward dropped in the defensive band of 4-3-3 gives 5-3-2
- the same drop under an extreme defensive-line instruction still resolves to
  the same band, proving the bands track the rendered layout
- a drop in the dragged player's own band returns null
- a drop in the keeper's band returns null, and the keeper himself never
  produces an outcome from any drop
- a drag with no exact match snaps to the nearest formation that still moves the
  player toward the target line
- every outcome, across every formation and every band, is one of
  `Formation.values` — the guard that the 17-shape constraint cannot be escaped

## Out of scope

Horizontal repositioning within a line (dragging a left-back to the right),
free-form player coordinates, a live preview of the resulting shape while
dragging, and any change to what dropping on a player does.
