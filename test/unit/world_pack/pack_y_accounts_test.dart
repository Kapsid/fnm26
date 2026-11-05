import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' show Locale;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/util/message_text.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/press/pundit_predictions.dart';
import 'package:fnm/domain/services/press/persona.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/domain/services/world_pack/active_world.dart';
import 'package:fnm/domain/services/world_pack/pack_paths.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/press/pundit_prediction_service.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';
import 'package:fnm/features/y/y_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../../helpers/test_database.dart';
import '../greenland/greenland_fixtures.dart';

const _goldenFile = 'test/unit/world_pack/fixtures/v1_world_pin.json';
const _pinSeed = 42;
const _czechia = 12, _slovakia = 48, _albania = 1;

PackYAccount _account(
  int n,
  String name,
  YVoice voice, {
  int? nationId,
}) => PackYAccount(
  id: kPackAddedIdBase + n,
  name: name,
  voice: voice,
  nationId: nationId,
);

/// Ten competitive afternoons of every sort, with ranking gaps wide enough
/// for the numbers desk to speak.
List<YContext> _tenMatches() => [
  for (var i = 0; i < 10; i++)
    plainContext((
      opponent: 'Opponent $i',
      nationRank: 40,
      opponentRank: i.isEven ? 5 + i : 90 + i,
      scored: i % 4,
      conceded: (i + 1) % 3,
      date: DateTime(2027, 3, 1).add(Duration(days: 30 * i)),
      key: 'fx:${1000 + i}',
      competitive: true,
      stakes: YStakes.qualifier,
      shootoutWon: null,
      away: i.isOdd,
    )),
];

/// The posts nation [nation] (id [nationId]) gets over ten matches, with
/// [accounts] as the world's added accounts.
List<YPost> _feed(
  String nation,
  int nationId,
  List<PackYAccount> accounts, {
  int seed = 7,
}) => YAccountsScope.run(
  YAccountsScope.forNation(accounts, nationId),
  () => YFeed.forRun(_tenMatches(), nation: nation, seed: seed),
);

Future<ProviderContainer> _world() async {
  final db = createTestDatabase();
  addTearDown(db.close);
  final c = greenlandContainer(db);
  addTearDown(c.dispose);
  await c.read(seedLoaderProvider).ensureSeeded();
  return c;
}

