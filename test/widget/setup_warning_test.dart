import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/features/match/setup_warning.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../helpers/pump_app.dart';

/// A manager who never opened the tactics screen had no way of learning that
/// the armband and the set-piece takers were his to name — both quietly
/// default to "let the engine decide". This says so before kick-off.
void main() {
  Future<void> pumpSetup(
    WidgetTester tester, {
    required CaptainIssue? issue,
    required bool setPieces,
    String? name,
  }) async {
    await tester.pumpApp(
      const Scaffold(body: SquadSetupWarning(careerId: 1)),
      overrides: [
        squadSetupProvider(
          1,
        ).overrideWith(
          (ref) async =>
              (captain: issue, captainName: name, setPieces: setPieces),
        ),
      ],
    );
    await tester.pumpAndSettle();
  }

  Future<void> pumpWith(
    WidgetTester tester, {
    required bool captain,
    required bool setPieces,
  }) async => pumpSetup(
    tester,
    issue: captain ? null : CaptainIssue.unnamed,
    setPieces: setPieces,
  );

  testWidgets('a side with both set says nothing', (tester) async {
    await pumpWith(tester, captain: true, setPieces: true);
    expect(find.byIcon(Icons.error_outline_rounded), findsNothing);
  });

  testWidgets('no captain is called out', (tester) async {
    await pumpWith(tester, captain: false, setPieces: true);
    expect(
      find.text('No captain named. Tap to give somebody the armband'),
      findsOneWidget,
    );
  });

  testWidgets('no set-piece takers are called out', (tester) async {
    await pumpWith(tester, captain: true, setPieces: false);
    expect(
      find.text('No set-piece takers named. Tap to choose who steps up'),
      findsOneWidget,
    );
  });

  testWidgets('neither set reads as one warning, not two', (tester) async {
    await pumpWith(tester, captain: false, setPieces: false);
    expect(
      find.text('No captain and no set-piece takers. Tap to set them'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
  });

  testWidgets('a captain who is out is named, and so is the reason', (
    tester,
  ) async {
    // "Your captain cannot play this one" named nobody and gave no reason, so
    // a manager who knew who his captain was read it as the game losing him.
    await pumpSetup(
      tester,
      issue: CaptainIssue.injured,
      setPieces: true,
      name: 'Tomas Kral',
    );
    expect(
      find.text(
        'Tomas Kral is injured and cannot lead this one out. '
        'Tap to hand the armband on',
      ),
      findsOneWidget,
    );
  });

  testWidgets('a suspended captain reads as suspended, not injured', (
    tester,
  ) async {
    await pumpSetup(
      tester,
      issue: CaptainIssue.suspended,
      setPieces: true,
      name: 'Tomas Kral',
    );
    expect(
      find.text(
        'Tomas Kral is suspended for this one. Tap to hand the armband on',
      ),
      findsOneWidget,
    );
  });

  testWidgets('a captain left out of the squad says exactly that', (
    tester,
  ) async {
    await pumpSetup(
      tester,
      issue: CaptainIssue.dropped,
      setPieces: true,
      name: 'Tomas Kral',
    );
    expect(
      find.text(
        'Tomas Kral has the armband but is not in your squad. Tap to hand it on',
      ),
      findsOneWidget,
    );
  });

  testWidgets('tapping it lands on the tab that holds the armband', (
    tester,
  ) async {
    // Both the captain and the set-piece takers live on tab 1. The strip used
    // to open the tactics screen on its default tab, the lineup, leaving the
    // manager to go and find the thing he had just been told about.
    final visited = <String>[];
    final router = GoRouter(
      initialLocation: '/preview',
      routes: [
        GoRoute(
          path: '/preview',
          builder: (context, state) =>
              const Scaffold(body: SquadSetupWarning(careerId: 7)),
        ),
        GoRoute(
          path: Routes.tactics,
          builder: (context, state) {
            visited.add(state.uri.toString());
            return const Scaffold(body: Text('tactics'));
          },
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          squadSetupProvider(7).overrideWith(
            (ref) async => (
              captain: CaptainIssue.unnamed,
              captainName: null,
              setPieces: true,
            ),
          ),
        ],
        child: MaterialApp.router(
          theme: AppTheme.theme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.error_outline_rounded));
    await tester.pumpAndSettle();

    expect(visited, hasLength(1));
    expect(Uri.parse(visited.single).queryParameters['careerId'], '7');
    expect(
      Uri.parse(visited.single).queryParameters['tab'],
      '2',
      reason: 'roles & set pieces is where both decisions are made',
    );
  });
}
