import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/player/player_aging.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';

import '../../helpers/fixtures.dart';

void main() {
  /// The first id at or after [from] that belongs to a superstar.
  int superstarId([int from = 1]) {
    for (var id = from; id < from + 500000; id++) {
      if (PlayerLifecycle.isSuperstar(id)) return id;
    }
    fail('no superstar id found — the tail is empty');
  }

  int ordinaryId([int from = 1]) {
    for (var id = from; id < from + 1000; id++) {
      if (!PlayerLifecycle.isSuperstar(id)) return id;
    }
    fail('no ordinary id found');
  }

  Player at(int id, int age, int attribute) => player(
        id: id,
        nationId: 1,
        name: 'Test',
        position: PlayerPosition.st,
        age: age,
        attributes: flatAttributes(attribute),
      );

  group('who is a superstar', () {
    test('a world of ~4800 players holds between five and twenty', () {
      // The count is never managed — it falls out of the tail of the potential
      // draw. This is the guard that keeps it in the band the design asks for.
      var count = 0;
      for (var id = 100; id < 4900; id++) {
        if (PlayerLifecycle.isSuperstar(id)) count++;
      }
      expect(count, greaterThanOrEqualTo(5));
      expect(count, lessThanOrEqualTo(20));
    });

    test('is derived from the id alone, so two saves see the same greats', () {
      final id = superstarId();
      expect(PlayerLifecycle.isSuperstar(id), isTrue);
      expect(PlayerLifecycle.isSuperstar(id), isTrue);
    });

    test('is the extreme tail of the same potential draw', () {
      final id = superstarId();
      expect(
        PlayerLifecycle.developmentPotential(id),
        greaterThanOrEqualTo(PlayerLifecycle.superstarPotential),
      );
    });
  });

  group('what a superstar plays at', () {
    test('a gem born in a weak pool is still world class', () {
      // The whole point: a player out of a squad rated in the sixties who is
      // himself one of the best in the world. A flat bonus could never do it.
      final id = superstarId();
      final peak = PlayerAging.agedYears(at(id, 26, 62), 0);
      expect(peak.overall, greaterThanOrEqualTo(88));
    });

    test('he is clearly above the best ordinary player', () {
      final star = PlayerAging.agedYears(at(superstarId(), 27, 70), 0);
      final best = PlayerAging.agedYears(at(ordinaryId(), 27, 88), 0);
      expect(star.overall, greaterThan(best.overall));
    });

    test('he keeps the shape he was born with', () {
      // Not every attribute flattened onto one number — the quick one stays the
      // quick one.
      final id = superstarId();
      final lifted = PlayerAging.agedYears(
        player(
          id: id,
          nationId: 1,
          name: 'Test',
          position: PlayerPosition.st,
          age: 27,
          attributes: const PlayerAttributes(
            physical: 80,
            technical: 55,
            stamina: 55,
          ),
        ),
        0,
      );
      expect(lifted.attributes.physical,
          greaterThan(lifted.attributes.technical));
    });

    test('he arrives through his early twenties and fades in his thirties', () {
      final id = superstarId();
      int levelAt(int age) => PlayerLifecycle.superstarLevel(id, age);
      expect(levelAt(18), lessThan(levelAt(21)));
      expect(levelAt(21), lessThan(levelAt(26)));
      expect(levelAt(26), greaterThan(levelAt(34)));
      expect(levelAt(34), greaterThan(levelAt(38)));
    });

    test('never breaks the superstar ceiling', () {
      final id = superstarId();
      final p = PlayerAging.agedYears(at(id, 27, 95), 0);
      for (final v in [
        p.attributes.physical,
        p.attributes.technical,
        p.attributes.stamina,
      ]) {
        expect(v, lessThanOrEqualTo(PlayerLifecycle.superstarCeiling));
      }
    });
  });

  test('an ordinary player is left exactly as he was', () {
    final id = ordinaryId();
    final before = at(id, 27, 74);
    expect(PlayerAging.agedYears(before, 0).attributes, before.attributes);
  });
}
