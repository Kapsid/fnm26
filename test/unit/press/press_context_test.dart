import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/press/press.dart';

/// The room used to ask everybody the same three questions and offer everybody
/// the same four answers — including "we are here to win this" to a side whose
/// board had asked only that it turn up. These are what stops that.
void main() {
  group('how long a conference runs', () {
    test('a triumph or an exit is a long afternoon', () {
      expect(Press.lengthFor(PressTopic.triumph), 4);
      expect(Press.lengthFor(PressTopic.elimination), 4);
    });

    test('a ranking milestone is a question and a thank-you', () {
      expect(Press.lengthFor(PressTopic.rankingPeak), 1);
      expect(Press.lengthFor(PressTopic.bigWin), lessThanOrEqualTo(2));
    });

    test('nothing runs past what the sheet reserves room for', () {
      for (final topic in PressTopic.values) {
        expect(Press.lengthFor(topic), inInclusiveRange(1, Press.maxConferenceLength));
      }
    });

    test('the lengths are not all the same, which was the whole complaint', () {
      final lengths = {for (final t in PressTopic.values) Press.lengthFor(t)};
      expect(lengths.length, greaterThan(1));
    });
  });

  group('what a manager can plausibly say', () {
    test('a minnow told to qualify is never offered "we will win it"', () {
      for (final topic in PressTopic.values) {
        final options = Press.optionsFor(
          topic,
          target: Press.qualifyTarget,
          worldRank: 62,
        );
        expect(
          options,
          isNot(contains(PressTone.raiseTheBar)),
          reason: '$topic offered the bar to a side asked only to be there',
        );
      }
    });

    test('a side ranked well but asked only to qualify still cannot', () {
      expect(
        Press.optionsFor(
          PressTopic.tournamentOpening,
          target: Press.qualifyTarget,
          worldRank: 3,
        ),
        isNot(contains(PressTone.raiseTheBar)),
      );
    });

    test('a contender told to win it can talk it up', () {
      expect(
        Press.optionsFor(
          PressTopic.tournamentOpening,
          target: 7,
          worldRank: 2,
        ),
        contains(PressTone.raiseTheBar),
      );
    });

    test('saying as little as possible is always available', () {
      for (final topic in PressTopic.values) {
        for (final target in [Press.qualifyTarget, 5, 7]) {
          for (final rank in [1, 40, 120, null]) {
            expect(
              Press.optionsFor(topic, target: target, worldRank: rank),
              contains(PressTone.playItDown),
              reason: '$topic / target $target / rank $rank',
            );
          }
        }
      }
    });

    test('nobody is ever left with nothing to say', () {
      for (final topic in PressTopic.values) {
        expect(
          Press.optionsFor(topic, target: Press.qualifyTarget, worldRank: 200),
          isNotEmpty,
        );
      }
    });
  });
}
