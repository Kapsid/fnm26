import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/features/career/manager_history_providers.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/features/match/pitch/pitch_view_providers.dart'
    show kMatchViewModePrefsKey;
import 'package:fnm/features/settings/settings_providers.dart';
import 'package:fnm/features/share/match_share_card.dart';
import 'package:fnm/features/share/share_cabinet_button.dart';
import 'package:fnm/features/share/share_capture.dart';
import 'package:fnm/features/share/share_card_kit.dart';
import 'package:fnm/features/share/share_sheet.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/fixtures.dart';

/// The Share feature: where the button is, the format sheet, and that the
/// image handed to the platform is exactly Instagram's size.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, Object>{
    kMatchViewModePrefsKey: 'timeline',
  });

  const cze = Nation(
    id: 1,
    name: 'Czechia',
    code: 'CZE',
    confederation: Confederation.europe,
    ranking: 30,
    primaryColor: '#D7141A',
  );
  const bra = Nation(
    id: 2,
    name: 'Brazil',
    code: 'BRA',
    confederation: Confederation.southAmerica,
    ranking: 5,
    primaryColor: '#FEDD00',
  );

  ManagerHistory history({required bool won}) => ManagerHistory(
    managerName: 'Tomáš Hrubý',
    cycles: const [],
    played: 10,
    won: 5,
    drawn: 3,
    lost: 2,
    goalsFor: 14,
    goalsAgainst: 9,
    trophyCounts: won ? const {'world': 1} : const {},
    trophyWins: won
        ? const [(key: 'world', year: 2030, nation: cze)]
        : const [],
  );

  Widget app(Widget child, {List<Override> overrides = const []}) =>
      ProviderScope(
        overrides: overrides,
        child: MaterialApp(
          theme: AppTheme.theme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: Center(child: child)),
        ),
      );

  /// The PNG's width and height, from its header.
  (int, int) pngSize(Uint8List png) {
    final b = ByteData.sublistView(png);
    return (b.getUint32(16), b.getUint32(20));
  }

  group('trophy cabinet', () {
    testWidgets('offers Share once a trophy is won', (tester) async {
      await tester.pumpWidget(
        app(ShareCabinetButton(history: history(won: true))),
      );
      expect(find.byKey(ShareKeys.button), findsOneWidget);
    });

    testWidgets('an empty cabinet has no Share', (tester) async {
      await tester.pumpWidget(
        app(ShareCabinetButton(history: history(won: false))),
      );
      expect(find.byKey(ShareKeys.button), findsNothing);
    });

    testWidgets('the sheet offers square and story, and shares a story at '
        '1080 x 1920', (tester) async {
      final shared = <(Uint8List, String)>[];
      await tester.pumpWidget(
        app(
          ShareCabinetButton(history: history(won: true)),
          overrides: [
            shareImageSinkProvider.overrideWithValue(
              (png, name, origin) async => shared.add((png, name)),
            ),
          ],
        ),
      );
      await tester.tap(find.byKey(ShareKeys.button));
      await tester.pumpAndSettle();
      expect(find.byKey(ShareKeys.sheet), findsOneWidget);
      expect(find.byKey(ShareKeys.format(ShareFormat.square)), findsOneWidget);
      expect(find.byKey(ShareKeys.format(ShareFormat.story)), findsOneWidget);
      expect(find.text('Square'), findsOneWidget);
      expect(find.text('Story'), findsOneWidget);

      await tester.tap(find.byKey(ShareKeys.format(ShareFormat.story)));
      // The capture mixes real work (decoding, encoding the PNG) with the
      // test clock's timers: give it both until the image arrives.
      for (var i = 0; i < 100 && shared.isEmpty; i++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 30)),
        );
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(shared, hasLength(1));
      expect(pngSize(shared.single.$1), (1080, 1920));
      expect(shared.single.$2, endsWith('-story.png'));
      await tester.pumpAndSettle();
      expect(find.byKey(ShareKeys.sheet), findsNothing);
    });
  });

  testWidgets('a square card renders at exactly 1080 x 1080', (tester) async {
    late BuildContext context;
    await tester.pumpWidget(
      app(
        Builder(
          builder: (c) {
            context = c;
            return const SizedBox();
          },
        ),
      ),
    );
    final png = await tester.runAsync(
      () => renderShareCard(
        context,
        format: ShareFormat.square,
        flagCodes: const ['CZE', 'BRA'],
        card: const MatchShareCard(
          format: ShareFormat.square,
          data: MatchShareData(
            home: ShareSide(
              name: 'Czechia',
              code: 'CZE',
              color: Color(0xFFD7141A),
              goals: 2,
            ),
            away: ShareSide(
              name: 'Brazil',
              code: 'BRA',
              color: Color(0xFFFEDD00),
              goals: 1,
            ),
            competition: 'World Championship',
            dateLabel: '19 July 2030',
          ),
        ),
      ),
    );
    expect(pngSize(png!), (1080, 1080));
  });

  testWidgets('the full-time bar has Share beside Continue', (tester) async {
    tester.view
      ..physicalSize = const Size(400, 900)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    Player at(int id, int nationId, PlayerPosition p) =>
        player(id: id, nationId: nationId, position: p);
    List<Player> xi(int base, int nationId) => [
      at(base, nationId, PlayerPosition.gk),
      for (var i = 1; i <= 4; i++) at(base + i, nationId, PlayerPosition.cb),
      for (var i = 5; i <= 7; i++) at(base + i, nationId, PlayerPosition.cm),
      for (var i = 8; i <= 10; i++) at(base + i, nationId, PlayerPosition.st),
    ];
    const instructions = TacticalInstructions();
    final preview = MatchPreview(
      fixture: Fixture(
        id: 9,
        careerId: 1,
        competitionId: 1,
        matchday: 1,
        date: DateTime(2030, 6, 20),
        homeNationId: 1,
        awayNationId: 2,
        round: 'GROUP',
      ),
      result: const MatchResult(
        homeScore: 0,
        awayScore: 0,
        events: [],
        homeShots: 6,
        awayShots: 7,
        homePossession: 48,
      ),
      nations: const {1: cze, 2: bra},
      homeTeam: MatchTeam(
        nationId: 1,
        xi: xi(1, 1),
        instructions: instructions,
      ),
      awayTeam: MatchTeam(
        nationId: 2,
        xi: xi(101, 2),
        instructions: instructions,
      ),
      playerNationId: 1,
      bench: [for (var i = 50; i < 57; i++) at(i, 1, PlayerPosition.cm)],
      saveSeed: 7,
      ground: (
        stadium: 'Test Park',
        city: 'Testville',
        groundNationId: 1,
        capacity: 40000,
        attendance: 30000,
        soldOut: false,
      ),
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          matchPreviewProvider(1).overrideWith((ref) async => preview),
          soundHapticsEnabledProvider.overrideWith((ref) => false),
          matchAttemptSaltProvider.overrideWithValue(() => 0),
        ],
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
    expect(
      find.byKey(ShareKeys.button),
      findsNothing,
      reason: 'no Share while the match is being played',
    );
    // Watch it out to the final whistle, through half time's Continue (the
    // full-time Continue is the one with the tick).
    final fullTime = find.byIcon(Icons.check_rounded);
    for (var i = 0; i < 800 && fullTime.evaluate().isEmpty; i++) {
      await tester.pump(const Duration(milliseconds: 400));
      final halfTime = find.text('Continue');
      if (fullTime.evaluate().isEmpty && halfTime.evaluate().isNotEmpty) {
        await tester.tap(halfTime.first);
      }
    }
    expect(fullTime, findsOneWidget);
    expect(find.byKey(ShareKeys.button), findsOneWidget);
    expect(find.text('Share'), findsOneWidget);
  });
}
