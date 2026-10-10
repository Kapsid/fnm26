import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/features/achievements/achievement_providers.dart';
import 'package:fnm/features/achievements/challenge_providers.dart';
import 'package:fnm/features/career/career_summary_providers.dart';
import 'package:fnm/features/career/manager_history_providers.dart';
import 'package:fnm/features/federation/federation_service.dart';
import 'package:fnm/features/federation/naturalization_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/manager/manager_providers.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/nations/nation_vitrine_providers.dart';
import 'package:fnm/features/records/all_time_records_providers.dart';
import 'package:fnm/features/records/head_to_head_providers.dart';
import 'package:fnm/features/records/legends_providers.dart';
import 'package:fnm/features/records/record_book_providers.dart';
import 'package:fnm/features/records/rivalry_providers.dart';
import 'package:fnm/features/results/results_providers.dart';
import 'package:fnm/features/squad/training_camp_providers.dart';
import 'package:fnm/features/squad/youth_providers.dart';
import 'package:fnm/features/stats/stats_providers.dart';
import 'package:fnm/features/tournaments/continental_clash_providers.dart';
import 'package:fnm/features/tournaments/continental_detail_providers.dart';
import 'package:fnm/features/tournaments/cup_detail_providers.dart';
import 'package:fnm/features/tournaments/intercontinental_playoff_providers.dart';
import 'package:fnm/features/tournaments/nations_cup_providers.dart';
import 'package:fnm/features/tournaments/tournaments_providers.dart';
import 'package:fnm/features/tournaments/wc_host_theme.dart';
import 'package:fnm/features/y/y_providers.dart';

import '../helpers/competition_fixtures.dart';
import '../helpers/seeded_save.dart';

typedef _Views = Map<String, ProviderListenable<Future<Object?>>>;

/// The competition screens' data (stage 3).
_Views _competitionViews(SeededSave save) {
  final id = save.careerId;
  return {
    'tournaments': tournamentsOverviewProvider(id).future,
    'cup': cupDetailProvider(id).future,
    'continental': continentalDetailProvider((
      careerId: id,
      confederation: Confederation.europe,
    )).future,
    'nationsCup': nationsCupProvider((
      careerId: id,
      confederation: null,
    )).future,
    'clash': continentalClashProvider(id).future,
    'playoff': intercontinentalPlayoffProvider(id).future,
    'results': resultsProvider(id).future,
    'wcHost': wcHostThemeProvider(id).future,
    'continentalHost': continentalHostThemeProvider(id).future,
    'vitrine': nationVitrineProvider((
      careerId: id,
      nationId: save.nationId,
    )).future,
  };
}

/// The federation, manager and Y screens' data (stage 4).
_Views _federationViews(SeededSave save) {
  final id = save.careerId;
  return {
    'finances': financeViewProvider(id).future,
    'funds': federationFundsProvider(id).future,
    'manager': managerViewProvider(id).future,
    'youth': youthPyramidProvider(id).future,
    'shortlist': youthShortlistProvider(id).future,
    'y': yFeedProvider(id).future,
    'naturalization': pendingNaturalizationProvider(id).future,
    'camp': trainingCampPlanProvider(id).future,
  };
}

/// The history and career screens' data (stage 5). The head-to-head pair is
/// the manager's nation against the best-ranked other one.
_Views _historyViews(SeededSave save) {
  final id = save.careerId;
  final pair = (
    careerId: id,
    nationA: save.nationId,
    nationB: fieldOf(save.nationId, 2)[1].id,
  );
  return {
    'recordBook': recordBookProvider(id).future,
    'rivalry': rivalryProvider(id).future,
    'legends': legendsProvider(id).future,
    'allTime': allTimeRecordsProvider(id).future,
    'myH2h': myHeadToHeadsProvider(id).future,
    'h2h': headToHeadProvider(pair).future,
    'meetings': h2hMeetingsProvider(pair).future,
    'achievements': achievementsViewProvider(id).future,
    'challenges': challengesViewProvider(id).future,
    'summary': careerSummaryProvider(id).future,
    'managerHistory': managerHistoryProvider(id).future,
    'careerStats': careerStatsProvider(id).future,
    'teamOverall': teamOverallHistoryProvider(id).future,
  };
}

