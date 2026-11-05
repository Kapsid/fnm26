import 'dart:math';

import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/pitch/formation_slots.dart';

/// Where each slot's disc is drawn once [switches] have moved slots into
/// other lines, in the same 0..1 layout units (and slot order) as
/// [layoutOf].
///
/// A switched slot is drawn in the row of the place it now plays: a 4-3-3
/// whose DM steps up to CM shows three CMs across the midfield row, spread
/// the way a shape with three CMs is drawn; one stepped up to AM sits
/// centrally behind the strikers; a left midfielder pushed on to LW joins the
/// forward row on his flank. With no switches it is [layoutOf] exactly, so
/// an untouched shape draws precisely as it always has.
///
/// The rows are the central chain (DM, CM, AM, ST), the wide men joining the
/// row they play in (LM/RM the CM row, LW/RW the forward row). A row whose
/// members changed is re-spread across the pitch with the spacing the
/// formation tables use for that many men ([_centralSpread] with no wide men,
/// [_fullSpread] with them), and a central-only row next to it re-centres
/// with it, so a line that lost its holding man closes up. The rows are then
/// pushed apart vertically wherever two discs would come closer than the
/// pitch's measured clearance, the back line held where it is.
List<(double, double)> switchedLayoutOf(
  Formation formation,
  SlotSwitches switches,
) {
  final base = layoutOf(formation);
  final from = formation.positions;
  final valid = switches.validFor(formation);
  if (valid.isEmpty) return base;
  final eff = valid.apply(formation);

  // Each chain row's line, read off the base shape.
  final rowY = _rowYs(formation);

  Set<int> membersOf(List<PlayerPosition> ps, int row) => {
    for (var s = 0; s < ps.length; s++)
      if (_rowOf(ps[s]) == row) s,
  };

  final changed = <int>{
    for (var r = 0; r < _rows; r++)
      if (!_sameSet(membersOf(from, r), membersOf(eff, r))) r,
  };
  bool hasWide(int r) =>
      membersOf(from, r).any((s) => _isWide(from[s])) ||
      membersOf(eff, r).any((s) => _isWide(eff[s]));
  final relaid = <int>{
    ...changed,
    for (var r = 0; r < _rows; r++)
      if (!changed.contains(r) &&
          !hasWide(r) &&
          (changed.contains(r - 1) || changed.contains(r + 1)))
        r,
  };

  // Every occupied row as a line y plus each member's (x, offset from it).
  final rows = <_Row>[];
  for (var r = 0; r < _rows; r++) {
    final members = membersOf(eff, r).toList();
    if (members.isEmpty) continue;
    final row = _Row(r);
    if (relaid.contains(r)) {
      row.y = rowY[r];
      _spread(row, members, eff, base);
    } else {
      // Kept as drawn: the line is its highest central man (or its highest
      // man at all), every disc an offset from it.
      final centrals = members.where((s) => !_isWide(eff[s]));
      final anchor = (centrals.isEmpty ? members : centrals)
          .map((s) => base[s].$2)
          .reduce(min);
      row.y = anchor;
      for (final s in members) {
        row.points[s] = (base[s].$1, base[s].$2 - anchor);
      }
    }
    rows.add(row);
  }

  _unstack(rows, relaid, base);
  _separate(rows, formation, base);

  final out = [...base];
  for (final row in rows) {
    row.points.forEach((s, p) => out[s] = (p.$1, row.y + p.$2));
  }
  return List.unmodifiable(out);
}

const int _rows = 4;

/// The chain row a place is drawn in: 0 DM, 1 CM (with the wide
/// midfielders), 2 AM, 3 the forwards (with the wingers). Null for the keeper
/// and the back line, which never move.
int? _rowOf(PlayerPosition p) => switch (p) {
  PlayerPosition.dm => 0,
  PlayerPosition.cm || PlayerPosition.lm || PlayerPosition.rm => 1,
  PlayerPosition.am => 2,
  PlayerPosition.st || PlayerPosition.lw || PlayerPosition.rw => 3,
  _ => null,
};

