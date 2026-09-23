import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/player_absence.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/player/discipline.dart';

MatchEvent _event(MatchEventType type, {int player = 1, int nation = 10}) =>
    MatchEvent(
      minute: 42,
      type: type,
      teamNationId: nation,
      playerId: player,
      playerName: 'P$player',
    );

void main() {
  SeededRng rng() => SeededRng.forFixture(1, 1);

  test('a red card bans the player for one match', () {
    final after = Discipline.applyMatch(
      before: const {},
      events: [_event(MatchEventType.redCard)],
      nationId: 10,
      rng: rng(),
    );
    expect(after[1]!.banMatches, 1);
    expect(after[1]!.isAvailable, isFalse);
  });

  test('three yellows across matches earn a suspension', () {
    final first = Discipline.applyMatch(
      before: const {},
      events: [_event(MatchEventType.yellowCard)],
      nationId: 10,
      rng: rng(),
    );
    expect(first[1]!.yellows, 1);
    expect(first[1]!.banMatches, 0);

    final second = Discipline.applyMatch(
      before: first,
      events: [_event(MatchEventType.yellowCard)],
      nationId: 10,
      rng: rng(),
    );
    // Two is no longer enough — the threshold is three, so still no ban.
    expect(second[1]!.yellows, 2);
    expect(second[1]!.banMatches, 0);

    final third = Discipline.applyMatch(
      before: second,
      events: [_event(MatchEventType.yellowCard)],
      nationId: 10,
      rng: rng(),
    );
    expect(third[1]!.banMatches, 1);
    expect(third[1]!.yellows, 0);
  });

  test('an injury sidelines the player for one to four matches', () {
    final after = Discipline.applyMatch(
      before: const {},
      events: [_event(MatchEventType.injury)],
      nationId: 10,
      rng: rng(),
    );
    expect(after[1]!.injuryMatches, inInclusiveRange(1, 4));
  });

  test('serving a match counts down and clears when done', () {
    final before = {1: const PlayerAbsence(playerId: 1, banMatches: 1)};
    final after = Discipline.applyMatch(
      before: before,
      events: const [],
      nationId: 10,
      rng: rng(),
    );
    expect(after.containsKey(1), isFalse); // served and cleared
  });

  test("other nations' events are ignored", () {
    final after = Discipline.applyMatch(
      before: const {},
      events: [_event(MatchEventType.redCard, nation: 99)],
      nationId: 10,
      rng: rng(),
    );
    expect(after, isEmpty);
  });
}
