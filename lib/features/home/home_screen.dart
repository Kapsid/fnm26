import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// The app's landing screen: jump straight back into the last save, start a new
/// game, or open the full saves list.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    // The most recent save (saves are listed most-recently-PLAYED first) —
    // powers the one-tap "continue where you left off" action.
    final saves = ref.watch(savesProvider).valueOrNull;
    final lastSave = (saves != null && saves.isNotEmpty) ? saves.first : null;
    final lastNation = lastSave == null
        ? null
        : ref.watch(nationByIdProvider(lastSave.nationId)).valueOrNull;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.marginMobile,
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  tooltip: l.homeSettings,
                  icon: const Icon(
                    Icons.settings_outlined,
                    color: AppColors.onSurfaceVariant,
                  ),
                  onPressed: () => context.go(Routes.settings),
                ),
              ),
              const Spacer(),
              Image.asset(
                'assets/images/fnm_logo.png',
                width: 168,
                height: 168,
                // Graceful fallback if the asset is missing in a bare test env.
                errorBuilder: (context, error, stack) => const Icon(
                  Icons.sports_soccer,
                  size: 112,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Football Nations\nManager',
                textAlign: TextAlign.center,
                style: textTheme.headlineLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l.homeLeadTheNation,
                textAlign: TextAlign.center,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              // The headline action when a save exists: resume it in one tap,
              // visually lifted so it reads as "carry on".
              if (lastSave != null) ...[
                _ContinueCard(
                  nationName: lastNation?.name ?? l.homeYourNation,
                  nationCode: lastNation?.code,
                  inGameDate: lastSave.inGameDate,
                  cyclePointer: lastSave.cyclePointer,
                  onResume: () {
                    ref.read(careerServiceProvider).markPlayed(lastSave.id);
                    context.go('${Routes.hub}?careerId=${lastSave.id}');
                  },
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              PrimaryButton(
                label: l.homeNewGame,
                onPressed: () => context.go(Routes.nations),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextButton(
                onPressed: () => context.go(Routes.saves),
                child: Text(lastSave != null ? l.homeAllSaves : l.homeLoadGame),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

/// The highlighted "continue your last save" card — a flag, the nation, and a
/// bright resume button.
class _ContinueCard extends StatelessWidget {
  const _ContinueCard({
    required this.nationName,
    required this.nationCode,
    required this.inGameDate,
    required this.cyclePointer,
    required this.onResume,
  });

  final String nationName;
  final String? nationCode;
  final DateTime inGameDate;
  final int cyclePointer;
  final VoidCallback onResume;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return GestureDetector(
      onTap: onResume,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.secondaryContainer,
          borderRadius: AppRadii.baseAll,
          border: Border.all(color: AppColors.primary, width: 1.5),
        ),
        child: Row(
          children: [
            if (nationCode != null) ...[
              FlagDisc(nationCode!, size: 40, highlighted: true),
              const SizedBox(width: AppSpacing.md),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.homeContinue,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  Text(nationName, style: AppTypography.titleMedium),
                  const SizedBox(height: 2),
                  Text(
                    l.homeRoadToWorldCup(
                      DateFormat('MMM yyyy').format(inGameDate),
                      CareerService.worldCupYear(cyclePointer),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.play_circle_fill_rounded,
              color: AppColors.primary,
              size: 36,
            ),
          ],
        ),
      ),
    );
  }
}