/// Listens to every one of [views] as a screen on show would, runs [step],
/// and expects each to hand out a fresh read afterwards.
Future<void> _expectRefreshedBy(
  WidgetTester tester,
  SeededSave save,
  _Views views,
  Future<void> Function() step,
) async {
  final c = save.container;
  // The listeners are the screens on show. They are opened inside the real
  // async zone, so the reads they start are not stranded on fake time.
  final subs = <String, ProviderSubscription<Future<Object?>>>{};
  addTearDown(() {
    for (final s in subs.values) {
      s.close();
    }
  });
  final before = <String, Future<Object?>>{};
  await tester.runAsync(() async {
    for (final e in views.entries) {
      subs[e.key] = c.listen<Future<Object?>>(e.value, (_, _) {});
      before[e.key] = subs[e.key]!.read();
      await before[e.key];
      // Sanity: with no step in between, the same read comes back.
      expect(
        identical(subs[e.key]!.read(), before[e.key]),
        isTrue,
        reason: e.key,
      );
    }
    await step();
    for (final e in subs.entries) {
      final after = e.value.read();
      expect(
        identical(after, before[e.key]),
        isFalse,
        reason: '${e.key} kept its pre-step data',
      );
      // Let the fresh read finish inside the real-async zone, so no
      // database work is left pending when the test ends.
      await after;
    }
  });
}

/// Review Focus 3 (stage 3), 1 (stage 4) and 1 (stage 5). A tablet's top bar runs the sim
/// while a screen is on show, and that screen's provider is kept alive by
/// being watched. Every way a step is committed must hand every one of them
/// a fresh read.
void main() {
  testWidgets('a step refreshes every screen a tablet keeps on show', (
    tester,
  ) async {
    final save = await seedSave(tester);
    await _expectRefreshedBy(
      tester,
      save,
      {
        ..._competitionViews(save),
        ..._federationViews(save),
        ..._historyViews(save),
      },
      () => save.container.read(seasonServiceProvider).advance(save.careerId),
    );
  });

  testWidgets("so does committing the manager's own match", (tester) async {
    final save = await seedSave(tester);
    final c = save.container;
    late MatchPreview preview;
    await tester.runAsync(() async {
      // Held, as the match screen holds it between whistle and commit.
      final held = c.listen(
        matchPreviewProvider(save.careerId).future,
        (_, _) {},
      );
      addTearDown(held.close);
      final p = await held.read();
      expect(p, isNotNull, reason: 'the seeded save has a next match');
      preview = p!;
    });
    await _expectRefreshedBy(
      tester,
      save,
      {
        ..._competitionViews(save),
        ..._federationViews(save),
        ..._historyViews(save),
      },
      () => c
          .read(seasonServiceProvider)
          .playPlayerMatch(save.careerId, preview.fixture, preview.result),
    );
  });

  // Skipping to the champion simulates the rest of a cycle, far too long for
  // the suite, so its cascade is checked in the source: it must end on the
  // same refresh as the other two paths.
  test('skipping to the champion runs the same refresh', () {
    final src = File('lib/features/hub/hub_providers.dart').readAsStringSync();
    final start = src.indexOf('Future<void> _skipToChampion(');
    expect(start, isNonNegative);
    final end = src.indexOf('\n  Future<', start + 1);
    final body = src.substring(start, end < 0 ? src.length : end);
    expect(body, contains('_invalidateCompetitionViews();'));
    final cascade = src.substring(
      src.indexOf('void _invalidateCompetitionViews()'),
    );
    final cascadeBody = cascade.substring(0, cascade.indexOf('\n  }'));
    expect(cascadeBody, contains('_invalidateFederationViews();'));
    expect(cascadeBody, contains('_invalidateHistoryViews();'));
  });
}
