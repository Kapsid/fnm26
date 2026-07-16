import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/tactics/position_fit.dart';
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
    super.key,
  });

  final Formation formation;
  final TacticalInstructions instructions;
  final List<int?> lineup;
  final Map<int, Player> byId;
  final ValueChanged<int> onTapSlot;
  final void Function(int slotA, int slotB) onSwap;
  final void Function(int slot, int playerId) onBenchIn;

  /// Nudges a slot's base coordinate by the instructions so the shape reads the
  /// tactics: wider/narrower spread, a higher/deeper back line, and a more
  /// advanced team when attacking.
  (double, double) _adjusted(
    (double, double) base,
    PositionCategory category,
  ) {
    final i = instructions;
    // Width: spread outfield players out from / in toward the centre line.
    final widthFactor = 0.82 + i.width / 100 * 0.30; // 0.82 … 1.12
    final x = 0.5 + (base.$1 - 0.5) * widthFactor;
    // The keeper is pinned near the goal line and never shifts up the pitch, so
    // a deep defensive line can't drop the back four on top of them.
    if (category == PositionCategory.goalkeeper) {
      return (x.clamp(0.04, 0.96), 0.93);
    }
    // Attacking mentality lifts the whole outfield up the pitch (lower y).
    var y = base.$2 - (i.mentality - 50) / 50 * 0.05;
    if (category == PositionCategory.defender) {
      // A high defensive line pushes the back line up; a deep one drops it.
      y -= (i.defensiveLine - 50) / 50 * 0.10;
    } else if (category == PositionCategory.forward) {
      y -= (i.mentality - 50) / 50 * 0.02;
    }
    // Cap outfield depth short of the keeper so the lines never overlap them.
    return (x.clamp(0.04, 0.96), y.clamp(0.10, 0.82));
  }

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
        child: Stack(
          children: [
            for (var slot = 0; slot < 11; slot++)
              () {
                final pos = _adjusted(layout[slot], positions[slot].category);
                return Align(
                  alignment: Alignment(pos.$1 * 2 - 1, pos.$2 * 2 - 1),
                  child: _PlayerNode(
                    slot: slot,
                    position: positions[slot],
                    player: byId[lineup[slot]],
                    onTap: () => onTapSlot(slot),
                    onSwap: onSwap,
                    onBenchIn: onBenchIn,
                  ),
                );
              }(),
          ],
        ),
      ),
    );
  }
}

class _PlayerNode extends StatelessWidget {
  const _PlayerNode({
    required this.slot,
    required this.position,
    required this.player,
    required this.onTap,
    required this.onSwap,
    required this.onBenchIn,
  });

  final int slot;
  final PlayerPosition position;
  final Player? player;
  final VoidCallback onTap;
  final void Function(int slotA, int slotB) onSwap;
  final void Function(int slot, int playerId) onBenchIn;

  @override
  Widget build(BuildContext context) {
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
        final node = _node(highlighted: candidate.isNotEmpty);
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
            feedback: _node(dragging: true),
            childWhenDragging: Opacity(opacity: 0.35, child: node),
            child: node,
          ),
        );
      },
    );
  }

  /// How well the assigned player suits this slot, driving the colour cue:
  /// green = exact position, primary = right line/different role, red = out of
  /// position (and taking a rating penalty in matches).
  Color get _fitColor {
    final p = player;
    if (p == null) return AppColors.outlineVariant;
    if (p.position == position) return AppColors.positive;
    if (p.category == position.category) return AppColors.primary;
    return AppColors.error;
  }

  Widget _node({bool highlighted = false, bool dragging = false}) {
    final p = player;
    final fit = _fitColor;
    final borderColor = highlighted ? AppColors.primary : fit;
    // The rating as it actually counts in this slot — docked when the player is
    // out of position, so the manager sees the real number before committing.
    final effective =
        p == null ? null : PositionFit.effectiveOverall(p, position);
    final penalised = p != null && effective! < p.overall;
    return Material(
      type: MaterialType.transparency,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.surfaceContainerHighest,
                  AppColors.surfaceContainer,
                ],
              ),
              border: Border.all(
                color: borderColor,
                width: highlighted || dragging ? 3 : 2,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              p == null ? '+' : '$effective',
              style: AppTypography.labelMedium.copyWith(
                color: penalised ? AppColors.error : AppColors.primary,
              ),
            ),
          ),
          // When out of position, spell out the drop from the base rating.
          if (penalised) ...[
            const SizedBox(height: 2),
            Text(
              '${p.overall}→$effective',
              style: AppTypography.labelSmall.copyWith(
                fontSize: 8,
                color: AppColors.error,
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
            Text(
              shortName(p.name).toUpperCase(),
              style: AppTypography.labelSmall.copyWith(fontSize: 8),
            ),
          ],
        ],
      ),
    );
  }
}

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
