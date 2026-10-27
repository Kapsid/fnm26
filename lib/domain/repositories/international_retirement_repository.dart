import 'package:fnm/domain/entities/enums.dart';

/// A finals tournament whose every fixture has been played: what an
/// international-retirement wave follows.
typedef FinishedFinals = ({
  int competitionId,
  CompetitionKind kind,
  Confederation confederation,
  int cycle,

  /// Every nation that played a match at the finals.
  Set<int> participants,

  /// The winner of the last fixture (the final), or null if it has none.
  int? championId,

  /// The date of the last fixture.
  DateTime endedOn,
});

/// The bookkeeping international retirements need, kept apart from the big
/// competition repository so the feature reads as one piece.
///
/// Everything is stored as per-career `draws_watched` markers (see
/// `InternationalRetirement`), so no schema change is involved.
abstract interface class InternationalRetirementRepository {
  /// Every World Championship and continental finals of [careerId] that has
  /// been played to the end, oldest first, leaving out the competitions in
  /// [skip] (so a caller that has dealt with them does not re-read their
  /// fixtures on every step).
  Future<List<FinishedFinals>> finishedFinals(
    int careerId, {
    Set<int> skip = const {},
  });

  /// Whether [careerId] carries the marker [kind] (any cycle).
  Future<bool> hasMarker(int careerId, String kind);

  /// Every marker of [careerId] whose kind starts with [prefix].
  Future<Set<String>> markersWithPrefix(int careerId, String prefix);

  /// Writes the markers [kinds] for [careerId] at [cycle], in one go
  /// (idempotent).
  Future<void> addMarkers(int careerId, int cycle, Iterable<String> kinds);
}
