import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/domain/services/press/y_tournaments.dart';

/// Every tournament the country plays gets talked about — not just the one
/// that happened to work.
///
/// The reported bug: "no tweets at all, only the Nations Cup, nothing for the
/// European Championship". The reading of the fixtures was right; the feed's
/// recency cap was not, and the continental championship — played two years
/// and forty matches before the World Championship — had scrolled off the
/// bottom by the time anyone looked. The shape of that bug is "one competition
/// speaks and the others silently do not", so the guard walks EVERY finals
/// competition the game runs.
void main() {
  const me = 1;
  const them = 2;
  const other = 3;
  const fourth = 4;

  /// One competition's round codes, as the app actually writes them.
  ///
  /// Built from the same configuration the calendar is, so a confederation
  /// added later is covered here the day it is added rather than the day
  /// somebody remembers this file.
  ({String name, String group, List<String> knockout}) contRounds(
    Confederation conf,
  ) {
    final cup = ContinentalCups.byConfederation[conf]!;
    final groups = cup.size ~/ cup.groupSize;
    // Mirrors SeasonCycle: a 24-team cup opens at the round of 16, a 16-team
    // cup at the quarter-finals, anything smaller at the semi-finals. A
    // Copa-style two groups of five goes straight to the quarters.
    final first = cup.groupSize >= 5
        ? 'CQF'
        : switch (groups) {
            6 => 'CR16',
            4 => 'CQF',
            _ => 'CSF',
          };
    final ladder = ['CR16', 'CQF', 'CSF', 'CFINAL'];
    return (
      name: cup.name,
      group: 'CGROUP',
      knockout: ladder.sublist(ladder.indexOf(first)),
    );
  }

  final families = <({String name, String group, List<String> knockout})>[
    (
      name: 'World Championship Finals',
      group: 'GROUP',
      knockout: ['R32', 'R16', 'QF', 'SF', 'FINAL'],
    ),
    for (final conf in Confederation.values)
      if (ContinentalCups.byConfederation.containsKey(conf)) contRounds(conf),
    (name: 'Nations Cup', group: 'NGROUP', knockout: ['NSF', 'NFINAL']),
  ];

  const competitionId = 7;
  var nextId = 100;

  Fixture fx({
    required String? round,
    required DateTime date,
    int home = me,
    int away = them,
    int? homeScore,
    int? awayScore,
    int? groupId,
    int competition = competitionId,
  }) => Fixture(
    id: nextId++,
    careerId: 1,
    competitionId: competition,
    matchday: 1,
    date: date,
    homeNationId: home,
    awayNationId: away,
    groupId: groupId,
    homeScore: homeScore,
    awayScore: awayScore,
    round: round,
    played: homeScore != null,
  );

  /// The nation's group: three games, all played, all won unless [win] says
  /// otherwise.
  List<Fixture> groupStage(String round, DateTime from, {bool win = true}) => [
    for (var i = 0; i < 3; i++)
      fx(
        round: round,
        date: from.add(Duration(days: i * 3)),
        away: [them, other, fourth][i],
        homeScore: win ? 2 : 0,
        awayScore: win ? 0 : 2,
        groupId: 1,
      ),
  ];

  List<YMilestone> read(
    List<Fixture> mine, {
    required String name,
    List<Fixture> world = const [],
  }) => YTournaments.milestones(
    nationFixtures: mine,
    worldFixtures: [...mine, ...world],
    names: {competitionId: name, 8: 'Somebody Else Cup'},
    nationId: me,
  );

  group('every finals competition speaks', () {
    for (final f in families) {
      test('${f.name}: a knockout exit is news', () {
        final start = DateTime(2058, 6, 8);
        final exit = f.knockout.first;
        final posts = read(
          [
            ...groupStage(f.group, start),
            fx(
              round: exit,
              date: start.add(const Duration(days: 12)),
              homeScore: 0,
              awayScore: 1,
            ),
          ],
          name: f.name,
        );
        expect(
          posts.map((m) => m.template),
          contains(YTemplate.eliminated),
          reason: '${f.name} went out at $exit and said nothing',
        );
        expect(posts.first.args, contains(f.name));
      });

      test('${f.name}: a trophy is news', () {
        final start = DateTime(2058, 6, 8);
        final posts = read(
          [
            ...groupStage(f.group, start),
            for (var i = 0; i < f.knockout.length; i++)
              fx(
                round: f.knockout[i],
                date: start.add(Duration(days: 12 + i * 4)),
                homeScore: 2,
                awayScore: 1,
              ),
          ],
          name: f.name,
        );
        expect(
          posts.map((m) => m.template),
          contains(YTemplate.trophy),
          reason: '${f.name} was won in silence',
        );
      });

      test('${f.name}: going out in the group is news once it is settled', () {
        final start = DateTime(2058, 6, 8);
        final posts = read(
          groupStage(f.group, start, win: false),
          name: f.name,
          // The tournament moved on without them: a knockout tie between two
          // other nations.
          world: [
            fx(
              round: f.knockout.first,
              date: start.add(const Duration(days: 12)),
              home: other,
              away: fourth,
              homeScore: 1,
              awayScore: 0,
            ),
          ],
        );
        expect(
          posts.map((m) => m.template),
          contains(YTemplate.eliminated),
          reason: '${f.name} ended at the group stage and said nothing',
        );
      });

      test('${f.name}: one that has not started yet is looked forward to', () {
        final start = DateTime(2058, 6, 8);
        final posts = read([
          for (var i = 0; i < 3; i++)
            fx(
              round: f.group,
              date: start.add(Duration(days: i * 3)),
            ),
        ], name: f.name);
        expect(
          posts.map((m) => m.template),
          contains(YTemplate.tournamentSoon),
          reason: '${f.name} is coming and nobody mentioned it',
        );
      });

      test('${f.name}: survives a cycle of match reports on top of it', () {
        // The reported bug itself. The milestone is dated at the tournament;
        // the months after it are full of results, each of which posts several
        // times. A feed capped purely by recency showed the chatter and lost
        // the tournament.
        final start = DateTime(2058, 6, 8);
        final milestones = read(
          [
            ...groupStage(f.group, start),
            fx(
              round: f.knockout.first,
              date: start.add(const Duration(days: 12)),
              homeScore: 0,
              awayScore: 1,
            ),
          ],
          name: f.name,
        );
        final posts = <YPost>[
          for (final m in milestones)
            ...YFeed.forEvent(
              template: m.template,
              args: m.args,
              date: m.date,
              key: m.key,
              nation: 'Czechia',
              seed: 11,
            ),
          // Two years of results afterwards, four posts apiece.
          for (var i = 1; i <= 200; i++)
            (
              voice: YVoice.stats,
              handle: '@s',
              displayName: 's',
              template: YTemplate.drew,
              variant: 0,
              args: const ['Norway', '1-1'],
              date: start.add(Duration(days: 20 + i * 3)),
              key: 'noise$i',
              replyTo: null,
              mood: null,
            ),
        ];
        final feed = YFeed.mostRecent(posts);
        expect(
          feed.where((p) => p.args.contains(f.name)),
          isNotEmpty,
          reason: '${f.name} was buried by the matches that came after it',
        );
      });
    }
  });

  group('a place booked', () {
    // The campaigns that GET a nation to a finals: World Championship
    // qualifying carries no round code at all, continental qualifying carries
    // 'CQ'. Each must be credited with its own family's tournament.
    for (final (label, qualRound, finals) in <(String, String?, String)>[
      ('World Championship', null, 'GROUP'),
      ('European Championship', 'CQ', 'CGROUP'),
    ]) {
      test('$label qualifying books a place at $label', () {
        const qualifyingId = 3;
        final campaign = [
          for (var i = 0; i < 4; i++)
            fx(
              round: qualRound,
              date: DateTime(2057, 3, 8).add(Duration(days: i * 30)),
              homeScore: 3,
              awayScore: 0,
              competition: qualifyingId,
            ),
        ];
        final tournament = groupStage(finals, DateTime(2058, 6, 8));
        final milestones = YTournaments.milestones(
          nationFixtures: [...campaign, ...tournament],
          worldFixtures: [...campaign, ...tournament],
          names: {qualifyingId: '$label Qualifiers', competitionId: label},
          nationId: me,
        );
        expect(
          milestones
              .where((m) => m.template == YTemplate.qualified)
              .map(
                (m) => m.args.first,
              ),
          contains(label),
          reason: 'the campaign that got them there went unmentioned',
        );
      });
    }
  });
}
