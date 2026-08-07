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
/// Reads the inbox straight from the repository rather than through
/// [messageInboxProvider], which syncs as a side effect: showing news is not
/// the right moment to generate it, and whoever displays the badge has already
/// done so.
///
/// Returns the number shown.
Future<int> showUnreadMessagePopups(
  BuildContext context,
  WidgetRef ref,
  int careerId,
) async {
  final l = AppLocalizations.of(context);
  final comp = ref.read(competitionRepositoryProvider);
  final unread = (await comp.messages(careerId)).where((m) => !m.read).toList()
    // The inbox is newest first; a run of events reads better in the order it
    // happened.
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

  // Only what was shown — the rest stay unread and pop next time.
  await ref
      .read(competitionRepositoryProvider)
      .markMessagesRead(careerId, ids: showing.map((m) => m.id).toList());
  ref
    ..invalidate(messageInboxProvider(careerId))
    ..invalidate(unreadMessagesProvider(careerId));
  return showing.length;
}
