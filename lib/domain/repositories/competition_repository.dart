import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/services/competition/schedule_generator.dart';

/// A qualifying group's table for display.
typedef GroupTable = ({
  int groupId,
  String name,
  List<GroupStanding> standings,
});

/// Persists and queries the competition schedule for a save.
abstract interface class CompetitionRepository {
  /// Whether a schedule has already been generated for this save.
  Future<bool> hasSchedule(int careerId);

  /// Persists a generated qualifying competition for [careerId].
  Future<void> saveSchedule({
    required int careerId,
    required GeneratedSchedule schedule,
  });

  /// A nation's fixtures, ordered by date.
  Future<List<Fixture>> fixturesForNation(int careerId, int nationId);

  /// All unplayed fixtures in the save due on or before [date].
  Future<List<Fixture>> unplayedDueBy(int careerId, DateTime date);

  /// The nation's next unplayed fixture on or after [onOrAfter].
  Future<Fixture?> nextFixtureForNation(
    int careerId,
    int nationId,
    DateTime onOrAfter,
  );

  /// Records a fixture result.
  Future<void> recordResult({
    required int fixtureId,
    required int homeScore,
    required int awayScore,
  });

  /// The group table containing [nationId] for this save, or null.
  Future<GroupTable?> groupTableForNation(int careerId, int nationId);
}
