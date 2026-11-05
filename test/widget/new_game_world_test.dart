import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/world_pack/active_world.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/career/new_game_screen.dart';
import 'package:fnm/features/career/play_time.dart';
import 'package:fnm/features/career/saves_screen.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/editor/pack_home_screen.dart';
import 'package:fnm/features/home/home_screen.dart';
import 'package:fnm/features/settings/settings_providers.dart';
import 'package:fnm/features/settings/settings_screen.dart';
import 'package:fnm/features/world_pack/world_choice.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/editor_app.dart';
import '../helpers/history_fixtures.dart';
import '../helpers/seeded_save.dart';
import '../helpers/test_database.dart';

/// The app over [db] (seeded on first use), as a fresh launch has it: a new
/// container, so nothing but the database and the stored settings carries
/// over from a container before it (a restart).
Future<ProviderContainer> _launch(
  WidgetTester tester,
  AppDatabase db, {
  FormFactor formFactor = FormFactor.phone,
  bool premium = false,
}) async {
  final c = ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
      premiumUnlockedProvider.overrideWith((ref) => premium),
      seedSourceProvider.overrideWithValue(
        InMemorySeedSource(nationList: realNations, playerList: realPlayers),
      ),
      formFactorProvider.overrideWithValue(formFactor),
    ],
  );
  addTearDown(c.dispose);
  await tester.runAsync(() => c.read(seedLoaderProvider).ensureSeeded());
  return c;
}

AppDatabase _db() {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final db = createTestDatabase();
  addTearDown(db.close);
  return db;
}

Future<void> _open(
  WidgetTester tester,
  ProviderContainer c,
  String location, {
  Size size = kPhoneSize,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final router = c.read(routerProvider)..go(location);
  // A new key per container: a restart builds the whole app afresh.
  await tester.pumpWidget(
    UncontrolledProviderScope(
      key: ObjectKey(c),
      container: c,
      child: MaterialApp.router(
        theme: AppTheme.theme,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    ),
  );
  await settle(tester);
}

/// A complete Czech squad whose surnames all start "Zzpack".
List<PackPlayer> _packSquad() => [
  for (final p in testSquad())
    PackPlayer(
      id: p.id,
      name: 'Karel Zzpack${p.id - kPackPlayerIdBase}',
      age: p.age,
      position: p.position,
      attributes: p.attributes,
      potential: p.potential,
    ),
];

Finder _chipText(String name) => find.descendant(
  of: find.byKey(WorldChip.chipKey),
  matching: find.text(enL.worldChip(name)),
);

Future<void> _choose(WidgetTester tester, Finder row) async {
  await tester.ensureVisible(row);
  await tester.tap(row);
  await settle(tester);
}

/// Pumps, with real time for the database, until [done].
Future<void> _pumpUntil(WidgetTester tester, bool Function() done) async {
  for (var i = 0; i < 3000 && !done(); i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 30)),
    );
    await tester.pump();
  }
  expect(done(), isTrue);
}

Future<List<Career>> _careers(WidgetTester tester, ProviderContainer c) async {
  late List<Career> all;
  await tester.runAsync(() async {
    all = await c.read(careerRepositoryProvider).all();
  });
  return all;
}

