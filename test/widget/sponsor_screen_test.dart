import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/util/sponsor_label.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/federation/sponsors.dart';
import 'package:fnm/features/federation/sponsor_card.dart';
import 'package:fnm/features/federation/sponsor_providers.dart';
import 'package:fnm/features/federation/sponsor_screen.dart';
import 'package:fnm/features/hub/hub_event.dart';
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
}
