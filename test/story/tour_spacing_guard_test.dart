@Tags(['slow'])
library;

import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/domain/services/competition/tournament_calendar.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/hub/round_popup.dart';

import 'driver.dart';

const _finalsRounds = {
  'GROUP', 'R32', 'R16', 'QF', 'SF', '3RD', 'FINAL', //
  'CGROUP', 'CR16', 'CQF', 'CSF', 'C3RD', 'CFINAL',
};

/// Every finals fixture of a career (World Championship and every
/// continental championship), in insertion order.
Future<List<FixtureRow>> finalsRows(StoryDriver d) async {
  final db = d.c.read(appDatabaseProvider);
  final rows =
      await (db.select(db.fixtures)
            ..where((t) => t.careerId.equals(d.careerId))
            ..orderBy([(t) => OrderingTerm(expression: t.id)]))
          .get();
  return [
    for (final r in rows)
      if (_finalsRounds.contains(r.round)) r,
  ];
}

/// [finalsRows] as one line each: its round, date, sides and score.
Future<String> finalsDump(StoryDriver d) async =>
    (await finalsRows(d)).map(_line).join('\n');

String _line(FixtureRow r) =>
    '${r.competitionId} ${r.round} ${r.matchday} '
    '${r.date.toIso8601String()} ${r.homeNationId}-${r.awayNationId} '
    '${r.homeScore}-${r.awayScore}';

/// FNV-1a, 64-bit (stable across runs, unlike String.hashCode).
String fnv(String s) {
  var h = 0xcbf29ce484222325; // ignore: avoid_js_rounded_ints, VM-only test
  for (final c in s.codeUnits) {
    h ^= c;
    h = (h * 0x100000001b3) & 0xFFFFFFFFFFFFFFFF;
  }
  return h.toUnsigned(64).toRadixString(16);
}

/// Plays a cycle to its rollover, simulating every watched tournament in one
/// go.
Future<void> driveCycle(StoryDriver d) async {
  final season = d.c.read(seasonServiceProvider);
  for (var i = 0; i < 6000; i++) {
    final e = await d.nextEvent();
    if (e.kind == HubEventKind.cycleRollover) break;
    if (e.kind == HubEventKind.watchTournament) {
      await season.simulateTournament(d.careerId);
      continue;
    }
    await d.step();
  }
}

int _days(DateTime a, DateTime b) => DateTime.utc(
  b.year,
  b.month,
  b.day,
).difference(DateTime.utc(a.year, a.month, a.day)).inDays;

