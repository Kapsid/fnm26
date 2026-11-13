import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/competition/tournament_calendar.dart';
import 'package:fnm/domain/services/squad/nomination.dart';

/// One format to play through the calendar: its field, its group size, the
/// first knockout round and how it is paired, and whether it has a
/// third-place play-off.
typedef _Format = ({
  String name,
  int teams,
  int perGroup,
  String prefix,
  List<String> ladder,
  List<(int, int)> Function(List<List<GroupStanding>>) firstPairs,
  bool thirdPlace,
});

final _formats = <_Format>[
  (
    name: 'World Championship 48',
    teams: 48,
    perGroup: 4,
    prefix: '',
    ladder: ['R32', 'R16', 'QF', 'SF'],
    firstPairs: WorldCupFinals.roundOf32,
    thirdPlace: true,
  ),
  (
    name: '24-team (EURO, AFCON, Asian)',
    teams: 24,
    perGroup: 4,
    prefix: 'C',
    ladder: ['R16', 'QF', 'SF'],
    firstPairs: (s) =>
        WorldCupFinals.knockoutWithThirds(s, WorldCupFinals.bestThirdsFor(6)),
    thirdPlace: false,
  ),
  (
    name: '16-team (North America)',
    teams: 16,
    perGroup: 4,
    prefix: 'C',
    ladder: ['QF', 'SF'],
    firstPairs: WorldCupFinals.knockoutFromGroups,
    thirdPlace: false,
  ),
  (
    name: '10-team (South America)',
    teams: 10,
    perGroup: 5,
    prefix: 'C',
    ladder: ['QF', 'SF'],
    firstPairs: WorldCupFinals.copaQuarters,
    thirdPlace: false,
  ),
  (
    name: '8-team (Oceania)',
    teams: 8,
    perGroup: 4,
    prefix: 'C',
    ladder: ['SF'],
    firstPairs: WorldCupFinals.knockoutFromGroups,
    thirdPlace: false,
  ),
];

/// A whole tournament of [format] dated by the calendar, with random results.
List<Fixture> _play(_Format format, int seed, DateTime opener) {
  final rng = Random(seed);
  final draw = WorldCupFinals.drawGroups(
    qualifierIds: [for (var i = 1; i <= format.teams; i++) i],
    rankingById: {for (var i = 1; i <= format.teams; i++) i: i},
    rngSeed: seed,
    perGroup: format.perGroup,
  );
  final template = TournamentCalendar.templateFor(
    groups: draw.groups.length,
    groupSize: format.perGroup,
  );
  var id = 0;
  final all = <Fixture>[];
  final standings = <List<GroupStanding>>[];
  for (final (gi, g) in draw.groups.indexed) {
    final games = [
      for (final (md, home, away) in g.fixtures)
        Fixture(
          id: ++id,
          careerId: 1,
          competitionId: 1,
          groupId: gi,
          matchday: md,
          date: TournamentCalendar.groupDate(
            opener: opener,
            template: template,
            groupIndex: gi,
            matchday: md,
          ),
          homeNationId: home,
          awayNationId: away,
          homeScore: rng.nextInt(4),
          awayScore: rng.nextInt(4),
          played: true,
          round: '${format.prefix}GROUP',
        ),
    ];
    all.addAll(games);
    standings.add(GroupStanding.table(g.nationIds, games));
  }

  List<Fixture> addRound(String round, List<(int, int)> pairings) {
    final last = <int, DateTime>{};
    for (final f in all) {
      for (final t in [f.homeNationId, f.awayNationId]) {
        if (last[t] == null || f.date.isAfter(last[t]!)) last[t] = f.date;
      }
    }
    final latest = all
        .map((f) => f.date)
        .reduce((a, b) => a.isAfter(b) ? a : b);
    final dates = TournamentCalendar.knockoutDates(
      opener: opener,
      template: template,
      round: '${format.prefix}$round',
      pairings: pairings,
      lastPlayed: last,
      notBefore: DateTime(latest.year, latest.month, latest.day + 1),
    );
    final ties = [
      for (final (i, (home, away)) in pairings.indexed)
        Fixture(
          id: ++id,
          careerId: 1,
          competitionId: 1,
          matchday: 99,
          date: dates[i],
          homeNationId: home,
          awayNationId: away,
          // Never level: a knockout always has a winner.
          homeScore: rng.nextBool() ? 1 : 0,
          awayScore: 0,
          played: true,
          round: '${format.prefix}$round',
        ),
    ];
    // Fix up the loser's score so the stored winner is random.
    for (var i = 0; i < ties.length; i++) {
      if (ties[i].homeScore == 0) ties[i] = ties[i].copyWith(awayScore: 1);
    }
    all.addAll(ties);
    return ties;
  }

  int winner(Fixture f) =>
      f.homeScore! > f.awayScore! ? f.homeNationId : f.awayNationId;
  int loser(Fixture f) =>
      f.homeScore! > f.awayScore! ? f.awayNationId : f.homeNationId;

  var ties = addRound(format.ladder.first, format.firstPairs(standings));
  for (final round in format.ladder.skip(1)) {
    ties = addRound(
      round,
      WorldCupFinals.pairWinners(ties.map(winner).toList()),
    );
  }
  if (format.thirdPlace) {
    addRound('3RD', WorldCupFinals.pairWinners(ties.map(loser).toList()));
  }
  addRound('FINAL', WorldCupFinals.pairWinners(ties.map(winner).toList()));
  return all;
}

