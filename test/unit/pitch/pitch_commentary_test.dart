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
const _names = {
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
}) => ShotMoment(
  minute: minute,
  stoppage: 0,
  seq: seq,
  teamNationId: 1,
  shooterId: _shooter,
  assistId: _assist,
  keeperId: _keeper,
  zone: origin == ShotOrigin.penalty
      ? PitchZone.boxCentre
      : PitchZone.edgeOfBox,
  xg: 0.2,
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
final _cards = [
  _card(MatchEventType.yellowCard),
  _card(MatchEventType.redCard, secondYellow: true),
  _card(MatchEventType.redCard),
];

/// Every kind of staged moment the Pitch view has a line for, by name.
Map<String, MatchMoment> _stagedKinds() => {
  for (final origin in ShotOrigin.values)
    for (final outcome in ShotOutcome.values) ...{
      'shot ${origin.name} ${outcome.name}': _shot(origin, outcome),
      if (origin == ShotOrigin.openPlay)
        'header ${outcome.name}': _shot(origin, outcome, header: true),
    },
  'corner': _setPiece(SetPieceKind.corner),
  'free kick': _setPiece(SetPieceKind.freeKick),
  'long throw': _setPiece(SetPieceKind.longThrow),
  'penalty awarded': _foul(PitchZone.boxCentre),
  'penalty awarded + yellow': _foul(PitchZone.boxLeft, card: 0),
  'penalty awarded + red': _foul(PitchZone.boxRight, card: 2),
  'foul + yellow': _foul(PitchZone.midfield, card: 0),
  'foul + second yellow': _foul(PitchZone.wideLeft, card: 1),
  'foul + red': _foul(PitchZone.midfield, card: 2),
  'offside': const OffsideMoment(
    minute: 30,
    stoppage: 0,
    seq: 0,
    teamNationId: 1,
    playerId: _shooter,
  ),
  'sub': const SubMoment(
    minute: 30,
    stoppage: 0,
    seq: 0,
    teamNationId: 1,
    onId: _shooter,
    offId: _assist,
    eventIndex: 0,
  ),
  'sub into an empty place': const SubMoment(
    minute: 30,
    stoppage: 0,
    seq: 0,
    teamNationId: 1,
    onId: _shooter,
    offId: null,
    eventIndex: 0,
  ),
};

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

void main() {
  test('every staged moment kind has ≥3 variants in en and cs', () {
    for (final loc in _locales.entries) {
      for (final kind in _stagedKinds().entries) {
        final lines = {
          for (var seed = 0; seed < 64; seed++)
            pitchLine(loc.value, kind.value, _names, seed, events: _cards),
        };
        expect(lines, isNot(contains(null)), reason: '${loc.key} ${kind.key}');
        expect(
          lines.length,
          greaterThanOrEqualTo(3),
          reason: '${loc.key} ${kind.key}: $lines',
        );
        for (final line in lines) {
          expect(line, isNot(contains('{')), reason: '${loc.key} $line');
        }
      }
      final injuries = {
        for (var seed = 0; seed < 64; seed++)
          pitchInjuryLine(
            loc.value,
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
      expect(injuries.length, greaterThanOrEqualTo(3), reason: loc.key);
      expect(injuries.every((s) => s.contains(_names[_shooter]!)), isTrue);
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

  test('lines name the players the moment names, from the names map', () {
    final l = AppLocalizationsEn();
    for (var seed = 0; seed < 16; seed++) {
      final line = pitchLine(
        l,
        _shot(ShotOrigin.openPlay, ShotOutcome.wide),
        _names,
        seed,
      )!;
      expect(line, contains(_names[_shooter]!));
    }
    // A saved shot with no keeper on the pitch never names one.
    final noKeeper = ShotMoment(
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
        pitchLine(l, noKeeper, _names, seed),
        isNot(contains(_names[_keeper]!)),
      );
    }
  });

  test('a goal line carries the score when given it', () {
    final l = AppLocalizationsEn();
    final goal = _shot(ShotOrigin.openPlay, ShotOutcome.goal);
    final plain = pitchLine(l, goal, _names, 5)!;
    expect(
      pitchLine(l, goal, _names, 5, score: (home: 2, away: 1)),
      '$plain 2–1',
    );
    final miss = _shot(ShotOrigin.openPlay, ShotOutcome.wide);
    expect(
      pitchLine(l, miss, _names, 5, score: (home: 2, away: 1)),
      pitchLine(l, miss, _names, 5),
    );
  });

  test('same seed same line', () {
    for (var i = 0; i < 6; i++) {
      final r = labMatch(i).result;
      final names = <int, String>{};
      for (final m in r.moments) {
        for (final id in switch (m) {
          ShotMoment s => [s.shooterId, ?s.assistId, ?s.keeperId],
          SetPieceMoment p => [p.takerId],
          FoulMoment f => [f.foulerId, f.fouledId],
          OffsideMoment o => [o.playerId],
          SubMoment s => [s.onId, ?s.offId],
        }) {
          names[id] = 'P$id';
        }
      }
      for (final l in _locales.values) {
        List<String?> lines(int seed) => [
          for (final m in r.moments)
            pitchLine(l, m, names, seed, events: r.events),
        ];
        expect(lines(41), lines(41));
        expect(lines(41), isNot(lines(42)));
      }
    }
    // The variant is picked from the seed, the moment's seq and its minute.
    final l = AppLocalizationsEn();
    final a = _shot(ShotOrigin.openPlay, ShotOutcome.wide, seq: 1, minute: 2);
    final b = _shot(ShotOrigin.openPlay, ShotOutcome.wide, seq: 2, minute: 1);
    expect(pitchLine(l, a, _names, 7), pitchLine(l, b, _names, 7));
    expect(pitchLine(l, a, _names, 7), l.pitchComShotWide2(_names[_shooter]!));
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
        expect(pitchLine(l, m, _names, seed), isNull, reason: '$m');
      }
    }

    // On real matches: a moment the pacer gives no screen time is routine,
    // save a shot folded into its set piece and a foul that gives a penalty.
    var staged = 0;
    for (var i = 0; i < 40; i++) {
      final r = labMatch(i).result;
      final pacer = PitchPacer(r, PitchSpeed.mid);
      for (final m in r.moments) {
        final line = pitchLine(l, m, const {}, i, events: r.events);
        final penaltyFoul =
            m is FoulMoment &&
            {
              PitchZone.boxCentre,
              PitchZone.boxLeft,
              PitchZone.boxRight,
              PitchZone.sixYard,
            }.contains(m.zone);
        final timed = pacer.momentLength(m) > Duration.zero;
        final expectLine = m is ShotMoment || penaltyFoul || timed;
        expect(line != null, expectLine, reason: '$m');
        if (line != null) staged++;
      }
    }
    expect(staged, greaterThan(400));
  });
}
