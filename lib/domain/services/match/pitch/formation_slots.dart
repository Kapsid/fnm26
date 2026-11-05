/// The formation slot coordinates shared by the tactics board and the Pitch
/// view: pure data and arithmetic, no Flutter.
library;

import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';

/// Normalised pitch coordinates per formation (x: 0=left…1=right,
/// y: 0=attack…1=own goal), in the same slot order as `Formation.positions`.
const _layouts = <Formation, List<(double, double)>>{
  Formation.f442: [
    (0.5, 0.90),
    (0.12, 0.70),
    (0.37, 0.73),
    (0.63, 0.73),
    (0.88, 0.70),
    (0.12, 0.45),
    (0.38, 0.48),
    (0.62, 0.48),
    (0.88, 0.45),
    (0.38, 0.16),
    (0.62, 0.16),
  ],
  Formation.f433: [
    (0.5, 0.90),
    (0.12, 0.70),
    (0.37, 0.73),
    (0.63, 0.73),
    (0.88, 0.70),
    (0.5, 0.55),
    (0.30, 0.42),
    (0.70, 0.42),
    (0.16, 0.18),
    (0.5, 0.13),
    (0.84, 0.18),
  ],
  Formation.f352: [
    (0.5, 0.90),
    (0.28, 0.73),
    (0.5, 0.76),
    (0.72, 0.73),
    (0.10, 0.45),
    (0.30, 0.50),
    (0.5, 0.52),
    (0.70, 0.50),
    (0.90, 0.45),
    (0.38, 0.16),
    (0.62, 0.16),
  ],
  // The back four sits deeper here than in the flat shapes: the two holding
  // midfielders are directly above the centre-halves on the same x, so with a
  // high defensive line pushing the defenders up they ended up almost on top
  // of each other. Everything else about the shape is unchanged.
  Formation.f4231: [
    (0.5, 0.90),
    (0.12, 0.76),
    (0.37, 0.79),
    (0.63, 0.79),
    (0.88, 0.76),
    (0.38, 0.56),
    (0.62, 0.56),
    (0.5, 0.38),
    (0.16, 0.22),
    (0.84, 0.22),
    (0.5, 0.14),
  ],
  Formation.f532: [
    (0.5, 0.90),
    (0.08, 0.62),
    (0.30, 0.74),
    (0.5, 0.76),
    (0.70, 0.74),
    (0.92, 0.62),
    (0.30, 0.45),
    (0.5, 0.48),
    (0.70, 0.45),
    (0.38, 0.16),
    (0.62, 0.16),
  ],
  Formation.f4141: [
    (0.5, 0.90),
    (0.12, 0.70),
    (0.37, 0.73),
    (0.63, 0.73),
    (0.88, 0.70),
    (0.5, 0.56),
    (0.14, 0.38),
    (0.38, 0.40),
    (0.62, 0.40),
    (0.86, 0.38),
    (0.5, 0.15),
  ],
  Formation.f343: [
    (0.5, 0.90),
    (0.28, 0.74),
    (0.5, 0.76),
    (0.72, 0.74),
    (0.10, 0.48),
    (0.38, 0.50),
    (0.62, 0.50),
    (0.90, 0.48),
    (0.18, 0.18),
    (0.5, 0.14),
    (0.82, 0.18),
  ],
  // Like 4-2-3-1 and 4-1-2-1-2, the two holding midfielders sit close in front
  // of the centre-halves, so the back four is drawn deeper to leave a line's
  // worth of room between them.
  Formation.f4222: [
    (0.5, 0.90),
    (0.12, 0.75),
    (0.37, 0.78),
    (0.63, 0.78),
    (0.88, 0.75),
    (0.35, 0.52),
    (0.65, 0.52),
    (0.22, 0.34),
    (0.78, 0.34),
    (0.38, 0.15),
    (0.62, 0.15),
  ],
  Formation.f424: [
    (0.5, 0.90),
    (0.12, 0.70),
    (0.37, 0.73),
    (0.63, 0.73),
    (0.88, 0.70),
    (0.35, 0.50),
    (0.65, 0.50),
    (0.14, 0.20),
    (0.38, 0.15),
    (0.62, 0.15),
    (0.86, 0.20),
  ],
  Formation.f41212: [
    (0.5, 0.90),
    (0.12, 0.76),
    (0.37, 0.79),
    (0.63, 0.79),
    (0.88, 0.76),
    (0.5, 0.58),
    (0.28, 0.45),
    (0.72, 0.45),
    (0.5, 0.31),
    (0.38, 0.15),
    (0.62, 0.15),
  ],
  Formation.f4411: [
    (0.5, 0.90),
    (0.12, 0.70),
    (0.37, 0.73),
    (0.63, 0.73),
    (0.88, 0.70),
    (0.12, 0.48),
    (0.38, 0.50),
    (0.62, 0.50),
    (0.88, 0.48),
    (0.5, 0.31),
    (0.5, 0.12),
  ],
  Formation.f4312: [
    (0.5, 0.90),
    (0.12, 0.70),
    (0.37, 0.73),
    (0.63, 0.73),
    (0.88, 0.70),
    (0.28, 0.50),
    (0.5, 0.53),
    (0.72, 0.50),
    (0.5, 0.32),
    (0.38, 0.15),
    (0.62, 0.15),
  ],
  Formation.f451: [
    (0.5, 0.90),
    (0.12, 0.70),
    (0.37, 0.73),
    (0.63, 0.73),
    (0.88, 0.70),
    (0.10, 0.45),
    (0.30, 0.48),
    (0.5, 0.50),
    (0.70, 0.48),
    (0.90, 0.45),
    (0.5, 0.15),
  ],
  Formation.f541: [
    (0.5, 0.90),
    (0.08, 0.70),
    (0.30, 0.74),
    (0.5, 0.76),
    (0.70, 0.74),
    (0.92, 0.70),
    (0.14, 0.45),
    (0.38, 0.48),
    (0.62, 0.48),
    (0.86, 0.45),
    (0.5, 0.15),
  ],
  Formation.f3421: [
    (0.5, 0.90),
    (0.28, 0.74),
    (0.5, 0.76),
    (0.72, 0.74),
    (0.10, 0.50),
    (0.38, 0.52),
    (0.62, 0.52),
    (0.90, 0.50),
    (0.32, 0.30),
    (0.68, 0.30),
    (0.5, 0.14),
  ],
  Formation.f3412: [
    (0.5, 0.90),
    (0.28, 0.74),
    (0.5, 0.76),
    (0.72, 0.74),
    (0.10, 0.50),
    (0.38, 0.52),
    (0.62, 0.52),
    (0.90, 0.50),
    (0.5, 0.32),
    (0.38, 0.15),
    (0.62, 0.15),
  ],
  Formation.f5212: [
    (0.5, 0.90),
    (0.08, 0.62),
    (0.30, 0.74),
    (0.5, 0.76),
    (0.70, 0.74),
    (0.92, 0.62),
    (0.35, 0.50),
    (0.65, 0.50),
    (0.5, 0.32),
    (0.38, 0.15),
    (0.62, 0.15),
  ],
  Formation.f4321: [
    (0.5, 0.90),
    (0.12, 0.70),
    (0.37, 0.73),
    (0.63, 0.73),
    (0.88, 0.70),
    (0.28, 0.52),
    (0.5, 0.55),
    (0.72, 0.52),
    (0.36, 0.32),
    (0.64, 0.32),
    (0.5, 0.13),
  ],
  // The five across midfield sit on the same spacing as 3-5-2's, which is the
  // widest the discs go without crowding: the wing-backs at 0.10/0.90 and the
  // three inside at 0.30/0.50/0.70.
  Formation.f3511: [
    (0.5, 0.90),
    (0.28, 0.73),
    (0.5, 0.76),
    (0.72, 0.73),
    (0.10, 0.45),
    (0.30, 0.50),
    (0.5, 0.52),
    (0.70, 0.50),
    (0.90, 0.45),
    (0.5, 0.29),
    (0.5, 0.11),
  ],
};

