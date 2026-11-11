import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/core/theme/text_size.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/tactics/call_up_screen.dart';
import 'package:fnm/features/tactics/nomination_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';

import '../helpers/expect_whole.dart';
import '../helpers/test_database.dart';

/// "Can you also add filter by position in callup screen?" The lines were
/// already tabs (phone) and chips (tablet); within a line the pool can now be
/// narrowed to one position, as a view only: the squad is never touched.
void main() {
  late AppDatabase db;
  late int careerId;
  late List<Nation> nations;
  late ProviderContainer container;

  Player p(int id, PlayerPosition pos, int overall) => Player(
    id: id,
    nationId: 1,
    name: '${pos.label} $id',
    position: pos,
    age: 25,
    club: 'Club $id',
    attributes: PlayerAttributes(
      physical: overall,
      technical: overall,
      stamina: overall,
    ),
  );

  /// Every line with a spread of positions, so each chip has someone to show.
  const spread = <PlayerPosition, int>{
    PlayerPosition.gk: 2,
    PlayerPosition.lb: 2,
    PlayerPosition.cb: 3,
    PlayerPosition.rb: 2,
    PlayerPosition.dm: 2,
    PlayerPosition.cm: 3,
    PlayerPosition.am: 1,
    PlayerPosition.lm: 1,
    PlayerPosition.rm: 1,
    PlayerPosition.lw: 1,
    PlayerPosition.rw: 1,
    PlayerPosition.st: 3,
  };

  List<Player> pool() {
    var id = 100;
    return [
      for (final e in spread.entries)
        for (var i = 0; i < e.value; i++) p(id++, e.key, 60 + i),
    ];
  }

  setUp(() async {
    db = createTestDatabase();
    nations =
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

  Future<void> pumpCallUps(
    WidgetTester tester, {
    Size size = const Size(360, 690),
    bool tablet = false,
    double textScale = 1,
    Locale locale = const Locale('en'),
  }) async {
    tester.view
      ..devicePixelRatio = 1
      ..physicalSize = size;
    addTearDown(tester.view.reset);
    final scoped = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        squadDataProvider(careerId).overrideWith(
          (ref) async =>
              SquadData(pool: pool(), callUps: const {}, absences: const {}),
        ),
        callUpDraftProvider.overrideWith((ref, arg) async => <int>{}),
        nominationWindowProvider(careerId).overrideWith(
          (ref) async => (
            open: true,
            matches: const <Fixture>[],
            nations: {for (final n in nations) n.id: n},
            playerNationId: nations.first.id,
          ),
        ),
      ],
    );
    addTearDown(scoped.dispose);
    final screen = CallUpScreen(careerId: careerId);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: scoped,
        child: MaterialApp(
          theme: AppTheme.theme,
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(textScale)),
            child: child!,
          ),
          home: tablet ? TabletShellScope(child: screen) : screen,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Finder tab(String label) =>
      find.descendant(of: find.byType(Tab), matching: find.text(label));

  Finder chip(PositionCategory line, PlayerPosition? pos) =>
      find.byKey(CallUpScreen.positionChipKey(line, pos));

  /// The names of the players listed on the phone, one ListTile each.
  List<String> phoneNames(WidgetTester tester) => [
    for (final e in find.byType(ListTile).evaluate())
      for (final t
          in find
              .descendant(
                of: find.byWidget(e.widget),
                matching: find.byType(Text),
              )
              .evaluate())
        if ((t.widget as Text).data case final s?
            when RegExp(r'^[A-Z]{2} \d+$').hasMatch(s))
          s,
  ];

  const lines = {
    PositionCategory.defender: 'DEF',
    PositionCategory.midfielder: 'MID',
    PositionCategory.forward: 'FWD',
  };

  group('phone', () {
    testWidgets('the keepers have no position row: there is one position', (
      tester,
    ) async {
      await pumpCallUps(tester);
      expect(
        find.byKey(CallUpScreen.positionFilterKey(PositionCategory.goalkeeper)),
        findsNothing,
      );
      expect(find.byType(ListTile), findsNWidgets(2));
    });

    for (final MapEntry(key: line, value: label) in lines.entries) {
      testWidgets('$label: each position shows only itself, '
          'Everyone shows the line', (tester) async {
        await pumpCallUps(tester);
        await tester.tap(tab(label));
        await tester.pumpAndSettle();

        final positions = [
          for (final pos in PlayerPosition.values)
            if (pos.category == line) pos,
        ];
        final whole = positions.fold(0, (n, pos) => n + spread[pos]!);
        expect(chip(line, null), findsOneWidget);
        expect(find.byType(ListTile), findsNWidgets(whole));

        for (final pos in positions) {
          await tester.ensureVisible(chip(line, pos));
          await tester.tap(chip(line, pos));
          await tester.pumpAndSettle();
          final names = phoneNames(tester);
          expect(names, hasLength(spread[pos]), reason: '${pos.label} rows');
          expect(
            names.every((n) => n.startsWith('${pos.label} ')),
            isTrue,
            reason: 'only ${pos.label} under ${pos.label}: $names',
          );
        }

        await tester.ensureVisible(chip(line, null));
        await tester.tap(chip(line, null));
        await tester.pumpAndSettle();
        expect(find.byType(ListTile), findsNWidgets(whole));
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('a man filtered out stays named and counted', (tester) async {
      await pumpCallUps(tester);
      await tester.tap(tab('DEF'));
      await tester.pumpAndSettle();
      await tester.tap(chip(PositionCategory.defender, PlayerPosition.lb));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();
      expect(find.text('SQUAD · 1/$kMaxSquadSize'), findsOneWidget);
      // The chip says how many of its position are named.
      expect(find.text('LB 1'), findsOneWidget);

      await tester.tap(chip(PositionCategory.defender, PlayerPosition.cb));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.check_circle), findsNothing);
      expect(find.text('SQUAD · 1/$kMaxSquadSize'), findsOneWidget);
      expect(find.text('LB 1'), findsOneWidget);

      // Off to another line and back: still named, filter still on.
      await tester.tap(tab('MID'));
      await tester.pumpAndSettle();
      await tester.tap(tab('DEF'));
      await tester.pumpAndSettle();
      expect(find.text('SQUAD · 1/$kMaxSquadSize'), findsOneWidget);
      await tester.tap(chip(PositionCategory.defender, null));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    for (final locale in [const Locale('en'), const Locale('cs')]) {
      testWidgets('at the largest text size nothing overflows '
          '(${locale.languageCode})', (tester) async {
        await pumpCallUps(
          tester,
          textScale: kMaxAppTextScale,
          locale: locale,
        );
        await tester.tap(find.byType(Tab).at(2));
        await tester.pumpAndSettle();
        final row = find.byKey(
          CallUpScreen.positionFilterKey(PositionCategory.midfielder),
        );
        expect(row, findsOneWidget);
        expect(tester.takeException(), isNull);
        expectWhole(
          find.descendant(
            of: row,
            matching: find.byWidgetPredicate(
              (w) => w is RichText,
            ),
          ),
          'a position chip',
        );
        // Scrolls sideways to the last chip rather than squeezing it.
        await tester.ensureVisible(
          chip(PositionCategory.midfielder, PlayerPosition.rm),
        );
        await tester.tap(chip(PositionCategory.midfielder, PlayerPosition.rm));
        await tester.pumpAndSettle();
        expect(phoneNames(tester), hasLength(1));
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('tablet', () {
    int gridRows(WidgetTester tester) => find
        .descendant(
          of: find.byType(DataGrid<Player>),
          matching: find.byKey(const ValueKey('callUps.name')),
        )
        .evaluate()
        .length;

    List<String> gridNames(WidgetTester tester) => [
      for (final e
          in find
              .descendant(
                of: find.byType(DataGrid<Player>),
                matching: find.byKey(const ValueKey('callUps.name')),
              )
              .evaluate())
        for (final t
            in find
                .descendant(
                  of: find.byWidget(e.widget),
                  matching: find.byType(Text),
                )
                .evaluate())
          (t.widget as Text).data!,
    ];

    testWidgets('no position row until a line is chosen; then each position '
        'shows only itself', (tester) async {
      await pumpCallUps(tester, size: const Size(1194, 834), tablet: true);
      expect(find.byKey(CallUpScreen.tabletLayoutKey), findsOneWidget);
      // Everyone (the grid builds only what fits, so not all 22 rows).
      expect(gridRows(tester), greaterThan(7));
      for (final line in lines.keys) {
        expect(find.byKey(CallUpScreen.positionFilterKey(line)), findsNothing);
      }

      await tester.tap(find.text('DEF 0'));
      await tester.pumpAndSettle();
      expect(gridRows(tester), 7);
      for (final pos in [
        PlayerPosition.lb,
        PlayerPosition.cb,
        PlayerPosition.rb,
      ]) {
        await tester.tap(chip(PositionCategory.defender, pos));
        await tester.pumpAndSettle();
        final names = gridNames(tester);
        expect(names, hasLength(spread[pos]));
        expect(names.every((n) => n.startsWith('${pos.label} ')), isTrue);
      }
      await tester.tap(chip(PositionCategory.defender, null));
      await tester.pumpAndSettle();
      expect(gridRows(tester), 7);
      expect(tester.takeException(), isNull);
    });

    testWidgets('filtering never drops a named man', (tester) async {
      await pumpCallUps(tester, size: const Size(1194, 834), tablet: true);
      await tester.tap(find.text('DEF 0'));
      await tester.pumpAndSettle();
      await tester.tap(chip(PositionCategory.defender, PlayerPosition.rb));
      await tester.pumpAndSettle();
      final grid = find.byType(DataGrid<Player>);
      await tester.tap(
        find.descendant(of: grid, matching: find.byType(Checkbox)).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(chip(PositionCategory.defender, PlayerPosition.cb));
      await tester.pumpAndSettle();
      // Out of the pool's view, still in the squad panel and the count.
      expect(find.text('SQUAD · 1/$kMaxSquadSize'), findsOneWidget);
      expect(find.byType(ListTile), findsOneWidget);
      expect(find.text('RB 1'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('at the largest text size nothing overflows', (tester) async {
      await pumpCallUps(
        tester,
        size: const Size(1194, 834),
        tablet: true,
        textScale: kMaxAppTextScale,
      );
      await tester.tap(find.text('MID 0'));
      await tester.pumpAndSettle();
      expect(
        find.byKey(CallUpScreen.positionFilterKey(PositionCategory.midfielder)),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });
  });
}
