import 'dart:math';

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
    @Default('Free agent') String club,

    /// FIFA code of the club's country (for its flag). Empty when unknown; set
    /// at materialisation from the deterministic club assignment.
    @Default('') String clubCountry,
  }) = _Player;

  const Player._();

  factory Player.fromJson(Map<String, Object?> json) => _$PlayerFromJson(json);

  /// Position-weighted overall rating (`1..99`).
  int get overall => OverallRating.forPosition(position, attributes);

  /// Broad positional grouping, for squad organisation and filtering.
  PositionCategory get category => position.category;

  /// Estimated transfer value in euros, derived from the rating with an age
  /// curve (peaks in the mid-20s). For squad/scouting display only.
  int get value {
    final base = pow(max(0, overall - 44) / 12, 3).toDouble(); // € millions
    final ageFactor = age <= 23
        ? 1.2
        : age <= 27
        ? 1.1
        : age <= 30
        ? 0.9
        : age <= 33
        ? 0.6
        : 0.35;
    return (base * ageFactor * 1000000).round();
  }
}
