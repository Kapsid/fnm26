import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/match/background_match.dart';
import 'package:fnm/domain/services/match/match_engine.dart';

Player _p(int id, PlayerPosition pos, {int overall = 75}) => Player(
  id: id,
  nationId: 1,
  name: 'P$id',
  position: pos,
  age: 26,
  club: 'C',
  attributes: PlayerAttributes(
    physical: overall,
    technical: overall,
    stamina: overall,
  ),
);

List<Player> _xi(int base) => [
  _p(base + 1, PlayerPosition.gk),
  _p(base + 2, PlayerPosition.lb),
  _p(base + 3, PlayerPosition.cb),
  _p(base + 4, PlayerPosition.cb),
  _p(base + 5, PlayerPosition.rb),
  _p(base + 6, PlayerPosition.cm),
  _p(base + 7, PlayerPosition.cm),
  _p(base + 8, PlayerPosition.cm),
  _p(base + 9, PlayerPosition.lw),
  _p(base + 10, PlayerPosition.st),
  _p(base + 11, PlayerPosition.rw),
];

BackgroundDetail _detail({
  int seed = 7,
  int homeScore = 2,
  int awayScore = 1,
  bool competitive = true,
}) => BackgroundMatch.detail(
  homeXi: _xi(100),
  awayXi: _xi(200),
  homeNationId: 1,
  awayNationId: 2,
  homeScore: homeScore,
  awayScore: awayScore,
  homeStrength: 78,
  awayStrength: 72,
  goalsByPlayer: {
    for (var i = 0; i < homeScore; i++) 110: homeScore,
    for (var i = 0; i < awayScore; i++) 210: awayScore,
  },
  rng: SeededRng(seed),
  competitive: competitive,
);

void main() {
  test('a background match is fully described and internally consistent', () {
    final d = _detail();

    expect(d.lines, hasLength(22), reason: 'both XIs are marked');
    expect(d.homePossession, inInclusiveRange(28, 72));
    expect(d.homeShots, greaterThan(0));
    expect(d.awayShots, greaterThan(0));
    expect(d.homeXg, greaterThan(0));

    // The stronger side, which also won, sees more of the ball.
    expect(d.homePossession, greaterThan(50));

    for (final l in d.lines) {
      expect(l.rating, inInclusiveRange(3.0, 10.0));
      expect(l.yellows, lessThanOrEqualTo(1));
      expect(l.reds, lessThanOrEqualTo(1));
      // A player cannot be both booked and sent off in the same line.
      expect(l.yellows + l.reds, lessThanOrEqualTo(1));
    }

    // Exactly one man of the match, and it is the best mark on the pitch.
    final motm = d.lines.where((l) => l.motm).toList();
    expect(motm, hasLength(1));
    final best = d.lines.map((l) => l.rating).reduce((a, b) => a > b ? a : b);
    expect(motm.single.rating, best);

    // The clean-sheet flag follows the scoreline, not the player.
    expect(
      d.lines.where((l) => l.nationId == 1).every((l) => !l.cleanSheet),
      isTrue,
    );
    expect(
      d.lines.where((l) => l.nationId == 2).every((l) => !l.cleanSheet),
      isTrue,
    );
  });

  test('a clean sheet is flagged for the side that conceded nothing', () {
    final d = _detail(homeScore: 3, awayScore: 0);
    expect(
      d.lines.where((l) => l.nationId == 1).every((l) => l.cleanSheet),
      isTrue,
    );
    expect(
      d.lines.where((l) => l.nationId == 2).any((l) => l.cleanSheet),
      isFalse,
    );
  });

  test('goals are credited to the scorers the caller attributed', () {
    final d = _detail(homeScore: 2, awayScore: 1);
    final scorer = d.lines.firstWhere((l) => l.playerId == 110);
    expect(scorer.goals, 2);
    // An assist never goes to the scorer of that goal.
    expect(scorer.assists, lessThanOrEqualTo(1));
    final totalAssists = d.lines.fold<int>(0, (s, l) => s + l.assists);
    expect(totalAssists, lessThanOrEqualTo(3), reason: 'at most one per goal');
  });

  test('the same fixture always produces the same detail', () {
    final a = _detail();
    final b = _detail();
    expect(a.homeShots, b.homeShots);
    expect(a.homePossession, b.homePossession);
    expect(a.homeXg, b.homeXg);
    expect(a.events.length, b.events.length);
    expect(
      a.lines.map((l) => (l.playerId, l.rating, l.yellows, l.reds)).toList(),
      b.lines.map((l) => (l.playerId, l.rating, l.yellows, l.reds)).toList(),
    );
  });

  test('friendlies produce far fewer cards than competitive matches', () {
    var competitive = 0;
    var friendly = 0;
    for (var seed = 0; seed < 300; seed++) {
      competitive += _detail(
        seed: seed,
      ).events.where((e) => e.type != MatchEventType.injury).length;
      friendly += _detail(
        seed: seed,
        competitive: false,
      ).events.where((e) => e.type != MatchEventType.injury).length;
    }
    expect(competitive, greaterThan(0));
    expect(friendly, lessThan(competitive));
  });

  test(
    'cards and knocks land often enough to matter, rarely enough to be news',
    () {
      var yellows = 0;
      var reds = 0;
      var injuries = 0;
      const matches = 400;
      for (var seed = 0; seed < matches; seed++) {
        for (final e in _detail(seed: seed).events) {
          switch (e.type) {
            case MatchEventType.yellowCard:
              yellows++;
            case MatchEventType.redCard:
              reds++;
            case MatchEventType.injury:
              injuries++;
            case MatchEventType.goal:
            case MatchEventType.substitution:
              break;
          }
        }
      }
      // Roughly one-to-three bookings a game across both sides.
      expect(yellows / matches, inInclusiveRange(0.8, 3.5));
      // A sending-off is an event, not a routine.
      expect(reds / matches, lessThan(0.25));
      // A knock every few matches per side.
      expect(injuries / matches, inInclusiveRange(0.05, 0.8));
    },
  );
}
