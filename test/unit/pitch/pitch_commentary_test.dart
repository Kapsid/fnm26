import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_moments.dart';
import 'package:fnm/domain/services/match/pitch/pitch_pacer.dart';
import 'package:fnm/features/match/pitch/pitch_commentary.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/l10n/app_localizations_cs.dart';
import 'package:fnm/l10n/app_localizations_en.dart';

import '../../helpers/pitch_match_lab.dart';

const _shooter = 1;
const _keeper = 2;
const _assist = 3;

/// World-pack style names, diacritics and all: they go in as they are.
const Map<int, String> _names = {
  _shooter: 'Žofín Kovář',
  _keeper: 'Ödön Ballaré',
  _assist: 'Nuño Ãlvarez',
};

ShotMoment _shot(
  ShotOrigin origin,
  ShotOutcome outcome, {
  bool header = false,
  int seq = 0,
  int minute = 30,
  int stoppage = 0,
  double xg = 0.12,
}) => ShotMoment(
  minute: minute,
  stoppage: stoppage,
  seq: seq,
  teamNationId: 1,
  shooterId: _shooter,
  assistId: _assist,
  keeperId: _keeper,
  zone: origin == ShotOrigin.penalty
      ? PitchZone.boxCentre
      : PitchZone.edgeOfBox,
  // Below a big save's bar, so a save reads as an ordinary one; see the
  // big-save test.
  xg: xg,
  outcome: outcome,
  origin: origin,
  header: header,
);

FoulMoment _foul(PitchZone zone, {int? card, bool advantage = false}) =>
    FoulMoment(
      minute: 30,
      stoppage: 0,
      seq: 0,
      teamNationId: 1,
      foulerId: _shooter,
      fouledId: _assist,
      zone: zone,
      cardEventIndex: card,
      advantage: advantage,
    );

SetPieceMoment _setPiece(SetPieceKind kind, {bool routine = false}) =>
    SetPieceMoment(
      minute: 30,
      stoppage: 0,
      seq: 0,
      teamNationId: 1,
      kind: kind,
      takerId: _assist,
      left: true,
      zone: PitchZone.wideLeft,
      routine: routine,
    );

MatchEvent _card(MatchEventType type, {bool secondYellow = false}) =>
    MatchEvent(
      minute: 30,
      type: type,
      teamNationId: 2,
      playerId: _shooter,
      playerName: 'x',
      secondYellow: secondYellow,
    );

/// The events a foul's card points into: 0 yellow, 1 second yellow, 2 red.
final List<MatchEvent> _cards = [
  _card(MatchEventType.yellowCard),
  _card(MatchEventType.redCard, secondYellow: true),
  _card(MatchEventType.redCard),
];

typedef _Lines = List<String> Function(AppLocalizations l);

const _p = 'Žofín Kovář'; // _shooter: shooter, fouler, sub on, offside
const _k = 'Ödön Ballaré'; // _keeper
const _o = 'Nuño Ãlvarez'; // _assist: deliverer, man fouled, sub off, taker

