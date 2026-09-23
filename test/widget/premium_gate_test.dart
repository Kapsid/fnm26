import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/entitlement/entitlement_service.dart';
import 'package:fnm/features/paywall/paywall_sheet.dart';
import 'package:fnm/features/paywall/premium_gate_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../helpers/expect_whole.dart';

/// The wall at the end of the free cycle. It is a full page rather than a
/// sheet on purpose, so everything on it has to fit on a phone in the longer
/// language, and every state a real store can be in has to have an answer:
/// there is no worse screen to offer a dead Buy button on.

/// A store that is simply not there: no listing, nothing to sell.
class _EmptyStore implements InAppPurchase {
  final StreamController<List<PurchaseDetails>> _purchases =
      StreamController<List<PurchaseDetails>>.broadcast();

  bool available = false;
  List<ProductDetails> products = const [];
  int restores = 0;
  int buys = 0;

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => _purchases.stream;

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<ProductDetailsResponse> queryProductDetails(
    Set<String> identifiers,
  ) async => ProductDetailsResponse(
    productDetails: products,
    notFoundIDs: products.isEmpty ? identifiers.toList() : const [],
  );

  @override
  Future<bool> buyNonConsumable({required PurchaseParam purchaseParam}) async {
    buys++;
    return true;
  }

  @override
  Future<bool> buyConsumable({
    required PurchaseParam purchaseParam,
    bool autoConsume = true,
  }) async => true;

  @override
  Future<void> completePurchase(PurchaseDetails purchase) async {}

  @override
  Future<void> restorePurchases({String? applicationUserName}) async {
    restores++;
  }

  @override
  Future<String> countryCode() async => 'CZ';

