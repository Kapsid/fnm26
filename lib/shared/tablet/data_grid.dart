import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/shared/tablet/tablet_text.dart';

/// One column of a [DataGrid].
class GridColumn<T> {
  const GridColumn({
    required this.id,
    required this.label,
    required this.cell,
    this.sortKey,
    this.width,
    this.flex = 1,
    this.numeric = false,
  });

  final String id;
  final String label;
  final Widget Function(T row) cell;

  /// Null makes the column unsortable.
  final Comparable<dynamic> Function(T row)? sortKey;

  /// A fixed width; when null the column takes [flex] shares of what is left.
  final double? width;
  final int flex;

  /// Right-aligned, and sorted high to low on the first tap.
  final bool numeric;
}

/// A named set of columns: one "view" of the same rows (Overview, Attributes).
class GridColumnSet<T> {
  const GridColumnSet({
    required this.id,
    required this.label,
    required this.columns,
  });

  final String id;
  final String label;
  final List<GridColumn<T>> columns;
}

/// The tablet's table: sticky header, tap a header to sort (again to reverse),
/// zebra rows, a highlighted selection, and several column views of the same
/// rows. Rows are built lazily, so a 2000-row list costs a screenful.
///
/// Pass a NEW list when the rows change. The sorted order is cached against
/// the list's identity, so a list mutated in place keeps its old order.
class DataGrid<T> extends StatefulWidget {
  const DataGrid({
    required this.rows,
    required this.columnSets,
    this.selected,
    this.onSelect,
    super.key,
  }) : assert(columnSets.length > 0, 'at least one column set');

  static const double rowHeight = 36;

  /// The header row: as tall as a body row, so each column title is a whole
  /// tap target rather than a strip of text.
  static const double headerHeight = 36;
  static const Key headerKey = Key('dataGrid.header');
  static const Key scrollKey = Key('dataGrid.scroll');

  /// The least a flexible column is given before the table scrolls sideways.
  static const double minFlexWidth = 120;

  final List<T> rows;
  final List<GridColumnSet<T>> columnSets;
  final T? selected;
  final ValueChanged<T>? onSelect;

  @override
  State<DataGrid<T>> createState() => _DataGridState<T>();
}

class _DataGridState<T> extends State<DataGrid<T>> {
  /// The active view, kept by id so a parent's new [GridColumnSet] objects
  /// take effect; resolved against [DataGrid.columnSets] on every read.
  late String _setId = widget.columnSets.first.id;
  String? _sortId;
  bool _ascending = true;

  // Sorted rows are cached and rebuilt only when the rows or column sets
  // change (see didUpdateWidget) or the view or sort does.
  List<T>? _sortedRows;
  String? _sortedSetId;
  String? _sortedSortId;
  bool _sortedAscending = true;

  GridColumnSet<T> get _set => widget.columnSets.firstWhere(
    (s) => s.id == _setId,
    orElse: () => widget.columnSets.first,
  );

  @override
  void didUpdateWidget(DataGrid<T> old) {
    super.didUpdateWidget(old);
    // A view or sort column the parent removed falls back to the first view
    // and no sort, so the header and the rows never disagree.
    final set = _set;
    _setId = set.id;
    if (!set.columns.any((c) => c.id == _sortId)) _sortId = null;
    if (!identical(old.rows, widget.rows) ||
        !identical(old.columnSets, widget.columnSets)) {
      _sortedRows = null;
    }
  }

  List<T> _rowsFor(GridColumnSet<T> set) {
    final column = set.columns.where((c) => c.id == _sortId).firstOrNull;
    final key = column?.sortKey;
    if (key == null) return widget.rows;
    if (_sortedRows != null &&
        _sortedSetId == set.id &&
        _sortedSortId == _sortId &&
        _sortedAscending == _ascending) {
      return _sortedRows!;
    }
    final rows = widget.rows;
    final keys = [for (final r in rows) key(r)];
    // Ties fall back to the incoming index in both directions, so equal keys
    // keep the order they arrived in (List.sort is not stable by itself).
    final order = List<int>.generate(rows.length, (i) => i)
      ..sort((a, b) {
        final c = keys[a].compareTo(keys[b]);
        if (c != 0) return _ascending ? c : -c;
        return a.compareTo(b);
      });
    _sortedSetId = set.id;
    _sortedSortId = _sortId;
    _sortedAscending = _ascending;
    return _sortedRows = [for (final i in order) rows[i]];
  }

