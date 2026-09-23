import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/match/penalty_takers.dart';
import 'package:fnm/domain/services/player/player_traits.dart';

import '../../helpers/fixtures.dart';

Player p({
  required int id,
  required PlayerPosition position,
  int technical = 70,
}) => player(
  id: id,
  nationId: 1,
  position: position,
  attributes: PlayerAttributes(
    physical: 70,
    technical: technical,
    stamina: 70,
  ),
);

void main() {
  group('choosing takers', () {
    final keeper = p(id: 1, position: PlayerPosition.gk, technical: 80);
    final defender = p(id: 2, position: PlayerPosition.cb, technical: 60);
    final midfielder = p(id: 3, position: PlayerPosition.cm, technical: 78);
    final striker = p(id: 4, position: PlayerPosition.st, technical: 84);
    final xi = [keeper, defender, midfielder, striker];

    test('the surest takers come first, and never the keeper', () {
      final order = PenaltyTakers.autoOrder(xi);
      expect(order.first.id, striker.id);
      expect(order.map((q) => q.id), isNot(contains(keeper.id)));
    });

    test('a sent-off player cannot be named', () {
      final order = PenaltyTakers.autoOrder(xi, unavailable: {striker.id});
      expect(order.map((q) => q.id), isNot(contains(striker.id)));
      expect(order.first.id, midfielder.id);
    });

    test('a keeper takes one only when nobody else is left', () {
      expect(PenaltyTakers.autoOrder([keeper]).single.id, keeper.id);
    });

    test('composure decides the kick, not the shirt', () {
      expect(
        PenaltyTakers.skillOf(striker, const []),
        greaterThan(PenaltyTakers.skillOf(defender, const [])),
      );
    });

    test('traits shift a taker either way', () {
      final base = PenaltyTakers.skillOf(striker, const []);
      expect(
        PenaltyTakers.skillOf(striker, const [PlayerTrait.setPiece]),
        greaterThan(base),
      );
      expect(
        PenaltyTakers.skillOf(striker, const [PlayerTrait.wasteful]),
        lessThan(base),
      );
    });
  });

  group('the shootout itself', () {
    /// How often the home side wins over many seeded shootouts.
    int homeWins({
      List<double> homeSkill = const [],
      List<double> awaySkill = const [],
    }) {
      var wins = 0;
      for (var i = 0; i < 400; i++) {
        final o = WorldCupFinals.decideKnockout(
          1,
          1,
          SeededRng(i * 2654435761 + 11),
          homeTakerSkill: homeSkill,
          awayTakerSkill: awaySkill,
        );
        if (o.wentToShootout && o.homeWon) wins++;
      }
      return wins;
    }

    test('better takers win more shootouts', () {
      final level = homeWins();
      final stacked = homeWins(
        homeSkill: const [1.15, 1.15, 1.15, 1.15, 1.15],
        awaySkill: const [0.75, 0.75, 0.75, 0.75, 0.75],
      );
      expect(stacked, greaterThan(level + 40));
    });

    test('an order of nobodies loses them', () {
      expect(
        homeWins(
          homeSkill: const [0.75, 0.75, 0.75, 0.75, 0.75],
          awaySkill: const [1.15, 1.15, 1.15, 1.15, 1.15],
        ),
        lessThan(homeWins() - 40),
      );
    });

    test('naming takers never changes the extra-time score', () {
      // Extra time is drawn from the same stream BEFORE the shootout, so the
      // tie the manager just watched must survive the choice.
      for (var i = 0; i < 50; i++) {
        final auto = WorldCupFinals.decideKnockout(
          1,
          1,
          SeededRng(i * 7919 + 3),
        );
        final named = WorldCupFinals.decideKnockout(
          1,
          1,
          SeededRng(i * 7919 + 3),
          homeTakerSkill: const [1.1, 0.8, 1.0, 0.9, 1.15],
        );
        expect(named.homeScore, auto.homeScore);
        expect(named.awayScore, auto.awayScore);
        expect(named.wentToShootout, auto.wentToShootout);
      }
    });

    test('an empty order leaves a background tie exactly as it was', () {
      final before = WorldCupFinals.decideKnockout(1, 1, SeededRng(4242));
      final after = WorldCupFinals.decideKnockout(
        1,
        1,
        SeededRng(4242),
        homeTakerSkill: const [],
        awayTakerSkill: const [],
      );
      expect(after.homeKicks, before.homeKicks);
      expect(after.awayKicks, before.awayKicks);
    });
  });
}
