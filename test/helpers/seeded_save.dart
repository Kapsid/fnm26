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
import 'package:fnm/features/tournaments/city_providers.dart';
import 'package:fnm/features/tournaments/qualifying_draw_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'test_database.dart';

/// An iPhone 14 in portrait, the size every phone guard is drawn at.
const Size kPhoneSize = Size(390, 844);

/// An 11in iPad in landscape, the size the mockups were drawn at.
const Size kTabletSize = Size(1194, 834);

/// The sizes every tablet layout is tested at: the 11 inch iPad, the 10.2
/// inch one, and the 9.7 inch one, where everything has the least room.
const List<Size> kTabletSizes = [
  Size(1194, 834),
  Size(1080, 810),
  Size(1024, 768),
];

/// The id [seedSave]'s career always gets: the first row of a fresh database.
/// A provider-family override handed to [seedSave] is fixed before the career
/// exists, so it keys on this.
const int kSeededCareerId = 1;

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

/// The real cities, read straight from disk. The app reads them through
/// `rootBundle`, whose cached load never completes for the second test of a
/// file (the preview then sits on its spinner for ever), so the harness
/// serves the same file itself.
final Map<int, List<String>> _cities = {
  for (final e
      in (jsonDecode(File('assets/data/country_cities.json').readAsStringSync())
              as Map<String, Object?>)
          .entries)
    int.parse(e.key): (e.value! as List).cast<String>(),
};

/// The real nations, for fake competition data drawn with real flags.
List<Nation> get realNations => _nations;

/// The nation [seedSave] starts the career with: the strongest in Europe.
int get seededNationId => _nations
    .where((n) => n.confederation == Confederation.europe)
    .reduce((a, b) => a.ranking <= b.ranking ? a : b)
    .id;

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
      countryCitiesProvider.overrideWith((ref) async => _cities),
      ...overrides,
    ],
  );
  addTearDown(db.close);
  addTearDown(container.dispose);

  late Career career;
  await tester.runAsync(() async {
    await container.read(seedLoaderProvider).ensureSeeded();
    career =
        (await container
                .read(careerServiceProvider)
                .create(
                  nationId: seededNationId,
                  managerName: 'M',
                  rngSeed: 20260922,
                ))
            .valueOrNull!;
    await container.read(messageInboxProvider(career.id).future);
    await container
        .read(competitionRepositoryProvider)
        .markMessagesRead(career.id);
  });
  expect(
    career.id,
    kSeededCareerId,
    reason: 'an override keyed on kSeededCareerId would miss this save',
  );
  container
    ..invalidate(messageInboxProvider(career.id))
    ..invalidate(unreadMessagesProvider(career.id));
  return SeededSave(container, career);
}

/// Lets the database work and the frames catch up.
///
/// At least [rounds] rounds of (real delay, pump), then on until no
/// [CircularProgressIndicator] is left, so a slow provider chain cannot leave
/// a golden on its spinner. Stops after [maxWait] of real time. If a spinner
/// is still showing then, the test FAILS: a screen stuck loading is a bug,
/// not a state to take a golden of. Pass [allowSpinner] only for a screen
/// whose spinner is its content, and say why at the call site. The final
/// pump runs out route transitions.
Future<void> settle(
  WidgetTester tester, {
  int rounds = 30,
  Duration maxWait = const Duration(seconds: 10),
  bool allowSpinner = false,
}) async {
  final clock = Stopwatch()..start();
  var i = 0;
  while (true) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 30)),
    );
    await tester.pump();
    i++;
    final spinning = find
        .byType(CircularProgressIndicator)
        .evaluate()
        .isNotEmpty;
    if (i >= rounds && !spinning) break;
    if (clock.elapsed >= maxWait) {
      if (spinning && !allowSpinner) {
        fail(
          'settle: still loading after ${maxWait.inMilliseconds} ms. '
          'A screen stuck on its spinner is a bug; pass allowSpinner: true '
          'only when the spinner is the content.',
        );
      }
      break;
    }
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
  bool allowSpinner = false,
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
  await settle(tester, allowSpinner: allowSpinner);
}

/// Compares the whole app against [file] (relative to the calling test).
Future<void> expectAppGolden(String file) =>
    expectLater(find.byKey(kAppRoot), matchesGoldenFile(file));

/// Marks the current cycle's continental qualifying draw watched, as the
/// manager does by sitting through it: the seeded save opens on that draw,
/// and the results list, the continental detail and the tournaments overview
/// keep its groups and fixtures hidden until it has been seen.
Future<void> watchContinentalQualifyingDraw(
  WidgetTester tester,
  SeededSave save,
) async {
  await tester.runAsync(() async {
    final sub = save.container.listen(
      qualifyingDrawProvider((
        careerId: save.careerId,
        worldCup: false,
      )).future,
      (_, _) {},
    );
    try {
      final data = await sub.read();
      expect(data, isNotNull, reason: 'the seeded save has no such draw');
      await save.container
          .read(competitionRepositoryProvider)
          .markDrawWatched(save.careerId, data!.cycle, data.watchedKind);
    } finally {
      sub.close();
    }
  });
}
