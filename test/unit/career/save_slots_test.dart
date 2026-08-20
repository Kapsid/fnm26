import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';

void main() {
  group('save slots', () {
    test('the free tier gets three', () {
      expect(maxSaveSlots(premiumUnlocked: false), 3);
    });

    test('Pro gets ten', () {
      expect(maxSaveSlots(premiumUnlocked: true), 10);
    });
  });
}