/// A shot's expected wordings, written out key by key: (origin, outcome)
/// to its trio, for the open-play header as `header` and the rest by origin.
Map<String, _Lines> _shotLines() {
  final setPiece = <ShotOutcome, _Lines>{
    ShotOutcome.goal: (l) => [
      l.pitchComSetPieceGoal1(_p),
      l.pitchComSetPieceGoal2(_p, _o),
      l.pitchComSetPieceGoal3(_p),
    ],
    ShotOutcome.saved: (l) => [
      l.pitchComSetPieceSaved1(_p, _k),
      l.pitchComSetPieceSaved2(_p),
      l.pitchComSetPieceSaved3(_p, _k),
    ],
    ShotOutcome.wide: (l) => [
      l.pitchComSetPieceWide1(_p),
      l.pitchComSetPieceWide2(_p),
      l.pitchComSetPieceWide3(_p),
    ],
    ShotOutcome.blocked: (l) => [
      l.pitchComSetPieceBlocked1(_p),
      l.pitchComSetPieceBlocked2(_p),
      l.pitchComSetPieceBlocked3(_p),
    ],
    ShotOutcome.woodwork: (l) => [
      l.pitchComSetPieceWoodwork1(_p),
      l.pitchComSetPieceWoodwork2(_p),
      l.pitchComSetPieceWoodwork3(_p),
    ],
  };
  List<String> penaltySaved(AppLocalizations l) => [
    l.pitchComPenaltySaved1(_p, _k),
    l.pitchComPenaltySaved2(_p),
    l.pitchComPenaltySaved3(_p, _k),
  ];
  return {
    'openPlay goal': (l) => [
      l.pitchComShotGoal1(_p),
      l.pitchComShotGoal2(_p),
      l.pitchComShotGoal3(_p),
    ],
    'openPlay saved': (l) => [
      l.pitchComShotSaved1(_p, _k),
      l.pitchComShotSaved2(_p),
      l.pitchComShotSaved3(_p, _k),
    ],
    'openPlay wide': (l) => [
      l.pitchComShotWide1(_p),
      l.pitchComShotWide2(_p),
      l.pitchComShotWide3(_p),
    ],
    'openPlay blocked': (l) => [
      l.pitchComShotBlocked1(_p),
      l.pitchComShotBlocked2(_p),
      l.pitchComShotBlocked3(_p),
    ],
    'openPlay woodwork': (l) => [
      l.pitchComShotWoodwork1(_p),
      l.pitchComShotWoodwork2(_p),
      l.pitchComShotWoodwork3(_p),
    ],
    'header goal': (l) => [
      l.pitchComHeaderGoal1(_p),
      l.pitchComHeaderGoal2(_p),
      l.pitchComHeaderGoal3(_p),
    ],
    'header saved': (l) => [
      l.pitchComHeaderSaved1(_p, _k),
      l.pitchComHeaderSaved2(_p),
      l.pitchComHeaderSaved3(_p, _k),
    ],
    'header wide': (l) => [
      l.pitchComHeaderWide1(_p),
      l.pitchComHeaderWide2(_p),
      l.pitchComHeaderWide3(_p),
    ],
    'header blocked': (l) => [
      l.pitchComHeaderBlocked1(_p),
      l.pitchComHeaderBlocked2(_p),
      l.pitchComHeaderBlocked3(_p),
    ],
    'header woodwork': (l) => [
      l.pitchComHeaderWoodwork1(_p),
      l.pitchComHeaderWoodwork2(_p),
      l.pitchComHeaderWoodwork3(_p),
    ],
    for (final origin in [
      ShotOrigin.corner,
      ShotOrigin.freeKickCross,
      ShotOrigin.longThrow,
    ])
      for (final e in setPiece.entries) '${origin.name} ${e.key.name}': e.value,
    'directFreeKick goal': (l) => [
      l.pitchComDirectFreeKickGoal1(_p),
      l.pitchComDirectFreeKickGoal2(_p),
      l.pitchComDirectFreeKickGoal3(_p),
    ],
    'directFreeKick saved': (l) => [
      l.pitchComDirectFreeKickSaved1(_p, _k),
      l.pitchComDirectFreeKickSaved2(_p),
      l.pitchComDirectFreeKickSaved3(_p, _k),
    ],
    'directFreeKick wide': (l) => [
      l.pitchComDirectFreeKickWide1(_p),
      l.pitchComDirectFreeKickWide2(_p),
      l.pitchComDirectFreeKickWide3(_p),
    ],
    'directFreeKick blocked': (l) => [
      l.pitchComDirectFreeKickBlocked1(_p),
      l.pitchComDirectFreeKickBlocked2(_p),
      l.pitchComDirectFreeKickBlocked3(_p),
    ],
    'directFreeKick woodwork': (l) => [
      l.pitchComDirectFreeKickWoodwork1(_p),
      l.pitchComDirectFreeKickWoodwork2(_p),
      l.pitchComDirectFreeKickWoodwork3(_p),
    ],
    'penalty goal': (l) => [
      l.pitchComPenaltyGoal1(_p),
      l.pitchComPenaltyGoal2(_p),
      l.pitchComPenaltyGoal3(_p),
    ],
    'penalty saved': penaltySaved,
    // A blocked penalty can only have been stopped by the keeper.
    'penalty blocked': penaltySaved,
    'penalty wide': (l) => [
      l.pitchComPenaltyMissed1(_p),
      l.pitchComPenaltyMissed2(_p),
      l.pitchComPenaltyMissed3(_p),
    ],
    'penalty woodwork': (l) => [
      l.pitchComPenaltyWoodwork1(_p),
      l.pitchComPenaltyWoodwork2(_p),
      l.pitchComPenaltyWoodwork3(_p),
    ],
  };
}

