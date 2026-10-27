import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/achievements/board_satisfaction.dart';

typedef _R = ({MatchOutcome outcome, bool underdog, bool humiliation});

_R _r(MatchOutcome o, {bool underdog = false, bool humiliation = false}) =>
    (outcome: o, underdog: underdog, humiliation: humiliation);

int _sticky(List<_R> rs, {double minnow = 0}) =>
    BoardSatisfaction.stickyFormPoints(rs, minnow: minnow);

/// The plain last-ten window over [rs] (oldest first), as the board used to
/// read it.
int _window(List<_R> rs, {double minnow = 0}) {
  final w = rs.reversed.take(BoardSatisfaction.formWindow).toList();
  return BoardSatisfaction.formPoints(
    [for (final r in w) r.outcome],
    asUnderdog: [for (final r in w) r.underdog],
    minnow: minnow,
    humiliations: [for (final r in w) r.humiliation],
  );
}

/// b8 round 2: board confidence follows the result's sign. The last-ten form
/// window dropped its oldest result as each new one came in, so a narrow win
/// that pushed an old upset out of the window cost the board points
/// ("my win versus Sweden (6-2 at home) saw my job security go down 1%").
void main() {
  test('a narrow win that pushes an old upset win out never lowers it', () {
    final before = [
      _r(MatchOutcome.win, underdog: true), // +5, about to drop out
      for (var i = 0; i < 9; i++) _r(MatchOutcome.draw),
    ];
    final after = [...before, _r(MatchOutcome.win)]; // +2 in, +5 out
    expect(
      _window(after),
      lessThan(_window(before)),
      reason: 'the bare window falls',
    );
    expect(_sticky(after), greaterThanOrEqualTo(_sticky(before)));
  });

  test('a defeat that pushes an old heavy defeat out never raises it', () {
    final before = [
      _r(MatchOutcome.loss), // -5, about to drop out
      for (var i = 0; i < 9; i++) _r(MatchOutcome.draw),
    ];
    final after = [...before, _r(MatchOutcome.loss, underdog: true)]; // -1 in
    expect(_window(after), greaterThan(_window(before)));
    expect(_sticky(after), lessThanOrEqualTo(_sticky(before)));
  });

  test('a draw against a stronger side still ticks it up', () {
    final before = [
      _r(MatchOutcome.loss),
      _r(MatchOutcome.win),
      _r(MatchOutcome.draw),
    ];
    final after = [...before, _r(MatchOutcome.draw, underdog: true)];
    expect(_sticky(after), greaterThan(_sticky(before)));
  });

  test('every win never lowers it, every defeat never raises it', () {
    final rng = Random(20261027);
    for (var run = 0; run < 300; run++) {
      final minnow = run.isEven ? 0.0 : rng.nextDouble();
      final rs = <_R>[];
      var last = 0;
      for (var k = 0; k < 40; k++) {
        final o = MatchOutcome.values[rng.nextInt(3)];
        rs.add(
          _r(
            o,
            underdog: rng.nextInt(3) == 0,
            humiliation: rng.nextInt(8) == 0,
          ),
        );
        final now = _sticky(rs, minnow: minnow);
        if (o == MatchOutcome.win) expect(now, greaterThanOrEqualTo(last));
        if (o == MatchOutcome.loss) expect(now, lessThanOrEqualTo(last));
        if (o == MatchOutcome.draw) expect(now, _window(rs, minnow: minnow));
        last = now;
      }
    }
  });

  test('over a career it sits where the window did', () {
    // Seeded careers of 40 results at three strengths: the sticky term stays
    // inside the window's range and its average barely moves.
    final rng = Random(7);
    for (final pWin in [0.25, 0.45, 0.65]) {
      var sumWindow = 0;
      var sumSticky = 0;
      var n = 0;
      for (var run = 0; run < 200; run++) {
        final rs = <_R>[];
        for (var k = 0; k < 40; k++) {
          final x = rng.nextDouble();
          rs.add(
            _r(
              x < pWin
                  ? MatchOutcome.win
                  : x < pWin + 0.25
                  ? MatchOutcome.draw
                  : MatchOutcome.loss,
              underdog: rng.nextInt(4) == 0,
            ),
          );
          if (k >= BoardSatisfaction.formWindow) {
            sumWindow += _window(rs);
            sumSticky += _sticky(rs);
            n++;
          }
        }
      }
      final shift = (sumSticky - sumWindow) / n;
      // ignore: avoid_print, the level check is read off the run.
      print('pWin $pWin: window ${sumWindow / n}, sticky ${sumSticky / n}');
      expect(shift.abs(), lessThan(2.5));
    }
  });
}
