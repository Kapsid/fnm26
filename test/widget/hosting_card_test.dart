// The Federation screen's Hosting card (brief b15): this cycle's hosts, only
// once revealed, and where the next cycle's bid stands.
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/host_bidding.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/host_bid_providers.dart';
import 'package:fnm/features/federation/hosting_card.dart';
import 'package:fnm/features/federation/investment_editor.dart'
    show formatEuros;
import 'package:fnm/features/tournaments/city_providers.dart';
import 'package:fnm/features/tournaments/host_draw_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/l10n/app_localizations_en.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/pump_app.dart';
import '../helpers/test_database.dart';

final AppLocalizations _en = AppLocalizationsEn();

const Nation _me = Nation(
  id: 12,
  name: 'Czechia',
  code: 'CZE',
  confederation: Confederation.europe,
  ranking: 40,
);
const Nation _hostA = Nation(
  id: 30,
  name: 'Portugal',
  code: 'POR',
  confederation: Confederation.europe,
  ranking: 6,
);
const Nation _hostB = Nation(
  id: 31,
  name: 'Brazil',
  code: 'BRA',
  confederation: Confederation.southAmerica,
  ranking: 3,
);

HostBidStatus _status(
  HostBidComp comp, {
  bool pending = false,
  bool recent = false,
  HostBidMarker? pledge,
}) => HostBidStatus(
  comp: comp,
  editionCycle: 1,
  year: comp == HostBidComp.continental ? 2032 : 2034,
  nation: _me,
  requirement: HostingRequirements.of(comp, Confederation.europe),
  shortfall: (grounds: 0, bigGrounds: 0),
  barredConfederation: null,
  recentHost: recent,
  rulesPending: pending,
  lodged: pledge != null,
  pledge: pledge,
  declined: false,
  windowOpen: false,
  offer: null,
);

List<CycleHosting> _hosting({required bool revealed}) => [
  CycleHosting(
    comp: HostBidComp.continental,
    confederation: Confederation.europe,
    year: 2028,
    hosts: revealed ? const [_hostA] : null,
  ),
  CycleHosting(
    comp: HostBidComp.worldChampionship,
    confederation: Confederation.europe,
    year: 2030,
    hosts: revealed ? const [_hostB] : null,
  ),
];

List<Override> _overrides(
  List<CycleHosting> hosting,
  List<HostBidStatus> statuses,
) => [
  cycleHostingProvider(1).overrideWith((ref) async => hosting),
  hostBidStatusProvider((
    careerId: 1,
    nationId: null,
  )).overrideWith((ref) async => statuses),
];

