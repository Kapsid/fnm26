import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';

void main() {
  group('SeededRng', () {
    test('same seed produces an identical sequence (determinism)', () {
      final a = SeededRng(12345);
      final b = SeededRng(12345);

      final seqA = List.generate(1000, (_) => a.nextDouble());
      final seqB = List.generate(1000, (_) => b.nextDouble());

      expect(seqA, equals(seqB));
    });

    test('different seeds produce different sequences', () {
      final a = SeededRng(1);
      final b = SeededRng(2);

      final seqA = List.generate(50, (_) => a.nextInt(1000));
      final seqB = List.generate(50, (_) => b.nextInt(1000));

      expect(seqA, isNot(equals(seqB)));
    });

    test('forFixture is deterministic per (saveSeed, fixtureId)', () {
      final a = SeededRng.forFixture(999, 42);
      final b = SeededRng.forFixture(999, 42);
      final other = SeededRng.forFixture(999, 43);

      final seqA = List.generate(100, (_) => a.nextInt(100));
      final seqB = List.generate(100, (_) => b.nextInt(100));
      final seqOther = List.generate(100, (_) => other.nextInt(100));

      expect(seqA, equals(seqB));
      expect(seqA, isNot(equals(seqOther)));
    });

    test('nextDouble stays within [0, 1)', () {
      final rng = SeededRng(7);
      for (var i = 0; i < 10000; i++) {
        final v = rng.nextDouble();
        expect(v, greaterThanOrEqualTo(0.0));
        expect(v, lessThan(1.0));
      }
    });

    test('nextInt stays within [0, max)', () {
      final rng = SeededRng(7);
      for (var i = 0; i < 10000; i++) {
        final v = rng.nextInt(6);
        expect(v, inInclusiveRange(0, 5));
      }
    });

    test('rangeInt stays within [min, max] inclusive', () {
      final rng = SeededRng(7);
      for (var i = 0; i < 10000; i++) {
        final v = rng.rangeInt(-3, 3);
        expect(v, inInclusiveRange(-3, 3));
      }
    });

    test('chance(0) is never true and chance(1) is always true', () {
      final rng = SeededRng(7);
      for (var i = 0; i < 1000; i++) {
        expect(rng.chance(0), isFalse);
        expect(rng.chance(1), isTrue);
      }
    });

    test('state can be captured and restored to reproduce a stream', () {
      final rng = SeededRng(2024)..nextDouble();
      final captured = rng.state;

      final continuation = List.generate(20, (_) => rng.nextInt(1000));

      final restored = SeededRng(0)..state = captured;
      final replay = List.generate(20, (_) => restored.nextInt(1000));

      expect(replay, equals(continuation));
    });

    test('shuffled is a permutation that leaves the original intact', () {
      final rng = SeededRng(5);
      final original = List.generate(20, (i) => i);
      final shuffled = rng.shuffled(original);

      expect(shuffled, hasLength(original.length));
      expect(shuffled.toSet(), equals(original.toSet()));
      expect(original, equals(List.generate(20, (i) => i)));
    });
  });
}
