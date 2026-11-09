import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/features/match/pitch/pitch_match_view.dart';
import 'package:fnm/features/match/pitch/pitch_view_providers.dart';
import 'package:fnm/features/share/share_sheet.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/seeded_save.dart';

/// The match's bottom bar on the silver of the navigation dock, on a phone
/// and a tablet; on a tablet it also carries the Pitch / Timeline toggle,
/// and at full time Share beside Continue.

Future<SeededSave> _open(
  WidgetTester tester,
  FormFactor f,
  MatchViewMode mode,
  Size size,
) async {
  final save = await seedSave(tester, formFactor: f);
  await tester.runAsync(() => const MatchViewModeStore().save(mode));
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
  return save;
}

Finder _inDock(Finder f) =>
    find.descendant(of: find.byType(MatchBarDock), matching: f);

final Finder _continue = find.byWidgetPredicate(
  (w) => w is PrimaryButton && w.label == enL.matchContinue,
);

/// Plays a Pitch-mode match to its final whistle.
Future<void> _toFullTime(WidgetTester tester) async {
  final screen = tester.state(find.byType(MatchScreen)) as MatchScreenProbe;
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
  for (var i = 0; i < 400 && _continue.evaluate().isEmpty; i++) {
    await tester.pump(const Duration(milliseconds: 16));
  }
  await tester.pump(const Duration(seconds: 3));
}

void main() {
  for (final size in [const Size(1366, 1024), const Size(1180, 820)]) {
    final tag = '${size.width.toInt()}x${size.height.toInt()}';
    testWidgets('tablet: silver bar with the view toggle at $tag', (
      tester,
    ) async {
      await _open(tester, FormFactor.tablet, MatchViewMode.timeline, size);
      expect(tester.takeException(), isNull);
      expect(_inDock(find.byType(SilverDock)), findsOneWidget);
      expect(_inDock(find.byType(MatchControlBar)), findsOneWidget);
      expect(_inDock(find.byType(MatchViewToggle)), findsOneWidget);
      // Not in the stats panel's header any more.
      expect(find.byKey(matchViewSwitchKey), findsNothing);
      expect(
        _inDock(find.text(enL.matchViewPitch)),
        findsOneWidget,
        reason: 'both ways are named',
      );
      expect(_inDock(find.text(enL.matchViewTimeline)), findsOneWidget);
      // The toggle sits between the speed and the tactics.
      final toggle = tester.getRect(find.byType(MatchViewToggle));
      expect(
        tester.getCenter(find.text('1×')).dx,
        lessThan(toggle.left),
      );
      expect(
        tester.getCenter(find.byType(MatchTacticsPillContent)).dx,
        greaterThan(toggle.right),
      );
      // Pressing the other half takes the match to the pitch.
      await tester.tap(
        find.byKey(MatchViewToggle.segmentKey(MatchViewMode.pitch)),
      );
      await tester.pump();
      for (
        var i = 0;
        i < 100 && find.byType(PitchMatchView).evaluate().isEmpty;
        i++
      ) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 50)),
        );
        await tester.pump(const Duration(milliseconds: 16));
      }
      expect(find.byType(PitchMatchView), findsOneWidget);
      expect(
        tester.widget<MatchViewToggle>(find.byType(MatchViewToggle)).current,
        MatchViewMode.pitch,
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('tablet: Share, the toggle and Continue at full time', (
    tester,
  ) async {
    await _open(
      tester,
      FormFactor.tablet,
      MatchViewMode.pitch,
      const Size(1180, 820),
    );
    await _toFullTime(tester);
    expect(tester.takeException(), isNull);
    expect(_inDock(_continue), findsOneWidget);
    expect(_inDock(find.byKey(ShareKeys.button)), findsOneWidget);
    expect(_inDock(find.byType(MatchViewToggle)), findsOneWidget);
    expect(tester.widget<PrimaryButton>(_continue).onSilver, isTrue);
    final share = tester.getRect(find.byKey(ShareKeys.button));
    expect(share.right, lessThan(tester.getRect(_continue).left));
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('phone: the same silver bar, no toggle on it', (tester) async {
    await _open(tester, FormFactor.phone, MatchViewMode.timeline, kPhoneSize);
    expect(tester.takeException(), isNull);
    expect(_inDock(find.byType(SilverDock)), findsOneWidget);
    expect(_inDock(find.byType(MatchControlBar)), findsOneWidget);
    expect(find.byType(MatchViewToggle), findsNothing);
    // The phone's switch stays on the scoreboard.
    expect(
      find.descendant(
        of: find.byType(MatchScoreboard),
        matching: find.byKey(matchViewSwitchKey),
      ),
      findsOneWidget,
    );
    // Held off the edges, above the foot of the screen.
    final plate = tester.getRect(_inDock(find.byType(SilverDock)));
    expect(plate.left, greaterThan(0));
    expect(plate.right, lessThan(kPhoneSize.width));
    expect(plate.bottom, lessThan(kPhoneSize.height));
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('phone: Share and Continue on the silver at full time', (
    tester,
  ) async {
    await _open(
      tester,
      FormFactor.phone,
      MatchViewMode.pitch,
      const Size(390, 1500),
    );
    await _toFullTime(tester);
    expect(tester.takeException(), isNull);
    expect(_inDock(_continue), findsOneWidget);
    expect(_inDock(find.byKey(ShareKeys.button)), findsOneWidget);
    expect(find.byType(MatchViewToggle), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });
}