bool _isWide(PlayerPosition p) =>
    p == PlayerPosition.lm ||
    p == PlayerPosition.rm ||
    p == PlayerPosition.lw ||
    p == PlayerPosition.rw;

bool _isLeft(PlayerPosition p) =>
    p == PlayerPosition.lm || p == PlayerPosition.lw;

bool _sameSet(Set<int> a, Set<int> b) =>
    a.length == b.length && a.containsAll(b);

/// One step down the central chain where no neighbouring line says better;
/// the same step the drag zones use.
const double _step = 0.125;

/// The y of each chain row's line in [f]'s own layout: its highest central
/// man where it has any, otherwise interpolated between the rows either side
/// (a 4-3-3's AM row sits midway between its CMs and its striker), or a
/// [_step] beyond the one row there is.
List<double> _rowYs(Formation f) {
  final base = layoutOf(f);
  final ps = f.positions;
  final known = List<double?>.filled(_rows, null);
  for (var s = 0; s < ps.length; s++) {
    final r = _rowOf(ps[s]);
    if (r == null || _isWide(ps[s])) continue;
    final y = base[s].$2;
    known[r] = known[r] == null ? y : min(known[r]!, y);
  }
  // A row holding only wide men: its line is just below them.
  for (var s = 0; s < ps.length; s++) {
    final r = _rowOf(ps[s]);
    if (r == null || !_isWide(ps[s]) || known[r] != null) continue;
    known[r] = base[s].$2 + (r == 3 ? -_wingerDrop : _wideLift);
  }
  final out = <double>[];
  for (var r = 0; r < _rows; r++) {
    if (known[r] != null) {
      out.add(known[r]!);
      continue;
    }
    int? d;
    int? u;
    for (var i = r - 1; i >= 0; i--) {
      if (known[i] != null) {
        d = i;
        break;
      }
    }
    for (var i = r + 1; i < _rows; i++) {
      if (known[i] != null) {
        u = i;
        break;
      }
    }
    if (d != null && u != null) {
      out.add(known[d]! + (known[u]! - known[d]!) * (r - d) / (u - d));
    } else if (d != null) {
      out.add(known[d]! - _step * (r - d));
    } else {
      out.add(known[u!]! + _step * (u - r));
    }
  }
  return out;
}

/// x of n central men in a row with no wide men, as the formation tables
/// draw them: one in the middle, a pair at 0.38/0.62 (4-4-2's strikers,
/// 4-2-3-1's pivot), three at 0.30/0.5/0.70 (3-5-2's midfield), on up to a
/// five-across line.
const Map<int, List<double>> _centralSpread = {
  1: [0.5],
  2: [0.38, 0.62],
  3: [0.30, 0.5, 0.70],
  4: [0.20, 0.40, 0.60, 0.80],
  5: [0.10, 0.30, 0.5, 0.70, 0.90],
};

/// x of a whole line with a wide man on each flank, the outer two theirs:
/// 4-4-2's midfield four, 4-5-1's five, a 4-3-3's front three.
const Map<int, List<double>> _fullSpread = {
  3: [0.16, 0.5, 0.84],
  4: [0.12, 0.38, 0.62, 0.88],
  5: [0.10, 0.30, 0.5, 0.70, 0.90],
};

/// How far either side of its line each half of a midfield too full for one
/// row stands (see [_spread]): two pairs a disc and its clearance apart.
const double _splitOffset = 0.09;

/// How much higher than the central men a wide midfielder stands (4-4-2:
/// 0.45 against 0.48).
const double _wideLift = -0.03;

/// How much deeper than the strikers a winger stands (4-3-3: 0.18 against
/// 0.13).
const double _wingerDrop = 0.05;

/// How much deeper the middle man of a midfield three sits (4-3-1-2: 0.53
/// against 0.50); in a front three of strikers the outer two drop instead.
const double _middleDrop = 0.03;

