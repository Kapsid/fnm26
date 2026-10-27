import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/awards/award_year.dart';
import 'package:fnm/domain/services/awards/player_of_year.dart';
import 'package:fnm/features/messages/poty_card.dart';

/// A tiny world to vote on, one fixture at a time.
class _World {
  final fixtures = <AwardFixture>[];
  final apps = <AwardAppearance>[];
  var _id = 0;
  var _day = 0;

  /// Adds a played fixture and returns its id.
  int match(
    int home,
    int away, {
    int hs = 1,
    int as = 0,
    CompetitionKind kind = CompetitionKind.worldCupQualifying,
    Confederation conf = Confederation.europe,
    int comp = 1,
    String? round,
  }) {
    final id = ++_id;
    fixtures.add((
      id: id,
      competitionId: comp,
      kind: kind,
      confederation: conf,
      round: round,
      date: DateTime(2030, 1, 1).add(Duration(days: ++_day)),
      homeNationId: home,
      awayNationId: away,
      homeScore: hs,
      awayScore: as,
      homePenalties: null,
      awayPenalties: null,
    ));
    return id;
  }

  void played(
    int fixture,
    int player,
    int nation, {
    double rating = 7.0,
    int goals = 0,
    bool cleanSheet = false,
    bool motm = false,
  }) => apps.add((
    fixtureId: fixture,
    playerId: player,
    nationId: nation,
    rating: rating,
    goals: goals,
    assists: 0,
    cleanSheet: cleanSheet,
    motm: motm,
  ));

  AwardYear build({int Function(int)? rankOf}) => AwardYear.build(
    year: 2030,
    fixtures: fixtures,
    appearances: apps,
    rankOf: rankOf,
  );
}

VoterProfile _p(PlayerPosition pos, {int age = 26, int overall = 80}) =>
    (name: 'P', age: age, position: pos, overall: overall);

/// A World Championship knockout of four (nations 1-4) on competition 10:
/// 1 beats 2 and 3 beats 4 in the semis, 1 beats 3 in the final.
List<int> _worldChampionship(_World w) => [
  w.match(1, 2, kind: CompetitionKind.worldCupFinals, comp: 10, round: 'SF'),
  w.match(3, 4, kind: CompetitionKind.worldCupFinals, comp: 10, round: 'SF'),
  w.match(1, 3, kind: CompetitionKind.worldCupFinals, comp: 10, round: 'FINAL'),
];

/// Six qualifiers for [nation] against nation 99, so a man reaches the floor.
List<int> _qualifiers(_World w, int nation) => [
  for (var i = 0; i < 6; i++) w.match(nation, 99),
];

