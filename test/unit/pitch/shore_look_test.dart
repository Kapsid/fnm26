import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/match/stadium/backdrop.dart';
import 'package:fnm/domain/services/match/stadium/city_geography.dart';
import 'package:fnm/domain/services/match/stadium/daylight.dart';
import 'package:fnm/domain/services/match/stadium/shore_look.dart';
import 'package:fnm/domain/services/match/stadium/stadium_spec.dart';
import 'package:fnm/domain/services/nation/dormant_nations.dart';
import 'package:fnm/features/match/pitch/backdrop_painter.dart';
import 'package:fnm/features/match/pitch/scene_look.dart';

const _away = Nation(
  id: 900,
  name: 'Away',
  code: 'FRO',
  confederation: Confederation.europe,
  ranking: 120,
  primaryColor: '#FFFFFF',
  secondaryColor: '#0055A4',
);

Nation _nation(String code, Confederation confederation) => Nation(
  id: 901,
  name: code,
  code: code,
  confederation: confederation,
  ranking: 150,
  primaryColor: '#123456',
);

StadiumSpec _spec(
  Nation home,
  String city, {
  int capacity = 10000,
  DateTime? date,
}) => StadiumSpec.from(
  (
    stadium: 'Mock Ground',
    city: city,
    groundNationId: home.id,
    capacity: capacity,
    attendance: capacity ~/ 2,
    soldOut: false,
  ),
  home,
  _away,
  0.1,
  groundNationCode: home.code,
  groundConfederation: home.confederation,
  date: date ?? DateTime(2026, 7, 10),
);

/// The backdrop of [spec] in [look], as raw pixels.
Future<Uint8List> _pixels(StadiumSpec spec, SceneLook look) async {
  const size = Size(390, 120);
  final recorder = ui.PictureRecorder();
  BackdropPainter(
    horizon: spec.horizon,
    city: spec.city,
    season: spec.season,
    landmark: spec.landmark,
    features: spec.features,
    shore: spec.shore,
    look: look,
    seed: '${spec.flagCode}:${spec.landmark.name}:${spec.tiers}',
  ).paint(Canvas(recorder), size, 90);
  final picture = recorder.endRecording();
  final image = await picture.toImage(390, 120);
  final bytes = await image.toByteData();
  picture.dispose();
  image.dispose();
  return bytes!.buffer.asUint8List();
}

