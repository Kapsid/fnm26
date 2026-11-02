import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
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

import '../../helpers/test_database.dart';

/// The general sponsor: every season three brands offer a deal, each with a
/// price. Derived offers; only the choice is stored.
void main() {
  group('the offers', () {
    List<SponsorOffer> offers({
      int seed = 7,
      int season = 2026,
      String code = 'ESP',
      int rank = 1,
    }) => Sponsors.offersFor(
      seed: seed,
      season: season,
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
      expect(offers(season: 2027), isNot(offers()));
    });

    test("three different brands a season, one risky, never last season's", () {
      for (var seed = 0; seed < 30; seed++) {
        Set<SponsorBrand>? last;
        for (var season = 2026; season < 2046; season++) {
          final o = offers(seed: seed, season: season);
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
      expect(Sponsors.baseEuros(1), 4000000);
      expect(Sponsors.baseEuros(209), 1000000);
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
        expect(pays(SponsorDeal.bigPayer, rank), lessThanOrEqualTo(6000000));
      }
      final m = Sponsors.offerOf(SponsorBrand.hexagon, 1);
      expect(m.levels, inInclusiveRange(2, 5));
      expect(m.marketingEuros, m.levels * FederationFinance.investLevelPrice);
    });

    test('Czech brands are offered to Czechia only', () {
      var seen = false;
      for (var seed = 0; seed < 30; seed++) {
        for (var season = 2026; season < 2034; season++) {
          expect(
            offers(seed: seed, season: season).any((o) => o.brand.czechOnly),
            isFalse,
          );
          seen |= offers(
            seed: seed,
            season: season,
            code: 'CZE',
          ).any((o) => o.brand.czechOnly);
        }
      }
      expect(seen, isTrue);
    });

    test('a season runs September to August, held inside its cycle', () {
      expect(Sponsors.seasonOf(DateTime(2026, 7), 2026), 2026);
      expect(Sponsors.seasonOf(DateTime(2027, 8, 31), 2026), 2026);
      expect(Sponsors.seasonOf(DateTime(2027, 9), 2026), 2027);
      expect(Sponsors.seasonOf(DateTime(2030, 7, 19), 2026), 2029);
      expect(Sponsors.seasonOf(DateTime(2030, 9), 2030), 2030);
    });

    test('the press key names the season and the brand, nothing else does', () {
      final key = Sponsors.pressKey(2027, SponsorBrand.agrofart);
      expect(Sponsors.brandOfPressKey(key), SponsorBrand.agrofart);
      expect(Sponsors.seasonOfPressKey(key), 2027);
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

    Future<int> newCareer(ProviderContainer c) async {
      await c.read(seedLoaderProvider).ensureSeeded();
      return (await c
              .read(careerServiceProvider)
              .create(nationId: 12, managerName: 'M', rngSeed: 99))
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
        reason: 'nothing more may be signed this season',
      );
    });

    test('a new season brings a new round, once', () async {
      final c = open();
      final id = await newCareer(c);
      await c.read(sponsorServiceProvider).decline(id);
      await c
          .read(competitionRepositoryProvider)
          .markDrawWatched(id, 0, budgetSetupKind);
      final r0 = await round(c, id);
      expect(r0.season, 2026);
      await moveTo(c, id, DateTime(2027, 9, 10));
      final r1 = await round(c, id);
      expect(r1.season, 2027);
      expect(r1.decided, isFalse);
      expect(
        r1.offers
            .map((o) => o.brand)
            .toSet()
            .intersection(r0.offers.map((o) => o.brand).toSet()),
        isEmpty,
      );
      expect((await event(c, id)).kind, HubEventKind.sponsor);
      // Moving the world on without answering is an answer.
      expect(
        await c.read(sponsorServiceProvider).settleUnanswered(id),
        isTrue,
      );
      expect((await round(c, id)).decided, isTrue);
      expect((await event(c, id)).kind, isNot(HubEventKind.sponsor));
    });

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

    test('board and morale move for the season only', () async {
      final c = open();
      final id = await newCareer(c);
      final r = await round(c, id);
      final risky = r.offers.firstWhere((o) => o.risky);
      expect(await press(c, id), (morale: 0, board: 0));
      expect(await c.read(sponsorServiceProvider).sign(id, risky), isTrue);
      expect(await press(c, id), (morale: risky.morale, board: risky.board));
      expect(risky.board, lessThan(0));
      expect(risky.morale, lessThan(0));

      // The next season, same cycle: gone.
      await moveTo(c, id, DateTime(2027, 9, 10));
      expect(await press(c, id), (morale: 0, board: 0));
      // And not carried into the next cycle either.
      await c
          .read(careerRepositoryProvider)
          .advanceCycle(id, 1, DateTime(2030, 9));
      expect(await press(c, id), (morale: 0, board: 0));
    });

    test(
      'a Commercial / PR deal pays at the cycle close, that cycle only',
      () async {
        final c = open();
        final id = await newCareer(c);
        final federation = c.read(federationServiceProvider);
        final without = (await federation.incomeForCycle(id, 0)).commercial;
        // The first season whose round holds a marketing deal.
        SponsorOffer? deal;
        for (var year = 2026; deal == null && year < 2030; year++) {
          await moveTo(c, id, DateTime(year, 9, 10));
          deal = (await round(c, id)).offers
              .where((o) => o.deal == SponsorDeal.marketing)
              .firstOrNull;
        }
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

    test('an old save is asked, and nothing changes until it answers', () async {
      final c = open();
      final id = await newCareer(c);
      await c
          .read(competitionRepositoryProvider)
          .markDrawWatched(id, 0, budgetSetupKind);
      expect((await round(c, id)).decided, isFalse);
      expect(await press(c, id), (morale: 0, board: 0));
      expect(
        (await c.read(federationServiceProvider).incomeForCycle(id, 0))
            .commercial,
        0,
      );
    });

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
