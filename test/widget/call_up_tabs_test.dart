import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/features/tactics/call_up_screen.dart';
import 'package:fnm/features/tactics/nomination_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/expect_whole.dart';
import '../helpers/test_database.dart';

/// Picking a squad used to be one list of sixty-odd names: it overflowed, it
/// had to be scrolled through line by line, and the club-standing label
/// ("Plays every week") ran into the badges beside it.
void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late int careerId;

  Player p(int id, String name, PlayerPosition pos, int overall) => Player(
    id: id,
    nationId: 1,
    name: name,
    position: pos,
    age: 25,
    club: 'Club $id',
    attributes: PlayerAttributes(
      physical: overall,
      technical: overall,
      stamina: overall,
    ),
  );

  /// Three keepers, eight defenders, eight midfielders and five forwards — the
  /// shape of a real pool, and more than fits on one phone screen.
  List<Player> mixedSquad() => [
    for (var i = 0; i < 3; i++)
      p(1 + i, 'Keeper $i', PlayerPosition.gk, 70 + i),
    for (var i = 0; i < 8; i++) p(11 + i, 'Back $i', PlayerPosition.cb, 70 + i),
    for (var i = 0; i < 8; i++) p(21 + i, 'Mid $i', PlayerPosition.cm, 70 + i),
    for (var i = 0; i < 5; i++)
      p(31 + i, 'Forward $i', PlayerPosition.st, 70 + i),
  ];

  setUp(() async {
    db = createTestDatabase();
    final nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Nation.fromJson(e as Map<String, Object?>))
            .toList();
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: const []),
        ),
      ],
    );
    await container.read(seedLoaderProvider).ensureSeeded();
    careerId =
        (await container
                .read(careerServiceProvider)
                .create(nationId: nations.first.id, managerName: 'M'))
            .valueOrNull!
            .id;
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  Future<void> pumpCallUps(WidgetTester tester) async {
    tester.view
      ..devicePixelRatio = 1
      ..physicalSize = const Size(360, 690);
    addTearDown(tester.view.reset);

    final scoped = ProviderContainer(
      parent: null,
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        squadDataProvider(careerId).overrideWith(
          (ref) async => SquadData(
            pool: mixedSquad(),
            callUps: const {},
            absences: const {},
          ),
        ),
        // No stored draft and an open window, so what the screen shows is only
        // what this test ticked — nothing arrives from the database late and
        // rewrites the selection mid-test.
        callUpDraftProvider.overrideWith((ref, arg) async => <int>{}),
        nominationWindowProvider(careerId).overrideWith(
          (ref) async => (
            open: true,
            matches: const <Fixture>[],
            nations: const <int, Nation>{},
            playerNationId: 1,
          ),
        ),
      ],
    );
    addTearDown(scoped.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: scoped,
        child: MaterialApp(
          theme: AppTheme.theme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: CallUpScreen(careerId: careerId),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// How many player rows are on screen — one ListTile each.
  int rows(WidgetTester tester) => find.byType(ListTile).evaluate().length;

  /// How many of them are ticked into the squad.
  int ticked(WidgetTester tester) =>
      find.byIcon(Icons.check_circle).evaluate().length;

  testWidgets('the call-up screen groups players by line', (tester) async {
    await pumpCallUps(tester);

    // One tab per line. ('GK' also names each keeper's position chip, so the
    // tab is looked for inside the tab bar.)
    for (final line in ['GK', 'DEF', 'MID', 'FWD']) {
      expect(
        find.descendant(of: find.byType(Tab), matching: find.text(line)),
        findsOneWidget,
        reason: 'a $line tab',
      );
    }

    // It opens on the keepers, and shows keepers and nobody else.
    expect(find.text('Keeper 0'), findsOneWidget);
    expect(find.text('Back 0'), findsNothing);
    expect(rows(tester), 3);

    // Nothing overflows at phone width.
    expect(tester.takeException(), isNull);
    expectNothingCut(tester);
  });

  testWidgets('a tab change shows that line and no other', (tester) async {
    await pumpCallUps(tester);

    await tester.tap(find.text('MID'));
    await tester.pumpAndSettle();

    expect(find.text('Mid 0'), findsOneWidget);
    expect(find.text('Keeper 0'), findsNothing);
    expect(rows(tester), 8);
    expect(tester.takeException(), isNull);
    expectNothingCut(tester);
  });

  testWidgets('selection survives a tab change — it is one squad', (
    tester,
  ) async {
    await pumpCallUps(tester);

    await tester.tap(find.byType(ListTile).first);
    await tester.pumpAndSettle();
    expect(find.text('SQUAD · 1/$kMaxSquadSize'), findsOneWidget);

    await tester.tap(find.text('DEF'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('GK'));
    await tester.pumpAndSettle();

    // Still named, and still counted.
    expect(ticked(tester), 1);
    expect(find.text('SQUAD · 1/$kMaxSquadSize'), findsOneWidget);
  });

  testWidgets('the pool gets the screen, not a peephole', (tester) async {
    await pumpCallUps(tester);

    // The chrome above the pool scrolls away with it, so the list is not
    // squeezed into whatever is left under a fixed header. Before this, the
    // eight defenders had a window a couple of names tall.
    await tester.tap(find.text('DEF'));
    await tester.pumpAndSettle();

    final listHeight = tester
        .getSize(find.byType(CustomScrollView).first)
        .height;
    final screenHeight = tester.getSize(find.byType(Scaffold)).height;
    expect(
      listHeight,
      greaterThan(screenHeight * 0.6),
      reason: 'the pool should own most of the screen',
    );
    expect(tester.takeException(), isNull);
    expectNothingCut(tester);
  });

  testWidgets('the line tabs stay put while the pool scrolls', (tester) async {
    await pumpCallUps(tester);
    await tester.tap(find.text('DEF'));
    await tester.pumpAndSettle();

    final before = tester.getTopLeft(
      find.descendant(of: find.byType(Tab), matching: find.text('DEF')),
    );
    await tester.drag(find.text('Back 0'), const Offset(0, -220));
    await tester.pumpAndSettle();

    // The header above has scrolled away; the tabs have not.
    final after = tester.getTopLeft(
      find.descendant(of: find.byType(Tab), matching: find.text('DEF')),
    );
    expect(after.dy, lessThanOrEqualTo(before.dy));
    expect(find.byType(TabBar), findsOneWidget);
    expect(tester.takeException(), isNull);
    expectNothingCut(tester);
  });
}
