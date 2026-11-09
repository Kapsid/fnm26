import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/util/sponsor_label.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/federation/sponsors.dart';
import 'package:fnm/features/federation/sponsor_card.dart';
import 'package:fnm/features/federation/sponsor_providers.dart';
import 'package:fnm/features/federation/sponsor_screen.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_event_button.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/expect_whole.dart';
import '../helpers/pump_app.dart';
import '../helpers/seeded_save.dart';

/// The general sponsor screen: fits the narrowest phones in the longest
/// languages, and signing a deal takes the manager on to the budget.
void main() {
  const widths = [320.0, 360.0];
  const locales = ['fi', 'de', 'cs', 'hu', 'en'];

  /// The round with the longest names [l] has: the three longest brands
  /// (flavour lines count), a risky one among them, each on its own shape.
  SponsorRound longest(AppLocalizations l) {
    int len(SponsorBrand b) =>
        sponsorBrandName(l, b).length + sponsorFlavour(l, b).length;
    SponsorBrand longestOf(SponsorDeal d) =>
        (SponsorBrand.values.where((b) => b.deal == d).toList()
              ..sort((a, b) => len(b).compareTo(len(a))))
            .first;
    return (
      cycle: 0,
      year: 2026,
      offers: [
        Sponsors.offerOf(longestOf(SponsorDeal.marketing), 1),
        Sponsors.offerOf(longestOf(SponsorDeal.crowdPleaser), 1, index: 1),
        Sponsors.offerOf(longestOf(SponsorDeal.risky), 1, index: 2),
      ],
      chosen: null,
      decided: false,
    );
  }

  for (final locale in locales) {
    for (final width in widths) {
      testWidgets('fits at ${width.toInt()}px in $locale', (tester) async {
        final l = lookupAppLocalizations(Locale(locale));
        await tester.binding.setSurfaceSize(Size(width, 2400));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await tester.pumpApp(
          const SponsorScreen(careerId: 1),
          locale: Locale(locale),
          overrides: [
            sponsorRoundProvider.overrideWith((ref, id) async => longest(l)),
          ],
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.byType(SponsorOfferCard), findsNWidgets(3));
        expect(find.text(l.sponsorRiskyLabel), findsOneWidget);
        expectNothingCut(tester, 'the sponsor screen in $locale');

        // And the hub's button that leads here.
        await tester.pumpWidget(const SizedBox());
        await tester.pumpApp(
          Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: PrimaryButton(label: l.hubEventSponsor, onPressed: () {}),
            ),
          ),
          locale: Locale(locale),
        );
        await tester.pump();
        expect(tester.takeException(), isNull);
        expectNothingCut(tester, 'the hub button in $locale');

        // And the finances card: a deal to the cycle's close, or none.
        final round = longest(l);
        for (final chosen in [round.offers.last, null]) {
          await tester.pumpWidget(const SizedBox());
          await tester.pumpApp(
            const Scaffold(
              body: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: SponsorCard(careerId: 1),
              ),
            ),
            locale: Locale(locale),
            overrides: [
              sponsorRoundProvider.overrideWith(
                (ref, id) async => (
                  cycle: 0,
                  year: 2026,
                  offers: round.offers,
                  chosen: chosen,
                  decided: true,
                ),
              ),
            ],
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          expect(find.byKey(SponsorCard.cardKey), findsOneWidget);
          expect(
            find.text(
              chosen == null ? l.sponsorNoneCycle : l.sponsorUntilCycleEnd,
            ),
            findsOneWidget,
          );
          expectNothingCut(tester, 'the finances card in $locale');
        }
      });
    }
  }

  testWidgets('every brand card lays out at 320px in every tested language', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 20000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    for (final locale in locales) {
      await tester.pumpApp(
        Scaffold(
          body: ListView(
            children: [
              for (final b in SponsorBrand.values)
                SponsorOfferCard(
                  offer: Sponsors.offerOf(b, 1),
                  onSign: () {},
                ),
            ],
          ),
        ),
        locale: Locale(locale),
      );
      await tester.pump();
      expect(tester.takeException(), isNull, reason: locale);
      expectNothingCut(tester, 'the brand cards in $locale');
    }
  });

  for (final size in [const Size(1366, 1024), const Size(1180, 820)]) {
    for (final locale in ['en', 'de', 'cs']) {
      testWidgets('tablet: the offers are tiles side by side at '
          '${size.width.toInt()} in $locale', (tester) async {
        final save = await seedSave(tester, formFactor: FormFactor.tablet);
        late SponsorRound round;
        await tester.runAsync(() async {
          round = (await save.container.read(
            sponsorRoundProvider(save.careerId).future,
          ))!;
        });
        await pumpRoute(
          tester,
          save,
          '${Routes.sponsor}?careerId=${save.careerId}',
          size: size,
          locale: Locale(locale),
        );
        expect(tester.takeException(), isNull);
        expect(find.byKey(SponsorScreen.tabletLayoutKey), findsOneWidget);
        expect(find.byKey(SponsorScreen.tilesKey), findsOneWidget);
        final cards = [
          for (final o in round.offers)
            tester.getRect(
              find.ancestor(
                of: find.byKey(SponsorScreen.signKey(o.index)),
                matching: find.byType(SponsorOfferCard),
              ),
            ),
        ];
        expect(cards.length, greaterThan(1));
        for (var i = 1; i < cards.length; i++) {
          // One row, left to right, every tile as tall as the others.
          expect(cards[i].top, cards[0].top);
          expect(cards[i].left, greaterThan(cards[i - 1].right));
          expect(cards[i].height, closeTo(cards[0].height, 0.5));
        }
        // The Sign buttons sit level at the tiles' feet.
        final signs = [
          for (final o in round.offers)
            tester.getRect(find.byKey(SponsorScreen.signKey(o.index))),
        ];
        for (final r in signs) {
          expect(r.bottom, closeTo(signs.first.bottom, 0.5));
        }
        expect(
          tester.getRect(find.byKey(SponsorScreen.declineKey)).top,
          greaterThan(cards.first.bottom),
        );
        expectNothingCut(tester, 'the sponsor tiles in $locale');
        await tester.pumpWidget(const SizedBox());
      });
    }
  }

  testWidgets(
    'signing on a real save pays, settles the round and returns to the hub',
    (
      tester,
    ) async {
      final save = await seedSave(tester);
      final container = save.container;
      late SponsorRound round;
      late int before;
      await tester.runAsync(() async {
        round = (await container.read(
          sponsorRoundProvider(save.careerId).future,
        ))!;
        before =
            (await container
                    .read(careerRepositoryProvider)
                    .byId(save.careerId))!
                .budget;
        final event = await container.read(
          nextEventProvider(save.careerId).future,
        );
        expect(event.route, contains(Routes.sponsor));
      });
      // The real screen, at the narrowest phone, in Czech.
      await pumpRoute(
        tester,
        save,
        '${Routes.sponsor}?careerId=${save.careerId}',
        size: const Size(320, 700),
        locale: const Locale('cs'),
      );
      expect(tester.takeException(), isNull);
      expectNothingCut(tester, 'the sponsor screen on a real save');
      final cash = round.offers.firstWhere((o) => o.euros > 0);
      final sign = find.byKey(SponsorScreen.signKey(cash.index));
      await tester.ensureVisible(sign);
      await tester.pump();
      await tester.tap(sign);
      await settle(tester);
      expect(container.read(routerProvider).state.uri.path, Routes.hub);
      await tester.runAsync(() async {
        final after =
            (await container
                    .read(careerRepositoryProvider)
                    .byId(save.careerId))!
                .budget;
        expect(after, before + cash.euros);
        final settled = await container
            .read(competitionRepositoryProvider)
            .hasWatchedDraw(
              save.careerId,
              0,
              Sponsors.chosenKind(round.year, cash.index),
            );
        expect(settled, isTrue);
      });
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets('a round that cannot be read shows the error state, and the '
      "hub's button retries", (tester) async {
    final l = lookupAppLocalizations(const Locale('en'));
    await tester.pumpApp(
      const SponsorScreen(careerId: 1),
      overrides: [
        sponsorRoundProvider.overrideWith(
          (ref, id) async => throw const FormatException('broken world'),
        ),
      ],
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(AppErrorState), findsOneWidget);
    expect(find.text(l.commonRetry), findsOneWidget);
    expect(find.text(l.federationContinue), findsOneWidget);
    expect(find.byType(SponsorOfferCard), findsNothing);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpApp(
      const Scaffold(body: HubEventButton(careerId: 1)),
      overrides: [
        nextEventProvider.overrideWith(
          (ref, id) async => throw const FormatException('broken world'),
        ),
      ],
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text(l.commonRetry), findsOneWidget);
    expect(find.text(l.commonSomethingWentWrong), findsOneWidget);
  });
}
