import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactic_preset.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/tactics/position_fit.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_role.dart';
import 'package:fnm/features/tactics/player_roles_providers.dart';
import 'package:fnm/features/tactics/tactic_preset_providers.dart';
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
              icon: const Icon(Icons.bookmark_border, color: AppColors.primary),
              tooltip: 'Tactic presets',
              onPressed: data == null
                  ? null
                  : () => _openPresets(context, ref, data.tactic),
            ),
            orElse: () => const SizedBox.shrink(),
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
          final roles =
              ref.watch(playerRolesProvider(careerId)).valueOrNull ??
                  const <int, PlayerRole>{};
          final startingIds = tactic.lineup.whereType<int>().toSet();
          final subs =
              data.pool.where((p) => !startingIds.contains(p.id)).toList()
                ..sort((a, b) => b.overall.compareTo(a.overall));
          final absentIds = {for (final p in data.unavailable) p.id};
          // Injuries (orange) vs suspensions (red) — split so the pitch and the
          // lists can show the right badge for each.
          final injuredIds = {
            for (final p in data.unavailable)
              if ((data.absences[p.id]?.injuryMatches ?? 0) > 0) p.id,
          };
          final outStarters = data.unavailableStarters;

          return ListView(
            children: [
              // Starters who are banned/injured block the next match: name
              // them (with the reason) right here, or the forced "reshape your
              // XI" event reads as an unexplained dead end.
              if (outStarters.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.marginMobile,
                    AppSpacing.sm,
                    AppSpacing.marginMobile,
                    0,
                  ),
                  child: AppCard(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.personal_injury_outlined,
                          color: AppColors.error,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'REPLACE ${outStarters.length} '
                                'STARTER${outStarters.length == 1 ? '' : 'S'}',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.error,
                                ),
                              ),
                              const SizedBox(height: 2),
                              for (final p in outStarters)
                                Text(
                                  '${p.name} — '
                                  '${data.absences[p.id]?.reason ?? 'Out'}',
                                  style: AppTypography.bodySmall,
                                ),
                              const SizedBox(height: 2),
                              Text(
                                'Tap their spot on the pitch to pick a '
                                'replacement.',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              AspectRatio(
                aspectRatio: 3 / 4,
                child: TacticsPitch(
                  injuredIds: injuredIds,
                  formation: tactic.formation,
                  instructions: tactic.instructions,
                  lineup: tactic.lineup,
                  byId: data.byId,
                  absentIds: absentIds,
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
                    const Text('PLAYER ROLES', style: AppTypography.labelMedium),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Give a player a job — a poacher, a playmaker, a target '
                      'man. Shapes who scores, who creates and your set-piece '
                      'threat.',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    for (final id in tactic.lineup.whereType<int>())
                      if (data.byId[id] case final p?)
                        _RoleRow(
                          player: p,
                          role: roles[id] ?? PlayerRole.none,
                          onTap: () => _pickRole(context, ref, p),
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
                    // Banned/injured squad members, visible with their reason
                    // rather than silently missing from the lists above.
                    if (data.unavailable.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'UNAVAILABLE · ${data.unavailable.length}',
                        style: AppTypography.labelMedium,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      AppCard(
                        padding: EdgeInsets.zero,
                        child: Column(
                          children: [
                            for (final p in data.unavailable)
                              ListTile(
                                dense: true,
                                enabled: false,
                                leading: SizedBox(
                                  width: 40,
                                  child: TacticalChip(p.position.label),
                                ),
                                title: Text(
                                  p.name,
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                                trailing: () {
                                  final inj = injuredIds.contains(p.id);
                                  final c = inj
                                      ? AppColors.warning
                                      : AppColors.error;
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: c.withValues(alpha: 0.16),
                                      borderRadius: AppRadii.smAll,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          inj
                                              ? Icons.personal_injury
                                              : Icons.gavel_rounded,
                                          size: 13,
                                          color: c,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          data.absences[p.id]?.reason ?? 'Out',
                                          style: AppTypography.labelSmall
                                              .copyWith(color: c),
                                        ),
                                      ],
                                    ),
                                  );
                                }(),
                              ),
                          ],
                        ),
                      ),
                    ],
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

  /// Opens the role picker for [player] — only the roles that suit their
  /// position, plus "No role".
  Future<void> _pickRole(
    BuildContext context,
    WidgetRef ref,
    Player player,
  ) async {
    final options = [
      for (final r in PlayerRole.values)
        if (r == PlayerRole.none ||
            switch (player.category) {
              PositionCategory.forward => r.forForwards,
              PositionCategory.midfielder => r.forMidfielders,
              PositionCategory.defender => r.forDefenders,
              PositionCategory.goalkeeper => false,
            })
          r,
    ];
    final picked = await showModalBottomSheet<PlayerRole>(
      context: context,
      backgroundColor: AppColors.surfaceContainerHigh,
      builder: (_) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(AppSpacing.marginMobile),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Text(
                'ROLE · ${player.name}',
                style: AppTypography.labelMedium
                    .copyWith(color: AppColors.primary),
              ),
            ),
            for (final r in options)
              ListTile(
                title: Text(r.label, style: AppTypography.bodyMedium),
                subtitle: Text(
                  r.blurb,
                  style: AppTypography.labelSmall
                      .copyWith(color: AppColors.onSurfaceVariant),
                ),
                onTap: () => Navigator.of(context).pop(r),
              ),
          ],
        ),
      ),
    );
    if (picked != null) {
      await ref
          .read(playerRolesStoreProvider)
          .setRole(careerId, player.id, picked);
    }
  }

  Future<void> _pickPlayer(
    BuildContext context,
    WidgetRef ref,
    TacticData data,
    int slot,
  ) async {
    final position = data.tactic.formation.positions[slot];
    final isKeeperSlot = position.category == PositionCategory.goalkeeper;
    // A goalkeeping slot is keeper-only; any other slot can be filled by any
    // outfield player, carrying the out-of-position penalty shown per row.
    var candidates = data.pool
        .where((p) => isKeeperSlot
            ? p.position.category == PositionCategory.goalkeeper
            : p.position.category != PositionCategory.goalkeeper)
        .toList()
      ..sort(PositionFit.bySlotFit(position));
    // Nobody available for a keeper slot (both keepers out): fall back to the
    // whole pool rather than a dead-end empty sheet — someone must go in goal.
    if (candidates.isEmpty) {
      candidates = [...data.pool]..sort(PositionFit.bySlotFit(position));
    }

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
              final eff = PositionFit.effectiveOverall(p, position);
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
                  eff < p.overall
                      ? '${p.position.roleName} · out of position'
                      : '${p.position.roleName} · Age ${p.age}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelSmall.copyWith(
                    color: eff < p.overall
                        ? AppColors.error
                        : AppColors.onSurfaceVariant,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (inXi) ...[
                      const TacticalChip('IN XI'),
                      const SizedBox(width: AppSpacing.sm),
                    ],
                    if (eff < p.overall)
                      Text(
                        '${p.overall}→',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    Text(
                      '$eff',
                      style: AppTypography.labelMedium.copyWith(
                        color: eff < p.overall ? AppColors.error : null,
                      ),
                    ),
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

  Future<void> _openPresets(
    BuildContext context,
    WidgetRef ref,
    Tactic tactic,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surfaceContainer,
      isScrollControlled: true,
      builder: (_) => _PresetsSheet(careerId: careerId, tactic: tactic),
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
    // Roomier than a plain sheet: a tall, scrollable panel so each instruction
    // has space to breathe and reads clearly.
    final maxHeight = MediaQuery.of(context).size.height * 0.85;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.lg + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // A small grab handle so the panel reads as a draggable sheet.
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                decoration: const BoxDecoration(
                  color: AppColors.outlineVariant,
                  borderRadius: AppRadii.smAll,
                ),
              ),
            ),
            Text(
              'TEAM INSTRUCTIONS',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Set how your side plays. Each dial nudges the whole team.',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      'Defensive line',
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
              ),
            ),
          ],
        ),
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
    // Each instruction sits in its own spaced-out block so the label, value and
    // end-points don't crowd the neighbouring dials.
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label, style: AppTypography.titleMedium),
              const Spacer(),
              Text(
                '$value',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 6,
            ),
            child: Slider(
              value: value.toDouble(),
              max: 100,
              divisions: 20,
              onChanged: (v) => onChanged(v.round()),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                low,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Text(
                high,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Save the current shape + instructions as a named preset, and apply or delete
/// any previously saved preset. Presets are reusable across every save.
class _PresetsSheet extends ConsumerStatefulWidget {
  const _PresetsSheet({required this.careerId, required this.tactic});

  final int careerId;
  final Tactic tactic;

  @override
  ConsumerState<_PresetsSheet> createState() => _PresetsSheetState();
}

class _PresetsSheetState extends ConsumerState<_PresetsSheet> {
  Future<void> _saveCurrent() async {
    // A dialog is the most reliable place to type on top of a bottom sheet —
    // the sheet's own text field kept losing the keyboard.
    final name = await showDialog<String>(
      context: context,
      builder: (_) => const _NamePresetDialog(),
    );
    if (name == null || name.trim().isEmpty) return;
    await ref.read(tacticPresetStoreProvider).save(
          widget.careerId,
          TacticPreset(
            name: name.trim(),
            formation: widget.tactic.formation,
            instructions: widget.tactic.instructions,
          ),
        );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Saved “${name.trim()}”')),
      );
    }
  }

  Future<void> _apply(TacticPreset preset) async {
    await ref.read(tacticServiceProvider).applyPreset(
          widget.careerId,
          preset.formation,
          preset.instructions,
        );
    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Applied “${preset.name}”')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final presetsAsync = ref.watch(tacticPresetsProvider(widget.careerId));
    final maxHeight = MediaQuery.of(context).size.height * 0.8;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.lg + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                decoration: const BoxDecoration(
                  color: AppColors.outlineVariant,
                  borderRadius: AppRadii.smAll,
                ),
              ),
            ),
            Text(
              'TACTIC PRESETS',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Save this shape and its instructions as a reusable style, or '
              'apply one you saved earlier.',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _saveCurrent,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Save current tactic'),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Flexible(
              child: presetsAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Could not load presets.\n$e'),
                data: (presets) {
                  if (presets.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.lg,
                      ),
                      child: Text(
                        'No presets yet. Tap “Save current tactic” to store '
                        'this setup as a reusable style.',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: presets.length,
                    itemBuilder: (context, i) {
                      final p = presets[i];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(
                          Icons.bookmark,
                          color: AppColors.primary,
                        ),
                        title: Text(p.name, style: AppTypography.bodyMedium),
                        subtitle: Text(
                          p.formation.label,
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: AppColors.onSurfaceVariant,
                          ),
                          onPressed: () => ref
                              .read(tacticPresetStoreProvider)
                              .delete(widget.careerId, p.name),
                        ),
                        onTap: () => _apply(p),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A small dialog to name a tactic preset — a plain dialog text field is the
/// most reliable place to type over a bottom sheet.
class _NamePresetDialog extends StatefulWidget {
  const _NamePresetDialog();

  @override
  State<_NamePresetDialog> createState() => _NamePresetDialogState();
}

class _NamePresetDialogState extends State<_NamePresetDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() => Navigator.of(context).pop(_controller.text);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Name this tactic'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _submit(),
        decoration: const InputDecoration(
          hintText: 'e.g. High press 4-3-3',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('Save'),
        ),
      ],
    );
  }
}

/// One player's role row in the tactics screen: position, name, and the role
/// they've been given (tap to change).
class _RoleRow extends StatelessWidget {
  const _RoleRow({
    required this.player,
    required this.role,
    required this.onTap,
  });

  final Player player;
  final PlayerRole role;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final assigned = role != PlayerRole.none;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            SizedBox(width: 36, child: TacticalChip(player.position.label)),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                player.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodyMedium,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              assigned ? role.label : 'Tap to assign',
              style: AppTypography.labelSmall.copyWith(
                color:
                    assigned ? AppColors.primary : AppColors.onSurfaceVariant,
                fontWeight: assigned ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 18,
              color: AppColors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
