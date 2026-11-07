import 'package:fnm/core/util/text_variety.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/match/stadium/nation_latitudes.dart';

/// The weather the Pitch view draws over a match. It is cosmetic only: no
/// match engine, rating or result ever reads it.
enum WeatherKind { clear, rain, snow, haze }

/// The weather at a ground, by its climate and the date: rain in Britain and
/// the north, snow in a northern winter, heat haze in the Gulf. The same
/// match always gets the same weather.
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

  /// The weather for the match [fixtureId] on [date] at a ground in the
  /// country [code] of [confederation].
  static WeatherKind of({
    required String code,
    required Confederation confederation,
    required DateTime date,
    required int fixtureId,
  }) {
    final c = code.toUpperCase();
    final lat = NationLatitudes.ofCode(c, confederation);
    // The month as the northern hemisphere has it.
    final m = lat >= 0 ? date.month : (date.month + 5) % 12 + 1;
    final winter = m == 12 || m == 1 || m == 2;
    final roll =
        varietySeed(
          'weather:$fixtureId:$c:${date.year}-${date.month}-${date.day}',
        ) %
        1000 /
        1000;

    if (gulf.contains(c)) {
      final hot = m >= 4 && m <= 10;
      if (roll < (hot ? 0.7 : 0.25)) return WeatherKind.haze;
      return WeatherKind.clear;
    }
    final north = lat >= 45;
    final snowChance = !winter || lat < 45
        ? (m == 3 && lat >= 55 ? 0.2 : 0.0)
        : lat >= 55
        ? 0.4
        : 0.25;
    if (roll < snowChance) return WeatherKind.snow;
    final rainChance = wetNorth.contains(c)
        ? 0.4
        : north
        ? 0.22
        : lat.abs() < 23
        ? 0.18
        : 0.12;
    if (roll < snowChance + rainChance) return WeatherKind.rain;
    return WeatherKind.clear;
  }
}
