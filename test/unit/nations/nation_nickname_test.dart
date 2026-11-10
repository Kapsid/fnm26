import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/nation/dormant_nations.dart';
import 'package:fnm/domain/services/nation/nation_identity.dart';
import 'package:fnm/domain/services/world_pack/active_world.dart';
import 'package:fnm/domain/services/world_pack/pack_paths.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';

WorldPack _pack(Map<int, ({String name, String code})> nations) => WorldPack(
  uuid: 'nick',
  name: 'Nick',
  author: '',
  formatVersion: kPackFormatVersion,
  madeWithVersion: '1.1.0',
  nations: nations,
);

void main() {
  tearDown(() => ActiveWorld.current = ActiveWorld.none);

  test('every nickname key is a real nation code', () {
    final real = {
      for (final n
          in jsonDecode(File('assets/data/nations.json').readAsStringSync())
              as List)
        (n as Map)['code'] as String,
      for (final n in DormantNations.all) n.code,
    };
    final stray = NationIdentity.curatedCodes.where((c) => !real.contains(c));
    expect(stray, isEmpty);
    for (final c in NationIdentity.curatedCodes) {
      expect(c, c.toUpperCase());
    }
  });

  test('Canada, Mexico and a nickname-less nation', () {
    expect(NationIdentity.nicknameOf('CAN'), 'Les Rouges');
    expect(NationIdentity.nicknameOf('mex'), 'El Tri');
    expect(NationIdentity.nicknameOf('AND'), isNull);
    expect(NationIdentity.nicknameCount, greaterThan(100));
  });

  test('new entries keep the balanced default style', () {
    expect(NationIdentity.of('CAN').style, NationStyle.balanced);
    expect(NationIdentity.of('CAN').pedigree, 3);
    expect(NationIdentity.of('ENG').pedigree, 1);
  });

  const canada = Nation(
    id: 20,
    name: 'Canada',
    code: 'CAN',
    confederation: Confederation.northAmerica,
    ranking: 40,
  );

  test('a default-named nation shows its nickname', () {
    expect(NationIdentity.nicknameFor(canada, 'en'), 'Les Rouges');
    // Czech shows the translated name, still the default.
    final cs = canada.copyWith(name: 'Kanada', englishName: 'Canada');
    expect(NationIdentity.nicknameFor(cs, 'cs'), 'Les Rouges');
  });

  test('a nation the pack renamed shows no nickname', () {
    ActiveWorld.current = ActiveWorld(
      _pack({20: (name: 'Maple Land', code: 'MPL')}),
    );
    final renamed = canada.copyWith(name: 'Maple Land', englishName: 'Canada');
    expect(NationIdentity.nicknameFor(renamed, 'en'), isNull);
  });

  test('a name that differs from the default shows no nickname', () {
    final renamed = canada.copyWith(name: 'Maple Land', englishName: 'Canada');
    expect(NationIdentity.nicknameFor(renamed, 'en'), isNull);
  });

  test('federation-branded nicknames are gone, descriptive ones remain', () {
    const retired = {
      'Three Lions',
      'Red Devils',
      'Super Eagles',
      'Black Stars',
      'Indomitable Lions',
      'Atlas Lions',
      'Bafana Bafana',
      'Samurai Blue',
      'Taegeuk Warriors',
      'Socceroos',
      'All Whites',
      'Chipolopolo',
      'Reggae Boyz',
      'Danish Dynamite',
    };
    final shown = {
      for (final c in NationIdentity.curatedCodes) NationIdentity.nicknameOf(c),
    };
    expect(shown.intersection(retired), isEmpty);
    expect(NationIdentity.nicknameOf('AUS'), 'Green and Gold');
    expect(NationIdentity.nicknameOf('FRA'), 'Les Bleus');
    expect(NationIdentity.nicknameOf('ITA'), 'Azzurri');
  });
}
