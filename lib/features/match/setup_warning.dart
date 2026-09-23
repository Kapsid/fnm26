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
///
/// Four different situations, because they are four different things to do
/// about it. "Your captain cannot play this one" covered three of them at once
/// and named nobody, so a manager who knew perfectly well who his captain was
/// could only read it as the game having lost track of him.
enum CaptainIssue {
  /// Nobody has it. Either it was never given out, or the man who had it is no
  /// longer in the game at all (retired, or left behind by a move to another
  /// nation) — in which case there is nobody to name, only somebody to pick.
  unnamed,

  /// He is in the squad and hurt.
  injured,

  /// He is in the squad and serving a ban.
  suspended,

  /// He was left out of the squad that was named. A rollover clears the
  /// call-ups, so the squad picked for him afterwards may simply not contain
  /// him.
  dropped,
}

/// What the manager has left unset before kick-off, and who it is about.
typedef SquadSetup = ({
  CaptainIssue? captain,
  String? captainName,
  bool setPieces,
});

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
///
/// The armband is resolved HERE, from the stored id against the squad, rather
/// than read off [captainProvider]. That provider answers "who leads the side
/// out", which is null for a captain who is merely left out of the squad — so
/// asking it first and then re-deriving the reason meant two reads of the same
/// facts, taken at different moments, disagreeing with each other and with the
/// name the tactics screen was showing.
final AutoDisposeFutureProviderFamily<SquadSetup, int> squadSetupProvider =
    FutureProvider.autoDispose.family<SquadSetup, int>((ref, careerId) async {
      final takers = await ref.watch(setPieceTakersProvider(careerId).future);
      final squad = await ref.watch(squadDataProvider(careerId).future);
      final storedId = await ref.watch(
        storedCaptainIdProvider(careerId).future,
      );

      /// Whether [id] is named for the next match and fit to play it.
      bool available(int? id) {
        if (id == null) return false;
        if (squad == null) return true;
        if (!squad.callUps.contains(id)) return false;
        final absence = squad.absences[id];
        return absence == null || absence.isAvailable;
      }

      // The man himself, wherever he is in the pool — in the squad or not, fit
      // or not. Resolving him over the whole pool rather than the call-ups is
      // what lets the warning say his NAME while telling the manager he is out
      // of it.
      final skipper = storedId == null || squad == null
          ? null
          : squad.pool.where((p) => p.id == storedId).firstOrNull;
      final absence = skipper == null ? null : squad!.absences[skipper.id];
      final CaptainIssue? issue;
      if (storedId == null || (squad != null && skipper == null)) {
        // Nobody named, or the named man is gone from the game entirely.
        issue = CaptainIssue.unnamed;
      } else if (skipper == null) {
        // Nothing loaded to check him against: say nothing rather than accuse.
        issue = null;
      } else if ((absence?.injuryMatches ?? 0) > 0) {
        issue = CaptainIssue.injured;
      } else if ((absence?.banMatches ?? 0) > 0) {
        issue = CaptainIssue.suspended;
      } else if (!squad!.callUps.contains(skipper.id)) {
        issue = CaptainIssue.dropped;
      } else {
        issue = null;
      }

      return (
        captain: issue,
        captainName: skipper?.name,
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
    // A named captain is always named BY NAME. A manager who is told his
    // skipper is suspended can act on it; one told "your captain cannot play"
    // has to go and find out who that even is.
    final name = setup.captainName ?? '';
    final message = switch (setup.captain) {
      CaptainIssue.injured => l.matchSetupWarnCaptainInjured(name),
      CaptainIssue.suspended => l.matchSetupWarnCaptainSuspended(name),
      CaptainIssue.dropped => l.matchSetupWarnCaptainDropped(name),
      CaptainIssue.unnamed when setup.setPieces => l.matchSetupWarnCaptain,
      CaptainIssue.unnamed => l.matchSetupWarnBoth,
      null => l.matchSetupWarnSetPieces,
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppCard(
        // Straight to the tab that holds both the armband and the takers,
        // rather than the lineup the manager then has to navigate off. Index 2
        // since the instructions took a tab of their own.
        onTap: () => context.push('${Routes.tactics}?careerId=$careerId&tab=2'),
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
