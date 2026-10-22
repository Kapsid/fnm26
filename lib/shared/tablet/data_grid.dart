import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/util/caps.dart';
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
    this.gapBefore = 0,
    this.firstAscending,
    this.tooltip,
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

  /// Empty room at the column's left edge, header and cells alike, so a
  /// left-aligned column never runs into a right-aligned number before it.
  final double gapBefore;

  /// The direction of the first tap's sort; null takes it from [numeric]
  /// (numbers high to low, text A to Z). A place (1st, 2nd) is a number read
  /// low to high.
  final bool? firstAscending;

  /// What the header says on a long press or hover, for a title too short
  /// to explain itself. Null adds nothing.
  final String? tooltip;
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

/// Lets a screen find and scroll to a row in the grid's CURRENT order, which
/// the grid sorts privately. Pass one to [DataGrid.rowsController].
class DataGridController<T> {
  _DataGridState<T>? _state;

  /// Whether a grid is showing rows for this controller.
  bool get isAttached => _state != null;

  /// Where [row] sits in the order on screen, or -1 when it is not there.
  int indexOf(T row) => _state?._indexOf(row) ?? -1;

  /// Scrolls so [row] is centred in the visible rows; false when the grid is
  /// not showing it. When the columns scroll sideways this is still the rows'
  /// vertical scroll.
  bool revealRow(T row, {bool animate = false}) =>
      _state?._reveal(row, animate: animate) ?? false;
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
    this.controller,
    this.rowsController,
    this.initialSortId,
    this.initialAscending = false,
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

  /// The rows' vertical scroll, for a screen that scrolls the table itself
  /// ("centre on my nation"). The header never scrolls.
  final ScrollController? controller;

  /// Finds and reveals rows by value in the grid's sorted order.
  final DataGridController<T>? rowsController;

  /// The column the rows arrive sorted by, if any: its header carries the
  /// sort arrow from the start, so the first tap on it reverses the order
  /// rather than "sorting" into the order already on screen. The grid sorts
  /// by it too (stably, so rows already in that order keep it), and a view
  /// that has the column returns to it. Null (the default) shows the rows as
  /// given with no arrow.
  final String? initialSortId;

  /// The direction of [initialSortId]'s order: false is high to low.
  final bool initialAscending;

  @override
  State<DataGrid<T>> createState() => _DataGridState<T>();
}

class _DataGridState<T> extends State<DataGrid<T>> {
  /// The active view, kept by id so a parent's new [GridColumnSet] objects
  /// take effect; resolved against [DataGrid.columnSets] on every read.
  late String _setId = widget.columnSets.first.id;
  late String? _sortId = _initialSortFor(widget.columnSets.first);
  late bool _ascending = widget.initialAscending;

  /// [DataGrid.initialSortId] when [set] has that column, else no sort.
  String? _initialSortFor(GridColumnSet<T> set) {
    final id = widget.initialSortId;
    return id != null && set.columns.any((c) => c.id == id) ? id : null;
  }

  /// The sort a view falls back to when it lacks the current sort column.
  void _resetSortFor(GridColumnSet<T> set) {
    _sortId = _initialSortFor(set);
    _ascending = widget.initialAscending;
  }

  // Sorted rows are cached and rebuilt only when the rows or column sets
  // change (see didUpdateWidget) or the view or sort does.
  List<T>? _sortedRows;
  String? _sortedSetId;
  String? _sortedSortId;
  bool _sortedAscending = true;

  ScrollController? _ownScroll;
  ScrollController get _scroll =>
      widget.controller ?? (_ownScroll ??= ScrollController());

  int _indexOf(T row) => _rowsFor(_set).indexOf(row);

  bool _reveal(T row, {bool animate = false}) {
    final index = _indexOf(row);
    final scroll = _scroll;
    if (index < 0 || !scroll.hasClients) return false;
    final position = scroll.position;
    final target =
        (index * DataGrid.rowHeight +
                DataGrid.rowHeight / 2 -
                position.viewportDimension / 2)
            .clamp(0.0, position.maxScrollExtent);
    if (animate) {
      scroll.animateTo(
        target,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    } else {
      scroll.jumpTo(target);
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    widget.rowsController?._state = this;
  }

  @override
  void dispose() {
    if (widget.rowsController?._state == this) {
      widget.rowsController!._state = null;
    }
    _ownScroll?.dispose();
    super.dispose();
  }

  GridColumnSet<T> get _set => widget.columnSets.firstWhere(
    (s) => s.id == _setId,
    orElse: () => widget.columnSets.first,
  );

  @override
  void didUpdateWidget(DataGrid<T> old) {
    super.didUpdateWidget(old);
    if (old.rowsController != widget.rowsController) {
      if (old.rowsController?._state == this) old.rowsController!._state = null;
      widget.rowsController?._state = this;
    }
    // A view or sort column the parent removed falls back to the first view
    // and the initial sort (or none), so the header and the rows never
    // disagree.
    final set = _set;
    _setId = set.id;
    if (_sortId != null && !set.columns.any((c) => c.id == _sortId)) {
      _resetSortFor(set);
    }
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
        _ascending = c.firstAscending ?? !c.numeric;
      }
    });
  }

  void _pickSet(GridColumnSet<T> s) => setState(() {
    _setId = s.id;
    if (!s.columns.any((c) => c.id == _sortId)) _resetSortFor(s);
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
                    // In capitals like every tablet tab and heading: the
                    // labels come from copy written for the phone, where some
                    // are capitals and some are not.
                    label: Text(
                      s.label.capsIn(
                        Localizations.localeOf(context).languageCode,
                      ),
                    ),
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
      // A fixed column's gap sits inside its width; a flexible one's on top.
      w += c.width ?? DataGrid.minFlexWidth + c.gapBefore;
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
              // Stretched, so each title is tappable over the header's whole
              // height and not only across its line of text.
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final c in columns)
                    _cellBox(
                      c,
                      _withTooltip(
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
                    ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: _scroll,
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

  Widget _withTooltip(GridColumn<T> c, Widget child) =>
      c.tooltip == null ? child : Tooltip(message: c.tooltip, child: child);

  Widget _cellBox(GridColumn<T> c, Widget child) {
    final padded = c.gapBefore > 0
        ? Padding(
            padding: EdgeInsets.only(left: c.gapBefore),
            child: child,
          )
        : child;
    return c.width != null
        ? SizedBox(width: c.width, child: padded)
        : Expanded(flex: c.flex, child: padded);
  }
}
