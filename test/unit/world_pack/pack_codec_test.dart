import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/repositories/world_pack_repository.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/world_pack/pack_codec.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
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
