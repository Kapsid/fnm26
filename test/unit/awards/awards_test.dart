import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/awards/awards.dart';

void main() {
  AwardLine line(
    int id, {
    int age = 27,
    int apps = 12,
    int goals = 0,
    int assists = 0,
    double rating = 7.0,
    int motms = 0,
  }) =>
      (
        playerId: id,
        nationId: 1,
        name: 'P$id',
        age: age,
        apps: apps,
        goals: goals,
        assists: assists,
        meanRating: rating,
        motms: motms,
      );

  group('Player of the Year', () {
    test('nobody wins a year nobody played', () {
      expect(Awards.playerOfYear(const []), isNull);
    });

    test('a handful of brilliant games does not beat a season', () {
      // The failure this guards: the award going to whoever played twice and
      // was marked 9.0 both times.
      final flash = line(1, apps: 3, rating: 9.5);
      final season = line(2, apps: 15, rating: 7.6);
      expect(Awards.playerOfYear([flash, season])!.playerId, 2);
    });

    test('below the appearance floor you are not in the running', () {
      expect(
        Awards.playerOfYear([line(1, apps: Awards.minApps - 1, rating: 9.9)]),
        isNull,
      );
    });

    test('at equal ratings, goals and man-of-the-match awards decide', () {
      final quiet = line(1, rating: 7.4);
      final decisive = line(2, rating: 7.4, goals: 9, motms: 4);
      expect(Awards.playerOfYear([quiet, decisive])!.playerId, 2);
    });

    test('the winner carries the right award', () {
      expect(
        Awards.playerOfYear([line(1)])!.kind,
        AwardKind.playerOfYear,
      );
    });

    test('a tie resolves the same way twice', () {
      final a = [line(1, rating: 7.5), line(2, rating: 7.5)];
      expect(
        Awards.playerOfYear(a)!.playerId,
        Awards.playerOfYear(a.reversed)!.playerId,
      );
    });
  });

  group('Young Player of the Year', () {
    test('never goes to a man too old for it', () {
      final old = line(1, age: 21, rating: 9.0);
      final young = line(2, age: 19, rating: 7.2);
      expect(Awards.youngPlayerOfYear([old, young])!.playerId, 2);
    });

    test('is empty when no youngster played enough', () {
      expect(
        Awards.youngPlayerOfYear([line(1, age: 28, rating: 9.0)]),
        isNull,
      );
    });

    test('the same man can win both', () {
      final prodigy = line(1, age: 19, apps: 16, rating: 8.4, goals: 12);
      final rest = [line(2, rating: 7.1), line(3, rating: 7.0)];
      expect(Awards.playerOfYear([prodigy, ...rest])!.playerId, 1);
      expect(Awards.youngPlayerOfYear([prodigy, ...rest])!.playerId, 1);
    });
  });

  test('more football is worth more, with diminishing returns', () {
    double at(int apps) => Awards.score(line(1, apps: apps, rating: 7.0));
    expect(at(12), greaterThan(at(8)));
    expect(at(30), greaterThan(at(20)));
    // The step from 8 to 12 games is worth more than 26 to 30.
    expect(at(12) - at(8), greaterThan(at(30) - at(26)));
  });
}
