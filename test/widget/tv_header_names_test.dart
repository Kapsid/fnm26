import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// The tablet 2D TV's score bug prints each nation's full name where it
/// fits its side of the bar, measured, and the code where it does not.
void main() {
  const TvStats stats = (
    shots: (3, 1),
    xg: (0.8, 0.2),
    yellows: (0, 0),
    reds: (0, 0),
    possession: null,
    lastGoal: null,
  );

  Future<void> pump(
    WidgetTester tester, {
    required double width,
    required String homeName,
    required String awayName,
  }) async {
    tester.view
      ..physicalSize = Size(width + 40, 400)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MediaQuery(
          data: MediaQueryData(
            size: Size(width + 40, 400),
            disableAnimations: true,
          ),
          child: Scaffold(
            body: Center(
              child: SizedBox(
                width: width,
                child: MatchTvHeader(
                  homeCode: 'CZE',
                  awayCode: 'POR',
                  homeName: homeName,
                  awayName: awayName,
                  homeScore: 1,
                  awayScore: 0,
                  clock: '30',
                  live: true,
                  stats: stats,
                  homeNationId: 1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('short names are printed in full', (tester) async {
    await pump(
      tester,
      width: 640,
      homeName: 'Velmora',
      awayName: 'Ostravia',
    );
    expect(tester.takeException(), isNull);
    expect(find.byKey(matchBugSideNameKey), findsNWidgets(2));
    expect(find.text('VELMORA'), findsOneWidget);
    expect(find.text('OSTRAVIA'), findsOneWidget);
    expect(find.text('CZE'), findsNothing);
    expect(find.text('POR'), findsNothing);
  });

  testWidgets('a name that does not fit falls back to the code', (
    tester,
  ) async {
    await pump(
      tester,
      width: 640,
      homeName: 'Velmora',
      awayName: 'United Federated Isles of Kestrelvania and Lower Morrow',
    );
    expect(tester.takeException(), isNull);
    expect(find.text('VELMORA'), findsOneWidget);
    expect(find.text('POR'), findsOneWidget);
    expect(
      find.textContaining('KESTRELVANIA'),
      findsNothing,
      reason: 'never a cut or shrunken name',
    );
  });

  testWidgets('a narrow bar keeps the codes', (tester) async {
    await pump(
      tester,
      width: 480,
      homeName: 'Ostravia Republic',
      awayName: 'Velmora Federation',
    );
    expect(tester.takeException(), isNull);
    expect(find.byKey(matchBugSideNameKey), findsNothing);
    expect(find.text('CZE'), findsOneWidget);
    expect(find.text('POR'), findsOneWidget);
  });
}
