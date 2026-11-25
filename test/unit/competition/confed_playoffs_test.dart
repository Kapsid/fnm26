import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/services/competition/confed_playoffs.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/match/match_engine.dart';

import '../../helpers/fixtures.dart';

/// Africa's, Asia's and Oceania's World Championship qualifying play-off
/// steps (calendar2) and the two-legged tie Asia's fifth round is played
/// over: who enters, how they are drawn, and how a tie is decided.
void main() {
  // A confederation's groups, each [size] deep, sides numbered by group and
  // finishing position (group 0's winner is 100, its runner-up 101, ...), the
  // records such that group g's side at place p has 30 - 3p - g points.
  List<List<GroupStanding>> groups(int count, int size) => [
    for (var g = 0; g < count; g++)
      [
        for (var p = 0; p < size; p++)
          GroupStanding(100 * (g + 1) + p)
            ..played = 10
            ..won = 10 - p
            ..lost = p
            ..goalsFor = 20 - p - g
            ..goalsAgainst = p,
      ],
  ];

  group('entrants', () {
    test('Africa: every group winner through, the four best runners-up '
        'to the play-off', () {
      final g = groups(9, 6);
      final entrants = ConfedPlayoffs.entrants(
        Confederation.africa,
        g,
        hosts: 0,
      );
      expect(entrants, hasLength(4));
      expect(entrants, [101, 201, 301, 401]);
      expect(ConfedPlayoffs.heldBack(Confederation.africa, 9), 0);
      expect(ConfedPlayoffs.groupBerths(Confederation.africa, 0), 9);
    });

    test('Asia: two places held back; the last two winners and the four '
        'best runners-up play the fourth round', () {
      final g = groups(8, 6);
      expect(ConfedPlayoffs.groupBerths(Confederation.asia, 0), 6);
      final entrants = ConfedPlayoffs.entrants(
        Confederation.asia,
        g,
        hosts: 0,
      );
      expect(entrants, [700, 800, 101, 201, 301, 401]);
      // An Asian host takes a place: five through, the next six play on.
      expect(ConfedPlayoffs.groupBerths(Confederation.asia, 1), 5);
      expect(ConfedPlayoffs.entrants(Confederation.asia, g, hosts: 1), [
        600,
        700,
        800,
        101,
        201,
        301,
      ]);
    });

    test('Oceania: its place is held back; the two group winners meet', () {
      final g = groups(2, 6);
      expect(ConfedPlayoffs.groupBerths(Confederation.oceania, 0), 0);
      expect(ConfedPlayoffs.entrants(Confederation.oceania, g, hosts: 0), [
        100,
        200,
      ]);
      // An Oceanian host took the place: no final, the ladder as before.
      expect(
        ConfedPlayoffs.entrants(Confederation.oceania, g, hosts: 1),
        isEmpty,
      );
    });

    test('no step for Europe, South or North America', () {
      for (final c in [
        Confederation.europe,
        Confederation.southAmerica,
        Confederation.northAmerica,
      ]) {
        expect(ConfedPlayoffs.entrants(c, groups(6, 5), hosts: 0), isEmpty);
        expect(ConfedPlayoffs.heldBack(c, 6), 0);
      }
    });
  });

  group('draws', () {
    final rank = {for (var i = 0; i < 1000; i++) i: 1000 - i};

    test('Africa seeds by the ranking: 1 v 4, 2 v 3', () {
      final seeds = ConfedPlayoffs.cafSeeds([101, 401, 201, 301], rank);
      expect(seeds, [401, 301, 201, 101]);
      expect(ConfedPlayoffs.cafSemis(seeds), [(401, 101), (301, 201)]);
    });

    test('Asia: one side of each pot of two in each group, each group '
        'with its top seed at home in both its matches', () {
      final entrants = [10, 20, 30, 40, 50, 60];
      for (var seed = 0; seed < 20; seed++) {
        final g = ConfedPlayoffs.afcGroups(entrants, rank, SeededRng(seed));
        expect(g, hasLength(2));
        // By rank (higher id = better here): pots {60,50}, {40,30}, {20,10}.
        expect({g[0].sides[0], g[1].sides[0]}, {60, 50});
        expect({g[0].sides[1], g[1].sides[1]}, {40, 30});
        expect({g[0].sides[2], g[1].sides[2]}, {20, 10});
        final games = [
          for (var md = 0; md < 3; md++)
            ...ConfedPlayoffs.afcMatchday(g[0], md),
        ];
        expect(games, hasLength(3));
        expect(games.where((p) => p.$1 == g[0].sides[0]), hasLength(2));
        final met = {
          for (final p in games) ([p.$1, p.$2]..sort()).join('-'),
        };
        expect(met, hasLength(3));
      }
    });

    test('the fifth round: first leg at the lower-ranked side', () {
      final (first, second) = ConfedPlayoffs.afc5Legs(10, 60, rank);
      expect(first, (10, 60));
      expect(second, (60, 10));
    });

    test('the stored rows read back in order', () {
      final rows = ConfedPlayoffs.toSlots({
        'A': [3, 2, 1],
        'B': [6, 5, 4],
      });
      expect(ConfedPlayoffs.fromSlots(rows.reversed.toList()), {
        'A': [3, 2, 1],
        'B': [6, 5, 4],
      });
    });

    test('step days hang off November W-1, Asia fifth round last', () {
      final d = ConfedPlayoffs.dates(2030, DateTime(2029, 11, 10));
      expect(d.first, DateTime(2029, 11, 13));
      expect(d.afc4Days, [
        DateTime(2029, 11, 13),
        DateTime(2029, 11, 16),
        DateTime(2029, 11, 19),
      ]);
      expect(d.afc5Leg1Day.isAfter(d.afc4Days.last), isTrue);
      expect(d.afc5Leg2Day.isAfter(d.afc5Leg1Day), isTrue);
      // A late last qualifier moves them on.
      expect(
        ConfedPlayoffs.dates(2030, DateTime(2029, 11, 15)).first,
        DateTime(2029, 11, 15),
      );
      // Never so late the second leg leaves November.
      final late = ConfedPlayoffs.dates(2030, DateTime(2029, 11, 25));
      expect(late.first, DateTime(2029, 11, 17));
      expect(late.afc5Leg2Day.month, 11);
    });
  });

  group('two legs', () {
    Fixture leg(
      int id,
      String round,
      int home,
      int away,
      int hs,
      int as, {
      int? hp,
      int? ap,
    }) => Fixture(
      id: id,
      careerId: 1,
      competitionId: 1,
      matchday: 99,
      date: DateTime(2029, 11, id),
      homeNationId: home,
      awayNationId: away,
      homeScore: hs,
      awayScore: as,
      round: round,
      played: true,
      homePenalties: hp,
      awayPenalties: ap,
    );

    test('the aggregate decides, with no away goals', () {
      final first = leg(1, ConfedPlayoffs.afc5Leg1, 7, 9, 2, 1);
      expect(TwoLegged.levelMargin(first), 1);
      final second = leg(2, ConfedPlayoffs.afc5Leg2, 9, 7, 2, 0);
      expect(TwoLegged.firstLegAmong(second, [first]), first);
      expect(TwoLegged.aggregate(first, second), (3, 2));
      expect(TwoLegged.winner(first, second), 9);
      // 1-0 to the second leg's hosts levels it: that is the extra-time
      // margin; 3-2 after extra time is the hosts' on aggregate (4-4 is
      // not: no away goals).
      final afterEt = leg(3, ConfedPlayoffs.afc5Leg2, 9, 7, 3, 1);
      expect(TwoLegged.winner(first, afterEt), 9);
    });

    test('a second leg settled on penalties is stored one goal clear and '
        'shows the real score', () {
      final first = leg(1, ConfedPlayoffs.afc5Leg1, 7, 9, 2, 0);
      // 2-0 on the night levels it; the away side wins the kicks and is
      // stored a goal up (2-1), the aggregate naming the winner.
      final second = leg(
        2,
        ConfedPlayoffs.afc5Leg2,
        9,
        7,
        2,
        1,
        hp: 3,
        ap: 4,
      );
      expect(TwoLegged.winner(first, second), 7);
      expect((second.shownHomeScore, second.shownAwayScore), (2, 0));
      // The home side winning them: 3-0 stored, 2-0 shown.
      final home = leg(3, ConfedPlayoffs.afc5Leg2, 9, 7, 3, 0, hp: 5, ap: 4);
      expect(TwoLegged.winner(first, home), 9);
      expect((home.shownHomeScore, home.shownAwayScore), (2, 0));
    });

    test('a one-off shootout still shows level', () {
      final f = leg(1, 'FINAL', 1, 2, 2, 1, hp: 4, ap: 3);
      expect((f.shownHomeScore, f.shownAwayScore), (1, 1));
      final g = leg(2, 'FINAL', 1, 2, 1, 2, hp: 3, ap: 4);
      expect((g.shownHomeScore, g.shownAwayScore), (1, 1));
    });

    test('a level tie drawn level is shifted back onto its real score', () {
      final ko = WorldCupFinals.decideKnockout(1, 1, SeededRng(5));
      final shifted = ko.shiftedHome(2);
      expect(shifted.homeScore, ko.homeScore + 2);
      expect(shifted.awayScore, ko.awayScore);
      expect(shifted.homeKicks, ko.homeKicks);
      expect(ko.shiftedHome(0), same(ko));
    });

    test('the engine plays extra time exactly at the margin it is given, '
        'the ninety unchanged', () {
      final home = ratedTeam(1, 80);
      final away = ratedTeam(2, 78);
      var checked = 0;
      for (var seed = 0; seed < 40 && checked < 6; seed++) {
        final plain = const MatchEngine().play(
          home: home,
          away: away,
          rng: SeededRng(seed),
        );
        final margin = plain.homeScore - plain.awayScore;
        final at = const MatchEngine().play(
          home: home,
          away: away,
          rng: SeededRng(seed),
          extraTimeAtMargin: margin,
        );
        expect(
          (at.homeScore, at.awayScore),
          (
            plain.homeScore,
            plain.awayScore,
          ),
        );
        expect(at.extraTime, isNotNull);
        final off = const MatchEngine().play(
          home: home,
          away: away,
          rng: SeededRng(seed),
          extraTimeAtMargin: margin + 1,
        );
        expect(off.extraTime, isNull);
        if (margin != 0) checked++;
      }
      expect(checked, greaterThan(0));
    });
  });
}
