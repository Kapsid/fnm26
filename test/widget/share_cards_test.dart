import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/shared/widgets/primary_button.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/world_pack/active_world.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/career/manager_history_providers.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/features/match/pitch/pitch_view_providers.dart'
    show kMatchViewModePrefsKey;
import 'package:fnm/features/settings/settings_providers.dart';
import 'package:fnm/features/share/cabinet_share_card.dart';
import 'package:fnm/features/share/match_share_card.dart';
import 'package:fnm/features/share/share_cabinet_button.dart';
import 'package:fnm/features/share/share_capture.dart';
import 'package:fnm/features/share/share_card_kit.dart';
import 'package:fnm/features/share/share_data.dart';
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

  /// Lets a capture finish: it mixes real work (decoding, encoding the PNG)
  /// with the test clock's timers, so give it both until [done].
  Future<void> settleCapture(WidgetTester tester, bool Function() done) async {
    for (var i = 0; i < 100 && !done(); i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 30)),
      );
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

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

    testWidgets('the My Career tab\'s big button reads Share my trophies', (
      tester,
    ) async {
      await tester.pumpWidget(
        app(ShareCabinetButton(history: history(won: true), big: true)),
      );
      expect(find.byKey(ShareKeys.button), findsOneWidget);
      expect(find.byType(PrimaryButton), findsOneWidget);
      expect(find.text('Share my trophies'), findsOneWidget);
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

      expect(find.byKey(ShareKeys.action(ShareAction.share)), findsOneWidget);
      expect(find.byKey(ShareKeys.action(ShareAction.save)), findsOneWidget);
      expect(find.text('Save to photos'), findsOneWidget);

      await tester.tap(find.byKey(ShareKeys.format(ShareFormat.story)));
      await tester.pump();
      await tester.tap(find.byKey(ShareKeys.action(ShareAction.share)));
      await settleCapture(tester, () => shared.isNotEmpty);
      expect(shared, hasLength(1));
      expect(pngSize(shared.single.$1), (1080, 1920));
      expect(shared.single.$2, endsWith('-story.png'));
      await tester.pumpAndSettle();
      expect(find.byKey(ShareKeys.sheet), findsNothing);
    });

    for (final (result, message) in [
      (ShareSaveResult.saved, 'Saved to photos'),
      (
        ShareSaveResult.denied,
        'FNM is not allowed to add to your photos. You can allow it in '
            'Settings.',
      ),
    ]) {
      testWidgets('Save to photos: ${result.name}', (tester) async {
        final saved = <(Uint8List, String)>[];
        final shared = <String>[];
        await tester.pumpWidget(
          app(
            ShareCabinetButton(history: history(won: true)),
            overrides: [
              shareImageSinkProvider.overrideWithValue(
                (png, name, origin) async => shared.add(name),
              ),
              shareImageSaverProvider.overrideWithValue((png, name) async {
                saved.add((png, name));
                return result;
              }),
            ],
          ),
        );
        await tester.tap(find.byKey(ShareKeys.button));
        await tester.pumpAndSettle();
        // Square is chosen to begin with.
        await tester.tap(find.byKey(ShareKeys.action(ShareAction.save)));
        await settleCapture(tester, () => saved.isNotEmpty);
        await tester.pump();
        expect(saved, hasLength(1));
        expect(pngSize(saved.single.$1), (1080, 1080));
        expect(saved.single.$2, endsWith('-square'));
        expect(shared, isEmpty, reason: 'saving never opens the share sheet');
        expect(find.text(message), findsOneWidget);
      });
    }
  });

  group('custom world trophy art', () {
    // A career on a world pack with its own World Championship picture
    // (here, the bundled European trophy's PNG, so it is plainly different).
    final custom = File('assets/trophies/europe.png').readAsBytesSync();
    final world = ActiveWorld(
      const WorldPack(
        uuid: 'u',
        name: 'Burgers',
        author: '',
        formatVersion: kPackFormatVersion,
        madeWithVersion: '1.1.0',
      ),
      trophies: {'world': custom},
    );

    testWidgets('the cabinet card draws the career world\'s picture', (
      tester,
    ) async {
      final l = lookupAppLocalizations(const Locale('en'));
      final data = cabinetShareData(l, history(won: true), world)!;
      expect(identical(data.trophies.single.image, custom), isTrue);
      expect(
        cabinetShareData(
          l,
          history(won: true),
          ActiveWorld.none,
        )!.trophies.single.image,
        isNull,
        reason: 'the default world keeps the bundled art',
      );

      await tester.pumpWidget(
        app(CabinetShareCard(data: data, format: ShareFormat.square)),
      );
      final drawn = find.byWidgetPredicate(
        (w) =>
            w is Image &&
            w.image is ResizeImage &&
            identical(
              ((w.image as ResizeImage).imageProvider as MemoryImage).bytes,
              custom,
            ),
      );
      expect(drawn, findsOneWidget);
    });

    testWidgets('the shared image carries it', (tester) async {
      final pngs = <Uint8List>[];
      for (final w in [ActiveWorld.none, world]) {
        pngs.clear();
        // A fresh scope for each world.
        await tester.pumpWidget(const SizedBox());
        await tester.pumpWidget(
          app(
            ShareCabinetButton(
              key: ValueKey(w),
              history: history(won: true),
            ),
            overrides: [
              activeWorldProvider.overrideWith((ref) => w),
              shareImageSinkProvider.overrideWithValue(
                (png, name, origin) async => pngs.add(png),
              ),
            ],
          ),
        );
        await tester.tap(find.byKey(ShareKeys.button));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(ShareKeys.action(ShareAction.share)));
        await settleCapture(tester, () => pngs.isNotEmpty);
        await tester.pumpAndSettle();
        expect(pngs, hasLength(1));
        if (identical(w, world)) {
          File('build/share_preview/captured_custom_trophy_square.png')
            ..createSync(recursive: true)
            ..writeAsBytesSync(pngs.single);
        } else {
          File('build/share_preview/captured_default_trophy_square.png')
            ..createSync(recursive: true)
            ..writeAsBytesSync(pngs.single);
        }
      }
      final a = File(
        'build/share_preview/captured_default_trophy_square.png',
      ).readAsBytesSync();
      final b = File(
        'build/share_preview/captured_custom_trophy_square.png',
      ).readAsBytesSync();
      expect(a, isNot(equals(b)), reason: 'the custom picture is drawn');
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
