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
    super.key,
  });

  static const Key dividerKey = Key('masterDetail.divider');

  final Widget master;
  final Widget? detail;
  final Widget? placeholder;
  final double initialFraction;
  final double minFraction;
  final double maxFraction;

  @override
  State<MasterDetail> createState() => _MasterDetailState();
}

class _MasterDetailState extends State<MasterDetail> {
  static const double _dividerWidth = 12;
  late double _fraction = widget.initialFraction;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final masterWidth = width * _fraction;
        return Row(
          children: [
            SizedBox(width: masterWidth, child: widget.master),
            MouseRegion(
              cursor: SystemMouseCursors.resizeColumn,
              child: GestureDetector(
                key: MasterDetail.dividerKey,
                behavior: HitTestBehavior.opaque,
                dragStartBehavior: DragStartBehavior.down,
                onHorizontalDragUpdate: (d) => setState(() {
                  _fraction = ((masterWidth + d.delta.dx) / width).clamp(
                    widget.minFraction,
                    widget.maxFraction,
                  );
                }),
                child: SizedBox(
                  width: _dividerWidth,
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
