import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/config/ui_language.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/services/classic/classic_medals.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/entitlement/entitlement_service.dart';
import 'package:fnm/features/classic/classic_providers.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/features/match/pitch/pitch_match_view.dart';
import 'package:fnm/features/match/pitch/pitch_view_providers.dart';
import 'package:fnm/features/paywall/paywall_sheet.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../helpers/classic_world.dart';
import '../helpers/seeded_save.dart';

/// Arabic, the first right-to-left language: the key screens boot in `ar`,
/// lay out without an overflow, and are drawn right to left at the root,
/// while the pitch and the scoreboard keep home on the left.
///
/// `--dart-define=AR_SHOTS=<dir>` also saves each screen as a 390x844 PNG
/// at device pixel ratio 2, in the bundled Arabic face, to look at.
const _shotsDir = String.fromEnvironment('AR_SHOTS');

const _ar = Locale('ar');

final GlobalKey _shotKey = GlobalKey();

/// Overflow reports, collected rather than thrown, so a screen reports
/// every one of them at once.
List<String> _watchOverflows() {
  final seen = <String>[];
  final original = FlutterError.onError;
  FlutterError.onError = (details) {
    final text = details.exceptionAsString();
    if (text.contains('overflowed')) {
      seen.add(text.split('\n').first);
      return;
    }
    original?.call(details);
  };
  addTearDown(() => FlutterError.onError = original);
  return seen;
}

void _phone(WidgetTester tester) {
  tester.view
    ..physicalSize = const Size(390 * 2, 844 * 2)
    ..devicePixelRatio = 2;
  addTearDown(tester.view.reset);
}

Widget _app({required Widget child}) =>
    RepaintBoundary(key: _shotKey, child: child);

Future<void> _pumpArabic(
  WidgetTester tester,
  SeededSave save,
  String location,
) async {
  _phone(tester);
  // The language the manager picked in Settings: the domain's own copy
  // (nation names, hub events) follows it, not only the widgets' locale.
  save.container.read(localeProvider.notifier).state = _ar;
  final router = save.container.read(routerProvider)..go(location);
  await tester.pumpWidget(
    _app(
      child: UncontrolledProviderScope(
        container: save.container,
        child: MaterialApp.router(
          theme: AppTheme.theme,
          locale: _ar,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    ),
  );
  await settle(tester);
}

/// The root of the screen reads right to left, and the copy is Arabic.
void _expectRtlRoot(WidgetTester tester) {
  final scaffolds = find.byType(Scaffold);
  expect(scaffolds, findsWidgets);
  final context = tester.element(scaffolds.first);
  expect(Directionality.of(context), TextDirection.rtl);
  expect(Localizations.localeOf(context).languageCode, 'ar');
}

Future<void> _shoot(WidgetTester tester, String name) async {
  if (_shotsDir.isEmpty) return;
  final boundary =
      _shotKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 2);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    await Directory(_shotsDir).create(recursive: true);
    await File(
      '$_shotsDir/$name.png',
    ).writeAsBytes(bytes!.buffer.asUint8List());
  });
}

Future<void> _check(
  WidgetTester tester,
  String name,
  List<String> overflows,
) async {
  _expectRtlRoot(tester);
  await _shoot(tester, name);
  expect(overflows, isEmpty, reason: '$name overflows:\n$overflows');
}

Future<void> _warmMatch(SeededSave save, WidgetTester tester) async {
  final warm = save.container.listen(
    matchPreviewProvider(save.careerId),
    (_, _) {},
  );
  addTearDown(warm.close);
  await tester.runAsync(
    () => save.container.read(matchPreviewProvider(save.careerId).future),
  );
}

