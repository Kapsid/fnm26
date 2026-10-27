import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/competition/finals_participation.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/messages/message_providers.dart';

import 'driver.dart';

/// Türkiye in nations.json.
const int turkiye = 53;

/// How far a World Championship run went, in order.
const List<String> wcStages = ['GROUP', 'R32', 'R16', 'QF', 'SF', 'FINAL'];

/// Marks all news read, generating what the inbox makes lazily first, so the
/// next hub shows only what happens after this.
Future<void> _readAll(ProviderContainer c, int id) async {
  await c.read(messageServiceProvider).sync(id);
  await c.read(competitionRepositoryProvider).markMessagesRead(id);
}

/// One Türkiye career on world [seed], played by the story driver's autopilot
/// for [cycles] cycles. With [work] set it saves a copy of the save at every
/// story moment and writes `manifest.json` (pass one of the story); without
/// it the very same career is played and only its beats come back (the seed
/// search). Both modes make the same calls into the game, so a seed the
/// search liked plays out the same story when it is planned.
Future<String> playTurkiye({
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

  // Before the career exists: picking the nation.
  await c.read(seedLoaderProvider).ensureSeeded();
  var db = await save();
  shot(db, 'search', 'pick_nation', {'route': Routes.nations, 'text': 'Türk'});
  shot(db, 'snap', 'new_game', {
    'route': '${Routes.newGame}?nationId=$turkiye',
  });

  final career =
      (await c
              .read(careerServiceProvider)
              .create(
                nationId: turkiye,
                managerName: 'M. Urbanczyk',
                rngSeed: seed,
              ))
          .valueOrNull!;
  final id = career.id;
  final d = StoryDriver(c, id);
  String q(String route) => '$route?careerId=$id';
  final hub = q(Routes.hub);

  var cycle = 1;
  final firsts = <String>{};

  // Day one.
  db = await save();
  shot(db, 'snap', 'day_one_hub', {'route': hub, 'extra': 3});
  await _readAll(c, id);
  db = await save();
  shot(db, 'snap', 'board_brief', {'route': q(Routes.boardObjectives)});
  shot(db, 'snap', 'stadiums', {'route': q(Routes.stadiums)});
  shot(db, 'snap', 'host_bid', {'route': '${q(Routes.hostBid)}&comp=wc'});
  shot(db, 'snap', 'manager', {'route': q(Routes.manager)});

  // What happened per cycle, for the search.
  final reached = <int, String>{};
  final finalsLine = <int, List<String>>{};
  var lastPress = -1;
  var bigResults = 0;

  d.beforeEvent = (e) async {
    final route = e.route;
    final path = route == null ? null : Uri.parse(route).path;
    switch (e.kind) {
      case HubEventKind.draw:
        final wc =
            route != null &&
            Uri.parse(route).queryParameters['worldCup'] == 'true';
        final tag = '${path!.substring(1)}${wc ? '_wc' : ''}';
        if (path == Routes.finalsDraw) {
          // Qualifying is over: its tables, then the ceremony.
          final db = await save();
          shot(db, 'snap', 'c${cycle}_wc_qualifying', {'route': q(Routes.cup)});
          shot(db, 'snap', 'c${cycle}_tournaments', {
            'route': q(Routes.tournaments),
          });
          shot(db, 'snap', 'c${cycle}_ranking_before_finals', {
            'route': q(Routes.ranking),
          });
          shot(db, 'snap', 'c${cycle}_draw_$tag', {
            'route': route,
            'extra': 40,
          });
        } else if (path == Routes.continentalDraw ||
            firsts.add('draw:$tag:$cycle')) {
          shot(await save(), 'snap', 'c${cycle}_draw_$tag', {
            'route': route,
            'extra': 40,
          });
        }
      case HubEventKind.tournamentKickoff:
        shot(await save(), 'snap', 'c${cycle}_kickoff', {
          'route': route,
          'extra': 12,
        });
      case HubEventKind.trainingCamp:
        shot(await save(), 'snap', 'c${cycle}_base_camp', {'route': route});
      case HubEventKind.budget:
        if (firsts.add('budget')) {
          shot(await save(), 'snap', 'budget', {'route': route});
        }
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
  var firstKo = <int>{};
  d.beforeMatch = (p) async {
    final f = p.fixture;
    final home = f.homeNationId == turkiye;
    final opp = nationById[home ? f.awayNationId : f.homeNationId]!;
    final gf = home ? p.result.homeScore : p.result.awayScore;
    final ga = home ? p.result.awayScore : p.result.homeScore;
    final wc = FinalsRounds.worldChampionship.contains(f.round);
    final cont = FinalsRounds.continental.contains(f.round);
    final ko =
        f.round != null &&
        !{'GROUP', 'CGROUP', 'CQ', 'NGROUP', 'FRIENDLY'}.contains(f.round);
    final isFinal = {'FINAL', 'CFINAL', 'FFINAL', 'NFINAL'}.contains(f.round);
    final giant = gf > ga && opp.ranking <= 12 && f.round != 'FRIENDLY';
    final upset = gf < ga && opp.ranking > 50;
    big = giant || upset || (ko && (wc || cont));
    key = wc || cont || isFinal || giant || upset;
    live = (wc && ko) || isFinal || (wc && giant);
    slug = 'c${cycle}_${opp.code.toLowerCase()}_${f.round ?? 'q'}';
    if (firstMatch && f.round != 'FRIENDLY') {
      firstMatch = false;
      final db = await save();
      shot(db, 'snap', 'squad', {'route': q(Routes.callUps)});
      shot(db, 'snap', 'tactics', {'route': q(Routes.tactics)});
    }
    if (wc && ko && firstKo.add(cycle)) {
      shot(await save(), 'snap', 'c${cycle}_wc_groups', {
        'route': q(Routes.cup),
        'tap': 'FINALS',
      });
    }
    if (!key) return;
    await _readAll(c, id);
    final db = await save();
    shot(db, 'snap', '${slug}_preview', {'route': q(Routes.matchPreview)});
    if (live) {
      shot(db, 'live', slug, {
        'at': isFinal ? [1, 60] : <int>[75],
        'halfTime': isFinal || f.round == 'SF',
        'goals': true,
        'stopAtExtraTime': ko && gf == ga,
        'expect': '${p.result.homeScore}-${p.result.awayScore}',
      });
    }
  };
  d.afterMatch = (Fixture played) async {
    log.writeln(describe(played, nationId: turkiye));
    final r = played.round;
    if (FinalsRounds.worldChampionship.contains(r) && r != '3RD') {
      final prev = reached[cycle];
      if (prev == null || wcStages.indexOf(r!) > wcStages.indexOf(prev)) {
        reached[cycle] = r!;
      }
      (finalsLine[cycle] ??= []).add(describe(played, nationId: turkiye));
    }
    if (!key) return;
    if (big) bigResults++;
    final db = await save();
    shot(db, 'snap', '${slug}_results', {'route': q(Routes.roundResults)});
    shot(db, 'snap', '${slug}_news', {'route': hub, 'extra': 3});
    if (big) shot(db, 'snap', '${slug}_y', {'route': q(Routes.y)});
    if (r == 'FINAL' || r == 'SF') {
      shot(db, 'snap', '${slug}_bracket', {'route': q(Routes.cup)});
    }
    if (r == 'CFINAL') {
      shot(db, 'snap', '${slug}_bracket', {
        'route': '${q(Routes.continental)}&conf=europe',
      });
    }
  };

  final summary = StringBuffer();
  for (var cy = 0; cy < cycles; cy++) {
    var steps = 0;
    while (await d.step(stopAtRollover: true)) {
      if (++steps > 4000) throw StateError('runaway');
    }
    final honours = await c.read(competitionRepositoryProvider).honours(id);
    final mine = [
      for (final h in honours)
        if (h.championId == turkiye || h.runnerUpId == turkiye)
          '${h.year} ${h.competition} ${h.championId == turkiye ? 'WON' : 'runner-up'}',
    ];
    final wcs = honours.where((h) => h.competition.contains('World')).toList()
      ..sort((a, b) => b.year.compareTo(a.year));
    final wcChamp = wcs.isEmpty ? null : wcs.first;
    summary.writeln(
      'SUMMARY seed $seed cycle $cycle: WC reached '
      '${reached[cycle] ?? 'did not qualify'}; champion '
      '${nationById[wcChamp?.championId]?.name}; Türkiye honours $mine',
    );
    for (final l in finalsLine[cycle] ?? const <String>[]) {
      summary.writeln('   $l');
    }
    if (cy + 1 < cycles) {
      await d.step(); // the rollover (beforeEvent shoots it)
      cycle++;
    }
  }
  final last = await d.nextEvent();
  if (last.kind == HubEventKind.cycleRollover) {
    // The verdict accepted (beforeEvent shoots it): the new cycle's first
    // morning.
    await d.step();
  }

  db = await save();
  for (final (r, name) in [
    (q(Routes.ranking), 'end_ranking'),
    (q(Routes.records), 'end_records'),
    (q(Routes.legends), 'end_legends'),
    (q(Routes.achievements), 'end_achievements'),
    (q(Routes.careerSummary), 'end_career_summary'),
    (q(Routes.managerHistory), 'end_manager_history'),
    ('${q(Routes.nationVitrine)}&nationId=$turkiye', 'end_vitrine'),
    (q(Routes.messages), 'end_messages'),
    (q(Routes.boardObjectives), 'end_board'),
    (hub, 'end_hub'),
  ]) {
    shot(db, 'snap', name, {'route': r});
  }
  if (plan) {
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