/// Every kind of staged moment the Pitch view has a line for, with the
/// exact trio of wordings it must use.
Map<String, (MatchMoment, _Lines)> _stagedKinds() {
  final shots = _shotLines();
  return {
    for (final origin in ShotOrigin.values)
      for (final outcome in ShotOutcome.values) ...{
        'shot ${origin.name} ${outcome.name}': (
          _shot(origin, outcome),
          shots['${origin.name} ${outcome.name}']!,
        ),
        if (origin == ShotOrigin.openPlay)
          'header ${outcome.name}': (
            _shot(origin, outcome, header: true),
            shots['header ${outcome.name}']!,
          ),
      },
    'corner': (
      _setPiece(SetPieceKind.corner),
      (l) => [
        l.pitchComCorner1(_o),
        l.pitchComCorner2(_o),
        l.pitchComCorner3(_o),
      ],
    ),
    'free kick': (
      _setPiece(SetPieceKind.freeKick),
      (l) => [
        l.pitchComFreeKick1(_o),
        l.pitchComFreeKick2(_o),
        l.pitchComFreeKick3(_o),
      ],
    ),
    'long throw': (
      _setPiece(SetPieceKind.longThrow),
      (l) => [
        l.pitchComLongThrow1(_o),
        l.pitchComLongThrow2(_o),
        l.pitchComLongThrow3(_o),
      ],
    ),
    // A penalty foul names the man fouled first, then the fouler.
    'penalty awarded': (
      _foul(PitchZone.boxCentre),
      (l) => [
        l.pitchComPenaltyAwarded1(_o),
        l.pitchComPenaltyAwarded2(_o, _p),
        l.pitchComPenaltyAwarded3(_o, _p),
      ],
    ),
    'penalty awarded + yellow': (
      _foul(PitchZone.boxLeft, card: 0),
      (l) => [
        l.pitchComPenaltyAwardedYellow1(_o, _p),
        l.pitchComPenaltyAwardedYellow2(_o, _p),
        l.pitchComPenaltyAwardedYellow3(_o, _p),
      ],
    ),
    'penalty awarded + second yellow': (
      _foul(PitchZone.sixYard, card: 1),
      (l) => [
        l.pitchComPenaltyAwardedSecondYellow1(_o, _p),
        l.pitchComPenaltyAwardedSecondYellow2(_o, _p),
        l.pitchComPenaltyAwardedSecondYellow3(_o, _p),
      ],
    ),
    'penalty awarded + red': (
      _foul(PitchZone.boxRight, card: 2),
      (l) => [
        l.pitchComPenaltyAwardedRed1(_o, _p),
        l.pitchComPenaltyAwardedRed2(_o, _p),
        l.pitchComPenaltyAwardedRed3(_o, _p),
      ],
    ),
    // A carded foul names the carded man first, then the man fouled.
    'foul + yellow': (
      _foul(PitchZone.midfield, card: 0),
      (l) => [
        l.pitchComFoulYellow1(_p),
        l.pitchComFoulYellow2(_p, _o),
        l.pitchComFoulYellow3(_p, _o),
      ],
    ),
    'foul + second yellow': (
      _foul(PitchZone.wideLeft, card: 1),
      (l) => [
        l.pitchComFoulSecondYellow1(_p),
        l.pitchComFoulSecondYellow2(_p),
        l.pitchComFoulSecondYellow3(_p),
      ],
    ),
    'foul + red': (
      _foul(PitchZone.midfield, card: 2),
      (l) => [
        l.pitchComFoulRed1(_p),
        l.pitchComFoulRed2(_p, _o),
        l.pitchComFoulRed3(_p),
      ],
    ),
    'offside': (
      const OffsideMoment(
        minute: 30,
        stoppage: 0,
        seq: 0,
        teamNationId: 1,
        playerId: _shooter,
      ),
      (l) => [
        l.pitchComOffside1(_p),
        l.pitchComOffside2(_p),
        l.pitchComOffside3(_p),
      ],
    ),
    'sub': (
      const SubMoment(
        minute: 30,
        stoppage: 0,
        seq: 0,
        teamNationId: 1,
        onId: _shooter,
        offId: _assist,
        eventIndex: 0,
      ),
      (l) => [
        l.pitchComSub1(_p, _o),
        l.pitchComSub2(_p, _o),
        l.pitchComSub3(_p, _o),
      ],
    ),
    'sub into an empty place': (
      const SubMoment(
        minute: 30,
        stoppage: 0,
        seq: 0,
        teamNationId: 1,
        onId: _shooter,
        offId: null,
        eventIndex: 0,
      ),
      (l) => [
        l.pitchComSubFill1(_p),
        l.pitchComSubFill2(_p),
        l.pitchComSubFill3(_p),
      ],
    ),
  };
}

