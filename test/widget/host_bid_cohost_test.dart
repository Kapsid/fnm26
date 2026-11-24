import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/host_bidding.dart';
import 'package:fnm/features/federation/host_bid_providers.dart';
import 'package:fnm/features/federation/host_bid_screen.dart';
import 'package:fnm/features/federation/investment_editor.dart'
    show formatEuros;
import 'package:intl/intl.dart';

import '../helpers/pump_app.dart';

// The co-host choice on the bid form, and the joint bid on the status card.

const Nation _lead = Nation(
  id: 12,
  name: 'Czechia',
  code: 'CZE',
  confederation: Confederation.europe,
  ranking: 40,
);
const Nation _yes = Nation(
  id: 47,
  name: 'Slovakia',
  code: 'SVK',
  confederation: Confederation.europe,
  ranking: 45,
);
const Nation _no = Nation(
  id: 21,
  name: 'Austria',
  code: 'AUT',
  confederation: Confederation.europe,
  ranking: 25,
);

const HostBidPartnerOption _agrees = HostBidPartnerOption(
  nation: _yes,
  size: 0.6,
  neighbour: true,
);
const HostBidPartnerOption _declines = HostBidPartnerOption(
  nation: _no,
  size: 0.7,
  neighbour: true,
  decline: CoHostDecline.ownBid,
);

HostBidOffer _offer({bool soloAllowed = true}) => HostBidOffer(
  careerId: 1,
  comp: HostBidComp.continental,
  editionCycle: 1,
  year: 2032,
  nation: _lead,
  size: 0.35,
  today: 0.04,
  freeFunds: 20000000,
  partners: const [_declines, _agrees],
  soloAllowed: soloAllowed,
);

Future<List<(int, int?)>> _pumpForm(
  WidgetTester tester,
  HostBidOffer offer, {
  Locale locale = const Locale('en'),
}) async {
  tester.view.physicalSize = const Size(360, 740);
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = 1.4;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  final submitted = <(int, int?)>[];
  await tester.pumpApp(
    Scaffold(
      body: HostBidForm(
        offer: offer,
        onSubmit: (levels, partner) => submitted.add((levels, partner)),
        onDecline: () {},
      ),
    ),
    locale: locale,
  );
  await tester.pumpAndSettle();
  return submitted;
}

String _text(WidgetTester tester, Key key) =>
    tester.widget<Text>(find.byKey(key)).data!;

String _pct(double p) => '${(p * 100).round()}%';

Future<void> _tap(WidgetTester tester, Finder f) async {
  await tester.scrollUntilVisible(
    f,
    120,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
  await tester.tap(f);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('alone by default; picking a partner moves the bar to the '
      'joint quote and shares the grant; submitted with the partner', (
    tester,
  ) async {
    final offer = _offer();
    final submitted = await _pumpForm(tester, offer);
    expect(tester.takeException(), isNull);
    expect(_text(tester, HostBidForm.totalKey), _pct(offer.quote(3).total));
    expect(find.byKey(HostBidForm.partnersKey), findsOneWidget);
    expect(find.text('Bid alone'), findsOneWidget);
    expect(find.text('Ready to co-host'), findsOneWidget);
    expect(
      find.text('Declines: it would rather bid on its own.'),
      findsOneWidget,
    );

    await _tap(tester, find.byKey(HostBidForm.partnerKey(_yes.id)));
    final joint = offer.quote(3, partner: _agrees);
    expect(joint.total, isNot(offer.quote(3).total));
    expect(_text(tester, HostBidForm.totalKey), _pct(joint.total));
    expect(
      _text(tester, HostBidForm.prizeKey),
      contains(formatEuros(HostBidOdds.jointBonusFor(3))),
    );
    expect(_text(tester, HostBidForm.prizeKey), contains(_yes.name));

    // A partner that declines cannot be picked.
    await _tap(tester, find.byKey(HostBidForm.partnerKey(_no.id)));
    expect(_text(tester, HostBidForm.totalKey), _pct(joint.total));

    await _tap(tester, find.text('Submit bid'));
    expect(submitted, [(3, _yes.id)]);

    // Back to alone.
    await _tap(tester, find.byKey(HostBidForm.aloneKey));
    expect(_text(tester, HostBidForm.totalKey), _pct(offer.quote(3).total));
    await _tap(tester, find.text('Submit bid'));
    expect(submitted.last, (3, null));
  });

  testWidgets('open only jointly: no "alone", the partner that agrees is '
      'picked, and the reason is said', (tester) async {
    final offer = _offer(soloAllowed: false);
    final submitted = await _pumpForm(tester, offer);
    expect(tester.takeException(), isNull);
    expect(find.byKey(HostBidForm.aloneKey), findsNothing);
    expect(
      find.text(
        'Your stadiums fall short alone. Choose a co-host to bid jointly.',
      ),
      findsOneWidget,
    );
    expect(
      _text(tester, HostBidForm.totalKey),
      _pct(offer.quote(3, partner: _agrees).total),
    );
    await _tap(tester, find.text('Submit bid'));
    expect(submitted, [(3, _yes.id)]);
  });

  for (final code in ['cs', 'de', 'el', 'fil', 'fr', 'hu', 'ja']) {
    testWidgets('the co-host choice fits on a phone at text 1.4 ($code)', (
      tester,
    ) async {
      await _pumpForm(tester, _offer(), locale: Locale(code));
      expect(tester.takeException(), isNull);
      expect(find.byKey(HostBidForm.partnersKey), findsOneWidget);
    });
  }

  testWidgets('the card says a lodged bid is joint, and that a nation too '
      'small alone may bid jointly', (tester) async {
    HostBidStatus status({
      required bool lodged,
      HostBidOffer? offer,
      Nation? partner,
    }) => HostBidStatus(
      comp: HostBidComp.continental,
      editionCycle: 1,
      year: 2032,
      nation: _lead,
      requirement: HostingRequirements.of(
        HostBidComp.continental,
        Confederation.europe,
      ),
      shortfall: (grounds: 0, bigGrounds: 0),
      barredConfederation: null,
      recentHost: false,
      lodged: lodged,
      declined: false,
      windowOpen: true,
      offer: offer,
      belowBar: offer != null,
      pledge: lodged
          ? const HostBidMarker(
              comp: HostBidComp.continental,
              editionCycle: 1,
              nationId: 12,
              levels: 2,
              permille: 300,
            )
          : null,
      pledgePartner: partner,
    );
    await tester.pumpApp(
      Scaffold(
        body: Column(
          children: [
            HostBidStatusRow(
              status: status(lodged: true, partner: _yes),
              seats: NumberFormat.decimalPattern('en'),
            ),
            HostBidStatusRow(
              status: status(
                lodged: false,
                offer: _offer(soloAllowed: false),
              ),
              seats: NumberFormat.decimalPattern('en'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Joint bid with Slovakia.'), findsOneWidget);
    expect(
      find.text(
        'Too small to host alone, but a joint bid with a co-host is open.',
      ),
      findsOneWidget,
    );
  });
}
