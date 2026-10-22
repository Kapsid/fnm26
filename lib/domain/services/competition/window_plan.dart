import 'package:fnm/core/rng/seeded_rng.dart';

/// International match windows (month numbers), in season order: a season
/// runs September to June, so the spring months belong to the following
/// calendar year.
const List<int> internationalWindowMonths = [9, 10, 11, 3, 6];

/// The span of international windows a qualifying campaign may use: every
/// window from [start] up to and including [deadline], with the window sizes
/// drawn from [seed]. [fillAll] makes the campaign play in every window of the
/// span (South America's eighteen matchdays must still run into March, where
/// the play-off follows them).
typedef WindowSpan = ({
  DateTime start,
  DateTime deadline,
  int seed,
  bool fillAll,
});

/// How many matches each international window holds, for cycles that play
/// fluid windows.
///
/// Every window used to hold exactly three matchdays (the 6th, 9th and 12th).
/// Real windows hold two or three, sometimes four: a campaign is split across
/// the windows of its span at random, from two to four matches a window,
/// mostly two or three, June leaning to three. The split is drawn from its
/// own seed, never the one the group draw uses, so the groups come out exactly
/// as they did before and every screen that re-runs the draw still matches.
abstract final class WindowPlan {
  /// The days of the month a window of each size plays on. Never past the
  /// 12th, which keeps the friendly day (the 14th) and June's Finals Four
  /// (from the 18th) clear.
  static const Map<int, List<int>> _days = {
    2: [6, 9],
    3: [6, 9, 12],
    4: [3, 6, 9, 12],
  };

  /// Relative weight of a window of each size, outside June and in June.
  static const Map<int, int> _weight = {2: 3, 3: 3, 4: 1};
  static const Map<int, int> _juneWeight = {2: 1, 3: 3, 4: 2};

  /// The windows of [span], in order.
  static List<({int year, int month})> windowsOf(WindowSpan span) {
    final out = <({int year, int month})>[];
    var seasonYear = span.start.year - 1;
    var wi = 0;
    // Bounded: a span is a few seasons at most.
    for (var guard = 0; guard < 40; guard++) {
      final month = internationalWindowMonths[wi];
      final year = month >= 9 ? seasonYear : seasonYear + 1;
      final first = DateTime(year, month);
      final last = DateTime(year, month + 1).subtract(const Duration(days: 1));
      if (first.isAfter(span.deadline)) break;
      if (!last.isBefore(DateTime(span.start.year, span.start.month))) {
        out.add((year: year, month: month));
      }
      wi++;
      if (wi == internationalWindowMonths.length) {
        wi = 0;
        seasonYear++;
      }
    }
    return out;
  }

  /// The [rounds] matchday dates for a campaign played across [span], or null
  /// when no split of two to four matches a window fits it.
  static List<DateTime>? dates(WindowSpan span, int rounds) {
    final windows = windowsOf(span);
    if (windows.isEmpty) return null;
    // Every split over the first k windows, each window two to four matches.
    final splits = <List<int>>[];
    void walk(List<int> sizes, int left) {
      if (left == 0) {
        if (!span.fillAll || sizes.length == windows.length) {
          splits.add(List.of(sizes));
        }
        return;
      }
      if (sizes.length == windows.length) return;
      for (final size in const [2, 3, 4]) {
        if (size > left) break;
        // A remainder of one cannot be played as a window of its own.
        if (left - size == 1) continue;
        sizes.add(size);
        walk(sizes, left - size);
        sizes.removeLast();
      }
    }

    walk(<int>[], rounds);
    if (splits.isEmpty) return null;

    int weightOf(List<int> sizes) {
      var w = 1;
      for (var i = 0; i < sizes.length; i++) {
        final june = windows[i].month == 6;
        w *= (june ? _juneWeight : _weight)[sizes[i]]!;
      }
      return w;
    }

    final weights = [for (final s in splits) weightOf(s)];
    final total = weights.fold(0, (a, b) => a + b);
    var pick = SeededRng(span.seed ^ 0x3D17).nextInt(total);
    var chosen = splits.last;
    for (var i = 0; i < splits.length; i++) {
      if (pick < weights[i]) {
        chosen = splits[i];
        break;
      }
      pick -= weights[i];
    }
    return [
      for (var i = 0; i < chosen.length; i++)
        for (final day in _days[chosen[i]]!)
          DateTime(windows[i].year, windows[i].month, day),
    ];
  }
}
