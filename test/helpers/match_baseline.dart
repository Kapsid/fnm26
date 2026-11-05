import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/services/match/match_engine.dart';

import 'fixtures.dart';

/// Shared by `tool/capture_match_baseline.dart` (which writes the baseline) and
/// `test/unit/match/match_baseline_test.dart` (which checks against it), so
/// both measure exactly the same way.

const baselinePairs = <(int, int)>[
  (70, 70),
  (78, 70),
  (85, 70),
  (85, 85),
  (70, 85),
];
const baselineMatches = 600;
const baselineSeed = 0xBA5E;
const goldenSeed = 0x601D;
const goldenMatches = 200;
const goldenPair = (78, 74);

double _r(double v) => (v * 1e6).round() / 1e6;

String figureKey((int, int) pair, bool neutral) =>
    '${pair.$1}-${pair.$2}/${neutral ? 'neutral' : 'home'}';

/// Per-match figures for one cell of the matrix.
Map<String, double?> measureCell((int, int) pair, {required bool neutral}) {
  const engine = MatchEngine();
  const n = baselineMatches;
  var goals = 0, hw = 0, d = 0, aw = 0, rout = 0, favWins = 0;
  var pen = 0, sp = 0, lt = 0, yel = 0, red = 0, inj = 0, shots = 0;
  var xg = 0.0, stop = 0;
  for (var i = 0; i < n; i++) {
    final r = engine.play(
      home: ratedTeam(1, pair.$1),
      away: ratedTeam(2, pair.$2),
      rng: SeededRng.forFixture(baselineSeed, i),
      neutralVenue: neutral,
    );
    goals += r.homeScore + r.awayScore;
    if (r.homeScore > r.awayScore) hw++;
    if (r.homeScore == r.awayScore) d++;
    if (r.homeScore < r.awayScore) aw++;
    if ((r.homeScore - r.awayScore).abs() >= 4) rout++;
    if (pair.$1 > pair.$2 && r.homeScore > r.awayScore) favWins++;
    if (pair.$1 < pair.$2 && r.awayScore > r.homeScore) favWins++;
    shots += r.homeShots + r.awayShots;
    xg += r.homeXg + r.awayXg;
    stop += r.stoppage;
    for (final e in r.events) {
      switch (e.type) {
        case MatchEventType.goal:
          if (e.penalty) pen++;
          if (e.setPiece) sp++;
          if (e.longThrow) lt++;
        case MatchEventType.yellowCard:
          yel++;
        case MatchEventType.redCard:
          red++;
        case MatchEventType.injury:
          inj++;
        case MatchEventType.substitution:
          break;
      }
    }
  }
  return {
    'goals': _r(goals / n),
    'homeWin': _r(hw / n),
    'draw': _r(d / n),
    'awayWin': _r(aw / n),
    'favouriteWin': pair.$1 == pair.$2 ? null : _r(favWins / n),
    'rout': _r(rout / n),
    'penaltyGoalShare': goals == 0 ? 0 : _r(pen / goals),
    'setPieceGoalShare': goals == 0 ? 0 : _r(sp / goals),
    'longThrowGoalShare': goals == 0 ? 0 : _r(lt / goals),
    'yellows': _r(yel / n),
    'reds': _r(red / n),
    'injuries': _r(inj / n),
    'shots': _r(shots / n),
    'xg': _r(xg / n),
    'stoppage': _r(stop / n),
  };
}

Map<String, Map<String, double?>> measureFigures() => {
  for (final pair in baselinePairs)
    for (final neutral in [true, false])
      figureKey(pair, neutral): measureCell(pair, neutral: neutral),
};

/// The exact outcome of golden match [i], as JSON-safe data.
Map<String, Object?> goldenMatch(int i) {
  final r = const MatchEngine().play(
    home: ratedTeam(1, goldenPair.$1),
    away: ratedTeam(2, goldenPair.$2),
    rng: SeededRng.forFixture(goldenSeed, i),
    neutralVenue: false,
  );
  return {
    'score': '${r.homeScore}-${r.awayScore}',
    'stoppage': r.stoppage,
    'possession': r.homePossession,
    'events': [
      for (final e in r.events)
        [
          e.minute,
          e.stoppage,
          e.type.name,
          e.teamNationId,
          e.playerId,
          e.assistPlayerId ?? '',
          e.penalty,
          e.setPiece,
          e.longThrow,
          e.secondYellow,
        ].join('|'),
    ],
    'homeShotsByMinute': r.homeShotsByMinute,
    'awayShotsByMinute': r.awayShotsByMinute,
    'homeXgByMinute': [for (final v in r.homeXgByMinute) _r(v)],
    'ratings': [
      for (final p in r.ratings) '${p.playerId}:${_r(p.rating)}',
    ],
  };
}

List<Map<String, Object?>> measureGolden() => [
  for (var i = 0; i < goldenMatches; i++) goldenMatch(i),
];
