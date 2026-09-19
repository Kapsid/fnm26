import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/features/tournaments/tournament_history.dart';

import '../helpers/pump_app.dart';

/// A shared edition's history row names every co-host, not just the primary.
///
/// The row used to read `Honour.hostId` alone, so a three-way co-hosted
/// tournament (USA/Canada/Mexico, say) showed only the first name in the
/// history list, even though `Honour.hostIds` had all three all along.
///
/// A three-way host string also used to run an unconstrained `Text` off the
/// end of the row: it fit English at the test harness's 800px default, but
/// clipped at real phone widths, worst in Czech (the longer language). The
/// width/locale cases below are pumped at 400px and 360px in both languages
/// and check `takeException` — how Flutter reports a RenderFlex overflow —
/// rather than the 800px default that let the regression through the first
/// time.
void main() {
  const names = {10: 'Spain', 11: 'Portugal', 12: 'Morocco'};
  const codes = {10: 'ESP', 11: 'POR', 12: 'MAR'};
  String name(int id) => names[id] ?? 'Unknown';
  String code(int id) => codes[id] ?? '??';

  Honour honour({List<int> hostIds = const [10, 11, 12]}) => (
    year: 2026,
    competition: 'World Championship',
    championId: 1,
    runnerUpId: 2,
    thirdId: null,
    thirdId2: null,
    hostId: hostIds.isEmpty ? null : hostIds.first,
    hostIds: hostIds,
    finalHomeScore: 2,
    finalAwayScore: 1,
    topScorerName: null,
    topScorerGoals: null,
  );

  Future<void> pumpAt(
    WidgetTester tester, {
    required double width,
    required Locale locale,
  }) async {
    tester.view
      ..physicalSize = Size(width, 800)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpApp(
      Builder(
        builder: (context) => Localizations.override(
          context: context,
          locale: locale,
          child: TournamentHistory(
            honours: [honour()],
            name: name,
            code: code,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  for (final width in [400.0, 360.0]) {
    for (final locale in [const Locale('en'), const Locale('cs')]) {
      testWidgets(
        'a three-way co-host fits at ${width.toInt()}px in '
        '${locale.languageCode} without overflowing',
        (tester) async {
          await pumpAt(tester, width: width, locale: locale);
          expect(
            tester.takeException(),
            isNull,
            reason: 'the host row must never run off a phone-width card',
          );
        },
      );
    }
  }

  testWidgets('a three-way co-host renders every host as a code', (
    tester,
  ) async {
    await tester.pumpApp(
      TournamentHistory(honours: [honour()], name: name, code: code),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('ESP'), findsOneWidget);
    expect(find.textContaining('POR'), findsOneWidget);
    expect(find.textContaining('MAR'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a single host still renders by name, not a bare code', (
    tester,
  ) async {
    await tester.pumpApp(
      TournamentHistory(
        honours: [
          honour(hostIds: const [10]),
        ],
        name: name,
        code: code,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Host: Spain'), findsOneWidget);
    expect(find.textContaining('ESP'), findsNothing);
  });
}
