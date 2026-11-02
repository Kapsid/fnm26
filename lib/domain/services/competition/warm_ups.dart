import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/nation.dart';

/// The warm-up window before a finals tournament: the days just before its
/// opening match, when the qualified sides play their send-off friendlies.
///
/// Nothing used to be played between the March window and a finals: a side in
/// the tournament went into its opener cold, and a side that missed out played
/// nothing at all from March to September. The window is not one of the
/// international windows (those sit on the 14th of their month and are shared
/// by everybody); it hangs off each tournament's own opener, so a June World
/// Championship, a June continental championship and a January one all get
/// one.
abstract final class WarmUps {
  /// How many days before the opener each warm-up is played. Two, three days
  /// apart, both clear of the call-up (ten days out) and of the opener.
  static const List<int> daysBefore = [9, 6];

  /// The warm-up dates before a tournament that opens on [opener], earliest
  /// first.
  static List<DateTime> datesBefore(DateTime opener) => [
    for (final d in daysBefore)
      DateTime(opener.year, opener.month, opener.day - d),
  ];

  /// Whether [d] is a warm-up date before [opener].
  static bool isWarmUpFor(DateTime d, DateTime opener) =>
      datesBefore(opener).any((w) => _sameDay(w, d));

  /// At most this many offers are taken up.
  static const int maxAccepted = 2;

  /// The qualified nations that reach out to a manager whose side is not in
  /// the tournament: one to three of them, deterministic from the save's
  /// [seed], the [cycle] and the tournament ([tournament], any stable small
  /// number per tournament of the cycle).
  ///
  /// Plausible first: a side from the manager's own confederation, then one
  /// drawn with a side from it (the friendly helps them prepare for a
  /// recognisable opponent), then anybody, and within each the closest in
  /// strength. The offers come from the front of that order, with a seeded
  /// shuffle among the nearest few so two saves do not hear from the same
  /// sides every time.
  ///
  /// [groups] are the tournament's drawn groups, each a list of nation ids.
  static List<int> offers({
    required int seed,
    required int cycle,
    required int tournament,
    required Nation me,
    required Map<int, Nation> nations,
    required List<List<int>> groups,
  }) {
    final rng = SeededRng(
      seed ^ (cycle * 0x1F3D) ^ (tournament * 0x6A09) ^ 0x3B7E,
    );
    int rank(int id) {
      final n = nations[id];
      if (n == null) return 3;
      if (n.confederation == me.confederation) return 0;
      final group = groups.firstWhere(
        (g) => g.contains(id),
        orElse: () => const [],
      );
      final facesMine = group.any(
        (o) => o != id && nations[o]?.confederation == me.confederation,
      );
      return facesMine ? 1 : 2;
    }

    final candidates =
        [
          for (final g in groups)
            for (final id in g)
              if (id != me.id && nations[id] != null) id,
        ]..sort((a, b) {
          final byRank = rank(a).compareTo(rank(b));
          if (byRank != 0) return byRank;
          final da = (nations[a]!.ranking - me.ranking).abs();
          final db = (nations[b]!.ranking - me.ranking).abs();
          return da != db ? da.compareTo(db) : a.compareTo(b);
        });
    if (candidates.isEmpty) return const [];
    final count = 1 + rng.nextInt(3);
    final pool = rng.shuffled(candidates.take(count + 3).toList());
    return (pool.take(count).toList()
      ..sort((a, b) => candidates.indexOf(a).compareTo(candidates.indexOf(b))));
  }

  /// Whether the qualified side [offerer] hosts the friendly it offers
  /// [nationId]: usually, as it is their send-off; one time in five they come
  /// to him.
  static bool offererHosts({
    required int seed,
    required int cycle,
    required int tournament,
    required int offerer,
  }) => !SeededRng(
    seed ^ (cycle * 0x1F3D) ^ (tournament * 0x6A09) ^ (offerer * 0x2C1B),
  ).chance(0.2);

  /// Which tournament number [WarmUps.offers] keys a finals by: the World
  /// Championship, or a continental championship (there is only ever one of
  /// those a manager can be offered warm-ups for: his own confederation's).
  static int tournamentKey({required bool worldChampionship}) =>
      worldChampionship ? 1 : 2;

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
