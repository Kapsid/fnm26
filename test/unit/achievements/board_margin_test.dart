import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/achievements/board_satisfaction.dart';
import 'package:fnm/domain/services/press/public_mood.dart';

typedef _R = ({MatchOutcome outcome, double underdog, bool humiliation});

/// One match as the board provider reads it: (opponent's rank, scored,
/// conceded) for a side ranked [own].
typedef _G = (int, int, int);

List<_R> _results(int own, List<_G> games) => [
  for (final g in games)
    (
      outcome: g.$2 > g.$3
          ? MatchOutcome.win
          : g.$2 == g.$3
          ? MatchOutcome.draw
          : MatchOutcome.loss,
      underdog: BoardSatisfaction.underdogDegree(
        ownRank: own,
        opponentRank: g.$1,
      ),
      humiliation: BoardSatisfaction.isHumiliation(
        margin: g.$3 - g.$2,
        ownRank: own,
        opponentRank: g.$1,
      ),
    ),
];

List<double> _shares(int own, List<_G> games) => [
  for (final g in games)
    BoardSatisfaction.defeatShare(
      margin: g.$3 - g.$2,
      ownRank: own,
      opponentRank: g.$1,
    ),
];

int _form(int own, List<_G> games, {double minnow = 0}) =>
    BoardSatisfaction.stickyFormPoints(
      _results(own, games),
      minnow: minnow,
      defeatShares: _shares(own, games),
    );

/// The whole gauge as the provider builds it, with no brief or honours yet.
int _gauge(int own, List<_G> games, {double minnow = 0}) =>
    BoardSatisfaction.compute(
      recent: const [],
      form: _form(own, games, minnow: minnow),
      honours: const [],
      worldRank: own,
      minnow: minnow,
      publicMood: PublicMood.of([
        for (final g in games.reversed)
          (
            nationRank: own,
            opponentRank: g.$1,
            won: g.$2 > g.$3,
            drew: g.$2 == g.$3,
          ),
      ]),
    );

