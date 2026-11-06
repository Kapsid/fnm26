import 'dart:ui' show Color;

import 'package:fnm/core/theme/kit_colors.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/match/attendance.dart';
import 'package:fnm/domain/services/match/stadium/backdrop.dart';
import 'package:fnm/domain/services/match/stadium/ground_look.dart';
import 'package:fnm/domain/services/match/stadium/landmarks.dart';
import 'package:fnm/domain/services/match/stadium/nation_latitudes.dart';

/// What the stadium looks like for one match: size from capacity, crowd from
/// attendance, colours from the two kits, the ground's own look (its mowing
/// and its goals), the city and the horizon behind it, and what the season
/// has done to them on the day.
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
    this.neutral = false,
    this.mowing = MowingPattern.stripes,
    this.goalStyle = GoalStyle.sloped,
    this.city = CityStyle.oldEuropean,
    this.horizon = Horizon.forestHills,
    this.season = BackdropSeason.green,
  });

  /// The spec for [g] between [home] and [away] in the country
  /// [groundNationCode] (the home nation's unless the venue is neutral),
  /// with the season of [date] (green when there is none).
  factory StadiumSpec.from(
    MatchGround g,
    Nation home,
    Nation away,
    double awayShare, {
    required String groundNationCode,
    Confederation? groundConfederation,
    DateTime? date,
  }) {
    final tiers = g.capacity < 15000 ? 1 : (g.capacity < 45000 ? 2 : 3);
    final kits = KitClash.resolve(home, away);
    final confed = groundConfederation ?? home.confederation;
    final (city, horizon) = NationBackdrops.of(
      groundNationCode,
      confed,
      capacity: g.capacity,
    );
    return StadiumSpec(
      tiers: tiers,
      openCorners: tiers == 1,
      fill: g.capacity <= 0 ? 0 : (g.attendance / g.capacity).clamp(0.0, 1.0),
      homeColour: kits.home.primary,
      awayColour: kits.away.primary,
      awayShare: awayShare,
      neutral: groundNationCode.toUpperCase() != home.code.toUpperCase(),
      flagCode: groundNationCode,
      landmark: Landmarks.forCity(g.city),
      mowing: MowingPattern.forStadium(g.stadium),
      goalStyle: GoalStyle.forGround(
        stadium: g.stadium,
        groundCode: groundNationCode,
        confederation: confed,
        capacity: g.capacity,
      ),
      city: city,
      horizon: horizon,
      season: date == null
          ? BackdropSeason.green
          : BackdropSeason.at(
              latitude: NationLatitudes.ofCode(groundNationCode, confed),
              date: date,
              continental: NationBackdrops.continental(
                groundNationCode,
                confed,
              ),
            ),
    );
  }

  /// This ground with parts of its look swapped, for previews and mocks.
  StadiumSpec withLook({
    MowingPattern? mowing,
    GoalStyle? goalStyle,
    CityStyle? city,
    Horizon? horizon,
    BackdropSeason? season,
    LandmarkKind? landmark,
    double? fill,
  }) => StadiumSpec(
    tiers: tiers,
    openCorners: openCorners,
    fill: fill ?? this.fill,
    homeColour: homeColour,
    awayColour: awayColour,
    awayShare: awayShare,
    neutral: neutral,
    flagCode: flagCode,
    landmark: landmark ?? this.landmark,
    mowing: mowing ?? this.mowing,
    goalStyle: goalStyle ?? this.goalStyle,
    city: city ?? this.city,
    horizon: horizon ?? this.horizon,
    season: season ?? this.season,
  );

  final int tiers;
  final bool openCorners;

  /// How full the ground is, 0 to 1: the crowd's density.
  final double fill;
  final Color homeColour;
  final Color awayColour;

  /// How much of the crowd follows the away side, 0 to 1.
  final double awayShare;

  /// A third country's ground: neither side has an end to itself, so the
  /// two followings mix.
  final bool neutral;
  final String flagCode;
  final LandmarkKind landmark;
  final MowingPattern mowing;
  final GoalStyle goalStyle;

  /// The near layer of the backdrop: the city round the ground.
  final CityStyle city;

  /// The far layer of the backdrop: the land on the horizon.
  final Horizon horizon;
  final BackdropSeason season;
}
