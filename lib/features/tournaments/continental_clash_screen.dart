import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/features/tournaments/continental_clash_providers.dart';
import 'package:fnm/features/tournaments/tournament_history.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// Continental Clash (Finalissima) detail: the champions-of-champions one-off
/// between the European and South American champions — this cycle's tie and
/// every past edition.
class ContinentalClashScreen extends ConsumerWidget {
  const ContinentalClashScreen({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final dataAsync = ref.watch(continentalClashProvider(careerId));

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: () =>
                context.go('${Routes.tournaments}?careerId=$careerId'),
          ),
          title: Text(
            l.tourContContinentalClash,
            style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kTournamentTabBarHeight),
            child: TabBar(
              labelColor: AppColors.onSurface,
              unselectedLabelColor: AppColors.onSurfaceVariant,
              indicatorColor: AppColors.primary,
              tabs: [
                Tab(text: l.tourContTabThisCycle),
                Tab(text: l.tourContTabHistory),
              ],
            ),
          ),
        ),
        body: dataAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) =>
              Center(child: Text(l.tourContCouldNotLoadClash(e.toString()))),
          data: (data) {
            if (data == null) {
              return Center(child: Text(l.tourContNoSaveFound));
            }
            String code(int id) => data.nations[id]?.code ?? '??';
            String name(int id) => data.nations[id]?.name ?? l.tourContUnknown;

            return TabBarView(
              children: [
                if (data.tie == null)
                  TournamentSoon(
                    message: l.tourContClashSoon,
                  )
                else
                  _ThisCycle(
                    tie: data.tie!,
                    playerNationId: data.playerNationId,
                    code: code,
                    name: name,
                  ),
                TournamentHistory(
                  honours: data.honours,
                  name: name,
                  code: code,
                  emptyMessage: l.tourContNoClashYet,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// This cycle's tie: both champions face to face, with the result once played.
class _ThisCycle extends StatelessWidget {
  const _ThisCycle({
    required this.tie,
    required this.playerNationId,
    required this.code,
    required this.name,
  });

  final Fixture tie;
  final int playerNationId;
  final String Function(int) code;
  final String Function(int) name;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final played = tie.hasResult;
    final winnerId = !played
        ? null
        : tie.homeScore! >= tie.awayScore!
        ? tie.homeNationId
        : tie.awayNationId;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [
        AppCard(
          child: Column(
            children: [
              const Icon(Icons.flash_on, color: AppColors.primary, size: 32),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l.tourContTwoContinentsOneMatch,
                textAlign: TextAlign.center,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(child: _side(tie.homeNationId)),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    child: Text(
                      played
                          ? '${tie.homeScore} – ${tie.awayScore}'
                          : l.tourContVersusShort,
                      style: AppTypography.headlineMedium,
                    ),
                  ),
                  Expanded(child: _side(tie.awayNationId)),
                ],
              ),
              if (winnerId != null) ...[
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.emoji_events,
                      color: AppColors.primary,
                      size: 18,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      l.tourContWinTheClash(name(winnerId)),
                      style: AppTypography.titleMedium,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _side(int nationId) => Column(
    children: [
      FlagDisc(
        code(nationId),
        size: 44,
        highlighted: nationId == playerNationId,
      ),
      const SizedBox(height: AppSpacing.sm),
      Text(
        name(nationId),
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.titleMedium,
      ),
    ],
  );
}