void main() {
  test('empty scope: personaFor identical to the pin', () {
    final golden =
        (jsonDecode(File(_goldenFile).readAsStringSync())
                as Map<String, Object?>)['y']!
            as Map<String, Object?>;
    for (final v in YVoice.values) {
      for (var i = 0; i < 10; i++) {
        final outside = YFeed.personaFor(v, 'Czechia', _pinSeed, 'k$i');
        final inside = YAccountsScope.run(
          const [],
          () => YFeed.personaFor(v, 'Czechia', _pinSeed, 'k$i'),
        );
        expect(outside.displayName, golden['${v.name}/$i'], reason: '$v/$i');
        expect(inside, outside, reason: '$v/$i');
      }
    }
    expect(YAccountsScope.current, isEmpty);
    expect(YFeed.namedAccounts.first, 'The Numbers Desk');
  });

  test('accounts of another voice leave a cast unchanged', () {
    final meme = [_account(0, 'MemeLord', YVoice.meme)];
    for (var i = 0; i < 20; i++) {
      expect(
        YAccountsScope.run(
          meme,
          () => YFeed.personaFor(YVoice.fan, 'Czechia', 3, 'k$i'),
        ),
        YFeed.personaFor(YVoice.fan, 'Czechia', 3, 'k$i'),
      );
    }
  });

  test("an added fan for Czechia posts in Czechia's feed within 10 matches "
      "and never in Slovakia's", () {
    final accounts = [
      _account(0, 'Pepa z Kotle', YVoice.fan, nationId: _czechia),
    ];
    final czech = _feed('Czechia', _czechia, accounts);
    expect(
      czech.where((p) => p.displayName == 'Pepa z Kotle'),
      isNotEmpty,
    );
    expect(
      czech
          .where((p) => p.displayName == 'Pepa z Kotle')
          .every((p) => p.voice == YVoice.fan),
      isTrue,
    );
    for (final seed in [1, 7, 99]) {
      expect(
        _feed(
          'Slovakia',
          _slovakia,
          accounts,
          seed: seed,
        ).where((p) => p.displayName == 'Pepa z Kotle'),
        isEmpty,
      );
    }
  });

  test("an all-nations pundit appears in two nations' feeds", () {
    final accounts = [_account(1, 'Professor Ball', YVoice.pundit)];
    for (final (name, id) in [('Czechia', _czechia), ('Slovakia', _slovakia)]) {
      expect(
        _feed(
          name,
          id,
          accounts,
        ).where((p) => p.displayName == 'Professor Ball'),
        isNotEmpty,
        reason: name,
      );
    }
  });

  test('an added stats account shares the stats posts with The Numbers '
      'Desk', () {
    final accounts = [_account(2, 'Expected Goals Guy', YVoice.stats)];
    final names = {
      for (var i = 0; i < 40; i++)
        YAccountsScope.run(
          accounts,
          () => YFeed.personaFor(YVoice.stats, 'Czechia', 7, 'k$i'),
        ).displayName,
    };
    expect(names, {'The Numbers Desk', 'Expected Goals Guy'});
    final stats = _feed(
      'Czechia',
      _czechia,
      accounts,
    ).where((p) => p.voice == YVoice.stats).map((p) => p.displayName).toSet();
    expect(stats, {'The Numbers Desk', 'Expected Goals Guy'});
    // The wire stays the wire.
    expect(
      YAccountsScope.run(
        accounts,
        () => YFeed.personaFor(YVoice.breaking, 'Czechia', 7, 'k1'),
      ).displayName,
      'The Wire',
    );
  });

  test('its profile trait is YCast.traitFor(name)', () {
    const fan = 'Pepa z Kotle', numbers = 'Expected Goals Guy';
    final accounts = [
      _account(0, fan, YVoice.fan),
      _account(2, numbers, YVoice.stats),
    ];
    final posts = _feed('Czechia', _czechia, accounts);
    final byFan = posts.firstWhere((p) => p.displayName == fan);
    final byNumbers = posts.firstWhere((p) => p.displayName == numbers);
    expect(byFan.handle, YFeed.handleFor(fan));
    expect(YFeed.personaOf(byFan).trait, YCast.traitFor(fan));
    expect(byNumbers.handle, YFeed.handleFor(numbers));
    expect(YFeed.personaOf(byNumbers).trait, YTrait.statshead);

    // Shown under its Czech name, it is still read under its own.
    final pack = WorldPack(
      uuid: 'u',
      name: 'W',
      author: '',
      formatVersion: kPackFormatVersion,
      madeWithVersion: '1.1.0',
      addedYAccounts: accounts,
      localized: {
        PackPaths.addedY(kPackAddedIdBase): {'cs': 'Pepík'},
      },
    );
    expect(ActiveWorld(pack).yAccountOriginal('Pepík'), fan);
    final before = ActiveWorld.current;
    addTearDown(() => ActiveWorld.current = before);
    ActiveWorld.current = ActiveWorld(pack);
    final shown = (
      voice: byFan.voice,
      handle: YFeed.handleFor('Pepík'),
      displayName: 'Pepík',
      template: byFan.template,
      variant: byFan.variant,
      args: byFan.args,
      date: byFan.date,
      key: byFan.key,
      replyTo: byFan.replyTo,
      mood: byFan.mood,
    );
    expect(YFeed.personaOf(shown).trait, YCast.traitFor(fan));
  });

  group('at most half the picks (ruling 2)', () {
    test('as many added fans as the cast: every account equally likely', () {
      final accounts = [
        for (var i = 0; i < YCast.castSize; i++)
          _account(i, 'Added Fan $i', YVoice.fan),
      ];
      var addedPicks = 0;
      const n = 4000;
      for (var i = 0; i < n; i++) {
        final p = YAccountsScope.run(
          accounts,
          () => YFeed.personaFor(YVoice.fan, 'Czechia', 3, 'k$i'),
        );
        if (p.displayName.startsWith('Added Fan')) addedPicks++;
      }
      expect(addedPicks / n, closeTo(0.5, 0.05));
    });

    test('with 10 added fans, their share of fan posts is at most about '
        '50%', () {
      final accounts = [
        for (var i = 0; i < 10; i++) _account(i, 'Added Fan $i', YVoice.fan),
      ];
      var addedPicks = 0;
      final seen = <String>{};
      const n = 4000;
      for (var i = 0; i < n; i++) {
        final p = YAccountsScope.run(
          accounts,
          () => YFeed.personaFor(YVoice.fan, 'Czechia', 3, 'k$i'),
        );
        seen.add(p.displayName);
        if (p.displayName.startsWith('Added Fan')) addedPicks++;
      }
      expect(addedPicks / n, lessThan(0.55));
      expect(addedPicks / n, greaterThan(0.45));
      expect(seen, containsAll([for (final a in accounts) a.name]));

      // And in a real feed: across seeds, the fan posts by added accounts.
      var fanPosts = 0, byAdded = 0;
      for (var seed = 0; seed < 30; seed++) {
        for (final p in _feed('Czechia', _czechia, accounts, seed: seed)) {
          if (p.voice != YVoice.fan) continue;
          fanPosts++;
          if (p.displayName.startsWith('Added Fan')) byAdded++;
        }
      }
      expect(fanPosts, greaterThan(100));
      expect(byAdded / fanPosts, lessThan(0.6));
    });

    test('three added stats accounts share half of the stats picks', () {
      final accounts = [
        for (var i = 0; i < 3; i++) _account(i, 'Numbers $i', YVoice.stats),
      ];
      var desk = 0;
      const n = 2000;
      for (var i = 0; i < n; i++) {
        if (YAccountsScope.run(
              accounts,
              () => YFeed.personaFor(YVoice.stats, 'Czechia', 3, 'k$i'),
            ) ==
            YFeed.numbersDesk) {
          desk++;
        }
      }
      expect(desk / n, closeTo(0.5, 0.05));
    });
  });

  test('the pundit inbox piece and the feed name the same pundit', () {
    final en = lookupAppLocalizations(const Locale('en'));
    final accounts = [
      _account(0, 'Professor Ball', YVoice.pundit),
      _account(1, 'Old Number Nine', YVoice.expro),
    ];
    final groups = [
      for (var g = 0; g < 6; g++) [for (var i = 0; i < 4; i++) 1 + g + i * 6],
    ];
    final call = PunditPredictions.call(
      groups: groups,
      sides: {
        for (var id = 1; id <= 24; id++)
          id: (nationId: id, strength: 90.0 - id, rank: id),
      },
      mine: 5,
    );
    var sawAdded = false;
    for (var i = 0; i < 30; i++) {
      final key = 'pundits:0:1:world:1:9:2030-1-$i';
      YAccountsScope.run(accounts, () {
        final body = renderMsgPart(
          en,
          punditsMessageBody(
            call: call,
            nameOf: (id) => 'Nation $id',
            mine: 'Czechia',
            seed: 3,
            key: key,
          ),
        );
        final posts = YFeed.forPundits(
          competition: 'World Championship',
          favourite: 'Nation ${call.favourite}',
          darkHorse: 'Nation ${call.darkHorse}',
          date: DateTime(2030),
          key: key,
          nation: 'Czechia',
          seed: 3,
        );
        final pundit = posts.firstWhere((p) => p.voice == YVoice.pundit);
        final expro = posts.firstWhere((p) => p.voice == YVoice.expro);
        final parts = body.split('\n\n');
        expect(parts.first, contains(pundit.displayName), reason: key);
        expect(parts.last, contains(expro.displayName), reason: key);
        if (pundit.displayName == 'Professor Ball') sawAdded = true;
      });
    }
    expect(sawAdded, isTrue);
  });

  group("the career's own copy", () {
    test(
      "a career reads its world's accounts for its nation, and an "
      'unreadable world reads as none',
      timeout: const Timeout.factor(4),
      () async {
        final c = await _world();
        final packs = c.read(worldPackRepositoryProvider);
        final packId = await c
            .read(worldPackServiceProvider)
            .createFromDefault('W');
        final mine = _account(0, 'Home Voice', YVoice.fan, nationId: _albania);
        final everywhere = _account(1, 'Everyone', YVoice.pundit);
        final elsewhere = _account(
          2,
          'Elsewhere',
          YVoice.fan,
          nationId: _czechia,
        );
        await packs.save(
          packId,
          (await packs.load(packId))!.copyWith(
            addedYAccounts: [mine, everywhere, elsewhere],
          ),
        );
        final careers = c.read(careerServiceProvider);
        final id = (await careers.create(
          nationId: _albania,
          managerName: 'M',
          rngSeed: 5,
          worldPackId: packId,
        )).valueOrNull!.id;
        final plain = (await careers.create(
          nationId: _albania,
          managerName: 'M',
          rngSeed: 5,
        )).valueOrNull!.id;
        final career = (await c.read(careerRepositoryProvider).byId(id))!;

        expect(
          [
            for (final a in await careerYAccountsForDisplay(packs, career))
              a.name,
          ],
          ['Home Voice', 'Everyone'],
        );
        // Editing the pack later changes nothing for the career.
        await packs.save(
          packId,
          (await packs.load(packId))!.copyWith(addedYAccounts: const []),
        );
        expect(await careerYAccountsForDisplay(packs, career), hasLength(2));
        expect(
          await careerYAccountsForDisplay(
            packs,
            (await c.read(careerRepositoryProvider).byId(plain))!,
          ),
          isEmpty,
        );

        final db = c.read(appDatabaseProvider);
        await db.customStatement(
          'UPDATE career_worlds SET json = ? WHERE career_id = ?',
          ['{"broken', id],
        );
        final reported = <FlutterErrorDetails>[];
        final before = FlutterError.onError;
        FlutterError.onError = reported.add;
        addTearDown(() => FlutterError.onError = before);
        expect(await careerYAccountsForDisplay(packs, career), isEmpty);
        expect(reported.where((r) => r.library == 'y'), hasLength(1));
        final feed = await c.read(yFeedProvider(id).future);
        expect(feed.posts, isA<List<YPost>>());
      },
    );
  });
}
