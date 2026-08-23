import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/features/onboarding/tour_providers.dart';
import 'package:fnm/features/onboarding/tour_steps.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// The guided tour, drawn over whatever screen it has navigated to.
///
/// It dims the real screen rather than describing it: what the manager reads
/// about is the thing behind the scrim, so when the tour ends he is looking at
/// somewhere he has already been.
///
/// Navigation is `go` per step, never `push`, so the tour cannot build a stack
/// behind itself and leaving lands on the hub from any step.
class TourOverlay extends ConsumerStatefulWidget {
  const TourOverlay({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<TourOverlay> createState() => _TourOverlayState();
}

class _TourOverlayState extends ConsumerState<TourOverlay> {
  int? _navigatedFor;

  /// Where the control being talked about actually is, in global coordinates.
  Rect? _hole;

  /// The step [_hole] belongs to, so a rebuild does not start the search over.
  int? _locatedFor;

  /// The painting surface itself, so a control's position can be converted
  /// into the coordinates the scrim is actually drawn in.
  ///
  /// localToGlobal gives a rect in SCREEN space, and the canvas is in the
  /// overlay's own — identical only while the overlay starts exactly at the
  /// screen's top-left. Anything that insets it, now or later, shifts every
  /// ring by that inset, which is the highlight sitting a little off the
  /// control with no obvious cause. Converting explicitly costs one lookup
  /// and cannot drift.
  final GlobalKey _surfaceKey = GlobalKey(debugLabel: 'tour.surface');

  /// How long the light takes to travel, and the caption to change ends.
  ///
  /// Long enough to be followed by eye, short enough not to be a wait: the
  /// whole point is that the manager sees WHERE it went.
  static const Duration _moveDuration = Duration(milliseconds: 320);

  /// How much room to leave around it, so the ring does not sit on the glyphs.
  static const double _padding = 6;

  /// A rect trimmed to what is actually on screen, or null if the control is
  /// not really visible.
  ///
  /// A control can sit off the edge — a list that would not scroll far enough,
  /// a row half under the app bar — and lighting it there draws a ring hanging
  /// off the side of the screen around nothing, which is worse than not
  /// lighting it at all. Trimmed if it overlaps, dropped if it does not.
  /// Where [box] sits on the canvas, or null when it is not really visible.
  ///
  /// Mapped through the actual transform between the two, rather than by
  /// translating a corner: a route mid-transition, or anything scaled or
  /// rotated between the control and the scrim, moves the box in ways two
  /// corner points do not describe — which is a ring a few pixels out from
  /// what it is meant to be around.
  Rect? _onScreen(RenderBox box) {
    final surface = _surfaceKey.currentContext?.findRenderObject();
    if (surface is! RenderBox || !surface.hasSize) return null;
    final rect = MatrixUtils.transformRect(
      box.getTransformTo(surface),
      Offset.zero & box.size,
    ).inflate(_padding);
    final bounds = Offset.zero & surface.size;
    if (!rect.overlaps(bounds)) return null;
    final clipped = rect.intersect(bounds);
    // A sliver of a control is not the control.
    if (clipped.width < 8 || clipped.height < 8) return null;
    return clipped;
  }

  /// Finds the step's target on screen and remembers its rect.
  ///
  /// Scrolls it into view first — a control the manager cannot see is not one
  /// he can be shown — and re-measures on the frame after, because the rect
  /// before a scroll is not the rect after one.
  Future<void> _locate(GlobalKey? key) async {
    if (key == null) {
      if (_hole != null && mounted) setState(() => _hole = null);
      return;
    }
    // A screen does not finish arriving in one frame: the route builds, its
    // providers resolve, a list lays out. Looking once and giving up meant a
    // step whose screen was still loading fell back to dimming everything and
    // stayed that way, because nothing looks again. So look for a while.
    // Waited out in FRAMES, not on a timer. What the target is waiting for is
    // frames — the route building, its providers resolving, a list laying out
    // — so a frame is the honest unit, and a timer left pending outlives the
    // screen it was watching.
    var context = key.currentContext;
    for (var attempt = 0; attempt < 12 && context == null; attempt++) {
      WidgetsBinding.instance.scheduleFrame();
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted) return;
      context = key.currentContext;
    }
    if (context == null) {
      // Genuinely not on this screen — a control this save does not have. The
      // step still reads; it just dims everything.
      if (_hole != null && mounted) setState(() => _hole = null);
      return;
    }
    await Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 250),
      alignment: 0.5,
    );
    if (!mounted) return;

