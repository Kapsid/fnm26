import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';

import '../../helpers/fixtures.dart';

/// The all-time charts mark a leader you can still pick. That flag used to be
/// read off a flat "under 37" rule while retirement is actually per player
/// (34–40), so a thirty-eight-year-old still turning out in a live tournament
/// was listed as finished.
void main() {
  test('a career that runs long is active past the norm', () {
    // Somebody, somewhere, plays to forty.
    final late = List.generate(
      500,
      (i) => i + 1,
    ).firstWhere((id) => PlayerLifecycle.retirementAgeFor(id) > 37);
    expect(
      PlayerLifecycle.hasRetiredAt(late, 37, 0),
      isFalse,
      reason: 'his own career has not ended yet',
    );
  });

  test('a career that ends early is finished before the norm', () {
    final early = List.generate(
      500,
      (i) => i + 1,
    ).firstWhere((id) => PlayerLifecycle.retirementAgeFor(id) < 37);
    expect(PlayerLifecycle.hasRetiredAt(early, 37, 0), isTrue);
  });

  test('everyone still in the pool counts as active', () {
    // The charts and the squad list must not disagree about who is playing:
    // that disagreement IS the bug — a man in this week's tournament shown as
    // retired.
    for (var nation = 1; nation <= 10; nation++) {
      for (final years in [0, 1, 4, 9]) {
        final seeded = [
          for (var i = 0; i < 30; i++)
            player(id: nation * 1000 + i, nationId: nation, age: 18 + i % 20),
        ];
        for (final p in PlayerLifecycle.poolAt(seeded, nation, years)) {
          expect(
            PlayerLifecycle.hasRetiredAt(p.id, p.age, years),
            isFalse,
            reason:
                'player ${p.id} (age ${p.age}) is in the pool in year $years, '
                'so the charts must call him active',
          );
        }
      }
    }
  });
}
