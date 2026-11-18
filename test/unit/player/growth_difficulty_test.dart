import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/player/growth_difficulty.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';

import '../../helpers/fixtures.dart';

/// The growth half of the 1.1.2 difficulty (`GrowthDifficulty`): game time
/// banked in a `difficulty2` cycle grows a player more slowly and to a lower
/// cap, an intake's bonus is capped and credited only with the hand the
/// manager had at the time, and nothing moves without the marker.
void main() {
  group('game-time development', () {
    // A spread of players: ids drive the hidden potential.
    final players = [
      for (var i = 0; i < 200; i++)
        player(
          id: 5000 + i * 37,
          nationId: 1,
          position: PlayerPosition.values[i % PlayerPosition.values.length],
          attributes: flatAttributes(60 + i % 25),
        ),
    ];
    int bump(int starts, {int marked = 0}) => [
      for (final p in players)
        PlayerLifecycle.withCareerDev(
              p,
              starts,
              markedStarts: marked,
            ).overall -
            p.overall,
    ].fold(0, (a, b) => a + b);

    test('no marked starts is exactly the old bump', () {
      for (final starts in const [0, 1, 4, 9, 25, 60, 120]) {
        for (final p in players) {
          expect(
            PlayerLifecycle.withCareerDev(p, starts, markedStarts: 0),
            PlayerLifecycle.withCareerDev(p, starts),
            reason: '${p.id} $starts',
          );
        }
      }
    });

    test('marked starts grow slower, and to a lower cap', () {
      expect(bump(25, marked: 25), lessThan(bump(25)));
      for (final p in players) {
        final d =
            PlayerLifecycle.withCareerDev(p, 400, markedStarts: 400).overall -
            p.overall;
        expect(d, lessThanOrEqualTo(GrowthDifficulty.devCap + 1));
      }
    });

    test('a rollover never takes back what older starts earned', () {
      for (final p in players) {
        for (final older in const [9, 30, 80]) {
          final before = PlayerLifecycle.withCareerDev(p, older).overall;
          for (final more in const [1, 5, 20]) {
            final after = PlayerLifecycle.withCareerDev(
              p,
              older + more,
              markedStarts: more,
            ).overall;
            expect(after, greaterThanOrEqualTo(before), reason: '${p.id}');
          }
        }
      }
    });

    test('a plain starts map reads no marked starts; CareerStarts does', () {
      expect(PlayerLifecycle.markedStartsOf(const {7: 12}, 7), 0);
      final starts = CareerStarts({7: 12}, marked: {7: 5});
      expect(starts[7], 12);
      expect(PlayerLifecycle.markedStartsOf(starts, 7), 5);
      expect(PlayerLifecycle.markedStartsOf(starts, 8), 0);
    });
  });

  group('the youth intake', () {
    test('a difficulty2 intake is capped, a negative standing bites', () {
      expect(
        GrowthDifficulty.cappedIntake(0.43),
        GrowthDifficulty.intakeBonusCap,
      );
      expect(GrowthDifficulty.cappedIntake(0.06), 0.06);
      expect(GrowthDifficulty.cappedIntake(-0.04), -0.04);
    });

    test('the hand is read per cycle, the best seen in it', () {
      final recorded = GrowthDifficulty.youthHandByCycle([
        GrowthDifficulty.youthHandKind(0, 0),
        GrowthDifficulty.youthHandKind(2, 0.05),
        GrowthDifficulty.youthHandKind(2, 0.035),
        'calendar2',
        'difficulty2',
        '${GrowthDifficulty.youthHandPrefix}junk',
      ]);
      expect(recorded, {0: 0.0, 2: 0.05});
      expect(GrowthDifficulty.youthHandFor(0, recorded), 0);
      // A cycle with no record of its own inherits the last one before it.
      expect(GrowthDifficulty.youthHandFor(1, recorded), 0);
      expect(GrowthDifficulty.youthHandFor(2, recorded), 0.05);
      expect(GrowthDifficulty.youthHandFor(3, recorded), 0.05);
      expect(GrowthDifficulty.youthHandFor(4, const {}), 0);
    });
  });
}
