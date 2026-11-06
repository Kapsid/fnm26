/// The Pitch view's wiring to the match screen.
library;

import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/theme/kit_colors.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/match/attendance.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/pitch/story_layer.dart';
import 'package:fnm/domain/services/match/stadium/daylight.dart';
import 'package:fnm/domain/services/match/stadium/kick_off.dart';
import 'package:fnm/domain/services/match/stadium/nation_latitudes.dart';
import 'package:fnm/domain/services/match/stadium/stadium_spec.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/match/pitch/match_dressing.dart';
import 'package:fnm/features/match/pitch/pitch_projection.dart';
import 'package:fnm/features/match/pitch/scene_look.dart';
import 'package:fnm/features/match/pitch/stadium_painter.dart';

/// Both sides' line-ups for the match [preview] pins, as the Pitch view
/// draws them: each starting XI in its formation's slot order with its
/// shirts, each bench, each side's instructions and slot switches, the plan
/// [result] (the preview's own result unless a re-simulated one is being
/// shown) says it fielded, and the live tactical [changes] the screen has
/// made (its own list, as it hands them to the engine).
///
/// The manager's bench is the preview's [MatchPreview.bench]; the
/// opponent's is its named bench plus anybody its planned substitutions
/// bring on.
MatchLineups matchLineupsFromPreview(
  MatchPreview preview, {
  MatchResult? result,
  List<TacticalChange> changes = const [],
}) {
  final homeIsPlayer = preview.playerNationId == preview.homeTeam.nationId;
  List<int> ids(Iterable<Player> ps) => [for (final p in ps) p.id];
  final opponentBench = ids(preview.opponentBench);
  for (final s in preview.opponentSubs) {
    if (!opponentBench.contains(s.on.id)) opponentBench.add(s.on.id);
  }
  final playerBench = ids(preview.bench);
  return matchLineupsOf(
    home: preview.homeTeam,
    away: preview.awayTeam,
    homeBench: homeIsPlayer ? playerBench : opponentBench,
    awayBench: homeIsPlayer ? opponentBench : playerBench,
    result: result ?? preview.result,
    changes: changes,
  );
}

/// Everything the Pitch view needs to know about the ground of one match:
/// its look ([spec], with the season of the match date), the two kits, how
/// it is dressed for the occasion, and where and when it is, for the light.
///
/// Build it once per match ([PitchStadium.forMatch]) and hand the same
/// object to the view for the whole match: the view bakes the ground once
/// for it.
class PitchStadium {
  const PitchStadium({
    required this.key,
    required this.spec,
    required this.kits,
    required this.latitude,
    required this.date,
    required this.kickOff,
    this.dressing = MatchDressing.none,
  });

  /// The ground of [ground] for [home] against [away] on [date], kicking
  /// off at [kickOff] local time. The date sets the season on the backdrop
  /// and, with the kick-off and the ground's latitude, the light of every
  /// minute.
  factory PitchStadium.forMatch({
    required MatchGround ground,
    required Nation home,
    required Nation away,
    required double awayShare,
    required DateTime date,
    required KickOffTime kickOff,
    String? groundNationCode,
    Confederation? groundConfederation,
    MatchDressing dressing = MatchDressing.none,
  }) {
    final code = groundNationCode ?? home.code;
    final confed = groundConfederation ?? home.confederation;
    return PitchStadium(
      key: (
        ground.stadium,
        ground.city,
        ground.groundNationId,
        ground.capacity,
        ground.attendance,
        home.code,
        away.code,
        awayShare,
        date,
        kickOff,
        code,
        confed,
        dressing,
      ),
      spec: StadiumSpec.from(
        ground,
        home,
        away,
        awayShare,
        groundNationCode: code,
        groundConfederation: confed,
        date: date,
      ),
      kits: KitClash.resolve(home, away),
      latitude: NationLatitudes.ofCode(code, confed),
      date: date,
      kickOff: kickOff,
      dressing: dressing,
    );
  }

  /// What the ground is built from. Two built from the same match are the
  /// same ground: the view keeps its images for a rebuilt one.
  final Object key;

  final StadiumSpec spec;
  final ({KitPair home, KitPair away}) kits;

  @override
  bool operator ==(Object other) => other is PitchStadium && other.key == key;

  @override
  int get hashCode => key.hashCode;
  final double latitude;
  final DateTime date;
  final KickOffTime kickOff;
  final MatchDressing dressing;

  /// The light at match minute [minute] (+[stoppage]); before kick-off,
  /// the first minute's.
  PitchLight lightAt(int minute, {int stoppage = 0}) => Daylight.at(
    latitude,
    date,
    kickOff,
    math.max(minute, 1),
    stoppage: stoppage,
  );
}

/// Bakes a ground's images for the Pitch view: its flag for the roof poles
/// and each of its three key looks.
///
/// A look is recorded on the UI thread (the crowd is most of it: up to
/// about 15,000 figures on a three-tier ground) and rasterised off it. The
/// view bakes one look at a time and lets frames through in between, the
/// look the kick-off needs first ([order]).
class PitchStadiumBaker {
  PitchStadiumBaker();

  /// How long the last [look] held the UI thread recording, in ms.
  double lastRecordMs = 0;

  Future<ui.Image?> flag(String code) => StadiumPainter.rasterFlag(code);

  Future<ui.Image> look(
    PitchStadium stadium,
    PitchProjection projection,
    Size size,
    PitchLight light, {
    ui.Image? flag,
    double pixelRatio = 1,
  }) {
    final sw = Stopwatch()..start();
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder)..scale(pixelRatio);
    StadiumPainter(
      stadium.spec,
      projection,
      flag: flag,
      light: light,
      dressing: stadium.dressing,
    ).paint(canvas, size);
    final picture = recorder.endRecording();
    lastRecordMs = sw.elapsedMicroseconds / 1000;
    return picture
        .toImage(
          (size.width * pixelRatio).ceil(),
          (size.height * pixelRatio).ceil(),
        )
        .whenComplete(picture.dispose);
  }

  /// The key looks in the order to bake them for a match that kicks off in
  /// [light]: the one it is nearest first, then the one it is fading
  /// toward, then the last.
  static List<LightMode> order(PitchLight light) {
    final (a, b, t) = SceneLook.weights(light);
    LightMode mode(SceneLook l) => identical(l, SceneLook.day)
        ? LightMode.day
        : identical(l, SceneLook.dusk)
        ? LightMode.dusk
        : LightMode.night;
    final first = t < 0.5 ? mode(a) : mode(b);
    final second = t < 0.5 ? mode(b) : mode(a);
    final out = <LightMode>[first];
    if (second != first) out.add(second);
    // Then the nearest of the rest: dusk sits between day and night.
    for (final m in [LightMode.dusk, LightMode.day, LightMode.night]) {
      if (!out.contains(m)) out.add(m);
    }
    return out;
  }
}

/// The baker the Pitch view uses; tests swap in one that counts.
final pitchStadiumBakerProvider = Provider<PitchStadiumBaker>(
  (ref) => PitchStadiumBaker(),
);
