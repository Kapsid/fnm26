import 'package:fnm/core/util/text_variety.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/match/stadium/kick_off.dart';
import 'package:fnm/domain/services/match/stadium/nation_latitudes.dart';

/// The weather a match is played in: what the Pitch view draws, and (since
/// 1.2) what the match plays in. Both simulators read it through
/// `MatchConditions.weather` (see `WeatherPlay`), from the one function
/// [MatchWeather.forFixture], so what is shown is what was played.
///
/// Never stored: it is worked out again for every fixture.
/// New kinds go on the end all the same, so the order of the old ones never
/// moves.
enum WeatherKind {
  clear,

  /// Light rain (the old plain "rain": its name kept).
  rain,
  snow,

  /// A warm heat shimmer (the Gulf).
  haze,
  heavyRain,

  /// Heavy rain and, now and then, a soft flash of lightning.
  thunderstorm,

  /// A cold grey fog that swallows the far stand and the city behind it.
  fog,

  /// Rain (or, in the cold, snow) driven at a slant; flags and scarves
  /// streaming.
  windy,

  /// An ochre dust storm (the Gulf, the Sahel in the dry season).
  dustStorm,

  /// A clear, frosty night: rime at the pitch edges, breath in the air.
  frostyNight;

  /// Whether rain falls (of any strength).
  bool get isRain =>
      this == rain ||
      this == heavyRain ||
      this == thunderstorm ||
      this == windy;
}

/// The weather at a ground, by its climate, the date and the kick-off: rain
/// in Britain and the north, snow in a northern winter, heat haze and dust
/// in the Gulf, storms in the tropics' wet season, fog and frost on northern
/// winter evenings. The same match always gets the same weather.
abstract final class MatchWeather {
  /// The wet maritime north: Britain, Ireland, the Low Countries and the
  /// Nordic coast.
  static const Set<String> wetNorth = {
    'ENG', 'SCO', 'WAL', 'NIR', 'IRL', 'NED', 'BEL', 'DEN', 'NOR', 'ISL', //
    'FRO', 'GRL',
  };

  /// The Gulf, where summer heat shimmers over the ground.
  static const Set<String> gulf = {
    'QAT', 'UAE', 'KSA', 'KUW', 'BHR', 'OMA', 'IRQ', //
  };

  /// The Sahel, dusty in its dry season (the harmattan).
  static const Set<String> sahel = {
    'MLI', 'NIG', 'CHA', 'BFA', 'SEN', 'MTN', 'SDN', 'GAM', //
  };

  /// Where the wind blows hardest: the British Isles, Iceland, the Faroes,
  /// Greenland and New Zealand. (Patagonia is a corner of Argentina and
  /// Chile: see [_windyChance].)
  static const Set<String> windy = {
    'ENG', 'SCO', 'WAL', 'NIR', 'IRL', 'ISL', 'FRO', 'GRL', 'NZL', //
  };

  /// Southeast Asia and West and Central Africa: thunderstorms in the wet
  /// season. (South America and the Americas' tropics are found by their
  /// confederation and latitude.)
  static const Set<String> stormBelt = {
    // Southeast Asia
    'THA', 'VIE', 'CAM', 'LAO', 'MYA', 'MAS', 'SGP', 'IDN', 'PHI', 'BRU', //
    'TLS',
    // West and Central Africa
    'BEN', 'BFA', 'CMR', 'CTA', 'CHA', 'CGO', 'COD', 'EQG', 'GAB', 'GHA', //
    'GUI', 'GNB', 'CIV', 'LBR', 'NGA', 'SLE', 'TOG', 'STP', 'MLI', 'SEN',
    'GAM', 'NIG', 'MTN',
  };

  /// The weather [fixture] is played in, at a ground in the country [code]
  /// of [confederation], for the save [saveSeed]: its kick-off read off the
  /// save and the fixture ([KickOff.forFixture]), then [of].
  ///
  /// The ONE function the Pitch view, the shown match and the background
  /// simulation all read, from the fixture, the ground and the save alone.
  static WeatherKind forFixture({
    required Fixture fixture,
    required String code,
    required Confederation confederation,
    required int saveSeed,
  }) => of(
    code: code,
    confederation: confederation,
    date: fixture.date,
    fixtureId: fixture.id,
    kickOffHours: KickOff.forFixture(fixture, saveSeed).hours,
  );