final _locales = <String, AppLocalizations>{
  'en': AppLocalizationsEn(),
  'cs': AppLocalizationsCs(),
};

Map<String, String> _pitchCopy(String locale) {
  final arb =
      jsonDecode(File('lib/l10n/app_$locale.arb').readAsStringSync())
          as Map<String, Object?>;
  return {
    for (final e in arb.entries)
      if (e.key.startsWith('pitchCom') && e.value is String)
        e.key: e.value! as String,
  };
}

/// A name for every player a lab match's moments and events name.
Map<int, String> _labNames(MatchResult r) => {
  for (final m in r.moments)
    for (final id in switch (m) {
      final ShotMoment s => [s.shooterId, ?s.assistId, ?s.keeperId],
      final SetPieceMoment p => [p.takerId],
      final FoulMoment f => [f.foulerId, f.fouledId],
      final OffsideMoment o => [o.playerId],
      final SubMoment s => [s.onId, ?s.offId],
    })
      id: 'P$id',
  for (final e in r.events) e.playerId: 'P${e.playerId}',
};

void main() {
  test('every staged moment kind has ≥3 variants in en and cs', () {
    expect(_shotLines(), hasLength(ShotOrigin.values.length * 5 + 5));
    for (final loc in _locales.entries) {
      final l = loc.value;
      for (final kind in _stagedKinds().entries) {
        final (moment, expected) = kind.value;
        final lines = {
          for (var seed = 0; seed < 64; seed++)
            pitchLine(l, moment, _names, seed, events: _cards),
        };
        final want = expected(l).toSet();
        expect(want, hasLength(3), reason: '${loc.key} ${kind.key}');
        expect(lines, want, reason: '${loc.key} ${kind.key}');
      }
      final injuries = {
        for (var seed = 0; seed < 64; seed++)
          pitchInjuryLine(
            l,
            const MatchEvent(
              minute: 30,
              type: MatchEventType.injury,
              teamNationId: 1,
              playerId: _shooter,
              playerName: 'x',
            ),
            _names,
            seed,
          ),
      };
      expect(injuries, {
        l.pitchComInjury1(_p),
        l.pitchComInjury2(_p),
        l.pitchComInjury3(_p),
      }, reason: loc.key);
    }
  });

  test('every Czech pitch line is written, not left to the English', () {
    final en = _pitchCopy('en');
    final cs = _pitchCopy('cs');
    expect(cs.keys.toSet(), en.keys.toSet());
    for (final k in en.keys) {
      if (k == 'pitchComGoalScore') continue;
      expect(cs[k], isNot(en[k]), reason: k);
    }
  });

  test('a good chance kept out is a big save, with lines of its own', () {
    for (final loc in _locales.entries) {
      final l = loc.value;
      for (final origin in [
        ShotOrigin.openPlay,
        ShotOrigin.corner,
        ShotOrigin.freeKickCross,
        ShotOrigin.longThrow,
      ]) {
        final big = _shot(origin, ShotOutcome.saved, xg: 0.2);
        expect(big.isBigSave, isTrue);
        final lines = {
          for (var seed = 0; seed < 64; seed++)
            pitchLine(l, big, _names, seed, events: _cards),
        };
        expect(lines, {
          l.pitchComBigSave1(_k, _p),
          l.pitchComBigSave2(_k),
          l.pitchComBigSave3(_k, _p),
        }, reason: '${loc.key} $origin');
      }
      // A penalty or a direct free kick saved keeps its own lines.
      final pen = _shot(ShotOrigin.penalty, ShotOutcome.saved, xg: 0.8);
      expect(
        pitchLine(l, pen, _names, 0, events: _cards),
        isNot(l.pitchComBigSave2(_k)),
      );
    }
  });

  test('lines name the players the moment names, from the names map', () {
    final l = AppLocalizationsEn();
    final wide = _shot(ShotOrigin.openPlay, ShotOutcome.wide);
    final saved = _shot(ShotOrigin.openPlay, ShotOutcome.saved);
    final keeperNamed = <bool>{};
    for (var seed = 0; seed < 16; seed++) {
      expect(pitchLine(l, wide, _names, seed, events: const []), contains(_p));
      final s = pitchLine(l, saved, _names, seed, events: const [])!;
      expect(s, contains(_p));
      keeperNamed.add(s.contains(_k));
    }
    // The keeper comes from the map, on the seeds whose wording names him.
    expect(keeperNamed, {true, false});
    // Both men of a sub come from the map.
    for (var seed = 0; seed < 16; seed++) {
      final line = pitchLine(
        l,
        const SubMoment(
          minute: 60,
          stoppage: 0,
          seq: 0,
          teamNationId: 1,
          onId: _shooter,
          offId: _assist,
          eventIndex: 0,
        ),
        _names,
        seed,
        events: const [],
      )!;
      expect(line, allOf(contains(_p), contains(_o)));
    }
    // A saved shot with no keeper on the pitch never names one.
    const noKeeper = ShotMoment(
      minute: 30,
      stoppage: 0,
      seq: 0,
      teamNationId: 1,
      shooterId: _shooter,
      zone: PitchZone.boxCentre,
      xg: 0.2,
      outcome: ShotOutcome.saved,
      origin: ShotOrigin.openPlay,
    );
    for (var seed = 0; seed < 16; seed++) {
      expect(
        pitchLine(l, noKeeper, _names, seed, events: const []),
        isNot(contains(_k)),
      );
    }
  });

  test('a player missing from the names map trips an assert', () {
    final l = AppLocalizationsEn();
    expect(
      () => pitchLine(
        l,
        _shot(ShotOrigin.openPlay, ShotOutcome.wide),
        const {_keeper: _k},
        0,
        events: const [],
      ),
      throwsA(isA<AssertionError>()),
    );
  });

  test('a goal line carries the score when given it', () {
    final l = AppLocalizationsEn();
    final goal = _shot(ShotOrigin.openPlay, ShotOutcome.goal);
    final plain = pitchLine(l, goal, _names, 5, events: const [])!;
    expect(
      pitchLine(
        l,
        goal,
        _names,
        5,
        events: const [],
        score: (home: 2, away: 1),
      ),
      '$plain 2–1',
    );
    final miss = _shot(ShotOrigin.openPlay, ShotOutcome.wide);
    expect(
      pitchLine(
        l,
        miss,
        _names,
        5,
        events: const [],
        score: (home: 2, away: 1),
      ),
      pitchLine(l, miss, _names, 5, events: const []),
    );
  });

  test('same seed same line', () {
    for (var i = 0; i < 6; i++) {
      final r = labMatch(i).result;
      final names = _labNames(r);
      for (final l in _locales.values) {
        List<String?> lines(int seed) => [
          for (final m in r.moments)
            pitchLine(l, m, names, seed, events: r.events),
        ];
        expect(lines(41), lines(41));
        expect(lines(41), isNot(lines(42)));
      }
    }
    // The variant is (seed ^ seq ^ minute ^ stoppage) % n.
    final l = AppLocalizationsEn();
    String line(int seq, int minute, int stoppage) => pitchLine(
      l,
      _shot(
        ShotOrigin.openPlay,
        ShotOutcome.wide,
        seq: seq,
        minute: minute,
        stoppage: stoppage,
      ),
      _names,
      7,
      events: const [],
    )!;
    // 7 ^ 1 ^ 2 = 4, and 4 % 3 = 1: the second wording.
    expect(line(1, 2, 0), l.pitchComShotWide2(_p));
    expect(line(2, 1, 0), l.pitchComShotWide2(_p));
    // Added time: the same seq at 90+0 and 90+2 reads differently.
    // 7 ^ 1 ^ 90 = 92 (% 3 = 2); 92 ^ 2 = 94 (% 3 = 1).
    expect(line(1, 90, 0), l.pitchComShotWide3(_p));
    expect(line(1, 90, 2), l.pitchComShotWide2(_p));
  });

  test('no em dashes', () {
    for (final loc in _locales.keys) {
      for (final e in _pitchCopy(loc).entries) {
        expect(e.value, isNot(contains('—')), reason: '$loc ${e.key}');
      }
    }
  });

  test('no "World Cup"', () {
    for (final loc in _locales.keys) {
      for (final e in _pitchCopy(loc).entries) {
        expect(
          e.value.toLowerCase(),
          isNot(contains('world cup')),
          reason: '$loc ${e.key}',
        );
      }
    }
  });

  test('routine moments return null', () {
    final l = AppLocalizationsEn();
    final routine = <MatchMoment>[
      _setPiece(SetPieceKind.freeKick, routine: true),
      _setPiece(SetPieceKind.throwIn),
      _setPiece(SetPieceKind.goalKick),
      _foul(PitchZone.midfield),
      _foul(PitchZone.longRange),
      _foul(PitchZone.edgeOfBox),
      _foul(PitchZone.midfield, advantage: true),
      const OffsideMoment(
        minute: 30,
        stoppage: 0,
        seq: 0,
        teamNationId: 1,
        playerId: _shooter,
        endsAttack: false,
      ),
    ];
    for (final m in routine) {
      for (var seed = 0; seed < 8; seed++) {
        expect(
          pitchLine(l, m, _names, seed, events: _cards),
          isNull,
          reason: '$m',
        );
      }
    }

    // On real matches: a moment the pacer gives no screen time is routine,
    // save a shot folded into its set piece, a foul that gives a penalty,
    // and (since Task 15c) a corner, free kick or long throw that comes to
    // nothing: it has a line, but no window, so it is never said.
    var staged = 0;
    for (var i = 0; i < 40; i++) {
      final r = labMatch(i).result;
      final pacer = PitchPacer(r, PitchSpeed.mid);
      final names = _labNames(r);
      for (final m in r.moments) {
        final line = pitchLine(l, m, names, i, events: r.events);
        final penaltyFoul =
            m is FoulMoment &&
            {
              PitchZone.boxCentre,
              PitchZone.boxLeft,
              PitchZone.boxRight,
              PitchZone.sixYard,
            }.contains(m.zone);
        final timed = pacer.momentLength(m) > Duration.zero;
        final idleSetPiece = m is SetPieceMoment && !isRoutineMoment(m);
        final expectLine =
            m is ShotMoment || penaltyFoul || timed || idleSetPiece;
        expect(line != null, expectLine, reason: '$m');
        if (line != null) staged++;
      }
    }
    expect(staged, greaterThan(400));
  });
}
