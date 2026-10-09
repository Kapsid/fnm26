import 'package:flutter/widgets.dart';

/// One tile of a [DashboardGrid], [span] columns wide out of 12.
class DashboardTile {
  const DashboardTile({required this.span, required this.child})
    : assert(span >= 1 && span <= 12, 'span is 1 to 12');

  final int span;
  final Widget child;
}

/// Lays tiles out on a 12-column grid, left to right, starting a new row when
/// the next tile would not fit. Tiles in a row share the row's height.
///
/// Each row is sized with [IntrinsicHeight], so every tile must be able to
/// report its intrinsic height. That rules out, anywhere inside a tile, a
/// [ListView] or other scrollable, a [LayoutBuilder], and widgets built on one
/// (`WholeText`, and so `YPostTile`): they assert. A tile that needs a list
/// gives it a fixed height (`SizedBox(height: ...)`), which IntrinsicHeight
/// reads without asking the list. A screen whose content must scroll inside a
/// panel uses `Panel(expand: true)` in a Row or Column, not this grid.
class DashboardGrid extends StatelessWidget {
  const DashboardGrid({required this.tiles, this.gap = 12, super.key});

  final List<DashboardTile> tiles;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final rows = <List<DashboardTile>>[];
    var used = 12;
    for (final t in tiles) {
      if (used + t.span > 12) {
        rows.add([]);
        used = 0;
      }
      rows.last.add(t);
      used += t.span;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < rows.length; i++) ...[
          if (i > 0) SizedBox(height: gap),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var j = 0; j < rows[i].length; j++) ...[
                  if (j > 0) SizedBox(width: gap),
                  Expanded(flex: rows[i][j].span, child: rows[i][j].child),
                ],
                // A short row keeps its tiles at their column width.
                if (_spanOf(rows[i]) < 12) ...[
                  SizedBox(width: gap),
                  Expanded(
                    flex: 12 - _spanOf(rows[i]),
                    child: const SizedBox(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }

  static int _spanOf(List<DashboardTile> row) =>
      row.fold(0, (sum, t) => sum + t.span);
}
