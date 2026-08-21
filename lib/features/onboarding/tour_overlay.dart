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

  /// How much room to leave around it, so the ring does not sit on the glyphs.
  static const double _padding = 6;

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
    final context = key.currentContext;
    if (context == null) {
      // The screen has not built it — or this save has no such control. The
      // step still reads; it just dims everything, as it used to.
      if (_hole != null && mounted) setState(() => _hole = null);
      return;
    }
    await Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 250),
      alignment: 0.5,
    );
    if (!mounted) return;
    final box = key.currentContext?.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return;
    final origin = box.localToGlobal(Offset.zero);
    final rect = (origin & box.size).inflate(_padding);
    if (rect != _hole) setState(() => _hole = rect);
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
      if (careerId != null) context.go('$route?careerId=$careerId');
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
    if (careerId == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.go('${Routes.hub}?careerId=$careerId');
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
      return widget.child;
    }
    _goTo(step);
    // ALWAYS, not only after a navigation. Tying the measuring to the
    // navigation meant that any step which did not navigate — a second step on
    // the same screen, or any step at all when there was no save to navigate
    // with — lit nothing, and the tour silently became a curtain.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _locate(kTourSteps[step].target),
    );

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
            child: CustomPaint(
              painter: SpotlightPainter(hole: _hole, radius: AppRadii.md),
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
