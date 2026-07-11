import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

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

/// Squad: a tactical pitch view of the starting XI with the substitutes list
/// and formation selector. Players can be tapped to pick, or dragged to swap
/// positions / bring a substitute on. Instructions live behind the tune action.
class TacticsScreen extends ConsumerWidget {
  const TacticsScreen({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(tacticDataProvider(careerId));
    final service = ref.read(tacticServiceProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.go('${Routes.hub}?careerId=$careerId'),
        ),
        title: Text(
          'SQUAD',
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.groups, color: AppColors.primary),
            tooltip: 'Call-ups',
            onPressed: () =>
                context.go('${Routes.callUps}?careerId=$careerId'),
          ),
          dataAsync.maybeWhen(
            data: (data) => IconButton(
              icon: const Icon(Icons.tune, color: AppColors.primary),
              tooltip: 'Instructions',
              onPressed: data == null
                  ? null
                  : () => _openInstructions(context, ref, data.tactic),
            ),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load squad.\n$e')),
        data: (data) {
          if (data == null) return const Center(child: Text('No tactic set.'));
          final tactic = data.tactic;
          final startingIds = tactic.lineup.whereType<int>().toSet();
          final subs =
              data.pool.where((p) => !startingIds.contains(p.id)).toList()
                ..sort((a, b) => b.overall.compareTo(a.overall));

          return ListView(
            children: [
              AspectRatio(
                aspectRatio: 3 / 4,
                child: _Pitch(
                  formation: tactic.formation,
                  instructions: tactic.instructions,
                  lineup: tactic.lineup,
                  byId: data.byId,
                  onTapSlot: (slot) => _pickPlayer(context, ref, data, slot),
                  onSwap: (a, b) =>
                      _dragBetweenSlots(service, tactic, a, b),
                  onBenchIn: (slot, playerId) =>
                      service.setSlot(careerId, slot, playerId),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.marginMobile),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('FORMATION', style: AppTypography.labelMedium),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        for (final f in Formation.values)
                          GestureDetector(
                            onTap: () => service.setFormation(careerId, f),
                            child: TacticalChip(
                              f.label,
                              emphasized: f == tactic.formation,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'SUBSTITUTES · ${subs.length}',
                      style: AppTypography.labelMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Drag a sub onto a player to bring them on.',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppCard(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          for (final p in subs) _SubRow(player: p),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _pickPlayer(
    BuildContext context,
    WidgetRef ref,
    TacticData data,
    int slot,
  ) async {
    final position = data.tactic.formation.positions[slot];
    final candidates =
        data.pool
            .where((p) => p.position.category == position.category)
            .toList()
          ..sort((a, b) => b.overall.compareTo(a.overall));

    final picked = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: AppColors.surfaceContainer,
      builder: (_) => ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(
            'PICK ${position.roleName.toUpperCase()}',
            style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final p in candidates)
            () {
              final inXi = data.tactic.lineup.contains(p.id);
              return ListTile(
                dense: true,
                leading: TacticalChip(p.position.label),
                title: Text(
                  p.name,
                  style: AppTypography.bodyMedium.copyWith(
                    color: inXi ? AppColors.onSurfaceVariant : null,
                    fontWeight: inXi ? FontWeight.w400 : FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  '${p.club} · ${p.position.roleName}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (inXi) ...[
                      const TacticalChip('IN XI'),
                      const SizedBox(width: AppSpacing.sm),
                    ],
                    Text('${p.overall}', style: AppTypography.labelMedium),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(
                        Icons.info_outline,
                        size: 20,
                        color: AppColors.onSurfaceVariant,
                      ),
                      onPressed: () => context.push(
                        '${Routes.player}?careerId=$careerId&playerId=${p.id}',
                      ),
                    ),
                  ],
                ),
                selected: inXi,
                selectedTileColor: AppColors.surfaceContainerHigh,
                onTap: () => Navigator.of(context).pop(p.id),
              );
            }(),
        ],
      ),
    );
    if (picked != null) {
      await ref.read(tacticServiceProvider).setSlot(careerId, slot, picked);
    }
  }

  /// Handles a pitch drag from slot [a] onto slot [b]. Within the same line it
  /// is a straight swap; across lines it reshapes to the formation implied by
  /// moving the dragged player to the target's line (keeping the same players),
  /// falling back to a swap when no such formation exists.
  void _dragBetweenSlots(TacticService service, Tactic tactic, int a, int b) {
    final positions = tactic.formation.positions;
    final catA = positions[a].category;
    final catB = positions[b].category;
    if (catA == catB) {
      unawaited(service.swapSlots(careerId, a, b));
      return;
    }
    final counts = _lineCounts(tactic.formation);
    final next = _formationForCounts(
      _adjust(counts.$1, PositionCategory.defender, catA, catB),
      _adjust(counts.$2, PositionCategory.midfielder, catA, catB),
      _adjust(counts.$3, PositionCategory.forward, catA, catB),
    );
    if (next != null && next != tactic.formation) {
      unawaited(service.reshapeFormation(careerId, next));
    } else {
      unawaited(service.swapSlots(careerId, a, b));
    }
  }

  /// Adjusts a line's count for a move from [from]'s line to [to]'s line.
  int _adjust(int count, PositionCategory line, PositionCategory from,
      PositionCategory to) {
    var n = count;
    if (from == line) n--;
    if (to == line) n++;
    return n;
  }

  Future<void> _openInstructions(
    BuildContext context,
    WidgetRef ref,
    Tactic tactic,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surfaceContainer,
      isScrollControlled: true,
      builder: (_) => _InstructionsSheet(careerId: careerId, tactic: tactic),
    );
  }
}

class _Pitch extends StatelessWidget {
  const _Pitch({
    required this.formation,
    required this.instructions,
    required this.lineup,
    required this.byId,
    required this.onTapSlot,
    required this.onSwap,
    required this.onBenchIn,
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
    var y = base.$2;
    if (category != PositionCategory.goalkeeper) {
      // Attacking mentality lifts the whole outfield up the pitch (lower y).
      y -= (i.mentality - 50) / 50 * 0.05;
    }
    if (category == PositionCategory.defender) {
      // A high defensive line pushes the back line up; a deep one drops it.
      y -= (i.defensiveLine - 50) / 50 * 0.10;
    } else if (category == PositionCategory.forward) {
      y -= (i.mentality - 50) / 50 * 0.02;
    }
    return (x.clamp(0.04, 0.96), y.clamp(0.07, 0.93));
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

/// The (defenders, midfielders, forwards) count of a formation's outfield.
(int, int, int) _lineCounts(Formation f) {
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
Formation? _formationForCounts(int d, int m, int w) {
  for (final f in Formation.values) {
    final c = _lineCounts(f);
    if (c.$1 == d && c.$2 == m && c.$3 == w) return f;
  }
  return null;
}

/// "Cristiano Ronaldo" → "C. Ronaldo" (surnames can repeat in a squad).
String shortName(String full) {
  final parts = full.trim().split(' ');
  if (parts.length < 2) return full;
  return '${parts.first[0]}. ${parts.last}';
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
          child: Draggable<Object>(
            data: _SlotDrag(slot),
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
              p == null ? '+' : '${p.overall}',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
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

class _SubRow extends StatelessWidget {
  const _SubRow({required this.player});
  final Player player;

  @override
  Widget build(BuildContext context) {
    final row = ListTile(
      dense: true,
      leading: SizedBox(width: 40, child: TacticalChip(player.position.label)),
      title: Text(player.name, style: AppTypography.bodyMedium),
      subtitle: Text(
        player.position.roleName,
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),
      trailing: const Icon(
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
      feedback: chip(),
      childWhenDragging: Opacity(opacity: 0.4, child: row),
      child: row,
    );
  }
}

class _InstructionsSheet extends ConsumerStatefulWidget {
  const _InstructionsSheet({required this.careerId, required this.tactic});

  final int careerId;
  final Tactic tactic;

  @override
  ConsumerState<_InstructionsSheet> createState() => _InstructionsSheetState();
}

class _InstructionsSheetState extends ConsumerState<_InstructionsSheet> {
  late TacticalInstructions _i = widget.tactic.instructions;

  void _set(TacticalInstructions next) {
    setState(() => _i = next);
    unawaited(
      ref.read(tacticServiceProvider).setInstructions(widget.careerId, next),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'INSTRUCTIONS',
            style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
          ),
          _slider(
            'Mentality',
            'Defensive',
            'Attacking',
            _i.mentality,
            (v) => _set(_i.copyWith(mentality: v)),
          ),
          _slider(
            'Pressing',
            'Low block',
            'High press',
            _i.pressing,
            (v) => _set(_i.copyWith(pressing: v)),
          ),
          _slider(
            'Tempo',
            'Patient',
            'Fast',
            _i.tempo,
            (v) => _set(_i.copyWith(tempo: v)),
          ),
          _slider(
            'Width',
            'Narrow',
            'Wide',
            _i.width,
            (v) => _set(_i.copyWith(width: v)),
          ),
          _slider(
            'Def. line',
            'Deep',
            'High',
            _i.defensiveLine,
            (v) => _set(_i.copyWith(defensiveLine: v)),
          ),
          _slider(
            'Directness',
            'Possession',
            'Direct',
            _i.directness,
            (v) => _set(_i.copyWith(directness: v)),
          ),
        ],
      ),
    );
  }

  Widget _slider(
    String label,
    String low,
    String high,
    int value,
    ValueChanged<int> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: AppTypography.bodyMedium),
            const Spacer(),
            Text('$value', style: AppTypography.labelMedium),
          ],
        ),
        Slider(
          value: value.toDouble(),
          max: 100,
          divisions: 20,
          onChanged: (v) => onChanged(v.round()),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              low,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            Text(
              high,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
