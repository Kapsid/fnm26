import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/venues.dart';
import 'package:fnm/domain/services/match/stadium/away_fan_share.dart';
import 'package:fnm/domain/services/match/stadium/backdrop.dart';
import 'package:fnm/domain/services/match/stadium/crowd_culture.dart';
import 'package:fnm/domain/services/match/stadium/daylight.dart';
import 'package:fnm/domain/services/match/stadium/landmarks.dart';
import 'package:fnm/domain/services/match/stadium/match_weather.dart';
import 'package:fnm/domain/services/match/stadium/stadium_signature.dart';
import 'package:fnm/domain/services/match/stadium/stadium_spec.dart';
import 'package:fnm/features/match/pitch/backdrop_painter.dart';
import 'package:fnm/features/match/pitch/landmark_paths.dart';
import 'package:fnm/features/match/pitch/match_dressing.dart';
import 'package:fnm/features/match/pitch/pitch_projection.dart';
import 'package:fnm/features/match/pitch/scene_look.dart';
import 'package:fnm/features/match/pitch/stadium_painter.dart';
import 'package:fnm/features/match/pitch/weather_painter.dart';

import '../../helpers/pitch_view_fixture.dart';

/// Every nation in the game's data.
final List<Nation> _nations = [
  for (final n
      in (jsonDecode(File('assets/data/nations.json').readAsStringSync())
              as List)
          .cast<Map<String, Object?>>())
    pitchNation(n['code']! as String),
];

/// Each nation's cities, biggest first.
final Map<int, List<String>> _cities = {
  for (final e
      in (jsonDecode(File('assets/data/country_cities.json').readAsStringSync())
              as Map<String, Object?>)
          .entries)
    int.parse(e.key): (e.value! as List).cast<String>(),
};

/// A nation's main ground: the biggest the venue generator gives it.
Venue _mainGround(Nation n) =>
    VenueGenerator.forHost(hostId: n.id, cities: _cities[n.id]).first;

StadiumSignature _sig(String code, String stadium, int capacity) =>
    StadiumSignature.of(
      stadium: stadium,
      nationCode: code,
      confederation: pitchNation(code).confederation,
      capacity: capacity,
    );

