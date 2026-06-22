import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_attributes.freezed.dart';
part 'player_attributes.g.dart';

/// A player's ability across ten attributes, each on a `1..99` scale.
///
/// Grouped conceptually as technical / mental / physical. Goalkeepers reuse
/// [positioning]/[composure]/[decisions] as a shot-stopping proxy for now; a
/// dedicated goalkeeping model arrives with the match engine (M6).
@freezed
abstract class PlayerAttributes with _$PlayerAttributes {
  const factory PlayerAttributes({
    // Technical
    required int passing,
    required int shooting,
    required int dribbling,
    required int tackling,
    // Mental
    required int positioning,
    required int composure,
    required int decisions,
    // Physical
    required int pace,
    required int stamina,
    required int strength,
  }) = _PlayerAttributes;

  const PlayerAttributes._();

  factory PlayerAttributes.fromJson(Map<String, Object?> json) =>
      _$PlayerAttributesFromJson(json);

  /// The unweighted mean of all ten attributes.
  int get average => ((passing +
              shooting +
              dribbling +
              tackling +
              positioning +
              composure +
              decisions +
              pace +
              stamina +
              strength) /
          10)
      .round();
}