void main() {
  const sanMarino = 45;

  test(
    'an unmarked cycle keeps its finals schedule and results exactly',
    () async {
      final c = storyContainer();
      addTearDown(c.dispose);
      final d = await StoryDriver.start(
        c,
        5,
        nationId: sanMarino,
        tournamentSpacing: false,
        // An old save's cycle: the old calendar too (calendar2, merged
        // after this guard was recorded, re-schedules a new career's
        // cycle by design).
        calendar2: false,
      );
      await driveCycle(d);
      final dump = await finalsDump(d);
      // Recorded on main (1f004335) before tournament spacing existed: the
      // same seed must still give the same finals, day for day and goal for
      // goal.
      expect(dump.split('\n'), hasLength(330));
      // Re-pinned in 1.1.2: the match engine's own changes (keeper errors
      // among them) and the wonderkids no academy releases any more move the
      // scores; the schedule, day for day, is the same. Re-pinned again in
      // 1.1.4 for the goal lull and the openness blend (scores only), and
      // in 1.1.5 for the community traits (the knocks, marks and form they
      // move; every round's date checked unchanged, scores and the ties they
      // decide moved), and in 1.1.3 for the secondary and learned positions
      // (some background elevens field a man where he also plays: 29 of the
      // 329 lines move, every round's date unchanged, 25 of them knockout
      // ties with another side through).
      expect(fnv(dump), '-5adcc6648157a5b');
    },
    timeout: const Timeout(Duration(minutes: 20)),
  );

  test(
    'a World Championship on the new spacing: rest, staggered groups and one '
    'popup per matchday',
    () async {
      final c = storyContainer();
      addTearDown(c.dispose);
      // San Marino reaches no finals, so every one of them is watched.
      final d = await StoryDriver.start(c, 5, nationId: sanMarino);
      final comp = c.read(competitionRepositoryProvider);
      expect(
        await comp.hasWatchedDraw(d.careerId, 0, TournamentCalendar.markerKind),
        isTrue,
      );
      final season = c.read(seasonServiceProvider);
      // Each popup that showed something, by competition and stage.
      final shown =
          <({String competition, String stage, int fixtures, int first})>[];
      var waiting = 0;
      for (var i = 0; i < 6000; i++) {
        final e = await d.nextEvent();
        if (e.kind == HubEventKind.cycleRollover) break;
        if (e.kind != HubEventKind.watchTournament) {
          await d.step();
          continue;
        }
        await season.advance(d.careerId);
        c
          ..invalidate(hubDataProvider)
          ..invalidate(latestRoundPopupProvider);
        final popup = await c.read(
          latestRoundPopupProvider(d.careerId).future,
        );
        if (popup == null) continue;
        if (popup.fixtures.isEmpty) {
          waiting++;
          continue;
        }
        final entry = (
          competition: popup.competition,
          stage: popup.stage,
          fixtures: popup.fixtures.length,
          first: popup.fixtures.first.id,
        );
        // A step that played nothing of the watched cup re-reads the same
        // day; count each summary once.
        if (shown.isEmpty || shown.last != entry) shown.add(entry);
      }

      final rows = await finalsRows(d);
      final wc = rows.where((r) => !r.round!.startsWith('C')).toList();
      expect(wc.where((r) => r.round == 'FINAL'), hasLength(1));
      final opener = wc
          .map((r) => r.date)
          .reduce((a, b) => a.isBefore(b) ? a : b);
      expect(opener, DateTime(2030, 6, 11));
      final fin = wc.singleWhere((r) => r.round == 'FINAL');
      expect(fin.date, DateTime(2030, 7, 19));
      expect(wc.every((r) => r.played), isTrue);

      // Every team in every finals rests at least four days (three before
      // the third-place play-off).
      final byComp = <int, List<FixtureRow>>{};
      for (final r in rows) {
        (byComp[r.competitionId] ??= []).add(r);
      }
      for (final games in byComp.values) {
        final byTeam = <int, List<FixtureRow>>{};
        for (final r in games) {
          (byTeam[r.homeNationId] ??= []).add(r);
          (byTeam[r.awayNationId] ??= []).add(r);
        }
        for (final e in byTeam.entries) {
          final mine = e.value..sort((a, b) => a.date.compareTo(b.date));
          for (var i = 1; i < mine.length; i++) {
            expect(
              _days(mine[i - 1].date, mine[i].date),
              greaterThanOrEqualTo(
                mine[i].round == '3RD'
                    ? TournamentCalendar.thirdPlaceRest
                    : TournamentCalendar.minRest,
              ),
              reason:
                  'team ${e.key}: ${mine[i - 1].round} ${mine[i - 1].date} '
                  'then ${mine[i].round} ${mine[i].date}',
            );
          }
        }
        // Groups are staggered: a matchday is played over several days.
        final group = games.where((r) => r.groupId != null).toList();
        if (group.map((r) => r.groupId).toSet().length > 2) {
          expect(
            group.where((r) => r.matchday == 1).map((r) => r.date).toSet(),
            hasLength(greaterThan(1)),
          );
        }
      }

      // One summary per World Championship group matchday, with all 24 of
      // its games. Each watched step plays a whole matchday, so no step
      // shows nothing (a tester pressed on through empty days to see one).
      final wcGroups = shown
          .where(
            (s) => s.competition == 'World Cup' && s.stage == 'Group Stage',
          )
          .toList();
      expect(wcGroups, hasLength(3));
      expect(wcGroups.every((s) => s.fixtures == 24), isTrue);
      expect(waiting, 0);
      expect(shown.last.stage, 'Final');
    },
    timeout: const Timeout(Duration(minutes: 20)),
  );
}
