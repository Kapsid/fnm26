import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/awards/award_year.dart';

/// The manager's matches are rated by the full engine, whose marks spread
/// wider than the background model's: the vote reads them on the world's
/// scale, so his men are not favoured by the spread alone.
void main() {
  test('an engine mark is pulled towards the world mean', () {
    expect(AwardYear.onWorldScale(AwardYear.engineMean), AwardYear.engineMean);
    expect(AwardYear.onWorldScale(9), closeTo(6.6 + 2.4 * 0.83, 1e-9));
    expect(AwardYear.onWorldScale(5), greaterThan(5));
  });

  test("only the engine side's fixtures are rescaled", () {
    AwardFixture fx(int id, int home, int away) => (
      id: id,
      competitionId: 1,
      kind: CompetitionKind.worldCupQualifying,
      confederation: Confederation.europe,
      round: null,
      date: DateTime(2027, 3, id),
      homeNationId: home,
      awayNationId: away,
      homeScore: 1,
      awayScore: 0,
      homePenalties: null,
      awayPenalties: null,
    );
    AwardAppearance app(int fixture, int player, int nation) => (
      fixtureId: fixture,
      playerId: player,
      nationId: nation,
      rating: 9.0,
      goals: 0,
      assists: 0,
      cleanSheet: false,
      motm: false,
    );
    final year = AwardYear.build(
      year: 2027,
      fixtures: [fx(1, 10, 11), fx(2, 20, 21)],
      appearances: [app(1, 100, 10), app(2, 200, 20)],
      engineNationIds: {10},
    );
    expect(
      year.lines[100]!.ratingSum,
      closeTo(AwardYear.onWorldScale(9), 1e-9),
    );
    expect(year.lines[200]!.ratingSum, 9.0);
  });
}
