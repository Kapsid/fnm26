import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/match/stadium/backdrop.dart';
import 'package:fnm/domain/services/match/stadium/city_geography.dart';
import 'package:fnm/domain/services/match/stadium/daylight.dart';
import 'package:fnm/domain/services/match/stadium/ground_setting.dart';
import 'package:fnm/features/match/pitch/ground_live.dart';

import '../../helpers/pitch_view_fixture.dart';
import '../../helpers/stadium_shots.dart';

GroundSetting _setting(
  String code,
  int capacity, {
  String stadium = 'Ground',
  Set<CityFeature> features = const {},
  int altitude = 0,
  bool built = false,
  Confederation conf = Confederation.europe,
}) => GroundSetting.of(
  stadium: stadium,
  nationCode: code,
  confederation: conf,
  capacity: capacity,
  features: features,
  altitude: altitude,
  built: built,
);

/// The share of 400 grounds in [code] seating [capacity] set as [want].
double _share(
  GroundSetting want,
  String code,
  int capacity, {
  Set<CityFeature> features = const {},
  int altitude = 0,
  Confederation conf = Confederation.europe,
}) {
  var n = 0;
  for (var i = 0; i < 400; i++) {
    final s = _setting(
      code,
      capacity,
      stadium: 'Ground $i',
      features: features,
      altitude: altitude,
      conf: conf,
    );
    if (s == want) n++;
  }
  return n / 400;
}

void main() {
  setUpAll(loadShotFonts);

  const coast = {CityFeature.coast};
  const mountains = {CityFeature.mountains};

  test('a small island nation plays at a one-stand ground', () {
    expect(CityGeography.isIsland('MLT'), isTrue);
    expect(CityGeography.isIsland('FRA'), isFalse);
    expect(
      _setting('MLT', 3000, features: coast),
      GroundSetting.smallIsland,
    );
    expect(
      _setting('LCA', 6000, features: coast),
      GroundSetting.smallIsland,
    );
    // A bigger island ground is no small island's.
    expect(
      _setting('MLT', 17000, features: coast),
      isNot(GroundSetting.smallIsland),
    );
  });

  test('altitude and the mountains cut grounds into hillsides', () {
    expect(
      _share(
        GroundSetting.hillside,
        'BOL',
        40000,
        altitude: 3640,
        conf: Confederation.southAmerica,
      ),
      inInclusiveRange(0.6, 0.8),
    );
    expect(
      _share(GroundSetting.hillside, 'SUI', 20000, features: mountains),
      inInclusiveRange(0.35, 0.55),
    );
    // Flat country, or mountains near a city of a country whose grounds
    // stand on the flat: never.
    expect(_share(GroundSetting.hillside, 'NED', 20000), 0);
    expect(
      _share(GroundSetting.hillside, 'FRA', 20000, features: mountains),
      0,
    );
  });

  test('a coast puts some grounds on the water, the north most', () {
    final nordic = _share(
      GroundSetting.seaside,
      'NOR',
      15000,
      features: coast,
    );
    final other = _share(
      GroundSetting.seaside,
      'ESP',
      15000,
      features: coast,
    );
    expect(nordic, inInclusiveRange(0.45, 0.65));
    expect(other, inInclusiveRange(0.12, 0.3));
    // Inland, or a giant bowl: never.
    expect(_share(GroundSetting.seaside, 'NOR', 15000), 0);
    expect(
      _share(GroundSetting.seaside, 'NOR', 60000, features: coast),
      0,
    );
  });

  test('a built ground stands on open ground; a ground keeps its setting', () {
    expect(
      _setting('BOL', 40000, altitude: 3640, built: true),
      GroundSetting.standard,
    );
    for (var i = 0; i < 30; i++) {
      expect(
        _setting('NOR', 15000, stadium: 'G$i', features: coast),
        _setting('NOR', 15000, stadium: 'G$i', features: coast),
      );
    }
    expect(
      GroundSetting.hillside.horizonFor(
        Horizon.plains,
        Confederation.southAmerica,
      ),
      Horizon.andes,
    );
    expect(
      GroundSetting.hillside.horizonFor(Horizon.plains, Confederation.europe),
      Horizon.alps,
    );
    expect(
      GroundSetting.seaside.horizonFor(
        Horizon.forestHills,
        Confederation.europe,
      ),
      Horizon.sea,
    );
    expect(
      GroundSetting.standard.horizonFor(Horizon.plains, Confederation.europe),
      Horizon.plains,
    );
  });

  testWidgets('each setting paints, by day and at night', (tester) async {
    final m = pitchMatch(seed: 5);
    for (final (name, capacity, setting, horizon) in const [
      ('ground_hillside', 30000, GroundSetting.hillside, Horizon.alps),
      ('ground_hillside_andes', 6000, GroundSetting.hillside, Horizon.andes),
      ('ground_seaside', 15000, GroundSetting.seaside, Horizon.sea),
      ('ground_seaside_big', 40000, GroundSetting.seaside, Horizon.sea),
      ('ground_small_island', 3000, GroundSetting.smallIsland, Horizon.sea),
    ]) {
      final base = pitchStadiumFor(m, capacity: capacity);
      final stadium = withSpec(
        base,
        base.spec.withLook(setting: setting, horizon: horizon),
      );
      final live = GroundLive(kits: stadium.kits)
        ..setBoard(shotBoard(), at: 0)
        ..tick(1);
      await stadiumShot(tester, name, stadium, live: live);
      await stadiumShot(
        tester,
        '${name}_night',
        stadium,
        live: live,
        light: PitchLight.night,
      );
      expect(live.anchors!.slices, isNotEmpty, reason: name);
      expect(live.anchors!.boards, isNotEmpty, reason: name);
      live.dispose();
    }
  });
}