void main() {
  group('signatures', () {
    test('every nation has a signature, and their main grounds differ', () {
      final seen = <StadiumSignature>{};
      for (final n in _nations) {
        final g = _mainGround(n);
        final sig = StadiumSignature.of(
          stadium: g.stadium,
          nationCode: n.code,
          confederation: n.confederation,
          capacity: g.capacity,
        );
        // The ground the Pitch view builds carries it.
        final spec = StadiumSpec.from(
          (
            stadium: g.stadium,
            city: g.city,
            groundNationId: n.id,
            capacity: g.capacity,
            attendance: g.capacity ~/ 2,
            soldOut: false,
          ),
          n,
          _nations.firstWhere((o) => o.id != n.id),
          0.1,
          groundNationCode: n.code,
        );
        expect(spec.signature, sig, reason: n.code);
        seen.add(sig);
      }
      // Personal grounds: no one look for everybody.
      expect(seen.length, greaterThanOrEqualTo(30));
    });

    test('the big football nations get their curated mix on big grounds', () {
      for (final code in StadiumSignature.curatedNations) {
        if (StadiumSignature.gridironShare.containsKey(code)) continue;
        final a = _sig(code, 'Mock One', 60000);
        final b = _sig(code, 'Mock Two', 45000);
        expect(a, b, reason: code);
      }
      // ...and their small grounds are their own.
      expect(
        _sig('ENG', 'Mock Small', 9000).bowl,
        BowlShape.openCorners,
      );
    });

    test('signatures are deterministic per stadium', () {
      for (final n in _nations.take(40)) {
        expect(
          _sig(n.code, 'Mock Arena', 42000),
          _sig(n.code, 'Mock Arena', 42000),
        );
      }
      // Within one nation, different grounds look different.
      final mixes = {
        for (var i = 0; i < 60; i++) _sig('CZE', 'Mock Ground $i', 32000),
      };
      expect(mixes.length, greaterThan(10));
    });

    test('a ring roof always closes the bowl', () {
      for (final n in _nations) {
        for (var i = 0; i < 20; i++) {
          final s = _sig(n.code, 'Mock Ground $i', 30000 + i * 2500);
          if (s.roof == RoofStyle.ring) {
            expect(
              s.bowl,
              isNot(anyOf(BowlShape.openCorners, BowlShape.openEnd)),
              reason: '${n.code} $i',
            );
          }
        }
      }
    });

    test('USA grounds are sometimes a gridiron bowl and sometimes '
        'soccer-specific', () {
      final kinds = [
        for (var i = 0; i < 200; i++)
          _sig('USA', 'Mock Ground $i', 30000 + (i % 40) * 1000).kind,
      ];
      final bowls = kinds.where((k) => k == GroundKind.gridironBowl).length;
      final soccer = kinds.where((k) => k == GroundKind.soccerSpecific).length;
      expect(bowls + soccer, kinds.length);
      expect(bowls / kinds.length, inInclusiveRange(0.35, 0.65));
      expect(soccer, greaterThan(50));
      // Each ground is one or the other, always the same one.
      expect(
        _sig('USA', 'Mock Prairie Bowl', 70000).kind,
        GroundKind.gridironBowl,
      );
      expect(
        _sig('USA', 'Mock Harbor Field', 25000).kind,
        GroundKind.soccerSpecific,
      );
      // A bowl has the bowl's features; a soccer ground its open end.
      final bowl = _sig('USA', 'Mock Prairie Bowl', 70000);
      expect(bowl.bigScreen, isTrue);
      expect(bowl.bowl, BowlShape.oval);
      expect(_sig('USA', 'Mock Harbor Field', 25000).bowl, BowlShape.openEnd);
      // Small American grounds are never bowls.
      for (var i = 0; i < 40; i++) {
        expect(
          _sig('USA', 'Mock Small $i', 18000).kind,
          GroundKind.soccerSpecific,
        );
      }
      // Lighter in Canada and Mexico, and nowhere else.
      int bowlsIn(String code) => [
        for (var i = 0; i < 200; i++) _sig(code, 'Mock Ground $i', 50000),
      ].where((s) => s.kind == GroundKind.gridironBowl).length;
      expect(bowlsIn('CAN'), inExclusiveRange(10, bowls));
      expect(bowlsIn('MEX'), inExclusiveRange(5, bowlsIn('CAN')));
      for (final code in ['ENG', 'BRA', 'JPN', 'NGA']) {
        expect(bowlsIn(code), 0, reason: code);
      }
    });
  });

  group('crowd culture', () {
    test('follows the region table', () {
      CrowdCulture of(String code) =>
          CrowdCultures.of(code, pitchNation(code).confederation);
      for (final c in ['SRB', 'CRO', 'BIH', 'ALB', 'TUR', 'GRE']) {
        expect(of(c), CrowdCulture.flares, reason: c);
      }
      for (final c in ['ENG', 'SCO', 'WAL', 'IRL', 'NOR', 'SWE', 'DEN']) {
        expect(of(c), CrowdCulture.scarves, reason: c);
      }
      for (final c in ['FRA', 'GER', 'JPN', 'USA', 'AUS', 'CZE']) {
        expect(of(c), CrowdCulture.calm, reason: c);
      }
      for (final n in _nations) {
        final c = CrowdCultures.of(n.code, n.confederation);
        if (n.confederation == Confederation.southAmerica) {
          expect(c, CrowdCulture.flares, reason: n.code);
        }
        if (n.confederation == Confederation.africa) {
          expect(c, CrowdCulture.drums, reason: n.code);
        }
      }
    });

    test('finals open with a tifo; the shows fade on their own clocks', () {
      for (final c in CrowdCulture.values) {
        expect(CrowdShow.of(c, isFinal: true), CrowdShow.tifo);
      }
      expect(CrowdShow.scarves.opacityAt(0), 1);
      expect(CrowdShow.scarves.opacityAt(3), 0);
      expect(CrowdShow.tifo.opacityAt(1), 1);
      expect(CrowdShow.tifo.opacityAt(20), 0);
      expect(CrowdShow.flares.opacityAt(2), 1);
      expect(CrowdShow.flares.opacityAt(5), 0);
      expect(CrowdShow.drums.opacityAt(70), 1);
      expect(CrowdShow.none.opacityAt(0), 0);
      // The ground carries each side's own culture.
      final spec = _spec('ENG', 'NGA');
      expect(spec.homeCulture, CrowdCulture.scarves);
      expect(spec.awayCulture, CrowdCulture.drums);
    });
  });

  group('weather', () {
    Map<WeatherKind, int> count(String code, DateTime date) {
      final out = {for (final w in WeatherKind.values) w: 0};
      final c = pitchNation(code).confederation;
      for (var id = 1; id <= 400; id++) {
        final w = MatchWeather.of(
          code: code,
          confederation: c,
          date: date,
          fixtureId: id,
        );
        out[w] = out[w]! + 1;
      }
      return out;
    }

    test('follows climate and date', () {
      final engAutumn = count('ENG', DateTime(2026, 10, 10));
      expect(engAutumn[WeatherKind.rain], greaterThan(110));
      expect(engAutumn[WeatherKind.snow], 0);
      expect(engAutumn[WeatherKind.haze], 0);

      final norWinter = count('NOR', DateTime(2027, 1, 20));
      expect(norWinter[WeatherKind.snow], greaterThan(100));
      final norSummer = count('NOR', DateTime(2026, 6, 20));
      expect(norSummer[WeatherKind.snow], 0);

      final qatSummer = count('QAT', DateTime(2026, 7, 10));
      expect(qatSummer[WeatherKind.haze], greaterThan(240));
      expect(qatSummer[WeatherKind.rain], 0);
      expect(qatSummer[WeatherKind.snow], 0);
      final qatWinter = count('QAT', DateTime(2026, 1, 10));
      expect(
        qatWinter[WeatherKind.haze],
        lessThan(qatSummer[WeatherKind.haze]!),
      );

      // Never snow in the south or the tropics, whatever the month.
      for (final code in ['BRA', 'ARG', 'NGA', 'ESP', 'AUS']) {
        for (final m in [1, 7]) {
          expect(
            count(code, DateTime(2026, m, 12))[WeatherKind.snow],
            0,
            reason: '$code $m',
          );
        }
      }
      // Wetter in Britain than in Spain.
      expect(
        engAutumn[WeatherKind.rain],
        greaterThan(count('ESP', DateTime(2026, 10, 10))[WeatherKind.rain]!),
      );
    });

    test('is the same for the same match', () {
      for (var id = 1; id < 50; id++) {
        final a = MatchWeather.of(
          code: 'SCO',
          confederation: Confederation.europe,
          date: DateTime(2026, 11, 14),
          fixtureId: id,
        );
        final b = MatchWeather.of(
          code: 'SCO',
          confederation: Confederation.europe,
          date: DateTime(2026, 11, 14),
          fixtureId: id,
        );
        expect(a, b);
      }
    });
  });

  testWidgets('the falling weather is tiled at the device pixel ratio, '
      'once', (tester) async {
    const size = Size(390, 280);
    final w = WeatherOverlay(WeatherKind.rain, seed: 3);
    void frame(double t) {
      final recorder = ui.PictureRecorder();
      w.paint(Canvas(recorder), size, t, pixelRatio: 3);
      recorder.endRecording().dispose();
    }

    frame(0);
    final tile = w.debugTile!;
    expect(tile.width, 390 * 3);
    expect(tile.height, 280 * 3);
    frame(1.5);
    expect(identical(w.debugTile, tile), isTrue, reason: 'kept, not remade');
    w.dispose();
  });

  group('licensing', () {
    test('the Eiffel Tower is never floodlit at night, only a dark '
        'silhouette', () {
      const size = Size(390, 280);
      // Every screen-blended path the night backdrop draws: the up-light
      // wash over a landmark is one.
      int lit(LandmarkKind landmark) {
        final c = _SpyCanvas();
        BackdropPainter(
          horizon: Horizon.plains,
          city: CityStyle.oldEuropean,
          landmark: landmark,
          look: SceneLook.night,
          seed: 'FRA:test',
        ).paint(c, size, 84);
        return c.screenPaths;
      }

      // Another landmark is lit from below at night...
      expect(lit(LandmarkKind.colosseum), greaterThan(lit(LandmarkKind.none)));
      // ...the Eiffel Tower is not: no more light than no landmark at all.
      expect(lit(LandmarkKind.eiffel), lit(LandmarkKind.none));
    });

    test('no text, image or emblem is drawn in the stands, the tifos, the '
        'banners or the weather', () {
      const size = Size(390, 280);
      const projection = PitchProjection(size, (centreX: 52.5, zoom: 0.94));
      var specs = 0;
      for (final (home, away) in [
        ('ENG', 'SCO'),
        ('SRB', 'CRO'),
        ('NGA', 'GHA'),
        ('USA', 'MEX'),
        ('BRA', 'ARG'),
      ]) {
        // Every feature in clear weather, and every weather on one ground.
        for (final (sig, w) in [
          for (final sig in _allSignatures()) (sig, WeatherKind.clear),
          for (final w in WeatherKind.values) (StadiumSignature.classic, w),
        ]) {
          {
            final spec = _spec(home, away).withLook(signature: sig, weather: w);
            for (final dressing in [
              MatchDressing.none,
              MatchDressing.theFinal,
            ]) {
              for (final light in [PitchLight.day, PitchLight.night]) {
                final painter = StadiumPainter(
                  spec,
                  projection,
                  light: light,
                  dressing: dressing,
                );
                final ground = _SpyCanvas();
                painter.paint(ground, size);
                expect(ground.text, 0, reason: '$home $sig $w');
                // The only images on the ground are the nation's flags on
                // their poles (none here: no flag is passed).
                expect(ground.images, 0, reason: '$home $sig $w');
                final show = _SpyCanvas();
                painter.paintShow(show, size);
                expect(show.text, 0, reason: '$home show');
                expect(show.images, 0, reason: '$home show');
                specs++;
              }
            }
          }
        }
      }
      expect(specs, greaterThan(100));
      for (final w in WeatherKind.values) {
        final c = _SpyCanvas();
        WeatherOverlay(w).paintTile(c, size);
        expect(c.text + c.images, 0);
      }
      // The painters never so much as build text.
      for (final f in [
        'stadium_painter.dart',
        'stadium_features.dart',
        'crowd_painter.dart',
        'weather_painter.dart',
        'backdrop_painter.dart',
        'city_skyline.dart',
        'landmark_paths.dart',
      ]) {
        final src = File('lib/features/match/pitch/$f').readAsStringSync();
        for (final banned in [
          'TextPainter',
          'ParagraphBuilder',
          'TextSpan',
          'drawParagraph',
        ]) {
          expect(src.contains(banned), isFalse, reason: '$f uses $banned');
        }
      }
      // The Eiffel Tower is a plain silhouette: never lit up at night.
      expect(LandmarkPaths.hasWindows(LandmarkKind.eiffel), isFalse);
    });
  });
}

