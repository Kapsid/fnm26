import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/nation/nation_facts.dart';

const _me = 1;
const _you = 2;

var _id = 0;

/// A played match of [_me]'s: [gf]-[ga] from its side.
Fixture _match(
  int gf,
  int ga, {
  int opp = 9,
  bool home = true,
  int year = 2030,
  int month = 6,
  int? pf,
  int? pa,
}) {
  _id++;
  return Fixture(
    id: _id,
    careerId: 1,
    competitionId: 1,
    matchday: 1,
    date: DateTime(year, month, _id % 28 + 1),
    homeNationId: home ? _me : opp,
    awayNationId: home ? opp : _me,
    homeScore: home ? gf : ga,
    awayScore: home ? ga : gf,
    homePenalties: pf == null ? null : (home ? pf : pa),
    awayPenalties: pf == null ? null : (home ? pa : pf),
    played: true,
  );
}

List<NationFact> _derive({
  List<Fixture> fixtures = const [],
  Set<int>? home,
  List<int> titles = const [2010],
  int? manager,
  ({String name, int goals})? scorer,
  List<({int year, int rank})> ranks = const [],
  int reached = 0,
  int playedFinals = 0,
  int limit = 10,
}) => NationFacts.derive(
  nationId: _me,
  fixtures: fixtures,
  homeFixtureIds:
      home ??
      {
        for (final f in fixtures)
          if (f.homeNationId == _me) f.id,
      },
  titleYears: titles,
  currentYear: 2034,
  rankHistory: ranks,
  managerNationId: manager,
  recordScorer: scorer,
  worldFinalsReached: reached,
  worldFinalsPlayed: playedFinals,
  limit: limit,
);

NationFact? _of(List<NationFact> facts, NationFactKind kind) =>
    facts.where((f) => f.kind == kind).firstOrNull;

