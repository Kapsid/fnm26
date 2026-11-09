import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet_shell_scope.dart';
import 'package:go_router/go_router.dart';

/// The primary destinations reachable from the persistent bottom navigation.
enum AppTab { hub, squad, competitions, careers }

/// The app's persistent bottom navigation: a floating dock of brushed silver,
/// held off the screen edges and above the home indicator, shared across the
/// four primary destinations so they are always one tap apart.
///
/// The dock floats OVER the content, which scrolls on beneath it and fades
/// out under it. So a Scaffold that carries it must set `extendBody: true`
/// (asserted in debug), and every scrolling body on such a screen pads its
/// foot with [AppBottomNav.padScroll], or its last item would end up behind
/// the dock with no way to scroll it clear.
///
/// The selected tab is a frosted, near-transparent pill of lighter silver,
/// its icon and label in the strongest ink; the others are engraved into the
/// plate in a lighter one.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    required this.careerId,
    required this.current,
    super.key,
  });

  final int careerId;
  final AppTab current;

  /// How much of the foot of a body the dock (and the fade above it) covers,
  /// read inside the body of a Scaffold carrying the dock. Scaffold reports
  /// the bar's height as the body's bottom padding when `extendBody` is set,
  /// so this is exact at any text size and safe-area inset. Zero inside the
  /// tablet shell, where the dock is not drawn and nothing changes.
  static double clearance(BuildContext context) =>
      TabletShellScope.isActive(context)
      ? 0
      : MediaQuery.paddingOf(context).bottom;

  /// [padding] with [clearance] added to its foot: the padding for a
  /// scrolling body under the dock, so its last item scrolls fully clear.
  static EdgeInsets padScroll(BuildContext context, EdgeInsets padding) =>
      padding.copyWith(bottom: padding.bottom + clearance(context));

  /// The dock's own height, not counting the safe area under it or the fade
  /// above it.
  static const double dockHeight = 68;

  /// The fade above the dock, where the content dims as it goes under.
  static const double fadeHeight = 22;

  void _go(BuildContext context, String route) {
    context.go('$route?careerId=$careerId');
  }

  @override
  Widget build(BuildContext context) {
    // On a tablet the shell's sidebar is the navigation.
    if (TabletShellScope.isActive(context)) return const SizedBox.shrink();
    assert(
      Scaffold.maybeOf(context)?.widget.extendBody ?? true,
      'AppBottomNav floats over the content: its Scaffold needs '
      'extendBody: true, and the body AppBottomNav.padScroll.',
    );
    final l = AppLocalizations.of(context);
    final bottom = MediaQuery.viewPaddingOf(context).bottom;
    final tabs = [
      (
        AppTab.hub,
        Icons.grid_view_outlined,
        Icons.grid_view_rounded,
        l.navHub,
        Routes.hub,
      ),
      (
        AppTab.squad,
        Icons.groups_outlined,
        Icons.groups,
        l.navSquad,
        Routes.tactics,
      ),
      (
        AppTab.competitions,
        Icons.emoji_events_outlined,
        Icons.emoji_events,
        l.navStandings,
        Routes.tournaments,
      ),
      (
        AppTab.careers,
        Icons.account_circle_outlined,
        Icons.account_circle,
        l.navCareers,
        Routes.careers,
      ),
    ];
    return DecoratedBox(
      // The content fades out under the dock rather than being cut by it.
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x00121416), Color(0xE6121416), AppColors.surface],
          stops: [0, 0.3, 1],
        ),
      ),
      child: Padding(
        // Over the home indicator, never on it; a phone without one gets the
        // same margin as the sides.
        padding: EdgeInsets.fromLTRB(
          14,
          fadeHeight,
          14,
          bottom > 0 ? math.max(bottom - 4, 12) : 14,
        ),
        child: _Dock(
          child: Row(
            // Equal shares rather than natural widths: a long translation
            // shrinks inside its own share instead of pushing the others out.
            children: [
              for (final (tab, icon, activeIcon, label, route) in tabs)
                Expanded(
                  child: _NavItem(
                    icon: tab == current ? activeIcon : icon,
                    label: label,
                    active: tab == current,
                    onTap: () => _go(context, route),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// The brushed silver of the score bug and the primary button.
const Color _silverHi = Color(0xFFF2F6FA);
const Color _silverMid = Color(0xFFDCE4ED);
const Color _silverCrease = Color(0xFFB8C2CD);
const Color _silverLow = Color(0xFFA6B0BB);

/// The selected tab's ink: past 7:1 anywhere on the plate.
const Color _inkActive = Color(0xFF0E1419);

/// The other tabs' ink: lighter, still past 4.5:1 on the darkest silver.
const Color _inkIdle = Color(0xFF4A545E);

/// One pixel of light under an engraved glyph.
const List<Shadow> _engraved = [
  Shadow(color: Color(0x99FFFFFF), offset: Offset(0, 1)),
];

const BorderRadius _dockRadius = BorderRadius.all(Radius.circular(34));
const BorderRadius _pillRadius = BorderRadius.all(Radius.circular(29));

/// The silver capsule itself: the plate, its brushing, a rim of light along
/// the top and a soft shadow cast on the content beneath.
class _Dock extends StatelessWidget {
  const _Dock({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: AppBottomNav.dockHeight),
    decoration: const BoxDecoration(
      borderRadius: _dockRadius,
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          _silverHi,
          _silverMid,
          _silverCrease,
          Color(0xFFC6CFD9),
          _silverLow,
        ],
        stops: [0, 0.46, 0.54, 0.84, 1],
      ),
      boxShadow: [
        BoxShadow(
          color: Color(0x99000000),
          blurRadius: 30,
          spreadRadius: -4,
          offset: Offset(0, 10),
        ),
        BoxShadow(
          color: Color(0x80000000),
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    ),
    foregroundDecoration: BoxDecoration(
      borderRadius: _dockRadius,
      border: Border.all(color: const Color(0x8C55606B), width: 0.75),
    ),
    child: ClipRRect(
      borderRadius: _dockRadius,
      child: Stack(
        children: [
          const Positioned.fill(
            child: RepaintBoundary(
              child: CustomPaint(painter: _BrushedMetalPainter()),
            ),
          ),
          // The rim catching the light along the top.
          Positioned(
            left: 20,
            right: 20,
            top: 0,
            child: Container(height: 1, color: const Color(0xF2FFFFFF)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            child: child,
          ),
        ],
      ),
    ),
  );
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ink = active ? _inkActive : _inkIdle;
    return Semantics(
      button: true,
      selected: active,
      inMutuallyExclusiveGroup: true,
      label: label,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          // The active tab is already here — tapping it is a no-op.
          onTap: active ? null : onTap,
          borderRadius: _pillRadius,
          splashColor: const Color(0x22000000),
          highlightColor: const Color(0x11000000),
          child: ExcludeSemantics(
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 58, minWidth: 48),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 220),
                      opacity: active ? 1 : 0,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1),
                        child: _FrostedPill(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 4,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: 24, color: ink, shadows: _engraved),
                        const SizedBox(height: 3),
                        // Never wraps, never overflows: a long translation
                        // ("Classificação", "Minha carreira") shrinks a little
                        // to fit its share.
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            label,
                            maxLines: 1,
                            softWrap: false,
                            textAlign: TextAlign.center,
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 11.5,
                              height: 1.15,
                              letterSpacing: 0.1,
                              fontWeight: active
                                  ? FontWeight.w800
                                  : FontWeight.w700,
                              color: ink,
                              shadows: _engraved,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The selected tab's highlight: frosted glass over the silver, translucent
/// white with a bright rim on top fading to a hint of shade below.
///
/// The rim is the outer box and the fill sits inset in it, because Flutter
/// cannot round a border whose sides differ in colour.
class _FrostedPill extends StatelessWidget {
  const _FrostedPill();

  @override
  Widget build(BuildContext context) => const DecoratedBox(
    decoration: BoxDecoration(
      borderRadius: _pillRadius,
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFFFFFF), Color(0x80FFFFFF), Color(0x4D6E7883)],
        stops: [0, 0.5, 1],
      ),
      boxShadow: [
        BoxShadow(
          color: Color(0x1F000000),
          blurRadius: 6,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Padding(
      padding: EdgeInsets.all(1),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(28)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0x8CFFFFFF), Color(0x59FFFFFF), Color(0x33FFFFFF)],
            stops: [0, 0.5, 1],
          ),
        ),
      ),
    ),
  );
}

/// Fine horizontal brushing, as on machined aluminium: hair strokes of light
/// and shade at a few per cent. Seeded, so it never shimmers between frames.
class _BrushedMetalPainter extends CustomPainter {
  const _BrushedMetalPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(11);
    final paint = Paint()..strokeWidth = 0.45;
    final strokes = (size.height * 7).round();
    for (var i = 0; i < strokes; i++) {
      final y = rnd.nextDouble() * size.height;
      final x = rnd.nextDouble() * size.width;
      final len = 60 + rnd.nextDouble() * size.width * 0.9;
      final light = rnd.nextBool();
      final a = 0.008 + rnd.nextDouble() * 0.022;
      paint.color = (light ? Colors.white : Colors.black).withValues(alpha: a);
      canvas.drawLine(Offset(x - len / 2, y), Offset(x + len / 2, y), paint);
    }
  }

  @override
  bool shouldRepaint(_BrushedMetalPainter old) => false;
}
