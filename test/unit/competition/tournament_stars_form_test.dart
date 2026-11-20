import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/competition/tournament_stars.dart';

Player _p(int id, PlayerPosition pos, int overall) => Player(
  id: id,
  nationId: id ~/ 100,
  name: 'P$id',
  position: pos,
  age: 26,
  club: 'C',
  attributes: PlayerAttributes(
    physical: overall,
    technical: overall,
    stamina: overall,
  ),
);

void main() {
  test('a great tournament beats a great reputation', () {
    final star = _p(101, PlayerPosition.st, 92); // famous, poor tournament
    final unknown = _p(102, PlayerPosition.st, 70); // unknown, superb
    final xi = TournamentStars.teamOfTournament(
      candidates: [star, unknown],
      goalsByPlayer: const {},
      runByNation: const {1: 2},
      formByPlayer: {
        101: (apps: 5, meanRating: 6.1, motms: 0),
        102: (apps: 5, meanRating: 8.2, motms: 3),
      },
    );
    expect(xi.first.id, 102);
  });

  test('a player who never appeared cannot be picked', () {
    final benched = _p(101, PlayerPosition.st, 99);
    final played = _p(102, PlayerPosition.st, 60);
    final xi = TournamentStars.teamOfTournament(
      candidates: [benched, played],
      goalsByPlayer: const {},
      runByNation: const {},
      formByPlayer: {102: (apps: 4, meanRating: 7.0, motms: 0)},
    );
    expect(xi.map((s) => s.id), [102]);
  });

  test('one good game is not a tournament', () {
    final cameo = _p(101, PlayerPosition.st, 80);
    final xi = TournamentStars.teamOfTournament(
      candidates: [cameo],
      goalsByPlayer: const {},
      runByNation: const {},
      formByPlayer: {101: (apps: 1, meanRating: 9.5, motms: 1)},
    );
    expect(xi, isEmpty, reason: 'below the minimum appearances');
  });

  test('a defender can make the team on performance alone', () {
    final xi = TournamentStars.teamOfTournament(
      candidates: [
        _p(101, PlayerPosition.cb, 72),
        _p(102, PlayerPosition.st, 90),
      ],
      goalsByPlayer: const {102: 4},
      runByNation: const {},
      formByPlayer: {
        101: (apps: 6, meanRating: 7.9, motms: 2),
        102: (apps: 6, meanRating: 7.0, motms: 0),
      },
    );
    expect(xi.map((s) => s.id), contains(101));
  });

  test('with no rating data it falls back to the old scoring', () {
    final xi = TournamentStars.teamOfTournament(
      candidates: [
        _p(101, PlayerPosition.st, 90),
        _p(102, PlayerPosition.st, 60),
      ],
      goalsByPlayer: const {},
      runByNation: const {},
    );
    expect(xi.first.id, 101, reason: 'reputation still decides an old edition');
    expect(xi.first.apps, 0);
  });

  test('the golden glove goes to the best keeper who actually played', () {
    final unused = _p(101, PlayerPosition.gk, 95);
    final good = _p(102, PlayerPosition.gk, 78);
    final glove = TournamentStars.goldenGlove(
      candidates: [unused, good],
      formByPlayer: {102: (apps: 6, meanRating: 7.6, motms: 1)},
      cleanSheetsByPlayer: const {102: 4},
    );
    expect(glove?.id, 102);
  });

  test('the golden glove is null when no keeper played enough', () {
    expect(
      TournamentStars.goldenGlove(
        candidates: [_p(101, PlayerPosition.gk, 90)],
        formByPlayer: const {},
        cleanSheetsByPlayer: const {},
      ),
      isNull,
    );
  });

  test('three right-backs and two strikers do not all make one team', () {
    // The reported team: GK, LB, RB, RB, RB, DM, CM, DM, ST, RW, ST.
    final players = [
      _p(101, PlayerPosition.gk, 70),
      _p(102, PlayerPosition.lb, 70),
      for (var i = 0; i < 3; i++) _p(110 + i, PlayerPosition.rb, 70),
      for (var i = 0; i < 2; i++) _p(120 + i, PlayerPosition.cb, 70),
      for (var i = 0; i < 3; i++) _p(130 + i, PlayerPosition.cm, 70),
      for (var i = 0; i < 2; i++) _p(140 + i, PlayerPosition.st, 70),
      _p(150, PlayerPosition.lw, 70),
      _p(151, PlayerPosition.rw, 70),
    ];
    final xi = TournamentStars.teamOfTournament(
      candidates: players,
      goalsByPlayer: const {},
      runByNation: const {},
      formByPlayer: {
        for (final p in players)
          // The right-backs and the strikers had the best tournaments.
          p.id: (
            apps: 5,
            meanRating:
                p.position == PlayerPosition.rb ||
                    p.position == PlayerPosition.st
                ? 8.0
                : 6.8,
            motms: 0,
          ),
      },
    );
    int at(PlayerPosition p) => xi.where((s) => s.position == p).length;
    expect(xi, hasLength(11));
    expect(at(PlayerPosition.gk), 1);
    expect(at(PlayerPosition.lb), 1);
    expect(at(PlayerPosition.cb), 2);
    expect(at(PlayerPosition.rb), 1);
    expect(at(PlayerPosition.cm), 3);
    expect(at(PlayerPosition.lw), 1);
    expect(at(PlayerPosition.st), 1);
    expect(at(PlayerPosition.rw), 1);
    // Still best first: the head of the team is its Golden Ball.
    expect(xi.first.score, xi.map((s) => s.score).reduce(math.max));
  });

  test('a place nobody of its position earned goes to its line', () {
    // No left-back took part: a right-back fills the place.
    final players = [
      _p(101, PlayerPosition.gk, 70),
      for (var i = 0; i < 2; i++) _p(110 + i, PlayerPosition.rb, 70),
      for (var i = 0; i < 2; i++) _p(120 + i, PlayerPosition.cb, 70),
      for (var i = 0; i < 3; i++) _p(130 + i, PlayerPosition.cm, 70),
      _p(140, PlayerPosition.st, 70),
      _p(150, PlayerPosition.lw, 70),
      _p(151, PlayerPosition.rw, 70),
    ];
    final xi = TournamentStars.teamOfTournament(
      candidates: players,
      goalsByPlayer: const {},
      runByNation: const {},
      formByPlayer: {
        for (final p in players) p.id: (apps: 5, meanRating: 7.0, motms: 0),
      },
    );
    expect(xi, hasLength(11));
    expect(xi.where((s) => s.position == PlayerPosition.rb), hasLength(2));
  });
}
