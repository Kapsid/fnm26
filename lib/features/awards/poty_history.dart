import 'package:fnm/domain/entities/enums.dart';

/// One man in the Player of the Year history: who he is, and what the year
/// knew of him. His name is null when nothing stored names him (a year filed
/// by a very old build whose player has since left every pool).
typedef PotyHistoryPlayer = ({
  int playerId,
  int nationId,
  String? name,

  /// FIFA code, lower case, for the flag; empty when unknown.
  String nationCode,

  /// His position and age THAT year; null when the year did not store them.
  PlayerPosition? position,
  int? age,
});

/// One place in a year's top five.
typedef PotyHistoryPlace = ({int rank, PotyHistoryPlayer player});

/// One voted year: its two winners and, from the year the full vote was
/// stored on, its top five (empty before that).
typedef PotyHistoryYear = ({
  int year,
  PotyHistoryPlayer? best,
  PotyHistoryPlayer? young,
  List<PotyHistoryPlace> topFive,
});

/// A player's Player of the Year wins, newest first.
typedef PotyMostWins = ({PotyHistoryPlayer player, List<int> years});

/// A nation's Player of the Year wins, newest first.
typedef PotyNationWins = ({int nationId, String nationCode, List<int> years});

/// One of the manager's nation's top-five finishes.
typedef PotyOwnFinish = ({int year, int rank, PotyHistoryPlayer player});

/// The whole Player of the Year history of a career, read from what is
/// already stored: the honours rows (every year, old saves too) and the
/// yearly vote message (the top five, from batch 6 on).
class PotyHistory {
  PotyHistory._({
    required this.ownNationId,
    required this.years,
    required this.mostWins,
    required this.byNation,
    required this.ownFinishes,
    required this.ownWinners,
  });

  /// Aggregates [years] for the manager's nation [ownNationId].
  ///
  /// Most wins: by wins, ties to the most recent win, then the player id so
  /// two reads agree. By nation the same way. A winner counts as a top-five
  /// finish; a year with no stored top five still counts its winner.
  factory PotyHistory.build(
    Iterable<PotyHistoryYear> years, {
    required int ownNationId,
  }) {
    final sorted = [...years]..sort((a, b) => b.year.compareTo(a.year));
    final byPlayer = <int, ({PotyHistoryPlayer player, List<int> years})>{};
    final byNation = <int, ({String code, List<int> years})>{};
    final own = <PotyOwnFinish>[];
    var ownWinners = 0;
    for (final y in sorted) {
      final best = y.best;
      if (best != null) {
        // Newest first, so the first sighting carries his latest name.
        final p = byPlayer[best.playerId] ??= (player: best, years: []);
        p.years.add(y.year);
        final n = byNation[best.nationId] ??= (
          code: best.nationCode,
          years: [],
        );
        n.years.add(y.year);
        if (best.nationId == ownNationId) ownWinners++;
      }
      final places = y.topFive.isNotEmpty
          ? y.topFive
          : [if (best != null) (rank: 1, player: best)];
      for (final place in places) {
        if (place.player.nationId != ownNationId) continue;
        own.add((year: y.year, rank: place.rank, player: place.player));
      }
    }
    int byWins(List<int> a, List<int> b) {
      final s = b.length.compareTo(a.length);
      return s != 0 ? s : b.first.compareTo(a.first);
    }

    final most =
        [
          for (final e in byPlayer.values) (player: e.player, years: e.years),
        ]..sort((a, b) {
          final s = byWins(a.years, b.years);
          return s != 0 ? s : a.player.playerId.compareTo(b.player.playerId);
        });
    final nations =
        [
          for (final e in byNation.entries)
            (nationId: e.key, nationCode: e.value.code, years: e.value.years),
        ]..sort((a, b) {
          final s = byWins(a.years, b.years);
          return s != 0 ? s : a.nationId.compareTo(b.nationId);
        });
    return PotyHistory._(
      ownNationId: ownNationId,
      years: sorted,
      mostWins: most,
      byNation: nations,
      ownFinishes: own,
      ownWinners: ownWinners,
    );
  }

  /// The manager's nation, whose players the history picks out.
  final int ownNationId;

  /// Every voted year, newest first.
  final List<PotyHistoryYear> years;

  /// Players by Player of the Year wins.
  final List<PotyMostWins> mostWins;

  /// Nations by Player of the Year wins.
  final List<PotyNationWins> byNation;

  /// The manager's nation's top-five finishes (winners included), newest
  /// first.
  final List<PotyOwnFinish> ownFinishes;

  /// How many years the manager's nation produced the winner.
  final int ownWinners;

  bool get isEmpty => years.isEmpty;

  /// The latest year with a winner, or null.
  PotyHistoryYear? get latest => years.where((y) => y.best != null).firstOrNull;

  /// The most decorated player, or null.
  PotyMostWins? get mostDecorated => mostWins.firstOrNull;
}
