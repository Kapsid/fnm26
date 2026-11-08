import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/features/match/pitch/pitch_view_providers.dart';
import 'package:fnm/shared/widgets/primary_button.dart';

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

  // After the final whistle: the manager's side on the pitch with each
  // man's mark. Played out on the 2D TV (its clock is the one a test can
  // jump to the end of), then, on a tablet, watched back on the Timeline,
  // whose line-ups column is the wider.
  for (final (f, size) in [
    (FormFactor.phone, const Size(390, 1500)),
    (FormFactor.tablet, kTabletSize),
  ]) {
    testWidgets('match screen Lineups at full time (${f.name})', (
      tester,
    ) async {
      final save = await seedSave(tester, formFactor: f);
      await tester.runAsync(
        () => const MatchViewModeStore().save(MatchViewMode.pitch),
      );
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
        size: size,
      );
      final screen = tester.state(find.byType(MatchScreen)) as MatchScreenProbe;
      final continueButton = find.byWidgetPredicate(
        (w) =>
            w is PrimaryButton &&
            w.label == enL.matchContinue &&
            w.onPressed != null,
      );
      // On to half time and through its Continue, then to the end.
      final half = find.descendant(
        of: find.byType(HalfTimePrompt),
        matching: find.text(enL.matchContinue),
      );
      final pb = screen.pitchMode.playback!;
      screen.seekPitch(pb.halfTime - const Duration(milliseconds: 100));
      for (var i = 0; i < 400 && half.evaluate().isEmpty; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }
      await tester.tap(half);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      screen.seekPitch(pb.pacer.total - const Duration(milliseconds: 200));
      for (var i = 0; i < 400 && continueButton.evaluate().isEmpty; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }
      expect(continueButton, findsOneWidget, reason: 'full time');
      if (f == FormFactor.tablet) {
        screen.switchMode();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
      }
      await tester.pump(const Duration(seconds: 3));
      await tester.tap(find.text(enL.matchTabLineups).first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      expect(tester.takeException(), isNull);
      expect(find.byType(MatchFullTimeLineups), findsOneWidget);
      expect(find.byKey(MatchFullTimeLineups.pitchKey), findsOneWidget);
      await expectAppGolden('goldens/match_lineups_full_time_${f.name}.png');
      await tester.pumpWidget(const SizedBox());
    });
  }
}
