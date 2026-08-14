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
}
