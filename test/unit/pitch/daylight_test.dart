import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/match/stadium/daylight.dart';
import 'package:fnm/domain/services/match/stadium/kick_off.dart';
import 'package:fnm/domain/services/match/stadium/nation_latitudes.dart';
import 'package:fnm/domain/services/nation/dormant_nations.dart';

Fixture _fixture(int id) => Fixture(
  id: id,
  careerId: 1,
  competitionId: 1,
  matchday: 1,
  date: DateTime(2026, 6, 10),
  homeNationId: 1,
  awayNationId: 2,
);

void main() {
  group('Daylight', () {
    test('Oslo at 21:00 in June is day or dusk', () {
      final l = Daylight.of(
        59.9,
        DateTime(2026, 6, 20),
        const KickOffTime(21, 0),
      );
      expect(l.mode, anyOf(LightMode.day, LightMode.dusk));
    });

    test('Madrid at 21:00 in November is night', () {
      final l = Daylight.of(
        40.4,
        DateTime(2026, 11, 15),
        const KickOffTime(21, 0),
      );
      expect(l.mode, LightMode.night);
    });

    test('the equator at 19:00 is night, whatever the month', () {
      for (var m = 1; m <= 12; m++) {
        final l = Daylight.of(
          0,
          DateTime(2026, m, 15),
          const KickOffTime(19, 0),
        );
        expect(l.mode, LightMode.night, reason: 'month $m');
      }
    });

    test('an 18:30 kick-off at 50°N in September goes from day through '
        'dusk to night', () {
      const ko = KickOffTime(18, 30);
      final date = DateTime(2026, 9);
      final modes = [
        for (var m = 1; m <= 90; m++) Daylight.at(50, date, ko, m).mode,
      ];
      expect(modes.first, LightMode.day);
      expect(modes, contains(LightMode.dusk));
      expect(modes.last, LightMode.night);
      // In that order, never back.
      final order = modes.map((m) => m.index).toList();
      for (var i = 1; i < order.length; i++) {
        expect(order[i], greaterThanOrEqualTo(order[i - 1]));
      }
    });

    test('the floodlights never go down during a match', () {
      for (final lat in [-35.0, 0.0, 40.0, 60.0]) {
        for (final month in [1, 4, 7, 10]) {
          for (final ko in const [
            KickOffTime(14, 0),
            KickOffTime(15, 0),
            KickOffTime(18, 0),
            KickOffTime(20, 45),
            KickOffTime(21, 0),
          ]) {
            var last = -1.0;
            for (var m = 1; m <= 120; m++) {
              for (final s in m == 45 || m == 90 ? [0, 3] : [0]) {
                final f = Daylight.at(
                  lat,
                  DateTime(2026, month, 12),
                  ko,
                  m,
                  stoppage: s,
                ).flood;
                expect(f, greaterThanOrEqualTo(last - 1e-12));
                last = f;
              }
            }
          }
        }
      }
    });

    test('the light is deterministic', () {
      final a = Daylight.at(
        50,
        DateTime(2026, 9, 3),
        const KickOffTime(19, 0),
        60,
      );
      final b = Daylight.at(
        50,
        DateTime(2026, 9, 3),
        const KickOffTime(19, 0),
        60,
      );
      expect(a, b);
    });

    test('the clock runs on through the intervals', () {
      expect(Daylight.clockMinutes(45), 45);
      expect(Daylight.clockMinutes(46), 61);
      expect(Daylight.clockMinutes(90, stoppage: 4), 109);
      expect(Daylight.clockMinutes(91), 111);
      expect(Daylight.clockMinutes(106), 127);
    });

    test('floodlights: off by day, full at night, ramping through dusk', () {
      expect(const PitchLight(10).flood, 0);
      expect(const PitchLight(0).flood, closeTo(0.5, 1e-9));
      expect(const PitchLight(-10).flood, 1);
    });
  });

  group('KickOff', () {
    test('the same fixture and seed always kick off at the same time', () {
      for (var id = 1; id < 50; id++) {
        expect(
          KickOff.localTime(_fixture(id), CompetitionKind.friendly, 7),
          KickOff.localTime(_fixture(id), CompetitionKind.friendly, 7),
        );
      }
    });

    test('friendlies are mostly evening games, about a fifth afternoon', () {
      var evening = 0, afternoon = 0;
      for (var id = 1; id <= 2000; id++) {
        final t = KickOff.localTime(_fixture(id), CompetitionKind.friendly, 3);
        if (t.hour >= 18 && t.hours <= 20.75) evening++;
        if (t.hour < 18) afternoon++;
      }
      expect(evening + afternoon, 2000);
      expect(afternoon / 2000, inInclusiveRange(0.15, 0.25));
    });

    test('tournaments use their slots', () {
      final slots = {
        for (var id = 1; id <= 500; id++)
          KickOff.localTime(
            _fixture(id),
            CompetitionKind.worldCupFinals,
            9,
          ).label,
      };
      expect(slots, {'15:00', '18:00', '21:00'});
    });
  });

  test('every nation, dormant ones included, has a latitude', () {
    final nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List)
            .cast<Map<String, Object?>>();
    final codes = {
      for (final n in nations) n['code']! as String,
      for (final n in DormantNations.all) n.code,
    };
    final missing = codes.where((c) => !NationLatitudes.table.containsKey(c));
    expect(missing, isEmpty);
    for (final v in NationLatitudes.table.values) {
      expect(v, inInclusiveRange(-90, 90));
    }
  });
}
