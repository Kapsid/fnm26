import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Tiles in as many equal columns as fit, row by row: the tablet's grid of
/// group tables.
///
/// The column count is how many [minTileWidth] tiles fit side by side with
/// [gap] between them, at least one and at most [maxColumns]. Tiles in a row
/// share the row's height (each row is an [IntrinsicHeight]), so a tile must
/// be able to report its intrinsic height: no [ListView], [LayoutBuilder] or
/// `WholeText` inside one. With one column the tiles are stacked [gap] apart.
///
/// Sits inside a vertical scroll view and sizes itself to its content. It is
/// built on a [LayoutBuilder] itself, so it must not go inside a
/// `DashboardGrid` tile.
class ColumnFlow extends StatelessWidget {
  const ColumnFlow({
    required this.children,
    this.minTileWidth = 280,
    this.maxColumns = 3,
    this.gap = 12,
    super.key,
  }) : assert(maxColumns >= 1, 'at least one column');

  final List<Widget> children;
  final double minTileWidth;
  final int maxColumns;
  final double gap;

  /// How many columns [width] holds.
  static int columnsFor(
    double width, {
    double minTileWidth = 280,
    int maxColumns = 3,
    double gap = 12,
  }) {
    if (!width.isFinite) return 1;
    final fit = ((width + gap) / (minTileWidth + gap)).floor();
    return math.max(1, math.min(maxColumns, fit));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        final columns = columnsFor(
          box.maxWidth,
          minTileWidth: minTileWidth,
          maxColumns: maxColumns,
          gap: gap,
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < children.length; i += columns) ...[
              if (i > 0) SizedBox(height: gap),
              if (columns == 1)
                children[i]
              else
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (var j = 0; j < columns; j++) ...[
                        if (j > 0) SizedBox(width: gap),
                        Expanded(
                          child: i + j < children.length
                              ? children[i + j]
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          ],
        );
      },
    );
  }
}
