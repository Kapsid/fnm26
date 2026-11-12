import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/world_pack/pack_codec.dart';
import 'package:fnm/domain/services/world_pack/pack_merge.dart';
import 'package:fnm/domain/services/world_pack/pack_rules.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';

PackPlayer _p(int id, {String? name, int age = 25, int tech = 60}) =>
    PackPlayer(
      id: id,
      name: name ?? 'Player $id',
      age: age,
      position: id % 4 == 0
          ? PlayerPosition.gk
          : id % 4 == 1
          ? PlayerPosition.cb
          : id % 4 == 2
          ? PlayerPosition.cm
          : PlayerPosition.st,
      attributes: PlayerAttributes(physical: 60, technical: tech, stamina: 60),
      potential: 80,
    );

PackPlayer _with(PackPlayer p, {String? name, int? age}) => PackPlayer(
  id: p.id,
  name: name ?? p.name,
  age: age ?? p.age,
  position: p.position,
  attributes: p.attributes,
  potential: p.potential,
);

/// The default world's squads: nation 1 has players 1..23, nation 2 has
/// 101..123.
final Map<int, List<PackPlayer>> _baseSquads = {
  1: [for (var i = 1; i <= 23; i++) _p(i)],
  2: [for (var i = 101; i <= 123; i++) _p(i)],
};

WorldPack _pack(String name) => WorldPack(
  uuid: 'uuid-$name',
  name: name,
  author: '',
  formatVersion: kPackFormatVersion,
  madeWithVersion: '1.1.1',
  squads: {
    for (final e in _baseSquads.entries) e.key: [...e.value],
  },
);

WorldPack _edit(
  WorldPack p,
  int nation,
  List<PackPlayer> Function(List<PackPlayer>) f,
) => p.copyWith(
  squads: {
    ...p.squads,
    nation: f([...p.squads[nation]!]),
  },
);

/// Plans [theirs] into [mine], reading the base the way the service does.
MergePlan _plan(
  WorldPack mine,
  WorldPack theirs, {
  Map<String, Uint8List> mineTrophies = const {},
  Map<String, Uint8List> theirTrophies = const {},
  Map<int, List<PackPlayer>> basePools = const {},
  Map<int, List<PackPlayer>> mineGenerated = const {},
}) {
  final needs = PackMerge.prepare(mine, theirs);
  return PackMerge.plan(
    mine,
    needs,
    MergeBase(
      squads: {
        for (final n in needs.squadNations) n: ?_baseSquads[n],
      },
      pools: {
        for (final n in needs.poolNations) n: ?basePools[n],
      },
      mineGeneratedPools: {
        for (final n in needs.mineGeneratedPools) n: ?mineGenerated[n],
      },
    ),
    mineTrophies: mineTrophies,
    theirTrophies: theirTrophies,
  );
}

MergeItem _item(MergePlan plan, String key) =>
    plan.items.firstWhere((i) => i.key == key);

