import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/util/caps.dart';
import 'package:fnm/shared/tablet/tablet_text.dart';

/// A titled box for tablet dashboards: tighter than `AppCard`, with a header
/// strip and an optional action on its right.
class Panel extends StatelessWidget {
  const Panel({
    required this.title,
    required this.child,
    this.action,
    this.padding = const EdgeInsets.all(12),
    this.expand = false,
    super.key,
  });

  final String title;
  final Widget? action;
  final Widget child;
  final EdgeInsetsGeometry padding;

  /// Whether the panel fills the height it is given, its body taking all of
  /// it below the header. For a body that scrolls (a list, a grid). Never
  /// inside a `DashboardGrid`, whose rows measure intrinsic heights.
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final body = Padding(padding: padding, child: child);
    return PanelBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Container(
            height: 34,
            color: AppColors.surfaceContainer,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title.capsIn(Localizations.localeOf(context).languageCode),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TabletText.panelTitle,
                  ),
                ),
                ?action,
              ],
            ),
          ),
          if (expand) Expanded(child: body) else body,
        ],
      ),
    );
  }
}

/// A panel's box without its header, for a pane whose content brings its own
/// (a tab bar, a detail view).
class PanelBox extends StatelessWidget {
  const PanelBox({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.surfaceContainerLow,
    shape: RoundedRectangleBorder(
      borderRadius: AppRadii.baseAll,
      side: const BorderSide(color: AppColors.outlineVariant),
    ),
    clipBehavior: Clip.antiAlias,
    child: child,
  );
}

/// The small link on the right of a [Panel]'s header ("View all").
class PanelLink extends StatelessWidget {
  const PanelLink({required this.label, required this.onTap, super.key});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: AppRadii.smAll,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      child: Text(label, style: TabletText.panelLink),
    ),
  );
}
