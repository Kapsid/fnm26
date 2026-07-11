import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// Call-ups: choose which of the nation's eligible players are in the squad
/// for this save. Only called-up players can be picked in the XI or brought on
/// as substitutes. The squad must keep at least [kMinSquadSize] players.
class CallUpScreen extends ConsumerStatefulWidget {
  const CallUpScreen({
    required this.careerId,
    this.eventKind,
    this.eventCycle,
    super.key,
  });

  final int careerId;

  /// When launched as a timeline event, confirming the squad records this
  /// call-up window as done (so it fires only once) and returns to the hub.
  final String? eventKind;
  final int? eventCycle;

  @override
  ConsumerState<CallUpScreen> createState() => _CallUpScreenState();
}

class _CallUpScreenState extends ConsumerState<CallUpScreen> {
  Set<int>? _selected;

  static const List<PositionCategory> _order = [
    PositionCategory.goalkeeper,
    PositionCategory.defender,
    PositionCategory.midfielder,
    PositionCategory.forward,
  ];

  static String _heading(PositionCategory c) => switch (c) {
        PositionCategory.goalkeeper => 'GOALKEEPERS',
        PositionCategory.defender => 'DEFENDERS',
        PositionCategory.midfielder => 'MIDFIELDERS',
        PositionCategory.forward => 'FORWARDS',
      };

  /// The starting selection: restore the last call-up if there is one, else
  /// preselect the best [kMaxSquadSize] by rating. Never exceeds the cap.
  Set<int> _initialSquad(List<Player> pool, Iterable<int> current) {
    final currentSet = current.toSet();
    final source = (currentSet.isNotEmpty
        ? pool.where((p) => currentSet.contains(p.id)).toList()
        : [...pool])
      ..sort((a, b) => b.overall.compareTo(a.overall));
    return source.take(kMaxSquadSize).map((p) => p.id).toSet();
  }

  /// Back to the hub when this was a timeline event, else back to tactics.
  String get _exitRoute => widget.eventKind != null
      ? '${Routes.hub}?careerId=${widget.careerId}'
      : '${Routes.tactics}?careerId=${widget.careerId}';

  Future<void> _confirm(Set<int> selected) async {
    await ref.read(squadServiceProvider).setCallUps(widget.careerId, selected);
    // A timeline call-up records itself done so the event fires only once.
    final kind = widget.eventKind;
    final cycle = widget.eventCycle;
    if (kind != null && cycle != null) {
      await ref
          .read(competitionRepositoryProvider)
          .markDrawWatched(widget.careerId, cycle, kind);
    }
    if (mounted) context.go(_exitRoute);
  }

  @override
  Widget build(BuildContext context) {
    final dataAsync = ref.watch(squadDataProvider(widget.careerId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.go(_exitRoute),
        ),
        title: Text(
          'CALL-UPS',
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load squad.\n$e')),
        data: (data) {
          if (data == null) return const Center(child: Text('No squad.'));
          final selected = _selected ??= _initialSquad(data.pool, data.callUps);
          final count = selected.length;
          final ok = count >= kMinSquadSize && count <= kMaxSquadSize;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.marginMobile),
                child: Row(
                  children: [
                    Text(
                      'SQUAD · $count/$kMaxSquadSize',
                      style: AppTypography.labelMedium.copyWith(
                        color: ok ? AppColors.onSurface : AppColors.error,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Min $kMinSquadSize · Max $kMaxSquadSize',
                      style: AppTypography.labelSmall.copyWith(
                        color: ok
                            ? AppColors.onSurfaceVariant
                            : AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.marginMobile,
                  ),
                  children: [
                    for (final category in _order)
                      ..._section(category, data.pool, selected),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.marginMobile),
                  child: PrimaryButton(
                    label: 'Confirm squad',
                    icon: Icons.check_rounded,
                    onPressed: ok ? () => _confirm(selected) : null,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _section(
    PositionCategory category,
    List<Player> pool,
    Set<int> selected,
  ) {
    final players = pool.where((p) => p.position.category == category).toList()
      ..sort((a, b) => b.overall.compareTo(a.overall));
    if (players.isEmpty) return const [];
    return [
      const SizedBox(height: AppSpacing.sm),
      Text(_heading(category), style: AppTypography.labelMedium),
      const SizedBox(height: AppSpacing.sm),
      AppCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            for (final p in players)
              _PlayerToggle(
                player: p,
                selected: selected.contains(p.id),
                onChanged: (on) {
                  if (on && selected.length >= kMaxSquadSize) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        const SnackBar(
                          content: Text('Squad full — max $kMaxSquadSize'),
                        ),
                      );
                    return;
                  }
                  setState(() {
                    if (on) {
                      selected.add(p.id);
                    } else {
                      selected.remove(p.id);
                    }
                  });
                },
                onInfo: () => context.push(
                  '${Routes.player}?careerId=${widget.careerId}'
                  '&playerId=${p.id}',
                ),
              ),
          ],
        ),
      ),
      const SizedBox(height: AppSpacing.md),
    ];
  }
}

class _PlayerToggle extends StatelessWidget {
  const _PlayerToggle({
    required this.player,
    required this.selected,
    required this.onChanged,
    required this.onInfo,
  });

  final Player player;
  final bool selected;
  final ValueChanged<bool> onChanged;
  final VoidCallback onInfo;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      onTap: () => onChanged(!selected),
      leading: SizedBox(width: 40, child: TacticalChip(player.position.label)),
      title: Text(player.name, style: AppTypography.bodyMedium),
      subtitle: Text(
        '${player.club} · Age ${player.age} · ${_money(player.value)}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(
              Icons.info_outline,
              size: 20,
              color: AppColors.onSurfaceVariant,
            ),
            onPressed: onInfo,
          ),
          Text('${player.overall}', style: AppTypography.labelMedium),
          const SizedBox(width: AppSpacing.sm),
          Icon(
            selected ? Icons.check_circle : Icons.circle_outlined,
            color: selected ? AppColors.primary : AppColors.outlineVariant,
            size: 22,
          ),
        ],
      ),
    );
  }

  /// Formats a euro value compactly, e.g. €12.5M / €650K / €0.
  static String _money(int euros) {
    if (euros >= 1000000) return '€${(euros / 1000000).toStringAsFixed(1)}M';
    if (euros >= 1000) return '€${(euros / 1000).round()}K';
    return '€$euros';
  }
}
