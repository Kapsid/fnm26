import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/real_history.dart';
import 'package:fnm/domain/services/competition/world_pedigree.dart';

Honour _wc(int year, int gold, int silver, int? third, {String? comp}) => (
  year: year,
  competition: comp ?? RealHistory.worldChampionship,
  championId: gold,
  coChampionId: null,
  runnerUpId: silver,
  thirdId: third,
  thirdId2: null,
  hostId: null,
  hostIds: const <int>[],
  finalHomeScore: null,
  finalAwayScore: null,
  topScorerName: null,
  topScorerGoals: null,
);

void main() {
  group('WorldPedigree', () {
    test(
      'a recent medal is worth more than an old one, never past the cap',
      () {
        final e = WorldPedigree.edges(
          honours: [
            _wc(2026, 1, 2, 3),
            _wc(1990, 2, 1, 4),
            for (var y = 1994; y < 2026; y += 4) _wc(y, 5, 2, 3),
          ],
          year: 2030,
        );
        expect(
          e[1]!,
          greaterThan(e[4]!),
          reason: 'gold 2026 beats bronze 1990',
        );
        expect(e[5]!, lessThanOrEqualTo(WorldPedigree.cap));
        expect(e[5]!, greaterThan(2), reason: 'eight titles in a row is a lot');
        expect(e.containsKey(9), isFalse);
      },
    );

    test('only earlier World Championships count', () {
      final e = WorldPedigree.edges(
        honours: [
          _wc(2030, 1, 2, 3),
          _wc(2026, 7, 8, 9, comp: RealHistory.europeanChampionship),
        ],
        year: 2030,
      );
      expect(e, isEmpty);
    });

    test('real fourth places are credited by name', () {
      final e = WorldPedigree.edges(
        honours: const [],
        year: 2026,
        idByEnglishName: {'Morocco': 135},
      );
      expect(e[135], greaterThan(0));
    });
  });

  group('Fixture shown score', () {
    Fixture f(int h, int a, {int? hp, int? ap}) => Fixture(
      id: 1,
      careerId: 1,
      competitionId: 1,
      matchday: 1,
      date: DateTime(2030),
      homeNationId: 1,
      awayNationId: 2,
      homeScore: h,
      awayScore: a,
      round: 'FINAL',
      played: true,
      afterExtraTime: hp != null,
      homePenalties: hp,
      awayPenalties: ap,
    );

    test('a shootout stored one goal clear shows level', () {
      final away = f(1, 2, hp: 3, ap: 4);
      expect((away.shownHomeScore, away.shownAwayScore), (1, 1));
      final home = f(3, 2, hp: 5, ap: 4);
      expect((home.shownHomeScore, home.shownAwayScore), (2, 2));
    });

    test(
      'a shootout already stored level and any other result are as stored',
      () {
        final level = f(1, 1, hp: 4, ap: 2);
        expect((level.shownHomeScore, level.shownAwayScore), (1, 1));
        final plain = f(3, 1);
        expect((plain.shownHomeScore, plain.shownAwayScore), (3, 1));
      },
    );
  });
}
