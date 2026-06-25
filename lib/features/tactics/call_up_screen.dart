import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// Call-ups: choose which of the nation's eligible players are in the squad
/// for this save. Only called-up players can be picked in the XI or brought on
/// as substitutes. The squad must keep at least [kMinSquadSize] players.
class CallUpScreen extends ConsumerStatefulWidget {
  const CallUpScreen({required this.careerId, super.key});

  final int careerId;

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

  @override
  Widget build(BuildContext context) {
    final dataAsync = ref.watch(squadDataProvider(widget.careerId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () =>
              context.go('${Routes.tactics}?careerId=${widget.careerId}'),
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
          final selected = _selected ??= {...data.callUps};
          final count = selected.length;
          final ok = count >= kMinSquadSize;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.marginMobile),
                child: Row(
                  children: [
                    Text(
                      'SQUAD · $count',
                      style: AppTypography.labelMedium.copyWith(
                        color: ok ? AppColors.onSurface : AppColors.error,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      ok ? 'Min $kMinSquadSize' : 'At least $kMinSquadSize',
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
                    onPressed: ok
                        ? () async {
                            await ref
                                .read(squadServiceProvider)
                                .setCallUps(widget.careerId, selected);
                            if (context.mounted) {
                              context.go(
                                '${Routes.tactics}?careerId=${widget.careerId}',
                              );
                            }
                          }
                        : null,
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
                onChanged: (on) => setState(() {
                  if (on) {
                    selected.add(p.id);
                  } else {
                    selected.remove(p.id);
                  }
                }),
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
  });

  final Player player;
  final bool selected;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      onTap: () => onChanged(!selected),
      leading: SizedBox(width: 40, child: TacticalChip(player.position.label)),
      title: Text(player.name, style: AppTypography.bodyMedium),
      subtitle: Text(
        '${player.position.roleName} · Age ${player.age}',
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
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
}
