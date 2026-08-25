import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/features/squad/captain_providers.dart';
import 'package:fnm/features/tactics/set_piece_takers_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// What is wrong with the armband, or null when nothing is.
enum CaptainIssue {
  /// Nobody has been given it.
  unnamed,

  /// Somebody has, and he cannot play this one — injured, suspended, or left
  /// out of the squad. A rollover clears the call-ups, so the squad that gets
  /// picked for him afterwards may simply not contain him.
  unavailable,
}

/// What the manager has left unset before kick-off.
typedef SquadSetup = ({CaptainIssue? captain, bool setPieces});

/// Whether the armband and the set-piece takers are actually COVERED for the
/// next match.
///
/// Both default to "let the engine decide", which is a reasonable default and
/// a terrible secret: a manager who never opened the tactics screen had no way
/// of learning there was a decision there at all.
///
/// The question is availability, not storage. Asking only whether an id had
/// been saved meant the warning fired on day one, when nothing was set, and
/// then never again — a captain who picked up a six-week injury, or a penalty
/// taker dropped from the squad, left the id sitting in the save and the
/// warning silent, which is precisely the match where it was needed. A named
/// man who cannot play is not a named man.
final AutoDisposeFutureProviderFamily<SquadSetup, int> squadSetupProvider =
    FutureProvider.autoDispose.family<SquadSetup, int>((ref, careerId) async {
      final captain = await ref.watch(captainProvider(careerId).future);
      final takers = await ref.watch(setPieceTakersProvider(careerId).future);
      final squad = await ref.watch(squadDataProvider(careerId).future);

      /// Whether [id] is named for the next match and fit to play it.
      bool available(int? id) {
        if (id == null) return false;
        if (squad == null) return true;
        if (!squad.callUps.contains(id)) return false;
        final absence = squad.absences[id];
        return absence == null || absence.isAvailable;
      }

      // NAMED and AVAILABLE are different problems and used to be the same
      // one. `captainProvider` returns null both for a manager who never gave
      // the armband to anybody and for one whose captain is injured or was
      // left out of the squad, so a man who had been captain for six years was
      // reported as "No captain named" the week he pulled a hamstring — which
      // reads as the game having lost the setting, and sends the manager to a
      // screen that already says what he expects it to say.
      // Whether the armband was given to ANYBODY. A resolved captain is proof
      // of it by itself; only when nobody resolved is the stored intent worth
      // reading, and that is exactly the case the two messages differ on.
      final storedCaptain =
          captain?.id ??
          await ref.watch(storedCaptainIdProvider(careerId).future);
      return (
        captain: storedCaptain == null
            ? CaptainIssue.unnamed
            : (captain != null && available(captain.id)
                  ? null
                  : CaptainIssue.unavailable),
        // Penalties are the half of this that decides matches, so a save with
        // a dead-ball taker and nobody on penalties still counts as unset.
        setPieces: available(takers.penalty) && available(takers.deadBall),
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
    if (setup == null || (setup.captain == null && setup.setPieces)) {
      return const SizedBox.shrink();
    }
    final message = switch (setup) {
      (captain: CaptainIssue.unavailable, setPieces: _) =>
        l.matchSetupWarnCaptainOut,
      (captain: CaptainIssue.unnamed, setPieces: false) => l.matchSetupWarnBoth,
      (captain: CaptainIssue.unnamed, setPieces: true) =>
        l.matchSetupWarnCaptain,
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
