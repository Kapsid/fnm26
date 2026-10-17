import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/tactics/team_chemistry.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/tactics_lab.dart';
import '../../helpers/test_database.dart';

/// THE CAREER LAB: what the manager's plan is worth over a whole career, not
/// one match.
///
/// The match lab (`tactics_lab_test.dart`) measures a plan in `MatchEngine`
/// between flat-rated sides. This drives real careers instead: Czechia (a
/// mid European nation, world ranking 36), the real nation and player data,
/// the manager's tactic set through `TacticService` exactly as the tactics
/// screen stores it, and `SeasonService.advance` (skip) until the first World
/// Championship has a champion. Every manager match is therefore played by the
/// skip path, `_withManagerTactics` in `hub_providers.dart`: his plan against
/// the AI's posture, the AI's counter to his recent plans, and the openness
/// the two make. The design doc explains why the career lab skips rather than
/// plays: skip/play parity is proven at match level (`skip_parity_test.dart`).
///
/// The plans are the match lab's own (`labPlans`), so both labs name the same
/// thing: `neutral` (the control), `possession` (the committed plan with the
/// best mean goal difference across the lab's After tables, countered or
/// not) and `highPress` (the plan a countering side punishes hardest there).
///
/// Two modes, because a skipped match does not add to the stored drilling
/// (only `playPlayerMatch` calls `recordMatch`):
///  * `skip` (default): the app exactly as it is for a manager who skips
///    everything. With no history the AI has no plan to scout, so there is no
///    counter at all.
///  * `drilled`: after each of his matches the harness records the plan into
///    `tactic_familiarities` the way the played path does, so the next skipped
///    match is countered as it would be for a manager who plays his matches
///    and never changes plan.
///
/// Opt-in and slow (about 10 s a career). Every career appends one JSON line
/// to `<out>/<mode>-<plan>-shard<i>.jsonl`; the report run reads them all:
///
///     FNM_CAREER_LAB=neutral,possession,highPress FNM_SHARD=0/8 \
///       FNM_CAREER_LAB_CAREERS=200 FNM_CAREER_LAB_MODE=skip \
///       FNM_CAREER_LAB_OUT=build/career_lab \
///       flutter test test/unit/match/tactics_career_lab_test.dart
///     FNM_CAREER_LAB=report FNM_CAREER_LAB_OUT=build/career_lab \
///       flutter test test/unit/match/tactics_career_lab_test.dart
///
/// Career k (0-based) uses `rngSeed: 1000 + k` for every plan, so the plans
/// are compared over the same worlds.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, Object>{});

  final env = Platform.environment;
  final lab = env['FNM_CAREER_LAB'];
  final out = env['FNM_CAREER_LAB_OUT'] ?? 'build/career_lab';

  if (lab == 'report') {
    test('career lab report', () => _report(out));
    return;
  }

  final careers = int.parse(env['FNM_CAREER_LAB_CAREERS'] ?? '200');
  final mode = env['FNM_CAREER_LAB_MODE'] ?? 'skip';
  final shard = (env['FNM_SHARD'] ?? '0/1').split('/').map(int.parse).toList();
  final plans = [
    for (final name in (lab ?? '').split(','))
      if (name.isNotEmpty) labPlans.firstWhere((p) => p.name == name),
  ];

  test(
    'career lab ($mode, shard ${shard[0]}/${shard[1]})',
    () async {
      final nations =
          (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                  as List<dynamic>)
              .map((e) => Nation.fromJson(e as Map<String, Object?>))
              .toList();
      final players =
          (jsonDecode(File('assets/data/players.json').readAsStringSync())
                  as List<dynamic>)
              .map((e) => Player.fromJson(e as Map<String, Object?>))
              .toList();
      Directory(out).createSync(recursive: true);
      for (final plan in plans) {
        final sink = File(
          '$out/$mode-${plan.name}-shard${shard[0]}.jsonl',
        ).openWrite(mode: FileMode.append);
        for (var k = shard[0]; k < careers; k += shard[1]) {
          final watch = Stopwatch()..start();
          final row = await _career(
            nations: nations,
            players: players,
            plan: plan,
            rngSeed: 1000 + k,
            drilled: mode == 'drilled',
          );
          sink.writeln(
            jsonEncode({...row, 'ms': watch.elapsedMilliseconds}),
          );
          await sink.flush();
        }
        await sink.close();
      }
    },
    skip: plans.isEmpty ? 'set FNM_CAREER_LAB to run the career lab' : null,
    timeout: Timeout.none,
  );
}

