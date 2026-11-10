import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/repositories/world_pack_repository.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/entities/player_ids.dart';
import 'package:fnm/domain/services/federation/sponsors.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/domain/services/world_pack/pack_codec.dart';
import 'package:fnm/domain/services/world_pack/pack_profanity.dart';
import 'package:fnm/domain/services/world_pack/pack_rules.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';

import '../../helpers/test_database.dart';

PackPlayer _player(int id, String name, {String? club}) => PackPlayer(
  id: kPackPlayerIdBase + id,
  name: name,
  age: 25,
  position: PlayerPosition.cm,
  attributes: const PlayerAttributes(physical: 60, technical: 60, stamina: 60),
  potential: 80,
  club: club,
  clubCountry: club == null ? null : 'cze',
);

/// A shared database with a slur in every kind of name it can hold.
WorldPack _dirty() => WorldPack(
  uuid: 'uuid-dirty',
  name: 'Kurva World',
  author: 'Me',
  formatVersion: kPackFormatVersion,
  madeWithVersion: '1.1.0',
  squads: {
    7: [
      _player(1, 'Fuck Face', club: 'Bitch FC'),
      _player(2, 'Pavel Novák', club: 'Sparta'),
    ],
  },
  nations: const {7: (name: 'Cuntland', code: 'TST')},
  clubs: const {'Old FC': 'Whore United'},
  stadiums: const {'7:Praha': 'Arena Sh1t'},
  competitions: const {'World Championship': 'Kurwa Cup'},
  sponsors: const {'agrofart': 'Shitbank'},
  yAccounts: const {'@fan': '@motherfucker'},
  reporters: const {0: PackReporter(name: 'Jan Kokot', outlet: 'Daily')},
  nameLists: {
    7: PackNameLists(
      first: ['Jan', 'Fuck', for (var i = 0; i < 20; i++) 'First$i'],
      sur: ['Kurva', for (var i = 0; i < 20; i++) 'Sur$i'],
    ),
  },
  managers: const {7: (name: 'Píča Trenér', nationality: 'TST')},
  addedClubs: const [
    PackClub(id: kPackAddedIdBase, name: 'Pussy Club', country: 'cze'),
  ],
  addedSponsors: const [
    PackSponsor(
      id: kPackAddedIdBase + 1,
      name: 'Arschloch AG',
      deal: SponsorDeal.crowdPleaser,
      industry: 'agrofart',
      description: 'We sell shit',
    ),
  ],
  addedYAccounts: const [
    PackYAccount(
      id: kPackAddedIdBase + 2,
      name: '@cunt',
      voice: YVoice.neutral,
    ),
  ],
  localized: const {
    'competitions.World Championship': {'cs': 'Pohár píčus'},
  },
);

