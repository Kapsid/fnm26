import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/tournaments/intercontinental_playoff_bracket.dart';
import 'package:fnm/features/tournaments/intercontinental_playoff_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

part 'intercontinental_playoff_tablet_layout.dart';

/// A one-shot event surfaced before the World Cup finals draw: the
/// intercontinental play-off that decided the final two berths, shown as its own
/// step (passively simulated) rather than buried on the draw screen.
class IntercontinentalPlayoffScreen extends ConsumerWidget {
  const IntercontinentalPlayoffScreen({required this.careerId, super.key});

  final int careerId;

  Future<void> _continue(BuildContext context, WidgetRef ref) async {
    final container = ProviderScope.containerOf(context, listen: false);
    final career = await ref.read(careerRepositoryProvider).byId(careerId);
    if (career != null) {
      await ref
          .read(competitionRepositoryProvider)
          .markDrawWatched(
            careerId,
            career.cyclePointer,
            worldCupPlayoffKind,
          );
    }
    // Retires the event in the top bar too (see CallUpScreen._confirm).
    container.invalidate(hubDataProvider(careerId));
    if (context.mounted) context.go('${Routes.hub}?careerId=$careerId');
  }

  static const Key tabletLayoutKey = Key('playoff.tabletLayout');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (TabletShellScope.isActive(context)) {
      return _PlayoffTabletLayout(screen: this);
    }
    final l = AppLocalizations.of(context);
    final async = ref.watch(intercontinentalPlayoffProvider(careerId));
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          l.tourContIntercontinentalPlayoff,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l.tourContCouldNotLoad(e.toString()))),
        data: (data) {
          if (data == null) {
            return Center(child: Text(l.tourContNoPlayoffThisCycle));
          }
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.marginMobile),
                  children: _playoffBody(l, data),
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.marginMobile),
                  child: PrimaryButton(
                    label: l.tourContContinue,
                    icon: Icons.check_rounded,
                    onPressed: () => _continue(context, ref),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// The play-off's body: what it is, how the manager's nation fared (when it
/// was in it), and the bracket. The phone's list and the tablet's both show
/// exactly this.
List<Widget> _playoffBody(AppLocalizations l, PlayoffView data) {
  String code(int id) => data.nations[id]?.code ?? '??';
  String name(int id) => data.nations[id]?.name ?? '—';
  final winners = {
    for (final t in data.ties)
      if (t.isFinal) t.winner,
  };
  final playerThrough = winners.contains(data.playerNationId);
  final playerInvolved = data.ties.any(
    (t) => t.home == data.playerNationId || t.away == data.playerNationId,
  );
  return [
    Text(
      l.tourContPlayoffIntro,
      style: AppTypography.bodySmall.copyWith(
        color: AppColors.onSurfaceVariant,
      ),
    ),
    if (playerInvolved) ...[
      const SizedBox(height: AppSpacing.sm),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: (playerThrough ? AppColors.positive : AppColors.error)
              .withValues(alpha: 0.12),
          borderRadius: AppRadii.baseAll,
          border: Border.all(
            color: playerThrough ? AppColors.positive : AppColors.error,
          ),
        ),
        child: Text(
          playerThrough ? l.tourContPlayoffThrough : l.tourContPlayoffOut,
          style: AppTypography.bodyMedium.copyWith(
            color: playerThrough ? AppColors.positive : AppColors.error,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    ],
    const SizedBox(height: AppSpacing.md),
    IntercontinentalPlayoffBracket(
      ties: data.ties,
      code: code,
      name: name,
      playerNationId: data.playerNationId,
    ),
  ];
}