void main() {
  group('match weights', () {
    AwardFixture f(CompetitionKind kind, String? round, [Confederation? c]) => (
      id: 1,
      competitionId: 1,
      kind: kind,
      confederation: c ?? Confederation.europe,
      round: round,
      date: DateTime(2030),
      homeNationId: 1,
      awayNationId: 2,
      homeScore: 0,
      awayScore: 0,
      homePenalties: null,
      awayPenalties: null,
    );

    test('friendly < qualifier < finals group < finals knockout', () {
      final friendly = AwardYear.weightOf(
        f(CompetitionKind.friendly, 'FRIENDLY'),
      );
      final qualifier = AwardYear.weightOf(
        f(CompetitionKind.worldCupQualifying, null),
      );
      final group = AwardYear.weightOf(
        f(CompetitionKind.worldCupFinals, 'GROUP'),
      );
      final ko = AwardYear.weightOf(f(CompetitionKind.worldCupFinals, 'QF'));
      expect(friendly, lessThan(qualifier));
      expect(qualifier, lessThan(group));
      expect(group, lessThan(ko));
    });

    test('a European championship tie outweighs an Oceania one', () {
      expect(
        AwardYear.weightOf(f(CompetitionKind.continentalFinals, 'CSF')),
        greaterThan(
          AwardYear.weightOf(
            f(
              CompetitionKind.continentalFinals,
              'CSF',
              Confederation.oceania,
            ),
          ),
        ),
      );
    });

    test('a strong opponent counts for more', () {
      expect(
        AwardYear.opponentFactor(5),
        greaterThan(AwardYear.opponentFactor(40)),
      );
      expect(
        AwardYear.opponentFactor(40),
        greaterThan(AwardYear.opponentFactor(150)),
      );
    });
  });

  group('trophies', () {
    test('a World Championship decided this year is read off its knockout', () {
      final w = _World();
      _worldChampionship(w);
      final t = w.build().trophies.single;
      expect(t.family, TrophyFamily.worldChampionship);
      expect(t.champion, 1);
      expect(t.runnerUp, 3);
      expect(t.semiFinalists, unorderedEquals([2, 4]));
      expect(t.placeOf(1), 1);
      expect(t.placeOf(3), 2);
      expect(t.placeOf(2), 3);
      expect(t.placeOf(77), isNull);
    });

    test('a cup whose final is not in the year is not a trophy of it', () {
      final w = _World()
        ..match(
          1,
          2,
          kind: CompetitionKind.worldCupFinals,
          comp: 10,
          round: 'SF',
        );
      expect(w.build().trophies, isEmpty);
    });
  });

  group('team achievements', () {
    test('champion > runner-up > semi-finalist, for the same year', () {
      final w = _World();
      final ko = _worldChampionship(w);
      // Nation n's star plays both his knockout games and six qualifiers.
      for (final (pid, nid) in [(1, 1), (3, 3), (2, 2)]) {
        for (final f in _qualifiers(w, nid)) {
          w.played(f, pid, nid);
        }
      }
      for (final (pid, nid) in [(1, 1), (3, 3)]) {
        w
          ..played(ko[nid == 1 ? 0 : 1], pid, nid)
          ..played(ko[2], pid, nid);
      }
      w.played(ko[0], 2, 2);
      final y = w.build();
      double team(int pid) => PlayerOfYear.team(y.lines[pid]!, y.trophies);
      expect(team(1), greaterThan(team(3)));
      expect(team(3), greaterThan(team(2)));
      expect(team(2), greaterThan(0));
    });

    test('scaled by his share: one game of two counts nothing, two count '
        'in full', () {
      final w = _World();
      final ko = _worldChampionship(w);
      w
        ..played(ko[0], 10, 1)
        ..played(ko[2], 10, 1)
        ..played(ko[2], 11, 1);
      final y = w.build();
      final full = PlayerOfYear.team(y.lines[10]!, y.trophies);
      final cameo = PlayerOfYear.team(y.lines[11]!, y.trophies);
      expect(cameo, 0);
      expect(full, greaterThan(0));
    });

    test('scaled by his form in it', () {
      final w = _World();
      final ko = _worldChampionship(w);
      for (final f in [ko[0], ko[2]]) {
        w
          ..played(f, 10, 1, rating: 8.0)
          ..played(f, 11, 1, rating: 6.2);
      }
      final y = w.build();
      expect(
        PlayerOfYear.team(y.lines[10]!, y.trophies),
        greaterThan(PlayerOfYear.team(y.lines[11]!, y.trophies)),
      );
    });

    test('a European title is worth more than an Oceania one', () {
      TrophyResult cup(Confederation c) => TrophyResult(
        competitionId: 1,
        family: TrophyFamily.continental,
        confederation: c,
        champion: 1,
        runnerUp: 2,
        semiFinalists: const [],
        matchesByNation: const {1: 5},
      );
      expect(
        PlayerOfYear.trophyPoints(cup(Confederation.europe), 1),
        greaterThan(PlayerOfYear.trophyPoints(cup(Confederation.oceania), 1)),
      );
      expect(
        PlayerOfYear.trophyPoints(cup(Confederation.europe), 1),
        lessThan(
          PlayerOfYear.trophyPoints(
            TrophyResult(
              competitionId: 2,
              family: TrophyFamily.worldChampionship,
              confederation: Confederation.europe,
              champion: 1,
              runnerUp: 2,
              semiFinalists: const [],
              matchesByNation: const {1: 7},
            ),
            1,
          ),
        ),
      );
    });
  });

  group('position fairness', () {
    test('a keeper is measured against keepers', () {
      final w = _World();
      for (final f in _qualifiers(w, 1)) {
        w.played(f, 1, 1, rating: 7.2, cleanSheet: true);
      }
      final line = w.build().lines[1]!;
      // The same marks are a great year for a keeper and an ordinary one for
      // a striker.
      expect(
        PlayerOfYear.individual(line, PositionCategory.goalkeeper),
        greaterThan(PlayerOfYear.individual(line, PositionCategory.forward)),
      );
    });

    test('an elite keeper outvotes a striker with an ordinary year', () {
      final w = _World();
      final games = _qualifiers(w, 1);
      for (final f in games) {
        w
          ..played(f, 1, 1, rating: 7.4, cleanSheet: true)
          ..played(f, 2, 1, rating: 6.9, goals: f.isEven ? 1 : 0);
      }
      final y = w.build();
      final ranked = PlayerOfYear.rank(y, {
        1: _p(PlayerPosition.gk),
        2: _p(PlayerPosition.st),
      });
      expect(ranked.first.playerId, 1);
    });

    test('the ceiling is never below any position\'s score', () {
      final w = _World();
      for (final f in _qualifiers(w, 1)) {
        w.played(f, 1, 1, rating: 7.3, goals: 1, cleanSheet: true);
      }
      final y = w.build();
      final l = y.lines[1]!;
      for (final c in PositionCategory.values) {
        expect(
          PlayerOfYear.ceiling(l, y.trophies),
          greaterThanOrEqualTo(PlayerOfYear.individual(l, c)),
        );
      }
    });
  });

  group('the vote', () {
    test('below the appearance floor you are not in the running', () {
      // Five men reach six games, so the floor stays at six and the man with
      // five brilliant ones is out.
      final w = _World();
      final games = _qualifiers(w, 1);
      for (final f in games) {
        for (var p = 10; p < 15; p++) {
          w.played(f, p, 1);
        }
      }
      for (final f in games.take(5)) {
        w.played(f, 1, 1, rating: 9.5, goals: 3);
      }
      final ranked = PlayerOfYear.rank(w.build(), {
        1: _p(PlayerPosition.st),
        for (var p = 10; p < 15; p++) p: _p(PlayerPosition.cm),
      });
      expect(ranked.map((e) => e.playerId), isNot(contains(1)));
    });

    test('a thin year lowers the floor, never below three', () {
      final w = _World();
      final games = _qualifiers(w, 1);
      // Nobody reaches six; four men play four games, one plays two.
      for (final f in games.take(4)) {
        for (var p = 1; p <= 4; p++) {
          w.played(f, p, 1, rating: 7 + p / 10);
        }
      }
      for (final f in games.take(2)) {
        w.played(f, 9, 1, rating: 9);
      }
      final y = w.build();
      // Five candidates are wanted: 4 games gives four, 3 games still four,
      // so the floor stops at three.
      expect(PlayerOfYear.floorFor(y.lines.values, need: 5), 3);
      final ranked = PlayerOfYear.rank(y, {
        for (final p in [1, 2, 3, 4, 9]) p: _p(PlayerPosition.cm),
      });
      expect(ranked.map((e) => e.playerId), [4, 3, 2, 1]);
      // With five men at four games, the floor is four.
      for (final f in games.take(4)) {
        w.played(f, 5, 1);
      }
      expect(PlayerOfYear.floorFor(w.build().lines.values, need: 5), 4);
      // A full year keeps six.
      expect(
        PlayerOfYear.floorFor(
          [for (var i = 0; i < 5; i++) YearLine(i, 1)..apps = 6],
          need: 5,
        ),
        6,
      );
    });

    test('the young award needs only three', () {
      expect(
        PlayerOfYear.floorFor(
          [
            for (var i = 0; i < 3; i++) YearLine(i, 1)..apps = 6,
            YearLine(9, 1)..apps = 4,
          ],
          need: PlayerOfYear.youngField,
        ),
        6,
      );
    });

    test('big matches count more than friendlies', () {
      final w = _World();
      for (var i = 0; i < 6; i++) {
        w
          ..played(w.match(1, 99), 1, 1, rating: 7.5)
          ..played(
            w.match(2, 99, kind: CompetitionKind.friendly, round: 'FRIENDLY'),
            2,
            2,
            rating: 7.5,
          );
      }
      final ranked = PlayerOfYear.rank(w.build(), {
        1: _p(PlayerPosition.st),
        2: _p(PlayerPosition.st),
      });
      expect(ranked.first.playerId, 1);
    });

    test('ties break on the player id, whatever the order', () {
      final w = _World();
      for (final f in _qualifiers(w, 1)) {
        w
          ..played(f, 8, 1, rating: 7.5)
          ..played(f, 5, 1, rating: 7.5);
      }
      final y = w.build();
      final a = PlayerOfYear.rank(y, {
        8: _p(PlayerPosition.st),
        5: _p(PlayerPosition.st),
      });
      final b = PlayerOfYear.rank(y, {
        5: _p(PlayerPosition.st),
        8: _p(PlayerPosition.st),
      });
      expect(a.map((e) => e.playerId), [5, 8]);
      expect(b.map((e) => e.playerId), [5, 8]);
    });

    test('a World Champion beats an equal year that won nothing', () {
      final w = _World();
      final ko = _worldChampionship(w);
      for (final f in _qualifiers(w, 1)) {
        w.played(f, 1, 1, rating: 7.4, goals: 1);
      }
      for (final f in _qualifiers(w, 5)) {
        w.played(f, 5, 5, rating: 7.4, goals: 1);
      }
      w
        ..played(ko[0], 1, 1, rating: 7.4)
        ..played(ko[2], 1, 1, rating: 7.4);
      final ranked = PlayerOfYear.rank(w.build(), {
        1: _p(PlayerPosition.st),
        5: _p(PlayerPosition.st),
      });
      expect(ranked.first.playerId, 1);
      expect(ranked.first.team, greaterThan(0));
      expect(ranked.last.team, 0);
    });

    test('the Golden Ball goes to the tournament\'s best and counts', () {
      final w = _World();
      final ko = _worldChampionship(w);
      for (final f in [ko[0], ko[2]]) {
        w
          ..played(f, 1, 1, rating: 8.6, goals: 2, motm: true)
          ..played(f, 2, 1, rating: 6.8);
      }
      final y = w.build();
      final honours = PlayerOfYear.tournamentHonours(y, {
        1: _p(PlayerPosition.st),
        2: _p(PlayerPosition.cb),
      });
      final kinds = honours[1]!.map((h) => h.kind);
      expect(kinds, contains(AwardKind.goldenBall));
      expect(kinds, contains(AwardKind.goldenBoot));
      expect(honours[2]!.map((h) => h.kind), [AwardKind.teamOfTournament]);
      expect(
        PlayerOfYear.honours(honours[1]!),
        greaterThan(PlayerOfYear.honours(honours[2]!)),
      );
    });

    test('the Golden Glove goes to a keeper', () {
      final w = _World();
      final ko = _worldChampionship(w);
      for (final f in [ko[0], ko[2]]) {
        w
          ..played(f, 1, 1, rating: 7.2, cleanSheet: true)
          ..played(f, 2, 1, rating: 8.0, goals: 1);
      }
      final honours = PlayerOfYear.tournamentHonours(w.build(), {
        1: _p(PlayerPosition.gk),
        2: _p(PlayerPosition.st),
      });
      expect(honours[1]!.map((h) => h.kind), contains(AwardKind.goldenGlove));
      expect(
        honours[2]!.map((h) => h.kind),
        isNot(contains(AwardKind.goldenGlove)),
      );
    });

    test('the young award only sees men of twenty or under', () {
      final w = _World();
      for (final f in _qualifiers(w, 1)) {
        w
          ..played(f, 1, 1, rating: 8.0, goals: 1)
          ..played(f, 2, 1, rating: 7.0);
      }
      final young = PlayerOfYear.rank(
        w.build(),
        {
          1: _p(PlayerPosition.st, age: 27),
          2: _p(PlayerPosition.st, age: 19),
        },
        eligible: PlayerOfYear.young,
      );
      expect(young.map((e) => e.playerId), [2]);
    });
  });

  group('the vote body', () {
    PotyPlace place(int rank, {bool own = false}) => (
      rank: rank,
      playerId: 100 + rank,
      nationId: 7,
      own: own,
      name: 'Odd|Name $rank',
      nationCode: 'cze',
      nationName: 'Czechia',
      age: 24,
      overall: 81,
      position: PlayerPosition.gk,
      apps: 11,
      goals: 0,
      assists: 1,
      cleanSheets: 6,
      meanRating: 7.31,
      motms: 2,
      score: 66.4,
    );

    test('round trips, places in order', () {
      final vote = (
        best: [place(2), place(1, own: true), place(3)],
        young: [place(1)],
      );
      final back = decodePotyVote(encodePotyVote(vote))!;
      expect(back.best.map((p) => p.rank), [1, 2, 3]);
      expect(back.best.first.own, isTrue);
      expect(back.best.first.position, PlayerPosition.gk);
      expect(back.best.first.cleanSheets, 6);
      expect(back.best.first.name, 'Odd Name 1');
      expect(back.young.single.rank, 1);
    });

    test('an old two-card body still opens, and is not a vote', () {
      final old = encodePotyReport([
        (
          young: false,
          name: 'A',
          nationCode: 'cze',
          nationName: 'Czechia',
          age: 25,
          overall: 80,
          apps: 9,
          goals: 4,
          assists: 1,
          meanRating: 7.2,
          motms: 1,
        ),
      ]);
      expect(decodePotyReport(old), hasLength(1));
      expect(decodePotyVote(old), isNull);
      expect(
        decodePotyReport(encodePotyVote((best: [place(1)], young: []))),
        isNull,
      );
    });

    test('the winners reduce to the popup cards, the young one only if he '
        'is somebody else', () {
      final same = potyWinnerRows((best: [place(1)], young: [place(1)]));
      expect(same, hasLength(1));
      final other = potyWinnerRows((
        best: [place(1)],
        young: [place(2)],
      ));
      expect(other.length, 2);
      expect(other.last.young, isTrue);
    });
  });
}
