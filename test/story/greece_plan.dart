import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/competition/finals_participation.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/messages/message_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';

import 'driver.dart';

/// Greece in nations.json.
const int greece = 22;

/// How far a European Championship run went, in order.
const List<String> euroStages = ['CGROUP', 'CR16', 'CQF', 'CSF', 'CFINAL'];

const Set<String> _koContinental = {'CR16', 'CQF', 'CSF', 'CFINAL'};

Future<void> _readAll(ProviderContainer c, int id) async {
  await c.read(messageServiceProvider).sync(id);
  await c.read(competitionRepositoryProvider).markMessagesRead(id);
}

/// One Greece career on world [seed], played by the story driver's autopilot
/// until the European Championship of cycle [cycles] is over. With [work] set
/// it saves a copy of the save at every story moment and writes
/// `manifest.json`; without it the very same career is played and only its
/// beats come back (the seed search). Both modes make the same calls into
/// the game, so a seed the search liked plays the same story when planned.
Future<String> playGreece({
  required int seed,
  required int cycles,
  String? work,
}) async {
  final plan = work != null;
  if (plan) {
    if (Directory(work).existsSync()) {
      Directory(work).deleteSync(recursive: true);
    }
    Directory('$work/snaps').createSync(recursive: true);
  }
  final c = storyContainer();
  final shots = <Map<String, Object?>>[];
  final log = StringBuffer('=== SEED $seed\n');
  var snaps = 0;

  Future<String> save() async {
    if (!plan) return '';
    final path = '$work/snaps/${(++snaps).toString().padLeft(3, '0')}.db';
    await c.read(appDatabaseProvider).customStatement("VACUUM INTO '$path'");
    return path;
  }

  void shot(String db, String type, String name, [Map<String, Object?>? x]) {
    if (plan) shots.add({'db': db, 'type': type, 'name': name, ...?x});
  }

  await c.read(seedLoaderProvider).ensureSeeded();
  var db = await save();
  shot(db, 'search', 'pick_nation', {'route': Routes.nations, 'text': 'Gree'});
  shot(db, 'snap', 'new_game', {'route': '${Routes.newGame}?nationId=$greece'});

  final career =
      (await c
              .read(careerServiceProvider)
              .create(
                nationId: greece,
                managerName: 'M. Urbanczyk',
                rngSeed: seed,
              ))
          .valueOrNull!;
  final id = career.id;
  final d = StoryDriver(c, id)..screenKnockouts = true;
  String q(String route) => '$route?careerId=$id';
  final hub = q(Routes.hub);

  var cycle = 1;
  final firsts = <String>{};

  db = await save();
  shot(db, 'snap', 'day_one_hub', {'route': hub, 'extra': 3});
  await _readAll(c, id);
  db = await save();
  shot(db, 'snap', 'board_brief', {'route': q(Routes.boardObjectives)});
  shot(db, 'snap', 'manager', {'route': q(Routes.manager)});
  shot(db, 'snap', 'ranking_start', {'route': q(Routes.ranking)});

  final reached = <int, String>{};
  final euroLine = <int, List<String>>{};
  final rankLine = <String>[];
  var euroOver = false; // Greece are out of the last Euro
  var lastPress = -1;
  var bigResults = 0;

  Future<int> rank() async =>
      (await c.read(rankingReleaseRepositoryProvider).latest(id))?.playerRank ??
      nationById[greece]!.ranking;

  /// Profiles of the men the story is about, from the current squad.
  Future<void> players(String tag) async {
    c.invalidate(squadDataProvider(id));
    final sub = c.listen(squadDataProvider(id).future, (_, _) {});
    final data = (await sub.read())!;
    sub.close();
    final squad = [
      for (final p in data.pool)
        if (data.callUps.contains(p.id)) p,
    ]..sort((a, b) => b.overall.compareTo(a.overall));
    final cap =
        (await c.read(careerRepositoryProvider).byId(id))!.captainPlayerId;
    final picks = <String, Player>{};
    void pick(String role, Iterable<Player> from) {
      for (final p in from) {
        if (picks.values.any((x) => x.id == p.id)) continue;
        picks[role] = p;
        return;
      }
    }

    pick('captain', squad.where((p) => p.id == cap));
    pick('striker', squad.where((p) => p.category == PositionCategory.forward));
    final young = squad.where((p) => p.age <= 21).toList();
    pick('young', young);
    pick(
      'keeper',
      squad.where((p) => p.category == PositionCategory.goalkeeper),
    );
    pick('star', squad);
    pick(
      'midfield',
      squad.where((p) => p.category == PositionCategory.midfielder),
    );
    pick(
      'defender',
      squad.where((p) => p.category == PositionCategory.defender),
    );
    final db = await save();
    for (final e in picks.entries) {
      log.writeln(
        'PLAYER $tag ${e.key}: ${e.value.name} (${e.value.age}, '
        '${e.value.position.name}, ${e.value.overall}) id ${e.value.id}',
      );
      shot(db, 'snap', '${tag}_player_${e.key}', {
        'route': '${q(Routes.player)}&playerId=${e.value.id}',
      });
    }
    shot(db, 'snap', '${tag}_squad', {'route': q(Routes.callUps)});
    shot(db, 'snap', '${tag}_tactics', {'route': q(Routes.tactics)});
    shot(db, 'snap', '${tag}_team_stats', {'route': q(Routes.teamStats)});
  }

  d.beforeEvent = (e) async {
    final route = e.route;
    final path = route == null ? null : Uri.parse(route).path;
    switch (e.kind) {
      case HubEventKind.draw:
        final wc =
            route != null &&
            Uri.parse(route).queryParameters['worldCup'] == 'true';
        final tag = '${path!.substring(1)}${wc ? '_wc' : ''}';
        if (path == Routes.continentalDraw) {
          // Euro qualifying is over: its tables, then the ceremony.
          rankLine.add('c$cycle euro draw: #${await rank()}');
          final db = await save();
          shot(db, 'snap', 'c${cycle}_euro_qualifying', {
            'route': '${q(Routes.continental)}&conf=europe',
          });
          shot(db, 'snap', 'c${cycle}_ranking_before_euro', {
            'route': q(Routes.ranking),
          });
          shot(db, 'snap', 'c${cycle}_board_before_euro', {
            'route': q(Routes.boardObjectives),
          });
          shot(db, 'snap', 'c${cycle}_draw_$tag', {
            'route': route,
            'extra': 40,
          });
          await players('c${cycle}_euro');
        } else if (firsts.add('draw:$tag:$cycle')) {
          shot(await save(), 'snap', 'c${cycle}_draw_$tag', {
            'route': route,
            'extra': 40,
          });
        }
      case HubEventKind.tournamentKickoff:
        shot(
          await save(),
          'snap',
          'c${cycle}_kickoff_${Uri.parse(route!).queryParameters['conf'] ?? 'wc'}',
          {
            'route': route,
            'extra': 12,
          },
        );
      case HubEventKind.trainingCamp:
        shot(await save(), 'snap', 'c${cycle}_base_camp', {'route': route});
      case HubEventKind.press:
        if (bigResults > lastPress && route != null) {
          lastPress = bigResults;
          shot(await save(), 'snap', 'c${cycle}_press_$bigResults', {
            'route': route,
            'extra': 2,
          });
        }
      case HubEventKind.cycleRollover:
        final db = await save();
        shot(db, 'snap', 'c${cycle}_messages', {'route': q(Routes.messages)});
        shot(db, 'snap', 'c${cycle}_rollover', {'route': route, 'extra': 4});
      default:
        break;
    }
  };

  var key = false;
  var live = false;
  var slug = '';
  var big = false;
  var firstMatch = true;
  final firstKo = <int>{};
  d.beforeMatch = (p) async {
    final f = p.fixture;
    final home = f.homeNationId == greece;
    final opp = nationById[home ? f.awayNationId : f.homeNationId]!;
    final gf = home ? p.result.homeScore : p.result.awayScore;
    final ga = home ? p.result.awayScore : p.result.homeScore;
    final wc = FinalsRounds.worldChampionship.contains(f.round);
    final cont = FinalsRounds.continental.contains(f.round);
    final ko = _koContinental.contains(f.round);
    final isFinal = f.round == 'CFINAL';
    final oppRank = opp.ranking;
    final giant = gf > ga && oppRank <= 15 && f.round != 'FRIENDLY';
    big = giant || (cont && (ko || gf > ga));
    key = cont || giant || (wc && gf >= ga);
    live = (cont && ko) || (cont && giant) || (giant && f.round == 'CQ');
    slug = 'c${cycle}_${opp.code.toLowerCase()}_${f.round ?? 'q'}';
    if (firstMatch && f.round != 'FRIENDLY') {
      firstMatch = false;
      await players('c1_first');
    }
    if (ko && firstKo.add(cycle)) {
      final db = await save();
      shot(db, 'snap', 'c${cycle}_euro_groups', {
        'route': '${q(Routes.continental)}&conf=europe',
      });
      shot(db, 'snap', 'c${cycle}_euro_groups_tab', {
        'route': '${q(Routes.continental)}&conf=europe',
        'tap': 'GROUPS',
      });
    }
    if (!key) return;
    await _readAll(c, id);
    final db = await save();
    shot(db, 'snap', '${slug}_preview', {'route': q(Routes.matchPreview)});
    if (live) {
      shot(db, 'live', slug, {
        'at': isFinal || f.round == 'CSF' ? [1, 60, 85] : <int>[75],
        'halfTime': ko,
        'goals': true,
        'expect': '${p.result.homeScore}-${p.result.awayScore}',
      });
    }
  };
  d.afterMatch = (Fixture played) async {
    final line = describe(played, nationId: greece);
    log.writeln(line);
    final r = played.round;
    final home = played.homeNationId == greece;
    if (FinalsRounds.continental.contains(r) && r != 'C3RD') {
      final prev = reached[cycle];
      if (prev == null || euroStages.indexOf(r!) > euroStages.indexOf(prev)) {
        reached[cycle] = r!;
      }
      (euroLine[cycle] ??= []).add(line);
      final gf = (home ? played.homeScore : played.awayScore)!;
      final ga = (home ? played.awayScore : played.homeScore)!;
      final pf = home ? played.homePenalties : played.awayPenalties;
      final pa = home ? played.awayPenalties : played.homePenalties;
      final lost = gf < ga || (gf == ga && pf != null && pf < pa!);
      if (_koContinental.contains(r) && lost && cycle == cycles) {
        euroOver = true;
      }
    }
    if (!key) return;
    if (big) bigResults++;
    final db = await save();
    shot(db, 'snap', '${slug}_results', {'route': q(Routes.roundResults)});
    shot(db, 'snap', '${slug}_news', {'route': hub, 'extra': 3});
    if (big) shot(db, 'snap', '${slug}_y', {'route': q(Routes.y)});
    if (_koContinental.contains(r)) {
      shot(db, 'snap', '${slug}_bracket', {
        'route': '${q(Routes.continental)}&conf=europe',
      });
    }
    if (euroOver) {
      shot(db, 'snap', '${slug}_board', {'route': q(Routes.boardObjectives)});
    }
  };

  final summary = StringBuffer();
  var midShot = false;
  for (var cy = 0; cy < cycles; cy++) {
    var steps = 0;
    final last = cy + 1 == cycles;
    while (true) {
      if (last && euroOver) break;
      if (!await d.step(stopAtRollover: true)) break;
      if (++steps > 4000) throw StateError('runaway');
      // Between Euros: the second cycle's first morning, a look at the climb
      // (ranking history, youth, board).
      if (cy == 1 && !midShot) {
        midShot = true;
        final db = await save();
        rankLine.add('c$cycle start: #${await rank()}');
        shot(db, 'snap', 'c2_vitrine', {
          'route': '${q(Routes.nationVitrine)}&nationId=$greece',
        });
        shot(db, 'snap', 'c2_youth', {'route': q(Routes.youth)});
        shot(db, 'snap', 'c2_board', {'route': q(Routes.boardObjectives)});
        shot(db, 'snap', 'c2_y', {'route': q(Routes.y)});
        shot(db, 'snap', 'c2_hub', {'route': hub, 'extra': 3});
      }
    }
    final honours = await c.read(competitionRepositoryProvider).honours(id);
    final euros = honours.where((h) => h.competition.contains('Europ')).toList()
      ..sort((a, b) => b.year.compareTo(a.year));
    final mine = [
      for (final h in honours)
        if (h.championId == greece || h.runnerUpId == greece)
          '${h.year} ${h.competition} ${h.championId == greece ? 'WON' : 'runner-up'}',
    ];
    summary.writeln(
      'SUMMARY seed $seed cycle $cycle: Euro reached '
      '${reached[cycle] ?? 'did not qualify'}; last Euro champion '
      '${nationById[euros.isEmpty ? null : euros.first.championId]?.name}; '
      'rank now #${await rank()}; Greece honours $mine',
    );
    for (final l in euroLine[cycle] ?? const <String>[]) {
      summary.writeln('   $l');
    }
    if (!last) {
      await d.step(); // the rollover (beforeEvent shoots it)
      cycle++;
    }
  }
  summary.writeln('RANKS ${rankLine.join('; ')}');

  if (plan && euroOver) {
    // Play on until the Euro is crowned, then the aftermath.
    var steps = 0;
    while (steps++ < 400) {
      final hs = await c.read(competitionRepositoryProvider).honours(id);
      final career = (await c.read(careerRepositoryProvider).byId(id))!;
      if (hs.any(
        (h) =>
            h.competition.contains('Europ') && h.year >= career.inGameDate.year,
      )) {
        break;
      }
      if (!await d.step(stopAtRollover: true)) break;
    }
    db = await save();
    shot(db, 'snap', 'after_euro_bracket', {
      'route': '${q(Routes.continental)}&conf=europe',
    });
    shot(db, 'snap', 'after_euro_hub', {'route': hub, 'extra': 3});
    shot(db, 'snap', 'after_euro_y', {'route': q(Routes.y)});
    shot(db, 'snap', 'after_euro_messages', {'route': q(Routes.messages)});
  }

  db = await save();
  for (final (r, name) in [
    (q(Routes.ranking), 'end_ranking'),
    (q(Routes.records), 'end_records'),
    (q(Routes.legends), 'end_legends'),
    (q(Routes.teamStats), 'end_team_stats'),
    (q(Routes.achievements), 'end_achievements'),
    (q(Routes.careerSummary), 'end_career_summary'),
    (q(Routes.managerHistory), 'end_manager_history'),
    ('${q(Routes.nationVitrine)}&nationId=$greece', 'end_vitrine'),
    (q(Routes.boardObjectives), 'end_board'),
    (hub, 'end_hub'),
  ]) {
    shot(db, 'snap', name, {'route': r});
  }
  if (plan) {
    // The owner's Greek set: Settings in Greek, then the same career's key
    // screens drawn in Greek.
    shot(db, 'snap', 'greek_settings', {
      'route': Routes.settings,
      'locale': 'el',
    });
    shot(db, 'snap', 'greek_settings_language', {
      'route': Routes.settings,
      'locale': 'el',
      'tapKey': 'settings-language-tile',
    });
    Map<String, Object?>? lastWhere(bool Function(Map<String, Object?>) t) {
      for (final s in shots.reversed) {
        if (t(s)) return s;
      }
      return null;
    }

    final greek = [
      lastWhere((s) => s['name'] == 'end_hub'),
      lastWhere((s) => '${s['name']}'.endsWith('_player_young')),
      lastWhere((s) => '${s['name']}'.endsWith('_player_captain')),
      lastWhere((s) => s['type'] == 'live'),
      lastWhere((s) => '${s['name']}'.endsWith('_bracket')),
      lastWhere((s) => '${s['name']}'.contains('_draw_continental')),
    ];
    for (final g in greek.nonNulls.toList()) {
      shots.add({...g, 'name': 'greek_${g['name']}', 'locale': 'el'});
    }
    File('$work/manifest.json').writeAsStringSync(
      const JsonEncoder.withIndent(
        ' ',
      ).convert({'careerId': id, 'shots': shots}),
    );
    File('$work/log.txt').writeAsStringSync('$log\n$summary');
  }
  c.dispose();
  return '$log\n$summary';
}