/// Re-spreads [row] across the pitch for [members] (slots playing in it).
void _spread(
  _Row row,
  List<int> members,
  List<PlayerPosition> eff,
  List<(double, double)> base,
) {
  int byX(int a, int b) {
    final c = base[a].$1.compareTo(base[b].$1);
    return c != 0 ? c : a.compareTo(b);
  }

  // One wide man per flank at most, the one nearer the touchline; a second
  // on the same flank (a 3-4-3 whose left midfielder also plays LW) is
  // spread as a central man, in the order the base shape has them.
  final sorted = [...members]..sort(byX);
  final lefts = [
    for (final s in sorted)
      if (_isWide(eff[s]) && _isLeft(eff[s])) s,
  ];
  final rights = [
    for (final s in sorted)
      if (_isWide(eff[s]) && !_isLeft(eff[s])) s,
  ];
  final left = lefts.isEmpty ? null : lefts.first;
  final right = rights.isEmpty ? null : rights.last;
  final centrals = [
    for (final s in sorted)
      if (s != left && s != right) s,
  ];
  final n = centrals.length;
  final forwards = row.index == 3;
  final wideOffset = forwards ? _wingerDrop : _wideLift;

  if (left == null && right == null) {
    final xs = _centralSpread[n.clamp(1, 5)]!;
    for (var i = 0; i < n; i++) {
      row.points[centrals[i]] = (xs[i], _centralOffset(i, n, forwards));
    }
    return;
  }
  if (n >= 4) {
    // Six across does not fit one row at the measured clearance (a 3-4-2-1
    // with both tens dropped to CM): the wide men keep the flanks of a
    // five-across line and the men inside stand in two staggered pairs, the
    // ones who came from higher up the pitch in front.
    final xs = _fullSpread[5]!;
    if (left != null) row.points[left] = (xs.first, wideOffset);
    if (right != null) row.points[right] = (xs.last, wideOffset);
    int byY(int a, int b) {
      final c = base[a].$2.compareTo(base[b].$2);
      return c != 0 ? c : byX(a, b);
    }

    final byDepth = [...centrals]..sort(byY);
    final high = byDepth.sublist(0, n ~/ 2)..sort(byX);
    final low = byDepth.sublist(n ~/ 2)..sort(byX);
    for (final (half, offset) in [(high, -_splitOffset), (low, _splitOffset)]) {
      final hx = _centralSpread[half.length]!;
      for (var i = 0; i < half.length; i++) {
        row.points[half[i]] = (hx[i], offset);
      }
    }
    return;
  }
  final xs = switch (n) {
    0 => forwards ? const [0.16, 0.84] : const [0.12, 0.88],
    // 4-4-2's wide midfielders, with one man inside them.
    1 when !forwards => const [0.12, 0.5, 0.88],
    _ => _fullSpread[n + 2]!,
  };
  if (left != null) row.points[left] = (xs.first, wideOffset);
  if (right != null) row.points[right] = (xs.last, wideOffset);
  for (var i = 0; i < n; i++) {
    row.points[centrals[i]] = (xs[i + 1], _centralOffset(i, n, forwards));
  }
}

double _centralOffset(int i, int n, bool forwards) {
  if (n != 3) return 0;
  if (forwards) return i == 1 ? 0 : _wingerDrop;
  return i == 1 ? _middleDrop : 0;
}

