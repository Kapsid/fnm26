import 'dart:async';
import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Which family of layouts the app is running.
///
/// Decided once at startup from the first window (see `main.dart`) and held in
/// [formFactorProvider]: the router is built around it, and a tablet is locked
/// to landscape, so it does not change while the app runs.
enum FormFactor {
  phone,
  tablet;

  /// The shortest side, in logical pixels, from which a window is a tablet.
  static const double tabletShortestSide = 600;

  static FormFactor fromLogicalSize(Size size) =>
      size.shortestSide >= tabletShortestSide ? tablet : phone;
}

/// The logical size of a window given its physical size and pixel ratio.
///
/// Returns [Size.zero] when the metrics are not usable yet: a zero or NaN
/// ratio, or an empty physical size (Android reports these before the first
/// metrics arrive).
Size logicalSizeOf(Size physical, double devicePixelRatio) {
  if (!(devicePixelRatio > 0) || !physical.isFinite || physical.isEmpty) {
    return Size.zero;
  }
  return physical / devicePixelRatio;
}

/// The logical size of the physical display the app runs on.
///
/// Unlike the window, this does not shrink when iPadOS letterboxes a
/// landscape-only app held in portrait. Returns [Size.zero] when no display
/// is known or its metrics are unusable.
Size logicalDisplaySizeOf(PlatformDispatcher dispatcher) {
  final display =
      dispatcher.implicitView?.display ?? dispatcher.displays.firstOrNull;
  if (display == null) return Size.zero;
  return logicalSizeOf(display.size, display.devicePixelRatio);
}

/// The startup form factor: the display decides when its size is known,
/// otherwise the window does. Empty sizes on both give a phone.
FormFactor formFactorAtStartup({required Size display, required Size window}) =>
    FormFactor.fromLogicalSize(display.isEmpty ? window : display);

/// The logical size of the first window, waiting briefly for real metrics.
///
/// Deciding from empty metrics would classify every device as a phone, so if
/// the implicit view has no usable size yet this waits for the next metrics
/// change, up to [timeout]. Returns [Size.zero] if there is no view or the
/// size is still empty when the wait ends. Any existing
/// `onMetricsChanged` handler keeps running and is restored afterwards.
Future<Size> firstLogicalWindowSize(
  PlatformDispatcher dispatcher, {
  Duration timeout = const Duration(seconds: 1),
}) async {
  Size sizeNow() {
    final view = dispatcher.implicitView;
    if (view == null) return Size.zero;
    return logicalSizeOf(view.physicalSize, view.devicePixelRatio);
  }

  final immediate = sizeNow();
  if (!immediate.isEmpty) return immediate;

  final completer = Completer<Size>();
  final previous = dispatcher.onMetricsChanged;
  void handler() {
    previous?.call();
    if (completer.isCompleted) return;
    final size = sizeNow();
    if (!size.isEmpty) completer.complete(size);
  }

  dispatcher.onMetricsChanged = handler;
  try {
    return await completer.future.timeout(timeout, onTimeout: sizeNow);
  } finally {
    // Only restore if nobody replaced our handler in the meantime.
    if (identical(dispatcher.onMetricsChanged, handler)) {
      dispatcher.onMetricsChanged = previous;
    }
  }
}

/// The form factor detected at startup. Overridden in `main.dart`; phone when
/// nothing overrides it, which is what every existing test expects.
final Provider<FormFactor> formFactorProvider = Provider<FormFactor>(
  (ref) => FormFactor.phone,
);

extension FormFactorContext on BuildContext {
  /// Whether the window this widget is drawn in is tablet sized RIGHT NOW.
  ///
  /// Differs from [formFactorProvider] when a tablet app is squeezed into a
  /// split-screen window: the shell then steps aside for the phone layout.
  bool get isTabletWindow =>
      FormFactor.fromLogicalSize(MediaQuery.sizeOf(this)) == FormFactor.tablet;
}
