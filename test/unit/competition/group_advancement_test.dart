import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/competition/group_advancement.dart';

void main() {
  group('GroupAdvancement.forGroup', () {
    Advancement nationsCup({required bool lowest}) => GroupAdvancement.forGroup(
      kind: CompetitionKind.nationsLeague,
      confederation: Confederation.europe,
      groupCount: 4,
      continentalSize: 24,
      isLowestLeague: lowest,
    );

    test('the Nations Cup relegates each group bottom', () {
      final adv = nationsCup(lowest: false);
      expect(adv.direct, 1, reason: 'only the group winner goes up');
      expect(adv.contention, isNull);
      expect(adv.relegate, 1, reason: 'the bottom side drops a league');
    });

    test('the lowest league has nowhere to fall', () {
      expect(nationsCup(lowest: true).relegate, 0);
    });

    test('nothing is relegated outside the Nations Cup', () {
      for (final kind in [
        CompetitionKind.worldCupQualifying,
        CompetitionKind.continentalQualifying,
        CompetitionKind.worldCupFinals,
        CompetitionKind.continentalFinals,
        CompetitionKind.friendly,
        CompetitionKind.finalissima,
      ]) {
        final adv = GroupAdvancement.forGroup(
          kind: kind,
          confederation: Confederation.europe,
          groupCount: 4,
          continentalSize: 24,
        );
        expect(adv.relegate, 0, reason: '$kind has no relegation');
      }
    });

    test('a finals group advances the top two', () {
      final adv = GroupAdvancement.forGroup(
        kind: CompetitionKind.worldCupFinals,
        confederation: Confederation.europe,
        groupCount: 12,
        continentalSize: 24,
      );
      expect(adv.direct, 2);
      expect(adv.contention, 3, reason: 'best thirds fill the last R32 places');
    });
  });

  group('GroupAdvancement.caption', () {
    String cap(
      CompetitionKind kind, {
      required int direct,
      int? contention,
      int relegate = 0,
    }) => GroupAdvancement.caption(
      kind: kind,
      adv: (direct: direct, contention: contention, relegate: relegate),
    );

    test('the Nations Cup names promotion and relegation', () {
      final c = cap(CompetitionKind.nationsLeague, direct: 1, relegate: 1);
      expect(c, contains('Winner'));
      expect(c.toLowerCase(), contains('relegated'));
    });

    test('the lowest Nations Cup league has no relegation clause', () {
      final c = cap(CompetitionKind.nationsLeague, direct: 1);
      expect(c.toLowerCase(), isNot(contains('relegated')));
    });

    test('a qualifying group states how many qualify', () {
      // The whole point of the fix: "top two" is stated, so two green is not
      // mistaken for a league where two teams "progress".
      final c = cap(CompetitionKind.continentalQualifying, direct: 2);
      expect(c, contains('Top 2'));
      expect(c.toLowerCase(), contains('advance'));
    });

    test(
      'WC qualifying mentions the play-offs when a spot is in contention',
      () {
        final c = cap(
          CompetitionKind.worldCupQualifying,
          direct: 1,
          contention: 2,
        );
        expect(c.toLowerCase(), contains('play-off'));
      },
    );

    test('friendlies have no caption', () {
      expect(cap(CompetitionKind.friendly, direct: 2), isEmpty);
    });

    test('a caption never reads "Top 0"', () {
      // Oceania plays two World Cup qualifying groups for one direct place, so
      // nothing is safe and first place is what's contested.
      final c = cap(
        CompetitionKind.worldCupQualifying,
        direct: 0,
        contention: 1,
      );
      expect(c, isNot(contains('Top 0')));
      expect(c, contains('best group winners'));
    });
  });

  group('World Cup qualifying berths', () {
    test('Oceania contests first place — two groups, one direct berth', () {
      final adv = GroupAdvancement.worldCupQualifying(Confederation.oceania, 2);
      // Winning a group guarantees NOTHING here: the two winners are ranked
      // against each other for the single place and the loser drops into the
      // intercontinental play-off. Painting both green was the bug.
      expect(adv.direct, 0);
      expect(adv.contention, 1);
      expect(adv.contentionQualify, 1);
    });

    test('Europe: winners through, best runners-up contest the rest', () {
      final adv = GroupAdvancement.worldCupQualifying(Confederation.europe, 9);
      expect(adv.direct, 1);
      expect(adv.contention, 2);
      // 16 places over 9 groups: every winner, then the 7 best runners-up.
      expect(adv.contentionQualify, 7);
    });

    test('a single league takes its top N', () {
      final adv = GroupAdvancement.worldCupQualifying(
        Confederation.southAmerica,
        1,
      );
      expect(adv.direct, 6);
      expect(adv.contention, 7, reason: 'the play-off entrant');
    });
  });

  group('continental qualifying berths', () {
    test('an 8-team Oceania Cup runs three deep and contests fourth', () {
      // Eight-team finals less one host is seven places from two groups:
      // winners, runners-up and thirds fill six, and the better fourth-placed
      // side takes the last. The old maths stopped at "top two, third in
      // contention", which is what made the table's highlighting nonsense.
      final adv = GroupAdvancement.continentalQualifying(7, 2);
      expect(adv.direct, 3);
      expect(adv.contention, 4);
      expect(adv.contentionQualify, 1);
    });

    test('a 24-team cup is the familiar top two plus best thirds', () {
      final adv = GroupAdvancement.continentalQualifying(23, 9);
      expect(adv.direct, 2);
      expect(adv.contention, 3);
      expect(adv.contentionQualify, 5);
    });

    test('an exactly-divisible field leaves nothing contested', () {
      final adv = GroupAdvancement.continentalQualifying(12, 6);
      expect(adv.direct, 2);
      expect(adv.contention, isNull);
      expect(adv.contentionQualify, 0);
    });

    test('no groups is survivable', () {
      expect(GroupAdvancement.continentalQualifying(8, 0).direct, 8);
    });
  });

  test('ordinals read correctly', () {
    expect(GroupAdvancement.ordinal(1), '1st');
    expect(GroupAdvancement.ordinal(2), '2nd');
    expect(GroupAdvancement.ordinal(3), '3rd');
    expect(GroupAdvancement.ordinal(4), '4th');
    expect(GroupAdvancement.ordinal(11), '11th');
    expect(GroupAdvancement.ordinal(21), '21st');
  });
}
