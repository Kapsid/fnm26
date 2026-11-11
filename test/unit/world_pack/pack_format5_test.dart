import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/util/sponsor_label.dart';
import 'package:fnm/domain/services/federation/sponsor_industries.dart';
import 'package:fnm/domain/services/federation/sponsors.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/domain/services/world_pack/active_world.dart';
import 'package:fnm/domain/services/world_pack/pack_keys.dart';
import 'package:fnm/domain/services/world_pack/pack_profanity.dart';
import 'package:fnm/domain/services/world_pack/pack_rules.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/l10n/app_localizations_en.dart';

/// Format 5 (1.1.1): a built-in sponsor's industry and a Y account's
/// @handle. Written only when used, so every pack without them stays
/// readable by a 1.1.0 build; read, ruled and shown in play.
void main() {
  tearDown(() => ActiveWorld.current = ActiveWorld.none);

  const fan = 'HomeEndHarry';
  const pundit = 'TheOldStopper';

  WorldPack pack({
    Map<String, String> sponsorIndustries = const {},
    Map<String, String> yHandles = const {},
    Map<String, String> yAccounts = const {},
    List<PackYAccount> added = const [],
  }) => WorldPack(
    uuid: 'u',
    name: 'Five',
    author: '',
    formatVersion: kPackFormatVersion,
    madeWithVersion: '1.1.1',
    sponsorIndustries: sponsorIndustries,
    yHandles: yHandles,
    yAccounts: yAccounts,
    addedYAccounts: added,
  );

  PackYAccount account(int n, String name, {String? handle}) => PackYAccount(
    id: kPackAddedIdBase + n,
    name: name,
    voice: YVoice.fan,
    handle: handle,
  );

  WorldPack roundTrip(WorldPack p) => WorldPack.fromJson(
    WorldPack.migrate(
      jsonDecode(jsonEncode(p.asWritten.toJson())) as Map<String, Object?>,
    ),
  );

  group('the file', () {
    test('a pack without an industry or a handle is written as before', () {
      final plain = pack(added: [account(0, 'Grill Fan')]).asWritten;
      expect(plain.formatVersion, 3);
      final json = plain.toJson();
      expect(json.containsKey('sponsorIndustries'), isFalse);
      expect(json.containsKey('yHandles'), isFalse);
      expect(
        (json['addedYAccounts']! as List).single as Map,
        isNot(contains('handle')),
      );
    });

    test('each new part makes it format 5, and round-trips', () {
      for (final p in [
        pack(
          sponsorIndustries: {
            SponsorBrand.miners.name: SponsorIndustry.coffee.id,
          },
        ),
        pack(yHandles: const {fan: 'Harry_99'}),
        pack(added: [account(0, 'Grill Fan', handle: 'GrillFan')]),
      ]) {
        expect(p.asWritten.formatVersion, 5);
        expect(roundTrip(p), p);
      }
    });

    test('a format-4 file (no new keys) reads, with nothing set', () {
      final json = pack().copyWith(formatVersion: 4).toJson()
        ..remove('sponsorIndustries')
        ..remove('yHandles');
      final p = WorldPack.fromJson(WorldPack.migrate(json));
      expect(p.formatVersion, kPackFormatVersion);
      expect(p.sponsorIndustries, isEmpty);
      expect(p.yHandles, isEmpty);
      // A format-4 file already holding a format-5 key is no format-4 file.
      expect(
        () => WorldPack.migrate({
          ...json,
          'yHandles': {fan: 'x'},
        }),
        throwsFormatException,
      );
    });

    test('a handle of the wrong type is refused', () {
      final json = pack(added: [account(0, 'Grill Fan')]).toJson();
      ((json['addedYAccounts']! as List).single as Map)['handle'] = 3;
      expect(() => WorldPack.fromJson(json), throwsFormatException);
    });
  });

  group('handles', () {
    test('letters A to Z, digits and underscores, up to 29', () {
      expect(PackRules.checkHandle('Harry_99'), isNull);
      expect(PackRules.checkHandle(''), FieldReason.empty);
      expect(PackRules.checkHandle('a' * 30), FieldReason.tooLong);
      expect(PackRules.checkHandle('a' * 29), isNull);
      for (final bad in ['Harry 99', 'Pepík', 'a-b', '@Harry', 'a.b']) {
        expect(PackRules.checkHandle(bad), FieldReason.badCharacters);
      }
    });

    test("another account's handle is taken, whatever the case", () {
      // A game account's own handle, and one the pack gives another.
      final p = pack(
        yHandles: const {fan: 'theoldstopper'},
        added: [account(0, 'Grill Fan', handle: 'Harry_99')],
      );
      expect(PackRules.takenHandle(p, 'TheOldStopper', original: fan), isTrue);
      expect(PackRules.takenHandle(p, '@harry_99', original: pundit), isTrue);
      expect(
        PackRules.takenHandle(p, 'Harry_99', addedId: kPackAddedIdBase),
        isFalse,
      );
      expect(PackRules.takenHandle(p, 'NobodyHasThis'), isFalse);
      final issues = PackRules.issues(p);
      expect(
        issues.whereType<BadField>().map((i) => (i.where, i.reason)),
        contains(('yHandles.$fan', FieldReason.duplicate)),
      );
      // The pundit gives his handle up once renamed: it is free again.
      final renamed = p.copyWith(yAccounts: const {pundit: 'Old Stopper'});
      expect(PackRules.issues(renamed).whereType<BadField>(), isEmpty);
    });

    test('a bad, unknown or offensive handle is listed', () {
      final p = pack(
        yHandles: const {'NoSuchAccount': 'Ghost', fan: 'bad handle'},
        added: [account(0, 'Grill Fan', handle: 'Fuck')],
      );
      expect(
        PackRules.issues(p).whereType<BadField>().map((i) => i.where),
        contains('yHandles.$fan'),
      );
      expect(
        PackRules.notAllowed(p).map((i) => i.where),
        contains('addedYAccounts.$kPackAddedIdBase.handle'),
      );
      final keys = PackGameKeys.of(
        const [],
        codes: const {},
        fringeRanges: const {},
      );
      expect(
        keys.check(p).map((i) => i.where),
        contains('yHandles.NoSuchAccount'),
      );
      // Masked in play, as every name.
      expect(
        maskedForPlay(p).addedYAccounts.single.handle,
        isNot('Fuck'),
      );
    });

    test('the feed shows the handle the world sets', () {
      final grill = account(0, 'Grill Fan', handle: 'GrillFan');
      final p = pack(yHandles: const {fan: 'Harry_99'}, added: [grill]);
      YPost post(String name) => (
        voice: YVoice.fan,
        handle: YFeed.handleFor(name),
        displayName: name,
        template: YTemplate.values.first,
        variant: 0,
        args: const <String>[],
        date: DateTime(2027),
        key: name,
        replyTo: null,
        mood: null,
      );
      final feed = YFeed.renamedIn(
        (posts: [post(fan), post(grill.name), post(pundit)], reserveFrom: null),
        ActiveWorld(p),
        added: [grill],
        addedWorld: 'u',
      );
      expect(feed.posts.map((x) => x.handle), [
        '@Harry_99',
        '@GrillFan',
        '@$pundit',
      ]);
      expect(YFeed.packHandleOf(p, fan), '@Harry_99');
      expect(YFeed.packHandleOf(p, pundit), '@$pundit');
      expect(YFeed.addedHandleOf(grill), '@GrillFan');
      expect(YFeed.addedHandleOf(account(1, 'Big Al')), '@BigAl');
    });
  });

  group('sponsor industries', () {
    final l = AppLocalizationsEn();

    test('a built-in sponsor reads in the industry the world gives it', () {
      final miners = Sponsor.of(SponsorBrand.miners);
      final own = sponsorIndustryLabel(l, miners);
      ActiveWorld.current = ActiveWorld(
        pack(
          sponsorIndustries: {
            SponsorBrand.miners.name: SponsorIndustry.coffee.id,
          },
        ),
      );
      expect(
        sponsorIndustryLabel(l, miners),
        extraIndustryLabel(l, SponsorIndustry.coffee),
      );
      expect(builtInIndustryLabel(l, SponsorBrand.miners), own);
      // Another brand's trade works too; one this build does not know falls
      // back to the brand's own.
      ActiveWorld.current = ActiveWorld(
        pack(
          sponsorIndustries: {
            SponsorBrand.miners.name: SponsorBrand.betBadger.name,
            SponsorBrand.moth.name: 'quantum',
          },
        ),
      );
      expect(
        sponsorIndustryLabel(l, miners),
        builtInIndustryLabel(l, SponsorBrand.betBadger),
      );
      expect(
        sponsorIndustryLabel(l, Sponsor.of(SponsorBrand.moth)),
        builtInIndustryLabel(l, SponsorBrand.moth),
      );
    });

    test('an unknown brand or industry is flagged, a misshapen one listed', () {
      final keys = PackGameKeys.of(
        const [],
        codes: const {},
        fringeRanges: const {},
      );
      final p = pack(
        sponsorIndustries: {
          'noSuchBrand': SponsorIndustry.coffee.id,
          SponsorBrand.moth.name: 'quantum',
          SponsorBrand.miners.name: SponsorIndustry.coffee.id,
        },
      );
      expect(keys.check(p).map((i) => i.where).toSet(), {
        'sponsorIndustries.noSuchBrand',
        'sponsorIndustries.${SponsorBrand.moth.name}',
      });
      expect(
        PackRules.issues(
          pack(sponsorIndustries: {SponsorBrand.miners.name: 'not one!'}),
        ).map((i) => i.where),
        contains('sponsorIndustries.${SponsorBrand.miners.name}'),
      );
    });
  });
}