void main() {
  group('biggest win', () {
    test('the widest margin, more goals breaking a tie', () {
      final facts = _derive(
        fixtures: [
          _match(3, 0, opp: 5),
          _match(5, 2, opp: 6, year: 2031),
          _match(1, 0),
        ],
      );
      final win = _of(facts, NationFactKind.biggestWin)!;
      expect(win.headline, '5-2');
      expect(win.opponentId, 6);
      expect(win.year, 2031);
    });

    test('read from either side, at the shown score', () {
      // Won away 4-1; a shootout's stored extra goal never counts.
      final facts = _derive(
        fixtures: [
          _match(4, 1, home: false, opp: 7),
          _match(3, 2, pf: 5, pa: 4),
        ],
      );
      final win = _of(facts, NationFactKind.biggestWin)!;
      expect(win.headline, '4-1');
      expect(win.opponentId, 7);
    });

    test('a one-goal win is not a fact', () {
      final facts = _derive(fixtures: [_match(1, 0), _match(2, 1)]);
      expect(_of(facts, NationFactKind.biggestWin), isNull);
    });
  });

  group('home unbeaten run', () {
    test('counts back from the latest home game to the last defeat', () {
      final fixtures = [
        _match(0, 1, year: 2030),
        _match(2, 0, year: 2031),
        _match(1, 1, year: 2031, month: 9),
        _match(0, 3, home: false, year: 2032), // away: ignored
        _match(3, 0, year: 2033),
      ];
      final run = _of(_derive(fixtures: fixtures), NationFactKind.homeUnbeaten);
      expect(run!.headline, '3');
    });

    test('a finals it hosted counts as home', () {
      final hosted = _match(2, 0, home: false, year: 2033);
      final fixtures = [_match(1, 0), _match(1, 0, year: 2031), hosted];
      final facts = _derive(
        fixtures: fixtures,
        home: {fixtures[0].id, fixtures[1].id, hosted.id},
      );
      expect(_of(facts, NationFactKind.homeUnbeaten)!.headline, '3');
    });

    test('too short a run is left out', () {
      final facts = _derive(fixtures: [_match(1, 0), _match(0, 2)]);
      expect(_of(facts, NationFactKind.homeUnbeaten), isNull);
    });

    test('a shootout defeat ends it', () {
      final fixtures = [
        _match(1, 0, year: 2030),
        _match(1, 0, year: 2031),
        _match(1, 0, year: 2032),
        // 1-1, lost on penalties: stored 1-2.
        _match(1, 2, year: 2033, pf: 3, pa: 4),
      ];
      expect(
        _of(_derive(fixtures: fixtures), NationFactKind.homeUnbeaten),
        isNull,
      );
    });
  });

  group('titles', () {
    test('years since the last title', () {
      final drought = _of(
        _derive(titles: [1998, 2014]),
        NationFactKind.titleDrought,
      )!;
      expect(drought.headline, '20');
      expect(drought.year, 2014);
    });

    test('a title last year is no drought', () {
      final facts = _derive(titles: [2033]);
      expect(_of(facts, NationFactKind.titleDrought), isNull);
      expect(_of(facts, NationFactKind.noTitles), isNull);
    });

    test('never won one', () {
      final facts = _derive(titles: const []);
      expect(_of(facts, NationFactKind.noTitles)!.headline, '0');
      expect(_of(facts, NationFactKind.titleDrought), isNull);
    });
  });

  test('the record scorer, once he has a few', () {
    expect(
      _of(
        _derive(scorer: (name: 'A. Bek', goals: 41)),
        NationFactKind.recordScorer,
      ),
      isA<NationFact>()
          .having((f) => f.headline, 'headline', '41')
          .having((f) => f.name, 'name', 'A. Bek'),
    );
    expect(
      _of(
        _derive(scorer: (name: 'A. Bek', goals: 2)),
        NationFactKind.recordScorer,
      ),
      isNull,
    );
    expect(_of(_derive(), NationFactKind.recordScorer), isNull);
  });

  group('against you', () {
    test('W-D-L from the manager side, shootouts by their winner', () {
      final fixtures = [
        _match(0, 2, opp: _you), // you won
        _match(1, 1, opp: _you, home: false), // draw
        _match(2, 1, opp: _you, pf: 4, pa: 2), // they won on penalties
        _match(3, 0), // someone else
      ];
      final fact = _of(
        _derive(fixtures: fixtures, manager: _you),
        NationFactKind.againstYou,
      )!;
      expect(fact.headline, '1-1-1');
    });

    test('never on the own page, and not before a meeting', () {
      final fixtures = [_match(0, 2, opp: _you)];
      expect(
        _of(
          _derive(fixtures: fixtures, manager: _me),
          NationFactKind.againstYou,
        ),
        isNull,
      );
      expect(
        _of(_derive(fixtures: fixtures), NationFactKind.againstYou),
        isNull,
      );
      expect(
        _of(_derive(manager: _you), NationFactKind.againstYou),
        isNull,
      );
    });
  });

  test('the biggest climb in one cycle', () {
    final climb = _of(
      _derive(
        ranks: const [
          (year: 2026, rank: 40),
          (year: 2030, rank: 22),
          (year: 2034, rank: 30),
        ],
      ),
      NationFactKind.rankClimb,
    )!;
    expect(climb.headline, '+18');
    expect(climb.year, 2030);
    expect(climb.rank, 22);
    expect(
      _of(
        _derive(ranks: const [(year: 2026, rank: 10), (year: 2030, rank: 9)]),
        NationFactKind.rankClimb,
      ),
      isNull,
    );
  });

  test('world finals only once an edition has been played', () {
    expect(_of(_derive(), NationFactKind.worldFinals), isNull);
    final none = _of(_derive(playedFinals: 2), NationFactKind.worldFinals)!;
    expect(none.headline, '0');
    expect(none.year, 2026);
    expect(
      _of(
        _derive(playedFinals: 2, reached: 2),
        NationFactKind.worldFinals,
      )!.headline,
      '2',
    );
  });

  test('ranked by interest, four at most, record against you first', () {
    final fixtures = [
      _match(6, 0, year: 2030),
      _match(1, 0, opp: _you, year: 2031),
      _match(2, 0, year: 2032),
      _match(1, 0, year: 2033),
    ];
    final facts = NationFacts.derive(
      nationId: _me,
      fixtures: fixtures,
      homeFixtureIds: {for (final f in fixtures) f.id},
      titleYears: const [2002],
      currentYear: 2034,
      rankHistory: const [(year: 2026, rank: 30), (year: 2030, rank: 20)],
      managerNationId: _you,
      recordScorer: (name: 'X', goals: 20),
      worldFinalsPlayed: 1,
      worldFinalsReached: 1,
    );
    expect(facts, hasLength(4));
    expect(facts.first.kind, NationFactKind.againstYou);
    for (var i = 1; i < facts.length; i++) {
      expect(facts[i - 1].score, greaterThanOrEqualTo(facts[i].score));
    }
    expect(facts.map((f) => f.kind).toSet(), hasLength(4));
  });

  test('no history: only what can be said without one', () {
    final facts = NationFacts.derive(
      nationId: _me,
      fixtures: const [],
      homeFixtureIds: const {},
      titleYears: const [],
      currentYear: 2026,
      rankHistory: const [],
    );
    expect(facts.map((f) => f.kind), [NationFactKind.noTitles]);
  });

  test('unplayed fixtures never count', () {
    final open = Fixture(
      id: 999,
      careerId: 1,
      competitionId: 1,
      matchday: 1,
      date: DateTime(2034),
      homeNationId: _me,
      awayNationId: _you,
    );
    final facts = _derive(fixtures: [open], manager: _you);
    expect(_of(facts, NationFactKind.againstYou), isNull);
    expect(_of(facts, NationFactKind.biggestWin), isNull);
  });
}
