import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/match/stadium/daylight.dart';
import 'package:fnm/domain/services/match/stadium/landmarks.dart';
import 'package:fnm/features/match/pitch/ground_live.dart';
import 'package:fnm/features/match/pitch/landmark_paths.dart';

import '../../helpers/pitch_view_fixture.dart';
import '../../helpers/stadium_shots.dart';

void main() {
  setUpAll(loadShotFonts);

  test('the step pyramid and the temple stupas stand for their countries', () {
    for (final code in ['MEX', 'GUA', 'HON']) {
      expect(
        Landmarks.forGround('Some Town', code),
        LandmarkKind.stepPyramid,
        reason: code,
      );
    }
    for (final code in ['CAM', 'THA', 'MYA', 'LAO']) {
      expect(
        Landmarks.forGround('Some Town', code),
        LandmarkKind.templeStupas,
        reason: code,
      );
    }
    // A city's own landmark comes first.
    expect(Landmarks.forGround('Ciudad de México', 'MEX'), LandmarkKind.angel);
    expect(Landmarks.forGround('Bangkok', 'THA'), LandmarkKind.watArun);
    expect(Landmarks.forGround('Yangon', 'MYA'), LandmarkKind.shwedagon);
    // Anywhere else, nothing new.
    expect(Landmarks.forGround('Some Town', 'FRA'), LandmarkKind.none);
  });

  test('the new silhouettes sit in the landmark box and are not lit', () {
    for (final k in [LandmarkKind.stepPyramid, LandmarkKind.templeStupas]) {
      final b = LandmarkPaths.of(k).getBounds();
      expect(b.isEmpty, isFalse);
      expect(b.left, greaterThanOrEqualTo(-1.001));
      expect(b.right, lessThanOrEqualTo(1.001));
      expect(b.top, greaterThanOrEqualTo(-1.001));
      expect(b.bottom, lessThanOrEqualTo(0.001));
      expect(LandmarkPaths.hasWindows(k), isFalse);
      expect(LandmarkPaths.isMountain(k), isFalse);
      expect(Landmarks.promoSafe(k), isTrue);
    }
    // Appended: the old kinds keep their places.
    expect(LandmarkKind.values.indexOf(LandmarkKind.victoriaMemorial), 80);
    expect(LandmarkKind.values.last, LandmarkKind.templeStupas);
  });

  testWidgets('each paints behind a ground', (tester) async {
    final m = pitchMatch(seed: 5);
    for (final (name, kind) in const [
      ('landmark_step_pyramid', LandmarkKind.stepPyramid),
      ('landmark_temple_stupas', LandmarkKind.templeStupas),
    ]) {
      final base = pitchStadiumFor(m, capacity: 30000);
      final stadium = withSpec(base, base.spec.withLook(landmark: kind));
      final live = GroundLive(kits: stadium.kits);
      await stadiumShot(tester, name, stadium, live: live);
      await stadiumShot(
        tester,
        '${name}_dusk',
        stadium,
        live: live,
        light: PitchLight.dusk,
      );
      live.dispose();
    }
  });
}
