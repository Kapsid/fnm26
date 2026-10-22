import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/repositories/drift_career_repository.dart';
import 'package:fnm/data/repositories/drift_competition_repository.dart';
import 'package:fnm/data/repositories/drift_player_repository.dart';
import 'package:fnm/data/seed/seed_loader.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/repositories/player_repository.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_database.dart';

/// The richer name pools (`country_names_more.json`) belong to careers created
/// from 1.0.6 on, and to no other.
///
/// Names are not stored: every read derives them from the save seed and the
/// nation's pools. So the pools a career reads are part of its identity, and a
/// save that existed before the richer pools must keep reading the old ones,
/// or every player in it is renamed overnight.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late DriftPlayerRepository repo;
  late List<Nation> nations;

  setUp(() async {
    db = createTestDatabase();
    nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Nation.fromJson(e as Map<String, Object?>))
            .toList();
    final players =
        (jsonDecode(File('assets/data/players.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Player.fromJson(e as Map<String, Object?>))
            .toList();
    await SeedLoader(
      db,
      InMemorySeedSource(nationList: nations, playerList: players),
    ).ensureSeeded();
    repo = DriftPlayerRepository(db);
  });

  tearDown(() => db.close());

  /// A career in the table, as an older version left it: no marker.
  Future<int> oldCareer(int nationId, int seed) async =>
      (await DriftCareerRepository(db).create(
        managerName: 'M',
        nationId: nationId,
        rngSeed: seed,
        startDate: DateTime(2026, 7),
      )).id;

  /// A career stamped the way [CareerService.create] now stamps one.
  Future<int> newCareer(int nationId, int seed) async {
    final id = await oldCareer(nationId, seed);
    await DriftCompetitionRepository(
      db,
    ).markDrawWatched(id, 0, namePoolsV2Kind);
    return id;
  }

  Map<String, dynamic> more() =>
      jsonDecode(File('assets/data/country_names_more.json').readAsStringSync())
          as Map<String, dynamic>;

  test(
    'a save without the marker reads exactly the names it always did',
    () async {
      // Frozen from the implementation before the richer pools existed: ten
      // stored players and four newgens per nation and seed, six years in.
      for (final MapEntry(:key, value: names) in _frozen.entries) {
        final [nation, seed] = [for (final s in key.split('/')) int.parse(s)];
        final career = await oldCareer(nation, seed);
        for (final viaCareer in [null, career]) {
          final pool = {
            for (final p in await repo.byNation(
              nation,
              saveSeed: seed,
              careerId: viaCareer,
              agingYears: 6,
              minAge: 15,
            ))
              p.id: p.name,
          };
          for (final MapEntry(key: id, value: name) in names.entries) {
            expect(
              pool[id],
              name,
              reason: '$key player $id (career $viaCareer)',
            );
          }
        }
      }
    },
  );

  test(
    'a new career draws from the richer pools, the same way every read',
    () async {
      final extra = more();
      for (final nation in [12, 58, 170]) {
        final seed = 4242 + nation;
        final career = await newCareer(nation, seed);
        final firstMore = ((extra['$nation'] as Map)['firstMore'] as List)
            .cast<String>()
            .toSet();
        final surMore = ((extra['$nation'] as Map)['surMore'] as List)
            .cast<String>()
            .toSet();
        Future<List<String>> names(DriftPlayerRepository r) async => [
          for (final p in await r.byNation(
            nation,
            saveSeed: seed,
            careerId: career,
            agingYears: 6,
            minAge: 15,
          ))
            p.name,
        ];
        final read = await names(repo);
        final fromMore = read.where((n) {
          final parts = n.split(' ');
          return firstMore.contains(parts.first) ||
              surMore.contains(parts.skip(1).join(' '));
        });
        expect(fromMore, isNotEmpty, reason: 'nation $nation');
        expect(
          read.toSet(),
          hasLength(read.length),
          reason: 'names stay unique',
        );
        // Deep into a career too: decades of newgens on top of the stored rows
        // walk far further into the permutation, and still no two men share a
        // name, and the first names are spread rather than clustered.
        final deep = [
          for (final p in await repo.byNation(
            nation,
            saveSeed: seed,
            careerId: career,
            agingYears: 40,
            minAge: 15,
          ))
            p.name,
        ];
        expect(deep.toSet(), hasLength(deep.length), reason: 'deep, $nation');
        expect(
          {for (final n in deep) n.split(' ').first}.length,
          greaterThan(deep.length ~/ 4),
          reason: 'first names spread, $nation',
        );
        expect(await names(repo), read, reason: 'a second read');
        expect(
          await names(DriftPlayerRepository(db)),
          read,
          reason: 'a fresh repository',
        );
        // And it is a different world from the same seed without the marker.
        final old = [
          for (final p in await repo.byNation(
            nation,
            saveSeed: seed,
            agingYears: 6,
            minAge: 15,
          ))
            p.name,
        ];
        expect(old, isNot(read));
      }
    },
  );

  test(
    'one name per player: nation pool, identity lookup and youth agree',
    () async {
      for (final marked in [false, true]) {
        const nation = 12;
        const seed = 99;
        final career = marked
            ? await newCareer(nation, seed)
            : await oldCareer(nation, seed);
        final senior = await repo.byNation(
          nation,
          saveSeed: seed,
          careerId: career,
          agingYears: 6,
          minAge: 15,
        );
        for (final p in senior) {
          final again = await repo.byId(
            p.id,
            saveSeed: seed,
            careerId: career,
            agingYears: 6,
          );
          expect(again?.name, p.name, reason: 'byId ${p.id} (marked $marked)');
        }
        final byIdName = {for (final p in senior) p.id: p.name};
        final youth = await repo.youthByNation(
          nation,
          saveSeed: seed,
          careerId: career,
          agingYears: 6,
        );
        var shared = 0;
        for (final y in youth) {
          if (byIdName[y.id] case final name?) {
            shared++;
            expect(y.name, name, reason: 'youth ${y.id} (marked $marked)');
          }
        }
        expect(
          shared,
          greaterThan(0),
          reason: 'the youth and senior pools overlap at 15-20',
        );
      }
    },
  );

  test('CareerService.create stamps the marker', () async {
    SharedPreferences.setMockInitialValues({});
    final c = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
      ],
    );
    addTearDown(c.dispose);
    final career =
        (await c
                .read(careerServiceProvider)
                .create(nationId: 12, managerName: 'M'))
            .valueOrNull!;
    expect(
      await c
          .read(competitionRepositoryProvider)
          .hasWatchedDraw(career.id, 0, namePoolsV2Kind),
      isTrue,
    );
  });
}

