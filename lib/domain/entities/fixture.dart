import 'package:freezed_annotation/freezed_annotation.dart';

part 'fixture.freezed.dart';

/// A scheduled match within a save. Scores are null until played.
@freezed
abstract class Fixture with _$Fixture {
  const factory Fixture({
    required int id,
    required int careerId,
    required int competitionId,
    required int matchday,
    required DateTime date,
    required int homeNationId,
    required int awayNationId,
    int? groupId,
    int? homeScore,
    int? awayScore,
    String? round,
    @Default(false) bool played,
    @Default(false) bool afterExtraTime,
    int? homePenalties,
    int? awayPenalties,
  }) = _Fixture;

  const Fixture._();

  /// Whether this fixture has a recorded result.
  bool get hasResult => played && homeScore != null && awayScore != null;

  /// Whether this knockout tie was settled on penalties.
  bool get wentToShootout => homePenalties != null && awayPenalties != null;

  /// The score as it stood when the shootout began: the one to SHOW.
  ///
  /// A tie settled on penalties is stored with the shootout winner one goal
  /// up (1-1 won on penalties is stored 2-1), so the stored score alone still
  /// names the winner for every reader that compares the two (the bracket,
  /// the ranking, the records). That extra goal never happened and has no
  /// scorer, so every screen shows these instead, beside the penalties.
  /// Both are the stored score for every other result, and old saves hold
  /// the same convention, so nothing needs migrating.
  int? get shownHomeScore => _levelled(homeScore, awayScore);

  /// See [shownHomeScore].
  int? get shownAwayScore => _levelled(awayScore, homeScore);

  int? _levelled(int? mine, int? theirs) {
    if (mine == null || theirs == null || !wentToShootout) return mine;
    return mine < theirs ? mine : theirs;
  }
}
