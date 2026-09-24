import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/press/press.dart';
import 'package:fnm/domain/services/press/squad_stories.dart';

/// The rules behind the questions that know who is playing.
///
/// Every topic here has to fire when it should and stay quiet when it should
/// not — a press room that asks about a drought after two games, or calls a
/// twenty-second cap a debut, is worse than one that only reads the scoreline,
/// because it is confidently wrong about a named man.
void main() {
  /// A squad man with nothing remarkable about him. Each test moves ONE thing.
  SquadMan man({
    int playerId = 1,
    String name = 'Hayes',
    int age = 26,
    int overall = 70,
    PlayerPosition position = PlayerPosition.cm,
    int caps = 30,
    bool available = true,
    bool inXi = true,
    int? gamesSinceGoal,
    double? lastRating,
    int? overallLastYear,
    bool captain = false,
    double? formRating,
    double? careerRating,
  }) => (
    playerId: playerId,
    name: name,
    age: age,
    overall: overall,
    position: position,
    caps: caps,
    available: available,
    inXi: inXi,
    gamesSinceGoal: gamesSinceGoal,
    lastRating: lastRating,
    overallLastYear: overallLastYear,
    captain: captain,
    formRating: formRating,
    careerRating: careerRating,
  );

  Set<PressTopic> topicsOf(List<SquadMan> squad) => {
    for (final s in SquadStories.read(squad)) s.topic,
  };

  SquadStory? storyOf(List<SquadMan> squad, PressTopic topic) =>
      SquadStories.read(squad).where((s) => s.topic == topic).firstOrNull;

  group('the striker who cannot score', () {
    test('is asked about, by name and by number', () {
      final story = storyOf([
        man(
          position: PlayerPosition.st,
          gamesSinceGoal: 8,
          caps: 20,
          name: 'Arbeloa',
        ),
      ], PressTopic.strikerDrought);
      expect(story?.name, 'Arbeloa');
      expect(story?.count, 8, reason: 'the number is half the question');
    });

    test('is not asked about after a couple of quiet games', () {
      expect(
        topicsOf([man(position: PlayerPosition.st, gamesSinceGoal: 2)]),
        isNot(contains(PressTopic.strikerDrought)),
      );
    });

    test('is not asked about when nobody expects goals from him yet', () {
      expect(
        topicsOf([
          man(
            position: PlayerPosition.st,
            gamesSinceGoal: 10,
            caps: SquadStories.droughtCaps - 1,
          ),
        ]),
        isNot(contains(PressTopic.strikerDrought)),
      );
    });

    test('is not asked about when he is not in the side', () {
      expect(
        topicsOf([
          man(
            position: PlayerPosition.st,
            gamesSinceGoal: 10,
            inXi: false,
          ),
        ]),
        isNot(contains(PressTopic.strikerDrought)),
      );
    });

    test('is the first-choice forward, not whichever came first', () {
      // Both up front and both in a drought; the question is about the man the
      // country expects goals from.
      final story = storyOf([
        man(
          playerId: 1,
          name: 'Squires',
          overall: 68,
          position: PlayerPosition.st,
          gamesSinceGoal: 9,
        ),
        man(
          playerId: 2,
          name: 'Molina',
          overall: 82,
          position: PlayerPosition.st,
          gamesSinceGoal: 9,
        ),
      ], PressTopic.strikerDrought);
      expect(story?.name, 'Molina');
    });
  });

  group('a breakthrough', () {
    test('fires for a young man who has just played out of his skin', () {
      final story = storyOf([
        man(age: 19, caps: 4, lastRating: 8.4, name: 'Okonkwo'),
      ], PressTopic.youngsterBreakthrough);
      expect(story?.name, 'Okonkwo');
      expect(story?.count, 19);
    });

    test('does not fire for a good game from a senior man', () {
      expect(
        topicsOf([man(age: 29, caps: 40, lastRating: 8.6)]),
        isNot(contains(PressTopic.youngsterBreakthrough)),
      );
    });

    test('does not fire for a young man who had an ordinary night', () {
      expect(
        topicsOf([man(age: 19, caps: 4, lastRating: 6.9)]),
        isNot(contains(PressTopic.youngsterBreakthrough)),
      );
    });

    test('never describes the same man as a debutant', () {
      // A first cap is its own question, and the two must not both be live
      // about one player: the room would ask the wrong one half the time.
      final topics = topicsOf([man(age: 19, caps: 1, lastRating: 8.8)]);
      expect(topics, contains(PressTopic.debutant));
      expect(topics, isNot(contains(PressTopic.youngsterBreakthrough)));
    });
  });

  group('a dropped star', () {
    test('is a question when he is visibly better than the XI', () {
      final story = storyOf([
        man(playerId: 1, overall: 64),
        man(playerId: 2, overall: 66),
        man(playerId: 3, name: 'Ferreira', overall: 80, inXi: false),
      ], PressTopic.droppedStar);
      expect(story?.name, 'Ferreira');
      expect(story?.count, 80);
    });

    test('is not a question when he is simply the next man', () {
      expect(
        topicsOf([
          man(playerId: 1, overall: 70),
          man(playerId: 2, overall: 72, inXi: false),
        ]),
        isNot(contains(PressTopic.droppedStar)),
      );
    });

    test('is not a question about a striker outrating a goalkeeper', () {
      // The comparison that fired in week one of a brand-new save.
      expect(
        topicsOf([
          man(playerId: 1, overall: 62, position: PlayerPosition.gk),
          man(
            playerId: 2,
            overall: 78,
            position: PlayerPosition.st,
            inXi: false,
          ),
        ]),
        isNot(contains(PressTopic.droppedStar)),
      );
    });

    test('is not a question about a centre-half outrating a full-back', () {
      // The same fault one level down, and the reason the comparison is by
      // POSITION rather than by line: a shape asks for one left-back, and a
      // country's spare centre-half outrates him almost everywhere.
      expect(
        topicsOf([
          man(playerId: 1, overall: 63, position: PlayerPosition.lb),
          man(playerId: 2, overall: 74, position: PlayerPosition.cb),
          man(
            playerId: 3,
            overall: 72,
            position: PlayerPosition.cb,
            inXi: false,
          ),
        ]),
        isNot(contains(PressTopic.droppedStar)),
      );
    });

    test('is not a question when he could not have played', () {
      expect(
        topicsOf([
          man(playerId: 1, overall: 64),
          man(playerId: 2, overall: 84, inXi: false, available: false),
        ]),
        isNot(contains(PressTopic.droppedStar)),
      );
    });

    test('is not a question before an XI has been named', () {
      expect(
        topicsOf([man(playerId: 1, overall: 84, inXi: false)]),
        isNot(contains(PressTopic.droppedStar)),
      );
    });
  });

  group('the armband', () {
    test('is questioned when the captain has lost his form', () {
      final story = storyOf([
        man(
          name: 'Kaltenbach',
          captain: true,
          caps: 61,
          formRating: 6.1,
          careerRating: 7.2,
        ),
      ], PressTopic.captaincyQuestion);
      expect(story?.name, 'Kaltenbach');
      expect(story?.count, 61);
    });

    test('is not questioned while he is playing to his own level', () {
      expect(
        topicsOf([
          man(captain: true, caps: 61, formRating: 7.1, careerRating: 7.2),
        ]),
        isNot(contains(PressTopic.captaincyQuestion)),
      );
    });

    test('is not questioned when nobody is wearing it', () {
      expect(
        topicsOf([man(caps: 61, formRating: 6.0, careerRating: 7.2)]),
        isNot(contains(PressTopic.captaincyQuestion)),
      );
    });
  });

  group('a career ending', () {
    test('is a question for a veteran whose level has visibly gone', () {
      final story = storyOf([
        man(name: 'Okoye', age: 35, caps: 90, overall: 74, overallLastYear: 79),
      ], PressTopic.veteranEnd);
      expect(story?.name, 'Okoye');
      expect(story?.count, 35);
    });

    test('is not a question while he is holding his level', () {
      expect(
        topicsOf([
          man(age: 35, caps: 90, overall: 79, overallLastYear: 79),
        ]),
        isNot(contains(PressTopic.veteranEnd)),
      );
    });

    test('is not a question about a thirty-four-year-old with two caps', () {
      expect(
        topicsOf([
          man(age: 35, caps: 2, overall: 60, overallLastYear: 66),
        ]),
        isNot(contains(PressTopic.veteranEnd)),
      );
    });

    test('is not a question about a man in his twenties', () {
      expect(
        topicsOf([
          man(age: 27, caps: 90, overall: 74, overallLastYear: 79),
        ]),
        isNot(contains(PressTopic.veteranEnd)),
      );
    });
  });

  group('a debut', () {
    test('is asked about when the cap was won on Saturday', () {
      final story = storyOf([
        man(name: 'Lindqvist', age: 18, caps: 1, lastRating: 6.4),
      ], PressTopic.debutant);
      expect(story?.name, 'Lindqvist');
      expect(story?.count, 18);
    });

    test('is not asked about for a one-cap man who did not play', () {
      expect(
        topicsOf([man(age: 18, caps: 1)]),
        isNot(contains(PressTopic.debutant)),
      );
    });

    test('is not asked about for a second cap', () {
      expect(
        topicsOf([man(age: 18, caps: 2, lastRating: 6.4)]),
        isNot(contains(PressTopic.debutant)),
      );
    });
  });

  group('the next opponent', () {
    List<OpponentStory> read({
      int? next = 9,
      int? rival,
      int rivalMeetings = 0,
      List<int> results = const [],
      int? knockedOut,
    }) => OpponentStories.read(
      nextOpponentId: next,
      rivalId: rival,
      rivalMeetings: rivalMeetings,
      results: results,
      knockedUsOutId: knockedOut,
    );

    test('says nothing when there is no next match', () {
      expect(read(next: null, rival: 9, rivalMeetings: 9), isEmpty);
    });

    test('is a rivalry when it is the side you have played most', () {
      final story = read(rival: 9, rivalMeetings: 7).single;
      expect(story.topic, PressTopic.rivalryNext);
      expect(story.nationId, 9);
      expect(story.count, 7);
    });

    test('is not a rivalry when your rival is somebody else', () {
      expect(
        read(rival: 4, rivalMeetings: 9).map((s) => s.topic),
        isNot(contains(PressTopic.rivalryNext)),
      );
    });

    test('is not a rivalry on three meetings', () {
      expect(
        read(rival: 9, rivalMeetings: 3).map((s) => s.topic),
        isNot(contains(PressTopic.rivalryNext)),
      );
    });

    test('an unbeaten run reads in the manager favour', () {
      final story = read(results: const [1, 0, 1, 1, -1]).single;
      expect(story.topic, PressTopic.headToHeadRun);
      expect(story.count, 4);
      expect(story.favourable, isTrue);
    });

    test('a winless run reads the other way', () {
      final story = read(results: const [-1, 0, -1, -1, 1]).single;
      expect(story.topic, PressTopic.headToHeadRun);
      expect(story.count, 4);
      expect(story.favourable, isFalse);
    });

    test('a run of draws is the sharper of the two questions', () {
      // Both readings are true at once. The room asks the one worth asking.
      final story = read(results: const [0, 0, 0, 0]).single;
      expect(story.favourable, isFalse);
    });

    test('a run that ended last time is not a run', () {
      // Beaten in the most recent meeting, unbeaten in the four before it.
      expect(
        read(results: const [-1, 1, 1, 1, 1]).map((s) => s.topic),
        isNot(contains(PressTopic.headToHeadRun)),
      );
    });

    test('three meetings is not yet a run', () {
      expect(
        read(results: const [1, 1, 1]).map((s) => s.topic),
        isNot(contains(PressTopic.headToHeadRun)),
      );
    });

    test('the side that put you out is a question of its own', () {
      final story = read(knockedOut: 9).single;
      expect(story.topic, PressTopic.revengeMatch);
      expect(story.nationId, 9);
    });

    test('and somebody else putting you out is not', () {
      expect(read(knockedOut: 3), isEmpty);
    });
  });
}
