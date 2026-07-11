import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// Everything the round-results screen needs: the grouped results plus the
/// nation lookup and which nation is the player's.
typedef _RoundView = ({
  RoundResults? results,
  Map<int, Nation> nations,
  int playerNationId,
});

final AutoDisposeFutureProviderFamily<_RoundView?, int> _roundResultsProvider =
    FutureProvider.autoDispose.family<_RoundView?, int>((ref, careerId) async {
  final career = await ref.watch(careerRepositoryProvider).byId(careerId);
  if (career == null) return null;
  final results = await ref
      .watch(competitionRepositoryProvider)
      .lastRoundResults(careerId, career.nationId);
  final nations = {
    for (final n in await ref.watch(nationRepositoryProvider).all()) n.id: n,
  };
  return (
    results: results,
    nations: nations,
    playerNationId: career.nationId,
  );
});

/// Shown after the player finishes a group-stage match: the rest of that
/// round's results, grouped by group, with the live standings. Continues to the
/// hub.
class RoundResultsScreen extends ConsumerWidget {
  const RoundResultsScreen({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewAsync = ref.watch(_roundResultsProvider(careerId));
    void toHub() => context.go('${Routes.hub}?careerId=$careerId');

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'ROUND RESULTS',
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: viewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load results.\n$e')),
        data: (view) {
          final results = view?.results;
          final hasContent = results != null &&
              (results.groups.isNotEmpty ||
                  results.knockoutFixtures.isNotEmpty);
          if (view == null || results == null || !hasContent) {
            // Nothing to show (e.g. a friendly) — go on.
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: PrimaryButton(
                  label: 'Continue',
                  icon: Icons.check_rounded,
                  onPressed: toHub,
                ),
              ),
            );
          }
          String code(int id) => view.nations[id]?.code ?? '??';
          String name(int id) => view.nations[id]?.name ?? '—';
          final isKnockout = results.knockoutFixtures.isNotEmpty;

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            children: [
              Text(
                results.competition.toUpperCase(),
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
              Text(
                isKnockout
                    ? (results.stage ?? 'Knockout').toUpperCase()
                    : 'MATCHDAY ${results.matchday}',
                style: AppTypography.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.md),
              if (isKnockout)
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final f in results.knockoutFixtures)
                        _ResultRow(
                          fixture: f,
                          playerNationId: view.playerNationId,
                          code: code,
                        ),
                    ],
                  ),
                )
              else
                for (final g in results.groups)
                  _GroupBlock(
                    group: g,
                    playerNationId: view.playerNationId,
                    code: code,
                    name: name,
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
            label: 'Continue',
            icon: Icons.check_rounded,
            onPressed: toHub,
          ),
        ),
      ),
    );
  }
}

class _GroupBlock extends StatelessWidget {
  const _GroupBlock({
    required this.group,
    required this.playerNationId,
    required this.code,
    required this.name,
  });

  final RoundResultGroup group;
  final int playerNationId;
  final String Function(int) code;
  final String Function(int) name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GROUP ${group.name}',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            // This matchday's scores.
            for (final f in group.fixtures)
              _ResultRow(
                fixture: f,
                playerNationId: playerNationId,
                code: code,
              ),
            const Divider(height: AppSpacing.md),
            // Standings snapshot (top spots advance).
            for (var i = 0; i < group.standings.length; i++)
              _StandingRow(
                pos: i + 1,
                standing: group.standings[i],
                isPlayer: group.standings[i].nationId == playerNationId,
                name: name,
                code: code,
              ),
          ],
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.fixture,
    required this.playerNationId,
    required this.code,
  });

  final Fixture fixture;
  final int playerNationId;
  final String Function(int) code;

  @override
  Widget build(BuildContext context) {
    final isPlayer = fixture.homeNationId == playerNationId ||
        fixture.awayNationId == playerNationId;
    final style = AppTypography.bodySmall.copyWith(
      fontWeight: isPlayer ? FontWeight.w700 : FontWeight.w400,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              code(fixture.homeNationId),
              textAlign: TextAlign.end,
              style: style,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: AppRadii.smAll,
            ),
            child: Text(
              '${fixture.homeScore} - ${fixture.awayScore}',
              style: AppTypography.labelMedium,
            ),
          ),
          Expanded(child: Text(code(fixture.awayNationId), style: style)),
        ],
      ),
    );
  }
}

class _StandingRow extends StatelessWidget {
  const _StandingRow({
    required this.pos,
    required this.standing,
    required this.isPlayer,
    required this.name,
    required this.code,
  });

  final int pos;
  final GroupStanding standing;
  final bool isPlayer;
  final String Function(int) name;
  final String Function(int) code;

  @override
  Widget build(BuildContext context) {
    final advancing = pos <= 2;
    return Container(
      decoration: BoxDecoration(
        color: isPlayer ? AppColors.surfaceContainerHigh : null,
        border: Border(
          left: BorderSide(
            color: advancing ? AppColors.positive : Colors.transparent,
            width: 3,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
      child: Row(
        children: [
          SizedBox(
            width: 16,
            child: Text(
              '$pos',
              style: AppTypography.labelSmall.copyWith(
                color: advancing
                    ? AppColors.positive
                    : AppColors.onSurfaceVariant,
              ),
            ),
          ),
          FlagDisc(code(standing.nationId), size: 18),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              name(standing.nationId),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySmall.copyWith(
                fontWeight: isPlayer ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ),
          SizedBox(
            width: 28,
            child: Text(
              '${standing.played}',
              textAlign: TextAlign.center,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          SizedBox(
            width: 28,
            child: Text(
              '${standing.points}',
              textAlign: TextAlign.center,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
