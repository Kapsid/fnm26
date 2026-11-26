import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/match/stadium/daylight.dart';
import 'package:fnm/domain/services/match/stadium/match_weather.dart';
import 'package:fnm/features/match/pitch/ground_live.dart';
import 'package:fnm/features/match/pitch/weather_painter.dart';

import '../../helpers/pitch_view_fixture.dart';
import '../../helpers/stadium_shots.dart';

void main() {
  setUpAll(loadShotFonts);

  testWidgets('drizzle, a frost by day and a dust storm paint', (
    tester,
  ) async {
    final m = pitchMatch(seed: 5);
    for (final (name, weather, light) in const [
      ('weather_drizzle', WeatherKind.drizzle, PitchLight.day),
      ('weather_frost_winter_sun', WeatherKind.frost, PitchLight.dusk),
      ('weather_dust_storm', WeatherKind.dustStorm, PitchLight.day),
    ]) {
      final base = pitchStadiumFor(m, capacity: 30000);
      final stadium = withSpec(base, base.spec.withLook(weather: weather));
      final live = GroundLive(kits: stadium.kits);
      final overlay = WeatherOverlay(weather, seed: 3);
      await stadiumShot(
        tester,
        name,
        stadium,
        live: live,
        light: light,
        extra: (canvas, size) => overlay.paint(canvas, size, 4, pixelRatio: 2),
      );
      live.dispose();
      overlay.dispose();
    }
  });
}
