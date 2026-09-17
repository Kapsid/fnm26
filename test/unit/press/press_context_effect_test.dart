import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/press/expectation.dart';
import 'package:fnm/domain/services/press/press.dart';

/// A press answer used to be worth the same whatever it answered.
///
/// Backing the players was six morale and minus three board whether they had
/// just held the world champions or just been beaten by a minnow — the same
/// blindness the feed had, in the other half of the game.
void main() {
  PressEffect after(
    PressTone tone, {
    ResultStanding? standing,
    int morale = 50,
    int board = 50,
  }) => Press.effectInContext(
    tone,
    standing: standing,
    squadMorale: morale,
    boardMood: board,
  );

  group('the result changes what an answer is worth', () {
    test(
      'defending a disgrace costs the board more than defending bad luck',
      () {
        final afterShame = after(
          PressTone.backThePlayers,
          standing: ResultStanding.humiliating,
        );
        final afterCredit = after(
          PressTone.backThePlayers,
          standing: ResultStanding.creditable,
        );
        expect(
          afterShame.board,
          lessThan(afterCredit.board),
          reason: 'everyone can hear that the first one is a defence',
        );
      },
    );

    test('and earns the dressing room less, too', () {
      expect(
        after(
          PressTone.backThePlayers,
          standing: ResultStanding.humiliating,
        ).morale,
        lessThan(
          after(
            PressTone.backThePlayers,
            standing: ResultStanding.heroic,
          ).morale,
        ),
      );
    });

    test('with no result in view it behaves as it always did', () {
      expect(
        after(PressTone.backThePlayers),
        Press.effectOf(PressTone.backThePlayers),
      );
    });
  });

  group('the room changes it too', () {
    test('praise is worth more to a squad on the floor', () {
      expect(
        after(PressTone.backThePlayers, morale: 10).morale,
        greaterThan(after(PressTone.backThePlayers, morale: 90).morale),
      );
    });

    test('criticism bites a fragile dressing room harder', () {
      final fragile = after(PressTone.demandMore, morale: 10).morale;
      final confident = after(PressTone.demandMore, morale: 90).morale;
      expect(fragile, lessThan(confident));
      expect(fragile, isNegative);
    });

    test('an unhappy board takes more convincing', () {
      expect(
        after(PressTone.raiseTheBar, board: 10).board,
        greaterThan(after(PressTone.raiseTheBar, board: 90).board),
      );
    });
  });

  group('the guarantees that were true before are still true', () {
    test('saying nothing still moves nothing, whatever the situation', () {
      for (final s in [null, ...ResultStanding.values]) {
        for (final m in [0, 50, 100]) {
          expect(
            after(PressTone.playItDown, standing: s, morale: m),
            (morale: 0, board: 0),
            reason: 'the honest way out must stay free',
          );
        }
      }
    });

    test('no answer pleases both the squad and the board', () {
      for (final tone in PressTone.values) {
        for (final s in ResultStanding.values) {
          final e = after(tone, standing: s);
          expect(
            e.morale > 0 && e.board > 0,
            isFalse,
            reason: '${tone.name} after ${s.name} is a free lunch',
          );
        }
      }
    });

    test('nothing said in a conference runs away with the save', () {
      // The arrow bands are written against a bounded effect.
      for (final tone in PressTone.values) {
        for (final s in ResultStanding.values) {
          for (final m in [0, 100]) {
            for (final b in [0, 100]) {
              final e = after(tone, standing: s, morale: m, board: b);
              expect(e.morale.abs(), lessThanOrEqualTo(9));
              expect(e.board.abs(), lessThanOrEqualTo(9));
            }
          }
        }
      }
    });

    test('a follow-up is still worth half of a stance', () {
      const opening = (
        key: 'k',
        reporter: (name: 'A', outlet: 'B', angle: PressAngle.tabloid),
        topic: PressTopic.heavyDefeat,
        probe: null,
        subjectNationId: null,
        options: <PressTone>[],
        halfWeight: false,
      );
      const followUp = (
        key: 'k2',
        reporter: (name: 'A', outlet: 'B', angle: PressAngle.tabloid),
        topic: PressTopic.heavyDefeat,
        probe: PressProbe.accountability,
        subjectNationId: null,
        options: <PressTone>[],
        halfWeight: true,
      );
      final full = Press.effectOfExchange(opening, PressTone.demandMore);
      final half = Press.effectOfExchange(followUp, PressTone.demandMore);
      expect(half.morale, full.morale ~/ 2);
      expect(half.board, full.board ~/ 2);
    });
  });
}