/// Czechia in `assets/data/nations.json`.
const int _czechia = 12;

/// How far into the World Championship finals a side went, as an ordinal: 0
/// not there, 1 group, 2 round of 32, 3 last 16, 4 quarter-final, 5 semi-final
/// (including the third-place game), 6 the final, 7 champion.
const Map<String, int> _stage = {
  'GROUP': 1,
  'R32': 2,
  'R16': 3,
  'QF': 4,
  'SF': 5,
  '3RD': 5,
  'FINAL': 6,
};

/// One career, from creation to the first World Championship champion.
Future<Map<String, Object?>> _career({
  required List<Nation> nations,
  required List<Player> players,
  required LabPlan plan,
  required int rngSeed,
  required bool drilled,
}) async {
  final db = createTestDatabase();
  final c = ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
      premiumUnlockedProvider.overrideWith((ref) => true),
      seedSourceProvider.overrideWithValue(
        InMemorySeedSource(nationList: nations, playerList: players),
      ),
    ],
  );
  try {
    await c.read(seedLoaderProvider).ensureSeeded();
    final career =
        (await c
                .read(careerServiceProvider)
                .create(nationId: _czechia, managerName: 'M', rngSeed: rngSeed))
            .valueOrNull!;

    // The plan, stored the way the tactics screen stores it: the shape (which
    // re-picks the best eleven for it) and then the six dials.
    final tactics = c.read(tacticServiceProvider);
    await tactics.setFormation(career.id, plan.formation);
    await tactics.setInstructions(career.id, plan.instructions);
    final stored = await c
        .read(tacticsRepositoryProvider)
        .tacticForCareer(career.id);
    expect(stored?.formation, plan.formation);
    expect(stored?.instructions, plan.instructions);

    Future<List<FixtureRow>> ours() async => [
      for (final f in await db.select(db.fixtures).get())
        if (f.played &&
            (f.homeNationId == _czechia || f.awayNationId == _czechia))
          f,
    ];

    final season = c.read(seasonServiceProvider);
    final fam = c.read(tacticFamiliarityRepositoryProvider);
    var recorded = 0;
    int? champion;
    var lastDate = DateTime(1900);
    for (var i = 0; i < 600 && champion == null; i++) {
      await season.advance(career.id);
      if (drilled) {
        // Each of his matches since the last step goes into the drilling,
        // as `playPlayerMatch` would have recorded it.
        final n = (await ours()).length;
        for (; recorded < n; recorded++) {
          await fam.recordMatch(
            career.id,
            plan.formation,
            planKey: TeamChemistry.planKey(plan.instructions),
          );
        }
      }
      champion = await _champion(db);
      final now = (await c.read(careerRepositoryProvider).byId(career.id))!;
      if (!now.inGameDate.isAfter(lastDate) && champion == null) break;
      lastDate = now.inGameDate;
    }
    expect(champion, isNotNull, reason: 'seed $rngSeed never crowned one');

    final comps = {
      for (final r in await db.select(db.competitions).get()) r.id: r,
    };
    var w = 0;
    var d = 0;
    var l = 0;
    var gf = 0;
    var ga = 0;
    var wcStage = 0;
    var continental = false;
    for (final f in await ours()) {
      final home = f.homeNationId == _czechia;
      final us = home ? f.homeScore! : f.awayScore!;
      final them = home ? f.awayScore! : f.homeScore!;
      gf += us;
      ga += them;
      if (us > them) {
        w++;
      } else if (us < them) {
        l++;
      } else {
        d++;
      }
      final comp = comps[f.competitionId]!;
      if (comp.kind == CompetitionKind.worldCupFinals) {
        final s = _stage[f.round] ?? 1;
        if (s > wcStage) wcStage = s;
      }
      if (comp.kind == CompetitionKind.continentalFinals &&
          comp.confederation == Confederation.europe) {
        continental = true;
      }
    }
    if (champion == _czechia) wcStage = 7;
    final rankOf = {for (final n in nations) n.id: n.ranking};
    final end = (await c.read(careerRepositoryProvider).byId(career.id))!;
    return {
      'seed': rngSeed,
      'plan': plan.name,
      'w': w,
      'd': d,
      'l': l,
      'gf': gf,
      'ga': ga,
      'wcStage': wcStage,
      'euro': continental,
      'champion': champion,
      'championRank': rankOf[champion],
      'stillCzechia': end.nationId == _czechia,
    };
  } finally {
    c.dispose();
    await db.close();
  }
}

