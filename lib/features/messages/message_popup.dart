import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/messages/message_providers.dart';
import 'package:fnm/features/messages/message_sheet.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

/// At most this many messages pop in one go. Anything past it waits in the
/// inbox rather than burying the manager in popups — a skip to the final can
/// generate a whole run at once.
const kMaxMessagePopups = 3;

/// Shows unread messages over the current screen, oldest first, then marks the
/// ones actually shown as read.
///
/// Unread is the trigger rather than "whatever [MessageService.sync] just
/// wrote", because the hub already syncs on every build to compute its unread
/// badge — by the time anything could ask sync what was new, it would always
/// answer "nothing".
///
/// SYNCS FIRST, then reads. This used to read the repository straight, on the
/// reasoning that whoever displays the unread badge has already synced. They
/// have — but not yet: the popup runs on the hub's FIRST frame, before
/// [messageInboxProvider] has resolved, so a step that had just generated news
/// found an empty inbox and the news appeared only on the manager's next visit
/// to the hub. Sync is idempotent and deduplicated, so paying for it here
/// costs a cache hit and buys news that arrives when it happened.
///
/// Returns the number shown.
///
/// Anything past [kMaxMessagePopups] is marked read along with them and waits
/// in the inbox — see the note at the bottom of this function.
Future<int> showUnreadMessagePopups(
  BuildContext context,
  WidgetRef ref,
  int careerId,
) async {
  final l = AppLocalizations.of(context);
  // Generate before reading — see the note above.
  await ref.read(messageServiceProvider).sync(careerId);
  final comp = ref.read(competitionRepositoryProvider);
  // Mid-tournament, the between-seasons reports wait. They stay unread and pop
  // once the final has been played — see [kBetweenSeasonsCategories].
  final duringTournament = await ref.read(
    tournamentInProgressProvider(careerId).future,
  );
  final unread =
      (await comp.messages(careerId))
          .where(
            (m) =>
                !m.read &&
                !(duringTournament &&
                    kBetweenSeasonsCategories.contains(m.category)),
          )
          .toList()
        // The inbox is newest first; a run of events reads better in the order
        // it happened.
        ..sort((a, b) => a.id.compareTo(b.id));
  if (unread.isEmpty) return 0;

  final showing = unread.take(kMaxMessagePopups).toList();
  for (var i = 0; i < showing.length; i++) {
    if (!context.mounted) break;
    final isLast = i == showing.length - 1;
    await showAppPopup<void>(
      context: context,
      // News is stepped through, so it's dismissed with the button rather than
      // by tapping away — otherwise a stray tap skips the rest of the run.
      barrierDismissible: false,
      builder: (popupContext) => MessageSheet(
        message: showing[i],
        action: (
          label: isLast ? l.messagesDone : l.messagesNext,
          onPressed: () => Navigator.of(popupContext).pop(),
        ),
      ),
    );
  }

  // The WHOLE eligible batch is marked read, not only the three that were
  // shown.
  //
  // Leaving the remainder unread turned the cap into a queue: a save with a
  // backlog — and one builds every tournament, since the between-seasons
  // reports are held until the final is played and then all arrive at once —
  // popped three items on every single visit to the hub, for ever. Opening the
  // app and being handed three reports about players, again, is the reported
  // bug, and it was the cap draining three at a time rather than anything
  // being generated twice.
  //
  // News is announced once. The inbox is where it lives afterwards, and the
  // count below says how much of it went straight there.
  await ref
      .read(competitionRepositoryProvider)
      .markMessagesRead(careerId, ids: unread.map((m) => m.id).toList());
  ref
    ..invalidate(messageInboxProvider(careerId))
    ..invalidate(unreadMessagesProvider(careerId));
  return showing.length;
}
