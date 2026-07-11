import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

typedef _PlayerView = ({Player? player, Nation? nation});

final AutoDisposeFutureProviderFamily<_PlayerView, int> _playerDetailProvider =
    FutureProvider.autoDispose.family<_PlayerView, int>((ref, playerId) async {
  final player = await ref.watch(playerRepositoryProvider).byId(playerId);
  Nation? nation;
  if (player != null) {
    final nations = await ref.watch(nationRepositoryProvider).all();
    nation = nations.where((n) => n.id == player.nationId).firstOrNull;
  }
  return (player: player, nation: nation);
});

/// A player's detail card: identity, club/value, and the ten attributes. Base
/// data for now — reachable from anywhere a player is listed.
class PlayerDetailScreen extends ConsumerWidget {
  const PlayerDetailScreen({
    required this.careerId,
    required this.playerId,
    super.key,
  });

  final int careerId;
  final int playerId;

  static String money(int euros) {
    if (euros >= 1000000) return '€${(euros / 1000000).toStringAsFixed(1)}M';
    if (euros >= 1000) return '€${(euros / 1000).round()}K';
    return '€$euros';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewAsync = ref.watch(_playerDetailProvider(playerId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.canPop()
              ? context.pop()
              : Navigator.of(context).maybePop(),
        ),
        title: Text(
          'PLAYER',
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: viewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load player.\n$e')),
        data: (view) {
          final p = view.player;
          if (p == null) return const Center(child: Text('Player not found.'));
          final a = p.attributes;

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            children: [
              AppCard(
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary, width: 2),
                      ),
                      child: Text(
                        '${p.overall}',
                        style: AppTypography.headlineMedium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.name, style: AppTypography.headlineMedium),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              TacticalChip(p.position.label),
                              const SizedBox(width: AppSpacing.sm),
                              if (view.nation != null)
                                FlagDisc(view.nation!.code, size: 18),
                              const SizedBox(width: AppSpacing.xs),
                              Flexible(
                                child: Text(
                                  view.nation?.name ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppCard(
                child: Column(
                  children: [
                    _fact('Club', p.club),
                    _fact('Position', p.position.roleName),
                    _fact('Age', '${p.age}'),
                    _fact('Value', money(p.value)),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'ATTRIBUTES',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              for (final s in <(String, int)>[
                ('Pace', a.pace),
                ('Shooting', a.shooting),
                ('Passing', a.passing),
                ('Dribbling', a.dribbling),
                ('Tackling', a.tackling),
                ('Positioning', a.positioning),
                ('Composure', a.composure),
                ('Decisions', a.decisions),
                ('Stamina', a.stamina),
                ('Strength', a.strength),
              ])
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: StatBar(label: s.$1, value: s.$2),
                ),
              const SizedBox(height: AppSpacing.xl),
            ],
          );
        },
      ),
    );
  }

  Widget _fact(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            Text(
              label.toUpperCase(),
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            Text(value, style: AppTypography.bodyMedium),
          ],
        ),
      );
}
