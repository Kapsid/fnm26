import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/match/pitch/pitch_geometry.dart';
import 'package:fnm/domain/services/match/stadium/ground_character.dart';
import 'package:fnm/domain/services/match/stadium/pitch_wear.dart';
import 'package:fnm/features/match/pitch/ground_live.dart';

import '../../helpers/pitch_view_fixture.dart';
import '../../helpers/stadium_shots.dart';

void main() {
  setUpAll(loadShotFonts);

  test('only the lesser grounds are worn, the old ones most', () {
    expect(PitchWear.of(GroundScale.big, seed: 1), isEmpty);
    expect(PitchWear.of(GroundScale.old, seed: 1, built: true), isEmpty);
    double total(GroundScale s) => [
      for (var seed = 0; seed < 50; seed++)
        for (final w in PitchWear.of(s, seed: seed)) w.strength,
    ].fold(0.0, (a, b) => a + b);
    expect(total(GroundScale.old), greaterThan(total(GroundScale.compact)));
    expect(PitchWear.lineWobble(GroundScale.big), 0);
    expect(PitchWear.lineWobble(GroundScale.old), lessThanOrEqualTo(0.1));
  });

  test('subtle, on the pitch, and the same at every match', () {
    for (var seed = 0; seed < 50; seed++) {
      final a = PitchWear.of(GroundScale.old, seed: seed);
      final b = PitchWear.of(GroundScale.old, seed: seed);
      expect(a.length, b.length);
      for (var i = 0; i < a.length; i++) {
        expect(a[i].x, b[i].x);
        expect(a[i].strength, lessThanOrEqualTo(0.45));
        expect(a[i].x, inInclusiveRange(0, PitchDims.length));
        expect(a[i].y, inInclusiveRange(0, PitchDims.width));
      }
      // Both goalmouths worn.
      expect(a.where((w) => w.x < 5), isNotEmpty);
      expect(a.where((w) => w.x > PitchDims.length - 5), isNotEmpty);
    }
  });

  testWidgets('a worn old ground paints', (tester) async {
    final m = pitchMatch(seed: 5);
    final stadium = pitchStadiumFor(m, capacity: 4000);
    final live = GroundLive(kits: stadium.kits);
    await stadiumShot(tester, 'pitch_wear_old_ground', stadium, live: live);
    live.dispose();
  });
}
