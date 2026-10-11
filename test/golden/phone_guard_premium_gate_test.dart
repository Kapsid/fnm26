import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/entitlement/entitlement_service.dart';
import 'package:fnm/features/paywall/premium_gate_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../helpers/seeded_save.dart';

/// A store selling the one product at a fixed price, so the golden carries
/// the store's own price line and a live Buy button.
class _Store implements InAppPurchase {
  final StreamController<List<PurchaseDetails>> purchases =
      StreamController<List<PurchaseDetails>>.broadcast();

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => purchases.stream;

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<ProductDetailsResponse> queryProductDetails(
    Set<String> identifiers,
  ) async => ProductDetailsResponse(
    productDetails: [
      ProductDetails(
        id: kPremiumProductId,
        title: 'Premium',
        description: 'One-time unlock',
        price: r'$12.99',
        rawPrice: 12.99,
        currencyCode: 'USD',
      ),
    ],
    notFoundIDs: const [],
  );

  // Nothing else is touched while the wall is only on show.
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<void> _pumpGate(WidgetTester tester, Size size) async {
  final store = _Store();
  addTearDown(store.purchases.close);
  tester.view
    ..physicalSize = size
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    RepaintBoundary(
      key: kAppRoot,
      child: ProviderScope(
        overrides: [
          premiumUnlockedProvider.overrideWith((ref) => false),
          entitlementServiceProvider.overrideWith(
            (ref) => EntitlementService(ref, iap: store),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.theme,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const PremiumGateScreen(),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

/// The end-of-cycle wall on a phone, pinned before its tablet width cap is
/// added: the phone page must stay exactly as it is. A tall one too, as the
/// wall's body is a scroll view once the words do not fit.
void main() {
  testWidgets('premium_gate_phone', (tester) async {
    await _pumpGate(tester, kPhoneSize);
    expect(find.text(r'$12.99'), findsOneWidget);
    await expectAppGolden('goldens/premium_gate_phone.png');
  });

  testWidgets('premium_gate_phone_tall', (tester) async {
    await _pumpGate(tester, const Size(390, 2400));
    expect(find.text(r'$12.99'), findsOneWidget);
    await expectAppGolden('goldens/premium_gate_phone_tall.png');
  });
}
