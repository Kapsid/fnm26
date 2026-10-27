import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/press/expectation.dart';
import 'package:fnm/domain/services/press/y_feed.dart';

/// Y reacting to how BIG an afternoon was (playtest 2026-10: "Y is not
/// reacting to huge and surprising wins and we need more variability").
///
/// Before this, the feed graded its volume on the five-word standing alone:
/// a 6-0 was filed as a routine win, a knockout won on penalties as a draw,
/// a final as any qualifier, and a shock drew three voices at most.
void main() {
  YMatch match({
    int mine = 30,
    int theirs = 30,
    int scored = 1,
    int conceded = 0,
    YStakes stakes = YStakes.qualifier,
    bool? shootoutWon,
    bool competitive = true,
    String key = 'fx:1',
    String opponent = 'Spain',
  }) => (
    opponent: opponent,
    nationRank: mine,
    opponentRank: theirs,
    scored: scored,
    conceded: conceded,
    date: DateTime(2030, 6, 10),
    key: key,
    competitive: competitive,
    stakes: stakes,
    shootoutWon: shootoutWon,
  );

  YContext ctx(YMatch m, {String? scorer}) => (
    match: m,
    scorerName: scorer,
    scorerGoals: scorer == null ? null : 2,
    winStreak: 0,
    lossStreak: 0,
    isRivalry: false,
    injuredNames: const [],
    boardMood: 50,
  );

  // The run a critic needs behind him: nobody has written off a side that
  // has not played, and a side that has only won has no critics.
  const rough = [
    ResultStanding.poor,
    ResultStanding.humiliating,
    ResultStanding.poor,
  ];

  List<YPost> posts(
    YMatch m, {
    int seed = 4242,
    String? scorer,
    List<ResultStanding> history = const [],
  }) => YFeed.forMatch(
    ctx(m, scorer: scorer),
    nation: 'Czechia',
    seed: seed,
    memory: (
      standings: history,
      metBefore: 0,
      sameRecently: 0,
      beatenBefore: 0,
    ),
  );

  Set<YTemplate> templates(List<YPost> ps) => {for (final p in ps) p.template};

  group('a big upset is louder than a routine win', () {
    final upset = match(
      mine: 80,
      theirs: 6,
      scored: 2,
      conceded: 1,
      stakes: YStakes.knockout,
    );
    final routine = match(mine: 6, theirs: 80, scored: 2, conceded: 0);

    test('on every seed: more posts, more voices, more heat', () {
      for (var seed = 0; seed < 60; seed++) {
        final big = posts(upset, seed: seed, scorer: 'Novak', history: rough);
        final small = posts(routine, seed: seed, scorer: 'Novak');
        expect(
          big.length,
          greaterThanOrEqualTo(small.length * 2),
          reason: 'seed $seed: ${big.length} vs ${small.length}',
        );
        final bigVoices = {for (final p in big) p.voice};
        final smallVoices = {for (final p in small) p.voice};
        expect(
          bigVoices.length,
          greaterThan(smallVoices.length + 2),
          reason: 'seed $seed',
        );
      }
      expect(
        YFeed.magnitudeOf(upset).heat,
        greaterThan(YFeed.magnitudeOf(routine).heat + 3),
      );
    });

    test('it brings out the whole room', () {
      final big = posts(upset, scorer: 'Novak', history: rough);
      expect(
        templates(big),
        containsAll([
          YTemplate.winUpset,
          YTemplate.knockoutWin,
          YTemplate.neutralWin,
          YTemplate.awayFansWin,
          YTemplate.eatWords,
          YTemplate.upsetGap,
          YTemplate.scorerHero,
        ]),
      );
      // The neutral names both sides; the away fans name us.
      final neutral = big.firstWhere((p) => p.voice == YVoice.neutral);
      expect(neutral.args, ['Czechia', 'Spain', '2–1']);
      final away = big.firstWhere((p) => p.voice == YVoice.away);
      expect(away.args, ['Czechia', '2–1']);
      // The gap is spelled out, in places.
      final gap = big.firstWhere((p) => p.template == YTemplate.upsetGap);
      expect(gap.args, ['Spain', '74']);
      // And everyone the mood calls for replies, not a random one or two.
      expect(
        big.where((p) => p.replyTo != null).length,
        2,
        reason: 'elation draws the meme account and a fan, both',
      );
    });

    test('a routine win stays quiet', () {
      final small = posts(routine);
      expect(templates(small), contains(YTemplate.winRoutine));
      expect(
        small.where((p) => p.mood == null).length,
        1,
        reason: 'the stats desk and nobody else',
      );
    });

    test('the critic only eats his words if he said them', () {
      expect(
        templates(posts(upset, history: rough)),
        contains(YTemplate.eatWords),
      );
      // A first match: nobody has written anybody off.
      expect(templates(posts(upset)), isNot(contains(YTemplate.eatWords)));
      // A side that has only won has no critics left to be wrong.
      const glory = [
        ResultStanding.heroic,
        ResultStanding.heroic,
        ResultStanding.creditable,
      ];
      expect(
        templates(posts(upset, history: glory)),
        isNot(contains(YTemplate.eatWords)),
      );
      // He is somebody from the pundits' or the ex-pros' cast, and sour.
      final critic = posts(
        upset,
        history: rough,
      ).firstWhere((p) => p.template == YTemplate.eatWords);
      expect([YVoice.pundit, YVoice.expro], contains(critic.voice));
    });
  });

  group('magnitude', () {
    test('a rout is a rout, not a routine win', () {
      final m = match(scored: 6, conceded: 0);
      expect(YFeed.classify(m), YTemplate.winRout);
      expect(YFeed.magnitudeOf(m).heat, greaterThanOrEqualTo(3));
      // ...while a favourite's 3-0 is still the job.
      expect(
        YFeed.classify(match(mine: 4, theirs: 70, scored: 3, conceded: 0)),
        YTemplate.winRoutine,
      );
    });

    test('the stakes count: a final is louder than a qualifier', () {
      final qualifier = match(mine: 10, theirs: 12);
      final finalWin = match(mine: 10, theirs: 12, stakes: YStakes.trophyFinal);
      expect(
        YFeed.magnitudeOf(finalWin).heat,
        greaterThan(YFeed.magnitudeOf(qualifier).heat),
      );
      expect(posts(finalWin).length, greaterThan(posts(qualifier).length));
      expect(templates(posts(finalWin)), contains(YTemplate.knockoutWin));
    });

    test('a knockout settled on penalties is not a draw', () {
      final won = match(
        scored: 1,
        conceded: 1,
        stakes: YStakes.knockout,
        shootoutWon: true,
      );
      final lost = match(
        scored: 1,
        conceded: 1,
        stakes: YStakes.knockout,
        shootoutWon: false,
      );
      expect(YFeed.classify(won), YTemplate.winShootout);
      expect(YFeed.classify(lost), YTemplate.lostShootout);
      // The line names the opponent only: "beat them 1-1" reads as nonsense.
      final first = posts(won).first;
      expect(first.args, ['Spain']);
      expect(YFeed.moodOf(YTemplate.winShootout), YMood.elation);
    });

    test('a friendly can be noticed, never celebrated', () {
      final m = match(
        mine: 90,
        theirs: 2,
        scored: 5,
        conceded: 0,
        competitive: false,
      );
      expect(YFeed.magnitudeOf(m).heat, lessThanOrEqualTo(1));
    });

    test('stakes are read off the round code', () {
      expect(YFeed.stakesOf('FRIENDLY'), YStakes.friendly);
      expect(YFeed.stakesOf(null), YStakes.qualifier);
      expect(YFeed.stakesOf('CQ'), YStakes.qualifier);
      expect(YFeed.stakesOf('NGROUP'), YStakes.qualifier);
      expect(YFeed.stakesOf('GROUP'), YStakes.finals);
      expect(YFeed.stakesOf('CGROUP'), YStakes.finals);
      expect(YFeed.stakesOf('R16'), YStakes.knockout);
      expect(YFeed.stakesOf('CQF'), YStakes.knockout);
      expect(YFeed.stakesOf('NSF'), YStakes.knockout);
      expect(YFeed.stakesOf('FINAL'), YStakes.trophyFinal);
      expect(YFeed.stakesOf('CFINAL'), YStakes.trophyFinal);
      expect(YFeed.stakesOf('NFINAL'), YStakes.trophyFinal);
      // The play-off final is for a place at the finals, not for a trophy.
      expect(YFeed.stakesOf('POFINAL'), YStakes.knockout);
      expect(YFeed.stakesOf('POSF'), YStakes.knockout);
    });

    test('a play-off final is no louder than any other knockout', () {
      final playoff = match(
        mine: 10,
        theirs: 12,
        stakes: YFeed.stakesOf('POFINAL'),
      );
      final knockout = match(mine: 10, theirs: 12, stakes: YStakes.knockout);
      final trophy = match(
        mine: 10,
        theirs: 12,
        stakes: YFeed.stakesOf('FINAL'),
      );
      expect(
        YFeed.magnitudeOf(playoff).heat,
        YFeed.magnitudeOf(knockout).heat,
      );
      expect(
        YFeed.magnitudeOf(trophy).heat,
        greaterThan(YFeed.magnitudeOf(playoff).heat),
      );
    });
  });

  group('defeats work in mirror', () {
    test('a humiliation is as loud as a triumph', () {
      final shame = match(mine: 5, theirs: 90, scored: 0, conceded: 3);
      final ps = posts(shame);
      expect(
        templates(ps),
        containsAll([
          YTemplate.lostBadly,
          YTemplate.neutralLoss,
          YTemplate.awayFansGloat,
          YTemplate.downGap,
        ]),
      );
      expect(YFeed.magnitudeOf(shame).heat, greaterThanOrEqualTo(4));
      // The rival still turns up, in the replies.
      expect(
        ps
            .where((p) => p.voice == YVoice.rival)
            .every((p) => p.replyTo != null),
        isTrue,
      );
    });

    test('the shock line is symmetric with the heroic one: 15 places', () {
      // A one-goal win over a side 15 places higher is heroic; a one-goal
      // defeat by a side 15 places lower is the mirror, and 14 is not.
      expect(
        YFeed.standingOf(match(mine: 16, theirs: 1, scored: 1, conceded: 0)),
        ResultStanding.heroic,
      );
      expect(
        YFeed.standingOf(match(mine: 1, theirs: 16, scored: 0, conceded: 1)),
        ResultStanding.humiliating,
      );
      expect(
        YFeed.standingOf(match(mine: 1, theirs: 15, scored: 0, conceded: 1)),
        ResultStanding.poor,
      );
    });

    test('Germany (1st) losing 0-1 to the 10th side is a mild reaction', () {
      final m = match(
        mine: 1,
        theirs: 10,
        scored: 0,
        conceded: 1,
        opponent: 'Netherlands',
      );
      expect(YFeed.standingOf(m), isNot(ResultStanding.humiliating));
      expect(YFeed.classify(m), YTemplate.lost);
      expect(YFeed.magnitudeOf(m).heat, lessThanOrEqualTo(1));
      for (var seed = 0; seed < 40; seed++) {
        final ps = posts(m, seed: seed);
        expect(
          templates(ps).intersection({
            YTemplate.lostShock,
            YTemplate.lostBadly,
            YTemplate.neutralLoss,
            YTemplate.awayFansGloat,
            YTemplate.downGap,
          }),
          isEmpty,
          reason: 'seed $seed',
        );
        expect(
          ps.map((p) => p.voice).toSet(),
          isNot(anyOf(contains(YVoice.neutral), contains(YVoice.away))),
          reason: 'seed $seed',
        );
        expect(
          ps.where((p) => p.replyTo == null).length,
          lessThanOrEqualTo(2),
          reason: 'seed $seed: the stats desk and a fan at most',
        );
      }
    });

    test('a one-goal defeat by a side a little lower is a shock, not a '
        'humiliation for the whole room', () {
      // Two minnows: 180th loses 0-1 to 205th. The board calls this a plain
      // defeat; Y names the shock but leaves the neutrals and the away fans
      // at home.
      final m = match(mine: 180, theirs: 205, scored: 0, conceded: 1);
      expect(YFeed.classify(m), YTemplate.lostShock);
      expect(YFeed.magnitudeOf(m).heat, 2);
      final t = templates(posts(m));
      expect(t, isNot(contains(YTemplate.neutralLoss)));
      expect(t, isNot(contains(YTemplate.awayFansGloat)));
      // Two goals, or a long way down the table, and the room fills.
      expect(
        YFeed.magnitudeOf(
          match(mine: 1, theirs: 16, scored: 0, conceded: 2),
        ).heat,
        greaterThanOrEqualTo(3),
      );
      expect(
        YFeed.magnitudeOf(
          match(mine: 1, theirs: 40, scored: 0, conceded: 1),
        ).heat,
        greaterThanOrEqualTo(3),
      );
    });

    test('a one-goal shock and a hammering by a better side read apart', () {
      expect(
        YFeed.classify(match(mine: 5, theirs: 90, scored: 0, conceded: 1)),
        YTemplate.lostShock,
      );
      expect(
        YFeed.classify(match(mine: 60, theirs: 3, scored: 0, conceded: 4)),
        YTemplate.lostRout,
      );
    });

    test('a point is a triumph or a disgrace depending on whose', () {
      expect(
        YFeed.classify(match(mine: 90, theirs: 3, scored: 1, conceded: 1)),
        YTemplate.drewHeroic,
      );
      expect(
        YFeed.classify(match(mine: 3, theirs: 90, scored: 1, conceded: 1)),
        YTemplate.drewShame,
      );
    });

    test('the other lot speak from their own cast, per opponent', () {
      final a = posts(
        match(mine: 5, theirs: 90, scored: 0, conceded: 3, opponent: 'Andorra'),
      ).firstWhere((p) => p.voice == YVoice.away);
      final handles = <String>{};
      for (final opp in ['Andorra', 'Malta', 'Gibraltar', 'Faroe Islands']) {
        handles.add(
          posts(
            match(mine: 5, theirs: 90, scored: 0, conceded: 3, opponent: opp),
          ).firstWhere((p) => p.voice == YVoice.away).handle,
        );
      }
      expect(a.handle, startsWith('@'));
      expect(handles.length, greaterThan(1));
    });
  });

  group('variety', () {
    test('no wording repeats within the window over a long career', () {
      // Two hundred matches of every kind: routs, shocks, shoot-outs, finals.
      // Deterministic: a fixed linear sequence, no Random.
      final contexts = <YContext>[
        for (var i = 0; i < 200; i++)
          ctx(
            match(
              key: 'fx:$i',
              opponent: 'Nation ${i % 11}',
              mine: 20 + (i * 7) % 60,
              theirs: 5 + (i * 13) % 100,
              scored: (i * 5) % 7,
              conceded: (i * 3) % 4,
              stakes: YStakes.values[i % YStakes.values.length],
              competitive: i % 9 != 0,
            ),
            scorer: i.isEven ? 'Scorer ${i % 6}' : null,
          ),
      ];
      final feed = YFeed.forRun(contexts, nation: 'Czechia', seed: 7);
      String wording(YPost p) => p.mood == null
          ? '${p.template.name}|${p.variant}'
          : 'reaction|${p.mood!.name}|${p.variant}';
      for (var i = 0; i < feed.length; i++) {
        final from = i < YFeed.noRepeatWindow ? 0 : i - YFeed.noRepeatWindow;
        final window = feed.sublist(from, i).map(wording).toSet();
        expect(
          window.contains(wording(feed[i])),
          isFalse,
          reason: '${wording(feed[i])} repeats at $i',
        );
      }
      // And it is not quiet about it: the extra voices are actually heard.
      final kinds = {for (final p in feed) p.template};
      expect(
        kinds,
        containsAll([
          YTemplate.winRout,
          YTemplate.neutralWin,
          YTemplate.neutralLoss,
          YTemplate.awayFansWin,
          YTemplate.awayFansGloat,
          YTemplate.knockoutWin,
          YTemplate.knockoutLoss,
        ]),
      );
    });

    test('a match report never vanishes for want of a fresh wording', () {
      // The same routine win, forty times: the stats desk must still report
      // every one of them.
      final contexts = [
        for (var i = 0; i < 40; i++)
          ctx(match(key: 'fx:$i', mine: 4, theirs: 80, scored: 2, conceded: 0)),
      ];
      final feed = YFeed.forRun(contexts, nation: 'Czechia', seed: 1);
      expect(
        feed.where((p) => p.voice == YVoice.stats).length,
        contexts.length,
      );
    });

    test('match reactions are at least three times as deep as before', () {
      // 96 wordings across the six result templates before this change.
      const matchTemplates = [
        YTemplate.winUpset,
        YTemplate.winRoutine,
        YTemplate.winTight,
        YTemplate.drew,
        YTemplate.lost,
        YTemplate.lostBadly,
        YTemplate.winRout,
        YTemplate.winShootout,
        YTemplate.knockoutWin,
        YTemplate.upsetGap,
        YTemplate.eatWords,
        YTemplate.awayFansWin,
        YTemplate.neutralWin,
        YTemplate.scorerHero,
        YTemplate.lostShock,
        YTemplate.lostRout,
        YTemplate.lostShootout,
        YTemplate.knockoutLoss,
        YTemplate.awayFansGloat,
        YTemplate.neutralLoss,
        YTemplate.downGap,
        YTemplate.drewHeroic,
        YTemplate.drewShame,
      ];
      final total = matchTemplates.fold<int>(
        0,
        (sum, t) => sum + YFeed.variantsFor(t),
      );
      expect(total, greaterThanOrEqualTo(96 * 3));
      // Every one splits into three tone bands.
      for (final t in matchTemplates) {
        expect(YFeed.variantsFor(t) % 3, 0, reason: t.name);
      }
    });
  });
}
