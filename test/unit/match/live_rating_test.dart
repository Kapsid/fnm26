import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/match/live_rating.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_moments.dart';

import '../../helpers/fixtures.dart';

/// The live line-up ratings: built from what the clock has reached and
/// nothing else, and at the whistle exactly the engine's stored marks.

const _home = 1;
const _away = 2;

RatedPlayer _p(int id, int nation, PositionCategory c) =>
    (id: id, nationId: nation, category: c);

final _players = [
  _p(10, _home, PositionCategory.forward),
  _p(11, _home, PositionCategory.midfielder),
  _p(12, _home, PositionCategory.defender),
  _p(13, _home, PositionCategory.goalkeeper),
  _p(14, _home, PositionCategory.forward), // home sub, on at 70'
  _p(20, _away, PositionCategory.forward),
  _p(21, _away, PositionCategory.defender),
  _p(23, _away, PositionCategory.goalkeeper),
];
const _starters = {10, 11, 12, 13, 20, 21, 23};

MatchEvent _goal(int minute, int nation, int scorer, {int? assist}) =>
    MatchEvent(
      minute: minute,
      type: MatchEventType.goal,
      teamNationId: nation,
      playerId: scorer,
      playerName: 'P$scorer',
      assistPlayerId: assist,
    );

MatchEvent _card(int minute, int nation, int id, MatchEventType type) =>
    MatchEvent(
      minute: minute,
      type: type,
      teamNationId: nation,
      playerId: id,
      playerName: 'P$id',
    );

ShotMoment _penMiss(int minute, int nation, int shooter, int keeper) =>
    ShotMoment(
      minute: minute,
      stoppage: 0,
      seq: 0,
      teamNationId: nation,
      shooterId: shooter,
      keeperId: keeper,
      zone: PitchZone.values.first,
      xg: 0.76,
      outcome: ShotOutcome.saved,
      origin: ShotOrigin.penalty,
    );

/// The first half of a match: 1-0 home at 30'.
final _early = <MatchEvent>[_goal(30, _home, 10, assist: 11)];

/// What happens after 60': the away side turn it round, cards, a sub, a
/// saved penalty, a stoppage-time goal.
final _late = <MatchEvent>[
  _goal(62, _away, 20),
  _card(65, _home, 12, MatchEventType.yellowCard),
  const MatchEvent(
    minute: 70,
    type: MatchEventType.substitution,
    teamNationId: _home,
    playerId: 14,
    playerName: 'P14',
    secondaryPlayerId: 10,
    secondaryName: 'P10',
  ),
  _goal(81, _away, 20),
  _card(85, _home, 11, MatchEventType.redCard),
  const MatchEvent(
    minute: 90,
    stoppage: 3,
    type: MatchEventType.goal,
    teamNationId: _away,
    playerId: 21,
    playerName: 'P21',
  ),
];
final _lateShots = <MatchMoment>[_penMiss(75, _home, 10, 23)];

Map<int, double> _at(
  int minute, {
  required List<MatchEvent> events,
  List<MatchMoment> moments = const [],
  int added = 0,
}) => LiveRatings.asOf(
  players: _players,
  starterIds: _starters,
  events: events,
  moments: moments,
  homeNationId: _home,
  minute: minute,
  added: added,
);

