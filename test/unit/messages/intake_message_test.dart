import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/messages/message_sheet.dart';

void main() {
  test('the youth category has its own look in the inbox', () {
    // A category with no entry falls through to the default, so an intake
    // message would be indistinguishable from any other note.
    final youth = messageStyle('youth');
    final fallback = messageStyle('no-such-category-xyz');
    expect(youth.icon, isNot(fallback.icon));
  });
}
