import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/tactics/set_piece_picks.dart';

import '../../helpers/fixtures.dart';

MatchTeam _team(
  int nationId, {
  ThrowInStyle style = ThrowInStyle.neutral,
  int? taker,
  bool explicit = false,
}) {
  final positions = Formation.f442.positions;
  final xi = [
    for (var i = 0; i < 11; i++)
      player(id: nationId * 100 + i, nationId: nationId, position: positions[i]),
  ];
  return explicit
      ? MatchTeam(
          nationId: nationId,
          formation: Formation.f442,
          instructions: const TacticalInstructions(),
          xi: xi,
          throwInStyle: style,
          throwInTakerId: taker,
        )
      : MatchTeam(
          nationId: nationId,
          formation: Formation.f442,
          instructions: const TacticalInstructions(),
          xi: xi,
        );
}

/// A comparable fingerprint of everything a match produces.
String _print(MatchResult r) => [
  r.homeScore,
  r.awayScore,
  r.homeShots,
  r.awayShots,
  r.homeXg,
  r.awayXg,
  r.homePossession,
  for (final e in r.events)
    [
      e.minute,
      e.stoppage,
      e.type.name,
      e.playerId,
      e.assistPlayerId,
      e.setPiece,
      e.longThrow,
    ].join(':'),
].join('|');

typedef _Tally = ({
  int goalsFor,
  int goalsAgainst,
  int shotsFor,
  int shotsAgainst,
  int longThrowGoals,
});

/// The styled side against an identical neutral side, each seed both ways
/// round on a neutral venue.
_Tally _play(ThrowInStyle style, {int seeds = 2000}) {
  const engine = MatchEngine();
  var gf = 0;
  var ga = 0;
  var sf = 0;
  var sa = 0;
  var lt = 0;
  for (var i = 0; i < seeds; i++) {
    for (final atHome in const [true, false]) {
      final a = _team(1, style: style, explicit: true);
      final b = _team(2);
      final r = engine.play(
        home: atHome ? a : b,
        away: atHome ? b : a,
        rng: SeededRng.forFixture(0x7412, i),
        neutralVenue: true,
      );
      gf += atHome ? r.homeScore : r.awayScore;
      ga += atHome ? r.awayScore : r.homeScore;
      sf += atHome ? r.homeShots : r.awayShots;
      sa += atHome ? r.awayShots : r.homeShots;
      lt += r.events.where((e) => e.longThrow).length;
    }
  }
  return (
    goalsFor: gf,
    goalsAgainst: ga,
    shotsFor: sf,
    shotsAgainst: sa,
    longThrowGoals: lt,
  );
}

