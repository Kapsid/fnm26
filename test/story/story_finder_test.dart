import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/match/match_providers.dart';

import '../helpers/test_database.dart';

/// Marketing: plays England careers on several world seeds and prints each
/// one's story beats. Not part of the suite.
const int england = 14;
const Set<int> rivals = {20, 46, 56, 18, 58, 26}; // GER SCO ARG FRA BRA ITA

void main() {
  final nations =
      (jsonDecode(File('assets/data/nations.json').readAsStringSync()) as List)
          .map((e) => Nation.fromJson(e as Map<String, Object?>))
          .toList();
  final players =
      (jsonDecode(File('assets/data/players.json').readAsStringSync()) as List)
          .map((e) => Player.fromJson(e as Map<String, Object?>))
          .toList();
  final byId = {for (final n in nations) n.id: n};
  final from = int.parse(Platform.environment['SEED_FROM'] ?? '1');
  final count = int.parse(Platform.environment['SEED_COUNT'] ?? '1');
  final cycles = int.parse(Platform.environment['CYCLES'] ?? '2');

  for (var s = from; s < from + count; s++) {
    test('seed $s', () async {
      final db = createTestDatabase();
      final c = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          premiumUnlockedProvider.overrideWith((ref) => true),
          matchAttemptSaltProvider.overrideWithValue(() => 0),
          seedSourceProvider.overrideWithValue(
            InMemorySeedSource(nationList: nations, playerList: players),
          ),
        ],
      );
      addTearDown(c.dispose);
      addTearDown(db.close);
      await c.read(seedLoaderProvider).ensureSeeded();
      final career = (await c
              .read(careerServiceProvider)
              .create(nationId: england, managerName: 'M', rngSeed: s))
          .valueOrNull!;
      final season = c.read(seasonServiceProvider);
      final out = StringBuffer('=== SEED $s\n');
      for (var cy = 0; cy < cycles; cy++) {
        var last = DateTime(1900);
        int? champ;
        for (var i = 0; i < 500; i++) {
          await season.advance(career.id);
          final hub = await c.read(hubDataProvider(career.id).future);
          champ = hub!.championNationId;
          if (champ != null) break;
          if (!hub.career.inGameDate.isAfter(last)) break;
          last = hub.career.inGameDate;
        }
        final comp = c.read(competitionRepositoryProvider);
        final fx = (await comp.fixturesForNation(career.id, england))
            .where((f) => f.hasResult)
            .toList()
          ..sort((a, b) => a.date.compareTo(b.date));
        for (final f in fx) {
          if (f.date.isBefore(last.subtract(const Duration(days: 365 * 4)))) {
            continue;
          }
          final home = f.homeNationId == england;
          final opp = byId[home ? f.awayNationId : f.homeNationId]!;
          final gf = home ? f.homeScore! : f.awayScore!;
          final ga = home ? f.awayScore! : f.homeScore!;
          final pens = f.wentToShootout
              ? ' p${home ? f.homePenalties : f.awayPenalties}-${home ? f.awayPenalties : f.homePenalties}'
              : '';
          final tag = [
            if (gf < ga && opp.ranking > 30) 'UPSET',
            if (rivals.contains(opp.id)) 'RIVAL',
          ].join(' ');
          out.writeln(
            '${f.date.toIso8601String().substring(0, 10)} ${f.round ?? '-'} '
            '${home ? 'H' : 'A'} ${opp.name}(#${opp.ranking}) $gf-$ga$pens $tag',
          );
        }
        out.writeln('-- cycle ${cy + 1} champion: ${byId[champ]?.name}');
        for (final h in (await comp.honours(career.id)).where(
          (h) => h.year >= 2026,
        )) {
          out.writeln('   honour ${h.year} ${h.competition}: '
              '${byId[h.championId]?.name}');
        }
        if (cy + 1 < cycles) await season.startNextCycle(career.id);
      }
      // ignore: avoid_print
      print(out);
    }, timeout: const Timeout(Duration(minutes: 20)));
  }
}
