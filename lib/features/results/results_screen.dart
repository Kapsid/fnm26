import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/features/results/results_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// All matches across the confederation, grouped by matchday — the player's
/// fixtures are highlighted.
class ResultsScreen extends ConsumerWidget {
  const ResultsScreen({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(resultsProvider(careerId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.go('${Routes.hub}?careerId=$careerId'),
        ),
        title: Text(
          'RESULTS & FIXTURES',
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load results.\n$e')),
        data: (data) {
          if (data == null) return const Center(child: Text('No fixtures.'));
          String code(int id) => data.nations[id]?.code ?? '??';

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            children: [
              for (final md in data.matchdays) ...[
                Padding(
                  padding: const EdgeInsets.only(
                    top: AppSpacing.md,
                    bottom: AppSpacing.sm,
                  ),
                  child: Text(
                    'MATCHDAY $md',
                    style: AppTypography.labelMedium
                        .copyWith(color: AppColors.primary),
                  ),
                ),
                AppCard(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.xs,
                    horizontal: AppSpacing.sm,
                  ),
                  child: Column(
                    children: [
                      for (final f in data.byMatchday[md]!)
                        _ResultRow(
                          fixture: f,
                          code: code,
                          isPlayer: f.homeNationId == data.playerNationId ||
                              f.awayNationId == data.playerNationId,
                        ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
            ],
          );
        },
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.fixture,
    required this.code,
    required this.isPlayer,
  });

  final Fixture fixture;
  final String Function(int) code;
  final bool isPlayer;

  @override
  Widget build(BuildContext context) {
    final middle = fixture.hasResult
        ? '${fixture.homeScore} - ${fixture.awayScore}'
        : DateFormat('d MMM').format(fixture.date);

    return Container(
      color: isPlayer ? AppColors.surfaceContainerHigh : null,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(code(fixture.homeNationId),
                    style: AppTypography.bodySmall),
                const SizedBox(width: AppSpacing.sm),
                FlagDisc(code(fixture.homeNationId), size: 22),
              ],
            ),
          ),
          SizedBox(
            width: 64,
            child: Text(
              middle,
              textAlign: TextAlign.center,
              style: fixture.hasResult
                  ? AppTypography.labelMedium
                  : AppTypography.labelSmall
                      .copyWith(color: AppColors.onSurfaceVariant),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                FlagDisc(code(fixture.awayNationId), size: 22),
                const SizedBox(width: AppSpacing.sm),
                Text(code(fixture.awayNationId),
                    style: AppTypography.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
