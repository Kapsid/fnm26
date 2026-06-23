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
};

/// Squad: a tactical pitch view of the starting XI with the substitutes list
/// and formation selector. Instructions live behind the tune action.
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
                  lineup: tactic.lineup,
                  byId: data.byId,
                  onTapSlot: (slot) => _pickPlayer(context, ref, data, slot),
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
            ListTile(
              dense: true,
              leading: TacticalChip(p.position.label),
              title: Text(p.name, style: AppTypography.bodyMedium),
              subtitle: Text(
                p.position.roleName,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              trailing: Text('${p.overall}', style: AppTypography.labelMedium),
              selected: data.tactic.lineup.contains(p.id),
              onTap: () => Navigator.of(context).pop(p.id),
            ),
        ],
      ),
    );
    if (picked != null) {
      await ref.read(tacticServiceProvider).setSlot(careerId, slot, picked);
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

class _Pitch extends StatelessWidget {
  const _Pitch({
    required this.formation,
    required this.lineup,
    required this.byId,
    required this.onTapSlot,
  });

  final Formation formation;
  final List<int?> lineup;
  final Map<int, Player> byId;
  final ValueChanged<int> onTapSlot;

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
              Align(
                alignment: Alignment(
                  layout[slot].$1 * 2 - 1,
                  layout[slot].$2 * 2 - 1,
                ),
                child: _PlayerNode(
                  position: positions[slot],
                  player: byId[lineup[slot]],
                  onTap: () => onTapSlot(slot),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PlayerNode extends StatelessWidget {
  const _PlayerNode({
    required this.position,
    required this.player,
    required this.onTap,
  });

  final PlayerPosition position;
  final Player? player;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final surname = player == null
        ? position.label
        : player!.name.split(' ').last;
    return GestureDetector(
      onTap: onTap,
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
                color: player == null
                    ? AppColors.outlineVariant
                    : AppColors.primary,
                width: 2,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              player == null ? '+' : '${player!.overall}',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.8),
              borderRadius: AppRadii.smAll,
              border: Border.all(color: AppColors.outlineVariant),
            ),
            child: Text(
              surname.toUpperCase(),
              style: AppTypography.labelSmall.copyWith(fontSize: 9),
            ),
          ),
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
    return ListTile(
      dense: true,
      leading: SizedBox(width: 40, child: TacticalChip(player.position.label)),
      title: Text(player.name, style: AppTypography.bodyMedium),
      subtitle: Text(
        player.position.roleName,
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),
      trailing: Text('${player.overall}', style: AppTypography.labelMedium),
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
