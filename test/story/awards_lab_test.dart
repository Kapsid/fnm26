import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/awards/award_year.dart';
import 'package:fnm/domain/services/awards/player_of_year.dart';
import 'package:fnm/features/career/career_providers.dart';

import '../helpers/poty_pack.dart';

import 'driver.dart';

/// Awards lab: plays LAB_CYCLES (default 2) cycles on autopilot for each of
/// LAB_AWARDS seeds and writes every finished year's raw vote material (the
/// year's fixtures, every rated appearance and each player's position, age
/// and rating) to LAB_OUT as JSON, one file per seed and year. The Player of
/// the Year calibration reads those files.
///
/// Not part of the suite: without LAB_AWARDS it plays nothing.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final packFrom = Platform.environment['LAB_AWARDS_PACK'];
  if (packFrom != null && packFrom.isNotEmpty) {
    test('pack the calibration set', () => _pack(Directory(packFrom)));
    return;
  }
  final raw = Platform.environment['LAB_AWARDS'];
  if (raw == null || raw.isEmpty) {
    test('awards lab', () {}, skip: 'set LAB_AWARDS to run the lab');
    return;
  }
  final seeds = raw.split(',').map(int.parse).toList();
  final cycles = int.parse(Platform.environment['LAB_CYCLES'] ?? '2');
  final out = Directory(Platform.environment['LAB_OUT'] ?? 'build/awards_lab')
    ..createSync(recursive: true);
  final nationId = int.parse(Platform.environment['LAB_NATION'] ?? '14');

  for (final seed in seeds) {
    test('seed $seed', () async {
      final c = storyContainer();
      addTearDown(c.dispose);
      final d = await StoryDriver.start(c, seed, nationId: nationId);
      final careers = c.read(careerRepositoryProvider);
      final comp = c.read(competitionRepositoryProvider);
      final players = c.read(playerRepositoryProvider);
      final dumped = <int>{};
      var steps = 0;
      while (true) {
        final career = (await careers.byId(d.careerId))!;
        if (career.cyclePointer >= cycles) break;
        final date = career.inGameDate;
        final year = date.month >= 12 ? date.year : date.year - 1;
        if (year >= CareerService.cycleStart.year && dumped.add(year)) {
          final data = await comp.awardYearData(d.careerId, year);
          final nations = {for (final a in data.appearances) a.nationId};
          final profiles = <String, List<Object>>{};
          for (final n in nations) {
            for (final p in await players.byNation(
              n,
              agingYears: CareerService.agingYears(career),
              saveSeed: career.rngSeed,
              careerId: career.id,
              includeIntlRetired: true,
              minAge: 15,
            )) {
              profiles['${p.id}'] = [p.position.name, p.age, p.overall];
            }
          }
          final json = {
            'seed': seed,
            'year': year,
            'dumpDate': date.toIso8601String(),
            'fixtures': [
              for (final f in data.fixtures)
                [
                  f.id,
                  f.competitionId,
                  f.kind.name,
                  f.confederation.name,
                  f.round,
                  f.date.toIso8601String(),
                  f.homeNationId,
                  f.awayNationId,
                  f.homeScore,
                  f.awayScore,
                  f.homePenalties,
                  f.awayPenalties,
                ],
            ],
            'apps': [
              for (final a in data.appearances)
                [
                  a.fixtureId,
                  a.playerId,
                  a.nationId,
                  a.rating,
                  a.goals,
                  a.assists,
                  if (a.cleanSheet) 1 else 0,
                  if (a.motm) 1 else 0,
                ],
            ],
            'players': profiles,
          };
          File(
            '${out.path}/s${seed}_$year.json',
          ).writeAsStringSync(jsonEncode(json));
          // ignore: avoid_print
          print(
            'LAB seed=$seed year=$year fixtures=${data.fixtures.length} '
            'apps=${data.appearances.length}',
          );
        }
        if (!await d.step()) break;
        if (++steps > 20000) throw StateError('runaway');
      }
    }, timeout: const Timeout(Duration(minutes: 60)));
  }
}

/// Packs every lab year in [dir] into [kPotyPackPath] (see [packYear]).
Future<void> _pack(Directory dir) async {
  final ranks = {for (final n in storyNations) n.id: n.ranking};
  final files =
      dir
          .listSync()
          .whereType<File>()
          .where((f) => RegExp(r's\d+_\d+\.json$').hasMatch(f.path))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));
  final out = <Map<String, Object?>>[];
  for (final file in files) {
    final j = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    final year = j['year'] as int;
    final fixtures = <AwardFixture>[
      for (final f in j['fixtures'] as List<dynamic>)
        () {
          final a = f as List<dynamic>;
          return (
            id: a[0] as int,
            competitionId: a[1] as int,
            kind: CompetitionKind.values.byName(a[2] as String),
            confederation: Confederation.values.byName(a[3] as String),
            round: a[4] as String?,
            date: DateTime.parse(a[5] as String),
            homeNationId: a[6] as int,
            awayNationId: a[7] as int,
            homeScore: a[8] as int,
            awayScore: a[9] as int,
            homePenalties: a[10] as int?,
            awayPenalties: a[11] as int?,
          );
        }(),
    ];
    final apps = <AwardAppearance>[
      for (final r in j['apps'] as List<dynamic>)
        () {
          final a = r as List<dynamic>;
          return (
            fixtureId: a[0] as int,
            playerId: a[1] as int,
            nationId: a[2] as int,
            rating: (a[3] as num).toDouble(),
            goals: a[4] as int,
            assists: a[5] as int,
            cleanSheet: a[6] == 1,
            motm: a[7] == 1,
          );
        }(),
    ];
    final y = AwardYear.build(
      year: year,
      fixtures: fixtures,
      appearances: apps,
      rankOf: (id) => ranks[id] ?? 150,
    );
    final profiles = <int, VoterProfile>{
      for (final e in (j['players'] as Map<String, dynamic>).entries)
        int.parse(e.key): (
          name: '',
          age: (e.value as List<dynamic>)[1] as int,
          position: PlayerPosition.values.byName(
            (e.value as List<dynamic>)[0] as String,
          ),
          overall: (e.value as List<dynamic>)[2] as int,
        ),
    };
    out.add(packYear(seed: j['seed'] as int, y: y, profiles: profiles));
  }
  File(kPotyPackPath)
    ..createSync(recursive: true)
    ..writeAsBytesSync(gzip.encode(utf8.encode(jsonEncode(out))));
  // ignore: avoid_print
  print('packed ${out.length} years');
}
