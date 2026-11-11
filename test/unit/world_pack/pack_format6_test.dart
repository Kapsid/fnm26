import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/world_pack/active_world.dart';
import 'package:fnm/domain/services/world_pack/pack_codec.dart';
import 'package:fnm/domain/services/world_pack/pack_paths.dart';
import 'package:fnm/domain/services/world_pack/pack_profanity.dart';
import 'package:fnm/domain/services/world_pack/pack_rules.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';

/// Format 6 (1.1.1): the press reporters and the stadiums a pack adds.
/// Written only when used, so every pack without them stays readable by an
/// older build; ruled like every other added item.
void main() {
  tearDown(() => ActiveWorld.current = ActiveWorld.none);

  const base = kPackAddedIdBase;
  const czechia = 34;

  WorldPack pack({
    List<PackAddedReporter> reporters = const [],
    List<PackStadium> stadiums = const [],
    Map<String, Map<String, String>> localized = const {},
  }) => WorldPack(
    uuid: 'u6',
    name: 'Six',
    author: '',
    formatVersion: kPackFormatVersion,
    madeWithVersion: '1.1.1',
    addedReporters: reporters,
    addedStadiums: stadiums,
    localized: localized,
  );

  const reporter = PackAddedReporter(
    id: base,
    name: 'Mira Holcova',
    outlet: 'Vltava Sport',
  );
  const ground = PackStadium(
    id: base + 1,
    nationId: czechia,
    name: 'Arena Labe',
    city: 'Usti nad Labem',
    capacity: 18000,
  );

  WorldPack roundTrip(WorldPack p) => WorldPack.fromJson(
    WorldPack.migrate(
      jsonDecode(jsonEncode(p.asWritten.toJson())) as Map<String, Object?>,
    ),
  );

  group('the file', () {
    test('a pack without the new parts is written as before', () {
      final plain = pack().asWritten;
      expect(plain.formatVersion, 3);
      final json = plain.toJson();
      expect(json.containsKey('addedReporters'), isFalse);
      expect(json.containsKey('addedStadiums'), isFalse);
      // A format-5 pack stays format 5.
      final five = pack().copyWith(yHandles: const {'HomeEndHarry': 'Harry'});
      expect(five.asWritten.formatVersion, 5);
      expect(five.asWritten.toJson().containsKey('addedReporters'), isFalse);
    });

    test('each new part makes it format 6, and round-trips', () {
      for (final p in [
        pack(reporters: const [reporter]),
        pack(stadiums: const [ground]),
        pack(reporters: const [reporter], stadiums: const [ground]),
      ]) {
        expect(p.asWritten.formatVersion, 6);
        final json = p.asWritten.toJson();
        // A format-6 file holds the format 4 and 5 keys too.
        expect(json.keys, containsAll(['managers', 'yHandles']));
        expect(roundTrip(p), p);
      }
    });

    test('a format-5 file reads, with nothing added', () {
      final json = pack().copyWith(formatVersion: 5).toJson()
        ..remove('addedReporters')
        ..remove('addedStadiums');
      final p = WorldPack.fromJson(WorldPack.migrate(json));
      expect(p.formatVersion, kPackFormatVersion);
      expect(p.addedReporters, isEmpty);
      expect(p.addedStadiums, isEmpty);
      // A format-5 file already holding a format-6 key is no format-5 file.
      expect(
        () => WorldPack.migrate({...json, 'addedStadiums': <Object?>[]}),
        throwsFormatException,
      );
    });

    test('an entry of the wrong shape is refused', () {
      final json = pack(stadiums: const [ground]).toJson();
      for (final bad in <Object?>[
        {...ground.toJson(), 'capacity': '18000'},
        {...ground.toJson(), 'roof': true},
        {...ground.toJson()}..remove('city'),
      ]) {
        expect(
          () => WorldPack.fromJson({
            ...json,
            'addedStadiums': [bad],
          }),
          throwsFormatException,
          reason: '$bad',
        );
      }
      expect(
        () => WorldPack.fromJson({
          ...json,
          'addedReporters': [
            {'id': base, 'name': 'X'},
          ],
        }),
        throwsFormatException,
      );
    });

    test('the .fnmdb file carries them; a newer format is refused', () async {
      final p = pack(reporters: const [reporter], stadiums: const [ground]);
      final decoded = await PackCodec.decode(
        PackCodec.encode(p, const {}),
        baseCodes: const {czechia: 'CZE'},
      );
      expect(decoded, isA<PackDecoded>());
      final back = (decoded as PackDecoded).pack;
      expect(back.addedReporters, [reporter]);
      expect(back.addedStadiums, [ground]);

      final newer = jsonEncode({
        'format': kPackFormatVersion + 1,
        'pack': {...p.toJson(), 'formatVersion': kPackFormatVersion + 1},
        'trophies': <String, Object?>{},
      });
      final refused = await PackCodec.decode(
        Uint8List.fromList(gzip.encode(utf8.encode(newer))),
      );
      expect(
        (refused as PackRejected).reason,
        PackRejection.newerFormat,
      );
    });
  });

  group('the rules', () {
    List<String> bad(WorldPack p) => [
      for (final i in PackRules.issues(p).whereType<BadField>())
        '${i.path} ${i.reason.name}',
    ];

    test('a whole reporter and stadium pass', () {
      expect(
        PackRules.issues(
          pack(reporters: const [reporter], stadiums: const [ground]),
        ),
        isEmpty,
      );
    });

    test('names, cities and seats are checked', () {
      final p = pack(
        reporters: const [
          PackAddedReporter(id: base, name: ' ', outlet: 'Sport'),
        ],
        stadiums: const [
          PackStadium(
            id: base + 1,
            nationId: czechia,
            name: 'Arena Labe',
            city: '',
            capacity: 999,
          ),
          PackStadium(
            id: base + 2,
            nationId: czechia,
            name: ' arena labe ',
            city: 'Decin',
            capacity: 150001,
          ),
          // Another nation may have one of that name.
          PackStadium(
            id: base + 3,
            nationId: 35,
            name: 'Arena Labe',
            city: 'Dresden',
            capacity: PackRules.stadiumCapacityMax,
          ),
        ],
      );
      expect(bad(p), [
        'addedReporters.$base empty',
        'addedStadiums.${base + 1}.city empty',
        'addedStadiums.${base + 1}.capacity outOfRange',
        'addedStadiums.${base + 2} duplicate',
        'addedStadiums.${base + 2}.capacity outOfRange',
      ]);
      expect(PackRules.stadiumCapacityOk(PackRules.stadiumCapacityMin), true);
    });

    test('ids are shared with every other added item', () {
      final p = pack(
        reporters: const [reporter],
        stadiums: const [
          PackStadium(
            id: base,
            nationId: czechia,
            name: 'Arena Labe',
            city: 'Decin',
            capacity: 9000,
          ),
          PackStadium(
            id: 5,
            nationId: czechia,
            name: 'Arena Vltava',
            city: 'Decin',
            capacity: 9000,
          ),
        ],
      );
      expect(bad(p), [
        'addedStadiums.$base.id duplicate',
        'addedStadiums.5.id outOfRange',
      ]);
    });

    test('the caps hold, in the rules and the file reader', () {
      final many = pack(
        reporters: [
          for (var i = 0; i <= PackRules.addedReportersMax; i++)
            PackAddedReporter(id: base + i, name: 'R$i', outlet: 'O'),
        ],
      );
      expect(bad(many), contains('addedReporters outOfRange'));
      expect(PackCodec.fieldsOk(many), isFalse);
    });

    test('their per-language names are paths of their own', () {
      final p = pack(
        reporters: const [reporter],
        stadiums: const [ground],
        localized: {
          PackPaths.addedReporter(base): {'cs': 'Mira Holcová'},
          PackPaths.addedReporterOutlet(base): {'cs': 'Vltava Sport CZ'},
          PackPaths.addedStadium(base + 1): {'cs': 'Aréna Labe'},
          // Naming nothing the pack adds.
          PackPaths.addedStadium(base + 9): {'cs': 'Nikde'},
          'addedReporters.$base.city': {'cs': 'X'},
        },
      );
      expect(bad(p), [
        'localized.addedReporters.$base.city outOfRange',
        'localized.addedStadiums.${base + 9} outOfRange',
      ]);
    });

    test('a stadium of a nation the game lacks is flagged, not refused', () {
      final p = pack(
        stadiums: const [
          PackStadium(
            id: base,
            nationId: 9999,
            name: 'Arena',
            city: 'Nowhere',
            capacity: 5000,
          ),
        ],
      );
      final compat = PackRules.compatibility(
        p,
        nationIds: const {czechia},
        competitionNames: const {},
        trophyKeys: const {},
        sponsorBrands: const {},
        yAccounts: const {},
        countryCodes: const {},
        fringeRanges: const {},
      );
      expect(compat.map((i) => i.where), ['addedStadiums.$base']);
      expect(PackCodec.fieldsOk(p), isTrue);
    });

    test('a word the game does not show is listed and masked in play', () {
      final p = pack(
        reporters: const [
          PackAddedReporter(id: base, name: 'Fuck Face', outlet: 'Shit FM'),
        ],
        stadiums: const [
          PackStadium(
            id: base + 1,
            nationId: czechia,
            name: 'Fuck Arena',
            city: 'Shit City',
            capacity: 5000,
          ),
        ],
      );
      expect(PackRules.notAllowed(p).map((i) => i.where), [
        'addedReporters.$base',
        'addedReporters.$base.outlet',
        'addedStadiums.${base + 1}',
        'addedStadiums.${base + 1}.city',
      ]);
      final masked = maskedForPlay(p);
      expect(masked.addedReporters.single.name, isNot(contains('Fuck')));
      expect(masked.addedReporters.single.outlet, isNot(contains('Shit')));
      expect(masked.addedStadiums.single.name, isNot(contains('Fuck')));
      expect(masked.addedStadiums.single.capacity, 5000);
    });
  });

  test('the world names an added reporter and stadium in a language', () {
    final p = pack(
      reporters: const [reporter],
      stadiums: const [ground],
      localized: {
        PackPaths.addedReporter(base): {'cs': 'Míra Holcová'},
        PackPaths.addedStadium(base + 1): {'cs': 'Aréna Labe'},
      },
    );
    final world = ActiveWorld(p);
    expect(world.addedReporter(base), reporter);
    expect(world.addedReporter(base + 7), isNull);
    final cs = world.inLanguage('cs');
    expect(
      cs.addedReporter(base),
      const PackAddedReporter(
        id: base,
        name: 'Míra Holcová',
        outlet: 'Vltava Sport',
      ),
    );
    expect(cs.addedStadiumName(base + 1, world: 'u6'), 'Aréna Labe');
    // Another world's stadium of that id is not this one.
    expect(cs.addedStadiumName(base + 1, world: 'other'), isNull);
    expect(ActiveWorld.none.addedReporter(base), isNull);
  });
}
