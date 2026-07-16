import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';

int _appPopupDepth = 0;

/// Whether a popup is being prepared or is on screen.
///
/// The hub surfaces unread news from a post-frame callback on *every* rebuild —
/// including the rebuild caused by the very action that is about to show its own
/// popup. Stepping a tournament's final is the case that bites: the champion
/// message and the final's result are triggered together, and whichever loses
/// the race is buried behind the other. Anything that shows a popup after an
/// `await` should hold [withAppPopupGuard] across the whole sequence so the
/// automatic news knows to wait its turn.
bool get appPopupBusy => _appPopupDepth > 0;

/// Marks a popup sequence as in progress for the duration of [action] — from
/// before its first `await`, not just while the dialog is up.
Future<T> withAppPopupGuard<T>(Future<T> Function() action) async {
  _appPopupDepth++;
  try {
    return await action();
  } finally {
    _appPopupDepth--;
  }
}

/// Shows [builder]'s content as a centered popup.
///
/// The app's standard way to surface something that *arrives* — news, a round's
/// results, an announcement. Centred rather than a bottom sheet: a popup the
/// player didn't ask for should land where the eye already is, not creep up
/// from the edge where it reads as a drawer they half-opened.
///
/// Bottom sheets stay for editors the player deliberately opens (the squad
/// picker, tactical instructions), which want the height and the drag handle.
Future<T?> showAppPopup<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
}) {
  return withAppPopupGuard(() => _show<T>(context, builder, barrierDismissible));
}

Future<T?> _show<T>(
  BuildContext context,
  WidgetBuilder builder,
  bool barrierDismissible,
) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) => Dialog(
      backgroundColor: AppColors.surface,
      insetPadding: const EdgeInsets.all(AppSpacing.lg),
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.baseAll),
      child: ConstrainedBox(
        // Tall content scrolls inside the popup rather than overflowing it, and
        // it never stretches to a silly width on a tablet.
        constraints: const BoxConstraints(maxWidth: 480),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: AppSpacing.lg),
          child: builder(context),
        ),
      ),
    ),
  );
}
