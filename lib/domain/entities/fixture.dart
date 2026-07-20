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
}
