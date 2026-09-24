import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/tactics/substitution_rules.dart';

void main() {
  group('canBringOn', () {
    test('refuses a fourth change once three are spent', () {
      expect(
        canBringOn(
          startingIds: {1, 2, 3, 4},
          onPitch: {4, 11, 12, 13},
          sentOffIds: const {},
          withdrawnIds: {1, 2, 3},
          maxSubs: 3,
          playerId: 14,
        ),
        isFalse,
      );
    });

    test('refuses a player already substituted off', () {
      expect(
        canBringOn(
          startingIds: {1, 2, 3, 4},
          onPitch: {2, 3, 4, 11},
          sentOffIds: const {},
          withdrawnIds: {1},
          maxSubs: 3,
          playerId: 1,
        ),
        isFalse,
      );
    });

    test('allows a change while changes remain', () {
      expect(
        canBringOn(
          startingIds: {1, 2, 3, 4},
          onPitch: {2, 3, 4, 11},
          sentOffIds: const {},
          withdrawnIds: {1},
          maxSubs: 3,
          playerId: 12,
        ),
        isTrue,
      );
    });

    test('a sending-off does not consume a substitution', () {
      expect(
        canBringOn(
          startingIds: {1, 2, 3, 4},
          onPitch: {3, 4},
          sentOffIds: {2},
          withdrawnIds: {1},
          maxSubs: 3,
          playerId: 12,
        ),
        isTrue,
      );
    });
  });

  group('deadSlots', () {
    /// An eleven-slot lineup with [holes] of them empty, at the back.
    List<int?> lineup(int holes) => [
      for (var i = 0; i < 11 - holes; i++) i + 1,
      for (var i = 0; i < holes; i++) null,
    ];

    test('a red card kills the slot it emptied', () {
      expect(deadSlots(lineup: lineup(1), sentOffCount: 1), {10});
    });

    test('two red cards kill two slots', () {
      expect(deadSlots(lineup: lineup(2), sentOffCount: 2), {9, 10});
    });

    test('an empty slot with nobody sent off is a vacancy, not a hole', () {
      expect(deadSlots(lineup: lineup(1), sentOffCount: 0), isEmpty);
    });

    test('a full eleven has no holes to kill', () {
      expect(deadSlots(lineup: lineup(0), sentOffCount: 1), isEmpty);
    });

    test('a side below its reduced eleven may still fill a slot', () {
      // Nine on the pitch with one man sent off: he is owed ten, so one of the
      // two holes is a vacancy. Filling it kills the other.
      expect(deadSlots(lineup: lineup(2), sentOffCount: 1), isEmpty);
      expect(deadSlots(lineup: lineup(1), sentOffCount: 1), {10});
    });

    test('the hole moves with the shape rather than being remembered', () {
      // A reshape re-derives the whole lineup, so the empty slot lands
      // somewhere else entirely. It is still the dead one.
      expect(
        deadSlots(
          lineup: [1, 2, 3, null, 5, 6, 7, 8, 9, 10, 11],
          sentOffCount: 1,
        ),
        {3},
      );
    });
  });

  group('slotLostToRedCard', () {
    test('refuses the hole and nothing else', () {
      final xi = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, null];
      expect(
        slotLostToRedCard(lineup: xi, sentOffCount: 1, slot: 10),
        isTrue,
      );
      expect(slotLostToRedCard(lineup: xi, sentOffCount: 1, slot: 4), isFalse);
    });
  });
}