StadiumSpec _spec(String homeCode, String awayCode, {int capacity = 50000}) {
  final home = pitchNation(homeCode);
  final away = pitchNation(awayCode);
  return StadiumSpec.from(
    (
      stadium: 'Mock Ground',
      city: 'Mock City',
      groundNationId: home.id,
      capacity: capacity,
      attendance: capacity * 9 ~/ 10,
      soldOut: false,
    ),
    home,
    away,
    AwayFanShare.estimate(
      home: home,
      away: away,
      neutral: false,
      tournament: false,
      distanceKm: AwayFanShare.proxyDistanceKm(home, away),
    ),
    groundNationCode: home.code,
  );
}

/// One signature for each value of each feature, and the North American
/// kinds.
List<StadiumSignature> _allSignatures() => [
  StadiumSignature.classic,
  for (final r in RoofStyle.values) StadiumSignature(roof: r),
  for (final c in RoofCrown.values) StadiumSignature(crownFeature: c),
  for (final b in BowlShape.values) StadiumSignature(bowl: b),
  for (final s in SeatPattern.values) StadiumSignature(seats: s),
  const StadiumSignature(
    lights: FloodlightStyle.roofEdge,
    bigScreen: true,
    runningTrack: true,
  ),
  const StadiumSignature(
    kind: GroundKind.gridironBowl,
    roof: RoofStyle.open,
    lights: FloodlightStyle.roofEdge,
    bigScreen: true,
  ),
  const StadiumSignature(
    kind: GroundKind.soccerSpecific,
    bowl: BowlShape.openEnd,
  ),
];

