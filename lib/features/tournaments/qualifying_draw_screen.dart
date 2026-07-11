import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/tournaments/qualifying_draw_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// A static presentation of a qualifying draw: the seeding pots and the drawn
/// groups for the player's confederation (not animated — just the result).
/// Viewing it marks the draw watched, so it fires as a timeline event once.
class QualifyingDrawScreen extends ConsumerStatefulWidget {
  const QualifyingDrawScreen({
    required this.careerId,
    required this.worldCup,
    super.key,
  });

  final int careerId;
  final bool worldCup;

  @override
  ConsumerState<QualifyingDrawScreen> createState() =>
      _QualifyingDrawScreenState();
}

class _QualifyingDrawScreenState extends ConsumerState<QualifyingDrawScreen> {
  bool _marked = false;

  @override
  Widget build(BuildContext context) {
    final careerId = widget.careerId;
    final worldCup = widget.worldCup;
    final dataAsync = ref.watch(
      qualifyingDrawProvider((careerId: careerId, worldCup: worldCup)),
    );

    // Record that this draw has now been seen (once) so the hub stops surfacing
    // it as a pending event — after the frame, to avoid mutating during build.
    // nextEventProvider auto-disposes, so it re-reads this on returning to hub.
    final data = dataAsync.valueOrNull;
    if (data != null && !_marked) {
      _marked = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(
          ref
              .read(competitionRepositoryProvider)
              .markDrawWatched(careerId, data.cycle, data.watchedKind),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.canPop()
              ? context.pop()
              : context.go('${Routes.hub}?careerId=$careerId'),
        ),
        title: Text(
          worldCup ? 'WC QUALIFYING DRAW' : 'QUALIFYING DRAW',
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load draw.\n$e')),
        data: (data) {
          if (data == null) {
            return const Center(child: Text('No qualifying draw.'));
          }
          String code(int id) => data.nations[id]?.code ?? '??';
          String name(int id) => data.nations[id]?.name ?? '—';
          final potCount = data.groups.fold(
            0,
            (m, g) => g.nationIds.length > m ? g.nationIds.length : m,
          );

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            children: [
              Text(data.title, style: AppTypography.headlineMedium),
              const SizedBox(height: AppSpacing.md),

              // Seeding pots.
              Text(
                'SEEDING POTS',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              for (var pot = 1; pot <= potCount; pot++)
                _PotChipRow(
                  pot: pot,
                  ids: [
                    for (final e in data.potByNation.entries)
                      if (e.value == pot) e.key,
                  ]..sort((a, b) =>
                      (data.nations[a]?.ranking ?? 9999)
                          .compareTo(data.nations[b]?.ranking ?? 9999)),
                  code: code,
                  playerId: data.playerNationId,
                ),
              const SizedBox(height: AppSpacing.lg),

              // Drawn groups.
              Text(
                'GROUPS',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              for (final g in data.groups)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'GROUP ${g.name}',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        for (final id in g.nationIds)
                          _TeamRow(
                            code: code(id),
                            name: name(id),
                            isPlayer: id == data.playerNationId,
                          ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: AppSpacing.xl),
            ],
          );
        },
      ),
    );
  }
}

class _PotChipRow extends StatelessWidget {
  const _PotChipRow({
    required this.pot,
    required this.ids,
    required this.code,
    required this.playerId,
  });

  final int pot;
  final List<int> ids;
  final String Function(int) code;
  final int playerId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 42,
            child: Text(
              'POT $pot',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                for (final id in ids)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: id == playerId
                          ? AppColors.secondaryContainer
                          : AppColors.surfaceContainer,
                      borderRadius: AppRadii.smAll,
                      border: Border.all(
                        color: id == playerId
                            ? AppColors.primary
                            : AppColors.outlineVariant,
                      ),
                    ),
                    child: Text(
                      code(id),
                      style: AppTypography.labelSmall.copyWith(
                        color: id == playerId
                            ? AppColors.primary
                            : AppColors.onSurface,
                        fontWeight:
                            id == playerId ? FontWeight.w700 : FontWeight.w400,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TeamRow extends StatelessWidget {
  const _TeamRow({
    required this.code,
    required this.name,
    required this.isPlayer,
  });

  final String code;
  final String name;
  final bool isPlayer;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1),
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
      decoration: isPlayer
          ? const BoxDecoration(
              color: AppColors.secondaryContainer,
              borderRadius: AppRadii.smAll,
            )
          : null,
      child: Row(
        children: [
          FlagDisc(code, size: 20, highlighted: isPlayer),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySmall.copyWith(
                color: isPlayer ? AppColors.primary : AppColors.onSurface,
                fontWeight: isPlayer ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