void main() {
  test('neutral (named or defaulted, with or without a thrower) is the '
      'engine byte for byte', () {
    const engine = MatchEngine();
    for (var i = 0; i < 300; i++) {
      final base = engine.play(
        home: _team(1),
        away: _team(2),
        rng: SeededRng.forFixture(0xA11, i),
      );
      final named = engine.play(
        home: _team(1, explicit: true, taker: 105),
        away: _team(2, explicit: true),
        rng: SeededRng.forFixture(0xA11, i),
      );
      expect(_print(named), _print(base), reason: 'seed $i');
    }
    expect(
      MatchEngine.throwInLift(
        own: ThrowInStyle.neutral,
        opponent: ThrowInStyle.neutral,
      ),
      1.0,
    );
    expect(MatchEngine.throwInOpenness(ThrowInStyle.neutral), 1.0);
  });

  test('long throws add a little, and cost a little', () {
    final neutral = _play(ThrowInStyle.neutral);
    final long = _play(ThrowInStyle.long);
    const games = 4000;
    final extraFor = (long.goalsFor - neutral.goalsFor) / games;
    final extraAgainst = (long.goalsAgainst - neutral.goalsAgainst) / games;
    // The measured effect, for the calibration note on the engine constants.
    // ignore: avoid_print
    print(
      'long: +${extraFor.toStringAsFixed(3)} for, '
      '+${extraAgainst.toStringAsFixed(3)} against a game; '
      '${long.longThrowGoals} long-throw goals in $games',
    );
    expect(neutral.longThrowGoals, 0);
    expect(long.longThrowGoals, greaterThan(0));
    expect(extraFor, greaterThan(0));
    // A few tenths of a goal per ten matches, at most.
    expect(extraFor, lessThan(0.04));
    expect(long.shotsAgainst, greaterThan(neutral.shotsAgainst));
    expect(extraAgainst, lessThan(0.03));
    expect(extraFor - extraAgainst, greaterThan(0));
  });

  test('safe throws: fewer chances both ways, a little', () {
    final neutral = _play(ThrowInStyle.neutral);
    final safe = _play(ThrowInStyle.defensive);
    const games = 4000;
    final lessFor = (neutral.shotsFor - safe.shotsFor) / games;
    final lessAgainst = (neutral.shotsAgainst - safe.shotsAgainst) / games;
    // The measured effect, for the calibration note on the engine constants.
    // ignore: avoid_print
    print(
      'safe: -${lessFor.toStringAsFixed(3)} shots for, '
      '-${lessAgainst.toStringAsFixed(3)} against a game; goals '
      '${(safe.goalsFor - neutral.goalsFor) / games} for, '
      '${(safe.goalsAgainst - neutral.goalsAgainst) / games} against',
    );
    expect(lessFor, greaterThan(0));
    expect(lessAgainst, greaterThan(0));
    expect(lessFor, lessThan(0.4));
    expect(lessAgainst, lessThan(0.4));
    expect(safe.goalsAgainst, lessThanOrEqualTo(neutral.goalsAgainst));
    expect(safe.longThrowGoals, 0);
  });

  test('the style can be changed mid-match, from that minute on', () {
    const engine = MatchEngine();
    final a = _team(1);
    final b = _team(2);
    var differs = 0;
    for (var i = 0; i < 200; i++) {
      final base = engine.play(
        home: a,
        away: b,
        rng: SeededRng.forFixture(0xC4A, i),
      );
      final changed = engine.play(
        home: a,
        away: b,
        rng: SeededRng.forFixture(0xC4A, i),
        changes: [
          TacticalChange(
            teamNationId: 1,
            minute: 60,
            formation: a.formation,
            instructions: a.instructions,
            xi: a.xi,
            throwIn: (style: ThrowInStyle.long, taker: 101),
          ),
        ],
      );
      // The hour already played is never rewritten.
      expect(
        changed.events.where((e) => e.minute < 60).map((e) => e.playerId),
        base.events.where((e) => e.minute < 60).map((e) => e.playerId),
      );
      if (_print(changed) != _print(base)) differs++;
      for (final e in changed.events.where((e) => e.longThrow)) {
        expect(e.minute, greaterThanOrEqualTo(60));
        if (e.playerId != 101) expect(e.assistPlayerId, 101);
      }
    }
    expect(differs, greaterThan(0));
  });

  group('automatic thrower', () {
    PlayerAttributes attrs(int physical) =>
        PlayerAttributes(physical: physical, technical: 70, stamina: 70);

    test('never the keeper, however strong', () {
      final positions = Formation.f442.positions;
      final xi = [
        for (var i = 0; i < 11; i++)
          player(
            id: i + 1,
            nationId: 1,
            position: positions[i],
            attributes: attrs(i == 0 ? 99 : 60),
          ),
      ];
      expect(xi.first.position, PlayerPosition.gk);
      expect(SetPiecePicks.throwIn(xi), isNot(1));
      // Only a keeper left: he has to.
      expect(SetPiecePicks.throwIn([xi.first]), 1);
      expect(SetPiecePicks.throwIn(const []), isNull);
    });

    test('the strongest, leaning to the full-backs and away from forwards', () {
      final xi = [
        player(
          id: 1,
          nationId: 1,
          position: PlayerPosition.st,
          attributes: attrs(80),
        ),
        player(
          id: 2,
          nationId: 1,
          position: PlayerPosition.lb,
          attributes: attrs(75),
        ),
        player(
          id: 3,
          nationId: 1,
          position: PlayerPosition.cm,
          attributes: attrs(70),
        ),
      ];
      expect(SetPiecePicks.throwIn(xi), 2);
      expect(
        SetPiecePicks.throwIn([
          ...xi,
          player(
            id: 4,
            nationId: 1,
            position: PlayerPosition.cb,
            attributes: attrs(90),
          ),
        ]),
        4,
      );
    });
  });
}
