import 'dart:ui' show Color;

import 'package:fnm/core/theme/kit_colors.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/match/attendance.dart';
import 'package:fnm/domain/services/match/stadium/landmarks.dart';

/// What the stadium looks like for one match: size from capacity, crowd from
/// attendance, colours from the two kits.
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
  });

  factory StadiumSpec.from(
    MatchGround g,
    Nation home,
    Nation away,
    double awayShare, {
    String? groundNationCode,
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
      flagCode: groundNationCode ?? _groundCode(g, home, away),
      landmark: Landmarks.forCity(g.city),
    );
  }

  /// The ground's nation is the home side or, at a neutral finals, a host that
  /// may be neither; callers then pass [groundNationCode].
  static String _groundCode(MatchGround g, Nation home, Nation away) =>
      g.groundNationId == away.id ? away.code : home.code;

  final int tiers;
  final bool openCorners;
  final double fill;
  final Color homeColour;
  final Color awayColour;
  final double awayShare;
  final String flagCode;
  final LandmarkKind landmark;
}
