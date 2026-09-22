import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/entitlement/entitlement_service.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/career/nation_offers_providers.dart';
import 'package:fnm/features/federation/federation_service.dart';
import 'package:fnm/features/hub/cycle_rollover_screen.dart';
import 'package:fnm/features/paywall/premium_gate_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../helpers/test_database.dart';

/// The end of a cycle is the one screen a manager cannot be stranded on.
///
/// It is entered with `context.go`, so there is nothing behind it; it carries
/// no app bar, so there is no back arrow; and at the end of the FIRST cycle it
/// used to render exactly one control. Every state it can be in — waiting,
/// failed, blocked by the wall, or simply finished — has to leave him a next
/// action, whatever the store is doing.

/// A store that is simply not there: no listing, nothing to sell. Exactly the
/// state of a product that is not yet Ready to Submit.
class _NoStore implements InAppPurchase {
  final StreamController<List<PurchaseDetails>> _purchases =
      StreamController<List<PurchaseDetails>>.broadcast();

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => _purchases.stream;

  @override
  Future<bool> isAvailable() async => false;

  @override
  Future<ProductDetailsResponse> queryProductDetails(
    Set<String> identifiers,
  ) async => ProductDetailsResponse(
    productDetails: const [],
    notFoundIDs: identifiers.toList(),
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// Every enabled control on screen right now.
  int liveControls(WidgetTester tester) {
    var n = 0;
    for (final b in tester.widgetList<PrimaryButton>(
      find.byType(PrimaryButton),
    )) {
      if (b.onPressed != null) n++;
    }
    for (final b in tester.widgetList<TextButton>(find.byType(TextButton))) {
      if (b.onPressed != null) n++;
    }
    return n;
  }

  /// Real drift queries do not run inside `testWidgets`' fake-async zone, and
  /// a spinner never lets `pumpAndSettle` return. So: let real time pass, then
  /// pump a frame, until the screen stops changing.
  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 40; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await tester.pump(const Duration(milliseconds: 40));
    }
  }

  Future<int> pump(
    WidgetTester tester, {
    required int cyclePointer,
    List<Override> extra = const [],
  }) async {
    late final int careerId;
    final db = createTestDatabase();
    final nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Nation.fromJson(e as Map<String, Object?>))
            .toList();
    final store = _NoStore();
    addTearDown(store._purchases.close);
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        // The real build: locked, and no listing to buy.
        premiumUnlockedProvider.overrideWith((ref) => false),
        entitlementServiceProvider.overrideWith(
          (ref) => EntitlementService(ref, iap: store),
        ),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: const []),
        ),
        ...extra,
      ],
    );
    addTearDown(container.dispose);
    addTearDown(db.close);
    await tester.runAsync(() async {
      await container.read(seedLoaderProvider).ensureSeeded();
      final career =
          (await container
                  .read(careerServiceProvider)
                  .create(nationId: nations.first.id, managerName: 'M'))
              .valueOrNull!;
      careerId = career.id;
      if (cyclePointer > 0) {
        await container
            .read(careerRepositoryProvider)
            .advanceCycle(careerId, cyclePointer, DateTime(2030, 7));
      }
    });

    tester.view
      ..physicalSize = const Size(400, 900)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      initialLocation: '/roll',
      routes: [
        GoRoute(
          path: '/roll',
          builder: (_, _) => CycleRolloverScreen(careerId: careerId),
        ),
        GoRoute(
          path: Routes.saves,
          builder: (_, _) => const Scaffold(body: Center(child: Text('SAVES'))),
        ),
        GoRoute(
          path: Routes.hub,
          builder: (_, _) => const Scaffold(body: Center(child: Text('HUB'))),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          theme: AppTheme.theme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await settle(tester);
    return careerId;
  }

  /// Walks champion → board → finances, which is how the manager reaches the
  /// button that rolls the save.
  Future<void> toTheEnd(WidgetTester tester) async {
    for (var step = 0; step < 2; step++) {
      expect(
        liveControls(tester),
        greaterThan(0),
        reason: 'step $step of the rollover offered nothing to press',
      );
      await tester.tap(find.byType(PrimaryButton).first);
      await settle(tester);
    }
  }

  testWidgets('the end of the FIRST cycle still offers a way back', (
    tester,
  ) async {
    await pump(tester, cyclePointer: 0);
    await toTheEnd(tester);

    // The end of the first cycle is the screen a free save reaches FIRST, and
    // it used to render exactly one button, because the way back was tied to
    // being blocked. If the roll then fails or hangs, that button is dead and
    // the manager has nothing at all.
    expect(
      find.text('Back to your saves'),
      findsOneWidget,
      reason: 'the rollover must always offer a way back to the saves list',
    );
    await tester.tap(find.text('Back to your saves'));
    await settle(tester);
    expect(find.text('SAVES'), findsOneWidget);
  });

  testWidgets('a rollover whose finances will not load is not a dead end', (
    tester,
  ) async {
    await pump(
      tester,
      cyclePointer: 0,
      extra: [
        cycleIncomeProvider.overrideWith(
          (ref, id) async => throw StateError('no finances'),
        ),
      ],
    );
    await toTheEnd(tester);

    expect(
      liveControls(tester),
      greaterThan(0),
      reason: 'a failed finances read left the screen with nothing to press',
    );
    await tester.tap(find.text('Back to your saves'));
    await settle(tester);
    expect(find.text('SAVES'), findsOneWidget);
  });

  testWidgets(
    "a rollover whose board verdict will not load is not a dead end",
    (tester) async {
      await pump(
        tester,
        cyclePointer: 0,
        extra: [
          rolloverVerdictProvider.overrideWith(
            (ref, id) async => throw StateError('no verdict'),
          ),
        ],
      );
      // Champion step, then the board step, which is the one that fails.
      await tester.tap(find.byType(PrimaryButton).first);
      await settle(tester);

      expect(
        liveControls(tester),
        greaterThan(0),
        reason: 'a failed board verdict left the screen with nothing to press',
      );
      await tester.tap(find.text('Back to your saves'));
      await settle(tester);
      expect(find.text('SAVES'), findsOneWidget);
    },
  );

  testWidgets('the wall over a store with nothing to sell still lets him out', (
    tester,
  ) async {
    await pump(tester, cyclePointer: 1);
    await toTheEnd(tester);

    // Blocked: the button opens the wall rather than rolling.
    expect(find.text('Continue your career'), findsOneWidget);
    await tester.tap(find.byType(PrimaryButton).first);
    await settle(tester);

    expect(find.byType(PremiumGateScreen), findsOneWidget);
    expect(
      find.text('Store unavailable'),
      findsOneWidget,
      reason: 'no listing is live yet, so there is nothing to sell',
    );
    // ...and the wall is still leaveable.
    await tester.tap(find.text('EXIT'));
    await settle(tester);

    expect(find.byType(PremiumGateScreen), findsNothing);
    expect(
      liveControls(tester),
      greaterThan(0),
      reason: 'declining the wall must not strand him on the rollover',
    );
    await tester.tap(find.text('Back to your saves'));
    await settle(tester);
    expect(find.text('SAVES'), findsOneWidget);
  });
}