void main() {
  group('no look-ahead', () {
    test('a mark at minute m ignores every event after m', () {
      for (var m = 0; m <= 60; m++) {
        final withoutFuture = _at(m, events: _early);
        final withFuture = _at(
          m,
          events: [..._early, ..._late],
          moments: _lateShots,
        );
        expect(withFuture, withoutFuture, reason: 'minute $m');
      }
    });

    test('two matches identical to 60\' read the same to 60\', however '
        'they end', () {
      final collapse = [
        ..._early,
        for (var i = 0; i < 4; i++) _goal(61 + i * 5, _away, 20),
      ];
      final rout = [
        ..._early,
        for (var i = 0; i < 4; i++) _goal(61 + i * 5, _home, 10, assist: 11),
      ];
      for (var m = 0; m <= 60; m++) {
        expect(
          _at(m, events: collapse),
          _at(m, events: rout),
          reason: '$m',
        );
      }
      // ...and part ways only once the clock reaches the first difference.
      expect(_at(61, events: collapse), isNot(_at(61, events: rout)));
    });

    test('a stoppage-time event waits for its own added minute', () {
      final all = [..._early, ..._late];
      final before = _at(90, events: all, added: 2);
      final after = _at(90, events: all, added: 3);
      expect(before[21], isNot(after[21]));
      expect(
        before,
        _at(90, events: all.where((e) => e.stoppage < 3).toList(), added: 2),
      );
    });

    test('a missed penalty counts only once its minute has passed', () {
      final all = [..._early, ..._late];
      final during = _at(75, events: all, moments: _lateShots);
      final after = _at(76, events: all, moments: _lateShots);
      final noShots = _at(76, events: all);
      expect(during[10], _at(75, events: all)[10]);
      expect(after[10]!, lessThan(noShots[10]!));
      expect(after[23]!, greaterThan(noShots[23]!));
    });

    test('a substitute has no mark until he comes on', () {
      final all = [..._early, ..._late];
      expect(_at(69, events: all).containsKey(14), isFalse);
      expect(_at(70, events: all)[14], isNotNull);
    });

    test('a clean sheet is earned across the ninety, never all at once', () {
      final at0 = _at(0, events: const []);
      final at45 = _at(45, events: const []);
      final at90 = _at(90, events: const []);
      // A goalkeeper at 0-0: base 6.5 plus a share of the 0.5 bonus.
      expect(at0[13], 6.5);
      expect(at45[13], 6.8); // 6.75 rounds to one decimal
      expect(at90[13], 7.0);
      // A forward has no clean-sheet bonus at all.
      expect(at45[10], 6.5);
      // Extra time gives no hint at 60': the share is out of ninety.
      expect(LiveRatings.cleanSheetShareAt(60), closeTo(60 / 90, 1e-9));
      expect(LiveRatings.cleanSheetShareAt(105), 1.0);
    });

    test('starts from a neutral mark at kick-off', () {
      final kickOff = _at(0, events: [..._early, ..._late]);
      for (final id in _starters) {
        expect(kickOff[id], 6.5, reason: 'player $id');
      }
    });
  });

  group('the whistle', () {
    const engine = MatchEngine();

    List<Player> bench(int nation) => [
      for (var i = 0; i < 5; i++)
        player(
          id: nation * 100 + 50 + i,
          nationId: nation,
          position: [
            PlayerPosition.st,
            PlayerPosition.cm,
            PlayerPosition.cb,
            PlayerPosition.lw,
            PlayerPosition.rb,
          ][i],
        ),
    ];

    test('the live mark at full time IS the stored mark, for every player '
        'of every match', () {
      var matches = 0;
      var withExtraTime = 0;
      for (var seed = 1; seed <= 60; seed++) {
        final home = ratedTeam(_home, 60 + seed % 25);
        final away = ratedTeam(_away, 70 - seed % 20);
        final homeBench = bench(_home);
        final awayBench = bench(_away);
        final r = engine.play(
          home: home,
          away: away,
          rng: SeededRng.forFixture(seed, 7),
          extraTimeIfLevel: seed.isEven,
          subs: [
            Substitution(
              teamNationId: _home,
              minute: 55 + seed % 20,
              offId: home.xi[10].id,
              on: homeBench[0],
            ),
            Substitution(
              teamNationId: _away,
              minute: 60 + seed % 15,
              offId: away.xi[5].id,
              on: awayBench[1],
            ),
          ],
        );
        if (r.extraTime != null) withExtraTime++;
        final everyone = [...home.xi, ...away.xi, ...homeBench, ...awayBench];
        final live = LiveRatings.asOf(
          players: [
            for (final p in everyone)
              (id: p.id, nationId: p.nationId, category: p.category),
          ],
          starterIds: {
            for (final p in [...home.xi, ...away.xi]) p.id,
          },
          events: r.events,
          moments: r.moments,
          homeNationId: _home,
          minute: r.extraTime == null ? 90 : 120,
          added: r.stoppage,
          fullTime: true,
        );
        expect(
          live,
          {for (final x in r.ratings) x.playerId: x.rating},
          reason: 'seed $seed',
        );
        matches++;
      }
      expect(matches, 60);
      expect(withExtraTime, greaterThan(0));
    });

    test('a real match never moves a mark ahead of its events', () {
      // Every minute of a real match, the whole result handed in, reads the
      // same as the match cut off at that minute.
      final home = ratedTeam(_home, 72);
      final away = ratedTeam(_away, 68);
      final r = engine.play(
        home: home,
        away: away,
        rng: SeededRng.forFixture(42, 3),
      );
      final players = [
        for (final p in [...home.xi, ...away.xi])
          (id: p.id, nationId: p.nationId, category: p.category),
      ];
      final starters = {for (final p in players) p.id};
      for (var m = 0; m <= 90; m++) {
        Map<int, double> at(List<MatchEvent> ev, List<MatchMoment> mo) =>
            LiveRatings.asOf(
              players: players,
              starterIds: starters,
              events: ev,
              moments: mo,
              homeNationId: _home,
              minute: m,
            );
        final cut = at(
          [
            for (final e in r.events)
              if (e.minute <= m && e.stoppage == 0) e,
          ],
          [
            for (final s in r.moments)
              if (s.minute < m) s,
          ],
        );
        expect(at(r.events, r.moments), cut, reason: 'minute $m');
      }
    });
  });
}
