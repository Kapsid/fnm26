import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// The manager's chosen text size, layered on top of the phone's own
/// accessibility text scale.
enum TextSize {
  normal(1),
  large(1.1),
  larger(1.2);

  const TextSize(this.factor);

  /// How much bigger than the phone's own text scale the app's text is drawn.
  final double factor;

  /// The stored name back to the option; unknown or absent means [normal].
  static TextSize fromName(String? name) =>
      TextSize.values.firstWhere((t) => t.name == name, orElse: () => normal);
}

/// The most the app's text is ever scaled, the phone's setting and the
/// manager's choice combined. Past this the busiest screens (squad lists,
/// tables, the match read-out) stop fitting a phone.
const double kMaxAppTextScale = 1.4;

/// The text scaler the app draws with: the phone's [system] scaler times the
/// chosen [size], never past [kMaxAppTextScale].
///
/// At [TextSize.normal] with the phone's scale already under the ceiling the
/// phone's own scaler is returned untouched, so nothing changes for anybody
/// who has not asked for bigger text.
TextScaler appTextScaler(TextScaler system, TextSize size) {
  if (size == TextSize.normal && system.scale(14) / 14 <= kMaxAppTextScale) {
    return system;
  }
  return _ProductTextScaler(system, size.factor, kMaxAppTextScale);
}

/// [base] (possibly nonlinear, as Android 14's is) times [factor], capped at
/// [max] times the unscaled size.
@immutable
class _ProductTextScaler extends TextScaler {
  const _ProductTextScaler(this.base, this.factor, this.max);

  final TextScaler base;
  final double factor;
  final double max;

  @override
  double scale(double fontSize) =>
      math.min(base.scale(fontSize) * factor, fontSize * max);

  @override
  // Still abstract on TextScaler, so it has to be implemented.
  // ignore: deprecated_member_use
  double get textScaleFactor => math.min(base.textScaleFactor * factor, max);

  @override
  bool operator ==(Object other) =>
      other is _ProductTextScaler &&
      other.base == base &&
      other.factor == factor &&
      other.max == max;

  @override
  int get hashCode => Object.hash(base, factor, max);
}

/// Applies the app text scale to everything below it. Sits in the
/// MaterialApp's builder so every route, sheet and dialog inherits it.
class AppTextScale extends StatelessWidget {
  const AppTextScale({required this.size, required this.child, super.key});

  final TextSize size;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final system = MediaQuery.textScalerOf(context);
    final scaler = appTextScaler(system, size);
    if (identical(scaler, system)) return child;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: scaler),
      child: child,
    );
  }
}

/// How many pixels [lineHeight] worth of text gains at the current text
/// scale, rounded up; zero at (or below) the normal size.
///
/// For the few boxes that must keep a fixed height (fixed-extent lists, a
/// bracket's tie slots, a tile row): add this to the height they were sized
/// for at the normal text size, and they hold their text at any size while
/// staying exactly as they were at the normal one.
double textScaleGrowth(BuildContext context, double lineHeight) {
  final grow = MediaQuery.textScalerOf(context).scale(lineHeight) - lineHeight;
  return grow > 0 ? grow.ceilToDouble() : 0;
}
