import 'package:fnm/core/rng/seeded_rng.dart';

/// A scheduled friendly: date, opponent, and whether the player is at home.
typedef FriendlySpec = ({DateTime date, int opponentId, bool home});

/// Fills international windows that have no competitive fixture with friendlies
/// (warm-ups), e.g. the gap between finishing qualifying and the finals.
abstract final class FriendlyScheduler {
  static const _windowMonths = [9, 10, 11, 3, 6];

  /// Schedules up to [max] friendlies on window dates strictly after [from] and
  /// before [until], against random members of [opponentPool]. Deterministic.
  static List<FriendlySpec> schedule({
    required DateTime from,
    required DateTime until,
    required List<int> opponentPool,
    required int seed,
    int max = 8,
  }) {
    if (opponentPool.isEmpty) return const [];
    final rng = SeededRng(seed ^ 0x4F12);

    final dates = <DateTime>[];
    for (var year = from.year; year <= until.year; year++) {
      for (final month in _windowMonths) {
        final d = DateTime(year, month, 14);
        if (d.isAfter(from) && d.isBefore(until)) dates.add(d);
      }
    }
    dates.sort();

    final specs = <FriendlySpec>[];
    for (final d in dates) {
      if (specs.length >= max) break;
      specs.add((
        date: d,
        opponentId: opponentPool[rng.nextInt(opponentPool.length)],
        home: rng.chance(0.5),
      ));
    }
    return specs;
  }
}
