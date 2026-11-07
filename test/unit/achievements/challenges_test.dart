import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/achievements/challenges.dart';

ChallengeStats stats({
  int worldCupTitles = 0,
  int continentalTitles = 0,
  int careerGoals = 0,
  int careerCleanSheets = 0,
  int careerHatTricks = 0,
  int longestWinStreak = 0,
  int nationsCupTitles = 0,
  int clashTitles = 0,
}) => ChallengeStats(
  worldCupTitles: worldCupTitles,
  distinctWorldCupNations: 0,
  worldCupConfederations: const <Confederation>{},
  mostWorldCupsInARow: 0,
  continentalTitles: continentalTitles,
  continentalCupsWon: const <String>{},
  nationsCupTitles: nationsCupTitles,
  clashTitles: clashTitles,
  yearsManaged: 0,
  nationsManaged: 0,
  careerGoals: careerGoals,
  careerCleanSheets: careerCleanSheets,
  careerHatTricks: careerHatTricks,
  longestWinStreak: longestWinStreak,
);

void main() {
  // The trophy cabinet and the manager's history count the Continental Clash
  // as a title; the majors challenge sums the same shelves.
  test('the majors challenge counts every shelf of the cabinet', () {
    final majors = ProceduralChallenges.forSeed(
      1,
    ).firstWhere((c) => c.id == 'pc_majors');
    final (got, _) = majors.progressOf(
      stats(
        worldCupTitles: 1,
        continentalTitles: 1,
        nationsCupTitles: 1,
        clashTitles: 1,
      ),
    );
    expect(got, 4);
  });

  test('every challenge id (catalogue + procedural) is unique', () {
    final ids = [
      ...ChallengeCatalog.all.map((c) => c.id),
      ...ProceduralChallenges.forSeed(1).map((c) => c.id),
    ];
    expect(ids.toSet().length, ids.length);
  });

  test('every challenge has non-empty English fallback text', () {
    for (final c in [
      ...ChallengeCatalog.all,
      ...ProceduralChallenges.forSeed(7),
    ]) {
      expect(c.title, isNotEmpty);
      expect(c.description, isNotEmpty);
    }
  });

  test('career-collector challenges complete at their thresholds', () {
    final by = {for (final c in ChallengeCatalog.all) c.id: c};
    expect(by['ch_goals_10k']!.isComplete(stats(careerGoals: 10000)), isTrue);
    expect(by['ch_goals_10k']!.isComplete(stats(careerGoals: 9999)), isFalse);
    expect(
      by['ch_cleansheets_500']!.isComplete(stats(careerCleanSheets: 500)),
      isTrue,
    );
    expect(
      by['ch_hattricks_25']!.isComplete(stats(careerHatTricks: 25)),
      isTrue,
    );
    expect(
      by['ch_winstreak_25']!.isComplete(stats(longestWinStreak: 25)),
      isTrue,
    );
    expect(by['ch_cont_10']!.isComplete(stats(continentalTitles: 10)), isTrue);
  });

  test('procedural targets sit in their documented ranges', () {
    final byId = {for (final c in ProceduralChallenges.forSeed(42)) c.id: c};
    final (_, wc) = byId['pc_wc']!.progressOf(stats());
    final (_, years) = byId['pc_years']!.progressOf(stats());
    expect(wc, inInclusiveRange(2, 5));
    expect(years, inInclusiveRange(40, 199));
  });
}
