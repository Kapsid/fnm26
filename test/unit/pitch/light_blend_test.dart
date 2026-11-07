import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/match/stadium/daylight.dart';
import 'package:fnm/domain/services/match/stadium/kick_off.dart';
import 'package:fnm/features/match/pitch/match_dressing.dart';
import 'package:fnm/features/match/pitch/scene_look.dart';
import 'package:fnm/features/match/pitch/stadium_looks.dart';

void main() {
  test('the cross-fade weights run day, dusk, night with no jump', () {
    double night(PitchLight l) {
      final (a, b, t) = SceneLook.weights(l);
      double n(SceneLook x) => identical(x, SceneLook.night)
          ? 1
          : identical(x, SceneLook.dusk)
          ? 0.5
          : 0;
      return n(a) + (n(b) - n(a)) * t;
    }

    var last = -1.0;
    for (var e = 40.0; e >= -20; e -= 0.25) {
      final v = night(PitchLight(e));
      expect(v, greaterThanOrEqualTo(last - 1e-9));
      expect((v - last).abs() < 0.03 || last < 0, isTrue, reason: 'at $e°');
      // The look's floodlights are the light's own.
      expect(
        SceneLook.at(PitchLight(e)).flood,
        closeTo(PitchLight(e).flood, 1e-9),
      );
      last = v;
    }
  });

  test('shadows turn and fade smoothly as the sun sets over a match', () {
    TokenShadows? prev;
    for (var m = 1; m <= 90; m++) {
      final s = TokenShadows.of(
        Daylight.at(50, DateTime(2026, 9), const KickOffTime(18, 30), m),
      );
      // Across half-time a quarter of an hour passes off screen: the light
      // may move on there, as it does in life.
      if (prev != null && m != 46) {
        expect((s.sunAlpha - prev.sunAlpha).abs(), lessThan(0.05));
        expect((s.towerAlpha - prev.towerAlpha).abs(), lessThan(0.05));
        expect((s.sunDirection - prev.sunDirection).distance, lessThan(0.05));
      }
      if (prev != null) {
        expect(s.towerAlpha, greaterThanOrEqualTo(prev.towerAlpha));
      }
      prev = s;
    }
  });

  test('finals tournaments are dressed, their final in gold', () {
    expect(
      MatchDressing.forFixture(CompetitionKind.friendly, 'FRIENDLY'),
      MatchDressing.none,
    );
    expect(
      MatchDressing.forFixture(CompetitionKind.worldCupFinals, 'GROUP').kind,
      DressingKind.tournament,
    );
    expect(
      MatchDressing.forFixture(CompetitionKind.worldCupFinals, 'SF').kind,
      DressingKind.tournament,
    );
    expect(
      MatchDressing.forFixture(CompetitionKind.continentalFinals, 'CFINAL'),
      MatchDressing.theFinal,
    );
    expect(
      MatchDressing.forFixture(CompetitionKind.worldCupFinals, 'FINAL'),
      MatchDressing.theFinal,
    );
    expect(
      MatchDressing.forFixture(CompetitionKind.worldCupQualifying, null),
      MatchDressing.none,
    );
  });
}