void main() {
  group('players', () {
    test('an untouched nation is not looked at, and nothing is listed', () {
      final plan = _plan(_pack('Mine'), _pack('Theirs'));
      expect(plan.items, isEmpty);
      expect(plan.squadNations, isEmpty);
    });

    test('new from them, the same, a conflict, and only mine', () {
      var mine = _pack('Mine');
      var theirs = _pack('Theirs');
      // 1: only they renamed him. 2: both renamed him alike. 3: both
      // differently. 4: only I renamed him.
      theirs = _edit(theirs, 1, (l) {
        l[0] = _with(l[0], name: 'Theirs One');
        l[1] = _with(l[1], name: 'Both Two');
        l[2] = _with(l[2], name: 'Their Three');
        return l;
      });
      mine = _edit(mine, 1, (l) {
        l[1] = _with(l[1], name: 'Both Two');
        l[2] = _with(l[2], name: 'My Three');
        l[3] = _with(l[3], name: 'My Four');
        return l;
      });
      final plan = _plan(mine, theirs);
      expect(plan.items.map((i) => (i.key, i.kind)), [
        ('player:1', MergeKind.theirs),
        ('player:3', MergeKind.conflict),
      ]);
      expect(plan.same, 1);
      final conflict = _item(plan, 'player:3');
      expect((conflict.mine! as PackPlayer).name, 'My Three');
      expect((conflict.theirs! as PackPlayer).name, 'Their Three');
      expect(conflict.nationId, 1);
      expect(plan.preselected, {'player:1'});
      expect(plan.conflicts, 1);

      // Taking the defaults keeps my three and four, and takes their one.
      final merged = PackMerge.apply(plan, plan.preselected).pack;
      final names = [for (final p in merged.squads[1]!.take(4)) p.name];
      expect(names, ['Theirs One', 'Both Two', 'My Three', 'My Four']);
    });

    test('a player I took out and they changed is a conflict', () {
      final mine = _edit(_pack('Mine'), 1, (l) => l..removeAt(4));
      final theirs = _edit(_pack('Theirs'), 1, (l) {
        l[4] = _with(l[4], age: 30);
        return l;
      });
      final plan = _plan(mine, theirs);
      final item = _item(plan, 'player:5');
      expect(item.kind, MergeKind.conflict);
      expect(item.mine, isNull);
      // Taken, he comes back where they have him.
      final merged = PackMerge.apply(plan, {'player:5'}).pack;
      expect(merged.squads[1]!.firstWhere((p) => p.id == 5).age, 30);
    });

    test('a move to another nation and a removal are places', () {
      final theirs = _pack('Theirs').copyWith(
        squads: {
          1: [
            for (final p in _baseSquads[1]!)
              if (p.id != 7 && p.id != 8) p,
          ],
          2: [..._baseSquads[2]!, _p(7)],
        },
      );
      final plan = _plan(_pack('Mine'), theirs);
      expect(plan.items.map((i) => (i.key, i.kind)).toSet(), {
        ('place:7', MergeKind.theirs),
        ('place:8', MergeKind.theirs),
      });
      expect(_item(plan, 'place:7').theirs, (nationId: 2, pool: false));
      expect(_item(plan, 'place:7').mine, (nationId: 1, pool: false));
      expect(_item(plan, 'place:8').theirs, isNull);

      final merged = PackMerge.apply(plan, plan.preselected).pack;
      expect(merged.squads[1]!.map((p) => p.id), isNot(contains(7)));
      expect(merged.squads[1]!.map((p) => p.id), isNot(contains(8)));
      expect(merged.squads[2]!.map((p) => p.id), contains(7));
      // Every player is in one place.
      final ids = [for (final l in merged.squads.values) ...l.map((p) => p.id)];
      expect(ids.toSet().length, ids.length);
    });

    test('a nation I left to the game reads as its default squad', () {
      final mine = _pack('Mine').copyWith(squads: {2: _baseSquads[2]!});
      final theirs = _edit(_pack('Theirs'), 1, (l) {
        l[0] = _with(l[0], name: 'Renamed');
        return l;
      });
      final plan = _plan(mine, theirs);
      expect(plan.items.single.key, 'player:1');
      expect(plan.items.single.kind, MergeKind.theirs);
      final merged = PackMerge.apply(plan, plan.preselected).pack;
      // The squad is now fixed: the default with their change.
      expect(merged.squads[1]!.length, 23);
      expect(merged.squads[1]!.first.name, 'Renamed');
    });

    test('their pool change fixes my generated pool with my names', () {
      final basePool = [_p(501), _p(502)];
      final mineGenerated = [
        _with(_p(501), name: 'Mine Gen 1'),
        _with(_p(502), name: 'Mine Gen 2'),
      ];
      final theirs = _pack('Theirs').copyWith(
        pools: {
          1: [_p(501), _with(_p(502), age: 19)],
        },
      );
      final plan = _plan(
        _pack('Mine'),
        theirs,
        basePools: {1: basePool},
        mineGenerated: {1: mineGenerated},
      );
      expect(plan.items.single.key, 'player:502');
      final merged = PackMerge.apply(plan, plan.preselected).pack;
      expect(merged.pools[1]!.map((p) => (p.id, p.name, p.age)), [
        (501, 'Mine Gen 1', 25),
        (502, 'Player 502', 19),
      ]);
    });
  });

  group('id remapping', () {
    test('their new player under one of my ids gets a fresh one', () {
      final mine = _edit(
        _pack('Mine'),
        1,
        (l) => l..add(_p(kPackPlayerIdBase + 1, name: 'My Newgen')),
      );
      final theirs = _edit(
        _pack('Theirs'),
        1,
        (l) => l
          ..add(_p(kPackPlayerIdBase + 1, name: 'Tom Newgen'))
          ..add(_p(kPackPlayerIdBase + 2, name: 'Tom Second')),
      );
      final plan = _plan(mine, theirs);
      final news = [
        for (final i in plan.items)
          if (i.field == MergeField.newPlayer) i.player!,
      ];
      expect(news.map((p) => p.name), ['Tom Newgen', 'Tom Second']);
      final ids = news.map((p) => p.id).toSet();
      expect(ids, isNot(contains(kPackPlayerIdBase + 1)));
      expect(ids.length, 2);

      final merged = PackMerge.apply(plan, plan.preselected).pack;
      final all = [for (final l in merged.squads.values) ...l];
      expect(all.map((p) => p.id).toSet().length, all.length);
      expect(
        all.firstWhere((p) => p.id == kPackPlayerIdBase + 1).name,
        'My Newgen',
      );
      expect(all.where((p) => p.name.startsWith('Tom')), hasLength(2));
    });

    test('a new player both have under one id and name is the same one', () {
      final made = _p(kPackPlayerIdBase + 1, name: 'Shared Newgen');
      final mine = _edit(_pack('Mine'), 1, (l) => l..add(made));
      final theirs = _edit(
        _pack('Theirs'),
        1,
        (l) => l..add(_with(made, age: 22)),
      );
      final plan = _plan(mine, theirs);
      expect(plan.items.single.key, 'player:${kPackPlayerIdBase + 1}');
      expect(plan.items.single.kind, MergeKind.conflict);
    });

    test('their added club under my id moves, its names with it', () {
      const myClub = PackClub(id: 700000000, name: 'Mine FC', country: 'cze');
      const theirClub = PackClub(id: 700000000, name: 'Tom FC', country: 'cze');
      const sharedA = PackClub(id: 700000001, name: 'Shared', country: 'svk');
      const sharedB = PackClub(id: 700000005, name: 'shared ', country: 'svk');
      final mine = _pack('Mine').copyWith(addedClubs: [myClub, sharedA]);
      final theirs = _pack('Theirs').copyWith(
        addedClubs: [theirClub, sharedB],
        localized: {
          'addedClubs.700000000': {'cs': 'Tomův klub'},
        },
      );
      final plan = _plan(mine, theirs);
      final club = plan.items.firstWhere(
        (i) => i.field == MergeField.addedClub && i.label == 'Tom FC',
      );
      final moved = club.theirs! as PackClub;
      expect(moved.id, isNot(anyOf(700000000, 700000001, 700000005)));
      expect(club.localized, {
        'addedClubs.${moved.id}': {'cs': 'Tomův klub'},
      });
      // The same club under another id and spelling takes my id: a pair.
      final pair = plan.items.where((i) => i.key == 'addedClubs:700000001');
      expect(pair.single.kind, MergeKind.conflict);

      final merged = PackMerge.apply(plan, plan.preselected).pack;
      expect(merged.addedClubs.map((c) => c.id).toSet().length, 3);
      expect(merged.localized['addedClubs.${moved.id}'], {'cs': 'Tomův klub'});
      expect(merged.localized.containsKey('addedClubs.700000000'), isFalse);
    });
  });

  group('overrides and the rest', () {
    test('club renames: new, the same, a conflict', () {
      final mine = _pack('Mine').copyWith(
        clubs: {'Both FC': 'Same', 'Clash FC': 'Mine', 'Mine FC': 'Only mine'},
      );
      final theirs = _pack('Theirs').copyWith(
        clubs: {'Both FC': 'Same', 'Clash FC': 'Theirs', 'New FC': 'From Tom'},
      );
      final plan = _plan(mine, theirs);
      expect(plan.items.map((i) => (i.key, i.kind)), [
        ('club:Clash FC', MergeKind.conflict),
        ('club:New FC', MergeKind.theirs),
      ]);
      expect(plan.same, 1);
      final merged = PackMerge.apply(
        plan,
        plan.items.map((i) => i.key).toSet(),
      );
      expect(merged.pack.clubs, {
        'Both FC': 'Same',
        'Clash FC': 'Theirs',
        'Mine FC': 'Only mine',
        'New FC': 'From Tom',
      });
    });

    test('stadiums, managers, name lists and nations, by nation', () {
      final theirs = _pack('Theirs').copyWith(
        stadiums: {'2:Brno': 'Tom Arena'},
        managers: {1: (name: 'Tom Boss', nationality: 'CZE')},
        nameLists: {
          2: const PackNameLists(first: ['Ana'], sur: ['Novak']),
        },
        nations: {1: (name: 'Tomland', code: 'TOM')},
      );
      final plan = _plan(_pack('Mine'), theirs);
      expect(plan.items.map((i) => (i.section, i.nationId, i.label)), [
        (MergeSection.stadiums, 2, 'Brno'),
        (MergeSection.nameLists, 2, '2'),
        (MergeSection.managers, 1, '1'),
        (MergeSection.nations, 1, '1'),
      ]);
      final merged = PackMerge.apply(plan, plan.preselected).pack;
      expect(merged.stadiums, {'2:Brno': 'Tom Arena'});
      expect(merged.managers[1]!.name, 'Tom Boss');
      expect(merged.nameLists[2]!.sur, ['Novak']);
      expect(merged.nations[1], (name: 'Tomland', code: 'TOM'));
    });

    test('trophy pictures by their bytes', () {
      final a = Uint8List.fromList([1, 2, 3]);
      final b = Uint8List.fromList([1, 2, 4]);
      final plan = _plan(
        _pack('Mine').copyWith(trophies: {'europe', 'asia'}),
        _pack('Theirs').copyWith(trophies: {'europe', 'asia', 'africa'}),
        mineTrophies: {'europe': a, 'asia': a},
        theirTrophies: {'europe': a, 'asia': b, 'africa': b},
      );
      expect(plan.items.map((i) => (i.key, i.kind)), [
        ('trophy:asia', MergeKind.conflict),
        ('trophy:africa', MergeKind.theirs),
      ]);
      final merged = PackMerge.apply(plan, plan.preselected);
      expect(merged.trophies.keys, ['africa']);
      expect(merged.pack.trophies, {'europe', 'asia', 'africa'});
    });

    test('translations, one per path and language', () {
      final mine = _pack('Mine').copyWith(
        localized: {
          'clubs.Old FC': {'cs': 'Starý', 'de': 'Alt'},
        },
      );
      final theirs = _pack('Theirs').copyWith(
        localized: {
          'clubs.Old FC': {'cs': 'Jiný', 'de': 'Alt', 'fr': 'Vieux'},
        },
      );
      final plan = _plan(mine, theirs);
      expect(plan.items.map((i) => (i.language, i.kind, i.section)), [
        ('cs', MergeKind.conflict, MergeSection.clubs),
        ('fr', MergeKind.theirs, MergeSection.clubs),
      ]);
      final merged = PackMerge.apply(plan, plan.preselected).pack;
      expect(merged.localized['clubs.Old FC'], {
        'cs': 'Starý',
        'de': 'Alt',
        'fr': 'Vieux',
      });
    });
  });

  group('the merged pack', () {
    test('round-trips through the file format', () async {
      final theirs = _edit(
        _pack('Theirs'),
        1,
        (l) => l..add(_p(kPackPlayerIdBase + 3, name: 'Tom Newgen')),
      ).copyWith(clubs: {'Old FC': 'New FC'});
      final plan = _plan(_pack('Mine'), theirs);
      final merged = PackMerge.apply(plan, plan.preselected).pack;
      final decoded = await PackCodec.decode(PackCodec.encode(merged, {}));
      expect(decoded, isA<PackDecoded>());
      expect((decoded as PackDecoded).pack, merged);
    });

    test('a merge that breaks a rule is kept and flagged', () {
      // They added 18 players: 41 in the squad, over the cap.
      final theirs = _edit(
        _pack('Theirs'),
        1,
        (l) => l
          ..addAll([
            for (var i = 1; i <= 18; i++)
              _p(kPackPlayerIdBase + i, name: 'Extra $i'),
          ]),
      );
      final plan = _plan(_pack('Mine'), theirs);
      final merged = PackMerge.apply(plan, plan.preselected).pack;
      expect(merged.squads[1], hasLength(41));
      expect(
        PackRules.squadIssues(1, merged.squads[1]!),
        contains(isA<SquadTooSmall>()),
      );
    });

    test('nothing ticked is my pack unchanged', () {
      final theirs = _pack('Theirs').copyWith(clubs: {'Old FC': 'New FC'});
      final plan = _plan(_pack('Mine'), theirs);
      expect(PackMerge.apply(plan, {}).pack, _pack('Mine'));
    });
  });

  test('countDifferences counts items two ways', () {
    final a = _pack('A').copyWith(clubs: {'X': 'Y'});
    final b = _edit(_pack('A'), 1, (l) {
      l[0] = _with(l[0], name: 'Changed');
      return l..removeLast();
    }).copyWith(competitions: {'Cup': 'Tom Cup'});
    // A player changed, a player gone, a club rename gone, a competition
    // added.
    expect(PackMerge.countDifferences(a, b), 4);
    expect(PackMerge.countDifferences(a, a), 0);
  });
}
