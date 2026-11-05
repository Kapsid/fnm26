import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/match/match_providers.dart';

import '../helpers/seeded_save.dart';

/// The player repository remembers each career's world. [seedSave] creates
/// the career inside `tester.runAsync`, so the first read of its world
/// happens in the real zone; the match widget tests then listen to the match
/// preview in fake async and await it in `tester.runAsync`. While the
/// repository kept the reading *future*, that future (made in the real zone)
/// handed its value to the preview's fake-async reads through the wrong
/// zone, and the preview never finished: match_tablet_test and
/// match_screen_keeps_its_own_fixture_test hung for ever.
void main() {
  testWidgets('the match preview finishes for a career whose world was '
      'first read in the real zone', (tester) async {
    final save = await seedSave(tester);
    final sub = save.container.listen(
      matchPreviewProvider(save.careerId),
      (_, _) {},
    );
    addTearDown(sub.close);
    Object? outcome;
    await tester.runAsync(
      () => save.container
          .read(matchPreviewProvider(save.careerId).future)
          .timeout(const Duration(seconds: 30))
          .then(
            (p) {
              outcome = p == null ? 'no preview' : 'preview';
            },
            onError: (Object e) {
              outcome = e;
            },
          ),
    );
    expect(outcome, 'preview', reason: 'the match preview never finished');
  });
}
