import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/features/hub/hub_screen.dart' show matchStageLabel;
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// Shown before a match kicks off: the fixture, your starting XI (with each
/// player's slot and any out-of-position flag), and the chance to adjust the
/// lineup before playing. "Kick off" starts the live match.
class MatchPreviewScreen extends ConsumerWidget {
  const MatchPreviewScreen({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final previewAsync = ref.watch(matchPreviewProvider(careerId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.go('${Routes.hub}?careerId=$careerId'),
        ),
        title: Text(
          'MATCH PREVIEW',
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: previewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load match.\n$e')),
        data: (preview) {
          if (preview == null) {
            return const Center(child: Text('No upcoming match.'));
          }
          final f = preview.fixture;
          String code(int id) => preview.nations[id]?.code ?? '??';
          final team =
              preview.playerIsHome ? preview.homeTeam : preview.awayTeam;
          final positions = team.formation.positions;

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            children: [
              Center(
                child: Text(
                  matchStageLabel(f),
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _Side(code: code(f.homeNationId)),
                  Column(
                    children: [
                      const Text('VS', style: AppTypography.labelLarge),
                      const SizedBox(height: 2),
                      Text(
                        DateFormat('EEE d MMM').format(f.date).toUpperCase(),
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  _Side(code: code(f.awayNationId)),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Text(
                    'YOUR XI',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    team.formation.label,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              AppCard(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.sm,
                  horizontal: AppSpacing.md,
                ),
                child: Column(
                  children: [
                    for (var i = 0; i < team.xi.length; i++)
                      _XiRow(
                        player: team.xi[i],
                        slot: i < positions.length
                            ? positions[i]
                            : team.xi[i].position,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              OutlinedButton.icon(
                onPressed: () =>
                    context.go('${Routes.tactics}?careerId=$careerId'),
                icon: const Icon(Icons.tune, size: 18),
                label: const Text('Adjust lineup & tactics'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(44),
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.outlineVariant),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.marginMobile),
          child: PrimaryButton(
            label: 'Kick off',
            icon: Icons.sports_soccer,
            onPressed: () => context.go('${Routes.match}?careerId=$careerId'),
          ),
        ),
      ),
    );
  }
}

class _Side extends StatelessWidget {
  const _Side({required this.code});
  final String code;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FlagDisc(code, size: 48),
        const SizedBox(height: AppSpacing.xs),
        Text(code, style: AppTypography.labelMedium),
      ],
    );
  }
}

/// One starting-XI row: the slot the player fills, their name and rating, with
/// a colour cue when they're fielded out of position.
class _XiRow extends StatelessWidget {
  const _XiRow({required this.player, required this.slot});

  final Player player;
  final PlayerPosition slot;

  @override
  Widget build(BuildContext context) {
    final Color fit;
    if (player.position == slot) {
      fit = AppColors.positive;
    } else if (player.category == slot.category) {
      fit = AppColors.primary;
    } else {
      fit = AppColors.error;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 34,
            child: Text(
              slot.label,
              style: AppTypography.labelSmall.copyWith(
                color: fit,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              player.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodyMedium,
            ),
          ),
          Text(
            '${player.overall}',
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
