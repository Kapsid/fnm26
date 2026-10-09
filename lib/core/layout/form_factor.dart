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
