import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/press/press.dart';

void main() {
  test('every question offers a way out that costs nothing', () {
    for (final topic in PressTopic.values) {
      final options = Press.optionsFor(topic);
      expect(
        options,
        contains(PressTone.playItDown),
        reason: '$topic must be answerable without taking a side',
      );
      expect(options.length, inInclusiveRange(3, 4));
      expect(options.toSet().length, options.length, reason: 'no duplicates');
    }
  });

  test('no answer pleases both the squad and the board', () {
    // The whole point of the mechanic: every stance costs something somewhere,
    // or it is not a decision.
    for (final tone in PressTone.values) {
      final e = Press.effectOf(tone);
      expect(
        e.morale > 0 && e.board > 0,
        isFalse,
        reason: '$tone would be a free win',
      );
    }
  });

  test('backing the players lifts them and irritates the board', () {
    final e = Press.effectOf(PressTone.backThePlayers);
    expect(e.morale, greaterThan(0));
    expect(e.board, lessThan(0));
  });

  test('demanding more is the mirror image', () {
    final e = Press.effectOf(PressTone.demandMore);
    expect(e.morale, lessThan(0));
    expect(e.board, greaterThan(0));
  });

  test('saying nothing moves nothing', () {
    expect(Press.effectOf(PressTone.playItDown), (morale: 0, board: 0));
  });

  test('a manager cannot talk their way to a title', () {
    // Twenty gushing answers must not be worth more than a couple of results.
    final total = Press.totalOf(
      List.filled(20, Press.effectOf(PressTone.backThePlayers)),
    );
    expect(total.morale, lessThanOrEqualTo(12));
    final boardTotal = Press.totalOf(
      List.filled(20, Press.effectOf(PressTone.raiseTheBar)),
    );
    expect(boardTotal.board, lessThanOrEqualTo(10));
  });

  test('the effects of a mixed cycle cancel out sensibly', () {
    final total = Press.totalOf([
      Press.effectOf(PressTone.backThePlayers),
      Press.effectOf(PressTone.demandMore),
    ]);
    expect(total.morale, 1); // +6 then -5
    expect(total.board, 1); // -3 then +4
  });

  test('the press stay quiet long enough to not be a chore', () {
    // A question can only follow another after a real gap, and goes stale
    // rather than queueing up.
    expect(Press.quietDays, greaterThanOrEqualTo(30));
    expect(Press.askWindowDays, greaterThanOrEqualTo(Press.quietDays));
  });
}
