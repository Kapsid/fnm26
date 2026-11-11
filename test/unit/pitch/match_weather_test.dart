import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/match/stadium/match_weather.dart';
import 'package:fnm/features/match/pitch/weather_painter.dart';

import '../../helpers/pitch_view_fixture.dart';

/// The share of each weather over many fixtures at a ground in [code] in
/// the [months], kick-offs spread over the afternoon and the evening.
Map<WeatherKind, double> _shares(
  String code,
  List<int> months, {
  List<double> hours = const [13, 15, 16, 18, 19, 20.75],
}) {
  final n = {for (final k in WeatherKind.values) k: 0};
  var total = 0;
  final conf = pitchNation(code).confederation;
  for (final m in months) {
    for (var id = 1; id <= 1000; id++) {
      final w = MatchWeather.of(
        code: code,
        confederation: conf,
        date: DateTime(2026, m, 1 + id % 28),
        fixtureId: id * 7 + m,
        kickOffHours: hours[id % hours.length],
      );
      n[w] = n[w]! + 1;
      total++;
    }
  }
  return {for (final e in n.entries) e.key: e.value / total};
}

const _winter = [11, 12, 1, 2];
const _all = [1, 3, 5, 7, 9, 11];

void main() {
  group('climate', () {
    test('clear is the most common weather almost everywhere', () {
      for (final (code, months) in [
        ('ENG', _all),
        ('SCO', _all),
        ('POL', _winter),
        ('ESP', _all),
        ('BRA', [12, 1, 2]),
        ('THA', [6, 8]),
        ('NGA', [7, 8]),
        ('MEX', [7, 8]),
        ('USA', [6, 7]),
        ('QAT', [12, 1]),
        ('MLI', [12, 1]),
        ('NZL', _all),
        ('ISL', [6, 7]),
      ]) {
        final s = _shares(code, months);
        final top = s.entries.reduce((a, b) => a.value >= b.value ? a : b);
        expect(top.key, WeatherKind.clear, reason: '$code $months');
      }
    });

    test('each new kind is rare but seen in its home climate', () {
      void band(String code, List<int> months, WeatherKind k) {
        final p = _shares(code, months)[k]!;
        expect(p, inInclusiveRange(0.025, 0.11), reason: '$code ${k.name}');
      }

      // Fog and frost: the cold north in autumn and winter.
      band('CZE', [10, 11, 12, 1, 2], WeatherKind.fog);
      band('POL', _winter, WeatherKind.fog);
      band('POL', _winter, WeatherKind.frostyNight);
      band('NOR', [12, 1, 2], WeatherKind.frostyNight);
      // Storms: the tropics' wet season, a summer in the southern US.
      band('BRA', [12, 1, 2, 3], WeatherKind.thunderstorm);
      band('THA', [5, 7, 9], WeatherKind.thunderstorm);
      band('NGA', [6, 7, 8, 9], WeatherKind.thunderstorm);
      band('MEX', [6, 7, 8, 9], WeatherKind.thunderstorm);
      band('USA', [6, 7, 8], WeatherKind.thunderstorm);
      // Gales: the British Isles, Iceland, the Faroes, New Zealand,
      // Patagonia.
      band('ENG', _all, WeatherKind.windy);
      band('SCO', _all, WeatherKind.windy);
      band('ISL', _all, WeatherKind.windy);
      band('FRO', _all, WeatherKind.windy);
      band('NZL', _all, WeatherKind.windy);
      band('ARG', _all, WeatherKind.windy);
      // Dust: the Gulf all year, the Sahel in the dry season.
      band('QAT', [5, 7, 9], WeatherKind.dustStorm);
      band('UAE', [5, 7, 9], WeatherKind.dustStorm);
      band('MLI', [11, 12, 1, 2, 3], WeatherKind.dustStorm);
      band('NIG', [11, 12, 1, 2, 3], WeatherKind.dustStorm);
      // A downpour: likelier in the wet tropics than in Spain.
      band('ESP', _all, WeatherKind.heavyRain);
      expect(
        _shares('THA', [6, 8])[WeatherKind.heavyRain],
        greaterThan(_shares('ESP', _all)[WeatherKind.heavyRain]!),
      );
    });

    test('never where it does not belong', () {
      void never(String code, List<int> months, WeatherKind k) =>
          expect(_shares(code, months)[k], 0, reason: '$code ${k.name}');

      // No snow in the tropics, no dust in Iceland.
      for (final code in ['BRA', 'THA', 'NGA', 'MEX', 'IDN', 'SGP']) {
        never(code, _all, WeatherKind.snow);
        never(code, _all, WeatherKind.fog);
        never(code, _all, WeatherKind.frostyNight);
      }
      for (final code in ['ISL', 'NOR', 'ENG', 'NZL', 'BRA']) {
        never(code, _all, WeatherKind.dustStorm);
      }
      for (final code in ['ISL', 'NOR', 'ENG', 'GER', 'QAT', 'CHI']) {
        never(code, _all, WeatherKind.thunderstorm);
      }
      for (final code in ['BRA', 'GER', 'QAT', 'THA', 'USA']) {
        never(code, _all, WeatherKind.windy);
      }
      // A dry season in the Sahel and the Gulf in summer: no storms.
      never('MLI', [12, 1, 2], WeatherKind.thunderstorm);
      never('QAT', [6, 7, 8], WeatherKind.heavyRain);
      // Frost is an evening's: never at an afternoon kick-off.
      expect(
        _shares('POL', _winter, hours: const [13, 15])[WeatherKind.frostyNight],
        0,
      );
      // Fog is likelier in the evening.
      expect(
        _shares('CZE', _winter, hours: const [20.75])[WeatherKind.fog],
        greaterThan(
          _shares('CZE', _winter, hours: const [14])[WeatherKind.fog]!,
        ),
      );
    });

    test('the same match always gets the same weather', () {
      for (var id = 1; id < 200; id++) {
        WeatherKind w() => MatchWeather.of(
          code: 'BRA',
          confederation: pitchNation('BRA').confederation,
          date: DateTime(2027, 1, 9),
          fixtureId: id,
          kickOffHours: 16,
        );
        expect(w(), w());
      }
    });
  });

  group('one door into the match', () {
    // Since 1.2 the weather plays, but only through `MatchConditions` and
    // `WeatherPlay`: the engine and the background simulator read its
    // factors there, never the weather itself, so no second reading of it
    // can grow up beside the one the Pitch view draws.
    test('only the conditions and their weather play read the weather', () {
      final readers = <String>[];
      for (final f in Directory('lib/domain').listSync(recursive: true)) {
        if (f is! File || !f.path.endsWith('.dart')) continue;
        if (f.path.contains('/stadium/')) continue;
        final src = f.readAsStringSync();
        if (src.contains('WeatherKind') || src.contains('MatchWeather')) {
          readers.add(f.path.split('/').last);
        }
      }
      expect(
        readers.toSet(),
        {'weather_play.dart', 'match_conditions.dart'},
      );
    });

    test('the enum keeps its first four kinds in place', () {
      // Nothing stores it, but the old order never moves all the same.
      expect(WeatherKind.values.take(4), [
        WeatherKind.clear,
        WeatherKind.rain,
        WeatherKind.snow,
        WeatherKind.haze,
      ]);
    });
  });

  group('the overlay', () {
    test('lightning: a soft flash a few times a minute at most', () {
      final w = WeatherOverlay(WeatherKind.thunderstorm, seed: 11);
      var flashes = 0;
      var peak = 0.0;
      var was = false;
      for (var t = 0.0; t < 600; t += 0.02) {
        final a = w.flashAt(t);
        peak = a > peak ? a : peak;
        final on = a > 0.5;
        if (on && !was) flashes++;
        was = on;
      }
      // Ten minutes: between ten and thirty flashes.
      expect(flashes, inInclusiveRange(10, 30));
      expect(peak, lessThanOrEqualTo(1));
      // Nothing flashes in any other weather.
      for (final k in WeatherKind.values) {
        if (k == WeatherKind.thunderstorm) continue;
        final o = WeatherOverlay(k, seed: 11);
        for (var t = 0.0; t < 120; t += 0.05) {
          expect(o.flashAt(t), 0);
        }
      }
    });

    test('every moving weather animates; the still ones are baked', () {
      for (final k in WeatherKind.values) {
        final still =
            k == WeatherKind.clear ||
            k == WeatherKind.haze ||
            k == WeatherKind.frostyNight;
        expect(WeatherOverlay(k).animates, !still, reason: k.name);
      }
    });

    testWidgets('each weather tiles once and is kept', (tester) async {
      const size = Size(390, 280);
      for (final k in WeatherKind.values) {
        for (final cold in [false, true]) {
          final w = WeatherOverlay(k, seed: 5, cold: cold);
          if (!w.animates) continue;
          for (final t in [0.0, 7.3, 31.0]) {
            final recorder = ui.PictureRecorder();
            w.paint(Canvas(recorder), size, t, pixelRatio: 2);
            recorder.endRecording().dispose();
          }
          final tile = w.debugTile!;
          final recorder = ui.PictureRecorder();
          w.paint(Canvas(recorder), size, 40, pixelRatio: 2);
          recorder.endRecording().dispose();
          expect(identical(w.debugTile, tile), isTrue, reason: k.name);
          w.dispose();
        }
      }
    });
  });
}
