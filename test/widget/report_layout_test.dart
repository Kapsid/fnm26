import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/career/manager_history_providers.dart';
import 'package:fnm/features/career/manager_history_screen.dart';
import 'package:fnm/features/messages/transfer_report.dart';

import '../helpers/pump_app.dart';

/// The two reports a playtest found running off the edge of a phone: the
/// manager's record results, and a transfer window's moves.
///
/// Both are pumped in CZECH, which is the longer language nearly everywhere,
/// at the narrowest screen the app supports and at a font a size up — which is
/// how a row that fits an English default stops fitting. `takeException` is how
/// Flutter reports a RenderFlex overflow.
void main() {
  ManagerResult result({
    required int forGoals,
    required int against,
    String opponentName = 'Bosna a Hercegovina',
  }) => (
    code: 'CZE',
    opponentCode: 'BIH',
    opponentName: opponentName,
    scoreFor: forGoals,
    scoreAgainst: against,
    date: DateTime(2032, 3, 24),
    round: 'GROUP',
  );

  testWidgets('the record results fit a narrow phone in Czech', (tester) async {
    tester.view
      ..physicalSize = const Size(320, 640)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpApp(
      Builder(
        builder: (context) => MediaQuery(
          // A size up. The row that broke measured its label in pixels, so it
          // held together at the default and only at the default.
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(1.3)),
          child: Localizations.override(
            context: context,
            locale: const Locale('cs'),
            child: const ManagerHistoryScreen(careerId: 1),
          ),
        ),
      ),
      overrides: [
        managerHistoryProvider(1).overrideWith(
          (ref) async => ManagerHistory(
            managerName: 'Martin Urbanczyk',
            cycles: const [],
            played: 40,
            won: 25,
            drawn: 8,
            lost: 7,
            goalsFor: 80,
            goalsAgainst: 35,
            titles: 2,
            biggestWin: result(forGoals: 7, against: 0),
            biggestLoss: result(
              forGoals: 0,
              against: 6,
              opponentName: 'Spojené arabské emiráty',
            ),
          ),
        ),
      ],
    );
    await tester.pumpAndSettle();

    expect(find.text('REKORDNÍ VÝSLEDKY'), findsOneWidget);
    expect(find.text('CZE 7–0 BIH'), findsOneWidget);
    expect(
      tester.takeException(),
      isNull,
      reason: 'nothing on the career screen may run off its card',
    );
  });

  testWidgets('a big transfer window pages instead of running on', (
    tester,
  ) async {
    // Thirty-four moves: a real window, and the length that turned the popup
    // into a scroll with its own button somewhere off the bottom.
    final rows = [
      for (var i = 0; i < 34; i++)
        (
          name: 'Jméno Příjmení $i',
          position: 'CM',
          from: 'Sportovní Klub $i',
          to: 'Athletic Association $i',
          fee: '€42.5M',
          abroad: i.isEven,
          rating: 0,
          change: null,
          step: 0,
        ),
    ];

    tester.view
      ..physicalSize = const Size(320, 900)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpApp(
      Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Builder(
              builder: (context) => Localizations.override(
                context: context,
                locale: const Locale('cs'),
                child: TransferTable(rows: rows),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // One page, not all thirty-four.
    expect(find.textContaining('Jméno Příjmení 0'), findsOneWidget);
    expect(find.textContaining('Jméno Příjmení 8'), findsNothing);
    expect(find.text('1–8 z 34'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Další'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Jméno Příjmení 8'), findsOneWidget);
    expect(find.text('9–16 z 34'), findsOneWidget);
    expect(
      tester.takeException(),
      isNull,
      reason: 'a paged move must not overflow its row',
    );
  });
}
