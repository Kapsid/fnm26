import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/shared/tablet/tablet_text.dart';

/// A list on the left and the picked item's detail on the right, split by a
/// divider the player can drag.
class MasterDetail extends StatefulWidget {
  const MasterDetail({
    required this.master,
    this.detail,
    this.placeholder,
    this.initialFraction = 0.4,
    this.minFraction = 0.25,
    this.maxFraction = 0.6,
    this.minDetailWidth = 0,
    super.key,
  });

  static const Key dividerKey = Key('masterDetail.divider');

  /// The divider's touch target. Only a 1px line is drawn in it, but a finger
  /// needs 24 to 32 points to find it.
  static const double dividerWidth = 28;

  final Widget master;
  final Widget? detail;
  final Widget? placeholder;
  final double initialFraction;
  final double minFraction;
  final double maxFraction;

  /// The narrowest the detail side may get, in logical px. The effective
  /// maximum fraction is clamped from the real width so the detail keeps at
  /// least this much, whatever the divider or the window does.
  final double minDetailWidth;

  @override
  State<MasterDetail> createState() => _MasterDetailState();
}

class _MasterDetailState extends State<MasterDetail> {
  late double _fraction = widget.initialFraction;

  /// Where the finger is, as a fraction, for the length of one drag. Kept
  /// unclamped so a finger that goes past a limit and comes back finds the
  /// divider under it again, rather than ahead of it by the overshoot.
  double? _dragFraction;

  double _effectiveMax(double width) {
    if (widget.minDetailWidth <= 0) return widget.maxFraction;
    final room =
        (width - MasterDetail.dividerWidth - widget.minDetailWidth) / width;
    return math.min(widget.maxFraction, room);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        // Nothing to split: a zero-width first frame, or a parent collapsing.
        if (!width.isFinite || width <= MasterDetail.dividerWidth) {
          return const SizedBox.shrink();
        }
        final maxFraction = _effectiveMax(width);
        final minFraction = math.min(widget.minFraction, maxFraction);
        final fraction = _fraction.clamp(minFraction, maxFraction);
        final masterWidth = width * fraction;
        return Row(
          children: [
            SizedBox(width: masterWidth, child: widget.master),
            MouseRegion(
              cursor: SystemMouseCursors.resizeColumn,
              child: GestureDetector(
                key: MasterDetail.dividerKey,
                behavior: HitTestBehavior.opaque,
                dragStartBehavior: DragStartBehavior.down,
                onHorizontalDragStart: (_) => _dragFraction = fraction,
                onHorizontalDragUpdate: (d) => setState(() {
                  final raw =
                      (_dragFraction ?? fraction) + d.delta.dx / width;
                  _dragFraction = raw;
                  _fraction = raw.clamp(minFraction, maxFraction);
                }),
                onHorizontalDragEnd: (_) => _dragFraction = null,
                onHorizontalDragCancel: () => _dragFraction = null,
                child: SizedBox(
                  width: MasterDetail.dividerWidth,
                  child: Center(
                    child: Container(
                      width: 1,
                      color: AppColors.outlineVariant,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child:
                  widget.detail ??
                  widget.placeholder ??
                  const SizedBox.shrink(),
            ),
          ],
        );
      },
    );
  }
}

/// What the detail side says while nothing is picked.
class MasterDetailPlaceholder extends StatelessWidget {
  const MasterDetailPlaceholder({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Center(
    child: Text(
      text,
      style: TabletText.cell.copyWith(color: AppColors.outline),
    ),
  );
}