int _days(DateTime a, DateTime b) => DateTime.utc(
  b.year,
  b.month,
  b.day,
).difference(DateTime.utc(a.year, a.month, a.day)).inDays;

void main() {
  final opener = DateTime(2030, 6, 11);

  group('TournamentCalendar templates', () {
    test('each real format has its own template', () {
      expect(
        TournamentCalendar.templateFor(groups: 12, groupSize: 4),
        TournamentCalendar.worldChampionship,
      );
      expect(
        TournamentCalendar.templateFor(groups: 6, groupSize: 4),
        TournamentCalendar.twentyFour,
      );
      expect(
        TournamentCalendar.templateFor(groups: 4, groupSize: 4),
        TournamentCalendar.sixteen,
      );
      expect(
        TournamentCalendar.templateFor(groups: 2, groupSize: 5),
        TournamentCalendar.tenCopa,
      );
      expect(
        TournamentCalendar.templateFor(groups: 2, groupSize: 4),
        TournamentCalendar.eight,
      );
    });

    test('the World Championship runs 11 June to 19 July, as in 2026', () {
      final all = _play(_formats.first, 1, opener);
      final group = all.where((f) => f.round == 'GROUP').map((f) => f.date);
      expect(
        group.reduce((a, b) => a.isBefore(b) ? a : b),
        DateTime(2030, 6, 11),
      );
      expect(
        group.reduce((a, b) => a.isAfter(b) ? a : b),
        DateTime(2030, 6, 27),
      );
      expect(
        all.singleWhere((f) => f.round == 'FINAL').date,
        DateTime(2030, 7, 19),
      );
      expect(
        all.singleWhere((f) => f.round == '3RD').date,
        DateTime(2030, 7, 18),
      );
      final r32 = all.where((f) => f.round == 'R32').map((f) => f.date.day);
      expect(r32.every((d) => d >= 29 || d <= 3), isTrue);
    });

    test('a EURO opening on 14 June ends on 14 July', () {
      final all = _play(_formats[1], 3, DateTime(2028, 6, 14));
      expect(
        all.singleWhere((f) => f.round == 'CFINAL').date,
        DateTime(2028, 7, 14),
      );
    });

    test('an unknown shape falls back to four-day gaps', () {
      final t = TournamentCalendar.templateFor(groups: 3, groupSize: 4);
      expect(t.gaps, [4]);
      expect(t.knockouts, isEmpty);
    });
  });

  for (final format in _formats) {
    group(format.name, () {
      test(
        'groups keep one day slot, two groups a day, last matchday together',
        () {
          for (var seed = 1; seed <= 20; seed++) {
            final all = _play(format, seed, opener);
            final group = all.where((f) => f.groupId != null).toList();
            final groups = group.map((f) => f.groupId!).toSet();
            // Each group's matchday is one day, and the slot (day of MD1 from
            // the opener) is the group's for every matchday.
            for (final g in groups) {
              final mine = group.where((f) => f.groupId == g).toList();
              final mds = mine.map((f) => f.matchday).toSet();
              for (final md in mds) {
                expect(
                  mine
                      .where((f) => f.matchday == md)
                      .map((f) => f.date)
                      .toSet(),
                  hasLength(1),
                  reason: 'group $g matchday $md on one day',
                );
              }
              expect(
                _days(opener, mine.firstWhere((f) => f.matchday == 1).date),
                g ~/ 2,
              );
            }
            // Not every group plays on the same day (when there are more than
            // two), and no more than two groups share a matchday's day.
            for (final md in group.map((f) => f.matchday).toSet()) {
              final byDay = <DateTime, Set<int>>{};
              for (final f in group.where((f) => f.matchday == md)) {
                (byDay[f.date] ??= {}).add(f.groupId!);
              }
              expect(byDay.values.every((s) => s.length <= 2), isTrue);
              expect(byDay.length, (groups.length + 1) ~/ 2);
            }
          }
        },
      );

      test('every team rests at least four days, the knockouts in their '
          'windows', () {
        final template = TournamentCalendar.templateFor(
          groups: format.teams ~/ format.perGroup,
          groupSize: format.perGroup,
        );
        for (var seed = 1; seed <= 60; seed++) {
          final all = _play(format, seed, opener);
          final byTeam = <int, List<Fixture>>{};
          for (final f in all) {
            (byTeam[f.homeNationId] ??= []).add(f);
            (byTeam[f.awayNationId] ??= []).add(f);
          }
          for (final e in byTeam.entries) {
            final games = e.value..sort((a, b) => a.date.compareTo(b.date));
            for (var i = 1; i < games.length; i++) {
              final rest = _days(games[i - 1].date, games[i].date);
              final min = games[i].round == '3RD'
                  ? TournamentCalendar.thirdPlaceRest
                  : TournamentCalendar.minRest;
              expect(
                rest,
                greaterThanOrEqualTo(min),
                reason:
                    'seed $seed team ${e.key}: ${games[i - 1].round} '
                    '${games[i - 1].date} then ${games[i].round} '
                    '${games[i].date}',
              );
            }
          }
          // Each knockout tie inside its round's window.
          for (final f in all.where((f) => f.matchday == 99)) {
            final key = f.round!.replaceFirst(RegExp('^C'), '');
            final (first, last) = template.knockouts[key]!;
            final day = _days(opener, f.date);
            expect(
              day,
              inInclusiveRange(first, last),
              reason: 'seed $seed ${f.round} on day $day',
            );
          }
          // The final closes the tournament on its own day.
          final fin = all.singleWhere((f) => f.round!.endsWith('FINAL'));
          expect(
            all.where((f) => f != fin).every((f) => f.date.isBefore(fin.date)),
            isTrue,
          );
        }
      });
    });
  }

  test('a tie is moved past its window rather than shorten a rest', () {
    final dates = TournamentCalendar.knockoutDates(
      opener: opener,
      template: TournamentCalendar.twentyFour,
      round: 'CQF',
      pairings: const [(1, 2), (3, 4)],
      lastPlayed: {1: DateTime(2030, 7, 10), 4: DateTime(2030, 6, 20)},
      notBefore: DateTime(2030, 6, 30),
    );
    expect(dates[0], DateTime(2030, 7, 14));
    // The early tie takes the first window day (+21 = 2 July).
    expect(dates[1], DateTime(2030, 7, 2));
  });

  test('a tournament crossing June into July is one call-up window', () {
    // One nation's whole run, from the opener to the final.
    final all = _play(_formats.first, 7, opener);
    final fin = all.singleWhere((f) => f.round == 'FINAL');
    final team = fin.homeNationId;
    final mine =
        all
            .where((f) => f.homeNationId == team || f.awayNationId == team)
            .toList()
          ..sort((a, b) => a.date.compareTo(b.date));
    expect(mine.first.date.month, 6);
    expect(mine.last.date.month, 7);
    for (var i = 0; i < mine.length; i++) {
      expect(
        Nomination.isPeriodStart(mine[i], i == 0 ? null : mine[i - 1]),
        i == 0,
        reason: '${mine[i].round} on ${mine[i].date}',
      );
    }
  });

  test('a warm-up six days before the opener is the same camp for a side '
      'whose group opens last', () {
    final t = TournamentCalendar.worldChampionship;
    final ownFirst = TournamentCalendar.groupDate(
      opener: opener,
      template: t,
      groupIndex: 11,
      matchday: 1,
    );
    expect(ownFirst, DateTime(2030, 6, 16));
    final warmUp = Fixture(
      id: 1,
      careerId: 1,
      competitionId: 2,
      matchday: 1,
      date: DateTime(2030, 6, 5),
      homeNationId: 1,
      awayNationId: 2,
      round: 'FRIENDLY',
    );
    final first = Fixture(
      id: 2,
      careerId: 1,
      competitionId: 1,
      matchday: 1,
      date: ownFirst,
      homeNationId: 1,
      awayNationId: 3,
      round: 'GROUP',
    );
    expect(Nomination.isPeriodStart(first, warmUp), isFalse);
  });
}
