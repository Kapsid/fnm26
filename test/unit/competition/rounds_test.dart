import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/competition/rounds.dart';

void main() {
  group('Rounds.isKnockout', () {
    test('knockout ties are knockouts, whatever the competition prefix', () {
      for (final suffix in Rounds.knockoutSuffixes) {
        expect(Rounds.isKnockout(suffix), isTrue, reason: suffix);
        expect(Rounds.isKnockout('C$suffix'), isTrue, reason: 'C$suffix');
      }
      // The Nations Cup's Finals Four is a knockout too.
      expect(Rounds.isKnockout('NSF'), isTrue);
      expect(Rounds.isKnockout('NFINAL'), isTrue);
    });

    test('group stages are not knockouts', () {
      expect(Rounds.isKnockout('GROUP'), isFalse);
      expect(Rounds.isKnockout('CGROUP'), isFalse);
      expect(Rounds.isKnockout('NGROUP'), isFalse);
    });

    test('continental qualifying is not a knockout', () {
      // Regression: a check that inferred knockout by excluding 'GROUP' called
      // 'CQ' a knockout, so a level continental qualifier rendered "1 - 1 p" —
      // a shootout the engine never ran.
      expect(Rounds.isKnockout('CQ'), isFalse);
    });

    test('friendlies are not knockouts', () {
      expect(Rounds.isKnockout(Rounds.friendly), isFalse);
    });

    test('World Cup qualifying carries no round code at all', () {
      expect(Rounds.isKnockout(null), isFalse);
      expect(Rounds.isKnockout(''), isFalse);
    });
  });
}
