import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/messages/messages_screen.dart';

void main() {
  test('every message category the inbox files has a group', () {
    expect(inboxGroupOf('board'), InboxFilter.board);
    expect(inboxGroupOf('cycle'), InboxFilter.board);
    for (final c in [
      'draw',
      'qualify',
      'eliminated',
      'champion',
      'triumph',
      'ranking',
    ]) {
      expect(inboxGroupOf(c), InboxFilter.competitions, reason: c);
    }
    for (final c in [
      'aging',
      'youth',
      'injury',
      'discipline',
      'retirement',
      'milestone',
      'award',
      'halloffame',
      'naturalize',
      'transfer',
      'record',
    ]) {
      expect(inboxGroupOf(c), InboxFilter.squad, reason: c);
    }
  });

  test('an unknown category is shown under All only', () {
    expect(inboxGroupOf('something-new'), isNull);
  });
}