/// The World Championship winner, once its final has been played: the higher
/// score, and on a level score the shootout.
Future<int?> _champion(AppDatabase db) async {
  final finals = {
    for (final r in await db.select(db.competitions).get())
      if (r.kind == CompetitionKind.worldCupFinals) r.id,
  };
  for (final f in await db.select(db.fixtures).get()) {
    if (!finals.contains(f.competitionId) ||
        f.round != WorldCupFinals.finalRound ||
        !f.played) {
      continue;
    }
    final hs = f.homeScore! * 100 + (f.homePenalties ?? 0);
    final as = f.awayScore! * 100 + (f.awayPenalties ?? 0);
    return hs >= as ? f.homeNationId : f.awayNationId;
  }
  return null;
}

/// Reads every JSONL file under [dir] and prints one table row per
/// (mode, plan), ready for the results doc.
void _report(String dir) {
  final rows = <String, List<Map<String, dynamic>>>{};
  for (final f in Directory(dir).listSync().whereType<File>()) {
    if (!f.path.endsWith('.jsonl')) continue;
    final name = f.uri.pathSegments.last;
    final key = name.substring(0, name.lastIndexOf('-shard'));
    for (final line in f.readAsLinesSync()) {
      if (line.trim().isEmpty) continue;
      (rows[key] ??= []).add(jsonDecode(line) as Map<String, dynamic>);
    }
  }
  String pct(num n, int of) => '${(100 * n / of).toStringAsFixed(1)}%';
  final buf = StringBuffer()
    ..writeln(
      '| Mode-plan | Careers | WC qualify | Euro finals | WC KO | WC QF+ '
      '| WC won | Win | Draw | Loss | GF/g | GA/g | Goals/g | Top-8 champion '
      '| s/career |',
    )
    ..writeln('|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|');
  for (final key in rows.keys.toList()..sort()) {
    final r = rows[key]!;
    final n = r.length;
    int sum(String k) => r.fold<int>(0, (s, e) => s + (e[k] as int));
    int count(bool Function(Map<String, dynamic>) t) => r.where(t).length;
    final games = sum('w') + sum('d') + sum('l');
    buf.writeln(
      '| $key | $n '
      '| ${pct(count((e) => (e['wcStage'] as int) > 0), n)} '
      '| ${pct(count((e) => e['euro'] as bool), n)} '
      '| ${pct(count((e) => (e['wcStage'] as int) >= 2), n)} '
      '| ${pct(count((e) => (e['wcStage'] as int) >= 4), n)} '
      '| ${pct(count((e) => (e['wcStage'] as int) == 7), n)} '
      '| ${pct(sum('w'), games)} | ${pct(sum('d'), games)} '
      '| ${pct(sum('l'), games)} '
      '| ${(sum('gf') / games).toStringAsFixed(2)} '
      '| ${(sum('ga') / games).toStringAsFixed(2)} '
      '| ${((sum('gf') + sum('ga')) / games).toStringAsFixed(2)} '
      '| ${pct(count((e) => (e['championRank'] as int) <= 8), n)} '
      '| ${(sum('ms') / n / 1000).toStringAsFixed(1)} |',
    );
  }
  // The table is the point of the report run: it goes into the results doc.
  // ignore: avoid_print
  print(buf);
}
