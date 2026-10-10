import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/features/shell/tablet_sidebar.dart';
import 'package:fnm/features/shell/tablet_top_bar.dart';
import 'package:fnm/shared/tablet/tablet_shell_scope.dart';

/// Route paths whose screens have a tablet layout and may use the whole
/// content area (in the shell) or the whole screen (full-screen routes).
/// Everything else is drawn at phone width: [PhoneWidthFrame] in the shell,
/// [FullScreenPhoneFrame] outside it. Each stage adds the screens it converts.
const Set<String> tabletReadyPaths = <String>{
  Routes.hub,
  Routes.callUps,
  Routes.matchPreview,
  Routes.match,
  Routes.roundResults,
  Routes.messages,
  Routes.tactics,
  Routes.ranking,
  Routes.results,
  Routes.cup,
  Routes.continental,
  Routes.nationsCup,
  Routes.continentalClash,
  Routes.intercontinentalPlayoff,
  Routes.tournaments,
  Routes.qualifyingDraw,
  Routes.continentalDraw,
  Routes.nationsCupDraw,
  Routes.finalsDraw,
};

/// The tablet frame around every in-save screen: sidebar on the left, top bar
/// above, the routed screen in what is left.
///
/// Steps aside entirely (returns [child]) when there is no save in the link,
/// or when the window is under [kTabletLayoutMinWidth] wide (iPad split view,
/// a narrowed iPadOS window).
class TabletShell extends StatelessWidget {
  const TabletShell({required this.location, required this.child, super.key});

  final Uri location;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final careerId = int.tryParse(location.queryParameters['careerId'] ?? '');
    if (careerId == null || careerId <= 0 || !context.isWideTabletWindow) {
      return child;
    }
    return TabletShellScope(
      // A Material, not a ColoredBox: it supplies the DefaultTextStyle the
      // sidebar and top bar texts need (without it they get the yellow
      // double underline).
      child: Material(
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
                    Expanded(child: child),
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

/// An in-shell screen with no tablet layout yet, framed at phone width.
///
/// Applied to the PAGE (see `_tabletRoutes`), not to the shell's navigator:
/// framing by the current location framed an outgoing tablet page at 600
/// while it was still transitioning out, and stretched an outgoing phone
/// page. Outside the shell (a split-view window) the child is left alone.
class ShellPhoneFrame extends StatelessWidget {
  const ShellPhoneFrame({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => TabletShellScope.isActive(context)
      ? PhoneWidthFrame(child: child)
      : child;
}

/// Draws a phone screen in the middle of a wider area, at most [maxWidth]
/// wide, and tells it so: the [MediaQuery] it sees is the frame's size, so
/// anything it sizes from the screen comes out as it would on a large phone.
///
/// Only the size and the padding are replaced. [MediaQueryData.viewInsets]
/// is passed through on purpose: the framed screen's Scaffold reads it to
/// lift its content above the keyboard.
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

/// A full-screen route with no tablet layout yet, on a tablet: its phone
/// layout centred at [PhoneWidthFrame.maxWidth] on the app's background,
/// rather than stretched across a landscape screen. On a phone, or a window
/// narrower than [kTabletLayoutMinWidth], the child is returned as it is.
class FullScreenPhoneFrame extends StatelessWidget {
  const FullScreenPhoneFrame({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!context.isWideTabletWindow) return child;
    return Material(
      color: AppColors.surface,
      child: SafeArea(child: PhoneWidthFrame(child: child)),
    );
  }
}