void main() {
  testWidgets('ar: home', (tester) async {
    final overflows = _watchOverflows();
    final save = await seedSave(tester);
    await _pumpArabic(tester, save, Routes.home);
    await _check(tester, 'home', overflows);
  });

  testWidgets('ar: hub', (tester) async {
    final overflows = _watchOverflows();
    final save = await seedSave(tester);
    await _pumpArabic(tester, save, '${Routes.hub}?careerId=${save.careerId}');
    await _check(tester, 'hub', overflows);
  });

  testWidgets('ar: squad and tactics, the pitch stays left to right', (
    tester,
  ) async {
    final overflows = _watchOverflows();
    final save = await seedSave(tester);
    await _pumpArabic(
      tester,
      save,
      '${Routes.tactics}?careerId=${save.careerId}',
    );
    final pitch = find.byType(TacticsPitch);
    if (pitch.evaluate().isNotEmpty) {
      final inside = find.descendant(of: pitch, matching: find.byType(Stack));
      expect(
        Directionality.of(tester.element(inside.first)),
        TextDirection.ltr,
        reason: 'the tactics pitch is never mirrored',
      );
    }
    await _check(tester, 'tactics', overflows);
  });

  testWidgets('ar: match, Timeline; the scoreboard keeps home on the left', (
    tester,
  ) async {
    final overflows = _watchOverflows();
    final save = await seedSave(tester);
    await _warmMatch(save, tester);
    await _pumpArabic(
      tester,
      save,
      '${Routes.match}?careerId=${save.careerId}',
    );
    final board = find.byType(MatchScoreboard);
    expect(board, findsOneWidget);
    final row = find.descendant(of: board, matching: find.byType(Row)).first;
    expect(Directionality.of(tester.element(row)), TextDirection.ltr);
    await _check(tester, 'match_timeline', overflows);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('ar: match, 2D; the pitch is not mirrored', (tester) async {
    final overflows = _watchOverflows();
    final save = await seedSave(tester);
    await tester.runAsync(
      () => const MatchViewModeStore().save(MatchViewMode.pitch),
    );
    await _warmMatch(save, tester);
    await _pumpArabic(
      tester,
      save,
      '${Routes.match}?careerId=${save.careerId}',
    );
    final view = find.byType(PitchMatchView);
    expect(view, findsOneWidget);
    final inside = find
        .descendant(of: view, matching: find.byType(CustomPaint))
        .first;
    expect(Directionality.of(tester.element(inside)), TextDirection.ltr);
    await tester.pump(const Duration(seconds: 3));
    await _check(tester, 'match_2d', overflows);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('ar: standings', (tester) async {
    final overflows = _watchOverflows();
    final save = await seedSave(tester);
    await _pumpArabic(
      tester,
      save,
      '${Routes.tournaments}?careerId=${save.careerId}',
    );
    await _check(tester, 'standings', overflows);
  });

  testWidgets('ar: Classic Cups', (tester) async {
    final overflows = _watchOverflows();
    final world = loadClassicWorld();
    final save = await seedSave(
      tester,
      overrides: [
        premiumUnlockedProvider.overrideWith((ref) => false),
        classicBaseWorldProvider.overrideWith((ref) async => world),
        classicSeedProvider.overrideWithValue(() => 11),
        classicMatchSaltProvider.overrideWithValue(() => 5),
      ],
    );
    final fra = world.nations.values.firstWhere((n) => n.code == 'FRA').id;
    await tester.runAsync(
      () => save.container
          .read(classicStoreProvider)
          .addRecord(ClassicRecord(year: 2018, nationId: fra, champion: true)),
    );
    await _pumpArabic(tester, save, Routes.classic);
    await _check(tester, 'classic_cups', overflows);
  });

  testWidgets('ar: editor', (tester) async {
    final overflows = _watchOverflows();
    final save = await seedSave(
      tester,
      overrides: [
        classicBaseWorldProvider.overrideWith(
          (ref) async => loadClassicWorld(),
        ),
      ],
    );
    await _pumpArabic(tester, save, Routes.editor);
    await _check(tester, 'editor', overflows);
  });

  testWidgets('ar: settings', (tester) async {
    final overflows = _watchOverflows();
    final save = await seedSave(tester);
    await _pumpArabic(tester, save, Routes.settings);
    await _check(tester, 'settings', overflows);
  });

  testWidgets('ar: paywall', (tester) async {
    final overflows = _watchOverflows();
    final store = _Store();
    addTearDown(store.close);
    _phone(tester);
    await tester.pumpWidget(
      _app(
        child: ProviderScope(
          overrides: [
            entitlementServiceProvider.overrideWith(
              (ref) => EntitlementService(ref, iap: store),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.theme,
            locale: _ar,
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
      ),
    );
    await tester.pumpAndSettle();
    await _check(tester, 'paywall', overflows);
  });
}

/// A store with the one product on sale, priced in Western digits.
class _Store implements InAppPurchase {
  final StreamController<List<PurchaseDetails>> _purchases =
      StreamController<List<PurchaseDetails>>.broadcast();

  Future<void> close() => _purchases.close();

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => _purchases.stream;

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
        price: r'$14.49',
        rawPrice: 14.49,
        currencyCode: 'USD',
      ),
    ],
    notFoundIDs: const [],
  );

  @override
  Future<void> restorePurchases({String? applicationUserName}) async {}

  @override
  Future<String> countryCode() async => 'AE';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