Future<void> _pump(
  WidgetTester tester,
  List<Override> overrides, {
  Locale locale = const Locale('en'),
}) async {
  tester.view.physicalSize = const Size(360, 1400);
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = 1.4;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  await tester.pumpApp(
    const Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: HostingCard(careerId: 1),
      ),
    ),
    locale: locale,
    overrides: overrides,
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('before the reveal: no host named, the bid rows wait', (
    tester,
  ) async {
    await _pump(
      tester,
      _overrides(_hosting(revealed: false), [
        _status(HostBidComp.continental, pending: true),
        _status(HostBidComp.worldChampionship, pending: true),
      ]),
    );
    expect(tester.takeException(), isNull);
    expect(find.text('Portugal'), findsNothing);
    expect(find.text('Brazil'), findsNothing);
    expect(find.text(_en.hostingTba), findsOneWidget);
    expect(find.text(_en.hostingTbaWc), findsOneWidget);
    expect(find.text(_en.hostBidRulesPending), findsNWidgets(2));
    expect(find.text(_en.hostBidOpensLater), findsNothing);
    expect(find.text(_en.hostingWindowLine), findsOneWidget);
  });

  testWidgets('after the reveal: the hosts and the specific reason', (
    tester,
  ) async {
    await _pump(
      tester,
      _overrides(_hosting(revealed: true), [
        _status(HostBidComp.continental, recent: true),
        _status(HostBidComp.worldChampionship),
      ]),
    );
    expect(tester.takeException(), isNull);
    expect(find.text('Portugal'), findsOneWidget);
    expect(find.text('Brazil'), findsOneWidget);
    expect(find.text(_en.hostingTba), findsNothing);
    expect(find.text(_en.hostBidRulesPending), findsNothing);
    expect(find.text(_en.hostBidRecentHost), findsOneWidget);
    // The World Championship row: eligible.
    expect(find.text(_en.hostBidOpensLater), findsOneWidget);
  });

  testWidgets('a pledged bid shows its stake and chance', (tester) async {
    const pledge = HostBidMarker(
      comp: HostBidComp.worldChampionship,
      editionCycle: 1,
      nationId: 12,
      levels: 3,
      permille: 240,
    );
    await _pump(
      tester,
      _overrides(_hosting(revealed: true), [
        _status(HostBidComp.worldChampionship, pledge: pledge),
      ]),
    );
    expect(
      find.text(_en.hostingBidPledged(formatEuros(pledge.invested), '24%')),
      findsOneWidget,
    );
  });

  testWidgets('a campaign or free save: hosts only, no bid section', (
    tester,
  ) async {
    await _pump(tester, _overrides(_hosting(revealed: true), const []));
    expect(find.byKey(HostingCard.cardKey), findsOneWidget);
    expect(find.text('Portugal'), findsOneWidget);
    expect(find.byKey(HostingCard.bidSectionKey), findsNothing);
    expect(find.text(_en.hostingWindowLine), findsNothing);
  });

  for (final code in ['de', 'fi', 'hu', 'el', 'pt', 'cs']) {
    testWidgets('fits at 360 wide, text 1.4 ($code)', (tester) async {
      await _pump(
        tester,
        _overrides(_hosting(revealed: false), [
          _status(HostBidComp.continental, pending: true),
          _status(HostBidComp.worldChampionship, pending: true),
        ]),
        locale: Locale(code),
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('a bid row opens the bid screen', (tester) async {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => const Scaffold(
            body: SingleChildScrollView(child: HostingCard(careerId: 1)),
          ),
        ),
        GoRoute(
          path: Routes.hostBid,
          builder: (_, state) => Scaffold(
            body: Text('bid ${state.uri.queryParameters['comp']}'),
          ),
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: _overrides(_hosting(revealed: true), [
          _status(HostBidComp.continental),
          _status(HostBidComp.worldChampionship),
        ]),
        child: MaterialApp.router(
          theme: AppTheme.theme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byKey(HostingCard.bidKey(HostBidComp.worldChampionship)),
        matching: find.byType(InkWell),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('bid ${HostBidComp.worldChampionship.code}'), findsOne);
  });

  // The provider on a real career: this cycle's hosts stay hidden until
  // their ceremony has been watched.
  test('cycleHostingProvider names a host only once it is revealed', () async {
    final nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List)
            .map((e) => Nation.fromJson(e as Map<String, Object?>))
            .toList();
    final cities = {
      for (final e
          in (jsonDecode(
                    File('assets/data/country_cities.json').readAsStringSync(),
                  )
                  as Map<String, Object?>)
              .entries)
        int.parse(e.key): (e.value! as List).cast<String>(),
    };
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final db = createTestDatabase();
    final c = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: const []),
        ),
        countryCitiesProvider.overrideWith((ref) async => cities),
      ],
    );
    addTearDown(c.dispose);
    addTearDown(db.close);
    await c.read(seedLoaderProvider).ensureSeeded();
    const seed = 5;
    final career =
        (await c
                .read(careerServiceProvider)
                .create(nationId: 50, managerName: 'M', rngSeed: seed))
            .valueOrNull!;
    final id = career.id;
    Future<List<CycleHosting>> read() {
      c.invalidate(cycleHostingProvider);
      return c.read(cycleHostingProvider(id).future);
    }

    final before = await read();
    expect(before.map((h) => h.comp), [
      HostBidComp.continental,
      HostBidComp.worldChampionship,
    ]);
    expect(before.every((h) => h.hosts == null), isTrue);

    final comp = c.read(competitionRepositoryProvider);
    await comp.markDrawWatched(id, 0, continentalHostDrawKind);
    final mid = await read();
    expect(mid.first.hosts, isNotNull);
    expect(mid.last.hosts, isNull);

    await comp.markDrawWatched(id, 0, worldCupHostDrawKind);
    final world = await c.read(nationRepositoryProvider).forCareer(id);
    final after = await read();
    expect(
      after.last.hosts!.map((n) => n.id).toList(),
      WorldCupHosts.hostsFor(year: 2030, nations: world, seed: seed),
    );
  });
}
