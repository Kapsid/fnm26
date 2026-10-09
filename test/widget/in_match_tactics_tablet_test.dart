import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/tactics/in_match_tactics.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart';

import '../helpers/in_match_editor.dart';
import '../helpers/seeded_save.dart';

void main() {
  for (final size in const [Size(1194, 834), Size(1080, 810)]) {
    testWidgets('pitch left, substitutions right at $size', (tester) async {
      await openEditor(tester, size: size, tabletLayout: true);
      expect(tester.takeException(), isNull);
      expect(find.byKey(InMatchTacticsKeys.tabletLayout), findsOneWidget);
      final pitch = tester.getRect(find.byType(TacticsPitch));
      final suitable = tester.getRect(find.text(enL.tacticsTabSuitable));
      expect(pitch.right, lessThanOrEqualTo(suitable.left));
      expect(pitch.bottom, lessThanOrEqualTo(size.height));
      expect(find.text('Bench12'), findsOneWidget, reason: 'subs on screen');
    });
  }

  testWidgets('a slot picker closes on its own, the editor stays', (
    tester,
  ) async {
    await openEditor(tester, size: kTabletSize, tabletLayout: true);
    // A striker's disc: the names are painted, not Text, so tap by place.
    final pitch = tester.getRect(find.byType(TacticsPitch));
    await tester.tapAt(
      pitch.topLeft + Offset(pitch.width * 0.35, pitch.height * 0.14),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bench12').last);
    await tester.pumpAndSettle();
    expect(find.byKey(InMatchTacticsKeys.tabletLayout), findsOneWidget);
  });

  testWidgets('narrow window falls back to the phone editor', (tester) async {
    await openEditor(tester, size: const Size(700, 810), tabletLayout: true);
    expect(find.byKey(InMatchTacticsKeys.tabletLayout), findsNothing);
    expect(find.byType(TabBar), findsOneWidget);
  });

  testWidgets('without the flag the editor keeps its phone body', (
    tester,
  ) async {
    await openEditor(tester, size: const Size(800, 600));
    expect(find.byKey(InMatchTacticsKeys.tabletLayout), findsNothing);
  });
}
