import 'package:fnm/domain/entities/formation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tactics.freezed.dart';

/// Team instructions, each on a 0–100 scale (50 = balanced).
@freezed
abstract class TacticalInstructions with _$TacticalInstructions {
  const factory TacticalInstructions({
    @Default(50) int mentality, // defensive ↔ attacking
    @Default(50) int pressing, // low block ↔ high press
    @Default(50) int tempo, // patient ↔ fast
    @Default(50) int width, // narrow ↔ wide
    @Default(50) int defensiveLine, // deep ↔ high
    @Default(50) int directness, // possession ↔ direct
  }) = _TacticalInstructions;
}

/// A team's tactic for a save: shape, chosen XI (slot → player id, or null if a
/// slot is empty), and instructions.
@freezed
abstract class Tactic with _$Tactic {
  const factory Tactic({
    required Formation formation,
    required List<int?> lineup, // length 11, slot order matches the formation
    @Default(TacticalInstructions()) TacticalInstructions instructions,
  }) = _Tactic;
}