/// nation/seed -> player id -> name, as the old code named them.
const Map<String, Map<int, String>> _frozen = {
  '12/1': {
    1201: 'Antonín Matoušek',
    1202: 'David Blažek',
    1203: 'Lubomír Musil',
    1204: 'František Zeman',
    1205: 'Jan Matoušek',
    1206: 'David Marek',
    1207: 'Rostislav Pavelek',
    1208: 'Dominik Marek',
    1209: 'Hynek Jelínek',
    1210: 'Kryštof Bartoš',
    1012010006: 'Miroslav Kadlec',
    1012010005: 'Martin Ševčík',
    1012010003: 'Jiří Pelc',
    1012010002: 'Josef Malý',
  },
  '12/777': {
    1201: 'Michal Urban',
    1202: 'Michal Král',
    1203: 'Josef Bartoš',
    1204: 'Hynek Růžička',
    1205: 'Lubomír Bureš',
    1206: 'Ladislav Holub',
    1207: 'Filip Krejčí',
    1208: 'Hynek Procházka',
    1209: 'David Hruška',
    1210: 'Jaroslav Matoušek',
    1012010006: 'Dominik Zeman',
    1012010005: 'Roman Jelínek',
    1012010003: 'Rostislav Konečný',
    1012010002: 'Radek Musil',
  },
  '12/123456': {
    1201: 'Filip Procházka',
    1202: 'Adam Kříž',
    1203: 'Vojtěch Krejčí',
    1204: 'Jiří Malý',
    1205: 'Vladimír Blažek',
    1206: 'Matyáš Urbanczyk',
    1207: 'Ondřej Matoušek',
    1208: 'Tomáš Fiala',
    1209: 'Kryštof Čermák',
    1210: 'Tomáš Homolka',
    1012010006: 'Ondřej Sedláček',
    1012010005: 'Lukáš Hruška',
    1012010003: 'Vladimír Novák',
    1012010002: 'Ivo Ondráček',
  },
  '58/1': {
    5801: 'Endrick Andrade',
    5802: 'Wesley Araújo',
    5803: 'Vinícius Correia',
    5804: 'Caio Moreira',
    5805: 'Douglas Teixeira',
    5806: 'Marquinhos Andrade',
    5807: 'Jean Ferreira',
    5808: 'Douglas Vieira',
    5809: 'Thiago Rocha',
    5810: 'Breno Monteiro',
    1058010006: 'Breno Silva',
    1058010004: 'Éder Correia',
    1058010003: 'Endrick Carvalho',
    1058010002: 'Talles Carvalho',
  },
  '58/777': {
    5801: 'Breno Magalhães',
    5802: 'Thiago Carvalho',
    5803: 'Jean Farias',
    5804: 'Davi Carvalho',
    5805: 'Davi Tavares',
    5806: 'Douglas Cardoso',
    5807: 'Luan Cavalcanti',
    5808: 'Davi Barbosa',
    5809: 'Igor Vieira',
    5810: 'Estêvão Monteiro',
    1058010006: 'Nathan Costa',
    1058010004: 'Alisson Barbosa',
    1058010003: 'Diego Souza',
    1058010002: 'Everton Mendes',
  },
  '58/123456': {
    5801: 'Igor Costa',
    5802: 'André Ribeiro',
    5803: 'Raphinha Araújo',
    5804: 'João Ferreira',
    5805: 'Caio Alves',
    5806: 'Alisson Correia',
    5807: 'Nathan Teixeira',
    5808: 'Matheus Alves',
    5809: 'Murilo Barbosa',
    5810: 'Igor Moraes',
    1058010006: 'João Andrade',
    1058010004: 'Jean Freitas',
    1058010003: 'Neymar Nascimento',
    1058010002: 'Davi Teixeira',
  },
  '170/1': {
    17001: 'Sota Suzuki',
    17002: 'Kota Ishikawa',
    17003: 'Haruto Maruyama',
    17004: 'Hayato Miura',
    17005: 'Hotaru Kimura',
    17006: 'Sota Sasaki',
    17007: 'Shinji Hasegawa',
    17008: 'Shuto Maruyama',
    17009: 'Hayato Mori',
    17010: 'Ayase Abe',
    1170010005: 'Hiroki Takeuchi',
    1170010004: 'Tsubasa Fukuda',
    1170010003: 'Yuito Ishida',
    1170010002: 'Hiroki Hara',
  },
  '170/777': {
    17001: 'Takumi Saito',
    17002: 'Ryota Suzuki',
    17003: 'Tsubasa Sasaki',
    17004: 'Shuto Sato',
    17005: 'Kyogo Abe',
    17006: 'Kyogo Hayashi',
    17007: 'Ryo Nakajima',
    17008: 'Keito Yamada',
    17009: 'Ko Murakami',
    17010: 'Takehiro Murakami',
    1170010005: 'Riku Noguchi',
    1170010004: 'Hidemasa Mori',
    1170010003: 'Wataru Harada',
    1170010002: 'Reo Takahashi',
  },
  '170/123456': {
    17001: 'Hidemasa Abe',
    17002: 'Zion Kato',
    17003: 'Keito Hara',
    17004: 'Ryo Sasaki',
    17005: 'Kaoru Ota',
    17006: 'Ko Abe',
    17007: 'Itsuki Sato',
    17008: 'Riku Tanaka',
    17009: 'Sho Fujita',
    17010: 'Ryo Ishikawa',
    1170010005: 'Takumi Hasegawa',
    1170010004: 'Genki Ono',
    1170010003: 'Tsubasa Sakamoto',
    1170010002: 'Hiroki Matsumoto',
  },
};