/// A canvas that draws nothing and counts the text and the images asked of
/// it.
class _SpyCanvas implements Canvas {
  int text = 0;
  int images = 0;

  @override
  void drawParagraph(ui.Paragraph paragraph, Offset offset) => text++;

  @override
  void drawImage(ui.Image image, Offset offset, Paint paint) => images++;

  @override
  void drawImageRect(ui.Image image, Rect src, Rect dst, Paint paint) =>
      images++;

  @override
  void drawImageNine(ui.Image image, Rect center, Rect dst, Paint paint) =>
      images++;

  @override
  void drawAtlas(
    ui.Image atlas,
    List<RSTransform> transforms,
    List<Rect> rects,
    List<Color>? colors,
    BlendMode? blendMode,
    Rect? cullRect,
    Paint paint,
  ) => images++;

  @override
  void drawRawAtlas(
    ui.Image atlas,
    Float32List rstTransforms,
    Float32List rects,
    Int32List? colors,
    BlendMode? blendMode,
    Rect? cullRect,
    Paint paint,
  ) => images++;

  @override
  void drawPicture(ui.Picture picture) => images++;

  /// Paths drawn with a screen blend (light laid over what is there).
  int screenPaths = 0;

  @override
  void drawPath(Path path, Paint paint) {
    if (paint.blendMode == BlendMode.screen) screenPaths++;
  }

  @override
  int getSaveCount() => 1;

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}
