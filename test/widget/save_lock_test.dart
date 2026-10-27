import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/services/campaign/campaigns.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/entitlement/entitlement_service.dart';
import 'package:fnm/features/campaign/campaign_brief_screen.dart';
import 'package:fnm/features/campaign/campaign_providers.dart';
import 'package:fnm/features/career/saves_screen.dart';
import 'package:fnm/features/hub/hub_screen.dart';
import 'package:fnm/features/onboarding/tour_providers.dart';
import 'package:fnm/features/paywall/premium_gate_screen.dart';
import 'package:fnm/features/paywall/save_lock.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../helpers/expect_whole.dart';
import '../helpers/history_fixtures.dart';
import '../helpers/seeded_save.dart';

/// A save past the free cycle, for a manager without Pro, on the screens he
/// would open it from: listed and padlocked, opening to the gate, still
/// deletable, and open again the moment Pro lands.

/// No store at all: the gate's price line has nothing to wait on.
class _NoStore implements InAppPurchase {
  final StreamController<List<PurchaseDetails>> purchases =
      StreamController<List<PurchaseDetails>>.broadcast();

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => purchases.stream;

  @override
  Future<bool> isAvailable() async => false;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// The seeded save, rolled past the free cycle, and the entitlement as given.
Future<SeededSave> _lockedSave(
  WidgetTester tester, {
  bool settled = true,
  FormFactor formFactor = FormFactor.phone,
}) async {
  final store = _NoStore();
  addTearDown(store.purchases.close);
  final save = await seedSave(
    tester,
    formFactor: formFactor,
    overrides: [
      fakeTransferOverride(),
      entitlementServiceProvider.overrideWith(
        (ref) => EntitlementService(ref, iap: store),
      ),
    ],
  );
  await tester.runAsync(() async {
    final db = save.container.read(appDatabaseProvider);
    await (db.update(db.careers)..where((t) => t.id.equals(save.careerId)))
        .write(const CareersCompanion(cyclePointer: Value(1)));
  });
  save.container
    ..read(premiumUnlockedProvider.notifier).state = false
    ..read(entitlementSettledProvider.notifier).state = settled;
  return save;
}

Uri _uri(SeededSave save) =>
    save.container.read(routerProvider).routeInformationProvider.value.uri;

void main() {
  _fits();

  testWidgets('a locked save is badged, opens the gate, and opens for real '
      'once Pro lands', (tester) async {
    final save = await _lockedSave(tester);
    await pumpRoute(tester, save, Routes.saves);

    expect(find.byKey(SaveTile.lockedBadgeKey), findsOneWidget);
    expect(find.text(enL.careerSaveLockedNote), findsOneWidget);

    await tester.tap(find.byType(SaveTile));
    await settle(tester);
    expect(_uri(save).path, Routes.saveLocked);
    expect(find.byType(PremiumGateScreen), findsOneWidget);
    expect(find.text(enL.gateSaveTitle), findsOneWidget);
    expect(find.text(enL.gateSaveLead), findsOneWidget);

    // Leaving the gate goes back to the list, with the save still on it.
    await tester.tap(find.byKey(PremiumGateScreen.exitKey));
    await settle(tester);
    expect(_uri(save).path, Routes.saves);
    expect(find.byType(SaveTile), findsOneWidget);

    // Pro bought: the badge goes at once.
    save.container.read(premiumUnlockedProvider.notifier).state = true;
    await settle(tester);
    expect(find.byKey(SaveTile.lockedBadgeKey), findsNothing);
    await tester.tap(find.byType(SaveTile));
    await settle(tester);
    expect(_uri(save).path, Routes.hub);
    await stopPlayClock(tester, save);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a purchase made on the gate opens the save', (tester) async {
    final save = await _lockedSave(tester);
    await pumpRoute(tester, save, '${Routes.hub}?careerId=${save.careerId}');
    expect(_uri(save).path, Routes.saveLocked);
    save.container.read(premiumUnlockedProvider.notifier).state = true;
    await settle(tester);
    expect(_uri(save).path, Routes.hub);
    expect(find.byType(HubScreen), findsOneWidget);
    await stopPlayClock(tester, save);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a locked save can still be deleted', (tester) async {
    final save = await _lockedSave(tester);
    await pumpRoute(tester, save, Routes.saves);
    await tester.tap(find.byIcon(Icons.delete_outline));
    await settle(tester);
    await tester.tap(find.widgetWithText(TextButton, enL.careerDelete));
    await settle(tester);
    expect(find.byType(SaveTile), findsNothing);
    late List<Object> left;
    await tester.runAsync(() async {
      left = await save.container.read(careerRepositoryProvider).all();
    });
    expect(left, isEmpty);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a deep link into a locked save lands on the gate', (
    tester,
  ) async {
    final save = await _lockedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.tactics}?careerId=${save.careerId}',
    );
    expect(_uri(save).path, Routes.saveLocked);
    expect(_uri(save).queryParameters['careerId'], '${save.careerId}');
    expect(find.byType(PremiumGateScreen), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('unsettled entitlement: no padlock and no redirect', (
    tester,
  ) async {
    final save = await _lockedSave(tester, settled: false);
    await pumpRoute(tester, save, Routes.saves);
    expect(find.byKey(SaveTile.lockedBadgeKey), findsNothing);
    await tester.tap(find.byType(SaveTile));
    await settle(tester);
    expect(_uri(save).path, Routes.hub);
    await stopPlayClock(tester, save);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a refund while in the hub sends him to the gate', (
    tester,
  ) async {
    final save = await _lockedSave(tester);
    save.container.read(premiumUnlockedProvider.notifier).state = true;
    await pumpRoute(tester, save, '${Routes.hub}?careerId=${save.careerId}');
    expect(_uri(save).path, Routes.hub);
    save.container.read(premiumUnlockedProvider.notifier).state = false;
    await settle(tester);
    expect(_uri(save).path, Routes.saveLocked);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the home card is padlocked and opens the gate', (tester) async {
    final save = await _lockedSave(tester);
    await pumpRoute(tester, save, Routes.home);
    expect(find.text(enL.careerSaveLockedNote), findsOneWidget);
    await tester.tap(find.text(enL.homeContinue));
    await settle(tester);
    expect(_uri(save).path, Routes.saveLocked);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a gate reached with Pro already owned goes straight on', (
    tester,
  ) async {
    final save = await _lockedSave(tester);
    save.container.read(premiumUnlockedProvider.notifier).state = true;
    await pumpRoute(tester, save, saveLockedLocation(save.careerId));
    expect(_uri(save).path, Routes.hub);
    expect(_uri(save).queryParameters['careerId'], '${save.careerId}');
    await stopPlayClock(tester, save);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the walk through skips a locked save for one it can open', (
    tester,
  ) async {
    final save = await _lockedSave(tester, formFactor: FormFactor.tablet);
    // The second save is the one played last; only the first is locked.
    final second = await addSecondSave(tester, save);
    await pumpRoute(tester, save, Routes.settings, size: kTabletSize);
    await tester.tap(find.text(enL.settingsTourTitle));
    await settle(tester);
    expect(_uri(save).path, Routes.hub);
    expect(_uri(save).queryParameters['careerId'], '$second');
    expect(save.container.read(tourCareerProvider), second);
    await stopPlayClock(tester, save);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets(
    'a locked campaign run: padlocked Resume opens the gate, Exit to campaigns',
    (
      tester,
    ) async {
      final save = await _lockedSave(tester);
      late int runId;
      save.container.read(premiumUnlockedProvider.notifier).state = true;
      await tester.runAsync(() async {
        final run = await save.container
            .read(campaignServiceProvider)
            .start(Campaigns.youngFinns, managerName: 'M');
        runId = run.id;
      });
      save.container.read(premiumUnlockedProvider.notifier).state = false;
      await pumpRoute(
        tester,
        save,
        '${Routes.campaignBrief}?id=${Campaigns.youngFinns.id}',
      );
      expect(find.byKey(CampaignBriefScreen.lockedNoteKey), findsOneWidget);
      expect(find.text(enL.careerSaveLockedNote), findsOneWidget);
      await tester.tap(find.byKey(CampaignBriefScreen.resumeKey));
      await settle(tester);
      expect(_uri(save).path, Routes.saveLocked);
      expect(_uri(save).queryParameters['careerId'], '$runId');
      // Exit from a campaign run goes back to the campaigns.
      await tester.tap(find.byKey(PremiumGateScreen.exitKey));
      await settle(tester);
      expect(_uri(save).path, Routes.campaigns);
      await tester.pumpWidget(const SizedBox());
    },
  );

  for (final size in kTabletSizes) {
    testWidgets('tablet ${size.width.toInt()}: badged in the table and the '
        'pane, Continue opens the gate', (tester) async {
      final save = await _lockedSave(tester, formFactor: FormFactor.tablet);
      await pumpRoute(tester, save, Routes.saves, size: size);
      expect(find.byKey(SaveTile.lockedBadgeKey), findsOneWidget);
      await tester.tap(find.byKey(SavesScreen.continueKey));
      await settle(tester);
      expect(_uri(save).path, Routes.saveLocked);
      expect(find.text(enL.gateSaveTitle), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }
}

/// The padlocked tile and the gate worded for a save, at 360 wide with text
/// at 1.4, in the longest languages.
void _fits() {
  for (final code in ['en', 'cs', 'de', 'fi', 'hu', 'el', 'pt']) {
    testWidgets('$code: the padlocked tile and the gate fit 360 at 1.4', (
      tester,
    ) async {
      final store = _NoStore();
      addTearDown(store.purchases.close);
      tester.view
        ..physicalSize = const Size(360, 780)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      Widget app(Widget home) => ProviderScope(
        overrides: [
          entitlementServiceProvider.overrideWith(
            (ref) => EntitlementService(ref, iap: store),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.theme,
          locale: Locale(code),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(1.4)),
            child: child!,
          ),
          home: home,
        ),
      );

      await tester.pumpWidget(
        app(
          Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: SaveTile(
                save: Career(
                  id: 1,
                  managerName: 'M. Urbanczyk',
                  nationId: 1,
                  rngSeed: 1,
                  createdAt: DateTime(2026),
                  inGameDate: DateTime(2031, 3),
                  cyclePointer: 1,
                  lastPlayedAt: DateTime.now().subtract(
                    const Duration(days: 3),
                  ),
                  // No played line: at 1.4 in German it ellipsizes by design
                  // (pre-existing, not part of the padlock).
                ),
                nation: null,
                locked: true,
                onContinue: () {},
                onDelete: () {},
                onShare: (_) {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expectWhole(
        find.text(lookupAppLocalizations(Locale(code)).careerSaveLockedNote),
        'the padlock note',
      );
      expectNothingCut(tester, 'the padlocked save tile');

      await tester.pumpWidget(app(const PremiumGateScreen(fromSave: true)));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expectNothingCut(tester, 'the gate for a locked save');
    });
  }
}
