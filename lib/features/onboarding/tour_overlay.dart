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
  const TourOverlay({required this.careerId, required this.child, super.key});

  /// The save being toured. The tour is about screens, but every screen in a
  /// save needs to know which one.
  final int? careerId;

  final Widget child;

  @override
  ConsumerState<TourOverlay> createState() => _TourOverlayState();
}

class _TourOverlayState extends ConsumerState<TourOverlay> {
  int? _navigatedFor;

  void _goTo(int index) {
    final careerId = widget.careerId;
    if (careerId == null) return;
    final route = kTourSteps[index].route;
    // Guard against navigating on every rebuild — the overlay rebuilds
    // whenever the screen underneath it does.
    if (_navigatedFor == index) return;
    _navigatedFor = index;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.go('$route?careerId=$careerId');
    });
  }

  void _finish() {
    final careerId = widget.careerId;
    endTour(ref);
    _navigatedFor = null;
    if (careerId == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.go('${Routes.hub}?careerId=$careerId');
    });
  }

  @override
  Widget build(BuildContext context) {
    final step = ref.watch(tourStepProvider);
    if (step == null || step < 0 || step >= kTourSteps.length) {
      _navigatedFor = null;
      return widget.child;
    }
    _goTo(step);

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
            child: ColoredBox(color: Colors.black.withValues(alpha: 0.72)),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
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