    // Measured until it STOPS MOVING, not once.
    //
    // A route transition slides, ensureVisible scrolls, a list settles — and a
    // rect read in the middle of any of that is a rect the control has already
    // left, which is the ring sitting slightly off the thing it is meant to be
    // around. Two identical readings in a row mean the screen has come to
    // rest; the cap stops a permanently animating screen from spinning here.
    Rect? previous;
    for (var frame = 0; frame < 30; frame++) {
      WidgetsBinding.instance.scheduleFrame();
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted) return;
      final box = key.currentContext?.findRenderObject();
      if (box is! RenderBox || !box.hasSize) return;
      final rect = _onScreen(box);
      if (rect == previous) {
        if (rect != _hole) setState(() => _hole = rect);
        return;
      }
      previous = rect;
    }
    // Never settled — light where it last was rather than not at all.
    if (previous != _hole) setState(() => _hole = previous);
  }

  void _goTo(int index) {
    final careerId = ref.read(tourCareerProvider);
    final route = kTourSteps[index].route;
    // Guard against navigating on every rebuild — the overlay rebuilds
    // whenever the screen underneath it does.
    if (_navigatedFor == index) return;
    _navigatedFor = index;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      // No save to walk through — a replay from Settings, say, before one is
      // open. The step still reads and still lights whatever it can find on
      // the screen already showing.
      // Through the ROUTER, not through this context.
      //
      // The overlay is built by MaterialApp.router's builder, which sits above
      // the Navigator — so context.go() had no InheritedGoRouter to find and
      // navigated nowhere. Every step after the first stayed on the hub, only
      // the steps whose target happened to be on the hub ever lit up, and the
      // tour read as a caption box counting to ten.
      if (careerId != null) {
        ref.read(routerProvider).go('$route?careerId=$careerId');
      }
      // Two frames: one for the route to build, one for it to lay out. Only
      // then does the target have a position worth measuring.
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted) return;
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted) return;
      await _locate(kTourSteps[index].target);
    });
  }

  void _finish() {
    final careerId = ref.read(tourCareerProvider);
    endTour(ref);
    _navigatedFor = null;
    _locatedFor = null;
    if (careerId == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(routerProvider).go('${Routes.hub}?careerId=$careerId');
    });
  }

  /// Whether the caption belongs at the top, because the hole is at the
  /// bottom. Judged against the middle of the screen.
  bool get _captionAtTop {
    final rect = _hole;
    if (rect == null) return false;
    final height = MediaQuery.sizeOf(context).height;
    return rect.center.dy > height / 2;
  }

  @override
  Widget build(BuildContext context) {
    final step = ref.watch(tourStepProvider);
    if (step == null || step < 0 || step >= kTourSteps.length) {
      _navigatedFor = null;
      _locatedFor = null;
      return widget.child;
    }
    _goTo(step);
    // Measured for every step, not only the ones that navigate — a second step
    // on the same screen moves the light without moving the page, and tying
    // the two together left those steps dark. Once per step, though: _locate
    // retries for a screen that is still arriving, and starting that over on
    // every rebuild would be a treadmill.
    if (_locatedFor != step) {
      _locatedFor = step;
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _locate(kTourSteps[step].target),
      );
    }

    final l = AppLocalizations.of(context);
    final current = kTourSteps[step];
    final last = step == kTourSteps.length - 1;

    return Stack(
      children: [
        widget.child,
        // Nothing behind the scrim is tappable: a tour that lets you set a
        // budget half way through it is not a tour, it is a modal argument.
        Positioned.fill(
          child: AbsorbPointer(
            // The light MOVES from one control to the next rather than
            // blinking out and reappearing somewhere else. A cut that jumps
            // reads as two separate things being lit; a cut that travels reads
            // as one thing being pointed at, and the eye follows it without
            // having to search the screen again.
            child: _hole == null
                // Nothing to travel to or from: a plain curtain, drawn at once.
                ? CustomPaint(
                    key: _surfaceKey,
                    painter: const SpotlightPainter(
                      hole: null,
                      radius: AppRadii.md,
                    ),
                  )
                : TweenAnimationBuilder<Rect?>(
                    // Only `end` is given: TweenAnimationBuilder interpolates
                    // from whatever it last showed, which is the previous
                    // control's rect — so the light glides between them
                    // instead of blinking out and reappearing.
                    tween: RectTween(end: _hole),
                    duration: _moveDuration,
                    curve: Curves.easeInOutCubic,
                    builder: (context, hole, _) => CustomPaint(
                      key: _surfaceKey,
                      painter: SpotlightPainter(
                        hole: hole ?? _hole,
                        radius: AppRadii.md,
                      ),
                    ),
                  ),
          ),
        ),
        Positioned.fill(
          child: Align(
            // Above the lit control when it sits low on the screen, below it
            // otherwise: a caption that covers the thing it is describing is
            // the one arrangement that cannot work.
            alignment: _captionAtTop
                ? Alignment.topCenter
                : Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.marginMobile),
                child: Material(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: AppRadii.mdAll,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                current.title(l),
                                style: AppTypography.titleMedium.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            Text(
                              '${step + 1}/${kTourSteps.length}',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(current.body(l), style: AppTypography.bodySmall),
                        const SizedBox(height: AppSpacing.md),
                        // Skip and Back sit inline; the step forward is the
                        // full-width primary action, which is this app's
                        // language for "the thing to do next" — and the only
                        // shape a FilledButton can take here anyway, since the
                        // theme gives it Size.fromHeight, an infinite width
                        // minimum that cannot be laid out in a Row.
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: _finish,
                              child: Text(l.tourSkip),
                            ),
                            if (step > 0)
                              TextButton(
                                onPressed: () {
                                  _navigatedFor = null;
                                  _locatedFor = null;
                                  ref.read(tourStepProvider.notifier).state =
                                      step - 1;
                                },
                                child: Text(l.tourBack),
                              ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        PrimaryButton(
                          label: last ? l.tourDone : l.tourNext,
                          onPressed: () {
                            if (last) {
                              _finish();
                            } else {
                              _navigatedFor = null;
                              _locatedFor = null;
                              ref.read(tourStepProvider.notifier).state =
                                  step + 1;
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Paints the scrim with a hole in it.
///
/// Public so a test can read [hole] back: "the overlay drew something" is not
/// the same claim as "the overlay lit the right control", and only the second
/// one is the feature.
///
/// The hole is what makes this a tour rather than a curtain: everything is
/// dimmed EXCEPT the control being talked about, which stays at full
/// brightness with a ring around it.
class SpotlightPainter extends CustomPainter {
  const SpotlightPainter({required this.hole, required this.radius});

  /// The control's rect in global coordinates, or null for no cut-out.
  final Rect? hole;
  final double radius;

  static const _scrim = Color(0xB8000000);

  @override
  void paint(Canvas canvas, Size size) {
    final full = Offset.zero & size;
    final target = hole;
    if (target == null) {
      canvas.drawRect(full, Paint()..color = _scrim);
      return;
    }
    final cut = RRect.fromRectAndRadius(target, Radius.circular(radius));
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(full),
        Path()..addRRect(cut),
      ),
      Paint()..color = _scrim,
    );
    canvas.drawRRect(
      cut,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = AppColors.primary,
    );
  }

  @override
  bool shouldRepaint(SpotlightPainter old) =>
      old.hole != hole || old.radius != radius;
}