/// The board charges a defeat by its margin, and an old result fades out of
/// the form window rather than dropping out whole (a tester: "I'm San Marino
/// ... lost 2-3 at home to Armenia ... and my satisfaction dropped 11%. Is
/// there any way of scaling the satisfaction drop by the size of the
/// defeat?").
void main() {
  group('a defeat is charged by its margin', () {
    double share(int margin, {int own = 30, int opp = 30}) =>
        BoardSatisfaction.defeatShare(
          margin: margin,
          ownRank: own,
          opponentRank: opp,
        );

    test('one goal, two goals, three or more', () {
      expect(share(1), BoardSatisfaction.narrowDefeatShare);
      expect(share(2), BoardSatisfaction.twoGoalDefeatShare);
      expect(share(3), 1);
      expect(share(6), 1);
      expect(
        BoardSatisfaction.defeatShare(margin: 1),
        BoardSatisfaction.narrowDefeatShare,
        reason: 'unknown ranks are judged on the margin alone',
      );
    });

    test('a defeat by a weaker side is charged in full however narrow', () {
      expect(share(1, own: 30, opp: 60), 1);
      expect(share(2, own: 1, opp: 2), 1);
      expect(share(1, own: 60, opp: 30), BoardSatisfaction.narrowDefeatShare);
    });

    test('an equal side: 0-1 costs -3, 0-2 -4, 0-3 the full -5', () {
      int lossBy(int margin) => BoardSatisfaction.formPoints(
        const [MatchOutcome.loss],
        defeatShares: [share(margin)],
      );
      expect(lossBy(1), -3);
      expect(lossBy(2), -4);
      expect(lossBy(3), BoardSatisfaction.loss);
    });

    test('combined with the underdog degree: narrow defeats by a clearly '
        'better side cost very little', () {
      // Five narrow defeats as the clear underdog: -3 where they were -5.
      final five = List.filled(5, MatchOutcome.loss);
      expect(
        BoardSatisfaction.formPoints(
          five,
          asUnderdog: List.filled(5, 1),
          defeatShares: List.filled(5, BoardSatisfaction.narrowDefeatShare),
        ),
        -3,
      );
      expect(
        BoardSatisfaction.formPoints(five, asUnderdog: List.filled(5, 1)),
        -5,
      );
    });

    test('the minnow weights scale too; a humiliation keeps its full '
        'weight', () {
      expect(
        BoardSatisfaction.formPoints(
          List.filled(5, MatchOutcome.loss),
          minnow: 1,
          defeatShares: List.filled(5, BoardSatisfaction.narrowDefeatShare),
        ),
        -3,
        reason: 'five narrow defeats at minnowLoss -1 each',
      );
      expect(
        BoardSatisfaction.formPoints(
          const [MatchOutcome.loss],
          minnow: 1,
          humiliations: const [true],
          defeatShares: const [0.6],
        ),
        BoardSatisfaction.loss,
      );
    });

    test('wins and draws are never scaled', () {
      expect(
        BoardSatisfaction.formPoints(
          const [MatchOutcome.win, MatchOutcome.draw],
          asUnderdog: const [0, 1],
          defeatShares: const [0.6, 0.6],
        ),
        BoardSatisfaction.win + BoardSatisfaction.drawAsUnderdog,
      );
    });
  });

  group('ten straight defeats still sink even a top side', () {
    test('ten narrow defeats for the best side in the world', () {
      // Everyone is weaker than the 1st, so nothing is narrowed.
      final games = [for (var i = 0; i < 10; i++) (2 + i * 3, 0, 1)];
      final form = _form(1, games);
      expect(form, 10 * BoardSatisfaction.loss);
      expect(
        BoardSatisfaction.compute(
          recent: const [],
          form: form,
          honours: const [],
          worldRank: 1,
        ),
        lessThan(15),
      );
    });

    test('ten defeats after a full window of wins', () {
      final games = [
        for (var i = 0; i < 10; i++) (40, 2, 0),
        for (var i = 0; i < 10; i++) (40, 0, 3),
      ];
      expect(_form(3, games), 10 * BoardSatisfaction.loss);
    });
  });

  group('the window no longer drops a result whole', () {
    test("an old upset leaves a minnow's gauge a quarter at a time", () {
      // San Marino (209th) beat a side ranked 90th, then loses to giants
      // by three each time, which the board charges nothing for.
      final games = <_G>[(90, 1, 0)];
      var last = _form(209, games, minnow: 1);
      expect(last, BoardSatisfaction.minnowWinAsUnderdog);
      final steps = <int>[];
      for (var k = 0; k < 12; k++) {
        games.add((20, 0, 3));
        final now = _form(209, games, minnow: 1);
        steps.add(last - now);
        last = now;
      }
      // It used to fall 9 in one step when the win dropped out; now no
      // single defeat moves it by more than three...
      expect(steps.every((s) => s >= 0 && s <= 3), isTrue, reason: '$steps');
      // ...and the win has still gone in the end.
      expect(last, 0);
    });

    test('a full window of wins is worth a little less, a full window of '
        'defeats exactly what it was', () {
      expect(
        BoardSatisfaction.formPoints(List.filled(10, MatchOutcome.win)),
        17,
      );
      expect(
        BoardSatisfaction.formPoints(List.filled(10, MatchOutcome.loss)),
        10 * BoardSatisfaction.loss,
      );
    });
  });

  test("the tester's case: San Marino's 2-3 at home to Armenia after "
      'winning in Slovakia costs a few points, not eleven', () {
    // Cycles 2-3 as San Marino (209th, a full minnow): an old upset win ten
    // matches back, the usual defeats by giants and two draws, then 2-1 at
    // Slovakia (44th) and 2-3 at home to Armenia (105th).
    const own = 209;
    const before = <_G>[
      (90, 1, 0),
      (30, 0, 3),
      (50, 0, 2),
      (100, 1, 1),
      (20, 0, 4),
      (70, 1, 2),
      (15, 0, 1),
      (60, 0, 2),
      (40, 1, 1),
      (44, 2, 1),
    ];
    const after = [...before, (105, 2, 3)];
    // The defeat itself was always nearly free: Armenia is all but the clear
    // underdog's opponent.
    expect(
      BoardSatisfaction.underdogDegree(ownRank: own, opponentRank: 105),
      greaterThan(0.99),
    );
    // Before the fix the form term fell 22 -> 13 here (the upset leaving the
    // window) and the public mood's shift +3 -> +1: the gauge went 75 -> 64,
    // the tester's eleven. Now the form term falls 15 -> 12.
    expect(_form(own, before, minnow: 1), 15);
    expect(_form(own, after, minnow: 1), 12);
    expect(_gauge(own, before, minnow: 1), 68);
    expect(_gauge(own, after, minnow: 1), 63);
  });
}
