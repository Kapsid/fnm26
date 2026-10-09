import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart';

import '../helpers/seeded_save.dart';

Future<SeededSave> _warm(WidgetTester tester, FormFactor f) async {
  final save = await seedSave(tester, formFactor: f);
  final warm = save.container.listen(
    matchPreviewProvider(save.careerId),
    (_, _) {},
  );
  addTearDown(warm.close);
  await tester.runAsync(
    () => save.container.read(matchPreviewProvider(save.careerId).future),
  );
  return save;
}

void main() {
  testWidgets('three columns and the control bar, full screen', (
    tester,
  ) async {
    final save = await _warm(tester, FormFactor.tablet);
    await pumpRoute(
      tester,
      save,
      '${Routes.match}?careerId=${save.careerId}',
      size: kTabletSize,
    );
    expect(tester.takeException(), isNull);
    expect(find.byKey(MatchScreen.tabletLayoutKey), findsOneWidget);
    expect(find.byType(FullScreenPhoneFrame), findsNothing);
    expect(find.byType(TacticsPitch), findsOneWidget);
    expect(find.byType(MatchStatsPanel), findsOneWidget);
    expect(find.byType(MatchControlBar), findsOneWidget);
    expect(find.byType(MatchDetailTabs), findsNothing);
    // Commentary left of the pitch, stats right of it.
    final pitch = tester.getCenter(find.byType(TacticsPitch));
    expect(
      tester.getCenter(find.text(enL.matchTabTimeline.toUpperCase())).dx,
      lessThan(pitch.dx),
    );
    expect(
      tester.getCenter(find.byType(MatchStatsPanel)).dx,
      greaterThan(pitch.dx),
    );
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a phone build keeps the phone match even in a tablet-sized '
      'test window (Review Focus 5)', (tester) async {
    final save = await _warm(tester, FormFactor.phone);
    await pumpRoute(
      tester,
      save,
      '${Routes.match}?careerId=${save.careerId}',
      size: const Size(800, 600),
    );
    expect(find.byKey(MatchScreen.tabletLayoutKey), findsNothing);
    expect(find.byType(MatchDetailTabs), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}
