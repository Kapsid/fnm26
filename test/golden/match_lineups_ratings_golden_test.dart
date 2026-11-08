import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/match/match_screen.dart';

import '../helpers/lineups_fixture.dart';
import '../helpers/seeded_save.dart';

/// The line-ups with their rating badges: the tab alone with every band and
/// marker (phone widths and the tablet's two column widths), and the real
/// match screen's Lineups tab on a phone and a tablet.
void main() {
  for (final (name, size, fullTime) in [
    ('phone_320', const Size(320, 1100), false),
    ('phone_390_full_time', const Size(390, 1100), true),
    // The tablet's line-ups column: Timeline mode, and Pitch mode's
    // narrower feed column.
    ('tablet_column', const Size(310, 1100), false),
    ('tablet_pitch_column', const Size(256, 1100), true),
  ]) {
    testWidgets('line-ups with badges: $name', (tester) async {
      await pumpThemed(tester, buildLineups(fullTime: fullTime), size);
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byType(RepaintBoundary).first,
        matchesGoldenFile('goldens/lineups_ratings_$name.png'),
      );
    });
  }

  for (final f in [FormFactor.phone, FormFactor.tablet]) {
    testWidgets('match screen Lineups tab (${f.name})', (tester) async {
      final save = await seedSave(tester, formFactor: f);
      final warm = save.container.listen(
        matchPreviewProvider(save.careerId),
        (_, _) {},
      );
      addTearDown(warm.close);
      await tester.runAsync(
        () => save.container.read(matchPreviewProvider(save.careerId).future),
      );
      await pumpRoute(
        tester,
        save,
        '${Routes.match}?careerId=${save.careerId}',
        size: f == FormFactor.tablet ? kTabletSize : const Size(320, 640),
      );
      await tester.tap(find.text(enL.matchTabLineups));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      expect(tester.takeException(), isNull);
      expect(find.byType(MatchLineups), findsOneWidget);
      await expectAppGolden('goldens/match_lineups_${f.name}.png');
      await tester.pumpWidget(const SizedBox());
    });
  }
}