  void _tapHeader(GridColumn<T> c) {
    if (c.sortKey == null) return;
    setState(() {
      if (_sortId == c.id) {
        _ascending = !_ascending;
      } else {
        _sortId = c.id;
        _ascending = !c.numeric;
      }
    });
  }

  void _pickSet(GridColumnSet<T> s) => setState(() {
    _setId = s.id;
    if (!s.columns.any((c) => c.id == _sortId)) _sortId = null;
  });

  @override
  Widget build(BuildContext context) {
    final set = _set;
    final columns = set.columns;
    final rows = _rowsFor(set);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.columnSets.length > 1)
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Wrap(
              spacing: AppSpacing.xs,
              children: [
                for (final s in widget.columnSets)
                  ChoiceChip(
                    label: Text(s.label),
                    selected: s.id == set.id,
                    onSelected: (_) => _pickSet(s),
                  ),
              ],
            ),
          ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, box) {
              final minWidth = _minContentWidth(columns);
              final table = _table(columns, rows);
              if (!box.maxWidth.isFinite || minWidth <= box.maxWidth) {
                return table;
              }
              // Too narrow for the columns: one horizontal scroll carries the
              // header and the rows together, so they stay aligned.
              return SingleChildScrollView(
                key: DataGrid.scrollKey,
                scrollDirection: Axis.horizontal,
                child: SizedBox(width: minWidth, child: table),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Row padding plus every fixed width and a floor for each flexible column.
  double _minContentWidth(List<GridColumn<T>> columns) {
    var w = 24.0;
    for (final c in columns) {
      w += c.width ?? DataGrid.minFlexWidth;
    }
    return w;
  }

  Widget _table(List<GridColumn<T>> columns, List<T> rows) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // A Material, not a coloured Container: the header cells' InkWells
        // paint on the nearest Material, and a Container's colour hid them.
        Material(
          key: DataGrid.headerKey,
          color: AppColors.surfaceContainer,
          child: SizedBox(
            height: DataGrid.headerHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  for (final c in columns)
                    _cellBox(
                      c,
                      Semantics(
                        container: true,
                        button: c.sortKey != null,
                        selected: c.id == _sortId,
                        child: InkWell(
                          onTap: () => _tapHeader(c),
                          child: Row(
                            mainAxisAlignment: c.numeric
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                  c.label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TabletText.header.copyWith(
                                    color: c.id == _sortId
                                        ? AppColors.onSurface
                                        : null,
                                  ),
                                ),
                              ),
                              if (c.id == _sortId)
                                Icon(
                                  _ascending
                                      ? Icons.arrow_drop_up
                                      : Icons.arrow_drop_down,
                                  size: 16,
                                  color: AppColors.onSurface,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: rows.length,
            itemExtent: DataGrid.rowHeight,
            itemBuilder: (context, i) {
              final row = rows[i];
              final selected =
                  widget.selected != null && row == widget.selected;
              return Material(
                color: selected
                    ? AppColors.surfaceContainerHighest
                    : i.isOdd
                    ? AppColors.onSurface.withValues(alpha: 0.015)
                    : Colors.transparent,
                child: InkWell(
                  onTap: widget.onSelect == null
                      ? null
                      : () => widget.onSelect!(row),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppColors.divider),
                      ),
                    ),
                    child: Row(
                      children: [
                        for (final c in columns)
                          _cellBox(
                            c,
                            Align(
                              alignment: c.numeric
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: DefaultTextStyle.merge(
                                style: c.numeric
                                    ? TabletText.cellNumeric
                                    : TabletText.cell,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                child: c.cell(row),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _cellBox(GridColumn<T> c, Widget child) => c.width != null
      ? SizedBox(width: c.width, child: child)
      : Expanded(flex: c.flex, child: child);
}
