import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/util/sponsor_label.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/federation/sponsors.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/domain/services/world_pack/active_world.dart';
import 'package:fnm/domain/services/world_pack/pack_paths.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/sponsor_providers.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';
import 'package:fnm/features/y/y_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/l10n/app_localizations_cs.dart';
import 'package:fnm/l10n/app_localizations_en.dart';

import '../../helpers/test_database.dart';
import '../greenland/greenland_fixtures.dart';

const _albania = 1;
const _goldenFile = 'test/unit/world_pack/fixtures/v1_world_pin.json';
const _packFile = 'test/unit/world_pack/fixtures/v1_pack.json';

PackSponsor _added(
  int n,
  SponsorDeal deal, {
  String name = 'Grill Co',
  String industry = 'happyBurgers',
  String description = '',
}) => PackSponsor(
  id: kPackAddedIdBase + n,
  name: name,
  deal: deal,
  industry: industry,
  description: description,
);

List<String> _ids(List<Sponsor> s) => [for (final b in s) b.id];

/// A seeded container over a fresh database.
Future<ProviderContainer> _world() async {
  final db = createTestDatabase();
  addTearDown(db.close);
  final c = greenlandContainer(db);
  addTearDown(c.dispose);
  await c.read(seedLoaderProvider).ensureSeeded();
  return c;
}

Future<SponsorRound> _round(ProviderContainer c, int id) async {
  c.invalidate(sponsorRoundProvider(id));
  final SponsorRound? r = await c.read(sponsorRoundProvider(id).future);
  return r!;
}

