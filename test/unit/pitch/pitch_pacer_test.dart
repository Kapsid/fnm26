import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_moments.dart';
import 'package:fnm/domain/services/match/pitch/pitch_pacer.dart';

import '../../helpers/fixtures.dart';

MatchResult _result(
  List<MatchMoment> moments, {
  int stoppage = 3,
  bool extraTime = false,
}) => MatchResult(
  homeScore: 0,
  awayScore: 0,
  events: const [],
  homeShots: 0,
  awayShots: 0,
  homePossession: 50,
  stoppage: stoppage,
  extraTime: extraTime ? (homeScore: 0, awayScore: 0) : null,
  moments: moments,
);

List<MatchMoment> _shots(
  int n, {
  ShotOutcome outcome = ShotOutcome.saved,
  int from = 1,
}) => [
  for (var i = 0; i < n; i++)
    ShotMoment(
      minute: from + (i * 2) % 88,
      stoppage: 0,
      seq: i,
      teamNationId: 1,
      shooterId: 1,
      zone: PitchZone.boxCentre,
      xg: 0.1,
      outcome: outcome,
      origin: ShotOrigin.openPlay,
    ),
];

double _secs(PitchPacer p) => p.total.inMicroseconds / 1e6;

void main() {
  const bands = {
    PitchSpeed.slow: (180.0, 240.0),
    PitchSpeed.mid: (120.0, 180.0),
    PitchSpeed.fast: (60.0, 120.0),
  };
  // Stoppage 0 keeps the band exact (scale 1).
  test('a quiet 0-0 lands in each band\'s lower half', () {
    for (final e in bands.entries) {
      final t = _secs(PitchPacer(_result(_shots(4), stoppage: 0), e.key));
      final (lo, hi) = e.value;
      expect(t, inInclusiveRange(lo, (lo + hi) / 2), reason: '${e.key}');
    }
  });

  test('a 4-3 lands in the upper half', () {
    final goals = _shots(7, outcome: ShotOutcome.goal);
    final moments = [...goals, ..._shots(18, from: 2)];
    for (final e in bands.entries) {
      final t = _secs(PitchPacer(_result(moments, stoppage: 0), e.key));
      final (lo, hi) = e.value;
      expect(t, inInclusiveRange((lo + hi) / 2, hi * 1.15), reason: '${e.key}');
    }
  });

  test('screenAt and matchAt invert', () {
    final p = PitchPacer(
      _result(_shots(12, outcome: ShotOutcome.goal), extraTime: true),
      PitchSpeed.mid,
    );
    for (final (m, s) in [
      (1, 0),
      (45, 0),
      (90, 0),
      (90, 2),
      (91, 0),
      (120, 0),
    ]) {
      for (final w in [0.0, 0.25, 0.9]) {
        final back = p.matchAt(p.screenAt(m, s, within: w));
        expect((back.minute, back.stoppage), (m, s));
        expect(back.within, closeTo(w, 1e-4));
      }
    }
    expect(p.screenAt(1, 0), Duration.zero);
    final end = p.matchAt(p.total);
    expect((end.minute, end.within), (120, 1.0));
  });

  test('moments never shorter than their fixed length', () {
    final goal = _shots(1, outcome: ShotOutcome.goal).single;
    final p = PitchPacer(_result([goal], stoppage: 0), PitchSpeed.fast);
    expect(p.momentLength(goal), const Duration(milliseconds: 6000));
    final span = p.screenAt(goal.minute + 1, 0) - p.screenAt(goal.minute, 0);
    expect(span, greaterThanOrEqualTo(p.momentLength(goal)));
    // Fixed lengths hold at every speed.
    for (final sp in PitchSpeed.values) {
      expect(
        PitchPacer(_result([goal]), sp).momentLength(goal),
        const Duration(milliseconds: 6000),
      );
    }
    const corner = SetPieceMoment(
      minute: 5,
      stoppage: 0,
      seq: 0,
      teamNationId: 1,
      kind: SetPieceKind.corner,
      takerId: 1,
      left: true,
      zone: PitchZone.wideLeft,
    );
    const routine = SetPieceMoment(
      minute: 6,
      stoppage: 0,
      seq: 0,
      teamNationId: 1,
      kind: SetPieceKind.throwIn,
      takerId: 1,
      left: true,
      zone: PitchZone.wideLeft,
      routine: true,
    );
    final q = PitchPacer(_result([corner, routine]), PitchSpeed.slow);
    expect(q.momentLength(corner), const Duration(seconds: 6));
    expect(q.momentLength(routine), Duration.zero);
    expect(q.screenAt(6, 0) - q.screenAt(5, 0), const Duration(seconds: 6));
  });

  test('120-minute match scales and holds', () {
    final reg = PitchPacer(_result(_shots(4), stoppage: 0), PitchSpeed.mid);
    final et = PitchPacer(
      _result(_shots(4), stoppage: 0, extraTime: true),
      PitchSpeed.mid,
    );
    expect(_secs(et), closeTo(_secs(reg) * 120 / 90, 0.5));
    expect(et.screenAt(120, 0), lessThan(et.total));
    expect(et.matchAt(et.screenAt(100, 0, within: 0.5)).minute, 100);
  });

  test('overflow capped at 15%', () {
    // 17 goals, 102 s of moments, quiet time pinned at its minimum.
    final q = PitchPacer(
      _result(_shots(17, outcome: ShotOutcome.goal), stoppage: 0),
      PitchSpeed.fast,
    );
    expect(_secs(q), lessThanOrEqualTo(120 * 1.15));
    expect(_secs(q), greaterThan(120));
  });

  test('key moments have the same length at every speed', () {
    final goal = _shots(1, outcome: ShotOutcome.goal).single;
    final wood = _shots(1, outcome: ShotOutcome.woodwork).single;
    final wide = _shots(1, outcome: ShotOutcome.wide).single;
    final lens = [
      for (final sp in PitchSpeed.values)
        PitchPacer(_result([goal, wood, wide]), sp),
    ];
    for (final k in [goal, wood]) {
      expect(lens.map((p) => p.momentLength(k)).toSet().length, 1);
    }
    expect(lens[0].momentLength(wide), const Duration(milliseconds: 3500));
    expect(lens[1].momentLength(wide), const Duration(milliseconds: 1750));
    expect(lens[2].momentLength(wide), const Duration(milliseconds: 1050));
    for (final p in lens) {
      expect(
        p.momentLength(wide),
        greaterThanOrEqualTo(const Duration(seconds: 1)),
      );
    }
  });

  test('a set piece and its shot are one moment', () {
    const corner = SetPieceMoment(
      minute: 5,
      stoppage: 0,
      seq: 0,
      teamNationId: 1,
      kind: SetPieceKind.corner,
      takerId: 1,
      left: true,
      zone: PitchZone.wideLeft,
    );
    const shot = ShotMoment(
      minute: 5,
      stoppage: 0,
      seq: 1,
      teamNationId: 1,
      shooterId: 2,
      zone: PitchZone.sixYard,
      xg: 0.3,
      outcome: ShotOutcome.goal,
      origin: ShotOrigin.corner,
    );
    final p = PitchPacer(_result([corner, shot], stoppage: 0), PitchSpeed.fast);
    expect(p.momentLength(corner), const Duration(milliseconds: 10000));
    expect(p.momentLength(shot), Duration.zero);
    expect(p.screenAt(6, 0) - p.screenAt(5, 0), const Duration(seconds: 10));
  });

  test('real engine matches fit the bands', () {
    const engine = MatchEngine();
    final per90 = {for (final s in PitchSpeed.values) s: <double>[]};
    final raw = {for (final s in PitchSpeed.values) s: <double>[]};
    final inBand = {for (final s in PitchSpeed.values) s: 0};
    for (var seed = 0; seed < 200; seed++) {
      final r = engine.play(
        home: ratedTeam(1, 75),
        away: ratedTeam(2, 75),
        rng: SeededRng.forFixture(0x7ACE, seed),
        neutralVenue: true,
        bigMatch: true,
        extraTimeIfLevel: seed.isEven,
      );
      final scale = (90 + r.stoppage + (r.extraTime != null ? 30 : 0)) / 90;
      for (final s in PitchSpeed.values) {
        final t = _secs(PitchPacer(r, s));
        per90[s]!.add(t / scale);
        raw[s]!.add(t);
        final (lo, hi) = bands[s]!;
        if (t / scale <= hi * 1.15) inBand[s] = inBand[s]! + 1;
        expect(t / scale, greaterThanOrEqualTo(lo - 0.5), reason: '$s $seed');
      }
    }
    for (final s in PitchSpeed.values) {
      final v = per90[s]!..sort();
      final w = raw[s]!..sort();
      final (lo, hi) = bands[s]!;
      // ignore: avoid_print
      print(
        '$s raw min ${w.first.toStringAsFixed(1)} '
        'median ${w[w.length ~/ 2].toStringAsFixed(1)} '
        'max ${w.last.toStringAsFixed(1)} | per90 min ${v.first.toStringAsFixed(1)} '
        'median ${v[v.length ~/ 2].toStringAsFixed(1)} '
        'max ${v.last.toStringAsFixed(1)} | within ceiling+15%: ${inBand[s]}/200',
      );
      expect(inBand[s]!, greaterThanOrEqualTo(180), reason: '$s');
      expect(v[v.length ~/ 2], inInclusiveRange(lo, hi), reason: '$s median');
    }
  });
}
