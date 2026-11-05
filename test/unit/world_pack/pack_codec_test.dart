import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/repositories/world_pack_repository.dart';
import 'package:fnm/data/seed/pool_generator.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/club/clubs.dart';
import 'package:fnm/domain/services/federation/sponsors.dart';
import 'package:fnm/domain/services/player/player_traits.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/domain/services/world_pack/pack_codec.dart';
import 'package:fnm/domain/services/world_pack/pack_rules.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';

import '../../helpers/test_database.dart';
import '../greenland/greenland_fixtures.dart';

PackPlayer _p(int id, PlayerPosition pos) => PackPlayer(
  id: id,
  name: 'Player $id',
  age: 25,
  position: pos,
  attributes: const PlayerAttributes(physical: 60, technical: 60, stamina: 60),
  potential: 90,
);

List<PackPlayer> _squad([int extra = 0]) {
  var id = 1;
  return [
    for (var i = 0; i < 3; i++) _p(id++, PlayerPosition.gk),
    for (var i = 0; i < 7; i++) _p(id++, PlayerPosition.cb),
    for (var i = 0; i < 10; i++) _p(id++, PlayerPosition.cm),
    for (var i = 0; i < 3 + extra; i++) _p(id++, PlayerPosition.st),
  ];
}

WorldPack _pack({String name = 'My World', List<PackPlayer>? squad}) =>
    WorldPack(
      uuid: 'u-1',
      name: name,
      author: 'Me',
      formatVersion: kPackFormatVersion,
      madeWithVersion: '1.1.0',
      squads: {1: squad ?? _squad()},
      nations: const {1: (name: 'Testland', code: 'TST')},
      clubs: const {'Old FC': 'New FC'},
    );

Future<Uint8List> _png(int w, int h) async {
  final rec = ui.PictureRecorder();
  ui.Canvas(rec).drawRect(
    ui.Rect.fromLTWH(0, 0, w.toDouble(), h.toDouble()),
    ui.Paint()..color = const ui.Color(0xFFC81E1E),
  );
  final image = await rec.endRecording().toImage(w, h);
  return (await image.toByteData(
    format: ui.ImageByteFormat.png,
  ))!.buffer.asUint8List();
}

Uint8List _file(Object json) =>
    Uint8List.fromList(gzip.encode(utf8.encode(jsonEncode(json))));

Map<String, Object?> _raw(WorldPack p, {Map<String, Object?>? trophies}) => {
  'format': 1,
  'pack': p.toJson(),
  'trophies': trophies ?? <String, Object?>{},
};