void main() {
  test('every kind of name is found, at the path its fix opens', () {
    expect(PackRules.notAllowed(_dirty()).map((i) => i.where), [
      'squads.7.${kPackPlayerIdBase + 1}.name',
      'squads.7.${kPackPlayerIdBase + 1}.club',
      'nations.7.name',
      'clubs.Old FC',
      'stadiums.7:Praha',
      'competitions.World Championship',
      'sponsors.agrofart',
      'yAccounts.@fan',
      'reporters.0.name',
      'nameLists.7.first.1',
      'nameLists.7.sur.0',
      'managers.7.name',
      'addedClubs.$kPackAddedIdBase',
      'addedSponsors.${kPackAddedIdBase + 1}',
      'addedSponsors.${kPackAddedIdBase + 1}.description',
      'addedYAccounts.${kPackAddedIdBase + 2}',
      'localized.competitions.World Championship.cs',
      'name',
    ]);
  });

  test('a name the game does not show never blocks a career', () {
    final issues = PackRules.notAllowed(_dirty());
    expect(issues.any(isBlocking), isFalse);
    // Nor is it one of the issues that decide whether a pack is ready.
    final clean = WorldPack(
      uuid: 'u',
      name: 'Fuck',
      author: '',
      formatVersion: kPackFormatVersion,
      madeWithVersion: '1.1.0',
    );
    expect(PackRules.issues(clean), isEmpty);
  });

  test('masked for play: every refused name masked, the rest as it was', () {
    final p = maskedForPlay(_dirty());
    final squad = p.squads[7]!;
    expect(squad[0].name, 'F*** Face');
    expect(squad[0].club, 'B**** FC');
    expect(squad[1].name, 'Pavel Novák');
    expect(squad[1].club, 'Sparta');
    expect(p.name, 'K**** World');
    expect(p.nations[7]!.name, 'C*******');
    expect(p.nations[7]!.code, 'TST');
    expect(p.clubs, {'Old FC': 'W**** United'});
    expect(p.stadiums['7:Praha'], 'Arena S***');
    expect(p.yAccounts, {'@fan': '@m***********'});
    expect(p.sponsors, {'agrofart': 'S*******'});
    expect(p.reporters[0]!.name, 'Jan K****');
    expect(p.reporters[0]!.outlet, 'Daily');
    // A refused name-list entry is left out: no newgen is named by it.
    expect(p.nameLists[7]!.first, [
      'Jan',
      for (var i = 0; i < 20; i++) 'First$i',
    ]);
    expect(p.nameLists[7]!.sur.first, 'Sur0');
    expect(p.managers[7]!.name, 'P*** Trenér');
    expect(p.addedClubs.single.name, 'P**** Club');
    expect(p.addedSponsors.single.description, 'We sell s***');
    expect(p.addedYAccounts.single.name, '@c***');
    expect(
      p.localized['competitions.World Championship']!['cs'],
      'Pohár p****',
    );
    expect(PackRules.notAllowed(p), isEmpty);
  });

  test('a name list left with nothing clean keeps its names masked', () {
    final p = maskedForPlay(
      WorldPack(
        uuid: 'u',
        name: 'Lists',
        author: '',
        formatVersion: kPackFormatVersion,
        madeWithVersion: '1.1.0',
        nameLists: const {
          7: PackNameLists(first: ['Jan'], sur: ['Kurva', 'Chuj']),
        },
      ),
    );
    expect(p.nameLists[7]!.sur, ['K****', 'C***']);
  });

  test('a clean pack is played as it is, the very same object', () {
    final clean = WorldPack(
      uuid: 'u',
      name: 'Scunthorpe World',
      author: '',
      formatVersion: kPackFormatVersion,
      madeWithVersion: '1.1.0',
      squads: {
        7: [_player(1, 'Antonio Cassano')],
      },
    );
    expect(identical(maskedForPlay(clean), clean), isTrue);
  });

  group('a shared database', () {
    late AppDatabase db;
    late WorldPackRepository repo;

    setUp(() {
      db = createTestDatabase();
      repo = WorldPackRepository(db);
    });

    tearDown(() => db.close());

    test(
      'imports whole, keeps its names, and a career shows them masked',
      () async {
        // As a friend would share it: the file, read back as an import.
        final read = await PackCodec.decode(PackCodec.encode(_dirty(), {}));
        // Never refused for its names.
        expect(read, isA<PackDecoded>());
        final id = await repo.insert((read as PackDecoded).pack, {});
        // Stored as it came: nothing is rewritten.
        expect((await repo.load(id))!.squads[7]!.first.name, 'Fuck Face');

        final careerId = await db
            .into(db.careers)
            .insert(
              CareersCompanion.insert(
                nationId: 1,
                managerName: 'Manager',
                createdAt: DateTime.utc(2030),
                inGameDate: DateTime.utc(2030, 6, 1),
                rngSeed: 7,
              ),
            );
        await db.transaction(() => repo.copyToCareer(id, careerId));
        final world = (await repo.forCareer(careerId))!.pack;
        expect(world.squads[7]!.first.name, 'F*** Face');
        expect(world.competitions['World Championship'], 'K**** Cup');
        expect((await repo.careerWorldNames())[careerId], 'K**** World');
        expect((await repo.addedYAccountsFor(careerId)).single.name, '@c***');
        expect((await repo.managersFor(careerId))[7]!.name, 'P*** Trenér');

        // The career's own copy keeps the names as they were.
        final row = await (db.select(
          db.careerWorlds,
        )..where((t) => t.careerId.equals(careerId))).getSingle();
        final stored = WorldPack.fromJson(
          WorldPack.migrate(jsonDecode(row.json) as Map<String, Object?>),
        );
        expect(stored.squads[7]!.first.name, 'Fuck Face');
      },
    );
  });
}
