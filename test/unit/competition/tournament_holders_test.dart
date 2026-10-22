import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/tournament_holders.dart';

/// Who holds a trophy walking into the edition on screen.
///
/// The case that matters is the first one: a champion is written to the roll
/// of honour the moment the final is played, so the newest honour is very
/// often the edition the manager is looking at. The holders line must name
/// the nation that came in holding it, never the one that has just won it.
void main() {
  Honour honour({
    required int year,
    required int championId,
    String competition = 'World Championship',
  }) => (
    year: year,
    competition: competition,
    championId: championId,
    coChampionId: null,
    runnerUpId: 99,
    thirdId: null,
    thirdId2: null,
    hostId: null,
    hostIds: const [],
    finalHomeScore: 2,
    finalAwayScore: 1,
    topScorerName: null,
    topScorerGoals: null,
  );

  // "Cup holders is not updated when the cup ends but only after the cycle."
  // The champion of the edition on screen holds the trophy from the night of
  // its final, not from the turn of the cycle.
  test('a decided edition holds its own trophy', () {
    // Newest-first, exactly as CompetitionRepository.honours returns them,
    // with 2026 already decided while 2026 is the edition being viewed.
    final honours = [
      honour(year: 2026, championId: 7),
      honour(year: 2022, championId: 3),
    ];

    final holders = TournamentHolders.forEdition(
      honours: honours,
      competition: 'World Championship',
      editionYear: 2026,
    );

    expect(holders, (nationId: 7, year: 2026));
  });

  test('before its final, the previous champion holds it', () {
    final holders = TournamentHolders.forEdition(
      honours: [honour(year: 2022, championId: 3)],
      competition: 'World Championship',
      editionYear: 2026,
    );

    expect(holders, (nationId: 3, year: 2022));
  });

  test('an edition after the one on screen is never its holder', () {
    final holders = TournamentHolders.forEdition(
      honours: [
        honour(year: 2030, championId: 9),
        honour(year: 2022, championId: 3),
      ],
      competition: 'World Championship',
      editionYear: 2026,
    );

    expect(holders, (nationId: 3, year: 2022));
  });

  test('the most recent prior edition wins over an older one', () {
    final honours = [
      honour(year: 2022, championId: 3),
      honour(year: 2018, championId: 4),
      honour(year: 2014, championId: 5),
    ];

    final holders = TournamentHolders.forEdition(
      honours: honours,
      competition: 'World Championship',
      editionYear: 2026,
    );

    expect(holders, (nationId: 3, year: 2022));
  });

  test("another competition's champions are not this trophy's holders", () {
    final honours = [
      honour(year: 2024, championId: 8, competition: 'European Championship'),
      honour(year: 2022, championId: 3),
    ];

    final holders = TournamentHolders.forEdition(
      honours: honours,
      competition: 'World Championship',
      editionYear: 2026,
    );

    expect(holders, (nationId: 3, year: 2022));
  });

  test('a trophy nobody has ever won has no holders', () {
    final honours = [
      honour(year: 2024, championId: 8, competition: 'European Championship'),
    ];

    expect(
      TournamentHolders.forEdition(
        honours: honours,
        competition: 'World Championship',
        editionYear: 2026,
      ),
      isNull,
    );
    expect(
      TournamentHolders.forEdition(
        honours: const [],
        competition: 'World Championship',
        editionYear: 2026,
      ),
      isNull,
    );
  });
}
