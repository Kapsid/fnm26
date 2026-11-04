import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';

const _player = PackPlayer(
  id: kPackPlayerIdBase + 1,
  name: 'A. Test',
  age: 24,
  position: PlayerPosition.gk,
  attributes: PlayerAttributes(physical: 60, technical: 70, stamina: 65),
  potential: 80,
  club: 'FC X',
  clubCountry: 'Czechia',
);

WorldPack _pack() => const WorldPack(
  uuid: 'u-1',
  name: 'My World',
  author: 'Me',
  formatVersion: kPackFormatVersion,
  madeWithVersion: '1.1.0',
  squads: {
    7: [_player],
  },
  nations: {7: (name: 'Testland', code: 'TST')},
  clubs: {'Old FC': 'New FC'},
  stadiums: {'7:Prague': 'Arena'},
  competitions: {'World Championship': 'Globe Cup'},
  yAccounts: {'Old': 'New'},
  reporters: {3: PackReporter(name: 'Bob', outlet: 'Daily')},
  nameLists: {
    7: PackNameLists(first: ['Al'], sur: ['Bo']),
  },
  sponsors: {'Brand': 'Brand2'},
  trophies: {'worldChampionship'},
);

void main() {
  test('round trip keeps every field', () {
    final p = _pack();
    expect(WorldPack.fromJson(p.toJson()), p);
  });

  test('wrong types throw FormatException', () {
    final good = _pack().toJson();
    for (final bad in <Map<String, Object?>>[
      {...good, 'squads': 'x'},
      {
        ...good,
        'nations': {'1': 5},
      },
      {
        ...good,
        'squads': {'abc': <Object?>[]},
      },
    ]) {
      expect(() => WorldPack.fromJson(bad), throwsFormatException);
    }
    final json = _pack().toJson();
    final squads = json['squads']! as Map<String, Object?>;
    final players = (squads['7']! as List).cast<Map<String, Object?>>();
    squads['7'] = [
      {...players.first, 'age': '20'},
    ];
    expect(() => WorldPack.fromJson(json), throwsFormatException);
  });

  test('unknown top-level keys throw', () {
    final json = {..._pack().toJson(), 'script': 'x'};
    expect(() => WorldPack.fromJson(json), throwsFormatException);
  });

  test('migrate is identity at v1 and rejects newer or missing versions', () {
    final json = _pack().toJson();
    expect(WorldPack.migrate(json), json);
    expect(
      () =>
          WorldPack.migrate({...json, 'formatVersion': kPackFormatVersion + 1}),
      throwsFormatException,
    );
    expect(() => WorldPack.migrate({'name': 'x'}), throwsFormatException);
  });
}
