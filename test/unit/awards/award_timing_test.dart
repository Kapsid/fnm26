import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/competition/tournament_stars.dart';

Fixture _fixture({required bool played, int id = 1}) => Fixture(
  id: id,
  careerId: 1,
  competitionId: 1,
  matchday: 1,
  date: DateTime(2030, 6, 11),
  homeNationId: 1,
  awayNationId: 2,
  homeScore: played ? 2 : null,
  awayScore: played ? 1 : null,
  played: played,
);

void main() {
  test('no award while a fixture is unplayed', () {
    expect(
      TournamentStars.isComplete([
        _fixture(played: true),
        _fixture(played: true, id: 2),
        _fixture(played: false, id: 3),
      ]),
      isFalse,
    );
  });

  test('a third-place play-off still to come holds the award back', () {
    // The final decided the champion; the tournament is not over.
    expect(
      TournamentStars.isComplete([
        _fixture(played: true),
        _fixture(played: false, id: 2),
      ]),
      isFalse,
    );
  });

  test('the award is named once every fixture is played', () {
    expect(
      TournamentStars.isComplete([
        _fixture(played: true),
        _fixture(played: true, id: 2),
      ]),
      isTrue,
    );
  });

  test('a tournament with no fixtures names nobody', () {
    expect(TournamentStars.isComplete(const []), isFalse);
  });
}
