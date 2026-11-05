import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/world_pack/pack_rules.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';

PackPlayer _p(
  int id,
  PlayerPosition pos, {
  String? name,
  int age = 25,
  int potential = 90,
  int q = 60,
}) => PackPlayer(
  id: id,
  name: name ?? 'Player $id',
  age: age,
  position: pos,
  attributes: PlayerAttributes(physical: q, technical: q, stamina: q),
  potential: potential,
);

List<PackPlayer> _squad({int gk = 3, int def = 7, int mid = 10, int fwd = 3}) {
  var id = 1;
  return [
    for (var i = 0; i < gk; i++) _p(id++, PlayerPosition.gk),
    for (var i = 0; i < def; i++) _p(id++, PlayerPosition.cb),
    for (var i = 0; i < mid; i++) _p(id++, PlayerPosition.cm),
    for (var i = 0; i < fwd; i++) _p(id++, PlayerPosition.st),
  ];
}

WorldPack _pack({
  Map<int, List<PackPlayer>>? squads,
  Map<int, ({String name, String code})> nations = const {},
  Map<String, String> competitions = const {},
  Map<int, PackNameLists> nameLists = const {},
}) => WorldPack(
  uuid: 'u',
  name: 'n',
  author: 'a',
  formatVersion: kPackFormatVersion,
  madeWithVersion: '1.1.0',
  squads: squads ?? {1: _squad()},
  nations: nations,
  competitions: competitions,
  nameLists: nameLists,
);

void main() {
  test('a complete pack has no issues', () {
    expect(PackRules.isComplete(_pack()), isTrue);
  });

  test('a 22-man squad is too small', () {
    final i = PackRules.issues(_pack(squads: {1: _squad(mid: 9)}));
    expect(i.whereType<SquadTooSmall>().single.have, 22);
  });

  test('two goalkeepers is not enough', () {
    final i = PackRules.issues(_pack(squads: {1: _squad(gk: 2, mid: 11)}));
    final n = i.whereType<NeedsPosition>().single;
    expect(n.category, PositionCategory.goalkeeper);
    expect(n.have, 2);
    expect(n.need, 3);
  });

  test('two nations renamed to the same code', () {
    final i = PackRules.issues(
      _pack(
        squads: {1: _squad(), 2: _squad()},
        nations: {
          1: (name: 'A', code: 'AAA'),
          2: (name: 'B', code: 'AAA'),
        },
      ),
    );
    expect(i.whereType<DuplicateCode>().single.nationIds, [1, 2]);
  });

  test("renaming a code to an untouched nation's code is a DuplicateCode", () {
    final p = _pack(nations: {1: (name: 'A', code: 'BBB')});
    expect(PackRules.issues(p).whereType<DuplicateCode>(), isEmpty);
    final i = PackRules.issues(p, baseCodes: {1: 'AAA', 2: 'BBB', 3: 'CCC'});
    expect(i.whereType<DuplicateCode>().single.nationIds, [1, 2]);
    expect(
      PackRules.issues(_pack(), baseCodes: {2: 'XXX', 3: 'XXX'}),
      isEmpty,
    );
  });

  test('a name of spaces is empty', () {
    expect(PackRules.checkName('   '), FieldReason.empty);
  });

  test('a 41-character name is too long', () {
    expect(PackRules.checkName('a' * 41), FieldReason.tooLong);
    expect(PackRules.checkName('a' * 40), isNull);
  });

  test('names are counted in user-perceived characters', () {
    // A family emoji is one character but 8 UTF-16 units (5 runes).
    const family = '\u{1F468}\u200D\u{1F469}\u200D\u{1F467}';
    expect(family.length, 8);
    expect(PackRules.nameLength(family), 1);
    expect(PackRules.checkName(family * 40), isNull);
    expect(PackRules.checkName(family * 41), FieldReason.tooLong);
    // Cut on character boundaries, never through an emoji.
    expect(PackRules.fitName(family * 45), family * 40);
    expect(PackRules.fitName('${'a' * 39} b'), 'a' * 39);
    expect(PackRules.fitName('short'), 'short');
  });

  test('a tab inside a name is badCharacters', () {
    expect(PackRules.checkName('a\tb'), FieldReason.badCharacters);
    expect(PackRules.checkName('a\uD800b'), FieldReason.badCharacters);
  });

  test('codes are three capital letters', () {
    expect(PackRules.checkCode('CZE'), isNull);
    expect(PackRules.checkCode('cze'), isNotNull);
    expect(PackRules.checkCode('CZ'), isNotNull);
  });

  test("a competition renamed to '' is empty", () {
    final i = PackRules.issues(_pack(competitions: {'Euro': ''}));
    final b = i.whereType<BadField>().single;
    expect(b.reason, FieldReason.empty);
    expect(b.path, 'competitions.Euro');
  });

  test('potential below overall is outOfRange', () {
    final s = _squad()..[0] = _p(1, PlayerPosition.gk, potential: 10);
    final i = PackRules.issues(_pack(squads: {1: s}));
    final b = i.whereType<BadField>().single;
    expect(b.reason, FieldReason.outOfRange);
    expect(b.path, 'squads.1.1.potential');
  });

  test('age outside 15..45 is outOfRange', () {
    final s = _squad()..[0] = _p(1, PlayerPosition.gk, age: 14);
    final b = PackRules.issues(_pack(squads: {1: s})).whereType<BadField>();
    expect(b.single.path, 'squads.1.1.age');
  });

  test('a duplicate player name inside a nation is not an issue', () {
    final s = _squad()
      ..[0] = _p(1, PlayerPosition.gk, name: 'Same')
      ..[1] = _p(2, PlayerPosition.gk, name: 'Same');
    expect(PackRules.isComplete(_pack(squads: {1: s})), isTrue);
  });

  test('name list with 19 surnames is an issue', () {
    final ok = [for (var i = 0; i < 20; i++) 'N$i'];
    final i = PackRules.issues(
      _pack(
        nameLists: {
          1: PackNameLists(first: ok, sur: ok.take(19).toList()),
        },
      ),
    );
    final b = i.whereType<BadField>().single;
    expect(b.path, 'nameLists.1.sur');
    expect(b.reason, FieldReason.outOfRange);
  });
}