  // The platform additions are never touched here; the interface is wide and
  // only the six methods above are part of the purchase.
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

ProductDetails _product(String price) => ProductDetails(
  id: kPremiumProductId,
  title: 'Premium',
  description: 'One-time unlock',
  price: price,
  rawPrice: 12.99,
  currencyCode: 'CZK',
);

void main() {
  Future<_EmptyStore> pumpGate(
    WidgetTester tester, {
    Locale locale = const Locale('en'),
    double width = 400,
    List<ProductDetails> products = const [],
    bool premium = false,
    bool? storeAvailable,
  }) async {
    final store = _EmptyStore()
      ..available = storeAvailable ?? products.isNotEmpty
      ..products = products;
    tester.view
      ..physicalSize = Size(width, 780)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    addTearDown(store._purchases.close);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          premiumUnlockedProvider.overrideWith((ref) => premium),
          entitlementServiceProvider.overrideWith(
            (ref) => EntitlementService(ref, iap: store),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.theme,
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const PremiumGateScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return store;
  }

  // "Store unavailable" covers three unrelated failures, and on a build that
  // cannot buy anything the only way to tell them apart is to be told which.
  // The line is a testing aid behind kShowStoreDiagnostics; these two hold it
  // to naming the right one.
  testWidgets('a device with no store says so', (tester) async {
    await pumpGate(tester, storeAvailable: false);

    expect(find.text('Store unavailable'), findsOneWidget);
    expect(find.textContaining('No store on this device'), findsOneWidget);
    expect(find.textContaining(kPremiumProductId), findsNothing);
  });

  testWidgets('a store that does not sell the product names it', (
    tester,
  ) async {
    await pumpGate(tester, storeAvailable: true);

    expect(find.text('Store unavailable'), findsOneWidget);
    expect(find.textContaining(kPremiumProductId), findsOneWidget);
    expect(find.textContaining('No store on this device'), findsNothing);
  });

  testWidgets("the price on screen is the store's, not ours", (tester) async {
    await pumpGate(tester, products: [_product(r'$14.49')]);

    expect(find.text(r'$14.49'), findsOneWidget);
    // The old hardcoded price must not be able to come back.
    expect(find.textContaining('12.99'), findsNothing);
    expect(find.textContaining('12,99'), findsNothing);
    expect(find.text('BUY AND CONTINUE'), findsOneWidget);
  });

  testWidgets('a store with nothing to sell offers no Buy button', (
    tester,
  ) async {
    await pumpGate(tester);

    expect(find.text('BUY AND CONTINUE'), findsNothing);
    expect(find.text('Store unavailable'), findsOneWidget);
    final button = tester.widget<PrimaryButton>(find.byType(PrimaryButton));
    expect(button.onPressed, isNull, reason: 'a dead Buy button is worse');
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('restore is reachable from the wall itself', (tester) async {
    final store = await pumpGate(tester, products: [_product('249,00 Kč')]);

    await tester.tap(find.text('Restore purchases'));
    await tester.pump();
    expect(store.restores, 1);
    // A restore that replays nothing gives up after its timeout rather than
    // spinning forever, and says so instead of leaving the buttons dead.
    await tester.pump(const Duration(seconds: 9));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('No previous purchase found'),
      findsOneWidget,
    );
  });

  testWidgets('buying asks the store', (tester) async {
    final store = await pumpGate(tester, products: [_product('249,00 Kč')]);

    await tester.tap(find.text('BUY AND CONTINUE'));
    await tester.pump();
    await tester.pump();
    expect(store.buys, 1);
  });

  testWidgets('the entitlement closes the wall with a yes', (tester) async {
    late BuildContext ctx;
    bool? carriedOn;
    final store = _EmptyStore()
      ..available = true
      ..products = [_product('249,00 Kč')];
    addTearDown(store._purchases.close);
    final container = ProviderContainer(
      overrides: [
        entitlementServiceProvider.overrideWith(
          (ref) => EntitlementService(ref, iap: store),
        ),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.theme,
          home: Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
    unawaited(
      PremiumGateScreen.show(ctx).then((v) => carriedOn = v),
    );
    await tester.pumpAndSettle();

    container.read(premiumUnlockedProvider.notifier).state = true;
    await tester.pumpAndSettle();

    expect(carriedOn, isTrue);
  });

  testWidgets('leaving the wall answers no', (tester) async {
    late BuildContext ctx;
    bool? carriedOn;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          entitlementServiceProvider.overrideWith(
            (ref) => EntitlementService(ref, iap: _EmptyStore()),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.theme,
          home: Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
    unawaited(
      PremiumGateScreen.show(ctx).then((v) => carriedOn = v),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('EXIT'));
    await tester.pumpAndSettle();
    expect(carriedOn, isFalse);
  });

  for (final locale in [const Locale('en'), const Locale('cs')]) {
    for (final width in [360.0, 400.0]) {
      testWidgets(
        '${locale.languageCode}: the wall fits at ${width.toInt()}px',
        (tester) async {
          await pumpGate(
            tester,
            locale: locale,
            width: width,
            products: [_product('1 299,00 Kč')],
          );

          expectLocale(
            tester,
            find.byType(PremiumGateScreen),
            locale.languageCode,
          );
          expect(tester.takeException(), isNull);
          expectNothingCut(tester, 'the end-of-cycle wall');
          expectLegible(tester, find.text('1 299,00 Kč'), 'the store price');
        },
      );
    }
  }

  // The settings sheet is the same wall through a different door, so the same
  // widths have to hold for it: its buy button carries the price inline,
  // which is the longest single line either wall prints.
  for (final locale in [const Locale('en'), const Locale('cs')]) {
    for (final width in [360.0, 400.0]) {
      testWidgets(
        '${locale.languageCode}: the settings sheet fits at ${width.toInt()}px',
        (tester) async {
          final store = _EmptyStore()
            ..available = true
            ..products = [_product('1 299,00 Kc')];
          addTearDown(store._purchases.close);
          tester.view
            ..physicalSize = Size(width, 780)
            ..devicePixelRatio = 1.0;
          addTearDown(tester.view.reset);
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                entitlementServiceProvider.overrideWith(
                  (ref) => EntitlementService(ref, iap: store),
                ),
              ],
              child: MaterialApp(
                theme: AppTheme.theme,
                locale: locale,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                home: const Scaffold(
                  body: Align(
                    alignment: Alignment.bottomCenter,
                    child: PaywallSheet(),
                  ),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          expectLocale(tester, find.byType(PaywallSheet), locale.languageCode);
          expect(tester.takeException(), isNull);
          expectNothingCut(tester, 'the settings paywall sheet');
        },
      );
    }
  }
}