/// A lone central man in a re-spread row, with a central man straight in
/// front of him and another straight behind (a 4-3-3 whose CM steps up to
/// AM leaves DM, CM, AM and ST one above the other), steps to his own side
/// of the middle. Four discs in one column cannot keep their clearance in the
/// height a pitch has; this is how a 4-1-1-1-3 is drawn on any tactics
/// board, the shuttler beside the line rather than in it.
void _unstack(
  List<_Row> rows,
  Set<int> relaid,
  List<(double, double)> base,
) {
  bool centred(_Row r) => r.points.values.any((p) => (p.$1 - 0.5).abs() < 0.05);
  rows.sort((a, b) => a.index.compareTo(b.index));
  for (var i = 1; i < rows.length - 1; i++) {
    final row = rows[i];
    if (!relaid.contains(row.index)) continue;
    final lone = [
      for (final e in row.points.entries)
        if ((e.value.$1 - 0.5).abs() < 0.05) e.key,
    ];
    // Alone in the middle: anybody else in the row is a wide man.
    final others = row.points.values.where((p) => (p.$1 - 0.5).abs() < 0.3);
    if (lone.length != 1 || others.length != 1) continue;
    if (!centred(rows[i - 1]) || !centred(rows[i + 1])) continue;
    final s = lone.single;
    final flanked = row.points.length > 1;
    // Inside wide men he keeps a 4-4-2 central midfielder's x; alone, a
    // 4-3-3 one's.
    final step = flanked ? 0.12 : 0.20;
    final x = base[s].$1 < 0.5 ? 0.5 - step : 0.5 + step;
    row.points[s] = (x, row.points[s]!.$2);
  }
}

/// One drawn row: its line [y] and each member slot's (x, y offset).
class _Row {
  _Row(this.index);
  final int index;
  double y = 0;
  final Map<int, (double, double)> points = {};
}

/// Centre-to-centre distance two discs need, in pitch WIDTHS: the pitch
/// tests' 1.10 ball-diameter clearance (balls are 0.145 of the width) with a
/// margin.
const double _clear = 0.163;

/// One unit of layout x in pitch widths at its smallest: a node's centre
/// travels the pitch less one node width (0.85 of it), and the width dial at
/// its narrowest draws the shape at 0.95 (see the pitch's `_adjusted`).
const double _xScale = 0.85 * 0.95;

/// One unit of layout y in pitch widths on the smallest phone: a 4:3 pitch
/// less a node's height and the insets, squeezed into the outfield band.
/// Larger pitches give a little more.
const double _yScale = 0.93;

/// How far the defensive-line dial can lift the back line.
const double _highLine = 0.04;

/// How far apart (in layout y) two discs [dx] apart across must be.
double _need(double dx) {
  final across = dx.abs() * _xScale;
  if (across >= _clear) return 0;
  return sqrt(_clear * _clear - across * across) / _yScale;
}

/// The least [lower].y - [upper].y that keeps every disc of one clear of
/// every disc of the other.
double _gap(_Row upper, _Row lower) {
  var g = double.negativeInfinity;
  for (final a in upper.points.values) {
    for (final b in lower.points.values) {
      g = max(g, _need(a.$1 - b.$1) + a.$2 - b.$2);
    }
  }
  return g;
}

/// Pushes the rows apart until every disc keeps its clearance: down from the
/// forwards first, and where that runs into the back line (lifted as high as
/// the dial goes), back up from it.
void _separate(
  List<_Row> rows,
  Formation formation,
  List<(double, double)> base,
) {
  // Top of the pitch first. Every row against every row above it, not only
  // the next: a man stepped aside (see [_unstack]) leaves the rows either
  // side of him face to face.
  rows.sort((a, b) => b.index.compareTo(a.index));
  for (var i = 1; i < rows.length; i++) {
    for (var j = 0; j < i; j++) {
      rows[i].y = max(rows[i].y, rows[j].y + _gap(rows[j], rows[i]));
    }
  }
  // The back line, at its highest; where a row now crowds it, everything is
  // pushed back up from it.
  final back = [
    for (var s = 0; s < base.length; s++)
      if (formation.positions[s].category == PositionCategory.defender)
        (base[s].$1, base[s].$2 - _highLine),
  ];
  for (var i = rows.length - 1; i >= 0; i--) {
    final row = rows[i];
    for (final p in row.points.values) {
      for (final d in back) {
        row.y = min(row.y, d.$2 - _need(p.$1 - d.$1) - p.$2);
      }
    }
    for (var j = i + 1; j < rows.length; j++) {
      row.y = min(row.y, rows[j].y - _gap(row, rows[j]));
    }
  }
}
