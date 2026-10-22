import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/match/card_status.dart';
import 'package:fnm/domain/services/match/match_engine.dart';

/// Who is carrying a card at a given minute, read straight off the events —
/// the one answer the pitch and the substitution lists both draw.
void main() {
  MatchEvent card(
    int minute,
    int playerId, {
    bool red = false,
    bool secondYellow = false,
    int nation = 1,
  }) => MatchEvent(
    minute: minute,
    type: red ? MatchEventType.redCard : MatchEventType.yellowCard,
    teamNationId: nation,
    playerId: playerId,
    playerName: 'P$playerId',
    secondYellow: secondYellow,
  );

  test('a booking, a second booking and a straight red', () {
    final events = [
      card(12, 1),
      card(30, 2),
      card(70, 2, red: true, secondYellow: true),
      card(55, 3, red: true),
    ];
    expect(cardStatusFor(events, nationId: 1, upToMinute: 90), {
      1: MatchCard.yellow,
      2: MatchCard.secondYellow,
      3: MatchCard.red,
    });
  });

  test('nothing the clock has not reached yet', () {
    final events = [card(12, 1), card(30, 2), card(70, 2, red: true)];
    expect(cardStatusFor(events, nationId: 1, upToMinute: 40), {
      1: MatchCard.yellow,
      2: MatchCard.yellow,
    });
  });

  test("the other side's cards are not ours", () {
    expect(
      cardStatusFor([card(12, 1, nation: 2)], nationId: 1, upToMinute: 90),
      isEmpty,
    );
  });

  test('a red outranks a booking whatever order the events come in', () {
    final events = [card(70, 2, red: true, secondYellow: true), card(30, 2)];
    expect(cardStatusFor(events, nationId: 1, upToMinute: 90), {
      2: MatchCard.secondYellow,
    });
  });
}
