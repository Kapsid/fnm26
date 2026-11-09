import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/press/expectation.dart';
import 'package:fnm/domain/services/press/persona.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/domain/services/press/y_locals.dart';
import 'package:fnm/domain/services/press/y_tournaments.dart';
import 'package:fnm/features/y/y_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// Tester feedback: Montenegro reached the last thirty-two of the World
/// Championship and the people on Y were upset he got knocked out, calling
/// for his resignation. A run that went further than the side was ever
/// expected to go is a run the country is proud of: no inquest, no fury, no
/// banner with his name on it. A favourite going out early still hurts.
void main() {
  final en = lookupAppLocalizations(const Locale('en'));
  const nation = 'Montenegro';

  /// What a reader would take as the country turning on the manager.
  const hostile = [
    'inquest',
    'explain',
    'surprised',
    'excuses',
    'cost somebody',
    'answerable',
    'in charge',
    'CV',
    'Out.',
    'names',
    'insult',
    'Not good enough',
    'had the team to win',
  ];

  void expectNothingHostile(List<YPost> posts, {required String reason}) {
    for (final p in posts) {
      final body = yPostBody(en, p);
      for (final h in hostile) {
        expect(body, isNot(contains(h)), reason: '$reason: "$body"');
      }
      expect(p.template, isNot(YTemplate.fansProtest), reason: reason);
      expect(p.template, isNot(YTemplate.boardPressure), reason: reason);
      expect(p.template, isNot(YTemplate.toldYouSo), reason: reason);
      expect(p.template, isNot(YTemplate.sameOldStory), reason: reason);
      if (p.replyTo != null) {
        expect(
          p.mood,
          isNot(anyOf(YMood.fury, YMood.despair, YMood.smugness)),
          reason: '$reason: a ${p.mood} reply',
        );
      }
    }
  }

  YMilestone exit({String key = 'out:cmp:3'}) => (
    template: YTemplate.eliminated,
    args: const ['World Championship'],
    date: DateTime(2030, 7, 2),
    key: key,
  );

  /// The defeat that ended it: a giant, two goals, in the last thirty-two.
  YMatch exitMatch({String key = 'fx:40', int conceded = 2}) => (
    opponent: 'Sweden',
    nationRank: 70,
    opponentRank: 4,
    scored: 0,
    conceded: conceded,
    date: DateTime(2030, 7, 2),
    key: key,
    competitive: true,
    stakes: YStakes.knockout,
    shootoutWon: null,
    away: false,
  );

  group('YTournaments.proudExit', () {
    ({String? round, int opponentRank, bool won}) g(
      int rank, {
      bool won = false,
    }) => (round: 'GROUP', opponentRank: rank, won: won);

    test('a minnow out of a group it was meant to finish third in', () {
      expect(
        YTournaments.proudExit(
          exitRound: 'R32',
          nationRank: 70,
          meetings: [
            g(10),
            g(30),
            g(90, won: true),
            (round: 'R32', opponentRank: 4, won: false),
          ],
        ),
        isTrue,
      );
    });

    test('a knockout tie won against a better side', () {
      expect(
        YTournaments.proudExit(
          exitRound: 'QF',
          nationRank: 20,
          meetings: [
            g(5),
            g(40, won: true),
            g(60, won: true),
            (round: 'R16', opponentRank: 12, won: true),
            (round: 'QF', opponentRank: 3, won: false),
          ],
        ),
        isTrue,
      );
    });

    test('not a group exit, a favourite, nor a side that did the job', () {
      expect(
        YTournaments.proudExit(
          exitRound: 'GROUP',
          nationRank: 70,
          meetings: [g(10), g(30), g(90)],
        ),
        isFalse,
        reason: 'it did not get out of the group',
      );
      expect(
        YTournaments.proudExit(
          exitRound: 'R16',
          nationRank: 3,
          meetings: [
            g(20, won: true),
            g(31, won: true),
            g(44, won: true),
            (round: 'R16', opponentRank: 1, won: false),
          ],
        ),
        isFalse,
        reason: 'a favourite out in the last sixteen did not overachieve',
      );
      expect(
        YTournaments.proudExit(
          exitRound: 'R32',
          nationRank: 20,
          meetings: [
            g(5),
            g(40, won: true),
            g(60),
            (round: 'R32', opponentRank: 8, won: false),
          ],
        ),
        isFalse,
        reason: 'expected through the group, and out where it should be',
      );
      expect(
        YTournaments.proudExit(
          exitRound: 'FINAL',
          nationRank: 70,
          meetings: [g(10), g(30)],
        ),
        isFalse,
        reason: 'a final lost is a runner-up, not an exit',
      );
    });
  });

  group('the exit itself', () {
    test('is proud and grateful, whoever is posting', () {
      for (var seed = 0; seed < 150; seed++) {
        // Every disposition, with a run behind it that has soured the room.
        for (final history in [
          const <ResultStanding>[],
          List.filled(8, ResultStanding.humiliating),
        ]) {
          final posts = YFeed.forMilestone(
            exit(key: 'out:cmp:$seed'),
            nation: nation,
            seed: seed,
            proud: true,
            history: history,
          );
          expectNothingHostile(posts, reason: 'seed $seed');
          final proud = posts.where((p) => p.template == YTemplate.exitProud);
          expect(proud.map((p) => p.voice).toSet(), {
            YVoice.fan,
            YVoice.expro,
          });
          for (final p in proud) {
            expect(yPostBody(en, p), contains('World Championship'));
          }
          expect(
            posts.where((p) => p.replyTo != null).map((p) => p.mood).toSet(),
            {YMood.pride},
          );
        }
      }
    });

    test('an ordinary exit can still turn on him', () {
      final bodies = <String>{};
      for (var seed = 0; seed < 40; seed++) {
        for (final p in YFeed.forMilestone(
          exit(key: 'out:cmp:$seed'),
          nation: nation,
          seed: seed,
        )) {
          bodies.add(yPostBody(en, p));
        }
      }
      expect(bodies.any((b) => b.contains('inquest')), isTrue);
    });

    test('a favourite out early still breaks hearts', () {
      final posts = YFeed.forMilestone(
        exit(),
        nation: nation,
        seed: 7,
        painful: true,
        proud: true,
      );
      expect(posts.map((p) => p.template), contains(YTemplate.exitHeartbreak));
      expect(
        posts.map((p) => p.template),
        isNot(contains(YTemplate.exitProud)),
      );
    });
  });

  group('the match that ended it', () {
    YContext soured(YMatch m) => (
      match: m,
      scorerName: null,
      scorerGoals: null,
      winStreak: 0,
      lossStreak: 4,
      isRivalry: false,
      injuredNames: const [],
      boardMood: 5,
    );

    test('is worded generously and answered with pride', () {
      for (var seed = 0; seed < 150; seed++) {
        for (final conceded in [1, 2, 5]) {
          final posts = YFeed.forMatch(
            soured(exitMatch(key: 'fx:$seed', conceded: conceded)),
            nation: nation,
            seed: seed,
            memory: (
              standings: [
                ...List.filled(4, ResultStanding.heroic),
                ResultStanding.poor,
                ResultStanding.poor,
              ],
              metBefore: 4,
              sameRecently: 4,
              beatenBefore: 0,
            ),
            proudExit: true,
          );
          expectNothingHostile(posts, reason: 'seed $seed, 0-$conceded');
          expect(
            posts.where((p) => p.replyTo != null).map((p) => p.mood),
            everyElement(YMood.pride),
          );
        }
      }
    });

    test('without the run behind it, the same defeat can still sting', () {
      final moods = <YMood?>{};
      for (var seed = 0; seed < 40; seed++) {
        final posts = YFeed.forMatch(
          soured(exitMatch(key: 'fx:$seed')),
          nation: nation,
          seed: seed,
        );
        moods.addAll(posts.where((p) => p.replyTo != null).map((p) => p.mood));
        expect(
          posts.map((p) => p.template),
          contains(YTemplate.boardPressure),
        );
      }
      expect(moods, isNot(contains(YMood.pride)));
    });

    test('a local fan answers it with pride too', () {
      final cast = [
        for (final n in ['Marko', 'Luka', 'Nikola', 'Stefan'])
          (handle: '@$n', displayName: n, trait: YCast.traitFor(n)),
      ];
      // An ordinary result draws a local only now and then: try a few.
      final locals = [
        for (var seed = 0; seed < 12; seed++)
          ...YLocals.withLocals(
            YFeed.forMatch(
              soured(exitMatch(key: 'fx:$seed')),
              nation: nation,
              seed: seed,
              proudExit: true,
            ),
            cast: cast,
            seed: seed,
          ).where((p) => p.key.contains('|local')),
      ];
      expect(locals, isNotEmpty);
      expect(locals.map((p) => p.mood), everyElement(YMood.pride));
    });
  });

  group('the stands', () {
    // Five humiliations in a row, then the knockout exit: the stands are
    // furious, and would chant his name after any defeat. (Five, so the
    // protest after the first of them is far enough back for another.)
    List<YContext> run() => [
      for (var i = 0; i < 5; i++)
        plainContext((
          opponent: 'Minnow $i',
          nationRank: 70,
          opponentRank: 160,
          scored: 0,
          conceded: 4,
          date: DateTime(2030, 1 + i, 3),
          key: 'fx:$i',
          competitive: true,
          stakes: YStakes.qualifier,
          shootoutWon: null,
          away: false,
        )),
      plainContext(exitMatch()),
    ];

    bool protestAtExit(Set<String> proud) =>
        YFeed.forRun(
          run(),
          nation: nation,
          seed: 11,
          manager: 'Ivo Brankov',
          proudExitKeys: proud,
        ).any(
          (p) =>
              p.template == YTemplate.fansProtest &&
              p.key.startsWith('fans:fx:40'),
        );

    test('do not chant for him the night of a proud exit', () {
      expect(
        protestAtExit(const {}),
        isTrue,
        reason: 'the control: an ordinary exit after that run draws one',
      );
      expect(protestAtExit({'fx:40'}), isFalse);
    });
  });

  group('an exit about where it was expected', () {
    ({String? round, int opponentRank, bool won}) g(
      int rank, {
      bool won = false,
    }) => (round: 'GROUP', opponentRank: rank, won: won);

    test('is a minnow out in its group, or out to a better side', () {
      expect(
        YTournaments.parExit(
          exitRound: 'GROUP',
          nationRank: 70,
          meetings: [g(10), g(30), g(90, won: true)],
        ),
        isTrue,
      );
      expect(
        YTournaments.parExit(
          exitRound: 'R32',
          nationRank: 20,
          meetings: [
            g(5),
            g(40, won: true),
            g(60),
            (round: 'R32', opponentRank: 8, won: false),
          ],
        ),
        isTrue,
      );
      expect(
        YTournaments.parExit(
          exitRound: 'GROUP',
          nationRank: 20,
          meetings: [g(5), g(40), g(60)],
        ),
        isFalse,
        reason: 'it should have got out of that group: a let-down',
      );
      expect(
        YTournaments.parExit(
          exitRound: 'R16',
          nationRank: 20,
          meetings: [
            g(5, won: true),
            g(40, won: true),
            g(60, won: true),
            (round: 'R16', opponentRank: 50, won: false),
          ],
        ),
        isFalse,
        reason: 'out to a weaker side: a let-down',
      );
    });

    test('draws no inquest and no fury, whoever is posting', () {
      for (var seed = 0; seed < 150; seed++) {
        for (final history in [
          const <ResultStanding>[],
          List.filled(8, ResultStanding.humiliating),
        ]) {
          final posts = YFeed.forMilestone(
            exit(key: 'out:cmp:$seed'),
            nation: nation,
            seed: seed,
            accepted: true,
            history: history,
          );
          expectNothingHostile(posts, reason: 'seed $seed');
          final accepted = posts.where(
            (p) => p.template == YTemplate.exitAccepted,
          );
          expect(accepted.map((p) => p.voice).toSet(), {
            YVoice.fan,
            YVoice.expro,
          });
          for (final p in accepted) {
            expect(yPostBody(en, p), contains('World Championship'));
          }
          final wire = posts.singleWhere(
            (p) => p.template == YTemplate.eliminated,
          );
          expect(
            yPostBody(en, wire),
            'Out at World Championship. That one will hurt for a while.',
          );
          expect(
            posts.where((p) => p.replyTo != null).map((p) => p.mood).toSet(),
            {YMood.acceptance},
          );
        }
      }
    });

    test('heartbreak and pride still win over it', () {
      final painful = YFeed.forMilestone(
        exit(),
        nation: nation,
        seed: 5,
        painful: true,
        accepted: true,
      );
      expect(
        painful.map((p) => p.template),
        contains(YTemplate.exitHeartbreak),
      );
      final proud = YFeed.forMilestone(
        exit(),
        nation: nation,
        seed: 5,
        proud: true,
        accepted: true,
      );
      expect(proud.map((p) => p.template), contains(YTemplate.exitProud));
      expect(
        proud.map((p) => p.template),
        isNot(contains(YTemplate.exitAccepted)),
      );
    });

    test('the match that ended it is answered with acceptance', () {
      for (var seed = 0; seed < 150; seed++) {
        final posts = YFeed.forMatch(
          (
            match: exitMatch(key: 'fx:$seed'),
            scorerName: null,
            scorerGoals: null,
            winStreak: 0,
            lossStreak: 4,
            isRivalry: false,
            injuredNames: const [],
            boardMood: 5,
          ),
          nation: nation,
          seed: seed,
          memory: (
            standings: [
              ...List.filled(4, ResultStanding.heroic),
              ResultStanding.poor,
              ResultStanding.poor,
            ],
            metBefore: 4,
            sameRecently: 4,
            beatenBefore: 0,
          ),
          acceptedExit: true,
        );
        expectNothingHostile(posts, reason: 'seed $seed');
        expect(
          posts.where((p) => p.replyTo != null).map((p) => p.mood),
          everyElement(YMood.acceptance),
        );
      }
    });

    test('the stands do not chant for him that night', () {
      final run = [
        for (var i = 0; i < 5; i++)
          plainContext((
            opponent: 'Minnow $i',
            nationRank: 70,
            opponentRank: 160,
            scored: 0,
            conceded: 4,
            date: DateTime(2030, 1 + i, 3),
            key: 'fx:$i',
            competitive: true,
            stakes: YStakes.qualifier,
            shootoutWon: null,
            away: false,
          )),
        plainContext(exitMatch()),
      ];
      bool protest({Set<String> accepted = const {}}) =>
          YFeed.forRun(
            run,
            nation: nation,
            seed: 11,
            manager: 'Ivo Brankov',
            acceptedExitKeys: accepted,
          ).any(
            (p) =>
                p.template == YTemplate.fansProtest &&
                p.key.startsWith('fans:fx:40'),
          );
      expect(protest(), isTrue, reason: 'the control');
      expect(protest(accepted: {'fx:40'}), isFalse);
    });
  });
}
