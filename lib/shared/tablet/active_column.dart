import 'package:flutter/widgets.dart';
import 'package:fnm/shared/tablet/data_grid.dart';
import 'package:fnm/shared/widgets/active_badge.dart';

/// The "still playing" column every all-time board on a tablet ends with
/// (the record book, the team records, the world's records), built in one
/// place so the badge sits the same way on all of them.
///
/// It follows a right-aligned tally, so it opens with a clear gap: the badge
/// never touches the number, and starts where its header does.
GridColumn<T> activeGridColumn<T>({
  required String label,
  required bool Function(T row) isActive,
}) => GridColumn<T>(
  id: 'active',
  label: label,
  // As wide as the column was before the gap, so no board that fitted
  // starts scrolling sideways.
  width: activeColumnGap + 68,
  gapBefore: activeColumnGap,
  // Who still plays, first.
  firstAscending: false,
  sortKey: (r) => isActive(r) ? 1 : 0,
  // Shrinks rather than cuts where the word runs long ("EN ACTIVITÉ").
  cell: (r) => isActive(r)
      ? const FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: ActiveBadge(),
        )
      : const SizedBox.shrink(),
);

/// The room between a board's tally and its "active" badge.
const double activeColumnGap = 16;
