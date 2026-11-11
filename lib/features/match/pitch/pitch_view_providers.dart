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
import 'package:fnm/domain/services/match/pitch/pitch_pacer.dart';
import 'package:fnm/domain/services/match/pitch/story_layer.dart';
import 'package:fnm/domain/services/match/stadium/away_fan_share.dart';
import 'package:fnm/domain/services/match/stadium/crowd_culture.dart';
import 'package:fnm/domain/services/match/stadium/daylight.dart';
import 'package:fnm/domain/services/match/stadium/ground_character.dart';
import 'package:fnm/domain/services/match/stadium/kick_off.dart';
import 'package:fnm/domain/services/match/stadium/match_weather.dart';
import 'package:fnm/domain/services/match/stadium/nation_latitudes.dart';
import 'package:fnm/domain/services/match/stadium/stadium_spec.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/match/pitch/match_dressing.dart';
import 'package:fnm/features/match/pitch/pitch_projection.dart';
import 'package:fnm/features/match/pitch/scene_look.dart';
import 'package:fnm/features/match/pitch/stadium_painter.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart' show pitchNameLabels;
import 'package:shared_preferences/shared_preferences.dart';

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
  /// minute. [weather] is drawn over it (cosmetic only), and
  /// [groundColours] (the ground nation's two colours) pattern its seats.
  /// [works] is what the manager's federation has done to the ground
  /// (cosmetic only; none for every other ground).
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
    WeatherKind weather = WeatherKind.clear,
    (Color, Color)? groundColours,
    GroundWorks works = GroundWorks.none,
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
        // The kits by their colours, not only the codes: a nation whose
        // colours were edited is another ground (another crowd, other
        // shirts), never the old images.
        (home.primaryColor, home.secondaryColor),
        (away.primaryColor, away.secondaryColor),
        awayShare,
        date,
        kickOff,
        code,
        confed,
        dressing,
        weather,
        groundColours,
        works,
      ),
      spec: StadiumSpec.from(
        ground,
        home,
        away,
        awayShare,
        groundNationCode: code,
        groundConfederation: confed,
        date: date,
        weather: weather,
        groundColours: groundColours,
        works: works,
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

  /// The weather drawn over the match: cosmetic only.
  WeatherKind get weather => spec.weather;

  /// What each side's fans put on in the stands: (home, away).
  (CrowdShow, CrowdShow) get shows => (
    CrowdShow.of(spec.homeCulture, isFinal: dressing.isFinal),
    CrowdShow.of(spec.awayCulture, isFinal: dressing.isFinal),
  );

  /// How strongly the fans' show image is drawn at match [minute]: the
  /// longer-lived of the two sides' shows.
  double showOpacityAt(int minute) {
    final (h, a) = shows;
    return math.max(h.opacityAt(minute), a.opacityAt(minute));
  }
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

  /// The fans' show for [stadium] in [light], or null when there is none
  /// (see `StadiumPainter.paintShow`).
  Future<ui.Image?> show(
    PitchStadium stadium,
    PitchProjection projection,
    Size size,
    PitchLight light, {
    double pixelRatio = 1,
  }) => StadiumPainter(
    stadium.spec,
    projection,
    light: light,
    dressing: stadium.dressing,
  ).bakeShow(size, pixelRatio: pixelRatio);

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

/// How the manager watches a live match: on the Pitch view or as the
/// Timeline of events.
enum MatchViewMode { pitch, timeline }

/// Prefs key for [MatchViewModeStore]: per device, outside the save
/// database, so no schema bump.
const String kMatchViewModePrefsKey = 'match_view_mode_v1';

/// Remembers how the manager last chose to watch a match, on this device.
/// Null until he has chosen once: the match screen then asks before
/// kick-off.
class MatchViewModeStore {
  const MatchViewModeStore();

  Future<MatchViewMode?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(kMatchViewModePrefsKey);
    for (final m in MatchViewMode.values) {
      if (m.name == saved) return m;
    }
    return null;
  }

  Future<void> save(MatchViewMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kMatchViewModePrefsKey, mode.name);
  }

  /// A new career is marked as it is made: its first match asks how to
  /// watch, once, whatever this device remembers. A save made before the
  /// mark existed is never marked, so it is never asked again.
  Future<void> markFirstMatchAsk(int careerId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(firstMatchAskKey(careerId), true);
  }

  /// Whether [careerId]'s first match still has to ask.
  Future<bool> firstMatchAskPending(int careerId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(firstMatchAskKey(careerId)) ?? false;
  }

  /// The question has been answered: the career is never asked again.
  Future<void> clearFirstMatchAsk(int careerId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(firstMatchAskKey(careerId));
  }

  /// Prefs key for [careerId]'s first-match question (per device, outside
  /// the save database: no schema bump).
  static String firstMatchAskKey(int careerId) =>
      'match_view_first_ask_v1_$careerId';
}

