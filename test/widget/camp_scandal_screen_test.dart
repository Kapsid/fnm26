import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/squad/camp_scandal.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_event_button.dart';
import 'package:fnm/features/squad/camp_scandal_providers.dart';
import 'package:fnm/features/squad/camp_scandal_screen.dart';
import 'package:fnm/features/tactics/nomination_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:go_router/go_router.dart';

/// Records the answer instead of writing it.
class _FakeService extends CampScandalService {
  _FakeService(super.ref);

  final List<String> calls = [];

  @override
  Future<void> sendHome(
    int careerId,
    PendingScandal s, {
    int? replacement,
  }) async => calls.add('home:${s.playerId}:$replacement');

  @override
  Future<void> keep(int careerId, PendingScandal s) async =>
      calls.add('keep:${s.playerId}');
}

void main() {
  Player man(int id, String name, PlayerPosition pos, int overall) => Player(
    id: id,
    nationId: 1,
    name: name,
    position: pos,
    age: 24,
    club: 'Club $id',
    attributes: PlayerAttributes(
      physical: overall,
      technical: overall,
      stamina: overall,
    ),
  );

  // Long names on purpose: the buttons carry them.
  const night = 'Maximilian Oberhauser-Kleinschmidt';
  const cover = 'Bartholomäus Wiesenthaler';

  Future<_FakeService> pump(
    WidgetTester tester, {
    required String locale,
    bool finals = false,
    ScandalKind kind = ScandalKind.nightclub,
    Size size = const Size(360, 640),
    double scale = 1.4,
    bool tablet = false,
  }) async {
    tester.view
      ..devicePixelRatio = 1
      ..physicalSize = size;
    addTearDown(tester.view.reset);
    late _FakeService service;
    final scoped = ProviderContainer(
      overrides: [
        campScandalServiceProvider.overrideWith(
          (ref) => service = _FakeService(ref),
        ),
        pendingScandalProvider(1).overrideWith(
          (ref) async => (
            cycle: 0,
            window: DateTime(2030, 9, 5),
            playerId: 1,
            playerName: night,
            kind: kind,
            finals: finals,
          ),
        ),
        squadDataProvider(1).overrideWith(
          (ref) async => SquadData(
            pool: [
              man(1, night, PlayerPosition.st, 81),
              man(2, 'In The Squad', PlayerPosition.cb, 75),
              man(3, cover, PlayerPosition.st, 72),
              man(4, 'Another Option', PlayerPosition.dm, 70),
            ],
            callUps: const {1, 2},
            absences: const {},
          ),
        ),
        nominationWindowProvider(1).overrideWith(
          (ref) async => (
            open: false,
            matches: const <Fixture>[],
            nations: <int, Nation>{},
            playerNationId: 1,
          ),
        ),
      ],
    );
    addTearDown(scoped.dispose);
    final router = GoRouter(
      initialLocation: '${Routes.campScandal}?careerId=1',
      routes: [
        GoRoute(
          path: Routes.campScandal,
          builder: (_, _) => tablet
              ? const TabletShellScope(child: CampScandalScreen(careerId: 1))
              : const CampScandalScreen(careerId: 1),
        ),
        GoRoute(path: Routes.hub, builder: (_, _) => const Text('HUB')),
      ],
    );
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: scoped,
        child: MaterialApp.router(
          routerConfig: router,
          theme: AppTheme.theme,
          locale: Locale(locale),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(scale)),
            child: child!,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    service = scoped.read(campScandalServiceProvider) as _FakeService;
    return service;
  }

  for (final locale in const ['de', 'fi', 'hu', 'el', 'pt', 'cs']) {
    for (final finals in const [false, true]) {
      testWidgets('fits at 360 and 1.4 in $locale (finals: $finals)', (
        tester,
      ) async {
        await pump(tester, locale: locale, finals: finals);
        expect(tester.takeException(), isNull);
        final l = lookupAppLocalizations(Locale(locale));
        expect(find.text(l.scandalStoryNightclub(night)), findsOneWidget);
        expect(find.text(l.scandalKeepNote), findsOneWidget);
        expect(
          find.text(finals ? l.scandalFinalsNote : l.scandalSendHomeNote),
          findsOneWidget,
        );
        // Both answers are on screen and can be tapped.
        for (final key in [
          CampScandalScreen.sendHomeKey,
          CampScandalScreen.keepKey,
        ]) {
          final rect = tester.getRect(find.byKey(key));
          expect(rect.left, greaterThanOrEqualTo(0));
          expect(rect.right, lessThanOrEqualTo(360));
          expect(rect.bottom, lessThanOrEqualTo(640));
        }
        // No replacement at a finals; a list of them otherwise, below the
        // story (scrolled to at this size).
        if (finals) {
          expect(find.text(l.scandalPickCover), findsNothing);
        } else {
          await tester.scrollUntilVisible(
            find.text(cover),
            100,
            scrollable: find.byType(Scrollable).first,
          );
          expect(find.text(cover), findsOneWidget);
          expect(tester.takeException(), isNull);
        }
        // A man already in the squad is never offered as cover.
        expect(find.text('In The Squad'), findsNothing);
      });
    }
  }

  testWidgets('keep answers keep, and goes back to the hub', (tester) async {
    final service = await pump(tester, locale: 'en', scale: 1);
    await tester.tap(find.byKey(CampScandalScreen.keepKey));
    await tester.pumpAndSettle();
    expect(service.calls, ['keep:1']);
    expect(find.text('HUB'), findsOneWidget);
  });

  testWidgets('send home with a replacement picked', (tester) async {
    final service = await pump(tester, locale: 'en', scale: 1);
    final l = lookupAppLocalizations(const Locale('en'));
    expect(find.text(l.scandalSendHome), findsOneWidget);
    await tester.tap(find.text(cover));
    await tester.pumpAndSettle();
    expect(find.text(l.scandalSendHomeCover(cover)), findsOneWidget);
    await tester.tap(find.byKey(CampScandalScreen.sendHomeKey));
    await tester.pumpAndSettle();
    expect(service.calls, ['home:1:3']);
  });

  testWidgets('send home with nobody picked', (tester) async {
    final service = await pump(tester, locale: 'en', scale: 1, finals: true);
    await tester.tap(find.byKey(CampScandalScreen.sendHomeKey));
    await tester.pumpAndSettle();
    expect(service.calls, ['home:1:null']);
  });

  for (final kind in ScandalKind.values) {
    testWidgets('the ${kind.name} tells its own story', (tester) async {
      final l = lookupAppLocalizations(const Locale('en'));
      await pump(tester, locale: 'en', scale: 1, kind: kind);
      expect(find.text(scandalStory(l, kind, night)), findsOneWidget);
    });
  }

  testWidgets('the hub button opens the decision', (tester) async {
    final l = lookupAppLocalizations(const Locale('en'));
    final event = HubEvent(
      kind: HubEventKind.scandal,
      label: l.hubEventScandal(night),
      icon: Icons.local_bar_rounded,
      route: '${Routes.campScandal}?careerId=1',
      subtitle: l.hubEventScandalSub,
    );
    final router = GoRouter(
      initialLocation: Routes.hub,
      routes: [
        GoRoute(
          path: Routes.hub,
          builder: (_, _) => const Scaffold(body: HubEventButton(careerId: 1)),
        ),
        GoRoute(
          path: Routes.campScandal,
          builder: (_, _) => const Text('DECISION'),
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [nextEventProvider(1).overrideWith((ref) async => event)],
        child: MaterialApp.router(
          routerConfig: router,
          theme: AppTheme.theme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pump();
    expect(find.text(l.hubEventScandal(night)), findsOneWidget);
    expect(find.text(l.hubEventScandalSub), findsOneWidget);
    await tester.tap(find.text(l.hubEventScandal(night)));
    await tester.pumpAndSettle();
    expect(find.text('DECISION'), findsOneWidget);
  });

  testWidgets('an error never spins for ever: the way out is shown', (
    tester,
  ) async {
    tester.view
      ..devicePixelRatio = 1
      ..physicalSize = const Size(360, 640);
    addTearDown(tester.view.reset);
    final scoped = ProviderContainer(
      overrides: [
        pendingScandalProvider(
          1,
        ).overrideWith((ref) async => throw StateError('no save')),
        squadDataProvider(1).overrideWith((ref) async => null),
        nominationWindowProvider(1).overrideWith(
          (ref) async => (
            open: false,
            matches: const <Fixture>[],
            nations: <int, Nation>{},
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
          home: const CampScandalScreen(careerId: 1),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final l = lookupAppLocalizations(const Locale('en'));
    expect(find.text(l.federationContinue), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('the tablet layout', (tester) async {
    await pump(
      tester,
      locale: 'de',
      size: const Size(1280, 800),
      scale: 1,
      tablet: true,
    );
    expect(tester.takeException(), isNull);
    expect(find.byKey(CampScandalScreen.tabletLayoutKey), findsOneWidget);
    expect(find.byKey(CampScandalScreen.keepKey), findsOneWidget);
  });
}
