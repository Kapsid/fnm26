import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/shared/tablet/screen_header.dart';

/// An in-shell tablet page: the screen's heading (a back arrow when [onBack]
/// is given, an action on the right) over [child], which takes the rest of
/// the content area and lays itself out: a dashboard in a scroll view, panes
/// in a Row.
///
/// `TabletDetailPage` is the competition screens' variant, which also boxes
/// its child in one panel.
class TabletPage extends StatelessWidget {
  const TabletPage({
    required this.scaffoldKey,
    required this.title,
    required this.child,
    this.onBack,
    this.backTooltip,
    this.trailing,
    super.key,
  });

  /// The page's key, which tests and the route sweeps look for.
  final Key scaffoldKey;
  final String title;
  final Widget child;

  /// Where the back arrow goes; no arrow when null (an event page, which is
  /// left by deciding).
  final VoidCallback? onBack;

  /// The back arrow's tooltip; Material's "Back" when null.
  final String? backTooltip;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TabletScreenHeader(
              title: title,
              onBack: onBack,
              backTooltip: backTooltip,
              trailing: trailing,
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
