import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/competition/group_advancement.dart';

void main() {
  group('GroupAdvancement.forGroup', () {
    Advancement nationsCup({required bool lowest}) =>
        GroupAdvancement.forGroup(
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
    String cap(CompetitionKind kind, {required int direct, int? contention,
        int relegate = 0}) => GroupAdvancement.caption(
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

    test('WC qualifying mentions the play-offs when a spot is in contention',
        () {
      final c = cap(CompetitionKind.worldCupQualifying, direct: 1,
          contention: 2);
      expect(c.toLowerCase(), contains('play-off'));
    });

    test('friendlies have no caption', () {
      expect(cap(CompetitionKind.friendly, direct: 2), isEmpty);
    });
  });
}
