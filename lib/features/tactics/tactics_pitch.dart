import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/tactics/position_fit.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// Normalised pitch coordinates per formation (x: 0=left…1=right,
/// y: 0=attack…1=own goal), in the same slot order as `Formation.positions`.
const _layouts = <Formation, List<(double, double)>>{
  Formation.f442: [
    (0.5, 0.90),
    (0.12, 0.70),
    (0.37, 0.73),
    (0.63, 0.73),
    (0.88, 0.70),
    (0.12, 0.45),
    (0.38, 0.48),
    (0.62, 0.48),
    (0.88, 0.45),
    (0.38, 0.16),
    (0.62, 0.16),
  ],
  Formation.f433: [
    (0.5, 0.90),
    (0.12, 0.70),
    (0.37, 0.73),
    (0.63, 0.73),
    (0.88, 0.70),
    (0.5, 0.55),
    (0.30, 0.42),
    (0.70, 0.42),
    (0.16, 0.18),
    (0.5, 0.13),
    (0.84, 0.18),
  ],
  Formation.f352: [
    (0.5, 0.90),
    (0.28, 0.73),
    (0.5, 0.76),
    (0.72, 0.73),
    (0.10, 0.45),
    (0.32, 0.50),
    (0.5, 0.52),
    (0.68, 0.50),
    (0.90, 0.45),
    (0.38, 0.16),
    (0.62, 0.16),
  ],
  Formation.f4231: [
    (0.5, 0.90),
    (0.12, 0.70),
    (0.37, 0.73),
    (0.63, 0.73),
    (0.88, 0.70),
    (0.38, 0.56),
    (0.62, 0.56),
    (0.5, 0.38),
    (0.16, 0.22),
    (0.84, 0.22),
    (0.5, 0.14),
  ],
  Formation.f532: [
    (0.5, 0.90),
    (0.08, 0.62),
    (0.30, 0.74),
    (0.5, 0.76),
    (0.70, 0.74),
    (0.92, 0.62),
    (0.30, 0.45),
    (0.5, 0.48),
    (0.70, 0.45),
    (0.38, 0.16),
    (0.62, 0.16),
  ],
  Formation.f4141: [
    (0.5, 0.90),
    (0.12, 0.70),
    (0.37, 0.73),
    (0.63, 0.73),
    (0.88, 0.70),
    (0.5, 0.56),
    (0.14, 0.38),
    (0.38, 0.40),
    (0.62, 0.40),
    (0.86, 0.38),
    (0.5, 0.15),
  ],
  Formation.f343: [
    (0.5, 0.90),
    (0.28, 0.74),
    (0.5, 0.76),
    (0.72, 0.74),
    (0.10, 0.48),
    (0.38, 0.50),
    (0.62, 0.50),
    (0.90, 0.48),
    (0.18, 0.18),
    (0.5, 0.14),
    (0.82, 0.18),
  ],
  Formation.f4222: [
    (0.5, 0.90),
    (0.12, 0.70),
    (0.37, 0.73),
    (0.63, 0.73),
    (0.88, 0.70),
    (0.35, 0.52),
    (0.65, 0.52),
    (0.22, 0.34),
    (0.78, 0.34),
    (0.38, 0.15),
    (0.62, 0.15),
  ],
  Formation.f424: [
    (0.5, 0.90),
    (0.12, 0.70),
    (0.37, 0.73),
    (0.63, 0.73),
    (0.88, 0.70),
    (0.35, 0.50),
    (0.65, 0.50),
    (0.14, 0.20),
    (0.38, 0.15),
    (0.62, 0.15),
    (0.86, 0.20),
  ],
  Formation.f41212: [
    (0.5, 0.90),
    (0.12, 0.70),
    (0.37, 0.73),
    (0.63, 0.73),
    (0.88, 0.70),
    (0.5, 0.58),
    (0.28, 0.45),
    (0.72, 0.45),
    (0.5, 0.31),
    (0.38, 0.15),
    (0.62, 0.15),
  ],
  Formation.f4411: [
    (0.5, 0.90),
    (0.12, 0.70),
    (0.37, 0.73),
    (0.63, 0.73),
    (0.88, 0.70),
    (0.12, 0.48),
    (0.38, 0.50),
    (0.62, 0.50),
    (0.88, 0.48),
    (0.5, 0.30),
    (0.5, 0.14),
  ],
  Formation.f4312: [
    (0.5, 0.90),
    (0.12, 0.70),
    (0.37, 0.73),
    (0.63, 0.73),
    (0.88, 0.70),
    (0.28, 0.50),
    (0.5, 0.53),
    (0.72, 0.50),
    (0.5, 0.32),
    (0.38, 0.15),
    (0.62, 0.15),
  ],
  Formation.f451: [
    (0.5, 0.90),
    (0.12, 0.70),
    (0.37, 0.73),
    (0.63, 0.73),
    (0.88, 0.70),
    (0.10, 0.45),
    (0.32, 0.48),
    (0.5, 0.50),
    (0.68, 0.48),
    (0.90, 0.45),
    (0.5, 0.15),
  ],
  Formation.f541: [
    (0.5, 0.90),
    (0.08, 0.62),
    (0.30, 0.74),
    (0.5, 0.76),
    (0.70, 0.74),
    (0.92, 0.62),
    (0.14, 0.45),
    (0.38, 0.48),
    (0.62, 0.48),
    (0.86, 0.45),
    (0.5, 0.15),
  ],
  Formation.f3421: [
    (0.5, 0.90),
    (0.28, 0.74),
    (0.5, 0.76),
    (0.72, 0.74),
    (0.10, 0.50),
    (0.38, 0.52),
    (0.62, 0.52),
    (0.90, 0.50),
    (0.32, 0.30),
    (0.68, 0.30),
    (0.5, 0.14),
  ],
  Formation.f3412: [
    (0.5, 0.90),
    (0.28, 0.74),
    (0.5, 0.76),
    (0.72, 0.74),
    (0.10, 0.50),
    (0.38, 0.52),
    (0.62, 0.52),
    (0.90, 0.50),
    (0.5, 0.32),
    (0.38, 0.15),
    (0.62, 0.15),
  ],
  Formation.f5212: [
    (0.5, 0.90),
    (0.08, 0.62),
    (0.30, 0.74),
    (0.5, 0.76),
    (0.70, 0.74),
    (0.92, 0.62),
    (0.35, 0.50),
    (0.65, 0.50),
    (0.5, 0.32),
    (0.38, 0.15),
    (0.62, 0.15),
  ],
};

