import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/seed/pool_generator.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/entities/player_ids.dart';
import 'package:fnm/domain/services/club/clubs.dart';
import 'package:fnm/domain/services/federation/sponsors.dart';
import 'package:fnm/domain/services/player/golden_generation.dart';
import 'package:fnm/domain/services/player/player_traits.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
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
  Map<String, String> clubs = const {},
  Map<String, String> yAccounts = const {},
  Map<int, List<PackPlayer>> pools = const {},
  List<PackClub> addedClubs = const [],
  List<PackSponsor> addedSponsors = const [],
  List<PackYAccount> addedYAccounts = const [],
  Map<String, Map<String, String>> localized = const {},
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
  clubs: clubs,
  yAccounts: yAccounts,
  pools: pools,
  addedClubs: addedClubs,
  addedSponsors: addedSponsors,
  addedYAccounts: addedYAccounts,
  localized: localized,
);

const _fringe = PoolGenerator.firstFringeId;
const _added = kPackAddedIdBase;

List<PackPlayer> _pool(int n, {int from = _fringe}) => [
  for (var i = 0; i < n; i++) _p(from + i, PlayerPosition.cm),
];

PackSponsor _sponsor(int id, {String description = ''}) => PackSponsor(
  id: id,
  name: 'Sponsor $id',
  deal: SponsorDeal.values.first,
  industry: SponsorBrand.values.first.name,
  description: description,
);