void main() {
  group('the draw', () {
    test('no extras: brandsFor identical to the pin for seeds 1..20, '
        'cycles 0..3', () {
      final golden =
          (jsonDecode(File(_goldenFile).readAsStringSync())
                  as Map<String, Object?>)['sponsors']!
              as Map<String, Object?>;
      for (var s = 1; s <= 20; s++) {
        for (var cycle = 0; cycle <= 3; cycle++) {
          final pinned = golden['$s/$cycle'];
          expect(
            _ids(Sponsors.brandsFor(seed: s, cycle: cycle, czech: false)),
            pinned,
          );
          expect(
            _ids(
              Sponsors.brandsFor(
                seed: s,
                cycle: cycle,
                czech: false,
                extra: const [],
              ),
            ),
            pinned,
          );
        }
      }
    });

    test('an added risky sponsor is offered in some round within 10 cycles '
        'on seed 7', () {
      final grill = Sponsor.added(_added(0, SponsorDeal.risky));
      final rounds = [
        for (var cycle = 0; cycle < 10; cycle++)
          Sponsors.brandsFor(
            seed: 7,
            cycle: cycle,
            czech: false,
            extra: [grill],
          ),
      ];
      expect(rounds.any((r) => r.contains(grill)), isTrue);
      for (final r in rounds) {
        // Still one risky deal and three shapes a round.
        expect(r.where((b) => b.risky), hasLength(1));
        expect(r.map((b) => b.deal).toSet(), hasLength(3));
      }
    });

    test('is the same every time for a seed', () {
      final extra = [
        for (var i = 0; i < 5; i++)
          Sponsor.added(_added(i, SponsorDeal.values[i])),
      ];
      for (var cycle = 0; cycle < 6; cycle++) {
        expect(
          Sponsors.brandsFor(seed: 3, cycle: cycle, czech: false, extra: extra),
          Sponsors.brandsFor(seed: 3, cycle: cycle, czech: false, extra: extra),
        );
      }
    });

    test('fifty added risky brands take at most about half the risky slot', () {
      final extra = [
        for (var i = 0; i < 50; i++)
          Sponsor.added(_added(i, SponsorDeal.risky, name: 'R$i')),
      ];
      var added = 0;
      var rounds = 0;
      for (var seed = 0; seed < 200; seed++) {
        for (var cycle = 0; cycle < 3; cycle++) {
          final r = Sponsors.brandsFor(
            seed: seed,
            cycle: cycle,
            czech: false,
            extra: extra,
          ).firstWhere((b) => b.risky);
          rounds++;
          if (r.builtIn == null) added++;
        }
      }
      // Pooled as fifty-six brands, the added ones would hold ~89%.
      expect(added / rounds, inInclusiveRange(0.4, 0.6));
    });

    test('one added brand of a shape is as likely as one built-in', () {
      final grill = Sponsor.added(_added(0, SponsorDeal.familyFriendly));
      var seen = 0;
      for (var seed = 0; seed < 400; seed++) {
        if (Sponsors.brandsFor(
          seed: seed,
          cycle: 0,
          czech: false,
          extra: [grill],
        ).contains(grill)) {
          seen++;
        }
      }
      // Family friendly is in two rounds of three (two plain shapes of four
      // per round) and is one brand among eight: about 1 in 16.
      expect(seen, inInclusiveRange(10, 45));
    });
  });

  group('a sponsor', () {
    test('an added one is keyed pack<id> and equal by id', () {
      final a = Sponsor.added(_added(3, SponsorDeal.bigPayer));
      expect(a.id, 'pack${kPackAddedIdBase + 3}');
      expect(a, Sponsor.added(_added(3, SponsorDeal.bigPayer, name: 'Other')));
      expect(a.czechOnly, isFalse);
      expect(a.builtIn, isNull);
      expect(Sponsor.of(SponsorBrand.miners).builtIn, SponsorBrand.miners);
      expect(Sponsor.builtIns, hasLength(SponsorBrand.values.length));
      expect(_ids(Sponsor.builtIns), [
        for (final b in SponsorBrand.values) b.name,
      ]);
    });

    test('its deal drives the money exactly as a built-in one does', () {
      for (final d in SponsorDeal.values) {
        final builtIn = SponsorBrand.values.firstWhere((b) => b.deal == d);
        for (final rank in [1, 80, 209]) {
          final a = Sponsors.offerOf(Sponsor.added(_added(0, d)), rank);
          final b = Sponsors.offerOf(Sponsor.of(builtIn), rank);
          expect(
            (a.euros, a.levels, a.board, a.morale),
            (b.euros, b.levels, b.board, b.morale),
          );
        }
      }
    });

    test('its press key reads back only with the pack sponsors given', () {
      final a = Sponsor.added(_added(9, SponsorDeal.risky));
      final key = Sponsors.pressKey(2030, a);
      expect(key, 'sponsor:2030:pack${kPackAddedIdBase + 9}');
      expect(Sponsors.brandOfPressKey(key), isNull);
      expect(Sponsors.brandOfPressKey(key, extra: [a]), a);
      expect(
        Sponsors.brandOfPressKey('sponsor:2030:agrofart', extra: [a]),
        Sponsor.of(SponsorBrand.agrofart),
      );
    });
  });

  group('labels', () {
    final locales = <AppLocalizations>[
      AppLocalizationsEn(),
      AppLocalizationsCs(),
    ];
    tearDown(() => ActiveWorld.current = ActiveWorld.none);

    test('an added sponsor without a description shows the deal-type line', () {
      for (final l in locales) {
        final lines = {
          SponsorDeal.risky: l.sponsorDealLineRisky,
          SponsorDeal.bigPayer: l.sponsorDealLineBigPayer,
          SponsorDeal.crowdPleaser: l.sponsorDealLineCrowdPleaser,
          SponsorDeal.familyFriendly: l.sponsorDealLineFamilyFriendly,
          SponsorDeal.marketing: l.sponsorDealLineMarketing,
        };
        expect(lines.values.toSet(), hasLength(5));
        for (final e in lines.entries) {
          final s = Sponsor.added(_added(0, e.key));
          expect(sponsorFlavour(l, s), e.value);
          expect(sponsorDealLine(l, e.key), e.value);
          expect(e.value.trim(), isNotEmpty);
          expect(e.value, isNot(contains('—')));
        }
        // A description, when there is one, is what it says.
        expect(
          sponsorFlavour(
            l,
            Sponsor.added(
              _added(0, SponsorDeal.risky, description: 'Flame-grilled.'),
            ),
          ),
          'Flame-grilled.',
        );
      }
    });

    test("the label is the sponsor's own, whatever world is on screen", () {
      WorldPack world(
        String uuid,
        List<PackSponsor> added, {
        Map<String, Map<String, String>> localized = const {},
      }) => WorldPack(
        uuid: uuid,
        name: uuid,
        author: '',
        formatVersion: kPackFormatVersion,
        madeWithVersion: '1.1.0',
        addedSponsors: added,
        localized: localized,
      );
      final mine = _added(0, SponsorDeal.risky, description: 'Flame-grilled.');
      final s = Sponsor.added(mine, world: 'mine');
      // Another world whose added sponsor has the same id, a per-language
      // value and all: none of it reaches this sponsor.
      final other = _added(
        0,
        SponsorDeal.risky,
        name: 'Other Co',
        description: 'Not ours.',
      );
      final others = ActiveWorld(
        world(
          'other',
          [other],
          localized: {
            PackPaths.addedSponsor(other.id): {'en': 'Other EN', 'cs': 'Jiné'},
            PackPaths.addedSponsorDescription(other.id): {'cs': 'Cizí.'},
          },
        ),
      );
      for (final l in locales) {
        ActiveWorld.current = others.inLanguage(l.localeName);
        expect(sponsorBrandName(l, s), 'Grill Co');
        expect(sponsorFlavour(l, s), 'Flame-grilled.');
      }
      // Its own world gives only the per-language values it has.
      final own = ActiveWorld(
        world(
          'mine',
          [_added(0, SponsorDeal.risky, name: 'Stale Name')],
          localized: {
            PackPaths.addedSponsor(mine.id): {'cs': 'Gril s.r.o.'},
            PackPaths.addedSponsorDescription(mine.id): {'cs': 'Z grilu.'},
          },
        ),
      );
      ActiveWorld.current = own.inLanguage('en');
      expect(sponsorBrandName(AppLocalizationsEn(), s), 'Grill Co');
      expect(sponsorFlavour(AppLocalizationsEn(), s), 'Flame-grilled.');
      ActiveWorld.current = own.inLanguage('cs');
      expect(sponsorBrandName(AppLocalizationsCs(), s), 'Gril s.r.o.');
      expect(sponsorFlavour(AppLocalizationsCs(), s), 'Z grilu.');
    });

    test('name and industry: the pack name, a built-in industry', () {
      final pack = _added(
        0,
        SponsorDeal.bigPayer,
        industry: SponsorBrand.miners.name,
      );
      for (final l in locales) {
        final s = Sponsor.added(pack);
        expect(sponsorBrandName(l, s), 'Grill Co');
        expect(
          sponsorIndustryLabel(l, s),
          sponsorIndustryLabel(l, Sponsor.of(SponsorBrand.miners)),
        );
        // An industry this build does not know reads as none.
        expect(
          sponsorIndustryLabel(
            l,
            Sponsor.added(_added(0, SponsorDeal.risky, industry: 'quantum')),
          ),
          '',
        );
      }
    });
  });

  group('in a career', () {
    test(
      'a world row that cannot be read: the Y feed still builds, the round '
      'reports an error',
      timeout: const Timeout.factor(4),
      () async {
        final db = createTestDatabase();
        addTearDown(db.close);
        final c = greenlandContainer(db);
        addTearDown(c.dispose);
        await c.read(seedLoaderProvider).ensureSeeded();
        final service = c.read(worldPackServiceProvider);
        final packId = await service.createFromDefault('W');
        final id =
            (await c
                    .read(careerServiceProvider)
                    .create(
                      nationId: _albania,
                      managerName: 'M',
                      rngSeed: 5,
                      worldPackId: packId,
                    ))
                .valueOrNull!
                .id;
        // A signed added sponsor's press row, as the story reads it.
        await c
            .read(careerRepositoryProvider)
            .recordPressAnswer(
              careerId: id,
              cycle: 0,
              questionKey: 'sponsor:2026:pack$kPackAddedIdBase',
              tone: Sponsors.pressTone,
              moraleDelta: -2,
              boardDelta: -3,
              answeredAt: DateTime(2026, 9, 2),
            );
        await db.customStatement(
          'UPDATE career_worlds SET json = ? WHERE career_id = ?',
          ['{"broken', id],
        );
        final reported = <FlutterErrorDetails>[];
        final before = FlutterError.onError;
        FlutterError.onError = reported.add;
        addTearDown(() => FlutterError.onError = before);

        final feed = await c.read(yFeedProvider(id).future);
        expect(feed.posts, isA<List<YPost>>());
        await expectLater(
          c.read(sponsorRoundProvider(id).future),
          throwsA(anything),
        );
        expect(
          reported.map((r) => r.library),
          containsAll(<String>['sponsor']),
          reason: 'both are reported',
        );
        expect(
          reported.where((r) => r.library == 'sponsor'),
          hasLength(2),
        );
      },
    );

    test(
      "signing an added sponsor pays its deal's money and writes a press "
      'key that brandOfPressKey reads back',
      timeout: const Timeout.factor(4),
      () async {
        final c = await _world();
        final packs = c.read(worldPackRepositoryProvider);
        final service = c.read(worldPackServiceProvider);
        final packId = await service.createFromDefault('W');
        final grill = _added(0, SponsorDeal.risky);
        await packs.save(
          packId,
          (await packs.load(packId))!.copyWith(addedSponsors: [grill]),
        );
        final extra = [Sponsor.added(grill)];
        // A seed whose first round offers it.
        var seed = 0;
        while (!Sponsors.brandsFor(
          seed: seed,
          cycle: 0,
          czech: false,
          extra: extra,
        ).contains(extra.single)) {
          seed++;
        }
        final careers = c.read(careerServiceProvider);
        final id = (await careers.create(
          nationId: _albania,
          managerName: 'M',
          rngSeed: seed,
          worldPackId: packId,
        )).valueOrNull!.id;
        final r = await _round(c, id);
        final offer = r.offers.firstWhere((o) => o.brand == extra.single);
        expect(offer.risky, isTrue);
        expect(offer.euros, greaterThan(0));
        final repo = c.read(careerRepositoryProvider);
        final before = (await repo.byId(id))!.budget;
        expect(await c.read(sponsorServiceProvider).sign(id, offer), isTrue);
        expect((await repo.byId(id))!.budget, before + offer.euros);

        final rows = await repo.pressAnswers(id);
        expect(rows, hasLength(1));
        expect(rows.single.questionKey, 'sponsor:2026:${grill.key}');
        expect(rows.single.boardDelta, offer.board);
        expect(rows.single.moraleDelta, offer.morale);
        expect(
          Sponsors.brandOfPressKey(rows.single.questionKey, extra: extra),
          extra.single,
        );

        // The career keeps its own copy: deleting the pack changes nothing.
        await service.delete(packId);
        final after = await _round(c, id);
        expect(after.decided, isTrue);
        expect(after.chosen, offer);
      },
    );

    test(
      "a 1.1.0 career's sponsor round is unchanged",
      timeout: const Timeout.factor(4),
      () async {
        final c = await _world();
        final raw =
            jsonDecode(File(_packFile).readAsStringSync())
                as Map<String, Object?>;
        final pack = WorldPack.fromJson(WorldPack.migrate(raw));
        final packId = await c
            .read(worldPackRepositoryProvider)
            .insert(pack, const {});
        final careers = c.read(careerServiceProvider);
        for (final seed in [1, 42]) {
          final plain = (await careers.create(
            nationId: _albania,
            managerName: 'M',
            rngSeed: seed,
          )).valueOrNull!.id;
          final onPack = (await careers.create(
            nationId: _albania,
            managerName: 'M',
            rngSeed: seed,
            worldPackId: packId,
          )).valueOrNull!.id;
          final a = await _round(c, plain);
          final b = await _round(c, onPack);
          expect(b.offers, a.offers);
          expect(
            _ids([for (final o in b.offers) o.brand]),
            _ids(Sponsors.brandsFor(seed: seed, cycle: 0, czech: false)),
          );
        }
      },
    );
  });
}
