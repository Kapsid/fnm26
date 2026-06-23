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

/// The player's own matches (qualifiers + finals), in date order.
class ResultsScreen extends ConsumerWidget {
  const ResultsScreen({required this.careerId, super.key});

  final int careerId;

  static String _stage(String? round) => switch (round) {
        null => 'QUALIFIER',
        'GROUP' => 'FINALS GROUP',
        'R16' => 'ROUND OF 16',
        'QF' => 'QUARTER-FINAL',
        'SF' => 'SEMI-FINAL',
        '3RD' => 'THIRD PLACE',
        'FINAL' => 'FINAL',
        _ => round,
      };

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
          'MY MATCHES',
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load results.\n$e')),
        data: (data) {
          if (data == null || data.fixtures.isEmpty) {
            return const Center(child: Text('No fixtures.'));
          }
          String code(int id) => data.nations[id]?.code ?? '??';

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            children: [
              for (final f in data.fixtures)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: AppCard(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                      horizontal: AppSpacing.md,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              _stage(f.round),
                              style: AppTypography.labelSmall
                                  .copyWith(color: AppColors.primary),
                            ),
                            const Spacer(),
                            Text(
                              DateFormat('d MMM yyyy').format(f.date),
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        _ResultRow(fixture: f, code: code, isPlayer: false),
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
        : 'vs';

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
