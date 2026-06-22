import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/rating/overall_rating.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'player.freezed.dart';
part 'player.g.dart';

/// A footballer eligible for a [nationId]'s squad.
@freezed
abstract class Player with _$Player {
  const factory Player({
    required int id,
    required int nationId,
    required String name,
    required int age,
    required PlayerPosition position,
    required PlayerAttributes attributes,
  }) = _Player;

  const Player._();

  factory Player.fromJson(Map<String, Object?> json) => _$PlayerFromJson(json);

  /// Position-weighted overall rating (`1..99`).
  int get overall => OverallRating.forPosition(position, attributes);

  /// Broad positional grouping, for squad organisation and filtering.
  PositionCategory get category => position.category;
}
