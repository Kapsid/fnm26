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
}
