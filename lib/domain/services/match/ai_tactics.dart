import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/nation/nation_identity.dart';

/// A tactical setup for an AI opponent: a shape and matching instructions.
typedef AiSetup = ({Formation formation, TacticalInstructions instructions});

/// Picks a plausible tactical setup for an AI opponent.
///
/// Previously every AI side lined up in a neutral 4-3-3 with all instructions
/// at 50, so the human faced the same shapeless opponent every game and the
/// engine's tactical match-up was effectively one-sided. This gives the AI a
/// real posture, chosen deterministically from [seed] (so it's stable across
/// re-sims of a fixture) and shaped by how the opponent's strength compares to
/// the player's: clear favourites take the initiative and press high, heavy
/// underdogs sit deep and hit on the break. A small per-field jitter keeps two
/// teams in the same band from looking identical.
abstract final class AiTactics {
  static AiSetup forOpponent({
    required double opponentStrength,
    required double playerStrength,
    required int seed,
    NationStyle style = NationStyle.balanced,
  }) {
    final diff = opponentStrength - playerStrength;
    final band = diff >= 8
        ? _favourite
        : diff >= 3
        ? _strong
        : diff > -3
        ? _even
        : diff > -8
        ? _weak
        : _underdog;

    var s = seed & 0x7fffffff;
    int rnd(int mod) {
      s = (s * 1103515245 + 12345) & 0x7fffffff;
      return s % mod;
    }

    final pick = band[rnd(band.length)];
    // The strength band sets the base posture; the national style then stamps
    // its signature on top (Italy sit deeper, the Dutch press higher), and a
    // small per-field jitter keeps two same-band teams from being identical.
    final (dm, dp, dt, dw, dl, dd) = _styleShift(style);
    int nudge(int v, int spread, int styleDelta) =>
        (v + styleDelta + rnd(spread * 2 + 1) - spread).clamp(8, 92);
    final base = pick.instructions;
    return (
      formation: pick.formation,
      instructions: TacticalInstructions(
        mentality: nudge(base.mentality, 4, dm),
        pressing: nudge(base.pressing, 6, dp),
        tempo: nudge(base.tempo, 6, dt),
        width: nudge(base.width, 6, dw),
        defensiveLine: nudge(base.defensiveLine, 5, dl),
        directness: nudge(base.directness, 6, dd),
      ),
    );
  }

  /// Per-style instruction shifts (mentality, pressing, tempo, width,
  /// defensiveLine, directness) layered on top of the strength-chosen posture.
  static (int, int, int, int, int, int) _styleShift(NationStyle style) =>
      switch (style) {
        NationStyle.possession => (0, 6, -12, 0, 4, -18),
        NationStyle.highPress => (4, 16, 6, 0, 12, 0),
        NationStyle.defensive => (-10, -8, 0, -4, -12, 4),
        NationStyle.direct => (2, 0, 12, 6, 0, 18),
        NationStyle.counter => (-6, -8, 8, 0, -8, 14),
        NationStyle.flair => (8, 0, 6, 8, 2, -8),
        NationStyle.physical => (2, 6, 0, -6, 2, 10),
        NationStyle.balanced => (0, 0, 0, 0, 0, 0),
      };

  // --- Archetypes ----------------------------------------------------------
  static const _dominant = _Archetype(
    Formation.f433,
    TacticalInstructions(
      mentality: 68,
      pressing: 66,
      tempo: 58,
      width: 60,
      defensiveLine: 66,
      directness: 40,
    ),
  );
  static const _gegenPress = _Archetype(
    Formation.f4231,
    TacticalInstructions(
      mentality: 64,
      pressing: 80,
      tempo: 66,
      width: 58,
      defensiveLine: 72,
      directness: 44,
    ),
  );
  static const _possession = _Archetype(
    Formation.f4231,
    TacticalInstructions(
      mentality: 58,
      pressing: 56,
      tempo: 42,
      width: 54,
      defensiveLine: 58,
      directness: 32,
    ),
  );
  static const _frontFoot = _Archetype(
    Formation.f343,
    TacticalInstructions(
      mentality: 62,
      pressing: 60,
      tempo: 60,
      width: 62,
      defensiveLine: 60,
      directness: 50,
    ),
  );
  static const _balanced = _Archetype(
    Formation.f442,
    TacticalInstructions(),
  );
  static const _balancedWide = _Archetype(
    Formation.f433,
    TacticalInstructions(
      mentality: 52,
      pressing: 50,
      tempo: 54,
      width: 64,
      defensiveLine: 50,
      directness: 55,
    ),
  );
  static const _direct = _Archetype(
    Formation.f442,
    TacticalInstructions(
      mentality: 50,
      pressing: 46,
      tempo: 68,
      width: 60,
      defensiveLine: 46,
      directness: 74,
    ),
  );
  static const _counter = _Archetype(
    Formation.f4141,
    TacticalInstructions(
      mentality: 42,
      pressing: 40,
      tempo: 64,
      width: 52,
      defensiveLine: 40,
      directness: 70,
    ),
  );
  static const _lowBlock = _Archetype(
    Formation.f451,
    TacticalInstructions(
      mentality: 32,
      pressing: 32,
      tempo: 52,
      width: 40,
      defensiveLine: 30,
      directness: 64,
    ),
  );
  static const _parkBus = _Archetype(
    Formation.f541,
    TacticalInstructions(
      mentality: 24,
      pressing: 26,
      tempo: 46,
      width: 34,
      defensiveLine: 24,
      directness: 68,
    ),
  );

  // Posture pools by strength gap (opponent minus player).
  static const _favourite = [_dominant, _gegenPress, _possession];
  static const _strong = [_possession, _frontFoot, _balancedWide];
  static const _even = [_balanced, _balancedWide, _possession, _direct];
  static const _weak = [_counter, _direct, _lowBlock, _balanced];
  static const _underdog = [_lowBlock, _parkBus, _counter];
}

class _Archetype {
  const _Archetype(this.formation, this.instructions);
  final Formation formation;
  final TacticalInstructions instructions;
}
