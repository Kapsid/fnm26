import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/features/shell/tablet_sidebar.dart';
import 'package:fnm/features/shell/tablet_top_bar.dart';
import 'package:fnm/shared/tablet/tablet_shell_scope.dart';

/// Route paths whose screens have a tablet layout and may use the whole
/// content area. Everything else is drawn at phone width (see
/// [PhoneWidthFrame]). Each later stage adds the screens it converts.
const Set<String> tabletReadyPaths = <String>{};

/// The tablet frame around every in-save screen: sidebar on the left, top bar
/// above, the routed screen in what is left.
///
/// Steps aside entirely (returns [child]) when there is no save in the link,
/// or when the window is not tablet sized, as in iPad split view.
class TabletShell extends StatelessWidget {
  const TabletShell({required this.location, required this.child, super.key});

  final Uri location;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final careerId = int.tryParse(location.queryParameters['careerId'] ?? '');
    if (careerId == null || careerId <= 0 || !context.isTabletWindow) {
      return child;
    }
    final content = tabletReadyPaths.contains(location.path)
        ? child
        : PhoneWidthFrame(child: child);
    return TabletShellScope(
      child: ColoredBox(
        color: AppColors.surface,
        child: SafeArea(
          child: Row(
            children: [
              TabletSidebar(careerId: careerId, location: location),
              const VerticalDivider(
                width: 1,
                thickness: 1,
                color: AppColors.outlineVariant,
              ),
              Expanded(
                child: Column(
                  children: [
                    TabletTopBar(careerId: careerId),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.outlineVariant,
                    ),
                    Expanded(child: content),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Draws a phone screen in the middle of a wider area, at most [maxWidth]
/// wide, and tells it so: the [MediaQuery] it sees is the frame's size, so
/// anything it sizes from the screen comes out as it would on a large phone.
class PhoneWidthFrame extends StatelessWidget {
  const PhoneWidthFrame({required this.child, super.key});

  static const double maxWidth = 600;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = math.min(constraints.maxWidth, maxWidth);
        final media = MediaQuery.of(context);
        return Center(
          child: SizedBox(
            width: width,
            height: constraints.maxHeight,
            child: MediaQuery(
              data: media.copyWith(
                size: Size(width, constraints.maxHeight),
                padding: EdgeInsets.zero,
                viewPadding: EdgeInsets.zero,
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
