import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/rating/overall_rating.dart';

import '../../helpers/fixtures.dart';

void main() {
  group('PlayerPosition.category', () {
    test('maps every position to the right broad category', () {
      expect(PlayerPosition.gk.category, PositionCategory.goalkeeper);
      for (final p in [PlayerPosition.lb, PlayerPosition.cb, PlayerPosition.rb]) {
        expect(p.category, PositionCategory.defender, reason: p.name);
      }
      for (final p in [
        PlayerPosition.dm,
        PlayerPosition.cm,
        PlayerPosition.am,
        PlayerPosition.lm,
        PlayerPosition.rm,
      ]) {
        expect(p.category, PositionCategory.midfielder, reason: p.name);
      }
      for (final p in [PlayerPosition.lw, PlayerPosition.rw, PlayerPosition.st]) {
        expect(p.category, PositionCategory.forward, reason: p.name);
      }
    });
  });

  group('OverallRating.forPosition', () {
    test('uniform attributes yield exactly that value (weights sum to 1)', () {
      for (final position in PlayerPosition.values) {
        expect(
          OverallRating.forPosition(position, flatAttributes(80)),
          80,
          reason: position.name,
        );
      }
    });

    test('a striker is rewarded for finishing more than for tackling', () {
      const finisher = PlayerAttributes(
        passing: 60,
        shooting: 95,
        dribbling: 80,
        tackling: 30,
        positioning: 80,
        composure: 85,
        decisions: 70,
        pace: 88,
        stamina: 70,
        strength: 70,
      );
      const tackler = PlayerAttributes(
        passing: 60,
        shooting: 30,
        dribbling: 80,
        tackling: 95,
        positioning: 80,
        composure: 85,
        decisions: 70,
        pace: 88,
        stamina: 70,
        strength: 70,
      );

      final finisherOverall =
          OverallRating.forPosition(PlayerPosition.st, finisher);
      final tacklerOverall =
          OverallRating.forPosition(PlayerPosition.st, tackler);

      expect(finisherOverall, greaterThan(tacklerOverall));
    });

    test('result is clamped to 1..99', () {
      expect(OverallRating.forPosition(PlayerPosition.st, flatAttributes(99)),
          lessThanOrEqualTo(99));
      expect(OverallRating.forPosition(PlayerPosition.gk, flatAttributes(1)),
          greaterThanOrEqualTo(1));
    });
  });

  group('PlayerAttributes.average', () {
    test('is the unweighted mean', () {
      expect(flatAttributes(77).average, 77);
    });
  });
}
