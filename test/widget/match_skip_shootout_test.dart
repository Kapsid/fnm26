import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/config/testing_flags.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/features/match/penalty_order_sheet.dart';
import 'package:fnm/features/settings/settings_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/fixtures.dart';

/// Skipping to full time must not answer the shootout for the manager.
///
/// This is the whole reason the control was given back carefully rather than
/// reverted. The old `_skip()` was a BYPASS: it set `_penOrderAsked = true` and
/// jumped `_penRevealed` to `_penTotal`, so there were no kicks left to name
/// takers for and the automatic order was accepted on his behalf without a word
/// — a manager could reach the end of a tournament tie having never been asked
/// who takes them. The restored control must ask when he has not been asked,
/// and must not ask again when he has. Both directions are checked here, in one
/// run through a tie that really goes to penalties.

/// A level semi-final, ready to be skipped. [saveSeed] is what decides whether
/// extra time settles the tie or a shootout does; the one used below was picked
/// because it gives a shootout (the test asserts it did).
MatchPreview levelKnockout({required int saveSeed}) {
  Player at(int id, int nationId, PlayerPosition position) =>
      player(id: id, nationId: nationId, position: position);
  List<Player> xi(int base, int nationId) => [
    at(base, nationId, PlayerPosition.gk),
    for (var i = 1; i <= 4; i++) at(base + i, nationId, PlayerPosition.cb),
    for (var i = 5; i <= 7; i++) at(base + i, nationId, PlayerPosition.cm),
    for (var i = 8; i <= 10; i++) at(base + i, nationId, PlayerPosition.st),
  ];

  const instructions = TacticalInstructions();
  return MatchPreview(
    fixture: Fixture(
      id: 7,
      careerId: 1,
      competitionId: 1,
      matchday: 1,
      date: DateTime(2026, 7, 7),
      homeNationId: 1,
      awayNationId: 2,
      round: 'SF', // a knockout tie: level after 90 means extra time
    ),
    // Goalless, so the tie is level at the whistle and the drama is all in
    // what comes after it.
    result: const MatchResult(
      homeScore: 0,
      awayScore: 0,
      events: [],
      homeShots: 4,
      awayShots: 4,
      homePossession: 50,
    ),
    nations: {1: nation(id: 1), 2: nation(id: 2)},
    homeTeam: MatchTeam(nationId: 1, xi: xi(1, 1), instructions: instructions),
    awayTeam: MatchTeam(
      nationId: 2,
      xi: xi(101, 2),
      instructions: instructions,
    ),
    playerNationId: 1,
    bench: [for (var i = 50; i < 57; i++) at(i, 1, PlayerPosition.cm)],
    saveSeed: saveSeed,
    ground: (
      stadium: 'Test Park',
      city: 'Testville',
      groundNationId: 1,
      capacity: 40000,
      attendance: 30000,
      soldOut: false,
    ),
  );
}

Future<ProviderContainer> pumpMatch(
  WidgetTester tester, {
  required int saveSeed,
}) async {
  final c = ProviderContainer(
    overrides: [
      matchPreviewProvider(
        1,
      ).overrideWith((ref) async => levelKnockout(saveSeed: saveSeed)),
      soundHapticsEnabledProvider.overrideWith((ref) => false),
    ],
  );
  addTearDown(c.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: c,
      child: MaterialApp(
        theme: AppTheme.theme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const MatchScreen(careerId: 1),
      ),
    ),
  );
  await tester.pump();
  await tester.pump();
  return c;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, Object>{});

  /// A tie this seed sends all the way to penalties.
  const shootoutSeed = 42;

  /// A tie this seed settles in extra time, so nothing is ever asked.
  const extraTimeSeed = 2026;

  // Both tests are about the aid itself, so both stand down with it: turning
  // [kShowSkipMatch] off must stay the one edit it promises to be, not one
  // edit and then a test file to go and fix. (The bar's own test covers the
  // off state; there is no skip pill to press once the flag is false.)
  const aidOff = !kShowSkipMatch;

  testWidgets('skipping a tie that goes to penalties asks exactly once', (
    tester,
  ) async {
    tester.view
      ..physicalSize = const Size(400, 900)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await pumpMatch(tester, saveSeed: shootoutSeed);

    final skip = find.byIcon(Icons.skip_next_rounded);
    expect(skip, findsOneWidget, reason: 'the skip pill must be on the bar');

    // --- Direction one: skipping must not leave him un-asked ---------------
    // The clock is barely out of the tunnel. The old control would have jumped
    // it to the end of the shootout with the automatic takers.
    await tester.tap(skip);
    await tester.pumpAndSettle();

    expect(
      find.byType(PenaltyOrderSheet),
      findsOneWidget,
      reason:
          'skipping past a shootout must still ask who takes them — if this '
          'fails, either the skip bypassed the sheet again, or seed $shootoutSeed no '
          'longer sends this tie to penalties (check the whistle, not the fix)',
    );

    // He names them (the automatic order, confirmed) and the kicks begin.
    await tester.tap(find.text('Take them'));
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
    expect(find.byType(PenaltyOrderSheet), findsNothing);

    // --- Direction two: he must not be asked twice -------------------------
    // The kicks are being revealed one at a time and the bar is still the live
    // one, so the aid is there to be pressed again. This is the tap that used
    // to have nothing to protect it.
    final skipAgain = find.byIcon(Icons.skip_next_rounded);
    expect(
      skipAgain,
      findsOneWidget,
      reason: 'the shootout is still revealing, so the live bar is still up',
    );
    await tester.tap(skipAgain);
    await tester.pumpAndSettle();

    expect(
      find.byType(PenaltyOrderSheet),
      findsNothing,
      reason: 'the takers are already named: nothing may ask for them again',
    );

    // And it really did finish the match rather than leaving it mid-shootout:
    // full time is the Continue bar, and no amount of further time reopens the
    // sheet behind it.
    expect(find.text('Continue'), findsOneWidget);
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 750));
      expect(find.byType(PenaltyOrderSheet), findsNothing);
    }
  }, skip: aidOff);

  // The control: the sheet above appears because of the SHOOTOUT, not because
  // skipping opens sheets. A tie extra time settles is skipped straight to the
  // final whistle with nothing asked of anybody.
  testWidgets('skipping a tie settled in extra time asks nothing', (
    tester,
  ) async {
    tester.view
      ..physicalSize = const Size(400, 900)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await pumpMatch(tester, saveSeed: extraTimeSeed);
    await tester.tap(find.byIcon(Icons.skip_next_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(PenaltyOrderSheet), findsNothing);
    expect(
      find.text('Continue'),
      findsOneWidget,
      reason: 'skip takes a match with no shootout straight to full time',
    );
  }, skip: aidOff);
}
