import 'dart:ui' show Color;

import 'package:fnm/core/theme/kit_colors.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/match/attendance.dart';
import 'package:fnm/domain/services/match/stadium/ground_look.dart';
import 'package:fnm/domain/services/match/stadium/landmarks.dart';

/// What the stadium looks like for one match: size from capacity, crowd from
/// attendance, colours from the two kits, and the ground's own look (its
/// mowing, its goals and what stands behind it), fixed per ground.
class StadiumSpec {
  const StadiumSpec({
    required this.tiers,
    required this.openCorners,
    required this.fill,
    required this.homeColour,
    required this.awayColour,
    required this.awayShare,
    required this.flagCode,
    required this.landmark,
    this.mowing = MowingPattern.stripes,
    this.goalStyle = GoalStyle.sloped,
    this.terrain = Terrain.hills,
  });

  factory StadiumSpec.from(
    MatchGround g,
    Nation home,
    Nation away,
    double awayShare, {
    required String groundNationCode,
    Confederation? groundConfederation,
  }) {
    final tiers = g.capacity < 15000 ? 1 : (g.capacity < 45000 ? 2 : 3);
    final kits = KitClash.resolve(home, away);
    return StadiumSpec(
      tiers: tiers,
      openCorners: tiers == 1,
      fill: g.capacity <= 0 ? 0 : (g.attendance / g.capacity).clamp(0.0, 1.0),
      homeColour: kits.home.primary,
      awayColour: kits.away.primary,
      awayShare: awayShare,
      flagCode: groundNationCode,
      landmark: Landmarks.forCity(g.city),
      mowing: MowingPattern.forStadium(g.stadium),
      goalStyle: GoalStyle.forGround(
        stadium: g.stadium,
        groundCode: groundNationCode,
        confederation: groundConfederation ?? home.confederation,
        capacity: g.capacity,
      ),
      terrain: Terrain.forGround(
        groundCode: groundNationCode,
        capacity: g.capacity,
      ),
    );
  }

  /// This ground with parts of its look swapped, for previews and mocks.
  StadiumSpec withLook({
    MowingPattern? mowing,
    GoalStyle? goalStyle,
    Terrain? terrain,
    LandmarkKind? landmark,
  }) => StadiumSpec(
    tiers: tiers,
    openCorners: openCorners,
    fill: fill,
    homeColour: homeColour,
    awayColour: awayColour,
    awayShare: awayShare,
    flagCode: flagCode,
    landmark: landmark ?? this.landmark,
    mowing: mowing ?? this.mowing,
    goalStyle: goalStyle ?? this.goalStyle,
    terrain: terrain ?? this.terrain,
  );

  final int tiers;
  final bool openCorners;
  final double fill;
  final Color homeColour;
  final Color awayColour;
  final double awayShare;
  final String flagCode;
  final LandmarkKind landmark;
  final MowingPattern mowing;
  final GoalStyle goalStyle;
  final Terrain terrain;
}
