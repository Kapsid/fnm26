import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/messages/message_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'test_database.dart';

/// An iPhone 14 in portrait, the size every phone guard is drawn at.
const Size kPhoneSize = Size(390, 844);

/// An 11in iPad in landscape, the size the mockups were drawn at.
const Size kTabletSize = Size(1194, 834);

/// Wraps the whole app, so a golden captures exactly what the screen shows.
const Key kAppRoot = Key('test.appRoot');

/// English strings, for finders.
AppLocalizations get enL => lookupAppLocalizations(const Locale('en'));

final List<Nation> _nations =
    (jsonDecode(File('assets/data/nations.json').readAsStringSync())
            as List<dynamic>)
        .map((e) => Nation.fromJson(e as Map<String, Object?>))
        .toList();

final List<Player> _players =
    (jsonDecode(File('assets/data/players.json').readAsStringSync())
            as List<dynamic>)
        .map((e) => Player.fromJson(e as Map<String, Object?>))
        .toList();

/// A brand-new career on the real world data, in its own in-memory database.
class SeededSave {
  SeededSave(this.container, this.career);

  final ProviderContainer container;
  final Career career;

  int get careerId => career.id;
  int get nationId => career.nationId;
  List<Nation> get nations => _nations;
}

/// Seeds the real nations and players, starts a career with the strongest
/// European nation (which opens on a drawn qualifying campaign, so there is a
/// draw to be watched), and reads the welcome news so it does not pop over
/// the hub. Always the same save: the seed is fixed.
///
/// [formFactor] decides the router's shape, exactly as `main.dart` does.
Future<SeededSave> seedSave(
  WidgetTester tester, {
  FormFactor formFactor = FormFactor.phone,
  List<Override> overrides = const [],
}) async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final db = createTestDatabase();
  final container = ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
      premiumUnlockedProvider.overrideWith((ref) => true),
      matchAttemptSaltProvider.overrideWithValue(() => 0),
      seedSourceProvider.overrideWithValue(
        InMemorySeedSource(nationList: _nations, playerList: _players),
      ),
      formFactorProvider.overrideWithValue(formFactor),
      ...overrides,
    ],
  );
  addTearDown(db.close);
  addTearDown(container.dispose);

  late Career career;
  await tester.runAsync(() async {
    await container.read(seedLoaderProvider).ensureSeeded();
    final strongest = _nations
        .where((n) => n.confederation == Confederation.europe)
        .reduce((a, b) => a.ranking <= b.ranking ? a : b);
    career = (await container
            .read(careerServiceProvider)
            .create(
              nationId: strongest.id,
              managerName: 'M',
              rngSeed: 20260922,
            ))
        .valueOrNull!;
    await container.read(messageInboxProvider(career.id).future);
    await container
        .read(competitionRepositoryProvider)
        .markMessagesRead(career.id);
  });
  container
    ..invalidate(messageInboxProvider(career.id))
    ..invalidate(unreadMessagesProvider(career.id));
  return SeededSave(container, career);
}

/// Lets the database work and the frames catch up.
///
/// A FIXED number of rounds, never "until the spinners stop": a golden must
/// capture the same frame on every run, and a nested provider that resolved
/// one round later would otherwise change the picture. The final pump runs
/// out route transitions.
Future<void> settle(WidgetTester tester, {int rounds = 30}) async {
  for (var i = 0; i < rounds; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 30)),
    );
    await tester.pump();
  }
  await tester.pump(const Duration(milliseconds: 500));
}

/// Opens [location] in the real app router at [size] and settles.
///
/// The router comes from [routerProvider], so the shell is there exactly when
/// the save was seeded with [FormFactor.tablet].
Future<void> pumpRoute(
  WidgetTester tester,
  SeededSave save,
  String location, {
  Size size = kPhoneSize,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final router = save.container.read(routerProvider)..go(location);
  await tester.pumpWidget(
    RepaintBoundary(
      key: kAppRoot,
      child: UncontrolledProviderScope(
        container: save.container,
        child: MaterialApp.router(
          theme: AppTheme.theme,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    ),
  );
  await settle(tester);
}

/// Compares the whole app against [file] (relative to the calling test).
Future<void> expectAppGolden(String file) =>
    expectLater(find.byKey(kAppRoot), matchesGoldenFile(file));
