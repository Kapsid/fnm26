import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';

import '../helpers/seeded_save.dart';

/// The phone new game, pinned before the tablet layout is added beside it.
/// The name field takes focus on its own, so the cursor is held still. The
/// page is a scroll view (for the keyboard), so it is pinned tall as well.
/// Pinned as a free player sees it, with the free-cycle note, the longest
/// thing on the page.
void main() {
  for (final (name, size) in [
    ('new_game_phone', kPhoneSize),
    ('new_game_phone_tall', const Size(390, 2400)),
  ]) {
    testWidgets(name, (tester) async {
      EditableText.debugDeterministicCursor = true;
      addTearDown(() => EditableText.debugDeterministicCursor = false);
      final save = await seedSave(tester);
      save.container.read(premiumUnlockedProvider.notifier).state = false;
      await pumpRoute(
        tester,
        save,
        '${Routes.newGame}?nationId=${save.nationId}',
        size: size,
      );
      expect(find.text(enL.careerStartCareer), findsOneWidget);
      await expectAppGolden('goldens/$name.png');
    });
  }
}
