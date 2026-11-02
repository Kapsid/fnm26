import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/press/expectation.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/domain/services/press/y_tournaments.dart';
import 'package:fnm/features/y/y_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// Owner's feedback: the fans on Y were positive but tame after the biggest
/// moments a nation has. An unexpected place at a finals, a knockout tie
/// won there, a title: the fans now lose their minds, naming the
/// championship in the reader's own words. A favourite's routine win stays
/// what it was.
void main() {
  final en = lookupAppLocalizations(const Locale('en'));
  final cs = lookupAppLocalizations(const Locale('cs'));
  const nation = 'Montenegro';
  const seed = 77;

  YMatch match({
    required int mine,
    required int theirs,
    required int scored,
    required int conceded,
    YStakes stakes = YStakes.qualifier,
    bool? shootoutWon,
  }) => (
    opponent: 'Sweden',
    nationRank: mine,
    opponentRank: theirs,
    scored: scored,
    conceded: conceded,
    date: DateTime(2030, 6, 20),
    key: 'fx:9',
    competitive: true,
    stakes: stakes,
    shootoutWon: shootoutWon,
    away: false,
  );

  YMilestone milestone(
    YTemplate t, {
    String competition = 'European Championship',
  }) => (
    template: t,
    args: [competition],
    date: DateTime(2031, 11, 18),
    key: 'qual:12',
  );

  Iterable<YTemplate> templatesOf(List<YPost> posts) =>
      posts.map((p) => p.template);

  const euphoric = {
    YTemplate.qualifiedEuphoric,
    YTemplate.knockoutEuphoric,
    YTemplate.trophyEuphoric,
  };

  group('a place nobody expected', () {
    test('is read off the campaign: two sides above, or one far above', () {
      expect(
        YTournaments.qualifiedAgainstTheOdds(
          nationRank: 60,
          opponentRanks: [40, 40, 52, 90, 110, 52],
        ),
        isTrue,
      );
      expect(
        YTournaments.qualifiedAgainstTheOdds(
          nationRank: 60,
          opponentRanks: [35, 90, 120],
        ),
        isTrue,
        reason: 'one side 25 places above',
      );
      expect(
        YTournaments.qualifiedAgainstTheOdds(
          nationRank: 8,
          opponentRanks: [30, 30, 55, 90],
        ),
        isFalse,
      );
      expect(
        YTournaments.qualifiedAgainstTheOdds(
          nationRank: 40,
          opponentRanks: [32, 70, 90],
        ),
        isFalse,
        reason: 'one side a little above: the second seed went through',
      );
    });

    test('draws a euphoric fan naming the championship', () {
      final posts = YFeed.forMilestone(
        milestone(YTemplate.qualified),
        nation: nation,
        seed: seed,
        againstTheOdds: true,
      );
      final fan = posts.singleWhere(
        (p) => p.template == YTemplate.qualifiedEuphoric,
      );
      expect(fan.voice, YVoice.fan);
      expect(yPostBody(en, fan), contains('European Championship'));
      expect(
        yPostBody(cs, fan),
        contains(cs.compEuropeanChampionship),
        reason: 'the championship in the language\'s own words',
      );
      // The room answers in kind.
      expect(
        posts.where((p) => p.replyTo != null).map((p) => p.mood).toSet(),
        {YMood.elation},
      );
      // The wire still has the plain fact.
      expect(templatesOf(posts), contains(YTemplate.qualified));
    });

    test('every wording names the championship', () {
      for (var v = 0; v < YFeed.euphoricVariantCount; v++) {
        for (final t in const [
          YTemplate.qualifiedEuphoric,
          YTemplate.trophyEuphoric,
        ]) {
          final p = (
            voice: YVoice.fan,
            handle: '@a',
            displayName: 'A',
            template: t,
            variant: v,
            args: const ['World Championship'],
            date: DateTime(2030),
            key: 'k',
            replyTo: null,
            mood: null,
          );
          expect(yPostBody(en, p), contains('World Championship'));
        }
      }
      for (var v = 0; v < YFeed.heartbreakVariantCount; v++) {
        final p = (
          voice: YVoice.fan,
          handle: '@a',
          displayName: 'A',
          template: YTemplate.exitHeartbreak,
          variant: v,
          args: const ['World Championship'],
          date: DateTime(2030),
          key: 'k',
          replyTo: null,
          mood: null,
        );
        expect(yPostBody(en, p), contains('World Championship'));
      }
    });

    test('an expected place stays the plain one', () {
      final posts = YFeed.forMilestone(
        milestone(YTemplate.qualified),
        nation: nation,
        seed: seed,
      );
      expect(templatesOf(posts).toSet().intersection(euphoric), isEmpty);
      expect(templatesOf(posts), contains(YTemplate.qualified));
    });

    test('is the same posts on every rebuild', () {
      List<String> words() => [
        for (final p in YFeed.forMilestone(
          milestone(YTemplate.qualified),
          nation: nation,
          seed: seed,
          againstTheOdds: true,
          history: const [ResultStanding.poor, ResultStanding.heroic],
        ))
          '${p.handle}:${yPostBody(en, p)}',
      ];
      expect(words(), words());
    });
  });

  test('a title is always euphoric', () {
    final posts = YFeed.forMilestone(
      milestone(YTemplate.trophy, competition: 'World Championship'),
      nation: nation,
      seed: seed,
    );
    final fan = posts.singleWhere(
      (p) => p.template == YTemplate.trophyEuphoric,
    );
    expect(yPostBody(en, fan), contains('World Championship'));
  });

  group('a knockout tie won at a finals', () {
    test('by an underdog sends the fans into dreamland', () {
      final posts = YFeed.forMatch(
        plainContext(
          match(
            mine: 40,
            theirs: 25,
            scored: 2,
            conceded: 1,
            stakes: YStakes.knockout,
          ),
        ),
        nation: nation,
        seed: seed,
      );
      final fan = posts.singleWhere(
        (p) => p.template == YTemplate.knockoutEuphoric,
      );
      expect(fan.voice, YVoice.fan);
      expect(yPostBody(en, fan), contains('Sweden'));
    });

    test('on penalties counts too', () {
      final posts = YFeed.forMatch(
        plainContext(
          match(
            mine: 30,
            theirs: 28,
            scored: 1,
            conceded: 1,
            stakes: YStakes.knockout,
            shootoutWon: true,
          ),
        ),
        nation: nation,
        seed: seed,
      );
      expect(templatesOf(posts), contains(YTemplate.knockoutEuphoric));
    });

    test('by a heavy favourite is the job', () {
      final posts = YFeed.forMatch(
        plainContext(
          match(
            mine: 3,
            theirs: 70,
            scored: 2,
            conceded: 0,
            stakes: YStakes.knockout,
          ),
        ),
        nation: nation,
        seed: seed,
      );
      expect(templatesOf(posts), isNot(contains(YTemplate.knockoutEuphoric)));
    });
  });

  test('an expected routine win draws nothing euphoric', () {
    final posts = YFeed.forMatch(
      plainContext(match(mine: 10, theirs: 90, scored: 3, conceded: 0)),
      nation: nation,
      seed: seed,
    );
    expect(posts, isNotEmpty);
    expect(templatesOf(posts).toSet().intersection(euphoric), isEmpty);
  });

  group('a painful exit', () {
    test('is a favourite out early', () {
      expect(
        YTournaments.painfulExit(
          exitRound: 'GROUP',
          nationRank: 5,
          opponentRanks: [20, 31, 44],
        ),
        isTrue,
      );
      expect(
        YTournaments.painfulExit(
          exitRound: 'R16',
          nationRank: 5,
          opponentRanks: [20, 31, 44, 2],
        ),
        isFalse,
        reason: 'out to a better side',
      );
      expect(
        YTournaments.painfulExit(
          exitRound: 'QF',
          nationRank: 5,
          opponentRanks: [20, 31, 44, 12],
        ),
        isFalse,
        reason: 'a quarter-final is going far enough',
      );
      expect(
        YTournaments.painfulExit(
          exitRound: 'GROUP',
          nationRank: 60,
          opponentRanks: [80, 90, 100],
        ),
        isFalse,
        reason: 'nobody expected a minnow to go far',
      );
    });

    test('breaks hearts rather than tempers', () {
      final posts = YFeed.forMilestone(
        (
          template: YTemplate.eliminated,
          args: const ['World Championship'],
          date: DateTime(2030, 6, 30),
          key: 'out:cmp:3',
        ),
        nation: nation,
        seed: seed,
        painful: true,
      );
      final fan = posts.singleWhere(
        (p) => p.template == YTemplate.exitHeartbreak,
      );
      expect(yPostBody(en, fan), contains('World Championship'));
      // Heartbreak, not fury (the rival enjoys it, as he always does).
      final moods = posts
          .where((p) => p.replyTo != null)
          .map((p) => p.mood)
          .toSet();
      expect(moods, contains(YMood.despair));
      expect(moods, isNot(contains(YMood.fury)));
    });
  });
}