/// Dragging an occupied XI slot off the pitch (to swap with another slot).
class _SlotDrag {
  const _SlotDrag(this.slot);
  final int slot;
}

/// Dragging a substitute onto the pitch (to bring them into the XI).
class _BenchDrag {
  const _BenchDrag(this.playerId);
  final int playerId;
}

/// "Cristiano Ronaldo" → "C. Ronaldo" (surnames can repeat in a squad).
String shortName(String full) {
  final parts = full.trim().split(' ');
  if (parts.length < 2) return full;
  return '${parts.first[0]}. ${parts.last}';
}

/// The outcome of dragging one pitch slot onto another.
sealed class DragOutcome {
  const DragOutcome();
}

/// A straight swap of the two slots' players.
class SwapSlots extends DragOutcome {
  const SwapSlots(this.a, this.b);
  final int a;
  final int b;
}

/// A reshape to [formation] (moving a player across lines), same players.
class ReshapeTo extends DragOutcome {
  const ReshapeTo(this.formation);
  final Formation formation;
}

/// Where the keeper is pinned, as a fraction down the pitch. He never shifts
/// up it, so a deep defensive line cannot drop the back line on top of him.
const double _keeperLine = 0.94;

/// A formation's base slot coordinates, before the instructions move anybody.
List<(double, double)> layoutOf(Formation f) => _layouts[f]!;

/// Where a slot actually sits up the pitch once the instructions have had their
/// say — the y half of what the pitch renders.
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

