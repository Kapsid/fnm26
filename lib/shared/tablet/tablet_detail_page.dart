import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/shared/tablet/panel.dart';
import 'package:fnm/shared/tablet/screen_header.dart';

/// The tab bar every tablet competition view carries across the top of its
/// panel: scrolling, start-aligned, on the container surface.
class TabletTabBar extends StatelessWidget {
  const TabletTabBar({
    required this.tabs,
    this.selectedColor = AppColors.onSurface,
    this.indicatorColor = AppColors.primary,
    super.key,
  });

  final List<Widget> tabs;

  /// The selected tab's label colour.
  final Color selectedColor;
  final Color indicatorColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceContainer,
      child: TabBar(
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelColor: selectedColor,
        unselectedLabelColor: AppColors.onSurfaceVariant,
        indicatorColor: indicatorColor,
        tabs: tabs,
      ),
    );
  }
}

/// A competition's full-screen tablet page: a heading (with back) over one
/// panel holding [child].
class TabletDetailPage extends StatelessWidget {
  const TabletDetailPage({
    required this.scaffoldKey,
    required this.title,
    required this.onBack,
    required this.child,
    this.accent,
    super.key,
  });

  /// The page's key, which tests and the route sweeps look for.
  final Key scaffoldKey;
  final String title;
  final VoidCallback onBack;
  final Widget child;

  /// The title's colour; the screen title's own when null.
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TabletScreenHeader(title: title, accent: accent, onBack: onBack),
            Expanded(child: PanelBox(child: child)),
          ],
        ),
      ),
    );
  }
}
