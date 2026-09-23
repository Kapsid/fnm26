import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/rating/overall_rating.dart';

import '../../helpers/fixtures.dart';

void main() {
  group('PlayerPosition.category', () {
    test('maps every position to the right broad category', () {
      expect(PlayerPosition.gk.category, PositionCategory.goalkeeper);
      for (final p in [
        PlayerPosition.lb,
        PlayerPosition.cb,
        PlayerPosition.rb,
      ]) {
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
      for (final p in [
        PlayerPosition.lw,
        PlayerPosition.rw,
        PlayerPosition.st,
      ]) {
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

    test('a striker weights technical ability above stamina', () {
      const technician = PlayerAttributes(
        physical: 70,
        technical: 95,
        stamina: 50,
      );
      const runner = PlayerAttributes(
        physical: 70,
        technical: 50,
        stamina: 95,
      );

      final technicianOverall = OverallRating.forPosition(
        PlayerPosition.st,
        technician,
      );
      final runnerOverall = OverallRating.forPosition(
        PlayerPosition.st,
        runner,
      );

      expect(technicianOverall, greaterThan(runnerOverall));
    });

    test('result is clamped to 1..99', () {
      expect(
        OverallRating.forPosition(PlayerPosition.st, flatAttributes(99)),
        lessThanOrEqualTo(99),
      );
      expect(
        OverallRating.forPosition(PlayerPosition.gk, flatAttributes(1)),
        greaterThanOrEqualTo(1),
      );
    });
  });

  group('PlayerAttributes.average', () {
    test('is the unweighted mean', () {
      expect(flatAttributes(77).average, 77);
    });
  });
}