  /// The weather for the match [fixtureId] on [date] at a ground in the
  /// country [code] of [confederation], kicking off at [kickOffHours] local
  /// time (fog and frost come in the evening, storms in the afternoon; null
  /// is taken as mid-afternoon).
  static WeatherKind of({
    required String code,
    required Confederation confederation,
    required DateTime date,
    required int fixtureId,
    double? kickOffHours,
  }) {
    final c = code.toUpperCase();
    final lat = NationLatitudes.ofCode(c, confederation);
    // The month as the northern hemisphere has it.
    final m = lat >= 0 ? date.month : (date.month + 5) % 12 + 1;
    final h = kickOffHours ?? 15;
    final evening = h >= 17.5;
    final roll =
        varietySeed(
          'weather:$fixtureId:$c:${date.year}-${date.month}-${date.day}',
        ) %
        1000 /
        1000;

    // The bands in turn: the first the roll falls in wins; past them all,
    // the sky is clear.
    var edge = 0.0;
    bool band(double p) {
      edge += p;
      return roll < edge;
    }

    if (gulf.contains(c)) {
      final hot = m >= 4 && m <= 10;
      if (band(hot ? 0.06 : 0.03)) return WeatherKind.dustStorm;
      if (band(hot ? 0.64 : 0.22)) return WeatherKind.haze;
      return WeatherKind.clear;
    }
    if (sahel.contains(c) && (m >= 11 || m <= 4)) {
      if (band(0.08)) return WeatherKind.dustStorm;
      if (band(0.06)) return WeatherKind.haze;
      if (band(0.03)) return WeatherKind.rain;
      return WeatherKind.clear;
    }

    final winter = m == 12 || m == 1 || m == 2;
    final tropics = lat.abs() < 23.5;
    final storms = _stormChance(c, confederation, lat, m, h);
    final wetSeason = tropics && storms > 0.03;
    final snow = !winter || lat < 45
        ? (m == 3 && lat >= 55 ? 0.2 : 0.0)
        : lat >= 55
        ? 0.4
        : 0.25;
    final rain =
        (wetNorth.contains(c)
            ? 0.4
            : lat >= 45
            ? 0.22
            : tropics
            ? (wetSeason ? 0.26 : 0.16)
            : 0.12) *
        (1 - snow);
    final storm = storms.clamp(0.0, rain * 0.5);
    final heavyShare = wetSeason
        ? 0.45
        : wetNorth.contains(c)
        ? 0.3
        : 0.25;
    final coldNorth = lat >= 44;
    final fog = coldNorth && (m >= 10 || m <= 2)
        ? (evening ? 0.08 : 0.035)
        : 0.0;
    final frost = coldNorth && (m >= 11 || m <= 3) && evening && h < 22.5
        ? 0.09
        : 0.0;

    if (band(snow)) return WeatherKind.snow;
    if (band(storm)) return WeatherKind.thunderstorm;
    if (band(_windyChance(c, m))) return WeatherKind.windy;
    if (band(fog)) return WeatherKind.fog;
    if (band((rain - storm) * heavyShare)) return WeatherKind.heavyRain;
    if (band((rain - storm) * (1 - heavyShare))) return WeatherKind.rain;
    if (band(frost)) return WeatherKind.frostyNight;
    return WeatherKind.clear;
  }

  /// How likely a gale is: a wild autumn to spring on the Atlantic's edge,
  /// all year round in New Zealand, now and then in Patagonia.
  static double _windyChance(String c, int m) {
    if (c == 'ARG' || c == 'CHI') return 0.03;
    if (!windy.contains(c)) return 0;
    if (c == 'NZL') return 0.06;
    return m >= 9 || m <= 4 ? 0.08 : 0.04;
  }

  /// How likely a thunderstorm is: in the wet season of the tropics and
  /// South America, and on a summer afternoon in the southern US and
  /// Mexico; likelier still for an afternoon kick-off.
  static double _stormChance(
    String c,
    Confederation confederation,
    double lat,
    int m,
    double h,
  ) {
    final wet = m >= 5 && m <= 10;
    final afternoon = h >= 13 && h < 19.5 ? 1.4 : 1.0;
    final belt =
        stormBelt.contains(c) ||
        (confederation == Confederation.southAmerica && c != 'CHI') ||
        (confederation == Confederation.northAmerica && lat < 26);
    if (belt) return (wet ? 0.06 : 0.012) * afternoon;
    if (c == 'USA' && m >= 6 && m <= 8) return 0.04 * afternoon;
    return 0;
  }
}
