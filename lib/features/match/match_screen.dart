import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// Plays (and shows) the player's next fixture using the tactical engine, then
/// commits the result and advances the save.
class MatchScreen extends ConsumerWidget {
  const MatchScreen({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final previewAsync = ref.watch(matchPreviewProvider(careerId));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MATCH',
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
          final r = preview.result;
          String code(int id) => preview.nations[id]?.code ?? '??';

          return Column(
            children: [
              const SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _Side(code: code(f.homeNationId)),
                  Column(
                    children: [
                      Text(
                        '${r.homeScore} - ${r.awayScore}',
                        style: AppTypography.displayLarge,
                      ),
                      const Text(
                        'FULL TIME',
                        style: AppTypography.labelMedium,
                      ),
                    ],
                  ),
                  _Side(code: code(f.awayNationId)),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: r.events.isEmpty
                    ? Center(
                        child: Text(
                          'A goalless affair.',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      )
                    : ListView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.marginMobile,
                        ),
                        children: [
                          for (final e in r.events)
                            ListTile(
                              dense: true,
                              leading: Text(
                                "${e.minute}'",
                                style: AppTypography.labelMedium,
                              ),
                              title: Text(
                                e.playerName,
                                style: AppTypography.bodyMedium,
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.sports_soccer,
                                    size: 16,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Text(
                                    code(e.teamNationId),
                                    style: AppTypography.labelSmall,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.marginMobile),
                child: PrimaryButton(
                  label: 'Continue',
                  icon: Icons.check_rounded,
                  onPressed: () async {
                    await ref
                        .read(seasonServiceProvider)
                        .playPlayerMatch(careerId, f, r);
                    if (context.mounted) {
                      context.go('${Routes.hub}?careerId=$careerId');
                    }
                  },
                ),
              ),
            ],
          );
        },
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
        FlagDisc(code),
        const SizedBox(height: AppSpacing.xs),
        Text(code, style: AppTypography.labelMedium),
      ],
    );
  }
}
