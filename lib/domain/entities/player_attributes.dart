import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_attributes.freezed.dart';
part 'player_attributes.g.dart';

/// A player's ability across three broad qualities, each on a `1..99` scale.
///
/// - [physical] — pace, power and athleticism.
/// - [technical] — on-the-ball skill and footballing awareness (passing,
///   finishing, dribbling, tackling, positioning, composure).
/// - [stamina] — endurance across a match.
///
/// Hidden potential is not stored here — it is derived from the player id (see
/// `PlayerLifecycle.developmentPotential`).
@freezed
abstract class PlayerAttributes with _$PlayerAttributes {
  const factory PlayerAttributes({
    required int physical,
    required int technical,
    required int stamina,
  }) = _PlayerAttributes;

  const PlayerAttributes._();

  factory PlayerAttributes.fromJson(Map<String, Object?> json) =>
      _$PlayerAttributesFromJson(json);

  /// The unweighted mean of the three qualities.
  int get average => ((physical + technical + stamina) / 3).round();
}