void main() {
  // Entering a career on a pack puts its world on show for the whole app.
  tearDown(() => ActiveWorld.current = ActiveWorld.none);
  // The first career here is made in the test's fake zone (a tap on Start),
  // so the name lists it reads are first loaded there, and the asset bundle
  // keeps that load's future: a later test awaiting it from its own zone
  // would wait for ever.
  tearDown(rootBundle.clear);

  testWidgets(
    'choosing a pack starts a career on it; the squad screen shows the pack '
    'names',
    timeout: const Timeout.factor(6),
    (tester) async {
      final c = await _launch(tester, _db());
      final cze = nationIdOf('CZE');
      final id = await insertPack(
        tester,
        c,
        testPack('Mine', squads: {cze: _packSquad()}),
      );
      await _open(tester, c, Routes.nations);
      expect(_chipText(enL.worldDefault), findsOneWidget);

      await tester.tap(find.byKey(WorldChip.chipKey));
      await settle(tester);
      expect(find.byKey(WorldChoiceSheet.defaultKey), findsOneWidget);
      await _choose(tester, find.byKey(WorldChoiceSheet.packKey(id)));
      expect(_chipText('Mine'), findsOneWidget);
      expect(c.read(newGameWorldProvider), id);

      c.read(routerProvider).go('${Routes.newGame}?nationId=$cze');
      await settle(tester);
      await tester.tap(find.byKey(NewGameScreen.startKey));
      await _pumpUntil(
        tester,
        () =>
            c.read(routerProvider).routeInformationProvider.value.uri.path ==
            Routes.hub,
      );
      await settle(tester);

      final made = (await _careers(tester, c)).single;
      late WorldPack? world;
      await tester.runAsync(() async {
        world = (await c.read(worldPackRepositoryProvider).forCareer(made.id))
            ?.pack;
      });
      expect(world?.name, 'Mine');
      // The chip changed that one career only: the next starts on Default.
      expect(c.read(newGameWorldProvider), isNull);

      c.read(routerProvider).go('${Routes.tactics}?careerId=${made.id}');
      await settle(tester);
      // The pitch shows the pack's own players, by surname in capitals.
      expect(find.text('ZZPACK1'), findsOneWidget);
      // The hub started the play clock and create() (run in this test's
      // fake zone) invalidated the saves list: stop the one and rebuild the
      // other before teardown.
      await tester.runAsync(() => c.read(playTimeTrackerProvider).stop());
      await rebuildSavesInFakeZone(tester, SeededSave(c, made));
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets('an incomplete pack is greyed out with its reason', (
    tester,
  ) async {
    final c = await _launch(tester, _db());
    final cze = nationIdOf('CZE');
    final id = await insertPack(
      tester,
      c,
      testPack('Short', squads: {cze: testSquad(gk: 1, def: 9)}),
    );
    await _open(tester, c, Routes.nations);
    await tester.tap(find.byKey(WorldChip.chipKey));
    await settle(tester);

    final row = find.byKey(WorldChoiceSheet.packKey(id));
    expect(
      find.descendant(
        of: row,
        matching: find.text('Czechia: ${enL.editorIssueGoalkeepers(2)}'),
      ),
      findsOneWidget,
    );
    await _choose(tester, row);
    // Nothing chosen: the sheet stays and the chip is still on Default.
    expect(row, findsOneWidget);
    expect(c.read(newGameWorldProvider), isNull);
  });

  testWidgets(
    'a pack naming nation 999 is incompatible, cannot be chosen, and Remove '
    'fixes it',
    timeout: const Timeout.factor(3),
    (tester) async {
      final c = await _launch(tester, _db());
      final cze = nationIdOf('CZE');
      final id = await insertPack(
        tester,
        c,
        testPack('Old', squads: {cze: testSquad(), 999: testSquad()}),
      );
      await _open(tester, c, Routes.nations);
      await tester.tap(find.byKey(WorldChip.chipKey));
      await settle(tester);
      final row = find.byKey(WorldChoiceSheet.packKey(id));
      expect(
        find.descendant(
          of: row,
          matching: find.text(enL.editorStatusAttention),
        ),
        findsOneWidget,
      );
      await _choose(tester, row);
      expect(c.read(newGameWorldProvider), isNull);

      // The list and the home both say so.
      c.read(routerProvider).go(Routes.editor);
      await settle(tester);
      expect(find.text(enL.editorStatusAttention), findsOneWidget);
      c.read(routerProvider).go(editorPackLocation(id));
      await settle(tester);
      expect(find.byKey(PackHomeScreen.attentionKey), findsOneWidget);
      expect(find.byKey(PackHomeScreen.removeKey(0)), findsOneWidget);
      expect(find.byKey(PackHomeScreen.removeKey(1)), findsNothing);

      await tester.tap(find.byKey(PackHomeScreen.removeKey(0)));
      await settle(tester);
      expect(find.byKey(PackHomeScreen.readyKey), findsOneWidget);
      expect(
        c.read(packEditorProvider(id)).valueOrNull!.squads.keys,
        [cze],
      );
      // One undo step brings exactly that entry back.
      await tester.tap(find.byKey(PackHomeScreen.undoKey));
      await settle(tester);
      expect(find.byKey(PackHomeScreen.attentionKey), findsOneWidget);
      await tester.tap(find.byKey(PackHomeScreen.removeKey(0)));
      await settle(tester);
      expect(find.byKey(PackHomeScreen.readyKey), findsOneWidget);

      // Back to the list (which writes the edit), then New Game: it can be
      // chosen now.
      await tester.tap(find.byIcon(Icons.arrow_back));
      await settle(tester);
      c.read(routerProvider).go(Routes.nations);
      await settle(tester);
      await tester.tap(find.byKey(WorldChip.chipKey));
      await settle(tester);
      await _choose(tester, find.byKey(WorldChoiceSheet.packKey(id)));
      expect(c.read(newGameWorldProvider), id);
    },
  );

  for (final (label, formFactor, size) in [
    ('phone', FormFactor.phone, kPhoneSize),
    ('tablet', FormFactor.tablet, kTabletSize),
  ]) {
    testWidgets(
      'save card shows the world name, $label',
      timeout: const Timeout.factor(6),
      (tester) async {
        final c = await _launch(
          tester,
          _db(),
          formFactor: formFactor,
          premium: true,
        );
        final cze = nationIdOf('CZE');
        final id = await insertPack(
          tester,
          c,
          testPack('Mine', squads: {cze: _packSquad()}),
        );
        late Career onPack;
        await tester.runAsync(() async {
          final careers = c.read(careerServiceProvider);
          await careers.create(nationId: cze, managerName: 'D', rngSeed: 1);
          onPack = (await careers.create(
            nationId: cze,
            managerName: 'P',
            rngSeed: 2,
            worldPackId: id,
          )).valueOrNull!;
        });
        // The pack can go: the career keeps its own copy, and its name.
        await tester.runAsync(
          () => c.read(worldPackServiceProvider).delete(id),
        );

        // Played last: it heads the list, the tablet's pane and the home.
        await tester.runAsync(
          () =>
              c.read(careerRepositoryProvider).touch(onPack.id, DateTime(2099)),
        );

        await _open(tester, c, Routes.saves, size: size);
        expect(find.byKey(SaveTile.worldKey), findsOneWidget);
        expect(
          find.descendant(
            of: find.byKey(SaveTile.worldKey),
            matching: find.text('Mine'),
          ),
          findsOneWidget,
        );
        if (formFactor == FormFactor.phone) {
          // Only the pack career's tile names a world.
          final tiles = find.byType(SaveTile);
          expect(tiles, findsNWidgets(2));
          final onPackTile = find.ancestor(
            of: find.byKey(SaveTile.worldKey),
            matching: find.byType(SaveTile),
          );
          expect(tester.widget<SaveTile>(onPackTile).save.id, onPack.id);
        }

        // The continue card leads with the career played last.
        c.read(routerProvider).go(Routes.home);
        await settle(tester);
        expect(
          find.descendant(
            of: find.byKey(HomeScreen.continueWorldKey),
            matching: find.text('Mine'),
          ),
          findsOneWidget,
        );
      },
    );
  }

  testWidgets('default stays the default choice after the app restarts', (
    tester,
  ) async {
    final db = _db();
    var c = await _launch(tester, db);
    final cze = nationIdOf('CZE');
    final id = await insertPack(
      tester,
      c,
      testPack('Mine', squads: {cze: _packSquad()}),
    );
    await _open(tester, c, Routes.nations);
    await tester.tap(find.byKey(WorldChip.chipKey));
    await settle(tester);
    await _choose(tester, find.byKey(WorldChoiceSheet.packKey(id)));
    expect(_chipText('Mine'), findsOneWidget);

    // The chip is for one career: it is not the Settings default.
    c = await _launch(tester, db);
    await _open(tester, c, Routes.nations);
    expect(_chipText(enL.worldDefault), findsOneWidget);
    expect(c.read(newGameWorldProvider), isNull);
    await _open(tester, c, Routes.settings);
    expect(
      find.descendant(
        of: find.byKey(SettingsScreen.defaultWorldKey),
        matching: find.text(enL.worldDefault),
      ),
      findsOneWidget,
    );
  });

  testWidgets(
    'a default world set in Settings is preselected in New Game after a '
    'restart; deleting that pack falls back to Default',
    (tester) async {
      final db = _db();
      var c = await _launch(tester, db);
      final cze = nationIdOf('CZE');
      final id = await insertPack(
        tester,
        c,
        testPack('Mine', squads: {cze: _packSquad()}),
      );
      await _open(tester, c, Routes.settings);
      await tester.tap(find.byKey(SettingsScreen.defaultWorldKey));
      await settle(tester);
      await _choose(tester, find.byKey(WorldChoiceSheet.packKey(id)));
      expect(
        find.descendant(
          of: find.byKey(SettingsScreen.defaultWorldKey),
          matching: find.text('Mine'),
        ),
        findsOneWidget,
      );
      late String? stored;
      await tester.runAsync(() async {
        stored = (await SharedPreferences.getInstance()).getString(
          kDefaultWorldPrefKey,
        );
      });
      expect(stored, 'uuid-Mine');

      c = await _launch(tester, db);
      await _open(tester, c, Routes.nations);
      expect(_chipText('Mine'), findsOneWidget);
      expect(c.read(newGameWorldProvider), id);

      // Changing the chip leaves the setting alone.
      await tester.tap(find.byKey(WorldChip.chipKey));
      await settle(tester);
      await _choose(tester, find.byKey(WorldChoiceSheet.defaultKey));
      expect(_chipText(enL.worldDefault), findsOneWidget);
      await tester.runAsync(() async {
        stored = (await SharedPreferences.getInstance()).getString(
          kDefaultWorldPrefKey,
        );
      });
      expect(stored, 'uuid-Mine');

      await tester.runAsync(() => c.read(worldPackServiceProvider).delete(id));
      await tester.runAsync(() async {
        stored = (await SharedPreferences.getInstance()).getString(
          kDefaultWorldPrefKey,
        );
      });
      expect(stored, isNull);

      c = await _launch(tester, db);
      await _open(tester, c, Routes.nations);
      expect(_chipText(enL.worldDefault), findsOneWidget);
      expect(c.read(newGameWorldProvider), isNull);
    },
  );

  for (final (label, formFactor, size) in [
    ('phone', FormFactor.phone, kPhoneSize),
    ('tablet', FormFactor.tablet, kTabletSize),
  ]) {
    testWidgets(
      'the Settings default-world row lists only complete, compatible packs, '
      '$label',
      (tester) async {
        final c = await _launch(tester, _db(), formFactor: formFactor);
        final cze = nationIdOf('CZE');
        final ready = await insertPack(
          tester,
          c,
          testPack('Ready', squads: {cze: testSquad()}),
        );
        final short = await insertPack(
          tester,
          c,
          testPack('Short', squads: {cze: testSquad(gk: 1, def: 9)}),
        );
        final old = await insertPack(
          tester,
          c,
          testPack('Old', squads: {999: testSquad()}),
        );
        await _open(tester, c, Routes.settings, size: size);
        final rowFinder = find.byKey(SettingsScreen.defaultWorldKey);
        await tester.ensureVisible(rowFinder);
        await tester.tap(rowFinder);
        await settle(tester);

        bool enabled(int id) => tester
            .widget<ListTile>(
              find.descendant(
                of: find.byKey(WorldChoiceSheet.packKey(id)),
                matching: find.byType(ListTile),
              ),
            )
            .enabled;
        expect(enabled(ready), isTrue);
        expect(enabled(short), isFalse);
        expect(enabled(old), isFalse);

        await _choose(tester, find.byKey(WorldChoiceSheet.packKey(old)));
        await _choose(tester, find.byKey(WorldChoiceSheet.packKey(short)));
        expect(c.read(defaultWorldProvider), isNull);
        await _choose(tester, find.byKey(WorldChoiceSheet.packKey(ready)));
        expect(c.read(defaultWorldProvider), 'uuid-Ready');
        expect(tester.takeException(), isNull);
      },
    );
  }

  /// Chooses pack [id] on the chip of the nation pick.
  Future<void> chooseOnChip(WidgetTester tester, int id) async {
    await tester.tap(find.byKey(WorldChip.chipKey));
    await settle(tester);
    await _choose(tester, find.byKey(WorldChoiceSheet.packKey(id)));
  }

  /// Opens New Game for nation [nationId] and presses Start.
  Future<void> pressStart(
    WidgetTester tester,
    ProviderContainer c,
    int nationId,
  ) async {
    c.read(routerProvider).go('${Routes.newGame}?nationId=$nationId');
    await settle(tester);
    await tester.tap(find.byKey(NewGameScreen.startKey));
    await settle(tester);
  }

  testWidgets(
    'a pack made incomplete after it was chosen starts no career: a message '
    'says so and the choice goes back to Default',
    (tester) async {
      final c = await _launch(tester, _db());
      final cze = nationIdOf('CZE');
      final pack = testPack('Mine', squads: {cze: _packSquad()});
      final id = await insertPack(tester, c, pack);
      await _open(tester, c, Routes.nations);
      await chooseOnChip(tester, id);
      expect(c.read(newGameWorldProvider), id);

      // Edited elsewhere: the list nobody refreshed still calls it ready.
      await tester.runAsync(
        () => c
            .read(worldPackRepositoryProvider)
            .save(
              id,
              pack.copyWith(squads: {cze: testSquad(gk: 1, def: 9)}),
            ),
      );
      await pressStart(tester, c, cze);

      expect(find.text(enL.worldPackNotReady), findsOneWidget);
      expect(await _careers(tester, c), isEmpty);
      expect(c.read(newGameWorldProvider), isNull);
      expect(
        c.read(routerProvider).routeInformationProvider.value.uri.path,
        Routes.newGame,
      );
    },
  );

  testWidgets('a pack deleted after it was chosen starts no career: a '
      'message says so', (tester) async {
    final c = await _launch(tester, _db());
    final cze = nationIdOf('CZE');
    final id = await insertPack(
      tester,
      c,
      testPack('Mine', squads: {cze: _packSquad()}),
    );
    await _open(tester, c, Routes.nations);
    await chooseOnChip(tester, id);

    // Deleted behind the chip's back.
    await tester.runAsync(
      () => c.read(worldPackRepositoryProvider).delete(id),
    );
    await pressStart(tester, c, cze);

    expect(find.text(enL.worldPackGone), findsOneWidget);
    expect(await _careers(tester, c), isEmpty);
    expect(c.read(newGameWorldProvider), isNull);
  });

  testWidgets('a chosen pack that turns incompatible is flagged on the chip', (
    tester,
  ) async {
    final c = await _launch(tester, _db());
    final cze = nationIdOf('CZE');
    final pack = testPack('Mine', squads: {cze: _packSquad()});
    final id = await insertPack(tester, c, pack);
    await _open(tester, c, Routes.nations);
    await chooseOnChip(tester, id);
    expect(
      find.descendant(
        of: find.byKey(WorldChip.chipKey),
        matching: find.byIcon(Icons.public_rounded),
      ),
      findsOneWidget,
    );

    await tester.runAsync(
      () => c
          .read(worldPackRepositoryProvider)
          .save(id, pack.copyWith(squads: {...pack.squads, 999: testSquad()})),
    );
    c.invalidate(worldPacksProvider);
    await settle(tester);
    expect(_chipText('Mine'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(WorldChip.chipKey),
        matching: find.byIcon(Icons.error_outline_rounded),
      ),
      findsOneWidget,
    );
  });

  testWidgets(
    'Start waits for the Settings default: a career started before the '
    'nation pick ever resolved it still starts on it',
    timeout: const Timeout.factor(6),
    (tester) async {
      final db = _db();
      var c = await _launch(tester, db);
      final cze = nationIdOf('CZE');
      final id = await insertPack(
        tester,
        c,
        testPack('Mine', squads: {cze: _packSquad()}),
      );
      await tester.runAsync(
        () => c.read(defaultWorldProvider.notifier).set('uuid-Mine'),
      );

      // A fresh launch straight onto New Game: no chip has seeded anything.
      c = await _launch(tester, db);
      await _open(tester, c, '${Routes.newGame}?nationId=$cze');
      expect(c.read(newGameWorldProvider), isNull);
      await tester.tap(find.byKey(NewGameScreen.startKey));
      await _pumpUntil(
        tester,
        () =>
            c.read(routerProvider).routeInformationProvider.value.uri.path ==
            Routes.hub,
      );
      await settle(tester);

      final made = (await _careers(tester, c)).single;
      late String? world;
      await tester.runAsync(() async {
        world = (await c.read(worldPackRepositoryProvider).forCareer(made.id))
            ?.pack
            .name;
      });
      expect(world, 'Mine');
      expect(id, isPositive);
      await tester.runAsync(() => c.read(playTimeTrackerProvider).stop());
      await rebuildSavesInFakeZone(tester, SeededSave(c, made));
      await tester.pumpWidget(const SizedBox());
    },
  );
}
