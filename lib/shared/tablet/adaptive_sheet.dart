import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';

/// Whether [showAdaptiveSheet] shows a dialog (rather than a bottom sheet) for
/// [context]. Code that must "pop before navigating" asks this, not
/// `TabletShellScope`, so the answer always matches the sheet that was shown.
bool sheetIsDialog(BuildContext context) => context.isTabletWindow;

/// A bottom sheet on a phone, a centred dialog on a tablet.
///
/// Takes the same arguments the app's sheets already pass to
/// [showModalBottomSheet], and on a phone forwards them unchanged. On a tablet
/// [enableDrag] and [showDragHandle] are ignored, and the dialog goes on the
/// root navigator.
///
/// On a tablet the sheet is a root dialog, not a route of the screen's own
/// navigator. Inside [builder], pop with the sheet's own context
/// (`Navigator.of(sheetContext).pop(x)`), never the screen's, which would pop
/// the screen from the shell navigator. And pop BEFORE navigating (go/push)
/// from inside sheet content, or the new page lands underneath the dialog.
///
/// Deliberate: a 600-999 wide tablet window shows the phone layouts but still
/// gets dialog sheets (see [sheetIsDialog]), so those windows also need the
/// pop-before-navigate rule.
Future<T?> showAdaptiveSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? backgroundColor,
  bool isScrollControlled = false,
  bool isDismissible = true,
  bool enableDrag = true,
  bool? showDragHandle,
}) {
  if (!sheetIsDialog(context)) {
    return showModalBottomSheet<T>(
      context: context,
      builder: builder,
      backgroundColor: backgroundColor,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      showDragHandle: showDragHandle,
    );
  }
  return showDialog<T>(
    context: context,
    barrierDismissible: isDismissible,
    builder: (dialogContext) {
      final size = MediaQuery.sizeOf(dialogContext);
      final height = size.height;
      // A definite width: sheet content is built for a full-width sheet and
      // would shrink to its content inside a loose dialog.
      final width = math.min<double>(560, size.width - 2 * AppSpacing.xl);
      return Dialog(
        backgroundColor: backgroundColor ?? AppColors.surfaceContainer,
        insetPadding: const EdgeInsets.all(AppSpacing.xl),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.lgAll),
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          // Bounded both ways: sheets built around a DraggableScrollableSheet
          // or a ListView need a finite height to lay out in.
          constraints: BoxConstraints(maxHeight: height * 0.85),
          child: SizedBox(
            width: width,
            child: Builder(builder: builder),
          ),
        ),
      );
    },
  );
}
