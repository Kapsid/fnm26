import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/awards/poty_history_providers.dart';
import 'package:fnm/features/awards/poty_history_screen.dart';
import 'package:fnm/features/nations/career_nations_providers.dart';

import '../helpers/fake_poty_history.dart';
import '../helpers/pump_app.dart';
import '../helpers/seeded_save.dart' show kPhoneSize, realNations;

/// The Player of the Year history on a phone: the manager's nation's line,
/// then the winners by year (an old save's winners-only year at the bottom).
void main() {
  testWidgets('poty_history_phone', (tester) async {
    tester.view
      ..physicalSize = kPhoneSize
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpApp(
      const RepaintBoundary(
        key: Key('potyHistoryGolden'),
        child: PotyHistoryScreen(careerId: 1),
      ),
      overrides: [
        potyHistoryProvider(1).overrideWith((ref) async => fakePotyHistory()),
        careerNationsByIdProvider(
          1,
        ).overrideWith((ref) async => {for (final n in realNations) n.id: n}),
      ],
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byKey(const Key('potyHistoryGolden')),
      matchesGoldenFile('goldens/poty_history_phone.png'),
    );
  });
}
