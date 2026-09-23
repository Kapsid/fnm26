import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/achievements/challenges.dart';

ChallengeStats _stats({
  int wc = 0,
  int wcNations = 0,
  Set<Confederation> wcConfs = const {},
  int streak = 0,
  int cont = 0,
  Set<String> contCups = const {},
  int nationsCup = 0,
  int clash = 0,
  int years = 0,
  int nations = 1,
  bool undefeated = false,
  bool perfectQual = false,
  bool asHost = false,
  bool asVisitor = false,
  bool asMinnow = false,
  int unbeaten = 0,
}) => ChallengeStats(
  worldCupTitles: wc,
  distinctWorldCupNations: wcNations,
  worldCupConfederations: wcConfs,
  mostWorldCupsInARow: streak,
  continentalTitles: cont,
  continentalCupsWon: contCups,
  nationsCupTitles: nationsCup,
  clashTitles: clash,
  yearsManaged: years,
  nationsManaged: nations,
  wonWorldCupUndefeated: undefeated,
  perfectQualifying: perfectQual,
  wonWorldCupAsHost: asHost,
  wonWorldCupAsVisitor: asVisitor,
  wonWorldCupAsMinnow: asMinnow,
  longestUnbeatenRun: unbeaten,
);

ChallengeDef _byId(String id) =>
    ChallengeCatalog.all.firstWhere((c) => c.id == id);

void main() {
  test('every challenge has a unique id and a positive target', () {
    final ids = ChallengeCatalog.all.map((c) => c.id).toSet();
    expect(ids.length, ChallengeCatalog.all.length);
    for (final c in ChallengeCatalog.all) {
      final (_, target) = c.progressOf(_stats());
      expect(target, greaterThan(0), reason: c.id);
    }
  });

  test('win 3 World Cups completes at three', () {
    expect(_byId('ch_wc_3').isComplete(_stats(wc: 2)), isFalse);
    expect(_byId('ch_wc_3').isComplete(_stats(wc: 3)), isTrue);
  });

  test('World Cup with every confederation needs all six', () {
    final five = {
      Confederation.europe,
      Confederation.southAmerica,
      Confederation.africa,
      Confederation.asia,
      Confederation.northAmerica,
    };
    expect(_byId('ch_wc_allconf').isComplete(_stats(wcConfs: five)), isFalse);
    expect(
      _byId(
        'ch_wc_allconf',
      ).isComplete(_stats(wcConfs: {...five, Confederation.oceania})),
      isTrue,
    );
  });

  test('play 100 and 500 years', () {
    expect(_byId('ch_years_100').isComplete(_stats(years: 99)), isFalse);
    expect(_byId('ch_years_100').isComplete(_stats(years: 100)), isTrue);
    expect(_byId('ch_years_500').isComplete(_stats(years: 500)), isTrue);
  });

  test('clean sweep needs WC + continental + Nations Cup (not the Clash)', () {
    expect(
      _byId('ch_treble').isComplete(_stats(wc: 1, cont: 1)),
      isFalse,
    );
    // The Continental Clash is irrelevant to the clean sweep now.
    expect(
      _byId('ch_treble').isComplete(_stats(wc: 1, cont: 1, clash: 1)),
      isFalse,
    );
    expect(
      _byId('ch_treble').isComplete(_stats(wc: 1, cont: 1, nationsCup: 1)),
      isTrue,
    );
  });

  test('untouchable needs an undefeated title', () {
    expect(_byId('ch_undefeated').isComplete(_stats()), isFalse);
    expect(
      _byId('ch_undefeated').isComplete(_stats(undefeated: true)),
      isTrue,
    );
  });

  test('flawless passage needs a perfect qualifying run', () {
    expect(
      _byId('ch_perfect_qual').isComplete(_stats(perfectQual: true)),
      isTrue,
    );
  });

  test('minnow miracle needs a low-ranked winner', () {
    expect(_byId('ch_minnow').isComplete(_stats(asMinnow: true)), isTrue);
  });

  test('home & away needs a title both as host and away', () {
    expect(_byId('ch_grand_tour').isComplete(_stats(asHost: true)), isFalse);
    expect(
      _byId('ch_grand_tour').isComplete(_stats(asHost: true, asVisitor: true)),
      isTrue,
    );
  });

  test('the wall needs a 25-match unbeaten run', () {
    expect(_byId('ch_unbeaten_25').isComplete(_stats(unbeaten: 24)), isFalse);
    expect(_byId('ch_unbeaten_25').isComplete(_stats(unbeaten: 25)), isTrue);
  });
}
