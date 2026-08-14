import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/match_stage.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/features/results/results_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// The player's own matches (qualifiers + finals), in date order.
class ResultsScreen extends ConsumerWidget {
  const ResultsScreen({required this.careerId, super.key});

  final int careerId;

  /// Groups fixtures by competition, ordering the groups so the most currently
  /// relevant one (the soonest still-to-play) comes first; fully-played
  /// competitions fall to the bottom, most-recent first.
  static List<MapEntry<String, List<Fixture>>> _grouped(
    AppLocalizations l,
    List<Fixture> all,
  ) {
    final groups = <String, List<Fixture>>{};
    for (final f in all) {
      (groups[MatchStage.category(l, f.round)] ??= []).add(f);
    }
    int keyFor(List<Fixture> fx) {
      final upcoming = fx.where((f) => !f.played).map((f) => f.date);
      if (upcoming.isNotEmpty) {
        // Soonest upcoming first (small, positive sort key).
        return upcoming
            .reduce((a, b) => a.isBefore(b) ? a : b)
            .millisecondsSinceEpoch;
      }
      // All played: push below any live competition, most recent first.
      final last = fx.map((f) => f.date).reduce((a, b) => a.isAfter(b) ? a : b);
      return 8000000000000 - last.millisecondsSinceEpoch;
    }

    return groups.entries.toList()
      ..sort((a, b) => keyFor(a.value).compareTo(keyFor(b.value)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final dataAsync = ref.watch(resultsProvider(careerId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.go('${Routes.hub}?careerId=$careerId'),
        ),
        title: Text(
          l.resultsMyMatches,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l.resultsCouldNotLoad(e.toString()))),
        data: (data) {
          if (data == null || data.fixtures.isEmpty) {
            return Center(child: Text(l.resultsNoFixtures));
          }
          String code(int id) => data.nations[id]?.code ?? '??';

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            children: [
              for (final section in _grouped(l, data.fixtures)) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    4,
                    AppSpacing.md,
                    4,
                    AppSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      Text(
                        section.key.toUpperCase(),
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        '${section.value.length}',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                for (final f in section.value)
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
                                MatchStage.stage(l, f.round),
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.primary,
                                ),
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
    final l = AppLocalizations.of(context);
    final middle = fixture.hasResult
        ? '${fixture.homeScore} - ${fixture.awayScore}'
        : l.resultsVs;

    return Container(
      color: isPlayer ? AppColors.surfaceContainerHigh : null,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  code(fixture.homeNationId),
                  style: AppTypography.bodySmall,
                ),
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
                  : AppTypography.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                FlagDisc(code(fixture.awayNationId), size: 22),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  code(fixture.awayNationId),
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
