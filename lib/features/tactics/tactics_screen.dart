import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/tactics/position_fit.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

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
          // Pop back to wherever we came from (e.g. the match preview); fall
          // back to the hub when opened as a root tab.
          onPressed: () => context.canPop()
              ? context.pop()
              : context.go('${Routes.hub}?careerId=$careerId'),
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
      bottomNavigationBar:
          AppBottomNav(careerId: careerId, current: AppTab.squad),
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
                child: TacticsPitch(
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
                    // The pitch scrolls, so a drag has to start with a hold —
                    // say so, or it just reads as the page moving.
                    Text(
                      'Tap a player to swap them out, or hold and drag one to '
                      'move them.',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
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
                      'Hold a sub, then drag them onto a player to bring '
                      'them on.',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppCard(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          for (final p in subs) SubDragRow(player: p),
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
          ..sort(PositionFit.bySlotFit(position));

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
                  '${p.position.roleName} · Age ${p.age}',
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

  /// Handles a pitch drag from slot [a] onto slot [b] by persisting the
  /// resolved swap or reshape.
  void _dragBetweenSlots(TacticService service, Tactic tactic, int a, int b) {
    switch (resolveDrag(tactic.formation, a, b)) {
      case SwapSlots():
        unawaited(service.swapSlots(careerId, a, b));
      case ReshapeTo(:final formation):
        unawaited(service.reshapeFormation(careerId, formation));
    }
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