/// Resolves a pitch drag from slot [a] onto slot [b]: within the same line it
/// is a straight swap; across lines it reshapes to the formation implied by
/// moving the dragged player to the target's line, falling back to a swap when
/// no such formation exists.
DragOutcome resolveDrag(Formation formation, int a, int b) {
  final positions = formation.positions;
  final catA = positions[a].category;
  final catB = positions[b].category;
  if (catA == catB) return SwapSlots(a, b);
  final counts = lineCounts(formation);
  final next = formationForCounts(
    _adjust(counts.$1, PositionCategory.defender, catA, catB),
    _adjust(counts.$2, PositionCategory.midfielder, catA, catB),
    _adjust(counts.$3, PositionCategory.forward, catA, catB),
  );
  if (next != null && next != formation) return ReshapeTo(next);
  return SwapSlots(a, b);
}

/// Which line a drop at [dropY] lands in: the nearest of the formation's own
/// rendered line bands.
PositionCategory bandAt(Formation f, TacticalInstructions i, double dropY) {
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

/// Resolves a drag from [slot] released in OPEN SPACE at [dropY].
///
/// Null means bounce: the drop asked for a shape the game does not have, or
/// for nothing at all. Aiming at a team-mate instead is [resolveDrag]; this is
/// the "push him up into the attack" gesture, which is how a manager thinks
/// about it rather than "swap him with the left winger".
DragOutcome? resolveSpaceDrag(
  Formation formation,
  TacticalInstructions instructions,
  int slot,
  double dropY,
) {
  final from = formation.positions[slot].category;
  // A side has exactly one keeper: he cannot leave, and nobody may join him.
  if (from == PositionCategory.goalkeeper) return null;
  final to = bandAt(formation, instructions, dropY);
  if (to == PositionCategory.goalkeeper) return null;
  if (to == from) return null; // already there

  final counts = lineCounts(formation);
  final wantD = _adjust(counts.$1, PositionCategory.defender, from, to);
  final wantM = _adjust(counts.$2, PositionCategory.midfielder, from, to);
  final wantF = _adjust(counts.$3, PositionCategory.forward, from, to);
  final exact = formationForCounts(wantD, wantM, wantF);
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
    final score = (c.$1 - wantD).abs() +
        (c.$2 - wantM).abs() +
        (c.$3 - wantF).abs();
    final better = score < bestScore ||
        (score == bestScore &&
            best != null &&
            _inLine(c, to) > _inLine(lineCounts(best), to));
    if (better) {
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

int _adjust(
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

/// The (defenders, midfielders, forwards) count of a formation's outfield.
(int, int, int) lineCounts(Formation f) {
  var d = 0;
  var m = 0;
  var w = 0;
  for (final p in f.positions) {
    switch (p.category) {
      case PositionCategory.defender:
        d++;
      case PositionCategory.midfielder:
        m++;
      case PositionCategory.forward:
        w++;
      case PositionCategory.goalkeeper:
        break;
    }
  }
  return (d, m, w);
}

/// The formation matching a given line distribution, or null if none exists.
Formation? formationForCounts(int d, int m, int w) {
  for (final f in Formation.values) {
    final c = lineCounts(f);
    if (c.$1 == d && c.$2 == m && c.$3 == w) return f;
  }
  return null;
}

/// A tactical pitch: the starting XI laid out in the formation's shape, nudged
/// by the instructions. Players can be tapped to pick, dragged to swap
/// positions, or have a substitute dragged onto them. Purely presentational —
/// all edits are reported through the callbacks.
class TacticsPitch extends StatelessWidget {
  const TacticsPitch({
    required this.formation,
    required this.instructions,
    required this.lineup,
    required this.byId,
    required this.onTapSlot,
    required this.onSwap,
    required this.onBenchIn,
    this.onMoveToSpace,
    this.absentIds = const {},
    this.injuredIds = const {},
    this.energyByPlayer = const {},
    this.teamColors,
    super.key,
  });

  final Formation formation;
  final TacticalInstructions instructions;
  final List<int?> lineup;
  final Map<int, Player> byId;

  /// The nation's kit colours (one or two stops, already made UI-legible by
  /// [KitColors.discFill]), filling each player disc so the pitch actually
  /// looks like YOUR team. Null falls back to the neutral surface fill.
  ///
  /// It used to be a single optional colour that no caller ever passed, so
  /// every nation's discs came out the same grey.
  final List<Color>? teamColors;

  /// Live remaining energy (0–100) per player id, shown on each node during a
  /// match so the manager can see who's tiring. Empty (the default) hides it —
  /// e.g. on the pre-match tactics screen where everyone is fresh.
  final Map<int, int> energyByPlayer;

  /// Players who cannot play the next match (banned or injured): their node is
  /// flagged OUT so the manager can see exactly who must be replaced.
  final Set<int> absentIds;

  /// The subset of [absentIds] who are INJURED (shown orange); the rest are
  /// suspended (shown red).
  final Set<int> injuredIds;
  final ValueChanged<int> onTapSlot;
  final void Function(int slotA, int slotB) onSwap;
  final void Function(int slot, int playerId) onBenchIn;

  /// A player released in OPEN SPACE, with where he landed as a fraction of
  /// the pitch's height. Null disables the gesture; dropping onto a team-mate
  /// still goes through [onSwap] either way.
  final void Function(int slot, double dropY)? onMoveToSpace;

  /// The deepest an outfield node may sit. The keeper is pinned below it, and
  /// a node is a good deal taller than its disc (position chip, name, and — in
  /// a match — an energy gauge), so the gap has to hold a whole node's worth of
  /// label. It used to be 0.77 against a keeper on 0.94, which was not enough
  /// once the energy readout was added: in a three-at-the-back shape the middle
  /// centre-half sits directly above the keeper (both on x = 0.5) and the two
  /// ran into each other.
  static const double _outfieldFloor = 0.68;
  static const double _outfieldCeiling = 0.10;

  /// Where the keeper stands. Below every outfield player, on the goal line.

  /// Nudges a slot's base coordinate by the instructions so the shape reads the
  /// tactics: wider/narrower spread, a higher/deeper back line, and a more
  /// advanced team when attacking.
  (double, double) _adjusted(
    (double, double) base,
    PositionCategory category,
  ) {
    final i = instructions;
    // Width: spread outfield players out from / in toward the centre line. The
    // span is deliberately modest so a wide 3-back shape (e.g. 3-4-3) can't push
    // the widest players' name labels off the painted pitch.
    final widthFactor = 0.82 + i.width / 100 * 0.24; // 0.82 … 1.06
    final x = 0.5 + (base.$1 - 0.5) * widthFactor;
    // The keeper is pinned on the goal line and never shifts up the pitch, so
    // a deep defensive line can't drop the back line on top of them.
    if (category == PositionCategory.goalkeeper) {
      return (x.clamp(0.12, 0.88), _keeperLine);
    }
    // Attacking mentality lifts the whole outfield up the pitch, a high
    // defensive line pushes the back line up — see [adjustedSlotY], which the
    // drop resolver reads too so the two can never disagree.
    final y = adjustedSlotY(base.$2, category, i);
    // Compress the outfield into its band rather than clamping to the floor:
    // clamping flattened a staggered back line (centre-halves deeper than the
    // full-backs) into one straight row as soon as the deepest player hit the
    // cap. Squeezing keeps the shape and just fits it above the keeper.
    const from = 0.78;
    final squeezed = _outfieldCeiling +
        (y.clamp(_outfieldCeiling, from) - _outfieldCeiling) *
            ((_outfieldFloor - _outfieldCeiling) / (from - _outfieldCeiling));
    // Cap the width so the widest players' labels stay on the pitch.
    return (x.clamp(0.12, 0.88), squeezed);
  }

  /// How tall a node is, so the layout can keep whole nodes inside the pitch.
  /// The disc, the position chip and the name are always there; the energy
  /// gauge only during a match.
  double get _nodeHeight => 79 + (energyByPlayer.isEmpty ? 0 : 12);

  @override
  Widget build(BuildContext context) {
    final layout = _layouts[formation]!;
    final positions = formation.positions;

    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          colors: [
            AppColors.surfaceContainer,
            AppColors.surfaceContainerLowest,
          ],
          radius: 0.9,
        ),
      ),
      child: CustomPaint(
        painter: _PitchPainter(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // A node is anchored by the CENTRE of its column, but the column is
            // mostly below the disc — so a coordinate near the goal line pushed
            // the keeper's name (and, in a match, his energy gauge) off the
            // bottom of the pitch. Inset the usable band by half a disc at the
            // top and the rest of a node at the bottom, in this pitch's own
            // units, so a whole node always fits whatever size it is drawn at.
            final height = constraints.maxHeight;
            final top = height <= 0 ? 0.0 : (_discSize / 2) / height;
            final bottom =
                height <= 0 ? 0.0 : (_nodeHeight - _discSize / 2) / height;
            final span = (1 - top - bottom).clamp(0.05, 1.0);
            double place(double y) => top + y * span;

            return Stack(
              children: [
                // BEHIND every player node: a drop that lands on a team-mate
                // must still reach his own target, so today's swap-and-reshape
                // gesture is untouched. This one only catches open space.
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
                      builder: (_, __, ___) => const SizedBox.expand(),
                    ),
                  ),
                for (var slot = 0; slot < 11; slot++)
                  () {
                    final pos = _adjusted(
                      layout[slot],
                      positions[slot].category,
                    );
                    return Align(
                      alignment: Alignment(
                        pos.$1 * 2 - 1,
                        place(pos.$2) * 2 - 1,
                      ),
                      child: _PlayerNode(
                        slot: slot,
                        position: positions[slot],
                        player: byId[lineup[slot]],
                        absent: absentIds.contains(lineup[slot]),
                        injured: injuredIds.contains(lineup[slot]),
                        energy: energyByPlayer[lineup[slot]],
                        teamColors: teamColors,
                        onTap: () => onTapSlot(slot),
                        onSwap: onSwap,
                        onBenchIn: onBenchIn,
                      ),
                    );
                  }(),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// The diameter of a player disc on the pitch.
const double _discSize = 46;

class _PlayerNode extends StatelessWidget {
  const _PlayerNode({
    required this.slot,
    required this.position,
    required this.player,
    required this.onTap,
    required this.onSwap,
    required this.onBenchIn,
    this.teamColors,
    this.absent = false,
    this.injured = false,
    this.energy,
  });

  final int slot;
  final PlayerPosition position;
  final Player? player;

  /// The nation's kit colours filling the disc for team identity.
  final List<Color>? teamColors;

  /// The player's live remaining energy (0–100) during a match, or null when
  /// energy isn't being tracked (pre-match) — shown as a small gauge on the node.
  final int? energy;

  /// Whether the assigned player is banned or injured for the next match.
  final bool absent;

  /// Whether the absence is an injury (orange) rather than a suspension (red).
  final bool injured;
  final VoidCallback onTap;
  final void Function(int slotA, int slotB) onSwap;
  final void Function(int slot, int playerId) onBenchIn;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return DragTarget<Object>(
      onWillAcceptWithDetails: (details) {
        final data = details.data;
        if (data is _SlotDrag) return data.slot != slot;
        return data is _BenchDrag;
      },
      onAcceptWithDetails: (details) {
        final data = details.data;
        if (data is _SlotDrag) {
          onSwap(data.slot, slot);
        } else if (data is _BenchDrag) {
          onBenchIn(slot, data.playerId);
        }
      },
      builder: (context, candidate, rejected) {
        final node = _node(l, highlighted: candidate.isNotEmpty);
        if (player == null) {
          return GestureDetector(onTap: onTap, child: node);
        }
        return GestureDetector(
          onTap: onTap,
          // Hold-then-drag: a plain Draggable loses the gesture arena to the
          // surrounding scroll view (the pitch lives inside a ListView), so
          // vertical drags never start. A brief hold disambiguates from a
          // scroll, matching the bench rows — see [kDragHoldDelay].
          child: LongPressDraggable<Object>(
            data: _SlotDrag(slot),
            delay: kDragHoldDelay,
            feedback: _node(l, dragging: true),
            childWhenDragging: Opacity(opacity: 0.35, child: node),
            child: node,
          ),
        );
      },
    );
  }

  /// How well the assigned player suits this slot, driving the colour cue:
  /// green = exact position, primary = right line/different role, amber = out
  /// of position (and taking a rating penalty in matches).
  ///
  /// Out of position is AMBER, not red. Red is the game's "you cannot play this
  /// man" colour — it marks a suspension — and using it for a fit as well made
  /// a striker filling in at full-back look like an illegal selection rather
  /// than a compromise the manager had chosen to make.
  Color get _fitColor {
    final p = player;
    if (p == null) return AppColors.outlineVariant;
    if (p.position == position) return AppColors.positive;
    if (p.category == position.category) return AppColors.primary;
    return AppColors.warning;
  }

  Widget _node(AppLocalizations l,
      {bool highlighted = false, bool dragging = false}) {
    final p = player;
    // An absent player overrides the fit cue entirely — nothing about the slot
    // matters until he is replaced. Injury shows orange, suspension red.
    final absentColor = injured ? AppColors.warning : AppColors.error;
    final fit = absent ? absentColor : _fitColor;
    final borderColor = highlighted ? AppColors.primary : fit;
    // The rating as it actually counts in this slot — docked when the player is
    // out of position, so the manager sees the real number before committing.
    final effective =
        p == null ? null : PositionFit.effectiveOverall(p, position);
    final penalised = p != null && effective! < p.overall;
    // Team identity: fill an occupied disc with the nation's kit colours (a
    // two-stop gradient for a two-colour kit, a shaded sweep of one otherwise).
    // Empty and absent slots keep the neutral surface fill so "add" and "OUT"
    // stay clear.
    final tc = teamColors;
    // A player out of position wears the AMBER bubble, not the kit: the whole
    // disc changes so the compromise is visible at a glance across the pitch,
    // and the number inside it is the rating he actually plays at in this slot.
    // It used to keep the kit fill, show his untouched overall, and spell the
    // drop out in small red type underneath — which read as a warning about a
    // number that was itself wrong, and made every node a line taller.
    final filled = tc != null && tc.isNotEmpty && p != null && !absent &&
        !penalised;
    final fillColors = penalised && !absent
        ? [
            Color.alphaBlend(
              AppColors.warning.withValues(alpha: 0.34),
              AppColors.surfaceContainerHighest,
            ),
            Color.alphaBlend(
              AppColors.warning.withValues(alpha: 0.16),
              AppColors.surfaceContainer,
            ),
          ]
        : filled
            ? (tc.length >= 2
                ? tc.take(2).toList()
                : [
                    tc.first,
                    Color.alphaBlend(
                      Colors.black.withValues(alpha: 0.28),
                      tc.first,
                    ),
                  ])
            : const [
                AppColors.surfaceContainerHighest,
                AppColors.surfaceContainer,
              ];
    // Legible number over the kit: dark text on a light shirt, else white.
    final onTeam = penalised
        ? AppColors.warning
        : filled
            ? (fillColors.first.computeLuminance() > 0.55
                ? Colors.black
                : Colors.white)
            : AppColors.primary;
    return Material(
      type: MaterialType.transparency,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: _discSize,
            height: _discSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: fillColors,
              ),
              border: Border.all(
                color: borderColor,
                width: highlighted || dragging ? 3 : 2,
              ),
            ),
            alignment: Alignment.center,
            child: absent
                ? Icon(
                    injured
                        ? Icons.personal_injury
                        : Icons.gavel_rounded,
                    size: 22,
                    color: absentColor,
                  )
                // The rating this player actually plays at IN THIS SLOT. In his
                // own position that is simply his overall; out of position it
                // is the docked figure, and the amber bubble around it says
                // why — so the number on the pitch is always the number the
                // match engine will use.
                : Text(
                    p == null ? '+' : '${effective!}',
                    style: AppTypography.labelMedium.copyWith(
                      color: onTeam,
                      fontWeight: penalised ? FontWeight.w800 : null,
                    ),
                  ),
          ),
          if (absent) ...[
            const SizedBox(height: 2),
            Text(
              injured ? l.tacticsInjuredReplace : l.tacticsSuspendedReplace,
              style: AppTypography.labelSmall.copyWith(
                fontSize: 7,
                color: absentColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          const SizedBox(height: 3),
          // The slot's exact position, always shown and tinted by fit.
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            decoration: BoxDecoration(
              color: fit.withValues(alpha: 0.18),
              borderRadius: AppRadii.smAll,
              border: Border.all(color: fit),
            ),
            child: Text(
              position.label,
              style: AppTypography.labelSmall.copyWith(
                fontSize: 9,
                color: fit,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (p != null) ...[
            const SizedBox(height: 1),
            // Fixed width + single line: a long name must never wrap onto a
            // second row, which would push the node past the pitch edge.
            SizedBox(
              width: 58,
              child: Text(
                shortName(p.name).toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppTypography.labelSmall.copyWith(fontSize: 8),
              ),
            ),
          ],
          if (p != null && energy != null) ...[
            const SizedBox(height: 1),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.bolt, size: 9, color: energyColor(energy!)),
                Text(
                  '$energy%',
                  style: AppTypography.labelSmall.copyWith(
                    fontSize: 8,
                    color: energyColor(energy!),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// The colour cue for a remaining-energy value: green when fresh, orange once
/// tiring (below 75%), red when spent (below 50%) — a shared scale so the pitch
/// node, the bench row and the in-match lineup pip all agree.
Color energyColor(int energy) => energy >= 75
    ? AppColors.positive
    : energy >= 50
        ? AppColors.warning
        : AppColors.error;

class _PitchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = AppColors.outlineVariant.withValues(alpha: 0.5);

    final inset = (Offset.zero & size).deflate(12);
    final boxW = size.width * 0.5;
    final boxH = size.height * 0.16;
    final left = (size.width - boxW) / 2;
    canvas
      ..drawRect(inset, paint)
      ..drawLine(
        Offset(inset.left, size.height / 2),
        Offset(inset.right, size.height / 2),
        paint,
      )
      ..drawCircle(Offset(size.width / 2, size.height / 2), 36, paint)
      ..drawRect(Rect.fromLTWH(left, inset.top, boxW, boxH), paint)
      ..drawRect(Rect.fromLTWH(left, inset.bottom - boxH, boxW, boxH), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// How long a press must be held before it becomes a drag rather than a scroll.
///
/// The default long-press (500ms) is long enough that a drag feels broken: the
/// press reads as a scroll, the page moves, and the player never lifts. This is
/// still comfortably above the tap and flick thresholds, so a tap still taps
/// and a flick still scrolls.
const kDragHoldDelay = Duration(milliseconds: 150);

/// A draggable substitute row: hold briefly, then drag onto a pitch player to
/// bring them on. The [trailing] slot lets callers annotate the row (e.g. a
/// rating).
class SubDragRow extends StatelessWidget {
  const SubDragRow({required this.player, this.trailing, super.key});

  final Player player;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final row = ListTile(
      dense: true,
      leading: SizedBox(width: 40, child: TacticalChip(player.position.label)),
      // Position is already shown by the leading chip — no role subtitle.
      title: Text(player.name, style: AppTypography.bodyMedium),
      trailing: trailing ??
          const Icon(
            Icons.drag_indicator,
            color: AppColors.onSurfaceVariant,
            size: 18,
          ),
    );

    Widget chip() => Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHighest,
              borderRadius: AppRadii.smAll,
              border: Border.all(color: AppColors.primary),
            ),
            child: Text(
              shortName(player.name).toUpperCase(),
              style: AppTypography.labelMedium,
            ),
          ),
        );

    return LongPressDraggable<Object>(
      data: _BenchDrag(player.id),
      delay: kDragHoldDelay,
      feedback: chip(),
      childWhenDragging: Opacity(opacity: 0.4, child: row),
      child: row,
    );
  }
}
