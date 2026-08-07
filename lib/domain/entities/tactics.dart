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

/// The side's general playing style: one decision that sets the whole shape of
/// the instructions beneath it.
///
/// Six dials, each 0–100, is a lot to ask of a manager who simply wants their
/// team to press and play out from the back. A playstyle is that sentence: it
/// composes straight into [TacticalInstructions], and the dials stay available
/// underneath for anyone who wants to trim it. Moving a dial by hand makes the
/// style [Playstyle.custom] — the style is a description of the tactic, so it
/// must never claim to describe one it no longer matches.
enum Playstyle {
  /// No stated style: whatever the dials happen to say.
  custom,

  /// Nothing overdone in any direction.
  balanced,

  /// Keep the ball, move it patiently, squeeze the pitch high.
  possession,

  /// Hunt the ball the moment it is lost, high line, quick vertical play.
  gegenpress,

  /// Sit off, stay compact, break at speed the moment the ball turns over.
  counter,

  /// Get it forward early and play for the second ball.
  direct,

  /// Deep, narrow and hard to beat; the game is survived rather than won.
  lowBlock,

  /// Stretch the pitch, get round the outside and cross.
  wingPlay,
}

/// What each playstyle actually asks for, on the same 0–100 dials.
extension PlaystyleX on Playstyle {
  /// The instructions this style composes into. [Playstyle.custom] has none —
  /// it *is* whatever the dials say — so it returns null.
  TacticalInstructions? get instructions => switch (this) {
    Playstyle.custom => null,
    Playstyle.balanced => const TacticalInstructions(),
    Playstyle.possession => const TacticalInstructions(
      mentality: 60,
      pressing: 60,
      tempo: 35,
      width: 60,
      defensiveLine: 65,
      directness: 20,
    ),
    Playstyle.gegenpress => const TacticalInstructions(
      mentality: 75,
      pressing: 90,
      tempo: 80,
      width: 55,
      defensiveLine: 85,
      directness: 60,
    ),
    Playstyle.counter => const TacticalInstructions(
      mentality: 35,
      pressing: 30,
      tempo: 70,
      width: 40,
      defensiveLine: 30,
      directness: 75,
    ),
    Playstyle.direct => const TacticalInstructions(
      mentality: 60,
      pressing: 55,
      tempo: 75,
      width: 55,
      defensiveLine: 55,
      directness: 90,
    ),
    Playstyle.lowBlock => const TacticalInstructions(
      mentality: 20,
      pressing: 20,
      tempo: 40,
      width: 30,
      defensiveLine: 20,
      directness: 60,
    ),
    Playstyle.wingPlay => const TacticalInstructions(
      mentality: 60,
      pressing: 55,
      tempo: 60,
      width: 90,
      defensiveLine: 55,
      directness: 55,
    ),
  };

  /// The style whose profile [i] matches exactly, or [Playstyle.custom].
  static Playstyle matching(TacticalInstructions i) {
    for (final s in Playstyle.values) {
      if (s == Playstyle.custom) continue;
      if (s.instructions == i) return s;
    }
    return Playstyle.custom;
  }
}

/// A team's tactic for a save: shape, chosen XI (slot → player id, or null if a
/// slot is empty), instructions, and the general style they compose from.
@freezed
abstract class Tactic with _$Tactic {
  const factory Tactic({
    required Formation formation,
    required List<int?> lineup, // length 11, slot order matches the formation
    @Default(TacticalInstructions()) TacticalInstructions instructions,
    @Default(Playstyle.custom) Playstyle playstyle,
  }) = _Tactic;
}