/// Whether [careerId]'s first match asks how to watch before kick-off (a
/// new career, not asked yet). False for every other match and every save
/// made before the question existed.
final FutureProviderFamily<bool, int> firstMatchViewAskProvider =
    FutureProvider.family<bool, int>(
      (ref, careerId) =>
          ref.read(matchViewModeStoreProvider).firstMatchAskPending(careerId),
    );

final Provider<MatchViewModeStore> matchViewModeStoreProvider =
    Provider<MatchViewModeStore>((ref) => const MatchViewModeStore());

/// The way the manager watches matches on this device: loaded from
/// [MatchViewModeStore], null while he has never chosen. [choose] sets it
/// and remembers it for the next match.
class MatchViewModeNotifier extends AsyncNotifier<MatchViewMode?> {
  @override
  Future<MatchViewMode?> build() => ref.read(matchViewModeStoreProvider).load();

  Future<void> choose(MatchViewMode mode) async {
    state = AsyncData(mode);
    await ref.read(matchViewModeStoreProvider).save(mode);
  }
}

final AsyncNotifierProvider<MatchViewModeNotifier, MatchViewMode?>
matchViewModeProvider =
    AsyncNotifierProvider<MatchViewModeNotifier, MatchViewMode?>(
      MatchViewModeNotifier.new,
    );

/// The Pitch view's pacing for the match screen's speed step [index]
/// (the 1, 2, 3 of its speed button): slow, then fast for both 2 and 3.
///
/// The owner's 2026-11-07 ask: 2x plays as 3x used to, and 3x a bit faster
/// again. Both use the fast pacing, whose staging is validated, and 3x is
/// quicker through its clock rate ([pitchRateForStep]) alone: a tighter
/// pacing band squeezes the staged picture (goal lines, restarts, offside
/// cuts) where a faster clock plays the same picture faster.
PitchSpeed pitchSpeedForStep(int index) =>
    const [PitchSpeed.slow, PitchSpeed.fast, PitchSpeed.fast][index.clamp(
      0,
      2,
    )];

/// The Pitch clock's playback rate for the speed step [index], on top of
/// the pacing [pitchSpeedForStep] picks: every staged second plays this
/// much faster. 1x runs 30% faster; 2x is the old 3x (fast pacing at 1.5);
/// 3x is that a quarter faster again (1.5 x 1.25).
/// The shootout keeps its own fixed 4 s a kick.
double pitchRateForStep(int index) =>
    const [1.3, 1.5, 1.5 * 1.25][index.clamp(0, 2)];

/// The competition a fixture's [round] code belongs to, as far as the
/// ground's dressing and its kick-off slots care.
CompetitionKind pitchCompetitionOf(String? round) => switch (round) {
  'FRIENDLY' => CompetitionKind.friendly,
  'FFINAL' => CompetitionKind.finalissima,
  'GROUP' ||
  'R32' ||
  'R16' ||
  'QF' ||
  'SF' ||
  '3RD' ||
  'FINAL' => CompetitionKind.worldCupFinals,
  'CGROUP' ||
  'CR16' ||
  'CQF' ||
  'CSF' ||
  'C3RD' ||
  'CFINAL' => CompetitionKind.continentalFinals,
  _ => CompetitionKind.worldCupQualifying,
};