/// Where the keeper is pinned, as a fraction down the pitch. He never shifts
/// up it, so a deep defensive line cannot drop the back line on top of him.
const double keeperLine = 0.94;

/// A formation's base slot coordinates, before the instructions move anybody.
List<(double, double)> layoutOf(Formation f) => _layouts[f]!;

/// Where a slot actually sits up the pitch once the instructions have had their
/// say — the y half of what the pitch renders.
///
/// Shared with [resolveSpaceDrag] rather than duplicated: a drop is judged
/// against the line the manager can SEE, and a second copy of this arithmetic
/// would drift from the first exactly when a tactic is extreme.
double adjustedSlotY(
  double baseY,
  PositionCategory category,
  TacticalInstructions i,
) {
  if (category == PositionCategory.goalkeeper) return keeperLine;
  // Mentality used to lift the whole outfield up the pitch (and the forwards
  // further still), which squeezed the lines together at the attacking end and
  // left the shape bunched in the middle of the pitch. It is a mentality, not
  // a formation: what it changes is how the side plays, which the match engine
  // already reads — it has no business redrawing the shape the manager set.
  //
  // The defensive LINE does still move, because that is exactly what that dial
  // means, and it moves one line rather than all of them.
  var y = baseY;
  if (category == PositionCategory.defender) {
    // Small on purpose. This is the one dial that still moves a line, and it
    // moves it toward another one: at the old ±0.10 a high line was worth most
    // of a ball on a phone, which drove the back four bodily into midfield in
    // nearly every shape in the game.
    y -= (i.defensiveLine - 50) / 50 * 0.04;
  }
  return y;
}

/// Resolves a pitch drag from slot [a] onto slot [b]: within the same line it
