import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/features/squad/captain_providers.dart';
import 'package:fnm/features/tactics/set_piece_takers_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// What the manager has left unset before kick-off.
typedef SquadSetup = ({bool captain, bool setPieces});

/// Whether the armband and the set-piece takers have been named for this save.
///
/// Both default to "let the engine decide", which is a reasonable default and
/// a terrible secret: a manager who never opened the tactics screen had no way
/// of learning there was a decision there at all. This is what the warning
/// strip reads.
final AutoDisposeFutureProviderFamily<SquadSetup, int> squadSetupProvider =
    FutureProvider.autoDispose.family<SquadSetup, int>((ref, careerId) async {
      final captain = await ref.watch(captainProvider(careerId).future);
      final takers = await ref.watch(setPieceTakersProvider(careerId).future);
      return (
        captain: captain != null,
        // Penalties are the half of this that decides matches, so a save with
        // a dead-ball taker and nobody on penalties still counts as unset.
        setPieces: takers.penalty != null && takers.deadBall != null,
      );
    });

/// A strip before kick-off saying what has not been set — the armband, the
/// set-piece takers, or both — with a tap through to the screen that sets it.
///
/// It WARNS. It never blocks: leaving the engine to pick is a legitimate way
/// to play, and a manager who means it should not have to argue with a dialog
/// every match. What he should not do is find out after the shoot-out.
class SquadSetupWarning extends ConsumerWidget {
  const SquadSetupWarning({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final setup = ref.watch(squadSetupProvider(careerId)).valueOrNull;
    if (setup == null || (setup.captain && setup.setPieces)) {
      return const SizedBox.shrink();
    }
    final message = switch (setup) {
      (captain: false, setPieces: false) => l.matchSetupWarnBoth,
      (captain: false, setPieces: true) => l.matchSetupWarnCaptain,
      _ => l.matchSetupWarnSetPieces,
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppCard(
        onTap: () => context.push('${Routes.tactics}?careerId=$careerId'),
        child: Row(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 18,
              color: AppColors.warning,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                message,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.warning,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: AppColors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
