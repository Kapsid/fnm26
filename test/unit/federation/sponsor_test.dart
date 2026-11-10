import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart' show Locale;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/util/sponsor_label.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/db/career_bundle.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/federation/federation_finance.dart';
import 'package:fnm/domain/services/federation/sponsors.dart';
import 'package:fnm/domain/services/press/press.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/budget_setup_screen.dart';
import 'package:fnm/features/federation/federation_service.dart';
import 'package:fnm/features/federation/sponsor_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/press/press_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../../helpers/test_database.dart';

/// The general sponsor: once a cycle three brands offer a deal for the whole
/// cycle, each with a price. Derived offers; only the choice is stored.
void main() {
  group('the offers', () {
    List<SponsorOffer> offers({
      int seed = 7,
      int cycle = 0,
      String code = 'ESP',
      int rank = 1,
    }) => Sponsors.offersFor(
      seed: seed,
      cycle: cycle,
      nationCode: code,
      worldRank: rank,
    );

    test('the pool is at least thirty brands, every deal shape in it', () {
      expect(SponsorBrand.values.length, greaterThanOrEqualTo(30));
      expect(
        SponsorBrand.values.where((b) => !b.czechOnly).length,
        greaterThanOrEqualTo(30),
      );
      expect(
        SponsorBrand.values.map((b) => b.deal).toSet(),
        SponsorDeal.values.toSet(),
      );
    });

    test('are the same every time they are read', () {
      expect(offers(), offers());
      expect(offers(cycle: 1), isNot(offers()));
    });

    test("three different brands a cycle, one risky, never last cycle's", () {
      for (var seed = 0; seed < 30; seed++) {
        Set<Sponsor>? last;
        for (var cycle = 0; cycle < 12; cycle++) {
          final o = offers(seed: seed, cycle: cycle);
          expect(o, hasLength(3));
          final brands = o.map((x) => x.brand).toSet();
          expect(brands, hasLength(3));
          expect(o.where((x) => x.risky), hasLength(1));
          expect(o.map((x) => x.deal).toSet(), hasLength(3));
          expect([for (final x in o) x.index], [0, 1, 2]);
          if (last != null) expect(brands.intersection(last), isEmpty);
          last = brands;
        }
      }
    });

    test('every offer is a trade-off: it always costs something', () {
      for (final b in SponsorBrand.values) {
        for (final rank in [1, 60, 209]) {
          final o = Sponsors.offerOf(b, rank);
          expect(o.hasCost, isTrue, reason: '$o is a free gift');
          expect(
            o.euros > 0 || o.levels > 0 || o.board > 0 || o.morale > 0,
            isTrue,
            reason: '$o gives nothing',
          );
        }
      }
    });

    test('are sized by the nation, the risky one paying the most', () {
      // A whole cycle's money: €2.5M to €10M for a plain deal.
      expect(Sponsors.baseEuros(1), 10000000);
      expect(Sponsors.baseEuros(209), 2500000);
      var last = Sponsors.baseEuros(1);
      for (final r in [10, 30, 60, 100, 150, 209]) {
        expect(Sponsors.baseEuros(r), lessThanOrEqualTo(last));
        last = Sponsors.baseEuros(r);
      }
      for (final b in SponsorBrand.values) {
        expect(
          Sponsors.offerOf(b, 1).euros,
          greaterThanOrEqualTo(Sponsors.offerOf(b, 180).euros),
        );
      }
      int pays(SponsorDeal d, int rank) => Sponsors.offerOf(
        SponsorBrand.values.firstWhere((b) => b.deal == d),
        rank,
      ).euros;
      for (final rank in [1, 60, 209]) {
        final risky = pays(SponsorDeal.risky, rank);
        for (final d in SponsorDeal.values) {
          if (d != SponsorDeal.risky) {
            expect(risky, greaterThan(pays(d, rank)));
          }
        }
        expect(pays(SponsorDeal.bigPayer, rank), lessThanOrEqualTo(15000000));
        // Never more than the central grant pays for a cycle.
        expect(risky, lessThan(FederationFinance.centralGrant * 2));
      }
      final m = Sponsors.offerOf(SponsorBrand.hexagon, 1);
      expect(m.levels, inInclusiveRange(5, 12));
      expect(Sponsors.offerOf(SponsorBrand.hexagon, 209).levels, 5);
      expect(m.marketingEuros, m.levels * FederationFinance.investLevelPrice);
    });

    test('Czech brands are offered to Czechia only', () {
      var seen = false;
      for (var seed = 0; seed < 30; seed++) {
        for (var cycle = 0; cycle < 8; cycle++) {
          expect(
            offers(seed: seed, cycle: cycle).any((o) => o.brand.czechOnly),
            isFalse,
          );
          seen |= offers(
            seed: seed,
            cycle: cycle,
            code: 'CZE',
          ).any((o) => o.brand.czechOnly);
        }
      }
      expect(seen, isTrue);
    });

    test('a round is keyed by the year its cycle opens in', () {
      expect(Sponsors.roundYear(0), 2026);
      expect(Sponsors.roundYear(1), 2030);
      expect(Sponsors.declinedKind(2030), 'sponsor:2030:none');
      // The first build's later seasons of a cycle settle it too.
      final legacy = Sponsors.legacySettlingKinds(0);
      expect(legacy, contains('sponsor:2027:none'));
      expect(legacy, contains('sponsor:2029:2'));
      expect(legacy.any((k) => k.startsWith('sponsor:2026:')), isFalse);
      expect(legacy.any((k) => k.startsWith('sponsor:2030:')), isFalse);
    });

    test('the press key names the round and the brand, nothing else does', () {
      final key = Sponsors.pressKey(2030, SponsorBrand.agrofart);
      expect(key, 'sponsor:2030:agrofart');
      expect(Sponsors.brandOfPressKey(key), SponsorBrand.agrofart);
      expect(Sponsors.brandOfPressKey('conf:3:1'), isNull);
      expect(Sponsors.brandOfPressKey(Sponsors.declinedKind(2027)), isNull);
    });

    test('a dubious deal is mocked on Y: a story and replies under it', () {
      final posts = YFeed.forSponsor(
        brand: 'Agrofart',
        date: DateTime(2027, 1, 2),
        key: 'sponsor:2026:agrofart',
        nation: '12',
        seed: 7,
      );
      expect(posts.first.template, YTemplate.sponsorDubious);
      final replies = posts.where((p) => p.replyTo != null).toList();
      expect(replies, isNotEmpty);
      expect(
        replies.every((p) => p.template == YTemplate.sponsorMocked),
        isTrue,
      );
      expect(posts.every((p) => p.args.contains('Agrofart')), isTrue);
    });
  });

  group('in a save', () {
    late AppDatabase db;
    late List<Nation> nations;

    setUp(() {
      db = createTestDatabase();
      addTearDown(db.close);
      nations =
          (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                  as List<dynamic>)
              .map((e) => Nation.fromJson(e as Map<String, Object?>))
              .toList();
    });

    ProviderContainer open() {
      final c = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          premiumUnlockedProvider.overrideWith((ref) => true),
          seedSourceProvider.overrideWithValue(
            InMemorySeedSource(nationList: nations, playerList: const []),
          ),
        ],
      );
      addTearDown(c.dispose);
      return c;
    }

    Future<int> newCareer(ProviderContainer c, {int seed = 99}) async {
      await c.read(seedLoaderProvider).ensureSeeded();
      return (await c
              .read(careerServiceProvider)
              .create(nationId: 12, managerName: 'M', rngSeed: seed))
          .valueOrNull!
          .id;
    }

    Future<SponsorRound> round(ProviderContainer c, int id) async {
      c.invalidate(sponsorRoundProvider(id));
      final r = await c.read(sponsorRoundProvider(id).future);
      return r!;
    }

    Future<HubEvent> event(ProviderContainer c, int id) async {
      c.invalidate(nextEventProvider(id));
      return c.read(nextEventProvider(id).future);
    }

    Future<int> budget(ProviderContainer c, int id) async =>
        (await c.read(careerRepositoryProvider).byId(id))!.budget;

    Future<PressEffect> press(ProviderContainer c, int id) async {
      c.invalidate(pressEffectProvider(id));
      return c.read(pressEffectProvider(id).future);
    }

    /// Moves the career's clock to [date], in the cycle it is in.
    Future<void> moveTo(ProviderContainer c, int id, DateTime date) async {
      final repo = c.read(careerRepositoryProvider);
      final career = (await repo.byId(id))!;
      await repo.advanceCycle(id, career.cyclePointer, date);
    }

    test('the cycle opens on it, before the budget, and asks once', () async {
      final c = open();
      final id = await newCareer(c);
      final first = await event(c, id);
      expect(first.kind, HubEventKind.budget);
      expect(first.route, contains('/sponsor'));
      expect((await event(c, id)).route, contains('/sponsor'));

      final before = await budget(c, id);
      expect(await c.read(sponsorServiceProvider).decline(id), isTrue);
      // Declining does nothing but settle the round.
      expect(await budget(c, id), before);
      expect(await c.read(careerRepositoryProvider).pressAnswers(id), isEmpty);
      final r = await round(c, id);
      expect(r.decided, isTrue);
      expect(r.chosen, isNull);
      expect((await event(c, id)).route, contains('/budget-setup'));
      expect(
        await c.read(sponsorServiceProvider).sign(id, r.offers.first),
        isFalse,
        reason: 'nothing more may be signed this cycle',
      );
    });

    test('one round a cycle: the later seasons ask nothing', () async {
      final c = open();
      final id = await newCareer(c);
      await c.read(sponsorServiceProvider).decline(id);
      await c
          .read(competitionRepositoryProvider)
          .markDrawWatched(id, 0, budgetSetupKind);
      final r0 = await round(c, id);
      expect(r0.year, 2026);
      for (final date in [
        DateTime(2027, 9, 10),
        DateTime(2028, 10, 1),
        DateTime(2029, 9, 10),
      ]) {
        await moveTo(c, id, date);
        final r = await round(c, id);
        expect(r.year, 2026, reason: '$date');
        expect(r.decided, isTrue, reason: '$date');
        final e = await event(c, id);
        expect(e.kind, isNot(HubEventKind.sponsor), reason: '$date');
        expect(e.route ?? '', isNot(contains('/sponsor')), reason: '$date');
      }
      // The next cycle brings the next round, on other brands.
      await c
          .read(careerRepositoryProvider)
          .advanceCycle(id, 1, DateTime(2030, 9));
      final r1 = await round(c, id);
      expect(r1.cycle, 1);
      expect(r1.year, 2030);
      expect(r1.decided, isFalse);
      expect(
        r1.offers
            .map((o) => o.brand)
            .toSet()
            .intersection(r0.offers.map((o) => o.brand).toSet()),
        isEmpty,
      );
    });

    test(
      'an old save that answered a later season is never asked again',
      () async {
        final c = open();
        final id = await newCareer(c);
        final comp = c.read(competitionRepositoryProvider);
        await comp.markDrawWatched(id, 0, budgetSetupKind);
        await moveTo(c, id, DateTime(2028, 10));
        // The first build's 2028/29 round, signed: a marker and a press row.
        const brand = SponsorBrand.miners;
        await comp.markDrawWatched(id, 0, Sponsors.chosenKind(2028, 1));
        await c
            .read(careerRepositoryProvider)
            .recordPressAnswer(
              careerId: id,
              cycle: 0,
              questionKey: Sponsors.pressKey(2028, brand),
              tone: Sponsors.pressTone,
              moraleDelta: 0,
              boardDelta: -2,
              answeredAt: DateTime(2028, 10),
            );
        final r = await round(c, id);
        expect(r.decided, isTrue);
        expect(r.chosen?.brand, brand);
        expect((await event(c, id)).kind, isNot(HubEventKind.sponsor));
        expect(
          await c.read(sponsorServiceProvider).sign(id, r.offers.first),
          isFalse,
        );
        // Its effect runs to the cycle's close.
        await moveTo(c, id, DateTime(2030, 6));
        expect(await press(c, id), (morale: 0, board: -2));
      },
    );

    test(
      'a save that signed a retired brand reads its deal under the new name',
      () async {
        final c = open();
        final id = await newCareer(c);
        final comp = c.read(competitionRepositoryProvider);
        await comp.markDrawWatched(id, 0, budgetSetupKind);
        await moveTo(c, id, DateTime(2028, 10));
        final en = lookupAppLocalizations(const Locale('en'));
        final cs = lookupAppLocalizations(const Locale('cs'));
        // Written by a build that still printed these brands as Hexagon and
        // Můra: the press row stores the id, spelled out here as it was.
        for (final (year, stored) in [(2028, 'hexagon'), (2029, 'moth')]) {
          final brand = Sponsors.brandOfPressKey('sponsor:$year:$stored');
          expect(brand, isNotNull, reason: stored);
          expect(sponsorBrandName(en, brand!), isNot(contains('Hexagon')));
          expect(sponsorBrandName(cs, brand), isNot(contains('Můra')));
        }
        expect(sponsorBrandName(en, SponsorBrand.hexagon), 'Boltworth');
        expect(sponsorIndustryLabel(en, SponsorBrand.hexagon), 'Engineering');
        expect(sponsorBrandName(en, SponsorBrand.moth), 'Dragonfly');
        expect(sponsorBrandName(cs, SponsorBrand.moth), 'Vážka');

        await comp.markDrawWatched(id, 0, Sponsors.chosenKind(2028, 1));
        await c
            .read(careerRepositoryProvider)
            .recordPressAnswer(
              careerId: id,
              cycle: 0,
              questionKey: 'sponsor:2028:hexagon',
              tone: Sponsors.pressTone,
              moraleDelta: -1,
              boardDelta: 0,
              answeredAt: DateTime(2028, 10),
            );
        final r = await round(c, id);
        expect(r.decided, isTrue);
        expect(r.chosen?.brand, SponsorBrand.hexagon);
        expect(sponsorBrandName(en, r.chosen!.brand), 'Boltworth');
        await moveTo(c, id, DateTime(2030, 6));
        expect(await press(c, id), (morale: -1, board: 0));
      },
    );

    test('cash is credited once', () async {
      final c = open();
      final id = await newCareer(c);
      final r = await round(c, id);
      final cash = r.offers.firstWhere((o) => o.euros > 0);
      final before = await budget(c, id);
      final service = c.read(sponsorServiceProvider);
      expect(await service.sign(id, cash), isTrue);
      expect(await service.sign(id, cash), isFalse);
      expect(await budget(c, id), before + cash.euros);
      expect((await round(c, id)).chosen, cash);
      c.invalidate(federationFundsProvider(id));
      expect(
        (await c.read(federationFundsProvider(id).future)).balance,
        before + cash.euros,
      );
    });

    test('board and morale move for the whole cycle, then stop', () async {
      final c = open();
      final id = await newCareer(c);
      final r = await round(c, id);
      final risky = r.offers.firstWhere((o) => o.risky);
      expect(await press(c, id), (morale: 0, board: 0));
      expect(await c.read(sponsorServiceProvider).sign(id, risky), isTrue);
      expect(await press(c, id), (morale: risky.morale, board: risky.board));
      expect(risky.board, lessThan(0));
      expect(risky.morale, lessThan(0));

      // Every later season of the cycle: still there.
      for (final date in [DateTime(2027, 9, 10), DateTime(2030, 6, 1)]) {
        await moveTo(c, id, date);
        expect(await press(c, id), (morale: risky.morale, board: risky.board));
      }
      // And not carried into the next cycle.
      await c
          .read(careerRepositoryProvider)
          .advanceCycle(id, 1, DateTime(2030, 9));
      expect(await press(c, id), (morale: 0, board: 0));
    });

    test(
      'a Commercial / PR deal pays at the cycle close, that cycle only',
      () async {
        // A save whose first round holds a marketing deal.
        final code = nations.firstWhere((n) => n.id == 12).code;
        var seed = 0;
        while (!Sponsors.brandsFor(
          seed: seed,
          cycle: 0,
          czech: code == 'CZE',
        ).any((b) => b.deal == SponsorDeal.marketing)) {
          seed++;
        }
        final c = open();
        final id = await newCareer(c, seed: seed);
        final federation = c.read(federationServiceProvider);
        final without = (await federation.incomeForCycle(id, 0)).commercial;
        final deal = (await round(
          c,
          id,
        )).offers.where((o) => o.deal == SponsorDeal.marketing).firstOrNull;
        expect(deal, isNotNull);
        final before = await budget(c, id);
        expect(await c.read(sponsorServiceProvider).sign(id, deal!), isTrue);
        expect(await budget(c, id), before, reason: 'no cash for levels');
        expect(
          (await federation.incomeForCycle(id, 0)).commercial,
          without + FederationFinance.commercialReturn(deal.marketingEuros),
        );
        await c
            .read(careerRepositoryProvider)
            .advanceCycle(id, 1, DateTime(2030, 9));
        expect((await federation.incomeForCycle(id, 1)).commercial, 0);
      },
    );

    test(
      'an old save caught mid-cycle is asked once, at the next stop',
      () async {
        final c = open();
        final id = await newCareer(c);
        await c
            .read(competitionRepositoryProvider)
            .markDrawWatched(id, 0, budgetSetupKind);
        await moveTo(c, id, DateTime(2028, 10, 1));
        expect((await round(c, id)).decided, isFalse);
        expect((await event(c, id)).kind, HubEventKind.sponsor);
        expect(await press(c, id), (morale: 0, board: 0));
        expect(
          (await c.read(federationServiceProvider).incomeForCycle(id, 0))
              .commercial,
          0,
        );
        // Moving the world on without answering is an answer.
        expect(
          await c.read(sponsorServiceProvider).settleUnanswered(id),
          isTrue,
        );
        expect((await round(c, id)).decided, isTrue);
        expect((await event(c, id)).kind, isNot(HubEventKind.sponsor));
      },
    );

    test('the choice travels in a career bundle', () async {
      final c = open();
      final id = await newCareer(c);
      final r = await round(c, id);
      final risky = r.offers.firstWhere((o) => o.risky);
      await c.read(sponsorServiceProvider).sign(id, risky);
      final bundle = CareerBundle.decode(
        CareerBundle.encode(await CareerBundle.export(db, id)),
      ).bundle!;
      final imported = await CareerBundle.import(db, bundle);
      expect(imported, isNot(id));
      final back = await round(c, imported);
      expect(back.decided, isTrue);
      expect(back.chosen, risky);
      expect(await budget(c, imported), await budget(c, id));
      expect(await press(c, imported), (
        morale: risky.morale,
        board: risky.board,
      ));
    });
  });
}
