import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';

/// The second half of the purchase: the trial runs two saves, the buyer runs
/// as many as he likes.
void main() {
  group('the save-slot rule', () {
    test('the trial runs two saves', () {
      expect(saveSlotLimit(premiumUnlocked: false), 2);
      expect(kFreeSaveSlots, 2);
    });

    test('paying takes the ceiling away entirely', () {
      // Not a bigger number: none. The product is sold as unlimited, and a
      // cap of any size is a promise a buyer can count up to.
      expect(saveSlotLimit(premiumUnlocked: true), isNull);
    });

    test('a free player may create up to the limit', () {
      expect(canCreateSave(existingSaves: 0, premiumUnlocked: false), isTrue);
      expect(canCreateSave(existingSaves: 1, premiumUnlocked: false), isTrue);
      expect(canCreateSave(existingSaves: 2, premiumUnlocked: false), isFalse);
    });

    test('a free player already over the limit is refused a new one, '
        'and only that', () {
      // Six saves made while everything was free. He keeps all six; the rule
      // only ever answers "may another one be made", and that is no.
      expect(canCreateSave(existingSaves: 6, premiumUnlocked: false), isFalse);
    });

    test('a buyer is never refused, however many he has', () {
      for (final n in [0, 2, 10, 500]) {
        expect(canCreateSave(existingSaves: n, premiumUnlocked: true), isTrue);
      }
    });
  });
}