/// The weather the Pitch view shows when a test pins it; null (always, in
/// the app) takes it from the ground's climate and the date
/// ([MatchWeather]). The weather is cosmetic only: no match reads it.
final Provider<WeatherKind?> pitchForcedWeatherProvider =
    Provider<WeatherKind?>((ref) => null);

/// When the match [preview] pins kicks off (local time at the ground) and
/// the weather it is played in: what the 2D TV draws, and what the venue
/// card writes, from the same inputs, so the two can never disagree.
///
/// Drawn from the save's seed and the fixture alone, never from a match
/// attempt's dice: the line is shown before kick-off, and a match played
/// again must not move its kick-off. [weather] pins the weather (tests).
/// Cosmetic only: no match reads either.
({KickOffTime kickOff, WeatherKind weather}) matchConditionsShown(
  MatchPreview preview, {
  WeatherKind? weather,
}) {
  final f = preview.fixture;
  final home = preview.nations[f.homeNationId];
  final groundNation = preview.nations[preview.ground.groundNationId] ?? home;
  final kickOff = KickOff.localTime(
    f,
    pitchCompetitionOf(f.round),
    preview.saveSeed,
  );
  return (
    kickOff: kickOff,
    weather:
        weather ??
        MatchWeather.of(
          code: groundNation?.code ?? '',
          confederation: groundNation?.confederation ?? Confederation.europe,
          date: f.date,
          fixtureId: f.id,
          kickOffHours: kickOff.hours,
        ),
  );
}

/// The ground of the match [preview] pins, for the Pitch view: its look,
/// both kits, the dressing of the occasion, the kick-off time and the
/// weather ([matchConditionsShown]; [weather] pins the weather). [works] is
/// what the manager's federation has done to the ground (see
/// `groundWorksProvider`).
PitchStadium pitchStadiumForPreview(
  MatchPreview preview, {
  WeatherKind? weather,
  GroundWorks works = GroundWorks.none,
}) {
  final f = preview.fixture;
  final shown = matchConditionsShown(preview, weather: weather);
  final home = preview.nations[f.homeNationId]!;
  final away = preview.nations[f.awayNationId]!;
  final groundNation = preview.nations[preview.ground.groundNationId];
  final competition = pitchCompetitionOf(f.round);
  final dressing = MatchDressing.forFixture(competition, f.round);
  return PitchStadium.forMatch(
    ground: preview.ground,
    home: home,
    away: away,
    awayShare: AwayFanShare.estimate(
      home: home,
      away: away,
      neutral: preview.neutralVenue,
      tournament: dressing.dressed,
      distanceKm: AwayFanShare.proxyDistanceKm(home, away),
    ),
    date: f.date,
    kickOff: shown.kickOff,
    groundNationCode: groundNation?.code ?? home.code,
    groundConfederation: groundNation?.confederation ?? home.confederation,
    dressing: dressing,
    weather: shown.weather,
    works: works,
    groundColours: groundNation == null
        ? null
        : (
            KitColors.parse(groundNation.primaryColor),
            KitColors.parse(groundNation.secondaryColor),
          ),
  );
}

/// Display names for every player [preview] can put on the pitch, both
/// squads and both benches: the surname, with an initial only where two
/// would read the same (as on the tactics pitch).
Map<int, String> pitchNamesForPreview(MatchPreview preview) => pitchNameLabels(
  {
    for (final p in [
      ...preview.homeTeam.xi,
      ...preview.awayTeam.xi,
      ...preview.bench,
      ...preview.opponentBench,
      for (final s in preview.opponentSubs) s.on,
    ])
      p.id: p,
  }.values,
);
