import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/campaign/campaigns.dart';
import 'package:fnm/features/campaign/campaign_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/ranking/world_ranking_providers.dart';

import 'driver.dart';

/// Campaign calibration lab: plays each campaign on autopilot LAB_RUNS times,
/// each run with its own match salt, and stops at the verdict. Prints the
/// stars per run and the distribution. Not part of the suite: without
/// LAB_RUNS it plays nothing and skips, so a plain `flutter test` does not
/// sit through dozens of autopilot careers. The calibration used LAB_RUNS=40.
/// LAB_CAMPAIGNS=transplant,grudge picks the campaigns. A campaign longer
/// than one cycle plays them all: the driver rolls it over, unmoved, as the
/// hub would.
///
/// Target (spec "Calibration"): one star or more in roughly 20-50% of runs,
/// three stars under 10%. Young Finns (medium, three cycles) aims higher on
/// the first star: autopilot should usually reach a World Championship at
/// least once, and rarely win one.
/// LAB_CAMPAIGNS=youngFinns runs it alone (three cycles a run, so slow).
/// A Greenland Century (hard, 25 cycles): qualify for a European
/// Championship, then a World Championship, then win either. A run is a
/// century long (about half an hour a run), so LAB_MAX_CYCLES=n stops each
/// run after n cycles for a per-cycle estimate, and LAB_GREENLAND_FACTOR
/// replays Greenland's squad at another attribute factor and LAB_ENGAGED=1
/// plays an engaged manager (both driver.dart). Its strength is Greenland's
/// attribute factor (lib/data/seed/dormant_seed.dart).
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final runs = int.parse(Platform.environment['LAB_RUNS'] ?? '0');
  final only = Platform.environment['LAB_CAMPAIGNS']?.split(',').toSet();
  final maxCycles = int.tryParse(Platform.environment['LAB_MAX_CYCLES'] ?? '');
  final defs = [
    for (final d in Campaigns.all)
      if (only == null || only.contains(d.id)) d,
  ];

  for (final def in defs) {
    final stars = <int>[];
    final watch = Stopwatch();
    for (var i = 0; i < runs; i++) {
      test('${def.id} run $i', () async {
        watch.start();
        final run = Stopwatch()..start();
        // Salt 0 is the bare fixture seed; start at 1 so every run is salted.
        final c = storyContainer(null, i + 1);
        addTearDown(c.dispose);
        final d = await StoryDriver.startCampaign(c, def);
        CampaignProgress? verdict;
        // The nation's place among Europe's sides in the world ranking, and
        // its squad rating, at the end of every cycle.
        final euroRanks = <int>[];
        final ratings = <int>[];
        d.beforeEvent = (e) async {
          if (e.kind == HubEventKind.cycleRollover) {
            c
              ..invalidate(worldRankingProvider(d.careerId))
              ..invalidate(hubDataProvider(d.careerId));
            final r = (await c.read(worldRankingProvider(d.careerId).future))!;
            final europe = [
              for (final n in r.nations)
                if (n.confederation == Confederation.europe) n.id,
            ];
            euroRanks.add(europe.indexOf(def.nationId) + 1);
            ratings.add(
              (await c.read(hubDataProvider(d.careerId).future))!.squadRating,
            );
          }
          if (e.kind != HubEventKind.campaignVerdict) return;
          c.invalidate(campaignProgressProvider(d.careerId));
          verdict = await c.read(campaignProgressProvider(d.careerId).future);
        };
        var steps = 0;
        while (verdict == null && await d.step()) {
          if (++steps > 4000 * def.cycles) throw StateError('runaway');
          // LAB_MAX_CYCLES: stop once that many cycles are played, for a
          // per-cycle estimate of a long campaign.
          if (maxCycles != null &&
              (await c.read(careerRepositoryProvider).byId(d.careerId))!
                      .cyclePointer >=
                  maxCycles) {
            c.invalidate(campaignProgressProvider(d.careerId));
            verdict = await c.read(
              campaignProgressProvider(d.careerId).future,
            );
          }
        }
        final v = verdict;
        if (v == null) throw StateError('no verdict');
        stars.add(v.stars);
        watch.stop();
        // ignore: avoid_print
        print(
          'LAB ${def.id} run=$i stars=${v.stars} ordinal=${v.ordinal} '
          'pos=${v.myPosition} rivalPos=${v.rivalPosition} '
          'gdGap=${v.goalDifferenceGap} '
          'rivalWins=${v.rivalWins}/${v.rivalMatchesPlayed} '
          'beaten=${v.rivalsBeaten.toList()..sort()} '
          'cups=${v.cycleRuns.map((r) => r.ordinal).toList()} '
          'worlds=${v.worldRuns.map((r) => r.ordinal).toList()} '
          'euroRank=$euroRanks rating=$ratings '
          '${run.elapsed.inSeconds}s',
        );
      }, timeout: Timeout(Duration(minutes: 10 * def.cycles)));
    }
    test('${def.id} distribution', () {
      final n = stars.length;
      String pct(int k) => n == 0 ? '-' : '${(100 * k / n).round()}%';
      final by = [
        for (var s = 0; s <= 3; s++) stars.where((x) => x == s).length,
      ];
      final success = n - by[0];
      // ignore: avoid_print
      print(
        'LAB ${def.id} DIST n=$n 0*=${by[0]} 1*=${by[1]} 2*=${by[2]} '
        '3*=${by[3]} | 1+ ${pct(success)} 3* ${pct(by[3])} '
        '| wall ${watch.elapsed.inSeconds}s',
      );
    }, skip: runs == 0 ? 'set LAB_RUNS to run the campaign lab' : false);
  }
}
