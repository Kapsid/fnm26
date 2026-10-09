import 'package:flutter/material.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';

/// A bottom sheet on a phone, a centred dialog on a tablet.
///
/// Takes the same arguments the app's sheets already pass to
/// [showModalBottomSheet], and on a phone forwards them unchanged.
Future<T?> showAdaptiveSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? backgroundColor,
  bool isScrollControlled = false,
  bool isDismissible = true,
  bool enableDrag = true,
  bool? showDragHandle,
}) {
  if (!context.isTabletWindow) {
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
      final height = MediaQuery.sizeOf(dialogContext).height;
      return Dialog(
        backgroundColor: backgroundColor ?? AppColors.surfaceContainer,
        insetPadding: const EdgeInsets.all(AppSpacing.xl),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.lgAll),
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          // Bounded both ways: sheets built around a DraggableScrollableSheet
          // or a ListView need a finite height to lay out in.
          constraints: BoxConstraints(maxWidth: 560, maxHeight: height * 0.85),
          child: Builder(builder: builder),
        ),
      );
    },
  );
}