void main() {
  testWidgets('round trip keeps the pack and re-encodes the trophy', (
    tester,
  ) async {
    await tester.runAsync(() async {
      final src = await _png(1000, 1500);
      final pack = _pack().copyWith(trophies: {'europe'});
      final r = await PackCodec.decode(PackCodec.encode(pack, {'europe': src}));
      expect(r, isA<PackDecoded>());
      final d = r as PackDecoded;
      expect(d.pack, pack);
      expect(d.trophies.keys, ['europe']);
      expect(d.trophies['europe'], isNot(src));
      final codec = await ui.instantiateImageCodec(d.trophies['europe']!);
      final f = await codec.getNextFrame();
      expect((f.image.width, f.image.height), (400, 600));
    });
  });

  test('an incomplete pack still decodes', () async {
    final r = await PackCodec.decode(
      PackCodec.encode(_pack(squad: _squad().take(5).toList()), const {}),
    );
    expect(r, isA<PackDecoded>());
  });

  Future<PackRejection?> reason(Uint8List b) async {
    final r = await PackCodec.decode(b);
    return r is PackRejected ? r.reason : null;
  }

  test('a 9 MB file is tooBig', () async {
    expect(
      await reason(Uint8List(9 << 20)),
      PackRejection.tooBig,
    );
  });

  test('a gzip bomb is tooBig without being unzipped', () async {
    final out = BytesBuilder(copy: false);
    final sink = gzip.encoder.startChunkedConversion(
      ByteConversionSink.from(_Collect(out)),
    );
    final chunk = Uint8List(1 << 20)..fillRange(0, 1 << 20, 0x20);
    for (var i = 0; i < 200; i++) {
      sink.add(chunk);
    }
    sink.close();
    final bomb = out.takeBytes();
    expect(bomb.length, lessThan(PackCodec.maxFileBytes));
    expect(await reason(bomb), PackRejection.tooBig);
  });

  test('random bytes and a non-gzip file are notAPack', () async {
    expect(
      await reason(Uint8List.fromList(List.generate(500, (i) => i % 251))),
      PackRejection.notAPack,
    );
    expect(
      await reason(Uint8List.fromList([0x1f, 0x8b, 1, 2, 3])),
      PackRejection.notAPack,
    );
    expect(
      await reason(_file({'format': 2, 'tables': <String, Object?>{}})),
      PackRejection.notAPack,
      reason: 'a career bundle is not a pack',
    );
    expect(await reason(_file([1, 2])), PackRejection.notAPack);
  });

  test('a pack made with a newer pack format is newerFormat', () async {
    final raw = _raw(_pack());
    (raw['pack']! as Map<String, Object?>)['formatVersion'] = 99;
    expect(await reason(_file(raw)), PackRejection.newerFormat);
  });

  test('an override key over 100 characters is badData', () async {
    final p = _pack().copyWith(clubs: {'k' * 101: 'New FC'});
    expect(await reason(_file(_raw(p))), PackRejection.badData);
  });

  test('format 99 is newerFormat', () async {
    expect(
      await reason(_file({..._raw(_pack()), 'format': 99})),
      PackRejection.newerFormat,
    );
  });

  test('a 10 000 character name is badData', () async {
    expect(
      await reason(_file(_raw(_pack(name: 'x' * 10000)))),
      PackRejection.badData,
    );
  });

  test('5 000 players in one nation is badData', () async {
    final big = [for (var i = 0; i < 5000; i++) _p(i, PlayerPosition.cm)];
    expect(await reason(_file(_raw(_pack(squad: big)))), PackRejection.badData);
  });

  test('an extra top-level script key is badData', () async {
    expect(
      await reason(_file({..._raw(_pack()), 'script': 'rm -rf /'})),
      PackRejection.badData,
    );
  });

  test('an extra key inside the pack is badData', () async {
    final raw = _raw(_pack());
    (raw['pack']! as Map<String, Object?>)['script'] = 'x';
    expect(await reason(_file(raw)), PackRejection.badData);
  });

  test('more than nine trophies, or an unknown key, is badData', () async {
    expect(
      await reason(
        _file(
          _raw(_pack(), trophies: {for (var i = 0; i < 10; i++) 'k$i': ''}),
        ),
      ),
      PackRejection.badData,
    );
    expect(
      await reason(_file(_raw(_pack(), trophies: {'nonsense': ''}))),
      PackRejection.badData,
    );
  });

  test('a trophy that is not an image is badTrophy', () async {
    final junk = base64Encode(utf8.encode('not an image'));
    expect(
      await reason(_file(_raw(_pack(), trophies: {'world': junk}))),
      PackRejection.badTrophy,
    );
    expect(
      await reason(_file(_raw(_pack(), trophies: {'world': '%%%'}))),
      PackRejection.badTrophy,
    );
  });

  group('format 2', () {
    const fringe = PoolGenerator.firstFringeId;

    Map<String, Object?> rawPack(WorldPack p) =>
        _raw(p)['pack']! as Map<String, Object?>;

    test('v1 file imports and reads as v2', () async {
      final json = _pack().toJson()
        ..['formatVersion'] = 1
        ..remove('pools')
        ..remove('addedClubs')
        ..remove('addedSponsors')
        ..remove('addedYAccounts')
        ..remove('localized');
      final r = await PackCodec.decode(
        _file({'format': 1, 'pack': json, 'trophies': <String, Object?>{}}),
      );
      final d = r as PackDecoded;
      expect(d.pack.formatVersion, 2);
      expect(d.pack.squads, _pack().squads);
      expect(d.pack.pools, isEmpty);
      expect(d.pack.localized, isEmpty);
    });

    test('export writes format 2', () {
      final bytes = PackCodec.encode(
        _pack().copyWith(formatVersion: 1),
        const {},
      );
      final top =
          jsonDecode(utf8.decode(gzip.decode(bytes))) as Map<String, Object?>;
      expect(top['format'], 2);
      expect((top['pack']! as Map)['formatVersion'], 2);
    });

    test('a pack with every new part decodes whole', () async {
      final p = _pack().copyWith(
        pools: {
          1: [_p(fringe, PlayerPosition.cm)],
        },
        addedClubs: const [
          PackClub(id: kPackAddedIdBase, name: 'New FC', country: 'cze'),
        ],
        addedSponsors: [
          PackSponsor(
            id: kPackAddedIdBase + 1,
            name: 'Brand',
            deal: SponsorDeal.values.first,
            industry: SponsorBrand.values.first.name,
            description: 'Makes things',
          ),
        ],
        addedYAccounts: const [
          PackYAccount(
            id: kPackAddedIdBase + 2,
            name: 'NewVoice',
            voice: YVoice.fan,
          ),
        ],
        localized: const {
          'clubs.Old FC': {'cs': 'Starý FC'},
        },
      );
      final r = await PackCodec.decode(PackCodec.encode(p, const {}));
      expect((r as PackDecoded).pack, p);
    });

    // Hostile files: each is refused whole.
    test('5 000 pool players -> badData', () async {
      final p = _pack().copyWith(
        pools: {
          1: [
            for (var i = 0; i < 5000; i++) _p(fringe + i, PlayerPosition.cm),
          ],
        },
      );
      expect(await reason(_file(_raw(p))), PackRejection.badData);
      // 150 is the most a pool holds.
      final ok = _pack().copyWith(
        pools: {
          1: [
            for (var i = 0; i < 150; i++) _p(fringe + i, PlayerPosition.cm),
          ],
        },
      );
      expect(await reason(_file(_raw(ok))), isNull);
    });

    test('10 000 added clubs -> badData', () async {
      final p = _pack().copyWith(
        addedClubs: [
          for (var i = 0; i < 10000; i++)
            PackClub(id: kPackAddedIdBase + i, name: 'C$i', country: 'cze'),
        ],
      );
      expect(await reason(_file(_raw(p))), PackRejection.badData);
    });

    test('added id 1 -> badData', () async {
      final p = _pack().copyWith(
        addedClubs: const [PackClub(id: 1, name: 'Low FC', country: 'cze')],
      );
      expect(await reason(_file(_raw(p))), PackRejection.badData);
    });

    test('a duplicate added id -> badData', () async {
      final p = _pack().copyWith(
        addedClubs: const [
          PackClub(id: kPackAddedIdBase, name: 'A FC', country: 'cze'),
          PackClub(id: kPackAddedIdBase, name: 'B FC', country: 'cze'),
        ],
      );
      expect(await reason(_file(_raw(p))), PackRejection.badData);
    });

    test('a duplicate player id -> badData', () async {
      final p = _pack().copyWith(
        pools: {
          1: [_p(fringe, PlayerPosition.cm)],
          2: [_p(fringe, PlayerPosition.cm)],
        },
      );
      expect(await reason(_file(_raw(p))), PackRejection.badData);
    });

    test('a pool id below the fringe -> badData', () async {
      final p = _pack().copyWith(
        pools: {
          1: [_p(500, PlayerPosition.cm)],
        },
      );
      expect(await reason(_file(_raw(p))), PackRejection.badData);
    });

    test('5 traits -> badData', () async {
      final raw = rawPack(_pack());
      final squad = (raw['squads']! as Map)['1']! as List;
      (squad.first as Map<String, Object?>)['traits'] = [
        for (final t in PlayerTrait.values.take(5)) t.name,
      ];
      expect(
        await reason(_file(_raw(_pack())..['pack'] = raw)),
        PackRejection.badData,
      );
    });

    test('a well-formed unknown trait, deal, voice, industry and language '
        'are kept, to be flagged', () async {
      final raw = rawPack(
        _pack().copyWith(
          addedSponsors: [
            PackSponsor(
              id: kPackAddedIdBase,
              name: 'Brand',
              deal: SponsorDeal.values.first,
              industry: 'spaceTourism',
            ),
          ],
          addedYAccounts: const [
            PackYAccount(
              id: kPackAddedIdBase + 1,
              name: 'NewVoice',
              voice: YVoice.fan,
            ),
          ],
          localized: const {
            'clubs.Old FC': {'xx': 'Klub'},
          },
        ),
      );
      final squad = (raw['squads']! as Map)['1']! as List;
      (squad.first as Map<String, Object?>)['traits'] = [
        'leader',
        'flyingKick',
      ];
      ((raw['addedSponsors']! as List).single as Map)['deal'] = 'barter';
      ((raw['addedYAccounts']! as List).single as Map)['voice'] = 'oracle';
      final r = await PackCodec.decode(_file(_raw(_pack())..['pack'] = raw));
      final p = (r as PackDecoded).pack;
      final pl = p.squads[1]!.first;
      expect(pl.traits, [PlayerTrait.leader]);
      expect(pl.unknownTraits, ['flyingKick']);
      final s = p.addedSponsors.single;
      expect((s.deal, s.unknownDeal), (PackSponsor.fallbackDeal, 'barter'));
      final y = p.addedYAccounts.single;
      expect((y.voice, y.unknownVoice), (PackYAccount.fallbackVoice, 'oracle'));
      expect(s.industry, 'spaceTourism');
      // Written back unchanged: the file travels on.
      final again = p.toJson();
      expect(
        ((again['squads']! as Map)['1']! as List).first['traits'],
        ['leader', 'flyingKick'],
      );
      expect((again['addedSponsors']! as List).single['deal'], 'barter');
      expect((again['addedYAccounts']! as List).single['voice'], 'oracle');
      // A game voice no pack may use is unknown to a pack, too.
      final player = rawPack(
        _pack().copyWith(
          addedYAccounts: const [
            PackYAccount(
              id: kPackAddedIdBase + 1,
              name: 'NewVoice',
              voice: YVoice.fan,
            ),
          ],
        ),
      );
      ((player['addedYAccounts']! as List).single as Map)['voice'] =
          YVoice.player.name;
      final r2 = await PackCodec.decode(
        _file(_raw(_pack())..['pack'] = player),
      );
      expect(
        (r2 as PackDecoded).pack.addedYAccounts.single.unknownVoice,
        YVoice.player.name,
      );
    });

    test("an added club or Y account named like the game's own decodes; "
        'a duplicate inside the pack -> badData', () async {
      final league = ClubService.leagueClubs('cze').first;
      final game = _pack().copyWith(
        addedClubs: [
          PackClub(id: kPackAddedIdBase, name: league, country: 'cze'),
        ],
        addedYAccounts: [
          PackYAccount(
            id: kPackAddedIdBase + 1,
            name: YFeed.namedAccounts.first,
            voice: YVoice.fan,
          ),
        ],
      );
      expect(PackCodec.fieldsOk(game), isTrue);
      expect(
        await PackCodec.decode(_file(_raw(_pack())..['pack'] = rawPack(game))),
        isA<PackDecoded>(),
      );
      final inside = _pack().copyWith(
        addedClubs: const [
          PackClub(id: kPackAddedIdBase, name: 'Twin FC', country: 'cze'),
          PackClub(id: kPackAddedIdBase + 1, name: 'twin fc', country: 'cze'),
        ],
      );
      expect(PackCodec.fieldsOk(inside), isFalse);
      expect(
        await reason(_file(_raw(_pack())..['pack'] = rawPack(inside))),
        PackRejection.badData,
      );
    });

    test(
      'an oversized or odd-shaped trait, deal or voice -> badData',
      () async {
        for (final bad in ['x' * 41, 'flying kick', 'leader!', '', '42']) {
          final raw = rawPack(_pack());
          final squad = (raw['squads']! as Map)['1']! as List;
          (squad.first as Map<String, Object?>)['traits'] = [bad];
          expect(
            await reason(_file(_raw(_pack())..['pack'] = raw)),
            PackRejection.badData,
            reason: bad,
          );
        }
        final sponsor = rawPack(
          _pack().copyWith(
            addedSponsors: [
              PackSponsor(
                id: kPackAddedIdBase,
                name: 'Brand',
                deal: SponsorDeal.values.first,
                industry: 'acme',
              ),
            ],
          ),
        );
        ((sponsor['addedSponsors']! as List).single as Map)['deal'] = 'x' * 41;
        expect(
          await reason(_file(_raw(_pack())..['pack'] = sponsor)),
          PackRejection.badData,
        );
        final y = rawPack(
          _pack().copyWith(
            addedYAccounts: const [
              PackYAccount(id: kPackAddedIdBase, name: 'A', voice: YVoice.fan),
            ],
          ),
        );
        ((y['addedYAccounts']! as List).single as Map)['voice'] = 'two words';
        expect(
          await reason(_file(_raw(_pack())..['pack'] = y)),
          PackRejection.badData,
        );
      },
    );

    test(
      'a badly shaped language or an empty localized entry -> badData',
      () async {
        final lang = _pack().copyWith(
          localized: {
            'clubs.Old FC': {'not a language': 'Klub'},
          },
        );
        expect(await reason(_file(_raw(lang))), PackRejection.badData);
        final empty = _pack().copyWith(
          localized: {'clubs.Old FC': const <String, String>{}},
        );
        expect(await reason(_file(_raw(empty))), PackRejection.badData);
      },
    );

    test(
      'a pool id between the fringe and the pack-made ids -> badData',
      () async {
        for (final id in [kPackAddedIdBase + 5, 500000000]) {
          final p = _pack().copyWith(
            pools: {
              1: [_p(id, PlayerPosition.cm)],
            },
          );
          expect(await reason(_file(_raw(p))), PackRejection.badData);
        }
      },
    );

    test('an oversized industry -> badData', () async {
      final p = _pack().copyWith(
        addedSponsors: [
          PackSponsor(
            id: kPackAddedIdBase,
            name: 'Brand',
            deal: SponsorDeal.values.first,
            industry: 'x' * 5000,
          ),
        ],
      );
      expect(await reason(_file(_raw(p))), PackRejection.badData);
    });

    test('a 10 000 character localized value or path -> badData', () async {
      final value = _pack().copyWith(
        localized: {
          'clubs.Old FC': {'cs': 'x' * 10000},
        },
      );
      expect(await reason(_file(_raw(value))), PackRejection.badData);
      final path = _pack().copyWith(
        localized: {
          'clubs.${'x' * 10000}': {'cs': 'X'},
        },
      );
      expect(await reason(_file(_raw(path))), PackRejection.badData);
    });

    test('25 000 localized entries -> badData', () async {
      final p = _pack().copyWith(
        localized: {
          for (var i = 0; i < 25000; i++) 'clubs.C$i': {'cs': 'K'},
        },
      );
      expect(await reason(_file(_raw(p))), PackRejection.badData);
    });

    test('pools for 1 000 nations -> badData', () async {
      final p = _pack().copyWith(
        pools: {for (var i = 0; i < 1000; i++) 1000 + i: const <PackPlayer>[]},
      );
      expect(await reason(_file(_raw(p))), PackRejection.badData);
    });
  });

  group('service', () {
    late Directory dir;
    late ProviderContainer c;
    late WorldPackRepository repo;
    late WorldPackService service;

    setUp(() async {
      dir = Directory.systemTemp.createTempSync('fnm-pack-codec');
      addTearDown(() => dir.deleteSync(recursive: true));
      final db = createTestDatabase();
      addTearDown(db.close);
      c = greenlandContainer(db);
      addTearDown(c.dispose);
      await c.read(seedLoaderProvider).ensureSeeded();
      repo = c.read(worldPackRepositoryProvider);
      service = c.read(worldPackServiceProvider);
    });

    test(
      'export then import adds a new pack with a new uuid and a (2) name',
      () async {
        final id = await repo.insert(_pack(name: 'A/B: world'), const {});
        final file = await service.export(id, into: dir);
        expect(file.path, endsWith('A_B_ world.fnmdb'));

        final r = await service.importFile(file.path);
        final newId = r.valueOrNull!;
        expect(newId, isNot(id));
        final copy = (await repo.load(newId))!;
        expect(copy.name, 'A/B: world (2)');
        expect(copy.uuid, isNot('u-1'));
        expect(copy.squads, _pack().squads);
        final again = (await service.importFile(file.path)).valueOrNull!;
        expect((await repo.load(again))!.name, 'A/B: world (3)');
        expect((await repo.load(id))!.name, 'A/B: world');
      },
    );

    test('a rejected import writes nothing', () async {
      final bad = File('${dir.path}/bad.fnmdb')
        ..writeAsBytesSync(_file(_raw(_pack(name: 'x' * 10000))));
      final before = (await repo.list()).length;
      final r = await service.importFile(bad.path);
      expect(r.isFailure, isTrue);
      expect(r.fold((_) => '', (f) => f.code), 'badData');
      expect((await repo.list()).length, before);
      final missing = await service.importFile('${dir.path}/none.fnmdb');
      expect(missing.isFailure, isTrue);
    });

    test('a 40-character name that clashes still fits in 40', () async {
      final name = 'N' * 40;
      final id = await repo.insert(_pack(name: name), const {});
      final file = await service.export(id, into: dir);
      final copy = (await repo.load(
        (await service.importFile(file.path)).valueOrNull!,
      ))!;
      expect(copy.name, '${'N' * 36} (2)');
      expect(copy.name.length, 40);
    });

    test('a stored pack with an unknown trait, deal and voice loads, and '
        'is flagged', () async {
      final pl = _p(1, PlayerPosition.gk);
      final pack = _pack().copyWith(
        squads: {
          1: [
            PackPlayer(
              id: pl.id,
              name: pl.name,
              age: pl.age,
              position: pl.position,
              attributes: pl.attributes,
              potential: pl.potential,
              traits: const [PlayerTrait.leader],
              unknownTraits: const ['flyingKick'],
            ),
            ..._squad().skip(1),
          ],
        },
        addedSponsors: const [
          PackSponsor(
            id: kPackAddedIdBase,
            name: 'Brand',
            deal: PackSponsor.fallbackDeal,
            industry: 'acme',
            unknownDeal: 'barter',
          ),
        ],
        addedYAccounts: const [
          PackYAccount(
            id: kPackAddedIdBase + 1,
            name: 'NewVoice',
            voice: PackYAccount.fallbackVoice,
            unknownVoice: 'oracle',
          ),
        ],
      );
      final id = await repo.insert(pack, const {});
      final loaded = (await repo.load(id))!;
      expect(loaded, pack);
      expect(loaded.squads[1]!.first.unknownTraits, ['flyingKick']);
      final world = await c.read(nationRepositoryProvider).newCareerWorld();
      final facts = await readPackFacts(
        c.read(playerRepositoryProvider),
        c.read(seedSourceProvider),
      );
      final a = assessPack(loaded, world, facts: facts);
      expect(a.status, PackStatus.needsAttention);
      expect(
        [
          for (final i in a.issues)
            if (i is UnknownId) i.path,
        ],
        containsAll([
          'squads.1.1.traits',
          'addedSponsors.$kPackAddedIdBase.deal',
          'addedYAccounts.${kPackAddedIdBase + 1}.voice',
        ]),
      );
    });

    test("an added club under a game club's name needs attention, comes "
        'first, and Remove drops it', () async {
      final league = ClubService.leagueClubs('cze').first;
      final pack = _pack(name: 'Clash').copyWith(
        nations: const {999: (name: '', code: '')},
        addedClubs: [
          PackClub(id: kPackAddedIdBase, name: league, country: 'cze'),
        ],
      );
      final world = await c.read(nationRepositoryProvider).newCareerWorld();
      final facts = await readPackFacts(
        c.read(playerRepositoryProvider),
        c.read(seedSourceProvider),
      );
      final a = assessPack(pack, world, facts: facts);
      expect(a.status, PackStatus.needsAttention);
      final clash = a.issues.whereType<NameClash>().single;
      expect(clash.path, 'addedClubs.$kPackAddedIdBase');
      expect(a.issues.takeWhile((i) => i is CompatIssue), contains(clash));
      final fixed = PackEditor.dropUnknown(pack, clash.path);
      expect(fixed.addedClubs, isEmpty);
      expect(
        assessPack(fixed, world, facts: facts).issues.whereType<NameClash>(),
        isEmpty,
      );
    });

    test('file names are safe and never empty', () {
      expect(PackCodec.fileStem('Světový'), 'Světový');
      expect(PackCodec.fileStem(''), 'world');
      expect(PackCodec.fileStem('../../etc'), '______etc');
      expect(PackCodec.fileStem('x' * 100).length, 60);
    });
  });
}

class _Collect extends ByteConversionSinkBase {
  _Collect(this._out);
  final BytesBuilder _out;
  @override
  void add(List<int> chunk) => _out.add(chunk);
  @override
  void close() {}
}
