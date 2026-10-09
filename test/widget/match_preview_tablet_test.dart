import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/match/match_preview_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';

import '../helpers/seeded_save.dart';

void main() {
  testWidgets('the preview is two columns: your side, then theirs', (
    tester,
  ) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    await pumpRoute(
      tester,
      save,
      '${Routes.matchPreview}?careerId=${save.careerId}',
      size: kTabletSize,
    );
    expect(tester.takeException(), isNull);
    expect(find.byKey(MatchPreviewScreen.tabletLayoutKey), findsOneWidget);
    expect(find.byType(PhoneWidthFrame), findsNothing);
    final mine = tester.getCenter(find.byType(MatchHeadline));
    final theirs = tester.getCenter(find.byType(OpponentBriefing));
    expect(mine.dx, lessThan(theirs.dx));
    expect(find.text(enL.matchKickOff), findsOneWidget);
    // The sidebar has a Tactics item too, so look inside the bottom bar.
    expect(
      find.descendant(
        of: find.byType(OutlinedButton),
        matching: find.text(enL.matchTactics),
      ),
      findsOneWidget,
    );
    await tester.pumpWidget(const SizedBox());
  });
}