void main() {
  group('which grounds get the island looks', () {
    test('Greenland is arctic in every one of its towns', () {
      for (final city in ['Nuuk', 'Sisimiut', 'Ilulissat']) {
        final spec = _spec(DormantNations.greenland, city, capacity: 2000);
        expect(spec.shore.arctic, isTrue, reason: city);
        expect(spec.shore.beach, isFalse, reason: city);
        expect(spec.shore.sails, Sails.none, reason: city);
        expect(spec.horizon, Horizon.fjords, reason: city);
        expect(spec.city, CityStyle.smallTown, reason: city);
      }
    });

    test('a coastal Zanzibar ground gets its beach, palms and dhows', () {
      for (final (city, capacity) in [
        ('Zanzibar City', 15000),
        ('Chake-Chake', 10000),
      ]) {
        final spec = _spec(DormantNations.zanzibar, city, capacity: capacity);
        expect(
          spec.shore,
          const ShoreLook(beach: true, sails: Sails.dhows),
          reason: city,
        );
        expect(spec.horizon, Horizon.sea, reason: city);
      }
    });

    test('a Caribbean or Pacific beach gets sailboats, not dhows', () {
      final jamaica = _nation('JAM', Confederation.northAmerica);
      expect(
        _spec(jamaica, 'Kingston').shore,
        const ShoreLook(beach: true, sails: Sails.sailboats),
      );
      final fiji = _nation('FIJ', Confederation.oceania);
      expect(
        _spec(fiji, 'Suva').shore,
        const ShoreLook(beach: true, sails: Sails.sailboats),
      );
    });

    test('an inland city of a tropical nation gets none of it', () {
      final cuba = _nation('CUB', Confederation.northAmerica);
      expect(_spec(cuba, 'Santa Clara').shore, ShoreLook.none);
      final jamaica = _nation('JAM', Confederation.northAmerica);
      expect(_spec(jamaica, 'Mandeville').shore, ShoreLook.none);
      final png = _nation('PNG', Confederation.oceania);
      expect(_spec(png, 'Mount Hagen').shore, ShoreLook.none);
      // A city the table does not know is not assumed to be on the coast.
      expect(_spec(jamaica, 'Nowhere Town').shore, ShoreLook.none);
    });

    test('the Swahili coast has dhows on the water but no island beach', () {
      final tanzania = _nation('TAN', Confederation.africa);
      expect(
        _spec(tanzania, 'Dar es Salaam').shore,
        const ShoreLook(sails: Sails.dhows),
      );
      expect(_spec(tanzania, 'Dodoma').shore, ShoreLook.none);
    });

    test('nations outside the lists are unchanged', () {
      for (final (code, confederation, city) in [
        ('CZE', Confederation.europe, 'Brno'),
        ('NOR', Confederation.europe, 'Bergen'),
        ('FRO', Confederation.europe, 'Tórshavn'),
        ('MLT', Confederation.europe, 'Valletta'),
        ('NGA', Confederation.africa, 'Lagos'),
        ('BRA', Confederation.southAmerica, 'Rio de Janeiro'),
      ]) {
        final spec = _spec(_nation(code, confederation), city);
        expect(spec.shore, ShoreLook.none, reason: '$code $city');
        expect(spec.shore.isNone, isTrue);
      }
    });

    test('only the listed island codes and Greenland are named', () {
      expect(ShoreLook.arcticNations, {'GRL'});
      expect(ShoreLook.tropicalIslands, contains('ZAN'));
      expect(ShoreLook.tropicalIslands, isNot(contains('GRL')));
      expect(ShoreLook.dhowCoasts, containsAll(['ZAN', 'TAN', 'KEN']));
    });

    test('the same fixture always gets the same look', () {
      for (final (home, city) in [
        (DormantNations.greenland, 'Nuuk'),
        (DormantNations.zanzibar, 'Zanzibar City'),
      ]) {
        expect(_spec(home, city).shore, _spec(home, city).shore);
        expect(
          ShoreLook.of(
            home.code,
            features: CityGeography.of(home.code, city),
            horizon: _spec(home, city).horizon,
          ),
          _spec(home, city).shore,
        );
      }
    });
  });

  group('the arctic snow season', () {
    BackdropSeason greenland(int month) => _spec(
      DormantNations.greenland,
      'Nuuk',
      date: DateTime(2026, month, 15),
    ).season;

    test('snow lies in Greenland from October to May', () {
      for (final m in [10, 11, 12, 1, 2, 3, 4, 5]) {
        expect(greenland(m), BackdropSeason.snow, reason: 'month $m');
      }
      for (final m in [6, 7, 8, 9]) {
        expect(greenland(m), isNot(BackdropSeason.snow), reason: 'month $m');
      }
    });

    test('elsewhere at the same latitude the season is as before', () {
      for (final m in [4, 5, 10]) {
        expect(
          BackdropSeason.at(
            latitude: 64.2,
            date: DateTime(2026, m, 15),
            continental: true,
          ),
          isNot(BackdropSeason.snow),
          reason: 'month $m',
        );
      }
    });
  });

  group('the painted backdrop', () {
    testWidgets('the same ground paints the same pixels every time', (
      tester,
    ) async {
      await tester.runAsync(() async {
        for (final (home, city) in [
          (DormantNations.greenland, 'Nuuk'),
          (DormantNations.zanzibar, 'Zanzibar City'),
        ]) {
          final spec = _spec(home, city);
          for (final light in [PitchLight.day, PitchLight.night]) {
            final look = SceneLook.at(light);
            expect(await _pixels(spec, look), await _pixels(spec, look));
          }
        }
      });
    });

    testWidgets('the island looks add to the backdrop they are laid on', (
      tester,
    ) async {
      await tester.runAsync(() async {
        for (final (home, city) in [
          (DormantNations.greenland, 'Nuuk'),
          (DormantNations.zanzibar, 'Zanzibar City'),
        ]) {
          final spec = _spec(home, city);
          final bare = spec.withLook(shore: ShoreLook.none);
          expect(
            await _pixels(spec, SceneLook.day),
            isNot(await _pixels(bare, SceneLook.day)),
            reason: city,
          );
        }
      });
    });
  });
}
