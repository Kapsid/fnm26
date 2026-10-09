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
class DataGrid<T> extends StatefulWidget {
  const DataGrid({
    required this.rows,
    required this.columnSets,
    this.selected,
    this.onSelect,
    super.key,
  }) : assert(columnSets.length > 0, 'at least one column set');

  static const double rowHeight = 36;

  final List<T> rows;
  final List<GridColumnSet<T>> columnSets;
  final T? selected;
  final ValueChanged<T>? onSelect;

  @override
  State<DataGrid<T>> createState() => _DataGridState<T>();
}

class _DataGridState<T> extends State<DataGrid<T>> {
  late GridColumnSet<T> _set = widget.columnSets.first;
  String? _sortId;
  bool _ascending = true;

  List<GridColumn<T>> get _columns => _set.columns;

  List<T> get _sorted {
    final column = _columns.where((c) => c.id == _sortId).firstOrNull;
    final key = column?.sortKey;
    if (key == null) return widget.rows;
    final rows = [...widget.rows]
      ..sort((a, b) {
        final c = key(a).compareTo(key(b));
        return _ascending ? c : -c;
      });
    return rows;
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
    _set = s;
    if (!s.columns.any((c) => c.id == _sortId)) _sortId = null;
  });

  @override
  Widget build(BuildContext context) {
    final rows = _sorted;
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
                    selected: s.id == _set.id,
                    onSelected: (_) => _pickSet(s),
                  ),
              ],
            ),
          ),
        Container(
          height: 30,
          color: AppColors.surfaceContainer,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              for (final c in _columns)
                _cellBox(
                  c,
                  InkWell(
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
            ],
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
                        for (final c in _columns)
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
