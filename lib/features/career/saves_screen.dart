import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/nations/nation_select_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// Lists save games: continue, delete, or start a new one (subject to the
/// free/Pro slot limit).
class SavesScreen extends ConsumerWidget {
  const SavesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savesAsync = ref.watch(savesProvider);
    final premium = ref.watch(premiumUnlockedProvider);
    final limit = maxSaveSlots(premiumUnlocked: premium);
    final nations = ref.watch(nationsProvider).valueOrNull ?? const <Nation>[];
    final nationsById = {for (final n in nations) n.id: n};

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.go(Routes.home),
        ),
        title: Text(
          'SAVES',
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: savesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load saves.\n$e')),
        data: (saves) {
          final full = saves.length >= limit;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.marginMobile),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'SLOTS  ${saves.length}/$limit',
                        style: AppTypography.labelMedium,
                      ),
                    ),
                    if (!premium)
                      Text(
                        'Pro: up to 5',
                        style: AppTypography.labelSmall
                            .copyWith(color: AppColors.onSurfaceVariant),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: saves.isEmpty
                    ? _empty(context)
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.marginMobile,
                        ),
                        itemCount: saves.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, i) {
                          final save = saves[i];
                          return _SaveTile(
                            save: save,
                            nation: nationsById[save.nationId],
                            onContinue: () => context.go(
                              '${Routes.hub}?careerId=${save.id}',
                            ),
                            onDelete: () => ref
                                .read(careerServiceProvider)
                                .delete(save.id),
                          );
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.marginMobile),
                child: PrimaryButton(
                  label: full ? 'Slots full' : 'New Game',
                  icon: Icons.add,
                  onPressed:
                      full ? null : () => context.go(Routes.nations),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _empty(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Text(
            'No saves yet.\nStart a new game to lead a nation.',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium
                .copyWith(color: AppColors.onSurfaceVariant),
          ),
        ),
      );
}

class _SaveTile extends StatelessWidget {
  const _SaveTile({
    required this.save,
    required this.nation,
    required this.onContinue,
    required this.onDelete,
  });

  final Career save;
  final Nation? nation;
  final VoidCallback onContinue;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('MMM yyyy').format(save.inGameDate);
    return AppCard(
      onTap: onContinue,
      child: Row(
        children: [
          FlagDisc(nation?.code ?? '??', size: 48),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nation?.name ?? 'Unknown',
                  style: AppTypography.titleMedium,
                ),
                Text(
                  '${save.managerName} · $date',
                  style: AppTypography.bodySmall
                      .copyWith(color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.outline),
            onPressed: onDelete,
          ),
          const Icon(Icons.chevron_right, color: AppColors.primary),
        ],
      ),
    );
  }
}
