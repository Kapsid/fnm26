import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/tournaments/tournament_holders_row.dart';

import '../helpers/expect_whole.dart';
import '../helpers/pump_app.dart';

/// The holders strip on a tournament detail screen.
///
/// It says nothing at all before the trophy has ever been won, and it has to
/// survive a phone's width in both languages: Czech runs longer than English
/// everywhere, and the last row that broke at 360px broke there first. The
/// width cases check `takeException` — how Flutter reports a RenderFlex
/// overflow — rather than the harness's roomy 800px default.
void main() {
  const names = {10: 'Netherlands', 11: 'Czechia'};
  const codes = {10: 'NED', 11: 'CZE'};
  String name(int id) => names[id] ?? 'Unknown';
  String code(int id) => codes[id] ?? '??';

  Future<void> pumpAt(
    WidgetTester tester, {
    required double width,
    required Locale locale,
    ({int nationId, int year})? holders = (nationId: 10, year: 2022),
  }) async {
    tester.view
      ..physicalSize = Size(width, 800)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpApp(
      TournamentHoldersRow(holders: holders, code: code, name: name),
      locale: locale,
    );
    await tester.pumpAndSettle();
  }

  testWidgets('a trophy nobody has won yet shows no holders row', (
    tester,
  ) async {
    await tester.pumpApp(
      TournamentHoldersRow(holders: null, code: code, name: name),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SizedBox), findsOneWidget);
    expect(find.text('NED'), findsNothing);
    expect(find.textContaining('2022'), findsNothing);
    expect(tester.takeException(), isNull);
    expectNothingCut(tester);
  });

  testWidgets('the holders are named with the year they won it', (
    tester,
  ) async {
    await tester.pumpApp(
      TournamentHoldersRow(
        holders: (nationId: 10, year: 2022),
        code: code,
        name: name,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Netherlands'), findsOneWidget);
    expect(find.textContaining('2022'), findsOneWidget);
    expect(tester.takeException(), isNull);
    expectNothingCut(tester);
  });

  for (final width in [400.0, 360.0]) {
    for (final locale in [const Locale('en'), const Locale('cs')]) {
      testWidgets(
        'the holders row fits ${width.toInt()}px in ${locale.languageCode} '
        'without overflowing',
        (tester) async {
          // The longest nation name in the pool, so the row is under the most
          // pressure a real save can put on it.
          await pumpAt(
            tester,
            width: width,
            locale: locale,
            holders: (nationId: 11, year: 2022),
          );
          expect(
            tester.takeException(),
            isNull,
            reason: 'the holders row must never run off a phone-width card',
          );
          // The year is the part that must survive: the nation name is the
          // one allowed to ellipsize.
          expect(find.textContaining('2022'), findsOneWidget);
        },
      );
    }
  }
}
