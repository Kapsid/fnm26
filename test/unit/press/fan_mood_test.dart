import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/federation/national_stadiums.dart';
import 'package:fnm/domain/services/match/attendance.dart';
import 'package:fnm/domain/services/press/fan_mood.dart';
import 'package:fnm/domain/services/press/y_feed.dart';

/// The stands: how a run of results becomes a mood, what the mood does to the
/// crowd and the gate, and when it takes to Y.
void main() {
  final start = DateTime(2030, 3, 1);

  /// [n] results a week apart, oldest first, each [scored]-[conceded]
  /// against a side at [theirRank] (we are 40th).
  List<FanResult> run(
    int n, {
    required int scored,
    required int conceded,
    int theirRank = 40,
    bool competitive = true,
    int from = 0,
  }) => [
    for (var i = 0; i < n; i++)
      (
        nationRank: 40,
        opponentRank: theirRank,
        scored: scored,
        conceded: conceded,
        competitive: competitive,
        date: start.add(Duration(days: (from + i) * 7)),
        shootoutWon: null,
      ),
  ];

  FanMoodReading moodOf(List<FanResult> results, {List<FanEvent>? events}) =>
      FanMood.of(
        results: results,
        asOf: results.isEmpty ? start : results.last.date,
        events: events ?? const [],
      );

  group('mood from a run of results', () {
    test('no results is calm, exactly neutral', () {
      final m = moodOf(const []);
      expect(m.score, FanMood.neutral);
      expect(m.band, FanMoodBand.neutral);
      expect(FanMood.fillShift(m.score), 0);
    });

    test('one defeat by an equal does not decide it', () {
      final m = moodOf(run(1, scored: 0, conceded: 1));
      expect(m.band, isNot(FanMoodBand.furious));
      expect(m.score, lessThan(FanMood.neutral));
    });

    test('a losing run turns the stands furious', () {
      final m = moodOf(run(5, scored: 0, conceded: 2));
      expect(m.band, FanMoodBand.furious);
      expect(m.lossRun, 5);
    });

    test('a winning run over equals makes them euphoric', () {
      final m = moodOf(run(6, scored: 2, conceded: 0));
      expect(m.band, FanMoodBand.euphoric);
      expect(m.winRun, 6);
    });

    test('a defeat by a giant hurts less than one by a minnow', () {
      final giant = moodOf(run(1, scored: 0, conceded: 1, theirRank: 2));
      final minnow = moodOf(run(1, scored: 0, conceded: 1, theirRank: 150));
      expect(giant.score, greaterThan(minnow.score));
    });

    test('a friendly counts for less than a competitive match', () {
      final real = moodOf(run(3, scored: 0, conceded: 2));
      final friendly = moodOf(
        run(3, scored: 0, conceded: 2, competitive: false),
      );
      expect(friendly.score, greaterThan(real.score));
    });

    test('a streak is worse than the same defeats scattered', () {
      final scattered = moodOf([
        ...run(1, scored: 0, conceded: 1),
        ...run(1, scored: 1, conceded: 0, from: 1),
        ...run(1, scored: 0, conceded: 1, from: 2),
        ...run(1, scored: 1, conceded: 0, from: 3),
        ...run(1, scored: 0, conceded: 1, from: 4),
        ...run(1, scored: 0, conceded: 1, from: 5),
        ...run(1, scored: 0, conceded: 1, from: 6),
      ]);
      final streak = moodOf([
        ...run(2, scored: 1, conceded: 0),
        ...run(5, scored: 0, conceded: 1, from: 2),
      ]);
      expect(streak.score, lessThan(scattered.score));
    });

    test('a good run wins them back', () {
      final after = moodOf([
        ...run(5, scored: 0, conceded: 2),
        ...run(5, scored: 2, conceded: 0, from: 5),
      ]);
      expect(after.band.index, greaterThan(FanMoodBand.neutral.index - 1));
      expect(after.winRun, 5);
    });

    test('results older than the memory are forgotten', () {
      final old = run(6, scored: 0, conceded: 3);
      final m = FanMood.of(
        results: old,
        asOf: old.last.date.add(FanMood.memory + const Duration(days: 1)),
      );
      expect(m.score, FanMood.neutral);
    });

    test('a later result does not leak into an earlier reading', () {
      final results = [
        ...run(4, scored: 2, conceded: 0),
        ...run(4, scored: 0, conceded: 3, from: 4),
      ];
      final then = FanMood.of(results: results, asOf: results[3].date);
      final onlyThen = FanMood.of(
        results: results.take(4),
        asOf: results[3].date,
      );
      expect(then, onlyThen);
    });

    test('a shoot-out counts as its result, as the feed reads it', () {
      final lostOnPens = [
        for (final r in run(5, scored: 1, conceded: 1))
          (
            nationRank: r.nationRank,
            opponentRank: r.opponentRank,
            scored: r.scored,
            conceded: r.conceded,
            competitive: r.competitive,
            date: r.date,
            shootoutWon: false,
          ),
      ];
      final drawn = moodOf(run(5, scored: 1, conceded: 1));
      final lost = moodOf(lostOnPens);
      expect(lost.lossRun, 5);
      expect(drawn.lossRun, 0);
      expect(lost.score, lessThan(drawn.score));
    });

    test('a trophy keeps the country warm, and fades', () {
      final trophy = (kind: FanEventKind.trophy, date: start);
      final soon = FanMood.of(
        results: const [],
        asOf: start.add(const Duration(days: 30)),
        events: [trophy],
      );
      final later = FanMood.of(
        results: const [],
        asOf: start.add(const Duration(days: 400)),
        events: [trophy],
      );
      expect(soon.score, greaterThan(later.score));
      expect(later.score, greaterThan(FanMood.neutral));
      final out = FanMood.of(
        results: const [],
        asOf: start.add(const Duration(days: 30)),
        events: [(kind: FanEventKind.eliminated, date: start)],
      );
      expect(out.score, lessThan(FanMood.neutral));
    });
  });

  group('the crowd follows the mood', () {
    final fixture = Fixture(
      id: 77,
      careerId: 1,
      competitionId: 1,
      matchday: 1,
      date: DateTime(2031, 9, 5),
      homeNationId: 10,
      awayNationId: 20,
    );
    const cities = <int, List<String>>{
      10: ['Homeville', 'Homeport'],
      20: ['Awaytown'],
    };
    MatchGround ground(double moodFill, {bool neutral = false}) =>
        Attendance.forFixture(
          fixture: fixture,
          neutral: neutral,
          citiesByNation: cities,
          seed: 4242,
          moodFill: moodFill,
        );

    test('a losing run empties the same fixture a winning run sells out', () {
      final losing = moodOf(run(5, scored: 0, conceded: 2));
      final winning = moodOf(run(6, scored: 2, conceded: 0));
      final empty = ground(FanMood.fillShift(losing.score));
      final full = ground(FanMood.fillShift(winning.score));
      final usual = ground(0);
      expect(empty.attendance, lessThan(usual.attendance));
      expect(full.attendance, greaterThan(usual.attendance));
      // Visibly emptier: at least a fifth of the ground.
      expect(
        full.attendance - empty.attendance,
        greaterThan(full.capacity ~/ 5),
      );
      expect(full.soldOut, isTrue);
      expect(empty.soldOut, isFalse);
    });

    test('a neutral mood leaves every ground exactly as it was', () {
      expect(ground(0), ground(FanMood.fillShift(FanMood.neutral)));
    });

    test('a neutral finals ignores the home mood', () {
      expect(ground(-0.3, neutral: true), ground(0, neutral: true));
    });

    test('the home advantage moves only a little', () {
      final empty = Attendance.atmosphere(ground(FanMood.fillShift(0)));
      final full = Attendance.atmosphere(ground(FanMood.fillShift(100)));
      final usual = Attendance.atmosphere(ground(0));
      // The engine's home bonus is 3 points times this: under half a point
      // either way.
      expect((usual - empty) * 3, lessThan(0.5));
      expect((full - usual) * 3, lessThan(0.5));
    });
  });

  group('the mood before the cap, never after', () {
    const grant = 16000000;
    const cap = 1600000;

    test('a euphoric estate just under the cap is held at the cap', () {
      expect(
        FanMood.stadiumIncome(
          estate: 1500000,
          grant: grant,
          mood: FanMoodBand.euphoric,
        ),
        cap,
      );
    });

    test('a furious estate over the cap falls below it (mood first)', () {
      // 1.8M is over the cap; capped first and then cut it would pay 1.28M,
      // cut first and then capped it pays 1.44M.
      expect(
        FanMood.stadiumIncome(
          estate: 1800000,
          grant: grant,
          mood: FanMoodBand.furious,
        ),
        1440000,
      );
      // And far over the cap even a fury leaves it at the cap.
      expect(
        FanMood.stadiumIncome(
          estate: 4000000,
          grant: grant,
          mood: FanMoodBand.furious,
        ),
        cap,
      );
    });

    test('no mood is the plain capped estate', () {
      for (final estate in [0, 300000, 1600000, 9000000]) {
        expect(
          FanMood.stadiumIncome(estate: estate, grant: grant),
          NationalStadiums.cappedToGrant(estate, grant),
        );
      }
    });

    test('the effective change is what is really paid', () {
      int pct(int estate, FanMoodBand band) =>
          FanMood.effectivePercent(estate: estate, grant: grant, mood: band);
      expect(pct(1000000, FanMoodBand.euphoric), 20);
      expect(pct(1000000, FanMoodBand.furious), -20);
      expect(pct(1000000, FanMoodBand.neutral), 0);
      // At the cap a good run adds nothing, so nothing is promised.
      expect(pct(cap, FanMoodBand.euphoric), 0);
      expect(pct(5000000, FanMoodBand.warm), 0);
      // An estate that earns nothing has nothing to move.
      expect(pct(0, FanMoodBand.furious), 0);
      // Part of the lift lost to the cap.
      expect(pct(1500000, FanMoodBand.euphoric), 7);
    });
  });

  group('the gate follows the mood, under the grant cap', () {
    test('furious earns a fifth less, euphoric a fifth more', () {
      expect(FanMood.moodIncome(1000000, FanMoodBand.furious), 800000);
      expect(FanMood.moodIncome(1000000, FanMoodBand.neutral), 1000000);
      expect(FanMood.moodIncome(1000000, FanMoodBand.euphoric), 1200000);
    });

    test('a euphoric estate is still held to a tenth of the grant', () {
      const grant = 16000000;
      final cap = NationalStadiums.cappedToGrant(1 << 40, grant);
      for (final band in FanMoodBand.values) {
        for (final income in [0, 500000, 1500000, 1600000, 5000000]) {
          final paid = NationalStadiums.cappedToGrant(
            FanMood.moodIncome(income, band),
            grant,
          );
          expect(paid, lessThanOrEqualTo(cap));
          expect(paid, lessThanOrEqualTo(grant ~/ 10));
        }
      }
    });
  });

  group('the stands on Y', () {
    YContext ctx(int i, {required int scored, required int conceded}) => (
      match: (
        opponent: 'Nation ${i % 5}',
        nationRank: 40,
        opponentRank: 40,
        scored: scored,
        conceded: conceded,
        date: start.add(Duration(days: i * 7)),
        key: 'fx:$i',
        competitive: true,
        stakes: YStakes.qualifier,
        shootoutWon: null,
      ),
      scorerName: null,
      scorerGoals: null,
      winStreak: 0,
      lossStreak: 0,
      isRivalry: false,
      injuredNames: const [],
      boardMood: 50,
    );
    List<YPost> feed(
      List<YContext> cs, {
      DateTime? since,
      bool home = true,
    }) => YFeed.forRun(
      cs,
      nation: 'Czechia',
      seed: 7,
      manager: 'Jan van der Berg',
      managerSince: since,
      homeKeys: home ? {for (final c in cs) c.match.key} : const {},
    );
    Iterable<YPost> of(List<YPost> posts, YTemplate t) =>
        posts.where((p) => p.template == t && p.replyTo == null);

    test('a losing run brings out the banners, with his name on them', () {
      final posts = feed([
        for (var i = 0; i < 8; i++) ctx(i, scored: 0, conceded: 2),
      ]);
      final protests = of(posts, YTemplate.fansProtest).toList();
      expect(protests, isNotEmpty);
      expect(protests.first.args, ['Czechia', 'Berg']);
      // An empty manager name chants the nation, never a bare "#Out".
      final unnamed = YFeed.fansFor(
        template: YTemplate.fansProtest,
        nation: 'Czechia',
        manager: '  ',
        date: start,
        key: 'k',
        seed: 7,
      );
      expect(unnamed.first.args, ['Czechia', 'Czechia']);
      expect(of(posts, YTemplate.fansSellOut), isEmpty);
      // And the room answers it.
      expect(
        posts.any(
          (p) => p.replyTo != null && p.replyTo == protests.first.key,
        ),
        isTrue,
      );
    });

    test('a winning run sells out and never protests', () {
      final posts = feed([
        for (var i = 0; i < 8; i++) ctx(i, scored: 2, conceded: 0),
      ]);
      expect(of(posts, YTemplate.fansSellOut), isNotEmpty);
      expect(of(posts, YTemplate.fansProtest), isEmpty);
    });

    test('an ordinary mixed run says nothing from the stands', () {
      final posts = feed([
        for (var i = 0; i < 12; i++)
          ctx(i, scored: i.isEven ? 1 : 0, conceded: i % 3 == 0 ? 1 : 0),
      ]);
      expect(of(posts, YTemplate.fansProtest), isEmpty);
      expect(of(posts, YTemplate.fansSellOut), isEmpty);
    });

    test('rate-limited: one protest every few matches, not every result', () {
      const n = 20;
      final posts = feed([
        for (var i = 0; i < n; i++) ctx(i, scored: 0, conceded: 2),
      ]);
      final protests = of(posts, YTemplate.fansProtest).toList();
      expect(protests.length, lessThanOrEqualTo(n ~/ FanMood.postGap + 1));
      final weeks = [
        for (final p in protests) p.date.difference(start).inDays ~/ 7,
      ];
      for (var i = 1; i < weeks.length; i++) {
        expect(weeks[i] - weeks[i - 1], greaterThanOrEqualTo(FanMood.postGap));
      }
    });

    test('nobody chants a new man out over results from before his time', () {
      final cs = [for (var i = 0; i < 8; i++) ctx(i, scored: 0, conceded: 2)];
      final posts = feed(cs, since: start.add(const Duration(days: 365)));
      expect(of(posts, YTemplate.fansProtest), isEmpty);
    });

    test('a new man inheriting a fury gets a few matches first', () {
      // A long slump before him, then he arrives in week 8 and keeps losing.
      final cs = [for (var i = 0; i < 14; i++) ctx(i, scored: 0, conceded: 2)];
      final since = start.add(const Duration(days: 8 * 7));
      final weeks = [
        for (final p in of(feed(cs, since: since), YTemplate.fansProtest))
          p.date.difference(start).inDays ~/ 7,
      ];
      expect(weeks, isNotEmpty);
      expect(weeks.first, greaterThanOrEqualTo(8 + YFeed.newManagerGrace - 1));
    });

    test('away or at a finals abroad, nobody describes the ground', () {
      const n = 60;
      final cs = [for (var i = 0; i < n; i++) ctx(i, scored: 0, conceded: 2)];
      final away = of(feed(cs, home: false), YTemplate.fansProtest).toList();
      expect(away, isNotEmpty);
      for (final p in away) {
        expect(YFeed.protestVenueVariants, isNot(contains(p.variant)));
      }
    });

    test('at home the ground can be described', () {
      final seen = <int>{};
      for (var seed = 0; seed < 40; seed++) {
        final cs = [
          for (var i = 0; i < 12; i++)
            ctx(i + seed * 100, scored: 0, conceded: 2),
        ];
        for (final p in of(
          YFeed.forRun(
            cs,
            nation: 'Czechia',
            seed: seed,
            manager: 'Jan van der Berg',
            homeKeys: {for (final c in cs) c.match.key},
          ),
          YTemplate.fansProtest,
        )) {
          seen.add(p.variant);
        }
      }
      expect(seen.intersection(YFeed.protestVenueVariants), isNotEmpty);
    });

    test('the same run always says the same thing', () {
      final cs = [for (var i = 0; i < 10; i++) ctx(i, scored: 0, conceded: 1)];
      List<String> said(List<YPost> ps) => [
        for (final p in ps) '${p.key}|${p.variant}|${p.args.join(',')}',
      ];
      expect(said(feed(cs)), said(feed(cs)));
    });

    test('a hashtag is the family name, letters only', () {
      expect(YFeed.hashtagOf('Martin Urbanczyk'), 'Urbanczyk');
      expect(YFeed.hashtagOf("Seán O'Brien"), 'OBrien');
      expect(YFeed.hashtagOf('Pelé'), 'Pelé');
      expect(YFeed.hashtagOf('J. Smith-Rowe!'), 'SmithRowe');
      // Family name first.
      expect(YFeed.hashtagOf('Nagy Péter', familyFirst: true), 'Nagy');
      expect(YFeed.hashtagOf('Nguyễn Văn An', familyFirst: true), 'Nguyễn');
      expect(YFeed.hashtagOf('山田 太郎'), '山田');
      expect(YFeed.hashtagOf('박지성'), '박지성');
      expect(YFeed.hashtagOf('   '), '');
    });
  });
}
