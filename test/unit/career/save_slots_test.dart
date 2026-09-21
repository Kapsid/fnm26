import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';

void main() {
  group('save slots', () {
    test('are the same for everyone', () {
      // The trial holds back the second cycle, and nothing else. A free
      // player who wants three saves on the go gets three saves on the go.
      expect(kSaveSlots, 10);
    });
  });
}
