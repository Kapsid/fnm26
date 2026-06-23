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

/// Squad & tactics: formation, starting XI, and team instructions.
class TacticsScreen extends ConsumerStatefulWidget {
  const TacticsScreen({required this.careerId, super.key});

  final int careerId;

  @override
  ConsumerState<TacticsScreen> createState() => _TacticsScreenState();
}

class _TacticsScreenState extends ConsumerState<TacticsScreen> {
  TacticalInstructions? _local;

  @override
  Widget build(BuildContext context) {
    final dataAsync = ref.watch(tacticDataProvider(widget.careerId));
    final service = ref.read(tacticServiceProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () =>
              context.go('${Routes.hub}?careerId=${widget.careerId}'),
        ),
        title: Text(
          'SQUAD & TACTICS',
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load tactics.\n$e')),
        data: (data) {
          if (data == null) {
            return const Center(child: Text('No tactic set.'));
          }
          final tactic = data.tactic;
          final instr = _local ?? tactic.instructions;

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            children: [
              const Text('FORMATION', style: AppTypography.labelMedium),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                children: [
                  for (final f in Formation.values)
                    GestureDetector(
                      onTap: () => service.setFormation(widget.careerId, f),
                      child: TacticalChip(
                        f.label,
                        emphasized: f == tactic.formation,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              const Text('STARTING XI', style: AppTypography.labelMedium),
              const SizedBox(height: AppSpacing.sm),
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    for (var slot = 0; slot < 11; slot++)
                      _SlotRow(
                        position: tactic.formation.positions[slot],
                        player: data.byId[tactic.lineup[slot]],
                        onTap: () => _pickPlayer(context, data, slot),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const Text('INSTRUCTIONS', style: AppTypography.labelMedium),
              const SizedBox(height: AppSpacing.sm),
              AppCard(
                child: Column(
                  children: [
                    _slider(
                      'Mentality',
                      'Defensive',
                      'Attacking',
                      instr.mentality,
                      (v) => _set(instr.copyWith(mentality: v)),
                    ),
                    _slider(
                      'Pressing',
                      'Low block',
                      'High press',
                      instr.pressing,
                      (v) => _set(instr.copyWith(pressing: v)),
                    ),
                    _slider(
                      'Tempo',
                      'Patient',
                      'Fast',
                      instr.tempo,
                      (v) => _set(instr.copyWith(tempo: v)),
                    ),
                    _slider(
                      'Width',
                      'Narrow',
                      'Wide',
                      instr.width,
                      (v) => _set(instr.copyWith(width: v)),
                    ),
                    _slider(
                      'Def. line',
                      'Deep',
                      'High',
                      instr.defensiveLine,
                      (v) => _set(instr.copyWith(defensiveLine: v)),
                    ),
                    _slider(
                      'Directness',
                      'Possession',
                      'Direct',
                      instr.directness,
                      (v) => _set(instr.copyWith(directness: v)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          );
        },
      ),
    );
  }

  void _set(TacticalInstructions next) => setState(() => _local = next);

  Widget _slider(
    String label,
    String low,
    String high,
    int value,
    ValueChanged<int> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
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
            label: '$value',
            onChanged: (v) => onChanged(v.round()),
            onChangeEnd: (_) {
              final i = _local;
              if (i != null) {
                unawaited(
                  ref
                      .read(tacticServiceProvider)
                      .setInstructions(widget.careerId, i),
                );
              }
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(low, style: _hint),
              Text(high, style: _hint),
            ],
          ),
        ],
      ),
    );
  }

  TextStyle get _hint =>
      AppTypography.labelSmall.copyWith(color: AppColors.onSurfaceVariant);

  Future<void> _pickPlayer(
    BuildContext context,
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
            'PICK ${position.label}',
            style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final p in candidates)
            ListTile(
              dense: true,
              leading: TacticalChip(p.position.label),
              title: Text(p.name, style: AppTypography.bodyMedium),
              trailing: Text('${p.overall}', style: AppTypography.labelMedium),
              selected: data.tactic.lineup.contains(p.id),
              onTap: () => Navigator.of(context).pop(p.id),
            ),
        ],
      ),
    );
    if (picked != null) {
      await ref
          .read(tacticServiceProvider)
          .setSlot(widget.careerId, slot, picked);
    }
  }
}

class _SlotRow extends StatelessWidget {
  const _SlotRow({
    required this.position,
    required this.player,
    required this.onTap,
  });

  final PlayerPosition position;
  final Player? player;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      dense: true,
      leading: SizedBox(
        width: 36,
        child: TacticalChip(position.label, emphasized: true),
      ),
      title: Text(
        player?.name ?? 'Empty',
        style: AppTypography.bodyMedium,
      ),
      trailing: player == null
          ? const Icon(Icons.add, color: AppColors.outline)
          : Text('${player!.overall}', style: AppTypography.labelMedium),
    );
  }
}
