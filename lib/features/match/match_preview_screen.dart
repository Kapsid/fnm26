import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/tactics/position_fit.dart';
import 'package:fnm/features/hub/hub_screen.dart' show matchStageLabel;
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/records/head_to_head_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// Shown before a match kicks off: the fixture, your starting XI (with each
/// player's slot and any out-of-position flag), and the chance to adjust the
/// lineup before playing. "Kick off" starts the live match.
class MatchPreviewScreen extends ConsumerWidget {
  const MatchPreviewScreen({required this.careerId, super.key});

  final int careerId;

  Future<void> _openTactics(BuildContext context, WidgetRef ref) async {
    // Push (don't replace) so returning lands back on the preview, then refresh
    // it to pick up the new lineup.
    await context.push('${Routes.tactics}?careerId=$careerId');
    ref.invalidate(matchPreviewProvider(careerId));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final previewAsync = ref.watch(matchPreviewProvider(careerId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.go('${Routes.hub}?careerId=$careerId'),
        ),
        title: Text(
          l10n.matchPreviewTitle,
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
          String name(int id) => preview.nations[id]?.name ?? 'Unknown';
          final team =
              preview.playerIsHome ? preview.homeTeam : preview.awayTeam;
          final positions = team.formation.positions;
          final myNationId =
              preview.playerIsHome ? f.homeNationId : f.awayNationId;
          final oppNationId =
              preview.playerIsHome ? f.awayNationId : f.homeNationId;

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
              _H2HCard(
                careerId: careerId,
                myNationId: myNationId,
                oppNationId: oppNationId,
                oppName: name(oppNationId),
                oppCode: code(oppNationId),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Text(
                    l10n.matchYourXi,
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
              const SizedBox(height: AppSpacing.xl),
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.marginMobile),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: PrimaryButton(
                  label: l10n.matchKickOff,
                  icon: Icons.sports_soccer,
                  onPressed: () =>
                      context.go('${Routes.match}?careerId=$careerId'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _openTactics(context, ref),
                  icon: const Icon(Icons.tune, size: 18),
                  label: Text(l10n.matchTactics),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.outlineVariant),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _H2HCard extends ConsumerWidget {
  const _H2HCard({
    required this.careerId,
    required this.myNationId,
    required this.oppNationId,
    required this.oppName,
    required this.oppCode,
  });

  final int careerId;
  final int myNationId;
  final int oppNationId;
  final String oppName;
  final String oppCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(headToHeadProvider(
      (careerId: careerId, nationA: myNationId, nationB: oppNationId),
    ));
    return async.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (h) {
        final edge = h.played == 0
            ? 'First-ever meeting'
            : h.winsA > h.winsB
                ? 'You lead the head-to-head'
                : h.winsA < h.winsB
                    ? '$oppName have the edge'
                    : 'Honours even';
        return AppCard(
          onTap: () => context.push(
            '${Routes.h2hMeetings}?careerId=$careerId'
            '&a=$myNationId&b=$oppNationId',
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.compare_arrows,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    AppLocalizations.of(context).matchHeadToHead,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    h.played == 0 ? '—' : '${h.played} met',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              if (h.played > 0) ...[
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _Tally(
                      value: h.winsA,
                      label: 'Won',
                      color: AppColors.positive,
                    ),
                    _Tally(
                      value: h.draws,
                      label: 'Drawn',
                      color: AppColors.onSurfaceVariant,
                    ),
                    _Tally(
                      value: h.winsB,
                      label: 'Lost',
                      color: AppColors.error,
                    ),
                    _Tally(
                      value: h.goalsA,
                      label: 'GF',
                      color: AppColors.onSurface,
                    ),
                    _Tally(
                      value: h.goalsB,
                      label: 'GA',
                      color: AppColors.onSurface,
                    ),
                  ],
                ),
              ],
              const SizedBox(height: AppSpacing.sm),
              Text(
                edge,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Tally extends StatelessWidget {
  const _Tally({
    required this.value,
    required this.label,
    required this.color,
  });

  final int value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$value',
          style: AppTypography.titleMedium.copyWith(color: color),
        ),
        Text(
          label.toUpperCase(),
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
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
    // The rating as it actually counts in this slot — docked when out of
    // position — so the preview matches the number the engine uses at kick-off.
    final effective = PositionFit.effectiveOverall(player, slot);
    final penalised = effective < player.overall;
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
          if (penalised)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Text(
                '${player.overall}→',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
          Text(
            '$effective',
            style: AppTypography.labelMedium.copyWith(
              color: penalised ? AppColors.error : AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
