import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/host_bidding.dart';
import 'package:fnm/features/federation/host_bid_providers.dart';
import 'package:fnm/features/federation/host_bid_screen.dart';

import '../helpers/pump_app.dart';

const Nation _nation = Nation(
  id: 12,
  name: 'Czechia',
  code: 'CZE',
  confederation: Confederation.europe,
  ranking: 40,
);

HostBidOffer _offer({
  HostBidComp comp = HostBidComp.continental,
  int freeFunds = 20000000,
}) => HostBidOffer(
  careerId: 1,
  comp: comp,
  editionCycle: 1,
  year: comp == HostBidComp.continental ? 2032 : 2034,
  nation: _nation,
  size: 0.35,
  today: 0.04,
  freeFunds: freeFunds,
);

Future<void> _pump(
  WidgetTester tester, {
  required Size size,
  Locale locale = const Locale('en'),
  HostBidOffer? offer,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = 1.4;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  final o = offer ?? _offer();
  await tester.pumpApp(
    const HostBidScreen(careerId: 1, comp: HostBidComp.continental),
    locale: locale,
    overrides: [
      hostBidOfferProvider((
        careerId: 1,
        nationId: null,
        comp: HostBidComp.continental,
      )).overrideWith((ref) async => o),
    ],
  );
  await tester.pumpAndSettle();
}

String _text(WidgetTester tester, Key key) =>
    tester.widget<Text>(find.byKey(key)).data!;

void main() {
  const phone = Size(360, 740);
  const tablet = Size(1194, 834);

  for (final size in [phone, tablet]) {
    testWidgets('the bar follows the investment (${size.width.toInt()} wide, '
        'text 1.4)', (tester) async {
      await _pump(tester, size: size);
      expect(tester.takeException(), isNull);
      final offer = _offer();
      // Starts at three levels.
      expect(
        _text(tester, HostBidForm.totalKey),
        '${(offer.quote(3).total * 100).round()}%',
      );
      final slider = find.byKey(HostBidForm.sliderKey);
      await tester.scrollUntilVisible(
        slider,
        120,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.drag(slider, const Offset(-2000, 0));
      await tester.pumpAndSettle();
      expect(_text(tester, HostBidForm.investKey), '+0%');
      expect(
        _text(tester, HostBidForm.totalKey),
        '${(offer.quote(0).total * 100).round()}%',
      );
      await tester.drag(slider, const Offset(2000, 0));
      await tester.pumpAndSettle();
      final top = offer.quote(HostBidOdds.maxLevels);
      expect(
        _text(tester, HostBidForm.totalKey),
        '${(top.total * 100).round()}%',
      );
      expect(top.total, greaterThan(offer.quote(3).total));
      expect(tester.takeException(), isNull);
    });
  }

  // The longest languages, at the largest text the game supports, on the
  // narrowest phone the layouts are held to.
  for (final code in ['cs', 'de', 'el', 'fil', 'hu', 'pl']) {
    testWidgets('fits on a phone at text 1.4 ($code)', (tester) async {
      await _pump(
        tester,
        size: phone,
        locale: Locale(code),
        offer: _offer(comp: HostBidComp.worldChampionship),
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('a federation that can afford one level gets one', (
    tester,
  ) async {
    await _pump(tester, size: phone, offer: _offer(freeFunds: 1500000));
    expect(tester.takeException(), isNull);
    final offer = _offer(freeFunds: 1500000);
    expect(offer.maxLevels, 1);
    expect(
      _text(tester, HostBidForm.totalKey),
      '${(offer.quote(1).total * 100).round()}%',
    );
  });

  // The card on the budget and rollover screens, with every line it can
  // show: the rotation, both shortfalls, an open offer.
  HostBidStatus status(
    HostBidComp comp, {
    HostingShortfall shortfall = (grounds: 0, bigGrounds: 0),
    Confederation? barred,
    bool recent = false,
    bool open = false,
  }) => HostBidStatus(
    comp: comp,
    editionCycle: 1,
    year: comp == HostBidComp.continental ? 2032 : 2034,
    nation: _nation,
    requirement: HostingRequirements.of(comp, Confederation.europe),
    shortfall: shortfall,
    barredConfederation: barred,
    recentHost: recent,
    lodged: false,
    declined: false,
    windowOpen: open,
    offer: open ? _offer(comp: comp) : null,
  );

  for (final code in ['en', 'de', 'fi', 'hu', 'el', 'pt', 'cs', 'fil']) {
    testWidgets('the hosting card fits at 360 wide, text 1.4 ($code)', (
      tester,
    ) async {
      tester.view.physicalSize = phone;
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 1.4;
      addTearDown(tester.view.reset);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.pumpApp(
        const Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: HostBidStatusCard(careerId: 1, interactive: true),
            ),
          ),
        ),
        locale: Locale(code),
        overrides: [
          hostBidStatusProvider((
            careerId: 1,
            nationId: null,
          )).overrideWith(
            (ref) async => [
              status(
                HostBidComp.continental,
                shortfall: (grounds: 1, bigGrounds: 2),
                recent: true,
              ),
              status(
                HostBidComp.worldChampionship,
                barred: Confederation.europe,
                shortfall: (grounds: 3, bigGrounds: 1),
              ),
              status(HostBidComp.continental, open: true),
            ],
          ),
        ],
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byKey(HostBidStatusCard.cardKey), findsOneWidget);
    });
  }
}
