import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'seeded_save.dart';
import 'test_database.dart';

/// The real world seeded into an in-memory database, with no career: what a
/// manager who opens the editor from the main menu has.
Future<ProviderContainer> editorContainer(
  WidgetTester tester, {
  FormFactor formFactor = FormFactor.phone,
  List<Override> overrides = const [],
}) async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final db = createTestDatabase();
  final container = ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
      // The editor is free: nothing it does may depend on this.
      premiumUnlockedProvider.overrideWith((ref) => false),
      seedSourceProvider.overrideWithValue(
        InMemorySeedSource(nationList: realNations, playerList: realPlayers),
      ),
      formFactorProvider.overrideWithValue(formFactor),
      ...overrides,
    ],
  );
  addTearDown(db.close);
  addTearDown(container.dispose);
  await tester.runAsync(
    () => container.read(seedLoaderProvider).ensureSeeded(),
  );
  return container;
}

/// Opens [location] in the real router of [container] at [size].
Future<void> pumpEditorRoute(
  WidgetTester tester,
  ProviderContainer container,
  String location, {
  Size size = kPhoneSize,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final router = container.read(routerProvider)..go(location);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
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

/// Pumps (with real time for the database) until [finder] finds something,
/// for work longer than [settle] waits for (a whole new pack).
Future<void> pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 90),
}) async {
  final clock = Stopwatch()..start();
  while (finder.evaluate().isEmpty) {
    if (clock.elapsed > timeout) fail('never found $finder');
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pump(const Duration(milliseconds: 50));
  }
  await tester.pump(const Duration(milliseconds: 500));
}

PackPlayer _player(int id, PlayerPosition pos) => PackPlayer(
  id: kPackPlayerIdBase + id,
  name: 'Player $id',
  age: 25,
  position: pos,
  attributes: const PlayerAttributes(physical: 60, technical: 60, stamina: 60),
  potential: 80,
);

/// A squad of [gk] goalkeepers, [def] defenders, [mid] midfielders and [fwd]
/// forwards (23 and complete by default).
List<PackPlayer> testSquad({
  int gk = 3,
  int def = 7,
  int mid = 8,
  int fwd = 5,
}) {
  var id = 1;
  return [
    for (var i = 0; i < gk; i++) _player(id++, PlayerPosition.gk),
    for (var i = 0; i < def; i++) _player(id++, PlayerPosition.cb),
    for (var i = 0; i < mid; i++) _player(id++, PlayerPosition.cm),
    for (var i = 0; i < fwd; i++) _player(id++, PlayerPosition.st),
  ];
}

/// A small pack: only [squads] are its own; everything else is the game's.
WorldPack testPack(
  String name, {
  Map<int, List<PackPlayer>> squads = const {},
}) => WorldPack(
  uuid: 'uuid-$name',
  name: name,
  author: '',
  formatVersion: kPackFormatVersion,
  madeWithVersion: kPackGameVersion,
  squads: squads,
);

/// Stores [pack] on the device and returns its id.
Future<int> insertPack(
  WidgetTester tester,
  ProviderContainer container,
  WorldPack pack,
) async {
  late int id;
  await tester.runAsync(() async {
    id = await container.read(worldPackRepositoryProvider).insert(pack, {});
  });
  container.invalidate(worldPacksProvider);
  return id;
}

/// The id of the nation with FIFA [code].
int nationIdOf(String code) => realNations.firstWhere((n) => n.code == code).id;