List<BadField> _bad(WorldPack p) =>
    PackRules.issues(p).whereType<BadField>().toList();

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

  test('a blank nation name or code keeps the game\'s', () {
    final p = _pack(
      nations: {
        1: (name: '', code: 'CZX'),
        2: (name: 'Bohemia', code: ''),
      },
    );
    expect(
      PackRules.issues(p, baseCodes: {1: 'AAA', 2: 'BBB'}),
      isEmpty,
    );
    // A blank code leaves the game's in play for the duplicate check.
    final clash = _pack(nations: {1: (name: '', code: 'BBB')});
    expect(
      PackRules.issues(clash, baseCodes: {1: 'AAA', 2: 'BBB'}),
      [isA<DuplicateCode>()],
    );
  });

  test('squadIssues is exactly the squad part of issues, nation by nation', () {
    final pack = _pack(
      squads: {
        1: _squad(),
        2: _squad(gk: 1, fwd: 1),
        3: [
          ..._squad(def: 5),
          _p(90, PlayerPosition.st, name: ' ', age: 50, potential: 20),
        ],
      },
      nations: {4: (name: '', code: 'xx')},
    );
    final all = PackRules.issues(pack);
    final squadPart = [
      for (final i in all)
        if (i.where.startsWith('squads.')) i,
    ];
    final perNation = [
      for (final id in pack.squads.keys.toList()..sort())
        ...PackRules.squadIssues(id, pack.squads[id]!),
    ];
    expect(perNation.map((i) => i.where), squadPart.map((i) => i.where));
    expect(
      perNation.map((i) => i.runtimeType),
      squadPart.map((i) => i.runtimeType),
    );
    expect(perNation, isNotEmpty);
    // The rest of the pack is still checked by issues alone.
    expect(all.length, greaterThan(squadPart.length));
  });

  group('format 2', () {
    test('a pool of 151 is too big', () {
      final p = _pack(pools: {1: _pool(151)});
      final t = PackRules.issues(p).whereType<SquadTooSmall>().single;
      expect((t.nationId, t.have, t.need), (1, 151, PackRules.poolMax));
      expect(t.where, 'pools.1');
      expect(PackRules.issues(_pack(pools: {1: _pool(150)})), isEmpty);
      expect(PackRules.issues(_pack(pools: {1: const []})), isEmpty);
    });

    test('poolIssues checks fields as squadIssues does, with no minimum', () {
      final bad = _p(_fringe, PlayerPosition.gk, age: 50, name: ' ');
      final i = PackRules.poolIssues(3, [bad]);
      expect(i.map((x) => x.where), [
        'pools.3.$_fringe.name',
        'pools.3.$_fringe.age',
      ]);
      expect(PackRules.poolIssues(3, const []), isEmpty);
    });

    test('a pool id below firstFringeId is outOfRange', () {
      final p = _pack(
        pools: {
          1: [_p(_fringe - 1, PlayerPosition.cm)],
        },
      );
      final b = _bad(p).single;
      expect(b.path, 'pools.1.${_fringe - 1}');
      expect(b.reason, FieldReason.outOfRange);
      // A pack-made id is fine.
      expect(
        _bad(
          _pack(
            pools: {
              1: [_p(kPackPlayerIdBase + 5, PlayerPosition.cm)],
            },
          ),
        ),
        isEmpty,
      );
    });

    test('one id in a squad and a pool is duplicate', () {
      final squad = _squad()..add(_p(_fringe, PlayerPosition.st));
      final p = _pack(
        squads: {1: squad},
        pools: {
          2: [_p(_fringe, PlayerPosition.cm)],
        },
      );
      final b = _bad(p).single;
      expect(b.path, 'pools.2.$_fringe');
      expect(b.reason, FieldReason.duplicate);
      // Twice across two pools, too.
      final twice = _pack(
        pools: {
          1: [_p(_fringe, PlayerPosition.cm)],
          2: [_p(_fringe, PlayerPosition.cm)],
        },
      );
      expect(_bad(twice).single.path, 'pools.2.$_fringe');
    });

    test('five traits, or a trait twice, is an issue', () {
      PackPlayer withTraits(List<PlayerTrait> t) => PackPlayer(
        id: _fringe,
        name: 'T',
        age: 25,
        position: PlayerPosition.cm,
        attributes: const PlayerAttributes(
          physical: 60,
          technical: 60,
          stamina: 60,
        ),
        potential: 90,
        traits: t,
      );
      final five = _bad(
        _pack(
          pools: {
            1: [withTraits(PlayerTrait.values.take(5).toList())],
          },
        ),
      ).single;
      expect(five.path, 'pools.1.$_fringe.traits');
      expect(five.reason, FieldReason.outOfRange);
      final twice = _bad(
        _pack(
          pools: {
            1: [
              withTraits([PlayerTrait.leader, PlayerTrait.leader]),
            ],
          },
        ),
      ).single;
      expect(twice.reason, FieldReason.duplicate);
      expect(
        _bad(
          _pack(
            pools: {
              1: [
                withTraits(
                  PlayerTrait.values.take(PlayerTraits.maxTraits).toList(),
                ),
              ],
            },
          ),
        ),
        isEmpty,
      );
      // The same check runs on squads.
      final s = _squad()..[3] = withTraits(PlayerTrait.values.take(3).toList());
      expect(
        PackRules.squadIssues(1, s).single.where,
        'squads.1.$_fringe.traits',
      );
    });

    test('added ids must be in the reserved range and unique across kinds', () {
      final p = _pack(
        addedClubs: [
          const PackClub(id: 1, name: 'Low FC', country: 'cze'),
          const PackClub(id: _added, name: 'A FC', country: 'cze'),
        ],
        addedSponsors: [_sponsor(_added)],
        addedYAccounts: [
          const PackYAccount(
            id: kPackAddedIdMax + 1,
            name: 'HighAccount',
            voice: YVoice.fan,
          ),
        ],
      );
      final b = _bad(p);
      expect(b.map((x) => (x.path, x.reason)), [
        ('addedClubs.1.id', FieldReason.outOfRange),
        ('addedSponsors.$_added.id', FieldReason.duplicate),
        ('addedYAccounts.${kPackAddedIdMax + 1}.id', FieldReason.outOfRange),
      ]);
    });

    test("an added club named like one of the game's clubs of its country "
        'is a NameClash, not a BadField (case and spaces ignored)', () {
      final league = ClubService.leagueClubs('cze');
      expect(league, isNotEmpty);
      final clash = ' ${league.first.toUpperCase()}  ';
      final p = _pack(
        addedClubs: [PackClub(id: _added, name: clash, country: 'cze')],
      );
      expect(_bad(p), isEmpty);
      final c = PackRules.issues(p).whereType<NameClash>().single;
      expect(c.path, 'addedClubs.$_added');
      expect(c.where, 'addedClubs.$_added');
      // A game club the pack renames is the pack's own name: an added club
      // under it is a duplicate inside the pack, refused.
      final renamed = _pack(
        clubs: {league.first: 'Bohemka'},
        addedClubs: [
          PackClub(id: _added, name: league.first, country: 'cze'),
          const PackClub(id: _added + 1, name: 'bohemka', country: 'cze'),
        ],
      );
      expect(_bad(renamed).single.path, 'addedClubs.${_added + 1}');
      // Two added clubs of one country under one name.
      final two = _pack(
        addedClubs: [
          const PackClub(id: _added, name: 'New FC', country: 'cze'),
          const PackClub(id: _added + 1, name: 'new fc', country: 'cze'),
          const PackClub(id: _added + 2, name: 'New FC', country: 'svk'),
        ],
      );
      expect(_bad(two).map((x) => x.path), [
        'addedClubs.$_added',
        'addedClubs.${_added + 1}',
      ]);
      // Two added clubs under a game club's name: the pack's own duplicate
      // wins, and both are refused.
      final both = _pack(
        addedClubs: [
          PackClub(id: _added, name: league.first, country: 'cze'),
          PackClub(id: _added + 1, name: league.first, country: 'cze'),
        ],
      );
      expect(_bad(both).map((x) => x.path), [
        'addedClubs.$_added',
        'addedClubs.${_added + 1}',
      ]);
      expect(PackRules.issues(both).whereType<NameClash>(), isEmpty);
    });

    test("an added club's country is three lower-case letters", () {
      final b = _bad(
        _pack(
          addedClubs: [
            PackClub(id: _added, name: 'X FC', country: 'c' * 500),
          ],
        ),
      ).single;
      expect(b.path, 'addedClubs.$_added.country');
    });

    test('an added Y account named TheOldStopper is a NameClash; clashes '
        'inside the pack are duplicate', () {
      expect(YFeed.namedAccounts, contains('TheOldStopper'));
      PackYAccount y(int id, String name) =>
          PackYAccount(id: id, name: name, voice: YVoice.fan);
      final game = _pack(addedYAccounts: [y(_added, 'theoldstopper ')]);
      expect(_bad(game), isEmpty);
      expect(
        PackRules.issues(game).whereType<NameClash>().single.path,
        'addedYAccounts.$_added',
      );
      // Two added accounts under a game account's name: refused.
      final twice = _pack(
        addedYAccounts: [
          y(_added, 'TheOldStopper'),
          y(_added + 1, 'theoldstopper'),
        ],
      );
      expect(_bad(twice).map((x) => x.path), [
        'addedYAccounts.$_added',
        'addedYAccounts.${_added + 1}',
      ]);
      // A rename's new name and another added account clash too.
      final p = _pack(
        yAccounts: {'TheOldStopper': 'Stopper2'},
        addedYAccounts: [
          y(_added, 'stopper2'),
          y(_added + 1, 'Twin'),
          y(_added + 2, 'Twin'),
        ],
      );
      expect(_bad(p).map((x) => x.path), [
        'yAccounts.TheOldStopper',
        'addedYAccounts.$_added',
        'addedYAccounts.${_added + 1}',
        'addedYAccounts.${_added + 2}',
      ]);
      // Over the handle cap.
      final long = _bad(
        _pack(addedYAccounts: [y(_added, 'a' * (PackRules.handleMax + 1))]),
      ).single;
      expect(long.reason, FieldReason.tooLong);
    });

    test('a 121-character sponsor description is tooLong', () {
      final b = _bad(
        _pack(addedSponsors: [_sponsor(_added, description: 'd' * 121)]),
      ).single;
      expect(b.path, 'addedSponsors.$_added.description');
      expect(b.reason, FieldReason.tooLong);
      expect(
        _bad(_pack(addedSponsors: [_sponsor(_added, description: 'd' * 120)])),
        isEmpty,
      );
      expect(_bad(_pack(addedSponsors: [_sponsor(_added)])), isEmpty);
    });

    test("a badly shaped language is BadField outOfRange; 'xx' and 'cs' "
        'pass (an unknown language is compatibility\'s)', () {
      for (final lang in ['x y', 'CS', 'english', 'c', 'pt-BRAZIL', '']) {
        final b = _bad(
          _pack(
            localized: {
              'clubs.Old FC': {lang: 'Starý FC'},
            },
          ),
        ).single;
        expect(b.path, 'localized.clubs.Old FC.$lang');
        expect(b.reason, FieldReason.outOfRange);
      }
      for (final lang in ['xx', 'fil', 'pt-BR', 'zh_Hant']) {
        expect(
          _bad(
            _pack(
              localized: {
                'clubs.Old FC': {lang: 'Starý FC'},
              },
            ),
          ),
          isEmpty,
          reason: lang,
        );
      }
      expect(
        _bad(
          _pack(
            localized: {
              'clubs.Old FC': {'cs': 'Starý FC'},
            },
          ),
        ),
        isEmpty,
      );
    });

    test('a localized value keeps to its root\'s cap', () {
      final p = _pack(
        addedSponsors: [_sponsor(_added)],
        localized: {
          'yAccounts.TheOldStopper': {'cs': 'a' * 31},
          'addedSponsors.$_added.description': {'cs': 'd' * 120},
          'competitions.World Championship': {'cs': 'a' * 41, 'de': ''},
        },
      );
      expect(_bad(p).map((x) => (x.path, x.reason)), [
        (
          'localized.competitions.World Championship.cs',
          FieldReason.tooLong,
        ),
        ('localized.competitions.World Championship.de', FieldReason.empty),
        ('localized.yAccounts.TheOldStopper.cs', FieldReason.tooLong),
      ]);
    });

    test('localized addedClubs.700000099 with no such club is an issue', () {
      final b = _bad(
        _pack(
          localized: {
            'addedClubs.700000099': {'cs': 'Klub'},
          },
        ),
      ).single;
      expect(b.path, 'localized.addedClubs.700000099');
      expect(b.reason, FieldReason.outOfRange);
      final ok = _pack(
        addedClubs: [
          const PackClub(id: 700000099, name: 'Club', country: 'cze'),
        ],
        localized: {
          'addedClubs.700000099': {'cs': 'Klub'},
        },
      );
      expect(_bad(ok), isEmpty);
    });

    test('a localized path with no known root is an issue', () {
      final b = _bad(
        _pack(
          localized: {
            'nations.1': {'cs': 'X'},
          },
        ),
      ).single;
      expect(b.path, 'localized.nations.1');
    });

    test('over the caps for added items and localized entries', () {
      final p = _pack(
        addedClubs: [
          for (var i = 0; i <= PackRules.addedClubsMax; i++)
            PackClub(id: _added + i, name: 'Club $i', country: 'zzz'),
        ],
        addedSponsors: [
          for (var i = 0; i <= PackRules.addedSponsorsMax; i++)
            _sponsor(_added + 10000 + i),
        ],
        addedYAccounts: [
          for (var i = 0; i <= PackRules.addedYMax; i++)
            PackYAccount(
              id: _added + 20000 + i,
              name: 'Y$i',
              voice: YVoice.fan,
            ),
        ],
      );
      expect(_bad(p).map((x) => x.path), [
        'addedClubs',
        'addedSponsors',
        'addedYAccounts',
      ]);
      final loc = _pack(
        localized: {
          for (var i = 0; i <= PackRules.localizedMax; i++)
            'clubs.C$i': {'cs': 'K$i'},
        },
      );
      expect(_bad(loc).single.path, 'localized');
    });
  });

  group('fix round 1', () {
    test('a localized path with no values is empty', () {
      final b = _bad(
        _pack(localized: {'clubs.Old FC': const {}}),
      ).single;
      expect(b.path, 'localized.clubs.Old FC');
      expect(b.reason, FieldReason.empty);
    });

    test('an industry of the wrong shape is badCharacters; an unknown '
        'well-formed one is not an issue here', () {
      PackSponsor s(String industry) => PackSponsor(
        id: _added,
        name: 'S',
        deal: SponsorDeal.risky,
        industry: industry,
      );
      for (final bad in ['', 'x' * 41, 'two words', 'a1', 'ünï']) {
        final b = _bad(_pack(addedSponsors: [s(bad)])).single;
        expect(b.path, 'addedSponsors.$_added.industry', reason: bad);
        expect(b.reason, FieldReason.badCharacters);
      }
      expect(_bad(_pack(addedSponsors: [s('nothingKnown')])), isEmpty);
    });

    test('a pool id outside the fringe space and the pack-made range is '
        'outOfRange', () {
      for (final id in [
        kFringeIdLimit,
        kPackAddedIdBase,
        kPackAddedIdMax,
        kPackPlayerIdBase - 1,
        GoldenGeneration.idBase,
      ]) {
        final b = _bad(
          _pack(
            pools: {
              1: [_p(id, PlayerPosition.cm)],
            },
          ),
        ).single;
        expect(b.path, 'pools.1.$id');
        expect(b.reason, FieldReason.outOfRange);
      }
      for (final id in [
        kFirstFringeId,
        kFringeIdLimit - 1,
        kPackPlayerIdBase,
        GoldenGeneration.idBase - 1,
      ]) {
        expect(PackRules.poolIdInRange(id), isTrue, reason: '$id');
      }
    });

    test('unknown traits count toward the cap and the duplicates', () {
      PackPlayer withTraits(List<PlayerTrait> known, List<String> unknown) =>
          PackPlayer(
            id: _fringe,
            name: 'T',
            age: 25,
            position: PlayerPosition.cm,
            attributes: const PlayerAttributes(
              physical: 60,
              technical: 60,
              stamina: 60,
            ),
            potential: 90,
            traits: known,
            unknownTraits: unknown,
          );
      List<BadField> of(PackPlayer pl) => _bad(
        _pack(
          pools: {
            1: [pl],
          },
        ),
      );
      expect(of(withTraits([PlayerTrait.leader], ['flyingKick'])), isEmpty);
      expect(
        of(withTraits([PlayerTrait.leader], ['a', 'b'])).single.reason,
        FieldReason.outOfRange,
      );
      expect(
        of(withTraits(const [], ['flyingKick', 'flyingKick'])).single.reason,
        FieldReason.duplicate,
      );
    });

    test('an added club named like a side the game names for one of its '
        "country's cities is a NameClash", () {
      const cities = {
        'zzz': ['Alpha', 'Beta', 'Gamma', 'Delta'],
      };
      expect(ClubService.domesticClubNames('zzz', cities['zzz']!), [
        for (final c in ['Alpha', 'Beta', 'Gamma'])
          for (final s in [
            'City',
            'United',
            'FC',
            'Athletic',
            'Sporting',
            'Rovers',
            'Union',
            'Dynamo',
            'Olympic',
            'Wanderers',
            'Rangers',
            'Stars',
          ])
            '$c $s',
      ]);
      // A country with a curated league generates none.
      expect(ClubService.domesticClubNames('cze', const ['Praha']), isEmpty);
      final p = _pack(
        addedClubs: const [
          PackClub(id: _added, name: 'alpha united ', country: 'zzz'),
          PackClub(id: _added + 1, name: 'Delta City', country: 'zzz'),
        ],
      );
      // The game's own name: flagged (a NameClash), never refused.
      final issues = PackRules.issues(p, countryCities: cities);
      expect(issues.whereType<BadField>(), isEmpty);
      expect(issues.whereType<NameClash>().single.path, 'addedClubs.$_added');
      // Without the cities there is nothing to clash with.
      expect(PackRules.issues(p), isEmpty);
    });
  });
}
