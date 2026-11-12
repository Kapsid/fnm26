import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/repositories/pack_history_repository.dart';
import 'package:fnm/data/repositories/world_pack_repository.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';

import '../../helpers/test_database.dart';

WorldPack _pack(String name, {Map<String, String> clubs = const {}}) =>
    WorldPack(
      uuid: 'uuid-1',
      name: name,
      author: '',
      formatVersion: kPackFormatVersion,
      madeWithVersion: '1.1.1',
      clubs: clubs,
    );

Uint8List _png(int seed) => Uint8List.fromList([137, 80, 78, 71, seed, seed]);

void main() {
  late AppDatabase db;
  late DateTime now;
  late PackHistoryRepository history;
  late WorldPackRepository packs;

  setUp(() {
    db = createTestDatabase();
    now = DateTime.utc(2026, 11, 12, 10);
    history = PackHistoryRepository(db, clock: () => now);
    packs = WorldPackRepository(db);
  });
  tearDown(() => db.close());

  test('a version reads back as it was saved, newest listed first', () async {
    final id = await packs.insert(_pack('A'), {});
    final first = await history.record(
      id,
      _pack('A', clubs: {'Old FC': 'New FC'}),
      {'europe': _png(1)},
      reason: PackVersionReason.manual,
      name: 'Before the big edit',
    );
    now = now.add(const Duration(minutes: 5));
    await history.record(
      id,
      _pack('B'),
      {},
      reason: PackVersionReason.beforeMerge,
      name: "Tom's world",
    );

    final list = await history.list(id);
    expect(list.map((v) => (v.reason, v.name)), [
      (PackVersionReason.beforeMerge, "Tom's world"),
      (PackVersionReason.manual, 'Before the big edit'),
    ]);
    final back = await history.load(first);
    expect(back!.pack, _pack('A', clubs: {'Old FC': 'New FC'}));
    expect(back.trophies.keys, ['europe']);
    expect(back.trophies['europe'], _png(1));
  });

  test('keeps the newest 30 automatic versions and every manual one', () async {
    final id = await packs.insert(_pack('A'), {});
    await history.record(id, _pack('M'), {}, reason: PackVersionReason.manual);
    for (var i = 0; i < 35; i++) {
      now = now.add(const Duration(minutes: 1));
      await history.record(
        id,
        _pack('auto $i'),
        {},
        reason: i.isEven
            ? PackVersionReason.session
            : PackVersionReason.beforeRestore,
      );
    }
    final list = await history.list(id);
    final autos = list.where((v) => v.reason.automatic).toList();
    expect(autos, hasLength(PackHistoryRepository.autoKept));
    expect(
      list.where((v) => v.reason == PackVersionReason.manual),
      hasLength(1),
    );
    // The oldest five automatic ones went.
    final names = [
      for (final v in autos) (await history.load(v.id))!.pack.name,
    ];
    expect(names.first, 'auto 34');
    expect(names.last, 'auto 5');
  });

  test('a picture is stored once however many versions hold it', () async {
    final id = await packs.insert(_pack('A'), {});
    for (var i = 0; i < 4; i++) {
      await history.record(
        id,
        _pack('v$i'),
        {'europe': _png(1), 'asia': _png(2)},
        reason: PackVersionReason.session,
      );
    }
    expect(await db.select(db.packVersionImages).get(), hasLength(2));

    // Deleting all but one keeps its pictures; deleting that one drops them.
    final list = await history.list(id);
    for (final v in list.skip(1)) {
      await history.delete(v.id);
    }
    expect(await db.select(db.packVersionImages).get(), hasLength(2));
    await history.delete(list.first.id);
    expect(await db.select(db.packVersionImages).get(), isEmpty);
  });

  test('rename changes only the name', () async {
    final id = await packs.insert(_pack('A'), {});
    final v = await history.record(
      id,
      _pack('A'),
      {},
      reason: PackVersionReason.session,
    );
    await history.rename(v, 'Kept for later');
    expect((await history.list(id)).single.name, 'Kept for later');
    expect((await history.list(id)).single.reason, PackVersionReason.session);
  });

  test('a session version is saved once per 30 minutes, and only when the '
      'pack changed', () async {
    final id = await packs.insert(_pack('A'), {});
    Map<String, Uint8List> none() => {};
    expect(await history.recordSessionIfDue(id, _pack('A'), none), isTrue);
    now = now.add(const Duration(minutes: 10));
    expect(await history.recordSessionIfDue(id, _pack('B'), none), isFalse);
    now = now.add(const Duration(minutes: 30));
    // Unchanged since the last version: nothing to keep.
    expect(await history.recordSessionIfDue(id, _pack('A'), none), isFalse);
    expect(await history.recordSessionIfDue(id, _pack('B'), none), isTrue);
    now = now.add(const Duration(hours: 1));
    // A new picture is a change too.
    expect(
      await history.recordSessionIfDue(id, _pack('B'), () => {'x': _png(3)}),
      isTrue,
    );
    expect(await history.list(id), hasLength(3));
  });

  test('deleting a database deletes its versions and pictures', () async {
    final keep = await packs.insert(_pack('Keep'), {});
    final gone = await packs.insert(
      _pack('Gone').copyWith(uuid: 'uuid-2'),
      {},
    );
    for (final id in [keep, gone]) {
      await history.record(
        id,
        _pack('x'),
        {'europe': _png(id)},
        reason: PackVersionReason.manual,
      );
    }
    await packs.delete(gone);
    expect(await history.list(gone), isEmpty);
    expect(await history.list(keep), hasLength(1));
    final images = await db.select(db.packVersionImages).get();
    expect(images.map((i) => i.packId), [keep]);
  });

  test('the image hash is stable and tells pictures apart', () {
    expect(
      PackHistoryRepository.imageHash([1, 2, 3]),
      PackHistoryRepository.imageHash([1, 2, 3]),
    );
    expect(
      PackHistoryRepository.imageHash([1, 2, 3]),
      isNot(PackHistoryRepository.imageHash([1, 2, 4])),
    );
    expect(PackHistoryRepository.imageHash([]), '811c9dc5-0');
  });
}
