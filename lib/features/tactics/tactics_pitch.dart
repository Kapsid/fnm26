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
    (0.30, 0.50),
    (0.5, 0.52),
    (0.70, 0.50),
    (0.90, 0.45),
    (0.38, 0.16),
    (0.62, 0.16),
  ],
  // The back four sits deeper here than in the flat shapes: the two holding
  // midfielders are directly above the centre-halves on the same x, so with a
  // high defensive line pushing the defenders up they ended up almost on top
  // of each other. Everything else about the shape is unchanged.
  Formation.f4231: [
    (0.5, 0.90),
    (0.12, 0.76),
    (0.37, 0.79),
    (0.63, 0.79),
    (0.88, 0.76),
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
  // Like 4-2-3-1 and 4-1-2-1-2, the two holding midfielders sit close in front
  // of the centre-halves, so the back four is drawn deeper to leave a line's
  // worth of room between them.
  Formation.f4222: [
    (0.5, 0.90),
    (0.12, 0.75),
    (0.37, 0.78),
    (0.63, 0.78),
    (0.88, 0.75),
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
    (0.12, 0.76),
    (0.37, 0.79),
    (0.63, 0.79),
    (0.88, 0.76),
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
    (0.5, 0.31),
    (0.5, 0.12),
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
    (0.30, 0.48),
    (0.5, 0.50),
    (0.70, 0.48),
    (0.90, 0.45),
    (0.5, 0.15),
  ],
  Formation.f541: [
    (0.5, 0.90),
    (0.08, 0.70),
    (0.30, 0.74),
    (0.5, 0.76),
    (0.70, 0.74),
    (0.92, 0.70),
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
  Formation.f4321: [
    (0.5, 0.90),
    (0.12, 0.70),
    (0.37, 0.73),
    (0.63, 0.73),
    (0.88, 0.70),
    (0.28, 0.52),
    (0.5, 0.55),
    (0.72, 0.52),
    (0.36, 0.32),
    (0.64, 0.32),
    (0.5, 0.13),
  ],
  // The five across midfield sit on the same spacing as 3-5-2's, which is the
  // widest the discs go without crowding: the wing-backs at 0.10/0.90 and the
  // three inside at 0.30/0.50/0.70.
  Formation.f3511: [
    (0.5, 0.90),
    (0.28, 0.73),
    (0.5, 0.76),
    (0.72, 0.73),
    (0.10, 0.45),
    (0.30, 0.50),
    (0.5, 0.52),
    (0.70, 0.50),
    (0.90, 0.45),
    (0.5, 0.29),
    (0.5, 0.11),
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

/// "Cristiano Ronaldo" → "Ronaldo".
String surnameOf(String full) {
  final parts = full.trim().split(' ');
  return parts.isEmpty ? full : parts.last;
}

/// What to write under each of [shown]: the SURNAME on its own, with the first
/// initial added back only for the men who would otherwise be
/// indistinguishable from a team-mate.
///
/// Every name used to carry its initial ("C. Ronaldo") because two players can
/// share a surname. They rarely do in the same eleven, so the initial was
/// three wasted characters on ten of the eleven — and on a pitch node, where
/// the width is the whole problem, three characters is the difference between
/// a name that fits and a name that has to shrink to fit.
Map<int, String> pitchNameLabels(Iterable<Player> shown) {
  final bySurname = <String, List<Player>>{};
  for (final p in shown) {
    (bySurname[surnameOf(p.name).toUpperCase()] ??= []).add(p);
  }
  final out = <int, String>{};
  for (final group in bySurname.values) {
    if (group.length == 1) {
      out[group.first.id] = surnameOf(group.first.name);
      continue;
    }
    // Shared surname: the initial tells them apart. If it doesn't either —
    // two men with the same initial AND surname — spell the first name out,
    // because at that point nothing shorter distinguishes them at all.
    final byInitial = <String, int>{};
    for (final p in group) {
      final initial = p.name.trim().isEmpty ? '' : p.name.trim()[0];
      byInitial[initial] = (byInitial[initial] ?? 0) + 1;
    }
    for (final p in group) {
      final first = p.name.trim().split(' ').first;
      final initial = first.isEmpty ? '' : first[0];
      out[p.id] = (byInitial[initial] ?? 0) > 1
          ? '$first ${surnameOf(p.name)}'
          : '$initial. ${surnameOf(p.name)}';
    }
  }
  return out;
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
  // Mentality used to lift the whole outfield up the pitch (and the forwards
  // further still), which squeezed the lines together at the attacking end and
  // left the shape bunched in the middle of the pitch. It is a mentality, not
  // a formation: what it changes is how the side plays, which the match engine
  // already reads — it has no business redrawing the shape the manager set.
  //
  // The defensive LINE does still move, because that is exactly what that dial
  // means, and it moves one line rather than all of them.
  var y = baseY;
  if (category == PositionCategory.defender) {
    // Small on purpose. This is the one dial that still moves a line, and it
    // moves it toward another one: at the old ±0.10 a high line was worth most
    // of a ball on a phone, which drove the back four bodily into midfield in
    // nearly every shape in the game.
    y -= (i.defensiveLine - 50) / 50 * 0.04;
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
    final score =
        (c.$1 - wantD).abs() + (c.$2 - wantM).abs() + (c.$3 - wantF).abs();
    final better =
        score < bestScore ||
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

  /// The band the ten outfield players are drawn in. The keeper is pinned
  /// below the floor, on his line.
  ///
  /// It used to be 0.10–0.68, which left the shape huddled in the top two
  /// thirds with a wide empty strip in front of the keeper — every line closer
  /// to the next than it needed to be. A node is now barely taller than its
  /// own ball, so the band can open up: the same eleven, further apart.
  static const double _outfieldFloor = 0.78;
  static const double _outfieldCeiling = 0.06;

  /// Where the keeper stands. Below every outfield player, on the goal line.

  /// Nudges a slot's base coordinate by the instructions so the shape reads the
  /// tactics: a wider or narrower spread, and a higher or deeper back line.
  (double, double) _adjusted(
    (double, double) base,
    PositionCategory category,
  ) {
    final i = instructions;
    // Width: spread outfield players out from / in toward the centre line. The
    // span is deliberately modest so a wide 3-back shape (e.g. 3-4-3) can't push
    // the widest players' name labels off the painted pitch.
    // The narrow end used to pull the side into 0.82 of its shape, which put
    // a five-across midfield closer together than a ball is wide — the eleven
    // ended up huddled in the middle of the pitch and their discs touched.
    // A narrow team should read narrower than a wide one, not collapse
    // inward, so the dial now runs from nearly-natural to genuinely spread.
    // The dial NARROWS from the drawn shape; it never widens past it.
    //
    // The layouts already put the wide men on the touchline, so a factor above
    // 1.0 only pushed them into the edge clamp while their neighbours carried
    // on spreading — which pulled the neighbour INTO the clamped player and
    // made "wide" the tightest setting on the whole pitch, the opposite of
    // what it says. And the old bottom of 0.82 hauled the whole side into the
    // middle. Ten per cent either side of the drawn shape reads as a narrow
    // team without either failure.
    final widthFactor = 0.95 + i.width / 100 * 0.05; // 0.95 … 1.00
    final x = 0.5 + (base.$1 - 0.5) * widthFactor;
    // The keeper is pinned on the goal line and never shifts up the pitch, so
    // a deep defensive line can't drop the back line on top of them.
    if (category == PositionCategory.goalkeeper) {
      return (x.clamp(_edgeX, 1 - _edgeX), _keeperLine);
    }
    // A high defensive line pushes the back line up — see [adjustedSlotY],
    // which the drop resolver reads too so the two can never disagree.
    final y = adjustedSlotY(base.$2, category, i);
    // Compress the outfield into its band rather than clamping to the floor:
    // clamping flattened a staggered back line (centre-halves deeper than the
    // full-backs) into one straight row as soon as the deepest player hit the
    // cap. Squeezing keeps the shape and just fits it above the keeper.
    const from = 0.82;
    final squeezed =
        _outfieldCeiling +
        (y.clamp(_outfieldCeiling, from) - _outfieldCeiling) *
            ((_outfieldFloor - _outfieldCeiling) / (from - _outfieldCeiling));
    // Cap the width so the widest players' balls stay on the pitch. With the
    // dial no longer widening past the drawn shape this is a backstop, not a
    // working part of the layout.
    return (x.clamp(_edgeX, 1 - _edgeX), squeezed);
  }

  /// How tall a node is, so the layout can keep whole nodes inside the pitch.
  ///
  /// The ball and the two badges on its rim, and nothing else — the position,
  /// the rating and the name all live inside the circle now. It used to be
  /// half as tall again, which is what put one man's name on the next man's
  /// disc in the tighter shapes.
  double _nodeHeight(double disc) => disc + _badgeOverhang * 2;

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
            final m = _metricsFor(constraints.maxWidth);
            final top = height <= 0 ? 0.0 : (m.disc / 2) / height;
            final bottom = height <= 0
                ? 0.0
                : (_nodeHeight(m.disc) - m.disc / 2) / height;
            final span = (1 - top - bottom).clamp(0.05, 1.0);
            double place(double y) => top + y * span;

            // Whether a name needs its initial is a question about the OTHER
            // ten, so it is answered once for the whole eleven rather than per
            // node.
            final names = pitchNameLabels([
              for (final id in lineup)
                if (id != null && byId[id] != null) byId[id]!,
            ]);

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
                        name: names[lineup[slot]],
                        metrics: m,
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

/// How wide a node may be, as a fraction of the pitch's width.
///
/// This is the whole layout budget, and it is a FRACTION rather than a number
/// of points because the pitch is: every slot coordinate is a fraction of the
/// width, so the distance between two team-mates is too.
///
/// MEASURED, not guessed, and measured as a straight line between two players
/// rather than as a horizontal gap: the tightest pair in the whole game is the
/// staggered middle of a 3-5-2, where the two inside midfielders sit closer to
/// each other on the diagonal than any two players in the same row ever do.
/// Reading off same-row pairs alone ships discs that visibly touch. Re-measure
/// with the pitch's own widget test whenever the layouts, the width dial or
/// the outfield band change — the figure moved from 0.1477 to 0.1616 the last
/// time the narrow end of the width dial was opened up.
const double _nodeWidthFraction = 0.150;

/// The disc's own share of the pitch width, a little under a node's so the
/// rim badges have somewhere to sit.
///
/// A FRACTION, like the node — these were points once, and a fixed number of
/// points shaved off a proportional width means the clear air between two
/// balls shrinks as the screen grows: the same layout that looked right on a
/// phone drew balls almost touching on a tablet.
///
/// This is the CEILING, measured: the vertical insets are derived from the disc
/// too, so a bigger ball also pulls the rows closer together, and the pitch's
/// own clear-air test fails at 0.147. A "make the balls bigger" is therefore
/// always a request for padding INSIDE them — see [_discInnerWidth].
const double _discWidthFraction = 0.145;

/// How close to the touchline a player's CENTRE may sit — half a node, so a
/// whole node stays on the painted pitch.
const double _edgeX = _nodeWidthFraction / 2;

/// The range a disc is kept inside, so it stays a legible circle on a small
/// phone without becoming a dinner plate on a tablet.
const double _discMin = 32;
const double _discMax = 76;

/// The sizes a node is drawn at on a pitch of a given width.
typedef _NodeMetrics = ({double node, double disc});

/// Node sizes for a pitch [width] points across.
///
/// Fixed sizes were the bug behind the bug: 46pt discs and a 58pt name label
/// happen to fit a 390pt phone and overlap a 320pt one, and waste half the
/// room on a tablet. Deriving both from the width means the eleven are drawn
/// as large as they can be AND never closer than they can be read.
_NodeMetrics _metricsFor(double width) => (
  node: (width * _nodeWidthFraction).clamp(34.0, 96.0),
  disc: (width * _discWidthFraction).clamp(_discMin, _discMax),
);

class _PlayerNode extends StatelessWidget {
  const _PlayerNode({
    required this.slot,
    required this.position,
    required this.player,
    required this.onTap,
    required this.onSwap,
    required this.onBenchIn,
    required this.metrics,
    this.name,
    this.teamColors,
    this.absent = false,
    this.injured = false,
    this.energy,
  });

  final int slot;
  final PlayerPosition position;
  final Player? player;

  /// How big to draw, derived from the pitch's own width — see [_metricsFor].
  final _NodeMetrics metrics;

  /// What to write under the disc — the surname, with an initial in front of
  /// it only when a team-mate shares it. Resolved for the whole eleven at once
  /// (see [pitchNameLabels]), because whether a name needs its initial is a
  /// question about the OTHER ten.
  final String? name;

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

  Widget _node(
    AppLocalizations l, {
    bool highlighted = false,
    bool dragging = false,
  }) {
    final p = player;
    // An absent player overrides the fit cue entirely — nothing about the slot
    // matters until he is replaced. Injury shows orange, suspension red.
    final absentColor = injured ? AppColors.warning : AppColors.error;
    final fit = absent ? absentColor : _fitColor;
    final borderColor = highlighted ? AppColors.primary : fit;
    // The rating as it actually counts in this slot — docked when the player is
    // out of position, so the manager sees the real number before committing.
    final effective = p == null
        ? null
        : PositionFit.effectiveOverall(p, position);
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
    final filled =
        tc != null && tc.isNotEmpty && p != null && !absent && !penalised;
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
    final nameColor = absent ? absentColor : onTeam;
    // The whole node IS the ball, give or take the two badges that straddle
    // its rim. Everything the manager reads — position, rating, name — sits
    // INSIDE the circle, which is the only arrangement in which a label
    // cannot end up written across the player standing next to him. It used
    // to hang the name in a band below the disc, and in the tight shapes
    // (five at the back, a deep midfield) that band landed squarely on the
    // disc of the man in the row underneath.
    final overhang = _badgeOverhang;
    return Material(
      type: MaterialType.transparency,
      child: SizedBox(
        width: metrics.node,
        height: metrics.disc + overhang * 2,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              // Keyed so a test can measure where the ball actually lands: the
              // rule that matters is that nothing a node draws ever touches
              // another player's DISC, and that cannot be checked without both
              // rectangles.
              key: ValueKey('pitchDisc$slot'),
              width: metrics.disc,
              height: metrics.disc,
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
              child: _DiscContents(
                key: ValueKey('pitchName$slot'),
                disc: metrics.disc,
                // The rating this player actually plays at IN THIS SLOT. In
                // his own position that is simply his overall; out of position
                // it is the docked figure, and the amber bubble around it says
                // why — so the number on the pitch is always the number the
                // match engine will use.
                rating: p == null ? '+' : '${effective!}',
                name: p == null ? null : (name ?? surnameOf(p.name)),
                icon: absent
                    ? (injured ? Icons.personal_injury : Icons.gavel_rounded)
                    : null,
                iconColor: absentColor,
                textColor: nameColor,
                bold: penalised,
              ),
            ),
            // The position, on top of the ball. Straddling the rim rather than
            // sitting above it: a badge fully outside the circle is another
            // row of node to collide with.
            Positioned(
              top: 0,
              child: _RimBadge(
                label: position.label,
                color: fit,
                background: fit.withValues(alpha: 0.18),
                maxWidth: metrics.node,
              ),
            ),
            // The bottom of the rim says whatever is urgent: that he cannot
            // play, or — during a match — how much he has left.
            if (absent)
              Positioned(
                bottom: 0,
                child: _RimBadge(
                  label: injured
                      ? l.tacticsInjuredShort
                      : l.tacticsSuspendedShort,
                  color: absentColor,
                  background: absentColor.withValues(alpha: 0.18),
                  maxWidth: metrics.node,
                ),
              )
            else if (p != null && energy != null)
              Positioned(
                bottom: 0,
                child: _RimBadge(
                  label: '$energy%',
                  color: energyColor(energy!),
                  background: energyColor(energy!).withValues(alpha: 0.18),
                  maxWidth: metrics.node,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// How far a rim badge hangs outside the circle it is pinned to. Half its own
/// height, so it straddles the edge: a badge sitting fully outside would add a
/// whole extra band to the node, which is the thing being got rid of.
const double _badgeOverhang = 7;

/// The width of a disc's usable interior, as a fraction of its diameter, and
/// the height that leaves. A rectangle fits inside a circle when its diagonal
/// does, so these two are chosen together: 0.84² + 0.54² = 0.997 < 1.
///
/// Weighted toward WIDTH on purpose. What the interior has to hold is a name
/// on one line, and every point of width buys a character; the height only has
/// to clear the rating plus that one line. Trading a little of it for a wider
/// box is what keeps a name off a second line.
/// Widened once (0.84 → 0.87) at the cost of height (0.54 → 0.49), and pulled
/// back in again since. At 0.87 × 0.49 the interior's own corners sat at 0.499
/// of the diameter — ON the rim — so a long surname ran into the edge of the
/// ball with nothing around it and the type read as crammed. At 0.84 × 0.48
/// the corners sit at 0.484 and the name has air on every side.
///
/// The ball itself could not be grown instead: [_discWidthFraction] is already
/// at the size the clear-air rule allows, so padding has to be found in here.
const double _discInnerWidth = 0.84;
const double _discInnerHeight = 0.48;

/// The size a name is asks to be drawn at, RELATIVE to the rating above it.
///
/// It is not the size that reaches the screen: the two of them share one
/// [FittedBox], which scales the pair together into the interior. So what this
/// number actually sets is how the circle is divided between the rating and
/// the name — raise it and the name comes out larger and the rating smaller.
/// At 9.5 against a rating of 0.32 of the disc, the number was half again the
/// size of the name and the name was the half a manager cannot work out for
/// himself.
const double _nameFontSize = 11.5;

/// What sits inside a player's disc: his position rating, his name, and — when
/// he cannot play — the icon that says why.
///
/// The name is never CUT. Surnames run to sixteen letters, so a fixed box plus
/// `TextOverflow.ellipsis` truncates the long ones every single time, which is
/// not a name any more. [WholeText] wraps it to a second line first and only
/// then scales it down, so it always arrives whole — the same promise the
/// squad list and the call-up screen now make.
class _DiscContents extends StatelessWidget {
  const _DiscContents({
    required this.disc,
    required this.rating,
    required this.name,
    required this.icon,
    required this.iconColor,
    required this.textColor,
    required this.bold,
    super.key,
  });

  final double disc;
  final String rating;
  final String? name;
  final IconData? icon;
  final Color iconColor;
  final Color textColor;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final inner = disc * _discInnerWidth;
    final label = name;
    return SizedBox(
      width: inner,
      height: disc * _discInnerHeight,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: SizedBox(
          // A bounded width is what lets the name wrap before anything is
          // scaled: an unbounded Text lays out on one endless line and the
          // FittedBox then shrinks that line to nothing.
          width: inner,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon case final glyph?)
                Icon(glyph, size: disc * 0.30, color: iconColor)
              else
                Text(
                  rating,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: AppTypography.titleMedium.copyWith(
                    // The number is the thing the manager reads across the
                    // pitch, so it takes as much of the circle as the name
                    // underneath can spare.
                    // Was 0.32, which left the rating taking two thirds of the
                    // interior and the name squeezed into what was left — and
                    // the name is the half a manager cannot work out for
                    // himself. Still comfortably the largest thing in the
                    // circle, and the name is drawn a quarter larger for it.
                    fontSize: disc * 0.30,
                    // Tight leading on both this and the name: the interior is
                    // half a dozen points tall and every point of it spent on
                    // the space ABOVE a line is a point the type itself does
                    // not get.
                    height: 0.95,
                    color: textColor,
                    fontWeight: bold ? FontWeight.w800 : FontWeight.w700,
                  ),
                ),
              if (label != null)
                WholeText(
                  label.toUpperCase(),
                  // THREE lines, not two. A name too long for two was CLIPPED
                  // — [Text] drops the lines past its limit, and no amount of
                  // scaling down brings them back — so the very longest
                  // surnames arrived on the pitch with their ends missing,
                  // which is the one thing this widget exists to prevent. A
                  // third line costs the short names nothing: a block is only
                  // as tall as the lines it actually uses.
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  style: AppTypography.labelSmall.copyWith(
                    fontSize: _nameFontSize,
                    height: 0.95,
                    letterSpacing: 0,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A small pill straddling the rim of a player's disc — the position on top,
/// and whatever is urgent underneath.
class _RimBadge extends StatelessWidget {
  const _RimBadge({
    required this.label,
    required this.color,
    required this.background,
    required this.maxWidth,
  });

  final String label;
  final Color color;
  final Color background;
  final double maxWidth;

  @override
  Widget build(BuildContext context) => Container(
    constraints: BoxConstraints(maxWidth: maxWidth),
    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
    decoration: BoxDecoration(
      color: Color.alphaBlend(background, AppColors.surfaceContainerLowest),
      borderRadius: AppRadii.smAll,
      border: Border.all(color: color),
    ),
    child: Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.clip,
      softWrap: false,
      style: AppTypography.labelSmall.copyWith(
        fontSize: 8,
        height: 1.1,
        letterSpacing: 0,
        color: color,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
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
      trailing:
          trailing ??
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
          surnameOf(player.name).toUpperCase(),
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
