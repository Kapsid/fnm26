import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/player/player_traits.dart';

Player _p({
  required int id,
  int age = 26,
  PlayerPosition position = PlayerPosition.cm,
  int physical = 70,
  int technical = 70,
  int stamina = 70,
}) => Player(
  id: id,
  nationId: 1,
  name: 'P$id',
  age: age,
  position: position,
  attributes: PlayerAttributes(
    physical: physical,
    technical: technical,
    stamina: stamina,
  ),
);

void main() {
  group('PlayerTraits', () {
    test('is stable for a player within a save', () {
      final p = _p(id: 42);
      final first = PlayerTraits.of(p, saveSeed: 7);
      for (var i = 0; i < 5; i++) {
        expect(PlayerTraits.of(p, saveSeed: 7), first);
      }
    });

    test('never exceeds the cap', () {
      for (var id = 1; id < 400; id++) {
        final traits = PlayerTraits.of(
          _p(id: id, age: 20, physical: 90, technical: 90, stamina: 90),
          saveSeed: 3,
        );
        expect(traits.length, lessThanOrEqualTo(PlayerTraits.maxTraits));
        expect(traits.toSet().length, traits.length, reason: 'no duplicates');
      }
    });

    test('earned traits follow the attributes that justify them', () {
      expect(
        PlayerTraits.of(_p(id: 1, physical: 90), saveSeed: 1),
        contains(PlayerTrait.pacey),
      );
      expect(
        PlayerTraits.of(_p(id: 1, stamina: 90), saveSeed: 1),
        contains(PlayerTrait.ironMan),
      );
      expect(
        PlayerTraits.of(
          _p(id: 1, age: 20, physical: 80, technical: 80, stamina: 80),
          saveSeed: 1,
        ),
        contains(PlayerTrait.wonderkid),
      );
      // An ordinary player with ordinary attributes earns nothing automatic.
      expect(
        PlayerTraits.of(
          _p(id: 1, physical: 60, technical: 60, stamina: 60),
          saveSeed: 1,
        ),
        isNot(contains(PlayerTrait.pacey)),
      );
    });

    test('traits stay sparse across a squad', () {
      // The point of a trait is that it distinguishes; if most players carry
      // one it distinguishes nobody.
      var withTrait = 0;
      const squad = 200;
      for (var id = 1; id <= squad; id++) {
        // A believable mid-tier pool: nothing here earns an automatic trait.
        final traits = PlayerTraits.of(
          _p(id: id * 7, physical: 72, technical: 74, stamina: 74),
          saveSeed: 11,
        );
        if (traits.isNotEmpty) withTrait++;
      }
      expect(withTrait, greaterThan(0));
      expect(withTrait / squad, lessThan(0.5));
    });

    test('a goalkeeper is never a hothead', () {
      for (var id = 1; id < 200; id++) {
        final traits = PlayerTraits.of(
          _p(id: id, position: PlayerPosition.gk, physical: 80),
          saveSeed: 5,
        );
        expect(traits, isNot(contains(PlayerTrait.hothead)));
      }
    });
  });

  group('keeper traits (1.1.2)', () {
    const keeperOnly = {PlayerTrait.shotStopper, PlayerTrait.penaltyStopper};

    test('only keepers carry them, and a fine handler is a shot stopper', () {
      var stoppers = 0;
      var penalty = 0;
      for (var id = 1; id < 600; id++) {
        final out = PlayerTraits.of(_p(id: id, technical: 85));
        expect(out.where(keeperOnly.contains), isEmpty, reason: 'outfield $id');
        final k = PlayerTraits.of(
          _p(id: id, position: PlayerPosition.gk, technical: 85),
        );
        if (k.contains(PlayerTrait.shotStopper)) stoppers++;
        if (k.contains(PlayerTrait.penaltyStopper)) penalty++;
        expect(k.length, lessThanOrEqualTo(PlayerTraits.maxTraits));
      }
      // Every fine handler with room for it; some known for penalties.
      expect(stoppers, greaterThan(500));
      expect(penalty, inInclusiveRange(30, 200));
    });

    test('they never displace a trait a keeper already carried', () {
      for (var id = 1; id < 600; id++) {
        final k = _p(id: id, position: PlayerPosition.gk, technical: 85);
        final traits = PlayerTraits.of(k);
        final older = traits.where((t) => !keeperOnly.contains(t)).toList();
        // The older traits come first and in their old order.
        expect(traits.take(older.length).toList(), older);
      }
    });

    test('an ordinary keeper is no shot stopper', () {
      for (var id = 1; id < 200; id++) {
        expect(
          PlayerTraits.of(
            _p(id: id, position: PlayerPosition.gk, technical: 70),
          ),
          isNot(contains(PlayerTrait.shotStopper)),
        );
      }
    });
  });
}
